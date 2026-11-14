# Scholarship queue and search-refresh hygiene: findings and draft (14 November 2026)

Read-only checks on live Supabase `fxcwkweaxjtknorudmwp`, Pilot `main` and PR #1143 head `ae367ed6`, and the admin repo. Nothing was changed in production: the only writes were two transactions that were forced to roll back (txid 17271148 and 17273009, both `aborted` when checked afterwards).

The draft migration is [`DRAFT_cf247_sch_queue_hygiene.sql`](DRAFT_cf247_sch_queue_hygiene.sql). It is unnumbered and applies only after #1143.

| # | Question | Finding | What the draft does |
|---|---|---|---|
| 1 | Does `svc_scholarship_read_record` stall on the search lock? | **Not today.** It can call the search refresh, but that path is switched off for now | Queues its search refresh behind its own setting, so the path cannot stall when it comes back |
| 2 | Why are 19,604 rows in `pipeline.search_refresh_signals` never processed? | **No worker was ever built to read them.** Nothing stalled. Search is kept current another way | Adds a table comment only. Retirement goes in a separate change (§2.4) |
| 3 | Terminal `rejected_admission` state (design §4.3) | The current code would **retry the item and send it to the next AI model** | Makes it terminal, with no retry, no next model and no AI spend. Rehearsed against live: PASS |

## 1. `svc_scholarship_read_record` and the search-document writer lock

**How it calls the search refresh.** It never calls it directly. When a page read succeeds, one of three things happens:

| Condition | What happens | Search refresh? |
|---|---|---|
| AI admission is on and a model is active | Queues an AI re-read (`scholarship_ai_queue`) | None |
| Otherwise, and the page now fails admission | `security.scholarship_admission_withdraw_v1` | Yes: scoped refresh, waits on `pg_advisory_xact_lock('cf247:search_course_documents_writer')` |
| Otherwise | `security.scholarship_sweep_apply_v1` | Yes: the same lock |

**Is it stalling now? No.**

- `ai_admission = true` and one model is active (`qwen3-30b`, prompt v3), so every read takes the first row.
- The postgres logs for the last 24 hours show **0** read_record cancellations. In the same window `svc_scholarship_ai_record` had 184, which is what #1143 fixes.
- `pg_stat_statements` shows a maximum of 7,993 ms over 21,974 calls. That counter has run since 10 August 2026, so the maximum is from history, not current runs.

**Why the draft still covers it.** The rule path comes back as soon as AI admission is switched off or no model is active. It would then wait on the same lock: job `search-refresh-requested` holds it for a p50 of 84 s. #1143 deliberately leaves `svc_scholarship_read_record` refreshing inside the call.

**The draft change:**

