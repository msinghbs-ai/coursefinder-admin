# Production validation load policy (in force 2 Nov 2026 08:10 AEDT)

**Authority:** Platform Admin direction 2 Nov 2026 07:41 §2 (`nz-enrichment-brief/2026-11-02-continuous-multi-agent-delivery-direction.md`).
**Trigger:** the 07:00 and 07:03 admission time-outs on 2 Nov, recorded in `2026-11-02-ss015-gate-c-jobs.md`. They coincided with an integrator query that evaluated the E13 gate across 499 items.

## Rules for every agent and the integrator

1. **Heavy full-cohort work runs off production:** on isolated local Postgres fixtures (`/usr/lib/postgresql/16/bin`, scratch databases), saved evidence files, or exported snapshots. There is no read replica on this project.
2. **Production reads are small:**
   - indexed, bounded (LIMIT, or keyed by id lists of at most 100), paginated;
   - no per-row calls of heavy functions over whole sets;
   - each query under 10 seconds where possible, never close to the statement time-out.
3. **Avoid busy windows:**
   - no production read heavier than a lookup during :00–:05 (admission jobs at :00 and :03) or :35–:42 (exit-awards at :37, adapter apply at :40);
   - nothing heavy during 06:50–07:15 AEDT (daily job peak).
4. **One production-facing check at a time.** Agents do not run large production queries independently. They prepare the query; the integrator runs or schedules it, unless it is a small lookup under rule 2.
5. **Measure and back off.** Before a verification batch, look at recent `cron.job_run_details` durations. If admission jobs are above twice their usual duration, or any time-out occurred in the last 15 minutes, defer non-critical verification.
6. **Deployed UAT runs** (`deployed-weekly.yml`, `deployed-uat.yml`, `release-currentness`) are dispatched by hand only outside :55–:10 and :35–:42, and never within 15 minutes of another heavy verification. Added 2 Nov 09:05: the 06:51 dispatch overlapped the 06:58–07:05 slowdown.
   **Correction, 09:20:** admission jobs run every 10 minutes (`coverage-admit` at :x0, `adapter-overwrite` at :x3), so a 12–15-minute deployed run always overlaps them. Run 41356236616 (v2.15.402, dispatched 09:15) was cancelled before any test ran. Full deployed desktop and phone runs are **held** until one of these:
   - the 10-minute jobs are moved off the admission slots (Workstream A stagger proposal); or
   - the Platform Admin accepts the risk of a supervised run; or
   - the incident cause is otherwise established.
   Post-merge targeted Deployed UAT and release-currentness checks (about 1 minute) continue.
7. **No new scheduler or subsystem.** Use existing jobs, settings and this document.

## Breach handling

A production job failure that coincides with validation load is recorded as "suspected validation-induced interference, pending root-cause verification". It is never relabelled as a pass.
