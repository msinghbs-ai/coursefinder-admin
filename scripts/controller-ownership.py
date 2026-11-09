#!/usr/bin/env python3
"""RETIRED 9 Nov 2026 (Platform Admin sole-controller decision): historical audit tooling only; no workflow runs it and nothing may rely on it as a release prerequisite. Original guard follows. Guards: Admin #382, exclusive controller ownership and interrupted recovery.

GitHub is the durable store. CAS is a one-parent commit followed by a non-forced
fast-forward ref update. Concurrent sibling commits cannot both win. This tool
does not grant production approval or make non-participating writers safe.
"""
import argparse
import copy
import json
import subprocess
import sys
from datetime import datetime, timezone

REPOSITORY = 'msinghbs-ai/coursefinder-admin'
BRANCH = 'studysearch-controller'
STATE_PATH = 'controller.json'


def utc(value):
    if not isinstance(value, str) or not value.endswith('Z'):
        raise ValueError('UTC timestamp with Z required')
    return datetime.fromisoformat(value[:-1] + '+00:00')


def timestamp():
    return datetime.now(timezone.utc).isoformat(timespec='seconds').replace('+00:00', 'Z')


def initial(execution_id, at):
    utc(at)
    return dict(schema_version='1.0.0', coordination_id='studysearch-integration-controller',
                status='reconciliation', generation=0, owner=None, heartbeat_at=None,
                lease_expires_at=None, transfer={'status': 'pending', 'to': execution_id,
                'predecessor': 'Claude', 'release_ref': None}, in_flight=None,
                last_event=None, event_ids=[], updated_at=at,
                adoption={'status': 'pending', 'evidence_refs': []},
                reconciliation={'status': 'required', 'evidence_refs': []})


def guard(state, execution_id, now, allow_in_flight=False):
    if state['status'] != 'active' or not state.get('owner'):
        raise ValueError('exclusive controller ownership is not active')
    if state['owner']['execution_id'] != execution_id:
        raise ValueError('different execution owns control')
    if not state.get('lease_expires_at') or utc(state['lease_expires_at']) <= utc(now):
        raise ValueError('lease expired; reconcile, never take over on expiry alone')
    if state['adoption']['status'] != 'verified':
        raise ValueError('production entry-point adoption has not been verified')
    if state['reconciliation']['status'] != 'verified':
        raise ValueError('live reconciliation required')
    if state.get('in_flight') and not allow_in_flight:
        raise ValueError('an operation is already in flight; reconcile its immutable id')


