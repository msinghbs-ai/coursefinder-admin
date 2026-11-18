# M2.4.7 FOLLOW-UPS

| ID | Workstream | Status | Exact next action |
|---|---|---|---|
| M247-FU-020 | Scheduler execution invariant | ACTIVE / BLOCKING CONTROL | Execution-first. Change critical-path state or stop on a specific hard external blocker; do not repeat reconciliation as progress. |
| M247-FU-021 | Admission proof contract | ACTIVE / REQUIRED FOR GATE ADVANCEMENT | Claim DATA ADMISSION only with bounded IDs, L2/L3 transitions, deterministic admission or Layer-4 disposition, canonical and Search/API delta/no-op, Evidence lineage, provider/model telemetry and resource/quota headroom. |
| M247-FU-022 | Iteration carry-forward | ACTIVE / MANDATORY — RECONCILED 2026-09-21 | Historical “resume seven”, “pending item” and new-cohort instructions are superseded. Original 10-item cohort is Layer 4; separate item `8eb0d4e1-b531-4d4e-b902-3808df9b8ea1` is now `parked` at attempt_count 6. PR #99 candidate contract/CI is exact-head green at `9b05918...`; dispatcher task/profile/auth repair is the active Gitar slice. Next: exact-head verify that slice, then benchmark-version binding and deterministic admission. Do not execute the parked item or enqueue/benchmark a cohort yet. |
| M247-FU-016 | Monitoring integrity | ACTIVE | Actual provider-call authority is `sum(external_call_count)` across live interpretations plus benchmark runs; never use work-item attempts as provider calls. |
| RLS-ADVISORY | Security drift | TRACK SEPARATELY | Reported RLS-disabled catalogue/search gate tables remain advisory only. Do not auto-enable without governed policies and do not consume the admission run unless safe execution is affected. |

## Current proof boundary

**NO DATA ADMISSION PROVEN.** Qualification PASS, CI and durable Layer-4 handover are not admission. The next legitimate advancement is exact-head task/profile/auth-safe dispatcher completion, benchmark-version binding and deterministic admission implementation before any bounded runtime proof.

## 21 September 2026 carry-forward

- **M247-FU-020:** dispatcher/reservation slice PASS at repository and Pilot runtime. Exact task/profile reservation, in-transaction profile revalidation, one-at-a-time dispatch, full-call budget and non-stranding failure fallback are now deployed.
- **M247-FU-021:** NOT SATISFIED. No validated candidate-to-canonical-to-Search/API proof exists; DATA ADMISSION is not claimed.
- **M247-FU-022:** reconciled to PR #99 `c8866b573...`, CI `35555931223/#2479` + `35555931237/#157`, migration `20260921040446`, and dispatcher v5 hash `f72a0194...`. Runtime is 10 Layer 4 + 1 parked. Next executable unit is benchmark binding (slice 3), not a parked-item retry or cohort.

### Migration-ledger reconciliation — 21 September 2026 14:12 AEST

Gitar aligned the repository migration filename to the already-applied Pilot ledger without changing SQL bytes. PR #99 exact head is now `e7b6d5b3ab345511c99fa66e35e65b89fab4d581`; Pilot Frontend Build `35560006737/#2480` and Release History Contract `35560006759/#158` both PASS. Repository file `20260921040446_cf247_task_profile_scoped_reservation.sql` now matches runtime migration `20260921040446`. Dispatcher v5/hash, queue counts and zero-call telemetry are unchanged. Slice 2 remains closed; slice 3 benchmark binding is next.


### CF-247 Slice 3A1 — 21 September 2026 15:00 AEST

PR #99 remains draft and mergeable at exact head `d3e48fa6c33cbe03cec66f3af0d3e3df50686a66`. Gitar added only the shared strict tuition response-schema export, stable candidate-validator/schema contract identifiers, and deterministic assertions in the existing required contract test. Independent diff review confirmed two files changed and no validator behaviour, benchmark execution, migration, dispatcher, interpreter, admission, Layer 4 or Search authority changed. Exact-head Pilot Frontend Build `35562558006/#2481` and Release History Contract `35562557856/#159` PASS.

