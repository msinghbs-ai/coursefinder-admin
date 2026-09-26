# CourseFinder Attribute & Admission Register v1.0

**Status:** CURRENT  
**Date:** 26 September 2026  
**Change control:** CF-CHG-20260915-247  
**Purpose:** one definition per course attribute: where it comes from, how it is admitted, who can correct it, how consumers receive it, and how complete it is. Coverage is measured from the consumer search document (what the website, Wix and Zoho APIs return).

## How to read this register
- **Authority:** the layer that owns the value. L1 = regulatory or statistical register; L2 = provider website, fetched and extracted deterministically; L3 = AI check of L2 evidence; L4 = a person.
- **Admission:** the rule that must pass before a value reaches the catalogue and search.
- **Correction:** the Layer 4 path a person uses to fix or supply the value.
- A value is only visible to consumers once admitted; everything unadmitted stays in the pipeline with its evidence.

## Course attributes

| # | Attribute | Consumer field | Authority | Source and fetch | Admission rule | Correction (L4) | Refresh | AU | NZ | Gap / next action |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Identity (code, title, provider) | course_code, course_title, provider_name | L1 | CRICOS (AU), NZQA (NZ) register files | Register record, identifier-first reconciliation | Title and code via L4 overrides | Per register schedule | 100% | 100% | None |
| 2 | Study level | study_level_code | L1 | Register level, mapped to CourseFinder levels | Deterministic mapping | None needed | With register | 100% | 95% | NZ unmapped levels |
| 3 | Field of study | primary_field_code | L1 | CRICOS field of education | Deterministic mapping | None | With register | 100% | 0% | NZ baseline accepted (Decision 143) |
| 4 | Locations | subdivision_codes | L1 | CRICOS course locations | Register record | Campus fields via L4 | With register | 99.9% | 0% | NZ baseline accepted (Decision 143) |
| 5 | Delivery mode | delivery_modes | L1 | CRICOS | Register record | delivery_mode via L4 | With register | 99.9% | 0% | NZ baseline accepted (Decision 143) |
| 6 | Duration | (course detail) | L1 | CRICOS weeks | Register record | duration via L4 | With register | Held | — | Not in search document |
| 7 | Registered tuition, non-tuition, total cost | regulatory_tuition_* | L1 | CRICOS registered costs | Register record; total course basis | None (regulatory) | With register | 99.3% | 0% | NZ has no equivalent register; keep "not applicable" |
| 8 | Provider current tuition | provider_annual_tuition_* | L2 → L3 or provider rule → L4 | Provider course page | Exact amount, audience, basis, year rule (Decisions 95–97, 106, 131, 132) | Tuition review, Edit and approve | L2 wave + 15-min rule admission | 1.5% | 0% | Per-provider qualification (Decision 141); L3 AI paused (Decision 125) |
| 9 | Intakes | intake_options, earliest_intake_date | L2 | Provider course page | Deterministic extraction with evidence | Being added (Decision 142) | L2 wave | 1.8% | 0% | Per-provider qualification (Decision 141) |
| 10 | English requirements | english_requirement_options | L2 | Provider course page | Deterministic extraction with evidence | Being added (Decision 142) | L2 wave | 2.0% | 0% | Per-provider qualification (Decision 141) |
| 11 | Official course link | official_course_url | L2 → L4 | Provider site discovery | Discovery match; reviewer source for human links (Decision 111) | Course link review | L2 wave | 2.0% | 0% | Per-provider qualification (Decision 141) |
| 12 | Course description | description | L2 | Admitted official course page only | Provider overview text, 200–1,000 characters, no fees, dates or navigation; no AI rewriting; shown with attribution (Decision 140) | course_description via L4 | With the course link | 0% | 0% | Being built; grows with official links |
| 13 | Scholarships | scholarship_options | L2 + AI → L4 | Provider scholarship pages | Provider page, international, award stated, evidence, at least one course, verified within 12 months; published by a person in batches (Decision 139) | Scholarship scope review | Scholarship runtime | 0% exposed | 0% | 57 ready to publish; 173 need award value or course links |
| 14 | Publication status | publication_status | L4 | Publication control | Pilot: consumer APIs return all records (intended). Production: publication rule and gate (Decision 138) | Publication control | On decision | 0 published | 0 | Production plan: publish by rule, then enforce the gate |

## Provider-level context (not course attributes)

| Dataset | Authority | Source | Editions held | Consumer exposure | Gap |
|---|---|---|---|---|---|
| QILT (4 surveys) | L1 statistics | Regulatory URL per survey and year | 1 each | Provider context | Move to stable publisher page and multi-year editions (Decision 134) |
| PRISMS | L1 statistics | Regulatory URL | 1 | Provider context | As above |
| QS rankings | L1 statistics | Licensed file upload | 2021–2027 (2024 and 2025 duplicated) | Rankings | Merge duplicates |
| THE rankings | L1 statistics | Licensed file upload | 2025, 2026, "2015" | Rankings | Apply 2019–2024; check the "2015" edition |
| ARWU, University Diversity Index | L1 statistics | Planned | None | None | Planned (Decision 135) |

## Rules
- Every attribute has exactly one authority layer; lower layers may only propose values to it.
- Each attribute must have an admission rule and, unless it is regulatory, a Layer 4 correction path.
- A new attribute is added here, with its rule and correction path, before it is exposed to consumers.