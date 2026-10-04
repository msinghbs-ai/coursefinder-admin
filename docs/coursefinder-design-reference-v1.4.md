# CourseFinder Platform Design Reference v1.4

**Status:** CURRENT — the single reference for CourseFinder design, guardrails and decisions  
**Date:** 28 September 2026  
**Change control:** CF-CHG-20260915-247  
**Supersedes:** Design Reference v1.3 (the single decision authority since 26 September 2026; earlier versions, Design Decisions v1.0–v1.36 and the Attribute & Admission Register v1.0 are history)  
**Detailed specifications it relies on:** Database Architecture (current version in the router), Navigation & Information Architecture (current version), M2.1 Layer 1–4 Architecture Contract v1.0

---

## 0. How to use this document

- This is the one place to find **what CourseFinder is designed to do, the rules it must keep, and why**. If another document disagrees with it, this document wins until it is amended.
- **Decisions keep their numbers forever.** A decision is never deleted; it is marked Superseded and points to what replaced it.
- **To change a guardrail:** propose the change, record it here as a new numbered decision (status Proposed), get the programme owner's approval (status Current), then implement under change control. Code and database changes must not run ahead of this document.
- Section 1–8 are the working design, written plainly. Section 9 is the complete decision log. Appendix A holds the early foundation principles.
- Status values: **Current**, **Proposed** (awaiting approval), **Superseded**, **Not assigned**.

---

## 1. What CourseFinder is

CourseFinder is an international-student course discovery and comparison platform. It aggregates providers, courses, campuses, regulatory facts, fees, intakes, entry requirements, scholarships and provider-level context (outcomes, student flow, rankings), keeps the evidence behind every value, and serves the result to consumers (the website, Wix and Zoho) through governed APIs.

It does **not** process applications, admissions decisions, offers or visas.

### Core principles

| # | Principle | Meaning in practice | Decisions |
|---|---|---|---|
| P1 | **Four layers, no fifth** | Every value comes from exactly one authority layer. Search and publication are downstream product states, not layers. | Contract §2, 144 |
| P2 | **Evidence first** | Everything fetched is stored once with its evidence. Later steps re-read stored evidence before fetching again. Every AI result and every human decision points to the evidence it used. | 81, 103, 146, 155 |
| P3 | **Deterministic before AI** | Rules and exact extraction run first. AI only interprets stored evidence when rules cannot, and never becomes canonical on its own. | 28, 98, 106, 124 |
| P4 | **People decide the unresolved** | Layer 4 is final. Every decision has a reason, is audited and can be reversed. | 15, Contract §11 |
| P5 | **Qualify before automating; activate separately** | A model, rule or provider route runs unattended only after it passes a defined check, and switching it on is its own deliberate step. | 30, 91, 125, 141 |
| P6 | **Never manufacture missing values** | Absent data stays absent and is labelled with the right completeness state. | Contract §5, §12 |
| P7 | **Protect consumers** | A change that could alter consumer output is proven not to, or is released as a deliberate contract change. | 83, 136, 137, 138 |
| P8 | **Spend is guarded** | Paid acquisition runs within budgets, reserves and concurrency limits that settings cannot bypass. | 78, 99, 141 |
| P9 | **Country-neutral core, country-specific edges** | The canonical model is the same for every country; each country adds its own sources, identifiers, mappings and completeness profile. | Contract §5, 143, 149 |
| P10 | **Simple screens** | One title per screen, one place for each job, plain language, no duplicated controls. | 116, 133, §7 |
| P11 | **Efficient by design** | Admit once, then re-check only on change or on the attribute's cycle. Jobs run no more often than their data changes, heavy jobs never overlap, rows are written only when something changed, and every new heavy job is sized before switch-on and watched after. Resource use is recorded and forecast. | 151, 152, 153, 154, 155 |

---

## 2. The layer model

Canonical flow: **Layer 1 → Layer 2 (acquire, keep evidence, extract) → Layer 3 (AI interprets evidence) → Layer 4 (a person decides) → completeness → search projection → publication → consumers.**

| | Layer 1 — Authoritative / Regulatory | Layer 2 — Deterministic acquisition & extraction | Layer 3 — AI interpretation of evidence | Layer 4 — Human resolution |
|---|---|---|---|---|
| **Purpose** | Stable identity and regulatory facts; provider-level statistics | Fetch first-party pages, keep evidence, extract facts by rule | Interpret stored evidence when rules cannot settle a fact | Final decision on anything unresolved or consequential |
| **Sources** | Country registers (CRICOS, NZQA, others), regulatory statistics (QILT, PRISMS), licensed files (QS, THE) | Provider websites via acquisition tools (Firecrawl first, direct HTTP fallback) | Layer 2 evidence only; never fetches on its own | Evidence from layers 1–3, plus the reviewer's own checked source |
| **Captures** | Providers, courses, campuses, registered costs, duration, delivery, locations; dataset editions | Page captures, extraction inputs, links; tuition, intakes, English, official link, description, scholarships | Structured proposals with exact quotes from the evidence | Decisions with reasons: approve, edit and approve, reject, not applicable, send back |
| **Admission** | Register record with identifier-first reconciliation; validated edition | Deterministic rule passes (for example the provider fee rule) | Only through a qualified model and validator, and never directly canonical | Decision applied to the canonical record, reversible |
| **Guardrails** | Layer 2 cannot redefine Layer 1 identity; editions kept per year | Acquisition success never authorises canonical change; budget, reserve and concurrency limits; per-provider qualification with a three-course identity check | Model qualification (two consecutive clean passes, all safety controls); activation is separate; no silent fallback across models | Reason required; batch actions previewed with typed confirmation; nothing hidden |
| **Where operators work** | Layer 1 — Operations (run, upload); Statistics & Rankings (view, compare); Administration (configure) | Layer 2 — Enrichment (coverage, onboarding, waves); Scraper Config (routes, automation limits) | Layer 3 — AI Interpretation (status, queues, qualification) | Layer 4 — Human Resolution (desk, batches, team and forecast) |

**Current state (28 September 2026):** Layer 1 is healthy for Australia (25,978 active CRICOS courses after 809 departures were retired on 27 Sep) and New Zealand (all 414 NZQA providers); register runs continue in the background, apply only changed records, retire departures and run automatically when the register changes within the accepted range (Decisions 155, 158). Layer 2 covers about 2% of Australian courses for provider-sourced attributes because most providers are not yet qualified; per-provider onboarding and automatic, evidence-ranked discovery now address that (Decisions 141, 146, 147). Layer 3 AI is paused because no model has qualified; approved provider rules admit fees without AI (Decisions 98, 106, 125). Layer 4 has 127 items waiting.

---

## 3. What is captured at which layer, and how it is admitted

One row per course attribute. "Correction" is the Layer 4 path a person uses. Coverage is measured from the consumer search document on 26 September 2026.

| # | Attribute | Authority | Source and capture | Admission rule | Correction (L4) | AU | NZ | Status / next action |
|---|---|---|---|---|---|---|---|---|
| 1 | Identity (code, title, provider) | L1 | Country register | Identifier-first reconciliation | Title and code overrides | 100% | 100% | AU should also record CRICOS in the identifier table (R3); courses that leave the register are retired with an audit record, never deleted (155) |
| 2 | Study level | L1 | Register level mapped to CourseFinder levels | Deterministic mapping | None needed | 100% | 95% | NZ unmapped levels |
| 3 | Field of study | L1 | Register field mapped to CourseFinder fields | Deterministic mapping | None | 100% | 0% | NZ baseline (143) |
| 4 | Locations | L1 | Register course locations | Register record | Campus fields | 99.9% | 0% | NZ baseline (143) |
| 5 | Delivery mode | L1 | Register | Register record | Delivery mode | 99.9% | 0% | NZ baseline (143) |
| 6 | Duration | L1 | Register (weeks) | Register record | Duration | Held | — | Not exposed to consumers (R2) |
| 7 | Registered tuition, non-tuition, total cost | L1 | Register costs | Register record | None (regulatory) | 99.3% | n/a | NZ has no equivalent register |
| 8 | Provider current tuition | L2 → L3 or provider rule → L4 | Official course page | Exact amount, audience, basis, year (95–97, 106, 131); one current record (132) | Tuition review | 1.5% | 0% | Grows with onboarding (141, 147) |
| 9 | Intakes | L2 | Official course page | Deterministic extraction with evidence | Being added (142) | 1.8% | 0% | Correction path to build (R9) |
| 10 | English requirements | L2 | Official course page | Deterministic extraction with evidence | Being added (142) | 2.0% | 0% | Correction path to build (R9) |
| 11 | **Academic entry requirements** | L2 | Official course page | **Not defined** | **None** | 0% | 0% | **No capture path; table exists but is empty (R1)** |
| 12 | Official course link | L2 → L4 | Provider site discovery | Discovery match; reviewer source for human links (111) | Course link review | 2.0% | 0% | Grows with onboarding |
| 13 | Course description | L2 | Admitted official course page only | Provider overview text, 200–1,000 characters, no AI rewriting, shown with attribution (140) | Description | 0% | 0% | To build (R7) |
| 14 | Scholarships | L2 + AI → L4 | Provider scholarship pages | Six publication conditions; published by a person in batches (139) | Scholarship scope | 0% exposed | 0% | 57 ready; batches to build (R8) |
| 15 | Publication status | L4 | Publication control | Pilot returns all records; production rule and gate (138) | Publication control | 0 published | 0 | Production step (R13) |

### Provider-level context

| Dataset | Authority | Source | Editions held | Rule | Status |
|---|---|---|---|---|---|
| QILT (four surveys) | L1 | Regulatory publisher | 1 each | One family, four surveys, one edition per year (134) | Stable publisher-page model to build (R6) |
| PRISMS | L1 | Regulatory publisher | 1 | As above (134) | As above |
| QS rankings | L1 | Licensed file upload | 2021–2027 (2024, 2025 duplicated) | Validated and applied automatically (128) | Merge duplicates (R5) |
| THE rankings | L1 | Licensed file upload | 2025, 2026, "2015" | As above (128) | 2019–2024 validated but not applied; check "2015" (R5) |
| ARWU, University Diversity Index | L1 | Planned | None | Planned (135) | — |

### Completeness states (every attribute, every country)

`present` · `source_null` (the source says nothing) · `not_applicable` · `zero` · `suppressed` · `not_yet_enriched` · `stale` · `ambiguous` · `rejected`. Coverage views must report these states, not just present or absent (R12).

---

## 4. Refinements to make (data capture and admission)

| # | Refinement | Why | Proposed handling |
|---|---|---|---|
| R1 | **Academic entry requirements have no capture path** | Required by the AU completeness profile; table empty | Define as a Layer 2 attribute from the admitted official course page with a Layer 4 correction path; decide consumer shape first |
| R2 | Duration held but not exposed | Consumers cannot filter or show it | Add to the search document in the next consumer contract version |
| R3 | ~~AU identity is not in the identifier table~~ | Done 28 Sep 2026 | CRICOS and NZQA provider and course codes recorded as country-scoped identifiers, kept in step with the registration tables (Decision 149) |
| R4 | Two AU-shaped consumer fields (`has_state`, `regulatory_tuition_state`) | Checked 28 Sep 2026: consumer outputs already use ISO subdivision codes and a neutral tuition basis; `state` inside regulatory tuition means status | Rename to `status` in the next consumer contract version, alongside the old name (Decision 149) |
| R5 | ~~Ranking editions~~ | Done 28 Sep 2026 | THE 2016–2024 applied (800 to 2,671 rows, exact expected counts); THE "2015" withdrawn (identical to 2021, 1,526 of 1,526 rows); QS 2025 restored to the correct load (the replacement workbook had region in the country column, 0 matches). One current edition per year: QS 2021–2027, THE 2016–2026 |
| R6 | ~~Statistics source model~~ | Done 28 Sep 2026 | Decision 134 built: edition rules from stable publisher pages, monthly discovery with a test read, Apply edition on the card, QILT as one card with survey tabs; first run found QILT SES 2025, applied 28 Sep 2026 (1,095 rows; 2024 retained) |
| R7 | Course description | No working path | Build Decision 140 |
| R8 | Scholarship publication | None published | Build Decision 139 batches |
| R9 | Intakes and English corrections | No Layer 4 path | Build Decision 142 |
| R10 | ~~Automation acts under a real admin's identity~~ | Done 26 Sep 2026 | System identity *CourseFinder Automation* (Pipeline Operator, cannot sign in) — Decision 150 |
| R11 | ~~Layer 3 AI paused~~ | Done 28 Sep 2026 | Decision 160: qualification accepts safe abstention; Mistral Small 3.2 qualified (10/10, 0 wrong, controls 5/5) and activated; dispatch and admission on |
| R12 | Completeness states not reported | Coverage shows present/absent only | Report the nine states in coverage views |
| R13 | Publication gate | Pilot returns unpublished records | Production step under Decision 138 |
| R14 | ~~Per-row verification drifted~~ | Done 28 Sep 2026 | CRICOS rows seen in a run are re-marked checked at most every 30 days; NZQA rows are re-marked by each run; stale NZ rows were departures (21 retired) |
| R15 | ~~Resource observability~~ | Done 26 Sep 2026 (v2.15.97) | Platform resources and cost panel, hourly recorder, alerts, cost model (Decision 153) |
| R16 | ~~Register ingestion overdue~~ | Done 26–27 Sep 2026 | CRICOS caught up (25,978 active; 809 departures retired); NZQA 414 of 414 providers; hard-coded register count removed (Package 9a); runs moved to the background (Decision 155, Package 9b) |
| R17 | Course-facts publishing window | The Aug–Nov window is recorded; the annual cycle is enforced through profile freshness, and re-acquisition is not yet steered into the window | Schedule the annual course-facts refresh wave inside the window |
| R18 | ~~Duplicate register evidence~~ | Done 28 Sep 2026 | 746 duplicate copies of register files removed (1.7 GB) after a byte-for-byte check of a sample; every record still points to an identical stored file (Decision 155 step 5) |
| R19 | ~~Register runs re-read every row~~ | Done 28 Sep 2026 | Change-based apply: a full CRICOS comparison takes about 10 seconds and only new and changed courses are applied (Decision 155 step 2) |
| R20 | ~~Departures and mergers handled by hand~~ | Done 28 Sep 2026 | Departures retired automatically at the end of each run, large departures held for approval, reactivation, provider review list (Decisions 155 step 6, 158) |
| R21 | ~~Database has outgrown memory~~ | Done 28 Sep 2026 | Discovery links kept once per provider (447,678 rows to 25,521); database 1,131 MB, the remainder being real data (Decision 157) |
| R22 | ~~Layer 1 run summary counts inactive registrations~~ | Done 28 Sep 2026 | Summaries count active records (25,978 CRICOS); retired shown separately |
| R23 | ~~Duplicate Layer 2 evidence~~ | Done 28 Sep 2026 (approved) | 8,461 duplicate copies of Layer 2 screenshots and page snapshots removed (4.47 GB, 1,848 groups) after 60 of 60 sampled copies matched the kept file byte for byte; every record keeps its own capture time and URL and points to an identical stored file. Evidence bucket 14 GB to 10 GB. Captures still create new copies, so duplicates will build up again until R26 |
| R24 | ~~NZQA runs re-fetch every provider~~ | Accepted 28 Sep 2026 | About 80 seconds weekly; now also the basis of NZQA departures (seen tracking). Revisit only if NZQA volume grows |
| R25 | ~~Provider departures review screen~~ | Done 28 Sep 2026 | Layer 4 → Provider departures: closed, merged into a successor (recorded association), or reviewed; Platform Admin decides with a reason |
| R26 | ~~Layer 2 duplicates build up again~~ | Done 28 Sep 2026 (approved) | New Layer 2 screenshots and page snapshots reuse an identical stored file of the same provider; each capture still gets its own record. Any upload left behind is removed by a daily clean-up (00:47 IST). Any future retention purge must only delete files that no record references |
| R27 | AU-specific columns in shared tables (before Decision 149) | pipeline.course_fact_source_records (course_cricos, provider_cricos), pipeline.course_fact_source_qualifications (provider_cricos), pipeline.scholarship_source_records (source_provider_cricos), catalogue.course_regulatory_observations (vet_national_code) | Add neutral columns (registration scheme and code) alongside, move readers across, then retire the old names; no rename in place |

---

## 5. Canonical data model and new countries

### What is already right
- **Country-neutral entities.** Providers, campuses, courses, fees, intakes, English requirements, links and scholarships are shared structures. Providers and campuses reference a **country and subdivision**, not a "state".
- **Identifiers are typed and country-scoped.** `course_identifiers` and `provider_identifiers` hold any scheme with its country (Canada already uses 30 course identifier types and `ircc_dli`).
- **Money carries its own currency.** Fees and scholarship awards store a currency code; countries have a default currency.
- **Country enablement switches.** Each country has catalogue status, student search, and provider, course and scholarship ingestion switches.
- **Mapping tables.** Study levels and study areas are mapped from each country's source vocabulary into CourseFinder's (`study_level_source_mappings`, `external_study_area_mappings`).
- **Completeness is per country.** `au-international-course-v1` and `nz-international-course-v1` profiles exist.

### Rules for adding a country
1. **Enable in stages** using the country switches: catalogue first, then ingestion, then student search.
2. **Layer 1 adapter** for the country's register(s), writing identity through the identifier tables with a registered identifier type. Never add country-specific columns to shared tables.
3. **Mappings** for study levels, fields and subdivisions before courses are exposed.
4. **Completeness profile** for the country: which attributes are required, optional or not applicable.
5. **Attribute register rows** marked for the country (authority, source, admission, correction) before any attribute is exposed.
6. **Currency and language** defaults set; fees always stored in the source currency.
7. **Statistics and rankings**: provider-level datasets are separate families per country and keep their own grain.
8. **Consumer check**: run the consumer API guard; new country data is additive and must not change existing countries' output.

### Rules for consumer API changes
- Consumers read only the **search projection** and **published** records (production, Decision 138), never canonical tables directly.
- **Additive first:** new fields are added; renames or removals happen only in a new contract version with a transition period.
- **Every database change touching consumer paths runs the guard** (Decision 136); a deliberate contract change records its expected differences.
- **Country-neutral field names** in new contract versions (R4).
- Reference data is **cached with a freshness limit** (Decision 137).

---

## 6. Guardrails register

| Area | Guardrail | Decisions |
|---|---|---|
| Identity | Layer 2 never redefines Layer 1 identity; identifiers are typed and country-scoped | Contract §12, 149 |
| Evidence | Evidence is stored once, bucket-relative, environment-portable; native evidence kept alongside normalised forms; an identical file (same source and content hash) is reused, not stored again; duplicate copies are removed only after proof, and evidence records are never deleted; discovery links are kept once per provider | 81, 103, 146, 155, 157 |
| AI | No model runs unqualified; qualification needs two consecutive clean passes and all safety controls; activation is separate; routing is pinned to qualified models | 30, 91, 94, 98, 125 |
| Admission | Acquisition success never authorises canonical change; provider rules are audited and time-limited; one current tuition per course | 97, 105, 124, 132 |
| Human decisions | Reason required; reversible; batch actions previewed with typed confirmation; person and rule decisions never confused | 15, 124 |
| Spend | Monthly budget, safety reserve, vendor concurrency, per-day and in-flight automation limits, no silent paid fallback | 78, 99, 141, 147 |
| Security | Security-definer functions pin their search path; no public execute on them; integration functions service-role only; secrets write-only | 77, 82, 145 |
| Consumers | API guard on every consumer-affecting change; production publication gate; consumer cutover separate from environment readiness | 83, 136, 138 |
| Releases | Visible version on every release; test-only commits may go straight to main; everything else by PR | 126 and earlier release decisions |
| Documentation | This reference is the decision authority; decisions are numbered, never deleted | 148 |
| Workload | Jobs run no more often than their data changes; heavy jobs never overlap (own minute slot, at least 7 minutes apart); rows written only on real change, verification markers at most once per 30-day cycle; new heavy jobs sized (rows and IO per run) before switch-on and watched after; stale runs closed after 3 days without progress | 151, 152 |
| Lifecycle | Each data type has a re-check cycle held as policy; configuration follows the policy through governed paths; overdue sources are flagged | 154 |
| Platform | Pilot runs on Micro compute; database size is kept below memory where possible; resource use recorded and forecast; production starts at Large | 153 |
| Automation identity | Automated actions run as *CourseFinder Automation* (Pipeline Operator), never as a person; no fallback to a person | 150 |
| Layer 1 runs | Runs are advanced by the database, never by a browser or a person's sign-in; one worker per run; temporary source errors retried up to 5 times (1, 2, 4, 8, 15 minutes) and then shown as the real error; a run is stopped after 40 background restarts; progress is measured by items reached; a run first compares the register with the last applied fingerprints and applies only new and changed records; departures are retired (never deleted) with an audit record and an exact count check, and more than 2% of the register (at least 50) waits for a Platform Admin; automatic ingestion only when the register changed and the variance is 'pass' | 155, 158 |

---

## 7. Screen and navigation rules

1. **One title per screen**, the page title (133).
2. **One place for each job:** *view and compare* (Statistics & Rankings, Catalogue), *run and upload* (Layer 1–4 operations), *configure* (Administration). Each card links to the other two; every link is checked.
3. **One card per dataset** with a year selector, not one per year or source (134). The card shows the newest edition that has data, with its year in the title; a newer edition without data shows as pending (156).
4. **No duplicated controls or names** on a screen; labels are unique enough for assistive technology and tests.
5. **Plain language:** no build codes, change-control numbers or internal jargon on screens (Package 5).
6. **Australian formats:** dates as 26 Sep 2026; AUD shown with its currency.
7. **Show only meaningful columns**; hide empty ones; one status vocabulary.
8. **Load what is visible:** summary first, detail on demand; every read under the 8-second limit.
9. **Old addresses keep working** (129).
10. **Screens are reviewed from captured screenshots** with personal data masked (130).

---

## 8. Open items

