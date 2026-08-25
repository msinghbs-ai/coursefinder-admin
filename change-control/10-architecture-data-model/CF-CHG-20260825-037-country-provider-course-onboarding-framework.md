# CF-CHG-20260825-037 — Country / Provider / Course Onboarding Framework

**Status:** APPROVED / IN PROGRESS — M2.3 FOUNDATION  
**Category:** 10-architecture-data-model  
**Initiated:** 25 August 2026 22:13 AEST (+10:00)  
**Origin:** M2.3 — Production Data Operations  
**Owner:** CourseFinder architecture / Data Operations

## Trigger

M2.3 now requires a reusable onboarding capability for future countries, regulatory authorities, Providers and Courses instead of adding each country through ad-hoc one-off implementation work.

The live canonical model is already country-neutral enough to support this direction: Providers are related to a governed country identifier, Courses are related to Providers, and stable identities are maintained independently of country-specific source adapters. New countries should therefore reuse the canonical Provider/Course model wherever semantics match and add source/country extension structures only where the source grain genuinely requires them.

## Decision

Create a separate Admin workspace:

**Onboarding**

with governed flows for:

1. Country onboarding;
2. Regulatory/source qualification;
3. Provider onboarding;
4. Course/source onboarding;
5. adapter/Worker requirement assessment;
6. database-extension requirement assessment;
7. Layer 1 qualification and UAT;
8. Layer 2 profile/routing/extraction setup and UAT;
9. Layer 3 readiness/interpretation-profile preparation;
10. promotion readiness and operational certification.

Layer 3 execution authority remains owned by M2.4. M2.3 may build the onboarding stage, validation model and handoff, but must not silently activate general Layer 3 AI execution early.

## Canonical architecture rule

Do **not** create a separate canonical database/schema per country.

Preferred architecture:

- one shared canonical `catalogue` model for Providers, Courses, Campuses, Scholarships and common governed dimensions;
- one shared stable entity registry;
- country and subdivision dimensions used as governed foreign keys;
- one shared source/profile/provider/evidence/job framework;
- source-specific staging/native tables where required to preserve authority/source grain;
- extension tables only for genuinely country-specific regulated concepts that cannot be represented safely in shared canonical structures;
- adapters/Workers own source differences, not the canonical tables;
- mapping/promotion transforms source-native records into the shared canonical model only after identity/source qualification gates pass.

Country-specific columns must not be added to shared canonical Provider/Course tables merely because one authority exposes a special field. Prefer extension/fact tables keyed to stable Provider/Course identity with source, period, audience, basis and Evidence where applicable.

## Environment model

Use the **same application codebase, migrations, adapter framework and onboarding workflow across UAT/Pilot and Production**, but retain separate environment trust boundaries.

Do not use one database/project simultaneously as UAT and Production.

Recommended promotion path:

`Development / source qualification → Pilot/UAT → accepted configuration + migration + adapter SHA → clean Production promotion`

Environment-specific items remain separate:

- Supabase project;
- Auth users/settings;
- service-role credentials;
- Vault secrets/vendor keys;
- Storage;
- job/run state;
- Evidence objects;
- Cloudflare environment/domain;
- protected GitHub deployment environment.

Promote **governed configuration/code/migrations**, not live UAT operational state or secrets.

## Onboarding lifecycle

Each onboarding case should have a durable status model such as:

`Draft → Source Qualification → Adapter Assessment → Schema Assessment → Layer 1 UAT → Layer 2 UAT → Layer 3 Ready → Operational Certification → Production Promotion Ready`

Possible terminal states:

- READY;
- CONDITIONAL;
- BLOCKED;
- PAUSED;
- REJECTED.

## Country onboarding

For a new country capture and govern:

- ISO country identity;
- subdivisions/regions;
- regulatory authority/authorities;
- Provider authority;
- Course/program authority;
- national/provider identifiers;
- source URLs/API/feed type;
- coverage claims;
- update cadence;
- licensing/usage restrictions;
- source-native pagination/batch/rate limits;
- source grain;
- identity strategy;
- canonical mapping strategy;
- source qualification result;
- adapter/Worker requirement;
- schema-extension requirement;
- Layer 1 certification result;
- Layer 2 enrichment source strategy;
- expected Layer 3 exception classes;
- Change Control/UAT/evidence references.

Future-country research should inherit the existing source-qualification discipline: no ETL/adapter implementation until a defensible Provider/Course authority strategy is accepted.

## Provider/Course onboarding

Provider and Course onboarding must prefer authoritative regulatory identity first.

A Provider/Course should not be manually invented in canonical tables merely to enable enrichment.

The workflow should determine:

1. authoritative identity source;
2. source stable identifier;
3. canonical stable key strategy;
4. Provider/Course relationship;
5. Layer 1 ingestion path;
6. Layer 2 first-party enrichment sources;
7. Evidence requirements;
8. deterministic extraction/mapping rules;
9. unresolved fields permitted for Layer 3;
10. human Layer 4 escalation conditions.

## Adapter / Worker registry

Onboarding should classify the required integration pattern rather than hard-code one Worker per country.

Preferred adapter families include:

- structured API;
- CSV/XLSX feed;
- JSON feed;
- XML feed;
- sitemap/catalogue crawl;
- HTML detail-page acquisition;
- document/PDF acquisition;
- direct HTTP;
- approved scraper/browser provider;
- custom adapter only when the generic families are insufficient.

Where a new adapter is required, record:

- adapter family;
- source contract;
- parser/version;
- batch/rate/retry policy;
- timeout;
- Evidence output;
- identity mapping;
- replay/idempotency contract;
- deployment SHA;
- automated UAT.

## Database-extension decision gate

A new country/source may request a database extension only after answering:

1. Is this concept already represented in the canonical/shared fact model?
2. Is it source-native staging only?
3. Is it a country-specific regulatory fact with its own grain/period/basis?
4. Can it be represented as a generic typed fact/relationship without losing semantics?
5. Would adding it to `catalogue.providers` or `catalogue.courses` incorrectly flatten source-specific meaning?

Default order of preference:

`existing canonical field → existing fact/relationship table → generic extension/fact table → country-specific extension table → canonical schema change only when globally valid`.

## Promotion / UAT rule

Onboarding must support UAT on the same software platform while preserving environment separation.

A country/source can be promoted toward Production only when:

- Source Qualification = PASS;
- stable identity strategy = PASS;
- adapter/Worker UAT = PASS;
- schema mapping = PASS;
- source-specific batch/rate/retry limits = certified;
- replay/idempotency = PASS;
- Evidence/provenance = PASS;
- Layer 1 invariants = PASS;
- Layer 2 bounded enrichment = PASS where applicable;
- security/negative access = PASS;
- operational runbook exists;
- Production promotion manifest references accepted migration/configuration/adapter SHAs.

## M2.3 integration

M2.3 should implement the onboarding foundation and UI sufficiently to onboard/qualify at least one representative future-country/source path without introducing an unauthorised parallel canonical model.

The onboarding workspace should integrate with **Data Operations** but remain a separate top-level menu item because it is a lifecycle/configuration workspace rather than daily ingestion operations.

Suggested top-level navigation:

- Dashboard
- Catalogue / PIM
- **Onboarding**
- Data Operations
- Data Quality
- Scholarship Selection
- Search / Publication
- Administration / Settings
- Help / Guides

## Acceptance

This Change Control closes only when the framework is represented in the maintained architecture/docs, the Admin onboarding UX exists or an explicitly accepted implementation boundary is recorded, canonical-extension rules are automated/documented, and at least one onboarding workflow is exercised through automated UAT without creating a country-specific canonical fork.