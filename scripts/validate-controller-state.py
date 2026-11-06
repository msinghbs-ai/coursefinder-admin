#!/usr/bin/env python3
"""Validate StudySearch's governed checkpoint and existing register handover.

Guards: Admin issue #382, Weekend Autonomous Integration Controller and AI
Continuity Mandate §§5–10. This validates evidence; it grants no release authority.
"""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
import json
from pathlib import Path
import re
import sys

from jsonschema import Draft202012Validator, FormatChecker

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_SCHEMA = ROOT / "docs/platform/STUDYSEARCH-CONTROLLER-STATE.schema.json"
HANDOVER_FIELDS = (
    "reason", "baseline", "completed", "priorities", "workstreams",
    "pending_prs_migrations", "decisions", "in_flight", "next_safe_action",
    "risks_recovery", "evidence",
)


def utc(value):
    return datetime.fromisoformat(value.replace("Z", "+00:00"))


def validate(state, schema, handover_text, release_ready=False, now=None):
    """Return every validation failure. Unknown live facts remain explicit ordinarily."""
    errors = []
    Draft202012Validator.check_schema(schema)
    validator = Draft202012Validator(schema, format_checker=FormatChecker())
    for error in sorted(validator.iter_errors(state), key=lambda e: str(list(e.path))):
        errors.append(f"{'.'.join(map(str, error.path)) or '$'}: {error.message}")
    if errors:
        return errors
    # jsonschema's optional RFC3339 dependency may be absent. Never let that
    # silently weaken calendar-date validation in a minimal Python environment.
    def check_dates(obj, path="$"):
        if isinstance(obj, dict):
            for key, value in obj.items():
                if key.endswith("_at") and value is not None:
                    try:
                        utc(value)
                    except (TypeError, ValueError):
                        errors.append(f"{path}.{key}: invalid UTC calendar timestamp")
                check_dates(value, f"{path}.{key}")
        elif isinstance(obj, list):
            for index, value in enumerate(obj):
                check_dates(value, f"{path}.{index}")
    check_dates(state)
    if errors:
        return errors
    now = now or datetime.now(timezone.utc)
    if utc(state["created_at"]) > now:
        errors.append("created_at: checkpoint cannot be created in the future")

    # Stable identifiers are unique within each collection, evidence globally.
    for name in ("workstreams", "prs", "releases", "measurements", "integration_issues",
                 "pending_decisions", "blockers", "next_actions", "evidence"):
        ids = [item["id"] for item in state[name]]
        if len(ids) != len(set(ids)):
            errors.append(f"{name}: duplicate stable identifiers")
    operations = state["controller"]["in_flight_operations"]
    if len({x["id"] for x in operations}) != len(operations):
        errors.append("controller.in_flight_operations: duplicate stable identifiers")
    evidence_ids = {item["id"] for item in state["evidence"]}
    workstream_ids = {item["id"] for item in state["workstreams"]}
    action_ids = {item["id"] for item in state["next_actions"]}

    def check_references(obj, path="$"):
        if isinstance(obj, dict):
            for key, value in obj.items():
                here = f"{path}.{key}"
                if key in ("evidence_ids", "test_evidence_ids"):
                    for item in value:
                        if item not in evidence_ids:
                            errors.append(f"{here}: unknown evidence {item}")
                elif key == "workstream_id" and value is not None and value not in workstream_ids:
                    errors.append(f"{here}: unknown workstream {value}")
                elif key == "workstream_ids":
                    for item in value:
                        if item not in workstream_ids:
                            errors.append(f"{here}: unknown workstream {item}")
                elif key == "depends_on" and path.startswith("$.next_actions"):
                    for item in value:
                        if item not in action_ids:
                            errors.append(f"{here}: unknown next action {item}")
                check_references(value, here)
        elif isinstance(obj, list):
            for index, value in enumerate(obj):
                check_references(value, f"{path}.{index}")

    check_references(state)
    controller = state["controller"]
    transfer = controller["transfer"]
    stages = {"none": 0, "prepared": 1, "published": 2, "accepted": 3,
              "verified": 4, "completed": 5, "pending": 1}
    if stages[transfer["status"]] >= 3:
        if not transfer["accepted_at"] or not transfer["accepted_by"]:
            errors.append("controller.transfer: accepted/completed transfer needs successor identity and acceptance timestamp")
    if stages[transfer["status"]] >= 4 and not transfer["verified_at"]:
        errors.append("controller.transfer: verified/completed transfer needs verification timestamp")
    if transfer["status"] == "completed" and not transfer["completed_at"]:
        errors.append("controller.transfer: completed transfer needs completion timestamp")
    ordered = [transfer[x] for x in ("requested_at", "accepted_at", "verified_at", "completed_at") if transfer[x]]
    if ordered != sorted(ordered, key=utc):
        errors.append("controller.transfer: transfer timestamps are out of order")
    if controller["status"] == "active" and not all(controller[x] for x in
            ("owner", "ownership_started_at", "last_heartbeat_at", "lease_expires_at", "ownership_ref", "ownership_commit")):
        errors.append("controller: active ownership requires identity, lease and atomic ownership evidence")
    heartbeat = controller["last_heartbeat_at"]
    started = controller["ownership_started_at"]
    if heartbeat and utc(heartbeat) > utc(state["created_at"]):
        errors.append("controller: heartbeat is later than the actual checkpoint")
    if heartbeat and started and utc(heartbeat) < utc(started):
        errors.append("controller: heartbeat predates ownership start")
    if controller["status"] == "active" and controller["lease_expires_at"] and utc(controller["lease_expires_at"]) <= utc(state["created_at"]):
        errors.append("controller: ownership was already expired when checkpoint was created")
    for key in ("predecessor_checkpoint", "successor_checkpoint"):
        if state["continuity"][key] == state["checkpoint_id"]:
            errors.append(f"continuity.{key}: checkpoint cannot refer to itself")
    for workstream in state["workstreams"]:
        if workstream["state"] == "completed" and not all((workstream["completion_summary"], workstream["test_evidence_ids"])):
            errors.append(f"workstreams.{workstream['id']}: completion requires summary and verification evidence")

    section_name = state["handover"]["section"]
    headings = list(re.finditer(r"(?m)^## " + re.escape(section_name) + r"\s*$", handover_text))
    if len(headings) != 1:
        errors.append(f"handover: expected exactly one '## {section_name}' section")
    else:
        section = handover_text[headings[0].end():]
        section = re.split(r"(?m)^## ", section, maxsplit=1)[0]
        for field in HANDOVER_FIELDS:
            marker = f"<!-- controller-handover:{field} -->"
            if section.count(marker) != 1:
                errors.append(f"handover: missing or duplicate field {field}")
            else:
                body = section.split(marker, 1)[1].split("<!-- controller-handover:", 1)[0]
                body = re.sub(r"<!--.*?-->", "", body, flags=re.S).strip()
                if not body:
                    errors.append(f"handover: field {field} is empty")
                elif " ".join(body.split()) != " ".join(state["handover"][field].split()):
                    errors.append(f"handover: field {field} conflicts with the machine-readable checkpoint")

    if release_ready:
        production = state["production"]
        if controller["status"] != "active" or not controller["owner"]:
            errors.append("release-ready: controller ownership is not active")
        if not controller["lease_expires_at"] or utc(controller["lease_expires_at"]) <= now:
            errors.append("release-ready: ownership lease is absent or expired")
        if operations:
            errors.append("release-ready: reconcile all in-flight operation records before a new release")
        if production["verification_status"] != "verified":
            errors.append("release-ready: production baseline is not verified")
        worker = production["worker"]
        if not all(worker[x] for x in ("version", "deployment_commit", "verified_at", "evidence_ids")):
            errors.append("release-ready: Worker version/deployment verification is unknown")
        migration = production["migrations"]
        if migration["status"] != "verified" or not all(migration[x] for x in ("head", "verified_at", "evidence_ids")):
            errors.append("release-ready: migration state is not verified")
        for key in ("scheduled_jobs", "settings", "feature_flags"):
            if production[key]["status"] != "verified" or not production[key]["evidence_ids"]:
                errors.append(f"release-ready: {key} compatibility is not verified")
        if any(x["status"] != "verified" for x in state["measurements"]):
            errors.append("release-ready: operational measurement has unknown/deferred verification")
        if any(x["status"] == "pending" and "release" in x["required_for"] for x in state["pending_decisions"]):
            errors.append("release-ready: a release requires an outstanding human decision")
        if state["blockers"]:
            errors.append("release-ready: resolve or scope out recorded blockers before release")
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("checkpoint", nargs="?", default="docs/platform/STUDYSEARCH-CONTROLLER-STATE.json")
    parser.add_argument("--schema", default=str(DEFAULT_SCHEMA))
    parser.add_argument("--handover", default="docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md")
    parser.add_argument("--release-ready", action="store_true")
    args = parser.parse_args()
    try:
        state = json.loads(Path(args.checkpoint).read_text())
        schema = json.loads(Path(args.schema).read_text())
        text = Path(args.handover).read_text()
        errors = validate(state, schema, text, args.release_ready)
    except (OSError, ValueError, TypeError, KeyError) as error:
        print(f"controller continuity: FAIL: {error}", file=sys.stderr)
        return 1
    if errors:
        print("controller continuity: FAIL\n" + "\n".join(f"- {error}" for error in errors), file=sys.stderr)
        return 1
    print(f"controller continuity: PASS {state['checkpoint_id']} ({'release-ready checks' if args.release_ready else 'record validation only; no release authority granted'})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
