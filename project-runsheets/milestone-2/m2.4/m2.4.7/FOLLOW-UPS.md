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

## 19 Nov 2026 11:55 AEDT — S2-BOOST-Discovery: read-only scholarship and AER discovery audit (AU, NZ, CA); report `docs/platform/2026-11-19-scholarship-and-aer-discovery-audit.md`

Read-only, no write, no Firecrawl spend, no table, column, function, job or setting added (G3 75/48). Of 1,675 active providers with international courses (AU 1,544, NZ 79, CA 52; 1,886 if courses not recorded as domestic-only are counted, NZ 290): **(a)** 1,571 hold a homepage (220 verified by search, 362 entered by a person, 989 register values not flagged; 104 AU have none); **(b)** 708 have a scholarship page crawled or a record published (91 published); **(c)** 797 have an entry-requirements read (AU 751, NZ 46, CA 0); **(d)** 90 have zero discovered pages (No site 26, No page 64, all AU); a further 355 have pages but nothing read. 1,385 lack a scholarship hub or an entry-requirements source (421 lack both). **Canada has no entry-requirements source for any of its 52 providers and no row in `aer_provider_coverage`**, so 25 of the top 30 uncovered providers are Canadian (UBC 575 courses, Alberta 379, Canterbury NZ 282, Conestoga 270). The Coverage & completeness screen shows academic entry as No reader for 34,631 courses because the field register reader is `none`; it cannot separate a provider with no source from one read but not admitted. Open work: Platform Admin to decide whether Canada joins the AER programme; AU and NZ top 20 and the 355 read-pending providers are listed in the report for post-handover crawls.
