# CourseFinder PIM Admin Guide v1.18

**Status:** CURRENT M2.1 ADMIN GUIDE  
**Date:** 24 August 2026  
**Supersedes:** v1.17.  
**Change Controls:** `CF-CHG-20260823-029`, `CF-CHG-20260823-030`, `CF-CHG-20260824-031`

## 1. Authority model

CourseFinder has exactly four enrichment authority layers:

1. **Layer 1 — Authoritative / Regulatory**;
2. **Layer 2 — Deterministic acquisition and extraction**;
3. **Layer 3 — AI-assisted Evidence interpretation**;
4. **Layer 4 — Human resolution**.

Layer 4 is terminal for enrichment authority. Search projection and Publication are downstream states and are not a Layer 5.

The Course Detail UI may show compact `L1`, `L2`, `L3` or `L4` badges beside facts. These badges describe the authority/provenance layer that supplied or resolved the displayed fact. They do not cause additional acquisition and should be rendered from data already returned by the governed Course-detail read wherever possible.

## 2. Layer 2 administration

Layer 2 is limited to Course and Scholarship enrichment. QILT and PRISMS remain Layer 1/contextual datasets and are not Layer 2 scraper targets.

Use **Data Enrichment → Layer 2 Operations** for routine management. Advanced Source Profile, provider, job and trial controls are drill-down functions rather than separate day-to-day menu destinations.

Provider credentials remain write-only in Admin and stored in Supabase Vault. Current acquisition providers may include Direct HTTP, Scrape.do, Firecrawl and ZenRows. Provider selection is outcome-based: evidence-backed fact resolution, correctness, latency, reliability, quota/cost and Layer 3 fall-out matter more than HTTP 200 alone.

## 3. Course Detail interpretation

Course Detail is intentionally concise. Empty optional areas such as Academic Options, Categories and Collections are hidden rather than rendered as empty panels.

### Fees

Fee information is separated into:

- **Registered CRICOS course cost — Layer 1**: registered tuition, non-tuition and estimated total-course values from authoritative CRICOS facts;
- **Current Provider tuition — Layer 2**: current first-party university tuition captured through governed enrichment.

Do not compare these as if they are the same measure. A Course may have registered CRICOS total-course cost but no evidence-backed current Provider annual tuition.

Fee cards show the monetary figure prominently, then Year, Audience and Basis as secondary metadata. Evidence opens the exact supporting artifact.

### Evidence navigation

When Evidence is opened from a Course, the Evidence workspace provides **Back to Course**. Use the Evidence workspace for source URL, capture timestamp, content hash, provider attempt, acquisition job and version history, then return to the Course without re-searching.

## 4. Completeness and readiness

Completeness is a coverage signal, not truth approval and not publication approval.

A factual-completeness score should only increase when the underlying domain reaches an accepted semantic state such as `present`, `source-null`, `not applicable`, `zero`, `suppressed`, `stale`, `ambiguous`, `rejected` or another governed state. Scraped text alone does not make a field complete.

Country-specific rules apply. AU Courses can use CRICOS-specific domains; other countries must not be penalised for not having Australian regulatory fields.

Decision-context readiness, such as QILT/PRISMS availability, remains separate from Course factual completeness.

## 5. Publication — required decision flow

**100% completeness must never publish a Course automatically.**

A 100% completeness result means the Course is a candidate for publication review. Publication is an explicit governed state transition with its own eligibility checks, approval and audit event.

The recommended operational flow is:

`Completeness / readiness → Publication eligibility → operator selection → preview → explicit Publish/Internal action → audit event → Search refresh → consumer visibility verification`

### Minimum Pilot publication conditions

Under the accepted Pilot publication profile, a Course may enter `internal` or `published` only when all applicable publication controls pass, including:

1. explicit approval for the publication profile;
2. active canonical lifecycle;
3. supported country/profile scope;
4. stable Course identity and Provider identity;
5. required Course title and Course code;
6. accepted Search projection presence;
7. at least one governed Course Evidence relationship;
8. no blocking publication/review state.

Completeness may be used as an additional operational filter but does not replace these controls.

### Bulk publication

For operational scale, use a **bulk publication workflow**, not automatic publication from a score.

The intended Admin interaction is:

1. filter Courses by `Publication eligible`, country, Provider and/or 100% factual completeness;
2. select a bounded set of Courses;
3. open a preview showing eligibility, unresolved warnings, consumer consequence and requested target state;
4. choose `Publish`, `Internal`, or cancel;
5. require a reason/change reference where policy requires it;
6. execute through the governed publication service;
7. record publication events and refresh Search;
8. verify Website/Zoho visibility according to the chosen state.

Bulk publication must skip or block ineligible Courses rather than partially hiding eligibility failures.

Current Pilot broad-catalogue publication remains unauthorised until a later explicit acceptance gate enables that operating mode.

## 6. Publication states

- `published` — eligible consumer channels may display the Course;
- `internal` — internal/authorised consumer use only according to channel contract;
- `unpublished` — canonical record exists but is not consumer-visible;
- `blocked` — publication is explicitly prevented.

`active`, `100% completeness`, `Search projected`, `Layer 2 resolved`, or `Evidence present` are not synonyms for `published`.

## 7. Country Course completeness trials

For bounded Layer 2 trials, begin with representative Courses per university, normally 5–10 Courses. Prefer Direct HTTP where sufficient and escalate to paid/free-tier providers only where the outcome justifies it.

Capture acquisition success, deterministic extraction success, Evidence quality, correctness, latency/retries, provider quota/cost, completeness delta and Layer 3/4 fall-out.

## 8. Scholarship administration

Scholarships are first-class related entities. A listing/search page must first discover Scholarship detail URLs; detail Evidence is then acquired and extracted. `Not discovered` is not equivalent to `none`.

## 9. Layer 3 and Layer 4 hand-off

Layer 3 receives unresolved domains plus the governed Evidence package. It does not scrape independently; it may request additional Layer 2 Evidence capability.

Only unresolved Layer 3 fall-out becomes Layer 4 Review. Layer 4 is terminal.

## 10. Terminology

Avoid **Search Admission**. Use Search Eligibility, Search Projection, Search Visibility, Publication Eligibility or Publication.
