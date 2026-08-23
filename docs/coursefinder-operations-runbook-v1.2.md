# CourseFinder Operations Runbook v1.2

**Status:** CURRENT M2.1 OPERATIONS RUNBOOK  
**Date:** 23 August 2026  
**Supersedes:** v1.1 for M2.1 operations; unchanged M1 operational procedures remain applicable.  
**Change Controls:** `CF-CHG-20260823-029`, `CF-CHG-20260823-030`

## 1. Operating boundary

CourseFinder operates a four-layer data-enrichment model only:

`L1 authority → L2 acquisition/extraction → L3 Evidence-aware AI → L4 human resolution`

Search projection/publication are downstream product states. University admissions, applications, offer letters and visa processing are outside platform operations.

## 2. Country completeness trial procedure

For a selected country:

1. confirm the Country Course Completeness Profile and accepted regulatory authority semantics;
2. select a Provider/university cohort;
3. start with an approximately 10-Course representative batch unless the source requires a different bounded sample;
4. record pre-run Course factual completeness and decision-context completeness;
5. identify only missing/stale domains requiring enrichment;
6. run Layer 2 acquisition through configured provider routes;
7. retain native provider Evidence and normalised extraction Evidence;
8. run deterministic domain extraction;
9. compare post-run completeness to baseline;
10. record cost/latency/retry/provider-attempt metrics;
11. expand or test alternate provider according to observed consistency.

Do not use a 10-Course batch as a permanent production limit.

## 3. Provider comparison procedure

Compare Direct HTTP, Scrape.do, ScraperAPI, Firecrawl, ZenRows and future governed providers using:

- successful bounded acquisition;
- access/gatekeeping success;
- JavaScript/render requirements;
- Evidence MIME/quality;
- deterministic extraction success;
- correctness against source;
- duration/retry count;
- provider cost units where available;
- cost per evidence-backed completed Course/domain;
- unresolved rate requiring Layer 3/4.

A provider that is cheap per request but yields poor evidence-backed completion may be operationally more expensive.

Do not silently reorder production routes from trial data. Produce a recommendation and record the accepted routing change under Change Control.

## 4. Evidence handling

Preserve provider-native Evidence exactly when practical. Supported evidence may include HTML, JSON, Markdown, documents, screenshots/images and approved structured files.

Normalised extraction Evidence must retain lineage to the native Evidence, Job, provider attempt and Source Profile version.

Never delete failed-attempt Evidence merely because a later provider succeeds; failed attempts are useful gatekeeping/provider-quality evidence.

## 5. Extraction failure procedure

If acquisition succeeds but deterministic extraction cannot establish the required fact:

1. mark/record `extraction_failed` against the provider attempt;
2. preserve the Evidence and blocker;
3. try the next configured provider when fallback policy permits;
4. re-run deterministic extraction on the new Evidence;
5. if still unresolved, provide the Evidence package to Layer 3;
6. if Layer 3 cannot safely resolve or identifies material ambiguity/conflict, route to Layer 4.

No step may manufacture a value to improve completeness.

## 6. Scholarship acquisition

Scholarship discovery/extraction uses the same Layer 2 provider/evidence substrate. Operate a generic Scholarship worker rather than provider-specific Scholarship scrapers.

Record source URL, eligibility scope, value/basis/currency, dates, Provider/Course/study-level/nationality context, application/automatic-consideration semantics, Evidence and verification time.

If no scholarship is discovered, retain `not_yet_enriched/not_discovered` unless an authoritative source establishes `none/not_applicable`.

## 7. QILT / PRISMS contextual projection checks

Before exposing contextual data with Courses:

- verify QILT/PRISMS source grain and reporting period;
- confirm Course-facing projection labels Provider/study-area/state/sector/cohort scope correctly;
- do not duplicate contextual metrics into Course-grain canonical fields;
- verify freshness and source links are available;
- confirm the context helps compare Course + Provider + Campus/state combinations without implying false Course-level precision.

## 8. Layer 3 additional-Evidence request

If Layer 3 later requests additional Evidence, the request must specify the missing capability/reason, for example `javascript_render_required`, `screenshot_required` or `dynamic_content_missing`.

Layer 2 performs the acquisition through configured provider routes. Layer 3 never receives Vault credentials and never becomes an independent scraper.

## 9. Layer 4 terminal handling

Layer 4 receives only unresolved/conflicting/consequential cases with the complete evidence package. Human resolution is terminal for enrichment authority. There is no Layer 5 queue.

## 10. Incident / blocker handling

Treat the following separately:

- source unavailable;
- provider credential missing;
- provider blocked/403/429/5xx;
- malformed or low-value Evidence;
- deterministic extraction defect;
- Layer 3 ambiguity;
- canonical mapping conflict;
- stale data;
- browser/UAT harness failure.

Do not collapse these into a generic `scrape failed` state because provider selection and operational cost decisions depend on the failure class.
