# CourseFinder Admin/PIM Design Decisions v1.18

**Status:** CURRENT M2 DESIGN DECISIONS  
**Date:** 28 August 2026  
**Supersedes:** v1.17; unspecified accepted decisions remain unchanged.  
**Change Controls:** prior accepted controls plus `CF-CHG-20260827-044`

## Decision 1 — CourseFinder is not an admissions workflow

CourseFinder serves international students/counsellors by aggregating and comparing Courses and related decision data. University applications, admissions decisions, offer letters and visa processing are outside the current platform.

Do not use **Search Admission** in new UI/docs. Use Search Eligibility/Projection/Visibility or Publication Eligibility as appropriate.

## Decision 2 — four enrichment layers only

The UI and operating model recognise exactly four enrichment authority layers:

- Layer 1 authoritative/regulatory;
- Layer 2 deterministic acquisition/extraction;
- Layer 3 AI-assisted Evidence interpretation;
- Layer 4 human resolution.

Layer 4 is terminal for enrichment authority. Search and Publication are downstream product states, not further layers.

## Decision 3 — Course decision context may include non-Course-grain signals

A Course detail/comparison experience may bring together Provider-, study-area-, state-, sector- or cohort-grain context, including QILT and PRISMS. Scope must be explicit; contextual facts must never be relabelled as direct Course facts.

## Decision 4 — two kinds of completeness

Expose separately:

1. **Course factual completeness** — direct Course/international-student facts; and
2. **Decision-context completeness** — availability of contextual Provider/study-area/geography signals.

## Decision 5 — Layer 2 provider evaluation is outcome-based

Provider trials compare evidence-backed completion, correctness, Evidence quality, latency, retries/quota/cost and Layer 3 fall-out—not merely HTTP success.

## Decision 6 — preserve native Evidence

Store the provider-native format whenever supported. Derived normalised representations may coexist but must preserve lineage to native Evidence.

## Decision 7 — Layer 3 is Evidence-aware, not an alternate scraper

Layer 3 consumes Layer 2 Evidence and may request better/additional Evidence through Layer 2. It does not hold acquisition-provider credentials or independently scrape arbitrary URLs.

## Decision 8 — Layer 4 receives the whole decision package

Human Review receives the entity/field, unresolved reason, provider attempts, Evidence, deterministic candidates, Layer 3 suggestion/confidence when available, source/freshness and the explicit reason automation stopped.

## Decision 9 — Scholarship is related decision data

Scholarships are first-class related data. Absence of discovery is not evidence of absence.

## Decision 10 — operational navigation stays simple

Primary Admin navigation remains grouped around Overview, Catalogue, Data Enrichment/Operations, Insights, Quality & Review and Governance/Platform. Technical source/provider/job controls should be progressive drill-down rather than routine top-level clutter.

## Decision 11 — required gaps remain visible; optional empty sections are suppressed

Course Detail must keep **required and decision-critical Course attributes visible even when empty**, because operators need to understand completeness gaps and the next enrichment layer.

Optional/non-required PIM collections do not need an empty blade in the routine Course drawer. Academic Options, Categories, Collections and similar optional groups may be suppressed when empty and appear automatically when populated or when a dedicated configuration/review workflow is opened.

An unresolved required field uses a neutral `—` placeholder plus its governed field-state trail. Avoid repeating vague prose such as `Not captured`.

This supersedes the broader v1.15 wording that every governed attribute must always occupy visible Course-detail space. Requiredness and decision relevance now determine routine visibility.

## Decision 12 — layer strike-through means an actual field-specific attempt

Layer badges are an authority/progress trail, not decoration.

- `L2` may be struck only when Layer 2 actually attempted that field/domain and failed to resolve it safely.
- `L3` may be struck only after real Layer 3 execution for that field/domain is persisted and unresolved.
- A Course-level job result is not sufficient to strike a layer for every Course field.

Current deployed schema has no accepted Layer 3 execution/persistence table. Therefore M2.1 may show `L2 struck → Awaiting L3`, but must not invent `L3 struck → L4` for enrichment facts until Layer 3 exists.

## Decision 13 — direct Layer 4 fields are distinct

Some PIM-curated fields may legitimately start at Layer 4. In the routine Course drawer an empty optional direct-L4 group may remain suppressed to reduce clutter; its L4 input surface belongs in the dedicated edit/review mode. The UI must not pretend Layers 2 and 3 failed when those layers never owned the field.

## Decision 14 — Layer 1 gaps are source corrections, not Layer 4 overrides

Provider identity, CRICOS Course identity, regulatory observations and other Layer 1-authority facts remain governed by Layer 1/source correction. A human operator may review and initiate correction, but the normal Layer 4 enrichment editor must not silently overwrite Layer 1 truth.

