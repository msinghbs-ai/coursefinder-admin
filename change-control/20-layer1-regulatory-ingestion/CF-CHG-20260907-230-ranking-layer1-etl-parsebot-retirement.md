# CF-CHG-20260907-230 — Ranking Layer 1 ETL / Parse.bot Retirement

**Status:** CLOSED / TARGETED PASS  
**Initiated:** 2026-09-07 AEST  
**Closed:** 2026-09-07 AEST  
**Category:** 20-layer1-regulatory-ingestion  
**Milestone:** M2.4.5 — H12/H13  

## Decision

Ranking acquisition no longer uses Parse.bot.

CourseFinder ranking ingestion is Evidence-first Layer 1 ETL:

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
- Pilot `ea8a107035e8164a14fefcafd9ff48f33fcea6e5` — add Evidence-only ranking Admin surface guard.
- Pilot `1f63ff2e55593728f1d6b8096c5c003682a4e6d0` — load Evidence-only ranking Admin surface.
- Pilot `11ff1a99a1884d11d48aeb1e698557df1f0f0110` — targeted CF-230 ranking acceptance candidate.

## Admin operator workflow

The active Sources & Imports ranking workflow is now:

`Publisher Evidence → registered import → Layer 1 Ranking ETL → reconciliation → apply → Statistics/Compare`

Operator-facing changes:

- ranking URL/Parse.bot import method is not exposed;
- scraper reference controls are not exposed;
- publisher/source URL remains provenance metadata only;
- QS/THE are described as dedicated Layer 1 Ranking ETL paths;
- file validation, edition detection, revision warnings, Jobs lineage, Apply, export and viewer actions remain available;
- complete global publisher Evidence is preferred; supported same-edition country/page bundles remain accepted where necessary.

## Acceptance result

Targeted acceptance candidate: Pilot `11ff1a99a1884d11d48aeb1e698557df1f0f0110`.

GitHub status:

- `coursefinder/deployed-uat/targeted/chromium-desktop` — **SUCCESS**
- workflow run `34057703740`

Accepted behaviour:

- QS official Evidence remains on `ranking-qs-official-etl`.
- THE official Evidence remains on `ranking-the-official-etl`.
- validated QS/THE imports continue through the governed `ranking-publisher-control` Layer 1 job path.
- retired ranking URL workers remain backend-blocked.
- Admin no longer exposes Parse.bot/URL ranking acquisition.
- historical imports/Evidence remain available for provenance and export.
- no Production environment was created or modified by this change.

## Non-blocking cleanup debt

The legacy `mature-main.jsx` and browser API wrapper still contain unreachable historical URL-mode symbols. They are not operator-accessible and cannot execute a ranking acquisition because the UI hides the path and all ranking URL workers are retired server-side.

Physical removal is a source-maintenance task only. It must:

- remove `rankingParsebotRef`, URL-mode form state/branches and Parse.bot copy from the legacy React source;
- remove the obsolete `importRankingPublisherUrl` browser wrapper;
- remove the temporary DOM guard only after the native React panel is Evidence-only;
- retain the 410 retirement workers for explicit compatibility/audit behaviour unless a later governed removal is approved;
- run the same targeted ranking UAT after cleanup.

This cleanup does not reopen CF-230 and must not reintroduce URL or metered ranking acquisition.