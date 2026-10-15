# StudySearch – System reference (how it works now)

**Version:** 1.16 (15 Oct 2026; v2.15.280: component register, hygiene check, housekeeping rule (Decision 260); migration 20261015030000)
**Change control:** CF-247
**Rule (Platform Admin, 12 Oct 2026 20:38):** questions about how the platform works are answered from this repository, starting with this page. Every change that alters a mechanism, setting, schedule, stage, stop reason or function updates this page in the same change-control entry and raises its version. The live database is read only for live numbers (counts, balances, progress), which this page does not hold, and to verify a deploy.

Screens: `docs/platform/UI-CATALOGUE.md` (every screen, read from the code); proposed simplification `docs/platform/UI-SIMPLIFICATION-REVIEW.md`. Where else to look first: change history `change-control/00-governance-programme/CF-CHG-20260915-247-…md` (newest entries at the end); scholarships `docs/scholarships/SCHOLARSHIP-MECHANISM.md`; daily duties `docs/sops/`; code in the Pilot repository (`supabase/migrations/`, `supabase/functions/coverage-sweep/index.ts`, `src/`).

---

## 1. Onboarding journey (Layer 2 › Onboarding)

Driven by cron `provider-onboarding` (every minute) → `security.provider_onboarding_tick_v1()` → `security.provider_onboarding_step_v1(id)` per row, run as the Platform Admin in the settings (`run_as`) or the person who started it.

| Stage | Status (result->>'phase') | What happens | Moves on when |
|---|---|---|---|
| 1 Provider in | queued | In the platform from a Layer 1 register, another database or our search; queued (largest first; pilot members priority 300000) | A slot is free (up to `max_active`) |
| 2 Prepare | website, course_pages, waiting_courses | Fill in from website (website, contacts, central pages); course-page search task `course_page_find` (up to 300 courses); university added to Firecrawl targets | At least min(3, courses) pages read |
| 3 Create adapter | capturing, proposing, applying, qualifying | 6 sample pages captured; pinned model proposes settings (twice more with 6 then 10 samples if nothing passes); saved in testing, applied, qualified | Qualified |
| 4 Admit | waiting_admit, or stopped nothing_ready / approve_central | With **auto-admit on** (since 12 Oct 2026 18:02): exactly the passing fields are admitted (`admin_uni_adapter_control('admit')`, logged) at the next check (≤10 min). Nothing passing: central pages AI enqueued; a person decides | Admitted (or central pages approved) |
| 5 Enrich courses | scholarships / enrich | Adapter applied to stored pages; admitted values written by `adapter-overwrite` (every 10 min) | ≥20 min and no value changed for 10 min; records `result.enriched` |
| 6 Scholarship adapter | scholarships / scholarship_search | Task `scholarship_provider_scan` (map, screen, read) — skipped if searched earlier in this onboarding | Task finished |
| 7 Admit scholarships | scholarships / scholarship_admit | AI reads and checks pages; held pages to a person (Scholarships › Extraction) | No page waiting for AI or person (≥15 min), or 7 days → **done** |

- Counting "at once": only website, course_pages, capturing, proposing, applying, qualifying and phase scholarship_search. Waiting stages (Admit, Enrich, Admit scholarships, waiting_courses) are checked every 10 min (waiting_courses hourly) after the working rows; tick limit 250.
- Stage of a row: `security.provider_onboarding_stage_v1(status, stop_reason, result)`.
- Events: `pipeline.provider_onboarding_events` (trigger records status, or the phase for stages 5–7).

### Stop reasons and what carries on by itself

| stop_reason | Carries on by itself when | Otherwise |
|---|---|---|
| no_website | A website is recorded | Enter it (Adapter builder 1.1, Layer 4 › Websites to find) |
| too_few_pages | Enough pages read (≥ min(3, courses)). Stops after the search task is done and ≥90 min, if no page read for 60 min (or 6 h, or nothing pending) | Add pages (Adapter builder 2.1) |
| ai_allowance | Adapter AI allowance renews (midnight Melbourne) | — |
| nothing_ready / approve_central | Admitted by hand, or central pages approved → Enrich | Person (Needs a person) |
| capture_failed, proposal_failed, adapter_off, recipe_off, error | — | Fix, then Retry |

### Admit rule (`security.provider_onboarding_ready_v1`)
A field (intakes, english, fee, delivery) is ready when it passes qualification, is read on ≥5 pages, has ≥3 held values to compare and agrees on ≥90% of them. Qualification: `eval_field_share` 0.5, `qualify_agree_share` 0.9.

### Settings (`pipeline.provider_onboarding_settings`, id 1)
enabled on; auto_start_new on; **max_active 100**; **auto_admit on** (reason: Platform Admin 12 Oct 2026 17:43 "Auto-admit everything that passes"); changed on Layer 2 › Onboarding settings with a reason.

### Pilot (since 12 Oct 2026)
`pipeline.onboarding_pilot` cohort `pilot-2026-10-12`: 60 AU, 25 NZ, 15 CA, baseline per university (`security.provider_fill_counts_v1`). Cohort `au-top-2026-10-12` (v2.15.262, Platform Admin 22:22): the 50 active Australian providers with the most active CRICOS-coded courses (code `^[0-9]{6}[0-9A-Z]$`), queued first with priority 400000 + courses (largest first); queued pilot members with fewer than 30 active courses held at priority -1. The Pilot panel shows the most recently picked cohort; snapshots are taken hourly for every cohort picked in the last 7 days. Hourly snapshot cron `onboarding-pilot-snapshot` (:07) → `pipeline.onboarding_pilot_snapshots`; live `security.onboarding_pilot_report_v1(cohort)`; Pilot panel on Layer 2 › Onboarding.

## 2. Course pages: find and read

| Step | How | Schedule / limits |
|---|---|---|
| Find | Firecrawl search (`{course} site:{domain}`, 5 results; CRICOS code then title), worker mode `link_search`; only Firecrawl target universities while `target_only` is on | `course-link-search` (tick, 20) and `course-link-search-worker` (limit 120) every minute |
| Bind | First candidate bound as the course's page (basis title_search / cricos_search); a wrong page (identity mismatch) or a page failing twice (or 404/410) moves to the next candidate | in the tick |
| Read | Worker mode `read`. **Since v2.15.261 (worker v0.21.3) every course page is read directly first; Firecrawl (rendered rawHtml, basic proxy) reads it only when the direct read is blocked, fails or the page needs a browser**, and **since v2.15.263 (worker v0.21.5) only for pages found by their CRICOS code (cricos_search, cricos_code, cricos_code_on_page), listed on the university's own site (title_match, cms_path_public) or entered by a person (manual)**; pages found by a title or web search are read directly only — v2.15.260 read found pages through Firecrawl first and cost about 23,500 credits in an hour. robots.txt respected for course pages | `coverage-read` every 30 s, 60 a call, **up to 20 per university** (`svc_coverage_read_next`); `coverage-read-2` **paused** (can be resumed on Scheduled jobs › Automations); a page is tried at most 3 times |
| Identify | Code or title on the page, or the university adapter's identity; otherwise identity_mismatch | — |
| Discover (matcher) | Worker mode `discover` | `coverage-discover` (20) and `coverage-discover-2` (8) every minute |

