# CourseFinder — University Adapters: Report, Decision and Design

**Version:** 1.0 · **Status:** CURRENT · **Date:** 4 October 2026 (amended 5 October 2026, 07:30, section 11; 08:35, section 12; 09:30, section 13; 10:30, section 14; 11:35, section 15; 18:04, section 16; 20:30, section 17; 21:00, section 17.8) · **Decision:** 254 (recorded in `docs/coursefinder-design-reference-v1.4.md`)
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

## 13. Amendment, 5 Oct 2026 (09:30): wave 7

**Source:** the wave run on the Platform Admin instructions of 5 Oct 2026 (04:49, 05:50, 06:12 and 06:32 approving fetching of public websites, 07:42 asking for bigger waves). The four decisions raised after wave 6 (section 12.6) have not been answered and stay on hold. Full entry: M2.4.7 runsheet set, entry "5 Oct 2026, 09:30 AEDT".

### 13.1 Wave 7 results

Wave 7 had 11 universities. Admission is on for 10 of them. 490 values were replaced with 0 errors. Readings that would have been wrong were excluded course by course, mostly domestic start dates, application closing dates and half-year totals. After the overwrite, every admitted field matches the adapter.

| University | Fields admitted | Intakes / fees / IELTS held = adapter | Held back |
|---|---|---|---|
| Monash | all | 266 / 262 / 260 | Scholarship and domestic fees, 2 intakes |
| Adelaide University | all | 229 / 199 / 246 | Half-year and online totals; online intakes (student visas) |
| Edith Cowan | all | 144 / 138 / 149 | Graduate certificate totals, 4 domestic-only pages |
| Canberra | intakes, English | 94 / — / 97 | Fees: not on the stored pages (the browser loads them) |
| Tasmania | intakes, English | 96 / — / 39 | Fees: annual figures for years that are not 100 credit points (decision) |
| AUT (NZ) | intakes, English | 137 / — / 138 | Fees: tuition only or with the student services levy (decision) |
| Federation | English, fees | — / 9 / 100 | Intakes: domestic-view pages |
| Sydney | intakes | 21 / — / — | Domestic-view pages; fee and IELTS load in the browser |
| Victoria University | English | — / — / 7 | Domestic-view pages; per-semester fees (decision) |
| Lethbridge (CA) | intakes | 3 / — / — | 186 courses bound to the wrong pages (decision) |
| Calgary (CA) | none | | Wrong bindings; graduate pages need an abbreviation identity rule (decision) |

**Central pages and rules.** 11 key-dates pages (and 5 more central English pages) were attached for wave 7 universities. The English rules written out from them, or read by the parser, wait for review in Layer 4 Review › Attributes like the earlier ones (section 12.1).

**At 09:30** the live database holds 45 adapters (38 admitting, 7 testing), 906 active course exclusions and 46 attached central pages for 32 universities. Calgary has a draft adapter only, so it has no configuration file yet. Wave 8 (Southern Cross, Notre Dame, UNE, UNBC, Athabasca, MacEwan, Fraser Valley, Kwantlen) is scheduled for 09:49 and finishes the list. UBC needs a Find re-run on ubc.ca.

### 13.2 Lessons

- **Domestic-view pages are the main blocker.** Sydney, Victoria University, Federation and Curtin keep their course pages in the domestic view. The international start dates and fees are either on a separate address or drawn in the browser, so the stored page shows domestic dates and fees. Reading them would admit the wrong values, so those fields are held back until the international view is stored (for example through Firecrawl, as was done for La Trobe).
- **Half-year and online-program totals.** Many graduate certificates and short programs print the whole-program fee in the place where longer courses print the annual fee (Adelaide University, Edith Cowan). Fully online programs print online prices and online-term start months, which do not apply to student-visa holders. These are excluded course by course, and adapter patterns now refuse amounts marked as part-year where the page says so.
- **Wrong bindings at Canadian universities.** At Lethbridge and Calgary many courses are bound to news, department or old planning-guide pages, not the programme page. Graduate programme pages name the degree by its short form (for example "MSc" or "PhD"), so the identity check needs an abbreviation rule before the courses can be rebound safely.

### 13.3 Open decisions (8)

