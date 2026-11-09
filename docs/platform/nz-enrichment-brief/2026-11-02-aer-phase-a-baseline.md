# CF-247 AER — Phase A baseline and impact assessment (read only)

**Date:** 2 November 2026, live reads 14:48–14:57 AEDT.
**Authority:** Platform Admin, *CF-247 AER Consolidated Development, Coverage Recovery and Continuous Assurance Mandate*, 2 Nov 2026 14:45 (`2026-11-02-aer-consolidated-development-mandate-1445.md`), §16 Phase A.
**Inputs read:** `../ENTRY-REQUIREMENTS.md` (Draft 1.2, §F), `../ENTRY-REQUIREMENTS-IMPLEMENTATION.md`, `../ENTRY-REQUIREMENTS-PROGRAMME-DECISION-2026-10-28.md`, `2026-11-02-aer-qualification-coverage-gap-assessment.md` (AER-GAP-01–10), `2026-11-02-aer-continuous-assurance-mandate.md`, `INDEX.md`, `../STUDYSEARCH-EXECUTION-REGISTER.md`, `../AGENT-OPERATING-MODEL.md`, `2026-11-01-layer4-exception-decision-pack.md` (E11–E13), `2026-11-02-morning-execution-mandate-and-decisions.md`, `../aer-v1.1-build-log.md`, `../ENTRY-REQUIREMENTS-STEP-B-DECISION-2026-10-28.md`.
**Code:** Pilot `main` `72e74da2` = v2.15.405 (clean checkout, not edited). Live migration head `20261102080000` (matches git).
**Method and load:** read-only `SELECT`s on `fxcwkweaxjtknorudmwp` only; `statement_timeout` 8 s; heavier reads in the 14:56–14:57 quiet window; no writes, AI, Firecrawl or edge-function calls; no scan of the course tables except joins keyed by `course_entry_requirements` (about 3,600 rows). Figures are observations at the time stated, not targets.

**What this document is not:** no decision, no schema, no production change. Phase A's last step ("record implementation decisions in the SS execution register") is left to the integrator, with the proposed task identity in §5.

---

## 1. Eligible AU/NZ international-enrolling provider denominator

### 1.1 Rule (from the catalogue's own fields)

A provider is **eligible** when, in `catalogue.providers`:

1. its country (`country_id` → `ref.countries.iso_alpha2`) is `AU` or `NZ`;
2. `lifecycle_status = 'active'`;
3. `publication_status = 'published'`;
4. `enrols_international is true`.

Evidence for rule 4, the international-intent field (not invented here):
- AU: set from the provider's CRICOS registration (`20261020070000_cf247_nz_cop_signatory.sql` header: "Australian providers take it from their CRICOS registration").
- NZ: set by `security.nz_cop_apply_v1` from the NZQA Code of Practice signatory page (`pipeline.nz_cop_status`), basis text `NZQA Code of Practice signatory`; universities set by `20261020100000_cf247_nz_universities_yes.sql`.

Rules 2–3 follow the continuous assurance mandate §1 ("lifecycle/publication/international-intent criteria, reporting unknowns separately").

### 1.2 Live count (14:56 AEDT)

| Country | lifecycle | publication | enrols_international | Providers | Treatment |
|---|---|---|---|---|---|
| AU | active | published | true | **1,279** | **Eligible** |
| NZ | active | published | true | **197** | **Eligible** |
| NZ | active | published | null | 219 | **Unknown** (no NZQA signatory evidence either way); reported separately, not in the denominator |
| AU | active | unpublished | true | 261 | Outside (not published); reported separately |
| AU | archived | unpublished | true | 16 | Outside |

**Eligible denominator: 1,476 providers (AU 1,279, NZ 197).** Unknown: 219 (NZ). Not published but international-enrolling: 261 (AU).

### 1.3 Where the AER programme stands against it

| | AU | NZ | Total |
|---|---|---|---|
| Eligible | 1,279 | 197 | 1,476 |
| With any `pipeline.entry_matrix_sources` row | 19 | 15 | 34 |
| With active `provider_entry_matrix` rows | 5 | 8 | 13 |
| In `entry.providers` (matrix read scope) | 18 | 15 | 33 |
| In `entry.course_read_providers` (course read scope) | 21 | 20 | 41 |

