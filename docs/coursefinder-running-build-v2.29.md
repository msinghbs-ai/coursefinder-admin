# CourseFinder Running Build v2.29

**Date:** 19 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.27.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.27.md`  
**Previous build:** `docs/coursefinder-running-build-v2.28.md`

## Current build position

All previously accepted AU/NZ Layer 1, AU QILT, AU PRISMS and AU Scholarship gates remain accepted. This build records a completeness/design correction identified during live AU revalidation.

## AU live completeness baseline

| Dimension | Live state |
|---|---:|
| Providers | 1,546 |
| Providers with subdivision | **0** |
| Courses | 26,648 |
| Campuses | 3,922 |
| Campuses with subdivision | **0** |
| Course-Campus links | **47,671** |
| Courses with structured fees | **0** |
| Courses with legacy `course_url` | **0** |
| Relational Course Links | **0** |
| AU subdivision reference rows | 8 |

Important correction: Course-Campus relationships are already present and are not a current Layer 1 gap. The missing "course links" dimension is provider/handbook/fee/application web URLs.

## Geography defect and correction

The AU CRICOS worker already sends the published Location `State` token into `svc_layer1_apply_location_records`.

The service resolver expected canonical subdivision code/name, while CRICOS sends abbreviations such as `NSW` and the canonical code is `AU-NSW`. This caused valid source states to remain null.

Applied live migration:
- `au_geography_course_links_hardening`;
- repository migration `053_au_geography_course_links_hardening.sql`.

New exact resolver accepts only:
- exact canonical code;
- exact canonical subdivision name;
- exact canonical code suffix.

Tested examples:
- `NSW` -> `AU-NSW`;
- `AU-VIC` -> `AU-VIC`;
- `Queensland` -> `AU-QLD`;
- `UNKNOWN` -> null.

No State is inferred from city/postcode/address.

The Provider service contract is now capable of accepting direct source state/address/postcode, but the current AU worker still forwards only Provider postal city. Therefore Provider geography remains unpopulated until the worker is upgraded and an evidence-backed bounded replay is run.

## Course Links foundation

Migration 053 also creates `catalogue.course_links` as the relational source-of-truth for Course web resources.

It supports multiple evidence-backed URL types per Course while keeping `catalogue.courses.course_url` as a compatibility/current-primary field.

Current live Course Links rows: **0**. This is expected until Layer 2 provider enrichment is implemented.

## Course Fee hardening

Existing `catalogue.course_fees` already had the required core dimensions but lacked deterministic source-local replay identity.

Applied live migration:
- `course_fee_source_identity_hardening`;
- repository migration `054_course_fee_source_identity_hardening.sql`.

Added:
- optional campus scope;
- `source_fee_key`;
- status/lifecycle;
- last verification/update timestamps;
- source identity uniqueness and covering indexes.

Current AU fee rows remain **0**. Fee values must come from qualified authoritative/first-party Layer 2 sources, not CRICOS or inference.

## Advisor state

Post-DDL Performance Advisor reports no new unindexed foreign key on Course Links or Course Fees. The remaining unindexed FK is the pre-existing `pipeline.ca_course_scope_keys.provider_id` item.

New unused-index INFO notices are expected because the new tables/columns have no production observations yet.

Security remains deny-by-default for the new Course Links table: RLS enabled, no `anon`/`authenticated` direct grants, service-role write/read boundary. Existing project-wide `SECURITY DEFINER` UI RPC warnings remain a separate hardening workstream.

## Next build gate

1. Patch `layer1-au-depth` to forward direct CRICOS Provider postal state/address/postcode where published.
2. Execute bounded AU CRICOS geography replay using existing identifiers/evidence rules.
3. Verify Campus subdivision coverage and explicit unmapped token count.
4. Verify Provider primary/postal subdivision independently from Campus coverage.
5. Preserve 1,546 Provider / 26,648 Course / 3,922 Campus identity counts and 47,671 Course-Campus relationships.
6. Qualify Layer 2 first-party Course page and international fee sources.
7. Build evidence-backed Course Links/Fee adapter with dry-run/APPLY/replay/idempotency UAT.
8. Only after those gates update State/Fee/Link completeness and Search/consumer filters.
