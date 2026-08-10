# Coursefinder Pilot Validation — Scenario 9 Recommendation Simulation v2.9

**Status:** Completed pilot simulation.

**Purpose:** Validate Website and Zoho recommendation/search behaviour across synthetic student intents using the existing demo catalogue, Search Projection, FTS, pgvector pilot and scholarship matcher.

---

## 1. Simulation scope

The simulation used 30 synthetic course-discovery profiles:

- 15 Website-style profiles — short direct discovery queries such as Data Science, AI, Cybersecurity, Information Technology, Health Data Science and postgraduate/doctoral variants.
- 15 Zoho-style profiles — richer counsellor/recommendation intents containing modifiers such as industry, professional, short postgraduate, undergraduate, conversion and research.

The test measured:

- availability of an embedded semantic seed in the current pilot embedding coverage;
- top-result topical relevance;
- top-5 topical relevance;
- response execution across the hybrid FTS + vector retrieval function;
- scholarship eligibility behaviour against 10 synthetic student profiles.

This remains a pilot quality test. Current embeddings cover only a subset of the catalogue, so it is not a final relevance benchmark.

---

## 2. Current embedding limitation

The current demo contains 13,698 courses but only 2,450 course embeddings, all at 1,536 dimensions. Coverage is concentrated in a small number of providers.

This materially affects semantic testing because a realistic natural-language query cannot always find an equivalent embedded course to use as a stand-in query vector.

Production must therefore use a true query-embedding step rather than derive user query semantics from an existing course embedding.

---

## 3. Raw-query simulation

### Website

15 Website profiles were tested directly.

Results:

- profiles with available semantic seed: 10 / 15;
- top-1 topical relevance: 66.7%;
- average top-5 topical relevance: 58.7%;
- average top-10 topical relevance: 54.0%.

This is reasonable for the partially embedded pilot because short Website queries often closely match catalogue titles and fields.

### Zoho

15 richer Zoho-style profile queries were tested directly.

Results:

- profiles with available semantic seed: 4 / 15;
- top-1 topical relevance: 20.0%;
- average top-5 topical relevance: 20.0%;
- average top-10 topical relevance: 20.0%.

This failure was caused primarily by the pilot query-vector workaround. Phrases such as `data science industry analytics`, `cybersecurity professional`, and `information technology conversion` rarely match an already embedded course closely enough to provide the vector seed.

Classification: `IMPLEMENTATION_GAP`, not DB design failure.

---

## 4. Intent-normalised simulation

A simple intent normalisation step was then applied before hybrid retrieval. Examples:

- `data science industry analytics` → `data science analytics`
- `AI machine learning industry` → `artificial intelligence machine learning`
- `cybersecurity professional` → `cybersecurity`
- `IT undergraduate` → `information technology`
- `data science doctoral research` → `data science`

The structured study-level filter remained separate.

### Revised results

Website:

- semantic seed available: 10 / 15;
- top-1 topical relevance: 66.7%;
- average top-5 topical relevance: 58.7%.

Zoho:

- semantic seed available: 11 / 15;
- top-1 topical relevance: 73.3%;
- average top-5 topical relevance: 64.0%.

This demonstrates the intended production pattern:

```text
Raw user/counsellor intent
  -> intent normalisation / structured extraction
  -> hard filters
  -> query embedding
  -> FTS candidates + vector candidates
  -> rank fusion
  -> scholarship/recommendation signals
```

The production implementation should use an actual query embedding rather than the pilot's course-vector stand-in.

---

## 5. Performance across 30 profiles

The normalised 30-profile hybrid simulation executed in approximately 195 ms total at the database level in the warm-cache pilot run.

This is not the same as 30 independent internet API calls because it was executed as one SQL benchmark, but it indicates that the projected/indexed database path itself is not the likely bottleneck.

The likely production latency contributors will instead be:

- external query-embedding generation;
- Edge/API network overhead;
- cache hit/miss state;
- pgvector candidate count and HNSW tuning;
- downstream Zoho commercial re-ranking where applicable.

---

## 6. Scholarship recommendation simulation

Ten synthetic student profiles were evaluated against the two currently linked Adelaide courses and five demo scholarships, producing 50 scholarship evaluations.

Result:

- `possible`: 50 / 50;
- average unresolved criterion ratio: 100%.

This is correct conservative matcher behaviour.

The issue is source normalisation: current demo scholarship criteria are mostly stored as human-readable text such as:

- `High distinction average (or equivalent)`;
- `Distinction average (or equivalent)`;
- `Credit average (or equivalent)`;
- `ASEAN member country citizenship`;
- `Prior study at University of Adelaide / UniSA / UoA`.

Because these have not yet been normalised into machine-evaluable values, the matcher intentionally refuses to auto-pass them.

Classification: `IMPLEMENTATION_GAP` in Layer 2/4 enrichment.

Production scholarship extraction/review should produce coded criteria such as:

