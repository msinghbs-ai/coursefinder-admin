# StudySearch SS-014 recovery and automation tranche: response

**Mandate:** Platform Admin, 31 Oct 2026 21:54 (`2026-10-31-studysearch-ss014-recovery-automation-mandate.md`).
**Response lodged:** 1 Nov 2026, 00:20 AEDT.
**Evidence:** transformation record §32.

## 1. Verified production improvements

| Decision | State | Verified evidence |
|---|---|---|
| **D12** Critical alerts by push and e-mail | **Live** (production alerts on since 23:05) | The existing "Work queue alerts" task took and confirmed: the test alert, a labelled synthetic critical (two evaluations produced one alert), and its recovery notice (sent 22:00 and 23:00). A failure dry run surfaced `alerts:delivery_failed` on Platform health. Work-queue alerts unchanged. No webhook or new credentials |
| **D14** Idle-pause flag recovery | **Live** (v2.15.385) | `coverage-ai-match`'s stale flag released as the 19 Oct person restart, with audit kept. Future restarts release the flag automatically. No other job touched |
| **D15** Refresh gap 30 → 25 min | **Applied 23:19, under observation** | No overlap possible: processing runs take at most 118 s against a 10-minute cycle, behind a single writer lock. One request since the change, so not measurable yet |
| **D16** Scholarship hold functions | **Live** (v2.15.386) | Cold scheduled runs: scholarship check 1.4–2.1 s (was 7.0–7.7 s the hour before; 11.9 s original median). Same results; worker jobs unaffected |
| **D13** Re-read pilot | **Live, waiting for eligible pages** (v2.15.386) | Direct-only path proven in a rolled-back dry run. 0 pages eligible until about 2 Nov, because the oldest last attempt is 2 Oct |

**Also fixed:** the alert job's schedule skipped minute 0 every hour. It now runs every 10 minutes.

## 2. Before and after

| Metric | Baseline | After implementation |
|---|---|---|
| Critical alert delivery | Admin-only visibility for platform issues | Push and e-mail through the existing task; test, deduplication and recovery delivered. **Please confirm the [TEST] messages reached you** |
| Exhausted course pages | 1,467 (1,461 not yet tried) | Pilot live; first eligible about 2 Nov. **Not yet attempted** |
| Idle-pause control | Stale flag after a manual restart | Released as a person release; automatic release on future restarts |
| Refresh wait p95 | 31 min (max 40) | Not yet measurable (1 request since the change) |
| Health-check duration (cold) | About 22 s (scholarship check 11.9 s) | 15.7–16.8 s (scholarship check 1.4–2.1 s), 3 runs |
| Job failures | 24 h and 7-day windows | 5 failures in 21,052 runs since 31 Oct 11:03 (4 incidents: two "job canceled" on read jobs at 15:00 and 15:30; two statement time-outs on a row lock at 17:10). T1 (0 a day) **not met so far** |
| Search API p95 | 5.2 s on 71 requests | No new measured traffic |

## 3. Outstanding reliability and acceptance checks

| When | Check |
|---|---|
| 1 Nov 11:10 and 11:20 | SS-004, SS-007, SS-010 and SS-012 24-hour checks; SS-014 24-hour run times; false criticals; first daily scorecard |
| 2 Nov 07:30 | First D13 pilot results; D15 wait figures; D14 guard re-arming; D16 over 24 hours; D12 alerts sent or failed |
| 7 Nov | SS-004 seven-day assessment; first complete weekly scorecard |
| SS-015 | Remains Verifying. The gate is two complete weeks with T1, T2, T3, T5 and T7 met, T4 under target and T6 with no errors or drift; acceptance not claimed |

## 4. Remaining human intervention points

- **Layer 4 review:** 1,175 pending; oldest 9.9 days.
- **SS-007:** 154 release candidates and 1,012 verification reads stay held (D11).
- **Alerts:** acknowledging alerted issues on Platform health stops reminders.
- **Re-read pilot:** scaling beyond 25 a day needs a new approval (the setting's maximum is 25).
- **Investigation of the 17:10 time-outs:** `coverage-admit` and `coverage-admit-intakes` waited on a row lock in `evidence_entity_links`, a write contention between two admission jobs. Tracked under SS-004.

## 5. Cost and operational implications

- **No new spend:**
  - D12 reuses the hourly task (one short model run an hour, as before).
  - D13 is direct-only (no Firecrawl, no AI).
  - D16 lowers database time.
- **Database time saved:** about 5 to 6 s per health run, which is roughly 13 to 14 minutes a day across 144 runs, plus faster scholarship worker claims.
- **D15:** at most one extra refresh run every 30 minutes, about 1 minute each.
- **New components:** one helper function (D14); one table and one job (D13, fixed ceiling); no new framework; no duplicate jobs.
- **Alert delay:** up to about 75 minutes; typically 30 to 45 minutes.

## 6. Decisions still requiring approval

- **None blocking.**
- **For later, only if you want it:** a faster alert path (webhook, or a more frequent task) if 75 minutes is too slow. This would need credentials, so it is not done under D12.

## 7. References

**Pilot:**

| PR | Release | Content |
|---|---|---|
| #777 (`dd320cc6`) | v2.15.385 | D14; migration `20261031100000`; s195 |
| #778 (`62ce39a3`) | v2.15.386 | D16 and D13; migration `20261031110000`; worker v0.55.0; s196; s27 updated |

- **Local suite before each merge:** 1,322 and 1,325 passed, 0 failed.
- **Consumer drift:** none.

**Admin:**
- this response;
- the mandate (verbatim);
- transformation record §32;
- execution register (SS-014, SS-015);
- `OPERATIONAL-LIMITS.md` 1.3;
- test register.

**Settings changed (logged in `admin_control_events`):**
- `alerts.delivery_enabled` on;
- `alerts.test_mode` on, then off;
- `search.refresh_min_gap_minutes` 25.

**Scheduled task changed:** "Work queue alerts" prompt (D12).
