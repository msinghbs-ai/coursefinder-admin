# CourseFinder M1 Search Enrichment Admission — Technical Acceptance

**Date:** 23 August 2026  
**Change Control:** `CF-CHG-20260823-023`  
**Final gate:** **PASS**  
**Pilot source authority:** `msinghbs-ai/Coursefinder-Pilot@23b2b98284a1c4e694ab37cb4d22c6d8a76b21fa`

PR #25 contains the accepted Search implementation, PR #26 aligns the first migration-ledger correction, and PR #27 mirrors the final native `course-v3` full-refresh/idempotency migrations plus the automated post-fix UAT evidence.

## Accepted boundary

The AU+NZ Search projection remains 33,105 Course documents and is governed as `course-v3`. Search admission remains separate from canonical presence, Layer 4 resolution, canonical publication and channel publication.

Only UAT-approved first-party Course Facts from RMIT and UQ are admitted. Deferred/unqualified sources do not enter Search merely because relational rows exist.

## Field semantics

| Field/domain | Authority | Projection behaviour | Consumer behaviour |
| --- | --- | --- | --- |
| CRICOS registered tuition | Layer 1 CRICOS | separate state/value/currency/basis; registered-total-course meaning | filter/sort/display as regulatory tuition only |
| Provider-current tuition | Layer 2 first-party Provider | structured options retain year/basis/scope; annual scalar only for annual-compatible basis | presence/annual max filter; annual scalar sort; options display |
| Official Course URL | Layer 2 first-party Provider | source-gated preferred official URL | display/click; presence filter only |
| Intake | Layer 2 first-party Provider | repeating options + earliest future date | presence filter; earliest-date sort; repeating display |
| English | Layer 2 first-party Provider | repeating test/component observations | presence filter; repeating display; no cross-test numeric sort |
| Scholarship | governed Scholarship model | only published/internal eligible relations | presence filter/display; current admitted count 0 |
| QILT | governed outcome model | excluded from Course grain | no inference |
| PRISMS | governed flow model | excluded from Course grain | no inference |

## Accepted coverage

- CRICOS regulatory tuition: 26,326 present / 131 zero / 191 source-null / 6,457 not-applicable;
- Provider-current tuition: 10 Courses;
- comparable annual/indicative annual Provider tuition: 9 Courses;
- official Course URL: 10 Courses;
- Intakes: 10 Courses / 18 observations;
- English requirements: 10 Courses / 32 observations;
- Scholarships admitted: 0 because current canonical Scholarships remain unpublished;
- QILT active accepted observations: 0;
- PRISMS active accepted observations: 0.

RMIT CRICOS `103390B` retains a `total_indicative` Provider tuition option but is deliberately excluded from the annual-sort scalar.

## Determinism and invalidation

Enrichment stage hash:

`fb0585a82e9fe5bc43e9d34bb0f55968846fefba3cf5cc7a41cd0523814bfd3d`

Earlier bounded UAT proved:

- enrichment replay: 0 changed / 33,105 unchanged;
- controlled derived-hash invalidation: exactly 1 changed / 33,104 unchanged;
- repair APPLY restored idempotency;
- 10 Courses gained searchable enrichment content;
- exactly 10 semantic hashes changed;
- 33,095 prior semantic hashes were retained exactly.

### Final automated full-refresh acceptance

Final reconciliation exposed that the first top-level v3 wrapper still used the v2 base comparison. This caused an unchanged full refresh to report all 33,105 base rows changed. The defect was corrected with native `search.refresh_course_base_v3(boolean)` plus the final v3 idempotency wrapper.

Automated APPLY after the fix:

- projection: `course-v3`;
- rows: 33,105;
- generation: **13**;
- base content hash: `cd2c8422da31f2fa298053a40563c947780ebdaf09d7b41ff983bc6ef9649d9b`;
- enrichment stage hash: `fb0585a82e9fe5bc43e9d34bb0f55968846fefba3cf5cc7a41cd0523814bfd3d`;
- combined projection hash: `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`.

Immediate automated dry replay:

- base: **0 changed / 33,105 unchanged / 0 new / 0 removed**;
- enrichment: **0 changed / 33,105 unchanged**;
- generation remains **13**.

`search.projection_state` records `projection_version=course-v3`, row count 33,105, the combined hash, base/enrichment hashes, `refresh_function=search.refresh_course_documents_v3` and `enrichment_gate=domain_and_source_explicit`.

The final full-projection deterministic APPLY/replay gate therefore passes.

## Search performance / vector boundary

Representative full-projection FTS execution:

- `nursing`: ~11 ms, 416 matches;
- `IELTS`: ~3.6 ms, 164 matches.

The previously rejected M1-SEARCH-VECTOR gate remains unchanged: embeddings 0, active embedding jobs 0, query embedding cache 0; hybrid without a vector corpus resolves to `fts_fallback`; vector-only returns 0 candidates. No vector/hybrid production relevance or latency claim is made.

## Consumer contract decision

Website receives versioned `website-course-search-v2` with materially different tuition concepts represented separately. Website v1 remains available. All Search documents remain unpublished in Pilot, so Website v2 currently returns zero public items.

Zoho remains on Consumer Contract v1.3 with no DTO change. Search state must not be used as canonical presence or publication authority.

## Security / performance regression

New Search relations and refresh/API functions are service-role/private surfaces with explicit ACLs. No new browser direct table CRUD was opened. The known leaked-password-protection warning remains under separate `CF-CHG-20260823-022` governance.

The new source-gate FK is covered by `enrichment_source_gates_source_idx`.

## Live migration ledger

- `20260823015526 — m1_search_enrichment_admission`;
- `20260823015929 — m1_search_enrichment_semantic_hash_stability`;
- `20260823020120 — m1_search_enrichment_source_admission_metadata`;
- `20260823020239 — m1_search_enrichment_source_gate_fk_index`;
- `20260823021306 — m1_search_enrichment_full_refresh_v3`;
- `20260823021630 — m1_search_enrichment_full_refresh_v3_idempotency`.

## Acceptance

**PASS.** Course-Fact Search admission and the native deterministic full `course-v3` refresh are accepted for the governed FTS path. Search publication remains unchanged, and vector/hybrid remains not admitted.
