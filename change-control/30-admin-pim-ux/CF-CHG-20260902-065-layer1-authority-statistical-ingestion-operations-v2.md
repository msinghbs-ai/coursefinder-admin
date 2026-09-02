# CF-CHG-20260902-065 — Layer 1 Authority & Statistical Ingestion Operations v2

**Status:** IMPLEMENTED / DEPLOYED TARGETED REVALIDATION IN PROGRESS  
**Initiated:** 2 September 2026, 08:50 AEST  
**Origin:** CourseFinder Layer 1 refactor v2 user request  
**Owner:** CourseFinder programme  
**Primary category:** 30-admin-pim-ux  
**Related category:** 20-layer1-regulatory-ingestion  
**UI version:** v2.15.24

## Problem

The accepted Layer 1 AU/NZ operations workspace exposed source health, current job, progress, reconciliation, Evidence, schedule, blockers and source configuration simultaneously in large expanded source panels. That model does not scale cleanly as additional countries and Layer 1 statistical datasets are registered, and it occupies excessive screen space on tablet/mobile.

## Requested outcome

Create a simple, standard, country-first Layer 1 operational surface resembling the accepted mockup:
- Australia selected by default when available;
- Country, Dataset and Status filters;
- compact Healthy / Running / Attention / Due summaries;
- compact standard dataset cards;
- manual governed Run now;
- current progress and Details;
- move authority URLs, source metadata, guardrails and cadence into Administration;
- preserve exact operational state when moving to source settings where practical;
- keep destructive maintenance away from the routine operations surface.

## Authority / semantic impact

No canonical Layer 1 identity, authority ranking, source schema, Search, Publication or downstream authority changes.

The existing governed server contracts remain authoritative:
- `admin_read('layer1_operations')`;
- `layer1_admin_command`;
- `layer1-operations-control`.

Statistical sources are presented through the same source-registry UI pattern when they are actually registered; the UI does not manufacture QILT/PRISMS or future-country source rows.

## Before

Each source card displayed seven operational/configuration sections in the default view and exposed Advanced source configuration inline.

## After

### Data Operations → Layer 1 — Authority
- renamed in-workspace purpose to **Authority & Statistical Ingestion**;
- country-first, dataset-class and status filtering;
- source-registry-driven cards rather than country-specific frontend layouts;
- Healthy, Running, Attention and Due summary signals;
- cards show source type/status, expected-count signal, Evidence count, last/next run and active progress;
- routine primary actions reduced to **Run now**, **View run** and **Details**;
- Validate, dry-run, pause/resume, retry/recover and settings remain progressively disclosed;
- reconciliation, provenance, schedule and source health move behind Details;
- responsive 3/2/1-column card behaviour for desktop/tablet/mobile.

### Administration → Layer 1 sources
Platform Admin-only source configuration now contains:
- source URL;
- authority name/domains;
- expected format;
- verification and ingestion cadence;
- variance warning/block thresholds;
- expected-record bounds;
- governance reason;
- Validate, dry-run and Save governed source actions.

No browser action was added to destructively purge retained Evidence, canonical accepted state or governed source history.

## Maintenance decision

Routine Layer 1 UI does not provide a generic purge button. Safe maintenance remains revalidation/dry-run/recovery. Any future re-acquire, re-parse, projection rebuild or bounded purge must use explicit governed semantics, dry-run where destructive, retained audit/Evidence exclusions and a separate accepted backend contract.

## Implementation

Coursefinder-Pilot:
- `28f68d5d001b519c36fb8f31305f4da3932a95b2` — compact Layer 1 v2 and Administration source-settings component;
- `c31b6f26315b681a2b466c51d1fef8de0d940d93` — Administration wiring and UI v2.15.24;
- `490c3307fba3cfb484edc218ba1c4335e28c4d1b` — release notes;
- follow-up validation/test-routing commits align title/version metadata, remove stale CF-060 version pinning and add the CF-065 targeted contract;
- current validation candidate: `3b0f0ab2785580a982cc54a0e6b4568defc07231`.

Permanent targeted source contract:
`tests/uat/cf-065-layer1-operations-v2-contract.spec.mjs`.

## UAT

Initial targeted run against `490c3307...` failed only because the unrelated CF-060 Jobs source contract hard-coded UI v2.15.20 while source correctly advanced to v2.15.24. The assertion was made version-agnostic while retaining the Jobs behaviour checks.

Candidate `3b0f0ab...` compiled successfully, but deployed targeted run `33569663659` exposed a legitimate test-integration regression: the permanent shared `openLayer1()` adapter and M2.4.1 deployed Layer 1 acceptance still targeted the pre-v2 `.l1o-*` workspace and "Layer 1 — Regulatory" heading. No backend authority failure was observed.

Corrective integration:
- `1c1b3f8caa2e888479941d2b6055e51c98d73195` — shared navigation adapter aligned to the v2 workspace;
- `850765e4af52255d04f952e0f533ab5b1d2902e7` — permanent Layer 1 deployed acceptance updated for country-first cards and progressive details while retaining real AU/NZ authority validation;
- `288590cabc3b72ae61b95ac9fae677547ce532ef` — targeted routing corrected so Layer 1 v2/support changes execute the permanent deployed Layer 1 acceptance rather than an obsolete selector path.

Deployed targeted revalidation workflow `33573716514` is running against `288590cabc3b72ae61b95ac9fae677547ce532ef`. A PASS must be recorded before this change is described as targeted-pass.

## Rollback

Revert the CF-065 Pilot implementation/test commits. No database rollback is required because this change adds no migration and changes no canonical data.

## Production boundary

Pilot/Admin UI only. This change does not create or promote Production, enable Production sources, expand Publication, change Search admission or authorise Zoho Production cutover.
