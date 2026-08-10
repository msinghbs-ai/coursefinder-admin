# Coursefinder — Improvements & Performance Roadmap v1.0

**Status:** Living roadmap  
**Purpose:** Capture non-blocking design improvements, performance opportunities, quality enhancements and scaling ideas discovered during Pilot/UAT.  
**Rule:** Add an item when evidence appears; promote it only when measurement or UAT justifies the change.

---

## 1. Roadmap Principles

- Measure before optimising.
- Keep canonical data normalised; optimise read paths with derived projections.
- Prefer configuration-as-data over hard-coded rules.
- Do not use pgvector for every request; use it where semantic intent adds value.
- Keep search/embeddings/cache rebuildable.
- Keep academic truth separate from commercial preference.
- Avoid premature index deletion based on unused-index notices during low-traffic Pilot.
- Record expected benefit and measurement criteria before implementing an optimisation.

---

## 2. Search & pgvector Improvements

| Improvement | Current state | Trigger | Expected benefit | Measurement |
|---|---|---|---|---|
| Full embedding coverage | Pilot catalogue only partially embedded historically | Wider Mumbai catalogue loaded | Better semantic recall | Embedding coverage %, top-5 relevance |
| Search Profile versioning | Designed/seeded | Multiple channels/locales active | Safer ranking changes | relevance by profile/version |
| Intent rules by channel/country | Base model exists | Zoho/Website vocabulary diverges | Higher recommendation precision | top-1/top-5 relevance |
| Dynamic FTS/vector weighting | Fixed pilot fusion | Search quality UAT identifies query classes | Better query-specific relevance | NDCG/MRR, click selection |
| Semantic routing | pgvector selective by design | Real traffic available | Lower cost/latency | % requests invoking vector path |
| Related-course vector API | Model supports stored course embeddings | Course detail UI live | Fast recommendation without query embedding | P95 related-course latency |
| HNSW parameter tuning | Baseline HNSW | Catalogue/embedding count materially increases | Lower latency or better recall | recall@k vs latency |
| Evaluate alternate vector dimensions/model | 1536-d current design | Model/provider/cost review | Lower storage/cost/latency | quality vs cost vs index size |

---

## 3. Cache Improvements

| Improvement | Current state | Trigger | Expected benefit | Measurement |
|---|---|---|---|---|
| Query embedding cache | Implemented pattern | Semantic API production use | Avoid repeated model calls | hit rate, provider cost saved |
| Search result cache | Planned | Website traffic repeats common queries | Lower DB/API load | hit rate, P95 latency |
| Provider/course detail cache | Planned | Public website active | Fast hot-page retrieval | cache hit %, origin requests |
| Catalogue-generation cache key | Designed principle | Result cache enabled | Safe invalidation | stale-result incidents = 0 |
| Edge cache / Cloudflare cache | Not yet implemented | Public API route stable | Reduce Supabase origin traffic | edge hit ratio |
| Zoho recommendation cache | Candidate | Repeated identical profile queries observed | Lower embedding/search load | repeated-profile rate |

### Cache rule

Cache keys should include enough version information to prevent semantic/configuration drift, including where relevant:

- normalised query hash;
- Search Profile version;
- embedding model/version;
- structured filters;
- channel;
- catalogue/search generation.

Raw sensitive student/profile text should not be persisted in the embedding cache unless explicitly required and governed.

---

## 4. Database / Projection Improvements

| Improvement | Current state | Trigger | Expected benefit | Measurement |
|---|---|---|---|---|
| Incremental Search Projection rebuild | Current rebuild model supports generation tracking | Full catalogue/rebuild becomes expensive | Faster freshness | rebuild duration, changed rows |
| Event-driven projection refresh | Candidate | High-frequency catalogue edits | Faster publish-to-search propagation | freshness lag |
| Precomputed filter facets | Candidate | Website filter traffic grows | Faster facet counts | facet query P95 |
| Partition large audit/evidence tables | Not needed at Pilot scale | Millions of rows / retention growth | Smaller indexes/maintenance | table/index growth |
| Archive old query cache rows | TTL model exists | Cache volume rises | Control DB size | cache rows/storage |
| Materialised aggregate dashboards | Current UI can compute via RPC | Dashboard becomes expensive | Lower admin load | dashboard P95 |
| Database connection pooling review | Supabase-managed baseline | Worker/API concurrency rises | Reduce connection pressure | active connections/timeouts |

---

## 5. API Improvements

| Improvement | Priority | Description |
|---|---:|---|
| Versioned API contracts | High | Introduce `/v1` contracts before external Website/Zoho dependency grows. |
| Batch APIs | High | Prefer `/courses/compare` and recommendation batches over N per-course calls. |
| Cursor pagination | High | Use stable pagination for larger catalogue responses. |
| Idempotency keys | High | Required for write/import/review requests and retry-safe integrations. |
| ETag / generation headers | Medium | Allow consumers to avoid unnecessary refreshes. |
| API response field profiles | Medium | Website vs Zoho can request appropriately bounded fields. |
| Rate limiting | High before public release | Protect semantic/model-heavy routes separately from cheap FTS/detail routes. |
| Request correlation IDs | High | Trace Worker → Supabase → pipeline/job/evidence. |
| API telemetry | High | Measure endpoint P50/P95/P99, errors, cache hits and vector invocation. |

---

## 6. Zoho Improvements

