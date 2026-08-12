# Coursefinder — Layer 1 Canada Production Gate UAT v1.1

**Date:** 12 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.9.2.md`  
**Prior gate evidence:** `docs/uat/coursefinder-layer1-ca-production-gate-uat-v1.0.md`  
**Pilot:** `msinghbs-ai/Coursefinder-Pilot` / `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Gate result:** **BLOCKED — IDENTITY ARCHITECTURE RESOLVED; NATIONAL/FEDERATED COURSE SOURCE COVERAGE REMAINS INCOMPLETE**

## 1. Change from v1.0

v1.0 proved that IRCC DLI is a valid Canada-wide Provider authority but that a single federal stable Course identifier is unavailable.

v1.1 accepts a Canada-specific source-scoped Course identity extension:

- Provider identity: `CA + ircc_dli + DLI number`.
- Course identity: `Provider + source identity scheme + stable source-local programme identifier`.
- Optional regional registration: e.g. Ontario `on_aps`.
- Course title and Provider name remain descriptive only and have zero identity power.

This resolves the database/identity-model blocker without weakening v2.9.1 principles.

## 2. Database implementation completed

Migration `ca_scoped_course_identity_and_staging` added:

- `catalogue.course_identifiers`;
- uniqueness at `provider_id + scheme + identifier`;
- Provider/Course ownership trigger;
- `pipeline.source_record_staging` raw JSONB ELT buffer;
- GIN raw-payload index;
- service-role-only table privileges.

Migration `ca_scoped_course_reconciliation_rpc` added:

- `public.svc_layer1_apply_scoped_course_records(...)`;
- separate Provider and Course identity schemes;
- optional regional registration scheme/code;
- explicit grants: `service_role=EXECUTE`, `anon/authenticated=DENIED`.

Verification:

- `catalogue.course_identifiers` exists;
- `pipeline.source_record_staging` exists;
- anonymous RPC execute: **false**;
- authenticated RPC execute: **false**;
- service-role RPC execute: **true**.

Pilot migration commits:

- `0254920c24a245571b9fc16bfe0c297b35a195ae`
- `b794ab9cc3293bf78e776276c1c76b239d908c37`

## 3. Source model

### IRCC DLI — Provider authority

Accepted role:
- national Provider identity;
- DLI/designation status;
- province/city/campus attributes where supplied.

Identity:

`ircc_dli + DLI number`

### Ontario public college programmes — first provincial Course source

Configured system:

`ca_on_public_college_programs`

Configured source:

`Ontario public college programmes / APS`

The Ontario Ministry dataset states that Approved Program Sequence (APS) is a unique code assigned to each approved programme of instruction and used for enrolment reporting. The dataset also carries programme titles, credential types, ministry codes and CIP mappings.

Accepted identity/registration scheme for this source:

`on_aps`

Coverage is explicitly marked `coverage_complete_for_country=false` because the source covers Ontario public colleges only.

## 4. Layer boundary

For Canada, authoritative Course identity may come from:

1. provincial/territorial programme authority where a stable programme code exists; or
2. an authoritative first-party institution catalogue/API/feed with a stable local programme code when no regulator programme ID exists.

Only identity/base catalogue fields are promoted through Layer 1. Fees, intakes, scholarships, marketing descriptions and other enrichment continue under Layer 2/3 source-priority rules.

## 5. UAT status

| Test | Result | Position |
|---|---|---|
| IRCC live Provider authority | **PASS** | DLI number remains accepted Provider identity. |
| Non-name Provider identity | **PASS** | DLI number only. |
| Non-name Course identity architecture | **PASS** | Source-scoped stable programme IDs implemented. |
| Separate Provider/Course schemes | **PASS** | New service-role RPC implemented. |
| Raw ELT staging | **PASS — schema/security** | Private JSONB staging added. |
| Ontario APS authority/identifier | **PASS — source qualification** | APS is a unique programme code for Ontario public colleges. |
| Full CA Course-source coverage | **BLOCKED** | Other provinces/territories and institution gaps are not yet implemented/validated. |
| Full CA APPLY | **NOT PERMITTED** | National/federated source set incomplete. |
| Full CA idempotency | **NOT EXECUTED** | Await complete source acquisition. |
| Full CA integrity | **PROTECTED** | No invalid CA canonical load is authorised. |
| Search Projection | **PROTECTED** | Search must remain derived only from accepted canonical data. |
| Security | **PASS — new DB objects** | Scoped RPC/table privileges verified. |
| Performance | **PARTIAL** | Schema/RPC foundation ready; source-by-source acquisition throughput remains to be measured. |

## 6. Gate blocker after architecture extension

**Blocker code:** `CA_FEDERATED_COURSE_SOURCE_COVERAGE_BLOCKER`

The identity design is no longer blocked. Canada remains unaccepted because the production gate requires sufficient Canadian Course-source coverage and each participating source must prove:

- authority and freshness;
- stable programme identifier semantics;
- deterministic Provider-to-DLI mapping without name-based identity;
- bounded acquisition/resume;
- private raw evidence/hash lineage;
- APPLY and rerun idempotency;
- duplicate/orphan checks;
- Search Projection finalisation;
- security/performance limits.

## 7. Decision

**CA remains BLOCKED / NOT ACCEPTED FOR FULL PRODUCTION APPLY.**

The correct next implementation sequence is now:

1. Ontario APS live ingestion and DLI mapping UAT;
2. identify/configure remaining provincial/territorial authoritative programme sources;
3. use first-party institutional catalogue feeds only for documented coverage gaps;
4. run bounded CA APPLY/idempotency/integrity/Search Projection after the accepted source set is complete;
5. promote CA to PASS only after the full gate closes.
