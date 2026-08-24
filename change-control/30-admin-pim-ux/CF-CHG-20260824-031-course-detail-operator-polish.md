# CF-CHG-20260824-031 — Course Detail Operator Polish

**Status:** APPLIED — DEPLOYED BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 24 August 2026 14:00 AEST (+10:00)  
**Updated:** 24 August 2026 14:48 AEST (+10:00)  
**Origin chat/workstream:** M2.1 — Layer 2 Platform / Admin cross-check  
**Owner:** M2.1 Layer 2 Platform + Admin/PIM UX workstreams

## Trigger

Manual Admin cross-check of Federation University Australia `Bachelor of Arts` (`085611C`) after Layer 2 canonical enrichment showed that the underlying data was present but Course Detail remained too implementation-oriented for management/PIM use.

Initial defects included blank official Course URL, duplicate fee presentation, empty optional panels, non-clickable Evidence, rough regulatory wording and generic object dumps. A second visual UAT pass found three further improvements required:

- monetary fee figures should be visually primary instead of embedded in metadata text;
- Evidence opened from a Course needs an explicit `Back to Course` return path;
- operators should be able to see the authority layer for important facts without opening Evidence for every field.

The user also requested explicit publication guidance so completeness does not become an accidental public-release control.

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

## PIM Admin v2.14 presentation

Course Detail now uses the dedicated `CourseDetailPolish` renderer.

### Fee cards

Fee rows present:

- clear fee type;
- monetary figure as the primary value;
- Year / Audience / Basis as secondary metadata;
- explicit `L1` or `L2` provenance badge;
- Evidence action.

Registered CRICOS and Provider-current tuition remain separate columns.

### Provenance badges

Compact `L1`, `L2`, `L3`, `L4` badges may appear beside important facts. The current Course Detail uses already-returned semantic/provenance context and does not issue extra per-field RPCs merely to render a badge. Therefore the expected performance cost is negligible.

Current examples:

- Provider/CRICOS/Study Level/Field/Campuses/Regulatory facts → Layer 1;
- official Course URL/description/intakes/English/current Provider tuition → Layer 2 where the displayed fact comes from deterministic enrichment.

Future Layer 3/4 resolved values must use actual stored resolution provenance rather than a guessed badge.

### Evidence return

Course-originated Evidence links include `return_course_id`. The Evidence workspace injects a `← Back to Course` action when that context is present. The return reopens the exact Course Detail rather than forcing a new catalogue search.

### Empty optional sections

Academic Options, Categories and Collections remain hidden when empty.

## Publication guidance

PIM Admin Guide v1.18 is now the current M2.1 operator guide for this workflow.

100% completeness must **not** auto-publish a Course. The recommended operational sequence is:

`Completeness/readiness → Publication eligibility → bounded operator selection → preview → explicit Publish/Internal action → audit event → Search refresh → consumer visibility verification`.

For scale, publication should use a governed bulk workflow with eligibility filtering and preview. Ineligible Courses must be blocked/skipped visibly; a completeness score must never bypass the accepted publication profile or approval controls.

Broad Pilot catalogue publication remains unauthorised until a later explicit gate enables it.

## Implementation references

Pilot:

- `src/CourseDetailPolish.jsx` — fee figures, layer badges, Evidence return context and publication help;
- `src/evidence-return-entry.js` — Evidence `Back to Course` UI;
- `src/pim-version-entry.js` — visible v2.14 marker alignment;
- `index.html` — PIM Admin v2.14 marker and new runtime helpers;
- `tests/uat/course-detail-polish-deployed.spec.mjs` — v2.14 desktop/mobile acceptance including return navigation and badges.

Governance:

- `docs/coursefinder-pim-admin-guide-v1.18.md` — updated operator/publication guidance.

## UAT

### Backend contract — PASS

- official Course URL resolves from the governed active Course link;
- registered CRICOS fee count remains 3;
- no Provider-current fee is manufactured for Federation Bachelor of Arts;
- Course-link/description Evidence is included;
- no Search/publication mutation.

### Browser acceptance — pending

The v2.14 deployed test verifies:

- PIM v2.14 runtime marker;
- Federation Bachelor of Arts drawer opens;
- official first-party URL is visible/clickable;
- one Fees section only;
- monetary fee figure is rendered visibly;
- CRICOS/current Provider fee separation remains explicit;
- L1 and L2 provenance badges are visible;
- empty optional sections remain suppressed;
- Regulatory Facts uses business wording;
- Evidence opens the artifact;
- `Back to Course` returns to the exact Course drawer.

Required browsers:

- Chromium desktop;
- Chromium mobile.

## Rollback

Revert the PIM v2.14 Pilot UI/runtime helper commits. Canonical Layer 2 facts, Course links, Evidence and frozen M1 Search/publication state do not require rollback because this is a presentation/navigation increment.

## Current gate

**APPLIED — DEPLOYED BROWSER UAT PENDING.**

`CF-CHG-20260823-029` remains the parent M2.1 acceptance gate until deployed desktop/mobile acceptance is PASS.
