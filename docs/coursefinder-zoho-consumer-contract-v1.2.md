# CourseFinder Zoho Consumer Contract v1.2

**Status:** GOVERNED CURATED CONTRACT — SCHOLARSHIP RELATIONAL EXTENSION  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-zoho-consumer-contract-v1.1.md`  
**Change Control:** `CF-CHG-20260820-001`, `008`, `009`, `011`  
**Scope:** semantic mapping contract only; no Search/Website/Zoho publication admission is implied.

All unchanged Provider/Course/Fee/Campus/Intake/English/QILT/PRISMS rules from v1.0-v1.1 remain in force. v1.2 defines a lossless Scholarship consumer shape.

## Scholarship object

Scholarships must not be flattened into one Course/Provider text field.

| API name | Zoho label | Type | Cardinality | Notes |
|---|---|---|---|---|
| `scholarship_key` | Scholarship Key | string | single | governed stable identity; name is not identity |
| `scholarship_name` | Scholarship | string | single | display label |
| `scholarship_type` | Scholarship Type | string | single | e.g. government/provider Scholarship |
| `provider_key` | Owning Provider | string | single | nullable; government schemes may not have one Provider owner |
| `audience` | Audience | string | single | source/governed audience |
| `lifecycle_status` | Lifecycle | string | single | independent of cycle/window/publication |
| `publication_status` | Publication | string | single | independent of lifecycle |
| `application_required` | Application Required | boolean | single | nullable where source does not define it |
| `award_summary` | Award Summary | string | single | convenience/display only; must not replace structured tiers/coverage |
| `cycles` | Offering Cycles | object[] | repeating | required relational parent for cycle-specific children |
| `source_ref` | Source | object/string | single | Scholarship record provenance |
| `evidence_ref` | Evidence | object/string | single | Scholarship record provenance |

## Offering Cycle object

| API name | Zoho label | Type | Cardinality | Notes |
|---|---|---|---|---|
| `cycle_key` | Offering Cycle Key | string | single | stable source/canonical cycle identity |
| `cycle_code` | Cycle Code | string | single | source/governed cycle code |
| `academic_year` | Academic Year | integer | single | nullable; recurring schemes may have no year |
| `intake_label` | Cycle / Intake Label | string | single | source-supported label |
| `valid_from` | Valid From | date | single | nullable |
| `valid_to` | Valid To | date | single | nullable; not automatically permanent |
| `status` | Cycle Status | string | single | separate from Scholarship lifecycle |
| `application_windows` | Application Windows | object[] | repeating | cycle child |
| `scopes` | Applicability Scopes | object[] | repeating | cycle child |
| `eligibility_groups` | Eligibility Groups | object[] | repeating | logical tree nodes |
| `award_tiers` | Award Tiers | object[] | repeating | value options |
| `coverage` | Coverage / Benefits | object[] | repeating | benefit components |
| `source_ref` | Cycle Source | object/string | single | child provenance |
| `evidence_ref` | Cycle Evidence | object/string | single | child provenance |

Child observations with no cycle relationship must not be silently copied into every cycle or assigned to the newest cycle. If consumer admission includes them, expose an explicit `unscoped`/review collection.

## Application Window object

| API name | Zoho label | Type | Notes |
|---|---|---|---|
| `round_code` | Application Round | string | nullable |
| `label` | Application Window | string | source/governed label |
| `opens_at` | Opens At | datetime | nullable |
| `closes_at` | Closes At | datetime | nullable |
| `source_closing_text` | Source Closing Text | string | retain when source supplies text instead of exact date |
| `application_method` | Application Method | string | nullable |
| `application_url` | Application URL | URL | nullable |
| `status` | Window Status | string | independent of Scholarship lifecycle |
| `source_ref` | Source | object/string | child provenance |
| `evidence_ref` | Evidence | object/string | child provenance |

Do not derive a precise date from phrases such as `Mid September each year - check website for exact dates`.

## Applicability Scope object

| API name | Zoho label | Type | Notes |
|---|---|---|---|
| `scope_type` | Scope Type | enum/string | Provider, Course, Collection, Study Level, Field, Country, Campus, etc. |
| `include_exclude` | Scope Action | enum | preserve include/exclude semantics |
| `target_key` | Scope Target Key | string | canonical/stable target identity |
| `target_name` | Scope Target | string | display label |
| `source_ref` | Source | object/string | provenance |
| `evidence_ref` | Evidence | object/string | provenance |

**Empty Scope list does not mean universal applicability.** Consumer logic must not infer `all Providers` or `all Courses` from no structured rows.

## Eligibility Group object

Eligibility is a tree. Zoho must preserve parentage and conjunction.

| API name | Zoho label | Type | Notes |
|---|---|---|---|
| `group_key` | Eligibility Group Key | string | stable group identity |
| `group_code` | Group Code | string | governed/source code |
| `label` | Eligibility Group | string | display label |
| `parent_group_key` | Parent Eligibility Group | string | nullable for root group |
| `conjunction` | Group Logic | enum | e.g. `all`, `any` |
| `is_mandatory` | Mandatory Group | boolean | preserve source/governed meaning |
| `display_order` | Display Order | integer | UI/ordering only |
| `criteria` | Eligibility Criteria | object[] | direct child criteria only |
| `source_ref` | Source | object/string | provenance |
| `evidence_ref` | Evidence | object/string | provenance |

If Zoho cannot support recursive group structures, use a relational child-module design with `parent_group_key`; do not flatten into a single text field or Boolean.

### Conjunction semantics

- `all` = all governed direct requirements/child-group requirements must be satisfied under that group;
- `any` = a governed alternative may satisfy that group according to its parent logic.

## Eligibility Criterion object

| API name | Zoho label | Type | Notes |
|---|---|---|---|
| `criterion_key` | Criterion Key | string | stable identity |
| `criterion_type` | Criterion Type | string | governed category |
| `operator` | Operator | string | e.g. `>=`, `not`, `in_source_list`, `source_text` |
| `human_text` | Eligibility Rule | text | source/governed human meaning |
| `value_text` | Value Text | text | nullable |
| `value_number` | Numeric Value | decimal | nullable |
| `value_codes` | Value Codes | string[] | nullable/repeating |
| `value_json` | Structured Source Value | object | nullable; consumer-specific mapping required |
| `is_mandatory` | Mandatory | boolean | criterion state |
| `machine_evaluable` | Machine Evaluable | boolean | false means human/source review, not failure |
| `status` | Criterion Status | string | observation status |
| `confidence` | Mapping Confidence | decimal | audit/automation signal, not approval |
| `source_ref` | Source | object/string | provenance |
| `evidence_ref` | Evidence | object/string | provenance |

Never reduce eligibility to `eligible=true/false` unless a separate governed eligibility-evaluation service has evaluated a specific applicant against the complete rule tree.

## Award Tier object

| API name | Zoho label | Type | Notes |
|---|---|---|---|
| `tier_code` | Award Tier Code | string | identity within Scholarship/cycle |
| `label` | Award Tier | string | display label |
| `amount` | Award Amount | decimal | nullable |
| `currency_code` | Currency | string(3) | nullable with non-cash/% tier |
| `percentage` | Award Percentage | decimal | nullable |
| `basis` | Award Basis | string | e.g. annual, tuition_fee_reduction |
| `maximum_amount` | Maximum Amount | decimal | nullable |
| `notes` | Award Notes | text | source-supported context |
| `source_ref` | Source | object/string | provenance |
| `evidence_ref` | Evidence | object/string | provenance |

## Coverage / Benefit object

Coverage is different from Award Tier.

| API name | Zoho label | Type | Notes |
|---|---|---|---|
| `coverage_type` | Benefit Type | string | e.g. tuition_fees, living_expenses, health cover |
| `percentage` | Coverage Percentage | decimal | nullable |
| `amount` | Coverage Amount | decimal | nullable |
| `currency_code` | Currency | string(3) | nullable |
| `duration_value` | Duration Value | decimal | nullable |
| `duration_unit` | Duration Unit | string | nullable |
| `notes` | Benefit Notes | text | may carry the primary source meaning |
| `source_ref` | Source | object/string | provenance |
| `evidence_ref` | Evidence | object/string | provenance |

Do not manufacture numeric amounts where the authority only publishes a benefit description.

## Reference cases

### Australia Awards Scholarships

If admitted, the 2027 cycle must preserve:

- two Application Windows;
- root mandatory `all` General eligibility group;
- nested mandatory `any` Participating-country pathway group;
- 7 direct criteria under root + 2 under child;
- nine separate Coverage benefits;
- no structured Scope rows as **no structured Scope rows**, not universal applicability.

### RMIT David Phillips Memorial Scholarship

If admitted, preserve:

- recurring Offering Cycle;
- source closing text `Mid September each year - check website for exact dates` with null exact dates;
- include Provider Scope → RMIT University (RMIT);
- Award Tier AUD 5,000 / annual.

## Admission status

v1.2 remains definition-only. Scholarship publication to Zoho/Website remains blocked until the consumer gate proves:

- cycle/window cardinality is lossless;
- scope include/exclude and empty-scope semantics are preserved;
- eligibility parent-group/conjunction logic is preserved;
- machine-evaluable false is not treated as ineligible;
- award tier and coverage remain separate;
- source/evidence exposure is appropriate;
- backward-compatible contract versioning is defined;
- no private/internal schema implementation detail is leaked unnecessarily.
