# Lineage verification and Track B sequencing (25 Oct 2026) — decision record

Platform Admin, 25 Oct 2026 12:44: "Combined mandate — decisions recorded, lineage verification, Track B sequencing. … CF-247 applies; this file is the decision record. Doc-as-code per section 7 of docs/platform/PIPELINE-LINEAGE.md. One release at a time, merged and alive before the next. Where the lineage draft and the code disagree, the CODE wins — correct the doc, never bend code to the doc."

## Decisions

### D-693: Part A approved and merged

> "Part A (v2.15.351, PR #693) is approved and merged by the Platform Admin. After merge: re-run the live check and confirm the deployed change matches the repo; the browser before/after is the Platform Admin's own visual check."

**Done:**
- PR #693 was still open when this mandate arrived. It was merged under this decision at 01:44 UTC (squash `a7fe02d1`).
- Deploy on merge, Pilot Frontend Build, Deployed UAT, Release History and Release Currentness all succeeded.
- Migration `20261025001000`: live `md5(statements[1])` is `8d291885353dac01e97f290b1211042e`, identical to the repo file.

**Live re-check, as the Platform Admin:**
- NZ sorted by Completeness: 50 of 50 rows have an International fee and 49 of 50 have a City.
- LI4245: NZD 37000, Lincoln.
- Sorted by Tuition Only: 22 of 50 rows have an International fee (rows without one have none on record).

**Still open:** the browser before/after is yours.

### D-SIT3954: the one unnamed NZ course

> "Read the STORED REGISTER COPY first. If the register carries a title → one-row count-guarded fill paste; if not → one-row quarantine paste. Either way the Platform Admin applies; show him the stored register extract for the row before writing either file."

**Status: no file written. The stored extract could not be read from this session.**

What is known:
- **The course row:** `course:nzqa:6015:3954`, title "--", active, unpublished.
- **Where the stored copy is:** evidence `d0ff24c6-c490-4daf-af9a-b62302421382`, a `regulatory_snapshot` captured 26 Sep 2026 13:19 UTC. It is held at `evidence/regulatory/NZ/nzqa/2026-09-26T13-19-33-648Z-offset-45-batch-5.json` (1,199,562 bytes, 647 records). Source "NZQA Education Organisations", reader `register adapter nz_nzqa v1`.
- **The register row is still live:** `pipeline.layer1_register_row_state` has `6015|3954`, last seen by the NZQA source on 23 Oct 2026 10:35 UTC.
- **The regulator listing link held for the course:** `https://www.nzqa.govt.nz/nzqf/search/viewQualification.do?selectedItemKey=3954`.
- **Why it can't be read here:** SQL cannot read storage objects, the record's fields are not kept in any table, and no signed-in session is available here to preview the file.

Two routes, for your choice:
- **(a)** You open Evidence › `d0ff24c6…` in the admin site (preview allowed) and search "3954". Paste me that record, or a screenshot of it, and I write the matching one-row file.
- **(b)** You authorise a one-off read through the existing GitHub workflow secret: fetch that one object, print only the 3954 record, and record the run here.

### D-stored-copy: 14-day replay approved

> "the 14-day replay default is APPROVED as a settings key (read.stored_copy_max_age_days, default 14, min 0, max 30): "Read with AI" replays a stored copy up to that age; fresh fetch only when older or the operator explicitly asks. This corrects the 23 Oct "always fetch" instruction — record the correction."

**Recorded correction:** the Platform Admin's 23 Oct 09:03 instruction is superseded from Track B release 1. That instruction ("with the page being read again, the fields wait for the new page (not the old copy)", implemented in `public.admin_course_read_now`) made "Read with AI" always fetch. Release 1 implements the new key as specified (key name `read.stored_copy_max_age_days`, 14, 0–30).

## Order (as mandated)

1. Part 1: verification, now.
2. **Track B release 1:** Fields section + Pipeline strip + `course_events` + stored-copy replay, including D-stored-copy.
3. **Track A:** S1 + 8a, uninterrupted.
4. **Track B releases 2 and 3:** decider display + filters + D-L4-1; then acceptance report + map.
5. Items 2.2 → 2.4, in turn.
6. Defect 1 build.
7. Part E provider descriptions ride with Track B release 3.

