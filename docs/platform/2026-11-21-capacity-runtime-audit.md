# Capacity and runtime audit: IQ-00510 and IQ-00445

**Date:** 21 Nov 2026, 02:00–02:30 AEDT · **Chat:** S1-Ops-Capacity-Runtime (scheduled run, Platform Admin 20 Nov 2026 23:02 AEDT) · **Type:** read-only audit

**Scope and limits of this run**

- Every figure was read live inside rolled-back runs of the `db-migration-dry-run` workflow. Nothing was kept.
- Nothing was changed: no threshold, no retention rule, no schedule, no data and no setting. Spend was $0.
- The options below wait for the Platform Admin's explicit approval.

## Summary

| Item | Finding | Recommended option (for approval) |
|---|---|---|
| **IQ-00510** database size | 7,185 MiB at 02:03 and 7,370 MiB at 02:17, already above the pilot critical level (7,168 MiB = 7 GiB). Growth is about 200 MiB a day over the last 10 days. Dead rows are only about 5%. | **A**: confirm the provisioned disk in the dashboard, then raise the pilot capacity levels by a Pilot migration. **C** (optional): a targeted plain `VACUUM (ANALYZE)` on four tables. |
| **IQ-00445** `coverage-reconcile` run time | Alone it runs in **9.1 s**. On its live minute (:26) it takes 106 s at p50 and 137 s at p95, with 3 time-outs in 7 days. **:26 is the busiest minute of the hour.** | **Move the job from :26 to :09**, the quietest minute, by a Pilot migration. Then accept the 120 s target after two clean unattended cycles. Trimming the batch would not help. |

## IQ-00510: database size against the alert level

### What the alert compares

- The alert level is in `pipeline.platform_capacity_policy` (environment `pilot`, change control CF-CHG-20260901-051, last updated 16 Oct 2026).
- The platform health check reads it (issue key `db_capacity:size`).

| Level | Bytes | MiB |
|---|---|---|
| Warn | 4,294,967,296 | 4,096 |
| High | 6,442,450,944 | 6,144 |
| Critical | 7,516,192,768 | **7,168** |

### Size now and growth

- **Database:** 7,185 MiB (PostgreSQL 17.6).
- **By schema (MiB):** pipeline 5,103; storage 738; catalogue 528; search 265; scholarship 190; ranking 133; cron 79; net 25.

| Day (daily max) | MiB |
|---|---|
| 22 Oct | 3,806 |
| 10 Nov | 4,989 |
| 13 Nov | 5,832 |
| 19 Nov | 7,011 |
| 20 Nov | 7,172 |
| 21 Nov (02:03) | 7,185 |
| 21 Nov (02:17) | 7,370 |

- **Growth rate:** about 113 MiB a day over 30 days, and about 200 MiB a day over the last 10.
- **02:03 to 02:17:** +185 MiB in 14 minutes. Part of that is short-lived: rolled-back dry runs and job writes leave dead rows until autovacuum reuses them. One reading is not a trend, but it puts the database 202 MiB over the critical level.
- **At 200 MiB a day:** the database reaches 8 GiB (8,192 MiB) in about 5 days.

### The 20 largest tables

**Kind** separates permanent evidence and canonical data (kept by design) from operational and log tables (high churn, kept under retention settings).

