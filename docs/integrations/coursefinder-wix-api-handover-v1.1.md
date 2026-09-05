# CourseFinder Wix Developer API Handover v1.1

**Date:** 5 September 2026  
**Environment:** Pilot  
**Consumer:** Wix / CourseFinder website  
**Source of truth:** CourseFinder Supabase Pilot  
**Repository:** `msinghbs-ai/coursefinder-admin`  
**Status:** CURRENT / FULL INDEPENDENT HANDOVER  
**Supersedes:** `coursefinder-wix-api-handover-v1.0.md`

## Changes since v1.0

- formalises the handover-versioning rule: every future version is a complete standalone handover, not a patch-only document;
- adds a developer quick-start and explicit test sequence;
- adds API key lifecycle/expiry/rotation/transfer rules aligned to the new M2.4.5 H14 Admin requirement;
- adds cache-sync failure, replay and schema-extension responsibilities;
- clarifies Production credential separation and key revocation expectations.

> Versioning rule: v1.0 remains immutable historical evidence. When this handover changes, create `v1.2`, `v1.3`, etc. Each new file must repeat the complete endpoint, authentication, architecture, data contract, cache, test, support and cutover guidance and place the change summary at the top.

## 1. Purpose

Wix is a downstream presentation/search consumer. It must not connect directly to CourseFinder database tables and must not receive Supabase `service_role` or other privileged keys.

The preferred architecture is cache-first:

1. CourseFinder remains canonical.
2. A Wix backend scheduled job calls the CourseFinder website sync API.
3. Wix stores a website-shaped cache in CMS collections.
4. Website search/filter/detail pages query Wix cache locally.
5. CourseFinder API is used again only on the next scheduled refresh, explicit cache refresh, or controlled lookup fallback.

This keeps page performance independent of live CourseFinder/Supabase latency and reduces API/database traffic.

## 2. Developer quick start

1. Receive the Wix Pilot API key through an approved secure transfer method. Do not request a Supabase key.
2. Store the key in Wix Secrets Manager/backend-only configuration.
3. Test `reference_bundle` from Wix backend code.
4. Test one `lookup` using a known Course identifier.
5. Run the initial paged `sync_courses` load into Wix cache collections.
6. Configure the scheduled reference refresh and Course delta refresh.
7. Prove visitor search/filter/detail pages read only from Wix cache.
8. Record last successful sync, request ID and cursor in `CF_SyncState`.
9. Complete the acceptance checklist in section 16 before UI sign-off.

## 3. Endpoints

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

## 4. Authentication

Store the CourseFinder Wix API key in Wix Secrets Manager / backend-only configuration.

Preferred header:

```text
Authorization: Bearer <COURSEFINDER_WIX_PILOT_API_KEY>
```

The Pilot credential identity is:

```text
coursefinder_website_wix_pilot_v1
```

Never place the raw key in browser code, page source, frontend fetch calls, public environment variables, CMS records, GitHub, screenshots, tickets or ordinary logs.

Do not request or use the Supabase `service_role` key.

The raw Wix key is intentionally not committed to this repository and must be transferred out-of-band.

### Key lifecycle rules

The CourseFinder Admin control plane will own the external-consumer API key lifecycle. The Wix developer should expect each credential to have:

- consumer/integration name;
- environment (`Pilot`, later `Production`);
- credential identity;
- status (`active`, `expiring`, `expired`, `revoked`, `disabled`);
- created/rotated timestamp;
- optional expiry timestamp;
- last-used/last-success signal where available;
- rotation history/audit reference;
- copy/secure-send action available only at creation/rotation while the raw value is transiently available.

The raw secret must not be recoverable from the stored hash after the creation/rotation window. If a developer loses a key, rotate it; do not attempt to reveal the existing secret.

Pilot and Production keys must always be different credentials.

## 5. API request examples

### Reference bundle

```json
{"action":"reference_bundle"}
```

### Initial Course sync

```json
{"action":"sync_courses","limit":50,"offset":0}
```

### Incremental Course sync

