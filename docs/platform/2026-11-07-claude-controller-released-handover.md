# CLAUDE CONTROLLER RELEASED: handover to Codex (Admin #382)

Recorded 2026-11-06T13:46:04Z (Melbourne: Sat 7 Nov 2026 00:5x). Author: Claude, previous Integration Controller. This record grants no release authority and claims no credential revocation.

## Platform Admin instruction (received Sat 7 Nov 2026 00:41 Melbourne, in chat; verbatim)

StudySearch — Immediate Controller Handover to Codex

Platform Admin instruction — effective immediately

Claude must relinquish its role as StudySearch Integration Controller for the weekend of 7–8 November 2026.

1. Stop initiating new development tasks, PR merges, deployments, migrations, production writes and scheduled engineering executions under Claude's control.
2. Allow any currently running critical production operation to finish safely or stop it through its documented recovery procedure. Do not interrupt a migration or transaction unsafely.
3. Identify all running, queued and scheduled Claude-controlled operations, including GitHub Actions, Cloudflare deployments, direct SQL sessions and automation tasks.
4. Specifically reconcile queued workflow "34749286102". Record whether it is running, cancelled, completed or otherwise safely disposed of.
5. Publish the final verified production baseline, active PRs, migrations, job states, outstanding issues and next safe actions in the canonical Admin execution register and controller checkpoint.
6. Record an explicit CLAUDE CONTROLLER RELEASED handover event under Admin issue #382, including timestamp, previous controller identity and evidence of all in-flight operations.
7. Release your controller ownership through the established atomic ownership mechanism, where available.
8. Do not reacquire controller ownership or initiate further production-changing operations without a new Platform Admin instruction.
9. Remain available for read-only consultation if requested by the successor, without independently modifying the platform.

Codex is the nominated successor Integration Controller.

Important: Do not claim that GitHub, Supabase or Cloudflare account credentials have been revoked unless those controls have actually been changed and independently verified.

After publishing the handover, stop execution. Codex will independently validate the release and accept ownership through Admin #382.

This instruction supersedes previous Claude autonomous development and integration mandates for the weekend.

## Previous controller identity

