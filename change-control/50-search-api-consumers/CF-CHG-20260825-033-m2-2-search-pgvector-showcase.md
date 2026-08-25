# CF-CHG-20260825-033 — M2.2 Bounded Search / pgvector Showcase

**Status:** APPROVED / IN PROGRESS  
**Category:** 50-search-api-consumers  
**Initiated:** 25 August 2026 20:08 AEST (+10:00)  
**Origin chat/workstream:** M2.2 — SECURITY-PRODUCTION-SEARCH-SHOWCASE  
**Owner:** CourseFinder Search/API consumer workstream  
**Change class:** Search projection / pgvector benchmark / bounded read contract / UAT

## Trigger

The Friday 28 August 2026 milestone meeting requires a defensible Search enhancement and practical technical discussion with website developers. The earlier M1 vector gate was not accepted. The current corpus is richer and already contains vector-ready schema/hash structures, so vector Search is reopened only as a governed, measurable candidate.

## Problem / requested outcome

Evaluate whether pgvector now adds useful relevance to the accepted deterministic `course-v3` Search projection while preserving structured hard filters, publication/visibility controls, consumer-safe fields and deterministic identity semantics.

Prepare a stable bounded website-developer Search/read contract even if vector remains deferred.

## Affected surfaces / related workstreams

- `search.course_documents`;
- `search.course_embeddings`;
- `search.embedding_jobs`;
- `search.query_embedding_cache`;
- `search.profiles`;
- existing `api.website_course_search_v2(...)` and any new versioned bounded Search/read function created under this control;
- Search projection/version/hash metadata;
- website developer contract and automated Search UAT;
- programme control `CF-CHG-20260825-032`;
- security/release controls under `70-security-platform` and `80-uat-release-operations`.

## Semantic impact

No canonical identity/source-authority change.

Embeddings are derived Search artefacts only. They must never become canonical identity or override deterministic hard filters/publication visibility. Private Evidence, reviewer notes, internal operational metadata, credentials and secrets must not be embedded or returned to consumer clients.

The accepted M1 fee semantics remain intact: CRICOS regulatory tuition is distinct from Provider-current tuition. QILT/PRISMS context must preserve real source grain if ever included in a consumer DTO.

## Before

- accepted Search projection: 33,105 AU+NZ `course-v3` documents;
- all Search documents unpublished;
- FTS accepted;
- vector/hybrid rejected/not admitted in M1 because embeddings/jobs/cache were zero and no measurable value was proven;
- `vector` extension is installed but availability did not imply acceptance.

## Live state at initiation

Pilot `fxcwkweaxjtknorudmwp`:

- `vector` extension: installed 0.8.2;
- `search.course_documents`: 33,105 rows;
- `search.course_embeddings`: 0 rows;
- `search.embedding_jobs`: 0 rows;
- `search.query_embedding_cache`: 0 rows;
- `search.profiles`: `website-default` and `zoho-default`, both version 1;
- website profile config presently includes `fts_weight=1`, `vector_weight=0.55`, `rrf_k=60`, but there is no embedding corpus, so this configuration is not evidence of accepted hybrid Search;
- `search.course_documents` already carries `semantic_content_hash`, `enrichment_semantic_text`, `enrichment_content_hash` and projection metadata;
- publication remains zero.

## After / acceptance candidate

A bounded accepted implementation, if benchmark evidence supports it, should provide:

1. exact Course/public/regulatory code lookup;
2. exact Provider lookup;
3. conventional FTS;
4. structured deterministic filters;
5. optional vector semantic retrieval using an explicit embedding profile/model/dimension;
6. optional hybrid FTS+vector ranking;
7. deterministic hard filters and publication/visibility gating;
8. pagination and bounded result size;
9. explainable match metadata;
10. projection/profile/version/hash metadata;
11. consumer-safe DTO only;
12. no vector value exposed to normal clients.

If vector/hybrid does not materially improve the benchmark, FTS remains accepted and vector/hybrid returns to candidate/deferred state.

## Embedding profile requirements

Before producing an accepted corpus, record explicitly:

- embedding provider/model;
- dimensions;
- profile/version;
- exact semantic text/content contract;
- content/semantic hash relationship;
- regeneration/invalidation rules;
- query embedding cache rules;
- cost and measured latency;
- privacy exclusion list;
- index decision based on actual workload/query plans rather than availability alone.

No embedding model has been selected or authorised by this record at initiation.

## Search relevance benchmark

Required benchmark set includes at minimum:

- exact CRICOS/NZQA/public Course code;
- exact Course title;
- partial/fuzzy Course name;
- discipline intent;
- Course + city/state;
- Course + tuition intent;
- Course + Intake intent;
- Course + Provider;
- semantic student-style query;
- ambiguous query;
- no-result query.

Compare FTS, vector and hybrid where actually implemented. Record expected top results, false positives, hard-filter correctness, latency, repeatability, explainability and query/index cost.

## Website developer read contract

The bounded discussion contract may expose approved fields such as stable public Course ID, Provider, title, public/regulatory code, study level, Campus/location, official URL, accepted tuition semantics, Intake summary, English summary, Scholarship context, match metadata and freshness/verification display fields.

It must not expose Evidence storage paths/IDs, review comments/IDs, source/provider credentials, Vault/service-role information, raw canonical CRUD or private Layer 2/3 operational metadata.

The contract must explicitly document browser-safe versus server-side boundaries and current publication limitations.

## Security constraints

- raw `search.*` tables are not the website contract;
- no broad raw-schema browser CRUD;
- no service-role secret in browser/client configuration;
- publication/visibility cannot be escalated by query parameters;
- malformed/unauthorised input must fail safely;
- any browser-executable RPC/API is separately inventoried in the M2.2 security gate;
- vector tables remain private derived infrastructure unless an explicit future contract says otherwise.

## Implementation references

- accepted Search baseline: `CF-CHG-20260823-023`;
- programme acceleration: `CF-CHG-20260825-032`;
- Pilot project: `fxcwkweaxjtknorudmwp`;
- source/migrations/functions: to be recorded as applied;
- UI version: N/A at initiation.

## UAT

Required before PASS:

- FTS baseline and deterministic exact-match tests;
- filter correctness;
- vector/hybrid tests only if embeddings are implemented;
- unpublished/blocked visibility tests;
- malformed and unauthorised input;
- pagination and limits;
- deterministic replay/idempotency;
- query plan/index inspection;
- latency benchmark at representative AU+NZ scale;
- consumer DTO field allowlist/security tests;
- regression of M1 `course-v3` projection invariants.

## Rollback / reversion

Derived-only rollback:

- disable/remove candidate vector/hybrid Search function/profile;
- clear candidate embeddings/cache/jobs if necessary;
- retain accepted `course-v3` FTS Search projection and canonical data unchanged;
- retain publication state unchanged;
- preserve benchmark evidence and record the rejection/defer decision.

## Documentation impact

- new website-developer bounded Search/read contract;
- new Search benchmark/UAT evidence;
- Running Build updated only after accepted runtime changes;
- database architecture receives a new version only if durable Search schema/semantics materially change;
- Master Plan/TSOW governed by `CF-CHG-20260825-032`.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 25 Aug 2026 20:08 AEST | APPROVED / IN PROGRESS | Reopen pgvector only as bounded candidate; deterministic contract remains valid regardless of vector outcome. | M2.2 — SECURITY-PRODUCTION-SEARCH-SHOWCASE |

## Closure

**Final status:** IN PROGRESS  
**Closed at:** N/A  
**Outcome:** Benchmark and implementation decision pending; no vector/publication acceptance is implied.