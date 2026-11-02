# Platform Admin decisions — 3 November 2026, 08:44 AEDT

**Source:** Platform Admin chat, 3 Nov 2026 08:44 AEDT, "Morning Decision Pack and Continuous Engineering Closure" (verbatim copy: `2026-11-03-morning-decision-pack-0844.md`). Submitted by the Platform Admin, so these items are **approved** and executed under the existing change-control rules.

| # | Decision | Approved scope | How it is executed | Status |
|---|---|---|---|---|
| D-M1 | AER D-R2/D-R3 enforced | Hold the 178 incomplete course reads and 38 incomplete matrix runs. Approved entries are untouched. Corrected reads may supersede pending reads, with history kept. Superseding reads are never approved automatically. No duplicates. | Release v2.15.415 (branch cf247-aer-dr2-dr3); actual held counts verified after deploy | **done 09:08**: PR #810; live md5s match; held 381 of 499 course reads and 38 of 40 matrix runs, exactly as predicted |
| D-M2 | Provider description limit 900 → 1,200 | Quotes and provenance kept; no silent truncation; CDU and other held descriptions revalidated; no unsupported descriptions | Setting `pdesc.max_chars` changed with this authority and a control event; held pilot reads re-read | **done 08:47** (event #28693; CDU, Monash, ACU re-queued #28694; outcomes in the next checkpoint) |
| D-M3 | Semester-pair reading on | "Semester 1 and 2" names both periods. A label alone never gives a date. Explicit periods, years and exclusions are preserved. About 414 rows reconciled before and after. | Setting `intake_dates.name_period_lists` 0 → 1; before/after counts recorded | **done 08:48** (event #28695; before: 122 filled to the day, 81 to the year, 600 skipped under the single-period rule) |
| D-M4 | Withdraw the 94 excluded-month intake rows | The exact 94 ids (md5 df15c7c6…). Guarded, with rollback. History kept. Destination state and Website API verified. Partial or mismatched execution refused. | Paste file `PASTE-20261103-intake-excluded-months-withdrawal.sql` | **done 08:49**: all guards passed, exactly 94 withdrawn (event #28696, id md5 df15c7c6…); the detector now lists 0 active; search refresh requested |
| D-M5 | SSC month list | Stays held for evidence review | none | held |
| D-M6 | Scholarships beyond universities, phased | Eligible registered providers (TAFE, VET, HE institutes) with verified official scholarship evidence. Representative pilots first. Stop on wrong-provider admission, unsupported eligibility, or budget or operational regression. | P1 and P2 settings, scoped to a pilot cohort | in progress |
| D-M7 | Legitimacy criteria replace the 30-course minimum | Identity, official source, audience and country, benefit and eligibility evidence, duplicate and edition protection, closing date and status rules, Layer 4, existing budgets | P2 `scholarship.legitimacy_checks_on`, with the pilot | in progress |
| D-M8 | Overlapping worker-outcome-check | Not enabled while v2.15.412 gives equivalent coverage | Stays paused | done |
| D-M9 | IQ-00043 (P1) | Permanent prevention of reactivating superseded, held, rejected, protected or retired links; reconcile the 13 courses and others with the same root cause | Workstream E fix and release | in progress |
| D-M10 | Gate C retest; contention checks | Retest windows and the rolling 24 h | Workstream F evidence | in progress |
| D-M11 | Restore rehearsal | Prepared with a US$3 ceiling; **no spend until explicitly authorised** | Preparation only | prepared, not authorised |
| D-M12 | PITR check | Authorised Dashboard read, if available | Platform Admin Dashboard read (the integrator has no Dashboard sign-in) | needs the Platform Admin |
| — | D-A6, E16 C1, the 7 refused links, H07, SSC | Separate exceptions; not broadened | unchanged | open |

## Execution notes (3 Nov, 09:20)

- **D-M3:** the intake job runs hourly at :26. The first run with the pair reading is 09:26; the after counts go in the next checkpoint. Before (event #28695): 122 filled to the day, 81 to the year, 2,197 skipped.
- **D-M4:** consumer check. UWA Master of Philosophy (Science) (course 0e04d722…) had only the two withdrawn months (January, December). Website API v2 now returns `intakes: []` for it, so it no longer shows months the page excludes. Search refresh request 7901 was processed at 08:56.
- **D-M2:** the re-reads are blocked by a picker time-out introduced in v2.15.410 (IQ-00055, P2: the stored-copy page rule is evaluated per artifact). Workstream C is fixing it. The three reads stay queued until then; nothing wrong is published.
- **D-M9:** the IQ-00043 fix is built.
  - The root cause is job `exit-awards-apply` (:37 hourly) sending fragment addresses into `coverage_apply_course_v1`, whose upsert sets `status = 'active'`.
  - Release v2.15.416 is in its full suite.
  - Afterwards the paste file restores the 13 La Trobe links. The set is 13 links with id md5 `e31aadee…`; no other record shows the same cause.

## 09:32: Platform-led enrichment and autonomy direction

Recorded verbatim in `2026-11-03-platform-led-enrichment-autonomy-mandate-0932.md`. It supersedes any instruction for Claude or its agents to enrich records by hand.

**Integrator practice from 09:32:**
- **No more record-level dispatch:** no more record-level re-queues by SQL, such as the 08:47 description retry (#28694). Re-reads go through the operator controls ("Read these again") or the platform's own schedules.
- **What remains:**
  - configuration under existing authority (settings and pilot cohorts with a recorded reason);
  - releases;
  - bounded acceptance tests;
  - read-only diagnosis.
- **Paste files:** they remain for governed corrections the Platform Admin approves, such as D-M4 and the IQ-00043 13-link restore.

**Deliverable:** `2026-11-03-platform-enrichment-control-autonomy-acceptance-report.md`, the per-field control and autonomy matrix with the acceptance verdict.
