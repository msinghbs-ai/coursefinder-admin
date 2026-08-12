# Coursefinder Admin UX & Information Architecture v1.0

**Status:** Approved design contract for phased Admin/PIM implementation  
**Architecture:** v2.10.0  
**Date:** 12 August 2026

---

## 1. Navigation

### Overview
- Dashboard

### Catalogue
- Providers
- Campuses
- Courses
- Course Collections
- Scholarships

### Data Quality
- Completeness
- Review Queue
- Source Mappings

### Data Operations
- Pipeline
- Jobs
- Evidence

### PIM
- Attributes
- Categories

### Insights
- Outcomes & Comparisons
- Rankings

### Administration
- Countries
- Regulatory Sources
- ETL / Workers
- Integrations
- Search Profiles
- Users & Roles
- Settings

Principle: execution belongs in Data Operations; configuration belongs in Administration.

---

## 2. Global country context

Top navigation provides `All Countries` plus enabled country choices.

Country context applies by default to:
- Dashboard;
- Providers;
- Campuses;
- Courses;
- Completeness;
- Review Queue;
- Pipeline;
- Jobs;
- Evidence;
- Insights.

A page may override the country context locally without changing canonical data.

---

## 3. Dashboard

### Global metric strip
- Providers
- Courses
- Campuses
- Course Locations
- Search Documents
- Completeness average
- Open Reviews
- Failed Jobs

### Country cards
One expandable card per enabled country.

Collapsed state:
- country;
- Providers;
- Courses;
- Campuses;
- Search Documents;
- completeness;
- Layer 1 health;
- last refresh.

Expanded state:
- source/adapter summary;
- last successful/failed Layer 1 job;
- latest Layer 2 source jobs;
- evidence freshness;
- completeness bands;
- missing fees/intakes/English/location counts;
- open review/mapping count;
- search coverage;
- outcome/QILT status where supported.

Cards show operational status: Healthy, Running, Warning, Failed, Disabled, Needs Review.

---

## 4. Catalogue list UX

Persistent filter bar/drawer:
- Country
- State/Subdivision
- Provider
- Campus
- Study Level
- Field of Study
- Delivery Mode
- Lifecycle Status
- Publication Status
- Source
- Completeness range
- Has Fees
- Has Intakes
- Has English Requirements
- Has Campus
- Has Description
- Needs Review
- Last Verified date
- Modified date

Later increment:
- Saved Views
- Bulk Edit
- Export current view

Default list actions:
- Add
- Import
- Export
- Bulk Edit
- More

---

## 5. Manual creation

Supported:
- Provider
- Campus
- Course
- Scholarship

Manual-entry governance:
- canonical UUID/stable key generated independently of descriptive name;
- regulatory identifier is never assumed verified because a user typed it;
- `manual` source/provenance recorded;
- actor/timestamp/reference/evidence/notes retained;
- potential match to existing regulatory record is a reconciliation candidate;
- ambiguous matches enter Review Queue;
- Layer 1 exact identifier reconciliation may later attach the manual record under controlled rules.

Course editor sections:
- Identity
- Academic
- Locations
- Fees
- Intakes
- English
- Academic Options
- Categories
- Source & Governance

---

## 6. Provider workspace

Tabs:
- Overview
- Campuses
- Courses
- Collections
- Scholarships
- Outcomes
- Sources
- Completeness
- History

Overview includes:
- canonical/display name;
- regulatory registrations;
- country/state;
- website/city;
- course/campus counts;
- completeness;
- last Layer 1 verification;
- Layer 2 freshness;
- publication status.

Outcomes tab displays QILT or future outcome datasets by supported cohort/granularity.

---

## 7. Course workspace

Tabs:
- Overview
- Locations
- Fees
- Intakes
- English
- Academic Options
- Categories
- Related Outcomes
- Sources
- History

`Related Outcomes` must explicitly show that provider/study-area outcomes are contextual cohort data, not results for the individual CRICOS Course unless the source genuinely provides course-level granularity.

---

## 8. Completeness UX

Completeness is both score and dimension state.

Example dimensions:
- Identity
- Academic
- Location
- Fees
- Intakes
- English
- Description
- Scholarships/related content where relevant

