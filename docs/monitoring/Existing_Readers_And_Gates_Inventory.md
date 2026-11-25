# Existing Readers and Gates Inventory (AER and Scholarships)

**Read-only discovery, 24 Nov 2026 11:00 AEDT (S2-Build, Platform Admin 10:43).** Sources: Pilot `main` at `83be9dec8` (live migration head `20261124120000`, worker `coverage-sweep-worker-v1.0.36`), admin `main` at `d30d3224`, and rolled-back live read-backs (nothing written). No schema, UI or cron change was made.

Purpose: the parallel AER lane (`S2-RM-Design`) and scholarship lane (`S2-Scholarship-Readers`) extend what exists instead of rebuilding it.

## 0. Corrections to the brief (read first)

| Brief says | Live system |
|---|---|
| "s992 multi-award heading splitter" | **Not built.** s992 (23 Nov) shipped the direct-first listing reader, turned stored-first off and registered the Charles Darwin listing sources. Multi-award pages that print awards in sections without per-award links (Charles Darwin, Lincoln) still give no items. The splitter is opportunity 1 below. |
| Pinned models `openai/gpt-4.1-mini`, Mistral Small 3.2, MiMo v2.6 Flash | Live routes (models used in the last 7 days): `provider_description` → `openai/gpt-4.1-mini`; `scholarship_extraction`, `scholarship_eligibility`, `course_description`, `fee_reader`, `calendar_reading` and others → `qwen/qwen3-30b-a3b-instruct-2507`. **`entry_matrices` (AER) is held, with no model and an empty model list**, so AER matrix reads are deterministic-only (s1017 `det_only` lease). Neither Mistral Small 3.2 nor MiMo v2.6 Flash is the routed model of any service with calls in the last 7 days (fallback chains were not inspected). |
| "64,000 remaining Firecrawl credits" | No balance table holds a credit balance; Firecrawl use is metered per call in `pipeline.firecrawl_calls.credits_used`. **Today 623 credits were used between 00:00 and 00:28 AEDT**, 576 of them by `link_search` (288 search calls), although `firecrawl.daily_budget_total` is 5 credits. See section 3.4: an escalation for the spend-gate owner. |
| s1022 golden-course validator as a database gate | It is a CI and digest script, `scripts/ci/validate-golden-courses.mjs` (spec `s1022`); there is no database object. |

## 1. AER reader stack

### 1.1 Edge functions

| Function | Role |
|---|---|
| `coverage-sweep` (worker `v1.0.36`) | Every AER read. Modes leased by the dispatcher lanes: entry-matrix reads, course entry reads, deterministic AER sweeps, chunk smoke tests. |
| `aer-source-upload` | A person uploads an official entry-requirements PDF or page as a source. |
| `evidence-storage-dedupe`, `evidence-link-index` | Evidence archive housekeeping: SHA-256 de-duplication and the link feed. |
| `firecrawl-monitor-webhook` (s1027) | Monitor change events; archives evidence first, then routes to Layer 4. It never admits. |

### 1.2 Shared parser modules (`supabase/functions/coverage-sweep/`)

| Module | Reader | Spec |
|---|---|---|
| `entry-ruled-grid.ts` | Ruled PDF and HTML grid, deterministic cell-to-row ($0, no model). Settings `reading.entry_ruled_grid_reader_on` (1), `reading.entry_ruled_grid_min_rows`, `reading.entry_ruled_grid_min_columns`, `reading.entry_det_only_lease_on`. | s1017 |
| `pdf.ts` (v1.4.1) | PDF text and cells, including a cell merged across columns (University of Auckland notes). | s996 |
| `entry-cells.ts`, `entry-grid.ts`, `pdf-grid.ts` | Cell reader and aligned-grid reader (v2 proven-structure sources). | s561, s851 |
| `entry.ts`, `entry-chunks.ts` | Matrix read orchestration and long-page sections. | s561 |
| `aer-det-reader.ts` | Deterministic per-course AER reader `aer-det-v1.4` (strict proof). | s1009 |
| `aer-v2.ts`, `aer-completeness.ts`, `aer-chunk-smoke.ts` | AER v2 rows, completeness checks, chunk smoke test. | s747, s1000 |
| `course-entry.ts` | Course-page entry reads. | |
| `admission-gate.ts`, `field-checks.ts`, `untrusted.ts` | Page classification, field checks, `fenceUntrusted` and `stripHiddenContent` for any text sent to a model. | s553, s811 |

