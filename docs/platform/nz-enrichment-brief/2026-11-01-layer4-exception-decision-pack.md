# Layer 4 exceptions: consolidated decision pack (1 Nov 2026)

**Requested by:** Platform Admin direction, 1 Nov 2026 13:52 ("prepare one decision pack … exact scope, affected refs, supporting evidence, expected downstream impact, cost ceiling where relevant and rollback requirements"). Batch L4B-20261101-1253 (checkpoints 1–3 in `2026-11-01-layer4-batch-L4B-1253.md`).

**Status:** prepared, nothing decided. This pack does not approve any merger, new source acquisition, paid AI or Firecrawl activity, or policy change. Every decision below is the Platform Admin's.

**Figures:** live database, 1 Nov 2026 about 14:15 AEDT (live pending 1,821).

## Summary

| # | Exception | Items | What is needed | Recommended | Spend |
|---|---|---:|---|---|---|
| E1 | Fees admitted by mistake on 30 Oct (re-verified 1 Nov 20:20) | 46 | Withdraw 41 (not supported by the stored copy), keep 5 | Run `PASTE-20261101-e1-fee-withdrawal.sql` (count-guarded, not run) | None |
| E2 | UniSA and Adelaide left the register | 2 | Merger authority | Record as merged into Adelaide University | None |
| E3 | Stamford, Nova, St Peters, Asia Pacific, "N/A" | 5 | Successor or closure, provider by provider | Closed, unless a successor is named | None |
| E4 | Onboarding kinds | 547 | A route per kind | Name a pilot budget, or mark "CRICOS data only" | Ceiling set by PA |
| E5 | Held scholarships with no quotes | 118 | Re-check them, refuse them or leave them | Leave held until a quote exists | Only if re-checked |
| E6 | Held scholarships already published | 4 | A way to close a duplicate | Build a "duplicate" close route | None |
| E7 | Aggregator copies attached to the wrong provider | 21 (10 also in E5) | Identity decision | Refuse as not this provider's scholarship | None |
| E8 | Griffith eligibility and a misleading re-check | 2 | Rule correction | Fix the re-check; decide on the 2 by hand | None |
| E9 | ANU entry-score reads | 22 | Interpretation | Reject the reads; build an ANU rank rule | None |
| E10 | Fee checks needing a policy | 28 | Rule for single-rate and per-discipline schedules | See E10 | None |
| E11 | RMIT entry reads from the local-student view | 298 | Reject and re-read from the international view, or wait | Store the international view, then re-read | Reader credits; ceiling set by PA |
| E12 | QUT entry reads: domestic and international rows, every read at the 6-row cap | 38 | Reject and re-read the international view with a reviewed row cap, or leave pending | Re-read (assessed 1 Nov 19:55: approve-except is not supported) | Reader credits; ceiling set by PA |
| E13 | Course entry reads cut at 6 rows (`entry.max_rows_per_course`) | 225 reads dropped 3,189 rows; 53 of the 59 capped approvals dropped 287 | Configurable cap plus a whole-read completeness gate (tests first) | Approve the design; no paid re-read now | None until a re-read |
| E14 | **Approvals of 1 Nov that need correcting** (this session): rows of a sibling programme variant, or a dropped "and"/"plus" condition | 18 items | Withdraw their rows and re-review, or keep with a flag | Withdraw (paste file to follow), then re-review after E13 | None to withdraw; reader credits for re-reads |

## E1. Fees admitted when the reviewer asked for a re-read (new, found 1 Nov 14:05)

