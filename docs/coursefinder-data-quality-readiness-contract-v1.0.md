# CourseFinder Data Quality & Readiness Contract v1.0

**Status:** IMPLEMENTED — TECHNICAL CONTRACT ACCEPTED; DEPLOYED BROWSER ACCEPTANCE PENDING  
**Date:** 21 August 2026  
**Workstream:** `M1-DATA-QUALITY-READINESS`  
**Change Control:** `CF-CHG-20260821-018`

## Purpose

CourseFinder data quality is a governed operational decision surface, not a generic percentage of populated fields. This contract defines how Provider, Course, Campus, Scholarship and enrichment readiness are classified and exposed to administrators without manufacturing values or collapsing source authority, enrichment coverage, Search admission and publication into one score.

## Core decision

CourseFinder does **not** expose one cross-domain composite completeness percentage as the authoritative Data Quality product measure.

A single equal-weight percentage is misleading because:

- Layer 1 regulatory identity has different authority from Layer 2 enrichment;
- a legitimate numeric zero is a known value, not a missing field;
- a source-confirmed null is different from enrichment that has never been attempted;
- a country-specific dimension can be genuinely not applicable;
- Search projection does not mean publication readiness;
- Scholarship applicability is relational enrichment, not a mandatory canonical Course identity property.

The Admin therefore reports **domain readiness** with domain-specific denominators and explicit exception states.

## Governed state vocabulary

Every readiness metric exposes all of the following states, including zero-count states:

| State | Meaning |
|---|---|
| `present` | A governed applicable value/relationship/state is present. |
| `source_null` | The authoritative/applicable source was checked and the expected value/relationship is absent/null. This must not be inferred from a plain canonical null without source evidence. |
| `not_applicable` | The dimension does not apply to the entity/source-country contract. It is excluded from the applicable denominator. |
| `zero` | A governed numeric zero is present. Zero counts as ready and must never be converted to missing. |
| `suppressed` | The governed source/observation explicitly suppresses the value. |
| `not_yet_enriched` | The canonical entity exists but the applicable enrichment has not yet been populated/accepted. This is not a Layer 1 defect. |
| `stale` | Verification exists but is outside the governed freshness window, or a required verification timestamp is absent where the domain defines that as stale. |
| `ambiguous` | The governed source/mapping/review state explicitly records unresolved ambiguity. |
| `rejected` | The observation/candidate/state is explicitly rejected by the governed contract. |

Ready states for readiness-rate calculation are `present` and `zero`. `not_applicable` is excluded from the denominator.

## Domains

The operational workspace exposes:

1. identity completeness;
2. regulatory completeness;
3. geography / delivery;
4. taxonomy;
5. regulatory fee;
6. current Provider fee;
7. Course URL;
8. Intake;
9. English requirement;
10. Scholarship;
11. evidence;
12. verification / freshness;
13. Search admission;
14. publication readiness.

Domains apply only to the entity types for which they have governed meaning.

## Authority boundaries

### Identity completeness

Uses stable canonical identity and governed Layer 1 identity relationships. It never uses title/name similarity as a substitute for a stable Provider/Course identity.

### Regulatory completeness

Uses country-specific accepted Layer 1 authority. Australia is CRICOS; New Zealand is NZQA under the accepted source matrix. Country semantics are not made artificially identical.

### Geography / delivery

Provider geography, Campus geography and Course→Campus/delivery relationships remain distinct. Missing Course delivery geography does not inherit Provider address merely to improve completeness.

For AU CRICOS, the 34 accepted Course-location gaps proven by Layer 1 UAT are `source_null` because current CRICOS Course Locations contains no relationship for those Courses. No synthetic Campus is created.

For current NZQA Layer 1, Course delivery-location enrichment is `not_yet_enriched` where no governed relationship exists; it is not labelled a CRICOS source-null.

### Taxonomy

Governed Study Level / Field mappings are used. Review-required/ambiguous/rejected mappings retain their explicit state. Missing later-country taxonomy enrichment is not silently inferred from titles.

### Regulatory fee

Australia uses CRICOS registered total-course tuition semantics only. The accepted AU residual is:

- 26,326 positive tuition values;
- 131 legitimate AUD 0 tuition values;
- 191 source-null tuition values.

The 131 zero values are ready values.

NZQA does not provide a CRICOS-equivalent regulatory tuition dimension in the accepted Layer 1 contract, so NZ Courses are `not_applicable` for this domain.

### Current Provider fee

Provider-current published fee observations are Layer 2 and remain separate from CRICOS registered total-course fees. Lack of a Provider-current fee before accepted enrichment is `not_yet_enriched`, not a regulatory defect.

