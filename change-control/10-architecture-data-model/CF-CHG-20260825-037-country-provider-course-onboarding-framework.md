# CF-CHG-20260825-037 — Country / Provider / Course Onboarding Framework

**Status:** APPROVED / IN PROGRESS — IMPLEMENTATION REQUIRED  
**Category:** 10-architecture-data-model  
**Initiated:** 25 August 2026 22:13 AEST (+10:00)  
**Last reconciled:** 26 August 2026 06:37 AEST (+10:00)  
**Owner:** CourseFinder architecture / Data Operations

## Decision

M2.3 requires a reusable Onboarding capability for Countries, regulatory sources, Providers and Courses rather than country-specific one-off canonical implementations.

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

Every Onboarding case must support the durable lifecycle:

`Draft → Source Qualification → Adapter Assessment → Schema Assessment → L1 UAT → L2 UAT → L3 Ready → Operational Certification → Production Promotion Ready`.

Governed outcome state must support:

- READY;
- CONDITIONAL;
- BLOCKED;
- PAUSED;
- REJECTED.

Lifecycle changes require immutable audit lineage, actor/time, reason, Change Control and UAT references. Browser writes must use rank-checked server contracts rather than direct table CRUD.

## Layer authority reconciliation

The original opening record predated CF-CHG-20260825-038 and stated that general Layer 3 execution would begin in M2.4. That statement is superseded by the current Master Project Plan v1.71 and CF-CHG-20260825-038: Layer 3 is now operationalised in M2.3 under its provider-profile, server-secret, eligibility, deterministic-validation and Layer 4 escalation controls.

Onboarding `L3 Ready` therefore means the case has the required source/Evidence/field profile and eligibility configuration to participate safely in the governed M2.3 Layer 3 platform. It does **not** bypass the model-profile provider benchmark; a PAUSED or unvalidated provider profile remains unavailable for real calls.

## Country onboarding contract

Capture at minimum:

- ISO country identity and relevant subdivisions;
- regulatory/Provider/Course authority strategy;
- national/source identifiers;
- official source URLs/feed type, coverage claim and usage/licensing restrictions;
- source cadence and source-native pagination/batch/rate limits;
- source grain and canonical identity mapping;
- adapter family and Worker requirement;
- schema-extension assessment;
- Layer 1 qualification/UAT;
- Layer 2 enrichment strategy/UAT;
- expected Layer 3 exception classes/readiness;
- operational certification;
- Production promotion manifest references;
- Change Control/UAT/Evidence lineage.

Future-country adapter/ETL coding remains prohibited until Source Qualification establishes a defensible authority strategy.

## Provider/Course onboarding contract

Provider/Course onboarding must prefer authoritative regulatory identity first. Canonical entities must not be manually invented merely to enable enrichment.

The workflow must determine:

1. authoritative identity source;
2. source-stable identifier;
3. canonical stable-key strategy;
4. Provider/Course relationship;
5. Layer 1 ingestion path;
6. Layer 2 first-party enrichment source(s);
7. Evidence requirements;
8. deterministic extraction/mapping rules;
9. unresolved fields eligible for Layer 3;
10. Layer 4 escalation conditions.

## Adapter assessment

Classify integrations into reusable families where possible:

- structured API;
- CSV/XLSX;
- JSON;
- XML;
- sitemap/catalogue crawl;
- HTML detail-page acquisition;
- document/PDF acquisition;
- direct HTTP;
- approved scraper/browser provider;
- custom adapter only where generic families are insufficient.

When a new adapter is required, record source contract, parser/version, batch/rate/retry/timeout policy, Evidence output, identity mapping, replay/idempotency contract, deployment SHA and automated UAT.

## Environment / promotion boundary

Use the same codebase, migrations, adapter framework and onboarding workflow across Pilot/UAT and Production while keeping separate trust boundaries. Do not promote UAT secrets, live job state or Evidence objects into Production. Promote accepted migrations/configuration/adapter SHAs and a governed promotion manifest.

## Reconciled implementation state

A fresh source and deployed-database search at this checkpoint found **no reusable Onboarding workspace/table/function foundation**. Existing source registry, acquisition provider, Evidence, Layer 1–4 and refresh foundations are available and must be inherited rather than duplicated.

Therefore this Change Control is not complete and no representative future-country/source workflow has yet passed the required lifecycle UAT.

## Required implementation

M2.3 must add:

- reusable Onboarding case and immutable lifecycle audit structures;
- rank-checked private implementations with public SECURITY INVOKER browser contracts;
- validation of allowed stage transitions/outcome semantics;
- links to existing source/source-profile/provider/entity/Evidence/Change Control/UAT references rather than duplicate registries;
- shared schema/adapter decision records;
- Onboarding Admin workspace with case list/filter, lifecycle progress, decision history and governed transition controls;
- automated rollback-only database/security UAT;
- permanent deployed desktop/mobile UAT;
- at least one representative workflow exercised without creating a country-specific canonical fork.

## Security

- direct browser CRUD on private Onboarding tables is prohibited;
- anonymous access is prohibited;
- read/write rank enforcement must follow the accepted Admin role model;
- helper functions with elevated authority remain private and service-role executable only;
- public browser contracts remain SECURITY INVOKER wrappers;
- source qualification and lifecycle decisions must retain actor/reason/audit evidence.

## Acceptance

**Gate: IN PROGRESS — IMPLEMENTATION REQUIRED.**

This Change Control closes only when architecture/docs and deployed Admin/runtime match the framework, automated UAT proves the lifecycle/security/canonical-extension rules, and a representative workflow reaches its governed M2.3 acceptance boundary. M2.4 must not start before M2.3 closure.