This is repository/contract foundation only; it is not a runtime deployment or DATA ADMISSION. Pilot remains: dispatcher ACTIVE v5 `f72a01945792207f73af03eb40c6d74748fbf6766d4f8142d6db7a74c2897d66`; interpreter ACTIVE v5 `13c1aeea1ebd7de173b8c775231694fc1778c0e39cbd88b383cd6799388445fe`; tuition benchmark ACTIVE v11 `ac0a1e6d4670a0ffb2b7704a39ab0d6014818d576a9862a3d22c97b3433a480c`. Runtime is unchanged at 10 Layer-4-required + 1 parked; target `8eb0d4e1-b531-4d4e-b902-3808df9b8ea1` remains parked at attempt 6; Evidence 32,040; course fees 79,730. No provider call, retry, canonical or Search/API delta was caused by this slice.

Next executable unit is Slice 3A2 only: make the tuition benchmark consume the shared schema/validator and align positive/null fixtures to single-target candidate-bound semantics. Do not start binding persistence/predicate work, retry the parked item, run a benchmark, create a cohort or expand Layer 2 in that unit.

### CF-247 Slice 3A2a — 21 September 2026 17:08 AEST

PR #99 remains draft at exact head `59b7a0759d5e87a709c47586f17ed952fa12f7a0` ([commit](https://github.com/msinghbs-ai/Coursefinder-Pilot/commit/59b7a0759d5e87a709c47586f17ed952fa12f7a0)). After the prior Gitar stop, a narrower, independently verified unit replaced only the benchmark's duplicate response schema with the shared schema export and added a deterministic source assertion; two files changed. Gitar's local contract/build passed; exact-head Pilot Frontend Build `35571407034/#2482` and Release History Contract `35571407041/#160` both PASS. No deployment or benchmark execution. Pilot functions remain dispatcher v5 `f72a01945792207f73af03eb40c6d74748fbf6766d4f8142d6db7a74c2897d66`, interpreter v5 `13c1aeea1ebd7de173b8c775231694fc1778c0e39cbd88b383cd6799388445fe`, benchmark v11 `ac0a1e6d4670a0ffb2b7704a39ab0d6014818d576a9862a3d22c97b3433a480c`. Fresh queue read: 10 `layer4_required`, 1 `parked`; bounded item remains parked at attempt 6. No provider call, retry or admission was triggered; fresh broader resource, canonical and Search/API counts were not measured. **NO DATA ADMISSION PROVEN.** Next run: complete 3A2 shared-validator adoption and candidate-bound control fixtures only, then independently verify exact-head CI. Binding persistence/predicate remains 3B; do not retry the parked item, benchmark or expand L2.

- 2026-09-21 20:04 AEST: FU-020 remains open; Slice 3A2c is exact-head CI-verified at Pilot `463821f`, but benchmark v11 remains deployed and no execution/admission occurred. FU-021 remains unproven. FU-022 carry-forward: next unit 3A2d known-positive provider scoring; then 3B exact binding. A separate `463821f` Gitar review fix marks transport errors inconclusive; do not count transport as semantic PASS. Queue 10 Layer-4-required + 1 parked. No parked-item retry or larger L2 wave.


### CF-247 Slice 3A2d — 21 September 2026 22:00 AEST

PR #99 remains draft/open/mergeable at exact head `82577c36b6326b35f063eabe8c3c13c992c0888b` (one commit ahead of `463821f`; auto-merge not enabled). Independently inspected the two-file Gitar diff: the provider corpus now has fixed `resolve_candidate` expected truth and uses `validatePositive(r.parsed,candidateContext,evidence)` regardless of the keyword diagnostic; transport failures are invalid/inconclusive rather than semantic Layer 4. Four synthetic null controls, shared validator and quote/confidence/Evidence checks remain. Deterministic contract regressions were added. Exact-head Frontend Build `35592290555/#2491` PASS and Release History Contract `35592290539/#163` PASS; Gitar reports scoped contract/build/browser checks green. No new deployment. Pilot still has 10 `layer4_required` + 1 `parked` (fresh read); parked item was not retried. Dispatcher ACTIVE v5 `f72a01945792207f73af03eb40c6d74748fbf6766d4f8142d6db7a74c2897d66`, interpreter ACTIVE v5 `13c1aeea1ebd7de173b8c775231694fc1778c0e39cbd88b383cd6799388445fe`, benchmark ACTIVE v11 `ac0a1e6d4670a0ffb2b7704a39ab0d6014818d576a9862a3d22c97b3433a480c`. No benchmark, provider call, admission or consumer delta was caused by this repository-only repair; fresh Evidence/course-fee/provider-resource/canonical/Search/API totals were not measured. **NO DATA ADMISSION PROVEN.** Next bounded unit is Slice 3B only: persist/compare an exact benchmark qualification binding covering shared validator implementation, response schema, profile prompt/system, model identifier and relevant settings; invalidate PASS on any mismatch. Require exact-head tests/CI and read-only runtime proof before any benchmark execution or parked-item/cohort retry. Larger L2 waves remain paused.


