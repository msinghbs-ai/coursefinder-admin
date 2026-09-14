# CF-CHG-20260915-245 — M2.4.5 Enrichment Operations, Metrics & Coverage Expansion

**Status:** OPEN / PLAN ACCEPTED — IMPLEMENTATION PENDING  
**Milestone:** M2.4.5 — Pre-Production Hardening  
**Opened:** 15 September 2026 AEST  
**Primary category:** 40-layer2-enrichment  
**Related surfaces:** 30-admin-pim-ux, 50-search-api-consumers, 70-security-platform, 80-uat-release-operations  
**Historical baseline:** CF-CHG-20260910-093 CLOSED / PASS; do not reopen  
**Accepted Pilot baseline:** `7196c5d2fade8830ec371c663b008e8a47e01f74` / v2.15.79 / package 0.1.6  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 remains PAUSED at P0

## Objective

Make CourseFinder enrichment operationally measurable and progressively expand governed AU/NZ enrichment coverage without weakening Layer 1 identity, Evidence, security, Layer 3/4 authority or Search/Publication admission rules.

The scheduler must report not only whether timers fired, but whether real work was eligible, queued, acquired, extracted, admitted and published, with field-level coverage growth and failure/admission reasons visible by hour and day.

## Reconciled findings at opening

Live Pilot inspection on 15 September 2026 showed:

- scheduler/cron infrastructure healthy and repeatedly executing;
- 245 successful `layer2_acquisition_v2` / `course_facts` jobs in the prior 24 hours;
- all 245 reported changed content and Evidence creation;
- all 245 created screenshot Evidence;
- zero of those 245 reported `canonical_mutation_authorised = true`;
- no `layer2_run_items` rows were produced for that execution path during the same period;
- 3,059 Layer 2 source profiles exist, including approximately 933 active course-facts website profiles, 955 scholarship-catalogue profiles, 955 provider-asset website profiles and 210 scholarship website profiles;
- refresh-policy coverage remains narrow: 10 Layer 2 refresh policies, 8 enabled, with zero due at the inspected moment and policy coverage effectively AU-only;
- 50 Layer 2 execution policies exist and are enabled; at inspection one was due;
- scheduler frequency is already high enough that increasing cron frequency is not the first tuning action.

Website-visible coverage baseline supplied/reconciled for this workstream:

- Search courses: 33,105;
- regulatory tuition: 26,457;
- intake coverage: 10;
- English requirement coverage: 10;
- official course links: 10;
- provider-current tuition: 10;
- website-admitted scholarships: 0.

The material bottleneck is therefore not scheduler liveness. It is incomplete demand generation plus insufficient end-to-end telemetry and an acquisition → extraction/admission/publication gap.

## Standing authority boundaries

This Change Control must preserve:

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

## Work plan

### Gate A — Measurement contract and baseline

Build one operational measurement contract covering the full enrichment funnel:

`missing/stale/due → eligible → queued → started → acquired → extracted → admitted/unchanged/rejected → Layer 3 escalation → Layer 4 review → Search/Publication admitted`.

Required hourly and daily dimensions:

- country;
- state/subdivision where relevant;
- provider/university;
- course/entity;
- source profile/version;
- acquisition provider/route;
- workflow/job type;
- field/domain.

Required metrics:

- backlog/missing/stale/due/queueable/excluded;
- queue wait and execution latency;
- started/succeeded/failed/retried/terminal counts;
- provider response and extraction p50/p95;
- Evidence and screenshot-Evidence counts/bytes;
- fields targeted/resolved/admitted/unchanged/rejected;
- admission/rejection/block reason;
- Layer 3 escalations and Layer 4 referrals;
- HTTP 429/5xx/error rates;
- provider/vendor units and cost;
- courses/entities improved;
- Search/website publication delta;
- starting coverage, additions, ending coverage and remaining gap per governed field.

Acceptance: a one-hour and one-day report can explain where every material unit of work stopped or progressed.

### Gate B — Telemetry wiring

Reconcile all active Layer 2 acquisition paths to a common execution ledger. Either populate governed `layer2_run_batches` / `layer2_run_items` consistently or introduce an explicitly governed equivalent without duplicating semantic ownership.

The existing item-level measurements (`fields_targeted`, `fields_resolved`, Evidence count, vendor units/cost, retry/failure/outcome, response/extraction time, Evidence bytes) must be populated by the real scheduled execution path.

Expose `canonical_mutation_authorised=false` reason codes. At minimum distinguish:

- capture-only;
- extraction not invoked;
- no eligible target field;
- identity mismatch;
- unchanged source/fact;
- confidence/authority gate;
- Preview/binding restriction;
- Layer 3 required;
- Layer 4 required;
- publication not eligible;
- runtime/provider/budget/credential blocker.

Acceptance: the current class of “245 acquisitions, 245 Evidence, zero canonical mutations” can be decomposed into explicit, countable causes.

### Gate C — Demand/backlog generation

Create governed enrichment demand from actual missing/stale coverage rather than relying only on sparse refresh policies.

For AU and NZ, calculate per-field backlog for at least:

