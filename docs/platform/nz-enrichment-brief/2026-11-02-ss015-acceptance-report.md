# SS-015 accelerated acceptance report (2 Nov 2026, 07:35 AEDT)

**Decision governing this report:** Platform Admin, 2 Nov 2026 05:45 (`2026-11-02-ss015-accelerated-acceptance-decision.md`). It supersedes the two-week gate of record §31.6, which is kept for audit.
**External requirement check:** the Admin repository holds no contractual, security or regulatory observation period. The superseded plan v1.3 mentions "2–5 business day hypercare", which is internal. Contracts held outside the repository were not visible.

**Evidence streams:**

| Stream | Scope | Record |
|---|---|---|
| A | Jobs, scheduling, concurrency | `2026-11-02-ss015-gate-c-jobs.md` |
| B | Data integrity | `2026-11-02-ss015-gate-b-data-integrity.md` |
| C | Release integrity and API | `2026-11-02-ss015-gate-a-release-integrity.md` |
| D | UI and roles | §E below; integrator |
| E | Alerts, recovery, budgets | `2026-11-02-ss015-gate-d-e-recovery.md` |
| F | This report | Integrator |

All streams were read-only, or used isolated local fixtures. No failure was injected into production and no protection was disabled.

## 1. Gate status

| Gate | Verdict | Evidence | Remaining to pass |
|---|---|---|---|
| **A** Release integrity | **Insufficient Evidence** (5 of 6 lines pass) | Live v2.15.401 (Pilot `c9338a91`, PR #793; screen shows v2.15.401). Full suite 1,416 / 0 / 0. Migration `20261102010000`: history md5 = file `01695ad7`; functions `9757abee`, `4be9267d`, `50c31fc4` as planned. Consumer API: `consumer-api-guard` clean; 75 functions, 48 tables, 5 edge functions match the baseline. Migrations from 1 Nov match git byte for byte | A full deployed run on desktop and phone (run 41343856629, started 07:30, live-acting held) must pass. The scheduled weekly run did not fire at 05:17 |
| **B** Data integrity | **Fail** (line 4) | E1, E14 and E15 still verified (stream B, 06:20). **E13 live** in v2.15.401: the gate holds 215 of 499 pending entry items, measured live after deploy; approval is refused by the server (s213). Representative validation passes (18/18, AU/NZ/CA). Held values are withheld (null) at the API | **E16** (sibling-variant pages and fees: 67 confirmed courses, 31 fees) needs a decision and containment. Pack: `2026-11-02-e16-sibling-variant-links-decision-pack.md` |
| **C** Operational reliability | **Insufficient Evidence** | 35,335 scheduler runs from 1 Nov 09:25 to 2 Nov 05:47: 0 failed, 0 timed out, 0 cancelled; admission p100 95.8 s (limit 120 s); queues moving; budgets well inside limits | (1) The window closes 09:25, or 11:05 if the 1 Nov admission change counts. (2) The 12 daily jobs due 06:17–08:23 succeed. (3) Two low-frequency jobs are not observable in the window: `provider-document-check-weekly-q4` (3 Nov 08:23) and `statistics-edition-discovery` (5 Nov 13:41). Observe them, or exercise them with an approved fixture, and disclose |
| **D** Stress and recovery | **Fail** (restore) | Pass: interrupted operations (claims reclaimed; s148, s197, s172), migration failure refusal and rollback (s203 plus a local rehearsal), search writer-lock deadlock reproduction (3 before the fix, 0 after). Insufficient: alerts and escalation (dedup proven live; escalation to the same person only; receipt not confirmed) and executed concurrency tests for the admission jobs and page readers | **Isolated restore rehearsal:** restore a daily backup into a separate temporary project (about US$2–3, needs Platform Admin approval). Today's database cannot be rebuilt from git. The 27 GB of stored evidence is outside database backups |
| **E** Operational handover | **Fail** (recovery instructions; P1 acceptance) | Pass: critical UI workflows run live today by the Platform Admin session (Layer 4 decisions, including #28588 E15; 105 Entry requirements withdrawals; course-link repair verification). Permissions: six-role fixtures pass (s207–s211); live 1/6 (Platform Admin), with that limitation disclosed. No P0 open | (1) A recovery runbook with RPO and RTO (none defined). (2) E16 containment and an acceptance decision. (3) Monitoring ownership: one person, no deputy, no external watchdog for the alert task. (4) Costs: Firecrawl limits refuse; the AI daily ceiling and credit floor only warn (OpenRouter "observe"); the monthly Firecrawl total could exceed 500,000 at the current daily share |

## 2. Remaining genuine production blockers (smallest exact scope)

| # | Blocker | Gate | Owner | Smallest action | Evidence for retest |
|---|---|---|---|---|---|
| 1 | E16: 67 courses show a sibling programme's page; 31 show its fee | B, E | Platform Admin decides; Claude executes | Approve E16-1 (prevention), E16-4 (hold the 67) and E16-5 (withdraw 31 fees) | Website/Zoho return null URL and no fee on the 67; new binding refused in fixtures |
| 2 | No data restore ever exercised; no recovery runbook, RPO or RTO | D, E | Platform Admin decides targets and cost; Claude rehearses and writes | Approve the isolated restore (about US$2–3); state the RPO/RTO; decide how the stored evidence files are recovered | Restore log, row counts against production, timed runbook |
| 3 | Gate C window and low-frequency jobs | C | Claude | Re-measure after 09:25/11:05; observe the weekly job 3 Nov 08:23; fixture-exercise or observe the statistics job (5 Nov) | Run ids and results |
| 4 | Deployed desktop and phone UAT | A | Claude | Run 41343856629 (in progress) | Run result |
| 5 | Alert receipt and escalation | D, E | Platform Admin | Confirm receipt; name a second recipient; approve an external watchdog for the alert task (or accept it as a residual P1 with containment) | Alert delivery log |
| 6 | AI spend ceiling only warns | E | Platform Admin | Decide: enforce (block at US$14 a day) or accept as residual with the current daily review | Setting and refusal test |

**Not blockers:**
- **Monitoring-accuracy defects (P2):** the false critical at 03:00, from pages of hidden providers being counted, and a daily-cap pause shown as "stuck". The fix is to align the watchdog and health counting with the readers. No data or job impact.
- **Routine coverage gaps and held values:** these are safely withheld.
- **Lower-priority data items (P2):**
  - 64 domestic-score courses, labelled;
  - 29 tuition-history fees from unapproved sources;
  - Mohawk and Georgian course codes;
  - 239 courses with multiple links (E16-2/E16-3 hygiene);
  - the stuck batch display from 29 Sep;
  - an out-of-date `OPERATIONAL-LIMITS.md`;
  - about 25 old one-off workflows.

## 3. Engineering and UI acceptance completed

- **Releases since 1 Nov 21:25:** v2.15.396–401, each verified live. v2.15.401 is E13.
- **SS-016:** 2/17 accepted, 13 implemented and awaiting acceptance, 2 remaining (UR-14, UR-15: investigation; findings feed blocker 2).
- **UR-18 slice 1:** built and fixture-tested (1,414 / 0 / 0), **not released**. Waiting on: (a) the decision on campus-link reversal, which deletes the row the operation added; (b) the live dry run; (c) a compatibility check of the shared Layer 4 decision function. Production apply off; D-B4 not approved.

## 4. Catalogue integrity

| Item | State |
|---|---|
| E1, E14, E15 | Done and verified 2 Nov (41 fees, 105 entry rows, 6 course links); still verified at 06:20 |
| E13 | Live: 215 incomplete or mixed reads held from approval |
| E16 | Open, P1: 67 confirmed, 1 false positive, 9 unclear; 31 sibling fees |
| SS-007 holds | 177 open; 0 links reach the website |
| Held values | 140 scholarships, 30 fees and 499 entry reads held; null at the API |
| Representative validation | 18/18 consistent and sourced (AU, NZ, CA) |
| Layer 4 | 1,353 pending (opening 1,870); 521 decisions verified; 1,304 active entry rows |

## 5. Earliest evidence-supported GO/NO-GO

**3 Nov 2026, after 09:00 AEDT**, if the Platform Admin decides blockers 1, 2, 5 and 6 today. On that basis:
- E16 containment and the restore rehearsal complete today;
- Gate C closes today at 11:05 at the latest;
- the weekly document check is observed at 3 Nov 08:23;
- the statistics job (5 Nov) is exercised with an approved fixture and disclosed.

Otherwise the GO/NO-GO moves to the day after the last decision. This is a target, not an automatic acceptance date.

## 6. Post-handover monitoring

| What | How | Owner |
|---|---|---|
| Seven-day trend, T1–T8 (thresholds unchanged) | Weekly scorecard and Monday line; insufficient data stays Insufficient | Claude prepares; Platform Admin reviews |
| Alerts | Hourly delivery by push and e-mail; deduplication; 12-hour reminder | Platform Admin (a second recipient is to be named) |
| Consumer API drift | `consumer-api-guard` daily; edge drift check | Automatic; a hard flag goes to the Platform Admin |
| Deployed UAT | Weekly run (schedule to be checked; dispatched by hand today) | Claude |
| Budgets | Daily AI and Firecrawl spend against ceilings | Platform Admin |
| A serious breach after acceptance | Incident response, containment, and withdrawal of acceptance for the affected capability | Platform Admin |