### Firecrawl daily budget (since v2.15.262)
Every Firecrawl spend of the worker goes through `public.svc_fc_spend(units, purpose, provider, url)`: it checks, then records the use in `coverage_vendor_usage`; a refusal is counted in `pipeline.firecrawl_budget_refusals` (day, group, reason) and the call is not made. Settings in section **Daily budget** of the Firecrawl toolset (Platform Admin, reason):

| Setting | Value | Rule |
|---|---|---|
| daily_budget_on | on | Off = observe only |
| daily_budget_total | 15,000 | Billed credits since midnight Melbourne (`security.fc_billed_today_v1`, from the 15-minute balance readings); reached = every purpose waits (reason day_total) |
| daily_share_course_search | 6,000 | Purpose course_link_search (`svc_course_link_search_next` also takes no more than the share left ÷ 2) |
| daily_share_reads | 3,000 | scrape, fc_read, fc_probe, site_hint, adapter_builder, fcx_*; Firecrawl runs (fc_run) stop with reason daily_budget |
| daily_share_scholarships | 3,500 | sch_* |
| daily_share_central | 1,500 | central_map, central_scrape, provider_facts_* |
| daily_share_other | 1,000 | anything else (search, site_verify, map, directory_scrape, …) |
| scholarship_cap_per_uni | 150 | sch_* credits per university **since the later of 30 days ago and when it joined onboarding** (cohort pick or onboarding start, `security.fc_sch_cap_since_v1`, since v2.15.265) (reason university_cap) |
| scholarship_min_courses | 30 | Since v2.15.265: scholarship discovery (site maps, searches, candidate pages, listing pages) only for Australian providers with at least this many active CRICOS courses, and overseas universities (`security.fc_sch_eligible_v1`); scholarships already on record are still read again (reason not_eligible) |
| central_refresh_days | 30 | central pages of a university read again only after this (an earlier central use 6 h – 30 days ago refuses; reason not_due) |
| search_stop_after | 30 | `security.fc_search_stopped_v1()`: ≥30 searches older than an hour in 7 days (since the last Search again, `pipeline.firecrawl_search_resumes`) and no correct page read in that time → search stopped (reason search_stopped; excluded from `svc_course_link_search_next`) |

**Since v2.15.265 (Platform Admin, 13 Oct 2026, credit waste by university):**
- **Directory guard:** `svc_fc_spend` refuses any spend whose page host, or the `site:` of a search (`security.fc_spend_host_v1`), is a directory (`security.third_party_host_v1`, Reference sources with use not_provider_site), whatever the purpose and whether or not the budget is on (reason directory_site). 183 directory course-search recipes (`active = false`, note) and 190 scholarship discovery rows (status `directory_site`) were switched off, not deleted.
- **Refusals by university:** every refusal is also counted in `pipeline.firecrawl_refusals_by_provider` (day, provider, group, reason); `admin_firecrawl_credits` returns `refused_by_uni` (today, up to 100, with tier and held), shown as **Refused today, by university** on Toolsets & limits › Firecrawl credits by university.
- **Search order** (`security.fc_provider_tier_v1`): 0 top-50 cohort, 1 Australian with 30+ active CRICOS courses, 2 overseas, 3 small Australian providers. Used by `svc_course_link_search_next` (tier, then CRICOS stage before title, then priority), `scholarship_discovery_refill_v1`, `svc_scholarship_discover_next` and `svc_scholarship_candidate_next`.
- **Held scholarship work:** `security.fc_sch_held_v1(provider, discovery)` (past the cap, or not eligible for discovery) keeps a university out of `svc_scholarship_candidate_next`, `svc_scholarship_listing_next` and `svc_scholarship_discover_next`; `svc_scholarship_read_next` (scholarships on record) skips only universities past the cap. Refused reads no longer repeat every minute.
- **Search holds:** `pipeline.firecrawl_search_holds` (provider, reason, held_at, set_by) is part of `fc_search_stopped_v1` until a Search again after `held_at`. Held 13 Oct 2026: Victoria University (676 credits for 1 correct page) and Adelaide University (1,048 credits for 23 correct, 219 wrong).
- **Notices:** search held (by name); Australian providers with no official website found; providers sharing a website with another provider. Since v2.15.268 the search held, search stopped and no-website notices carry `items` (provider_id, name, website, and reason or searches), and search stopped counts only universities stopped after searching (not those held).

Groups: `security.fc_purpose_group_v1(purpose)`. Today: `security.fc_budget_status_v1()`. Report: `security.firecrawl_credits_report_v1(hours)` (per university credits by group, fc_ok / fc_wrong / direct_ok course pages read in the window, credits per correct page, flag search_stopped / no_pages / mostly_wrong / scholarships_high), shown on Models & services › Firecrawl credits by university (`admin_firecrawl_credits`; Search again `admin_firecrawl_search_resume`, Platform Admin). Notices (`platform_notices_v1`): a share or the day's total at 80% (warning) or 100% (high); universities with search stopped. Not gated (recorded after the call): adapter sample captures (bounded by 25 builds a day), fc_probe, the extra pages of provider_facts_scrape. Wrong pages: the next stored candidate is tried first, read directly (`course_link_search_tick_v1` step 2), before a new search.

### Finding a provider's official website (worker mode `find_site`, job `coverage-find-site`, every 3 min, 5 a call)
Order (since worker v0.21.6, v2.15.265): 1 the CRICOS register's Website column (Layer 1 import); 2 **training.gov.au** (national register of RTOs, regulated by ASQA): Firecrawl search `"{name}" site:training.gov.au`, the organisation page read through the scraper, the RTO code kept in the evidence; 3 the **TEQSA National Register** the same way; a register page counts only if it shows the provider's CRICOS code or name; its listed website is accepted when the home page shows the CRICOS code (basis `register_*_code`), the address fits the provider's name (`register_*_name`), or it is the only website the register lists and it answers (`register_*_listed`); 4 the CRICOS-code web search (code on the home page, or a name-fitting deeper page; basis `cricos_code`). Directories and registers are never accepted as the provider's site. The basis is kept in `coverage_provider_discovery.site_source` (`search_verified_<basis>`), so which source works best can be counted. A provider with none found shows in the notice "Australian providers have no official website found"; a website entered by hand is never replaced. Spend: group other (search 2 credits, register page 1).