- metric = WAM, operator = GTE, value = 80;
- citizenship region = ASEAN with controlled country codes;
- alumni relationship = provider identifier set;
- study level = masters;
- specific course / Course Collection scope using stable IDs;
- international/domestic status as controlled code.

Human-readable source text must still be retained as evidence.

---

## 7. Recommended Website call scenarios

### Website discovery

`GET /search/courses?q=data+science&country=AU&level=masters`

Use structured filters + FTS first. Use pgvector only when semantic intent or low lexical recall justifies it.

### Natural-language Website search

`POST /search/semantic`

Example intent:

`I want a postgraduate AI course focused on healthcare data in Australia.`

Flow:

1. parse hard filters and intent;
2. normalise query text;
3. fetch or create cached query embedding;
4. FTS candidate retrieval;
5. vector candidate retrieval;
6. reciprocal/rank fusion;
7. return safe DTO.

### Related courses

`GET /courses/{id}/related`

This is a particularly efficient pgvector use case because the selected course already has a stored embedding and no external query-embedding generation is required.

---

## 8. Recommended Zoho call scenarios

### Counsellor recommendation

`POST /recommendations/courses`

Input should contain structured student constraints plus free-text intent, for example:

```json
{
  "country": "AU",
  "study_level": "masters",
  "field_preferences": ["data science", "artificial intelligence"],
  "max_annual_fee": 55000,
  "ielts_overall": 7.0,
  "intent": "AI and analytics with strong industry focus"
}
```

Coursefinder should return academically relevant candidates and reasons. Zoho then applies commercial preference separately.

### Batch course comparison

`POST /courses/compare`

Accept a list of stable Coursefinder course IDs and return one batched response instead of one network call per course.

### Scholarship matching

`POST /recommendations/scholarships`

Should operate only after scholarship criteria have been normalised and approved. Ambiguous criteria must remain `possible`, not automatically eligible.

---

## 9. Cache design confirmed by simulation

### Query embedding cache

Key:

`embedding_model + search_profile_version + normalised_query_hash`

Value:

- query vector;
- generated_at;
- model/version metadata.

A user changing budget, destination, intake or study level should not force the same semantic query to be embedded again.

### Search result cache

Key should include:

`channel + normalised_query + structured_filters + search_profile_version + catalogue_generation`

The `catalogue_generation` value increments when a published search projection materially changes. This avoids per-record cache invalidation complexity.

Recommended high-volume implementation: Edge-compatible Redis/cache service. Canonical PostgreSQL should not become the general ephemeral response cache.

### Stable entity/detail cache

Course/provider detail responses can use longer TTL and ETag/content hash because they change less frequently than search results.

---

## 10. DB/search design improvements to consolidate

The simulation confirms the v2.9 architecture but recommends the following production details:

1. `search.search_profiles` — versioned retrieval definition.
2. `search.search_documents` — structured/filter/search projection.
3. `search.search_embeddings` — entity/document embedding separated from canonical courses.
4. `search.search_embeddings` must record model, dimensions, content hash, profile version and status.
5. `search.query_embedding_cache` should be logical architecture only if Redis is unavailable; preferred implementation is external ephemeral cache rather than canonical DB storage.
6. Search API should distinguish `fast lexical/structured`, `semantic`, and `related` modes.
7. Query embedding must be an API/function input so HNSW can be used effectively.
8. Vector candidate count must be bounded before rank fusion.
9. Website autocomplete should never invoke pgvector.
10. Zoho recommendation requests should be batch-friendly and separate academic relevance from commercial re-ranking.
11. Scholarship criteria should be machine-normalised during Layer 2 and approved in Layer 4 before eligibility automation.

---

## 11. Production acceptance targets

Before launch, rerun this simulation against fully enriched production data with true query embeddings.

Suggested minimum acceptance targets:

- ≥ 95% of published searchable courses have current embeddings where their Search Profile requires vector participation;
- 100% of vector rows have model/profile/content-hash lineage;
- Website top-5 topical relevance ≥ 80% on curated benchmark queries;
- Zoho recommendation top-5 topical relevance ≥ 80% before commercial reranking;
- hard-filter violation rate = 0%;
- scholarship `eligible` must never be produced from unresolved mandatory criteria;
- warm DB retrieval p95 target < 50 ms for semantic/hybrid query excluding external embedding API latency;
- structured/FTS-only queries should remain materially faster than semantic search;
- repeat semantic query should use embedding cache;
- repeated result set should use result cache while catalogue generation is unchanged.

---

## 12. Conclusion

The recommendation simulation validates the overall production search architecture.

No new canonical database redesign is required.

The main production-quality work is now implementation and enrichment:

- complete embedding coverage;
- use true query embeddings;
- add intent normalisation/structured extraction;
- implement cache/version keys;
- machine-normalise scholarship criteria;
- keep commercial preference outside Coursefinder relevance.

These findings should be consolidated into the final v2.9 production schema and API/search implementation plan before `Coursefinder_Prod` build begins.
