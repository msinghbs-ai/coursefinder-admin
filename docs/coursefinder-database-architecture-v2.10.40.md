# CourseFinder Database Architecture v2.10.40

**Effective:** 23 August 2026  
**Status:** **CURRENT — GOVERNED SEARCH ENRICHMENT `course-v3` ACCEPTED**  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.39.md`  
**Canonical identity semantics:** unchanged

## 1. Scope

All accepted v2.10.39 architecture remains in force. This revision adds the governed Search enrichment admission architecture accepted under `CF-CHG-20260823-023`.

The change does not alter Provider/Course/Campus/Scholarship identity. It does not imply publication. It does not reopen the rejected vector candidate.

## 2. Search authority boundary

Accepted operational authority remains:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

Search now has two independent admission dimensions:

1. domain admission in `search.enrichment_gates`;
2. first-party source admission in `search.enrichment_source_gates`.

A canonical row is not searchable merely because it exists.

## 3. Fee architecture

Materially different tuition concepts are permanently separate in Search.

### CRICOS registered tuition

Projected as:

- `regulatory_tuition_state`;
- `has_regulatory_tuition`;
- `regulatory_tuition_amount`;
- `regulatory_tuition_currency`;
- `regulatory_tuition_basis`.

The value retains Layer 1 `registered_total_course` meaning. State semantics preserve `present`, `zero`, `source_null` and `not_applicable`.

### Provider-current tuition

Projected separately as:

- `has_provider_current_tuition`;
- `provider_annual_tuition_amount`;
- `provider_annual_tuition_currency`;
- `provider_tuition_options`.

The structured options retain year/basis/campus/validity. The annual scalar is populated only for comparable `annual` or `indicative_annual` basis. `total_indicative` remains structured/display data and is not coerced into an annual sort value.

Legacy `has_fee` maps to Provider-current Search admission only. It no longer means CRICOS regulatory fee presence.

## 4. Other admitted Course Facts

`search.course_documents` adds:

- `official_course_url`;
- `intake_options`;
- `earliest_intake_date`;
- `english_requirement_options`;
- `scholarship_options`;
- `enrichment_semantic_text`;
- `enrichment_content_hash`.

Repeating intake and English facts remain structured rather than flattened into lossy scalar semantics.

## 5. QILT / PRISMS boundary

QILT and PRISMS remain blocked from Course-grain Search in this revision.

The live Pilot has no accepted active QILT/PRISMS observations for this gate, and their provider/study-area/flow/cohort grains must not be invented at Course level.

## 6. Deterministic refresh

Accepted refresh path:

`search.refresh_course_documents_v3(p_apply)`

Execution composes:

1. the accepted base `course-v2` projection refresh;
2. `search.refresh_course_enrichment_v1(p_apply)`.

The enrichment refresh supports dry-run/APPLY/replay statistics and a deterministic full-stage hash. Canonical facts are not mutated by Search refresh.

Accepted stage hash at closure:

`fb0585a82e9fe5bc43e9d34bb0f55968846fefba3cf5cc7a41cd0523814bfd3d`

Replay is 0 changed / 33,105 unchanged.

## 7. Semantic-content hash contract

Searchable enrichment text currently derives from admitted intake/English/eligible Scholarship semantic content, not raw URLs or fee numbers.

Semantic hash stability is content-sensitive:

- 10 Courses gained genuine searchable enrichment text;
- exactly 10 semantic hashes changed;
- 33,095 prior semantic hashes remained exact.

Projection-version changes alone must not invalidate embeddings.

## 8. Website API

Versioned service-only contract:

`api.website_course_search_v2(...)`

Adds governed Provider-current tuition filtering, comparable annual tuition max, intake/English/Scholarship presence filters and supported sorts for regulatory tuition, annual Provider tuition and earliest intake.

The DTO represents CRICOS regulatory tuition and Provider-current tuition as separate objects.

Website v1 remains intact. Search publication state is still authoritative for Website visibility; all 33,105 Pilot Search documents remain unpublished.

## 9. Zoho contract

Zoho Consumer Contract remains v1.3. No new Zoho DTO fields were admitted by this architecture revision.

Search projection state remains diagnostic and is not canonical presence/publication authority.

## 10. Vector / hybrid position

`M1-SEARCH-VECTOR` remains rejected/not admitted:

- accepted embeddings: 0;
- active embedding jobs: 0;
- query cache: 0.

Hybrid without an admitted vector corpus uses the governed FTS fallback. Vector-only has no accepted corpus. No vector/hybrid production relevance or latency claim is made.

## 11. Live migrations

- `20260823015526 — m1_search_enrichment_admission`;
- `20260823015929 — m1_search_enrichment_semantic_hash_stability`;
- `20260823020120 — m1_search_enrichment_source_admission_metadata`;
- `20260823020800 — m1_search_enrichment_source_gate_fk_index`.

## 12. Security / performance

New Search control relations and functions remain private/service-role surfaces. Explicit ACLs preserve the existing browser boundary.

A covering index on `search.enrichment_source_gates(source_id)` resolves the new FK-index advisor finding.

The known Pilot leaked-password-protection warning remains governed separately under `CF-CHG-20260823-022`.

## 13. Accepted implementation

Pilot:

`msinghbs-ai/Coursefinder-Pilot@69ac752193b9a79cc2ba3809ebd68aabbbb97582`

Technical acceptance:

`docs/uat/coursefinder-m1-search-enrichment-admission-technical-acceptance-2026-08-23.md`

## 14. Architecture outcome

**Accepted.** `course-v3` is the governed Course Search projection for approved Course-Fact enrichment. Identity and publication authority remain unchanged. Vector/hybrid remains outside the accepted production Search path.
