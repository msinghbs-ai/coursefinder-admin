# CF-CHG-20260903-096 — Ranking Parse.bot Evidence Hand-off

**Status:** IMPLEMENTED / TARGETED PASS — APPLY REMAINS MANUAL  
**Initiated:** 2026-09-03 16:07 AEST  
**Category:** 20-layer1-regulatory-ingestion  
**Parent:** CF-093 / CF-094 / CF-095 / H12-H13  
**Trigger:** User screenshot showed QS 2026 Parse.bot Evidence registered as Uploaded while automatic Parse & validate raised a false “ranking Evidence required” banner.

## Root cause

The exact selected-import service RPC `public.svc_ranking_import_control_context(uuid)` returned import identity and Evidence ID but omitted `storage_path`.

The parser correctly received the selected QS 2026 import ID, but had no private Storage path from which to download the already-registered Evidence and therefore returned the misleading Evidence-required error.

## Fix

- added `storage_path`, mime/size and parse/validation context to the service-only exact-import RPC;
- added first-class ARWU source-system mapping;
- retained service-role-only execution boundary;
- repo migration parity added;
- release advanced to v2.15.52;
- no Apply/publication automation added.

## Live QS 2026 recovery

Import:
- id: `05716189-91c6-4bd1-a99a-c82104e1f409`;
- Evidence: `fe646c94-98a7-4865-88f5-5255810576c4`;
- Evidence file: `parsebot-qs_wur-2026.json`;
- private Storage object size: 2,548,660 bytes;
- source: established QS Parse.bot scraper.

Targeted deployed parser validation successfully moved the import to **validated**.

Validation result:
- candidate observations: **1,503**;
- indicator cells: **15,030**;
- unknown rank semantics: **0**;
- AU source rows: **36**;
- AU mapped unique Providers: **35**;
- AU mapped rate: **97.22%**;
- unmatched AU row: `The University of Technology Sydney (UTS)`;
- equivalent-name fan-out retained for `Victoria University`.

No edition Apply occurred. No Search/Website/Zoho publication occurred.

## Pilot commits/runtime

- `8eecda951bf0434fb8f5e7b3ec891ff24200ebaf` migration parity;
- `b49812378d802b97f5101b14f37973e79bf398c1` v2.15.52 UI version;
- `5edaabd8d866ef0083e37f5fa0f80a193063ba07` v2.15.52 release note;
- `b141b21d01fc12e7dd23f9134fd50c217922f725` document title sync;
- `8ed37278d50ddccb04c3e55db299f75c78e6c126` deployed recovery UAT;
- `6baf2be7508e736b121b25194cf5f37f4fcb9917` UAT routing;
- `da768aa1c41aba6f2b72d05c7e56bd70e4924852` decouple parser UAT from frontend deployment settle;
- `c6ecc9442751a39cf722b1c59bab89ba8af11b62` retry candidate.

Pilot migration `cf_096_ranking_import_context_storage_path`: applied.

## Acceptance

Targeted runtime result proves the selected registered Parse.bot Evidence now parses correctly. Apply remains an explicit operator decision because Provider reconciliation still contains review work.

## Rollback

Restore the previous service RPC definition if regression is found; this does not delete retained Evidence or validated import history.
