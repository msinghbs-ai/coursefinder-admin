# CF-CHG-20260820-001 — PIM field semantics, fee presentation and Admin Guide

**Status:** PROPOSED  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 10:30 AEST (UTC+10)  
**Origin chat/workstream:** `M1-PIM — Admin/PIM UX & Governance`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** UI / data-contract / governance / documentation / Zoho-consumer semantics

## Trigger

User validation against the authoritative CRICOS Course Details page for Swinburne University of Technology — Bachelor of Artificial Intelligence, CRICOS Course Code `121174E` — showed that the Admin Course Fee drawer preserves the numeric values but obscures the distinct regulatory fee meanings.

The same review also established the need for durable cross-chat Change Control and a maintained PIM Admin Guide so field meaning, source authority and downstream Zoho semantics can be understood without relying on conversation history.

## Problem / requested outcome

1. Make CourseFinder PIM field semantics understandable and auditable end-to-end.
2. Remove misleading UI assumptions/labels without weakening the canonical model.
3. Prove curated downstream field meaning for Zoho rather than exposing internal storage structure directly.
4. Maintain a practical PIM Admin Guide explaining what each Admin field means, where it comes from and how to validate it.
5. Use Change Control records so the initiating chat/date/time, implementation and UAT can be reviewed later.

## Affected surfaces / related workstreams

- `catalogue.course_fees`
- Course-detail RPC/API contract
- Course verification drawer / Fee presentation
- source/evidence and verification visibility
- Admin/PIM field semantics and Admin Guide
- `60-zoho-integration` curated consumer contract
- architecture review only if a genuine canonical semantic gap is proven

## Semantic impact

**Review required before any canonical/schema change.**

The current canonical fee model already carries distinct fee concepts and supporting dimensions. The first assumption is therefore that this is primarily a presentation/consumer-contract problem, not permission to redesign the schema.

Material distinctions that must remain preserved include:

- `fee_type`
- `currency_code`
- `fee_year`
- `audience`
- `basis`
- `load_basis`
- `campus_id`
- validity
- `source_id` / `evidence_id`
- source snapshot and verification timestamps

CRICOS registered total-course fees must remain semantically separate from future Provider-current annual/per-unit fees.

## Before

For the validated Course, the Admin Fee tab renders generic rows similar to:

`AUD 132900 · — · international`

`AUD 0 · — · international`

`AUD 132900 · — · international`

This makes three different regulatory concepts appear interchangeable and makes the NULL year marker look like an unexplained missing value.

## After

The Admin should explicitly present the governed business concepts, for example:

| Fee type | Amount | Audience | Basis | Year |
|---|---:|---|---|---|
| Tuition Fee | AUD 132,900 | International | Registered total course | Not supplied by source |
| Non-Tuition Fee | AUD 0 | International | Registered total course | Not supplied by source |
| Estimated Total Course Cost | AUD 132,900 | International | Registered total course | Not supplied by source |

Evidence/source, snapshot and verification context should remain available with minimal navigation.

Do not represent zero as missing. Do not invent a fee year when the source does not provide one.

## Source authority / evidence

Validated source case:

- Provider: Swinburne University of Technology
- Course: Bachelor of Artificial Intelligence
- CRICOS Course Code: `121174E`
- CRICOS source page supplied in originating chat
- Source values observed:
  - Tuition Fee: AUD 132,900
  - Non Tuition Fee: AUD 0
  - Estimated Total Course Cost: AUD 132,900
  - Course Level: Bachelor Degree
  - Duration: 156 weeks

Identity/reconciliation must use the stable CRICOS Course Code, not title-only matching.

## Current canonical observations

`catalogue.course_fees` already contains, for CRICOS `121174E`:

- `fee_type = tuition`, `AUD 132900.00`
- `fee_type = non_tuition`, `AUD 0.00`
- `fee_type = estimated_total_course_cost`, `AUD 132900.00`
- `audience = international`
- `basis = registered_total_course`
- source/evidence/version/verification fields are available in the canonical model

A title-only database search also showed multiple different courses named “Bachelor of Artificial Intelligence” with different CRICOS fee values. This confirms that title is not an acceptable reconciliation key.

## Implementation references

- Supabase migration(s): TBD if implementation requires DB/RPC change
- Pilot UI commits: TBD
- PIM Admin Guide: TBD
- Zoho curated field contract: TBD
- UI version at initiation: `v1.7.2`

## UAT

Required first reference UAT:

1. Resolve Course by CRICOS code `121174E`.
2. Compare authoritative CRICOS source values against canonical `catalogue.course_fees`.
3. Verify each fee concept is explicitly labelled in Admin.
4. Verify zero remains zero, not missing.
5. Verify absent source year is represented as source-not-supplied, not invented.
6. Verify source/evidence/snapshot/verification context is reachable.
7. Verify curated Zoho mapping preserves fee type, basis, currency and audience semantics.
8. Verify no title-only identity is used.

## Rollback / reversion

Any UI/RPC presentation change must be independently reversible without deleting canonical fee observations. Schema changes, if ultimately necessary, require their own explicit migration rollback and semantic review.

## Documentation impact

- PIM Admin Guide: REQUIRED
- Architecture: only if canonical semantic change is proven
- Running build: update when accepted implementation changes running behaviour
- Master plan: update only if programme status/gate changes
- UAT/design docs: REQUIRED for accepted implementation
- Zoho contract: REQUIRED before Zoho consumes the fee semantics

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 20 Aug 2026 10:30 AEST | PROPOSED | Change initiated from CRICOS/Admin fee comparison and request for formal field-semantics governance | M1-PIM — Admin/PIM UX & Governance |
| 20 Aug 2026 10:35 AEST | PROPOSED | Change Control moved out of core docs into category hierarchy; project-wide operating instructions established | M1-PIM — Admin/PIM UX & Governance |

## Closure

**Final status:** OPEN / PROPOSED  
**Closed at:** N/A  
**Outcome:** Dedicated PIM field-semantics/Admin Guide workstream to audit and implement the accepted presentation and downstream consumer contract.