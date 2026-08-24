# CF-CHG-20260824-032 — Course Attribute State Matrix & Terminal Layer 4 Resolution

**Status:** BLOCKED — V2.15.1 STABLE-DRAWER RECOVERY UAT REQUIRED; FIELD-STATE UI TEMPORARILY ROLLED BACK  
**Category:** 30-admin-pim-ux  
**Initiated:** 24 August 2026 16:16 AEST (+10:00)  
**Updated:** 24 August 2026 16:58 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — Layer 2 Platform / Course Detail human-resolution UX  
**Owner:** Admin/PIM UX with M2.1 Layer 2 and future Layer 3 integration  
**Related:** `CF-CHG-20260823-029`, `CF-CHG-20260824-031`

## Trigger and accepted UX direction

Course Detail must ultimately show every governed Course attribute even when empty, using:

`Field → value / — → field-specific layer trail → next action`.

Layer strike-through is permitted only after an actual field-specific attempt. Layer 1 gaps are regulatory/source corrections, not Layer 4 overrides. Direct PIM-managed fields may begin at L4. Compound tuition/intake/English facts require typed editors rather than free text. Completeness/L4 resolution never auto-publishes.

## Backend field-state model — PASS

The deployed backend retains the governed field-state projection and terminal L4 audit model. Federation Science (Honours), CRICOS `088661B`, remains the reference unresolved Course:

- Delivery mode → `awaiting_l2`;
- Academic options → `awaiting_l2`;
- Current Provider tuition → `awaiting_l3`;
- English requirement → `awaiting_l3`;
- Categories → `l4_input`;
- Collections → `l4_input`;
- Course URL / description / intakes → resolved L2;
- campuses / regulatory identity → resolved L1.

No accepted Layer 3 persistence model exists yet, so the UI must not fake struck L3 → L4 states.

Layer 4 scalar mutation is audit-recorded and routed through JWT-protected Edge function `layer4-course-resolve`; its database mutation function is service-role-only. Search and Publication remain unchanged by L4 resolution.

## v2.15.0 manual browser UAT — FAIL

Clicking a Course produced a blank drawer/page.

The first field-state drawer was not accepted. Investigation identified an unsafe React rendering path around operational state payloads, and manual behaviour demonstrated the release was not browser-safe regardless of backend correctness.

## v2.15.1 recovery reconciliation

A newer parallel recovery commit was detected and preserved rather than overwritten:

- `93565d702257dbd89ca0d3f1b976f340bdc7a1fd` — **Hotfix v2.15 blank Course page by restoring stable drawer**.

This commit deliberately restores the last stable Course Detail presentation while retaining the field-state backend schema/read model. Therefore **v2.15.1 is an availability recovery build, not final acceptance of the new field-state matrix UI**.

Visible release marker remains **PIM Admin v2.15.1**.

Current Pilot UAT head:

- `4a24e7f708b3d2272670314f411dd431450bd8a3` — recovery UAT aligned to the stable drawer baseline.

The current recovery UAT checks:

1. Bachelor of Arts Course drawer opens and title renders;
2. first-party Course URL is present;
3. Fees render;
4. English requirement renders;
5. Operational state renders without a blank-page failure;
6. Evidence opens responsively;
7. Science (Honours) also opens despite unresolved enrichment gaps;
8. no browser/server runtime errors;
9. exact `PIM Admin v2.15.1` release marker.

## Field-state UI disposition

The 16-row visible field-state matrix is **temporarily rolled back from the browser** to recover application availability. Its backend projection, UAT reference semantics and design decisions remain preserved.

Do not reintroduce the full matrix or inline L4 controls until the stable v2.15.1 drawer passes SHA-bound desktop/mobile deployed UAT. The next browser increment must reintroduce the field-state experience progressively, with render-safe scalar formatting and explicit tests for object/array payloads before deployment.

## Rollback / recovery rule

Availability outranks cosmetic/interaction progress. If the stable v2.15.1 drawer still exhibits blank-page, lock-up or timeout behaviour, revert to the last proven responsive v2.14.3 Course Detail implementation while retaining all safe Layer 2 canonical changes and read-only field-state backend work.

## Current gate

**BLOCKED — V2.15.1 STABLE-DRAWER DEPLOYED BROWSER UAT REQUIRED. FIELD-STATE UI NOT YET ACCEPTED.**

M2.1 remains blocked until the deployed Admin runtime and parent Layer 2 acceptance gate pass.