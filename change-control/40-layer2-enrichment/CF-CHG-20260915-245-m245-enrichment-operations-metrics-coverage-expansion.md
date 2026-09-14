# CF-CHG-20260915-245 — M2.4.5 Enrichment Operations, Metrics & Coverage Expansion

**Status:** OPEN / IMPLEMENTATION IN PROGRESS — GATES A–E PARTIAL PASS; GATE F NEXT  
**Milestone:** M2.4.5 — Pre-Production Hardening  
**Opened:** 15 September 2026 AEST  
**Reconciled:** 15 September 2026 08:22 AEST  
**Primary category:** 40-layer2-enrichment  
**Related surfaces:** 30-admin-pim-ux, 50-search-api-consumers, 70-security-platform, 80-uat-release-operations  
**Historical baseline:** CF-CHG-20260910-093 CLOSED / PASS; do not reopen  
**Accepted Pilot baseline:** `7196c5d2fade8830ec371c663b008e8a47e01f74` / v2.15.79 / package 0.1.6  
**Active Pilot branch:** `cf-245-enrichment-ops` @ `2feb5be5d9bf39f0d677a323bafd30c7f8da1026`  
**Pilot PR:** #91 — OPEN / mergeable; checks/review required before merge  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 remains PAUSED at P0

## Objective

Make CourseFinder enrichment operationally measurable and progressively expand governed AU/NZ enrichment coverage without weakening Layer 1 identity, Evidence, security, Layer 3/4 authority or Search/Publication admission rules.

The scheduler must report not only whether timers fired, but whether real work was eligible, queued, acquired, extracted, admitted and published, with field-level coverage growth and failure/admission reasons visible by hour and day.

## Authority boundaries

This Change Control preserves:

1. Layer 1 identity/regulatory authority unchanged.
2. Deterministic Layer 2 Evidence-preserving behaviour.
3. Exact Preview/binding/fingerprint/identity provenance where required by accepted scheduler contracts.
4. No generic scheduler Layer 3 auto-approval.
5. Layer 4 human authority for unresolved consequential outcomes.
6. Search/Publication as a separate governed admission boundary.
7. Existing rank/ACL/RLS/private-helper/service-role boundaries.
8. Immutable applied migration history; forward-only changes.
9. No synthetic facts and no flattening of source-null, zero, suppressed, not-applicable and not-yet-enriched states.
10. CF-093 remains historical and closed.

## Opening planning baseline

Planning-time inspection showed healthy scheduler/cron infrastructure, successful acquisition/Evidence activity, zero reported canonical mutation, narrow refresh/execution coverage and website-visible course-fact enrichment of only 10 courses per principal enrichment field.

The planning note that the recent acquisition execution path produced no `layer2_run_items` rows was subsequently corrected by Gate A: managed-run items were pre-created and later lifecycle-updated, so a created-at-only inspection missed them.

Planning website/Search baseline:

- Search courses: 33,105;
- regulatory tuition: 26,457;
- intake coverage: 10;
- English requirement coverage: 10;
- official course links: 10;
- provider-current tuition: 10;
- website-admitted scholarships: 0.

## Gate A — existing workload explanation

### Result: PARTIAL PASS / HISTORICAL COHORT QUANTIFIED

The complete 263-item RMIT managed batch `74b4b16f-20f0-4b61-a9e0-632d824f001a` now reconciles:

- 263 fetched/extracted items;
- 789 Evidence artifacts = 263 acquisition + 263 screenshot + 263 normalised extraction Evidence;
- 1,307 targeted fields;
- 935 deterministic candidate fields resolved;
- 263 original Layer 3 escalations;
- zero original field admissions;
- zero HTTP 429 / zero HTTP 5xx inside the reconciled batch;
- 263 recorded vendor units / recorded cash cost USD 0.

The dominant cause of `canonical_mutation_authorised=false` was not scheduler liveness or fetch failure. The extraction/run-item path escalated the whole item to Layer 3 whenever any targeted domain remained unresolved. Description remained unresolved across the cohort; tuition, intake and English introduced additional overlapping fall-out. Identity mismatch was not the dominant stop cause.

This is an admission-granularity/demand-generation problem. Scheduler frequency/concurrency was intentionally not increased.

## Gate B — common telemetry wiring

### Result: PARTIAL PASS

Applied to Pilot and committed on PR #91:

- `20260915072000_cf_245_enrichment_operational_ledger_v1.sql`.

Runtime surfaces include:

- `pipeline.layer2_enrichment_operational_ledger_v1`;
- `pipeline.layer2_enrichment_hourly_v1`.

The common ledger correlates governed run items, batches, Jobs, provider attempts, Evidence, normalised source records and Search state. It records/derives fields targeted/resolved, unresolved domains, stop reason, Evidence counts, response/extraction latency, retries, vendor units/cost, queue/execution timing and course/provider/country/profile dimensions where available.

Security posture remains service-role/private; the observability objects do not confer canonical/Search/Publication mutation authority.

A fresh CF-245 governed execution is still required after repository reconciliation to prove the same telemetry contract on new work rather than only historical replay.

## Gate C — AU/NZ backlog classification

### Result: PASS FOR CURRENT RUNTIME CLASSIFICATION

Applied to Pilot and committed on PR #91:

- `20260915074500_cf_245_enrichment_reports_backlog_v1.sql`.

