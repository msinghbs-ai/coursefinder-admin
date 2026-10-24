# AU builds and enrichment jobs — the developer's gap review, and the standing order

**Date:** 24 Oct 2026, 09:55 → 11:30 AEDT
**Mandate:** Platform Admin, 24 Oct 2026 09:55 (section 11). Standing state, guardrails, the docs rule and the standing order from [2026-10-24-zero-yield-reacquisition.md](2026-10-24-zero-yield-reacquisition.md) section 6 apply unchanged. Figures come from [2026-10-24-au-quick-wins-and-247-ingestion.md](2026-10-24-au-quick-wins-and-247-ingestion.md) section 7, corrected here only with live data (each correction says so).

---

## 1. Phase 0 — R1 and R3

### R1 — v2.15.339 (PR #681, migration `20261024004000_cf247_r1_backoff_ledger_identity.sql`) — **LIVE 10:40 AEDT**

**What the measurement found before building (10:05 AEDT).** The empty-tick backoff already existed: the flag unit (v2.15.283, 15 Oct) pauses a worker lane after `flag.empty_calls_to_pause` (30) empty calls and tries it again after `flag.job_recheck_hours` (6 h, rising with every check), or — for three modes only (read, link_search, provider_facts) — as soon as `worker_mode_waiting_v1` says work waits. Live at 10:05: **coverage-read and coverage-read-2 paused at 09:40 with pages due and a next trial at 15:40**; central-find (paused 07:00), find-site (04:50) and the contact-page lane (08:10) the same, each with a six-hour wait and no "work is waiting" test at all. So the quick-wins file's 24/7 audit line "no lane sleeps" was wrong — lanes sleep up to six hours after draining — and that correction is appended to its section 4. The defect is the backoff maximum and the missing wake-up test, not the absence of a backoff.

| Q | Shipped | How it honours the invariant |
|---|---|---|
| Q2 | `tick.backoff_max_minutes` (15, 1–60, Settings › Pipeline settings › Waste rules) caps every trial wait in `flag_jobs_v1` (md5-guarded edit); `worker_mode_waiting_v1` replaced (md5-checked) with a "work is waiting" test for **13 lanes** (read, link_search, provider_facts, ai_match, reidentify, discover, find_site, central_find, contact_page, logo_find, companion_read, source_find, programme_read), each a non-leasing mirror of its picker | a paused lane is tried again within 15 minutes, and the 10-minute flag recheck switches it on the moment its queue is fed (the event-driven reset). No worker change; `flag.empty_calls_to_pause` stays the "after N empty ticks" setting the plan called `tick.backoff_after_empty` (one setting, not two) |
| Q4 (narrowed) | **Companion read**: the University of Sydney's course data files (`….coredata.json`) answer with the course page itself (HTML, 200) and the worker refused the body as "not JSON" — 219 of 583 files failed (49 with every attempt used). Worker v0.46.0 reads such an answer as the page; the 219 get their attempts back (count-guarded). **Why idle**: `pipeline.queue_watch.upstream_key` + `security.lane_why_idle_v1(key)`, one plain line per queue on the Work queues screen (paused by the idle guard and when it is tried again; nothing waiting and which lane feeds it; waiting with nothing finishing: a gate holds it; failing; nothing left) | the screen now says in words why each lane is idle, and the companion lane stops failing every hour |
| Q3 | `pipeline.mode_outcome_ledger`: one row per worker call (mode, status, ms, items, ok, failed, landed, worker, detail ≤ 4 KB) written by `public.svc_worker_report_v1` from worker v0.46.0 after every answer is built (a failure to write never fails a call); `security.lane_queue_wait_v1(hours)` gives queue wait p50/p90/max and rows waiting per reader lane from the queues' own timestamps (fee reader, enrich fields, course-page read, AI page match, course-page search, central AI); job `ledger-retention` daily 03:37 UTC (`retention.mode_outcome_ledger_days` 90) — it also removes old zero-yield snapshots, which v2.15.338 left to a job that never did | the hourly picture reads the ledger and the wait function instead of being inferred from `edge_request_log` |
| Apply-time identity check | `security.coverage_apply_course_v1` (md5-guarded): a fee for a course whose bound, non-manual page carries a proof the country's tuition policy refuses is written `unverified` with one Layer 4 row (source `identity_basis_reverify`) and the result says `fee_quarantined_identity`; the floor quarantine is untouched | every caller is covered at the write, whatever it checked before |

