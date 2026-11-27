# S1-Data-Gaps: VU feedback and source integrity, and Batch 08 identity check (28 Nov 2026, as at 07:48 AEDT)

**Brief:** SS-Programme-Control, Sat 28 Nov 2026 07:06 AEDT, "Resolve reported feedback and source integrity defects". **Lane:** S1-Data-Gaps. **Change made:** none to Pilot, settings, jobs or data. **Spend:** US$0. All reads were rolled-back reads. Official provider pages were not read in this session (the approval request for a read was not answered), so no official amount or date below comes from this session; DOT's evidence in the register is quoted as DOT's.

## 1. What was found (live, read only)

| Item | Finding |
|---|---|
| VU Bachelor of Business 092944A (Melbourne) | Website API shows four intakes as months only (February, April, July, September), "course page not verified". January is withdrawn and is not served (kept). Annual fee 2026 AUD 36,800 (provider current) and registered total 116,175 are served. |
| Cause (092944A intake) | The course's own page `/courses/bachelor-of-business-bbns/international` is bound and read on its CRICOS code, but the course page check refuses it as a shared page. The setting `binding.shared_page_patterns` holds `/international(-students?)?/?$`, which matches the end of this address. The page names the course (title and level match). With the page not proved, the intake reader stops with `course_identity_unresolved` and the next try is 11 Dec 2026. The course's links are already locked by a person (`course_url`, `official_url`). |
| Reach of the cause | 220 read AU pages of the form `/<slug>/international` are refused this way. 103 are Victoria University. The others are mostly schools, one to six each. |
| VU EBCL 115486F (Sydney City Centre, Brisbane) | Page proved (`identity_proof`, pass). No provider fee row. Website API shows the CRICOS registered total AUD 135,200 and a derived annual AUD 33,800 with no year, labelled derived. The Melbourne EBCL 105139H amounts (2026 33,800; 2027 35,500) were not copied. DOT's evidence (register FB-4B.3-01) gives 2026 AUD 16,900 per semester on the campus pages, so the derived figure agrees with the official 2026 annual equivalent. Intake: months only; calendar reader `calendar_interpretation_failed`, revisit 11 Dec 2026. |
| VU 092820B (Brisbane and Sydney City Centre) | January and July intakes withdrawn, none active. Not changed. |
| Campus association | 092944A lists Footscray Park and City Campus (City Tower). DOT's evidence says the 2027 guide binds Melbourne City to 092944A. The Footscray Park link is unproven. Not changed. |
| Batch 08 (UNE, TAFE Queensland) identity | The s1327 sources are registered, qualified and active on the right providers: University of New England `fa0e0d13-838a-42ff-b6a3-9cea84bd80b2` (website une.edu.au, 130 active courses) and TAFE Queensland `bf68c5a3-77c4-4ab8-8c84-6d99e435b1f5` (tafeqld.edu.au, 97 active). The look-alikes New England Institute of Technology Pty Ltd and New England School of English share nec.edu.au and are separate providers; the migration names provider ids, so they cannot be picked. No duplicate or missing course codes in either provider. |
| Batch 08 state | Not applied yet: UNE plus TAFE Queensland still hold 870 active fees and 348 active intakes, as at the baseline. Dated proposal `c914b027` still waits for a person (S1-Build's record). |

## 2. Decision S1-DG-8 (Platform Admin)

Add one provider-scoped line to the existing approved-exceptions setting `binding.identity_exceptions`, as the setting's own description requires a Platform Admin decision:

`bac82321-ded7-4e10-a71d-b18f3ae4d1c7|shared_page|/courses/[^/]+/international/?$` (Victoria University only).

Rehearsed rolled back: 102 of 103 VU pages pass as `exception_shared_page` (the exception still requires the page to name the course); 1 stays refused as a genuinely shared page; 092944A becomes proved. Impact: the existing intake, fee, English and academic entry readers can read those 102 VU courses; DOT's four 2027 dates for 092944A (15 February, 26 April, 26 July, 27 September, from the course page) can then go through the existing intake path. Consumer API: no change until a value is admitted. Risk: low, VU only, the page must still name the course, and every admission rule is unchanged. Rollback: remove the line.

## 3. Handed over (no competing writer)

| To | What |
|---|---|
| S1-RM-Design | Admit 115486F 2026 AUD 16,900 per semester (annual equivalent 33,800 with full-time proof) through the existing fee mechanism, with campus and year. Do not copy 105139H. |
| S2-Intakes | The four 2027 dates for 092944A after S1-DG-8; 092820B has no active intakes; 115486F months only. |
| S1-Build | Batch 08 apply run; the other 219 pages of the same form need their own provider decisions if wanted. |
| Platform Admin | S1-DG-8; the 33 Newcastle scholarship items (28 Nov review pack); S1-DG-7. |

## 4. Feedback records

Owner notes and last reviewed date were updated by tracking ID in the register for FB-4A.8-01, FB-4B.3-01 and FB-6.C04-01 (28 Nov 07:48 AEDT). No item was marked resolved: nothing is verified on the consumers yet.
