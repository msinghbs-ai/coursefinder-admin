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