AER v1 is frozen (Decision 276). New AER work is v2 only, and proven-structure sources are pre-authorised by the 23 Nov 2026 charter.

### 1.3 Database objects

- **Sources:** `pipeline.entry_matrix_sources` (one row per official matrix page or PDF per provider; the row is what the sweep reads).
- **Read queue:** `public.svc_entry_matrix_next` leases a source to the worker (s1017: with no usable model, stored PDFs are still leased `det_only` for the deterministic readers). `public.svc_entry_matrix_record` records the result; **a provider's first matrix read is a Layer 4 item a person approves**.
- **Rows and resolution:** `catalogue.provider_entry_matrix`, `catalogue.course_entry_requirements`, `security.aer_resolver_coverage_v1(text[])` (rules: course override, course row, provider minimum at the course level), `pipeline.aer_course_outcomes`, `pipeline.aer_machine_admissions` (reason codes such as `gate_incomplete`, `row_unsupported`, `identity_not_admitted`), `pipeline.aer_provider_coverage`, `pipeline.aer_coverage_daily`.
- **Rendered pages:** setting `pipeline.entry.render_hosts` = `wgtn.ac.nz`, `whitireiaweltec.ac.nz`, `newcastle.edu.au`, `griffith.edu.au` (hosts read through a renderer).

### 1.4 How a newly tested source joins the sweep (no new `pg_cron` job)

1. Add a row to `pipeline.entry_matrix_sources` for the provider, through its admin action or a migration that calls the canonical function.
2. The existing dispatcher jobs (`coverage-lane-dispatch`, `-b` and `-c`, through `security.worker_lane_call_v1`) and the AER jobs (`aer-det-sweep`, `aer-scheduled-read`, `aer-replay`) lease it on their next tick through `svc_entry_matrix_next`.
3. The worker tries the deterministic readers in order (cell, aligned grid, ruled grid). A model read happens only when the `entry_matrices` route has a qualified model (none today).
4. The first read goes to Layer 4; later reads follow the provider's approved matrix.

Active cron jobs: 136 (cap 140). No reader work needs a new job.

## 2. Scholarship reader stack

### 2.1 Edge function and modes

`coverage-sweep` (the same worker):

- **`scholarship_listing`:** listing pages, read direct-first since s992. The direct copy is used when it gives at least one listing item or award section; otherwise Firecrawl.
- **`scholarship_ai`:** reads candidate and detail pages, then extracts. A cut-off answer escalates to the two-part read `sectioned-v1` (s985). Answer limit `reading.answer_tokens.scholarship_page` = 4500.
- **Candidate page reads:** direct first.

Modules: `scholarship.ts` (`scholarshipListing`, `awardSections`, `awardSection`), `sch-extract.ts` (`scholarshipExtractPartRequest` a/b for the two-part read), `eligibility.ts`, `answer.ts`.

### 2.2 Fetch order (charter Tier 1 and Tier 2)

1. Stored copy (`storage_path` on the candidate or listing).
2. $0 plain-HTTP direct read: `lanes.stored_first_on` = 0 (s992), and robots.txt is respected.
3. Firecrawl only through `public.svc_fc_spend` (lane `sch_scrape`), gated by `firecrawl.daily_budget_on` and `firecrawl.daily_budget_total`.
   - The total was 0 under s976, so every fallback was refused.
   - s1010 raised it to **5 credits a day**, so scholarship fallbacks can spend again. Today: 5 `scholarship_read` credits. **Superseded (verified live 25 Nov 2026): the setting is 1,500 credits a day since s1035, 24 Nov 13:08; Master Plan 6.4.**

### 2.3 Discovery to publication: tables and functions

