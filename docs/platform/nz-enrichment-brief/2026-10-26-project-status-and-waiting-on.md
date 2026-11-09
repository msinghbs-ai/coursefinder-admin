# CourseFinder project status and waiting list

Date: 26 October 2026, live checks at 21:12 AEDT (10:12 UTC).
Change control: CF-CHG-20260915-247.
Scope: read-only review of the two repositories and the live Supabase project. No live data, setting, job, migration or deployment was changed by this review.

## 1 Sources and currentness

- Pilot `main`: `054cfcda21d55c3eeb52fed0027b9a2c0b1cee27`, v2.15.359 / PR #705. No open pull requests at the check.
- Admin `main` before this record: `ad237e6ba7728c9471f91cd349d5588bf5c078eb`.
- Current programme records: `../ui-audit/2026-10-26-au-completion-week.md`, `../ui-audit/2026-10-26-au-wave-checkins.md`, `../ui-audit/2026-10-25-speed-reconfiguration.md`, `../ui-audit/2026-10-26-auto-admit-escalation.md` and `../ui-audit/2026-10-26-test-governance.md`.
- Live checks: AU publish eligibility, Layer 4 and policy queues, job activation, governed switches, and the presence of the Track B / Track A / description objects.
- `INDEX.md` was last updated at 07:40 and is not current enough to be the sole status source: it omits v2.15.356–v2.15.359 and the AU completion wave. This record uses the later mandate records and live state.

## 2 Executive position

CourseFinder is not waiting on R1, the `target_only` audit, O10 or R2. Those stages have landed. The current primary track is the expedited AU completion wave, with the speed programme and Layer 4 learning loop running alongside it.

The latest release is v2.15.359. It closes a genuine admission-gate hole by putting the tuition identity check at the fee table for every writer and by checking identity in the adapter before it supersedes an existing fee. The local suite for that release passed 1,005 tests with none skipped or failed. Separately, the first weekly deployed run exposed a rotten deployed test track and one Coverage HTTP 500; that is not the same as a red local merge suite.

The AU wave's largest unblock is administrative, not a new build: two count-guarded paste files are ready for the Platform Admin, the held CRICOS departures still need their separate decision, and the staged AU entry-matrix reader remains off. The original Thursday targets are not credible at the measured pace and have already been rebaselined in the latest check-in record.

## 3 What has landed

| Area | Current state |
|---|---|
| R1: backoff, per-mode ledger, why-idle, apply-time identity | Landed v2.15.339 / #681. `ledger-retention` is active; the governed ledger retention remains 90 days. |
| R3: hourly health | Landed v2.15.340 / #682. `health-hourly` is active at minute 11. `health.headline_target` is still 0, meaning not set. |
| `target_only` audit and O10 | Audit produced; O10 approved; staged overrides-then-rule-settings route recorded. |
| R2 and Tranche 1 | Landed v2.15.350 / #692; cap 100 and Tranche 1 applied. The first weekly line reports a 31% correct-page rate, so Tranche 2 selection must continue to use evidence rather than provider size. |
| Gate consolidation and SP-1 | v2.15.352–v2.15.354 landed. No-page proposals are on; the no-page/conjoint and named-refusal mechanisms are live. |
| SP-2a auto-admit | v2.15.356 / #698 landed. `layer4-auto-admit` is active at minute 47. The bootstrap is now progressing through person-approved shape leaders. |
| Layer 4 first-run usability | v2.15.357 / #702 landed. Provider-entity first runs appear under their university with approve/edit/reject actions. |
| CRICOS end dates and AU publish eligibility | v2.15.358 / #703 landed. Ended and current registrations are now separable; the publish eligibility function is live. |
| AU entry matrix, step A | #704 landed, but only staged: 20 AU providers are listed, `entry.matrix_enabled` is 0 and `entry-matrix-read` is inactive. |
| Universal tuition identity gate | v2.15.359 / #705 landed. `fees.identity_gate_on` is 1. |

## 4 Active AU completion wave

### Baseline and latest recorded progress

The 26 October baseline was 26,103 active AU courses, with 5,435 (20.8%) complete across all 11 core fields. The latest recorded coverage snapshot in the wave file, at 18:47, was 5,439 complete, 310 in automatic work and 20,354 blocked.

At the 19:45 check-in:

- international tuition had reached 8,427 courses;
- 244 AU fee schedules had been found and 37 read;
- all AU lanes were moving;
- the fee queue was 576 done, one leased, none queued and four failed;
- Firecrawl use was 1,040 of 25,000 credits and fee-reader AI was US$1.89 of US$5.

