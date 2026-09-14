# CF-CHG-20260915-245 — M2.4.5 Enrichment Operations, Metrics & Coverage Expansion

**Status:** OPEN / IMPLEMENTATION IN PROGRESS — GATES A–F IMPLEMENTED/PARTIAL PASS; DEPLOYED UAT RECOVERY ACTIVE  
**Milestone:** M2.4.5 — Pre-Production Hardening  
**Opened:** 15 September 2026 AEST  
**Reconciled:** 15 September 2026  
**Primary category:** 40-layer2-enrichment  
**Related surfaces:** 30-admin-pim-ux, 50-search-api-consumers, 70-security-platform, 80-uat-release-operations  
**Historical baseline:** CF-CHG-20260910-093 CLOSED / PASS; do not reopen  
**Current Pilot main:** `f707e2d4b7221a185dcafb6ec2095ec4a94ad841`  
**Merged implementation:** PR #91 and PR #92  
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

## Gate A — existing workload explanation

### Result: PASS FOR HISTORICAL COHORT

The complete 263-item RMIT managed batch `74b4b16f-20f0-4b61-a9e0-632d824f001a` reconciles:

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

### Result: PASS / MERGED

Merged via PR #91 and reconciled to Pilot runtime:

- `20260915072000_cf_245_enrichment_operational_ledger_v1.sql`;
- `pipeline.layer2_enrichment_operational_ledger_v1`;
- `pipeline.layer2_enrichment_hourly_v1`.

The ledger correlates governed run items, batches, Jobs, provider attempts, Evidence, normalised source records and Search state. It records/derives fields targeted/resolved, unresolved domains, stop reason, Evidence counts, response/extraction latency, retries, vendor units/cost, queue/execution timing and course/provider/country/profile dimensions where available.

Security posture remains service-role/private; observability does not confer canonical/Search/Publication mutation authority.

## Gate C — AU/NZ backlog classification

### Result: PASS FOR CURRENT RUNTIME CLASSIFICATION

Merged via PR #91:

- `20260915074500_cf_245_enrichment_reports_backlog_v1.sql`.

### Australia

- 516 missing courses currently queueable under existing URL/profile/execution-policy scope;
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

Merged via PR #91:

- `20260915082000_cf_245_field_admission_bounded_url_v1.sql`.

The bounded replay admitted only `official_course_url`, requiring exact AU CRICOS provider/course resolution, identity match, regulatory code observed in Evidence, candidate URL equal to captured Evidence URL, qualified source admission, approved Search source gate and no Layer 4 operational block.

Field-admission outcome:

- 262 official-URL decisions;
- 260 admitted canonical changes;
- 2 unchanged/idempotent outcomes;
- one additional candidate remained unadmitted because the regulatory code was not observed.

No generic tuition, intake, English or description auto-approval was introduced.

## Gate E — Search/publication reconciliation

### Result: PASS FOR BOUNDED URL PUBLICATION

The final governed Search preview contained exactly 37 changed rows and raised official-course-URL coverage to 421 without collateral intake, English, provider-current-tuition or scholarship changes. The projection was applied.

Verified current Search/consumer coverage:

- Search courses: **33,105**;
- regulatory tuition: **26,457**;
- intake coverage: **161**;
- English requirement coverage: **161**;
- official course links: **421**;
- provider-current tuition: **161**;
- website-admitted scholarships: **0**.

## Gate F — Enrichment Operations Admin reporting

### Result: IMPLEMENTED / MERGED; DEPLOYED ACCEPTANCE STILL OPEN

PR #92 merged to Pilot `main` as `f707e2d4b7221a185dcafb6ec2095ec4a94ad841`.

Implemented:

- hourly AU/NZ coverage snapshot ledger;
- rank-gated `admin_read('enrichment_operations')` bundle;
- outcome-focused Enrichment Operations reporting inside the existing Layer 2 workspace;
- coverage/backlog, hourly funnel, stop reasons, provider yield/latency, admissions, cost/units/errors and Jobs/Evidence drill-down;
- no change to Scheduled Tasks semantics, scheduler frequency/concurrency, provider routing, budgets or mutation authority.

Security targeted verification:

- rank-4 `pipeline_operator` read: PASS;
- rank-3 `curator` negative path: PASS (`pipeline_operator role required`);
- authenticated/anon direct SELECT on coverage snapshot table: denied;
- snapshot schedule: hourly at minute 7;
- Supabase Security Advisor introduced no new WARN/ERROR finding for CF-245; the new table follows the existing intentional RLS-enabled/no-policy/private-read pattern.

PR #92 final candidate CI `34905465257`: PASS. Post-merge Pilot Frontend Build `34905600072`: PASS.

## Fresh bounded measurement cohort

Fresh RMIT batch: `797da1cb-0689-4dc6-80e3-6dcf38792950`.

Outcome:

- 5 / 5 processed;
- all 5 fetched and extracted successfully;
- 15 correlated Evidence artifacts in the operational ledger;
- 20 fields targeted;
- 11 fields resolved deterministically;
- 0 retries;
- 0 acquisition/runtime blockers;
- 5 vendor units;
- recorded request cash cost USD 0;
- all 5 ended `layer3_required` with stop reason `layer3_unresolved_target_fields`;
- observed p50 response about 2.9 s and p95 response about 3.8 s;
- observed p50 extraction about 2.0 s and p95 extraction about 2.15 s.

The fresh cohort confirms the historical diagnosis: acquisition capacity is healthy; the current limiter is unresolved field/admission granularity and subsequent Layer 3 handling, not scheduler tick frequency or concurrency.

No scheduler/provider tuning is justified by this cohort.

## Deployed UAT recovery finding

Post-merge deployed UAT run `34905600101` failed on desktop. This does **not** currently demonstrate a CF-245 functional/security failure.

The deployed-UAT router selected the older permanent suite `tests/uat/m2-5-layer2-finalizer-fairness-deployed.spec.mjs` because `src/layer2-operations-entry.jsx` matched its generic route. The failing assertion expected `[data-l2-latest-terminal="true"]` in the Layer 2 Operations workspace and did not find it. The source-contract portion of that suite passed.

Classification: **UAT routing/currentness recovery required**. Do not weaken the older fairness contract or CF-245 authority boundaries merely to make the run green.

Required recovery:

1. add/select a dedicated deployed CF-245 Enrichment Operations test path;
2. reconcile the current deployed Worker/UI with Pilot `main` `f707e2d4...`;
3. rerun targeted deployed desktop UAT;
4. if a genuine CF-245 UI/runtime defect appears, fix it under the governed troubleshooting protocol;
5. only after targeted deployed UAT is green may Gate F be accepted as fully deployed.

## Gate G — evidence-led tuning

### Status: NOT AUTHORISED YET

No scheduler frequency, concurrency, paid-attempt ceiling, provider rate, routing or credential change has been made under CF-245.

The 5-course fresh cohort shows no acquisition pressure signal: no retries, no acquisition blockers and sub-4-second p95 response. The useful-field/admission bottleneck must be addressed before considering throughput tuning.

## Gate H — acceptance

CF-245 is not ready to close. Remaining acceptance includes:

- deployed CF-245 Enrichment Operations UAT route/currentness recovery and green targeted run;
- at least one real subsequent hourly snapshot so +hour velocity is based on genuine history rather than fabricated baseline;
- daily report/publication attribution after sufficient elapsed runtime;
- bounded AU expansion beyond the first qualified RMIT slice where qualification permits;
- NZ remains blocked pending source/profile/discovery/policy qualification;
- applicable targeted/bounded security/browser acceptance green;
- RUNSHEET, CURRENT-STATE, FOLLOW-UPS and NEXT-CHAT current at closure.

## Exact next action

1. Repair deployed-UAT suite routing so CF-245 changes select a dedicated Enrichment Operations deployed test instead of the older finalizer-fairness suite.
2. Verify deployed Worker/UI currentness against Pilot `main` `f707e2d4b7221a185dcafb6ec2095ec4a94ad841`.
3. Run targeted deployed desktop UAT and close only the actual defect, if any.
4. Allow hourly coverage snapshots to accumulate and verify real +hour coverage/throughput delta.
5. Continue bounded AU qualification/coverage work; keep NZ blocked until qualification exists.
6. Do not tune scheduler frequency/concurrency/provider ceilings from idle ticks or the current 5-course sample.
