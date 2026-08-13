# CourseFinder Running Build v2.10

**Date:** 13 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.7.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.9.md`

## Current programme position

- Layer 1: AU PASS; NZ PASS; CA ACTIVE/BLOCKED; GB/US/IE queued; DE deferred/blocked.
- CA Gate A Federal Provider Authority: PASS at 1,130 Providers / 1,130 DLI identifiers.
- CA Gate B Ontario public-college live acquisition/parser: PASS.
- CA Gate B canonical Course APPLY: BLOCKED on stable first-party programme identity coverage.
- CA Layer 2A StatsCan authenticated runtime parser dry-run: PASS.

## Pilot automation execution boundary

Pilot UAT no longer requires repeated browser JWT handoff for newly wired UAT workers.

Implemented:
- `pipeline.pilot_automation_keys` stores only a SHA-256 hash;
- plaintext temporary Pilot automation key is stored in Supabase Vault;
- `svc_pilot_automation_authorize(text)` is service-role-only;
- key expires 30 September 2026;
- new UAT workers may run with `verify_jwt=false` only when they retain in-function Platform Admin or Pilot-secret authorisation;
- production hardening must disable/remove the Pilot automation path.

Pilot migrations committed:
- `20260813125500_pilot_automation_secret_auth.sql`;
- `20260813125600_evidence_xlsx_mime.sql`.

## Ontario public-college parser

Worker: `layer1-ca-on-college-programs-v0.1.0`.

Supabase deployment:
- function version 1;
- ACTIVE;
- `verify_jwt=false` with mandatory in-function Platform Admin or Pilot-secret validation;
- deployment SHA-256 `fd371ef915281817b6b62701e599e4299b6e75f0fb5a2e4d8aaca1e81ea1fc89`.

Runtime UAT:
- live Ontario Data Catalogue XLSX discovery: PASS;
- current resource discovered: `ontario_public_college_programs_postsecondary_field_of_study_table_august_07_2026.xlsx`;
- evidence: PASS;
- evidence hash: `13754b3cfbf0ff6300855d9b0dcae2d1910063278db359297345009b0e95d295`;
- workbook rows: 4,522;
- Ontario college source codes: 24;
- APS coverage: 4,522 / 4,522;
- stable institutional/local programme-code coverage: 0 / 4,522.

Ontario source columns include College, MTCU Code/Title, APS Code/Title, Credential Type, CIP Code/Title and STEM/BHASE.

## Identity consequence

The accepted Course identity remains:
`UUIDv5(verified IRCC DLI + namespaced stable institutional/source-local programme key)`.

The Ontario ministry workbook does not expose a stable institutional/local programme key. APS/MTCU/CIP remain validation/classification metadata only under the accepted architecture, and titles remain mutable.

Therefore Ontario ministry data alone cannot enable canonical Course APPLY. The worker keeps `apply=true` locked with HTTP 409.

## Immediate execution

1. Verify the 24 Ontario source-college codes to existing canonical IRCC DLI Providers.
2. Select first-party Ontario college catalogue sources exposing stable programme codes/keys.
3. Build source adapters and join first-party programme identity to Ontario APS/MTCU/CIP validation metadata.
4. Run bounded dry-run, then approved APPLY/idempotency/integrity UAT.
5. Broaden Canadian provincial/institutional Course coverage.
6. Run StatsCan source-provider mapping in parallel.

## Decision

**Ontario live parser UAT is PASS, but the ministry workbook is a validation/classification source rather than a sufficient base Course identity source. CA Gate B remains BLOCKED on first-party stable programme-key coverage. Pilot automation can now execute newly wired UAT workers without repeated browser JWT handoff while preserving an explicit temporary secret boundary.**
