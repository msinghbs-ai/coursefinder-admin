# CF-CHG-20260825-033 — M2.2 Bounded Search / pgvector Showcase

**Status:** **CLOSED / PASS — DETERMINISTIC SEARCH ACCEPTED; VECTOR/HYBRID DEFERRED**  
**Category:** 50-search-api-consumers  
**Initiated:** 25 August 2026 20:08 AEST (+10:00)  
**Closed:** 25 August 2026 21:15 AEST (+10:00)  
**Origin chat/workstream:** M2.2 — SECURITY-PRODUCTION-SEARCH-SHOWCASE  
**Owner:** CourseFinder Search/API consumer workstream

## Decision

The Friday acceleration is accepted as a bounded Search/read capability only. It does not grant broad Publication, Production website exposure, Zoho cutover or raw Search/Catalogue access.

Final accepted bounded path:

- exact Course/regulatory code lookup;
- exact stable Course identifier lookup;
- deterministic PostgreSQL FTS;
- structured hard filters;
- bounded pagination/sorting;
- consumer-safe DTO and projection metadata;
- service-side-only preview boundary;
- publication authority explicitly not granted.

## Final live state

- Search Projection: `course-v3`, generation 22;
- documents: 33,105 (AU 26,648 / NZ 6,457);
- pgvector: 0.8.2 installed;
- Course embeddings: 0;
- embedding jobs/cache: 0;
- governed `integration.model_profiles`: 0;
- published entities: 0.

## pgvector outcome

**DEFERRED / NOT ACCEPTED.** No governed reproducible embedding provider/model/profile exists. Availability of pgvector and vector-ready schema is not acceptance evidence. No synthetic/demo vectors were generated.

Vector/hybrid may be reconsidered only under a later Search gate after an explicit provider/model, dimensions, semantic-content contract, cost, regeneration rules and relevance benchmark exist.

## Implementation

Final Pilot source SHA: `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`.

Applied M2.2 Search/runtime hardening includes:

- service-side `api.website_course_lookup_preview_v1(text)`;
- service-side `api.website_course_search_preview_v1(...)`;
- exact Course-code/stable-ID indexes and separated exact branches;
- separated FTS and filter-only query branches so GIN-backed FTS is not defeated by a generic optional predicate;
- consumer DTO retains separate regulatory tuition and Provider-current tuition semantics.

Normal `anon` and `authenticated` roles have no EXECUTE on the bounded preview RPCs; `service_role` retains execution.

## Measured UAT

- website exact preview: reduced from ~8.78 s cold to ~17 ms after indexed branch separation;
- website `data science` + AU FTS preview: reduced from ~4.74 s to ~281 ms after plan hardening;
- exact code `102784C`: expected Course returned;
- exact stable ID lookup: expected stable identity returned;
- structured AU/QLD/masters/tuition/Intake/English filtering: PASS;
- no-result exact lookup: safe JSON null;
- projection version/generation metadata: PASS;
- publication non-escalation: PASS, published count remains zero.

Final deployed browser regression on SHA `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`: run `32840377935`, desktop and mobile PASS.

## Website developer contract

Current bounded contract: `docs/coursefinder-website-developer-search-read-contract-v1.0.md`.

It documents request/filter inputs, DTO, pagination, error/security semantics, server/browser boundary, current Publication limitation, and the explicit vector/hybrid defer decision.

## Rollback

The Search preview functions/indexes are derived/read-only infrastructure. Rollback may remove/disable the preview functions and candidate indexes while retaining accepted `course-v3`, canonical data and Publication state.

## Closure

**Final status: CLOSED / PASS.**

Deterministic exact/FTS/filter Search is accepted for the bounded Friday technical showcase/read-contract discussion. pgvector/vector/hybrid remains explicitly deferred and gains no Publication or Production authority.