### CF-247 Slice 3B1 — 22 September 2026 02:00 AEST

Pilot PR #99 remains draft/unmerged at exact head `86345a880692e30bb9e9b6512ecac5fa6b730ec6` (auto-merge off). Independently reviewed Gitar's bounded binding-helper/test changes: the descriptor now derives real benchmark/interpreter prompt-building and provider-request source, the shared validator implementation/instruction and response schema, plus profile model/prompt/validator settings. The binding contract test is required in Frontend Build. Exact-head Frontend Build `35617285293/#2494` and Release History Contract `35617285480/#166` PASS; independent local binding and tuition contract tests PASS. This is descriptor/CI foundation only: no benchmark PASS is persisted or compared at runtime, no function was redeployed, and the existing PASS remains unbound. Pilot queue is 10 `layer4_required` + 1 `parked`; dispatcher v5 `f72a0194…`, interpreter v5 `13c1aeea…`, benchmark v11 `ac0a1e6d…` remain deployed. No provider call, parked retry, admission or consumer delta was caused by 3B1. **NO DATA ADMISSION PROVEN.** Next bounded unit is 3B2 only: forward-only PASS binding persistence and fail-closed comparison at every tuition execution/reservation gate, with profile-change invalidation and exact-head tests/CI; do not run benchmark or cohort until deployed proof. Larger L2 waves remain paused.


### CF-247 3B2A safety hold — 22 September 2026 03:10 AEST

Read-only Pilot check found tuition profile `openrouter-provider-tuition-validation-v1` enabled and unpaused on legacy benchmark run `76ba93df-7a0b-4646-be85-a22c6a548b49` with `quality_benchmark.pass=true` but no binding hash. There were no reserved/interpreting work items (queue: 10 Layer-4-required + 1 parked). A guarded Pilot update set only this tuition profile `paused=true`; legacy PASS/history were not rewritten. Gitar was given one bounded 3B2A instruction at PR #99 comment `5764398252` for source-derived binding manifest and forward-only PASS persistence, with explicit no-unpause/no-execution scope. PR #99 was draft at `86345a880692e30bb9e9b6512ecac5fa6b730ec6` when instructed. No provider call, benchmark, retry or admission occurred. Next: verify Gitar's exact diff/CI or implement the same 3B2A unit after a 45-minute stall; then separate 3B2B eligibility gates. **NO DATA ADMISSION PROVEN.**


### CF-247 3B2A baseline and manual failover — 22 September 2026 03:24 AEST

Pilot PR #99 draft head `f5bb7ead2fa1874e821d57a93a28cab8a994f67a` adds one NEW, UNAPPLIED migration containing the exact live tuition-benchmark record RPC baseline, function-body MD5 `7556ed94d82ec8fa46eb069b891e9737`; local comparison with fresh `pg_get_functiondef` was byte-identical. Do not apply the baseline as a standalone no-op; complete 3B2A in this same unapplied migration first. Exact-head Frontend Build `35630687777/#2495` and Release History Contract `35630687692/#167` PASS. Gitar independently matched the in-branch digest but stopped without a corrective commit because it lacks direct Pilot DB access and requires a credentialed CI/live diff. This is a Gitar capability blocker, not authorisation to weaken the check. The tuition profile remains paused against legacy unbound PASS; queue 10 Layer-4-required + 1 parked, no active execution or admission. If no manual/Gitar progress for 45 minutes after the last action, manually implement the same bounded forward-only 3B2A with direct live-function verification and exact-head CI; do not start 3B2B, deploy, run benchmark, unpause, retry parked, merge or expand L2. **NO DATA ADMISSION PROVEN.**


### CF-247 3B2A fail-closed migration foundation — 22 September 2026 04:12 AEST

