# CF-CHG-20260905-213 — QS URL Acquisition, Generated Excel Evidence & Export

**Milestone:** M2.4.5  
**Domain:** Layer 1 / Rankings  
**Status:** IMPLEMENTED BACKEND / UI FOLLOW-UP  
**Date:** 2026-09-05

## Intent

Replace ad-hoc QS country/page ranking imports with a governed World University Rankings acquisition path that can start from an approved QS publisher URL, retain raw Evidence, generate an edition-compatible XLSX Evidence artifact, validate it through the same QS workbook parser, and optionally Apply it through the existing ranking reconciliation contract.

The generated XLSX is also the governed export artifact for the edition. It is private Evidence and is exposed only through a short-lived signed download.

## Accepted acquisition contract

`QS World Rankings URL → approved QS dataset/API route → raw private Evidence → generated XLSX Evidence → QS workbook parser → reconciliation preview → explicit Apply → ranking projections`

Rules:

- Only `https://www.topuniversities.com/world-university-rankings` and its `/YYYY` edition path are accepted for QS URL acquisition.
- URL edition must match the selected edition.
- Arbitrary remote URL fetching is prohibited.
- Raw publisher/API response must be written to private Evidence before the generated XLSX is registered.
- Generated XLSX must be persisted in the private `evidence` bucket before parsing starts.
- A supposed global QS edition must contain at least 1,000 institutions.
- Year-specific indicator completeness is checked before an official static QS dataset is accepted.
- If the direct QS source is incomplete or access-blocked, the established QS Parse.bot adapter may be used only when its credential and response contract are qualified.
- If neither route produces a complete edition, acquisition fails closed. A partial dataset must never be relabelled as a global QS edition.
- Apply remains governed; URL acquisition defaults to validated/dry-run state.
- No Provider identity is created or merged from ranking acquisition.

## QS release map and current source qualification

| Edition | QS release NID | Current direct-source result | Outcome |
| --- | --- | --- | --- |
| 2021 | `2057712` | 1,184 rows; six legacy indicators | Qualified |
| 2022 | `3740566` | 1,300 rows; six legacy indicators | Qualified |
| 2023 | `3816281` | 1,422 rows; eight indicators | Qualified |
| 2024 | `3897789` | 1,498 rows; nine indicators | Qualified; matches official workbook count |
| 2025 | `3990755` | 1,503 rows; nine indicators | Qualified; matches official workbook count |
| 2026 | `4061771` | static source returns 1,501 rows but lacks required indicator columns | Not qualified; official XLSX/fallback required |
| 2027 | `4153156` | publisher REST blocked from Pilot egress | Not qualified; official XLSX/fallback required |

The corrected 2023 WUR release is `3816281`. The previously explored `3846211` route is not the governed World University Rankings release and must not be used for this dataset.

## Indicator coverage

Historical columns are edition-aware; fields are not manufactured for years in which QS did not publish them.

- 2021–2022: Academic Reputation, Employer Reputation, Faculty Student Ratio, Citations per Faculty, International Faculty Ratio, International Student Ratio.
- 2023: the above plus International Research Network and Employment Outcomes.
- 2024–2025: the above plus Sustainability.
- 2026 official workbook additionally includes International Student Diversity.
- 2027 official workbook retains IRN, Employment Outcomes and Sustainability; no ISD field is manufactured when absent.

QS indicator IDs currently reconciled from publisher metadata include `76`, `77`, `36`, `73`, `18`, `14`, `15`, `3819456`, and `3897497`.

## Generated workbook contract

Each generated workbook contains:

1. **Rankings** — QS-compatible multi-row header layout with overall rank, previous rank where deterministically available, institution/location fields, each available indicator SCORE/RANK pair, Overall SCORE, and hidden Publisher ID/Profile URL provenance columns.
2. **Raw Source** — unmodified source fields retained for audit/replay.
3. **Evidence Metadata** — source URL, edition, acquisition mode, QS release identifier, generation timestamp, generator version and row count.

