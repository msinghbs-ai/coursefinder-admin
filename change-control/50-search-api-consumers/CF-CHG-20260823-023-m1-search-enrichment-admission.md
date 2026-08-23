# CF-CHG-20260823-023 — M1 Search Enrichment Admission

**Status:** CLOSED / PASS  
**Category:** 50-search-api-consumers  
**Initiated:** 23 August 2026 11:49 AEST  
**Closed:** 23 August 2026  
**Origin chat/workstream:** M1-SEARCH-ENRICHMENT — Governed Course-Fact Search Admission Gate  
**Owner:** CourseFinder Search/API consumer workstream  
**Change class:** Search projection / API contract / consumer semantics / UAT

## Trigger

Admit only UAT-approved enrichment into the accepted AU+NZ Course Search projection after bounded first-party Course Facts work, while preserving Layer 1/Layer 2 authority boundaries and materially different fee concepts.

## Accepted semantic contract

| Domain | Accepted Search semantics | Filter/sort contract |
| --- | --- | --- |
| CRICOS registered tuition | separate `regulatory_tuition_*` state/value/basis; Layer 1 registered-total-course meaning retained | state/amount filterable; amount sortable; displayable |
| Provider-current tuition | source-gated `provider_tuition_options`; annual scalar only for `annual`/`indicative_annual` | presence and comparable annual amount filterable; annual scalar sortable; all options displayable |
| Official Course URL | source-gated first-party URL | presence filterable; URL display/click only; not sortable |
| Intake | repeating options plus earliest future date | presence filterable; earliest future date sortable; repeating grain displayable |
| English requirements | repeating test/component structures | presence filterable; displayable; no cross-test scalar sort |
| Scholarships | separately gated repeating associations | presence filterable; displayable; no value sort in this gate |
| QILT | excluded from Course projection | blocked; provider/study-area outcome grain not coerced to Course grain |
| PRISMS | excluded from Course projection | blocked; flow/cohort grain not coerced to Course grain |

Legacy `has_fee` means **Search-admitted Provider-current tuition presence**. It does not mean CRICOS regulatory fee presence.

## Source admission

Only already-qualified/UAT-passed Course Facts sources are admitted:

- `au_rmit_official_course_pages`;
- `au_uq_official_program_pages`.

Deferred QUT remains outside Search admission.

## Implementation references

- implementation PR: `msinghbs-ai/Coursefinder-Pilot#25`;
- ledger-alignment PR: `msinghbs-ai/Coursefinder-Pilot#26`;
- final full-refresh/UAT PR: `msinghbs-ai/Coursefinder-Pilot#27`;
- final accepted Pilot source authority: `23b2b98284a1c4e694ab37cb4d22c6d8a76b21fa`;
- Pilot UAT: `docs/m1-search-enrichment-admission-uat-2026-08-23.md`.

Live migration ledger:

- `20260823015526 — m1_search_enrichment_admission`;
- `20260823015929 — m1_search_enrichment_semantic_hash_stability`;
- `20260823020120 — m1_search_enrichment_source_admission_metadata`;
- `20260823020239 — m1_search_enrichment_source_gate_fk_index`;
- `20260823021306 — m1_search_enrichment_full_refresh_v3`;
- `20260823021630 — m1_search_enrichment_full_refresh_v3_idempotency`.

Key durable surfaces:

- `search.enrichment_source_gates`;
- `search.refresh_course_enrichment_v1(boolean)`;
- `search.refresh_course_base_v3(boolean)`;
- `search.refresh_course_documents_v3(boolean)`;
- `api.website_course_search_v2(...)`;
- `search.course_documents` `course-v3` enrichment fields.

## Accepted state

- Search documents: 33,105;
- CRICOS regulatory tuition: 26,326 present / 131 zero / 191 source-null / 6,457 not-applicable;
- Provider-current tuition: 10 Courses;
- comparable annual/indicative-annual Provider tuition scalar: 9 Courses;
- official Course URL: 10 Courses;
- Intake: 10 Courses / 18 observations;
- English: 10 Courses / 32 observations;
- admitted Scholarships: 0 because current canonical Scholarships remain unpublished;
- QILT/PRISMS Course Search signals: excluded;
- projection version: `course-v3`;
- all 33,105 Search documents remain unpublished.

## UAT

Accepted enrichment stage hash:

