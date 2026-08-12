# Coursefinder Running Build v2.4

**Date:** 12 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.2.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.3.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE / blocked on federated Course-source coverage; GB/US/IE queued; DE deferred/blocked.
- CA Layer 1 identity architecture remains resolved.
- Phase 3A now has two parallel structured-outcomes streams:
  - AU QILT/ComparED;
  - CA Postsecondary Outcomes.
- Phase 7 hardening continues.

## CA Layer 2A source model

Configured structured-outcome sources:

1. `statcan_wds` / Statistics Canada PSIS
   - source label: `Statistics Canada PSIS / Postsecondary Graduates`
   - PID: `37100278`
   - table: `37-10-0278-01`
   - role: national structured backbone
   - Provider mapping required: yes
   - canonical identity write: no

2. `on_open_data_outcomes`
   - source label: `Ontario Postsecondary Graduate Outcomes`
   - role: provincial Provider outcomes
   - canonical identity write: no

3. `bc_student_outcomes`
   - source label: `BC Student Outcomes`
   - role: provincial Provider outcomes
   - canonical identity write: no

Seeded source-family definitions only:
- `statcan_psis`
- `statcan_grad_longitudinal`
- `on_university_graduate_survey`
- `on_college_kpi`
- `bc_student_outcomes`

No CA outcome metric definitions or observations have been fabricated or loaded.

## New database object

`catalogue.outcome_benchmarks`

Purpose:
- preserve authoritative outcome statistics with no named Provider dimension;
- support country/subdivision + field/study area + study level/credential + audience + period + years-after-graduation dimensions;
- prevent geography/cohort statistics from being mislabeled as Provider-specific outcomes.

Provider-specific observations remain in `catalogue.provider_outcomes`.

## Layer 2A service contract

New service-role-only RPCs:
- `svc_layer2a_resolve_sources`
- `svc_layer2a_start_job`
- `svc_layer2a_finish_job`
- `svc_layer2a_record_evidence`
- `svc_layer2a_source_health`

Privilege UAT:
- `anon`: no execute
- `authenticated`: no execute
- `service_role`: execute

`catalogue.outcome_benchmarks`:
- RLS enabled;
- no direct `anon`/`authenticated` read;
- service-role ingestion explicit.

## StatsCan worker

Worker: `statcan-ca-psis-etl`  
Version: `statcan-ca-psis-etl-v0.1.0`  
Supabase function version: `1`  
Deployment SHA-256: `3658085a2dfb6d5cd6142e1922423543ae9e1b818417bcb3b1adcb1dc6b3f1c8`  
JWT verification: enabled.

Pilot Git commit:
- `07065683ac86936a5ebbc04c2095dcb9f969224f`

Current behaviour:
1. Platform Admin authentication;
2. resolve configured StatsCan Layer 2A source;
3. request WDS cube metadata for PID `37100278`;
4. request full-table CSV download URL;
5. download ZIP;
6. SHA-256 raw source;
7. store ZIP in private evidence storage;
8. record Layer 2A job/evidence/source health;
9. return acquisition metadata.

`apply=true` is deliberately blocked until parser/mapping UAT passes.

## Applied migrations

Supabase migration history:
- `20260812120513 ca_postsecondary_outcomes_foundation`
- `20260812120555 ca_layer2a_service_contract`
- `20260812120641 ca_layer2a_evidence_zip_mime`
- `ca_identity_outcomes_fk_index_hardening` — applied after Performance Advisor review.

Admin reproducible migration files:
- `046_ca_postsecondary_outcomes_foundation.sql`
- `047_ca_layer2a_service_contract.sql`
- `048_ca_layer2a_evidence_zip_mime.sql`
- `049_ca_identity_outcomes_fk_index_hardening.sql`

Performance Advisor after 049 reports no remaining unindexed-foreign-key notices for the recent CA identity/outcomes additions. New indexes appear as expected unused-index INFO before workload population.

Security Advisor reports the expected `rls_enabled_no_policy` INFO for the new internal deny-by-default table. Existing authenticated UI SECURITY DEFINER warnings and leaked-password protection warning remain pre-existing Phase 7 items.

## Source verification

Statistics Canada officially exposes WDS methods including:
- `getCubeMetadata`
- `getFullTableDownloadCSV`
- `getFullTableDownloadSDMX`

Table `37-10-0278-01` is annual and publishes postsecondary graduates by detailed field of study, institution, program/credential characteristics and status of student in Canada.

Ontario University Graduate Survey is an annual government dataset covering employment outcomes at six months and two years after graduation.

BC Student Outcomes annually covers employment, further education and education satisfaction for former post-secondary students.

## Current UAT boundary

Passed:
- authoritative source discovery;
- database model and source configuration;
- JWT-protected worker deployment;
- private evidence design;
- service-role privilege boundary;
- post-DDL FK-index hardening;
- no fabricated metrics/observations;
- no Layer 1 identity writes.

Pending:
- authenticated Platform Admin runtime invocation of `statcan-ca-psis-etl`;
- full-table ZIP/CSV parser validation in Supabase runtime;
- source institution key inspection/mapping to canonical CA DLI Providers;
- CIP/study-level mapping;
- bounded dry-run/APPLY/idempotency/integrity;
- longitudinal benchmark ingestion;
- Ontario/BC adapters;
- curated comparison projection/API.

## Current next step

**Run authenticated StatsCan PSIS acquisition UAT, inspect the authoritative full-table CSV schema, then implement parser + candidate Provider mapping with canonical APPLY still disabled.**

This Phase 3A work remains parallel and does not change the active CA Layer 1 production gate sequence.