After >45 minutes without Gitar progress, manual failover verified the live tuition recorder MD5 `7556ed94d82ec8fa46eb069b891e9737` and advanced only the same 3B2A unit. Pilot PR #99 remains draft at exact head `c1a7d411f9e338c6137187db93dfb46a231ca0e8` (a subsequent merge/synchronisation preserved the two changed blobs). Its **unapplied** `20260921171328` migration adds nullable SHA-256-format `binding_hash` storage to benchmark runs and disables the legacy ten-argument unbound recorder before its scorer/profile mutation. The original live scorer stays byte-identical behind the guard; the required binding contract checks this baseline, guard order, schema and service-role grants. Local binding/tuition tests PASS; exact-head Frontend Build `35636595427/#2498` and Release History Contract `35636595401/#170` PASS. This is **not** binding persistence or migration replay and must not be deployed alone as qualification: the bound recorder, source-derived worker manifest/handoff and later 3B2B gate comparisons remain. Runtime tuition profile stays paused with legacy unbound `pass=true`; queue 10 `layer4_required` + 1 `parked`. Dispatcher v5 `f72a0194…`, interpreter v5 `13c1aeea…`, benchmark v11 `ac0a1e6d…` unchanged. No benchmark/provider call, parked retry, deployment, admission or consumer delta. Next run continues **3B2A only** (source-derived manifest, bound recorder/persistence and worker handoff), then independent exact-head tests/CI; 3B2B remains later. **NO DATA ADMISSION PROVEN.**


### CF-247 3B2A source-binding correction — 22 September 2026 05:06 AEST

PR #99 remains draft/unmerged at exact head `eb432f4ad155010cb6292111c96f6dc3ef0f4d87`, with no unresolved review threads. Live `layer3_cf245_tuition_benchmark_profile_service` exposes `deterministic_validators` and `structured_output_schema`; the previous 3B1 descriptor incorrectly read `validators` (defaulting the values), omitted `max_output_tokens`, and omitted the stored profile schema. Manual 3B2A repair now binds the complete live validator JSON, stored profile schema and output-token setting without silent defaults. A checked-in source-hash manifest is verified by the mandatory binding contract against actual benchmark/interpreter prompt and request spans, validator source, shared response schema and helper source; drift fails CI. Local binding and tuition contracts PASS. Exact-head Frontend Build `35642420505/#2501` and Release History Contract `35642420484/#173` PASS. This is a repository-only descriptor/manifest correction: the unapplied migration's legacy recorder remains fail-closed, but the bound recorder/worker handoff and runtime PASS comparison are NOT implemented; do not deploy or run qualification based on this partial unit. Runtime tuition profile stays paused on legacy unbound PASS, queue unchanged at 10 `layer4_required` + 1 `parked`, deployed dispatcher v5 `f72a0194…`, interpreter v5 `13c1aeea…`, benchmark v11 `ac0a1e6d…`. No benchmark, provider call, parked retry, admission or consumer delta. Next run: **3B2A bound recorder + benchmark-worker binding handoff only**, then separate 3B2B gates; preserve draft, pause and larger-wave hold. **NO DATA ADMISSION PROVEN.**

### CF-247 Scholarships — parked 9 Oct 2026 08:50 (Melbourne)

Parked by the Platform Admin ("park this for circle later"): review why New Zealand and Canada provider scholarships stay thin. Canada: of about 1,600 university scholarship pages read, 43 admitted; most rejections are "international_not_stated" (often with "no_named_title"). New Zealand: 76 held from 8 universities. Proposed first step when resumed: hand-check about 30 rejected Canadian and New Zealand pages, read-only, to see whether the "international not stated" rule is too strict for those sites, then propose a rule change for a decision.

### CF-247 Canada Layer 1 — opened 9 Oct 2026 09:30 (Melbourne)

1. Ten Canadian readers held after first verification (exact-count checks out of date or detail check failed): Boreal, Centennial, Fanshawe, Fleming, Lambton, Northern, Sault, Seneca, St Clair, St Lawrence. Each needs its expected count re-based against the current site (reader change, deploy, re-verify, first run, then `admin_layer1_schedule` monthly).
   - **Parked 9 Oct 2026 09:40 (Melbourne), approach decided.** Platform Admin chose "Re-base the 10 held readers", then "Use the Layer 1 variance gate" for all 26 Canadian readers, then parked the work for later. Approach when resumed: replace each reader's hard-coded exact count with a minimum floor that only catches a broken parser, and let Layer 1 judge drift against the last accepted run (warn 5%, block 20%; `previous_accepted_count` is already set for the 16 scheduled sources). Fleming (response wait exceeded) and St Lawrence (detail check failed on 0263) need their own look. Nothing changed yet; the 16 scheduled sources keep their exact counts until then, so any of them may fail a monthly verification if its site changes.