| # | Decision | What is needed |
|---|---|---|
| 1 | RMIT intakes | 56 course pages list fewer intakes than the catalogue holds. Decide whether the page wins or the held intakes stay (section 12.6). |
| 2 | Swinburne fees | Course pages show 2026 fees, the catalogue holds the 2027 schedule. Decide which year to keep (section 12.6). |
| 3 | Otago rebind | Rebind 152 courses to `/courses/qualifications/<slug>`, about 160 Firecrawl credits (section 12.6). |
| 4 | Victoria University of Wellington domain | Change the website and search domain to wgtn.ac.nz, then re-run Find (section 12.6). |
| 5 | AUT fee levy | AUT prints tuition and the student services levy separately. Decide whether the admitted annual fee is tuition only or includes the levy. |
| 6 | Tasmania fees | Some Tasmania courses have a standard year that is not 100 credit points. Decide whether the printed annual figure is admitted as it is, or scaled to a full-time year. |
| 7 | Victoria University international pages | Decide whether to store the international view of each course page (`/courses/<slug>/international`), and whether per-semester fees can be turned into annual fees. |
| 8 | Calgary and Lethbridge rebind | Approve rebinding the wrongly bound courses (186 at Lethbridge) and an abbreviation rule in the identity check. |

## 14. Amendment, 5 Oct 2026 (10:30): wave 8, programme complete, open decisions

**Source:** the wave run on the Platform Admin instructions of 5 Oct 2026 (04:49, 05:50, 06:12 and 06:32 fetch approved, 07:42 bigger waves). The open decisions have not been answered and stay on hold. Full entry: M2.4.7 runsheet set, entry "5 Oct 2026, 10:30 AEDT".

### 14.1 Fix to written-out rules (migration 20261005001470, PR #316)

- **What went wrong.** When the provider-facts job read an attached central page again, the parser's new proposal replaced ("superseded") the English rule that had been written out by hand from the same page. 10 written-out rules were lost this way (Adelaide University, AUT, Calgary, Lethbridge, Sydney, QUT, Otago, Victoria University of Wellington, University of Victoria, Alberta).
- **Fix.** A parser re-read no longer supersedes a rule written out from the same page. The 10 lost rules were put back as proposals. The md5 of the stored statement equals the migration file.
- **Why it matters.** Written-out rules are the main source of central English requirements (section 12.1), because most central pages give the parser no values.

### 14.2 Wave 8 results

Wave 8 covered the last target universities. Admission is on for 4 more (42 in all). 406 values were replaced with 0 errors, and 90 readings are excluded.

| University | Fields admitted | Intakes / fees / IELTS held = adapter | Held back |
|---|---|---|---|
| UBC (CA) | all | 196 / 216 / 220 | 11 short course-based programme fees, 4 wrong-campus pages |
| Southern Cross | all | 87 / 85 / 91 | 6 pages with a 2027 fee and no printed year |
| UNE | intakes, fees | 89 / 99 / — | Online-only courses, short-course totals, the 2027 fee list. 82 courses narrow to their international on-campus months |
| UNBC (CA) | intakes, fees | 3 / 2 / — | Most bindings are calendar pages |
| Athabasca (CA) | none | | Online only, no study permit (decision) |
| Notre Dame | none | | Website stored as nd.edu.au; the real site is notredame.edu.au (decision) |
| Fraser Valley, MacEwan, Kwantlen (CA) | none | | Wrong bindings and three title-matching gaps in the worker (decision). 2 Kwantlen median-earnings "fees" are excluded |

### 14.3 The programme at 10:30

Every one of the 57 target universities has now been through a wave. From the live database at 10:30 AEDT:

| Measure | Value |
|---|---:|
| Target universities | 57 (14,973 courses) |
| Adapters configured | 50 (42 admitting, 8 testing) |
| Universities with no adapter | 7 (Calgary has a draft only; Notre Dame, Fraser Valley, MacEwan, Kwantlen wait on decisions; Otago and Victoria University of Wellington wait on decisions from wave 6) |
| Courses holding intakes | 5,932, of which 4,947 equal the adapter reading and 15 come from a central rule |
| Courses holding English | 5,845, of which 3,204 equal the adapter reading and 1,297 come from a central rule |
| Courses holding fees | 3,941, of which 2,500 equal the adapter reading |
| Active course exclusions | 996 (994 on adapters, 2 at Kwantlen) |
| Central pages attached | 61 (37 key-dates, 24 English) for 41 universities |
| English rules waiting for review | 8 (3 written out from central pages: Wollongong, Victoria University, Alberta; 2 parser proposals from the wave 8 pages of Kwantlen and Notre Dame; 3 older parser proposals for providers outside the target list) |
| Calendar proposals waiting for review | 78 |

