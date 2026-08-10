# Coursefinder Pilot Validation — Wave 1 Scenario 6 v2.9

**Status:** Completed validation.

**Scope:** Adelaide University identity transition, evidence supersession, pilot catalogue API, and database traffic simulation.

---

## 1. Outcome summary

| Area | Outcome | Classification |
|---|---|---|
| Adelaide University identity transition | Separate canonical identities are correct; explicit provider lineage is required | `DESIGN_GAP` — provider relationship table missing from physical v2.9 |
| Evidence versioning | Existing evidence schema supports supersession | `IMPLEMENTATION_GAP` — pipeline does not populate supersession links |
| Public catalogue API shape | Pilot GET-only API deployed successfully | `PASS` for pilot API contract |
| RLS/anonymous read path | Representative query succeeds under `anon` database role | `PASS` |
| Canonical-table search traffic | Functional but inefficient for website search | `IMPLEMENTATION_GAP` — production Search Projection required, as already designed in v2.9 |

No production project was created.

---

## 2. Adelaide identity baseline

Current demo catalogue keeps three separate canonical provider identities:

- Adelaide University — CRICOS `04249J`
- The University of Adelaide — CRICOS `00123M`
- University of South Australia — CRICOS `00121B`

The current records must not be collapsed merely because Adelaide University was built from the two foundation institutions.

Official transition information confirms Adelaide University opened in 2026 and continuing students from the University of Adelaide and UniSA transitioned to Adelaide University programs. This is a lineage/succession relationship, not permission to rewrite historical identifiers.

### Required production representation

```text
University of Adelaide -----------\
                                  > Adelaide University
University of South Australia ----/
```

Each provider retains:

- its own stable provider ID;
- its own historical/current registration identifiers;
- validity periods;
- aliases;
- historical courses/evidence.

The relationship between providers is modelled explicitly.

### Confirmed design addition

Add `catalogue.provider_associations` to the final v2.9 consolidation:

- `id uuid PK`
- `source_provider_id uuid FK catalogue.providers NOT NULL`
- `target_provider_id uuid FK catalogue.providers NOT NULL`
- `association_type text NOT NULL`
- `directional boolean NOT NULL default true`
- `valid_from date`
- `valid_to date`
- `notes text`
- `source_id uuid`
- `evidence_id uuid`
- timestamps
- UNIQUE `(source_provider_id,target_provider_id,association_type)`

Initial controlled association types:

- `successor_of`
- `predecessor_of`
- `foundation_of`
- `merged_into`
- `renamed_to`
- `related_provider`

For Adelaide, prefer a non-destructive lineage relationship such as `foundation_of` / `successor_of`; do not automatically merge the providers.

---

## 3. Evidence supersession

The current demo `evidence_artifacts` table already contains:

- `content_hash`
- `valid_from`
- `valid_to`
- `supersedes_evidence_id`
- `source_id`
- `job_id`
- `metadata`

The demo contains repeated evidence URLs, proving multiple snapshots can be retained. However, none of the current evidence rows populates `supersedes_evidence_id`.

### Production behaviour

When the same authoritative URL is re-fetched:

1. calculate content hash;
2. if unchanged, update freshness only / no new canonical candidate;
3. if changed, insert a new immutable evidence record;
4. set the new row `supersedes_evidence_id` to the previous evidence row;
5. set the prior record's `valid_to`;
6. create/re-open review only when relevant extracted facts materially changed.

Classification: `IMPLEMENTATION_GAP`. The database design is already sufficient.

---

## 4. Pilot catalogue API

Deployed Supabase Edge Function:

`catalogue-api-pilot-v2-9`

Source is retained in:

`supabase/functions/catalogue-api-pilot-v2-9/index.ts`

### API characteristics

- HTTP `GET` only;
- public pilot endpoint;
- query parameters: `q`, `country`, `level`, `limit`;
- maximum result size: 50;
- uses `SUPABASE_ANON_KEY`, not service-role credentials;
- therefore remains subject to the demo database's RLS policies;
- one catalogue query per request;
- returns only catalogue-safe fields;
- 30-second cache hint;
- returns measured function elapsed time for pilot diagnostics.

Example logical request:

```text
GET /catalogue-api-pilot-v2-9?q=data%20science&country=AU&level=masters&limit=20
```

### Pilot response contract

