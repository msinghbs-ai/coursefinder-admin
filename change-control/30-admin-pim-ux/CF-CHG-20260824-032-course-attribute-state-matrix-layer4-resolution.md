# CF-CHG-20260824-032 — Course Attribute State Matrix & Terminal Layer 4 Resolution

**Status:** BLOCKED — V2.15.2 DEPLOYED BROWSER UAT REQUIRED  
**Category:** 30-admin-pim-ux  
**Initiated:** 24 August 2026 16:16 AEST (+10:00)  
**Updated:** 24 August 2026 17:04 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — Layer 2 Platform / Course Detail human-resolution UX  
**Owner:** Admin/PIM UX with M2.1 Layer 2 and future Layer 3 integration  
**Related:** `CF-CHG-20260823-029`, `CF-CHG-20260824-031`

## Trigger and accepted UX direction

Course Detail must show governed Course attributes even when empty using:

`Field → value / — → field-specific layer trail → next action`.

Layer strike-through is permitted only after an actual field-specific attempt. Layer 1 gaps are regulatory/source corrections, not Layer 4 overrides. Direct PIM-managed fields may begin at L4. Compound tuition/intake/English facts require typed editors rather than free text. Completeness/L4 resolution never auto-publishes.

## Backend field-state model — PASS

Federation Science (Honours), CRICOS `088661B`, is the reference unresolved Course:

- Delivery mode → `awaiting_l2`;
- Academic options → `awaiting_l2`;
- Current Provider tuition → `awaiting_l3`;
- English requirement → `awaiting_l3`;
- Categories → `l4_input`;
- Collections → `l4_input`;
- Course URL / description / intakes → resolved L2;
- campuses / regulatory identity → resolved L1.

No accepted Layer 3 persistence model exists yet, so the UI must not fake struck L3 → L4 states.

Layer 4 scalar mutation remains audit-recorded through JWT-protected Edge function `layer4-course-resolve`; Search and Publication remain unchanged.

## Browser recovery history

### v2.15.0 — FAIL

The full 16-row field-state drawer caused a blank Course drawer. Browser acceptance failed.

### v2.15.1 — availability recovery

The large field-state matrix was rolled back to the last stable Course Detail presentation. Manual UAT confirmed the Course drawer opens again, but the recovery presentation no longer exposed the expected struck-L2 → Awaiting-L3 state for the Science (Honours) tuition and English gaps.

### v2.15.2 — lightweight field-state recovery

The stable drawer is retained. Field-state trails are reintroduced only inside existing render-safe Course sections rather than by replacing the whole drawer.

Expected Science (Honours) display:

- Current Provider tuition: `—` + struck `L2` → `L3` + `Awaiting L3`;
- English requirement: `—` + struck `L2` → `L3` + `Awaiting L3`;
- Delivery mode: `—` + `L2` + `Awaiting L2`;
- Academic options: `—` + `L2` + `Awaiting L2`;
- Categories: `—` + `L4 input`;
- Collections: `—` + `L4 input`.

Resolved Course URL, description and intakes retain their resolved-layer trails. Empty sections use `—` rather than repeated `Not captured` prose.

Implementation refs:

- `9c25732c02b3b63143d0019e0cfceefdb4cb3e2e` — lightweight render-safe field trails;
- `f3d2e4bc611659f3110fd6adef2bec22ee04e457` — visible `PIM Admin v2.15.2` marker;
- `8e18279a2bed9b0ad7d1bf10530e0193409f8de5` — deployed UAT expectations.

## v2.15.2 deployed UAT requirements

Desktop and mobile must prove:

1. both Federation Bachelor of Arts and Science (Honours) Course drawers open without blank-page/runtime failure;
2. exact `PIM Admin v2.15.2` marker;
3. Science (Honours) shows exactly two field-specific struck-L2 → `Awaiting L3` trails for tuition and English;
4. exactly two `Awaiting L2` fields for Delivery and Academic options;
5. Categories and Collections show direct `L4 input` states;
6. resolved Course URL/English positive path for Bachelor of Arts remains correct;
7. Evidence drill-down remains responsive;
8. no browser/server runtime errors.

## Rollback

If v2.15.2 regresses drawer responsiveness, revert the Course-detail component to the v2.15.1 stable presentation while retaining the field-state backend. Do not remove Layer 2 canonical/enrichment data.

## Current gate

**BLOCKED — V2.15.2 DEPLOYED DESKTOP/MOBILE BROWSER UAT REQUIRED.**

M2.1 remains blocked until the deployed Admin runtime and parent Layer 2 acceptance gate pass.
