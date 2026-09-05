# CF-CHG-20260905-198 — Bounded UQ/UWA Scholarship Detail Wave

**Status:** IMPLEMENTED / RUNTIME PASS  
**Milestone:** M2.4.5  
**Layer:** Layer 2 — Scholarship detail acquisition

## Scope

Using the CF-196 first-party catalogue Evidence, seeded exactly three detail candidates:

- UQ International Excellence Scholarship
- UWA Global Excellence Scholarship
- UWA International Student Award

The governed detail batch preview returned 1 ready UQ record and 2 ready UWA records. All three were dispatched through the normal CF-186 detail path and succeeded via direct HTTP.

## Evidence/extraction result

- UQ: `25% reduction`, international, first-party detail, normalised Evidence `3a7c66c8-99ec-4842-9279-d70f8202fa2c`.
- UWA Global Excellence: international, first-party detail, normalised Evidence `1f0c3183-afbc-4e3a-a97e-72fbc8b51e25`; extractor did not claim a single award amount because the page is tiered/up-to.
- UWA International Student Award: `$5,000` extraction, international, first-party detail, normalised Evidence `3e787c84-20e6-480f-9c32-6ec5ce71051b`.

`scholarship.reconcile_verified_detail_records` then created three new canonical **unpublished** roots. No publication changed.

## Boundary

The UWA values are not force-normalised where first-party semantics are ambiguous or edition-sensitive. Course scope remains unresolved and is handled separately under CF-200.
