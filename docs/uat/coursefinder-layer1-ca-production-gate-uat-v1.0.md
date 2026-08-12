# Coursefinder — Layer 1 Canada Production Gate UAT v1.0

**Date:** 12 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.9.1.md`  
**Programme governance:** `docs/coursefinder-master-project-plan-v1.0.md`  
**Pilot repository:** `msinghbs-ai/Coursefinder-Pilot`  
**Pilot project:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`, Mumbai / `ap-south-1`)  
**Gate result:** **BLOCKED — PROVEN SOURCE/COURSE-IDENTITY BLOCKER; NO CANONICAL APPLY PERMITTED**

## 1. Objective

Replace the legacy CA seed/snapshot path with authoritative live Canadian acquisition and prove the v2.9.1 Layer 1 production contract: stable non-name Provider and Course identity, bounded execution, evidence/provenance, APPLY/idempotency/integrity, Search Projection, security and performance.

## 2. Authoritative source findings

### Provider authority — PASS

Primary source: Immigration, Refugees and Citizenship Canada (IRCC), Designated Learning Institutions list.

IRCC confirms that a post-secondary institution must be designated by its province/territory to host international students and that IRCC creates a DLI number when the institution is enrolled. The public DLI register exposes DLI number, institution name, province/territory, city/campus and public/private status.

Accepted Provider identity candidate:

`CA + ircc_dli + DLI number`

The DLI number is regulator/source issued and is not derived from the institution name.

### Course/programme authority — BLOCKED

The IRCC DLI register is not a complete Canada-wide course catalogue. IRCC detail pages may list selected PGWP-eligible programmes by descriptive title, but the public representation does not expose a stable regulator/source programme identifier suitable for the v2.9.1 Course identity contract.

Ontario publishes an authoritative public-college programme table with stable Approved Program Sequence (APS) codes and ministry programme coding. This is valid evidence that a federated provincial source model is technically possible, but the Ontario dataset covers only Ontario public colleges and therefore cannot satisfy a Canada-wide Layer 1 production gate by itself.

No Canada-wide authoritative programme register with stable programme identifiers was identified during this gate.

Required Course identity remains:

`Provider + registration_scheme + stable regulator/source course code`

Programme title, provider name, URL slug, row hash or synthetic name-based key is prohibited as Course identity.

## 3. Pilot implementation

A dedicated production-gate worker was added:

- Function: `layer1-ca-live`
- Worker version: `layer1-ca-live-v1.0.0`
- `verify_jwt=true`
- Platform Admin authorisation retained.
- Live source: configured `ca_ircc_dli` / IRCC DLI page.
- Live HTML evidence is stored privately with SHA-256 lineage.
- DLI rows are parsed and deduplicated by DLI number.
- Bounded `offset` / `batchSize` / `nextOffset` / `hasMore` semantics are implemented.
- Provider identity is explicitly DLI-number based.
- `apply=true` is hard blocked while stable/complete Course authority is unresolved.

Pilot client routing was changed so CA invokes `layer1-ca-live` rather than the general `layer1-register-etl` seed/snapshot path.

Pilot commits:

- `959d794feee6cd1da563e79e71658ed6db8d4bde` — add live IRCC CA gate worker.
- `d5cfbbc9729efc8129161c4e25bbb961772afa7b` — route CA Admin execution to live worker.

Deployed Edge Function:

- Supabase function: `layer1-ca-live`
- Version: 1
- Deployment SHA-256: `114be53dda2650efe2336ce3222fd5c018e67da6d3473918069abc96a68d33a0`
- JWT verification: enabled.

The CA source metadata in Mumbai now records:

- `production_route=layer1-ca-live`
- `seed_snapshot=false`
- `provider_identity=IRCC DLI number`
- `course_catalogue_authoritative_coverage=false`
- `course_gate_blocked=true`

## 4. UAT results

| Test | Result | Evidence / finding |
|---|---|---|
| Authoritative Provider source | **PASS** | IRCC DLI is the federal public register for designated post-secondary institutions. |
| Stable Provider identity | **PASS** | DLI number is IRCC-issued; names are descriptive only. |
| Live CA acquisition path | **PASS — provider scope** | Dedicated live IRCC worker deployed; CA Admin route no longer uses seed snapshot. |
| Evidence/provenance design | **PASS** | Worker records raw live HTML in private evidence storage with SHA-256. |
| Bounded/resumable contract | **PASS — implementation** | `offset`, bounded `batchSize` (max 500), `nextOffset`, `hasMore`. |
| Full authoritative Course coverage | **FAIL / BLOCKER** | IRCC is not a full programme catalogue; no Canada-wide stable programme-code source proven. |
| Stable Course identity | **FAIL / BLOCKER** | Descriptive programme names cannot satisfy v2.9.1 identity. |
| APPLY | **BLOCKED BY DESIGN** | Worker returns a CA course-identity/source blocker and performs no canonical writes. |
| Idempotency | **NOT EXECUTED** | Canonical APPLY is prohibited until Course authority is resolved. |
| Canonical integrity | **PASS — protected state** | CA remains 0 Providers / 0 Provider Registrations / 0 Courses / 0 Course Registrations. |
| Search Projection | **PASS — protected state** | CA Search Documents remain 0; no invalid projection created. |
| Security | **PASS — design/deployment** | `verify_jwt=true`; Platform Admin check retained; service-role used only inside worker. |
| Performance | **PARTIAL / NOT GATEABLE** | Live fetch/parser is bounded, but full-load APPLY performance cannot be accepted without a valid Course source. |

Database verification at blocker closure:

- CA Providers: **0**
- CA Provider Registrations: **0**
- CA Courses: **0**
- CA Course Registrations: **0**
- CA Search Documents: **0**

This is the required safe state for a blocked country.

## 5. Blocker statement

**Blocker code:** `CA_COURSE_IDENTITY_SOURCE_BLOCKER`

Canada cannot pass the v2.9.1 Layer 1 production gate because the accepted federal Provider authority (IRCC DLI) does not provide a complete Canada-wide programme catalogue with stable regulator/source programme identifiers.

Using programme names, provider names, slugs, hashes or synthetic descriptive keys would violate the accepted architecture and repeat the identity defect already rejected for DE.

## 6. Remediation options

The blocker can be removed only by one of the following:

1. identify a Canada-wide authoritative programme register exposing stable programme identifiers; or
2. approve and implement a federated provincial/territorial Layer 1 source model in which each participating authority provides stable Provider/Programme identifiers and collectively achieves the required Canadian coverage.

Ontario APS is a strong candidate component for option 2 but is not sufficient on its own.

No database architecture change is currently required; the existing identity model can support multiple registration schemes/sources if a complete federated authority model is approved.

## 7. Gate decision

**CA = BLOCKED / NOT ACCEPTED FOR PRODUCTION APPLY.**

The legacy snapshot-backed CA production route has been removed from the Admin execution path, live authoritative Provider acquisition is established, and the database remains uncontaminated. The remaining blocker is source authority/stable Course identity, not implementation convenience.

Per programme sequencing, GB must not begin production APPLY until governance explicitly decides whether a proven CA source blocker pauses the queue or permits controlled advancement while CA remains deferred.
