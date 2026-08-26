# CF-CHG-20260825-037 — Country / Provider / Course Onboarding Framework

**Status:** CLOSED / PASS  
**Category:** 10-architecture-data-model  
**Initiated:** 25 August 2026 22:13 AEST (+10:00)  
**Closed:** 26 August 2026 12:23 AEST (+10:00)  
**Owner:** CourseFinder architecture / Data Operations

## Decision

CourseFinder uses one reusable Country / Provider / Course onboarding framework and one shared canonical Provider/Course/Campus/Scholarship model. Source and country differences remain in source-native staging, Evidence, adapters/configuration and genuinely country-specific fact/extension tables. No country-specific canonical Provider/Course fork is authorised.

Default extension preference remains:

`existing canonical field → existing fact/relationship table → generic extension/fact table → country-specific extension table → canonical change only when globally valid`.

## Implemented lifecycle

`Draft → Source Qualification → Adapter Assessment → Schema Assessment → L1 UAT → L2 UAT → L3 Ready → Operational Certification → Production Promotion Ready`

Outcome state supports READY / CONDITIONAL / BLOCKED / PAUSED / REJECTED. Actor/time/reason/Change Control/UAT lineage is retained.

Deployed implementation is based on migration:

`20260825202903_m2_3_onboarding_lifecycle_foundation`

It provides private case/audit storage, rank-checked implementations, public SECURITY INVOKER browser contracts, stage/outcome validation, references to existing source/profile/provider/course/Evidence registries, adapter/schema decisions and the M2.3 Intelligence Onboarding workspace.

## Representative acceptance

Rollback-only AU lifecycle UAT passed:

- one representative case traversed all nine stages through `production_promotion_ready`;
- invalid stage jump was rejected;
- lifecycle outcome semantics were retained;
- 10 immutable lifecycle/audit events were observed;
- the case linked existing source/profile/provider/course/Evidence records rather than duplicate registries;
- shared schema decision explicitly recorded `canonical_fork=false`;
- curator/insufficient-rank case creation was denied;
- anonymous access was denied;
- authenticated direct access to private implementation/helpers was denied;
- synthetic UAT state was rolled back and did not persist.

This proves Source Qualification precedes adapter/schema promotion and that L3 Ready/Operational Certification do not bypass Layer 1–4 authority.

## Browser/runtime evidence

Final accepted Pilot runtime:

`msinghbs-ai/Coursefinder-Pilot@260ed6a0d19b80ad666d74b90aa13e735e802a6a`

- Frontend Build `32917685085` — PASS;
- browser smoke — PASS;
- deployed UAT `32917685022` — PASS;
- desktop `98024710961` — PASS;
- mobile `98024711090` — 29/29 PASS.

Permanent M2.3 browser UAT verifies the Onboarding workspace, lifecycle stages, shared-canonical messaging and governed controls on desktop/mobile.

## Security posture

Direct browser CRUD remains prohibited. Private tables retain RLS with no browser policy by design, elevated helpers remain non-executable by anon/authenticated, and public browser contracts remain SECURITY INVOKER.

Final Security Advisor posture is INFO-only with no WARN/ERROR.

## NZ expansion relationship

NZ first-party Layer 2 Course enrichment is not configured and is deferred to future NZ source qualification/onboarding. The accepted framework is the mechanism that must be used for that later expansion; the deferral does not require a country-specific schema fork.

## Rollback / reversion

Any lifecycle contract correction must be delivered through a forward migration and permanent UAT. Browser changes may be reverted at source SHA level. Existing immutable lifecycle history must not be rewritten during rollback.

## Acceptance

**CLOSED / PASS.** The reusable onboarding architecture, lifecycle implementation and representative negative/rollback acceptance are complete for M2.3.