"Equal the adapter reading" means the held value's source is the adapter: the adapter read it and the overwrite admitted it, or it already matched. Values entered by hand are never changed.

**Note on English rules.** At 10:26:55 AEDT, 33 English rules were approved in one batch in Layer 4 Review, including 31 written out from central pages. That is why only 3 written-out rules were still waiting at 10:30, against the 36 listed as waiting in the runsheet entry. At about 10:30 the provider-facts job then read the 15 central pages attached in wave 8 and added new parser proposals; the figures above include them. At the time of this export the central-rule English counts above had not yet changed from 09:30, so the approved rules may not yet have been applied to courses.

### 14.4 Open decisions (10)

Costs are estimates. Firecrawl figures use the rate of the 4 Oct better-page run (386 credits for 194 courses, about 2 credits a course) unless a figure was already given.

| # | Decision | What it would change | Cost |
|---|---|---|---|
| 1 | RMIT intakes | 56 course pages list fewer intakes than the catalogue holds. If the page wins, intakes are admitted from RMIT pages and the extra held months are replaced. If not, held intakes stay and RMIT keeps admitting English and fees only. | Decision only; one overwrite run. No Firecrawl credits |
| 2 | Swinburne fees | Course pages show 2026 fees; the catalogue holds the 2027 schedule. Admitting the page fees would add 2026 rows (under the fee-year rule) beside the held 2027 ones. | Decision only; one overwrite run. No Firecrawl credits |
| 3 | Otago rebind | 152 Otago courses are rebound to `/courses/qualifications/<slug>` and the identity check accepts "(ABBR)". Otago could then get an adapter. | About 160 Firecrawl credits, plus a small identity-rule change |
| 4 | Victoria University of Wellington domain | Website and search domain change from vuw.ac.nz to wgtn.ac.nz, then Find runs again for 273 courses. | About 550 Firecrawl credits for the Find run |
| 5 | AUT fee levy | Decide whether AUT's annual fee is tuition only or tuition plus the student services levy. AUT fees can then be admitted. | Decision only; one overwrite run |
| 6 | Tasmania fees | Decide whether a printed annual fee for a standard year that is not 100 credit points is admitted as it is or scaled to a full-time year. Tasmania fees can then be admitted. | Decision only; scaling would need a small adapter change |
| 7 | Victoria University international pages | Store the international view of each course page and turn per-semester fees into annual ones (times two). VU intakes and fees could then be admitted. | About 280 Firecrawl credits to re-read the course pages, plus a small fee-conversion change |
| 8 | Rebind and title matching (Calgary, Lethbridge, Fraser Valley, MacEwan, Kwantlen) | Rebind wrongly bound courses (186 at Lethbridge) and fix three title-matching gaps in the worker, including an abbreviation rule for Canadian graduate pages. | Worker development, then a Find run for up to about 500 courses across the five universities (up to about 1,000 Firecrawl credits) |
| 9 | Athabasca | Athabasca is online only and no study permit is issued. Decide whether it stays a target for international students. If not, it is removed from the target list. | Decision only |
| 10 | Notre Dame domain | Website changes from nd.edu.au to notredame.edu.au, then Find runs again for 131 courses. | About 260 Firecrawl credits for the Find run |

## 15. Amendment, 5 Oct 2026 (11:35): wave 9 and the adapter apply fix

Source: M2.4.7 runsheet entry of 11:35. Figures in 15.4 were re-read from the live database at 11:47 AEDT.

### 15.1 Fix to applying adapters (migration 20261005001480, Pilot PR #317)

