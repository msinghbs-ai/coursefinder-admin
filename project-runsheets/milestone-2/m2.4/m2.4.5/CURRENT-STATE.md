# M2.4.5 CURRENT STATE

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 CLOSED / PASS; CF-245 ENRICHMENT OPERATIONS ACTIVE  
**Reconciled:** 2026-09-15 AEST  
**Accepted Pilot main:** `7196c5d2fade8830ec371c663b008e8a47e01f74`  
**Visible accepted release:** v2.15.79 / package 0.1.6  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 remains PAUSED at P0

## CF-093 final disposition

`CF-CHG-20260910-093` remains CLOSED / PASS / HISTORICAL ONLY. It must not be reopened for country/source onboarding, provider expansion, operational tuning or defects.

## Active workstream

`CF-CHG-20260915-245` — M2.4.5 Enrichment Operations, Metrics & Coverage Expansion — is OPEN / PLAN ACCEPTED / IMPLEMENTATION PENDING.

Purpose: separate scheduler health from enrichment outcome, make the real enrichment funnel observable, create governed AU/NZ backlog/work demand, reconcile acquisition through publication, and produce meaningful hourly/daily reporting before evidence-led tuning.

## Reconciled live findings — 15 September 2026

- Scheduler/cron infrastructure is healthy and repeatedly executing.
- 245 successful `layer2_acquisition_v2` / `course_facts` jobs occurred in the inspected prior 24 hours.
- Those 245 jobs all reported changed content, Evidence creation and screenshot Evidence creation.
- Zero of those 245 reported `canonical_mutation_authorised = true`.
- The same execution path produced no `layer2_run_items` rows in the inspected period, leaving field-level resolution/yield telemetry incomplete.
- 3,059 Layer 2 source profiles exist; approximately 933 active course-facts website profiles, 955 scholarship-catalogue profiles, 955 provider-asset website profiles and 210 scholarship website profiles.
- Layer 2 refresh-policy coverage remains narrow: 10 policies total, 8 enabled, zero due at inspection; effectively AU-only coverage at that layer.
- 50 Layer 2 execution policies exist and are enabled; one was due at inspection.
- Scheduler frequency is already sufficient; frequency/concurrency is not the first tuning lever.

## Website/consumer coverage baseline for CF-245

- Search courses: 33,105.
- Regulatory tuition: 26,457.
- Intake coverage: 10.
- English requirement coverage: 10.
- Official course links: 10.
- Provider-current tuition: 10.
- Website-admitted scholarships: 0.

These counts must not be represented as “all missing data is being populated”. The scheduler is healthy, acquisitions are occurring, but enrichment admission/publication coverage is not yet scaling materially.

## Accepted authority baseline

- Layer 1 identity/regulatory authority unchanged.
- Layer 2 remains deterministic, Evidence-preserving and fail-closed.
- Exact Preview token/fingerprint/binding/identity provenance remains enforced where applicable.
- Generic scheduler Layer 3 auto-approval remains prohibited.
- Layer 4 human authority remains separate.
- Search/Publication remains separately governed.
- Rank/ACL/RLS/private-helper/service-role boundaries retained.
- Applied migration history remains immutable and forward-only.

## Current operational interpretation

The current bottleneck is not scheduler liveness. It is the combination of:

1. incomplete work-demand/backlog generation across AU/NZ;
2. incomplete telemetry on the active acquisition path;
3. insufficient visibility into why acquired Evidence does not progress to authorised canonical enrichment;
4. incomplete reconciliation from extracted/admitted facts to Search/website-visible coverage.

## Exact next gate

1. Reconcile the 245 recent acquisition jobs across attempts, Evidence, extraction/candidate/admission and publication stores.
2. Count exact `canonical_mutation_authorised=false` causes.
3. Wire the real path into common batch/item telemetry.
4. Produce the first real hourly enrichment funnel report.
5. Only after comparable observations exist, expand AU/NZ demand and tune throughput.

M2.4.4 remains CLOSED/PASS/FROZEN. M2.5 remains paused unless separately authorised.