2. Seneca register adapter `ca_seneca` copies reader v0.1.0; the deployed reader is v0.3.1 and reads a different page. Re-derive the adapter and its replay from v0.3.1 before any switch-on.
3. Phase B: ALIS, EducationPlannerBC, NSCC, Saskatchewan Polytechnic and Quebec MES paged readers.

### CF-247 old-system clean-up — database leftovers (opened 9 Oct 2026 14:10, Melbourne)

To be done in the SQL editor (drops and deletes): the old database functions behind the screens removed in batch 2 (scholarship_scope_acquisition_service, scholarship_international_detail_batch_service, reconcile_verified_detail_records, scholarship_runtime_settings_write, layer3_source_pattern_queue reads, layer2_profiles / layer2_profile_detail / layer2_provider_routes / layer2_provider_onboarding_queue_v1 admin reads) and the batch-runner dispatch chain (layer2_run_batch_dispatch, layer2_operator_sync_service, layer2_scope_profile_batch_service, layer2_wave_dispatch_request, scholarship_scope_scheduler_tick_impl, svc_pilot_invoke_layer2 branch in trg_submit_pilot_edge_execution); run-token rows for layer2-batch-runner, layer2-scholarship-extract-v2, layer2-v2-diagnostic, scholarship-scope-job-execute; then the 8 dormant v2 Layer 2 functions (layer2-acquire-v2, layer2-extract-v2, layer2-provider-page-fanout, layer2-scholarship-extract, layer2-course-fact-extract-v2, layer2-scholarship-catalogue-enumerate, layer2-hotcourses-directory-parse, layer2-provider-asset-promote) and layer2-scope-discover-scheduled, after a live check of each.

- 9 Oct 2026 16:55 update: batch 4 done (15 functions dropped, trigger branch removed, run tokens removed, 4 dormant edge functions retired). Still open: the 11 functions reached from admin_read 'scholarship_runtime_uat' and the scheduler workflow bridges (remove those admin_read branches and bridges first), layer2_background_scope_service, the provider-asset edge functions (decision), layer2-acquire-v2 and layer2-scope-discover-scheduled.

## 18 Nov 2026 11:45 AEDT — S2 - BOOST: refused study loads to Layer 4 (Pilot #1251); Boost multi-field reading live in shadow (Pilot #1255, #1261); run-3 PASS

**Trigger:** Platform Admin 18 Nov 2026 07:08 (decisions 3 and 4) and 10:10 AEDT (priority execution), chat S2 - BOOST.

**Done:**
- **Decision 4.** Pilot #1251 (migration `20261118111500`, s618): refused Boost study-load readings (the page had study-load text and the answer failed the page check) go to Layer 4 › Inbox as kind **Boost study load**; "not stated" rows and failed calls never do. Own cap `boost.layer4_open_max` (400, not the recovery lanes' 150), refilled after each result file and each decision. Choices (Pipeline Operator or above): Full-time, Part-time, Both (fills `study_load` only while empty and unlocked, source `manual`), Not stated on the page, Dismiss. Read back 10:31: all 376 refused readings open; at 11:36 the Inbox holds 400 (the cap) as new pages are read.
- **Decision 3.** Pilot #1255 (worker `coverage-sweep` v1.0.16, migration `20261118121500`, s621): job `boost-fields` reads each stored course page once for every gap field the course misses (course description, delivery mode, intakes, tuition fee, entry requirements), in Boost priority matrix order, through its own route `boost_fields_extract` pinned to Qwen3 30B (US$2 / 6,000 calls a day). Each answer is checked against the whole page and staged in Storage `staging-boost/fields` and `pipeline.boost_field_candidates`, `promotion_state` shadow, with the field's owner. **Nothing is admitted** until each owner's rule takes Boost candidates. Its claim timed out under the API from 11:01 (no page read); fixed by Pilot #1261 (migration `20261118130000`, s626: one pass from the stored pages, post-check under an 8-second time-out).
- **Read back 11:36 AEDT:** 59 pages read for US$0.010 (59 calls); field answers verified / refused / not stated: entry requirements 31/21/4, course description 23/7/1, intakes 0/14/10, delivery mode 1/9/1, tuition fee 1/7/2; 0 left shadow. The commonest refusals: quote not on the page, intake month not in the quote, entry quote not a requirement. Early figures; the refusals keep wrong values out of staging.
- **Study load keeps admitting** as S2-Build's page feed (Pilot #1252, merged by S2 - BOOST on green under the standing mandate) adds stored pages: 1,703 admitted, courses holding a study load 4,224 (2,521 this morning). G3 75 functions and 48 relations, no drift.
- **Test project:** S1-Build posted "can re-seed" at 10:59; run-3 dispatched 11:11 (admin run 44205747811): cohort re-seeded (12 providers, 69 courses, 60 without study load), promotion function byte-identical to production, **PASS** on every check (60 admitted for 60 courses, nothing held changed, cohort put back, G3).
- **Registers:** test register regenerated from Pilot `main` `14a30503` (741 specs, 3,474 tests); nine S2 - BOOST engagements logged (RM0, 135 minutes; ledger 69 rows, 1,035 minutes); workbook rebuilt; Drive Monitoring synced.

