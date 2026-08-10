# Coursefinder Architecture v2.7 — Global Reference, Seed Data & Search Foundation

Status: **Architecture/research only — no application or database changes in this version.**

Date: 2026-08-10

## 1. Objective

Future-proof Coursefinder for a staged destination rollout:

1. Oceania first
2. Americas next
3. Europe after that

The design must support fast website search, deterministic filtering, institution groups such as Australia's Group of Eight, rankings, scholarships, semantic search with pgvector, and multiple regulatory/provider sources without forcing those concepts into generic PIM attributes.

## 2. Critical modelling rule

Do **not** model these as the same thing:

- institution membership groups (Go8, Russell Group, U15, AAU, LERU)
- university rankings
- geographic regions
- regulatory classifications
- editorial/search collections
- PIM categories
- provider custom attributes

They have different provenance, lifecycle and search behaviour.

Recommended model layers:

```text
Geography / jurisdiction
  ↓
Canonical Institution / Provider
  ├─ External identifiers
  ├─ Regulatory classifications
  ├─ Institution group memberships
  ├─ Rankings (source + year + subject)
  ├─ PIM categories / attributes
  └─ Courses
       ├─ categories / family / attributes
       ├─ completeness
       ├─ scholarships
       └─ search projection / pgvector
```

## 3. Institution groups — Go8 and global equivalents

### Recommended concept: Institution Collections

A Go8-style grouping is not a boolean provider attribute such as `is_go8`.

Use a governed collection plus time-aware membership:

### `institution_collections`

Recommended fields:

- `id`
- `code` — `GO8_AU`, `RUSSELL_GROUP_UK`, `U15_CA`, `AAU_NA`, `LERU_EU`
- `name`
- `collection_type`
- `scope_type` — country / region / global
- `country_code` nullable
- `region_code` nullable
- `description`
- `official_url`
- `source_id`
- `is_authoritative_membership`
- `status`
- `valid_from`
- `valid_to`
- timestamps

Collection types:

- `research_university_group`
- `university_association`
- `regulatory_group`
- `accreditation_group`
- `editorial_collection`
- `marketing_collection`

### `institution_collection_memberships`

- `collection_id`
- `provider_id`
- `membership_status`
- `valid_from`
- `valid_to`
- `source_id`
- `evidence_id`
- `verified_at`

This lets a university join/leave/change membership without rewriting the provider record.

### Recommended initial authoritative collections

Oceania:
- Group of Eight (Australia)

Americas:
- U15 Canada
- Association of American Universities (AAU)

Europe:
- Russell Group
- League of European Research Universities (LERU)

Add other official associations only where they materially help discovery or matching. Do not seed hundreds of arbitrary 'prestige' groups.

## 4. Rankings must be separate from groups

A membership such as Go8 is stable organisational membership. A ranking changes by year, provider and often subject.

Recommended tables:

### `ranking_sources`

- code
- name
- ranking_type — global / subject / country
- provider_name
- licence_notes
- source_url
- status

Potential sources if licensed/permitted:
- QS
- Times Higher Education
- ARWU
- U.S. News
- internally calculated Coursefinder score / meta-ranking

### `institution_ranking_results`

- provider_id
- ranking_source_id
- ranking_year
- subject_code nullable
- rank_exact nullable
- rank_band_min nullable
- rank_band_max nullable
- percentile nullable
- score nullable
- source_id/evidence
- retrieved_at

Do not store a permanent provider attribute such as `world_rank=23`.

### Search treatment

Rankings are deterministic structured features for filtering, sorting and scoring. They are not primary pgvector content.

Examples:

- `Go8 only`
- `Top 100 QS`
- `Top 10% Coursefinder meta-ranking`
- `AAU member`
- `Russell Group`

These should be resolved before/alongside vector retrieval, not by hoping the embedding understands prestige text.

## 5. Country and geography seed data

Current live database state observed at V2.7 review:

- `ref_countries`: 7 rows
- `providers`: 522 rows
- provider distribution includes GB 221, DE 213, AU 56, NZ 8, US 8, CA 8, IE 8
- `ref_countries` currently contains: `country_code`, `name`, `currency_code`, `register_name`, `register_url`, `adapter_key`

