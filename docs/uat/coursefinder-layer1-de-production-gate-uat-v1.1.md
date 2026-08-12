# Coursefinder Layer 1 — Germany (DE) Production Gate UAT v1.1

**Date:** 12 August 2026  
**Gate:** Phase 1 — Germany Layer 1 Production Validation  
**Architecture baseline:** `docs/coursefinder-database-architecture-v2.9.1.md`  
**Running-build baseline:** `docs/coursefinder-running-build-v2.1.md`  
**Runtime:** `coursefinder_Pilot` / `fxcwkweaxjtknorudmwp` / Mumbai `ap-south-1`  
**Edge function:** `layer1-register-etl` v7 / worker `layer1-edge-v1.4.1` / `verify_jwt=true`  
**Decision:** **BLOCKED / REMEDIATED TO FAIL SAFE — NOT ACCEPTED FOR DE CANONICAL APPLY**

---

## 1. Executive Gate Decision

Germany cannot yet receive the AU-equivalent Layer 1 Production Gate PASS.

The production validation established that:

1. the DAAD International Programmes source is live and healthy;
2. DAAD programme identity is stable enough to expose a programme `id` for candidate Course identity;
3. the DAAD search and programme-detail payloads do **not** expose a stable institution/Provider identifier — only descriptive institution name (`academy`) plus contact/profile data;
4. the deployed adapter currently derives `provider_code = slug(c.academy)`, which violates architecture v2.9.1 because names must never act as identity;
5. the DAAD API does support real bounded acquisition through `limit + offset`, but the deployed adapter currently uses the ineffective `page` parameter;
6. a production DB guard now blocks DE `registration_scheme=daad` canonical Provider writes so the unsafe identity path cannot contaminate the catalogue;
7. DE remains clean at zero canonical/search entities.

The remaining external prerequisite is an approved stable Provider identity source/mapping, expected to come from the HRK-primary German catalogue relationship or another explicitly approved non-name identifier source.

No canonical identity rule or source-of-truth rule was changed.

---

## 2. Authoritative Source / Coverage Result

### DAAD International Programmes

**Result: PASS as official complementary programme source.**

Live production-network probes on 12 August 2026 returned HTTP 200 with no timeout. The DAAD API reported **2,434** programme records during the gate.

DAAD's own public material distinguishes:
- the Higher Education Compass / HRK data as covering the German study landscape; and
- DAAD International Programmes as a complementary set focused on international programmes.

### HRK Hochschulkompass

The production source registry already records:
- `HRK Hochschulkompass` — trust rank 10, `coverage_role=primary`;
- `DAAD International Programmes` — trust rank 20, complementary international-programme source.

**Gate consequence:** CourseFinder must not silently redefine DAAD International Programmes as the sole national Layer 1 authority. A sanctioned HRK/provider identity feed or approved mapping remains required for the full-country DE gate.

---

## 3. Live DAAD Payload Validation

### Search payload

Production-network request:

`.../api/solr/en/search.json?q=&sort=4&page=1`

Observed:
- HTTP 200;
- `numResults = 2434`;
- programme objects contain stable-looking `id`;
- programme objects contain `academy` institution name;
- no `providerId` field;
- no `institutionId` field.

A representative result contained programme ID `4920` and institution name `Martin Luther University Halle-Wittenberg`.

### Programme detail payload

The corresponding DAAD detail page was inspected from the production network.

It exposed institution name, descriptive profile, location/contact and website information but no machine-stable institution identifier suitable for canonical Provider identity.

**Identity result:** DAAD Course/programme ID is available; DAAD Provider ID is not available from the current search/detail surfaces.

---

## 4. Acquisition / Pagination Validation

### Deployed implementation finding

`layer1-edge-v1.4.1` assumes `page` is the upstream pagination mechanism. It derives `pageSize` from the first response and calculates `startPage` from CourseFinder `offset`.

Live validation showed this assumption is incorrect for the current DAAD endpoint:
- `page=1` and `page=2` returned the same leading records;
- without `limit`, the endpoint returned all 2,434 programmes in one response.

Therefore the deployed implementation bounds reconciliation records but does not currently perform true bounded upstream acquisition.

### Correct upstream semantics discovered

The current DAAD API accepted:
- `limit=<n>`;
- `offset=<n>`.

Validation:

| Probe | HTTP | Returned | First ID | Last ID | Timeout |
|---|---:|---:|---|---|---|
| `limit=250&offset=0` | 200 | 250 | `4920` | `4338` | No |
| `limit=250&offset=250` | 200 | 250 | `7716` | `9906` | No |

Cross-batch programme-ID overlap: **0**.

**Acquisition result:** **PASS for source capability; REMEDIATION REQUIRED in deployed adapter.**

Required code correction before gate re-entry:
- use DAAD `limit=batchSize&offset=offset` directly;
- enforce DE server-side maximum batch 250;
- stop deriving pagination from `page` / first-response length;
- preserve `totalRecords`, `selectedRecords`, `nextOffset`, `hasMore`, evidence and job metadata.

This change does not alter canonical architecture.

---

## 5. Stable Identity Validation

### Provider

Deployed code:

`provider_code = slug(c.academy)`

**Result: FAIL — CRITICAL.**

This is a descriptive-name-derived identifier and violates architecture v2.9.1.

No hash, slug, domain name or transformed institution title is approved as a replacement identity.

### Course

Deployed code:

`course_code = String(c.id)`

**Result: CONDITIONAL.**

The DAAD programme ID is machine supplied and suitable as a candidate stable Course identifier for the DAAD international-programme source, but canonical Course reconciliation still depends on first resolving stable Provider identity and the approved HRK/DAAD coverage relationship.

---

## 6. Fail-Safe Production Remediation

### Migration 042

`supabase/production-migrations/042_guard_de_daad_name_derived_identity.sql`

Introduces a trigger guard on `catalogue.provider_registrations` that rejects Germany registrations where `registration_scheme = 'daad'`.

The exception explicitly states that canonical APPLY is blocked until a stable Provider identifier / approved HRK mapping exists.

### Migration 043

`supabase/production-migrations/043_harden_de_daad_guard_function_acl.sql`

Restricts the trigger function ACL to:
- `postgres`;
- `service_role`.

`public`, `anon` and `authenticated` have no EXECUTE grant.

### Guard UAT

A service reconciliation probe attempted to write a synthetic DE/DAAD Provider/Course record through the actual `svc_layer1_apply_register_records` path.

Expected result received:
- SQLSTATE: `23514`;
- message: DE DAAD canonical APPLY blocked because stable Provider identifier is unavailable.

Post-probe state:

| Entity | DE count |
|---|---:|
| Providers | 0 |
| Provider Registrations | 0 |
| Courses | 0 |
| Course Registrations | 0 |
| Search Documents | 0 |

**Result: PASS — unsafe APPLY fails atomically and leaves no orphan/canonical residue.**

---

## 7. Evidence and Provenance

The deployed adapter implementation:
- serialises acquired DAAD source payloads;
- calculates SHA-256 content hash;
- uploads source bytes to the private `evidence` bucket;
- records `pipeline.evidence_artifacts` linked to source/job;
- records source health and job result metadata.

The evidence bucket is private.

Historical 11 August runtime-UAT logs show earlier temporary DE dry-run/APPLY/rerun activity and DAAD evidence objects before the database was reset. Those historical runs predate this production identity gate and are **not accepted as the DE production gate**, because the then-current adapter used name-derived Provider identity.

For the 12 August gate, source health was updated from a direct Mumbai production-network `pg_net` probe rather than performing an unsafe canonical Edge APPLY.

Current DAAD source health now records:
- successful check timestamp;
- HTTP 200;
- available records 2,434;
- `limit` supported;
- `offset` supported;
- `page` ineffective;
- programme ID present;
- Provider identity field absent;
- canonical APPLY guard active.

**Result: source provenance mechanism PASS by implementation; accepted canonical evidence lineage remains pending the remediated DE ingestion run.**

---

## 8. Dry-Run / APPLY / Idempotency / Integrity / Search

| Gate | Result | Reason |
|---|---|---|
| Acceptance dry-run | **BLOCKED** | Deployed normaliser still emits name-derived Provider identity and wrong pagination semantics. |
| Canonical APPLY | **BLOCKED + FAIL-SAFE GUARDED** | Migration 042 rejects current DAAD registration scheme for DE. |
| Idempotency | **PENDING** | Must be tested after stable Provider identity exists. |
| Duplicate checks | **BASELINE PASS / POST-APPLY PENDING** | Current DE canonical counts remain zero. |
| Orphan/integrity checks | **BASELINE PASS / POST-APPLY PENDING** | Guard probe rolls back atomically; full ingestion not permitted. |
| Search Projection | **PENDING** | No accepted DE Courses exist to project. |

