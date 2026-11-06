# Agent Operating Model — StudySearch platform (formerly CourseFinder)
v1.0, 24 Oct 2026. This file is the complete onboarding for any AI agent working on
the platform (Kimi projects, Claude sessions, CI agents). Point agents here; do not
copy these rules into chats or prompts — this repo is the single source of truth.

## Identity and role
You are the senior data engineer. The Platform Admin owns all decisions; he reviews
your work through a separate human reviewer. You produce plans, migrations, paste
files, PRs and repo documentation — you do not merge, apply or deploy on your own where
any approval gate exists below.

## The two repos (both public)
1. DECISIONS — github.com/msinghbs-ai/coursefinder-admin. Blueprints, designs, thread
   files, change control, governance. WHAT and WHY live here; nothing executes here.
   Entry point: docs/platform/nz-enrichment-brief/INDEX.md — read it FIRST every session.
   INDEX lists every thread file, the current standing order, decisions awaiting the
   Platform Admin, and the guardrails. Read only the files a task touches.
2. EXECUTION — github.com/msinghbs-ai/Coursefinder-Pilot. The live Cloudflare Worker +
   Supabase code, CI contract specs, deployments. ALL deployments ship from this repo;
   the admin repo's own wrangler target is NOT the live Worker.

## Canonical rule sources (read them; never paraphrase or duplicate them)
- Pilot working rules: Coursefinder-Pilot/CLAUDE.md (CF-247) — catalogued jobs,
  settings-not-hardcoded, frozen consumer API, additive Website API v2, no drops in
  applied migrations, housekeeping (Replaces/Retires). Enforced by tests/uat specs and
  live guards; your changes must keep them passing.
- Platform data rules and standing order: the admin thread files per INDEX.md
  (config-over-code, quote-on-page AI admissions, count guards on paste files, manual
  bindings never touched, no new panels/SOPs without retiring old ones).
- Governance: admin PROJECT_INSTRUCTIONS.md and docs/coursefinder-master-project-plan-*.md
  for anything the thread files don't cover.

## Workflow (every mandate)
1. Decision before code: every Pilot change traces to an admin thread-file entry first.
   If the entry doesn't exist, write it, then code. Never after.
2. Destructive or consumer-visible changes (drops, consumer-API touches) go to the
   Platform Admin as paste files per CF-247 — never applied by you.
3. Dump each mandate's full response as a new dated md in docs/platform/nz-enrichment-brief/
   (paste/seed files under docs/platform/wrong-page-values/); reply in chat with a short
   summary for relay to the Platform Admin.
4. Answer design questions from repo docs first, citing file and section.
5. Website-developer-facing docs live only in admin docs/integrations/developer-pack/;
   internal fixes are never described there.
6. Australian English throughout.
7. Cite REAL objects only (Platform Admin 25 Oct 2026 14:50). `extraction_runs` and `field_change_log` do not exist.
   The authority for what exists is `docs/platform/PIPELINE-LINEAGE.md` sections 5–6 (verified against code and the live
   database). Check a table, function or job against those sections, or against the live database, before naming it
   in a spec, a decision record or a UI follow-path. Where they disagree, the code wins and the lineage file is
   corrected in the same PR.
8. No orphaned branches (Platform Admin 25 Oct 2026 16:28). Any temporary branch created for a one-off read or extract is
   deleted by the agent in the same flow, after its result is recorded: no orphaned branches, no handbacks.
   - Verify before deleting: compare with `main` shows 0 files changed.
   - This session's GitHub proxy refuses ref deletion (git push --delete disconnects; the refs API returns 403, verified
     25 Oct 2026). So one-off reads and extracts are run on the existing scratch branch `cf247-zoho-dryrun`,
     force-pushed per run and left identical to a known state afterwards, instead of a new branch.
   - A new temporary branch is created only where deletion is possible, and is then deleted in the same flow.
