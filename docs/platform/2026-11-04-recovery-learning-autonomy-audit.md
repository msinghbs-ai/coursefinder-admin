# Recovery learning: autonomy audit and build (direction 4 Nov 2026 18:08 §1, §2, §3, §6, §7)

**By:** development agent under the Integration Controller.
**Production access:** read-only on `fxcwkweaxjtknorudmwp`.
**Build:** Pilot branch `cf247-recovery-knowledge`, commit `bcbe8e55`, not deployed:
- migration `20261104600000` (md5 `c7a02a6024e4b30f1fbb0aff505a383d`);
- spec s285;
- fixture `tests/fixtures/recovery-knowledge/`.

## 1. Autonomy, last 24 hours (§1)

Window: 3 Nov 2026 18:16 to 4 Nov 2026 18:16 AEDT. Read at 18:16:25, inside the :x6 slot.

| Outcome | Count | What it was |
|---|---:|---|
| Detected automatically | 200 issues | 1 more was raised by hand (Integration Controller) |
| Diagnosed automatically | 243 | Another 10 stayed `unclassified` |
| Remedied automatically | 29 auto remedy runs | Only **1** changed data and verified: `layer4_tuition_publication_repair` (IQ-00116, 06:24). The other 28 were 15 load-profile recordings (3 verified, 11 failed, 1 open), 6 fee rechecks (all failed), 3 Layer 4 rechecks (all failed), 3 cleared-condition confirmations and 1 stale re-close. Linking duplicates (165 runs) is counted apart |
| Verified automatically | 9 runs | 11 issues were closed by the controller |
| Needed Claude engineering | 38 releases | v2.15.434–v2.15.471 merged. The Integration Controller also took 36 issue status steps and 7 closures |
| Needed Platform Admin authority | 39 issues open at `needs_decision` | Also 17 pastes (15 fee withdrawals, 1 correction, 1 re-check) and 19 approved Course Link rule executions |
| Needed a human Layer 4 decision | 338 Course Link decisions + 22 scholarship reviews | The Course Link decisions are 134 approve, 21 edit and approve, and 183 reject, executed as Platform Admin-approved rules. There were 0 AER decisions and 0 intervention answers |

**What was actually admitted and published:**
- **Scholarships:** 5 admitted, 4 published.
- **AER:** 0 rows admitted, 0 published. 605 items wait in Layer 4 and 0 were decided.
- **Course links:** 155 changed and verified on all three consumers (register, 03:00).

**Every data-changing recovery except one came from Claude-built releases or from people.** The platform's own remedies:
- repeated a remedy that could not work 20 times;
- verified 1 data repair.

## 2. Findings that shaped the build

- **No memory across issues.** The controller ran:
  - `record_capacity_profile` 11 times on `job_failed:course-relink`, a code defect that a release fixed;
  - `fee_integrity_recheck` 6 times on IQ-00111, all failed.
- **Most automatic remedies can never be selected.** 28 auto remedies are active. Most of the root causes they treat carry documentary detect rules (`fn`/`sql` keys) that the controller's grammar cannot evaluate. As a result, every scholarship and source-recovery remedy can only run if the Integration Controller forces it. Making these rules executable is a separate change; this build does not alter any detect rule.
- **AER re-reads the same copy.** The held step re-reads an unchanged stored copy: 90 of 100 closed corrections were refused.

## 3. What was built (§2, §3, §7)

The build extends the controller's remedy catalogue and runs. It adds no new controller and no new job.

**The knowledge base:** `pipeline.ops_remedy_knowledge` holds one pattern per remedy and root cause, or per lane. Each pattern records:
- its fingerprints and trigger;
- its authority, and who performs it (platform, Claude engineering, Platform Admin, or Layer 4 human);
- its expected outcome;
- its no-retry and reuse conditions;
- its counts and cost;
- whether it may still run automatically.

Outcomes are recorded in `pipeline.ops_remedy_outcomes`. Remedies stopped for a single fingerprint are recorded in `pipeline.ops_remedy_blocks`.

**The learning step** runs inside job `first-run-verify`. It:
- harvests every verified or failed run;
- stops a remedy on a fingerprint after 3 failures in a row (`learn.no_yield_max`), and the controller's own attempt rule then routes the issue;
- lifts the stop when the issue's evidence changes: a fix, a release or a remediation state.

**Losing eligibility across all patterns:** below 20% verified over the last 6 outcomes, `ops_authorise_v1` refuses the remedy. It is restored only by `ops_learning_eligibility_set_v1`, with an evidence-based reason and a named authority.

**Lanes outside the controller** (the AER recovery selector in v2.15.473) call `ops_learning_retry_check_v1` before repeating an attempt on the same evidence signature: copy, reader and settings.

**Seeds** are real outcomes only:
- every live run;
- the classifier and relink fixes (Claude engineering);
- the Course Link rules (Platform Admin);
- the AER same-copy and row-limit re-reads (platform, not effective).

**The §7 table:**
- It is part of the `self_sustainability` section of `ops_report_v1`, together with the §1 audit, which carries them without its own definition changing (518b5bf8).
- The baseline is taken at release, and a reading is kept every hour.
- It tracks Claude interventions over time.

## 4. Closed loop (§6)

**In the fixture**, these run through the real controller and the learning step:

- **AER:**
  - The controller diagnosed `work_technical_hold` and chose the verified `work_retry_technical` itself.
  - The remedy executed, was verified on the next run and closed the issue, and all 3 items advanced.
  - A re-read of the same copy is refused; a changed copy is allowed.
- **Course Link:**
  - The verified recheck was reused for projection lag.
  - The same recheck was not repeated on a manual-lock fingerprint where it had failed 3 times. The repeat was counted as prevented, and the stop lifted when a fix was deployed.
- **Fees (the refusal case):** `fee_integrity_recheck` (0 of 6 verified) lost eligibility. Authorise refused a new occurrence, which was routed to a release.
- **Scholarships:** the recurring classifier defect became owned engineering work and is never retried automatically. The listing and register recoveries are not automatic until decision item 20, so they stay parked for authority. This is safe, but it is not an automatic recovery.

**Production cases expected after release**, at the first `first-run-verify` run (:02 or :32), then the next controller run (:24 or :54):

1. **IQ-00074** (`job_failed:course-relink`): `record_capacity_profile` is stopped on this fingerprint (8 failures in a row). The next planned repeat is prevented and counted.
2. **IQ-00111 / fees:** `fee_integrity_recheck` loses automatic eligibility, and `remedy_ineffective:fee_integrity_recheck` is raised and owned by engineering.
3. **AER:** an automatic success needs a recurring `work_blocked:aer_technical:technical_hold` issue. The current one (IQ-00203) is superseded into a duplicate decision. The selector in v2.15.473 is the expected source, once it records outcomes through `ops_learning_record_v1`.
4. **Scholarships:** no automatic recovery is possible until decision item 20 or executable detect rules exist.

## 5. Query log (Sydney time)

| Time | Kind |
|---|---|
| 18:09:23, 18:10:04, 18:10:30, 18:10:52 | Light: remedy catalogue, function definitions, root causes |
| 18:11:31 | Light: runs, 45 rows |
| 18:16:25, 18:16:38 | §1 counts, inside the slot |

No reads were made at :35–:42 or :47–:48.