**Next:** owner rules for Boost field candidates (each owner turns its rule on); Thursday squash: re-seed and run-4 right after 03:30 AEDT; watch the multi-field refusal rate as more pages are read.

## 18 Nov 2026 12:25 AEDT — S2 - BOOST: Qwen3 30B kept solo; AER and scholarship admission audited; Scholarship course links in Layer 4 (Pilot #1267); Layer 4 approval requirements

**Trigger:** Platform Admin 18 Nov 2026 11:57 AEDT (directive: keep Qwen3 30B solo; audit and drive scholarship and AER admission; document the Layer 4 approval requirements), chat S2 - BOOST.

**Done:**
- **Model decision closed.** Qwen3 30B stays the only model qualified for Boost study load (bench-4: 0 failed calls). No second route for Mistral Small 3.2.
- **Scholarship course links into Layer 4 (Pilot #1267, migration `20261118143000`, s631; also merged S2-Build's green #1266 first so its migration landed in order).** The 57 scholarships waiting to link hold 18,023 proposed links, all "provider owned but no explicit course or provider scope" (each proposed against every course of its provider, e.g. a School of Business award against all 575 UBC courses), so they need one scope decision per scholarship, not row-by-row approval. New Inbox kind **Scholarship course links**: one item per scholarship with a rule-based suggested scope from its own name and description (study levels; subject words from setting `scholarship.scope_suggest_subjects`), the courses it keeps, and the text it rests on. Choices (Pipeline Operator or above): Accept the suggested scope, All courses, No courses; each calls the existing `public.admin_scholarship_links_decide`, so decisions are recorded exactly as on the Course links screen. Read back 12:19: 57 items; 38 with a suggestion (together keeping 800 of the 18,023 links), 19 with none found; G3 75/48, no drift.
- **AER: nothing to advance; everything clean is already in Layer 4 or already admitted.** All 3,302 proposed provider-matrix rows (60 providers: AU 2,605 rows / 46 providers, NZ 697 / 14) and all 9,718 proposed course entry rows (2,578 courses) are covered by pending Layer 4 items. Machine admission is on for both (`aer.machine_mode` and `aer.matrix_machine_mode` = 2): it has admitted 8,611 course reads and 22 matrix runs; what remains waiting is what its rules declined (below). AER v1 is frozen (Decision 276), so no new recovery path was added. Every proposed row carries `source_url`, a verbatim `quote`, `as_at` and its evidence; `edition` is empty on 2,920 of 3,302 proposed matrix rows and `routes` is empty on all (both AER v2 fields; not part of the v1 admission rules).
- **Grade scale conversions: not seeded, with reason.** `ref.grade_scale_conversions` holds 0 rows and has no Layer 4 queue. The "1,289-row matrix (16 providers)" is the active provider entry matrix as recorded on 12 Nov (now 5,542 active rows, 22 providers), not grade-scale data. A grade scale needs an official source that states its 0–100 normalisation; none is held, and deriving one would put unsourced numbers in front of reviewers. The loader exists: Layer 1 induction (Pilot #1258, S2-Build) loads grade scales **inactive for review** when such a source is run.
- **Scholarship field gaps (reported to the Scholarships lane, not re-extracted):** of 456 active unpublished scholarships, 287 have no award value; 645 of 1,060 published have no closing date. The scholarship AI extraction lane owns these reads; a second extractor was not added.

**Layer 4 › Inbox, waiting items by kind (read 18 Nov 2026 12:19 AEDT):**

| Kind | Items | What one decision covers |
|---|---|---|
| AER provider matrix (`entry_matrix_first_run` 77, `entry_matrix_change` 6) | 83 (3,302 rows, 60 providers) | one provider's whole table |
| AER course entry (`course_entry_first_read`) | 2,578 (9,718 rows) | one course's rows; 488 are the 5% audit sample |
| Grade scale conversions | 0 (no rows held) | — |
| Scholarship course links (new) | 57 (18,023 proposed links) | one scholarship's scope |
| Held scholarship pages (`held_scholarship`) | 89 (38 providers) | one page |
| Refused study loads (Boost study load) | 400 (cap `boost.layer4_open_max`) | one course |
| Campus postcodes (`campus_locality`) | 312 | one postcode (all its campuses) |
| Official course URLs and tuition checks (`course_link`) | 1,487 (1,335 URLs, 146 tuition validations) | one course |
| Course page needed | 1,958 | one course |
| Descriptions (provider and course first read) | 751 | one description |
| Provider blockers (site down, no pages, website needed and the like) | 752 | one provider |
| Human input needed (interventions) | 491 | one case |

**What a row needs to pass Layer 4 into the consumer API:**
- **AER provider matrix row** (machine rule, `security.aer_matrix_machine_check_v1`; a person decides the rest): source on the provider's own official host, not a host shared with another provider; the read shown complete (D-R3); `confidence` ≥ `aer.matrix_machine_min_confidence` (0.9); verbatim `quote` of at least `aer.machine_min_quote_chars` (8) characters that contains the value; study level mapped; `min_grade`, or `min_value` with a `grade_scale`; not a change to an already admitted table; no earlier rejection of that source. Present on every row: `source_url`, `quote`, `as_at`, evidence. `edition`, `routes` and `conditions` are carried but not checked in v1.
- **AER course entry row** (`security.aer_machine_check_v1`): verbatim `quote` ≥ 8 characters, `confidence` ≥ `aer.machine_min_confidence` (0.8), this read's evidence, the page bound to the course by an admitted identity basis, and the stored page not shared with other programmes.
- **A person's decision on AER:** Approve, Approve except (tick the rows to leave out, one reason) or Reject; no inline edits (decision A1). Approved rows become `active`, which API v3 reads.
- **Scholarship course links:** one scope decision per scholarship (all, matching levels/fields/title words, or none); accepted links become `scholarship.course_mappings` with basis `scope_decision:*`.
- **Refused study load:** a value (Full-time, Part-time, Both) fills `study_load` only while it is empty and unlocked (source `manual`, evidence the stored page); or Not stated; or Dismiss.
- **Campus postcode:** accept the largest-share locality, choose another candidate, or none; the decision applies to every campus in that postcode.

**Why waiting AER items were declined by the machine rules:**
- Course entry: stored page shared with other programmes 1,874; every row fails a row rule 102; no bound course page 39; a row lacks quote, confidence or evidence 19; identity basis not admitted 18; not yet checked 82.
- Provider matrix: read not shown complete 61; every row fails a row rule 15; change to an admitted table 6; no minimum 4; level unmapped 3; source not on the official host 2; shared host 2; no rows 1; earlier rejection 1.

**Bulk or provider-level approval versus single-row inspection.** Phase 5's review grid (S2-Build, Pilot #1253, merged) is a view: rows, saved views (AER Audit Samples, Official URLs, Provider Blockers) and the quote-versus-value drawer. Decisions still go one item at a time through `public.admin_layer4_inbox`; there is no bulk-approve action yet.
- **Already batched (one decision, many rows):** scholarship course links (about 316 links per decision); AER provider matrix items (a provider's whole table, Approve or Approve except).
- **Candidates for a grouped decision once a bulk action lands:** AER course items declined only because the stored page is shared (1,874), grouped by provider and shared page, since one confirmation of which programme the page serves settles the group; refused study loads with the same quote at the same provider (for example "Part-time study is not available for international students"); course pages needed and official URLs grouped by provider.
- **Single-row inspection only:** the 488 AER audit-sample items (the 5% sample exists to be checked one by one); changes to an admitted matrix (6); matrix rows with an unmapped level or no minimum; host problems; identity not admitted; campus postcodes (each postcode is a different place).

**Next:** the Scholarships lane, the 57 scholarship decisions and their 287 missing award values; AER v2 for `edition`/`routes`; a bulk-decision action on the Phase 5 grid for the grouped cases above.

## 18 Nov 2026 14:10 AEDT — S2 - BOOST: all 57 Scholarship course links resolved by deterministic rule (Pilot #1273, #1276)

Platform Admin 13:06: resolve every Layer 4 › Scholarship course links item without a person.

- **Decision order.** Each waiting scholarship got a decision from its own name, then its description, under the automated rule authority:
  1. Wording that is not course-specific in its name: No courses.
  2. A scope from its own words that keeps a course: that scope.
  3. Explicit university-wide wording with no level or subject: All courses.
  4. Otherwise: No courses.
- **Audit.** The reason "Auto-applied deterministic title/description scope rule: …" names the rule used. The existing `security.scholarship_scope_apply_v1` applied each decision, with a `pipeline.layer4_mass_operations` row per scholarship.
- **Migrations and settings.** Migrations `20261118153000` (#1273) and `20261118163000` (#1276, correcting three decisions read back live the same hour), spec s636. The word lists are settings in Pipeline settings › Scholarships.
- **Live at 14:05:**
  - 57 decided: 42 only matching courses, 1 all courses, 14 no courses.
  - 694 links written and 60 audit rows.
  - 0 waiting, and the Inbox count is 0.
  - No decision made by a person was touched.
  - G3 75/48; head `20261118163000`.
- **Open:** the Course links screen is not yet verified signed in. A person can change any of the 14 No courses on that screen at any time.

## 18 Nov 2026 15:45 AEDT — S2 - BOOST: reader v5, Course link and Boost study load settled by rule (Pilot #1283, #1284, #1286)

Platform Admin 14:23, 14:25 and 14:29.

- **Reader v5 (worker coverage-sweep v1.0.17, prompt `boost-study-load-v5`).** A fee note (EFTSL, CSP, a fee calculated on a standard full-time load) is never sent or accepted as the study load (s647, renamed from s643 in #1289).
- **Boost study load (400 open readings).** 94 admitted on the v5 re-read, 231 settled Not stated by rule l4-boost-sl-settle-v1, 75 waiting for their re-read (job every 30 minutes). 38 of the Not stated readings had a sentence for international students that the reading did not use; a person may want to check them.
- **Course link (1,487 to 423).** Rule l4-link-accept-v1, from the binder's proof, first run 0 failed:
  - 154 pages used and 105 proved pages set: 259 official links written.
  - 809 proposals refused (nothing linked).
  - 16 left as the audit sample and 251 held for a person.
  - Fee and English items were not touched.
  - Job `layer4-link-accept` runs hourly.
- **Scholarship course links stay at 0.** Job `scholarship-scope-auto` runs hourly.
- **Course page needed (1,958) is unchanged.** 1,568 items have every page found refused by the binder, 288 have a dead 404 page (163 of them at Adelaide University: adelaideuni.edu.au addresses, probably moved to adelaide.edu.au; not checked live), 60 are unread and 41 blocked. None has a proved page, and the search and reader lanes are paused.
- **Open, needs a decision:** the 14:23 items (scholarship deadline refresh REQ-71 and REQ-72; multi-field admission REQ-61, REQ-69 and REQ-70) were held because that message ruled out migrations. The round-state refresh has not run since 17 Nov 00:23 UTC (its only caller job is paused) and uses the UTC date.
- Migrations `20261118171000`, `173000` and `183000`; specs s644, s645 and s647. G3 75/48.

## 18 Nov 2026 17:00 AEDT — S2 - BOOST: Course page needed through the search lane by rule; study-load settlement heals itself (Pilot #1293, #1295)

Platform Admin 16:10.

- **Course page needed (1,958 to 1,360).** Rule l4-page-needed-search-v1 (s654, job hourly at minute 53, 300 a run) sends each open item back to the course-link search lane through the existing Search again decision under the system automation account. 404 and unread pages go first. The lane's caps and Firecrawl limits apply, and no on-demand work was opened. 43 blocked or robots pages wait for a person.
- **Correction to 15:45.** The search worker and the course-list reader run live through the lane dispatcher; they are not paused.
- **Adelaide University.** `adelaideuni.edu.au` is the live domain and the `adelaide.edu.au` alias was already in place. The 203 404s are addresses guessed from titles; they were sent for a new search.
- **Study load.** Rule l4-boost-sl-settle-v1 now releases pages last read with an older prompt (s655). The 74 that the old worker read with v4 during the deploy are released for v5. Totals: 94 admitted, 231 Not stated, 75 to settle.
- **Not done, with reasons:**
  - The international cue (38 items) needs the stored sentence texts, which this session cannot read.
  - AER shared-page splitting is a new layout reader under the v1 freeze (Decision 276).
  - The 751 descriptions are already read and are held by identity and wording rules; scraping again would not change that.
  - The offline multi-field qualification has no person-decided reference answers.
- Migrations `20261118190000` and `193000`. G3 75/48.
