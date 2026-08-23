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

## Pre-change finding

The former `course_fee` gate could not safely be switched to approved. `search.refresh_course_documents_v2()` treated any active international `catalogue.course_fees` row as fee presence; live canonical data contains both CRICOS registered-total-course fees and Provider-current fees. Approving that gate would have falsely represented regulatory fees as Provider-current tuition.

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
- implementation merge SHA: `69ac752193b9a79cc2ba3809ebd68aabbbb97582`;
- ledger-alignment PR: `msinghbs-ai/Coursefinder-Pilot#26`;
- final accepted Pilot source authority: `27b760252ead4591e87277524cf7b59928125517`;
- Pilot UAT: `docs/m1-search-enrichment-admission-uat-2026-08-23.md`.

Live migration ledger:

- `20260823015526 — m1_search_enrichment_admission`;
- `20260823015929 — m1_search_enrichment_semantic_hash_stability`;
- `20260823020120 — m1_search_enrichment_source_admission_metadata`;
- `20260823020239 — m1_search_enrichment_source_gate_fk_index`.

Key durable surfaces:

- `search.enrichment_source_gates`;
- `search.refresh_course_enrichment_v1(boolean)`;
- `search.refresh_course_documents_v3(boolean)`;
- `api.website_course_search_v2(...)`;
- `search.course_documents` `course-v3` enrichment fields.

## Before / after

Before:

- Search documents: 33,105;
- Provider-current tuition/URL/intake/English admitted: 0;
- semantic embeddings accepted: 0;
- projection version: `course-v2`.

After:

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

Accepted deterministic stage hash:

`fb0585a82e9fe5bc43e9d34bb0f55968846fefba3cf5cc7a41cd0523814bfd3d`

- replay: 0 changed / 33,105 unchanged;
- controlled invalidation: 1 changed / 33,104 unchanged, then repaired;
- semantic hashes: exactly 10 changed / 33,095 retained;
- `nursing`: ~11 ms FTS execution, 416 matches;
- `IELTS`: ~3.6 ms FTS execution, 164 matches.

M1-SEARCH-VECTOR remains rejected/not admitted:

- embeddings 0;
- active embedding jobs 0;
- query embedding cache 0;
- hybrid without corpus uses `fts_fallback`;
- vector-only returns 0 candidates.

## Consumer isolation

- `api.website_course_search_v2` is versioned; v1 remains intact;
- all Search documents remain `unpublished`; Website v2 returns 0 published items in Pilot;
- Zoho DTO is unchanged; Consumer Contract v1.3 remains authoritative.

## Security / performance

- new Search relation/functions remain private/service-role surfaces with explicit ACLs;
- no new browser CRUD surface was opened;
- no new security-advisor warning is attributable to this work;
- known leaked-password warning remains governed by `CF-CHG-20260823-022`;
- FK performance finding was resolved with `enrichment_source_gates_source_idx`.

## Rollback / reversion

Rollback is Search-only: block/remove new admissions, restore `course-v2` refresh/API use, clear derived `course-v3` enrichment fields if required, retain all canonical Layer 1/Layer 2 facts/evidence, and do not alter publication state.

## Documentation impact

- Database Architecture v2.10.40;
- Running Build v2.64;
- Master Project Plan v1.62;
- technical acceptance/UAT record added;
- Zoho Consumer Contract remains v1.3;
- PIM Admin Guide and Admin/PIM Design Decisions unchanged.

## Status history

| Timestamp | Status | Decision / event |
|---|---|---|
| 23 Aug 2026 11:49 AEST | IN PROGRESS | Workstream opened after mandatory governance/live-state reconciliation. |
| 23 Aug 2026 | APPLIED | `course-v3` Search enrichment migrations applied to Pilot with source/domain gates. |
| 23 Aug 2026 | UAT PASS | Dry-run/APPLY/replay/invalidation, semantic-hash stability, FTS and consumer/security boundaries passed. |
| 23 Aug 2026 | CLOSED / PASS | Pilot PR #25 merged; governed Course-Fact Search admission accepted. |
| 23 Aug 2026 | RECORD CORRECTION | PR #26 aligned the source migration filename to live ledger version `20260823020239`; no runtime semantics changed. Final Pilot source authority `27b760252ead4591e87277524cf7b59928125517`. |

## Closure

**Final gate: PASS — M1-SEARCH-ENRICHMENT.**

Course-Fact enrichment is admitted to the accepted FTS projection under `course-v3`. Vector/hybrid remains a separate rejected/not-admitted capability and was not reopened by this change.
