# Coursefinder — Layer 1 NZ Production Gate UAT v1.0

**Date:** 12 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.9.1.md`  
**Programme governance:** `docs/coursefinder-master-project-plan-v1.0.md`  
**Reference gate:** `docs/uat/coursefinder-layer1-au-full-ingestion-uat-v1.0.md`

## Result

**PASS / ACCEPTED**

New Zealand Layer 1 regulatory ingestion is accepted for production use against the v2.9.1 identity and evidence model.

## Authoritative Source

Primary acquisition authority:
- New Zealand Qualifications Authority (NZQA) Education Organisations / Qualifications register.

Secondary authority assessed:
- Ministry of Education / Education Counts tertiary-provider directory.
- Education Counts was Cloudflare-challenged from the database runtime during validation, so it is retained as an independent authority/freshness cross-check rather than a hard ingestion dependency.

The accepted production acquisition path is therefore NZQA-complete for the tertiary provider population.

## Stable Identity

Accepted Provider identity:
- `NZ + nzqa + Education Organisation number`

Accepted Course identity:
- `Provider + nzqa + NZQA qualification Number`

Provider names and qualification titles remain descriptive only and do not act as canonical identity.

Transactional reconciliation validation with real NZQA identities confirmed the existing v2.9.1 service contract can create Provider/Course records without schema changes.

## Live Provider Population

Live NZQA tertiary register after deduplicating delivery-site rows:

| Provider Type | Unique Provider IDs |
|---|---:|
| University | 8 |
| Polytechnic | 17 |
| Wānanga | 3 |
| Private Training Establishment | 377 |
| Government Training Establishment | 4 |
| **Total** | **409** |

The NZQA search endpoint exposes stable `providerId` links. Provider detail records expose the Education Organisation number; current qualification results expose stable qualification Numbers.

## Runtime

Production worker:
- `layer1-nz-live`
- validated version: `layer1-nz-live-v1.1.1`
- deployed Edge Function SHA: `97e15f84243ca9b0350621df3935539763a5371edfaa2a874839b9d92513e62e`
- `verify_jwt=true`
- Platform Admin authorisation required for the normal production path.

Bounded contract:
- `apply`
- `offset`
- `batchSize`
- `nextOffset`
- `hasMore`

The validation worker enforced a five-provider maximum batch while production behaviour and source shape were being proved.

## Dry-Run

Controlled live dry-run at offset 0 / batch 1:
- HTTP: 200
- Provider population detected: 409
- Selected providers: 1
- Reconciliation conflicts: 0
- Runtime: 1,992 ms
- Evidence artifacts: 2
- Evidence hashes:
  - `ad460d9d3e8bf9ed3079d6bae823b08aa38beb653cfc70a1a811c067664d970c`
  - `e0c894a3cba66886d036eb6be1e2852be742f9e7e59787b46df240ab646d62fd`

## APPLY / Full Load

Full NZ tertiary acquisition was completed through bounded five-provider slices.

Final canonical NZ population:
- Providers: **409**
- Provider Registrations: **409**
- Courses: **6,457**
- Course Registrations: **6,457**
- Search Documents: **6,457**

The accepted full-catalogue finalisation result after NZ ingestion was:
- Total Providers: 1,955
- Total Courses: 33,105
- Search Documents: 33,105
- Search generation: 10

The accepted AU population remains present and unchanged within the combined catalogue.

## Idempotency

Same-source replay of the leading NZ batch returned existing Provider/Course reconciliation rather than creating duplicate canonical entities.

Observed replay reconciliation included:
- `provider_created=0`
- `provider_existing=5`
- `conflicts=0`

Final uniqueness validation:
- duplicate Provider regulatory identity keys: **0**
- duplicate Course identity keys at `provider + scheme + qualification code`: **0**

NZQA qualification numbers can legitimately occur at multiple providers. Therefore qualification-code uniqueness is evaluated within Provider identity, as required by architecture v2.9.1.

## Integrity

Final NZ integrity validation:
- Providers without Provider Registration: **0**
- Courses without Course Registration: **0**
- Orphan Course Registrations: **0**
- Duplicate Provider identity keys: **0**
- Duplicate Course identity keys: **0**
- Search Documents vs Courses: **6,457 / 6,457**

## Search Projection

`svc_layer1_finalize_catalogue()` completed successfully after the country load with an extended controlled statement timeout.

NZ Search Projection coverage is complete:
- Courses: 6,457
- Search Documents: 6,457

A scaling finding was recorded during UAT: concurrent batch jobs must not each perform catalogue finalisation simultaneously. The canonical reconciliation stage completed safely, but concurrent finalisation attempts can contend and hit statement timeout. Operationally, country ingestion should reconcile bounded slices and perform final Search Projection rebuild once after the load or serialize finalisation.

This is an operational/performance hardening item, not an NZ identity/data acceptance blocker.

## Security

Validated service boundary:
- Layer 1 write/evidence/finalisation functions executable by `postgres` / `service_role`.
- `authenticated` execution: denied.
- `anon` execution: denied.
- NZ production worker retains `verify_jwt=true` and Platform Admin authorisation.

Temporary UAT controls were removed after validation:
- `svc_layer1_validate_nz_gate_uat_token(uuid,text)` dropped.
- temporary UAT token rows removed.
- `layer1-nz-gate-uat` redeployed as JWT-protected HTTP 410 retired harness.
- `layer1-nz-source-inspect` redeployed as JWT-protected HTTP 410 retired harness.

## Evidence / Provenance

Each bounded run stores raw NZQA acquisition artifacts in the private evidence boundary and records SHA-256 hashes through the Layer 1 evidence service contract.

The dry-run and APPLY evidence records are linked to their regulatory-sync jobs and source records.

## Architecture / DB Impact

No v2.9.1 architecture change is required.

NZ conforms to the existing regulator-identifier model:
- Provider = country + scheme + stable regulator provider ID.
- Course = Provider + scheme + stable regulator qualification ID.

A temporary UAT-token validation function was created only to permit controlled autonomous live validation and was removed after the gate. No persistent browser-accessible write path was introduced.

## Gate Decision

**NZ PASS / ACCEPTED.**

Phase 1 execution may advance to **CA**.

Execution order remains:
1. NZ — PASS
2. CA — NEXT
3. GB
4. US
5. IE
6. DE — deferred until the preceding countries are accepted and the DE identity/source-authority blocker is remediated.
