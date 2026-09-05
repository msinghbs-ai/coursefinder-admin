# CF-CHG-20260906-218 — QS Canonical Reload & Compare Availability

**Status:** IMPLEMENTED / TARGETED UAT ACTIVE  
**Milestone:** M2.4.5 — H13 Ranking Acquisition & Compare UX  
**Related:** CF-212, CF-213, CF-215, CF-217

## Objective

Restore the QS World University Rankings canonical history after the CF-212 reset and ensure Compare availability is driven by retained canonical history rather than only a `latest` row.

## Root cause

The earlier QS replacement reset removed canonical QS editions/observations while 2024–2027 replacement records remained only as validation/import placeholders. Compare used `ranking_context.qs_wur.latest` as its availability test, so QS appeared disabled with no edition selector.

## Runtime corrections

1. Compare now considers a ranking available when either `latest` exists or retained `history` contains at least one edition.
2. QS 2021–2025 were reacquired from the qualified QS publisher static indicator releases, converted into Storage-backed raw JSON and generated XLSX Evidence, and applied to the canonical ranking model.
3. Ranking publisher-institution resolution now uses stable publisher ID first, then exact name/country fallback.
4. Ranking Evidence capture versions now increment per ranking edition rather than hard-coding capture version 1.
5. Service-role-only RPCs register raw Evidence without exposing the private `pipeline` schema through the Data API.
6. Failed/superseded import attempts are retained for audit but marked rejected; 2026/2027 placeholders are `needs_review` until real Storage-backed official workbooks are applied.
7. Temporary one-time backfill functions were retired after execution and now require JWT while returning HTTP 410.

## Restored canonical QS editions

| Edition | Global observations | RMIT rank | Evidence state |
|---|---:|---:|---|
| 2021 | 1,184 | 223 | Storage-backed raw + XLSX |
| 2022 | 1,300 | 206 | Storage-backed raw + XLSX |
| 2023 | 1,422 | =190 | Storage-backed raw + XLSX |
| 2024 | 1,498 | 140 | Storage-backed raw + XLSX |
| 2025 | 1,503 | =123 | Storage-backed raw + XLSX |

The edition finalizers currently report `needs_review` because a small number of Providers in supported countries remain unresolved. This does not invalidate the global ranking observations or the already reconciled Provider histories.

## 2026 / 2027 boundary

- The official user-supplied 2026 workbook contains 1,504 rows; the older publisher static endpoint exposes only 1,501 and is rejected as incomplete.
- The official user-supplied 2027 workbook contains 1,504 rows; unattended publisher acquisition is blocked.
- The configured QS Parse.bot fallback still returns HTTP 401 and is not qualified.
- 2026/2027 therefore remain `needs_review` placeholders until the exact workbook bytes are persisted to private Evidence Storage and applied through the normal parser.
- Compare must not offer these editions until canonical observations exist.

## Compare acceptance

For RMIT University after deployment, QS must be enabled and the independent QS Edition selector must offer:

- `Multi-year`
- `2025 · latest`
- `2024`
- `2023`
- `2022`
- `2021`

THE remains independent and must retain its own edition selector.

## Security

The CF-218 service RPCs are `SECURITY DEFINER` but executable only by `service_role` / `postgres`; `anon` and `authenticated` EXECUTE grants are revoked. Security Advisor after the DDL changes introduced no CF-218-specific WARN/ERROR findings. Existing unrelated INFO/WARN findings remain tracked separately.

## Repository/runtime alignment

Pilot migration sources:

- `20260905171500_cf_218_qs_evidence_service_rpcs.sql`
- `20260905171600_cf_218_ranking_import_capture_versioning.sql`
- `20260905171700_cf_218_ranking_stable_publisher_id_first.sql`

Compare UI commit:

- `4b082f7792f62abfbf5eb11db43949d5a31d3f5f` — enable ranking selectors from retained history.

## Remaining acceptance

1. Confirm final Pilot frontend/deployed UAT for the Compare availability correction.
2. Persist and apply the exact official 2026 and 2027 QS workbooks.
3. Reconcile the remaining supported-country Provider mappings through the governed mapping/L4 path.
4. Retest Compare with RMIT and at least one AU, NZ and CA Provider.