Dry run against a branch: all checks passed (ledger row written and read back; why-idle lines rendered; waiting tests answered for 14 modes; the 219 companion rows reset; the three md5 edits applied). Test s93. Full suite: 1,830 passed, the 4 known legacy failures (cf-091, cf-103). Live verification after the merge (10:40): migration md5 `b7b335d953c94bc79213ef0a31d0eca3` = file; worker `coverage-sweep-worker-v0.46.0` reporting (14 ledger rows in the first minutes); settings present; job `ledger-retention` scheduled; 219 companion files at 0 attempts; `coverage_apply_course_v1`, `flag_jobs_v1` and `admin_queue_watch` carry their edits; why-idle line for Read course pages: "Paused by the idle guard (coverage-read) since 24 Oct 10:30; tried again by 24 Oct 16:30, or as soon as work waits". **The four lanes paused before the release still carried six-hour waits, so their next trial was brought forward to the cap (logged `idle_paused_trial_capped`); at 10:50 the recheck switched coverage-read, coverage-read-2 and find-site on again because work was waiting — the event-driven reset, observed live.**

### R3 — v2.15.340 (PR #682, migration `20261024005000_cf247_r3_health_hourly.sql`) — **LIVE 11:20 AEDT**

| Piece | What it does |
|---|---|
| `pipeline.health_snapshots` | one row per metric per hour (at, country, metric, value); RLS on; 90-day retention through `ledger-retention` |
| `security.health_hourly_v1()` — job `health-hourly` at :11 | writes **headline** (pages read from the R1 ledger, values admitted from the 15-minute field counts, the 24-hour pace against `health.headline_target`), **fields_delta** per country (hour and day), **lane_wait** (R1 `lane_queue_wait_v1`), **ledger** (calls / items / ok / failed per mode), **idle** (every watched queue that is not simply moving, with its why-idle line), **bound_empty** per country (bound page with a stored copy, read more than `health.bound_empty_hours` ago, course holds no fee, English score or intake), **negative_movers** (a field count that fell over the day beyond `health.growth_pct`, a lane with work and no progress for `health.stuck_hours`, a binding-rate fall beyond `health.binding_drop_pct`, Layer 4 growth beyond `health.growth_pct` — each with the window so the cause can be found in `admin_control_events` or the migrations applied in it), **budget_burn** (Firecrawl day shares and AI guards, marked at `health.burn_warn_pct`) |
| `security.health_latest_v1()` | the latest hour in one call; the hourly report scheduled task (:03 Melbourne) now prints "Hour:", "Lanes:" and "Negative movers:" from it |
| `stats.countries` (NZ, AU, CA) | the 15-minute stats job carried `array['NZ','CA']` in its command; it now reads the setting, so **AU joins the 15-minute stats and the hourly rows** |
| `health.headline_target` = 0 | "not yet set": the first full week of hourly rows gives the provisional target, set by the Platform Admin (a passing check never sets it) |

