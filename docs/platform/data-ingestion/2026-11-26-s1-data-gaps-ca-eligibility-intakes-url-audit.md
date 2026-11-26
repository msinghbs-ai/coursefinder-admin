# S1-Data-Gaps: CA international eligibility, $0 intakes and official URL alignment (audit, 26 Nov 2026)

**Lane:** S1-Data-Gaps (new dedicated channel; Atlas brief 26 Nov 2026 19:50 AEDT). **Boundary kept:** no `portal/` code and no `public.portal_course_search_v1` change (S2-Data-Gaps owns those).
**Read:** 26 Nov 2026 19:55 to 20:20 AEDT, live, read only. **Written to the database:** nothing. **Spend:** US$0 (no Firecrawl, no model call).
**Result in one line:** no flag, intake row or URL was changed, because the measured evidence does not support a governed change without a Platform Admin decision. Three decisions are set out in section 5 with a recommendation each.

## 1. How this was read (no interactive SQL)

Every figure below was read by the hand-started, rolled-back rehearsal of `db-migration-dry-run.yml` on a throwaway `…-probe` branch carrying a no-op migration, with the read as the probe expression (the non-interactive route in `CLAUDE.md`, Migration Pre-flight Before Any Push). Each run ended in `CF-DRYRUN-ROLLED-BACK`, so nothing was kept. No interactive Supabase `execute_sql` was called. The probe branch is deleted by the Auto-merge workflow when its run ends. The only data not readable this way is the stored page text itself (it lives in Storage, not in the database); where that matters it is said below.

