# Coursefinder Database Architecture v2.10.0

**Status:** Authoritative architecture baseline.  
**Supersedes:** `docs/coursefinder-database-architecture-v2.9.1.md`  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Date:** 12 August 2026

This version retains all accepted v2.9.1 architecture principles and adds the structured outcomes/comparison model required for QILT/ComparED and future authoritative quality/outcomes sources.

---

## 1. Unchanged core principles

1. Canonical entities use stable identifiers; names/titles never act as identity.
2. Layer 1 owns regulatory identity and regulatory truth.
3. Layer 2 acquires and normalises non-regulatory evidence without redefining canonical identity.
4. Layer 3 AI produces evidence-linked structured suggestions where deterministic extraction is insufficient.
5. Layer 4/human workflow resolves ambiguity and conflicts.
6. Search and comparison projections are derived/rebuildable read models.
7. Internal schemas are not direct browser CRUD surfaces; UI access is through curated RPC/API contracts.

---

## 2. New structured outcomes domain

QILT/ComparED data is modelled as temporal, evidenced **Provider outcomes**, not as CRICOS Course attributes.

Granularity is preserved from the source:

`Provider -> Study Area (optional) -> Study Level (optional) -> Audience -> Survey -> Metric -> Collection Period`

The model must never imply course-level survey results where the source only publishes provider/study-area cohorts.

### New reference tables

- `ref.outcome_surveys`
  - survey families such as QILT SES, GOS, GOS-L and ESS.
- `ref.outcome_metrics`
  - versionable metric definitions and units.
- `ref.external_study_areas`
  - source-native study-area codes/names, including QILT/ComparED study areas.
- `ref.external_study_area_mappings`
  - verified crosswalk from source study areas to CourseFinder `ref.fields_of_study`.

### New pipeline crosswalk

- `pipeline.source_provider_mappings`
  - maps an external source institution key/name to an existing canonical `catalogue.providers.id`.
  - source name matching may generate a candidate only; it is never canonical identity.
  - verified mappings are reusable by QILT and future enrichment sources.

### New catalogue observation table

- `catalogue.provider_outcomes`

Key dimensions:
- canonical `provider_id`;
- `survey_id` and `metric_id`;
- optional external study area;
- optional canonical study level;
- audience (`all`, `domestic`, `international`, etc.);
- source collection-year range;
- metric value;
- response count;
- confidence interval;
- national benchmark;
- source/evidence IDs;
- source-native institution/study-area/metric codes;
- observation/status/version metadata.

Observations are versioned by collection period and source. A later annual survey creates/reconciles a later observation rather than overwriting historical results.

---

## 3. Layer classification

### Layer 1 — Regulatory
Examples:
- AU CRICOS;
- NZQA;
- future accepted national regulators.

Layer 1 creates/reconciles canonical Provider/Course/Campus identity and regulatory facts.

### Layer 2A — Authoritative structured enrichment
Examples:
- QILT/ComparED survey outcomes;
- future government outcomes, ranking or public-statistics datasets where structured and authoritative.

Layer 2A may update structured enrichment domains but cannot create/merge regulatory identities merely from descriptive names.

### Layer 2B — Provider/source enrichment
University/provider websites and approved source acquisition for fees, intakes, English requirements, scholarships, descriptions and other current provider facts.

### Layer 3 — AI enrichment
Structured extraction/classification from evidence that cannot be handled deterministically.

### Layer 4 — Human review/governance
Provider mapping review, study-area crosswalk review, source conflicts, low-confidence extraction and publication decisions.

---

## 4. QILT/ComparED acquisition design

Primary ingestion target is the official QILT-published structured report tables/resources. ComparED is treated as a presentation/validation reference unless a documented, stable machine-readable source contract is accepted.

Planned worker: `qilt-au-etl`.

Required flow:
1. discover latest official QILT resources;
2. fetch structured SES/GOS/GOS-L/ESS resources as applicable;
3. store original source files in private evidence storage with hash/metadata;
4. parse source-native institution and study-area identifiers/labels;
5. reconcile source institutions through `pipeline.source_provider_mappings`;
6. load/update source study areas and verified field mappings;
7. load `catalogue.provider_outcomes` by exact published cohort/granularity;
8. run duplicate, orphan, mapping and temporal checks;
9. publish comparison/read projection only after the ingest gate passes.

