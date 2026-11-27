# FB-4B.3-01: VU Bachelor of Early Childhood Education and Leadership, CRICOS 115486F, 2027 tuition (correction input for S1-Build)

S1-RM-Design, 28 Nov 2026 07:10 AEDT. Assignment: SS-Programme-Control (P0, existing tuition mechanism and source qualification). Prepared input only. Nothing has been written to the database: S1-Build owns the fee writer and the release. Spend US$0.

## What the feedback reports

The VU Sydney record of the Bachelor of Early Childhood Education and Leadership (EBCL) shows the wrong 2027 tuition in the Portal (Feedback FB-4B.3-01, P0).

## What the platform holds (from the repository record, not re-read live)

- **105139H (VU Melbourne registration):** corrected by s1056 (Pilot #1579, migration `20261125180000`, live 24 Nov 22:06). It now holds 2026 AUD 33,800 and 2027 AUD 35,500 as calculated annual equivalents (`indicative_annual`, `full_time`); the wrong-year row is kept as superseded history.
- **115486F (VU Sydney and VU Brisbane registration):** s1056 deliberately left it with only its CRICOS registered total. The s1056 read-back gives its annual tuition as `missing`.
- 115486F is a separate CRICOS registration under VU's Sydney and Brisbane provider number (CRICOS 02475D), not a copy of 105139H. Melbourne fees were not copied to it without proof for its own registration, and they are not copied now: the proof below is its own.

## Official evidence (read 28 Nov 2026, $0 direct read)

| Source | What it states |
|---|---|
| VU international course page `https://www.vu.edu.au/courses/international/bachelor-of-early-childhood-education-and-leadership-ebcl` | CRICOS "105139H, 115486F". "Fees for full-time international student (2027): AU$17,750 per semester." "International students are required to pay full tuition fees up front each semester." Campuses: Sydney, Brisbane, City, Footscray Nicholson. One fee figure, with no campus split. No 2026 figure on the page. |
| VU Sydney course page `https://www.vu.edu.au/vu-sydney/courses-at-vu-sydney/undergraduate-courses-vu-sydney/bachelor-of-early-childhood-education-and-leadership-vu-sydney` | "CRICOS code: 115486F". "Fees (2027): AU$17,750 per semester". "Duration: 4 years (8 semesters of study)". 384 credit points. Campus: 160–166 Sussex Street, Sydney. Audience not stated on this page. |
| VU Brisbane course page `https://www.vu.edu.au/vu-brisbane/courses-at-vu-brisbane/bachelor-of-early-childhood-education-and-leadership-vu-brisbane` | "CRICOS code: 115486F". "Fees (2026): AU$16,900 per semester". 4 years (8 semesters). This is an older-year campus page, not a conflicting 2027 amount. |

- **Not stored by this lane:** the session shell cannot reach vu.edu.au (proxy 403), so there is no stored copy or SHA-256 from this read. The fee reader's own $0 direct read must store the two VU pages as evidence before apply. The 105139H row already cites evidence `9d883905` (26 Oct): check whether it is this same international page, and refresh it if its 2027 line is not in the stored copy.

## Correction input (for the existing fee route)

| Field | Value |
|---|---|
| Course | 115486F, the active VU course record of the Bachelor of Early Childhood Education and Leadership. Resolve the course by the CRICOS code under its own provider record; there are two VU provider records, a known duplicate identity |
| Fee years | Two rows, as s1056 did for 105139H: 2026 and 2027 |
| Audience | international |
| Kind | `provider_current_tuition` |
| Amounts | 2026 AUD 33,800 and 2027 AUD 35,500 |
| Basis | `indicative_annual` (shown as a calculated equivalent by `security.course_fee_selected_v1`) |
| Load | `full_time` |
| Derivation | 2026: AUD 16,900 a semester × 2, from the VU Sydney and VU Brisbane campus pages ("Fees (2026)", confirmed by S1-Data-Gaps / DOT for FB-4B.3-01). 2027: AUD 17,750 a semester × 2, from the international page ("Fees for full-time international student (2027)") and the VU Sydney page. Full-time load proof for both: "4 years (8 semesters of study)" |
| Campus | No campus split on the official international page, so the row is course-level (both Sydney and Brisbane). If the writer requires campus rows, write the same amount for each of the course's two campuses; never only for Sydney while Brisbane is inferred |
| Note text | `Calculated annual equivalent: AUD <16,900 or 17,750> a semester (<2026 or 2027>) x 2 semesters, full-time; official VU pages for 115486F (FB-4B.3-01)`, the same wording as the s1056 105139H rows |
| Keep | The CRICOS registered total tuition, as its own line (never turned into an annual amount, and never compared with it as a defect) |
| Existing derived figure | Website API currently shows a derived annual AUD 33,800 with no year (S1-Data-Gaps, 28 Nov). After apply, it is replaced in the selection by the dated provider rows; the derived figure is not deleted |

**Checks the existing route already makes, and which apply here:**
- the code is bound to one active course of the provider;
- a newer current fee year is not overwritten;
- a different amount in the same fee year goes to Layer 4;
- a manual lock stops the write.

**Expected read-back after apply:**
- `security.course_fee_selected_v1(<115486F>, 'international', 2027)` returns AUD 35,500, `calculated_equivalent`, 2027;
- Website API v3 and the Portal course detail show it for VU Sydney;
- 105139H is unchanged (2027 AUD 35,500).

## Lesson for the operational learning register (S1-Build s1292, recovery knowledge)

An annual fee above the CRICOS total is not a defect on its own:
- the CRICOS total is registered at an earlier fee year;
- it covers the registered duration;
- it is a different basis.

For example, for 115486F, 35,500 × 4 years = 142,000, against the registered total of AUD 135,200 the Website API serves (Study Australia shows AUD 128,800, an older registration figure). Before raising a fee defect, compare on the same basis and year: annual against annual, total against total, the same fee year, and the same full-time load.

Also: a course page that states a fee per semester is turned into an annual equivalent only when the page proves the full-time load (semesters a year). The amount is then recorded as `indicative_annual`, never as `annual`.

## Batch 08 (UNE, TAFE Queensland): already prepared by S1-Build

S1-Build's s1327 (`docs/platform/2026-11-28-s1327-batch08-fees-and-intakes.md`) covers the assignment's UNE and TAFE Queensland items in full, and this lane has nothing to add:
- two Decision 162 sources were registered and qualified (`une_2027`, `tafeqld_he_2027`);
- `fee-schedule-etl` v0.9.0 was rehearsed with 82 plus 2 applied and 0 skipped;
- the 13 TAFE Queensland whole-of-course totals are parked.

At 07:05 AEDT it was in release: Pilot branch `s1-build-s1327-fee-html-une-tafeqld`, migration `20261130223000`, and Pilot main still at head `20261130220000`.

## Revision, 28 Nov 2026 09:20 AEDT (S1-RM-Design, CHAT-INIT-20261128)

Added the 2026 row asked for by S1-Data-Gaps (`2026-11-28-s1-data-gaps-vu-feedback-source-integrity.md`, row for S1-RM-Design). Corrected the CRICOS total in the lesson to the live AUD 135,200. Still not applied: this lane has no fee writer and no Pilot or live-read access. s1327 is now merged in Pilot (#1738); its UNE and TAFE Queensland apply has not been run (CURRENT-STATE, 28 Nov).
