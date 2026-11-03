# First-run failure audit and switch audit (4 Nov 2026)

**For:** Platform Admin mandate of 4 Nov 2026 08:16 AEDT (`2026-11-04-p0-autonomous-operations-acceptance-mandate-0816.md`), §2 (why released capabilities fail on their first run), §6 (switches and activation readiness) and §10 (scorecard sources).
**By:** development agent under the Integration Controller. Read-only against production `fxcwkweaxjtknorudmwp`; nothing was switched on, changed or merged.
**Build that follows from it:** Pilot branch `cf247-first-run-verification` (migration `20261104460000`, spec s275, fixture `tests/fixtures/first-run-verification/`). See §5.

## Summary

- **The releases did not fail for one reason.** Of 9 material failures:
  - 3 were inputs that tests never had: fixtures not shaped like production, or not at production volume.
  - 2 were drift between live objects and the checked-in code or constraints.
  - 2 were valid caps, or switches deliberately left off, that nothing reported as a stall.
  - 2 were controller routing defects.
  - None was a failure of AI reasoning.
- **Nothing checks a release after its migration lands:**
  - The V3 release check (`security.integration_deploy_check_v1`) exists, but `pipeline.integration_deploy_checks` is **empty**. It has never been called in production. "Verified" in the register has meant md5s checked by hand in a chat.
  - No record follows a changed scheduled job to its first run. So a release is called verified before its job has ever run.
- **Jobs report success while their stage does not move.** Two examples:
  - AER scheduled reading succeeded 16 of 16 runs and admitted 0 rows.
  - Course page discovery is paused, and 1,438 AER gap findings are `no_source` with no source attempt.
  - Neither appears anywhere as a stalled stage.
- **The controller cannot route a new job's first failure:**
  - Its release-regression rule needs a success before the failure streak, and a new job has none. So IQ-00239 was `unclassified` and sent to `needs_decision` ("no automatic remedy for unclassified").
  - IQ-00241, raised by hand for the same fault, got a weak correlation key. Weak keys are never superseded, so the two issues were never linked.
  - No open issue in the sample had an assignee or a checkpoint.
- **Scholarship classifier (v2.15.461):**
  - The first scheduled run after the fix succeeded at 08:29: run 1211430, 32 s, 40 providers, 4,577 coverage cases. 12 of the 13 states are populated; `evidence_backed_none` is 0.
  - This is evidence for the Integration Controller's §1 verification. IQ-00239 and IQ-00241 are not closed here.

## 1. Evidence: how it was read (Sydney time, every query)

| Time | Read | Kind |
|---|---|---|
| 08:19:49 | integration_issues columns; md5 of 10 controller and queue functions; migration head | light (catalogue) |
| 08:19:58 | 25 integration issues by ref | light (small table) |
| 08:20:05 | 5 controller function definitions | light (catalogue) |
| 08:20:54 | columns of 17 pipeline and catalogue tables | light (catalogue) |
| 08:21:02, 08:21:10 | switch values (`platform_toolset_settings`) | light (small table) |
| 08:21:18 | `cron.job` for 40 jobs | light |
| 08:23:33 | status counts: AER gaps, entry rows, scholarship reviews, admission log, listings, matrix sources | light to medium (largest table 24k rows) |
| 08:23:47 | two function definitions | light (catalogue) |
| **08:25:52** | **runs of 11 jobs since 3 Nov 16:00 (`cron.job_run_details`, about 32,000 rows by run id)** | **heavy. Slip: 8 seconds before the :x6 slot** |
| 08:26:02 | classifier md5, migration versions, coverage counts, deploy checks | light |
| 08:27:03 | evidence of IQ-00239, IQ-00241, IQ-00074 | light |
| 08:30:08, 08:30:13 | the 08:29 classifier run by run id (2 rows) and the coverage tables | light |
| 08:56–08:58 | baseline readings of the progress transitions (§6) | heavy, inside the slot |

Nothing was read at :35–:42 or :47–:48.

## 2. Failure audit (§2)

### 2.1 Answers to the ten questions

Key to the column numbers:

1. Was the defect present before deployment?
2. Did the tests use production shape and cardinality?
3. Did the release need a behaviour switch?
4. Was that switch activated?
5. Did the first scheduled run complete?
6. Were output records created?
7. Did downstream work resume?
8. Was anything admitted or published?
9. Did a controller detect the failure and remedy it automatically?
10. Why was a person needed?

| # | Failure (release, evidence) | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | Root cause |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| F1 | **course-relink** (v2.15.443, contract). Statement time-outs in `course_relink_slugs_v1`, failing since 17:34 3 Nov (first failed run 1186211). 32 of 99 runs failed (17:34–22:44); the 22:04 and 22:14 runs after v2.15.443 still failed. Fixed by v2.15.445 (merged 22:49); 67 runs succeeded since 22:54. IQ-00074. | Yes | No. The fixture had a few courses per university; production has thousands, and one statement ran over its time budget. | `wc.relink_fair_on` | Yes (1) | **No** (22:04, 22:14) | No (rolled back) | No | No | Detected (job_failed). Diagnosed `timeout_under_load`, retried as load, then blocked `needs_release` when attempts ran out. Not remedied. | A person traced the time-out to one statement and wrote the per-university isolation (v2.15.445). | **Time budget** (fixture not at production volume) |
| F2 | **provider-identity-check** (v2.15.433). First run 18:16 failed: the job's issue write broke `integration_issues_root_cause_class_check` (run 1187444). 5 of 15 runs failed until v2.15.444 (23:16). IQ-00077. | Yes | No. The fixture's queue stub had no check constraint, so the class value written was never refused. | identity.* | Yes | **No** | No | No | No | Detected. Not diagnosed beyond a code defect. | A person found that the job wrote a value the live constraint refuses. | **Live constraint drift** (fixture not production-shaped) |
| F3 | **Layer 4 rule executor** (v2.15.447). First call 23:43 failed: "column apply of relation layer4_rule_runs does not exist". The live-only table `pipeline.layer4_rule_runs` (78 rows) has no checked-in migration, so `create table if not exists` skipped. Fixed by v2.15.448 (own tables). IQ-00161 (closed). | Yes | No. The fixture is built from git, which does not have the table. | `layer4.*_on` | Yes | No (manual count call) | No | No | No | No. The executor is not a scheduled job, so nothing watched it. | Found by the Integration Controller on its own call. | **Live-only object drift** |
| F4 | **Simon Fraser rule, strict validation** (v2.15.447/448). The strict level check timed out on the 86 Simon Fraser items. Fixed by v2.15.451. | Yes | No. Not at production volume. | rule | Yes | No | No | No | No | No | Found when the rule was run by hand. | **Time budget** |
| F5 | **Simon Fraser rule decisions refused** (v2.15.451). 11 items: "the link must be a full https:// web address". The rewrite dropped the scheme. Fixed by v2.15.453. IQ-00189 (closed). | Yes | No. The fixture addresses had no "http://" source shape. | rule | Yes | Partly (34 of 58 decided) | Partly | Partly | 34 links admitted | No | Found in the run counts by the Integration Controller. | **Fixture not production-shaped** (address forms) |
| F6 | **scholarship-coverage-classify** (v2.15.460, merged 06:03). Runs 1208143 (06:29) and 1209768 (07:29) failed: "ON CONFLICT DO UPDATE command cannot affect row a second time". Listing pages repeat an address. Fixed by v2.15.461 (merged 07:44). The first run after the fix, 1211430 (08:29), succeeded: 40 providers, 4,577 cases. IQ-00239, IQ-00241. | Yes | No. The fixture seed had no repeated address. | `sch_cov.classify_on` | Yes (1) | **No** (twice) | No (0 cases until 08:29) | No: work continuity and the human-assisted recovery have no scholarship cases | No | Detected as IQ-00239 (06:51). Diagnosed `unclassified` and sent to `needs_decision`. Not linked to IQ-00241. | A person diagnosed it and started the fix. The controller asked the Platform Admin for a decision on a code defect. | **Fixture not production-shaped**, then **controller did not route** |
| F7 | **AER scheduled reading: 0 admissions** (v2.15.427, activated 3 Nov). 16 of 16 runs succeeded. 0 rows admitted overnight. The daily cap of 200 was reached at 03:13. Back-pressure stood at 605 waiting against the 600 limit. 0 AER decisions were made in Layer 4 overnight. IQ-00128. | No | n/a | `wc.aer_fair_on` (v2.15.450) | **No (0)**, by decision until 24 h of observation | Yes | Yes (132 rows proposed, 48 Layer 4 items) | No: held at Layer 4 | **No** | No: a "succeeded" job does not raise anything | A person read the counts in the morning measures. | **Capacity cap** plus **switch not yet activated**. Valid by design; never reported as a stall. |
| F8 | **Course page discovery paused.** `coverage-discover` and `-2` were paused when the Firecrawl window ended on 3 Nov. 1,438 open AER gap findings are `no_source` (live 08:23); the mandate cites 1,424. | No | n/a | job active flag | **No** (paused) | n/a | 0 | No | No | No: a paused job does not raise anything | Seen by people in the reports. | **Switch not activated** (budget). Blocked by authority, with no owner or checkpoint. |
| F9 | **IQ-00239 and IQ-00241 duplicate.** IQ-00239: fingerprint `job_failed:scholarship-coverage-classify`, key `job:…` (strong), `needs_decision`. IQ-00241: raised by hand, key `jobtext:…` (weak, because `ops_issue_subject_v1` reads `evidence.detail.job`, not `evidence.job`). | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | No: weak keys are never superseded, and the subject rule misses `evidence.job` | Two people's work on one fault, unlinked. | **Controller did not route** (correlation and diagnosis rules) |

