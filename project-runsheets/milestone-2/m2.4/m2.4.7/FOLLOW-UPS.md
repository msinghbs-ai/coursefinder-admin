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

## S1-AER, 18 Nov 2026 23:35 AEDT: prompt v3.1 and 180 s evaluation calls (s674), round 5 not qualified; standing 7-day validation renewal; five AER consumer data findings resolved without quarantine (s675)

Platform Admin 20:53 and 22:26 (alert batch `88e5ff5b-3fb9-4613-80db-3ff0c96a6b06`). Pilot #1311, #1313, #1317, #1320 (s674) and #1321 (s675). Migrations:
- `20261118243000` (md5 `28ef812f`)
- `20261118270000` (md5 `85f5e02a`)

Worker `coverage-sweep` v1.0.19. Full write-up: `docs/platform/2026-11-18-s1-aer-round5-renewal-consumer-findings.md`.

**Done and read back from live:**
- **s674, prompt `aer-v2-course-v3.1`.** v3 plus one section asking for every requirement row of a table or list. It runs on the three exact pinned models with no fallback.
- **s674, 180 s evaluation calls (was 90 s).** The 150 s request idle time-out and `EarlyDrop` of background tasks forced a streamed answer. The replay workflow calls the worker straight with a one-time nonce, records each answer as it comes and starts at most 8 examples a call.
- **Round 5 (runs 45 to 47).** The gate is unchanged and **no model passes**:

  | Model | Right of 50 | Quotes on page | Error points | False positives | Time-outs |
  |---|---|---|---|---|---|
  | Mistral Small 3.2 | 13 | 85.7% | 8 | 2 | 2 |
  | MiMo v2.6 Flash | 14 | 54.6% | 12 | 4 | 6 |
  | Qwen3 30B | 7 | 25% | 22 | 3 | 11 (27 in round 4) |

  Nothing was qualified or switched on. Switches are back to 0 and on-demand `6c37d8fc` is closed. AER v3 spend is US$1.529 of US$2.
- **Standing rule (Platform Admin 20:53).** The two AER automatic admission validations renew automatically every 7 days, without sign-off, when nothing has changed:
  - Workflow `aer-validation-renew.yml` runs daily at 18:17 AEDT and renews once the last pass is `aer.validation_renew_after_days` (5) old.
  - It renews only on 0.8/8 (course reads) and 0.9/8 (provider tables), the validators checked on 18 Nov, mode 2, not suspended, and 0 regressions.
  - Anything else fails the run and is reported; nothing is forced on.
  - Next renewal about 23 Nov. The runbook item 3a in `docs/platform/2026-11-12-aer-admission-mechanism.md` has the rule.
- **s675, the five critical consumer data findings.**
  - The findings are 149 provider-table rows at five providers: AUT 56, Whitireia and WelTec 44, Massey 36, Flinders 12, Otago 1.
  - People approved these rows on 30 Oct. On 11 Nov 19:15 the qualification-first re-record recorded the same runs again and re-pointed them to new change items, so the check read approved rows as "not admitted".
  - Not quarantined: that would have withdrawn person-approved data from the consumer API. Instead:
    - the check now accepts an approval that names the row's run;
    - a run a person approved is never recorded again.
  - The 23:27 `aer-reconcile` resolved findings 1516 to 1520: 0 P0 open and Platform health `aer:p0` resolved at 23:27:00 AEDT.
- G3 75 functions and 48 relations. AER v1 thresholds unchanged. Both migrations were applied before Thursday's 01:15 freeze.

**Not done:**
- No AER v2 model is qualified, so the about 1,620 incomplete course reads stay held.
- The five `entry_matrix_change` items, which hold the 11 Nov qualification rows, wait in Layer 4 for a person.

**Next executable action:**
- S1-AER, Thursday 02:45 AEDT (scheduled): read-only `aer-validation-renew.yml` status since 20:09:59. Confirm the 90 would-admit course reads were admitted after their 6-hour re-check.
- Platform Admin: how AER v2 qualification proceeds after round 5. Mistral now meets the error-point limit but not quote fidelity or false positives. The every-row section did not raise recall. US$0.47 of the evaluation cap is left.

## S1-AER, 18 Nov 2026 23:55 AEDT: decisions recorded (149 approved rows stay live; paid AER v2 replay paused)

Platform Admin 23:52. No code or migration.
- **The 149 person-approved provider-table rows stay live** in the consumer API: AUT 56, Whitireia and WelTec 44, Massey 36, Flinders 12, Otago 1. The five 11 Nov `entry_matrix_change` items stay in Layer 4 for a person (s675).
- **Paid AER v2 replay rounds are paused.**
  - There is no round 6 on Qwen3 30B, Mistral Small 3.2 or MiMo v2.6 Flash, and the US$0.47 left of the US$2 evaluation cap is kept.
  - AER v2 stays off (shadow only, `aer.v2_shadow_on` 0, gate unchanged). AER v1 deterministic admission handles live admission: course reads and provider tables, s670, s671, s673.
  - **Replay resumes only when** dense multi-row entry tables are chunked per qualification, or a stronger frontier model is explicitly authorised.
  - Recorded in Decision 276 and the AER runbook, item 3b.

**Next executable action:**
- S1-AER, Thursday 02:45 AEDT (scheduled): read-only check that the about 90 would-admit course reads were admitted after their 6-hour re-check.

