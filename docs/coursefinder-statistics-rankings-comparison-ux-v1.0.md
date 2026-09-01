# CourseFinder Statistics, Rankings & Comparison UX v1.0

**Status:** CURRENT DESIGN  
**Date:** 2 September 2026  
**Change Control:** CF-CHG-20260902-064

## 1. Statistics & Rankings workspace

Purpose: one place for operators to answer:
- what statistical/ranking datasets do we hold?
- which years/periods are available?
- which Providers/Courses are covered?
- what is mapped/unmapped/suppressed?
- what Evidence/source produced the observation?
- when was it refreshed?

### Header scorecards
- QILT: latest period, observations, Provider coverage
- PRISMS: latest period, observations, geography/study-area coverage
- QS: latest edition, mapped Providers, unresolved mappings
- THE: latest edition, mapped Providers, unresolved mappings

### Filters
- Dataset
- Country
- Provider
- Course where dataset grain permits
- Year/edition
- Study level
- Study area
- Survey/metric
- Mapping state
- Suppression/availability
- Evidence/source status

### Views
1. Overview
2. Coverage & years
3. Observations
4. Mapping / reconciliation
5. Sources & Evidence

The workspace should favour readable cards/coverage matrices before raw tables.

## 2. Manual file import

Location: Statistics & Rankings → Sources & Evidence → **Upload publisher file**, also linked from Administration → Sources & Imports.

Required metadata is captured before upload. Files remain private Evidence. Parsing/apply is a separate controlled action.

Historical paywall handling:
- operator obtains an authorised publisher file;
- records publisher/source/licence context;
- uploads it;
- system fingerprints and registers Evidence;
- adapter validates expected edition/schema;
- preview shows row count and parse errors;
- operator applies or sends unresolved institution mappings to Layer 4.

Never accept an unexplained third-party spreadsheet as QS/THE authority.

## 3. Compare journey

Step 1 — Select:
- Provider or Course mode;
- search/add up to six;
- persistent compare tray across Catalogue/detail pages.

Step 2 — Choose data:
- QILT;
- PRISMS;
- QS;
- THE;
- future accepted datasets.

Step 3 — Choose period:
- Latest common period;
- specific edition/year;
- per-dataset period when no common year is semantically valid.

Step 4 — Compare:
- aligned matrix;
- source-grain badge;
- suppression/unavailable states;
- optional trends;
- source/methodology links.

## 4. Provider/Course detail

Detail blades provide summary, not a second statistics application.

Provider summary:
- QILT selected headline metrics;
- PRISMS relevant provider/geography context;
- QS latest rank + edition;
- THE latest rank + edition;
- View all statistics;
- Add to Compare.

Course summary:
- valid Course-context outcomes;
- inherited Provider ranking clearly labelled;
- PRISMS provider/geographic context clearly labelled;
- View all statistics;
- Add to Compare.

## 5. Navigation model

### Overview
- Dashboard

### Catalogue
- Providers
- Courses
- Campuses
- Scholarships

### Statistics & Insights
- Statistics & Rankings
- Compare

### Data Operations
- Layer 1 — Authority
- Layer 2 — Enrichment
- Layer 3 — AI Interpretation
- Layer 4 — Human Resolution
- Evidence
- Jobs

### Quality & Review
- Completeness
- Review Queue / reconciliation as governed

### Administration
Single top-level entry with sub-navigation:
- Overview
- Sources & Imports
- Acquisition
- Scheduling
- Onboarding
- PIM Configuration
- Users & Roles
- Platform

## 6. Security

Manual publisher upload is Curator/Admin only and never anonymous. Storage remains private. Registration/parsing/apply is server-side. Browser never receives service-role credentials.

## 7. UAT

- navigation desktop/tablet/mobile;
- Statistics workspace data/empty/loading states;
- coverage/year filtering;
- Compare selection/dataset/year states;
- deep-links from Provider/Course;
- role-negative upload access;
- duplicate upload fingerprint handling;
- invalid MIME/oversize rejection;
- parse preview/apply separation;
- Evidence lineage;
- payload/performance budgets.