def transition(current, event):
    """Pure transition, applied once by id; callers must CAS the returned state."""
    for key in ('id', 'kind', 'execution_id', 'at', 'evidence_refs'):
        if key not in event:
            raise ValueError('event missing ' + key)
    if not all(isinstance(event[k], str) and event[k].strip() for k in ('id', 'kind', 'execution_id', 'at')):
        raise ValueError('nonempty string event identity and timestamp required')
    if not isinstance(event['evidence_refs'], list) or not event['evidence_refs'] or not all(isinstance(x, str) and x.strip() for x in event['evidence_refs']):
        raise ValueError('attributable event id, execution and evidence required')
    utc(event['at'])
    if event['id'] in current['event_ids']:
        # Only the exact event can be replayed idempotently; no mutation.
        if event == current.get('last_event'):
            return copy.deepcopy(current)
        raise ValueError('event id already used; inspect history, do not replay')
    if utc(event['at']) < utc(current['updated_at']):
        raise ValueError('event time predates current state')
    s = copy.deepcopy(current)
    kind, actor = event['kind'], event['execution_id']
    p = event.get('payload', {})
    required_payload = {
        'request_transfer': ('successor_execution_id',),
        'publish_transfer': ('release_ref', 'handover_ref'),
        'record_predecessor_release': ('release_ref', 'handover_ref'),
        'recover_release': ('predecessor_stop_ref', 'terminal_evidence_ref', 'handover_ref'),
        'accept': ('identity', 'environment', 'lease_expires_at'),
        'heartbeat': ('lease_expires_at',),
        'begin': ('operation_id', 'operation_kind', 'approval_ref', 'checkpoint_ref'),
        'finish': ('operation_id', 'outcome', 'checkpoint_ref'),
    }
    if not isinstance(p, dict):
        raise ValueError('event payload must be an object')
    for key in required_payload.get(kind, ()):
        if not isinstance(p.get(key), str) or not p[key].strip():
            raise ValueError('nonempty payload field required: ' + key)
    is_owner = bool(s.get('owner') and s['owner']['execution_id'] == actor)
    if kind == 'request_transfer':
        if s.get('in_flight'):
            raise ValueError('record in-flight result before transfer')
        if s.get('owner') and not is_owner:
            raise ValueError('only owner may prepare transfer; publish request in issue')
        s['transfer'] = {'status': 'prepared', 'to': p['successor_execution_id'],
                         'predecessor': s.get('owner'), 'release_ref': None,
                         'prepared_at': event['at']}
        s['status'] = 'reconciliation'
    elif kind == 'publish_transfer':
        if s['transfer']['status'] != 'prepared' or not is_owner:
            raise ValueError('owner must prepare transfer first')
        if s.get('in_flight'):
            raise ValueError('in-flight operation blocks release')
        s['transfer'].update(status='published', published_at=event['at'],
                             release_ref=p['release_ref'], handover_ref=p['handover_ref'])
        s['status'] = 'released'
        s['lease_expires_at'] = event['at']
    elif kind == 'record_predecessor_release':
        # Bootstrap/recovery path only. An expired lease is never release proof.
        if s.get('owner') or s.get('in_flight') or s['status'] != 'reconciliation':
            raise ValueError('existing owner/operation requires its normal transfer protocol')
        if s['reconciliation']['status'] != 'verified' or not p.get('release_ref'):
            raise ValueError('verified live reconciliation and explicit predecessor release required')
        s['transfer'].update(status='published', release_ref=p['release_ref'],
                             handover_ref=p['handover_ref'], published_at=event['at'])
        s['status'] = 'released'
    elif kind == 'recover_release':
        # A new execution may recover an interrupted owner only after both the
        # old execution and every critical operation have verified terminal
        # evidence. Expiry is necessary here, never sufficient.
        if not s.get('owner') or not s.get('lease_expires_at') or utc(s['lease_expires_at']) > utc(event['at']):
            raise ValueError('recovery requires an expired recorded owner')
        rec = s['reconciliation']
        if rec['status'] != 'verified' or rec.get('verified_by') != actor or utc(rec['verified_at']) < utc(s['lease_expires_at']):
            raise ValueError('successor must reconcile live state after expiry')
        if p.get('predecessor_execution_stopped') is not True or not p.get('predecessor_stop_ref'):
            raise ValueError('verified predecessor termination/revocation required')
        if p.get('all_critical_operations_terminal') is not True or not p.get('terminal_evidence_ref'):
            raise ValueError('all workflows and writes require terminal proof')
        if s.get('in_flight'):
            if p.get('operation_id') != s['in_flight']['id'] or not p.get('post_checkpoint_ref'):
                raise ValueError('matching in-flight terminal checkpoint required')
            s['last_operation'] = dict(s['in_flight'], outcome='recovered',
                finished_at=event['at'], terminal_evidence_refs=event['evidence_refs'],
                post_checkpoint_ref=p['post_checkpoint_ref'])
            s['in_flight'] = None
        s['transfer'] = {'status': 'published', 'to': actor, 'predecessor': s['owner'],
            'release_ref': p['predecessor_stop_ref'], 'handover_ref': p['handover_ref'],
            'published_at': event['at'], 'recovery_evidence_refs': event['evidence_refs']}
        s['status'] = 'released'
    elif kind == 'reconcile':
        # This records evidence, not a takeover. Never clears an in-flight token.
        s['reconciliation'] = {'status': 'verified', 'evidence_refs': event['evidence_refs'],
                               'verified_at': event['at'], 'verified_by': actor}
    elif kind == 'adopt':
        if s['status'] == 'active' and not is_owner:
            raise ValueError('only active owner may change adoption')
        if p.get('all_production_entrypoints_fenced') is not True:
            raise ValueError('all production entry points must participate')
        s['adoption'] = {'status': 'verified', 'evidence_refs': event['evidence_refs'],
                         'verified_at': event['at'], 'verified_by': actor}
    elif kind == 'accept':
        t = s['transfer']
        if s.get('in_flight') or t.get('to') != actor:
            raise ValueError('wrong successor or operation in flight')
        if t['status'] != 'published' or not t.get('release_ref'):
            raise ValueError('published predecessor release required; no expiry takeover')
        if s['reconciliation']['status'] != 'verified':
            raise ValueError('incoming controller must verify live state')
        if s['reconciliation'].get('verified_by') != actor:
            raise ValueError('successor must perform its own reconciliation')
        if utc(s['reconciliation']['verified_at']) < utc(t['published_at']):
            raise ValueError('successor must reconcile after transfer publication')
        expiry = p['lease_expires_at']
        if utc(expiry) <= utc(event['at']):
            raise ValueError('lease must expire in the future')
        s['owner'] = {'identity': p['identity'], 'execution_id': actor,
                      'environment': p['environment'], 'started_at': event['at']}
        s['generation'] += 1
        s['heartbeat_at'], s['lease_expires_at'] = event['at'], expiry
        s['status'] = 'reconciliation'
        t.update(status='accepted', accepted_at=event['at'], accepted_by=actor)
    elif kind == 'verify_transfer':
        if not is_owner or s['transfer']['status'] != 'accepted':
            raise ValueError('only accepted successor may verify')
        if s['adoption']['status'] != 'verified':
            raise ValueError('production fencing adoption still pending')
        s['transfer'].update(status='verified', verified_at=event['at'])
    elif kind == 'complete_transfer':
        if not is_owner or s['transfer']['status'] != 'verified':
            raise ValueError('successor verification required')
        s['transfer'].update(status='completed', completed_at=event['at'])
        s['status'] = 'active'
        guard(s, actor, event['at'])
    elif kind == 'heartbeat':
        guard(s, actor, event['at'], allow_in_flight=True)
        expiry = p['lease_expires_at']
        if utc(expiry) <= utc(event['at']):
            raise ValueError('lease must expire in the future')
        s['heartbeat_at'], s['lease_expires_at'] = event['at'], expiry
    elif kind == 'begin':
        guard(s, actor, event['at'])
        if not p.get('approval_ref') or not p.get('checkpoint_ref'):
            raise ValueError('approval and pre-write checkpoint required')
        s['in_flight'] = {'id': p['operation_id'], 'execution_id': actor,
                          'generation': s['generation'], 'kind': p['operation_kind'],
                          'started_at': event['at'], 'approval_ref': p['approval_ref'],
                          'checkpoint_ref': p['checkpoint_ref'],
                          'evidence_refs': event['evidence_refs']}
    elif kind == 'finish':
        op = s.get('in_flight')
        # Expiry never erases the lock. The original execution may record a
        # verified terminal result after expiry, but may not start more work.
        if not is_owner or not op or op['id'] != p.get('operation_id'):
            raise ValueError('only matching owner/operation may record terminal evidence')
        if p.get('outcome') not in ('committed', 'failed_before_write', 'recovered'):
            raise ValueError('unknown outcome stays in reconciliation')
        if not p.get('checkpoint_ref'):
            raise ValueError('post-write checkpoint required')
        s['last_operation'] = dict(op, outcome=p['outcome'], finished_at=event['at'],
                                   terminal_evidence_refs=event['evidence_refs'],
                                   post_checkpoint_ref=p['checkpoint_ref'])
        s['in_flight'] = None
    else:
        raise ValueError('unsupported transition: ' + kind)
    s['event_ids'].append(event['id'])
    s['last_event'], s['updated_at'] = event, event['at']
    return s


