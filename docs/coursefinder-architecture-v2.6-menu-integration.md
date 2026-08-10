# Coursefinder Architecture v2.6 — Menu, Integration & Catalogue Model

Status: **Architecture only — no code or database migration in this version.**

Date: 2026-08-10

## 1. Objective

Finalise the production PIM information architecture before further implementation.

The production application remains the **UnoPIM-inspired admin experience**. The menu is designed first for `platform_admin` as the complete super-menu; lower roles receive a reduced navigation tree and reduced actions.

Key goals:

- make Courses behave like PIM products;
- separate **Family**, **Category**, **Attribute** and **Channel/locale** responsibilities;
- make Layer 2 scraper and Layer 3 LLM configuration provider-agnostic and future-proof;
- keep pipeline execution, job history, evidence and review fully traceable;
- keep scholarship data first-class and compatible with student matching;
- ensure pgvector is generated from governed searchable projections rather than raw/uncontrolled fields;
- keep Zoho and future consumers behind approved catalogue APIs/views.

## 2. Design principles

UnoPIM's model is the reference pattern:

`Attribute -> Attribute Group -> Attribute Family -> Product`

For Coursefinder:

`Attribute -> Attribute Group -> Attribute Family -> Course / Provider / Scholarship / Student Profile`

A Family controls which attribute groups and fields are expected for an entity. Categories are a separate hierarchical classification system. Searchability/filterability belongs to the attribute definition, not to category membership.

### 2.1 Separation of concerns

- **Family** = schema/shape of the entity.
- **Attribute Group** = edit-screen organisation.
- **Attribute Definition** = data type, validation, filterability, searchability, localisation/channel behaviour.
- **Attribute Value** = actual canonical/enriched value.
- **Category** = hierarchical classification/taxonomy.
- **Association** = relationship to another canonical entity.
- **Completeness Profile** = which fields must be present for a given family/channel/publication state.
- **Search Projection** = governed set of values used by full-text/pgvector search.

UnoPIM similarly uses Attribute Families to decide which fields appear on a product and Attribute Groups to organise those fields; filterable attributes can be exposed to the product listing. Categories form a separate hierarchical catalogue structure.

## 3. Platform Admin super-menu

The complete production navigation for `platform_admin` should be:

### 3.1 Dashboard

**Dashboard**

Purpose:
- overall catalogue health;
- provider/course/scholarship counts;
- completeness by entity/family/country;
- Layer 1–4 activity summary;
- open review and stale evidence counts;
- failed jobs / configuration warnings;
- vector indexing freshness;
- upcoming scholarship review/expiry.

Dashboard is monitoring only; it should not become a second configuration screen.

---

### 3.2 Catalogue

**Catalogue**
- Providers
- Courses
- Scholarships
- Student Profiles
- Categories
- Associations

#### Providers
Canonical institutions/provider entities.

Provider edit sections are driven by the provider Attribute Family.

Provider-specific integration configuration should be linked from the provider record but physically governed under **Integrations / Pipeline Configuration**.

#### Courses
Courses are the Coursefinder equivalent of UnoPIM Products.

Course creation/edit flow:
1. choose Provider;
2. choose Course Family;
3. create canonical identity;
4. apply family attribute groups;
5. assign one or more Categories;
6. populate canonical values;
7. display evidence/provenance per value;
8. calculate completeness;
9. generate/update search projection and embeddings when publishable searchable content changes.

#### Scholarships
First-class PIM records, not generic Course attributes.

Scholarship records have:
- Scholarship Family;
- categories;
- scopes;
- award tiers;
- eligibility criteria;
- evidence;
- academic year/history;
- provider/course associations.

#### Student Profiles
Administrative/test profiles used for matcher UAT and future integration testing. This should not become the primary student CRM.

#### Categories
Hierarchical classification shared across the PIM.

Recommended roots:
- Course Subject / Field of Study
- Study Level
- Delivery / Mode
- Provider Classification
- Scholarship Type
- Scholarship Audience / Eligibility Segment
- Geography / Region
- Marketing / Featured Collections

Not every classification must be a Category. Stable single-valued facts such as `study_level`, `delivery_mode`, `country_code` may remain typed/filterable attributes. Categories are best for managed hierarchy, many-to-many assignment, curated discovery and navigation.

#### Associations
Entity-to-entity relationships:
- related courses;
- pathway courses;
- articulation/credit relationships;
- provider-campus relationships;
- course-scholarship relationships;
- successor/replacement course;
- related scholarship.

