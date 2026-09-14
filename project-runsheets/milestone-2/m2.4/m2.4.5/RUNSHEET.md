# M2.4.5 RUNSHEET — Admin/PIM Hardening & Pre-Production Operational Readiness

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 CLOSED / PASS; CF-245 ENRICHMENT OPERATIONS ACTIVE  
**Opened:** 2026-09-03 10:28 AEST  
**Reconciled:** 2026-09-15 08:22 AEST  
**Predecessor:** M2.4.4 CLOSED / PASS / FROZEN  
**Successor:** M2.5 Production Readiness — PAUSED AT P0

## Current baseline

- Accepted Pilot main: `7196c5d2fade8830ec371c663b008e8a47e01f74`.
- Active CF-245 Pilot branch: `cf-245-enrichment-ops` @ `2feb5be5d9bf39f0d677a323bafd30c7f8da1026`.
- Pilot PR: #91 — `CF-245: Enrichment operations telemetry, backlog and bounded admission`.
- Visible accepted release: v2.15.79 / package 0.1.6.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- CF-093: CLOSED / PASS / HISTORICAL ONLY; do not reopen.
- Production Supabase: not provisioned.
- Current operational authority: `CF-CHG-20260915-245`.

## Accepted inherited gates

- [x] CF-093 consequential scheduler/orchestrator acceptance closed.
- [x] Exact Preview/binding/fingerprint/identity provenance preserved.
- [x] Deterministic Layer 2 remains Evidence-preserving and fail-closed.
- [x] Generic scheduler Layer 3 auto-approval prohibited.
- [x] Layer 4 and Search/Publication remain separate governed boundaries.
- [x] Accepted v2.15.79 runtime/release baseline established.

## CF-245 Gate A — measurement contract and baseline

- [x] Reconciled the historical 245-job planning cohort and corrected the false `no layer2_run_items` interpretation: item rows existed but were pre-created before acquisition and later lifecycle-updated.
- [x] Quantified the zero-mutation cause: item-wide Layer 3 escalation occurred because unresolved targeted domains were treated as a whole-item outcome; description was unresolved on 245/245, with additional tuition/intake/English fall-out.
- [x] Produced field-level hourly measurements including provider response/extraction latency, Evidence, retries, vendor units/cost and stop reasons.
- [ ] Daily report requires a fresh representative CF-245 execution period before velocity/ETA claims.

## CF-245 Gate B — telemetry wiring

- [x] Applied `20260915072000_cf_245_enrichment_operational_ledger_v1.sql` to Pilot.
- [x] Added common operational ledger and hourly report derived from governed run-item/job/provider-attempt/Evidence/source-record/Search state.
- [x] Added explicit stop-reason classification without granting mutation authority.
- [x] Historical 263-item RMIT batch reconciles 789 Evidence artifacts, 1,307 targeted fields, 935 deterministic candidates and zero original admissions.
- [ ] Prove the same telemetry on a fresh governed execution after PR/repository reconciliation.

## CF-245 Gate C — demand/backlog generation

- [x] Applied `20260915074500_cf_245_enrichment_reports_backlog_v1.sql` to Pilot.
- [x] Classified AU/NZ missing coverage by queueable, blocked and awaiting source/profile qualification.
- [x] AU current course-fact scope: 516 queueable missing courses, 2,005 requiring governed URL discovery, 28 lacking enabled execution policy, 18,534 awaiting discovery+policy, 5,555 outside current qualified course-fact scope.
- [x] NZ current course-fact scope: 0 queueable; 1,087 require discovery/policy and 5,370 have no qualified course-fact scope.
- [x] Scholarship coverage remains a separate qualified scholarship-source/admission path rather than being manufactured as course-fact data.

## CF-245 Gate D — AU/NZ operational coverage expansion

- [x] First bounded AU field-admission replay completed for qualified RMIT official-course URLs.
- [x] 262 official-URL decisions recorded: 260 admitted canonical changes + 2 unchanged/idempotent.
- [x] One additional source-record candidate remained unadmitted because the regulatory code was not observed.
- [ ] Expand beyond the qualified RMIT cohort only through bounded country → subdivision → provider → course waves with source/profile qualification retained.
- [ ] NZ remains blocked from execution expansion until its discovery/profile/policy qualification gaps are resolved.

## CF-245 Gate E — admission/publication reconciliation

- [x] Applied `20260915082000_cf_245_field_admission_bounded_url_v1.sql` to Pilot.
- [x] Official-URL admission requires exact CRICOS identity, Evidence URL equality, qualified source, approved Search source gate and no Layer 4 operational block.
- [x] No generic tuition/intake/English/description auto-approval was introduced.
- [x] Re-ran governed Search enrichment projection separately from canonical admission.
- [x] Verified current Search coverage: 33,105 courses; 26,457 regulatory tuition; 161 intakes; 161 English; 421 official course URLs; 161 provider-current tuition; 0 website-admitted scholarships.
- [ ] Add explicit publication-delta attribution to the operational report rather than inferring causality from acquisition success.

## CF-245 Gate F — Admin reporting

- [ ] Provide Enrichment Operations reporting separate from Scheduled Tasks configuration/health.
- [ ] Show backlog, due/queued/processing, Evidence, admitted/published/failed, field coverage growth, provider/source yield, latency, blockers, retries/errors and cost/yield.
- [ ] Drill down to Jobs and Evidence.

## CF-245 Gate G — evidence-led tuning

- [x] Scheduler frequency/concurrency/provider limits deliberately unchanged through Gates A–E.
- [ ] Tune only after comparable fresh-period observations exist.
- [ ] Audit any behavioural tuning through governed tuning events with CF-245 reference.

## CF-245 Gate H — acceptance

- [ ] Pilot PR #91 checks/review green and repository/runtime migrations reconciled.
- [ ] Representative fresh bounded AU/NZ workloads complete where source qualification permits.
- [ ] Hourly and daily operational reports meaningful and reproducible.
- [ ] Applicable targeted/bounded CI/UAT/security gates green.
- [ ] Continuity and Change Control reconciled; CF-245 closure only after Admin reporting and steady-state evidence.

## Exact next action

1. Complete PR #91 targeted review/CI and reconcile the three already-applied Pilot migrations to repository history.
2. Add the Enrichment Operations Admin read/reporting surface using the new ledger/backlog/admission data; keep Scheduled Tasks limited to scheduler configuration/health.
3. Run one fresh bounded governed Layer 2 cohort to prove the live acquisition → Evidence → extraction → admission → Search/publication telemetry chain.
4. Continue bounded AU expansion from current qualified scope; do not enable NZ or tune scheduler/provider limits until qualification and comparable evidence support it.
