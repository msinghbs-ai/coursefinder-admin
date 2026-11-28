# s1355: the Portal shows a fee in the currency it is held in, labelled by the course's own register

S1-API-Frontend-Delivery, 28 Nov 2026 18:35 AEDT (first recorded as 18:55 in error; corrected 18:48), for PC-20261128-CONTINUOUS-BUILD-EXECUTE (assigned scope: fee semantics, labels and currency, guide parity, using current views and the API contract). Claimed with S1-Build as `s1355` (S1-Build holds integration and release; `s1354` is S1-Build's worker change and does not touch these files). Evidence it builds on: `docs/platform/2026-11-28-fee-display-parity-acceptance.md` (#1371), S1-RM-Design's recommendation (#1376) to close the Portal part of the consolidated currency-and-scheme gap with no schema change.

## Change (Pilot, code and tests only)

No migration, setting, job, cron row, table, edge function, consumer function or spend. The consumer API (G3) and Website API v3 are not touched; the Portal reads the same `portal_course_detail_v1` it read before (the `regulator` object it already returns).

| File | Before | After |
|---|---|---|
| `portal/src/lib/format.js` `money()` | A fee with no currency printed as A$ | A fee with no currency prints the figure alone; no country's currency is assumed |
| `portal/src/lib/courseDetailFormat.js` `feeLabel()` | "(CRICOS)" written into the registered-fee labels | The suffix is the course's own register (`regulator.label`: CRICOS, NZQA, MTCU); none when the course has no register |
| `portal/src/lib/courseDetailFormat.js` `outcomeValue()` | Only the unit `AUD` was formatted as money | Any ISO currency unit (AUD, NZD, CAD, GBP ...) |
| `portal/src/components/CourseDetails.jsx` | Fee list did not know the course's register | `FeeList` receives `body.regulator` |
| `portal/src/lib/proposals.js` `sheetModel()` | Student budget printed as A$ (the editor has no currency field) | Uses a stated budget currency, else the one currency the shortlisted fees share, else the figure alone |
| `src/guide/platformGuide.js` (courses) | Did not describe zero registered amounts, courses with only a registered total, or the Portal card rule | One entry (s1355) |

**Live effect today: none for display.** No active fee row has a null currency (S1-Data-Gaps #1372), the only registered-fee types are AU's (label unchanged: "(CRICOS)"), and the only outcome units are AUD, percent and count. The change removes the Australia assumption before the next country's data arrives (UK, Ireland, US are planned in `ref.registration_schemes`; no activation here).

## Tests

- `tests/uat/cf-247-s1215-portal-course-details-and-entry-requirements-contract.spec.mjs` amended (guard line carries s1355; no new spec). It asserts the labels for CRICOS, NZQA and no register, NZ$ and CA$ amounts, a missing currency shows no symbol, NZD and GBP outcomes, the proposal budget rules, that `FeeList` passes the register, and that `format.js` has no `|| 'AUD'`.
- Local, sandbox: the 11 Portal-formatting specs pass; the 158 Portal, guide-source, G2 (s32), G3 (s57), housekeeping (s42), UI map (s557), paste (s616) and test-governance (s120) checks pass. Six mocked-browser specs (platform guide 2, s32 settings 1, s625 3) fail identically on clean main in this sandbox (browser environment); they are the CI's to confirm on the final head. `node scripts/ui-map.mjs --check` and `export-role-guides.mjs --check` match. Portal build (`vite build`) succeeds.

## Rollback

Revert the Pilot commit (one commit, six files) and let Deploy on merge publish it. No data, setting or consumer state changes with it.

## Verification after release

Signed-in Portal (Browser 1), desktop and 412 px: Course details fee lines for AU 086056F, 069918F, 118175H, NZ 113114 and CA 0024; proposal sheet budget; outcomes for AU. Result recorded in the S1-API-Frontend-Delivery M3 document and on the Pilot pull request.

## Not in this change (owners)

- Whether the Portal card should show a registered-only fee, and whether v3 delivers non-tuition and the total: S1-RM-Design (fee grain) and the Platform Admin; not decided here, and v3/G3 stay untouched.
- Source proof for the 207 no-fee and 124 zero-tuition AU courses: S1-Data-Gaps with S1-Build.
- The Zoho-only `cricos_course_code` and `cricos_provider_code` fields (v3 is open before go-live; v2 frozen): a v3 decision for S1-Build and S1-RM-Design. Correction to #1371: Website v3 and Zoho v3 are identical in business content, not byte for byte (envelope label and those two fields differ).

## Production verification (s1355, Pilot #1763 merged 18:41 AEDT, commit `028b957ff`; signed-in Portal, Platform admin, Browser 1, 18:42 to 18:46)

- **Deploy:** Workers Build `studysearch-portal` succeeded on the merge commit; the live bundle (`index-Czc4RGUe.js`) has no fixed "Registered tuition ... (CRICOS)" literal, no `|| "AUD"` default, and the register suffix comes from `regulator.label`.
- **AU 086056F (James Cook, Veterinary Science Honours [End-on]):** Course details > Other recorded fee lines: "Estimated total course cost (CRICOS)" A$73,845, "Non-tuition fees for the whole course (CRICOS)" A$0, "Registered tuition for the whole course (CRICOS)" A$73,845, each marked not annualised; the card shows no fee (registered-only), as before.
- **NZ 113114:** card NZ$28,000 per year, 2026 fee, provider; "NZQA 113114" badge. **CA 0024:** card CA$15,477 per year, provider. Saved courses and Compare show NZ$28,000 and CA$15,477, totals "about NZ$84,000" and "about CA$46,430" (annual x 3 years).
- **Journeys passed:** search by plain English and by code, Course details drawer, Save and Remove (test saves removed: 0 saved at the end), Compare of two courses, the Study in tab (Australia) kept when moving between Courses and Saved courses, Entry Requirements "Student's country of education" with India and Nepal pinned first.
- **Not measurable here:** the 412 px layout. The browser window cannot be narrowed from the extension (viewport stays 1920 px) and the Portal refuses framing, so it is left to the phone-viewport CI specs (`@responsive`) and a person on a phone. Proposal creation and the A4 print were not repeated live (a proposal writes a record); both are covered by their specs (s1200 to s1202, s1210).

## Defects the production check found (s1356, Pilot #1767)

1. Compare marked CA$15,477 "Lowest per year" against NZ$28,000: raw amounts ranked across currencies. Now ranked only within one currency (`lowestAnnualFee`).
2. The Study in tabs were shown on Saved courses but did nothing: Australia selected still listed NZ and CA saved courses. Saved courses now follow the tab (`country_code` is already in `portal_saved_list_v1`), with an in-this-destination count and an empty notice; the note under the tabs names every screen it applies to.

Both are portal code and the amended s1215 spec only: no migration, setting, job, consumer function or spend. Rollback: revert the one commit.