**S1-AER, 19 Nov 2026 03:15 AEDT: Thursday 02:45 check — the about 90 would-admit course reads were NOT admitted (the machine's job starves them)**

Read only; no migration and no data change (Thursday freeze respected; zero schema migrations in this lane). Pilot #1326 (s676, script only: the `status` mode of `aer-validation-renew.yml` now also reports why would-admit reads wait).
- **Result (status run 44339423118 at 02:46, detail run 44343797388 at 03:05):**
  - Since the 20:09:59 re-validation: **2 course reads admitted (3 rows)** and 2 provider tables admitted. **89 course reads are still recorded would-admit and waiting**; 2,576 course reads wait in Layer 4.
  - The validations are fresh (course and matrix passed 18 Nov 20:10, age 0.3 days); admission mode 2, not suspended, daily cap 5,000, 2 used.
  - All 89 still pass the rule when re-checked now (rolled-back probe run 44344041791): 79 on `aer-machine-v1`, 10 on Approve except.
- **Cause (by finding):** job `aer-machine-admission` (every 30 minutes, succeeding) re-checks the same items every run and never reaches the 89.
  - Every one of the 2,576 waiting items is eligible on every run. In admit mode a declined or audit-sample result does not refresh the item's last-checked time (only shadow mode does), so the 6-hour re-check gap never applies to them.
  - The run takes items gate-complete first, then oldest first, and stops at its 45-second limit. The first 60 in that order are 45 audit samples and 15 declined (no bound page 7, identity not admitted 8, row unsupported 1). The 89 sit at positions 443 to 2,542.
  - No shadow rows were written after 20:09; the 89 were last checked 16:54 to 19:54 AEDT.
- **Not changed:** no setting, function or row. Raising `batch.aer_machine` does not help (the 45-second limit stops the run first).

**Decision needed (Platform Admin):** authorise one function fix, S677, outside this lane's zero-migration rule:
- `security.aer_machine_admit_v1`: in admit mode, a declined or audit-sample result also refreshes the item's last-checked time (`create or replace`, md5-guarded, no table change, G3 unchanged), so each item waits 6 hours before its next check and the queue moves.
- Until then a person can approve the 89 in Layer 4 › Inbox (kind Course entry first read).

**Next executable action:**
- Platform Admin: authorise S677 (or approve the 89 by hand).
- S1-AER after authorisation: S677 migration with a rolled-back live dry run, then a status read 30 minutes after merge.
- Delete branch `cf247-s676-probe` in the GitHub UI (a never-merged probe carrier; this session cannot delete branches).
- Unchanged: the five 11 Nov `entry_matrix_change` items in Layer 4; first automatic renewal about 23 Nov.

## 19 Nov 2026 05:25 AEDT — S2 - BOOST: run-4 PASS after the squash; benchmark bench-5 (Pilot #1327)

Post-squash follow-up of the Platform Admin's 18 Nov 10:10 directive.

- **Run-4 on `coursefinder-boost-test`: PASS, 9 of 9 checks** (admin run 44349340646, after S1-Build's "can re-seed" of 02:25):
  - 60 admitted for 60 courses at 1,000 and 5,000 rows; 5,922 duplicates refused; shadow admitted none; held courses unchanged.
  - The promotion function is byte-identical to production (md5 `fa4e3a86`), and test-project G3 is 75/48.
  - The read-only production probe could not execute two security functions; production G3 was read separately at 03:52 (75/48).
- **Bench-5** (migration `20261119044000`, s699; measures only). On 63 leftover pages with signal (AU 200 and NZ 1 pages per model):
  - Verified rates: Mistral Small 3.2 59%, MiMo v2.6 Flash 44%, Qwen3 30B 32%.
  - Cost per verified field: US$0.00012, US$0.00030 and US$0.00031.
  - Qwen3's refusals are mostly duration lines quoted as the study load (24 of 31).
  - Bench-4 rates for comparison: 81%, 66% and 76%.
- Qwen3 30B stays the only qualified model; nothing was switched.

**S1-AER, 19 Nov 2026 05:30 AEDT: morning read-back — would-admit course reads still NOT admitted; 0 P0 findings; replay pause confirmed**

Read only; no migration, no data change (zero schema migrations in this lane). Live reads: `aer-validation-renew.yml` status run 44369257782 (05:24) and a rolled-back probe (run 44370612954 on the carrier branch).
- **Course-read sweep (`s670`/`s673`): not complete.** Since 20:09:59 on 18 Nov, 2 course reads (3 rows) and 2 provider tables admitted. **89 course reads are still would-admit and waiting**; 2,576 wait in Layer 4. The post-6-hour sweep did not reach them: the machine job (every 30 minutes, succeeding) re-checks the same first items each run (cause and fix S677 in the 03:15 block, awaiting Platform Admin authorisation). The 89 were last checked 16:54 to 19:54 AEDT on 18 Nov; no shadow rows since.
- **P0 consumer-data findings: 0 open** (`pipeline.aer_gap_findings`, severity P0, state open or reopened). The 149 person-approved provider-table rows stay live; 6 `entry_matrix_change` items are pending in Layer 4 (the five from 11 Nov plus one to identify; none touched).
- **Paid replay pause recorded in all three places:** CURRENT-STATE (23:55 block), the AER runbook (`docs/platform/2026-11-12-aer-admission-mechanism.md`, item 3b) and Decision 276 (`docs/coursefinder-design-reference-v1.4.md`, 23:52 decision): no round 6 until dense entry tables are chunked per qualification or a stronger frontier model is authorised; US$0.47 of the US$2.00 cap kept; AER v2 stays at 0 (shadow only).

**Next executable action:**
- Platform Admin: authorise S677 (one function, `security.aer_machine_admit_v1`: admit-mode declined and audit-sample results refresh the last-checked time), or approve the 89 in Layer 4 › Inbox.
- S1-AER after authorisation: S677 with a rolled-back live dry run, then a status read 30 minutes after merge.
- Open for a person: the Layer 4 change items; branch `cf247-s676-probe` still exists (never merged; delete in the GitHub UI).

## 19 Nov 2026 07:15 AEDT — S2-BOOST-Discovery: request closed, s658 holding, search pick still times out under load (141, measured), no matcher or year rule built

Own check-in on the 16:54 and 17:02 directives. It adds to the 19:20 entry and corrects two lines of it (marked). No Pilot change, no migration, no data write.

Read live from 06:55 AEDT (project `fxcwkweaxjtknorudmwp`, read-only SQL). Live head `20261119053000` (2,156 applied). G3 75 functions and 48 relations.

- **On-demand request `2fe02033` was closed 18 Nov 19:16 AEDT** (08:16 UTC) through `security.on_demand_close_v1`; it did not need closing again. Window use: 1,092 `link_search` calls, 2,184 credits (recorded 2,190). After the close the scheduled share ran from 00:00 AEDT: 400 calls, 800 credits, which is the whole daily share for course search. Credit left on the plan at the close: 70,682.
- **Pilot s658 (#1306) is live and holding.** The live rule carries the gate filter and the return to the list. Of the 563 items waiting on a search, none has its search behind a gate (489 have a search queued, all with the gate open).
- **Searches finished since the request opened (06:15 UTC 18 Nov): 922 courses.** 99 found a page (6 by CRICOS code, 93 by title; 1 of them verified); 823 found none. Course page needed now: open 1,492, search asked for 563, page added 6, no page exists 236.
- **The 99 found pages: 1 is read and proved** (CRICOS code). The other 98 are: need a rendered read 40 (24 on `sws.ucol.ac.nz`, next read 19 Nov 17:58 AEDT), could not be fetched 29 (404) and 12 (200 but not read), unread 11 (see below), robots-disallowed 4, blocked 1, a 400 response 1.
- **Queued searches by stop gate (4,049):** open 2,108 (405 providers), no page published by the provider 1,263 (29 providers), university search stop 637 (21 providers), per-course stop 31, remediation hold 10. The university stop now holds: Adelaide University 172, Swinburne 159, Victoria University 92, Flinders 45, Monash 38, Melbourne 31, ICMS 25, NorthTec 14, UCOL 13, Torrens 12 (**correction to the 19:20 list: Swinburne and Melbourne are in it too**).
- **Finding: the search pick still times out under real load.** 141 `svc_course_link_search_next` time-outs since 06:49 UTC: 18 between 06:49 and 09:00 UTC (the window was open until 08:16), 123 from 00:00 AEDT when the daily share opened (59 of 59 runs in the first hour), none after the share was spent at 02:12 AEDT. Cost measured read-only over the 4,049 queued rows: the stop gate 43 s (12 s with the provider flag the pick supplies), the site-list match 8 s, the provider-level checks 6.1 s for 171 providers; the worker's call limit is 8 s. The work was not lost: the full share of 800 credits was used. **Corrects the 19:20 block** (13 time-outs while open, 2 after close): that count was low. Not fixed: under the current share it would add no searches; the fix is a function change (evaluate the gate and site-list check lazily in pick order, with a stop time taken from the role's statement time-out), to be done with an on-demand window that needs it.
- **Binder matcher (s651 as asked, s659 reserved): no change.** Of the 98 unproved found pages, 53 have the same address in the search and the binder, 0 differ only by a query string or a trailing slash, 3 differ in whether a query string is present, and 42 are not the address the binder holds. In the 12 sampled, those 42 are wrong-page results (a student story, a news article, a library or repository page) the binder did not take. The wrong-class hosts and paths are not a rule: 55 of 66 older found or verified pages on such hosts were verified. Failures are rendering, 404 and blocks.
- **Finding: 11 found pages are unread with their lease expired.** UVic 8, Seafood Training Services 2, PBRS 1: three read attempts, lease ended 18 Nov 18:11 AEDT, no read status. Not touched (reader lane).
- **Course link year preference (s650 as asked): not built, by finding. Corrects the 19:20 block.** Layer 4 Course link: 270 waiting; the check holds 254 and would refuse 16 (audit sample), and would use or enter none. Waiting by university: Macquarie 52, SFU 47, ANU 34, Melbourne 27, Sydney 22, La Trobe 21. For ANU and La Trobe the proposed page is the binder's own old-year page (2016 to 2024 handbook address), read and proved by CRICOS code (ANU 34 of 34, La Trobe 20 of 21, the other by exact title). Melbourne's 27 are 2026 pages that failed the identity check.
  - The 19:20 line "these read as courses no longer in the current handbook" is not supported: the binder already holds 16 ANU and 16 La Trobe pages with a 2026 address, all proved by an accepted identity basis, none a 404. No 2026 address has been tried for the 55 waiting (0 rejections).
  - The rule already prefers the current year: `use` needs the page year at or above the Melbourne year, `enter` needs a binder page that is read, proved and of the current year (`security.course_relink_year_url_v1` makes the swapped address).
  - Why it is not a rule now: `security.course_page_rebind_v1` overwrites the binder row, clearing the proof and the stored page reading, before the new address is read. Offering 55 unproved addresses that way risks the proved old pages. Keeping the old row beside needs a new table (not in this lane). A live read of two swapped addresses was not possible from this session (the fetch needed approval and nobody answered).

**Not done:**
- Year-swapped read for ANU (34) and La Trobe (21), about 55 Firecrawl credits.
- The search pick fix above.
- 489 searches for waiting items are still queued with the gate open; the daily share allows about 400 searches a day.

**Next executable action:**
- Platform Admin: lift or keep the university search stop for the 21 providers above (637 queued searches); decide whether the year-swap read for ANU and La Trobe may be run as a probe that keeps the old row (needs a table: a lane with migrations).
- S2-BOOST-Discovery next: after 17:58 AEDT read the UCOL rendered reads; with the next on-demand window, build the pick fix.
## 19 Nov 2026 07:15 AEDT — S2-BOOST-Providers handover: provider description prompt recorded, held re-reads restored to Layer 4, final counts (Pilot #1345)

Platform Admin 06:49. One migration, `20261119080000` (md5 `ab4845cc`), data only; specs s760 and s761. No table, column, function or job added. G3 75/48, no drift (read 07:07). Live head `20261119080000` (2,158 applied).

**Handover numbers (read live 07:07):**

| Measure | Count |
|---|---|
| Published, active providers | 2,830 |
| With a description | 2,171 |
| Without a description | 659 |
| University descriptions waiting for a person in Layer 4 | 61 |
| Scholarship records | 2,832 |
| Scholarships published | 1,066 |
| Held scholarship pages | 82 |
| Campus localities waiting | 78 |

- **Prompt record (s760).** The live prompt is version 5. Version 4 had been saved from the admin screen and version 5 built in SQL, so neither text was in a file. Both are now byte-for-byte fixtures in Pilot `tests/fixtures/pdesc/` with the live checksums; the migration refuses to apply if either live row differs.
- **Re-read finished.** All 81 descriptions sent back on 18 Nov were read again from stored pages (US$0.0206, no Firecrawl): 12 admitted, 6 proposed in Layer 4, 63 held by the reader's own checks (a quote not on the page 26, a sentence its quote does not support 24, others 13).
- **Restore (s761).** For 54 of the 63, the provider still has no description, so the earlier reading is pending in Layer 4 again with its reading proposed, and a person can approve it. The other 9 already hold a register-fact description. The migration admitted nothing.
- **Why 659 providers have no description** (latest read of each):
  - 238 have never been read.
  - 196 are held by the page identity proof: the page title or h1 is not the provider's name alone (for example "About Us | Sydney Art School (SAS)", "Scotch College Melbourne", "About Us - Princeton International College" for Princeton Education Group Pty Ltd).
  - 56 share their host with another active provider; 21 have a campus, faculty or school heading.
  - 105 are held by grounding (quote not on the page 63, unsupported sentence 34, unsupported number 8).
  - 7 are proposed in Layer 4; the rest are sentence count, wrong page and wording.
- **Held scholarships (82, unchanged).** No rule was changed. Of the 15 clear re-check recommendations, 7 were settled on 18 Nov. The other 8 stay held: in 5 the two readings disagree about who may apply, 1 is a staging address, 1 audience sentence does not say "international", and 1 (Bond) is a second page of a scholarship already admitted. The rest are audience not stated 57, value unclear 3, not settled 3, no stored copy 11.
  - The two scholarships admitted on 18 Nov are still unpublished: Ronald Lu Travel Award closed on 22 Jun 2026, and the Otago Polytechnic record has no award value.

**Not done:**
- Signing in to PIM Admin in a browser: the UAT email and password are GitHub Actions secrets, which cannot be read back, so the screens were not checked by eye. The counts above are from the live database. The Deployed UAT run on this merge was cancelled by a later merge.
- No batch drain was started and no follow-up check was scheduled: the reader has no queued description reads, and every remaining provider is held by a rule, not by a queue.
- The page identity proof and the grounding check are in the worker (`coverage-sweep/description.ts`); neither was changed.
- The test register rows for s760 and s761 were added in the generator's format.

**Next executable action:**
- Platform Admin: decide the provider description model route (Qwen3 30B gave 8 usable readings of 39 with prompt version 5; GPT-4.1 mini gave 158 of 392 with version 4). It governs the 105 grounding holds.
- Provider description owner: a worker release that accepts a title segment made of the provider's name plus its own initials in brackets or a registration number, then a re-read of the 196 identity holds.
- A person: the 61 university descriptions in Layer 4.

## 19 Nov 2026 08:35 AEDT — S2-BOOST-Courses: description reader live (Pilot #1344), 650 held descriptions queued for re-read, live counts read in PIM Admin (s728)

**Trigger:** Platform Admin 19 Nov 2026 06:49 AEDT, chat S2-BOOST-Courses (reserved s666–s669 and s720–s739): standing 1-day handover mandate and five items. Full record: `docs/platform/S2-BOOST-COURSES-HANDOVER-2026-11-19.md`.

**Done:**
- Item 1. Pilot #1344 (the #1335 change rebased onto main; worker `coverage-sweep` v1.0.25, release v2.16.50, migration `20261119084000`, specs s662 and s664) merged on green CI after a rolled-back live dry run passed and the md5 of all seven guarded function bodies matched live. Live head is `20261119084000`; `security.cdesc_prompt_version_v1()` returns `cdesc-source-grounded-v4`. #1335 and #1336 closed as superseded (#1336's splitter is #1337, s721). G3 75/48 held (CREATE OR REPLACE and settings only).
- Drain of the 666 held course descriptions (zero Firecrawl): the changed policy stamp made the machine rule look at every decline again at 07:44 (668 rows: 5 admitted, 254 too many sentences, 39 too long, 202 identity margin, 142 binding ambiguous, 15 evidence moved, 13 wrong page kind). By 08:29, 44 readings had been admitted by the machine rule, 650 were superseded for a 1-2 sentence re-read, and 15 stay in review (evidence moved). Courses holding a description: 14,433 (07:42) to 14,477 (08:29) of 44,733 (36,031 active). No overwrite: a course with a description is never written.
- Item 2 and the study-load release: label splitter is #1337 (s721, worker v1.0.24) and the release of 820 items is #1347 (s722, merged 07:37 AEDT), both from the S1-Courses lane; nothing duplicated here. Courses with a study load: 5,689 of 36,031 active (08:21); Layer 4 Boost study load 179.
- Item 4. s727 is #1341 (merged, migration `20261119062000`): 3 postcodes (9 campuses) settled; Layer 4 Campus locality 69 campuses wait for a person (suburbs outside the area's name, a campus under the wrong postcode, 50/50 postcodes). Nothing was guessed.
- Item 5, live check. GitHub Actions secrets are write-only (they cannot be read back), so the UAT login was used where it already lives: the deployed-uat workflow signs in with `COURSEFINDER_UAT_EMAIL` and `COURSEFINDER_UAT_PASSWORD` and prints neither. New read-only deployed spec s728 (Pilot #1356, #1357; selected by `.github/s2-boost-live-counts-candidate`) opened Coverage (Courses, Attributes) and Layer 4 Inbox as the UAT user on the live site (Actions run 44400209609, release pill v2.16.50): Coverage snapshot built 08:12; Attributes tiles 24,066, 10,797, 13,456 and 20,834 of 36,031 admitted (Intakes 13,456, Provider tuition 10,797); Layer 4 Inbox: Boost study load 179, Campus locality 69, University description 76, Fee fails the check 10, Held scholarship 82, Entry requirements (AER) 2,655.
- Self-check scheduled for about 10:14 AEDT (reads the drain, final admitted field totals and G3).

**Not done:**
- The 650 superseded descriptions are not yet re-read: job `field-gap-queue` (hourly at :23) failed at 08:23 with a statement timeout (it averages 80 s against a 120 s limit; one earlier failure, 19 Nov 05:23 AEDT). The next run is 09:23. Not changed here.
- Items 3 (s723 intakes, s724/s725 fee gold replay and tier enablement, s726 deadlines) are Pilot #1346 (S1-Courses lane), open and conflicting with main (worker v1.0.25 and migration `20261119061500` are taken); a comment says what to renumber. No field other than study load is qualified for live admission; no fee tier was enabled (no tier has met 95% with zero false positives).
- A Claude-browser login with retrieved credentials was not possible (see above); s728 is the governed substitute.

**Next executable action:**
- Pilot owner of #1346: rebase to worker v1.0.26, a migration above `20261119084000` and the next release number.
- Self-check at about 10:14 AEDT: confirm the 650 re-reads ran after 09:23 and report the admitted description total.


## 19 Nov 2026 08:45 AEDT — S2-BOOST-Providers: identity proof rule, GPT-4.1 mini route and bounded re-read launched, source words, Layer 4 triage (Pilot #1353, #1355)

Platform Admin 07:39 and 08:17. Worker change #1353 (s762, no migration) and one data-only migration `20261119090000` (md5 `f6c0971b`, #1355; s763, s764, s765). No table, column, function or job added. G3 75/48, no drift (read 08:40). Manual locks 7,585, unchanged.

- **Identity proof (s762, worker).** A title or h1 segment that holds the provider's whole catalogue name plus its own initials in brackets, or an RTO, CRICOS or TEQSA registration number, now proves the provider on its own host. The registration code's form is checked, not its value: the worker is not given the register's numbers. A place or sub-brand after the name, another institution, a campus, faculty or school, a shared host and a foreign bracket stay held. The worker version string was not bumped.
- **Route (s763).** GPT-4.1 mini is allowed again, qualified for `provider_description` only (the Platform Admin's decision is the evidence; provisional until a regression qualification), and is the service's one model with prompt version 5. The service's daily cap is US$0.50 (was US$1). No other service lists it. `pdesc.acquire_firecrawl` is 0.
- **Re-read launched 08:36 (s764).** 267 reads queued: 196 held by the identity proof, 58 held by grounding, 13 never read with a stored page. At 08:40, 23 were done and all held (identity 8, machine identity rules 12, not stated 2, shared host 1); 244 were queued. Spend so far US$0.0007. At 10 reads every 5 minutes it finishes about 10:45.
  - Not in the re-read: the 54 readings restored to Layer 4 (they keep their open reading), and 225 never-read providers that have no stored page.
- **Source words (s765, F-PDESC.01/.02).** There is no allow list. The one list is `pdesc.refused_path_words`, and dates, calendar and timetable have been in it since 9 Nov: a page address with one of them is never a description source. The migration puts a missing word back and fails if any of the three is not refused; nothing was removed.
- **Layer 4 triage (F-PDESC.03).** All 61 pending university descriptions have been checked by the machine rule and declined, so none is machine-eligible as it stands.

| Group | Items | What a person does |
|---|---|---|
| The provider is not named at the start (29) | 17 as read, 12 after refused sentences are left out | Approve only after adding nothing: reject, or wait for the re-read |
| Fewer than two sentences remain once refused sentences are left out (18), or too short (2) | 20 | Reject, or wait for a new reading |
| A refused topic (fees, visas, rankings and the like) | 11 | Reject |
| Every sentence refused | 1 | Reject |

  - 54 of the 61 are the readings restored at 07:07; 7 arrived on their own.
- **Held scholarships (82).** Unchanged, as confirmed: the 5 pages whose readings disagree, the staging address and the second Bond page stay held. No rule or spec was added for this (s683 already guards it).

**Not done:**
- Final re-read counts: the batch is running.
- The test register rows for s762 to s765 were added in the generator's format.

**Next executable action:**
- S2-BOOST-Providers, about 11:15 AEDT: read the final re-read results (admitted, proposed, held by rule, spend), then record them here and in the registers.
- Platform Admin: `pdesc.acquire_firecrawl` stays 0 and the service cap stays US$0.50 a day until changed on Settings.

## 19 Nov 2026 08:50 AEDT — S2-BOOST-AER: matrix completion clauses and course links (s741); held-page export (s742); course machine queue (s748, s749); table row chunker (s744 to s746); s747 not yet run (Pilot #1338, #1358, #1360)

Platform Admin 1-day handover, 19 Nov 2026 06:49 (spec block s740 to s759). Migrations `20261119052500` (s741), `20261119080500` (s748) and `20261119095500` (s749), each md5-guarded `create or replace` in place: no new table or function, G3 75/48 read back after each. Pilot #1338, #1339, #1340, #1349, #1350, #1358, #1360.

**Done and read back from live (05:50 to 08:46 AEDT):**
- **S740 (checks).**
  - The course machine validation passed at 20:10 on 18 Nov and lapses 25 Nov 20:10. `aer-validation-renew.yml` is active, daily at 18:17 AEDT.
  - P0 findings open: 0. The 149 approved AER rows stay live.
- **S741, matrix completion clauses and course links (#1338).**
  - `aer_matrix_machine_exclusions_v1`, `_check_v1` and `_admit_v1` edited in place:
    - a matrix row that names one of the provider's courses is linked to it;
    - the check adds `course_linked`;
    - admission writes `course_id` only where none is set.
  - The matrix validation was re-run and passed. 2 matrix items admitted live.
  - The other waiting matrix items (57) are stopped by the D-R3 completeness gate. The reader dropped printed rows, so only a new read fixes them.
  - The 294 rows with no level have no printed level on the page, and no provider is single-level, so no further inheritance applies.
- **S742, held-page export (#1339, #1340, #1350).**
  - Read-only workflow `aer-entry-inspect.yml` (worker mode `entry_inspect`) exported the stored pages of the held matrices.
  - The pages are kept as 48 test fixtures with their sha256 (Pilot `tests/fixtures/aer-chunks/held/`).
  - No reading, data or switch changed.
- **S748, course machine queue (#1349, migration `20261119080500`).**
  - Cause: a read the machine checked and did not admit (audit sample or declined) never had its shadow row refreshed. It therefore stayed at the front of the queue, and the run spent its time limit on the same items. The 89 would-admit reads behind them were never reached (S1-AER 03:15 finding, its S677).
  - Fix: `aer_machine_admit_v1` now records the check time on every non-admitted outcome, with the same upsert the shadow mode uses.
  - md5 `7473f475` → `89a5c44b`. Course validator unchanged (`945077fe`).
  - Live from about 07:50: the 07:54 run reached 114 items and the 08:24 run 80 more (75 audit samples, 5 declined); 190 shadow rows refreshed by 08:27.
  - No course read admitted yet at 08:27, because the gate-complete group checked first is mostly audit samples (about 970).
- **S749, fair order (#1360, migration `20261119095500`).**
  - Within the same groups (gate-complete first, then never checked), the least recently checked item now comes first, then the oldest by creation.
  - Without this, an item that became eligible again after the 6-hour gap went back in front of items not yet reached.
  - `aer_machine_run_v1` md5 `da1f53c6` → `fc9261cb`, read back live at 08:44.
  - Not changed: eligibility, batch (200), the 45-second limit, daily cap, 6-hour gap, rule, thresholds (0.8 and 8), validators, the 5% audit sample.
- **S744 to S746, table row chunker (AER v2 record source; #1358, worker module only, nothing deployed or switched on).**
  - `coverage-sweep/entry-chunks.ts` splits a page into one chunk per printed table row, list line or text block, each with:
    - the nearest three headings;
    - the table header;
    - the cells with their headings;
    - the country and the qualification.
  - A header is recognised only as a header line followed by its first row, so a repeated header stays in its table and a different header starts the next one.
  - A national qualification normaliser (`national-qualifications.json`) maps overseas qualification names.
  - Regression on the 48 held pages: on 36 pages the D-R3 gate stopped, every printed row with two or more cells is a chunk quote; none is missing or doubled; every quote is a line of the page text; the output is the same on every run.
    - 1,715 row chunks (the stored readings hold 1,727 rows and lost 238).
  - 70 of 70 local specs pass (s744 7, s745 50, s746 4, plus the source contracts). The 21 gate pages without table markup (PDF or text only) are not covered.
- **UAT login with the saved GitHub credentials.** Deployed UAT acceptance on the #1358 branch (run 44398577335, 08:10 to 08:30) signed in as the UAT user through the repository secrets: 52 passed, 16 failed and 4 flaky.
  - Most failures are live statement time-outs: 156 in 21:05 to 21:35 UTC, while another session's browser made about 2,000 `admin_read` calls, giving 500s on `admin_read`, `admin_toolsets_read` and `admin_aer_discovery`.
  - The rest: a tablet filter layout check (a13), a missing regional-manager assignment on UQ (a15), and a strict-mode locator on the Data quality pager.
  - None touches the chunker, which has no frontend change. Platform Health has no deployed spec; P0 read from the database: 0.

**Not done:**
- **S747, the 10-table chunked smoke test (≤ US$0.10).**
  - It needs a worker mode that reads from the chunks, a matrix prompt version stored as data, and an on-demand window.
  - Not run this cycle. No model call made; AER v3 spend unchanged at US$1.372 of US$2.
- Course admissions after S748 and S749 are not yet measured over a full cycle.
- `docs/platform/TEST-REGISTER.md` was not regenerated here: the generator needs the frontend packages, which this runner cannot install. It is regenerated by the next release bump or by CI.

**Next executable action:**
- S2-BOOST-AER, 10:24 AEDT (scheduled check): course reads admitted since 07:50, would-admit still waiting, shadow rows refreshed, matrix outcomes, P0.
- S2-BOOST-AER: S747 smoke test on 10 chunked tables, the pinned models only, ≤ US$0.10, promote only if row completeness and quote fidelity meet the bar.
- S1-AER: S677 is delivered by S748 and S749; do not build it again.

## 19 Nov 2026 08:55 AEDT — S2-BOOST-Discovery handover: decisions recorded; 11 unread pages released but 10 stopped again by the read worker's resource limit; discovery and course search picks answer inside the 8 s limit (Pilot #1354, #1361)

Platform Admin 07:39 (three handover decisions) and 08:18 (addendum IQ-00029). Two Pilot changes, no table, column, job or setting added: #1354 migration `20261119085000` (md5 `ed95b24d`, data only) and #1361 migration `20261119100000` (md5 `bcb8b92d`, two function replacements; specs s659 and s666). Live head `20261119100000` (2,169 applied). G3 75 functions and 48 relations (read after each apply).

**Decisions recorded (07:39):**
1. **University search stop kept active** for all 21 providers (637 queued searches at the 07:15 read), so the day's Firecrawl share goes to the 2,108 queued searches with the gate open. Nothing was changed.
2. **ANU (34) and La Trobe (21) year-swapped addresses (55 courses): held.** No candidate table was created and `security.course_page_rebind_v1` was not called; their proved pages and readings are untouched (the s659 release selects only found pages with no read result, no proof and no stored reading).
3. **The 11 found pages left unread (UVic 8, Seafood Training Services 2, PBRS 1) were released to the reader** with no search credit (#1354: next read now, attempts reset, lease cleared; recorded in `pipeline.admin_control_events` as `read_released`, search credits 0).

**What happened to the 11 pages:**
- The two read jobs (`coverage-read`, `coverage-read-2`) had been switched off at 07:50 by the idle check (its last 30 runs found nothing). The 10-minute recheck switched them on again at 08:10 because the release left work waiting; nobody changed them by hand.
- **1 page was read:** a UVic page, HTTP 200, identity mismatch (status mismatch), so not proved.
- **10 pages (UVic 7, Seafood 2, PBRS 1) are unread, with all three attempts used.** The read call that claimed them ended with `WORKER_RESOURCE_LIMIT` (HTTP 546, "not enough compute resources") at 08:10, 08:21 and 08:31, and wrote no result each time (attempts 3, read status empty, lease ended 08:42). The same ending fits the three claims left unrecorded at 18 Nov 18:11. They were not released again: another release would repeat the ending. The cause is in the worker's read call (up to 20 pages of one university in one call), not in the queue.

**IQ-00029 (08:18 addendum), fixed by #1361:**
- **Finding that changes the fix.** The HTTP 500s on `discover` (128 of 394 calls from 05:24 AEDT to the apply, 32%) are `svc_coverage_discovery_next` ("canceling statement due to statement timeout"): its focus check (`security.enrich_focus_v1`, 10.7 ms a provider) ran over the 1,177 due providers before the order and the limit, 7.8 s with nothing in focus. The stop gate belongs to the course search pick `svc_course_link_search_next`, which showed no failure only because the daily share was spent. Both picks are fixed.
- **Both picks now check lazily, in pick order, and stop at a 5 s budget counted from the start of the call** (inside the worker's 8 s limit; the only number, marked `-- fixed:`). Course search: the stop gate (9.7 ms a row), the site-list check (7.4 ms a row) and the provider-level checks (about 17 ms a provider) run in pick order, once per provider for the provider-level ones; the stop is read per provider through the gate's own fallback; the order, the locks and the lease are unchanged. A call that spends its budget returns the rows it found, the next call continues.
- **Rolled-back live run with the daily share opened:** the old course search pick took 17.7 s for 40 rows (a time-out); the new one 5.1 s for 17 rows, all among the old 40. Discovery: 5.05 s with nothing in focus; with 3 focus providers forced due it picked the same 3, in course-count order.
- **After the apply (08:43:32):** 12 of 12 `discover` calls started since returned 200 (the 2 failures at 08:43 had started before the apply). 6 of 6 `link_search` calls returned 200, but the share is spent, so the course search pick has not yet run its full path live: that is the first check at 00:00 AEDT 20 Nov.

**Not done:**
- The 10 pages stay unread, and the other binder rows in the same state (95 at 07:50, mostly UVic) are untouched.
- The read worker's resource limit: not changed (worker code, or the read call size `batch.coverage_read`, are not this lane's).
- The course search pick under the open share: first live proof at 00:00 AEDT 20 Nov.

**Next executable action:**
- Worker owner / Platform Admin: reduce the read call's page count (setting `batch.coverage_read`, Settings › Pipeline settings, with a reason) or raise the worker's compute, then release the 10 pages again (Read now on each course) and read the results.
- S2-BOOST-Discovery, 00:05 AEDT 20 Nov: read the first 10 `link_search` calls after the share opens (expect 200 with picks, no 500).
- The ANU and La Trobe hold and the university search stop stay as decided.

## 19 Nov 2026 10:15 AEDT — S2-BOOST-Courses self-check: held descriptions drained, G3 clean

**Trigger:** the self-check scheduled by the 06:49 AEDT handover mandate (read-only).

**Read live:**
- Course descriptions: the 09:23 `field-gap-queue` run succeeded and the 650 superseded descriptions were re-read. Admitted since 07:40: 267 (161 with `cdesc-source-grounded-v4`). Courses holding a description: 14,433 (07:42) to 14,700 at 10:14 of 36,031 active (44,733 in total). Still declined since 07:40: too many sentences 254, identity margin 240, binding ambiguous 175, too long 39, evidence moved 15, wrong page kind 14, refused word 8. In review: 94. The sentence-count and length declines are readings made under the older prompt, not v4 readings.
- Study load: 5,689 of 36,031 active (unchanged since 08:21; #1347 released 820 items for the label-split reader).
- Intakes and fees: the 08:12 Coverage tiles stand (Intakes 13,456, Provider tuition 10,797 of 36,031 admitted). Pilot #1346 (s723 every intake month, s724 strict stratified fee replay, s726 deadlines; worker v1.0.26, migration `20261119103000`, records only) merged at about 10:03; the replay writes and qualifies nothing, so no new intake, fee or deadline value was admitted and no fee tier is enabled.
- Campus locality: #1341 settled 3 postcodes (9 campuses); 69 campuses still wait for a person.
- Migrations and G3: live head `20261119103000`; `20261119084000` applied once; `security.consumer_api_check_v1()` reports no drift, 75 functions and 48 relations.

**Outstanding:**
- The fee and intake replay results (#1346) and the decision on which tier, if any, to enable are with the S1-Courses lane and Platform Admin; nothing is enabled by a passing replay.
- The UAT sign-in check in PIM Admin ran through the deployed-uat workflow (s728, run 44400209609 at 08:2x); a second run needs a change to `.github/s2-boost-live-counts-candidate`.
- Declined descriptions that need v4 re-reads again after the 94 in review are handled by the hourly gap queue.

## 19 Nov 2026 09:55 AEDT — S2 - BOOST: study-load label split and 206 international study loads admitted; campus locality by campus name; Boost fields v2 replay finds no field at the bar (Pilot #1337, #1341, #1346, #1347)

**Trigger:** Platform Admin directives 05:40 and 06:55 AEDT (Platform Admin directives 05:40 and 06:55 AEDT, spec block s720–s739; 07:40: continue without the browser). This block covers study load, multi-field reading, campus locality and the test project; the other blocks of the lane keep their items.**

- **s720, test project:** no Pilot change was needed. S2-Build's admin #622 fixed the `outside_window_refused` check; rebuild run 44369667112 passed with it `true`. Run-5 (admin run 44374301938, re-seeded) passed **9 of 9**: 60 admitted for 60 courses at batch sizes 1,000 and 5,000, duplicates refused, shadow admitted nothing, held courses unchanged, G3 75/48 on the test project.
- **s721, study-load label split (Pilot #1337, worker v1.0.24, selectors `study-load-windows-v6` and `study-load-international-v3`, prompt `boost-study-load-v5` unchanged):**
  - Unpunctuated stored text is split at its Domestic and International labels only when a block holds both (CDU, La Trobe, VIT).
  - A line under the Domestic label never states the international load.
  - Closures such as "not available to international students" are never split.
  - S1-Courses closed its own split (#1336) as superseded; its s666 spec passes unchanged against #1337.
- **s722, release and admission (Pilot #1347, migration `20261119082000`, data only, dry run md5 `d26cba54`):**
  - 740 study-load items were released for one re-read: rejected, failed or refused at promotion, on the course's own latest unshared page, course with no study load and no manual lock.
  - Drained by 08:10 AEDT: the batches since the release read 820 items (418 verified, 401 rejected, 1 failed).
  - **206 courses gained an international study load** (110 full-time, 93 both, 3 part-time), each matching its admitted answer. Every one had no study load at release, and the claim takes only courses with none, so nothing was overwritten.
  - 5,689 courses now hold a study load. Cost about US$0.05.
  - The 35 items released before stay released: their pages are shared, so the claim does not read them.
- **s723, s724 and s726, multi-field (Pilot #1346, worker v1.0.26, migration `20261119103000`, records only):**
  - Prompt `boost-fields-v2`: intakes are every announced start month; a new application deadline field gives the date, the intake it belongs to and the verbatim quote, checked by page check `boost-fields-check-v3`.
  - Replay scoring: a held primary intake contained in the page's months agrees. Fees are compared strictly on basis, currency and fee year. Strata are sized one by one (annual 160, whole-course total 60), and the run stops at US$0.15.
  - The `boost_fields_extract` qualification row names v2. `boost.fields_lanes` is unchanged, so live reading does not ask for deadlines.
  - Worker numbering: v1.0.25 went to S1-Courses' #1344, so this change is v1.0.26.
  - **Replay `replay-v2-1`** (Pilot run 44413900611): 237 stored pages, Qwen3 30B, cost US$0.0606 (limit US$0.15), nothing staged or admitted. **No field passes the bar** (at least 100 compared, at least 95%, no disagreement), so **s725 did not admit anything**:
    - intakes: 21 verified, 13 agree and 8 disagree (62%). By s723: 8 exact, 3 contain the held primary intake, 2 page subsets.
    - course fees: 34 verified, 17 agree and 7 disagree (71%). Annual 10 of 11 (91%); whole-course total 7 of 13 (54%).
    - application deadlines: 20 pages hold one; 3 verified, all 3 agree; 17 refused by the page check.
  - **What the disagreements show:** most are the held value, not the reading. Held intake "March" against the page's "First semester (February)"; held CRICOS registered totals against the provider's current "Total course fee". The gold set therefore needs current held values before it can qualify the model.
  - **The 150 and 50 targets were not reachable:** the catalogue holds too few stored pages with a comparable fee of the same basis, currency and year. 197 of the 234 fee answers were refused by the strict page check.
  - Next: a gold set built from verified page values (not CRICOS registration), or human-confirmed samples. Live admission of intakes, fees and deadlines stays off.
- **s727, campus locality (Pilot #1341, migration `20261119062000`):**
  - Rule `l4-campus-locality-v1` gains the basis `campus_name`: the leading urban area holds more than half the postcode's mesh blocks and is named in every waiting campus's suburb or own name, never only through the provider's name (Roseworthy 5371 waits).
  - The 07:57 run settled **3 postcodes, 9 campuses, 0 failures** (2650 Wagga Wagga, 4670 Bundaberg, 6330 Albany). 28 postcodes (69 campuses) wait for a person; settling more by rule needs a suburb-to-area gazetteer the platform does not hold.
  - `062000` was numbered above the live head and every open PR when written, but it applied after `20261119080000` (#1345), which merged first. #1346 and #1347 were renumbered above main before merging.
- **University descriptions, read-only (sentence-1 name rule):** 45 of 49 published university and university-college descriptions name the provider in sentence 1. The 4 that do not were published 10 and 11 Nov on prompt v2:
  - **University of Waikato:** off-topic ("The Academic Calendar …").
  - **Southern Cross University:** "The university uses …".
  - **ECU and ANU:** initials only. `pdesc_name_forms_v1` gives no initials for these names.
  - For S2-BOOST-Providers; nothing changed here.
- **s728, held scholarships, read-only:** rule `l4-held-sch-settle-v1` is settling. 82 pending: 57 audience not stated, 11 without a re-check, 6 publish and 2 refuse recommendations held by the rule's own conditions (for example a `/staging/` address), 3 unclear value, 3 unsettled. Nothing changed.
- **Course descriptions (item 1), S1-Courses' lane:**
  - The 1–2 sentence reader and the identity proof are live (#1344, migration `20261119084000`, prompt `cdesc-source-grounded-v4`).
  - Since 07:44 AEDT: 77 admitted with no overwrite. All 666 earlier readings were declined for a v4 re-read from the stored page (no Firecrawl).
- **Browser check:** not done. Claude in Chrome was not connected, and the Platform Admin said at 07:40 to continue without it. GitHub secrets cannot be read back, and were not printed. The screens are covered by the deployed UAT workflow, which signs in with them; it passed on each merge (for example run 44384114106).

**Next executable action:**
- S2 - BOOST: build a multi-field gold set from verified page values (not CRICOS registration) or human-confirmed samples, then replay again; live admission of intakes, fees and deadlines stays off until a field passes.
- S2-BOOST-Providers: Waikato's off-topic description and the ECU and ANU initials (name forms).
- S1-Courses: read the v4 course-description re-read drain to its end.
- A person: the 28 campus postcodes left in Layer 4 › Campus locality.


## 19 Nov 2026 10:24 AEDT — S2-BOOST-AER: scheduled check, AER course machine queue drained (s748, s749)

Read only, project `fxcwkweaxjtknorudmwp`, 10:24 to 10:26 AEDT. No change made.

- **Course reads admitted since S748 (07:50): 73.** 26 at 09:24, 43 at 09:54, 4 at 10:24. The 08:54 run, the first under S749, checked 169 items (audit samples first).
- **Would-admit reads still waiting: 16** (89 at 07:02). At the current rate they are reached in the next run or two.
- Live definitions unchanged since the merges: `aer_machine_admit_v1` md5 `89a5c44b`, `aer_machine_run_v1` md5 `fc9261cb`. P0 findings open: 0. G3 75/48. Head `20261119103000`.
- **Matrix machine:** admit mode (validated 06:30), 79 matrix items pending. No admission since the 2 at 06:54 (6 rows). By latest outcome:
  - D-R3 gate incomplete: 70
  - all rows held: 11
  - change of an admitted table: 6
  - shared host: 6
  - source not on the official host: 5
  - earlier rejection: 2
  - audit sample: 1
  - no rows: 1
  - The run re-checks pending items every 30 minutes and records only a changed outcome. Only a new read fixes the gate-incomplete items.

**Next executable action:**
- S2-BOOST-AER: S747, the 10-table chunked smoke test (≤ US$0.10, pinned models only), from the merged chunker (Pilot #1358).


## 19 Nov 2026 11:10 AEDT — S2-BOOST-Providers self-check: GPT-4.1 mini re-read results (no change made)

Read live at 11:05, SELECT only. No rule, route, cap or setting was changed. G3 75/48, no drift. Manual locks 7,585.

**Totals:**

| Measure | 07:07 | 11:05 |
|---|---|---|
| Published, active providers with a description (of 2,830) | 2,171 | 2,184 |
| University descriptions pending in Layer 4 | 61 | 62 |
| Scholarships published (of 2,832 records) | 1,066 | 1,066 |
| Held scholarship pages | 82 | 82 |

- **Re-read of 267 (launched 08:36):** 252 finished, 14 still queued and 1 being read. 13 admitted by the unchanged machine rule, 1 proposed in Layer 4, 238 held.
  - Spend US$0.0478 for 55 model calls; Firecrawl reads 0. The service cap of US$0.50 a day was not approached.
- **58 grounding holds:** 12 admitted, 40 held again (quote not on the page 17, unsupported sentence 10, nothing stated 10, others 3), 6 queued.
- **196 identity holds:** 184 are still held by the page identity proof. 1 was admitted and 1 proposed; the other 10 are queued or held by another rule. The s762 rule released at most 12.
- **13 never-read providers with a stored page:** none admitted. All 13 were held before any model call: identity not confirmed 6, name not clean 2, shared domain 2, shared host 1, register changed 1, redirected or parked 1.
- **Held scholarships:** unchanged at 82.

**Not done:**
- 15 reads had not finished at 11:05.

**Next executable action:**
- Provider description owner or Platform Admin: the 184 identity holds need a trading name recorded for the provider, or a person; the narrow rule does not reach them.
- A person: the 62 university descriptions in Layer 4.

## 19 Nov 2026 11:35 AEDT — S2-BOOST-Discovery: read-only scholarship and AER discovery audit (AU, NZ, CA); report `docs/platform/2026-11-19-scholarship-and-aer-discovery-audit.md`

Read-only, no write, no Firecrawl spend, no table, column, function, job or setting added (G3 75/48). Of 1,675 active providers with international courses (AU 1,544, NZ 79, CA 52; 1,886 if courses not recorded as domestic-only are counted, NZ 290): **(a)** 1,571 hold a homepage (220 verified by search, 362 entered by a person, 989 register values not flagged; 104 AU have none); **(b)** 708 have a scholarship page crawled or a record published (91 published); **(c)** 797 have an entry-requirements read (AU 751, NZ 46, CA 0); **(d)** 90 have zero discovered pages (No site 26, No page 64, all AU); a further 355 have pages but nothing read. 1,385 lack a scholarship hub or an entry-requirements source (421 lack both). **Canada has no entry-requirements source for any of its 52 providers and no row in `aer_provider_coverage`**, so 25 of the top 30 uncovered providers are Canadian (UBC 575 courses, Alberta 379, Canterbury NZ 282, Conestoga 270). The Coverage & completeness screen shows academic entry as No reader for 34,631 courses because the field register reader is `none`; it cannot separate a provider with no source from one read but not admitted. Open work: Platform Admin to decide whether Canada joins the AER programme; AU and NZ top 20 and the 355 read-pending providers are listed in the report for post-handover crawls.

## 19 Nov 2026 11:40 AEDT — S2-BOOST-Discovery: Canada approved for the AER programme in Wave 2; the 355 read-pending providers are the priority read queue (closes the open work in the 11:35 audit entry; audit #639)

Platform Admin 11:36 AEDT. **Canada (52 international providers, including UBC, Alberta and Conestoga) joins the AER programme in Wave 2, immediately after the 20 Nov handover.** Today's remaining budget and queues stay on AU and NZ. **Priority read queue (no search credit): the 355 providers that already have discovered pages and nothing read for scholarships or entry requirements** (AU 332, NZ 21, CA 2; the 2 Canadian providers wait for Wave 2), then the remaining AU and NZ AER and scholarship drains. Docs and registers only: nothing was started on the queue, no setting, job, table or function changed (G3 75/48), no migration. Correction: the audit entry and report were stamped 11:55 AEDT in error; the audit ran about 11:15 to 11:35 AEDT on 19 Nov and the stamps now read 11:35. Ledger row, workbook and Drive Monitoring synced with this entry.

## 19 Nov 2026 12:40 AEDT — S2-BOOST-AER: S747 chunked matrix smoke test run, nothing qualified; course drain 75, the last 16 still queued (Pilot #1365, #1368)

Platform Admin 10:48. Worker `coverage-sweep` v1.0.27 then v1.0.28 (mode `aer_chunk_smoke`) and one data-only migration `20261119110500` (Pilot #1365); the table match fix in Pilot #1368 (no migration). No table, column, function or job added; G3 75/48 read back. Spec s747 (6 tests).

**Done and read back from live (11:00 to 12:40 AEDT):**
- **Matrix reader on the row chunker.**
  - Mode `aer_chunk_smoke` reads one table of a stored entry-matrix page through `entry-chunks.ts` (S744 to S746), 25 rows a call.
  - It checks every answer without a model: row completeness (each row answered once, no invented row), quote fidelity (each quote inside its own row) and minimum in quote.
  - It admits, proposes and records no reading.
- **Prompt version kept as data.**
  - `aer-v2-matrix-chunk-v1` is 3 candidate rows of `pipeline.ai_instruction_versions` (ids 44 to 46), one per pinned model, each with its v3.1 provider pins.
  - Text sha-256 `15888e86…`. The worker refuses a version whose text does not match.
- **Smoke test: 10 gate-held tables, 237 rows, one per provider.**
  - Selection rule: from the held pages that lost the most rows, the largest table of 8 to 70 rows, at most 12,000 characters.
  - Workflow `aer-chunk-smoke.yml`, under on-demand windows `851c9099` (11:36 to 11:48) and `59b754f0` (12:09 to 12:37). Both closed. Firecrawl 0.
  - Run 1 refused 7 of 10 tables before any model call: the tables were chosen on the exported copy (title, h1 and tables), whose table numbers differ from the whole page's. v1.0.28 finds the table by its rows; run 2 matched all 10.
  - **Spend US$0.0276 of the US$0.10 cap** (run 1 US$0.0080, run 2 US$0.0196). `ai_invocations` source `aer_chunk_smoke` agrees: 54 attempts, US$0.02756.

| Pinned model (run 2) | Row completeness | Quote fidelity | Minimum in quote | Invented rows | Cost US$ |
|---|---|---|---|---|---|
| xiaomi/mimo-v2.6-flash | 100% (237/237) | 100% (237/237) | 99.3% (136/137) | 0 | 0.0070 |
| qwen/qwen3-30b-a3b-instruct-2507 | 59.5% (141/237) | 97.2% (137/141) | 100% (127/127) | 0 | 0.0084 |
| mistralai/mistral-small-3.2-24b-instruct | 36.7% (87/237) | 100% (87/87) | 82.9% (34/41) | 0 | 0.0042 |

- **Bar not met; nothing promoted.** The bar is 100% on all three measures with no invented row.
  - MiMo misses it by one row: Manukau, row 28, minimum not printed inside its own quote.
  - Qwen and Mistral lost whole groups: calls that ran past the 90-second limit on 25-row groups, and Qwen answering rows twice.
  - Nothing is qualified, admitted or switched on. Each run is one control event (`aer` / `matrix_chunk_smoke`).
- **Course drain.**
  - 75 course reads admitted since S748 (26 at 09:24, 43 at 09:54, 4 at 10:24, 1 at 11:24, 1 at 11:54).
  - The last 16 would-admit reads all pass `aer_machine_check_v1` (14 `aer-machine-v1`, 2 `aer-machine-v1-except`). At 11:14 they stood at queue positions 1,407 to 1,767 of 1,801 eligible items, about 170 checked a run, so they are reached by about 15:30.
  - P0 0. Head `20261119120000`.
- **Test register.** `docs/platform/TEST-REGISTER.md` regenerated from Pilot main `107fe5c2` is byte-identical to this repository's (the s747 row has been in since #641). This closes the 08:50 "not regenerated" note.

**Not done:**
- The 16 course reads are not yet admitted (queue order, not a hold).
- No chunked reader is qualified.

**Next executable action:**
- S2-BOOST-AER, 15:45 AEDT (scheduled): record the final 16-item drain here and in the registers.
- Platform Admin, AER v2 (a decision): either (a) a second chunked run with MiMo v2.6 Flash only, on more tables, with 12 rows a call (stays inside the 90-second limit), or (b) keep the AER v2 replay paused.

## 19 Nov 2026 13:45 AEDT — S2-BOOST-AER: S750 MiMo v2.6 Flash, 12 rows a call, 20 tables: 99.8% rows, 100% quotes, 99.4% minimums, bar not met; Manukau miss explained (Pilot #1373)

Platform Admin 13:05 (decision approved). Worker `coverage-sweep` v1.0.29 and script/workflow only; no schema migration (G3 75/48 read back). Spec s750 (3 tests).

**Done and read back from live (13:15 to 13:45 AEDT):**
- **Worker v1.0.29 (mode `aer_chunk_smoke`).**
  - Each call reports its own duration, measured against the 90 s time-out.
  - A row that fails a check comes back with the row as sent and the model's own answer.
  - `inspect_only` returns a table's row chunks with no model call and no spend.
  - `aer-chunk-smoke.yml` takes a model, rows a call, a table set and an inspect list.
- **The 20 tables (`tests/fixtures/aer-chunks/smoke-tables-20.json`, 645 rows).**
  - The S747 rule (gate-held pages, most rows lost first, one per provider) with the character bound raised to 16,000 so that 20 providers qualify. The S747 ten are kept.
  - The gate-held set holds three universities (Lincoln, CDU and ANU). The other 17 are colleges, TAFEs and NZ institutes, so 20 university-only tables were not available.
- **Run** (workflow run 44444450585, on-demand window `53d590e8`, 13:27 to 13:40, closed; Firecrawl 0).

| xiaomi/mimo-v2.6-flash, 12 rows a call | Result |
|---|---|
| Tables answered | 20 of 20 |
| Row completeness | 99.8% (644/645) |
| Quote fidelity | 100% (644/644) |
| Minimum in quote | 99.4% (343/345) |
| Invented rows | 0 |
| Calls / longest call | 62 / 32.9 s (time-out 90 s; none over 60 s) |
| Spend | US$0.019775 of the US$0.05 cap (`ai_invocations` agrees: 62 attempts) |

- **Bar not met (100/100/100, no invented row); nothing admitted, promoted or switched on.** Three rows decide it:
  - **KBS, Zimbabwe (row 52), page structure:** the row prints one requirement per study-level column (Diploma, Bachelor); the model returned two records, one per level, so the row counts as doubled.
  - **KBS, Korea (row 27), page encoding:** the page writes its quote marks as old Windows character codes (`&#145;C&#146;`), which stay undecoded in the row text; the model wrote the minimum as `'C' grade average`, so it is not inside its own quote.
  - **Sydney Institute, Australia (row 2), prompt wording:** the row prints "ATAR of 60"; the model wrote "ATAR 60", following the prompt's own example ("ATAR 70").
- **The Manukau miss of run 2 (136/137).**
  - Row 28 is "Pacific Islands" (confirmed with `inspect_only`; read from the title, h1 and tables form). Its Diploma cell prints no minimum and its Degree cell prints "55% average".
  - One record per row cannot hold both, so this is a page-structure edge case (two study levels in one row), the same class as KBS Zimbabwe, not the prompt.
  - At 12 rows a call the same row passed (Manukau 26/26 minimums).
- **AER v2 smoke spend so far:** US$0.047332 over three runs (116 attempts).
- **Course drain at 13:42:** 75 admitted since S748, 16 still queued (they pass the rule), P0 0, head `20261119125500`.
- **Test register:** `docs/platform/TEST-REGISTER.md` regenerated from Pilot main `395cd53f` (adds s750; picks up two rows other sessions changed).

**Not done:**
- No chunked reader is qualified.
- The 16 course reads are not yet admitted (queue order, not a hold).

**Next executable action:**
- S2-BOOST-AER, 15:45 AEDT (scheduled): the final read-back of the 16 course reads, recorded beside these figures.
- Platform Admin (a decision): the three edge cases would need reader changes before another run:
  - a contract that gives one record per study-level cell;
  - decoding the Windows character codes in the chunk text (which touches the shared text converter, held by the AER v1 freeze);
  - prompt wording that copies the minimum exactly as printed.

## 19 Nov 2026 15:45 AEDT — S2-BOOST-AER: handover close-out: course drain 76 of 91, S751–S752 verification (100% minimum in quote, 99.9% quote fidelity), Platform Admin decision of 15:14 for the S1 follow-up

Scheduled close-out under the Platform Admin directives of 10:48, 13:05, 14:25 and 15:14. Read only, no setting changed, no replay, no Pilot PR. `aer.v2_shadow_on` 0 and the `ai_eval` run switches 0, so no further AER v2 spend and S2 weekly capacity is preserved. G3 75/48, P0 0, head `20261119153000`.

**Course AER drain (read 15:46):**
- **76 of 91 admitted since S748** (26 at 09:24, 43 at 09:54, 4 at 10:24, 1 at 11:24, 1 at 11:54, 1 at 14:54).
- **The last 16 are not admitted yet.** All 16 still pass `aer_machine_check_v1`; none is held.
  - They stand at queue positions 914 to 1,268 of 1,304 eligible course reads (1,407 to 1,767 of 1,801 at 11:14).
  - The run takes gate-complete reads first. That group (mostly audit samples) becomes eligible again every 6 hours and goes back in front, so the queue advanced about 55 places a run, not the 170 estimated at 11:14.
  - Expected reached between about 20:30 and 22:30 AEDT tonight, when the rule admits them.

**S751–S752 (Pilot #1376, worker v1.0.30, migration `20261119143000`, data only):**
- Prompt `aer-v2-matrix-chunk-v2` (row 48, sha-256 `7897c6c5`, MiMo v2.6 Flash, 12 rows a call).
  - Contract v2: one record per row and study level.
  - The minimum must be an exact substring of its quote.
- Windows-1252 punctuation folded inside the AER v2 verifier only. The shared AER v1 text converter is unchanged and spec s752 pins it.
- Verification replay (run 44453911662, on-demand window `c6262d9f`, closed):
  - Spend: US$0.028067 of the US$0.03 cap; `ai_invocations` agrees (55 attempts).
  - The cap stopped the run after 18 of 20 tables. ANU and Sydney Institute were not run, because multi-record answers cost about 40% more.

| MiMo v2.6 Flash, prompt v2, 12 rows a call (18 tables, 565 rows) | Result |
|---|---|
| Quote fidelity | 99.9% (818/819) |
| Minimum in quote | 100% (519/519) |
| Invented records | 0 |
| Row completeness | 89.4% (505/565) |
| Longest call | 66.7 s against the 90 s time-out (2 over 60 s) |

- The three S750 edge cases now pass: Manukau two-level rows (53/53 minimums), KBS Korea Windows quote codes (KBS 70/70 minimums) and verbatim minimums.
- **Row completeness losses:**
  - Several qualifications under one study level (TAFE SA, KBS India) were counted as doubled by the (row, study level) rule.
  - UTS College gave identical duplicate "N/A" records and one call timed out.
- **Bar not met; nothing promoted.**

**Platform Admin decision, 15:14 AEDT (recorded for the post-handover S1 follow-up; not built here):**
- **Option 1:** a row is doubled only when (row index, study level, normalised quote) repeats. Distinct qualifications under one study level pass; duplicate "N/A" records are still rejected.
- **6 rows a call on wide multi-column tables** (target under 35 s a call).
- AER v2 live admission stays paused until sign-off after the handover. No further replay in this session.

**Records:** `docs/platform/TEST-REGISTER.md` regenerated from Pilot main `b6974a69` (s751 and s752 are in; picks up s771 and s772 from other sessions).

**Not done:**
- The 16 course reads (queue order, not a hold).
- The Option 1 verifier and the 6-row setting (post-handover S1).

**Next executable action:**
- S1 (post-handover): build Option 1 in `aerChunkVerifyV2` and 6 rows a call for wide tables, with the Platform Admin's spend approval, then replay on the 20 tables.
- Any session after 22:30 AEDT: confirm the 16 course reads were admitted (91 of 91).


## 19 Nov 2026 16:15 AEDT — S2-BOOST-Providers: Australian university descriptions triaged; none admissible by rule (no change made)

Platform Admin 16:02. Read live 16:04 to 16:08 through the rolled-back `live-dry-run` workflow (probe expression, SELECT only). No rule, route, cap, setting or description was changed, so no spec was written (s766 unused). G3 75/48, no drift. Manual locks 7,585. Firecrawl off; provider AI spend today US$0.0075 of the US$0.50 cap; US$0.00 spent by this run.

**Before and after (unchanged):** Australian universities with a description 37 of 45; Australian university colleges 6 of 8; all active providers with a description 2,185 of 3,091 (906 without, 645 of them published).

**The 10 Australian university records without a description:**

| Provider | State | Exact reason | What settles it |
|---|---|---|---|
| University of Technology Sydney (UTS) | Layer 4, pending | Machine rule: after sentences with refused words are left out, fewer than two remain. The reading itself is sound. | A person approves it in Layer 4 |
| Victoria University (two records, `0f5373c8` and `bac82321`) | Identity hold, never read | Both records hold the host vu.edu.au, so each blocks the other | Merge or retire the duplicate record |
| RMIT University | Identity hold, never read | Host rmit.edu.au is also held by "RMIT University Pathways, RMIT UP" | Record which provider owns the host |
| Western Sydney University | Identity hold, never read | Host westernsydney.edu.au is also held by "UWS College, Western Sydney University The College" | Record which provider owns the host |
| Torrens University Australia | Identity hold, stored page | Page title is "About Us \| Torrens University"; the catalogue name ends in "Australia" | A trading name "Torrens University", or a person |
| Moore College (university college) | Identity hold, stored page | Page title is "About Moore Theological College"; the catalogue name is "Moore College" | A trading name "Moore Theological College", or a person |
| Avondale University | Wrong page, no stored page | The About address redirects to `/your-uni/`, which is not an approved About address | An approved About address for the provider |
| Macquarie University | Never read, no stored page | An open identity finding (identity unconfirmed) stops the read | Resolve the identity finding |
| Australian University College of Divinity (university college) | Never read, no stored page | Its domain is shared with a provider record named "NA" | Fix or retire the "NA" record |

- **No re-read was run.** The two with a stored page and a name mismatch (Torrens, Moore) would be held again by the unchanged identity proof, so a model call would change nothing.
- **Layer 4.** Of the 62 pending university-description items, 1 is an Australian university (UTS). The others: Australian private VET 28, schools 7, higher education institutes 7, other 3; Canada 11; New Zealand 5. Each went to Layer 4 because the machine rule `pdesc-machine-v1` declined its text; none passes as it stands.
- **Why there is no Australian university pill.** The Layer 4 grid filters by kind and reason only; it has no country or provider-type filter. A `Country` and `Provider type` filter is a screen change for S1-Build after handover.
- **All 906 providers without a description, by country and state:**

| State | AU | CA | NZ |
|---|---|---|---|
| No stored page | 348 | 76 | 59 |
| Identity hold | 177 | 74 | 31 |
| Layer 4, pending | 46 | 11 | 5 |
| Grounding hold | 17 | 10 | 2 |
| Other (wrong page, sentence count, wording) | 26 | 9 | 11 |
| Never read, stored page | 3 | 0 | 0 |
| Queued | 1 | 0 | 0 |
| **Total** | **618** | **180** | **108** |

**Not done:**
- No Australian university description was admitted.
- Propagation to the Website and Zoho projections was not checked, because nothing was admitted.

**Next executable action:**
- A person: approve UTS in Layer 4.
- Platform Admin or catalogue owner: the duplicate Victoria University record, the shared hosts for RMIT and Western Sydney, the "NA" record, and the Macquarie identity finding.
- S1-Build, after handover: `Country` and `Provider type` filters on the Layer 4 grid.

## 19 Nov 2026 17:10 AEDT — S2 - BOOST s754: university and higher-education provider descriptions triaged; 0 ready to admit; bounded re-check of 2 held again (Pilot #1383)

**Trigger:** S2 - BOOST (Platform Admin 16:00, s754: university and higher-education provider descriptions). This block is newer than the S2-BOOST-Providers 11:10 block for those items.**

Pilot #1383, one data-only migration `20261119170500` (dry run md5 `4d54f3c2`; applied, read back 17:05). No table, column, function, job or setting. G3 75/48, no drift. Manual locks 7,585. Every live read was made through the rolled-back dry run (workflow_dispatch on a probe branch), with no interactive query.

- **Scope found live:** 201 published, active providers of the types university (53), university_college (8), higher_education_institute (137) and wānanga (3). 141 hold a description and 60 do not. The directive's 209 could not be reproduced from the live tables; this block reports the 201 and the 60.
- **The 60 without a description, by their latest read:**

| State | Count |
|---|---|
| Ready to admit (passes the machine rule) | **0** |
| Layer 4 pending: all 8 declined by the machine rule; a person decides | 8 |
| Identity hold | 29 |
| Grounding hold outside Layer 4 (read today with GPT-4.1 mini) | 2 |
| Other content hold: sentence count 3, not stated 2, refused topic 1, refused source word 1, not an about page 1 | 8 |
| No stored page and never read | 13 |

- **Identity holds (29):**
  - 9 share a website with another active provider record (Holmes Institute 3, Victoria University 2, RMIT, Western Sydney, Le Cordon Bleu, Trident).
  - 18 are pages that do not prove the full catalogue name.
  - 1 is identity unconfirmed (ECA) and 1 a sub-unit page (Christian Heritage College).
- **Why no read can clear them:** the identity proof runs before any model call and takes names only from the catalogue and the register. 8 of the 18 look like the same institution under a trading name or with a suffix, on the provider's own website:
  - AUT ("… in New Zealand");
  - Lyons College;
  - Te Whare Wānanga o Awanuiārangi;
  - Torrens University;
  - Moore Theological College;
  - Kaplan Murdoch;
  - Sydney Metropolitan Institute of Technology;
  - CIHE (Crown Institute of Higher Education).
- **Clearing those 8** needs a trading name recorded for the provider or a person; the 07:39 rule keeps a place or sub-brand after the name held, so the proof was not weakened. The other 10 correctly stay held: the page names another institution (Emmaus to ACCS, AIM, Deakin College, Texila) or the title does not carry the name (APEX, EQUALS, IBC, Ozford, Sydney Institute of Higher Education, AMPA).
- **Re-check (s754):** one GPT-4.1 mini read from the stored page went to each provider whose latest read was held by a content rule (never identity) and was not made by GPT-4.1 mini in the last day. That was 2: Kingsford Institute of Higher Education and Australian Guild of Education.
  - Both were read at 16:31 and held again (not stated: the page does not describe the institution).
  - Spend US$0.0006 (US$0.00 Firecrawl, `pdesc.acquire_firecrawl` 0); the provider_description route stood at US$0.0081 today, inside its US$0.50 cap.
- **Before and after:** published providers with a description 2,185 → 2,185; higher-education 141 → 141. Nothing was admitted, so the Website and Zoho projections are unchanged. Layer 4 provider descriptions pending (all types): 62.
- **No stored page (13):** Macquarie University, Victoria University of Wellington, Te Wānanga o Aotearoa and 10 others stay held; a read needs a page, and Firecrawl is off.

**Next executable action:**
- Platform Admin or the provider owner: record trading names for the 8 same-institution identity holds (or approve them in Layer 4), and decide the 9 shared-website records (which provider owns the site).
- A person: the 8 higher-education descriptions in Layer 4 (62 provider descriptions in all).
- Platform Admin: allow Firecrawl for the 13 providers with no stored page, if wanted (about 13 credits).


## 19 Nov 2026 17:35 AEDT — S2-BOOST-AER: S753 Layer 4 AER triage and bounded drain: 17 rule-compliant reads admitted (2,579 → 2,562), 16 would-admit reads cleared (93 since S748), holds unchanged (Pilot #1381, #1384, #1387)

Platform Admin 15:59. Script and workflow only (`scripts/aer-l4-drain.mjs`, `aer-l4-drain.yml`, spec s753): no migration, no worker change. Zero AI and Firecrawl spend: only the AER v1 rules' own database functions ran. Every query and write went through GitHub Actions (Management API); none through an interactive prompt. G3 75/48, P0 0, `aer.v2_shadow_on` 0, manual locks 7,585 unchanged.

**Triage (drain run 44469183404: before at 17:13, after at 17:30 AEDT; the read-only run 44466360632 at 16:50 gave the same before counts).** Every pending AER item went through its rule's read-only check (`aer_machine_check_v1`, `aer_matrix_machine_check_v1`):

| Pending AER items in Layer 4 | Before | After |
|---|---|---|
| Pass the rule (machine-eligible) | 17 | 0 |
| Completeness gate not passed (`gate_incomplete`) | 1,835 course + 57 matrix | same |
| Audit sample (a person checks; left untouched) | 491 course + 1 matrix | same |
| Every row fails a row rule (`all_rows_held`) | 102 course + 9 matrix | same |
| No bound course page (page identity) | 38 | same |
| Page identity basis not admitted (`identity_not_admitted`) | 17 | same |
| Change to an admitted matrix (a person decides) | 6 | same |
| Shared host / source not the official host | 2 + 2 | same |
| No rows / earlier rejection | 1 + 1 | same |
| No-overwrite conflict (`active_rows_exist`) | 0 | 0 |
| Manual lock | 0 | 0 |
| **Total pending** | **2,579** | **2,562** |

- **Leases.** Layer 4 items carry no worker lease (no `locked_until`). There were no person claims of any age and no assignments, so nothing was reclaimed.
- **Drain.** One tick of 17 items (bound 250, run at 40), 13.4 s, rows locked `FOR UPDATE SKIP LOCKED`, clear of the cron's :24 and :54 runs. The cron's own admission function `aer_machine_admit_v1('run')` admitted all 17.
- **Entry requirements.** Active rows in `catalogue.course_entry_requirements` went from 25,412 to 25,452 (+40, proposed rows made active; table total unchanged at 36,295; no row overwritten).
- **Course drain after S748.**
  - 93 admitted: the 76 recorded at 15:45 and the 17 here.
  - Would-admit reads waiting: 0, read back through the rolled-back dry run (run 44472699290). The last 16 of the 91 are in.
- **Gates.** No rule, threshold, switch, lock, claim or held item changed. One control event each run (`aer` / `l4_triage`, `l4_drain`).
- **Script fixes during the run.**
  - Pilot #1384: 400 checks in one statement passed the API's 60 s statement time (rolled back, nothing changed). Statements now start at 50 or 100 and halve on a time-out.
  - Pilot #1387: the job limit is 60 minutes, because a drain triages before and after.

**Remaining human-review holds (2,562):** completeness gate 1,892, audit sample 492, all rows held 111, page identity 55 (no bound page 38, identity basis 17), matrix changes 6, host 4, no rows 1, earlier rejection 1. Only a new read or a person moves these.

**Next executable action:**
- None for S2-BOOST-AER.
- The gate-held reads need corrected reads (AER v2, paused until sign-off after the handover).
- The audit samples and matrix changes wait for a person in Layer 4.

**S1-AER, 20 Nov 2026 11:05 AEDT: Boost DB AER and English lane — pre-flight, live gap read and mockup; no extraction, promotion or Main DB change yet**

Read only; zero schema migrations, no data change, zero AI and Firecrawl spend. Specs s815 to s819 claimed for this lane (above S1-Build's s813/s814; none used yet). Live read through the rolled-back dry-run route (run on the Pilot carrier branch), head `20261120110000`, 2,208 history rows.
- **Pre-flight:** no open Pilot PRs; one open admin PR (#609, S1-Courses, not touched). No course description, scholarship or Platform Health file touched.
- **Live figures differ from the brief:** 36,031 active courses (brief 34,341); 25,452 active entry-requirement rows on 9,186 courses; courses with none: **AU 16,931, NZ 6,100, CA 3,814** (brief 7,876, 4,123, 1,798). Pending in Layer 4: 2,483 course first reads, 73 matrix first runs, 6 matrix changes (2,562). `aer.machine_mode` 2, `aer.v2_shadow_on` 0.
- **Table 1, source-backed gaps** (course has a bound, stored page that was read; proxy: bound page with evidence and a read status; not yet proof the page states entry requirements): AU 12,222, NZ 4,522, CA 3,235 (19,979).
- **Table 2, no source available yet** (no bound stored page; do not quote as verified): AU 4,709, NZ 1,578, CA 579 (6,866).
- **Not done, and why:**
  - "Boost DB" is the test project `coursefinder-boost-test` (69 seeded courses). It holds none of the stored pages, so it cannot mine the 19,979 pages. The Boost design keeps `aer_entry` shadow only and never promotable; AER v1 is frozen and AER v2 live admission stays paused (Decisions 276 and the 15:14 and 23:52 decisions) until chunking or an authorised frontier model.
  - Layer 4 holds are gates, not slowness: completeness 1,892, audit sample 492, all rows held 111, page identity 55, matrix changes 6, host 4, other 2; none passes its rule (S753). A bulk approve of "verified" items can only act on items that already pass; approving held items would bypass the gates behind the 18 Nov P0 consumer findings.
  - Decision time-outs are covered by S1-Build s813/s814 (`20261120110000`).
- **Mockup (Design canvas):** Layer 4 Bulk Approve Verified AER and quote-verification drawer, hold counts live as at 19 Nov 17:35. Nothing in the product changed.

**Decision needed (Platform Admin), in one line each:**
1. Authorise Boost reading of `aer_entry` as promotable (reverses the Boost design and Decision 276 for AER), or keep it shadow and build only the deterministic and AER v1 route.
2. Confirm the Boost target: a production-scale Boost database that holds the stored pages (none exists today) or the test project.

**Next executable action (no decision needed):** S1-AER builds the deterministic English-score and ATAR/NCEA pattern reader as a shadow reader over the 19,979 stored pages in Main storage, with zero AI spend, writing only shadow readings beside Layer 4; run through workflows; then a read-back table of yield.

**S1-AER, 20 Nov 2026 12:05 AEDT: s828 recorded (parity fix): Pilot #1412 live, `20261120120000`; deterministic entry reader in shadow; s829 to s832 claimed**

Numbering (Platform Admin 20 Nov 2026 11:55): the S1-AER work of Pilot #1412 is **s828**, not s815 (s815 belongs to S1-Build, Pilot #1414). S1-AER claims **s829 to s832** for the rest of this block. Pilot spec `cf-247-s815-aer-det-reader-contract` is renamed to s828 in the s829 release.
- **Repo-first lapse, disclosed:** Pilot #1412 merged on green CI and a passing rolled-back dry run (run 44642273650), and deploy-on-merge applied `20261120120000` before this mirror existed. This block closes that gap. From here any new migration is mirrored here and merged here **before** its Pilot PR merges.
- **What is live:** worker `coverage-sweep-worker-v1.0.32`, read-only mode `aer_det_read` (reader `aer-det-v1.0`); shadow tables `pipeline.aer_det_pages` and `pipeline.aer_det_readings` (RLS on, no public grants); `security.aer_det_record_v1` (service role only, idempotent, never writes `catalogue.*` or Layer 4); setting `batch.aer_det_read` (20; 5 to 40). Workflow `aer-det-read` (status, run). G3 unchanged (75 functions, 48 tables, zero new public objects). Nothing admitted. AI and Firecrawl spend $0.
- **First shadow batch (200 stored pages, keyset by course):** 258 readings on 83 courses (IELTS 78, Year 12 96, ATAR 25, PTE 14, TOEFL iBT 10, University Entrance 10, NCEA L3 8, Canadian secondary 8, Cambridge 5, Bachelor GPA 4). Run time about 15 minutes, so the sequential runner would need about 25 hours for all 19,981 pages.
- **Precision read (30 sampled readings, checked by eye against the quote):** numeric IELTS and ATAR readings correct, quotes on the page. Findings for s829: Year 12 "stated" readings are often boilerplate with no value; University Entrance and NCEA L3 fired inside a long IELTS-only sentence (320-character window too wide); IELTS band minimums ("no lower than 5.0 in any subtest") are missed (recall).
- **Promotion:** none. It needs a new writer into the Layer 4 and `catalogue.*` path under the existing gates (second sign-off). Decision 276 holds: AI and Boost `aer_entry` stay shadow only.
- **Left alone for the Platform Admin:** S677 (`security.aer_machine_admit_v1`) and the 6 entry-matrix changes. Branch `cf247-s676-probe` stays until the read-only probes finish; the Platform Admin deletes it.
- **Next:** s829 tighten the four reader rules and parallelise the runner, then a verification batch; s830 diagnose the 1,892 partial-table-read holds; s831 Layer 4 hold-reason table and quote drawer; s832 closing sync, Drive Monitoring row and the two gap tables.

**S1-AER, 20 Nov 2026 13:10 AEDT: s829 live (reader aer-det-v1.1, parallel runner); s830 diagnosed; s831 recorded before merge (Pilot #1418, `20261120130000`)**

Specs: s828 (reader, Pilot #1412, live), s829 (precision rules and runner, Pilot #1417, merged, no migration), s830 (diagnosis, no code change), s831 (Pilot #1418, recorded here first). Spec `cf-247-s815-aer-det-reader-contract` is now `cf-247-s828-aer-det-reader-contract` (s815 is S1-Build's). TEST-REGISTER regenerated from the s831 branch.
- **s829 (live).** Reader `aer-det-v1.1`: Year 12 needs a stated value (boilerplate gives nothing); University Entrance and NCEA L3 read a same-clause window of 120 characters with a stated credit count and never inside an English-test sentence; IELTS band minimums read in eight wordings (each band, no band below, a list of components). The runner sends several worker calls at once (workflow input `concurrency`, 1 to 12, default 6) with a keyset cursor. Worker call time is the limit: 240 pages in 257 s at 6 calls (the sequential runner took about 15 minutes for 200), so all 19,981 pages need about 5 hours at 6 calls or about 2.5 hours at 12; "minutes" is not reachable without a larger per-call batch (`batch.aer_det_read` is 20, range 5 to 40; a Platform Admin setting change).
  - Verification batch (240 pages): 183 readings on 90 courses (IELTS 93, ATAR 31, PTE 16, TOEFL iBT 11, Year 12 11, Canadian secondary 8, Cambridge 5, Bachelor GPA 5, NCEA L3 2, University Entrance 1). Year 12 fell from 96 to 11 readings per 200 to 240 pages.
  - Precision, 16 readings read by eye: numeric IELTS and ATAR readings are right and their quotes are on the page. Still wrong in some cases: a value taken from another test or programme on a table row collapsed to one line (a PTE reading taken beside LANGUAGECERT scores; a Year 12 value of 50 that belongs to a foundation course; a Canadian average beside an NCUK point score). Shadow only; no promotion (needs a Layer 4 and `catalogue.*` writer under the existing gates and a second sign-off).
- **s830 (diagnosis, read only; no code or gate change).** Live, 20 Nov: 2,562 pending = 2,483 course first reads + 73 matrix first runs + 6 matrix changes. By the latest stored machine check: completeness gate 1,834; audit sample 491; all rows held 102; matrix first run 73; no stored page bound 37; page identity 19; matrix change 6 (S753 on 19 Nov: gate 1,892, audit sample 492; the 18 and 1 difference are items decided or re-read since).
  - A sample of 160 gate-held items was run through `security.course_entry_gate_v1` (rolled back): 133 incomplete. **Not truncation:** 114 of 133 hold because the reader dropped printed requirements no waiting row covers (167 dropped: minimum grade 134, prior qualification 90, portfolio or interview 26, subject prerequisite 11, work experience 5, general note 14; reasons quote_not_on_page about half, score_without_basis about a third, low_confidence 4); 16 are a shared stored page; 6 had rows cut at the row limit; the rest are domestic-route or not-a-requirement rows that "Approve except" (machine except mode) already handles.
  - So the gate is working: the readings the AI reader proposed did not quote the page verbatim, or gave a score with no basis. The fix is a new read with verbatim quotes (the S744 row chunker with a qualified model, AER v2, still paused, or the deterministic reader once it has a promotion path), not a looser gate. Left alone: S677 and the 6 matrix changes (Platform Admin).
- **s831 (Pilot #1418, recorded before merge; repo-first).** Migration `20261120130000` (dry-run md5 `a7ad6ac9`): `security.layer4_aer_hold_base_v1`, `security.layer4_aer_hold_reasons_v1` (revoked from public, anon, authenticated, read only) and one new branch in `public.admin_layer4_aer_queue` (`{hold_reasons: true}`; live definition md5 `800198d6` checked first; no new public function, table or view; G3 75 and 48). Rolled-back reads: summary 92 ms, list 108 ms; total 2,562 equals Layer 4. UI: Layer 4 › Inbox › Course entry first read › "Why items are held (N pending)" (reason, count, Show items, Show the audit sample) opens the existing Source quote drawer, which now has four rule checks (exact quotes, page identity, completeness gate, no overwrite: checked again on approval); decisions stay in the Inbox card (Approve, Approve except, Reject, each with a reason). No "Approve the verified batch" button. Not built: highlighted full stored-page text (no read of the stored text from the browser exists; the drawer shows the verbatim quotes kept from the stored page and links the stored copy). No release version bump and no SOP edit here (S1-Build owns v2.16.x and SOP 2.78); both are owed at the next bump.
- **Open for a person or the Platform Admin:** S677, the 6 matrix changes, promotion path and second sign-off for deterministic readings, a larger `batch.aer_det_read`, deleting branch `cf247-s676-probe`.

## 20 Nov 2026 12:50 AEDT — S1-UX: s823 to s827 rebased on main after PR 1411, migration renumbered to `20261120140000`; handed off (read-only session; not merged, not live)

**Trigger:** Platform Admin 20 Nov 2026 10:31, 10:46, 11:24 and 12:35 AEDT (s817 to s821 are S1-RM-Design's, merged as PR 1411, v2.16.66).

**Built and tested (Pilot branch on `main` `3279126`; v2.16.67, package 0.1.489):**
- **s823, migration `20261120140000`** (not `20261120130000`, which S1-AER's open #1418 holds): Platform Health and the top-bar health dot read one stored row (`pipeline.ops_pulse_snapshot`, job `ops-pulse-refresh` every 5 minutes) instead of read-time counts of `pipeline.jobs`, evidence, Layer 2 attempts, Layer 3 interpretations and scholarships; live fallback after `ops.pulse_max_age_minutes` (15). A run of idle worker calls updates one `pipeline.mode_outcome_ledger` row (`telemetry.idle_collapse_minutes`, 15) instead of an insert and two updates per call. No new public object (G3 75/48 asserted before and after); md5- and fragment-guarded edits (no merged migration since 3 Nov touched either function); rolled-back post-checks.
- **s824** Dashboard: five KPI cards with icons, AU/NZ/CA completeness bars, Active failures (operators); no pipeline or telemetry read for rank 1–2. **s825** 4-stage pipeline board under the s817 summary. **s826** Layer 4 Inbox: Waiting, grouped by rule (left panel; reads and decides nothing; PR 1411's card and bar untouched). **s827** ? help drawer on Dashboard, Platform Health, Layer 4 Review, Courses and Providers.
- **Tests (US$0):** s823–s827 spec 9 of 9; with PR 1411's specs 31 of 31; affected suite 972 passed, 1 failed (also fails on unmodified main: catalogue course description "Show all"), 1 flaky (s227 Approve except; 9 of 9 alone). Release contract, UI tokens, CSS classes, build: PASS.
- **Parity at hand-off (12:40):** live 2,215 rows, head `20261120121100` = Pilot main. #1419 (S1-Build) carries `20261120117000`, below the live head.
- **Design record:** `docs/platform/2026-11-20-s823-s827-ops-pulse-dashboard-conveyor-rule-groups-help.md`.

**Not done, stated plainly:** no push from this session (its `GH_TOKEN` is invalid), so no PR, merge, dry run, live apply, live read-back, signed-in check, Drive `Monitoring` row or workbook rebuild.

**Next executable action:**
- S1-RM-Design or S1-Build: merge this admin record first, then apply `coursefinder-pilot-s823-s827-v2.patch`, green CI, rolled-back dry run, merge, read back, signed-in check, Drive `Monitoring` row (45 minutes, engagement `20261120T125000+1100-claude-rm0-s1ux-s823-s827-ops-pulse-dashboard-board-handoff-7d1e`).

## 20 Nov 2026 13:40 AEDT — S1-UX s823 to s827 live and read back (applied by S1-RM-Design: Pilot #1420 `d219e7d7b`, v2.16.67; admin #686 `546f165e`)

**Done (S1-RM-Design for S1-UX, which has no GitHub write access):**
- **Pre-flight (13:08, rolled-back dry-run workflow):** live 2,217 rows, head `20261120130000`, 1-to-1 with Pilot main (today's 21 versions match, including #1419's `20261120117000`); nothing at or above `20261120140000`; v2.16.67 free; no open PRs; `public.svc_worker_report_v1` live md5 `b110a648…` = the migration's guard.
- **Admin first:** #686 merged (`546f165e`): S1-UX's admin patch v2 (`git am -3`, clean), plus the same runsheet entry in the change-control document (the patch wrote `FOLLOW-UPS.md` in its place; both kept) and the workbook rebuilt from the CSV.
- **Pilot #1420 merged (`d219e7d7b`):** S1-UX's two commits (`git am -3`; `Layer4Inbox.jsx` merged with #1418 automatically), plus one S1-RM-Design commit: the `?` help on the s820 hold banner (the action bar untouched), and in the migration `security.worker_idle_collapse_v1`'s body delimited `$function$` (was `$f$`) so spec s42 (housekeeping) reads its two runtime `delete` lines as the function's, not the migration's; no behaviour change. CI 20 of 20 green.
- **Dry run (rolled back, md5 `b9db78b4`):** every post-check passed; first rebuild 1,405 ms with no errors; four stages (Page Capture warning, the others ok); Layer 4 waiting 5,718; completeness AU 68.0%, NZ 40.1%, CA 52.1%; job scheduled; G3 75/48, no drift.
- **Live read-back (13:32, dry-run workflow only):** 2,218 rows, head `20261120140000`, history md5 `b9db78b4` = file; `pipeline.ops_pulse_snapshot` refreshed 115 s before the read (build 3,768 ms, no errors); `ops-pulse-refresh` active, `*/5 * * * *`, 13:30 run succeeded; settings `ops.pulse_max_age_minutes` 15 and `telemetry.idle_collapse_minutes` 15; 9 idle ledger rows in 30 minutes carry `idle_polls` (largest 32), 16 idle runs open; G3 75/48, no drift; manual locks 7,585. Spend US$0.
- **Signed in (PIM Admin v2.16.67, Platform Admin):** Platform Health shows the 4-stage board under the s817 summary (stage 2 amber, others green; stored figures from 13:30); the Dashboard shows five cards with five icons, AU 68%, NZ 40%, CA 52% bars and Active failures (two Page Capture checks); Layer 4 › Inbox › University description shows "Waiting, grouped by rule" (Waiting for the machine check 16, The page changed after it was read 9); `?` is on Dashboard, Platform Health, Layer 4 Review, Courses and Providers, opens three steps with a link to `#platform-guide`, and Escape closes it; every description hold banner carries its `?`. `/.well-known/security.txt` read live: 200, `text/plain; charset=utf-8` (the s811 check, now closed).

**Not done, stated plainly:**
- The Viewer view of the Dashboard (search only, no pipeline read) was not checked signed in: there is no Viewer account in this browser. It is covered by the mocked spec (s823-s827) only.
- A call that finds nothing because a budget is held is folded into the running idle row, keeping the first idle call's outcome and hold reason (telemetry only).
- Observed, not caused by this release: `public.admin_course_description_queue` (Layer 4 course descriptions) took 36.9 s (summary) and 14.8 s (items) in a rolled-back read at 13:34, past the app role's 8 s limit, so the Inbox logs two HTTP 500s. Neither #1411 nor #1420 touches it; it is S1-Courses' queue.

**Next executable action:**
- S1-Courses: `admin_course_description_queue` time-outs. S1-UX: the next item on its list (stage meters as rates, Catalogue keyset paging).

**S1-AER, 20 Nov 2026 14:50 AEDT: s832 recorded before merge: reader `aer-det-v1.2` collapsed-row guard (Pilot branch `cf247-s832-aer-det-v12`, code only, no migration; live head stays `20261120140000`)**

Platform Admin 20 Nov 2026 14:25 AEDT: do not run the full sweep; keep the reader shadow only and `batch.aer_det_read` at 20; leave S677 and the 6 matrix changes for the Platform Admin; branch `cf247-s676-probe` to be deleted. Pre-flight: Pilot #1420 (v2.16.67, `20261120140000`, 2,218 rows) and admin #688 are in; both repositories rebased on their latest `origin/main` before any edit.
- **Reader `aer-det-v1.2` (shadow only, pure module, no model, fetch or write).** A collapsed table line is skipped rather than guessed: two or more distinct degree titles, a table separator beside two or more tests or qualifications, or three or more tests or qualifications on a line over 200 characters. A value is never taken across another test or qualification: a test reading takes its value only from words that name that test (a PTE score beside LANGUAGECERT, a Canadian average beside an NCUK point score or an IB Diploma, and a Year 12 value beside a foundation course are no longer read), and a quote for NCEA, University Entrance or Year 12 stops before the next qualification. Every quote is still a substring of the page text.
- **Tests (US$0):** `cf-247-s828-aer-det-reader-contract` is now 9 tests, all passing locally (the new one covers the three observed mis-assignments, the table-line skip and the quote cut). The s120 governance and s42 housekeeping specs pass. TEST-REGISTER patched on four lines (regression total 3,970; local suite 4,006; s828 row 9 / 0) because a full regeneration from a shallow clone rewrites the PR column of hundreds of unrelated rows.
- **Not changed:** no migration, no public function, table or view (G3 75 functions / 48 relations); `batch.aer_det_read` stays 20; no promotion; Decision 276 and every gate untouched; manual locks 7,585; AI and Firecrawl spend US$0.
- **Next:** merge this admin record first, then Pilot on green CI (code only: `deploy-on-merge` redeploys the worker), then one 200-page shadow batch at 6 calls and a 20-row spot check, then the closing block.


**S1-AER, 20 Nov 2026 15:20 AEDT: s832 closed: reader `aer-det-v1.2` live in shadow (Pilot #1421 `518d926c`, admin #689 `bb079cf8`); 200-page verification batch and 20-row check; parked**

- **Merged in order.** Admin #689 (record before merge) merged first, then Pilot #1421 on green CI (20 of 20 checks; code only, no migration, so no dry run was needed); `deploy-on-merge` redeployed the worker and succeeded. Live migration head unchanged at `20261120140000`.
- **Verification batch (workflow run 44669957261, US$0, 6 calls at once).** 200 pages sent, 200 recorded, 211 s. Result at v1.2: 128 shadow readings on 65 courses (IELTS 72, ATAR 18, Year 12 9, PTE 8, Canadian secondary 8, TOEFL iBT 7, NCEA L3 2, Bachelor GPA 2, Cambridge 1, University Entrance 1). The same courses held 158 readings at v1.1, so 30 were dropped (ATAR 7, IELTS 6, PTE 6, Year 12 4, Cambridge 4, TOEFL 3, GPA 2): the price of skipping collapsed lines. Year 12 is 9 (was 11 at v1.1).
- **Spot check (21 readings, read by eye against the quote, rolled-back read only).** 18 right, 2 wrong, 1 not verifiable. None of the three earlier collapsed-row mis-assignments (a PTE score beside LANGUAGECERT, a Year 12 value from a foundation course, a Canadian average beside an NCUK score) appeared. The two wrong: University Entrance credits read as 3 from "42 level 3 credits" (should be 42), and a PTE score of 58 read from "58.5" (decimal cut). The one not verifiable: a Year 12 "aggregate score of 8" (its page was not read). One flattened table line of spelled-out tests (Cambridge 169) gave the right value. Still shadow only; not promotable.
- **Follow-ups for the next reader version (not built; one batch was the instruction):** a credit count must not be taken from "level 3 credits"; a decimal score is not read as its whole part; spelled-out test names (International English Language Testing System, Pearson Test of English, Occupational English Test) count as tests for the collapsed-line rule.
- **Decisions applied (Platform Admin 14:25):** full sweep not run (200 + 440 earlier pages read of 19,983); `aer-det` shadow only; `batch.aer_det_read` stays 20; S677 and the 6 matrix changes untouched; no promotion to `catalogue.*`.
- **Branch `cf247-s676-probe`:** probes are finished, but deleting it is refused through this session's proxy (HTTP 403). It still exists on GitHub; a person deletes it.
- **Not re-read in this block:** G3 (75 functions, 48 relations) and the manual-lock count (7,585) were not read live again; no migration, function, table or view was added. AI and Firecrawl spend: US$0.
- **Gaps (as read 20 Nov):** Table 1, verified source-backed (a stored page is bound; no active entry rule): AU 12,226, NZ 4,522, CA 3,235, total 19,983. Table 2, no source available yet (*No source available — do not quote as verified*): AU 4,705, NZ 1,578, CA 579, total 6,862.
- **Open for a person:** authorise S677; decide the 6 matrix changes; sign off a promotion path for deterministic readings; raise `batch.aer_det_read`; delete branch `cf247-s676-probe`.

**S1-AER, 20 Nov 2026 15:22 AEDT: s834 and s835 recorded before merge: reader `aer-det-v1.3` (academic only) and automated deterministic AER promotion with a scheduled sweep (Pilot #1423, migration `20261120160000`)**

Platform Admin 20 Nov 2026 15:08 AEDT ("Correction & Scope Clarification"): AER is strictly separate from English. No English test (IELTS, TOEFL iBT, PTE Academic, OET, CELPIP, Cambridge English) is read or written in S1-AER or the `aer-det` pipeline; English stays in its own pipeline (`english_group_match_v1`). Pre-flight: both repositories rebased on the latest `origin/main` (Pilot `98656714`, admin `f4ee69f5`); no open pull request at pre-flight; spec numbers s834 and s835 claimed above every merged spec (s833 is S1-Courses'); migration `20261120160000` is above the newest migration in the repository (`20261120143000`); `cf247-s676-probe` left untouched.

- **s834, reader `aer-det-v1.3` (`aer-det-reader.ts`, no model, no fetch, no write).** The six English rules are removed; an English test name beside a number is still never taken as an academic value. New academic rules: IB Diploma points, A-level grades, Indian board average (CBSE, CISCE, ISC, State Boards). Fixed: a credit count is never the level number ("42 level 3 credits" reads 42; "level 3 credits" alone reads nothing). Year 12 now needs a stated threshold (a score, mark, rank, aggregate, average or percentage with its number, or a grade "or higher"); boilerplate such as "levels of achievement in particular Year 12 subjects" and "Units 3 and 4" read nothing. The v1.2 collapsed-row guard and the proximity guard are kept. The worker mode `aer_det_read` also returns the other requirement lines the reader does not read (prerequisite, portfolio, interview, work experience, bridging), up to 6 a page. Spec `cf-247-s828-aer-det-reader-contract` now has 11 tests (it replaces the English tests; the two retired tests are in the retirement log).
- **s835, promotion and sweep (migration `20261120160000`, replaces nothing, retires nothing; the s815 shadow writer and its two tables are left in place, nothing is dropped).** New objects, all in schemas `pipeline` and `security` (G3 stays 75 functions and 48 relations, checked in the migration's post-check): tables `pipeline.aer_det_academic_pages`, `pipeline.aer_det_academic_readings` (nine academic keys only, never English) and `pipeline.aer_det_sweep_calls`; functions `security.aer_det_record_v2`, `security.aer_det_propose_v1` and `security.aer_det_sweep_v1`; job `aer-det-sweep` every 5 minutes (catalogued, registered; its command holds no number).
- **How a reading is promoted, with every gate unchanged.** The proposer writes ordinary `proposed` rows in `catalogue.course_entry_requirements` (provenance reader `aer_det`) and one Layer 4 `course_entry_first_read` item per course. It never activates anything, never writes `catalogue.*` as active and never touches `search.course_documents`. The existing machine rule `aer-machine-v1` (job `aer-machine-admission`, 300 a day) then admits it only when every check passes: manual lock (the 7,585 locks), no active rows (no-overwrite), earlier rejection, page identity, verbatim quote of at least 8 characters, confidence at least 0.8, the E13 completeness gate, and the 5% audit sample. Otherwise a person decides in Layer 4. A page that prints a requirement line the reader does not read carries it as a dropped requirement (reason `det_other_requirement`, now a hold reason in `entry.gate_hold_reasons`), so the gate holds the read for a person. A row that only mentions a value (not a stated minimum) is written at confidence 0.7, below the machine rule's 0.8, so a person decides it. A locked, hidden, already-ruled, already-read, other-programme, shared-page or over-row-limit page is skipped and its outcome recorded.
- **Sweep and settings (G2).** `batch.aer_det_read` raised from 20 to 40. New settings, section Admission checks: `aer_det.sweep_on` 1, `sweep_calls` 3 a tick, `sweep_max_open` 4, `call_lost_minutes` 15, `propose_on` 1, `propose_max_pending` 400, `propose_per_run` 50, `confidence_stated` 0.9, `confidence_mentioned` 0.7. At 3 calls of 40 pages every 5 minutes the sweep reads about 1,440 pages an hour, so the remaining stored pages (19,983 courses at the last read) drain in roughly 14 hours while Layer 4 is held at 400 waiting items by `propose_max_pending`. The sweep sends worker calls through `pipeline.svc_pilot_submit_nonce`, collects answers from `net._http_response` and refuses a worker still on an older reader version. No AI spend, no Firecrawl spend (US$0).
- **Validation.** Local: s828 11 of 11, s835 8 of 8, s32 (settings), s42, s57 and s120 pass (the s32 browser test needs Chromium, which this session does not have; CI runs it). Rolled-back live dry run through the non-interactive workflow (run 44673620791, md5 `8e7ace4d`) passed; its post-check runs a synthetic proposal inside a rolled-back block, proves the uncovered-prerequisite case is not machine-admitted, and confirms G3 75/48. 3,395 courses were eligible for that synthetic read. No interactive `execute_sql` was used.
- **Held for a person:** S677 (`security.aer_machine_admit_v1`) and the 6 entry-matrix changes are untouched; the AI and Boost `aer_entry` readers stay shadow only (Decision 276). Branch `cf247-s676-probe` is untouched for the Platform Admin to delete.
- **Next:** merge this admin record, then Pilot #1423 on green CI; read back the deployed worker, the job and the first proposals; an initial verification batch (academic keys only, zero English rows); closing records, Drive sync and the two gap tables.

**S1-Structure-Outcomes, 20 Nov 2026 16:05 AEDT: s860 and s861 recorded before merge: deterministic course structure reader `struct-det-v1.0` (duration, study load, delivery mode), automated promotion and a scheduled sweep at $0 (Pilot #1427, migration `20261120163500`)**

Platform Admin 20 Nov 2026 15:19 and 15:22 AEDT (chat S1-Structure-Outcomes): close course duration, study load, delivery mode and regulatory code gaps from stored pages and registers at $0 AI and $0 Firecrawl; lane block specs s860 to s869, migrations `20261120160000` to `20261120162900`. Pre-flight: no open pull requests in either repository at 15:24 except S1-AER's Pilot #1423, which holds `20261120160000` (the first slot of this block), and #1423 merged at 15:49 renumbered to `20261120163000`, which put the live head above this whole block; this change is therefore numbered `20261120163500`, strictly above the live head (the parity rule outranks the lane block; recorded here). The first PR, #1426, was closed unmerged and replaced by #1427 after the rebase; s860 to s869 were unused in the test register.

- **Baseline, read live 20 Nov 15:26 AEDT** (rolled-back dry-run workflow, run 44674367539; `search.course_documents` joined to `catalogue.courses`):

| Field (courses) | AU 24,013 | NZ 6,514 | CA 3,814 |
|---|---:|---:|---:|
| No duration | 0 | 4,080 (647 with a stored page) | 2,458 (1,151) |
| No study load | 24 | 4,186 (690) | 2,368 (977) |
| No study mode (search `delivery_modes`) | 20 | 3,386 (262) | 1,204 (152) |
| Regulatory course code | CRICOS 24,013 | NZQA 6,514 | provider DLI 3,814; PGWP 0 |

  AU structure and CRICOS codes are already complete from the CRICOS register (duration in weeks, Decision B7 study load); the gaps are in NZ and CA. Manual locks 7,585.
- **s860, reader `struct-det-v1.0`** (Pilot `supabase/functions/coverage-sweep/struct-det-reader.ts`, worker mode `struct_det_read`, coverage-sweep worker v1.0.33). No model, no fetch, no write. It keeps the page's own blocks as lines (a label on its own line takes the next line as its value) and reads: duration (years, months, weeks or semesters, the units the catalogue already holds) from a labelled line or a sentence that ties a length to full-time study; study load (full_time, part_time, both); delivery mode (on_campus, online, blended, on_campus_and_online) from labelled lines only. Never read as a value: a range, a maximum or minimum, a part-time-only length, trimester, term or credit-point lengths, a line about international or domestic students or a visa, "flexible". A line with two or more qualification titles, or a table separator beside two or more lengths, is marked collapsed and never admitted, so a length printed for one course of a table is never given to another.
- **s861, promotion and sweep** (migration `20261120163500`; replaces nothing, retires nothing). New objects, all in `pipeline` and `security` (G3 stays 75 functions and 48 relations, checked before and after inside the migration): tables `pipeline.struct_det_pages`, `struct_det_readings`, `struct_det_outcomes` (every decision, with the value before and after: the audit and rollback trail), `struct_det_sweep_calls`; functions `security.struct_det_record_v1`, `struct_det_promote_v1`, `struct_det_sweep_v1`; job `struct-det-sweep` every 5 minutes (catalogued, G1; command holds no number, G2).
- **Gates.** A value is admitted only when every non-collapsed reading of the field on the page agrees, the field is empty (no overwrite of any source), no manual lock covers it (`duration`, `duration_value`, `duration_unit`, `study_load*`, `delivery_mode`, `delivery`, `all`), the page is the course's current bound page, its identity admits course facts (the same identity set as course descriptions), the provider is not hidden, and no other course is bound to the same page. Two different values, or a shared page, go to Layer 4 (`pipeline.layer4_review_items`, field `duration`, `study_load` or `delivery_mode`, reader `struct_det`) with a plain reason, capped at 200 waiting. Study loads are written with `study_load_source` `provider_page` and the page's evidence id. Each admitted course is queued in `search.course_refresh_requests` (existing job `search-course-refresh`).
- **Settings (G2, Settings › Pipeline settings, Admission checks):** `struct_det.sweep_on` 1, `sweep_calls` 2, `sweep_max_open` 3, `pages_per_call` 40, `call_lost_minutes` 15, `promote_on` 1, `promote_per_run` 150, `admit_stated` 1, `layer4_max_pending` 200. About 960 pages an hour; the stored pages of every NZ and CA gap course (about 2,600) are read in under three hours.
- **Validation.** Local: s860 8 of 8, s861 6 of 6, s32 contract tests, s42, s57 and s120 pass (the s32 browser test needs Chromium, not in this session; CI runs it). Rolled-back live dry runs (runs 44676017054, 44676140582 and, after the renumber, 44677214117) passed: one full sweep tick in 29 to 103 ms (2 calls of 40 pages queued and rolled back; under the 300 ms target), and the post-check's synthetic promotion admitted the agreed duration, sent two disagreeing delivery modes to Layer 4, queued the search rebuild and rolled back. Spend US$0.
- **Not admitted, by design (no invented values):** NZQF level and credits (6,267 NZ titles carry "(Level N)" from the NZQA register, but no catalogue field holds a level or credits; a Platform Admin decision); PGWP eligibility (no register of eligible programmes is held, 0 course registrations); trimester and credit-point lengths (not a catalogue unit).
- **Next:** merge this admin record, then Pilot #1427 on green CI; read back the deployed worker, the job and the first admissions; closing records, Drive sync and the two gap tables.

**S1-AER, 20 Nov 2026 16:25 AEDT: s834 and s835 closed: reader `aer-det-v1.3` and the deterministic AER sweep live (Pilot #1423 `1827dc0c`, admin #693 `f7d576f0`); correction: migration is `20261120163000`**

- **Correction to the 15:22 block.** The migration was first numbered `20261120160000`, which the 15:25 roster gives to S1-Structure-Outcomes (160000 to 162900). Before merge it was renumbered to `20261120163000` (S1-AER window: at or above 163000); the rolled-back dry run was repeated on that file and passed (md5 `083d6ba4`, no other dry run active when it started). Admin #693 still names `160000`; the correct number is `20261120163000`. Spec numbers stay s834 and s835.
- **Merged in order.** Admin #693 first, then Pilot #1423 on green CI (17 of 17 checks) and a passing rolled-back dry run; `deploy-on-merge` succeeded. Live migration head after the merge: `20261120163000` (S1-Structure-Outcomes' `20261120163500` follows it).
- **Live read-back (rolled-back probe, read only, 16:20).** Job `aer-det-sweep` active, 2 ticks run. 3 worker calls sent and collected, all `ok`; 120 pages read; 15 academic readings: ATAR 15, Canadian secondary 8, Year 12 7, NCEA Level 3 2, Indian boards 2, bachelor GPA 2, IB 1 (the counts are per page and key, not per course); **no English key exists in the tables** (the check constraint allows none). Outcomes of the 120 pages: 107 no academic reading, 3 proposed, 6 skipped because the course already held rows, 4 not admitted (page proof not admitted for entry requirements). 3 Layer 4 items waiting (reader `aer_det`) with 12 proposed rows; **0 rows active**: nothing is admitted until `aer-machine-admission` (at :24 and :54) or a person decides. Manual locks 7,585, unchanged. G3 was checked by the migration's post-check at apply time (75 functions, 48 relations); no public object was added.
- **Throughput and spend.** About 120 pages a tick (3 calls of 40), so roughly 1,400 pages an hour; the sweep drains the remaining stored pages over about 14 hours without further input, and holds new proposals at 400 waiting Layer 4 items. AI and Firecrawl spend: US$0.
- **Not done, by instruction:** S677 and the 6 entry-matrix changes untouched; AI and Boost `aer_entry` readers remain shadow only (Decision 276); branch `cf247-s676-probe` left for the Platform Admin to delete (deletion is refused through this session's proxy).
- **Yield note.** 107 of 120 pages state no academic threshold in a form the reader accepts (it needs an explicit number or grade); this is the cost of skipping vague boilerplate, as instructed. Courses whose pages state their rules only in tables are for the table reader (S2 lanes), not this path.
- **Gaps (as read 20 Nov, no row activated since).** Table 1, verified source-backed (a stored page is bound; no active entry rule): AU 12,226, NZ 4,522, CA 3,235, total 19,983 (120 of these pages now read, 3 proposed). Table 2, no source available yet (*No source available — do not quote as verified*): AU 4,705, NZ 1,578, CA 579, total 6,862.
- **Open for a person:** authorise S677; decide the 6 matrix changes; watch the machine rule's first admissions (the next :24 and :54 runs) and Layer 4 volume; delete branch `cf247-s676-probe`.

**S1-ELR, 20 Nov 2026 16:55 AEDT: s840 to s842 recorded before merge: admission-rule-runner-b time-outs fixed, deterministic English requirement reader `elr-det-v1.0`, gated automatic promotion and a scheduled sweep at $0 (Pilot #1428, migration `20261120170000`)**

The Platform Admin's requests came at 20 Nov 2026 15:10 and 15:21 AEDT (chat S1-ELR). The scope is English language requirements only, with no AER. The lane block is specs s840 to s849, migrations 20261120150000 to 20261120152900 and dry-run slot 1.

Pre-flight:
- Both repositories were rebased on `origin/main`. s840 to s842 are claimed and unused.
- The migration was written in the slot, then renumbered `20261120170000` to stay strictly above the live head (`20261120163000`, S1-AER) and the open lanes' files (163500, 165000, 165100, 145000).
- Every dry run waited for an empty shared queue.

- **Baseline, read live 15:12 AEDT** (rolled-back dry-run workflow, read only). The head was `20261120143000` with 2,219 rows. G3 75/48, 7,585 manual locks.

| Country | Active | With English requirement | Table 1: gap, stored page bound | Table 2: gap, no stored page |
|---|---:|---:|---:|---:|
| AU | 25,703 | 16,427 | 3,780 | 5,496 |
| NZ | 6,514 | 2,392 | 1,094 | 3,028 |
| CA | 3,814 | 2,017 | 1,341 | 456 |
| Total | 36,031 | 20,836 | 6,215 (6,151 read) | 8,980 |

- **s840, runner-b.** There were 2 statement time-outs in 24 h. The context was `english_group_match_v1` inside `security.provider_english_plan_v1`, and rule `provider-english-defaults` ran at a median of 52 s and a maximum of 119 s against a 122 s budget.
  - Cause: the match was called once per course, and again per course × other policy. It cannot be inlined (`SET search_path`), and none of the 180 approved policies has a binding, so every call returned `[]`.
  - Fix: the calls now run only when a binding exists, and the title key is written out in place. The md5-guarded live text was replaced. The plans of the 8 largest providers are equal row for row before and after.
  - Same-transaction timings: 230 to 5,649 ms before, 151 to 676 ms after (one run reached 2,223 ms under other lanes' load). EXPLAIN on the largest provider: 176 ms.
- **s841, reader `elr-det-v1.0`** (worker mode `elr_det_read`, read only). It reads IELTS (overall and bands), TOEFL iBT (total and sections), PTE Academic (decimals kept), OET (grades or scores), CELPIP and Cambridge C1/C2, by acronym or spelled-out name. A collapsed multi-programme line is skipped. Pathway and foundation quotes are flagged and never promoted.
- **s842, promotion and sweep.** The single writer is `security.elr_det_record_v1`. Its gates:
  - the page is still bound and read;
  - its identity is allowed for English;
  - the page is not refused, and the course is not Layer 4 blocked;
  - the course has no active requirement (insert only), no lock and no pending review;
  - every reading of a test agrees, states a minimum and has its value in its own quote, and is complete.

  Conflicts, shared pages and the 5% audit sample go to Layer 4 (`course_english`). Promoted courses are refreshed in `search.course_documents`. The job `elr-det-sweep` runs every 5 minutes: it reads pg_net answers back and sends the next keyset batch of 200 pages, 25 a call, at most 8 calls open. That drains about 6,151 pages in roughly 2.6 hours. There are seven settings, the workflow is `elr-det-read.yml`, and the status read is `security.elr_det_status_v1()`.
- **Validation:**
  - Specs: s841 7/7, s840 to s842 6/6; s42, s57, s120, s616 and s828 pass. The s32 browser test needs Chromium, which CI runs.
  - The rolled-back live dry run of the final file passed.
  - Synthetic writer run on 40 real gap pages, rolled back: 29 promoted, 9 to Layer 4, 2 held, search refreshed.
  - G1, G2 and G3 kept; US$0 spend; no interactive `execute_sql`.
- **Design:** `docs/platform/2026-11-20-s840-s842-elr-deterministic-reader-and-sweep.md`. The decisions are in the design reference under "S1-ELR design decisions".
- **Next:** merge this admin record, then Pilot #1428 on green CI. Then read back the worker version, the job, the first ticks, promotions and Layer 4 items. After that: closing records, the Drive Monitoring row, and Table 1 and Table 2 re-measured.

**S1-Structure-Outcomes, 20 Nov 2026 16:55 AEDT: s861 live and read back (Pilot #1427 `24317d50`); s862 recorded before merge: shared-page check indexed (Pilot #1430, migration `20261120172000`)**

- **Merged in order.** Admin #696 (`9526ea2c`) first, then Pilot #1427 on green CI (16 of 16 checks; the PR dry-run job is label-only and the manual rolled-back dry run of the same file, run 44677214117, passed). Deploy on merge applied `20261120163500` (history md5 `905d8d23` = file) and deployed coverage-sweep v1.0.33. Live head `20261120163500`, 2,222 rows; G3 75/48, 0 drift; locks 7,585; spend US$0.
- **First live results (16:42 AEDT, three ticks):** 160 stored pages read (4 calls ok), 73 decided, 87 with no reading. Admitted: duration 26 (NZ 13, CA 13), study load 4 (NZ 1, CA 3). Held: duration has a value 20, study load 7, delivery mode 37 (the campus already holds a mode); identity not admitted 3; Layer 4: 3 duration conflicts and 1 shared page (4 items, plain reasons). Readings: duration 78 (5 collapsed, never admitted), study load 14, delivery mode 42 (1 collapsed), 19 notes (ranges, credits, part-time only).
- **Found:** ticks took 6.6 s and 9.8 s. The promoter's shared-page check took 2,842 ms for 160 pages: its "same stored copy OR same address" test could not use an index (23,989 bound pages scanned per page).
- **s862 (migration `20261120172000`, above every open pull request: #1425 holds `20261120165000` and `165100`, #1428 `20261120170000`).** A partial index on the bound pages' evidence id and the test written as two EXISTS (stored copy; address on the existing bound-address index). Guarded by the live md5 of `security.struct_det_promote_v1` (`bf0bc0d6`); its post-check proves the same shared pages and fails above 300 ms. Rolled-back dry run passed (run 44683159633). No worker, setting or job change.
- **Lane note (S1-Fees-Intakes, 16:33 AEDT):** the request to bump this lane's worker to v1.0.34 arrived after Pilot #1427 had merged with coverage-sweep v1.0.33. Pilot #1425 (S1-Fees-Intakes) must therefore rebase on main and take v1.0.34; its migrations (`20261120165000`, `165100`) are already above this lane's.
- **Next:** merge this record, then Pilot #1430 on green CI; read back the tick time; final gap read and the two gap tables; Drive sync.

**S1-Structure-Outcomes, 20 Nov 2026 17:15 AEDT: s860 to s862 closed: course structure reader live, sweep draining at $0 (Pilot #1427 `24317d50`, #1430 `720d6963`; admin #696, #701)**

- **Merged in order:** admin #701 (`cae00ed1`) first, then Pilot #1430 on green CI (15 of 15; rolled-back dry run 44683159633 passed). Live head `20261120172000`, 2,224 rows; index `coverage_course_pages_bound_evidence_idx` present; G3 75/48, 0 drift; locks 7,585; spend US$0 (no model, no Firecrawl).
- **Admitted by 17:05 AEDT** (seven ticks, 400 stored pages read): duration 77, study load 7, delivery mode 1 (NZ and CA; AU had no structure gap with a stored page). 13 items in Layer 4 (conflicting durations and shared pages, each with a plain reason). 2,082 stored pages still to read, about two hours at the current pace.
- **Tick time:** the promoter takes 25 ms and the shared-page check is indexed (s862). The tick still runs for 8.7 to 10.9 s, because a tick sends up to 80 pages and parses up to 80 answers. The send query alone took up to 1.7 s when it was measured over the whole backlog. One tick at 16:56 failed with "job startup timeout": pg_cron could not start its worker in time. That is platform contention, not this job; the next tick ran normally. Next optimisation: cut the send query below 300 ms by marking the gap courses once rather than re-testing each tick.
- **Table 1 — Verified source-backed gaps** (a stored course page is bound, so the sweep reads it; 17:05 AEDT):

| Field | AU | NZ | CA |
|---|---:|---:|---:|
| Duration | 0 | 620 | 1,101 |
| Study load | 1 | 687 | 973 |
| Study mode | 3 | 262 | 151 |
| NZQF level and credits (register-backed, no catalogue field) | n/a | 6,267 titles state the level | n/a |

- **Table 2 — No source available yet** (no stored course page and no register value; *No source available — do not quote as verified*):

| Field | AU | NZ | CA |
|---|---:|---:|---:|
| Duration | 0 | 3,433 | 1,307 |
| Study load | 23 | 3,496 | 1,391 |
| Study mode | 17 | 3,124 | 1,052 |
| PGWP eligibility (no register of eligible programmes held) | n/a | n/a | 3,814 |

- **Lane coordination:** Pilot #1427 merged with coverage-sweep v1.0.33 before the 16:33 S1-Fees-Intakes note arrived. Pilot #1425 should rebase on main and take worker v1.0.34. Its migrations (`20261120165000`, `165100`) are now below the live head (`20261120172000`), so they also need renumbering above it.
- **Open for a person:** (1) whether NZQF level and credits get a catalogue field (a design and API v3 decision); (2) a source for PGWP programme eligibility; (3) the 13 Layer 4 structure items (field codes `duration`, `study_load`, `delivery_mode`, reader `struct_det`). The dedicated Inbox card is a follow-up for the S1-RM-Design Layer 4 universal-card work.

**S1-ELR, 20 Nov 2026 17:20 AEDT: s840 to s843 closed: live and read back (Pilot #1428 `5873a131`, #1431 `27fa9f79`; admin #698 `67644eaf`)**

- **Deploy.** Pilot #1428 merged on green CI with the labelled dry run passing. `deploy-on-merge` applied migration `20261120170000` at about 16:57 AEDT (history md5 `b362663d` = file) and deployed `coverage-sweep` with mode `elr_det_read`. Pilot #1431 (s843, script only) fixed the workflow's status read: the status function is not granted to the read-only role, so the script now reads it through the owner connection.
- **Live read-back** (rolled-back probe, 17:17 AEDT):
  - Head `20261120172000`, 2,224 rows.
  - G3: 75 functions, 48 relations, no drift.
  - Manual locks: 7,585, unchanged.
  - Spend: AI and Firecrawl US$0.
  - Job `elr-det-sweep`: 5 of 5 runs succeeded, the longest 4.7 s (these include reading back 8 worker answers and the search refresh).
  - The claim query took 190 ms for 250 pages.
  - `admission-rule-runner-b`: 0 failures since the fix. `provider-english-defaults`: 40.8 s and 44.3 s after the fix (180 plans, about 0.24 s a plan), against 41 to 107 s in the 3 hours before.
- **First yield** (17:15 AEDT; about 1,200 pages sent, 1,000 read): 12 courses promoted (12 IELTS rows, `elr-det:` key), 5 to Layer 4 (conflict, shared page or audit sample), 985 held. The held reasons:
  - 979: the page states no English test requirement. Course pages mostly point to a central English page rather than printing the score.
  - 3: no reading passed every check.
  - 2: adapter-title identity not accepted for English.
  - 1: page refused.

  Nothing was written over an existing requirement or a lock.
- **Gaps, as read live 17:15 AEDT.** These are still draining; the sweep reads about 200 pages every 5 minutes.

| Country | Table 1: verified source-backed gaps (stored page bound) | Table 2: no source available yet |
|---|---:|---:|
| AU | 3,771 | 5,496 |
| NZ | 1,093 | 3,028 |
| CA | 1,341 | 456 |
| Total | 6,205 | 8,980 |

- **Finding for the next lane step:** the course-page route will clear only a small share of Table 1. The remaining value is on the providers' central English pages (the existing policy route, `provider_english_plan_v1`), which is a policy decision for the Platform Admin, not a reader change.
- **Housekeeping:** the temporary probe branches `cf247-s834-elr-det` and `cf247-s844-elr-probe` (never merged) could not be deleted through this session's proxy. The Platform Admin deletes them.
**S1-Fees-Intakes, 20 Nov 2026 15:48 AEDT: s850 to s852 recorded before merge: Fee reader (AI) unstuck; $0 deterministic fee, intake and deadline reader with gated promotion and a scheduled sweep (Pilot #1425, migrations `20261120165000` and `20261120165100`)**

Platform Admin 20 Nov 2026 15:11 and 15:22 AEDT (lane block s850 to s859, migrations `20261120153000` to `155900`, dry-run slot 2). Pre-flight: both repositories on the latest `origin/main` (Pilot `98656714`, admin `f7d576f`); live head `20261120143000`, 2,219 history rows; G3 75/48; manual locks 7,585. Every live read went through the rolled-back dry-run workflow on branch `cf247-s850-fees-probe` (no interactive `execute_sql`). Renumbered 20 Nov 2026 16:05 AEDT from `20261120153000` and `20261120153100` to `20261120165000` and `20261120165100`: S1-AER #1423 merged at 15:49 AEDT with `20261120163000`, so both files must sit above it (repo-first parity, merge check). An earlier probe branch, `cf247-s840-fees-probe`, was named before the lane block arrived. It holds only rolled-back probes and was never merged. The proxy refuses branch deletes, so the Platform Admin deletes it, along with `cf247-s850-fees-probe`.

- **Baseline (active, published courses, read 15:20 AEDT).** AU 24,013: international fee 24,013 (CRICOS registered totals; provider current tuition is the Fee reader's field), intakes 9,522 (39.7%), deadlines 53 (0.2%), stored page text 14,431. NZ 6,514: fee 1,491 (22.9%), intakes 2,221 (34.1%), deadlines 33 (0.5%), stored page text 1,800. CA 3,814: fee 732 (19.2%), intakes 1,688 (44.3%), deadlines 214 (5.6%), stored page text 2,118. Gaps with stored page text: fees NZ 1,087 and CA 1,477; intakes AU 7,087, NZ 565 and CA 733; deadlines AU 14,387, NZ 1,781 and CA 1,906.
- **Why the Fee reader (AI) stalled (s850).** This was a queue-state bug, not a lock, budget or batch limit. `pipeline.fee_reader_queue` held 6,290 done pages and one course-page item (created 17 Nov) in state `queued` with `attempts = 3` and no error. `public.svc_fee_ai_next` only hands out items with fewer than three tries, but the watchdog's waiting count counted every queued item. So Platform health showed "1 waiting and nothing finished since 20 Nov 01:41" ever since the real work ran out. The AI route was open (not held, US$0 spent today). Fix (migration `20261120165000`): the watchdog counts only claimable items (attempts < 3) and counts the rest as exhausted. `security.fee_reader_queue_settle_v1()` turns any item that has used its three tries (still queued, or a third lease that ran out) into failed every minute, through the s852 job, keeping the reason and recording a `read_failed` finding. There is no trigger on the queue table: the fee-reader job writes it every minute, and the first PR dry run of a trigger hit its lock (lock timeout). The one item found gets one more full try. The waiting count runs well under 300 ms (post-check).
- **s851, reader `fid-det-v1.0`** (`supabase/functions/coverage-sweep/fid-det-reader.ts`; worker v1.0.34 mode `fid_det_read`, read only; no model, no fetch, no write). It reads the international tuition fee (amount, AUD, NZD or CAD, basis per year, per semester, per unit or whole course, and the fee year printed beside the amount), the intake months (calendar months after a start word; trimester and semester labels are kept as labels), and the application closing date (one full date in the closing sentence, with an intake hint) or a rolling-admission statement. Every reading's quote is a sentence of the stored page, word for word. Domestic, CSP, application fee, deposit, living-cost, insurance and scholarship lines are never read as tuition.
- **s852, promotion and sweep** (migration `20261120165100`; replaces nothing, retires nothing, nothing dropped). New objects, all internal: tables `pipeline.fid_det_runs`, `fid_det_pages`, `fid_det_readings` and `fid_det_state`; functions `security.fid_det_batch_v1`, `fid_det_record_v1`, `fid_det_tick_v1` and `fid_det_status_v1`; watchdog row `fid_det`; job `fid-det-sweep` (every minute; it sends a batch every `fid.run_every_minutes`, 5). The batch is an indexed keyset over bound stored pages of courses in the Fee reader's scope (countries NZ, CA, AU; its provider types; published providers) that miss a fee, an intake or a deadline: 100 to 250 a batch (`fid.batch_size` 150), in calls of `fid.items_per_call` (30). The worker's reply is read back from `net._http_response`.
- **Gates (every value is admitted only when 100% verified).** The quote must be on the page. The page must still be the course's bound page, and the country identity rule must accept its proof for the field (tuition or intakes). The value must be complete: one yearly figure in the country currency, a fee year no older than last year; a calendar month; a full closing date in its closing clause, tied to one intake and inside that intake's window. Nothing may be held for the field (no overwrite), and no manual lock may be set (the table guard checks again). Fees and intakes go through the one governed write, `security.coverage_apply_course_v1`, which applies the currency, fee-floor and tuition-identity checks. A deadline fills only an empty deadline. A fee per semester, per unit or for the whole course, two yearly figures, a foreign currency or an old fee year goes to Layer 4 (`provider_current_tuition_validation`) with the reason in words, at most `fid.layer4_per_run` (20) a run. Rolling statements are recorded and write nothing. Search: the course source is approved for `provider_current_tuition` and `course_intake`, and one `search.refresh_requests` row is added.
- **Settings (G2, Pipeline settings › Fees and intakes):** `fid.sweep_on` 1, `fid.run_every_minutes` 5, `fid.batch_size` 150 (100 to 250), `fid.items_per_call` 30, `fid.reply_wait_minutes` 15, `fid.layer4_per_run` 20, `fid.deadline_past_days` 31, `fid.deadline_ahead_days` 550. AI spend: none (no model). Firecrawl: none.
- **Validation.** Local: s850 4/4, s851 6/6, s852 7/7, plus s42 and the specs that pin the worker version (updated to v1.0.34). The browser tests need Chromium, which this session does not have; CI runs them. Rolled-back rehearsal on production (run 44676404734) applied s850 and s851/s852 together, then ran a synthetic reply for 6 real batch courses:
  - batch of 150 (AU 103, NZ 28, CA 19) in 95 ms, tick 8 ms;
  - 3 fees admitted, 1 sent to Layer 4 (per semester), 2 held because a fee is already held, 4 intakes admitted, 2 intakes held, 6 rolling statements recorded;
  - fee watchdog: 1 claimable item, 0 stuck; G3 75/48, no drift; locks 7,585.
  The first run of the batch query took 808 ms against the 300 ms post-check (a table-wide scan of `course_fees`), so it was rewritten as an indexed keyset loop before the PR.
- **Parallel lanes.** S1-AER #1423 (migration `20261120163000`, merged 15:49 AEDT) is below this lane's renumbered files; S1-Structure-Outcomes #1427 (`20261120163500`) merged first with worker v1.0.33, so this change is rebuilt on main as worker v1.0.34 (20 Nov 2026 16:40 AEDT). Whichever merges second re-bumps the worker version on rebase. S1-UI-Parity #1424 uses `20261120145000`, which is below this slot.
- **Next:** merge this admin record, then Pilot #1425 on green CI and the passing rolled-back dry run. Then read back the deployed worker, the job and the first sweep batches with their admitted values. Close with Drive Monitoring, the two gap tables and the closing records.

**S1-Fees-Intakes, 20 Nov 2026 18:25 AEDT: s850 to s852 live and read back; closing records; parked**

Admin #695 merged first (`5f7b8576`) by the `automerge` label, then Pilot #1425 (`57efdea8`); Deploy on merge succeeded. Before merging, #1425 was rebuilt on main twice. Its migrations were renumbered to `20261120175000` and `20261120175100`, above S1-ELR `20261120170000` and S1-Structure-Outcomes `20261120172000`. The worker went out as v1.0.34, because #1427 had taken v1.0.33. Its import was moved off S1-ELR's import-line comment, and the batch post-check is now timed warm. All reads below were through the rolled-back dry-run workflow (runs 44692806423, 44693048168 and 44694432114), with no interactive SQL.

- **Live (18:19 AEDT).** Both migrations installed (2,228 history rows). `fid_det_read` replies come from `coverage-sweep-worker-v1.0.34`, reader `fid-det-v1.0`. G3 75/48, no drift. Manual locks 7,585. Firecrawl US$0; no model was called by this lane. Account AI spend today is US$1.06 of US$14, all from other lanes.
- **Fee reader (AI).** The stuck item `940bdc00…` got its one more try and finished `done` at 18:06 AEDT; 0 queued, 0 leased. The Platform health watchdog now reads `nothing_left: 6 fee pages the ai could not read` (18:19), no longer "stuck".
- **Sweep `fid-det-sweep`.** 18 job runs in the first 20 minutes, 18 succeeded, 0 failed. 20 worker calls recorded and 600 pages read. The batch query measured about 300 ms on production. A tick that records five replies (150 pages, each admission through `coverage_apply_course_v1`) takes up to 21 s (p95). That is background job time, not a screen query; the follow-up is to record one reply per tick.
- **Readings and outcomes (fid-det-v1.0, 600 pages).**
  - Admitted: 1 yearly international fee (NZ), intakes on 5 courses (AU 3, CA 2), and 3 application deadlines (AU).
  - Layer 4: 1 fee.
  - Held because a value is already held (no overwrite): 7 fees and 242 intakes.
  - Not admitted: 4 rolling statements; 3 deadlines not tied to one intake; 2 deadlines and 3 intakes incomplete; 10 ambiguous lines.
  - Most pages read so far already hold intakes, so yield per page is low; the sweep keeps going through the keyset.
- **Gaps (18:19 AEDT).** Table 1, verified source-backed (stored page text): fee NZ 1,086, CA 1,477; intakes AU 7,086, NZ 565, CA 731; deadlines AU 14,385, NZ 1,781, CA 1,906. Table 2, no source available yet: fee NZ 3,936, CA 1,605; intakes AU 7,402, NZ 3,728, CA 1,393; deadlines AU 9,572, NZ 4,700, CA 1,694. AU international fee: 0 gaps (CRICOS registered totals).
- **Branches.** `cf247-s853-readback-probe` and `cf247-s854-gaps-probe` were removed by the probe clean-up after their dry runs. `cf247-s840-fees-probe` and `cf247-s850-fees-probe` were still present at 18:11; they are left to the idle-probe sweep.
- **Follow-ups (for a later session).** Record one reply per tick so a tick stays short. Map trimester and semester labels to months through the university calendars (3 intakes incomplete). A deadline with no intake on the page (3 not tied to one intake) waits for its intakes.

**S1-Fees-Intakes, 20 Nov 2026 19:30 AEDT: s856 recorded before merge: the deterministic sweep is paced (Pilot s856, migration `20261120193000`)**

Platform Admin 20 Nov 2026 19:15 AEDT. Pre-flight: Admin #695 (`5f7b8576`), #710 (`ccb7980a`) and Pilot #1425 (`57efdea8`) were already merged, and Deploy on merge had succeeded; no check was failing. Stale probe branches `cf247-s840-fees-probe` and `cf247-s850-fees-probe` were given one rolled-back dry run each (runs 44701250430 and 44701298645), so the Auto-merge workflow's probe clean-up deletes them.

- **Live read-back (19:18 AEDT, runs 44701411953 and 44701584244, read only).** Worker v1.0.34. G3 75/48. Manual locks 7,585. AI spend today US$1.07 of US$14 (other lanes; this lane US$0, Firecrawl US$0). Fee reader watchdog `nothing_left: 6 fee pages the ai could not read` (19:04).
- **Sweep progress.** 74 of 74 job runs succeeded; 2,100 pages read, 70 calls recorded. Admitted so far: 5 yearly international fees (NZ), intakes on 31 courses (AU 14, CA 17) and 4 deadlines (AU). 2 fees went to Layer 4. Held because a value is already held: 789 intakes, 31 fees and 7 deadlines.
- **Two problems found.**
  - A tick that recorded all five replies of a batch (150 pages) in one transaction took 84 to 120 s, holding catalogue row locks that long.
  - At 18:50 all five calls of one batch went to `coverage-sweep` at once, alongside the other lanes' sweeps, and all failed with `WORKER_RESOURCE_LIMIT` (HTTP 546). Those 150 pages were never recorded, so they come round again in the next pass.
- **s856 (migration `20261120193000`; replaces the burst; retires nothing).** A batch (still 100 to 250 courses, `fid.batch_size` 150) is cut into calls of `fid.items_per_call` that wait as `queued` in `pipeline.fid_det_runs` (new column `payload`). Each minute the job sends one queued call while fewer than `fid.calls_open_max` (2, new) are waiting for a reply, and records at most `fid.replies_per_tick` (1, new) reply. A run then records about 30 pages (about 20 s), and throughput stays about 1,800 pages an hour. The gates, the batch query and the reader are unchanged. The post-check runs a tick inside a subtransaction that is always rolled back. Spec s856. G3 checked before and after.
- **Gaps (19:18 AEDT).**
  - Table 1, verified source-backed: fee NZ 1,082, CA 1,477; intakes AU 7,081, NZ 565, CA 717; deadlines AU 14,384, NZ 1,781, CA 1,906.
  - Table 2, no source available yet: fee NZ 3,936, CA 1,605; intakes AU 7,396, NZ 3,728, CA 1,392; deadlines AU 9,572, NZ 4,700, CA 1,694.
- **Next:** merge this record, then Pilot s856 by `automerge` with `live-dry-run`; read back a paced tick; Drive Monitoring row; park.

**S1-Fees-Intakes, 20 Nov 2026 20:00 AEDT: s857 recorded before merge: s856 re-issued without a drop (migration `20261120200000`)**

Pilot #1437 (s856) merged by `automerge` (`86f373a1`), but Deploy on merge (run 44704221314) refused `20261120193000` before applying anything. It widened the `pipeline.fid_det_runs` state check with `alter table … drop constraint`, and the deploy refuses any top-level drop (the Platform Admin pastes those). Nothing reached the database, so the sweep kept running unpaced on the s852 tick.

- **s857 fix.** The unapplied file is removed, and `20261120200000` does the same pacing with no drop. Queued calls wait in a new table, `pipeline.fid_det_call_queue` (`run_id` is set when the call is sent), and the existing state check is unchanged. The settings `fid.calls_open_max` 2 and `fid.replies_per_tick` 1 are as recorded for s856. Spec s856 gains a test that the file has nothing the deploy refuses and that the old file is gone. The deploy's rule was checked against the file locally.
- **Probe branches.** `cf247-s840-fees-probe`, `cf247-s850-fees-probe` and `cf247-s855-readback-probe` were deleted by the Auto-merge probe clean-up after their dry runs.

**S1-Fees-Intakes, 20 Nov 2026 20:10 AEDT: s856 and s857 live and read back; parked**

Admin #713 (`b81912dd`) and #714 (`73188414`) merged first. Pilot #1437 (`86f373a1`; its deploy refused the file, nothing applied) and #1438 (`13575474`) merged by `automerge`. Deploy on merge run 44706192536 succeeded. Read back through the rolled-back dry run (run 44707126431), with no interactive SQL.

- **Live (20:02 AEDT).** History holds `20261120200000` and not `20261120193000`. Worker v1.0.34. G3 75/48, no drift. Manual locks 7,585. AI spend today US$1.08 of US$14, from other lanes (this lane US$0, Firecrawl US$0). Fee reader watchdog `nothing_left`. Settings `fid.calls_open_max` 2 and `fid.replies_per_tick` 1.
- **Paced sweep.** One call sent a minute; the 5 calls of the batch went out one by one. Ticks 0.2 to 2.8 s from 19:57, against 84 to 120 s before; the last unpaced tick, at 19:56, took 118 s. 0 job failures and 0 worker failures in the 15 minutes after the change.
- **Totals.**
  - 3,270 pages read, 109 calls recorded. The 5 failed calls are the 18:50 burst.
  - Admitted: 6 yearly international fees (NZ), intakes on 50 courses (AU 25, CA 24, NZ 1) and 4 deadlines (AU).
  - 2 fees in Layer 4.
- **Gaps (20:02 AEDT).**
  - Table 1, verified source-backed: fee NZ 1,081, CA 1,477; intakes AU 7,075, NZ 565, CA 710; deadlines AU 14,384, NZ 1,781, CA 1,906.
  - Table 2, no source available yet: fee NZ 3,936, CA 1,605; intakes AU 7,391, NZ 3,727, CA 1,392; deadlines AU 9,572, NZ 4,700, CA 1,694.
- **Branches.** Every probe branch of this lane was removed by the probe clean-up, and the PR branches were deleted at merge.
- **Follow-ups (later session).** Trimester and semester labels to months via the university calendars; deadlines that wait for their intakes.

**S1-ELR-Central, 20 Nov 2026 23:20 AEDT: s884 to s886 recorded before merge: central English pages read at $0 (`elr-central-v1.0`) through the governed English policy route, inside `elr-det-sweep` (Pilot #1439, migration `20261120220000`)**

The Platform Admin's decision came at 20 Nov 2026 22:07 AEDT: populate the remaining Table 1 gaps from central English pages via the governed provider English policy route, at $0.

- **Audit, read live and rolled back.** Table 1 is 6,160 courses on 792 providers.
  - 115 providers (1,829 courses) have an approved policy, with 0 waiting to cascade. All are held: level not covered 1,173, no research requirement 362, no default for the level 266, named 186, double degree or exit award 61.
  - 15 providers (648 courses) have a reading waiting for a person.
  - 69 providers (1,051 courses) have a stored page that gave no values.
  - 70 providers (346 courses) have a page found but not stored; that needs Firecrawl, which is out of scope.
  - 523 providers (2,286 courses) have no central page.
- **s884, reader `elr-central-v1.0`.** It reads by tier (undergraduate, postgraduate coursework, research, VET/diploma), keeps verbatim quotes and PTE decimals, and keeps tiers strict. Conflicts are left out, and regulated disciplines are reported rather than used as a default.
- **s885, the governed route.**
  - Each university gets one proposal, holding only the tiers its approved policy lacks.
  - It is auto-approved only with no conflict and no other reading waiting, and the course-page disagreement check still applies.
  - The plan adds a VET tier only when the policy states one, and holds regulated disciplines.
  - The plans of the 8 largest existing policies are unchanged row for row.
- **s886, sweep.** There is no new cron job. `elr-det-sweep` now also reads central pages (6 universities a run), applies 2 approved central policies a run, and sends regulated-discipline courses to Layer 4. `provider-english-defaults` skips these policies.
- **Validation:**
  - Specs: s884 7/7, s885 and s886 6/6, and the guards pass.
  - The rolled-back dry run of the final file passed; the claim finds 604 pages for 263 universities.
  - Rolled-back smoke test: one proposal; the auto-approve refused it on the disagreement check (synthetic values); VET and bachelor defaults by tier; the sweep run took 1.1 s.
  - G1, G2 and G3 kept; US$0.
- **Design:** `docs/platform/2026-11-20-s884-s886-elr-central-policy-route.md`.
- **Next:** auto-merge this record, then Pilot #1439, then read live.

**S1-ELR-Central, 21 Nov 2026 00:05 AEDT: s884 to s886 closed: live and read back (Pilot #1439 `718106fc`; admin #722 `ac9cb169`)**

- **Deploy.** Pilot #1439 auto-merged on green CI with the labelled dry run passing. `Deploy on merge` applied migration `20261120220000` (history md5 `6492bf95` = file) and deployed `coverage-sweep` with mode `elr_central_read`.
  - The first PR dry run waited on a lock held by the running jobs. The new tables therefore have no foreign keys and no existing table is altered: central calls have their own table, `pipeline.elr_central_requests`.
- **Live read-back** (rolled-back probe, 21 Nov 2026 00:00 AEDT):
  - G3: 75 functions, 48 relations, no drift.
  - Manual locks: 7,585, unchanged.
  - Active cron jobs: 135 (ceiling 140); no job was added.
  - Spend: AI and Firecrawl US$0.
  - `elr-det-sweep`: 8 of 8 runs succeeded in 40 minutes. The longest took 6.8 s, which includes applying central policies. The central claim takes 58 ms.
- **First 40 minutes:**
  - 85 central pages read, with 13 more in flight.
  - 41 universities proposed tiers: VET 19, VET and undergraduate 10, undergraduate and postgraduate 6, VET and research 3, VET and postgraduate 3.
  - 41 pages state no English test requirement by tier.
  - 3 pages added no tier the approved policy lacks.
- **Governed approval.** 8 elr-central policies were approved automatically and 6 wait for a person: they had a conflict, another reading waiting, or failed the course-page disagreement check.
- **Applied:** 6 policies, 53 rows written by the sweep, 120 active rows from elr-central policies, and 2 regulated-discipline courses sent to Layer 4. No course rule or manual lock was overwritten (insert-only plan outcomes).
- **Gaps** (live, 00:00 AEDT; still draining at 6 universities a run, so about 3 more hours for the rest of the 263):

| Country | Table 1: verified source-backed gaps (stored page bound) | Table 2: no source available yet |
|---|---:|---:|
| AU | 3,687 | 5,485 |
| NZ | 1,091 | 3,028 |
| CA | 1,340 | 456 |
| Total | 6,118 | 8,969 |

- **What stays out of reach in this $0 lane:**
  - 523 providers (2,286 Table 1 courses) have no central English page.
  - 70 providers (346 courses) have a page found but not stored, which needs Firecrawl.
  - Non-AQF, school and short courses (751) have no tier.
  - Pages that state no requirement by tier stay held.
