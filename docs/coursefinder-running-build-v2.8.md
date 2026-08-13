# CourseFinder Running Build v2.8

**Date:** 13 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.5.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.7.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE; GB/US/IE queued; DE deferred/blocked.
- CA dual-authority identity architecture: PASS.
- CA Provider authority and Course authority remain independent gates.
- CA final production gate remains blocked on federated Course-source coverage and remaining production UAT.
- CA Layer 2A StatsCan authenticated runtime parser dry-run: PASS.

## CA Provider authority

Current canonical state after live verification:
- CA Providers: 500;
- IRCC DLI identifiers: 500;
- duplicate DLI identifiers: 0;
- duplicate Provider stable keys: 0;
- orphan Provider identifiers: 0;
- CA Courses: 0.

Verified bounded slice:
- offset 500 APPLY: 500 Providers created;
- same-offset idempotency rerun: 0 created / 500 existing / 0 conflicts.

Offsets 0 and 1000 were validated only and therefore remain unapplied. Gate A is not yet full-source PASS.

Worker advanced to `layer1-ca-live-v1.1.1`:
- dry-run no longer advances the production cursor;
- `nextOffset` advances only after successful APPLY;
- dry-run exposes `candidateNextOffset` separately;
- Supabase function version 3;
- `verify_jwt=true`;
- deployment SHA-256 `34d5014a48ee01337cb9eee7f3a884e19c4744f3587961aa01e8c64321763078`.

Pilot commits:
- cursor contract: `02f9aa3e4f64b9e8bc4e0655e51cca664a8721ae`;
- corrected IRCC source URL: `6392a81f162b094d7d2d925f608f1fb93d5cbd80`.

## StatsCan Layer 2A

Worker `statcan-ca-psis-etl-v0.3.1` is accepted for authenticated parser/runtime dry-run UAT.

Deployment:
- function version 5;
- `verify_jwt=true`;
- SHA-256 `eee1f193e21e4206897d12a605aa146557062bbf2bf93719444dd3d6e42a6322`;
- Pilot commit `9f2359af3c3299e698922771d301cbfaf41314e9`.

Runtime PASS evidence:
- metadata contract PASS;
- required PSIS dimensions PASS;
- 248 institution candidates;
- private evidence captured;
- five bounded WDS institution series probes executed;
- 5/5 returned real vectors/data points with `SUCCESS` and response code `0`;
- canonical Provider/Course identity writes disabled;
- canonical outcomes APPLY disabled.

Source metadata now records `authenticated_runtime_parser_dry_run_pass`.

Next Layer 2A gate:
`StatsCan source institution -> verified pipeline.source_provider_mappings -> existing IRCC-DLI Provider`, followed by CIP/study-level/audience transforms.

## Immediate execution

1. Apply IRCC Provider slice offset 0, batch 500.
2. Re-run offset 0 for idempotency.
3. Apply IRCC Provider slice offset 1000, remaining 130 records.
4. Re-run offset 1000 for idempotency.
5. Verify full-source 1,130 Provider/DLI coverage and duplicate/orphan integrity.
6. If clean, promote CA Gate A — Federal Provider authority to PASS.
7. Continue federated Course-source integration separately.
8. In parallel, begin StatsCan source-provider mapping UAT.

## Decision

**StatsCan authenticated runtime parser gate is PASS. CA Provider Gate A remains PARTIAL because only offset 500 has been applied and idempotency-tested. The cursor defect that caused dry-run slices to be skipped is fixed in layer1-ca-live-v1.1.1. Overall CA remains ACTIVE/BLOCKED on federated Course coverage.**