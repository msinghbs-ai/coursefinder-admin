# Execution Addendum A20 — UniPIM-style Information Architecture & Central Administration

**Status:** ACTIVE — M2.4.4 ADDENDUM  
**Effective:** 31 August 2026  
**Change Control:** `CF-CHG-20260830-048`

## Purpose

Reorganise the CourseFinder Admin UI around a PIM-first, task-oriented information architecture influenced by UniPIM: daily catalogue and data-quality work is prominent; configuration, platform administration and diagnostics are centralised and progressively disclosed.

## A20.1 — Primary navigation contract

Primary navigation is for frequent operator journeys only.

### Overview
- Dashboard

### Catalogue
- Providers
- Courses
- Campuses
- Scholarships

### Insights
- Outcomes / QILT
- Student Flow / PRISMS

### Data Quality
- Completeness
- Evidence
- Review Queue

### Operations
- Layer 1 Operations
- Layer 2 Operations
- Layer 3 AI
- Layer 4 Review
- Jobs
- Important Dates
- Important Links

### Administration
A single central Administration workspace contains:
- Sources / source registry;
- Attributes, groups, families and completeness configuration;
- onboarding/source qualification;
- refresh/scheduling policy configuration;
- scraper/provider/API configuration and budgets;
- Layer 3 model/provider configuration;
- user/role/security administration where supported;
- platform/Pilot settings;
- release notes/version and diagnostics;
- advanced/probe/reset/developer controls.

Configuration entries should not appear as peer navigation items beside routine catalogue work unless the operator is explicitly in Administration.

## A20.2 — Workspace design

Follow the UniPIM interaction principle:
- listing/grid first for record sets;
- compact filters and saved/common filter patterns;
- record detail/edit grouped into meaningful cards/sections;
- task actions close to the record/task they affect;
- advanced/raw IDs/configuration under progressive disclosure;
- one consistent Save/Apply/Discard pattern for editable forms where practical;
- badges/status/completeness visible without opening diagnostics;
- pagination/lazy loading for large lists;
- avoid full-screen overlays for routine work.

## A20.3 — Settings centralisation

Move unrelated or infrequently used settings out of Layer 1–4 normal workspaces and out of the primary menu.

Examples:
- provider API credentials, route weights, paid-provider ceilings → Administration > Acquisition;
- model profiles, benchmark configuration and token/cost limits → Administration > AI;
- attribute definitions/families → Administration > PIM configuration;
- source qualification and onboarding templates → Administration > Sources & Onboarding;
- scheduler cadence/default policies → Administration > Scheduling;
- release notes/system diagnostics → Administration > Platform.

Operational screens may show the *effective setting* and health status, but editing it must link to the central Administration location.

## A20.4 — Layer workspace cleanup

- Layer 1: source health, current run, freshness, progress, exceptions, Run/Retry. Configuration elsewhere.
- Layer 2: scope, wave size, route mode, progress, Evidence, cost/provider use, fall-out. Detailed provider config elsewhere.
- Layer 3: qualified route status, Evidence candidates, Run, outcomes, tokens/cost/latency. Model configuration elsewhere.
- Layer 4: pending decisions, effective vs underlying value, reason/comment, approve/revert/publication decision. Registry/schema configuration elsewhere.

## A20.5 — Acceptance

A20 requires:
1. primary navigation contains no duplicate settings/configuration concepts;
2. Administration is the single entrypoint for privileged configuration;
3. existing role gates remain enforced server-side;
4. direct routes/bookmarks remain backwards compatible where feasible;
5. Layer workspaces show effective config/health but do not become settings pages;
6. desktop/tablet navigation and record detail UAT pass.
