# CourseFinder M1-SEARCH-VECTOR UAT v1.0

**Status:** REJECTED / NOT ADMITTED  
**Date:** 19 August 2026  
**Scope:** Semantic/Hybrid Search Production Gate against accepted `course-v2` AU+NZ projection  
**Baseline:** 33,105 Search Documents; 0 accepted embeddings

## Decision

`M1-SEARCH-VECTOR` is **REJECTED for production admission in this candidate configuration**.

The tested candidate was technically functional but did not meet the production generation/operational gate. No semantic or hybrid behaviour has been admitted to Website or Zoho consumer contracts, no publication state was broadened, and all diagnostic embeddings/cache rows were removed after UAT.

Accepted Search remains governed FTS over `course-v2`.

## Candidate profile

| Dimension | Candidate |
|---|---|
| Model | `Supabase/gte-small` |
| Model contract | `edge-runtime-gte-small-v1` |
| Dimensions | 384 |
| Distance | cosine |
| Pooling | mean pool |
| Normalisation | enabled |
| Semantic input | `search_text-v1` |
| Freshness key | `search.course_documents.semantic_content_hash` |
| Query cache profile | `course-semantic-v1` |

A deterministic three-sentinel model fingerprint was captured during UAT:

`c2bc0561992eebbf0eca1e63d16c4458299ac7783959e7dd5a52f64c67bd8b50`

This fingerprint is suitable as a future drift detector, but the candidate was rejected before a repeatable full-corpus build could establish production reproducibility.

## Baseline integrity

Before testing:
- Search Documents: 33,105;
- documents with semantic hash: 33,105;
- distinct semantic hashes: 33,105;
- accepted embeddings: 0;
- query cache rows: 0;
- active embedding jobs: 0.

Semantic input is compact at the current projection grain:
- minimum length: 45 characters;
- median length: 110 characters;
- p95 length: 161 characters;
- maximum length: 380 characters.

## Generation UAT

### High-throughput attempts

The following Edge inference shapes failed with `WORKER_RESOURCE_LIMIT` before any embedding rows were persisted:

1. 500-record batch with concurrency 12 — FAIL;
2. 50-record batch with concurrency 4 — FAIL.

This demonstrates that bulk in-function generation is not viable in the current project compute envelope.

### Minimum viable generation

Serial generation with a five-record batch succeeded:
- selected: 5;
- upserted: 5;
- elapsed: 1,410.16 ms;
- measured throughput: **3.55 documents/second**.

At that measured rate, one 33,105-document profile requires approximately **2.59 hours** of continuous inference, before a second profile, rebuild, retry overhead or changed-content invalidation workload.

A one-record regeneration took 773.11 ms / 1.29 documents per second.

**Generation gate: FAIL.** The successful shape is bounded but operationally too slow, while higher-throughput shapes exceed the Edge worker resource envelope.

## Freshness, replay and invalidation UAT

The candidate implementation keyed stored embeddings to the exact `semantic_content_hash` and model/profile version.

Test sequence:
1. generate five fresh diagnostic embeddings — PASS;
2. confirm 5 fresh / 0 stale / 33,100 missing — PASS;
3. deliberately replace one derived embedding content hash with a UAT-invalid value — PASS;
4. pending selector immediately chose the stale Course — PASS;
5. one-record replay regenerated the vector and restored exact hash equality — PASS.

**Freshness/replay/invalidation mechanics: PASS.**

## Query-cache UAT

Curated diagnostic query: `nursing`, country filter `AU`, limit 10.

First request:
- cache: miss;
- query-embedding/cache stage: 695.98 ms;
- FTS DB leg: 118.12 ms;
- vector DB leg: 52.39 ms;
- hybrid DB leg: 153.07 ms;
- total: 1,019.62 ms.

Second identical request:
- cache: hit;
- hit count: 1;
- query-cache stage: 537.21 ms;
- FTS DB leg: 36.47 ms;
- vector DB leg: 46.97 ms;
- hybrid DB leg: 39.56 ms;
- total: 660.28 ms.

**Cache correctness: PASS.** The warm cache avoided model inference, but the Edge/Data API vector serialisation round-trip remained material.

## Retrieval and relevance UAT

FTS returned directly relevant nursing results at the top of the diagnostic query, including Nursing and Midwifery/Nursing qualifications.

Vector-only retrieval was intentionally **not scored as production relevance** because only 5 of 33,105 documents had diagnostic embeddings. Its returned set therefore represented only that five-document subset and cannot be compared fairly to FTS. Hybrid ranking effectively preserved the FTS ranking because the diagnostic vector corpus did not contain relevant nursing candidates.

This is a gate failure, not a claim that the model has poor semantic quality. A valid FTS-vs-vector-vs-hybrid relevance benchmark requires a complete, reproducibly generated vector corpus. The candidate could not reach that prerequisite within the accepted operational envelope.

**Production relevance comparison: NOT ADMISSIBLE / FAILS PREREQUISITE.**

## Latency interpretation

The observed sparse-corpus vector timings (approximately 47–52 ms in the two diagnostic calls) are not accepted as production vector latency because the HNSW index contained only five vectors. Filtered production latency likewise cannot be truthfully certified without the full 33,105-vector corpus.

FTS remains the only fully populated and measured retrieval path in this gate.

## Cost and operational assessment

The built-in candidate avoided an external embedding API dependency, but the relevant production cost is not only token/API price. The measured worker-resource failures and ~3.55 documents/second viable throughput create unacceptable rebuild duration and operational fragility for the current gate.

A future semantic candidate must prove one of the following before reopening admission:
- materially faster bounded bulk generation within the existing compute envelope;
- a durable queue/batch architecture whose full-corpus wall-clock time and retry behaviour are acceptable;
- or a separately qualified embedding provider/profile with explicit cost, rate-limit, privacy and reproducibility controls.

## Rollback and boundary validation

After rejection:
- all five diagnostic course embeddings deleted;
- all diagnostic query-cache rows deleted;
- candidate-specific 384-dimensional runtime contract removed;
- original 1,536-dimensional structural placeholder restored;
- candidate service wrappers removed;
- search profiles restored to their prior weights/configuration;
- `search-vector-gate` Edge endpoint locked behind JWT and returns a rejected-gate response;
- accepted embeddings: **0**;
- active embedding jobs: **0**;
- Website/Zoho consumer search contracts unchanged;
- publication/search visibility unchanged.

Supabase security advisors showed no new vector-specific security warning after rollback. Existing programme-wide informational RLS-no-policy findings and the leaked-password-protection warning remain outside this lane and are tracked by `M1-PIM-HARDENING`.

## Gate result

| Criterion | Result |
|---|---|
| Model/profile/version selected | PASS for candidate evaluation |
| Semantic hash freshness | PASS |
| Cache | PASS |
| Replay/invalidation | PASS |
| Full 33,105 generation | **FAIL** |
| Worker resource envelope | **FAIL** |
| Production vector latency | NOT PROVABLE |
| Filtered production latency | NOT PROVABLE |
| FTS/vector/hybrid relevance benchmark | NOT ADMISSIBLE without full corpus |
| Publication isolation | PASS |
| Rollback to 0 accepted embeddings | PASS |

**Final decision: REJECT semantic/hybrid Search admission for `Supabase/gte-small / edge-runtime-gte-small-v1` in the current Edge generation architecture. Keep FTS as the accepted production Search mode and reopen semantic Search only with a newly qualified generation architecture/profile.**