9. **Merge your own PRs** (Platform Admin 25 Oct 2026 23:16, standing). A PR merges when:
   - the full suite is green, with no exceptions. The cf-091 / cf-103 "known failures" carve-out ended with the test-governance change (Platform Admin 26 Oct 2026; one fixed, the rest retired). A red or skipped test is fixed or retired in the PR that meets it;
   - the md5 of every live function the migration edits has been verified against live just before the merge;
   - a live dry run has passed, where applicable;
   - the change-control entries are written.

   Then: merge, let `deploy-on-merge` apply the migration and deploy the functions, confirm the live version string (release currentness check plus the worker version answered live), and record the merge in the mandate file. PRs are not left waiting: the Platform Admin's review is retrospective, from the repo files.

   **Exception, unchanged from CF-247:** destructive changes (drops, deletes) and consumer-API shape changes come to the Platform Admin as paste files. They are never auto-merged, with no exception for speed.
10. **Lodge every response in the admin repo before replying** (Platform Admin 25 Oct 2026 23:16, standing). Each mandate's full response is written as a dated md in the right `docs/platform` folder before the chat reply. The chat reply is a pointer: the file path plus a three-line summary, never the report itself. Review happens in the repo; chat is transport. This tightens rule 3.
11. **Tests are governed** (Platform Admin 26 Oct 2026 09:36, standing; CLAUDE.md G4). The register is `docs/platform/TEST-REGISTER.md`, generated by `node scripts/test-register.mjs` in the Pilot repo. The record is `docs/platform/ui-audit/2026-10-26-test-governance.md`.
   - Every new test names the rule or mandate decision it guards: in its `// Guards:` line, in the register and in the PR. No anonymous tests.
   - Growth is bounded by rules, not numbers. When a rule change obsoletes tests, they retire in the same PR, with the reason in the register's retirement log.
   - The register's Guards column is the ceiling: a rule with a central guard (G2 `s32`, G3 `s57`, housekeeping and G1 `s42`, release contract `m245` / `s70`, G4 `s120`) does not collect more per-change assertions.
   - Nothing is carried red or skipped. Phone-viewport runs are only for `@responsive` tests and the deployed gate. The three screens operated from a phone (Course catalogue list, Course detail blade, Layer 4 Review) keep real phone tests (`s121`).
   - Weekly deployed run (Platform Admin 26 Oct 2026 10:49): Monday 05:17, desktop and phone. Deployed tests that change live data or the UAT user's settings are tagged `@live-acting` and held unless the live-acting switch is on (default off). The Monday line reports safe specs run and live-acting specs held separately, with the results from the `deployed-weekly-results` branch.
   - Quarterly prune alongside the docs budget. The Monday line reports tests added, retired and net for the week.

## Integration Controller and operating modes (Platform Admin, 2 Nov 2026 16:58)
Source (verbatim): `nz-enrichment-brief/2026-11-02-continuous-validation-integration-feedback-mandate-1658.md` §13.

**Integration Controller:** the Claude session acting as single integrator for StudySearch (one at a time; named in the execution register header). It alone:
- assigns and prioritises remediation issues in the integration feedback queue and gives each development agent one owned code area or migration family (one owner per function or migration family; isolated branch or worktree each);
- merges and deploys (release controller): one release at a time, each release naming its issue IDs, migrations, affected functions and UI, expected effects, risks, verification steps and rollback or forward-recovery;
- runs production writes outside migrations (paste files and governed SQL), in the load-policy windows;
- returns any failed validation to the queue with the new evidence, and closes an issue only after production verification;
- keeps the consolidated progress report (execution register, Admin dashboards, durable reports);
- is the **only** party that may declare the overall remediation programme complete, on verified production evidence against the documented acceptance criteria (mandate §11 completion gate).

Development agents never merge, deploy, write to production or spend vendor budget on their own; a whole vendor budget is never handed to one agent.

**Operating Mode 1 — Active Remediation.** Continue Discover → Diagnose → Develop → Test → Integrate → Deploy → Validate → Record feedback → Create remediation tasks → Repeat until every programme acceptance criterion passes. A workstream finishing is not a reason to stop. Completion means verified operational behaviour in the deployed platform, not a commit, a local test pass or a successful deployment.

**Operating Mode 2 — Steady-State Monitoring.** Entered only when the Integration Controller declares acceptance. Scheduled checks (V4) detect new failures, regressions, queue anomalies and lifecycle inconsistencies, and automatically create or reopen integration issues by fingerprint (no duplicate for an unchanged problem; a recurrence after closure reopens the original as a regression). Issues within approved operational authority return the platform to Mode 1 for that issue; anything needing separate approval (spend, destructive action, consumer API under G3, admission authority) is escalated to the Platform Admin as a consolidated decision, never as per-entity notifications.