`fb0585a82e9fe5bc43e9d34bb0f55968846fefba3cf5cc7a41cd0523814bfd3d`

Earlier bounded UAT:

- enrichment replay: 0 changed / 33,105 unchanged;
- controlled invalidation: 1 changed / 33,104 unchanged, then repaired;
- semantic hashes: exactly 10 changed / 33,095 retained;
- `nursing`: ~11 ms FTS execution, 416 matches;
- `IELTS`: ~3.6 ms FTS execution, 164 matches.

### Final full-refresh blocker and resolution

Final reconciliation found the initial `refresh_course_documents_v3()` still delegated base comparison semantics to `course-v2`, causing a nominally unchanged top-level refresh to report 33,105 base changes. The workstream therefore remained blocked until a native v3 base refresh and idempotency patch were applied and re-tested.

Automated post-fix APPLY:

- generation: 13;
- rows: 33,105;
- base hash: `cd2c8422da31f2fa298053a40563c947780ebdaf09d7b41ff983bc6ef9649d9b`;
- enrichment hash: `fb0585a82e9fe5bc43e9d34bb0f55968846fefba3cf5cc7a41cd0523814bfd3d`;
- combined projection hash: `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`.

Immediate automated replay:

- base: **0 changed / 33,105 unchanged / 0 new / 0 removed**;
- enrichment: **0 changed / 33,105 unchanged**;
- projection version: `course-v3`;
- generation remains 13.

`search.projection_state` now records the accepted `course-v3` projection, full content hash, base/enrichment hashes and explicit domain/source enrichment admission.

M1-SEARCH-VECTOR remains rejected/not admitted: embeddings 0, active embedding jobs 0, query embedding cache 0; hybrid without corpus uses `fts_fallback`; vector-only returns 0 candidates.

## Consumer isolation

- `api.website_course_search_v2` is versioned; v1 remains intact;
- all Search documents remain `unpublished`; Website v2 returns 0 published items in Pilot;
- Zoho DTO is unchanged; Consumer Contract v1.3 remains authoritative.

## Security / performance

- Search control relations/functions remain private/service-role surfaces with explicit ACLs;
- no new browser CRUD surface was opened;
- no new security-advisor warning is attributable to this work;
- known leaked-password warning remains governed by `CF-CHG-20260823-022`;
- FK performance finding was resolved with `enrichment_source_gates_source_idx`.

## Rollback / reversion

Rollback is Search-only: block/remove new admissions, restore `course-v2` refresh/API use, clear derived `course-v3` enrichment fields if required, retain all canonical Layer 1/Layer 2 facts/evidence, and do not alter publication state.

## Documentation impact

- Database Architecture remains v2.10.40;
- Running Build remains v2.64;
- Master Project Plan remains v1.62;
- technical acceptance/UAT updated with final automated full-refresh proof;
- Zoho Consumer Contract remains v1.3;
- PIM Admin Guide and Admin/PIM Design Decisions unchanged.

## Status history

| Timestamp | Status | Decision / event |
|---|---|---|
| 23 Aug 2026 11:49 AEST | IN PROGRESS | Workstream opened after mandatory governance/live-state reconciliation. |
| 23 Aug 2026 | APPLIED | Initial `course-v3` Search enrichment migrations applied with source/domain gates. |
| 23 Aug 2026 | UAT PASS | Enrichment dry-run/APPLY/replay/invalidation, semantic-hash stability, FTS and consumer/security boundaries passed. |
| 23 Aug 2026 | BLOCKED | Final top-level refresh reconciliation found v2 base-comparison churn: 33,105 false changes. |
| 23 Aug 2026 | FIXED | Native `refresh_course_base_v3` plus full-refresh idempotency patch applied. |
| 23 Aug 2026 | AUTOMATED UAT PASS | Full APPLY followed by immediate replay proved 0 changed / 33,105 unchanged for base and enrichment; `projection_state` is `course-v3`, generation 13. |
| 23 Aug 2026 | CLOSED / PASS | Pilot PR #27 merged at `23b2b98284a1c4e694ab37cb4d22c6d8a76b21fa`; final blocker cleared. |

## Closure

**Final gate: PASS — M1-SEARCH-ENRICHMENT.**

Course-Fact enrichment and the native deterministic full refresh are accepted under `course-v3`. Publication remains separate. Vector/hybrid remains rejected/not admitted and was not reopened by this change.
