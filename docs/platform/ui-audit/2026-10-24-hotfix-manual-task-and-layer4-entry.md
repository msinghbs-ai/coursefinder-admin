# HOTFIX — manual task never reaches Firecrawl, stalled task invisible, Layer 4 address entry refused

| | |
|---|---|
| Raised | Platform Admin, 24 Oct 2026 13:17 (Melbourne) with four screenshots: Layer 4 AUT item ("field is not enabled for scalar Layer 4 editing"), Task manager "Find course pages — University of Otago (50 courses)" running · 0 of 50, Adapter builder Otago, PR #683 |
| Priority | Over everything, including the UI audit Phase 3 suite (resumes after this lands) |
| Change control | CF-CHG-20260915-247 |
| Release | **v2.15.342**, PR **#686** against Coursefinder-Pilot, branch `cf247-hotfix-manual-task-layer4` from `main` at `c201a728` (v2.15.341 merged). **Not merged**: Platform Admin review first |
| Migration | `supabase/migrations/20261024009000_cf247_hotfix_manual_task_and_layer4_entry.sql` (md5-guarded edits; dry run against live passed, rolled back) |
| Test | `tests/uat/cf-247-s99-hotfix-manual-task-layer4-entry-contract.spec.mjs`; full suite 1,852 passed, only the 4 known legacy failures (cf-091, cf-103) |
| Consumer API | Not touched (Decision 266) |
| Gates, budgets, caps | **Not changed** (constraint). One on-demand bypass for a person's task, behind setting `search.person_task_bypass` |

## 1 Summary

| # | Defect | Root cause (evidence in section 2) | Fix |
|---|---|---|---|
| D2 | A person's "Find course pages" task never reaches Firecrawl | The task queues its rows correctly, and the worker is asked every minute. The one course search picker then drops any university on the **search-stop list** before it looks at whether a person asked. Otago was stopped on 21 Oct 10:33 after 20 wrong title-search pages in a row, and was never resumed. A second check (bulk onboarding) voids the person-asked bypass again | A row of a person's **running** Find course pages task passes the stop and the bulk check only. Budget, month cap, target-only, hidden universities, directory sites and the skip list all still apply. The task also asks the worker straight after it is accepted, with the minute job's exact request, instead of waiting up to a minute |
| D3 | A dead task looks alive | The task view had no status beyond "0 of 50". After 45 minutes the watcher **closed the task as done** with "the rest wait their turn in the reader". The hourly gap causes counted the same rows as "web search queued (automatic)" | Every running task now shows **last forwarded**, **next attempt** and, once nothing has moved for 60 s (`tasks.stall_seconds`), **Blocked: <the gate> · <where to fix it>**. The watcher's closing note names the gate. Gap causes gain "no page: web search stopped for this university" (not automatic) |
| D1 | Layer 4 "Enter another address" on a quarantined item fails | The Inbox shows every pending review row as "Course link", including **fee** rows (`provider_current_tuition`: the identity re-verification quarantine and the fee floor). Their choices went to `layer4_review_decide`, which has no fee branch, so they fell through to the scalar resolver ("field is not enabled for scalar Layer 4 editing"). This is the same pattern fixed for English on 17 Oct | A fee item's "Enter another address" goes through the **standard bind path**, the one a person's page entry uses (`admin_course_edit set_official_url`): a manual binding plus manual locks, then a read first in line under the current identity rule, then the fee reader. A manual binding is exempt from the identity quarantine, so the fee re-admits. https:// only, on the university's own site. "Use the new page" is hidden on fee items (there is no page in a fee row) |

## 2 Evidence (live, 24 Oct 2026 13:20–13:40 Melbourne)

### D2 — task accept → toolset call, and where it stalls

| Step | Object | What the record shows for Otago |
|---|---|---|
| 1 Accept | `public.admin_jobs('start')` → `security.provider_task_prepare_v1('course_page_find')` | Task `e43e47de-3f9e-4057-992c-cc622f48a784`, created 01:38 UTC. Its 50 rows were in `pipeline.course_link_search`: state queued, stage title, `requested_at` set, `sent_at` null, attempts 0 |
| 2 Runner | cron `admin-jobs` (every minute) → `security.admin_job_watch_v1` | Ran every minute and counted 0 done |
| 3 Lane | cron `course-link-search-worker` (every minute, active) → edge `coverage-sweep` mode `link_search` | Called every minute; each call answered in about 3 s with `{"picked":0,"searched":0}` (`pipeline.edge_request_log` / `net._http_response`). **The toolset was asked; the picker gave it nothing** |
| 4 Picker | `public.svc_course_link_search_next` | Gates for Otago: search on ✔; month 97,670 of 200,000 ✔; today's share 12,992 left ✔; **search stopped since 21 Oct 10:33 (20 wrong in a row, no resume, no hold) ✘**; hidden no ✔; target ✔; site `otago.ac.nz` ✔; skip list no ✔; **bulk onboarding yes ✘** (voids the person-asked bypass) |
| 5 Close | `admin_job_watch_v1` | 02:25 UTC: task closed **done**, "0 of 50 done, nothing more for 45 minutes: the rest wait their turn in the reader" (false) |

