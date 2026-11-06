#!/usr/bin/env python3
"""Guards: Admin #382 continuity schema, recovery and truthful handover gates.

These tests exercise only the governance validator, not Pilot product coverage.
"""
import copy
from datetime import datetime, timezone
import importlib.util
import json
from pathlib import Path
import sys
import unittest

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location("controller_state", HERE / "validate-controller-state.py")
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
SCHEMA = json.loads(module.DEFAULT_SCHEMA.read_text())
NOW = datetime(2026, 11, 6, 12, 0, tzinfo=timezone.utc)
STAMP = "2026-11-06T11:00:00Z"


def checkpoint():
    handover = {key: f"Recorded {key}." for key in module.HANDOVER_FIELDS}
    handover.update(path="docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md", section="Controller handover")
    state = {
        "schema_version": "1.0.0", "checkpoint_id": "CP-382-001", "created_at": STAMP,
        "display_timezone": "Australia/Melbourne", "execution_id": "EXEC-382-001", "trigger": "reconciliation",
        "controller": {
            "candidate": "Codex", "owner": None, "previous_owner": "Claude", "status": "reconciliation",
            "environment": "unit-test", "session_id": "EXEC-382-001", "ownership_started_at": None,
            "last_heartbeat_at": None, "lease_expires_at": None, "ownership_ref": None, "ownership_commit": None,
            "mode": "read_only_reconciliation", "successor": None,
            "transfer": {"status": "none", "requested_at": None, "accepted_at": None, "verified_at": None,
                         "completed_at": None, "accepted_by": None},
            "in_flight_operations": []},
        "production": {
            "verification_status": "unknown", "worker": {"version": None, "deployment_commit": None,
                "verified_at": None, "evidence_ids": []},
            "migrations": {"status": "unknown", "head": None, "applied_versions": [], "verified_at": None, "evidence_ids": []},
            "function_hashes": [], "scheduled_jobs": {"status": "unknown", "evidence_ids": []},
            "settings": {"status": "unknown", "evidence_ids": []}, "feature_flags": {"status": "unknown", "evidence_ids": []},
            "incidents": [], "restrictions": ["No production mutations pending reconciliation."], "checkpoint_at": None},
        "workstreams": [], "prs": [], "releases": [], "measurements": [], "integration_issues": [],
        "pending_decisions": [], "blockers": [], "next_actions": [], "evidence": [],
        "continuity": {"last_completed_atomic_action": None, "current_action": "Reconcile ownership.",
            "next_safe_action": "Read live state.", "retry_or_rollback": [], "must_not_repeat": [],
            "verification_required": ["Verify active workflows."], "predecessor_checkpoint": None, "successor_checkpoint": None},
        "handover": handover}
    text = "## Controller handover\n\n" + "\n\n".join(
        f"<!-- controller-handover:{key} -->\n{handover[key]}" for key in module.HANDOVER_FIELDS)
    return state, text


