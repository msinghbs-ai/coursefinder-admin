# UI/UX and settings simplification: audit and phased plan (15 Nov 2026)

## Status
- **Requested by:** the Platform Admin (15 Nov 2026 23:23 AEDT).
- **This document:** a read-only audit with a phased plan. Nothing has changed yet.
- **Decisions locked:** the Platform Admin, 16 Nov 2026 05:12 AEDT. See §6 for the four decisions and §7 for the architectural specs (UnoPim patterns) that every phase's implementation spec must carry.
- **Starts after:** Phase 1 begins once all three consolidation cutovers are complete:
  - PR 1, rollup scheduler: review Mon 16 Nov 22:30 AEDT;
  - PR 2, admission rule runner: review Tue 17 Nov 22:30 AEDT;
  - PR 3, coverage lane dispatcher: not started.

  See [[cron-governance-audit-2026-11-15]].
- **Sources:**
  - live tables: `pipeline.platform_toolset_settings`, `pipeline.component_register`, `pipeline.automation_catalogue` and `cron.job`, read on project fxcwkweaxjtknorudmwp on 15 Nov 2026 at about 14:10 UTC;
  - function source in schemas `security` and `pipeline`, read with one pattern pass and a 20-second limit;
  - the Pilot repo at `main` ae9464f8 (`src/`, `supabase/functions/`).
- **Audit rule after the 15 Nov incident:**
  - Every audit query is small and bounded, with `statement_timeout` of 20 s or less.
  - No query concatenates function source or scans every function once per setting.
  - The 12:33–13:44 UTC outage came from such a query.

## 1. Summary

| Area | Finding | What it means |
|---|---|---|
| Settings | 1,489 settings; **1,406 (94%) have never been changed by a person** | Most settings are defaults nobody tunes. They make Settings hard to read |
| Settings | **64 sections** on Pipeline settings, several of them near-duplicates | People can't find a setting by looking for it |
| Settings | **39 settings belong to Serper and ScrapingBee**, dropped on 4 Oct 2026 (Firecrawl only) | Dead weight. Their screens retire on 17 Nov |
| Settings | 11 settings name a retiring or retired component in `used_by` | Candidates to retire, or to re-point to the component that replaced it |
| Settings (G2) | `used_by` is missing on 93 service settings and `unit` on 82 settings | G2 asks for a label, range, unit and `used_by` on every setting |
| Code (G2) | 61 worker or decision functions hold unmarked time and size literals (and 14 more are partly marked); 26 unmarked numeric constants sit in 15 edge function files | Values that should be settings, or lines that should carry `-- fixed:` |
| Screens | 39 menu entries and 69 active screens; **76 files build their own tables (197 tables), and only 3 use the shared `DataTable`** | Each screen filters, sorts and pages differently, and the effort repeats on every change |
| Screens | Settings are written from 5 screens; Layer 4 review is spread over 6 files | One concept is split across several places |

## 2. Settings bloat

### 2.1 Size and use

| Toolset | Settings | Never changed by a person | Missing `used_by` | Missing unit | Sections |
|---|---|---|---|---|---|
| pipeline | 1,366 | 1,287 | 0 | 45 | 64 |
| firecrawl | 66 | 64 | 45 | 20 | 9 |
| serper (dropped 4 Oct) | 23 | 22 | 23 | 11 | 4 |
| scrapingbee (dropped 4 Oct) | 16 | 16 | 16 | 6 | 3 |
| openrouter | 14 | 13 | 5 | 0 | 2 |
| edge_functions | 2 | 2 | 2 | 0 | 1 |
| scheduled_jobs | 2 | 2 | 2 | 0 | 1 |
| **Total** | **1,489** | **1,406** | **93** | **82** | |

Other facts:
- **Metadata is complete in places.** Every setting has a label and a reason, and every number setting has a range.
- **Classification is sparse.**
  - `control_class` is set on only 84 settings (55 automatic, 29 human).
  - `home` is set on only 89 (all `models_services`).
- **Change history is thin.** There is no `created_at`, and no change log beyond `pipeline.settings_backups`. The `reason` column holds only the latest reason.
- **Where people do tune:** of the 83 settings changed by a person, the most are in Provider descriptions (18), Entry requirements (11), Job sizes (8), Intake dates (6), Course description and deadline (5) and Scholarship eligibility reader (5).
- **Sections never touched:** 43 of the 64 pipeline sections have no setting a person has changed, among them Human-assisted recovery (92 settings), Platform upkeep (84), Work continuity (36), Layer 4 readiness (33) and Re-read and retry (32).

