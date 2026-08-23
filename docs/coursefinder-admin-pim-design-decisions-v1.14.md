# CourseFinder Admin/PIM Design Decisions v1.14

**Status:** CURRENT M2.1 DESIGN DECISIONS  
**Date:** 23 August 2026  
**Supersedes:** v1.13 for M2.1 UI/semantic interpretation; unspecified accepted M1 decisions remain unchanged.  
**Change Controls:** `CF-CHG-20260823-029`, `CF-CHG-20260823-030`

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

A Course detail/comparison experience should bring together decision-relevant context even where the underlying source is Provider-, study-area-, state-, sector- or cohort-grain.

Examples include QILT Provider outcomes, QILT field/study-area outcomes and PRISMS Provider/state/cohort trends.

The UI must label scope explicitly. It must never present Provider-level QILT as a Course-level outcome or a PRISMS state/provider count as a Course enrolment count.

## Decision 4 — two kinds of completeness

Expose separately:

1. **Course factual completeness** — direct facts about the Course and its international-student suitability; and
2. **Decision-context completeness** — availability of contextual Provider/study-area/geography/international-student signals useful for comparison.

A Course is not factually incomplete merely because a contextual source has no Course-grain observation.

## Decision 5 — Layer 2 provider evaluation is outcome-based

Provider trials should compare whether each acquisition provider produces evidence-backed completion of required Course domains, not merely HTTP success.

Initial trials may use approximately 10 representative Courses per Provider/university and adapt based on consistency. The Admin should show or retain acquisition success, extraction success, Evidence type/quality, latency, retries, estimated cost and completion delta.

## Decision 6 — preserve native Evidence

Store the provider-native format whenever supported: HTML, JSON, Markdown, document, image/screenshot or other approved MIME. A derived normalised extraction representation may coexist but must preserve lineage to the original Evidence.

## Decision 7 — Layer 3 is Evidence-aware, not an alternate scraper

Layer 3 consumes Layer 2 Evidence and may request better/additional Evidence through Layer 2. It does not hold acquisition-provider credentials or independently scrape arbitrary URLs.

## Decision 8 — Layer 4 receives the whole decision package

Human Review should receive the entity/Course, unresolved field/domain, provider attempts, Evidence, deterministic candidates, Layer 3 suggestion/confidence, source/freshness and the explicit reason automation stopped.

## Decision 9 — scholarship is related decision data

Scholarships are first-class related data and should be discoverable/linked with Courses and Providers for international-student comparison. Absence of discovery is not evidence of absence.

## Decision 10 — acquisition navigation follows lifecycle

Primary Admin navigation remains grouped as:

- Overview;
- Catalogue;
- Data Acquisition;
- Enrichment & Insights;
- Quality & Review;
- Governance & Platform.

Data Acquisition owns Pipeline Control, Source Registry, Layer 2 Source Config, Acquisition Providers, Jobs and Evidence. Evidence is not hidden under Data Quality.
