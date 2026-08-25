# CF-CHG-20260825-037 — Country / Provider / Course Onboarding Framework

**Status:** APPROVED / IN PROGRESS — IMPLEMENTED IN PILOT; REPRESENTATIVE LIFECYCLE ACCEPTANCE REMAINS  
**Category:** 10-architecture-data-model  
**Initiated:** 25 August 2026 22:13 AEST (+10:00)  
**Last reconciled:** 26 August 2026 09:55 AEST (+10:00)  
**Owner:** CourseFinder architecture / Data Operations

## Decision

M2.3 requires a reusable Onboarding capability for Countries, regulatory sources, Providers and Courses rather than country-specific canonical forks.

The canonical architecture remains shared and country-neutral:

- one shared Provider/Course/Campus/Scholarship model;
- governed country/subdivision identity;
- stable entity keys independent of adapter/provider implementation;
- shared source/profile/provider/Evidence/job foundations;
- source-native staging where source grain must be preserved;
- extension/fact tables only for genuinely country-specific concepts;
- adapters/Workers own source differences;
- no separate canonical Provider/Course schema per country.

Default database-extension preference remains:

`existing canonical field → existing fact/relationship table → generic extension/fact table → country-specific extension table → canonical change only when globally valid`.

## Lifecycle

Every Onboarding case supports:

`Draft → Source Qualification → Adapter Assessment → Schema Assessment → L1 UAT → L2 UAT → L3 Ready → Operational Certification → Production Promotion Ready`.

Outcome state supports READY / CONDITIONAL / BLOCKED / PAUSED / REJECTED. Lifecycle decisions retain actor/time/reason/Change Control/UAT lineage and browser writes use rank-checked contracts rather than direct table CRUD.

## Reconciled deployed implementation

The earlier 06:37 AEST statement that no reusable Onboarding foundation existed is superseded by deployed migration:

`20260825202903_m2_3_onboarding_lifecycle_foundation`.

Live Pilot contains:

- private `pipeline.onboarding_cases`;
- private immutable lifecycle-event/audit structure;
- rank-checked private implementations;
- public SECURITY INVOKER browser contracts;
- stage/outcome transition validation;
- references to existing source/source-profile/provider/course/Evidence/governance identifiers rather than duplicate registries;
- shared adapter/schema decision fields;
- deployed M2.3 Intelligence **Onboarding** Admin workspace with case list/filter, lifecycle state, decision history and governed create/transition controls.

Direct browser CRUD remains prohibited. The private tables have RLS enabled with no browser policy by design. Elevated helpers are not exposed to anon/authenticated.

## Deployed browser evidence

Go 3 accepted runtime `e94383bd4fd3b5718566bc4bb1c19f8cf687de36` passed permanent desktop and mobile deployed acceptance. The M2.3 Intelligence test verifies:

- Onboarding workspace is reachable;
- shared canonical lifecycle messaging is visible;
- all nine lifecycle stages are exposed;
- governed case creation is present.

Evidence:

- deployed UAT `32910110993` — PASS;
- desktop `98002494209` — PASS;
- mobile `98002494407` — PASS.

Go 4 target `87da570d8e6701928e45d532caf11877b6eab369` retains the same Onboarding foundation while adding Layer 3 provider credential control; final Go 4 deployed regression is tracked in the M2.3 run sheet.

## Layer authority reconciliation

Onboarding `L3 Ready` means the case has the required source/Evidence/field profile and eligibility configuration to participate safely in the governed Layer 3 platform. It does not imply an external model can run and never bypasses the provider-profile credential/quality benchmark.

Provider/Course onboarding continues to prefer authoritative regulatory identity first. Canonical entities must not be manually invented merely to enable enrichment.

## Environment / promotion boundary

The same codebase, migrations, adapter framework and onboarding workflow are intended for Pilot/UAT and Production while preserving separate trust boundaries. UAT secrets, live jobs and Evidence objects are not promotion artifacts; accepted migration/config/adapter SHAs and governed promotion manifests are.

## Remaining acceptance

Implementation is no longer the blocker. Before CF-CHG-037 can close, automated rollback-only evidence must exercise at least one representative case through the governed lifecycle boundary and prove:

- transition validation and invalid-transition rejection;
- outcome semantics;
- immutable audit lineage;
- anon/insufficient-rank/private-table/private-helper denial;
- source qualification before adapter/ETL implementation;
- no country-specific canonical fork;
- links to the existing source/profile/provider/entity/Evidence registries;
- representative L1/L2/L3-ready/operational-certification decisions without bypassing layer authority.

Synthetic UAT state must be rolled back.

## Acceptance

**Gate: IN PROGRESS — IMPLEMENTED; REPRESENTATIVE LIFECYCLE ACCEPTANCE REMAINS.**

M2.4 must not start until the complete M2.3 boundary is classified PASS, BLOCKED with accepted evidence, or explicitly DEFERRED.
