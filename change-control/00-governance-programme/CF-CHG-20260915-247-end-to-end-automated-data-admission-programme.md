

**S1-ELR-Bands-And-Crawl, 21 Nov 2026 10:15 AEDT: s904 to s909 merged (Pilot #1447, f779b439; migration `20261121110000`; deployed 09:41 AEDT). The live check found `elr-det-sweep` failing on every run since 08:47 AEDT; s910 is recorded before merge (Pilot #1448, migration `20261121120000`)**

- **The failure:**
  - The central writer re-read a page whose identical text already had a superseded elr-central proposal, and its insert hit the unique key `provider_policy_proposals_key`.
  - The error was raised during the answer read-back, before the lost-call step. So every run failed on the same answer (request 898146, sent 08:42 AEDT), and nothing after it ran.
  - Nothing reached Firecrawl. The s907 fetch has not started: 52 pages are queued and no credits have been used.
  - The fault came in with s896, which explains why the earlier closing record's "5 of 5 runs succeeded" was true only up to 08:47.
- **s910 fix:**
  - A page text that already has a proposal is not proposed again, and its reads are held with that reason.
  - Each answer is recorded in its own sub-transaction; one that fails is marked failed and the run goes on.
  - Rolled-back proof: one sweep run completed in 1.2 s, reading back the stuck answer, applying 2 policies and sending 11 central pages and 10 fetch pages.
- **Live after #1447:** G3 75/48; manual locks 7,585; 133 active cron jobs, 0 unregistered; on-demand request open until 15:41 AEDT, estimate 52 credits, 67,177 credits left.
- **Validation:** spec s910 3 of 3; the guards pass.
- **Next:** auto-merge this record, then Pilot #1448, then read live.

### 21 Nov 2026 10:10 AEDT, S1-Coverage-Unlock-UI-Notes: partial entry-table admission approved (Platform Admin 09:57); s912 recorded before merge

- Approved, superseding the all-or-nothing completeness hold under Decision 276: admit every country row of a university-wide or course entry table that passes the domain, identity and source-evidence checks; hold only missing or unverified country rows in Layer 4.
- s912 (`20261121130000`): the shadow now counts university-wide and course rows. Dry run: would admit 1,158 rows (17 course) at 31 providers.
- Cutover 22 Nov 2026 09:30 AEDT after the 24-hour shadow report.

### 21 Nov 2026 10:35 AEDT, S1-Fast-Admission: s913 to s915 recorded before merge (Pilot migration `20261121140000`)

- **Decision (Platform Admin, 10:03 AEDT):** admit verified data into the live canonical tables today.
  - This brings forward the s912 cutover planned for 22 Nov 09:30 AEDT. **That cutover is this change and is not made again.**
- **s913:** rule `aer-partial-admit` goes live every 15 minutes and replaces the shadow `aer-uniwide-partial-shadow` (switched off, retiring).
  - It looks only at entry-table reads stopped by completeness alone.
  - It admits each university-wide or course row that passes every machine row rule, with no course lock, no conflicting active row and no shared identity.
  - The countries a read did not cover, and the rows held, stay in Layer 4.
  - It can be reversed with `security.aer_matrix_machine_withdraw_v1`.
- **s914:** the course and entry-table audit samples go to 0%.
  - 491 verified course reads (1,450 rows) were waiting only as audit samples. Their ledger rows are kept so a person can check them after admission.
  - `aer-machine-admission` moves to :06, :21, :36 and :51.
  - The proposer takes 150 courses a tick (was 50) and up to 1,200 waiting items (was 400).
- **s915:** `aer-reconcile` moves to :12, :27, :42 and :57.
  - aer-det-sweep NUL fix: 71 of 72 calls had failed since 03:00 AEDT. The edit is md5-guarded (`9856b441`).
  - aer_det calls 3 → 9 and open calls 4 → 12. ELR in flight 8 → 24, batch 200 → 600, central sources 6 → 18.
- **Rolled-back dry run, 10:30 AEDT:**
  - First partial run: 38 reads, 1,133 rows at 31 providers (Charles Sturt 7, Hong Kong held).
  - Active entry-table rows 5,576 → 6,709.
  - G3 75/48; locks 7,585; active jobs unchanged (135).
- **Design record:** `docs/platform/2026-11-21-s913-s915-fast-admission.md`.
