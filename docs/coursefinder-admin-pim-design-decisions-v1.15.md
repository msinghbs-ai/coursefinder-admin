# CourseFinder Admin/PIM Design Decisions v1.15

**Status:** CURRENT M2.1 DESIGN DECISIONS  
**Date:** 24 August 2026  
**Supersedes:** v1.14 for M2.1 UI/semantic interpretation; unspecified accepted decisions remain unchanged.  
**Change Controls:** `CF-CHG-20260823-029`, `CF-CHG-20260823-030`, `CF-CHG-20260824-031`, `CF-CHG-20260824-032`

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

## Decision 11 — all governed attributes remain visible

Course Detail must show the governed Course attribute set even when a value is empty. Hiding empty fields prevents operators from understanding data-quality gaps and prevents Layer 4 from acting on unresolved fields.

An empty field is rendered with a neutral `—` placeholder plus its governed field state. Avoid repeating vague prose such as `Not captured` on every empty field.

The default row conveys:

`Field → value / blank → layer-state trail → next action`.

## Decision 12 — layer strike-through means an actual field-specific attempt

Layer badges are an authority/progress trail, not decoration.

- `L2` may be struck only when Layer 2 actually attempted that field/domain and failed to resolve it safely.
- `L3` may be struck only after real Layer 3 execution for that field/domain is persisted and unresolved.
- A Course-level job result is not sufficient to strike a layer for every Course field.

Current deployed schema has no accepted Layer 3 execution/persistence table. Therefore M2.1 may show `L2 struck → Awaiting L3`, but must not invent `L3 struck → L4` for enrichment facts until Layer 3 exists.

## Decision 13 — direct Layer 4 fields are distinct

Some PIM-curated fields may legitimately start at Layer 4 (for example Categories/Collections). They display `L4 input` directly. The UI must not pretend Layers 2 and 3 failed when those layers never owned the field.

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