These are the latest lodged operational measurements, not a claim that they are the values at 21:12.

### Thursday outcome targets

The original 29 October targets are not supported by the arithmetic:

- 7,500–9,000 complete: the first check-in projected at most 5,463 before the later rebaseline;
- 8,000+ in automatic work: publishing the eligible providers alone adds only about 205 courses to automatic work;
- under 10,000 blocked: the projection remained about 20,150.

The 19:45 record proposes a realistic scorecard: 5,600 complete (floor 5,540, with limited upside), automatic work reported per lane rather than as one unsupported number, and zero blocked rows without a named cause and owner. It records the 10,000-blocked target as retired. Intakes remain the binding field; delivery has no lane yet.

### Live publish gate at 21:12

The publish paste has not been applied. The live eligibility function still returns exactly:

| Verdict | Providers | Courses |
|---|---:|---:|
| Publish: registered and site answers | 1,056 | 9,454 |
| Hold: site gave no course pages | 147 | 1,101 |
| Hold: no website on record | 104 | 564 |
| Hold: site not checked yet | 10 | 26 |
| Hold: CRICOS registration ended | 5 | 28 |

## 5 Waiting on the Platform Admin now

1. **Apply the AU publish paste at the intended 08:00 gate.** File: `docs/platform/pastes/PASTE-20261026-au-publish-eligible-providers.sql`. It is count-guarded for 1,056 providers and was verified by a rolled-back live dry run. The live 21:12 re-check still returns the same 1,056 / 9,454 population. The agent verifies every row after application.

2. **Decide the 563 held CRICOS register departures separately.** This remains the existing Layer 1 operations approval; it is not in the publish paste. 318 of the held courses belong to providers in that paste, so publishing first would make those off-register courses visible. The publish and departure decisions should therefore be handled together operationally, while keeping the two governed actions separate.

3. **Apply the AU fee re-apply paste.** File: `docs/platform/pastes/PASTE-20261026-au-fee-reapply.sql`. It covers 386 held items whose strong identity proof is now accepted: 80 courses with no live fee, 70 with the same amount already live and 236 with another fee year. The dry run produced 386 live fees, 386 approvals and 386 decision rows. It completes 27 courses. Fourteen items stay with a person: ten same-year conflicts and four without a stored fee row. No re-apply control event was found after the paste was lodged.

4. **Confirm activation of the AU top-20 entry-matrix reader on Tuesday.** The release is live but deliberately inert: `entry.matrix_enabled = 0` and `entry-matrix-read` is inactive. Activation requires both the governed switch and job activation; a passing qualification does not activate it.

5. **Return the AU policy MARK-FILE with approve/reject marks.** File: `docs/platform/reports/2026-10-26/AU-policy-approvals-MARK-FILE.xlsx`: five English policies and 30 intake calendars. The immediate yield is at most 27 courses, and four English defaults are recommended for rejection because they disagree with course-page evidence. Across all countries, the live policy queue currently has 59 proposed rows: 16 English and 43 calendars. Current live rows and the MARK-FILE should be used, not the older count of 65 as a blind apply target.

6. **Tuesday fee-scope decision after publishing:** whether `fees.provider_types` adds `private_vet` and `school`. This would bring roughly 1,000 newly published AU private providers into scope, but because the setting is shared it would also bring NZ's 383 private providers into scope. That cross-country effect is the reason this is a separate decision.

7. **Continue the Layer 4 first-run leader reviews and the ordinary review queue.** At 21:12 there were 789 pending Layer 4 items: 500 tuition, 189 tuition validation, 43 official-course-link, 38 no-page first runs, 16 conjoint first runs and three English. Six first-run items have been decided since the earlier 60-waiting measurement, leaving 54. The next active hourly auto-admit run can process eligible followers of approved shapes; novel shapes, unverified lists, unconfirmed samples and providers without a list still need the designed human or evidence path. The 386-item fee paste will clear much of the tuition backlog only after it is applied.

8. **Decide the deployed-test remediation proposal.** The first weekly safe run produced 42 failures out of 84 on desktop and 41 out of 84 on phone, with ten live-acting tests held. The proposal is to retire about 31 obsolete screen/release assertions, reshape about nine data-dependent tests, add a slim current acceptance set, and investigate the Coverage 500 and possible `provider_context` regression. The weekly run remains on and will honestly fail again if no remediation is approved.

9. **SIT NZQA 3954:** the stored register extract has now been shown and the register itself titles the row `--`. The remaining action is the Platform Admin's go-ahead for the one-row quarantine paste, followed by Platform Admin application. Branch `cf247-sit3954-extract` also remains undeleted because this session's GitHub route refuses branch deletion.

