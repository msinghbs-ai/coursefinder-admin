# CourseFinder Database Architecture v2.10.40

**Effective:** 23 August 2026  
**Status:** **CURRENT — GOVERNED SEARCH ENRICHMENT `course-v3` ACCEPTED**  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.39.md`  
**Canonical identity semantics:** unchanged

## 1. Scope

All accepted v2.10.39 architecture remains in force. This revision adds governed Search enrichment admission under `CF-CHG-20260823-023`. It does not alter Provider/Course/Campus/Scholarship identity, imply publication, or reopen the rejected vector candidate.

## 2. Search authority boundary

Accepted authority remains:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

Search admission now uses both `search.enrichment_gates` and source-specific `search.enrichment_source_gates`. Canonical relational presence alone is insufficient.

## 3. Fee architecture

Materially different tuition concepts remain separate.

CRICOS registered tuition projects through `regulatory_tuition_state`, `has_regulatory_tuition`, `regulatory_tuition_amount`, `regulatory_tuition_currency` and `regulatory_tuition_basis`, retaining Layer 1 `registered_total_course` meaning and `present/zero/source_null/not_applicable` state semantics.

Provider-current tuition projects separately through `has_provider_current_tuition`, `provider_annual_tuition_amount`, `provider_annual_tuition_currency` and structured `provider_tuition_options`. Only `annual`/`indicative_annual` basis is eligible for the comparable annual scalar; `total_indicative` remains structured/display data.

Legacy `has_fee` maps to Provider-current Search admission only.

## 4. Other admitted Course Facts

`search.course_documents` adds `official_course_url`, repeating `intake_options`, `earliest_intake_date`, repeating `english_requirement_options`, `scholarship_options`, `enrichment_semantic_text` and `enrichment_content_hash`.

Repeating intake and English facts are not flattened into lossy scalar semantics.

## 5. QILT / PRISMS boundary

QILT and PRISMS remain blocked from Course-grain Search. Their provider/study-area/flow/cohort grains are not invented at Course level.

## 6. Deterministic refresh

Accepted refresh path is `search.refresh_course_documents_v3(p_apply)`, composing the accepted base v2 refresh with `search.refresh_course_enrichment_v1(p_apply)`.

Accepted stage hash:

`fb0585a82e9fe5bc43e9d34bb0f55968846fefba3cf5cc7a41cd0523814bfd3d`

Replay is 0 changed / 33,105 unchanged. Canonical facts are not mutated by Search refresh.

## 7. Semantic-content hash contract

Searchable enrichment text derives from admitted semantic content, not raw URLs or fee-number strings. Exactly 10 Courses gained searchable enrichment text, exactly 10 semantic hashes changed, and 33,095 prior hashes remained exact. Projection-version churn alone must not invalidate embeddings.

## 8. Website / Zoho

`api.website_course_search_v2(...)` is a versioned service-only DTO/filter/sort contract that represents CRICOS regulatory tuition and Provider-current tuition separately. Website v1 remains intact. All 33,105 Pilot Search documents remain unpublished.

Zoho Consumer Contract remains v1.3 with no new DTO fields; Search state is not canonical presence/publication authority.

## 9. Vector / hybrid position

M1-SEARCH-VECTOR remains rejected/not admitted: 0 accepted embeddings, 0 active embedding jobs and 0 query-cache rows. Hybrid without an admitted vector corpus uses FTS fallback; vector-only has no accepted corpus.

## 10. Live migration ledger

- `20260823015526 — m1_search_enrichment_admission`;
- `20260823015929 — m1_search_enrichment_semantic_hash_stability`;
- `20260823020120 — m1_search_enrichment_source_admission_metadata`;
- `20260823020239 — m1_search_enrichment_source_gate_fk_index`.

The source-control filenames are aligned to the live Supabase migration ledger by Pilot PR #26.

## 11. Security / performance

New Search control relations/functions remain private/service-role surfaces with explicit ACLs. A covering index on `search.enrichment_source_gates(source_id)` resolves the new FK-index advisor finding. The known Pilot leaked-password warning remains governed separately under `CF-CHG-20260823-022`.

## 12. Accepted implementation

Final Pilot source authority:

`msinghbs-ai/Coursefinder-Pilot@27b760252ead4591e87277524cf7b59928125517`

Implementation semantics were merged in PR #25; PR #26 only aligned the migration filename to the live ledger.

Technical acceptance:

`docs/uat/coursefinder-m1-search-enrichment-admission-technical-acceptance-2026-08-23.md`

## 13. Architecture outcome

**Accepted.** `course-v3` is the governed Course Search projection for approved Course-Fact enrichment. Identity and publication authority remain unchanged. Vector/hybrid remains outside the accepted production Search path.