Source-discovery coverage is therefore 34 / 1,476 (2.3%). The AU figure is dominated by small CRICOS providers (colleges, ELICOS, VET); Phase E waves should be ordered by active course count, but that count needs a read of the course tables, which was left out under the load policy (**not measured here**).

---

## 2. Live reconciliation of the ten gaps

RMIT (`8e1adb6c-e069-43db-9584-bd054255e702`): 36 sources, all `status = 'read'`, 36 runs; matrix rows 380 active, 167 superseded, 20 unverified (CN 9, DE 11), **0 proposed** (the "37 proposed RMIT rows" of 28 Oct are no longer proposed). No GB, CH, NG, VN or NO rows in any status.

Reader paths cited: worker `supabase/functions/coverage-sweep/index.ts` (mode `entry_matrix`, lines 2150–2245) and `entry.ts`. The completeness guard runs only for providers in `entry.completeness_providers` (live: RMIT only; `security.entry_completeness_required_v1`, `20261026010000`).

| # | Gap (mandate §8 / register) | Live state (2 Nov 14:56) | Root cause in code | RMIT-specific or reusable |
|---|---|---|---|---|
| 1 | **International Baccalaureate** (AER-GAP-01) | Source read; run `failed`, `held_unparsed: not a country table: no country named in the page heading ("International Baccalaureate Diploma …")`, 26 Oct. 0 rows | `entryNonCountryShape` → `entryPageCountry` (`entry.ts:372–392`), called before any AI read at `index.ts:2192–2199`. The page heading must name a country; a qualification page cannot pass. Data model: `provider_entry_matrix.country_code` is the only scope key; no qualification identity exists | **Reusable.** Any provider under the guard with a qualification-only page fails the same way. Also a model defect for every provider |
| 2 | **Global Assessment Certificate** (AER-GAP-01) | As #1: `held_unparsed … ("Global Assessment Certificate | …")`, 26 Oct. 0 rows | Same as #1 | **Reusable** (same defect) |
| 3 | **United Kingdom 2 of 31** (AER-GAP-02) | Source read; run `failed`, `held_incomplete: 2 of 31 published minimums not read`, 27 Oct. 0 GB rows | `entryCompleteness` (`entry.ts:407–455`, basis `manifest-v1`) correctly fails closed; the AI read (`entryMatrixRequest`, pinned `openai/gpt-4.1-mini`, prompt `entry-matrix-v0.1.4`) returned 29 of 31 manifest cells after the PR A column tie-break (G1) | **Reusable** reader-omission class. The guard that catches it is generic, but the manifest only recognises tables with an "Australian standard" band column (`entryManifestDetail`, `entry.ts:307–368`), so it is RMIT-shaped today |
| 4 | **Nigeria 6 of 17** (AER-GAP-03) | Run `failed`, `held_incomplete: column left out: Senior School Certificate and completion of first year at a recognised university …; 6 of 17 published minimums not read`, 26 Oct | Merged case-by-case column omitted by the AI read on all 3 attempts despite the cell list (`entryCellList`, D4 class; build log §"Still defective") | **Reusable** (merged-cell / case-by-case column class). Fail-closed guard works |
| 5 | **Vietnam hold** (AER-GAP-03) | Run `failed`, `held: AER PR B (table context) not yet built; not read in the PR A recovery (Platform Admin 27 Oct 2026 14:35)`. Earlier attempt: 18 of 31 cells (short read) | No code fault recorded: a **policy hold** waiting for "PR B" (table-context reading), which was never built. The hold text appears in **no checked-in migration** (see §7) | **Reusable** (short-read / table-context class); PR B was scoped as generic reader work |
| 6 | **Norway hold** (AER-GAP-03) | Run `failed`, `held_unparsed: no printed scale: bare numbers in Vitnemal …`, 27 Oct. 0 rows | `entryUnscaledColumns` (`entry.ts:394–402`, R2) — implements the Platform Admin's 27 Oct ~15:00 rule "hold every bare-number column whose scale is not printed" | **Reusable rule, behaving as designed.** Recovery needs official evidence of the scale (another first-party page) or an evidenced case-by-case outcome, not a code fix |
| 7 | **Nepal** (AER-GAP-04) | 11 active NP rows (Nepal HSC / SLC / PC, with and without first-year university). No IB, A Level or US-diploma resolution for a Nepal applicant | Resolver `security.entry_resolve_v1(p_course, p_country)` (latest `20261030280000_cf247_d5_scale_stated_marker.sql`; original `20261028001000`, lines 203–245) matches steps 2–4 on `m.country_code = v_cc` only; `edu_country` is the only consumer input (`website-api-v2/index.ts:141–148`) | **Reusable model gap** (every provider, every global qualification) |
| 8 | **Switzerland** (AER-GAP-04) | 0 CH rows; **no RMIT Switzerland source** among the 36 recorded | Same resolver key as #7; plus discovery: sources are seeded by hand (`found_via = 'manual'` on all 102 sources) | **Reusable** (model) + discovery gap |
| 9 | **Master's backlog** (AER-GAP-05) | `course_entry_first_read`: 499 pending, 498 approved/edited. Proposed course-entry rows by level: MC 309 (74 courses), GC 158, DR 98, GD 92, MA 91, MR 59; active MC 283 (85 courses), MA 144, GD 111, GC 80, DR 24, MR 13. E13 gate (v2.15.401, `20261102010000`) measured **215 of 499** pending items held (162 row cap, 98 shared page, 2 other-programme rows). E11: 298 RMIT reads from the local-student view; E12: 38 QUT mixed reads | Course reader cap `entry.max_rows_per_course` = 6 (`security.enrich_entry_record_v1`, `course_entry_max_rows_v1`); course-entry kinds (`prior_qualification`, `minimum_grade`, `work_experience` …) carry no study-route semantics (coursework vs research, GPA scale, discipline); resolver step 1 uses only `kind = 'override'` | **Reusable** (row cap, page audience, variant pages affect every provider; E13 already proves it across providers) |
| 10 | **Tenth: RMIT Foundation equivalencies** (held source in the same evidence set; AER-GAP-03 "other sources may exist") | Run `failed`, `held_unparsed: not a country table: requirement-type columns, not qualifications (English Requirement 1; Academic Requirement; Prerequisites)`, 26 Oct | `entryNonCountryShape`, `REQUIREMENT_COLUMN` (`entry.ts:371, 384–385`); the Foundation page is a pathway source, which the reader has no classification for | **Reusable** (pathway-source classification) |

