# CourseFinder M2.1 Layer 1–4 Architecture Contract v1.0

**Status:** CURRENT — M2.1 architecture contract  
**Date:** 23 August 2026  
**Primary Change Control:** `CF-CHG-20260823-029`  
**Related Change Control:** `CF-CHG-20260823-030`

## 1. Product boundary

CourseFinder is an international-student Course and related-data aggregation, discovery and comparison platform.

Its governed data domain includes Providers, Courses, Campuses, regulatory facts, tuition, intakes, English and academic entry requirements, Scholarships, course descriptions, taxonomy, delivery/location, outcomes/context, Evidence, completeness and freshness.

University application processing, admissions decisions, offer-letter processing and visa processing are outside the CourseFinder data-platform scope. The term **Search Admission** must not be used for the CourseFinder search projection because it is ambiguous with university admissions. Use **Search Eligibility**, **Search Projection**, **Search Visibility**, **Publication Eligibility** or **Publication** as appropriate.

## 2. Final enrichment authority model

There are exactly four data-enrichment authority layers:

1. **Layer 1 — Authoritative / Regulatory**  
   Establishes stable identity and authoritative regulatory facts. Examples include CRICOS and NZQA/other accepted country regulatory sources.
2. **Layer 2 — Deterministic Acquisition & Extraction**  
   Acquires structured and unstructured first-party/approved sources using reusable acquisition providers, records immutable Evidence and performs deterministic extraction/normalisation.
3. **Layer 3 — AI-assisted Evidence Interpretation**  
   Consumes Layer 2 Evidence and observations when deterministic extraction cannot safely establish a fact. Layer 3 does not independently bypass Layer 2 acquisition governance.
4. **Layer 4 — Human Resolution**  
   Terminal human decision layer for unresolved ambiguity, conflicts and consequential interpretation. Layer 4 may approve, correct, reject, mark source-null/not-applicable, or leave unresolved.

**There is no Layer 5.**

Search projection/publication are downstream product states, not enrichment authority layers.

Canonical flow:

`Layer 1 → Layer 2 Acquisition/Evidence/Deterministic Extraction → Layer 3 Evidence-aware AI → Layer 4 Human Resolution → Completeness/Readiness → Search Projection/Visibility → Publication → Course Discovery/Selection`

## 3. Layer 2 operating model

Layer 2 separates:

- **Source Profile** — source authority, country/domain, discovery/URL scope, parser/mapping semantics, stable identifiers, freshness, schedule and Evidence policy;
- **Acquisition Provider** — reusable technical fetch service such as Direct HTTP, Scrape.do, ScraperAPI, Firecrawl, ZenRows or another governed API/browser provider;
- **Source → Provider Route** — ordered providers, required capabilities, request overrides, Evidence policy and fallback conditions;
- **Acquisition Job** — bounded execution against a versioned Source Profile;
- **Provider Attempt** — exact provider execution for the Job;
- **Native Provider Evidence** — exact JSON/HTML/Markdown/document/image/screenshot representation returned by the provider;
- **Normalised Extraction Evidence** — common extraction input produced without destroying the native Evidence;
- **Deterministic Extractor** — domain worker for Course facts, fees, intakes, English/academic requirements, Scholarships or other approved domains.

Credentials are write-only from the Admin UI, stored server-side in Supabase Vault and never returned to the browser.

Acquisition targets must remain within the governed Source Profile URL/domain boundary; Layer 2 must never become an arbitrary URL proxy.

## 4. Provider fallback semantics

Fallback may occur for approved transport or content reasons including blocked access, timeout, HTTP 403, HTTP 429, retryable 5xx responses, missing JavaScript-rendered content or `extraction_failed`.

A successful HTTP response is not equivalent to successful enrichment. The platform measures whether the required decision-grade fact is present, extractable and evidence-backed.

When extraction fails:

`Provider A Evidence → deterministic extraction failed → preserve Evidence → next approved provider → new Evidence → deterministic extraction → Layer 3 if still unresolved → Layer 4 if automation remains unresolved`

No layer manufactures a value merely to increase completeness.

## 5. Country-based Course completeness

Completeness is evaluated by country because authority, identifiers and required international-student facts differ by jurisdiction.

A **Country Course Completeness Profile** defines the decision-relevant domains for that country. For Australia this includes, where applicable:

- Provider/Course identity and CRICOS identity;
- regulatory duration/fees;
- current Provider tuition and currency/year/basis;
- official Course URL;
- intake availability;
- Campus/delivery/geography;
- English requirement and test detail;
- academic entry requirement;
- Course description/taxonomy;
- relevant Scholarships;
- Evidence and verification/freshness;
- decision-context availability.

