# CourseFinder University Ranking Data Design v1.1

**Status:** CURRENT DESIGN — MULTI-COUNTRY EDITION SCOPE ACCEPTED  
**Date:** 3 September 2026  
**Supersedes:** `docs/coursefinder-university-ranking-data-design-v1.0.md`  
**Change Controls:** `CF-CHG-20260902-063`, `CF-CHG-20260903-100`  
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


## Manual publisher artifact fallback

When a historical publisher page/download is unavailable to automation because of authentication, registration, paywall or bot controls, CourseFinder must not circumvent the restriction.

A privileged operator may instead upload an authorised publisher artifact into the existing private Evidence bucket.

Required import metadata:
- ranking system;
- edition year;
- publisher/source URL;
- licence/access note;
- original filename/MIME/size;
- methodology URL/revision where known;
- uploader and upload timestamp;
- file hash/Evidence ID.

The ingestion lifecycle is:
`uploaded → validated → parsed → reconciled → applied`.

Upload is not apply. Duplicate file hash + ranking system + edition is idempotent/rejected as duplicate. Unresolved institution mapping remains review work.

The Statistics & Rankings workspace is the verification surface for imported editions and historical coverage.


## Multi-country same-edition ingestion rule — CF-100

A ranking year/edition is global publisher identity, not a country-specific dataset identity.

For example:

`QS WUR 2027` is one logical edition.

Australia, New Zealand, Canada, the United Kingdom, the United States, Ireland and later countries are scope slices of that same edition. Do not create parallel logical editions such as `QS 2027 AU`, `QS 2027 NZ` or `QS 2027 CA`.

### Scope model

Use:

`ranking system → edition/year → source revision/Evidence bundle → country-scoped publisher institutions/observations → canonical Provider mappings`

The country dimension belongs to publisher institution / observation scope and reconciliation, not to the edition key.

A single edition may therefore be populated incrementally:

- Day 1: AU + NZ Evidence;
- Day 30: CA Evidence;
- later: GB / US / IE Evidence;
- final: global or remaining-country Evidence.

Each later country addition extends edition coverage without replacing or invalidating already accepted country observations.

### Source revision and Evidence handling

For the same ranking system/year:

- each upload/fetch receives its own Evidence fingerprint and acquisition metadata;
- a multi-file same-edition upload may be registered as one governed Evidence bundle;
- later country additions may form a new source revision or additional Evidence bundle linked to the same logical edition;
- exact duplicate content is idempotent and must not create duplicate observations;
- corrected publisher data supersedes only matching source rows/scope after reconciliation; it must not wipe unrelated countries.

### Required scope identity

For ingestion/replay, the effective natural identity is:

`system + edition_year + publisher_institution identity + source revision/fingerprint`

Country must participate in reconciliation whenever publisher institution identity is name-based or publisher IDs are not globally stable.

Name-only matching is never global. Exact normalised Provider-name matching must be constrained to the same country.

### Partial-country coverage

An edition can be:

- **Partial** — only some target countries loaded;
- **Complete for selected countries** — all expected in-scope Providers for those countries reconciled;
- **Global/Publisher complete** — complete source population where authorised and verifiable.

The UI must distinguish edition existence from country completeness.

Example:

`QS 2027 — 45 observations — AU complete / NZ complete / CA not loaded`

must not be shown simply as “QS 2027 complete”.

### Country backfill workflow

When another country is added later for an already-existing year:

1. select existing ranking system + edition year;
2. choose/upload/fetch the new country or global Evidence;
3. detect country scope from payload and validate against operator selection where supplied;
4. register Evidence under the existing logical edition;
5. stage rows;
6. reconcile publisher institutions against canonical Providers within the same country;
7. classify matched / unmatched / ambiguous / equivalent-fanout rows;
8. preview net-new / changed / duplicate counts;
9. manually Apply accepted scope;
10. update country coverage for the edition.

No existing accepted country scope is deleted merely because another country is added.

### Re-run / correction behaviour

If a country is re-imported for the same edition:

- unchanged rows remain unchanged;
- new institutions are inserted;
- changed ranking values become the new accepted source revision only through the governed Apply gate;
- disappeared rows are not automatically deleted or treated as unranked; they require source-revision reconciliation;
- Evidence history remains retained.

### Comparison behaviour

Provider comparison must align by:

1. ranking system;
2. same edition/year where possible;
3. Provider country-independent canonical identity after country-safe publisher mapping.

A cross-country Provider comparison is valid for global ranking systems such as QS/THE/ARWU because the publisher edition is common.

For country-specific statistical datasets such as QILT or PRISMS, cross-country comparison must not manufacture equivalent metrics. Those datasets retain their own country/native grain and can only be compared where a governed metric crosswalk exists.

### Dataset-family strategy beyond rankings

The same structural principle applies to future multi-country statistical families, but with a distinction:

- **Global publisher datasets**: one family + one edition, countries as observation scope.
- **Country-native government/regulatory datasets**: separate country-scoped family codes under a shared semantic group.

Examples:

Global ranking:
`qs_wur → 2027 → AU/NZ/CA/GB/US/IE observations`

Country-native statistics:
`au_qilt_gos → 2026`
`nz_<accepted-outcomes-family> → 2026`

These may share a UI category such as “Graduate outcomes”, but they remain different source-authority families unless an explicit semantic crosswalk is accepted.

### Admin/PIM UX

Statistics & Rankings should expose:

- Dataset/system;
- Edition/year;
- Country coverage chips;
- loaded row count by country;
- mapped/unmapped/ambiguous count by country;
- Evidence/source revision;
- last verified;
- status: Partial / Country-complete / Global-complete;
- Add country data;
- Add revision;
- Compare only where semantics are aligned.

This prevents operators from creating duplicate year cards while making later-country ingestion obvious and safe.