Register items not in the §8 case list, reconciled for completeness:

| Register ID | Live state | Note |
|---|---|---|
| AER-GAP-06 scope | `entry.providers` 33, RMIT **not** in it (removed 27 Oct 07:02:15, build log); 28 Oct decision P1 keeps RMIT outside matrix reading | Needs a superseding decision (§4, D-A1) |
| AER-GAP-07 provider URLs | `pipeline.entry_matrix_sources` has no classification, scope, level, edition or "primary" column; Provider details shows no AER sources (no reference in `src/` outside `AerWorkspace.jsx`) | Phase D |
| AER-GAP-08 country-only UI | Consumer input is `edu_country` only; Admin country lists from `src/aer-countries.js` | Phase C/F |
| AER-GAP-09 metric | Confirmed live: all 36 RMIT sources `read`, 7 of their runs `failed`; across all providers 99 sources `read`, 12 runs `failed` | Phase B |
| AER-GAP-10 consumer | Consumer API at its baseline; additive keys need G3 approval | Phase F |

Other providers' holds (not RMIT): 5 PDF `held_unparsed` runs (Auckland ×2 "crosses a column edge", Sydney "outside its columns", UQ "no drawn rules", UNSW "column without row rules") and 3 Macquarie PDF sources `failed` `blocked_pdf`. All reusable PDF-route (Step B) classes.

---

## 3. Current live AER inventory (2 Nov 14:56)

### 3.1 `catalogue.provider_entry_matrix` (26 providers with rows)