NZ and later countries use their own authority semantics rather than inheriting CRICOS terminology.

Completeness must distinguish at least `present`, `source_null`, `not_applicable`, `zero`, `suppressed`, `not_yet_enriched`, `stale`, `ambiguous` and `rejected`.

## 6. M2.1 provider trial method

Initial provider evaluation is Course-outcome based rather than request based.

For each selected country and Provider/university:

1. select an initial representative batch of approximately 10 Courses;
2. include static, JavaScript-heavy and structurally difficult examples where available;
3. evaluate required missing completeness domains;
4. acquire only what is needed rather than re-scraping already complete facts;
5. retain provider-native Evidence;
6. run deterministic extraction;
7. measure completion/accuracy/Evidence/cost outcomes;
8. expand, retry or change provider based on measured results.

Suggested adaptive rule:

- ≥90% consistent evidence-backed extraction: expand cautiously;
- 70–89%: another validation batch;
- <70%: diagnose acquisition/extraction and test alternate provider before scale-out.

These are operating defaults, not hard canonical thresholds; final thresholds must be documented with UAT evidence.

## 7. Provider benchmarking

Compare providers using business outcomes, including:

- acquisition success;
- anti-bot/gatekeeping success;
- JavaScript/render success;
- native Evidence quality;
- deterministic extraction success;
- Layer 3 recovery rate when later enabled;
- correctness against source;
- latency;
- requests per Course;
- vendor cost per Course;
- vendor cost per evidence-backed completed Course;
- cost per newly completed fact/domain;
- failure consistency;
- screenshot usefulness where supported;
- projected human-review rate.

Provider order may later be recommended from measured performance but must not silently self-modify without an accepted governance decision.

## 8. Scholarship model

Scholarships are first-class related data for international Course selection.

Layer 2 should support reusable Scholarship discovery/acquisition/extraction through the same provider platform. Candidate fields include name, official URL, Provider, award value/type/currency/percentage, eligible Courses/study levels/nationalities, international-student eligibility, academic/English requirements, application requirement, automatic consideration, opening/closing dates, intake applicability, duration/renewability and terms URL.

`not found by scraper` must never be translated to `no scholarship`.

## 9. QILT / PRISMS contextual Course projection

QILT and PRISMS may be decision-relevant even when the source grain is Provider, study area/field, state, sector or reporting cohort rather than Course.

CourseFinder may project that context alongside a Course for counsellor/student comparison, but it must preserve the real scope and reporting period.

Examples:

- `qilt_provider_context` — Provider-level outcome;
- `qilt_study_area_context` — mapped field/study-area outcome;
- `prisms_provider_context` — Provider-level international student trend;
- `prisms_state_context` — state/sector/cohort context;
- `scholarship_context` — relevant Provider/Course/study-level opportunity.

A Provider-level QILT result must never be relabelled as a Course-level outcome. A PRISMS state/provider count must never be represented as the Course's own enrolment count.

This yields two separate readiness concepts:

- **Course factual completeness** — direct facts about the Course;
- **decision-context completeness** — availability of relevant Provider/study-area/geography/international-student context.

## 10. Layer 3 contract

Layer 3 receives only governed inputs: Course identity, missing completeness domains, Layer 2 Evidence, source authority, provider-attempt metadata and prior observations.

Layer 3 produces structured candidate facts with Evidence references, confidence, ambiguity and status. If Evidence is inadequate, Layer 3 requests additional Evidence capabilities from Layer 2; it does not start an ungoverned scraper itself.

## 11. Layer 4 terminal contract

Only genuinely unresolved, conflicting or consequential records reach Layer 4. Reviewers must receive the full decision package: Course/entity, missing/conflicting field, provider attempts, Evidence, deterministic candidates, Layer 3 candidate/confidence, source URL/freshness and explicit reason automation stopped.

Layer 4 is terminal for enrichment authority. Downstream Search/Publication consumes governed results; it is not another resolution layer.

## 12. Non-negotiable boundaries

- Layer 2 does not redefine Layer 1 identity.
- Acquisition success does not authorise canonical mutation.
- Layer 3 does not bypass Layer 2 Evidence governance.
- Layer 4 is the final enrichment authority layer.
- Search/publication are downstream product states, not admissions and not additional enrichment layers.
- QILT/PRISMS context preserves source grain.
- Missing source values are never manufactured.
- Native Evidence is preserved even when a normalised extraction representation exists.
