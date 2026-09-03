# CF-CHG-20260903-098 — Ranking File-First Country/Global Bundle Parser

**Status:** IMPLEMENTED / TARGETED PASS  
**Initiated:** 2026-09-03 16:57 AEST  
**Category:** 20-layer1-regulatory-ingestion  
**Parent:** CF-093 / CF-097 / H12-H13  
**Trigger:** Repeated Parse.bot testing consumed API quota without reliable ranking ingestion. User requested file-first ingestion that accepts country-scoped and global/multi-page files across QS, THE and ARWU.

## User-provided acceptance shapes

QS 2027 country exports:
- Australia: 37 universities;
- New Zealand: 8 universities;
- both use `status → data → universities`;
- both declare edition 2027 and one page.

## Implemented

### File-first acquisition
- File upload is now the preferred/default ranking acquisition method.
- Parse.bot remains an optional metered fallback for QS/ARWU.
- THE continues to use file acquisition.

### Shared JSON/TXT ranking parser
The same governed parser now accepts QS, THE and ARWU JSON/TXT Evidence as:
- one country-scoped file;
- one global file;
- multiple country files selected together;
- multiple page files selected together;
- direct API payloads;
- arrays of payloads;
- `responses` / `pages` envelopes;
- existing governed Parse.bot envelope.

### Multi-file bundle
- Operator may select multiple JSON/TXT files for the same system/year.
- Backend validates system/year consistency before registration.
- Files are combined into one governed `manual_ranking_bundle` Evidence artifact.
- Duplicate rows are de-duplicated by publisher identity/name + rank in the shared parser.
- Acquisition Job records file count, detected row count and country scope.

### Existing formats retained
- CSV/XLSX single-file ingestion remains supported.
- Existing THE native JSON/TXT remains supported.
- Existing Parse.bot QS/ARWU Evidence remains supported.
- Apply remains manual after validation/reconciliation.

### Admin UX
- release v2.15.54;
- File upload (recommended) is default;
- Parse.bot URL marked metered;
- file input supports multiple files;
- detected system/year/row count/countries are shown before registration.

## Runtime

- `ranking-publisher-import` deployed v6.
- `ranking-layer1-etl` deployed v9 / parser v1.6.0.

## Pilot commits

- `11fe91a1f7ee3b056ebf3e902e31244a92cf44c0` multi-file client upload;
- `09bbe2e6dcbc3ffcb003f3e7dbf5400eca711692` country/multi-file Evidence registration;
- `c104b2b5e275e4a0f35ca2945ba16606bfa3cb10` shared QS/THE/ARWU JSON parser;
- `5b442e6a3a9569ad0e028243902ec8f620128c16` file-first Admin UI;
- `6480573a2dc3b301b8bcf0f8f9d83a3489e480c6` v2.15.54 release;
- `b81b8c8eb9612cc1af80e5be97e8238a5a675953` title sync;
- `13a749d6614c4aaa23a23ce9efccee84d664ef8e` deployed file-bundle UAT;
- `dd94c9047a8a01db7505cbed1e325f27ea5a2f53` targeted UAT routing;
- final candidate `9a6ffc938e811a2f6e5ef8bde1565541805cb81f`.

## Validation

- Pilot Frontend Build `33726246825`: PASS.
- Deployed targeted UAT `33726246829`: PASS.
- Browser test selects two QS 2027 country files (37 AU + 8 NZ) and verifies:
  - default method is File upload;
  - multi-file input is enabled;
  - system auto-detected as QS;
  - edition auto-detected as 2027;
  - combined row count is 45;
  - Australia and New Zealand scope is shown.

The targeted test does not Apply an edition, so canonical ranking observations are not mutated by acceptance testing.

## Rollback

Revert CF-098 client/importer/parser/UI commits and redeploy prior Edge versions. Existing Evidence/import/job records remain intact.