| Provider | active | proposed | superseded | inactive | unverified | Countries (largest status) |
|---|---|---|---|---|---|---|
| RMIT | 380 | — | 167 | — | 20 | 28 active |
| AUT | 56 | — | — | 5 | — | 41 |
| SIT | 54 | — | — | — | — | 29 |
| Whitireia and WelTec | 44 | — | — | — | — | 44 |
| Massey | 36 | — | — | 2 | — | 36 |
| Waikato | 35 | — | — | — | — | 35 |
| Unitec | 14 | — | — | 3 | — | 7 |
| Flinders | 12 | — | — | 1 | — | 12 |
| ANU | 11 | 235 | 10 | 1 | — | 11 |
| Ara | 11 | — | — | — | — | 6 |
| Melbourne | 6 | 18 | 34 | 3 | — | 2 |
| Swinburne | 3 | — | — | 4 | — | 1 |
| Otago | 1 | — | — | — | — | 1 |
| Western Sydney | — | 367 | 13 | — | — | 64 |
| Wollongong | — | 220 | 175 | — | — | 43 |
| UWA | — | 177 | 59 | — | — | 15 |
| Victoria University | — | 147 | — | — | — | 24 |
| Wintec | — | 135 | 13 | — | — | 46 |
| Otago Polytechnic | — | 104 | 89 | 106 | — | 59 |
| Lincoln | — | 71 | 63 | — | — | 40 |
| Federation | — | 69 | 58 | — | — | 41 |
| MIT | — | 68 | — | — | — | 41 |
| NMIT | — | 48 | 42 | — | — | 25 |
| UTS | — | 41 | 44 | — | — | 40 |
| Curtin | — | 33 | — | — | — | 27 |
| Adelaide University | — | 27 | — | — | — | 22 |

Totals: active 663 at 13 providers; proposed 1,760 at 15 providers. Every row has a `country_code` (no qualification-only scope exists).

### 3.2 `catalogue.course_entry_requirements` by course study level and status

