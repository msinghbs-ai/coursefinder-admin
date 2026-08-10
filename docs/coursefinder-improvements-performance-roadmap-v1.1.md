# Coursefinder — Improvements & Performance Roadmap v1.1

**Status:** Living roadmap  
**Purpose:** Capture non-blocking improvements, performance opportunities, security hardening, operational observability and quality enhancements discovered during Pilot/UAT.  
**Supersedes:** `coursefinder-improvements-performance-roadmap-v1.0.md`

> Add an item when evidence appears. Promote it only when measurement, security review or UAT justifies the change.

---

## 1. Roadmap Principles

- Measure before optimising.
- Security hardening is not optional optimisation; Critical/Error findings become delivery gates.
- Keep canonical data normalised and optimise reads with derived projections.
- Prefer configuration-as-data over hard-coded rules.
- Do not use pgvector for every request; use it where semantic intent adds value.
- Keep search/embeddings/cache rebuildable.
- Keep academic truth separate from commercial preference.
- Avoid premature index deletion based on unused-index notices during low-traffic Pilot.
- Record expected benefit and measurement criteria before implementing an optimisation.
- Maintain a running-build document so operational state is never inferred from Studio UI alone.

---

## 2. Security / Access Hardening Roadmap

| Improvement | Status | Trigger / Evidence | Expected benefit | Validation |
|---|---|---|---|---|
| Enable RLS across internal tables | **PLANNED / BLOCKING** | Supabase flagged 61 internal tables with RLS disabled | Prevent unintended client-role access | Security Advisor; anon/auth tests |
| Review direct grants to `anon` / `authenticated` | **PLANNED** | RLS hardening pass | Least privilege | privilege inventory + access tests |
| Keep canonical schemas server-only | **VALIDATED design** | Multi-schema architecture | Smaller browser attack surface | browser cannot query canonical base tables directly |
| Curated UI/API RPC contracts | **IMPLEMENTED** | UI integration | Controlled read boundary | authenticated RPC tests |
| Replace transitional compatibility layer | **CANDIDATE** | New clean UI available | Reduce legacy surface | compatibility views retired |
| Role-checked write RPC/Edge contracts | **PLANNED** | UI editing begins | Controlled writes/audit | role matrix UAT |
| Rate limiting / abuse controls | **PLANNED** | Public API exposure | Protect expensive routes | endpoint load/abuse tests |
| Evidence Storage signed access | **PLANNED** | Evidence UI | Prevent direct bucket exposure | signed URL / policy tests |
| Security Advisor gate in release process | **PLANNED** | Pilot → production | Prevent regression | no Critical/Error findings at release |

### Immediate security gate

Before formal UI/UAT sign-off:

1. Enable RLS via Git-tracked migration.
2. Remove unnecessary direct grants.
3. Re-test UI/API paths.
4. Run Security Advisor.
5. Record accepted INFO/WARN notices in the running-build document.
6. Resolve all Critical/Error findings.

---

## 3. Search & pgvector Improvements

| Improvement | Current state | Trigger | Expected benefit | Measurement |
|---|---|---|---|---|
| Full embedding coverage | Mumbai embeddings intentionally not copied from demo | Wider canonical catalogue loaded | Better semantic recall | embedding coverage %, top-5 relevance |
| Search Profile versioning | Designed/seeded | Multiple channels/locales active | Safer ranking changes | relevance by profile/version |
| Intent rules by channel/country | Base model exists | Zoho/Website vocabulary diverges | Higher recommendation precision | top-1/top-5 relevance |
| Dynamic FTS/vector weighting | Fixed pilot fusion | Search quality UAT identifies query classes | Better relevance | NDCG/MRR |
| Semantic routing | pgvector selective by design | Real traffic available | Lower cost/latency | % vector-route requests |
| Related-course vector API | Model supports stored course embeddings | Course detail UI live | Avoid query embedding call | P95 related-course latency |
| HNSW parameter tuning | Baseline HNSW | Catalogue grows materially | Recall/latency balance | recall@k vs P95 |
| Alternate vector dimensions/model | 1536-d baseline | Cost/model review | Lower storage/cost/latency | quality vs cost/index size |

---

## 4. Cache Improvements