```json
{
  "action":"sync_courses",
  "changed_since":"2026-09-05T00:00:00Z",
  "limit":50,
  "offset":0
}
```

### Exact Course lookup

```json
{
  "action":"lookup",
  "identifier":"082960F"
}
```

## 6. Initial cache load

### Step A — reference data

Call `reference_bundle` and cache the returned countries, subdivisions, providers, study levels, study areas, intake labels, English-test values and platform/filter metadata.

Recommended refresh: once daily.

### Step B — courses

Request the first page with `offset:0`, then continue offsets `50`, `100`, `150`, etc. until `offset + items.length >= page.total`.

Use `course_id` as the stable Wix upsert key. Do not identify Courses by title.

Recommended initial import: backend-only, chunked and bulk-written into Wix CMS.

## 7. Incremental refresh

After a successful full load, persist the completed CourseFinder sync timestamp in `CF_SyncState`.

For the next run, pass `changed_since` and page all results before advancing the stored cursor.

Use a small overlap window, recommended 5 minutes, when calculating `changed_since` so timestamp-boundary changes cannot be missed. Wix upserts must be idempotent by stable `course_id`, so replay is safe.

Do not advance the cursor on a partially failed run.

## 8. Recommended Wix schedule

Use two scheduled jobs rather than making CourseFinder calls from normal page rendering:

- **Reference refresh:** daily.
- **Course delta refresh:** hourly where the Wix plan permits; otherwise use the shortest supported interval appropriate to the site's plan.

A manual Admin refresh may call the same Wix backend synchronisation functions.

Do not create one scheduled job per Provider or per filter. One reference job plus one paged Course-delta job is the preferred pattern.

## 9. Wix collections

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

- contract version;
- last successful full sync;
- last successful delta cursor;
- last attempted sync;
- status;
- imported/updated/error counts;
- last request ID.

## 10. Performance architecture

Normal visitor path:

`Browser -> Wix backend/data query -> Wix cached collection`

Refresh path:

`Wix scheduled backend job -> CourseFinder Wix API -> Wix bulk upsert -> cache becomes current`

The website should normally perform zero CourseFinder API calls during a visitor search session.

Use Wix indexes for the highest-value search/filter dimensions. Start with stable Course ID as unique index and add regular indexes based on the production UX/filter combinations rather than indexing every field.

Use bulk operations and small chunks. Do not write one CMS item per API request when a bulk operation is available.

## 11. TTL, stale-serving and failure behaviour

Treat the cache as valid until the next successful scheduled sync rather than expiring each record independently.

Recommended policy:

- reference TTL: 24 hours;
- ordinary Course-data target freshness: 1 hour;
- serve stale-on-sync-failure: yes, with monitoring;
- never clear or replace the working cache before a successful replacement/delta completion.

On a failed sync:

1. keep the last-known-good Wix cache active;
2. record failure status, request ID and error class;
3. do not advance the delta cursor;
4. retry on the next schedule or authorised manual run;
5. alert support if the failure persists beyond the agreed freshness target.

## 12. Schema and database extension strategy

Do not mirror CourseFinder's internal database schema in Wix. The API contract is an anti-corruption layer between the canonical PIM and website.

When CourseFinder adds a new table, layer, statistic or data source:

1. canonical database changes remain internal;
2. decide whether the new fact is approved for website publication;
3. extend the versioned website projection/API contract with an additive field or a new resource;
4. Wix ignores unknown fields until its cache schema/UI is ready;
5. Wix adds the new CMS field/collection and deploys code to consume it;
6. only make a breaking contract change under a new major contract version.

Recommended contract metadata on every resource:

- `contract_version`;
- `generated_at`;
- stable record ID;
- source/projection freshness timestamp.

New optional fields should be additive. Existing field meaning must not be changed silently.

### Handover versioning for extensions

When the API or Wix responsibilities change, create the next handover file as a complete independent document, for example:

- `coursefinder-wix-api-handover-v1.1.md`
- `coursefinder-wix-api-handover-v1.2.md`
- `coursefinder-wix-api-handover-v2.0.md`