| Control (Atlas brief) | Read live | Held |
|---|---|---|
| Live migration head | `20261129210000` (S2-Data-Gaps' s1275 migration `20261129220000` is open, not applied) | No migration here |
| Manual locks | 7,585 | Immutable, untouched |
| Active cron jobs | 137 (≤ 140) | None added |
| Consumer API G3 (75/48) | Not re-measured; nothing was changed | Frozen |
| Spend | US$0.00 | Held |
| Daytime quiet hours (08:00 to 20:00 AEDT) | Reads only; all done by 20:20 | Held |

Scope reconciles to the brief: **34,362** published-provider active courses (AU 24,013, NZ 6,520, CA 3,829).

## 2. International eligibility (`open_to_international`), Canada

| Group (all 3,829 CA courses) | Courses | Stored backing |
|---|---|---|
| `true` | 3,829 | One `international` enrichment item each, state `filled`, source `institution_rule`, a rule quote, **no evidence ID** (no stored page) |
| `false` | 0 | None |
| unknown (null) | 0 | None |

**Nursing and regulated-health courses** (grouped by title keywords, so a heuristic grouping, not a regulator list): 288 courses at 40 providers, **all `true`, none locked**.

| Group | Courses |
|---|---|
| Nursing and midwifery | 96 |
| Other regulated health (paramedic, pharmacy, dental, physiotherapy, occupational therapy, respiratory, radiography, medicine and similar) | 192 |

Largest providers in the group: University of Alberta 52 (5 pages read), UBC 40 (23), Durham College 16 (15), Conestoga College 15 (15), University of Calgary 12 (4), University of Lethbridge 11 (4), Cambrian College 10 (10), Loyalist College 10 (10).

Stored page state for the 288: read 175, fetch failed 52, identity mismatch 51, no page 3, not a course page 3, page refused 2, identity refused 2.

**What the evidence says about domestic-only:** nothing stored says so for Canada. Platform-wide, `international` readings with a value of false are AU 4 (admitted, course is false) and NZ 265 (139 filled, 126 skipped); the 125 NZ readings whose course is still null were all taken back by the identity gate ("the page read was another course's page" and similar). CA has none. This agrees with the s1275 read (144 false in scope: NZ 140, AU 4, CA 0).

**Why nothing was set to false:**
1. The brief allows `false` only where stored official evidence explicitly says domestic-only. For Canada there is none. Whether any of the 175 stored CA health pages says it is untested, because the page text is not readable from the database.
2. The governed admission writer, `security.enrich_apply_v1` (field `international`), updates a course only `where open_to_international is null`. All 3,829 CA flags are already `true`, so that path **cannot** turn a CA `true` into `false`. The only other writers are the Curator-only hand edit `public.admin_course_applicants_edit` (sets a manual lock and basis "Set by hand") and the provider-level `admin_provider_applicants_edit`. A script that wrote `false` directly would bypass the governed path the brief requires.
3. `false` is not a small change downstream: s1163 treats it as "not applicable" for English, academic entry and tuition, and s1275 removes such a course from Portal search and Entry Requirements.

Baseline reconciliation (all 36,052 active courses): true 31,579 (25,380 "CRICOS course registration"; 6,199 with no basis, which includes all of CA), false 144, unknown 4,329 (4,287 of them in the published scope, per s1275).

## 3. Intakes (`intake_dates`), $0 deterministic read on stored pages

| Measure | Courses |
|---|---|
| In scope | 34,362 |
| Future-dated intake | 3,160 (9.2%) |
| No future date | 31,202 |
| of which no intake row at all | 20,711 |
| of which rows exist but none future-dated (mostly month-only, Rule B; includes the 7 past-dated rows) | 10,491 |
| Intake manual locks among the 31,202 | 14 |

The 7 past-only rows were confirmed (7 past-dated rows, 7 courses, none with a future row) and are untouched.

**Stored copies.** Of the 31,202, **19,951** have a stored page that was read and bound with evidence. Identity basis: CRICOS code 11,180, exact title 5,371, adapter title 776, field and award 761, title and level 727, manual 468. A further 5,025 stored pages failed identity and are not used. Evidence metadata carries no intake-table or JSON-LD flag, so "how many stored pages hold an intake table or JSON-LD" cannot be counted from the database; what can be counted is what the existing reader found.

**The existing deterministic reader already covers this.** `fid-det-reader.ts` (mode `fid_det_read`, gate `security.fid_det_record_v1`, job `fid-det-sweep`, active, every minute) reads fee, intake and deadline from stored pages at $0 and already enforces the title or code identity match, Rule B (a month is never turned into a day), manual locks and the no-overwrite rule. Nothing new was built or run.

| Sweep result | Count |
|---|---|
| Stored in-scope pages (read, with evidence) | 19,951 |
| Already processed by the sweep | 11,982 |
| Bound and not yet processed | 7,133 |
| of which in provider types the sweep is set to read | **211** (CA "other" 185, AU university 12, NZ university 8, NZ polytechnic 4, AU TAFE 2) |
| of which in provider types **outside** the setting | **6,922** (AU private VET 6,141, NZ private VET 447, AU schools 246, NZ wānanga 88) |
| Pages admitted an intake, all processed pages | 185 of 15,209 (1.2%); 381 readings admitted |
| Intake readings held ("intakes already held, no overwrite") | 5,869 |
| Intake readings incomplete (study periods, past year) | 188 |

So the 211 in-type pages will drain on their own (the sweep looks slow, 2 pages in the last hour, because it has almost run out of in-type pages). The 6,922 others are not read because the setting `fees.provider_types` lists only university, TAFE or polytechnic, other, higher education institute and university college. **Expected yield if they were read: about 80 courses (6,922 at the observed 1.2%), roughly 0.2 percentage points.** The platform's own intake reader has also already tried most stored pages: for the 19,951, 8,651 have no attempt on record, 7,601 were skipped as "the page does not state it", 1,833 as "the quote names no start month or semester", and 1,107 were filled.

Two other levers sit outside this lane and are noted, not acted on: courses with no page at all (10,624 have no official URL; 1,804 have no bound page), and a university's International Academic Calendar (Standing Authority Charter item 4); the `provider-calendar-intakes` and `intake-dates-apply` cron jobs are inactive.

## 4. Official URL alignment

| Measure | Courses |
|---|---|
| With an active official course URL | 23,738 |
| Without one (the URL gap, S1-Build) | 10,624 |
| Bound page failed identity or host check (identity mismatch 487, identity refused 22, refused host 8, not a course page 1) | 518 |
| of which the failing page **is** the held active URL | **146** (CA 64, NZ 47, AU 35) |
| of which manual-locked on the link (immutable) | 123 |
| **Unlocked candidates** | **23** |
| Already in Course page needed, or pending in Layer 4 | 0 |

The other 372 failed pages are a different candidate page while a different URL is held, so nothing is known to be wrong with the held URL.

**`needs_better_source_url` is the existing Course page needed queue** (`pipeline.course_page_needed`, written only by `security.course_page_needed_add_v1`, Decision 179). It now holds open 2,189, search requested 402, no page exists 236, page added 6. No new state was invented. The existing converter (`course_page_needed_convert_v1`) works one university at a time on pending Layer 4 items, needs a Platform Admin session, and **deliberately skips a course that holds an active page** ("held page: a person decides"). It never touches `course_links`, so no valid URL is deleted.

"Points to a confirmed domestic-only page" cannot be tested from the database (no field records it, and page text is not readable there). Nothing was moved.

## 5. Decisions required (recommendation first)

**DECISION REQUIRED, S1-DG-1: Canada eligibility for nursing and regulated-health courses.**
- *Problem:* all 3,829 CA flags are a blanket `true` from an institution rule with no page evidence, and the governed writer cannot lower a `true`.
- *Options:* (A) leave as is, flag stays "institution rule"; (B) add a $0 pure reader for explicit domestic-only wording on stored pages (verbatim quote, identity gate, manual-lock check), run on the same `fid-det` tick (no new cron), and let one narrow gate lower an `institution_rule` `true` to `false` only on a verified quote; start with the 175 stored CA health pages; (C) curators set each course by hand.
- *Recommendation:* B, in two steps: a read-only count of how many of the 175 pages state domestic-only, then the gate only if the count is non-zero.
- *Impact:* unknown until step one; each `false` removes the course from Portal search (s1275) and marks English, academic entry and tuition not applicable (s1163).
- *Consumer API:* none expected on the frozen v2 surface (checked by G3 in the migration); Website v3 and Portal read the flag.
- *Risk and rollback:* the prior value and basis are logged; one statement restores them; locks are never overwritten.
- *Approval requested:* "B, step one only".

**DECISION REQUIRED, S1-DG-2: read stored pages for private VET, schools and wānanga.**
- *Problem:* 6,922 bound stored pages are outside the sweep's provider types.
- *Options:* (A) leave; (B) add private VET, school and wānanga to `fees.provider_types` (Settings, with a reason).
- *Recommendation:* B, only if you also want the fee reader to cover those providers, because the setting is shared and there is no intake-only switch. The intake gain is small (about 80 courses); the fee gain is not estimated here.
- *Impact:* $0; the same identity, Rule B and lock gates apply. *Consumer API:* none. *Rollback:* set the value back; admitted rows are individually reversible.
- *Approval requested:* "B" or "A".

**DECISION REQUIRED, S1-DG-3: the 23 unlocked courses whose held URL failed identity or host.**
- *Problem:* Decision 179 keeps held-page courses with a person; the brief asks for routing to the queue.
- *Options:* (A) raise the 23 as Layer 4 "binding check" items for a person; (B) add them straight to Course page needed (the link stays); (C) leave.
- *Recommendation:* A, because it follows Decision 179 and the 123 locked courses are excluded either way.
- *Impact:* 23 courses. *Consumer API:* none (no link changes). *Rollback:* an item can be superseded.
- *Approval requested:* "A", "B" or "C".

## 6. Not done, and why

| Item | Why |
|---|---|
| Set any `open_to_international = false` | No stored official evidence; governed writer cannot lower a `true` (S1-DG-1) |
| Run an intake reader | The existing reader already covers the in-type pages; remainder is a setting decision (S1-DG-2) |
| Move any URL to the queue | Decision 179 held-page rule; 123 of 146 locked (S1-DG-3) |
| Migration, s-number, spec | No code or migration is needed; none claimed (same as the S2-AER audit of 26 Nov 17:05) |
| `TEST-REGISTER.md` regeneration | No test added, changed or retired; register unchanged |
| Pilot PR | Nothing to merge in Pilot |
| Drive "Running Build & Chat Handover" append | The document is not editable by this connection (`canEdit: false`); the entry text is in section 7 for pasting |

## 7. Entry for the Drive running build document (to paste)

> **S1-Data-Gaps, 26 Nov 2026 20:20 AEDT: CA eligibility, $0 intakes and URL alignment audit (read only, nothing written, US$0).** Scope 34,362 reconciled. CA: all 3,829 courses `open_to_international = true` from an institution rule, none with page evidence; 288 nursing and regulated-health courses (96 nursing and midwifery, 192 other), all true, none locked; no stored domestic-only statement for Canada; the governed writer only fills nulls so it cannot lower a true. Intakes: 3,160 future-dated; 19,951 stored pages read, 11,982 already processed by `fid-det-sweep`, 211 in-type pages left, 6,922 in provider types outside `fees.provider_types`; observed yield 1.2%, so about 80 more courses at most. URLs: 146 courses hold an active URL whose own page failed identity or host (CA 64, NZ 47, AU 35); 123 locked; 23 unlocked; Decision 179 keeps held pages with a person. Decisions S1-DG-1 to S1-DG-3 open. G3 75/48 untouched, locks 7,585, cron 137, US$0.
