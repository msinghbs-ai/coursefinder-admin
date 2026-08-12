# Coursefinder Database Architecture v2.10.2

**Status:** Authoritative architecture baseline.  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.1.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 12 August 2026

v2.10.2 retains all v2.10.1 Layer 1 identity rules and the v2.10.0 QILT/ComparED outcomes model, and generalises Layer 2A structured outcomes for Canada.

---

## 1. Unchanged boundaries

- Names/titles never act as canonical identity.
- Layer 1 owns regulatory/authoritative base Provider/Course identity.
- Layer 2A attaches authoritative structured statistics/outcomes to already-established canonical entities or to non-Provider benchmark dimensions.
- Layer 2A must not create or merge Layer 1 Provider/Course identity from names.
- Layer 3 AI remains evidence-linked suggestion only.
- Layer 4 resolves ambiguous mappings/conflicts.
- Search/comparison are derived read models.
- Internal schemas remain deny-by-default browser surfaces.

---

## 2. Global Layer 2A outcomes model

The QILT foundation becomes a reusable international structured-outcomes architecture.

Provider-specific observations remain in:
- `catalogue.provider_outcomes`

External source reconciliation remains in:
- `pipeline.source_provider_mappings`
- `ref.external_study_areas`
- `ref.external_study_area_mappings`

Survey/metric definitions remain in:
- `ref.outcome_surveys`
- `ref.outcome_metrics`

New non-Provider benchmark table:
- `catalogue.outcome_benchmarks`

`outcome_benchmarks` is required for authoritative statistics published at geography + field + credential/study-level + audience + cohort granularity where no named Provider dimension exists. Such rows must never be represented as a Provider-specific outcome.

Key benchmark dimensions:
- survey/metric;
- country;
- optional subdivision;
- optional source study area;
- optional canonical study level;
- audience;
- collection year range;
- optional years after graduation;
- value/response count;
- source/evidence;
- source-native geography/study-area/metric codes.

---

## 3. Canada Layer 2A — Postsecondary Outcomes

Canada uses a federated structured-outcomes source family rather than a single QILT-equivalent programme.

### National backbone — Statistics Canada PSIS

Primary source family:
- Statistics Canada Postsecondary Student Information System (PSIS).

Initial table:
- Table `37-10-0278-01` / PID `37100278`.

Published dimensions include institution, detailed field of study, institution/program/credential characteristics and status of student in Canada. The table is annual and is suitable for machine acquisition through Statistics Canada WDS.

Ingestion role:
- national Layer 2A structured backbone;
- institution-level graduate counts and published programme/student characteristics;
- source institution identifiers/labels reconcile through `pipeline.source_provider_mappings` to existing CA canonical Providers;
- no canonical Provider identity writes from descriptive institution names.

### National benchmark outcomes

Statistics Canada longitudinal graduate-outcome tables may publish employment-income outcomes by geography, credential, field and years after graduation without a named institution dimension.

Those rows belong in `catalogue.outcome_benchmarks`, not `catalogue.provider_outcomes`.

### Ontario

Approved Layer 2A source families:
- Ontario University Graduate Survey;
- Ontario public-college Graduate Outcomes / KPI resources.

Provider-specific published observations may populate `catalogue.provider_outcomes` only after verified source Provider -> canonical IRCC DLI Provider mapping.

### British Columbia

Approved source-discovery family:
- BC Student Outcomes.

Employment, further-study and satisfaction measures may populate `provider_outcomes` only at the exact granularity published by the source and after verified Provider mapping.

---

## 4. Source acquisition architecture

New systems/sources:
- `statcan_wds` — Statistics Canada Web Data Service;
- `on_open_data_outcomes` — Ontario Open Data postsecondary outcomes;
- `bc_student_outcomes` — BC Student Outcomes.

All are `pipeline.sources.source_type='structured_outcomes'` and carry `canonical_identity_write=false`.

New service-role-only RPC contract:
- `svc_layer2a_resolve_sources(...)`;
- `svc_layer2a_start_job(...)`;
- `svc_layer2a_finish_job(...)`;
- `svc_layer2a_record_evidence(...)`;
- `svc_layer2a_source_health(...)`.

`PUBLIC`, `anon` and `authenticated` execution is denied; `service_role` is explicit.

---

## 5. Statistics Canada worker

Worker:
- `statcan-ca-psis-etl`
- initial version: `v0.1.0`
- `verify_jwt=true`
- Platform Admin authorisation required.

Initial acquisition behaviour:
1. resolve configured CA Layer 2A source;
2. call Statistics Canada WDS `getCubeMetadata/37100278`;
3. call `getFullTableDownloadCSV/37100278/en`;
4. download the returned full-table ZIP;
5. calculate SHA-256;
6. store the raw ZIP in private evidence storage;
7. record evidence/job/source-health metadata;
8. perform no canonical outcome APPLY.

`apply=true` remains hard blocked until parser/mapping UAT is accepted.

Next worker version must parse the full-table CSV, preserve source dimensions/codes, create candidate Provider mappings, establish CIP/study-level mappings, and only then support bounded outcome APPLY.

---

## 6. Security and evidence

- `catalogue.outcome_benchmarks`: RLS enabled; no `anon/authenticated` direct access; service role explicit.
- Layer 2A service RPCs: service-role only.
- Evidence bucket accepts `application/zip` because StatsCan WDS full-table CSV resources are delivered as ZIP archives.
- Raw source files remain immutable evidence; parsed/staged representations are not substitutes for source evidence.
- Provider mappings must be verified before Provider-specific outcome publication.

---

## 7. New production migrations

Applied to Mumbai Pilot and committed to Admin governance:
- `046_ca_postsecondary_outcomes_foundation.sql`
- `047_ca_layer2a_service_contract.sql`
- `048_ca_layer2a_evidence_zip_mime.sql`

These extend migrations 044/045; they do not replace the QILT model.

---

## 8. Gate sequence

CA Layer 2A is a parallel Phase 3A workstream and does not alter the CA Layer 1 production gate.

Layer 2A CA gates:
1. source discovery/acquisition;
2. parser/schema validation;
3. source Provider mapping to canonical DLI Providers;
4. study-area/CIP and study-level crosswalk;
5. bounded dry-run;
6. bounded APPLY;
7. idempotency/duplicate/orphan/temporal checks;
8. benchmark-vs-Provider granularity validation;
9. curated Admin/API comparison projection;
10. production acceptance.

Consumer exposure is prohibited until those gates pass.
