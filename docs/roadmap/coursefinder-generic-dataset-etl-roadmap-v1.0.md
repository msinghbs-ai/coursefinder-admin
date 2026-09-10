# CourseFinder Generic Dataset ETL Roadmap v1.0

**Status:** FUTURE ROADMAP / DEFERRED — NOT CURRENT IMPLEMENTATION AUTHORITY  
**Issued:** 10 September 2026  
**Programme position:** Parked for future development; current Statistics & Rankings implementation remains QS-focused unless separately authorised.  
**Related current design:** `docs/coursefinder-university-ranking-data-design-v1.1.md`, `docs/coursefinder-platform-maturity-design-v1.0.md`  
**Related backlog:** `project-runsheets/milestone-2/m2.5/PLATFORM-MATURITY-IMPLEMENTATION-BACKLOG.md`

## 1. Decision

CourseFinder will **not** generalise the current QS ranking recovery/onboarding work into a broad generic statistics/ranking ingestion framework during the active M2.4.5 pre-production hardening cycle.

Near-term scope is intentionally narrowed to:
- make the QS ranking ingestion path reliable;
- preserve all authorised QS workbook/source fields and indicator observations;
- display only the governed headline ranking fields in the normal Statistics & Rankings grid;
- retain Evidence, edition/version history, mapping review and scheduled/on-demand operational behaviour already required for QS;
- avoid introducing generic parser-generation, dynamic source onboarding or customer-extensible ETL changes into the current recovery path.

ARWU, University Diversity Index and broader generic dataset onboarding are therefore **future roadmap fixtures**, not immediate acceptance gates.

## 2. Research conclusion

The current architecture is a viable foundation for a future **metadata-driven extensible data platform** rather than publisher-specific ETL proliferation.

The preferred future model is:

`Dataset definition → Source definition → Acquire → Evidence → Schema discovery → Parser profile → Field mapping → Validate → Layer 4 review where needed → Family-specific Apply → Scheduled/on-demand Job`

Key architectural findings:

1. **Reuse the existing authority chain.**  
   Preserve `Layer 1 authoritative/regulatory → Layer 2 deterministic acquisition → Layer 3 AI-assisted interpretation → Layer 4 human resolution → governed publication`.

2. **Generic acquisition, bounded apply.**  
   HTTP, browser/Firecrawl, API, downloadable file and manual upload should eventually become acquisition adapters feeding the same Evidence/job lifecycle. Canonical mutation must remain through bounded family-specific Apply contracts rather than one unrestricted generic writer.

3. **Configuration should replace publisher-specific code where practical.**  
   Source-specific selectors, JSON paths, worksheet/header mappings, pagination strategies, field maps and deterministic validators should be versioned parser configuration consumed by hardened generic executors.

4. **Layer 3 should propose configuration, not deploy arbitrary code.**  
   Layer 3 may discover candidate fields, structures and mappings from retained Evidence, but must not dynamically generate/deploy unrestricted Edge Functions or directly mutate canonical facts.

5. **Layer 4 remains the semantic decision gate.**  
   Ambiguous source-field meanings, identity mappings, score semantics and consequential transformations require governed approval before the deterministic parser profile is activated.

6. **Manual upload is an acquisition mode, not a separate ingestion architecture.**  
   A future framework should allow the same parser/job definition to run from a publisher URL, API, browser scrape, downloadable artifact or operator file upload.

7. **Existing flexible observation models should be retained.**  
   Ranking indicator observations already avoid physical-column churn. Future statistical families should prefer typed observation/fact children for high-volume changing measures and PIM metadata for customer-variable attributes rather than turning every source field into a physical table column.

## 3. Upgrade-safe customisation principle

Future extensibility must preserve the distinction between **platform-owned schema** and **customer-owned configuration**.

Target ownership classes:

| Class | Examples | Upgrade rule |
|---|---|---|
| Platform schema | core tables, indexes, RPCs, canonical identity, Evidence/job engine | repository migrations own and evolve |
| Platform configuration | built-in attributes/families/parser strategies/validation profiles | seeded/upserted by stable code; migration may update platform-owned rows only |
| Customer configuration | custom PIM attributes/families, dataset/source definitions, parser profiles, field mappings, UI overrides, schedules | retained across upgrades; never truncated/reseeded |
| Runtime/environment | Vault secret references, provider credentials, environment enablement, project/origin settings | environment-specific; not embedded as canonical data |