Claude (model claude-sonnet-5-5), Claude Code cloud session cse_01RnriTf32Hcv4Xqnq2DF1qq (https://claude.ai/code/session_01RnriTf32Hcv4Xqnq2DF1qq). Successor: Codex.

## What Claude did after the instruction (all read-only except the two documentation writes at the end)

- Started nothing new. The only production-affecting step was an attempt to cancel the queued run (below), which GitHub refused.
- Last code change before the instruction: commit 162e9fc7 on the #894 branch (test assertion only, CI green on that head). Last production change: release v2.15.489 (#877, main 4ba94e3f). Claude has made no production write since.

## Ownership mechanism (item 7)

Ref refs/heads/studysearch-controller at 23a161046c4cf2c331c7bab13b4c21dcd904630e, read back at the time of this record: status reconciliation, generation 0, owner null, no lease, no events, transfer pending to codex-weekend-20261106-0903Z, adoption pending, reconciliation required. Claude never held the lease, so there is no lease of Claude's to release and no atomic release was published. record_predecessor_release needs verified live reconciliation, which is Codex's to establish. Claude did not change the ref. Codex should record Claude's release and verify it independently.

## Item 4: queued workflow run 34749286102

| Field | Value |
| --- | --- |
| Run | CF-093 UQ Acceptance Dispatcher, Coursefinder-Pilot, event push on main, run_attempt 3 |
| Created / last updated | 2026-09-13T09:18:14Z / 2026-09-13T09:19:23Z |
| API status | queued, conclusion null, 0 jobs |
| Workflow definition | .github/workflows/cf093-uq-acceptance-dispatcher.yml, workflow state deleted |
| Cancel and force-cancel | both refused: HTTP 409 "Cannot cancel a workflow run that has not been queued yet" |
| Disposition | Not running and cannot start (no jobs, workflow definition deleted, 54 days old). Not cancellable through the API. Run record not deleted by Claude (a permanent deletion needs the Platform Admin). Remaining action: Platform Admin or GitHub Support removes the run record. It has no effect on production. |

## Item 3: inventory of in-flight and scheduled operations (read at 13:44 to 13:46 UTC, 6 Nov)

| Area | Finding |
| --- | --- |
| Claude scheduled tasks | none (list shows no enabled tasks) |
| Claude agents / background tasks | none running; no other Claude session reachable |
| Local processes | none (no test, build or SQL processes) |
| Claude worktrees | wt-evid, wt-gdesc, wt-h, wt-iprog, wt-pdesc: clean, nothing unpushed |
| GitHub Actions in progress | Test evidence 42226902408 (branch cf247-controller-entrypoint-gates) and 42225031328 (delivery-p0-deadline-382). Not started by Claude after the instruction; belong to Codex branches. Admin repo: none |
| Direct SQL sessions | none open from Claude. Non-idle sessions were pg_cron only |
| Cloudflare | Claude has no pending deployment. Last production frontend is v2.15.489; deployment commit not independently verified |

## Item 5: verified production baseline (read-only)

- Pilot main 4ba94e3f (v2.15.489, #877). Latest migration 20261106400000, 1791 migrations. Nothing from #893/#894 (migrations 500000, 550000) applied.
- pg_cron: 164 active jobs, 12 inactive, 0 failures in the last 2 hours. One platform job running: coverage-admit-intakes (since 13:45:00 UTC, scheduled, finishes on its own). consumer-api-guard, first-run-verify, intake-dates-apply, provider-description-read and central-find are active.
- Settings: run_now.jobs = ["intake-dates-apply"]; pdesc.enabled 1; pdesc.ai_usd_max 1. enrich.course_description_reask_max was not re-read (shipped at 0, unreleased).
- Provider descriptions after v2.15.489: no new read since deploy; 4 Layer 4 items pending, 0 approved; AI spend US$0.0066 of US$1; nothing admitted or visible through Website API v2 because of this release.

## Open PRs (as read now; heads move as Codex pushes)

| PR | Branch | Head | State |
| --- | --- | --- | --- |
| #894 | cf247-course-descriptions-complete | e15536e8 | ready, unmerged |
| #893 | cf247-english-requirements-complete | eb0caf2e | ready, unmerged |
| #892 | cf247-test-evidence | 4823f68f | ready, unmerged |
| #895 | cf247-controller-entrypoint-gates | bcc3d57a | draft |
| #896 | delivery-p0-deadline-382 | 15018708 | draft |
| #890 | cf247-devapi-r23-r24 | b42a529d | draft, held (needs G3 approval) |
| #875 | cf247-aer-selector-fix | 9205087d | draft, held |

## Outstanding issues

- #877 operational acceptance pending: needs provider-description-read added to run_now.jobs from a Platform Admin signed-in session, then the bounded five-provider run.
- Pending Platform Admin checks: authenticated Admin UI check of Process results (#889) and the Course Catalogue layout.
- Release order and authorisation: course descriptions (#894), then English requirements (#893). Each needs Platform Admin release authorisation. Worker version must be re-versioned above #894. Re-check the md5 of security.course_description_check_v1 (ff3d6dd7b0f88c85b1fdff6c8a8cd86b) before applying.
- English requirements: Canterbury stored page is wrong; Massey has no stored page; central-find paid calls held by the Firecrawl reserve guard (decision for Platform Admin).
- Trust policy (D1) before any course-description admission. Terminology: publication-stage "975" label wording.
- Register entries for PRs #892 to #894 and the provider_facts_inspect calls (requests 602654, 602806, 602807) were not written by Claude.
- P0 deadline defect and D-382-CUTOVER: owned by Codex per #382; not touched by Claude.

## Credentials (item 9 caution)

Nothing was revoked or changed. This session still holds GitHub, Supabase and Cloudflare access. Claude will not use it for production-changing work. Revocation, if wanted, must be done by the Platform Admin and then independently verified.

## Next safe actions for Codex

1. Validate this record and the in-flight evidence independently, then accept ownership through #382 and the ownership tool.
2. Re-read production before any write; apply the load policy (heavy reads only at :x6 to :x8, no reads :35 to :42 or :47 to :48).
3. Ask the Platform Admin to dispose of run 34749286102 and for the pending authorisations above.
