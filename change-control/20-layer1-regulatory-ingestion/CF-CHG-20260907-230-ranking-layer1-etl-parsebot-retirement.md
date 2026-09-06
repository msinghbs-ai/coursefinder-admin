# CF-CHG-20260907-230 — Ranking Layer 1 ETL / Parse.bot Retirement

**Status:** IMPLEMENTED IN SOURCE / DEPLOYMENT-UAT PENDING  
**Initiated:** 2026-09-07 AEST  
**Category:** 20-layer1-regulatory-ingestion  
**Milestone:** M2.4.5 — H12/H13  

## Decision

Ranking acquisition no longer uses Parse.bot.

CourseFinder ranking ingestion is now Evidence-first Layer 1 ETL:

1. obtain authorised publisher ranking Evidence;
2. register the Evidence against the ranking system and edition;
3. execute the system-specific Layer 1 ranking ETL;
4. validate reconciliation and canonical indicators;
5. apply the edition through the governed ranking workflow;
6. retain source Evidence, hashes, parser/worker version and mapping exceptions.

## Primary workers

- QS World University Rankings: `ranking-qs-official-etl`.
- Times Higher Education World University Rankings: `ranking-the-official-etl`.
- ARWU remains on the governed `ranking-layer1-etl` path until/if a dedicated official Evidence worker is qualified.

QS and THE official workers read registered private Evidence and do not require Parse.bot credentials.

## Runtime/source cleanup

Pilot source changes:

- `ranking-publisher-url-import` v2.0.0 retires ranking URL/Parse.bot acquisition and returns a controlled `410 ranking_url_acquisition_retired` response.
- `ranking-qs-url-import` v2.0.0 retires the previous URL acquisition path, including its Parse.bot fallback.
- `ranking-the-url-import` v2.0.0 retires the previous Parse.bot-backed THE URL acquisition path.
- historical Parse.bot ranking Evidence is retained for audit/replay provenance; no Evidence deletion is authorised by this change.
- generic Parse.bot configuration may remain available for unrelated Layer 2 workloads. This change removes it only from ranking acquisition.

Source commits:

- Pilot `f1ccca9a5498d08f44e40f534ad1eb090416730f` — retire shared ranking URL acquisition.
- Pilot `3f269a93627c780a42842224a59cb7ce7e1410e8` — retire QS URL acquisition/Parse.bot fallback.
- Pilot `55907ea2c329acaf4e6fc3a1e4268237292d2fae` — retire THE Parse.bot-backed URL acquisition.

## UI cleanup required before closure

The current Admin ranking registration screen still contains the historical URL/Parse.bot import method. It must be simplified to a single publisher-Evidence workflow:

- remove Parse.bot/URL ranking method and scraper reference field;
- retain publisher/source URL as provenance metadata only;
- label QS/THE imports as Layer 1 Evidence ETL;
- keep file validation, edition detection, revision warning, Jobs lineage, Apply and viewer actions;
- do not remove Parse.bot from generic Scraper Config if another Layer 2 workflow still consumes it.

Until this UI cleanup is deployed, the backend prevents accidental use by returning 410 for the retired URL routes.

## Acceptance

Required targeted checks:

- QS official XLSX Evidence validates through `ranking-qs-official-etl` and canonical QS indicators remain populated.
- THE XLSX Evidence validates through `ranking-the-official-etl`.
- applying validated QS/THE imports still uses the existing `ranking-publisher-control` Layer 1 job path.
- direct calls to all three retired URL workers return controlled 410 responses after authentication.
- Admin no longer offers Parse.bot/URL ranking acquisition after UI cleanup.
- historical imports/Evidence remain visible and exportable.
- no Production environment is created or modified by this change.
