# Coursefinder Layer 1 — Germany (DE) Production Gate UAT v1.0

**Date:** 12 August 2026  
**Gate:** Phase 1 — Germany Layer 1 Production Validation  
**Architecture baseline:** `docs/coursefinder-database-architecture-v2.9.1.md`  
**Running-build baseline:** `docs/coursefinder-running-build-v2.1.md`  
**Runtime repository:** `msinghbs-ai/Coursefinder-Pilot`  
**Runtime project:** `coursefinder_Pilot` / `fxcwkweaxjtknorudmwp` / Mumbai `ap-south-1`  
**Runtime function:** `layer1-register-etl` v7, worker `layer1-edge-v1.4.1`, `verify_jwt=true`  
**Decision:** **BLOCKED / NOT ACCEPTED FOR APPLY**

---

## 1. Objective

Take the existing live paged DAAD Layer 1 adapter through a production gate equivalent to the accepted AU standard without changing canonical identity, source-of-truth ownership or architecture implicitly.

Required validation areas:
- authoritative source and source health;
- acquisition/pagination and bounded execution;
- evidence/provenance;
- stable Provider/Course identity without name/title matching;
- dry-run and APPLY reconciliation;
- idempotency;
- duplicate/orphan/integrity checks;
- Search Projection;
- security/privilege boundaries;
- runtime/performance and resumability.

The gate must stop before canonical APPLY if a precondition violates architecture v2.9.1.

---

## 2. Gate Summary

| Gate area | Result | Evidence / finding |
|---|---|---|
| Official DAAD source | **PASS (official source)** | `DAAD International Programmes` is an official DAAD catalogue and the deployed adapter targets the live DAAD search JSON endpoint. |
| Layer 1 source-of-truth authority | **BLOCKED / DECISION REQUIRED** | Current DE source registry marks `HRK Hochschulkompass` as `coverage_role=primary`; DAAD is a complementary international-programme dataset. DAAD also publicly states that HRK Higher Education Compass covers the entire German study landscape while International Programmes complements it. |
| Source health/freshness | **PARTIAL / NOT ACCEPTED** | Official DAAD web search was reachable during validation and advertised about 2.5k programmes. Runtime DB source-health timestamps for DE were still null and DAAD metadata retained an older `available_records=2433`, so production source-health evidence has not yet been written by a successful DE job. |
| Live acquisition | **PASS by implementation inspection** | Deployed `runDE()` uses live DAAD JSON acquisition, not a stored DE seed snapshot. |
| Pagination | **PASS by implementation inspection** | Adapter derives `pageSize`, calculates `startPage=floor(offset/pageSize)+1`, skips records within the first page and fetches only enough pages to fill the bounded slice. |
| Bounded execution | **PASS by implementation inspection** | DE Admin contract is bounded; running build documents 100 default / 250 maximum. Edge route receives `offset` and `batchSize` and returns `nextOffset`/`hasMore`. |
| Evidence/provenance implementation | **PASS by implementation inspection; runtime proof pending** | Adapter serialises fetched DAAD pages, SHA-256 hashes bytes, writes to private `evidence` storage and records `pipeline.evidence_artifacts` linked to the Layer 1 job/source. No DE job/evidence exists yet in production runtime because APPLY was intentionally blocked before first canonical run. |
| Provider stable identity | **FAIL — CRITICAL BLOCKER** | `normaliseDaadCourse()` sets `provider_code = slug(c.academy)`. This derives Provider identity from the institution name and violates architecture v2.9.1: names never act as identity. |
| Course stable identity | **CONDITIONALLY PASS** | `course_code = String(c.id)` uses the DAAD programme ID. This is suitable only after the provider identity/source-authority contract is resolved and stability of the DAAD ID is accepted for the intended Layer 1 scope. |
| Dry-run | **NOT EXECUTED AS ACCEPTANCE EVIDENCE** | A valid production Platform Admin JWT is required. More importantly, identity precondition already fails by code inspection, so progressing to an acceptance dry-run would not cure the blocker. |
| APPLY reconciliation | **BLOCKED / NOT RUN** | No DE canonical writes were permitted while provider identity violates the architecture baseline. |
| Idempotency | **BLOCKED / NOT RUN** | Requires an accepted identity strategy and APPLY rerun. |
| Duplicate/orphan/integrity | **BASELINE CLEAN; POST-APPLY BLOCKED** | Runtime currently contains 0 DE Providers, 0 DE Provider Identifiers, 0 DE Courses, 0 DE Course Registrations and 0 DE Search Documents. Therefore there is no DE contamination to clean up, but post-APPLY integrity cannot be tested yet. |
| Search Projection | **BLOCKED / NOT RUN** | Requires accepted canonical DE APPLY. Current DE Search Documents = 0. |
| Security boundary | **PASS for inspected Layer 1 path** | Edge function has `verify_jwt=true`, validates the user session, checks `svc_layer1_authorize_platform_admin`, retains service key server-side, writes evidence to a private bucket, and Layer 1 service RPC EXECUTE ACLs are limited to `postgres` and `service_role`. |
| Runtime/performance | **DESIGN PASS; empirical DE gate pending** | Fetch timeout and bounded pagination exist; DE 250-record batches avoid monolithic execution. End-to-end timing must be measured after identity remediation. |
| Resumability | **PASS by contract; empirical proof pending** | Adapter returns `nextOffset`/`hasMore`; Admin running build resumes from persisted completed job result. |

