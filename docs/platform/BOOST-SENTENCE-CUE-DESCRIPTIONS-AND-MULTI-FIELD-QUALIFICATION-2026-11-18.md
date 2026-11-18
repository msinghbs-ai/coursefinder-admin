# Boost: the international-sentence cue, the 663 held course descriptions and multi-field qualification

**Session:** S2-BOOST-Courses (S2 - BOOST lane). **Read:** 18 Nov 2026, 17:30 to 18:00 AEDT, against the live Pilot.
**Request:** Platform Admin, 18 Nov 2026 17:02, items 1 to 3. **Pilot changes:** #1299 and #1301 (worker `coverage-sweep` v1.0.18, specs s660 and s663, no migration).

## Summary

| Item | Outcome |
|---|---|
| 1. Study load reader v6 from the international-sentence cue | **Not promoted.** The cue was inspected on the stored pages and is not clean: 35 of 41 pages gave a false match. Nothing was admitted. A corrected design is set out below |
| 2. The 663 held course descriptions | **Clustered by reason; no rule promoted yet.** A deterministic identity rule that would release up to 340 of the 448 is specified below. It changes the description admission function, so it needs a function migration that was not written in this session |
| 3. Qwen3 30B multi-field qualification | **Not qualified on any field.** Replay of 80 gold pages: intakes 50% agreement, fees 70%, on 12 and 10 verified answers. Descriptions pass the page check on 78% of pages but have no value to compare. Deadlines cannot be replayed (no deadline field in the prompt) |
| Platform changes that are live | Read-only sentence inspection (s660), page check `boost-fields-check-v2` and the replay tool (s663) |

G3 read at 17:59 AEDT: 75 functions and 48 relations, no drift. Live head `20261118210000` (2,134 applied); this session added no migration.

## 1. The international-sentence cue (s660)

**What was built.** Worker mode `boost_sentences` returns, for stored course pages, the sentences the study load reader takes as a statement for international students, with the load the page check requires for each. It calls no model and writes nothing. Workflow `boost-sentences-inspect.yml` runs it on demand (run 44251878109).

**What it showed.** 41 readings were settled Not stated although the page check found such a sentence (38 at 15:45, 41 by 17:30). All 41 pages were read.

| What the matched text is | Pages | A study load for international students? |
|---|---|---|
| Griffith: one unpunctuated block about the IELTS admission procedure (also one entry-requirement block and one GPA block) | 18 | No |
| ACAP: the page's navigation and duration panel in one block | 5 | No |
| Entry requirements naming international applicants (Lincoln 2, AIIHE, Charles Sturt, Acknowledge Education) | 5 | No |
| Charles Darwin: the "You may be interested in" list of other courses ("Not available to international students") | 3 | No, it is about other courses |
| Holmesglen: page markup left in the text | 2 | No |
| Wollongong: duration line run into the overview | 1 | No |
| Griffith: "This program is offered part-time online and is not available to international students on a student visa" | 1 | No. The reader inferred full-time; the sentence says the program is closed to them |
| Griffith: "Trimester 3 is part-time only and is not available to commencing International students" | 1 | Yes, full-time |
| Charles Darwin: "International 1.5 years full-time" inside the delivery table | 1 | Yes, full-time, but the block also holds the domestic line, so the check required Both |
| La Trobe handbook: "International onshore … Study mode: Full time" | 4 | Yes, but the block also holds the domestic line |

**Finding.** The stored page text often has no sentence punctuation, so a "sentence" is a block of 600 characters or more. Such a block passes the cue whenever it holds the word international, a study word and a rule word anywhere. 35 of the 41 are false matches and only 6 hold a real statement. Promoting the cue into the prompt would have made the model answer from these blocks.

**Corrected design for v6 (not built).**
1. The three signals must sit close together (within one clause, about 160 characters), not anywhere in a block.
2. A labelled line counts: "International" or "International onshore", then a duration or "Study mode", then full-time or part-time.
3. "Not available to international students" with no study load ruled out says the course is closed to them. It never implies the other load.
4. The text sent to the model for such a page is the clause, not the block.
5. Before promotion, run the candidate rule through `boost_sentences` over every settled reading and the readings already admitted on an international basis, and promote only if the admitted ones still match.

Promotion then needs the prompt version on the route rows moved from v5 to v6 and the 41 pages released for a re-read. Both are data changes in a migration, as for v2 to v5.

## 2. The 663 held course descriptions

The Layer 4 kind Descriptions holds 663 course descriptions waiting. Each has a description already written from its stored page. The machine rule (`security.course_description_machine_check_v1`) declined them for these reasons:

| Reason | Items | What it means |
|---|---|---|
| Identity margin thin | 448 | The page was found by an AI match (254), or by a title score less than 0.1 above the next page (163), or by a CRICOS code with a thin margin (31; for the 28 found by the code on the page, another course shares the address) |
| Binding ambiguous | 143 | The course has more than one candidate page |
| Refused word | 44 | accredited 22, innovative 7, tuition 5, leading 2, excellence 2, employability 2, and four single words |
| Evidence moved | 15 | The stored page changed after the description was written; the queue reads the new copy |
| Wrong page kind | 13 | The bound address is not a course page |

**The identity finding.** The margin rule looks at how the page was *found*. It ignores what the binder *proved* after reading the page. For the 448:

| Proof recorded after the read (`identity_basis`) | Items |
|---|---|
| The course's own CRICOS code is on the page | 161 |
| The course's own NZQA code is on the page | 9 |
| Exact title | 170 |
| Degree name | 58 |
| Title and level | 39 |
| Field and award, adapter title | 11 |

