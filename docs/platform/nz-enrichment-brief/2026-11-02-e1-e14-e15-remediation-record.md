# E1, E14 and E15 remediation record (2 Nov 2026, 05:20–05:34 AEDT)

**Authority:** Platform Admin decisions of 2 Nov 2026 05:18, recorded verbatim in `2026-11-02-morning-execution-mandate-and-decisions.md` (Admin `1df6d000`) before any write.
**Controller:** Claude (integrator), one controller. No other controller acted on these records.
**Nothing was deleted.** Every change is a status change with a reason, and every change can be rolled back (rollback files listed below).

## 1. Live reconciliation before any write (05:20 AEDT)

| Check | Approved pack | Live 05:20 | Result |
|---|---|---|---|
| E1 id set | 41 ids, md5 `3a9fd375…` | 41, `3a9fd3758f1e4f989425478265f68618` | Match |
| E1 rows still the active 30 Oct admissions | 41 | 41 | Match |
| E1 five kept fees (`4cef7c53`, `86782081`, `f11e1411`, `467f5d48`, `cf286581`) | Active, not touched | All active | Match |
| E14 id set | 105 ids, md5 `23488f75…` | 105, `23488f75ba7972f42126852e89292af2` | Match |
| E14 rows active | 105 on 18 courses | 105 on 18 courses | Match |
| Migration head / course-link function | `20261101120000` / `75a53dbb` | Same | Match |
| Layer 4 pending | 1,352 at 02:00 | 1,353 (one new arrival) | Expected movement |

## 2. E1: 41 unsupported fee admissions withdrawn

- **Route:** the documented, count-guarded `PASTE-20261101-e1-fee-withdrawal.sql` (the pack's only route for E1; no fee screen exists for this). It was run exactly as written. The audit event also records the approval.
- **Result:**
  - 41 rows active → inactive, each with a note ("E1 withdrawn 02 Nov 2026 05:2x AEDT: …") and `valid_to` set;
  - the 5 kept fees are still active;
  - catalogue active provider fees 11,578 → 11,537 (−41), and all active fees 91,942 → 91,901 (−41), so no other fee changed.
- **Audit:** `pipeline.admin_control_events` #28596 (`e1_fee_withdrawal`, count 41, ids md5, approval). Search refresh request #7723 was processed at 05:26 AEDT.
- **Website and Zoho:**

| | Before (05:22) | After (05:30) |
|---|---|---|
| E1 courses whose search document shows provider tuition | 27 of 41 | **0** |
| E1 courses with a CRICOS fee still shown | 38 | 38 |
| Courses with another active provider fee | 0 | 0 |
| Projection fingerprint over the 41 courses | `3031d31e` | `e6d1cab8` |

  On three sample courses (116768K, 2992, `9dd4c309…`), the withdrawn amount no longer appears in `public.website_v2_course` or in `public.zoho_edge_course_lookup_v1`. 3 courses (Selkirk, Kalandra, College of the Rockies) now show no tuition until a checked fee is admitted, as the pack expected.
- **No replacement fee was inferred.**
- **Rollback:** `PASTE-20261101-e1-fee-withdrawal-rollback.sql` (same ids, same guards).

## 3. E14: 105 entry rows withdrawn through Catalogue › Entry requirements

- **Route:** the Catalogue › Entry requirements › Course entry requirements screen, signed in as the Platform Admin. For each row:
  - open its drawer; confirm it shows Active;
  - Withdraw, with the reason "E14 (Platform Admin approval 2 Nov 2026 05:18): approved in error on 1 Nov; the read mixed a sibling programme variant or dropped an "and"/"plus" condition. Withdrawn pending re-review.";
  - Confirm, then wait for "Withdrawn. It no longer reaches the website." and the drawer showing Withdrawn.
- **One row at a time**, course by course. Row 1 was verified in the database before continuing. Course order: 079669B, 082653F, 102718B, 2036, 2519, 2527, 2651, 4093, 4095, 4096, 4097, 4116, 4117, 4121, 4380, 4381, 4382, AU4015. **The SQL fallback was not used.**
- **Verified in the database (05:33):**
  - 105 of 105 rows inactive;
  - 105 `pipeline.manual_edit_log` entries (#13295–#13399), one per row: action `withdraw`, active → inactive, actor the Platform Admin account, with the E14 reason;
  - **0 active entry rows remain on the 18 courses**;
  - no other entry row was withdrawn in that hour.
- **Website and Zoho:** for 079669B and AU4015, `website_v2_course` returns an empty `entry` section and Zoho returns no entry requirements, as the pack expected ("these 18 courses show no entry requirements, as before 1 Nov"). A website snapshot was not taken before E14; the before state rests on the 105 active rows above.
- **Effect on Active entry rows:** 1,409 → 1,304 (−105).
- **Rollback:** restore through the same screen (Restore, with a reason), or `PASTE-20261101-e14-entry-rows-withdrawal-rollback.sql` with separate authority.
- **Handling note:** an early attempt to change course by changing the address did not refresh the list. The row was not found, so it stopped before taking any action, and the course filter box was used instead. One drawer was read before it reloaded; the database showed the save was correct, and the check now waits for the drawer.

## 4. E15: course-link repair (Part 1) and option B (Part 2)

- **Route:** the v2.15.398 correction path only applies to pending Layer 4 items. These decisions were made on 30 Oct and cannot be decided again, so the documented count-guarded `PASTE-20261101-e15-course-link-repair.sql` was used.
- **Guards before running (read only, 05:28):**
  - 8 active non-primary official links;
  - 8 active official links on the 4 courses;
  - 0 primary;
  - course_url = the reviewer's page on all 4;
  - 0 hand locks.
  All five guards passed.
- **Part 1, four TAFE courses** (092518G, 107862J, 084563C, 108538B): the 4 old links were made inactive and not primary; the 4 reviewer links were made primary; course_url was already correct and was not changed; the search documents were refreshed for these 4 courses. Event **#28597**.
- **Part 2, option B** (Waikato WI0194, MITO 4226): no data change. The hand-set pages stay (active, primary, locked). Event **#28598** records that the two 30 Oct 12:43 decisions (`202e4319`, `1177c2f1`) were not applied, and that the Platform Admin kept the hand-set pages.
- **Verified (05:30):** each of the 6 courses has exactly 1 active official link. It is primary, equals course_url, and equals the website's `official_course_url`.
- **Unrelated records:** none. The only writes were the 8 named links on 4 courses and two audit events.
- **Rollback:** Part 1's rollback is in the paste file. Option B changed no data.

## 5. Not started yet (by design)

| Item | State | Why |
|---|---|---|
| E13 completeness gate | Build started on branch `cf247-e13-completeness-gate` (agent) | Fixture- and evidence-tested before any release |
| E12 QUT 5-course pilot | **Waiting for a recorded cost ceiling** | Mandate §4.7: "only when its spend ceiling is explicitly recorded". The pack's estimate is about US$0.05, which is not a ceiling. It also runs after the E13 gate |
| E11 RMIT recovery pilot | Preparation (read-only check of stored copies) next | Needs a separately recorded ceiling before any AI read |
| UR-18 slice 1 (country, state, campus, delivery location) | Build started on branch `cf247-ur18-bulk-review-slice1` (agent) | Production apply off (`layer4.bulk_review_enabled` = 0); D-B4 not approved |