- Applying a text-only adapter no longer sends `needs_render` pages back for a Firecrawl read. Before the fix, UBC, NorthTec and Southern Cross spent Firecrawl credits this way.
- The adapter's page record now clears test-only extra fields (`adapter_extra`) when the new reading has none.
- The statement md5 (`1f3d0473f87374a289358ff2c48c4148`) equals the migration file. It is recorded live as version 20261005003319. At 11:47, PR #317 was still open, so `main` of the Pilot repo does not yet hold this file.

### 15.2 Wave 9 results

Wave 9 went beyond the target list of 57 to 25 more providers, mostly polytechnics and TAFEs. Admission is on for 22 of them (64 in all); NorthTec, the Open Polytechnic and TAFE NSW stay in testing. 778 values were replaced across 676 courses (717 previously blank), with 0 errors. 966 readings are excluded (1,962 in all).

| Provider | Fields admitted | Held back |
|---|---|---|
| UNSW | intakes, fees | 34 fees (graduate certificate totals, borderline graduate diplomas, 6 wrong bindings). The English rule failed the agreement check (catalogue holds 6.0) |
| Newcastle | English | Intakes (domestic first term), fees (browser only) |
| Torrens | intakes, English | 29 intakes and 20 English (single past starts, shared pages) |
| Southern Institute of Technology | intakes, English | All general-reader fees |
| Collarts | intakes | 12 intakes, 8 wrong catalogue fees |
| TAFE International WA | intakes, English | All fees (semester or whole-course totals) |
| TAFE Queensland | English, fees | Intakes |
| TAFE SA | all | 15 fees |
| Ara | all | 6 fees, 5 intakes, 3 English |
| Wintec | intakes | All fees (domestic), 3 intakes |
| NMIT | intakes, English | All fees (domestic) |
| EIT | intakes, English | 37 courses not offered to international students |
| Alphacrucis | intakes, English | Fees (domestic per-subject only) |
| Otago Polytechnic | all | 30 readings |
| Melbourne Polytechnic | all | 27 not-for-international, closed or old-registration courses |
| Charles Sturt | all | 15 fees (2026 tables, study abroad, Master of Philosophy), 2 intakes |
| Whitireia and WelTec | all | 8 fees, 1 intake |
| WITT | English, fees | Intakes (next intake only) |
| Toi Ohomai | English | Intakes (domestic view) |
| AIBT | all | 9 fees (52 weeks on the page, longer in the catalogue), 9 older CRICOS codes |
| Unitec | all | 13 readings |
| Manukau Institute of Technology | all | 9 pages not for international students, 6 fees |
| NorthTec, Open Polytechnic, TAFE NSW | none | 40 courses bound to the academic calendar / distance only / no usable fields |

### 15.3 Working rules from wave 9