Standing future principle:

> **Core is migrated; configuration is reconciled; customer customisation is never reseeded.**

## 4. Required future data-model retrofit

Do not implement these changes now. If/when this roadmap is activated, first inspect current runtime/schema and create an architecture Change Control before modifying the database.

Likely additive metadata required:

### 4.1 Dataset/source registry
Extend or replace-by-migration the existing statistics dataset registry with explicit source definitions capable of recording:
- dataset family and semantic type;
- publisher/source authority;
- source URL/API/file/manual-upload modes;
- allowed acquisition adapters and preferred/fallback order;
- environment enablement;
- licence/access notes;
- expected edition/period/country scope;
- active parser-profile version;
- source/schema fingerprint;
- drift state;
- last qualification/UAT reference.

### 4.2 Parser profiles
Introduce versioned parser metadata such as:
- parser strategy: HTML table / JSON / CSV / XLSX / browser-rendered / structured API;
- row/table/sheet selector;
- header row and data start row;
- pagination/cursor/infinite-scroll strategy;
- identity fields;
- field mapping;
- indicator mapping;
- datatype/unit/null/suppression rules;
- deterministic transformations;
- validators and expected ranges;
- source/schema fingerprint;
- status: candidate / approved / superseded / rejected;
- ownership/origin;
- minimum compatible executor/platform version.

### 4.3 Configuration ownership/versioning
PIM attributes, families and future dataset/parser/source configuration should have stable codes and explicit ownership/origin/version metadata sufficient to distinguish:
- `platform`;
- `customer`;
- `system_discovered` candidates.

Platform migrations must update only platform-owned configuration unless an explicit governed migration maps customer configuration safely.

### 4.4 Job definitions
Evolve scheduling so one approved source/parser definition can execute as:
- on-demand URL/API/browser acquisition;
- scheduled acquisition;
- manual file-upload acquisition;
- replay from retained Evidence.

All execution modes should converge on the same downstream parse/validate/map/apply state machine and common job/evidence telemetry.

### 4.5 Drift/review events
Add explicit source/parser drift events when:
- headers/selectors/JSON shape change;
- required fields disappear;
- data type/rank/score semantics change;
- row-count variance breaches policy;
- publisher identity behaviour changes.

Drift must stop or quarantine Apply when accepted parser assumptions are no longer proven.

## 5. Edge/runtime retrofit

The preferred future runtime should use a **small number of hardened generic executors**, not one custom Edge Function per publisher/customer.

Candidate responsibilities, subject to future reconciliation with whatever runtime exists then:
- acquisition orchestrator — direct HTTP/API/browser/file adapter selection;
- discovery executor — Layer 3 interpretation against retained Evidence only;
- deterministic parser executor — consumes approved parser profiles;
- bounded family Apply adapters — e.g. ranking/statistics/provider-enrichment, each with explicit authority checks;
- scheduled/on-demand orchestration — creates/links Jobs and evidence lineage.

Existing working executors such as Layer 2 acquisition and Layer 3 profile infrastructure should be **retrofitted or wrapped**, not duplicated, if their then-current contracts are still suitable.

Arbitrary generated Edge Function code is not the target design. Any genuinely custom executable extension should require a separately governed extension/plugin contract with compatibility metadata and security review.

## 6. PIM/customer customisation retrofit

Future upgrade-safe customer customisation should follow these rules:
- stable canonical facts and identities remain strongly relational;
- variable customer business fields use the PIM attribute/family model;
- changing statistical/ranking measures use typed observation/fact models;
- customer UI layout/label/visibility preferences use override metadata rather than editing platform-owned rows;
- migrations use stable codes and idempotent upsert behaviour;
- no truncate/reseed of customer-owned PIM/configuration data;
- deprecated platform configuration is lifecycle-marked/superseded rather than destructively removed where customer references may exist.

A future configuration export/import package should carry metadata such as attributes, families, source definitions, parser profiles, mappings, job definitions and display configuration, while excluding secret values and private Evidence bytes.