| Step | Objects |
|---|---|
| Listing sources | `pipeline.scholarship_listing_pages` (`source` manual, auto or suggested; `next_read_at`, where nulls are read first; `items`, `paging`), `pipeline.scholarship_listing_members` (`present`, `candidate_id`, `held_scholarship_id`); `public.svc_scholarship_listing_next`, `public.svc_scholarship_listing_record_v2` (a missing member only flips `present`; nothing is retired) |
| Candidate pages | `pipeline.scholarship_page_candidates` (`admit_status`, `admit_reasons`, `storage_path`); admission `security.scholarship_admit_from_provider_page_v1(bigint)`; scope `security.scholarship_university` and setting `sch_cov.legal_name_identity_on` (s985) |
| AI queue and extraction | `pipeline.scholarship_ai_queue` (`run_kind` admit, reread or detail; `recovery`; `next_try_at`), `pipeline.scholarship_ai_extractions`; fire `security.scholarship_ai_fire_v1` (counts only items the picker can take, s989), picker `public.svc_scholarship_ai_next`, record `public.svc_scholarship_ai_record` (cut answers queue `sectioned-v1`, s985; handed-back tries wait `retry.sch_ai_wait_minutes`) |
| Awards | `scholarship.scholarships` (`publication_status`, `lifecycle_status`), `scholarship.criteria` (`criterion_type`, `value_text`, `value_json`), `scholarship.award_details`, `award_tiers`, `scopes`, `offering_cycles`, `application_windows`, `audience_readings`, `nationality_readings` |
| Publication | `security.scholarship_publishability_for_v1(uuid[])` (returns `missing text[]`); hourly job `scholarship-auto-publish` (`security.scholarship_auto_publish_v1`, value from note s984) |
| Course linking | `scholarship.course_mappings` (`mapping_state` = `mapped` for all 142,750 rows; `mapping_basis`, `proof`, `source_scope_id`); `scholarship.course_mapping_candidates`. Writers: `security.scholarship_scope_apply_v1`, `security.scholarship_sweep_apply_v1`, `scholarship_course_fill_service`, `security.layer4_scope_rule_apply_one_impl`, `l4_api.layer4_scholarship_scope_bulk_decide`, `svc_scholarship_register_record_profile`. Jobs `scholarship-scope-auto`, `scholarship-recheck-queue`. |
| Coverage view | `pipeline.scholarship_provider_coverage` (1,935 providers; refreshed 24 Nov 10:34 AEDT; `disposition`, `next_action`, `reject_reasons`, `firecrawl_credits_30d`) |

Live totals (rolled back, 24 Nov 2026):
- 1,033 published awards on active-course providers (1,083 overall).
- 12,974 of 36,046 active courses linked to a published award.
- Dispositions: 895 searched with nothing found, 592 evidence insufficient, 195 not yet attempted or vendor failure, 112 published, 46 admitted but not published.

## 3. Shared guardrails and gates

### 3.1 Pre-admission gates (s1020, s1021)

They act on new machine admissions only. An active row is never demoted; a doubtful refresh opens a Layer 4 item and keeps the row. Every decision is logged in `pipeline.preadmission_gate_events`.

| Gate | Table and trigger | Switch (live) | Layer 4 kind |
|---|---|---|---|
| Fee year | `catalogue.course_fees` (`provider_current_tuition`) | `gates.fee_year_on` = 1, `gates.fee_year_ahead` = 1 | `provider_current_tuition` (approve: `security.layer4_tuition_apply_impl`) |
| English bands | `catalogue.course_english_requirements` | `gates.english_bands_on` = 1 | `course_english` (`security.layer4_course_english_apply_impl`) |
| Campus | `catalogue.course_campuses` | `gates.campus_provider_on` = 1 | `campus_link` notice |
| Scholarship GPA scale (s1021) | `scholarship.criteria` BEFORE trigger `security.gate_gpa_scale_tg` (`academic_minimum`, `value_text` starting `GPA`) | `gates.gpa_scale_on` = 1 | `scholarship_gpa_scale` (reviews in `pipeline.gpa_scale_reviews`; grouped by provider via `security.layer4_groups_v1`) |

### 3.2 Manual locks (s1023)

7,585 locks. `security.manual_fact_guard` (md5 `d0490f37` before s1023) drops a machine write to a locked field. For tuition and intakes it now opens one Layer 4 item, "Periodic Audit - Locked Field Update" (kind `locked_field_update`). Approve & Keep Lock writes as a person's edit and leaves the lock row unchanged. Bulk: `security.layer4_locked_update_bulk_v1` through `public.admin_layer4_locked_update_bulk` (limit `layer4.locked_update_bulk_max`).