| Item | Status |
|---|---|
| Decision 149 — country-neutral identity and consumer fields | Identity delivered 28 Sep 2026; consumer renames go into the next contract version (R4) |
| Decision 159 — Layer 1 closed | Closed 28 Sep 2026 (v2.15.100); changes only by a new decision |
| Decision 155 — Layer 1 ingestion redesign | Current; all steps delivered (v2.15.98 and v2.15.99, 27–28 Sep 2026) |
| Refinements R1, R2, R4, R7–R9, R12, R13, R17, R27 | To schedule (R3, R5, R6, R10, R11, R14–R16, R18–R26 done or accepted) |
| Decision 160 — Layer 3 safe abstention | Current; Mistral Small 3.2 active from 28 Sep 2026; first fresh-item admission still to show for the M2.4.7 exit |
| Decision 161 — RMIT course refresh unblocked | Current; first run 28 Sep 2026; UQ and RMIT refresh weekly |
| Decision 162 — Course attributes and refresh | Current; definition v1.0; interim 90-day refresh live; build steps 1–6 to schedule |
| Decision 163 — Complete coverage, ongoing, reported daily | Current; admission of official page and English live (every 10 min); tuition via Layer 3 (Option A) to build; scholarships publishing under Decision 139 |
| Decision 164 — Production in customer-owned accounts | Current; go-live 3 Oct 2026 by project transfer (Mumbai) |
| Decision 165 — Consumer API presentation | Current; live 29 Sep 2026 (names, regional class, English summary) |
| Decision 166 — Australian university groups | Current; 26 members; admin and API filters live 29 Sep 2026 |
| Decision 167 — Scholarship sweep | Current; discovery on provider sites; 124 published by hand-run batches; 40 held after hand-check |
| Decision 168 — Intakes after the Layer 3 benchmark | Superseded by Decision 169 |
| Decision 169 — Layer 3 model routing | Current; intake and English via Claude Sonnet 4.6, tuition via Qwen3 235B 2507; 24 profiles retired |
| Decision 170 — Platform self-monitoring | Current; health check every 10 minutes; Platform health screen |
| Decision 171 — Simplified admin menu; sources side by side | Current; v2.15.107 |
| Decision 172 — Layer 3 cost-first cascade | Current; intake and English ladders running |
| Decision 173 — Layer 3 control screen | Current; v2.15.108 |
| Decision 174 — Tuition without a stated period: per year, flagged | Current; v2.15.109 |
| Decision 175 — Everything operated from the admin screens | Current; v2.15.110 |
| Decision 176 — Layer 3 on cheap models; stronger models only from Layer 4 | Current; v2.15.111; replaces the Sonnet step of Decision 172 |
| Decision 177 — Admin layout: daily work separate from setup | Current; Catalogue changes live in v2.15.112; Layer 1–4 merge awaits the screen review |
| Decision 178 — Priority queue set from the admin screens | Current; v2.15.113 |
| Decision 179 — Manual data first: CRUD, course pages not found, automatic publishing | Agreed; build order CRUD → course pages → publishing |
| Decision 180 — Course link recipes: find course pages by CRICOS code on the university's own site | Current; top 10 universities running (Pilot PRs #199, #200) |
| Decision 181 — A person's entry always wins (CRUD for courses and providers) | Current; v2.15.114 (Pilot PR #202) |
| Decision 182 — Scholarship course links decided once per scholarship | Current; v2.15.115 (Pilot PR #203) |
| Decision 183 — Layer 4 batch rules: one fee wording rule per university | Current; v2.15.116 (Pilot PR #205) |
| Decision 184 — Models & services: one on/off switch per model and service | Current; v2.15.118 (Pilot PR #207) |
| Decision 185 — Parse.bot removed completely | Current; v2.15.119 (Pilot PR #208) |
| Decision 186 — Edit in list for Courses and Providers | Current; v2.15.120 (Pilot PR #209) |
| Decision 187 — Reference sources: third-party sites managed in the admin and read by the platform | Current; v2.15.121 (Pilot PR #210) |
| Decision 188 — One home per setting for models and services | Current; v2.15.122 (Pilot PR #211) |
| Decision 189 — Duplicate screens merged | Current; v2.15.123–v2.15.124 (Pilot PRs #212, #213) |
| Decision 190 — Dashboard opens with "Waiting for you" | Current; v2.15.125 (Pilot PR #214) |
| Decision 191 — Fee rules, flagged values and Layer 3 Control easier to read | Current; v2.15.126 (Pilot PR #215) |
| Decision 192 — Layer 3 Work queue rebuilt; fetchers set per source | Current; v2.15.127 (Pilot PR #216) |
| Decision 193 — Layer 2 split into Overview, Fetch an area, History and Source profiles | Current; v2.15.128 (Pilot PR #217) |
| Decision 194 — Layer 4 review queue: Bulk decisions, scholarship scope decided on Course links | Current; v2.15.129 (Pilot PR #218) |
| Decision 195 — Edit in list for course facts, campuses and scholarships | Current; v2.15.130 (Pilot PR #219) |
| Decision 196 — Melbourne time, plain wording and counts that say what they cover | Current; v2.15.131 (Pilot PR #220) |
| Decision 197 — Older screens in the compact style | Current; v2.15.132 (Pilot PR #221) |
| Decision 198 — New Zealand course-page coverage started; Layer 3 limited to Australia until NZ admission is approved | Current; migrations 20261001160000–20261001163000 (Pilot PR #222) |
| Decision 199 — Course-link search for every Australian provider | Current; migration 20261001164000 (Pilot PR #222) |
| Decision 200 — Course links of every kind; who can apply | Current; v2.15.133 (Pilot PR #223) |
| Decision 201 — Course link refresh schedules for every country | Current; v2.15.133 (Pilot PR #223) |
| Decision 202 — New Zealand admission: NZ programme code or exact title, NZD only | Current; v2.15.133 (Pilot PR #223) |
| Decision 203 — Australian exact-title pages admit course links and intakes | Current; v2.15.133 (Pilot PR #223) |
| Decision 204 — Course-link search runs in the coverage-sweep worker | Current; migrations 20261001175000–20261001177000 (Pilot PRs #224, #225) |
| Decision 205 — Institution-level fee schedules, approved by a Platform Admin | Current; v2.15.134 (Pilot PRs #226, #227, #228) |
| Decision 206 — Layer 3 English and intake claims: no duplicate calls, under the time limit | Current; v2.15.134 (Pilot PR #227) |
| Decision 207 — The Firecrawl budget guard follows the balance Firecrawl reports | Current; migration 20261001179500 (Pilot PR #228) |
| Decision 208 — QS and THE universities linked to providers, kept linked for every country | Current; v2.15.135 (Pilot PR #229) |
| Decision 209 — The Platform guide lives in the app and is reviewed with every release | Current; v2.15.136 (Pilot PR #230) |
| Decision 210 — An approved fee schedule settles the flagged fees it answers | Current; v2.15.137 (Pilot PR #232) |
| Decision 211 — Scholarship eligibility and award scope are read from the provider page | Current; v2.15.138 (Pilot PR #233) |
| Decision 212 — Scholarship publishing: domestic only held back, "up to" values as maxima, savings per year | Current; v2.15.139 (Pilot PR #234) |
| Decision 213 — Coverage by country and university; fee schedules approved in bulk; course-page pattern requests retired | Current; v2.15.140 (Pilot PR #235) |
| Decision 214 — Live activity shows every layer's work; discovery keeps its own list | Current; v2.15.141 (Pilot PR #236) |
| Decision 215 — Scheduled workers sign in with one-time run passes; worker errors are shown | Current; v2.15.142 (Pilot PR #237) |
| Decision 216 — Every background function signs in with one-time run passes | Current; v2.15.143 (Pilot PR #238) |
| Decision 217 — New Zealand course pages are proven by NZQA title and level or NZQA number; NZ tuition in NZD | Current; v2.15.144 (Pilot PRs #239, #240) |
| Decision 218 — Fee periods are settled from the page wording; worker errors name their job | Current; v2.15.145 (Pilot PR #241) |
| Decision 229 — Intake check v1.3.0 is a separate contract, switched on only after qualification | Not qualified (both candidates 2 wrong-admitted on l3r-intake-h1); profiles paused |
| Decision 230 — Candidate models are qualified on the frozen holdouts before any cascade change | Current; MiMo v2.6 Pro is English step 3 (Pilot PR #252); Kimi K2 0905 not qualified; intakes: neither (Pilot PR #251) |
| Decision 231 — Course pages are matched from the university's own site map by a pinned model; the identity rule still decides | Current; live 2 Oct 2026 (Pilot PRs #253, #254) |
| Decision 232 — Third-party course directories are hints and counts only | Current; Hotcourses Canada and NZ captured 2 Oct 2026 |
| Decision 228 — Semester-only intakes are answered from the university's approved calendar | In progress; part 1 of 3 live (Pilot branch cf247-semester-months) |
| Decision 227 — English requirements from each university's own policy, approved per university | Current; v2.15.153 (Pilot PR #249) |
| Decision 226 — Quote failures are re-run once; a repeat failure needs a new intake check | Current; v2.15.153 (Pilot PR #249) |
| Decision 225 — Tuition comes from the regulator where it publishes it | Current; v2.15.152 (Pilot PR #248) |
| Decision 224 — Tuition reviews are settled against the page's international view | Current; v2.15.151 (Pilot PR #247) |
| Decision 223 — A fee follows the page's own domestic or international view | Current; v2.15.150 (Pilot PR #246) |
| Decision 222 — Fetch an area works on the course-page sweep; websites not found go to a person | Current; v2.15.149 (Pilot PR #245) |
| Decision 221 — A cascade task never falls back to a switched-off model | Current; v2.15.148 (Pilot PR #244) |
| Decision 220 — The old Layer 2 pipeline is retired; Canada is admitted like New Zealand | Current; v2.15.147 (Pilot PR #243) |
| Decision 219 — Every country's providers carry its own divisions; flagged values can be decided in bulk | Current; v2.15.146 (Pilot PR #242) |
| Production publication gate | Planned for P10 |

---

## 9. Decision log

Every numbered decision, in number order, with its current wording and the file it was last recorded in. Decision 26 was never assigned.

### Decision 1 — CourseFinder is not an admissions workflow
**Status:** Current · **Recorded in:** Design Decisions v1.19

CourseFinder serves international students/counsellors by aggregating and comparing Courses and related decision data. University applications, admissions decisions, offer letters and visa processing are outside the current platform.

Do not use **Search Admission** in new UI/docs. Use Search Eligibility/Projection/Visibility or Publication Eligibility as appropriate.

### Decision 2 — four enrichment layers only
**Status:** Current · **Recorded in:** Design Decisions v1.19

The UI and operating model recognise exactly four enrichment authority layers:

- Layer 1 authoritative/regulatory;
- Layer 2 deterministic acquisition/extraction;
- Layer 3 AI-assisted Evidence interpretation;
- Layer 4 human resolution.

Layer 4 is terminal for enrichment authority. Search and Publication are downstream product states, not further layers.

### Decision 3 — Course decision context may include non-Course-grain signals
**Status:** Current · **Recorded in:** Design Decisions v1.19

A Course detail/comparison experience may bring together Provider-, study-area-, state-, sector- or cohort-grain context, including QILT and PRISMS. Scope must be explicit; contextual facts must never be relabelled as direct Course facts.

### Decision 4 — two kinds of completeness
**Status:** Current · **Recorded in:** Design Decisions v1.19

Expose separately:

1. **Course factual completeness** — direct Course/international-student facts; and
2. **Decision-context completeness** — availability of contextual Provider/study-area/geography signals.

### Decision 5 — Layer 2 provider evaluation is outcome-based
**Status:** Current · **Recorded in:** Design Decisions v1.19

Provider trials compare evidence-backed completion, correctness, Evidence quality, latency, retries/quota/cost and Layer 3 fall-out—not merely HTTP success.

### Decision 6 — preserve native Evidence
**Status:** Current · **Recorded in:** Design Decisions v1.19

Store the provider-native format whenever supported. Derived normalised representations may coexist but must preserve lineage to native Evidence.

### Decision 7 — Layer 3 is Evidence-aware, not an alternate scraper
**Status:** Current · **Recorded in:** Design Decisions v1.19

Layer 3 consumes Layer 2 Evidence and may request better/additional Evidence through Layer 2. It does not hold acquisition-provider credentials or independently scrape arbitrary URLs.

### Decision 8 — Layer 4 receives the whole decision package
**Status:** Current · **Recorded in:** Design Decisions v1.19

Human Review receives the entity/field, unresolved reason, provider attempts, Evidence, deterministic candidates, Layer 3 suggestion/confidence when available, source/freshness and the explicit reason automation stopped.

### Decision 9 — Scholarship is related decision data
**Status:** Current · **Recorded in:** Design Decisions v1.19

Scholarships are first-class related data. Absence of discovery is not evidence of absence.

### Decision 10 — operational navigation stays simple
**Status:** Current · **Recorded in:** Design Decisions v1.19

Primary Admin navigation remains grouped around Overview, Catalogue, Data Enrichment/Operations, Insights, Quality & Review and Governance/Platform. Technical source/provider/job controls should be progressive drill-down rather than routine top-level clutter.

### Decision 11 — required gaps remain visible; optional empty sections are suppressed
**Status:** Current · **Recorded in:** Design Decisions v1.19 · Supersedes a broader rule in v1.0 (see its text).

Course Detail must keep **required and decision-critical Course attributes visible even when empty**, because operators need to understand completeness gaps and the next enrichment layer.

Optional/non-required PIM collections do not need an empty blade in the routine Course drawer. Academic Options, Categories, Collections and similar optional groups may be suppressed when empty and appear automatically when populated or when a dedicated configuration/review workflow is opened.

An unresolved required field uses a neutral `—` placeholder plus its governed field-state trail. Avoid repeating vague prose such as `Not captured`.

This supersedes the broader v1.15 wording that every governed attribute must always occupy visible Course-detail space. Requiredness and decision relevance now determine routine visibility.

### Decision 12 — layer strike-through means an actual field-specific attempt
**Status:** Current · **Recorded in:** Design Decisions v1.19

Layer badges are an authority/progress trail, not decoration.

- `L2` may be struck only when Layer 2 actually attempted that field/domain and failed to resolve it safely.
- `L3` may be struck only after real Layer 3 execution for that field/domain is persisted and unresolved.
- A Course-level job result is not sufficient to strike a layer for every Course field.

Current deployed schema has no accepted Layer 3 execution/persistence table. Therefore M2.1 may show `L2 struck → Awaiting L3`, but must not invent `L3 struck → L4` for enrichment facts until Layer 3 exists.

### Decision 13 — direct Layer 4 fields are distinct
**Status:** Current · **Recorded in:** Design Decisions v1.19

Some PIM-curated fields may legitimately start at Layer 4. In the routine Course drawer an empty optional direct-L4 group may remain suppressed to reduce clutter; its L4 input surface belongs in the dedicated edit/review mode. The UI must not pretend Layers 2 and 3 failed when those layers never owned the field.

### Decision 14 — Layer 1 gaps are source corrections, not Layer 4 overrides
**Status:** Current · **Recorded in:** Design Decisions v1.19

Provider identity, CRICOS Course identity, regulatory observations and other Layer 1-authority facts remain governed by Layer 1/source correction. A human operator may review and initiate correction, but the normal Layer 4 enrichment editor must not silently overwrite Layer 1 truth.

### Decision 15 — Layer 4 is terminal but typed
**Status:** Current · **Recorded in:** Design Decisions v1.19

Layer 4 controls appear only after the field is genuinely ready for Layer 4, or when revising a prior Layer 4 resolution.

Safe scalar Course fields may use a bounded inline editor with mandatory reason/audit. Compound semantic facts require typed editors:

- tuition: amount, currency, year, audience, basis/scope;
- English: test, overall/component scores, notes/scope;
- intakes: label/year/date/deadline/campus/status.

Do not replace these with generic free-text editing.

Layer 4 resolution does not imply Publication approval and must not auto-write Search visibility.

### Decision 16 — completeness does not publish
**Status:** Current · **Recorded in:** Design Decisions v1.19

100% completeness may support Publication Eligibility filtering, but never auto-publishes. Publication remains an explicit governed state transition with eligibility, preview, approval/audit and consumer verification.

### Decision 17 — Course Detail uses a consistent decision-card hierarchy
**Status:** Current · **Recorded in:** Design Decisions v1.19

Routine Course Detail presentation is standardised around:

1. fixed identity/status overview;
2. Course description;
3. **Fees & entry requirements** — Fees beside Intakes/English on desktop and stacked responsively on narrow viewports;
4. Locations;
5. populated optional course information;
6. Regulatory facts;
7. Evidence;
8. Operational state.

Field labels, values and metadata use consistent typography. Monetary figures remain deliberately prominent and bold. Core identity/status stays fixed so user customisation cannot remove navigational context.

Users may reorder the major decision cards below the fixed overview/description. Reordering is a presentation preference only and never changes canonical data, completeness, layer state or publication.

### Decision 18 — per-user, per-screen working state persists until explicitly cleared
**Status:** Current · **Recorded in:** Design Decisions v1.19

Catalogue working context should survive normal navigation, reload and logout/login on the same browser so administrators do not repeatedly rebuild filters while investigating data.

The current Pilot stores interface preferences in browser `localStorage`, namespaced by signed-in user and screen. It may persist:

- catalogue search text;
- selected filters;
- advanced-filter visibility;
- Course Detail decision-card order.

The screen **Clear** action explicitly removes the saved search/filter state. Course section order remains until the user rearranges it or resets the browser preference.

This storage contains interface preferences only—no passwords, API keys, service-role tokens, raw Evidence content or canonical facts. Browser-local persistence is intentionally chosen to avoid adding RPC/database latency. Cross-device preference synchronisation may be introduced later through a dedicated user-preferences contract if operationally justified.

### Decision 19 — large filter option domains are paged server-side
**Status:** Current · **Recorded in:** Design Decisions v1.19

Operator-facing filter/dropdown/combobox option domains must not be eagerly loaded in full when they can exceed 10 values.

The accepted pattern is:
- maximum normal option page size: 10;
- server-side search/paging for dynamic or growing domains;
- response carries total and has-more/cursor state rather than the complete option universe;
- a selected value remains labelled when it is outside the current option page;
- Course result pagination and filter-option pagination are independent concerns.

Small fixed enums of 10 values or fewer may remain local/static.

The Course catalogue is the first mandatory implementation because Provider, State/Region, Study level, Field and Delivery are large/growing dimensions.

### Decision 20 — dependent filters remain scope-aware
**Status:** Current · **Recorded in:** Design Decisions v1.19

Parent/child filter relationships must be resolved from current governed scope.

Examples:
- Country → State/Region;
- Country + State/Region → Provider;
- Layer 2 Country → State → included universities;
- Country → University.

Changing a parent scope clears any child value that may no longer be valid.

Layer 2 State scope represents all governed universities and eligible Courses in the selected subdivision. The UI must visibly enumerate those included universities, paged 10 at a time, while the State remains the single execution scope.

### Decision 21 — touch/tablet filter opening must not summon the keyboard
**Status:** Current · **Recorded in:** Design Decisions v1.19

Shared filter popovers must not use unconditional input auto-focus.

On coarse-pointer/touch-first devices:
- opening a filter keeps focus on the trigger/control;
- the search field receives focus only after the operator explicitly taps it;
- paging/options remain usable without moving the cursor unexpectedly or opening the on-screen keyboard.

Fine-pointer desktop environments may focus the search input automatically where useful. Keyboard accessibility remains mandatory.

### Decision 22 — filter performance is a platform-wide reusable UI contract
**Status:** Current · **Recorded in:** Design Decisions v1.19

The paged-filter component/endpoint pattern is shared platform infrastructure, not a Course-only special case.

Any M2 workstream that introduces or materially changes a large Provider, University, Campus, source, job, Evidence-type or reference-data selector must use the same bounded option-loading contract before its next acceptance gate.

Reference: Milestone 2 Execution Addendum A10.

### Decision 23 — contextual insights belong in the entity decision journey
**Status:** Current · **Recorded in:** Design Decisions v1.19

Standalone QILT/PRISMS/country-equivalent and Scholarship workspaces remain valid for ingestion, QA, source analysis and bulk filtering, but they are not sufficient as the only operator presentation.

Provider and Course detail must surface relevant decision context through generic semantic groups:
- Student outcomes / benchmarks;
- International student flow;
- Scholarships / funding.

The UI must preserve the actual source grain. Provider, regional, state, sector or study-area observations shown from Course detail remain explicitly contextual and must never be relabelled as Course facts. Missing direct relationships are represented as not mapped/not available, not inferred.

Scholarships are related by governed scope. Direct Course scope is strongest; compatible study-level/field/campus/Provider scope may support contextual eligibility. Explicit exclusions override broad inclusion. Contextual relevance is not proof of student eligibility.

Country-specific labels such as QILT and PRISMS are source labels, not country-specific blade architecture. Equivalent accepted source families for NZ/CA/GB/US/IE/DE use the same generic decision groups.

Reference: Milestone 2 Execution Addendum A12.

### Decision 24 — website screenshot Evidence is secondary visual Evidence
**Status:** Current · **Recorded in:** Design Decisions v1.19

Layer 2 website acquisition may retain a screenshot returned by an accepted provider such as Firecrawl, but source/raw HTML/JSON Evidence remains authoritative. Screenshot Evidence must retain lineage to the provider attempt/source Evidence and use the private Evidence access boundary for thumbnail/full viewing.

A screenshot may improve operator traceability and demo comprehension; it does not independently authorise canonical, Search or Publication mutation and must not be treated as a manufactured Course fact.

### Decision 25 — routine Layer 2 routing is explicit but remains one-action
**Status:** Current · **Recorded in:** Design Decisions v1.19

The normal operator journey exposes one primary Layer 2 action and visibly explains the governed routing sequence `Direct HTTP → Firecrawl → governed fallback → Evidence`. Advanced provider configuration remains drill-down. A hidden launcher must not be restored for UAT or demo convenience.

Reference: Milestone 2 Execution Addendum A13.

### Decision 26
**Status:** Not assigned (the number was skipped when decisions were first numbered).

### Decision 27 — Layer 3 operator presentation is Evidence-led
**Status:** Current · **Recorded in:** Design Decisions v1.24

The normal Layer 3 operator journey must present the governed chain:

`Evidence → model/profile → result/confidence/provenance → human-review state`.

Credentials remain write-only/private and must not be exposed in routine UI.

### Decision 28 — AI interpretation cannot silently become canonical truth
**Status:** Current · **Recorded in:** Design Decisions v1.24

Layer 3 consumes governed Layer 2 Evidence and may produce interpreted candidates, confidence and provenance. It cannot directly rewrite Layer 1/2 canonical values. Low-confidence/no-candidate results fall out to Layer 4.

### Decision 29 — screenshots are visual Evidence, not AI text input
**Status:** Current · **Recorded in:** Design Decisions v1.24

Rendered screenshot Evidence may be shown as governed visual context/thumbnail, but is excluded from Layer 3 text input. Native/textual Evidence remains the interpretation substrate.

### Decision 30 — model qualification is an operator/runtime gate
**Status:** Current · **Recorded in:** Design Decisions v1.24

A Layer 3 model profile must be enabled, unpaused and benchmark-passed for its task class before execution. The accepted source-pattern profile is pinned to `nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free` and passed the unchanged 4/4 Provider + 3/3 control threshold.

### Decision 31 — retries, fallback and zero-call paths are visible governance
**Status:** Current · **Recorded in:** Design Decisions v1.24

The UI/runtime must preserve:
- zero-call paths for resolved, unchanged or active duplicate work;
- bounded retries with attempt telemetry;
- fallback only to explicitly configured qualified profiles;
- external-call/token/latency/cost outcomes under A14;
- replay/revalidation provenance.

### Decision 32 — cross-layer and consumer boundaries stay explicit
**Status:** Current · **Recorded in:** Design Decisions v1.24

Layer 4 remains terminal human enrichment authority. Search, Publication, Website and Zoho are separately governed downstream consumers. M2.4.3 acceptance does not authorise their automatic admission/cutover.

### Decision 33 — Repository navigation registry is canonical UI authority
**Status:** Current · **Recorded in:** Design Decisions v1.24

The CourseFinder Admin primary navigation must follow the navigation registry implemented in the authoritative Pilot repository.

Canonical implementation:
- `src/mature-main.jsx::NAV` — primary menu authority;
- `src/mature-main.jsx::HIDDEN_ROUTES` — backwards-compatible deep routes only;
- `src/mature-main.jsx::PAGE_META` — canonical page labels/descriptions;
- `src/mature-main.jsx::routeFromHash()` — supported route resolution.

Future UI/UX work must extend this registry rather than create a parallel top-level menu inside feature components.

Administration remains the single normal entrypoint for configuration/settings under A20. Routine Catalogue, Insights, Data Quality and Operations workspaces must remain task-first. Important Links/Dates may remain operational reference registries; configuration such as Sources, PIM Attributes, Scheduling policy, Onboarding templates, acquisition/provider settings, AI model settings and platform diagnostics belongs under Administration.

Hidden routes may be retained for compatibility, but they do not establish primary navigation authority. Floating launchers and overlays are secondary affordances only and cannot be the sole path required by permanent UAT.

Any change to the canonical navigation must update repository implementation, A20 or its successor, this design-decision baseline, desktop/tablet UAT and release notes where user-visible. Repository/runtime truth takes precedence over stale screenshots or older documentation.

### Decision 34 — Layer workspaces are permanent canonical routes, not floating applications
**Status:** Current · **Recorded in:** Design Decisions v1.24

The final Pilot information architecture places four permanent sibling workspaces under Operations:

1. Layer 1 — Authority
2. Layer 2 — Enrichment
3. Layer 3 — AI Interpretation
4. Layer 4 — Human Resolution

These routes are rendered inside the canonical CourseFinder shell. Visible floating launchers, independent feature roots and modal-only primary journeys are not permitted for these Layers.

Layer 3 and Layer 4 are separate operator workspaces. A combined tabbed Layer 3/4 dialog may not be the canonical route.

The Pilot is a demonstration of intended final placement. Navigation/layout experiments must not be exposed as competing user journeys in the normal shell. Feature experimentation may occur behind development controls, but accepted Pilot UI must use the governed navigation architecture before user-facing validation.

Operational information-density standard:
- normally 3–5 primary KPIs;
- one main action group for the current state;
- visible blocker/fall-out guidance;
- recent progress/outcomes compactly presented;
- Evidence one or two clicks away;
- raw IDs, diagnostics, credentials and provider/model configuration progressively disclosed or centralised in Administration.

Feature modules may export embedded workspace components, but `src/mature-main.jsx::NAV` remains the primary menu authority. Permanent UAT must navigate through canonical routes and assert absence of floating Layer launchers.

### Decision 35 — Canonical navigation cannot be rewritten by post-render browser adapters
**Status:** Current · **Recorded in:** Design Decisions v1.24

The canonical `src/mature-main.jsx::NAV` registry is rendered directly by React and remains authoritative after render.

Browser-side compatibility scripts, MutationObservers or feature entrypoints must not:
- rename canonical groups;
- hide canonical menu items and inject replacements;
- introduce an alternate menu hierarchy;
- route a Layer menu entry through Settings or another legacy workspace;
- continually reconcile an alternate DOM navigation model.

The historical `src/data-acquisition-nav-entry.js` behaviour is explicitly rejected as a Pilot architecture pattern. It may remain only as unloaded historical source pending deletion.

Users & Roles and other privileged configuration belong under Administration rather than being injected into Operations.

Permanent deployed UAT must assert the absence of legacy DOM-navigation markers and replacement menu groups.

### Decision 36 — Layer 2 header treatment is the shared Layer workspace visual hierarchy
**Status:** Current · **Recorded in:** Design Decisions v1.24

Layers 1–4 use one embedded dark-navy workspace header architecture with violet/indigo eyebrow, white Layer title, muted explanatory text and dark utility actions. Layer identity is expressed by wording/iconography rather than unrelated header colour systems. The header is part of the canonical route and cannot become a floating or experimental banner.

### Decision 37 — Evidence preview is artifact-type aware; screenshot linkage is exact-attempt only
**Status:** Current · **Recorded in:** Design Decisions v1.24

Evidence type and MIME/format are separate governed attributes and must remain visible/filterable.

A screenshot is visual Evidence only. It may be rendered:
- as the selected screenshot/image artifact itself; or
- as a secondary visual for an HTML/source artifact only when the screenshot is linked to the exact same Layer 2 acquisition attempt through non-null Evidence IDs.

Null/empty-string matching, Provider/source-wide screenshot inheritance and screenshot substitution for JSON/API/regulatory/workbook/PDF evidence are prohibited.

JSON/text artifacts use their own bounded private-object preview when browser-safe. PDF uses governed signed preview. Workbook/archive formats retain explicit type/download treatment. HTML remains the extraction/source artifact and may show an exact same-attempt screenshot only as secondary visual corroboration.

Permanent deployed UAT must prove JSON does not inherit website screenshots, exact HTML relations remain available, and screenshot Evidence previews its own image.

### Decision 38 — Environment state is explicit
**Status:** Current · **Recorded in:** Design Decisions v1.25

Pilot qualification and Production enablement are separate. Source capabilities, acquisition providers and AI profiles require environment-specific approval.

### Decision 39 — Capacity and integrity are distinct
**Status:** Current · **Recorded in:** Design Decisions v1.25

Capacity reporting must separate DB size, Evidence storage utilisation and temp spill from orphan/missing Evidence lineage findings.

### Decision 40 — Retention is dry-run first
**Status:** Current · **Recorded in:** Design Decisions v1.25

Regulatory Evidence, accepted source history, Layer 4 decisions, publication decisions and material audit remain excluded from routine purge. Future purge requires bounded deletion and post-delete integrity checks.

### Decision 41 — Blocking is reversible governance state
**Status:** Current · **Recorded in:** Design Decisions v1.25

Operational, publication, Search and data-quality-quarantine blocks are independent append-only Layer 4 decisions. Each action retains actor, reason, time, optional review/expiry and supersession history. Blocking does not delete source data or rewrite canonical values.

### Decision 42 — Onboarding extends existing profiles
**Status:** Current · **Recorded in:** Design Decisions v1.25

Scraper onboarding extends existing Layer 2 acquisition-provider configuration. AI onboarding extends existing Layer 3 model/task profiles. Environment enablement is additional to credentials, benchmark and quota configuration rather than a duplicate profile store.

### Decision 43 — UAT and workload profiles are first-class
**Status:** Current · **Recorded in:** Design Decisions v1.25

Release governance must distinguish accepted Pilot domains from Production gates not yet run. Performance evidence must identify steady-state serving, scheduled refresh, bulk ingestion or representative concurrent workload while preserving the existing hard budgets.

### Decision 44 — QS/THE are Provider context, not Course quality
**Status:** Current · **Recorded in:** Design Decisions v1.27

QS and Times Higher Education World University Rankings attach at institution/Provider grain. A Course blade may show inherited Provider ranking only when labelled explicitly as Provider context.

### Decision 45 — Ranking systems remain independent
**Status:** Current · **Recorded in:** Design Decisions v1.27

QS and THE ranks/scores must be displayed separately. Do not calculate a combined “world rank” or directly compare a QS ordinal with a THE ordinal as though they shared one methodology.

### Decision 46 — Historical ranking is editioned and methodology-aware
**Status:** Current · **Recorded in:** Design Decisions v1.27

The Admin may display up to 5–10 years of history, but methodology/revision boundaries must remain visible. Banded ranks stay banded; missing/unranked is not zero.

### Decision 47 — Ranking provenance is one-click context
**Status:** Current · **Recorded in:** Design Decisions v1.27

Latest rank cards and comparison rows must expose edition, publisher source and methodology/provenance with minimum navigation. Ambiguous Provider matches show unresolved rather than guessing.

### Decision 48 — Ranking filters/sorts require explicit consumer semantics
**Status:** Current · **Recorded in:** Design Decisions v1.27

A ranking filter or sort is permitted only after consumer admission and must state ranking system + edition. Ranking is never an undisclosed Search relevance boost.

### Decision 49 — Statistics & Rankings is the verification hub
**Status:** Current · **Recorded in:** Design Decisions v1.27

QILT, PRISMS, QS, THE and future admitted statistical datasets are organised through one Statistics & Rankings workspace for coverage, period availability, observation review, mapping and Evidence verification.

### Decision 50 — Compare is a first-class workflow
**Status:** Current · **Recorded in:** Design Decisions v1.27

Compare is exposed directly in primary navigation. Entity selection is followed by dataset selection and period/edition selection. Users are not forced to accept every available metric or the latest year.

### Decision 51 — Manual historical publisher files reuse governed Evidence
**Status:** Current · **Recorded in:** Design Decisions v1.27

When automated acquisition is blocked by publisher access controls, an authorised publisher artifact may be uploaded through a privileged Sources & Imports flow into the existing private Evidence store. Upload, parse, reconcile and apply are separate states.

### Decision 52 — Detail blades summarise and deep-link
**Status:** Current · **Recorded in:** Design Decisions v1.27

Provider/Course blades show concise contextual statistics and ranking summaries with View Statistics and Add to Compare actions. They do not duplicate the full statistics workspace.

### Decision 53 — Navigation separates insights from operations
**Status:** Current · **Recorded in:** Design Decisions v1.27

Primary groups become Overview, Catalogue, Statistics & Insights, Data Operations, Quality & Review and Administration. QILT/PRISMS detailed pages remain available as dataset drill-downs rather than competing top-level concepts.

### Decision 54 — Provider Contacts is a first-class Catalogue module
**Status:** Current · **Recorded in:** Design Decisions v1.28

Provider Contacts is not buried in generic Evidence or Layer 2 diagnostics. It is a dedicated Catalogue workspace linked many-to-one to canonical Providers.

### Decision 55 — Managed contacts do not replace A15 observations
**Status:** Current · **Recorded in:** Design Decisions v1.28

A15 contact observations remain source/Evidence history. Operator edits apply to a stable managed contact and append a new managed version/resolution instead of rewriting source observations.

### Decision 56 — Contact deletion is reversible
**Status:** Current · **Recorded in:** Design Decisions v1.28

Routine delete is soft-delete with actor/time/reason and retained history. Deleted contacts remain filterable and can be restored. Hard delete is not a normal PIM action.

### Decision 57 — Contact import is dry-run first
**Status:** Current · **Recorded in:** Design Decisions v1.28

Mass imports are private-Evidence-backed, hash-addressed and idempotent. Provider mapping, duplicate matching and create/update/restore/skip/conflict actions are previewed before APPLY.

### Decision 58 — Provider matching cannot rely on source names alone
**Status:** Current · **Recorded in:** Design Decisions v1.28

Legacy, merged and alternate institution names must resolve through governed Provider aliases/crosswalks to canonical `provider_id`. Ambiguous Provider matches remain review items.

### Decision 59 — Contact management uses a dense decision grid
**Status:** Current · **Recorded in:** Design Decisions v1.28

The module provides server-side search/filter/sort and operator-controlled column order/visibility/width, with a detail drawer for source, verification, history and audit context.

### Decision 60 — Import/export belongs in the module
**Status:** Current · **Recorded in:** Design Decisions v1.28

PIM/Data Admin can import and export from Provider Contacts without navigating to a separate generic ingestion tool. The workflow still reuses the governed private Evidence/import infrastructure and retains audit history.

### Decision 61 — Contact consumer publication remains separate
**Status:** Current · **Recorded in:** Design Decisions v1.28

Admin availability does not imply Search, Website/Wix or Zoho admission. Any external contact projection requires a separately governed consumer contract.

### Decision 62 — Provider logos are governed assets
**Status:** Current · **Recorded in:** Design Decisions v1.29

Provider logos are Layer 2 Provider assets linked to canonical Provider identity. The UI displays an approved primary asset; discovered candidates remain reviewable with Evidence.

### Decision 63 — Logo is presentation, not identity
**Status:** Current · **Recorded in:** Design Decisions v1.29

A visual/logo match cannot create, merge or rename a Provider. Provider resolution occurs first.

### Decision 64 — Scholarship discovery is multi-view
**Status:** Current · **Recorded in:** Design Decisions v1.29

Scholarships should support Scholarship, Provider/university and Course views. Provider cards can show logo, current Scholarship count, award summary and applicable study levels; Course views show only resolved applicable Scholarships.

### Decision 65 — Shared acquisition is visible operationally
**Status:** Current · **Recorded in:** Design Decisions v1.29

Layer 2 operations distinguish new vendor acquisition from reused Evidence/fan-out. Operators should be able to see provider route, content change, shared-fetch reuse and cost/vendor units.

### Decision 66 — Parse.bot remains disabled until qualification
**Status:** Current · **Recorded in:** Design Decisions v1.29

A configuration slot may exist without endpoint/credential. UI must not imply it is usable until connection, security, cost and extraction UAT pass.

### Decision 67 — Refresh follows volatility
**Status:** Current · **Recorded in:** Design Decisions v1.29

Routine full refreshes are not daily by default. Course facts are monthly, Scholarships weekly, Provider logos quarterly, with lighter checks and source-specific acceleration around consequential dates/changes.

### Decision 68 — Commercial aggregators are reconciliation by default
**Status:** Current · **Recorded in:** Design Decisions v1.29

Hotcourses, IDP and similar platforms may inform completeness/UX comparison. Their data is not automatically imported as canonical CourseFinder Scholarship truth without explicit source/reuse approval.

### Decision 69 — Catalogue and detail are different Scholarship grains
**Status:** Current · **Recorded in:** Design Decisions v1.30

A Provider catalogue/search page is not a Scholarship. Admin operations must show catalogue discovery/completeness separately from individual Scholarship detail candidates.

### Decision 70 — Provider Scholarship completeness is measurable
**Status:** Current · **Recorded in:** Design Decisions v1.30

The Scholarship workspace should expose per-Provider counts such as catalogue discovered, unique candidates, acquired details, canonical current records, pending scope review, rejected and failed. Zero discovered from a successfully fetched source must not automatically display “complete”.

### Decision 71 — Stable first-party detail URL can anchor identity
**Status:** Current · **Recorded in:** Design Decisions v1.30

When the Provider exposes no stronger source-native identifier, the official detail URL is the accepted source identifier. Title matching cannot establish identity.

### Decision 72 — Scope review precedes course applicability
**Status:** Current · **Recorded in:** Design Decisions v1.30

The PIM may show an unpublished Scholarship root while applicability is pending. Course/Provider views must not show it as applicable until scope resolution is accepted.

### Decision 73 — Layer 4 owns ambiguous Scholarship scope
**Status:** Current · **Recorded in:** Design Decisions v1.30

Scholarship `scope_resolution` uses the existing Layer 4 review workspace, Evidence context and terminal decision model. Do not create a parallel Scholarship-only human-review queue.

### Decision 74 — Provider logo promotion is governed
**Status:** Current · **Recorded in:** Design Decisions v1.30

Logo discovery and logo promotion are separate actions. Promotion requires a first-party candidate, managed asset copy and hash. Failed CDN download remains a review state and does not justify bypassing controls.

### Decision 75 — Consumer presentation derives from governed state
**Status:** Current · **Recorded in:** Design Decisions v1.30

Provider cards may eventually show approved logos and Scholarship aggregates, but only from approved/published consumer projections. Internal candidate/review counts remain Admin/PIM information.

### Decision 76 — Environment controls are first-class Administration
**Status:** Current · **Recorded in:** Design Decisions v1.31

Platform Admins use Administration → Environment & Migration for environment-specific settings, integration credentials, vendor entitlements and Production migration status.

### Decision 77 — Secret values are write-only
**Status:** Current · **Recorded in:** Design Decisions v1.31

The UI may show configured/missing/rotation status but never retrieves an API key after save.

### Decision 78 — Provider quota changes are configuration
**Status:** Current · **Recorded in:** Design Decisions v1.31

Firecrawl or other vendor-plan changes update provider billing/quota configuration in Admin; they do not require application source changes.

### Decision 79 — Parse.bot can be prepared but not implicitly enabled
**Status:** Current · **Recorded in:** Design Decisions v1.31

Endpoint/key configuration is not adapter qualification. Parse.bot remains disabled until bounded UAT.

### Decision 80 — Production migration is multi-plane
**Status:** Current · **Recorded in:** Design Decisions v1.31

Admin must show separate readiness for Database/Auth data, Vault, Storage bytes, Edge Functions, secrets, cron, extensions, CORS/origins, frontend keys and consumer endpoints.

### Decision 81 — Evidence paths are environment-portable
**Status:** Current · **Recorded in:** Design Decisions v1.31

Canonical Evidence uses bucket-relative object paths and source URLs. Signed Storage URLs are generated for the current environment and are not canonical persisted links.

### Decision 82 — Production-generated Supabase keys are not copied
**Status:** Current · **Recorded in:** Design Decisions v1.31

Production frontend/server deployments consume target-generated publishable/secret keys. Pilot keys are never treated as migration artefacts.

### Decision 83 — Consumer cutover remains separate
**Status:** Current · **Recorded in:** Design Decisions v1.31

Environment readiness may record Website/Zoho endpoints/status but cannot authorise their Production cutover.

### Decision 84 — Layer 3 enqueue comes from the governed fee backlog
**Status:** Current · **Recorded in:** Design Decisions v1.32

Layer 3 tuition work is queued only from the governed Layer 3 fee-validation backlog and only when a real Layer 2 fee target exists. An older rule that read the wrong population was replaced (CF-247, 23 Sep 2026).

### Decision 85 — Bounded fee-year resolution (option A)
**Status:** Current · **Recorded in:** Design Decisions v1.32

Layer 3 may supply a fee year only when the quote states that year with the amount, within 2024–2030. Five required safety controls apply, including rejecting a course total presented as annual.

### Decision 86 — Layer 3 admission holds go to Layer 4 with plain reasons
**Status:** Current · **Recorded in:** Design Decisions v1.32

An item Layer 3 cannot settle is routed to Layer 4 with a plain-English reason; no review item is created for validated tuition, which admission decides.

### Decision 87 — Admitted fees follow one record convention
**Status:** Current · **Recorded in:** Design Decisions v1.32

Admitted tuition is recorded in catalogue fees with a key of course:audience:year:basis, linked to its Evidence and source. The same convention is used by Layer 3 admission and by Layer 4 human decisions.

### Decision 88 — Layer 3 daily limit and benchmark usage
**Status:** Current · **Recorded in:** Design Decisions v1.32

The Layer 3 daily call limit is 1,000 per profile (reversible, noted on the profile). Benchmark calls currently count against it; excluding them is a follow-up.

### Decision 89 — Qualification is bound to exact code and model
**Status:** Current · **Recorded in:** Design Decisions v1.32

A Layer 3 model is qualified for one binding: model, prompts, request format, validator and helper sources. Any change to these requires the manifest to be regenerated and the model to be re-qualified by benchmark.

### Decision 90 — Activation is a separate, deliberate step
**Status:** Current · **Recorded in:** Design Decisions v1.32

A passing benchmark never activates a model. An administrator activates it explicitly, and a model must be paused while it is benchmarked.

### Decision 91 — Two consecutive clean passes are required
**Status:** Current · **Recorded in:** Design Decisions v1.32

Qualification needs two consecutive benchmark runs that pass every real case and every safety control. Failed runs are kept on record; runs are never repeated until one happens to pass.

### Decision 92 — Benchmark runs name the profile and are spaced out
**Status:** Current · **Recorded in:** Design Decisions v1.32

The benchmark service defaults to an old, disabled profile, so every run names the profile explicitly. Runs are spaced to avoid the aggregator's rate limit; a rate-limited run is invalid, not a model failure.

### Decision 93 — The benchmark keeps a strict JSON schema
**Status:** Current · **Recorded in:** Design Decisions v1.32

The benchmark requires strict structured output. Production currently uses plain JSON mode and will move up to the strict schema, not the reverse. A model that cannot meet the strict schema through the aggregator (Claude Haiku 4.5 via OpenRouter, Sep 2026) cannot be qualified.

### Decision 94 — The benchmark mirrors production context
**Status:** Current · **Recorded in:** Design Decisions v1.32

Real benchmark cases receive the same approved provider-rule context as production items, so a model is judged on the conditions it will run under. Before this, the benchmark rewarded guessing and penalised caution.

### Decision 95 — Quotes are compared as visible text
**Status:** Current · **Recorded in:** Design Decisions v1.32

An Evidence quote must match the saved page's visible text exactly and in order. Link targets, JSON escapes, stray square brackets, formatting symbols and whitespace are removed on both sides before comparing; nothing is added.

### Decision 96 — A year selector is not a stated year
**Status:** Current · **Recorded in:** Design Decisions v1.32

A fee year is recorded only when printed beside the amount. A list of selectable years does not state a year. Every quote must be one continuous passage from the page.

### Decision 97 — Provider-rule basis wording
**Status:** Current · **Recorded in:** Design Decisions v1.32

Where an approved provider rule sets the basis (for example indicative annual), an AI answer of "annual" is accepted as the same yearly fee and the rule's wording is recorded.

### Decision 98 — Model comparison outcome, 24–25 Sep 2026
**Status:** Current · **Recorded in:** Design Decisions v1.32

Mistral Small 3.2 was inconsistent (guessed years, invented quotes, failed a must-decline control). DeepSeek V3.2 and Gemini 2.5 Flash were safe but declined or blanked genuine values. GPT-OSS 20B was too slow. None passed two clean runs, so Layer 3 tuition validation is paused until a model qualifies. If a Gemini 2.5 model is chosen later, its successor must be planned.

### Decision 99 — One API key per aggregator
**Status:** Current · **Recorded in:** Design Decisions v1.32

Profiles use their own key only if one is deliberately set; otherwise they use the aggregator's shared key. The register stores only the vault entry name; secrets are never read out or copied. The seven per-profile copies will be retired once the shared key is proven.

### Decision 100 — New model profiles start paused
**Status:** Current · **Recorded in:** Design Decisions v1.32

New Layer 3 profiles are cloned from the reference profile's instructions, validators and limits, and are created paused. Nothing runs in production until activation.

### Decision 101 — Scoped search refresh
**Status:** Current · **Recorded in:** Design Decisions v1.32

When fees or links change, only the affected courses' search documents are refreshed. The scoped refresh was proven identical to the full refresh. The full refresh still rewrites every row; making it write only changed rows is a follow-up (PERF-3).

### Decision 102 — Heavy summary reads are pre-computed
**Status:** Current · **Recorded in:** Design Decisions v1.32

Dashboard and layer summaries are refreshed in the background every 2 minutes and Evidence filter options every 15 minutes, with a live fallback if stale. Reads that approach the 8-second limit are fixed at the source (index use, scoped work).

### Decision 103 — Tool-neutral Evidence
**Status:** Current · **Recorded in:** Design Decisions v1.32

Acquisition tools are replaceable adapters (seven are registered). Each saved page records which tool and adapter fetched it. Downstream steps rely on visible text produced by CourseFinder's own normalisation, not on any tool's output format; storing normalised text per page is planned.

### Decision 104 — Provider fee profiles
**Status:** Current · **Recorded in:** Design Decisions v1.32

Where a provider officially states what its published fee means, an approved profile records it: page pattern, audience, basis, exclusion words, the provider's guidance and link, approval reference and review date. Profiles are applied deterministically at Layer 2.

### Decision 105 — First provider rule: UQ program pages
**Status:** Current · **Recorded in:** Design Decisions v1.32

UQ program pages show the indicative annual international tuition fee, per UQ's official fee guidance. Exclusions: total, semester, trimester, per unit, per credit, subsidy, Commonwealth supported, domestic, HECS. Review by 31 March 2027.

### Decision 106 — Deterministic admission for rule-covered pages
**Status:** Current · **Recorded in:** Design Decisions v1.32

For pages covered by an approved provider rule, a fee is admitted without AI when the Layer 2 fee panel shows the exact target amount for international students, labelled as the fee, with no exclusion words in the text right after the amount. The year is left blank unless printed beside the amount. Anything else goes to Layer 3 or Layer 4 as before. (Decided 25 Sep 2026; build in progress.)

### Decision 107 — RMIT needs no provider rule
**Status:** Current · **Recorded in:** Design Decisions v1.32

RMIT labels fees as "(year annual)" or "(year total)"; the rules already treat totals as not yearly. Storing total course fees as a separate fee type is a future product decision.

### Decision 108 — Countries without a regulatory course register
**Status:** Current · **Recorded in:** Design Decisions v1.32

Layer 1 becomes a provider register (official where available, otherwise curated and approved). Layer 2 builds the course catalogue from provider sites. Listing and aggregator sites are leads, never Evidence. A country profile sits above provider profiles. Canada is the next country after Australia and New Zealand, after the consumer API phase.

### Decision 109 — Layer 4 review principles
**Status:** Current · **Recorded in:** Design Decisions v1.32

One decision at a time; reason first, then the facts that settle it, then links; rule-based suggestions are shown but never applied automatically; opening an item reserves it for 30 minutes; managers (PIM Admin and above) see everyone's figures and others see their own; target: nothing waits more than 7 days.

### Decision 110 — Approve needs a complete value
**Status:** Current · **Recorded in:** Design Decisions v1.32

Approve is offered only when a complete value is proposed (for tuition, already marked per year). Otherwise the reviewer uses Edit and approve and enters it. Approved tuition fees and course links are written to the catalogue and refreshed in search.

### Decision 111 — Reviewer-entered values have their own source
**Status:** Current · **Recorded in:** Design Decisions v1.32

Values entered by reviewers are attributed to the "Layer 4 human review" source, approved for official course links in search, with the reviewer, time and note on the decision.

### Decision 112 — Send back really re-checks
**Status:** Current · **Recorded in:** Design Decisions v1.32

Sending a tuition item back to Layer 3 re-queues its work item. A "send back" suggestion appears only once a newly qualified binding is active.

### Decision 113 — Official course link suggestions
**Status:** Current · **Recorded in:** Design Decisions v1.32

Exit awards and study abroad or exchange registrations have no course page: suggest Reject (batchable). Research degrees: use the provider's research-degree page. Others are checked individually.

### Decision 114 — Batch decisions
**Status:** Current · **Recorded in:** Design Decisions v1.32

Batches need the Pipeline Operator role, hold 2 to 100 items of one kind, require a typed confirmation and a reason, record every item individually plus the batch, and are all or nothing. Items someone else is reviewing are refused.

### Decision 115 — Scholarship scope is decided per course
**Status:** Current · **Recorded in:** Design Decisions v1.32

Scholarship scope is decided course by course in batch work; the scholarship-level item can be marked done only when no courses remain undecided.

### Decision 116 — Menu and screen simplification
**Status:** Current · **Recorded in:** Design Decisions v1.32

The Review Queue is retired (its address opens Layer 4). Jobs and Scheduled Tasks are one menu item, Jobs & Schedules, with tabs; the single pages remain as routes. Duplicate Layer shortcuts are removed from screens; the Administration tab row duplicates are next.

### Decision 117 — Onboarding stays in Administration
**Status:** Current · **Recorded in:** Design Decisions v1.32

Onboarding remains under Administration, reversing the earlier UI-0 note: it is an occasional set-up task (for example onboarding a new country) and an existing governance test records it there.

### Decision 118 — Release notes are complete and current
**Status:** Current · **Recorded in:** Design Decisions v1.32

The version pill shows the current release. The full history is generated at build time from the legacy list, the release notes files and the manifest, and a searchable page lists every release. Each visible release adds its notes; fixes without a screen change are listed in the next visible release; the version changes only with visible changes.

### Decision 119 — Delivery through consolidated packages
**Status:** Current · **Recorded in:** Design Decisions v1.32

Work ships in consolidated packages, one pull request each. Edge functions are deployed only through the guarded workflow (allow-list with recorded settings, typed project reference matching a repository variable, Layer 3 contracts first). Files starting with a dot are created in the web editor, because the upload page skips them.

### Decision 120 — Testing before packaging
**Status:** Current · **Recorded in:** Design Decisions v1.32

Run every changed module, not only build it; time the reads a change touches from cold; prove data changes with rolled-back runs; make sure every UPDATE and DELETE on the app path has a WHERE clause; merge only with a green smoke test; fix or retire stale tests while keeping their intent. An hourly read-speed check and tests on pull-request previews are deferred.

### Decision 121 — Roadmap to production
**Status:** Current · **Recorded in:** Design Decisions v1.32

P1 queue relief, P2 Jobs, P3 screen review, P4 menu redesign, P5 admission cross-check (with P5a tool-neutral Evidence and provider profiles first), P6 consumer API for Wix and Zoho, P7 release history, P8 guides by role, P9 metrics, P10 production build in a new environment. Recommended production region: Sydney.

### Decision 122 — Decisions are recorded here promptly
**Status:** Current · **Recorded in:** Design Decisions v1.32

Each design decision is numbered when made and added to this document at the next admin update, no later than the close of the package in which it was made. Runsheet entries reference decision numbers.

### Decision 123 — Preview deployments stay blocked from admin functions
**Status:** Current · **Recorded in:** Design Decisions v1.32

Pull-request preview addresses remain blocked by CORS from calling admin edge functions. Revisit only with the production CORS design (P10), which also decides whether live tests can run against previews.

### Decision 124 — Provider-rule admission runs on a schedule and is audited separately
**Status:** Current · **Recorded in:** Design Decisions v1.33

Deterministic provider-rule admission (Decision 106) runs every 15 minutes, after rule stamping every 5 minutes. Each admission is recorded in its own audit table with the rule, the amount and the exact page text that satisfied the check. Review items it settles are marked "superseded", never "approved", so a person's decision and a rule's are never confused. First run: 160 UQ items admitted, 89 courses gained their indicative annual fee, and the Layer 4 queue fell from 330 to 151.

### Decision 125 — Layer 3 while no model is qualified
**Status:** Current · **Recorded in:** Design Decisions v1.33

Until a model passes two consecutive clean benchmark runs (Decision 91), Layer 3 enqueue keeps running (it makes no AI calls, so new items can be settled by provider rules), while AI dispatch and admission stay paused.

### Decision 126 — Test-only fixes may go straight to main
**Status:** Current · **Recorded in:** Design Decisions v1.33

Changes that touch only test files may be committed directly to main (programme owner, 25 September 2026). All checks still run on the push, and any app, database or function change still goes through a pull request.

### Decision 127 — Live-site tests check current behaviour, not pinned values
**Status:** Current · **Recorded in:** Design Decisions v1.33

Live-site tests read the current version from the release manifest instead of a hard-coded version, and use patterns where exact wording or version numbers routinely change. Stale expectations are fixed to the current behaviour while keeping each test's intent. A full check of every live-site test against the current app is the first item of P3.

### Decision 128 — Ranking editions are validated and applied automatically
**Status:** Current · **Recorded in:** Design Decisions v1.33

Ranking editions are validated and applied automatically by the Layer 1 Ranking ETL; mapping exceptions remain traceable separately, and every edition stays visible in the import history. A new country for an existing edition is treated as an extension (add country data), never as a replacement of the accepted edition. This records a behaviour that changed earlier without a numbered decision.

### Decision 129 — Old addresses stay routable when pages merge or move
**Status:** Current · **Recorded in:** Design Decisions v1.34

When pages are merged, renamed or moved, their previous addresses keep working: they remain as hidden routes or aliases, so bookmarks, shared links and refreshes open the right page. Found when #jobs, #scheduled-tasks and #refresh-scheduling fell back to the Dashboard after the Jobs & Schedules merge (v2.15.91); fixed in v2.15.93.

### Decision 130 — Screen reviews use captured screenshots
**Status:** Current · **Recorded in:** Design Decisions v1.35

Screen-by-screen reviews use the "UI review screenshots" workflow: it signs in as the UAT user, waits until the screen's data has loaded, captures the full screen and commits the images to the separate ui-review-snapshots branch, never to main. E-mail addresses and the signed-in user's details are always masked; screens showing personal data are not captured unless masked, because the repository is public.

### Decision 131 — The UQ rule also matches UQ's fee explanation
**Status:** Current · **Recorded in:** Design Decisions v1.35

The UQ provider rule also admits a fee when UQ's fee explanation ("Approximate yearly cost of full-time tuition") is followed by the exact amount, with no exclusion words beside it. The year is recorded only when it is printed beside the amount and no other year appears in the same text; otherwise it is left blank. Applied 26 September 2026: 24 items, 14 courses.

### Decision 132 — One current provider tuition per course
**Status:** Current · **Recorded in:** Design Decisions v1.35

Each course has one current provider tuition record per audience. When several active records have the same amount, one stays: a person's Layer 4 decision first, then a stated year, then a provider-rule admission, then the most recently verified. The kept record takes the approved provider rule's wording where one applies. Others are marked "superseded" and kept for audit, never deleted. Records with different amounts are left for a person. A database trigger applies this to every new admission; the first run resolved 14 courses.

### Decision 133 — One title per screen (supersedes A24)
**Status:** Current · **Recorded in:** Design Decisions v1.35 · Supersedes A24 (CF-CHG-20260830-048).

Each Layer screen shows its title once, as the page title. The Layer header is a slim, light bar with the screen's one-line purpose and its refresh button; it no longer repeats the title in a dark banner. This supersedes A24 (CF-CHG-20260830-048), which required all four Layer screens to share a dark header. Pop-up versions keep their own title because it is their only one.

### Decision 134 — Statistics datasets: one card per dataset, one edition per year
**Status:** Current · **Recorded in:** Design Decisions v1.36

Each statistics dataset (QILT, PRISMS, QS, THE) is one dataset family shown as one card, with a year selector over its retained editions. QILT is one family with its four surveys (SES, GOS, GOS-Longitudinal, ESS) as tabs. A family's source is the publisher's stable page that lists its files, with a rule for finding each year's file, not a year-specific file address. Each new year becomes a new edition in the same family; the newest becomes current and earlier editions are kept. Each family has one schedule that checks for a new edition. Licensed files (QS, THE) are uploaded from their own dataset card with the same validation and history. Placement: Statistics & Rankings is where people view and compare, Layer 1 Operations is where operators run and upload, and Administration is where sources and schedules are configured; each card links to all three. Data fixes (with proof first): apply THE 2019–2024, check the THE "2015" edition, and merge the duplicated QS 2024 and 2025 editions.

Progress (28 September 2026, v2.15.100): built. Each family member has an edition rule (stable publisher page and a file pattern) in pipeline.statistics_edition_rules; a monthly discovery job records new files and test-reads them (nothing written); a Pipeline Operator applies a checked edition from the card, which makes it current and keeps the previous edition. QILT shows as one card with a tab per survey (each survey keeps its own editions). Scheduled checks now cover QS and THE. Data fixes done: THE 2016–2024 applied; THE "2015" withdrawn (it was the 2021 file); QS 2025 restored to the correct load; QS 2024 and 2025 each have one current edition.

### Decision 135 — ARWU and University Diversity Index are planned
**Status:** Current · **Recorded in:** Design Decisions v1.36

ARWU and the University Diversity Index remain registered but are shown as "Planned — no data yet" until acquisition is approved.

### Decision 136 — Consumer API guard
**Status:** Current · **Recorded in:** Design Decisions v1.36

Every database change that can affect the website, Wix or Zoho APIs runs a guard in the same transaction: the outputs of the six consumer data functions are fingerprinted with fixed cases before and after the change, and any difference aborts the change. Baselines are kept. Permission changes, which the guard cannot see, are verified separately in the same change.

### Decision 137 — The consumer reference bundle is cached
**Status:** Current · **Recorded in:** Design Decisions v1.36

The consumer reference bundle (countries, subdivisions, providers, filters, platform figures) is rebuilt every 10 minutes and served from the cache; if the cache is older than 30 minutes the live query is used. Output is unchanged; response time fell from about 4.6 seconds to 54 milliseconds.

### Decision 138 — Publication: pilot behaviour now, gate in production
**Status:** Current · **Recorded in:** Design Decisions v1.36

In the pilot, consumer APIs continue to return unpublished records (intended). For production (P10): a course is publishable when it is active, has a study level, its provider is active, and (AU) it has a registered cost; enrichment attributes are not required. Publication is applied by an audited rule that also withdraws courses that stop qualifying, with Layer 4 overrides either way. The production sequence is: publish by rule with proof first, compare consumer output before and after, then make the consumer APIs return published records only. Sized on 26 September 2026: 26,457 AU and 6,163 NZ courses would publish; 485 would be held for review.

### Decision 139 — Scholarship publication
**Status:** Current · **Recorded in:** Design Decisions v1.36

A scholarship is publishable when it has the provider's own page, an international audience, a stated award value, captured evidence, at least one linked course, and verification within the last 12 months. Scholarships are published by a PIM Admin in batches, because they carry eligibility claims, and withdrawn automatically when re-verification lapses. On 26 September 2026, 57 of 292 met every condition.

### Decision 140 — Course description
**Status:** Current · **Recorded in:** Design Decisions v1.36

The course description's authority is Layer 2: the provider's own overview text, taken only from the admitted official course page, so description and link always match. Extraction takes the first overview section as plain text, 200 to 1,000 characters, without fees, dates or navigation, stored with evidence. No AI rewriting. It is shown with attribution and a link to the provider page; corrections use the Layer 4 description path.

### Decision 141 — Layer 2 qualification per provider
**Status:** Current · **Recorded in:** Design Decisions v1.36

Layer 2 source qualification is done per provider, so one qualification unlocks all of that provider's courses, instead of course by course. The Layer 2 admissions view shows, per attribute and country, the funnel from awaiting qualification to queued to admitted, with blocked reasons and the actions to qualify a provider or run a wave.

### Decision 142 — Layer 4 correction for intakes and English requirements
**Status:** Current · **Recorded in:** Design Decisions v1.36

Intakes and English requirements get a Layer 4 correction path, like official links and tuition, so every non-regulatory attribute has one.

### Decision 143 — New Zealand baseline
**Status:** Current · **Recorded in:** Design Decisions v1.36

New Zealand courses keep identity and study level from the NZ register; field, locations, delivery mode and fees are not available from that source. NZ enrichment is planned after Australia.

### Decision 144 — The Attribute & Admission Register
**Status:** Current · **Recorded in:** Design Decisions v1.36

The Attribute & Admission Register is a standing design document: one row per course attribute with its authority layer, source, admission rule, Layer 4 correction path, refresh, consumer field and coverage. Every attribute has exactly one authority layer; every non-regulatory attribute has an admission rule and a correction path; a new attribute is added to the register before it reaches consumers.

### Decision 145 — Database hygiene
**Status:** Current · **Recorded in:** Design Decisions v1.36

Indexes are added for foreign keys on busy tables. Unused indexes are removed only when large and verified as not serving a consumer path, a planned production path or a foreign key, and each removal keeps a recreate script; small unused indexes are left, because some serve yearly jobs. Security-definer functions must pin their search path, public (anon) access is not granted to them, and internal or integration functions are limited to the service role. The Auth connection strategy is set for production in P10.

### Decision 146 — Evidence first
**Status:** Current · **Recorded in:** this reference (26 September 2026)

Evidence is captured once and reused. Everything fetched (Layer 1 files, provider pages, extraction inputs) is kept in Supabase Storage with its record. Layer 2 extracts deterministically from stored artifacts and fetches again only when evidence is missing or stale. Links in stored pages are indexed once, in a narrow evidence link index: only same-site, discovery-relevant links (study, courses, degrees, programs, handbook, find or search; at most 200 per page); the complete link lists remain in the stored evidence. (Refined 26 Sep 2026 after indexing every link reached 1.75 million rows and 672 MB in a few hours and exhausted the database's disk IO.) Layer 3 and Layer 4 work from the same stored evidence, every result and decision references the evidence it used, and the UI shows it.

### Decision 147 — Automatic catalogue discovery
**Status:** Current · **Recorded in:** this reference (26 September 2026)

Providers waiting for Layer 2 qualification are onboarded automatically: candidate course catalogue pages are ranked deterministically from the evidence link index (no web fetching), the best candidate is submitted through the same path a person uses, and the three-course identity check (3 of 3) decides. Up to the configured number of candidates is tried per provider; if none passes, the provider is marked 'Needs a person' and the Onboard action is used. Platform Admins set the limits in Scraper Config: on or off, providers per day, providers in flight (never above the Firecrawl concurrency) and candidates per provider; changes need a reason and are audited. Every attempt is recorded with its candidate, score, source evidence and result, and automatic submissions are recorded with origin 'automatic'.

### Decision 148 — One design reference
**Status:** Current · **Recorded in:** this reference (26 September 2026)

The CourseFinder Platform Design Reference is the single authority for design, guardrails and decisions. Decisions keep their numbers permanently and are never deleted; a replaced decision is marked Superseded and points to its replacement. A guardrail changes only by recording a new decision here (Proposed, then Current on approval) before implementation. The versioned Admin/PIM Design Decisions files v1.0–v1.36 and the Attribute & Admission Register v1.0 are kept as history.

### Decision 149 — Country-neutral identity and consumer fields
**Status:** Current (approved 26 September 2026) · **Recorded in:** this reference (26 September 2026)

Every country's official identifiers, including Australia's CRICOS provider and course codes, are recorded as typed, country-scoped identifiers in the identifier tables; course_code remains the display code. Shared tables never gain country-specific columns. New consumer contract versions use country-neutral field names (subdivision rather than state; regulatory basis rather than a country's term), added alongside existing names before any old name is retired.

Progress (28 September 2026): official schemes are listed once each in ref.identifier_schemes (CRICOS and NZQA for providers and courses, IRCC DLI for providers); a new country adds rows, not columns. The registration tables remain the register write path and triggers keep the identifier tables in step, writing only when an identifying value changes. Backfilled: 1,548 CRICOS and 414 NZQA provider codes, 26,787 CRICOS and 6,496 NZQA course codes, all with the correct country. The current consumer contracts were checked and already use neutral names (ISO subdivision codes such as AU-VIC, tuition basis 'registered_total_course', no CRICOS-named fields); the 'state' key inside regulatory_tuition means status and becomes 'status' in the next contract version. Older AU-specific columns in Layer 2 staging tables are listed as R27.

### Decision 150 — System identity for automation
**Status:** Current (approved and implemented 26 September 2026) · **Recorded in:** this reference

Automated actions are recorded under a dedicated system identity, *CourseFinder Automation*, not a person's account. The account cannot sign in (no password, permanently banned, non-routable address) and holds only Pipeline Operator, the minimum the Layer 2 batch service requires (automation previously acted as the first Platform Admin). layer2_automation_actor() returns this identity and has no fallback to a person: if the identity is missing or lacks its role, automation does not act. Automated records also carry origin 'automatic'.

### Decision 151 — Stale Layer 2 runs are closed
**Status:** Current · **Recorded in:** this reference (26 September 2026)

A Layer 2 parent run (scope-wave request) that has made no progress for 3 days is closed as cancelled with the reason recorded, and its pending items are marked blocked with the same reason, so no run can stay "active" indefinitely and nothing picks up abandoned work. History is kept. A daily job applies this, with a proof mode. (A run left at wave1_dispatched from 15 September made the Layer 2 screen show a run as active for 11 days.)

### Decision 152 — Workload efficiency
**Status:** Current · **Recorded in:** this reference (26 September 2026)

The platform admits data once and then re-checks it only on change or on the attribute's re-check cycle (annual for most provider and regulatory facts). Scheduled jobs run no more often than their data changes; heavy jobs each have their own minute slot, at least 7 minutes apart, and never overlap. Rows are written only when a fact actually changes; verification markers (such as last_verified_at and evidence pointers) are refreshed at most once per 30-day cycle, while every run is still recorded in full at run level. Every new job that writes heavily is sized first (rows and disk IO per run), switched on gently and watched afterwards. Consumer APIs read cached or pre-computed data and never trigger heavy work; the reference bundle is rebuilt hourly with a live fallback only after 3 hours. Job history is kept for 14 days.

### Decision 153 — Platform sizing and resource observability
**Status:** Current · **Recorded in:** this reference (26 September 2026)

The pilot runs on Micro compute (1 GB memory) with the database kept below memory where possible; production (P10) starts at Large. Resource use is recorded hourly with minimal overhead: database size against memory, largest tables and growth, cache hit rate, connections, job run times, overlaps and failures, Firecrawl units, AI calls and cost, and edge-function calls. Administration shows current use, trends, when the current size will be outgrown, and the monthly cost of the toolset (Supabase, Firecrawl, OpenRouter), so sizing is planned rather than discovered. (26 September 2026: the pilot on Nano, 0.5 GB memory, with a 1.7 GB database, exhausted its disk IO budget and Auth timed out.)

### Decision 154 — Admission lifecycle policy
**Status:** Current (approved 26 September 2026) · **Recorded in:** this reference

Each kind of data has a re-check cycle, held as policy (pipeline.admission_lifecycle_policy) and applied to configuration through governed paths: check cheaply for change and acquire only when there is something new. Registers (CRICOS, NZQA): checked weekly, ingested only when changed. Provider course facts (tuition, intakes, English, links, description): annually, in the August–November publishing window, or on demand (a person, a broken link, a Layer 4 correction). Scholarships: quarterly, or on demand. Provider assets: annually. QILT: checked twice a year for a new edition. PRISMS: checked monthly, ingested on a new release. Rankings: annually by licensed upload. Layer 2 profile freshness is aligned to the policy through the official profile-versioning path (3,057 profiles on 26 September 2026, previously weekly for course facts and scholarships). The Resources view shows each data type's cycle, window and alignment, and flags overdue sources. A change to a cycle is a change to this decision.


### Decision 155 — Layer 1 ingestion redesign
**Status:** Current (approved 27 September 2026) · **Recorded in:** this reference (28 September 2026)

Register ingestion (CRICOS, NZQA and later countries) works on changes, not on whole files, and runs without a person watching:
1. **Download once, store once.** A register file is downloaded once per run and stored once; an identical file (same source and content hash) is reused by every later batch and run.
2. **Change-based apply.** Each row has a fingerprint; a run applies only new, changed and departed rows and counts the rest as unchanged.
3. **Background execution.** A run is advanced by the database, not by an open browser or a person's sign-in. One worker holds a run at a time; a run that goes quiet for 3 minutes is restarted automatically; temporary source errors are retried up to 5 times (1, 2, 4, 8, 15 minutes); a run stops after 40 background restarts. The run's own record is the truth, not a web request's response.
4. **Visible progress and real errors.** The Layer 1 card shows items reached out of the total, pace, time left, last update, the batch in progress, retries and the actual error, and offers resume from the item where a run stopped.
5. **Duplicate evidence clean-up.** Existing duplicate copies are proven first, references are moved to the first copy, then the copies are removed.
6. **Departures and mergers.** Records that leave a register are retired (marked inactive, never deleted) with an audit record, the register file as evidence and an exact count check; a provider merger records the successor provider.
7. **Foundation for automatic ingestion.** With steps 1–6 in place, weekly register ingestion can run automatically when the record-count variance is within the pass band (option B).

Progress: steps 1, 3 and 4 delivered in v2.15.98 (27 Sep 2026): NZQA 414 providers in 81 seconds; a full CRICOS dry run in 3.5 minutes with no new evidence files; step 6 applied once by hand for 809 CRICOS departures (685 linked to Adelaide University as successor of UniSA and the University of Adelaide). Steps 2, 5, 6 and 7 delivered in v2.15.99 (28 Sep 2026): a full CRICOS comparison in about 10 seconds (baseline taken from the accepted 26 Sep file); 746 duplicate register copies removed (1.7 GB) after a 20-file byte-for-byte check; departures, reactivation and provider review applied at the end of each run (Decision 158); automatic ingestion on for CRICOS and NZQA.

### Decision 156 — Ranking family card shows the ingested edition
**Status:** Current (implemented 28 September 2026) · **Refines:** Decision 134 · **Recorded in:** this reference

A ranking family card (QS, THE) shows the newest edition that has data, with its year in the card title (for example "QS World University Rankings 2026"). A newer edition without data, such as one the publisher does not yet serve, is shown as pending and does not replace the card's figures. (QS 2027 was marked current without data, so the card had shown no figures and the CF-068 deployed test failed.)


### Decision 157 — Discovery links kept once per provider
**Status:** Current (implemented 28 September 2026) · **Refines:** Decision 146 · **Recorded in:** this reference

The evidence link index keeps each discovery-relevant link once per provider, with the number of stored pages it appeared on, the longest link text and the first evidence it came from, instead of one row per page. Only stored pages of providers still waiting for onboarding are indexed. Candidate ranking is unchanged: before switching, the per-provider candidates were proven identical to the page-level index for all 648 providers (3,011 candidates). (The same navigation links on every page had grown the page-level index to 447,678 rows and 188 MB; it now holds 25,521 rows in 19 MB.)

### Decision 158 — Register departures and automatic ingestion
**Status:** Current (implemented 28 September 2026) · **Implements:** Decision 155 steps 6 and 7 · **Recorded in:** this reference

At the end of every register apply run, records that left the register are retired (marked inactive, never deleted) with an audit record, the register file as evidence and an exact count check. If more than 2% of the register (and more than 50 records) would be retired at once, nothing is retired until a Platform Admin approves it on the Layer 1 card with a reason; the approver is recorded. A retired record that returns to the register is reactivated and its audit record closed. A provider whose every active course departed is listed for a person to review as a closure or a merger; any successor is recorded by a person, not guessed. When the weekly verification finds a changed register file and the record-count variance is 'pass', an apply run is queued automatically under the system identity; a 'warn' or 'block' variance, a paused or stale source, a run already in progress, or a file that an automatic run already failed on is left for a person. Automatic ingestion is on for CRICOS and NZQA.


### Decision 159 — Layer 1 closed
**Status:** Current (closed 28 September 2026, release v2.15.100) · **Recorded in:** this reference

Layer 1 (regulatory registers, rankings and statistics) is functionally complete and closed. Every Layer 1 source checks itself on its schedule (registers weekly, rankings and statistics monthly), applies only what changed, retires departures with an audit record and a Platform Admin hold above 2% and 50 records (CRICOS by register comparison, NZQA by what each run reads), reactivates returning records, lists empty providers for a closure or merger decision in Layer 4, re-marks rows as checked at most every 30 days, and records identity as country-scoped identifiers. Rankings hold one current edition per year (QS 2021–2027, THE 2016–2026); licensed uploads are validated, then applied, then checked on schedule against the stored upload. Statistics find their own new editions from the publisher's page and a person applies a checked edition. The closure is guarded by the contract suite tests/uat/cf-247-layer1-closure-contract.spec.mjs; a change that breaks it needs a new decision here.

Out of scope of the closure, and not a reopening: a new country or source is onboarded as an adapter (rows and a worker), not by changing how Layer 1 works — Canada's register data is the next such onboarding; R27 renames older AU-specific staging column names without changing behaviour; QS 2027 publisher access stays pending while the publisher blocks automated download.


### Decision 160 — Layer 3 qualification accepts safe abstention
**Status:** Current (28 September 2026) · **Recorded in:** this reference

A Layer 3 model qualifies for a task when every answer it gives is correct. Saying "unsure" is allowed and sends the item to Layer 4 for a person; a wrong answer is not. The benchmark passes only with at least 3 cases, no wrong answers, no infrastructure errors, at least 3 cases and at least half of them resolved, and every control passing. A passing benchmark never switches a model on: the profile stays paused until a separate, recorded activation. The model is pinned to one named model (no automatic routing across models), so a result is always bound to the model that was qualified. Open items assigned to a profile that can no longer run are moved to the qualified profile with an audit record; finished items never move. The admission guard still applies: an AI answer is admitted only when it matches a governed Layer 2 target, and otherwise goes to Layer 4.

First use: Mistral Small 3.2 (tuition validation) qualified 10/10 with 0 wrong answers and 5/5 controls, and was activated on 28 September 2026. Guarded by tests/uat/cf-247-d160-safe-abstention-contract.spec.mjs.


### Decision 161 — RMIT course refresh unblocked
**Status:** Current (28 September 2026) · **Recorded in:** this reference

RMIT's weekly Layer 2 course refresh, switched off on 27 August 2026 under CF-CHG-20260827-044 while RMIT canonical promotion was blocked, is switched back on by the Platform Admin to grow provider-current tuition coverage. The block is superseded by today's governed path: tuition candidates are checked by Layer 3 under Decision 160 and anything unsure goes to Layer 4; other fields follow the Decision 152 admission lifecycle. Federation (bounded, paused as source-limited) and QUT (deferred) are unchanged.


### Decision 162 — Course attributes: regulator first, deterministic Layer 2, refresh by change
**Status:** Current (28 September 2026) · **Recorded in:** docs/coursefinder-course-attribute-ingestion-v1.0.md

Every course and scholarship attribute has one authority, a deterministic Layer 2 method where the regulator does not publish it, and a refresh cadence matched to how often it changes. CRICOS supplies identity, international availability (active registration), duration, locations, regulatory facts and registered international tuition, non-tuition and total cost for every Australian course; provider-page annual tuition is a fee-year refinement read once per fee year from a provider fee schedule where one exists. Provider pages are re-read only when a change check finds them changed (interim: every 90 days, replacing weekly). Layer 3 handles only ambiguous candidates for attributes with a qualified task. Layer badges show stored provenance (layer, rule or model, evidence), not a guess; CRICOS tuition shows as Layer 1. Firecrawl is used as a deterministic fetcher (sitemap discovery, raw HTML, git-diff change tracking, PDF parsing); its AI extraction features are not used for admission.


### Decision 163 — Complete coverage, ongoing, reported daily
**Status:** Current (29 September 2026) · **Recorded in:** docs/coursefinder-course-attribute-ingestion-v1.0.md §9 and docs/coursefinder-complete-coverage-delivery-plan-v1.0.md

**Coverage and reporting**
- Every active Australian course, and its scholarships, is to be accounted for attribute by attribute. The coverage sweep keeps running (monthly site re-discovery, 90-day page re-reads, monthly document checks, weekly from October to December).
- Coverage is shown hourly under Data Quality → Course coverage.
- A daily consumer API update and stakeholder update is written to `docs/daily-updates/` at 08:49 IST.

**Identity and admission**
- A provider page counts as the course's own page only when it prints the course's CRICOS code.
- The sweep writes nothing to the catalogue until the admission rule is approved.
- Tuition from the sweep is admitted only through the qualified Layer 3 model (Decision 160).

**Limits (Platform Admin, 29 Sep 2026)**
- Firecrawl: 100,000 credits a month, 25 concurrent requests. The budget guard stops at 2,000 remaining; the platform uses at most 20 concurrent requests.
- Layer 3: up to 15,000 items a day with a US$5 a day ceiling, on US$29 of OpenRouter prepaid credit.
- Supabase compute may be raised for the sweep window and lowered once the backlog is admitted.


### Decision 164 — Production in customer-owned accounts by project transfer; admission detail
**Status:** Current (29 September 2026) · **Recorded in:** docs/coursefinder-production-environment-runbook-v1.0.md and docs/coursefinder-complete-coverage-delivery-plan-v1.1.md

**Go-live**
- Production goes live on 3 October 2026 in accounts owned and paid for by the customer: Supabase, GitHub, Cloudflare, OpenRouter, Firecrawl, SMTP and domain. The MSP keeps administrator access.
- The Supabase project is moved by **project transfer** to the customer's organisation, so data, evidence files, functions, schedules and the API address are unchanged. A new project with a full migration is used only for a region change.
- The consumer API is published on the customer's own domain through Cloudflare, so a later platform move doesn't affect the website.
- Every credential used during the pilot is rotated before go-live.
- Live edge functions without source in GitHub are brought into the repository before the transfer.

**Admission detail (29 Sep 2026)**
- Under the Decision 163 rule, official course pages and English requirements are admitted from CRICOS-code pages every 10 minutes.
- Intakes are held because a hand-check found about 9 of 14 right. They go to the Layer 3 benchmark.
- For scholarships under Decision 139, a provider-wide course link doesn't count for a scholarship named for a field or level. It needs a narrower course link.
- The daily review withdraws published scholarships that stop qualifying.


### Decision 165 — Consumer API presentation: provider names, regional classification, English summary
**Status:** Current (29 September 2026) · **Recorded in:** this reference (Pilot PR #175)

**Names**
- Consumer APIs show a presentable provider name: the first registered trading name, HTML entities decoded, legal suffixes removed, and all-capitals names put in title case with known acronyms kept.
- The registered name stays available (`provider.legal_name`; the bundle keeps `name`).
- Campus localities in capitals are shown in title case.
- All of this is computed when the API is read, so register refreshes never undo it.

**Regional classification**
- Each campus carries the Department of Home Affairs regional category, from Migration (LIN 19/217: Regional Areas) Instrument 2019 postcode lists: 1 major city, 2 city or major regional centre, 3 regional centre or other regional area.
- Each campus also carries its metro area.
- The city filter matches either the locality or the metro area.

**English summary**
- `entry_requirements.summary` states only the English requirement, marked `basis: english_only`.
- Academic entry is not held and is never implied.

**Contract**
- All changes are additive within `website-search-v1`, with consumer snapshots recorded before and after.


### Decision 166 — Australian university groups
**Status:** Current (29 September 2026) · **Recorded in:** this reference (Pilot PRs #176, #177)

**Membership**
- The Group of Eight, Australian Technology Network, Innovative Research Universities and Regional Universities Network are held as provider collections (`ref.institution_collections`, type `university_group`).
- Membership comes from each group's official member page (26 universities on 29 September 2026). Each member is matched to the university's own CRICOS provider code; pathway colleges and pre-merger registrations are excluded.
- Membership is re-checked yearly. Changes are made by migration, citing the page.

**Filtering**
- Admin screens: University group filter on Courses and Providers, with group badges on provider detail (v2.15.105).
- Consumer API: `university_groups` filter, plus `provider.university_groups` on course and scholarship results. The reference bundle lists each group with its members and course count.
- Group filter codes: `go8`, `atn`, `iru`, `run`.

### Decision 167 — Scholarship sweep
**Status:** Current (29 September 2026) · **Recorded in:** this reference and docs/coursefinder-course-attribute-ingestion-v1.0.md

**Reading**
- Each active scholarship's own provider page is read with robots.txt respected, and the page is kept as gzipped evidence.
- Deterministic facts are recorded: study levels (from the eligibility section where the page has one), field (from the scholarship's name or the faculty it names), award value, closing date and eligibility excerpt.

**Applying**
- Facts are applied only where the record lacks them, and every change is logged. Tiered or mixed values are not applied.
- Course links cover the provider's active courses at the stated levels and in the named field. They replace provider-wide links.
- A faculty that cannot be matched to a field stops linking. A re-read that states no level or field removes the earlier sweep links.

**Publishing**
- Publication stays with the Decision 139 batch under the 29 September approval. Each batch is run by hand: dry run, sample check, then apply. There is no automatic publish job.
- A scholarship is not publishable if its read provider page limits eligibility to citizens and residents, or never mentions international students.
- The nightly review withdraws anything that stops qualifying.
- First sweep batch, 29 September 2026: 54 published (27 at Group of Eight universities); 7 held back as domestic-only.

**Discovery (step 1 and step 2, 29 September 2026)**
- Candidate scholarship pages are collected on each provider's own site: sitemaps first, then a budget-guarded Firecrawl map, then one exact-name search where nothing matches (cron `scholarship-discover` every 10 minutes).
- A Study Australia-only record takes its provider page only when the page names the scholarship; otherwise it is recorded as a name mismatch and nothing is applied. The Study Australia address stays in the change log.
- A page not matched to a held record becomes a new scholarship only through `security.scholarship_admit_from_provider_page_v1`. It must be a single named scholarship on the provider's own site, open to international students and currently offered. New records start unpublished. A re-read that no longer qualifies sets the record inactive, and the change is logged.
- Publication holds: a hand-check can hold a record from publication with a logged reason (`pipeline.scholarship_publication_holds`). Publishability reports "held after hand-check", and releasing a hold is a deliberate update.

### Decision 168 — Intakes stay held after the Layer 3 benchmark
**Status:** Current (29 September 2026) · **Recorded in:** this reference (Pilot PR #180)

- Gold set: 44 courses from 33 providers, each read by hand. 20 state their intake months and 24 do not.
- Layer 2 extractor: 55% exact on stated cases, with invented intakes on 5 of 24 pages that don't state them.
- Layer 3, pinned `mistralai/mistral-small-3.2-24b-instruct` (no automatic routing): 90% exact on stated cases, with 1 invented intake. Every answer must quote the page. OpenRouter spend was US$0.03.
- The pass bar is at least 95% exact on stated cases and no invented intakes. The run failed, so intakes stay held. The intake profile is disabled and paused, and there is no intake cron or hand-off.
- A re-qualification must use a fresh holdout gold set, because the prompt rules were written after reading this one. Activation is a separate step that needs Platform Admin approval.
- **Superseded the same evening by Decision 169:** Mistral Small 3.2 and Mistral Medium 3.1 also failed a fresh holdout (76% and 86%). Claude Sonnet 4.6 passed, and intakes are now admitted through Layer 3.

### Decision 169 — Layer 3 model routing: stronger pinned models, qualified per task, automated admission
**Status:** Current (29 September 2026, activated 19:44 IST) · **Recorded in:** this reference (Pilot PRs #183, #186, #187)

**Direction**
- Platform Admin, 18:30 IST: use a stronger AI model, route each task to the improved model, retire unused models and profiles, and automate admission between layers.

**Qualification**
- Each task's prompt, schema and validators are frozen and fingerprinted before any holdout page is read.
- Holdout gold sets are hand-read, disjoint from earlier sets and frozen by digest. Qualification spend is capped at US$8.
- Models are individually pinned; there is no "auto" routing.
- The bar is unchanged: at least 95% exact on stated cases and no wrong-admitted values. Withheld answers are reported separately.

**Results**

| Task | Model routed | Holdout result |
|---|---|---|
| Intakes | Claude Sonnet 4.6 | 13/13 exact, 0 wrong. Only pass; Mistral Small, Mistral Medium, GPT-4.1 mini and Claude Haiku 4.5 failed |
| English | Claude Sonnet 4.6 | 19/19 exact, 0 wrong. Only pass; GPT-4.1 mini, Gemini 2.5 Flash and DeepSeek V3.2 failed |
| Tuition | Qwen3 235B 2507 | 8/8 exact, 0 wrong. Replaces Mistral Small 3.2, which failed the fresh holdout (6/8) |

**Running**
- Intake and English routes run every 2 minutes. Governed admission runs every 5 minutes. A different held value goes to Layer 4, never overwritten.
- The tuition hand-off is raised to 50 per 10 minutes.
- Daily guards: intake US$4, English US$4, tuition US$5. All routes stop below US$5 of OpenRouter credit.
- 24 unused or failed profiles are retired (disabled, paused, dated, with a reason, kept for audit). Scholarship profiles are untouched.
- A new model can replace a routed one only after passing a fresh frozen holdout. Switching routes is a logged step.

### Decision 172 — Layer 3 cost-first cascade
**Status:** Current (29 September 2026) · **Recorded in:** this reference (Pilot PR #189) · **Refines:** Decision 169

**Direction**
- Platform Admin, 21:08 IST: use the cheapest OpenRouter model with at least 80% success, and escalate failed pages to higher-cost models, so stronger models are used only when needed.

**Tier rule**
- A model can hold a tier only with at least 80% right **and no wrong admissions** on the task's frozen holdout. Moving up a tier rescues answers a model did not give; it cannot catch a confident wrong answer.
- Tiers are ordered by measured cost, cheapest first. The final tier is the qualified single-route model from Decision 169.
- A page moves up when the answer fails the automatic checks, or says "not stated" while the page shows a clear signal (month names near intake words, or an English test name with a score).

**Ladders**

| Task | Tier 1 | Tier 2 | Tier 3 | Cost per 1,000 pages (holdout simulation) |
|---|---|---|---|---|
| Intakes | Qwen3 30B | Claude Haiku 4.5 | Claude Sonnet 4.6 | US$1.29 (Sonnet only US$10.94); 43/45 right, 0 wrong |
| English | Qwen3 30B | Mistral Small 3.2 | Claude Sonnet 4.6 | US$0.17 (Sonnet only US$10.72); 36/37 right, 0 wrong |

- Tuition stays on its single qualified route (Qwen3 235B 2507, US$0.55 per 1,000).

**Safeguards**
- 5% of lower-tier answers are re-asked to the final tier. A disagreement goes to Layer 4. Three disagreements in a tier's last 60 audits pause that tier, and it is never re-promoted automatically.
- If OpenRouter refuses a call (key, billing or rate limit), the page is released for retry. It is never escalated or sent to Layer 4, and Platform health raises a critical issue.

### Decision 173 — Layer 3 is operated from one control screen
**Status:** Current (29 September 2026, v2.15.108) · **Recorded in:** this reference (Pilot PR #191) · **Refines:** Decisions 171 and 172

**Screen**
- Layer 3 has three tabs: Control, Models and Work queue.
- Control shows each task: Running or Paused, today's spend against its daily limit, the last 24 hours, the cascade in order, and what is waiting for a person.
- Models lists only models in use or qualified to be used.

**Controls**
- A Platform Admin can pause or run a task or all tasks, set the daily limit (US$0–100), switch a cascade step on or off, move it, add a qualified model as the last step, or remove one. At least one step always stays on.
- Adding a model enforces the tier rule of Decision 172. Every change is logged and shown under Recent changes.

**Retry of parked work**
- Layer 4 items that Layer 3 raised because a model could not settle a page return to Layer 3, and are retried through the cascade (tuition through its qualified route).
- Items where the page differs from a value already held stay with a person.

### Decision 254 — University adapters are the admission path for course fields: page roles, waves of five, a visual builder
**Status:** Current (4 October 2026, migrations 20261004001280–20261004001330, worker coverage-sweep v0.16.2, releases v2.15.183–v2.15.185, Pilot PRs #302–#305) · **Recorded in:** this reference; full report and design in `docs/coursefinder-university-adapters-v1.0.md`; register and configurations in `docs/adapters/` · **Amends:** Decision 253 (adapters) · **Source:** Platform Admin, 4 Oct 2026 21:50, 22:43 and 23:30
- **Why.** The general reader missed fields because each university prints them differently. For example, it found start dates on 25 of 262 Flinders study pages. The Flinders adapter read 173, with no Firecrawl credits.
- **Adapters read page data and page text.** JSON paths and text patterns with a "pick" rule (first, last, all) cover intakes, fee, IELTS, campus, mode, duration, level, student type, "not admitting" and AQF level. Unsafe patterns are refused. Apply runs in slices within the edge processor-time limit.
- **An admitting adapter's own reading is exact.** It replaces held intakes and IELTS scores (logged in `adapter_overwrite_changes`). It never changes a value entered or locked by hand. Intakes are admitted only from an adapter's own reading, with its admit switch on. Tuition from pages is shown, not admitted.
- **Page roles.** An adapter may use the course page, linked (continued) pages, the handbook page and central pages.
  - Precedence: by hand, then course page, then linked page, then handbook, then central policy (approved, by category, gaps only), then the general reader.
  - Linked pages inherit identity from the confirmed course page. Handbook pages must show the code. Central pages become policy proposals approved by the Platform Admin.
- **Better pages.** Firecrawl may search for a better page for a university's courses. A better page the identity check refuses is undone, and the earlier page is restored.
- **Evaluation.** Every target university gets a next step from three settings (no page share, unreadable share, field share): find pages first, an adapter for page data, start dates or English, or no adapter needed.
- **Waves of five.** Adapters are built five at a time, then tested and admitted before the next wave. Platform Admin review is the limit; Firecrawl (50 concurrent browsers) and the worker are not. Wave 1: ANU, Melbourne, UTS, Macquarie, UWA.
- **Visual builder (target).** The Platform Admin works from a Firecrawl screenshot with its text blocks and the page-data tree, choosing values and adding comments. The cheapest qualified model, pinned by name, proposes the adapter, and the output is shown per attribute before saving. The model never saves, applies or admits. Admission stays a separate Platform Admin switch.
- **Production.** Configurations live in `pipeline.uni_adapters` and move with the database. The reviewed baseline is exported to `docs/adapters/configs/` at each release gate and whenever an adapter is admitted or changed.

### Decision 253 — Firecrawl only, by use case, for universities that enrol international students
**Status:** Current (4 October 2026, migrations 20261004001200–20261004001250, worker coverage-sweep v0.15.1, release v2.15.180, Pilot PR #299) · **Recorded in:** this reference · **Amends:** Decision 252 (Serper and ScrapingBee are no longer used) · **Source:** Platform Admin, 4 Oct 2026 15:51
- **One service.** Firecrawl (Growth plan, 500,000 credits a month) is used for search, page reading and site maps. Serper and ScrapingBee keys stay saved but are not used.
- **Target universities only.** A rule of settings picks the targets: countries, a name pattern, names left out, the least number of active courses per country (AU 100, NZ 100, CA 30) and the international-student registers (CRICOS, NZQA, IRCC DLI). The Platform Admin can add or take out any provider with a reason. A setting (on) keeps every Firecrawl call of the coverage worker to the targets. On 4 Oct this gave 57 targets: AU 34, NZ 8, CA 15.
- **By use case, each with its own settings and credit allowance.** A run is started by the Platform Admin with a reason, carries on every minute and stops at its allowance or at the plan's reserve.
  - **Read pages:** course-like pages that need a browser or refused a plain read. Research archives, profiles and PDFs are skipped.
  - **Find pages:** a Firecrawl search on the university's own site for courses without a confirmed page.
  - **Pages found or read go through the existing identity check and approved admission paths.** Nothing new is admitted by a run.
- **University adapters, set in the UI.** Each adapter is one university's own settings:
  - patterns taken off page titles and catalogue titles;
  - where the page keeps its data as JSON (a script id and a path for each field);
  - where each field is on the page (a heading pattern).
  - An adapter is previewed on stored pages (no credits), then applied. It is also used by the reader, so handbooks that keep their data in the page (CourseLoop: Flinders, Macquarie, Murdoch) are read from a plain fetch with no Firecrawl credits.
  - A page an adapter confirms gets the identity basis adapter_code or adapter_title. **No country admission rule allows these yet. Allowing them is a separate Platform Admin decision.**
- **Report for Firecrawl support.** Every Firecrawl call made by a run is logged: the request, HTTP status, error, scrape id, credits, proxy used and the page's own status. The Firecrawl panel shows the report and copies or downloads it as Markdown.
- **The platform's allowance follows Firecrawl's own balance.** It was still set to the old 100,000 plan and would have stopped all Firecrawl work at about 86,000 credits used this month.
- **Amended 17:19 (v2.15.181, migration 20261004001260).** Adapter identities may be admitted. The country rules list adapter_code and adapter_title for links, English and intakes. Each adapter also has its own admit switch, off until the Platform Admin has tested what it would admit; requests for improvement are kept with the adapter.
- **Archived and test sites are refused (17:19).** A setting holds their host pattern. A page on such a host is never bound unless a person entered it by hand. Values admitted automatically from such pages are taken out of use and logged.

### Decision 252 — One admission plan and toolset: observe, notify, trial before use, never overwrite
**Status:** Current (4 October 2026, migrations 20261004000600–20261004000900, workers layer3-model-routing v10 and toolset-runner v1, releases v2.15.177–v2.15.178; amended 14:26); **amended by Decision 253:** Firecrawl only, Serper and ScrapingBee not used · **Recorded in:** this reference · **Extends:** Decisions 221, 251 · **Source:** Platform Admin, 4 Oct 2026 13:37, on the failure review of 12:39
- **This is the admission plan.** Every attribute goes through one pipeline — register, find the page, identify it, read and admit, AI check, person — with one second strategy under each stage. Layers are not re-planned per field; a new country or attribute is a new row of settings and sources, not a new design.
- **Decisions by step** (each recorded and changeable only by the Platform Admin with a reason):

| Step | Decision | State on 4 Oct 2026 |
|---|---|---|
| AI (Layer 3) | OpenRouter is **not capped by the platform**. Daily guards and the credit floor are shown and raise notices but stop nothing ("observe only"); one switch returns it to "stop at limits". Logs (spend by day and task, refusals) are collected and the balance is topped up when the Platform Admin decides. | Observe only; US$27.67 left. The key's own weekly limit is set at OpenRouter, outside CourseFinder; it refused 568 calls between 29 Sep and 2 Oct. |
| Find the page (Layer 2) | **Serper** finds course pages and websites for providers with none. Sample runs cover every country listed in its settings (AU, NZ, CA to start; new countries are added as rows). | Key saved (free plan, 2,500 credits); switched on by the Platform Admin. |
| Read the page (Layer 2) | **ScrapingBee** reads pages that need a browser or refuse a direct read, in every listed country. Pages a provider's robots file disallows stay unread. | Key saved (free plan, 1,000 credits); switched on by the Platform Admin. |
| Scholarship pages (Layer 2) | Scholarship share of Firecrawl raised from 3,000 to 6,000 credits so held scholarships are re-read. | 6,000 (2,974 used). |
| Tuition (Layer 3) | Benchmark two pinned models (Qwen3-235B and Kimi K2) on a fresh holdout; a pass never switches a model on by itself. | To run after the sample runs. |
| Jobs | Consolidate 84 scheduled jobs to about 28 in two steps: pause duplicates, retire them after seven clean days. | Planned. |
| Go-live | GO/NO-GO is set two weeks after the sample-run results are reviewed. | To be dated at that review. |

- **Notices, not silent stops.** Each layer's page shows a notice when a toolset it depends on hits a limit or times out — OpenRouter refusals and balance, spend past a guard, Firecrawl balance and caps, scheduled jobs that hit the database time limit or fail, edge function time-outs, sample runs stopped by a limit, a key's plan at its reserve. Notices are worked out from logs that already exist when the page is read, so no new scheduled job is added. A notice can be acknowledged with a reason and comes back if the limit is hit again.
- **Incremental, never from scratch.** New evidence never overwrites an admitted value or a value entered by hand. Each pass adds candidates that go through the same identity and admission checks; every run and setting change is recorded (sample runs and their cases, the control log), so iterations can be compared.
- **Nothing hard-coded that the Platform Admin cannot change.** Every per-run limit, cap, look-back, threshold, query wording and rendering option is a settings row shown in the UI. Prompts and validators are versioned and shown read-only in Layer 3; they change only through a reviewed migration because a model's qualification is bound to them.
- **Keys carry their plan's limits (amended 14:26).** Each outside service runs on a key whose plan limits — plan name, credits, monthly renewal, the date credits are counted from, credits kept back, calls at once — are settings in the UI. A free key is used now; moving to a production key is saving the new key on Environment & integrations and entering the new plan's limits. No code changes. Work using a service stops when its key's plan reaches the reserve, with a notice. No "trial" wording is used for the toolset or its code.
- **Sample runs record, they do not admit.** A sample run takes real cases from the backlog per country, records each call's outcome and credits, and projects the cost for the whole backlog. Using the results is a separate step the Platform Admin approves.

### Decision 251 — Scholarships are set up and watched on the layer they belong to
**Status:** Current (4 October 2026, migration 20261004000300, release v2.15.173) · **Recorded in:** this reference · **Extends:** Decisions 139, 249, 250
- Layer 1 › Scholarships holds the countries switched on and every scholarship source by country, each with one use: Ingest (read into records), University pages, Reference (for looking up) or Validation (to compare with our records). Third-party aggregators are Validation or Reference only, never a source of record.
- Layer 2 › Scholarships shows what was found, read, added and refused by country, with the per-run limits and the job switches; Layer 3 › Scholarships shows the AI check, which stays off until a pinned model passes its benchmark and a person switches it on; Layer 4 keeps publishing and the jobs after it.
- Values the jobs use are kept as settings, not in job commands or function text. Changes need a Platform Admin and a reason and are logged. A source added for Ingest is registered, not read, until a reader exists for it.

### Decision 250 — Scholarships for New Zealand and Canadian universities; the Scholarships module shows published only
**Status:** Current (4 October 2026, migration 20261004000100, reader scholarship-sweep-v0.6.0, release v2.15.172) · **Recorded in:** this reference · **Extends:** Decisions 139, 244, 245, 246
- New Zealand and Canadian universities are searched for their own scholarship pages exactly as Australian universities are; only universities are admitted outside Australia (the Australian rule is unchanged). Discovery uses the website on the provider record or the one the website finder verified.
- Amounts are kept and shown in the university's own currency (A$, NZ$, C$); a page amount marked in another currency is not taken as the value. Domestic-only wording is read for the study country (for example, Canadian citizens and permanent residents; New Zealand citizens, Māori and Pasifika scholarships).
- Government programmes are registered in Layer 1: Manaaki New Zealand Scholarships (read through each New Zealand university's own Manaaki page, so they link to that university's courses) and Study in Canada Scholarships (short exchanges for students enrolled abroad; registered for reference, not linked to courses).
- The Scholarships module lists published scholarships only, without status filters; ready, held and withdrawn scholarships are handled in Layers 1 to 4. The scholarship record lists the courses it is linked to.

### Decision 249 — Scholarship publishing is a Layer 4 decision
**Status:** Current (3 October 2026, release v2.15.169) · **Recorded in:** this reference · **Refines:** Decision 139
- Publishing a scholarship is a person's decision, so it sits in Layer 4 Review › Scholarship publishing with the other decisions; Scholarships › Publishing redirects there. Layer 3 checks with AI and never publishes.
- The nightly review (06:17 AEST) still withdraws a published scholarship that no longer passes a check; republishing is a person's step.

### Decision 248 — The scholarship value shown is built from the recorded value
**Status:** Current (3 October 2026, migration 20261003002700) · **Recorded in:** this reference
- What counsellors, the website and Zoho see as a scholarship's value is built from the recorded value — "20% of tuition fees", "A$10,000 a year", "Up to A$15,000", the page-tier range (Decision 245) — never a fragment of page text. With no recorded value it reads "Value not stated" and the scholarship is not publishable. The page's own words stay on the record and in the evidence.

### Decision 247 — A course's scholarships, and their savings, are a course attribute kept in step
**Status:** Current (3 October 2026, migrations 20261003002500, 002600, 002900) · **Recorded in:** this reference · **Refines:** Decision 212
- A course's scholarships (search, website, Zoho) are those **published, open to international students, and linked to the course by a decided course link**, each with its value, audience, nationalities, close date, page and saving per year with its basis. They are refreshed every 15 minutes for changed scholarships and fully each night at 06:51 AEST.
- Saving per year (percentage-of-tuition only): from the provider's annual international fee; where there is none, for Australia, estimated from the registered CRICOS tuition ÷ registered duration in years (at least one), marked as an estimate and replaced when a provider fee is recorded.
- A published or ready scholarship's page is re-read at least every 30 days; a changed value or date updates the record (never a value set by hand) and reaches the course within 15 minutes, the saving the next morning.

### Decision 246 — Scholarship nationality is read from the scholarship's own wording
**Status:** Current (3 October 2026, migration 20261003002200) · **Recorded in:** this reference · **Refines:** Decision 244
- Which nationalities a scholarship names ("citizens of India", "Sri Lankan citizen", "students from South Asia") is read hourly from its name, description and criteria against a fixed list of country names, demonyms and regions (`ref.nationality_terms`), with the matched phrase kept as the basis. An empty list means the page names none: the scholarship is open to any nationality its audience allows.
- Australia is never a nationality (it is the study country); at an Australian provider "New Zealand citizen" is the domestic rule (Decision 212), not a nationality. A value set by hand is never changed.
- The selections, the list, the record and the Zoho `scholarships` action carry the list; a semantic search (plan step 7) will filter on it.

### Decision 245 — Several values on a page become award tiers; the value is shown as a range
**Status:** Current (3 October 2026, migration 20261003002100) · **Recorded in:** this reference · **Refines:** Decision 212
- When a scholarship page states several values (by result, region or level) the single-value rule records none. Those values are now kept as award tiers, each with the page as evidence, and the scholarship's value text is the range in words ("20% to 70% of tuition fees"; "Up to A$15,000 (A$2,500, A$5,000, A$15,000 stated)" when the page says "up to").
- A value with page tiers counts as a stated value for publishing. It is never used for a fee saving: a saving is worked out only from a single percentage (Decision 212). Values set by hand, pages in another currency, and pages with no value are untouched.

### Decision 244 — Scholarship audience is read from the scholarship's own wording
**Status:** Current (3 October 2026) · **Recorded in:** this reference · **Refines:** scholarship publishing rules
- Platform Admin, 14:21–14:50 (multiple choice "Read audience from wording, then publish international"): who a scholarship is for is never a default. It is read from the scholarship's own name, description and criteria by fixed phrase rules — International students, Domestic students, International and domestic, or Not stated on the page — and the matched phrase is kept as the basis (`scholarship.audience_readings`). A value set by hand is never changed.
- Only International and International-and-domestic scholarships can be published or offered on course and provider pages; Domestic and Not stated are held until a person decides. Publishing stays a deliberate Platform Admin step; a reading never publishes anything.
- The reading runs hourly over active scholarships (job `scholarship-audience`) so newly admitted scholarships are treated the same way; the rules are versioned (`scholarship-audience-v1`) and move to Settings with the other rule sets under Decision 238.

### Decision 243 — Calendar rules: one list, parser versioned, a university's saved months are its rule
**Status:** Current (3 October 2026) · **Recorded in:** this reference · **Refines:** Decision 228, Decision 238
- Platform Admin, 13:50–14:05 (multiple choice "Fold into one list + fix parser"): there is one Academic calendars list. A university whose calendar page parsed shows its suggested Intake 1 and Intake 2; a university whose page gave no months (or has none in CourseFinder) is a row of the same shape with the periods its course pages name and the calendar page address to fill in. Saving writes each intake's month to every period of that rank the course pages name; the waiting intake reviews are answered within 10 minutes; nothing is rejected.
- The months a Platform Admin saves for a university are that university's rule: kept as an approved by-hand calendar, they win over parsed values for the same period, and a later parse never replaces them.
- The generic parsing rules (what counts as a period, a start word, a date, and which layouts are read) are versioned with the worker (`provider-policy-v0.2.2`: a period named on its own section row or heading applies to the start-date rows under it) and move to Settings › step 7 "University documents" as a tested rule set under Decision 238. There is no per-university parsing-rule editor.
- A new parser version re-reads stored documents without reading the site again; proposals it produces supersede earlier waiting ones, and approved calendars are untouched.

### Decision 242 — Australian provider-page tuition beside the CRICOS fee
**Status:** Current (3 October 2026; to build) · **Recorded in:** this reference · **Refines:** Decision 225
- Platform Admin, 13:25 (multiple choice): the fee printed on an Australian course page — per-term or per-year amount, number of terms and the total as printed — is captured and shown beside the registered CRICOS fee, labelled as the provider page's; CRICOS stays the registered fee. A difference above 20% between the two is flagged for review. The page's printed duration is recorded the same way beside the registered duration.

### Decision 241 — College intakes from the approved academic calendar
**Status:** Current (3 October 2026; migration 20261003001800; job provider-calendar-defaults) · **Recorded in:** this reference · **Refines:** Decision 228
- Platform Admin, 13:25 (multiple choice "Yes, but only for VET/TAFE colleges"): for an Australian college (a provider not named University) with an approved academic calendar, Intake 1 and Intake 2 as approved on the Academic calendars list fill every course of that college that has an official course page and no intake at all. Universities keep Decision 228's rule (a calendar only turns a period named on the page into a month).
- The default never overrides an intake stated on the page, set or removed by hand, or waiting in a review with a value; the calendar page is the evidence; the intakes carry a calendar_default key so they can be told apart and replaced when a page states its own.

### Decision 240 — Application deadline (international) is the sixth course attribute
**Status:** Current (3 October 2026; pattern step and AI contract to follow) · **Recorded in:** this reference · **Refines:** Decision 228
- Platform Admin, 10:58, after reviewing a UBC graduate page: every course carries the international application deadline — the open date, the deadline and the intake it applies to — read from the course page. Multiple choice (11:10): a plain pattern first ("international applicant deadline: 1 February 2027"), the AI contract with its own frozen holdout after, under the same admission rule as the other attributes. Shown on the course page and through the Zoho course API.

### Decision 239 — Canadian tuition from the course's own page
**Status:** Current (3 October 2026; tested on a hand-checked sample before switch-on) · **Recorded in:** this reference · **Refines:** Decision 220
- Platform Admin, 11:10 (multiple choice "Yes: course's own page, labelled International, in CAD"): Canadian tuition is admitted from a page that passed exact title or field + award when the amount is labelled international and the currency is CAD; the basis (first year, per year) is recorded as printed. Decision 220's code-on-page rule stays for every other case. Switched on only after the sample check, as a separate step.

### Decision 238a — Notes on a value and report-back from counsellors
**Status:** Current (3 October 2026; migration 20261003001600; Zoho course API action "report") · **Recorded in:** this reference · **Refines:** Decision 238
- Platform Admin, 10:46: an operator or Platform Admin leaves a note on a course value; a counsellor reports one through the Zoho course API. Both become an open flag on the course's field on Layer 4 › Flagged values, with the note, who said it and where it came from. A note never changes a value; a Reviewer or Editor acts on it.

### Decision 238 — Settings controlled from the UI; prompts as tested versions; Reviewer and Editor roles for customer staff
**Status:** Current (3 October 2026; migrations 20261003001000–20261003001300; releases v2.15.159–v2.15.160) · **Recorded in:** this reference · **Refines:** Decisions 172, 179, 229
- Platform Admin, 09:26: every value the pipeline runs on — throughput (universities per matcher run, items a minute, pages read per batch), Layer 3 limits (requests a day, daily spend guards, credit floor), the course-page search cap, the Firecrawl limit and reserve, and which page proofs admit each attribute per country — is shown and changed on one Settings page, grouped by pipeline step. A number applies at once and writes an audit row. Migrations stop being the way settings change.
- Prompts and rules (English, intakes, tuition, page identity, the AI matcher, Firecrawl extraction, scholarship patterns) are versioned contracts bound to the step they qualified. A Platform Admin edits one as a new version, tests it on the frozen holdout from the same screen, and switches it on by a separate click (multiple choice, 09:30: "Edit, test on holdout, then switch on"); nothing live changes until then.
- The course drawer opens on the course's values, each with one Change button; a value entered by hand is marked so, keeps its evidence and is never overwritten by the pipeline. No separate editor panel, no comparison strip.
- Customer staff vet data in two roles (multiple choice, 09:30): a Reviewer confirms or flags a value on the Courses, Providers and Scholarships pages; an Editor also changes a value in place. Every action is logged with who and when; neither role sees settings, rules, jobs or users, and neither action starts a pipeline run.
- The attribute set is fixed; the rapid admission plan fills it. Screens are folded, not multiplied: a new control goes on the page for its pipeline step, never on a new tab.

### Decision 237 — Matcher throughput; intake cascade steps 2 and 3; Firecrawl AI extraction as a provider-level candidate
**Status:** Current (3 October 2026; migrations 20261003000600–20261003000800; worker coverage-sweep v0.13.3) · **Recorded in:** this reference · **Refines:** Decisions 172, 220, 233
- Platform Admin, 08:17: the AI link matcher prepares up to 500 universities a run (the job asks 200) and runs 80 items a minute. The queues had been throttled by the prepare step (4 universities a run), not empty.
- Platform Admin, 08:45 (multiple choice "Yes, MiMo step 2, Kimi step 3"): the intake cascade is 1 Qwen3 30B, 2 MiMo v2.6 Pro, 3 Kimi K2 0905, 4 Claude Haiku 4.5 (final), 5 Claude Sonnet 4.6 (off). A model joins a cascade under the cascade admission rule of 29 September (at least 30 holdout cases, at least 80% right, 0 wrong-admitted), the rule every live step was admitted under; no stricter rule is applied to one model and not another.
- Platform Admin, 08:45 (multiple choice "Yes, qualify now"): Firecrawl's own AI extraction (JSON format) is a candidate route, tested on the frozen holdouts by the worker mode fc_extract_qualify under the same automatic checks as the live routes. Because Firecrawl does not name the model behind it, it can only ever be a provider-level route (Decision 172): one named service, re-tested weekly on the holdout, paused automatically on a failed re-test; never a step inside a model cascade. Result on 3 October: intakes meet the rule in two runs (43 and 45 of 47, 0 wrong); English does not (a wrong answer in both runs). Nothing is switched on by a passing test: activation for intakes is a separate Platform Admin step, and English stays unqualified.
- A qualification result is never acted on automatically. Every run is kept (pipeline.fc_extract_results) with the prompt wording used, so runs are comparable.

### Decision 236 — New Zealand university degrees by name; one approved policy document per university
**Status:** Current (3 October 2026; migrations 20261003000300, 20261003000400; worker coverage-sweep v0.12.1; release v2.15.155) · **Recorded in:** this reference · **Refines:** Decisions 202, 217, 227
- Platform Admin, 00:57 ("yes NZ"): a New Zealand degree page (bachelor to doctor) whose heading is exactly the degree name, optionally followed by its abbreviation, is the course's page when the page names no other level of it. Conjoint, double and broad degrees taught in many subjects never match. It admits the official course page, English and intakes.
- Approving a university's English policy or academic calendar closes its other waiting documents of the same kind. Several documents can be approved or rejected in one action, each with the same checks.
- The course-page search monthly credit cap is shown and set on Jobs › Priority queue (Platform Admin).

### Decision 235 — Canadian course pages by field and award; websites by full name and a fitting address
**Status:** Current (2 October 2026; migrations 20261002190000–20261002190200; worker coverage-sweep v0.11.2) · **Recorded in:** this reference · **Refines:** Decision 220
- Platform Admin, 22:55 (multiple choice "Yes, test then switch on"): a Canadian course page on the university's own site matches when its heading or title holds the same award (in words or its abbreviation) and exactly the same field. Combined, dual and double awards, generic awards, a different campus (UBC Okanagan) and archived calendar pages never match. It admits the official course page, English and intakes; tuition still needs the course code.
- A Canadian or New Zealand website is accepted when the full name is anywhere on the home page and the address fits the name (initials or a distinctive word), besides the title/heading and DLI rules of Decision 220.
- Canadian course searches use the title's words, not the catalogue title as an exact phrase.

### Decision 234 — Australian English by exact title; university English statements need one approval each
**Status:** Current (2 October 2026; migrations 20261002185600, 20261002185700, 20261002185800) · **Recorded in:** this reference · **Refines:** Decisions 203, 227, 233
- Platform Admin, 22:26: Australian English is admitted from a page on the provider's own site that shows the CRICOS code or whose title is exactly the course title. The CRICOS code is no longer required for English.
- A university's own statement of English by study level fills every course of that level with no English yet, with the statement as evidence (Decision 227). Each statement is approved once by a Platform Admin in Coverage › Attributes › English policies; a statement that leaves some courses unlisted is applied with those values marked to check (confidence 0.6).
- Reference and hint sites are read through Firecrawl when direct access fails. robots.txt is followed per RFC 9309; terms that forbid automated access are followed whatever tool is used.

### Decision 233 — Reference lists of universities give website hints only; a hint is used only when the home page proves it
**Status:** Current (2 October 2026; migration 20261002185500) · **Recorded in:** this reference · **Refines:** Decision 232
- Hipo university-domains-list and univ.cc are hint sources. A hint becomes a university's website only if its home page shows the CRICOS provider code (Australia) or, in Canada and New Zealand, the national domain plus the existing name or DLI rule.
- A source whose robots.txt cannot be read is not captured. A source whose terms forbid automated access or text and data mining (XuanXiao) is recorded as reference only and is never read by a job.
- Nothing from a reference list is admitted as a course value.

### Decision 232 — Third-party course directories are hints and counts only
**Status:** Current (2 October 2026; migrations 20261002184800, 20261002185200) · **Recorded in:** this reference
- Directory pages (Hotcourses only) are captured through Firecrawl with robots.txt respected, and stored as evidence under thirdparty/<site>/<country>/.
- Institutions are matched to providers by exact name only; course counts are kept for comparison. Nothing from a directory is admitted.
- The directory's terms bar commercial use without written consent: legal review before wider use.

### Decision 231 — Course pages are matched from the university's own site map by a pinned model; the identity rule still decides
**Status:** Current (2 October 2026; migrations 20261002184400–184700, 185100, 185300, 185400) · **Recorded in:** this reference
- For a course with no verified page, the closest addresses in the stored site map are given to one pinned model, which picks one or none. The choice must be one of them.
- The page is read and accepted only under the identity rule (course code on the page, exact title, NZQA title and level). Pages entered by hand are never replaced.
- Identity v0.5.7: a national qualification code before the exact title is the exact title. Stored mismatch pages are checked again without fetching.
- A refused model call (key limit, credit) returns the item to the queue without using an attempt.
- An AI page-identity check is qualified separately and is not part of this decision until the Platform Admin switches it on.

### Decision 230 — Candidate models are qualified on the frozen holdouts before any cascade change
**Status:** Current (2 October 2026; migrations 20261002184100–184300, Pilot PRs #251, #252) · **Recorded in:** this reference
- A new model enters as a paused profile pinned to one named model, copied from the qualified profile of the same task, and is run on the frozen holdout for that task.
- It passes with at least 95% exact on stated cases and zero wrong-admitted values; a pass never places it in a cascade — the Platform Admin does that separately.
- Results: MiMo v2.6 Pro passed English (37 of 37) and failed intakes (one stated page withheld); Kimi K2 0905 failed both (one stated page each). No wrong values were admitted by either.
- Platform Admin placed MiMo v2.6 Pro as English step 3 (final step) on 2 October 2026; Claude Sonnet 4.6 moved to step 4 and stays off.

### Decision 229 — Intake check v1.3.0 is a separate contract, switched on only after qualification
**Status:** Not qualified (2 October 2026; migration 20261002183800, router version 9) · **Recorded in:** this reference
- A new intake contract never changes the qualified one. Each profile names its contract, and every other profile keeps the binding it was qualified with.
- A candidate needs 95% exact on stated cases and zero wrong-admitted on the frozen holdout. It then stays paused until the Platform Admin switches it on.
- v1.3.0 failed: rolling or monthly intakes, a course closing to international students, and a general semester passage were admitted. A v1.3.1 goes to a fresh hand-read holdout.

### Decision 228 — Semester-only intakes are answered from the university's approved calendar
**Status:** In progress (2 October 2026; migration 20261002183400 live, 183410–183420 waiting for approval) · **Recorded in:** this reference
- A course page that names only its study periods ("Semester 1", "Trimester 2") gets months from its university's calendar.
- The calendar must be approved, or its start months set by hand, by a Platform Admin. Only periods with one start month are used.
- A review is answered only when every period it names has a start month, the page names no months itself, the course has no intakes and none set by hand, and no campus outside Australia is named.
- The course page stays the evidence. The page's words and the calendar months are both kept.

### Decision 227 — English requirements from each university's own policy, approved per university
**Status:** Current (2 October 2026, migrations 20261002182800–183200) · **Recorded in:** this reference (Pilot PR #249)
- A university's English language policy is read from its own site and parsed without AI into a default for undergraduate courses, a default for postgraduate coursework courses, and the courses it names with their own score.
- A Platform Admin approves each policy. Approval writes only to courses with no English requirement, no lock set by hand, no review open and no page still to read.
- Research degrees, double degrees, other levels and courses the policy names are held back.
- A default that most course pages disagree with cannot be approved (at least 10 compared).
- Policies that set scores by band, by faculty or only on course pages give no default.

### Decision 226 — Quote failures are re-run once; a repeat failure needs a new intake check
**Status:** Current (2 October 2026, migration 20261002182700) · **Recorded in:** this reference (Pilot PR #249)
- Intake and English reviews held only because the AI's quote was not on the saved page were sent back to the AI check once.
- Failures that repeat are fixed by a new, separately qualified check contract, never by changing the qualified one.

### Decision 225 — Tuition comes from the regulator where it publishes it
**Status:** Current (2 October 2026, migration 20261002182600) · **Recorded in:** this reference (Pilot PR #248)
- Australian tuition comes from CRICOS. Provider-page tuition is chased only where the regulator publishes none, and only for international students.
- Australian tuition work and reviews were closed with the reason kept. Recorded fees were not changed.

### Decision 224 — Tuition reviews are settled against the page's international view
**Status:** Current (2 October 2026, migrations 20261002182400–182500) · **Recorded in:** this reference (Pilot PR #247)
- A tuition review asks a person only about a page's international annual fee.
- Bursaries, scholarships, loan caps, health cover, salaries, deposits and other fees are never tuition.
- A per-session fee or a course total is never taken as annual.
- A review about any other figure is closed with both amounts kept, and the page's international fee goes to the AI check.

### Decision 223 — A fee follows the page's own domestic or international view
**Status:** Current (2 October 2026, migrations 20261002182100–182300) · **Recorded in:** this reference (Pilot PR #246)
- On a page that switches between a domestic and an international view, each fee belongs to the view it sits in.
- A course total, or a fee for one study period, trimester or unit, is never an annual fee.
- A review that the recorded fee already answers, confirmed again by the current reader on the same page, is closed with its reason kept.
- The retired pipeline's fee feed is paused.

### Decision 222 — Fetch an area works on the course-page sweep; websites not found go to a person
**Status:** Current (2 October 2026, migration 20261002182000) · **Recorded in:** this reference (Pilot PR #245)
- **Fetch an area:** it shows where a country, state or university stands in the course-page sweep, and Start puts that area first. Nothing admitted or entered by hand is changed.
- **Websites to find:** a university whose own website the finder cannot confirm waits in Layer 4 › Websites to find. A website a person enters there is never changed by automation.
- **Errors:** each worker error says what to do.

### Decision 221 — A cascade task never falls back to a switched-off model
**Status:** Current (2 October 2026, migration 20261002181900) · **Recorded in:** this reference (Pilot PR #244)
- Intakes and English are answered only by cascade steps that are switched on. With none switched on, nothing is sent to any model.
- A page sent back from Layer 4 to one named, tested model is the only exception.
- Recent results shows the model that actually answered.

### Decision 220 — The old Layer 2 pipeline is retired; Canada is admitted like New Zealand
**Status:** Current (2 October 2026, migration 20261002181800) · **Recorded in:** this reference (Pilot PR #243)
- **Retired, not removed:** the older provider-reading pipeline's 7 scheduled jobs are paused and its history kept. Layer 2 Overview lists only what someone can act on now, each item with guidance and a button. History shows daily progress by country.
- **Canada:**
  - A university's own site is found by name and accepted only on its own .ca site whose home page names it or prints its DLI number.
  - Course pages are accepted on the exact course title.
  - Fees are read in Canadian dollars and taken only from a page that prints the course's code.

### Decision 219 — Every country's providers carry its own divisions; flagged values can be decided in bulk
**Status:** Current (2 October 2026, migration 20261002181700) · **Recorded in:** this reference (Pilot PR #242)
- **Divisions:** each country's states, provinces or regions are held in the reference list by their ISO 3166-2 codes (Australia 8, Canada 13, New Zealand 17). A provider's division is set from its own address or town; a town that names two places, or an overseas address, is left for a person. A division set by hand is never changed. The filter uses each country's own name for its divisions.
- **Bulk decisions on flagged values:** Pipeline Operators and above may confirm, mark as whole course or remove many flagged values at once; each is recorded as that person's decision, the same as one at a time.

### Decision 218 — Fee periods are settled from the page wording; worker errors name their job
**Status:** Current (2 October 2026, migration 20261002181600) · **Recorded in:** this reference (Pilot PR #241)
- **Fee periods:** a fee the Layer 3 fee check adds as per year with its period unconfirmed is confirmed automatically when the page wording it quoted says per year, or when the course runs a year or less. Wording that names another period is never confirmed; those fees stay in Flagged values for a person. Each automatic confirmation records the rule and the quoted words.
- **Worker errors:** every scheduled call records the function and mode it called, and Live activity shows the job behind each error reply. An error marked as seen (Pipeline Operator and above) is hidden until it happens again.

### Decision 217 — New Zealand course pages are proven by NZQA title and level or NZQA number; NZ tuition in NZD
**Status:** Current (2 October 2026, migrations 20261002181300–20261002181500) · **Recorded in:** this reference (Pilot PRs #239, #240)
- **NZ page identity** (in addition to the programme code and exact title of Decision 202):
  - `title_level`: the page heading (or the page title before the site name) is the NZQA title without "(Level N)", or with the same level, and the page shows "Level N". A page that names the same qualification at another level is not accepted on its title.
  - `nzqa_code`: the NZQA qualification number printed with its label.
  - Both are admitted for official links, English and intakes.
- **NZ tuition** is read in NZD and, as in Australia, only from a page that prints the course's code. It is validated by the qualified Layer 3 tuition model before admission; unclear fees go to Layer 4.
- **Course-page search** covers courses without a CRICOS code at the title stage, with the NZQA level suffix dropped. NZ providers use the generic own-site recipe; pages still rejected after a re-read are searched each minute.
- **Fee schedules** are CRICOS-matched (Australia only) and follow the Coverage country and university filter.

### Decision 216 — Every background function signs in with one-time run passes
**Status:** Current (2 October 2026, migration 20261002181200) · **Recorded in:** this reference (Pilot PR #238)
- **No shared automation key:** every scheduled job and background worker signs in with a one-time run pass, valid for 5 minutes and usable once, consumed under the receiving function's own name. No function accepts the long-lived automation key.
- **One allow-list:** `pipeline.pilot_nonce_functions` decides which functions can be given a pass. Database callers use `svc_pilot_submit_nonce` or `svc_pilot_issue_nonce`; a worker that calls another worker makes a fresh pass for each call (never forwards the one it received). A new background function is added to this list and to the deploy workflow's allow-list.
- **Deployed from git only:** background functions are deployed by the deploy workflow from the repository, and live code is compared with git after each deploy. Code found running without its source in git is committed before it is changed.

### Decision 215 — Scheduled workers sign in with one-time run passes; worker errors are shown
**Status:** Current (2 October 2026, migrations 20261002180900–20261002181100) · **Recorded in:** this reference (Pilot PR #237)
- **Run passes:** a scheduled job calls its worker with a one-time run pass (`pipeline.svc_pilot_submit_nonce`, allow-listed per function); the worker accepts it once (`svc_pilot_consume_nonce`). The long-lived automation key expired on 30 September 2026 and is not used for new work.
- **Worker errors are visible:** a scheduled run only sends the request, so its success says nothing about the worker. Live activity (admin_read 'live_activity') lists error replies that workers sent back in the last few hours (pg_net), with a plain-English reading. A job that relies on a worker must have its worker's reply shown, not just the run's status.
- **Evidence link indexing** reads compressed saved pages. Pages wrongly recorded as having no links were indexed again.

### Decision 214 — Live activity shows every layer's work; discovery keeps its own list
**Status:** Current (2 October 2026, migrations 20261002180600–20261002180800) · **Recorded in:** this reference (Pilot PR #236)
- **Live activity** (admin_read 'live_activity', every role, read only) lists every scheduled job in pipeline.automation_catalogue by layer. Each job shows its state (Running now, Working, Up to date, Scheduled, Paused, Stuck, Failing), last run, failures in 24 hours, work left and done in 24 hours where it has a queue, the worker's last reply and the next run. It also shows what is waiting for a person. A new scheduled job must be added to the catalogue so that it appears.
- **No silent stops:** a job that works through a list keeps that list filled itself (scholarship discovery: job scholarship-discover-refill keeps 30 providers waiting, adding the largest not yet searched). A list that has run dry shows as Up to date; a waiting list with nothing done in 24 hours shows as Stuck.
- **Release check:** deployed-release-currentness downloads the served bundle before searching it for the version (never a pipe into `grep -q` under pipefail).

### Decision 213 — Coverage by country and university; fee schedules approved in bulk; course-page pattern requests retired
**Status:** Current (2 October 2026, migration 20261002180500) · **Recorded in:** this reference (Pilot PR #235)
- **Coverage & completeness** counts every active course in every country, with the country on each row; provider tiers are ranked within each country. Every count, list and trend can be narrowed by country and by university (admin_read course_coverage, course_coverage_courses, course_coverage_providers). Daily attribute counts by country are kept in pipeline.course_coverage_daily_by_country; history before 2 October 2026 is Australia only.
- **Fee schedules:** a Platform Admin may approve or reject several waiting schedules at once (each is still decided on its own). A schedule with nothing to add is closed by approving it, which records the decision and settles flagged fees it answers. Every row of a schedule can be reviewed before deciding.
- **Course-page pattern requests** (CF-054) are retired: the course-link search (Decision 204) finds course pages. Existing requests are cancelled with the reason; new ones are created cancelled.

### Decision 212 — Scholarship publishing: domestic only held back, "up to" values as maxima, savings per year
**Status:** Current (2 October 2026, migration 20261002180400) · **Recorded in:** this reference (Pilot PR #234)
- **Domestic only:** a scholarship is not publishable when the provider page's student type (Decision 211) names domestic students only. It is publishable again only when a Platform Admin records that international students can apply (Scholarships › Publishing › Domestic only; a note is required; stored as a person's criterion that automation never changes). The daily review withdraws a published one.
- **"Up to" values:** when the page states a single maximum amount or percentage and the record has no value, it is recorded with award_value_is_maximum. It is shown as "Up to …", counts as a stated value for publishing, and is never used to work out a fee saving. Values entered by hand are not changed.
- **Savings:** a percentage off tuition fees is worked out per year from the course's annual international tuition fee recorded from the provider (fee type provider_current_tuition). The scholarship's year is used when it states one, otherwise the latest year. Two different fees for the same year are left for a person. Refreshed daily (job scholarship-savings).
- Publishing itself is unchanged: a Platform Admin publishes the ready list with an approval note.

### Decision 211 — Scholarship eligibility and award scope are read from the provider page
**Status:** Current (2 October 2026, migration 20261002180300) · **Recorded in:** this reference (Pilot PR #233)
- **What is read** (scholarship reader v0.5.3, from the eligibility section and short "key details" lines; each item keeps the page's own words):
  - student type: domestic, international, or both;
  - study stage: new (commencing) or current students; a page naming both gives neither;
  - full-time study; minimum ATAR, GPA (with its scale when stated) or weighted average;
  - citizenship lists, gender restrictions, and consideration without an application;
  - award duration: one-off, first year only, each year, each year for the length of the course, for the length of the course, or each semester.
- **Exclusions are respected:** "not an Australian citizen", "... are not eligible", and "not eligible ... if you: are an Australian citizen" do not make a scholarship domestic.
- **Where it goes:** scholarship.criteria rows marked value_json.by = 'scholarship_sweep'. A changed page supersedes the earlier sweep rows. Criteria from people, AI or feeds are never touched. Award duration is filled only where the record has none.
- **When:** on every scholarship page read. Stored pages are re-read without fetching (worker mode scholarship_reextract) when the reader version changes.
- **Not changed:** publication rules and fee-saving calculations. Old course-link candidates are kept as superseded, not deleted.

### Decision 210 — An approved fee schedule settles the flagged fees it answers
**Status:** Current (2 October 2026, migration 20261001180200) · **Recorded in:** this reference (Pilot PR #232)
- **What a flag asks:** whether a fee shown without a period is per year or for the whole course.
- **What an approved fee schedule answers,** for the same course (CRICOS code), using a per-year row:
  - the same amount: the flag is confirmed by the schedule, and the fee takes the schedule's year when it had none;
  - an amount within 15% (a whole-course fee would be about two or more times larger): the period is confirmed, and the recorded amount is unchanged;
  - anything else: the flag stays open for a person, with the schedule's fee shown beside it.
- It runs when a schedule is approved and ran once for the schedules already approved. Fees locked by hand are left for a person.
- Fee rules stay for universities without a fee schedule.

### Decision 209 — The Platform guide lives in the app and is reviewed with every release
**Status:** Current (1 October 2026, v2.15.136) · **Recorded in:** this reference (Pilot PR #230)
- Help › Platform guide is the operator and Platform Admin walkthrough. It is open to every role; each screen's Open button shows only when the person's role can open that screen.
- **Where the words are:** Pilot `src/guide/platformGuide.js`. They are plain Australian English, with no figures that go stale (counts and amounts stay on the screens). It has no screenshots.
- **What every release must do:**
  - update the entries for any screen, role, job, budget or alert it changes;
  - set `GUIDE_REVIEWED_FOR` to the release version.
- **Enforcement:** `npm run release:verify` (before every build) and the contract test refuse a release whose guide is not reviewed for its version, or that adds a menu page without a guide entry.

### Decision 208 — QS and THE universities linked to providers, kept linked for every country
**Status:** Current (1 October 2026, migration 20261001180000) · **Recorded in:** this reference (Pilot PR #229)
- **Automatic links** (job ranking-link, hourly, security.ranking_link_auto_v1), only within the same country and only to one provider:
  - the publisher's name equals a provider's name, or a provider alias (letters and digits compared);
  - or the name key (lower case, accents folded, no leading "The", nothing in brackets or after "|") equals a provider's name or alias, and the same provider is already linked under that key from the other ranking or another edition.
- Anything else is a candidate (ranking.provider_mappings status candidate: up to three providers with at least half their words in common). A Curator or above links or rejects it (public.admin_ranking_link). The provider must be active and in the university's country.
- A link applies to every edition of that university and keeps the publisher's name as a provider alias, so the next edition links at import. A link is never changed automatically; a second, different link is refused.
- New countries need no code: once a country's providers are in the catalogue, the hourly job links its universities across all editions held.
- **Screens:** filters by country, state (from the linked provider), provider and link; the provider record shows QS and THE ranks by edition.

### Decision 207 — The Firecrawl budget guard follows the balance Firecrawl reports
**Status:** Current (1 October 2026, migration 20261001179500) · **Recorded in:** this reference (Pilot PR #228)
- The guard used the platform's own usage per calendar month against the 100,000 plan. Firecrawl's period runs 29th to 29th and some usage is outside the platform's count: at 19:30 on 1 Oct the guard showed 60,657 credits left and Firecrawl 47,476.
- The job firecrawl-credit reads Firecrawl's balance every 15 minutes (pipeline.vendor_credit_observations).
- security.layer2_provider_budget_status uses the lower of its own count and the last reading (under 2 hours old) less the platform's use since. The reserve stop (2,000 credits) is unchanged.

### Decision 206 — Layer 3 English and intake claims: no duplicate calls, under the time limit
**Status:** Current (1 October 2026, migrations 20261001179000, 20261001179100, 20261001179300) · **Recorded in:** this reference (Pilot PR #227)
- Releasing a stale claim (after 30 minutes) also closes its interpretation, as hourly housekeeping does; a course with an open call is never claimed again.
- One claim at a time per task, so two claims sent together never choose the same course.
- The identity and block checks are joins, not per-row functions: a 40-item claim takes 0.6 seconds (was 9.1, over the 8-second limit for calls through the API). The pages chosen are the same.

### Decision 205 — Institution-level fee schedules, approved by a Platform Admin
**Status:** Current (1 October 2026, migrations 20261001178000, 20261001179200, 20261001179400) · **Recorded in:** this reference (Pilot PRs #226, #227, #228)
- Platform Admin approval 3 (1 Oct 2026 16:54, "build it"; 18:15 "go ahead with the institution reader").
- The job provider-facts (every 10 minutes) searches each provider's own site for its international fee schedule, English policy and academic calendar, and follows fee PDFs linked from a fee page. Documents are kept as evidence.
- A fee row is kept only when one CRICOS code and one amount sit on the same row, with the basis from the column heading (a schedule split across pages keeps its heading).
- Each document becomes a proposal. A Platform Admin approves it on Coverage › Attributes › Fee schedules. Approval writes a fee only where the course has no current tuition and no Layer 4 tuition review is pending; a different fee on record is listed, not changed. Per-semester rows and courses with several amounts are not used.
- English policies and calendars are found but not read until a qualified extractor exists.

### Decision 204 — Course-link search runs in the coverage-sweep worker
**Status:** Current (1 October 2026, migrations 20261001175000, 20261001176000, 20261001177000) · **Recorded in:** this reference (Pilot PRs #224, #225)
- Searches sent through the database's outbound queue (pg_net) stalled it at 80 a minute: the queue sends in rounds of 200 and each round waits for its slowest call.
- The worker (mode link_search) runs searches six at a time and records each through the same rules; job course-link-search-worker every minute.
- The one-time pass a job hands the worker lasts 5 minutes, so a call delayed in the queue is still accepted.

### Decision 203 — Australian exact-title pages admit course links and intakes
**Status:** Current (1 October 2026, migration 20261001173000) · **Recorded in:** this reference (Pilot PR #223)
- Platform Admin approval 2 (1 Oct 2026 16:54): a page on the provider's own site whose title is the course title admits the official course page and intakes.
- Tuition and English still need the CRICOS code printed on the page.
- Set in pipeline.coverage_admission_countries (AU row), together with Decision 202.

### Decision 202 — New Zealand admission: NZ programme code or exact title, NZD only
**Status:** Current (1 October 2026, migration 20261001173000) · **Recorded in:** this reference (Pilot PR #223)
- Platform Admin approval 1 (1 Oct 2026 16:54): NZ values are admitted when the page is on the provider's own site and shows the NZQA programme code or the exact programme title.
- **Values:** official course page, intakes and English. Tuition waits for the NZD tuition path.
- **Rules per country:** they live in pipeline.coverage_admission_countries (identities per value, currency), so a country added later is a row, not new code. The admission plan, the admission apply step and Layer 3 (claim and admit) read it.
- **How NZ values are written:** through security.coverage_apply_course_v1, keyed by the course and its evidence. It refuses a fee whose currency differs from the country's.
- A tuition entered by hand defaults to the course country's currency.

### Decision 201 — Course link refresh schedules for every country
**Status:** Current (1 October 2026, migration 20261001172000) · **Recorded in:** this reference (Pilot PR #223)
- **Where schedules are set:** pipeline.link_refresh_policies, for all countries, one country or one provider, per link type. The most specific schedule wins.
- **Defaults (all countries):** official page every 30 days; handbook, admission centre and regulator listing every 90 days.
- **The job link-refresh (every 10 minutes, in Automations):**
  - re-reads pages that are due;
  - searches again for courses with no page after their period;
  - carries each read to the link: re-confirmed, or marked unverified when the page is gone (404/410) and the course searched again;
  - adds regulator links for new NZ codes.
- Links set by a person or confirmed in Layer 4 are never changed.
- pipeline.link_portals registers third-party and regulatory portals per country: NZQA (on), UAC, VTAC, QTAC, SATAC, TISC and Study Australia (off until their reader is verified).
- Both are maintained on Coverage › Courses › Link refresh.

### Decision 200 — Course links of every kind; who can apply
**Status:** Current (1 October 2026, migrations 20261001170000, 20261001171000, 20261001174000) · **Recorded in:** this reference (Pilot PR #223)
- **Link types (ref.course_link_types):** official course page, handbook entry, international students page, how to apply, admission centre listing, regulator listing.
- **Editing:** every type can be added, changed and removed in the course editor. Each type has its own manual lock, and automation leaves a hand-set link type alone until it is handed back.
- **"Has a course link"** still means the official course page everywhere: search projection, data quality, admin lists and the Layer 2 snapshot.
- **NZQA regulator page:** added for every NZ course.
- **Who can apply:** courses record open to international students and open to domestic students (yes, no or not known).
  - Australian CRICOS-registered courses are open to international students.
  - Providers record whether they enrol international students, and that applies to their courses not set by hand.
  - An English requirement is expected only where international students can apply.
  - Courses has the filter "International students".

### Decision 199 — Course-link search for every Australian provider
**Status:** Current (1 October 2026, migration 20261001164000) · **Recorded in:** this reference (Pilot PR #222)
- Course-link search looks for a course's own page on its provider's site with Firecrawl: first "<CRICOS code>", then "<title>". It used to run only for the 10 universities with a hand-written recipe.
- 920 more Australian providers that have a website and CRICOS-coded courses now have a generic recipe. Any page on the provider's own site can be a candidate, except files and news, event, staff and search pages.
- The safeguard is unchanged: a candidate page is used only when the reader finds the course's CRICOS code printed on it. Otherwise the next candidate is tried, then the title search, then the course is marked not found.
- Generic recipes are marked in their notes and can be switched off per provider. Websites holding more than one address (6) were left out.
- Monthly search allowance: raised from 15,000 to 50,000 Firecrawl credits, inside the 100,000-credit plan guard.
- Batch: 80 courses a minute, changeable in Automations.

### Decision 198 — New Zealand course-page coverage started; Layer 3 limited to Australia until NZ admission is approved
**Status:** Current (1 October 2026, migrations 20261001160000–20261001163000) · **Recorded in:** this reference (Pilot PR #222)
- **NZ providers in the pipeline:**
  - All NZ providers with active courses are in course-page discovery.
  - A second discovery worker runs beside the first; the queue never gives the same provider to both.
  - NZ websites with a doubled scheme were corrected, and the NZ register loader (`layer1-nz-live` v1.2.1) no longer creates them.
- **Layer 3 is limited to Australian providers.** This covers tuition (`svc_coverage_tuition_handoff_next`) and intakes and English (`layer3_fact_claim_service`). NZ programme codes appear on NZ pages like CRICOS codes, and the tuition step records AUD.
- **NZ pages are found, matched and read, but nothing is admitted for NZ** until a separate NZ admission rule is approved:
  - identity by NZ programme code or exact title on the provider's own site;
  - amounts in NZD.
- Open NZ Layer 3 items were parked, and their Layer 4 items were marked superseded with the reason. No NZ value had been written.

### Decision 197 — Older screens in the compact style
**Status:** Current (1 October 2026, v2.15.132) · **Recorded in:** this reference (Pilot PR #221)
- Screen review, 1 Oct (Fix): cc-two-styles, ast-big-tiles, rnk-style, cmp-hero, cmp-tiny-controls, imp-native, au-tall-rows, att-wide-table, att-vocab, l1-country-empty, l1-desc, l1set-hero, hc-chart.
- Changes by screen:
  - Logos & assets and the Rankings overview: compact tiles, small buttons and styled selects.
  - Compare: a light header in plain words.
  - Ranking imports: smaller controls.
  - Automations: two short rows per automation.
  - Coverage › Attributes: short column headings (full wording on hover) and a line explaining the two panels.
  - Layer 1: the country filter always shows a value, and Source settings has a light header.
  - Platform health: a short history chart, with the table on request.
- Not changed: the filter panels on Evidence, Jobs and Contacts, because the Platform Admin skipped "filter walls" in general.
- CSS and wording only.

### Decision 196 — Melbourne time, plain wording and counts that say what they cover
**Status:** Current (1 October 2026, v2.15.131) · **Recorded in:** this reference (Pilot PR #220)
- Screen review, 1 Oct (Fix): au-timezone, cc-time-format, cc-jargon, cc-counts-consistency, ds-blank, l2r-onboard (merge), onb-*, usr-*, pub-reasons-dead, hc-actions, hc-details-text, au-error-text.
- Every instant is shown in Australia/Melbourne time, with daylight saving, for every viewer. Calendar dates are shown as written. Schedules (which run on UTC) name the Melbourne time and day.
- About 80 on-screen strings were rewritten in plain words. Milestone and change-control codes no longer appear on screens; the release history is unchanged.
- Counts state their scope:
  - lists and Dashboard tiles: every status;
  - Coverage: active Australian courses.
- Rankings › Datasets is a proper list, replacing a panel injected by script that showed nothing when its read failed.
- The provider onboarding queue sits on Providers › Onboarding, as marked (merge). The older onboarding case tracker (0 cases ever) is collapsed beneath it.
- Users & roles explains each role, matching security.roles ranks 1–6.
- Publishing reasons and Platform health issues link to where they are fixed.

### Decision 195 — Edit in list for course facts, campuses and scholarships
**Status:** Current (1 October 2026, v2.15.130) · **Recorded in:** this reference (Pilot PR #219)
- Screen review, 1 Oct (Fix): crs-listedit-fields, cmp-readonly, sch-no-edit, cc-inline-edit, crs-detail-long, crs-detail-jargon, sch-fill-overlap, sch-decision-support, sch-jargon.
- **Courses › Edit in list** also edits tuition (amount, per year, semester, trimester or whole course, and year), intakes and English, through the existing admin_course_edit actions.
  - Start dates and sub-scores already held are kept.
  - The live `indicative_annual` basis is shown and saved as per year.
- **Campuses and scholarships** follow Decision 181: a person's entry always wins.
  - `pipeline.manual_locks` accepts campus and scholarship.
  - A guard trigger on each table keeps a person's value on every automated update.
  - `admin_campus_edit` and `admin_scholarship_edit` are Curator and above, and every change is logged. `admin_campus_create` is PIM Operator and above.
  - Migrations 20261001140000 and 20261001150000 are both md5-guarded, and each stored statement equals its file.
  - Rolled-back live test: hand-entered values survived a simulated automated update while unlocked columns still changed.
- **Course panel:** corrections and three less-used sections start collapsed, with plain wording.
- **Scholarships:** fill-from-clear-scopes and course decision support moved to Course links.
- **Not done:** Data model editing, which changes the catalogue structure. It is raised with the Platform Admin.

### Decision 194 — Layer 4 review queue: Bulk decisions, scholarship scope decided on Course links
**Status:** Current (1 October 2026, v2.15.129) · **Recorded in:** this reference (Pilot PR #218)
- Screen review, 1 Oct (Fix): l4-batch-naming, l4-scholarship-overlap, l4-legacy-style, l4-status-tiles, l4-forecast.
- Review queue: four even status tiles; filters read "All tasks", "Everyone / Mine / Unassigned"; items show "Yours" or "With someone else".
- "Batches" is renamed **Bulk decisions**. Below its groups are only:
  - provider departures (10 live records; nowhere else);
  - errors and improvements (kept until the Platform Admin decides on Layer 4 findings);
  - decision history (renamed from Mass audit).
- Removed from Layer 4:
  - scholarship scope cohorts: all 37,200 candidates were stale, and Scholarships › Course links decides once per scholarship (Decision 182), linked from here;
  - the older generic review cohorts, covered by the Bulk decisions groups;
  - the self-mounted reusable scope rules panel: no rule was ever saved.
- No database change.

### Decision 193 — Layer 2 split into Overview, Fetch an area, History and Source profiles
**Status:** Current (1 October 2026, v2.15.128) · **Recorded in:** this reference (Pilot PR #217)
- Screen review, 1 Oct (Fix): l2-bloat, l2-dup, l2-hour-table, l2-jargon, l2-mixed-style. The page was about 2,500px with about 15 panels.
- **Overview:** tiles, coverage and what is left, where work stops, fetchers, by hour (9 columns instead of 25; the full breakdown is in the row tooltip), not ready to fetch, recently accepted facts.
- **Fetch an area:** provider onboarding (each provider's course catalogue page, Decisions 141, 146 and 147) and the background area fetch.
  - Provider onboarding was kept: the review called it a duplicate of Providers › Onboarding, but that is a different feature (the case-stage tracker).
  - Background area fetch stays until the Platform Admin decides on it.
- **History:** progress, recent runs, recent page fetches and the execution trace.
- Removed as duplicates: the acquisition policy chain and its fixed example (Scrapers & fetchers), the Data Quality and Evidence boxes, an extra tile row, internal notes and the change-control footer.
- No database change.

### Decision 192 — Layer 3 Work queue rebuilt; fetchers set per source
**Status:** Current (1 October 2026, v2.15.127) · **Recorded in:** this reference (Pilot PR #216)
- Screen review, 1 Oct (Fix): l3w-banner, l3w-jargon, l3w-dup-buttons, l3w-placement, prof-style, prof-governance-text, prof-provider-btn, prof-routing-dup.
- **Layer 3 › Work queue** shows:
  - work by task: waiting, settled, no value on the page, sent to a person, failed;
  - course-page pattern requests, still run by hand, one at a time, with unchanged behaviour;
  - recent results.
- Removed from the Work queue:
  - the "AI interpretation is paused" banner: it counted older model-route records and could contradict Control;
  - the one-off manual run form: its task types had no activity in 30 days;
  - duplicate links.
- **Layer 2 › Source profiles** moved to the compact style; the governance footer and pipeline banner are gone.
- Which fetchers a source uses is now shown, added and tested in that source's detail panel:
  - adding a fetcher is PIM Admin only, with the same server call as before;
  - Scrapers & fetchers points there instead of having its own routing panel.
- No database change.

### Decision 191 — Fee rules, flagged values and Layer 3 Control easier to read
**Status:** Current (1 October 2026, v2.15.126) · **Recorded in:** this reference (Pilot PR #215)
- Platform Admin (1 Oct 09:24 AEST): the Layer 4 rules preview was "very hard to read".
- **Fee rules:**
  - the preview opens directly under the rule, with the page words centred on the rule's wording and that wording highlighted;
  - the tab is renamed "Fee rules".
- **Flagged values:**
  - filter by university and search by course;
  - "Confirm all N as per year" appears only once a university is chosen and confirms each item through the same call as one by one.
- **Send back to AI:** short reasons and days ago. "Layer 3 work that failed" moved to Layer 3 under Control.
- **Layer 3 Control:** short model names (full ID on hover), fixed column widths, compact row actions, and "stopped for today" when a task is over its daily limit.
- UAT helper fix: a page with only one visible tab shows no tab bar, which is the case for Layer 1 Register for operators since #213.
- No database change.

### Decision 190 — Dashboard opens with "Waiting for you"
**Status:** Current (1 October 2026, v2.15.125) · **Recorded in:** this reference (Pilot PR #214)
- Screen review, 1 Oct (Fix): dash-missing-todo, dash-duplicate-health, dash-tiles-low-value, dash-jargon, dash-security-strip.
- New `public.admin_waiting_read()` (migration 20261001130000, md5 equal to its file) lists nine queues. Each has its count, oldest item, link and the lowest role that can open it:
  - Layer 4 review items;
  - flagged values;
  - fee rules to approve;
  - scholarships to link;
  - scholarships ready to publish;
  - unreachable reference sites;
  - key dates within their warning window;
  - failed jobs;
  - failed automations.
- Rows above the viewer's role are dropped. A row that cannot be counted is skipped instead of failing the whole read.
- The rest of the Dashboard is four tiles, one platform-health line, four layer tiles and recent activity. The old command view, pulse and attention panels were removed.

### Decision 189 — Duplicate screens merged
**Status:** Current (1 October 2026, v2.15.123–v2.15.124) · **Recorded in:** this reference (Pilot PRs #212, #213)
- Screen review, 1 Oct (Fix): reg-merge-l1, l1set-merge-regulatory, reg-crash, rd-nested-tabs, mig-thin, sch-overlap, jobs-dup, au-overlap, dom-merge, src-cross-layer and others.
- **Regulatory settings** removed:
  - the bounded country runner moved to Layer 1 › Manual batch runs (Platform Admin);
  - the Pilot database reset moved to the Go-live checklist.
- **Environment migration** became the **Go-live checklist**: production settings, migration manifest, readiness gates and UAT.
- **Platform health › Capacity** is one page with no inner tabs.
- New **Layer 4 › Blocks** tab.
- **Scheduled jobs** tabs are Automations, Priority queue and Jobs. Schedules render under Automations without their copied run history.
- **Coverage** tabs are Courses and Attributes. Readiness by area is a section of Attributes.
- **Operations › Sources** is a new page, replacing Layer 1 › Sources.
- Old addresses redirect. Provider contacts stays where it is (Platform Admin's note). No database change.

### Decision 188 — One home per setting for models and services
**Status:** Current (1 October 2026, v2.15.122) · **Recorded in:** this reference (Pilot PR #211)
- Screen review, 1 Oct (Fix): models and services were switched or configured in five places.
- Where each setting now lives:
  - **Models & services:** the only on/off for models and services.
  - **Environment & integrations:** keys only.
  - **Scrapers & fetchers:** address, limits and routing.
  - **Layer 3 › Control:** cascade order and daily limits.
  - Layer 3 › Models was removed; old links open Models & services.
- A model can be switched on only after it has passed its test: a passed benchmark, or the tier rule (at least 80% right and 0 wrong on the frozen pages) for one of its tasks. Passing never switches it on by itself.
- Adding a model to a cascade no longer switches the model on as a side effect. Before this change it bypassed the activation checks.
- New fetching services start switched off.

### Decision 187 — Reference sources: third-party sites managed in the admin and read by the platform
**Status:** Current (1 October 2026, v2.15.121) · **Recorded in:** this reference (Pilot PR #210)
- Platform Admin (1 Oct 09:24 AEST): "notable third party links … UI should maintain and control profiles how they are used. Not hard coded in script or functions."
- Reference data › Key links became **Reference sources**. Each site has a domain, an on/off switch and ticked uses:
  - reference link;
  - data source;
  - never a university website;
  - never a course page;
  - scholarship placeholder;
  - logo directory;
  - ranking publisher.
- It was seeded with exactly the patterns that were previously hard-coded: 40 new sites and 7 existing ones.
- These now read the list instead of fixed patterns:
  - nine database functions (course-link binding, provider catalogue, six scholarship functions, source comparison; md5-guarded edits);
  - the coverage sweep (it fails closed if the list is empty);
  - the Ranking imports addresses.
- Scholarship publishability output was byte-identical before and after.
- Who can change what:
  - Curators: names, addresses, purpose, and "Check now".
  - PIM Operators: adding or retiring a site, or changing its domain, uses, category or switch. A reason is required and the change is logged.
- A placeholder site cannot be switched off while scholarships depend on it (111 depend on Study Australia today).
- Key dates is edited in place: list first, dd/mm/yyyy, cancel and restore, and a short form for adding a date.

### Decision 186 — Edit in list for Courses and Providers
**Status:** Current (1 October 2026, v2.15.120) · **Recorded in:** this reference (Pilot PR #209)
- Platform Admin (1 Oct 09:24 AEST): "can this be modernise and have inline edit on existing fields? Or better edit in list view on visible columns?"
- Courses and Providers have an **Edit in list** button (Curator and above). The editable fields become columns:
  - courses: title, duration, delivery, course page;
  - providers: name, city, website, phone, email.
- Click a cell to edit. Enter or leaving the cell saves; Esc cancels. A tick confirms each save, and a lock marks values entered by hand.
- Saves use the same guarded edits as the record panel (Decision 181), so every change is role-checked, logged and locked against automation.
- The read `admin_catalogue_edit_rows` takes up to 100 rows (one page).
- The screen review suggests adding tuition, intakes and English next.

### Decision 185 — Parse.bot removed completely
**Status:** Current (1 October 2026, v2.15.119) · **Recorded in:** this reference (Pilot PR #208)
- Platform Admin (1 Oct 09:24 AEST): "Parse.bot remove completely."
- Parse.bot had never fetched a page: no attempts, fetches, run items, benchmarks or trials.
- Removed:
  - the provider, its 2,098 source routes and its stored key;
  - its settings card and section;
  - the ranking URL-import route, i.e. the three functions `ranking-publisher-url-import`, `ranking-qs-url-import` and `ranking-the-url-import`;
  - every code reference. Two database functions were edited behind md5 guards.
- Ranking imports are file upload only. Rankings already imported and their evidence (one superseded QS 2026 file) are kept.
- The deploy workflow can delete only functions on a fixed retired list, and only once their source is gone from the repository.
- Keep `layer2-scope-discover-scheduled` at worker version v1.3.10: terminal-discovery freshness is keyed to that string.

### Decision 184 — Models & services: one on/off switch per model and service
**Status:** Current (1 October 2026, v2.15.118) · **Recorded in:** this reference (Pilot PR #207)
- Platform Admin (1 Oct 09:24 AEST): "Model or external should have toggle button to enable /disable. Disable should grey out or not available in operation but only in admin menu."
- **Platform settings › Models & services** lists every AI model and every page-fetching service with an on/off switch. Pipeline Operators can view it; PIM Operators and above can switch.
- Anything switched off stays listed there, greyed, and is not offered on operations screens (Layer 3 Control, Send back to AI, Layer 2 routing).
- Switching a model off also pauses it and switches off its cascade steps; the confirmation names the steps. Switching it back on does not put it back into a cascade; that stays a Layer 3 Control decision.
- Retired models (failed tests) are listed separately and cannot be switched on.
- Every switch is logged (`admin_control_events`, area `services`) with an optional reason.
- The 29 Sep production decision to drop ZenRows, Scrape.do and ScraperAPI is now one switch each; they are still on, pending the Platform Admin.

### Decision 183 — Layer 4 batch rules: one fee wording rule per university
**Status:** Current (1 October 2026, v2.15.116) · **Recorded in:** this reference (Pilot PR #205)
- Platform Admin (1 Oct 07:45 AEST): "simplify it and make provision in layer 4 to create those batch decisions and rules … same for Monash … make rules from ui".
- Finding: unsettled tuition at a university usually comes down to one wording.
  - UNSW: "2026 Indicative First Year Fee $56,500" is the international block; the domestic block says "First Year Full Fee".
  - Monash: "standard full-time course load for a year. The fees for 2027 are: A$46,640".
- Layer 4 › Batch rules:
  - A rule is a university plus the words just before the fee plus the fee period (with an optional address filter).
  - A preview shows every course it would settle and the amount.
  - Wordings repeated on 10+ pages with no fee are listed.
  - A Pipeline Operator prepares a draft. A PIM Operator approves it, which runs it at once and then hourly, and can pause it.
- A run admits international tuition only when:
  - the page is confirmed (CRICOS code on the page, or entered by hand);
  - the words match exactly one amount;
  - the course has no current fee and no value entered by hand.
- When a fee is admitted, the course's open Layer 4 tuition items are closed and its Layer 3 tuition work is marked admitted. Every run is logged, and every admission is kept with its matched text.
- The first two rules were prepared as drafts for the Platform Admin to approve: UNSW (214 courses) and Monash (231 courses).

### Decision 182 — Scholarship course links decided once per scholarship
**Status:** Current (1 October 2026, v2.15.115) · **Recorded in:** this reference (Pilot PR #203)
- Platform Admin chose "Clear the 37,200 links" as the first scholarship selection work.
- Finding: the 37,200 waiting links come from 87 scholarships whose pages name no course, so each was proposed for every course of its university. 17,008 of them were also mapped by the automatic sweep. For example, a scholarship for one Masters course was linked to 25 courses.
- Scholarships › Course links: for each scholarship, a Pipeline Operator or above chooses one of:
  - all proposed courses;
  - only matching courses (study level, broad field of study, words in the title);
  - no courses.
- Matching links are accepted and the rest rejected. The decision is saved with who made it and why, and can be changed.
- The hourly job `scholarship-scope-apply` applies saved decisions to links proposed later.
- The decision governs the automatic sweep: matching sweep links are taken over, non-matching ones are removed, and a guard trigger stops new excluded links. Links from the scholarship's own stated scope are untouched.
- A suggestion from the name is shown (for example "Master of …" suggests that course, "research" suggests research degrees). It is never applied on its own.

### Decision 181 — A person's entry always wins (CRUD for courses and providers)
**Status:** Current (1 October 2026, v2.15.114) · **Recorded in:** this reference (Pilot PR #202). This is build step 1 of Decision 179.
- Course detail › Edit this course: official course page (or "No page"), intakes, English requirement, international tuition, title shown, duration, delivery and description.
- Provider detail › Edit this provider: name, website, course finder address (sends the provider back to page discovery), phone, email, address and description.
- Access by role:
  - Curator and above can edit.
  - PIM Operator and above can add, archive and restore courses and providers.
- `pipeline.manual_locks` records each field a person set or removed. Guard triggers on the four course-fact tables, on courses and on providers stop every automated writer from overwriting or refilling it, without editing each writer.
- "Let automation update this" releases the lock. Layer 4 approvals do not lock.
- Every change goes to `pipeline.manual_edit_log` and is shown on the record.
- Setting or removing a value closes that course's open Layer 4 items for the same field.
- A hand-entered official page is trusted by the page reader (identity "manual", worker v0.6.3) and left alone by the site-map matcher.
- Not yet: the Hide switch (it comes with publishing, Decision 179 step 3). Admission of facts read from "manual" or exact-title pages still requires the CRICOS code on the page. Relaxing that is a separate decision.

### Decision 180 — Course link recipes: find course pages by CRICOS code on the university's own site
**Status:** Current (1 October 2026, 01:40 AEST) · **Recorded in:** this reference (Pilot PRs #199, #200)
- Platform Admin (1 Oct 00:39 AEST): take the "Further information" link that VTAC shows for each course, build the same strategy for the top 10 universities, and fetch the links with Firecrawl.

**Why not VTAC itself**
- The VTAC link is the university's own course page. For Monash it is built from the Monash course code: `https://www.monash.edu/study/course/B2029`.
- VTAC's robots.txt blocks all automated access (`User-agent: *`, `Disallow: /`). VTAC also lists only Victorian undergraduate entry, so most of the top 10 (NSW and SA) and all postgraduate courses are missing. We checked one VTAC page by hand to confirm the pattern and do not crawl VTAC.

**The strategy (per university, editable data)**
- `pipeline.course_link_recipes` holds, for each university:
  - the domain to search;
  - its address patterns, in order: the course page first, then the handbook entry.
  - `{year}` in a handbook address is replaced by the current year, so an old handbook hit becomes this year's edition.
- Monash: the course code comes from a handbook or publications hit, and the page is `/study/course/<code>?international=true`, the same address VTAC links to.
- For each course without a confirmed page:
  1. Search for the CRICOS code on the university's domain (2 Firecrawl credits).
  2. If nothing matches the patterns, search for the exact course title.
  3. The first match is bound as `cricos_search` or `title_search`.
  4. The page reader then has to find the CRICOS code (or the exact title) on the page. A page that fails the check, or answers 404, moves to the next candidate.
  5. Courses with nothing left are marked "none". They are the first entries for the Layer 4 "Course page needed" queue (Decision 179).
- The page reader renders a priority page through Firecrawl before it calls it a mismatch. UNSW and Melbourne handbooks are built by script and show the code only when rendered. This is worker v0.6.2.
- The site-map matcher (`coverage_bind_v2`) no longer overwrites or releases pages found this way.
- Limits:
  - Monthly credit cap of 15,000 (`pipeline.course_link_search_settings`).
  - The job `course-link-search` runs every minute with 40 searches per run. It appears under Automations, where it can be paused, run now or resized.
  - Universities are taken in turn, so the reader keeps up.
- To add a university, add a recipe row and queue its courses (`security.course_link_search_enqueue_v1`). An editor for recipes comes with the "Course page needed" queue.

### Decision 179 — Manual data first: CRUD at every level, course pages not found, automatic publishing
**Status:** Agreed (30 September 2026, 23:59 AEST); to be built · **Recorded in:** this reference
- Platform Admin: most foundational data will be handled manually, so every level needs create, edit and delete. A separate publishing step adds complexity.

**CRUD (build first)**
- Providers, courses, course facts (official page, intakes, English, tuition), scholarships, contacts and reference data can be added, edited and removed from their own admin page, by role.
- Every change is audited.
- A person's entry always wins: automation never overwrites a manual value or refills a value a person removed.
- Today the course and provider pages are read-only. Only Layer 4 (fee and official link when approving) and Flagged values (tuition) can change facts.

**Course pages not found (build second)**
- Each course carries a page status: found, searching, not found (last tried), or no page exists.
- **Every** course with no page found goes to a Layer 4 "Course page needed" queue (about 9,400 today). There an operator adds the link, sends it for another search, or marks "no page exists", which stops retries.
- Links are found in this order:
  1. One course catalogue address per university, for example the course finder section.
  2. A search per missing course.
  3. A link list supplied by the university (CSV upload).
- Every link still needs the course's CRICOS code on the page.
- Reason for the top 10 gap: the finder reads whole-site maps. Monash is recorded under its old domain (36 pages kept). Melbourne's course pages are on a separate study site (157 kept from 7,712). Macquarie and Newcastle list only part of their degree pages.

**Publishing (build third)**
- A record goes live automatically when it passes the basic checks. For scholarships: a stated value, its own page, and open to international students.
- Anyone rank 4 and above can hide any record, with a reason.
- Batch publishing (Decision 139) is retired when this is built. Course publication status is already unused: all 43,639 courses are "unpublished" and the website still serves them.

### Decision 178 — Priority queue set from the admin screens
**Status:** Current (30 September 2026, v2.15.113) · **Recorded in:** this reference (Pilot PRs #197, #198)
- Platform Admin, 03:22 IST: the admin screens must let an operator move universities or courses up or down, and add a country, state or university to the priority queue.
- Work order for the page reader and the Layer 3 intake and English checks:
  1. Pinned single courses.
  2. Pinned universities, states and countries, in the order of the pin list. A provider takes the best of its own, its state's and its country's pin.
  3. Australian providers by number of active courses.
  4. Everyone else.
- The page reader uses its Firecrawl fallback for pinned courses and the top 100 providers. Identity still needs the CRICOS code on the page.
- Screen: Scheduled jobs › Priority queue. Anyone rank 3 or above views; a Platform Admin adds, reorders and removes. Every change is logged.
- Not yet covered: the tuition AI check keeps its own order.

### Decision 177 — Admin layout: daily work separate from setup
**Status:** Current (30 September 2026) · **Recorded in:** this reference (Pilot PR #195)
- Platform Admin, 02:04 IST: the Layer 1–4 screens are confusing and bloated. Ask before merging views.
- Chosen layout: daily work (pipeline status, review, automations, health, evidence) is kept separate from setup (registers and sources, scrapers and budgets, AI models, scholarship runtime).
- Reference data that is not a register run lives in Catalogue:
  - Catalogue › Reference data holds Ranking imports, Key dates and Key links.
  - Onboarding sits under Providers.
  - Provider contacts sits in Catalogue.
- Older operator screens change only after the Platform Admin marks each action Keep, Merge, Remove or Ask on the screen review page.
- Whole-course tuition fees stay in Layer 4 for a person to decide. No automatic whole-course admission.

### Decision 176 — Layer 3 runs on cheap models; stronger models only when a person sends work from Layer 4
**Status:** Current (30 September 2026, v2.15.111) · **Recorded in:** this reference (Pilot PR #194) · **Changes:** Decision 172 (no Sonnet step)

**Direction**
- Platform Admin, 01:31 IST: stop using Sonnet, which was costing money for no outcome.
- Use cheap models with full coverage; anything they cannot settle goes to Layer 4.
- Send work to a specific model only from Layer 4, or edit it there.
- Admit as much as possible with more parallel streams.

**Why**
- In the two hours before the change, 172 of about 220 Sonnet intake calls followed two cheaper "not stated" answers. Sonnet agreed in 172 of 178 of those pages and found an intake on 3.
- About US$7 of the day's US$12.58 Sonnet spend produced nothing.

**Rules**
| Task | Cascade (cheapest first) | Unsettled at the last step |
|---|---|---|
| Intakes | Qwen3 30B → Claude Haiku 4.5 | Layer 4 |
| English | Qwen3 30B → Mistral Small 3.2 | Layer 4 |
| Tuition | Qwen3 235B (single) | Layer 4 |

- Qualification is unchanged: at least 80% right and no wrong answer admitted on the frozen holdout.
- On 30 Sep, four cheaper intake candidates were tested against the Claude Haiku 4.5 result of 93.6%. None qualified:

  | Candidate | Right | Wrong admitted |
  |---|---|---|
  | DeepSeek V3.2 | 43/47 | 1 |
  | GPT-OSS 120B | 37/47 (78.7%) | 0 |
  | Qwen3 235B | — | 1 |
  | Qwen3 Next 80B | — | 2 |

- Layer 4 › Send back to AI offers a model choice per field. The default is the cheap cascade. A named model may be any model in the task's cascade, including steps switched off such as Claude Sonnet 4.6, or a qualified tuition model.
- A page sent to a named model goes only to that model, with no escalation and no spot check. If still unsettled, it returns to Layer 4.
- Intake and English routes run every minute, 40 pages a run, 8 in parallel.

### Decision 175 — Everything configured is operated from the admin screens
**Status:** Current (30 September 2026, v2.15.110) · **Recorded in:** this reference (Pilot PR #193)

**Direction**
- Platform Admin, 29 Sep 23:45 IST: the admin UI must be in full control of every configured feature, as the Layer 3 screen is, including moving older entries between layers and managing the AI models.

**What the sweep found done only in the database, and where it now lives**
| Feature | Admin screen | Who can change it |
|---|---|---|
| The 58 scheduled automations (cron jobs) | Scheduled jobs › Automations: by area, plain name and purpose, schedule in IST, last run, 24-hour runs and failures | Platform Admin: pause or resume a job or an area, run now, change frequency (preset intervals), change batch size where the job works in batches. Platform health checks, job-history trim and duplicate-file removal: rank 6 only |
| Moving review items back to the AI | Layer 4 Review › Send back to AI, and a Send back to AI button on each Layer 3 task | Platform Admin: send a reason group or a whole field back to Layer 3; retry Layer 3 work that failed |
| Scholarship publishing (Decision 139) | Scholarships › Publishing: published, ready and held lists, and why the rest are not published | Platform Admin: publish the ready list with an approval note, hold with a reason, release a hold |
| Layer 3 models, cascade, limits and pause | Layer 3 AI validation › Control and Models (Decision 173) | Unchanged |

**Rules**
- Reads need rank 3; changes need Platform Admin (rank 5). Every change is logged in `pipeline.admin_control_events` and shown on the screen.
- Send back applies only to items the AI raised with no value already held. Differences from a held value, and items not raised by the AI, stay with a person.
- Reason groups hide amounts, so items with the same reason group together.
- A publish batch goes ahead only if the ready list is unchanged since it was shown. Each batch keeps a before-and-after snapshot of the website API.
- A hold takes a scholarship off the website and keeps it off future batches; there is no separate withdraw on screen, because a withdrawn scholarship would return in the next batch.
- Intake and English work that fails is released and retried automatically, so it is not counted as failed.

### Decision 174 — Tuition without a stated period is recorded as per year, and flagged
**Status:** Current (29 September 2026, v2.15.109) · **Recorded in:** this reference (Pilot PR #192)

**Direction**
- Platform Admin, 23:27 IST: tuition fees whose page does not state the period are treated as per year and flagged, and operators and admins can edit them.

**When the rule applies**
- Layer 3 has confirmed the fee: it matches the Layer 2 candidate, is quoted verbatim, is for international students in AUD or NZD, is within the ceiling and has enough confidence.
- The only reason it was held is that the period is not stated.
- The model, prompt and validators are unchanged; the rule applies at admission.

**When it does not**
- The quote names another period (total, whole course, per semester, term, unit or credit).
- The amount is a loan cap, student contribution, deposit or application fee.
- The course already has a current fee.
- The model decided the amount is not this course's tuition.
- All of these stay in Layer 4.

**Flags and editing**
- Every value admitted this way is flagged in `pipeline.data_flags`.
- Pipeline operators and admins (rank 4 and above) confirm it, correct the amount or period (per year or whole course), or remove it, on Layer 4 Review › Flagged values. Curators can view.
- Every action is kept on the flag.

### Decision 170 — Platform self-monitoring
**Status:** Current (29 September 2026) · **Recorded in:** this reference (Pilot PRs #184, #187)
- `security.platform_health_check_v1()` runs every 10 minutes.
- It checks scheduled jobs, edge function calls, sweep, scholarship and Layer 2–4 queues, stalled admission, budgets (Firecrawl, OpenRouter against the route guards, OpenRouter credit), database size and connections, search speed, the consumer API snapshot, reference bundle freshness and the nightly scholarship review.
- Issues are deduplicated, clear themselves when resolved, and can be acknowledged by an admin.
- Issues show on the Platform health screen, as a status dot in the top bar and in the daily update.
- There is no email alerting yet, because the platform has no email function.

### Decision 171 — Simplified admin menu and sources side by side
**Status:** Current (29 September 2026, v2.15.107) · **Recorded in:** this reference (Pilot PR #185)

**Menu and layout**
- The menu has five sections: Catalogue, Data pipeline, Operations, Platform settings and Administration, with Dashboard on its own at the top.
- `src/nav-map.js` is the single source for menu, tabs, role gates and redirects from old addresses.
- Every screen uses the standard page layout. Coverage & completeness, Administration, Jobs & Schedules and Statistics & Rankings no longer have their own shells or sub-menus.
- Layer 3 is one page with tabs: Routing, Models & profiles, Test results, Spend and Work queue.
- Platform settings has Environment & integrations (key names only, never values) and Scrapers & fetchers.

**Sources side by side**
- Both sources are kept and shown together, with differences highlighted:
  - Scholarship detail shows the provider page (primary) next to Study Australia (government).
  - Course detail shows the provider page next to the regulator (CRICOS).
- A confirmed provider page becomes a scholarship's source. The Study Australia address stays as an identifier and in the change log.
- The consumer scholarship API gains a `published_only` filter.

---

## Appendix A — Foundation principles (Design Decisions v1.0–v1.4)

These early, unnumbered principles shaped the admin interface. Where a numbered decision covers the same ground, the numbered decision prevails.

### From Design Decisions v1.0

**Status:** AUTHORITATIVE CROSS-CHAT UX / OPERATING CONTRACT  
**Date:** 18 August 2026  
**Architecture baseline:** `docs/coursefinder-database-architecture-v2.10.26.md`  
**Programme baseline:** `docs/coursefinder-master-project-plan-v1.26.md`  
**Related UX baseline:** `docs/coursefinder-admin-ux-information-architecture-v1.0.md`

#### 1. Purpose

This document records durable Admin/PIM product decisions so work performed from separate CourseFinder chats, countries, enrichment streams and implementation sessions converges on one interaction model.

Later chat callouts may extend this contract, but should not silently remove accepted features or replace them with a less efficient interaction unless a new documented design decision explicitly supersedes the relevant rule.

The canonical backend model remains authoritative. UI convenience must not weaken identity, evidence, lifecycle, publication or Search boundaries.

#### 2. Primary operating objective

CourseFinder Admin is a **decision and exception-management workspace**, not a passive database viewer.

Design for:
- minimum routine human effort;
- maximum deterministic automation;
- AI/agent assistance where it reduces repetitive review without inventing facts;
- rapid cross-checking of canonical record, source, evidence, freshness and publication state;
- few-click approve/reject/review workflows;
- dense information presentation with drill-in detail rather than navigation-heavy pages;
- safe bulk operations where the underlying decision is deterministic and auditable.

Human operators should primarily handle exceptions, ambiguous mappings, low-confidence structure and governance approvals that cannot be resolved safely by deterministic rules or bounded agents.

#### 3. Catalogue decision-grid pattern

Providers, Courses, Scholarships and similar high-volume entities should converge on the same list interaction pattern:

1. server-side pagination;
2. dense scan-friendly rows;
3. sortable column headers;
4. column/global filters that work with sorting and pagination;
5. persistent selected row state;
6. compact right-side detail/verification panel;
7. close/collapse detail without navigating away or losing list/filter/page state;
8. evidence/source/lifecycle/publication/Search signals visible before deep drill-in;
9. bulk action capability only where governance permits;
10. saved views as a later productivity layer.

A list-to-full-page navigation should not be required for ordinary verification.

#### 4. Mandatory Provider decision-grid fields

Provider rows should prioritise:
- Provider name;
- Country flag + ISO country code;
- State / Province / Region where canonically available;
- City;
- stable key / regulatory identifier as appropriate;
- Course count;
- Campus count where useful;
- Last Verified;
- Evidence count / evidence state;
- Lifecycle;
- Publication;
- Search projection/sync status;
- change/freshness status.

##### Provider website

A direct Provider website action is mandatory when an accepted website URL exists.

Rules:
- show a clear external-link affordance from the row and/or condensed detail header;
- open the authoritative Provider website in a new browser tab;
- never fabricate a URL;
- distinguish canonical Provider website from evidence/source URLs where both exist.

#### 5. Country and currency presentation

Where country or currency is relevant to the entity or value:

##### Country
Display:
- country flag;
- ISO alpha-2 country code;
- country name on hover/detail where space is constrained.

##### Currency
Display:
- ISO 4217 currency code;
- amount/value;
- currency symbol where unambiguous and useful;
- associated country flag only as contextual decoration where appropriate, never as a substitute for the currency code because currencies can span multiple countries.

The currency code is authoritative in the UI; a flag alone is never sufficient.

#### 6. Change intelligence and recency

Admin users must be able to identify what changed without manually comparing records.

Standard change signals should include, where the backend supports them:
- **Added** — canonical entity first created;
- **Modified** — canonical row last changed;
- **Source Changed** — new source-record/evidence content hash or source observation changed;
- **Amended** — governed material change to structured facts/relationships after initial canonical creation;
- **Verified** — last authoritative verification/check timestamp;
- **Evidence Updated** — latest evidence capture/version changed;
- **Publication Changed** — publication state changed;
- **Search Changed / Out of Sync** — Search projection differs from current publishable canonical state;
- **Stale** — verification/evidence age exceeds the relevant source/freshness policy;
- **Needs Review** — unresolved deterministic/AI confidence or governance issue.

Required filters/sorts should evolve toward:
- Added today / 7 days / 30 days;
- Modified today / 7 days / 30 days;
- recently verified;
- stale verification;
- source/evidence changed since last verification;
- newly unpublished/published;
- Search out of sync;
- Needs Review;
- AI-suggested changes awaiting approval.

A future `Since my last visit`/saved checkpoint view is recommended once per-user state is available.

#### 7. AI / agent-first operating model

Every new Admin feature should explicitly ask:

**Can this step be deterministic or safely agent-assisted so a human only handles exceptions?**

Preferred sequence:

`Acquire -> validate -> compare -> classify -> propose -> auto-resolve safe cases -> queue exceptions -> human approve/reject -> apply -> verify -> evidence/audit`

##### Suitable automation/agent responsibilities
- source freshness checks;
- change detection by content hash/version;
- deterministic exact identifier matching;
- completeness scoring;
- stale-data detection;
- duplicate candidate detection;
- evidence presence/lineage validation;
- Search projection drift detection;
- source schema drift detection;
- proposed taxonomy/category mapping;
- proposed structured extraction from unstructured evidence;
- clustering similar review exceptions;
- summarising evidence differences for reviewer attention;
- prioritising Review Queue by risk/impact/confidence/freshness;
- generating bounded re-validation/re-acquisition jobs.

##### Human-only or approval-gated decisions
- ambiguous canonical identity resolution;
- low-confidence source mappings;
- material semantic interpretation not proven by the source;
- publication approval where policy requires human governance;
- acceptance of AI-derived structure when confidence/evidence policy does not permit auto-apply.

AI must not invent Provider/Course/Scholarship identity, eligibility, award or regulatory facts.

#### 8. Review-by-exception UX

Admin pages should surface the reason a record needs attention, not merely mark it `Needs Review`.

Recommended decision chips/signals:
- Missing identifier;
- Missing authoritative evidence;
- Source changed;
- Evidence stale;
- Canonical/source conflict;
- Ambiguous mapping;
- Search out of sync;
- Completeness below threshold;
- New record;
- Material amendment;
- AI suggestion;
- Publication pending.

The right-side detail panel should put the decision-critical differences first and allow deeper evidence sections to remain collapsed until needed.

#### 9. Few-click decision standard

For common review tasks, target:

`filter/sort -> select record -> inspect condensed evidence/difference -> approve/reject/queue`

Normal verification should not require repeated back navigation, reopening filters or losing pagination state.

Where one-click/bulk approval is permitted, the UI must still preserve actor, timestamp, evidence and the decision basis.

#### 10. Common feature consistency

New country, source, Layer 2/3, Scholarship, Search or data-quality chats must reuse this design language unless a documented exception exists.

Common primitives should include:
- country flag/code;
- currency code/value;
- sortable/filterable tables;
- pagination;
- compact collapsible detail panels;
- direct canonical website/source links;
- status pills;
- recency/change chips;
- evidence counts/freshness;
- completeness indicators;
- Review Queue actions;
- AI/automation recommendation/exception indicators.

Do not create a different interaction model for each country merely because the source shape differs.

#### 11. Proposed near-term improvements

Priority additions to the current Pilot Admin:

1. Provider direct website link in row/detail header.
2. Country flag + ISO code rendering.
3. Last Verified and Modified columns.
4. Added/Modified/Verified recency chips.
5. Evidence count/freshness and source-change indicator.
6. Quick views: `New`, `Recently modified`, `Stale`, `Needs review`, `Source changed`, `Search out of sync`.
7. Course decision grid brought to the same server-side pagination/filter/sort standard as Providers.
8. Scholarship decision grid aligned to the same pattern, with Current Cycle / Open Window / Award / Eligibility / Evidence freshness signals.
9. Review Queue priority scoring from risk + impact + confidence + freshness.
10. Agent-produced `What changed?` summary in the detail panel backed by stored source/evidence differences.
11. Automated re-verification jobs for stale/source-changed records, with humans notified only for exceptions.
12. Saved views/checkpoints for repeat Admin workflows.

#### 12. Non-negotiable backend boundary

These UX decisions do not alter accepted canonical design:
- stable source identifiers remain identity authority;
- names/titles do not become identity;
- Layer 2/3 cannot redefine Layer 1 Provider/Course identity;
- evidence remains separate from canonical facts;
- lifecycle remains separate from publication;
- publication remains separate from Search projection;
- private evidence does not become public because the Admin UI links to authorised metadata/actions;
- AI suggestions remain evidence-backed proposals until policy permits deterministic/approved application.

#### 13. Governance rule for future chats

At the start of any CourseFinder Admin/PIM feature work, use this document together with the current architecture/master-plan/running-build documents as the default UX operating contract.

When a new chat introduces a useful UI/UX decision:
1. implement and UAT it where in scope;
2. record the durable decision here or in a superseding version;
3. preserve feature compatibility across Providers, Courses, Scholarships and future entities where applicable;
4. explicitly assess agent/automation opportunities and human-effort reduction;
5. avoid silent regression of previously accepted interaction features.

**Decision:** ACCEPTED as the cross-chat Admin/PIM UX and automation baseline.

### From Design Decisions v1.1

**Status:** AUTHORITATIVE CROSS-CHAT UX / OPERATING CONTRACT  
**Date:** 18 August 2026  
**Supersedes:** `docs/coursefinder-admin-pim-design-decisions-v1.0.md`  
**Architecture baseline:** `docs/coursefinder-database-architecture-v2.10.26.md`  
**Programme baseline:** `docs/coursefinder-master-project-plan-v1.26.md`

v1.1 retains all decisions from v1.0 and adds the following mandatory filter interaction standard.

#### Typed combobox filter standard

Reference-data and bounded-enum filters should be implemented as **searchable comboboxes**, not plain text boxes and not dropdown-only controls.

The user must be able to:
- type part of a code or name;
- see matching valid values in a dropdown;
- select a valid value with mouse or keyboard;
- clear the selected value quickly;
- continue typing without first opening the dropdown;
- open the dropdown without typing to browse available values.

This pattern is mandatory where practical for:
- Country;
- State / Province / Region / Subdivision;
- Provider;
- Campus;
- Study Level;
- Field of Study;
- Delivery Mode;
- Source;
- Lifecycle Status;
- Publication Status;
- Currency;
- review/reason/status taxonomies;
- other reference-data filters introduced later.

#### Dependent reference filters

Where one reference constrains another, the dropdown options should narrow automatically while preserving typed search.

Examples:
- Country -> State / Province / Region;
- Provider -> Campus;
- Provider -> Course where the workflow requires it;
- Country -> regulatory Source where appropriate.

A dependent filter must not silently invent values. Options come from accepted reference/canonical data or a governed read projection.

#### Display rules

Country options should display flag + ISO alpha-2 code + country name where space permits.

Subdivision options should display human-readable name plus canonical code, for example `Victoria · AU-VIC` or `Ontario · CA-ON`.

Currency options should display ISO 4217 code and display name/symbol where available. Currency code remains authoritative.

#### Interaction and accessibility

Comboboxes should support:
- keyboard navigation;
- Enter to select;
- Escape to close;
- visible selected state;
- predictable focus behaviour;
- no loss of pagination/sort/list context when changing filters;
- server-side filtering for high-volume entity filters;
- bounded client-side option lists only for small reference sets.

#### Automation principle

Filter metadata should be sourced dynamically from governed reference/canonical data so new countries, regions, sources and statuses appear without manual UI code changes wherever practical.

The minimum-workforce principle remains: configuration/reference changes should propagate automatically into Admin filter choices rather than requiring repeated frontend edits.

#### Immediate Provider implementation contract

Provider Admin should use:
- Country searchable combobox populated from countries that currently have Provider rows;
- State / Region searchable combobox populated from authoritative subdivision values available for the selected country;
- Lifecycle and Publication searchable/selectable bounded enums;
- server-side Provider filtering after selection;
- typed global search independently of the structured filters.

For countries where authoritative subdivision mapping is absent, the State / Region combobox should show no fabricated choices and the UI should expose the coverage gap rather than infer an unverified subdivision.

### From Design Decisions v1.2

**Status:** AUTHORITATIVE CROSS-CHAT UX / OPERATING CONTRACT  
**Date:** 18 August 2026  
**Supersedes:** `docs/coursefinder-admin-pim-design-decisions-v1.1.md`  
**Architecture baseline:** `docs/coursefinder-database-architecture-v2.10.26.md`  
**Programme baseline:** `docs/coursefinder-master-project-plan-v1.26.md`

v1.2 retains all v1.1 decisions and makes UI primitive reuse and visible UI versioning mandatory.

#### 1. One platform interaction model

Admin/PIM must not implement page-specific interaction patterns where a common primitive can be reused.

Providers, Courses, Campuses, Scholarships, Evidence, Review Queue, Pipeline/Jobs and future catalogue/enrichment workspaces should converge on the same operating model where applicable:

`search / quick view -> searchable combobox filters -> sortable dense columns -> cross-click related entity -> condensed right-side result/detail -> decision/action`

The objective is minimum navigation and minimum repetitive human effort while retaining evidence and governance context.

#### 2. Mandatory searchable combobox primitive

Reference/bounded filters must use the common searchable combobox component rather than HTML `datalist`, plain text input or dropdown-only `select` unless there is a documented exception.

The component must support:
- click chevron to browse all available values;
- type to reduce the dropdown by code or display name;
- keyboard Up/Down navigation;
- Enter to select;
- Escape to close;
- explicit clear action;
- selected-state visibility;
- no server query merely because partial invalid text was typed;
- dependent option lists, such as Country -> State/Region;
- governed dynamic option sources where practical.

Country display: `flag + ISO alpha-2 + name`.

State/Region display: `human name + canonical subdivision code`.

The same primitive should be used for Lifecycle, Publication, Source, Study Level, Currency, Evidence Type, Review Status and similar bounded filters.

#### 3. Uniform decision-grid primitive

High-volume workspaces should share:
- server-side pagination where volume requires it;
- dense rows;
- sortable column headers;
- structured filters aligned directly above the grid;
- consistent status pills;
- selected-row state;
- same-row cross-links for related objects/counts;
- condensed right-side detail/related-result panel;
- close/collapse without losing page, sort, search or filters.

Column order should prioritise human decision-making rather than physical schema order.

#### 4. Cross-clickable relationships

Counts and related objects that help validation should be interactive rather than informational only.

Examples:
- Provider -> Courses, Campuses, Scholarships, Evidence, Outcomes;
- Course -> Provider, Campuses, Fees, Intakes, English, Evidence, Scholarships;
- Scholarship -> Provider, Offering Cycles, Windows, Eligibility, Awards/Coverage, Evidence;
- Evidence -> Source, Job, canonical entity;
- Review item -> affected canonical/source/evidence records.

Cross-click should prefer a filtered related-result workspace using the same combobox/search/order/pagination logic rather than navigating the user away from their current decision context.

#### 5. Visible UI version — mandatory

Every user-visible Admin/PIM release that materially changes interaction, layout, fields, filters or decision behaviour must increment the UI version.

The active UI version must be visibly rendered in the application shell and/or page workspace so screenshots and browser UAT can be correlated to source control.

Version format:

`UI vMAJOR.MINOR.PATCH`

Guidance:
- MAJOR — substantial interaction model/navigation redesign;
- MINOR — new decision-grid/workspace/filter/cross-link capability;
- PATCH — defect/style correction with no material feature change.

A UAT report must state the UI version tested and, where available, the Pilot Git commit.

Initial governed implementation after this decision: **UI v1.3.0**.

#### 6. AI / automation consistency

Uniform UI primitives should also support uniform agent/automation outputs. Agent-derived recommendations, source-change summaries, stale warnings and review priorities should surface through the same status/change-chip/detail conventions rather than bespoke page-specific widgets.

The operating principle remains:

**minimum routine workforce + maximum safe deterministic automation/agent assistance + human review by exception.**

#### 7. Regression rule

A later country/source/chat implementation must not replace an accepted common primitive with a less capable page-specific implementation without an explicit superseding design decision.

When a feature is called out in one CourseFinder chat and is broadly applicable, treat it as a candidate common platform primitive and update this design contract rather than implementing it as an isolated screen behaviour.

### From Design Decisions v1.3

**Status:** AUTHORITATIVE CROSS-CHAT UX / OPERATING CONTRACT  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-admin-pim-design-decisions-v1.2.md`  
**Pilot UI reference:** UI v1.5.0

v1.3 retains all accepted v1.2 decisions and adds the following mandatory platform rules.

#### 1. Neutral first-column rule

The first data column is not a primary-action button and must not inherit application `primary` button styling.

- first-column text may be semibold for scanability;
- row selection is indicated at row level only;
- cells must remain neutral unless their data state itself requires a status colour;
- reusable table-cell classes must be namespace-safe and must not collide with global button/component classes.

#### 2. Fluid decision-grid sizing

High-volume Admin tables must use available viewport width rather than a fixed spreadsheet canvas.

- use fluid semantic column widths (`xs`, `sm`, `md`, `wide`) rather than hard-coded pixel widths per screen;
- identity/name columns get the largest share;
- short codes/status/date/count columns stay compact;
- long secondary text truncates with drill-in/detail available;
- horizontal scroll is a fallback for constrained viewports, not the default desktop layout;
- opening the right-side drawer may trigger responsive stacking rather than crushing the decision grid.

#### 3. Common modern component primitives

The same reusable components are expected across Providers, Courses, Scholarships, Evidence, Review Queue and future Admin workspaces:

- `FilterCombobox` — type + browse dropdown + keyboard select + clear;
- `DecisionWorkspace` — common header/search/filter/grid/pager/drawer shell;
- `DecisionTable` — sortable fluid columns with row selection;
- `CrossLink` — opens related filtered outcome with minimal navigation;
- `Drawer` — condensed verification/related-record workspace;
- `Status` / Country / Currency primitives;
- visible UI version.

Do not implement visually similar but behaviourally different controls per page.

#### 4. Course catalogue discovery contract

Course Admin is a discovery and validation workspace, not merely a title list.

The preferred drill-down sequence is:

`Country -> State/Province/Region -> Provider -> Study Level -> Field of Study -> Delivery -> Lifecycle -> Publication`

Global search remains available independently.

All reference filters are searchable comboboxes and must dynamically narrow where the backend has governed data.

##### Geography

Course geography may be derived only from governed Provider/Campus subdivision relationships. The Admin UI must not silently infer State/Region from city/address text.

If a country's authoritative subdivision mapping is incomplete, display the coverage gap in the UI and leave the filter empty rather than manufacturing options.

#### 5. Cross-click behaviour

Course rows should expose related entities with the same minimal-navigation contract:

- Provider -> Provider verification drawer;
- future Campus count/location -> filtered Campus outcome;
- Fees / Intakes / English / Scholarships / Evidence -> filtered related view where canonical relationships exist;
- external Course URL -> new tab without changing Admin list context.

#### 6. Version correlation

Every material Admin interaction/layout release increments the visible UI version. UI v1.5.0 corresponds to:

- removal of first-column blue style collision;
- fluid semantic column sizing;
- common flex-based filter bar;
- Course geography/provider/level/field/delivery drill-down;
- explicit canonical geography coverage warning when subdivision mapping is absent.

Future browser UAT feedback should name or show the visible UI version whenever possible.

#### 7. Automation objective

Facet choices should come from governed backend read contracts, not duplicated frontend lists, so new Providers, Countries, subdivisions, study levels, fields and delivery modes appear with minimal manual UI maintenance.

The standing operating goal remains minimum routine workforce with maximum safe deterministic automation and bounded agent assistance.

### From Design Decisions v1.4

**Status:** AUTHORITATIVE CROSS-CHAT UX / OPERATING CONTRACT  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-admin-pim-design-decisions-v1.3.md`

#### UI baseline

Current Pilot reference implementation: **UI v1.6.0**.

#### Course decision-workspace standard

Course Admin must support progressive drill-down with the same searchable combobox primitive used elsewhere:

`Country -> State/Region -> Provider -> Study Level -> Field of Study -> Delivery -> data-quality/freshness -> governance status`

The course list is a decision surface, not a passive catalogue.

##### Required quality / readiness filters

Where canonical data exists, support:
- Has Fee / Missing Fee;
- Has Intake / Missing Intake;
- Has English requirement / Missing English requirement;
- Has Scholarship / Missing Scholarship;
- minimum completeness threshold;
- Never Verified;
- recently modified;
- stale verification;
- Lifecycle;
- Publication.

These filters must remain evidence-backed. Zero-result states are valid and must not be filled with inferred or fabricated data.

#### Related-record cross-click standard

Course rows and drawers should expose directly related records with minimal navigation:
- Provider;
- Campuses / Locations;
- Fees;
- Intakes;
- English requirements;
- Scholarships;
- Evidence;
- later outcomes / student-flow observations where relevant.

Related-record clicks should open a filtered/condensed related view in the same workspace rather than requiring ordinary validation to navigate to a separate full page.

#### Data-quality interpretation

A missing structured fact is itself an Admin decision signal. `No fee`, `No intake`, `No English requirement`, or `No course-scoped scholarship` should be filterable so enrichment agents and human reviewers can work by exception.

Do not confuse missing structured enrichment with a claim that the real-world course has no fee/intake/English requirement/scholarship. The UI label describes canonical structured-data availability only.

#### Geography rule

State/Region filtering is authoritative only when Provider/Campus subdivision mapping exists in the canonical model. Do not infer subdivision from city/address text silently.

#### Uniform interaction contract

All comparable Admin screens should continue to share:
- searchable comboboxes;
- fluid semantic table sizing;
- sortable column headers;
- server-side pagination for high-volume data;
- country flag + ISO code;
- currency code where relevant;
- cross-click related records;
- compact right-side drawer;
- preserved page/filter/sort context;
- visible UI version.

#### Automation / agent operating rule

Course data-quality filters should become natural work queues for deterministic jobs and bounded agents. Preferred pattern:

`detect missing/stale -> reacquire/extract -> compare -> auto-apply safe evidence-backed facts -> queue exceptions -> verify -> update completeness/change signals`

Human operators should focus on ambiguity and exceptions, not manually inspect every course.
