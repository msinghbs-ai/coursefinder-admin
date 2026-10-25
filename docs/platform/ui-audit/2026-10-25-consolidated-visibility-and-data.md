# Consolidated mandate — visibility and data (25 Oct 2026) — decision record

Platform Admin, 25 Oct 2026 12:15 (attachment): "Consolidated mandate — decisions recorded, then execution across five parts. … CF-247 applies; this file is the decision record. Nothing merges without Platform Admin review. The catalogue list STRUCTURE stays frozen — only column CONTENT and the detail blade change. No new pages; the blade and existing panels are the only surfaces. One release at a time, merged and alive before the next starts."

## Decisions

| Ref | Decision (Platform Admin 25 Oct 2026) | Recorded effect |
|---|---|---|
| **D-calendar** | "provider-calendar-defaults STAYS OFF, catalogued for retirement (Replaces/Retires; superseded by the page-period→month route — course-page evidence only, per the 22 Oct "page-only months" decision). The policy paste file's calendar check (period-route only, R60 allowed, the 27 no-op rows refused) is CORRECT — keep it." | The job is already off and `retiring` in `pipeline.component_register` (migration `20261022042000`). The retirement migration names `security.enrich_parse_intake_periods_v1` (Enrich fields) as its replacement, and the drop goes by paste file after `hygiene.retire_after_days`. It rides with the next Track B release (no new release for it). The paste file stays as it is; you can now mark the 49 calendar rows |
| **D-auto-approve** | "central.auto_approve STAYS ON, with both visibility conditions mandated in Part D as work items, not options." | Part D items 1 (decider display) and 4 (acceptance report) are work items, not options |

## Sequencing (as mandated)

1. **Part A:** hotfix → merge → evidence.
2. **Track B (UI), in order:**
   - **R1:** Fields section + Pipeline strip + stored-copy-first.
   - **R2:** decider display + "has recommendation" filter + D-L4-1 and the pointer sweep.
   - **R3:** acceptance report + field-admission map.
3. **Part E** (provider description reader) rides with Track B.
4. **Part C** is read-only alongside; its fill proposal comes to the Platform Admin before any write.
5. **Track A** (S1 + 8a) continues in parallel and is not displaced.

---

## Part A — hotfix: list columns show "—" while the blade shows data

### Root cause (measured live 25 Oct 2026, evidence quoted)

**The list and the blade read the same rows.** The difference is the *sort*.

| | List (Courses) | Blade (course details) |
|---|---|---|
| Call | `admin_read('courses_page')` → `security.admin_course_page_fast` → `security.admin_course_page_fast_base` | `admin_read('course_detail')` |
| International fee | `catalogue.course_fees` where `fee_type='provider_current_tuition' and audience='international' and status='active'`, latest `fee_year` | the same table and rows (fee summary "provider_current") |
| City | `catalogue.course_campuses` → `catalogue.campuses.city` | `catalogue.course_campuses` → `catalogue.campuses` (campus pills) |
| State / Region | campus subdivisions; when the course has no campus, the provider's subdivision (`region_source` 'campus' / 'provider') | same: e.g. UCOL 2664 shows Manawatū-Whanganui from the provider in both |

`admin_course_page_fast_base` builds the International fee and City columns in its normal path. Two sorts leave that path: **Completeness** (`sort 'completeness'`) and **Tuition Only** (`sort 'fee'`). For those, it hands the page to the older `public.ui_courses_decision_page`, quoting the function:

> `if v_sort in ('fee','completeness') then return security.admin_course_page_search_state(public.ui_courses_decision_page(…))`

`ui_courses_decision_page` rows never carried `intl_fee_*` or `city_names`, and `security.admin_course_page_search_state` only adds search-copy flags. So the frontend renders "—" for every row: `if(key==='intl_fee_amount')return v!=null? … : '—'`.

Live, NZ filter, first page of 50 rows:

| Sort | Rows with International fee | Rows with City |
|---|---|---|
| Course (A–Z) | 22 | 30 |
| International fee ↑ / ↓ | 50 / 50 | 36 / 42 |
| City ↑ | 31 | 50 |
| **Completeness ↓** | **0** | **0** |