Dashboard bands:
- 90-100%
- 70-89%
- 50-69%
- <50%

Filters/actions allow administrators to target missing dimensions for Layer 2/3 work.

---

## 9. Source Mappings

Two initial mapping workspaces:

### Provider mappings
External source institution -> canonical Provider.

Columns:
- Source
- Source key
- Source name
- Candidate Provider
- Match method
- Confidence
- Status
- Verified by/at

Actions:
- Verify
- Change Provider
- Reject
- Re-open

### Study-area mappings
External study area -> CourseFinder field of study.

Columns/actions follow the same candidate/verified/rejected governance model.

---

## 10. Pipeline

Pipeline is the only Admin surface for ingestion/execution.

Stages:

### Layer 1 — Regulatory
- AU CRICOS
- NZQA
- CA/GB/US/IE/DE as each production gate is accepted

### Layer 2A — Government / Structured Enrichment
- AU QILT SES
- AU QILT GOS
- AU QILT GOS-L
- AU QILT ESS where supported
- future authoritative datasets

### Layer 2B — Provider Enrichment
- provider web/content acquisition
- fees/intakes/English/scholarships

### Layer 3 — AI Enrichment
- approved extraction/classification jobs

### Search / Projection
- rebuild/reindex operations

Each pipeline card shows:
- source/worker;
- status;
- records available/processed;
- bounded batch/offset where relevant;
- evidence timestamp;
- last success/failure;
- next action.

Actions are context-specific: Validate, Dry Run, Apply Batch, Continue, Retry, Finalise.

---

## 11. Jobs

Job list columns:
- Status
- Country
- Layer
- Source
- Worker
- Records
- Duration
- Started
- User

Job detail:
- input parameters;
- source/evidence;
- batch/offset;
- parsed/created/existing/skipped/conflict counts;
- errors;
- downstream projection action;
- next offset/resume state;
- affected entity links.

---

## 12. Evidence

Evidence page supports:
- Country
- Layer
- Source
- Job
- MIME/type
- captured date
- hash
- validity/supersession

Evidence remains private; UI exposes metadata and authorised retrieval actions rather than public storage paths.

---

## 13. Outcomes & Comparisons

Admin view:
- Provider selector
- Study area
- Study level
- Audience (`All`, `International`, etc.)
- Survey family
- Collection period

Metrics show:
- value/unit;
- response count;
- confidence interval;
- national benchmark;
- source/period;
- mapping status.

Consumer comparison (Phase 6) activates when multiple eligible AU Providers/Courses are selected. It derives the appropriate Provider + study-area + level cohort and labels that scope clearly.

---

## 14. Settings / Administration

### Countries
- enabled
- catalogue/search flags
- currency/language
- default worker
- default batch
- Layer 2/3 enablement

### Regulatory Sources
Editable:
- source URL
- discovery/API URL
- adapter
- trust/source authority
- expected coverage
- enabled/status

### ETL / Workers
- worker identifier
- layer/country support
- version
- bounded execution contract
- security requirements
- parser/schema contract
- last validation

`Validate configuration` performs a non-writing test:
1. worker exists;
2. JWT/security settings valid;
3. source resolves/reachable;
4. expected schema recognised;
5. required source identifiers present;
6. parser returns valid candidate records;
7. evidence storage path is usable;
8. required service RPCs available.

Settings never contains the production Apply/Run ingestion action.

---

## 15. Phased UI delivery

### UI Phase A — Navigation and Dashboard
- new navigation structure;
- global country context;
- combined global metrics;
- expandable country cards.

### UI Phase B — Catalogue productivity
- advanced filters;
- Provider/Course workspaces;
- governed manual add/edit;
- completeness dimensions.

### UI Phase C — Data Operations
- Pipeline stages;
- Jobs/Evidence detail;
- source/worker configuration moved to Administration;
- non-writing config validation.

### UI Phase D — Data Quality and Outcomes
- Provider/study-area mapping review;
- QILT Outcomes admin view;
- comparison read projection/API validation.

### UI Phase E — Consumer comparison
- multi-provider/course comparison;
- All vs International cohort switch where supported;
- confidence/sample/source disclosure;
- performance/accessibility UAT.