**Scope:**
- 46 Course link fee-check items (field `provider_current_tuition_validation`) decided with **Enter another address** in batch L4B-20261030-0816 (30 Oct 08:57–08:59, audit #25776–25821, actor the Platform Admin account).
- Each reason says the reviewer entered the course's page "so the read-again path re-reads the current fee".

**What happened:**
- `security.layer4_tuition_apply_impl` treats a non-object value as a plain Approve, so it admitted the item's proposed fee instead.
- The fee reader had flagged every one of these fees as "outside the usual range or an old fee year".
- Each wrote one active row in `catalogue.course_fees` (notes "CF-247 Layer 4 human decision; review item …").
- No page was re-read and no course link changed.

**Evidence:** all 46 rows are active (query in batch checkpoint 3). Examples:

| Ref | Provider | Course | Fee admitted |
|---|---|---|---|
| 0fd93c5f | College of the Rockies | Associate of Arts | CAD 504.93, 2026, indicative annual |
| b38bc734 | Milestones English Academy | 092102K | AUD 290, no year |
| 12931ae7 | Stott's | 096281C | AUD 825, 2025 |
| fb66b5c1 | Employment Focus | 2540 | NZD 14,000, **2024** |
| e291efce | NZ College of Chinese Medicine | 4103 | NZD 32,997, **2024** |
| International College of Management (14 courses) | | | AUD 1,449–9,900, 2027 |
| AIBI (8 courses) | | | AUD 2,112–2,700, 2026 |

**Already fixed (v2.15.394):**
- An address on a fee check is refused.
- The card shows the proposed fee and offers **Admit this fee** or **Do not admit this fee**.

**Options:**
- (a) **Withdraw (recommended).** Set the 46 rows to `inactive`, count-guarded on the 46 ids. Then re-check each item against its stored copy, one at a time, with the same rules as checkpoint 3.
- (b) Keep them, and check each against its stored copy before deciding.

**Downstream impact of (a):**
- The 46 courses lose these fees on the website until a checked fee is admitted.
- 1 of the 46 courses (4f2cbdda) holds a second active fee.

**Note:** 10 of the proposals printed no fee year, yet the stored rows carry fee year 2026. A year was filled in that the page did not state.

**Rollback:** set the same 46 ids back to `active`.
- The ids are in `docs/platform/ui-audit/e1-fee-check-admissions-2026-10-30.csv` (md5 of the sorted fee ids `9cc197a3`).
- A withdrawal would be count-guarded on 46 and on that md5.
- Nothing is deleted.

**Cost:** none.


### E1 re-verification (1 Nov 2026, 20:12–20:20 AEDT; direction 20:08 §2)

**Current state (live):**
- All 46 rows are still `active`; none has been superseded.
- The md5 of the sorted ids is still `9cc197a3…`.
- Each row's evidence id equals its review item's evidence.

**Fee year:** 10 rows were changed on 31 Oct at 14:27 AEDT. Each now carries the note "Rule 3 (8 Oct 2026): no year on the page; evidence captured in 2026, so aligned to 2026 without review" (`security.l4_rule_fee_year_align_v1`). The year was set by that approved rule, not by the 30 Oct decisions. The note above ("a year was filled in") is explained by it.

**Consumer impact:**
- The website and Zoho course detail (`website_v2_course`, `zoho_v2_course` → `tuition_history`) returns every active international or "all" tuition row. All 46 are returned, and all 46 courses are in `search.course_documents`.
- 30 of the 46 are also the list-level "annual tuition" (`provider_annual_tuition_amount`).
- 39 of the 46 courses also carry a CRICOS registered total-course fee or another admitted fee. That fee stays.

**Evidence check:** each amount was searched on the item's own stored copy, with and without thousands separators. Per-row results are in `ui-audit/e1-fee-check-admissions-2026-10-30.csv` (columns `verdict_2026_11_01`, `evidence_check`).

| Finding | Rows | Verdict |
|---|---:|---|
| Amount printed, basis and year consistent (ACTS NZD 7,500; NZCCM English NZD 8,630 for 2027; Future Skills NZD 7,196 a year) | 3 | Keep |
| Amount printed per year, but the stored year is 2024 while the page also shows 2025 and 2026 (NZCCM Master NZD 32,997) | 1 | Keep; re-check the year at the next fee read |
| Amount printed, but the basis is not stated as annual (Employment Focus NZD 14,000, enrolment information dated Nov 2024) | 1 | Keep; re-check the basis |
| Amount not printed on the stored copy (AIBI 9, ICM 15, Stott's 3, VIT 3, University of Canberra, ACA, Open Colleges, College of the Rockies, Australasia) | 35 | Withdraw |
| Wrong basis: per subject (SAHE 2), per trimester (ICM AU$9,900), per week (Milestones AUD 290), a two-month special-offer price (Kalandra NZD 5,000) | 5 | Withdraw |
| Year mismatch: Year 1 tuition printed for 2025/26, stored as 2027 (Selkirk CAD 3,770) | 1 | Withdraw |

**Revised option (a), recommended:**
- Withdraw **41** rows (status `inactive`, with a note) and keep 5. Nothing is deleted.
- Paste file: `PASTE-20261101-e1-fee-withdrawal.sql`; rollback: `PASTE-20261101-e1-fee-withdrawal-rollback.sql`.
- Count guards: 41 ids, md5 `3a9fd3758f1e4f989425478265f68618`, all still active with the 30 Oct note, exactly 41 updated. The guards pass read-only (20:20). The file was **not run**.

**After withdrawal:**
- 38 of the 41 courses keep their CRICOS registered total-course fee.
- 3 courses show no tuition until a checked fee is admitted: Selkirk, Kalandra and College of the Rockies.
- A search refresh is requested in the same transaction, so the list-level fee follows.
- Each withdrawn course's fee is then re-read through the normal fee path. That needs no new decision, but it costs reader credits only if a re-read is started.


## E2. UniSA and the University of Adelaide (merger authority)

**Scope:** provider_departure refs 5 (UniSA, 344 courses, 0 active) and 8 (University of Adelaide, 341 courses, 0 active).

**Evidence:**
- Every registered course has left the CRICOS register.
- A provider "Adelaide University" (`de2201a1`) holds 498 active courses.
- The merger formed Adelaide University from 2026, but this is general knowledge and is not yet recorded as a stored source in the platform.

**Choice:** **Merged** (archived, merger recorded with successor Adelaide University) or **Closed**.

**Downstream impact:**
- Both former providers are archived and hidden from the consumer API. Their courses are already inactive, so nothing the website shows changes.
- The successor link lets later reporting follow the history.

**Rollback:**
- The archive goes through the clean-up workflow, which is reversible: unarchive.
- The merger record is one row.

**Cost:** none.

**Needs:** explicit Platform Admin approval to record a merger (the 13:52 direction excludes it).

## E3. Stamford, Nova, St Peters, Asia Pacific and "N/A" (identity or successor)

| Ref | Provider | Courses (active) | Possible successor in catalogue | Evidence held |
|---|---|---|---|---|
| 2 | Stamford International College Pty Ltd | 1 (0) | "STAMFORD COLLEGE" (`19028f30`, 8 active). Same name stem; no register link proves it. | Register departure only |
| 40 | Nova Institute of Technology | 16 (0) | none found | Register departure only |
| 36 | St Peters International College | 6 (0) | none ("St Peters Lutheran College" is a different school) | Register departure only |
| 3 | Asia Pacific Institute of Technology | 4 (0) | none found | Register departure only |
| 4 | "N/A" (`5cb730d1`) | 1 (0) | a second "N/A" provider (`083dab09`, 4 active) | Name missing in the register load |

**Choice per provider:**
- **Closed**: archived and hidden; nothing visible changes, because the courses are already inactive.
- **Merged**, with a successor the Platform Admin names.
- **Reviewed**: left as it is.

**Recommended:**
- **Closed** for Nova, St Peters and Asia Pacific.
- Stamford: Closed, unless the Platform Admin confirms STAMFORD COLLEGE as the successor.
- "N/A" (4): Reviewed, and raised as a register-load data defect, because a provider without a name should not exist.

**Rollback:** unarchive. **Cost:** none.

## E4. The 547 onboarding items

| Kind | Items | Providers | Oldest | Existing routes |
|---|---:|---:|---|---|
| Adapter has nothing ready | 316 | 316 | 12 Oct | fix a pattern; rebuild (AI); CRICOS data only |
| Too few course pages | 130 | 130 | 12 Oct | add pages; CRICOS data only |
| Course pages not found | 54 | 54 | 19 Oct | map the website again (Firecrawl); add pages; release; CRICOS data only |
| Website needed | 41 | 41 | 12 Oct | enter a website (onboarding restarts); CRICOS data only; archive |
| Adapter proposal failed | 1 | 1 | 30 Oct | retry; builder |
| First run: no page published | 55 | 55 | 30 Oct | sample check by a person (no spend) |
| First run: conjoint rule | 5 | 5 | 30 Oct | sample check by a person (no spend) |

The first-run items (60) need no spend. They are being worked in this batch as "other kinds with eligible stored evidence".

The other 542 can each be closed only by AI rebuild, Firecrawl mapping, new source acquisition, or a "CRICOS data only" policy.

**Options:**
- (a) **CRICOS data only** for all 542. They keep register data, the website shows them without enriched fields, and the cost is nil. This is a policy decision.
- (b) **Pilot rebuild:** 20 providers from "nothing ready", chosen by course count. Measure the cost per provider and the admitted fields, then decide the rest.
  - The cost per rebuild has not been measured from history, so the ceiling is the Platform Admin's.
  - The pilot reports its measured cost before any second wave.
- (c) Leave as they are.

**Recommended:** (b) with a ceiling the Platform Admin names; (a) for the remainder after the pilot result.

**Rollback:** (a) is undone by the same choice reversed (CRICOS-only is a label). (b) admits only through Qualify, and admissions are reversible per field.

## E5. 118 held scholarships with no usable quote

**Scope:** 118 items across 49 providers. Ids:
1172–1175, 1287, 1323, 1328, 1337, 1351, 1352, 1377, 1379, 1380, 1427–1429, 1454, 1455, 1487, 1580, 1583, 1596, 1597, 1601, 1614, 1692, 1699, 1701, 1703, 1749–1751, 1762, 1782–1784, 1797–1799, 1801, 1805, 1851, 1871, 1879–1883, 1890–1892, 1894, 1897, 1918–1923, 1946, 1948–1952, 1974, 1975, 1979, 1980, 2024, 2025, 2114, 2120, 2125–2127, 2143, 2157, 2162, 2164, 2165, 2169–2179, 2203–2207, 2210–2220, 2232–2234, 2242–2246, 2248, 2249.

**Evidence:**
- The AI re-check holds neither an audience quote nor a value quote.
- The publish rule needs a quote to say the scholarship is for international students.
- The direction says not to infer a missing quote.

**Options:**
- (a) **Leave held (recommended).** They stay off the website. No cost.
- (b) Re-check with AI. The cost is per item; a ceiling is needed.
- (c) Refuse as "not international" in bulk. **Not recommended:** there is no evidence either way, and Layer 4 decisions are one at a time.

**Downstream:** none for (a).

## E6. Held scholarships already published (4)

**Scope:** 1184, 1970, 1972, 1973. The same page and value are already a published scholarship.

**Gap:** Layer 4 has no "duplicate of a published scholarship" close. Both refusal choices would record a false reason.

**Recommended:** build the close route (engineering, SS-016 UR-06 family); no data change before then.

**Cost:** none.

## E7. Aggregator copies attached to the wrong provider (21)

**Scope:** Study Melbourne and Study Queensland copies of other institutions' scholarships, attached to colleges that do not offer them. Checkpoint 2 counted 10 of these, the ones with quotes.

Measured now, 21 held items come from aggregator pages:
- Lexis TESOL: 1172–1175, 1851, 1854, 1855, 1859, 1867;
- Prime Education: 1176, 1177, 1287;
- Marriott Academy: 1861, 1868, 1869, 1881, 1882;
- Kangaroo International College: 1889, 1893, 1894;
- Victorian Skills: 1897.

10 of these 21 are also in E5 (no quote). The decision covers all 21.

**Evidence:** the page is an aggregator. The scholarship names another institution.

**Choice:** **Not a scholarship** (refused for this provider). **Recommended**, because a wrong-provider scholarship must not be published.

**Downstream:** none visible (held). **Rollback:** the refusal is per page copy; a new copy asks again.

## E8. Griffith eligibility and the misleading re-check

**Scope:** 1970 and 1972 (also in E6).

**Evidence:** the AI re-check says "audience not stated", but the stored quote names non-Australian citizens.

**Recommended:**
- Correct the re-check rule (engineering).
- Decide these 2 by hand after E6.
- Do not refuse from the re-check.

## E9. ANU entry-score reads (22)

**Scope:** AER refs 11e999c9, c5dbff45, 7e5bcc2e, a8f7825c, 4effa6fd, d7eedd9f, 726b51d7, d01d7b4f, 36a9abd7, 7e66129d, daae933c, e278c754, cad93a9a, 02bc7d80, b79ab7db, 2d021379, ea9d17c9, e537afa9, e615509e, 4f6d54ad, 987dac71, 2b491c25 (28–29 Oct).

**Evidence:** the entry matrix read reverses rank and score columns. 0 rows are active.

**Recommended:**
- **Reject the read** for all 22, one at a time: nothing is admitted and the bad interpretation is closed.
- Build an ANU rank/score rule before a new read.

**Needs:** Platform Admin approval (direction: "excluding the unresolved ANU 22").

**Rollback:** a new read creates new items.

**Cost:** none.

## E10. Fee checks needing a policy (28)

| Refs | Count | Finding (stored copy) | Decision needed |
|---|---:|---|---|
| Burman University (62415d45) | 27 | One institution-wide "Tuition 30 credits/year" CAD 20,880, headed May 2026 – April 2027. The footer says valid May 2025 – April 2026. | Does one university-wide rate apply to every program? Which year governs when the page contradicts itself? |
| ae1b22fe Victoria University PhD | 1 | The research schedule prices the PhD by thesis discipline (AUD 35,000–41,400). | Leave a multi-rate course without a fee, or admit a range? |

**Recommended:** do not admit until a rule exists. For Burman, ask the provider page owner, or wait for the page to drop the old footer.

## Not in this pack (authorised, being worked)

| Item | Status |
|---|---|
| College of the North Atlantic (5) and SITI (1) | The stored copies support the proposed fees. They are admitted one at a time after v2.15.394, with the first saved outcome verified. |
| USC 0850e65e | Quarantined fee awaiting a rebind; handled with the course-link URL pairs. |

## E11. RMIT entry-requirement reads from the local-student view (298)

**Scope:** 298 AER course-entry first reads at RMIT (29 Oct).

**Evidence:** 294 of the 298 stored copies are the local-student page ("You're viewing program information for local students"). The rows carry domestic ATAR, Guaranteed ATAR, adjustment factors, STAT and VCE work-and-life-experience routes.

**Risk:** approving them would show domestic requirements to international students.

**Options:**
- (a) **Reject the reads** one at a time, store the international view (RMIT `page_view`) and read again. **Recommended.** A new read costs reader credits, so a ceiling is needed.
- (b) Leave them pending until the international view is stored.

**Cost:** the re-read is about 300 page reads plus the AI read. The ceiling is the Platform Admin's.

**Rollback:** none needed for (b). Under (a), rejected reads are withdrawn rows; a new read proposes again.


## E12. QUT entry-requirement reads that mix domestic and international rows (38)

**Scope:** 38 AER course-entry first reads at QUT (29 Oct), held at batch L4B-20261101-1253 checkpoint 7. None of the 38 courses has active entry rows, so the D4 rule would allow Approve except.

**Assessment (1 Nov, 19:55 AEDT; measured from the reads and stored copies):**
- **Every read hit the reader's row cap.** All 38 reads have exactly 6 rows (`entry.max_rows_per_course` = 6). The 6 rows are a mix, so each course page held more requirements than were read.
- **Domestic rows dominate.** 90 of 228 rows are tagged domestic (ATAR, selection-rank thresholds, guaranteed offers, Australian Year 12). Another 19 rows are AQF diploma and VET offer guarantees, a domestic admission route, but tagged "all".
- **Few international rows, and most lack a scale.** After leaving out domestic rows and "assumed knowledge" notes, 73 rows could stay (IB, A-Level, SAT, GED, US high school, NCUK, Bellerbys, INTO, NCC). 11 items would keep none, 14 would keep 1–2, and 13 would keep 3 or more. 64 of the 73 carry a score with no scale field (for example IB "28" and US GPA "3", where the 4-point scale is only in the quote).
- The stored copies are QUT's combined page: both audiences are in one HTML file, with the international qualifications in a `requirements-international` block.

**Why Approve except is not used:** each approval would publish a partial international list (often one or two routes) chosen by the row cap, not by the page. Most kept scores also lack the scale the playbook requires ("every number has its scale"). The items stay pending.

**Options:**
- (a) **Reject the 38 reads and read the international view again**, with the international block as the source and the row cap reviewed for multi-route pages. **Recommended.** About 40 page reads plus the AI read; ceiling set by the Platform Admin.
- (b) Leave them pending.
- (c) Approve except, one item at a time, accepting partial international lists and scale-less scores. **Not recommended.**

**Rollback:** none needed for (b). Under (a), rejected reads are withdrawn rows; a new read proposes again.

## E11 (addition, 1 Nov 19:55). RMIT recovery requirements

The direction of 1 Nov 19:42 asks for the exact controlled recovery requirements. No RMIT item is decided from the local-student copies.

1. **Source:** store each program's international view. The local copies print "You're viewing program information for local students"; the stored copy must show the international banner, or the international entry block. Each RMIT program also has plan pages (for example `…/diploma-of-visual-arts-c5448/c5448auscy`). Which URL or parameter serves the international view is confirmed with a live check during the authorised acquisition step, not assumed.
2. **Check before reading:** a copy is read only if its entry section is the international one, with no ATAR, Guaranteed ATAR, adjustment factor or STAT rows. The banner text is the test.
3. **Read:** a fresh course-entry read of the stored international copy. The 6-row cap (`entry.max_rows_per_course`) is reviewed first (see E13), because RMIT pages list many international qualifications.
4. **Old items:** each of the 298 local-copy reads is rejected one at a time in the Layer 4 UI, naming the new read, only after the new read exists. Nothing is rejected in bulk.
5. **Authority:** steps 1 and 3 are source acquisition and paid AI processing. Both wait for the Platform Admin's approval and spend ceiling: about 300 page fetches and 300 AI reads.
6. **Acceptance:** quotes on the international copy; rows with a scale for every score; the D4 rule for courses that by then have active rows; Active rows verified after each approval.

## E13. Course entry reads cut at 6 rows (new, 1 Nov 19:55)

**Finding:** the course entry reader proposes at most 6 rows a course (`entry.max_rows_per_course` = 6, CF-247 Track C). Of the 454 course-entry reads approved on 1 Nov, 59 have 6 rows (354 rows Active). Their rows were checked against their quotes and are correct, but those pages may print further routes that were not read. QUT (E12) and RMIT (E11) are the clearest cases.

**Options:**
- (a) **Keep the approved rows** (they are correct) and review the cap before the E11 and E12 re-reads. **Recommended.**
- (b) Raise the cap in Settings › Pipeline settings (with a reason) and re-read the 59 courses. This costs reader credits; ceiling set by the Platform Admin.

**Rollback:** none; nothing is changed until a decision.

## E11 (second addition, 1 Nov 20:24). Read-only check of the stored RMIT copies

Six stored RMIT copies were sampled at random from the 298 pending items. They were read in the Layer 4 evidence viewer (no fetch, no AI).
- **Every copy holds both banner texts:** "You're viewing program information for local students" and "… for international students". They are the two labels of the page's audience toggle. **The banner test in step 2 above is therefore not a valid check** and is replaced. The check must find the international entry content itself.
- All six have an English language requirements tab with IELTS.
- 2 of the 6 also print ATAR, which is domestic content.
- No audience attribute separating the two views was found on the tab components (`tabs-english-language-requirments`, `tabs-selection-tasks`).

**Consequence:** the stored copies may already hold the international content, in which case no new page acquisition is needed. This is not proven until the page's audience structure is identified. **Next read-only step:** map where RMIT puts country-specific international qualifications (in the copy, or loaded later by script). If they are in the copy, the recovery reduces to an international-only re-read of the stored copies. That costs about US$0.0082 a read (measured mean of 385 QUT and RMIT entry reads), so about US$2.45 for 298, under a ceiling the Platform Admin sets.

## E12 (addition, 1 Nov 20:24). International-only extraction method and bounded pilot

**Method (proposed; nothing run):**
1. **Source:** the stored QUT copy, cut to the `requirements-international` block, which includes the country selector's `data-content` entries. Domestic blocks are never sent to the reader.
2. **Rows:** one row per qualification and country, with the printed score, the scale stated or taken from the page's own explanation (for example "on a 4 scale"), and the quote.
3. **Completeness gate:** count the qualification entries in the block, then compare with the rows proposed and dropped. A read is proposed only when every entry is either a row or dropped with a reason other than the row cap. Otherwise it is held whole. This uses the gate proposed in E13.
4. **Review:** one item at a time. Approve all rows only if every row passes; D4 applies.

**Bounded pilot:** 5 QUT courses (1 undergraduate, 1 double degree, 1 postgraduate coursework, 1 creative-industries course with an audition, 1 health course).
- Estimated AI cost about US$0.05 (5 × US$0.0082 measured mean).
- No page fetch; the stored copies are used.
- Acceptance: every block entry accounted for, and every score with a scale.
- Needs the Platform Admin's spend approval and the E13 gate first.

## E13 (measured, 1 Nov 20:24). Does the 6-row cap stop complete publication?

**Yes.** The reader records the rows it drops beyond the cap (`field_enrich_items.value->dropped`, reason `over_row_limit`).
- **All course entry reads (1,117):** 225 dropped rows at the cap, 3,189 rows in total (median 4, maximum 111). 193 of the reads are Australian and 32 New Zealand.
- **The 59 capped approvals of 1 Nov:** 53 dropped rows, 287 in total. By kind: minimum grade 151, prior qualification 76, general note 28, subject prerequisite 16, portfolio or interview 10, work experience 5, override 1.
- **Sample, comparing the stored page's rows with the admitted rows:**
  - Monash Master of Clinical Research admitted "An Australian bachelor degree (or equivalent)" but dropped "plus a minimum of two years of relevant work experience".
  - The EIT Postgraduate Certificate in IT admitted Master of IT rows but dropped "The academic entry requirement for the PGCertIT is …".

The cap does more than leave routes out: on these pages it can publish a **lower** or **wrong-programme** requirement. See E14.

**Proposal (design and tests before any setting change):**
- **Cap:** keep `entry.max_rows_per_course` as the setting (G2). Raise it only per provider, with a reason, after the gate below exists. The value is the Platform Admin's.
- **Whole-read completeness gate:** a read that drops any row for `over_row_limit` is held whole (`held_partial`), never proposed in part. This is the same rule the reader already applies to token and slice limits.
- **Conjunction check:** a dropped row starting with "and" or "plus", or of kind `work_experience`, holds the read.
- **Variant check:** when a quote names a programme or credit variant other than the course's own (for example "MIT (240)" on a Postgraduate Certificate), the row is dropped with the reason `other_programme`.
- **Tests:** a contract spec with fixture reads covering a cap overflow, a conjunction, a sibling variant and a clean read, then a supervised run on stored copies. No paid re-read under the current mandate.

## E14 (new, 1 Nov 20:24). Approvals of 1 Nov that need correcting

**What happened:** this session approved these items one at a time on 1 Nov after checking that each quote was on the stored copy and each row was faithful to its quote. It did not check two things the playbook requires ("course items have strong exact-course identity"; completeness):
- whether a row belongs to **this** course's variant on a combined page;
- whether the reader had dropped a joined condition.

The error is the reviewer's (this session), not the reader's alone.

**Items (18), every one decided by this session:**
- **Sibling variant on EIT combined pages (14):** 94f31620 and b25a3d1d (MAppM 180 and 240), 9dbc3950 (PGCert ApM), bc8866f0 and ff1f768c (MLSCM 180 and 240), 6a26d4d7 and 26fb0941 (MWBI 180 and 240), 37368deb (PGDip WBI), a175eb32 and 6736a57a (MDigiBus 240 and 180), 49be3b93 and 213c3e9d (MIT 180 and 240), 12bd7ce0 (PGCert IT), 72d54be7 (PGDip IT). Each course carries the routes of all its variants (for example the 180-point "Bachelor Honours, 120 credits at Level 8" route on a 240-point master, or master's routes on a postgraduate certificate).
- **Dropped joined condition (4):** 06b4b580 (Monash Master of Clinical Research: "plus two years of relevant work experience"), 44d14493 and e8c40f42 (Monash), and 40d159c9 (Auckland PhD: conditions "and b … and d … and e …").

**Consumer impact:** these rows are Active and on the website and Zoho course detail. A student may see a route that applies to another variant, or a requirement without its work-experience condition.

**Options:**
- (a) **Withdraw the 18 items' entry rows** (status withdrawn, count-guarded paste file with rollback; nothing deleted), then re-review each item once the E13 gate exists. **Recommended.**
- (b) Keep them and add a reviewer flag until the re-read.
- **Route for (a), added 1 Nov 20:56:** the existing Catalogue › Entry requirements screen lets a Curator or above withdraw a row with a reason, and keeps the row history (AER-ROLE-GUIDES §3). Withdrawing the 105 rows one at a time there is the governed route and needs no SQL. The paste file stays as the fallback only if the screen cannot withdraw these rows.

**Process change, effective now:** before approving a course entry read, this session also checks:
- the read's dropped rows (`over_row_limit`);
- any programme or variant named in each quote.

The approvals since 20:08 (none so far in this tranche) follow this.

### E14 approval pack (1 Nov 2026 21:09 AEDT; direction 21:02 §4). Nothing withdrawn

1. **Current rows (reconciled live 21:09):**
   - 18 courses, 105 entry rows, all `active`. The id list and md5 `23488f75…` are unchanged from the paste file.
   - Every active entry row on these 18 courses comes from the 1 Nov approvals. There are no other active rows and **no superseded rows**: these approvals replaced nothing.
2. **Why each is invalid:** per item, in E14 above.
   - 14 EIT items carry routes of sibling variants (180 and 240 points, PG Certificate, PG Diploma) from one combined page.
   - 4 items have a joined condition dropped by the reader's row cap, shown in the read's `dropped` list (`over_row_limit`).
3. **Effect for consumers:** the website and Zoho course detail for these 18 courses will show no entry requirements, which is their state before 1 Nov. The search projection follows at its next requested refresh. No other course changes.
4. **Role and route:** Catalogue › Entry requirements, row withdraw with a reason (Curator, rank 3, or above; AER-ROLE-GUIDES §3). This session holds the Platform Admin account. Rows are withdrawn one at a time, each with the reason "E14: <variant | dropped condition>, approval of 1 Nov by the integrator session".
5. **Reconciliation:**
   - **Before:** count = 105 active, md5 of the sorted ids = `23488f75ba7972f42126852e89292af2`.
   - **After:** 105 withdrawn, 0 active on the 18 courses, and one audit event per row.
   - **Rollback:** if the screen offers a restore, use it row by row. Otherwise use `PASTE-20261101-e14-entry-rows-withdrawal-rollback.sql`, which is count-guarded on the same 105 ids.
6. **Approval needed:** the Platform Admin's explicit approval of E14 option (a). The direction of 21:02 is not that approval, in its own words.