---

## Part 1 — PIPELINE-LINEAGE.md verification (done; verified 1.1 replaced the draft in place)

Method:
- the live database `fxcwkweaxjtknorudmwp` (function bodies, tables, columns, cron jobs, settings, row counts);
- Coursefinder-Pilot code at `a7fe02d1` (worker `supabase/functions/coverage-sweep/`, migrations, `src/`).

Every row now carries its citation.

### Flips: 16 [T] / [V/T] marks resolved

| Resolution | Count | Rows |
|---|---|---|
| Flipped to [V] as written, with citation | 8 | Study level (`svc_enrich_ai_record` `level`); Field of study (`field_of_study`); Tuition from fee-schedule pages (`fee_reader_tick_v1`, `svc_fee_schedule_apply`); Website (`find_site`, `cs:index.ts:926`); Logo (`logo_find`, `cs:index.ts:698`); Contacts (`contact_page`, `cs:index.ts:764`); Scholarship name/value (`scholarship_read`, `scholarship_ai`); Scholarship eligibility (`scholarship_ai`, `scholarship-audience` / `-nationality`) |
| Flipped to [V] with a correction | 6 | Title (no "TITLE SHOWN" reader step exists; landing is `canonical_title`); Delivery mode (Enrich fields AI, not the page reader); Duration (Enrich fields AI + CRICOS register, not the page reader); Rankings (landing `catalogue.provider_rankings`); Graduate results (`svc_qilt_*`, landing `provider_outcomes` / `outcome_benchmarks`); Fee schedules in section 3 (live at low volume, not just queued) |
| Verified absent ([V-absent]) | 2 | Course description reader (none; 163 courses hold a description today); provider legal-name capture (deferred) |

Also marked [V-absent] inside rows: the course-title alias table (Defect 1), `course_fees.superseded_by`, B4, and `country_identity_rules` (8a).

### Corrections to [V] / unmarked content (code wins): 11

| # | Draft said | Code says |
|---|---|---|
| 1 | "read (stored copy first, fetch only when silent)" | The page read re-fetches when due: direct first, then Firecrawl under trust rules (`cs:index.ts` mode `read`). Only the downstream readers (`fee_ai`, `enrich_ai`, `reextract`) read the stored copy. "Read with AI" also re-fetches until release 1 |
| 2 | Lanes list incl. "coverage-read-2", "programme_read" | `coverage-read-2` is a cron job; its mode is `read`. The real mode list (with 7-day ledger calls) is now in section 2; `coverage-read` is off |
| 3 | Gate order: target → stop → cap → budgets → unpublished … | `link_search_block_v1`: lane paused → idle-paused → search off → month cap → day budget → daily cap → hidden → search stopped → not target → no site → directory → skipped. The per-course stop is a picker row filter |
| 4 | "Per-URL read attempts capped at 3" (as a setting) | `read_attempts < 3` is a **literal** in `svc_coverage_read_next`. **G2 finding:** `reading.max_attempts` is added with the next change to that picker |
| 5 | "exhausted pages … feed page_rejections" | They do not. The only writer of `pipeline.page_rejections` is `security.zero_yield_reset_v1`; exhausted-page rejections are S1 |
| 6 | "pickers do not carry queued-at" | The queue carries it (`course_link_search.queued_at`, 26,020 of 26,020). The gap is the report: `svc_worker_report_v1` gets no item queue times, so ledger `wait_ms` is null (0 of 14,952 in a day) |
| 7 | "Person tasks have no durable per-item checkpoint" | A job-level watermark exists (`admin_jobs.cursor {last_done, last_change_at}`, 4,089 of 4,446 jobs). Per-item checkpoints are what is missing |
| 8 | `extraction_runs`, `field_change_log`, `admin_queue_watch` listed as instrumentation | First two do not exist. `pipeline.manual_edit_log` holds a person's edits. `admin_queue_watch` is a function (plus `security.queue_watch_*`) |
| 9 | Landings `courses.title`, `courses.status`, `ranking_observations`, "intake rows" | `catalogue.courses.canonical_title`, `catalogue.courses.lifecycle_status`, `catalogue.provider_rankings`, `catalogue.course_intakes` |
| 10 | "Unnamed courses (3,954 NZ)" | One NZ course: SIT NZQA 3954, "--" |
| 11 | "1,896 tests"; `superseded_by` on fees as existing/proposed | 1,926 tests at v2.15.351 (1,906 pass, 16 skipped, 4 legacy). `superseded_by` does not exist on `catalogue.course_fees` |

