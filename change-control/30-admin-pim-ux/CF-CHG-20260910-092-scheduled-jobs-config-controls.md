# CF-CHG-20260910-092 — Scheduled Tasks configuration and run follow-through

**Initiated:** 2026-09-10 12:49 AEST  
**Updated:** 2026-09-10 20:29 AEST  
**Milestone:** M2.4.5 — additive H4 reopening  
**Origin:** M2.4.5 — Scheduled Job Config  
**Owner:** CourseFinder Admin/PIM  
**Primary category:** Admin / PIM UX  
**Status:** PILOT RUNTIME APPLIED / TARGETED ACCEPTANCE ACTIVE

## Requested outcome

Provide a first-class operational Scheduled Tasks workspace with operator-friendly naming, schedule editing, bounded Layer 1–3 Run on demand, Jobs/Evidence follow-through, readable queues/results and application UX parity.

## Navigation decision — 10 Sep 2026

The governed scheduler workspace is the primary **Data Operations → Scheduled Tasks** route immediately before **Evidence**.

The duplicate Administration → Scheduling entry, Administration scheduling render branch and hidden `Refresh & Scheduling` route are removed. The visible workspace identifies itself as `Data Operations · Scheduled Tasks`; it no longer presents itself as an Administration scheduling surface.

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

Generic historical Job retry/replay/reset remains prohibited. Layer-specific Evidence, qualification, identity, publication and Search controls remain authoritative.

## Repository reconciliation

PR #65 — QS duplicate re-upload recovery — is accepted Pilot baseline at `6935e23cf65fc6348fbc6d1b5bdfd520e3f272f2`.

Scheduled Tasks continues in PR **#66** on `feature/m245-scheduled-jobs-config-20260910`. The branch is reconciled onto current main and remains 0 commits behind the PR #65 baseline.

Current Pilot source head at this update: `90a4da06d277dd24f7bc333a2e4bba56e9d546e9`.

PR #65 multipart upload, private Evidence recovery and QS regression changes remain preserved. Production remains untouched and the separate RLS remediation remains out of scope.

## Acceptance-review corrections

Codex review of the earlier scheduler candidate identified consequential P1 issues that are valid and must not be bypassed:

1. PostgreSQL interval values represented as time-only hours (for example a seven-day cadence rendered as `168:00:00`) could be parsed as empty and then overwrite cadence.
2. UTC ISO slicing into a `datetime-local` control could shift `next_due_at` by the operator timezone when saved.
3. The inherited refresh-policy mutation validated a governance reason but did not persist the operator/reason in durable scheduler audit state.

The final source corrects these issues rather than accepting the earlier implementation.

## Final scheduler action architecture

The earlier proposed generic `public.scheduler_policy_control` remains absent and was never deployed.

The final implementation separates schedule maintenance from on-demand execution:

### Schedule edit

`public.scheduler_policy_edit_v1` is a SECURITY INVOKER browser-facing wrapper to `security.scheduler_policy_edit_v1_browser_bridge`.

The non-exposed bridge:

- requires `auth.uid()` and Pipeline Operator rank >= 4;
- requires an exact existing Layer 1–3 bounded recurring policy;
- rejects event-driven schedules and non-whole-day editing from this UI;
- updates only cadence, next run, enabled state, Change Control and update time;
- persists actor, governance reason, before state and after state to `pipeline.refresh_policy_action_events`.

### Run on demand

`public.scheduler_policy_run_now_v1` is a SECURITY INVOKER browser-facing wrapper to `security.scheduler_policy_run_now_v1_browser_bridge`.

The non-exposed bridge:

- requires `auth.uid()` and Pipeline Operator rank >= 4;
- accepts only an exact existing enabled Layer 1–3 bounded policy;
- reuses an already queued/running request for the exact target rather than duplicating it;
- otherwise creates a `manual_governed` refresh request carrying `requested_by`, operator reason and `CF-CHG-20260910-092`;
- records the action and resulting request in durable scheduler audit;
- does **not** change policy cadence or `next_due_at`.

