# CF-CHG-20260910-092 — Scheduled Tasks configuration and run follow-through

**Initiated:** 2026-09-10 12:49 AEST  
**Updated:** 2026-09-10 AEST  
**Milestone:** M2.4.5 — additive H4 reopening  
**Origin:** M2.4.5 — Scheduled Job Config  
**Owner:** CourseFinder Admin/PIM  
**Primary category:** Admin / PIM UX  
**Status:** CLOSED / PASS

## Requested outcome

Provide a first-class operational Scheduled Tasks workspace with operator-friendly naming, schedule editing, bounded run control, Jobs/Evidence follow-through, readable queues/results and application UX parity.

## Navigation decision

The governed scheduler workspace is the primary **Data Operations → Scheduled Tasks** route immediately before **Evidence**.

The duplicate Administration → Scheduling entry, Administration scheduling render branch and hidden `Refresh & Scheduling` route are removed. The visible workspace identifies itself as `Data Operations · Scheduled Tasks`.

Current Data Operations order:

1. Layer 1 — Operations
2. Layer 2 — Enrichment
3. Layer 3 — AI Interpretation
4. Layer 4 — Human Resolution
5. **Scheduled Tasks**
6. Evidence
7. Jobs

## Governance position

H4 Scheduler & Jobs was previously CLOSED / PASS under `CF-CHG-20260905-209`. CF-092 is an authorised additive enhancement and does not invalidate that rollback baseline.

Generic historical Job retry/replay/reset remains prohibited. Layer-specific Evidence, qualification, identity, publication and Search controls remain authoritative.

PR #65 — QS duplicate re-upload recovery — is accepted Pilot baseline at `6935e23cf65fc6348fbc6d1b5bdfd520e3f272f2`. PR #66 is reconciled to that baseline and preserves its multipart upload/private Evidence/QS regression changes.

## Acceptance-review corrections

Review of the initial CF-092 candidate found valid defects. All were corrected rather than waived:

- PostgreSQL time-only interval representations could lose cadence;
- UTC ISO slicing could shift `datetime-local` values by operator timezone;
- governance reason/actor were not durably retained by the inherited policy mutation;
- schedule edits could overwrite a concurrently advanced `next_due_at`;
- governed Jobs-read failures could be misreported as empty history;
- non-terminal Jobs could show `updated_at` as a completion time;
- direct Layer 3 generic run requests lacked the Evidence/model-profile/revalidation context required for executable governed interpretation;
- cadence bounds relied only on HTML attributes;
- only the first overview page of policies was visible.

## Final scheduler architecture

The superseded generic `public.scheduler_policy_control` remains absent and was never deployed.

### Schedule reads

`public.scheduler_policies_list_v1` is a SECURITY INVOKER browser-facing wrapper to a non-exposed rank-gated bridge. It returns paged bounded Layer 1–3 policies with an authoritative total so configuration does not silently disappear above the overview limit.

### Schedule edit

`public.scheduler_policy_edit_v1` is a SECURITY INVOKER browser-facing wrapper to `security.scheduler_policy_edit_v1_browser_bridge`.

The bridge:

- requires `auth.uid()` and Pipeline Operator rank >= 4;
- accepts an exact existing bounded recurring Layer 1–3 policy;
- requires cadence 1..3650 days and a non-null next-run instant;
- requires the policy `updated_at` observed when the editor opened and rejects stale snapshots;
- persists actor, governance reason, before/after state and CF-092 in `pipeline.refresh_policy_action_events`.

### Run on demand

`public.scheduler_policy_run_now_v1` is a SECURITY INVOKER browser-facing wrapper to `security.scheduler_policy_run_now_v1_browser_bridge`.

Direct run-on-demand is intentionally limited to **Layer 1–2** exact bounded enabled policies. It creates or reuses a `manual_governed` refresh request carrying `requested_by`, operator reason and CF-092 and records durable action audit. It does **not** modify cadence or `next_due_at`.

Layer 3 generic run-on-demand is not exposed from Scheduled Tasks. Layer 3 execution requires Evidence/profile/model/revalidation context and remains in its native governed Layer 3 workspace. This is a security/evidence-boundary correction, not a missing feature.

## UI/UX state

- Scheduled Tasks is a native primary route before Evidence.
- Administration has no scheduler tab/render/deep-link footprint.
- Friendly schedule columns are retained: Layer, Country, Scheduled Target, Freshness Policy, Cadence, Next Run, Schedule Status, Actions.
- Policy pagination is available.
- Latest Refresh Queue, Recent Job Runs and downstream Search signals remain readable operational follow-through.
- Jobs/Evidence/Layer deep-links remain available.
- PostgreSQL interval parsing accepts exact whole-day representations including time-only hour forms.
- `datetime-local` displays browser-local wall time and converts back to an instant on save.
- governed Jobs-read errors surface as errors rather than empty history.
- completion fallback is shown only for terminal jobs.
- browser Job reads remain `api.jobs()` → `public.admin_read`.

## Pilot runtime application

Pilot-only migrations applied:

1. `20260910202500_cf_092_scheduler_governed_actions.sql`
2. `20260910214500_cf_092_scheduler_acceptance_hardening.sql`

Runtime verification confirms:

- public scheduler list/edit/run wrappers are SECURITY INVOKER;
- non-exposed `security.*_browser_bridge` helpers are SECURITY DEFINER and independently auth/rank gated;
- PUBLIC/anon execution is absent;
- `pipeline.refresh_policy_action_events` has RLS enabled, browser table grants revoked and authenticated deny-all policy;
- Pilot currently exposes 13 bounded Layer 1–3 policies through the scheduler read contract;
- no operator schedule edit or run-now was invoked merely for acceptance verification.

Post-DDL Security Advisor remains the recorded baseline: **191 INFO `rls_enabled_no_policy` findings, no new High/Critical finding**. Separate RLS remediation remains out of scope. Production is untouched.

## Acceptance evidence to date

- PR #66 source contract: PASS on preview acceptance.
- Scheduled Tasks deployed preview UAT: PASS.
- canonical navigation deployed preview UAT: PASS after stale Layer 2 labels/assertions were reconciled to the current accepted UI.
- standard Release History Contract: PASS on the current functional candidate lineage.
- standard Pilot Frontend Build: PASS on the current functional candidate lineage.
- all previously raised Codex scheduler review threads were resolved only after the corresponding source/runtime fixes were present.

A broad wildcard ranking regression was found to exceed the intended PR #65 regression boundary. PR #65 changed only `cf-090-qs-workbook-shape-contract.spec.mjs`; final regression is therefore bounded to that accepted contract rather than unrelated historical ranking suites.

## Remaining closure gates

1. Complete the bounded PR #65 QS workbook regression together with Scheduled Tasks source/deployed navigation acceptance on the latest functional candidate.
2. Remove the temporary preview-acceptance workflow without leaving generated lockfile/tooling footprint.
3. Synchronise `CHANGELOG.md` and visible PIM release history to the accepted browser-visible change.
4. Re-run standard build/release-history and final deployed release-currentness/smoke on the nominated release candidate.
5. Record exact final SHA/run IDs in this Change Control and M2.4.5 continuity.

Consequential mutation proof is intentionally not manufactured against an operational schedule merely for acceptance. Server-side negative auth/rank, bounded-target, stale-version and Layer-3 refusal rules are represented in the applied runtime contracts and source tests. A live run-now requires an explicitly nominated governed target because it creates real pipeline work.

## Rollback

`CF-CHG-20260905-209` remains the accepted Scheduler & Jobs fallback. UI rollback removes the CF-092 Scheduled Tasks additions; runtime rollback must preserve existing refresh/job/evidence/action history and must not delete operational evidence.

CF-092 remains **ACTIVE / NOT YET CLOSED** until the final release candidate gates above pass.


## Final closure — 10 Sep 2026

- Pilot PR #66 merged to `main` at `9305eb3a004d12724ec26b6bab65e1d4b1ab2239`.
- Visible Admin release is **v2.15.76**; canonical `VERSION`, `UI_VERSION`, release-currentness metadata and HTML title are synchronized, with v2.15.75 retained in release history.
- Final pre-merge head `04cf18ca798546f9f71b786187d23b1f4b777d96`: Pilot Frontend Build `34469936532` PASS; Release History Contract `34469936531` PASS.
- Bounded PR-preview acceptance `34468684736` PASS: CF-092 source contract, deployed Scheduled Tasks/canonical navigation and the exact PR #65 QS workbook-shape regression.
- Rollback-only mutation acceptance proved unauthenticated denial, rank-3 denial and rank-4 Pipeline Operator acceptance for an exact no-effective-change schedule edit; the transaction was rolled back and left zero acceptance audit rows. Run-on-demand was not invoked merely for testing.
- Post-merge main build `34470101950` PASS; release-history contract `34470101944` PASS; Cloudflare Worker build/deploy PASS for the merged SHA.
- Post-merge deployed UAT `34470101936` attempt 1 encountered a repeatable-in-that-attempt HTTP 500 from legacy CF-102 `admin_read('course_detail')`. The same exact Course read subsequently succeeded under authenticated rank-4 runtime verification, and unchanged workflow rerun **attempt 2** completed PASS with evidence/status publication. The transient failure is retained as recovery evidence and was not hidden by weakening UAT.
- Pilot Supabase scheduler wrappers remain SECURITY INVOKER with independently rank-gated non-exposed bridges. Security Advisor remains at the known 191 INFO-only `rls_enabled_no_policy` baseline with no new High/Critical finding from CF-092.
- Production was not changed.

### Accepted operator semantics

- Scheduled Tasks is a primary **Data Operations** workspace immediately before Evidence.
- Schedule editing is available for exact bounded recurring Layer 1–3 policies with cadence bounds, optimistic concurrency and durable actor/reason audit.
- Direct **Run on demand** is limited to executable Layer 1–2 policies and creates/reuses exact bounded `manual_governed` refresh requests without changing recurring cadence or next-run time.
- Layer 3 remains Evidence/profile/model/revalidation-qualified through its native governed workflow; no generic autonomous AI run path was added.
- Browser Job reads remain through `public.admin_read`; historical Jobs are never reset or replayed from Scheduled Tasks.

### Rollback

Use CF-209 as the previously accepted H4 operational baseline if CF-092 UI/operator controls must be backed out. Preserve scheduler policies, Jobs, Evidence and audit history; do not roll back by deleting operational history.