class ControllerStateTests(unittest.TestCase):
    def setUp(self):
        self.state, self.text = checkpoint()

    def check(self, release=False):
        return module.validate(self.state, SCHEMA, self.text, release_ready=release, now=NOW)

    def test_reconciliation_preserves_unknown_facts_without_claiming_acceptance(self):
        self.assertEqual(self.check(), [])
        self.assertTrue(self.check(release=True))

    def test_schema_rejects_missing_required_and_unrecognised_fields(self):
        del self.state["production"]
        self.state["secret"] = "must not be stored"
        errors = " ".join(self.check())
        self.assertIn("required", errors)
        self.assertIn("Additional properties", errors)

    def test_checkpoint_requires_valid_utc_and_melbourne_display(self):
        for value in ("2026-11-06T11:00:00+00:00", "2026-11-06T11:00:00", "2026-02-30T11:00:00Z"):
            with self.subTest(value=value):
                self.state["created_at"] = value
                self.assertTrue(self.check())
        self.state["created_at"] = STAMP
        self.state["display_timezone"] = "UTC"
        self.assertTrue(self.check())

    def test_future_checkpoint_is_not_an_actual_execution(self):
        self.state["created_at"] = "2026-11-07T00:00:00Z"
        self.assertIn("future", " ".join(self.check()))

    def test_duplicate_evidence_ids_are_refused(self):
        item = {"id": "EV-1", "reference": "https://github.com/msinghbs-ai/Coursefinder-Pilot/actions/runs/1",
                "kind": "workflow", "observed_at": STAMP, "summary": "Test evidence."}
        self.state["evidence"] = [item, copy.deepcopy(item)]
        self.assertIn("duplicate stable", " ".join(self.check()))

    def test_missing_evidence_and_workstream_references_are_refused(self):
        self.state["production"]["worker"]["evidence_ids"] = ["EV-missing"]
        self.state["measurements"] = [{"id": "M-1", "workstream_id": "WS-missing", "name": "Queue",
            "value": None, "unit": "items", "measured_at": None, "status": "unknown", "evidence_ids": []}]
        errors = " ".join(self.check())
        self.assertIn("unknown evidence", errors)
        self.assertIn("unknown workstream", errors)

    def test_transfer_cannot_be_completed_without_successor_acceptance(self):
        self.state["controller"]["transfer"]["status"] = "completed"
        self.assertIn("acceptance", " ".join(self.check()))

    def test_transfer_requires_verification_and_chronological_timestamps(self):
        self.state["controller"]["transfer"] = {
            "status": "completed", "requested_at": "2026-11-06T11:30:00Z", "accepted_at": STAMP,
            "verified_at": None, "completed_at": "2026-11-06T11:45:00Z", "accepted_by": "Claude"}
        errors = " ".join(self.check())
        self.assertIn("verification timestamp", errors)
        self.assertIn("out of order", errors)

    def test_handover_requires_all_fields_in_the_canonical_section(self):
        self.text = self.text.replace("<!-- controller-handover:decisions -->", "")
        self.assertIn("decisions", " ".join(self.check()))
        self.state, self.text = checkpoint()
        self.text = self.text.replace("## Controller handover", "## Historical handover")
        self.assertIn("expected exactly one", " ".join(self.check()))

    def test_empty_handover_field_is_refused(self):
        self.text = self.text.replace("Recorded reason.", "")
        self.assertIn("field reason is empty", " ".join(self.check()))

    def test_handover_and_checkpoint_cannot_publish_conflicting_baselines(self):
        self.text = self.text.replace("Recorded baseline.", "An older production release.")
        self.assertIn("field baseline conflicts", " ".join(self.check()))
        self.state, self.text = checkpoint()
        self.text = self.text.replace("Recorded baseline.", "Recorded\n   baseline.")
        self.assertEqual(self.check(), [])

    def test_active_owner_requires_atomic_ownership_evidence(self):
        self.state["controller"]["status"] = "active"
        self.assertIn("atomic ownership evidence", " ".join(self.check()))

    def test_heartbeat_cannot_claim_a_later_execution(self):
        self.state["controller"]["last_heartbeat_at"] = "2026-11-06T11:30:00Z"
        self.assertIn("later than the actual checkpoint", " ".join(self.check()))

    def test_checkpoint_predecessor_is_not_a_self_reference(self):
        self.state["continuity"]["predecessor_checkpoint"] = self.state["checkpoint_id"]
        self.assertIn("refer to itself", " ".join(self.check()))

    def make_verified(self):
        self.state["evidence"] = [{"id": "EV-live", "reference": "https://github.com/msinghbs-ai/Coursefinder-Pilot/actions/runs/1",
            "kind": "live_verification", "observed_at": STAMP, "summary": "Synthetic test verification."}]
        self.state["controller"].update(owner="Codex", status="active", ownership_started_at=STAMP,
            last_heartbeat_at=STAMP, lease_expires_at="2026-11-06T13:00:00Z",
            ownership_ref="refs/heads/controller-ownership", ownership_commit="a" * 40)
        production = self.state["production"]
        production["verification_status"] = "verified"
        production["worker"].update(version="v2.15.test", deployment_commit="b" * 40, verified_at=STAMP, evidence_ids=["EV-live"])
        production["migrations"].update(status="verified", head="20261106000000", verified_at=STAMP, evidence_ids=["EV-live"])
        for key in ("scheduled_jobs", "settings", "feature_flags"):
            production[key].update(status="verified", evidence_ids=["EV-live"])

    def test_release_gate_accepts_only_verified_known_baseline_and_valid_lease(self):
        self.make_verified()
        self.assertEqual(self.check(release=True), [])
        self.state["controller"]["lease_expires_at"] = STAMP
        self.assertIn("expired", " ".join(self.check(release=True)))

    def test_release_gate_blocks_inflight_unknown_and_pending_release_decisions(self):
        self.make_verified()
        self.state["controller"]["in_flight_operations"] = [{"id": "OP-1", "kind": "deployment", "state": "unknown", "started_at": None, "evidence_ids": []}]
        self.state["pending_decisions"] = [{"id": "D-1", "status": "pending", "summary": "Release held.", "authority": "Platform Admin", "required_for": ["release"], "evidence_ids": []}]
        errors = " ".join(self.check(release=True))
        self.assertIn("in-flight", errors)
        self.assertIn("outstanding human decision", errors)

    def test_scoped_gate_preserves_unrelated_blockers_without_blocking_independent_work(self):
        self.make_verified()
        self.state["workstreams"] = [{"id": "WS-safe", "issue_ref": "Admin #382", "owner": "Codex",
            "branch": "safe", "commit": "c" * 40, "worktree": None, "state": "verifying",
            "owned_paths": [], "owned_functions": [], "owned_migrations": [],
            "acceptance_criteria": ["Verified"], "dependencies": [], "blockers": [],
            "test_evidence_ids": [], "completion_summary": None}]
        self.state["pending_decisions"] = [{"id": "D-held", "status": "pending", "summary": "Unrelated API hold",
            "authority": "Platform Admin", "required_for": ["PR-890"], "evidence_ids": []}]
        self.state["workstreams"].append(dict(self.state["workstreams"][0], id="WS-held", branch="held"))
        self.state["blockers"] = [{"id": "B-held", "summary": "Unrelated held issue", "owner": "Admin",
            "workstream_ids": ["WS-held"], "next_action": "Resolve", "evidence_ids": []}]
        # Retain unrelated decisions and blockers in the canonical state.
        self.assertEqual(module.validate(self.state, SCHEMA, self.text, True, NOW, "WS-safe"), [])
        self.state["blockers"][0]["workstream_ids"] = ["WS-safe"]
        # A blocker in this release's scope still refuses it.
        errors = module.validate(self.state, SCHEMA, self.text, True, NOW, "WS-safe")
        self.assertIn("recorded blockers", " ".join(errors))
        self.assertNotIn("human decision", " ".join(errors))
        self.state["blockers"] = []
        self.assertEqual(module.validate(self.state, SCHEMA, self.text, True, NOW, "WS-safe"), [])
        self.assertTrue(module.validate(self.state, SCHEMA, self.text, True, NOW, "WS-unknown"))


if __name__ == "__main__":
    unittest.main()