This remains a bounded refresh request, not a generic historical Job replay/reset. Layer 3 execution still requires its existing Evidence/profile/model qualification and does not gain autonomous AI authority.

## UI corrections

- PostgreSQL day/time interval strings are converted only when they represent an exact whole-day cadence; unsupported cadences are not silently rewritten.
- Existing `next_due_at` is formatted into browser-local wall time before populating `datetime-local`, then converted back to an instant on save.
- Run-on-demand copy explicitly states the recurring cadence/next run are unchanged.
- Browser Job reads remain `api.jobs()` → `public.admin_read`; no browser `pipeline.jobs` read was introduced.

## Pilot runtime application

Migration `20260910202500_cf_092_scheduler_governed_actions.sql` has been applied to the **Pilot** Supabase project only.

Runtime verification confirms:

- `public.scheduler_policy_edit_v1`: SECURITY INVOKER; execute grants only postgres/authenticated/service_role;
- `public.scheduler_policy_run_now_v1`: SECURITY INVOKER; execute grants only postgres/authenticated/service_role;
- both non-exposed `security.*_browser_bridge` functions are SECURITY DEFINER and independently auth/rank gated;
- PUBLIC/anon execution is absent;
- `pipeline.refresh_policy_action_events` has RLS enabled, browser table grants revoked and an authenticated deny-all policy;
- action-event count immediately after migration is **0**, proving migration itself did not mutate schedules or queue work.

Post-DDL Security Advisor remains exactly the recorded baseline: **191 INFO `rls_enabled_no_policy` findings, no new High/Critical finding**. The new scheduler audit table does not add a new advisor finding. Existing RLS remediation remains separate.

## Acceptance contracts

Source and deployed contracts now require:

- Scheduled Tasks before Evidence;
- `#scheduled-tasks` canonical route;
- no Administration Scheduling tab/render branch;
- no hidden `Refresh & Scheduling` route;
- friendly schedule columns;
- Jobs/Evidence/Layer links;
- dedicated audited edit/run-now RPCs;
- no direct Jobs table reads;
- no generic Job update/delete/truncate/replay;
- run-now leaves recurring schedule unchanged;
- public SECURITY INVOKER / non-exposed rank-gated bridge pattern;
- durable actor/reason/Change-Control audit.

## Acceptance evidence

Earlier application candidate `032b52dec72a1764f64931fa1aaacd74e1e6984a` passed:

- Pilot Frontend Build `34464602385`;
- Release History Contract `34464602333`.

Those are historical evidence only because later functional hardening changed the candidate.

A dedicated CF-092 source-acceptance workflow was queued on pre-release-metadata candidate `abe165c6a9b618198b7a91eaed4bdc1e22d6e619`; it must not be treated as the final candidate after subsequent source metadata commits. Fresh CI is required on the final nominated SHA.

## Remaining gates

1. Close the last Administration-description wording footprint in source and confirm no Scheduling tab/render/deep-link remains.
2. Fresh frontend build + release-history CI on the resulting final source candidate.
3. Execute the corrected CF-092 source contract on that final source candidate.
4. Run deployed PR-preview Scheduled Tasks + canonical navigation UAT.
5. Run focused PR #65 ranking/Open Dataset/Compare regression.
6. Controlled no-effective-change schedule-edit proof plus negative auth/rank proof. Do not invoke run-on-demand merely to create live work unless a governed bounded test target is explicitly nominated.
7. Resolve Codex P1 threads only after evidence is attached to the corrected head.
8. Determine next visible PIM release from canonical history after functional gates pass; nominate one final SHA and run final deployed acceptance once.

## Current exact next gate

**Finish the last Administration copy cleanup, then run fresh targeted CI/source contract and bounded deployed UI acceptance on one final PR #66 SHA.**

CF-092 remains **ACTIVE / NOT ACCEPTED** until these gates pass.