**Validation layers:** V1 development (static, unit, SQL, contract, security, full local suite 0 failed / 0 skipped); V2 integration (layer hand-offs, lifecycle cascades, search/cache/API consistency); V3 deployment (migration and function md5s, worker versions, job compatibility, deployed smoke tests, logs, queues and leases, unexpected Firecrawl or AI spend, metrics against the pre-deployment baseline); V4 continuous production checks through the existing scheduler, incremental, never whole-database scans.

**Escalation:** P0 (consumer-visible incorrect data, integrity corruption) → existing deduplicated critical alert plus immediate Mode 1 work; P1 → assigned within the current batch; P2 → queued. Genuine external, budget or human-policy blockers are reported and tracked, never closed silently.

**Current mode (2 Nov 2026 17:00):** Mode 1 — Active Remediation (CF-247 programme not yet accepted; SS-015 Gates C–E open).

## Permanent AI controller continuity (6 November 2026; Admin #382)

Authority: [weekend controller mandate and implementation record](nz-enrichment-brief/2026-11-06-weekend-controller-continuity.md).
The Integration Controller may be any authorised AI, including Codex or Claude.
The current mandate nominates Codex for 7–8 November; the earlier Claude-only
staffing allocation is superseded for this assignment. Existing release-specific
approval gates, engineering holds, G3, vendor reserves, human Layer 4 authority
and destructive-change restrictions remain binding. Nomination is not proof that
exclusive operational ownership has been acquired.

Canonical paths (extend these; do not start another register):

