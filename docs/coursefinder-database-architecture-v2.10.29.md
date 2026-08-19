# CourseFinder Database Architecture v2.10.29

Status: **AUTHORITATIVE**
Date: 19 August 2026
Supersedes: `docs/coursefinder-database-architecture-v2.10.28.md`

## 1. Version scope

v2.10.29 preserves every accepted canonical Provider/Course/Campus identity, source/evidence, lifecycle, geography, exact-field and relational contract from v2.10.28. This version adds the **M1-SEARCH governed derived-projection and consumer API boundary** only.

No Search structure may redefine canonical identity. Search can be destroyed and regenerated from accepted canonical/relational data plus explicit Search governance gates.

## 2. Search is a derived projection

`search.course_documents` is not a source of truth. It is a versioned projection with explicit country and enrichment admission gates.

The active Course projection version is `course-v2`.

Required projection metadata includes:

- stable Course and Provider business keys;
- country, study-level and field codes suitable for filter contracts;
- weighted full-text search document;
- multi-valued `subdivision_codes[]` derived through Course → Course Campus → Campus → Subdivision;
- multi-valued `delivery_modes[]` derived through Course → Course Campus;
- readiness flags;
- projection generation/version/timestamps;
- a complete projection content hash; and
- a separate semantic-content hash for embedding invalidation.

A Search row must never become a replacement for the canonical record.

## 3. Country admission gate

Search country admission is controlled by `search.projection_country_gates` and is independent of general country ingestion/search feature flags.

For the M1-SEARCH accepted gate:

- AU — APPROVED
- NZ — APPROVED
- every other country — not admitted until a separate Search UAT decision is recorded

This prevents newly ingested CA/GB/US/IE/DE data from appearing in the accepted AU+NZ projection merely because those countries are ingestion-enabled.

Current governed projection count: **33,105 Search Documents** = AU 26,648 + NZ 6,457.

## 4. Enrichment admission gate

Search enrichment admission is controlled by `search.enrichment_gates`.

A relational fact enters Search only when both conditions are true:

1. its Search domain gate is approved; and
2. the underlying fact satisfies its lifecycle/validity/publication rules.

Current state:

| Domain | Search gate | Consumer outcome |
|---|---|---|
| Canonical field | accepted substrate | projected |
| Canonical geography / Course Campus | accepted substrate | projected |
| Course Campus delivery | accepted substrate | projected |
| Scholarship | approved structurally | only published/internal scholarships may set Search readiness; currently none |
| Course Link | blocked | not projected as ready |
| Course Fee | blocked | not projected as ready |
| Course Intake | blocked | not projected as ready |
| English requirement | blocked | not projected as ready |

The gate deliberately prevents a future ingestion job from making an unreviewed fact searchable just because a relational row exists.

## 5. Geography and delivery semantics

Course State remains relational and multi-valued.

Canonical path:

`Course → catalogue.course_campuses → catalogue.campuses → ref.subdivisions`

Search projection path:

`Course → subdivision_codes[]`

A multi-State Course must retain all accepted State codes. No representative State, provider State or first-linked Campus may be substituted.

At M1-SEARCH gate:

- AU Courses with State: 26,613;
- AU Courses with delivery evidence: 26,614; and
- AU multi-State Courses: 4,388.

## 6. Projection lifecycle

`search.refresh_course_documents_v2(p_apply boolean)` is the governed rebuild contract.

Dry-run reports prospective rows, country counts, coverage, added/changed/unchanged/removed rows and a deterministic aggregate hash without mutating the projection.

Apply performs a transactional upsert/delete against the staged accepted set and advances `search.projection_state` only after the projection mutation succeeds.

The legacy `search.rebuild_course_documents()` entry point is retained only as a compatibility wrapper over the governed v2 refresh. It must not use an unscoped delete/reinsert.

Current accepted state:

- generation: 12;
- rows: 33,105;
- hash: `e4d72aa009ec5ce6ac00ee61d7e2286514c1fe5251faab2292c24d54a26233f6`;
- replay: 0 changed / 33,105 unchanged.