### 2.2 Sections that overlap
These groups can merge. The section is a display label, so renaming one changes no key:
- Re-read and retry (32) / Re-reads and retries (4)
- Storage & retention (5) / Storage (1) / Retention (1)
- Admission checks (13) / Admission (4)
- Enrichment (66) / Enrich fields (32) / Enrichment lanes (5)
- Layer 4 (28) / Layer 4 readiness (33)
- Provider descriptions (72) / Provider descriptions › built-in prompt only (4)
- Scholarships (32) / Scholarship details (4) / Scholarship discovery (5) / Scholarship coverage recovery (16) / Scholarship flow guard (6) / Scholarship eligibility reader (13)

### 2.3 Settings tied to retiring or retired components

| Setting(s) | Component (status) | Replaced by |
|---|---|---|
| `calendar.countries`, `calendar.university_levels` | `security.calendar_default_intakes_apply_v1` (retiring) | Intakes from the course's own page only |
| `alerts.max_attempts`, `alerts.retry_minutes` | `security.platform_alerts_confirm_v1` (retiring) | `security.alert_delivery_receipt_v1` |
| `alerts.delivery_enabled` | `security.platform_alerts_take_v1` (retiring) | `security.alert_delivery_take_v1` |
| `intake_dates.name_period_lists` | `security.intake_dates_plan_v2` (retiring) | `security.intake_dates_plan_v3` |
| `intake_dates.deadline_max_days_before` | `security.intake_dates_plan_v1` (retiring) | v2, then v3 |
| `batch.course_link_reverse` | job `course-link-reverse` (retiring) | nothing |
| `worker.outcome_failed_runs` | job `worker-outcome-check` (retiring) | nothing |
| `batch.evidence_purge_check` | job `evidence-purge-prepare` (retired) | nothing |
| `batch.calendar_reread` | `public.svc_calendar_reread_next` (retiring) | not recorded |

**Check before retiring.** Each of these must first be confirmed unread by the component that replaced it. For example, the alert settings may still be read by the v1 replacements.

### 2.4 Values in code to promote under G2
**How this was counted.** One pattern pass looked for `limit` above 1, `interval 'N unit'` and `make_interval(... => N)` in schemas `security` and `pipeline`. "Marked" means the function carries `-- fixed:`.

| Class | Functions with literals | Literals | Unmarked functions | Partly marked |
|---|---|---|---|---|
| Workers and decisions | 138 | 242 | 61 | 14 |
| Reports and health | 28 | 89 | 15 | 2 |
| Screen reads (`admin_*`) | 35 | 140 | 30 | 1 |

**Why so many.** The central guard `s32` covers migrations from `20261013012900` on. Most of these functions are older than that, and `security.controls_check_v1()` only looks at running jobs.

**Promote to settings** (operational values: sizes, windows, look-backs). Each one needs a label, range, unit and `used_by`:
- **Onboarding:** `provider_onboarding_step_v1`, 12 literals such as `90 minutes`.
- **Layer 1:** `layer1_plan_finish_v1`, `layer1_run_for_job_v1`, `layer1_seen_departures_v1`, `layer1_run_driver_tick_v1`, `layer1_queue_system_run_v1`, `layer1_auto_ingest_tick_v1` and `layer1_regulatory_scheduler_tick_impl`.
- **Detection, retention and quality:** `zero_yield_detect_v1` (`23 hours`), `retention_tick_v1`, `retention_evidence_candidates_v1` (`7 days`), `data_quality_exceptions_impl` and `data_quality_overview_impl` (`180 days`), `layer2_course_factual_snapshot` (`180 days`), `progress_snapshot_v1` (`90 days`), `course_url_retraction_30d_v1`.
- **Scholarships:** `scholarship_fee_alignment_v1` (`70 minutes`), `scholarship_provider_coverage_refresh_v1` (`30 days`), `scholarship_sweep_apply_v1` (`1 month`), `scholarship_admit_from_provider_page_v1` (`90 days`), `scholarship_scheduler_tick_impl`.
- **Provider tasks:** `provider_task_prepare_v1` (`91 days`), `provider_policy_refresh_plans_v1`.
- **Small caps:** `provider_rule_admit_v1` and `intake_rule_b_qualify_one_v1` (`limit 6`), `course_entry_gate_v1` and `ranking_link_auto_v1` (`limit 3`), `coverage_fetch_area_v1` (`limit 10`), `enrich_plan_orphans_v1` (`limit 50`).

**Mark `-- fixed: <why>`** (claim and lease timers, fire guards and API time-outs, which G2 allows in code):
- the Layer 4 claim lease of `30 minutes` in `layer4_claim_v1_impl`, `layer4_batch_decide_v1_impl`, `layer4_tuition_settle_v1` and `layer4_review_desk_v1_impl`;
- the nonce and fire guards in `svc_pilot_submit_nonce`, `svc_pilot_invoke_scholarship_edge`, `central_ai_fire_v1`, `provider_task_fire_v1`, `enrich_ai_fire_v1`, `firecrawl_runs_tick_v1`, `firecrawl_targets_refresh_v1` and `scholarship_job_items_sync_v1`.

