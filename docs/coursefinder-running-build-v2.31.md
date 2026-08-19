# CourseFinder Running Build v2.31

Status: **CURRENT RUNNING BUILD**
Date: 19 August 2026
Supersedes: `docs/coursefinder-running-build-v2.30.md`
Architecture: `docs/coursefinder-database-architecture-v2.10.29.md`

## Build delta

v2.31 accepts **M1-SEARCH — Search/API & Consumer Projection** over the existing AU+NZ canonical substrate. Canonical Provider/Course/Campus identity and all accepted Layer 1/Layer 2 facts remain unchanged.

## Accepted Search state

- Governed projection: `course-v2`
- Search Documents: **33,105**
- AU: **26,648**
- NZ: **6,457**
- Projection generation: **12**
- Projection hash: `e4d72aa009ec5ce6ac00ee61d7e2286514c1fe5251faab2292c24d54a26233f6`
- Replay: **0 changed / 33,105 unchanged**
- Field-populated: **26,648**
- State-populated: **26,613**
- Delivery-populated: **26,614**
- AU multi-State courses preserved: **4,388**

Search country membership is now explicit and currently admits AU + NZ only. CA and later countries cannot enter Search merely because ingestion/search feature flags are enabled.

## Search enrichment gates

Scholarship is structurally approved but current scholarship rows are unpublished, so `has_scholarship` remains 0.

Course Link, Fee, Intake and English readiness remain Search-blocked until the Course Facts UAT gate is accepted. Their Search counts remain 0.

This is intentional; the running build does not infer consumer readiness from an unapproved relational row.

## Search performance

Representative database timings:

| Path | Result |
|---|---:|
| Weighted FTS, `data science`, AU, top 20 warm | ~1.95 ms |
| Structured AU + field + VIC + delivery filter, top 20 | ~11.35 ms |
| Hybrid request with no accepted vectors | ~11.77 ms via `fts_fallback` |

The first generic hybrid fallback measured ~159 ms. That implementation was rejected and replaced before acceptance.

## Vector status

`search.course_embeddings` rows: **0**.

The existing HNSW cosine index is valid/ready, semantic-content hashing is implemented, and the hybrid function correctly falls back when no accepted matching vectors exist. This is **structural readiness only**.

No semantic quality/latency claim is accepted until an embedding model/profile and generated vector set pass a separate UAT gate.

## Consumer API boundary

Accepted database DTO contracts:

- Website: `api.website_course_search_v1` / `website-course-search-v1`
- Zoho: `api.zoho_course_candidates_v1` / `zoho-course-candidates-v1`

Website execution is service-gateway only and published-only. Zoho requires authenticated Counsellor-or-higher and returns published/internal rows only.

Current catalogue publication remains unchanged: all 33,105 Search Documents are unpublished. Both consumer contract UATs therefore return a valid envelope with `items: []`.

No internal Search/canonical/evidence schema has been opened to browser consumers.

## Migrations applied and committed

- `20260819045418_m1_search_governed_projection_v1`
- `20260819045543_m1_search_consumer_contracts_v1`
- `20260819045719_m1_search_hybrid_fallback_optimisation_v1`
- `20260819045818_m1_search_country_gate_fk_index_v1`

Pilot evidence: `msinghbs-ai/Coursefinder-Pilot/docs/m1-search-governed-projection-uat-2026-08-19.md`

## Security/performance review

M1-SEARCH introduced no anonymous function execution. The one newly reported performance item—an unindexed country-gate FK—was remediated before handover.

Existing Admin/PIM `SECURITY DEFINER` advisor warnings and Supabase Auth leaked-password-protection warning remain pre-existing work and are not masked by this gate.

## Deployment note

No static Pilot UI or Cloudflare Worker asset changed in M1-SEARCH, so there is no justified front-end Worker deployment for this gate. The Website HTTP gateway remains a later publication/integration step using the accepted DTO contract; direct exposure of database schemas is prohibited.

## Gate

**M1-SEARCH core projection + FTS + curated API contract: PASS.**

**Vector-content/semantic gate: PENDING.**
