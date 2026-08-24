# CourseFinder PIM Admin Guide v1.20

**Status:** CURRENT M2.1 ADMIN GUIDE  
**Date:** 24 August 2026  
**Supersedes:** v1.19.  
**Change Controls:** `CF-CHG-20260823-029`, `CF-CHG-20260823-030`, `CF-CHG-20260824-031`, `CF-CHG-20260824-032`

## 1. Authority model

CourseFinder has exactly four enrichment authority layers:

1. **Layer 1 — Authoritative / Regulatory**;
2. **Layer 2 — Deterministic acquisition and extraction**;
3. **Layer 3 — AI-assisted Evidence interpretation**;
4. **Layer 4 — Human resolution**.

Layer 4 is terminal for enrichment authority. Search projection and Publication are downstream states and are not Layer 5.

## 2. Reading Course Detail

Course Detail is a decision surface rather than a raw field dump.

### Required versus optional fields

Required and decision-critical facts remain visible even when empty. A blank uses `—` together with its layer-state trail so the operator can see what happens next.

Empty optional/non-required groups such as **Academic options, Categories and Collections** are suppressed from the normal Course drawer to reduce clutter. They appear when populated or through the relevant edit/review workflow.

A layer is struck only when that **specific field/domain** was actually attempted.

| UI state | Meaning | Operator action |
|---|---|---|
| value + `L1/L2/L3/L4` + Resolved | fact is currently resolved by that authority layer | inspect Evidence only if needed |
| struck `L1` + Regulatory correction | authoritative Layer 1 fact is missing/invalid | correct/re-ingest through Layer 1/source workflow |
| `L2` + Awaiting L2 | deterministic enrichment has not attempted that field/domain | leave to Layer 2/run the appropriate governed enrichment |
| struck `L2` → `L3` + Awaiting L3 | Layer 2 attempted and could not safely resolve the field | Layer 3 interprets retained Evidence or requests better Layer 2 Evidence |
| struck `L2`, struck `L3` → `L4 input` | both automated enrichment layers actually exhausted the field | Layer 4 human resolution |
| `L4` + L4 input | direct PIM/human-managed field | authorised human/PIM review |

The current M2.1 schema does not yet contain the accepted Layer 3 execution/persistence model, so the Admin may show `L2 struck → Awaiting L3` but must not fake a struck L3 state.

## 3. Course Detail formatting and card order

The normal order is:

1. identity/status overview;
2. Course description;
3. **Fees & entry requirements**;
4. Locations;
5. populated optional course information;
6. Regulatory facts;
7. Evidence;
8. Operational state.

Fees and Intakes/English appear side by side on desktop and stack vertically on narrower screens. Monetary values remain deliberately bold and prominent. Other field labels, values and supporting metadata use the same visual hierarchy throughout the drawer.

### Rearranging decision cards

Use **Arrange sections** in Course Detail to change the order of the major decision cards. Move cards up/down and choose **Done arranging** when finished.

The identity/status overview and Course description stay fixed at the top. They cannot be moved because they provide the stable context for every Course.

The chosen card order is saved for the signed-in user on that browser and survives page reload and logout/login. Rearranging cards is only a UI preference; it does not change Course data, completeness, Evidence, Search or Publication.

## 4. Retained per-screen search and filters

CourseFinder preserves working context per signed-in user and per screen on the same browser.

Current persisted working state includes:

- search text;
- selected filters;
- advanced-filter visibility where applicable;
- Course Detail decision-card order.

For example, if an administrator searches Courses for `088661B` and filters Country to Australia, those selections are restored after a reload and after signing out and signing back in on the same browser.

Use **Clear** on a catalogue screen to remove that screen's saved search/filter state and return to the default view.

Preferences are stored browser-locally and are not currently synchronised to another computer/browser. They contain interface state only; credentials, API keys, Evidence payloads and canonical facts are never stored in these preference records.

## 5. Layer 4 editing

Layer 4 is terminal for human resolution but is not unrestricted edit mode.

Layer 4 actions appear only when a field has genuinely reached L4 or when revising an existing L4 result. Current safe scalar fields include Course description, official Course URL, delivery mode and duration. Human resolution requires a reason/audit trail and does not automatically affect Search or Publication.

Compound tuition, English and intake facts require typed editors preserving their dimensions and must not be flattened into generic text.

## 6. Layer 2 administration

Layer 2 is limited to Course and Scholarship enrichment. QILT and PRISMS remain Layer 1/contextual datasets and are not scraper targets.

Use **Data Enrichment → Layer 2 Operations** for routine management. Source/profile/provider/job details remain progressive drill-down.

Provider credentials remain write-only in Admin and stored in Supabase Vault. Provider selection is outcome-based: Evidence-backed completion, correctness, latency, reliability, quota/cost and downstream fall-out matter more than HTTP success.

## 7. Fees

Fee information remains semantically separated:

- **Registered CRICOS course cost — Layer 1:** registered tuition, non-tuition and estimated total-course values;
- **Current Provider tuition — Layer 2/3/4 as resolved:** current first-party university tuition at the Provider-current semantic grain.

Never use a registered CRICOS total-course value as a substitute for missing Provider-current tuition.

Domestic CSP/student-contribution/Band values are not international Provider-current tuition unless governed source semantics explicitly prove that interpretation.

## 8. Evidence navigation

Evidence remains a private governed workspace for source URL, capture time, hash, acquisition/provider attempt, version/supersession, observations and review lineage.

Opening Evidence from Course Detail is supported. The earlier DOM-injected Back-to-Course implementation caused a browser responsiveness incident and remains deferred until a native React return path passes browser acceptance.

## 9. Completeness and readiness

Completeness is a coverage signal, not truth approval and not publication approval.

A factual completeness domain increases only when it reaches an accepted semantic state. Raw scraped text, HTTP success or a Layer 3 suggestion does not by itself make a field complete.

Course factual completeness remains separate from QILT/PRISMS decision-context readiness.

## 10. Publication

**100% completeness must never publish a Course automatically.**

Recommended flow:

`Completeness/readiness → Publication eligibility → bounded operator selection → preview → explicit Publish/Internal action → audit event → Search refresh → consumer visibility verification`.

For scale, publication should use a governed bulk workflow with an eligibility preview. Ineligible Courses are blocked/skipped explicitly; completeness cannot override publication governance.

Current broad Pilot catalogue publication remains unauthorised.

## 11. Country Course completeness trials

Use representative 5–10 Course cohorts and adapt based on consistency. Prefer Direct HTTP where sufficient; use scraper providers only where outcomes justify quota/cost.

Capture acquisition/extraction success, Evidence quality, correctness, latency/retries, provider quota/cost, completeness delta and L3/L4 fall-out.

## 12. Scholarship administration

Scholarships are first-class related entities. Listing/search Evidence discovers detail URLs; detail Evidence is then acquired and extracted. `Not discovered` is not equivalent to `none`.

## 13. Terminology

Avoid **Search Admission**. Use Search Eligibility, Search Projection, Search Visibility, Publication Eligibility or Publication.
