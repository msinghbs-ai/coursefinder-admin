# AER University Reader Status register

**File:** `docs/monitoring/AER_University_Reader_Status.csv` (canonical). **Owner:** `S1-Build` (since 23 Nov 2026; taken over from `S2-Build` and `S2-RM-Design`). **Engineering owner of the readers:** `S2-RM-Design` (the `owner_lane` column).
**Snapshot:** 23 Nov 2026 16:40 AEDT. Read-only: rolled-back reads of the live project; nothing written, run or changed.

## Scope

- **Rows:** every provider in AU, NZ and CA with at least one active course. That is 1,886 providers: AU 1,544, NZ 290, CA 52.
- **Active courses:** 36,046 (AU 25,703, NZ 6,514, CA 3,829), the same as the active-course denominator.
- **Universities:** `provider_type` says which providers are universities (university, university college or wānanga) and which are other higher-education or VET providers, so the register can be filtered to universities.
- **Order:** sorted by country (AU, NZ, CA), then active courses from most to fewest. `rank` is the position within the country.

## Columns

| Column | How it is computed |
|---|---|
| `national_code` | The provider's CRICOS (AU), NZQA (NZ) or IRCC DLI (CA) identifier |
| `has_registered_source`, `source_count` | `pipeline.entry_matrix_sources`. **Yes:** at least one source is read. **Draft:** sources are registered but none is read (failed, robots or blocked). **No:** no source is registered. The count excludes inactive sources |
| `aer_source_url`, `storage_artifact_path` | The best registered source, in this order: read first, then rank, then the latest read. The path is its stored snapshot. A provider with no source shows its latest stored course-page snapshot that the deterministic AER reader used |
| `source_type` | A URL ending `.pdf` is `PDF_TABLE`. An inventory shape of `html_table` is `HTML_TABLE`, and `selector` is `HTML_ACCORDION`. A read source whose matrix rows trace to it is `HTML_TABLE`. With no source but stored course pages: `SHARED_HUB_s670` when at least half the provider's courses sit on a page shared with another course, otherwise `HTML_COURSE_PAGE`. Anything else is `Unknown` |
| `aer_admitted_courses`, `aer_admitted_pct` | Active courses covered by the live academic-entry coverage rule (`security.aer_covered_courses_v1`, including the `s1000` v3 course-row part) |
| `fallback_to_course_row_count` | Courses covered only by the `s1000` course-row rule: not by a provider minimum, a per-course matrix row or an override row |
| `courses_with_official_url` | Active courses with an active `official_course` link |
| `courses_on_shared_hub_s670` | Active courses whose bound course page is also bound to another course |
| `courses_no_url` | Active courses with neither an official link nor a bound page |
| `aer_held_l4_count` | Pending Layer 4 AER items (course first reads and matrix items) that the machine check has held |
| `aer_pending_queue_count` | Pending Layer 4 AER items not yet checked |
| `l4_blocker_reason` | The most common held reason among the provider's pending items: `all_rows_held`, `gate_incomplete`, `identity_not_admitted`, `no_bound_page` or `active_rows_exist`. `NONE` if there is none |
| `last_reader_run_utc` | The latest of: the deterministic AER page read, the source read, and the machine check |
| `daily_admitted_delta` | The change in `aer_admitted_courses` against the previous CSV on `main` (a signed whole number, `0` when unchanged); `new` for a provider with no row in the previous CSV; `n/a` only on the first snapshot |

## `reader_status`

Rules are applied in this order. The first match wins.

1. **Site Blocked:** nothing admitted, and either the registered sources are refused (robots, HTTP 403 or 429) with none read, or at least half of 5 or more course-page reads were refused.
2. **No Reader Yet:** no registered source and nothing admitted.
3. **Fully Working:** a read source, at least 80% admitted, and no pending Layer 4 item.
4. **Stuck in Layer 4:** a source (`Yes` or `Draft`), pending Layer 4 items, and either under 25% admitted or a blocking reason (`all_rows_held`, `gate_incomplete`, `identity_not_admitted`, `no_bound_page`).
5. **Partial - Low Confidence:** anything else with at least one course admitted. This includes 80% or more with Layer 4 items still open, and course-page admission without a registered source.
6. **No Reader Yet** (remainder): a source is registered but nothing is admitted and nothing waits in Layer 4.

## Daily refresh

The register is refreshed every day at 08:00 AEDT by `S1-Build`'s scheduled task (Platform Admin, 23 Nov 2026 16:33). Runbook and scripts: [`aer-reader-status-refresh/`](aer-reader-status-refresh/README.md). The reads are rolled-back dry runs that start only when the shared dry-run queue is clear; nothing is applied.