class GitHubStore:
    def __init__(self, repository=REPOSITORY, branch=BRANCH):
        self.repository, self.branch = repository, branch

    def api(self, path, method='GET', body=None):
        args = ['gh', 'api', 'repos/' + self.repository + '/' + path, '--method', method]
        if body is not None:
            args += ['--input', '-']
        r = subprocess.run(args, input=json.dumps(body) if body is not None else None,
                           text=True, capture_output=True)
        if r.returncode:
            # Do not echo CLI output, which may include private response content.
            raise RuntimeError('GitHub request failed: ' + method + ' ' + path)
        return json.loads(r.stdout)

    def read(self):
        head = self.api('git/ref/heads/' + self.branch)['object']['sha']
        import base64
        f = self.api('contents/' + STATE_PATH + '?ref=' + head)
        return head, json.loads(base64.b64decode(f['content']))

    def commit(self, parent, state):
        tree = self.api('git/trees', 'POST', {'tree': [{'path': STATE_PATH,
                        'mode': '100644', 'type': 'blob',
                        'content': json.dumps(state, indent=2) + '\n'}]})['sha']
        return self.api('git/commits', 'POST', {'message': 'Controller checkpoint ' +
                        (state.get('last_event') or {}).get('id', 'bootstrap'),
                        'tree': tree, 'parents': [parent]})['sha']

    def create(self, base, state):
        head = self.commit(base, state)
        self.api('git/refs', 'POST', {'ref': 'refs/heads/' + self.branch, 'sha': head})
        return head

    def cas(self, expected, state):
        if self.read()[0] != expected:
            raise ValueError('ownership head changed; stop and re-read')
        head = self.commit(expected, state)
        # Server ancestry check is the atomic arbiter. Never force, merge two
        # contender histories, retry a rejected write, or reparent stale state.
        self.api('git/refs/heads/' + self.branch, 'PATCH', {'sha': head, 'force': False})
        observed, saved = self.read()
        if observed != head:
            raise ValueError('ownership moved after update; authority must be rechecked')
        return observed


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=['show', 'init', 'transition', 'guard'])
    parser.add_argument('--execution-id')
    parser.add_argument('--base')
    parser.add_argument('--expected-head')
    parser.add_argument('--event')
    parser.add_argument('--operation-id')
    args = parser.parse_args()
    store = GitHubStore()
    if args.action == 'init':
        if not args.base or not args.execution_id:
            parser.error('init requires immutable --base and --execution-id')
        print(store.create(args.base, initial(args.execution_id, timestamp())))
        return
    head, state = store.read()
    if args.action == 'show':
        print(json.dumps({'head': head, 'state': state}, indent=2))
        return
    if head != args.expected_head:
        raise ValueError('exact current --expected-head required')
    if args.action == 'guard':
        guard(state, args.execution_id, timestamp(), allow_in_flight=bool(args.operation_id))
        if args.operation_id:
            op = state.get('in_flight')
            if not op or op['id'] != args.operation_id or op['execution_id'] != args.execution_id:
                raise ValueError('matching persistent operation reservation required')
        print(json.dumps({'head': head, 'generation': state['generation'],
                          'execution_id': args.execution_id, 'verified_at': timestamp()}))
    else:
        with open(args.event, encoding='utf-8') as f:
            event = json.load(f)
        # Reject backdated/future fabricated heartbeats at the execution boundary.
        if abs((utc(event['at']) - utc(timestamp())).total_seconds()) > 60:
            raise ValueError('event must belong to the current actual execution minute')
        if event['kind'] in ('heartbeat', 'begin'):
            # Attribution time cannot renew an already-expired real lease.
            guard(state, event['execution_id'], timestamp(), allow_in_flight=event['kind'] == 'heartbeat')
        new = transition(state, event)
        print(head if new == state else store.cas(head, new))


if __name__ == '__main__':
    try:
        main()
    except (ValueError, RuntimeError, KeyError, OSError) as exc:
        print('BLOCKED: ' + str(exc), file=sys.stderr)
        sys.exit(1)