- Keep Zoho as consumer/workflow/commercial preference layer.
- Use stable Coursefinder provider/course/scholarship IDs.
- Add batch recommendation/compare APIs.
- Return recommendation reasons and eligibility status rather than only scores.
- Distinguish `eligible`, `ineligible`, `possible/unknown` scholarship states.
- Cache catalogue reference lists where appropriate.
- Add explicit retry/backoff policy.
- Add API contract version and catalogue generation to integration logs.
- Never inject raw commission/agreement value into semantic search text or vectors.
- Measure how often Zoho commercial re-ranking changes Coursefinder academic top results.

---

## 7. Layer 2 / Layer 3 Quality Improvements

| Improvement | Rationale |
|---|---|
| Provider-specific acquisition profiles | Sites differ in structure and anti-bot behaviour. |
| Multi-scraper failover | Avoid one vendor becoming a pipeline dependency. |
| Content-hash skip | Avoid repeated extraction where evidence did not change. |
| Structured intake labels | Preserve `Autumn`, `Spring`, `Semester 1`, etc. alongside normalised dates. |
| Fee audience/year/basis | Prevent domestic/international and annual/total confusion. |
| English component scores | Preserve writing/reading/listening/speaking thresholds. |
| Academic Option extraction profile | Treat majors/minors/specialisations/streams as first-class course children. |
| Scholarship acquisition profile | Separate scholarship crawl/extraction from course crawl. |
| Model routing | Cheap deterministic/model path for simple fields; stronger model only for ambiguous extraction. |
| Confidence calibration | Validate confidence against Layer 4 outcomes rather than arbitrary fixed scores. |

---

## 8. Layer 4 / Governance Improvements

- Reviewer workload dashboard.
- Queue SLA / ageing.
- Priority based on publication impact and data authority.
- Bulk approval only for low-risk homogeneous changes.
- Reopen review automatically when evidence hash changes materially.
- Show side-by-side evidence snapshot differences.
- Measure reviewer acceptance/rejection by extraction profile/model.
- Feed Layer 4 outcomes back into extraction/routing improvements.
- Explicit authority matrix by field/source layer.
- Preserve immutable decision history.

---

## 9. Scholarship Matching Improvements

Current Pilot validation demonstrated that human-readable scholarship criteria alone lead to conservative `possible/unknown` outcomes.

Roadmap:

1. Normalise criteria into codes/operators/values.
2. Establish a controlled eligibility vocabulary.
3. Support study level/course/collection/provider/campus/country/field scope.
4. Add quantitative rules such as GPA/WAM/score thresholds.
5. Add citizenship/residency country sets.
6. Add exclusion rules.
7. Support auto-considered vs application-required.
8. Keep retention/renewal conditions separate from initial eligibility.
9. Return reason codes for eligibility decisions.
10. Benchmark matcher precision against manually reviewed cases.

---

## 10. Performance Baseline Register

Historical pilot measurements to retain for comparison:

| Test | Pilot result |
|---|---:|
| Canonical representative search | ~24 ms |
| Search Projection FTS | ~1.25 ms |
| Improvement for representative query | ~19× |
| 1,000 canonical searches | ~23.99 s |
| 1,000 projected searches | ~1.71 s |
| Serial throughput improvement | ~14× |
| HNSW vector top-20, warm | ~10.8 ms |
| Hybrid FTS + vector + fusion, warm | ~36.9 ms |

These measurements were from a small/partial Pilot catalogue and must not be treated as production SLAs.

### Production-oriented metrics to maintain

- API P50/P95/P99 latency by endpoint.
- DB execution P50/P95.
- FTS query latency.
- vector candidate latency.
- hybrid search latency.
- query embedding latency.
- embedding cache hit rate.
- final result cache hit rate.
- search relevance top-1/top-5/MRR/NDCG.
- Search Projection rebuild duration.
- evidence/pipeline throughput.
- queue depth / job age.
- Supabase CPU/IO/connections where available.
- Worker requests/errors/CPU time.

---

## 11. Scale Triggers

Review architecture when any of these occur:

- catalogue grows by an order of magnitude;
- embeddings exceed several hundred thousand/millions;
- Search Projection rebuild cannot meet freshness objective;
- P95 semantic API latency exceeds agreed target;
- query cache hit rate remains low despite repeated traffic;
- DB connections become constrained;
- Layer 2 jobs backlog exceeds UAT/operational SLA;
- evidence storage/retention materially affects cost;
- Website traffic justifies CDN/edge result caching;
- Zoho integration volume requires asynchronous recommendation jobs.

---

## 12. Roadmap Status Categories

Use these states going forward:

- **IDEA** — recorded but no evidence yet.
- **CANDIDATE** — likely useful; measurement needed.
- **VALIDATED** — Pilot/UAT shows benefit.
- **PLANNED** — scheduled implementation.
- **IMPLEMENTED** — deployed.
- **MEASURED** — post-deployment benefit confirmed.
- **REJECTED/DEFERRED** — measurement did not justify complexity yet.

---

## 13. Current Priority Roadmap

### High

- Clean Pilot repo/Worker.
- PIM UI against v2.9.1 contracts.
- Layer 2 production acquisition.
- Scholarship criteria normalisation.
- API v1 contracts for Website and Zoho.
- Full Mumbai embedding generation.
- representative search/recommendation UAT.
- API telemetry and rate limiting.

### Medium

- Result caching/Cloudflare edge caching.
- Incremental Search Projection refresh.
- reviewer metrics.
- dynamic semantic routing.
- batch export/import UX.

### Later / scale-triggered

- table partitioning.
- alternate vector model/dimension optimisation.
- advanced multi-model routing.
- high-scale asynchronous recommendation workloads.

---

## 14. Revision Log

### v1.0

- Created after Mumbai v2.9.1 DB/UI handoff.
- Captures validated performance findings and future optimisation candidates.
- Establishes measurement-first roadmap process for Pilot through Production.