This current table mixes geography with integration configuration. V2.7 recommends separating those concerns in the next schema proposal.

### Global geography seed

Seed once from stable standards:

#### Countries
Use ISO 3166-1 and UN M49-derived geography:

- ISO alpha-2
- ISO alpha-3
- M49 numeric code
- canonical short name
- region
- sub-region
- intermediate region where applicable
- active/former status

#### Subdivisions
Use ISO 3166-2 where useful for destination search:

- states
- provinces
- territories
- regions

Examples:
- AU-VIC
- AU-NSW
- US-CA
- CA-ON
- GB-ENG

Do not embed city/state strings as the only representation. Preserve structured geographic IDs/codes for fast filtering.

### Rollout flags

Country reference data should be global even if catalogue ingestion is staged.

Add conceptual rollout metadata such as:

- `catalogue_status`: unsupported / seed_only / onboarding / active / paused
- `student_search_enabled`
- `provider_ingestion_enabled`
- `course_ingestion_enabled`
- `scholarship_ingestion_enabled`
- default currency
- default locale

This avoids needing to add a country later just because market expansion starts.

## 6. Institution seed strategy

Do not use one global institution list as the sole canonical truth.

Recommended hierarchy of trust:

```text
National/regional official regulator/register
        ↓
Canonical Coursefinder provider
        ↓
Global identifier crosswalk (ROR where applicable)
        ↓
University group / ranking / editorial metadata
```

### Why ROR should be a crosswalk, not the sole provider registry

ROR is global, open and strong for research organisations, with persistent IDs, aliases, locations and identifier crosswalks. However, its scope is research organisations; many non-research education providers, pathway colleges, VET providers and language schools may be outside its intended scope.

Therefore:

- use ROR IDs when a Coursefinder provider matches a ROR organisation;
- retain national regulator/provider identifiers as authoritative jurisdictional IDs;
- do not reject a legitimate education provider solely because it lacks a ROR ID.

### Recommended `provider_external_identifiers`

- provider_id
- scheme
- value
- issuing_authority
- country_code
- source_id
- valid_from/to

Examples:

Australia:
- CRICOS provider code
- TEQSA provider ID
- ROR ID

New Zealand:
- NZQA / Ministry provider code
- ROR ID where applicable

United States:
- UNITID / College Scorecard/IPEDS identifier
- ROR ID

Future Europe:
- national regulator IDs
- ROR ID
- ETER/other licensed/open identifiers where appropriate

## 7. Recommended seed data by rollout phase

### Phase A — Oceania

#### Geography
- Australia
- New Zealand
- Pacific destinations can exist in global reference data but remain `seed_only` until supported.

#### Australia institution seed

Authoritative hierarchy:
1. CRICOS for international-student provider/course eligibility
2. TEQSA for higher-education provider registration/category
3. ROR crosswalk for research-university identity where available
4. official institution website for enrichment

Initial institution collection:
- Group of Eight

Useful provider structured attributes/classifications:
- university / university college / institute / VET / ELICOS / pathway etc.
- public/private where reliably sourced
- self-accrediting authority where relevant
- CRICOS active status

#### New Zealand institution seed

Authoritative hierarchy:
1. NZQA/provider register and programme data where applicable
2. relevant university/public-sector official sources
3. ROR crosswalk
4. official institution website

Search-useful classifications:
- university
- institute/polytechnic
- wānanga
- PTE
- international Code of Practice signatory

### Phase B — Americas

#### United States
Use official U.S. Department of Education datasets such as College Scorecard/IPEDS-style institution identifiers for canonical crosswalk and structured outcomes where licences/terms permit.

Initial collection:
- AAU

Do not use `Ivy League` as a quality synonym. If added, store it as its actual membership/association type rather than an editorial 'best university' flag.

#### Canada
Canonical institutions should come from authoritative provincial/national directory sources selected during country-adapter design, with ROR crosswalk.

Initial collection:
- U15 Canada

