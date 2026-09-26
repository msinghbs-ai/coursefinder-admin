# CourseFinder Platform Design Reference v1.1

**Status:** CURRENT — the single reference for CourseFinder design, guardrails and decisions  
**Date:** 26 September 2026  
**Change control:** CF-CHG-20260915-247  
**Supersedes:** Design Reference v1.0 (the single decision authority since 26 September 2026; Design Decisions v1.0–v1.36 and the Attribute & Admission Register v1.0 are history)  
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
| P2 | **Evidence first** | Everything fetched is stored once with its evidence. Later steps re-read stored evidence before fetching again. Every AI result and every human decision points to the evidence it used. | 81, 103, 146 |
| P3 | **Deterministic before AI** | Rules and exact extraction run first. AI only interprets stored evidence when rules cannot, and never becomes canonical on its own. | 28, 98, 106, 124 |
| P4 | **People decide the unresolved** | Layer 4 is final. Every decision has a reason, is audited and can be reversed. | 15, Contract §11 |
| P5 | **Qualify before automating; activate separately** | A model, rule or provider route runs unattended only after it passes a defined check, and switching it on is its own deliberate step. | 30, 91, 125, 141 |
| P6 | **Never manufacture missing values** | Absent data stays absent and is labelled with the right completeness state. | Contract §5, §12 |
| P7 | **Protect consumers** | A change that could alter consumer output is proven not to, or is released as a deliberate contract change. | 83, 136, 137, 138 |
| P8 | **Spend is guarded** | Paid acquisition runs within budgets, reserves and concurrency limits that settings cannot bypass. | 78, 99, 141 |
| P9 | **Country-neutral core, country-specific edges** | The canonical model is the same for every country; each country adds its own sources, identifiers, mappings and completeness profile. | Contract §5, 143, 149 |
| P10 | **Simple screens** | One title per screen, one place for each job, plain language, no duplicated controls. | 116, 133, §7 |
| P11 | **Efficient by design** | Admit once, then re-check only on change or on the attribute's cycle. Jobs run no more often than their data changes, heavy jobs never overlap, rows are written only when something changed, and every new heavy job is sized before switch-on and watched after. Resource use is recorded and forecast. | 151, 152, 153 |

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

**Current state (26 September 2026):** Layer 1 is healthy for Australia. Layer 2 covers about 2% of Australian courses for provider-sourced attributes because most providers are not yet qualified; per-provider onboarding and automatic, evidence-ranked discovery now address that (Decisions 141, 146, 147). Layer 3 AI is paused because no model has qualified; approved provider rules admit fees without AI (Decisions 98, 106, 125). Layer 4 has 127 items waiting.

---

## 3. What is captured at which layer, and how it is admitted

One row per course attribute. "Correction" is the Layer 4 path a person uses. Coverage is measured from the consumer search document on 26 September 2026.

| # | Attribute | Authority | Source and capture | Admission rule | Correction (L4) | AU | NZ | Status / next action |
|---|---|---|---|---|---|---|---|---|
| 1 | Identity (code, title, provider) | L1 | Country register | Identifier-first reconciliation | Title and code overrides | 100% | 100% | AU should also record CRICOS in the identifier table (R3) |
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
| R3 | **AU identity is not in the identifier table** | Canada uses identifier types properly; AU keeps CRICOS only in `course_code` | Register CRICOS provider and course identifier types and backfill them; keep `course_code` as the display code |
| R4 | Two AU-shaped consumer fields (`has_state`, `regulatory_tuition_state`) | Wrong vocabulary for other countries | Add neutral names (subdivision, regulatory basis) alongside; retire the old names in a later contract version |
| R5 | Ranking editions: THE 2019–2024 not applied; THE "2015" suspect; QS duplicates | Contradicts Decision 128 | Proof, then apply and merge |
| R6 | Statistics source model | Year-specific sources, one edition each | Build Decision 134 |
| R7 | Course description | No working path | Build Decision 140 |
| R8 | Scholarship publication | None published | Build Decision 139 batches |
| R9 | Intakes and English corrections | No Layer 4 path | Build Decision 142 |
| R10 | ~~Automation acts under a real admin's identity~~ | Done 26 Sep 2026 | System identity *CourseFinder Automation* (Pipeline Operator, cannot sign in) — Decision 150 |
| R11 | Layer 3 AI paused | No model qualified | Keep deterministic provider rules; re-run qualification when a candidate model appears |
| R12 | Completeness states not reported | Coverage shows present/absent only | Report the nine states in coverage views |
| R13 | Publication gate | Pilot returns unpublished records | Production step under Decision 138 |
| R14 | Per-row verification drifted | Course `last_verified_at` last refreshed mid-August; September register runs verified at run level only | The next full register apply re-verifies all rows once (Decision 152, option B), then every 30 days |
| R15 | Resource observability | No hourly record of database size vs memory, job overlap, external usage or cost | Build the Resources view and forecasts (Decision 153, Package 8.2) |

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
| Evidence | Evidence is stored once, bucket-relative, environment-portable; native evidence kept alongside normalised forms | 81, 103, 146 |
| AI | No model runs unqualified; qualification needs two consecutive clean passes and all safety controls; activation is separate; routing is pinned to qualified models | 30, 91, 94, 98, 125 |
| Admission | Acquisition success never authorises canonical change; provider rules are audited and time-limited; one current tuition per course | 97, 105, 124, 132 |
| Human decisions | Reason required; reversible; batch actions previewed with typed confirmation; person and rule decisions never confused | 15, 124 |
| Spend | Monthly budget, safety reserve, vendor concurrency, per-day and in-flight automation limits, no silent paid fallback | 78, 99, 141, 147 |
| Security | Security-definer functions pin their search path; no public execute on them; integration functions service-role only; secrets write-only | 77, 82, 145 |
| Consumers | API guard on every consumer-affecting change; production publication gate; consumer cutover separate from environment readiness | 83, 136, 138 |
| Releases | Visible version on every release; test-only commits may go straight to main; everything else by PR | 126 and earlier release decisions |
| Documentation | This reference is the decision authority; decisions are numbered, never deleted | 148 |
| Workload | Jobs run no more often than their data changes; heavy jobs never overlap (own minute slot, at least 7 minutes apart); rows written only on real change, verification markers at most once per 30-day cycle; new heavy jobs sized (rows and IO per run) before switch-on and watched after; stale runs closed after 3 days without progress | 151, 152 |
| Platform | Pilot runs on Micro compute; database size is kept below memory where possible; resource use recorded and forecast; production starts at Large | 153 |
| Automation identity | Automated actions run as *CourseFinder Automation* (Pipeline Operator), never as a person; no fallback to a person | 150 |

---

## 7. Screen and navigation rules

1. **One title per screen**, the page title (133).
2. **One place for each job:** *view and compare* (Statistics & Rankings, Catalogue), *run and upload* (Layer 1–4 operations), *configure* (Administration). Each card links to the other two; every link is checked.
3. **One card per dataset** with a year selector, not one per year or source (134).
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
| Decision 149 — country-neutral identity and consumer fields | Current (approved 26 Sep 2026); build in Package 9 |
| Refinements R1–R9, R11–R15 | To schedule (R10 done) |
| Resources view and forecasts (153) | Package 8.2 |
| Layer 3 model qualification | Paused (no qualified model) |
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
