# Coursefinder Layer 2A Canada Postsecondary Outcomes Parser UAT v1.2

**Date:** 12 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.3.md`  
**Running build:** `docs/coursefinder-running-build-v2.6.md`

## Scope

Validate the authenticated Statistics Canada PSIS acquisition/parser path without canonical outcome writes.

Worker:
- `statcan-ca-psis-etl`
- tested failed version: `v0.2.0`
- corrective version: `v0.2.1`
- `verify_jwt=true`
- Platform Admin authorisation required
- `apply=true` disabled.

## Runtime evidence

Authenticated invocation reached the worker and created pipeline job:
- job ID `21cf6d0c-86b0-4cc2-a6bd-896968910d48`
- domain `outcomes`
- job type `layer2a_outcomes`
- status `failed`
- created `2026-08-12 12:42:08.628112+00`
- completed `2026-08-12 12:42:09.992196+00`

Observed error:

`Error: HTTP 404: https://www150.statcan.gc.ca/t1/wds/rest/getCubeMetadata/37100278`

## Root cause

Implementation defect, not a StatsCan source-authority blocker.

Statistics Canada WDS documents:
- `getCubeMetadata` as POST `/getCubeMetadata` with body `[{'productId': PID}]`;
- `getFullTableDownloadCSV/{PID}/en` as GET returning a ZIP URL.

Worker v0.2.0 incorrectly used `GET /getCubeMetadata/{PID}`.

## Correction

Worker v0.2.1:
- changes metadata request to POST `/getCubeMetadata`;
- sends `[{"productId":37100278}]`;
- retains GET full-table CSV download;
- retains private ZIP evidence, SHA-256, bounded CSV parsing, source-health/job logging and no canonical writes;
- emits the Canada dual-authority identity boundary in diagnostics.

Deployment:
- Supabase function version `3`
- SHA-256 `3d069c7e3f3f87f8cafd54b8c5405d0a4c645f55711db2113e2f5152d0f51d5c`

## Canada identity UAT

Migration `050_ca_dual_authority_identity_contract.sql` is applied.

Enforced rules:
- CA Provider scheme must be `ircc_dli`;
- CA base Course scheme cannot be APS/MTCU/CIP;
- new CA Course ID is deterministic UUIDv5 from verified DLI + namespaced local programme key;
- title does not participate in identity;
- regional registration remains optional independent metadata.

RPC privilege result:
- anon execute = false;
- authenticated execute = false;
- service_role execute = true.

Ontario source metadata result:
- coverage role = `provincial_course_validation`;
- APS role = `validation_metadata_only`;
- base identity requirement = verified DLI + stable institutional/source-local programme key.

## Gate result

| Test | Result |
|---|---|
| Signed-in route reaches StatsCan worker | PASS |
| Platform Admin/job start | PASS |
| v0.2.0 WDS metadata acquisition | FAIL |
| Root cause established | PASS |
| v0.2.1 corrective deployment | PASS |
| No canonical outcome write on failure | PASS |
| Canada dual-authority DB enforcement | PASS |
| v0.2.1 authenticated parser rerun | PENDING |
| Repeat-run evidence/idempotency comparison | PENDING |
| Provider mapping -> IRCC DLI | PENDING |
| CIP/study-level/audience transform | PENDING |
| Canonical outcomes APPLY | BLOCKED |

## Current decision

**Parser runtime gate remains PENDING, not BLOCKED. The first signed-in run proved authentication and job wiring; its failure was an incorrect WDS HTTP method and has been corrected in v0.2.1. Re-run v0.2.1 before proceeding to mapping or APPLY.**
