# Coursefinder Master Project Plan v1.1

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.0.md`  
**Repository:** `msinghbs-ai/coursefinder-admin`  
**Last consolidated:** 12 August 2026  
**Architecture baseline:** `docs/coursefinder-database-architecture-v2.10.0.md`  
**Running build baseline:** `docs/coursefinder-running-build-v2.2.md`  
**Accepted Layer 1 gates:** AU PASS; NZ PASS  
**Current programme position:** CA Layer 1 active; GB, US and IE queued; DE deferred/blocked. Phase 2 Admin/PIM redesign and AU QILT structured-outcomes foundation can progress in parallel without changing Layer 1 country-gate sequencing.

---

## 1. Governance

This is the authoritative programme-level plan for Coursefinder. Detailed implementation remains in running-build, architecture, migrations and UAT documents.

Source-of-truth order:
1. approved architecture/database identity rules;
2. this master project plan;
3. current running-build documentation;
4. accepted UAT evidence;
5. Admin/operator implementation guides.

Any change to identity, canonical ownership, source authority, phase boundaries, data model, security boundary or production-gate criteria must update this plan and the relevant architecture/runtime documentation.

---

## 2. Programme status

| Phase | Name | Status | Current gate |
|---|---|---|---|
| 0 | Foundation & Architecture | **COMPLETE / ACCEPTED** | Architecture v2.10.0 authoritative |
| 1 | Layer 1 Regulatory Data | **IN PROGRESS** | AU PASS; NZ PASS; CA ACTIVE; GB/US/IE queued; DE deferred |
| 2 | Admin / PIM UX | **IN PROGRESS / REDESIGN APPROVED** | Production information architecture + country/dashboard/filter/manual-entry design |
| 3 | Layer 2 Source Enrichment | **PLANNED / FOUNDATION EXTENDED** | Layer 2A QILT outcomes DB foundation applied; Layer 2B provider enrichment planned |
| 4 | Layer 3 AI Enrichment | **PLANNED** | No production gate accepted |
| 5 | Data Quality & Human Review | **IN PROGRESS** | Mapping/reconciliation workflows extended for external outcomes |
| 6 | Search / API / Consumer Experience | **PARTIALLY COMPLETE** | AU/NZ search accepted; comparison/outcomes API planned |
| 7 | Production Hardening & Operations | **IN PROGRESS** | Security, bounded execution, observability, recovery and release hardening |

---

# Phase 0 — Foundation & Architecture

**Status:** COMPLETE / ACCEPTED

Architecture v2.10.0 preserves the v2.9.1 identity/evidence/search model and adds a structured provider-outcomes domain for QILT/ComparED and future quality/outcomes sources.

Core rules remain:
- names/titles are never identity;
- Layer 1 owns regulatory identity;
- Layer 2 enriches existing canonical entities;
- Layer 3 AI produces evidence-linked suggestions;
- Layer 4 resolves ambiguity/conflict;
- search/comparison surfaces are derived read models;
- internal schemas are not direct browser CRUD surfaces.

Linked docs:
- `docs/coursefinder-database-architecture-v2.10.0.md`
- `docs/coursefinder-database-architecture-v2.9.1.md`
- `supabase/production-migrations/044_qilt_provider_outcomes_foundation.sql`
- `supabase/production-migrations/045_qilt_provider_outcomes_fk_index_hardening.sql`

---

# Phase 1 — Layer 1 Regulatory Data

**Status:** IN PROGRESS

Accepted country state:
- AU — PASS
- NZ — PASS
- CA — ACTIVE
- GB — QUEUED
- US — QUEUED
- IE — QUEUED
- DE — DEFERRED/BLOCKED pending stable Provider identity/source-authority remediation

QILT/ComparED work does **not** alter this sequence and is not a Layer 1 source.

Production identity contract:
- Provider = country + accepted registration scheme + stable regulator/source Provider code;
- Course = Provider + accepted scheme + stable regulator/source Course code;
- names and titles remain display/enrichment only.

Per-country exit gate remains: authoritative source, stable identifiers, bounded dry-run/APPLY/resume, evidence, idempotency, integrity, Search Projection, security and performance UAT.

---

# Phase 2 — Admin / PIM UX

**Status:** IN PROGRESS / REDESIGN APPROVED

## Approved information architecture

### Overview
- Dashboard

Dashboard requirements:
- combined global statistics;
- global country context/filter;
- expandable country cards;
- per-country Provider/Course/Campus/Search counts;
- completeness distribution;
- latest Layer 1/2 job/source health;
- failed jobs/open reviews;
- last successful refresh.

### Catalogue
- Providers
- Campuses
- Courses
- Course Collections
- Scholarships

Catalogue requirements:
- persistent filters for country, state/subdivision, Provider, study level, field, delivery, lifecycle/publication, completeness, source, verification/review state and relevant missing-data flags;
- saved views in a later increment;
- governed manual create/edit for Provider, Course, Campus and Scholarship;
- regulatory IDs manually entered remain unverified until authoritative reconciliation;
- Provider and Course workspaces become tabbed detail surfaces for source/history/evidence and related entities.

### Data Quality
- Completeness
- Review Queue
- Source Mappings

Source Mappings must support:
- external source institution -> canonical Provider;
- QILT/other external study area -> CourseFinder field-of-study crosswalk;
- candidate/verified/rejected states and audit history.

### Data Operations
- Pipeline
- Jobs
- Evidence

All ingestion execution moves to Pipeline. Settings is configuration only.

Pipeline stages:
- Layer 1 Regulatory;
- Layer 2A Government / Structured Enrichment;
- Layer 2B Provider Source Enrichment;
- Layer 3 AI Enrichment;
- Search/Projection operations.

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

Settings/admin configuration must support editable source/worker configuration with non-writing validation of source reachability, worker existence/security, parser/schema compatibility and identifier contract.

## Phase 2 gate
- production navigation accepted;
- Dashboard country cards and global country context functional;
- advanced catalogue filters functional;
- manual-entry governance functional;
- Pipeline owns ingestion execution;
- Settings owns configuration;
- mappings/evidence/history are inspectable;
- role/security UAT passes.

---

# Phase 3 — Layer 2 Source Enrichment

**Status:** PLANNED / FOUNDATION EXTENDED

Layer 2 is split into two governed substreams.

## Phase 3A — Layer 2A Authoritative Structured Enrichment

Initial AU source family: **QILT / ComparED outcomes**.

Purpose:
- student experience;
- graduate employment/outcomes;
- salary/satisfaction;
- international-student outcomes where published;
- longitudinal outcomes;
- employer outcomes only at supported publication granularity.

Architecture/storage:
- `ref.outcome_surveys`
- `ref.outcome_metrics`
- `ref.external_study_areas`
- `ref.external_study_area_mappings`
- `pipeline.source_provider_mappings`
- `catalogue.provider_outcomes`

Migration 044 has been applied. It seeds only four survey-family definitions; no fabricated QILT metrics or observations are loaded before source/parser validation. Migration 045 adds the covering FK indexes identified during post-DDL performance review.

Planned AU QILT worker: `qilt-au-etl`.

Acquisition gate:
1. discover latest official QILT structured resources;
2. capture source file + SHA-256 evidence;
3. parse survey/institution/study-area/metric dimensions;
4. establish source Provider mappings without name-based identity;
5. establish study-area crosswalk;
6. dry-run SES/GOS first;
7. bounded/versioned APPLY;
8. idempotency/duplicate/orphan/period-granularity UAT;
9. add comparison projection/API only after canonical observations pass.

ComparED is primarily a presentation/validation reference unless a stable accepted machine-readable contract is documented.

## Phase 3B — Layer 2B Provider Source Enrichment

Acquire current provider facts such as:
- fees;
- intakes;
- English requirements;
- scholarships;
- descriptions;
- approved academic attributes.

Layer 2B must attach evidence to stable canonical IDs and never silently override Layer 1 regulatory truth.

---

# Phase 4 — Layer 3 AI Enrichment

**Status:** PLANNED

AI output remains evidence-linked structured suggestion, not automatic canonical truth. Use AI only where deterministic parsing/extraction is insufficient. Version schemas/models/prompts and control confidence/cost/rate limits.

---

# Phase 5 — Data Quality & Human Review

**Status:** IN PROGRESS

Scope now includes:
- completeness;
- field conflicts;
- source mapping review;
- QILT institution mapping review;
- external study-area mapping review;
- suggestion acceptance/rejection;
- evidence/provenance inspection;
- audit/reviewer history.

The mapping tables created by migration 044 are part of this phase's foundation.

---

# Phase 6 — Search / API / Consumer Experience

**Status:** PARTIALLY COMPLETE

Current accepted:
- AU Search Projection PASS;
- NZ Search Projection PASS.

Planned comparison extension:
- consumer comparison activates when multiple eligible AU Providers/Courses are selected;
- course -> Provider -> field/study level -> verified QILT study-area mapping -> current accepted Provider outcome observation;
- response must expose cohort scope, survey period, response count/confidence interval and benchmark where available;
- never label provider/study-area survey results as an individual CRICOS Course result;
- allow `All students` / `International students` where the source supports the audience split.

Future API work:
- country/filter contracts;
- comparison projection;
- pagination/performance;
- semantic/vector relevance where justified;
- consumer/counsellor presentation.

---

# Phase 7 — Production Hardening & Operations

**Status:** IN PROGRESS

Continue:
- RLS/privilege review;
- authenticated RPC review;
- bounded/retry/resume/idempotency controls;
- source-health monitoring;
- evidence retention;
- job observability;
- single/serial Search Projection finalisation;
- backup/recovery/cutover/runbooks;
- worker configuration validation.

Migrations 044/045 keep all new tables internal with RLS enabled, `anon`/`authenticated` direct access revoked and service-role ingestion explicit. Security Advisor `rls_enabled_no_policy` INFO is expected under the current deny-by-default internal-schema design; existing SECURITY DEFINER UI RPC warnings remain a separate Phase 7 hardening item.

---

## 3. Immediate programme sequence

Primary Layer 1 programme sequence remains:
1. CA production gate — ACTIVE.
2. GB production gate.
3. US production gate.
4. IE production gate.
5. DE remediation/re-entry.

Parallel, non-blocking workstreams:
1. Admin/PIM information architecture implementation.
2. QILT source/parser discovery and AU pilot mapping.
3. Dashboard country-statistics contract.
4. catalogue filter/manual-entry contracts.
5. Pipeline/Settings separation.
6. Data Quality Source Mapping UI.
7. Phase 7 UI RPC/security hardening.

QILT may progress in parallel, but consumer comparison cannot be released until its source/mapping/observation UAT gate passes.

---

## 4. Current programme decision

**CA remains the active Layer 1 country. QILT/ComparED is approved as Layer 2A AU structured enrichment. Architecture v2.10.0 and migrations 044/045 establish the database foundation. Admin navigation is to separate Catalogue, Data Quality, Data Operations, Insights and Administration, with ingestion execution in Pipeline and configuration in Settings.**