**Overall decision:** **DE Layer 1 Production Gate — BLOCKED.**

No canonical DE APPLY was performed. This is deliberate and preserves the approved architecture.

---

## 3. Critical Blocker — Provider Identity

### Deployed behaviour

The deployed DE normaliser currently produces:

```text
provider_code = slug(c.academy)
provider_name = c.academy
course_code = String(c.id)
```

This means the value used as the DAAD Provider identifier is generated from the descriptive institution name.

### Why this fails the gate

Architecture v2.9.1 requires:
- stable IDs and explicit identifiers/aliases;
- names never act as identity;
- Layer 1 identity must not regress to name/title matching.

The accepted Layer 1 identity pattern is:

```text
Provider identity = country + registration_scheme + stable regulator/source provider code
Course identity   = provider + registration_scheme + stable regulator/source course code
```

A slugged name is still a name-derived identifier. Institution renaming, punctuation/transliteration changes, wording differences or source formatting changes can produce a new canonical Provider or incorrectly merge distinct Providers.

### Required remediation

Before DE APPLY:

1. Inspect the DAAD programme payload/detail source for a stable institution identifier that is independent of the institution display name.
2. If DAAD exposes a stable institution identifier, use that identifier as the `provider_code` for the `daad` registration scheme and retain `academy` only as descriptive name/alias data.
3. If DAAD does **not** expose a suitable stable institution identifier, do not invent one from the name. Resolve Provider identity against an approved primary German institution authority such as HRK Higher Education Compass, using a stable HRK/institution identifier and an explicit cross-source mapping.
4. Keep the DAAD programme `id` as the candidate Course identifier only after confirming its persistence/stability and the intended DAAD Layer 1 scope.
5. Add automated negative tests proving that changing provider name/title does not change Provider/Course identity.
6. Update technical documentation if the DE source composition is clarified, but do not change the canonical architecture unless an explicit architecture decision is approved.

---

## 4. Source Authority / Coverage Decision

The production source registry currently contains:

- `HRK Hochschulkompass` — active, trust rank 10, metadata `coverage_role=primary`;
- `DAAD International Programmes` — active, trust rank 20.

DAAD describes its International Programmes database as an international-programme catalogue that complements the HRK Higher Education Compass; it states that HRK covers the entire German study landscape.

Therefore one of the following must be explicitly approved before DE can be called production-complete:

### Option A — Full Germany regulatory/catalogue Layer 1
Use HRK/another approved national authority as the Provider/base-course identity authority, with DAAD as a complementary official international-programme source linked through stable identifiers.

### Option B — Deliberately scoped DAAD International Programmes Layer 1
Explicitly define DE Layer 1 scope as the DAAD International Programmes subset rather than the complete German study landscape. Even under this option, Provider identity still requires a non-name stable identifier.

**No source-of-truth rule was changed during this UAT.**

---

## 5. Runtime and Security Evidence

Validated runtime facts:

- Supabase project `fxcwkweaxjtknorudmwp` is active in `ap-south-1`.
- `layer1-register-etl` v7 is active with `verify_jwt=true`.
- Worker reports `layer1-edge-v1.4.1`.
- Caller must present a valid Supabase user JWT.
- Edge code calls `svc_layer1_authorize_platform_admin` before routing work.
- Service-role credential is read only from server environment variables.
- Layer 1 RPCs inspected in PostgreSQL are `SECURITY DEFINER` but EXECUTE is restricted to `postgres` and `service_role`; no `anon` or general `authenticated` EXECUTE grant was observed.
- Storage bucket `evidence` is private (`public=false`).