## 6 Work waiting on the agent or a later release

### In the current AU wave

- **Provider description reader:** draft branch `cf247-provider-description-reader` exists; it is not merged and `pipeline.provider_descriptions` is absent live. Worker mode, AI spend guard, inactive job and contract coverage remain before the Wollongong acceptance test and any activation.
- **Delivery reader:** build this week, but first determine whether the 3,390 eligible 'not on page' rows are genuinely silent pages or misses by the existing Enrich fields reader.
- **AU top-20 calendar MARK-FILE:** due after the current general MARK-FILE.
- **Weekly workbook generator:** proposed as a catalogued Friday workflow; not yet built.
- **Thursday re-run:** report the revised outcome measures and give every remaining blocked row a cause and owner.
- **Non-AU scholarship job:** investigate the latest `scholarship-course-attribute-full` deadlock.

### Speed, Track B and the older standing sequence

- **Search-quality / Defect 1 batch:** still to land. It includes query-result verdict logging, recipe learning, near-twin/title verification and the approved redirect-to-other-course rejection rule. `pipeline.course_link_search_results` is absent live.
- **Track B release 1:** approved but not landed. `pipeline.course_events` is absent live, so the Fields section, Pipeline strip, course events and stored-copy replay remain outstanding. S5/S6 visibility rides with this release or its approved immediate split.
- **Track A remainder:** the stepped read-lane test, full S1 rejection consumption and 8a remain. No `country_identity_rules` table exists live. Items 2.2–2.4 and 9–11 stay behind their recorded sequence.
- **AU B1–B6 programme:** not complete. Entry requirements are only staged and off; course descriptions still need a reader; provider descriptions are in draft; the scholarship second pass and the remaining build items are not closed by the current AU wave.

These items must not be represented as blocked on R1/O10/R2. They are queued behind the current primary track, awaiting their own build or approval gates.

## 7 Operational and quality issues to keep visible

- **Deployed acceptance is unhealthy despite green local merges.** Keep the local and deployed results separate in status reports.
- **Coverage HTTP 500:** reproduce in API logs and check the likely :23-hour contention; the current timeout explanation is plausible but unproven.
- **Possible `provider_context` regression:** check before retiring the affected deployed assertion as a mere data pin.
- **Layer 4 volume:** 789 pending items is material review load. The fee paste and auto-admit learning loop address different portions; neither should be used to bypass evidence checks.
- **No-page quality:** Waikato showed that a 0.6 word-overlap check can miss a rename. The near-twin rule belongs in Defect 1, not in an unreviewed threshold tweak.
- **R3 target:** still unset. Set the provisional headline target only after the first full week of hourly rows.
- **Tranche evidence:** the first weekly correct-page rate is 31%, below the 60% quality gate. Further target expansion must follow the recorded evidence route, not raw provider size.

## 8 Parked, not today's critical path

- `zero_yield.auto_reset` after the UoA pilot review.
- UoA catalogue-host allowance versus manual bindings.
- O5 NZQA signatory-list URL.
- O8/O9 Firecrawl and OpenRouter plan tiers and caps; S3 stop calibration waits on these.
- R3 provisional headline target after its first full week.
- Policy proposals not included in the current AU action file.
- F9 rejected-quote retention and full zero-yield S1 consumption remain technical follow-ups, not completed work.

## 9 Repository housekeeping

- `docs/platform/nz-enrichment-brief/.record-gap-check` still exists and should be removed in a docs-only cleanup.
- The earlier accidental placeholder/no-op commit noise remains in Git history. It has not been cleaned up; no history rewrite should occur without explicit approval.
- `INDEX.md` needs a deliberate refresh against the later records and this review. A partial date-only edit would leave its standing-order and release sections misleading.

## 10 Recommended next sequence

1. At the Tuesday gate, handle the publish paste and the held departures together as separate governed actions; verify both.
2. Apply and verify the 386-item fee re-apply paste; leave the 14 exceptions for person review.
3. Confirm and activate the AU top-20 entry matrix; measure first runs before widening.
4. Return the current MARK-FILE and decide the shared private-provider fee scope with its NZ effect explicit.
5. Continue Layer 4 shape leaders and inspect the next auto-admit outcomes rather than assuming bootstrap completion.
6. Keep the description, delivery and search-quality builds inside their recorded release sequence; do not displace them with already-completed R1/O10/R2 work.
7. Approve and execute the deployed-test remediation, including the Coverage 500 and `provider_context` checks.
8. Refresh INDEX and remove the accidental placeholder as a separate documentation cleanup.
