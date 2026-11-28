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

## 5. Instruction PC-20261128-0931-S1-ELR (s1336, Pilot #1743)

The instruction was acknowledged at 09:55 AEDT, 28 Nov 2026. The S1-ELR chat document in Drive is read-only to this account, so this record is the outcome.

| Item | Outcome |
|---|---|
| Swinburne Bachelor of Business 063366D, 088382J | **Corrected.** The official "Undergraduate: other bachelor degrees" row adds PTE 50 (50), TOEFL iBT 64 (R13 L12 S18 W21) and CAE 169 (169), insert only. The stored central reading was misaligned (PTE 66) and was not used |
| VU 115486F | **Corrected.** IELTS band 6.0 added; the course page names both 105139H and 115486F. No PTE is stated on the page, so none is added |
| VU 092820B | **Verified.** IELTS 6.0 with 6.0 bands from its own course page (CF-245); Website and Zoho return band 6 |
| Adelaide College | **Held: identity.** Provider record 03127E has "Diploma of Business" 113489H and 069094G; no "Diploma in Business Studies" |
| CQU 084516K | **Held** with S1-Build for the backend course-page re-fetch |

- **s1336 live (10:50 AEDT):** Pilot #1751 (9457b2ff). Website and Zoho return the Swinburne PTE, TOEFL and CAE rows and the VU 115486F band.

## 6. TIWA institutional English (s1346, Pilot #1755)

Instructions: PC-20261128-TIWA-INSTITUTION-S1-ELR, PC-20261128-1050-S1-ELR and PC-20261128-DOT-STORAGE-IMPLEMENT-S1-ELR (acknowledged 28 Nov 2026 11:55 AEDT).

**Source.** The TIWA admission requirements page, tafeinternational.wa.edu.au/tafe-courses/tafe-admission-requirements, last updated 9 Sep 2026.
- DOT captured it on 27 Nov 2026 in package `DOT-TIWA-00020G-Institutional-Coverage-IN_PROGRESS.zip`, file `adm.raw`, sha256 `80b2fa34…7c9c83`.
- It is the same page as TIWA's approved English policy `e53f450b` (stored copy `ba83a96a`, 2 Oct 2026).
- I read DOT's stored bytes, so no new fetch was made and nothing was spent.

**Live before (rolled back, 28 Nov 12:30 AEDT).** TIWA has 102 active courses, 88 with English:
- 76 hold IELTS 6.0 with every band 5.0;
- 5 Early Childhood and maritime courses hold the bands from their own course pages;
- 4 rows hold an IELTS overall with no band minimum (the change below);
- 14 courses have no stored course page and no English.

**Existing route found.** Structured intake does not take English (as PC-1050 says). The routes that do are:
- the course rows themselves, for exact corrections from official evidence (as in s1330 and s1336);
- the central English policy, approved by a person in Universities › English.

**Corrected by s1346** (overall unchanged, guarded, insert nothing):

| Course | Row | Before | After | Page words |
|---|---|---|---|---|
| Diploma of Nursing 111837J | `61986991` | IELTS 7.0, no bands | L 7.0, R 7.0, S 7.0, W 6.5 | "Nursing: IELTS 7.0 (Academic) with no band below 7.0, excluding writing where the minimum is 6.5" |
| Certificate IV in Business 107276E | `0321767a` | IELTS 6.0, no bands | 5.0 each | "…Academic IELTS 6.0, with no band lower than 5.0" |
| Certificate IV in Electronics and Communications 119536B | `7a026fca` | IELTS 6.0, no bands | 5.0 each | same |
| Certificate III in Carpentry 121507M | `cd920ac5` | IELTS 6.0, no bands | 5.0 each | same |

All four courses are unpublished. The Website and Zoho show nothing for them until they are published, and no publication is forced.

**Held, with the reason and the next owner:**
- **Proposal `08e66434` (elr-central, in the 55-reading pack):** a person should not approve it as it stands.
  - It would give the 14 gap courses IELTS 6.0 with no band minimum.
  - Its Nursing exception reads 6.5 in every band, which is not what the page prints.
  - The approved policy `e53f450b` has the same misreading for Nursing. It never wrote a row.
  - Suggested decision: reject `08e66434` and keep `e53f450b`. The Nursing row is now corrected directly.
- **The 14 courses with no stored course page** (0100606, 103577B, 103797A, 105801E, 108207K, 108208J, 108215K, 108216J, 108218G, 108219F, 109073M, 111989D, 116643A, 117119B):
  - The page says "some courses may require a higher level", so the standard level is not applied without each course's own page.
  - Next: S1-Build's coverage sweep reads the course pages (Tier 1, $0). The course rows then come through the normal route.
- **Certificate IV in Preparation for Health and Nursing Studies 111816C:** its own course page gives IELTS 7.0. The page's "Nursing" line does not name the course, so no band is added.
- **The equivalent tests for IELTS 6.0 with no band below 5.0** would reach the 79 standard-level courses:
  - PTE Academic 50, no band below 42;
  - TOEFL iBT 67 with Listening 8, Reading 8, Speaking 14, Writing 9 for tests before 26 Jan 2026, and 4 on the new scale after;
  - Cambridge 161;
  - LanguageCert, MET, Duolingo and others are not in `ref.english_tests`.

  The approved policy carries IELTS only. The policy-add-tests job is off and read none of these on 17 Oct, so adding them is a person's decision (Platform Admin), not something done here. TOEFL's two scales cannot be shown as one number without the date condition.
- **CELPIP and OET:** CELPIP overall 161 next to bands of 5 stays quarantined. OET "1210" is outside OET's scale, so it is not read.
- **Nursing PTE 66 and TOEFL iBT 94:** left as they are. The page gives no Nursing equivalents.