**Leave alone:**
- **Consumer API (G3, frozen):** `zoho_reference_bundle_live_v1` (`limit 8`).
- **AER v1 (Decision 276, frozen):** the `aer_*` v1 functions, which take correctness and security fixes only.
- **Retiring components:** `calendar_default_intakes_apply_v1`, `course_link_reverse_tick_v1` and `onboarding_pilot_snapshot_v1`. They leave by paste file.

**Screen reads and reports.** The `admin_*` reads and the report functions hold display windows ("last 24 hours", "top 10"). They are lower risk. They move as part of each screen's redesign (Phase 3 to 5), not one by one.

**Edge functions.** 15 files hold 26 numeric constants without `-- fixed:`; 147 lines are already marked. Only 5 functions read `svc_worker_settings_v1`.

| Constant(s) | File | Proposed |
|---|---|---|
| `BUDGET_MS` 110 000, `WALL_MS` 95 000, `SCH_V3_TIMEOUT_MS` 90 000, `ADAPTER_CPU_MS` 900 | coverage-sweep | Mark fixed: API and DB time-out safety (under the 120 s worker wait) |
| `OPS_DIAGNOSE_TOKENS_DEFAULT` 800, `COURSE_TEXT_ANSWER_DEFAULT` 1500 | coverage-sweep | Read through `svc_worker_settings_v1`. Check whether a setting already exists (the "AI answer limits" section) |
| `DEFAULT_BATCH` / `MAX_BATCH` / `RPC_CHUNK` / `CONCURRENCY` | layer1-register-etl, layer1-au-depth, layer1-au-cricos-facts, layer1-nz-live, layer1-ca-live | Batch sizes become settings (`batch.layer1_*`); RPC chunk and concurrency are marked fixed |
| `MAX_LINKS` 1500, `MAX_BYTES` 6 MB | evidence-link-index | Settings |
| `SIGNED_URL_TTL_SECONDS` 1800, `SIGNING_CONCURRENCY` 8 | provider-asset-access | Mark fixed (security and lease) |
| `BLOCK_TOLERANCE`, `WRAP_GAP` | fee-schedule-etl/elp.ts | Mark fixed (parser geometry, not operations) |
| `MAX_BYTES` | provider-contact-import, ranking-publisher-import | Mark fixed (upload safety) |
| `PID` 37100278 | statcan-ca-psis-etl | An identifier, not a value. Mark fixed |

## 3. Screen bloat (repo `main` ae9464f8)
- **Screens:**
  - 39 menu entries in `src/nav-map.js`;
  - 69 active and 14 retiring screens in the component register, 12 of the retiring ones due 16–18 Nov (for example the Serper and ScrapingBee cards, and Layer 3 blocks).
- **Tables:** 76 files build their own tables (197 tables). Only `AerSourceManage`, `AerWorkspace` and `mature-main` use `DataTable`. Filtering, sorting, paging, export and column choice differ on each.
- **Data calls:** 88 files call 208 distinct RPCs.
- **Settings are written from five screens:**
  - `PipelineSettings` writes through `admin_pipeline_settings_write`;
  - `SettingsRegister`, `Toolsets`, `AiModelsServices` and `FirecrawlFormatProfiles` write through `admin_toolsets_write`;
  - `SettingsBackup` sits beside them.
- **Layer 4 review spreads over six files:** `Layer4Inbox` (49 KB), Groups, Intervention, ItemLifecycle, `layer4-mass-operations-entry` and `ArchivedReview`.
- **Evidence:** `EvidenceWorkspace` (30 KB) is its own screen with its own table.
- **Largest screens:**

  | File | Size |
  |---|---|
  | `mature-main.jsx` | 182 KB |
  | `layer1-operations-entry.jsx` | 96 KB |
  | `AerWorkspace.jsx` | 74 KB |
  | `AiModelsServices.jsx` | 67 KB |
  | `AdapterBuilderTab.jsx` | 56 KB |
  | `DataDelivery.jsx` | 52 KB |

