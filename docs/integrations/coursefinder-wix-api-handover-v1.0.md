# CourseFinder Wix Developer API Handover v1.0

**Date:** 5 September 2026  
**Environment:** Pilot  
**Consumer:** Wix / CourseFinder website  
**Source of truth:** CourseFinder Supabase Pilot  
**Repository:** `msinghbs-ai/coursefinder-admin`

## 1. Purpose

Wix is a downstream presentation/search consumer. It must not connect directly to CourseFinder database tables and must not receive Supabase `service_role` or other privileged keys.

The preferred architecture is cache-first:

1. CourseFinder remains canonical.
2. A Wix backend scheduled job calls the CourseFinder website sync API.
3. Wix stores a website-shaped cache in CMS collections.
4. Website search/filter/detail pages query Wix cache locally.
5. CourseFinder API is used again only on the next scheduled refresh, explicit cache refresh, or controlled lookup fallback.

This keeps page performance independent of live CourseFinder/Supabase latency and reduces API/database traffic.

## 2. Endpoints

### Cache/synchronisation endpoint

`POST https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1/wix-course-api`

Edge Function: `wix-course-api` v1.

Supported actions:

- `reference_bundle`
- `sync_courses`
- `lookup`

### Existing website interactive endpoint

`POST https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1/website-course-api`

This remains the website interactive/pilot contract for search, lookup, provider/filter options and reference bundle. The Wix cache endpoint should be preferred for scheduled catalogue ingestion.

## 3. Authentication

Store the CourseFinder Wix API key in Wix Secrets Manager / backend-only configuration.

Preferred header:

```text
Authorization: Bearer <COURSEFINDER_WIX_PILOT_API_KEY>
```

The same pilot credential is registered as `coursefinder_website_wix_pilot_v1`.

Never place this key in browser code, page source, frontend fetch calls, public environment variables, CMS records, GitHub, or logs.

Do not request or use the Supabase `service_role` key.

The raw Wix key is intentionally not committed to this repository and must be transferred out-of-band.

## 4. Initial cache load

### Step A — reference data

Request:

```json
{"action":"reference_bundle"}
```

Cache the returned countries, subdivisions, providers, study levels, study areas, intake labels, English-test values and platform/filter metadata.

Recommended refresh: once daily.

### Step B — courses

Request the first page:

```json
{"action":"sync_courses","limit":50,"offset":0}
```

Continue with offsets `50`, `100`, `150`, etc. until `offset + items.length >= page.total`.

Use `course_id` as the stable Wix upsert key. Do not identify courses by title.

Recommended initial import: backend-only, chunked and bulk-written into Wix CMS.

## 5. Incremental refresh

After a successful full load, persist the completed CourseFinder sync timestamp in a small Wix control collection, for example `CourseFinderSyncState`.

Next run:

```json
{
  "action":"sync_courses",
  "changed_since":"2026-09-05T00:00:00Z",
  "limit":50,
  "offset":0
}
```

Continue paging until complete, then advance the stored cursor only after all pages have been successfully written.

Use a small overlap window (recommended 5 minutes) when calculating `changed_since` so timestamp boundary changes cannot be missed. Because Wix upserts by stable `course_id`, replay is safe.

## 6. Recommended Wix schedule

Use two scheduled jobs rather than making CourseFinder calls from normal page rendering:

- **Reference refresh:** daily.
- **Course delta refresh:** hourly where the Wix plan permits; otherwise use the shortest supported interval appropriate to the site's plan.

A manual admin refresh can call the same backend synchronisation functions.

Do not create one scheduled job per provider or per filter. One reference job plus one paged course-delta job is the preferred pattern.

## 7. Wix collections

Recommended logical collections:

### `CF_Courses`

Minimum fields to index/query locally:

- `_id` or unique mapped stable `course_id`
- `course_id`
- `course_code`
- `title`
- `provider_id`
- `provider_name`
- `country_code`
- `subdivision_codes`
- `study_level_code`
- `primary_field_code`
- `primary_field_name`
- `delivery_modes`
- `regulatory_tuition_amount`
- `regulatory_tuition_currency`
- `provider_annual_tuition_amount`
- `provider_annual_tuition_currency`
- `official_course_url`
- `has_intake`
- `has_english`
- `has_scholarship`
- `earliest_intake_date`
- `publication_status`
- `source_updated_at`
- `projection_updated_at`
- `generated_at`
- `raw_contract_version`

