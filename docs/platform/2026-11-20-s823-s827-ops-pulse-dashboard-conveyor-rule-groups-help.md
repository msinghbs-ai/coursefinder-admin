# S1-UX s823 to s827 — stored ops pulse, Dashboard cards by country, 4-stage pipeline board, Layer 4 rule groups and ? help

**Chat:** S1-UX · **Trigger:** Platform Admin 20 Nov 2026 10:31, 10:46 and 11:24 AEDT (the 11:24 brief rescoped S1-UX to five additive upgrades on top of S1-RM-Design's Pilot PR 1411)
**Release:** PIM Admin **v2.16.67** (package 0.1.489), on Pilot `main` `3279126` (PR 1411 merged as v2.16.66) · **Migration:** `20261120140000_cf247_s823_ops_pulse_snapshot_state_transition_logging.sql` (renumbered at 12:45 from `20261120130000`, which S1-AER's open #1418 holds)
**Status (20 Nov 2026 12:50 AEDT):** rebased onto the real `main` after PR 1411 merged, built and tested; **not merged and not applied live.** This session has read-only GitHub access (the session's `GH_TOKEN` is invalid for github.com; push was refused), so the change is handed to S1-RM-Design or S1-Build as patches and drop-in bundles (section 8). Nothing applied to Supabase; no interactive `execute_sql`; spend US$0.

## 1. Pre-flight and coordination (read only)

| Check (20 Nov 2026) | Result |
|---|---|
| Live `schema_migrations` (Supabase `list_migrations`, read only, 12:40) | 2,215 rows, head `20261120121100` (PR 1411's `121000`/`121100`) |
| Pilot `origin/main` | `3279126` (#1416 on PR 1411 #1417 #1415); head migration file `20261120121100` = live head (1 to 1) |
| In-flight migrations of other lanes | #1418 (S1-AER s831) `20261120130000`; #1419 (S1-Build s819) `20261120117000` (below the live head: S1-Build to renumber) |
| S1-UX migration | `20261120140000`: above every live and in-flight version; #1418 and S1-UX can merge in either order |
| Spec numbers | s822 is S1-Courses' (Pilot #1413, live); S1-AER holds s828 to s832; **S1-UX uses s823 to s827** (S1-Courses' record notes them as S1-UX's) |
| Files shared with PR 1411 | `src/PlatformHealth.jsx` (one section added under the s817 executive view), `src/Layer4Inbox.jsx` (one list expression wrapped), release and guide bookkeeping. **The Layer 4 card, hold banner, Remove & Admit and the card's action bar are PR 1411's and are not touched.** |

## 2. What each item does

| Id | Change | Where |
|---|---|---|
| s823 | **Stored ops pulse and state-transition logging.** (a) `security.admin_platform_health_cf221()`, read by Platform Health and the top-bar health dot on every page, counted `pipeline.jobs` and 24 hours of `pipeline.evidence_artifacts`, `pipeline.layer2_provider_attempts`, `pipeline.layer3_interpretations` and every scholarship at read time. Those counts, plus Layer 4 waiting by kind, completeness by country (stored scores) and the four pipeline stages (from the checks the scheduled health check already stores) are now one row, `pipeline.ops_pulse_snapshot`, rebuilt every 5 minutes by job `ops-pulse-refresh` (Automations). The read returns the stored row (post-check limit 50 ms) while it is fresher than `ops.pulse_max_age_minutes` (15), and otherwise counts live exactly as before. The pulse goes to rank 3 and above only; existing role gates unchanged. (b) `public.svc_worker_report_v1` wrote one `pipeline.mode_outcome_ledger` row plus two updates for every worker call, including calls that found nothing. A run of idle calls for the same mode and worker now updates one row (run_at moves to the latest call so lane liveness is unchanged; `detail.idle_polls` counts calls; `detail.first_idle_at` keeps the first) for up to `telemetry.idle_collapse_minutes` (15; 0 switches it off). Work, failures and errors end the run and are written as before. | Migration; `security.ops_pulse_refresh_v1`, `ops_pulse_fresh_v1`, `ops_pulse_cf221_v1`, `worker_idle_collapse_v1`, `worker_idle_note_v1`; tables `pipeline.ops_pulse_snapshot`, `pipeline.ops_pulse_stage_map` (editable data), `pipeline.worker_idle_tally` |
| s824 | **Dashboard.** Five KPI cards with Lucide icons in tinted badges (System status, Catalogue completeness with AU/NZ/CA progress bars, Decisions waiting on you, Active blockers, AI & crawl spend today with a meter against the daily cap), Curator and above; Active failures for operators; role pill icons (search, clipboard check, shield). A Viewer or Counsellor (rank 1–2) makes **no pipeline or telemetry read** (the operator block and its `admin_read 'dashboard'` are no longer mounted for them). An unknown figure shows a dash, never 0. | `src/Dashboard.jsx`, `src/OpsPulse.jsx`, `src/lib/ops-pulse.js`, `src/ops-pulse.css` |
| s825 | **4-stage pipeline board** under PR 1411's s817 executive view: Official Registers → Page Capture → AI Extraction & Auto-Clean → Live Catalogue. Stage icons, a coloured top accent (green running normally, amber slowed or due, red stopped, always with words), a connected flow track up to the first stage that needs attention, the queued count and a health meter (checks passing) in each card, and the selected stage's panel with a link to the screen that controls it. Shown only when the stored pulse is present; otherwise the page is exactly s817's. | `src/PlatformHealth.jsx`, `src/OpsPulse.jsx` |
| s826 | **Layer 4 › Inbox, Waiting, grouped by rule.** A left panel groups the cards on the page by the check that holds them (descriptions by hold code, other kinds by the first clause of their reason), largest first; Preview the batch lists a group's cards; Show only these narrows the list. It reads and decides nothing; every card keeps PR 1411's card and bar; Grid › Grouped decisions remains the one-step server-checked batch. Hidden when it groups nothing. | `src/Layer4RuleGroups.jsx`, one wrap in `src/Layer4Inbox.jsx` |
| s827 | **? help drawer** on the Dashboard, Platform Health, Layer 4 Review, Courses and Providers headers: three numbered steps, the role note, a link to Guides › Platform guide (`#platform-guide`); Escape closes it. | `src/HelpDrawer.jsx`, `src/mature-main.jsx` (`HELP_TOPIC`), `HELP_GUIDES` in `src/lib/ops-pulse.js` |

## 3. Guardrails

- **G3:** no new public function, table or view; `security.consumer_api_check_v1()` asserted at 75 functions / 48 relations with no drift before and after, inside the migration.
- **G1:** one job (`ops-pulse-refresh`) registered in `pipeline.automation_catalogue` (Automations, control rank 6) and the component register. **G2:** both limits are settings.
- **Data safety:** no catalogue write; manual locks untouched (7,585 at last read). **Spend:** none.
- **Fail-closed edits:** `public.svc_worker_report_v1` md5-guarded (`b110a648…`, recorded after its 3 Nov edit); `security.admin_platform_health_cf221()` guarded by two exactly-once fragments (no md5 recorded since its 20 Oct D11 edit). A drifted definition stops the migration in the dry run.

## 4. Rolled-back post-checks inside the migration

1. First rebuild under 20 s, four stages, a known Layer 4 waiting count (unknown fails the check).
2. As a Platform Admin the health read answers from the stored row (`pulse_source` snapshot) in under 50 ms with every CF-221 key the Dashboard reads.
3. A rank 1–2 user gets neither the pulse nor API activity.
4. Three idle calls of a test mode fold into one ledger row with `idle_polls` 3; a call with work gets its own row and ends the run (rolled back).
5. The job is scheduled; the consumer API is unchanged.

## 5. Local tests (US$0)

- New spec `tests/uat/cf-247-s823-s827-ops-pulse-dashboard-conveyor-rule-groups-help-contract.spec.mjs`: 9 tests (4 source, 5 mocked browser), all pass.
- Affected suite on main `3279126` + S1-UX (188 specs, `--grep-invert @deployed`, 4 workers): **972 passed**, 1 failed, 1 flaky. The failure (`cf-247-catalogue-course-description-contract` › "Show all") also fails on unmodified `main`; the flaky one (`cf-247-s227…` › Approve except) asserts the call list straight after a click and passes on both solo runs.
- Release contract PASS (v2.16.67); UI tokens PASS; CSS class collisions PASS; `vite build` PASS; SOP documents and UI map regenerated.

## 6. Not done here, stated plainly

| Asked | Why not here | What it needs |
|---|---|---|
| Merge, live apply, live read-back, signed-in check, Drive `Monitoring` sync, workbook rebuild | Read-only GitHub access in this session | Section 8 handoff |
| Stage meters as rates ("capture rate vs normal") | The stored pulse holds check status, not rates; a rate needs a stored baseline | Add the rate figures the health checks already compute to the snapshot (no extra scan) |
| Keyset ("Next 50") paging for the Catalogue grids | Needs an edit to `security.admin_course_page_fast` (live definition not read here) | Function snapshot through the dry-run workflow, then a keyset variant behind `courses_page` |
| ? on the Layer 4 hold banner | The banner is PR 1411's (now merged); left to its owner | S1-RM-Design: `<HelpButton topic="layer4"/>` in the banner (one line) |

## 7. Rollback

Unschedule `ops-pulse-refresh` (reads fall back to live counts after 15 minutes); set `telemetry.idle_collapse_minutes` to 0. Each in-place edit is one inserted line, removable with the same `cf_edit_def` helper. UI: revert the v2.16.67 commit.

## 8. Handoff

Bundles from the S1-UX chat (v2, 12:50, cut from real `main` `3279126`): `coursefinder-pilot-s823-s827-v2.patch` (two commits, `git am -3`; no bookkeeping conflicts expected) with `coursefinder-pilot-s823-s827-v2.zip` and `coursefinder-admin-s823-s827-v2.patch`/`.zip` (on admin `main` `7366f32`). Order: apply the admin patch and merge it first (repo-first) → apply the Pilot patch on a branch off `main` → re-check the live head and renumber `20261120140000` only if another lane has gone above it → regenerate SOP documents, UI map, release history and TEST-REGISTER → green CI → rolled-back live dry run (section 4) → merge → merged-main CI applies → read back → admin PR (rebased) → Drive `Monitoring` row.

## 9. Data gaps (from S1-AER's live read, 20 Nov 2026 11:05 AEDT, academic entry requirements; not re-measured by S1-UX)

**Table 1 — Verified source-backed gaps** (course has a bound, stored page that was read; a proxy, not yet proof the page states entry requirements)

| Country | Courses |
|---|---|
| Australia | 12,222 |
| New Zealand | 4,522 |
| Canada | 3,235 |
| **Total** | **19,979** |

**Table 2 — No source available yet** (no bound stored page; *No source available — do not quote as verified*)

| Country | Courses |
|---|---|
| Australia | 4,709 |
| New Zealand | 1,578 |
| Canada | 579 |
| **Total** | **6,866** |