## 7. Retrofit impact if adopted later

A future retrofit should be staged so existing QS/THE or other accepted pipelines continue to work during migration.

Recommended sequence:

1. **Inventory current customisation and runtime contracts**  
   Catalogue PIM attributes/families, source configs, ranking/statistics pipelines, schedules, Edge Functions, Vault references, Evidence links, RPC grants and browser contracts.

2. **Introduce metadata alongside existing source-specific paths**  
   Add source/parser/job configuration tables without removing current executors.

3. **Build compatibility adapters around existing QS path**  
   Represent the accepted QS acquisition/parser contract as a parser/source profile while still calling the existing deterministic Apply boundary.

4. **Prove replay parity**  
   Run the same retained QS Evidence through old and new deterministic paths and require equivalent row counts, ranks, scores, indicators, mappings and Evidence lineage.

5. **Prove upgrade preservation**  
   Create customer custom attributes/families/parser/source/schedule configurations, apply a simulated platform migration, and verify those objects and values remain unchanged unless explicitly migrated.

6. **Add one structurally different future fixture**  
   Use ARWU or another authorised source to prove a new dataset can be onboarded without publisher-specific schema or custom Edge code.

7. **Add a second fixture with different semantics**  
   Use University Diversity Index or equivalent contextual statistics to prove the architecture does not assume every dataset behaves like a ranking.

8. **Introduce drift handling and Layer 3 rediscovery**  
   Deliberately alter fixture headers/shape and prove the job is quarantined/reviewed instead of silently ingesting incorrect fields.

9. **Migrate schedules/manual uploads to common job definitions**  
   Only after parity, replay, security and recovery tests pass.

10. **Retire publisher-specific orchestration selectively**  
    Remove old code only when every accepted operation has an equivalent, evidenced, rollback-capable generic path.

## 8. Future architecture acceptance criteria

This roadmap should not be activated merely because a generic scraper can fetch pages. Architecture acceptance should require all of the following:
- new dataset onboarding without a physical DB schema change where semantics fit existing canonical/observation models;
- URL/API/browser/file acquisition converging on one Evidence and job lifecycle;
- Layer 3 proposal with zero direct canonical mutation;
- Layer 4 approval producing replayable deterministic configuration;
- repeat run without AI assistance where source shape is unchanged;
- schema/source drift detection and quarantine;
- customer PIM/configuration surviving simulated platform upgrades;
- stable Evidence identity/replay;
- role/grant/RLS/Vault boundaries preserved;
- family-specific Apply refusing unauthorised mappings;
- export/import of configuration without secrets;
- rollback proving old accepted pipelines remain recoverable during migration.

## 9. Research required before activation

At the future activation gate, repeat research against current implementation/runtime rather than assuming this 2026 design is still optimal. Specifically evaluate:
- current generic Layer 2 acquisition capabilities and provider routing;
- current Layer 3 structured-output/profile framework;
- current Layer 4 candidate/review workflow;
- current scheduler/job-definition model;
- current PIM attribute/family ownership/versioning capabilities;
- whether parser profiles can be represented safely as metadata without creating an unbounded expression/execution language;
- suitable deterministic parsing libraries/runtimes for XLSX, CSV, JSON and browser-rendered HTML;
- configuration migration/versioning strategy;
- tenant/customer customisation boundaries if CourseFinder becomes multi-customer;
- extension/plugin compatibility strategy for exceptional executable integrations;
- performance/cost implications of generic browser acquisition and Layer 3 rediscovery;
- security threat model for user-authored selectors/mappings/transforms;
- backup/restore/export behaviour for custom configuration.

## 10. Current scope boundary — 10 September 2026

Until a future Change Control explicitly activates this roadmap:
- **QS is the only ranking ingestion/recovery path being actively hardened in the present workstream.**
- ARWU and Diversity Index are not current implementation gates.
- Do not generalise QS recovery code merely to satisfy this roadmap.
- Do not modify current DB architecture, generic PIM ownership semantics or Edge topology solely for this deferred design.
- Record future findings against this roadmap/backlog rather than reopening current QS recovery unless they directly affect QS correctness/security.