### `CF_Providers`

Provider/reference data derived from `reference_bundle`.

### `CF_Reference`

Countries, subdivisions, study levels, study areas, intake labels and English tests where separate collections are not required.

### `CF_SyncState`

Store:

- contract version
- last successful full sync
- last successful delta cursor
- last attempted sync
- status
- imported/updated/error counts
- last request ID

## 8. Performance design

The website should normally perform zero CourseFinder API calls during a visitor search session.

Visitor path:

`Browser -> Wix backend/data query -> Wix cached collection`

Refresh path:

`Wix scheduled backend job -> CourseFinder Wix API -> Wix bulk upsert -> cache becomes current`

Use Wix indexes for the highest-value search/filter dimensions. Start with stable course ID as unique index and choose remaining regular indexes based on the production UX/filter combination rather than indexing every field.

Use bulk operations and small chunks. Do not write one CMS item per API request if a bulk operation is available.

## 9. TTL and freshness

Treat the cache as valid until the next successful scheduled sync rather than expiring each record independently.

Recommended policy:

- reference TTL: 24 hours
- ordinary course-data target freshness: 1 hour
- serve stale-on-sync-failure: yes, with monitoring
- never delete or replace the working cache before the replacement/delta transaction has completed successfully

If a refresh fails, continue serving the previous cache and retry on the next schedule/manual run.

## 10. Schema and database extension strategy

Do not mirror CourseFinder's internal database schema in Wix. The API contract is an anti-corruption layer between the canonical PIM and website.

When CourseFinder adds a new table, layer, statistic or data source:

1. Canonical database changes remain internal.
2. Decide whether the new fact is approved for website publication.
3. Extend the versioned website projection/API contract with an additive field or a new resource.
4. Wix ignores unknown fields until its cache schema/UI is ready.
5. Wix adds the new CMS field/collection and deploys code to consume it.
6. Only make a breaking contract change under a new major contract version.

This means database growth does not require Wix to understand Supabase tables, joins, evidence schemas or internal PIM layers.

Recommended contract metadata on every resource:

- `contract_version`
- `generated_at`
- stable record ID
- source/projection freshness timestamp

New optional fields should be additive. Existing field meaning must not be changed silently.

## 11. Future resources

Provider statistics, QILT, PRISMS, rankings, scholarships, logos/assets and other approved website data should be introduced as explicit API resources/bundles rather than by exposing database tables directly.

For large datasets, use one of:

- paged delta resource with `changed_since`, or
- versioned snapshot manifest plus paged resources.

This allows Wix to independently refresh only the affected cache collection.

## 12. Wix platform considerations

Current Wix guidance should be checked against the actual plan before production cutover. Relevant design constraints include scheduled-job frequency/quantity, CMS item quotas, read/write request quotas, request payload limits, backend timeouts and index limits.

Design assumptions for this integration:

- schedule work in backend code only;
- bulk-write cache records;
- page CourseFinder results;
- keep individual CMS items well below Wix item/payload limits;
- avoid a full catalogue rewrite for ordinary refreshes;
- query Wix data locally from the site;
- monitor sync-state and 429/5xx responses.

## 13. Error handling

Expected CourseFinder responses:

- `200` success
- `400` malformed/unsupported input
- `401` invalid/missing integration key
- `404` lookup not found
- `429` rate limited — honour `Retry-After`
- `503/5xx` bounded service failure

On `429` or `5xx`, do not clear Wix cache. Record the failed run and retry later.

## 14. Developer acceptance

Before UI integration is accepted, prove:

1. API key remains backend-only.
2. `reference_bundle` succeeds.
3. Initial paged `sync_courses` completes without duplicate IDs.
4. A second delta sync updates only changed/replayed records.
5. Wix visitor search works without live CourseFinder calls.
6. Failed sync leaves the last known-good Wix cache available.
7. 401 handling works with an invalid key.
8. 429 handling honours `Retry-After`.
9. Cache state exposes last successful sync and request ID for support.
10. No Supabase privileged credential is present in Wix frontend code.

## 15. Production cutover

This document and credential are Pilot-only. Before Production:

- deploy the governed website/cache API to the Production Supabase tenancy;
- generate a new Production Wix key;
- store it in Wix backend Secrets Manager;
- update the Wix endpoint to the Production project;
- complete cache-load and delta-sync acceptance;
- revoke/disable Pilot credentials from Production workflows.
