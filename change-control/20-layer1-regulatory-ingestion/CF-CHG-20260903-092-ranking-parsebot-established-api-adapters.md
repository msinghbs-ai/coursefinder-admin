# CF-CHG-20260903-092 — Ranking Parse.bot Established API Adapters

**Status:** ACTIVE / IMPLEMENTATION DESIGN  
**Category:** 20-layer1-regulatory-ingestion  
**Initiated:** 2026-09-03 12:59 AEST  
**Origin chat:** CF M2.4.5 — H11 Provider Assets & Rankings — 2026-09-03  
**Parent:** CF-091 / H13  
**Related:** CF-089 Parse.bot control plane, CF-090 ranking import recovery, CF-063 QS/THE ranking context

## Decision

Use the user-supplied, already-established Parse.bot dataset-specific APIs for QS and ARWU instead of generating new generic Parse.bot scrapers for these ranking families.

Target coverage for both families: **2015–2026 inclusive**, retaining each edition/year separately.

## QS adapter

Reference scraper:
- https://parse.bot/scrapers/e3ecc5de-f530-478a-b464-867d43099420

Established API:
- scraper_id: `e3ecc5de-f530-478a-b464-867d43099420`
- endpoint_name: `get_world_rankings`
- base request: `GET https://api.parse.bot/scraper/e3ecc5de-f530-478a-b464-867d43099420/get_world_rankings?items_per_page=10`
- auth: `X-API-Key` from Vault only.

The exact edition/year and pagination parameter names must be learned from the established endpoint metadata/response contract or supplied documentation. Do not invent a QS year parameter if the endpoint exposes history by another field/pagination scheme.

## ARWU adapter

Reference scraper page:
- https://parse.bot/scrapers/0f6d2cb9-c7eb-4f31-9216-f7be578e9f96

Established API execution contract supplied by user:
- execution scraper_id: `9a025ecd-9ccb-4cf6-a454-be52e290b946`
- endpoint_name: `get_arwu_rankings`
- request: `GET https://api.parse.bot/scraper/9a025ecd-9ccb-4cf6-a454-be52e290b946/get_arwu_rankings?year={YEAR}`
- auth: `X-API-Key` from Vault only;
- required header: `API-Snapshot-Version: 10`;
- target years: 2015–2026 inclusive.

The difference between the reference page scraper ID and API execution scraper ID is retained as supplied and must be verified through the API response/metadata, not normalised away.

## Shared ingestion contract

Both APIs must feed the same governed ranking flow:

`API fetch → raw private Evidence → edition/year staging → schema validation → Provider/institution reconciliation → dry-run → manual Apply/acceptance → ranking observations/read projections`

Requirements:
- one immutable raw Evidence artifact per request/page/year as applicable;
- request URL/parameters excluding secret material;
- response status/content hash;
- Parse.bot scraper_id, endpoint_name and snapshot version where applicable;
- adapter version;
- source ranking family + edition/year;
- pagination/completeness counters;
- latency/vendor-unit/cost telemetry where Parse.bot exposes it;
- idempotent replay by ranking family + edition/year + source revision/hash;
- no destructive overwrite of prior editions;
- fail closed on HTTP auth errors, schema drift, missing edition/year, incomplete pagination or Provider ambiguity;
- Search/Website/Zoho publication remains separate.

## Parse.bot credential boundary

The current Vault credential previously returned HTTP 401. This remains an authentication blocker for live calls only.

Do not:
- expose the key;
- move the key into source/profile JSON;
- create a replacement generic scraper simply to bypass the 401;
- weaken H13 acceptance.

Once a valid key is stored, qualify the two established APIs directly.

## Bounded qualification sequence

1. QS: one bounded request using the established endpoint; inspect response contract and pagination/year semantics.
2. ARWU: one bounded request for a single year using `API-Snapshot-Version: 10`.
3. Register both responses as private Evidence.
4. Validate fields against ranking staging semantics.
5. Reconcile a bounded AU Provider sample.
6. Roll back any test-only canonical Apply.
7. Only then enable 2015–2026 controlled backfill loops.

## Production portability

Record these non-secret adapter identifiers/configuration in governed ranking/source profiles and Production migration inventory. The API key remains environment-specific Vault state and must be re-entered/rotated in Production.


## Live credential validation — 2026-09-03 13:48 AEST

Fresh read-only calls were executed from Pilot using the currently configured Vault secret. The secret value was not returned.

QS:
- request: `GET /scraper/e3ecc5de-f530-478a-b464-867d43099420/get_world_rankings?items_per_page=1`;
- result: HTTP 401;
- response: `Invalid API key`.

ARWU:
- request: `GET /scraper/9a025ecd-9ccb-4cf6-a454-be52e290b946/get_arwu_rankings?year=2024`;
- header: `API-Snapshot-Version: 10`;
- result: HTTP 401;
- response: `Invalid API key`.

Network/DNS/endpoint reachability is therefore proven for both established APIs. The current blocker is credential validity only.

Vault metadata:
- configured secret exists;
- last Vault secret update: 2026-09-03 09:44:50 AEST.

No ranking data was ingested, no canonical observation was changed and no routing was enabled.


## Established API qualification PASS — 2026-09-03 14:29 AEST

Fresh live calls using the rotated/current Vault credential now pass.

QS:
- endpoint: `get_world_rankings`;
- request: `?year=2026&items_per_page=1`;
- HTTP 200;
- response `edition_year=2026`;
- response confirms pagination contract: `page`, `items_per_page`, `total_pages`, `has_more`;
- 2026 reported total universities: 1,504.

ARWU:
- endpoint: `get_arwu_rankings`;
- request: `?year=2026`;
- header: `API-Snapshot-Version: 10`;
- HTTP 200;
- response `year=2026`;
- 2026 reported total rankings: 892.

This proves:
- Vault credential valid;
- QS year parameter is `year`;
- QS pagination semantics are discoverable from the response;
- ARWU year parameter and snapshot header work;
- both established adapters are execution-qualified for bounded ingestion.

Next gate:
- implement controlled 2015–2026 fetch loops;
- capture raw private Evidence per year/page;
- validate completeness before Apply;
- do not canonicalise until Provider reconciliation and dry-run pass.
