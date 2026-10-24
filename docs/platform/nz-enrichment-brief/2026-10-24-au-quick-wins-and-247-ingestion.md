# AU quick wins (website developer's gap review), round-the-clock ingestion, hourly lag

**Date:** 24 Oct 2026, 09:17–10:10 AEDT
**Mandate:** Platform Admin, 24 Oct 2026 09:17 (quoted in section 10). Standing state, guardrails and the docs-and-questions rule from [2026-10-24-nz-field-admission.md](2026-10-24-nz-field-admission.md) apply unchanged.
**Audit trail:** [2026-10-23-platform-throughput-gap-schema.md](2026-10-23-platform-throughput-gap-schema.md) section 10. In-flight: [2026-10-24-zero-yield-reacquisition.md](2026-10-24-zero-yield-reacquisition.md) (zero-yield wins on any page it resets).

**R1 status (two lines).** Not started: no artefact exists for Q2 (empty-tick backoff), Q4 (stuck lanes), Q3 (per-mode ledger) or the apply-time identity check; every window since 00:45 went to the four mandates that followed (item 5, CRICOS-Australian-only, zero-yield, this one). What remains is all of R1; it is next in the standing order and the queue-wait figures in section 5 are the measurement the Q3 ledger replaces.

Every figure was read from the live project (`fxcwkweaxjtknorudmwp`) between 09:20 and 10:05 AEDT on 24 Oct 2026.

---

## 1. Reconciliation: the developer's 14,930 AU courses

The developer's figures come from the consumer API, which serves the active courses of the **224 published AU providers = 14,930 courses** exactly. The platform's AU catalogue holds **26,103** active courses at all AU providers; the other 11,173 belong to providers not yet published (they are not served, by design). Every count below is given on the developer's population (`search.course_documents`, country AU) and reconciles to theirs within one course.

| Developer's figure | Platform, same population | Match |
|---|---|---|
| 14,930 AU courses | 14,930 | exact |
| 6,885 (46%) no start months | 6,884 | exact |
| 3,182 (21%) no English | 3,181 | exact |
| 25% no official link | 3,732 (25.0%) before today; **3,800 → after today's fill, see section 3** | exact |
| 1,742 no tuition; 46% "worked out from total" | 99 with no tuition at all; **8,461 (57%)** carry only the CRICOS registered total (the API derives the yearly figure); 6,370 carry a provider yearly fee. The 1,742 is their count of courses whose derived figure the frontend could not compute (basis not annual and no length) — the flag they need already exists: `tuition.annual_is_derived` on the course item | explained |
| 45 universities, no descriptions | 45 published universities, 0 with a description; 14,767 of 14,930 courses without one | exact |
| 7 universities without rankings | 38 of 45 carry QS and THE; 7 missing | exact |
| 898 scholarships; 63 with eligible countries; 479 with deadlines | 898 published; 63 with nationalities; 479 with a closing date | exact |

---

## 2. Triage — the 10 gaps

Stored copies are the fuel: **11,106 of the 14,930 (74%)** have a bound page with a stored copy, and the AI reader had never read **4,572** of those copies before today.