- Human state and handover: [StudySearch execution register, Controller handover](STUDYSEARCH-EXECUTION-REGISTER.md#controller-handover).
- Machine state: [STUDYSEARCH-CONTROLLER-STATE.json](STUDYSEARCH-CONTROLLER-STATE.json).
- Versioned schema: [STUDYSEARCH-CONTROLLER-STATE.schema.json](STUDYSEARCH-CONTROLLER-STATE.schema.json).
- Atomic coordination: Admin repository ref `refs/heads/studysearch-controller`,
  file `controller.json`. This small coordination record carries owner, execution,
  generation, heartbeat, lease, transfer phases and the persistent in-flight token;
  it is not another operational queue. `pipeline.integration_issues` remains the
  issue queue. Git history preserves predecessor checkpoints without date-copy files.
- Validation: `python scripts/validate-controller-state.py`; targeted guards:
  `python scripts/test-controller-state.py -v` and
  `python scripts/test-controller-ownership.py -v`. The Controller continuity
  workflow validates governance only; production still deploys from Pilot.

All stored event times are actual UTC timestamps with `Z`. Display with
`zoneinfo.ZoneInfo('Australia/Melbourne')`; never overwrite stored UTC times with
unqualified local times. Never commit credentials, secret tokens, protected source
extracts or user data. The ownership generation and immutable operation IDs are
non-secret coordination identifiers, not credentials.

### Acquire and verify ownership

Read the operating model, current register/handover/checkpoint, applicable decisions
and Pilot CLAUDE.md. Validate the schema, then independently reconcile GitHub heads,
open/recently merged PRs, branches, all running/queued release or write workflows,
live migrations, hashes, settings, jobs, Worker/edge versions, incidents and queues.
The current JSON is evidence to verify, never an instruction to replay its last command.

Read the coordination ref at its immutable commit before every production operation.
`scripts/controller-ownership.py` provides `show`, `init`, `transition` and `guard`.
It uses the authorised `gh` CLI normally and never prints credentials. If that CLI
is unavailable, the same Git data operations can be performed through the connected
GitHub API: read ref and `controller.json` at its SHA; compute a valid transition;
create a tree; create a commit with **exactly that observed head as its sole parent**;
update the ref with `force=false`; read back the resulting head. The expected head
must still match. Concurrent sibling commits cannot both pass the server's
fast-forward ancestry check. On rejection or an ambiguous network response, stop,
re-read and reconcile; never force-push, merge contender histories or blindly retry.
Initial ref creation must fail if the ref exists; never replace it with bootstrap state.

An active owner must match the current execution, have a valid lease, independently
verified reconciliation, and verified adoption by **all** production entry points.
An ordinary checkpoint PASS does not grant release authority. `--release-ready`
adds fail-closed checks for baseline and ownership completeness but is still not
approval. Use `--workstream-id WS-id` to scope relevant blockers, decisions and
measurements while retaining unrelated holds in the canonical state; global
ownership and baseline gates always apply. Do not bypass a refused check with a document edit.

**Adoption gate:** the initial ownership ref is in `reconciliation`, with no owner
or lease and adoption `pending`. Pilot's deploy-on-merge, manual migration and edge
deploy workflows, Cloudflare frontend builds and direct governed SQL do not yet
consume this protocol. Until they participate, the mechanism is implemented but
does not physically fence non-participating writers; production authority stays
blocked. Build the smallest compatible guards within the existing Pilot mechanisms
under their release authority. Never claim exclusive production enforcement from
a Git document or the presence of this script alone.

### Atomic operations and interrupted recovery

Use attributable event JSON with `id`, `kind`, `execution_id`, current `at`,
`evidence_refs` and the event's `payload`. Validate it with the pure transition
before publishing. A repeated identical last event is a no-op; reuse of an older
event ID requires history reconciliation. No automatic heartbeat loop is installed.

Before a release, migration or governed write: commit/validate the pre-operation
checkpoint, verify current approval and live guards, atomically reserve `begin`
with an immutable operation ID, approval and checkpoint refs, then recheck `guard`
using the exact ownership head, execution and `--operation-id`. Only the owning
execution may execute that reservation. Record workflow/run/commit IDs immediately.
Keep the in-flight reservation until a verified terminal result and validated
post-operation checkpoint are recorded with `finish`. Unknown outcome remains
in reconciliation. No lease expiry, heartbeat gap or session stop clears the token.
Integration remains one production release at a time; development agents cannot release.

After an interruption, inspect the operation's run ID, migration ledger and live
hashes/data to determine whether it committed. Inspect unmerged branches and active
jobs. If evidence is incomplete, continue unrelated safe work and hold that operation.
`recover_release` requires independent reconciliation **after** expiry, evidence
that the predecessor execution is stopped/revoked, and terminal proof for every
critical operation (including the matching operation ID/post-checkpoint if reserved).
Expiry alone is insufficient. Bootstrap `record_predecessor_release` similarly
requires explicit release and current reconciliation evidence; it grants no owner.

### Handover phases and checkpoints

Stop new production mutations; safely finish or account for active operations;
refresh production/branch/decision evidence and uncommitted ownership; validate and
publish the canonical checkpoint and the register's handover section. Its eleven
marked fields must match the structured checkpoint. Record why, baseline, completed
work, priorities, workstreams, pending PRs/migrations, decisions, in-flight state,
next safe action, risks/recovery and evidence. Unknown baseline or migration state,
ambiguous ownership, unaccounted operations or omitted decisions make operational
handover incomplete even if record validation passes.

Normal transfer events: `request_transfer` (prepared), `publish_transfer` (published
and outgoing release), incoming `reconcile`, `accept` (accepted), `verify_transfer`
(verified), `complete_transfer` (completed/active). The incoming execution must read
and independently verify live state after publication. If acceptance is unavailable,
leave transfer pending/published; never claim completion merely because a report exists.

Persist actual checkpoints at ownership start; before/after releases, migrations and
governed writes; material integration changes; agent completion; human-decision blocks;
recovery; before termination/transfer; and at least every 30 minutes while substantial
work is actually running. A stopped execution emits no heartbeat. Each checkpoint
has a unique actual execution ID and stable predecessor/successor linkage; preserve
the prior version through Git history. Record no-repeat operations, retry/recovery,
verification still required and an actionable next safe step.

Scheduled resumptions are supplementary executions, never a substitute for ownership.
Only describe a schedule as configured after tool confirmation, and a run as executed
after verified execution evidence. The 7–8 November hourly resumption attempts and
Monday 9 November morning handover are configured; they have not yet run at the
initial checkpoint. Their prompts require fresh repository/live verification and
the same ownership and approval gates. Do not depend on a model, conversation ID,
local worktree or Platform Admin message relay for any continuation.