**Rule proposed (cdesc identity proof, not yet promoted).** The margin does not apply when the page's proof is the course's own CRICOS or NZQA code, or an exact title that no other active course of the provider shares, and no other course is bound to the same address or stored copy. This extends Decision 265, which already exempts a page *found* by its CRICOS code, and uses the proofs rule l4-link-accept-v1 accepts for official links. It would release up to 340 of the 448 to the unchanged wording checks. Degree name, title and level, and the other near matches (108) stay with a person.

**Why it was not promoted here.** The rule lives in a 20 KB database function whose current text is not in the repository (only the 10 Nov version is). Changing it safely needs the live definition captured byte for byte, a migration with an md5 pre-check, and a rolled-back live dry run. That is the next action for this lane.

**Wording.** The 44 refused words are claims, not spelling: "accredited" needs the accrediting body to be on the page. A normaliser that deletes the word would change the meaning, so none was added. The sound route is a re-read under the current prompt, which already forbids them.

## 3. Multi-field qualification of Qwen3 30B (s663, REQ-61, REQ-69, REQ-70)

**Page check `boost-fields-check-v2` (live).** Written from the first 3,300 answers:
- A description must be prose about the course. A title, a menu, a call to action ("Apply Now"), a video caption or raw markup is refused.
- A month counts as an intake only where the quote says the course starts then. A post date, an event, an application deadline, a term calendar or a calendar header is refused. Of the 43 intake answers check v1 had accepted, most were of these kinds.
- A fee needs its whole amount in the quote, its currency named by the quote (or by the page when the quote has a bare "$", and then only one currency), its period, and its year when one is given.

**Gold-set replay (run 44254128321, label replay-1).** The gold set comes from the catalogue: courses that already hold active intakes, an active provider-page annual fee or a description, and have a stored page. 80 pages, one call each, US$0.0168. Nothing was staged or admitted.

| Field | Pages holding a value | Verified | Refused | Agrees with the held value | Disagrees |
|---|---|---|---|---|---|
| Course description | 60 | 47 (78%) | 13 | not compared | not compared |
| Intakes | 40 | 12 | 28 | 6 | 6 |
| Tuition fee | 55 | 10 | 45 | 7 | 3 |
| Deadlines | not asked | | | | |

**Reading of the figures.**
- **Intakes: not qualified.** Half the verified answers differ from the held months. Several are real page statements ("Next intake: February, July") beside a held March start, so part of the gap is the difference between an intake and a teaching start date. That has to be settled with S2-Intakes before any comparison can pass.
- **Fees: not qualified.** Three of ten differ: two quoted a whole-course total beside a held annual fee, one quoted a domestic fee. The sample is too small either way.
- **Descriptions: not a candidate for admission as they stand.** The Boost answer is the page's own words. The description rule refuses copied sentences, so a quote can feed the description reader but cannot be the description.
- **Deadlines: no evidence.** The prompt has no deadline field and only 26 courses with a stored page hold a deadline.

**Live-admission activation spec for S2-Build (after the squash).** None of these is switched on by this document.
1. **One admission path per field, owned by the field's lane.** Boost candidates stay in `pipeline.boost_field_candidates` (`promotion_state` shadow). Each owner adds a rule that reads verified candidates of `check_version` `boost-fields-check-v2` or later and writes through its own admission function, only where the course holds no value (no overwrite), with source `boost` and the stored page as evidence. Conflicts and low-confidence rows go to Layer 4.
2. **Qualification rows.** `pipeline.boost_model_qualifications` gets one row per lane (`intakes`, `course_fees`), added by a migration that cites the replay run. The promotion function must refuse a lane with no row. The check version should be stored on the candidate row (a new column; today it is only in the Storage result file).
3. **Bar to qualify a field.** At least 100 verified gold answers, at least 95% agreeing with the held value on the same basis (annual with annual, international with international), and zero wrong-currency answers. Run `boost-fields-replay.yml` with `per_stratum` 120 and a new label.
4. **Before intakes can be measured:** agree with S2-Intakes whether the held `start_date` month or the page's stated intake month is the value.
5. **Deadlines:** add a `course_deadline` field to the prompt (new prompt version, route row moved), with a page check that requires the day, month and year in the quote and a deadline word beside them, then replay against the 26 held deadlines and the intake calendar.
6. **Fees:** the scoring should compare like with like; add the fee basis to the gold query before the next run.

## Evidence

| What | Where |
|---|---|
| Sentence inspection, 41 pages | Pilot Actions run 44251878109 (artifact `boost-sentences`) |
| Replay, 80 pages | Pilot Actions run 44254128321 (artifact `boost-fields-replay`); first attempt 44252085329 stopped on a slow answer and led to #1301 |
| Worker deployed | Deploy on merge run 44251752170; mode ledger shows `coverage-sweep-worker-v1.0.18` for both new modes |
| Unchanged | Route rows (study load v5, fields v1), the single admission qualification (Qwen3 30B, study load), 0 field candidates out of shadow |

## Follow-up, 18 Nov 2026 22:20 AEDT (S1-Courses, s662 and s664)

The identity rule proposed in section 2 is built in Pilot #1314 (migration `20261118253000`), extended by the Platform Admin's 21:08 directive: a 1 to 2 sentence reader (prompt v4), the first-description hold switched off, and a plain-English Layer 4 card with four decisions. Live read at 21:15: 666 waiting, 451 on the identity margin (CRICOS 161, NZQA 9, exact title 172 would be proved). In the rolled-back dry run, 249 of the 451 pass identity and fall to the new 2-sentence limit, so they are superseded and read again with v4; 3 pass outright. The 44 refused words are left to the v4 re-read, as section 2 recommended. Items 1 and 3 continue in Pilot #1316 (s661, s665).
