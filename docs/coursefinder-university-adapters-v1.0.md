# CourseFinder — University Adapters: Report, Decision and Design

**Version:** 1.0 · **Status:** CURRENT · **Date:** 4 October 2026 (amended 5 October 2026, 07:30, section 11; 08:35, section 12) · **Decision:** 254 (recorded in `docs/coursefinder-design-reference-v1.4.md`)
**Change control:** CF-CHG-20260915-247 (M2.4.7) · **Source:** Platform Admin, 4 Oct 2026 21:50, 22:43 and 23:30
**Register and configurations:** `docs/adapters/README.md`, `docs/adapters/configs/`

---

## 1. Executive summary

Data admission had stalled because one general reader was trying to read every university's pages the same way. Universities print course details differently: in page data, in tabs, in a domestic and an international block, on a separate handbook, or on one central page for the whole university. The general reader missed most of it. For example, it found start dates on 25 of 262 Flinders study pages.

A **university adapter** is one university's own reading rules, set in the PIM Admin. The Flinders adapter showed what this unlocks:
- start dates on 173 study pages, up from 25;
- 28 courses corrected or filled in the catalogue (22 replaced, 6 new);
- duration, campus and delivery mode read for checking.

This took one evening and cost no Firecrawl credits for the reading itself.

**Decision 254:** university adapters become the main path for course fields that the general reader misses. Each adapter can use several kinds of page, not just the course page. They are built five at a time, with a visual builder as the target way to make them. That builder lets the Platform Admin point at fields on a page while the cheapest qualified model proposes the configuration.

## 2. Business objectives

- Fill every course attribute that international students need (official page, intakes, English, fees, duration, campus and mode) for the 57 target universities.
- Make each university's reading rules visible, testable and editable by the Platform Admin, with no code change.
- Keep every value traceable to the page it came from, and never overwrite a value entered by hand.
- Prepare adapters to move into production as reviewed, recorded configuration.

## 3. Report — what the Flinders adapter showed

| Measure | Result |
|---|---|
| Stored Flinders pages read by the adapter | 360 (no Firecrawl credits) |
| Start dates read (study pages) | 173 (general reader: 25) |
| Agreed with the intakes held | 145 |
| Replaced (adapter read is exact, Decision 254) | 22 |
| New intakes | 6 |
| Duration, campus, fee read (shown, not admitted) | 227, 130, 150 |
| Better-page run (Firecrawl search for study pages) | 194 courses, 386 credits, 140 found |
| Better pages refused by the identity check and undone | 28 (double degrees and combined courses with no study page of their own) |

**Lessons, now rules in the platform**

1. **Read the right block.** Flinders prints a domestic block first (CSP fee) and an international block from the course's CRICOS code on. The adapter reads from the CRICOS code on, so domestic values are never taken.
2. **Pages print the same field in several ways.** Flinders start dates appear as "– March – July", as "March, July", as "February … June & October", and inside a folded "Start Dates" control. One pattern now covers all four.
3. **Unsafe patterns can stall the reader.** A pattern written as `(.|\s)` exhausted the worker's processor time on long pages. Such patterns are now refused when an adapter is saved.
4. **Apply in small slices.** An edge call may use about two seconds of processor time, and a large course page takes about 75 ms to read. Apply now reads pages one after another and carries on in a fresh call.
5. **Not every course has its own page.** Double degrees, combined courses and discontinued courses have no study page of their own, and search returns a related page. The identity check refuses those, and the earlier page is restored automatically.
6. **Central pages hold some fields for the whole university.** English is set centrally (by course level), and the key-dates calendar applies to all courses. These belong to a central source, not to the course page.

## 4. Decision 254 — how adapters fill every attribute

### 4.1 Page roles

An adapter may use up to four kinds of page. Each kind has its own identity rule.

