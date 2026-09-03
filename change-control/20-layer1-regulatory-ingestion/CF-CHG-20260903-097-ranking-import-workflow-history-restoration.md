# CF-CHG-20260903-097 — Ranking Import Workflow & History Restoration

**Status:** IMPLEMENTED / TARGETED PASS  
**Initiated:** 2026-09-03 16:20 AEST  
**Category:** 20-layer1-regulatory-ingestion  
**Parent:** CF-093 / CF-094 / CF-096 / H12-H13  
**Trigger:** User screenshot showed a ranking Parse running without visible Job lineage and older THE editions apparently disappearing from Recent imports.

## Root causes

1. Ranking import history UI hard-coded `imports.slice(0,8)`, hiding older THE editions as newer QS activity moved to the top.
2. Parse.bot URL acquisition registered Evidence but did not create a dedicated `pipeline.jobs` acquisition Job.
3. Publisher-file acquisition likewise lacked an explicit acquisition Job.
4. Validate/Apply Jobs already existed, but their linkage/count/status were not surfaced on the ranking import row.
5. The import workspace therefore looked like a direct UI action rather than the governed staged workflow.

## Live truth before fix

THE imports remained in the database:
- 2026: needs_review;
- 2025: needs_review;
- 2024–2015: validated.

QS 2026:
- status: needs_review;
- validate and apply Jobs already recorded.

No THE data was deleted.

## Implemented workflow

Each ranking import now follows:

`Acquire Evidence Job → Registered import → Parse & Validate Job → Apply edition Job → Review exceptions`

Changes:
- Parse.bot URL import creates `ranking_import_acquire` Job before fetch/Evidence registration;
- publisher-file upload creates the same acquisition Job class;
- acquisition Jobs record system/year/method/import_id/result/error;
- Validate and Apply remain separate Jobs;
- ranking import read returns latest linked Job and total Job count;
- import history loads up to 100 editions instead of 12/8;
- removed the eight-row display truncation;
- added All / QS / THE / ARWU publisher filter;
- each row shows latest Job type/status and Job count;
- `uploaded` → Parse & validate;
- `validated` → Apply edition;
- `needs_review` → Review edition, with no blind re-Apply button;
- `applied` → View module;
- Jobs button remains available per row and at workspace level.

## Existing THE recovery

No re-upload is required.

- THE 2024–2015 remain validated and can be applied individually from the restored history.
- THE 2025 and THE 2026 have already had Apply Jobs and are `needs_review`; they should be reviewed, not applied again.

## Pilot evidence

Runtime:
- `security.admin_ranking_imports_read` updated with job lineage;
- Pilot migration `cf_097_ranking_import_job_history_read`: applied;
- `ranking-publisher-url-import` deployed v3;
- `ranking-publisher-import` deployed v5;
- Admin release v2.15.53.

Pilot commits include:
- `ca7a9b6cf5342f8e82bbfbd406d372b8dc34d19b` Parse.bot acquisition Jobs;
- `01c7bf07c9660dafdbe19ffcde747e6e0fb16f00` file acquisition Jobs;
- `68ae803d6984d5d4b4d3103385d85d6f7a2547ff` full history/filter/job visibility;
- `8798789a4dd124888ec8946e943ddff9c5f74069` migration parity;
- `830b2d2768bc7c3c700e9d447164f297594097f3` v2.15.53 release;
- `bf6efc4800b2657033c2f552a3a50a27000a85b1` title sync;
- `b9cfb3b77555250d3c0f8696950a6b3a6208cbf5` JSX build correction;
- `00871c9f4146104f412c680441ad544ded556bf3` deployed workflow/history UAT;
- `eea3600aab5a172b06318b3d24ccb4ff3f91302b` targeted routing correction;
- `7e0775f4714934ac1cabf6c4555774075d13ab71` UAT status assertion correction;
- final candidate `e92e52572574fa79104d971c1146a56c4bfdccf3`.

Validation:
- final Pilot Frontend Build: PASS;
- final deployed targeted UAT run `33723730026`: PASS;
- deployed UAT proves full THE 2015–2026 history is visible;
- THE 2024 exposes Apply edition;
- THE 2025 exposes Review edition and no Apply button;
- ranking rows expose linked Job state/count.

## Important note on user's second QS 2025 run

That run began before the acquisition-job version was deployed. It is not accepted as workflow evidence and should not be repeated blindly. New attempts use the governed acquisition Job path.

## Rollback

Revert CF-097 frontend/importer/migration commits and redeploy prior Edge versions if required. Existing ranking imports/Evidence/Jobs are retained.
