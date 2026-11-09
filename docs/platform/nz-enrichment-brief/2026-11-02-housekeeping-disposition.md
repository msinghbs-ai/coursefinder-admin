# Housekeeping disposition H01–H28 (2 Nov 2026)

- **Authority:** Platform Admin consolidated decision pack, 2 Nov 2026 10:56 AEDT, Decision 6: `2026-11-02-consolidated-decision-pack-1056.md`.
- **Findings:** `2026-11-02-housekeeping-reconciliation.md`, H01–H28. Every H identifier is kept.
- **Operating model:** Decision 260 (`DATA-PIPELINE-OPERATING-MODEL.md` §6). Drops are made only by a paste file after separate approval.
- **Load policy:** `PRODUCTION-VALIDATION-LOAD-POLICY.md`. The load disclosure is in §5.
- **This stream:** read-only against `fxcwkweaxjtknorudmwp`.
  - Nothing was written, deleted, committed or deployed.
  - **Records changed: 0. Records deleted: 0.**
  - The integrator runs every prepared file and makes every commit.
- **Snapshot:** database clock 2 Nov 2026, 11:05–12:27 AEDT.
  - This is after the E16 containment writes (10:05–10:25) and v2.15.402 (09:15).
  - Counts that differ from the 07:24 reconciliation reflect those changes.

**Prepared files.** All are in the scratchpad folder `hk/` at `/tmp/claude-0/-home-claude/f86eaff9-39df-5a0c-9d38-8954c30d5e12/scratchpad/hk/`. The integrator copies them into the change record.

| File | Covers | md5 at preparation |
|---|---|---|
| `H11-component-register-drift.sql` | H11 | `0bcd29139193f1fe8b33522c56939217` |
| `H24-layer2-batch-closure.sql` | H24 | `2b3f8d5d61d4ce999e593067d582b77c` |
| `H01-H03-H04-H09-duplicate-link-tranche.sql` | H01, H03, H04, H09 | `f8f2b3082e039043e250a57ba8d68dd2` |
| `H05-H13-H20-layer4-route.sql` | H05, H13, H20, H23 (v1: **superseded**, refused at 16:06) | `402ff248f9c9873a35b78820cf7150af` |
| `H05-H13-H20-layer4-route-v2.sql` | H05, H13, H20, H23 (drift-tolerant, §6) | `697d0e9b4b5c3f0e0a717e98b33133a4` |
| `H10-H27-retirement-evidence-DRAFT.sql` | H10, H27 (marked **NOT APPROVED: needs separate explicit approval**) | `5986fb849eba708d8cafd44722706e0a` |

**How the prepared files are protected:**
- Each file is count-guarded and md5-guarded, runs in one transaction, and has a read-back and a rollback.
- Each was run end to end on an isolated local PostgreSQL 16 fixture (stub tables, synthetic rows, guard constants swapped for fixture values). The fixture runs checked:
  - each disposition in the H01 tranche;
  - that a second run is refused;
  - that the H01 rollback restores the exact prior state;
  - that the route file creates no duplicate.
- The production guard values in the files are unchanged.

**Run order:**
1. H11.
2. H24.
3. H01 tranche.
4. H05/H13/H20 route.

The route must run **after** the tranche. H13 includes tranche courses (for example 104952J shows a 2023 page). A new pending link item on one of those courses makes the tranche's guard refuse, which is safe but blocks it.

## 1. Disposition table

Status values: **prepared** (a file is ready for the integrator under an existing authority), **needs approval** (a Platform Admin decision is required first) and **retained** (no change, under Decision 6).