Current core course-fact backlog classification:

### Australia

- 516 missing courses are currently queueable under existing URL/profile/execution-policy scope;
- 2,005 require governed course-URL discovery;
- 28 have a usable URL/profile but no enabled execution policy;
- 18,534 await both discovery and execution-policy qualification;
- 5,555 are outside the currently qualified course-fact profile scope.

### New Zealand

- 0 currently queueable;
- 1,087 are in current course-fact scope but require discovery/policy qualification;
- 5,370 have no qualified course-fact profile scope.

Scholarships remain a separate qualified scholarship-source/admission path. No scholarship values are manufactured from course-fact acquisition.

## Gate D — bounded coverage expansion

### Result: PARTIAL PASS — QUALIFIED RMIT URL FIELD ONLY

Applied to Pilot and committed on PR #91:

- `20260915082000_cf_245_field_admission_bounded_url_v1.sql`.

The bounded replay admitted only `official_course_url`, requiring:

- exact AU CRICOS provider/course resolution;
- identity match;
- regulatory code observed in Evidence;
- candidate URL equal to the captured Evidence URL;
- an already-qualified source admitting `official_course_url`;
- an approved Search source gate;
- no Layer 4 operational block.

Current field-admission ledger:

- 262 official-URL decisions;
- 260 admitted canonical changes;
- 2 unchanged/idempotent outcomes;
- one additional candidate remained unadmitted because the regulatory code was not observed.

No generic tuition, intake, English or description auto-approval was introduced. Observed candidate-quality issues include ambiguous/equal-rank fees, low-confidence international-fee candidates and implausible English-score candidates; those domains remain gated.

## Gate E — Search/publication reconciliation

### Result: PARTIAL PASS

Search/Publication remains separate from acquisition and canonical/source-backed admission.

After bounded URL admission, `search.refresh_course_enrichment_v1(false)` was used before each apply. The final preview contained exactly 37 changed Search rows and raised official-course-URL coverage to 421 without changing intake, English, provider-tuition or scholarship coverage. The final projection was then applied.

Verified current Search/consumer coverage:

- Search courses: **33,105**;
- regulatory tuition: **26,457**;
- intake coverage: **161**;
- English requirement coverage: **161**;
- official course links: **421**;
- provider-current tuition: **161**;
- website-admitted scholarships: **0**.

Relative to the planning baseline, runtime outcome movement is +151 intake courses, +151 English courses, +411 official links and +151 provider-current-tuition courses. Causal attribution must use admission/source/publication records rather than assuming every observed delta was produced by the current acquisition replay.

## Gate F — Enrichment Operations Admin reporting

### Status: NEXT IMPLEMENTATION GATE

Scheduled Tasks remains scheduler configuration/health. Build an outcome-focused Enrichment Operations surface that answers without direct SQL:

- backlog / due / queued / processing / Evidence / admitted / published / failed;
- field coverage start, +hour, +day, current, percentage and remaining gap;
- hourly throughput;
- provider/source yield and latency;
- admission/rejection/block reasons;
- retries, 429/5xx/runtime failures;
- vendor units/cost and cost per useful admitted fact;
- drill-down to Jobs and Evidence.

The Admin surface must consume governed read contracts; it must not expose private helper tables or create a new mutation-authority path.

## Gate G — evidence-led tuning

### Status: BLOCKED UNTIL COMPARABLE FRESH PERIODS

No scheduler frequency, concurrency, paid-attempt ceiling, provider rate, routing or credential change has been made under CF-245 to date.

Tuning must use comparable before/after measurements for useful admitted facts per 100 acquisitions, courses improved, p50/p95 latency, error/retry rates, cost/yield, Evidence/storage growth, publication delta and backlog reduction velocity. Material behavioural tuning must create the governed tuning audit trail with CF-245 reference.

## Gate H — acceptance

CF-245 is not ready to close. Remaining acceptance includes:

- PR #91 review/CI and repository/runtime migration reconciliation;
- fresh bounded governed Layer 2 execution proving the telemetry chain on new work;
- Gate F Admin outcome reporting and drill-down;
- representative bounded AU/NZ execution where source qualification permits;
- hourly and daily reports with publication attribution;
- targeted/bounded DB/security/browser UAT and deployed-runtime reconciliation;
- steady-state evidence sufficient for any tuning/ETA statement;
- RUNSHEET, CURRENT-STATE, FOLLOW-UPS and NEXT-CHAT current at closure.

## Current implementation references

- Pilot branch: `cf-245-enrichment-ops`.
- Branch head: `2feb5be5d9bf39f0d677a323bafd30c7f8da1026`.
- PR: #91.
- Last observed PR frontend build: `34904038556` — in progress when recorded; recheck before merge.
- Admin continuity reconciled 15 September 2026 AEST.

## Exact next action

1. Complete PR #91 targeted review/CI; merge only after green evidence and runtime/repository migration equivalence.
2. Implement Gate F Enrichment Operations governed read/UI surface.
3. Run a fresh bounded governed enrichment cohort and reconcile acquisition → Evidence → extraction → field admission/fall-out → Search/publication within one report window.
4. Continue bounded AU expansion only from qualified scope; keep NZ blocked pending source/profile/discovery/policy qualification.
5. Do not tune scheduler/provider limits until comparable fresh-period evidence justifies a governed tuning event.