### Phase C — Europe

Country-specific regulator adapters remain authoritative. ROR provides cross-country identity reconciliation.

Initial collections where relevant:
- Russell Group
- LERU

Europe needs careful handling because one continent contains many national regulatory systems; do not create a single generic 'European university ID' unless sourced from a reliable interoperable dataset.

## 8. What similar platforms reveal

### Course Seeker

Course Seeker is useful as the transparency/reference pattern:
- institution and course data is collected/published in a nationally consistent form;
- the platform filters structured fields such as location, study mode, duration, study area and admissions criteria;
- results are relevance-driven rather than pay-to-rank;
- course/provider data comes directly from institutions/TAC processes.

Lesson for Coursefinder:
- canonical structured fields should drive filters;
- semantic search should augment, not replace, comparable structured data;
- provenance/source should be visible.

### IDP

IDP exposes a broad international filter set including:
- course subject
- study level
- destination
- institution
- budget
- study mode
- duration
- IELTS
- scholarships
- internships

Lesson:
- most high-value student constraints are structured facets, not vector dimensions.

### ApplyBoard

ApplyBoard exposes structured filters including:
- destination down to region/city
- institution
- programme level
- field of study
- intakes
- tuition
- scholarships/program tags

It also separates discovery filters from a custom ranking/matching layer.

Lesson:
- Coursefinder needs a deterministic eligibility/filter stage and a separate relevance/matching stage.

### Studyportals

Studyportals uses:
- field of study
- location
- university
- tuition
- duration
- format/attendance
- degree type
- special programmes
- rankings

It also maintains a meta-ranking by combining multiple external rankings and uses custom institution groupings such as Go8 and Russell Group in analysis.

Lesson:
- provider group membership and ranking are valuable discovery dimensions but should remain separate data products;
- a Coursefinder meta-ranking could be created later, but only after ranking-data licensing/provenance is clear.

## 9. Fast search architecture for website integration

The website search should not query the full PIM joins for every keystroke.

Recommended architecture:

```text
Canonical PIM tables
     ↓ async projection
Search document / search index table
     ├─ deterministic filter columns
     ├─ category IDs
     ├─ institution collection IDs
     ├─ ranking bands/derived sortable features
     ├─ scholarship availability summary
     ├─ publication/freshness flags
     ├─ text search vector
     └─ pgvector embedding
           ↓
Search RPC/API
           ↓
Website / Zoho / counsellor
```

### Search document should denormalise only read-optimised data

Recommended indexed fields:

Identity:
- course_id
- provider_id
- canonical title
- provider name

Geography:
- country
- subdivision
- city/campus

Academic:
- family
- study level
- field/category IDs
- delivery mode

Admissions:
- IELTS/PTE/etc. structured thresholds
- admission tags

Commercial/student intent:
- fee/currency
- duration
- intakes
- scholarship available

Institution reference:
- collection codes (`GO8_AU`, `U15_CA`, etc.)
- ranking bands / selected ranking metrics

Quality:
- completeness
- evidence freshness
- publication status

Semantic:
- controlled search text
- embedding
- embedding/search-profile version

## 10. pgvector strategy

### Principle

Use pgvector for meaning; use PostgreSQL indexes for facts.

Student query example:

> "top research university in Australia for AI under 50k with scholarship, IELTS 6.5"

Do not ask the embedding to solve all of that.

Recommended execution:

1. parse/recognise structured constraints:
   - destination = AU
   - institution collection/prestige intent = research-intensive / Go8 may be a possible mapped intent
   - max tuition = 50k
   - scholarship = required
   - IELTS <= 6.5
2. apply deterministic indexed filters
3. run vector similarity for semantic intent `AI`
4. apply relevance boosts, not hard filters, for softer signals such as ranking or institution group unless user explicitly asked for them
5. return explanations/facets

### Provider-group vectors

Do not embed `Go8=true` as the only way to discover Go8 institutions.

Store membership as deterministic metadata. Optionally include human-readable group names in provider/course search text to improve natural-language recall when a student literally types "Group of Eight" or "Russell Group".