```json
{
  "api_version": "pilot-v2.9",
  "filters": {},
  "count": 20,
  "db_roundtrips": 1,
  "elapsed_ms": 0,
  "results": [
    {
      "course_id": "uuid",
      "course_name": "Master of Data Science",
      "level": "masters",
      "field_of_study": "Computer Science",
      "duration_weeks": 104,
      "course_url": "https://...",
      "provider": {
        "provider_id": "uuid",
        "university_name": "University name",
        "country_code": "AU",
        "city": "..."
      },
      "fees": []
    }
  ]
}
```

This API is intentionally a pilot. Production API must read from the v2.9 `search` / `api` projection rather than canonical tables.

---

## 5. Anonymous/RLS path validation

A representative catalogue query was executed under the PostgreSQL `anon` role rather than as database owner.

Result: successful.

This verifies the pilot API can use the anon/RLS path for the currently permitted demo catalogue data instead of bypassing RLS with `service_role`.

Production will replace the demo-wide public policies with deliberate `api` schema views/RPCs and narrowly scoped grants.

---

## 6. Database traffic simulation

### Workload

Executed a database-side equivalent of 1,000 website catalogue text searches over the current demo catalogue.

Query mix rotated between:

- Data Science
- Information Technology
- Cybersecurity
- Artificial Intelligence

Common constraints:

- Australia
- published courses
- top 20 ordered results

The test intentionally used the current canonical `courses` + `providers` model to determine whether direct canonical-table search is suitable for production website traffic.

### Results

- Search equivalents: **1,000**
- Total execution time: **~23.99 seconds**
- Effective serial DB execution: **~24 ms/search**
- Result rows processed: **20,000**
- Shared buffer hits: **531,003**
- Shared disk reads: **0**
- Temporary reads/writes: **0**

Because all tested pages were already in shared buffers, this is effectively a warm-cache result.

### Representative individual query timings

#### AU + title contains `Data Science`

- execution: **~24.02 ms**
- shared hits: **534**
- result: 20 rows

#### AU + Masters filter without free-text term

- execution: **~7.12 ms**
- shared hits: **534**
- result: 20 rows

### Query-plan finding

The free-text path repeatedly:

1. identifies Australian providers;
2. scans courses through the provider index;
3. performs case-insensitive `%term%` filtering on each provider's course rows;
4. sorts candidate rows for the top 20.

The existing provider FK index works, but the direct canonical-table API is not the desired website search architecture.

### Conclusion

`PASS` for functional scalability proof at pilot size, but **do not make this the production website query path**.

The test validates the existing v2.9 decision to use:

```text
Canonical PIM / Catalogue
        ↓ async projection
Search Document
        ├── structured facets/indexes
        ├── FTS/trigram text
        ├── categories/collections
        ├── scholarships summary
        └── pgvector embedding
        ↓
api.search_courses()
        ↓
Website / Zoho / Counsellor
```

Production search should benchmark its projection/API independently before go-live.

---

## 7. Recommended production performance gates

These are engineering targets for the next build, not current measured guarantees:

- common structured DB search: p95 under 50 ms;
- hybrid DB search: p95 under 100 ms before external network latency;
- public API end-to-end: p95 under 250 ms for cached/common searches in Australia;
- no direct wide canonical-table joins from website autocomplete;
- search projection rebuild must not block catalogue writes;
- load tests must include cold-cache, warm-cache and concurrent traffic;
- introduce API rate limiting before public production exposure.

---

## 8. Scenario 6 disposition

### Confirmed design change

`catalogue.provider_associations`.

### Existing design confirmed

- stable provider identity;
- temporal provider identifiers;
- immutable evidence versions;
- evidence supersession field;
- dedicated Search Projection;
- deliberate `api` exposure boundary.

### Implementation work confirmed

- populate evidence supersession links;
- detect material evidence change and re-open Layer 4 review;
- build production Search Projection;
- build production search RPC/API;
- add API rate limiting/observability;
- run genuine concurrent HTTP load tests after `Coursefinder_Prod` search projection exists.

---

## 9. Overall result

Scenario 6: **PASS WITH ONE DESIGN ADDITION**.

The Adelaide case validates the identity principle: names and institutional transition must not destroy canonical history.

The traffic simulation validates the search principle: canonical tables are the write model; the website must consume a governed, indexed read projection.