Search remains derived/rebuildable and no Search Projection rule was changed.

---

## 9. Security / Privilege Boundary

Validated:
- `layer1-register-etl` has `verify_jwt=true`;
- caller session is validated;
- Platform Admin is checked server-side;
- service-role key remains server-side;
- Layer 1 service RPCs remain service-only;
- evidence bucket is private;
- DE guard trigger function ACL is only `postgres` + `service_role`;
- unsafe service reconciliation is rejected atomically.

Supabase security advisors were rerun after the guard DDL. No new DE-guard warning was introduced. Existing programme-level warnings remain, including authenticated `public.ui_*` SECURITY DEFINER functions, leaked-password protection disabled and RLS-enabled/no-policy informational findings; these remain Phase 7 hardening items and are not caused by the DE remediation.

**DE Layer 1 privilege-path result: PASS WITH EXISTING PHASE 7 RESIDUALS.**

---

## 10. Runtime / Performance / Resumability

Source capability now proves that a 250-record DAAD slice can be retrieved directly and independently with `limit + offset`.

The two representative 250-record production-network probes returned HTTP 200 with no timeout and no cross-batch ID overlap.

Historical Edge UAT timings from 11 August included roughly 17–40 second DE runtime executions under the older full-payload/page implementation. These are useful diagnostic evidence but are not the final performance acceptance baseline.

Final runtime/performance acceptance must be measured after the Edge adapter is changed to `limit + offset` and the stable Provider identity dependency is resolved.

Resumability contract remains conceptually valid:
- next request offset = current offset + selected record count;
- `hasMore` compares next offset to DAAD `numResults`;
- the source itself has proven non-overlapping offset windows.

**Result: source-level resumability PASS; deployed-adapter performance/resume gate PENDING remediation.**

---

## 11. Database / Architecture Impact

### Architecture

**No architecture change.**

Architecture v2.9.1 remains authoritative:
- Layer 1 owns approved regulatory/catalogue truth;
- names/titles never act as identity;
- Search Projection remains derived;
- internal/service boundaries remain unchanged.

### Database

Two fail-safe migrations were added:
- `042_guard_de_daad_name_derived_identity.sql`;
- `043_harden_de_daad_guard_function_acl.sql`.

They introduce no DE canonical data and no new identity model. They prevent an implementation that violates the existing identity model from writing.

---

## 12. Remaining Blockers / Remediation Plan

### Blocker A — Stable Provider identity / authoritative national mapping

Required:
1. obtain an approved/sanctioned HRK Higher Education Compass data feed, export or equivalent stable institution identifier mapping appropriate for CourseFinder production use; or
2. identify another authoritative non-name German institution identifier and explicitly approve it within existing v2.9.1 identity rules.

Do **not** use:
- institution-name slug;
- name hash;
- website domain;
- descriptive title matching.

### Blocker B — DAAD adapter bounded acquisition correction

Change the DE Edge adapter from `page` logic to:
- `limit = min(requestedBatch, 250)`;
- `offset = requested offset`.

This is a code/runtime correction only and requires no architecture change.

### Re-entry sequence

After A and B are complete:
1. live source-health probe;
2. bounded dry-run at offset 0;
3. bounded dry-run at non-zero offset and verify non-overlap;
4. inspect Provider/Course identifiers before writes;
5. APPLY first bounded batch;
6. rerun same batch for idempotency;
7. continue through all offsets;
8. duplicate/orphan/integrity SQL;
9. Search Projection rebuild and Course/Search parity;
10. privilege-negative tests;
11. runtime/performance measurement;
12. resume from persisted `nextOffset`;
13. update this UAT and master plan to PASS only if every gate succeeds.

---

## 13. Final Gate Status

**DE Layer 1 Production Gate — BLOCKED / NOT ACCEPTED.**

The runtime is now safer than at gate entry because current name-derived DAAD Provider writes are blocked at the database reconciliation boundary.

The technical acquisition defect is understood and has a proven `limit + offset` remediation path.

The decisive remaining dependency is an approved stable German Provider identity source/mapping aligned with the HRK-primary national catalogue semantics.