- **No web fetching by agents.** At 10:54 the Platform Admin reported website permission prompts. They came from wave agents fetching university sites directly. From wave 10, agents do not fetch web pages. They read stored pages only.
- **Central pages are read on the server.** Central English and key-dates pages are attached to the provider (`pipeline.provider_fact_sources`, found by hand) and read by Firecrawl on the server, with evidence kept. About 40 were attached in wave 9 (113 in all at 11:47).
- **The requeue fix.** Applying a text-only adapter must not send pages back for a Firecrawl read (15.1). An adapter apply is a database step and should cost no credits.
- **Exclude by course, not by URL, when a page is shared.** Where one page serves several courses (shared specialisation pages, index pages, a course bound to another course's page), exclusions are made by course code or `course_id`. Excluding the URL would also hide the courses the page really belongs to.
- **Written-out English rules cover two levels only.** `public.admin_provider_english_propose` keeps only the undergraduate and postgraduate levels. New Zealand rules tiered by NZQF level, and VET rules, cannot be written out in full through it. Those rules wait for a change to the function or are entered by hand.
- **The NZQA Rule 18 table is a shared New Zealand English source.** NZQA's table of internationally recognised English proficiency outcomes (NZQA Rules 2025) is the English source for NorthTec and is attached beside the provider page for WITT and Whitireia and WelTec. It is one shared page, not a provider page, so a change to it affects every New Zealand provider that uses it.
- **No direct table changes.** Before the brief was tightened, wave 9 agents changed `pipeline.coverage_course_pages` directly: `next_read_at` at Charles Sturt (11 pages) and NorthTec (43 pages), and `adapter_extra` on 7 NorthTec rows. The brief now forbids direct table changes.

### 15.4 Live figures at 11:47 that differ from the 11:35 entry

- The 12 English rules written out in wave 9 (Whitireia and WelTec, Newcastle, Melbourne Polytechnic, Ara, EIT, Alphacrucis, TAFE Queensland, TAFE SA, NMIT, Collarts, TAFE International WA, Unitec) were approved at 11:35 AEDT, so none is still waiting in Layer 4 Review.
- Alphacrucis's parser proposal (7.0 for every level) was superseded at 11:35 by the written-out rule, not rejected.
- The Kwantlen and Notre Dame parser proposals and the written-out rules for Victoria University and Alberta were approved at 10:55 AEDT.
- 3 English proposals are still waiting (Wollongong, written out; Southern Queensland and JMC Academy, older parser proposals).
- 75 adapters are configured (64 admitting, 11 testing), with 404 patterns, 1,962 active exclusions (1,960 on adapters) and 113 central pages for 64 providers. All 75 configurations are in `docs/adapters/configs/`, checked against the live rows by md5.

### 15.5 Open decisions

The 10 open decisions in 14.4 are unchanged. Wave 10 (19 providers) uses no web fetching.

## 16. Amendment, 5 Oct 2026 (18:04): whole-course fee range and the 16:49 decisions

Source: M2.4.7 runsheet entry of 18:04 (covering 11:48 to 18:04). Adapter figures in 16.5 were re-read from the live database at 18:51 AEDT.

### 16.1 What changed between 11:48 and 18:04

- **International view (11:48, 13:02).** Adapters read the international student view of each course page. Where the view is set by the address, `page_view` holds the render setting, the address suffix and the pages it applies to (for example ACU `?type=International`, Curtin `?region=int`, Monash `?international=true`, La Trobe `#/fees?studentType=int&year=2027`). Where the page prints both views in plain HTML, `page_view` is empty.
- **Delivery (11:48).** Delivery is a new admitted field. Courses delivered 100% online are in scope.
- **Exit awards (15:22).** Exit awards are a new admitted field. Where the page gives no years, they are set by hand: Diploma 1 year, Associate Degree 2 years, Bachelor 3 years. The whole fee is the annual fee times the years.
- **Annual fee from a whole-course fee (15:34).** Where a page prints only a whole-course fee and its full-time years (`fee_total` and `course_years`), the annual fee is the total divided by the years. Courses under one year get no annual fee this way.
- **Per-credit fees (12:12, 13:25).** Athabasca's per-credit rate is turned into an annual fee at 30 credits a year.
- **Coverage page (15:36).** The Coverage page shows location, delivery and requirement columns.

### 16.2 Decisions of 16:49 (Platform Admin)

1. RMIT higher education figures labelled "(2027 total)" are treated as annual fees.
2. Exit award years follow the term: 6 months or 1 year.
3. Delivery is On campus or Online. Location gives the campus detail.
4. Requirement means the entry requirement plus any other requirements, such as a nursing uniform, visits or kits.

### 16.3 Whole-course fee range

Each university can show the range of whole-course international fees across its award courses: the cheapest and the most expensive course, with the course behind each end. The range is worked out from course data. It is shown on the university only after a Platform Admin publishes it.

**Decisions of 18:04 (Platform Admin).**
- Current fees come first. Where a course has no current fee, the CRICOS register fee is used as the fallback.
- Only award courses count.
- Ranges are published per university, not all at once.

**How a course's whole fee is worked out.** From current fees where they exist: a whole-course total printed on the course page, or the current annual fee times the course length in years. Otherwise the CRICOS register total is used. Each course in the list shows which way was used, and courses left out show why.

**Settings** (`pipeline.provider_fee_range_settings`, defaults set at 18:04):

| Setting | Default |
|---|---|
| Include courses under one year | Yes |
| Minimum number of courses for a range to count | 5 |
| Oldest fee year used | 2026 |
| Floor (whole fees below this are left out) | A$1,000 |
| Levels left out | Non-award levels (non-AQF awards, short vocational courses, foundation and school levels) |

**Parts** (migration 20261005001570, `cf247_provider_whole_course_fee_range`):
- `catalogue.provider_fee_ranges`: one row per university, with the low and high amounts, the courses and sources behind them, counts by source, skipped courses, the fee years used, any range set by hand, and the publish state.
- `security.course_years_from_text`, `provider_course_whole_fees_v1` and `provider_fee_ranges_refresh_v1`. The cron job `provider-fee-ranges-refresh` runs at :57 each hour.
- `public.admin_provider_fee_range` with actions read, refresh, publish, unpublish, set, release and settings. Every change needs a Platform Admin and a reason, and the reason is logged.
- UI v2.15.191: a "Whole-course fees" column in Coverage › Universities, a panel per university (publish, set by hand, work out again, course list) and a settings panel.

**First run.** 1,161 providers, 1,151 with a range, 845 meeting the minimum, none published. Example: RMIT A$13,500–A$290,400 from 499 award courses (24 page totals, 329 annual fee times years, 146 from the CRICOS register). The A$1 placeholder fees in the CRICOS register are left out by the floor (14 at Monash, 1 at La Trobe).

**Gaps.**
- UBC (256 courses) and Auckland (12 courses) have no course length, so no range yet.
- Vancouver Island shows the same whole fee on all 25 courses (one annual fee times 4 years). The adapter's course length needs checking.
- There is no public provider page in the repo yet. Published ranges stay in `catalogue.provider_fee_ranges`, ready for the public card.

### 16.4 Migrations and releases

- Migrations 20261005001490 to 20261005001570 (9 files) are applied, and each statement md5 equals the file in Pilot main (PR #318, merge `9f43815719df32f5d4b375115ce415064f30f3dd`, CI green). Pilot PR #317 (migration 20261005001480) is now merged too.
- Worker coverage-sweep v0.17.9 is deployed (version 94); all 8 files are the same as the repo.
- UI v2.15.191 (package 0.1.118).

### 16.5 Adapters at 18:51

- 76 adapters: 65 admitting and 11 testing. MacEwan has a calendar adapter in testing (level and credits only).
- 526 patterns, 2,161 active exclusions (2,159 on adapters) and 126 central pages for 64 providers. No English proposals are waiting.
- Of the central pages attached in wave 9, most now show a failed read (for example Newcastle, UNSW, TAFE NSW, TAFE SA, Collarts, EIT and the NZQA table). They are recorded in each configuration's `central_rules` as they stand.
- All 76 configurations in `docs/adapters/configs/` were checked against the live rows by md5.

## 17. Amendment, 5 Oct 2026 (20:30): hosted courses

Source: M2.4.7 runsheet entry of 20:30 (covering 19:01 to 20:30). Figures were re-read from the live database at about 20:40 AEDT.

### 17.1 The problem

Many courses have no course page of their own. Pathways (foundation, diploma, associate degree, bachelor) and awards inside a longer degree are often described only on another course's page, or not at all. Across the 76 adapters, 5,400 active courses have no confirmed page. Without a page, the adapter cannot read their fee, intakes or delivery.

A **hosted course** is a course whose values come from another course's page (its host). There are two kinds of link:

- **Award links** (`pipeline.course_exit_awards`): an exit award or nested award (for example a Graduate Certificate inside a Master's, or a Diploma inside a Bachelor's) linked to its parent degree.
- **Host pages** (`pipeline.course_host_pages`): a course whose page is shared with other courses (`shared_page`), whose only page is a double degree (`double_degree`), or whose page no longer exists (`no_public_page`).

### 17.2 Decisions (from read-only checks of RMIT, La Trobe, Monash and their colleges)

1. **Single-degree parent only, after a register check.** An exit or nested award takes its page, annual fee, intakes and delivery from its single-degree parent, never from a double degree. The link is used only after a register check confirms the fee fits. Evidence: at RMIT, 20 of 21 Graduate Certificates are half the Master's annual fee and 21 of 27 Graduate Diplomas equal it; at La Trobe, 33 of 39 pairs match.
2. **Pathway colleges stay separate.** RMIT UP, La Trobe College and Monash College stay as their own providers and are not counted in the university's whole-course fee range. Each will have a "leads to" link to the degree. That link is not built yet: `catalogue.provider_associations` is empty across the platform.

### 17.3 The register check

The check tests the fee the award would take from its parent against the CRICOS register. Settings (`pipeline.award_link_settings`, set from Coverage › Universities) allow 2% difference when both are for the same fee year and 6% when the register is one fee year behind. A link that fails the check is not applied unless it was set by hand. A field is copied only when it is admitted for that university.

### 17.4 How it works (migrations 20261005001580–1600)

- `security.exit_awards_detect_v2` finds exit awards from La Trobe and RMIT wording and nested awards by title, where there is exactly one single-degree parent. Links on double degrees are moved to the single degree.
- `security.exit_awards_apply_v2` applies links that pass (or were set by hand), field by field.
- `security.host_pages_detect_v1` and `apply_v1` propose and apply host pages. The cron job `host-pages-apply` runs at :42 each hour. Host pages are a new admitted field (`host_pages`), and `host_page` is a new identity basis in the Coverage admission country lists.
- `public.admin_host_pages` (read, detect, apply, confirm_page, no_page, off/on) and the `settings` action of `admin_exit_awards` are the admin controls. Changes are made by a Platform Admin.
- Migration 1600 fixes the apply step where fees are not admitted (Canberra).
- Worker coverage-sweep v0.17.10 gives an annual fee from a whole-course total for courses of 0.25 to 8 years.
- UI v2.15.192: hosted-courses panel and award link settings in Coverage › Universities, a host marker on each course, and the 'Host pages' admit field.

### 17.5 Results at 20:40

| Link | Total | Pass | Fail | No register entry | Applied |
|---|---:|---:|---:|---:|---:|
| Exit awards | 43 | 36 | 7 (set by hand) | 0 | 43 |
| Nested awards | 360 | 142 | 191 (held for review) | 27 | 38 |
| Shared pages | 55 | 28 | 26 | 1 | 0 |
| Double degrees | 169 | — | — | — | 0 |
| Pages gone | 262 | — | — | — | 0 |

Award links applied today: La Trobe 28, RMIT 18, Melbourne 14, Canberra 8, Griffith 7, Southern Cross 6. Host pages wait for a Platform Admin; `host_pages` is not yet admitted for any university.

### 17.6 RMIT Graduate Certificate fees

19 RMIT Graduate Certificates held the domestic figure as the international fee. The adapter now reads the international "(2027 total)" over 6 months. The overwrite at 20:20 replaced the 19 with the international annual figure, which equals CRICOS (for example Marketing 19,200 → 50,880). Three fees were added (084999G 55,680, 103208E 50,880, 084998J 50,880). No other RMIT fee changed.

### 17.7 Open items

- 191 nested awards failed the check. Many are different products with similar names, not parts of the degree (for example Melbourne Graduate Certificate in Management +114%, RMIT Diploma of Graphic Design −44%).
- Admit `host_pages` university by university.
- Build the pathway "leads to" links.
- La Trobe College Undergraduate Certificates: the whole-course fee is stored as annual.
- Monash diplomas are held under both Monash and Monash College.
- RMIT vocational courses under one year (Certificate IV in Accounting and Bookkeeping, Diploma of Accounting) are not read.

### 17.8 Note, 5 Oct 2026 (21:00): hand-bound pages and central English

- **Hand-bound pages are now admitted.** A course page bound by hand (identity 'manual') counts as a confirmed page for admission, like an adapter or host page. Before migration 20261005001610, 'manual' was missing from the identity lists, so 482 hand-bound pages at 26 universities (15 at Athabasca) were never admitted. The adapter overwrite runs every 10 minutes now admit them, 200 changes a run.
- **One bad central rule no longer stops the rest.** The hourly central English job failed on every run from 10:33 (61 failures) because one approved rule had no evidence. The job now takes the central page's evidence when the rule has none, skips a rule that still fails and records the error on it. The catch-up wrote 2,308 English requirements across 117 rules. 9 rules stay held until their central pages are read: Ara, Newcastle, TAFE Queensland, Alphacrucis, Melbourne Polytechnic, NMIT, EIT, Unitec and NZIST.
- **"Work out the fee range again"** only recomputes the fee range (section 16). Course values are admitted by the 10-minute runs, not by this button.

## Sources

- [Firecrawl billing: plans, concurrent browsers and credit costs](https://docs.firecrawl.dev/billing)
