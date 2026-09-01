# CourseFinder University Ranking Data Design v1.0

**Status:** CURRENT DESIGN — IMPLEMENTATION PENDING  
**Date:** 2 September 2026  
**Change Control:** `CF-CHG-20260902-063`  
**Execution addendum:** `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A29-QS-THE-WORLD-RANKINGS.md`

## Objective

Retain QS and Times Higher Education world-university ranking editions as reproducible, editioned Provider context with historical trends and source Evidence.

## Proposed logical model

### `ranking.systems`
- `id`
- `code` — `qs_wur`, `the_wur`
- `publisher_name`
- `ranking_name`
- `official_url`
- `active`

### `ranking.editions`
- `id`
- `system_id`
- `edition_year`
- `publication_date`
- `methodology_version`
- `methodology_url`
- `source_url`
- `source_artifact_id`
- `retrieved_at`
- `source_fingerprint`
- `source_revision`
- `access_status`
- `licensing_note`
- `status`

Unique active source version should be based on system + edition + source fingerprint/revision, not year alone.

### `ranking.publisher_institutions`
Publisher-side identity:
- `id`
- `system_id`
- `publisher_institution_id` nullable
- `profile_url` nullable
- `institution_name`
- `country_text`
- `location_text`
- `first_seen_edition`
- `last_seen_edition`

### `ranking.provider_mappings`
- `publisher_institution_id`
- `provider_id`
- `mapping_method`
- `confidence`
- `status` — accepted / candidate / rejected / superseded
- `valid_from/to`
- `evidence_artifact_id`
- `reviewed_by/at`

### `ranking.observations`
- `id`
- `edition_id`
- `publisher_institution_id`
- `provider_id` nullable projection/matched FK
- `rank_display`
- `rank_exact` nullable
- `rank_low` nullable
- `rank_high` nullable
- `is_tied`
- `rank_status` — ranked_exact / ranked_band / reporter / unranked / not_eligible / unknown
- `overall_score` nullable
- `source_row_ordinal`
- `source_row_payload`
- `evidence_artifact_id`
- `created_at`

Unique: edition source version + publisher institution.

### `ranking.indicator_observations`
Typed child rows:
- `observation_id`
- `indicator_code`
- `indicator_label`
- `value_numeric`
- `value_display`
- `unit`
- `methodology_version`

This avoids schema churn when QS/THE change indicator sets.

## Read projections

### Provider latest rankings
One latest accepted observation per ranking system:
- provider;
- ranking system;
- edition;
- exact/banded display;
- score;
- previous edition display;
- movement only when defensibly comparable;
- source/methodology.

### Provider ranking history
Bounded last 10 observations per system.

### Compare projection
Up to six Providers, preserving system/edition alignment. Never coerce QS and THE into a combined ordinal.

## Indexes

- `editions(system_id, edition_year desc)`;
- `publisher_institutions(system_id, publisher_institution_id)`;
- `provider_mappings(provider_id, status)`;
- `observations(edition_id, publisher_institution_id)`;
- `observations(provider_id, edition_id)`;
- optional `rank_exact` indexes for explicit ranking filters after consumer acceptance.

## Evidence / replay

Store source files/pages in the existing governed Evidence subsystem. Ranking tables reference Evidence IDs; do not build a second blob store.

Every apply is idempotent from edition fingerprint + publisher identity + source row. Publisher corrections create another source version and reconciliation event.

## Scheduling

Annual discovery cadence:
- QS: check around the publisher’s normal WUR release window and then periodically for corrections;
- THE: check around the annual WUR release window and then periodically for corrections.

Do not hard-code dates as invariant. Store the detected release date per edition.

## Historical bootstrap

Preferred sequence:
1. QS 2027;
2. QS 2026;
3. THE 2026;
4. QS/THE 2025;
5. QS/THE 2024;
6. continue backwards until 5 years are complete;
7. extend towards 10 years when official source editions/artifacts remain accessible and authorised.

## Data-quality reconciliation

Per edition report:
- source rows parsed;
- exact ranked;
- band ranked;
- reporter/unranked;
- mapped Providers;
- unmatched publisher institutions;
- ambiguous mappings;
- duplicates;
- rejected malformed rows;
- source revision/fingerprint;
- prior-edition row-count variance.

## Display caveats

- Institutional ranking ≠ Course ranking.
- QS and THE are independent methodologies.
- A rank movement can reflect methodology or population changes.
- Banded ranks cannot be converted to exact ranks.
- Missing/unranked is not rank 0.
