# CourseFinder PIM Admin Guide v1.19

**Status:** CURRENT M2.1 ADMIN GUIDE  
**Date:** 24 August 2026  
**Supersedes:** v1.18.  
**Change Controls:** `CF-CHG-20260823-029`, `CF-CHG-20260823-030`, `CF-CHG-20260824-031`, `CF-CHG-20260824-032`

## 1. Authority model

CourseFinder has exactly four enrichment authority layers:

1. **Layer 1 — Authoritative / Regulatory**;
2. **Layer 2 — Deterministic acquisition and extraction**;
3. **Layer 3 — AI-assisted Evidence interpretation**;
4. **Layer 4 — Human resolution**.

Layer 4 is terminal for enrichment authority. Search projection and Publication are downstream states and are not Layer 5.

## 2. Reading the Course attribute matrix

Course Detail displays the governed attribute set even when values are empty. The matrix is designed for operational decisions rather than hiding incomplete data.

Each row reads:

`Attribute → value / — → layer state → available action`

A blank (`—`) is not itself an error and does not automatically authorise human entry. The state trail determines what should happen next.

| UI state | Meaning | Operator action |
|---|---|---|
| value + `L1/L2/L3/L4` + Resolved | fact is currently resolved by that authority layer | inspect Evidence only if needed |
| struck `L1` + Regulatory correction | authoritative Layer 1 fact is missing/invalid | correct/re-ingest through Layer 1/source workflow; do not override in normal L4 enrichment |
| `L2` + Awaiting L2 | deterministic acquisition/extraction has not attempted that field/domain | leave to Layer 2/run the appropriate governed enrichment |
| struck `L2` → `L3` + Awaiting L3 | Layer 2 actually attempted and could not safely resolve this field/domain | Layer 3 should interpret the retained Evidence/request more Layer 2 Evidence |
| struck `L2`, struck `L3` → `L4 input` | both automated enrichment layers actually failed/exhausted the field | Layer 4 human resolution |
| `L4` + L4 input | direct PIM/human-managed field | authorised human/PIM review |

A layer is struck only when that **specific field/domain** was attempted. Do not infer that all fields were attempted merely because a Course had a Layer 2 job.

### Current Layer 3 limitation

The current M2.1 deployed schema does not yet have the accepted Layer 3 execution/persistence model. Therefore the Admin can legitimately show `L2 struck → Awaiting L3`, but must not show a fake struck L3 for enrichment fields until Layer 3 actually runs and records the result.

## 3. Layer 4 editing

Layer 4 is the terminal human-resolution layer, but it is not a general unrestricted edit mode.

Layer 4 actions appear only when:

- a field is explicitly `L4 input` / `awaiting L4`; or
- an existing Layer 4 value is being revised.

Current safe scalar Layer 4 fields are:

- Course description;
- official Course URL;
- delivery mode;
- duration.

The inline scalar editor requires a human resolution reason and creates an audit/provenance record. The resulting value displays `L4` provenance. It does not publish the Course and does not automatically change Search.

### Compound facts

Do not enter tuition, English requirements or intakes as generic free text. Their future Layer 4 editors must retain the semantic dimensions of those facts:

- **tuition:** amount, currency, year, audience, basis/scope;
- **English:** test, overall score, component scores, scope/notes;
- **intakes:** label, year, start date, deadline, campus/status where applicable.

Until those typed editors are accepted, terminal compound fields route to Layer 4 Review rather than a free-text mutation.

## 4. Layer 2 administration

Layer 2 is limited to Course and Scholarship enrichment. QILT and PRISMS remain Layer 1/contextual datasets and are not Layer 2 scraper targets.

Use **Data Enrichment → Layer 2 Operations** for routine management. Source/profile/provider/job detail is progressive drill-down.

Provider credentials remain write-only in Admin and stored in Supabase Vault. Provider selection is outcome-based: evidence-backed completion, correctness, latency, reliability, quota/cost and downstream fall-out matter more than HTTP success.

## 5. Fees

Fee information remains semantically separated:

- **Registered CRICOS course cost — Layer 1:** registered tuition, non-tuition and estimated total-course values;
- **Current Provider tuition — Layer 2/3/4 as resolved:** current first-party university tuition at the Provider-current semantic grain.

Never use a registered CRICOS total-course value as a substitute for a missing Provider-current tuition field.

Domestic CSP/student-contribution/Band values are not international Provider-current tuition unless the governed source semantics explicitly prove that interpretation.

## 6. Evidence navigation

Evidence remains a private governed workspace for source URL, capture time, hash, acquisition/provider attempt, version/supersession, observations and review lineage.

The earlier v2.14 DOM-injected **Back to Course** implementation caused a browser responsiveness incident and is currently deferred. Opening Evidence from a Course is supported; a native React return path may be reintroduced only after browser recovery acceptance.

## 7. Completeness and readiness

Completeness is a coverage signal, not truth approval and not publication approval.

A factual completeness domain increases only when it reaches an accepted semantic state. Raw scraped text, an HTTP success or a Layer 3 suggestion does not by itself make a field complete.

Course factual completeness remains separate from QILT/PRISMS decision-context readiness.

## 8. Publication

**100% completeness must never publish a Course automatically.**

Recommended flow:

`Completeness/readiness → Publication eligibility → bounded operator selection → preview → explicit Publish/Internal action → audit event → Search refresh → consumer visibility verification`.

Minimum applicable controls include active lifecycle, stable identity, required Course fields, accepted Search projection, governed Evidence and absence of blocking review/publication state.

For operational scale, publication should use a governed bulk workflow with an eligibility preview. Ineligible Courses are blocked/skipped explicitly; a completeness score cannot override publication governance.

Current broad Pilot catalogue publication remains unauthorised.

## 9. Publication states

- `published` — eligible consumer channels may display the Course;
- `internal` — authorised internal consumers only according to channel contract;
- `unpublished` — canonical Course exists but is not consumer-visible;
- `blocked` — publication is explicitly prevented.

`active`, `100% completeness`, `Search projected`, `Layer 2 resolved` and `Evidence present` are not synonyms for `published`.

## 10. Country Course completeness trials

Use representative 5–10 Course cohorts and adapt based on consistency. Prefer Direct HTTP where sufficient; use scraper providers only where outcomes justify quota/cost.

Capture acquisition/extraction success, Evidence quality, correctness, latency/retries, provider quota/cost, completeness delta and L3/L4 fall-out.

## 11. Scholarship administration

Scholarships are first-class related entities. Listing/search Evidence discovers detail URLs; detail Evidence is then acquired and extracted. `Not discovered` is not equivalent to `none`.

## 12. Terminology

Avoid **Search Admission**. Use Search Eligibility, Search Projection, Search Visibility, Publication Eligibility or Publication.