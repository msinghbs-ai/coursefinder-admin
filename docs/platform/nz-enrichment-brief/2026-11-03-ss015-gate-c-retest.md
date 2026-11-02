# SS-015 Gate C — targeted admission retest (3 November 2026)

**Pass rule** (Gate C record, 2 Nov 09:05 correction): 0 admission failures and every admission run under 100 s.
**Jobs:** coverage-admit, coverage-admit-intakes, adapter-overwrite, layer4-auto-admit, provider-basis-rule-admit, provider-rule-admit.
**Source:** `cron.job_run_details`, read at 08:51 AEDT (light read, outside the admission minutes).

| Window | Runs | Failed | Over 100 s | Longest | Result |
|---|---:|---:|---:|---:|---|
| A: 3 Nov 06:45–07:15 | 16 | 0 | 0 | 17.3 s (layer4-auto-admit) | **Pass** |
| B: rolling 24 h from 2 Nov 07:06 | 614 | 3 | 3 | 120.1 s | **Not met (3 time-outs, cause identified)** |
| Since 3 Nov 07:06 to 08:51 | 42 | 0 | 0 | 39.7 s | Pass so far |
| 3 Nov 09:00–09:10 | — | — | — | — | due; recorded below |
| 3 Nov 11:00–11:10 | — | — | — | — | due; recorded below |

## The three time-outs in window B

| Job | Started (AEDT) | Duration |
|---|---|---|
| coverage-admit-intakes | 2 Nov 17:05:00 | 120.1 s (statement time-out waiting on its advisory lock) |
| coverage-admit | 2 Nov 17:23:00 | 120.1 s (statement time-out) |
| coverage-admit-intakes | 2 Nov 17:55:00 | 120.0 s (statement time-out waiting on its advisory lock) |

All three fall inside 17:05–17:55 on 2 Nov, while the authorised Firecrawl window ran at concurrency 50. The integrator cut concurrency to 24, then 12, and paused the re-read from 17:49 to 19:45. No admission failure since 17:55 on 2 Nov (about 15 hours, about 400 admission runs).

- **Cause:** capacity contention from the integrator's Firecrawl run settings under the temporary authority. It was not validation-induced and not a code defect.
- **Remediation in force:**
  - the Firecrawl window has ended and normal limits are restored (concurrency 12, budgets on; event #28683);
  - the validation load policy applies;
  - the yield and hidden-failure checks (v2.15.412) now raise any timed-out run as an issue.
- **Residual risk:** a future high-concurrency Firecrawl run could contend with admission again. Concurrency stays a setting changed only with a reason. The checks surface any recurrence within 30 minutes.

**Gate C status:** the targeted retest windows pass. T1 over the rolling 24 h is **not met** because of 3 time-outs with an identified, remediated cause. Acceptance on an exception basis needs the Platform Admin's risk disposition, under the 07:41 direction §3.
