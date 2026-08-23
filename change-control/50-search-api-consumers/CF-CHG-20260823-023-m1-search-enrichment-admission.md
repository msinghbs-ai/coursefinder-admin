# CF-CHG-20260823-023 — M1 Search Enrichment Admission

**Status:** IN PROGRESS  
**Category:** 50-search-api-consumers  
**Initiated:** 23 August 2026 11:49 AEST  
**Origin chat/workstream:** M1-SEARCH-ENRICHMENT — Governed Course-Fact Search Admission Gate  
**Owner:** CourseFinder Search/API consumer workstream  
**Change class:** Search projection / API contract / consumer semantics / UAT

## Trigger

Admit only UAT-approved enrichment into the accepted AU+NZ Course Search projection after bounded first-party Course Facts work, while preserving Layer 1/Layer 2 authority boundaries and materially different fee concepts.

## Requested outcome

Define and implement governed Search semantics for CRICOS registered tuition, Provider-current tuition, official Course URL, intake availability, English requirements, Scholarships and QILT/PRISMS signals where appropriate. Define filterable/sortable/display-only/excluded behaviour. Prove deterministic dry-run/APPLY/replay/invalidation and benchmark accepted FTS behaviour. Re-test vector/hybrid only to the extent permitted by the previously accepted M1-SEARCH-VECTOR decision.

## Affected surfaces / related workstreams

- `search.course_documents` and Search refresh functions
- Website Search DTO/API
- Zoho consumer contract only if a genuine consumer requirement is established
- M1-L2-AU-COURSE-FACTS (`CF-CHG-20260820-002`, `003`, `004`)
- M1-SEARCH-VECTOR UAT v1.0
- Scholarships, QILT and PRISMS enrichment boundaries
- running-build/master-plan/architecture only where programme or structural state genuinely changes

## Pre-change finding

The existing `course_fee` gate cannot safely be switched to approved as-is. `search.refresh_course_documents_v2()` computes `has_fee` from all active international `catalogue.course_fees`; the live table contains both CRICOS registered-total-course fees and Provider-current fees. Enabling the gate without a semantic split would incorrectly treat regulatory fee presence as Provider-current fee enrichment.

Live bounded Course Facts currently include 10 official Course links, 10 Courses with Provider-current tuition, 10 Courses with intakes and 10 Courses with English requirements. CRICOS regulatory fee rows remain a separate Layer 1 fact class.

## Governing semantic intent

- CRICOS registered tuition remains a regulatory total-course fact and must never be labelled or filtered as Provider-current tuition.
- Provider-current tuition retains year/basis/campus/scope and is admitted only from UAT-approved first-party Course Facts.
- Official Course URL is an admitted first-party link, not identity authority.
- Intake and English requirements retain repeating/source-scoped grain; scalar simplification must not discard material distinctions.
- Scholarship association remains separately gated.
- QILT/PRISMS signals are not to be projected at Course grain unless the source grain and approved mapping support that interpretation.
- Search admission remains separate from canonical publication and channel publication.

## Implementation references

Pending.

## UAT

Required before closure:

1. pre-change semantic audit;
2. deterministic projection dry-run;
3. APPLY;
4. exact replay/idempotency;
5. changed-content/hash invalidation test;
6. fee-semantic non-conflation checks;
7. Course Facts bounded coverage checks;
8. Website DTO contract checks;
9. Zoho no-change or versioned-change check;
10. FTS latency/relevance benchmark after semantic-content expansion;
11. vector/hybrid boundary check against M1-SEARCH-VECTOR rejection;
12. ACL/security advisor regression.

## Rollback / reversion

Revert the Search enrichment migration/contract and restore the prior `course-v2` projection/gates. Canonical Layer 1/Layer 2 facts and evidence are not deleted by Search rollback.

## Status history

| Timestamp | Status | Decision / event |
|---|---|---|
| 23 Aug 2026 11:49 AEST | IN PROGRESS | Workstream opened after mandatory governance/live-state reconciliation. |
