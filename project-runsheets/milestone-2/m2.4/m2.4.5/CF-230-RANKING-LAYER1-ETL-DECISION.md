# CF-230 — Ranking Layer 1 ETL strategy

**Recorded:** 2026-09-07 AEST  
**Milestone:** M2.4.5 — H12/H13  
**Status:** ACTIVE — BACKEND SOURCE COMPLETE / UI + DEPLOYED UAT REQUIRED

## Current strategy

Ranking ingestion is no longer a Parse.bot workload.

The supported operating path is:

`Publisher Evidence → Ranking import registration → Layer 1 Ranking ETL → reconciliation → Apply → Statistics / Compare`

### QS

- Primary worker: `ranking-qs-official-etl`.
- Preferred Evidence: authorised full-edition XLSX workbook.
- Canonical promotion includes overall rank/score and supported QS indicators.
- Global edition is ingested once; AU/NZ or other country views are projections/filters after ingestion rather than separate acquisition requirements.

### THE

- Primary worker: `ranking-the-official-etl`.
- Preferred Evidence: authorised full-edition XLSX workbook.
- Historical editions remain versioned by year with raw Evidence and parser version retained.

### ARWU

- Continue through governed `ranking-layer1-etl` file/Evidence route until a dedicated official-Evidence worker is justified and qualified.
- Parse.bot is not an accepted ranking acquisition route.

## Parse.bot boundary

Parse.bot may remain configured under Administration → Scraper Config only for unrelated Layer 2 extraction workloads.

It must not be:

- presented as a Ranking import method;
- called by ranking URL import workers;
- required by QS/THE ranking ETL;
- considered a Production ranking dependency.

Historical Parse.bot ranking Evidence is retained for provenance and audit. Do not delete or rewrite historical lineage.

## Source implementation

Pilot commits:

- `f1ccca9a5498d08f44e40f534ad1eb090416730f` — shared ranking URL acquisition retired.
- `3f269a93627c780a42842224a59cb7ce7e1410e8` — QS URL/Parse.bot fallback retired.
- `55907ea2c329acaf4e6fc3a1e4268237292d2fae` — THE Parse.bot-backed URL acquisition retired.

Retired URL workers return controlled HTTP 410 responses and direct operators to registered publisher Evidence + Layer 1 ETL.

## Remaining closure gate

1. Remove the URL/Parse.bot ranking import selector and scraper-reference input from the Admin ranking registration screen.
2. Keep Publisher/source URL only as provenance metadata.
3. Present `Publisher Evidence file(s)` as the only ranking acquisition control.
4. Preserve edition detection, revision warning, Jobs lineage, automatic Layer 1 validation/apply, Evidence export and Statistics viewer.
5. Remove the unused frontend `importRankingPublisherUrl` call after the UI path is removed.
6. Run targeted build/deployed acceptance for QS and THE official Evidence and verify retired URL routes return 410.
7. Reconcile CURRENT-STATE, FOLLOW-UPS, WORK-ITEM-LEDGER, MEETING-READINESS and NEXT-CHAT after deployed acceptance.

## Acceptance target

CF-230 closes only when the deployed Admin surface contains no ranking Parse.bot/URL operational control and QS/THE official Evidence successfully traverses the Layer 1 ETL path without a Parse.bot credential.
