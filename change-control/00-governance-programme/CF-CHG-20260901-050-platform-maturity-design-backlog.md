# CF-CHG-20260901-050 — Post-M2.4 Platform Maturity Design & Implementation Backlog

**Status:** APPLIED — DESIGN BASELINE / IMPLEMENTATION DEFERRED TO OWNING GATES  
**Category:** 00-governance-programme  
**Initiated:** 1 September 2026 AEST (+10:00)  
**Origin chat/workstream:** CourseFinder platform maturity queries and future addenda  
**Owner:** CourseFinder programme governance  
**Change class:** architecture / product design / operations / UAT / future implementation planning

## Trigger

Post-M2.4 maturity questions require a durable design covering Scholarships, Provider groups, country source onboarding, UAT, performance, Layers 2–4, future scrapers/AI, manual catalogue intervention, storage, retention and manual blocking.

M2.4 is CLOSED/PASS and must not be reopened for these improvements.

## Decision

Create:
- `docs/coursefinder-platform-maturity-design-v1.0.md`;
- `docs/coursefinder-uat-performance-baseline-v1.0.md`;
- `project-runsheets/milestone-2/m2.5/PLATFORM-MATURITY-IMPLEMENTATION-BACKLOG.md`.

The documents distinguish current accepted capability, designed-but-unimplemented structures and new implementation work. Individual backlog items require their owning M2.5/M3/M4/future gate before runtime changes.

## Key design decisions

- Scholarship relationships use typed evidence-backed scopes/course links; structural scope is not student eligibility.
- G8/provider groupings use institution collections and memberships, not hard-coded Provider booleans.
- country/source Production readiness is environment-specific.
- manual entity creation is provisional pending authoritative reconciliation.
- Layer 4 edits remain append-only/audited.
- blocking is reversible state, not deletion.
- scrapers/AI models require governed profile qualification before Production enablement.
- storage/retention are first-class operational controls.
- Website/Zoho consumer caching uses version invalidation.
- accepted performance budgets remain unchanged.

## Semantic impact

No current canonical data semantic change. This is a design/backlog baseline only.

## UAT

No runtime UAT required for design-only change. Existing accepted M2.4.4 final UAT remains authoritative. Future PM addenda define new UAT cases.

## Closure

**Final status:** APPLIED — DESIGN BASELINE  
**Outcome:** Platform-maturity questions converted to governed design and implementation backlog without reopening M2.4.
