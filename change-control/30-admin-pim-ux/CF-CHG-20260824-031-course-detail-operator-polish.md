# CF-CHG-20260824-031 — Course Detail Operator Polish

**Status:** APPLIED — DEPLOYED BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 24 August 2026 14:00 AEST (+10:00)  
**Updated:** 24 August 2026 15:42 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — Layer 2 Platform / Admin cross-check  
**Owner:** M2.1 Layer 2 Platform + Admin/PIM UX workstreams

## Trigger

Manual Admin cross-check of Federation University Australia `Bachelor of Arts` (`085611C`) after Layer 2 canonical enrichment showed that the underlying data was present but Course Detail remained too implementation-oriented for management/PIM use.

Initial defects included blank official Course URL, duplicate fee presentation, empty optional panels, non-clickable Evidence, rough regulatory wording and generic object dumps. A second visual UAT pass required figure-first fee presentation, reversible Evidence navigation and layer provenance badges. A third live browser UAT at 15:36 AEST identified a critical v2.14 regression: clicking Course Evidence caused Chrome `Page Unresponsive`.

## Root cause of v2.14 Evidence freeze

`src/evidence-return-entry.js` used a document-wide `MutationObserver`. Its callback removed and recreated the `Back to Course` button. Those DOM changes immediately retriggered the same observer, producing an unbounded mutation/render loop and locking the browser tab.

This was a UI helper defect only. Evidence ACL, stored artifacts and canonical Course data were not corrupted.

## Semantic impact

No canonical fee semantics change.

- CRICOS registered tuition/non-tuition/estimated-total-course-cost remain Layer 1 `registered_total_course` facts.
- Provider-current tuition remains a separate Layer 2/current Provider fact.
- Course URL may resolve from active governed `official_course` `catalogue.course_links` when the legacy scalar is empty.
- layer badges are presentation/provenance hints only and do not change authority.
- completeness/readiness is not publication approval.
- Search/publication authority is unchanged.

## Live read contract

Migration `m2_1_admin_course_detail_enrichment_presentation_contract` remains active.

Federation Bachelor of Arts validation:

- official Course URL: `https://www.federation.edu.au/courses/dhm5-bachelor-of-arts/`;
- registered CRICOS fee rows: `3`;
- Provider-current fee rows: `0`;
- distinct supporting Evidence rows in Course Detail union: `3`.

## PIM Admin v2.14.1 presentation

Course Detail uses the dedicated `CourseDetailPolish` renderer.

### Fee cards

Fee rows present clear fee type, monetary figure as the primary value, Year/Audience/Basis as secondary metadata, explicit `L1` or `L2` provenance badge, and Evidence action. Registered CRICOS and Provider-current tuition remain separate columns.

### Provenance badges

Compact `L1`, `L2`, `L3`, `L4` badges may appear beside important facts. Current Course Detail derives them from already-returned authority context; no per-field RPC is issued merely to render a badge. Future Layer 3/4 resolved values must use stored resolution provenance rather than guessed badges.

### Evidence return — v2.14.1 hotfix

Course-originated Evidence links retain `return_course_id`.

The v2.14 mutation observer was removed. The helper is now idempotent and event-driven:

- one render attempt is started on initial document readiness/hash navigation;
- bounded retries wait only for the Evidence hero to mount;
- an existing Back button is reused rather than removed/recreated;
- route generations cancel stale retries;
- there is no page-wide MutationObserver and therefore no self-triggering DOM loop.

The action returns to `#courses?id=<course-id>` and reopens the exact Course drawer.

### Empty optional sections

Academic Options, Categories and Collections remain hidden when empty.

## Publication guidance

PIM Admin Guide v1.18 is the current M2.1 operator guide for this workflow.

100% completeness must **not** auto-publish a Course. Recommended operation:

`Completeness/readiness → Publication eligibility → bounded operator selection → preview → explicit Publish/Internal action → audit event → Search refresh → consumer visibility verification`.

Broad Pilot catalogue publication remains unauthorised until a later explicit gate enables it.

## Implementation references

Pilot:

- `src/CourseDetailPolish.jsx` — figure-first fees, layer badges and Evidence return context;
- `src/evidence-return-entry.js` — v2.14.1 bounded/idempotent Evidence return helper; commit `48d7a5406d05fad69a0bf829e78a5aa93ad64383`;
- `src/pim-version-entry.js` — visible v2.14.1 patch marker; commit `839ff21dea50b79b82cf029f45ed621ca442e213`;
- `index.html` — v2.14.1 runtime marker; commit `297b2d121768d2fe5f77385dd89e583e51e0130c`;
- `tests/uat/course-detail-polish-deployed.spec.mjs` — v2.14.1 desktop/mobile acceptance; commit `1d9301919bb9036b11fefc51bc0d2b4b10ff3601`.

Governance:

- `docs/coursefinder-pim-admin-guide-v1.18.md` — operator/publication guidance.

## UAT

### Backend contract — PASS

- official Course URL resolves from governed active Course link;
- registered CRICOS fee count remains 3;
- no Provider-current fee is manufactured for Federation Bachelor of Arts;
- Course-link/description Evidence is included;
- no Search/publication mutation.

### Manual deployed browser v2.14 — FAIL

24 August 2026 15:36 AEST: Chrome became unresponsive immediately after navigating from Federation Bachelor of Arts Course Detail to an Evidence artifact with `return_course_id`. Evidence round-trip acceptance therefore failed v2.14 and triggered the v2.14.1 hotfix.

### Automated deployed browser v2.14.1 — pending

The updated test verifies:

- PIM v2.14.1 runtime marker;
- Federation Bachelor of Arts drawer opens;
- official first-party URL is visible/clickable;
- figure-first fee display and CRICOS/current Provider separation;
- L1/L2 badges;
- empty optional sections suppressed;
- Evidence navigation reaches the Evidence drawer responsively;
- `Back to Course` is visible and returns to the exact Course drawer;
- no browser/server runtime errors under desktop/mobile Chromium.

Required browsers: Chromium desktop and Chromium mobile.

## Rollback

Revert the v2.14/v2.14.1 Pilot UI helper commits. Canonical Layer 2 facts, Course links, Evidence and frozen M1 Search/publication state do not require rollback because this is a presentation/navigation increment.

## Current gate

**APPLIED — DEPLOYED BROWSER UAT PENDING.**

v2.14 Evidence round-trip is explicitly rejected. `CF-CHG-20260823-029` remains the parent M2.1 acceptance gate until v2.14.1 deployed desktop/mobile acceptance is PASS.