Last course search anywhere: 23 Oct 21:19 UTC. Nothing has been searched since then.

**Wider finding (report, not changed).** 2,866 person-requested rows are waiting. **292 Find course pages tasks have been closed as done with the "wait their turn" note since 11 Oct, 289 of them with nothing found (7,259 courses).** This includes tasks started by enrichment plans. What holds the 2,866 rows:

| Gate | Universities | Rows | After this hotfix |
|---|---|---|---|
| Automatic search stopped (`fc_search_stopped_v1`) | 24 (of 87 stopped) | 1,549 | Pass while a person's task for them is running |
| Not a Firecrawl target (target-only on) | 136 | 1,130 | Still held (policy gate). The task now says so within a minute |
| University unpublished or archived | 32 | 127 | Still held; named |
| Bulk onboarding, then the site checks | 36 | 59 | Pass while a person's task is running |
| No website recorded | 1 | 1 | Still held; named |

This corrects an earlier reading. On 24 Oct (AU quick wins, R2) the idle search was put down to the R2 gate. Most of it is the stop list and the target-only rule.

### D1 — why the scalar path refused

| Step | Object | Finding |
|---|---|---|
| Inbox list | `security.layer4_inbox_items_v1` | All pending `layer4_review_items` are kind `course_link`; detail carries `field_code` |
| Decide | `public.admin_layer4_inbox('decide')` → `public.layer4_review_decide` → `layer4_review_decide_impl` | Branches for `provider_current_tuition_validation`, `official_course_url`, `course_english` and the scholarship scope. **No branch for `provider_current_tuition`** → `layer4_course_scalar_resolve_impl` → "field is not enabled for scalar Layer 4 editing" |
| Item | AUT, e.g. `c62b431b…` "Postgraduate Certificate in Science (Level 8)" | Escalation "quarantined for re-verification: the course page was bound with a cricos_code proof…". The page held was `/courses/graduate-certificate-in-science` (a different course), basis ai_match, status mismatch |

## 3 One execution path (the manual path is the canary)

| | Scheduled | A person's task |
|---|---|---|
| Queue | `pipeline.course_link_search` | the same rows (`requested_at` set) |
| Trigger | cron `course-link-search-worker`: `svc_pilot_submit_nonce('coverage-sweep', {mode:'link_search', limit: batch.link_search_worker})` | `provider_task_fire_v1('link_search')`, sending **the same body word for word**, straight after accept; then the same minute job |
| Worker | edge `coverage-sweep` `link_search` | the same |
| Picker | `svc_course_link_search_next` | the same function; the person's rows sort first (unchanged) and pass the stop and bulk checks only |
| Spend | `coverage_vendor_usage` purpose `course_link_search`, inside the month cap and the day share | the same |

There is no second picker and no second worker. Proof in the dry run: starting a task through `admin_jobs('start')` logged one `coverage-sweep link_search` request at accept. A second fire in the same moment was held by the existing 45-second in-flight guard, so there are no duplicate calls. The picker then handed all 58 Otago courses with no read page to the worker.

## 4 Stall taxonomy (names the cause)

There is no separate "field-lineage taxonomy" document. The failure vocabulary in use is the gap-cause taxonomy (`security.gap_causes_snapshot_v1`, hourly) and the gate order of the picker. `security.link_search_block_v1(provider, course_ids)` walks the picker's gates in its order and returns the first that holds, as `{code, words, fix}`:

| Order | Code | Words shown (abridged) |
|---|---|---|
| 1 | `lane_paused` / `lane_idle_paused` | The course page search lane is switched off / paused by the idle guard until hh:mm |
| 2 | `search_off` | Course page search is switched off |
| 3 | `month_cap` | This month's course search credits are used |
| 4 | `day_budget` | Today's Firecrawl share for course search is used |
| 5 | `provider_hidden` | The university is unpublished or archived |
| 6 | `search_stopped` | The automatic search stopped for this university on dd Mon (only when the bypass is off, or no person's task) |
| 7 | `not_target` | Firecrawl is for target universities only and this one is not a target |
| 8 | `no_site` / `directory_site` | No website recorded / the website is a course directory |
| 9 | `skipped_provider` | On the search skip list |
| — | `waiting_turn` | n search(es) waiting their turn behind earlier requests (nothing blocks) |
| — | `runner_off` / `no_progress` | Task runner off / generic, for other task kinds |

The same function feeds the Task manager (`admin_job_status_v1` → `admin_jobs` read, key `status`) and the watcher's closing note. The hourly gap causes add the cause "no page: web search stopped for this university", marked not automatic, so those courses are no longer counted as queued (5,812 course-attribute rows in the dry run). This follows the same pattern as the UI cleanup mandate's error references: a plain line, a code to look up, and where to fix it.

## 5 Settings (G2)

| Key | Default | Range | Section | Used by |
|---|---|---|---|---|
| `search.person_task_bypass` | 1 (on) | 0–1 | Course page search | `svc_course_link_search_next`, `worker_mode_waiting_v1`, `link_search_block_v1` |
| `tasks.stall_seconds` | 60 | 30–3600 s | Platform upkeep | `admin_job_status_v1` |

The only fixed value is `next_attempt_at` = the next minute (the runner's and the lane's cadence), marked `-- fixed:`.

## 6 Dry run against live (rolled back)

| Check | Result |
|---|---|
| Stall cause, bypass **off** (the 13:20 state) | `search_stopped` — "The automatic search stopped for this university on 21 Oct…" |
| Accept → worker request logged | 1 `coverage-sweep link_search` at accept; immediate second fire 0 (in-flight guard) |
| Lane wakes for a person's task at a stopped university | true |
| Picker | 58 picked, 58 Otago, 58 marked sent |
| Task status after | blocked null, forwarded 58, last forwarded and next attempt set |
| `admin_jobs` read | every job carries `status` |
| Layer 4 http:// address | "enter the full web address (https://…)" (the existing message) |
| Layer 4 off-site address | "this page is not on the provider's own website (aut.ac.nz)" |
| Layer 4 "Use the new page" on a fee item | "this item holds a fee, not a new page: enter the course page's address, or keep the page we hold" |
| Layer 4 enter `https://www.aut.ac.nz/courses/postgraduate-certificate-in-science` on `c62b431b…` | ok; page **manual / bound / next read now**; official link active; manual locks `official_url`, `course_url`; item `edited_approved`; decision `edit_and_approve` |
| Gap causes | "no page: web search stopped for this university", automatic false |

## 7 Regression

| Required | Where |
|---|---|
| Contract: a Find course pages task forwards to the toolset within 30 s of accept | s99 test 1. The accept step fires the worker with the minute job's body, so it is limited by the commit and pg_net only (the dry run logged the request in the accept transaction). No gate, budget or cap line is edited; every edit is md5-guarded |
| Contract: a stalled task surfaces its blocking reason | s99 test 2: gate order, threshold setting, watcher note, Task manager render and status line |
| Contract: Layer 4 enter on a quarantined course-link item completes bind → reidentify → re-read (mocked fetch); non-https gets the existing message | s99 test 3: the screen's helpers, server routing, the call order replayed against fakes; plus the live dry run above |
| E2E via the browser extension after deploy | **Platform Admin**, section 9 |

## 8 What was not changed, and decisions for the Platform Admin

| Item | Status |
|---|---|
| Search stop list, target-only, budgets, caps | Unchanged (constraint). The stop list worked as designed for the automatic search; it was wrongly applied to people |
| 1,130 person-requested rows at **non-target** universities (136) | Held by the target-only rule. **Decision:** should Find course pages refuse to start for a non-target university (saying so at once), or should a person's task pass target-only like the stop? Not done here because it is a budget gate |
| Rows of the 292 tasks closed falsely as done | Their rows stay queued. They run when a person (or a plan) starts Find course pages for that university again. **Decision:** re-open the 24 stopped universities' tasks in one go (a paste file), or leave them to the enrichment plans |
| 87 stopped universities | Unchanged. "Search again" in the Adapter builder resumes one |
| `coverage-admit` | **Paused by the Platform Admin at 12:18** (`admin_control_events`). The v2.15.341 fix is live and verified: migration md5 matches, and a rolled-back run gave 86 written, 0 errors. Not resumed by me; resume when ready |

## 9 Deploy and post-deploy steps

1. Platform Admin reviews and squash-merges the v2.15.342 PR (migration applies with the release).
2. Verify: migration md5 against the repo file; `pg_get_functiondef` of the eight edited functions contains the hotfix lines; settings rows present.
3. **E2E (browser extension), Platform Admin:**
   - Adapter builder › University of Otago › Find course pages › start. Within a minute the Task manager shows "Last forwarded hh:mm (n sent)" and the count moves past 0 of 58.
   - Layer 4 › Inbox › an AUT held-fee item › Enter another address › the course's own https:// page › reason › confirm. The item leaves the Inbox and the course shows the page as a person's value, read first in line.
4. Then rebase the UI audit PRs on the new main and renumber them: #684 → v2.15.343, #685 → v2.15.344, Phase 1 → v2.15.345 (its PR opens after this one). The Phase 3 suite resumes.

## 10 Found on the way

- The Phase 1 branch's full suite (v2.15.344 as numbered before this hotfix) has one real failure besides the four known legacy ones: `cf-247-ui-standard-contract` "provider panel: pills and fact cards; no raw identifier or evidence lists" (both viewports). Fixed on that branch (`248f62bb`: the identifiers block renders only when opened).

## 11 Thread — Platform Admin decisions and execution (24 Oct 2026 13:55)

### Decisions (Platform Admin, verbatim intent)

| Decision | What it means | Done |
|---|---|---|
| **D-target_only** | A person's task that hits the target-only gate is **refused at start**, with the gate named in the message. No task bypasses target_only; releasing that gate is R2's audit decision, not this hotfix | Added to v2.15.342 (PR #686 commit `ec997366`, after the 13:55 review): `provider_task_prepare_v1` raises "Not started: this university is not a search target, and course page search is for target universities only (Toolsets & limits › targets)." (under the 160-character plain-error limit, so the gate name survives). It uses the picker's own check. The enrichment plan runner catches the refusal (step not started). Dry run: Griffith College, QIBT refused; Otago still forwarded 58. Test s99 asserts it |
| **D-stopped** | Re-open the 24 stopped universities' 1,549 queued rows in **one** count-guarded paste file, applied by the Platform Admin after the hotfix merge. Until S1 lands, stall visibility plus a paste file is the accepted handling | `docs/platform/ui-audit/PASTE-20261024-hotfix-reopen-stopped-rows.sql`: one Find course pages task per university for exactly its held rows, as the Platform Admin. Guards: hotfix live, ≤1,549 rows at ≤24 universities, skip a university with a task already waiting or running, skip and name unpublished ones. Dry run on the hotfix: **23 tasks, 1,533 courses**; Nova Institute of Technology (16 rows) not started, because it is unpublished; picker took 200 at once (its per-call limit) |
| **S1 is the permanent fix** | A per-course stop plus negative evidence (a course whose search failed is remembered per course, not by stopping the whole university) replaces the university-wide stop and the paste-file handling | Recorded; S1 stays in the standing order after R2 |

### Execution log

| Step | State | Evidence |
|---|---|---|
| 1 Post-merge verification (section 9) | **Pass** — PR #686 squash-merged 14:19 (`3c3f218b`) on the Platform Admin's instruction ("make sure all PRs are merged", 14:18); Deploy on merge succeeded | Live last migration `20261024009000`; applied text md5 `968426215ee8b0e44f575c13b6a65952` = repo file md5 (byte for byte). All eight edited functions carry the hotfix lines (`svc_course_link_search_next`, `worker_mode_waiting_v1`, `provider_task_fire_v1`, `provider_task_prepare_v1` incl. the target-only refusal, `admin_job_watch_v1`, `admin_jobs`, `admin_layer4_inbox`, `gap_causes_snapshot_v1`); the four new functions exist; settings `search.person_task_bypass` = 1 and `tasks.stall_seconds` = 60 |
| 2 E2E | **Run through the screens' server calls, as the Platform Admin.** The session had no browser link, so the browser-extension view itself is still to be looked at. Otago: **failed on v2.15.342, passed after hotfix 2** (section 12). AUT: **pass** | **Otago** — before: task e43e47de closed 02:25 UTC "0 of 50… wait their turn". Re-find task `a4ec5237` accepted 03:19:28.98 UTC; the worker was asked in the same second and **picked 58** (forwarding within one minute: yes). But it searched 0 each minute: the credit check refused every credit (section 12). Status showed "Last forwarded 03:33, not blocked", so the stall was still invisible. **After v2.15.343 (live about 03:50 UTC): first search 03:50:21, all 58 searched within the minute, task done 03:51:00: 41 of 58 course pages found, 17 not found, 116 credits.** **AUT** item `c62b431b` (Postgraduate Certificate in Science). Before: pending, in the Inbox, page `/courses/graduate-certificate-in-science` (the sibling course's page; the two pages are swapped between the two courses) ai_match / mismatch / identity_mismatch, fee $48,059.68 unverified. Entered `https://www.aut.ac.nz/courses/postgraduate-certificate-in-science` (an AUT page we already hold) 03:27:38. After: `edited_approved`, **gone from the Inbox**, page manual / bound, locks `official_url` + `course_url`, official link active; read 03:30:43 (`read`); fee reader done 03:32; **fee $48,059.68 active 03:32:26** (bind → re-read → fee re-admit, end to end) |
| 3 Resume coverage-admit | **Pass** | Resumed 14:28 by the Platform Admin control (reason recorded). First run 03:30:00–03:31:35 UTC **succeeded** (before: every run failed since 23 Oct 11:40 UTC). Result `{written 92, layer4 39, decided_by_rule 21, errors 0, more false}`: the batch completed with nothing left. **29 http:// official-page rows went to Layer 4**, not 187. The 187 counted every http:// row in the 45,314-row plan; under the v2.15.341 fix only rows a "take" rule would have applied are sent to a person, and the rest are decided as before. Matches the rolled-back test (86 written, layer4 39, 0 errors) |
| 4 Rebase and renumber the stack | **Done and merged.** Hotfix 2 took v2.15.343 (no two releases share a version), so #684 → **v2.15.344**, #685 → **v2.15.345**, Phase 1 → **v2.15.346** (PR #688). Each rebuilt on main, release text carried over, release-notes files renamed, a full suite before each merge, each deploy verified live | #687 `c5749a9c` (suite 1,854; migration md5 `d8f18f4f…` live) · #684 `42e3d2d6` (1,858; `864c8f32…`) · #685 `70462968` (1,864; `12a7bd0a…`) · #688 `3f2e6dba` (1,884; no migration). Only the 4 known legacy failures each time. Renumber recorded in `2026-10-24-ui-cleanup-mandate.md` |
| 5 Re-open paste file | **Handed to the Platform Admin** (D-stopped: Platform Admin applies). Its guard now also requires v2.15.343 (without it every credit of these tasks is refused); both are live | Rolled-back run on live after v2.15.343 (03:55 UTC): **22 tasks, 1,483 courses** (guard: 1,499 rows at 23 universities; Otago's rows were searched by the E2E task); Nova Institute of Technology (16) not started, unpublished. Expected spend about 2,970 credits, inside today's course-search share. Queue state after it is applied: to be recorded |

### Open items (logged, not for now)

| Item | Owner | Note |
|---|---|---|
| CRICOS legal-name capture | Platform (later) | Layer 1 change; needs a coverage-reidentify-delta decision first. Do not implement now |
| Torrens University display name | Platform Admin | Set on the Providers screen |
| Two ECU near-duplicate scholarships | Scholarship owner | Owner decision, not a platform change |

## 12 Hotfix 2 — v2.15.343 (found by the step 2 E2E)

| | |
|---|---|
| Defect | The Otago re-find task was forwarded at accept and each minute (picked 58) but **searched 0**. The worker asks the database for every credit (`public.svc_fc_spend`), and that check carries a **third copy of the search-stop gate**: it refused every course-search credit for a stopped university (`firecrawl_refusals_by_provider`: Otago, course_search, `search_stopped`, 918 on 24 Oct). The worker then returned each row to the queue as "credit budget". The v2.15.342 dry run proved accept → picker but did not run the worker's spend step, a test gap. Every function that reads the stop was listed: only `svc_fc_spend` enforced it beyond the two already fixed; the rest report it |
| Second gap (D3) | "Forwarded" alone hid the stall: the Task manager showed Last forwarded every minute and no block |
| Fix | Migration `20261024010000_cf247_hotfix2_person_task_spend_gate.sql`, md5-guarded. `svc_fc_spend`: a person's waiting or running Find course pages task for the university passes the stop (same setting `search.person_task_bypass`); the day share, day total, month cap, reserve and target-only rules are unchanged. `admin_job_status_v1`: for Find course pages the stall clock follows credits spent (`last_spent_at`), and a refusal since the task started is the blocking reason (`credit_refused`: "Sent to the search, but its credits were refused (search stopped, n time(s) today)") |
| Dry run (live, rolled back) | Otago credit allowed (task running); Humber (stopped, no task) still refused; Otago status before the fix shows `credit_refused` |
| Release | v2.15.343, PR (see change control); test s99 (4th test) |