| # | Gap | Platform holds today (developer population) | Admits from stored pages via existing lanes **now** | Needs | Effort | Expected at 24 h / 7 d | Tier |
|---|---|---|---|---|---|---|---|
| 1 | Academic entry requirements | no field, no column (0%) | nothing: no reader, no column | the section-5 spec of the field-admission file (table beside the course, AI reader with quote-on-page, supersession, settings) — approved to proceed; NZ + AU, stored pages first | 2.5 days | 0 / first rows in 7 d once built | **BUILD (first)** |
| 2 | Start months | 8,046 have intakes (54%); 6,884 do not; 3,131 of the missing have a bound page with a stored copy | **exhausted**: the Enrich fields lane has already read 3,121 of those 3,131 copies for intakes and found no month (2,394 "the page does not state it", 303 "the quote names no start month or semester", 390 carry a mis-labelled reason — see section 3); today's task confirmed it (1 filled of 1,269 items) | the 3,753 missing courses with **no** correct page need binding (R2); months for the rest need the **intake calendar lane** (`provider-calendar-intakes`, switched off) or the provider's intake page rather than the course page | 0.5 day to switch calendars back on for AU (policy: the Platform Admin's call) | +0–20 / +50–150 (R2 bindings only) until calendars run | SMALL BUILD (calendars) |
| 3 | Tuition | 14,831 have a fee; 8,461 registered-total only; 99 none | nothing to admit: the yearly figure is derived in the API and flagged `annual_is_derived` on the course item; the search document does not carry the flag | additive API field on the search document (`provider_annual_is_derived`) so lists can show "worked out from the registered total" — G3 additive; the fee reader for AU course pages is a policy decision (`fees.countries` is NZ, CA by the Platform Admin's choice; AU fees come from CRICOS) | 0.5 day | no change in counts; the flag becomes visible on lists | SMALL BUILD |
| 4 | English requirements | 11,749 (79%); 3,181 missing; 1,717 of the missing have a bound page with a stored copy | **exhausted on course pages**: 1,698 of the 1,717 copies have been read for English and state no IELTS score (the course page defers to the provider's English policy page) | the **central English policy** lane per provider (`central_ai_enqueue_v1`): the provider-level default admits to every course without a page-stated score — fire for the 29 universities with the largest English gaps | 0 (existing lane) | +0 / +400–900 if the provider policies admit | **QUICK WIN (next step, central lane)** |
| 5 | Official course links | 11,198 (75%) before today | **item 5 fill, widened to AU + CA today: 16,889 AU and 1,863 CA links filled** (10,442 of them on the developer population); AU published with a link now **11,130 of 14,930 (74.5% → the API shows it after the next search refresh)** | the remaining 3,800 are unbound courses (R2) | 0 | done today / +0–200 as R2 binds | **DONE** |
| 5b | Course descriptions | 163 of 14,930 | nothing: no reader | an AI description reader over the stored copy (quote-on-page: the description must be sentences on the page, ≤ 600 chars), written to `courses.description` (exists, nullable, already served) — approved to build if copies cover the population: they do (74%) | 1.5 days | 0 / +6,000–8,000 once built | BUILD |
| 6 | University descriptions | 0 of 45 | nothing: no reader; `providers.description` exists | the same reader on the provider's home or about page (stored by `site_check` / `logo_find` reads), 45 pages | 0.5 day (with 5b) | 0 / 45 | SMALL BUILD |
| 7 | Campuses | 14,930 have a campus; full lists missing (UNSW 4 of 7) | the Enrich fields `campus` reader needs the provider's **admitted campus list** (`provider_fill`); UNSW's list holds 4 | a campus-list refresh per university from its stored campus page (`provider_fill`, existing task) — fire for the 45 universities | 0 | +0 / +50–150 campuses listed | QUICK WIN (next session: needs the campus pages stored) |
| 8 | Scholarships | 898 published; nationalities 63; closing dates 479; eligibility summaries 52; min academic 123; 23 value notes contradict amounts | the scholarship AI reader (`scholarship_ai`, pinned model, quote-on-page) already reads the stored scholarship page; nationalities and closing dates come from it when the page states them | a second pass of the reader asking for eligibility summary, minimum academic result and the value-note consistency check (reject a note that contradicts the amount) — settings-keyed re-read of the 898 | 1 day | 0 / +100–250 nationalities, +50–100 deadlines | SMALL BUILD |
| 9 | Rankings | 38 of 45 with QS and THE; 7 missing; older QS editions not held | nothing: rankings are Layer 1 (official QS/THE editions); the 7 are unranked in the editions held | load earlier QS editions (Layer 1 ETL, `statistics-edition-discovery` monthly) | 0.5 day | 0 / 7 universities marked "not ranked in this edition" rather than missing | SMALL BUILD |
| 10 | Graduate results | QILT held; 4 providers missing (UNSW, Adelaide, UQ College, USQ Sydney) | nothing from pages: QILT is a register | map the 4 to their QILT institution names (UNSW and Adelaide are name mismatches after the Adelaide merger; UQ College and USQ Sydney are not surveyed separately) | 0.5 day | 0 / 2 of 4 | SMALL BUILD |

---

## 3. Fired and executed today

| Action | Count | Record |
|---|---|---|
| **Official-link fill widened to AU + CA** (`course_url.fill_countries` NZ → NZ, AU, CA; logged Settings change; batch raised to 5,000 for the first runs and set back to 2,000) | 4 runs: **16,889 AU + 1,863 CA + 1 NZ links filled, 0 retracted**; AU published courses with a link 11,198 → **11,130 of 14,930 after the search refresh** (the fill reached 10,442 published courses; the earlier 1,132 links stay) | `docs/platform/wrong-page-values/PASTE-20261024-au-quick-wins-fire.sql`, control events `course_url_filled` × 4; search refresh requested |
| **AU Enrich fields task** (intakes, English, duration, campus, delivery, international) for 29 AU universities (RMIT, UTS, UNSW, Monash, Griffith, Adelaide, Wollongong, Curtin, Swinburne, Deakin, La Trobe, Melbourne, ECU, CDU, Torrens, VU, Canberra, Flinders, SCU, TAFE International WA, UNE, UniSC, TAFE Qld, Collarts, Bond, Alphacrucis, TAFE SA, Melbourne Polytechnic, CSU) | task `77c5a3bf…`, 1,269 items, **finished within the hour: 1 filled (intakes), 1 for review (a campus list), 1,267 skipped** — 1,113 because the course's only page is a mismatch (correctly refused: the lane reads no wrong page), 132 read from the stored copy and not stated, 7 campus items with no admitted campus list. The triage line "4,572 copies never read" was wrong: the lane keys on course + field, and the standing hourly task had already read 3,121 of the 3,131 intake-gap copies and 1,698 of the 1,717 English-gap copies (section 2). **The AU intake and English gaps on bound pages are a page-content fact, not a backlog.** | `docs/platform/wrong-page-values/PASTE-20261024-au-quick-wins-fire.sql`; Task manager |
| **Central AI (provider policies)** enqueued for every published AU provider with an intake or English gap: the lane reads the provider's stored English-policy and intake-calendar pages and writes **proposals**; a person approves each (nothing activates on its own) | 206 providers checked, **94 fact sources enqueued for 32 providers** (the other 174 have no stored policy page, or their proposals are already approved or waiting); queue now 99 | same paste file; Settings › Provider policies for the approvals |
| Zero-yield coordination | nothing fired on any page the zero-yield flow has reset (48 UoA pages); the AU task has no UoA pages | — |

**Finding to carry (F9):** 390 intake items on AU bound pages carry the reason "only a site-wide line mentions international" (a reason that belongs to the `international` field) and no quote; 303 carry "the quote names no start month or semester" with no quote stored. Neither can be audited after the fact; the reader should keep the quote it rejected. Logged for R1's Q4 pass over the enrich lane; no re-read fired today (a re-read without the fix would produce the same unauditable rows).

Not fired, with reasons: AU fee reader (policy: `fees.countries` excludes AU by the Platform Admin's choice; AU fees are the CRICOS register); campus-list refresh (the stored campus pages for the 45 universities need checking first; next session); provider calendars (`provider-calendar-intakes` is switched off; switching on is the Platform Admin's call because it writes intake dates from calendars for every course of a provider).

---

## 4. Round-the-clock ingestion: the schedule audit

Every lane is a `pg_cron` job and every one runs on a minute, 2-, 3-, 5-, 10-, 15-minute or hourly cadence **across all 24 hours**; there is no overnight window, no weekday gate and no job that waits for a person. Audit of the 136 jobs (131 active):

| Lane | Cadence | Idle in the last 24 h? | Why | Depends on a manual nudge? |
|---|---|---|---|---|
| Course-page read (`coverage-read`, `-2`) | every 30 s, two calls | yes, most of the day | **no eligible work**: 4 pages due now; the sweep gave it 3,675 and it cleared them in 42 min | no |
| Fee reader | every minute | yes, after the sweep drained | no queued work (0 now) | no |
| Enrich fields (task runner) | every minute; standing task hourly | no | always has items | no |
| AI page match + prepare | every minute / 2 min | yes | no courses to match for focus providers (0 ready) | no |
| Reidentify | every minute | no (7,003 pages under the new rule) | — | no |
| Course-page search (`course-link-search`) | every minute | **yes, by the scheduler's gates** (2,816 queued, 0 picked) | R2 / Q1 | no, but blocked |
| Source finder | hourly-ish (`16-59/20`) | partly | step-carry-over design; `work.again` nudges exist (transition re-check, zero-yield) | by design |
| Central AI (policies) | every 5 min | no | — | no |
| Provider calendars | — | **switched off** | `provider-calendar-intakes` inactive | yes: switch on |
| Scheduled tasks (reports) | hourly :03, daily 06:47 / 07:15 / 07:35, 13:19 IST | n/a | reporting only | — |

**The standing invariant:** *no lane sits idle while eligible work exists in its own queue; where a lane is idle because its queue is empty, the invariant chains upstream — the binding and search lanes must be producing, and a lane that cannot produce because of a gate (not a budget) is a defect.* Status today: every reader lane honours it (they drain to zero and idle on an empty queue); the one lane that breaks it is the **course-page search**, idle on 2,816 eligible courses because of the scheduler's gates — that is R2 (Q1), unchanged, and it is the root of the readers' idleness. R1's Q2 backoff must keep its maximum short (`tick.backoff_max_minutes` ≤ 15 in the plan) and reset on any new eligible work, so it never turns an empty-tick saving into an idle lane with work waiting.

**What changed today:** the official-link fill now runs for three countries nightly; the zero-yield detect job runs hourly; the AU enrich task is queued; nothing was throttled. Neither this mandate nor the zero-yield flow slows any lane: zero-yield resets at most `zero_yield.reset_per_provider` pages a provider a run and only with automatic resets on (off).

---

**Correction (24 Oct 2026 10:05, recorded in [2026-10-24-au-builds-and-enrichment-jobs.md](2026-10-24-au-builds-and-enrichment-jobs.md) section 1).** The line above — no sleep windows — was wrong. The idle guard (flag unit) pauses a worker lane after 30 empty calls and tries it again after six hours and more, waking it early only for three modes. At 10:05 coverage-read and coverage-read-2 had been paused since 09:40 with a next trial at 15:40; central-find, find-site and the contact-page lane were paused the same way. R1 (v2.15.339) caps the wait at `tick.backoff_max_minutes` (15) and gives 13 lanes a "work is waiting" wake-up test; the four lanes paused before the release had their next trial brought forward to the cap (logged).

## 5. Hourly lag

**Where the hourly report reads from:** the scheduled task "StudySearch hourly stats" at :03 reads `pipeline.stats_15m` (written at :01, :16, :31, :46) and `pipeline.gap_cause_snapshots` (written at :55). Its figures are therefore at most **2 minutes old for the stats and 8 minutes old for the gap causes** when it runs — the report itself does not lag an hour. What lags is the *work*: a value admitted in the hour is counted, but work queued in the hour is often still waiting. Measured from queue timestamps (the ledger, Q3, replaces this measurement):

| Lane | Finished in 24 h | Queue wait p50 | p90 | max | Reading |
|---|---|---|---|---|---|
| Fee reader (`fee_reader_queue` created → finished) | 4,165 | **71 min** | **577 min** | 1,032 min | throughput-bound during the sweep burst (one call a minute, up to 40 pages a call, 4 at once); the queue is now 0 |
| Enrich fields items (created → finished) | 45,078 | 18 min | 13,110 min | 13,265 min | the p90 is old items the standing task re-touches; fresh items finish within the hour |
| Course-page read (due → read) | — | — | — | — | the sweep's 3,675 were read in 42 min (≈ 100 a minute); nothing due now |
| AI page match | 1,293 | minutes | — | — | — |

**Before / after:** before the sweep the fee reader had nothing to wait for; during it the wait rose to 9.6 h at p90 because 2,737 pages arrived in one minute and the lane reads about 900 an hour; after, 0 queued. The fix for a burst is lane capacity (`fees.concurrency`, `fees.course_pages_per_tick`, the fee-reader cadence) — all settings — but by F6 no value is raised before R3's tripwire is live. **R3 (health-hourly at :11)** is the hourly-lag fix proper: it prints the per-lane queue wait from the Q3 ledger and the headline metric, so a lane that does not finish its hour's work is seen within the hour.

---

## 6. Builds started

None of the builds was started in this session beyond the triage — honestly recorded. In priority order, each with its settings keys and estimate, ready to start next:

| # | Build | Settings keys | Estimate |
|---|---|---|---|
| B1 | Entry requirements (academic), NZ + AU, stored pages first — spec: field-admission file section 5 | `entry.max_rows_per_course` (1–10, 6), `entry.min_confidence` (0.5–1, 0.8), `entry.countries` (list) | 2.5 days (table + admission 1; reader 1; test, rules, SOP line 0.5) |
| B2 | Course descriptions reader over the stored copy → `courses.description` | `description.max_chars` (200–1,000, 600), `description.min_confidence` (0.5–1, 0.8), `description.countries` | 1.5 days |
| B3 | University descriptions (45 AU, then NZ/CA) from the stored home/about page → `providers.description` | shares B2's keys plus `description.provider_pages` (list of page kinds) | 0.5 day with B2 |
| B4 | Scholarship second pass: eligibility summary, minimum academic result, value-note consistency | `scholarship.second_pass_batch` (10–500, 100), `scholarship.note_amount_check` (0/1) | 1 day |
| B5 | `provider_annual_is_derived` on the search document (additive) | none | 0.5 day |
| B6 | Rankings: earlier QS editions; graduate results: QILT name mapping for 4 providers | none | 1 day |

All additive on the consumer API (Decision 266); quote-on-page for every AI reader; existing apply paths.

---

## 7. Expected AU coverage per gap (developer population, 14,930)

| Gap | Today | 24 h | 7 d | How |
|---|---|---|---|---|
| Official links | 75% → **74.5% served after refresh** (11,130; the fill reached every policy-allowed bound page) | 75% | 76–77% | R2 binds more |
| Start months | 54% | 54% | 54–55% | the bound pages do not state months; only new bindings (R2) or the calendar lane (switched off) move this — quote 54% until the calendar decision is made |
| English | 79% | 79% | 79–85% | depends on the Platform Admin approving the provider-policy proposals the central lane writes from today's 94 enqueued pages; each approval fills every course of that provider |
| Tuition (any) | 99.3% | 99.3% | 99.3% | the derived flag is the change, not the count |
| Descriptions (course) | 1% | 1% | 1% until B2 ships, then 40–55% within a week of it | B2 |
| University descriptions | 0 of 45 | 0 | 0 until B3, then 45 | B3 |
| Campuses (full lists) | city + postcode for all | — | +50–150 campuses once the lists refresh | provider_fill |
| Scholarships (eligible countries) | 63 of 898 | 63 | 63 until B4, then 160–300 | B4 |
| Rankings | 38 of 45 | 38 | 38 (+ "not ranked" states after B6) | B6 |
| Graduate results | 41 of 45 | 41 | 43 after B6 | B6 |
| Entry requirements | 0% | 0% | 0% until B1 ships | B1 |

---

## 8. Blocked on the Platform Admin

O5 (NZQA signatory list URL), O8 / O9 (Firecrawl and OpenRouter plan tiers and caps). Nothing else is blocked; two policy choices sit with the Platform Admin and are recorded, not pressed: the provider-policy proposals from today's central-lane reads need approving as they arrive (Settings › Provider policies), and the calendar lane (`provider-calendar-intakes`) stays off until switched on.

---

## 9. Runbook addition (one section)

**Official links for AU and CA.** The nightly `course-url-fill` job now fills links for NZ, AU and CA (Settings › Pipeline settings › Official link: countries filled). A link filled by the platform is retracted automatically when its page is no longer bound; a person-set link is never touched. To see today's fills: `select detail from pipeline.admin_control_events where action = 'course_url_filled' order by created_at desc`.

---

## 10. Mandate as received (24 Oct 2026, 09:17)

> Mandate — AU quick wins from the website developer's data-gap review, round-the-clock ingestion, and the hourly-lag fix. Reconcile the developer's figures (14,930 AU courses, 23 Oct) against the live catalogue. In scope: academic entry requirements (no field; reference the existing spec), start months (46% missing), tuition (1,742 none; derived flag visible), English (3,182 missing), official links (25% missing) and descriptions, university descriptions (45), campuses (full lists), scholarships (eligible countries 63 of 898, thin details, 23 contradictory value notes, deadlines 479), rankings (7 missing, older QS), graduate results (4 providers). Out of scope: the Suajata project, hand-typed page facts, frontend bugs. D1: per gap — holds today → admits from stored pages now → small build → effort → expected at 24 h / 7 d → tier; approve widening `course_url.fill_countries` to AU + CA (apply, logged); approve description and scholarship readers behind settings keys if stored copies cover the population; execute the quick-win tier today. D2: audit the 24-hour schedule; state and make true the invariant that no lane idles while eligible work exists; fix the hourly lag with queue-wait percentiles (ledger, or queue timestamps until it exists); confirm nothing throttles ingestion and zero-yield wins on pages it resets. Coordination: R1 status in the first lines; entry requirements approved to proceed, first among builds.