| Level | active (courses) | proposed (courses) | inactive |
|---|---|---|---|
| BA | 428 (116) | 712 (132) | — |
| BH | 165 (43) | 444 (94) | 2 |
| MC (master's coursework) | 283 (85) | 309 (74) | 18 |
| MA | 144 (79) | 91 (25) | 57 |
| GD | 111 (59) | 92 (28) | 12 |
| GC | 80 (50) | 158 (37) | 12 |
| DR (doctorate) | 24 (12) | 98 (33) | 6 |
| MR (master's research) | 13 (10) | 59 (21) | — |
| DP | 16 (7) | 71 (21) | — |
| CT | 22 (12) | 25 (8) | — |
| AS / AD / C4 / C3 / ME / NA / none | 18 | 109 | — |

Postgraduate (MC, MA, MR, DR, GC, GD, ME): active 664 rows; proposed 807 rows.

### 3.3 `pipeline.entry_matrix_sources` (102 sources, 34 providers)

| found_via | status | read_via | Sources | Providers |
|---|---|---|---|---|
| manual | read | direct | 87 | 24 |
| manual | read | firecrawl | 12 | 9 |
| manual | failed | — | 3 | 1 (Macquarie, `blocked_pdf`) |

There is **no classification column** (country page / qualification page / pathway / postgraduate / course). Classification exists only in titles ("RMIT country equivalency: …").

### 3.4 `pipeline.entry_matrix_runs` (112 runs)

| State | Error class | Runs | Providers | Last | Cost US$ |
|---|---|---|---|---|---|
| done | — | 100 | 29 | 29 Oct | 1.5883 |
| failed | held_unparsed | 9 | 5 | 28 Oct | 0.0576 |
| failed | held_incomplete | 2 | 1 (RMIT) | 27 Oct | 0.0354 |
| failed | held (policy) | 1 | 1 (RMIT Vietnam) | 27 Oct | 0.0060 |

No run since 29 Oct (ingestion frozen by the 30 Oct mandate §2; job `entry-matrix-read` is active at `4-59/5` but has nothing queued).

### 3.5 Layer 4 AER items (`pipeline.layer4_review_items`)

| Kind | pending | approved | edited_approved | rejected | superseded |
|---|---|---|---|---|---|
| `course_entry_first_read` | **499** | 497 | 1 | — | — |
| `entry_matrix_first_run` | **40** | 31 | 6 | 2 | 40 |
| `entry_matrix_change` | — | 4 | — | — | — |

E13 gate (`security.course_entry_gate_v1`, live since v2.15.401): of the 499 pending course items, 215 cannot be approved (measured in the migration header on stored reads, 2 Nov; not re-run here to avoid 499 gate calls in production). E11 (298 RMIT) and E12 (38 QUT) items stay pending by decision.

### 3.6 Qualification and study-level reference objects

| Object | Exists | Note |
|---|---|---|
| Qualification catalogue / aliases / provider recognition | **No** | No `ref`, `catalogue` or `pipeline` table for qualification identity. `provider_entry_matrix.qualification_name` is free text as published. (`pipeline.adapter_qualifications` is unrelated: adapter qualification) |
| `ref.study_levels` | Yes (9 rows; `code`, `short_code`, `parent_id`) | Used by the resolver; `entry.level_equivalents` `["BH=BA"]` |
| `ref.study_level_source_mappings` | Yes | Source label → study level |
| `provider_entry_matrix.study_level_id`, `level_label`, `aer_level`, `benchmark_band`, `matrix_kind`, `routes`, `conditions`, `edition`, `intake_year`, `valid_to`, `version`, `row_hash` | Yes | `routes` and `conditions` can hold alternatives; no issuer/awarding-body field |
| `ref.countries` (249) | Yes | `svc_entry_country_refs_v1` feeds the heading check |
| `pipeline.aer_course_outcomes` (31,875) / `aer_course_outcome_builds` | Yes | Course outcome register, job `aer-outcome-register` every 5 min; scope `entry.course_read_providers` |

---

## 4. Restrictions and holds to reconcile before conflicting production actions

| # | Restriction | Source | Live setting / state | Conflicts with mandate | Proposed handling |
|---|---|---|---|---|---|
| R1 | **40-provider plan; "do not expand beyond the approved provider plan"** | 28 Oct decision P1 (`ENTRY-REQUIREMENTS-PROGRAMME-DECISION-2026-10-28.md` §1) | `entry.providers` 33; `entry.course_read_providers` 41; `entry.countries` and `entry.course_read_countries` `["AU","NZ"]` | §9 all eligible providers | **D-A1:** superseding decision lifting P1 for inventory and discovery only; reads stay wave-gated |
| R2 | **RMIT outside matrix reading scope** | 28 Oct P1; Step B decision §10 (IB, GAC, Foundation, Norway, UK, Nigeria, Vietnam excluded); build log (RMIT removed 27 Oct 07:02:15) | RMIT not in `entry.providers`; RMIT is the only member of `entry.completeness_providers` | §8 recover RMIT gaps | **D-A2:** bounded RMIT re-entry for the 7 held sources (stored copies, no fetch) after the Phase C reader fix |
| R3 | **Ingestion frozen** (no QUT, B5, R1 exceptions; do not enlarge Layer 4) | 30 Oct closure mandate §2; INDEX "ingestion held"; D11 (31 Oct 19:22) | No run since 29 Oct | §9, §12 reads | Phase B is read-only and needs no lift. **D-A3** before any Phase C/E read |
| R4 | **E11 / E12 cost ceilings not recorded** | Decisions 2 Nov 05:18; register "Next three actions" #2 | Pilots at US$0 | §7 master's recovery, RMIT/QUT course reads | **D-A4:** record ceilings (E11 about US$2.45 for 298 stored-copy reads; E12 about US$0.05) |
| R5 | **E13 gate**: incomplete course reads cannot be approved; no global cap raise, no re-read without a measured rollout | 2 Nov 05:18; v2.15.401 | `entry.max_rows_per_course` 6; `entry.max_rows_by_provider` `[]`; `entry.shared_page_hold` 1; `entry.variant_check` 1 | §7 | Per-provider caps by setting with reason, as the decision allows |
| R6 | **Layer 4 gates** | Implementation §2.2; 28 Oct P3; AER review path (`security.aer_review_kinds_v1`: one at a time, never in bulk) | `entry.matrix_first_run_review` 1 | §12 "no Layer 4 bypass" (consistent) | Unchanged |
| R7 | **AI budget** | Decision pack 2 Nov 10:56 E-7 (v2.15.404) | `budgets.ai_daily_ceiling_usd` 14; OpenRouter mode `observe`, credit floor US$5 (per `20261102070000`; floor US$10 proposed) | §12 paid reads | Phase B uses no AI |
| R8 | **Reader limits** | Settings, Entry requirements section | `batch.entry_matrix` 4; `entry.matrix_attempts` 3; `entry.matrix_refresh_days` 30; `entry.matrix_max_rows_per_page` 400; `entry.matrix_slice_chars` 8000; `entry.matrix_slice_concurrency` 6; `entry.matrix_max_tokens` 16000; `entry.matrix_min_confidence` 0.85; `entry.course_batch_size` 50; `entry.course_read_cost_usd` 0.005; `entry.course_page_chars` 205000; `enrich.course_entry_*` | — | Reused as is |
| R9 | **Source acquisition** | 28 Oct P2, P5; implementation §2.2 | `entry.pdf_enabled` 1, `entry.pdf_max_pages` 40, `entry.pdf_max_bytes` 20 MB; `entry.render_hosts` 4 hosts; `entry.render_wait_ms` 5000; Firecrawl monthly limit (`security.fc_month_refusal_v1`) | §10 discovery | Discovery from stored copies first; any new fetch waits for D-A3 |
| R10 | **Consumer API frozen** | CLAUDE.md G3 (Decision 266); INDEX 31 Oct 11:24 handover rule | Job `consumer-api-guard` daily | §6, §F | Any qualification filter or key is a G3 approval (D-A6) |
| R11 | **Sydney 2027 robots block; edition check** | Decision 8 (25 Oct) | **`entry-matrix-edition-check` job and `entry.edition_check_days` do not exist** in live or git | §11 stale/edition | Build in Phase B/E (governance gap, §7) |

---

## 5. Mapped work items

Proposed SS task: **SS-017 "AER coverage, qualification-first and continuous assurance"**, with sub-items B1… below (integrator to confirm the number in the execution register).

| Mandate § | Existing objects / screens / jobs it extends | Work item | Phase | Depends on | Needs Platform Admin |
|---|---|---|---|---|---|
| §11, §13 (metrics), §17 #14, #15, #17, #18–#20, #24 | `entry_matrix_sources`, `entry_matrix_runs.result.completeness` (manifest-v1), `aer_course_outcomes`, Layer 4 items, `admin_aer` 'summary' | **B1–B6** quality-control foundation (below) | B | — | No (read-only, additive, catalogued job, no AI) |
| §14 alerts / daily / weekly | `security.platform_health_check_v1`, `pipeline.platform_alerts`, job `platform-alerts`, `ops-scorecard` / `pipeline.ops_scorecards`, watchdog workflow | **B7** AER check in platform health (P0 only to alerts); daily line; Monday 08:00 section | B (alerts) / G (weekly) | B3 | Confirm the weekly report destination is the existing scorecard + alert e-mail path |
| §3, §4 qualification identity | `provider_entry_matrix` (`qualification_name`, `routes`, `conditions`, `aer_level`) | **C1** additive `ref.qualifications` + aliases + `catalogue.provider_qualification_recognition` (provider, qualification, levels, optional course, issuer/country restriction, minimum, source, status, edition); no `GLOBAL` country | C | B1 | **Yes: D-A5** (new tables in the canonical model) |
| §8 IB, GAC, Foundation | `entryNonCountryShape`, `entryManifestDetail`, `entry.completeness_providers` | **C2** source shape classification (country table / qualification page / pathway table); qualification pages produce recognition rows, not country rows | C | C1, B1 | D-A2 (RMIT re-entry) |
| §8 UK, Nigeria, Vietnam | `entryCompleteness`, `entryCellList`, slices | **C3** cell-by-cell re-read of omitted manifest cells only (stored copy); "PR B" table context | C | D-A2, D-A3; spend ≤ cents | Yes (spend, scope) |
| §8 Norway | `entryUnscaledColumns` (R2) | **C4** evidence search for the printed scale in stored first-party pages; otherwise evidenced case-by-case | C | — | No (rule exists) |
| §5 resolver | `security.entry_resolve_v1`, `entry_matrix_payload_v1`, `entry_course_payload_v1` | **C5** qualification matching inside steps 2–4; country optional for global qualifications; outcomes unchanged | C | C1 | Internal only; consumer exposure is F |
| §7 postgraduate | `course_entry_requirements` kinds, E13 gate, E11/E12 pilots | **D1** postgraduate route semantics (coursework / research, GPA scale, discipline, experience) as additive columns or `provenance` keys; reuse stored reads (`value.rows_read`) | D | E13 (live), D-A4 | D-A4 ceilings |
| §10 Provider entity | `entry_matrix_sources`, Providers › Provider details | **D2** side table `pipeline.aer_source_profiles` (source_id, classification, scope, levels, edition, primary flag) + Provider details "Academic Entry Requirements" panel | D | B1 | No |
| §9 all-provider expansion | `entry.providers`, `admin_entry_matrix_seed`, central-page discovery | **E1** discovery waves from stored copies (ordered by course count), then seeded reads | E | D-A1, D-A3 | **Yes** (scope, Firecrawl/AI spend) |
| §6, §F4 consumer | `website_v2_course`/`_provider`, `website-api-v2` `edu_country` | **F1** qualification-aware contract spec, developer guide issue | F | C5 | **Yes: D-A6 (G3)** |
| §16 G | tests `s111`–`s114`, `s57`, `s42`, `s120` | **G1** scenario fixtures §17 #1–#24 (stored evidence) | G | all | Production acceptance |

### 5.1 Phase B — smallest additive design

All objects new; no edit to a consumer object; no AI, no fetch; settings in toolset `pipeline`; catalogued; `-- Replaces: nothing`, `-- Retires: nothing`.

- **B1 `pipeline.aer_source_manifests`** (one row per source × content hash): `source_id`, `provider_id`, `content_hash`, `basis` (`manifest-v1`, `pdf-table-v1`, `none`), `shape` (`country_table` | `qualification_page` | `requirement_table` | `pdf_table` | `unparsed` | `unknown`), `heading`, `scope_country` (nullable), `scope_label` (qualification text when no country), `expected_cells`, `sections` jsonb, `derived_from_run`, `computed_at`. First fill: from the stored `entry_matrix_runs.result.completeness` and `held_*` reasons already persisted (zero reads). Later fills: a no-AI worker mode over stored evidence reusing `entryManifestDetail` / `pdfTables`.
- **B2 `pipeline.aer_gap_findings`**: `fingerprint` (md5 of provider · source · scope kind · scope key · study level · root cause code; unique), `root_cause_id`, `severity` (P0/P1/P2), `state` (`open` | `resolved` | `reopened` — observation states, not admission statuses), `scope`, `evidence` jsonb (run, item, evidence ids), `owner_role`, `next_action`, `first_seen`, `last_seen`, `resolved_at`, `closure_evidence`. **`pipeline.aer_gap_root_causes`**: one row per defect class (e.g. `non_country_heading`, `merged_column_omitted`, `unscaled_column`, `row_cap`, `pdf_column_edge`, `no_source`) linking all affected providers. **`pipeline.aer_gap_events`**: append-only history (opened, observed, resolved, reopened).
- **B3 `security.aer_reconcile_v1()`** + job **`aer-reconcile`** (hourly, off the busy minutes, e.g. `:46`; settings `batch.aer_reconcile`, `aer.reconcile_max_seconds`): keyed by provider over the existing tables, compares manifest → run → proposed → admitted → active → resolvable; upserts findings by fingerprint (dedupe), closes only when active verified rows prove it, reopens on regression. Idempotent; advisory-lock single flight like `aer_course_outcomes_build_v1`.
- **B4 `pipeline.aer_coverage_daily`**: one row per day × country × provider (or "all") with the four measures (discovery, extraction, verified admission, consumer-resolvable) as numerator/denominator, open P0/P1/P2, new/resolved/reopened; denominator from §1.1's rule.
- **B5 Admin metrics**: extend `public.admin_aer` with action `coverage` (role checks as today) and wire the **Coverage & completeness** `academic_entry` attribute, which today reads "Not measured here yet" (`src/course-coverage.jsx:52`), plus an AER overview block; provider drill-down in the Entry requirements workspace.
- **B6 tests**: one `// Guards:` spec for the reconcile contract (scenarios 14, 15, 17, 18, 19, 20, 24) on fixtures; register regenerated (G4); central guards `s32`/`s42`/`s57` unchanged.
- **First proof (§16 B):** the 12 current failed runs whose sources read `read` become 12 extraction findings; RMIT gives 7 P1 findings under 5 root causes; 1,442 eligible providers without a source give one P2 `no_source` root cause rather than 1,442 alerts.

---

## 6. Existing reporting surfaces (§13, §14)

| Purpose | Existing surface / mechanism | Object |
|---|---|---|
| Coverage & completeness (§13 home) | Coverage & completeness › Courses, Attributes, Progress (`src/nav-map.js:50`; `src/course-coverage.jsx`, `src/Progress.jsx` via `admin_progress_read`) | `academic_entry` attribute is a placeholder: "Not measured here yet: read and admitted on Catalogue › Entry requirements" |
| AER workspace | Catalogue › Entry requirements: Provider entry matrix, Course entry requirements, Sources, reads and holds, Resolution inspection (`src/AerWorkspace.jsx`, `public.admin_aer` actions `summary`, `matrix_list`, `course_list`, `sources_list`, `resolve`, `reread` …); course outcome register (`public.admin_aer_outcomes`, `pipeline.aer_course_outcomes`, job `aer-outcome-register` every 5 min) | Extend, do not duplicate |
| Layer 4 | Layer 4 › Review (AER path, `security.aer_review_read_v1`, E13 `completeness_gate`) | Backlog counts |
| Critical alerts (§14 event-driven) | `security.platform_health_check_v1` (job `platform-health`, `8-59/10`) → `pipeline.platform_alerts` (job `platform-alerts`, `*/10`), deduplicated, cooldown, recovery notice; delivered by push and e-mail through the existing scheduled task (`security.platform_alerts_take_v1` / `_confirm_v1`) or webhook; live: `alerts.delivery_enabled` true, `alerts.test_mode` false, `alerts.min_severity` 3 | Add an AER check; P0 only |
| External watchdog | `.github/workflows/platform-watchdog.yml` (hourly `:24`, `security.platform_watchdog_v1`) | Unchanged |
| Weekly report (§14 Monday) | Platform health › weekly operational scorecard (`security.ops_scorecard_v1`, `pipeline.ops_scorecards`, job `ops-scorecard` daily `29 19 * * *` UTC); Monday deployed-weekly line (05:17); work queue alerts (`pipeline.queue_watch_alerts`, job `queue-watch`) | Add an AER section; the Monday 08:00 e-mail destination needs confirming (D-A7) |
| Daily | Admin repo `docs/daily-updates/YYYY-MM-DD.md` (e.g. #379, 2 Nov); job `health-hourly` (`11 * * * *`) | AER daily line from `aer_coverage_daily` |
| Housekeeping | job `hygiene-check` (weekly), `pipeline.component_register` | New objects registered |

---

## 7. Governance gaps found

1. **Decision 8 not built.** `entry-matrix-edition-check` (quarterly) and `entry.edition_check_days` (90) were decided on 25 Oct; neither exists in live `pipeline.automation_catalogue`, `cron.job`, settings or git.
2. **Vietnam hold has no checked-in source.** The run error `held: AER PR B (table context) not yet built …` is not in any migration in `supabase/migrations/`; it was set during the 27 Oct PR A recovery (governed action or paste). Provenance should be linked in the register.
3. **Live-only migrations.** Live holds 1,711 migration versions, git 365: 1,347 live-only versions, all before 25 Oct 2026 (the AER era is fully in git; `20261031090000` is in git but deliberately not applied, superseded by `20261031091000`). All 55 live AER functions (`%entry%`, `%aer%`) have a defining migration in git.
4. **Source status overstates completeness.** `entry_matrix_sources.status = 'read'` on all 36 RMIT sources while 7 of their runs failed (AER-GAP-09).
5. **Scope settings diverge.** `entry.completeness_providers` holds RMIT only, while RMIT is outside `entry.providers`; the completeness guard therefore protects no provider that is currently in matrix scope.
6. **No discovery outcome register.** All 102 sources are `found_via = 'manual'`; the planned `entry_requirements` page type of central-page discovery (implementation §2.2) produces none.

## 8. Decisions needed from the Platform Admin (consolidated)

- **D-A1** Supersede the 28 Oct 40-provider restriction (P1) for inventory and discovery to the 1,476 eligible providers; reads stay wave-gated.
- **D-A2** Bounded RMIT re-entry for its 7 held sources (stored copies only), superseding the RMIT exclusion for these sources.
- **D-A3** Lift or narrow the 30 Oct ingestion hold for Phase C recovery reads (and later waves), with a spend ceiling.
- **D-A4** Record the E11 and E12 cost ceilings (pending since 05:18).
- **D-A5** Approve new canonical tables for qualification identity and provider recognition (additive).
- **D-A6** G3: any consumer qualification filter or payload key (Phase F).
- **D-A7** Confirm the Monday 08:00 executive report goes through the existing alert e-mail / scorecard path.
- Treatment of the 219 NZ providers with unknown international status (included as "unknown", outside the denominator, unless decided otherwise).

Phase B (B1–B6) needs none of these and can start under standing authority.