| Page role | What it is | How we know it is this course's page | Typical fields |
|---|---|---|---|
| **Course page** (primary) | The university's own course page (study, course or programme page) | The course code is printed on it (CRICOS, programme code), or its title matches exactly | Official link, intakes, international fee, English (if course-specific), campus, mode |
| **Linked pages** (continued pages) | Tabs or sub-pages reached by a link on the confirmed course page: entry requirements, fees, "how to apply", international view | Reached from the confirmed course page by a link matching the adapter's link pattern, on the same host. The identity is inherited from the course page | English, fees, intakes, when the course page splits them out |
| **Handbook page** | The academic handbook entry for the course (CourseLoop, Akari or a custom handbook) | The course code is in the page or its page data, or the address is built from the code by the adapter's address template | Duration, AQF level, study level, offerings (location, mode, student type), "not admitting" notices |
| **Central pages** | One page for the whole university: English requirements, key dates or intake calendar, fee schedule | Not course-specific. Read once, turned into a **policy proposal** mapped by course category (level, faculty, named courses), then approved by the Platform Admin (as for the English policy, Decision 227) | English by level, intakes by level or calendar, fees by faculty |

### 4.2 Precedence for each attribute

1. A value **entered or locked by hand** always wins and is never overwritten.
2. **Course page** (adapter reading, marked "by adapter").
3. **Linked page** (adapter reading).
4. **Handbook page** (adapter reading).
5. **Central policy** (approved proposal, by category). Used only where 2–4 give nothing.
6. **General reader** (no adapter). Used only where nothing above applies.

Once an adapter is admitting, its own readings (2–4) replace values held from lower sources, and every replacement is logged. Values from a central policy fill gaps only. A course-specific value always beats a central one.

### 4.3 Attribute coverage plan

| Attribute | First source | Then | Fallback |
|---|---|---|---|
| Official course link | Course page | — | Find pages (Firecrawl search on the university site) |
| Intakes (start months) | Course page (international view) | Linked page | Central calendar by level (proposal, approved) |
| English (IELTS, TOEFL, PTE, Cambridge, Duolingo) | Course page, if course-specific | Linked entry-requirements page | Central English policy by category (approved) |
| International tuition fee | Course page (international view) | Linked fees page | Central fee schedule. Shown, and **not admitted from pages** until a separate decision |
| Duration, AQF level, study level | Handbook | Course page | — |
| Campus, delivery mode, student type | Handbook offerings | Course page | — |
| Not admitting / discontinued | Handbook notice | Course page notice | — |

### 4.4 Courses with no page of their own

Double degrees, combined courses and discontinued courses keep their handbook page as the course page. Their fields come from the handbook, linked pages and central policies. A Firecrawl "better page" is accepted only when the identity check confirms it, and is undone automatically otherwise.

## 5. How many adapters can be built at once

The adapters themselves have no technical limit. Each one is a row of settings, and the worker reads all enabled adapters on every call. The practical limits are these:

| Constraint | Limit | Effect |
|---|---|---|
| Firecrawl Growth plan | 50 concurrent browsers, 500,000 credits a month (477,999 left on 4 Oct) | Not a constraint for adapters. Preview and apply use stored pages (0 credits). Probes cost about 1 credit a page. One Read run and one Find run may be open at a time (platform rule) |
| Edge worker processor time | About 2 seconds of processor time per call | Apply runs as a chain of calls for each university. Up to 5 chains at once keep the regular reader and admission schedules running on time |
| Platform Admin review | About 30–60 minutes per adapter (check values, admit, answer requests) | **The real bottleneck** |
| Build effort (Claude) | About 30–90 minutes per adapter, faster once the visual builder exists | Fits five adapters per wave |

**Recommendation: build five adapters at a time (a wave), and test and admit them before the next wave.** Up to ten at once is possible if the Platform Admin has the review time, but errors then surface later and cost more to undo.

**Amended 4 Oct 23:41 (Platform Admin): every wave includes a New Zealand and a Canadian university.**

| Wave | Australia | New Zealand | Canada |
|---|---|---|---|
| 1 | ANU (started: builder draft, adapter saved for testing), Melbourne, Macquarie | Canterbury | Simon Fraser |
| 2 | UTS, UWA, Murdoch | Auckland | Mount Royal |
| 3 | La Trobe, Griffith, Bond | Massey | Thompson Rivers |
| 4 | James Cook, Charles Darwin, Central Queensland | Lincoln | Vancouver Island |
| 5 | Western Sydney, Sunshine Coast, Australian Catholic | Waikato | Royal Roads |
| After the Find run | Curtin, Monash, Sydney, Adelaide, Swinburne, UTas, Canberra, Notre Dame, Federation, Victoria University | Victoria University of Wellington, Otago | UBC, Alberta, Victoria, Lethbridge, Calgary, UNBC, Athabasca, MacEwan, Fraser Valley, Kwantlen |