Dry run: passed; the negative-movers row flagged exactly the 23 Oct 16:02 take-back (NZ campus 3,258 → 2,315, delivery, duration; CA campus) with its window — the deliberate retraction of values read from wrong pages (v2.15.330), which is what the row is for. Full suite 1,838 passed (4 known legacy failures). Live 11:20: migration md5 `307754643ae40fec4bd49b85ca5c29dd` = file; job scheduled; 8 settings; stats command reads the setting; first run by hand wrote 10 rows for the 11:00 hour — **237 pages read in the hour** (the read lane woke at 10:50 under R1's cap and read), 7 negative movers (the take-back fields, still inside the 24-hour window).

**Provisional headline target:** not set (0) by design until a week of rows exists; the first hour's figure — 237 pages read, 0 new values — is the baseline the week starts from, and the recommended starting target when the week is in is the week's median 24-hour pace.

---

## 2. Phase 1 — builds B1–B6 (none started before R1; order and dependencies)

| # | Build | Settings keys | Est. | Expected (24 h / 7 d after ship) | Order |
|---|---|---|---|---|---|
| B1 | Entry requirements (academic), NZ + AU, stored pages first — spec: field-admission file section 5 (`catalogue.course_entry_requirements`, AI reader, quote-on-page, supersession, additive API) | `entry.max_rows_per_course` (1–10, 6), `entry.min_confidence` (0.5–1, 0.8), `entry.countries` (list) | 2.5 d | 0 / first 1,500–3,000 courses (AU + NZ stored pages that print an entry section; the reader refuses the rest) | **first, starts straight after R3 (the mandate: after R1; R3 is a half-day and is the measurement every build is judged by)** |
| B2 | Course descriptions reader over the stored copy → `courses.description` | `description.max_chars` (200–1,000, 600), `description.min_confidence` (0.5–1, 0.8), `description.countries` | 1.5 d | 0 / 40–55 % of 14,930 (11,106 have a copy; a description must be sentences on the page) | second; runs in parallel with B1's reader day (same worker prompt family) |
| B3 | University descriptions from the stored home/about page → `providers.description` (39 of the 53 AU university-type providers have a stored home or contact page; the other 14 need a `site_check` read first) | B2's keys + `description.provider_pages` (list) | 0.5 d with B2 | 0 / 39 then 53 | with B2 |
| B4 | Scholarship second pass: eligibility summary, minimum academic result, eligible countries asked explicitly, value-note consistency (reject a note contradicting the amount) | `scholarship.second_pass_batch` (10–500, 100), `scholarship.note_amount_check` (0/1) | 1 d | 0 / nationalities 63 → 160–300, deadlines +50–100 (E6 says what is free: ≤ 31 close dates, 0 nationalities), the 23 notes corrected | after B2 |
| B5 | `provider_annual_is_derived` on the search document (additive) — a visibility change, not a data change: 8,461 courses already carry the CRICOS registered total; the item already serves `tuition.annual_is_derived` | none | 0.5 d | the flag shows on lists; counts unchanged | any gap; can run beside B1 |
| B6 | Rankings: earlier QS editions through the Layer 1 `statistics-edition-discovery` job; graduate results: QILT name mapping — UNSW and Adelaide can be filled (post-merger name mismatches); UQ College and USQ Sydney are not surveyed separately and need a "not surveyed" state (an additive status on the provider's graduate-results row, never a gap flag) | none | 1 d | rankings 38 → 45 (or "not ranked in this edition"); graduate results 41 → 43 + 2 "not surveyed" | after B4 |
| B7 (new, from E3) | Full campus lists: a reader over the university's stored campuses/contact page → campus proposals for review (the existing `campus_list` item only admits names seen on enough course pages, which is why UNSW holds 4 of 7) | `campus.list_min_confidence` (0.5–1, 0.8) | 0.5 d | 0 / +50–150 campuses after review | with B3 (same page kind) |

Every build: quote-on-page for every AI reader, existing apply paths, settings-keyed, catalogued jobs, contract tests, count-guarded backfills where rows exist, additive consumer API only (Decision 266). **Parallelism:** B1 and B5 can run on the same day (schema and API work); B2 + B3 + B7 share one worker prompt change and one deploy; B4 and B6 follow. Calendar: R3 → B1 (2.5 d) ∥ B5 → B2/B3/B7 (2 d) → B4 (1 d) → B6 (1 d): about 7 working days of build after R3.

---

## 3. Phase 2 — enrichment jobs E1–E6

| # | Item | What was done today | What awaits the Platform Admin | Record |
|---|---|---|---|---|
| E1 | Provider-policy approvals | **The approval UX already has two paths:** checked AI readings approve themselves (Platform Admin 15 Oct: "automatic approval of checked AI readings" — 43 approved automatically in the last 24 h) and the rest wait on Settings › Provider policies for a person. Live at 10:40: **65 proposals waiting at 48 providers (oldest 23 Oct 12:55)**; the central AI queue holds 99 (today's 94 + 5) and is moving at ~36 an hour (done in ~3 h). **Daily summary line added** to the "Work queue daily report" scheduled task (07:35 Melbourne, email): proposals waiting, providers, oldest, older than 3 days, approved in 24 h (automatic / by a person) | approve the waiting proposals as they arrive; each approval fills English and intakes for every course of that provider (est. +400–900 English on the AU published population) | scheduled task `trig_014HaaDRXYJNbCHM8fyW32vo` updated 10:18 |
| E2 | Intake calendars (on/off analysis — not switched on) | **What the job writes:** `provider-calendar-intakes` (`semester_intake_apply_v1`, every 10 min when active) answers *Layer 4 course-intake review items* whose course page quotes a study period ("Semester 1") with the months of the university's **approved** calendar (Decision 228), writing `catalogue.course_intakes` rows through `coverage_apply_course_v1` and superseding the review item. **Live today it would write nothing:** there are 0 pending course-intake review items (that review flow was superseded by the Enrich fields reader, which already maps a quoted semester through the approved calendar — v0.42.1). **Calendars admitted:** 53 of the 224 published AU providers have an approved calendar; **5,332 of the 6,883 missing-intake courses sit at those 53**, 1,551 at providers with no calendar. **The real lever is not this job but a "calendar default":** writing the calendar's main periods to every coursework course of a provider whose page states no period. That is an inference, not a page fact — wrong for research degrees, mid-year-only programmes (nursing, education placements), short courses and offshore campuses — and it would show on the website as a start month the university never stated for that course. **Recommendation: leave the job off; do not build the default.** If the Platform Admin wants a typical-starts figure, build it as a *provider-level* "typical start periods" field (proposal → approval, shown as the university's calendar, never as the course's intake) — 1 day, additive | decide: (a) leave off (recommended), (b) build the provider-level "typical start periods" field, (c) switch the job on (fills 0 today) | — |
| E3 | Campus lists | **Stored coverage checked:** 53 published AU university-type providers (the developer's "45" is their count of universities; the platform's type includes university colleges); 39 have a stored home or contact page; 292 campuses held; 6 have one campus or none. **Not firable through the existing lane:** `campus_list` items are made only from course-level `campus` items, and every published AU course already has a campus, so a `provider_fill` run creates nothing. The full list (UNSW 4 of 7) needs the small reader B7 (section 2) | none (B7 is in the build order) | — |
| E4 | Zero-yield continuation | Detect-only, hourly at :21 (`zero_yield.auto_reset` = 0). **F9 (enrich reader keeps its rejection quotes) is not yet fixed** — R1's Q4 was narrowed by this mandate to the companion read and the why-idle line, so F9 moves to the next release (0.5 day: the `enrich_fields_slice_v1` rejection branches keep the quote they refused; the "only a site-wide line mentions international" reason is written only for the `international` field). No re-read of the 693 rows before that. **Flagged providers (latest snapshot):** 149 providers measured so far, **14 flagged as systematic** (verified-wrong of bound, rate): University of Sydney (AU, 28 of 403, 64.8 %), TasTAFE (AU, 14 of 26, 53.8 %), University of Alberta (CA, 10 of 222, 39.2 %), UNBC (CA, 8 of 47, 63.8 %), University of Otago (NZ, 6 of 194, 53.1 %; its zero-yield pages are the right pages — Otago prints fees elsewhere), University of Victoria (CA, 4 of 140), University of Calgary (CA, 4 of 33), SFU (CA, 2 of 153), and six flagged by zero-yield rate alone with 0 verified wrong (James Cook, King's Own, Awanuiārangi, Top Education, Mount Royal, Melbourne) — the rate flags them, the signals clear them, so nothing would be reset there even with automatic resets on. UoA: the catalogue-only courses (45) still wait on the host-allowance-vs-manual-bindings decision; the 38 quarantined UoA fees wait on it | (1) `zero_yield.auto_reset` stays off until you decide; (2) UoA decision: host allowance for `study.auckland.ac.nz` catalogue pages vs manual bindings for the 45; (3) NZ top-20 sweep with auto_reset on follows those two | zero-yield file section 6 |
| E5 | Fee follow-through (the 149 identity-quarantined fees) | Measured and acted on: **112 of 149 courses re-bound under their country's rule and 115 carry a live international fee again**; the 149 Layer 4 rows had stayed `pending` because nothing closed them — **95 closed (`superseded`) today** where the page is re-bound and the fee re-admitted after the quarantine. **Remaining 54:** 37 NZ pages not proved under identity-v0.6.0 (now `mismatch`: they need a new page — the AI page match and the zero-yield flow), 16 NZ re-bound with an open fee request (the fee lane reads them next), 1 CA re-bound and queued. **Found and fixed:** 4 Manukau Institute of Technology pages bound with a `cricos_code` label at 08:19 AEDT, inside the v0.45.0 deploy window and after the 406 re-verification — reset to `mismatch` the same way, 3 fees quarantined (count-guarded, logged). 15 manual bindings (AUT, UoA) still carry a `cricos_code` label and are exempt by design (manual bindings are never touched) | nothing | `docs/platform/wrong-page-values/PASTE-20261024-e5-fee-follow-through.sql` |
| E6 | Scholarship fields from existing reads | **859 of the 898 published AU scholarships have an AI read.** The current prompt asks name, value, levels, courses, audience (international / both / domestic), open and close dates — **not eligible countries**: the separate nationality reader has read all 898 and found codes on 63 (the pages name no country on the rest). Close dates: the AI reads state 477 (the catalogue holds 479); **31 are stated but not held**, and a sample shows why (a 2023 date, an "end of eligibility 2031" date, an open-date range read as a close) — not free, a sanity rule in B4. **Free coverage for B4: 0 nationalities, ≤ 31 close dates after a rule.** B4's re-read must ask for eligible countries, eligibility summary, minimum academic result and the value-note check explicitly | none | — |

---

## 4. Phase 3 — the gates (status lines only)

| Gate | Status |
|---|---|
| R2 (Q1 at cap 100) | not started; waits on the `target_only` audit paste file and the Platform Admin's sign-off; course-page search holds 2,839 queued courses (the only lane idle with eligible work) — expected +1,400 bindings in the first week at cap 100 |
| S1 full | not started; `page_rejections` (zero-yield partial) is in place for the AI match and reidentify; the search picker and the finder do not read it yet |
| 8a remainder (`country_identity_rules`) | not started; the worker part shipped in v2.15.337; the 15 manual `cricos_code` labels on NZ pages are the first rows its acceptance test will relabel |
| Items 9, 10, 11 | not started |

---

## 5. Expected coverage — the numbers for the developer (14,930 published AU courses)

| Gap | Now | 7 days | 30 days | What moves it |
|---|---|---|---|---|
| Official course links | 74.5 % (11,130) | 75–77 % | 80–85 % | R2 bindings (+1,400 / week once on) |
| Start months | 54 % | 54–55 % | 56–60 % | R2 bindings only, unless the Platform Admin chooses a calendar field (E2) |
| English requirements | 79 % | 79–85 % | 85–90 % | provider-policy approvals (E1) + R2 |
| Tuition (any) | 99.3 % | 99.3 % | 99.3 % | B5 makes the derived flag visible; counts unchanged |
| Course descriptions | 1 % | 1 % (B2 not shipped within 7 d of today) | 40–55 % | B2 |
| University descriptions | 0 of 53 | 0 | 39–53 | B3 |
| Campuses (full lists) | city + postcode on all | — | +50–150 campuses | B7 after review |
| Scholarships — eligible countries | 63 of 898 | 63 | 160–300 | B4 |
| Scholarships — closing dates | 479 | 479 | 530–580 | B4 |
| Rankings | 38 of 45 | 38 | 45 (incl. "not ranked") | B6 |
| Graduate results | 41 of 45 | 41 | 43 + 2 "not surveyed" | B6 |
| Entry requirements (academic) | 0 % | 0 % | 10–20 % (B1 ships in week 1, reads in week 2–4) | B1 |

---

## 6. Weekly coverage matrix rows (added once Phase 1 lands)

The weekly matrix (`pipeline.enrichment_coverage_snapshots`, item 10) gains one row per developer gap per country, each with its unblock lever:

| Row | Measure | Lever |
|---|---|---|
| `official_course_url` | courses with a link / published | R2 |
| `intake_months` | courses with ≥ 1 intake / published | R2; E2 decision |
| `english_requirement` | courses with an IELTS score / published | E1 approvals |
| `tuition_any` and `tuition_derived_share` | courses with a fee; share derived from the registered total | B5 |
| `course_description` | courses with a description / published | B2 |
| `provider_description` | providers with a description / published providers | B3 |
| `campus_list_complete` | providers whose campus list matched the stored page | B7 |
| `scholarship_nationalities`, `scholarship_close_date`, `scholarship_eligibility_summary`, `scholarship_min_academic` | of published scholarships | B4 |
| `rankings_current_edition`, `graduate_results` | providers with a value or an explicit "not ranked / not surveyed" state | B6 |
| `entry_requirements` | courses with ≥ 1 entry-requirement row / published | B1 |

---

## 7. Blocked on the Platform Admin

O5 (NZQA signatory list URL); O8 / O9 (Firecrawl and OpenRouter plan tiers and caps); and the three decisions above: **E2** (calendar: leave off / provider-level field / switch on), **zero-yield `auto_reset`**, **UoA** (host allowance vs manual bindings for the 45 catalogue-only courses; the 38 quarantined fees wait on it). Nothing else.

---

## 8. Decisions recorded (docs-and-questions rule)

| # | Decision | Why |
|---|---|---|
| D1 | Q2 ships as a cap on the existing flag-unit backoff plus per-lane wake-up tests, not as a worker-side backoff | the backoff already existed in the database; a second one in the worker would be two controls for one behaviour |
| D2 | `flag.empty_calls_to_pause` keeps its name; no `tick.backoff_after_empty` | one setting, not two |
| D3 | The ledger's `wait_ms` is null in v1; queue wait comes from `lane_queue_wait_v1` over the queues' timestamps | the pickers do not carry a queued-at; adding it to six pickers is a later, separate edit |
| D4 | Q4 narrowed to the companion read and the why-idle line (per the mandate); onboarding (12 waiting) and central AI leases are reported by the why-idle line, not changed | the mandate's scope |
| D5 | The 4 MIT pages and the 95 closed quarantine rows were acted on live under the 07:32 and 09:55 decisions | continuation of a decided action, count-guarded and logged |
| D6 | E2: recommend leaving the calendar job off and not building a course-level default | a start month the university did not state for the course is an inference the website would show as fact |
| D7 | F9 moves to the next release | Q4 was narrowed; a re-read before the fix would reproduce unauditable rows |
| D8 | B7 (campus-list reader) added to the build order | the existing lane cannot produce the full lists |

---

## 9. Runbook addition (one section)

**Idle lanes.** A worker lane that finds nothing to do for `flag.empty_calls_to_pause` calls is paused by the idle guard and shown on Platform health › Work queues with the line "Paused by the idle guard … tried again by <time>, or as soon as work waits". It is tried again within Idle lane: tried again within (Settings › Pipeline settings › Waste rules, 15 minutes) and the moment its queue holds eligible work. Nothing needs doing by hand; to see what each call did, `select * from pipeline.mode_outcome_ledger order by run_at desc`; for queue wait per lane, `select * from security.lane_queue_wait_v1(24)`.

---

## 10. Correction to the quick-wins file

Section 4 of [2026-10-24-au-quick-wins-and-247-ingestion.md](2026-10-24-au-quick-wins-and-247-ingestion.md) said every lane runs around the clock with no sleep window. Wrong: the idle guard was pausing drained lanes for six hours and more (coverage-read paused 09:40 → 15:40; find-site, central-find and contact-page the same). A correction is appended to that file and R1 fixes it.

---

## 11. Mandate as received (24 Oct 2026, 09:55)

> Mandate — ALL builds and data-enrichment jobs from the website developer's Australia gap review, plus the standing order. Phase 0: R1 (Q2 empty-tick backoff with event-driven reset; Q4 narrowed to companion-read failure + why-idle line; Q3 per-mode ledger; apply-time identity check) ships as ONE release before any build; then R3 (health-hourly at :11, provisional headline target from its first week). Phase 1: B1 entry requirements (first; 2.5 d), B2 course descriptions (1.5 d), B3 university descriptions (0.5 d), B4 scholarship second pass (1 d), B5 tuition derived flag (0.5 d), B6 rankings + graduate results (1 d); quote-on-page, existing apply paths, settings-keyed, catalogued jobs, contract tests, count-guarded backfills. Phase 2: E1 provider-policy approvals (report the UX, how many wait, a daily summary line), E2 intake calendars on/off analysis (do not switch on), E3 campus lists (check stored coverage first), E4 zero-yield continuation (F9 first; auto_reset off until decided; UoA decision; then NZ top-20), E5 fee follow-through (149 shrinking to zero), E6 scholarship fields from existing reads. Phase 3: status lines for R2, S1, 8a, items 9–11. Output: R1 + R3 references and the provisional target; B1–B6 with keys, estimates, expected counts, order; E1–E6; the 7-day / 30-day coverage table; the weekly matrix rows; what is blocked (O5, O8/O9 and the three decisions only).