The top row under Completeness is Lincoln LI4245 (Bachelor of Agribusiness and Food Marketing). The same call sorted by Course returns `intl_fee_amount 37000, city_names "Lincoln"`.

- The screenshot's "L14245" is LI4245.
- Not NZ-specific: any country sorted by Completeness or Tuition Only.
- Not a pending refresh: no search copy is involved.

**SIT 2935 and UCOL 2664 (also named in the mandate) genuinely have no fee, campus, intake or English on record.** The blade also shows them empty: `fees: [], campuses: [], intakes: []`, value_state `not_collected` and `source_missing`. "—" is correct for those two. Their gap is data, not display (both are NZQA register imports with no page bound: `course_url null`).

### Fix (v2.15.351)

Migration `20261025001000_cf247_list_columns_on_every_sort.sql`, md5-guarded edit of `security.admin_course_page_search_state`. Its only caller is that branch. The edit adds to each row, from the same tables and with the same row choice as the normal path:
- `intl_fee_amount`, `intl_fee_currency`, `intl_fee_year`, `intl_fee_basis`;
- `city_names`;
- `display_code`, `code_kind`;
- `open_to_international`, `open_to_domestic`.

Order, filters and totals are unchanged. Formatting is the list's own (blade style: amount, year, basis); "—" only when the course truly has none. Both columns already sort (`intl_fee`, `city`). Admin read only; consumer API untouched. Test s103.

Dry run against live (rolled back): NZ sorted by Completeness: **0 → 50 of 50 rows with an International fee, 0 → 49 with a City**; LI4245 `37000.00 / Lincoln / LI4245`.

### Evidence after merge

See "Part A — execution log" at the end of this file.

---

## Part B — per-course pipeline visibility (spec; Track B R1)

Surfaces: the existing course blade only (`CourseDetailPolish` / `CourseAudit` in the catalogue detail panel). No new pages.

### B1 Fields section

One chip per field, in this order: fee, English, intakes, duration, campus, delivery, link, description, level, field.

