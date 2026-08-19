# CourseFinder Master Project Plan v1.34

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.33.md`  
**Last consolidated:** 19 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.34.md`  
**Running build:** `docs/coursefinder-running-build-v2.38.md`  
**Completeness design:** `docs/coursefinder-au-layer1-regulatory-completeness-design-v1.0.md`

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS identity/geography/field | PASS / ACCEPTED | Preserve 1,546 Provider / 26,648 Course substrate |
| AU CRICOS regulatory Course facts | PASS / ACCEPTED | Preserve accepted fact/fee model |
| AU Layer 1 primary adapter consolidation | PASS / ACCEPTED | Primary adapter owns complete CRICOS refresh path |
| **AU Layer 1 residual completeness remediation** | **IMMEDIATE PRIMARY** | Resolve/classify 2,281 study-level gaps and 34 campus gaps before L2 |
| AU first-party Course facts | PRE-STAGED / BLOCKED | RMIT contract proven but APPLY remains deferred until L1 completeness passes |
| NZ Layer 1 NZQA | PASS / ACCEPTED | Preserve accepted substrate |
| AU QILT Layer 2A | PASS / ACCEPTED | Maintain governed outcomes |
| AU PRISMS Layer 2A | PASS / ACCEPTED | Maintain time-scoped observations |
| AU Scholarships | PASS / FIRST-SOURCE ACCEPTED | Controlled expansion only |
| Publication/Search completeness | NOT YET FORMALISED FOR AU | Do not manufacture score from regulatory coverage |
| Search governed projection + FTS | PASS / ACCEPTED | 33,105 documents; consumer contracts remain FTS |
| **Vector/semantic Search** | **REJECTED / NOT ADMITTED** | `gte-small` Edge generation candidate failed production throughput/resource prerequisite |
| Search enrichment readiness | BLOCKED | Fee/link/intake/English require separate admission UAT |
| **Admin/PIM hardening** | **PASS / COMPLETE** | Role-aware reads, provenance, fee semantics and browser security gate accepted |

## M1-SEARCH-VECTOR decision

The first semantic Search production candidate gate is complete and rejected.

Candidate evaluated:
- `Supabase/gte-small`;
- model contract `edge-runtime-gte-small-v1`;
- 384 dimensions;
- cosine distance;
- mean pooling and normalisation;
- semantic input `search_text-v1`;
- freshness keyed to `semantic_content_hash`;
- query cache profile `course-semantic-v1`.

Measured generation results:
- 500 records / concurrency 12: FAIL — Edge `WORKER_RESOURCE_LIMIT`;
- 50 records / concurrency 4: FAIL — Edge `WORKER_RESOURCE_LIMIT`;
- serial 5 records: PASS — 1,410.16 ms / 3.55 documents per second;
- projected 33,105-document single-profile generation at measured rate: ~2.59 hours.

Freshness/replay/invalidation and cache correctness passed, but complete-corpus vector generation did not. Consequently production vector latency, filtered latency and FTS-vs-vector-vs-hybrid relevance could not be truthfully certified.

All diagnostic embeddings/cache rows were removed after UAT. Accepted embeddings remain 0. Website/Zoho contracts and publication scope remain unchanged.

Detailed evidence: `docs/coursefinder-m1-search-vector-uat-v1.0.md`.

A future semantic gate must use a **newly qualified generation architecture/profile**. Do not retry the same Edge generation shape unchanged. Required evidence remains:
- bounded complete-corpus generation within an acceptable resource/wall-clock envelope;
- model/version reproducibility and drift detection;
- exact semantic-hash invalidation/replay;
- complete-corpus vector-only and filtered retrieval latency;
- curated FTS vs vector vs hybrid relevance;
- explicit operational cost, rate-limit and privacy controls.

## M1-PIM-HARDENING decision

The parallel Admin/PIM operational/security gate is **PASS / complete** as recorded in running build v2.37 and `docs/uat/m1-pim-hardening-gate-2026-08-19.md`.

Accepted posture includes:
- browser reads through `public.admin_read(text,jsonb)` with private role enforcement;
- legacy browser-executable SECURITY DEFINER bridges retired;
- source/evidence/history and completeness/readiness governance visible in Admin;
- Scholarship relational detail preserved;
- CRICOS registered-total-course fees separated from Provider-current fees;
- private evidence Storage retained.

The remaining leaked-password-protection advisor item is classified as unsupported on the current Supabase Free plan, not silently waived.

## Immediate serial gate — M1-L1-AU-CRICOS-COMPLETENESS

The serial data lane remains unchanged by the vector/PIM decisions.

Required outcome:
- resolve/classify all 2,281 study-level gaps;
- resolve/classify all 34 campus gaps;
- preserve exact AU Provider/Course identity;
- repeat full dry-run/APPLY/replay/idempotency UAT;
- recalculate regulatory completeness with source-gap versus adapter-defect attribution;
- keep Search isolated.

The target is zero unexplained Layer 1 mapping defects, not fabricated 100% coverage.

## Next serial gate — M1-L2-AU-COURSE-FACTS

The RMIT first-party contract has been pre-staged only. It remains deferred until `M1-L1-AU-CRICOS-COMPLETENESS` passes.

Layer 2 scope remains Provider-owned facts CRICOS does not supply at the required grain/freshness:
- official Course URL;
- current/year-specific international fees, separate from CRICOS registered-total-course fees;
- intakes/application timing;
- English entry requirements;
- exact CRICOS Provider+Course identity resolution;
- source/evidence/versioning;
- bounded dry-run/APPLY/replay/idempotency/ambiguity UAT.

## Search posture

Current state:
- Search Documents: 33,105;
- accepted embeddings: 0;
- Search `has_fee=true`: 0;
- governed FTS: accepted;
- semantic/hybrid Search: not admitted;
- `courses/course_fee`: BLOCKED.

No publication or consumer visibility was broadened by `M1-SEARCH-VECTOR`.

## Programme sequence

Primary serial lane:

`M1-L1-AU-CRICOS-COMPLETENESS -> M1-L2-AU-COURSE-FACTS -> SEARCH-ENRICHMENT-READINESS -> PUBLICATION-UAT`

Completed parallel gates:

`M1-PIM-HARDENING` — PASS.

`M1-SEARCH-VECTOR` candidate 1 — REJECTED; no semantic admission.

Close-out:

`M1-PRODUCTION-HARDENING -> M1-ACCEPTANCE`
