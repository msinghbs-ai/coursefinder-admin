# S1-Fast-Admission: s914 to s916, verified entry data admitted today (21 Nov 2026)

**Chat:** S1-Fast-Admission. **Decision:** Platform Admin, 21 Nov 2026 10:03 AEDT. **Change control:** CF-CHG-20260915-247.
**Pilot:** migration `20261121150000_cf247_s914_s916_fast_admission.sql`, spec `tests/uat/cf-247-s914-s916-fast-admission-contract.spec.mjs`. No UI change, so no version bump.

## 1. The decision

Accelerate verified data admission into the live canonical tables today:

1. Make the partial entry-table admission live on deploy, with no 24-hour shadow. This brings forward the cutover approved at 09:57 for 22 Nov 2026 09:30 AEDT (s912, chat S1-Coverage-Unlock-UI-Notes). **That cutover is this change, so it is not made again tomorrow.**
2. Admit verified course entry reads automatically. Hold only real ambiguities, table conflicts and unverified rows in Layer 4.
3. Run the admission and reconcile work every 15 minutes. Triple the throughput of the $0 sweeps, with no new cron job.
4. Merge both repositories, check the live gains, and sync Drive `Monitoring`.

## 2. What we found live (rolled-back probes, 10:08 to 10:40 AEDT)

| Measure | Value |
|---|---|
| Migration head | `20261121130000` (2,242 rows) |
| G3 | 75 functions / 48 relations |
| Manual locks | 7,585 |
| Active cron jobs | 137, then 135 (another lane), 0 unregistered |
| Course entry reads waiting in Layer 4 | 1,065 (2,721 proposed rows) |
| Why they wait | audit sample 491 (1,450 rows), every row held 285, gate incomplete 257, no bound page 41, identity not admitted 19 |
| Course reads admitted in the last 24 hours | 15 |
| Entry-table reads waiting | 73 first reads, 6 changes |
| s912 shadow | 1,141 rows at 27 providers would be admitted; Charles Sturt 7 of 7, Hong Kong held |
| aer-det-sweep | 71 of 72 calls failed since 03:00 AEDT. A NUL escape (`\u0000`) in page text failed the jsonb cast, so the same 40 pages were sent again on every tick. The proposer was held at its cap of 400 waiting items |
| elr-det-sweep | main English reader: 0 pages left; central English sources: 378 left, one call at a time |
| aer-reconcile | hourly at :27, 84 s p50, 99 s max. It is read only: it builds the assurance record and admits nothing |
| aer-machine-admission | :24 and :54, 45 s p50. This is the job that admits course reads and entry tables |

## 3. What the change does

### s914: partial entry-table admission is live

- **Rule:** `aer-partial-admit`, run by admission-rule-runner at :14, :29, :44 and :59. It calls `security.aer_partial_admit_v1()`.
- **Settings:** `aer.partial_admit_on` (1) and `batch.aer_partial_admit` (200).
- **Old rule:** the shadow `aer-uniwide-partial-shadow` is switched off and marked retiring (14 days). Its table stays.
- **Which reads it looks at:** entry-table reads where the machine admission (`security.aer_matrix_machine_check_v1`, unchanged) stops only at completeness. Every earlier check has already passed for these reads:
  - no manual lock, no earlier rejection, not claimed;
  - the stored copy is present and current;
  - the copy was fetched from the official address, on the provider's own host, and no other provider shares that host.
- **Which rows it admits:** university-wide and course rows that pass every machine row rule:
  - verbatim quote, and the minimum appears in the quote;
  - confidence;
  - mapped level;
  - a published minimum on a grade scale;
  - not excluded by a rule.
- **Extra checks on each row:**
  - a course row whose course is locked is held;
  - a row whose identity is active from another source or provider is held (D4 C2);
  - two passing rows of the same read that share one identity are both held (D4 C1).