ESS must not be surfaced at institution/study-area granularity unless the published source supports that slice.

---

## 5. Comparison/read architecture

The consumer comparison feature is derived from canonical catalogue entities plus current accepted outcome observations.

For selected AU courses/providers:

`Course -> Provider -> Course field/study level -> verified source study-area mapping -> provider_outcomes`

A comparison projection/API should expose:
- provider identity/display name;
- survey/metric display name;
- study area and study level;
- audience;
- value/unit;
- response count;
- confidence interval;
- national benchmark;
- survey collection period;
- provenance/source metadata.

The UI must label cohort scope clearly, e.g. `Provider / Computing & Information Systems / Undergraduate`, and must not present the value as a specific CRICOS course result.

---

## 6. Admin information architecture

### Overview
- Dashboard

Dashboard combines global catalogue health with expandable per-country cards. Each country card can expose provider/course/campus/search counts, completeness distribution, latest Layer 1/2 jobs, source health and outstanding reviews.

### Catalogue
- Providers
- Campuses
- Courses
- Course Collections
- Scholarships

Catalogue list views support country, state/subdivision, provider, study level, field, lifecycle/publication, completeness, source and review filters. Manual creation/editing is governed and cannot fabricate regulatory identity.

### Data Quality
- Completeness
- Review Queue
- Source Mappings

Source Mappings includes external Provider crosswalk and study-area mapping review.

### Data Operations
- Pipeline
- Jobs
- Evidence

Pipeline owns execution. Settings does not execute ingestion.

Pipeline stages:
- Layer 1 Regulatory;
- Layer 2A Government/Structured Enrichment;
- Layer 2B Provider Enrichment;
- Layer 3 AI Enrichment;
- Search/Projection jobs.

### Insights
- Outcomes & Comparisons
- Rankings

Outcomes & Comparisons is the admin/read surface for QILT and future outcome data.

### Administration
- Countries
- Regulatory Sources
- ETL / Workers
- Integrations
- Search Profiles
- Users & Roles
- Settings

Settings holds configuration. Country/source/worker records are editable only within validation rules. A `Validate configuration` action should test source reachability, worker existence/security, expected schema/parser compatibility and required identifier contracts without writing canonical data.

---

## 7. Manual data-entry rules

Manual Provider/Course/Campus records are supported for operational completeness, but:
- manual records receive canonical UUID/stable-key identity independent of names;
- regulatory identifiers entered manually are `unverified` until reconciled with the relevant authoritative source;
- manual entry records actor/time/source/evidence/notes;
- later Layer 1 reconciliation must attach to exact accepted identifiers rather than merge by name;
- ambiguous matches enter Layer 4 review.

---

## 8. Security boundary

New v2.10.0 tables are internal-schema tables with RLS enabled and no direct `anon`/`authenticated` grants. Service-role ingestion is explicit. Browser access must be introduced later through curated authenticated RPC/API contracts.

This matches the current deny-by-default internal-schema posture. Supabase Security Advisor may report `rls_enabled_no_policy` INFO for these tables; that is intentional while no direct browser policies exist.

---

## 9. Migration baseline

New production migration:
- `044_qilt_provider_outcomes_foundation.sql`

It creates:
- four survey families;
- outcome metric definitions table;
- external study-area and mapping tables;
- generic source-to-provider mapping table;
- temporal provider outcomes observations;
- indexes, RLS and service-role boundaries.

No QILT metric observations are seeded by the migration. Source-native metric definitions and data are created only by the accepted ingestion adapter so schema assumptions are not fabricated ahead of source validation.

---

## 10. Next architecture gates

1. Complete the active CA Layer 1 production gate without changing Layer 1 sequencing.
2. Build QILT source-discovery/parser UAT independently of CA.
3. Validate source institution keys and establish verified Provider mappings for an AU university pilot subset.
4. Validate QILT study-area taxonomy and CourseFinder field crosswalk.
5. Dry-run SES/GOS ingestion with zero canonical identity writes.
6. Apply bounded/versioned outcomes ingestion and run idempotency/integrity UAT.
7. Add curated Admin Outcomes API/RPC and comparison projection.
8. Implement Dashboard country cards, global country context, advanced catalogue filters, Data Operations navigation and mapping review UI.
9. Only then expose QILT comparison in the consumer course-selection experience.
