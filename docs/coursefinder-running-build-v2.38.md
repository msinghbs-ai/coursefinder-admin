# CourseFinder Running Build v2.38

**Status:** CURRENT RUNNING BUILD  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.37.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.34.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.34.md`  
**Admin/PIM design:** `docs/coursefinder-admin-pim-design-decisions-v1.10.md`

## Build delta

The v2.37 `M1-PIM-HARDENING` PASS remains accepted unchanged.

In parallel, the first `M1-SEARCH-VECTOR` semantic/hybrid production candidate gate is now complete.

**Vector gate result: REJECTED / NOT ADMITTED.**

The tested `Supabase/gte-small` Edge generation architecture proved semantic-hash freshness, cache and invalidation/replay mechanics, but failed the full-corpus generation/worker-resource prerequisite. Search remains governed FTS only.

Detailed vector UAT: `docs/coursefinder-m1-search-vector-uat-v1.0.md`.

## Verified live Search state after vector rollback

- Search Documents: 33,105
- accepted embeddings: 0
- query embedding cache rows: 0
- active embedding jobs: 0
- Website Search: governed FTS / unchanged
- Zoho Search: governed FTS / unchanged
- Search publication visibility: unchanged
- original 1,536-dimensional structural vector placeholder restored

## Vector candidate profile

- model: `Supabase/gte-small`;
- model contract: `edge-runtime-gte-small-v1`;
- dimensions: 384;
- cosine distance;
- mean pooling + normalisation;
- semantic input: `search_text-v1`;
- freshness key: `semantic_content_hash`;
- cache profile: `course-semantic-v1`.

Three-sentinel fingerprint captured:

`c2bc0561992eebbf0eca1e63d16c4458299ac7783959e7dd5a52f64c67bd8b50`

The marker can detect later runtime/model drift, but the candidate was rejected before a repeatable complete-corpus build could establish production reproducibility.

## Vector generation UAT

- 500 records / concurrency 12: FAIL — Edge `WORKER_RESOURCE_LIMIT`;
- 50 records / concurrency 4: FAIL — Edge `WORKER_RESOURCE_LIMIT`;
- serial 5 records: PASS — 1,410.16 ms / **3.55 documents per second**;
- extrapolated 33,105-document single-profile generation at the measured rate: approximately **2.59 hours**;
- one-record invalidation replay: PASS — 773.11 ms.

The viable worker shape is bounded but operationally too slow for this production gate. Higher-throughput shapes exceed the current Edge compute envelope.

## Freshness/cache/replay UAT

Freshness/invalidation:
- five diagnostic vectors generated against exact semantic hashes: PASS;
- one derived hash deliberately invalidated: pending selector detected the stale row immediately — PASS;
- replay regenerated the vector and restored exact hash equality — PASS.

Query cache diagnostic (`nursing`, AU, limit 10):
- first call: cache MISS, total 1,019.62 ms;
- second identical call: cache HIT / hit count 1, total 660.28 ms;
- warm database legs: FTS 36.47 ms / sparse-vector 46.97 ms / hybrid 39.56 ms.

Cache correctness passes. The cache/Edge round trip remains material.

## Relevance and latency decision

FTS returned directly relevant Nursing results in the diagnostic query.

Vector-only and hybrid relevance were **not admitted as production evidence** because only five diagnostic embeddings existed. A complete vector corpus is required for a fair FTS-vs-vector-vs-hybrid benchmark.

The observed sparse-vector latency is likewise not accepted as production vector or filtered-vector latency.

The candidate therefore fails the prerequisite for relevance and latency admission. This is an operational-production rejection, not a claim that `gte-small` is semantically poor.

## Vector rollback/security validation

After rejection:
- diagnostic embeddings removed;
- diagnostic query-cache rows removed;
- candidate 384-dimensional contract removed;
- candidate-only service wrappers removed;
- prior search profile weights/config restored;
- `search-vector-gate` Edge endpoint JWT-protected and reduced to a rejected-gate response;
- accepted embeddings remain 0.

Post-rollback security advisor review found no new vector-specific warning. Existing RLS-no-policy informational findings remain intentional closed-schema posture. The leaked-password-protection item is already classified by v2.37 PIM hardening as unsupported on the current Supabase Free plan rather than waived.

## Retained v2.37 Admin/PIM decision

`M1-PIM-HARDENING` remains **PASS / complete**:
- one promoted browser read RPC `public.admin_read(text,jsonb)`;
- browser-executable legacy SECURITY DEFINER bridges retired;
- private Storage and role thresholds verified;
- CRICOS registered-total-course fee remains distinct from Provider-current fee;
- detailed UAT remains `docs/uat/m1-pim-hardening-gate-2026-08-19.md`.

## Current AU serial position

The serial data lane is unchanged:
- AU Providers: 1,546;
- active AU Courses: 26,648;
- unresolved Layer 1 Study Level gaps: 2,281;
- unresolved canonical campus gaps: 34;
- Search `has_fee=true`: 0.

**Immediate primary remains:** `M1-L1-AU-CRICOS-COMPLETENESS`.

The RMIT first-party Course Facts contract remains pre-staged/deferred and may not APPLY until the Layer 1 completeness gate passes.

## Semantic Search next condition

No semantic implementation is admitted after this rejection.

Reopen only with a newly qualified generation architecture/profile that proves:
- bounded full-corpus generation within an acceptable wall-clock/resource envelope;
- model/version reproducibility and drift detection;
- exact semantic-hash invalidation/replay;
- complete-corpus vector-only and filtered latency;
- curated FTS vs vector vs hybrid relevance;
- explicit operational cost, rate-limit and privacy controls.

Do not retry the same Edge generation shape unchanged.
