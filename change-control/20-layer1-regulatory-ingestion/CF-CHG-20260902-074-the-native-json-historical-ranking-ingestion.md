# CF-CHG-20260902-074 — Native THE Historical JSON Ranking Ingestion

**Status:** IMPLEMENTED / SOURCE+RUNTIME VALIDATION ACTIVE  
**Initiated:** 2 September 2026 Australia/Melbourne  
**Category:** 20 — Layer 1 Regulatory / Authoritative Ingestion  
**Related:** CF-063, CF-064, CF-067, CF-068, CF-071, A29

## Purpose

Support user-authorised Times Higher Education World University Rankings historical files in the native THE JSON response format for editions 2015–2026, preserving publisher-native ranking and indicator semantics and preventing arbitrary Provider resolution.

## Supplied 2015 artifact validation

User-supplied file: `THE_year2015.txt`.

Validated locally without modifying the source:
- prefix: `Year 2015`;
- JSON status: `success`;
- publisher rows: **1,526**;
- locations: **93**;
- Australian rows: **37**;
- SHA-256: `538984dff990e3bed1377e772238d08ffde21cb8b894bdcc2cf634ea97e38d8c`;
- rank semantics include exact, tied exact, bands such as `201–250`, and open-ended bands such as `1001+`;
- banded overall-score strings such as `50.6–54.2` are present and must not be coerced to one numeric value.

## Implementation

### Upload / Evidence

`ranking-publisher-import` v2:
- accepts THE native `.json` and `.txt` artifacts;
- validates optional `Year YYYY` header against the selected edition before Evidence registration;
- validates THE response shape `status=success` + `data.data[]`;
- retains existing private Evidence hashing/deduplication and 50 MB limit;
- `.txt` native-JSON mode is THE-only.

### Parser

`ranking-layer1-etl` v1.3.0:
- parses native THE JSON/TXT;
- preserves institution NID, name, profile path, country and raw source row;
- preserves exact/tied/banded rank display and numeric bounds;
- preserves overall score display and numeric/range bounds;
- emits indicator observations for Overall, Teaching, Research, Citations, Industry Income and International Outlook;
- verifies embedded year where supplied;
- continues to support existing CSV/XLSX publisher artifacts.

### Ranking schema / APPLY hardening

`ranking.observations` gains:
- `overall_score_display`;
- `overall_score_low`;
- `overall_score_high`.

`svc_ranking_ingest_apply` now:
- persists indicator observations idempotently;
- uses a unique accepted ranking alias or a unique exact Provider name+country match only;
- never resolves multiple exact Provider candidates by arbitrary row order;
- preserves unresolved Provider mapping as review work.

### AU Provider reconciliation

THE 2015 Australian institutions:
- exact unique: **27**;
- accepted aliases: **9**;
- deterministic mapped: **36 / 37 (97.30%)**;
- unmatched: **0**;
- ambiguous: **1 — Victoria University**.

Victoria University remains unresolved because CourseFinder has active CRICOS Providers `00124K` and `02475D`; no representative Provider is manufactured.

Accepted ranking aliases are reusable across QS/THE when the same verified institution alias already exists, avoiding duplicate alias rows.

## Browser release

Admin release: **v2.15.32**.

Administration → Sources & Imports now advertises native THE JSON/TXT support.

## Safety boundary

- Raw THE files remain private Evidence, not GitHub source files.
- No THE ranking observations were applied from the supplied attachment during this change.
- No Search, Website, Zoho or public ranking publication authority is granted.
- Historical editions remain separate publisher observations with edition-year lineage.
- Victoria University remains governed review work.

## Next operational action

Register the user-held THE 2015–2026 files through Administration → Sources & Imports (THE + matching edition year), dry-run each edition, confirm source fingerprints/counts and reconciliation, then APPLY authorised editions through the governed Layer 1 path.
