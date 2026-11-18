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

## 18 Nov 2026 17:30 AEDT — S2-BOOST-Providers: campus locality, held scholarship re-check and university description name forms by rule (Pilot #1298)

Platform Admin 16:56 and 17:03. One migration, `20261118203000` (md5 `df6991b9`); specs s680, s681 and s682. No table or column added.

- **Campus locality (312 to 78).** The 90% test used the share of a postcode's area inside the Significant Urban Area, so regional city postcodes always failed it (Armidale 2350: 6% by area, 82% by mesh blocks).
  - Rule l4-campus-locality-v1 (job `layer4-campus-locality`, hourly at minute 57) uses the ABS mesh-block counts already loaded, and the campuses' own suburb name, through the existing Inbox decision under the system automation account.
  - First run: 63 postcodes and 234 campuses settled, 0 failed. 44 postcodes by mesh-block share of 90% or more, 17 because every waiting campus gives the area's name as its suburb, 2 recorded as outside every area (Bellingen 2454, Murwillumbah 2484).
  - 31 postcodes (78 campuses) wait for a person: the campuses name different suburbs, or no area holds half the mesh blocks.
  - `ref.localities` does not exist. The reference tables are `destination.localities`, `destination.locality_postcodes` and `destination.abs_postcode_sua_shares`, Australia only; no New Zealand campus waits.
- **Held scholarships (89).** 82 had never had the AI re-check: it was queued once, by a data update on 19 Oct, and nothing queued it for items held later.
  - Rule l4-held-sch-recheck-v1 (job `scholarship-recheck-queue`, hourly at minute 9) queues it for every held page with a stored copy. First run: 72 queued; 11 have no stored copy and wait.
  - At 17:30, 60 of the 72 were re-checked for US$0.0072: 52 with a value sentence and 47 with an audience sentence quoted from the page. Recommendations: audience not stated 46, not for international students 5, international, check and publish 4, international but value unclear 3, not settled 2. The other 12 were still queued.
  - The 89 are still held. The re-check records a recommendation and publishes or rejects nothing; settling by recommendation is a decision for the Scholarships owner.
  - Scholarship pages not read: 89, not 69 (name does not match 46, page gone 28, blocked 10, too thin 5). None can be read from a stored copy.
- **University descriptions (88 to 86 at 17:30, settlement still running).** The Inbox kind shows 751: 88 university descriptions and 663 course descriptions, which are the Course Module's.
  - Name forms pdesc-name-forms-v2: each name of a semicolon-separated trading-name list, and a whole name's initials of four letters or more. No check, word list or admission was changed.
  - 2 admitted by the unchanged machine rule so far (ICMS and ICAE). A read-only count gives at most 8 by this rule.
  - What the rule cannot reach: 29 readings never name the provider in a sentence that passes the wording check, 33 keep fewer than two sentences once refused sentences are left out, and 12 name it only in a later sentence. They need a new reading or a person.
- G3 75/48, no drift (read 17:29). Live head `20261118203000` (2,133 applied).

**Not done:**
- The test register rows for s680 to s682 were added in the generator's format; the generator's listing step needs the full Pilot environment.
- Moving a naming sentence to the front (12 descriptions) changes the validation and the admission, which belong to the provider description owner.

**Next executable action:**
- Scholarships owner: decide whether a re-check recommendation may settle a held page by rule (5 not for international students, 4 check and publish).
- Read `pipeline.provider_description_machine_admissions` after 18:30 AEDT for the final count admitted by pdesc-name-forms-v2.

## 18 Nov 2026 17:55 AEDT — S2-BOOST-Discovery: the Course page needed searches now run (Pilot #1297, #1300); 834 are held by the stop gate

Platform Admin 16:54 and 17:02. Two migrations, `20261118200000` (md5 `77d86cb5`) and `20261118210000`; specs s656 and s657. No table, column or job added. s650 to s655 were already taken on `main`, so this lane starts at s656.

