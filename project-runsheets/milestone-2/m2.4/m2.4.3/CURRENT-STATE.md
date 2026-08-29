# M2.4.3 Current State

**Status:** ACTIVE — A15 TARGETED PASS / COHORT ROLLOUT IN PROGRESS
**Updated:** 29 August 2026

## A15
- Change: CF-CHG-20260829-046.
- Target cohort: 52 AU + 8 NZ Provider profiles.
- UQ accepted proof: 8 first-party International Regional Manager territory assignments.
- Provider detail UI: implemented.
- PIM release: v2.15.10.
- Apollo adapter: implemented, Pilot credential absent; non-blocking.
- Current advisors: Security 135 INFO/0 WARN/0 ERROR; Performance 171 INFO/0 WARN/0 ERROR.
- Corrected targeted UAT: PASS `33227565016`.

## Quality rules
- first-party > governed manual > licensed enrichment;
- actionable row requires institutional email/phone or named person + territory;
- generic/noisy rows are rejected, retained historically;
- no personal-email/phone reveal from licensed enrichment;
- contact data cannot mutate Layer 1 identity/Search/Publication.

## Active rollout
Continue sequential nonce-backed batches until no Provider contact profile remains with `last_run_at is null`.
