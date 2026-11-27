# English requirement feedback: official-page corrections (S1-ELR, s1330, 28 Nov 2026)

**Request:** SS-Programme-Control P0, 28 Nov 2026 07:07 AEDT. Source-acquisition mandate 07:44 AEDT.
**Pilot:** #1740, migration `20261130233000`.
**Spend:** US$0. The official pages were plain HTTP reads; no Firecrawl, no model.

English language requirements only. The academic entry correction FB-6.C10-01 stays with S1-AER-Claude.

## 1. Feedback items and outcomes

| Feedback | Course | Held before | Official page (read 28 Nov 2026) | Outcome |
|---|---|---|---|---|
| **FB-6.C10-02** | RMIT Master of Marketing MC197 / 077512F | IELTS 6.5, PTE 58, TOEFL iBT 79; no component minima; no Cambridge | IELTS 6.5 "with no individual band below 6.0"; PTE 58 "no communication band less than 50"; TOEFL iBT 79 "minimum of 13 in Reading, 12 in Listening, 18 in Speaking and 21 in Writing"; CAE 176 "no less than 169 in any component" | **Corrected.** Bands added to 3 rows; CAE row added |
| FB-6.C01-02 | RMIT Bachelor of Business BP343 / 106623K | same | same wording | **Corrected**, same as above |
| FB-6.C13-03 | Deakin Master of Health Management 114205F | IELTS 6.5, no bands | IELTS 6.5 "(with no band score less than 6.0) in each component"; no PTE or TOEFL stated | **Corrected.** IELTS bands added |
| FB-6.C04-03 | VU Bachelor of Business 092944A (00124K) | IELTS 6.0, no bands | IELTS 6.0 "with no band less than 6.0 in Listening, Reading, Writing and Speaking"; no PTE or TOEFL stated | **Corrected.** IELTS bands added |
| FB-4B.3-02 | VU Bachelor of Early Childhood Education and Leadership 105139H (00124K) | IELTS 6.5, no bands | IELTS 6.5 "with no band less than 6.0 …"; no PTE or TOEFL stated | **Corrected.** IELTS bands added |
| FB-6.C02-02 | Swinburne Bachelor of Business 063366D, 088382J | IELTS 6.0 with all four bands 6.0 | The course page states the same IELTS and no PTE or TOEFL score ("equivalent measures" on the central entry page) | **Already correct.** PTE and TOEFL are not stated on the course page, so none is added |
| FB-6.C06-03 | CQU Bachelor of Psychological Science 084516K | IELTS 6.0 (5.5 bands), PTE 54, TOEFL 75; no PTE or TOEFL sections | The course page refused the plain read (client error). The 2027 international course and fee PDF states no English requirement | **Held: source exception** (see 3) |
| FB-6.C04-03 (second record) / FB-4B.3-02 (second record) | VU 092820B, 115486F (provider record 02475D) | IELTS only, no bands | Not read this session (bound to the VU Brisbane and domestic pages) | **Held:** for the same official read |
| FB-6.C07-04 | Adelaide College Diploma in Business Studies | none | The course was not identified in the catalogue by this session | **Held:** catalogue identity (S1-Build) |

Nothing was inferred. No overall score was changed, and no test was added that the page does not state. Every row was guarded against its current value, with no manual lock and no pending Layer 4 item on any of the five courses.

## 2. Website and Zoho verification

These results come from the rolled-back rehearsal. The live read-back after merge goes in section 4.

| Course | `website_v2_course` and `zoho_v2_course` after the change |
|---|---|
| RMIT 077512F and 106623K | CAE 176 band 169; IELTS 6.5 band 6.0; PTE 58 band 50; TOEFL iBT 79 band 12 |
| Deakin 114205F, VU 092944A, VU 105139H | IELTS with band 6.0 |

Before the change, both reads returned `min_band_score` null for every row.

## 3. Genuine held cases and exceptions

- **CQU 084516K.**
  - The course page refuses plain HTTP, and the stored copy (already read) states no PTE or TOEFL section minima.
  - No existing course-page Firecrawl re-fetch can be started from this session: the worker and the admin re-read need a signed-in Platform Admin.
  - Recorded for S1-Build: one existing course-page re-fetch through the backend, then the English reader.
- **Provider-level feedback** (FB-4B.3-07, -12, -19; FB-5.3-03 to -51). These cover Adelaide, Newcastle, Notre Dame, VU, La Trobe, Kaplan, MIT, Charles Sturt, CDU and Tasmania, and no course is named.
  - These are coverage gaps, not single wrong values.
  - Where an approved university English policy gives PTE, TOEFL or Cambridge with all four bands, s1047 already inherits them to the courses whose IELTS agrees.
  - Where it does not, the 55 waiting university readings in the 27 Nov review pack (`docs/monitoring/AU-ELR-REVIEW-PACK-2026-11-27.csv`) are the decision.
  - Nothing is inferred from a course's IELTS.

## 4. After merge

- **Merge and deploy:** admin #1336 (7003e154) merged first, then Pilot #1740 (2cae67b9). Deploy on merge succeeded at 07:59 AEDT, and migration `20261130233000` is applied.
- **Live read-back, 08:05 AEDT, through `website_v2_course` and `zoho_v2_course`:** both reads match the rehearsal for all five courses.
  - RMIT 077512F and 106623K: CAE 176 band 169; IELTS 6.5 band 6.0; PTE 58 band 50; TOEFL iBT 79 band 12.
  - Deakin 114205F, VU 092944A and VU 105139H: IELTS band 6.0.
- **Guardrails:**
  - G3: 75/48, no drift. Active cron jobs: 136.
  - Manual locks: 7,587. The migration's own check confirmed no lock changed; the +2 since 27 Nov are human Layer 4 approvals in other lanes.
- **Feedback status for the register owner:**
  - FB-6.C10-02, FB-6.C01-02, FB-6.C13-03, FB-6.C04-03 (092944A) and FB-4B.3-02 (105139H): verified corrected.
  - FB-6.C02-02: already correct.
  - FB-6.C06-03: held (CQU source exception).