## Decision 15 — Layer 4 is terminal but typed

Layer 4 controls appear only after the field is genuinely ready for Layer 4, or when revising a prior Layer 4 resolution.

Safe scalar Course fields may use a bounded inline editor with mandatory reason/audit. Compound semantic facts require typed editors:

- tuition: amount, currency, year, audience, basis/scope;
- English: test, overall/component scores, notes/scope;
- intakes: label/year/date/deadline/campus/status.

Do not replace these with generic free-text editing.

Layer 4 resolution does not imply Publication approval and must not auto-write Search visibility.

## Decision 16 — completeness does not publish

100% completeness may support Publication Eligibility filtering, but never auto-publishes. Publication remains an explicit governed state transition with eligibility, preview, approval/audit and consumer verification.

## Decision 17 — Course Detail uses a consistent decision-card hierarchy

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

## Decision 18 — per-user, per-screen working state persists until explicitly cleared

Catalogue working context should survive normal navigation, reload and logout/login on the same browser so administrators do not repeatedly rebuild filters while investigating data.

The current Pilot stores interface preferences in browser `localStorage`, namespaced by signed-in user and screen. It may persist:

- catalogue search text;
- selected filters;
- advanced-filter visibility;
- Course Detail decision-card order.

The screen **Clear** action explicitly removes the saved search/filter state. Course section order remains until the user rearranges it or resets the browser preference.

This storage contains interface preferences only—no passwords, API keys, service-role tokens, raw Evidence content or canonical facts. Browser-local persistence is intentionally chosen to avoid adding RPC/database latency. Cross-device preference synchronisation may be introduced later through a dedicated user-preferences contract if operationally justified.


## Decision 19 — large filter option domains are paged server-side

Operator-facing filter/dropdown/combobox option domains must not be eagerly loaded in full when they can exceed 10 values.

The accepted pattern is:
- maximum normal option page size: 10;
- server-side search/paging for dynamic or growing domains;
- response carries total and has-more/cursor state rather than the complete option universe;
- a selected value remains labelled when it is outside the current option page;
- Course result pagination and filter-option pagination are independent concerns.

Small fixed enums of 10 values or fewer may remain local/static.

The Course catalogue is the first mandatory implementation because Provider, State/Region, Study level, Field and Delivery are large/growing dimensions.

## Decision 20 — dependent filters remain scope-aware

Parent/child filter relationships must be resolved from current governed scope.

Examples:
- Country → State/Region;
- Country + State/Region → Provider;
- Layer 2 Country → State → included universities;
- Country → University.

Changing a parent scope clears any child value that may no longer be valid.

Layer 2 State scope represents all governed universities and eligible Courses in the selected subdivision. The UI must visibly enumerate those included universities, paged 10 at a time, while the State remains the single execution scope.

## Decision 21 — touch/tablet filter opening must not summon the keyboard

Shared filter popovers must not use unconditional input auto-focus.

On coarse-pointer/touch-first devices:
- opening a filter keeps focus on the trigger/control;
- the search field receives focus only after the operator explicitly taps it;
- paging/options remain usable without moving the cursor unexpectedly or opening the on-screen keyboard.

Fine-pointer desktop environments may focus the search input automatically where useful. Keyboard accessibility remains mandatory.

## Decision 22 — filter performance is a platform-wide reusable UI contract

The paged-filter component/endpoint pattern is shared platform infrastructure, not a Course-only special case.

Any M2 workstream that introduces or materially changes a large Provider, University, Campus, source, job, Evidence-type or reference-data selector must use the same bounded option-loading contract before its next acceptance gate.

Reference: Milestone 2 Execution Addendum A10.


## Decision 23 — contextual insights belong in the entity decision journey

Standalone QILT/PRISMS/country-equivalent and Scholarship workspaces remain valid for ingestion, QA, source analysis and bulk filtering, but they are not sufficient as the only operator presentation.

Provider and Course detail must surface relevant decision context through generic semantic groups:
- Student outcomes / benchmarks;
- International student flow;
- Scholarships / funding.

The UI must preserve the actual source grain. Provider, regional, state, sector or study-area observations shown from Course detail remain explicitly contextual and must never be relabelled as Course facts. Missing direct relationships are represented as not mapped/not available, not inferred.

Scholarships are related by governed scope. Direct Course scope is strongest; compatible study-level/field/campus/Provider scope may support contextual eligibility. Explicit exclusions override broad inclusion. Contextual relevance is not proof of student eligibility.

Country-specific labels such as QILT and PRISMS are source labels, not country-specific blade architecture. Equivalent accepted source families for NZ/CA/GB/US/IE/DE use the same generic decision groups.

Reference: Milestone 2 Execution Addendum A12.