- **Replacing older rows:** when an active row from the same source has the same identity, it is superseded, the same way Approve except works.
- **What stays in Layer 4:** the item itself. Its reason now names the countries the read did not cover and the number of rows held.
- **Grid reads** stay held while `aer.grid_machine_admission_on` is 0.
- **Undo:** the ledger row is `aer_matrix_machine_admissions` (rule `aer-partial-v1`), so `security.aer_matrix_machine_withdraw_v1(item, reason)` reverses it. The first run happens inside the migration, so the cutover is live as soon as it deploys.

### s915: verified course reads are admitted

- **Audit sample set to 0:** `aer.machine_audit_pct` and `aer.matrix_machine_audit_pct` go to 0. The 491 course reads (1,450 rows) held only as audit samples are admitted by the next runs. Every other check stays.
- **After-the-fact audit:** each read's `audit_sample` ledger row is kept, so a person can still check these reads after admission. A withdrawal suspends the rule (`aer_machine_suspend_check_v1`, unchanged).
- **Still in Layer 4:** reads with every row held, an incomplete gate, no bound page, or identity not admitted. These are the unverified rows and real ambiguities.
- **Schedule:** `aer-machine-admission` moves from :24 and :54 to :06, :21, :36 and :51. The command is unchanged.
- **Deterministic proposer:** `aer_det.propose_per_run` goes from 50 to 150, and `aer_det.propose_max_pending` from 400 to 1,200.

### s916: cadence and $0 throughput

- **aer-reconcile** moves from :27 to :12, :27, :42 and :57. It runs one at a time. The command is unchanged.
- **aer-det-sweep NUL fix:** the NUL escape is now dropped before the cast. This is an md5-guarded edit of `security.aer_det_sweep_v1` (`9856b441`), and only the cast line changes. The stuck 40 pages are read on the next tick.
- **Throughput:** every value below is a setting, and each range was widened to take the new value. No call carries more pages than before, except the central English call.

| Setting | Was | Now | Notes |
|---|---|---|---|
| `aer_det.sweep_calls` | 3 | 9 | 40 pages a call, unchanged |
| `aer_det.sweep_max_open` | 4 | 12 | |
| `elr_det.in_flight_max` | 8 | 24 | 25 pages a call, unchanged |
| `batch.elr_det_sweep` | 200 | 600 | |
| `batch.elr_central` | 6 | 18 | sources in the one central call |

## 4. Rolled-back dry run (10:30 AEDT, run 44837264243)

- **Partial admission, first run:** 38 reads, **1,133 rows, 31 providers**. Charles Sturt: 7 rows admitted, Hong Kong held.
- **Entry-table rows:** active rows went from 5,576 to 6,709.
- **Schedules:** `aer-machine-admission` at `6,21,36,51 * * * *`; `aer-reconcile` at `12,27,42,57 * * * *`.
- **Unchanged:** G3 75/48, 7,585 manual locks, active jobs (135).

## 5. Risks and how they are held

- **No human audit sample.** A person no longer sees 5% of passing reads before they are admitted. *Mitigation:* the audit_sample rows stay as a list to check after admission; a withdrawal suspends the rule; the 7-day validation and suspension checks are unchanged.
- **More load on the database.** aer-reconcile now runs four times an hour (about 84 s each, one run at a time), and aer-machine-admission four times an hour (45 s cap). *Watch:* the s900 capacity levels and the Platform Health runtime rates.
- **More parallel worker calls.** Up to 12 aer-det calls and 24 ELR calls can be open at once. A lost call is sent again by the existing rules. *Watch:* the failed and lost call rates after deploy.
- **The central English call is three times larger.** *Watch:* the request time. If it times out, set `batch.elr_central` back to 6 in Settings.
- **A person rejects a partly admitted read.** A Reject in Layer 4 makes only the rows still proposed inactive. To take the admitted rows out as well, use the withdrawal.

## 6. Live read-back after deploy

This section is filled in after the deploy.

**Renumbered 10:45 AEDT:** S1-ELR-Bands-And-Crawl claimed s913 and `20261121140000` at the same time (Pilot #1451). This change is now **s914 to s916**, Pilot migration `20261121150000` (Pilot #1450).
