# Pipeline lineage & operations reference

**Verified 1.1, 25 Oct 2026.** Draft 1.0 (Platform Admin's reviewer) was checked against the Coursefinder-Pilot code and the live database (`fxcwkweaxjtknorudmwp`). The report of flips and corrections is in `docs/platform/ui-audit/2026-10-25-lineage-verify-and-trackb.md`, Part 1. Where draft and code disagreed, the code won and the row was corrected.

Marks used in this file:
- **[V]** verified, with its citation;
- **[V-absent]** verified that the mechanism does not exist yet;
- **[V-spec]** an approved spec, not built.

Citations use these abbreviations:
- `cs:` = `supabase/functions/coverage-sweep/` in Coursefinder-Pilot;
- `mig:` = `supabase/migrations/`;
- `db:` = a live database object (schema.name).

This file is the single map of WHAT feeds each catalogue field, HOW the pipeline moves it, WHERE it breaks, and HOW work stops, retries, resumes and replays. Maintenance rule: section 7.

---

## 1. Field lineage — every catalogue field, its source, path and failure surface

### Course fields

| Field | Source (authority order) | Admitting mechanism (lane/function) | Landing | Failure surface → follow |
| --- | --- | --- | --- | --- |
| Title | 1. Register import (NZQA register adapter `nz_nzqa v1`, CRICOS) [V: db `pipeline.layer1_register_row_state`; evidence source "NZQA Education Organisations", worker `layer1-nz-live-v1.3.0`] 2. Published page title as alias (Defect 1) [V-absent: no course-title alias table; only `db:catalogue.provider_aliases`] | Register import [V]. There is no "TITLE SHOWN" reader step in the worker [V-absent: not in `cs:`] | `catalogue.courses.canonical_title` (+ `display_title`) | Gap cause; unnamed course: one NZ row (SIT NZQA 3954 "--", D-SIT3954) |
| Course code | Register (CRICOS = AU, NZQA = NZ, catalogue code = CA) [V] | Register import; identity proof of the bound page, `IDENTITY_RULE = "identity-v0.6.0"` [V: `cs:index.ts:117`, `cs:extract.ts:51`] | `catalogue.courses.course_code`; proof in `pipeline.coverage_course_pages.identity_basis` | `db:pipeline.coverage_reidentify_done` (re-verification record); mismatched pages re-verified once under the new rule |
| Study level | Register; else Enrich fields AI from the stored page | `public.svc_enrich_ai_record` case `level` → `ref.study_levels.short_code` [V: db; mode `enrich_ai` `cs:index.ts:2033`] | `catalogue.courses.study_level_id` | `gap_cause_snapshots` (level: "AI: the title gives no value", "not tried yet") |
| Field of study | Register; else Enrich fields AI | `svc_enrich_ai_record` case `field_of_study` (ASCED `asced-\d{4}`) [V] | `catalogue.courses.primary_field_id` | `gap_cause_snapshots` (field_of_study) |
| Delivery mode | Course page (stored copy) via Enrich fields AI; register course locations | `svc_enrich_ai_record` case `delivery` [V]. **Corrected:** not the page reader (`read` mode does not extract delivery) | `catalogue.courses.delivery_mode`; `catalogue.course_campuses.delivery_mode` (register) | `gap_cause_snapshots` (delivery); Layer 4 |
| Duration | Register (CRICOS duration) [V]; course page via Enrich fields AI, quote-on-page (a fee-basis quote is refused, worker v0.23.2) | `svc_enrich_ai_record` case `duration` [V]. **Corrected:** Enrich fields AI, not the page reader | `catalogue.courses.duration_value` / `duration_unit` | `gap_cause_snapshots` ("AI: the page does not state it") |
| Intakes | 1. Course-page months [V] 2. Page-period → month via the latest approved calendar, course page as evidence [V: `security.enrich_parse_intake_periods_v1`, called from `svc_enrich_ai_record` case `intakes`] | Enrich fields AI; period route. Calendar-defaults lane **retired**: jobs `provider-calendar-defaults` and `provider-calendar-intakes` off and `retiring` [V: `mig:20261022042000_cf247_intakes_page_only.sql`; D-calendar 25 Oct] | `catalogue.course_intakes` (status, `source_intake_key`; 2,166 calendar rows withdrawn 22 Oct) | gap causes (intakes); policy approvals queue (Layer 2/3 › Operations › Approvals waiting) |
| English requirement | 1. Course page [V] 2. Central policy default, provider level [V] | Enrich fields AI (`english`, `security.enrich_parse_english_v1`) [V]. Central policy lane: `central-find` → `central-ai` (pinned model, quotes) → proposal → `policy-auto-approve` (`security.policy_auto_approve_v1`, `central.auto_approve` on; refused when > `central.max_disagree_pct` 50% of ≥ `central.min_compare` 10 pages disagree) or a person (`admin_provider_policy_decide`) [V]. Applied by job `provider-english-defaults` [V] | `catalogue.course_english_requirements` | Layer 4; Approvals panel (Operations); flag `policy_disagrees` |
| Tuition (international) | 1. Course page fee [V] 2. Fee-schedule pages [V: `pipeline.provider_fact_sources` kind `fee_schedule`; job `fee-reader` → `security.fee_reader_tick_v1`; `public.svc_fee_schedule_preview` / `svc_fee_schedule_apply`; person `admin_provider_fee_schedule_decide`] | Fee reader (mode `fee_ai`, `cs:index.ts:1997`, `cs:fees.ts`), which reads the **stored copy** (`svc_fee_ai_next` returns `storage_path`) [V]. Write path `security.coverage_apply_course_v1` with `security.fee_below_floor_v1` and `security.coverage_identity_allowed` [V]. Supersession by `fee_year` / `valid_to` [V]. `superseded_by` [V-absent: no such column on `catalogue.course_fees`] | `catalogue.course_fees` (`fee_type 'provider_current_tuition'`, audience) | unverified quarantine; Layer 4 (fee validation, held fee); `pipeline.fee_course_requests` |
| Official course page link | Bound page (proven binding) [V] | `security.course_url_fill_v1` (job `course-url-fill`) [V]; Layer 4 "enter another address" → `security.layer4_fee_item_rebind_v1` → `admin_course_edit set_official_url` [V: `mig:20261024009000`]; manual (never auto-touched) | `catalogue.course_links` (`link_type 'official_course'`) | `db:pipeline.course_url_fills` (fill and retraction log) |
| Description | Course page | No course-description reader [V-absent; B2 queued]. 163 courses hold a description today (origin not traced in this pass) | `catalogue.courses.description` | — |
| Campus (name/city/state) | Register + provider campus pages | Register mapping (CRICOS location names, v2.15.348) [V]; Enrich fields AI `campus` / `campus_list` / `campus_region` (`provider_fill` tasks) [V] | `catalogue.campuses`; `catalogue.course_campuses` | Layer 4; provider blade; gap causes (campus, campus_region) |
| Open to international | Register (CRICOS registration) + NZ signatory basis [V] | Register import; `nz-cop` → `security.nz_cop_fire_v1` / `nz_cop_apply_v1` (mode `nz_cop` reads stored NZQA provider pages) [V]; Enrich fields AI `international` (quote must name the course's students or fees) [V] | `catalogue.courses.open_to_international`; `catalogue.providers.enrols_international` | Layer 4; NZ signatory list (O5) |
| Status (active/archived) | Decisions | Layer 4 archive decisions [V] | `catalogue.courses.lifecycle_status` (**corrected** from "courses.status") | Layer 4 Decided |

### Provider fields

| Field | Source | Mechanism | Landing | Failure surface |
| --- | --- | --- | --- | --- |
| Name / display name | Register; a person sets the display name | Register import [V]; `public.admin_provider_edit` [V]. Legal-name capture [V-absent: deferred, "not now"] | `catalogue.providers.canonical_name` / `display_name` | Layer 4 |
| Website | Provider's own site | Mode `find_site` (`cs:index.ts:926`; registers first for AU, worker v0.21.6) via `svc_coverage_site_next`, job `coverage-find-site` [V]; Layer 4 kind `website_needed` [V] | `catalogue.providers.website` | Layer 4 (40) |
| Description | Provider's about page | Part E reader [V-spec; providers with a description today: 0 of AU/NZ/CA] | `catalogue.providers.description` (+ additive provenance columns, spec) | Wollongong acceptance test |
| Logo/assets | Provider home page | Mode `logo_find` (`cs:index.ts:698`, `cs:logo.ts`), job `logo-find` [V] | `catalogue.provider_assets` | Task manager; flag on not found |
| Contacts | Provider's own site (public contacts) | Mode `contact_page` (`cs:index.ts:764`), job `provider-contact-page` [V]; "Fill in from website again" (`provider_fill`) [V] | `pipeline.provider_contacts` (+ `provider_contact_points`, `_observations`, `_versions`) | Task manager |
| Enrols international | Register | Register import [V]; NZ: `nz_cop` [V] | `catalogue.providers.enrols_international` (+ `_basis`) | — |
| Rankings | Statistics editions (QS / THE) | Job `statistics-edition-discovery` (edge function) [V]; `ranking-link` → `security.ranking_link_auto_v1` [V] | `catalogue.provider_rankings` (**corrected** from "ranking_observations", which does not exist) | Rankings panel |
| Graduate results | QILT / PRISMS | `public.svc_qilt_prepare_source`, `svc_qilt_upsert_mappings`, `svc_qilt_apply_observations` [V]. The B6 UNSW/Adelaide name mismatch was not re-checked in this pass | `catalogue.provider_outcomes`, `catalogue.outcome_benchmarks`, `ref.outcome_surveys` (**corrected**) | Rankings panel |

### Scholarship fields

| Field | Source | Mechanism | Landing | Failure surface |
| --- | --- | --- | --- | --- |
| Name/value/deadline | Listing + detail pages | Modes `scholarship_read` (`cs:index.ts:1087`), `scholarship_listing`, `scholarship_ai` (`cs:index.ts:1843`, pinned model, quotes checked), `scholarship_recheck` [V]. B4 second pass [V-absent: queued] | `scholarship.scholarships` | Layer 4 Held scholarship (935) |
| Eligibility / min academic / countries | Detail page (quote-on-page) | `scholarship_ai`; jobs `scholarship-audience`, `scholarship-nationality` [V]. B4 [V-absent] | scholarship fields | Layer 4 (three-button decisions) |
| Value-note consistency | Detail page | B4 note-vs-amount check [V-absent: queued] | `scholarship.scholarships` | the 23 contradictory notes |

---

## 2. Execution model — how work moves

**Stages per course:**
1. Register import (L0).
2. Binding: page search, then AI match, then reidentify; or manual.
3. **Read: the page is fetched again when it is due** (`next_read_at`): directly first, through Firecrawl only under the trust rules (CRICOS-code finds, pages listed on the university's own site, manual) or when blocked or needing a browser [V: `cs:index.ts` mode `read` from line 2646, worker v0.21.3 and v0.21.5]. A re-read whose text equals the copy in use keeps that copy (no new evidence; worker v0.32.0).
4. **Downstream readers use the stored copy:** `fee_ai`, `enrich_ai` and `reextract` take `storage_path` from their pickers (`svc_fee_ai_next`, `svc_enrich_ai_next`, `svc_coverage_reextract_next`) [V].
5. Per-field admission (apply functions with gates).
6. Layer 4 review where flagged.
7. Publication to the website and search document.

**Corrected:** the draft said "read (stored copy first, fetch only when silent)". That holds for the downstream readers, not for the page read. "Read with AI" (`public.admin_course_read_now`) also forces a fresh fetch today. That changes in Track B release 1 under D-stored-copy: `read.stored_copy_max_age_days`, default 14.

**Worker modes** (`coverage-sweep-worker-v0.47.0` since SP-1, 25 Oct 2026 23:20; one edge function; each mode is `if (mode === …)` in `cs:index.ts`), with ledger calls over 7 days to 25 Oct:

| Group | Modes (calls) |
| --- | --- |
| Course pages | `read` 2,733 (job `coverage-read-2`; `coverage-read` is off), `discover` 3,135, `link_search` 1,568, `ai_match` 1,567, `reidentify` 1,558, `reextract` 1,507, `companion_read` 27, `course_list_read` 21, `programme_discover`, `programme_read` |
| Providers | `find_site` 433, `contact_page` 429, `logo_find` 156, `cricos_peo` 1,567, `site_check`, `flag_check`, `nz_cop`, `credential_read` |
| Central pages | `central_find` 273, `central_ai` 628, `provider_facts` 157, `provider_facts_add_tests` 26 |
| AI readers | `enrich_ai` 46, `fee_ai` 4, `scholarship_ai` 13 |
| Scholarships | `scholarship_discover` 157, `scholarship_listing` 104, `scholarship_read`, `scholarship_recheck`, `scholarship_reextract` |
| Other | `source_find` 78, `openrouter_balance` 105, `register_replay`, `retention_files`, `fc_run`, adapter modes |

**Corrected:** the draft's "coverage-read-2" is a scheduled-job name, not a mode. Its mode is `read`.

**Course-search gates, in the order code evaluates them.** This is the stall-cause walk in `security.link_search_block_v1`, mirroring the picker `public.svc_course_link_search_next` [V: live function; R2 `mig:20261024013000`; hotfixes `mig:20261024009000` / `010000` / `011000`]:
1. Lane paused.
2. Lane idle-paused: backoff, `tick.backoff_max_minutes` 15.
3. Search switched off.
4. Month cap.
5. Day budget (`svc_fc_spend`'s day share).
6. Daily picked cap: `search.daily_picked_cap` 100; a person's running task is counted, not held.
7. Provider hidden (unpublished).
8. Search stopped: the university stop. A person's task passes it, in the picker and in `svc_fc_spend`.
9. Not a target: rule plus overrides, `firecrawl_target_cache` with `rule_reason`.
10. No site.
11. Directory site.
12. Skipped provider.

The per-course stop (6 rejected pages, `search.stop_per_course_after`) is a row filter in the picker, not a step of the walk.

**Updated 25 Oct 2026 (v2.15.352, #694 gate consolidation, and v2.15.353, SP-1) [V: live after merge]:**
- The university stop with the person bypass and the per-course stops now live in one function, `security.search_stop_gate_v1(provider, course, stopped, person)`. It is called by the picker, `svc_fc_spend` and the stall walk, and returns `search_stopped`, `no_page_by_provider` or `course_stopped`.
- `no_page_by_provider` (SP-1) holds a course recorded in `pipeline.course_no_page` (no page published by the provider, or a conjoint degree under an approved rule) until a newer map exists.
- Every automatic binding path asks one negative-evidence predicate, `security.page_refused_v1(course, url)` (page_rejections ∪ course_page_blocks): search result, binder, AI match prepare and reidentify.

After search, fees pass `fee_below_floor_v1`, and every field kind passes `coverage_identity_allowed`.

**Corrected:** the draft put the target rule first and the stop before the cap; the code order is as above. Gate consolidation is the S1 item.

**Binding model, SP-1 (v2.15.353, 25 Oct 2026):** map, then AI match (`coverage_ai_match`) is the binding lane. Its AU scope is widened by `pipeline.bind_match_scope` (tranche overrides plus the top `bind.match_scope_top_n` providers by courses without a page; refreshed hourly by `no-page-propose`). Discovery also maps each provider's approved extra course domains (`pipeline.provider_extra_domains`, added by the Platform Admin).

Courses still without a page after `bind.no_page_after_passes` AI passes on a fresh inventory are proposed by job `no-page-propose` (inert while `bind.no_page_on` is 0):
- the first run per provider goes to Layer 4 (`no_page_first_run` / `conjoint_rule_first_run`), universities first, at most `bind.no_page_first_runs_per_run` an hour;
- `pipeline.no_page_trust` keeps the 60% result;
- trusted providers' later cases are recorded automatically;
- any page found later re-opens a course (triggers on `course_links` and `coverage_ai_match`). Nothing is deleted.

**Auto-admit of first runs, SP-2a (v2.15.356, Platform Admin 26 Oct 2026 08:25):** job `layer4-auto-admit` (hourly at :47, while `layer4.auto_admit_on` is 1) checks each waiting first run against stored data and approves it through `security.no_page_review_apply_v1` (same 60% rule) when:
- the provider's course list is verified (`security.course_list_check_v1`: read within `layer4.auto_admit_list_days`, holding at least `layer4.auto_admit_list_recall` of its bound official pages);
- the sample is confirmed (`security.no_page_sample_check_v1`: at least `layer4.auto_admit_sample_pct` with no look-alike unbound list address; look-alikes are kept as "has a page");
- the list shape (read method | provider type | page depth | pdf | extra-domain) matches a first run a person approved.

New shapes stay in Layer 4; 1 in `layer4.auto_admit_sample_rate` that pass is kept for a person. Outcomes and evidence: `pipeline.layer4_auto_admissions`; auto-admissions also in `pipeline.layer4_decisions` (system account) and Layer 4 › Decided ("Auto: <reason>").

**Write paths (the only ways values reach the catalogue):**
- `security.coverage_apply_course_v1` (fees: floor + identity);
- `svc_enrich_ai_record` (English, intakes, duration, delivery, level, field, campus, international);
- `security.course_url_fill_v1` (links);
- Layer 4 apply functions;
- admin functions (manual; exempt from automatic gates; never overwritten). [V]

---

## 3. Incomplete mechanisms — the register of gaps being fought

| Gap | Mechanism fighting it | Status |
| --- | --- | --- |
| Binding ceiling (NZ 47.0% on the tracker definition, 25 Oct 22:20; the earlier 53.5% was not reproducible) | R2 cap + tranche overrides + zero-yield re-acquire + person tasks; SP-1 no-page cause and conjoint rule (Layer 4 first runs, 60% rule), AI match scope, extra course domains | Live; SP-1 merged 25 Oct, no-page proposals off until `bind.no_page_on` |
| Wrong pages | Zero-yield flow (`security.zero_yield_detect_v1`; reset `zero_yield_reset_v1` is the only writer of `pipeline.page_rejections` today) + S1 rejections (queued) | Detect live |
| Identity mislabel (421) | identity-v0.6.0 re-verify; 8a per-kind country identity rules (queued) [V-absent: no `country_identity_rules` table yet] | Re-verify live |
| Fees on separate schedule pages | `fee_schedule` sources + `fee-reader` + `fee_ai` (4 calls in 7 days) [V] | Live, low volume |
| Page-silent fields | Gap causes recorded; re-reads don't help (sweep proved it) | Accepted truth |
| Policy defaults | Central policy lane; approvals queue (D-L4-1 fix in Track B release 2) | Live, queue surfaced |
| Intakes beyond page-stated | Period→month route only (calendar-defaults retiring, D-calendar) | Live |
| Unnamed courses | **Corrected:** one NZ course (SIT NZQA 3954 "--"), not 3,954. Stored-register read, then a one-row fill or quarantine paste (D-SIT3954) | Awaiting the register extract |
| Title variants / renames | Defect 1 (wrong-page first, aliases quoted) | Build queued |
| Redirect to a different course's page (Waikato, 26 Oct 2026: the Certificate of Attainment in Academic English address redirects to the Certificate of Attainment in English Language page, WI0194) | **Rule (Platform Admin 26 Oct 2026 12:29):** a page reached by a redirect that lands on a different course's page is a wrong page, with S1 semantics: rejected for that course, never a binding, and no value is read from it for that course. Spec: `ui-audit/2026-10-26-waikato-triage-followups.md` section 2 | Spec written; build queues with the search-quality / Defect 1 batch |
| Register course renamed on the provider's site (Waikato Bachelor of Social Work WI0858 vs the published Bachelor of Social Sciences) | Routed to the Defect 1 title-verify flow (alias after verification), never to the no-page cause. WI0858 is held from no-page proposals (`course_no_page` hold row, 26 Oct). The general near-twin check is designed with the Defect 1 batch | Hold live; check queued |
| AU international variants | Defect 2 (quantify now, build later) | Queued |
| Scholarships thin fields | B4 second pass + Layer 4 de-parking | Queued |
| Provider descriptions | Part E reader (Wollongong acceptance test) | Rides with Track B release 3 |
| target_only scope | Staged (c) tranche live; (b) rule proposal after 2 weekly lines | Live |

---

## 4. Stop / start / retry semantics — what exists today

- **Read attempts** [V]: picked while `read_attempts < 3`; `needs_render` gives the attempt back (`public.svc_coverage_read_next`, `svc_coverage_read_record`).
  - **Corrected:** the cap 3 is a literal in the picker, not a setting. This is a G2 finding. **Open row (Platform Admin 25 Oct 2026 14:50):** settings key `reading.read_attempts_max` (default 3, min 1, max 10) replaces the literal the next time `svc_coverage_read_next` is touched.
  - **Corrected:** exhausted pages are excluded from picking but do **not** feed `page_rejections`. Only `security.zero_yield_reset_v1` writes it. Exhausted-page rejections are part of S1.
- **Search stop** [V]: per course after 6 rejected pages, with the university stop behind it. A person's task passes the stop in the picker and in the credit check (hotfix 2). `credit_refused` and `daily_cap` blocking reasons show in the Task manager (`security.admin_job_status_v1`).
- **Firecrawl refusals are named** (SP-1, worker v0.47.0) [V]: `target_list_refused`, `credits_reserve`, `scholarship_share`, `no_firecrawl_key` are recorded in `firecrawl_budget_refusals` / `firecrawl_refusals_by_provider` by `svc_fc_refusal_note_v1`; the database's own refusals stay in `svc_fc_spend` (worker label `credits_refused`). A target-list refusal in course search is counted as an attempt, not re-queued.
- **Backoff** [V]: empty-tick pause with event-driven wake; `tick.backoff_max_minutes` 15.
- **Person tasks** [V]: `pipeline.admin_jobs` (state, `cursor`, `progress`, `cancel_requested`, `pause_requested`), driven by `security.admin_jobs_tick_v1` and watched by `security.admin_job_watch_v1`. Cancel sets `cancel_requested` (or `cancelled` when not started). Finished tasks leave the running list.
- **Recovery patterns in use** [V]:
  - count-guarded re-queue paste files (re-opened 24 universities; tranche overrides);
  - fee requests re-fired on re-bind;
  - `admin_course_read_now`;
  - reidentify re-verification keyed by rule version;
  - attempt-restoration migrations.
- **Reconstructable state** [V]: a course's binding, read and admission state can be rebuilt from `coverage_course_pages` (status, `read_attempts`, `bound_at`, `next_read_at`, `fetched_via`, `identity_basis`) + gap causes + evidence artifacts.
- **[Gap, corrected]** Person tasks keep a job-level progress watermark (`admin_jobs.cursor = {last_done, last_change_at}`, 4,089 of 4,446 jobs) but no per-item checkpoint. A dead mid-way task is re-derivable only from queue state. → Item 2.3.
- **[Gap, corrected]** The queue *does* carry queued-at (`pipeline.course_link_search.queued_at`, 26,020 of 26,020 rows; `coverage_course_pages.next_read_at`). But the worker's report (`public.svc_worker_report_v1`) is not given item queue times, so ledger `wait_ms` is null on 0 of 14,952 calls in the last day. Queue waits are measured separately via `security.lane_queue_wait_v1`. → Item 2.4.
- **[Gap]** No per-course append-only event log: a course's journey needs about 6 tables joined. → Item 2.1 (`pipeline.course_events`, Track B release 1).

---

## 5. Logging & replay — what exists, and what replay requires

**Existing instrumentation [V]:**

| Object | What it holds |
| --- | --- |
| `pipeline.mode_outcome_ledger` | Columns `run_at, mode, status, ms, items, ok, failed, wait_ms, landed, worker, detail`; retention `retention.mode_outcome_ledger_days` 90, job `ledger-retention`; written by `svc_worker_report_v1` and `security.health_hourly_v1` |
| `pipeline.gap_cause_snapshots` | Job `gap-causes`, hourly; aggregate country × attribute × cause |
| `pipeline.evidence_artifacts` | 172,218 rows; bucket `evidence` |
| `pipeline.admin_control_events` | Fills, resets, quarantines, decisions |
| `pipeline.page_rejections` | Rejected pages |
| `pipeline.manual_edit_log` | A person's edits |
| `pipeline.stats_15m` | 15-minute stats |
| Health hourly | Job `health-hourly` → `security.health_hourly_v1`; `pipeline.health_snapshots`, retention 90 days |
| Queue watch | `public.admin_queue_watch` (a function) and `security.queue_watch_*`, job `queue-watch`; `security.lane_why_idle_v1` |
| Task records | `pipeline.firecrawl_runs`, `pipeline.field_enrich_items` (per item, per field, with reason), `pipeline.scholarship_ai_extractions`, `pipeline.enrich_plan_runs` |

**Corrected:**
- `extraction_runs` does not exist; there is no per-run extraction table. The run records are the ledger plus the per-lane item tables above.
- `field_change_log` does not exist; `pipeline.manual_edit_log` holds a person's edits.
- `admin_queue_watch` is a function, not a table.

**What a replay of a course's enrichment requires:**
1. Stored page copies. These exist; downstream readers already read them, and the page read itself re-fetches (section 2).
2. The reader versions, prompts and rules in force at the time. Partly present: the worker constants `VERSION`, `WORKER` and `IDENTITY_RULE` exist in code, but are not stamped per run → item 2.2.
3. The gate settings at the time. A settings change is logged with its reason, but not snapshotted per decision → item 2.2.

Deterministic re-admission (replaying a stored copy through the current readers) exists. Historical replay (as it happened) does not.

**Specified (see `docs/platform/ui-audit/2026-10-25-lineage-verify-and-trackb.md`):**

| Item | What | When |
| --- | --- | --- |
| 2.1 | `pipeline.course_events` | Track B release 1 |
| 2.2 | Version stamps per run | Queued behind Track A |
| 2.3 | Task items and resume | Queued behind Track A |
| 2.4 | Queued-at into the ledger | Queued behind Track A |

---

## 6. Failsafe & failproof inventory

**Existing [V]:**
- count guards on every paste file (all-or-nothing, named-row failures);
- md5-guarded edits;
- contract tests and CI gates (CF-247 UATs: 1,926 tests at v2.15.351; 1,906 pass, 16 skipped, 4 known legacy failures);
- frozen consumer API plus daily drift guard (`consumer-api-guard`);
- settings-not-hardcoded live check (`security.controls_check_v1`);
- no drops (destructive changes go to the Platform Admin as a paste file);
- quarantine-not-delete with named reversal paths;
- backoff caps; daily credit and course caps;
- stall visibility (`lane_why_idle_v1`, `credit_refused`, `daily_cap`, Task manager blocking reasons);
- negative-evidence learning;
- manual-lock exemptions;
- retention jobs;
- health checks plus queue watchdogs; hourly report; weekly tranche line;
- housekeeping Replaces/Retires (`hygiene-check`).

**Proposed additions (from open mandates):**
- blade Fields section and Pipeline strip (Track B release 1, on `course_events`);
- FIELD-ADMISSION-MAP plus regeneration job;
- acceptance report and auto-admit (off by default);
- task resume (2.3);
- D-L4-1 pointer integrity check;
- `reading.read_attempts_max` setting (default 3, 1–10; open row, section 4 finding).

---

## 7. The division of labour for this file (doc-as-code, standing rule from 25 Oct 2026)

The data-engineering agent maintains this file. Verified rows carry the release, PR or code location that evidences them.

**Standing check (Platform Admin 25 Oct 2026):**
1. A PR that changes a lane, gate, picker, worker mode, write path or retry/stop semantic updates sections 2–4 of this file in the **same PR**.
2. The FIELD-ADMISSION-MAP regeneration job covers section 1.
3. A pipeline PR without its lineage update fails review.
4. It is enforced by the contract test `cf-247-s104-lineage-doc-as-code` (Track B release 1). The test fails a migration or worker change that adds or changes a `cron` job, `svc_*_next` picker, worker mode or gate function unless the PR body names the PIPELINE-LINEAGE.md section updated, or states "lineage: no change" with a reason.

## 8. Verification checklist

Done 25 Oct 2026 (version 1.1); the report is in the mandate record, Part 1. Re-run in full whenever a Track A or Track B release lands. Each release's PR records its section updates under rule 7.
