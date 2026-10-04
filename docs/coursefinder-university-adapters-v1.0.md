# CourseFinder — University Adapters: Report, Decision and Design

**Version:** 1.0 · **Status:** CURRENT · **Date:** 4 October 2026 · **Decision:** 254 (recorded in `docs/coursefinder-design-reference-v1.4.md`)
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

| Wave | Universities | Adapter type |
|---|---|---|
| 1 | Australian National University, University of Melbourne, University of Technology Sydney, Macquarie University, University of Western Australia | Start dates (ANU, Melbourne, UTS) and page data (Macquarie, UWA) |
| 2 | Murdoch, La Trobe, Griffith, Bond, James Cook | Start dates |
| 3 | Charles Darwin, Central Queensland, Western Sydney, Sunshine Coast, Australian Catholic | Start dates and English |
| 4 | Simon Fraser, Mount Royal, Canterbury, Thompson Rivers, Vancouver Island, Royal Roads | Start dates and English (NZ and CA) |
| In parallel | 27 universities whose next step is Find pages first | One Firecrawl Find run: about 3,725 courses at about 2 credits each (about 7,500 credits). Re-evaluate them afterwards |

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

## 10. Decisions for the Platform Admin

1. Approve the wave plan (5 adapters per wave) and wave 1: ANU, Melbourne, UTS, Macquarie, UWA.
2. Approve one Find run for the 27 universities needing pages first (about 7,500 credits).
3. Choose the cheapest model to qualify for the builder (it must be pinned by name), and approve phase C.
4. Decide whether international fees read by an admitting adapter may be admitted (currently shown only).

## Sources

- [Firecrawl billing: plans, concurrent browsers and credit costs](https://docs.firecrawl.dev/billing)
