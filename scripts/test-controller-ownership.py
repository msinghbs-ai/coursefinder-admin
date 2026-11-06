#!/usr/bin/env python3
"""Guards: Admin #382 §§7–9, CAS, exclusive ownership and expiry-safe recovery."""
import copy
import importlib.util
import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from concurrent.futures import ThreadPoolExecutor

spec = importlib.util.spec_from_file_location('ownership', Path(__file__).with_name('controller-ownership.py'))
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)
AT = '2026-11-06T09:00:00Z'


def event(kind, execution='codex-test', **payload):
    return dict(id='event-' + execution + '-' + kind, kind=kind, execution_id=execution, at=AT,
                evidence_refs=['https://github.com/msinghbs-ai/coursefinder-admin/issues/382'], payload=payload)


def active():
    s = m.initial('codex-test', AT)
    s = m.transition(s, event('reconcile'))
    s = m.transition(s, event('record_predecessor_release', release_ref='verified-release-evidence', handover_ref='verified-handover'))
    s = m.transition(s, event('adopt', all_production_entrypoints_fenced=True))
    s = m.transition(s, event('accept', identity='Codex', environment='test', lease_expires_at='2026-11-06T10:00:00Z'))
    s = m.transition(s, event('verify_transfer'))
    return m.transition(s, event('complete_transfer'))