Associations should be governed and typed rather than stored as generic JSON links.

---

### 3.3 PIM Model

**PIM Model**
- Attribute Families
- Attribute Groups
- Attributes
- Attribute Options
- Attribute Aliases
- Completeness Profiles
- Category Fields

#### Attribute Families
Families define the editable shape.

Initial recommended Course families:
- Higher Education Course
- VET / Vocational Course
- English Language / ELICOS
- Foundation / Pathway
- Research Program
- Short Course / Microcredential

Do not create a family per university. University-specific requirements are handled through globally governed attributes + aliases, unless the data model is genuinely structurally different.

Initial Scholarship families:
- Merit Scholarship
- International Scholarship
- Equity / Access Scholarship
- Research Scholarship
- Faculty / Course-specific Scholarship
- Government / External Scholarship

Family assignment affects:
- edit groups;
- required attributes;
- completeness calculation;
- search projection recipe;
- validation rules;
- optionally allowed category roots.

#### Attribute Groups
Examples for Courses:
- General
- Regulatory
- Academic Structure
- Admissions
- English Requirements
- Fees
- Intakes
- Delivery
- Campuses
- Scholarships
- Careers / Outcomes
- SEO / Content
- Evidence / Provenance

#### Attributes
Each attribute should explicitly declare:
- entity type;
- data type;
- required/unique;
- filterable;
- searchable;
- vector-included;
- vector weight/profile role;
- localisable;
- channel-scoped;
- multivalue;
- controlled vocabulary/options;
- validation;
- sensitivity/publication behaviour.

`is_searchable` and `include_in_vector` should be separate concepts.

Example:
- CRICOS code: searchable exact text, but low/no semantic-vector weight.
- course title: searchable and vector-included, high weight.
- course description: vector-included, high weight.
- fee amount: filterable, not semantically embedded.
- IELTS score: filterable/rules data, not embedded as primary meaning.

#### Attribute Aliases
Maps provider wording to global canonical attributes.

Example:
- `Indicative annual tuition fee` -> `annual_tuition_fee`
- `English language entry requirements` -> `english_requirement_notes`

Aliases help Layer 2/3 extraction without creating a new PIM field for every university label.

#### Completeness Profiles
New architectural concept recommended for V2.6 implementation.

A completeness profile should be attached to:
- entity type;
- family;
- channel/publication target;
- optionally country/regulatory regime.

Example:
`Higher Education Course / Counsellor Channel / AU`
requires:
- title;
- provider;
- study level;
- duration;
- fee;
- intake;
- English requirement;
- official URL;
- registration/CRICOS where applicable;
- scholarship coverage status (available or verified-none).

This removes hard-coded completeness logic from UI code.

---

### 3.4 Data Quality

**Data Quality**
- Completeness
- Missing Attributes
- Scholarship Coverage
- Evidence Freshness
- Conflicts
- Duplicates
- Stale / Expiring Records

Purpose: separate data-quality management from catalogue editing.

#### Completeness
Filter by:
- entity type;
- family;
- category;
- provider;
- country;
- channel;
- missing field;
- minimum score;
- publication state.

Completeness should be derived from the relevant Completeness Profile.

#### Scholarship Coverage
Track whether a provider/course has:
- scholarship available;
- verified none;
- unknown;
- needs review.

`verified_none` is complete data and must not be treated as missing.

---

### 3.5 Enrichment & Pipeline

**Enrichment**
- Pipeline Overview
- Layer 1 — Regulatory
- Layer 2 — Acquisition
- Layer 3 — AI Enrichment
- Layer 4 — Human Review
- Jobs
- Schedules
- Evidence

This is the operational pipeline workspace.

#### Pipeline Overview
Shows the lifecycle and operational health only:

`L1 Canonical -> L2 Evidence -> L3 Enrichment -> L4 Review -> Publish/Search`

Should expose status, queue sizes, throughput, failures and freshness, not every configuration field.

#### Layer 1 — Regulatory
Configuration for canonical/official structured sources:
- CRICOS;
- future government/register connectors;
- source priority;
- update schedule;
- country;
- authoritative entity scope.

#### Layer 2 — Acquisition
Execution and acquisition policy.

Layer 2 should not be hard-coded to a single scraper.

It should reference a **Scraper Provider Profile** and a **Discovery/Acquisition Policy**.

#### Layer 3 — AI Enrichment
Execution and enrichment policy.

Layer 3 should not be hard-coded to one LLM vendor or one model.