### 3.3 Evidence archive

`pipeline.evidence_artifacts` (storage path, SHA-256, source URL). Storage paths:
- `evidence/aer-artifacts/<provider>/monitor/<sha256>.json.gz` (s1027 monitor: evidence first, `held_no_evidence` otherwise);
- `aer-artifacts/<provider>/` for snapshots (design section 10).

De-duplicated by `evidence-storage-dedupe`; linked by `evidence-link-index`.

### 3.4 Firecrawl metering

- **Per-call ledger:** `pipeline.firecrawl_calls` (`use_case`, `endpoint`, `provider_id`, `credits_used`, `outcome`).
- **Gate:** `public.svc_fc_spend`, with `firecrawl.daily_budget_on` = true and `firecrawl.daily_budget_total` = 5 credits a day (s1010). **Superseded (verified live 25 Nov 2026): the setting is 1,500 credits a day since s1035, 24 Nov 13:08; Master Plan 6.4.**
- **Platform caps:** `budgets.paid_daily_cap_usd` = 5 and `budgets.ai_daily_ceiling_usd` = 5 (s997).
- **Monitor:** a separate weekly cap, `firecrawl.monitor_weekly_credits` = 150 (s1027).
- **On-demand windows:** `security.on_demand_open_v1`, `on_demand_scope_v1`, `on_demand_close_v1`.
- **AI spend:** the key and balance are read live by `security.ai_route_v1` (balance US$100.98 and daily ceiling US$5 at 11:00 AEDT).
- **Escalation (spend-gate owner):** 623 credits were used today, 00:00 to 00:28 AEDT: `link_search` 576 (288 searches), course site maps 14, course reads 25, scholarship reads 5, central maps 3. That is well above the 5-credit daily total. Either search credits bypass the daily-budget count, or that work runs under an on-demand window. This should be checked before any lane relies on the US$5.00-a-day cap.

### 3.5 Other frozen surfaces

- G3 consumer API 75/48 (`security.consumer_api_check_v1`, spec s57).
- AER v1 frozen (Decision 276).
- Nothing is dropped or deleted by an applied migration.

## 4. Top 3 iteration opportunities

1. **Multi-award section splitter (scholarships; reuses `awardSection` and `sectioned-v1`).**
   - **Problem:** `awardSections` only finds coded award anchors. Pages that print several awards under headings, with no per-award link (Charles Darwin `/international/how-apply/scholarships` and `/international/scholarships`, Lincoln #10), produce no items. They also sit among the 592 "evidence insufficient" providers.
   - **Fix:** a heading-based splitter in `scholarship.ts` that emits one item per heading block (name plus anchor), so each award goes to the existing per-award section read (`awardSection(name)`) and, if cut off, the two-part read.
   - **Cost and risk:** no new table, job or model; a worker change plus its spec.
2. **Course linking through scope rules (scholarships; reuses `scholarship_scope_apply_v1` and `scholarship-scope-auto`).**
   - **Gap:** linked courses are 12,974 of 36,046, and only 18 providers reach 80% linkage.
   - **Example:** UNSW (8 published, 67.5%) and Sydney (72 published, 96.9%) are held by open Layer 4 items (14 and 48).
   - **Fix:** clearing grouped Layer 4 scope cards (`l4_api.layer4_scholarship_scope_bulk_decide`) and applying university-wide awards to all eligible courses through the existing scope rules raises coverage without new readers.
3. **AER: register sources, not readers (reuses s1017 and s996 with the dispatcher).**
   - **Problem:** with `entry_matrices` held (no model), only deterministic readers run, so throughput is set by how many official matrix sources are registered in `pipeline.entry_matrix_sources` and by `entry.render_hosts` (4 hosts).
   - **Fix:** S2-CF's domain pass (design section 10.3) should keep saving each university's international entry page or PDF to `aer-artifacts/<provider>/` and register the source row. The existing sweep picks it up with no job.
   - **Also:** close the Firecrawl search-metering gap (section 3.4) before any paid Tier 2 discovery.

Also seen: 39 scholarship admit items whose pages do not open with a direct read wait 30 minutes each round at $0. They are candidates for the Tier 2 micro-budget once metering is confirmed.