Residual Phase 7 platform findings remain governed separately by the master plan; this DE gate introduced no new privilege broadening.

---

## 6. Current DE Database Baseline

At validation time:

| Object | DE count |
|---|---:|
| Providers | 0 |
| Provider Identifiers | 0 |
| Courses | 0 |
| Course Registrations | 0 |
| Search Documents | 0 |
| Completed/failed DE Layer 1 jobs | 0 |

This is the correct safe state for remediation: there is no name-derived DE canonical population requiring rollback.

---

## 7. Remediation Gate / Exact Re-test Sequence

After Provider identity and source-authority remediation, rerun the gate in this order:

1. **Source health** — execute a DE dry-run and confirm DAAD endpoint success, fresh `last_checked_at/last_success_at`, current available record count and no source error.
2. **Payload identity proof** — capture examples showing stable provider identifier + DAAD programme ID independently of names/titles.
3. **Dry-run offset 0 / batch 100** — validate parse count, pages fetched, `nextOffset`, `hasMore`, evidence/job IDs and zero canonical writes.
4. **Dry-run non-zero offset** — prove page arithmetic and no overlap/gap at a page boundary.
5. **APPLY first bounded slice** — reconcile Providers/Courses, inspect identifiers/registrations/evidence lineage and rebuild Search Projection.
6. **Idempotency rerun same slice** — require zero new canonical Providers/Courses and zero duplicate identifiers/registrations.
7. **Continue through all pages** using returned `nextOffset`; record per-batch runtime and total runtime.
8. **Full integrity SQL** — duplicate stable keys, duplicate scheme/code identities, course/provider orphans, registration/evidence/source orphans, NULL/blank regulator IDs, country leakage.
9. **Search Projection parity** — DE searchable course documents must equal the accepted publishable DE course population; verify stable course/provider IDs are retained.
10. **Security negative tests** — unauthenticated and non-Platform-Admin callers denied; no service key/browser exposure.
11. **Resumability** — interrupt after a completed batch, resume from persisted `nextOffset`, prove no missed/duplicated canonical rows.
12. **Performance acceptance** — retain a safe production DE batch maximum based on observed runtime, with no Edge timeout or PostgreSQL statement timeout.

Only then may the decision be changed to **DE Layer 1 Production Gate — PASS**.

---

## 8. Architecture / DB Impact

**Architecture change:** None.  
**Canonical identity change:** None approved.  
**DB schema change:** None.  
**Production data change:** None for DE; canonical DE remains empty.  
**Security change:** None.

The blocker exists because the current adapter does not yet conform to the already-approved identity architecture; the correct remediation is to bring the adapter/source mapping into conformance rather than weakening the architecture.

---

## 9. Risks

| Risk | Severity | Treatment |
|---|---|---|
| Name-derived Provider identity creates duplicates or false merges | **Critical** | Block APPLY; replace with stable source/authority identifier. |
| DAAD International Programmes treated as complete German regulatory catalogue | **High** | Explicitly approve DE Layer 1 coverage model; preserve HRK primary role unless governance changes it. |
| DAAD endpoint/payload changes | Medium | Persist evidence/hash/metadata; source-health monitoring; controlled adapter tests. |
| Pagination dataset changes during long multi-batch run | Medium | Bounded runs, evidence per batch, current sort stability validation, resumable job records; document source snapshot limitations. |
| DAAD course ID lifecycle not formally proven | Medium | Validate ID persistence using repeated evidence and detail URLs before accepting course identity. |
| Production runtime empirical performance not yet measured | Medium | Measure after blocker remediation across representative and full-country run. |

---

## 10. Gate Decision and Recommended Next Work

**Decision:** **BLOCKED / REMEDIATION REQUIRED**.

Recommended next engineering task:

> Remediate the DE adapter so Provider identity is sourced from a stable non-name German/DAAD institution identifier, explicitly resolve the HRK-vs-DAAD Layer 1 coverage contract, then rerun the complete DE production gate from dry-run through full APPLY/idempotency/integrity/Search Projection/security/performance/resume validation.

Do **not** progress DE to production APPLY using `slug(c.academy)` as Provider identity.
