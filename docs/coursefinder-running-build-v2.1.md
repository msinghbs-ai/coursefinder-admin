# Coursefinder Running Build v2.1

## Current Phase
Layer 1 production-style regulatory ingestion controls after successful full AU CRICOS phase gate.

## Production Execution Contract
Settings > Regulatory ingestion now runs one country at a time.

Every Layer 1 request carries:
- `country`
- `apply`
- `offset`
- `batchSize`

Every country adapter returns bounded progress metadata including:
- `totalRecords`
- `selectedRecords`
- `nextOffset`
- `hasMore`
- reconciliation counts
- evidence/job references

The Settings screen can continue from the exact next offset or re-run the current offset for idempotency validation.

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

### DE — DAAD
- Live DAAD programme source is paged.
- The adapter calculates the upstream start page from the requested record offset and page size.
- It fetches only enough pages to satisfy the bounded batch.
- UI default is 100 records with a 250-record maximum per execution.

### CA / IE / NZ / US
- Current adapters use the preserved country Layer 1 snapshot plus a live source freshness check.
- They follow the same offset/batch execution contract so their acquisition implementation can later be replaced without changing the Admin workflow.

## Admin UX
The old `Dry-run all 7 / Apply all 100` UAT model has been removed from the primary workflow.

The production-style workflow is now:
1. Select country.
2. Review adapter, programmed logic, identity model and configured source health.
3. Set bounded batch size / offset.
4. Validate batch without writes.
5. Apply bounded batch with explicit `APPLY <COUNTRY>` confirmation.
6. Continue using returned `nextOffset`.
7. Optionally re-run the current batch to prove idempotency.

The UI also loads the latest completed country job and resumes from its `result.nextOffset` where available.

## Runtime Versions
- `layer1-register-etl`: `layer1-edge-v1.4.1`
- `layer1-au-depth`: `layer1-au-depth-v1.1.0`
- Both remain `verify_jwt=true` and require server-side Platform Admin authorisation.

## AU Baseline Preserved
The accepted AU full-ingestion baseline remains:
- Providers: 1,546
- Courses: 26,648
- Campuses: 3,922
- Course↔Campus: 47,671
- Search Documents: 26,648

This change modifies the production execution/control model; it does not reset or replace the accepted AU catalogue population.
