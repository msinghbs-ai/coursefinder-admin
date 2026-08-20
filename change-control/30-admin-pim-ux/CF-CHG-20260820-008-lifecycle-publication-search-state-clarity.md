# CF-CHG-20260820-008 — Lifecycle, publication and Search projection state clarity

**Status:** OPEN / AUDITED — IMPLEMENTATION IN PROGRESS  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 12:06 AEST (UTC+10)  
**Origin chat/workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Owner:** CourseFinder Admin/PIM governance  
**Change class:** Admin semantic presentation / Search-state separation / lifecycle/publication clarity

## Trigger

The full Course semantic walkthrough showed that exact CRICOS `121174E` simultaneously has:

- canonical lifecycle: `active`;
- canonical publication status: `unpublished`;
- a Search projection record whose projection status is `active`.

These states are not contradictory because they represent different layers. However the current Course UI exposes lifecycle/publication prominently while Search projection is buried inside generic detail, making it easy to interpret “has a Search document” as “published to consumers”.

The PIM Admin Guide already prohibits that interpretation:

- canonical readiness and Search readiness are separate concepts;
- completeness/readiness is not publication approval;
- `last_verified_at` means verified against evidence, not approved;
- Layer 2 canonical presence does not imply Search admission.

## Governed state definitions

### Lifecycle

`catalogue.courses.lifecycle_status`

Canonical record lifecycle state. It is not publication approval.

### Publication

`catalogue.courses.publication_status`

Canonical publication-governance state. It must not be inferred from Search projection existence.

### Search projection

`search.course_documents` presence/status

A derived Search projection record exists and has its own operational status. Projection existence/status does **not** mean the Course is consumer-published or that blocked enrichment is admitted.

### Verification

`last_verified_at`

Most recent verification against retained evidence. It is not human approval.

## Accepted correction

1. Expose Search projection presence/status/updated time as explicit fields in the governed Course page result.
2. Keep Search fields semantically separate from canonical lifecycle/publication/readiness.
3. Add a clear Course-grid Search projection state column.
4. Add a Course-detail State section showing Lifecycle, Publication, Search projection, Search projection updated time and Last verified.
5. Label Search as **projection**, never as “published”.
6. Preserve the existing Search-admission boundary: current Search fee/intake/English enrichment remains unadmitted.
7. Do not alter `search.course_documents` contents merely for Admin display.

## Reference case

CRICOS `121174E` is the first state-separation UAT case:

- lifecycle: active;
- publication: unpublished;
- Search projection: present / active;
- Search enrichment fee/intake/English: false;
- last verified: evidence verification timestamp, not approval.

## UAT required

1. exact `121174E` page result carries lifecycle/publication/Search projection as separate values;
2. Search projection presence does not change publication status;
3. Course grid labels Search as projection state;
4. Course detail explicitly explains projected ≠ published;
5. current Search enrichment flags remain unchanged;
6. exact fee/readiness/QILT/PRISMS/Evidence regressions remain PASS;
7. no Search document is created/deleted/modified by this change;
8. deployed authenticated browser UAT after source release.

## Rollback

Revert the Admin read/display additions. Do not change lifecycle/publication/Search records to roll back presentation.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 20 Aug 2026 12:06 AEST | AUDITED / OPEN | `121174E` proven active + unpublished + Search-projected simultaneously; UI state separation required | `M1-PIM-GOV` / live Pilot audit |
| 20 Aug 2026 | APPLIED — BACKEND | Additive Course page Search-state decorator applied in Pilot; Search data unchanged | `m1_pim_gov_course_state_projection_v1` |

## Closure

**Final status:** OPEN / IMPLEMENTATION IN PROGRESS  
**Closed at:** N/A  
**Outcome:** Backend additive state contract applied; frontend/source UAT pending.