- One md5-guarded line (live md5 `ec72dc99…`). It sets the same transaction-local flag #1143 uses, `cf247.defer_search_refresh`, while the new setting `search.defer_read_record_refresh_on` is 1 (the default).
- The sweep and withdraw steps (made flag-aware by #1143) then queue courses in `search.course_refresh_requests`.
- The flag lasts for one transaction. The function's only caller is the worker's PostgREST call, which is one transaction per call.

**Rehearsal (section A):**

- AI admission was switched off inside the rolled-back transaction.
- A page that fails admission (scholarship `26ad43cc…`) was withdrawn in **286 ms**. Two courses were queued (`requested_by scholarship_admission_withdraw_v1`), and the writer lock was **not** taken. A positive control confirmed the lock check works.
- With the setting at 0, the flag stays unset.

## 2. `pipeline.search_refresh_signals`

### 2.1 Live state

| Measure | Value |
|---|---|
| Rows | 19,604, all `queued`: 17,309 course, 2,295 provider |
| Oldest / newest | 24 Sep 2026 06:21 / 14 Nov 2026 03:20 UTC |
| Ever processed | **0** (`n_tup_upd` 0, `n_tup_del` 0, `completed_at` always null; `processing`, `completed`, `cancelled` and `blocked` never used) |
| Growth | 18,632 rows in the week of 9 Nov: CDESC machine admissions 7,896, AER 8,543, PDESC 2,191 |
| Size | 16 MB; no table comment; register status `active` with no purpose |
| Origin | CF-CHG-20260825-038, migration `20260825133136` (M2.3 refresh scheduler) |

### 2.2 Writers and readers

- **Writers (9 functions):**
  - `security.layer4_review_decide_impl`;
  - `aer_machine_admit_v1` / `_withdraw_v1`;
  - `aer_matrix_machine_admit_v1` / `_withdraw_v1`;
  - `course_description_machine_admit_v1` / `_withdraw_v1`;
  - `provider_description_machine_admit_v1` / `_withdraw_v1`.
- **Readers:**
  - only `security.refresh_intelligence_overview_impl`, which lists the latest 250 rows; the admin UI does not use that key;
  - no job, no edge function, no update path in any migration.
- **Tests that name it:**
  - `cf-247-s527` asserts the CDESC admit writes it;
  - `cf-093` asserts one path does not.

### 2.3 Superseded or stalled?

**Superseded. Nothing ever stalled, because no consumer was ever built.** Search documents are kept current by:

- job `search-refresh-requested`, which runs the full refresh (`refresh_course_documents_v3`) whenever `search.refresh_requests` has an open request. Over the last 2 days it ran about every 10 minutes, with 0 open requests;
- from #1143, `search.course_refresh_requests`.

**Evidence that nothing was lost:**

- Of 13,199 signalled courses, 9,633 had their search document rewritten after their signal.
- For the other 3,564, a dry run of the scoped refresh (`p_apply false`, no lock) found **0 changed**. Their documents already match the data.
- Providers have no search document, so the 2,295 provider signals have nothing to refresh.

**The table is also a hazard.** Its `unique(review_decision_id)` caused the 9 Nov blocking defect B1: `machine_withdraw_v1` failed on a duplicate key (Execution Register, 9 Nov QA of #930).

### 2.4 Recommendation: retire it, do not build a consumer

A consumer would only repeat work the full refresh already does. Suggested housekeeping change, separate from this draft because its nine writers belong to three workstreams:

1. **Stop the writes.** Remove the insert from the nine writers with md5-guarded edits:
   - AER owns `aer_*`;
   - S2-CF owns `course_description_*` and `provider_description_*`;
   - `layer4_review_decide_impl` is shared, so it goes through the Integration Controller.

   In the same PR, update the `s527` assertion and retire or adjust `cf-093`, with the test register regenerated (G4). Also drop the `search_signals` key from `refresh_intelligence_overview_impl`.
2. **Mark it retiring.** In `pipeline.component_register` set status `retiring`, `replaced_by` = `search.refresh_requests` (job `search-refresh-requested`) and `search.course_refresh_requests`, and `retire_after` = +14 days (`hygiene.retire_after_days`). Use `-- Retires: pipeline.search_refresh_signals`.
3. **Drop it after 14 days.** Once nothing writes it, a Platform Admin paste file drops the table and its index. No archive is needed: every row is derived from `pipeline.layer4_decisions` and the machine admission logs, which remain.

## 3. Terminal `rejected_admission` state (design §4.3)

### 3.1 What happens today to `p_error = 'rejected_admission: …'`

| Function | Behaviour |
|---|---|
| `pipeline.scholarship_ai_queue` | The state check allows only `queued`, `leased`, `done` and `failed`, so a terminal state needs the check extended |
| `public.svc_scholarship_ai_record` (live `cbcf286f…`; `fa3345b7…` after #1143) | An error makes the answer unsettled, so the item **goes to the next model in the chain** (AI spend). After the last model it is **re-queued** while `attempts < 3`. Both are wrong for a gate rejection |
| `public.svc_scholarship_ai_next` (`4860b52d…`) | Takes only `queued` items, or `leased` ones whose lease has lapsed. A terminal state is never picked. **No change needed** |
| `security.scholarship_ai_enqueue_v1` (backfill tick, admin and task paths) | Re-queues a candidate that has no error-free extraction. A rejected candidate would come back on every pass, and a fresh scrape could cost Firecrawl credits. It already skips candidates with `admit_status` `skipped`, as it does for directory sites |
| `security.admin_job_watch_v1` and `security.ops_step_value_v1` | Count finished items as `done` and `failed`. A new state would look like it is still running |

### 3.2 The draft change

All edits are md5-guarded against the #1143 result.

- **In `svc_scholarship_ai_record`, right after the extraction row is written** (so the error and the evidence are kept):
  - the item gets state `rejected_admission`, `done_at`, the extraction id and `skip_reason`;
  - no next model, no retry, no Layer 4 review, no admission;
  - a discovered candidate page gets `admit_status 'skipped'` with `admit_reasons {rejected_admission, <codes>}` and a `scholarship_admission_log` row, so the enqueuer passes over it;
  - an approved single read is set to `refused` with the reason.
- **The state check gains `rejected_admission`.** It keeps the same name and is replaced in place, as `20261113060000` did for `run_kind`.
- **The two finished-item counters** treat the new state as finished.
- **No switch.** The rule does nothing until a reason's `admission.enforce.<reason>` is on, and switching that off is its rollback.

**Rehearsal (section B), all PASS:**

| Test | Result |
|---|---|
| Candidate rejected for `thin_page,soft_block` | Terminal; attempts unchanged; no next model; candidate skipped and logged; extraction cost 0; the picker would not take it; the enqueuer passes over it |
| Approved single read | Refused with the reason; no Layer 4 review opened |
| Re-read of a known scholarship | Terminal |
| Another error (`HTTP 500`) | Behaves as today (re-queued); never takes the new state |
| An unknown state | Refused by the check |

### 3.3 Needed in the gate patch before any reason is enforced (not changed here)

In `pre-ai-admission-gate-shadow.patch`, the worker calls `rec({ p_error: 'rejected_admission: ' + dec.reasons… })` whenever `dec.decision !== "admit"`. That has two problems:

1. **A `park` decision also sends `rejected_admission:`.** This applies to `duplicate_input` and `over_budget_split`, and with this SQL a parked item would become terminal. Design §4.3 says a parked item is re-queued. Send `rejected_admission:` only when `decision === "reject"`, and park with `p_retry: true` (or a separate prefix if the reason must be kept).
2. **The code list includes reasons that are only being measured** (all of `dec.reasons`). The recorded codes should be the enforced ones: `reasons.filter(r => s.enforce?.[r.code])`.

Both lines are in the coverage-sweep `index.ts`, which this session did not touch. They belong to the D3 bundle after #1139.

**Residual (accepted):** a re-read of a known scholarship that the gate rejects can be queued again by the daily backfill. That only happens if it has never had an error-free extraction, it spends no AI, and it is at most once a day.

## 4. Rehearsal record

| Item | Value |
|---|---|
| Script | [`QUEUE-HYGIENE-REHEARSAL.sql`](QUEUE-HYGIENE-REHEARSAL.sql), md5 `876e9d44…`: #1143 sections 0 and 2 to 5 verbatim, then the draft verbatim, then the assertions. #1143's index build and timing post-check were left out so the rehearsal never held a share lock on the 176 MB extractions table |
| Result | [`queue-hygiene-rehearsal-result.json`](queue-hygiene-rehearsal-result.json): **PASS**, 0 failed assertions, txid 17273009, `aborted` when checked afterwards |
| After rollback | Live md5s unchanged (`ec72dc99…`, `cbcf286f…`, `947806f3…`, `1cb05209…`), state check unchanged, `search.course_refresh_requests` absent, 0 new settings, rehearsal extractions 67272 to 67275 absent, no worker errors in the window |
| Static checks | s42 housekeeping (Replaces and Retires, nothing dropped, no job), G2 (no fixed interval or limit), G3 (no consumer API object): pass |
| Before apply | Number the file after #1143 is applied. Re-read the four md5s in the header, which must equal #1143's live result. Re-run the rehearsal without the #1143 sections |