It should reference an **LLM Provider**, **Model Profile**, **Prompt/Extraction Profile** and **Routing Policy**.

#### Layer 4 — Human Review
Queues and curation actions:
- low-confidence extraction;
- conflicts;
- unknown attributes;
- proposed attribute creation;
- duplicate candidates;
- scholarship scope/eligibility ambiguity;
- source changes;
- stale/expired records;
- Zoho suggestions.

#### Jobs
Universal job history across Layers 1–4 and system tasks.

Each job should identify:
- layer;
- job kind;
- integration/provider profile used;
- model/scraper version;
- scope;
- counts;
- cost/usage where relevant;
- started/completed;
- retry lineage;
- errors;
- evidence created;
- resulting review items.

#### Schedules
Separate schedule definitions from provider credentials/configuration.

Examples:
- CRICOS weekly;
- provider course discovery monthly;
- scholarship refresh fortnightly;
- stale evidence recheck;
- embedding backlog;
- review SLA reminders.

#### Evidence
Central evidence catalogue with private object access, retention, supersession and entity/value links.

---

### 3.6 Integrations

**Integrations**
- Overview
- Scrapers
- LLM Providers
- LLM Routers / Aggregators
- Regulatory Sources
- Consumer APIs
- Zoho
- Webhooks

This is intentionally separate from **Enrichment**.

- Integrations = capabilities/configuration.
- Enrichment = execution/operations.

#### Scrapers
Future-proof registry of acquisition adapters.

Examples:
- Scrape.do
- Cloudflare Browser Rendering
- Browserless / Playwright service
- direct HTTP fetch
- provider API adapter
- custom university connector

Each scraper profile should expose non-secret configuration only:
- code/name;
- adapter type;
- enabled;
- capabilities: HTTP, JS render, screenshot, PDF, proxy/geolocation;
- supported countries/domains;
- rate/concurrency defaults;
- timeout/retry;
- cost profile;
- secret reference name;
- health/status;
- priority/fallback order.

Secrets remain server-side.

#### LLM Providers
Registry of direct model providers:
- OpenAI;
- Anthropic;
- Google;
- future providers.

Configuration:
- adapter;
- endpoint class;
- supported capabilities;
- secret reference;
- health/status.

#### LLM Routers / Aggregators
Separate first-class integration type for:
- OpenRouter-style aggregators;
- AI gateways;
- internal routing/proxy layer;
- future multi-provider routing.

This avoids treating an aggregator as merely another model.

#### Model Profiles
Recommended child configuration under LLM Providers/Routers:
- logical purpose (`course_extraction`, `scholarship_extraction`, `classification`, `normalisation`, `embedding`);
- provider/router;
- model ID;
- temperature/structured-output settings;
- max tokens;
- cost limits;
- active version;
- fallback profile;
- allowed countries/provider families;
- test/production status.

#### Routing Policies
Example:
`scholarship_extraction_au_v1`
1. primary model profile A;
2. if provider error -> profile B;
3. if schema validation failure -> retry once;
4. if confidence below threshold -> Layer 4;
5. if cost ceiling exceeded -> stop/queue.

Routing policy belongs to Layer 3 pipeline configuration, while provider/model definitions live under Integrations.

---

### 3.7 Search & Matching

**Search & Matching**
- Search Profiles
- Vector Indexes
- Embedding Jobs
- Scholarship Matcher
- Search Diagnostics

This deserves its own admin area because pgvector is an output system, not the canonical PIM itself.

#### Search Profiles
Define how canonical PIM data becomes search documents.

Example: `student_course_search_v1`

High semantic weight:
- canonical title;
- field of study;
- course summary;
- careers/outcomes;
- admission notes;
- selected category labels.

Structured metadata/filter-only:
- provider;
- country;
- level;
- fee;
- duration;
- IELTS;
- delivery mode;
- intake;
- scholarship availability;
- family;
- category IDs.

The vector document should be generated from approved attributes according to the Search Profile.

#### Effect of Families on pgvector
Family controls which fields are available and therefore which search projection recipe is used.

Example:
- Higher Education Course vector can include careers, majors and admissions.
- ELICOS vector may emphasise English level, duration and delivery.
- Research Program vector may emphasise research area, supervisor/lab information and thesis focus.

Changing a Course Family or changing a vector-included attribute definition should mark the course embedding as stale and queue re-embedding.

#### Effect of Categories on pgvector
Categories should primarily be structured filters/boosting metadata.