| Improvement | Current state | Trigger | Expected benefit | Measurement |
|---|---|---|---|---|
| Query embedding cache | Implemented pattern | Semantic API production use | Avoid repeated model calls | hit rate / provider cost saved |
| Search result cache | Planned | Repeated Website queries | Lower DB/API load | cache hit %, P95 |
| Provider/course detail cache | Planned | Public website active | Faster hot pages | edge/origin hit ratio |
| Catalogue-generation cache key | Designed | Result cache enabled | Safe invalidation | stale incidents = 0 |
| Cloudflare edge cache | Not implemented | Stable public API | Reduce Supabase origin load | edge hit ratio |
| Zoho recommendation cache | Candidate | Repeated profile queries | Reduce embedding/search load | repeated-profile hit rate |

Cache keys should include query hash, Search Profile version, embedding model, structured filters, channel and catalogue/search generation where relevant. Do not persist raw sensitive profile text unless explicitly governed.

---

## 5. Database / Projection Improvements

| Improvement | Current state | Trigger | Expected benefit | Measurement |
|---|---|---|---|---|
| Incremental Search Projection rebuild | Full rebuild + generation tracking | Full catalogue makes rebuild expensive | Faster freshness | rebuild duration / changed rows |
| Event-driven projection refresh | Candidate | Frequent edits | Lower publish-to-search lag | freshness lag |
| Precomputed filter facets | Candidate | Website filter traffic grows | Faster facet counts | facet P95 |
| Materialised dashboard aggregates | Candidate | Admin dashboard becomes expensive | Lower admin query load | dashboard P95 |
| Partition audit/evidence tables | Deferred | Millions of retained rows | Smaller indexes/maintenance | table/index growth |
| Query-cache cleanup scheduling | TTL structure exists | Cache volume rises | Controlled DB size | cache rows/storage |
| Connection pooling review | Supabase baseline | Worker concurrency rises | Avoid connection pressure | connections/timeouts |

### Studio / schema visualisation improvement

**CANDIDATE:** provide a generated architecture/schema diagram in the clean Pilot repo because Supabase Studio visualisation is schema-scoped and the default `public` view can look empty.

Expected benefit:
- faster onboarding;
- fewer false data-loss diagnoses;
- visible cross-schema domain boundaries.

Measure by onboarding/UAT usability rather than runtime performance.

---

## 6. API Improvements

| Improvement | Priority | Description |
|---|---:|---|
| Versioned `/v1` contracts | High | Stabilise external Website/Zoho dependencies. |
| Batch APIs | High | Prefer compare/recommendation batches over N calls. |
| Cursor pagination | High | Stable large-catalogue pagination. |
| Idempotency keys | High | Retry-safe writes/import/review flows. |
| ETag / generation headers | Medium | Consumer cache validation. |
| Field profiles | Medium | Bound Website vs Zoho payloads. |
| Rate limiting | High | Separate limits for cheap FTS/detail vs semantic/model-heavy routes. |
| Correlation IDs | High | Trace Worker → API → DB → pipeline/evidence. |
| API telemetry | High | P50/P95/P99, errors, cache hits, vector invocation. |

---

## 7. Zoho Improvements

- Stable Coursefinder provider/course/scholarship IDs.
- Batch recommendation/compare APIs.
- Return recommendation reasons and eligibility state.
- Distinguish `eligible`, `ineligible`, `possible/unknown`.
- Catalogue-reference caching.
- Explicit retry/backoff/idempotency behaviour.
- Log API contract version and catalogue generation.
- Keep commission/agreement values out of semantic search/vectors.
- Measure how often Zoho commercial reranking changes the academic top results.

---

## 8. Layer 2 / Layer 3 Quality Improvements

| Improvement | Rationale |
|---|---|
| Provider-specific acquisition profiles | Provider websites differ materially. |
| Multi-scraper failover | Avoid one-vendor pipeline dependency. |
| Content-hash skip | Avoid repeated extraction when evidence is unchanged. |
| Structured intake labels | Preserve provider wording plus normalised dates. |
| Fee audience/year/basis | Avoid domestic/international and annual/total ambiguity. |
| English component scores | Preserve component thresholds. |
| Academic Option extraction | Majors/minors/specialisations/streams are first-class. |
| Scholarship acquisition profile | Separate scholarship acquisition from course acquisition. |
| Model routing | Use stronger models only for ambiguous extraction. |
| Confidence calibration | Learn from Layer 4 outcomes. |