### Course URL / Intake / English requirement

These are Provider-first-party Layer 2 facts. Before accepted enrichment, absence is `not_yet_enriched` unless a governed source observation explicitly supports another state such as source-null/suppressed/rejected.

### Scholarship

Scholarship is relational. Course applicability comes from accepted Scholarship scopes/relationships. Lack of an accepted relationship is an enrichment-coverage state, not a defect in Course identity.

### Evidence

Evidence readiness reflects governed Evidence/entity lineage. It does not expose private Storage paths or raw internal metadata beyond the already accepted Evidence workspace boundary.

### Verification / freshness

Only governed verification timestamps are authoritative for freshness. `updated_at` is not silently promoted to verification. Scholarship verification is therefore not inferred from a recent row update.

### Search admission

Search readiness reports presence in the governed Search projection/admission state. It does not mean enrichment is admitted, an entity is published, or a publication channel is active.

### Publication readiness

Canonical publication progression and publishing-channel state remain separate from Search. No Search document is treated as evidence that a Course is published.

## Browser read contract

Normal browser access remains:

`public.admin_read(text, jsonb)`

New operations:

- `data_quality_overview`
- `data_quality_exceptions`

`data_quality_overview` returns all domain/entity aggregate state counts in one bounded call.

`data_quality_exceptions` returns one server-side filtered/paged entity/domain/state result set with canonical identity, Provider/country context, Source/Evidence references, verification timestamps and an open Review ID where the underlying workflow supplies one.

The workspace does not perform page-level per-row detail RPCs. Opening a canonical entity, Evidence artifact or Review Queue is an explicit operator action.

## Security boundary

- `public.admin_read` remains authenticated-only and role-checked through the existing CourseFinder role model.
- Data Quality overview/exception access requires at least an assigned CourseFinder role (rank 1).
- Evidence navigation continues to require Curator rank 3.
- Review Queue continues to require Curator rank 3.
- Private `security.data_quality_*` implementation/base helpers are not executable by `anon` or `authenticated`.
- No canonical/internal schema CRUD permission is introduced.

## Live AU+NZ technical baseline

At technical UAT on 21 August 2026:

- Providers: 1,955;
- Courses: 33,105;
- Campuses: 3,922;
- Scholarships: 4;
- Search Course documents: 33,105.

Representative domain state:

- identity: 100% present across scoped entity types;
- Provider/Course regulatory identity: 100% present;
- Course geography: 26,614 present / 34 AU source-null / 6,457 NZ not-yet-enriched;
- regulatory tuition: 26,326 present / 131 zero / 191 AU source-null / 6,457 NZ not-applicable;
- Provider-current fee: 10 present / 33,095 not-yet-enriched;
- Course URL: 10 present / 33,095 not-yet-enriched;
- Intake: 10 Courses present / 33,095 not-yet-enriched;
- English requirement: 10 Courses present / 33,095 not-yet-enriched;
- Course Scholarship applicability: 500 present / 32,605 not-yet-enriched;
- Evidence: 100% present for scoped Provider/Course/Campus/Scholarship entities;
- Search admission/projection: 33,105/33,105 Courses present;
- publication readiness: no Search-derived publication is inferred.

Current zero-count `suppressed`, `ambiguous` and `rejected` states remain first-class parts of the API/UI contract.

## Performance contract

Full AU+NZ reads are server-side and bounded.

Observed final implementation samples:

- full AU+NZ overview, warm DB sample: ~837 ms;
- AU regulatory-fee `source_null`, 50-row exception page, warm DB sample: ~156 ms;
- final queries showed zero temporary read/write spill in those samples.

Earlier cold optimisation runs are retained in UAT and are not hidden; the overview had approximately 4 s cold behaviour after spill removal before warm-cache measurement.

## Change isolation

This workstream does not:

- change Provider/Course/Campus/Scholarship identity;
- manufacture missing values;
- rewrite canonical fees/intakes/English facts;
- rebuild or broaden Search admission;
- publish entities;
- change Evidence storage/privacy semantics;
- approve Review Queue decisions.

## Related records

- `CF-CHG-20260820-012` — lifecycle/publication/readiness/Search separation;
- `CF-CHG-20260820-014` — completeness-profile governance;
- `CF-CHG-20260820-015` — PIM browser/performance baseline;
- `CF-CHG-20260821-016` — Pipeline Operations boundary;
- `CF-CHG-20260821-017` — Evidence operational/private boundary;
- `CF-CHG-20260821-018` — this Data Quality gate.
