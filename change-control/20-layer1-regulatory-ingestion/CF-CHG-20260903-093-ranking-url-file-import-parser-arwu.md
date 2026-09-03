# CF-CHG-20260903-093 — Ranking URL/File Import Parser & ARWU Publisher Registration

**Status:** IMPLEMENTED / TARGETED PASS — 2026 URL REGISTRATION REQUIRES ADMIN SESSION  
**Initiated:** 2026-09-03 14:30 AEST  
**Category:** 20-layer1-regulatory-ingestion  
**Parent:** CF-091 / H12-H13  
**Related:** CF-090, CF-092, CF-089

## User outcome

Extend Administration → Sources & Imports → Register ranking publisher file so an operator can choose:
- ranking system;
- edition year;
- import method: Parse.bot URL or File upload;
- Parse import / file register+parse;
- then use the existing Parse & validate → Apply edition workflow.

QS and ARWU Parse.bot established APIs are supported. THE continues to support the existing publisher-file/native JSON/TXT parser.

## Implemented

- ARWU added as first-class `ranking.systems` code.
- `ranking-publisher-url-import` added and deployed.
- Parse.bot URL references:
  - QS: `/scrapers/e3ecc5de-f530-478a-b464-867d43099420`;
  - ARWU: `/scrapers/0f6d2cb9-c7eb-4f31-9216-f7be578e9f96`.
- ARWU reference path maps to the established execution scraper `9a025ecd-9ccb-4cf6-a454-be52e290b946` with snapshot v10.
- URL importer captures complete response(s) into private Evidence before registration.
- Parser v1.5.0 parses governed Parse.bot QS/ARWU JSON envelopes plus existing THE/file formats.
- Ranking control now parses the exact selected import ID, preventing QS direct retrieval from overriding the chosen Evidence.
- File registration accepts ARWU.
- Runtime Parse.bot provider is resolved by provider_key for Production portability.
- UI release v2.15.49 adds Ranking system, Edition year, Import method, Parse.bot scraper URL and Parse import/File register+parse actions.

## Pilot evidence

Pilot commits:
- `110acf06e517b71d95bfea8c007a7748599e0f05` URL importer;
- `df26cb10352464f609f8bd6eb41182674a7bf571` QS/ARWU parser;
- `cd637c0f9b1693afad69c464509b3ba3391e9fd4` exact selected import;
- `805c037759a4b910d29f1a74e7c811f64f9f62d9` ARWU file registration;
- `71e29faeea104e8863cfd8c71d9ba56c9ccdf7ef` client URL API;
- `0177b0191b0d05de05b50b0b5dc465be315ccfd6` Admin UI;
- `f6d6703c8e845df51e76c46e56b6b08f6b3d96fc` provider-key portability;
- `2f59bbdaa63674f275ce36beb5e272aeea501f82`, `30d22c177c3e96d22d6e9f91f16af41d5e12e7cf` migration parity.

Deployed:
- ranking-publisher-url-import v1;
- ranking-layer1-etl v8;
- ranking-publisher-control v8;
- ranking-publisher-import v4.
- targeted deployed UAT on Pilot head `30d22c177c3e96d22d6e9f91f16af41d5e12e7cf`: PASS, run `33715985168`.

## 2026 API qualification

- QS 2026 established API: HTTP 200, edition 2026, 1,504 universities.
- ARWU 2026 established API: HTTP 200, edition 2026, 892 rankings.
- Credential and endpoint qualification are PASS.

## Remaining bounded action

The management tool context does not hold an authenticated CourseFinder Admin user JWT, so it cannot legitimately call the new Admin-only registration endpoint. Do not bypass this gate.

From an authenticated Admin session:
1. QS / 2026 / Parse.bot URL / Parse import.
2. ARWU / 2026 / Parse.bot URL / Parse import.
3. Review both validation/reconciliation summaries.
4. Apply editions only after bounded reconciliation acceptance.

No canonical ranking observations were written by this implementation step.