### Ranking vectors

Do not embed raw ranking numbers as semantic text for relevance.

Use rankings as structured features/boosts:
- exact filter
- band filter
- sort
- relevance boost

### Hybrid retrieval

Future target:

`structured SQL filtering + PostgreSQL FTS/trigram + pgvector + controlled ranking/quality boosts`

The website API should return results quickly from the projection, then hydrate detailed course/scholarship content only for the selected result/detail page.

## 11. Scholarship interaction with institution groups and rankings

Scholarships should not be inferred merely because a provider is Go8/top-ranked.

Scholarship availability remains based on:
- explicit course links
- provider/category/study-level scopes
- scholarship criteria
- active academic year/status
- coverage verification

However, search can combine them:

Example filters:
- Go8 university
- active scholarship
- Engineering category
- Bachelor
- max fee

These are all deterministic joins/projected features before vector scoring.

## 12. Seed taxonomy proposal

### Seed globally from day one

Geography:
- countries
- ISO alpha-2/3
- UN M49 region/subregion
- major subdivisions for enabled destinations

PIM/reference:
- education/study levels
- delivery modes
- attendance/study load
- currencies
- languages
- standard English tests
- application/intake month/term concepts
- provider lifecycle/publication states
- evidence/source types
- collection types
- ranking source placeholders (disabled until data terms confirmed)

Categories:
- global Field of Study taxonomy
- Scholarship Type taxonomy
- Scholarship Audience taxonomy

Do not seed university names as static application code constants.

### Seed per active destination

- canonical providers from official registers
- regulator IDs
- campuses/subdivisions
- provider classifications
- official group memberships
- country-specific qualification/study-level mappings
- country-specific regulatory metadata

### Enrich after provider seed

- ROR crosswalk
- official aliases/acronyms
- websites/domains
- institution collection membership
- rankings if permitted
- provider description/logo/media via controlled sources

## 13. Recommended new menu implications

V2.6 menu additions/refinements for this model:

### Catalogue
- Providers
- Courses
- Scholarships
- **Institution Collections**
- Categories
- Associations

### Reference Data
Recommended new top-level area for `platform_admin` / selected `pim_admin`:
- Countries & Regions
- Subdivisions
- Study Levels
- Fields of Study
- Provider Types
- Institution Collections
- Ranking Sources
- Currencies
- Languages
- English Tests

### Search & Matching
- Search Profiles
- Search Projection Health
- Vector Indexes
- Ranking/Boost Rules
- Scholarship Matcher
- Search Diagnostics

This keeps reference seed data separate from editable catalogue records.

## 14. Recommended decisions before DB design

1. Add **Reference Data** as a first-class super-menu area.
2. Add **Institution Collections** instead of provider booleans such as `is_go8`.
3. Separate **Rankings** from collections and PIM attributes.
4. Use official country/regulator data as canonical seed and ROR as global identity crosswalk.
5. Seed global geography immediately, but activate catalogue countries in stages.
6. Build a dedicated read-optimised Search Projection rather than query full PIM joins from the website.
7. Use hybrid retrieval: SQL facets + FTS/trigram + pgvector + explicit scoring/boost rules.
8. Never make arbitrary custom attributes automatically part of pgvector; Search Profiles decide inclusion.
9. Store ranking/group metadata in the search projection for fast filtering/boosting.
10. Keep scholarships deterministic and first-class, then combine them with course retrieval.
11. Before importing rankings, review licensing/redistribution rights for each ranking provider.
12. Next schema design should separate the current `ref_countries` geography fields from register/adapter configuration.

## 15. Proposed implementation sequence after architecture approval

1. approve Reference Data menu and terminology;
2. approve geography/country reference schema;
3. approve institution identifiers + collection membership model;
4. approve ranking model;
5. approve global Field of Study taxonomy;
6. approve search projection/Search Profile design;
7. draft Database Schema v2.7 with migration impact against current V2.1/V2.6 structures;
8. seed Oceania authoritative data;
9. validate website search performance/quality before Americas onboarding;
10. expand country adapters without changing core search/PIM structures.
