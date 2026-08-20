# CourseFinder Change Control Register v1.0

**Status:** AUTHORITATIVE CROSS-CHAT CHANGE TRACEABILITY CONTRACT  
**Effective:** 20 August 2026  
**Owner:** CourseFinder Admin / PIM governance  

## Purpose

Every material CourseFinder change must be traceable to the conversation/workstream that initiated it and to the exact implementation evidence that completed it. This register is the common control point across parallel country, enrichment, Search, Admin/PIM and security chats.

The register complements Git history; it does not replace migrations, UAT evidence, design decisions or source evidence.

## Mandatory change record

For every material change, record:

| Field | Requirement |
|---|---|
| Change ID | Stable `CF-CHG-YYYYMMDD-NNN` identifier |
| Initiated at | Absolute local date/time with timezone |
| Origin chat/workstream | Exact chat/workstream name or supplied callout |
| Change class | Data / schema / ingestion / UI / security / search / governance / documentation |
| Trigger | Defect, source change, UAT finding, user decision, design improvement, security finding, planned gate |
| Problem / requested outcome | Concise statement of why change exists |
| Affected surfaces | DB objects, adapter, RPC/API, Admin UI, Search, Zoho/consumer contract, docs |
| Semantic impact | Whether canonical meaning/identity/field semantics change |
| Before | Existing behaviour/value/contract |
| After | Intended behaviour/value/contract |
| Source authority | Authoritative source(s) and evidence where data semantics are involved |
| Implementation refs | Supabase migration/version, Git commit(s), issue/PR if used |
| UI version | Visible Admin UI version where browser behaviour changes; `N/A` otherwise |
| UAT | Exact bounded checks and result |
| Rollback | Deterministic rollback/reversion path |
| Status | PROPOSED / APPROVED / APPLIED / UAT PASS / CLOSED / REJECTED |
| Closed at | Absolute local timestamp when closed |

## Control rules

1. No material UI/data-contract correction is considered complete solely because code was committed or a migration ran.
2. A change that alters field meaning, source precedence, granularity, identity, publication/search behaviour or Zoho-facing semantics requires explicit semantic-impact review.
3. Browser-facing changes must carry the visible UI version used for UAT.
4. Source-derived values must retain source/evidence/version semantics; UI labels must not collapse materially different source concepts into one ambiguous field.
5. Parallel chats must search/read the latest design decisions and this register before making overlapping changes.
6. A chat may initiate a change, but the final record must point to implementation/UAT evidence rather than relying on conversation history alone.
7. Human-facing Admin labels should use governed business meaning; storage names and raw source vocabulary remain available in provenance/detail where useful.
8. Consumer/Zoho mappings must identify whether a field is canonical, regulatory-source fact, provider-current fact, derived value or display-only value.

## Initial register

### CF-CHG-20260820-001 — PIM field semantics, fee presentation and Admin guide

- **Initiated at:** 20 August 2026 10:30 AEST (UTC+10)
- **Origin chat/workstream:** `M1-PIM — Admin/PIM UX & Governance`
- **Change class:** UI / data-contract / governance / documentation
- **Trigger:** User validation against CRICOS Course Details for Swinburne University of Technology — Bachelor of Artificial Intelligence; current Admin fee drawer is semantically ambiguous.
- **Problem / requested outcome:** Establish formal change traceability; audit PIM field semantics end-to-end; remove nonsensical UI assumptions; prove downstream Zoho field mappings; create and maintain a practical PIM Admin Guide explaining what each field means, where it comes from and how to validate it.
- **Affected surfaces:** `catalogue.course_fees`, Course detail RPC/UI, source/evidence views, Admin labels, Zoho/consumer field contract, PIM documentation.
- **Semantic impact:** REVIEW REQUIRED before any canonical/schema change. Existing fee model already distinguishes regulatory fee types; presentation/downstream mapping must preserve those distinctions.
- **Observed source case:** CRICOS Course Code `121174E` shows Tuition Fee AUD 132,900; Non Tuition Fee AUD 0; Estimated Total Course Cost AUD 132,900.
- **Observed Admin case:** Course drawer presents three generic fee rows without explicit fee-type labels, reducing regulatory meaning.
- **Status:** PROPOSED — dedicated field-semantics/PIM-guide workstream required.
- **UI version at initiation:** UI v1.7.2

## Operating expectation

The change register should stay concise. Detailed investigation belongs in linked UAT/design/PIM-guide documents; the register records what changed, why, where, who/what initiated it, and how the accepted outcome can be reproduced.