## 4. Target design
1. **Schema-driven Settings Hub.**
   - **What it is:** one screen built from the settings' own metadata (label, help, kind, range, unit, `used_by`, `control_class`), with search and a "changed by a person" filter. Every change still needs a reason and keeps a backup.
   - **Groups:**
     - **AI & Models:** OpenRouter, model allow-list and AI answer limits.
     - **Schedulers & Cadence:** job sizes, re-reads and retries, rollup and admission runner timing.
     - **Circuit Breakers:** breaker thresholds and back-off, budgets and credit floors.
     - **Consumer APIs:** Website API and Zoho API settings. The group is read-only by default (decided 16 Nov). A change needs an explicit unlock, which is an approved change step. The keys that `svc_website_settings_v1` reads are never renamed (G3).
     - **Pipeline steps:** the step-specific sections (Entry requirements, Provider descriptions and others), folded so that only settings a person has changed show until the group is opened. Approved 16 Nov as the fifth group.
   - **Grouping without renaming:** a new column or mapping table (`hub_group`) sits beside the existing columns, so nothing is renamed.
   - **Replaces:** `SettingsRegister`, `PipelineSettings` and `Toolsets`, plus the limit cards of `AiModelsServices`. Those screens are set to `retiring` in the same change.
2. **Unified Review & Evidence DataGrid.**
   - **What it is:** one grid component (an extension of `DataTable`) with server paging, column choice, CSV export and **Saved Filter Views** (a new table, `pipeline.saved_views`).
   - **Saved views (decided 16 Nov):** both kinds.
     - **Shared default views** for the core queues: `AER Audit Samples`, `Official URLs` and `Provider Blockers`.
     - **Personal views** for each user.
     - **Who sees what:** a shared view is visible to everyone, and only a Platform Admin can change it. A personal view is visible to its owner only.
     - **Views only filter what is shown:** the AER audit sample rate and the Layer 4 URL rules stay unchanged (holds B and F).
   - **Drawer:** a **Source Quote vs Extracted Value** drawer shows the saved page quote beside the value it produced, with the evidence link and the decision history.
   - **Replaces:** Layer4Inbox, Groups, Intervention, ArchivedReview and the EvidenceWorkspace table.
   - **Must keep:** the phone screens guarded by `s121` (Layer 4 Review, Course catalogue list, Course detail blade).
3. **Dispatcher Panels:** one panel per family (Rollups, Admission Rules, Coverage Lanes).
   - **Each target shows:** due next, last result, time against budget, breaker state (`consecutive_failures`, `open_until`), and shadow or live.
   - **Pause:** a target can be paused with a reason; this writes the target's own `enabled` or `mode`.
   - **Replaces:** the one-row-per-job view in Scheduled jobs › Automations for those families.
4. **Inline ✦ AI Enrich popovers.**
   - **What they are:** an Enrich action on an empty field opens a popover with the estimate and the credit left.
   - **Rules:** it runs through `security.on_demand_open_v1` / `on_demand_scope_v1` / `on_demand_close_v1` (CLAUDE.md on-demand rule) and the field's existing admission path. Nothing is written straight to the catalogue.
   - **Contract:** preview before write, set out in §7.2.
5. **Website/Zoho Channel Completeness pills.**
   - **What they are:** on the course and provider screens, a pill per channel shows how many of the fields that channel reads are held.
   - **Source:** they read v2 data only (G3); v3 can be added while it is outside the frozen surface.
   - **Rules:** derived from each channel's contract, set out in §7.4.
6. **Field History drawer** (added 16 Nov): field-level diffs with one-click restore on the Course and Provider detail screens. See §7.3.

## 5. Phased plan (after the PR 1–3 cutovers)
Every phase:
- is one release with its version pill, CHANGELOG and release note;
- updates the Platform guide, SOP and mirror;
- adds its own spec with a `// Guards:` line and regenerates the test register;
- has `-- Replaces:` / `-- Retires:` lines;
- marks the screens it replaces `retiring`;
- drops nothing in a migration (paste files only).

| Phase | When | Work | Guards and checks |
|---|---|---|---|
| 0 | Now | This audit | — |
| 1. Settings hygiene | After the PR 1, 2 and 3 cutovers | Fill `used_by` and `unit` (93 and 82 rows). Retire the 39 Serper/ScrapingBee settings (approved 16 Nov). Retire or hide the 11 settings in §2.3 (approved 16 Nov) once each is confirmed unread by its replacement; a setting still read is re-pointed instead. Both go to `retiring`, with a paste-file drop after 14 days. Merge the overlapping sections (labels only). Add the settings change log with a reason (§7.5) | s32, s42, s57; new spec |
| 2. G2 promotion wave and prompt registry | After Phase 1 | Promote the operational literals in §2.4 family by family: Layer 1, scholarships, retention and quality, provider tasks, small caps. Each function is md5-guarded against its live definition. Mark the technical ones `-- fixed:`. Edge function batch sizes go through `svc_worker_settings_v1`. G3 and AER v1 functions are left alone. Build the prompt registry (§7.1) and move the existing prompts into it in shadow | s32 (extended to the promoted functions), s57; dry run in a rolled-back transaction; registry spec |
| 3. Settings Hub | After Phase 2 | The hub screen with its five groups and the `hub_group` mapping. Settings and prompts render from metadata (§7.5). Old settings screens are set to retiring | Settings spec, s121 untouched, s57 |
| 4. Dispatcher Panels | After Phase 3 (all three cutovers are already done) | Rollups, Admission Rules and Coverage Lanes panels; pause per target with a reason | s547, s548 and the PR 3 spec stay green |
| 5. Review & Evidence DataGrid and History drawer | After Phase 3 | The shared grid, the shared and personal saved views, and the quote/value drawer; move the Layer 4 and Evidence tables onto it. Add the field history log and the History drawer with restore (§7.3) | s121 (phone), Layer 4 specs; B hold: Layer 4 URL rules and the 5% AER audit sample unchanged |
| 6. ✦ Enrich popovers and channel pills | After Phase 5 | The preview-before-write popovers through the on-demand gate (§7.2), using the registry's prompts. Channel pills from the contract rules (§7.4) | s57 (reads only), the website API v2 contract spec, the popover spec |