Selected human-readable category labels can be included in the vector text where semantically helpful, but the category tree itself should not replace embeddings.

Example:
`Engineering > Civil Engineering > Structural Engineering`
can contribute semantic context, while category IDs remain deterministic filters.

#### Embedding versioning
Every embedding should be tied to:
- search profile version;
- embedding model profile;
- source content hash;
- generated timestamp;
- entity/family;
- dimensions.

A model/profile change does not mutate old embeddings in place without traceability; it queues a new index generation.

---

### 3.8 Scholarships and matching architecture

Scholarships remain a first-class catalogue entity.

Course Families and Categories affect scholarship matching differently:

#### Family
Scholarship eligibility should not generally depend directly on internal PIM Family names.

Families are administrative/schema constructs.

However, family may determine which matching attributes are available. Example: Research Programs can expose research-specific attributes needed by research scholarships.

#### Categories
Categories can participate in scope when they represent controlled academic domains.

Example scholarship scope:
- category: `Engineering` including descendants;
- study level: Bachelor;
- country eligibility: India/Nepal;
- international status: international;
- minimum WAM: 75.

The matcher should resolve category hierarchy deterministically before rules are evaluated.

#### Scholarship-course relationship model
Use three complementary mechanisms:
1. explicit `course_scholarships` links;
2. `scholarship_scopes` for broad rules/category/provider/level coverage;
3. structured `scholarship_criteria` for student eligibility.

Do not create thousands of explicit course links where a valid category/provider-wide scope can represent the rule accurately.

Scholarship availability should also be exposed as structured metadata to course search, but scholarship prose should not be merged indiscriminately into every course embedding.

Recommended search treatment:
- course embedding contains a short governed scholarship signal/summary at most;
- scholarship has its own embedding/search projection;
- course results can join ranked/matched scholarships after course retrieval.

This prevents scholarship text from dominating semantic course similarity.

---

### 3.9 Publishing & Channels

**Publishing**
- Channels
- Locales
- Publication Queue
- Consumer Views

Initial channels:
- Internal PIM
- Counsellor / Zoho
- Student/Public Search
- API

An attribute can be channel-scoped and a Completeness Profile can define what is required before an entity is publishable to that channel.

Example:
A course may be publishable internally at 55% completeness, but require 85% plus verified fee/intake/English/scholarship coverage before publication to the counsellor/student channel.

---

### 3.10 Administration

**Administration**
- Users
- Roles & Permissions
- Audit Log
- System Settings
- Feature Flags
- Maintenance

Only `platform_admin` should see the full Administration menu.

Database/maintenance/destructive actions should not be mixed into normal catalogue or pipeline screens.

## 4. Role-driven menu reduction

Start from the complete `platform_admin` menu and remove visibility/actions downward.

| Area | platform_admin | pim_admin | pipeline_operator | curator | counsellor | viewer |
|---|---|---|---|---|---|---|
| Dashboard | Full | Full | Ops | Quality | Limited | Read |
| Providers/Courses/Scholarships | Full CRUD | Full CRUD | Read | Read/Edit proposed | Read | Read |
| Student Profiles | Full | Manage test profiles | No | Read | Optional own workflow | No |
| Categories | Full | CRUD | Read | Read | Read | Read |
| Associations | Full | CRUD | Read | Suggest | Read | Read |
| Families/Groups/Attributes | Full | Full | Read | Suggest new attribute | No | Read metadata only |
| Completeness/Data Quality | Full | Full | Full | Full queues | Read relevant | Read |
| Layer 1–3 Execute | Full | Optional by permission | Full | No | No | No |
| Layer 1–3 Configuration | Full | Read or limited | Operational config only | No | No | No |
| Layer 4 Review | Full | Full | Read | Full | No | Read if needed |
| Jobs/Evidence | Full | Full | Full | Relevant | No | Read limited |
| Integrations | Full | Read/selected | Operational | No | No | No |
| Search/Vector config | Full | Selected | Embedding jobs only | No | No | No |
| Publishing/Channels | Full | Full | No | Suggest | No | Read |
| Users/Roles/System | Full | No | No | No | No | No |

Permissions should be action-based server-side, not only hidden navigation.

## 5. Proposed final `platform_admin` navigation tree