- official course URL;
- intake availability;
- English requirements;
- provider-current international tuition;
- scholarships where eligible;
- other already-governed Layer 2 facts as applicable.

Demand generation must respect source/profile availability, country/source qualification, freshness policy, identity and Evidence rules. Missing source support is reported as a coverage blocker, not manufactured as data.

Acceptance: every missing/stale fact is classified as queueable, blocked-with-reason, not-applicable or awaiting source/profile qualification.

### Gate D — AU/NZ operational coverage expansion

Expand refresh/work policies from pilot-sized coverage to governed AU/NZ country/provider/course cohorts in bounded waves.

Use country → state/subdivision → provider → course scoping. Preserve rate limits, provider budgets, credentials and route policy. Start with representative bounded cohorts, prove telemetry, then expand.

NZ source limitations or provider-specific exceptions must remain explicit; do not treat AU routing assumptions as universal.

Acceptance: recurring work queues exist for approved AU/NZ cohorts and produce measurable coverage movement rather than green no-op ticks.

### Gate E — Enrichment admission and publication reconciliation

Trace acquired Evidence through deterministic extraction and governed admission. Verify that accepted Layer 2 facts reach the intended canonical/source-backed fact stores and only then the Search/publication admission boundary.

Track independently:

- acquired Evidence;
- extracted candidate facts;
- canonical/source-backed admitted facts;
- Search-admitted facts;
- website/API-visible fields.

Acceptance: coverage deltas can be reconciled from source Evidence to consumer-visible output without bypassing Layer 3/4/publication authority.

### Gate F — Admin operational reporting

Provide an Admin Enrichment Operations view or equivalent governed report with:

1. current backlog / due / queued / processing / Evidence / admitted / published / failed;
2. field coverage table showing start, +hour/+day, current, percentage and remaining gap;
3. hourly throughput trend;
4. provider/source yield and latency;
5. admission/rejection/blocker reasons;
6. retries, 429/5xx/runtime errors;
7. cost/vendor-unit efficiency;
8. drill-down to jobs and Evidence.

Scheduled Tasks remains scheduler configuration/health. Enrichment Operations reports business/data outcome; do not conflate the two.

Acceptance: an administrator can answer “what enriched this hour/day, where did it stop, what changed on the website, and why?” without direct SQL.

### Gate G — Evidence-led tuning

Do not tune simply because timers are idle. Tune only after comparable governed observations exist.

Prioritised levers:

1. demand/backlog eligibility;
2. profile/source routing quality;
3. batch/wave size;
4. max concurrency;
5. retry/backoff/stale thresholds;
6. provider routing strategy;
7. paid-attempt/vendor-unit/cost ceilings;
8. Layer 3 handoff rules only within separately accepted governance.

Measure before/after using:

- useful facts admitted per 100 acquisitions;
- courses improved per hour/day;
- p50/p95 latency;
- error/retry rate;
- cost per admitted useful fact;
- Evidence bytes/storage growth;
- publication delta;
- remaining backlog velocity.

All behavioural tuning must create `layer2_tuning_events` or equivalent governed audit evidence with reason, before/after policy and Change Control reference.

### Gate H — Acceptance and steady-state reporting

Run bounded representative AU/NZ workloads and produce at least:

- hourly operational report;
- daily coverage report;
- field-level enrichment funnel;
- provider/source performance report;
- cost/yield report;
- blocker/failure report;
- security/authority verification;
- rollback/reversion evidence for material changes.

Do not claim full AU/NZ population until coverage counts and consumer-visible results prove it.

## Initial report contract

Hourly report should include:

- eligible, queued, fetched, fetch failures;
- Evidence created;
- extraction attempted;
- official URLs/intakes/English/current tuition/scholarships found;
- facts admitted/unchanged/rejected;
- Layer 3/Layer 4 counts;
- courses improved;
- website-visible deltas by field;
- cost/units;
- p50/p95 latency;
- 429/5xx/other errors.

Daily report should add:

`starting coverage → added today → ending coverage → coverage % → remaining gap → blocked/not-queueable → recent velocity`.

ETA may only be shown after representative multi-period throughput exists; it must be clearly derived, not invented.

## Exact first implementation action

1. Reconcile the 245 successful recent `layer2_acquisition_v2/course_facts` jobs against provider attempts, Evidence, extraction/candidate/admission stores and Search/publication outputs.
2. Identify and count the exact causes of `canonical_mutation_authorised=false`.
3. Wire that execution path into the common item/batch telemetry contract.
4. Produce the first real hourly funnel report before changing dispatcher concurrency/frequency.

## Completion criteria

This Change Control can close only when:

- scheduler health and enrichment outcome are separately observable;
- real active execution paths produce field-level telemetry;
- AU/NZ missing/stale demand is classified and queueable where valid;
- bounded AU/NZ enrichment demonstrates measurable coverage growth;
- admission/publication deltas reconcile to Evidence;
- Admin can see meaningful hourly/daily reports;
- tuning is evidence-led and audited;
- applicable CI/UAT/security gates are green;
- RUNSHEET, CURRENT-STATE, FOLLOW-UPS and NEXT-CHAT are reconciled.