- **Finding: the Course page needed drain was not running.** Rule l4-page-needed-search-v1 (Pilot #1293) moves items off the Layer 4 list into the course-link search queue. At 17:05 all 600 it had sent were still queued with 0 attempts. Two causes:
  - Today's Firecrawl share for finding course pages (800) was used up by 00:47 AEDT, so the scheduled pick took nothing.
  - Whenever the lane had room, `public.svc_course_link_search_next` ended in a statement time-out (97 times in the seven days before 17:16; 8-second call limit). It ran the provider-level checks for all 306 providers with a queued search, about 10 seconds.
- **Pilot #1297 (s656), live 17:16.** One on-demand request (operating model 3.3.2), toolset Firecrawl, scoped to `course_search`, for the 91 providers of the items the rule had sent. Request `2fe02033`; it closes itself at 23:16 AEDT.
  - Estimate: 1,181 queued searches, 2,362 credits. Credit left on the plan before: 72,009.
  - The worker's pool is fixed at 10 searches at a time; s656 guards it.
- **Pilot #1300 (s657), live 17:48.** md5-guarded edit of the pick: the provider list is cut first to the providers the pass can take, not hidden, on the target list. Every later condition is kept. Time-outs since: 0.
- **Read at 17:55 AEDT:** 716 searches run, 1,432 credits, 0 failed. 265 courses finished: 71 found a page, 194 found none.
  - Of the 71 pages: 1 read and proved by CRICOS code, 33 not read yet, 26 could not be fetched, 5 blocked, 3 need a rendered read, 3 refused by the page check.
  - Course page needed: 1,150 open, 860 with a search asked for.
- **Finding: 834 of the searches asked for can never run.** The lane's stop gate holds them, on demand or not:
  - University search stopped after wrong pages in a row (395): Adelaide University 172, Victoria University 91, Flinders 45, Monash 35, ICMS 29. Only a person's Find course pages task passes this stop.
  - Recorded as no page published by the provider (420): Swinburne 159, RMIT 102, Southern Institute of Technology 38, AUT 37, Western Sydney 21.
  - Per-course stop (19).
  - These items left the Layer 4 list when the rule sent them, but nothing will search them. The rule keeps sending more each hour.
- **Adelaide University.** No alias added. 161 of the 163 404 pages are addresses on `adelaideuni.edu.au` itself, guessed from the course title; 2 are on `adelaide.edu.au`, already an approved host. All its searches sit behind the university stop above.
- **Course link (268 official-page items pending; the other waiting items are fee checks).** Clustered, nothing changed:
  - Old handbook year on the page shown: 158. Macquarie 2014 handbook 50, ANU 33, Melbourne 27, La Trobe 18, Sydney 19. For Macquarie, ANU and La Trobe the binder holds only the old-year page itself.
  - CRICOS page on another address: 68 (51 proved only by field and award).
  - Audit sample of finder refusals, left for a person by rule l4-link-accept-v1: 40. Two pages held: 2.
- G3 75 functions and 48 relations (read 17:56). Live head `20261118210000` (2,134 applied).

**Not done:**
- The year-preference and auto-read rule for Course link (asked for as s650) is not built. It changes what rule l4-link-accept-v1 may enter into the live catalogue, and the local spec runner is not available in this session.
- No binder matcher change (asked for as s651): the searches had not run, so there was no refusal pattern to read until 17:48.
- The 43 blocked or robots-disallowed pages were not touched.
- The test register rows for s656 and s657 were added in the generator's format; the generator needs `@playwright/test`, which this session cannot install.

**Next executable action:**
- Stop rule l4-page-needed-search-v1 sending items whose search the stop gate holds, and return the 834 parked items to the list with the gate as their reason (s658).
- Read the search results again after the found pages are read (reads run inside the scheduled share), then close request `2fe02033` with `security.on_demand_close_v1` and record the actual use.
- Platform Admin: lift or keep the university search stop for Adelaide University, Victoria University, Flinders, Monash and ICMS. While it stands, their 395 courses are not searched.

## S2-BOOST-Courses, 18 Nov 2026 18:00 AEDT: sentence cue inspected and not promoted; multi-field check v2 and replay live; 663 descriptions clustered

**Request:** Platform Admin 18 Nov 2026 17:02 (study load v6 from the 38 international-sentence items, the 663 held course descriptions, Qwen3 30B multi-field qualification). Full findings: `docs/platform/BOOST-SENTENCE-CUE-DESCRIPTIONS-AND-MULTI-FIELD-QUALIFICATION-2026-11-18.md`.

**Done and read back:**
- **Pilot #1299 and #1301 merged on green and deployed** (worker `coverage-sweep` v1.0.18, specs s660 and s663, no migration). The mode ledger shows v1.0.18 answering both new modes.
- **Read-only sentence inspection (s660).** Mode `boost_sentences` and workflow `boost-sentences-inspect.yml` return the sentences the study load reader takes as a statement for international students. No model call, no write.
- **The cue is not clean, so v6 was not promoted and nothing was admitted.** 41 pages inspected (run 44251878109): 35 are false matches (unpunctuated blocks of entry requirements, navigation, other courses, markup) and 6 hold a real statement. One page shows the reader inferring full-time from "not available to international students", which is wrong.
- **Multi-field page check `boost-fields-check-v2` is live (s663).** A description must be prose about the course; a month counts as an intake only where the quote says the course starts then; a fee needs its whole amount, currency, period and year supported.
- **Gold-set replay (run 44254128321, 80 pages, US$0.0168, nothing staged or admitted).** Descriptions 47 of 60 verified. Intakes 12 verified, 6 agree with the held value. Fees 10 verified, 7 agree. **Qwen3 30B is not qualified on any of these fields.** Deadlines were not asked: the prompt has no deadline field.
- **663 held course descriptions clustered:** identity margin thin 448, binding ambiguous 143, refused word 44, evidence moved 15, wrong page kind 13. Of the 448, the binder proved 170 by the course's own CRICOS or NZQA code and 170 by exact title after reading the page.
- G3 75/48, no drift (read 17:59). Live head `20261118210000` (2,134 applied). Route rows, the one admission qualification and the 0 field candidates out of shadow are unchanged.

**Not done:**
- Study load v6. The corrected cue (signals close together, labelled international lines, no inference from a closed course) is designed in the findings document and not built.
- No held description was admitted. The identity-proof rule changes `security.course_description_machine_check_v1`, whose live text is not in the repository; it needs a function migration with an md5 pre-check and a rolled-back dry run.
- The test register rows for s660 and s663 were added in the generator's format and the totals raised by 2 specs and 11 tests; the generator's listing step needs the full Pilot environment.
- The Google Drive Monitoring folder is synced after this change merges (the backups carry the merged commit); its result is in the session report, not in this block.

**Next executable action:**
- Capture the live `security.course_description_machine_check_v1`, add the identity-proof exemption (spec s662), dry-run it, and let the unchanged machine rule re-check the 340 items.
- Build the v6 cue behind `boost_sentences`, run it over all settled and admitted readings, and promote only if it is clean (spec s661).
- S2-Intakes: say whether an intake is the stated intake month or the teaching start date, then re-run the replay with 120 pages a field.

## 18 Nov 2026 18:45 AEDT — S2-BOOST-Providers: held scholarships settled by rule on a clear re-check; university descriptions re-read with prompt version 5 (Pilot #1302)

Platform Admin 17:52. One migration, `20261118213000` (md5 `8290da99`); specs s683 and s684, s681 guard line updated. No table, column, function or job added: the one function changed is this lane's own `security.scholarship_recheck_queue_rule_v1`.

- **Held scholarships (89 to 82).** Rule l4-held-sch-settle-v1 runs inside job `scholarship-recheck-queue` (hourly at minute 9) and decides through the existing decision under the system automation account, with the page sentences in the note.
  - It admits only when the AI re-check and the first reading both say international students may apply, the audience and value sentences were found on the page, and the page is on the provider's own https host. It refuses only when the re-check found a domestic-only sentence the first reading does not contradict.
  - First run: 3 admitted, 4 refused, 0 failed.
    - Two new scholarship records, both unpublished until the hourly publish checks pass: Ronald Lu Travel Award in Architecture (UNSW, 34 course links) and 2027 Otago Polytechnic International Scholarships (68 course links).
    - The third (Griffith) was closed as a duplicate of a record already held; no record was written.
  - 8 of the 15 clear recommendations stay held for a person: in 5 the re-check and the first reading disagree about who may apply, 1 is a staging address (Macquarie), 1 audience sentence does not say "international" (Massey), and 1 was not taken (Bond; cause not yet read).
  - Still held, as directed: audience not stated 57, value unclear 3, not settled 3, and 11 with no stored copy.
- **University descriptions (83 pending at 18:00; 81 sent back).** Prompt version 5 is active (version 4 retired): two to three sentences, the first beginning with the provider's full name, and the most-refused words left out. The 81 Layer 4 items were closed as superseded, with every reading kept, and a new read was queued for each provider.
  - At 18:40, 34 of the 81 were re-read from stored pages (no Firecrawl, US$0.0076): 6 admitted by the unchanged machine rule, 2 back in Layer 4 as proposals, 26 held by the reader's own checks, 47 still queued.
  - The name problem is gone (1 of 34). What holds them now is grounding: a quote that is not on the page (11) or a sentence its quote does not support (11).
  - **Cause to decide.** The description route now uses Qwen3 30B. Across all its readings with prompt version 4 it gave 11 usable readings of 161; GPT-4.1 mini gave 158 of 392. Version 5 lifts Qwen3 30B to 8 of 39. The route is a Models & services setting and was not changed.
  - **Effect on the Inbox.** Layer 4 › University descriptions shows 2 (plus the 663 course descriptions), but a reading the reader holds is not admitted. The earlier readings sit on the superseded items and cannot be approved from the Inbox until restored.
  - One read sat leased for 20 minutes (18:17 to 18:37) and paused the queue; it released itself.
- **Campus locality: source-data exceptions (no rule changed).** The locality follows the postcode, so a campus with a wrong postcode in its source record shows the wrong city.

| Postcode | Campus suburb and address as held | Provider | Locality now | What is wrong |
|---|---|---|---|---|
| 0830 | Alice Springs, 17 Grevillea Dr | Charles Darwin University | Darwin (by rule) | Alice Springs is 0870; 0830 is Palmerston |
| 2615 | Forest Hill, 138 Don Kendell Drive, Wagga Wagga Airport | AAPA Victoria Pty Ltd | Canberra - Queanbeyan (by rule) | Forest Hill NSW is 2651; state held is NSW, postcode is ACT |
| 2232 | Camperdown, 22 Carillon Avenue | Australian University of Theology | Sydney (by rule) | Camperdown is 2050; the city is right, the postcode is not |
| 2800 | North Parramatta, 16 Masons Dr | Charles Sturt University | Waits for a person | North Parramatta is 2151; 2800 is Orange |
| 4650 | Nambour, Blaxland Rd | Education Queensland International | Waits for a person | Nambour is 4560; 4650 is Maryborough |
| 2536 | "Batmans", Batemans Bay Education Centre | University of Wollongong | Waits for a person | Suburb misspelt (Batemans Bay) |
| 4740 | "Beaconsfiled", Celeber Dr | Whitsunday Anglican School | Waits for a person | Suburb misspelt (Beaconsfield) |

  - The first two show a wrong city on API v3 `campuses[].locality` until the campus postcode is corrected at its source (CRICOS). Campus locality stays at 78 waiting.
- G3 75/48, no drift (read 18:09). Live head `20261118220000` (another lane's); 2,136 applied.
- Google Drive `Roadmap_Engagement_Register`: the extra blank row was removed and the three rows that had landed mid-table (this lane's and two from other sessions) were moved to the end, so the sheet follows the CSV order.

**Not done:**
- The 47 queued re-reads had not run at 18:40.
- The superseded items of readings the reader held were not restored to the Inbox.
- The test register rows for s683 and s684 were added in the generator's format; the generator's listing step needs the full Pilot environment.

**Next executable action:**
- S2-BOOST-Providers, about 20:05 AEDT: read the final re-read counts and restore to Layer 4 the superseded item of every provider whose re-read was held, so a person can still approve the earlier reading.
- Platform Admin: decide whether the provider description route returns to GPT-4.1 mini.
- Correct the campus postcodes for 0830 and 2615 at their source.

## S2-BOOST-AER, 18 Nov 2026 19:00 AEDT: hand-bound shared-page rule live (s670); AER course machine admission found running in shadow since 15:40

Platform Admin 17:52. One migration, `20261118220000` (md5 `e0f5a6ff`), Pilot #1303, spec s670. Classification and reasons: `docs/platform/2026-11-18-aer-held-items-classification.md`.

**Done and read back from live (18:26 to 18:57 AEDT):**
- `security.course_entry_shared_page_v1` replaced in place under its live md5: `7b43d0c6…` to `077bf1637e515fc08e837f581767a1ac` (the md5 the database test and the rolled-back live dry run both predicted). One clause changed.
- New setting `entry.shared_page_hand_lock_holds` = 0: a hand lock on the page address no longer makes a refused (mismatch) binding of another course count as sharing the page. 1 restores the rule of 8 Nov.
- `entry.shared_page_own_bases` now ends with `manual`.
- Unchanged: `aer.machine_min_confidence` 0.8, `aer.machine_min_quote_chars` 8, every other AER v1 rule (Decision 276). One audit event. G3 75 functions and 48 relations.
- Effect: 25 of the 230 shared-page course reads are no longer held as a shared page (20 with only refused bindings on the page: 14 bound by hand, 4 by CRICOS code, 2 by exact title; and 5 whose recorded reason was already out of date). 19 of the 25 now pass the gate; 6 are still held for another gate reason (rows cut, dropped requirements).
- 205 stay held as shared pages: another course is bound or ambiguous on the page (qualification ladders, stream siblings, pace and duration twins). Twins stay held until an AER v2 read returns the variant with each row (Platform Admin 17:52).

**Found, not changed: AER course machine admission has been in shadow since 18 Nov 15:40 AEDT.**
- `security.aer_machine_run_v1` admits only while `aer.machine_mode` is 2 and a passed validation in `pipeline.aer_machine_validations` is no older than 7 days. The only passed validation is dated 11 Nov 2026 15:40 AEDT, so it lapsed at 15:40 today. `aer.machine_suspended` is 0.
- Every outcome the job has written since is a shadow record. 79 waiting course reads are recorded `would_admit` and are not being admitted; 7 of the 25 released reads are among them after the 18:54 run, and the rest are re-checked as the job works through its batches. The last machine admission of a course read was 15 Nov 2026 15:22 AEDT.
- Nothing was run to change this. Re-validating (`security.aer_machine_validate_v1`) turns live admission of AER v1 course reads back on, which is the Platform Admin's decision.

**Not done:**
- `docs/platform/TEST-REGISTER.md` is not regenerated for s670. The generator needs the frontend packages installed (`lucide-react`), and this session cannot install packages. The next session that runs `node scripts/test-register.mjs` in Pilot picks s670 up.
- The local Playwright run was not possible for the same reason; the full suite ran green in GitHub CI on the PR, with the 15 database scenarios (`aer-hand-bound-test.yml`) and the rolled-back live dry run.
- s671 (matrix parser and completeness) and s672 (offline model replay) are not started.

**Next executable action:**
- Platform Admin: decide whether to re-run the AER course machine validation so the 79 `would_admit` reads (and the released ones as they are re-checked) are admitted.
- s671: the 893 rows with no study level come from 22 sources whose rows are table lines with the level printed, where it is printed at all, in the page or file heading ("Undergraduate" for Lincoln, UTAS, Macquarie, Adelaide) and not in the row. Several college pages print one requirement for every course and name no level.
- s672 after s671, through the on-demand open and close route.

## 18 Nov 2026 19:20 AEDT — S2-BOOST-Discovery: 795 Course page needed items returned to the list (Pilot #1306); on-demand request closed; corrections to 17:55

Own follow-up of the 17:55 block (Platform Admin 16:54 and 17:02). One migration, `20261118233000` (md5 `a1c8157c`); spec s658. No table, column or job added.

- **Correction to the 17:55 block.** "834 searches held by the stop gate" counted every queued search of the 91 providers, including older ones the rule never sent. Of the items rule l4-page-needed-search-v1 itself had sent, 402 were gate-held at 18:50. The 17:55 block also said the pick fix ended the time-outs; 13 more followed while the on-demand request stayed open.
- **Finding: 709 courses had left the Layer 4 list with nothing working on them (18:50).** Of the 840 items the rule had sent: 307 searches finished and found no page, and nothing brought those items back; 402 were queued behind the stop gate; 90 had found a page; 41 were queued with the gate open.
- **Pilot #1306 (s658), live 19:16.** md5-guarded edit of `security.course_page_needed_search_rule_v1`:
  - The rule returns to the list every item it sent whose search found no page, ended in error, or is queued behind the stop gate. The decision record keeps why (`returned_because`). The search count is kept.
  - It no longer asks for a search the gate would hold, nor repeats one that found no page.
  - First run: 795 returned (349 found no page; university search stop 418; no page published by the provider 15; per-course stop 13), 229 new searches asked, 0 failed.
- **On-demand request `2fe02033` closed 19:16** through `security.on_demand_close_v1`. Actual: 2,190 Firecrawl credits (1,095 searches) against the estimate of 2,362. Credit left on the plan: 70,682.
- **What the searches gave.** 497 courses finished by 18:50: 112 found a page, 385 found none. One page is read and proved by CRICOS code. The rest wait: 38 need a rendered read (24 on `sws.ucol.ac.nz`), 37 could not be fetched, 30 unread, 6 blocked.
- **Read at 19:18 AEDT:** Course page needed 1,445 open (44 blocked or robots-disallowed, untouched), 572 with a search asked for (93 found a page, 479 queued with the gate open; they run inside the daily share from midnight). G3 75 functions and 48 relations. Live head `20261118233000` (2,139 applied).
- **Binder matcher (asked for as s651): no change made.** The pages the searches found show no query-string or trailing-slash mismatch. They fail on rendering, 404 and blocks, which a matcher rule does not fix.
- **Course link year preference (asked for as s650): not built, by finding.** Of the 158 old-handbook-year items:
  - Where the binder has read the current-year page (Melbourne 27, Flinders 1), it failed the identity check every time. Entering it by year alone would link an unproved page.
  - Where the binder holds only the old-year page (Macquarie 2014 and 2015 handbook 50, ANU 32, La Trobe 18), nothing has read a current-year address. The Macquarie handbook of those years no longer exists in that form.
  - These read as courses no longer in the current handbook. Whether to keep the archived page or retire the course is a person's decision.

**Not done:**
- A read of year-swapped addresses for ANU (32) and La Trobe (18) to test whether any current-year page proves the course.
- The test register row for s658 was added in the generator's format (the generator needs `@playwright/test`).

**Next executable action:**
- Platform Admin: lift or keep the university search stop for Adelaide University, Victoria University, Flinders, Monash and ICMS. 418 of their courses are back on the list and are not searched while it stands.
- After midnight AEDT, read how many of the 479 queued searches ran and how many found pages were read and proved.
- UCOL: 24 found pages on `sws.ucol.ac.nz` need a rendered read; check them after their next read (19 Nov 17:58 AEDT).

## S1-AER, 18 Nov 2026 20:50 AEDT: AER course machine admission re-validated (s673); matrix level from the table heading and completion-only rows (s671); AER v2 replay round 4, no model qualified (s672)

Platform Admin standing mandate 19:28. Pilot #1308 (migration `20261118237000`, md5 `c1ae9cae`) and #1310 (`20261118238000` md5 `070779e6`, `20261118239000` md5 `536a4204`); specs s671 to s673. Full write-up: `docs/platform/2026-11-18-s1-aer-revalidation-matrix-parser-replay.md`.

**Done and read back from live:**
- **S673 (step 1):**
  - Validation 6 of rule `aer-machine-v1` passed at 20:09:59 AEDT: 401 would-admit reads re-checked, 0 regressions. It ran inside a migration under the live md5, as on 11 Nov; there was no separate workflow.
  - Course machine admission is live again; the 20:24 run admitted 1 read.
  - The other about 90 `would_admit` reads are admitted as each 6-hour re-check comes round, by about 02:30 Thursday (fixed rule, not changed).
  - Thresholds 0.8 and 8 unchanged; variant twins held.
- **S671 (step 2):**
  - Matrix rows with no level read take the one level named in the stored heading or file title (codes bachelor, masters, doctorate, foundation; never when any row names a level).
  - "Year N equivalent" is not a level.
  - Completion requirements with no score are not missing minimums.
  - Effect: 127 rows take a level, 225 rows are completion-only; reads passing 0 to 2, both admitted at 20:24 (UTAS 29 rows, Deakin College 1 row).
  - 54 reads stay held by the D-R3 gate (dropped rows); they need a corrected read.
  - Matrix validation 12 passed. Switches `aer.matrix_level_inherit_on` and `aer.matrix_completion_only_on`. Functions replaced in place, G3 75/48.
- **S672 (step 3):**
  - Round 4 on frozen set 5 with the exact pinned IDs, through the new workflow `aer-v3-replay.yml` (run 44273806589, 20:13 to 20:37): on-demand `639066c5` opened and closed, switches back to 0.
  - Results: MiMo v2.6 Flash 14/50 right, integrity 60%, 26 pts, 2 FP; Mistral Small 3.2 11/50, 85.7%, 22 pts, 2 FP; Qwen3 30B 3/50, 100%, 54 pts, 27 time-outs.
  - **No model passes the unchanged gate:** Path B, nothing qualified or switched on.
  - US$0.125 spent; AER v3 total US$1.372 of US$2.

**Not done:**
- No held AER course read was re-read. No model is qualified.

**Next executable action:**
- Platform Admin, AER v2: (a) revise prompt v3 for missed rows, then round 5 with `aer-v3-replay.yml` (recommended); (b) longer evaluation time-out (a fixed code value); or (c) pause replays.
- Platform Admin: how the 7-day validations are renewed. They lapse on 25 Nov at 20:10 (course reads) and 20:12 (matrices).
- S1-AER, about 02:45 Thursday: read back that the 90 `would_admit` reads were admitted.

## 18 Nov 2026 AEDT — S3-Boost providers: full CRICOS provider reconciliation (s700)

Platform Admin directed one report-only reconciliation against the 2 November CRICOS Institutions export and a deterministic `https://` normaliser for bare CRICOS provider websites. Use the GitHub Actions Management API read-only route with `p_write: false`, a US$0.00 LLM and Firecrawl budget, and zero migrations. Keep G3 at 75 functions and 48 tables. Evidence and exception lists belong in the Admin report and the summary goes to Admin #574. The Pilot implementation is scoped to the S3 lane.

1,543 source codes, 1,541 exact matches (1,539 active), 2 same-provider alias candidates, 21 domain differences, 106 blank catalogue URLs and 709 source URLs normalised. Zero production rows written and US$0.00 LLM spend. [Reconciliation report](https://github.com/msinghbs-ai/coursefinder-admin/blob/main/docs/platform/nz-enrichment-brief/2026-11-18-s3-boost-cricos-provider-reconciliation.md) includes the complete domain and alias lists. Engineer-review projection is 144.01 hours or 18.95 FTE days saved across the CRICOS edition. Pilot #1312 merged at `d7782d7b`. The exact rebased candidate `fe347485` passed 3,552 tests with zero failures and zero skips, including all four s700 tests, and passed production parity. [Governing CI](https://github.com/msinghbs-ai/Coursefinder-Pilot/actions/runs/44285129957) · [Edge deployment](https://github.com/msinghbs-ai/Coursefinder-Pilot/actions/runs/44287604764).

## S2-Courses, 18 Nov 2026 23:00 AEDT: study load cue guard (s661) and fee-basis replay (s665) live; s662 and s664 are in Pilot #1314 (S1-Courses)

**Request:** Platform Admin 18 Nov 2026 21:59 (four items). Full findings: `docs/platform/S2-COURSES-STUDY-LOAD-GUARD-AND-FEE-BASIS-REPLAY-2026-11-18.md`.

**Done and read back:**
- **Pilot #1316 and #1319 merged on green and deployed** (worker `coverage-sweep` v1.0.22, specs s661 and s665, no migration; the deploy run for each merge commit succeeded).
- **Study load cue guard (s661).** A course closed to international students ("not available to international students") is never read as a load rule and nothing is inferred from it (the Griffith full-time reading); an international word that names the student and a study word must lie within 80 characters, or a labelled "International ..." line must have its study word within 160. A CRICOS code and course titles no longer count as international words. Selectors `study-load-windows-v5` and `study-load-international-v2`; prompt `boost-study-load-v5` and the route are unchanged.
- **Live inspection** (read only, no model, 62 readings): matched the cue on 41 pages before, 24 after proximity and closure, 18 after the word rule; about 8 of the 18 are real statements. **Not promoted, no page released for re-reading, no study load admitted.** A block that holds both a Domestic and an International line still makes the page check ask for the load of the whole block; the next change splits blocks at their labels.
- **Fee-basis replay (s665), run 44297706134** (225 stored pages, US$0.0458, nothing staged or admitted): annual fees 6 of 6 agree, whole-course totals 3 of 7, intakes 10 of 18 (9 exact), 3 of the 8 intake disagreements list every held month and more; fees 15 verified of 224, descriptions 119 of 172 pass the page check. **Qwen3 30B is not qualified for any of these fields.**
- **s662 and s664 are not built in this chat.** Pilot #1314 (chat S1-Courses, same spec block) already carries them: reader v4, identity-proof exemption, Layer 4 explanations and the four decisions. It was reviewed against the directive and left untouched. Its migration `20261118253000` is below the live head `20261118256000`, so it must be renumbered before it merges.
- G3 75 functions and 48 relations, no drift (read 22:52). Live head `20261118256000` (2,144 applied).

**For S2-Intakes (priority):** is the intake we hold the next intake the page announces or the main annual start? The replay cannot score intakes until this is defined.

**Not done:** the label-splitting cue and any re-read release (needs a migration); intake, fee and description qualification (no route qualification row, no deadline field, intake undefined).
