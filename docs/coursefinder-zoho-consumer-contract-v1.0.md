# CourseFinder Zoho Consumer Contract v1.0

**Status:** GOVERNED CURATED CONTRACT — INITIAL  
**Date:** 20 August 2026  
**Change Control:** `CF-CHG-20260820-001`  
**Scope:** semantic mapping contract only; no Search/Zoho publication gate is implied by this document.

## 1. Purpose

Zoho must consume a curated CourseFinder contract rather than internal table structure. This contract defines stable consumer meaning, type, cardinality and null semantics for the first externally useful Provider/Course fields.

Internal UUIDs, table names and implementation joins may change without changing the consumer contract when semantics remain stable.

## 2. Consumer principles

- stable regulatory/provider identifiers are exposed ahead of display-name identity;
- repeating facts remain repeating objects;
- regulatory, Provider-current and derived values are explicitly classified;
- zero is preserved as zero;
- `NULL` is not converted to zero or an invented year/basis;
- evidence metadata may be exposed as audit metadata but private storage paths are not part of the normal Zoho contract;
- Search admission and Zoho admission are separate governance decisions;
- unsupported/internal-only fields are omitted rather than leaked from the database schema.

## 3. Provider object

| API name | Zoho label | Type | Cardinality | Class | Null semantics / notes |
|---|---|---|---|---|---|
| `provider_key` | Provider Key | string | single | canonical | governed stable key; not a display name |
| `provider_name` | Provider Name | string | single | canonical/display | current canonical/display name |
| `country_code` | Country | string(2) | single | canonical | ISO alpha-2 |
| `regulatory_identifiers` | Regulatory Identifiers | object[] | repeating | regulatory | scheme + code; use for reconciliation |
| `lifecycle_status` | Lifecycle Status | string | single | canonical | does not imply publication |
| `publication_status` | Publication Status | string | single | publication | consumer must not infer from completeness |
| `last_verified_at` | Last Verified | datetime | single | governance | verification timestamp, not approval |

## 4. Course object

| API name | Zoho label | Type | Cardinality | Class | Null semantics / notes |
|---|---|---|---|---|---|
| `course_key` | Course Key | string | single | canonical | governed stable key |
| `course_code` | Course Code / CRICOS Code | string | single | regulatory where applicable | AU reconciliation key; title-only matching forbidden |
| `course_title` | Course Title | string | single | canonical/display | not an identity key |
| `provider_key` | Provider Key | string | single | canonical relationship | parent relationship |
| `study_level` | Study Level | object | single | canonical taxonomy | include canonical code/label; source vocabulary may be separate audit metadata |
| `field_of_study` | Field of Study | object | single | canonical taxonomy | mapping authority governed separately |
| `duration_value` | Duration Value | decimal | single | canonical/regulatory | pair with unit |
| `duration_unit` | Duration Unit | string | single | canonical/regulatory | e.g. weeks |
| `campuses` | Campuses | object[] | repeating | relational | do not substitute Provider State |
| `fees` | Fees | object[] | repeating | relational | see fee observation contract |
| `intakes` | Intakes | object[] | repeating | Provider-current | only when admitted to Zoho |
| `english_requirements` | English Requirements | object[] | repeating | Provider-current | preserve test/component grain |
| `lifecycle_status` | Lifecycle Status | string | single | canonical | independent of publication |
| `publication_status` | Publication Status | string | single | publication | independent of Search projection |
| `last_verified_at` | Last Verified | datetime | single | governance | not approval |

## 5. Fee observation object

Fee observations must never be flattened into a single generic `Course Fee` field.

| API name | Zoho label | Type | Cardinality | Required for meaning? | Notes |
|---|---|---|---|---|---|
| `fee_class` | Fee Class | enum | single | yes | `cricos_registered`, `provider_current`, or separately governed future class |
| `fee_type` | Fee Type | string | single | yes | e.g. `tuition`, `non_tuition`, `estimated_total_course_cost`, `provider_current_tuition` |
| `amount` | Amount | decimal | single | yes when source supplies | preserve `0` as numeric zero |
| `currency_code` | Currency | string(3) | single | yes with amount | e.g. AUD |
| `basis` | Fee Basis | string | single | yes | e.g. `registered_total_course`, `annual`, `indicative_annual`, `total_indicative` |
| `load_basis` | Load Basis | string | single | no | `NULL` when not supplied/applicable |
| `fee_year` | Fee Year | integer | single | no | `NULL` is valid for CRICOS registered fees where no year is supplied |
| `audience` | Audience | string | single | yes when supplied | e.g. `international` |
| `campus_key` | Campus Scope | string | single | no | null means no accepted campus scope is recorded; do not infer all campuses |
| `valid_from` | Valid From | date | single | no | observation validity |
| `valid_to` | Valid To | date | single | no | null commonly means no end recorded/current |
| `source_key` | Source Key | string | single | audit | curated source identifier, not internal UUID if a stable external key is available |
| `source_snapshot_at` | Source Snapshot | datetime | single | audit | snapshot represented by observation |
| `last_verified_at` | Last Verified | datetime | single | audit | verification, not approval |
| `evidence_ref` | Evidence Reference | string/object | single | audit | governed reference; private storage location is not exposed by default |