Section 7 now carries the doc-as-code standing rule (Part 3), and section 8 is marked done for 1.1.

---

## Part 2 — gap builds

### 2.1 `pipeline.course_events`: builds with Track B release 1 (its single data source)

**Table** (new; `comment on table`; Replaces: nothing; Retires: nothing):

| Column | Meaning |
|---|---|
| `id` bigint identity | |
| `at` timestamptz | |
| `course_id` uuid | |
| `provider_id` uuid | |
| `stage` text | One of: `binding`, `read`, `fee`, `english`, `intakes`, `enrich`, `admission`, `layer4`, `publish`, `operator` |
| `mode` text | Worker mode or job name |
| `run_id` uuid null | Admin job, ledger call, or Layer 4 item |
| `in_state` text, `out_state` text | The stage's own state words (no new status vocabulary) |
| `error_ref` text null | Reason code or gap-cause wording |
| `actor` uuid null | |
| `detail` jsonb | Small; capped by `course_events.detail_max_bytes` |

- Index `(course_id, at desc)`.
- **Append-only:** `update` and `delete` are refused by trigger. Only the catalogued retention job removes rows past retention, through the retention path.

**Writers** (one helper, `security.course_event_v1(...)`, called from each course lane's record function):
- **Binding:** `svc_course_link_search_*`, `svc_coverage_ai_match_*`, `svc_coverage_reidentify_record`, `course_url_fill_v1`, `layer4_fee_item_rebind_v1`.
- **Read:** `svc_coverage_read_record`.
- **Fee:** `svc_fee_ai_record`, `coverage_apply_course_v1`.
- **English / intakes / enrich:** `svc_enrich_ai_record`.
- **Layer 4:** `admin_layer4_inbox` decide.
- **Operator:** `admin_course_read_now` / v2.

Provider-level lanes (`find_site`, `logo_find`, `contact_page`) are not course events.

**Seed:** one `snapshot` event per course from current state (`coverage_course_pages`, `field_enrich_items`, `fee_course_requests`). It is labelled as a snapshot and is not presented as history.

**Settings:**
- `course_events.retention_days` (180, range 30–730, days, Retention);
- `course_events.detail_max_bytes` (2,000, range 200–8,000, bytes);
- `batch.course_events_retention` (20,000, range 1,000–100,000, rows a run).

**Job:** retention folds into the catalogued `retention-worker`, with a new `automation_catalogue` line.

**Volume:** about 10,000 events a day (reads about 2,200 pages a day, plus search, enrich and fee), so about 1.8 M rows at 180 days.

**Tests:**
- s105 (table, append-only trigger, every writer calls the helper);
- a live check that a read, an enrich and a fee each produce one event.

### Track B release 1 plan (data source: `course_events`)

| Piece | What | Reads from |
|---|---|---|
| Fields section | Chips for fee, English, intakes, duration, campus, delivery, link, description, level and field: filled / empty with cause / stale | Admitted values; `security.course_gap_causes_v1(course_id)` (the existing classifier lifted per course; `gap_causes_snapshot_v1` rebuilt on it, totals equal before and after); stale per `blade.stale_after_days` (180, 30–720) from `bound_at` / `captured_at` / `as_at` |
| Pipeline strip | BINDING → READ → FEE / ENGLISH / INTAKES / ENRICH: state, last run, where to follow, action | **`course_events`** (latest per stage) plus live queue state. Follow-paths named only where they exist: Task manager, Layer 4, `admin_control_events`, ledger, `gap_cause_snapshots`. Actions (role-gated, existing mechanisms): queue search (Operator+), queue read / fee / enrich (Curator+), open Layer 4 |
| Stored-copy replay (D-stored-copy) | "Read with AI": a stored copy no older than `read.stored_copy_max_age_days` (14, 0–30) goes at once to the enrich and fee readers with no fetch. A fresh fetch happens only when there is no copy, the copy is older, or "Fetch the page again" is ticked (logged with the reason) | New `public.admin_course_read_now_v2(course, reason, fetch_again)`; v1 marked `retiring` (replaced_by v2) and its UI call moves to v2. Each step writes a `course_events` row |
| D-calendar housekeeping | `component_register`: `calendar_default_intakes_apply_v1` and `semester_intake_apply_v1` get `replaced_by = security.enrich_parse_intake_periods_v1` and `retire_after` (+14 days); stale catalogue description corrected | — |
| Doc-as-code | PIPELINE-LINEAGE sections 2 and 4 updated in the same PR (stored-copy replay, `course_events`); contract test s104 added (Part 3) | — |

- **Tests:** s104 (lineage), s105 (`course_events`), s106 (replay: no `next_read_at` reset within age; reset when `fetch_again` or older; setting row label / range / unit / `used_by`), s107 (Fields / Strip render from mocked reads).
- **Live checks after merge:** snapshot totals unchanged; one replayed course reads with no fetch (`fetched_via` unchanged, no new evidence row).
- **Estimate:** about 3 days build + suite. Spend falls (fewer fetches).

### 2.2 Version stamps per run: queued behind Track A

- The worker passes `versions = {extractor: VERSION, worker: WORKER, identity_rule: IDENTITY_RULE, prompt_hash}` into `svc_worker_report_v1` (ledger `detail.versions`) and into each `course_events.detail`.
- Settings are content-addressed: `pipeline.settings_snapshots(hash pk, taken_at, settings jsonb)`, written by trigger on any `platform_toolset_settings` change. Ledger rows and course events carry `settings_hash`.
- **Settings:**
  - `replay.settings_snapshot_keep_days` (400, range 90–1,095, days; a snapshot still referenced is kept);
  - `replay.stamp_versions` (1, 0–1).
- **Retention:** the `retention-worker` line.
- **Tests:** s108 (every ledger row from `svc_worker_report_v1` has `detail.versions` and `settings_hash`; trigger writes a snapshot on change).
- **Estimate:** about 1 day.

### 2.3 Person-task resume: queued behind Track A

- `pipeline.task_items(job_id, item_key, course_id, provider_id, state, attempts, last_at, done_at)` is derived at accept from the task's arguments (idempotent: re-deriving gives the same items).
- The tick works items, not a counter. `progress` is computed from items.
- The watcher (`admin_job_watch_v1`) treats a running task with no item progress for `tasks.dead_after_minutes` as dead. It re-queues the unfinished items at their original position, up to `tasks.max_resumes`, then fails the task with the reason.
- **Settings:**
  - `tasks.dead_after_minutes` (30, range 10–240, minutes);
  - `tasks.max_resumes` (3, range 0–10);
  - `retention.task_items_days` (90, range 30–365, days).
- **Job:** the existing `admin-jobs` tick (catalogue line updated).
- **Tests:** s109 (derivation idempotent; dead → re-queue; resume cap).
- **Estimate:** about 1.5 days.

### 2.4 Queued-at into the ledger: queued behind Track A

- Pickers add `queued_at` per item:
  - `course_link_search.queued_at`;
  - `coverage_course_pages` as `greatest(next_read_at, bound_at)`;
  - `field_enrich_items.created_at`;
  - `fee_course_requests.requested_at`.
- The worker reports `wait_ms` (median of picked − queued) and `detail.wait_p90_ms` to `svc_worker_report_v1`.
- No new setting. `lane_queue_wait_v1` stays as the cross-check.
- **Tests:** s110 (the picker JSON carries `queued_at`; ledger `wait_ms` is not null for modes with a queue).
- **Estimate:** about 0.5 day (worker + pickers, additive keys).

---

## Part 3 — doc-as-code (standing rule, recorded)

> "Lane/gate/pipeline changes update PIPELINE-LINEAGE.md sections 2–4 in the SAME PR as the code; the FIELD-ADMISSION-MAP regeneration job covers section 1. A pipeline PR without its lineage update fails review — add this as the standing check."

Recorded in PIPELINE-LINEAGE.md section 7. Enforced from Track B release 1 by contract test **s104**:
- **When it applies:** a PR that adds or changes a cron job, an `svc_*_next` picker, a worker mode, a gate function (`link_search_block_v1`, `svc_fc_spend`, `coverage_identity_allowed`, `fee_below_floor_v1`) or a write path.
- **What it requires:** the release's CHANGELOG entry names the PIPELINE-LINEAGE.md section updated (commit and PR body likewise), or says "lineage: no change" with a reason.
- **Until s104 lands:** I apply the rule by hand on every pipeline PR.

---

## Remaining Platform Admin list (pruned)

1. **D-SIT3954:** choose route (a) or (b) to the stored register extract. Then you apply the one-row file I write.
2. **Visual check of #693:** NZ list sorted by Completeness; LI4245 shows NZ$37,000 / Lincoln.
3. **Policy proposals:** mark the 65 rows in `PASTE-20261025-policy-proposals-decide.sql`.
4. Unchanged and still waiting on you:
   - `zero_yield.auto_reset`;
   - UoA catalogue-host;
   - O5 / O8 / O9;
   - the R3 headline target after its first week.

**Next:** Track B release 1 starts now (Fields + Pipeline strip + `course_events` + stored-copy replay). Its PR comes for your review before merge.

---

## Decisions 25 Oct 2026 14:50 (Platform Admin; recorded before code)

| # | Decision | Effect |
|---|---|---|
| 1 | **SIT 3954, route (b).** "authorise the one-off workflow run. Constraints: reads ONLY the evidence file d0ff24c6…, prints ONLY the 3954 record, workflow deleted after use, run log + extract recorded in the triage file. Show me the extract before either one-row paste file is written." | Run on a temporary branch (push-triggered workflow), then the branch is deleted. Run log and extract go in the triage file (`2026-10-24-layer4-parked-triage.md`, section "SIT 3954 stored register extract"). No paste file is written until the Platform Admin has seen the extract |
| 2 | **#693 accepted.** "the live re-check (50/50 fees, LI4245 = NZD 37,000, Lincoln) is the verification; my browser glance is confirmation only." | Part A closed |
| 3 | **Track B release 1 approved as specified:** `pipeline.course_events` append-only as the single data source; Fields section with dashboard-total parity; Read-with-AI v2 (replay per `read.stored_copy_max_age_days` = 14, plus an explicit "Fetch again"); calendar retirement tidy; the test blocking pipeline PRs without a lineage update. "PR to me before merge." | Build starts; PR for review, not merged without approval |
| 4 | **Items 2.2, 2.3, 2.4:** specs accepted; builds queue behind Track A (S1 / 8a) | Standing order unchanged |
| 5 | **New settings key, open row:** `reading.read_attempts_max` (default 3, min 1, max 10) replaces the hardcoded 3-attempt limit the next time the picker is touched | PIPELINE-LINEAGE.md section 4 and section 6 rows renamed from the provisional `reading.max_attempts` |
| 6 | **Operating model:** agents cite REAL tables only. `extraction_runs` and `field_change_log` do not exist; the authority is PIPELINE-LINEAGE.md sections 5–6 | Added as rule 7 of `AGENT-OPERATING-MODEL.md` |

**Standing order:** Track A (S1 + 8a) runs uninterrupted. Next human gates: Track A PRs, the Track B release 1 PR, the SIT 3954 extract.
