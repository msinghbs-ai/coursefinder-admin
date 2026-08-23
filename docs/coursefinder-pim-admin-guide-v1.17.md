# CourseFinder PIM Admin Guide v1.17

**Status:** CURRENT M2.1 ADMIN GUIDE  
**Date:** 23 August 2026  
**Supersedes:** v1.16 for M2.1 workflows; unchanged M1 field semantics from v1.16 remain applicable.  
**Change Controls:** `CF-CHG-20260823-029`, `CF-CHG-20260823-030`

## 1. M2.1 authority model

CourseFinder has exactly four enrichment authority layers:

1. Layer 1 authoritative/regulatory;
2. Layer 2 deterministic acquisition/extraction;
3. Layer 3 AI-assisted Evidence interpretation;
4. Layer 4 human resolution.

Layer 4 is terminal for enrichment authority. Search projection/publication are downstream states and are not Layer 5.

## 2. Data Acquisition administration

### Source Registry
Validate source authority, country/domain, source type, freshness and operational state.

### Layer 2 Source Config
Validate discovery URL/domain, inclusion/exclusion rules, parser/mapping semantics, stable identifier strategy, MIME/payload policy, Evidence requirements, freshness SLA, schedule and Change Control/UAT references.

Do not place scraper API keys or tokens in Source Profile JSON.

### Acquisition Providers
Validate provider adapter type, base endpoint, auth mechanism, capability declaration, timeout/concurrency/rate settings, provider route order and credential status.

Credentials are write-only from the browser and stored in Supabase Vault. The Admin should see only whether a credential is configured.

### Jobs / Provider Attempts
Use execution records to distinguish configuration from actual runtime results. Every provider attempt should retain exact source-profile version and provider identity.

### Evidence
Validate native Evidence before accepting a mapping. Provider-native HTML/JSON/Markdown/document/image/screenshot should remain retained even where a normalised extraction representation exists.

## 3. Country Course completeness

Completeness is jurisdiction-specific. Do not expect a New Zealand Course to satisfy Australian CRICOS-specific fields.

For each country, validate the expected international-student domains such as authoritative identity, tuition, Course URL, intake, Campus/delivery, English/academic requirements, Scholarships, Evidence/freshness and relevant decision context.

Keep semantic state distinctions explicit: present, source-null, not applicable, zero, suppressed, not yet enriched, stale, ambiguous and rejected.

## 4. Provider evaluation

For bounded M2.1 trials, begin with a representative Course sample per university/Provider, normally around 10 Courses for initial comparison. Do not treat 10 as a permanent ingestion limit.

Evaluate providers by evidence-backed Course/domain completion, not HTTP success alone.

Capture/compare:

- acquisition success;
- gatekeeping/JS-render success;
- deterministic extraction success;
- Evidence quality/type;
- correctness against source;
- latency/retries;
- provider cost where available;
- cost per evidence-backed completed Course/domain;
- projected Layer 3/Layer 4 escalation rate.

Do not automatically reorder provider routes solely from early benchmark results. Any learned routing policy requires accepted governance/UAT.

## 5. QILT / PRISMS in Course context

QILT and PRISMS may be surfaced beside a Course to help counsellor/student selection, but their true source grain must be retained.

Examples:

- QILT Provider metric → label as Provider-level context;
- QILT study area metric → label as study-area/field context;
- PRISMS Provider/state/sector/cohort trend → label actual reporting scope/time period.

Never save a Provider-level metric into a Course-grain canonical field merely to simplify UI rendering.

## 6. Scholarship administration

Scholarships are first-class related entities. Validate eligibility scope, value/basis/currency, relevant Courses/study level/nationality, dates, application/automatic-consideration semantics and source Evidence.

`not discovered` is not equivalent to `none`.

## 7. Layer 3 hand-off

Layer 3 should receive only governed Course/entity identity, missing domain, Evidence set, source authority, provider-attempt metadata and prior observations.

If Layer 3 determines that the Evidence is insufficient, it should request additional capability from Layer 2, such as JavaScript-rendered or screenshot Evidence. Layer 3 does not independently scrape.

## 8. Layer 4 hand-off

Before human review, verify the case contains:

- entity/Course and unresolved domain;
- provider attempts;
- native/normalised Evidence;
- deterministic extraction candidates;
- Layer 3 suggestion/confidence if applicable;
- source URL/freshness;
- explicit blocker/reason automation stopped.

Human resolution is the last enrichment authority step.

## 9. Terminology

Avoid **Search Admission** in new Admin content. CourseFinder is not an admissions platform. Use Search Eligibility, Search Projection, Search Visibility, Publication Eligibility or Publication.