**Root-cause counts (9 failures):**

| Root cause | Failures | Count |
|---|---|---|
| Fixture not production-shaped | F2, F5, F6 | 3 |
| Time budget at production volume | F1, F4 | 2 |
| Live-only object or constraint drift | F2, F3 | 2 (F2 is also counted above) |
| Capacity cap, or switch not activated | F7, F8 | 2 |
| Controller did not route or link | F6, F9 | 2 (F6 is also counted above) |
| AI reasoning failure | none | 0 |

Every code failure (F1–F6) was in the code before it was deployed, and every one passed a green suite and an md5 deployment check.

### 2.2 Shared defects

| Area | Defect | Evidence |
|---|---|---|
| Testing | Fixtures are built from git and from small hand-made seeds. They do not carry production shape (repeated addresses, http:// sources, live constraints, live-only tables) or volume (rows per university). Production shape is only checked when a fixture copies a live definition. | F1–F6 |
| Production validation | The V3 release check has never been called live: `integration_deploy_checks` has 0 rows. Release "verification" stops at migration and function md5s. Nothing follows a changed job to its first run, compares output with what was expected, or checks that downstream work became eligible. | F1, F2, F6 |
| Activation | Switches and jobs left off by design (`wc.aer_fair_on`, the `sch_cov.*` recovery families, `coverage-discover`) have no owner, checkpoint or stall signal in any record. The morning report finds them by hand. | F7, F8; §3 |
| Orchestration | A job's success is taken as progress. No record says which pipeline stage moved, or why a zero-output run was zero (cap, authority, no eligible work, correct exclusion, technical). | F7, F8 |
| Error isolation | Whole-run rollback on one statement: a time-out (F1) and a duplicate key in one insert (F6). The per-item isolation pattern exists (`coverage_admission_apply_v1`) but is not the default. IQ-00133 lists 8 more batch writers that lack it. | F1, F6, IQ-00133 |
| Issue routing | The release-regression rule needs an earlier success, so a new job's first failure is `unclassified` and goes to `needs_decision`. The subject rule misses `evidence.job`. Weak keys are never linked. Code defects get no assignee, owner or checkpoint: `assignee` is null on every open issue read (25). | F6, F9 |

## 3. Switch audit (§6)

Live values were read at 08:21. "Authorised" cites the decision pack (`nz-enrichment-brief/2026-11-03-decision-pack-2150.md`, with its 07:05 reconciliation) and the mandates of 3 and 4 Nov. No switch was changed.

### 3.1 Switches that are off, or are pending release

| Switch | Live | What is lost while it is off | Exact activation condition | Authorised? | Owner · next checkpoint |
|---|---|---|---|---|---|
| `sch_cov.legal_name_identity_on` | 0 | Torrens stays outside admission. The Motivational Scholarship (international, up to 25%) stays refused. 1 of 43 joined-name providers is affected. | Platform Admin approves decision item 19 | **No.** Awaiting decision. | Platform Admin · next decision review |
| `sch_cov.policy_disposition_on` | 0 | 45 policy-refused providers stay reported as zero (26 issues, 25 of them P1, including IQ-00216 and IQ-00219), so the P1 list overstates defects. | Item 22 approved; severities changed through the governed process | **No** | Platform Admin |
| `sch_cov.recover_register_pages_on` | 0 | 72 never-read register pages (51 providers) stay unread. | Item 20 approved, after the Firecrawl budget decision (2,099 credits left; 06:53: no limit increase) | **No** | Platform Admin (budget) |
| `sch_cov.recover_stored_reads_on` | 0 | Pages refused only under the old name rule are not re-read. This is AI work only, with no Firecrawl. | Item 20, and item 19 first (otherwise nothing becomes eligible) | **No** | Platform Admin |
| `sch_cov.recover_listings_on` | 0 | Listings stay untraversed. Live: 132 suggested listing pages and 181 `traversal_incomplete` cases. The decision pack measured 618 listing verdicts at 158 providers. | Item 20, after the budget decision | **No** | Platform Admin |
| `wc.ai_recovery_on` (failed-field recovery) | 0 | 2,301 field reads are parked as `ai_incomplete`. | Item 9: not before 22:00 4 Nov (24 h of v2.15.443), and only if the retry, spend and independence checks pass | **Yes, with conditions.** Not yet met. | Integration Controller · 22:00 4 Nov |
| `wc.aer_fair_on` (AER fairness and back-pressure) | 0 | One platform-wide count (605 of 600) stops AER reading for every provider, and the daily cap (200) also stops it. | 24-hour observation of v2.15.450 (merged 01:10). The unattended window closes 5 Nov 02:00. | **Yes, with conditions.** Not yet met. | Integration Controller · 5 Nov 02:00 |
| `wc.page_find_release_on` | 0 | Freed page-find slots are not released to the planner. | As `wc.aer_fair_on` | **Yes, with conditions** | Integration Controller · 5 Nov 02:00 |
| `wc.fee_item_claims_on` | 0 | The fee reader stays single-flight. | As `wc.aer_fair_on` | **Yes, with conditions** | Integration Controller · 5 Nov 02:00 |
| `coverage-discover`, `coverage-discover-2` (AER source discovery) | paused | 1,438 providers have no AER source attempt. | A Firecrawl budget decision. 06:53 said stored evidence and free discovery come first, with no limit increase. | **No** | Platform Admin (budget). The human-assisted recovery offers "give the official address" for the 10 named universities. |
| `har.ai_escalate_on` (AI fallback; v2.15.463, being released) | ships 0; model empty | No stronger-model attempt before a person is asked. | A pinned, qualified model is chosen, within the existing cost authority (decision 06:30) | **Partly.** The fallback is authorised, but no model is qualified. | Integration Controller to propose a model; Platform Admin |
| `ops.ai_diagnosis_on` | 0 | No AI-assisted diagnosis of `unclassified` issues. | Caps exist (US$0.50 a day); a qualified pinned model and a decision are needed | **No** | Platform Admin |
| `binding.cricos_identity_guard_on` | 0 | New title-only bindings are not stopped. | Item 7: after evaluation | **Yes, with conditions** (evaluation) | Integration Controller |
| `identity.candidate_check_on` | 0 | No worker read to confirm candidate identity (source recovery). | It spends a worker read; no decision is recorded | **No.** No owner or checkpoint recorded. | **Needs an owner** |
| `reading.entry_global_pages_on`, `entry_range_lower_bound_on`, `entry_subject_rows_on` | 0 | AER reader options for RMIT IB/GAC and UWA rows are not used. | A workstream C qualification | **No.** No checkpoint recorded. | **Needs an owner** |
| `reading.link_search_share_on`, `ops_cost.enforce_*`, `ops.answer_replay_on`, `ops.lane_orphan_release_on`, `ops.lease_orphan_close_on`, `ops.task_dedupe_on`, `layer4.reconcile_supersede_on`, `layer4.arrival_guard_on`, `lifecycle.cascade_on` | 0 | Waste is measured but not stopped. Duplicate and resolvable Layer 4 items stay in the queue (228 `covered_by_active`). Orphaned leases stay. | Each "ships off (removes or reorders work)" | **No.** None has a recorded owner, checkpoint or decision. | **Needs an owner** (§6: no indefinite "built but off") |

### 3.2 Switches that are on and stay on

- `sch_cov.classify_on`
- `wc.on`, `wc.escalate_on`, `wc.relink_fair_on`, `wc.page_find_park_on`, `wc.page_find_never_end_on`, `wc.link_search_continuity_on`
- The free source-recovery routes: `proof.absence_input_on`, `relink.slug_variants_on`, `relink.stored_search_reuse_on`, `relink.year_current_on`
- `har.on`, `har.generate_aer_on`, `har.generate_sch_on`, `har.resume_on` (with v2.15.463)

### 3.3 Activation readiness

**Authorised, with prerequisites met now: none.** These become due as follows, if their checks pass:

| When | Switches | Checks |
|---|---|---|
| 22:00 4 Nov | `wc.ai_recovery_on` | Retry, spend and independence checks |
| 5 Nov 02:00 | `wc.aer_fair_on`, `wc.page_find_release_on`, `wc.fee_item_claims_on` | The 24-hour observation |
| After its evaluation | `binding.cricos_identity_guard_on` | The evaluation |

**Need a decision (one consolidated pack):**

- Items 19, 20 and 22 (the `sch_cov.*` switches). Item 20 also needs the Firecrawl budget.
- The AER source-discovery budget.
- The model for `har.ai_escalate_on` and `ops.ai_diagnosis_on`.
- An owner and checkpoint for the nine "ships off" waste and orphan switches, and for the `reading.*` and `identity.candidate_check_on` options.

## 4. Scorecard sources (§10)

Every query below is read-only. The heavy ones (cron history) are for the :x6–:x8 slots.

| Measure | Existing data | Query |
|---|---|---|
| Scheduled-job reliability | `cron.job_run_details`; justified idle from `pipeline.progress_transitions.zero_reason` (new) | `select count(*), count(*) filter (where status='failed') from (select status, start_time from cron.job_run_details order by runid desc limit 40000) d where start_time >= now()-interval '24 hours';` |
| Automatic diagnosis | `pipeline.integration_issues` (`validation_layer`, `diagnosis`, `ops_state`, `assignee`) | `select count(*) filter (where validation_layer<>'manual') auto, count(*) filter (where validation_layer='manual') by_hand, count(*) filter (where status<>'closed' and assignee is null and ops_state not in ('verified','superseded','verifying')) unowned from pipeline.integration_issues where detected_at >= now()-interval '24 hours';` |
| Automatic recovery | `pipeline.ops_remedy_runs` with `pipeline.ops_remedies.authority = 'auto'` | `select r.remedy_code, r.result, count(*) from pipeline.ops_remedy_runs r join pipeline.ops_remedies m on m.code=r.remedy_code where m.authority='auto' and r.started_at >= now()-interval '24 hours' group by 1,2;` |
| Queue continuity | `pipeline.work_items`; `pipeline.progress_transitions.stalled` (new) | `select lane, stage, count(*), count(*) filter (where next_eligible_at is null) no_next, count(*) filter (where recovered_at >= now()-interval '24 hours') recovered from pipeline.work_items group by 1,2;` |
| Source-to-admission yield | `pipeline.scholarship_admission_log`; `scholarship.scholarships`; `catalogue.course_entry_requirements` | `select (select count(*) from pipeline.scholarship_admission_log where action='admitted' and at >= now()-interval '24 hours') sch, (select count(*) from catalogue.course_entry_requirements where status='active' and updated_at >= now()-interval '24 hours') aer;` |
| Admission-to-publication yield | `scholarship.scholarships.publication_status`; consumer read-back through `api.website_v2_scholarship_item` and `api.zoho_course_lookup_v1` in a `begin transaction read only` | `select count(*) from scholarship.scholarships where lifecycle_status='active' and publication_status='published' and updated_at >= now()-interval '24 hours';` then read each one back through the consumer functions, as in the morning measures §2.3 and §4 |
| Human intervention | `pipeline.layer4_review_items`; `pipeline.scholarship_ai_reviews`; `pipeline.layer4_interventions` (v2.15.463) | `select field_code, count(*) from pipeline.layer4_review_items where status='pending' group by 1;` and `select status, count(*) from pipeline.layer4_interventions group by 1;` |
| Spending | `pipeline.ai_spend_ledger`; `pipeline.coverage_vendor_usage`; `pipeline.vendor_credit_observations`; `budgets.ai_daily_ceiling_usd` | `select (select sum(cost_usd) from pipeline.ai_spend_ledger where at >= now()-interval '24 hours') ai_usd, (select sum(units) from pipeline.coverage_vendor_usage where at >= now()-interval '24 hours') fc_units;` |
| Release correctness | `supabase_migrations.schema_migrations`; `pg_proc` md5s; `pipeline.integration_deploy_checks` (empty today); `pipeline.release_job_verifications` (new) | `select release, ok, operational_status from pipeline.integration_deploy_checks order by id desc limit 20;` and `select release, jobname, status, status_reason from pipeline.release_job_verifications order by id desc;` |
| Unattended operation | The cron history above; the progress readings (`pipeline.progress_observations`, new) | Hours since the last failed run, plus `select key, output_created, zero_reason, stalled from pipeline.progress_transitions;`. A clean window with no eligible data processed counts only if every zero is `no_eligible_work`. |

`security.self_sustainability_v1(24)` (new, read only) computes all ten from these tables, each with a verdict (`met`, `not_met`, `not_measured` or `needs_read_back`). It is also added as a `self_sustainability` section of `security.ops_report_v1`.

## 5. What was built (Pilot `cf247-first-run-verification`, not deployed)

**First-run verification (§3) extends the existing V3 contract. It is not a second one.**

- `pipeline.release_job_verifications` holds one row per release and changed scheduled job: the expected first run (from the job's own schedule), the observed run, its result and error, expected and actual output, downstream eligibility, and the status (`awaiting_first_run`, `operationally_verified` or `failed_first_run`).
- `integration_deploy_checks.operational_status` is a new column. A release reads "deployed, operationally unverified" until its jobs pass.
- The release controller calls `security.release_first_run_register_v1` together with `integration_deploy_check_v1`. Both must now actually be called.
- A failed first run raises or updates `job_failed:<job>`. A fix that fails its first run sends its issue back to `in_progress` with the new evidence.

**Progress contract (§4):**

- `pipeline.progress_transitions` covers the 9 scholarship and 7 AER transitions, with every §4 field.
- A bounded reader counts them from existing tables. Each zero gets a reason: `no_eligible_work`, `cap_reached`, `blocked_authority`, `correctly_excluded` or `technical_failure`.
- A stall is raised as `stall:<transition>`, whatever the producing job reports.

**Recovery loop (§5):**

- Duplicates (same job, same error class) are linked into one canonical issue the controller's way. The canonical issue is the one furthest along its lifecycle. A `supersede_into_owner` run is recorded, so the duplicate closes with its owner.
- Code and SQL defects get assignee `engineering`, a remediation status, the error text, the run id and a 4-hour checkpoint.
- The root cause `first_run_sql_defect` and the remedy `engineering_remediation` (authority: release) mean the controller routes these to `needs_release`, not `needs_decision`.

**Job `first-run-verify`** runs at :02 and :32. It is catalogued and reads its settings from `frv.*`, `progress.*` and `recovery.*`.

**Switches:**

- On (records only): `frv.on`, `progress.on`, `recovery.link_on`, `recovery.route_on`.
- Off: `recovery.close_on_verified_on`.

**Authority:** nothing in the build merges, deploys, grants a budget, decides a Layer 4 item, overrides a lock, admits, publishes or destroys. The fixture asserts this (case 10).

## 6. Baseline progress readings

See §6 below, added after the 08:56 slot.