| Table | MiB | Dead rows | Kind |
|---|---|---|---|
| `storage.objects` | 738 (indexes 535) | 7.3% | File metadata (Supabase-owned) |
| `pipeline.evidence_artifacts` | 495 | 0.5% | Permanent evidence |
| `pipeline.field_enrich_items` | 347 | 5.5% | Operational queue |
| `search.course_documents` | 256 | 0% | Canonical (search) |
| `pipeline.mode_outcome_ledger` | 239 | 3.8% | Log (472k rows, oldest 23 Oct; retention 90 days) |
| `pipeline.scholarship_ai_extractions` | 201 | low | Stored AI evidence |
| `pipeline.enrich_ai_answers` | 188 | low | Stored AI evidence |
| `pipeline.coverage_provider_urls` | 165 | 11.3% | Operational |
| `pipeline.course_attribute_coverage` | 144 | 15.3% | Operational (recomputed) |
| `catalogue.course_fees` | 142 | 11.6% | Canonical (last autovacuum 5 Oct) |
| `pipeline.layer4_review_items` | 141 | low | Review history |
| `pipeline.scholarship_page_candidates` | 137 | low | Operational |
| `pipeline.admin_control_events` | 125 | low | Audit log (permanent) |
| `pipeline.coverage_ai_match` | 117 | low | Stored AI evidence |
| `pipeline.provider_discovery_links` | 113 | low | Operational |
| `pipeline.layer4_decisions` | 112 | low | Decision record (permanent) |
| `pipeline.website_sync_items` | 104 | low | Operational |
| `scholarship.course_mappings` | 101 | 15.5% | Canonical |
| `pipeline.ai_eval_examples` | 100 | low | Evaluation record |
| `catalogue.courses` | 82 | low | Canonical |

**What this shows:**

- **Bloat is small.** There are 450k dead rows against 8.79M live (about 5%). A `VACUUM FULL` of the bloated tables would return an estimated 100–300 MiB, and it locks each table while it runs.
- **Unused indexes are small.** Non-unique indexes with no scans since 24 Jul total 19 MiB across 166 indexes.
- **The scheduler log is already trimmed.** `cron.job_run_details` holds 199k rows (78 MiB), oldest 16 Nov.
- **The growth is real data.** It is mostly stored evidence, AI answers and pipeline queues from the deterministic sweeps and coverage work. Clean-up alone will not keep the database under 7 GiB.

### File storage and the Supabase disk

- **File storage is billed apart from the database disk.** The buckets hold `evidence` 22,611 MiB and `adapter-captures` 7,534 MiB.
- **What Supabase documents:**
  - Pro and Team plans include 8 GB of disk; more costs $0.125 per GB a month.
  - The disk grows by itself at 90% use (by 50%, at most once every 4 hours).
  - The database goes read-only at 95% only if the resize quota is used up.
- **What could not be read:**
  - The plan and the provisioned disk size are not visible to the API.
  - The disk also holds WAL and system files, so it may already have grown.
  - The Platform Admin should read **Project Settings › Compute and Disk** before choosing.

### Options (for explicit approval; none applied)

| Option | What it does | Gain | Risk and effort | Data deleted |
|---|---|---|---|---|
| **A. Raise the pilot capacity levels** | A Pilot migration updates the `pilot` row in `pipeline.platform_capacity_policy`, for example warn 6 GiB, high 9 GiB, critical 12 GiB (set them against the provisioned disk read in the dashboard). | Stops a false critical flag on growth that is expected. | Low. One config row, repo-first, about 30 minutes. Disk cost follows real use, not the alert. | None |
| **B. Log-table hygiene under the existing retention settings** | Confirm the trim jobs for `mode_outcome_ledger` (90 days), `job_log_keep_days` (3) and `ai_invocations_days` (90) run as set. Shortening any retention would be a retention change. | Little now. The ledger's oldest row is 28 days old, so it trims nothing until 21 Jan 2027. | Low. A retention change needs its own approval. | Only what the existing rules already remove |
| **C. Targeted `VACUUM (ANALYZE)`** on `catalogue.course_fees`, `pipeline.course_attribute_coverage`, `scholarship.course_mappings` and `pipeline.coverage_provider_urls` | Marks dead space for reuse and refreshes planner statistics (`course_fees` was last vacuumed 5 Oct). A plain `VACUUM` does not lock. `VACUUM FULL` would lock each table and return 100–300 MiB. | Slows growth a little and helps query plans. | Low (plain); medium (FULL: write lock while it runs). As a paste file or a maintenance migration. | None |

**Recommendation:**

- Take **A** once the provisioned disk is confirmed, with **C (plain `VACUUM`)** alongside.
- Do not shorten retention, and do not run `VACUUM FULL`: the gain is small against a table lock on live pipeline tables.
- Watch the 200 MiB a day: at that rate the included 8 GB is passed within a week, so disk cost, not the alert, is the real decision.

## IQ-00445: `coverage-reconcile` run time

### Configuration

