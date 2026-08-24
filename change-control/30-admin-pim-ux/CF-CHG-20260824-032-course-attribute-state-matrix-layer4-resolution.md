# CF-CHG-20260824-032 — Course Attribute State Matrix & Terminal Layer 4 Resolution

**Status:** APPLIED — V2.15.3 DEPLOYED BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 24 August 2026 16:16 AEST (+10:00)  
**Updated:** 24 August 2026 18:33 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — Layer 2 Platform / Course Detail human-resolution UX  
**Owner:** Admin/PIM UX with M2.1 Layer 2 and future Layer 3 integration  
**Related:** `CF-CHG-20260823-029`, `CF-CHG-20260824-031`

## Trigger and accepted UX direction

Course Detail is a decision surface rather than a raw field dump. Required and decision-critical fields remain visible when unresolved using:

`Field → value / — → field-specific layer trail → next action`.

Optional/non-required empty groups are suppressed from the routine drawer to reduce clutter. Layer strike-through is permitted only after an actual field-specific attempt. Layer 1 gaps are regulatory/source corrections, not Layer 4 overrides. Compound tuition/intake/English facts require typed editors rather than free text. Completeness/L4 resolution never auto-publishes.

## Backend field-state model — PASS

Federation Science (Honours), CRICOS `088661B`, remains the unresolved reference Course:

- Delivery mode → `awaiting_l2`;
- Academic options → `awaiting_l2` but optional/empty and therefore suppressed from routine drawer;
- Current Provider tuition → `awaiting_l3`;
- English requirement → `awaiting_l3`;
- Categories / Collections → direct L4-managed optional groups, suppressed when empty in the routine drawer;
- Course URL / description / intakes → resolved L2;
- campuses / regulatory identity → resolved L1.

No accepted Layer 3 persistence model exists yet, so the UI must not fake struck L3 → L4 states.

Layer 4 scalar mutation remains audit-recorded through JWT-protected Edge function `layer4-course-resolve`; Search and Publication remain unchanged.

## Browser recovery history

### v2.15.0 — FAIL

The full 16-row replacement field-state drawer caused a blank Course drawer. Browser acceptance failed.

### v2.15.1 — availability recovery

The large matrix was rolled back to the last stable Course Detail presentation. Course opening recovered, but unresolved layer-state trails were no longer visible.

### v2.15.2 — lightweight field-state recovery

The stable drawer was retained and field-state trails were reintroduced only inside existing render-safe sections. Science (Honours) tuition/English again expose struck L2 → Awaiting L3; Delivery exposes Awaiting L2.

### v2.15.3 — standardised decision layout and retained user working state

The next increment standardises field presentation and reduces routine clutter without replacing the stable drawer architecture.

Accepted presentation hierarchy:

1. fixed Course identity/status overview;
2. fixed Course description;
3. **Fees & entry requirements** — Fees and Intakes/English side-by-side on desktop, stacked responsively on narrow viewports;
4. Locations;
5. populated optional Course information only;
6. Regulatory facts;
7. Evidence;
8. Operational state.

Formatting is standardised across normal fields: consistent field label, value and metadata typography. Monetary figures remain deliberately large/bold. Required unresolved fields use `—` plus their field-state trail. Empty non-required Academic Options, Categories and Collections do not consume routine drawer space.

Major decision cards below the fixed identity/description context can be reordered by the signed-in user using **Arrange sections**. Order is stored as a browser-local user preference and survives reload/logout/login on the same browser.

Catalogue working context is also retained per user/per screen in browser localStorage:

- search text;
- selected filters;
- advanced-filter visibility;
- Course decision-card order.

The catalogue **Clear** action removes that screen's saved search/filter state. Preference storage contains no credentials, API keys, Evidence payloads or canonical facts and adds no database/RPC latency.

Cross-device preference synchronisation is deliberately not implemented in this increment.

## Implementation refs

Pilot:

- `38c9e028e208f90eeb8a5edbd4a064142c9eadf5` — standardised Course Detail cards and per-user card ordering;
- `a628400a4a9551146037b9393453991ad01edf91`, corrected by `18345186407af096d3f67d9fc401b27332176673` — per-screen browser-local working-state helper;
- `dedf74f88d7347100a7ba3a288530f29d4407419` — v2.15.3 shell + screen-state entry;
- `48af15bb4c3eec988796bc4fb9fe95a7a8025b43` — exact visible v2.15.3 marker;
- `6488d743f06283ac79bc2c50a181e704ec840c5d`, hardened by `dcfc3a5d794d1e1991e03f7311acf357c669a045` — Course layout/reorder deployed UAT;
- `326c2c9408d210e01cf1e631703944a1bc85233d`, hardened by `05b7674b2fe3e5b69e0b88354fb713a3ca92ad89` — per-screen persistence deployed UAT;
- `11ea427d9ffb3c15a0ab8dfd5468be105998bc4d` — deployed UAT workflow includes screen-state acceptance.

Governance:

- `docs/coursefinder-admin-pim-design-decisions-v1.16.md`;
- `docs/coursefinder-pim-admin-guide-v1.20.md`.

## v2.15.3 deployed UAT requirements

Desktop and mobile Chromium must prove:

1. Bachelor of Arts and Science (Honours) Course drawers open without blank-page/timeout/runtime failure;
2. exact `PIM Admin v2.15.3` marker;
3. standardised **Fees & entry requirements** section renders and fee figures remain prominent;
4. desktop pairs Fees with Intakes/English; narrow viewport remains responsive rather than horizontally overflowing;
5. Science (Honours) retains two field-specific struck-L2 → Awaiting-L3 states for tuition/English and one visible Awaiting-L2 state for Delivery;
6. empty Academic Options, Categories and Collections are suppressed from the routine drawer;
7. Locations follows the default decision block and Evidence remains responsive;
8. user section ordering survives reload and can be reset without changing Course data;
9. Course search and selected filter survive reload and logout/login for the same browser/user until **Clear**;
10. Clear returns the screen to its default search/filter state;
11. no browser/server runtime errors.

## Rollback

If v2.15.3 regresses drawer responsiveness, revert `CourseDetailPolish.jsx` to the accepted v2.15.2 lightweight-state presentation and remove `screen-state-entry.js` from the shell. Browser-local preferences can be ignored/cleared without canonical effect. Do not remove Layer 2 canonical/enrichment data or the read-only field-state backend.

## Current gate

**APPLIED — V2.15.3 DEPLOYED DESKTOP/MOBILE BROWSER UAT PENDING.**

M2.1 remains blocked until the deployed Admin runtime and parent Layer 2 acceptance gate pass.
