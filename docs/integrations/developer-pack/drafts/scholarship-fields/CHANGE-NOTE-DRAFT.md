# Website API v2: new scholarship fields (DRAFT developer communication)

**Status:** DRAFT, not issued. The fields are not live. Prepared 12 Nov 2026 under the Platform Admin's approval of 12 Nov 2026 20:19. Release is held under the standing rule of 12 Nov 2026 11:50 until this note is issued and the release is authorised (Pilot #1077; gate `api.v2_scholarship_fields_released`). On release, re-measure the counts below live, fold this note into the next guide issue (section 7.5 and section 13), and rebuild the OpenAPI file and Postman collection.

## What changes

Each scholarship (`scholarships` items and `scholarship`) gains the fields below. Nothing existing changes: no key is renamed, removed or retyped, and filters, sorting and paging are unchanged. `null` means not held, and an empty list means none held.

| Field | Type | Meaning |
|---|---|---|
| `description` | string or null | The scholarship description. It was already on `scholarship`; it now also appears on `scholarships` items. |
| `award_type` | string or null | `scholarship`, `bursary`, `tuition_waiver`, `fee_discount`, `research_funding`, `grant`, `stipend` or `other`. |
| `sponsor` | string or null | The funding body when the source names one (for example a foundation or a government council). |
| `programme` | string or null | The umbrella programme the award belongs to. |
| `award_code` | string or null | The provider's own code for the award. |
| `benefits[]` | list | Each benefit: `type` (`tuition_fees`, `fixed_amount`, `stipend`, `living_expenses`, `accommodation`, `travel`, `overseas_student_health_cover`, `in_kind`, `other`), `amount`, `currency`, `percentage` and `is_maximum`. |
| `application` | object | `method` (`separate_application`, `automatic_consideration`, `nomination` or null), `url` (the official application address, if printed) and `rolling` (true when applications are accepted all year). |
| `award_duration` | object or null | `value` and `unit` (`years`, `semesters`, `trimesters`, `months`, `program`). |
| `academic_year` | number or null | The funding round's academic year. |
| `nationality_eligibility_status` | string | `restricted` (the source names eligible or excluded countries or regions), `unrestricted` (the source says any nationality may apply), `under_review` or `unknown`. An empty `citizenship_eligibility` list is never `unrestricted`. |
| `excluded_nationality_codes[]` | list | ISO country codes the source names as not eligible. |
| `nationality_regions[]` | list | Regions as the source names them, never expanded into countries. |

## How to use them
- **Nationality.** Show `citizenship_eligibility` as before. Use `nationality_eligibility_status` to decide the wording: `restricted` names the countries, and `unknown` says the source does not say. Do not treat an empty list as open to everyone.
- **Benefits.** Show `benefits[]` beside the existing `amount_*` fields. When both are present, `benefits[]` is the fuller list, for example a stipend plus a tuition offset.
- **How to apply.** Use `application.method`. `automatic_consideration` (the existing field) stays as it is.

## Coverage on 12 Nov 2026 (dry run, 1,202 published scholarships; to re-measure at release)

| Field | Held for |
|---|---|
| `award_type` | 944 |
| `benefits[]` | 1,006 |
| `sponsor` | 481 |
| Nationality status | 154 restricted, 1,048 unknown |
| `description` | 813 (growing as stored pages are read) |

`academic_year` and `award_code` are held for only a few records so far.
