# StudySearch – System reference (how it works now)

**Version:** 1.0 (12 Oct 2026, platform release v2.15.260)
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
`pipeline.onboarding_pilot` cohort `pilot-2026-10-12`: 60 AU, 25 NZ, 15 CA, baseline per university (`security.provider_fill_counts_v1`). Hourly snapshot cron `onboarding-pilot-snapshot` (:07) → `pipeline.onboarding_pilot_snapshots`; live `security.onboarding_pilot_report_v1(cohort)`; Pilot panel on Layer 2 › Onboarding.

## 2. Course pages: find and read

| Step | How | Schedule / limits |
|---|---|---|
| Find | Firecrawl search (`{course} site:{domain}`, 5 results; CRICOS code then title), worker mode `link_search`; only Firecrawl target universities while `target_only` is on | `course-link-search` (tick, 20) and `course-link-search-worker` (limit 120) every minute |
| Bind | First candidate bound as the course's page (basis title_search / cricos_search); a wrong page (identity mismatch) or a page failing twice (or 404/410) moves to the next candidate | in the tick |
| Read | Worker mode `read`. **Since v2.15.260 (worker v0.21.2) a page found by a search is read through Firecrawl** (rendered rawHtml, waitFor 2 s); direct request only when Firecrawl cannot be used. Other pages (matcher, CRICOS code, by hand): direct first, Firecrawl fallback when blocked/thin. robots.txt respected for course pages | `coverage-read` and `coverage-read-2` every 30 s, 60 a call, **up to 20 per university** (`svc_coverage_read_next`); a page is tried at most 3 times |
| Identify | Code or title on the page, or the university adapter's identity; otherwise identity_mismatch | — |
| Discover (matcher) | Worker mode `discover` | `coverage-discover` (20) and `coverage-discover-2` (8) every minute |

Firecrawl targets (`firecrawl_target_cache`): countries AU/NZ/CA; name contains "university"; AU/NZ ≥100 courses, CA ≥30; excludes college/pathway/…; plus every university onboarding works on (`pipeline.firecrawl_targets`). Firecrawl key settings: read/find credits per run 15,000; run concurrency 12; low-balance warning 10,000. Plan 500,000 credits a month (period starts the 2nd); balance read every 15 min (`firecrawl-credit`).

## 3. AI and limits

| Use | Model(s) | Daily guard |
|---|---|---|
| Scholarship pages | Qwen3 30B, then GPT-4.1 mini (GPT-4.1 qualified, not in the order) | US$20 |
| Adapter proposals | qwen/qwen3-30b-a3b-instruct-2507 (pinned) | US$5; also the Adapter builder allowance: **400 proposals a day**, US$5 |
| Central pages (English policy, calendar) | GPT-4.1 mini | US$5 |
| Course-page matching | — | US$5 (observed) |

OpenRouter: balance read every 15 min (`openrouter-balance`, worker mode `openrouter_balance`); credit floor US$5; enforcement **observe** (notices only; "stop" makes `security.ai_use_allowed_v1` refuse scholarship AI and central pages AI). Spend today: `security.ai_spend_today_v1()`.

## 4. Scheduled jobs that drive admission (all in `pipeline.automation_catalogue`)

provider-onboarding (1 min) · onboarding-pilot-snapshot (hourly :07) · layer2-onboarding-snapshot (53 */2) · course-link-search, course-link-search-worker (1 min) · coverage-discover, coverage-discover-2 (1 min) · coverage-read, coverage-read-2 (30 s) · adapter-overwrite (10 min) · firecrawl-runs, firecrawl-targets (1 min) · firecrawl-credit (15 min) · firecrawl-panel-figures (5 min) · openrouter-balance (15 min) · central-ai · scholarship-discover (10 min) · scholarship-discover-refill (hourly :23). Scholarship jobs: `docs/scholarships/SCHOLARSHIP-MECHANISM.md` §6.

## 5. Live function checksums (md5 of pg_get_functiondef without \r), as last deployed

| Function | md5 | Since |
|---|---|---|
| security.provider_onboarding_step_v1(uuid) | 1ce3f7b6… | 11700 |
| security.provider_onboarding_tick_v1() | 5196a85f… | 11700 |
| security.provider_onboarding_event_v1() | a3e685cd… | 11500 |
| public.admin_provider_onboarding(text, jsonb) | dcec0b55… | 11600 |
| public.svc_coverage_read_next(integer) | 2e177089… | 11700 |
| security.platform_notices_v1() | e2d636a2… | 11400 |
| security.scholarship_ai_fire_v1() | 0a432552… | 11400 |
| security.central_ai_fire_v1() | 0a6dba98… | 11400 |
| public.admin_toolsets_read() | 75ed6d4d… | 11400 |

Worker: coverage-sweep v0.21.2. App: v2.15.260 / 0.1.187.

## 6. How a change is made (for the next change)
Migration generated with guard blocks (live md5 must equal the definition replaced) and post-checks; plpgsql syntax-checked on a local PostgreSQL 16; applied through the `db-apply-migration` workflow from the branch (worker first through `deploy-edge-functions` when both change); anything that drops or deletes goes to the Platform Admin as a paste file. Release: bump release manifest, guide and SOP review versions, package.json, CHANGELOG, persistence-contract test; regenerate `docs/sops`; full local suite; PR, squash merge; record the entry identically in the four CF-247 files; update this page.

## Version history
| Version | Date | Change |
|---|---|---|
| 1.0 | 12 Oct 2026 | First issue (v2.15.260): onboarding journey, stop reasons, admit rule, settings, pilot, course-page find and read, AI limits, jobs, function checksums, change method. |