Generated filename:

`{year} QS World University Rankings CourseFinder Evidence.xlsx`

The generated workbook does not fabricate QS Size/Focus/Research/Status values when the source route does not provide them.

## Parser / database changes

`ranking-qs-official-etl-v1.1.0`:

- understands the official/generated QS multi-row XLSX format;
- preserves exact, tied and banded overall ranks;
- preserves available QS indicator scores and ranks;
- rejects global workbooks under 1,000 institutions;
- fails when excessive unknown rank semantics are encountered;
- treats impossible QS score values outside 0–100 (including sentinel-like values such as `1111`) as null rather than valid scores.

`ranking.indicator_observations` now retains:

- indicator group;
- rank display;
- exact/low/high rank semantics;
- tied state;
- rank status.

This prevents indicator rank information from being retained only in Evidence while being lost from the canonical ranking observation model.

## Runtime components

- `ranking-qs-url-import` — authenticated QS URL acquisition, raw Evidence retention, XLSX generation and validation/apply orchestration.
- `ranking-qs-official-etl` — QS XLSX parser and Apply worker.
- `ranking-publisher-url-import` — backward-compatible router; a TopUniversities WUR URL delegates into `ranking-qs-url-import`, while existing governed Parse.bot/ARWU routes remain intact.
- `ranking-publisher-control` — QS validate/apply is routed through the QS workbook parser.
- `ranking-evidence-export` — authenticated short-lived signed export of the stored XLSX Evidence artifact.

## Security controls

- QS URL acquisition requires an authenticated operator with role rank >= 4.
- Export requires an authenticated CourseFinder user and returns a five-minute signed private Storage URL.
- Service-role keys remain server-side.
- Direct ranking ingest RPC execution is revoked from `public`, `anon` and `authenticated` and retained for `service_role` only.
- Temporary CF-212/CF-213 source-probe functions used during qualification are retired, JWT-protected and return HTTP 410.
- Supabase Security Advisor after the change shows no new CF-213/ranking-specific WARN/ERROR. Existing unrelated INFO and Layer 4/scholarship SECURITY DEFINER warnings remain open under their existing governance.

## Current limitations / blocked source routes

- The current Parse.bot QS credential returns HTTP 401, so it is not a usable live fallback until corrected/qualified.
- Consequently 2026 and 2027 URL acquisition currently fail closed rather than produce incomplete generated workbooks.
- Authorised official 2026/2027 XLSX files remain the valid fallback path.
- Existing 2024–2027 replacement import rows created during CF-212 point to `inline://` placeholders and must not be treated as persisted Storage Evidence. They require regeneration via this URL path where qualified or a real governed workbook upload.

## Repository/runtime references

Pilot commits introduced during CF-213:

- `7f2fd5d1d7712d52db55383d86c98f8547645054` — QS official/generated workbook parser.
- `01a84cd3813d0353337c24659939749501056ef2` — QS URL acquisition and generated XLSX Evidence.
- `d09f50a67a2ffb044281b825eca81fac565c43d2` — governed ranking Evidence export.
- `e7789806b3373e658bc72d386178c8d39cf6d1e5` — QS control routing.
- `49c580b19f0ad6bde4bf1647de6ec6fb90342bde` — indicator rank semantics migration.
- `e4331561059ce3b9e636c7cda18046a820d90906` — QS publisher URL delegation through existing URL import control.

## Acceptance remaining

Backend/runtime contract is implemented. Before CF-213 is marked targeted PASS:

- expose explicit **QS Publisher URL → Evidence XLSX** labels in Administration rather than the legacy Parse.bot wording;
- expose **Export XLSX** in ranking import history / ranking edition UI;
- run authenticated 2021–2025 acquisition through the operator surface and verify generated workbook counts and parser dry-runs;
- resolve/re-upload 2026/2027 official workbook Evidence and Apply only after successful dry-run/reconciliation;
- add targeted deployed UAT covering URL allowlist, fail-closed partial source handling, generated Evidence registration and signed export.
