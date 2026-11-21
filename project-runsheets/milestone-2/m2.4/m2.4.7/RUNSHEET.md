### 21 Nov 2026 10:50 AEDT, S1-Fast-Admission: s914 to s916 recorded before merge (Pilot migration `20261121150000`, Pilot #1450)

- **Decision (Platform Admin, 10:03 AEDT):** admit verified data into the live canonical tables today.
  - This brings forward the s912 cutover planned for 22 Nov 09:30 AEDT. **That cutover is this change and is not made again.**
- **s914:** rule `aer-partial-admit` goes live every 15 minutes and replaces the shadow `aer-uniwide-partial-shadow` (switched off, retiring).
  - It looks only at entry-table reads stopped by completeness alone.
  - It admits each university-wide or course row that passes every machine row rule, with no course lock, no conflicting active row and no shared identity.
  - The countries a read did not cover, and the rows held, stay in Layer 4.
  - It can be reversed with `security.aer_matrix_machine_withdraw_v1`.
- **s915:** the course and entry-table audit samples go to 0%.
  - 491 verified course reads (1,450 rows) were waiting only as audit samples. Their ledger rows are kept so a person can check them after admission.
  - `aer-machine-admission` moves to :06, :21, :36 and :51.
  - The proposer takes 150 courses a tick (was 50) and up to 1,200 waiting items (was 400).
- **s916:** `aer-reconcile` moves to :12, :27, :42 and :57.
  - aer-det-sweep NUL fix: 71 of 72 calls had failed since 03:00 AEDT. The edit is md5-guarded (`9856b441`).
  - aer_det calls 3 → 9 and open calls 4 → 12. ELR in flight 8 → 24, batch 200 → 600, central sources 6 → 18.
- **Rolled-back dry run, 10:30 AEDT:**
  - First partial run: 38 reads, 1,133 rows at 31 providers (Charles Sturt 7, Hong Kong held).
  - Active entry-table rows 5,576 → 6,709.
  - G3 75/48; locks 7,585; active jobs unchanged (135).
- **Design record:** `docs/platform/2026-11-21-s914-s916-fast-admission.md`.
- **Renumbered 10:45 AEDT:** S1-ELR-Bands-And-Crawl claimed s913 and `20261121140000` at the same time (Pilot #1451). This change is now **s914 to s916**, Pilot migration `20261121150000` (Pilot #1450).



**S1-ELR-Bands-And-Crawl, 21 Nov 2026 10:45 AEDT: s910 merged (Pilot #1448, d741077c; deployed 10:10 AEDT) and `elr-det-sweep` runs again (3 of 3 succeeded, 3.7 to 4.5 s). The live check found the two new worker modes unreachable; s913 is recorded before merge (Pilot #1451, migration `20261121140000`)**

- **The fault:**
  - Every s907 fetch call came back HTTP 422 "supported modes" from coverage-sweep.
  - In #1447 the band and fetch mode blocks sat after mode `read`'s return and before its closing brace, so they were unreachable code. esbuild and the type check both accept that.
  - Nothing was fetched and no Firecrawl credit was used. 30 pages were marked lost by the three refused calls.
- **s913 fix:**
  - The worker: the brace moves, so both modes are reachable. Spec s913 fails against the #1447 worker and passes with the fix.
  - The sweep: a fetch call refused with HTTP 422 returns its pages to the queue.
  - This migration queues the lost pages again. Rolled-back proof: 42 queued and 10 in flight, under the same on-demand request, open until 15:41 AEDT.
- **Live:** G3 75/48; manual locks 7,585; 137 active cron jobs, 0 unregistered.
- **v1.2 reads so far:**
  - 13 gave values without a study level;
  - 13 state no English test by level;
  - 6 add no level the approved policy lacks;
  - 4 are page texts already proposed (now held by s910);
  - 3 flagged as band pages;
  - 13 in flight.
- **Next:** auto-merge this record, then Pilot #1451, then read live.

### 21 Nov 2026 10:50 AEDT, S1-Coverage-Unlock-UI-Notes: standing mandate, immediate live activation (s917), recorded before merge

- `CLAUDE.md` and `AGENTS.md` in both repositories: reported fixes and verified admission rules go live immediately upon deploy; no unrequested shadow, off-by-default flag or next-day cutover; no assumed future work.
- The partial-admission cutover is carried by S1-Fast-Admission (Pilot #1450); this lane's duplicate build was stopped before merge.
