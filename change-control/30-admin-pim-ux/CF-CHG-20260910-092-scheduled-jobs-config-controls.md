# CF-CHG-20260910-092 — Scheduled Tasks configuration and run follow-through

**Initiated:** 2026-09-10 12:49 AEST  
**Updated:** 2026-09-10 20:17 AEST  
**Milestone:** M2.4.5 — additive H4 reopening  
**Origin:** M2.4.5 — Scheduled Job Config  
**Owner:** CourseFinder Admin/PIM  
**Primary category:** Admin / PIM UX  
**Status:** SOURCE RECONCILED / TARGETED ACCEPTANCE ACTIVE

## Requested outcome

Provide a first-class operational Scheduled Tasks workspace with operator-friendly naming, schedule editing, bounded Layer 1–3 Run on demand, Jobs/Evidence follow-through, readable queues/results and application UX parity.

## Navigation decision — 10 Sep 2026

The governed scheduler workspace is now the primary **Data Operations → Scheduled Tasks** route immediately before **Evidence**.

The duplicate Administration → Scheduling entry, Administration scheduling render branch and hidden `Refresh & Scheduling` route have been removed. Scheduled Tasks reuses the same native React workspace and governed scheduler contracts; this is an IA move, not a second scheduler implementation.

Current Data Operations order:

1. Layer 1 — Operations
2. Layer 2 — Enrichment
3. Layer 3 — AI Interpretation
4. Layer 4 — Human Resolution
5. **Scheduled Tasks**
6. Evidence
7. Jobs

## Governance position

H4 Scheduler & Jobs was previously CLOSED / PASS under `CF-CHG-20260905-209`. This is an authorised additive reopening and does not invalidate that rollback baseline.

Generic historical Job retry/replay/reset remains prohibited. Run on demand must preserve existing Layer-specific scheduler, Evidence, authority, qualification, Search and publication boundaries.

## Repository reconciliation

PR #65 — QS duplicate re-upload recovery — is accepted Pilot baseline at `6935e23cf65fc6348fbc6d1b5bdfd520e3f272f2`.

Scheduled Tasks continues in PR **#66** on `feature/m245-scheduled-jobs-config-20260910`. The branch is reconciled onto PR #65 main and is **0 commits behind** that baseline.

Current source candidate after navigation and acceptance-contract cleanup: `d1e08208198ebb18445ffbcc1791fbc360c51777`.

PR #65 multipart upload, private Evidence recovery and QS regression changes remain preserved. Production remains untouched and the separate RLS remediation remains out of scope.

## Current implementation

- Native `ScheduledJobsWorkspace` is surfaced only through the primary **Scheduled Tasks** page.
- Temporary DOM-enhancer remains rejected/absent.
- Proposed `public.scheduler_policy_control` remains absent and was never deployed.
- Schedule edits and Run on demand reuse governed `public.refresh_policy_upsert_v2`.
- Run on demand marks the same exact enabled bounded policy due now; normal scheduler dispatch remains authoritative.
- Browser Job reads remain `api.jobs()` → `public.admin_read`.
- Historical Jobs are never reset/replayed.
- Layer 3 Evidence/profile/model qualification remains authoritative.

## UI acceptance contract

Required Scheduled Tasks surface:

- Schedule Configuration: Layer, Country, Scheduled Target, Freshness Policy, Cadence, Next Run, Schedule Status, Actions;
- Edit schedule with governance reason;
- bounded Run on demand for eligible Layer 1–3 schedules;
- Latest Refresh Queue;
- Recent Job Runs;
- canonical Layer, Jobs and Evidence links;
- downstream Search signals unchanged.

Navigation acceptance now explicitly verifies:

- Scheduled Tasks appears before Evidence;
- `#scheduled-tasks` route resolves and survives browser history;
- Administration exposes no Scheduling tab;
- no `Refresh & Scheduling` primary/hidden navigation remains;
- the old deployed navigation UAT no longer instructs the browser to click the removed Scheduling tab.

## Acceptance evidence

On candidate `032b52dec72a1764f64931fa1aaacd74e1e6984a` before the final navigation-test maintenance commit:

- Pilot Frontend Build run `34464602385`: **PASS**;
- Release History Contract run `34464602333`: **PASS**.

Those passes prove build/release-history integrity of the same application implementation, but the later UAT-only commits invalidate that SHA as the final nominated acceptance candidate. Fresh CI is required on the latest PR #66 head before closure.

## Remaining gates

1. Fresh frontend build and release-history CI on latest PR #66 head.
2. Execute the CF-092 source contract; CI discovery alone is not execution evidence.
3. Deployed PR preview acceptance for Scheduled Tasks plus canonical navigation.
4. Focused PR #65 ranking/Open Dataset/Compare regression.
5. Rollback-only/no-effective-change operator mutation proof for edit/due-now and negative rank/auth paths.
6. Security Advisor delta check against the pre-CF-092 baseline; separate RLS inventory remains separate.
7. Determine next visible release only after functional gates pass; nominate one final SHA and run final deployed acceptance matrix once.

## Current exact next gate

**Fresh CI on `d1e08208...`, followed by targeted CF-092 contract execution and bounded deployed Scheduled Tasks acceptance.**

CF-092 remains **ACTIVE / NOT ACCEPTED** until these gates pass.