class OwnershipTests(unittest.TestCase):
    def test_initial_reconciliation_refuses_production(self):
        with self.assertRaisesRegex(ValueError, 'not active'):
            m.guard(m.initial('codex-test', AT), 'codex-test', AT)

    def test_takeover_cannot_use_expiry_or_missing_release(self):
        s = m.initial('codex-test', AT)
        s = m.transition(s, event('reconcile'))
        with self.assertRaisesRegex(ValueError, 'predecessor release'):
            m.transition(s, event('accept', identity='Codex', environment='test', lease_expires_at='2026-11-06T10:00:00Z'))

    def test_unknown_fencing_blocks_transfer_verification(self):
        s = active()
        s['adoption']['status'] = 'pending'
        with self.assertRaisesRegex(ValueError, 'adoption'):
            m.guard(s, 'codex-test', AT)

    def test_other_execution_cannot_begin_or_renew(self):
        for kind in ['begin', 'heartbeat']:
            with self.assertRaisesRegex(ValueError, 'different execution'):
                m.transition(active(), event(kind, execution='other', operation_id='op', operation_kind='write',
                    approval_ref='approved', checkpoint_ref='before', lease_expires_at='2026-11-06T10:00:00Z'))

    def test_operation_survives_expiry_and_blocks_transfer(self):
        s = m.transition(active(), event('begin', operation_id='release-immutable-1', operation_kind='release',
                         approval_ref='approval', checkpoint_ref='before'))
        with self.assertRaisesRegex(ValueError, 'in-flight'):
            m.transition(s, event('request_transfer', successor_execution_id='claude-test'))
        late = event('finish', operation_id='release-immutable-1', outcome='committed', checkpoint_ref='after')
        late['at'] = '2026-11-06T11:00:00Z'
        result = m.transition(s, late)
        self.assertIsNone(result['in_flight'])
        self.assertEqual(result['last_operation']['id'], 'release-immutable-1')
        with self.assertRaisesRegex(ValueError, 'expired'):
            m.guard(result, 'codex-test', late['at'])

    def test_idempotency_and_wrong_operation(self):
        s = active()
        e = event('begin', operation_id='op-1', operation_kind='write', approval_ref='approval', checkpoint_ref='before')
        s = m.transition(s, e)
        self.assertEqual(s, m.transition(s, e))
        with self.assertRaisesRegex(ValueError, 'matching owner/operation'):
            m.transition(s, event('finish', operation_id='op-2', outcome='committed', checkpoint_ref='after'))
        with self.assertRaisesRegex(ValueError, 'already in flight'):
            m.transition(s, dict(e, id='other-begin'))

    def test_transfer_is_accepted_by_successor_only(self):
        s = m.transition(active(), event('request_transfer', successor_execution_id='claude-test'))
        s = m.transition(s, event('publish_transfer', release_ref='outgoing-release', handover_ref='handover'))
        with self.assertRaisesRegex(ValueError, 'wrong successor'):
            m.transition(s, event('accept', execution='third', identity='Third', environment='test',
                                   lease_expires_at='2026-11-06T10:00:00Z'))
        s = m.transition(s, dict(event('reconcile', execution='claude-test'), id='incoming-reconciliation'))
        s = m.transition(s, dict(event('accept', execution='claude-test', identity='Claude', environment='test',
                                       lease_expires_at='2026-11-06T10:00:00Z'), id='incoming-accept'))
        self.assertEqual(s['transfer']['status'], 'accepted')
        self.assertEqual(s['generation'], 2)
        self.assertEqual(s['status'], 'reconciliation')

    def test_non_owner_cannot_retarget_prepared_transfer(self):
        s = m.transition(active(), event('request_transfer', successor_execution_id='claude-test'))
        with self.assertRaisesRegex(ValueError, 'only owner'):
            m.transition(s, event('request_transfer', execution='intruder', successor_execution_id='intruder'))

    def test_expired_owner_recovery_requires_stopped_execution_and_terminal_proof(self):
        s = active()
        e = event('recover_release', execution='new-session', predecessor_stop_ref='verified-stopped',
                  terminal_evidence_ref='live-terminal-proof', handover_ref='verified-handover')
        e['at'] = '2026-11-06T11:00:00Z'
        with self.assertRaisesRegex(ValueError, 'reconcile live state after expiry'):
            m.transition(s, e)
        rec = dict(event('reconcile', execution='new-session'), at=e['at'])
        s = m.transition(s, rec)
        with self.assertRaisesRegex(ValueError, 'predecessor termination'):
            m.transition(s, e)
        e['payload'] = dict(predecessor_execution_stopped=True, predecessor_stop_ref='verified-stopped',
                            all_critical_operations_terminal=True, terminal_evidence_ref='live-terminal-proof',
                            handover_ref='verified-handover')
        result = m.transition(s, e)
        self.assertEqual(result['status'], 'released')
        self.assertEqual(result['transfer']['to'], 'new-session')
        self.assertEqual(result['transfer']['status'], 'published')

    def test_empty_operation_and_transfer_id_are_refused(self):
        for e in (event('begin', operation_id='', operation_kind='write', approval_ref='approval', checkpoint_ref='before'),
                  event('request_transfer', successor_execution_id=''), dict(event('reconcile'), evidence_refs='not-a-list')):
            with self.assertRaises(ValueError):
                m.transition(active(), e)

    def test_git_server_atomic_cas_has_exactly_one_winner(self):
        # Exercise nonforced server fast-forward pushes, the same ancestry
        # rule as REST, rather than relying only on update-ref's stronger CAS.
        with tempfile.TemporaryDirectory() as d:
            def git(*args, data=None, check=True):
                r = subprocess.run(['git', '-C', d, '-c', 'user.name=Continuity test',
                                    '-c', 'user.email=continuity-test@example.invalid', *args],
                                   input=data, text=True, capture_output=True)
                if check and r.returncode:
                    raise RuntimeError(r.stderr)
                return r.stdout.strip() if check else r.returncode
            git('init', '--bare', '.')
            tree = git('mktree', data='')
            base = git('commit-tree', tree, data='base\n')
            ref = 'refs/heads/studysearch-controller'
            git('update-ref', ref, base)
            children = [git('commit-tree', tree, '-p', base, data='contender ' + str(i)) for i in range(2)]
            with ThreadPoolExecutor(max_workers=2) as pool:
                results = list(pool.map(lambda head: git('push', d, head + ':' + ref, check=False), children))
            self.assertEqual(sum(code == 0 for code in results), 1)
            winner = git('rev-parse', ref)
            loser = next(x for x in children if x != winner)
            self.assertNotEqual(git('merge-base', '--is-ancestor', winner, loser, check=False), 0)


if __name__ == '__main__':
    unittest.main()
