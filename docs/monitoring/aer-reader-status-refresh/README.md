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
| `sliceC.sql.tmpl` | One rolled-back read of live coverage (per field, active courses) and the guardrails (G3, manual locks, active cron jobs), run in the same dispatch as the B slices |
| `daily_digest.py` | Releases stale claims (older than 24 hours) in `PROVIDER-ENRICHMENT-QUEUE.csv`, writes `S1-BLOCKER-QUEUE.csv` (every `HELD:*` cell with its solver) and regenerates `DAILY-EXECUTIVE-STATUS.md`, keeping the lanes' spend log and solver entries |

## Daily procedure

1. Run `bash docs/monitoring/aer-reader-status-refresh/refresh.sh <pilot clone> <admin clone> <work dir>`.
   - It stops with a non-zero exit if a slice is missing or the provider list has outgrown the slice count (the last slice must be empty).
   - In that case, report it and commit nothing.
2. Check the totals the builder prints.
   - The active courses per country are the live denominator.
   - Every provider with active courses is one row.
3. Copy the CSV to `docs/monitoring/AER_University_Reader_Status.csv` on a branch from `origin/main`. Open an admin pull request with the `automerge` label, and confirm it merged.
4. Sync the sheet with the Google Sheets and Google Drive connectors. Each `*_Universities` tab holds every provider with active courses in its country (AU 1,544, NZ 290, CA 52 on 23 Nov 2026), ranked by active courses: the 24-column header in row 1 and the data from row 2 (Platform Admin, 23 Nov 2026 17:07).
   - Run `python3 sheet_payloads.py <work>/sheet.json <work>/sheet --snapshot "<B3 line>" --stamp "<YYYY-MM-DD HH:MM>"`. It writes `upload.csv`, `plan.json`, `90_summary.json` and `91_kpi_*.json`, and prints the sha256 of `upload.csv`.
   - **Rows are never typed.** Upload `upload.csv` with Drive `create_file` (title `tmp_AER_reader_status_sync_<date>`, `contentMimeType` `text/csv`, `base64Content` the file reference `sha256:<hex>:<absolute path>`). It converts to a temporary Google Sheet. Copy its first tab into the target with `copy_sheet_to_another_spreadsheet`.
   - Add grid rows where a tab is shorter than `plan.append_rows` (`appendDimension`). Clear `plan.clear` with `batch_clear_values`.
   - Fill `plan.requests_template` (`@TMP@` = the copied tab's sheetId, `@<tab>@` = each tab's sheetId) and send it in one `update_spreadsheet` call. It pastes values, writes `updated_at_aedt` as text, and deletes the copied tab. Then trash the temporary file (the only file this run trashes).
   - **Summary tab:** rows 11 to 14 are live `COUNTIF`/`SUM` formulas over the three tabs and are never overwritten. Send `90_summary.json` (`Summary!A15:M15`, the register CSV reconciliation row) and each `91_kpi_*.json` (B3, B6, B7, F6, F7, J6, J7) with `update_values`.
   - Columns M (`aer_admitted_pct`) and V (`daily_admitted_delta`) carry plain number formats (`0.0` and `+0;-0;0`) from row 2; never change other formats.
   - **Verify** with `get_values`: row 1 is the header, row 2 is rank 1, the last data row is at row `rows + 1`, and `Summary!C14:M14` (Total Combined) equals `Summary!C15:M15` (the register CSV).
   - **If the sheet cannot be written** (permission or connector unavailable): leave it, say so in the report, and do not fail the run. The CSV in git is the canonical register.
5. Daily digest, in the same admin pull request as the register: run `python3 daily_digest.py --admin <admin clone> --live <work>/C.out --now "<YYYY-MM-DD HH:MM, Melbourne>"`.
   - It changes `PROVIDER-ENRICHMENT-QUEUE.csv` only to release stale claims (a dated note on each row), and writes `S1-BLOCKER-QUEUE.csv`, `DAILY-EXECUTIVE-STATUS.md` and `daily-digest-state.json`.
   - If the live probe did not answer, the guardrail rows show "not read" and the run reports it; nothing is guessed.
6. Drive mirror (Platform Admin 23 Nov 2026 19:59): upload `docs/platform/CONTINUOUS-DELIVERY-MASTER-PLAN.md` and `docs/monitoring/DAILY-EXECUTIVE-STATUS.md` from merged `main` to the Drive folder `1NyLe89dtY1DBn32TXyR3le2p3uUdxfXN` (Drive `create_file` with a file reference, `text/markdown`, no conversion, same title). After both uploads succeed, trash the older copies with exactly the same title in that folder, so one current copy of each is left. Never trash any other file.
7. Report:
   - providers per country and the counts per `reader_status`;
   - the admitted courses and their change against the previous snapshot;
   - the five universities blocked in Layer 4 with the most active courses;
   - the merged admin pull request.