---

## 9. Layer 4 / Governance Improvements

- Reviewer workload dashboard and queue ageing/SLA.
- Publication-impact priority.
- Safe bulk approvals only for homogeneous low-risk changes.
- Automatic reopen on material evidence change.
- Evidence diff view.
- Review outcome metrics by extraction profile/model.
- Authority matrix by field/source layer.
- Immutable decision history.

---

## 10. Scholarship Matching Improvements

1. Normalise criteria to codes/operators/values.
2. Controlled eligibility vocabulary.
3. Support study-level/course/collection/provider/campus/country/field scope.
4. Quantitative GPA/WAM/score rules.
5. Citizenship/residency country sets.
6. Exclusion rules.
7. Automatic consideration vs application-required.
8. Separate renewal conditions from initial eligibility.
9. Reason codes.
10. Benchmark precision against reviewed cases.

---

## 11. Performance Baseline Register

| Test | Pilot result |
|---|---:|
| Canonical representative search | ~24 ms |
| Search Projection FTS | ~1.25 ms |
| Representative improvement | ~19x |
| 1,000 canonical searches | ~23.99 s |
| 1,000 projected searches | ~1.71 s |
| Serial throughput improvement | ~14x |
| HNSW vector top-20 warm | ~10.8 ms |
| Hybrid FTS + vector + fusion warm | ~36.9 ms |

These are small/partial Pilot measurements, not production SLAs.

Maintain: API P50/P95/P99, DB execution, FTS/vector/hybrid latency, embedding latency, cache hit rates, relevance metrics, Search Projection rebuild duration, pipeline throughput/queue age, Supabase resource pressure and Worker errors/CPU.

---

## 12. Build / Observability Improvements

| Improvement | Status | Benefit |
|---|---|---|
| Running build document | **IMPLEMENTED** | One place for environment, migrations, security state and blockers. |
| Migration manifest/checksum | Candidate | Detect repo/DB drift. |
| Automated schema inventory | Candidate | Verify expected schemas/tables/counts during deployment. |
| Automated advisor snapshot | Candidate | Security/performance regression detection. |
| Generated ER/schema diagram | Candidate | Better multi-schema visual onboarding. |
| Environment health page | Later | UI/Worker/API/Search generation visibility. |
| Release readiness checklist | Planned | Repeatable Pilot/UAT/Production promotion. |

---

## 13. Scale Triggers

Re-review architecture when catalogue/embeddings grow by an order of magnitude, Search Projection freshness is missed, semantic P95 exceeds target, cache hit rate is poor, connections constrain, Layer 2 backlog exceeds SLA, evidence retention materially affects cost, Website traffic justifies edge caching, or Zoho volume requires asynchronous recommendation jobs.

---

## 14. Roadmap Status Categories

- **IDEA**
- **CANDIDATE**
- **VALIDATED**
- **PLANNED**
- **IMPLEMENTED**
- **MEASURED**
- **BLOCKING**
- **REJECTED/DEFERRED**

---

## 15. Current Priority Roadmap

### Blocking / Immediate

- RLS and privilege hardening across internal schemas.
- Re-run Security Advisor and browser-contract tests.
- Clean Pilot repo/Worker.

### High

- PIM UI against v2.9.1 contracts.
- Layer 2 production acquisition.
- Scholarship criteria normalisation.
- API v1 contracts for Website and Zoho.
- Full Mumbai embedding generation.
- representative recommendation/search UAT.
- API telemetry and rate limiting.

### Medium

- result/edge caching;
- incremental Search Projection;
- reviewer metrics;
- dynamic semantic routing;
- generated schema visualisation;
- migration/advisor automation.

### Later / scale-triggered

- partitioning;
- alternate vector model/dimensions;
- advanced model routing;
- asynchronous high-scale recommendation workloads.

---

## 16. Revision Log

### v1.1

- Added RLS/privilege hardening as a blocking roadmap item after live Supabase inspection identified 61 internal tables with RLS disabled.
- Added running-build and schema visualisation/observability roadmap.
- Recorded multi-schema Studio visualisation expectations as an onboarding improvement opportunity.
- Preserved existing performance baselines and optimisation backlog.

### v1.0

- Initial Mumbai v2.9.1 improvements/performance roadmap.