## 7. FTS, vector and hybrid architecture

Weighted PostgreSQL FTS remains the accepted production search kernel for the current projection.

Vector data is stored separately from canonical/Search document rows. Embeddings are keyed by Course, profile/model and semantic-content hash. HNSW cosine indexing remains the vector access method.

`search.course_candidates_v1` supports keyword, vector and hybrid/RRF candidate generation. Hard filters are applied before ranking where possible. If hybrid is requested but no accepted matching embedding set exists, the function deterministically returns `fts_fallback`; it must not synthesize vector scores.

Current embedding count is **0**. Therefore M1-SEARCH does not claim semantic relevance or vector latency acceptance. Vector-content admission requires a separate approved model/profile and embedding-generation UAT.

The previously retained 1536-dimensional storage/HNSW structure is an implementation capability, not approval of a particular embedding model.

## 8. Curated consumer boundary

Internal database schemas are not consumer APIs.

Website and Zoho integrations consume versioned DTO contracts through trusted gateways/RPC boundaries; they do not receive direct access to `catalogue`, `search`, `pipeline`, `publishing`, `scholarship`, `ref` or evidence/review tables.

### Website search contract

Database contract: `api.website_course_search_v1`

Contract version: `website-course-search-v1`

Execution: service gateway only.

Visibility: `publication_status='published'` only.

Allowed response fields are consumer-safe business fields such as Course key/title/code, Provider key/name, country, study level, exact field, State array, delivery-mode array, readiness flags and match metadata.

No source IDs, evidence IDs, raw claims, review workflow state, vector payloads or internal table/column contracts are exposed.

### Zoho candidate contract

Database contract: `api.zoho_course_candidates_v1`

Contract version: `zoho-course-candidates-v1`

Execution: authenticated CourseFinder user with role rank >= Counsellor.

Visibility: `published` and `internal` only.

Zoho may apply CRM/commercial ranking after the academic candidate set is returned. Commercial ranking must not overwrite canonical facts or Search academic relevance profiles.

## 9. Publication boundary

Search readiness is not publication.

At this gate all 33,105 Search Documents remain `unpublished`. Consequently the curated Website and Zoho contract UAT correctly returns an empty `items` array while preserving a valid v1 response envelope.

No project phase may change publication state merely to make Search/API UAT return sample rows.

## 10. Security boundary

- `anon` has no direct execution grant on M1-SEARCH functions.
- Website search RPC is executable by `service_role` only and returns published data only.
- Zoho candidate RPC is executable by `authenticated` and enforces role rank >= 2.
- Search refresh/rebuild and hybrid candidate functions are service-only.
- Search/canonical schemas remain non-consumer implementation details.

Existing Admin/PIM public `SECURITY DEFINER` warnings are outside this architecture delta and remain tracked separately.

## 11. Accepted benchmark evidence

Representative Pilot database timings on 19 August 2026:

| Path | Case | Execution |
|---|---|---:|
| Weighted FTS | `data science`, AU, top 20, warm | ~1.95 ms |
| Structured filters | AU + Business & Management + VIC + on-campus, top 20 | ~11.35 ms |
| Hybrid with no accepted vectors | `data science`, AU, top 20 | ~11.77 ms, `fts_fallback` |

An earlier generic hybrid-fallback implementation measured ~159 ms and was rejected/optimised before this architecture was accepted.

## 12. UAT and implementation references

Pilot UAT: `msinghbs-ai/Coursefinder-Pilot/docs/m1-search-governed-projection-uat-2026-08-19.md`

Pilot migrations:

- `20260819045418_m1_search_governed_projection_v1`
- `20260819045543_m1_search_consumer_contracts_v1`
- `20260819045719_m1_search_hybrid_fallback_optimisation_v1`
- `20260819045818_m1_search_country_gate_fk_index_v1`

## 13. Gate decision

**M1-SEARCH governed projection / FTS / curated Website+Zoho contract gate: PASS.**

**Vector-content / semantic relevance gate: PENDING and CLOSED to production publication until separately accepted.**
