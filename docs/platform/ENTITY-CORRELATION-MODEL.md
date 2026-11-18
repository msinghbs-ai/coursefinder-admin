# How the data connects: destinations, providers, courses, rules and outcomes

**Version:** 1.0, 18 Nov 2026 (S1-RM-Design; Platform Admin 18 Nov 2026 14:23). **For:** the website (Wix) and Zoho developers, the Platform Admin and operators. **Source of truth:** Pilot `src/guide/entityModel.js` (shown on Guides › Platform guide › How the data connects, v2.16.42); this page is rendered from it. Every path is a live, undeprecated Website API v3 path in `ref.api_field_dictionary` (checked 18 Nov 2026).

## The chain

Destination (country, locality) → Provider (campuses, accreditations) → Course (study load, empty reason, entry requirements, scholarships) → Study rules and career outcomes.

### 1. Destination → Provider

**Joined on:** country_code, then locality_id.

A destination is a country (country_code) and its localities (locality_id). A provider belongs to a country, and each campus is placed in a locality by its postcode once that locality is approved.

- `destination: localities[].country_code, localities[].locality_id`
- `provider: item.country_code, item.campuses[].locality.locality_id, item.campuses[].is_primary`

### 2. Provider → Course

**Joined on:** the course's provider and campuses.

A course carries its provider and the campuses it runs at, with the same locality. Use the primary campus when one place is needed. Accreditations (AACSB, EQUIS, AMBA and national quality ratings) belong to the provider and are repeated on every course.

- `course: item.country_code, item.campuses[].locality.locality_id, item.campuses[].is_primary, item.provider.accreditations[].body_code`
- `provider: item.accreditations[].body_code`

### 3. Course → Course facts

**Joined on:** the course item.

Study load (full-time, part-time or both) and, for a course with no campus, why (empty_reason_code). Entry requirements (AER) are the course's own, with the basis they rest on. Scholarships linked to the course come with it.

- `course: item.study_load, item.empty_reason_code, item.entry_requirements.summary, item.entry_requirements.basis, item.scholarships[].name`
- `search: items[].study_load, items[].entry_requirements.summary`

### 4. Course → Study rules & career outcomes

**Joined on:** country_code (rules), country_code and locality_id (outcomes).

Visa, work and study rules apply to the whole country: join on the course's country_code. Career outcomes are by country and, where published, by locality: join on country_code and the campus locality_id. City figures (population, climate, living costs) are on the locality.

- `destination: study_rules[].country_code, study_rules[].rule_category, study_rules[].title`
- `destination: career_outcomes[].country_code, career_outcomes[].locality_id, career_outcomes[].occupation_scheme, career_outcomes[].occupation_code`
- `destination: localities[].metrics[].category, localities[].metrics[].key, localities[].metrics[].value, localities[].metrics[].unit`

## Rules for joining

- Join on the codes, never on names: country_code (ISO 3166-1 alpha-2) and locality_id.
- A value that is null is not held; do not read it as zero, none or not offered.
- Destination figures, rules and outcomes reach the API only from a published edition with approved terms; their attribution must be shown where they are shown.
- Climate figures are long-term averages, not forecasts. The icon rule (sunny, partly cloudy, rain, heavy rain, storm, snow, wind) is in the developer guide and src/lib/climate-icons.js.

## Climate icons

Climate figures (`localities[].metrics[]` with `category` = `climate`) are long-term averages, not forecasts. PIM Admin draws an icon by this rule (Pilot `src/lib/climate-icons.js`, lucide icons, ISC licence); the website may use any icon set with the same rule. First match wins:

| The metric key | Icon |
|---|---|
| contains storm or thunder | Storm |
| contains rain (annual rainfall) | Rain; Heavy rain at or above 1500 mm a year |
| contains wind | Wind |
| contains snow | Snow |
| a mean minimum temperature (`_min_c`) | Snow at or below 2 °C; otherwise Partly cloudy |
| a mean maximum or other temperature | Sunny |

Keys live on 18 Nov 2026 (BOM climate normals, eight capital cities, draft until approved): `climate_annual_rainfall_mm`, `climate_summer_mean_max_c`, `climate_summer_mean_min_c`, `climate_winter_mean_max_c`, `climate_winter_mean_min_c`. Show the attribution with the figure.
