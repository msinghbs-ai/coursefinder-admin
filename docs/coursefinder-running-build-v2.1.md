# Coursefinder Running Build v2.1

## Current Phase
Layer 1 production-style regulatory ingestion controls after successful full AU CRICOS phase gate. Germany (DE) production validation is active but canonical APPLY is blocked pending a stable non-name Provider identity source/mapping.

## Production Execution Contract
Settings > Regulatory ingestion runs one country at a time.

Every Layer 1 request carries:
- `country`
- `apply`
- `offset`
- `batchSize`

Country adapters return progress metadata including:
- `totalRecords`
- `selectedRecords`
- `nextOffset`
- `hasMore`
- reconciliation counts
- evidence/job references

The Settings screen can continue from the exact next offset or re-run the current offset for idempotency validation where that country is cleared for APPLY.

## Country Routing
`layer1-register-etl` remains the single authenticated Platform Admin entrypoint and routes to programmed country logic.

### AU — CRICOS
- Adapter: consolidated CRICOS Providers / Courses / Locations ZIP.
- Canonical identity: CRICOS Provider Code and CRICOS Course Code.
- Bounded core slice: default 2,500 courses; hard UI maximum 5,000.
- Each selected course slice reconciles matching provider Locations and Course Locations.
- Canonical output: Providers, Courses, Campuses and Course↔Campus relationships.
- Search Projection finalises after Apply.

### GB — UKVI + configured course source
- UKVI provider register is bounded by offset/batch.
- Configured country course source remains routed through the preserved Layer 1 country adapter.

### DE — DAAD / HRK identity dependency
- Live DAAD International Programmes source is reachable and remains the configured international-programme acquisition source.
- Production validation on 12 August 2026 confirmed the DAAD search API currently reports 2,434 programme records.
- The API supports bounded retrieval using `limit` and `offset`.
- The API `page` parameter does not provide pagination: `page=1` and `page=2` return the same leading records unless `offset` changes.
- Deployed worker `layer1-edge-v1.4.1` still calculates pagination from `page`; therefore its upstream acquisition behaviour is not yet accepted as the final DE bounded implementation even though selected reconciliation slices are bounded.
- The DAAD search and programme-detail payloads expose stable programme IDs but no stable Provider/institution identifier; the Provider field is descriptive `academy` text.
- The existing adapter therefore must not use `slug(academy)` as canonical Provider identity.
- Production migrations `042_guard_de_daad_name_derived_identity.sql` and `043_harden_de_daad_guard_function_acl.sql` now block DE `registration_scheme=daad` Provider registration writes and restrict the guard to `postgres` / `service_role`.
- The guard was verified with an attempted service reconciliation: SQLSTATE `23514` was returned and DE remained at 0 Providers / 0 Provider Registrations / 0 Courses / 0 Course Registrations / 0 Search Documents.
- UI default remains 100 records with a 250-record maximum. Before DE gate re-entry, the Edge adapter should use DAAD `limit + offset` directly and enforce the DE ceiling server-side.
- Current source registry retains HRK Hochschulkompass as DE primary coverage and DAAD International Programmes as complementary official international-programme coverage.

### CA / IE / NZ / US
- Current adapters use the preserved country Layer 1 snapshot plus a live source freshness check.
- They follow the same offset/batch execution contract so their acquisition implementation can later be replaced without changing the Admin workflow.

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

The UI also loads the latest completed country job and resumes from its `result.nextOffset` where available.

## Runtime Versions
- `layer1-register-etl`: `layer1-edge-v1.4.1`
- `layer1-au-depth`: `layer1-au-depth-v1.1.0`
- Both remain `verify_jwt=true` and require server-side Platform Admin authorisation.
- DE DB safety gate: production migrations `042` + `043` active.

## AU Baseline Preserved
The accepted AU full-ingestion baseline remains:
- Providers: 1,546
- Courses: 26,648
- Campuses: 3,922
- Course↔Campus: 47,671
- Search Documents: 26,648

The DE guard does not change the accepted AU catalogue population or canonical identity architecture.
