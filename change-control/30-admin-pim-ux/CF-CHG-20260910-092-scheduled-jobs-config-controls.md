# CF-CHG-20260910-092 — Scheduled Jobs configuration and run follow-through

**Initiated:** 2026-09-10 12:49 AEST  
**Updated:** 2026-09-10 19:56 AEST  
**Milestone:** M2.4.5 — additive H4 reopening  
**Origin:** M2.4.5 — Scheduled Job Config  
**Owner:** CourseFinder Admin/PIM  
**Primary category:** Admin / PIM UX  
**Status:** SOURCE ACTIVE / REBASE-RECONCILIATION REQUIRED BEFORE ACCEPTANCE

## Requested outcome

Improve **Administration → Scheduling** with:

- operator-friendly column naming;
- schedule editing;
- safe Layer 1 / Layer 2 / Layer 3 Run on demand;
- Jobs and Evidence cross-links;
- readable latest queue/run outcomes;
- UI/UX parity with the canonical Administration workspaces;
- targeted → bounded → nominated acceptance.

## Governance position

H4 Scheduler & Jobs was previously CLOSED / PASS under `CF-CHG-20260905-209`. This is an authorised additive reopening and does not invalidate that rollback baseline.

Generic historical Job retry/replay/reset remains prohibited. Run on demand must preserve the existing Layer-specific scheduler, Evidence, authority, qualification, Search and publication boundaries.

## Repository reconciliation after PR #65

PR **#65 — Fix QS duplicate re-upload recovery for retained XLSX parsing** was merged on 10 September 2026, not merely closed.

New accepted Pilot `main`:

- merge SHA: `6935e23cf65fc6348fbc6d1b5bdfd520e3f272f2`;
- PR #65 accepted head: `2f0623c4f48ee6150287caa152f240d6ed81e711`;
- PR #65 preserves authenticated browser multipart upload, QS 2027 Evidence recovery and accepted QS 2027 parsing/application;
- package version on merged `main` remains `0.1.2`;
- RLS remediation remains separately tracked and is not part of CF-092.

Open Scheduled Jobs PR **#63** remains based on the earlier `0705195f4667f6562225b52de922f21c6df59aaf` baseline. Compare against current main reports:

- status: **diverged**;
- Scheduled Jobs branch: **19 commits ahead / 12 commits behind** current main;
- therefore the old PR #63 candidate is no longer an acceptance candidate.

No prior CF-092 build/UAT result may be promoted to final PASS until the Scheduled Jobs work is reconciled onto `6935e23c...` and rerun.

## Current implementation decision

The permanent Scheduling implementation remains the native React workspace introduced on `feature/m245-scheduled-jobs-config-20260910`.

The temporary DOM-enhancer approach is rejected under A2 and must remain removed.

The earlier proposed `public.scheduler_policy_control` RPC is also superseded and must remain absent. It was never successfully deployed to Pilot.

CF-092 must reuse the already governed `public.refresh_policy_upsert_v2` mutation boundary:

- **Edit schedule** updates the exact existing bounded policy with required governance reason;
- **Run on demand** marks that same enabled bounded policy due now;
- the normal scheduler then creates/dispatches the refresh request;
- historical Jobs are never reset/replayed.

Browser Job reads continue through `api.jobs()` → `public.admin_read`. No direct browser read of `pipeline.jobs` is permitted.

## Required UI outcome

The accepted Scheduling workspace must contain:

1. **Schedule Configuration** columns: Layer, Country, Scheduled Target, Freshness Policy, Cadence, Next Run, Schedule Status, Actions.
2. **Edit schedule** with cadence, next-run and enabled state plus required governance reason.
3. **Run on demand** for eligible enabled Layer 1–3 bounded schedules.
4. **Latest Refresh Queue** with trigger, target, status, queued/completed timestamps and readable reason/result.
5. **Recent Job Runs** with Job/source, state, run mode, start/completion, result summary and canonical Jobs/Evidence follow-through.
6. Layer 1 / Layer 2 / Layer 3 contextual links to canonical workspaces.
7. Existing Search refresh signals retained unchanged.

## Updated execution plan

### Gate 0 — reconcile parallel baseline

1. Rebase/merge current Pilot `main` `6935e23c...` into the Scheduled Jobs branch or recreate the CF-092 patch cleanly from that main head.
2. Preserve every PR #65 change, especially `src/lib/supabase.js`, ranking multipart upload behaviour, QS Evidence recovery migration/tests and current ranking lifecycle state.
3. Resolve package/CHANGELOG changes from current main rather than carrying the stale `0.1.3` branch state blindly.
4. Confirm diff contains only intended CF-092 Scheduled Jobs changes plus unavoidable reconciliation metadata.

### Gate 1 — targeted source validation

Run on the reconciled candidate SHA:

- frontend build;
- CF-092 source contract;
- existing admin-navigation/deep-link contract;
- browser data-access guard: no direct `supabase.from()` for Jobs/private pipeline tables;
- verify `refresh_policy_upsert_v2` remains authenticated/rank gated through the accepted public → security bridge;
- verify no `scheduler_policy_control` migration/RPC remains;
- verify no generic Job retry/reset/replay control appears.

### Gate 2 — bounded integration

Against the deployed reconciled candidate:

- Administration → Scheduling loads natively;
- friendly columns render correctly;
- Edit schedule opens and requires reason;
- Run on demand appears only for eligible enabled Layer 1–3 policies;
- queue and recent Job results remain readable;
- Jobs, Evidence and Layer links resolve correctly;
- PR #65 ranking upload/Open Dataset/Compare paths receive a focused regression check because `src/lib/supabase.js` changed on main while CF-092 was in flight;
- no browser/server errors.

### Gate 3 — consequential-action proof

Use a rollback-only/no-effective-change operator test:

- capture an existing bounded policy;
- prove unauthenticated/insufficient-rank mutation fails;
- update/restore the same policy through `refresh_policy_upsert_v2`;
- for Run on demand, mark only an eligible existing bounded policy due now and prove the normal scheduler creates/follows the request without historical Job replay;
- verify Layer-specific authority/Evidence constraints remain intact.

Do not weaken role/RLS/security controls and do not fabricate an unbounded test target.

### Gate 4 — security/runtime reconciliation

- compare Security Advisor with the recorded pre-CF-092 baseline;
- keep the existing RLS INFO inventory/pending security task separate;
- no unexplained new Critical/High findings;
- inspect public browser RPC grants and SECURITY DEFINER bridges relevant to the scheduler;
- confirm Production remains untouched.

### Gate 5 — release and final acceptance

Only after Gates 0–4 PASS:

1. select the next visible Admin version from current main release history; do **not** assume `v2.15.76` until current release surfaces are reconciled;
2. update package/CHANGELOG/canonical release history as required by current guardrails;
3. nominate one final SHA;
4. run one full deployed acceptance matrix;
5. merge PR #63 (or its clean replacement) only after the candidate is green;
6. update RUNSHEET / CURRENT-STATE / FOLLOW-UPS / NEXT-CHAT and close CF-092 as UAT PASS/CLOSED.

## Current exact next gate

**Reconcile PR #63 onto merged PR #65 main SHA `6935e23cf65fc6348fbc6d1b5bdfd520e3f272f2`, then rerun targeted source/build validation.**

Until that occurs, CF-092 remains **ACTIVE / NOT ACCEPTED** and no prior Scheduled Jobs CI result is final acceptance evidence.
