# CourseFinder PIM v2.15 Field-State, Layout & Layer 4 UAT — 24 August 2026

**Status:** BACKEND PASS / V2.15.3 DEPLOYED BROWSER PENDING  
**Change Control:** `CF-CHG-20260824-032`

## Backend field-state UAT — PASS

Federation Science (Honours), CRICOS `088661B`, remains the reference unresolved Course.

| Attribute | Expected backend state | Routine drawer treatment in v2.15.3 |
|---|---|---|
| Delivery mode | Awaiting L2 | visible `—` + Awaiting L2 |
| Academic options | Awaiting L2 | optional/empty, suppressed |
| Current Provider tuition | L2 attempted → Awaiting L3 | visible `—` + struck L2 → Awaiting L3 |
| English requirement | L2 attempted → Awaiting L3 | visible `—` + struck L2 → Awaiting L3 |
| Categories | Direct L4 input | optional/empty, suppressed from routine drawer |
| Collections | Direct L4 input | optional/empty, suppressed from routine drawer |
| Official Course URL | Resolved L2 | visible |
| Course description | Resolved L2 | visible |
| Intakes | Resolved L2 | visible |
| Campuses / regulatory identity | Resolved L1 | visible |

No accepted Layer 3 execution/persistence exists yet, so enrichment fields cannot legitimately show struck L3 → L4.

## Layer 4 authority UAT — PASS for scalar contract

The scalar human-resolution contract is typed/bounded, reason-required, audit-recorded and does not change Search or Publication. Browser writes use JWT-protected Edge function `layer4-course-resolve`; the underlying database mutation path is service-role-only.

A rollback-safe transaction proved a Layer 4 delivery-mode mutation and restored the original value after the test.

## Browser recovery history

### v2.15.0 — FAIL

The full replacement field-state matrix caused a blank Course drawer/page and was rejected.

### v2.15.1 — recovery

The last stable drawer restored application availability but temporarily removed unresolved field-state commentary.

### v2.15.2 — lightweight state trail

The stable drawer architecture was retained. Tuition/English/Delivery layer states were reintroduced only inside existing render-safe sections.

### v2.15.3 — standardised layout and retained working state

The current browser candidate keeps that stable architecture and adds:

- consistent field-label/value/metadata typography;
- prominent bold fee amounts;
- desktop two-column **Fees & entry requirements** layout, responsive stacking on narrow screens;
- Locations following the default decision block;
- optional empty Academic Options/Categories/Collections suppression;
- object-safe Operational State formatting;
- user-reorderable major Course decision cards below fixed identity/description;
- per-user browser-local Course card-order persistence;
- per-user/per-screen catalogue search and filter persistence across reload and logout/login;
- explicit Clear semantics for saved screen search/filter state;
- no MutationObserver-based persistence or layout logic.

## Required deployed desktop/mobile v2.15.3 checks

### Federation Bachelor of Arts

- exact `PIM Admin v2.15.3` marker;
- drawer renders without blank-page/timeout;
- official first-party Course URL is correct;
- **Fees & entry requirements** visible;
- Registered tuition `AUD 77,100` remains prominent;
- English requirement remains labelled and populated;
- Locations visible;
- Operational state object-safe;
- Evidence drill-down responsive.

### Federation Science (Honours)

- drawer renders despite unresolved enrichment gaps;
- Current Provider tuition visible as blank with struck L2 → Awaiting L3;
- English requirement visible as blank with struck L2 → Awaiting L3;
- Delivery visible as blank + Awaiting L2;
- empty Academic Options/Categories/Collections headings absent from routine drawer;
- Locations and Operational state visible;
- no browser/server runtime errors.

### Course section-order persistence

- default first movable card = Fees & entry requirements;
- user can arrange Locations ahead of it;
- reload preserves that order for the same signed-in user/browser;
- clearing the test preference restores the default;
- no canonical Course data changes.

### Per-screen filter/search persistence

- Courses search `088661B` + Country Australia persist after reload;
- same values restore after logout/login for the same user/browser;
- **Clear** removes the saved state;
- subsequent reload returns Search blank + Country All;
- saved preference data contains UI state only.

## Automated implementation refs

- `tests/uat/course-detail-polish-deployed.spec.mjs`;
- `tests/uat/screen-state-persistence-deployed.spec.mjs`;
- `.github/workflows/deployed-uat.yml` runs both on desktop and mobile Chromium and publishes SHA-bound commit status.

## Acceptance rule

Do not close `CF-CHG-20260824-032` or the parent M2.1 gate until the deployed SHA-bound desktop/mobile v2.15.3 result is PASS. Any blank-page, timeout, state-restore loop or responsive layout regression keeps the gate BLOCKED.
