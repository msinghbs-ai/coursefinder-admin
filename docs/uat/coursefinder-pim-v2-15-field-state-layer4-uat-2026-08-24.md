# CourseFinder PIM v2.15 Field-State & Layer 4 UAT — 24 August 2026

**Status:** BACKEND PASS / V2.15.1 STABLE-DRAWER DEPLOYED BROWSER RECOVERY PENDING  
**Change Control:** `CF-CHG-20260824-032`

## Backend field-state UAT — PASS

Federation Science (Honours), CRICOS `088661B`, remains the reference unresolved Course.

| Attribute | Expected backend state |
|---|---|
| Delivery mode | Awaiting L2 |
| Academic options | Awaiting L2 |
| Current Provider tuition | L2 attempted → Awaiting L3 |
| English requirement | L2 attempted → Awaiting L3 |
| Categories | Direct L4 input |
| Collections | Direct L4 input |
| Official Course URL | Resolved L2 |
| Course description | Resolved L2 |
| Intakes | Resolved L2 |
| Campuses / regulatory identity | Resolved L1 |

No accepted Layer 3 execution/persistence exists yet, so enrichment fields cannot legitimately show struck L3 → L4.

## Layer 4 authority UAT — PASS for scalar contract

The scalar human-resolution contract is typed/bounded, reason-required, audit-recorded and does not change Search or Publication. Browser writes use JWT-protected Edge function `layer4-course-resolve`; the underlying database mutation path is service-role-only.

A rollback-safe transaction proved a Layer 4 delivery-mode mutation and restored the original value after the test.

## v2.15.0 deployed manual UAT — FAIL

Clicking a Course produced a blank drawer/page. The first field-state browser implementation was therefore rejected despite the backend state model passing.

## v2.15.1 recovery state

A newer parallel recovery commit was reconciled and preserved:

`93565d702257dbd89ca0d3f1b976f340bdc7a1fd` — **Hotfix v2.15 blank Course page by restoring stable drawer**.

The browser field-state matrix is temporarily rolled back. Backend field-state projection remains deployed for later safe reintroduction.

Current Pilot UAT head:

`4a24e7f708b3d2272670314f411dd431450bd8a3`

### Required deployed desktop/mobile recovery checks

For Federation Bachelor of Arts:

- exact `PIM Admin v2.15.1` marker;
- Course drawer visible;
- Course title visible;
- first-party Course URL correct;
- Fees visible;
- English requirement visible and populated;
- Operational state visible;
- Evidence drill-down responsive;
- no browser/server runtime errors.

For Federation Science (Honours):

- Course drawer visible despite unresolved enrichment gaps;
- Fees visible;
- English requirement label visible;
- Operational state visible;
- no blank-page/render exception.

## Deferred browser acceptance

The 16-row visible field-state matrix and terminal L4 controls are **not accepted in v2.15.1**. They must be reintroduced only after the stable drawer recovery passes, with explicit render-safe tests for primitive, array and JSON-object payloads.

## Acceptance rule

Do not close `CF-CHG-20260824-032` or the parent M2.1 gate until the deployed SHA-bound desktop/mobile recovery result is PASS. Any blank-page, timeout or lock-up keeps the gate BLOCKED.