The Find run for all target universities was approved and started on 4 Oct (2,722 courses, allowance 15,000 credits). Every search result is kept in the evidence bucket with its run.

Nine universities need no adapter now (RMIT, Wollongong, UQ, QUT, Deakin, ECU, Southern Cross, UNE, AUT).

## 6. Target design — the visual adapter builder

### 6.1 What the Platform Admin does

1. **Pick a university.** The builder picks three sample courses (an undergraduate, a postgraduate and a double degree) and shows the page roles it found for each (course page, linked pages, handbook).
2. **See the page.** Firecrawl captures each sample page as a full-page screenshot and its raw HTML in one call. The page data, if any (for example `__NEXT_DATA__`), is shown as a tree with values.
3. **Point and comment.**
   - **Page text:** next to the screenshot, the page is shown as text blocks (headings and the text under them). The Platform Admin clicks a block and chooses the attribute it holds, or writes a comment, for example "start dates are the months under Start dates in the international view".
   - **Page data (JSON):** the Platform Admin clicks a value in the tree and chooses the attribute. The path is written for them, and lists are turned into "every item" paths.
4. **Ask for a proposal.** The cheapest qualified model, pinned by name in Models & services (the Platform Admin's "Layer 4 model"), receives:
   - the page text and the JSON shape;
   - the Platform Admin's selections and comments;
   - the adapter rules (safe pattern forms, page roles).
   It returns a proposed adapter as structured data: page roles, link patterns, JSON paths, text patterns and "pick" rules.
5. **See the output.** The proposal is run on the three samples and up to 50 stored pages, at no Firecrawl cost. Each attribute is shown per course: the value found, where it came from (role, block or path), and whether it matches what the Platform Admin marked. Mismatches are highlighted.
6. **Accept, edit or ask again.** Each round is kept with the adapter. Saving is a separate, logged step. Admission stays a separate switch.

### 6.2 Rules the builder must keep

- **The model only proposes.** It never saves, applies or admits. Saving, applying and switching admission on are Platform Admin actions, each with a reason. A good test result never switches anything on by itself.
- **Pinned model.** One named, individually qualified model, with no "auto" routing. Its name and version are stored with every proposal.
- **Proposals are checked before they run.** The safe-pattern rule, the field list, page-role identity rules and the processor-time budget all apply.
- **Page content is data.** Text on a university page is never treated as an instruction to the model or the platform.
- **Cost is visible.** Each proposal records model tokens and cost, and each capture records Firecrawl credits. Expected cost is about 3–6 credits and a few cents of model use per university.

### 6.3 Technical notes and open checks

- **Clicking on the screenshot itself.** A screenshot is only a picture: Firecrawl does not return where each element sits. Phase 1 therefore uses the text blocks beside the screenshot for selection. Phase 2 can ask Firecrawl to run a small script during capture that returns the position of each text block, so a click on the picture selects the block under it. This needs a probe first.
- **Screenshot credits** are not listed separately on Firecrawl's billing page. Confirm with one probe before the builder is enabled.
- **New stored data:**
  - adapter drafts: samples, screenshots in storage, selections, comments, proposals, model, cost;
  - page roles: role, link pattern, address template, the fields each role gives;
  - central policy proposals: extending the English policy table to intakes and fees.

### 6.4 Phases

| Phase | Scope | Depends on |
|---|---|---|
| A (now) | Text patterns, page data paths, pick rules, preview and apply, test then admit, adapter readings replace held values, evaluation per university | Done, v2.15.183–v2.15.185 |
| B | Page roles: linked pages and handbook address templates in the adapter, so each field records its source role | Wave 1 learnings |
| C | Visual builder phase 1: capture, text blocks, JSON tree picker, comments, model proposal, output table | B; a pinned cheapest qualified model registered and qualified in Models & services |
| D | Central policy proposals for intakes and fees (as for English) | B |
| E | Visual builder phase 2: click on the screenshot, adapter health alerts when a site changes | C |

## 7. Production preparation

| Item | Where it lives | Production step |
|---|---|---|
| Adapter configurations | Database: `pipeline.uni_adapters` (patterns, paths, pick, notes, admit switch) | Moves with the database (project transfer). The reviewed baseline is exported to `docs/adapters/configs/`. Compare live and baseline at the M2.4.9 dress rehearsal |
| Adapter history | `admin_control_events` (save, apply, admit), `uni_adapter_previews`, `uni_adapter_results`, `uni_adapter_requests`, `adapter_overwrite_changes`, `page_link_repairs` | Kept. Part of the audit trail |
| Schedules | `coverage-admit` (10 min), `coverage-admit-intakes` (10 min), `adapter-overwrite` (10 min), `better-page-revert` (5 min), `firecrawl-runs`, `firecrawl-targets` (1 min), `firecrawl-panel-figures` (5 min) | Listed in the operations runbook. Check they are all active after transfer |
| Settings | Firecrawl toolset settings, including Adapter evaluation (3 shares) and the refused-host pattern | In the database. Re-check values at go-live |
| Worker | `coverage-sweep` edge function v0.16.2 | Deployed from `main` and byte-verified after every deploy |
| Gates | Each adapter is admitted only after testing, with a reason. Its register row and configuration file are updated the same day | Register reviewed at each release gate |
| Monitoring (to build) | Each adapter's hit rate per field over time | Alert when a field's hit rate drops sharply. It usually means the university changed its site |

## 8. Assumptions

- The 57 target universities and the evaluation shares (no page 30%, unreadable 20%, field found 50%) remain as set. Both can be changed in settings.
- Each wave is tested and admitted before the next one starts.
- Tuition fees read from pages are shown, but not admitted until a separate Platform Admin decision.
- The cheapest qualified model will be chosen and qualified in Models & services before the visual builder is enabled.

## 9. Risks

| Risk | Effect | Mitigation |
|---|---|---|
| A university redesigns its site | The adapter stops finding fields, so values go stale | Hit-rate monitoring (phase E). Re-test adapters each term |
| A pattern reads the wrong block (e.g. domestic instead of international) | Wrong values admitted | Anchor patterns on the international block. Test then admit. Every replacement logged and reversible |
| An adapter replaces correct values with wrong ones | Catalogue regressions | Logged changes (`adapter_overwrite_changes`). Hand-entered values never touched. Switch admission off to stop at once |
| The model proposes an unsafe or wrong configuration | Stalled worker or wrong values | Proposal checks, safe-pattern rule, output table before save, separate admit switch |
| Review capacity | Waves slip | Five per wave. The builder shortens review |

## 10. Decisions recorded (Platform Admin, 4 Oct 2026 23:41)

| # | Decision | What was done |
|---|---|---|
| 1 | Each wave includes NZ and CA universities | Waves re-planned (section 5) |
| 2 | Find pages approved with Firecrawl; keep artifacts and scrape results in the Supabase bucket | Find run started for 2,722 courses. Pages read are kept in the evidence bucket (as before), and search results are now kept there too (`layer2/{country}/firecrawl/search/{run}/{item}.json.gz`). Builder screenshots are kept in the private bucket `adapter-captures` |
| 3 | Use the preferred cheapest vetted model, and avoid a large AI daily budget | The builder is pinned to qwen/qwen3-30b-a3b-instruct-2507 (the vetted model already used for page matching). Daily allowance: US$ 0.50 and 30 proposals (settings). First live proposal cost US$ 0.0003 |
| 4 | Include fees and admit them | The international annual fee an admitting adapter reads is admitted and replaces the automatic fee held for the same year. Hand-entered fees are never changed. Whole-course fees still go to Layer 4 |
| 5 | Build the visual adapter builder | Built (phase C1): capture, text blocks, page data, marks, comments, pinned model proposal, output on samples, "Use this proposal" |

**Lessons from the first fee admissions.** Some study pages cover several courses, each with its own CRICOS code and block. Patterns can now hold `{code}`, which stands for the course's own code, so each course is read from its own block. The fee is also compared with the fee held for the same year.

**Lesson from the Find run.** The search domain must be the university's course site:
- UBC's recorded website is grad.ubc.ca, so undergraduate searches found only graduate pages. UBC needs a re-run on ubc.ca.
- Monash courses are on monash.edu, not monash.edu.au. The run's Monash items were corrected before they ran.
- Recommendation: give each adapter its own search site setting.

## 11. Amendment, 5 Oct 2026 (07:30): admission by field, course exclusions, waves 1–5

**Source:** Platform Admin, 5 Oct 2026 04:49 (continue the wave run), 05:50 (switch on the admissions), 06:12 and 06:32 (fetching any public website approved, Firecrawl to save evidence). Full entry: M2.4.7 runsheet set, entry "5 Oct 2026, 07:30 AEDT".

### 11.1 Admission by field

- **What.** Each adapter now has a list of admitted fields (`admit_fields`): intakes, English and fees. When an adapter is admitting, only the ticked fields overwrite held values. The others are read and shown, but not admitted.
- **Why.** A university can be right on one field and wrong on another. For example, Griffith's fees and IELTS are right, but its intakes are held because its trimester months change by year.
- **Built by.** Migration 20261005001400. The PIM Admin (v2.15.188, PR #312) has a tick box for each admitted field.

### 11.2 Course exclusions

- **What.** `pipeline.uni_adapter_exclusions` holds a course, a field and a written reason. An excluded course keeps its held value for that field, even when the adapter is admitting.
- **Why.** Most wrong readings are single courses: short-course totals printed as "annual", scholarship amounts read as fees, domestic-only pages, and application-open months read as starts. Excluding one course is safer than holding back the whole university.
- **Never removed.** Exclusions are switched off ("Stop excluding"), never deleted, so the history stays. At 07:30, 54 exclusions were active and none had been written to the catalogue.
- **PIM Admin.** "Exclude" beside each reading, and a list of excluded courses with "Stop excluding".

### 11.3 Which functions honour them

| Function | Admitted fields | Exclusions |
|---|---|---|
| Adapter overwrite (`security.adapter_overwrite_v1`) | Yes | Yes |
| Country identity rule (`security.coverage_identity_allowed`) | Yes | — |
| Page record (`public.svc_adapter_page_record`) | — | Yes |
| Coverage admission of intakes and English (`security.coverage_admission_apply_v1`, from migration 20261005001410) | — | Yes |

The exclusion check itself is `security.uni_adapter_excluded(course, field)`. Both migrations were checked live: the md5 of each stored statement equals its file.

### 11.4 Term months

- Many universities print a term name ("Semester 1", "Trimester 2", "Autumn Session") instead of a month. Each adapter now has `term_months`, which turns a term name into a start month.
- The months come from each university's own key-dates or academic-calendar page, and the page is named in the adapter notes. Examples: Charles Darwin (Semester 1 = March, Semester 2 = July, Summer = November), CQUniversity (Term 1 = March, Term 2 = July, Term 3 = November), UTS (Autumn = February, Spring = July, Summer = November).
- Where pages print months directly (Bond, James Cook, Royal Roads, Vancouver Island), no term months are set.

### 11.5 Measuring before admitting

`public.admin_adapter_measures(provider_ids)` gives, for each university, the pages read and how the adapter's readings compare with held values: intakes (agree, differ, new), fees (equal, differ, new), IELTS read, and other fields. It is limited to the Platform Admin and Operators. Each wave was measured with it before any field was admitted.

### 11.6 Waves 1–5 results

"All" means intakes, English and fees.

| University | Fields admitted | Held = adapter after the overwrite | Excluded / held back |
|---|---|---|---|
| Flinders | all | 174 intakes, 158 fees | — |
| Melbourne | all | 89 intakes | — |
| UTS | all | 130 intakes, 307 IELTS read | Fee PDF needed |
| Canterbury (NZ) | all | 148 intakes, 70 fees | — |
| Murdoch | all | 178 intakes, 160 fees, 41 IELTS | — |
| Griffith | English, fees | 252 fees, 252 IELTS | Intakes held: the 2027 calendar has T1 March, T2 July, T3 September, not Feb/Jul/Oct |
| Thompson Rivers (CA) | intakes | 36 | No fee reader |
| Massey (NZ) | intakes, fees | 10 intakes, 79 fees | 3 fees (GDDRS, UDBRB, UBAVT) |
| James Cook | intakes, fees | 20 intakes, 2 fees | Diploma of Higher Education fee (Singapore). IELTS held |
| Charles Darwin | intakes, fees | 147 intakes, 130 fees | 8 short-course totals |
| Lincoln (NZ) | intakes, fees | 57 intakes, 30 fees | LI0511 intakes |
| Vancouver Island (CA) | intakes, fees | 27 intakes, 25 fees | Liberal Studies and Global Studies (cancelled) |
| CQUniversity | all | 66 intakes, 66 fees, 55 IELTS | Rebound to handbook pages for the international view |
| La Trobe | all | 100 intakes, 100 fees, 95 IELTS | Dental fee to confirm |
| Western Sydney | intakes, fees | 138 intakes, 21 fees | 7 intakes, 6 fees |
| ACU | intakes, English | 90 intakes, 25 IELTS | 3 intakes. Fees wait on the international view |
| Waikato (NZ) | intakes, fees | 70 intakes, 21 fees | WI0250 intakes, 3 sub-year fees |
| Sunshine Coast | intakes | 93 intakes | 073869J intakes. Fees held (2026 or 2027 label in doubt) |
| Royal Roads (CA) | intakes | 13 intakes | 16 scholarship fees excluded |

- Overwrite runs: 394 values (05:55), 324 values (06:35) and 166 values (07:20), all with 0 errors.
- Not admitted yet: ANU, Macquarie, UWA, Auckland, Simon Fraser, Mount Royal and Bond (reasons in the register, `docs/adapters/README.md`).
- The live database at 07:30 holds 26 adapters: 19 admitting and 7 testing, with 54 active exclusions (Royal Roads has 15 active scholarship-fee exclusions).

### 11.7 Lessons

- A university can be right on one field and wrong on another, so admission must be by field.
- Wrong single courses are mostly short-course totals printed as "annual", scholarships, domestic-only pages, and application-open months read as starts.
- Term months change by year (Griffith).
- The central English rule is by level for most universities (James Cook, Charles Darwin, Lincoln, Vancouver Island, Western Sydney, Sunshine Coast, Waikato). A central-rule source is the next design item.

### 11.8 Open design items

| Item | What is needed |
|---|---|
| Second-page source (Bond, ANU) | Some fields are on a second page, not the course page: Bond's IELTS is on `/program/<slug>/entry_requirements`, and ANU's start dates and English are central. An adapter needs a way to read a linked or second page for a course. |
| Central English rule by level | Most universities set English once, by level (undergraduate, postgraduate, and higher for some fields). A central rule per university and level is needed, rather than a pattern on every course page. |
| Term months by year | Term months can change from one year to the next (Griffith 2027). `term_months` needs a year, so each intake is mapped with that year's calendar. |
| Sunshine Coast fee year | Course pages label the fee "2026", but it may be the 2027 fee. A Platform Admin decision is needed before Sunshine Coast fees are admitted. |
| Re-run Find for UBC | UBC's search site must be ubc.ca, not grad.ubc.ca (lesson in section 10). |

## 12. Amendment, 5 Oct 2026 (08:35): central rules, Universities tab, fee year, wave 6

**Source:** Platform Admin, 5 Oct 2026 07:36 (fee year when none is printed; build the central rule and link it to universities; show universities and courses with coloured pills in a new tab) and 07:42 (more universities in each wave). Full entry: M2.4.7 runsheet set, entry "5 Oct 2026, 08:35 AEDT".

### 12.1 Central pages and English proposals

- **What.** Many universities set English, and sometimes start months, once for the whole university on a central page, not on each course page. A Platform Admin can now attach that central page to a university: an English requirements page or a key-dates page (`admin_provider_central_page`, migration 20261005001430; migrations 1440 and 1450 fixed the address check and mark attached pages as manual).
- **How it works.**
  1. The provider-facts job reads the attached page through Firecrawl and keeps the page as evidence.
  2. The parser tries to turn it into a rule. Most central English pages gave no values, so the rule can also be written out from the page by hand (`admin_provider_english_propose`, migration 20261005001460). It is written as level defaults (for example, undergraduate and postgraduate) plus any named courses with their own requirement.
  3. Either way, the result is **a proposal only**. Nothing changes in the catalogue until a reviewer approves it in Layer 4 Review › Attributes.
- **Why.** Course pages often say only "see English requirements". Without a central rule those courses would show no English requirement at all.
- **At 08:35.** 30 central pages are attached for 21 universities, and 16 English proposals written out from central pages are waiting for review. Waikato also has a parser proposal reading "7.09", which should be rejected.

### 12.2 Precedence: which value a course shows

For intakes and English, each course takes its value in this order:

1. **The course's own page** (read by the adapter or the general reader).
2. **The central rule** for its university, once approved, and only when the course page gave nothing.
3. **Nothing.** The field stays empty, and coverage shows it as missing.

A value entered by hand is never replaced by any of these. Course exclusions (section 11.2) still apply.

### 12.3 Coverage & completeness › Universities

- **What.** A new tab (v2.15.189, PR #314) with one row per target university. Coloured pills show:
  - the adapter state, admitted fields and exclusions;
  - the central English rule and the calendar (Approved, Proposed, No values or none);
  - how many courses hold intakes, English and fees, and from which source (adapter, central rule or general reader).
- **Open a university** to see its courses, each value with its source.
- **Attach a central page** from the university's row (Platform Admin only).
- **Why.** One view of where each university stands, so the next action (admit a field, attach a central page, approve a rule) is easy to see. The adapter register (`docs/adapters/README.md`) uses the same rule for its English rule and Calendar columns: the latest proposal of each kind, with approved ahead of proposed, and proposed ahead of no values.

### 12.4 Fee year

- **Rule.** When a page shows a fee but prints no year, the fee is held against the **current year** (Melbourne time). Migration 20261005001420.
- **Why.** Fees are compared and replaced year by year. Without a year, a correct fee could not be admitted.
- **Sunshine Coast.** Fees are now admitted. 28 readings are excluded:
  - 13 from the 2024 and 2025 fee tables;
  - 6 that are not annual;
  - 9 from pages labelled 2026 that show the 2027 table figures.
- **Western Sydney.** Courses that held a 2027 fee also gained a 2026 row.

### 12.5 Wave 6 results

Wave 6 had 11 universities. Admission is on for 9 of them. 902 values were replaced with 0 errors, and 143 readings are excluded.

| University | Fields admitted | Intakes / fees / IELTS held = adapter | Held back |
|---|---|---|---|
| UQ | all | 316 / 312 / 316 | 3 fees |
| Deakin | all | 144 / 189 / 185 | Domestic-view pages and site-menu months |
| QUT | all | 140 / 122 / 138 | 3 general-reader readings |
| Curtin | all | 202 / 3 / 257 | Fees wait on the international view |
| RMIT | English, fees | — / 271 / 362 | Intakes: 56 pages list fewer intakes than held (decision) |
| Swinburne | intakes, English | 212 / — / 219 | Fees: pages show 2026, the catalogue holds 2027 (decision) |
| Wollongong | intakes, English | 208 / — / 210 | No annual fee published |
| University of Victoria (CA) | intakes, English | 70 / — / 3 | No international fee on the pages |
| Alberta (CA) | English | — / — / 16 | No fee or start dates on the pages |
| Otago (NZ) | none | | Wrong bindings. Rebind 152 courses to `/courses/qualifications/<slug>` (about 160 credits, decision) and accept "(ABBR)" in the identity check |
| Victoria University of Wellington (NZ) | none | | The site moved to wgtn.ac.nz. Website and search domain still say vuw.ac.nz (decision) |

At 08:35 the live database holds 35 adapters (28 admitting, 7 testing) and 222 active course exclusions. Wave 7 is scheduled for 08:54, and wave 8 finishes the list.

### 12.6 Open decisions

| Decision | What is needed |
|---|---|
| RMIT intakes | 56 course pages list fewer intakes than the catalogue holds. Decide whether the page wins (fewer intakes) or the held intakes stay. Until then RMIT admits English and fees only. |
| Swinburne fee year | Course pages show 2026 fees, but the catalogue holds the 2027 schedule from Swinburne's international fee lists. Decide whether to keep 2027 only, or also hold the 2026 page figures. |
| Otago rebinding | 152 Otago courses are bound to the wrong pages. Rebinding them to `/courses/qualifications/<slug>` costs about 160 Firecrawl credits. The identity check would also need to accept a short name in brackets, for example "(BSc)". |
| Victoria University of Wellington domain | The university's site has moved to wgtn.ac.nz, but its website and search domain are still vuw.ac.nz. Decide whether to change both, then re-run Find. |

## Sources

- [Firecrawl billing: plans, concurrent browsers and credit costs](https://docs.firecrawl.dev/billing)