```text
Dashboard

Catalogue
  Providers
  Courses
  Scholarships
  Student Profiles
  Categories
  Associations

PIM Model
  Attribute Families
  Attribute Groups
  Attributes
  Attribute Options
  Attribute Aliases
  Completeness Profiles
  Category Fields

Data Quality
  Completeness
  Missing Attributes
  Scholarship Coverage
  Evidence Freshness
  Conflicts
  Duplicates
  Stale / Expiring

Enrichment
  Pipeline Overview
  Layer 1 - Regulatory
  Layer 2 - Acquisition
  Layer 3 - AI Enrichment
  Layer 4 - Human Review
  Jobs
  Schedules
  Evidence

Integrations
  Overview
  Scrapers
  LLM Providers
  LLM Routers / Aggregators
  Regulatory Sources
  Consumer APIs
  Zoho
  Webhooks

Search & Matching
  Search Profiles
  Vector Indexes
  Embedding Jobs
  Scholarship Matcher
  Search Diagnostics

Publishing
  Channels
  Locales
  Publication Queue
  Consumer Views

Administration
  Users
  Roles & Permissions
  Audit Log
  System Settings
  Feature Flags
  Maintenance
```

## 6. Recommended relationship architecture

```text
Provider
  └── Course
       ├── Attribute Family
       │    └── Attribute Groups
       │         └── Attribute Definitions
       │              └── Attribute Values
       ├── Categories
       ├── Associations
       ├── Evidence
       ├── Completeness Profile -> score/status
       ├── Search Profile -> search document -> pgvector
       └── Scholarship availability
            ├── explicit course links
            └── scope/category/provider rules

Scholarship
  ├── Scholarship Family
  ├── Categories
  ├── Award Tiers
  ├── Scopes
  ├── Criteria
  ├── Evidence
  └── Search Projection / optional vector

Student Profile
  └── Matcher
       ├── structured course filters
       ├── scholarship scopes
       └── scholarship criteria
```

## 7. Pipeline configuration architecture

### Layer 2

`Layer 2 Policy -> Scraper Profile -> Adapter -> Secret Reference`

A Layer 2 policy determines:
- discovery method;
- preferred scraper;
- fallback scraper(s);
- domain/provider matching;
- JS rendering rules;
- screenshot/PDF capture;
- rate/concurrency;
- evidence requirements;
- retry strategy;
- freshness/revisit period.

Provider overrides are allowed but should inherit from a global/default policy.

Example:

```text
AU Higher Education Default
  Primary: Direct HTTP
  Fallback 1: Scrape.do
  Fallback 2: Browser Rendering
  Capture: HTML + screenshot
  Retry: 2
  Revisit: 30 days

University X override
  Primary: Browser Rendering
  because: JS-only catalogue
```

### Layer 3

`Layer 3 Policy -> Extraction Profile -> Routing Policy -> Model Profile -> Provider/Router -> Secret Reference`

An extraction profile defines:
- entity type/family;
- attribute groups in scope;
- structured output schema;
- confidence rules;
- evidence citation requirements;
- prompt version;
- validator version;
- review threshold.

Routing policy determines which model/provider is selected and fallback behaviour.

This allows Coursefinder to add new LLMs/aggregators without rewriting the extraction pipeline.

## 8. Decisions recommended before implementation

1. Adopt the menu tree in Section 5 as the `platform_admin` baseline.
2. Treat Courses as PIM Products with one primary Attribute Family.
3. Keep Categories separate from Families.
4. Introduce Completeness Profiles rather than hard-coded completeness fields.
5. Introduce explicit Search Profiles and versioned embedding projections.
6. Separate Integrations configuration from Enrichment execution.
7. Make Scraper Profiles, LLM Providers, LLM Routers/Aggregators and Model Profiles independent registries.
8. Use policy inheritance for global -> country -> provider pipeline overrides.
9. Keep scholarships first-class; use category/provider/level scopes rather than brute-force links where possible.
10. Do not make arbitrary custom attributes automatically searchable/vectorised. PIM admin must explicitly mark them.
11. Treat vector regeneration as a derived job triggered by relevant canonical/search-profile changes.
12. Keep role enforcement server-side; menu visibility is convenience only.

## 9. Implementation order after architecture sign-off

No implementation is included in V2.6. Recommended next sequence:

1. confirm super-menu and terminology;
2. confirm Course/Scholarship families and category roots;
3. finalise integration configuration objects and inheritance;
4. finalise completeness/search profile model;
5. produce Database Schema v2.6 proposal;
6. review impact/migration plan against current V2.1 tables;
7. only then implement DB/API changes;
8. build role-aware production menu/UI last against the approved API model.