**Hidden effort and risks:**
- **Grid migration:** 197 hand-built tables, each with its own small behaviours.
- **Consumer-facing settings:** the settings read by `svc_website_settings_v1` must keep their keys (G3).
- **Phone screens:** they must stay usable (s121).
- **Database load:** the hub must page settings from the server, not load 1,489 rows with full help text at once.
- **Audit queries:** keep the bounded-query rule from the 15 Nov incident.

## 6. Decisions (locked by the Platform Admin, 16 Nov 2026 05:12 AEDT)

| # | Question | Decision |
|---|---|---|
| 1 | Serper and ScrapingBee settings | **Retire all 39** in Phase 1. The 11 settings tied to retiring components (§2.3) are retired or hidden in the same phase |
| 2 | Settings Hub groups | **Five groups:** AI & Models, Schedulers & Cadence, Circuit Breakers, Consumer APIs, Pipeline steps |
| 3 | Saved Filter Views | **Both:** shared default views for the core queues (`AER Audit Samples`, `Official URLs`, `Provider Blockers`) plus personal views per user |
| 4 | Consumer APIs group | **Read-only by default.** A change needs an explicit unlock, which is an approved change step |

**Execution order (16 Nov):**
1. PR 1 (#1159) and PR 2 (#1160) keep their scheduled reviews and automatic cutovers: Mon 16 Nov and Tue 17 Nov at 22:30 AEDT.
2. PR 3, the coverage lane dispatcher, comes next.
3. Phase 1 begins once all three cutovers are complete.

## 7. Architectural specs: UnoPim patterns (locked 16 Nov 2026)
Every phase's implementation spec carries the specs below. Each one sits inside the platform's existing rules:
- G2: settings, not numbers in code;
- G3: the consumer API is frozen;
- G4: tests are governed;
- AER v1 is frozen;
- a passing qualification never switches anything on;
- on-demand work goes through the on-demand gate;
- migrations drop nothing.

### 7.1 Decoupled AI platform and variable-driven prompt registry (Phases 2 and 6)
**What it is:**
- **Two layers, kept apart:**
  - **AI platform:** the provider and model configuration (OpenRouter key, credit floor, the allowed models) stays in the `AI & Models` group.
  - **Prompt registry:** field prompt templates live in a separate registry.
- **Each template records:**
  - field code, version and the model it is pinned to;
  - its variables, for example `{{course_name}}`, `{{provider_name}}` and `{{raw_page_markdown}}`;
  - the JSON schema its answer must match.
- **One contract for every caller:** batch workers (`field_execution_registry`, PR 3) and inline UI actions both call the same render-and-validate path. They send the same prompt for the same field and version, and they check the answer against the same schema.

**Implementation rules:**
- **Storage:** a new table beside what exists (working name `pipeline.prompt_templates`).
- **Variables:**
  - Only declared variables may be used.
  - A template with an undeclared or missing variable fails to render.
  - It never sends a prompt with a blank gap.
- **Validation:** an answer that doesn't match the schema is held, the same as a failed check today. It is never admitted.
- **Model pinning:**
  - Each template names one specific, qualified model.
  - "Auto" routing across models isn't allowed, because results must stay traceable to the model that produced them.
  - Provider-level routing controls (such as `require_parameters`) are fine.
- **Activation:**
  - A new template version runs in shadow first.
  - A passing qualification never makes it live by itself; switching it on is its own separate, approved step.
  - Every admitted value records the `prompt_version` it came from.
- **Discovery first:** prompts are held in several places today, for example `cdesc-source-grounded-v2` and the provider description prompt. Phase 2 inventories them before moving them in, and marks the old storage `retiring`.
- **What stays out:**
  - AER v1 prompts stay where they are (Decision 276). AER v2 can adopt the registry.
  - The registry never changes what the consumer API returns.

### 7.2 Preview-before-write inline ✦ AI Enrich (Phase 6)
**What it is:**
- An Enrich action on a Course or Provider form never writes to `catalogue.*` silently.
- It opens one preview popover, the same on every screen. The popover shows:
  - **Extracted Value**;
  - **Verbatim Source Quote**;
  - **Confidence**.
- **Actions:**
  - **Accept & Admit:** admits the value through the field's normal admission path, with `actor` = the admin user plus the `prompt_version`.
  - **Regenerate:** asks again within the same on-demand request.
  - **Discard:** writes nothing to the catalogue. The answer is kept as telemetry.

**Implementation rules:**
- **On-demand gate:** each Enrich opens a request with `security.on_demand_open_v1`, scoped to the field's purpose group. The popover shows the estimate and the credit left. The request is closed when the popover closes.
- **Quote rule:**
  - The quote must be verbatim and found on the saved source page (the same rule as the `quote_not_on_page` check).
  - When it isn't, **Accept & Admit** is disabled and the item can only be sent to Layer 4.
- **Confidence:**
  - The platform has no single confidence score today.
  - The Phase 6 spec defines it from signals that already exist (check verdict, quote found on the page, second-model agreement) and shows how it was worked out.
  - It is a display aid. It never admits a value by itself.
- **Fields under review:** a field with a manual lock or an open Layer 4 item can't be admitted from the popover.
- **What stays the same:** the 5% AER audit sample and the Layer 4 URL rules (holds B and F).

### 7.3 Field-level version history and one-click rollback (Phases 5 and 6)
**What it is:** one **History drawer** on the Course and Provider detail screens. For each field it shows:
- the diff, `old_value → new_value`;
- the `actor`: a `rule_code`, a `prompt_version` or an `admin_user`;
- the timestamp;
- **Restore**, one click.

**Implementation rules:**
- **History store:** a new field history table written by the admission path, beside the catalogue tables and never in their shape (G3). Phase 5 first checks what change history exists today and reuses it where it can.
- **What Restore does:**
  - It is a new change, recorded with a reason, that goes through the admission path.
  - It doesn't edit the row directly, and it respects manual locks and open Layer 4 items.
  - A restored value reaches the website and Zoho like any other admitted value. Only data changes, never the API shape.
- **Gaps:** older changes made before the history table existed show as "no earlier history held". They are not reconstructed.

### 7.4 Channel-scoped completeness rules, Website vs Zoho (Phase 6)
**What it is:**
- The `Website` and `Zoho` readiness pills come from each consumer API's actual contract rules (G3), not from internal flags.
- Each pill links straight to the fields that are missing for that channel.

**Implementation rules:**
- **Contract table:** a new declarative table (working name `pipeline.channel_contract_fields`), built from:
  - the website API v2 contract (`cf-247-website-api-v2-contract.spec.mjs`, `WEBSITE-DEVELOPER-REQUIREMENTS.md`);
  - the Zoho API contract.
- **Each row records:** channel, entity, field, whether the field is required or optional for that channel, and the rule that makes it "held" (for example, "null means not held" and the provider Published switch).
- **Reads only:**
  - Pills read the same data the consumer API reads and change nothing in it.
  - Website v3 rows can be added while v3 is outside the frozen surface.
  - v3 joins the frozen list at go-live (Decision 277).
- **Kept in step:** a spec checks that every field in the contract table exists in the matching contract spec, so the pills can't drift from the real API.

### 7.5 Migration and UI parity for settings and prompts (Phases 1–3)
**What it is:**
- Every `platform_toolset_settings` row and every prompt template can still be managed declaratively by SQL migration.
- Each one also renders automatically in the five-group Settings Hub, with metadata validation and an audited "changed with a reason" log. The Consumer APIs group is read-only there.

**Implementation rules:**
- **Migrations:**
  - A migration may add a setting or template and change its metadata.
  - It doesn't overwrite a value a person has changed unless the migration says so explicitly, with the reason.
- **Validation:**
  - Every row needs a label, range, unit, `used_by` and `hub_group` (templates: variables, schema and pinned model).
  - The central guard `s32` is extended to fail a migration that leaves one out.
  - The Hub refuses to render a row whose metadata is invalid, and flags it instead.
- **Change log:**
  - One audited log (new table, Phase 1) records every change from either path: actor, old value, new value, reason and time.
  - A migration records itself as `migration:<version>`.
  - `pipeline.settings_backups` stays as it is.
- **Consumer APIs group:**
  - A change through the Hub needs the explicit unlock, which is an approved change step.
  - A change by migration needs the `-- Consumer API change approved:` line, the same as G3 requires today.

## 8. Progress
**Order change (Platform Admin, 16 Nov 2026 05:23):** Phases 1–3 and 5 don't wait for the PR 1–3 cutovers. Only Phase 4 (the Dispatcher Panels) does. The Monday and Tuesday 22:30 shadow checks and cutovers are unchanged.

### Phase 1: settings tidy-up (done; Pilot #1163 and #1164, v2.16.5, migration `20261116010000`, applied 15 Nov 2026 18:53 UTC)
- **46 settings retiring.** Each has `control_class` set to `retiring` and a component register row of the new kind `setting`, with `replaced_by` and `retire_after` 29 Nov 2026. They are:
  - the 39 Serper and ScrapingBee settings;
  - from §2.3, `calendar.university_levels`, `batch.course_link_reverse`, `worker.outcome_failed_runs` and `batch.evidence_purge_check`, whose only readers are retiring or which have none;
  - 3 model pins the platform already reports as not read since the AI routes (`entry.matrix_model`, `ops.ai_diagnosis_model`, `firecrawl.builder_model`). These were added to the approved list as the same kind of setting.
- **7 of the 11 re-pointed, not retired.** They are still read by the replacement functions: `calendar.countries`, `alerts.max_attempts`, `alerts.retry_minutes`, `alerts.delivery_enabled`, `intake_dates.name_period_lists`, `intake_dates.deadline_max_days_before` and `batch.calendar_reread`.
- **Metadata filled:** `used_by` for 54 settings and a unit for 61. The Website API and Zoho API settings were left as they are.
- **Sections:** pipeline sections went from 64 to 51 (labels only).
- **Change log (§7.5):** it reuses `pipeline.admin_control_events`, the table the settings screens already write with before, after and reason. A migration's own changes are logged with `action = 'migration'`. No new table was needed.
- **Sample-run notices:** `security.toolset_sample_notices_v1` now returns an empty list. Both its notices were for the dropped services.
- **Paste file:** `docs/paste/PASTE-20261116-retired-settings-drop.sql` runs from 29 Nov 2026. It refuses to run until the retiring functions that read these settings, and the jobs `course-link-reverse` and `worker-outcome-check`, are gone.
- **Checked on production after the change:** the counts above, no setting without `used_by` or a unit, no consumer API drift, and no job failures.

### Phase 2 wave A: G2 promotion (Pilot #1165, v2.16.6, migration `20261116020000`)
- **Nine settings with today's values:** `layer1.reverify_after_days`, `scholarship.scheduler_retry_minutes`, `coverage.link_search_retry_days`, `data_quality.stale_after_days`, `retention.progress_snapshots_days`, `retention.evidence_min_age_days`, `zero_yield.redetect_hours`, `english_policy.replan_minutes` and `retention.audit_columns_per_tick`.
- **Eleven functions read them.** One more function now reads `reread.scholarship_page_days`.
- **How each function is edited:**
  - It is edited in place from its md5-guarded live definition.
  - Each edit must match an exact number of times.
  - Technical values in the same functions are marked `-- fixed:`.
- **Classification:** most literals in §2.4 turned out to be technical, so they are marked rather than promoted. Examples are the run's own correlation window, leases, end-of-month date maths, display list sizes, and a value named by the function itself (`course_url_retraction_30d_v1`).

### Phase 2 wave B: onboarding stage timers (Pilot #1166, v2.16.7, migration `20261116030000`)
- **What changed:** the 11 stage timers written into `security.provider_onboarding_step_v1` (job `provider-onboarding`) became 9 settings with today's values, under Pipeline settings › Onboarding.
- **Accounted for:** all 12 intervals in the function. The one-minute clock tolerance is marked `-- fixed:`.
- **Dry run:** the rolled-back live dry run passed, including a run of `security.provider_onboarding_tick_v1()`.

### Phase 3: Settings Hub (done; Pilot #1167, v2.16.8, migration `20261116040000`, live 15 Nov 2026 20:20 UTC)
- **Groups:** `pipeline.settings_hub_groups` (new) and `security.settings_hub_group_v1` place every setting in one of the five groups. The live count is AI & Models 49, Schedulers & Cadence 217, Circuit Breakers 150, Consumer APIs 26 and Pipeline steps 1,065.
- **Built in place:** Settings › Settings (`SettingsRegister`) became the hub rather than a new screen. That keeps every existing anchor, link and the 14 specs that drive it. No settings screen was retired; the Models & services cards still hold the service settings.
- **On the screen:** the five group headings, Find a setting (name, key, help, used-by), Changed by a person only, and Consumer APIs read-only.
- **Consumer APIs (decision 4):**
  - `admin_toolsets_write` refuses a Website API or Zoho API change without the explicit unlock, and records the refusal (action `refused`).
  - With the unlock, ticked on screen as "Unlock: this is an approved change", the change is saved and the unlock is kept in the change log.
  - This was checked in a rolled-back live dry run as a Platform Admin user.
- **Admin SOP 2.44:** the unlock task.
- **Still open (later, small):** the hub covers the pipeline toolset on Settings. The firecrawl, openrouter, edge_functions and scheduled_jobs settings are already grouped in the table, but they stay on Models & services until that screen is folded in.

### Wave C: prompt registry in shadow (Pilot #1168, v2.16.9, migration `20261116050000`)
- `pipeline.prompt_templates` holds three prompts verbatim, in shadow only:
  - provider_description v4;
  - scholarship_extraction v3;
  - course_description `cdesc-source-grounded-v2`.
- Supporting functions: render, answer check, JSON schema check and a parity report.
- The `prompt_source` drift (v1 named, v2 live) is corrected.
- No reader uses the registry yet.

### AI tab timeout (Pilot #1169 and #1170, v2.16.10 and v2.16.11, migrations `20261116060000` and `20261116070000`)
- **Cause:**
  - The planner pulled a lateral subquery up, so `security.ai_route_v1` ran about 225 times instead of 15. Fixed with an `offset 0` fence.
  - Each route then read the whole OpenRouter balance history. Fixed with an index on `layer3_openrouter_observations (kind, observed_at desc)`.
- **Live:**
  - 5.6–20.7 s before.
  - 491 ms after (16 Nov 2026 08:31 AEDT).
  - Consumer API: no drift (75 functions, 48 relations).
- **Retired model pins:** the 3 retired AI model pins are confirmed unread (only the display read them). They stay retiring and are dropped by the 29 Nov paste file (Platform Admin 08:22).

### Settings tabs and the registry pane (Pilot #1170, v2.16.11)
- Settings › Settings shows one hub group at a time, as tabs. It opens on the settings someone has changed, else the first group.
- Models & services › AI pane 5 is "Prompt registry (shadow)".

### Services at a glance and Settings › Integrations (Pilot #1171, v2.16.12, no migration)
- **Services & limits:**
  - One summary row per outside service (Firecrawl, Direct HTTP, OpenRouter), showing status, switch and the credit or cap left.
  - The Firecrawl and Direct read cards sit in a closed Details fold. A link into a service opens it.
- **Settings › Integrations:** Environment & integrations (keys, platform resources, services overview) is its own tab (Platform Admin 08:22). The Settings tab is the settings only.
- **On the diagnostics:** "Model performance", "Worker health" and "Migration history" are not headings on Settings. The block that matched was Environment & integrations, now moved.

### Next
- **Remaining fixed-only marks:** the Layer 4 claim lease, the nonce and fire guards, and the Layer 1 run windows. These are functions with only technical values. Each gets its `-- fixed:` mark the next time the function is changed for another reason, or in one md5-guarded sweep. Marking alone changes no behaviour, so it isn't urgent.
- **Wave C, prompt registry (§7.1):**
  - **What discovery found:**
    - The AI platform is already decoupled. `pipeline.ai_model_catalogue`, `pipeline.ai_service_routes` (per service: `prompt_source`, caps, `purpose_group`) and `pipeline.ai_route_qualifications` (service, model, prompt version) exist.
    - Prompts live in 3 database tables (`aer_prompt_versions`, `provider_description_prompts`, `scholarship_ai_prompts`), in worker code (11 services) and in one function (`ops_diagnosis`).
    - **Drift:** `ai_service_routes.prompt_source` for `course_description` still names `cdesc-source-grounded-v1`, though v2 is live.
  - **Proposal:**
    - A `pipeline.prompt_templates` table with variables, JSON schema and pinned model, filled from the worker-code prompts verbatim, in shadow.
    - A parity check proves the registry renders exactly the prompt the worker sends.
    - Only then would a worker read from it, as a separate approved step.
    - AER v1 services (`entry_matrices`, `course_entry_requirements`) stay out.
- **Phase 3, Settings Hub:** done (see above). Original plan, kept for the record:
  - **Data:**
    - A new mapping table, `pipeline.settings_hub_groups` (toolset or section to hub group), beside the settings table.
    - A new read, `public.admin_settings_hub_read_v1`, that pages the settings of every toolset by group and section, with search and a "changed by a person" filter.
    - Retiring settings are listed apart. The Consumer APIs group (sections Website API and Zoho API) carries `read_only`.
  - **Writes:** these keep going through `admin_toolsets_write` with a reason. A Consumer APIs change is refused unless an explicit unlock is given, and the refusal is recorded.
  - **Screen:** Settings › Settings becomes the hub. SettingsRegister, PipelineSettings and the Toolsets settings cards are set to retiring in the same change. Models & services keeps its service status panels and links to the hub for limits.
  - **Specs:** a mocked browser spec (five groups, search, read-only consumer group, a reason required). s32, s57 and s121 stay green.
