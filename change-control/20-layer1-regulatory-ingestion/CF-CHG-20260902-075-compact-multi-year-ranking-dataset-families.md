# CF-CHG-20260902-075 — Compact Multi-Year Ranking Dataset Families

**Status:** IMPLEMENTED / TARGETED PASS  
**Initiated:** 2 September 2026 Australia/Melbourne  
**Category:** 20 — Layer 1 Regulatory / Authoritative Ingestion  
**Related:** CF-063, CF-064, CF-067, CF-068, CF-071, CF-074, A29

## Purpose

Reduce Layer 1 ranking UI sprawl by treating each annual ranking publisher as one multi-year dataset family, while preserving immutable edition Evidence and comparison history.

## User-supplied compact CSV validation

### QS Australia
File: `1_QS_Rankings_Australia.csv`
- 39 Australian universities.
- Columns: `university`, `qs_world_rank_2027`, `qs_world_rank_2026`, `official_source_url`, `source_dataset`, `confidence`.
- Selected edition determines the rank column used.
- Rank values include exact, banded and `not ranked`.

### THE Australia
File: `2_THE_Rankings_Australia.csv`
- 39 Australian universities.
- Columns: `university`, `the_world_rank_2026`, `the_overall_score_2026`, `official_source_url`, `source_dataset`, `confidence`.
- Rank and overall-score bands are preserved rather than coerced.

## Implementation

### Dataset family UI
- QS renders as one `QS World University Rankings` family card.
- THE renders as one `Times Higher Education World University Rankings` family card.
- Ranking source records are collapsed by publisher for Layer 1 Operations and Layer 1 source configuration.
- Family card exposes an Edition selector and `Upload selected edition`.
- THE provisions 2015–2026.
- QS provisions 2027 and 2026 for the currently supplied compact format.
- Existing source records remain retained; no destructive source merge/purge is performed.

### Import UX
- Ranking import is edition-first.
- Current publisher edition is selected by default: QS 2027, THE 2026.
- Official publisher URL is prefilled on system selection.
- THE accepts native JSON/TXT or compact CSV/XLSX.
- QS accepts authorised compact CSV/XLSX.

### Compact CSV parser
- Detects edition-specific fields such as `qs_world_rank_2027`, `qs_world_rank_2026`, `the_world_rank_2026`, `the_overall_score_2026`.
- Selected edition controls the field ingested.
- Compact ranking files without an explicit country/location column require a country-scoped filename such as Australia.
- This prevents accidental global name-only Provider reconciliation.
- Generic workbook ingestion remains available for normal publisher exports.

### Comparison UX
Two explicit modes:
1. **Current snapshot** — default for multi-provider comparison; latest/current available QILT year and ranking edition are selected automatically.
2. **Multi-year trend** — suited to one Provider or a bounded set of Providers; retained QILT year-specific rows and all retained QS/THE editions are displayed.

QS and THE remain independent ranking systems. Course ranking context remains inherited institutional Provider context.

## Safety boundary

- No Provider identity is manufactured.
- No ambiguous ranking Provider mapping is auto-resolved.
- No Search, Website or Zoho publication authority is added.
- Existing historical Evidence and source records are retained.
- Multi-year family presentation is a UI/operational grouping; ranking truth remains edition-scoped.

## Acceptance

- one visible ranking family card per publisher;
- edition dropdown defaults to current publisher edition;
- THE 2015–2026 upload route available from one card;
- QS compact 2027/2026 CSV schema supported;
- current snapshot comparison defaults to latest available periods;
- multi-year trend mode available;
- frontend build and deployed UAT pass;
- Security advisor remains 0 WARN / 0 ERROR.


## Targeted proof

- permanent CF-075 targeted contract commit `805a6390a05c8e6201eaf02a1a2ceffd8550c567`: frontend build **PASS**, deployed UAT **PASS**;
- latest direct family-card upload commit `1104612ac4590ea94c58c1aa12a2e57c2aacd98c`: build job `100147815603` **PASS**, browser smoke job `100147905803` **PASS**, deployed targeted UAT job `100147815947` **PASS**;
- Security advisor: **158 INFO / 0 WARN / 0 ERROR**;
- Performance advisor: **186 INFO only**.

The direct Platform Admin family-card uploader uses the same authenticated `ranking-publisher-import` service as the advanced import workspace; server-side size/type/year validation, private Evidence retention and deduplication remain authoritative.
