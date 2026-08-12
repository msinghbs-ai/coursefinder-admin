# Coursefinder Running Build v2.1

## Current Phase
Layer 1 multi-country regulatory production validation after successful AU and NZ production gates. **CA is now the active country.** DE remains deferred and protected by the existing Provider-identity safety guard until NZ, CA, GB, US and IE have been accepted.

## Production Execution Contract
Settings > Regulatory ingestion runs one country at a time.

Every general Layer 1 request carries:
- `country`
- `apply`
- `offset`
- `batchSize`

Country adapters return progress metadata including:
- `totalRecords` / country-equivalent total population
- `selectedRecords` / selected providers
- `nextOffset`
- `hasMore`
- reconciliation counts
- evidence/job references

The Settings workflow can continue from the exact next offset or re-run the current offset for idempotency validation where that country is cleared for APPLY.

## Country Routing

### AU — CRICOS
- Adapter: consolidated CRICOS Providers / Courses / Locations ZIP.
- Canonical identity: CRICOS Provider Code and CRICOS Course Code.
- Bounded core slice: default 2,500 courses; hard UI maximum 5,000.
- Each selected course slice reconciles matching Provider Locations and Course Locations.
- Canonical output: Providers, Courses, Campuses and Course↔Campus relationships.
- Search Projection finalises after Apply.
- Gate: **PASS / ACCEPTED**.

### NZ — NZQA
- Production worker: `layer1-nz-live`.
- Validated runtime: `layer1-nz-live-v1.1.1`.
- Edge deployment SHA: `97e15f84243ca9b0350621df3935539763a5371edfaa2a874839b9d92513e62e`.
- Runtime acquisition authority: NZQA Education Organisations / Qualifications register.
- Education Counts remains an independent secondary authority/freshness cross-check but is not a hard runtime dependency because the database runtime encountered a Cloudflare challenge.
- Tertiary provider types acquired from NZQA: University, Polytechnic, Wānanga, Private Training Establishment and Government Training Establishment.
- Provider identity: `NZ + nzqa + Education Organisation number`.
- Course identity: `Provider + nzqa + NZQA qualification Number`.
- Names/titles never act as identity.
- Bounded execution validated with `apply`, `offset`, `batchSize`, `nextOffset`, `hasMore`.
- UAT validation maximum batch: 5 Providers per request.
- Full accepted NZ population:
  - Providers: 409
  - Provider Registrations: 409
  - Courses: 6,457
  - Course Registrations: 6,457
  - Search Documents: 6,457
- Duplicate Provider identity keys: 0.
- Duplicate Course identity keys at Provider + scheme + qualification code: 0.
- Providers/Courses without regulatory registrations: 0.
- Orphan Course Registrations: 0.
- Gate: **PASS / ACCEPTED**.
- Detailed UAT: `docs/uat/coursefinder-layer1-nz-production-gate-uat-v1.0.md`.

### CA — ACTIVE NEXT COUNTRY
- Current adapter is still snapshot-backed plus live source health checking.
- Production APPLY is not accepted from the legacy snapshot path.
- Active work is to identify authoritative Canadian Provider and Course/programme acquisition sources and stable regulator/source identifiers.
- The v2.9.1 identity model remains mandatory unless a documented country-specific architecture extension is approved.

### GB — UKVI + configured course source
- UKVI provider register is bounded by offset/batch.
- Configured country course source remains routed through the preserved Layer 1 country adapter.
- Gate remains pending until CA passes.
- Any name-derived Provider identity must be removed before APPLY.

### US / IE
- Current adapters use the preserved country Layer 1 snapshot plus a live source freshness check.
- They follow the same offset/batch execution contract so their acquisition implementation can later be replaced without changing the Admin workflow.
- Production APPLY remains pending their country gates.

### DE — DAAD / HRK identity dependency
- Live DAAD International Programmes source is reachable and remains the configured international-programme acquisition source.
- Production validation on 12 August 2026 confirmed the DAAD search API currently reports 2,434 programme records.
- The API supports bounded retrieval using `limit` and `offset`.
- The deployed general worker still has known DE pagination/identity issues and must not be treated as an accepted production DE adapter.
- DAAD exposes stable programme IDs but no stable Provider/institution identifier in the tested payload; Provider text is descriptive `academy` data.
- `slug(academy)` is prohibited as canonical Provider identity.
- Existing DE database safety migrations block unsafe `registration_scheme=daad` Provider registration writes and restrict the guard to `postgres` / `service_role`.
- DE canonical population remains unaccepted until the Provider identity/source-authority blocker is remediated and the full gate is rerun.
- Gate: **DEFERRED / BLOCKED**.

## Search Projection Operational Finding
NZ full-load UAT exposed a scaling characteristic in the current operational pattern:
- bounded canonical reconciliation can run safely in slices;
- simultaneous `svc_layer1_finalize_catalogue()` calls from multiple concurrent APPLY slices can contend and hit PostgreSQL statement timeout;
- after the NZ load, a single controlled finalisation completed successfully and produced full NZ Search Projection coverage.

Production hardening direction:
- reconcile bounded country slices;
- perform one Search Projection rebuild after the country load, or serialize finalisation;
- do not run concurrent full-catalogue finalisation per slice.

This is an operational/performance hardening item and did not create NZ canonical integrity defects.

## Admin UX
The old `Dry-run all 7 / Apply all 100` UAT model has been removed from the primary workflow.

The production-style workflow is:
1. Select country.
2. Review adapter, programmed logic, identity model and configured source health.
3. Set bounded batch size / offset.
4. Validate batch without writes.
5. Apply bounded batch with explicit `APPLY <COUNTRY>` confirmation only when the country gate permits canonical writes.
6. Continue using returned `nextOffset`.
7. Optionally re-run the current batch to prove idempotency.
8. Finalise Search Projection once the country load is complete.

## Runtime / Security Versions
- `layer1-register-etl`: `layer1-edge-v1.4.1` — existing general country entrypoint.
- `layer1-au-depth`: `layer1-au-depth-v1.1.0`.
- `layer1-nz-live`: `layer1-nz-live-v1.1.1` — accepted dedicated NZ authoritative worker.
- Production workers retain `verify_jwt=true` and Platform Admin/server-side authorisation.
- Layer 1 write/evidence/finalisation RPCs remain service-role only; `authenticated` and `anon` direct execution is denied.
- Temporary NZ gate token function and token rows were removed after UAT.
- `layer1-nz-gate-uat` and `layer1-nz-source-inspect` are retired JWT-protected HTTP 410 harnesses.
- DE DB safety gate remains active.

## Accepted Regulatory Baselines

### AU
- Providers: 1,546
- Courses: 26,648
- Campuses: 3,922
- Course↔Campus: 47,671
- Search Documents: 26,648

### NZ
- Providers: 409
- Courses: 6,457
- Search Documents: 6,457

### Combined catalogue after NZ finalisation
- Providers: 1,955
- Courses: 33,105
- Search Documents: 33,105
- Search generation observed at final NZ gate: 10

## Current Next Step
**CA Layer 1 Production Gate.**

Do not start GB, US, IE or DE production APPLY until CA reaches an accepted gate and the controlled country order advances.