- Job #364, `26 * * * *`, `select security.coverage_reconcile_v1()`, run as `postgres`.
- **Statement time-out:** the platform default of 120 s applies. The function sets no time-out of its own, and there is no role setting for `postgres`.
- **Batch setting:** `coverage.investigations_per_run` = 5. This is the only batch setting the function reads.

### Run times (7 days to 21 Nov 02:10 AEDT)

| Measure | Value |
|---|---|
| Runs | 94 (91 ok, 3 failed: time-outs at 120.1, 140.7 and 166.1 s) |
| p50 | 106.3 s |
| p95 | 136.7 s |
| Max | 166.1 s |
| Over 100 s | 54 runs |
| Over 120 s | 19 runs |
| `pg_stat_statements` | 396 calls, mean 52.5 s, max 119.7 s (since the last statistics reset) |

### Where the time goes

**One profiled run, alone (rolled back, 02:12):** the whole reconcile took **9.1 s**.

| Function | Total | Self |
|---|---|---|
| `security.aer_coverage_v1` | 6.5 s | 6.4 s |
| `security.scholarship_coverage_v1` | 1.7 s | 0.2 s |
| `security.coverage_due_v1` (2 calls) | 0.6 s | 0.6 s |
| `security.integration_issue_upsert_v1` (106 calls) | 0.2 s | 0.2 s |
| Everything else | under 1 s | |

**On its live minute it shares the database with 32–61 other job runs**, among them:

- `admission-rule-runner` (and `-b`, `-c`), `aer-reconcile`, `coverage-lane-dispatch` (and `-b`, `-c`), `rollup-scheduler`;
- `fee-reader`, `fid-det-sweep`, `struct-det-sweep`, `scholarship-ai-extract`, `platform-health`.

**Busy seconds by minute of the hour** (24 hours, all other cron runs, 3-minute window from each minute):

| Minute | :04–:07 | **:09** | :14–:17 | :24–:27 | **:26** | :30–:33 | :34–:37 | :40 | :44–:47 | :48–:49 | :54–:57 | :58 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Busy s | 31–44k | **13.3k** | 32–47k | 37–59k | **59.3k (peak)** | 15–17k | 30–47k | 15.8k | 30–37k | 15–16k | 42–53k | 10.1k |

**What this shows:**

- The run time is **contention, not batch size.** The reconcile does about 9 seconds of work and waits for the rest of its 106–153 seconds behind the busiest minute of the hour.
- No lock waits were seen at the time of the read.
- Trimming `investigations_per_run` (5) would save well under a second.

### Options (for explicit approval; none applied)

| Option | What it does | Expected effect | Effort |
|---|---|---|---|
| **1. Move the minute (recommended)** | A Pilot migration changes job #364 from `26 * * * *` to `9 * * * *` (:09 is the quietest minute after :58–:59, which is close to the hourly start of other jobs). The catalogue row and `docs/UI-MAP.md` scheduler entry move with it. | Well under 100 s, likely 10–30 s. | About 30 minutes, repo-first; a scheduler change |
| 2. Trim the batch | Lower `coverage.investigations_per_run`. | Under 1 s saved; does not meet the target. | Not recommended |
| 3. Reconcile the target | Accept the target as it stands after two clean unattended cycles. | Not supportable at :26: 3 time-outs and 19 runs over 120 s in 7 days. | Only after option 1 |

**Recommendation:**

- Take option 1, then close IQ-00445 after two clean unattended cycles at :09 (run time under 100 s, no time-out).
- The same reading supports the pending question on the scholarship classifier at :29. :29 is moderate (18.5k busy seconds), and :09, :40 and :48 are quieter.

## Invariants at the read

- Read 02:17 AEDT.
- G3: 75 functions and 48 tables, no drift.
- Manual locks: 7,585.
- Active cron jobs: 137 (ceiling 140).
- Migration head: `20261120235000` (2,233 rows).
- Spend: $0.

## Sources

- [Supabase: Disk size](https://supabase.com/docs/guides/platform/manage-your-usage/disk-size)
- [Supabase: Database size](https://supabase.com/docs/guides/platform/database-size)
