# CF-CHG-20260903-095 — Ranking Release Currentness & QS 2027 Parse.bot Error Handling

**Status:** IMPLEMENTED / TARGETED PASS  
**Initiated:** 2026-09-03 15:52 AEST  
**Category:** 20-layer1-regulatory-ingestion  
**Parent:** CF-093 / CF-094 / H12-H13  
**Trigger:** User screenshot showed new ranking controls while release badge still reported v2.15.48 and QS Parse.bot error rendered as `[object Object]`.

## Root causes

1. Release-version drift:
   - `src/mature-main.jsx` had advanced to v2.15.50;
   - `src/pim-version-entry.js` remained v2.15.48;
   - `index.html` title remained v2.15.47.
2. Previous targeted deployed UAT could pass without asserting the ranking release/version contract.
3. QS 2027 Parse.bot established API currently returns HTTP 500 `extraction_failed` because the underlying TopUniversities payload does not match the expected shape.
4. Ranking URL importer stringified nested Parse.bot error objects as `[object Object]`.

## Fix

- synchronised release surfaces to **v2.15.51**;
- added v2.15.51 release note;
- QS Parse.bot defaults to **2026**;
- QS 2027 remains selectable but Parse.bot URL mode shows a warning and disables Parse import while the upstream extraction remains invalid; file upload remains available;
- Parse.bot nested provider errors now surface the actual message;
- QS URL importer uses 100-item pages to align with the established API response contract;
- added permanent deployed CF-095 currentness UAT;
- updated deployed-UAT routing so the dedicated test runs for ranking release/currentness changes.

## Live evidence

- QS 2027 direct Parse.bot reproduction:
  - HTTP 500;
  - kind: `extraction_failed`;
  - message: `Rankings payload did not match the expected shape.`
- QS 2026 direct Parse.bot:
  - HTTP 200;
  - edition 2026;
  - total 1,504;
  - 100 rows/page; 16 pages.
- ranking-publisher-url-import redeployed as v2.
- final Pilot head: `791573c4a26903ab3ed5cffe7ce8711af63efba8`.
- Pilot Frontend Build triggered on final head.
- deployed targeted UAT run **33721019815**: **PASS** against the live Worker, explicitly asserting:
  - release badge v2.15.51;
  - QS default edition 2026;
  - Parse.bot QS scraper reference;
  - QS 2027 warning and disabled Parse action.

## Pilot commits

- `e49f64901947f9597ed5f4b20a3dbb63ad879c54` UI/default-year correction;
- `f2df8463c61190a2a43234e6e3eae85b39f717e7` release v2.15.51;
- `5a2b05537dfdb823352802e030c67eda16eb77cb` document title sync;
- `0358ac80a6e90dd377d56b54e02ead9b902a3efa` nested Parse.bot error handling;
- `7e53bc1807c65c9d285c9ea123edeb00973719b7` dedicated deployed UAT;
- `b121fad313234087775e939b957e32b1135a0f0f` UAT routing;
- `791573c4a26903ab3ed5cffe7ce8711af63efba8` nominated deployed candidate.

## Rollback

Revert the listed UI/release/importer/UAT-routing commits and redeploy the previous ranking URL importer version if regression is found. No canonical ranking observations were mutated by this correction.
