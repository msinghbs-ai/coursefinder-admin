# Coursefinder — Canada Layer 2A Postsecondary Outcomes Source Discovery UAT v1.0

**Date:** 12 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.2.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.3.md`  
**Running build:** `docs/coursefinder-running-build-v2.4.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Gate result:** **FOUNDATION PASS / SOURCE-RUNTIME PARSER GATE PENDING**

## 1. Objective

Establish a Canadian equivalent to the AU QILT Layer 2A structured-outcomes workstream without changing Layer 1 Provider/Course identity.

## 2. Source findings

### Statistics Canada PSIS — accepted national backbone

Official source:
- Statistics Canada Postsecondary Student Information System.
- Table `37-10-0278-01` / PID `37100278`.
- Annual table.
- Published dimensions include detailed field of study, institution, institution/program/credential characteristics and status of student in Canada.
- Statistics Canada WDS supports cube metadata plus full-table CSV/SDMX downloads.

Accepted role:
- national Layer 2A structured backbone;
- Provider-specific rows only after verified source institution -> canonical DLI Provider mapping;
- no canonical identity writes from source names.

### Statistics Canada longitudinal graduate outcomes — accepted benchmark candidate

Where the source publishes geography + field + credential/study-level + years-after-graduation without named Provider, values must be stored as `catalogue.outcome_benchmarks`, never `catalogue.provider_outcomes`.

### Ontario — accepted provincial source family

Ontario University Graduate Survey:
- annual government dataset;
- graduates surveyed two years after graduation;
- includes employment outcomes at six months and two years;
- machine-readable XLSX resource exists.

Ontario public-college graduate outcomes/KPIs are also accepted for later source-specific UAT.

### British Columbia — accepted source-discovery family

BC Student Outcomes:
- annual former-student outcomes;
- employment, further education and satisfaction;
- exact machine-readable resource/granularity must be validated before APPLY.

## 3. Database implementation

New object:
- `catalogue.outcome_benchmarks`

New source-family seeds only:
- `statcan_psis`
- `statcan_grad_longitudinal`
- `on_university_graduate_survey`
- `on_college_kpi`
- `bc_student_outcomes`

New systems/sources:
- `statcan_wds`
- `on_open_data_outcomes`
- `bc_student_outcomes`

All configured CA outcome sources have:
- Layer `2A`;
- canonical identity writes disabled;
- Provider mapping required where Provider-specific observations are expected.

No outcome metric rows or observations were fabricated.

## 4. Service/security contract

New service-role-only functions:
- `svc_layer2a_resolve_sources`
- `svc_layer2a_start_job`
- `svc_layer2a_finish_job`
- `svc_layer2a_record_evidence`
- `svc_layer2a_source_health`

Verified:
- `anon` execute: denied;
- `authenticated` execute: denied;
- `service_role` execute: allowed.

`catalogue.outcome_benchmarks`:
- RLS enabled;
- `anon/authenticated` direct SELECT denied.

Security Advisor:
- new table produces only expected internal `rls_enabled_no_policy` INFO;
- no new externally exposed write surface was introduced.

## 5. Worker

Worker:
- `statcan-ca-psis-etl`
- version `statcan-ca-psis-etl-v0.1.0`
- `verify_jwt=true`
- Platform Admin authorisation required.

Deployment:
- Supabase function version: `1`
- SHA-256: `3658085a2dfb6d5cd6142e1922423543ae9e1b818417bcb3b1adcb1dc6b3f1c8`
- Pilot commit: `07065683ac86936a5ebbc04c2095dcb9f969224f`

Designed dry-run acquisition:
1. WDS cube metadata;
2. WDS full-table CSV download link;
3. raw ZIP download;
4. SHA-256;
5. private evidence storage;
6. evidence/job/source-health records.

`apply=true` returns HTTP 409 until parser/mapping UAT is accepted.

## 6. Migration/performance UAT

Applied migrations:
- `ca_postsecondary_outcomes_foundation`
- `ca_layer2a_service_contract`
- `ca_layer2a_evidence_zip_mime`
- `ca_identity_outcomes_fk_index_hardening`

Reproducible Admin migrations:
- `046_ca_postsecondary_outcomes_foundation.sql`
- `047_ca_layer2a_service_contract.sql`
- `048_ca_layer2a_evidence_zip_mime.sql`
- `049_ca_identity_outcomes_fk_index_hardening.sql`

Performance Advisor initially identified missing covering indexes in the recent CA identity/outcomes additions. Migration 049 remediated them. Re-run shows no remaining unindexed-FK notices for those additions; unused-index INFO is expected before workload population.

## 7. Test matrix

| Test | Result | Finding |
|---|---|---|
| Canada QILT-equivalent source discovery | **PASS** | StatsCan national backbone + ON/BC richer provincial outcome sources established |
| StatsCan authority | **PASS** | Official Statistics Canada PSIS table/WDS |
| Source configuration | **PASS** | CA structured-outcomes sources registered |
| Provider identity isolation | **PASS** | Layer 2A canonical identity writes explicitly disabled |
| Provider mapping design | **PASS** | Reuses `pipeline.source_provider_mappings` |
| Benchmark granularity design | **PASS** | Non-Provider outcomes separated into `outcome_benchmarks` |
| Evidence design | **PASS** | WDS ZIP evidence supported with SHA-256/private storage |
| Worker deployment | **PASS** | JWT-protected worker deployed |
| Service RPC security | **PASS** | service-role only |
| FK performance hardening | **PASS** | missing covering indexes remediated |
| Authenticated StatsCan runtime acquisition | **PENDING** | Requires live Platform Admin invocation; no admin JWT is exposed through the management connector used for this UAT session |
| CSV parser/schema validation | **PENDING** | Must follow successful runtime acquisition |
| Provider mapping UAT | **PENDING** | Must inspect source institution dimensions/keys first |
| CIP/study-level crosswalk | **PENDING** | Parser-dependent |
| Outcome APPLY/idempotency | **BLOCKED BY DESIGN** | `apply=true` disabled until parser/mapping gate passes |
| Consumer/API comparison | **NOT STARTED** | Requires accepted canonical observations/benchmarks |

## 8. Decision

**FOUNDATION PASS.** Canada has an approved Layer 2A structured-outcomes architecture analogous to AU QILT but implemented as a federated source family.

Statistics Canada PSIS is the national backbone. Ontario and BC provide richer provincial outcomes where their published granularity supports Provider/study-area observations. Non-Provider Statistics Canada cohort outcomes are stored as benchmarks, not misrepresented as Provider outcomes.

The next controlled gate is authenticated StatsCan acquisition followed by exact CSV schema/parser and Provider-mapping UAT. Canonical outcome APPLY remains disabled until that gate passes.

This workstream is parallel to CA Layer 1 and does not change the Layer 1 country sequence or resolve the CA federated Course-source coverage blocker.
