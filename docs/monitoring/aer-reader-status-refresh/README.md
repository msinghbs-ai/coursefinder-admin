# AER University Reader Status: daily refresh (runbook)

**Owner:** `S1-Build`. **Schedule:** daily at 08:00 AEDT (Platform Admin, 23 Nov 2026 16:33), as a scheduled Claude task.
**Outputs:**
- `docs/monitoring/AER_University_Reader_Status.csv`: the canonical register. Columns and rules are in `docs/monitoring/AER_University_Reader_Status.md`.
- The Drive sheet `Monitoring / AER_University_Reader_Status`: tabs `AU_Universities`, `NZ_Universities` and `CA_Universities`, and the `Summary` tab.

**Read only.** The live project is read through the shared rolled-back dry run (`db-migration-dry-run.yml`, workflow_dispatch, Pilot branch `s1-build-diag`).
- No migration is merged, nothing is applied, and no interactive SQL is used.
- Each dispatch waits until no other dry run is queued or running, so a pull request's check is never displaced.
- Nothing in the Pilot repository, the AER readers, Layer 4 or another lane's domain is changed.

## Files

| File | What it does |
|---|---|
| `sliceA.sql.tmpl` | One slice of providers (24, ordered by id): per-provider counts for admission, links, shared pages, Layer 4, fallback, last run and blocks. `@OFF@`, `@LIM@` and `@K@` are filled in by the runner |
| `sliceB.sql.tmpl` | One slice of the providers that have a registered source or a stored course-page read (12): best source URL, inventory shape, stored snapshot path and matrix rows |
| `dispatch_slices.sh` | Runs a list of slice files in one rolled-back dispatch, then collects each slice's text |
| `build_register.py` | Builds the CSV: ranks, percentage, source type, `reader_status`, and `daily_admitted_delta` against the previous CSV. It also builds `sheet.json` for the Drive sync |
| `refresh.sh` | The whole run: 90 A slices and 40 B slices in three dispatches, completeness checks, then the build |
| `sheet_payloads.py` | Turns `sheet.json` into the exact Sheets writes (one JSON file per call: clear, tab chunks of 100 rows, Summary rows, KPI cells), so no number is retyped |

## Daily procedure

1. Run `bash docs/monitoring/aer-reader-status-refresh/refresh.sh <pilot clone> <admin clone> <work dir>`.
   - It stops with a non-zero exit if a slice is missing or the provider list has outgrown the slice count (the last slice must be empty).
   - In that case, report it and commit nothing.
2. Check the totals the builder prints.
   - The active courses per country are the live denominator.
   - Every provider with active courses is one row.
3. Copy the CSV to `docs/monitoring/AER_University_Reader_Status.csv` on a branch from `origin/main`. Open an admin pull request with the `automerge` label, and confirm it merged.
4. Sync the sheet from `sheet.json`, using the Google Sheets connector. Run `python3 sheet_payloads.py <work>/sheet.json <work>/sheet --snapshot "<snapshot line>"` and send each file in name order.
   - **Tab rows:** for each `*_Universities` tab, clear from `A1` and write the tab's rows in chunks of 100 or fewer. Add grid rows first if the tab is too short.
   - **Tab scope:** AU takes university, university college and higher-education institute. NZ takes university, wānanga and polytechnic. CA takes every provider (no provider type is held).
   - **Summary tab:** write `summary_rows` to `Summary!A11:M15` (column A is blank), the snapshot line to `Summary!B3`, and the KPI lines to `B6`, `B7`, `F6`, `F7`, `J6` and `J7`.
   - **If the sheet cannot be written** (permission or connector unavailable): leave it, say so in the report, and do not fail the run. The CSV in git is the canonical register.
5. Report:
   - providers per country and the counts per `reader_status`;
   - the admitted courses and their change against the previous snapshot;
   - the five universities blocked in Layer 4 with the most active courses;
   - the merged admin pull request.