Each file must start with **Changes since previous version**, then repeat the entire current handover. Do not require the developer to merge multiple documents mentally.

Use a minor version for additive/non-breaking changes. Use a major version for a breaking contract or materially different integration architecture.

## 13. Future resources

Provider statistics, QILT, PRISMS, rankings, scholarships, logos/assets and other approved website data should be introduced as explicit API resources/bundles rather than by exposing database tables directly.

For large datasets, use either:

- a paged delta resource with `changed_since`; or
- a versioned snapshot manifest plus paged resources.

This allows Wix to independently refresh only the affected cache collection.

## 14. Wix platform considerations

Current Wix limits must be checked against the actual Wix plan before Production cutover. Relevant design constraints include scheduled-job frequency/quantity, CMS item quotas, read/write quotas, request payload limits, backend timeouts and index limits.

Design assumptions:

- schedule work in backend code only;
- bulk-write cache records;
- page CourseFinder results;
- keep individual CMS items well below Wix item/payload limits;
- avoid a full catalogue rewrite for ordinary refreshes;
- query Wix data locally from the site;
- monitor sync-state and 429/5xx responses.

## 15. Error handling

Expected CourseFinder responses:

- `200` success;
- `400` malformed/unsupported input;
- `401` invalid/missing integration key;
- `404` lookup not found;
- `429` rate limited — honour `Retry-After`;
- `503/5xx` bounded service failure.

On `429` or `5xx`, do not clear Wix cache.

## 16. Developer testing and acceptance

Run these tests from Wix backend code, not the browser console.

1. **Authentication success:** valid key returns `200` for `reference_bundle`.
2. **Authentication failure:** invalid key returns `401` and no privileged data.
3. **Reference load:** cache the complete reference bundle and record the request ID.
4. **Known lookup:** `082960F` returns the expected Course payload or an explicitly governed replacement test identifier if the Pilot catalogue changes.
5. **Initial sync:** complete all `sync_courses` pages without duplicate stable IDs.
6. **Replay safety:** rerun the same page/range and confirm upserts do not create duplicate Courses.
7. **Delta sync:** run with a prior `changed_since` value and confirm only changed/replayed records are applied.
8. **Cursor safety:** force one failed page and confirm the Wix cursor is not advanced.
9. **Stale-serving:** simulate API failure and confirm visitor pages continue using the last-known-good cache.
10. **Rate limit:** confirm `429` handling honours `Retry-After`.
11. **Frontend secret scan:** confirm the key is absent from browser bundles, page source, public CMS and client-side network requests.
12. **Performance:** confirm ordinary visitor search/filter/detail operations execute against Wix cache only.
13. **Sync telemetry:** `CF_SyncState` shows last success, last attempt, counts, contract version and request ID.
14. **Schema tolerance:** add an unused optional field to a test payload and confirm Wix ignores it safely.
15. **Expiry/rotation:** replace the Wix secret with a rotated test credential and confirm the old/revoked credential fails after the agreed overlap window.

Acceptance evidence should record the Wix environment, handover version, API contract version, test date, result and any deviations.

## 17. Support and troubleshooting

When raising an API issue provide:

- Wix environment;
- action called;
- UTC/AEST timestamp;
- CourseFinder request ID;
- HTTP status;
- handover version;
- API contract version;
- current `CF_SyncState` status/cursor;
- whether the issue affects scheduled sync only or visitor cache reads.

Never include the raw API key in support evidence.

## 18. Production cutover

This document and current credential are Pilot-only. Before Production:

- deploy the governed website/cache API to the Production Supabase tenancy;
- create a separate Production Wix credential with an explicit owner and expiry/rotation policy;
- store it in Wix backend Secrets Manager;
- update the Wix endpoint to the Production project;
- complete initial cache load and delta-sync acceptance;
- prove expiry/rotation/revocation controls;
- revoke/disable Pilot credentials from Production workflows;
- update the next standalone handover version with the Production endpoint/contract and repeat the full document.
