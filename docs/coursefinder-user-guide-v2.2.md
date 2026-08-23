# CourseFinder User Guide v2.2

**Status:** CURRENT M2.1 USER GUIDE  
**Date:** 23 August 2026  
**Supersedes:** v2.1 for M2.1 workflows; unchanged catalogue/PIM guidance from v2.1 remains applicable.  
**Change Controls:** `CF-CHG-20260823-029`, `CF-CHG-20260823-030`

## 1. What CourseFinder is

CourseFinder is an international-student Course and related-data aggregation, discovery and comparison platform.

It helps counsellors and students evaluate combinations of Course, university/Provider, Campus/state, tuition, intake, entry requirements, Scholarships and contextual outcome/student-flow information.

CourseFinder does not perform university admissions, application processing, offer-letter processing or visa processing.

## 2. Main navigation

### Data Acquisition

Use this group to understand how data entered the platform:

- **Pipeline Control** — overall Layer 1–4 operational journey;
- **Source Registry** — governed sources and their authority/freshness;
- **Layer 2 Source Config** — how approved sources are discovered and interpreted;
- **Acquisition Providers** — Direct HTTP/scraper/browser/API providers, routing and credentials;
- **Jobs** — execution history;
- **Evidence** — acquired JSON/HTML/Markdown/documents/screenshots and provenance.

### Enrichment & Insights

- **Outcomes (QILT)** — Provider/study-area outcome context;
- **Student Flow (PRISMS)** — Provider/state/sector/cohort international-student trends.

### Quality & Review

- **Completeness** — factual and decision-context readiness;
- **Review Queue** — Layer 4 human-resolution workload.

## 3. The four-layer model

- **Layer 1:** authoritative/regulatory identity and facts.
- **Layer 2:** deterministic acquisition, Evidence and extraction.
- **Layer 3:** AI-assisted interpretation of Layer 2 Evidence where deterministic extraction is insufficient.
- **Layer 4:** final human resolution for unresolved or conflicting cases.

There is no Layer 5. Search visibility/publication happens after the governed data work and is not another enrichment layer.

## 4. Reading a Course

A Course can display two types of information:

### Direct Course facts
Examples: tuition, duration, Course URL, intake, Campus/delivery, English requirement, academic entry requirement and Course-linked Scholarships.

### Decision context
Examples: QILT Provider outcomes, QILT study-area outcomes, PRISMS Provider/state trends and Provider/study-level Scholarship context.

Decision context may not be measured at Course grain. Always read the displayed scope label. A Provider-level QILT metric is contextual information about the Provider, not a measured outcome for that exact Course.

## 5. Completeness

CourseFinder distinguishes:

- **Course factual completeness** — are the expected direct Course facts available for the selected country?
- **Decision-context completeness** — is relevant Provider/study-area/state/international-student context available?

Missing does not always mean bad data. The platform distinguishes source-null, not applicable, zero, suppressed, not yet enriched, stale, ambiguous and rejected states.

## 6. Acquisition provider trials

Authorised operators may test multiple acquisition providers against the same governed Source Profile.

The purpose is to determine which provider gives the best evidence-backed completion at acceptable cost and latency, not merely which provider returns HTTP 200.

Typical comparison signals include acquisition success, extraction success, Evidence type/quality, latency, retries, cost and how many previously incomplete Course facts became evidence-backed.

## 7. Evidence

Evidence may include provider-native:

- HTML;
- JSON;
- Markdown;
- PDF/XLSX/other approved documents;
- screenshots/images.

A normalised extraction representation may also exist. Native Evidence remains preserved for audit/review.

## 8. Scholarships

Scholarships are related decision data for international students. A scholarship may apply at Provider, Course, study-level, nationality or other eligibility scope.

A scraper failing to discover a scholarship does not mean that no scholarship exists. Treat `not yet enriched/not discovered` separately from an authoritative `none/not applicable` state.

## 9. Layer 4 Review

Only unresolved/ambiguous/conflicting cases should reach Layer 4. Reviewers should be able to see the full evidence package and why automation stopped before making a governed decision.