| ID | Finding (short) | Disposition (Decision 6) | Counts (live 2 Nov 11:05–12:27 unless stated) | File | Owner | Status |
|---|---|---|---|---|---|---|
| H01 | Reviewer link and old sweep link both active, neither primary | Consolidation tranche: keep the validated, shown link and set the older link `inactive` | 165 courses (331 links). **65 in the tranche**; 93 held (kept link not validated by the rule); 6 hand-locked (excluded); 1 has no search document (041111J) | H01 tranche | INT | prepared (65); **needs approval** (93) |
| H02 | Different pages, no primary, no reviewer link | Covered by E16 containment (Decisions 1–2). Not re-done here | 33 (all E16). The 38 multi-link E16 courses are excluded from the tranche | — (E16 stream) | INT under E16 | covered elsewhere |
| H03 | One primary plus other active links | In the tranche | 23. **18 in the tranche** (primary kept, already primary); 5 in E16 (excluded) | H01 tranche | INT | prepared |
| H04 | Same page spelled differently | In the tranche | The reconciliation's exclusive class is 18. With overlapping tags, 31 tranche courses hold same-page spellings. Every H04 course not in E16 and not locked is in the tranche | H01 tranche | INT | prepared |
| H05 | One active link, but course_url names a different page | Route to Layer 4; reuse pending items; no withdrawal | 56 courses (md5 A `412a0229…`, B `451ae71c…`), 32 with a fee. **23 reused** (pending item exists); **32 not raised** (Decision 263: already raised for that page); **1 new** | Route | INT, L4 | prepared |
| H06 | course_url with no link row | Retain (historical URLs) | 21 | — | — | retained |
| H07 | Link shown, course_url null | Separate evidence: do not copy the projected URL into `course_url` | 1,345. Related: the 93 H01 courses held because `course_url` disagrees with the reviewer link | — | PA | needs approval (separate evidence) |
| H08 | Federation source without a gate | Separate evidence: keep the gate unchanged until source approval is evidenced | 10 links, not shown | — | PA | needs approval (separate evidence) |
| H09 | Older-year link beside a newer one | In the tranche where the rule is met | 114. **22 in the tranche**; 85 held (inside H01's 93); 7 in E16 | H01 tranche | INT; PA for the 85 | prepared (22); needs approval (85) |
| H10 | Retiring components past `retire_after` | Retirement evidence; draft drop only | 3 functions and 2 paused jobs: 0 callers, 0 cron references, 0 `pg_depend`, 0 REST calls in 24 h, `service_role` only | H10/H27 draft | INT prepares; PA approves and runs | **needs approval** |
| H11 | Component-register drift | Correct under existing housekeeping authority | 4 rows as found, plus **2 more of the same drift** found live (the paused jobs `provider-calendar-intakes` and `provider-calendar-defaults` were still `active`). 6 rows; before and after for each in the file | H11 | INT | prepared |
| H12 | E16 77-course cohort | Covered by E16 (Decisions 1–2) | 77 (md5 `1374432181…`, re-derived from the CSV and matching). Status per `2026-11-02-e16-containment-reconciliation.md` | — (E16 stream) | INT under E16 | covered elsewhere |
| H13 | Shown page carries a handbook year of 2024 or earlier | Route to Layer 4 (address year only, unproved); no withdrawal | 193 (md5 A `342286d1…`, B `9e9502ce…`). **188 new**, **1 reused** (UniMelb), **4 not raised** (Decision 263). Excluded: E16 2, H14 24 | Route | INT, L4 | prepared |
| H14 | Hand-entered, locked Monash links (2020–2024) | Separate evidence: preserve all of them | 24, locked. Excluded by every file's guard | — | PA | needs approval (separate evidence) |
| H15 | Shown page carries 2025 | Separate evidence: a review candidate, not automatically wrong | 92 (reconciliation count; not re-measured) | — | PA | needs approval (separate evidence) |
| H16 | Evidence rows without a Storage object | Retain (evidence and history pending a retention decision) | 4 | — | — | retained |
| H17 | Rule items with no evidence id | Retain | 60 | — | — | retained |
| H18 | Storage objects with no lineage row | Retain (decide within H28) | 18,031 objects, 699 MB | — | — | retained |
| H19 | E16 sibling-page fees | Covered by E16 (Decisions 1–2) | 31: 10 withdrawn (F2a/F2b); F1 2 and F3 14 follow Decisions 1–2 | — (E16 stream) | INT under E16 | covered elsewhere |
| H20 | Fees read from an H13 wrong-year page | Route to the fee check; no withdrawal | **38 fees on 38 courses** (md5 A `b9bb906f…`, B `162d2de1…`). 38 new, 0 reused, 0 not raised | Route | INT, L4 | prepared |
| H21 | 29 ungated fees in `tuition_history` | Separate evidence: G3 assessment before any consumer-facing correction | 29 | — | PA (G3) | needs approval (separate evidence) |
| H22 | Superseded Layer 4 history | Retain (immutable) | 22,199 | — | — | retained |
| H23 | Fee checks pending since 25 Oct | Reuse; settle before the 14-day limit on 8 Nov | 27 reused. None is on an H20 course, so no new item duplicates them | Route (reuse only) | L4 | prepared (reuse) |
| H24 | Layer 2 batch `dc4fabeb` still `running`; 34 `partial` | Guarded closure of genuinely completed batches, plus a health-rule proposal | **1 to close** (`running` to `partial`, `completed_at` = last heartbeat). **0 of 34** change: all are already correctly closed (see §2) | H24 | INT | prepared |
| H25 | Exhausted page reads | Retain | 1,509 (20 shown) | — | — | retained |
| H26 | Manual locks and protected values | Retain | 7,561. 0 touched by any file | — | — | retained |
| H27 | Adapter screenshots older than 7 days | Retention evidence; Storage removal only through the existing run, after approval | 4,367 objects, 7.46 GB older than `retention.screenshot_keep_days` (7). About 3,124 objects, 5.46 GB after the open-build rule (1 Nov estimate). No `adapter_screenshots` run has ever started | H10/H27 draft | PA | **needs approval** |
| H28 | No lifecycle rule for page copies | Separate evidence: no purge or retention policy until recoverability and legal retention are established | — | — | PA | needs approval (separate evidence) |

**One-line dispositions:**

*Retain without correction (Decision 6):*
- **H06:** historical course URLs, kept as the record of the old address.
- **H16–H18:** evidence and history pending retention decisions.
- **H22:** Layer 4 history is immutable (CF-CHG-20260901-051).
- **H25:** exhausted page-read history; re-entry follows Decision 261.
- **H26:** manual locks and protected values are preserved, and every prepared file excludes locked courses.

*Separate evidence (Decision 6):*
- **H07:** no projected URL is copied into `course_url` to fill an empty field.
- **H08:** Federation gating is unchanged until the source approval is evidenced.
- **H14:** all hand-entered, locked Monash links are preserved.
- **H15:** 2025 handbook URLs are review candidates, not automatically wrong.
- **H21:** a G3 assessment comes before any consumer-facing correction.
- **H28:** no purge or retention policy until recoverability and legal retention are established.

## 2. Notes on each prepared item

### H11: register drift (6 rows)

Rows 1–2 were found absent live, so they are set to `retired` and a note is added.

Rows 3–4 are given `retire_after` 2026-11-05 (22 Oct plus 14 days, per rule 6.2.3) and a `replaced_by`. The guard confirms that their only cron callers are paused.

Rows 5–6 (additional drift): the two paused calendar jobs go from `active` to `retiring`, with the same date and `replaced_by`.

### H24: Layer 2 batches

The platform's own rule is `public.layer2_run_batch_reconcile` (def md5 `d6891d23…`). When processed equals target and any item escalated to Layer 3, the batch is `partial` and `completed_at` is set.

**The 34 `partial` batches.** Each one has:
- `completed_at` set;
- processed equal to target;
- item counts summing to target;
- 0 in-flight items;
- escalated Layer 3 items above 0.

So `partial` is their correct finished state, and **none qualifies for a change**. Setting any to `completed` would misstate them. Two of them also hold one blocked item each (`ed73a37e`, `a27f7ab9`).

**Batch `dc4fabeb`.** It has 61,211 of 61,211 items as `layer3_required` and 0 in flight, and its last heartbeat was 12 Oct 08:55 AEDT. Under the same rule it is `partial`. The file changes only `status` and `completed_at`; it does not call `reconcile`, which would also rewrite the vendor totals.

**Judgement point for the integrator.** This is the sweep profile's shared "open batch … reused across days". Two live writers append to it: `svc_coverage_tuition_handoff_record` and `layer3_fact_claim_service`. Both open a new batch when none is open, which is their designed fallback. After closure, the next hand-off creates a new batch. That is expected, not a fault.

**Health-check extension (code proposal only; no code written):**
- **Rule:** a new issue key, `layer_queues:layer2_batch_stale_heartbeat`, in the existing `security.platform_health_check_v1`, section 4.6 "Layer 2 run items …". It is raised through `security.platform_health_issue_v1`. The rule has two parts:
  - **(a) warning:** a batch in `queued` or `running` with processed below target and `coalesce(heartbeat_at, updated_at)` older than the setting.
  - **(b) notice:** a batch in `running` with processed equal to target and a heartbeat older than the setting, meaning finished but not closed. Part (b) would have caught `dc4fabeb`.
- **Setting:** reuse the existing `health.stuck_hours` (toolset `pipeline`; live 4; range 1–24; unit hours). Read it with `security.pipeline_num_v1('health.stuck_hours', 4)` and add `security.platform_health_check_v1` to its `used_by` line. No number is written into code (G2), and no new job is needed (G1).
- **Display fix in the same change:** `security.admin_layer_status_summary_compute()` counts `partial` as active (35 today). It should count `partial` only where `completed_at is null`, as `layer2_run_batch_start` and `layer2_run_batch_cancel` already do.
- **Spec to add:**
  - The file is `tests/uat/cf-247-s219-layer2-batch-stale-heartbeat-health-contract.spec.mjs`. s219 is the next free number at writing, since s215 and s218 exist. Use the next free number at integration.
  - It starts with `// Guards: Decision 6 H24 (Platform Admin 2 Nov 2026 10:56)`.
  - It asserts that the migration adds the issue key inside the `layer_queues` section, reads `health.stuck_hours` through `pipeline_num_v1`, and contains no literal hour count.
  - G2 stays with `s32`, so the spec does not re-assert it.
  - Regenerate `docs/platform/TEST-REGISTER.md` with `node scripts/test-register.mjs` in the same PR (G4).
- **Activation:** the rule reports only. It never closes a batch by itself.

### H01/H03/H04/H09: duplicate-link tranche

**Rules applied exactly:**
- The **kept link** is the link the projection already shows.
- It counts as **validated** when it is primary, or when it equals `course_url` and passes `security.course_page_check_v1`.
- Superseded duplicates are set to `inactive`.
- The kept link is made primary where it is not already.

**Re-measure on 2 Nov:** 239 courses and 491 links, which equals the reconciliation exactly.

**Tranche:** 101 courses, 213 links.
- 112 links set to `inactive`.
- 83 links made primary.
- 18 links already primary.
- Validated by primary 18; by `course_url` and page check 83.
- md5 by half:

| Half | Courses | Kept links | Superseded links |
|---|---|---|---|
| A | `05528955…` | `eb9fb756…` | `15c6b045…` |
| B | `1ddb5647…` | `8eb8523d…` | `c4e99f89…` |

**Page checks:** 151 links equal to `course_url` were checked at 11:55–11:56. 142 passed and 9 were refused. The 9 refused links can never count as validated.

**Consumer-visible changes: 0.** The kept link is always the shown link, and there are 0 courses where another active link is itself validated. The write block refreshes the projection for the 101 courses and rolls back everything if any shown URL differs.

**Held for approval (93 courses, all H01; 85 also H09):**
- The reviewer link is shown, but `course_url` names another page (or is null on 8). So the rule is not met, even though consolidation would not change what consumers see.
- **Decision for the PA:** accept the Layer 4 reviewer decision as the validation, or settle H07 first.
- md5 A `bac0e6ca…`, B `c43b9dd6…`.

**Not consolidated, needs a routing decision:** 7 of those 93 currently **show a link that the page check now refuses**:

| Course id (first 8) | Refusal rule |
|---|---|
| 454bb36d | shared_page |
| 95fc1a5d | variant |
| 97dbcc4e | sibling |
| 980fb700 | old_year |
| b3cadedc | variant |
| ef8a4b5b | old_year |
| f16381f9 | shared_page |

These are consumer-visible. They sit outside the H05/H13/H20 authority, so no file routes them. See §4.

### H05/H13/H20: Layer 4 route

The file deliberately does **not** use `security.binding_refusal_route_v1`. That route also writes `pipeline.page_rejections`, which is the containment path for refused pages. These values are unproved. Instead, the file raises the same item kinds with the route's own three dedupe steps:
- the advisory lock per course;
- a pending item on the course, which is reused;
- Decision 263, under which an item already raised for the same page or amount is not raised again.

The file proves there are no duplicates by counting 0 course and field pairs with more than one pending item.

**Reviewer effect:**
- On an H13 link item, "Keep" or "Use" both keep the shown page. "Enter another address" sets the current page.
- On a fee check, "do not admit" does **not** withdraw the active fee. This is inferred from the 1 Nov fee-check change. `security.layer4_tuition_apply_impl` is not in git, so verify it before relying on this.

### H10/H27: retirement evidence

All of it is in the draft file. The draft has no `DELETE` on `storage.objects`. Screenshot removal, if approved, is the existing Settings › Storage & retention run.

Storage has no backup (Decision 5 E-4 is still open). Screenshot removal is therefore irreversible, apart from paid re-reads of the pages.

## 3. Mandatory housekeeping reconciliation (Decision 6)

| Field | Value |
|---|---|
| **Records examined** | **Register:** 12 component-register rows. **Jobs:** 10 cron jobs. **Layer 2:** 35 batches plus their items (keyed index counts; 61,211 items on `dc4fabeb`). **Links:** 239 multi-link courses (491 links), of which 151 links were page-checked; 56 single-link courses with a differing `course_url`; 219 shown URLs with a year of 2024 or earlier (193 in H13); 38 fees. **Other:** 3 functions with their callers; 4,553 Storage objects in `adapter-captures`; Layer 4 pending and history keyed per course. The reconciliation's 07:24 totals stand for everything not re-measured |
| **Corrected** | Executed **0** (read-only stream). Prepared: H11 6 register rows; H24 1 batch; H01 tranche 101 courses (112 links to `inactive`, 83 to primary) |
| **Retained** | H06 21; H16 4; H17 60; H18 18,031 objects; H22 22,199; H25 1,509; H26 7,561. The 34 H24 `partial` batches are unchanged (already correct) |
| **Held** | H01/H09 93 (rule not met); H07 1,345; H08 10; H14 24; H15 92; H21 29; H28 (policy). Also excluded from the tranche: E16 38, hand-locked 6, no search document 1. 7 shown links refused by the page check (§2) |
| **Retired** | **0.** Drafted, not approved: H10 (3 functions, 2 paused jobs, 5 register rows) and H27 (up to 4,367 objects, 7.46 GB) |
| **Layer 4 items reused or created** | Executed: 0. Prepared to create 227 items: 1 H05 and 188 H13 `official_course_url` items, and 38 H20 `provider_current_tuition_validation` items. Reused: 23 (H05), 1 (H13) and 27 (H23). Not raised because already raised or decided (Decision 263): 32 (H05) and 4 (H13) |
| **Evidence identifiers** | **E16:** cohort md5 `1374432181aca2abb3ec525448b66923`. **Duplicate tranche (md5):** A courses `05528955becdafe84abbb20005913b0a`, kept `eb9fb756b269f262be52814e264c5398`, superseded `15c6b04522c9fc2f4d0e9cc68cc3c0d2`; B courses `1ddb5647e02d83ce4bfe436c87af545f`, kept `8eb8523dbe65c49ccfae42b22bcd78aa`, superseded `c4e99f89175ade771b7c6850e7e04616`. **H01 held:** A `bac0e6ca5736e302b709bd2189ac6987`, B `c43b9dd6eb0e99e7d8ce457fb909623d`. **H05:** A `412a0229f8c55b9c8ffe2c10da11d3c6`, B `451ae71cac4d79889ef3a4bc8dcea0cf`, new `67224396c18f6449037d3237ee3dad43`. **H13:** A `342286d1afd7fa665edc43392cf7cb33`, B `9e9502cee7f67c057c65782ed667fa45`; new A `be7e9c3869cd1b85ae9b20204e41e615`, B `6259d0d7dba35bdf65d321300e320435`. **H20 fees:** A `b9bb906f70e684ccedebba16cd20b8b3`, B `162d2de13dce8c493b33fabdb654d0d5`. **Function definitions (md5):** reconcile `d6891d2358457b5fac43f64d073815b1`; hand-off writer `963e419e1285efacb7e00edcf98f6421`; claim service `831241fbf4f996f85ad185e688a08739`; H10 functions `7ccad3b3…`, `28d33d93…`, `b25dd2ca…`. **Audit actions on run:** `h11_component_register_drift`, `h24_layer2_batch_close`, `h01_duplicate_link_tranche`, `h05_h13_h20_route` |
| **Consumer changes** | **0** in every prepared file. The tranche enforces this inside its transaction. No G3 object is touched. Consumer-visible items that need approval are listed separately: the 7 refused shown links (§2) and E16 (Decisions 1–2) |
| **Manual locks preserved** | 7,561 of 7,561. Every file excludes locked courses: 6 multi-link and 24 H14 |
| **Records physically deleted** | **0** |
| **Remaining risks** | See §4 |

## 4. Remaining risks

1. **Refused shown links.** 7 shown links are refused by the page check today and sit outside the H05/H13/H20 authority. They need a decision: route them through the neutral Layer 4 route, or contain them as E16 Part B.
2. **H01/H09 held courses.** 93 courses stay multi-link until the PA rules on what counts as validation (H07).
3. **Batch closure side effect.** H24 closure makes the coverage-sweep writers open a new batch. That is designed, but it changes what the Layer 2 screen shows.
4. **Live-only functions.** `svc_coverage_tuition_handoff_record`, `layer3_fact_claim_service`, `layer2_run_batch_reconcile`, `layer2_run_batches`/`items` DDL and `layer4_tuition_apply_impl` are not in git. Each is a governance gap to log.
5. **No call statistics.** `track_functions = none`, so H10's "unused for 14 days" cannot be shown from counters.
6. **Edge function source.** 20 deployed edge functions were deployed from `/tmp`, so their source may differ from git. Read `website-course-api` before the H10 drop.
7. **Fee-check reject.** On an H20 fee check, "do not admit" does not withdraw the fee (inferred). Suppression needs its own authority.
8. **H23 deadline.** The 27 fee checks reach the 14-day limit on 8 Nov.
9. **Storage.** There is no Storage backup (G8). H27 removal would be irreversible.
10. **Scheduler.** The admission stagger (Decision 4) is live. It was applied between 11:05 and about 11:30.
    - Current slots: `coverage-admit` `3-59/10`, `coverage-admit-intakes` `5-59/10`, `adapter-overwrite` `9-59/10`.
    - Runs now take 25–55 s (they were about 1 s at 10:30–11:00).
    - The usable minutes are therefore :x6–:x8, never :35–:42, and :x1–:x2 outside :00–:05. Re-check `cron.job` before running each file.

## 5. Production load disclosure

**Windows used:**

| Time (AEDT) | Queries |
|---|---|
| 11:05–11:06 | 5 |
| 11:15–11:16 | 5 |
| 11:25–11:26 | 3 |
| 11:45–11:47 | 2 |
| 11:55–11:56 | 6 |
| 12:05–12:07 | 3 |
| 12:15–12:17 | 5 |
| 12:25–12:26 | 2 |

Plus one 24-hour log query. No query ran during :00–:05 or :35–:42.

**How the queries were kept small:**
- Cohort queries were keyed by `course_id` halves or by indexed keys, mostly with `statement_timeout` 9 s.
- `cron.job` was checked at 11:05. `coverage-admit`, `coverage-admit-intakes` and `adapter-overwrite` ran in 0.7–1.2 s, except `adapter-overwrite` at 11:03, which took 30.2 s. None failed.

**Breaches and errors:**
- **Statement time-out (read-only, cancelled):** at 11:55 one page-check query hit its own 9 s `statement_timeout` and was cancelled. The planner had inlined the check across the join. It was re-run as materialised batches of 60–70, at about 60 ms a check.
- **Rejected before running:** four queries failed at parse or plan (one invalid regex and three column-name errors) and did no work. The window counts above include them.
- **At an admission minute:** one keyed lookup ran at 12:17:5x, near the `:x8` slot.
- **Breach of the briefing (recorded, not relabelled):** the briefing said to check `cron.job` before each batch. This stream checked it only at 11:05.
  - The stagger was applied after that, so `coverage-admit-intakes` moved to `:x5`. The queries at 11:45–11:47, 11:55–11:56, 12:05–12:07 and 12:15–12:17 therefore overlapped its runs at 11:45, 11:55, 12:05 and 12:15.
  - Those runs took 28.0, 37.0, 28.5 and 26.4 s, against a median of 28.5 s and a maximum of 38.7 s over 11:00–12:45.
- **Admission results, 11:00–12:45 (checked at 12:45):**

  | Job | Runs | Failures | Median | Maximum |
  |---|---:|---:|---:|---:|
  | `coverage-admit` | 11 | 0 | 32.0 s | 48.3 s (11:33) |
  | `coverage-admit-intakes` | 9 | 0 | 28.5 s | 38.7 s (11:08) |
  | `adapter-overwrite` | 11 | 0 | 25.8 s | 54.5 s (11:23) |
  | `exit-awards-apply` | 2 | 0 | — | 49.1 s |

  No failure and no run above twice its median coincided with this stream. The longer durations followed the stagger, not the query windows. The other window minutes were not admission slots after the stagger. If any later investigation links a slowdown to these windows, it is recorded as "suspected validation-induced interference, pending root-cause verification".

## 6. Addendum, 2 Nov 16:07–16:47: route file v1 refused; v2 prepared

**What the integrator applied** (as reported at 16:07):
- H11 (#28614), H24 (#28615) and the tranche (#28622: 101 courses, 112 inactive, 83 primary, consumer values unchanged).
- E16 group (a) (#28616, #28617), E16 unclear (#28620) and F1/F3 (#28618, #28619).

The route file v1 refused at its first guard ("H05 A: 42 / c2a43377…"). Nothing was written.

### Why H05 grew

**Measurement windows:** read-only, at 16:07, 16:16–16:17, 16:26 and 16:46, all in the :x6–:x8 minutes. The admission jobs now run at :x3, :x5 and :x9.

**H05 now:** half A 42 (md5 `c2a433775d22ec3595e21a543ae5a19b`) and half B 39 (md5 `382e8222666a3423b060f7c8e3b1e86b`), 81 in all. That is **25 more** than at 12:15 (14 in A, 11 in B).

**Writer:**
- **Job:** `course-url-fill` (`security.course_url_fill_v1`, cron `23 2 * * *` UTC, 13:23 AEDT).
- **Run:** 2 Nov 13:23, succeeded in 2.4 s.
- **Event:** **#28612** `course_url_filled` (filled 45, emptied 20, refilled 22, retracted 20; NZ 40, CA 4, AU 1).

**What the fill did:**
- It wrote `course_url` from the proven coverage binding on 25 courses whose single active official link is a different (sweep) page.
- Half A: AU5502, AU4090, AU4055, AU5658, AU0092, AU0371, AU0408, AU0047, AU0087, AU0059, AU4105, AU0354, AU0025, AU5752. Identity basis: adapter_title 12, degree_name 2. None is retracted.
- Half B: 11 more from the same run.

**Ruled out:** E16 group (a), the tranche, the :37 exit-award lane and the admission jobs.

**Ongoing drift:**
- All 81 H05 courses carry a live `course_url_fills` row, so H05 is produced by this job and grows on most days.
- Fill counts by day: 24 Oct 19,089; 27 Oct 131; 28 Oct 146; 30 Oct 1,280; 1 Nov 306; 2 Nov 45.

**No extra work today:** all 25 joiners already had a pending `official_course_url` item, so pending rose 11 to 25 in half A and 12 to 23 in half B:
- **17 items:** raised 2 Nov 11:00–12:11 by the E16 binding check (lane `cricos_search`, rule `shared_page`).
- **8 items:** raised 31 Oct 17:20 by the coverage sweep. Each proposes **the very page the fill then wrote**, so `course-url-fill` wrote a page that is still under Layer 4 review.

**Engineering proposal:** `course-url-fill` should skip, or report, a course whose page has a pending `official_course_url` item. This needs a G2 setting and its own spec; no code was written.

### Re-measure at 16:16–16:27

| Group | Courses or fees | md5 | Pending (reused) | Decided before | New |
|---|---|---|---|---|---|
| H05 | 81 | as above | 48 | 32 | **1** (unchanged: OO0524) |
| H13 | 193 (unchanged since 12:15) | A `342286d1…`, B `9e9502ce…` | 1 | 4 | **188** |
| H20 | 38 fees (unchanged) | A `b9bb906f…`, B `162d2de1…` | 0 | 0 | **38** |

### Route file v2 (`H05-H13-H20-layer4-route-v2.sql`)

**What it routes:** only the measured id lists, which are embedded in the file.

| List | Ids | md5 |
|---|---:|---|
| H05 | 1 | `67224396c18f6449037d3237ee3dad43` |
| H13 | 188 | `caa6dcbaf608efb9fd0c7c34a5c3865d` |
| H20 (fees) | 38 | `327a8c2e060ca7fe540cf1ee3f5e2df8` |

**Transcription check:** the lists were copied from the query output and checked against the live md5s per half. They are re-checked first at run time.

**Per-row handling:**
- Each row is re-checked live for eligibility.
- Then the route's own dedupe runs: lock, reuse a pending item, Decision 263.
- A row that is no longer eligible is counted and skipped.

**Refusal rule:** the run refuses if more than 10% of the links or fees listed have moved.

**Extras:** courses that qualify now but are not on the lists are counted in the audit event (`h05_extras_unrouted`, `h13_extras_unrouted`). They are not routed.

**What it writes:** only new pending items, with no withdrawal. The rollback sets them to `superseded`.

**Expected on production (16:27 state):** 189 link items (1 + 188), 38 fee checks, 0 reused, 0 extras, 0 duplicates.

**Local PostgreSQL 16 run** (fixture with the real measured ids, 1 listed course pre-pending, 1 extra each for H05 and H13):

| Test | Result |
|---|---|
| First run | 188 link items created, 1 reused, 38 fee checks, extras 1/1 reported and not routed, 0 duplicates |
| Second run | Refused: 189 of 189 now pending |
| 5 listed courses no longer eligible | Refused at the fee tolerance (5 of 38 fees, 13%) |

The fee list is small, so a few changed courses refuse the whole run. That is deliberate: re-measure instead.

## 7. Execution record (integrator, 2 Nov 2026, each with Platform Admin approval of the database prompt)

| File | Run (AEDT) | Result | Event |
|---|---|---|---|
| H11 component-register drift | 14:46 | 6 rows (2 retired, 2 dated 5 Nov, 2 paused jobs retiring) | #28614 |
| H24 Layer 2 batch closure | 14:47 | dc4fabeb running → partial, completed_at = last heartbeat; 0 open on the profile | #28615 |
| H01/H03/H04/H09 duplicate-link tranche | pre-flight 15:26–15:27 (both halves matched md5s; 83/83 page checks pass); write 15:56 | 101 courses; 112 superseded links inactive; 83 kept links primary; 101 courses with exactly one active primary link equal to the shown URL; consumer values changed 0 | #28622 |
| H05/H13/H20 route v1 | 16:06 | refused at guard "H05 A: 42" (course-url-fill drift, §6); nothing written | — |
| H05/H13/H20 route v2 (md5 697d0e9b…) | 17:06 | 189 link items (H05 1 + H13 188) and 38 fee checks created; 0 reused, 0 decided before, 0 no longer eligible; 0 duplicates; 0 withdrawals | #28640 |

Not run: H10/H27 retirement evidence (draft, needs separate approval). Open finding for engineering: `course-url-fill` writes `course_url` while a pending `official_course_url` Layer 4 item exists (§6) — logged for the integration queue.
