# CourseFinder Zoho Integration Read Contract v1.0

**Contract code:** `zoho-integration-v1`  
**Status:** PILOT / UAT — SERVER-SIDE READ CONTRACT  
**Date:** 27 August 2026  
**Change Control:** CF-CHG-20260827-045  
**Semantic dependency:** `coursefinder-zoho-consumer-contract-v1.3.md`

## 1. Boundary

Zoho Creator is a separate CourseFinder consumer. It must not use the Website contract blindly and must never query raw `catalogue`, `pipeline`, Evidence, review, Vault, Search internals or Admin tables.

Pilot functions are service-role-only database helpers. The first server-side transport is now deployed for the Courses screen as Supabase Edge Function `zoho-course-api`. **Do not place the Supabase service-role key in Zoho Creator, Deluge, forms, pages or browser code.**

Production is a later clean trust boundary and is not covered by this contract.

## 2. Authority

Zoho is read/operational presentation only in v1. It cannot:
- establish or change Provider/Course/Scholarship identity;
- bypass Layer 1 → Layer 2 → Layer 3 → Layer 4 authority;
- write canonical facts;
- publish;
- change Search visibility.

Any future Zoho write capability requires a separate governed change.

## 3. Resources

### Providers
- `api.zoho_provider_search_v1(query,country_code,changed_since,limit,offset)`
- `api.zoho_provider_lookup_v1(identifier)`

Stable ID: `provider_id = catalogue.providers.stable_key`.

### Courses
- `api.zoho_course_search_v1(query,country_codes,provider_ids,subdivision_codes,has_scholarship,changed_since,limit,offset)`
- `api.zoho_course_lookup_v1(identifier)`

Stable ID: `course_id = search.course_documents.course_stable_key`.
Exact lookup accepts stable ID or governed Course code.

### Campuses
- `api.zoho_campus_search_v1(query,country_code,provider_ids,subdivision_codes,changed_since,limit,offset)`
- `api.zoho_campus_lookup_v1(identifier)`

Stable ID: `campus_id = catalogue.campuses.stable_key`.

### Scholarships
- `api.zoho_scholarship_search_v1(query,provider_ids,changed_since,limit,offset)`
- `api.zoho_scholarship_lookup_v1(identifier)`

Stable ID: `scholarship_id = scholarship.scholarships.stable_key`.

### Reconciliation / incremental sync
- `api.zoho_sync_manifest_v1(changed_since)`

Returns per-resource counts/max timestamps and deterministic ordering metadata.

## 4. Paging and ordering

- default page: 20;
- hard database cap: 50;
- Zoho UI should normally render 10 rows/options at a time in accordance with the platform A10 contract;
- offsets are non-negative;
- Provider: `name ASC, provider_id ASC`;
- Course: `title ASC, course_id ASC`;
- Campus: `name ASC, campus_id ASC`;
- Scholarship: `name ASC, scholarship_id ASC`.

Paging and filter-option paging are independent.

## 5. Incremental sync

`changed_since` is an exclusive UTC timestamp watermark.

A sync cycle should:
1. capture the previous successful watermark;
2. call `zoho_sync_manifest_v1(previous_watermark)`;
3. page each changed resource using the same watermark;
4. upsert into Zoho by stable ID;
5. reconcile expected versus processed counts;
6. advance the Zoho watermark only after the whole cycle succeeds.

Replaying the same watermark is safe for read operations. Zoho upsert logic must use the CourseFinder stable ID to prevent duplicates.

## 6. Null and state semantics

Do not collapse materially different states.

Use/retain where supplied:
- `present`;
- `source_null`;
- `zero`;
- `suppressed`;
- `not_applicable`;
- `not_yet_enriched`;
- `stale`;
- `ambiguous`;
- `rejected`.

Rules:
- numeric zero is a value, not missing;
- empty related-object arrays mean no admitted records in this payload, not proof that none exist;
- `has_value=false` is not interchangeable with amount 0;
- `lifecycle_status` and `publication_status` remain independent;
- freshness/verification is not approval.

## 7. Fees

Keep regulatory tuition and Provider-current tuition separate. Never display one unlabeled generic “Tuition”.

Regulatory tuition retains its regulated source basis. Provider-current tuition represents accepted current Provider-derived data where available.

## 8. QILT / PRISMS context

QILT/PRISMS are not Course facts.

Valid Course-detail joins are contextual:
- Course → Provider → QILT Provider outcomes;
- Course → Study Area → QILT study-area outcomes;
- Course → Provider / State / Sector → PRISMS context;
- Country → country-level context.

Each insight DTO must contain:
- `source`;
- `grain`;
- `scope`;
- `reporting_period`;
- `metric`;
- `value/state`;
- `freshness`.

Current Pilot `zoho_course_lookup_v1` deliberately returns QILT/PRISMS context as `state=not_admitted` until a current governed read projection at the correct grain is reconciled. This must be presented as unavailable/not yet admitted, not as zero or no outcome.

## 9. Errors

Database helper objects return bounded resource errors such as:
- `NOT_FOUND` for failed exact lookup.

The HTTP transport implements or must preserve:
- 400 malformed/unsupported input;
- 401 missing/invalid integration authentication;
- 403 authenticated but not authorised;
- 404 exact resource not found;
- 409 reconciliation/idempotency conflict where applicable;
- 429 rate limit;
- 5xx server failure without SQL, secret, internal path or Evidence leakage.

Search no-results is 200 + empty `items`.

## 10. Authentication and rate limiting

Current DB helpers are `service_role` only. That is an internal server boundary, not a Zoho credential model.

Pilot transport:
- Zoho Creator uses a Creator **Connection** or other server-side credential store;
- credential is scoped to the dedicated CourseFinder Pilot integration endpoint;
- endpoint stores/uses Supabase service credentials only server-side;
- rotate credentials independently of Production;
- rate-limit by integration identity and resource;
- log request ID, resource, outcome, latency and reconciliation counts without payload secrets.

For the Courses screen, `zoho-course-api` v2 is deployed under CF-CHG-045. It authenticates a dedicated Pilot bearer token by SHA-256 hash against a private service-role-only credential table, rate-limits each action to 120 requests/minute, returns request IDs and safe errors, and never exposes the Supabase service-role key. Creator Connection end-to-end acceptance remains open.

## 11. Explicit exclusions

Never return:
- Evidence payloads/IDs/storage paths;
- review comments/IDs;
- Layer 2/3 provider credentials;
- Vault values;
- service-role/database credentials;
- raw pipeline jobs/attempt internals unless a separate operational DTO is governed;
- embedding vectors;
- arbitrary raw canonical CRUD.

## 12. UAT baseline

Targeted Pilot evidence on 27 August 2026:
- exact Course `082960F`: PASS;
- deterministic replay item equality: PASS;
- AU nursing search: 330 total, 5 returned for limit 5: PASS;
- limit cap 50: PASS;
- all nine v1 functions anon/authenticated denied and service_role allowed: PASS;
- 30-day incremental Course baseline: 33,105; future watermark 0: PASS;
- Security Advisor: INFO only; no Zoho-specific finding;
- Performance Advisor: INFO only; no Zoho-specific finding.

Courses-screen Supabase transport deployment is PASS. Actual Zoho Creator Connection invocation, external-path malformed-request/401/404/429 checks and responsive UI acceptance remain open.