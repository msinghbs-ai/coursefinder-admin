# S2-Courses: study load cue guard (s661) and fee-basis replay (s665), 18 Nov 2026

**Chat:** S2-Courses (reserved spec block s661 to s669). **Request:** Platform Admin 18 Nov 2026 21:59 (four items: s661 study load guard, s662 description reader and identity exemption, s664 Layer 4 explanations and buttons, s665 fee-basis replay).
**Pilot:** #1316 and #1319, both merged on green CI and deployed. Worker `coverage-sweep` v1.0.22. No migration. G3 read 18 Nov 2026 22:52 AEDT: 75 functions, 48 relations, no drift. Live head `20261118256000` (2,144 applied).

## 1. What was asked and where each item stands

| Item | Status |
|---|---|
| s661 Study load reader guard | Built and live (Pilot #1316, #1319). Not promoted for re-reading or admission: see section 2. |
| s662 1 to 2 sentence description reader and identity-proof exemption | Not built in this chat. Already open as Pilot #1314 from the session labelled S1-Courses (same s660 to s669 block, opened 21:37 AEDT): prompt `cdesc-source-grounded-v4`, `cdesc-machine-v2` identity proof, migration `20261118253000`. Reviewed against the directive in section 4. |
| s664 Layer 4 course description explanations and four buttons | Same: in #1314 (release v2.16.44). |
| s665 Fee-basis replay | Built and run (section 3). Qwen3 30B is still not qualified on any new field. |

## 2. s661: the international cue, now close together and never a closure

**What was wrong (from the 41 pages settled "Not stated"):** the cue was "an international word, a study word and a rule word anywhere in one sentence". Stored page text often has no sentence punctuation, so a "sentence" was a block of 600 characters or more. And a course closed to international students was read as a load rule: Griffith's "This program is offered part-time online and is not available to international students on a student visa" gave full-time.

**What changed (`boost.ts`, selectors `study-load-windows-v5` and `study-load-international-v2`):**
1. **No inference from a closure.** A sentence that only says the course is not available to international students is never a study load statement (`internationalClosure`). The opposite load is inferred only when the ruled-out load is itself the subject joined by a verb of being ("Part-time study is not available for international students", within 40 characters, no "and", "offered" or "online" between).
2. **Proximity.** An international word and a study word must lie within 80 characters (`INTL_NEAR`), or the line is labelled ("International students: ...", with the study word within 160 characters of the label).
3. **Which words count as international (v1.0.22, after the first live inspection).** Words that name the student: international students, applicants, onshore, offshore, learners; "International" followed by a duration; overseas students; student visa; visa holders; non-visa; onshore. A CRICOS code (printed on every page) and course titles ("International Exchange", "Master of International Business") no longer make a sentence one about international students.
4. **The prompt text and version are unchanged (`boost-study-load-v5`).** The route's qualification row is bound to the prompt version by a migration (`pipeline.ai_route_qualifications`), which this item does not make. The model only ever sees the sentences the selector sends, so the deterministic fix is where the rule lives.

**Live inspection** (`boost-sentences-inspect.yml`, read only, no model; scope international-not-stated, 62 readings, run 44294262439 then 44297711567):

| | Matched the cue |
|---|---|
| Before (worker v1.0.18, all signals anywhere in a block) | 41 pages (35 of them false) |
| After v1.0.21 (proximity and closure) | 24 of 62 |
| After v1.0.22 (words that name the student) | 18 of 62 |

Cleared by the guard: all Griffith IELTS and entry-requirement blocks, ACAP navigation, Charles Darwin's "other courses" list, Lincoln, AIIHE, Cordon Bleu, the Griffith closures, UOW and UWA (CRICOS code), Acknowledge Education and CSU (entry requirements), CDU's "International Exchange" lines.

**The 18 still matching (classified by hand):** Monash on-campus notes (5, labelled "only available to international students in on-campus mode" beside "On-campus: Full time"), CDU Certificate IV (1, real: "International 1.5 years full-time"), Flinders handbook (1, "Study load: Full time only ... Onshore international"), KOIC (1), La Trobe handbook (4), Monash B6014 (1), VIT (3, "(only available for non-Visa students)"), Holmesglen (1, page markup), Dance Factory (1, page heading). About 8 are real statements.

**Not promoted, nothing admitted, no page released for re-reading.** One problem remains: where one unpunctuated block holds both a Domestic line and an International line (CDU, La Trobe, VIT), the page check requires the load of the whole block (here "both"), not of the International line. The next change is to split a block at its labels and send only the International-labelled segment. Releasing pages for a re-read also needs a database change (a migration) that this item does not make. No study load was admitted.

## 3. s665: fee basis aligned, and the replay re-scored

**Gold set fix (`scripts/boost-fields-replay.mjs`):** fees are compared by basis. A page "year" fee is compared with held annual fees (basis `annual`, `indicative_annual`, `current indicative annual international tuition`); a page "total" with held whole-course totals (provider `total_indicative`, and the registered `tuition` and `estimated_total_course_cost`, because a page's "Total course cost" includes non-tuition fees). Another period (semester, credit point, unit) and a domestic answer are not compared. A new stratum draws pages of courses whose provider states a whole-course total (16 such pages exist). Intake answers that list every held month and more are counted separately.

**Result, run 44297706134 (label s665-2, 225 stored pages, worker v1.0.22, US$0.0458, nothing staged or admitted):**

| Field | Pages holding a value | Verified | Refused | Not stated | Verified and agrees | Disagrees |
|---|---|---|---|---|---|---|
| Descriptions | 172 | 119 | 53 | 0 | not compared | not compared |
| Intakes | 73 | 18 | 55 | 0 | 10 (9 exact) | 8 |
| Fees | 224 | 15 | 194 | 15 | 9 | 4 |

| Fee basis | Agrees | Disagrees | Agreement |
|---|---|---|---|
| Annual (period year) | 6 | 0 | 100% (6 answers) |
| Whole-course total | 3 | 4 | 43% |

The earlier run before the total basis was corrected (run 44291557724, 227 pages) scored whole-course totals 2 of 13, because a page's "Total course cost" was compared with tuition-only registered totals; that was a gold set fault, not the model.

**Reading:** annual fees agree on every verified answer but only 6 were verified, far below the bar (at least 100 verified gold answers, 95% agreement, no wrong currency). Whole-course totals are 3 of 7 and the disagreements are real differences between a page total and the held figure (for example "Course Fees Total AUD 16,000" against held 20,000 and 21,000). Intakes: 3 of the 8 disagreements list every held month and more (the page says "Start in March, July, November" where the held value is March), which is the S2-Intakes question below. **Qwen3 30B is not qualified for fees, intakes or descriptions; deadlines still have no field in the prompt.**

## 4. s662 and s664: Pilot #1314 against the directive

Read from the open PR (CI green except the baseline checks still running at 22:55 AEDT; not touched):
- 1 to 2 sentences, 180 to 360 characters, no intake dates, addresses, fees or duration, per-sentence quote grounding: prompt `cdesc-source-grounded-v4`, settings max sentences 4 to 2 and max characters 700 to 360.
- Exemption: the 0.1 margin is waived when the page proves the course by its own CRICOS or NZQA code, or an unshared exact title, and no other course of the provider shares the page. The edit to `security.course_description_machine_check_v1(uuid)` is guarded by the md5 of the live body before and after; no new function or table (G3 stays 75 and 48).
- Layer 4: plain-English "Why this is held" for each reason, and the four choices Approve as read, Re-read (1-2 sentences), Approve all verified for provider (the person types the count first) and Reject (bad page / wrong course).
- Migration `20261118253000` is below the live head `20261118256000` (a separate S1-RM-Design migration merged after it was numbered). Its owner needs to renumber it above `20261118256000` before it merges, and it must not merge during Thursday 01:15 to 03:30 AEDT.

## 5. S2-Intakes priority question (recorded in `docs/CURRENT-STATE.md`)

Is the course intake we hold the **next intake** the page announces ("Next intake: February, July"), or the **main annual start** ("Start in March")? In the replay the held value is often the main start and the page lists several more months, or a single next intake that differs from it. Until S2-Intakes defines the field, Boost cannot score intake answers and no intake is admitted from a page.

## 6. Open work

1. Split a page block at its Domestic and International labels for the study load cue; then validate against all settled and admitted readings before any release for re-reading (needs a migration for the release).
2. Fee, intake and description qualification stays closed; a larger replay needs the intake definition, a deadline field (new prompt version) and a route qualification row (a migration).
3. The activation specification for S2-Build in `BOOST-SENTENCE-CUE-DESCRIPTIONS-AND-MULTI-FIELD-QUALIFICATION-2026-11-18.md` still applies unchanged.
