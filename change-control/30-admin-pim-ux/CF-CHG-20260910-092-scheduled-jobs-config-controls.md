# CF-CHG-20260910-092 — Scheduled Tasks configuration and run follow-through

**Initiated:** 2026-09-10 12:49 AEST  
**Updated:** 2026-09-10 20:10 AEST  
**Milestone:** M2.4.5 — additive H4 reopening  
**Origin:** M2.4.5 — Scheduled Job Config  
**Owner:** CourseFinder Admin/PIM  
**Primary category:** Admin / PIM UX  
**Status:** SOURCE RECONCILED / TARGETED ACCEPTANCE ACTIVE

## Requested outcome

Provide a first-class operational Scheduled Tasks workspace with:

- operator-friendly column naming;
- schedule editing;
- safe Layer 1 / Layer 2 / Layer 3 Run on demand;
- Jobs and Evidence cross-links;
- readable latest queue/run outcomes;
- UI/UX parity with the rest of the application;
- targeted → bounded → nominated acceptance.

## Navigation decision — 10 Sep 2026

The governed scheduler workspace is now a primary **Data Operations → Scheduled Tasks** route, positioned immediately before **Evidence**.

The duplicate Administration → Scheduling entry has been removed. The old hidden `Refresh & Scheduling` route and Administration scheduling render branch are also removed from the active shell. Scheduled Tasks reuses the same native React workspace and governed scheduler contracts; this is an IA move, not a second scheduler implementation.

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

## Repository/runtime reconciliation

PR #65 — QS duplicate re-upload recovery — was merged into Pilot `main` as `6935e23cf65fc6348fbc6d1b5bdfd520e3f272f2` on 10 September 2026 and is part of the accepted baseline.

Scheduled Tasks work now continues in replacement PR **#66** on branch `feature/m245-scheduled-jobs-config-20260910`.

The branch has been reconciled onto PR #65 main. Latest comparison records:

- merge base: `6935e23cf65fc6348fbc6d1b5bdfd520e3f272f2`;
- branch behind main: **0**;
- current Scheduled Tasks candidate after nav/contract correction: `032b52dec72a1764f64931fa1aaacd74e1e6984a`;
- PR #65 multipart upload, Evidence recovery migration and QS workbook regression contract are preserved;
- Production remains untouched;
- RLS remediation remains separately tracked.

## Current implementation

The permanent implementation is the native React `ScheduledJobsWorkspace` surfaced as **Scheduled Tasks**.

The temporary DOM-enhancer approach remains rejected under A2 and is absent.

The earlier proposed `public.scheduler_policy_control` RPC is superseded, absent from source and was never successfully deployed to Pilot.

CF-092 reuses the governed `public.refresh_policy_upsert_v2` mutation boundary:

- **Edit schedule** updates the exact existing bounded policy with required governance reason;
- **Run on demand** marks that same enabled bounded policy due now;
- the normal scheduler creates/dispatches the refresh request;
- historical Jobs are never reset/replayed.

Browser Job reads remain `api.jobs()` → `public.admin_read`. No direct browser read of `pipeline.jobs` is permitted.

## Required UI outcome

The Scheduled Tasks workspace contains:

1. **Schedule Configuration** columns: Layer, Country, Scheduled Target, Freshness Policy, Cadence, Next Run, Schedule Status, Actions.
2. **Edit schedule** for cadence, next-run and enabled state plus governance reason.
3. **Run on demand** for eligible enabled Layer 1–3 bounded schedules.
4. **Latest Refresh Queue** with trigger, target, status, queued/completed timestamps and reason/result.
5. **Recent Job Runs** with Job/source, state, run mode, timing, result summary and canonical Jobs/Evidence follow-through.
6. Layer 1 / Layer 2 / Layer 3 links to canonical workspaces.
7. Existing downstream Search refresh signals retained unchanged.

## Acceptance gates

### Gate 1 — targeted source / build

Run against the final source candidate:

- frontend build;
- CF-092 source contract;
- primary-nav order and `#scheduled-tasks` routing;
- Administration has no Scheduling tab/section/render branch;
- no hidden `Refresh & Scheduling` route;
- browser Jobs remain on `public.admin_read`;
- `refresh_policy_upsert_v2` remains the accepted public SECURITY INVOKER → security SECURITY DEFINER bridge;
- no `scheduler_policy_control` source or migration;
- no generic Job reset/replay/delete semantics.

### Gate 2 — bounded deployed UI

Against the deployed PR #66 candidate:

- Scheduled Tasks opens from primary nav;
- it appears immediately before Evidence;
- Administration exposes no Scheduling tab;
- friendly schedule columns render;
- Edit schedule dialog opens and requires a governance reason;
- Run on demand is bounded and role-gated;
- Latest Refresh Queue and Recent Job Runs remain readable;
- Jobs, Evidence and Layer links resolve;
- focused PR #65 ranking upload/Open Dataset/Compare regression passes;
- no browser/server errors.

### Gate 3 — consequential-action proof

Use rollback-only/no-effective-change operator evidence. Prove insufficient-rank/anonymous mutation fails, and prove exact bounded schedule update/due-now behaviour without replaying historical Jobs or weakening authority/Evidence rules.

### Gate 4 — security/runtime reconciliation

Compare Security Advisor with the recorded baseline. Existing RLS INFO findings remain separate. No unexplained new Critical/High finding may be accepted. Production remains untouched.

### Gate 5 — release/final acceptance

After Gates 1–4 PASS, determine the next visible Admin release from current canonical release history, nominate one final SHA, run the full deployed acceptance matrix once, then merge PR #66 and close CF-092 only on PASS.

## Current exact next gate

**Complete targeted build/source contract on PR #66 head, then run bounded deployed Scheduled Tasks UI acceptance.**

CF-092 remains **ACTIVE / NOT ACCEPTED** until these gates pass.