Firecrawl targets (`firecrawl_target_cache`): countries AU/NZ/CA; name contains "university"; AU/NZ ≥100 courses, CA ≥30; excludes college/pathway/…; plus every university onboarding works on (`pipeline.firecrawl_targets`). Firecrawl key settings: read/find credits per run 15,000; run concurrency 12; low-balance warning 10,000. Plan 500,000 credits a month (period starts the 2nd); balance read every 15 min (`firecrawl-credit`).

## 2a. Progress (Coverage & completeness › Progress, since v2.15.266)
- **Read:** `public.admin_progress_read(view, args)`, rank 3+. Views: `overview` (`security.progress_overview_v1(group)` + notices from `platform_notices_v1` for Firecrawl and OpenRouter + the hourly trend), `journeys` (onboarding rows with stage `provider_onboarding_stage_v1`, facts, pages with the AI, whether scholarships were searched, held up by: stop reason, search held, search stopped, scholarship cap; sorted by courses; filters stage, country, find, stop and held: any, person, pages, cap, search, ai, stopped; returns total), `journey` (since v2.15.267: one university's onboarding events grouped into steps by stage with from, to and the last note, with its facts and scholarship counts), `running` (`security.admin_live_activity_v1()` jobs with a journey stage from `security.progress_job_stage_v1(job, area)`, credits and refusals in the last hour), `running_unis` (the universities one job worked on in the last hour: onboarding events, course-link searches, page reads, website finds, scholarship credits and refusals, pages waiting for the AI, published today, central pages, enrichment; since v2.15.267 also central and fee page credits, CRICOS-code matches, scholarship pages read again, the discovery queue and Firecrawl targets; when a job touched none, the universities now at its stage, flagged `fallback`), `levers` (onboarding settings, Firecrawl Daily budget settings and AI guards with what each did today).
- **Groups:** all (every `pipeline.provider_onboarding` row), pilot (`pilot-2026-10-12`), top (`au-top-2026-10-12`); `security.progress_cohort_v1`.
- **Snapshots:** job `progress-snapshot` (hourly at :09, catalogued, `security.progress_snapshot_v1()`): refreshes `pipeline.progress_provider_facts` (each onboarding or cohort university's courses, intakes, English, fee, delivery and scholarships, via `provider_fill_counts_v1`, about 0.6 s) and records one Overview per group in `pipeline.progress_snapshots`; snapshots older than 90 days are removed by the same function. `onboarding-pilot-snapshot` is paused (its Pilot panel is retired).
- **Retired screens:** Live activity (old addresses open Progress › Running now), the Pilot panel on Layer 2 › Onboarding, the Dashboard health strip, Layers and Recent activity, Task manager's Running now.
- **Chat updates:** the hourly pilot updates ended at update 17 (13 Oct, 12:50 pm); summaries at 8 am, 1 pm and 6 pm Melbourne until 14 Oct 6 pm.

## 3. AI and limits

| Use | Model(s) | Daily guard |
|---|---|---|
| Scholarship pages | Qwen3 30B, then GPT-4.1 mini (GPT-4.1 qualified, not in the order) | US$20 |
| Adapter proposals | qwen/qwen3-30b-a3b-instruct-2507 (pinned) | US$5; also the Adapter builder allowance: **1,000 proposals a day** (from 13 Oct, 18:04), US$5 |
| Central pages (English policy, calendar) | GPT-4.1 mini | US$5 |
| Course-page matching | — | US$5 (observed) |

Where it is set (since v2.15.264): **Models & services › AI & OpenRouter** — one read `admin_ai_config_read()`; the OpenRouter key (one secret, OPENROUTER_API_KEY, shared by every profile) is set and verified there through the `layer3-provider-control` edge function (Platform Admin); guards, floor, mode and the adapter proposal model through `admin_toolsets_write`; central pages model and on/off through `admin_ai_config('central_model'|'central_on')` (`pipeline.central_ai_settings`; a scholarship AI model that is not retired); scholarship models (order, qualify, make active) through `admin_scholarship_ai` (same section as Scholarships › Extraction). Course-page matching uses `AI_MATCH_MODEL` fixed in the worker. Model profiles (`pipeline.layer3_model_profiles`, not retired) are listed read-only with prompt version and hash.

OpenRouter: balance read every 15 min (`openrouter-balance`, worker mode `openrouter_balance`); credit floor US$5; enforcement **observe** (notices only; "stop" makes `security.ai_use_allowed_v1` refuse scholarship AI and central pages AI). Spend today: `security.ai_spend_today_v1()`.

## 4. Scheduled jobs that drive admission (all in `pipeline.automation_catalogue`)

provider-onboarding (1 min) · progress-snapshot (hourly :09) · onboarding-pilot-snapshot (paused since v2.15.266) · layer2-onboarding-snapshot (53 */2) · course-link-search, course-link-search-worker (1 min) · coverage-discover, coverage-discover-2 (1 min) · coverage-read (30 s), coverage-read-2 (paused) · adapter-overwrite (10 min) · firecrawl-runs, firecrawl-targets (1 min) · firecrawl-credit (15 min) · firecrawl-panel-figures (5 min) · openrouter-balance (15 min) · central-ai · scholarship-discover (10 min) · scholarship-discover-refill (hourly :23). Scholarship jobs: `docs/scholarships/SCHOLARSHIP-MECHANISM.md` §6.

## 4a. Settings register and the rule against fixed values (since v2.15.269)
- **G2:** no operational value is written into code.
- **The register.** Every job size, re-read and retry time and onboarding rule is a row of toolset `pipeline` in `pipeline.platform_toolset_settings`.
  - It holds 60 settings: 33 job sizes, 19 re-read and retry times and 8 onboarding rules.
  - Each has a range, a unit and a `used_by` line.
  - Code reads it with `security.pipeline_num_v1(key, default)`. Every default is the value used before 13 Oct 2026.
- **Jobs.** Every scheduled job passes its size as a setting call (31 jobs converted in migration 12900).
  - The Automations batch box changes the setting.
  - Pipeline settings rows (matcher, searches, reads) change it too, through `admin_pipeline_settings_write`.
- **Worker.** It reads the Firecrawl proxy, site map sizes and search result counts through `svc_worker_settings_v1`. These are 10 Firecrawl settings, including `search_stop_window_days`. The proxy is used by every Firecrawl read.
- **Policy tables.** These are edited on Pipeline settings through `admin_policy_tables_read` and `admin_policy_tables_write`, with a reason, logged in `admin_control_events` area `policies`.
  - Capacity thresholds and evidence storage thresholds.
  - Retention days and delete limits.
  - Provider fee profiles and basis rules: active and review date.
  - The allowed columns are listed in `security.policy_columns_v1()`.
- **Guards.**
  - `security.controls_check_v1()` lists running jobs with a number written into them. It shows on Pipeline settings and raises the notice `pipeline:0:fixed_value:<job>`.
  - Test S32 fails any migration from 12900 on that writes a number into a job, or a day, hour, week or month interval or a limit of 100 or more into a non-screen function, unless the line is marked `-- fixed: <why>`.
  - The repo `CLAUDE.md` states G1 and G2.
- **Kept in code on purpose:** lease and claim timers (minutes), fire guards, the Firecrawl month roll-over, API time-outs, and the pinned AI models.
- **Not controls:** `scholarship_ai_settings` (old scholarship AI runs), `acquisition_policies` (read only by reset functions) and `admission_lifecycle_policy` (its job is not scheduled). These run nothing today.
- **Unused:** `publication_control_settings` and `scholarship_runtime_settings` are read by nothing. A paste file retires them.

## 4b. Website API v2 (Wix consumer, since 8 Oct 2026)

- **Endpoint and contract.** Edge function `wix-course-api` (`verify_jwt` off, own key check; source md5 29864613, 15 Oct 2026). A request with `"contract": "website-search-v2"` reaches the v2 actions; without it the v1 path (`wix-cache-v1`) answers the Wix key only. Keys: `private.website_integration_credentials` (sha256 only); `public.website_edge_identity_v1(sha256)` → `api.website_integration_identity_v1` returns the credential name of an enabled key. Keys now: `coursefinder_website_wix_pilot_v1` (Wix, v1 and v2), `coursefinder_website_developer_pilot_v1` (developer, v2 only, 15 Oct 2026); a temporary verification key was disabled the same day. Rate limit: `zoho_edge_rate_check_v1`, 60 a minute per action (`v2:<action>`) per identity (the Wix key keeps identity `coursefinder_wix_pilot_v1`; other keys use their credential name). A key is never in git or documents; a new key is a row added directly and handed over once.
- **One path (Platform Admin, 15 Oct 2026).** v2 is the website's only path. The v1 path and edge function `website-course-api` are marked for retirement once the developer is live on v2 (register, "One path for the website"); nothing removed yet.
- **Actions → database functions** (all `public`, security definer, search path pinned, execute for service_role only): reference → `website_v2_reference()`; search → `website_v2_course_search(filters, page, page_size, sort)`; course → `website_v2_course(identifier)`; providers → `website_v2_providers(filters, page, page_size, sort)`; provider → `website_v2_provider(provider_id)`; rankings → `website_v2_rankings(filters, page, page_size)`; scholarships → `website_v2_scholarships(filters, page, page_size)`; scholarship → `website_v2_scholarship(scholarship_id)`. sync → `website_v2_sync(cursor, full_load, entities, page_size)` (v2.15.277). Helpers are in `api.website_v2_*` (public execute revoked).
- **What is returned.** Courses come from `search.course_documents`, minus `security.layer4_search_blocked_courses` (inactive courses and every course of a hidden provider). Providers hidden by `security.provider_hidden_v1` (not published or not active) are left out of every action with their campuses and scholarships. Scholarships are published and active only, always. The provider Published switch is the Platform Admin's control: switched off, the provider and its courses are not returned to any API query. A returned course reads `publication_status: published` (follows its provider). Country and per-source gates for the projection: `search.projection_country_gates` (AU, NZ, CA approved) and `search.enrichment_source_gates`.
- **Course codes.** `course_code` is the source value. `display_code` / `display_code_kind` / `display_code_label` come from `security.course_display_code_v1` (Decision 255): the printed code, else the StudySearch code. The course action also finds a course by its StudySearch code.
- **Tuition.** Provider current fee first, else the CRICOS registered total; amounts under 1,000 are placeholders and not held; basis always stated; annual derived from a total only for courses of 12 months or more; no currency conversion.
- **QILT.** Gate `search.enrichment_gates` courses/provider_outcomes (approved 14 Oct 2026) releases QILT rows of `catalogue.provider_outcomes` (provider grain, status current, surveys `qilt_*`) on provider and course detail. The course-grain gate courses/qilt stays blocked.
- **Institution type.** `institution_type {code, name, basis}` on every provider (list and detail) and on the provider of every course; filter `institution_types` on search and providers (a course matches through its provider, `api.website_v2_institution_type_code`); `reference` lists the active types with published provider counts. null when not held (section 4c).
- **Campuses and regions (O1, 14 Oct 2026).** `campuses[]` and the city filter read `catalogue.course_campuses` and `catalogue.campuses` live. Australia: CRICOS locations. New Zealand (168) and Canada (78): campuses made by Enrich fields from the providers' own course pages (`stable_key` `campus:studysearch:…`); city where the page names one, postcode mostly null, metro area and regional category Australia only. A New Zealand campus carries the provider's region only when it is in the provider's own city (`primary_city`); otherwise null (132 cleared, old values in `pipeline.campus_region_cleared`). A Canadian campus carries the province. `security.enrich_campus_list_apply_v1` applies the same rule to new campuses.
- **Projection refresh.** Study area, study level, course regions (`subdivision_codes`, the state filter) and delivery modes come from `search.course_documents`, refreshed by `search-refresh-requested` (every 10 minutes) only when a row is in `search.refresh_requests`. An Enrich fields task requests one when it finishes (`security.enrich_fields_slice_v1`). Delivery modes are the campus links' modes, else the course's own mode (`search.refresh_course_base_v3`). Duration and campuses are read live.
- **Logos and rankings.** Logos leave the private `provider-assets` bucket only as signed links made by the edge function (`storage_path` is removed), valid `website.logo_link_days` (365) read through `public.svc_website_settings_v1()`. `terms_status` comes from `security.website_terms_status_v1(kind)`: `approved` while the Yes/No settings `website.rankings_display_approved` / `website.logos_display_approved` are Yes (Platform Admin decision 14 Oct 2026), otherwise `management_decision_pending`.
- **Sync (v2.15.277).** `pipeline.website_sync_items` holds one row per item the API returns (entities reference, provider, logo, rankings, scholarship, course; course is the search item), with the md5 of the item as built (`security.website_sync_item_v1`, `generated_at` left out) and a sequence number. Job `website-sync-check` (every minute, catalogued, size `batch.website_sync_check` 600; a provider counts 8, reference 200) walks the entities in a rolling pass (`pipeline.website_sync_scan`, one pass about 90 minutes): a new, changed or removed item takes the next number; a logo also does when `seq_at` is older than its link life less `website.logo_renew_before_days`. `website_v2_sync` pages rows by number: no cursor = full load of the items numbered up to now; the cursor (base64 JSON v, m, a, s, e) then returns rows numbered after it, removals included; `checked_through` is null until every chosen entity has finished a pass. Page size at most `website.sync_page_max` (50).
- **Reference cache (15 Oct 2026).** `website_v2_reference()` returns the copy in `pipeline.website_reference_cache` (id 1, with `built_at` as `generated_at`), built by `api.website_v2_reference_build()` (the former body, 5.5–6.6 s) through `security.website_reference_cache_refresh_v1()`; job `website-reference-cache` every 15 minutes (catalogued, Search and API). With no copy it builds live.
- **Sync pages by cost (15 Oct 2026).** A page is filled by build cost against the page size: provider 16, scholarship 2, others 1, so a page holds 3 provider details; the first row is always taken. `has_more` is true when fewer rows than chosen were sent. Provider detail is slow (it builds the providers list for one provider): register O8.
- **Developer document.** `docs/integrations/developer-pack/` (guide master .md, Word, PDF, OpenAPI, Postman; `build.sh` rebuilds). The Version 2 handover is internal history (router `docs/integrations/README.md`).
- **Measured 14 Oct 2026 (warm, database time).** Filtered search 0.1–0.6 s; whole-country tuition sort about 2 s; course detail under 0.1 s; scholarships 50 a page 0.2–0.5 s; providers 50 a page about 1.5 s; reference 2–4 s to build, under 0.1 s from the copy (15 Oct). The first call after a quiet period takes 2–4 s.

## 4c. Institution type (Decision 258, since 14 Oct 2026)

- **Types** (`ref.provider_types`, active): university, university_college, higher_education_institute, tafe_polytechnic, private_vet, school, wananga, other. `tafe` and `college` are retired (kept). The type is `catalogue.providers.provider_type_id`, with `provider_type_basis` (the rule label, "Set by a person", or "No rule matched: …" with the facts seen) and `provider_type_set_at`.
- **Register facts.** `catalogue.provider_register_facts (provider_id, fact_code, value, source_id, evidence_id, observed_at)`: `teqsa_category`, `teqsa_status`, `teqsa_provider_id` (TEQSA National Register), `cricos_institution_type` (Government / Private), `nzqa_org_type` (UNI, POLLY, WANA, PTE, GTE). Written by `public.svc_provider_register_facts_put(source, evidence, scheme, rows)` (service role, one statement): a row's codes match `catalogue.provider_registrations` in the scheme, else the stable key; only when a code matches nothing, the listed name (`security.register_name_key_v1`, a question mark is any one letter) among that register's providers, and only when every listed row with that name has the same facts. The NZQA register applier (`svc_layer1_apply_register_records`) also writes `nzqa_org_type` when it applies.
- **Rules.** `pipeline.provider_type_rules` (ordered by position; first enabled match wins; text fields are case-insensitive patterns; `course_profile` vet / school_no_vet / non_aqf_only from `security.provider_course_profile_v1`, active courses and `ref.study_levels`). Seeded order: 10 TEQSA Australian University (Active) → university; 20 CRICOS Government + VET → tafe_polytechnic; 30 TEQSA University College → university_college; 40 TEQSA Institute of Higher Education → higher_education_institute; 50 CRICOS + school courses only → school; 60 CRICOS Private + VET → private_vet; 70 CRICOS + non-AQF only → other; 110–150 NZQA UNI / POLLY / WANA / PTE / GTE → university / tafe_polytechnic / wananga / private_vet / other. Canada has no rules. Changed on Settings › Pipeline settings › Institution type rules (`admin_provider_type_rules`: list any role; save and run Platform Admin; each change logged in `pipeline.manual_edit_log` and the rules run at once).
- **Classifier.** `security.provider_type_classify_v1()` (set-based; skips providers with a manual lock on `provider_type_id`). Runs daily (`provider-type-classify`, 03:47 UTC, catalogued, area Layer 1 register) and after every register read. `public.svc_provider_type_classify()` for the service role.
- **By hand.** Providers › Type column; `admin_provider_set_type(provider, code)` PIM Admin and above, no reason asked: a type adds a manual lock and is kept; `auto` removes the lock and reruns the rules.
- **Layer 1 sources** (source_system `PROVIDER_FACTS`, read by edge function `layer1-provider-facts` v1.3.0, service key or one-time nonce, approved hosts only, file kept as evidence by hash): TEQSA National Register providers file (data.gov.au CKAN package `0c4f6591-…`, resource `providers_<date>.csv`, key column CRICOS Registration, several codes per row allowed, an Active row wins); CRICOS Institutions.csv (data.gov.au package `cricos`); NZQA provider search per organisation type (`nzqa.govt.nz`; the search number is the NZQA number followed by a five-digit site number, `code_from_id`). Verified and applied through `layer1-operations-control` v1.9.0 and `layer1-operations-scheduled` v1.5.0; cadence 7 days, applied when the file changes (settings on Layer 1 › Sources).
- **First live read (14 Oct 2026).** TEQSA 200 codes from 272 rows (78 rows have no CRICOS code), 200 matched; CRICOS Institutions 1,542 of 1,545 matched; NZQA 415 of 415 by number. Providers with courses: Australia 1,541 of 1,546 typed, New Zealand 287 of 287, Canada 0 of 52.

## 4d. Waste rules, focus providers and central pages (v2.15.278 and v2.15.279, 15 Oct 2026)

Platform Admin, 15 Oct 2026 09:18: "If we are wasting resources on multiple tries then tighten rules around it, recording, flagging and moving on." Settings: Pipeline settings › Waste rules and › Admission checks.

- **Records.** `pipeline.enrichment_flags` holds what a rule stopped and why (`reason_code`: idle_paused, flip_flop, outside_focus, page_not_found, fee_crosscheck, adapter_fee_fails_check, policy_disagrees); `cleared_at` is set when it no longer applies. Notices: a paused job, and the count of frozen values.
- **Idle jobs.** Job `waste-guard` (hourly at :17) runs `security.waste_guard_v1()`: for each job in `pipeline.job_idle_watch` (output and waiting-work queries), a job with no output for `waste.idle_pause_hours` (24) and nothing waiting is paused (`cron.alter_job` active false) and flagged; a job it paused is switched on again when work waits. Watched: course-link-reverse (paused 15 Oct; last page read 30 Sep, 2 courses bound ever).
- **Admit jobs on new input.** coverage-admit, coverage-admit-intakes and adapter-overwrite call `security.coverage_admission_gated_v1` / `security.adapter_overwrite_gated_v1`: they skip unless `security.admit_input_mark_v1()` (newest page read, adapter change, validated value, exclusion, lock, review decision, course or provider change) moved since their last run, the last run filled its batch, or `waste.admit_full_check_hours` (6) passed. `pipeline.job_input_marks` keeps the marks and run counts. A run went from about 53 s to 0.9 s when skipped.
- **Retry cap by yield.** `security.retry_cap_v1('ai_match')`: AI course-page matching makes attempt k only while attempt k found a page in at least `waste.retry_min_yield_pct` (15%) of cases in the last `waste.retry_window_days` (14), with at least `waste.retry_min_sample` (200) cases, up to `waste.retry_max_attempts` (3). On 15 Oct: 2 (attempt 2 17%, attempt 3 9%). Courses past the cap are flagged page_not_found.
- **Flip-flops.** Exit awards no longer overwrite a delivery, intake or fee the course's own page gives (`security.own_page_value_v1`). `security.waste_flipflop_guard_v1()` freezes a course value changed automatically more than `waste.flipflop_max_changes` (3) in `waste.flipflop_window_days` (7) through the adapter exclusions and flags it (counting from 15 Oct). The admission job does not raise a review item identical to one superseded within the window.
- **Stored pages.** `svc_scholarship_ai_next` uses a copy of the same page stored within `waste.page_reuse_hours` (24), for a candidate too.
- **Focus providers.** `pipeline.enrich_focus_providers` ranks Australian providers by missing English plus intakes (`security.enrich_focus_refresh_v1`, job `enrich-focus-refresh` weekly); `in_focus` = top `enrich.focus_top_n` (50). Course-page search (`svc_course_link_search_next`), site mapping (`svc_coverage_discovery_next`) and AI page matching (`coverage_ai_match_prepare_v1`) take Australian providers only when `security.enrich_focus_v1` is true (New Zealand and Canada unlimited; 0 = all). Other Australian courses lacking a page, English or intakes are flagged outside_focus (register data only).
- **Firecrawl.** `firecrawl_panel_refresh_v1` takes the target-refresh lock, so the two no longer deadlock.
- **Fees (v2.15.279).** Wollongong, Tasmania, TAFE NSW and Notre Dame adapters admit fee (fee only for the last two). Before adapter-overwrite runs, `security.fee_crosscheck_guard_v1()` holds back (adapter exclusion) and flags an adapter fee not yet held whose annual amount times the course years is more than `admit.fee_crosscheck_pct` (25%) from the CRICOS registered course total. Victoria University, Academies Australasia and Torrens flagged adapter_fee_fails_check.
- **Central pages (v2.15.279).** The focus providers' English policies and calendars are read with the pinned central AI model (worker v0.24.0 also asks for the research-degree requirement). Job `policy-auto-approve` (every 10 minutes) runs `security.policy_auto_approve_v1()`: with `central.auto_approve` Yes, an AI proposal of a focus provider is approved (decided_by null, note "Automatic: …") unless, for English, at least `central.min_compare` (10) courses show their own score and more than `central.max_disagree_pct` (50%) disagree (then flagged policy_disagrees for a person). The recorder (`svc_central_ai_record`) still never approves. University calendars still answer only semester names on course pages (Decision 241 unchanged).
- **English plan.** `provider_english_plan_v1`: a double degree whose awards are all at the course's level takes that level's default (`security.double_degree_same_group_v1`); research masters and doctorates take a `research` default only where the policy states one; other Decision 227 holds stay. The applied note says whether the policy was approved by a person or automatically.

## 4e. Housekeeping: component register and hygiene check (Decision 260, v2.15.280, 15 Oct 2026)

How the platform stays streamlined: `docs/platform/DATA-PIPELINE-OPERATING-MODEL.md` §6. Settings: Pipeline settings › Housekeeping.

- **Register.** `pipeline.component_register` (kind job, table, view, edge_function, screen; name; layer; area; purpose; status active, retiring or retired; replaces, replaced_by; introduced_in; retire_after; last_used_at; usage; size). `security.component_register_sync_v1()` brings jobs (purpose from the job catalogue), tables and views (purpose from `comment on table`, size) up to date; what no longer exists is marked retired, never removed. Layer from the job area or the name (`security.component_layer_v1`).
- **Repository side.** GitHub workflow "Component register" (daily 21:40 UTC, and on demand): `scripts/component-register-collect.mjs` lists the edge functions (`supabase/functions`) and screens (`src/nav-map.js` pages and tabs) and reads edge function calls for the last 24 hours from the Supabase logs endpoint; `security.component_register_ingest_v1(payload)` records them; the generated document (`security.component_register_markdown_v1()`) is committed to the branch `component-register-snapshot` and copied to `docs/platform/COMPONENT-REGISTER.md` here with change-control entries.
- **Hygiene check.** Job `hygiene-check` (Sundays 16:23 UTC = Monday morning Melbourne) runs `security.hygiene_check_v1()`: records counters in `pipeline.component_usage_snapshots` (table reads and writes, index scans); compares with the snapshot at least `hygiene.idle_days` (14) old; lists unused tables, indexes and edge functions, uncatalogued jobs, switched-off jobs, tables without row-level security, definer functions without a pinned search path, public definer functions open to anonymous callers, tables without a purpose, and retiring components past `retire_after` (ready to drop). Result in `pipeline.hygiene_reports`; notice "Housekeeping" while it finds something.
- **Build rule.** `tests/uat/cf-247-s42-housekeeping-contract.spec.mjs`: migrations from 20261015030000 have `-- Replaces:` and `-- Retires:` lines, a `comment on table` for each new table, a catalogue row for each new job, and no drop or delete outside function bodies.
- **First check (15 Oct 2026).** Registered: 102 jobs, 450 tables, 24 views, 80 edge functions (11 called in the last day), 63 screens. 39 tables without row-level security; 420 tables without a stated purpose; definer functions all have a search path; no public function open to anonymous callers. Unused-component findings start once 14 days of snapshots exist.

## 5. Live function checksums (md5 of pg_get_functiondef without \r), as last deployed

| Function | md5 | Since |
|---|---|---|
| security.platform_notices_v1() | 81bf986b… | 20261015030000 (replaces 7580ed33 of 20261015010000) |
| security.component_register_sync_v1() / component_register_ingest_v1(jsonb) / hygiene_check_v1() / component_register_markdown_v1() / component_layer_v1(text, text, text) | 62c2396a… / 8ffd7d6a… / 2499ec0f… / cf4963c2… / 2ba39fa3… | 20261015030000 |
| security.coverage_admission_apply_v1(integer, text, text[]) | 9667b916… | 20261015010000 (replaces c5ce945a) |
| security.coverage_ai_match_prepare_v1(integer, integer) | 01ad8260… | 20261015010000 (replaces 744dda6c) |
| public.svc_course_link_search_next(integer) | 8b6c6f82… | 20261015010000 (replaces 2c4d4055) |
| public.svc_coverage_discovery_next(integer) | d7a00f49… | 20261015010000 (replaces 7d6ae2fa) |
| security.exit_awards_apply_v2(uuid) | 8d4e5f7b… | 20261015010000 (replaces 53c4064a) |
| security.firecrawl_panel_refresh_v1() | 098c8d6d… | 20261015010000 (replaces 89ce4d05) |
| public.svc_scholarship_ai_next(integer) | 11de2cc8… | 20261015010000 (replaces 3f1c5858) |
| security.waste_guard_v1() / waste_idle_guard_v1() / waste_flipflop_guard_v1() / enrichment_flags_refresh_v1() | 101d6fbf… / 2fff04de… / 2de1d43b… / 2044836d… | 20261015010000 |
| security.retry_cap_v1(text) / enrich_focus_v1(uuid) / enrich_focus_refresh_v1() / own_page_value_v1(uuid, text) / admit_input_mark_v1() | 56e6d020… / 73e1bcfd… / 0588c931… / 540051c7… / 8a282bf1… | 20261015010000 |
| security.coverage_admission_gated_v1(text, integer, text, text[]) | 4e4e7f9a… | 20261015010000 |
| security.adapter_overwrite_gated_v1(integer) | ef72b386… | 20261015020000 (replaces 62780a64 of 20261015010000) |
| security.provider_english_plan_v1(uuid) | 6f331c06… | 20261015020000 (replaces a14d3730) |
| security.provider_english_apply_v1(uuid) | 760c173d… | 20261015020000 (replaces af9a96c9) |
| security.double_degree_same_group_v1(text, text) / fee_crosscheck_guard_v1() / policy_auto_approve_v1() | b797d4e1… / d15c6fc5… / ebf52656… | 20261015020000 |
| public.website_v2_course(text) | ad9ba388… | 20261014040646 (replaces 9872c3ef, a22d40c8) |
| public.website_v2_provider(text) | 2411c7e4… | 20261014040646 (replaces 70ccdc9b) |
| api.website_v2_course_item(uuid, text[], text[]) | 15129314… | 20261014060746 (replaces c9fcc242, 600bc47a) |
| public.website_v2_course_search(jsonb, integer, integer, text) | dcefed12… | 20261014060746 (replaces 19b602f5) |
| public.website_v2_providers(jsonb, integer, integer, text) | 73ba533e… | 20261014060746 (replaces 2d4d1909) |
| public.website_v2_rankings(jsonb, integer, integer) | 9c5f725e… | 20261014110000 (replaces 9a9e9598) |
| public.website_v2_reference() | 4f3bc6db… | 20261015000200 (replaces 28ea2093) |
| api.website_v2_reference_build() | a3d1dfa9… | 20261015000200 |
| security.website_reference_cache_refresh_v1() | 6286e941… | 20261015000200 |
| public.website_edge_identity_v1(text) | e26ead8c… | 20261015000100 |
| api.website_integration_identity_v1(text) | a0c8147c… | 20261015000100 |
| api.website_v2_institution_type(uuid) | 42563a41… | 20261014060746 |
| api.website_v2_institution_type_code(uuid) | 1541a9c8… | 20261014060746 |
| api.website_v2_provider_logo(uuid) | ed09e7d2… | 20261014110000 (replaces 37fe1dcd) |
| api.website_v2_ranking_summary(uuid) | 889a4c7f… | 20261014110000 (replaces 5e5b2d19) |
| public.website_v2_provider_rankings(uuid) | 173e3a9f… | 20261014110000 (replaces 4b50d415) |
| public.website_v2_sync(text, boolean, text[], integer) | 42b7597b… | 20261015000400 (replaces 70890025 of 20261015000300, 92414ce7) |
| security.website_sync_check_v1(integer) | 2a8d3e59… | 20261014110000 |
| security.website_sync_item_v1(text, uuid, text) | cd15a2cb… | 20261014110000 |
| security.website_terms_status_v1(text) | 9e92654c… | 20261014110000 |
| search.refresh_course_base_v3(boolean) | a3737e58… | 20261014090000 (replaces bbb65ede) |
| security.enrich_campus_list_apply_v1(bigint) | 2617420b… | 20261014090000 (replaces adecd776) |
| security.enrich_fields_slice_v1(uuid, integer) | 03cc5526… | 20261014090000 (replaces aa68e9a8) |
| security.admin_providers_page(…10 args) | bb66c64c… | 20261014060746 (replaces 4d07ec59) |
| public.svc_layer1_apply_register_records(text, uuid, uuid, text, jsonb) | d8e3ed69… | 20261014060746 (replaces 081d6a57) |
| security.provider_type_classify_v1() | 06e35dec… | 20261014060746 |
| security.provider_course_profile_v1(uuid) | d7362f92… | 20261014060746 |
| public.svc_provider_register_facts_put(uuid, uuid, text, jsonb) | 97519fab… | 20261014070327 (replaces 7f33287c, 72017d2b, d1b4e3b2) |
| security.register_name_key_v1(text) | 2e8b1d5f… | 20261014070327 |
| public.admin_provider_set_type(uuid, text) | 9d515548… | 20261014060746 |
| public.admin_provider_type_rules(text, jsonb) | efcbd576… | 20261014060746 |
| public.website_v2_scholarships(jsonb, integer, integer) | b3a616d8… | 7100 |
| public.website_v2_scholarship(text) | 79131c22… | 7100 |
| api.website_v2_scholarship_item(uuid) | d1792cc7… | 8400 |
| security.provider_onboarding_step_v1(uuid) | 85977406… | 12900 (replaces 1ce3f7b6) |
| security.provider_onboarding_tick_v1() | 924761ef… | 12900 (replaces 5196a85f) |
| security.provider_onboarding_event_v1() | a3e685cd… | 11500 |
| public.admin_provider_onboarding(text, jsonb) | dcec0b55… | 11600 |
| public.svc_coverage_read_next(integer) | 2e177089… | 11700 |
| security.scholarship_ai_fire_v1() | 0a432552… | 11400 |
| security.central_ai_fire_v1() | 0a6dba98… | 11400 |
| public.admin_toolsets_read() | c54f956c… | 12900 (replaces 75ed6d4d) |
| public.svc_course_link_search_next(integer) | 2c4d4055… | 12200 (replaces 6867d7ed) |
| security.platform_notices_v1() | eb994869… | 12900 (replaces 08076626) |
| public.svc_fc_spend(numeric, text, uuid, text) | b49dd1f2… | 12200 (replaces d6c215dd) |
| security.fc_search_stopped_v1() | 672e614c… | 12900 (replaces 52f4f34e) |
| public.admin_pipeline_settings_read() / _write(text, jsonb) | 6a192ef1… / 47491f59… | 12900 |
| security.automation_batch(text) / admin_automation_control_v1(text, text, jsonb) | fe2d14f9… / 8d5a6f10… | 12900 |
| svc_coverage_read_record / discovery_record / site_next / site_record | e0437f03… / ff0454e1… / bdac9ab9… / aa8a8565… | 12900 |
| svc_scholarship_read_record / candidate_record / listing_record / ai_record | ece91393… / 2bfb43c3… / a72f798f… / b047f8d2… | 12900 |
| svc_provider_facts_search_next / read_next, svc_cricos_peo_next | 14c68d37… / 5125d179… / 9b7675ad… | 12900 |
| security.scholarship_discovery_refill_v1(integer) | ef694f93… | 12200 (replaces db4f9875) |
| public.svc_scholarship_discover_next(integer) | e95b75ee… | 12200 (replaces cf7cd3c0) |
| public.svc_scholarship_candidate_next(integer) | 5034833c… | 12200 (replaces e712f443) |
| public.svc_scholarship_listing_next(integer) | f8184295… | 12200 (replaces 133c192d) |
| public.svc_scholarship_read_next(integer) | 89879c6d… | 12200 (replaces bd0b48fc) |
| public.admin_firecrawl_credits(integer) | 21ae40b4… | 12400 (replaces 356e6842) |
| public.admin_progress_read(text, jsonb) | e526fbba… | 12700 (12600 was 16ff4919, 12500 79d2c159) |
| security.progress_overview_v1(text) | c2d80cb0… | 12500 |
| security.progress_snapshot_v1() | d2b01fca… | 12500 |
| security.progress_job_stage_v1(text, text) | 5c919602… | 12500 |
| security.progress_cohort_v1(text) | 089db028… | 12500 |

Worker: coverage-sweep v0.21.7, deployed version 151 (Firecrawl proxy, map sizes and search results from settings; every Firecrawl spend through svc_fc_spend; Firecrawl reads only trusted page bases; official websites from training.gov.au and TEQSA first). App: v2.15.267 / 0.1.194. Firecrawl read proxy: basic (setting firecrawl.read_proxy; every worker scrape sends proxy basic).

## 6. How a change is made (for the next change)
Migration generated with guard blocks (live md5 must equal the definition replaced) and post-checks; plpgsql syntax-checked on a local PostgreSQL 16; applied through the `db-apply-migration` workflow from the branch (worker first through `deploy-edge-functions` when both change); anything that drops or deletes goes to the Platform Admin as a paste file. Release: bump release manifest, guide and SOP review versions, package.json, CHANGELOG, persistence-contract test; regenerate `docs/sops`; full local suite; PR, squash merge; record the entry identically in the four CF-247 files; update this page.

## Version history
| Version | Date | Change |
|---|---|---|
| 1.0 | 12 Oct 2026 | First issue (v2.15.260): onboarding journey, stop reasons, admit rule, settings, pilot, course-page find and read, AI limits, jobs, function checksums, change method. |
| 1.1 | 12 Oct 2026 | v2.15.261: found pages read directly first, Firecrawl only as fallback, basic proxy; second reader paused. |
| 1.16 | 15 Oct 2026 | Section 4e: component register, daily register workflow, weekly hygiene check, housekeeping build rule (Decision 260); checksums. |
| 1.15 | 15 Oct 2026 | Section 4d: waste rules (idle jobs, admit on new input, retry cap by yield, flip-flops, stored pages, focus providers, records), fee cross-check, central pages approved automatically when checked, English plan double degrees and research defaults; checksums. |
| 1.14 | 15 Oct 2026 | Section 4b: keys by identity (developer key, v2 only), one path with v1 marked for retirement, reference cache, sync pages by cost, developer pack; checksums. |
| 1.13 | 14 Oct 2026 | v2.15.277 (section 4b): sync action and change check, display terms from settings (approved), logo links 365 days; checksums. |
| 1.12 | 14 Oct 2026 | Website requirements O1 (section 4b): campuses and regions for New Zealand and Canada, New Zealand regions only where proven, projection refreshed when an Enrich fields task finishes, course delivery mode as fallback; checksums. |
| 1.11 | 14 Oct 2026 | v2.15.276, Decision 258: institution type (section 4c): types, register facts, ordered rules, classifier and daily job, three Layer 1 sources (TEQSA, CRICOS Institutions, NZQA search), Providers Type column, website API v2 field, filter and reference list; checksums. |
| 1.10 | 14 Oct 2026 | Website API v2 (section 4b): actions, provider Published switch as the API control, display codes, QILT at provider grain, tuition, logos, timings; v2 checksums. |
| 1.9 | 13 Oct 2026 | v2.15.269: settings register and rule G2 (section 4a); jobs and 14 functions read settings; worker v0.21.7; checksums. |
| 1.8 | 13 Oct 2026 | v2.15.268: notices list the universities to act on (`items`); search stopped excludes held. |
| 1.7 | 13 Oct 2026 | v2.15.267: Progress journeys filters and journey steps; running_unis for every job. |
| 1.6 | 13 Oct 2026 | v2.15.266: Progress (section 2a): admin_progress_read, hourly snapshots kept 90 days, retired screens. |
| 1.5 | 13 Oct 2026 | v2.15.265: directory guard at spend, refusals by university, search order tiers, scholarship eligibility (30+ courses) and cap from joining onboarding, search holds, official website from training.gov.au and TEQSA first. |
| 1.4 | 13 Oct 2026 | v2.15.264: AI configuration on Models & services › AI & OpenRouter. |
| 1.3 | 13 Oct 2026 | v2.15.263: Firecrawl reads only pages found by CRICOS code, listed by the university or entered by a person. |
| 1.2 | 12 Oct 2026 | v2.15.262: Firecrawl daily budget, per-university caps, search stop, credits by university; cohort au-top-2026-10-12. |