| State | Rule | Wording source |
|---|---|---|
| Filled | the active admitted value exists (same rows as the blade's existing facts) | value plus its source label |
| Empty, with cause | no value | **the existing gap-cause vocabulary only** (`security.gap_causes_snapshot_v1`'s per-attribute causes, e.g. "no page: web search stopped for this university", "fee reader found no fee on the page", "AI: page gives no start dates; university calendar approved") |
| Stale | the value's source is older than the setting | "older than N days" plus the date |

- Staleness comes from the page's `bound_at` and the evidence `captured_at` (`as_at` for fees).
- Description has no attribute of its own in the vocabulary. It uses the generic page causes ("no page found", "page not read: …", "AI: the page does not state it"). Link uses `official_page`.
- No new status values.

**Hidden effort.** The causes are computed in aggregate (`pipeline.gap_cause_snapshots` holds country × attribute × cause counts). The classifier is lifted into `security.course_gap_causes_v1(course_id)`, and `gap_causes_snapshot_v1` is rebuilt on top of it, so there stays one vocabulary and one set of rules. The snapshot totals must match before and after (contract test plus a live check).

### B2 Pipeline strip

For this course: BINDING → READ → FEE / ENGLISH / INTAKES / ENRICH. Each stage shows state, last run, "where to follow" and the action. All of it renders from live state, not documentation.

| Stage | State from | Where to follow (named, real) | Operator action when stalled (existing mechanism, role) |
|---|---|---|---|
| Binding | `pipeline.coverage_course_pages` (status, `bound_at`, basis); `pipeline.course_link_search` (queued / sent, stop) | Task manager (Find course pages); stall cause `security.link_search_block_v1` | Queue search: `admin_jobs start course_page_find` (Operator+) |
| Read | `coverage_course_pages` (`read_status`, `read_at`, `http_status`, `fetched_via`, `next_read_at`) | evidence (stored copy); `admin_control_events` (course, read_now) | Queue read: `admin_course_read_now` (Curator+); see B3 |
| Fee | `pipeline.fee_course_requests`; Layer 4 fee items | Layer 4 › Course link (fee); fee reader queue | Queue fee: `fee_course_requests` upsert (Curator+) |
| English / Intakes / Enrich | `pipeline.field_enrich_items` (state, reason) | Task manager (Enrich fields); Layer 4 | Queue enrich: `enrich_fields` task for this course (Curator+) |
| Spend | `pipeline.coverage_vendor_usage` (the ledger) for this course | Models & services › usage | — |

The mandate's "extraction_runs" does not exist in this database. The real follow-paths are the ones in the table; the strip names only objects that exist.

### B3 Stored-copy-first: verification result (live, 25 Oct)

**Not met today.** "Read with AI" (`public.admin_course_read_now`) always sets the bound page `next_read_at = now(), read_attempts = 0`, so the page reader fetches the page again. The fields then wait for the *new* page: `insert … state = case when v_page > 0 and f <> 'campus' then 'waiting'`, from the Platform Admin's 23 Oct 09:03 "the fields wait for the new page (not the old copy)".

- 42 of the 57 "Read with AI" requests so far re-fetched.
- The reader goes direct first: over 3 days, 4,610 direct fetches and 1,222 via Firecrawl (about 21%).

Fix in R1:
- A stored copy no older than `read_now.stored_copy_max_age_days` (setting, default 14 days) is replayed from Supabase storage: the AI fields, fee reader and English read it at once, with no fetch.
- A fresh fetch happens only when there is no stored copy, it is older than the setting, or the operator ticks "Fetch the page again" (logged with the reason).
- This changes the 23 Oct 09:03 behaviour, so the Platform Admin should confirm the default (14 days) at R1 review.

### B4 FIELD-ADMISSION-MAP.md

`docs/platform/FIELD-ADMISSION-MAP.md`, generated from the live catalogue (`automation_catalogue`, `component_register`, admission rules, settings `used_by`) plus code. Per field it lists:
- admitting mechanisms;
- layer;
- landing table and columns;
- follow-path;
- failure surfaces (gap causes, Layer 4 kinds, flags).

Regenerated by a catalogued weekly job, `field-admission-map` (GitHub workflow like the Component register; the generated file lands on a `field-admission-map-snapshot` branch and the docs copy is refreshed by PR). Each blade chip links to its field's section.

**R1 settings:**
- `blade.stale_after_days` (180, range 30–720, days, Course details);
- `read_now.stored_copy_max_age_days` (14, range 0–90, days, Course page reading; 0 = always fetch, today's behaviour).

**Estimate:** about 2.5 days build + suite; no Firecrawl or AI spend (B3 lowers spend).

---

## Part C — "3,954 unnamed NZ courses": quantification (read-only)

**There is one unnamed NZ course, not 3,954.** Southern Institute of Technology, NZQA qualification **3954**, title "--" (`course:nzqa:6015:3954`, created 12 Aug 2026 from the NZQA register import, active, unpublished, 1 link). It sorts first under Course A–Z, so it heads the NZ list. Its course code (3954) reads like a count in the screenshot.

Checked across all NZ courses:
- titles empty, punctuation or digits only, under 6 characters, or equal to the code: **1** (this one);
- active NZ courses at a provider with no name: **0**.

So nothing blocks search or binding at scale. The NZQA mapping is not broken: the other NZ courses carry register titles.

**Fill proposal (for approval; no write made).** Read the stored NZQA register snapshot this course came from (evidence `regulatory/NZ/nzqa/2026-09-26…batch-5.json`, from storage, no fetch) for qualification 3954:
- **(a)** If the register gives a title, a count-guarded paste (1 row, `canonical_title` from the register, register as source, no page quote needed) sets it.
- **(b)** If the register itself has no title for 3954 (a withdrawn or placeholder qualification), a count-guarded quarantine paste (status change, reversible), as for unverifiable courses.

If "unnamed" meant something else on your screen (for example "Unnamed on the register" providers, or course titles that are only a code), tell me and I will quantify that instead.

---

## Part D — follow-on UI items (specs; Track B R2 then R3)

### D1 Decided-view decider (work item, D-auto-approve condition a) — R2

- Layer 4 › Decided gains the central-policy decisions alongside its own: both a person's (`admin_provider_policy_decide`) and the automatic ones (`policy_auto_approve_v1`).
- **By** shows the person's name, or **"Automatic: disagreement check passed (N agree, M differ)"**.
- The same marker shows in Layer 2/3 › Operations › Approvals waiting › Show: Decided.
- **N and M at the moment of decision:** `policy_auto_approve_v1` (md5-guarded edit) writes `agrees`, `differs` and `decider: 'automatic'` into its `admin_control_events` row from now on. For the 111 earlier automatic approvals (14 Oct 23:34 → today: 52 English, 59 calendars), the counts at decision time were not kept. They show "counts at the time not recorded; now N agree, M differ" from `plan_summary`.
- Display only, no API change.

### D2 Layer 4 "Has recommendation" chip — R2

A filter chip on the existing Inbox views:
- **Has recommendation:** the item carries a pre-filled proposal (`proposed_value` not null, or a staged proposal batch).
- **Needs judgment:** everything else.
- Counts appear on the chip; no new status.

### D3 D-L4-1 fix and pointer sweep — R2

- An Inbox kind **"Central policy"** counts every waiting `provider_policy_proposals` row, shows the oldest wait, and links to Layer 2/3 › Operations › Approvals waiting.
- Stale texts corrected: `svc_central_ai_record` ("Providers › Onboarding › Approvals waiting") and `gap_causes_snapshot_v1` ("Layer 4 › Attributes").
- **Pointer sweep:** every Inbox, gap-cause and flag text that names a location (pattern "X › Y") is listed and checked against `src/nav-map.js` (pages, tabs, MOVED maps).
- **Standing check:**
  - a contract test fails the build when a text in a migration or the UI names a "page › tab" that nav-map cannot resolve;
  - a weekly catalogued job `pointer-check` does the same against live function bodies and raises a flag.

### D4 Acceptance report (learning-loop Phase 2; work item, D-auto-approve condition b) — R3

Weekly (Monday), per kind:
- proposals made;
- accepted / edited / rejected (acceptance rate);
- reversals by a person;
- course pages read later that disagree with the admitted value;
- Layer 4 English reviews opened against an admitted default.

Automatic approvals count as first-class decisions (decider "automatic"). The report feeds the auto-admit escalation rule, which stays **OFF** by default (`layer4.auto_admit.<kind>` 0). The surface is the existing Layer 4 page (a "Report" view beside Decided) plus the weekly scheduled report line.

**Settings:**
- D2: none.
- D3: `pointer_check.enabled` (1).
- D4: `report.acceptance_window_days` (7, range 7–28, days); plus the auto-admit settings already designed in the triage record (`layer4.auto_admit_threshold` 0.95, `_min_decisions` 50, `_cycle_days` 7, `_sample_one_in` 10, per kind 0).

**Estimates:** R2 about 1.5 days; R3 about 2 days (report plus map). No spend.

---

## Part E — provider description reader (spec; rides with Track B)

**Today (live):** `catalogue.providers.description` is empty for **every** AU, NZ and CA provider (0 with a description). Central-page discovery (`pipeline.provider_fact_sources`) knows only `english_policy`, `fee_schedule` and `intake_calendar`. No "about" page is held for any provider, including Wollongong: 11 central pages stored, none an about page.

Design:
1. **Source.**
   - A new fact kind `about_page` in the existing central-page discovery.
   - Candidates: the provider's `website` domain plus `description.about_paths` (setting: `/about`, `/about-us`, `/about-us/`, `/why-<name>`), plus links titled About on the stored home page.
   - Stored copies first; a Firecrawl fetch only where storage holds no about page (≈ 45 credits for AU's 45 universities at most).
2. **AI consolidation.**
   - One model call per provider, pinned to an individually qualified model (`description.model`, no "auto" routing).
   - It writes a short factual description: location, type, scale and the strengths the provider itself states, for a prospective international student.
   - Rules:
     - no superlatives at all ("leading", "world-class" are dropped even when on the page);
     - no claim that is not on the page;
     - no marketing voice;
     - ≤ `description.provider_max_chars` (400);
     - Australian English.
   - It returns the exact source sentences used, kept as the evidence quote. Every claim must be found in the stored page text, or the description is refused.
3. **Provenance.**
   - New additive columns beside the field: `description_source_url`, `description_as_at`, `description_model`, `description_run_id`, `description_ai_consolidated` (boolean), `description_quote`.
   - The consumer API is unchanged (G3): the website reads `description` as today. Exposing the "AI-consolidated" label to the website is an API change that needs your approval; it is recorded, not done.
   - Catalogued job `provider-description-refresh` re-reads only where the stored about page's `content_hash` changed. Never a blind re-read.
4. **Scope.** AU's 45 universities first, then NZ and CA by course count.
5. **Guardrails.**
   - No source, no description.
   - A manual lock on `providers.description` is respected (a person's text is never overwritten).
   - `description.enabled` stays 0, and the refresh job inactive, until 5 descriptions are hand-verified against their about pages.
   - A passing check never switches it on by itself.

**Settings:** `description.provider_max_chars` (400, range 200–800, characters), `description.about_paths` (JSON list), `description.model`, `description.enabled` (0), `batch.provider_description` (10, range 1–50, providers a run), `description.countries` (["AU"]).

**Cost:** AU about 45 model calls (well under US$0.50) plus at most 45 Firecrawl credits. **Estimate:** about 1.5 days build.

**Wollongong acceptance test: source confirmed, run pending the build.**
- `https://www.uow.edu.au/about/` is live and holds the "About UOW" paragraph. Quoting the page: "The University of Wollongong (UOW) is a leading Australian university with a global reputation for excellence in education, research, and community engagement." and "With deep regional roots and a vibrant global network, UOW offers a personalised, inclusive experience that values every student while driving positive change locally and internationally."
- The page places UOW in Wollongong, New South Wales, with 35,076 students and 2,586 staff.
- This is a direct test of the no-superlatives rule: "leading" and "excellence" must not survive into the description.
- The test runs on the first build: ≤ 400 characters, sourced from that URL, quote on file, read beside the campus chips. It is reported before the job is enabled.

---

## Remaining decisions for the Platform Admin (pruned)

1. **Part A:** review and merge v2.15.351 (PR below); confirm on screen (Courses, NZ, sorted by Completeness) that International fee and City now show.
2. **Part C:** approve fill path (a) or (b) for SIT 3954, or say what "unnamed" meant if not this.
3. **Policy proposals:** mark the 65 rows in the paste file (calendar rows now actionable under D-calendar).
4. **R1 review point:** the stored-copy replay default (`read_now.stored_copy_max_age_days` 14) replaces the 23 Oct "fields wait for the new page" behaviour.
5. **Part E:** later, whether the website may show an "AI-consolidated" label (consumer API change, G3).

---

## Part A — execution log

| When (25 Oct) | Step | Result |
|---|---|---|
| 12:50 | Live dry run of `20261025001000` (rolled back) | NZ sorted by Completeness: fee 0 → 50 of 50, city 0 → 49 of 50; LI4245 `37000.00`, Lincoln |
| 13:20 | Full suite | 1,906 passed; only the 4 known legacy failures (cf-091, cf-103 desktop and mobile); `release:verify` PASS v2.15.351; build OK |
| 13:25 | PR #693 opened | **Not merged: awaiting Platform Admin review.** After merge: the migration's md5 is checked against `schema_migrations`, the live NZ Completeness page is re-run, and the on-screen before/after is taken. The browser pane is not linked to this session, so the screenshot evidence is the Platform Admin's, or comes when the pane is linked |
