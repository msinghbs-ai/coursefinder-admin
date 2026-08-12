# Coursefinder — Canada Layer 2A Postsecondary Outcomes Parser UAT v1.1

**Date:** 12 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.2.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.4.md`  
**Running build:** `docs/coursefinder-running-build-v2.5.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Gate result:** **PARSER IMPLEMENTED / AUTHENTICATED RUNTIME UAT PENDING**

## 1. Scope

Advance Statistics Canada PSIS from source-acquisition-only worker to a bounded parser/mapping-diagnostic worker without enabling canonical Layer 2A APPLY.

Official source remains Statistics Canada PSIS table `37-10-0278-01` / PID `37100278`.

The published table is annual and includes institution, detailed field of study, program type, credential type, status of student in Canada and gender. Institution data in this series are reported at parent level with documented exceptions; therefore the Statistics Canada institution dimension is an external Layer 2A entity and must be mapped to an existing canonical IRCC DLI Provider before Provider-specific outcomes can be written.

## 2. Worker v0.2.0

Function: `statcan-ca-psis-etl`  
Worker version: `statcan-ca-psis-etl-v0.2.0`  
Supabase function version: `2`  
Deployment SHA-256: `544b7d99bf86914d3f66ff7c88197ca9c871694682fde64b76f9730b57413464`  
JWT verification: enabled  
Platform Admin authorisation: required

Pilot commit:
- `3ed44da1772828b25f0527c2b26144ae0706999e`

New behaviour:
1. fetch WDS cube metadata;
2. resolve full-table CSV ZIP URL;
3. download ZIP and record SHA-256 private evidence;
4. unzip the source package;
5. select the data CSV, excluding metadata CSV entries;
6. parse a bounded sample (`sampleRows`, max 5,000);
7. validate `REF_DATE`, `VALUE` and institution/geography dimension presence;
8. collect source-side institution candidates;
9. collect field-of-study, credential and student-status samples;
10. return mapping diagnostics only.

`apply=true` remains hard blocked with HTTP 409.

## 3. Mapping rule

Source-side institution candidates use the Statistics Canada coordinate/member reference where available. The institution label is retained as candidate-matching metadata only.

A PSIS institution may populate `catalogue.provider_outcomes` only after a verified row exists in `pipeline.source_provider_mappings` pointing to an existing canonical CA Provider established from IRCC DLI identity.

PSIS may never:
- create a Provider from its institution label;
- merge Providers by name;
- create/modify Layer 1 Course identity.

## 4. Pilot client route

`src/lib/supabase.js` now exposes:

`runLayer2AStatsCan({ apply=false, sampleRows=1000 })`

Pilot commit:
- `cee10a81c8632645cdcf0d573c273f18718e3023`

This allows an authenticated Pilot Admin session to invoke the JWT-protected worker without adding a public/test authentication bypass.

## 5. Source metadata

Statistics Canada PSIS source metadata now records:
- `worker_version=statcan-ca-psis-etl-v0.2.0`;
- `parser_gate=implemented_pending_authenticated_runtime_uat`;
- `sample_row_cap=5000`;
- `apply_enabled=false`;
- source-side candidate mapping with verified IRCC DLI target required.

## 6. UAT matrix

| Test | Result | Finding |
|---|---|---|
| Official source contract | **PASS** | PSIS table/WDS confirmed |
| Parser implementation | **PASS — code/deployment** | ZIP/CSV parser deployed as function v2 |
| Bounded parsing | **PASS — implementation** | `sampleRows` bounded to max 5,000 |
| Required-header guard | **PASS — implementation** | Worker blocks if required source columns are absent |
| Provider identity isolation | **PASS** | PSIS cannot create/merge canonical Provider identity |
| Mapping diagnostics | **PASS — implementation** | source institution candidates emitted for mapping review |
| Private evidence | **PASS** | source ZIP + SHA-256 evidence retained |
| JWT / Platform Admin | **PASS — deployment** | `verify_jwt=true` and application authorisation retained |
| Client authenticated route | **PASS** | Pilot API helper added |
| Canonical APPLY | **BLOCKED BY DESIGN** | remains disabled |
| Authenticated live parser run | **PENDING** | requires execution from a signed-in Platform Admin session; management connector does not expose the interactive JWT |
| Exact source schema acceptance | **PENDING RUNTIME** | must inspect first worker v0.2.0 result |
| Provider-to-DLI mapping UAT | **PENDING** | follows live parser result |
| CIP/study-level crosswalk | **PENDING** | follows live parser result |
| APPLY/idempotency/integrity | **NOT PERMITTED YET** | dependent on mapping/crosswalk acceptance |

## 7. Decision

**Parser implementation gate = PASS. Runtime parser UAT remains pending.**

No canonical outcome observations or benchmarks have been inserted by this change. The next accepted action is one authenticated dry-run from the Pilot Admin session, followed by review/persistence of source Provider mappings and field/study-level transformations.

CA Layer 1 remains independent and still blocked on federated Course-source coverage.
