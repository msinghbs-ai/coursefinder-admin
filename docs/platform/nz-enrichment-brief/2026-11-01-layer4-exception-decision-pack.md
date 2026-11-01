# Layer 4 exceptions: consolidated decision pack (1 Nov 2026)

**Requested by:** Platform Admin direction, 1 Nov 2026 13:52 ("prepare one decision pack … exact scope, affected refs, supporting evidence, expected downstream impact, cost ceiling where relevant and rollback requirements"). Batch L4B-20261101-1253 (checkpoints 1–3 in `2026-11-01-layer4-batch-L4B-1253.md`).

**Status:** prepared, nothing decided. This pack does not approve any merger, new source acquisition, paid AI or Firecrawl activity, or policy change. Every decision below is the Platform Admin's.

**Figures:** live database, 1 Nov 2026 about 14:15 AEDT (live pending 1,821).

## Summary

| # | Exception | Items | What is needed | Recommended | Spend |
|---|---|---:|---|---|---|
| E1 | Fees admitted by mistake on 30 Oct | 46 | Keep or withdraw the 46 fees | Withdraw, then re-check from stored copies | None |
| E2 | UniSA and Adelaide left the register | 2 | Merger authority | Record as merged into Adelaide University | None |
| E3 | Stamford, Nova, St Peters, Asia Pacific, "N/A" | 5 | Successor or closure, provider by provider | Closed, unless a successor is named | None |
| E4 | Onboarding kinds | 547 | A route per kind | Name a pilot budget, or mark "CRICOS data only" | Ceiling set by PA |
| E5 | Held scholarships with no quotes | 118 | Re-check them, refuse them or leave them | Leave held until a quote exists | Only if re-checked |
| E6 | Held scholarships already published | 4 | A way to close a duplicate | Build a "duplicate" close route | None |
| E7 | Aggregator copies attached to the wrong provider | 21 (10 also in E5) | Identity decision | Refuse as not this provider's scholarship | None |
| E8 | Griffith eligibility and a misleading re-check | 2 | Rule correction | Fix the re-check; decide on the 2 by hand | None |
| E9 | ANU entry-score reads | 22 | Interpretation | Reject the reads; build an ANU rank rule | None |
| E10 | Fee checks needing a policy | 28 | Rule for single-rate and per-discipline schedules | See E10 | None |

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