### 5.1 CRICOS registered fee mappings

| Canonical `fee_type` | Zoho label | `fee_class` | Basis |
|---|---|---|---|
| `tuition` | Tuition Fee | `cricos_registered` | `registered_total_course` |
| `non_tuition` | Non-Tuition Fee | `cricos_registered` | `registered_total_course` |
| `estimated_total_course_cost` | Estimated Total Course Cost | `cricos_registered` | `registered_total_course` |

For CRICOS `121174E`, Zoho must receive three distinct observations if/when this field class is admitted: AUD 132,900 tuition; AUD 0 non-tuition; AUD 132,900 estimated total Course cost. `fee_year` remains null.

### 5.2 Provider-current fee mappings

Provider-current tuition is emitted as `fee_class=provider_current` with source-preserved year and basis. It must not replace or overwrite the CRICOS registered observations.

Example semantics already present in Pilot for bounded Layer 2 Courses include year-specific values with `annual`, `indicative_annual` or `total_indicative` basis.

## 6. Intake observation object

| API name | Zoho label | Type | Cardinality | Notes |
|---|---|---|---|---|
| `intake_year` | Intake Year | integer | single | preserve source year |
| `intake_label` | Intake | string | single | source-governed label |
| `start_date` | Start Date | date | single | null if source does not publish exact date |
| `application_deadline` | Application Deadline | date | single | null if not supplied |
| `campus_key` | Campus Scope | string | single | do not infer when absent |
| `status` | Intake Status | string | single | observation state |
| `source_snapshot_at` | Source Snapshot | datetime | single | audit where contract exposes it |
| `evidence_ref` | Evidence Reference | string/object | single | audit |

## 7. English requirement object

| API name | Zoho label | Type | Cardinality | Notes |
|---|---|---|---|---|
| `test_code` | English Test | string | single | governed test identity only |
| `overall_score` | Overall Score | decimal | single | null if source uses a different rule |
| `component_scores` | Component Scores | object | single | preserve component thresholds |
| `notes` | Requirement Notes | string | single | source-supported explanation |
| `valid_from` | Valid From | date | single | optional |
| `valid_to` | Valid To | date | single | optional |
| `last_verified_at` | Last Verified | datetime | single | not approval |
| `evidence_ref` | Evidence Reference | string/object | single | audit |

## 8. Scholarship contract direction

Scholarships are relational and should not be embedded as one text field on Course.

Expose a Scholarship object with stable identifier, Provider relationship, offering cycles, application windows, scopes, compound eligibility groups/criteria, award tiers and coverage. Course/provider scope is explicit. Detailed schema remains subject to its own consumer-admission gate.

## 9. QILT outcomes contract direction

QILT values must expose their true source grain: Provider, survey/metric, year/cohort and other governed dimensions. Do not emit an aggregate Provider outcome as though it were a Course-specific result.

## 10. PRISMS student-flow contract direction

PRISMS observations must retain period, geography, sector, study-area and suppression semantics. Do not synthesize Provider/Course keys when source grain is aggregate.

## 11. Completeness/readiness fields

No generic `complete=true` field should be treated as truth or approval.

If Zoho needs operational quality signals, expose them with an explicit namespace/classification, for example:

- `admin_readiness.registration_present`
- `admin_readiness.fee_present`
- `admin_readiness.intake_present`
- `admin_readiness.english_present`
- `admin_readiness.display_score`

The current display score is derived and must be labelled as such. Publication/Search status must be separate fields.

## 12. Evidence exposure

Default Zoho payloads should expose only curated evidence references needed for audit/support. Do not expose private Storage paths or internal service metadata by default.

Recommended audit object:

- `source_key`
- `source_label`
- `source_url` where safe/public
- `captured_at`
- `source_snapshot_at`
- `last_verified_at`
- `evidence_ref`
- optional `content_hash` for audit-capable integrations

## 13. Admission status

This v1.0 document defines semantics; it does **not** admit these fields to Zoho or Website publication automatically.

Each consumer admission must confirm:

- field semantics are accepted;
- cardinality is supported downstream;
- null/zero/suppression behaviour is preserved;
- evidence exposure is appropriate;
- backward compatibility/versioning is defined;
- UAT confirms no internal schema leakage.

## 14. Versioning

Consumer-breaking semantic changes require a new contract version and Change Control record. Internal implementation changes that preserve the contract may remain within the same major contract version but must still be traceable when material.
