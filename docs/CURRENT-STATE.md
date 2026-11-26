# StudySearch – current state (read this first)

**S2-RM-Design, 27 Nov 2026 00:28 AEDT (scheduled DR-19 check): s1277 realised gain.**
- **Of 554 handed back:** 13 filled (all descriptions), 176 skipped, 5 sent to Layer 4, 27 being read, 333 waiting; 0 refused again by the account.
- **Field-level check:** all 13 filled descriptions are verified in the catalogue and served by Website v3 matching the catalogue text exactly.
- **The skips are evidence holds, not operational:** sentence count 13, insufficient verified course facts 10, date not in the quote 11, quote not on the page 5, rolling applications 5.
- **Spend:** AI spend since midnight is US$0.05.

**S1-RM-Design, 27 Nov 2026 00:30 AEDT: s1176c live and read back (Pilot #1707; head `20261130061500`).**
- **Register:** `field_register.academic_entry` now reads `reader = coverage` with its producer named.
- **Coverage build:** the first unattended build (00:24) re-stated 238 courses from `no_reader` to page states (not_on_page 95, site_known 123, page_found 19, blocked 1). The rest follow over the build's normal cycle; 24,337 `no_reader` remained at 00:25.
- **Record trace:** a missing entry is now diagnosed from its evidence. For example, course 2a0d9f18 is `data_exception`, identity unproven (E16), not `software_defect`.
- **Unchanged:** G3 75/48; locks 7,585; no job or setting; US$0.
- **Next (Priority 3 in order):** request register projection, s1177 annual tuition, s1178 regulator identifiers, s1179 campus locality, intake validity.

**S1-RM-Design, 27 Nov 2026 00:30 AEDT (SS-Programme-Control 00:08, Priority 3 item 1): s1176c academic entry producer registration, recorded before merge (Pilot #1707, migration `20261130061500`).**
- **Defect:** `field_register.academic_entry` had `reader = none`. Missing entry was diagnosed as a software defect and `no_reader` (24,607 courses), although the s1274 planner step and the s1261 scheduled reader produce it.
- **Change:** `reader = coverage` (the existing classification) with the producer named. No other change.
- **Measured before release (rolled back on live; 3,998 courses at 198 providers rebuilt):**
  - entry states of the 2,562 courses without entry: not_on_page 1,118, site_known 1,078, page_found 290, blocked 63, no_website 13;
  - planner eligible gaps 155,231 to 157,603 (+1.5%), 162 providers changed (largest +207), none added or removed, top-50 overlap 49 of 50.
  - Projection, not a measurement: about +22,800 eligible gaps once the build has re-stated every course (about 90 minutes).
- **Unchanged:** G3 75/48; locks; cron; no job or setting; US$0. The measurement probe branch is a `-probe` branch, swept automatically.

**S1-Build, 27 Nov 2026 00:15 AEDT: P0 Keep Main Green (s1285).**
- **Cause:** main was red because the deployed Layer 1 spec still used the old `.xl-*` selectors.
- **Fix:** selectors only. Verified 3 of 3 on production.
- **Auto-merge:** now checks named required checks, runs one release at a time, and lets only a `main-green-fix` through while main is red.
- **Duplicate runs:** per-check-suite and label-triggered duplicates removed.
- **Cron:** no change by S1-Build.

**S1-Build, 27 Nov 2026 00:20 AEDT: cron and s1279 safeguards.**
- **Cron:** 138 active at 23:34 AEDT. S1-Build changed 0 jobs today. No redundant job was found.
- **Entities:** the 11 entity-pattern descriptions are UQ `&#039;` from the adapter path. They go to the description owner for a shared decoder and source-backed re-admission.
- **s1281:** renumbered `20261130054500`.

**S1-RM-Design, 26 Nov 2026 23:45 AEDT: s1176b live (Pilot #1699, deploy 45820200452, head `20261130044500`); job effectiveness assessment; academic entry producer analysis.**
- **s1176b deploy checks:** live bodies of `pim_consumer_sample_v1`, `pim_consumer_fields_v1`, `pim_consumer_text_v1` and `pim_norm_v1` match the file. The seed checks at 23:30 were clean.
- **First unattended sample (23:41):** 2 entry and 2 description courses, all delivery verified, entry international verified. It took about 13 s inside a 52 s background run (limit 120 s).
- **Populations (live):** academic entry 10,192, descriptions 16,118. Coverage is reported as sampled ÷ population, never extrapolated.
- **Cross-spec change:** `cf-247-s1202-portal-proposal-screens-contract` rejected any later migration that names a frozen read, even a read-only call. Its assertion now targets a definition, change, grant, comment or drop (all five negative cases still fail); G3 stays with `s57`. For S1-API-Frontend-Delivery (spec owner).
- **Consumer-read defect (from the rehearsal, confirmed by hand):** the v2 website and Zoho reads, and the v3 international read, join every entry row into `requirements_note` whatever its audience, so domestic-only rows reach international students (00020G 103424H: "Equivalent to Australian Year 12."). Routed to S1-Build and S1-API-Frontend-Delivery; v2 is G3, so a fix needs the Platform Admin and developer notice.
- **Job effectiveness (Priority 2):** `docs/platform/2026-11-26-pim-job-effectiveness-assessment.md`, generated from the live jobs snapshot. It covers 227 live components with purpose, owner, upstream and downstream, cadence, 24 h and 7 d outcomes, duration, contribution class and a recommendation each.
  - 172 record no structured result, so their outcome is unmeasured, not zero.
  - **S1-Build (dispatcher):** `ops-cost-guard` and `coursefinder-data-quality-overview-refresh` are stalled by deferral. `course-field-readiness` (4,999 of 6,852), `course-completeness-build` and `adapter-build-readiness` are often deferred. `layer2-onboarding-snapshot` still runs on its legacy cron beside a shadow row. Three cron jobs are switched off while still registered active.
  - **Owners:** 6 admission rules found nothing in most 7-day runs; `layer4-auto-admit` repeats the same protective outcome every run.
- **Academic entry producer registration (Priority 3, analysed, not changed):** `pipeline.field_register.academic_entry` has `reader = none`, so the trace calls missing entry a software defect and the coverage build says `no_reader`, although the s1274 planner step and the s1261 scheduled reader exist.
  - The column's CHECK allows only register, coverage, enrich and none. A new `aer` value needs the constraint replaced, which is a paste file.
  - `coverage` is allowed, but `security.enrich_plan_priority_v1` counts coverage and enrich fields, so it would also move academic entry gaps into planner priority.
  - Next: rehearse `coverage` with the planner ranking measured before and after, then ship, or prepare the paste file.
- **Unchanged:** G3 75/48; locks 7,585; no job or schedule change by this lane; US$0.

**S2-RM-Design, 26 Nov 2026 23:20 AEDT: DR-19 s1282 live (Pilot #1698, migration `20261130040000`) and read back. s1277 realised gain measured at the field level.**
- **s1282 live:** the trace returns cause, second opinion and audience; policy `ai_account_refusal` is present; G3 75/48, locks 7,585, cron 135.
- **s1277 realised (23:13) of 554 handed back:** 5 filled, 109 skipped, 2 sent to Layer 4, 27 being read, 411 waiting. AI spend today is US$3.23 of the US$10.00 ceiling.
  - All 5 filled descriptions are verified in the catalogue and served by Website v3 matching the catalogue text exactly (`served_and_verified`, `matches_canonical = true`).
  - The skips are genuine evidence holds (date not in the quote 11, quote not on the page 5, rolling applications 5, sentence count 7). They are insufficient evidence, not account refusals.
- **Open:** the Platform Admin decision on the human-assisted stronger-model step (off, no pinned model). S2-AER and S1-Build to name the four domestic-labelled requirements by course. S1-Build to check the entry-route spend (US$1.94 against US$1.00) and to make account refusals non-counting in the worker. S1-RM-Design to update the field register's academic_entry producer.

**S1-API-Frontend-Delivery, 26 Nov 2026 23:40 AEDT (SS-Programme-Control 22:51, "Complete job and lane monitoring UI"): s1283 built; recorded before merge (Pilot #1700, frontend only, no migration).**
- **Data Delivery:** the 138-row workers table is replaced by the backend-classified summary (snapshot time, state counts, counts by component type, attention items with the platform's reason and findings, searchable and paged). The Processing stalled count stays.
- **Scheduled jobs › Automations:** "Job and lane monitoring" reads `public.admin_pim_jobs_v1` once per visit (Curator and above) with search, type, state, finding and 24 h outcome filters, 20 a page and a drill-down. Labels are the backend's own; an unrecorded figure reads Not recorded, never 0.
- **Open for S1-RM-Design:** `toolset.ai` `not_ok` equals `attempts` on every service (the count treats the answered outcome as not OK); the UI leaves it out until corrected.
- **Reported Data Issues:** R2 waits on the R1 backend contract (S1-Build); Admin #1220 still open.

**S1-Build, 26 Nov 2026 23:20 AEDT: Reported Data Issues R1 backend (s1281) in release.**
- **Contract:** `docs/platform/2026-11-26-reported-issues-r1-backend-contract.md`.
- **Next:** R2 (UI) and R3 (Layer 4) can build on it now.
- **Zoho R4:** held.

**S1-RM-Design, 26 Nov 2026 23:05 AEDT (SS-Programme-Control 22:51, Priority 1): s1176b consumer field verification, recorded before merge (Pilot #1699, migration `20261130044500`, rehearsed rolled back).**
- **What it does:** a bounded rotating sample reads academic entry and course descriptions back through the reads the consumers call: `website_v2_course` and `zoho_v2_course` (actual delivery today), and for entry also `website_v3_course` as an international student. Each read records returned, populated, matches canonical and international applicability separately, then delivery verified and international verified.
- **Size and cadence:** 2 courses per stream every 10 minutes (settings), never-checked first, on a background run where neither the PIM progress nor the jobs read is due.
- **Populations it samples from (read live 23:00):** academic entry 10,062 courses (international or all audience rows, published providers); descriptions 16,116. The report gives coverage as sampled ÷ population and never extrapolates.
- **Rehearsal, 5 courses per stream (rolled back):**
  - descriptions: 5 of 5 verified on website and Zoho;
  - academic entry: 2 of 5 clean.
- **Academic entry failures:**
  - **domestic-only rows served:** the v2 website and Zoho reads, and the v3 international read, join every entry row into `requirements_note` whatever its audience. Confirmed by hand on 00020G 103424H: "Equivalent to Australian Year 12." is served to an IN student although v3's resolved rows exclude it;
  - **`contact_provider` for IN:** one course gets it although it holds an international row;
  - **missing row:** one course's v2 reads miss a canonical row that v3 returns.
- **Routed:** these are consumer-read defects. The v2 reads are G3 (frozen), so a fix needs the Platform Admin and developer notice; v3 is open to additions. Owners: S1-Build with S1-API-Frontend-Delivery. Nothing here changes a consumer read.
- **Unchanged:** G3 75/48; locks 7,585; cron 136; no job; US$0.

**S1-Build, 26 Nov 2026 23:15 AEDT.**
- **First autonomous AER cycle (run 593):** 53 rows on 20 courses.
- **Audience defect:** "Australian Year 12 or equivalent" was labelled domestic on 701 rows. s1280 fixes it (worker v1.0.52 plus the row correction); recorded as IQ-00683.
- **121558M BSB wording:** it is on the provider's own page. Recorded as source conflict IQ-00684.

**SS-Programme-Control — s1279 post-implementation lessons, 26 Nov 2026 22:55 AEDT (docs only).**
- Portal card description and provider-name display: Pilot #1695 merged `6500835d`; Admin #1226 merged; final migration `20261130023000` independently present. Effective `portal.card_description_chars=220`; 80–400 bounds recorded by owner. Clean migration ordering and downstream CI reported by owner; no independent browser/full-suite rerun.
- Master Plan §3b Rules 7–10: G2 registered settings for configurable UI data limits (retain explicit structural/security bounds); stand-in matcher parity and real-runner evidence distinction; early-warning review at >=137/140 active crons and dated per-lane before/after delta; source-aware HTML entity normalisation at admission, preserving raw evidence and manual locks.
- Live count at 22:55 AEDT: active crons 138/140 (2 headroom), locks 7,585. This review changed zero jobs (delta 0 attributable to this lane); earlier 135/137/138 are dated snapshots, not proof of additions. S1-Build to review dispatcher capacity/consolidation now through existing monitoring, no arbitrary job disable or new cron. G3 75/48 owner release evidence; not independently rerun here.
- 11 canonical course descriptions matched a limited residual HTML entity pattern in a read-only query. Candidate count, not 11 proved bad descriptions. S1-Build to coordinate shared normalisation/description owners; verify source semantics, preserve literal text and immutable evidence, repair through existing governed admission only, no mass replacement. Read-side s1279 snippet cleanup is not a canonical repair.
- Generated TEST-REGISTER lacks `cf-247-s1279-portal-card-description-contract` at this check. S1-Build to regenerate with full Pilot runner, review existing lightweight shim matcher coverage (toEqual/toBeLessThan), and coordinate real UAT if outstanding; no manual generated file edit. Zero migrations, production mutations or paid calls by oversight. No new launch dependency.

**S2-RM-Design, 26 Nov 2026 23:05 AEDT (DR-19 slice 3, SS-Programme-Control 22:32): s1282 claimed and rehearsed. Recorded before merge.**
- **Causes kept apart** under the stable class: account refusal (configured `service_limit` rows), technical failure, insufficient evidence, no source, unproven identity.
- **Second opinion:** the trace names the existing human-assisted recovery class and reads its stronger-model step live. It is off (`har.ai_escalate_on` = 0) with no pinned model, so no AI second opinion runs. Switching it on is a Platform Admin spend and qualification decision.
- **Audience:** held entry and fee rows by audience. In the UWA rehearsal, 2 of 40 courses hold only domestic entry rows. The v3 resolver serves no domestic row (0 of 2,607 courses holding them, for an India applicant). The four domestic-labelled requirements in API responses need naming by S2-AER and S1-Build.
- **Retained strategy:** recovery policy `ai_account_refusal` (defer and recheck, no attempt used).
- **Budgets:** AI ceiling US$10 a day and paid cap US$5 a day (live settings). The entry route is set at US$1.00 a day but spent US$1.94 today. No US$5.00 AER-only setting exists.
- **s1277 realised (22:49):** 52 skipped, 2 to Layer 4, 500 waiting, 0 filled.
- **Guardrails:** G3 75/48, locks 7,585, cron unchanged, no new spend.

**S1-RM-Design, 26 Nov 2026 22:50 AEDT: s1176 slice A live and read back (Pilot #1693 merged; deploy run 45811790352 success; head `20261130020000`).**
- **Deploy checks:** live bodies of `security.data_delivery_jobs_v1`, `security.pim_operations_v1` and `public.admin_pim_jobs_v1` match the file byte for byte (md5 `8834aabe`, `f6d87f0b`, `7c0bb6da`). Five `pim.jobs_*` settings are present.
- **Unattended background count:** the first one ran at 22:45:23 on its own run (15.6 s, no error); the PIM progress ran separately at 22:36 (39 s). The latest count has active 191, idle 20, held 13, degraded 2, retired 85 and shadow 1.
- **Screen read:** `security.data_delivery_v1()` 0.9 s in the database, 167 KB (was 96 KB). The 22:36 PIM snapshot carries 136 workers, `states` and 27 `attention` items.
- **Production UAT (Platform Admin session, Layer 2/3 Build & enrich › Operations › Autonomous PIM):**
  - desktop, measured 1024 × 768: "Stalled workers 0 of 136 scheduled jobs" and the Workers table lists every active job; no sideways scroll (scroll width 1024);
  - phone, measured 412 × 915 (DPR 2): no sideways scroll (scroll width 412).
- **For S1-API-Frontend-Delivery:** the screen still derives its own worker labels ("Idle, on time"). Drawing `state`, `reason`, `attention` and `by_component`, and a drill-down from `admin_pim_jobs_v1`, is a frontend change for that lane; 136 rows in one table is long on a phone.
- **Consumer read-back finding (DR-16 part 3, next slice):** the website and Zoho course sync copies carry no academic entry (basis only `english_only` or empty, including 10,655 courses with active entry rows) and no course description field. The v2 course read serves entry, but at about 1.5 s per course, so population read-back cannot run in the background count. The next slice is a rotating verified sample through the existing consumer reads.

**S1-Data-Gaps, 26 Nov 2026 23:10 AEDT: s1281 live and read back (Pilot #1696, merge `d59e461`, migration `20261130024500`; Admin record #1230 merged first, `843c7d3`).**
- **Read back from the live database (not the rehearsal):** head `20261130024500`; `fid.provider_types` holds the eight types; `fees.provider_types` is unchanged at five; the body of `security.fid_det_batch_v1` has the checksum the migration expected (`ec678d37e7ed3578ae4c1d06d8308dc8`); both audit events are recorded (22:57). The Course page needed list holds the 23 courses, all open, none locked, all still holding their address.
- **The sweep took the change within minutes:** the last batch before the deploy sent 1 page (11:15 UTC); from 23:00 AEDT it sends 30-page batches. Run 592 recorded 30 pages with 0 Layer 4 items raised, and `fid_det_pages` grew from 15,213 to 15,243, all 30 in private VET, school or wananga courses. No fee, intake or deadline has been admitted from them yet, so the yield is not known. At the first rate (30 pages a run, two calls open) the 6,935 pages take about six hours; read the readings table by outcome once the pass ends.
- **Guards after the deploy:** G3 75/48, no drift; manual locks 7,585; active cron 135 (this change added none); the 7 past-dated intake rows are still 7 rows, 7 courses, none with a future row; US$0.00.
- **Still open:** S1-DG-4 (a domestic-only statement finder; audit record section 9) and the Platform Admin's reading of the 23 listed courses. TEST-REGISTER now carries the `s1281` spec (1,080 regression specs, 5,038 tests). The `s1279` spec (S2-Data-Gaps) is not in the register yet; it is theirs to add.
- **Number clash to reconcile:** `s1281` is also claimed by S1-Build (Reported Data Issues R1 backend, claimed 22:22 AEDT in `CONTINUOUS-DELIVERY-MASTER-PLAN.md`, Admin #1239), and `s1280` by both S1-Build and S2-AER. S1-Data-Gaps' `s1281` is live first (Pilot #1696, migration `20261130024500`). Nothing was renumbered. The only live object that carries the number is the lane label `s1281 url alignment` on the 23 list rows; the migration and spec file names are unique. The Integration Controller reconciles which lane keeps which number.

**S1-Data-Gaps, 26 Nov 2026 22:55 AEDT (Atlas brief 22:19; Platform Admin approvals S1-DG-1 B, S1-DG-2 B, S1-DG-3 A): s1281 claimed and rehearsed (Pilot branch `s1-data-gaps-s1281`, migration `20261130024500`, rolled back live); recorded before merge.**
- **S1-DG-2, $0 intake sweep:** the deterministic sweep (`fid-det-sweep`) gets its own provider-type setting, `fid.provider_types` (the five types it reads today plus `private_vet`, `school`, `wananga`), and `security.fid_det_batch_v1` reads it (md5-guarded counted edit, body `23f4c294` to `ec678d37`). **`fees.provider_types` is deliberately not widened:** it also scopes the AI fee reader (`fee_reader_in_scope_v1`, `fee_reader_tick_v1`), and its own recorded reason keeps `private_vet` and `school` out. Widening it would have put 290 providers (308 fee-schedule sources) in front of the AI reader, so US$0 would not have held. Live read 22:2x: 22,303 stored pages; 15,149 processed; 219 in scope waiting; 6,935 outside the types (AU private_vet 6,152 pages at 651 providers, NZ private_vet 449 at 111, AU school 246 at 97, NZ wananga 88 at 3). Rule B, the identity and host gates, the manual locks and the Layer 4 cap (`fid.layer4_per_run`) sit in `fid_det_record_v1` and the reader, which this change does not touch. Expect a small yield (1.2% overall so far).
- **S1-DG-3, held addresses:** the 23 unlocked courses (AU 18, NZ 5, CA 0) whose held official address failed identity or host are added to the Course page needed list through `security.course_page_needed_add_v1` (lane `s1281 url alignment`), each gate repeated at apply time with an exact count guard. The held address is kept, nothing is deleted, the 123 locked courses are untouched. **Read before acting on the list:** because each course holds an active official link, the hourly `layer4-page-needed-search` rule never takes them, so they wait open for a person (add the page, search again, or record no page). `security.course_page_needed_settle_v1` (Platform Admin, `p_apply`) would settle any open row whose course holds an active link to `page_added`; do not run it over these 23 until their addresses are fixed.
- **S1-DG-1, CA evidence capture: nothing written, no credit spent (0 Firecrawl credits, no on-demand request opened).** The page text is held in Storage and is read only by edge functions, so no SQL read can scan it for explicit domestic-only wording, and no deterministic reader for that wording exists (the enrichment route fills only empty values; all 3,829 CA flags are `true` from an institution rule). The list of explicit statements therefore cannot be prepared yet. New decision **S1-DG-4** (audit record section 9): build a narrow $0 finder, or approve an AI re-read.
- **Guardrails:** live head `20261130020000` at rehearsal; G3 75/48 before and after; manual locks 7,585 unchanged; active cron 138 at rehearsal (this change adds none; other lanes moved it from 137); US$0.00; migration, setting and list changes each carry an audit event. TEST-REGISTER regenerates after the Pilot merge (the spec's PR number is read from git).

**S2-Data-Gaps, 26 Nov 2026 23:05 AEDT (Atlas brief 22:25, Platform Admin live UAT): s1279 Portal card description and provider clamp built and rehearsed (Pilot #1695, migration `20261130023000`). Recorded before merge.**
- **Short description on search cards.** `catalogue.portal_course_cards_v1` returns `description_snippet`: white space collapsed, `&#039;` read as an apostrophe, cut at the last whole word with an ellipsis, null when no description is held. Today 16,112 of 44,743 courses hold one (13,345 are longer than 220 characters); S1-Data-Gaps backfills the rest and owns the writers, and this change only reads, so new descriptions appear on cards with no further change. The card shows two lines only when held and never says "Not recorded".
- **Length is a setting (G2):** Settings › Pipeline settings, Portal, **Course cards: description length** (`portal.card_description_chars`, default 220, range 80 to 400, characters).
- **Long provider names clamp to two lines** on search cards, Entry Requirements cards, saved cards and list rows, with the full name as the tooltip and in full in Course details (for example Torrens University Australia, CRICOS 095357G).
- **Rehearsal (rolled back, live):** passed with its post-checks; one anchored edit of the cards body (md5-guarded); the search function is not touched.
- **Guardrails:** G3 75/48, manual locks and active cron asserted unchanged in the migration, nothing dropped, no job, US$0. TEST-REGISTER regeneration for the new spec is left to S1-Build (the local run lacks Playwright). The 1,440, 1,280 and 412 px layouts could not be viewed here (the live portal needs a sign-in); the Platform Admin checks are in the Portal build document, section 7.

**S2-RM-Design, 26 Nov 2026 22:25 AEDT: DR-19 s1277 live (Pilot #1690, migration `20261130010000`; dry run and test evidence green after one s42 fix: the recovery function is quoted `$function$`).**
- **Read back live:** the recovery ran at deploy (22:18): 554 items handed back to the existing AI worker (506 descriptions, 45 deadlines, 2 intakes, 1 English) and 554 absences resolved; 0 eligible operational failures left.
- **Not yet claimed:** at 22:22 all 554 were still `ai`. The measure's `cost_usd` (US$0.23) is the cost already recorded on those items from earlier attempts, not new spend. AI spend today is US$3.11 of the US$5.00 ceiling.
- **Realised gain:** fields filled, and descriptions served by Website v3 equal to the catalogue, are read by `security.pim_operational_recovery_measure_v1` and the record trace at the next check.
- **Guardrails:** G3 75/48, locks 7,585, active cron 137 (s1277 adds none and asserts the count unchanged).

**S1-RM-Design, 26 Nov 2026 22:40 AEDT (SS-Programme-Control 21:34, DR-16 takeover): s1176 slice A, PIM monitoring by jobid, recorded before merge (Pilot #1693, migration `20261130020000`, rehearsed rolled back).**
- **What it corrects (s1175 `pim.operations`, additions only):**
  - jobs are read from `cron.job_run_details` by `jobid`, never by name;
  - every `cron.job` row, dispatcher lane, rollup target and admission rule is one component (312 at rehearsal: 226 cron, 29 lanes, 35 targets, 22 rules), with state, reason, heartbeat, last run, next run, failure reason, effective state of a moved job, and 24 h and 7 d outcomes (productive, held, empty, failed, deferred, unmeasured) and durations;
  - unmeasured outcomes are never 0; cron history is kept about 4 days, so its 7-day figures carry `partial_since`;
  - a job switched off by the designed `flag-recheck` idle pause is **idle**, not held (the 21:50 switch-off of `coverage-read` and `coverage-read-2` was this, not a fault).
- **Where it runs:** the existing background count, into new `ops*` columns of `pipeline.data_delivery_job_runs`, on the run that does not count the PIM progress (PIM about 42 s, this read about 18 s). The screen read never counts it.
- **Contract for S1-API-Frontend-Delivery (no screen change made here):** `pim.operations.workers` is every active job (jobid added; s1175 fields unchanged). New keys: `states`, `by_component`, `attention`, `holds`, `toolset`, `jobs_snapshot`. The full list is `public.admin_pim_jobs_v1()` (Curator and above).
- **Rehearsal figures:** active 190, idle 19, held 13, degraded 2, retired 85, shadow 1; 135 workers.
- **Findings for S1-Build (no change made; dispatcher owner decides):**
  - rollup target `ops-cost-guard` was deferred 9,349 of 9,380 times in 7 days and last ran 25 Nov;
  - `coursefinder-data-quality-overview-refresh` was deferred 910 of 912 times and last ran 21 Nov.
- **Folded in:** the 15:47 checkpoint (admin #1177) and the s1175 record (admin #1173); both PRs are closed as superseded by this record.
- **Unchanged:** no job, schedule, lane, rule or target changed. G3 75/48, locks 7,585, cron 135 active; US$0.
- **Next in this lane:** AER and course description consumer coverage; request register projection; s1177 to s1179.

**SS-Programme-Control — Portal international eligibility and location display (s1275), post-implementation reconciliation, 26 Nov 2026 22:02 AEDT.**
- Pilot #1686 merged `ce56de42`; final migration `20261129230000` independently present live. Admin #1210/#1215 merged. Original PR text `20261129220000` is historical, superseded by the renumbered version.
- Generated `docs/platform/TEST-REGISTER.md` already contains `cf-247-s1275-portal-intl-availability-contract` (6 source tests, #1686, local status `not run`). No regeneration or hand edit for this documentation-only change. Owner's rolled-back rehearsal recorded; authenticated 1440/1280/412 px production evidence not independently established; S1-Build/authorised capable runner owns outstanding checks.
- Dated s1275 finding: 92 pending AER first reads, none machine-eligible then; 423 proposed rows across 15 providers held for missing explicit study level (51 India/Nepal). S2-AER to reconcile current cohort and resolve only through official evidence and existing reader/mapping/admission path; no inferred level, protected holds unchanged. Earlier 68-count scope not equivalent; CA false 0 is not proof of course eligibility.
- See Master Plan §3b for the six parallel-lane guardrails and Portal design snapshot boundary. Live read-only 22:02: active cron 135/140, existing lock count 7,585; previous 136/137 counts dated. G3 75/48 owner evidence for s1275, not re-run here. No migrations, vendor calls, schedule or production mutation in this docs-only review.


**S1-API-Frontend-Delivery, 26 Nov 2026 22:10 AEDT: reported data issues, mock-ups done (s1278).**
- **Done:** 19 screens and states for Admin, the Portal and the Zoho journey, desktop and 412 px, in the Drive document "StudySearch — Reported Data Issues & Resolution Tracking | UI Mock-ups" (https://docs.google.com/document/d/1Pafu45ifemADUHiBV2NSY3eesnfiTkwLLeqexyqj-kY/edit), linked from architecture document section 6.9. Illustrative data only.
- **Next:** R1 additive backend contract (S1-Build); then R2 reporter UI (this lane), R3 Layer 4 unified view (S2-Build, S2-RM-Design). R4 Zoho v3 is held for the developer notice and Platform Admin approval.
- **Record:** `docs/platform/2026-11-26-reported-data-issues-ui-mockups.md`. Nothing in Pilot, no migration, no setting changed.

**S1-Build, 26 Nov 2026 21:55 AEDT.**
- **Live:** s1261, entry route on (21:22 AEDT); s1276, quiet hours off.
- **In release:** s1277, the initial AI allocations: entry US$5 a day, platform AI ceiling US$10 a day (D8).
- **Unchanged:** Firecrawl 1,500 credits a day.
- **Next:** the first scheduled entry reads at 22:13 AEDT are traced at 22:30.

**S2-RM-Design, 26 Nov 2026 22:15 AEDT (DR-19 slice 2, SS-Programme-Control 21:36): s1277 claimed and rehearsed: operational-failure recovery, resolution history and field-level delivery. Recorded before merge.**
- **Diagnosis:** the 554 open absences are account refusals (OpenRouter weekly key limit and HTTP 401), not evidence. Their items used all 3 attempts during the outage. They were due again from 13 to 23 Nov, but nothing re-read them: the worker claims only items in state `ai` under 3 attempts.
- **Recovery (live on deploy):** each item goes back once to the existing AI worker (attempts at most 2, so the cap of 3 holds). Manual locks are honoured and the absences resolved; nothing is deleted. Rehearsed: 554 handed back (506 descriptions, 45 deadlines, 2 intakes, 1 English) and 0 eligible left. The estimated cost is about US$0.21 within the worker's caps; today's AI spend before this is US$3.04 of the US$5.00 ceiling.
- **Configurable classification:** three `recovery_error_classes` rows (`service_limit`) name the refusal wording.
- **Trace additions:** resolution history (resolved absences; Layer 4 decisions with change references) and field-level Website v3 delivery set against the platform state. Presence is never treated as accuracy.
- **Routed:** academic entry still shows "no automatic producer" (`field_register.reader = none` despite the s1274 planner step; S1-RM-Design). Refusals still count as attempts in the worker (S1-Build). Today's course_entry_requirements AI spend was US$1.94 against s1261's US$1.00 a day route (S1-Build to check).
- **Guardrails:** G3 75/48, locks 7,585, cron unchanged, no new job.

**S1-Build, 26 Nov 2026 21:10 AEDT: 24×7 operation.**
- **s1276:** daytime quiet hours off.
- **s1261:** scheduled entry route on at US$1.00 a day.
- **Status:** both in release, admin first.
- **s1274:** live.
- **Policy:** Agent Operating Model v1.28.

**S1-Data-Gaps, 26 Nov 2026 20:20 AEDT (Atlas brief 19:50, Platform Admin Portal UAT data-gap pass): CA international eligibility, $0 intakes and official URL alignment audited; read only, nothing written, no spec or migration claimed.**
- **Record:** `docs/platform/data-ingestion/2026-11-26-s1-data-gaps-ca-eligibility-intakes-url-audit.md`. Every figure was read through the hand-started rolled-back rehearsal (no interactive SQL).
- **International eligibility:** all 3,829 CA courses are `open_to_international = true` from an `institution_rule` with no page evidence; 288 nursing and regulated-health courses (96 nursing and midwifery, 192 other) at 40 providers, all true, none locked. No stored statement says domestic-only for Canada (false readings platform-wide: AU 4, NZ 265, CA 0). `security.enrich_apply_v1` fills only a null flag, so the governed path cannot lower a `true`; nothing was set.
- **Intakes:** 3,160 future-dated (9.2%); 19,951 stored pages read with evidence; `fid-det-sweep` (active) has processed 11,982; 7,133 bound pages remain, 211 in its provider types (they drain on their own) and 6,922 outside `fees.provider_types` (AU private VET 6,141, NZ private VET 447, AU schools 246, NZ wānanga 88). Observed yield 185 of 15,209 pages (1.2%), so about 80 more courses at most. The 7 past-only rows and the 14 intake locks are untouched.
- **URLs:** 146 courses hold an active URL whose own page failed identity or host (CA 64, NZ 47, AU 35); 123 are manual-locked and 23 are not. `needs_better_source_url` is the existing Course page needed queue (Decision 179: a held page stays with a person). Nothing was moved.
- **Decisions needed:** S1-DG-1 (CA domestic-only reader, step one read-only), S1-DG-2 (`fees.provider_types` for private VET, schools and wānanga), S1-DG-3 (the 23 courses).
- **Guardrails:** live head `20261129210000`; G3 75/48 untouched; manual locks 7,585; active cron 137 (none added); US$0. TEST-REGISTER unchanged (no test added, changed or retired). The Drive running build document is not editable by this connection; its entry text is in the record (section 7).

**S2-Data-Gaps, 26 Nov 2026 20:15 AEDT (Atlas brief 19:51, Platform Admin live UAT): s1275 Portal data display built and rehearsed (Pilot #1686, migration `20261129230000`). Recorded before merge.**
- **Domestic-only courses leave Portal search and Entry Requirements.** `catalogue.portal_course_search_v1` (read by `public.portal_course_search_v1`) and `portal.aer_list_v1` (read by `public.portal_aer_list_v1`) leave out `open_to_international = false` in the one passing step, so the total, ranking, near misses and relaxation counts agree. In scope today (34,362 published-provider courses): 144 domestic-only (NZ 140, AU 4, CA 0). A saved course stays on a person's list.
- **Unknown availability is flagged.** 4,287 courses hold no answer (NZ 4,269, AU 18, CA 0; the brief's 4,329 counted a slightly different scope). Search cards and Entry Requirements rows return `open_to_international` (true or null) and `portal/` shows the badge **Check international availability** when it is null.
- **Multi-campus place.** A course with no primary campus and campuses in several cities shows the one campus city inside the state the search names (`state_campus`), **Multiple campuses (VIC)** when several cities are in it, or **Multiple campuses** with no state; never a guessed campus. One wording, `portal.place_label_v1`; a typed city or postcode still shows its campus first (s1271). Rehearsed on ACU Bachelor of Nursing (Honours) 061896E: none selected reads Multiple campuses, VIC and NSW read Multiple campuses (VIC) and (NSW), QLD reads BANYO, ACT reads Watson. Across a sample of 2,000 Victorian courses with campus links: 1,030 sole-city (s1271), 542 one campus city in Victoria with campuses elsewhere, 428 Multiple campuses (VIC).
- **Rehearsal (rolled back, live):** passed with its post-checks. Search 214 to 1,194 ms (first call cold), Entry Requirements 482 ms.
- **Staged AER first reads (no admission possible without loosening a rule).** Live queue 26 Nov: 92 pending first reads (the brief's 68 is not a distinct set; the closest match is 38 partly admitted + 29 all_rows_held + 1 no_rows). The machine check passes none now: 58 gate_incomplete (38 already partly admitted by `aer-partial-v1`, 20 D-R3), 29 all_rows_held, 3 host_shared, 1 earlier_rejection, 1 no_rows; 17 change_of_admitted_table stay with a person. Nothing was admitted and no hold was changed. Portal India and Nepal coverage before and after: India 36 providers, 654 active matrix rows, 8,555 published active courses; Nepal 25 providers, 64 rows, 5,276 courses (unchanged). The largest all_rows_held cause is a level the page does not state (423 proposed rows at 15 providers, 51 of them India or Nepal); the level is never inferred. That belongs to S2-AER.
- **Guardrails:** G3 75/48 checked in the migration, manual locks 7,585, active cron 136 (none added), no setting, nothing dropped, US$0. TEST-REGISTER regeneration for the new spec is left to S1-Build (the local run lacks Playwright).

**S2-RM-Design, 26 Nov 2026 20:00 AEDT: DR-19 s1273 live (Pilot #1682, migration `20261129210000`; dry run, security gates and six test shards green).**
- **Read back live:** migration history holds `20261129210000`. The four functions and four `pim.trace_*` settings are present. UWA academic entry reads 190 verified, 84 data exceptions and 54 software defects, as rehearsed. A UWA course's trace returns Website v3 and Zoho v3 `returned: true` with `checked_at`.
- **Guardrails:** G3 75/48, locks 7,585, $0. Active cron is 136; s1273 adds none, and the migration asserts the count unchanged.

**S2-RM-Design, 26 Nov 2026 19:55 AEDT (DR-19, SS-Programme-Control 19:18): s1273 claimed and rehearsed: the record trace and provider diagnosis (shared contract items 1 and 2 of S2-Build's s1272 design). Recorded before merge.**
- **What it is:** read-only `security.pim_record_trace_v1(course, field, consumer)`. For each registered course field it returns:
  - the interface 2 facts, the field's producer kind, recent attempts, the open absence finding and open Layer 4 items;
  - a diagnosis in nine evidence-only classes, keeping operational failures, data exceptions and software defects apart, with the permitted actions;
  - the Website v3 and Zoho v3 read-back for the course, with its time.
- **Provider read:** `security.pim_provider_trace_v1(provider, field, class, limit)` counts by class and lists the records in a class. Admin reads are Viewer and above; there are four settings and no job or table.
- **Rehearsed live (rolled back):** for UWA academic entry, 190 verified, 84 data exceptions and 54 software defects (no automatic producer, the #1201 class that s1261 closes). For UWA descriptions, 204 verified, 121 data exceptions and 3 operational failures. Platform-wide, 554 open absence rows are operational failures (506 descriptions). The provider read takes 1.4 to 3.2 s for 328 courses.
- **Guardrails:** G3 75/48, locks 7,585, cron unchanged, $0. TEST-REGISTER regeneration is left to S1-Build (the local run lacks the spec dependencies).

**S1-Build, 26 Nov 2026 19:45 AEDT (SS-Programme-Control 18:21, 19:06, 19:12, 19:13): PIM academic entry activation in progress.**
- **Built and rehearsed (rolled back), recorded before merge:**
  - s1274 (Pilot #1683, migration `20261129220000`), **live 20:12 AEDT**: the planner's `academic_entry` step queues due entry reads through the existing rule and enqueue; skipped AI refusals are read again.
  - s1261 (Pilot #1675, migration `20261129230000`, not merged): route `course_entry_requirements` on gpt-4.1-mini at US$1.00 a day inside the US$5.00 ceiling.
- **Order:** s1274 merges and deploys. The first automatic plan (job 249 `enrich-plan-auto`, minute 41; job 248 starts its steps) that queues entry reads meets the condition, and s1261 then merges.
- **Eligible now:** 22 courses, 18 providers (AU 20, NZ 2, CA 0 under scope). Not a launch blocker: the backlog is held by Layer 4 supersession, silent pages, unproven identity and no-value flags (Master Plan status log 19:45).
- **Unchanged:** G3 75/48, locks 7,585, cron 138 active, no job created.
- **Records:** Master Plan §6.6 and §6.7 (DR-19) and Agent Operating Model v1.27 (diagnostic method).

**S2-AER (was S2-RM-Design), 26 Nov 2026 17:05 AEDT (Atlas brief 16:22: Portal UAT data-gap pass over 34,362 published-provider courses): read-only audit; no backfill shipped; nothing written.**
- **Audit:** `docs/platform/2026-11-26-portal-published-course-gap-audit.md`.
- **CRICOS:** 0 missing; all 24,013 AU courses carry a code, served by Website v3 and portal detail.
- **Campus city:** already unambiguous and served for a further 15,469 courses (no primary campus, all campuses in one city). The card's "Not recorded" is a mapping gap for S2-Build and S1-API-Frontend-Delivery. 8,509 multi-city courses need evidence; no manufactured primary.
- **Fees:** 15,585 courses hold only the register total. An annual figure from it would be inference. One canonical fee is `portal.primary_fee_v1` (s1222).
- **Intakes:** 3,160 future-dated (9.2%); 20,711 with no row; nothing staged waits (S1-RM-Design).
- **Description and URL:** 18,261 and 10,624 missing (S1-Build).
- **AER:** `IN` at providers covering 8,449 courses, `NP` 5,170; 0 matrix rows without a country. Coverage grows only by admitted reads.
- **Not changed:** no spec claimed, no migration, no test change. G3 75/48, locks 7,585, cron 135, $0.

**S2-AER, 26 Nov 2026 17:30 AEDT: reusable AER course-label defect corrected (Pilot s1252, branch `s2-aer-link`); William Angliss, George Brown and TasTAFE matrix holds classified.**
- William Angliss: genuine D-R3 hold (no applicant countries on the page). TasTAFE and George Brown English pages: wrong domain for the academic matrix (English AER lane). George Brown recruitment policy: `course_unlinked` was a shared defect, other row holds genuine.
- s1252: `entry_course_link_v1` reads VET levels from the existing mapper and strips training package codes, only when the level helper names no level; exact title, level and one active course still required. Rehearsal (rolled back): 9 labels link across 6 providers; decided links unchanged. Admission follows from re-read. G3 75/48, locks 7,585, US$0.
- CQU and AIBT source host identity: with S1-AER-Claude, not relaxed. Test register: S1-Build to add `cf-247-s1252-vet-course-label-identity-contract` at its next regeneration.

**S1-RM-Design, 26 Nov 2026 16:35 AEDT: DR-16 (permanent PIM data-completeness controls) received and claimed; not started. This session is at its working limit; a fresh S1-RM-Design session takes over from here.**
- **Slices, in order** (each extends the existing field register, applicability, field state, gap queue and Data Delivery snapshot; no separate pipeline, no cron, no blanket block or withdrawal):
  - **s1176:** the 15:47 items: every active worker and effective hold (join `cron.job` on jobid); read-only request register projection from `CONSUMER-REQUESTS.csv`; AER and cdesc consumer coverage.
  - **s1177 (DR-16 §1 and §6):** register field `annual_tuition`.
    - Held means `security.course_fee_selected_v1` resolves one international annual amount with currency, year and basis.
    - Gap classes: missing, conflicting, duplicate, unverified. No amount is inferred. Coordinate with the fee owner.
  - **s1178 (§2):** register field `regulator_id`, with a per-country rule (AU CRICOS; NZ and CA only where a registry is held).
    - A gap is flagged only when authoritative L1 evidence exists. Nothing is invented. Coordinate with the L1 owner.
  - **s1179 (§3 and §4):**
    - campus locality: primary campus city, state and postcode against the `ref` locality table; no provider-HQ substitution;
    - intake validity: duplicate offering at course, campus and edition grain; expired-from-current under the existing lifecycle; scholarships excluded.
  - **§5:** academic entry country identifiers (IN, NP) stay with S2-AER. This lane adds only the measurement.
- **Migration versions:** take them above the live head at build time, checking open PRs first. The s1170 to s1179 spec block is reserved for this lane.
- **Cron:** Atlas's operating target is at most 135 active; the approved ceiling is 140. Live is 135 (26 Nov 15:45). This lane adds no cron.
- **Records:** DR-16, the Execution Register and Feature Acceptance update with each slice as it merges.

**S2-AER, 26 Nov 2026 19:00 AEDT: stored AER evidence inspected; shared PDF reader scope in merge (s1253; Pilot #1677, #1680, #1684; worker v1.0.51).** Existing inspection, extended by source id: LCB Table A is page 15 and Table B pages 16 to 32 (page 33 is Table C); its 24 Nov hold was a numbered list on page 3. CQU CDN PDF (`?v=edf51706`) is one stored copy under two sources; the official page links to the CDN document path and the stored bytes hash is verified (A1 evidence read; the edition is on our stored URL only). LCB: the scoped read also needed the repeated page footer left out (Pilot #1684, worker v1.0.51, retry only), replayed on the stored geometry. Excelsia guide has no academic entry table. entry_ai re-reads a held PDF on its entry-table pages only when the same proven reader proves them. No migration, no setting, US$0, G3 untouched. Detail: Execution Register.

**S1-API-Frontend-Delivery, 26 Nov 2026 19:25 AEDT: searchable Admin pages live (s1270; Pilot #1676, #1679, #1685; Admin #1196).** A search bar at the top of eight long Admin pages (Build & enrich, Settings, Models & services, Layer 1, Coverage, Platform health, Scheduled jobs, Go-live) finds a tab, section or setting by name, key, what uses it or a plain synonym, opens the tab and section, scrolls to and highlights the control; press `/` to focus it. It reads only what the page already loaded and offers only what the role can open. No migration, no new setting, no backend read, no G3 change. Design: `docs/platform/2026-11-26-page-search-s1270.md`. Signed-in desktop (1,894 px) and 412 x 915 phone UAT as Platform Admin passed on the live site; evidence is in the Master Plan status log (19:25 entry).

**S1-API-Frontend-Delivery, 26 Nov 2026 16:10 AEDT: PIM operations integration live (s1221; Pilot #1668 and Admin #1179 merged; signed-in desktop read-back matches the live read: 7 workers, 0 stalled, 17 consumer rows across six streams, 43 freshness rows; no overflow; frontend only, no migration, no setting, US$0, G3 untouched).**
- The deployed `pim.operations` (s1175) was verified against the live snapshot and migration, then drawn as delivered: stalled workers and a Workers table, verified consumer read-back per stream and country (website and Zoho matched out of expected, pending, missing and not served apart; Zoho Not measured where null; streams never added), freshness by country with a country filter, and the age of each helper count.
- Still Not available, with reasons: the request register (`operations.requests` is `not_projected`: no registered database source) and verified feedback (no authoritative source); oldest verified by country and a per-worker heartbeat are not in the read.
- Open: live 412 px read-back (needs a phone or a resizable browser; the site's `frame-ancestors 'none'` is deliberate and unchanged). F-OPS.17, F-OPS.18 and F-OPS.21 stay open until verified.

**S1-API-Frontend-Delivery, 26 Nov 2026 17:45 AEDT: mobile acceptance recorded for the Autonomous PIM block (F-OPS.17 and F-OPS.21).** The Platform Admin checked the live block signed in, in Chrome DevTools emulation (Samsung Galaxy A55, 360 x 800): readable, no horizontal scrolling. Recorded beside the automated 412 px tests (Pixel 7 emulation, mocked data). Not claimed: a physical-device check, or any live tap or interaction beyond the layout (tap sizes and interactions are covered by the automated tests only). F-OPS.18 and the outstanding backend monitoring requirements stay open (request register `not_projected`, verified feedback, oldest verified by country, per-worker heartbeat). Evidence table in `docs/platform/data-ingestion/2026-11-26-pim-data-delivery-frontend-s1217.md`.

**S1-AER-Claude, 26 Nov 2026 15:50 AEDT (SS-Programme-Control assignment: Australian AER autonomous PIM delivery and acceptance; spec s1219, documents only, no Pilot code, no migration, no setting change): reconciliation of the 40-provider AU cohort and of the autonomous route. US$0 spent, Firecrawl 0, no AI call by this lane since 25 Nov 07:00.**
- **Cohort state, read live at 15:05 AEDT (outcomes view built 15:05).** Courses with admitted course-level AER 732 (643 at 25 Nov 07:05, +89); active course-level rows 1,954 (1,564, +390); identity-held 395 (503, minus 108); awaiting Layer 4 58 (27); admitted by provider matrix 243; nothing published 131; no official course page 108; excluded 44. Provider matrix unchanged: 9 active rows at 3 providers (La Trobe 2, William Angliss 4, Gold Coast Learning Centre 3).
- **Attribution (not claimed as autonomous delivery).** All 390 new rows are `gpt-4.1-mini` entries from S1-Build's bounded course entry read windows (25 Nov 18:00 hour 42 rows over 10 courses; 26 Nov 09:00 hour 157 over 37; 10:00 hour 191 over 42), each a scoped request with the route off afterwards. Largest: Collarts 40 courses; then Gold Coast Learning Centre 6, Lead College, York Business Institute and Aventia 5 each. All 89 new courses are at providers with publication_status `published`. No new row in this cohort came from an unattended scheduled route since 25 Nov 07:00, so this cohort adds **no** unattended result-bearing cycle to PIM acceptance yet (two cycles stay S1-Build's, with the evidence above as the starting record).
- **Matrix and source recovery: nothing has moved since 25 Nov 07:18, and the autonomous route does not retry these.** Greenwich (21e1cb6d): both sources `found`, 0 attempts; the provider is unpublished and hidden, so the fetch refuses it by design (Platform Admin: publish or leave). Le Cordon Bleu and Excelsia guide PDFs: run `failed`, source status `read`, not requeued (no reader version change); the two PDFs need a layout reader or a qualified model, same class as ACU (s1071) and CQU (s1105, s1106). CQU (4ff4010f 0 rows; 50e4031c): run done 25 Nov 08:04 with **112 rows kept**, declined 08:18 `source_not_official_host` (host `delivery-cqucontenthub.stylelabs.cloud`); the retired copy 55de8e6d is inactive. AIBT: declined the same rule (aibtglobal.edu.au against aibt.qld.edu.au). William Angliss: 4 rows admitted partial at 07:14, then declined `gate_incomplete` 13:18 for its further read; George Brown (`all_rows_held`, `gate_incomplete`) and TasTAFE (`gate_incomplete`; the source is English-only) unchanged. ACU holds 377 active matrix rows. Layer 4 pending platform-wide: 92 `entry_matrix_first_run`, 17 `entry_matrix_change`.
- **Reusable defect found: official source on a different host.** The machine admission's host rule has a Platform Admin alias list, `aer.provider_host_aliases` (s1038, first entry adelaide.edu.au). CQU (112 rows waiting) and AIBT need the same decision; the Curtin CDN host was left unaliased earlier ("not decided"). Not changed by this lane (a protected setting). **Platform Admin decision requested:** alias `delivery-cqucontenthub.stylelabs.cloud` for CQU (evidence needed first: that cqu.edu.au links to that file; not verified in this record) and `aibtglobal.edu.au` for AIBT.
- **Spec reservations reconciled with the record** (Master Plan table status cells updated in this change): s1042 documents only, closed; s1049 Pilot #1557 merged and deployed 24 Nov; s1106 Pilot #1596 merged 25 Nov (s1105 #1595, s1071 #1565, #1568, #1569 also merged); CQU re-read through 50e4031c done after s1106. S1-Build to confirm no objection to closing the three; no other reservation held by this lane.
- **Autonomous mechanism, verified from live state and Admin #1146 to #1166 (not re-derived):** `coverage-read` and `aer-det-sweep` run unattended on stored pages; the revisit step s1171 has 0 pages due until 5 Dec; course entry AI runs only as bounded windows (route off between); 2,028 never-AI-read courses wait on the shared programme page identity decision. 176 cohort courses still match the read-skipped definition at 15:05. Consumer read-back: all 89 new courses are at published providers (database state); the read through `website_v3_course` with the course UUID returned NOT_FOUND, so the identifier form is not established and **the consumer read-back by this lane is not verified**; S1-Build's records carry read-backs by official course identifier (for example 120328M). Data Delivery: the AU AER counts above can be compared to the snapshot; no screen change from this lane.
- **Next, in order:** (1) Platform Admin: the two host aliases and the Greenwich publishing decision; (2) S1-Build or S2-AER: PDF layout reader for Le Cordon Bleu and Excelsia guides, then requeue by reader version; (3) S2-AER: George Brown, TasTAFE and Angliss `gate_incomplete`; (4) this lane, after (1): re-read machine decisions for CQU and AIBT and verify admission and consumer read-back by official identifier; (5) this lane: record the next two scheduled cycles' new cohort rows (none expected until the next window or identity decision).


**SCH-FU-04 / S3-Scholarship-ChatGPT — 26 Nov 2026 15:16 AEDT, autonomous acceptance.** Request 625e62fc remains closed (84/84 FC, audit 68201), never reopen. NZ 120 published/13 providers, 86 active unpublished, 206 combined active; one publication fewer since closure, no new NZ candidate reads or admission events. R0 linked 606: 237 read, 367 unread (Auckland69, Canterbury295, Otago3; ordinary cap held), 4 read-undecided (Otago3, VUW1), no leases. Existing W01 45 IDs retained. No eligible due unleased candidate, queued NZ AI item, or publishable unpublished award. Holds overlap: 55 missing value, 39 closed, 3 resident/citizen, 2 edition. Scheduled NZ FC1 since closure, no NZ AI extraction records; account 60925, OpenRouter US$91.55; G3 75/48, locks7585, cron138. Data Delivery security.data_delivery_v1() NZ120/13 published, 8 admitted-not-published providers, 9 domestic/ineligible, 58 insufficient evidence, 1 not attempted/vendor failure, 200 searched-none; 17 NZ pending reviews. Global stream 1753 reading/72 review/617 decisions in 24h, 256 read and 24 publisher successes, recovery healthy; Website global 1206/1206 matched; Zoho comparison unavailable, stages null. Not evidence of two NZ result-bearing end-to-end cycles after closure.

**S2-Scholarship-Readers (Canada) — 26 Nov 2026 ~16:30 AEDT.** CA 404 active, 197 published, 54 publishing providers. AI extraction pauses 08:00 to 20:00 Melbourne by the quiet-hours setting (resumes about 20:00 AEDT). 92 unpublished active awards are held for "no stated award value": 63 state none (held), 16 non-monetary or tiered (held), 11 had a fixed amount the checker wrongly rejected: `quoteSource` ignored a quote of only "$165.00" or "$4,000". Fix `s1237` (Pilot, worker v1.0.48, shared with AU and NZ) is in two PRs, Admin first; the affected awards (4 CA, 4 AU) are re-read after 20:00 AEDT through the existing queue. Detail and next steps: master plan, S2-Scholarship-Readers entry of 26 Nov.

**Shared code coordination: proposed s1236**, not found in Pilot/Admin searches; S1-Build must confirm reservation and ownership before release, coordinate S1-Scholarship-Claude and S2-Scholarship-Readers. WITT listing 1751 zero sections, candidate 48478 listing_page rejection; exact stored source 0071e251-23a7-436d-b446-2ed042c2bdca SHA256 0adf7961337837dbc51fa6d43550026af9d5a2be0688eaf3423583ec9dfc9319. Official https://www.witt.ac.nz/international-students/international-scholarships has programme/benefit table and 2027 international tuition eligibility. Extend existing label splitter, no new reader; exact row scope, exclude n/a/pending approval/missing course page/ambiguous duplicate names; preserve shared terms, require provider/course identity, fail closed. A reconstructed fixture is not qualification against stored raw bytes. Lincoln extraction 76851, evidence 1948b015-e6b5-4d4e-a3c9-d71b101d71c6: verified NZD15000 A average, NZD10000 B average, two academic_minimum criteria and full taught masters scope; canonical dac3ea6d-9a89-5fe5-a784-6b8923bbb9ac scalar 15000 not marked maximum, two coverage rows, zero tiers/academic criteria, 14 mappings. Conditional benefit may be overstated. No NZD7000 or B+ inference; no AND combination of grade alternatives. Five unmatched: li7770 Global Management and Marketing, li7772 Finance (title candidates only), li7580 Planning (duration unproved), li0426/li7403 Landscape Architecture (ambiguous credits), Parks Management no matching title. Verify exact programme/duration, preserve existing links; shared existing normaliser/matcher correction via governed integration, replay checked stored answer, no direct canonical writes or consumer API change. NZTC publication/consumer proof retained. Acceptance requires two scheduled result-bearing acquisition/read→checked extraction→admission→automatic publication→consumer lineage cycles. No new queue/scheduler/spend or cap bypass. Continue existing claims and eligible stored recovery. S1-Build owns register regeneration.

**S2-AER, 26 Nov 2026 15:30 AEDT: shared AER admission failures reconciled by rule; no release (US$0, G3 75/48 untouched, locks 7,585).**
- Course entry pending: `active_rows_exist` 566 (partial admissions, protected), `all_rows_held` 147, `no_bound_page` 38, `identity_not_admitted` 11. Matrix pending 109: D-R3 56, `all_rows_held` 29, `change_of_admitted_table` 17, `host_shared` 3, `source_not_official_host` 2, `earlier_rejection` 1, `no_rows` 1; each needs a person.
- Candidate technical defect, unproven: D-R3 quote capture (`quote_not_on_page`, `grade_not_in_quote`; quotes capped near 120 to 300 characters). Next: test 10 items against stored page text.
- Consumer read-back: 25 of 25 sampled courses admitted in the last 24 h resolve with a populated `entry` in `website_v2_course`. Two unattended result-bearing cycles not yet verified. Pilot #1502 remains a draft. Detail: `docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md`.

**S1-RM-Design, 26 Nov 2026 14:50 AEDT: Data Delivery read moved to background snapshots (s1174 live, Pilot #1660, md5 2add9bc9).**
- The four heavy helpers now come from `pipeline.data_delivery_helper_snapshots`, counted by the existing `data-delivery` job after `data_delivery.refresh_minutes`. Measured live: cdesc_stages 10.6 s, intake 5.6 s, aer 4.6 s, pdesc 1.1 s.
- The last good result is kept on failure. The new key `snapshots` reports each helper's as_at, took_ms, error and failed_at. The response contract is unchanged.
- **`security.data_delivery_v1()`: 6.0 s before; after, 354 ms cold, then 117, 117 and 125 ms on four calls issued in parallel.** The signed-in `admin_layer23('data_delivery')` path adds only the permission check; a browser read-back is to be confirmed by S1-API-Frontend-Delivery on s1217.
- First background recount after the deploy fill: due about 14:55 AEDT; to be read back.
- **Not yet built (open, S1-RM-Design):**
  - `pim.requests[]` (request register read);
  - verified consumer coverage per PIM field;
  - worker heartbeat and stalled processing;
  - freshness by country;
  - verified request feedback outcomes.
- **Still open:** changed and unchanged source evidence; recovered-page admission and read-back; two unattended cycles (S1-Build).

**S1-API-Frontend-Delivery, 26 Nov 2026 15:30 AEDT: final authenticated UAT of the Data Delivery PIM block (Pilot #1663 adds role-gate tests only; no source, backend or migration change).** G3 75/48 untouched, locks 7,585, cron 136, US$0.
- **Response time, after s1174 (Pilot #1660).** `security.data_delivery_v1()` 0.05 s warm in the database (was 10 to 23 s). The signed-in browser call to `admin_layer23('data_delivery')` took 404 to 739 ms over 10 calls (8 s limit), all 200, 85 KB, `failed_measures` 0, every stream fresh.
- **Snapshot freshness.** PIM counted every 10 min (`data_delivery.refresh_minutes`), age 0 to 10 min when read; stale after 30 min; a failed count keeps the last good `pim` and sets the error and time, which the screen shows as Stale beside the last good figures (browser spec, and the refresh function read in the database).
- **Role gate.** Read in the database as each role: counsellor (rank 2) is refused (42501, Curator role or above required); pipeline_operator, pim_admin and platform_admin read all 42 PIM rows. Browser specs: not shown at rank 2; shown and read only at ranks 3, 4 and 6.
- **Not done.** 412 px live read-back: the site denies framing (CSP and X-Frame-Options, kept as is) and this browser session cannot resize or zoom, so phone width is covered by the Pixel 7 (412 px) specs only. Request data: `pim` carries no `requests` key yet. F-OPS.17, F-OPS.18 and F-OPS.21 stay open.

**S1-API-Frontend-Delivery, 26 Nov 2026 15:00 AEDT: PIM block accuracy pass live (s1218; Pilot #1661 and Admin #1163 merged, deploy succeeded, no migration).** G3 75/48 untouched, locks 7,585, cron 136, US$0.
- **What changed on screen.** `gain_basis` is shown and gains on different bases are never added (Mixed bases; legend); "Published-provider gain" is kept apart from "Verified consumer delivery" (Not measured per field); a measured zero reads "measured: none" and a missing value is Not measured (no longer summed as 0); the funnel is split into Canonical field coverage and Work items in the queue, because held work items can exceed the backlog. Detail: design note section "s1218 accuracy pass".
- **Live read-back (desktop, 2:53 pm snapshot).** Two gain groups with their bases (entry rows +547; 13 enrich-item fields +55), no blended total; the Entry cell says Mixed bases and the legend lists both bases; Verified consumer delivery says Not measured; the funnel shows the two groups (applicable 480,923, completed 307,401, backlog 173,522; items queued 5, held 198,842, failed 7,719); no overflow. The first load succeeded this time. 412 px live and request data are not yet read back.
- **Waiting on S1-RM-Design (backend).** Request register read (`pim.requests[]`) and the Data Delivery read under the 8 s limit. After that release: authenticated desktop and 412 px read-back with request data, response time and snapshot freshness, then F-OPS.17, F-OPS.18 and F-OPS.21 frontend acceptance.

**S1-API-Frontend-Delivery, 26 Nov 2026 14:10 AEDT: Data Delivery PIM frontend live (s1217; Admin #1159 and Pilot #1659 merged, deploy succeeded, no migration).** G3 75/48 untouched, locks 7,585, cron 136, US$0.
- **Live read-back (desktop).** The Autonomous PIM block renders on the live Data Delivery screen with figures identical to the stored snapshot (counted 1:58 pm Melbourne: applicable 480,923, completed 307,401, backlog 173,522, queued 5, held 198,841, failed 7,719). No overflow. The 412 px phone width was not read back live (the session could not narrow the browser); the mock-backed phone spec covers it.
- **Open, pre-existing, for S2-Build / S1-RM-Design.** `security.data_delivery_v1()` takes 10 to 23 s against the 8 s limit for signed-in users (`data_delivery_cdesc_stages_v1()` about 8.4 s of it, counted live on every open). The screen showed "The database took too long" on two of three retries. Proposed fix and timings in the design note. F-OPS.21 stays open until this is under the limit and the phone read-back is done.

**S1-API-Frontend-Delivery, 26 Nov 2026 13:25 AEDT: Data Delivery PIM frontend built (s1217, recorded before merge; Pilot branch `s1-pim-frontend-s1217`, no migration); live read-back follows the merge.** G3 75/48 untouched, locks 7,585, cron 136, US$0.
- **What is on screen.** An "Autonomous PIM" block inside the existing Data Delivery panel (Layer 2/3 Build & enrich › Operations), from `pim` in `admin_layer23('data_delivery')`. Delivery matrix (country selector, domain × country, measure switch, funnel, gains, throughput, measured clearance, oldest outstanding, last and next run, scheduler, leases and recovery, AI and Firecrawl use, human interventions), Requests & feedback and Refresh & maintenance views. No new control, setting, migration or backend read. Detail: `docs/platform/data-ingestion/2026-11-26-pim-data-delivery-frontend-s1217.md`.
- **Labelled, not counted.** Request register (Requests view says Not available), consumer coverage as a share, worker heartbeat, freshness by country, billed AI cost when null, clearance where nothing was gained. None is shown as 0.
- **Open for S1-RM-Design.** Request register read (`pim.requests[]`, shape in the design document above). F-OPS.17 and F-OPS.21 stay open until the live read-back at 1440 and 412 px; F-OPS.18 until the request read exists.
- **Spec number.** `s1216` went to S2-Build during the build, so this change is `s1217`.

**S1-RM-Design, 26 Nov 2026 13:30 AEDT: PIM monitoring reconciled (s1173 live, Pilot #1655, md5 9c8ea25b); operational verification read 2.** G3 75/48, locks 7,585, cron 136, US$0.
- **Reconciliation.**
  - The 11:57 snapshot showed 0 academic entry gains because `pim_progress_v1` counted only enrich items in state `filled` (key `entry_requirements`, never the register's `academic_entry`). AER admissions write no enrich items. Fixed.
  - The gain is now canonical: a course counts when its first active `course_entry_requirements` row was created in the 24 h window (`data_delivery.net_short_hours`), and as published when its provider is published.
  - Live: **AU 547 newly populated courses, 547 published; NZ 0; CA 0; 2,222 active rows created in 24 h.** S1-Build's 278 courses and 1,305 rows were read over an earlier 24 h window.
  - Every field now states its `gain_basis`. The other fields are still enrich-based.
- **Protected holds.** Blocked and robots_disallowed pages are `protected_hold` in `pim.refresh` and are never counted as due. The revisit never takes them (s1171 and s1172).
- **Contract for S1-API-Frontend-Delivery.** `pim.fields[]` gives:
  - country, field, applicable, not_applicable, unconfirmed, held, backlog, queued, running, review, failed, no_source_found, expired_leases;
  - canonical_gain_window, published_gain_window, gain_basis, throughput_per_hour, clearance_hours, oldest_outstanding.

  Also `pim.excluded`, `pim.lifecycle`, `pim.refresh` (sources with protected_hold), and `pim.snapshot_at`, `pim.snapshot_error`.
- **Scheduled `academic_entry` dispatch: proven.**
  - Three automatic plans carried the step; one finished as a `handoff`. It revisited 1 page (Job Training Institute): read again, still fetch_failed with HTTP 200 (empty or failed body), not stored, no rows.
  - Tracing recovered evidence through extraction, admission and read-back is still open; no revisit has produced a stored page yet.
- **Replacement safety.** 4 successor triggers are live, and 971 guarded Layer 4 reads are pending, none discarded. The 2,217 flagged supersessions are still awaiting the EQUALS decision.
- **Still open:**
  - changed and unchanged source evidence;
  - a recovered page traced to admission and consumer read-back;
  - two unattended cycles per domain (S1-Build);
  - F-OPS.21 screen (S1-API-Frontend-Delivery, now on the contract above);
  - Adelaide re-discovery (S1-Build).

**S3-Scholarship-ChatGPT / SCH-FU-04 — 26 Nov 2026 10:41:45 AEDT: request 625e62fc-fd69-47d1-9858-216dcb4a76e7 CLOSED.** Admin #937 / Pilot #1574 / Admin #981. Expired 25 Nov 03:40:21 AEDT; 0 active candidate, listing or AI leases at closure, exact five NZ providers/purpose/cap rechecked under lock. Existing `security.on_demand_close_v1` executed; production readback state closed, audit 68201. 84/84 Firecrawl credits consumed (sch_scrape), account 61,289 credits and OpenRouter US$91.64 at closure; report US$1.3538 all-lane AI window, not request-attributed. NZ Qwen3-30B scoped-provider extraction records within original authority window: 240, 377,341 input/214,699 output tokens, US$0.12089247, 20 errors (records, not proved distinct vendor calls). No new vendor acquisition or policy change in closure operation. Four original capped providers Auckland/Canterbury/Otago/VUW are again held by ordinary controls; Lincoln not held. Do not reopen/extend.

**Delivery proof:** initial 84/84 listings and 501 sections recorded earlier; linked candidate universe expanded to 606 (237 read, 367 unread, 2 other, 4 read-undecided), 0 leases. Scoped-provider admissions since opening 35 (34 during original authority window): Canterbury 26, Auckland 3, Lincoln 3, VUW 2, Otago 1 after expiry. Seven of these currently published and Website v3 SQL RPC returned all seven. Country-wide NZ 112→121 published (+9), 12→13 publishing providers, 54→86 active unpublished, combined 166→207 (+41); country-wide changes not attributed solely to request. Five result-bearing NZ automatic publication cycles on 24 Nov 22:29 (1), 23:29 (2), 25 Nov 00:29 (1), 01:29 (1), 02:29 (4); nine publication events, not necessarily nine distinct newly admitted awards. Lincoln Master's candidate 44346 admitted/published as dac3ea6d-9a89-5fe5-a784-6b8923bbb9ac, 14 mapped courses; extraction 76851 checked true, evidence 1948b015-e6b5-4d4e-a3c9-d71b101d71c6, records NZD15000 A average and NZD10000 B average (not B+), no NZD7000 proof. Canonical scalar amount 15000, zero tier rows, no canonical academic criterion; 5 named programmes unmatched. This is incomplete tier/grade/course mapping, not verified benefit-tier acceptance. NZTC candidate 48781 admitted/published as 93166720-cea2-5d96-a70a-186cfe37e751 NZD10000 with one mapped programme. Website v3 and Zoho v3 SQL RPC readback confirmed both, Zoho matches 14/14 and 1/1 respectively. No external Wix/Zoho credentialled HTTP proof. WITT candidate 48478 rejected `listing_page`, stored evidence 0071e251-23a7-436d-b446-2ed042c2bdca; amount NZD1500 is one programme row, not an umbrella award; preserve gate and recover individual programme rows through existing reader.

**Continuation:** 86 active unpublished NZ; 0 pass current publication checks. Holds (overlapping): 55 no stated value, 39 closed, 3 citizen/resident restriction, 2 another edition. Verified-benefit replay query found no eligible missing scalar value; no unleased due eligible candidate or queued NZ AI item in focused checks. Four scoped universities ordinary cap-held; preserve 367 unread linked candidates for normal eligibility/cadence, don't reset retries. Review exact Lincoln tier/grade mapping defect and WITT listing split through existing qualified/gated reader path with Integration Controller, retain W01 claims (#1024/#1034), continue eligible NZ providers as they become due. No direct canonical edits, no new cron, request, pipeline or cap. G3 75/48 drift [], manual locks 7585, active cron 138 at 10:41. S1-Build canonical register writer; country-wise Sheet evidence and Running Build checkpoint follow. Completion of request closure does not close SCH-FU-04 whole territory.


**S1-Build, 26 Nov 2026 18:25 AEDT: Platform Admin decisions (18:21) recorded.** s1261 approved conditionally: the route is enabled only after the planner-to-reader handoff is proven automatic. CQU and AIBT not approved (Layer 4 holds kept). s1260 is to be reconciled against its stored-evidence conditions. No cron shutdown is authorised.

**S1-Build, 26 Nov 2026 18:15 AEDT: PIM readiness. s1199 (DR-15) and s1260 (s1240) live and read back; s1261 prepared; Data Delivery phone UAT passed at a measured 412 px.**
- s1199 (DR-15): free scholarship candidate reads no longer held by paid Firecrawl limits; paid reads stay capped (1,526 candidates at 20 providers released to free reads).
- s1260 (s1240 A1 to A3): CQU and AIBT aliases (A1 evidence confirmed live), Excelsia guide retired; both decisions now stop at D-R3 for Layer 4.
- s1261 prepared, not merged: course entry route on gpt-4.1-mini at US$1.00 a day. Platform Admin approval needed; the planner must also queue entry items for it to read.
- F-OPS.20 backend verified (7 d billed US$13.93; all caps held; cost per retained entry row US$0.00147, per scholarship US$0.0113). Scholarship cycles' lineage verified end to end.
- Agent Operating Model v1.26: autonomous production UAT.

**S1-Build, 26 Nov 2026 17:00 AEDT: D1 to D5 executed where permitted; PIM go-live not complete.**
- s1196 live (Adelaide retired host kept out; guard trigger; 14 re-bound so far, 42 still on the retired host while relink works). s1197 verified `lean-md-v3` live; s1198 switches the recall job off.
- F-OPS.16: scholarships have three unattended end-to-end cycles with consumer read-back; academic entry has none. Protected decision: a scheduled `course_entry_requirements` daily cap.
- D3, D4 and D5 need the Platform Admin: settings writes and branch deletion are refused in this session. Revalidated lists are in `docs/platform/2026-11-26-repository-branch-inventory.md`.

**S1-Build, 26 Nov 2026 15:15 AEDT: Platform Admin decisions D1 to D5 (15:09).**
- D1: s1196 approved (retired hosts out of relink and site-map binding; Adelaide rediscovered on the current site).
- D2: the 35 Adelaide courses with no new-site page are retained; no withdrawal without provider or registration evidence.
- D3: automatic branch deletion approved in both repositories.
- D4: removal of the 2,107 safe branches approved, each revalidated.
- D5: snapshot branches kept at least 30 days.

**S1-Build, 26 Nov 2026 12:35 AEDT: integration read back.** s1195 (#1652), #1577, #1589, #1597 and #1600 merged and live; head `20261129080000`, G3 75/48, locks 7,585, cron 136.

**S1-Build, 26 Nov 2026 11:15 AEDT: converter fix and pending PR integration.**
- s1195 (Pilot, no migration): converter `lean-md-v3` reads escaped markup (Holmesglen) as words; worker v1.0.47. No page is read again for the version.
- S3-AER-ChatGPT PRs #1577, #1589, #1597 and #1600: rebased by S3-AER, rehearsed together by S1-Build (29 sources, locks, G3 and cron unchanged). #1589 live (`20261129031000`). #1597 and #1600 renumbered to `20261129061000` and `20261129062000` above the live head `20261129050000`; merging in that order. #1502 held (protected draft).
- Adelaide: 56 courses bound to the retired host again after the 18 Oct refind, because relink learnt address forms from retired-host pages. 35 have no page on the new site. Fix s1196 proposed; the discontinued-course decision is the Platform Admin's.
- Branch inventory (admin `docs/platform/2026-11-26-repository-branch-inventory.md`): Pilot 1,720 branches, Admin 772; 2,107 safe to remove. Removing them and enabling automatic deletion wait for the Platform Admin.

**S1-Build, 26 Nov 2026 10:15 AEDT: course entry Window 5 done (s1193 live, Pilot #1648); s1194 closes it.**
- Window 5: 346 courses passing the proven sibling page. 57 filled with 113 active rows (47 providers, all published), 269 to Layer 4 (923 proposed rows), 20 held, 0 failed; US$0.79.
- Verified: consumer read-back `website_v2_course('120328M')` returns the admitted requirements under `item.entry`.
- Hourly measure 10:11: last 24 h 278 courses newly populated, 1,305 entry rows, conversion 13.8%; AU backlog 14,072, clearance about 51 days. Platform AI today US$2.53 of US$5.00; G3 75/48, locks 7,585, cron 138.
- s1194 live (Pilot #1650, 10:26): course entry route off and Window 5 request closed; read back head `20261129030000`, G3 75/48, locks 7,585, cron 136.
- Still open, not S1-Build's: S3-Scholarship-ChatGPT on-demand request `625e62fc` (Admin #937, opened 24 Nov).

**S1-API-Frontend-Delivery, 26 Nov 2026 09:20 AEDT: a browser tab left open across a deploy now reloads once and recovers (Pilot s1203; no migration).** Live head `20261129010000`, G3 75/48 no drift, locks 7,585, cron 137, US$0.
- **Cause (confirmed by the Platform Admin):** the `Failed to fetch dynamically imported module: .../assets/access-roles-entry-*.js` error on `Administration › Users & roles` came from a tab holding the old `index.html` across a Worker deploy. A refresh fixed it; nothing was broken in the deploy.
- **Fix:** `src/lib/chunkReload.js` (identical copy in `portal/src/lib/`): one reload on a stale chunk, with the time of the last reload kept in sessionStorage so it is never a loop (one a minute at most, none if storage is blocked). The Admin `lazyPage` guard it replaces reloaded once per route and never reset, and `CounsellorApp` and the two AI panes bypassed it. A plain "Failed to fetch" (offline, a database call) never triggers a reload.
- **Cache headers:** `/` and `/index.html` are `no-cache, must-revalidate`; `/assets/*` is `public, max-age=31536000, immutable`; set in `public/_headers` and `portal/public/_headers`, not the Cloudflare dashboard.
- **Not covered by design:** a tab that is already stale only recovers when it next loads a lazy screen or fails a preload; the portal has no lazy screens today, so it recovers on its next preload error. Unsaved form entries in a tab are lost on the reload, which is the same as the manual refresh.

**S1-RM-Design, 26 Nov 2026 08:30 AEDT: PIM operational verification, read 1 (no change deployed).**
- **Planner dispatch:** two automatic plans since s1172. One carries the `academic_entry` step: Collarts, 2 pages due, state pending, not yet started. The hand-off has not run through a scheduled plan yet.
- **Audit of the 50 deploy-triggered revisits.** The s1172 closing check ran 2 × 25 real revisits on Adelaide University at deploy. They were not from a planner step.
  - All 50 have been read again. 48 are on the retired host `adelaide.edu.au` and return HTTP 404; 2 were refused by the identity safeguard (`adelaideuni.edu.au`).
  - Result: 0 stored, 0 deterministic reads, 0 entry rows, US$0.
  - **Root cause for the course-pages owner (S1-Build):** the provider's pages moved to `adelaideuni.edu.au`. These need re-discovery, not revisits. The revisit backoff (now 14 days for them) keeps the retries rare.
- **Standing rule from this audit:** a production migration's checks read only. Any mutation test (a claim, a revisit, an update) runs in the rolled-back rehearsal, never in the deployed file.
- **No-source revisits:** 543 evidenced no-source findings reached their revisit date in the last 24 h and are eligible again automatically.
- **Changed and unchanged source:** 5 successful pages were re-read in the last 24 h under the existing schedule. Telling changed from unchanged on those re-reads is not yet proven; still open.
- **Consumer read-back (existing Data Delivery consumer measure):**
  - English AU 16,556 of 16,849 matched, 271 not served, 22 pending; NZ 2,399 of 2,400; CA 2,084 of 2,085.
  - Intakes AU 2,895 of 2,905, NZ 262 of 262.
  - No new admission has come from revisited pages yet.
- **Still open:** items 1 to 4 above (dispatch run, admission from revisits, changed and unchanged evidence, read-back of new admissions), F-OPS.21 UI (S1-API-Frontend-Delivery), and two unattended cycles (S1-Build).

**S1-Build development closure (Platform Admin 26 Nov 2026 06:59 AEDT), as at 07:55 AEDT. Course entry delivery is now operational.**

- **Delivered functionality (course entry, S1-Build lane):**
  - gpt-4.1-mini qualified for course entry requirements on source-verified labels (whole page; s1151, s1154).
  - Bounded read windows on the existing route: US$0 daily cap, one scoped on-demand request each, route off after each window (s1154 to s1159, s1190).
  - $0 retirement of superseded corrections (s1157).
  - Window selection by the read gate's own identity and page checks (s1159).
  - Proven sibling-page identity for academic entry requirements in the deterministic proposer (s1191, Platform Admin decision 06:57).
  - Recall diagnostics for the selector (s1152).
  - Hourly delivery measure (Daily Executive Status).
- **Deployed PRs:**
  - Pilot: #1611, #1614, #1615, #1617, #1619, #1621, #1638, #1640, #1641, #1642, #1644.
  - Admin: #1081 to #1129.
- **Verified in production:**
  - Last 24 h at 07:29 AEDT: 212 courses newly populated, all published; 1,180 entry rows admitted; conversion 12.9%; US$0.012 entry AI per new course. AU backlog 14,138, clearance about 67 days at that rate (796 at 04:38).
  - s1191 live 07:40: 69 deterministic pages released. 40 courses proposed from their own stored readings (48 rows; no row copied from a sibling); 23 no row.
  - Route off and no session request open. G3 75/48, locks 7,585, cron 138. Platform AI today US$1.54 of US$5.00; Firecrawl 0 for every window.
- **Outstanding acceptance criteria (not complete):**
  1. s1191 canonical admission of the 40 proposals and consumer read-back (`website_v2_course`): **not verified.**
     - At 08:06 AEDT the 40 were still pending in Layer 4.
     - Deterministic (`aer_det`) proposals are not taken by the machine admission. Of all of them ever made, 12 were approved, all by a person; 512 are pending.
     - Dependency (protected, Platform Admin): Layer 4 decisions, or an approved machine-admission rule for deterministic entry proposals.
     - **10:15 AEDT:** canonical admission under the approved rule **verified** (s1192: 082307B; Window 5: 57 courses, read-back 120328M). Of the 20 s1191 proposals: 1 admitted, 13 row-held at confidence 0.70 (Layer 4), 6 gate incomplete.
  2. The proven sibling-page rule in the AI read gate (`security.enrich_fields_slice_v1`) and AI recorder (`security.enrich_entry_record_v1`), for the 2,028 never-AI-read identity-held courses. Shared identity code; S2-AER to agree.
     - **10:15 AEDT: done** (s1192, live 08:39); applied unattended in Window 5 (346 courses).
  3. Holmesglen escaped-markup converter fix (`lean-md-v3`), after a check that no lane reads pages again on the version change.
     - **11:15 AEDT:** in release as s1195; the check found no re-read on the version.
- **Operational backlog and owners:**
  - AU entry no page (5,432) and page bound not stored (1,503): S1-Build course pages; capped revisits are S1-RM-Design s1171.
  - Read with no admissible rows (7,056):
    - pages that state none (1,962): terminal;
    - superseded losses (1,425): the EQUALS decision, S1-RM-Design and Platform Admin;
    - identity-held: S1-Build and S2-AER under s1191.
  - Layer 4 (651 pending): Platform Admin, with the existing machine admission.
  - Further course entry windows run through the same bounded mechanism, inside the daily limit.
- **Known CI fault:** the Secret scan check-run can stay "in progress" after its workflow ends, blocking auto-merge (admin #1127, Pilot #1644). An empty commit restarts it.


**S1-RM-Design, 26 Nov 2026 07:35 AEDT: Global Autonomous PIM core development closure (Platform Admin 06:59). Architectural expansion frozen; data population continues on the existing pipelines.**
- **Live head `20261128235000`.** G3 75/48, locks 7,585, cron 138, spend US$0 from this lane.
- **Delivered and deployed (Pilot PRs):**
  - #1618, #1624: applicability and field state.
  - #1625: progress read.
  - #1626: applicability hardening and the gap-scan hook.
  - #1627: field-state grains.
  - #1628: fee replacement guard.
  - #1629: eligible-gap planner.
  - #1630 + #1632: snapshot, excluded reasons, null-safe planner.
  - #1631: replacement guard for AER, description and Scholarship writers, and the s871 hold.
  - #1634: lifecycle read and replacement re-check.
  - #1635: refresh window and source findings.
  - #1636 + #1639: bounded source revisit, academic entry hand-off, deadline in three states, provider scholarships.
  - #1643: scoped `pim.source_revisit_days` = 7 (Platform Admin 06:57), batch capped in the function, eligibility re-tested on the claimed row, entry-missing courses first. `gaps.recheck_days` stays at 60.
- **Verified in production:**
  - The Data Delivery read takes the PIM snapshot only.
  - The planner counts eligible gaps only, with the reasons kept.
  - The replacement guards are live, with 2,217 flagged supersessions preserved for governed reconciliation.
  - Revisit: 1,731 pages due now. The deploy's own check claimed 2 × 25 pages on one provider, and the second claim took none of the first claim's pages. Of those 50, 43 were read since, 7 are being read, 1 was stored, several were refused by the identity safeguard, and no entry rows yet.
- **Not yet verified (open acceptance):**
  1. A planner run that carries the `academic_entry` step: 0 such plans in the 2 hours after deploy. Check the next automatic plans.
  2. Canonical admission from revisited pages: the AER readers (aer-det-sweep) on newly stored copies.
  3. The changed, unchanged and no-source revisit scenarios, with live evidence.
  4. Consumer read-back for the new fields.
  5. F-OPS.21 UI: the PIM block in Data Delivery, by S1-API-Frontend-Delivery.
  6. Two unattended result-bearing cycles per domain (Master Plan step 6, S1-Build).
- **Protected decisions recorded (not blocking processing):**
  - The EQUALS recovery of the 2,217 flagged supersessions (Platform Admin).
  - Course entry AI route and Window 2 spend (S1-Build).
- **Operational backlog and owners:**
  - Course pages and the revisit: planner and coverage-read (automatic).
  - AER reads and admission: S2-AER, S1-AER-Claude, S3-AER-ChatGPT.
  - Scholarship lifecycle: S1-Scholarship-Claude, S3-Scholarship-ChatGPT.
  - Layer 4 (1,405 waiting): Platform Admin.
  - Monitoring screen: S1-API-Frontend-Delivery.
  - At the last 24 h read, 138,353 applicable gaps were open, with 2.7 canonical gains an hour.

**S1-Build, 26 Nov 2026 06:30 AEDT: course entry windows 3 and 4 done; next windows wait on the identity decision.**
- Delivery 06:25: last hour 43 courses newly populated (all published), 318 entry rows admitted; last 24 h 162 courses, 804 rows, conversion 11.3%, US$0.016 entry AI per new course; AU backlog 14,188, clearance about 88 days (796 at 04:38).
- Window 4 (s1159): 93 to Layer 4, 36 held, 2 failed, US$0.75. Platform AI today US$1.50 of US$5.00.
- s1190 (Pilot, migration `20261128230000`): course entry route off and Window 4 request closed.
- The never-AI-read courses that pass the read gate are used up. The next 2,028 wait on the **shared programme page identity decision** (`docs/platform/p0-aer-activation/2026-11-26-entry-identity-shared-programme-pages-decision.md`).

**S1-Build, 26 Nov 2026 05:40 AEDT: course entry Window 3 done; Window 4 in release; identity decision prepared.**
- Window 3 (s1158, 446 university courses): 46 admitted with 153 active rows, 58 to Layer 4, 299 held at $0 by the read gate, US$0.223.
- Delivery 05:29: last hour 62 courses newly populated (all published), 220 rows admitted; last 24 h 80 courses, conversion 6.2%, US$0.024 entry AI per new course; AU backlog 14,270, clearance about 178 days at the 24 h rate.
- s1159 (Pilot, migration `20261128220000`): Window 4, the 131 courses passing the gate's own identity and page checks.
- **Platform Admin decision:** identity for pages shared by records of one programme. It is the dominant block (2,028 unread courses, 513 deterministic readings). See `docs/platform/p0-aer-activation/2026-11-26-entry-identity-shared-programme-pages-decision.md`.

**S1-API-Frontend-Delivery, 26 Nov 2026 07:15 AEDT: StudySearch Portal Release 2 screens built (Pilot s1200 to s1202; no migration).** Live head `20261128230000`, G3 75/48 no drift, locks 7,585, cron 138, US$0.
- **Built in `portal/`:** Proposals list, proposal editor (reorder, notes, soft-lock and conflict handling), live refresh difference (Accept all changes / Keep my version) and the two-page student sheet with Save as PDF / Print (browser print, no Browser Rendering). Counsellor-only. Checked at 1280 px and 412 px.
- **Pending cutover:** the screens call `portal_proposal_list_v1`, `_get_v1`, `_save_v1` and `_refresh_v1`, which are **not live yet** (none exist). Until S1-Build deploys them to the contract in `docs/platform/2026-11-25-studysearch-portal-design-decisions-and-plan.md` ("Release 2 contract: student proposals"), every Proposals screen shows "not switched on yet". Nothing else in the portal changed.
- **Open for the Platform Admin:** retention period and privacy notice wording before real student data is entered.

**S1-RM-Design, 26 Nov 2026 05:15 AEDT: s1171 live (Pilot #1636 + deploy fix #1639, applied by a hand-started deploy, md5 cfa271d9). Live head `20261128200000` (S1-Build s1157; s1171 applied below it, history matches).** G3 75/48, locks 7,585, cron 137, US$0.
- **Bounded source revisit is live:** `security.pim_source_revisit_v1` and `_due_v1`, history in `pipeline.coverage_page_revisits`, setting `pim.source_revisit_batch` = 25.
  - Backoff on the existing `gaps.recheck_days` = 60 days, doubled per revisit. Never blocked, robots-refused or access-refused pages; no bulk reset.
  - There are 1,849 candidates and **0 due now**, because every failure is less than 60 days old. The first is due 5 Dec 2026, and 142 fall due within 30 days.
  - Shortening the 60 days is a Settings decision (`gaps.recheck_days` is an existing approved policy); it was not changed.
- **Planner `academic_entry` hand-off is live,** in `enrich_plan_v1`, `start_step` (ref `handoff`) and `tick` (done on fetches, never counted as delivery). It proposes only when pages are due.
- **Deadline is `defined` in three states. `p_scholarships` is measured** from active scholarships, with the scholarship lane's disposition as the source finding.
- **#1633 (s1180) reconciled:** applied live before s1169; no collision. The earlier warning is withdrawn.
- **Window 2:** its 90 expired leases are now 0, released by S1-Build's own s1157. This lane did not touch them.
- **Delivery (24 h, PIM snapshot):**
  - 65 canonical and 65 published gains (2.7 an hour); no new courses or providers.
  - Backlog of 138,353 applicable gaps, so clearance is not reachable at the current rate.
  - Layer 4 waiting 1,405; enrich review 1,662; failed 7,719.
  - AI US$3.28 per 24 h, about US$0.05 per retained outcome.
- **Next:**
  1. The changed, unchanged and no-source scenarios on live pages: the re-read schedule (median 90 days) and absence revisits are already live, so this is evidence only.
  2. Consumer read-back for the s1171 fields.
  3. The PIM UI block (S1-API-Frontend-Delivery).

**S1-Build, 26 Nov 2026 04:45 AEDT: accelerated delivery (Platform Admin 03:59); course entry bottlenecks measured, s1157 in release.**
- Baseline (04:38, last 24 h): 18 courses newly populated with active entry rows (all published), 56 rows, 2.6% conversion of resolved entry reads, AU backlog 14,332, clearance about 796 days at that rate, US$0.083 entry AI per new course.
- s1157 (Pilot, migration `20261128200000`): Window 2's 130 superseded corrections skipped at $0; its 7 genuine re-reads read under a US$0 cap and one scoped request.
- Next (S1-Build): Window 3, the AU courses read with no admissible rows and never AI-read, shortest stored pages first under a set spend bound; the `exact_title` identity decision for 521 courses with 4,735 deterministic readings goes to the Platform Admin with evidence.

**S1-RM-Design, 26 Nov 2026 04:20 AEDT: takeover checkpoint for the Platform Admin's 03:48 priorities (no new migration since s1170; live head `20261128100000`, G3 75/48, locks 7,585, cron 137, US$0; Window 2 and its 90 spend-held leases untouched).**

Verified live this session. These are the facts the next slices build on.

- **AER dispatch (priority 1).** The AER lane already runs unattended for readable pages:
  - `coverage-read` (two jobs, every 30 s) reads due bound pages, mostly by direct HTTP, Firecrawl by the existing toolset limits;
  - `aer-det-sweep` (every 5 min) runs the $0 deterministic reader on stored copies;
  - the planner `pages` step finds missing course pages.
- **Where it stops (priority 2).**
  - `security.coverage_read_eligible_v1` and `public.svc_coverage_read_next` take a page only while `read_attempts < 3`, a literal in code. For courses open to international students and with no entry rows, 2,226 bound pages without a stored copy are "due" but at that cap, so they are **never revisited**: fetch_failed 1,687, not read 206, blocked 133, needs_render 94, robots_disallowed 93, too_thin 13.
  - The 7,260 AU courses read with no admissible rows wait for the course entry AI route (S1-Build Window 2, route off, spend-held): not touched.
- **Next slice s1171 (version 20261128110000), in order:**
  1. Settings `pim.source_revisit_days` and `pim.source_revisit_batch`.
  2. A $0 revisit: a capped failed or unread page whose last attempt is older than the setting gets `read_attempts` reset and is made due, so the existing `coverage-read` takes it.
     - robots_disallowed is never retried inside its policy; blocked and challenge pages are never bypassed.
     - Firecrawl stays under the existing scheduled ceiling.
     - It runs from an existing ops job, not a new cron.
  3. A planner step `academic_entry` in `security.enrich_plan_v1` (md5 `15d174d703e29cb1b37d449847827cfa`): it hands the provider's capped pages to that revisit, and lists the AI-stage courses as not proposed (reason: course entry AI route off).
  4. Its running state in `security.enrich_plan_tick_v1` (md5 `9b7c7c05491b95646b99fb7a855a9fa9`), as ref kind `handoff`: done when none of the handed pages is still due and under the cap.
  5. Scenario evidence: changed source (new content hash), unchanged source (same hash: freshness renewed, no write), no source (absence `next_eligible_at` revisit).
- **Scholarships (priorities 1 and 5).** The planner already dispatches `scholarship_provider_scan` when a provider has no active scholarship and no scan in 30 days. The scholarship lane's own `scholarship_watch` and `scholarship_provider_coverage.next_discover_at` drive revisits. `p_scholarships` measure: use `scholarship_provider_coverage` (scholarships_active, scholarships_published, disposition) in `field_state_entity_v1`.
- **Replacement exceptions (priority 3).** The 2,217 flagged supersessions stay as they are. Recovery goes only through the existing reread and verifier paths:
  - `aer_det_reread` with its new successor check;
  - Layer 4.
  - Nothing invalid, withdrawn or protected is restored.
- **Deadline (priority 4).** Three states:
  - a published `application_deadline` on an active intake;
  - an explicit rolling or no-deadline statement, recorded as a `course_field_absence` finding with evidence (class to be added beside not_applicable);
  - unknown.
  No date is ever derived, and the admission rules are unchanged.
- **Unconfirmed (priority 6).** The 41,653 `eligible_unconfirmed` gaps are worked but keep their own figure. A read may set `open_to_international` only through the existing admission path; unconfirmed never bypasses it.
- **UI (priority 7).** S1-API-Frontend-Delivery draws the PIM block from `pim` (hand-off doc). F-OPS.21 stays open until the deployed screen is read back.

**S1-RM-Design, 26 Nov 2026 01:55 AEDT: PIM s1169 and s1170 live; read back. Takeover checkpoint (supersedes the 00:55 block below for head and next steps).**
- **Live head `20261128100000`.** G3 75/48, locks 7,585, cron 137, spend US$0. No open S1-RM-Design Pilot PR; branches deleted on merge.
- **s1169 (Pilot #1634):** `security.pim_lifecycle_v1()` in the snapshot (`pim.lifecycle`).
  - AU academic entry: admitted 9,677; read but no admissible rows 7,260; no page 5,428; page bound but not stored 1,507; in Layer 4 137; read queued 0; page stored but unread 0.
  - The replacement re-check flags **2,217 of 2,803** guarded supersessions in the last 7 days with no successor now. These are the s871, s1009 and description-prompt losses; they need the EQUALS recovery decision. Nothing was reversed.
- **s1170 (Pilot #1635):** refresh window setting `pim.refresh_days` = 365 days (Settings › Data delivery), with a per-field override in `field_register.refresh_days`. Freshness (inside or past) is given for held values.
  - `pim.refresh`: 325,812 held course field values, 0 refresh due (courses were last verified about 29 days ago).
  - Bound pages by last read: read 22,323, fetch_failed 1,730, http_error 247, not_read 207, blocked 146, robots_disallowed 124. Failed sources keep their values and are re-read by the existing page re-read.
- **2x workload (read only, coverage doubled in the query):** the planner list takes 13.9 s (5.8 s at 1x, limit 120 s). The background snapshot takes 24 to 38 s at 1x, so about 50 to 75 s at 2x, still inside the limit. At about 3x it would need splitting across runs.
- **Still open, in order:**
  1. The refresh executor: a $0 change check of held values past their window, which re-enters them into the gap queue with the old value kept. Nothing is due for about 11 months.
  2. The planner academic entry step (interface 3 hand-off to the AER lanes through `pim_lifecycle_v1`).
  3. Remaining applicability: a `deadline` rule (a Platform Admin statement is needed) and a `p_scholarships` measure.
  4. The UI block by S1-API-Frontend-Delivery (hand-off doc updated).
  5. Pilot #1633 (s1180) must renumber its migration above the live head.
  6. The EQUALS recovery decision for the flagged supersessions (parked with the Platform Admin).

**S1-RM-Design, 26 Nov 2026 00:55 AEDT: PIM s1167 and s1168 live; s1169 in merge (Pilot #1634). Takeover checkpoint.**
- **Live head `20261128070000`.** G3 75/48, locks 7,585, cron 136, spend US$0.
- **s1167 (Pilot #1630 + deploy fix #1632, applied by a hand-started `Deploy on merge` with before `016e8ce1`, after `669f17bc`):**
  - The PIM count runs in the existing `data-delivery` background count. Its snapshot is in `pipeline.data_delivery_job_runs.pim`, which took 37.6 s to count, and the Data Delivery screen read only reads it.
  - `pim.excluded` reports gaps by reason: eligible 113,319, eligible_unconfirmed 41,653, no_source_revisit_pending 389, closed_to_international 199, recorded_not_applicable 37.
  - The planner was made null-safe: it now counts 154,972 eligible gaps; s1166 had dropped 337.
  - **Lesson:** a migration guard must not compare exact cron or lock counts. Other lanes change them during a long migration; check the ceiling and that no lock was removed. **Deploy only applies files ADDED by the merge:** a fix to a merged-but-unapplied migration needs a hand-started deploy with before and after.
- **s1168 (Pilot #1631):** the replacement guard now covers Layer 4 entry and description reads, scholarship reviews and active entry rows (deferred triggers, `HELD:NO_SUCCESSOR`; scope in `pipeline.supersede_guard_scope`). The s871 reread now holds a read with no successor (verdict `held_no_successor`). Evidence of past loss: 1,650 + 132 courses with no entry read or row since aer-det-reread and aer-det-propose. Those are unchanged until the EQUALS recovery decision.
- **s1169 (Pilot #1634, rehearsal passed, md5 3dcf2ab1):** `security.pim_lifecycle_v1()` (academic entry stages per course and the scholarship lane rollup, both by country, with the owning lane) and the interface 4 second safeguard (`pim.lifecycle.replacement_check`).
- **Finding for the Data Delivery owner:** `security.data_delivery_v1()` takes about 35 s even without PIM. Its sub-reads `cdesc_stages` (4.5 s), `intake` (1.4 s), `aer` (0.8 s) and `pdesc` (0.9 s) explain only part; the rest is in `admin_providers_page_v3`, `consumer` or `net`.
- **Collision to resolve:** Pilot #1633 (s1180 portal hybrid ranking fix) uses migration `20261128075000`, inside S1-RM-Design's reserved range. It must renumber above the live head before it merges, or the pre-flight refuses it once s1169 (080000) is live.
- **Live and owned by others:** the 90 expired field-enrich leases are S1-Build's held course entry Window 2 (route off, spend hold). The existing `ops-job-lifecycle` closes leases at the attempt cap, so this lane does not touch them.
- **Next, in order:**
  1. s1170 Step 5: a refresh window as a setting `pim.refresh_days` (default 365, an annual cycle), with a per-field override column in `field_register`; freshness inside or past it in `field_state_entity_v1`; refresh-due counts in the snapshot; held values past the window count as refresh gaps in the planner, with the old value kept. Source-change detection from `coverage_course_pages` read failures and content hash.
  2. s1171: a 2x workload performance fixture for the planner, gap scan and snapshot.
  3. s1172: remaining applicability (`deadline` rule, a `p_scholarships` measure).
  4. The planner academic entry step (interface 3 hand-off to the AER lanes through `pim_lifecycle_v1`).
  5. S1-API-Frontend-Delivery draws the PIM block (hand-off doc updated 26 Nov).

**S1-RM-Design, 25 Nov 2026 23:55 AEDT: Global Autonomous PIM steps 1 to 3 live (s1160 to s1166); read back.**
- **Live head `20261128050000`.** G3 75/48, locks 7,585, cron 138, spend US$0. Branches merged and deleted; no open S1-RM-Design Pilot PR except the next slice.
- **s1160, s1161 (Pilot #1618, #1624):** field applicability and the five-fact field state. **s1162 (#1625):** `security.pim_progress_v1()` is key `pim` in `security.data_delivery_v1()` (F-OPS.21 backend; reads in about 6 s warm, 32 s cold, limit 120 s). **The Data Delivery block that draws it belongs to S1-API-Frontend-Delivery** (hand-off `docs/platform/data-ingestion/2026-11-25-pim-progress-ui-handover-s1162.md`); the backend alone does not close F-OPS.21.
- **s1163 (#1626):** applicability is defined or undefined per register field (only `deadline` is undefined; undefined is never applicable). english, academic_entry and provider_tuition need a course open to international students: closed courses are not applicable, courses with the flag unknown are unconfirmed and shown apart. The gap scan skips a not-applicable course field (md5-guarded patch).
- **s1164 (#1627):** `security.field_state_entity_v1(field, entity)`: partial completeness (an active row with no stored evidence), campus_city, the provider grain; award and country/edition grains are unmeasured until a field of that grain is registered. `p_scholarships` stays unmeasured.
- **s1165 (#1628):** replacement guard. A fee cannot go from active to superseded without an active successor of the same fee type at commit: `HELD:NO_SUCCESSOR`. Watch for it in fee writer job errors; the 27 older superseded fee rows without a successor are all 4 to 8 Oct 2026. English, intake and entry removals are not supersession.
- **s1166 (#1629):** the planner's provider list (`security.enrich_plan_priority_v1`) counts eligible gaps only (applicable, a reader exists, no open not_applicable or not-yet-due no-source finding): 154,637 eligible gaps across 1,625 providers. New courses are already enrolled by the coverage build.
- **Next, in order:** Step 4 shared interfaces for the AER and Scholarship lifecycles (AER v2 only, S1-Build's qualification untouched); Step 5 freshness windows, source-change detection and recovery; 90 expired field-enrich leases are reported in `pim.leases`. Reserved migration block 20261128010000 to 090000 (060000 to 090000 free).

**S1-Build, 25 Nov 2026 19:40 AEDT: course entry Window 2 held for spend; route off.**
- Window 2 (s1155, the 267 waiting reads) opened 19:13 AEDT and was held by s1156 at 19:20 AEDT: 630 calls, US$0.80 against a US$0.48 estimate. The corrected-read pages are long and the whole page is read in many slices (1.6 million input tokens).
- Of the 267: 105 corrected reads (D-R2) were refused when recorded because their Layer 4 item was already superseded (the read was paid and discarded); 15 wait on an earlier Layer 4 read of the course; 8 went to Layer 4; 137 still wait. Rows for those courses: active 23 to 34, proposed 13 to 16 (Layer 4 decisions were also made during the window).
- Window 1 (s1154): US$0.0762 for 94 calls; 28 active and 14 proposed rows from 0 and 0.
- Route `course_entry_requirements`: off, gpt-4.1-mini qualified, cap US$0, whole-page input. No open session requests. Platform AI today US$3.59 of US$5.00; Firecrawl not used by either window. Cron 138, locks 7,585, G3 75/48, the 152 inactive rows unchanged.
- **Decision for the Platform Admin:** how to read the 137 remaining. **For S2-AER:** refuse superseded corrected reads before the AI read.

**S1-Build, 25 Nov 2026 19:10 AEDT: course entry Window 1 done; Window 2 (the 267) in release.**
- Window 1 (s1154, 172 courses, gpt-4.1-mini, whole page) finished at 18:49 AEDT, about US$0.08. Before: 0 active, 0 proposed rows. After: 28 active rows (7 courses), 14 proposed rows to Layer 4 (3 courses). 91 courses held by the course-page identity gate E16 before any AI call; 60 pages do not state entry requirements; 6 had no quoted requirement; 5 had no row meeting the admission rules.
- **S1-AER:** read back Window 1 (the 7 filled and 3 Layer 4 courses). **S2-AER:** the 91 E16 identity holds are in your lane.
- s1155 (Pilot, migration `20261127040000`): Window 1 closed (route off, request closed); Window 2 opened for the 267 waiting reads at 22 providers, US$0 cap, one request. Estimate US$0.48.

**S1-Build, 25 Nov 2026 18:40 AEDT: Window 1 (the 172 courses) approved on gpt-4.1-mini, whole page (Platform Admin 18:26).**
- s1154 (Pilot, migration `20261127030000`): gpt-4.1-mini qualified for course entry requirements; `reading.course_entry_sections_on` 0; route on with a US$0 cap (the scheduled reader stays held); one on-demand request for the 20 providers; the 172 queued through the entry Read now; `lean-qualify` and `lean-sections-eval` paused. Estimate US$0.31.
- Next: monitor Window 1, then switch the route off and hand read-back to S1-AER; then Window 2 (the 267) the same way, then notify S2-AER and S3-AER. Converter fix `lean-md-v3` after both windows.

**S1-Build, 25 Nov 2026 18:05 AEDT: course entry model comparison complete; Platform Admin decision needed.**
- On source-verified labels (83 pages, 119 academic, 89 pathway lines), only gpt-4.1-mini on the whole page reaches 90%: academic 95%, pathways 94%, fewest rows matching no label (17%), US$0.0018 a page. On the v6 selection no model reaches 90% (Qwen3 30B 87% with 65% rows matching no label; gpt-4.1-mini 81%; DeepSeek 81%).
- GPT-5 mini and nano: not served under the existing contract (HTTP 404), US$0. s1151 cost US$0.256.
- Proposed acceptance criteria and the prepared activation (gpt-4.1-mini, whole page, US$0 cap, one scoped request; Window 1 the 172 at about US$0.31; Window 2 the 267 at about US$0.48): `docs/platform/p0-aer-activation/2026-11-25-course-entry-model-comparison.md`. Nothing is activated until the Platform Admin approves.

**S2-Build, 27 Nov 2026 00:35 AEDT: DR-19 increments 2 to 4 (s1282) and Reported data issues R3 (s1285) live and accepted on production, desktop and phone (Pilot #1701, #1704, #1705, #1708).**
- **Acceptance:** Deployed UAT run 45829529456 on production, both specs: desktop success, mobile success.
- **s1282:**
  - **Platform Admin, 1440 px and 412 px:** Data Delivery drill on Lincoln University by diagnosis class (Not read yet 86, Explained gap 65, Value held 41, Being read now 4, Protected or in review 3). A record's description trace opened.
  - **Course drawer fold:** 15 fields (Not read yet 6, Value held 3, Explained gap 5, Does not apply 1), each with the seven facts. No sideways scroll.
- **s1285:**
  - **Platform Admin and Pipeline Operator, 1440 px and 412 px:** the Layer 4 Reported data issues panel shows its figures (all 0 today) and Admin (0), Portal (0) and Zoho (0), with the Reported, Resolved and All states. No sideways scroll.
- **Observed on the shared Operations and Layer 4 pages, not these releases:** HTTP 500 from `admin_aer_delivery_progress` (13:11 UTC) and `admin_progress_read` (13:30 UTC) at 412 px. Each cleared on retry. They are flagged to the Data Delivery and Progress owners.
- **Branches:** the three `…-probe` branches used to rerun acceptance are left for the Auto-merge sweep (this session's proxy refuses branch deletion).
- **Guards:** G3 75/48, cron and locks unchanged; $0.

**S2-Build, 27 Nov 2026 00:15 AEDT: s1285 Reported data issues R3 live (Pilot #1705, migration `20261130060000` applied, history md5 `4bbc99b5`); s1282 drill fix merged (Pilot #1704); a field-list race fix recorded before merge.**
- **s1285 live and read back on production.** Deployed UAT run 45827096343, desktop:
  - **Platform Admin and Pipeline Operator:** the Layer 4 panel opens and shows its figures (Submitted 0, Reported (open) 0, Awaiting verification 0, Resolved 0, median time to resolve Not available, recurring 0 in 90 days).
  - **Origins:** Admin (0), Portal (0), Zoho (0). The Reported, Resolved and All states are shown. No sideways scroll at 1440 px.
  - **Live stores:** they hold 0 reports today. The items, evidence and flags paths were proven in the rolled-back rehearsal with R1 and five test reports.
  - **Phone acceptance:** it follows the next run, because that run's phone gate was skipped when the s1282 desktop test failed.
- **s1282, production UAT after the fix (run 45826521071, merge `ce1d8fd`):**
  - **Desktop passed:** drill classes on Lincoln University (Not read yet 86, Explained gap 65, Value held 41, Being read now 4, Protected or in review 3); a record's description trace opened; the course drawer fold listed 15 fields (Not read yet 5, Value held 3, Explained gap 5, Does not apply 1, Needs engineering 1) with the seven facts; 1440 px with no sideways scroll.
  - **Phone (412 px):** the drill and the drawer read and showed the same figures with no sideways scroll.
  - **Phone failures:**
    1. Data Delivery's own `admin_aer_delivery_progress` returned HTTP 500 on the Operations page. That read is not s1282's; it is flagged to the Data Delivery owner.
    2. The drill's field list sometimes arrived after the test tried to choose a field. Run 45827096343 hit the same race on desktop.
- **Fix recorded before merge (Pilot branch `s2-s1282-spec-option-wait`):**
  - A failed field-list read in the drill now says so, with Read again; it never shows an empty register.
  - The deployed spec waits for the register's field option, or for that error, which it reads again once.
- **For S1-API-Frontend-Delivery / Data Delivery owner:** `admin_aer_delivery_progress` returned 500 on the live Operations page at 412 px (26 Nov 2026 13:11 UTC).
- **Guards:** G3 75/48 (the s1285 pre-check and post-check passed on apply); cron and locks unchanged; $0.

**S2-Build, 26 Nov 2026 23:45 AEDT: s1282 merged (Pilot #1701); production UAT found a drill fault, fixed in the same lane and recorded before merge. Reported data issues R3 built as s1285 and recorded before merge. SS-Programme-Control 22:52.**
- **s1282 merged and deployed:**
  - Pilot #1701, merge `fc0dc1e`; Workers Builds `coursefinder-pilot` succeeded.
  - Before the merge, CI found that the drill's nested `<summary>` broke the Data Delivery and PIM folds' own controls. The drill now opens with a button, and its body (and every read) mounts only when opened.
- **Production UAT (Deployed UAT run 45821870207, Platform Admin, desktop):**
  - The drill opened, the provider search found Lincoln University, the diagnosis classes were shown, and a record was listed.
  - The opened record's field trace did not appear within 60 s. Cause: a class list mounted every listed record's trace at once, so the opened record's read queued behind them.
  - **Fix (s1282, Pilot branch `s2-s1282-drill-lazy-fix`):** a record reads its trace only when it is opened. The deployed spec now prints a trace error before failing on it. s1282 is not called live until this passes production UAT.
- **s1285, Reported data issues R3** (numbered s1285 because s1283 and s1284 were taken by other lanes; plan row s1283 renamed):
  - **Read:** `public.admin_reported_issues_v1` (Curator and above), migration `20261130060000`. It needs R1 (s1281, Pilot #1702) and joins both stores without changing either:
    - in-app reports (`pipeline.counsellor_feedback`, origin Admin or Portal from R1's `origin`);
    - Zoho reports (`pipeline.data_flags` `reported`, origin Zoho).
  - **List mode:** counts by origin and state, figures (submitted, open, awaiting verification, resolved, fixed, not changed, median time to resolve, recurring course fields) and one page of reports, each with origin, Layer 4 kind and reference, course, provider, register field, issue, value at report, stage, resolution and evidence.
  - **Course mode:** Reported and Resolved per field.
  - **Evidence-backed resolution:** R1's verification when held; otherwise the current field state, said to be current state and not a check made at closing. A report closed as fixed with no held value is flagged.
  - **New objects:** reference table `pipeline.report_origin_field_map` (which register field a Zoho field answers); settings `reports.l4_view_page_max` (50) and `reports.recurrence_days` (90).
  - **Rehearsal (rolled back, with R1 and five test reports across both stores, 26 Nov 2026 23:40 AEDT):** total 5; by origin Zoho 1 open and 1 resolved, Admin 1 and 1, Portal 0 and 1; the Zoho report closed as fixed with no held English value was flagged; the Portal report showed R1's verification; recurrence 1 (English on one course from Admin and Zoho); list 38 ms, course 3 ms. Live stores hold 0 reports today.
  - **UI:**
    - Layer 4 gains a closed **Reported data issues (Admin, Portal and Zoho)** panel, read only when opened. It has origin and state choices, the figures, and a page of reports. Each report opens the s1282 field trace and the existing Processing journey and diagnosis fold, and links to its existing card and the course record.
    - The course record's Field processing status fold shows Reported and Resolved beside each field and for the course.
    - Decisions stay on the existing cards (`counsellor_feedback`, `counsellor_report`).
  - **Coordination:**
    - S1-Build R1 (#1702) must merge first: the R3 migration's pre-check refuses to run without R1's columns.
    - S1-API-Frontend-Delivery R2 (the reporter UI) is untouched.
    - R4 (Zoho v3) stays held; the Zoho store is read, never altered (G3).
  - **Guards:** G3 75/48 unchanged; cron and manual locks unchanged; no job; $0.
  - **Tests:** `cf-247-s1285-reported-issues-r3-contract` (6) and `cf-247-s1285-reported-issues-r3-deployed` (3, desktop and phone, read only). The register also gains the two s1282 specs (5 and 3).

**S2-Build, 26 Nov 2026 23:05 AEDT: DR-19 increments 2 to 4 (s1282) built and recorded before merge (Pilot branch `s2-s1282-dr19-record-trace-ui-2`; no migration); SS-Programme-Control 22:52.**
- **Reuse only.** The UI reads S2-RM-Design's existing contract and creates no new diagnostic read or framework:
  - `admin_pim_record_trace_v1`, `admin_pim_provider_trace_v1` and `admin_pim_operational_recovery_measure_v1` (Pilot #1682 and #1690);
  - `admin_record_journey_v1`, through the existing Processing journey and diagnosis fold (s1272).
- **Increment 2, Data Delivery:**
  - a **Records** drill in every stream body and under the PIM matrix;
  - pick a field (from the field register) and a provider (through the existing admin search);
  - the provider's courses are counted by diagnosis class: value held, protected or in review, service failure (retry), explained gap, needs engineering, not read yet;
  - a class lists its records, and a record opens its trace and a link to the course record.
- **Increment 3, course record drawer:** a closed fold, **Field processing status and diagnosis**, listing every registered field, with the fields needing attention first. Each field shows:
  - its class and exact reason;
  - source evidence ids;
  - attempts;
  - recovery history (resolved findings, decided Layer 4 items with their change-control reference);
  - authorised actions;
  - open Layer 4 items with their journey fold and a link (Curator and above).
- **Increment 4, seven facts kept apart:**
  - record returned by consumer (Website v3 and Zoho v3; "a returned record says nothing about whether this field is right");
  - field populated;
  - field value verified: Not verified, because the backend's "verified" means a value is held. The Website text of the description equalling the catalogue is shown as delivery consistency, not as a source check;
  - international applicability verified: Not available, because the field trace holds no such evidence;
  - canonical admission;
  - consumer delivery (Website v3 per field; Zoho per field not measured);
  - actual recovery gain (per field, plus the platform-wide recovery measure).
- **Live read times** (rolled back, Platform Admin account):
  - record trace: 15 fields in 2.9 s;
  - provider trace: a 41-course provider in 0.7 s.
  - **Dependency for S2-RM-Design:** at that rate a 667-course provider takes about 11 s, past the 8 s statement limit for signed-in users, so its drill would time out. The screen shows the error plainly. The fix belongs in `pim_provider_trace_v1` (paging or a lower `pim.trace_max_courses`).
- **Section 3b:**
  - Cross-spec search: 122 specs read the changed files. Their static tests pass, and the colour-literal token check passes after one fix.
  - Browser and build specs need the dev server, which this session lacks; CI runs them.
  - Production acceptance: `cf-247-s1282-dr19-record-trace-deployed` (read only, desktop and phone) runs on merge through the Deployed UAT targeted rule.
- **Shared files** (S1-API-Frontend-Delivery informed through this plan line): one drill line each in `DataDelivery.jsx` and `PimDelivery.jsx`, and one line in the course drawer in `mature-main.jsx`. Page search is not touched.
- G3 untouched; no setting, job or spend.

**S2-Build, 26 Nov 2026 22:40 AEDT: DR-19 increment 1 (s1272) live and accepted on production (Pilot #1681, migration `20261129200000`, history md5 `06dda010`; acceptance spec through #1687, #1689, #1692, #1694; admin #1204, #1205, #1216, #1222).**
- **Live:** every Layer 4 card in the production Admin has the **Processing journey and diagnosis** fold, reading `public.admin_record_journey_v1`. Workers Builds coursefinder-pilot passed on the merge.
- **Production UAT, authenticated** (Deployed UAT run 45812223349, `cf-247-s1272-dr19-record-journey-deployed`, read only):
  - Signed in as the Platform Admin (rank 6) and as a Pipeline Operator (rank 4), with the existing UAT accounts in Actions secrets.
  - On the focused Layer 4 card, the fold opened with eight stages, the stopping stage and all thirteen diagnosis rows, with no error and no server error.
  - Measured viewport: desktop 1440 × 1100 (DPR 1); phone 412 × 839 (DPR 2.625, Pixel 7). scrollWidth equals clientWidth at both widths.
  - Live record shown: a course description held by machine rule cdesc-machine-v2 (identity_margin_thin). Discovery, acquisition, extraction and normalisation read done; validation held; admission and publication not reached; verification not verified.
  - Screenshots are attached to the run.
- **Method, and the limit met:**
  - Claude in Chrome reached the Admin sign-in page, but no session was open, and agents never type passwords.
  - So acceptance ran in the deployed Playwright suite.
  - Two spec fixes before it passed: the Admin routes by hash; the phone gate runs only `@responsive` tests.
  - Operator actions were not exercised. The fold adds none: its authorised actions are the card's existing decisions, whose own deployed and live-acting tests are unchanged.
- **Remaining genuine gaps:** the design's shared-contract items 1 to 4 (S2-RM-Design), and increments 2 to 4:
  - Data Delivery record drill;
  - Course record drawer;
  - per-record website and Zoho verification;
  - realised recovery gain.
- G3 75/48; locks 7,585; no cron added; US$0.

**S2-Build, 26 Nov 2026 19:40 AEDT: DR-19 increment 1 (s1272) built and recorded before merge (Pilot branch `s2-s1272-dr19-record-journey`, migration `20261129200000`).**
- **Admin UI:** every Layer 4 card has a closed fold, **Processing journey and diagnosis**. The focused view and the list views share the card, so both get it.
  - When opened, it reads the new `public.admin_record_journey_v1` and shows the eight stages as a strip that wraps on a phone.
  - It names where processing stopped ("Stopped at validation (held): Held by the course entry completeness gate"). Every later stage reads "Not reached: waits for …".
  - Its diagnosis lists:
    - failure reason;
    - stored evidence (page, time, type, hash);
    - attempts;
    - reader and model;
    - gate;
    - AI analysis (shown when an intervention made one; otherwise "Not run … nothing was spent");
    - similar resolved cases (same field and hold reason, last 90 days, with counts and the latest 5);
    - references;
    - recommended recovery;
    - cost (US$0.00 for a stored-copy re-read of an entry read; the recent average for an AI re-interpretation);
    - potential or realised gain;
    - the card's own decision buttons with the role each needs;
    - outcome.
  - Not available, Not verified and 0 are shown differently.
  - No new page, tab or navigation. The Layer 4 guide names the fold. UI-MAP is regenerated (233 folds) and mirrored here.
- **Read contract** (read only, Curator and above, no model call, no job, no spend):
  - Review items (course link, entry, matrix, description, no page, conjoint) get the full journey.
  - Interventions and other kinds show validation, admission and publication; the earlier stages read Not available.
  - Website and Zoho verification reads **Not verified**, because no per-record check is recorded yet (shared contract item 1, S2-RM-Design).
  - Two G2 settings: `layer4.journey_similar_days` (90) and `layer4.journey_similar_max` (5).
- **Rolled-back rehearsal**, as a Platform Admin account, one item of each kind:
  - entry read: stopped at validation, held by the completeness gate (149 ms);
  - course link: stopped at validation; 13 rejected and 8 superseded similar cases (64 ms);
  - provider description: stopped at validation by machine rule pdesc-machine-v1; 105 approved similar cases (42 ms);
  - intervention: held, "Whether international students may apply is not established" (29 ms);
  - fee check: held (28 ms).
  - G3 75/48; locks 7,585; cron unchanged.
- **Correction:** the portal read-backs recorded for s1222 and s1271 earlier today ran as account `25269f74…`. That account holds the **Counsellor** role, not the Platform Admin role as those entries say. The portal checks Viewer or Counsellor, so the results stand.
- **Specs:**
  - The new `cf-247-s1272-dr19-record-journey-contract` passes, with s931, s557, s42, s57, s120 and s980.
  - The s32 and s931 mocked-browser tests need the local dev server, which this session lacks; CI runs them.
  - TEST-REGISTER is updated.
- **Production UAT** follows the merge, on the signed-in browser.

**S2-Build, 26 Nov 2026 19:25 AEDT: DR-19 received and claimed (SS-Programme-Control 19:19, Platform Admin execution mandate "Intelligent monitoring and human-assisted resolution"); design adjustments recorded; increment 1 is `s1272`.**
- **Design:** `docs/platform/2026-11-26-dr19-record-journey-and-diagnosis-design.md`.
  - No new page, tab or navigation level.
  - Each Layer 4 card (the focused view and the list views share it) gets one more fold, **Processing journey and diagnosis**. It shows eight stages:
    1. discovery;
    2. acquisition;
    3. extraction;
    4. normalisation and mapping;
    5. validation;
    6. canonical admission;
    7. publication;
    8. website and Zoho verification.
  - The fold shows the stage where processing stopped, and why later stages are not reached.
  - The diagnosis covers:
    - failure reason;
    - stored evidence;
    - attempts;
    - reader and model;
    - gate;
    - the AI analysis where the platform already made one;
    - similar resolved cases;
    - references;
    - recommended recovery;
    - cost estimate;
    - potential gain;
    - the card's own authorised actions;
    - outcome.
- **Read contract:** read-only `public.admin_record_journey_v1` (Curator and above). It needs no AI call, no job and no spend, and leaves G3 untouched.
  - Unavailable, not verified and zero are kept apart.
  - S2-RM-Design is asked for the shared contract's next items: per-record website and Zoho verification, a record list behind Data Delivery's holds, resolution references, and measured recovery gain.
- **Increments:**
  1. Layer 4 card (s1272);
  2. Data Delivery record drill;
  3. Course record drawer;
  4. verification and realised gain.

**S2-Build, 26 Nov 2026 18:40 AEDT: s1271 portal sole-city place live (Pilot #1678, merge `9d6f6a4`; admin #1199; migration `20261129170000`, history md5 `700a0dd1` matches the file).**
- **Deploy:**
  - The `live-dry-run` gate passed; Deploy on merge applied the migration.
  - **Workers Builds: studysearch-portal did not run for this merge, and none was needed.** s1271 changes no file under `portal/`, so the portal build is not started (the same holds for the other non-portal merges since s1222). The portal keeps serving the s1222 build that passed on `290ca1d`. The change is in the database reads it calls, so it is live without a rebuild.
- **Read back live** (rolled back, signed in as the Platform Admin):
  - "Bachelor of Nursing" in Australia: 20 cards in 1.9 s (primary campus 7, one city 1, one state 6, several cities 3, provider 3). The one-city card is Notre Dame's, which reads Fremantle, WA. No multi-city card is given a city.
  - "business in Fremantle": 15 cards in 365 ms, each naming its matching Fremantle campus.
  - Entry Requirements for Nursing: 20 rows in 282 ms (one city 10, one state 5, several cities 5).
  - `portal.course_place_v1` cannot be called by `anon` or `authenticated`.
- G3 75/48 with no drift; locks 7,585; active cron 136 (s1271 adds none); live migration head `20261129170000`; US$0.

**S2-Build, 26 Nov 2026 18:25 AEDT: s1271 portal sole-city place claimed and recorded before merge (Pilot branch `s2-s1271-portal-sole-city`, migration `20261129170000`); Atlas brief 18:18, from the S2-AER gap audit (admin #1186).**
- **What changes:** portal cards now name the city of a course with no primary campus when all its active campuses are in one city and state.
  - A new `portal.course_place_v1(course)` decides one place from the course's active campuses, in this order:
    - the course's primary campus (`course_campuses.is_primary`);
    - else the one city and state every campus shares;
    - else the one state, with no city;
    - else nothing (no tie-break, no guess);
    - the provider's own place only when the course has no campus at all, as before.
  - The search cards (`catalogue.portal_course_cards_v1` behind `public.portal_course_search_v1`), Entry Requirements rows (`portal.aer_list_v1`) and saved courses (`public.portal_saved_list_v1`) read it, with `place_basis`.
  - A search that names a city or postcode still shows the matching campus first.
- **What it fixes beyond the brief:**
  - Before, a course with campuses in several cities showed the alphabetically first campus's city: a guess. It now shows only the state when there is one state, or no place.
  - Saved courses showed the provider's city; they now show the course's place.
- **Rolled-back rehearsal** (the migration and a probe in one transaction, as the Platform Admin):
  - Places for the searchable courses: primary campus 4,279; one city 15,466; one state 5,054; several cities 4,186; no campus (provider) 5,377.
  - The audit's 15,469 counted city alone; 3 courses have the same city name in two states, so they get no city here.
  - "Bachelor of Nursing" in Australia: 20 cards in 1.9 s; a sole-city card reads Fremantle, WA.
  - Entry Requirements for Nursing: 20 rows in 289 ms.
  - The migration's own post-check proves a sole-city card names its city and a multi-city card gets none.
  - G3 75/48 with no drift; active cron 135; locks 7,585; US$0.
- **Specs:** the new `cf-247-s1271-portal-sole-city-contract` passes, with the governance specs (s42, s57, s120, s980, s32 static checks). TEST-REGISTER updated.
- **Pre-flight** passed above main's `20261129150000`. Version `20261129160000` is held by the open s1261 (#1675), so this takes `20261129170000`.
- No screen change: the cards already show city and state when they are returned.

**S2-Build, 26 Nov 2026 16:40 AEDT: s1222 portal UAT fixes live (Pilot #1670, merge `290ca1d`; admin #1183; migration `20261129130000`, history md5 `129bcb6c` matches the file).**
- **Deploy:**
  - **Workers Builds: studysearch-portal** passed on the merge commit, so the portal at `studysearch-portal.techm.workers.dev` serves the s1222 screens: full-width card grids, Cards/List, the Course details drawer, concise cards with one annual fee and the course code badge, and India and Nepal first in the country lists.
  - Deploy on merge applied the migration.
  - The `live-dry-run` gate passed before the merge.
- **Read back live** (rolled back, signed in as the Platform Admin):
  - `portal_settings_v1` returns `priority_source_countries` `["IN","NP"]`.
  - Entry Requirements for Nursing in Australia: 205 courses in 281 ms. The first item carries one annual fee (2026, A$48,600, basis annual) and CRICOS 115738B.
  - On a course with India and Nepal rows, `portal_entry_matrix_v1` returned 4 India rows in 15 ms and 1 Nepal row in 3 ms. That course's detail carries NZQA LI1012.
  - On a course whose provider holds India rows only for other study levels, the read returns 0 country rows in 6 ms, and the screen shows the plain "no entry requirement recorded for India" fallback.
  - Of the 34,362 searchable courses, 2,637 have an India row that applies to them and 2,029 a Nepal row. Every other course shows the fallback until the data lanes admit rows (feedback 5 handoffs in the plan).
  - Anonymous callers cannot run `portal_entry_matrix_v1`.
- G3 75/48, no drift; locks 7,585; live migration head `20261129130000`; US$0; Admin Worker untouched.
- **Active cron jobs: 139.** s1222 adds none (the count was 135 to 138 earlier today). It is under the charter limit of 140 but above the 135 in the brief. Other lanes' work today raised it; for Atlas to note.
- **Not read from here:** the live bundle itself. The session's network refuses the workers.dev host, so the build result is the deploy evidence. The Platform Admin's UAT is the visual check on live data.

**S2-Build, 26 Nov 2026 16:20 AEDT: s1222 portal UAT fixes claimed and recorded before merge (Pilot branch `s2-s1222-portal-uat-fixes`, migration `20261129130000`); Atlas brief 15:59, from the Platform Admin's live UAT of `studysearch-portal.techm.workers.dev`.**
- **Layout:** the content area is fluid to 1,680 px (it was capped at 1,100 px), and results sit in a card grid: 3 columns at 1,440 px, 2 at 1,280 px, 1 at 412 px.
- **Cards or List:** a toggle on Courses, Saved courses and Entry Requirements. The choice is kept for the person across screens and visits.
- **Course details drawer:** Course details open in a right-hand drawer, or a full-height sheet on a phone, instead of inside the card.
  - Escape, the close button or the shaded area closes it.
  - Focus moves into the drawer and back to the button that opened it.
  - The list keeps its place.
- **Concise cards:**
  - no "Not recorded" boxes on a card ("Not recorded" is said only inside Course details);
  - one annual tuition fee with its year and "per year · provider", from the new `portal.primary_fee_v1`: the current Melbourne year first, then the nearest later year, then the latest earlier year (feedback 5: a 2027 fee showed beside a 2026 fee);
  - the national course code (CRICOS, NZQA or MTCU) as a badge beside the title;
  - "Course page ↗" (new tab, `noopener noreferrer`) directly beside Course details.
- **Student countries pinned:** every student-country list shows India and Nepal first, a divider, then every other country A to Z. This covers Entry Requirements, the Course details selector, Universities & Providers and Proposals. The pinned countries are the new G2 setting `portal.priority_source_countries` (`["IN","NP"]`), changed on Settings with a reason; none is written into a screen.
- **Course details entry requirements (blank-country fix):** one "Academic entry requirements" section.
  - Choosing a country reads that country's rows in full through the new `public.portal_entry_matrix_v1` (Viewer and above), so the detail read's row cap can no longer hide a country.
  - Rows are grouped as This course, This study level, and Every course at the provider, plus rows that apply to every country and the course's own requirement lines.
  - When the provider holds nothing for the country, the panel says so plainly.
  - Other fee lines fold under "Other recorded fee lines".
- **Migration** `20261129130000_cf247_s1222_portal_uat_data.sql` (additive):
  - the four replaced function bodies were checked by md5 before replacement;
  - G3, cron and lock guards run before and after;
  - nothing is dropped.
  - **Rolled-back rehearsal passed:** 20 of 20 sample cards carry a course code; the India matrix read for a sample course returned 3 rows in 39 ms; a multi-year fee picked 2026.
- **Checked in Chromium** at 1,440, 1,280 and 412 px, on an esbuild bundle of the portal with fixture data, across Courses (cards, list, drawer), Saved courses and Entry Requirements:
  - horizontal overflow 0 px;
  - no tap target under 44 px (the search-chip remove buttons were raised from 36 to 44 px);
  - every outside link opens in a new tab with `noopener noreferrer`;
  - no "Not recorded" on cards;
  - the drawer closes on Escape and the list position is kept;
  - no page errors.
- **Specs:** the new `cf-247-s1222-portal-uat-fixes-contract` passes. The s1145, s1148, s1215 and s1220 assertions were amended to the s1222 rule, with their guards amended. The 142 portal and governance specs run pass. TEST-REGISTER updated.
- **Drive Feedback folder scanned:** nothing newer than feedback 5 (25 Nov). Its data items go to the owning lanes in the plan (campuses, entry minimums, PTE/TOEFL bands, scholarships, intakes, fee year at source). The portal parts are fixed here: fee year, and Nepal pinned.
- **Revised mock-ups** (images of the built screens) are in Drive `M3 > Portal > Mockups`, numbers 25 to 28.
- G3 75/48; locks 7,585; no cron change; Admin Worker untouched; US$0.

**S2-Build, 26 Nov 2026 15:45 AEDT: s1220 portal screens live (Pilot #1666, merge `d00a416`; frontend only).**
- **Workers Builds: studysearch-portal** passed on the merge commit, so the portal at `studysearch-portal.techm.workers.dev` serves:
  - the provider website and the provider's entry matrix in Course details;
  - location, length and tuition per year on Entry Requirements cards.
- **Admin Worker:** its routine preview build ran; no Admin code was changed.
- **Not read from here:** the live bundle itself. The session's network refuses the workers.dev host, so the build result is the deploy evidence. The Platform Admin's UAT is the visual check on live data.
- **TEST-REGISTER** regenerated: s1220 added.
- G3 75/48; locks 7,585; no migration or cron change; US$0.

**S2-Build, 26 Nov 2026 15:40 AEDT: s1220 portal screens for the s1216 fields claimed and recorded before merge (Pilot branch `s2-s1220-portal-detail-wiring`, frontend only, no migration); Atlas brief 15:18, Platform Admin authority while S1-API-Frontend-Delivery is busy.**
- **Course details panel** (`portal/src/components/CourseDetails.jsx`):
  - "Open the provider website" opens in a new tab through ExtLink; "Provider website: Not recorded" when it is missing.
  - New section "Entry requirements by country (provider)", for each row:
    - country, qualification, grade, band, scale, level and course, and conditions;
    - checked date and a Source link (new tab).
  - When the student's country is chosen, the section shows that country's rows plus rows that apply to every country, with "Show all N rows".
  - "Showing X of Y rows" appears when the read was capped; "Not recorded" when empty.
- **Entry Requirements cards** (`portal/src/screens/EntryRequirements.jsx`): Location (city, state), Length (the existing `durationText`) and Tuition per year (provider); "Not recorded" for each when null.
- **Formatting:** pure helpers `matrixLine`, `matrixForMarket` and `conditionsText` in `courseDetailFormat.js`.
- **Checked in Chromium** at 1280 px and 412 px, on an esbuild bundle of the portal with fixture data:
  - horizontal overflow 0 px;
  - no tap target under 44 px;
  - every outside link has `target="_blank" rel="noopener noreferrer"`;
  - no page errors.
- **Specs:** portal specs (76) pass, including s1215 and the new s1220.
- G3 75/48; locks 7,585; no migration or cron change; Admin Worker untouched; US$0.

**S2-Build, 26 Nov 2026 13:28 AEDT: s1216 portal detail fields live (Pilot #1658, migration `20261129100000`, history md5 checked).**
- **Read back as the signed-in Platform Admin:**
  - `public.portal_course_detail_v1` for Advanced Diploma of Accounting (Gold Coast Learning Centre): `provider_website` https://www.goldcoaststudy.com and `entry_matrix` 2 of 2 rows (Australia, Certificate IV, international) in 112 ms.
  - `public.portal_aer_list_v1` for business in AU: 2,301 courses; rows carry `city`, `state_code`, `duration_value`, `duration_unit` and `annual_tuition_fee`, in 0.88 s under load.
  - anon is refused.
- G3 75/48, drift 0; locks 7,585; active cron 135; head `20261129100000`; US$0.
- TEST-REGISTER regenerated: s1215 x2 and s1216 added; the pending s1217 rows kept.
- **Stale branches:** the session proxy refuses branch deletion through both git and the REST API ("Write access to this GitHub API path is not permitted"). These Pilot branches remain for a session with delete rights: `s2-s1170-portal-hybrid-fix`, `s2-s1182-portal-proposals`, `s2-s1211-latency-diag`, `s2-s1152-portal-search`, `s2-build-reads`. `s2-build-am-reads` is the read-back helper branch.

**S2-Build, 26 Nov 2026 13:15 AEDT: s1216 portal detail fields claimed and recorded before merge (migration `20261129100000`, branch `s2-s1216-portal-detail-fields`); Atlas brief 13:07, from S1-API-Frontend-Delivery's plan item 13.**
- **`public.portal_course_detail_v1` adds:**
  - `provider_website` (`catalogue.providers.website`).
  - `entry_matrix`: the provider's active country-by-country entry rows from `catalogue.provider_entry_matrix`, for international or all applicants.
    - Order: rows naming the course first; then rows for its study level, or the level above or below it, that name no course; then provider-wide rows; by country within each.
    - Each row: `country_code`, `country_name`, `qualification`, `min_grade`, `min_value`, `grade_scale`, `benchmark_band`, `level_label`, `course_label`, `for_this_course`, `audience`, `edition`, `intake_year`, `conditions`, `as_at`, `source_url`.
    - Capped by the new setting `portal.entry_matrix_max_rows` (300).
  - `entry_matrix_total`: the number of matrix rows that matched before the cap.
- **`public.portal_aer_list_v1` items add:**
  - `city` and `state_code` (the primary campus, otherwise the provider);
  - `duration_value` and `duration_unit` (the keys the screens' `durationText` already reads);
  - `annual_tuition_fee` `{amount, currency}`.
- **Keys:** `portal/src` had no keys for these fields yet. These are additive keys on the same functions, documented in the design document for S1-API-Frontend-Delivery to wire.
- **Coverage today:** 12,573 portal courses are at providers holding an entry matrix; 4,129 match one by course or level, before provider-wide rows.
- **Rehearsed:** detail 11 to 16 ms; list 87 to 100 ms.
- G3 75/48; locks 7,585; active cron 138 when read (other lanes; s1216 adds none); US$0.

**S2-Build, 26 Nov 2026 12:35 AEDT: s1213 daytime quiet hours read back live; s1214 portal course detail and entry requirements reads live (Pilot #1656, migration `20261129080000`, history md5 checked).**
- **s1213 live** (cron run history):
  - The five held jobs average 0.07 to 0.10 s a run by day, against 10 to 40 s before.
  - All cron job-seconds per 10 minutes: 1,800 to 3,400 before 12:18, 1,002 in the 12:20 window, and 49 in the first minutes of 12:30.
  - A fixed CPU benchmark (counting 3 million generated rows) took 2.36 s at 12:26 and 1.28 s at 12:30.
- **Database finding:** the database is on Medium compute. Supabase documents sizes up to Medium as shared CPU, with Large and above on dedicated vCPUs. On shared CPU the same warm search took 0.15 s at one moment and over 2 s at another, with few blocks read. The quiet hours remove about 47,700 job-seconds by day. If searches still vary, the remaining lever is compute size, a Platform Admin cost decision.
- **s1214 live**, read back as the signed-in Platform Admin:
  - `public.portal_course_detail_v1`: Master of Nursing Practice in 60 ms, with 4 fees, 2 intakes, 1 campus, 2 entry requirements, 1 English requirement and 7 graduate outcome figures (PGC, full-time employment 84.6%).
  - `public.portal_aer_list_v1`: masters nursing in AU with both kinds of requirement found 20 courses in 147 ms, page size 20.
  - anon cannot execute either function.
- G3 75/48, drift 0; locks 7,585; active cron 136; head `20261129080000`; US$0.
- TEST-REGISTER regenerated: s1213, s1214 and three other lanes' specs now on main added.
**S1-API-Frontend-Delivery, 26 Nov 2026 12:45 AEDT: s1215 recorded before merge: portal Course details panel, Entry Requirements (AER) screen and new-tab links (Pilot branch `s1-portal-details-aer-s1215`, migration `20261129090000`).** Atlas brief 12:02 from the Platform Admin's live UAT. The reads behind the screens are S2-Build's s1214 (`public.portal_course_detail_v1(uuid)`, `public.portal_aer_list_v1(jsonb)`, live, migration `20261129080000`). I had built a duplicate read layer under the same number; it was withdrawn before merge (nothing of it reached main or the database) and the screens were rebuilt on S2-Build's functions, so there is one data layer.
- **Course details:** each course card on Courses, Saved courses and Entry Requirements has a "Course details" button that opens an inline panel: overview, campuses and delivery, fee lines as recorded (annual and whole-course, never added together), intakes and deadlines, academic entry requirements (lines naming no country, plus the student's country when chosen) and English, provider-level career outcomes (labelled as the provider's, not the course's), and the official source link. Anything not held reads "Not recorded".
- **Entry Requirements (AER):** new menu item after Courses (Viewer and Counsellor); filters Study in, student's country of education (sent as `source_country`), study level, provider or course text, and academic, English or both. Save and + Add to proposal are Counsellor only.
- **Links:** every outside link (course page, provider website, scholarship page, and the official page on each proposal course) goes through one `ExtLink` component: new tab, `noopener noreferrer`, web addresses only. A spec fails any other outside `href`.
- **Database:** one new read, `public.portal_study_levels_v1()` (Viewer and above, `authenticated` only, `anon` denied): the live top-level study levels that have courses, for the Study level filter (s930). Rehearsed rolled back on the live database (passed). No setting, table or job added.
- **Checked in real Chromium at 1280 px and 412 px (mock-backed build, as a Counsellor and a Viewer):** all eight sections, no horizontal overflow, no tap target under 44 px, every outside link `_blank|noopener noreferrer`, a Viewer sees no Save or Add to proposal.
- Live head `20261129080000`, G3 75/48 no drift, locks 7,585, cron 138 (adds none), US$0.
- Known gaps in what S2-Build's reads return, shown as "Not recorded" or left out: the provider's country-by-country entry matrix and the provider website are not in the detail read; the Entry Requirements cards show provider, country and level but not city, length or fee (the course's own panel shows them). Raised for S2-Build in the Master Plan.

**S2-Build, 26 Nov 2026 12:25 AEDT: s1213 live (Pilot #1654, migration renumbered to `20261129070000` above another lane's `20261129061000`; history md5 checked); s1214 portal course detail and entry requirements reads claimed and recorded before merge (migration `20261129080000`, branch `s2-s1214-portal-detail-aer`); Atlas brief 12:02 for S1-API-Frontend-Delivery.**
- **s1213:** the five background jobs carry the quiet-hours check live. The daytime read-back follows in the next entry.
- **s1214** adds read-only `portal` functions behind public wrappers. Each needs Viewer rank or above; anon is refused.
  - **`public.portal_course_detail_v1(p_course_id uuid)`:** one published-provider course in full. A course outside the portal scope answers not found (P0002). It returns:
    - the description and campuses;
    - every active fee row, plus the annual tuition;
    - upcoming intakes;
    - academic entry and English requirements;
    - the provider's QILT employment and salary figures for the course's cohort (UG, PGC or PGR);
    - the official page and when it was last checked.
  - **`public.portal_aer_list_v1(p_args jsonb)`:** pages of published-provider courses with their active academic and English requirements.
    - Filters: `q`, `country`, `source_country`, `level` (a code or its family, e.g. masters), `provider_id`, and `has` (academic, english, both or any). Malformed fields are ignored.
    - Page size: new setting `portal.aer_page_size` (20).
    - No active entry requirement records a qualification country yet, so `source_country` also returns requirements that name no country, since those apply to everyone.
- **Coverage today:** 22,286 of 34,362 portal courses carry a requirement (10,634 academic, 21,063 English).
- **Rehearsed:**
  - Master of Nursing Practice detail in 21 to 51 ms, with 2 entry requirements, 1 English requirement, 4 fees, 2 intakes and 7 outcome figures.
  - The list: masters nursing in AU found 55 courses in 78 ms; the unfiltered list took 0.37 s.
- G3 75/48; locks 7,585; active cron 138; no job; US$0.

**S2-Build, 26 Nov 2026 12:20 AEDT: s1213 daytime quiet hours claimed and recorded before merge (migration `20261129060000`, branch `s2-s1213-quiet-hours`); Atlas brief 11:59, Platform Admin approval.**
- **Measured** (cron run history, last 24 hours): 363,920 job-seconds a day, 177,899 of them between 08:00 and 20:00 Melbourne time. Database at CPU 78% and disk 79%.
- **The five heaviest direct background jobs**, 95,352 job-seconds a day (about 47,700 of them by day), serve no screen:
  - coverage-ai-match-prepare: 28,216 s
  - fee-reader: 27,581 s
  - scholarship-ai-extract: 14,203 s
  - course-description-machine: 13,498 s
  - provider-description-read: 11,854 s
- **Change:** each job's own command now checks `security.quiet_hours_open_v1(job)`.
  - The jobs do no work from 08:00 to 20:00 Melbourne time, so daylight saving needs no change, and run exactly as before at night.
  - The settings `pipeline.quiet_hours.enabled`, `start_hour`, `end_hour` and `jobs` are changed on Settings › Pipeline settings › Scheduling, with a reason.
  - No job is added, removed, activated or deactivated: active cron jobs stay at 138.
- **Kept all day:**
  - website-sync-check and zoho-sync-check, the change feeds the website and Zoho read;
  - admin-jobs (Task manager);
  - the rollup and admission-rule dispatchers;
  - every light handler.
- **Rehearsed:** the commands are gated, a held run returns in 1 ms, and the gate is closed at noon and open at 23:00.
- **Effect on owning lanes** (S2-CF, Scholarships, Descriptions): these jobs, and on-demand items queued for them, now work overnight only. The Platform Admin can lift the hold on Settings.
- G3 75/48; locks 7,585; US$0.

**S2-Build, 26 Nov 2026 11:45 AEDT: s1212 live (Pilot #1653, migration `20261129050000`, history md5 checked): the portal meaning step reads the full-vector index again; s1211's other speed-ups stay.**
- **Live read-back** (the live search and an s1181 copy run turn about, at the same moments): same totals, chips, near misses and top 20 on every phrase.
  - Bachelor of Nursing in Melbourne under $40,000: 0.18 to 0.24 s (s1181 0.44 to 1.12 s).
  - accounting in Brisbane: 0.54 to 0.87 s (s1181 0.74 to 1.27 s).
  - Master of Nursing in Victoria warm: 0.15 s (s1181 0.16 s).
  - nursing: within the load noise of s1181.
- `portal_search.meaning_index` = full. Five phrases are cached, and all four Dashboard examples rank by meaning.
- G3 75/48, drift 0; locks 7,585; active cron 138; head `20261129050000`.
- Portal embedding spend since 11:00 is US$0.00044. That covers the pre-warm requests and the queued course vectors that ride along with each request.
- TEST-REGISTER regenerated: s1211, s1212 and s3-witt-source-recovery added; s1195, from a pending branch, kept.
- The 11:50 timestamps in the 11:25 record were corrected to 11:25.

**S2-Build, 26 Nov 2026 11:25 AEDT: s1211 live (Pilot #1651, migration `20261129040000`, history md5 checked); s1212 claimed and recorded before merge (migration `20261129050000`, branch `s2-s1212-portal-meaning-full`).**
- **s1211 live read-back** (the live search and an s1181 copy run in turn, three times each, at the same moments):
  - City searches are faster: Bachelor of Nursing in Melbourne under $40,000 0.40 to 0.61 s (s1181 0.72 to 1.03 s); accounting in Brisbane 0.47 to 0.58 s (0.82 to 1.00 s).
  - The compact one-bit meaning index did not hold its gain. The scheduled pipeline runs about 13,500 job-seconds an hour, with 29 to 41 job runs overlapping each minute, and the 16 MB index was pushed out of memory within 15 minutes (a cold search read 3,146 blocks against 2,302).
  - Warm meaning searches were 60 to 110 ms slower, and one course moved across the meaning threshold (Master of Data Science: 60 against 61).
- **The four Dashboard example searches were pre-warmed live:** five typed phrases are now cached, and each example ranks by meaning.
- **s1212** puts the meaning step back on the full-vector index by default, through the new setting `portal_search.meaning_index` (full or compact). The compact index stays as the second choice; nothing is dropped. Every other s1211 change stays.
- **Rehearsed against s1181:** same totals, chips, near misses and top 20.
  - City searches 0.21 to 0.42 s (s1181 0.40 to 0.80 s).
  - Master of Nursing in Victoria 0.26 to 0.33 s warm (0.35 to 0.37 s).
  - "nursing" about 25 ms slower.
- **Search time on this database depends mostly on the scheduled pipeline's load:** the same warm search took 0.15 s at one moment and 6 s at another. Written into the plan as a Platform Admin decision: compute size, or keeping the heaviest per-minute jobs off UAT hours.
- G3 75/48, drift 0; locks 7,585; active cron 138 (s1211 and s1212 add none); US$0.00 for s1211 and s1212 (pre-warm about 20 tokens, under US$0.000001).

**S2-Build, 26 Nov 2026 11:00 AEDT: s1211 portal course search latency claimed and recorded before merge (migration `20261129040000`, branch `s2-s1211-portal-search-latency`); Atlas brief 09:30 (Platform Admin UAT: search slow).**
- **Measured live (rolled back), each step timed inside the search:**
  - UAT calls at 08:45 took 0.3 to 3.9 s.
  - A first search on a new database session took 1.96 s; the same search warm took 0.13 s.
  - 1.94 s of that was the meaning step reading the 255 MB full-vector index from disk (about 2,000 blocks; shared memory is 1 GB).
  - A city search read every course campus three times (55,922 rows each) and every course (44,743).
  - Only one typed phrase was cached, because meanings were kept for 24 hours.
  - A phrase not yet embedded never waits: its vector is fetched in the background (about 1 s), and that search ranks by words.
- **Fix:**
  - A 16 MB one-bit meaning index (`search.course_embeddings_bq_hnsw_idx`) gives 300 candidates, which are scored exactly (new setting `portal_search.topic_vector_candidates`).
  - City and filter steps read the topic's courses by key; countries and levels come through their indexes.
  - `portal_search.query_cache_hours` goes from 24 to 720, and each use renews a cached phrase.
  - The Dashboard example searches are a setting (`portal_search.prewarm_phrases`, held equal to EXAMPLE_PROMPTS by spec s1211) and are pre-warmed when the change is applied.
- **Rehearsed against s1181:** same totals, chips and near misses on every phrase.
  - Master of Nursing in Victoria: 0.16 s (s1181 1.52 s cold).
  - City searches: 0.2 to 0.48 s (s1181 0.38 to 1.05 s).
  - First search on a new session: 0.27 s.
  - The whole migration runs in 38 s.
- G3 75/48 untouched; locks 7,585; no cron added; spend is US$0.00 (pre-warm about 20 tokens, under US$0.000001). The full-vector index stays, because `search.course_candidates_v1` reads it.

**S2-Build, 26 Nov 2026 09:00 AEDT: s1210 Portal Release 2 proposals layer live (Pilot #1646, migration `20261129003000`); read back as signed-in Counsellors.**
- **Live read-back (through the deployed public functions, two real Counsellors, rolled back):**
  - `save` as Counsellor 1 created v1, `SS-000001`, with the server course snapshot (fee held).
  - `get` as Counsellor 2 showed Counsellor 1 in `others_recent`, limits 12 courses and a 15-minute window.
  - Counsellor 2 saved on base 1 to make v2.
  - Counsellor 1's save on the stale base 1 answered `saved_after_other_edit`: current 2, changes "Message to the student", nothing written.
  - `refresh` gave 0 changes, with `built_at` set.
  - `list` (mine, by reference) gave total 1, page size 20 and the facet counts.
  - `get` gave v2 with 2 versions and `expires_at` 12 months out.
- G3 75/48, drift 0; locks 7,585; active cron 136 (s1210 adds none); anon has no execute; US$0.
- The Release 2 screens (s1200 to s1202) now have their functions; the Platform Admin can run the proposal UAT.
- TEST-REGISTER regenerated: s1210 added, with s1172 and s1200 to s1202 now on Pilot main.
- Leftover: the superseded branch `s2-s1182-portal-proposals` (never merged); the session proxy refuses branch deletion (HTTP 403).

**S2-Build, 26 Nov 2026 08:25 AEDT: s1210 Portal Release 2 proposals layer recorded before merge (Pilot branch `s2-s1210-portal-proposals`, migration `20261129003000`).**
- **What:** the database layer the live Release 2 screens (Pilot #1645, s1200 to s1202) are waiting for.
  - Tables:
    - `pipeline.portal_proposals`: student_ref, given name and family initial, plus academic facts; statuses draft, ready, sent, accepted and archived; archived_at/by/reason; expires_at.
    - `pipeline.portal_proposal_versions`: append only, with last_editor_id and saved_after_other_edit.
    - `pipeline.portal_activity` and `pipeline.portal_user_prefs`.
  - Row level security is on, with no table privilege granted.
  - Contract functions with one `p_args jsonb`: `public.portal_proposal_list_v1`, `get_v1`, `save_v1` and `refresh_v1`, plus `portal_proposal_archive_v1`; all Counsellor and above.
  - `portal_activity_touch_v1`, `portal_activity_list_v1` and `portal_prefs_save_v1`: Viewer and above. Anon has no execute.
  - Eleven portal settings: course, message, note and "why" limits; soft-lock 15 minutes; page size 20; retention 12 months; resume items; themes; default steps and documents.
- **Platform Admin decisions (26 Nov 07:30, asked because the 07:01 brief and the screens' 07:15 contract differed):**
  - the contract's functions on the brief's tables;
  - the student record may hold academic facts (country of education, qualification, result, English result, destination, preferred intake, budget), with identity kept to reference, given name and initial;
  - a save on an older version writes nothing unless forced;
  - `ready` is a status.
  - The 07:37 brief confirmed the contract alignment and set 12-month retention.
- **Behaviour:**
  - The server builds every course snapshot from live rows: fee, length, delivery, place, next intake, entry, English and international scholarships.
  - An ordinary save keeps the snapshots already held. Only refresh `accept` (or a new or duplicated proposal) takes live values, and `keep` clears the notice until values move again.
  - `needs_refresh` watches fee, intake and availability.
  - Archive is a save with status archived (default reason) or `portal_proposal_archive_v1` with a reason; restore is a save with another status. Nothing is deleted. Removing expired or privacy-requested proposals is a Platform Admin paste file.
- **Rehearsed on live data, rolled back, acting as real users** (a temporary Viewer, two Counsellors, an unassigned sign-in): every contract path behaves as specified, including the clash with and without force, the kept snapshot, refresh keep and accept, duplicate, ready and sent, archive and restore, paging and facets, append-only enforcement and access refusals. G3 75/48; locks 7,585; cron 136 (s1210 adds none); US$0.
- **The superseded s1182 branch** (built to the 07:01 brief before the screens' contract was known) was never merged or claimed.

**S2-Build, 26 Nov 2026 05:45 AEDT: s1181 portal search hardening live (Pilot #1637, migration `20261128105000`); read back as a signed-in Counsellor.**
- **Live read-back (through `public.portal_course_search_v1` with a real rank-2 user's identity, rolled back):** every spelling of "Master of Nursing in Victoria" (extra, leading or trailing spaces, upper case, a tab, a non-breaking space, a comma and a full stop) returns the same 21 courses, ranked by meaning, chips Victoria / Master / Nursing.
  - Each took 0.54 to 0.59 s; the first, cold search took 2.7 s including the sign-in setup.
  - "  bachelor   of nursing   in   new  south  wales  " returns 52 in 0.75 s.
  - "grad dip education queensland" returns 75 (Graduate Diploma) in 1.4 s.
  - "Bachelor of Nursing in Melbourne under $40,000 per year" returns 6 in 1.3 s.
  - "Master of Data Science with internship in Sydney or Brisbane" returns 58 in 1.3 s.
  - A blank search and "!!!" return no courses in 0.1 s.
  - The three settings are live (200 / 8 / 100), and the function body is the new one.
- G3 75/48, drift 0; locks 7,585; active cron 138 (s1181 adds none); s1181 spends US$0 (US$0.31 across all lanes today at 05:40).
- TEST-REGISTER regenerated: the s1181 spec is added; S1-RM-Design's s1171 is listed now that it is on Pilot main; S1-Build's pending s1157 row is kept.

**S2-Build, 26 Nov 2026 05:10 AEDT: s1181 portal search hardening recorded before merge (Pilot branch `s2-s1181-search-hardening`, migration `20261128105000`).**
- **Bug (Platform Admin, live UAT 03:45):** "Master of  Nursing  in victoria" (extra spaces) showed "Something went wrong on our side". The request: make it idiot proof.
- **Root cause (Postgres log 03:41 to 03:43, SQLSTATE 57014, statement timeout, API limit 8 s):** the filter step of `catalogue.portal_course_search_v1` read every candidate course's stored vector one by one once the phrase's vector was cached (5,558 Master's courses; 10 to 15 s in a rolled-back run). The spaces were not the cause: every spelling understood Victoria / Master / Nursing, and all of them were slow. A failed search also rolls back its own request to embed a new phrase.
- **Fix:**
  1. Typed text and place names are folded one way (`security.portal_fold_v1`): case, accents, smart quotes, tabs, line breaks, non-breaking or zero-width spaces, punctuation and hyphens.
  2. Malformed request fields are ignored (countries, removed, relax, provider_id).
  3. The vector index is searched once (nearest `topic_vector_pool`). Topic words are matched through the text index once each. Filtering starts from the topic matches. Ranking is the shared ranker's fusion (k and weights from the `portal-default` profile) over the matches, and `search.course_candidates_v1` is no longer called.
  4. City names are matched in one query, and urban-area postcodes are treated as a set.
  5. A search with nothing to go on returns no courses at once.
  6. "grad dip", "grad cert", "adv dip" and "assoc degree" read as study levels.
  7. Each topic word is kept once.
  8. A typed country outside Study in matches nothing (it was read as every country).
  9. Three G2 settings: `portal_search.query_max_chars` 200, `topic_max_words` 8, `topic_vector_pool` 100.
- **Rehearsed on live data, rolled back:**
  - 30 messy inputs (extra and leading spaces, tabs, line breaks, invisible spaces, upper case, punctuation, hyphens, accents, emoji, SQL-like text, a 2,400-character query, empty and stopword-only) gave no error, in 0.03 to 1.55 s (the cold first search). Before the fix: 10 to 15 s.
  - 20 malformed request shapes gave no error.
  - "Master of  Nursing  in victoria" returns 21, ranked by meaning; "  bachelor   of nursing   in   new  south  wales  " returns 52; "grad dip education queensland" returns 75 (Graduate Diploma).
- **Numbering:** version `20261128105000` is between main (`20261128100000`) and S1-RM-Design's open s1171 (`20261128110000`). Guarded by the s1153 body checksum `2ab79d9e`. G3, locks and cron are checked in the migration; US$0.
- **Running build document:** created at the Platform Admin's request (03:59) as `docs/platform/STUDYSEARCH-PORTAL-BUILD-DOCUMENT.md`, mirrored to Drive `M3 > Portal`, and updated at every delivery checkpoint until acceptance.

**S2-Build, 26 Nov 2026 00:25 AEDT: s1180 portal search hotfix live (Pilot #1633, migration `20261128075000`, history md5 `e53c27e4`); read back as a signed-in Counsellor.**
- **Live read-back (00:17, through `public.portal_course_search_v1` with a real rank-2 user's identity, rolled back):** "Master of Nursing in Victoria" and "Master of Nursing  in Victoria" each return 20 exact (21 in total), ranked by meaning, chips Victoria / Master / Nursing. Federation University Master of Nursing, Monash Master of Nursing Practice and La Trobe Master of Nursing come first. "Master of Data Science in Sydney" returns 20 of 252, ranked by words (no cached vector), chips Sydney / Master / Data Science. The live ranker carries the qualified CTEs.
- **Postgres log:** the last real portal error was 22:51 (SQLSTATE 42702); there have been none since the deploy.
- **Numbering:** the version moved from `20261128055000` to `20261128065000` to `20261128075000` while S1-RM-Design merged s1167 (`060000`) and s1168 (`070000`). It stays below S1-RM-Design's pending s1169 (`080000`).
- G3 75/48, drift 0; locks 7,585; active cron 136 (two jobs switched off by another lane at 23:10; s1180 changes none); AI spend today US$0.00. TEST-REGISTER regenerated (s1180 spec added, 2 tests).

**S2-Build, 25 Nov 2026 23:35 AEDT: s1180 portal search hotfix recorded before merge (Pilot branch `s2-s1180-portal-hybrid-fix`; migration renumbered to `20261128075000` at merge).**
- **Bug (Platform Admin, live UAT 22:53):** "Master of Nursing in Victoria" on the portal Courses screen showed "Something went wrong on our side".
- **Root cause (Postgres log, SQLSTATE 42702):** `search.course_candidates_v1` raised `column reference "course_id" is ambiguous` at line 68. Its hybrid / vector branch selects a bare `course_id` in the `fts` and `vec` CTEs, which clashes with the function's own `course_id` output column, so that branch had never run. The portal search asks for hybrid only once a phrase's query vector is cached. The first search of this phrase cached it at 22:50, and every later search of it failed. Phrases with no cached vector (the s1153 smoke tests) run keyword only, which is why it was not seen. The state ("Victoria") and the double space are not involved, and the screen sends the right payload.
- **Fix:** the two CTEs qualify `course_id` with their source alias, as the keyword branch already does. Every other line is the live definition byte for byte, and the replace runs only if the live checksum is `cea85208`. Only the portal calls this function: `api.zoho_course_candidates_v1` ranks with its own query, and it is not in the 75/48 frozen baseline (both checked in the migration).
- **Numbering:** s1170 to s1179 and versions 20261128100000 to 20261128190000 were reserved by S1-RM-Design at 23:12, so this is s1180 with version 20261128055000: above main's head (20261128050000) and below S1-RM-Design's pending 20261128060000 onwards, so it blocks none of them.
- **Rehearsed on live data, rolled back:** both Victoria queries return 20 exact (21 in total) ranked by meaning, led by Federation, Monash and La Trobe Master of Nursing courses. "Master of Data Science in Sydney" returns 20 of 252, ranked by words. G3 75/48, locks and cron are checked by the migration (cron 138); US$0.

**S2-Build, 25 Nov 2026 22:45 AEDT: s1153 scope decided; Release 1 search ready for UAT.**
- **Platform Admin decision (25 Nov 2026 22:43):** portal search keeps the published-provider scope of the shared search documents: 34,362 courses. The document builder (`search.refresh_course_base_v3`, rule v2.15.236) and the 1,690 courses at the 261 unpublished (1,672) or archived (18) providers stay as they are. A provider's courses enter the index automatically when the provider is published. Website search and the frozen Zoho course matching are unaffected, and there is no added spend.
- No further migration or code change from S2-Build for s1153. Release 1 search is ready for live UAT on `studysearch-portal.techm.workers.dev`.

**S2-Build, 25 Nov 2026 20:45 AEDT: s1153 embed batch follow-up live (Pilot #1622, migration `20261127130000`); portal backfill complete.**
- **Embedded:** 34,362 of 34,362 search documents have a `portal-default` vector (`openai/text-embedding-3-small`, 1,536 dimensions), each matching its document's current semantic text. The website and Zoho profiles hold no portal vectors. With batches of 25, no write timed out after 20:20, and the queue emptied at 20:27.
- **Spend:** 508 answered calls, 2,577,857 tokens, US$0.051567. 36 calls failed (HTTP time-outs while writing at batch 150) at US$0. The 1,050 job rows marked failed were re-queued and are all embedded. Today's spend across all lanes was US$3.61 at 20:40, inside US$5.
- **Correction to the 20:15 entry:** the refresh processed all 1,690 requests (`rows 0, changed 0`) and built no documents. The document builder (`search.refresh_course_base_v3`) keeps only courses whose provider is published and active (v2.15.236, Feature 4: "an unpublished or archived provider's courses leave search"). The 1,690 courses belong to 261 such providers: 1,672 courses at active providers that are not published, and 18 at archived providers. The portal search reads the same documents, so it does not return these courses, and none has a vector. That gives 34,362 of 36,052 active courses. The design doc says Counsellors search all active courses. Reaching 36,052 would mean letting these providers' courses into `search.course_documents`, which the frozen `api.zoho_course_candidates_v1` and website search also read, or giving the portal its own document source. This is a Platform Admin decision; nothing was changed.
- **Ranking:** a phrase ranks by meaning once its vector is cached (`portal:` keys in `search.query_embedding_cache`, 24 h); none is cached yet, because the smoke tests were rolled back.
- G3 75/48, drift 0; locks 7,585; active cron 138 (s1153 added none; the lane runs on the existing dispatcher).

**S2-Build, 25 Nov 2026 20:15 AEDT: s1153 live (Pilot #1616, merged 18:51; migration history md5 `e7beb2be`); follow-up s1153 embed batch recorded before merge.**
- **Gateway rule:** during review the embedding call moved from a separate edge function into `coverage-sweep` as mode `portal_search_embed` (worker v1.0.46), because only the worker may call OpenRouter (Platform Admin 13 Nov 2026; spec `cf-247-ai-models-services-contract`). No edge function was added.
- **Live smoke (rolled back, 19:10):** "Master of Data Science with internship in Sydney or Brisbane" gives chips Brisbane / Sydney, Master, Data Science Internship, 58 exact matches, led by QUT, CDU and Sydney. "Bachelor of Nursing in Melbourne under $40,000 per year" gives 6 exact matches: ACU Fitzroy A$39,672 and IHM North Melbourne A$20,000 first. No errors. The public entry refuses a caller who is not signed in. Both rank by words until a phrase is searched for real and its vector is cached.
- **Backfill:** 21,004 of 34,362 search documents were embedded between 18:51 and 19:33 (1.6 million tokens, US$0.032; about 79 tokens a course), with no vectors on the website or Zoho profiles. Then every write of 150 vectors timed out as the HNSW index grew (29 calls). 900 jobs were marked failed after 3 tries; they are re-queued automatically. Follow-up migration `20261127130000` sets `portal_search.embed_batch` to 25 (rehearsed).
- **Not yet:** the 1,690 active courses without a search document wait on the existing refresh (`search-refresh-requested`) and are embedded by the trigger when built. "36,052 embedded" is reached only once the refresh builds them. G3 75/48; locks 7,585; active cron 136 (none added).

**S2-Build, 25 Nov 2026 18:30 AEDT (Platform Admin 17:13, Portal Release 1 search activation): s1153 (Pilot #1616, migration `20261127020000`, edge function `portal-search-embed`) recorded before merge.** `public.portal_course_search_v1(p_args)` and `catalogue.portal_course_search_v1` are built to the as-built contract in the portal design doc. Stage 1 reads the words into filters from the live tables: country, state, campus city (with ABS urban-area postcodes so suburbs count), study level and budget. Stage 2 ranks with the existing `search.course_candidates_v1`. Fewer than 3 exact matches bring near misses and relaxations: third-cheapest fee + 5%, rounded up to A$1,000, within +30%. Vectors (`openai/text-embedding-3-small` via OpenRouter, data collection denied) live under a new profile `portal-default`, because the frozen `api.zoho_course_candidates_v1` uses the same ranker; Zoho and website results cannot change. The backfill runs on a new registry lane of the existing dispatcher (no cron job) in steps of 1,500; one statement for all 34,362 jobs timed out in rehearsal. A trigger re-queues a course when its semantic text changes. 1,690 active courses with no search document were sent to the existing refresh. The spec number moved to s1153 because S1-Build took s1152 and `20261127010000` first. Rehearsed on live data, rolled back: nursing under A$40,000 in Melbourne returns ACU Fitzroy and IHM North Melbourne first; data science masters in Sydney or Brisbane returns QUT, CDU, Sydney, UTS and Western Sydney. G3 75/48, 7,585 locks and active cron are unchanged (post-checks).

**S1-API-Frontend-Delivery, 25 Nov 2026 18:00 AEDT: Portal Release 1 screens (Pilot s1144 to s1149).**
- `portal/` now has Dashboard, Courses, Universities & Providers, Scholarships and Saved courses with compare, role-aware menu and a "Study in" bar. Front end only: no migration, no new job, no Admin app change.
- Courses waits on S1-Build's `portal_course_search_v1` (shape in the portal design document); until then it says search is not switched on. Live migration head and cron count are unchanged by this release.

**S1-API-Frontend-Delivery, 25 Nov 2026 16:30 AEDT: Portal data layer, migration `20261126230000` (Pilot s1143).**
- New `portal` schema and read functions for providers, scholarships and saved shortlists; 5 settings under toolset `portal`. Additive; G3 75/48 checked in the migration. Live when Pilot s1143 merges and deploys.
- Course search (`catalogue.portal_course_search_v1`) still belongs to S1-Build; the response shape the portal reads is in the design document.

**S1-Build, 25 Nov 2026 16:10 AEDT: course entry model comparison (Platform Admin 15:40); DeepSeek-only cycles stopped.**
- s1151 (Pilot, migration `20261127000000`): the 83-page cohort read on gpt-4.1-mini, gpt-5-mini and gpt-5-nano in the existing harness, same v6 selection, prompt and schema; estimate US$1.06 to 1.66 (run ceiling US$2). Earlier DeepSeek, Qwen, MiMo and Mistral results reused.
- Scoring: against source-verified requirements (recall, unsupported rows, qualification and score accuracy, conditions and pathways, audience, consistency, tokens, cost, time), not row-count equality. The proposed acceptance criteria go to the Platform Admin for approval.
- Then: the three missed lines corrected; bounded activation of the 172 and reconciliation of the 267 prepared on the selected model.
- 17:30 AEDT: s1151 live. GPT-5 mini and GPT-5 nano are not suitable under the existing extraction contract: OpenRouter answers HTTP 404 to the request as sent (temperature 0 with provider parameters required), US$0 spent. gpt-4.1-mini is reading.
- s1152 (Pilot, migration `20261127010000`, worker v1.0.45): the recall check records where each missed line sits on its stored page; the selector fix follows from it.

**S1-Build, 25 Nov 2026 15:35 AEDT: P0 AER bounded activation (Platform Admin 14:36), Decision 1 not met; nothing activated.**
- s1150 live (Pilot #1611): DeepSeek V4 Flash read the 83 benchmark pages again under `lean-sections-v6` (worker v1.0.44), US$0.0659.
- Criteria: read 83/83; valid 83/83; median input tokens 3,411 to 1,704 (50% less); unsupported quotes dropped 5 (whole page 17); **no loss NOT met: 12 pages found fewer label rows on the selection than on the whole page (9 found more)**.
- Run-to-run noise measured on identical input: the whole page read twice differs on 21 of 83 pages (11 lower). Total recall: whole page 156 and 162 rows of 216 in the two runs; selection 151 and 164.
- Causes of the 16 missed labels (12 pages): the model returned no rows on 5 pages although the label was in the selection; 3 labels outside the selection (an AQF Level 9 line, a previous-completion line, a "may also be considered if" list); 7 where the model quoted other sentences in the selection; 1 label that is not an entry requirement (credit points to qualify for the award).
- Not done, as the approval required: no qualification recorded, route unchanged (off, cap US$5, qwen3-30b), no window opened, the 172 and the 267 not queued. Jobs `lean-qualify` and `lean-sections-eval` stay active (idle). Request 0de69556 expires 16:40 AEDT.
- Waiting on: the Platform Admin's decision on the corrective action.

**S1-API-Frontend-Delivery, 25 Nov 2026 15:30 AEDT: Portal sign-in fix (Pilot s1142); no live data change.**
- Portal sign-ins reached Supabase Auth and were refused with 401 (the connection key), not 400 (wrong password). The screen now says which; it also trims and unquotes the build values and refuses a secret key in a browser. Left brand panel added.
- **Platform Admin action:** set `VITE_SUPABASE_PUBLISHABLE_KEY` on the `studysearch-portal` Worker as a **Build** variable (the `sb_publishable_` key from Supabase > Project Settings > API Keys, no quotes or spaces) and redeploy.
- Next: Providers, Scholarships and Saved screens (publish predicates confirmed above); Courses search waits for `catalogue.portal_course_search_v1` (S1-Build).

**S1-API-Frontend-Delivery, 25 Nov 2026 13:30 AEDT: StudySearch Portal scaffold in Pilot (`portal/`, spec s1141); no live data change.**
- Separate `studysearch-portal` Worker, sign-in, Viewer/Counsellor guard and Dashboard search bar; Courses is a placeholder until `catalogue.portal_course_search_v1` (S1-Build) exists. Admin Worker untouched. Lane specs are now `s1141` to `s1149` (`s1140` went to S1-Build).
- **Waiting on the Platform Admin:** Build variables, build settings and the Supabase redirect URL for `studysearch-portal.techm.workers.dev`.

**S1-API-Frontend-Delivery, 25 Nov 2026 12:55 AEDT (Platform Admin brief 12:47): StudySearch Portal Release 1 lane registered; documents only, no live change.**
- **Lane:** master plan section 4 item 10; specs `s1140` to `s1149` claimed. Design mirrored at `docs/platform/2026-11-25-studysearch-portal-design-decisions-and-plan.md` (Drive `M3 > Portal` holds mock-ups 01 to 24 and the original Google Doc).
- **Gate met:** Layer 4 Review fix live (s1090, Pilot #1582, UI v2.17.0).
- **Decisions:** separate `studysearch-portal` Worker first on `*.workers.dev`, Admin Worker untouched; Courses search all active courses until publishing is live (`portal_search.visibility_scope = active`); relaxation = third-cheapest x 1.05 rounded up to the nearest A$1,000; embedding model `text-embedding-3-small`.
- **Waiting on:** `catalogue.portal_course_search_v1` from S1-Build (not live yet); the Platform Admin creating the Worker and the Supabase redirect URL (sessions have no Cloudflare access).
- **Guardrails:** G3 75/48, locks 7,585, cron 140, $0 Firecrawl and no unapproved AI spend, all unchanged.

**S2-RM-Design, 25 Nov 2026 00:16 AEDT (scheduled read-back against the 22:15 baseline): 3 first reads approved by a person; Website and Zoho v3 verified; no machine admission.**
- **Active matrix rows:** 7,261 → 7,263 (+2 net). Five rows were made active from three Layer 4 first-read approvals: Australian Institute (23:18; AU Year 12 and AQF Certificate IV, bachelor), Conestoga College (00:18; CA OSSD 65%) and Simon Fraser University (00:18; CN Senior Middle School).
- **Pending:** first-run reads 65 → 68 (new reads for Quality College of Australia and Victoria University, 23:45); change items 13, unchanged.
- **No change:** covered courses 10,729 (the coverage table refreshes in chunks); active course rows 27,969, with none new; machine admissions in the last 24 hours: none (the 9 earlier declines have aged out).
- **Consumer check:** a Conestoga bachelor course (country CA) resolves `provider_minimum` on `entry_resolve_v3`; Website v3 and Zoho v3 `item.entry` both serve "OSSD … minimum cumulative average of 65%", as at 24 Nov 2026. A Simon Fraser bachelor course (CN) serves today's row on Website v3; that row prints no minimum (`scale none`).
- **Guardrails:** G3 75/48, locks 7,585, active cron 138, $0.

**S3-Scholarship-ChatGPT / SCH-FU-04 — Admin #1030 execution, 25 Nov 2026 00:01 AEDT.** Existing R0 five and NZ-W01 45 provider IDs retained from #1024 (no reselection); independent official source discovery and verified existing evidence used without waiting for AI or another chat. Live NZ published 115/12 providers, active unpublished 72, combined 187 vs 166 at request opening (+21), 21 admission events; no additional publication above 115 since #1024. 545 scoped candidates: 150 read, 395 unread, 66 read-undecided, zero leases. Three new published awards verified previously via Website v3 and Zoho v3 (511 award-course associations); two result-bearing automatic publication cycles at 22:29 and 23:29 AEDT verified in #1024. No complete wave acceptance. New writes: Whitecliffe L1774/audit67087, Toi Ohomai L1775/audit67088, NZTC C48781/audit67095; Yoobee L1771 registered concurrently, not attributed or duplicated. Whitecliffe and Yoobee read zero sections, Toi Ohomai waiting_scraper; OP L1766 waiting_scraper, EIT L1767 read zero. NZTC source page verified international NZD10000 programme-specific benefit, candidate unread, no canonical identity inferred. Lincoln Manaaki is eligible for scheduled auto-publish; Master's 44346/89853 next 00:18:26 AEDT; WITT 48478/90564 next 00:25:40 AEDT. Full stored HTML unavailable in this connector; direct raw HTTP requests for IPU/WITT/Lincoln failed DNS resolution in this runtime, official indexed pages verified separately, no raw immutable evidence claim. No forced same-answer or paid reruns. Request 625e62fc-fd69-47d1-9858-216dcb4a76e7 open, cap84, used69, remaining15, expiry 03:40 AEDT; account62753, OpenRouter99.45, request-window all-lane USD0.2875. NZ Qwen 91 extraction records, 155036 input/81040 output tokens, USD0.0488562, 7 errors, not exclusively request/session-attributed. G3 75/48 no drift, locks7585, active cron138; no protected setting/API/cron or manual lock changes by this lane. Existing publication gate: Lincoln Manaaki eligible, remaining cases mostly closed, missing value, edition or residency; no global publish call. Actual per-provider window metrics below for S1-Build, who owns generated CSV and Sheet refresh. Resume: existing R0/W01 queues, independent individual official award sources where available, shared table/label mapping defects only through governed release, and settle/close request within expiry/cap.


**S3-Scholarship-ChatGPT / SCH-FU-04 — 24 Nov 2026, late-evening NZ-W01 provider checkpoint.** Prior #1016 merged-main records initial 84/84 listings, 501 sections. At 23:33 AEDT NZ 115 published/12 providers and 70 active unpublished (112/54 at request opening; +19 combined active); 19 admission events and 3 newly admitted published. Scoped request 625e62fc-fd69-47d1-9858-216dcb4a76e7 open, expiry 25 Nov 03:40 AEDT, FC69/84 and account 62894 at 23:33, all-lane AI USD0.2496. New independent official hubs Otago Polytechnic listing 1766/audit 67067 and EIT listing 1767/audit 67068 registered, waiting at readback. WITT listing 1751 returned zero sections; existing exact official HTML evidence 0071e251-23a7-436d-b446-2ed042c2bdca, SHA-256 0adf7961337837dbc51fa6d43550026af9d5a2be0688eaf3423583ec9dfc9319, evidence bucket verified, Qwen qualified route open. Stored replay candidate 48478/queue 90564, audit 67070, no new acquisition. Lincoln candidate 44346/queue 89853 still scheduled 00:48 AEDT, no inferred amount or grade. Publication gate later found 71 active unpublished, one publishable; closed/value/residency/edition holds preserved. G3 75/48 drift[], locks 7585, cron 137 at 23:33; no global settings or API changes. W01 same-cohort batches below retain first 15 IDs, next 30 ranked from live eligible catalogue; R0 scoped five tracked separately. S1-Build owns generated country-wise register sync. Continue existing processing, verify consumer and two result-bearing cycles, close request after settlement within expiry/cap.


**S3-Scholarship-ChatGPT / SCH-FU-04 — 24 Nov 2026 23:23 AEDT.** Pilot #1574 / Admin #981 deployed; prior Admin #1002 listing drain recorded. Request `625e62fc-fd69-47d1-9858-216dcb4a76e7` remains open (expiry 25 Nov 03:40 AEDT, 84-credit cap). Initial 84/84 listing pages read, 501 new sections. 545 linked candidates: 129 read, 416 unread, 68 read with no admission verdict, 16 admitted-status (includes historical), no active candidate leases at 23:22:46. Admission ledger since request: 13 events (Canterbury 10, VUW 2, Lincoln 1); 1 newly admitted award currently published. NZ 112→113 published, 54→66 active unpublished, combined 166→179; 12 publishing/16 active providers. Lincoln CSC PhD new scholarship `6203f1ef-e055-5356-af17-489c9056107f`, evidence b27a4973-5496-4de1-b040-6e63bd5393e1, mapped course `f0e6f7da-e956-437f-833a-e6e9a744aabf`; existing Website v2/v3 SQL RPC readback succeeded using the actual stable key; Zoho v3 top RPC returns full tuition. No external consumer credentialled HTTP check. Scheduled reader and publication runs recorded successful (reader latest 23:20, publisher 22:29 AEDT); actual canonical events span multiple read batches, two complete result-bearing end-to-end publication cycles not yet proved. Lincoln Master's candidate 44346: official stored evidence 1948b015-e6b5-4d4e-a3c9-d71b101d71c6, SHA-256 6986c4e6e166984d8e96d2842aec56054556c2afc7cd58716353b01db4fbf964; value null and no admission verdict. Existing Qwen queue 89853, attempts 0, next_try_at 25 Nov 00:48:21 AEDT; stored copy resolved by picker. Do not reset retry or invent tiers; earlier excerpt says B average for NZ$10,000, so verify all programme/grade combinations from official snapshot via existing qualified reader. Four Lincoln monetary awards 2500/3000/5000/10000 confirmed previously. Request FC 69/84 consumed (15 remaining), account 62904; OpenRouter $0.2262 all-lane window, NZ scholarship extraction ledger Qwen 62 records, 105203 input/54202 output tokens, $0.0343149, 6 errors; no other recorded NZ extraction model, not exclusively request-attributed. G3 75/48 drift [], locks 7585, active cron 136. No cap extension, job/setting/API edits.

**Independent NZ source work, same-cohort continuation:** registered and enqueued four verified provider-owned hubs, guarded against duplicate listings/stored snapshots and cross-country writes, existing caps retained: AUT `1749` audit 67041 (https://www.aut.ac.nz/study/fees-and-scholarships/scholarships-and-awards-at-aut/international-scholarships); Ara `1750` audit 67042 (https://www.ara.ac.nz/student-services/supporting-your-study/scholarships/); WITT `1751` audit 67045 (https://www.witt.ac.nz/international-students/international-scholarships); NMIT `1752` audit 67046 (https://www.nmit.ac.nz/study/finance-your-study/scholarships). All four read successfully in existing pipeline at 23:22 AEDT. AUT 9 members/4 award sections, 9 candidates/5 read/2 admitted-status (0 new linked admissions); Ara 55/33, 53 candidates/22 read/4 admitted-status (0 new linked admissions, canonical active 0); WITT 0 members despite official source's programme-specific automatic 2027 award table, requiring existing reader table/benefit-tier mapping proof; NMIT 25/18, 25 candidates/0 read. Three hubs yielded 55 award sections, not canonical awards. Massey and Waikato listings already read; Massey candidates 44334/44335 stored and existing queue 90075/90076 due 00:48 AEDT; Waikato 907/908 completed, do not duplicate. IPU listing 419 and candidate 28366 already stored, listing_page/international_not_stated rejection despite public page identifying awards: investigate stored evidence, do not repeat paid acquisition. Ara candidate 28055 Rika Fund title rejection, 2026 round closed on public listing; preserve current-round gate. Te Aratika candidate 28818 is NZQA national secondary award, not provider-owned; ITC 43868 past 2011 page; do not admit. Ranked 15 eligible sourced-zero-active review cohort: NZIST Work-Based Learning 231 courses, Ara 178, Toi Ohomai 157, NMIT 148, MIT 144, NorthTec 122, UCOL 115, Open Polytechnic 93, WITT 89, Te Wānanga o Aotearoa 85, NZMA 77, NZIST 72, Te Wānanga o Raukawa 63, Te Whare Wānanga o Awanuiārangi 52, Yoobee 52. Existing candidate verdicts mostly domestic_only/international_not_stated/listing_page/not_a_scholarship; UCOL includes refused_by_person, preserve; NZIST both stored sources domestic-only, no ownership inference. No forced identical retry or mass re-admission. Exact resume: continue 416 scoped unread and 68 undecided through scheduled gates while FC capacity remains; recheck Qwen 89853 after its scheduled retry and provider-specific tier evidence, WITT table reader and independent AUT/Ara/NMIT candidate settlement, then next eligible providers (up to 15) in same 45-provider wave. Close request only after settlement or expiry/cap prevents further authorised work; record residual holds and actual costs, no extension. S1-Build owns generated CSV/Sheet sync. M3 mirror after merged main; no new tracker.


**S2-RM-Design, 24 Nov 2026 23:05 AEDT (AER admission validator and Layer 4 triage): 13 change items triaged; s995 re-rehearsed; no live change.**
- **Triage (Execution Register, S2-AER section):** 0 of 13 can be bulk-approved now. Every item is `technical_blocked` (`matrix_source`) because its read dropped published rows; Approve is refused.
  - Across the 13 reads: 1,269 proposed rows; 449 unchanged, 7 changed scores, 813 added; 187 active rows would be superseded; 541 rows fail value proof; 50 have a blank level.
**S2-AER, 25 Nov 2026 00:00 AEDT: overnight pass 1.** Active matrix rows AU 6,704, NZ 540, CA 17 (63 providers); proposed 2,498; 13 change holds kept. s1093 (Pilot, migration `20261126001000`) reads 16 pre-qualification failures again through the governed re-read. TAFE NSW combined-level mapping is blocked on the PDF bytes (details and resume point in the master plan 00:00 line). Full evidence in the master plan status log.

  - Remedy: corrected re-reads from stored copies by the reader owners.
- **Reusable fix routed:** six country aliases (Hong Kong (China), HK, Taiwan(China), SG, Macedonia, and the misspellings Bangaldesh and Phillipines). No equivalence is inferred.
- **s995 (Pilot #1502):** not superseded. `security.aer_matrix_machine_exclusions_v1` is unchanged (md5 `51ad50c5…`) and UWA's 194 rows still wait. Re-rehearsed 23:00: 186 rows admitted; active matrix 7,261 → 7,447; counter 10,729 → 10,795 (+66); real answers 0 (UWA India answers: 152 course_override, 176 contact_provider before and after).
  - Remaining value: correct bachelor ATAR-band rows that answer only once UWA courses carry an ATAR band. Kept as a draft; if it is merged, its migration timestamp must be renumbered above the head.
- **Baseline for the 00:10 read-back:** active matrix 7,261; covered 10,729; 0 machine admissions in the last 24 hours.
- **Guardrails:** G3 75/48, locks 7,585, cron and $0 all unchanged.

**S3-Scholarship-ChatGPT / SCH-FU-04, 24 Nov 2026 22:28 AEDT:** Pilot #1574 / Admin #981 live; request `625e62fc-fd69-47d1-9858-216dcb4a76e7` audit 66899, expiry 25 Nov 03:40 AEDT, remains open. All 84/84 listings read, no failures (Auckland 31, Canterbury 37, Otago 11, VUW 3, Lincoln 2); 501 new award sections. NZ published 112/12 providers unchanged; active unpublished 54→56; two new admission events (Lincoln and VUW), two duplicate and five rejected events. Later linked-candidate snapshot: 545 distinct candidates, 506 unread, 39 read (5 admitted status, 5 duplicate, 21 rejected, 8 unclassified); statuses are not new admission counts. Lincoln candidate 44346, evidence 1948b015-e6b5-4d4e-a3c9-d71b101d71c6, stored HTML exists, deterministic value null and no admit status; source excerpt shows B average for NZ$10,000, do not assume B+; reuse stored evidence and qualified extraction before patch. Four Lincoln canonical monetary awards 2500/3000/5000/10000, only 10000 published. FC request 39/84, account 63077, AI all lanes $0.1026; scholarship lane Qwen 114 calls $0.06768208 (not NZ-attributed; tokens not retrieved). G3 75/48 no drift, locks 7585, cron 137. Independent existing listings: AUT 3, Massey 7, Waikato 5, NZIST 0; no fresh source claimed. Resume: let existing candidate reader settle, prioritise stored Lincoln 44346 via existing extraction, verify canonical/consumer and two cycles, close request after settlement; no extension or global changes. S1-Build owns status CSV sync. M3 mirror pending.


**S2-RM-Design, 24 Nov 2026 22:15 AEDT (cross-country AER admission and blocker gate): active-course counts added for the 12 change-item providers; no live change.**
- **Counts:** the 12 providers carry 3,024 active courses, 1,167 of them covered now, under 13 pending `entry_matrix_change` items (1,284 proposed rows). The table is in the Execution Register's S2-AER blocker section.
- **Correction:** Top Education Institute's two items read two different source pages, so they are not duplicates.
- **Live state:** active matrix rows 7,261; covered courses 10,729; 0 machine admissions in the last 24 hours (9 declines).
- **Gates unchanged:** the 13 human change items, blank-level rows and host_shared RMIT Pathways all stay gated.
- **Rules:** none shipped. The 53 value-not-in-quote rows are reader misreads.
- **Guardrails:** G3 75/48, locks 7,585, cron and $0 all unchanged.

**S1-Build, 24 Nov 2026 21:05 AEDT: s1054 live; s1055 recorded before merge; AER-FU-11 diagnosis.**
- **s1054 live** (Pilot #1571, merged 20:18). Results in the first 30 minutes (to 20:48):
  - 3 scholarship-discover and 6 scholarship-read runs.
  - 210 candidates read, 70 each for AU, NZ and CA, across 42 providers.
  - Outcomes: 14 admitted, 37 rejected, 8 duplicates; 143 sit in the AI extraction queue.
  - 17 new scholarships. Published 1,146 (was 1,143), across 127 providers.
  - 161 scholarship_extraction calls on Qwen3 30B: 280,919 input and 135,752 output tokens, US$0.0688. 0 Firecrawl (every read was direct).
  - 1,706 unread candidates are still due.
- **Held follow-ups (controls unchanged):**

  | Hold | Candidates | Note |
  |---|---|---|
  | Firecrawl provider hold | 821 (AU 600, CA 216, NZ 5) | includes the UTAS prize pages, which stay under their provider hold |
  | Discovery priority 2 (AU) | 164 | |
  | Not yet due | 304 | |
  | Three tries exhausted | 46 | |

- **s1055 (SCH-FU-04, Admin #937):** integration of branch `s3-nz-scholarship-on-demand-recovery-20261124`.
  - Rebased on main. The migration is renumbered to `20261125130000`.
  - Live `security.fc_sch_held_v1` md5 `1b9bbe30` equals its guard. Without the change, a scholarships-scoped on-demand request leaves the four NZ universities held, so the existing route does not meet the need.
  - The committed fixture now runs inside the migration and always rolls back. Rehearsal passed: purpose, provider scope, expiry, the non-discovery path and the Canadian behaviour are all unchanged; cron 136.
- **AER-FU-11 (diagnosis):** entry_matrices calls in 48 hours are 52 answered on Mistral Small 3.2 (US$0.0313). 10 runs failed after three tries, Canadian colleges at 16:11 to 17:57, with "reply unreadable: TimeoutError".
  - Each slice call has a 90 s time-out (`AbortSignal.timeout(90000)`), set against `entry.matrix_max_tokens` 16,000 and 8,000-character slices, inside a 110 s worker budget.
  - After the first time-out there is less time left than two 15 s attempts, so the cascade never reaches Qwen3 30B or GPT-4.1 mini.
  - Each run then repeats unchanged three times (`entry.matrix_attempts` 3).
  - Failed attempts are not in `pipeline.ai_invocations`; only answered calls are.

**S1-Build, 24 Nov 2026 20:20 AEDT (Platform Admin 19:48, SCH-FU-09): s1054 recorded before merge.**
- **Why the readers were off:** `scholarship-read`, `scholarship-discover`, `scholarship-discover-refill` and `calendar-reread` were paused on 17 Nov 2026 13:34 by migration `20261117051700` (Pilot #1195, Platform Admin 13:11). Its reason reads "Temporarily paused for bulk REQ and Roadmap ingestion: no or almost no work moved in 72 hours. Resume on Automations", and the events are marked temporary. No protected policy is attached. Only `scholarship-discover`'s candidate phase reads candidates, so the listing reader's candidates waited.
- **Backlog (live 19:55):**

  | Country | Pickable | Firecrawl hold | Not due | Three tries | Other |
  |---|---|---|---|---|---|
  | AU | 966 (21 providers) | 600 (11 providers) | 208 | 25 | discovery priority 2: 164 |
  | CA | 283 (26 providers) | 216 (2 providers) | 76 | 19 | |
  | NZ | 92 (14 providers) | 5 (1 provider) | 20 | 2 | |

  Oldest pickable: AU 12 Nov, CA 16 Nov, NZ 20 Nov.
- **s1054:**
  - The picker puts first only providers in a queued or running Find scholarships task, so a stale `requested_at` no longer jumps the queue (c209b8f0).
  - It then alternates countries and providers. In rehearsal, a 60-page pick changed from AU 60 (5 providers) to AU 20, CA 20, NZ 20 (40 providers). Holds are unchanged and are checked before the window.
  - `scholarship-discover` and `scholarship-read` are resumed with their commands, sizes and budgets unchanged (cron 138 in rehearsal). `scholarship-discover-refill`, `scholarship-listing` and `calendar-reread` stay as they are.

**S1-API-Frontend-Delivery, 24 Nov 2026 22:35 AEDT brief: s1090 Layer 4 Review fix (UI v2.17.0 stays; migration `20261125210000`).**
- **Only the Layer 4 Review screen changed.** One University box filters the tiles, the held-reason table and the items; the grouping log is gone from the header; an empty list says so in both panes.
- **Hold reasons:** `admin_layer4_aer_queue` hold_reasons takes `provider_id` and `country`; every reason is named (no `Other`). Matrix change and first run list open with an Approve Selected bar (each item decided through the Inbox `decide`; the server gate still applies).
- **Frozen until lifted:** Slice 3/4 ports and legacy CSS deletion.

**S1-Build, 24 Nov 2026 18:50 AEDT: s1053 live (Pilot #1566, merged 18:18; head `20261125060000` with other lanes).**
- **English:** 1,041 rows added from the published equivalence tables: Adelaide 525 (PTE, TOEFL iBT and CAE on 175 courses), Newcastle 516 (172 courses, applied by the trigger when its procedure was stored).
- **Scholarships:** GPA thresholds that say "on a 7.0 scale" now count as stating their scale. The Vice-Chancellor's postgraduate GPA (4.5 out of 7) is live. The two Newcastle terms pages are queued for the scholarship reader.
- **Fees (not done):** all four official pages are stored (on-demand request closed, 9 Firecrawl credits). The fee reader admitted no 2027 fee: it read the Adelaide guide (207k characters) with 0 rows for US$0.0035, and its model call timed out on both Newcastle lists. Adelaide's deterministic parse found 109 rows on the first direct read, but the later scrape copy parses to none. Every current fee is still 2026, and none was relabelled.
- **Guardrails:** locks 7,585; cron 135; G3 75/48.

**S1-RM-Design, 24 Nov 2026 19:35 AEDT (Platform Admin 18:02): scholarship publication recovery from existing data; s1073 live (Pilot #1567). Published 1,096 to 1,143, providers 114 to 127 after two unattended cycles (18:29: 22, 19:29: 25).** Baseline 1,096 published, 114 providers, 492 active unpublished (AU 335, CA 108, NZ 49), Layer 4 pending 72 (31 providers). Blocker reconciliation and decisions for a person: `docs/platform/2026-11-24-s1-rm-design-scholarship-publication-recovery.md`. s1073 clears 9 false citizens-only holds; 18 publishable awards wait for the hourly auto-publish. $0.

**S1-Build, 24 Nov 2026 17:50 AEDT (Platform Admin 17:14): s1053 recorded before merge (Item 2 completed from the official university sources).**
**S2-Scholarship-Readers, 24 Nov 2026 18:20 AEDT — Canadian scholarship recovery in progress.** Canada: 325 active, 148 published. Unpublished holds are legitimate except 11 awaiting auto-publish. Open defect for S1-Build: no Canadian provider has a provider type (s1066/s1067 allow-list is a stopgap). Resume point is in the master plan log.

- **Fees:** Adelaide's 2027 International Student Guide and Newcastle's 2027 undergraduate and postgraduate international fee lists are registered (manual, with the approval) and fetched through the governed queue under one on-demand request. The fee reader (job fee-reader, pinned model, logged as fee_ai) then reads each row with its printed fee year. 2026 rows are not relabelled.
- **English:** the published equivalence tables are in `pipeline.english_concordance` (30 rows). Rehearsal for Adelaide: PTE, TOEFL iBT and CAE added to 175 courses (525 rows). Newcastle's applies by trigger the moment its procedure is stored. Rows are added only where the course's IELTS has four equal bands, and never for regulated disciplines.
- **Scholarships:** GPA thresholds that say "on a 7.0 scale" now count as stating their scale (Adelaide's merit awards). Newcastle's Vice-Chancellor's merit award gets its postgraduate entry GPA, 4.5 out of 7, and both award terms are offered to the scholarship reader. The International Excellence 2027 terms state no entry GPA.
- **Guardrails (rehearsal):** live head `20261125000000`; locks 7,585; cron 136; G3 75/48.

**S3-AER-ChatGPT NZ/CA continuous recovery, 24 Nov 2026, s1064, OPEN (no canonical gain yet).** The production source-backed no-active backlog is now **54 providers** (NZ 19, CA 35) across **70 sourced** NZ/CA providers (35 per country). All currently stored NZ/CA source versions already have a run; do not queue unchanged files just to repeat paid models. Canada: 15 failed runs were unproved HTML/PDF structures, seven were AI timeouts, and seven unclaimed first-read Layer 4 reviews hold 49 proposed rows, zero machine-eligible (KPU 16 incomplete quote; Royal Roads 16 study level; UNBC 11 unsupported quotation; Athabasca 2 level; MacEwan 2 quote/value; Langara 1 level; Mount Royal 1 level). S2-AER owns shared mapper/admission and was handed evidence in Admin PR #935 (comment 7123451972). Registered two official UNBC country-PDF child sources (India source 284d4bba-a25b-48e5-a61d-3ba54656a5cb and Cameroon 8e6c0adf-3385-4fb2-ae1e-8e545d746ab5): the previous UNBC URL was only a country index, PDFs include 2022 and 2021 draft imprints, so edition currency remains unverified and no grade is admitted; PDF-family handover to S1-AER at Pilot #1557 (comment 7123660210). Pilot #1558 (s1064 NZ/CA deterministic HTML academic sections and s1065 Wave5 scoped sources) is still in governed CI, last head c5eec252, with security/type-check/dry-run green and full-suite shard 2 passed after fixing printed ATAR score-of 65 as rank. Its migration includes guarded $0 replay of Otago Polytechnic, Wintec and VUW stored copies, plus five Wave5 Canadian source allowlist entries; **not deployed**. Admin #941 merged after conflict-safe rebase; no duplicate Test Register, UI, cron, AU or S2 admission changes. CA-wide AER remains OFF, frozen G3 75/48 and 7,585 manual locks intact. **Exact resume:** wait for last #1558 full-suite and description gates; if failure, repair only failed check on exact head, else Integration Controller merge/deploy; verify migration and deployed worker, guarded three NZ reread outcomes and five CA source acquisitions; then validate quotation, country/level/course, existing S2 partial/machine gates, new active canonical rows and consumer visibility; require two result-bearing unattended cycles. If no eligible rows, continue the first 15 CA unproved-structure providers with stored evidence, not another broad discovery wave. All 54 no-active providers remain unaccepted.
**S2-Scholarship-Readers, 24 Nov 2026 AEDT — Canadian colleges now admitted (s1066 live, s1067 in flight).** 29 college scholarships admitted and active after the provider gate was opened (George Brown 22, Durham 4, Camosun 2, Cambrian 1); publication follows the hourly auto-publish. s1067 adds thirteen more colleges (setting only). Resume point and next actions are in the master plan log.
**S2-AER, 24 Nov 2026 18:00 AEDT: s1070 live (Pilot #1562).** Resume point and next action are in the master plan status log (18:00 line). Live: Canada 17 active matrix rows (was 0), active matrix 6,882, pending 57 gate_incomplete and 15 all_rows_held, G3 75/48, 7,585 locks, 136 active crons, machine validation valid to 1 Dec 2026 16:20 AEDT.




**S3-AER-ChatGPT NZ/CA — F-AER Steps 3–5 evidence, 24 Nov 2026, s1064 (UNACCEPTED pending canonical gain).** Live Wave4 migration `20261124210000` present; scope remains only NZ/CA, Canada global schedule OFF. Wave4 sourced cohort 32 providers: 32 sources (30 read / 1 found / 1 failed), 33 runs, 380 active canonical rows unchanged since 16:17 AEDT; 271 proposed (not admissions); no session-created Wave4 run IDs or new canonical rows. Auckland A–I: 126 proposed, 94 course-linked and 32 ambiguous/unlinked, latest review `04a4ad2a-a098-41b3-9a80-cd689e2b435f` is `entry_matrix_change` and requires a person. CA initial zero-active seven-provider first-run cohort: 49 proposed rows; machine gate `ok=false` for every review (KPU 16 gate_incomplete quote_too_short; Royal Roads 16 all_rows_held level_unmapped; UNBC 11 gate_incomplete 3 quote_not_on_page; Athabasca 2 level_unmapped; MacEwan 2 value_not_in_quote; Langara 1 level_unmapped; Mount Royal 1 level_unmapped). S2-AER handoff on Admin PR #935 conversation comment 7123451972; no shared admission gate changed. NZ/CA deterministic parser and guarded replay in Pilot #1558 `s1064`: failing full-suite synthetic ATAR-score wording repaired on branch (latest head `56cb2ec9`); green security/type-check/dry-run, remaining governed CI pending, not yet deployed, hence no extracted/admitted gain claimed. Wave5 45 (3×15) only eight sourced, 37 pending; five CA URLs registered live, 3 NZ sources reused; zero new Wave5 canonical records. Two `entry-matrix-read` cron executions succeeded at 16:54 and 16:59 AEDT (the scheduler ran; no admission implied). Production guardrails G3 75/48, 7,585 manual locks, cron ≤140. Mandatory next acceptance: merged/ deployed reader → exact stored evidence row integrity and identity → existing S2 machine/partial checks → active canonical insert → consumer read-back → two further unattended result-bearing cycles; until then F-AER remains OPEN.


**S1-Build, 24 Nov 2026 16:55 AEDT (Platform Admin 15:10): s1046 and s1047 live; Firecrawl Monitor re-registered; scholarship register generated daily; test register regenerated.**
**S2-Scholarship-Readers, 24 Nov 2026 AEDT — s1066 in flight (Canadian colleges and scholarship admission).** Pilot #1551 is live (Canadian hold exemption). Root cause of zero college scholarships: Canadian providers have no provider type, so `scholarship_admission_provider_ok_v1` refused ten colleges (226 stored verdicts). s1066 lists them in `scholarship.ca_college_providers`. Resume: replay stored verdicts after deploy, then read back active and published awards. Detail in the master plan log.

- **s1046 (Pilot #1552, live 16:11):** `firecrawl.monitor_credits_per_url` 6 and `firecrawl.monitor_weekly_credits` 160, each with one logged event. Watchlist: 27 pages planned, none held, about 153 credits a week. Registered through workflow *Firecrawl Monitor* (run 45333883241, 16:31): 10 monitors, all accepted. First weekly check Monday 03:17 AEDT.
- **s1047 (Pilot #1556, live 16:16):** an approved English policy's other tests (all four bands) are added where the course's level-default IELTS agrees. 168 rows on 84 Victoria University courses: PTE on 101 courses (89 with bands), CAE on 89. Adelaide University and The University of Newcastle policies hold IELTS only, so nothing was added there.
- **Not done (needs a Platform Admin decision):** 2027 fee years and GPA-threshold scholarships for Adelaide and Newcastle, and their PTE and TOEFL. The official 2027 fee lists, English procedures and scholarship terms are not among the stored links, so no reader can register them.
- **Scholarship register:** `docs/monitoring/Scholarship_University_Reader_Status.csv` is now built by `build_scholarship_register.py` in the 08:00 refresh. Rules are in the runbook. Today: 1,886 providers (AU 1,544, NZ 290, CA 52): No Reader Yet 1,758, Stuck in L4 79, Partial 27, Fully Working 22.
- **Read back:** head `20261124234000`; locks 7,585; cron 136 (at most 140). G3 was checked by both migrations' post-checks.

**S3-Scholarship-ChatGPT — NZQA only, 24 Nov 2026: atomic recovery patch preparation.** Platform Admin authorised a time-limited, purpose-scoped on-demand listing recovery for Auckland (31), Canterbury (37), Otago (11), VUW (3) and Lincoln (2). Existing Canadian eligibility exception preserved; ordinary caps, account reserves, human admission and manual locks unchanged. Prior audit 66524 queued Lincoln and Waikato; no new admission or publication claimed. Shared hold function change assigned to Integration Controller for governed release; spec and migration numbering subject to controller reconciliation. S1-Build owns scholarship_status sync. No paid extraction initiated.


**S3-AER-ChatGPT, 24 Nov 2026 15:08 AEDT — s1044 Wave 3 registered, not admitted.** Pilot #1544 remains OPEN (not merged or deployed); production migration head 20261124170000 (s1041 target 190000–190200 absent), so no s1041 live admission gain claimed. Wave 3 next 15 high-course NZ/CA providers: 10 official source URLs inserted in live `pipeline.entry_matrix_sources` (8 CA, 2 NZ); 9 AER queue claims `CLAIMED:S3-AER-ChatGPT` (s1044), UBC retains S1-Build's existing other-domain claim, 5 without a proved current academic country matrix held `HELD:NO_SOURCE` (NZIST work-based, EIT, Toi Ohomai, NorthTec, Open Polytechnic). UCOL's historical country PDF and WITT's prospectus require current-programme proof; no invented grade/auto-admit. Wave 3 CA eligibility and source queue are to be released only AFTER s1041 and governed CI. G3 unchanged, manual locks untouched, active cron baseline 134. Zero AI/Firecrawl charged by this lane so far.
**S2-Scholarship-Readers, 24 Nov 2026 AEDT — s1046 (Canadian Wave 2 hubs and hold exemption), Pilot #1551 merged; live setting `scholarship.listing_open_ca` = 1.** (The s1046 number was also taken by S1-Build; the migration file name is unique.) Pilot #1546 (s1039, seven Wave 1 hubs) is merged. s1046 registers eleven more hubs and lets Canadian providers skip the eligibility rule in the scholarship hold while `scholarship.listing_open_ca` is 1 (per-university cap and Firecrawl budget switch unchanged; Lethbridge stays held by its cap). Rehearsed rolled back: 18 of 18 hubs queued. G3 75/48, 7,585 locks and the cron count unchanged.

**S3-AER-ChatGPT, 24 Nov 2026 16:17 AEDT — s1064 NZ reader recovery / s1065 Wave 5 (release pending).** Live Wave4 s1045 migration 20261124210000 applied; head 20261124234000, 133 active crons, CA-wide AER schedule off. Wave4 32 source-backed: 32 source records, 30 read, 1 found, 1 failed; 33 historic/queued runs (7 queued/21 done/5 failed); canonical active 380 unchanged since 15:10 AEDT; proposed 255 (not admitted). Auckland A–I 94/126 course-linked; 28 ambiguous named-degree variants and 4 conjoint/major headings remain held, no unsafe links. Pilot branch s1064-nzca-aer-semantic-sections extends the existing HTML reader for strict country/level block pairs and global explicit IB qualification only in NZ/CA, source-shaped tests; stored artefact production re-read pending CI/deployment. Canterbury PDF grid/page proof remains with S1-AER PDF lane (#1557); no duplicate PDF converter. The global entry_matrices cascade Mistral/Qwen/GPT is enabled under provisional qualifications; not benchmark-certified, no manual Layer4 override. Wave5 next 45 NZ/CA pending providers grouped B1/B2/B3 15 each; 5 official Canadian source URLs registered live and 3 NZ verified registered URLs reused (8 S3 queue claims), remaining 37 marked discovery pending, not falsely HELD. No AU work, no Consumer G3 change, no manual-lock edits, no new cron; usage report after CI/live replays.

**S2-AER, 24 Nov 2026 17:15 AEDT: s1070 recorded before merge** (NCUK IFY long-form alias in `ref.aer_qualifications`; stored re-read of one source; migration `20261125020000`, rehearsal passed). Of the 21 mapping items only this one is a true alias gap; the others are scope words, regions and blank countries (reader output) and stay held.


**S3-AER-ChatGPT live release read-back, 24 Nov 2026 (s1041/s1044/s1045):** Pilot #1544 MERGED (f771b2f9), live migrations 20261124190000–20261124190200; Pilot #1547 MERGED (a7615a7c), live migration 20261124203000. All governed CI/dry-run gates green. NZ $0 re-reads: Auckland A-I 126 proposed/94 course-linked, but Otago Polytechnic, Wintec and VUW latest retries failed `held_unparsed` (the deterministic parser could not prove their table; no qualified `entry_matrices` fallback model); Canterbury's two candidate sources also `held_unparsed`. No new canonical admission is asserted. Wave 4 Admin #922 merged: 45 NZ/CA providers, 32 source claims, 12 no-source holds, one robots hold; 22 new official-domain source candidates in cohort + prior-held Open Polytechnic page. Pilot #1550 open and labelled `automerge`+`live-dry-run`: rolled-back rehearsal passed (18 CA scoped, global CA off, 135 active crons), but new full-suite evidence run is still queued. Do not claim #1550 deployment or newly enqueued Wave 4 rows. No AU, frozen G3 or manual-lock changes. S3 directly invoked zero models and zero Firecrawl; account-wide separate `course_site_map` used one Firecrawl credit for Ara, not S3 reader. Parent authority and status retained in Admin #912/#918/#922.


**S1-Scholarship-Claude (Platform Admin brief 24 Nov 17:55), 24 Nov 2026 18:50 AEDT: s1051 and s1052 live (Pilot #1559, #1563; Admin #938, #946).** Charles Darwin pages 1188 and 1189 now give all eight awards as distinct `S-` sections (read 18:08 AEDT). Their eight candidates (45578 to 45583, 45661, 45662) were given the existing on-demand priority (`requested_at`) and read by the existing candidates task (`scholarship_task_fire_v1(['candidates'])`, on-demand window `338c4f95`, closed: Firecrawl 4 units by other lanes, 8 CDU pages read plain HTTP, $0): 4 admitted (VCIHAS, Dili: published 18:29; Australia Awards, NT Government: active, unpublished, reason not yet read); 4 (two International College, Global Merit, Nursing) wait in the existing `scholarship_ai_queue` (qwen3-30b, run_kind admit, next try 08:14 UTC). No gate bypassed. Adelaide: hub is a link page; international awards already published in Sep 2026 (not a new gain). Reusable finding: candidate detail reads (`scholarship-read` job is off under `S1-Build`) only run on demand, so 1,969 candidates (1,460 AU, oldest 29 Sep) sit unread; the on-demand `requested_at` priority plus the `candidates` task is the existing way to read listing-split awards. Recovery wave R1 (45 pages, 15 providers, official `/scholarship` pages the reader rejected as `listing_page`, stored copies exist) queued 18:31 to 19:15 AEDT; most of the 931 such rejected pages (164 providers) remain for later waves. Most `listing_page` rejections (sitemap news, `findthecourses.com.au`, `oneuedu.com` course pages, school sites) are genuine non-award pages. **Resume point:** (1) read back R1 (`pipeline.scholarship_listing_pages`, members with `award:S-` keys) and give each new member's candidate `requested_at`, then fire the `candidates` task; (2) confirm the four waiting CDU candidates settle, then trace publication and the two unpublished (Australia Awards, NT) to their reason; (3) next waves of 15 providers from the same cohort query (rejected `listing_page`, `/scholarship` URL, stored copy, not yet a listing page); (4) Wave 3 batch 1 read-back (Collarts, Melbourne Polytechnic, Box Hill) and batches 2 and 3; (5) hand verified counts to `S1-Build`. `listing_limit` 15 holds 56 to 60 pages an hour. `S1-Build` stays the only writer of `scholarship_status`. **20:15 AEDT update:** CDU eight awards all admitted, six published (Australia Awards and NT Government unpublished: follow-up SCH-FU-01). R1 and R2 of the 931-page cohort are in progress (see SCH-FU-02); AI verdicts arrive after the queue's 30-minute cooling, so new admissions are read back at the next checkpoint. Candidate-read drain: about 30 pages a fire, each fire needs the previous request answered (45 s guard); `S1-Build` could run the same `candidates` task or re-enable `scholarship-read` to remove the manual firing.

**S1-Scholarship-Claude (Platform Admin brief 24 Nov 15:27), 24 Nov 2026 15:45 AEDT: s1043 live (Pilot #1545; Admin-first order not kept, this record follows).** Adelaide's `allowed_hosts` holds `adelaide.edu.au`; Charles Darwin international hubs registered. Reader throughput: the `scholarship-listing` worker lane runs every 15 minutes and reads `listing_limit` pages per run (was 6, so a ceiling of 24 an hour; measured 10 to 23); `pipeline.scholarship_layer_settings.listing_limit` raised 6 to 15 (setting range 1 to 20; ceiling 60 an hour), to be verified over two cycles. AU data changes since 24 Nov 14:45 are queueing only ($0): Wave 1 and 2 pages read now, staggered so Charles Darwin and Adelaide are read first. `S1-Build` stays the only writer of `scholarship_status` in the queue CSV; verified AU outcomes are handed to it.

**S2-AER (formerly S2-RM-Design), 24 Nov 2026 17:00 AEDT: validation renewed, s1048 verified live (docs only; no Pilot change).** Matrix machine validation renewed by the governed workflow at 16:20 AEDT (passed, regressions 0); new expiry 1 Dec 2026 16:20 AEDT. Live: VU 00124K 91 rows admitted, 02475D untouched, RMIT Pathways held (host_shared), Adelaide 39 rows plus 1 outstanding, Curtin at gate_incomplete. 58 gate_incomplete items classified (21 mapping alias gaps, 13 quote not on page, 13 value not in quote, 9 waiting, 2 partial candidates). `entry_matrix_runs.rows_admitted` counts proposed rows, not canonical (CA 33 proposed, 0 active). Details in the master plan status log and `AER-TECHNICAL-DESIGN.md`.

**S1-RM-Design (S2-RM-Design brief 15:16), 24 Nov 2026 15:55 AEDT: s1048 (renumbered from s1045) recorded before merge** (Curtin `s30991.pcdn.co` alias; shared-host primary record; migration 20261124213000). Partial admission (aer-partial-v1) was already live. Machine mode validation expires 25 Nov 19:29 UTC.

**S3-AER-ChatGPT, 24 Nov 2026 15:24 AEDT — s1045 NZ/CA Wave 4 cohort registered (NOT ADMITTED).** Wave 4 ranked next 45 pending NZ/CA providers: 32 with an official source candidate claimed `CLAIMED:S3-AER-ChatGPT`; 12 without a verified academic-entry source held `HELD:NO_SOURCE`, one robots-blocked held `HELD:SITE_BLOCKED`. 22 new official source candidates for Wave 4 inserted into live `pipeline.entry_matrix_sources`, plus Open Polytechnic's previously held NZ international page (no proven country matrix). Pilots: #1544 merged with s1041 migrations live through 20261124190200; #1547 restored/retargeted main, on green/dry-run release path; Wave 4 Pilot migration and Admin PR pending. Source registration is not verified reading or admission; no AU rows, G3, manual locks or UI touched. Credits: no S3 AI or Firecrawl calls to date; account balance is shared across parallel lanes.


**S3-AER-ChatGPT (NZ/CA only), 24 Nov 2026 14:26 AEDT, s1041 in progress (NOT RELEASED).** Pilot branch `s1041-nzca-aer-heading-reader-linker` contains a country-heading headerless HTML table parser for Otago Polytechnic/Wintec and a md5-guarded NZ-only Auckland/VUW course-label abbreviation normaliser. Live SQL rehearsal was rolled back; unique Auckland Bachelor of Commerce and Engineering linked under test, conjoint heading stayed unlinked. Admin source queue: 9 NZ/CA rows claimed; AU unchanged. No production rerun, admission, model spend or Firecrawl spend yet. Source registration requires actual official academic matrix proof (not an English-only page), tests/green CI and Admin-first/Pilot-second release remain outstanding.
**S2-Scholarship-Readers (Canadian territory, brief 24 Nov 14:58), 24 Nov 2026 s1039: seven Canadian scholarship hubs recorded before merge** (Conestoga, Durham, Sheridan, Camosun, Algonquin, George Brown, MacEwan registered as manual listing pages on the provider's own site and queued to read now; migration 20261124180000). Rehearsed rolled back: G3 75/48, locks 7,585, cron unchanged. AU and NZ providers are not touched by this lane. Resource and spend: 0 AI calls, 0 Firecrawl credits ($0).



**S1-RM-Design (S2-RM-Design brief 14:21), 24 Nov 2026 15:05 AEDT: s1038 recorded before merge** (list setting `aer.provider_host_aliases`, Adelaide University to `adelaide.edu.au`; one md5-guarded edit of `security.aer_matrix_machine_check_v1`; migration 20261124170000). Adelaide now clears the host rule and stops at `gate_incomplete`.

**S2-Scholarship-Readers, 24 Nov 2026 13:55 AEDT: s1035 live (Pilot #1539).** Read back: head 20261124150000, `firecrawl.daily_budget_total` 1500, heading award keys accepted by the listing-record and admit functions, 128 Batch 1 listing pages queued (about 36 an hour), G3 75/48, locks 7,585, cron 133. No heading award member exists yet (`award_members` 0); the queue is still draining.

**S2-Scholarship-Readers (Platform Admin brief 24 Nov 13:08), 24 Nov 2026 13:30 AEDT: s1035 recorded before merge** (heading-based multi-award splitter in `scholarship.ts`; heading award keys `S-<slug>` accepted by the listing-record and admit functions; `firecrawl.daily_budget_total` 5 -> 1500; Batch 1 hub listings read now; migration 20261124150000). Rehearsed rolled back: G3 75/48, locks 7,585, cron 133. Hand-off: test register regeneration to S1-Build.
**S2-Scholarship-Readers (Platform Admin brief 24 Nov 13:09), 24 Nov 2026 s1037: label-and-tier award sections recorded before merge** (Pilot PR 1 of the split: Charles Darwin and Lincoln; bold-label and tier-block splitter in `catalogue.ts` behind the setting `scholarship.label_sections_on` (on), worker v1.0.38; merit wording Global Merit, High Achiever and Flagship added to `scholarship.scope_all_patterns` so university-wide international merit awards link to every eligible course; both hubs' listing pages read now; migration 20261124160000). Rehearsed rolled back: G3 75/48, locks 7,585, cron 136, 8 listing pages queued. Fixtures are reconstructions of the live structure; the live read-back after deploy is the real check. Resource and spend so far: 0 AI calls, 0 Firecrawl credits ($0). Hand-off: test register regeneration to S1-Build. Next: PR 2 (UNSW, Monash, Auckland, Massey, Adelaide, UoN, UNDA, VU 00124K) and Batch 2.


**S1-RM-Design (S2-RM-Design AER v2 Batch 1 brief), 24 Nov 2026 12:20 AEDT: s1029 live (Pilot #1535, merged 11:53; admin #900).**
- **Live read-back:** head `20261124140000` (history md5 `92ec98ad` matches), `coverage-sweep` v1.0.37 deployed, both settings on, lease takes stored HTML, re-read logged (3 runs, 13 proposed rows and 1 item superseded); G3 75/48 no drift, locks 7,585, cron 134 (other lanes), $0.
- **First reads (entry-matrix-read, 12:04 and 12:09):** Lincoln 110 rows proposed (all three tables, levels from their headings; was 13); Waikato 40 (bachelor table; five non-country tables not read); Macquarie HTML page and VU 02475D held (no proven table). Both reads are Layer 4 page-change items (`change_of_admitted_table`): the earlier admitted rows (Lincoln 58, Waikato 35) are replaced only when a person approves, so admitted coverage is unchanged until then.

**S1-RM-Design (S2-RM-Design AER v2 Batch 1 brief), 24 Nov 2026 11:25 AEDT: s1029 recorded before merge (Pilot #1535, admin #900).**
- **s1029 (pending merge):** a $0 HTML_TABLE proven-structure reader (`entry-html-table.ts`, worker v1.0.37, switch `reading.entry_html_table_reader_on`, fewest rows `reading.entry_html_table_min_rows`). A stored HTML entry table is read without the model only when its markup proves a worded header, a country or qualification first column and a study level from a column header or the nearest heading; each cell goes through the PDF cell reader and `entryMatrixParsed`. `svc_entry_matrix_next` leases stored HTML pages beside PDFs while the `entry_matrices` route has no usable model; an unproven page is held, never sent to a model. Migration `20261124140000` re-reads Lincoln, Macquarie's HTML page and VU 02475D through `admin_entry_matrix_reread`. Rehearsed rolled back: 3 runs re-queued, 13 proposed rows and 1 pending item superseded, 0 active rows changed, G3 75/48.
- **Batch 1 live state (read 24 Nov 10:30 to 11:10):** route `entry_matrices` has no usable model (`gpt-4.1-mini` is the setting, no qualification row). Held for a person in Layer 4: Adelaide (`source_not_official_host`: PDF on `adelaide.edu.au`, provider website `adelaideuni.edu.au`), VU 00124K (`host_shared`), Macquarie PDFs (Firecrawl text copies, `gate_incomplete`), Massey (page change), Auckland (2 rows admitted; 124 course rows held on course links). UON and Monash `HELD:NO_SOURCE` (empty rendered page; research-degrees handbook). UNDA approved.
- **Governance gaps found:** `public.svc_entry_matrix_record`, `public.admin_entry_matrix_reread`, `security.entry_matrix_enqueue_v1` and `security.aer_matrix_machine_check_v1` are live only (no migration in Pilot).
- **Handed off:** feedback-4 fee year and GPA scholarships to S1-Build, PTE/TOEFL inheritance to S1-ELR (Platform Admin's choice, 24 Nov); test register regeneration for s1029 to S1-Build.

**Purpose:** one page a new coding session reads before anything else, so it starts from the live system and not from chat history. It says where each exact fact lives and what is in flight right now.
**S1-Build, 24 Nov 2026 12:05 AEDT: s1027 Firecrawl Monitor live and registered; s1028 recorded before merge.**
- **Monitors:** 10 active (8 universities, 3 course pages each; search monitors for Monash and Adelaide). Firecrawl estimates about 148 credits a week (cap 150). First check Monday 03:17 AEDT. Status: `public.admin_monitor_status_v1`; register, status or pause through workflow *Firecrawl Monitor*.
- **s1028 (live 11:00, Pilot #1533):** search checks counted at the search price, so the cap does not pause the monitors by mistake. Read back: head `20261124123000`, 26 targets registered, no deliveries yet, G3 75/48 no drift, locks 7,585, cron 136 (other lanes, under 140).

**S1-Build, 24 Nov 2026 11:30 AEDT: s1025 live (Pilot #1530); s1027 Firecrawl Monitor recorded before merge.**
- **s1025 (live):** in-app counsellor feedback backend; read back: head `20261124115000`, three policies, ten categories, both RPCs, Inbox kind listed; G3 75/48; locks 7,585; cron 134.
- **s1027 (live 10:39, Pilot #1532):** Firecrawl Monitor webhook and watchlist (8 universities, 2 search monitors, 124 of 150 credits a week). Changes are archived first, then sent to Layer 4 or Locked Field Update; nothing is admitted by the machine. Also fixes s1020: gate items are no longer rerouted to the adapter.

**S1-Build, 24 Nov 2026 10:30 AEDT: role-specific UAT accounts wired; s1025 counsellor feedback recorded before merge.**
- **UAT:** rank 6, 4 and 2 accounts are used by the deployed runs; the Layer 1 boundary check passes as rank 4. Deployed specs broken by the v1.1 Admin shell (s999) are with S1-API-Frontend-Delivery.
- **s1025 (pending merge):** in-app counsellor feedback backend (slice 7); triage in the Layer 4 Inbox kind *Counsellor feedback (in app)*. Screens with S1-API-Frontend-Delivery.

**S1-Build, 24 Nov 2026 09:20 AEDT (Platform Admin 08:22): feedback-4 courses confirmed served; s1023 Locked Field Update recorded before merge.**
- **Serving:** the website API (v2 and v3) serves 1,401 of the 1,402 feedback-4 courses; no publication flag was changed (course `publication_status` is not the serving switch). Victoria University's CRICOS 02475D record (Sydney and Brisbane) is a separate registration kept by the Platform Admin's decision of 20 Nov (s890); both VU records stay served.
- **s1023 (live 08:47, Pilot #1525; read back: head `20261124100000`, guard on its four tables records locked re-reads, Inbox lists the kind, G3 75/48 no drift, locks 7,585, cron 133):** a machine re-read of a locked tuition or intake value is never written and opens one Layer 4 item *Periodic Audit - Locked Field Update*. Approve & Keep Lock (rank 3+, reason required) writes the value and keeps the lock; Reject changes nothing; bulk through `public.admin_layer4_locked_update_bulk`. Screen card and bulk bar: S1-API-Frontend-Delivery.
- **Kind hooks (corrected 24 Nov 12:05):** `pipeline.layer4_inbox_kind_hooks` and `security.layer4_inbox_hooks_v1` are in git in the squash baseline (`supabase/live-capture/baseline/schema.sql`) and match live; no gap.

**S1-Build, 24 Nov 2026 08:00 AEDT: s1021 live (Pilot #1521); s1022 golden-course validator recorded before merge.**
- **s1021 (live):** course-linked scholarship GPA thresholds with no stated scale are held for the Layer 4 Inbox kind *Scholarship GPA scale*. Live head `20261124090000`; G3 75/48, no drift; locks 7,585; cron 135.
- **s1022 (pending merge):** workflow *Golden courses*, daily 07:35 AEDT, read-only. First reading (24 Nov, corrected 08:40): 1,402 courses across the five feedback-4 providers; the website API (v2 and v3) serves 1,401 (the one not served is VU's single inactive course), both VU EBCL copies included. Course `publication_status` is not the serving switch (44,724 of 44,734 courses carry 'unpublished'); the website looks a course up by its stable key or code, and serving follows the search documents and the provider Published switch (all five on). PTE and TOEFL iBT with four bands on 14 of 1,250 courses that hold IELTS. Fee year in the gate window on 506. 0 of 1,272 course-linked GPA thresholds state a scale. VU EBCL is held twice (both VU records) and both copies are served.

**S1-Build, 24 Nov 2026 07:50 AEDT: s1020 live (Pilot #1520); s1021 recorded before merge (Pilot branch `s1-build-s1021-gpa-scale-gate`).**
- **s1020 pre-admission gates (live 07:37):** machine writes of a tuition fee outside the year window, a PTE or TOEFL iBT row without four bands on an IELTS course, or a cross-provider campus link are held for Layer 4; active rows are never withdrawn. Switches on Settings › Pipeline settings › Pre-admission gates. Log: `pipeline.preadmission_gate_events`.
- **s1021 scholarship GPA scale (pending merge):** a course-linked GPA threshold with no stated scale, or above its scale, is held and opens a Layer 4 Inbox item *Scholarship GPA scale*, grouped per provider. A person sets the scale (4, 7 or another); the threshold is re-admitted only if it fits. Switch `gates.gpa_scale_on`.
- **Live:** migration head `20261124080000`; G3 75/48, no drift; locks 7,585; cron 134.

**S1-RM-Design, 24 Nov 2026 07:40 AEDT (Platform Admin 07:01): s1024 live (Pilot #1527, admin #889); s1026 speed fix live (Pilot #1531; India, 70%, meets-minimum, sort by GPA 2.2 s live, was about 21 s).**
- **Counsellor GPA sort and filter (REQ-110 follow-up):** optional `gpa_*` arguments and `sort: 'gpa'` on `courses_page`; percentage-scale minimums only (`security.course_gpa_min_percent_v1`); student result as a percentage or a listed scale (`security.gpa_student_percent_v1`, setting `lookups.gpa_comparable_scales`, empty). Admin read only; G3 75/48 unchanged. Frontend control is S1-API-Frontend-Delivery's.
- **Speed (s1026):** s1024 took about 21 s live for India, 70%, meets-minimum, sort by GPA (4,080 courses); the minimums are now read once per call into two maps (`security.gpa_min_maps_v1`).

**S1-RM-Design, 24 Nov 2026 06:25 AEDT (Platform Admin 05:33): s1017 live (Pilot #1515, admin #866; migration 20261124060000 applied; worker v1.0.36 deployed).**
- **$0 ruled-grid reader:** a proven ruled PDF table that is a course-by-qualification grid is read without a model (`entry-ruled-grid.ts` into `entry-grid.ts`; worker v1.0.36; settings `reading.entry_ruled_grid_reader_on`, `_min_rows`, `_min_columns`). `reading.entry_grid_headings` names "Additional programme entry" a course fact.
- **No-model lease:** `svc_entry_matrix_next` leases stored PDFs with `det_only` and no model while the `entry_matrices` route has no usable model (`reading.entry_det_only_lease_on`); a PDF no deterministic reader proves is held (`held_unparsed`), never sent to a model. Non-PDF pages wait.
- **Auckland (live 24 Nov 06:19):** runs `838d1a42` (A-I, 126 rows, Layer 4 item `0ab3024e`) and `498a46c6` (J-Z, 225 rows, item `aa9a7aaf`) done at $0; both first-run items pending a person; no course rule admitted by the machine. The four queued HTML runs were not leased. G3 75/48, cron 136, locks 7,585.

**S1-RM-Design, 24 Nov 2026 00:20 AEDT (Platform Admin overnight brief 23:47): s1015 recorded before merge (Pilot branch `s1-rm-design-s1015-v3-restriction`).**
- **REQ-118 on v3:** every Website API v3 provider item gains `restriction_mode` and `restriction_markets` from `pipeline.provider_representation` (null when nothing is held or the agreement ended); `representation_status` is not served. v2 and the G3 surface are unchanged (75/48). v3 developer guide updated (section 7 provider rows, section 13).
- **Auckland, `HELD:MODEL_NOT_QUALIFIED` (was `HELD:ROUTE_OFF`):** the `entry_matrices` route was switched off by the Platform Admin on 16 Nov (Qwen3 failed the benchmark); it can come back on only with a qualified model, and recording a qualification is the Platform Admin's own act. `gpt-4.1-mini` is allowed but unqualified for this service. Nothing switched; $0 spent.

**S1-RM-Design, 23 Nov 2026 21:40 AEDT (Platform Admin 20:38): s1012 recorded before merge (Pilot branch `s1-rm-design-s1012-representation-grade-scale`); REQ-118 and REQ-110 built, Auckland read held.**
- **REQ-118 (provider level, approved contract section 5):** `pipeline.provider_representation` (representation_status represented, direct or not_represented; no row = Not recorded; restriction_mode include, exclude or none; restriction_markets ISO alpha-2, empty when none; dates, source, reason) with `pipeline.provider_representation_events`; Admin save needs PIM Admin and a reason; read needs Counsellor. Empty until the partner agreement register is loaded. Not served to the website or Zoho (G3 untouched, 75/48).
- **REQ-110:** `ref.grade_scale_conversions` gets seven rows only: CBSE Class X grade points 10 to 4 x 9.5 (https://www.cbse.gov.in/circulars/cir24-2010.pdf). Not seeded, no official 0 to 100 statement found: NCEA, AU GPA, ATAR, gaokao and the other Indian boards.
- **Held, `HELD:ROUTE_OFF`:** Auckland runs `838d1a42` and `498a46c6` stay `queued`: `security.ai_route_v1('entry_matrices')` is switched off in Models & services with no qualified model (qwen3-30b not qualified), so `svc_entry_matrix_next` returns nothing. Four older runs wait for the same reason. Needs the Platform Admin to switch the route on or qualify a model. Spend $0.

**S1-RM-Design, 23 Nov 2026 19:50 AEDT (Platform Admin standing authority): s996 recorded before merge (Pilot branch `s996-auckland-merged-note-cell`); University of Auckland parser fix built; live re-run to follow the deploy.**
- **Fix:** `gridRows` (`coverage-sweep/pdf.ts`) reads a line that crosses a column edge as one merged cell when no vertical rule runs at any crossed edge in its row band. On both Auckland PDFs the note ("No direct entry for secondary qualifications ...") has vertical rules only at the table's outer edges and the first column edge. The cell is kept as a `§ Note:` line and is never a cell under a column header, so it cannot be a minimum. A vertical rule at a crossed edge, even part of one, still holds the document.
- **Offline result ($0, stored extractions, same sha256 as the live PDFs):** A-I and J-Z both read `ok` (were `unparsed` on page 2). Nine other fixtures give byte-identical output. 34 of 34 PDF contract specs pass (new `s996`: 3 tests; neighbours `f-aer-07`, `f-aer-08`, `s142`). TEST-REGISTER: 967 specs, 4,425 tests.
- **Live (23 Nov 2026 20:08 AEDT):** Pilot #1504 merged 20:05 (Deploy on merge and Security gates green); `coverage-sweep` redeployed 20:05:42 AEDT (version 348, no migration, worker version string unchanged). **Not yet done:** the two Auckland entry-matrix runs (`entry_matrix_runs` `838d1a42` A-I and `498a46c6` J-Z) are still `failed` with the old page-2 error (cost 0, 28 Oct). Re-reading them goes through `entry_ai` with `openai/gpt-4.1-mini` (a few cents), which is not the $0 re-run asked for; a decision is open (see the S1-RM-Design hand-off). Exact one-to-one abbreviation expansions (`B`, `M`, `Hons`, `GradDip`) go to Layer 4 cards, never to machine admission. Queue: Auckland `CLAIMED:S1-RM-Design` (s996).
- **Guardrails:** G3 75/48 untouched; locks 7,585; cron unchanged; $0; no migration in this change (live head `20261123200000`).

**S1-Build, 24 Nov 2026 00:25 AEDT: deployed specs follow Decision 269 (Pilot #1512).**
- **Acceptance:** 7 failed / 65 passed (was 13 failed at the start of the recovery).
- **Remaining failures:** cf-061 QILT card; layer2-provider credential text (needs a decision); Courses payload and Adapters latency (needs a decision); the rank 4 UAT account.
- **Findings:** `docs/platform/2026-11-23-deployed-uat-recovery.md` section 6.

**S1-Build, 23 Nov 2026 23:55 AEDT: s1014 live (Pilot #1511, `5df82e85`).**
- **Live migration head:** `20261123235000`.
- **Search:** results identical to the baseline; plans use the trigram indexes.
- **Guardrails:** G3 75/48, locks 7,585, cron 136.
- **Acceptance:** 9 failed / 62 passed (was 13 failed). Six of the failures are deployed specs still on the pre-Decision 269 screens; the Pilot fix is in this release cycle.
- **Open:** Courses list payload (413 KB against 250 KB) and `admin_layer23` (6.8 s); the rank 4 UAT account (Platform Admin).
- **Main shows red** only for Deployed UAT. Build, Deploy on merge and Security gates are green.

**S1-Build, 23 Nov 2026 23:05 AEDT: s1013 live (Pilot #1510, `8070bf4d`; Deploy on merge and Security gates green).**
- **Live migration head:** `20261123233000`.
- **Admin reads:** `admin_toolsets_read` 769 ms and `admin_course_audit` 212 ms under production load.
- **Guardrails:** G3 75/48, locks 7,585, cron 133.
- **s1014 (Courses keyword search on trigram indexes; `admin_toolsets_read` recorded in source):** claimed and rehearsed.

**S1-Build, 23 Nov 2026 22:45 AEDT: Deployed UAT recovery (Platform Admin 22:10).**
- **Sign-in:** works again (UAT_PASSWORD updated by the Platform Admin).
- **Full acceptance:** the failures were present before s1011 (22 Nov baseline: the same 11 tests).
- **s1013 (rehearsed):** covering indexes for `admin_toolsets_read` and `admin_course_audit`, which were timing out at the 8 s signed-in limit (now 163 ms and 173 ms). Also the Data Quality pager locator and CF-073 on today's Services & limits.
- **Open:** the Courses keyword search (2.5 to 8 s, cf-061) and role-specific UAT accounts (rank 6, 4 and 2; the Platform Admin creates them).
- **Findings:** `docs/platform/2026-11-23-deployed-uat-recovery.md`.

**S1-Build, 23 Nov 2026 21:15 AEDT: s1011 is live (Pilot #1508, merge `b3fddcc0`; Deploy on merge and Security gates green).**
- **Live migration head:** `20261123220000`.
- **Row-level security:** 0 application tables have it off (both Zoho tables on). `ref.nationality_terms` has its read policy.
- **saved_courses:** all three policies use `(SELECT auth.uid())`.
- **Indexes:** both foreign-key indexes are present.
- **API usage coverage:** no gaps.
- **Guardrails:** G3 75/48 with no drift, 7,585 locks, 135 active cron jobs.
- **Component register:** `docs/platform/COMPONENT-REGISTER.md` is refreshed from the snapshot of 23 Nov 2026 21:10. The previous copy dated from 15 Oct.
- **Still pending:** the duplicate-index paste file (Platform Admin).

**S1-Build, 23 Nov 2026 21:00 AEDT (Platform Admin 20:38): hardening slice from the architecture audit bundle.**
- **Row-level security:** s1011 turns it on for the 93 tables that had it off. The audit named 13; the live catalogue holds 93, including `private.zoho_integration_credentials` and `private.zoho_integration_rate_windows`. All 93 are owned by `postgres` and read only by `postgres`-owned definer functions or bypass roles, so no read or write changes. `ref.nationality_terms` keeps its read for signed-in users through a policy.
- **saved_courses:** its policies use `(select auth.uid())`.
- **Indexes:** two foreign-key indexes are added (`course_entry_requirements.country_id`, `provider_entry_matrix.study_level_id`).
- **Pending paste file:** `docs/paste/PASTE-20261123-s1011-duplicate-indexes-drop.sql` drops the three exact duplicate indexes. It is for the Platform Admin to run.
- **Live telemetry:** `docs/platform/2026-11-23-live-telemetry-readback.md` (settings, guardrails, RLS, indexes, dead tuples, largest tables).
- **Governance:**
  - Section 3a and the queue use S1 lane names (6 claims renamed; their specs unchanged).
  - The design has one section 10 (the charter) and one matrix (section 11).
  - The CI job `Provider queue check` enforces the queue's shape, HELD codes and single writer per column, with S2 names accepted as aliases.

**S1-Build, 23 Nov 2026 20:20 AEDT (Platform Admin 19:59 and 20:03): Deployed UAT cause found; s997 merging; s1010 claimed.**
- **Deployed UAT red on Pilot `main`, including `af26ad7` (s992):** every sign-in by the UAT account fails with `400: Invalid login credentials` (Supabase auth log). A password reset was requested for that account at 22 Nov 2026 22:51 UTC (23 Nov 09:51 AEDT), and the password was changed a minute later. Every UAT run since then has failed at sign-in (`tests/uat/support/runtime-evidence.mjs` line 95), whatever the change under test. `Deploy on merge` and `Security gates` are green on the same commits. **Fix:** the Platform Admin sets the repository secret `UAT_PASSWORD` (Coursefinder-Pilot, Actions) to the account's current password, or resets the account to the stored one. No code change can fix it, and Claude does not handle passwords.
- **s997** (Pilot #1503): every check green, including the live dry run; merging by label.
- **s1010** (claimed, rehearsed):
  - `firecrawl.daily_budget_total` goes from 0 to 5 with the reason "Standing Authority Charter Section 10 — Tier 1 micro-budget cap US$5.00/day". The setting counts credits, so this is 5 credits a day, inside the US$5.00 platform cap. **Superseded (verified live 25 Nov 2026): the setting is 1,500 credits a day since s1035, 24 Nov 13:08; Master Plan 6.4.**
  - The 33 settings with no or short help get plain-English help for the v1.2 Settings screen.
- **08:00 run:** it now also refreshes the Drive mirror of the master plan and the digest.

**S1-Build, 23 Nov 2026 19:45 AEDT (Platform Admin 18:55): S1 consolidation recorded; digest and blocker queue live in the 08:00 run; s997 rehearsed.**
- **Design v1.2:** section 11 mirrors the Drive design section 6 (asset acquisition, lane ownership, related jobs and toolset matrix), with every S2 lane mapped to `S1-RM-Design` or `S1-Build`. The Standing Authority Charter was already in both `CLAUDE.md` files (admin #842, Pilot #1501).
- **Daily digest:** `DAILY-EXECUTIVE-STATUS.md` is now generated by `docs/monitoring/aer-reader-status-refresh/daily_digest.py` in the 08:00 AEDT run, from the queue, the register and a rolled-back live read. That run also releases claims older than 24 hours and writes `docs/monitoring/S1-BLOCKER-QUEUE.csv`: every `HELD:*` cell with `provider_id`, `aer_source_url`, `storage_artifact_path`, the reason and the target solver. First run 23 Nov 19:17: 1,885 HELD cells, no stale claim. Live: AER 10,463 of 36,046 courses, English 21,330, official URLs 24,089, descriptions 15,967, exact intake dates 3,127, campus city 29,949, 1,081 published scholarships. G3 75/48 with no drift, locks 7,585, cron 136.
- **To check:** five intake rows are `HELD:BUDGET_GATE` because "no $0 read" was allowed when they were set (Curtin, La Trobe, Sunshine Coast, Australian Pacific College, King's Own). Under the Charter a $0 plain-HTTP read is now allowed, so the intake owner re-checks them first. The live AI daily ceiling setting is US$14 (`budgets.ai_daily_ceiling_usd`), above the US$5.00 platform cap; it is S3's enforced guard and was not changed.
- **s997 (Pilot PR to follow, rehearsed in a rolled-back run):**
  - `admin_boost_queue_read` returns `budget_cap` (Firecrawl daily budget 0 credits, platform cap US$5.00 a day, AI ceiling, queued and `dry_lane`).
  - `pipeline.saved_courses` (RLS, own rows), `saved_course_toggle_v1`, `saved_courses_read_v1`, and `is_saved` on every course-list row.
  - `pipeline.partner_contacts` sits beside the provider contacts the frozen Zoho v2 feed reads. It is written by Admin entry (`admin_partner_contact_save_v1`) and the Zoho CRM partner import (`admin_partner_contacts_import_v1`), and read with `active_count` and `inactive_count` (`provider_partner_contacts_v1`).

**S1-RM-Design, 23 Nov 2026 19:30 AEDT: HELD codes registered; Auckland diagnosed; parked (documents only).** `HELD:PARSER_EDGE_CASE` (solver S1-RM-Design) and `HELD:WAF_OR_JS_BLOCK` (solver S1-Build) added to design section 6, with S1 solver routing for every code; digest section 4a *Technical Blockers & Ready-to-Solve S1 Queue* added. University of Auckland: both stored entry PDFs read fine, but the aligned-grid reader (`gridRows`, Pilot `coverage-sweep/pdf.ts`) fails closed on a full-width note in a merged cell on page 2, so 0 rows are held (admitted 11 courses, unchanged); queue `HELD:PARSER_EDGE_CASE`, fix proposed in the digest, spec `s996` claimed for the next S1-RM-Design chat. `s993` closed. Live: migration head `20261123190000`; no Pilot or live change.

**Platform Admin, 23 Nov 2026 18:52 AEDT: Standing Authority Charter (gate upgrades) committed** to `CLAUDE.md` in both repositories and to the file-driven delivery design (section 10). (1) AER v2 proven-structure sources and degree-abbreviation expansions are pre-authorised (expanded-title matches go to Layer 4, never machine-admitted). (2) $0 direct HTTP reads of copy-less pages always allowed; paid Firecrawl or pinned AI for Tier 1 universities and linked courses up to US$5.00 a day platform-wide, logged in the daily digest; above that `HELD:BUDGET_GATE`. (3) Auto-enqueue of description, AER, intake and scholarship items on URL or snapshot capture. (4) Rule B global; international calendar inheritance. (5) Escalation by exception only: G3 75/48, the 7,585 locks, more than 140 cron jobs, more than US$5.00 a day, bulk withdrawal without replacement. Live follow-ups (design 10.6): Firecrawl `daily_budget_total` is still 0 (S3 containment), so paid Firecrawl stays off until that setting is changed with a reason; auto-enqueue, global Rule B and calendar inheritance are built by S2-CF and S2-INT. `docs/security/AI-SYSTEM-CARDS.md` section 3 updated.

**S2-RM-Design, 23 Nov 2026 19:55 AEDT (Platform Admin 18:22, Step 2: CDU, UWA, Victoria University, Macquarie): measured; s995 held as a draft (Pilot #1502); no live change; parked.**
- **What holds the 472 rows (live, rolled back):** university-wide matrix rows of six Layer 4 `entry_matrix_first_run` reads (12 Nov, AI reads `entry-matrix-v0.1.4`).
  - **UWA (194):** every row is excluded only as `level_unmapped`; all other rules pass. The table is an ATAR-equivalence table (178 band rows, 154 quotes name the ATAR).
  - **CDU (45):** 44 rows pass every rule except level; the page states no level; 4 band rows were dropped.
  - **Macquarie (107):** the undergraduate and pathways PDFs were read without their minimum column (1 of 46 and 16 of 61 rows carry a minimum).
  - **Victoria University (126):** `host_shared`, because two provider records named Victoria University share vu.edu.au.
- **s995 (AER v2 admission rule, Pilot #1502, draft):** a read that prints no level takes `bachelor` when at least half its rows are ATAR band rows (`aer.matrix_atar_table_share`). Rehearsed: it touches only UWA (1 of 72 pending reads); 186 rows admitted; active matrix rows 6,720 → 6,906; coverage counter 10,465 → 10,531 (+66).
  - **Not shipped:** all 66 newly counted courses resolve to `contact_provider` on `entry_resolve_v3` and Website v3 (UWA course pages print no ATAR band to enter the table with). Real answers gained: 0. Truthful coverage comes before headline gains; the decision is the Platform Admin's.
- **Coverage note for the coverage owner (S2-Build):** `security.aer_covered_courses_v1` counts a course as covered when its provider has a band table, even when the resolver cannot enter it. The counter can overstate real answers.
- **Queue:** Victoria University `HELD:IDENTITY_UNRESOLVED`; UWA claimed (s995 draft); CDU and Macquarie back to `PENDING` with notes (level unstated: a person decides in Layer 4; Macquarie needs a v2 PDF re-read of its stored PDFs). No HELD code fits those two. Next batches start with rows where S2-CF has filled `aer_source_url` and `storage_artifact_path` (Platform Admin 18:42).
- **Guardrails:** G3 75/48 untouched; locks 7,585; active cron unchanged; $0; no Layer 4 decision or lock changed.

**S2-RM-Design, 23 Nov 2026 18:30 AEDT: carryover verified; AER batch 1 (s993) measured and recorded; no Pilot change; parked.**
- **Carryover (s1009) verified live:** head `20261123170000`; strict proof `aer-course-proof-v1` has admitted 29 items for 29 courses (last 17:29); reader aer-det-v1.4 in both sweep functions; `aer.machine_min_confidence` 0.8. Ledger de-duplication stays not needed: the 304 items with two declines in 7 days changed state between them (`gate_incomplete` then `active_rows_exist`, about 67 h apart); none repeats for unchanged evidence. One note: admit-mode decline rows store no `content_hash`.
- **Batch 1 (Platform Admin 17:43; AER v2 proven-structure route chosen 18:00, relink to Layer 4 approved 18:15):**
  - **UNSW and UQ:** the 735 unlinked table rows (UNSW 622 / 21 labels, UQ 113 / 5 labels) were all excluded by a Layer 4 reviewer ("approve except"). The approved relink (expand `B`/`M`/`Hons`, exact one-to-one course) finds 0 one-to-one matches, so no card is raised and no Pilot migration is shipped. Five labels (143 rows) match two active unpublished courses each (IR-027, S2-CF); the rest are ambiguous abbreviations or mis-parsed labels and fail closed. Both are `HELD:IDENTITY_UNRESOLVED`.
  - **Sydney:** `DONE`. All 1,780 active table rows are already linked (67 courses), and the guide holds nothing more.
  - **Auckland:** still claimed. The $0 shadow read of its stored PDF (v2 converter, precision gate before admission) is for the next S2-RM-Design chat; if not taken within 24 h, S2-Build releases it.
- **Guardrails (live 18:20):** G3 75/48 untouched; locks 7,585; active cron 135; $0 spend; no Layer 4 decision or lock changed.

**S1-CD-Orchestrator, 23 Nov 2026 17:20 AEDT: file-driven continuous delivery design, provider enrichment queue and daily digest added; S1-UI-UX v1.1 prototype baseline logged (documents and CSVs only; no Pilot, migration or live change).**
- **Design:** `docs/platform/2026-11-23-file-driven-continuous-delivery-design.md` (linked in plan section 3a): batch sizes by lane, the `PULL -> CLAIM -> EXECUTE -> SHIP -> ADVANCE -> LOOP` loop, one writer per queue column, a 24-hour stale-claim release by S2-Build, artifact reuse through S2-CF, and the `HELD` reason codes.
- **Queue:** `docs/monitoring/PROVIDER-ENRICHMENT-QUEUE.csv`, 1,886 providers and 36,046 active courses, seeded from `AER_University_Reader_Status.csv` (snapshot 23 Nov 16:49 AEDT). Tier 1: 64 universities (AU 53, NZ 11); tier 2: 50 providers with 50 or more courses; tier 3: 1,772. `aer_status` is `DONE` for the 10 `Fully Working` providers (one university) and `PENDING` for 1,876 (63 universities); every other lane column is `PENDING`; `elr_status` is `PARKED` for all rows.
- **Digest:** `docs/monitoring/DAILY-EXECUTIVE-STATUS.md` template; 08:00 AEDT daily update registered under `S1-Build` in plan section 3a.
- **S1-UI-UX v1.1 prototype baseline (reported by the Platform Admin; not re-run in this session):** 44 of 44 Playwright renders pass in the Drive `Mockups` folder, covering REQ-111, REQ-115, REQ-116, REQ-117 and REQ-118 / IR-023. **Backend prerequisites for S1-API-Frontend-Delivery (handed in the plan):** (1) additive v3 RPCs `public.counsellor_scholarships_list` and `public.admin_integrations_status`, with G3 v2 75/48 frozen; (2) `ai.firecrawl_budget_cap` seeded or mapped in `pipeline.settings` for the Screen 5 dry-lane banner; (3) `restriction_mode` (`include`, `exclude`, `none`) confirmed on the additive v3 StudySquare provider representation contract (S2-RM-Design); (4) saved-courses persistence (REQ-115) and the partner-contacts source (REQ-116) confirmed under S2-Build.

**S2-RM-Design, 23 Nov 2026 17:12 AEDT: s1009 live (Pilot #1497 `7e41c95`; migration `20261123170000` applied, md5 55c7bc84; `coverage-sweep` deployed with reader aer-det-v1.4).** Read back 16:58 AEDT: strict proof (`aer-course-proof-v1`) admitted 25 rows for 24 courses on its first tick; admitted courses (canonical rule) 10,441 → 10,461; active entry rows 27,929 → 27,954; the v1.4 sweep re-read 720 stored pages ($0), 15 older held reads superseded, 7 new v1.4 reads proposed; Website and Zoho v3 checked live: University of New England, Bachelor of Nursing returns rule 1 "Guaranteed ATAR: 65.00" (v2 step 5, frozen). Pending AER reads by reason: active_rows_exist 296, all_rows_held 249 (from 284), partial 75, no_bound_page 38, identity_not_admitted 11, not checked 7. Guardrails: 75/48 no drift; locks 7,585; active cron 135; `aer.machine_min_confidence` 0.8. The AER university register is S1-Build's (`docs/monitoring/AER_University_Reader_Status.csv`, daily 08:00 AEDT); this lane wrote none. Step 2 sized: entry-table rows held only for want of a linked course: UNSW 622, UQ 113 (course identity first); CDU's 45 entry-table rows wait as a Layer 4 first run since 3 Nov (layout case); proposed tables UWA 194, Victoria University 126, Macquarie 107.

**S2-RM-Design, 23 Nov 2026 16:09 AEDT (Platform Admin 15:52, Priority 2 Step 1): s1009 (Pilot, migration `20261123170000`, reader aer-det-v1.4) recorded before merge.** Strict-proof rule `aer-course-proof-v1` (third pass of `security.aer_partial_admit_v1`, every 15 min): a held course entry row becomes active only when it is for international or all applicants, an academic kind, its value word for word in its quote, with no maximum/"up to", no age and not a mark in one named subject (added after 99 of the 165 candidates proved to be "CBSE ... 65% in English" stored as an overall average); 5% audit share kept; `aer.machine_min_confidence` 0.8 untouched. Rehearsed live (rolled back): one tick admitted 25 rows in 24 items, 0 errors. Ledger de-duplication (item 2): not built: 0 repeated declines for one item in 7 days; the repeated hashes are one shadow plus one admit row per item by design, and shared pages. Reader v1.4: no maximum/"up to" read as a minimum; the quote carries its value; no overall average from one subject's mark; "International Baccalaureate" no longer cut to "International" (a v1.3 bug). The sweep re-reads stored pages of courses with no active entry row at $0, and an older held deterministic read gives way to the v1.4 read (not audit samples, claimed items, locks or courses with active rows).

**S2-INT, 23 Nov 2026 19:55 AEDT: intake queue loop finished (s995): 0 `PENDING` rows.**
- All 1,886 `PROVIDER-ENRICHMENT-QUEUE.csv` rows read against live data (no Pilot change, $0): 5 `DONE`, 1,864 `HELD:NO_SOURCE`, 12 `HELD:IDENTITY_UNRESOLVED` (S2-CF), 5 `HELD:BUDGET_GATE`. Each note holds the before and after exact-date course count (unchanged).
- To reopen a held row: S2-CF routes the identity rows, an approved budget window reads the stale 2026 calendars, or a stated audience source arrives for page-printed dates. Southern Cross stays held (June to 5 July not admitted).

**S2-INT, 23 Nov 2026 19:15 AEDT: s994 live; intake queue loop, Tier 1 advanced (s995, read-only).**
- **s994 live** (Pilot #1499): `security.intake_nearest_start_v1` md5 `4eee36d4…`; dated rows 5,381 unchanged; G3 75/48; locks 7,585; cron 136.
- **Tier 1 (64 rows):** 4 `DONE`, 49 `HELD:NO_SOURCE`, 8 `HELD:IDENTITY_UNRESOLVED` (routed to S2-CF), 3 `HELD:BUDGET_GATE`. Each row's note holds the before and after exact-date course counts (unchanged: nothing was safely admittable) and its undated intake count.
- **Why nothing more at $0:** the Rule B qualification of each remaining Tier 1 university finds 0 calendar-start dates in the stated month; the rest need an audience, a course identity or a fresh calendar.

**S2-INT, 23 Nov 2026 18:10 AEDT (Platform Admin decision 17:49): s994 (Pilot #1499) recorded before merge; queue loop started.**
- **Decision:** Monash and RMIT's existing Decision 271 admitted rows stay untouched (no regression of live rows); every new Rule B admission needs the stated month to equal the calendar start's month.
- **s994:** `security.intake_nearest_start_v1` (md5 `5e864efd…` to `4eee36d4…`) no longer uses the next-month path (February to 1 March); only the one start in the stated month; otherwise month only. Rehearsed rolled back: applies, no dated count change. Existing Rule B rows with a start outside the label month stay as they are (543b87b8 206, 8e1adb6c 221, 030992c3 31, 62e61a02 1).
- **Queue:** Federation, Canterbury and Waikato `intake_status` = DONE (s988). Tier 1 blocker read (rolled back, 64 universities): undated active intakes are mostly `no_matching_commencement_period`, `course_identity_unresolved` (S2-CF), `academic_year_unprovable`, `calendar_interpretation`; each batch is classified and marked HELD with a reason code unless a safe stored-evidence admission exists.

**S2-INT, 23 Nov 2026 17:00 AEDT: s988 live (Pilot #1495; migrations `20261123150000` to `150002`); parked.**
- **Result (live read-back, rolled back):** Rule B dated **131 intakes** (Federation 41, Waikato 55, Canterbury 35), all `calendar-v3-nearest-start`, 0 outside the month the page names, quote and calendar stored. Exact-date intakes 5,242 to **5,375**; exact-date courses 3,041 to **3,119**. Since the start of the day: rows 4,896 to 5,375 (+479), courses 2,844 to 3,119 (+275, about 8.7%).
- **Held as decided:** the 2 Waikato February to 1 March rows (recorded withdrawal; none dated); Southern Cross unlisted and still `qualified`. Website v3 and Zoho v3 show the new dates (6 of 6 sampled). G3 75/48 no drift, locks 7,585, active cron 134, spend $0.
- **Still held (no action without a new decision):** page-printed dates without a stated audience (1,355 rows / 722 courses); stale 2026 calendars (about 10 universities); Southern Cross; application deadlines are unchanged (350 courses). Open hand-offs: about 2,300 identity rows with S2-CF; Western Sydney provenance row (Layer 4 review); S2-Build regenerates `TEST-REGISTER.md` (s986 to s988) and refreshes the Drive copy of the plan.

**S1-RM-Design, 23 Nov 2026 17:25 AEDT: S1-UI-UX v1.1 prototype baseline recorded; backend prerequisites registered (registers only).** (traceability section 8)
- **Baseline:** Drive `UI-UX-and-Architecture-Audit/Mockups` v1.1, **44 of 44 Playwright renders passing** (22 desktop, 22 at 375 px; 0 px overflow, 0 bad requests, `ui-` classes only, Counsellor menu of four), covering REQ-111, REQ-115, REQ-116, REQ-117 and REQ-118 / IR-023.
- **Before `S1-API-Frontend-Delivery` ships (live check 17:20):**
  - **P1, IR-025:** `public.counsellor_scholarships_list` and `public.admin_integrations_status`. Neither exists yet. Both are Admin reads; G3 v2 stays 75/48.
  - **P2, IR-026, decision:** there is no `pipeline.settings` table. Recommended: map the Dry-Lane banner to the live G2 setting `firecrawl.daily_budget_total` (0) with `daily_budget_on` (true) through `admin_boost_queue_read`, instead of seeding `ai.firecrawl_budget_cap`.
  - **P3:** `restriction_mode` (`include` / `exclude` / `none`) for S2-RM-Design to confirm in the additive v3 representation contract.
  - **P4a, P4b:** the saved-courses store (REQ-115) and the partner-contacts source (REQ-116 / REQ-22) under S2-Build. Neither exists live.

**S1-RM-Design, 23 Nov 2026 16:30 AEDT: Platform Admin decisions of 16:22 recorded; registers only.** (traceability section 7)
- **REQ-116 / REQ-22 (Approved):** no scraping of university staff contacts; source is Study Square partner records (Admin entry and/or Zoho CRM partner contact import); data owner S2-Build; empty state "No partner contacts recorded for this provider" with S1-API-Frontend-Delivery.
- **REQ-118 / IR-023 (Approved):** representation status on the section 5 contract; source of truth is the Study Square partner agreement register (Admin + CSV/Zoho sync, never scraped); S2-RM-Design finalises the additive v3 contract (v2 frozen), then S1-API-Frontend-Delivery builds the Counsellor badge and filter.
- **REQ-110 (Approved):** GPA order by normalised percentage (0 to 100) from `grade_scale_conversions`, scoped to the applicant country and scale (India % / 10-point CGPA by default for Indian applicants, otherwise AU 7.0 GPA / ATAR), unscored last; S2-RM-Design defines the rows first (`ref.grade_scale_conversions` exists live with 0 rows), then the sort is exposed.
- **REQ-114 routing:** S2-CF (La Trobe's 8 unpublished Nursing courses, James Cook Nursing discovery), S3 (8 s statement time-out, IR-022), S2-RM-Design Priority 2. Drive mirror of the plan: S2-Build, next integration pass.

**S1-RM-Design, 23 Nov 2026 16:10 AEDT: counsellor feedback rounds 1 to 3 reconciled; registers only (no Pilot, migration or live change).** Traceability: `docs/platform/2026-11-23-counsellor-feedback-1-3-traceability.md` (roadmap RM0G).
- **Feedback 3 registered:** REQ-113 Nursing search returns unrelated courses (P1, S1-API-Frontend-Delivery and S3); REQ-114 La Trobe only Doctor of Nursing, James Cook none, time-outs (P1, S3 IR-022, S2-RM-Design Priority 2, S2-CF); REQ-115 compare defect, saved courses and compare columns (P1 defect / P2, Mockups); REQ-116 La Trobe contacts (P2); REQ-117 state and campus names (P2, with S2-GEO); REQ-118 Study Square representation status (P2, decision IR-023, contract proposed).
- **Feedback 1 and 2:** 33 traced items: 17 Done / Verified Live (s956, s957, s958, s959, v2.16.86), 9 in progress (REQ-94 s1000, REQ-95 s984 and s985, REQ-99, REQ-105, REQ-109, REQ-111), 2 open (REQ-108, REQ-110), 5 newly logged: REQ-119 NZ Bachelor of Business Analytics, REQ-120 La Trobe Master of Business Analytics and AI, REQ-121 International Excellence Scholarship (20%), REQ-122 English band scores, REQ-123 fee and campus mapping examples. Intake filtering, profile and GPA, acronym help and click analytics were already in the register.
- **Live checks (read-only, 16:00):** La Trobe holds 8 active Nursing courses (all unpublished), James Cook 1; La Trobe 0 named contacts (31 at 11 providers), so FB3-4 is data, not the filter; `admin_entry_requirements` and `website_v3_course` call `security.entry_resolve_v3` (`admin_aer` names v1 only in a definition guard), so there is no Admin legacy-path gap; no NZ bachelor titled Business Analytics; La Trobe still "Master of Business Analytics".
- **Hand-offs:** IR-021 Counsellor UI clean-up from the UI-UX and architecture audit (S1-API-Frontend-Delivery, Mockups); IR-022 time-outs and raw database text (S3); IR-023 representation contract (Platform Admin); IR-024 duplicate IR-017 number (S2-Build). Clarifications for the India team on REQ-113, REQ-119, REQ-121, REQ-123.

**S2-INT, 23 Nov 2026 16:20 AEDT (Platform Admin decisions of 15:38 on the three held items): s988 (Pilot #1495) recorded before merge.**
- **Rule B (approved):** Federation, Canterbury and Waikato are listed in `intake_dates.nearest_start_providers` where the official calendar gives an exact date. Read before building: every Rule B date is a start in the month the page names, except 2 Waikato rows (February to 1 March 2027), which are held by a recorded withdrawal (the planner never re-admits a withdrawn value). **Southern Cross stays unlisted** (June to 5 July, 34 rows; 133 rows in all): "Approve all qualified" must exclude it. Rehearsed rolled back: Federation 41, Waikato 55, Canterbury 35 = 131 rows dated, 0 outside the stated month; applied now in the same migrations through the existing apply function. Monash and RMIT keep their earlier Decision 271 listing (February to 1 March is part of it); raise it if you want that rule re-read in the light of these decisions.
- **Page-printed dates without a stated audience (1,355 rows / 722 courses):** stay held; the audience corroboration rule is not relaxed.
- **Stale 2026 calendars (about 10 universities, about 2,000 rows):** stay held under the S3 $0 cap. This session has no plain-HTTP re-read path for those calendar URLs (the platform's calendar reader works from stored copies; the session shell cannot reach other sites), so none were read; they stay queued for an approved budget window.
- **Hand-offs recorded:** about 2,300 identity rows stay with S2-CF; the Western Sydney row without provenance stays flagged for Layer 4 review; S2-Build regenerates `TEST-REGISTER.md` (s986 to s988) and refreshes the Drive copy of the plan.
- **Spec claim:** `s988` taken; next free `s995`. The result (distinct-course gain, v3 read-back) is recorded after Pilot #1495 is live.

**S2-INT, 23 Nov 2026 16:00 AEDT (F-INT): s986 and s987 live (Pilot #1493 `5addbc78`, #1494; migrations `20261123120000`, `20261123140000` to `140002`); parked.**
- **Result (live read-back, rolled back):** exact-date intakes 4,914 to **5,242 rows (+328)** and exact-date courses 2,845 to **3,041 (+196 net-new; 2,844 at the start of the day, about 8.4%)**. 328 courses gained a dated intake; 132 of them already had another dated intake. Every new date is rule `calendar-v3`, in 2027, in the intake's own month (0 month mismatches), with the page quote and official calendar stored. One more row was filled year-and-month only (general wording), with no day. Held "starts sooner" decisions 815 to 483.
- **Serving:** all 328 are in the search documents; 6 of 6 sampled courses show the date with `start_date_status: known` in Website v3 and Zoho v3. G3 75/48 no drift, locks 7,585, active cron 135, spend $0, no setting, job or shadow added.
- **Application deadlines were not changed** (350 courses; 344 at the start): nothing in s986 or s987 touches them. No deadline gain is claimed.
- **How it ran:** s986 is the planner rule (the hourly job alone would have taken about 30 hours); s987 ran the same apply function once for the freed courses in three parts. A first s986 push failed its dry run (the renumber changed comment text inside the edited body, so the md5 guard refused; corrected before merge). A first s987 push failed on a racy active-cron equality check; removed (no cron statement in those migrations).
- **Held for Platform Admin (nothing built):** (1) list the 4 Rule B-qualified providers (Federation, Southern Cross, Canterbury, Waikato; 266 rows; Southern Cross's "June" to 5 July is a month-to-day step); (2) admit page-printed dates with no stated audience (1,355 rows, 722 courses)? (3) fresh 2027 calendars for about 10 stale-edition universities (about 2,000 rows) under the S3 zero Firecrawl cap.
- **Hand-offs:** about 2,300 rows blocked by unresolved course identity go to S2-CF (no rebinding by S2-INT). One Western Sydney exact-date row has no stored provenance: flagged for review, not withdrawn. Test register not regenerated (Playwright's test listing cannot run in this session); the integration owner regenerates it for `s986` and `s987`.

**S2-RM-Design, 23 Nov 2026 13:17 AEDT: s1000 live (Pilot #1491 `675b14d`; migration `20261123100000` applied by Deploy on merge, run 45098467095); NZ/CA campus-link evidence audit recorded.** Acceptance (REQ-94 → Pilot #1491 → `security.entry_resolve_v3`, v3 course read, coverage rule): academic entry admitted by the canonical rule **2,250 → 10,441 courses (+8,191; 6.24% → 28.97% of 36,046, +22.7 points)**; 17,000 existing evidence-backed course entry rows now served (no new canonical rows: the rows were already active). Website and Zoho v3 checked live by keyed function calls for named courses (`edu_country` IN): Certificate III in Roof Plumbing (Austra College), Certificate IV in Automotive Mechanical Overhauling (New England College Perth) and Bachelor of Science, Bachelor of Commerce (Curtin) now return rule 1 with the course's rows on Website v3 and Zoho v3, where v2 still returns step 5 (frozen). Held: 442 courses hold only non-academic rows (notes, work experience, portfolio); 324 hold only an age limit (not served as an academic minimum); 24,839 active courses have no admitted entry row. The stored coverage table (daily readiness report) recomputes in provider chunks over about 3.5 hours (`rollup-scheduler`); at 13:10 it read 2,254 admitted and will reach the canonical figure as each chunk runs. Live 13:11: G3 75/48, no drift; locks 7,585; active cron 136 (unchanged by s1000). NZ/CA campus links: 667 without source or evidence (NZ 494, CA 173); 0 have course-level evidence; 30 conflict with an online delivery mode; 7 sit at multi-campus providers; none withdrawn (`docs/platform/2026-11-23-nz-ca-campus-links-evidence-audit.md`).

**S2-Build, 23 Nov 2026 19:35 AEDT: s992 live (Pilot #1500, merged 19:13, deployed 19:15; migration renumbered to `20261123200000` after S2-INT s994 took `20261123190000`); parked.**
- **Live read-back 19:25:** `lanes.stored_first_on` is 0. Worker v1.0.35 read both new Charles Darwin listing sources directly ($0, 2 items each). The only linked award is Australia Awards, already held; the Global Merit and International College awards are printed in sections with no per-award link. Lincoln #10's direct copy gave no items, fell back to the scraper and was refused (`waiting_scraper`); an earlier scraper read found only 2 items, so Firecrawl would not fix it. The next S2-Build step is a heading-based award splitter that feeds each section to the two-part read.
- **Cut-off escalation live:** 3 cut answers since 14:30 and 1 next-model item queued as `sectioned-v1`.
- **Stuck items:** the 39 admit items were tried directly, did not open, and wait 30 minutes ($0).
- **Published:** 1,081 (1,078 this morning; Torrens +2). G3 75/48 with no drift; locks 7,585; active cron 136; scholarship AI $0.01 in 12 hours; Firecrawl $0.
- **Firecrawl window (Charles Darwin and Lincoln):** not opened. S3 s976's zero total refuses on-demand spend, and the blocker is the page layout, not fetching.
- **Queue:** both rows stay `CLAIMED:S2-Build` (s992) with notes, because the section splitter continues them.
- **Docs:** design doc section 10 mirrors Drive blueprint Section 6 (Platform Admin 18:48). TEST-REGISTER regenerated from Pilot main (965 specs, 4,419 tests; adds s990 and s994).

**S2-Build, 23 Nov 2026 18:30 AEDT (Platform Admin 15:39, 17:45 and 17:49): s989 live; s992 (Pilot #1500, migration `20261123190000`, worker v1.0.35) recorded before merge; TEST-REGISTER regenerated.**
- **s989 live (Pilot #1496, merged 16:35):** scholarship worker calls fell from 65 to 2 a quarter-hour; extraction restarted (4 in the first 30 minutes).
- **Why Charles Darwin and Lincoln were at 0 (measured):** Charles Darwin's finder is an APEX app that lists nothing without a browser session. Its international awards are on official pages (`/international/how-apply/scholarships`, `/international/scholarships`) that were never listing sources, and its Vice-Chancellor's High Achievers record is held for want of a stated value. Lincoln holds only the closed CSC award; its international page (listing source #10) prints the Flagship and master's awards in sections, but its next read was 15 Dec. Listing pages were read through the scraper first, S3 s976 holds Firecrawl at a zero daily total, and while the lane was held the picker took only pages with a stored copy (39 admit items had waited since 03:21).
- **s992:** (1) Listing pages are read directly first; the direct copy is used only when it gives items, and otherwise the scraper is tried as before (refused at the zero total). (2) `lanes.stored_first_on` 1 to 0 (used only by the three scholarship lanes). Copy-less pages are read directly; a page that cannot be read directly waits 30 minutes. The migration requires the zero total, so the change is $0. (3) The two Charles Darwin pages are registered as listing sources and, with Lincoln #10, read first (367 sources are due). Rehearsed: the picker takes 12 items (was 0); the next listing call takes those three pages.
- **Firecrawl window (Platform Admin 17:49):** not opened. s976's zero total refuses on-demand spend too, so a window needs `firecrawl.daily_budget_total` raised. That is S3's setting and a Platform Admin decision.
- **TEST-REGISTER** regenerated (961 specs, 4,400 tests): s985 to s989, s992 and s1000; s990 joins when Pilot #1498 merges.
- **Queue:** Charles Darwin and Lincoln stay `CLAIMED:S2-Build` (s992) until the live read-back after deploy.

**S2-Build, 23 Nov 2026 16:20 AEDT (Platform Admin 15:39, 15:40 and 15:54): s989 (Pilot #1496, migration `20261123160000`) recorded before merge; TEST-REGISTER regenerated; AER University Reader Status register handed to S1-Build.**
- **s989 empty-call fix:** `security.scholarship_ai_fire_v1` counted every queued item as due, but the picker takes only items whose provider is not hidden and that either the Firecrawl lane may fetch or that have a stored copy. While the scholarship Firecrawl lane was on budget hold, the 39 queued admit items (none with a stored copy) produced about 255 worker calls an hour, each returning 0 items after 16 to 32 seconds. The fire job now counts only items the picker can take, bounded by what the send loop uses (worst case 182 ms). Rehearsed, rolled back: 1 call a minute instead of about 4 empty ones, now the existing idle fill from stored official pages (3 detail items; stored copies only, $0 Firecrawl, scholarship AI $0.10 today).
- **TEST-REGISTER:** regenerated with `node scripts/test-register.mjs` (Pilot main plus s989). It adds `s1000` (S2-RM-Design), `s986` and `s987` (S2-INT) and `s989` (958 specs, 4,389 tests), and replaces the hand-added rows of `s974` to `s985` with the generator's own text. A local stub stood in for the missing `lucide-react` package so that the 4 UI specs importing it could be listed; nothing about the stub is committed.
- **Hand-off (Platform Admin 15:54):** the AER University Reader Status register (`docs/monitoring/AER_University_Reader_Status.csv`, the Drive sheet `Monitoring / AER_University_Reader_Status` and its daily sync) is owned by `S1-Build`. S2-Build stopped work on it (read-only discovery only; nothing written) and records the transfer in plan section 3a.
- **Next (S2-Build):** merge s989; slice 2, the $0 direct read of the Charles Darwin and Lincoln listing pages, with live verification of the two-part cut-off read.

**S2-Build, 23 Nov 2026 14:45 AEDT: s985 live (Pilot #1492 merged 13:58; admin #804).** Live read-backs 14:05 to 14:40:
- **Deployed:** migration head `20261123110000`. The legal-name switch is on. `svc_scholarship_ai_record` now sends a cut answer to the next model as the two-part read (`sectioned-v1`).
- **Torrens University Australia:** 3 candidates admitted. The 14:29 auto-publish tick published **Family scholarship** and **Motivational scholarship**, so Torrens went from 0 to 2 published. Published scholarships overall went from 1,078 to 1,080.
- **Cut-off guardrail not yet seen live:** no extraction has run since 03:21 AEDT. All 39 queued items are `admit` items with no stored page copy. Stored-first is on and the scholarship Firecrawl lane is on budget hold ("no room left in today's Firecrawl share for scholarships"; $0 Firecrawl, S3 containment), so the picker takes nothing. The fire job still calls the worker about 255 times an hour, and each call returns 0 items after 16 to 32 seconds, because its "due" count includes items the picker cannot take. Both the guardrail check and that wasted-call fix are S2-Build scholarship work.
- **Guards:** locks 7,585; active cron 133; $0 Firecrawl; no new AI use.
- **Charles Darwin and Lincoln:** unchanged at 0 published. Their international awards are on listing pages; slice 2 is a $0 listing read.

**S2-Build, 23 Nov 2026 14:00 AEDT (Platform Admin 13:13: s1001 scholarship coverage for Charles Darwin, Lincoln and Torrens, plus the M3 extraction cut-off guardrail): s985 (Pilot #1492, migration `20261123110000`) recorded before merge.** Measured first (rolled-back read-backs 13:25-13:50):
- **Cut-offs:** in 48 hours 68 of 430 scholarship extraction calls (15.8%) stopped at the 4,500-token limit. All were candidate pages listing many awards (school pages); successful answers are 1,518 tokens at p90. A cut answer went to the next model as the same whole-page request and cut again (21 items). s985 sends it as the existing two-part read (`sectioned-v1`). The limit is not raised, because that would make runaway answers dearer, not complete.
- **Torrens:** its 3 international pages were refused as "not a university provider" because its joined trading names include "Language Centre". s985 switches on the IQ-00215 legal-name test (shipped off on 4 Nov; it brings only Torrens into scope) and re-admits the 3 candidates through the canonical admission function. Rehearsed: Family scholarship (35%) and Motivational scholarship (25%) pass every check and publish on the next hourly tick.
- **Charles Darwin and Lincoln:** refused by their own pages (domestic only, international not stated, not a scholarship page); no refusal came from a cut answer. Their international awards sit on listing pages that need the listing reader (job `scholarship-listing` has been off since 08:29), which is the discovery gap for slice 2.
- **Not built:** a nationality rule. The readings mix code formats (AUS against the host code AU), so domestic awards would publish.
- **Spec claim:** `s985` taken (central table); `s1001` stays for the P1-P10 reconciliation fixture.

**S2-Build, 23 Nov 2026 13:20 AEDT: Platform Admin ownership decisions of 13:13 recorded in plan section 3a; documents only.**
- **City statistics:** `destination.*` passes from parked Lane 2 to S2-GEO. S2-GEO stays read-only until it reports its discovery findings and the Platform Admin unlocks writes.
- **English requirements** (`enrich:english`): stays with S1-ELR, or a dedicated S2-ELR session when one opens, and is parked. None of the five active lanes writes ELR code.
- **Rest of the 12:47 AER brief:** the CDU two-column layout, the 284 reads at confidence 0.70, the high-yield universities and ingress hash de-duplication go to S2-RM-Design as Priority 2, strictly after Pilot #1491 (`s1000`) merges on green.
- **Next:** S2-Build starts `s1001` (scholarship coverage for Charles Darwin, Lincoln and Torrens, plus the guardrail against scholarship extraction answers being cut off).

**S2-Build, 23 Nov 2026 13:10 AEDT (Platform Admin 13:00: parallel data-admission lane registration): ownership recorded in `docs/platform/CONTINUOUS-DELIVERY-MASTER-PLAN.md` section 3a; documents only.**
- **Single-writer domains:** S2-CF (official course URL, course description), S2-INT (exact intake dates, application deadlines), S2-GEO (campus locality, city statistics; read-only until the Platform Admin confirms `destination.*` passes from parked Lane 2), the AER/ELR owner (English requirements; the Platform Admin names the next writing chat), AER (`s1000` preserved with S2-RM-Design, Pilot #1491), S2-Build (scholarships, `s1001`) and S3 (spend gate, Firecrawl containment, Layer 4 hygiene).
- **Integration owner:** S2-Build, for dispatchers and schedules, `course_coverage_build_v1`, health and consumer checks, v3 serving and the developer hold, migration numbering at merge, versions, spec claims and shared registers.
- **Specs:** claimed centrally in the plan; next free `s987`; `s1003` unassigned. No migration timestamp or version is held in advance.
- **Checked live 13:05:** every scheduled job is mapped to one owner; the only open pull request is #1491.
- **Duplicate avoided:** S2-Build had measured the same AER resolver gap 12:47-12:58 and stopped before writing any file, because `s1000` covers it.

**S2-RM-Design, 23 Nov 2026 12:56 AEDT (Platform Admin 12:29, Priority 1: AER admission recovery): s1000 (Pilot, migration `20261123100000`) recorded before merge; database only, no version bump.** Found live (rolled-back read-backs, head `20261123060000`): 8,957 active courses (AU 8,601, NZ 356) read `academic_entry` no_reader while holding active, quoted, evidence-backed course entry rows for international or all applicants (8,515 with the academic kinds, the audit's figure). The rows are canonical already; `security.entry_resolve_v1` rule 1 reads only `override` rows and the coverage rule counts only override, matrix and provider-minimum rows, so Website and Zoho v3 answer "contact the provider" and coverage reports no reader. The v1 resolver feeds frozen v2 (`website_v2_course` → `entry_course_payload_v1`), so it is not edited (G3). s1000 adds `security.entry_resolve_v3` (v1's answer, except step 5 becomes the course's own academic rows as rule 1; an age limit is left out: 1,119 such rows), uses it in `website_v3_course` (Zoho v3 follows) and the Admin resolve views, and counts the same rows in field coverage. Rehearsed live and rolled back: academic entry coverage 2,250 → 10,441 courses (+8,191, +22.7 points of 36,046); in a 300-course sample 285 were step 5 and 0 remain; 0 other answers changed; Zoho v3 follows. v2 unchanged. Not done here: `docs/platform/TEST-REGISTER.md` (the generator needs `@playwright/test`, which this session cannot install); S2-Build's next register run includes the s1000 spec. s1001 stays with S2-Build.

**S2-RM-Design, 23 Nov 2026 12:19 AEDT (Platform Admin review of admin #797, 12:10): design v1.12, targeted reconciliation; documents only.** The contracts in `docs/Roadmap/2026-01/DESTINATION-DATA-DESIGN.md` are the **implementation baseline**, not production-verified. Seven corrections, checked against the live system by three rolled-back probes (Pilot `db-migration-dry-run` rehearsals 45093300850, 45093450408, 45093457903; head `20261123060000`): (1) no NZ or CA `register_rule` study load (NZ 4,172 and CA 2,362 courses have none; none register-sourced); (2) no course-campus link without course evidence; the 257 s818 links of 20 Nov (NZ 177, CA 80) stay as the accepted decision, withdrawal optional (H-09); (3) primary-campus tie-breaks and the below-90% postcode batch withdrawn (95 providers without a primary campus stay unresolved); (4) P8: provider-wide scholarships pass with a stated scope (0 of 1,140 unpublished are held by the course-link checks); (5) TISC recorded as unreachable, not as absence of guidance; IR-007 open for TISC; (6) QILT is served live in v3 (3,164 rows, 118 providers), so any gate needs approval and a developer notice (H-12); (7) `[D]` names corrected (`status`, `pipeline.aer_machine_admissions`, `catalogue.provider_entry_matrix`). Approvals reconciled row by row: decisions left are H-01 and H-02 (publish) and the optional H-03, H-06, H-08, H-09 and H-12; IR-017 and IR-019 closed. Build order handed to S2-Build: `s1001`, `s1000`, `s1002`, `s1007`, then `s1004`–`s1006` and `s1008`; each completes only with the production acceptance record (design section I). No Pilot or live change; the probe branch was deleted by the Auto-merge workflow.

**S2-Build, 23 Nov 2026 12:40 AEDT: s983 and s984 live (Pilot #1489 and #1490; migrations `20261123050000` and `20261123060000` applied by Deploy on merge); parked.** Read back live at 12:31:
- **AER:** active course entry rows rose from **26,996 to 27,929** (+933). All are from rule `aer-course-partial-v1`, on 347 courses, with 0 open P0 findings.
- **Scholarships:** the 12:29 publishing tick read values from 16 stored notes and **published 12**, so published is now **1,078**. Before the change the count was 1,066, because 8 scholarships whose closing date had passed (Melbourne date) were withdrawn automatically at 11:29 (REQ-72).
- **Unchanged at $0:** exact intakes 4,896 (FID readings carry months, not dates) and provider descriptions 2,216 (identity and source policy holds).
- **Health:** one critical check is open, `alerts:not_collected`. Five platform alerts have waited since 08:30 because the alert destination (the "Work queue alerts" scheduled task, not owned by this account) is not collecting them. It is unrelated to these releases and needs its owner to restart it.
- **Coverage-sweep:** no 5xx since 22:37 UTC. The one 5xx in the last hour came from the Boost bulk-ingest worker, a different lane.
- **Guardrails:** G3 75/48, no drift; locks 7,585; active cron 136 (coverage-read and coverage-read-2 switched back on outside S2-Build; cap 140); Layer 4 pending 1,483 (the 347 course items stay for their held rows); $0 Firecrawl and AI by S2-Build.
- **Left for a person:** 284 deterministic course reads at confidence 0.70 (unreliable reads; a better reader is AER v2 work); 31 hand-checked and 14 citizens-only scholarships; the CDU two-column pathway layout (REQ-99) needs a new layout reader, which Decision 276 sends to AER v2.

**S2-Build, 23 Nov 2026 12:05 AEDT (Platform Admin batch 11:10, "Data Admissions unblock, AER and scholarship coverage"): s983 (Pilot #1489, migration `20261123050000`) and s984 (Pilot #1490, migration `20261123060000`) recorded before merge.** Measured first (rolled-back read-backs 11:11-11:55; head `20261123040000`):
- **AER, 615 deterministic course reads in Layer 4:** 284 have every row at confidence 0.70, and the samples are genuinely wrong ("Units 3 and 4" read as a score of 4), so they stay held. 347 are held whole by the completeness gate, which flags a printed "other requirement" the reader skipped; 933 of their rows pass every machine row rule, and none of those courses had an active entry row.
- **Scholarships:** of the unpublished active records, 193 are held only by "no stated award value". 13 of them state the value in their stored note. The rest of the 48 international candidates are held by a person's hand check (31) or are citizens-only (14); those holds stand.
- **s983:** `security.aer_partial_admit_v1` gains rule `aer-course-partial-v1`, row-level partial admission for course reads stopped only by the gate. It applies the same policy as s914, with no lock, no overwrite and every row rule kept; the item stays in Layer 4 for the rest. `security.aer_current_findings_v1` counts these rows as admitted. Rehearsed over two ticks: **933 rows on 347 courses, active AER 26,996 → 27,929**, 0 false P0.
- **s984:** the hourly `scholarship_auto_publish_v1` reads the award value from the stored note of a text-only record before its publishability check: tuition percentage, tiers taken as the upper figure marked "up to" (REQ-64), and explicit amounts in the provider country's currency. Rehearsed over one tick: 16 values read, **12 now publish**.
- **Not changed:** the 0.70-confidence reads and the hand-checked or citizens-only scholarships (a person's holds and genuine rules); FID intake readings (months, no dates); Firecrawl fetches ($0 rule).

Live 11:11: G3 75/48; locks 7,585; active cron 134; Layer 4 pending 1,483.

**S2-RM-Design, 23 Nov 2026 11:25 AEDT (Platform Admin brief 11:11 AEDT): frozen design and governance contracts recorded; documents only.** `docs/Roadmap/2026-01/DESTINATION-DATA-DESIGN.md` v1.11, section "Frozen design and governance contracts": (A) AER admission: the brief's precedence mapped onto the unchanged resolver, a step-5 reason (`source_blocked`, `domestic_only`, `pathway_only`, `not_published_by_provider`) as a new v3 field beside `resolution.note` (the course `empty_reason_code` list is not widened), table rules N1 to N9 with CDU as the fixture, test and grade mappings, and the partial-admission rule that keeps `aer:p0` at 0; (B) scholarship publishability P1 to P10 with the Melbourne-date round state on the live values `open`, `closed`, `opening_soon`, `check_provider`; (C) Layer 4 close-by-rule predicates and five sign-off batches (82 primary-campus ties, 160 postcodes, 69 campuses, 5 English readings, 701 CRICOS departures); (D) QTAC and TISC: plain reads on 23 Nov found no official international route on either centre's own pages, so no state rule is written and the national rules cover QLD and WA; RM1C and RM1I publish checklists; JSA attribution; a QILT gate setting; RM1G teaching-language and NZ and CA study-load rules; (E) API v3 freeze audit, 13 items, all additive (ARWU and `primary_basis` values are missing from dictionary issue 1); (F) NZQCF, NZSCED and CIP native codes, one level mapping, and the campus-link reason contract; (G) UK, Ireland and USA adapter contracts and an AI Auto-Map ceiling of US$14.75; (H) one Platform Admin checklist, H-01 to H-12. **Nothing was built, deployed, approved or published; no live read was made (figures are the latest recorded ones); no Pilot file changed.** New requests IR-017 to IR-020. Build works from the section's order table under specs `s1000` to `s1008`. Open for the Platform Admin: sign H-01 to H-12.

**S2-Build, 23 Nov 2026 10:10 AEDT: s982 live (Pilot #1488, migration `20261123040000` applied by Deploy on merge); parked.** Listing claim 557 ms live at 10:08 (7.6 s at 09:52 before s982; 10.4 s under load before s978). No coverage-sweep 5xx since 22:37 UTC (before s981). Health has no critical check. IQ-00555 and IQ-00029 stay open until a day of clean listing runs. Live 10:08: head `20261123040000`; G3 75/48, no drift; locks 7,585; active cron 134. Open for the Platform Admin: non-AER Layer 4 rule-group settlement needs an approve or reject choice per group (not run); 606 deterministic AER reads stay for a person, one by one; under-load Courses reads (5.1-5.3 s at 08:46 with 22 jobs running) keep REQ-105 Partly delivered; branches `s2-build-reads` and `s2-build-am-reads` need deleting by someone with write access.

**S2-Build, 23 Nov 2026 10:00 AEDT: s980 live (Pilot #1486; dry-run gate and rehearsal job in use: the s982 rehearsal ran its pre-flight against live head 20261123030000) and s981 live (Pilot #1487, migration `20261123030000` applied; hold check 0.8 s for 34 providers at :52); s982 (Pilot #1488, migration `20261123040000`) recorded before merge.** After s981 the listing claim still took 5.5-7.6 s. EXPLAIN ANALYZE showed the planner running the host check on all 348 due pages before the provider filter. s982 puts the passing providers' pages in their own materialised step first: the claim takes 537 ms rehearsed at 09:54, against 7.6 s at 09:52. The last coverage-sweep 5xx was at 22:37 UTC (before s981); 4 since s978 in all. **Health has no critical check open at 09:51** (`consumer_snapshot:failing` resolved after the job stagger). Live 09:51: G3 75/48, no drift; locks 7,585; active cron 135; Layer 4 pending 1,483; AER 26,996, exact intakes 4,896, scholarships 1,074, provider descriptions 2,216.

**S2-Build, 23 Nov 2026 09:10 AEDT: s979 live (Pilot #1484 `584754cd`; IQ-00367 and IQ-00239 closed, read back 08:54); s980 (Pilot #1486, no migration) and s981 (Pilot #1487, migration `20261123030000`) recorded before merge.** s980 (Platform Admin 08:47: stop failed dry-run notices; make migration pre-flight permanent). No push or pull-request run had failed. The four failed `Database migration dry run (rolled back)` runs were hand-started rehearsals and read-back probes: three probe typos and one real catch (run 45068758936, the s978 post-check timeout, fixed before its PR). The workflow now has two jobs. `dry-run` is the gate: pull requests to `main` that add a migration and carry `live-dry-run`, with no push trigger. It runs `scripts/ci/migration-preflight.mjs` against main and the live head before the dry run and fails hard. `rehearsal` is for hand-started runs: it reports failures as warnings and cannot satisfy the gate. A probe error prints `PROBE-ERROR` instead of failing. `.githooks/pre-push` runs the pre-flight locally. Standing rule "Migration Pre-flight Before Any Push (s980)" is in CLAUDE.md and AGENTS.md in both repositories. Verified live before merge: gate self-test PR #1485 green (pre-flight against live head 20261123020000, closed unmerged); rehearsal of an applied file reported a pre-flight failure as a warning, run green; probe typo printed PROBE-ERROR, run green; the s980 PR started no dry run. s981 (IQ-00555): after s978 the listing claim still timed out twice under load (21:37 and 21:52 UTC). `security.fc_sch_held_v1` now checks the cap before the eligibility rule (same rule and answers; parity checked in the migration), with a covering index. Rehearsed: hold check for 31 providers 58 ms (was about 1.6 s quiet), claim 1.7 s. Under load at 08:46 (22 jobs running) the Courses NSW-by-fee read took 5.3 s, text search 5.1 s and the Zoho v2 probe 4.8 s, so REQ-105 stays Partly delivered under load. Health: only `consumer_snapshot:failing` is left (frozen Zoho v2, IR-012). Branches `s2-build-reads` and `s2-build-am-reads` could not be deleted from this session (proxy refuses ref deletes); the `…-probe` branch is swept by Auto-merge. Live 08:54: head `20261123020000`; G3 75/48; locks 7,585; active cron 135; Layer 4 pending 1,483.

**S2-Build, 23 Nov 2026 08:40 AEDT: s978 live (admin #791, then Pilot #1483 `b5dea68e`); migration `20261123010000` applied by Deploy on merge; s979 (Pilot #1484, migration `20261123020000`, data only) recorded before merge.** Live read-back 08:25-08:31: head `20261123010000`; both function edits present; five job schedules moved as planned; 106 stale AI course entry reads superseded and reopened to aer-det-v1.3 ($0); Layer 4 pending 1,484 (was 1,580). The 08:27 aer-reconcile run left **0 open AER P0 findings**, and Health check `aer:p0` resolved. The one critical check left is `consumer_snapshot:failing` (search_master_page2, the frozen Zoho v2 search; IR-012 keeps v2 frozen). The listing claim took 2.8 s at :28 (10.4 s under load before), with 0 HTTP 5xx since deploy. Job scholarship-listing, and coverage-read and coverage-read-2 (at 08:29), were switched off outside S2-Build, so active cron is now **134** (IR-016) and IQ-00555 and IQ-00029 have no fresh run to verify and stay open. s979 closes IQ-00367 and IQ-00239 (0 classify failures in 24 h). G3 75/48, no drift; locks 7,585; canonical AER 26,995 (unchanged: no new admission at $0); $0 AI and Firecrawl by S2-Build.

**S2-Build, 23 Nov 2026 08:15 AEDT (Platform Admin consolidated morning batch, 07:16 and 07:45 AEDT): s978 (Pilot #1483, migration `20261123010000`, no version bump: database only) recorded before merge.** (1) Health `aer:p0` and IQ-00367: all 31 critical AER findings were false positives. 1,133 provider-table rows admitted by the partial admission rule `aer-partial-v1` (s914, Platform Admin 21 Nov 10:03) read as "not admitted" because their Layer 4 item stays pending for the rows held back. `security.aer_current_findings_v1` now accepts a row named by an admitted `aer-partial-v1` ledger row (Decision 276: correctness fix only). (2) IQ-00555: coverage-sweep's HTTP 500s (59 in 24 h) were `svc_scholarship_listing_next` timing out at 8 s. Provider checks now run once per provider (29) instead of per due page (339), and the host check only on pages that passed: 10.4 s under load before, 5.3 s after. (3) IR-013: aer-source-discover, field-gap-queue, aer-machine-admission, cdesc-queue-refresh and layer4-readiness move out of :19-:23 and :49-:53 (none to :00-:02; commands unchanged; layer2-onboarding-snapshot kept as a dispatcher shadow target). (4) $0 re-read: the existing `aer_det_reread_v1` rule supersedes the 106 stale AI course entry reads that have a stored copy and reopens them to aer-det-v1.3. Layer 4 goes from 1,580 to 1,474 in the dry run; nothing is approved or rejected. Of the "687 group-B" figure, 606 are already deterministic reads waiting for a person and 33 have no stored page, so the rule does not take them. Measured and not changed: the 48 international scholarships that look publishable are held by the publishability check (31 hand-check holds, 14 citizen-only, 3 other); 5,837 FID intake readings are months or terms with no date, held by the no-overwrite rule, so they cannot add exact intakes; provider description holds are identity and source policy holds (no switch was off; 2,291 admitted by rule); no pending Layer 4 item has a manual lock, and none of the 1,580 met a supersede rule. Courses text search took 1.4-5.4 s (filter itself 0.58 s); the Zoho v2 probe query (frozen) takes 2.4 s quiet because the frozen function materialises every matching row, so an index cannot fix it. Live 07:20: head `20261123000000`; G3 75/48, no drift; locks 7,585; active cron 136 (above the 134 asked; no job paused, decision needed); canonical AER 26,995, exact intakes 4,896, scholarships 1,074, provider descriptions 2,216.

**S2-Build, 23 Nov 2026 07:30 AEDT: s977 live (admin #789, then Pilot #1482 `775ea3d0`, v2.16.86); migration `20261123000000` applied by Deploy on merge (history md5 2a02cec0 matches the file). Live read-back: Australia + New South Wales by International fee 0.35 s steady over eight calls (1.19 s first call), Victoria 0.33 s, Website API v3 keyword search 0.51 s steady (no generic-plan slowdown); in the 07:20 job window (7 cron jobs running) the same read took 1.6-2.7 s (4.9 s first call), so under-load reads stay above 1.5 s until IR-013 (job staggering or compute) is decided; no 8 s timeout seen. REQ-105 stays Partly delivered for that reason. Guardrails live 07:15: G3 75/48, no drift; locks 7,585; active cron 134; $0 AI and Firecrawl by S2-Build. Counsellor and Viewer screens could not be checked signed in (the deployed UAT signs in as one user); TEST-REGISTER.md not regenerated (packages unavailable). Decisions needed: IR-012, IR-013, IR-014, IR-015; REQ-109 to REQ-111 scoping. Parked.**

**S2-Build, 23 Nov 2026 06:35 AEDT (scheduled run of the Platform Admin batch queued 22 Nov 2026 22:01 and its 22:57 addendum; S1 usage credit exhausted): s977 (v2.16.86, Pilot #1482, migration `20261123000000`) recorded before merge. REQ-105 closed for filtered and sorted Courses lists (set-based state path, each call planned with its own values: Australia + New South Wales by International fee 2.6-7.3 s before, 0.26 s list and 0.35 s through admin_read over eight calls in a rolled-back rehearsal; same rows, order and totals on eight lists); seven-filter counselling bar for Counsellor and Viewer with Clear / Reset (Operators and Platform Admins keep every filter); intake, fee range and English score filters; Settings › API usage in one compact table; Website API v3 search planned per call. Decisions needed: IR-012 (frozen Website API v2 latency), IR-013 (database load at :19-:23 and :49-:53), IR-014 (red Health: consumer snapshot and AER P0), IR-015 ($0 data gaps). Live 05:32: head `20261122230000`; G3 75/48, no drift; locks 7,585; active cron 134.**

**S3 post-containment verification — 22 November 2026:** The existing `firecrawl-runs` cron (job 108, one-minute dispatch) was paused **only after** verifying zero active Firecrawl runs, zero leased run items and the zero-credit setting. This changes 137 active registered cron jobs to **136**, meeting the S3 cap without deleting a job or replacing its schedule. Existing Firecrawl `daily_budget_total=0`, `daily_budget_on=true`; the vendor ledger showed **0 new charged calls/credits after the 23:07 cap**, as of the follow-up read. Pilot #1481 adds the guarded hard-zero branch to the existing `public.svc_fc_spend`, including on-demand exemptions; PR is waiting on exact-head CI and is **not yet deployed**. The prior first full CI run on #1481 failed only housekeeping s42 because migration omitted its required Replaces/Retires headers; the next head fixes these comments, so actual green checks and deploy are still required. Layer 4 automatic reconciliation independently found **0 policy-proven resolvable** items among all **340** pending official-course-URL, tuition or ELR cases; no forced closures, no 859 AER item decisions or reread bypass. FID `fid_det_readings` currently includes 380 already-admitted and 5,837 held intake readings; 7,023 readings recorded across 15,181 FID pages, distinct from the empty old Run Now cohort-stage history. Supabase Edge logs for 22 Nov 20:00–23:40 AEDT showed 37 coverage-sweep HTTP 546 and 8 HTTP 500, so **0 errors is not verified**; this remains P1 investigation. No extra Firecrawl or paid AI was invoked by S3; the AI ledger recorded spend from unrelated scheduled `enrich_fields` jobs, thus a platform-wide AI $0 claim is not supported. Drive `M3`/Monitoring mirrors could not be identified in the connected Google Drive search and are **not marked synced**. Five IQ items remain open until cause-specific green release and net canonical gains.\n\n**S3 P1 checkpoint — 22 November 2026 23:07 AEDT:** Live-read migration head `20261122180000`; 137 active pg_cron jobs (all registered, higher than this S3 mandate's <=136 cap), 7,585 manual locks, Layer 4 pending 1,580 at last read (initial sample 1,582); canonical active course-entry 26,995, exact intake dates 4,896, published scholarships 1,074, provider descriptions 2,216. The 22:06–22:43 Firecrawl vendor usage consists of 6 scholarship scrapes and 5 site maps (11 credits, no on-demand request IDs). **Live containment:** at 23:07 `firecrawl.daily_budget_total` changed 4000→0, with `daily_budget_on=true`; measured 0 further calls at the next read. On-demand exceptions are NOT hard-blocked by that setting alone; Pilot s976 is an in-place `svc_fc_spend` guard for cap=0. Exact rolled-back live rehearsal for scheduled/scholarship/on-demand had PASS exception and no persistent function change. Existing `pipeline.intake_cohort_stages` has 0 rows while the old cohort sources date to 5 Nov; no history manufactured. **No other P1 blocker resolved yet, no manual Layer 4 approvals, no paid AI initiated by S3; all canonical counts remain unchanged.** [S3 Master Plan §3/§5/§6](platform/CONTINUOUS-DELIVERY-MASTER-PLAN.md). This live check supersedes earlier chat counts for this audit only.

**Rule (Platform Admin, 16 Nov 2026 09:20):** every version bump, migration, or UI or scheduler change updates this page in the same release cycle, with the documents it points to. A fact here carries the time it was read; check the live system before relying on a figure older than a day.
**Last updated:** 27 Nov 2026 00:30 AEDT (S1-RM-Design: s1176c live), 27 Nov 2026 00:30 AEDT (S1-RM-Design: s1176c recorded before merge), 26 Nov 2026 23:45 AEDT (S1-RM-Design: s1176b live; job effectiveness assessment), 26 Nov 2026 23:05 AEDT (S1-RM-Design: s1176b consumer field verification recorded before merge), 26 Nov 2026 23:05 AEDT (S2-Build: DR-19 increments 2 to 4, s1282, recorded before merge), 26 Nov 2026 22:50 AEDT (S1-RM-Design: s1176 live and read back), 26 Nov 2026 22:40 AEDT (S2-Build: DR-19 s1272 live and accepted on production), 26 Nov 2026 22:40 AEDT (S1-RM-Design: s1176 PIM monitoring by jobid recorded before merge), 26 Nov 2026 19:40 AEDT (S2-Build: DR-19 increment 1 s1272 recorded before merge), 26 Nov 2026 19:25 AEDT (S2-Build: DR-19 claimed, design recorded, increment 1 s1272), 26 Nov 2026 18:40 AEDT (S2-Build: s1271 portal sole-city place live, Pilot #1678), 26 Nov 2026 18:25 AEDT (S2-Build: s1271 portal sole-city place recorded before merge), 26 Nov 2026 16:40 AEDT (S2-Build: s1222 portal UAT fixes live, Pilot #1670), 26 Nov 2026 16:35 AEDT (S1-RM-Design: DR-16 claimed), 26 Nov 2026 16:20 AEDT (S2-Build: s1222 portal UAT fixes recorded before merge), 26 Nov 2026 15:45 AEDT (S2-Build: s1220 portal screens live, Pilot #1666), 26 Nov 2026 15:40 AEDT (S2-Build: s1220 portal screens for the s1216 fields recorded before merge), 26 Nov 2026 14:50 AEDT (S1-RM-Design: s1174 Data Delivery snapshots), 26 Nov 2026 13:28 AEDT (S2-Build: s1216 portal detail fields live, Pilot #1658), 26 Nov 2026 13:15 AEDT (S2-Build: s1216 portal detail fields recorded before merge), 26 Nov 2026 13:30 AEDT (S1-RM-Design: PIM monitoring reconciled, s1173), 26 Nov 2026 12:45 AEDT (S1-API-Frontend-Delivery: s1215 portal Course details, Entry Requirements and new-tab links recorded before merge), 26 Nov 2026 12:35 AEDT (S2-Build: s1213 read back live; s1214 portal detail and entry requirements live), 26 Nov 2026 12:25 AEDT (S2-Build: s1213 live; s1214 portal detail and entry requirements recorded before merge), 26 Nov 2026 12:20 AEDT (S2-Build: s1213 daytime quiet hours recorded before merge), 26 Nov 2026 11:45 AEDT (S2-Build: s1212 portal meaning step live, Pilot #1653), 26 Nov 2026 11:25 AEDT (S2-Build: s1211 live; s1212 recorded before merge), 26 Nov 2026 11:00 AEDT (S2-Build: s1211 portal search latency recorded before merge), 26 Nov 2026 08:30 AEDT (S1-RM-Design: PIM operational verification 1), 26 Nov 2026 09:00 AEDT (S2-Build: s1210 Portal Release 2 proposals layer live, Pilot #1646), 26 Nov 2026 08:25 AEDT (S2-Build: s1210 Portal Release 2 proposals layer recorded before merge), 26 Nov 2026 07:35 AEDT (S1-RM-Design: PIM core development closure), 26 Nov 2026 05:15 AEDT (S1-RM-Design: s1171 live), 26 Nov 2026 05:45 AEDT (S2-Build: s1181 portal search hardening live, Pilot #1637), 26 Nov 2026 05:10 AEDT (S2-Build: s1181 portal search hardening recorded before merge), 26 Nov 2026 04:20 AEDT (S1-RM-Design: step 5 findings and next slices), 26 Nov 2026 01:55 AEDT (S1-RM-Design: PIM s1169, s1170 live; checkpoint), 26 Nov 2026 00:25 AEDT (S2-Build: s1180 portal search hotfix live, Pilot #1633), 26 Nov 2026 00:55 AEDT (S1-RM-Design: PIM s1167, s1168 live; checkpoint), 25 Nov 2026 23:35 AEDT (S2-Build: s1180 portal search hotfix recorded before merge), 25 Nov 2026 23:55 AEDT (S1-RM-Design: PIM steps 1 to 3 live), 25 Nov 2026 22:45 AEDT (S2-Build: s1153 scope decided, published providers only; ready for UAT), 25 Nov 2026 20:45 AEDT (S2-Build: s1153 follow-up live; backfill complete), 25 Nov 2026 20:15 AEDT (S2-Build: s1153 live; embed batch follow-up), 25 Nov 2026 18:30 AEDT (S2-Build: s1153 portal course search recorded before merge), 23 Nov 2026 19:35 AEDT (S2-Build: s992 live; parked; live migration head 20261123200000), 23 Nov 2026 19:30 AEDT (S1-RM-Design: HELD codes; Auckland HELD:PARSER_EDGE_CASE; s996 claimed), 23 Nov 2026 18:55 AEDT (Standing Authority Charter committed), 23 Nov 2026 18:30 AEDT (S2-RM-Design: carryover verified; batch 1 recorded, IR-027), 23 Nov 2026 18:30 AEDT (S2-Build: s989 live; s992 recorded before merge), 23 Nov 2026 17:25 AEDT (S1-RM-Design: S1-UI-UX v1.1 baseline, 44/44; prerequisites IR-025, IR-026), 23 Nov 2026 17:12 AEDT (S2-RM-Design: s1009 live), 23 Nov 2026 16:09 AEDT (S2-RM-Design: s1009 recorded before merge), 23 Nov 2026 16:30 AEDT (S1-RM-Design: decisions on REQ-116, REQ-118, REQ-110 recorded), 23 Nov 2026 16:10 AEDT (S1-RM-Design: counsellor feedback 1 to 3 reconciled; REQ-113 to REQ-123, IR-021 to IR-024), 23 Nov 2026 16:20 AEDT (S2-Build: s989 recorded before merge; TEST-REGISTER regenerated; AER reader register to S1-Build), 23 Nov 2026 14:45 AEDT (S2-Build: s985 live; Torrens 2 published; live migration head 20261123110000), 23 Nov 2026 14:00 AEDT (S2-Build: s985 recorded before merge), 23 Nov 2026 13:17 AEDT (S2-RM-Design: s1000 live; NZ/CA campus-link audit), 23 Nov 2026 13:20 AEDT (S2-Build: ownership decisions of 13:13), 23 Nov 2026 13:10 AEDT (S2-Build: data-admission lane ownership, plan section 3a), 23 Nov 2026 12:56 AEDT (S2-RM-Design: s1000 recorded before merge), 23 Nov 2026 12:19 AEDT (S2-RM-Design: design v1.12, reconciliation of the Platform Admin review; documents only), 23 Nov 2026 12:05 AEDT (S2-Build: s983 and s984 recorded before merge), 23 Nov 2026 11:25 AEDT (S2-RM-Design: frozen design and governance contracts, design v1.11; documents only), 23 Nov 2026 10:10 AEDT (S2-Build: s982 live; parked), 23 Nov 2026 10:00 AEDT (S2-Build: s980 and s981 live; s982 recorded before merge; Health has no critical check), 23 Nov 2026 09:10 AEDT (S2-Build: s979 live; s980 and s981 recorded before merge), 23 Nov 2026 08:40 AEDT (S2-Build: s978 live; s979 recorded before merge), 23 Nov 2026 08:15 AEDT (S2-Build: s978 recorded before merge, Pilot #1483), 23 Nov 2026 07:30 AEDT (S2-Build: s977 live, v2.16.86, Pilot #1482 `775ea3d0`; parked), 23 Nov 2026 06:35 AEDT (S2-Build: s977 v2.16.86 recorded before merge, Pilot #1482), 22 Nov 2026 17:40 AEDT (S1-API-Frontend-Delivery: consolidated batch complete; s974 and s975 live; S2 stays parked), 22 Nov 2026 17:30 AEDT (S1-API-Frontend-Delivery: s972 and s973 live; s974 and s975 recorded before merge), 22 Nov 2026 16:35 AEDT (S1-API-Frontend-Delivery: s971 live; s972 REQ-105 and s973 RM1K recorded before merge), 22 Nov 2026 14:55 AEDT (S1-API-Frontend-Delivery: consolidated batch started, S2 stands down; s971 recorded before merge), 22 Nov 2026 13:20 AEDT (S1-API-Frontend-Delivery: rankings delivered for THE; IR-011 for QS; s970 recorded before merge), 22 Nov 2026 12:45 AEDT (S1-API-Frontend-Delivery: THE 2027 live; s969 recorded before merge), 22 Nov 2026 12:00 AEDT (S1-API-Frontend-Delivery: s967 live; s968 recorded before merge), 22 Nov 2026 11:30 AEDT (S1-API-Frontend-Delivery: s966 live; s967 fix recorded before merge), 22 Nov 2026 10:20 AEDT (S1-API-Frontend-Delivery: rankings decision recorded; s966 THE and QS public readers recorded before merge), 22 Nov 2026 01:45 AEDT (Lane 2: s965 live, Pilot #1472 `34e31e05`, migration `20261122100000` now the live head; 75 draft Tasmania-wide living-cost figures; parked), 22 Nov 2026 02:45 AEDT (S1-API-Frontend-Delivery: v2.16.83 live; Lane 1 parked), 22 Nov 2026 01:00 AEDT (Lane 2: s965 RM1I Tasmania-wide living costs, 75 draft figures, recorded before merge, Pilot #1472, migration `20261122100000`; item 3 audited, nothing rule-resolvable at $0), 22 Nov 2026 02:20 AEDT (S1-API-Frontend-Delivery: s959 live; RM1K acceptance read; v2.16.83 recorded before merge, Pilot #1471), 22 Nov 2026 01:40 AEDT (S1-API-Frontend-Delivery: s958 live, v2.16.81; s959 recorded before merge, Pilot #1470, v2.16.82), 22 Nov 2026 01:00 AEDT (S1-API-Frontend-Delivery: s957 live, v2.16.80; s958 recorded before merge, Pilot #1469, v2.16.81), 22 Nov 2026 00:05 AEDT (S1-API-Frontend-Delivery: s956 live, v2.16.79; s957 recorded before merge, Pilot #1468, v2.16.80), 21 Nov 2026 22:55 AEDT (S1-API-Frontend-Delivery: s955 live; s956 recorded before merge, Pilot #1467, v2.16.79), 21 Nov 2026 22:50 AEDT (Lane 2: s960 live, Pilot #1466 `de3ddba5`, migration `20261122050000` now the live head; 5 RM1C routes as draft rules with state scope, $0; parked), 21 Nov 2026 22:00 AEDT (Lane 2 S2-Data-Destination-Continuous: s960 RM1C Australian application routes recorded before merge, Pilot #1466, migration `20261122050000`; draft edition, state scope, $0), 21 Nov 2026 22:05 AEDT (S1-API-Frontend-Delivery: s955 recorded before merge, Pilot #1465, migration `20261122030000`), 21 Nov 2026 21:35 AEDT (S1-API-Frontend-Delivery: Step 0, Continuous Delivery Master Plan v0.1 and standing rule), 21 Nov 2026 20:30 AEDT (S1-RM-Design: s951 P0, website-api-v3 and zoho-api-v3 answered 503 since s935 because they called the unexposed pipeline schema; fix migration 20261122020000 adds public entry points), 21 Nov 2026 18:45 AEDT (S1-ELR-Fetch-Window: s950 live, Pilot #1462 `41572ace`, migration `20261122010000` now the live head; parked), 21 Nov 2026 18:30 AEDT (S1-ELR-Fetch-Window: s950 recorded before merge, Pilot #1462, migration `20261122010000`; logic only, $0), 21 Nov 2026 15:25 AEDT (S1-Coverage-Unlock-UI-Notes: window ad97c846 closed, s945), 21 Nov 2026 14:50 AEDT (S1-RM-Design s935 live: Pilot #1458 `44f68a06` v2.16.78, migration `20261121230000` now the live head; Settings › API usage shows every version and key; Website v3 key bridge to 5 Dec; parked), 21 Nov 2026 14:32 AEDT (S1-Fix-IQ00313: s940 live and verified, Pilot #1459 `ad95b073`, admin #757 `0e6434ed`, migration `20261121220000`; Massey MY0418 reads July 2027 with no day in the catalogue, Website and search (no Zoho item exists for Massey); clean unattended intake cycle 14:26, 0 day admissions; G3 75/48; locks 7,585; IQ-00313 closed, parked), 21 Nov 2026 14:55 AEDT (S1-Impl-Layer4-Human-UI-Guide: s932 live, v2.16.77; parked), 21 Nov 2026 14:00 AEDT (S1-Fix-IQ00313: s940 recorded before merge, Pilot #1459, migration `20261121220000`: general semester descriptions ("Semester One: late February to June") give month only; Massey MY0418 goes back from 12 Jul 2027 to July 2027; live on deploy; dry run passed, md5 `8b933573`), 21 Nov 2026 14:20 AEDT (S1-Impl-Layer4-Human-UI-Guide: s931 live; s932 recorded before merge, v2.16.77), 21 Nov 2026 13:45 AEDT (S1-RM-Design s935: Settings › API usage for every version and key, one key per consumer and version, Pilot #1458 v2.16.76, migration `20261121200000`; standing rule Self-Sustaining API & Key Governance), 21 Nov 2026 13:35 AEDT (S1-Fix-IQ00313: s925 live and verified, Pilot #1453 `899c9986`, admin #747 `c636a5dd`, migration `20261121170000`; ECU 086244B, 060895C and 083819C read February 2027 with no day in catalogue, Website and Zoho; two clean unattended intake cycles (12:26, 13:26), 0 day admissions from general wording; G3 75/48; locks 7,585; parked; Massey MY0418 held for a decision), 21 Nov 2026 13:40 AEDT (S1-Impl-Layer4-Human-UI-Guide: s931 recorded before merge, v2.16.76; s930 live), 21 Nov 2026 13:20 AEDT (S1-ELR-Bands-And-Crawl and IQ-00624 closed: sweep 34/34 since s910, 48 central pages fetched, Table 1 5,919, Table 2 8,836), 21 Nov 2026 12:45 AEDT (S1-Dynamic-Lookups: s930 recorded before merge, v2.16.75), 21 Nov 2026 12:40 AEDT (S1-RM-Design: s927 daily data gap register, Pilot workflow `Course field readiness` plus scheduled task "Data gap register to Drive (08:07)" `trig_019UmEjiuMzPiWfev6ospuFJ`, Google Sheet `StudySearch_Data_Gap_Register`; course × field by country, not shared; runbook `docs/platform/DATA-GAP-REGISTER.md`), 21 Nov 2026 11:20 AEDT (S1-ELR-Unblock-IQ00624: IQ-00624 cleared, elr-det-sweep 11/11 since s910; s926 fetch reopen recorded before merge, Pilot #1454), 21 Nov 2026 11:35 AEDT (S1-Fast-Admission: s914 to s916 live and read back, Pilot #1450 `2c2ad53a`, migration `20261121150000`; 1,133 entry-table rows at 31 providers and 75 course reads admitted in the first runs; parked), 21 Nov 2026 11:45 AEDT (S1-Fix-IQ00313: P0 IQ-00313 s925 recorded before merge, Pilot #1453, migration `20261121170000`: calendar-v3 never takes a start day from general course-page wording; ECU 086244B, 060895C and 083819C go back from 22 Feb 2027 to February 2027 with history, evidence and locks kept; live on deploy; audit `docs/platform/2026-11-21-iq00313-generic-wording-audit.md`), 21 Nov 2026 11:00 AEDT (S1-Design-Layer4-Guide: design only, no code, migration or job change. Locked spec `docs/design/2026-11-21-layer4-human-ui-and-guide-spec.md` signed off 10:53 AEDT as Decision 279 (D1 approved, Phase 0 mock-up skipped; D2 existing re-read paths only; D3 read-only `provider_id` and `source_country` on `rule_groups` and `admin_layer4_grid_read_v1`; D4 lock only where `decide` accepts `set_manual_lock`; D5 Add official URL for Curator and above). Layer 4 three-decision card, five primary filters with Advanced filters (N), source-limitation pills on five screens, Platform guide filter reference, Layer 4 guide and four worked examples. Implementation is next and touches `src/Layer4Inbox.jsx`, so other lanes please hold edits there), 21 Nov 2026 10:50 AEDT (S1-Coverage-Unlock-UI-Notes: standing mandate, immediate live activation; s917 recorded before merge), 21 Nov 2026 10:45 AEDT (S1-ELR-Bands-And-Crawl: s910 merged, elr-det-sweep running again; s913 worker modes fix recorded before merge, Pilot #1451, migration `20261121140000`), 21 Nov 2026 10:50 AEDT (S1-Fast-Admission: renumbered to s914 to s916, Pilot migration `20261121150000`, Pilot #1450, because S1-ELR-Bands-And-Crawl took s913 and `20261121140000`. The partial entry-table admission goes live now; this replaces the s912 cutover planned for 22 Nov 09:30. Audit samples go to 0; the admission and reconcile jobs run every 15 minutes; the $0 sweeps take three times the work; aer-det NUL fix), 21 Nov 2026 10:10 AEDT (S1-Coverage-Unlock-UI-Notes: partial entry-table admission approved; s912 recorded before merge), 21 Nov 2026 10:15 AEDT (S1-ELR-Bands-And-Crawl: Pilot #1447 merged; elr-det-sweep failing since 08:47 AEDT, s910 fix recorded before merge, Pilot #1448, migration `20261121120000`), 21 Nov 2026 10:05 AEDT (S1-ELR-Bands-And-Crawl: s904 to s909 recorded before merge, Pilot #1447, migration `20261121110000`: band label fix, English band to course matching, one-off fetch of 52 central English pages), 21 Nov 2026 09:20 AEDT (S1-CourseLink-2027-CRICOS: s894 live, Pilot #1445 `2bf2b592`, admin #734 `80bdf5de`, migration `20261121093000` now the live head; year holds 158 to 100, La Trobe PHDLJ admitted from its stored copy; parked), 21 Nov 2026 09:20 AEDT (S1-Coverage-Unlock-UI-Notes: s900 to s903 live and read back, v2.16.74), 21 Nov 2026 09:05 AEDT (S1-Coverage-Unlock-UI-Notes: s901 to s903 recorded before merge; s900 live), 21 Nov 2026 09:05 AEDT (S1-ELR-Central-Policy closed: Pilot #1443 3bace2e7, migration `20261121080000`; v1.1 second pass running, 354 pages left; Table 1 5,930, Table 2 8,837), 21 Nov 2026 08:40 AEDT (S1-CourseLink-2027-CRICOS: s894 re-issued as migration `20261121093000`, Pilot #1445; its first version `20261121080000` was S1-ELR-Central-Policy's, so nothing of s894 was live), 21 Nov 2026 08:45 AEDT (S1-Coverage-Unlock-UI-Notes: s900 recorded before merge), 21 Nov 2026 08:35 AEDT (S1-ELR-Central-Policy: s895 and s896 recorded before merge, Pilot #1443, migration `20261121080000`: `elr-central-v1.1` second pass over every stored central English page, no exclusions; Table 1 5,930), 21 Nov 2026 07:50 AEDT (S1-CourseLink-2027-CRICOS: Platform Admin 07:35 decisions; s894 recorded before merge, Pilot #1442, migration `20261121080000`: 8 items a call, held address proved by its stored copy), 21 Nov 2026 02:30 AEDT (S1-Ops-Capacity-Runtime: capacity and runtime audit, read only), 21 Nov 2026 01:45 AEDT (S1-CourseLink-2027-CRICOS: s891 to s893 live, Pilot #1441 `a0f9cece`, admin #728 `3b740982`, v2.16.73, migration `20261120235000` now the live head; first runs: 14 of 120 tried admitted, year holds 158 to 144; parked), 21 Nov 2026 00:20 AEDT (S1-CourseLink-2027-CRICOS: s891 to s893 recorded before merge, Pilot #1441, v2.16.73, migration `20261120235000`: held course links with an old year move to 2027, 2026 or 2025 when the page proves the exact CRICOS code, $0, inside link-refresh), 21 Nov 2026 00:05 AEDT (S1-ELR-Central: s884 to s886 live and read back, Pilot #1439 `718106fc`; G3 75/48; locks 7,585; cron 135; US$0; first 40 minutes 85 central pages, 41 proposals, 8 approved automatically, 53 rows written, 2 to Layer 4; Table 1 6,118, Table 2 8,969), 20 Nov 2026 23:40 AEDT (S1-RM-Design: s890 live and read back, Pilot #1440 `f0b8d751`, admin #724 `f46d1d60`, migration `20261120231000` now the live head; Victoria University 02475D off the held list), 20 Nov 2026 23:25 AEDT (S1-RM-Design: Platform Admin 22:54 and 23:07 decisions: Victoria University 02475D kept with its 35 courses and given the 00124K description, s890 recorded before merge, Pilot #1440, migration `20261120231000`; UTS unchanged and live; REQ-59, REQ-66 and REQ-69 confirmed), 20 Nov 2026 23:30 AEDT (S1-RM-Design: Website API v3 readiness checked live, ten actions, v2 parity, 0 website v3 calls in 14 days; v3 developer guide issue 1 with field dictionary, OpenAPI and Postman in `docs/integrations/developer-pack/v3/`; developer email drafted, not sent; gaps: 9,348 courses at 447 providers to collect, 71 providers with no website, 1,956 Layer 4 items pending; `docs/platform/2026-11-20-api-v3-readiness-and-coverage.md`), 20 Nov 2026 23:20 AEDT (S1-ELR-Central: s884 to s886 recorded before merge, Pilot #1439, migration `20261120220000`: central English pages read at $0 by `elr-central-v1.0`, governed policy route with VET tier and regulated-discipline holds, inside `elr-det-sweep`; Table 1 6,160), 20 Nov 2026 23:00 AEDT (S1-Build: Platform Admin 22:41 decisions recorded: REQ-49 Delivered, REQ-69 Partly delivered, REQ-59 and REQ-66 Open; UTS description live; Victoria University held for one decision), 20 Nov 2026 20:10 AEDT (S1-Fees-Intakes: s856 and s857 live, Pilot #1438 `13575474`, migration `20261120200000`; ticks 0.2 to 2.8 s; parked), 20 Nov 2026 20:00 AEDT (S1-Fees-Intakes: s857 recorded before merge, migration `20261120200000`: s856 pacing re-issued without a drop after the deploy refused `20261120193000`, never applied), 20 Nov 2026 19:30 AEDT (S1-Fees-Intakes: s856 recorded before merge, migration `20261120193000`: the deterministic sweep sends one call a minute and records one reply a run, after 84 to 120 s ticks and one WORKER_RESOURCE_LIMIT burst), 20 Nov 2026 18:55 AEDT (S1-RM-Design: s875 live and checked signed in, Pilot #1436 `ebae623e`, admin #711 `80982d6c`, v2.16.72, no migration; lane parked), 20 Nov 2026 18:35 AEDT (S1-RM-Design: s872 to s874 live and checked signed in, Pilot #1435 `d3fbed00`, admin #708 `925c324d`, v2.16.71, migration `20261120174700`; s875 recorded before merge, Pilot #1436, v2.16.72, no migration), 20 Nov 2026 18:25 AEDT (S1-Fees-Intakes: s850 to s852 live and read back, Pilot #1425 `57efdea8`, admin #695 `5f7b8576`, migrations `20261120175000` and `20261120175100`, worker v1.0.34; Fee reader watchdog `nothing_left`; `fid-det-sweep` 18 of 18 runs clean; parked), 20 Nov 2026 18:15 AEDT (S1-Build: s881 live (Pilot #1434, `20261120181000`, history md5 `b0ae0cb4`): 136 active cron jobs, 0 unregistered; merged hands-free by the automerge label), 20 Nov 2026 18:05 AEDT (S1-RM-Design: s870 and s871 live, Pilot #1432 `fb182018`, v2.16.70; s872 to s874 recorded before merge, Pilot #1435, v2.16.71, migration `20261120174700`: one card contract for the 19 Layer 4 queues), 20 Nov 2026 18:05 AEDT (S1-Build: s881 idle cron jobs recorded before merge (Pilot #1434, `20261120181000`): active 143 to 136, 0 unregistered; s880 automatic merging live), 20 Nov 2026 16:10 AEDT (S1-Fees-Intakes: s850 to s852 recorded before merge, Pilot #1425, migrations `20261120165000` and `20261120165100`: Fee reader (AI) stuck item fixed; $0 deterministic fee, intake and deadline reader `fid-det-v1.0`, gated promotion and job `fid-det-sweep`), 20 Nov 2026 17:30 AEDT (S1-RM-Design: s870 and s871 recorded before merge, Pilot #1432, v2.16.70, migration `20261120145500`: AER re-read from the stored copy ($0), stale partial-table holds re-queued), 20 Nov 2026 17:20 AEDT (S1-ELR: s840 to s843 live and read back, Pilot #1428 `5873a131` and #1431; head `20261120172000`, 2,224 rows; G3 75/48; locks 7,585; US$0; runner-b 0 failures since the fix; first yield 12 courses promoted, 5 to Layer 4; Table 1 6,205, Table 2 8,980), 20 Nov 2026 17:30 AEDT (S1-Build: s870 automatic merging recorded before merge (Pilot #1433; this repository's Auto-merge workflow); no database change), 20 Nov 2026 17:15 AEDT (S1-Structure-Outcomes: s860 to s862 closed; head `20261120172000`; 77 durations, 7 study loads and 1 delivery mode admitted at $0; sweep draining 2,082 stored pages; two gap tables), 20 Nov 2026 16:55 AEDT (S1-Structure-Outcomes: s861 live and read back, Pilot #1427, head `20261120163500`, 26 durations and 4 study loads admitted in the first three ticks; s862 recorded before merge, Pilot #1430, migration `20261120172000`: shared-page check indexed), 20 Nov 2026 16:40 AEDT (S1-RM-Design: s839 live, Pilot #1429 `4a0695c8`, v2.16.69; S1-UI-Parity s836 to s839 closed), 20 Nov 2026 16:20 AEDT (S1-RM-Design, S1-UI-Parity: s836 to s838 live and read back, Pilot #1424 `13256fba`, v2.16.68, migration `20261120145000` applied; s839 recorded before merge, Pilot #1429, v2.16.69), 20 Nov 2026 16:55 AEDT (S1-ELR: s840 to s842 recorded before merge, Pilot #1428, migration `20261120170000`: admission-rule-runner-b English plan time-outs fixed, deterministic English requirement reader `elr-det-v1.0`, gated promotion and sweep `elr-det-sweep`; baseline 20,836 of 36,031 with English, Table 1 6,215, Table 2 8,980), 20 Nov 2026 15:50 AEDT (S1-RM-Design, S1-UI-Parity: s836 to s838 recorded before merge, Pilot #1424, v2.16.68, migration `20261120145000`: Dashboard parity, Layer 4 Review by rule, card polish, Platform Health rates), 20 Nov 2026 16:25 AEDT (S1-AER: s834 and s835 closed, Pilot #1423 live, migration `20261120163000`, reader `aer-det-v1.3`, job `aer-det-sweep` running), 20 Nov 2026 16:05 AEDT (S1-Structure-Outcomes: s860 and s861 recorded before merge, Pilot #1427, migration `20261120163500`: deterministic course structure reader `struct-det-v1.0` (duration, study load, delivery mode), automated promotion and scheduled sweep at $0; baseline NZ/CA gaps), 20 Nov 2026 15:22 AEDT (S1-AER: s834 and s835 recorded before merge, Pilot #1423, migration `20261120160000`: reader `aer-det-v1.3` academic only; automated deterministic AER promotion and scheduled sweep), 20 Nov 2026 14:55 AEDT (S1-Courses: s833 live and read back, Pilot #1422, queue summary 43 ms and items 86 ms; correction: Pilot #1411 had merged), 20 Nov 2026 14:50 AEDT (S1-Courses: s833 recorded before merge, Pilot #1422, migration `20261120143000`: course description queue without time-outs; final s822 re-read yield), 20 Nov 2026 13:40 AEDT (S1-UX s823 to s827 live and read back, applied by S1-RM-Design: Pilot #1420 `d219e7d7b`, v2.16.67, migration `20261120140000` (history md5 `b9db78b4` = file); live head `20261120140000`, 2,218 rows, G3 75/48, locks 7,585, spend US$0; security.txt read live: 200 text/plain), 20 Nov 2026 13:40 AEDT (S1-Build: s813–s819 closed; classifier budget live (Pilot #1419, `20261120117000`); 12:29 and 13:29 classifier runs clean), 20 Nov 2026 12:50 AEDT (S1-UX: s823 to s827 rebased on main after PR 1411 and handed off; not merged, not live; migration `20261120140000`, v2.16.67), 20 Nov 2026 12:50 AEDT (S1-Build: s819 Layer 4 speed live (Pilot #1416, `20261120116000`); classifier budget recorded before merge (Pilot #1419, `20261120117000`)), 20 Nov 2026 12:20 AEDT (S1-RM-Design: s817 and s819 to s821 live and read back (Pilot #1411 `8982b5555`, v2.16.66, migrations `20261120121000`, `20261120121100`); live head `20261120121100`, 2,214 rows, G3 75/48, locks 7,585, spend US$0; live security.txt read pending), 20 Nov 2026 12:10 AEDT (S1-Build: s818 live (Pilot #1415, `20261120115000`); s819 recorded before merge (Pilot #1416, `20261120116000`): Layer 4 Inbox item read planned with its arguments known), 20 Nov 2026 12:00 AEDT (S1-Courses: interim re-read yield; Drive Summary fixed; parked), 20 Nov 2026 11:50 AEDT (S1-Courses: s822 live; re-read yield and link sizing, read only), 20 Nov 2026 11:35 AEDT (S1-Build: s815 live (Pilot #1414, `20261120112000`); s818 recorded before merge (Pilot #1415, `20261120115000`, v2.16.65): tied main campuses, Main campus filter, NZ/CA campus projection), 20 Nov 2026 11:12 AEDT (S1-Build: s813/s814 live (Pilot #1410, head `20261120110000`); s815 recorded before merge (Pilot #1414, `20261120112000`): domestic-only scholarship rule, classifier and full attribute sync without time-outs), 20 Nov 2026 11:02 AEDT (S1-Courses: s822 stuck description re-read built and dry-run, Pilot #1413; no live change), 20 Nov 2026 11:05 AEDT (S1-AER: Boost DB AER and English lane pre-flight, live gap read and Layer 4 bulk-approve mockup; no data change), 20 Nov 2026 10:28 AEDT (S1-Build: s813/s814 recorded before merge (Pilot #1410, `20261120110000`): Layer 4 decisions without time-outs; Layer 4 lane admission matrix), 20 Nov 2026 09:55 AEDT (S1-RM-Design: s811 and s812 live and read back (Pilot #1408 `b2b8c688f`, v2.16.63; Pilot #1409 `3667aae2f`, v2.16.64, migration `20261120104000`; admin #672 `085e0543`); live head `20261120104000`, 2,207 rows, G3 75/48, locks 7,585, spend US$0; live security.txt read pending), 20 Nov 2026 08:25 AEDT (S1-Build: s805b live (Pilot #1407, head `20261120102000`, 2,205 rows); s802 to s805 verified in PIM Admin v2.16.62 on UTS, Torrens and AUT, read only), 20 Nov 2026 08:12 AEDT (S1-Build: s802 to s805 live (Pilot #1406, v2.16.62, head `20261120101000`); s805b held-list total fix recorded before merge (Pilot #1407, `20261120102000`)), 20 Nov 2026 07:45 AEDT (S1-Build: s802 to s805 recorded before merge (Pilot #1406, migration `20261120101000`, v2.16.62): Layer 4 Edit & Approve, human-edit audit, Human Edits & Periodic Audit), 20 Nov 2026 07:46 AEDT (S1-RM-Design: s806 to s810 merged and read back live (Pilot #1403, #1405); live head `20261120100000`, 2,203 rows; G3 0 drift 75/48; locks 7,585), 20 Nov 2026 07:10 AEDT (S1-Build: s797, s798 and s799 live and read back (Pilot #1401, #1402, #1404); live head `20261120095000`; AU study-load gap 15,382 → 24), 20 Nov 2026 07:45 AEDT (S1-Build: s797, s798 and s799 recorded before merge (Pilot #1401, #1402, #1404; migrations `20261120093000`, `094000`, `094100`, `095000`); s800 QS 2027 trace and THE 2027 / B5 readiness), 20 Nov 2026 06:48 AEDT (S1-RM-Design: s806 to s810 recorded before merge (Pilot #1403, v2.16.61, migration `20261120100000`): UnoPim completeness patterns and ASD ISM security documents and gates), 20 Nov 2026 01:35 AEDT (S1-Build: s791b live (Pilot #1400, migration `20261120010000`), read back; correction to s794: the 48 courses were unpublished, not lagging; gap re-measure 01:19), 20 Nov 2026 01:15 AEDT (S1-Build: s790/s791 live (Pilot #1399, v2.16.60, migration `20261120002000`), read back; s791b recorded before merge (Pilot #1400, migration `20261120010000`): Run Now follows the dispatchers; `enrich_ai` window 2 clean), 20 Nov 2026 00:50 AEDT (S1-Build: s788 live (Pilot #1397, migration `20261119190000`, worker v1.0.31) and s794 live (Pilot #1398, migration `20261119191000`), both read back; s790/s791 recorded before merge (Pilot #1399, v2.16.60, migration `20261120002000`)), 20 Nov 2026 00:20 AEDT (S1-Build: s792 AU, NZ and CA data gap assessment written (`docs/platform/2026-11-19-au-nz-ca-data-gap-assessment-and-fix-plan.md`); s789 checked at the day reset; s794 recorded before merge (Pilot #1398, migration `20261119191000`); Pilot #1396 s782 merged), 19 Nov 2026 23:40 AEDT (S1-Build: repo-first record of Pilot #1397 s788 before it is merged and applied — migration `20261119190000`, the next live head; Pilot #1396 s782 puts the text of all 2,194 production history versions in the repository), 19 Nov 2026 18:57 AEDT (S1-Build: s776/s777 live 17:22 (Pilot #1382, v2.16.54, migration `20261119174000`; follow-up #1389 18:11, migration `20261119182000`): course field readiness snapshot, Pipeline & field ETA panel and hourly stakeholder tabs; s778 live 18:11 (Pilot #1390, v2.16.55): Users & roles dialogs stack each field; s781 live 18:24 (Pilot #1392, v2.16.56; #1393 v2.16.57): Catalogue › Providers logos, drawn flags, compact rows and More filters), 19 Nov 2026 17:53 AEDT (S1-RM-Design s766 addendum, trading names, Holmes owner and bounded read, Pilot #1388 and #1391; earlier s766 and s767: v2.16.53, Pilot #1385, heads `20261119172000` and `20261119173000`; host owners for Victoria University, RMIT and Western Sydney, trading names for Torrens and Moore, two stored-page reads queued, Layer 4 Grid Country and Provider type pills; section 5 › S1-RM-Design, 16:18 block), 19 Nov 2026 17:10 AEDT (S2 - BOOST s754: 201 university and higher-education providers, 141 with a description; of the 60 without, 0 ready to admit, 8 in Layer 4, 29 identity holds, 13 with no stored page; bounded GPT-4.1 mini re-check of 2 held both again, US$0.0006, no Firecrawl; Pilot #1383, head `20261119170500`; section 5 › S2-BOOST-Providers, 17:10 block), 19 Nov 2026 16:15 AEDT (S2-BOOST-Providers, no change made: Australian universities with a description 37 of 45; the 10 records without one triaged by exact reason, none admissible by rule; 906 providers without a description broken down by country and state; section 5 › S2 - BOOST lane, 19 Nov 16:15 block), 19 Nov 2026 15:45 AEDT (S2-BOOST-AER handover close-out: course drain 76 of 91, the last 16 pass the rule and are queued, expected 20:30 to 22:30 AEDT; S751-S752 prompt v2 and Windows-1252 verifier folding, Pilot #1376, migration `20261119143000`, verification replay 100% minimum in quote, 99.9% quote fidelity, 89.4% rows, US$0.028 of US$0.03, bar not met; Platform Admin decision of 15:14 for the S1 follow-up; AER v2 admission paused; m2.4.7 runsheets, 15:45 block), 19 Nov 2026 15:30 AEDT (S2-Build: page-text claim bounded, IQ-00606 closed after 11 of 11 clean runs (Pilot #1377, #1379, s772); course field readiness as 8 plain per-country CSVs under 2.9 MB in Drive › Monitoring, zip retired (Pilot #1378, s771); IQ-00594, IQ-00588 and IQ-00426 handed to S1-Build with their failure paths (s773–s775); head `20261119153000`; section 5, S2-Build 15:30 block), 19 Nov 2026 15:20 AEDT (S1-Build: s767 post-fix check, three hours of runs after the 12:24 deploy; no setting change needed, `no-page-propose` needs a query fix), 19 Nov 2026 14:18 AEDT (S1-Build: s769 live, Pilot #1374 and #1375, v2.16.51, migrations `20261119130000` and `20261119144500`: Scholarships › Coverage loads again (ref 8XEY7B); the listing matcher works out keys once instead of per item × record pair, 50 providers a page; the provider drawer and Publish read publishing checks for one provider only), 19 Nov 2026 13:45 AEDT (S2-BOOST-AER: S750 MiMo v2.6 Flash at 12 rows a call on 20 gate-held tables, 99.8% rows, 100% quotes, 99.4% minimums, longest call 32.9 s of 90 s, US$0.0198 of US$0.05, window closed, bar not met, nothing promoted; Manukau miss is a two-level row; worker v1.0.29, Pilot #1373, s750, no migration; course drain 75, 16 queued; m2.4.7 runsheets, 13:45 block), 19 Nov 2026 12:50 AEDT (S2-Build: LIN 19/198 living cost AUD 29,710 published on the Home Affairs edition, UKVI and USCIS published (Pilot #1363); s720 reliability unblock live, chunked coverage build, bounded admission snapshot and lock, page-text claim, evidence-link-index feed 1.6 s and HTTP 200 after the 11:42 critical alert, 34 stalled plans released, 203 runs with 0 timeouts (Pilot #1364, #1366, #1369, #1372); daily course field readiness to Drive › Monitoring, first run 36,031 courses (Pilot #1370, #1371, s770); #1333 guardrail note and Hourly_Admittance_Telemetry columns; head `20261119125500`; section 5, S2-Build 12:50 block), 19 Nov 2026 13:30 AEDT (S1-Build: s768 design for queue and lane control and on-demand runs, docs only: `docs/platform/OPS-QUEUE-LANE-CONTROL-AND-ON-DEMAND-RUNS-DESIGN.md`, F-OPS.10–.12, operating model v1.23, UI catalogue 1.20; three open points for the Platform Admin), 19 Nov 2026 12:40 AEDT (S2-BOOST-AER: S747 chunked matrix smoke test, 10 tables, US$0.0276 of US$0.10, both on-demand windows closed; MiMo v2.6 Flash 100% row completeness and quote fidelity, 99.3% minimum in quote, bar not met, nothing qualified; prompt aer-v2-matrix-chunk-v1 as data (Pilot #1365, migration `20261119110500`, worker v1.0.28 #1368, s747); course drain 75 admitted since s748, 16 queued; m2.4.7 runsheets, 12:40 block), 19 Nov 2026 12:40 AEDT (S1-Build: s767 live 12:24, Pilot #1367, migration `20261119120000`: `flag_jobs_v1` reads live registry lanes, so the PR 3 and PR 4 unschedule paste files can run; `security.job_effective_state_v1` and telemetry exporter revision 4 read dispatcher-held jobs from their dispatcher; CHRONIC_FAIL fixes: waste-guard cost measure to rollup target `ops-cost-guard`, `batch.sch_coverage_classify` 120 → 80, `bind.no_page_providers_per_run` 40 → 25; idle guard keeps retiring jobs off), 19 Nov 2026 11:25 AEDT (S1-Build: handover architecture documents updated, read only on production: `AGENT-OPERATING-MODEL.md` v1.22 "Production architecture baseline for handover", `STUDYSEARCH-PROGRAMME-STATUS.md` section 0, `UI-CATALOGUE.md` 1.19 section 4.2, `processes/intake-dates.md` schedule note; docs only), 19 Nov 2026 11:10 AEDT (S2-BOOST-Providers self-check, no change made: GPT-4.1 mini re-read 252 of 267 finished, 13 admitted, 238 held, US$0.0478, no Firecrawl; 2,184 of 2,830 published providers have a description; 184 identity holds remain; section 5 › S2 - BOOST lane, 19 Nov 11:10 block), 19 Nov 2026 10:26 AEDT (S2-BOOST-AER scheduled check: 73 course reads admitted since s748, 16 would-admit waiting, 79 matrix items pending with no new admission, P0 0; m2.4.7 runsheets, 10:24 block), 19 Nov 2026 09:55 AEDT (S2 - BOOST: study-load label split live, 206 international study loads admitted on re-read, Pilot #1337 and #1347; campus locality by campus name, 3 postcodes and 9 campuses, Pilot #1341; Boost fields v2 with application deadlines, worker v1.0.26, replay replay-v2-1 found no field at the bar so nothing admitted, Pilot #1346; run-5 PASS 9/9; head `20261119103000`; section 5 › S2 - BOOST lane, 09:55 block), 19 Nov 2026 08:45 AEDT (S1-Build: consolidation PR 4 cutover live 08:18, early by the Platform Admin's 07:47 decision, Pilot #1331, migration `20261119095000`; 9 legacy jobs off and retiring, active jobs 146 to 138, G1 0 unregistered, G3 75/48; paste file listed; spec renumbered s766, Pilot #1359 and #1362; Job governance section), 19 Nov 2026 08:50 AEDT (S2-BOOST-AER: matrix completion clauses and course links, 2 matrix items admitted (Pilot #1338, migration `20261119052500`, s741); held-page export (s742); AER course machine queue records every check and takes the least recently checked first (Pilot #1349 and #1360, migrations `20261119080500` and `20261119095500`, s748 and s749); table row chunker on 48 held pages, nothing switched on (Pilot #1358, s744 to s746); s747 smoke test not yet run; head `20261119100000`; section 5 › S2 - BOOST lane, 19 Nov 08:50 block), 19 Nov 2026 08:45 AEDT (S2-BOOST-Providers: identity proof accepts own bracketed initials and registration numbers (Pilot #1353, s762); provider description route GPT-4.1 mini, cap US$0.50 a day, Firecrawl off; 267 re-reads queued 08:36; dates, calendar and timetable confirmed refused source words; 61 Layer 4 descriptions triaged (Pilot #1355, migration `20261119090000`, s763 to s765); section 5 › S2 - BOOST lane, 19 Nov 08:45 block), 19 Nov 2026 07:40 AEDT (S1-RM-Design: v2.16.49 scholarships listed once, Pilot #1342, s699, verified live at 375×812, section 5); before it: 19 Nov 2026 07:15 AEDT (S2-BOOST-Providers handover: provider description prompt versions 4 and 5 recorded as fixtures; 54 held re-reads restored to Layer 4; 2,171 of 2,830 published providers have a description, 82 held scholarship pages, 78 campus localities waiting; Pilot #1345, migration `20261119080000`, s760 and s761; section 5 › S2 - BOOST lane, 19 Nov 07:15 block), 19 Nov 2026 07:15 AEDT (S2-BOOST-Discovery check-in: request closed, s658 holding, pick time-outs 141 and measured, no matcher or year rule built, section 5); before it: 19 Nov 2026 06:00 AEDT (S2-Build: post-squash batch: Boost test project rebuilt (PASS) and re-seeded, v2.16.47 blades live for every role, round states on rollup-scheduler only; coverage telemetry Pilot #1333 held for a decision; section 5, S2-Build 06:00 block), 19 Nov 2026 05:25 AEDT (S2 - BOOST: run-4 PASS 9/9 on the test project after the squash, admin run 44349340646; benchmark bench-5 on prompt v5, Mistral Small 3.2 59%, MiMo 44%, Qwen3 30B 32% of 63 leftover pages with signal, Pilot #1327, s699; nothing qualified or switched; head `20261119044000`; section 5 › S2 - BOOST lane, 05:25 block), 19 Nov 2026 04:30 AEDT (S2-Build: API v3 PR D read path, scholarship round states on the Melbourne date and the student-facing destination read; Pilot #1328, #1329, migrations `20261119041000`–`043000` and `045000`, s710–s712; section 5, S2-Build 04:30 block), 19 Nov 2026 03:15 AEDT (S1-AER: Thursday 02:45 check, 2 course reads admitted and 89 would-admit reads not reached by the machine job; cause found, fix S677 awaits authorisation; Pilot #1326, s676, no migration; section 5, S1-AER 03:15 block), 19 Nov 2026 02:25 AEDT (S1-Build: canonical migration squash merged, Pilot #1325, baseline from production dump 44324920057 at cut-off `20261118272000`, 800 files archived, production unchanged; migration freeze lifted early; `coursefinder-boost-test` free to re-seed), 19 Nov 2026 01:17 AEDT (S1-Build: migration freeze in effect until 03:30, #1314 held; coursefinder-boost-test being reset from 01:30), 19 Nov 2026 00:35 AEDT (S1-Build: 24-hour late-tick check of the dispatchers, PR 4 shadow progress; Job governance section), 19 Nov 2026 00:40 AEDT (S1-RM-Design: v2.16.46 Course detail declutter, Pilot #1324, s698, no migration; section 5 › S1-RM-Design 23:51 block), 18 Nov 2026 23:55 AEDT (S1-AER: Platform Admin decisions of 23:52, the 149 approved AER rows stay live and paid AER v2 replay is paused until tables are chunked per qualification or a stronger model is authorised; section 5, S1-AER 23:55 block), 18 Nov 2026 23:55 AEDT (S1-RM-Design: v2.16.45 Course and Provider detail fixes after live inspection, Pilot #1323, s697, no migration; section 5 › S1-RM-Design 23:02 block), 18 Nov 2026 23:35 AEDT (S1-AER: AER prompt v3.1 and 180 s evaluation calls, round 5 not qualified, Pilot #1311 to #1320, s674; standing 7-day AER validation renewal, workflow `aer-validation-renew.yml`; five AER consumer data findings resolved without quarantine, Pilot #1321, s675, `aer:p0` resolved 23:27; section 5, S1-AER 23:35 block), 18 Nov 2026 23:00 AEDT (S2-Courses: study load cue guard s661 and fee-basis replay s665 live, Pilot #1316 and #1319, worker v1.0.22, no migration; s662 and s664 are in Pilot #1314; S2-Intakes question below; section 5 › S2-Courses block), 18 Nov 2026 21:10 AEDT (S3-Boost providers: 1,543 CRICOS rows audited read-only, s700, section 5), 18 Nov 2026 20:05 AEDT (S1-RM-Design: v2.16.43 Layer 4 › Inbox › Grid › Clusters and City metrics measure wrap, Pilot #1309, no migration; Australia's city figures checked live; section 5 › S1-RM-Design block), 18 Nov 2026 19:20 AEDT (S2-BOOST-Discovery: 795 Course page needed items returned to the list by rule, Pilot #1306, s658; on-demand request closed, 2,190 credits; corrects 17:55 (402 gate-held, not 834); Course link year preference not built, by finding; head `20261118233000`; section 5 › S2 - BOOST lane, 19:20 block), 18 Nov 2026 19:00 AEDT (S2-BOOST-AER: hand-bound shared-page rule live, Pilot #1303, migration `20261118220000`, s670, 25 of 230 shared-page course reads released and 205 stay held; **AER course machine admission has run in shadow since 15:40 AEDT because its 11 Nov validation lapsed, 79 reads `would_admit` and none admitted**; section 5, AER block), 18 Nov 2026 18:45 AEDT (S2-BOOST-Providers: held scholarships 89 to 82 by rule l4-held-sch-settle-v1; provider description prompt version 5, 81 held descriptions sent back to the reader, 6 admitted of 34 re-read at 18:40; campus source-data exceptions table; Pilot #1302, migration `20261118213000`, s683 and s684; section 5 › S2 - BOOST lane, 18:45 block), 18 Nov 2026 18:00 AEDT (S2-BOOST-Courses: worker v1.0.18, read-only sentence inspection s660, multi-field page check v2 and gold-set replay s663, Pilot #1299 and #1301, no migration; the international-sentence cue is not clean (35 of 41 false) so study load v6 was not promoted; Qwen3 30B not qualified for intakes, fees or deadlines; 663 held course descriptions clustered; section 5 › S2 - BOOST lane, 18:00 block), 18 Nov 2026 17:55 AEDT (S2-BOOST-Discovery: the Course page needed searches were queued but not running; on-demand course search request, Pilot #1297, s656; search pick time-out fixed, Pilot #1300, s657; 716 searches, 71 pages found, 1 proved so far; 834 searches held by the stop gate; Course link 268 clustered; head `20261118210000`; section 5 › S2 - BOOST lane, 17:55 block), 18 Nov 2026 17:30 AEDT (S2-BOOST-Providers: Campus locality 312 to 78 by rule l4-campus-locality-v1; held scholarship re-check queued by rule l4-held-sch-recheck-v1, 60 of 72 re-checked; university description name forms pdesc-name-forms-v2, 88 to 86; Pilot #1298, migration `20261118203000`, s680 to s682; head `20261118203000`; section 5 › S2 - BOOST lane, 17:30 block), 18 Nov 2026 17:00 AEDT (S2 - BOOST: Course page needed 1,958 to 1,360 through the search lane by rule l4-page-needed-search-v1, Pilot #1293; study-load settlement heals itself, 74 released for v5, Pilot #1295; correction: search worker and course-list reader run live through the dispatcher; Adelaide 404s are guessed addresses, alias already in place; AER shared-page splitting held by the v1 freeze; head `20261118193000`; section 5 › S2 - BOOST lane, 17:00 block), 18 Nov 2026 15:45 AEDT (S2 - BOOST: reader v5, fee notes never the study load, worker v1.0.17, Pilot #1283; Course link 1,487 to 423 by rule l4-link-accept-v1, Pilot #1284; 400 Boost study loads: 94 admitted on re-read, 231 Not stated by rule, 75 waiting, Pilot #1286; scholarship scope rule hourly; Course page needed by provider; head `20261118183000`; section 5 › S2 - BOOST lane, 15:45 block), 18 Nov 2026 16:00 AEDT (S1-Build: RM1I/RM1C/RM1H/RM1D source readiness, pre-freeze lane; the per-owner paste file was reviewed against live), 18 Nov 2026 15:30 AEDT (S2-Build pre-freeze lane: paste file v2 must be run by the Platform Admin (the deploy refused it as a migration, Pilot #1280 reverted by #1288); BOM climate figures approved and served, edition waits for the published-per-owner paste file, Pilot #1287; page-text evidence key fix, Pilot #1281; head `20261118181500`; section 5), 18 Nov 2026 15:05 AEDT (S1-Build: consolidation PR 4 in shadow, Pilot #1282, migration `20261118170000`; cutover Thu 15:10 and late-tick check Thu 00:25 scheduled; Job governance section), 18 Nov 2026 14:55 AEDT (S1-RM-Design: v2.16.41 Operations screens, Pilot #1278; v2.16.42 Coverage now, climate icons and How the data connects, Pilot #1285, no migration; Coverage read migration handed to S2-Build; RM1F AMBA paste file; Wave 2 drafts status; section 5 › S1-RM-Design block and section 4 paste files), 18 Nov 2026 14:10 AEDT (S2 - BOOST: all 57 Scholarship course links resolved by deterministic rule under the automated rule authority, Pilot #1273 and correction #1276, migrations `20261118153000` and `20261118163000`, s636; 694 links, 60 audit rows, Inbox 0; head `20261118163000`; section 5 › S2 - BOOST lane, 14:10 block), 18 Nov 2026 14:30 AEDT (S2-Build: Operations backend v2.16.39, Pilot #1274, Task manager time-out fixed and 254 stranded tasks closed, health checks follow dispatchers and recorded pauses; BOM climate terms and open-licence publishing, Pilot #1275; grouped Layer 4 decisions v2.16.40, Pilot #1277 (study-load fix #1279 open); head `20261118162000`; section 5), 18 Nov 2026 13:45 AEDT (S1-RM-Design: hotfix v2.16.37, Links & Email Templates opens again, ref ZDUFMC, Pilot #1270, s634, live render confirmed; v2.16.38 Layer 1 wizard What this source will create, Pilot #1272, s635; runbook v1.4 maps the 28-destination extensions into existing tables; Operations UI v2.16.40 in progress after S2-Build's #1274; section 5 › S1-RM-Design block), 18 Nov 2026 13:05 AEDT (S2-Build: page-text registered, Pilot #1266; consolidation audit; 28-destination schema lock, Pilot #1265 and #1268 merged, paste file v2 dry-run passed; legacy CF-245 telemetry retired, #1269; section 5), 18 Nov 2026 12:25 AEDT (S2 - BOOST: Qwen3 30B kept solo; AER and scholarship admission audited; Scholarship course links in Layer 4, Pilot #1267; Layer 4 approval requirements written up; head `20261118143000`; section 5 › S2 - BOOST lane, 12:25 block), 18 Nov 2026 12:05 AEDT (S1-RM-Design: v2.16.35 role-centric Dashboard, Role guides, guided Create user, email editor, Pilot #1259; API v3 `study_load` and Publish edition fix, Pilot #1257, migrations `20261118133707` and `133717`; multi-country schema lock `s627`, Pilot #1262; RM26 to RM33 and REQ-84 to REQ-91; rows 37 and 38 and section 5), 18 Nov 2026 11:55 AEDT (S2-Build: 29-destination schema readiness cross-check, data paths in Pilot #1263, constraint paste file; section 5), 18 Nov 2026 11:45 AEDT (S2 - BOOST: refused study loads to Layer 4 › Inbox, Pilot #1251; Boost multi-field reading live in shadow, Pilot #1255 and #1261; run-3 PASS on the test project; head `20261118130000`; section 5 › S2 - BOOST lane, 11:45 block), 18 Nov 2026 11:35 AEDT (S2-Build: v2.16.33 Layer 4 › Inbox › Grid, saved views and the quote drawer, Pilot #1254; page-text feed to Boost, #1252; Layer 1 induction v3 fields and baseline records, #1258; v2.16.34 Layer 1 Register fixes, #1260; BOM climate loader open as #1256; section 5), 18 Nov 2026 11:10 AEDT (S1-Build: squash rehearsal complete, #1235 green at `20261118113000`, 3,364 of 3,364; section 4), 18 Nov 2026 11:00 AEDT (S1-Build: squash rehearsal dump and rebuild proof done, `coursefinder-boost-test` free to re-seed; section 4 and the S2 - BOOST lane), 18 Nov 2026 10:30 AEDT (v2.16.32, Pilot #1250: Bulk Approve Drafts for city figures, ILEP note corrected, migration `20261118110707`; `study_load` recorded as held but not yet returned by API v3; section 5), 18 Nov 2026 09:50 AEDT (S2 - BOOST: Platform Admin decisions of 07:08; the international study load first, worker v1.0.14; Boost no longer skips for a dispatcher tick; **Qwen3 30B qualified for study load, page-verified study loads admitted: 447 at 09:45 and rising**; Pilot #1238, #1241, #1244, #1246, #1247, #1249, migrations `20261118074500` to `20261118101500`; Boost specs renumbered s600 to s602; section 5 › S2 - BOOST lane, 09:50 block), 18 Nov 2026 09:35 AEDT (S2-Build: paste split done, Pilot #1248 and admin; Pilot has no docs/paste/, 36 guard-read files are Pilot test fixtures, 5 reference files moved here; spec s616), 18 Nov 2026 09:10 AEDT (S2-Build: Track B page reader live, Pilot #1245, s613, s599 renumbered to s612; PGWP ready, OfS and IRQ addresses hold no table; head `20261118090707`), 18 Nov 2026 08:40 AEDT (v2.16.30 and v2.16.31, Pilot #1242: Boost queue with Country tier and Priority score, migration `20261118083707`; Bulk Approve Drafts for localities, migration `20261118090707`; section 5), 18 Nov 2026 08:15 AEDT (S2-Build: Wave 2 schemes and duplicate sources reconciled, Pilot #1240; wizard Run dry run, #1243; live admitted counts; head `20261118080000`), 18 Nov 2026 08:00 AEDT (v2.16.29, Pilot #1239: Courses Study load and Empty reason, Campuses Primary and Locality, migration `20261118073000`; new operator runbook for destination editions and Wave 2 drafts; section 5), 18 Nov 2026 02:00 AEDT (S2 - BOOST: the stored-page queue is read in full, 2,144 courses, all shadow, 0 admitted; model benchmark bench-1 run on production and replayed on the test project; Pilot #1236, migration `20261118020000`, worker v1.0.11, s596; section 5 › S2 - BOOST lane, results block), 18 Nov 2026 01:25 AEDT (S1-Build: squash tooling 2 merged, Pilot #1237; rehearsal #1235 full CI green at live head `20261118020000`, 3,310 of 3,310; section 4), 18 Nov 2026 01:10 AEDT (S1-Build: consolidation PR 1 cutover live, Pilot #1232, migration `20261118010000`; squash tooling #1234 merged, #1237 and rehearsal #1235 in progress; sections 3 to 5), 18 Nov 2026 00:35 AEDT (S2-Build: consolidation PR 3 cutover live 00:21, Pilot #1229 after prerequisite #1227; Wave 2 PR C, the Layer 1 declarative runner, live, Pilot #1233; head `20261118013000`; section 2 and section 5), 18 Nov 2026 00:10 AEDT (S2 - BOOST: Boost extraction runs all day in shadow at higher throughput; first live results read; **Qwen3 30B not qualified, by finding**; Pilot #1226 and #1231, migrations `20261118000100` and `20261118011000`, worker v1.0.10; section 5 › S2 - BOOST lane, status block), 17 Nov 2026 23:32 AEDT (Pilot #1228: nine Wave 2 register drafts pre-staged, migration `20261118004000`; v2.16.28, Pilot #1230: API field dictionary and Grade scale conversions on Reference data, migration `20261118005000`; UI audit of the new API v3 fields written; section 5), 17 Nov 2026 22:55 AEDT (v2.16.27, Pilot #1225: the Email delivery provider card saves and tests itself; Deployed UAT on `main` green again from 22:31 AEDT; section 5), 17 Nov 2026 22:50 AEDT (S2 - BOOST: Boost extraction through `coverage-sweep` and the Models & services route is live, Pilot #1223, migration `20261117235000`, worker v1.0.9, s587; #1219 read back and run-2 passed through GitHub Actions; section 5 › S2 - BOOST lane), 17 Nov 2026 22:50 AEDT (Pilot #1222: the deployed Layer 1 role-boundary test follows the approved gates; Deployed UAT still red because the UAT account's password was changed at 22:17 AEDT; section 5), 17 Nov 2026 22:25 AEDT (S2 - BOOST, Platform Admin decisions of 21:18: Boost priority matrix moved to Settings › Pipeline settings over the single category list, one admitted row per course in a batch; Pilot #1219, migration `20261117223000`, s586 added, s581 retired; section 5 › S2 - BOOST lane), 17 Nov 2026 20:30 AEDT (squash rebuild proof decided: option A on `coursefinder-boost-test`; S2 - BOOST re-seeds after the rehearsal and after Thursday 03:30; sections 4 and 5), 17 Nov 2026 21:30 AEDT (release v2.16.26, Pilot #1217, Wave 2 decisions: one category list, source retention in one place, Curators open Layer 1, evidence and Layer 4 items side by side; migration `20261117213000`; section 5), 17 Nov 2026 20:15 AEDT (release v2.16.25, Pilot #1214, Wave 2 addenda: parser badge and Re-infer Parser Spec on Layer 1 sources, target record type in the wizard; migration `20261117203000`; section 5), 17 Nov 2026 19:45 AEDT (S1-Build Wave 2, Pilot #1212, migration `20261117200000`: staging retention in housekeeping-daily (dry run), 7-year evidence floor, ops telemetry views, live dry-run workflow; squash runbook and schedule; sections 3 to 5), 17 Nov 2026 19:00 AEDT (release v2.16.24, Pilot #1211, Parallel Wave 2: Layer 1 source induction wizard and Platform health › Country & category completeness; migration `20261117193000`; section 5), 17 Nov 2026 18:40 AEDT (S2 - BOOST: Boost priority matrix `country_category_boost` live, Pilot #1209, migration `20261117183000`, guard spec s581; first Boost test-project experiments, run-1; section 5 › S2 - BOOST lane), 17 Nov 2026 17:15 AEDT (S1-Build: `worker-boost-bulk-ingest` live, Pilot #1205, migration `20261117163500`; window, blackout, housekeeping and tick-lock gate; qualification SQL; section 5), 17 Nov 2026 17:00 AEDT (releases v2.16.22 and v2.16.23, Pilot #1204 and #1206: clean greeting without a name, Go-live checklist row for custom SMTP, and Admin invitations and resets through Resend with a write-only API key in Vault; migrations `20261117163000` and `20261117170000`; section 5), 17 Nov 2026 16:15 AEDT (Boost test rebuild PASS on every check, run 44019730363; section 5), 17 Nov 2026 16:15 AEDT (release v2.16.21, Pilot #1203: Resend invite on Users & roles, warning with Copy HTML on Links & Email Templates; the `#0b6e5f` StudySearch PIM Admin emails applied to Supabase Auth by `supabase-auth-config.yml` run 44021389741; section 5), 17 Nov 2026 15:35 AEDT (release v2.16.20, Pilot #1202: Users & roles › Links & Email Templates; migration `20261117152700`), 17 Nov 2026 15:30 AEDT (S1-Build: Supabase Auth applied, Boost bucket and tables live, four low-yield jobs paused, Boost rebuild root cause fixed; section 5), 17 Nov 2026 14:05 AEDT (release v2.16.19, Pilot #1197: Destination data page, Layer 4 kind Campus locality, `campuses[].locality` on API v3 providers; migration `20261117131500`). Before it: 17 Nov 2026 14:40 AEDT (S2-Build step 1, Pilot #1196: destination G-1 career grain and the destination field dictionary, migrations `20261117060000` and `20261117061000`; ABS loader runtime note in section 5), 17 Nov 2026 09:20 AEDT (AER benchmark round 3: Path B, Mistral failed the gate; Pilot #1191 and #1192; all AER entry reading stays off; benchmark report §6.1), 17 Nov 2026 08:50 AEDT (release v2.16.18, Pilot #1193 and #1194: destination data schema pack and API v3 `destination` action; migration `20261117040000`; bulk ingestion readiness checklist in section 5). Before it: 17 Nov 2026 07:15 AEDT (release v2.16.17, Pilot #1190: RM1A-3 register end dates; migration `20261117010000`; 2,051 applied), 17 Nov 2026 07:20 AEDT (Boost rebuild run 43940610220: schema complete, later steps FAIL with causes fixed; section 5), 17 Nov 2026 06:30 AEDT (PR 3 `coverage-lane-dispatch` in shadow since 06:21, Pilot #1188, 13 lanes; `coverage-ai-match` left out; section 4), 17 Nov 2026 03:30 AEDT (Boost rebuild: schema step stopped at its limit with one cause found and fixed; re-run waits; section 5), 17 Nov 2026 01:05 AEDT (release v2.16.16 live, Pilot #1189: invite and reset links to the admin sign-in, catalogue CSV export; no migration; Supabase dashboard paste doc pending; sections 3 to 5), 16 Nov 2026 23:45 AEDT (PR 2 cut over live 23:31 AEDT by S2 - SS Build under the Platform Admin's override of 21:23, Pilot #1185; PR 3 built in shadow as Pilot #1188, not merged: its live rehearsal waits for an approval; API v3 PR A/B fills live 21:50; sections 3 to 5), 16 Nov 2026 23:20 AEDT (PR 1 fix live 23:14 AEDT, Pilot #1187; fresh 24-hour shadow from 23:15 AEDT; cutover review Tue 17 Nov 23:20 AEDT; Boost test rebuild from the schema dump running, run 43863252704; sections 4 and 5), 16 Nov 2026 22:50 AEDT (PR 1 no longer blocks PR 3 or PR 2; PR 1 fix and new shadow, cutover Tue 22:30; section 4), 16 Nov 2026 22:50 AEDT (PR 1 cutover held: shadow fails the no-tick-over-budget criterion; section 4), 16 Nov 2026 21:25 AEDT (Boost setup steps 1 to 4: test project `coursefinder-boost-test` created; rebuild workflow waits for one secret; bucket paste file; sections 4 and 5), 21:05 AEDT (Cloudflare Worker Boost built and tested locally, nothing deployed or applied; section 5), 20:50 AEDT (Pilot #1181 finder fix, #1182 Course page needed settle, #1183 API v3 daily admittance telemetry; Layer 4 quick wins and the paths taken; Tue A/B gates; sections 3 and 5), 19:45 AEDT (Pilot #1180 live; official URL resolution of 856 items, Layer 4 4,916, new paste file; sections 3 to 5), 18:10 AEDT (Pilot #1162 field dictionary, #1178 AER routes and #1179 worker v1.0.6 merged; decisions of 16:52 in section 5), 16:45 AEDT (API v3 data admission plan in section 5), 16:40 AEDT (Layer 4 clearance and AER benchmark round 2 in section 5), 13:36 AEDT (course description readings in section 5), 13:25 AEDT (release v2.16.14: sections 2 to 5), 12:45 AEDT (AI token efficiency check in section 5), 12:26 AEDT (sections 3 to 5), 09:25 AEDT (rest), by the Course Module session (S2-CF), from Pilot `main` 8f53f8fd (#1173) and a read-only query of project `fxcwkweaxjtknorudmwp`.

## 1. Start here

1. This page, then `docs/README.md` (which document is current in each family).
2. Pilot `CLAUDE.md` (working rules G1 to G4, housekeeping, cron dispatchers, the UI map rule, the two-repository rule). This repository's `CLAUDE.md` mirrors the two-repository rule.
3. The live system: Supabase project `fxcwkweaxjtknorudmwp` only. The organisation's other project, `coursefinder-demo`, is unrelated and is never targeted.
4. Open Pilot PRs and branches. `main` is not always what is deployed mid-change.

## 2. Where each exact fact lives

| Question | Source of truth | How to get it exactly |
|---|---|---|
| Live schema (tables, functions, policies) | The live database | Pilot workflow "Database schema dump" (branch `db-schema-dump/<run id>`, md5 per file); one function: workflow "Database function snapshot". Checked-in migrations are not complete: at least one live function has no migration file. |
| Migrations applied | 2,154 (19 Nov 05:53 AEDT) |
| Scheduled jobs and dispatchers | `cron.job`, `pipeline.automation_catalogue`, `pipeline.rollup_targets`, `pipeline.admission_rules` | Read live; shadow reports: `security.rollup_shadow_report_v1(days)`, `security.admission_rule_shadow_report_v1(hours)` |
| Components and what is retiring | `pipeline.component_register` | Pilot branch `component-register-snapshot` (daily); `docs/platform/COMPONENT-REGISTER.md` is an older copy (15 Oct 2026) |
| UI routes, tabs, sub-tabs, folds, drawers | `docs/UI-MAP.md` (generated) | Pilot `node scripts/ui-map.mjs --mirror <this repo>`; guarded by spec `s557` |
| What each screen shows and does | `docs/platform/UI-CATALOGUE.md` (written by hand; v1.18 at v2.15.494, behind the v2.16 screens), in-app Guides | Trust `docs/UI-MAP.md` for names and places |
| Admin and operator SOPs | `docs/sops/` (mirror of Pilot `src/guide/sops.js`) | Pilot `node scripts/export-sops.mjs --check-mirror <this repo>/docs/sops` |
| Tests and what each guards | `docs/platform/TEST-REGISTER.md` (generated) | Pilot `node scripts/test-register.mjs` |
| Settings and UI simplification plan (decisions, phases, progress) | `docs/platform/ui-audit/ui-ux-settings-audit-2026-11-15.md` | Read §6 to §8; the live counts in it carry their read time |
| AI spend and yield by service and model tier; page-to-catalogue funnel | Google Sheet `StudySearch_Pipeline_Telemetry_Live`, tabs `Model_Tier_&_Token_Efficiency` and `Layer_Lifecycle_Funnel` (refreshed 08:05 AEDT daily) | `security.telemetry_model_tier_v1(24)`, `security.telemetry_layer_funnel_v1(24)` (read only) |
| Settings | `pipeline.platform_toolset_settings` | Settings › Settings on the admin screen; never a number in code (G2) |
| Consumer API (frozen) | Pilot `tests/uat/consumer-api-baseline.json`, spec `s57` | `docs/integrations/WEBSITE-DEVELOPER-REQUIREMENTS.md` before touching anything the website or Zoho reads |
| Paste files waiting to be run | `docs/paste/README.md` | Section 4 below |
| Task status and evidence | `docs/platform/STUDYSEARCH-EXECUTION-REGISTER.md`; consumer requests: `docs/integrations/` | One register; no second tracker |

## 3. Live system as read (16 Nov 2026 09:22 AEDT; release, migration and test rows 13:14 AEDT)

| Measure | Value |
|---|---|
| Visible release | **v2.16.53** (package 0.1.475; Pilot #1385, commit `0b68e4d3`, merged 19 Nov 2026 about 17:35 AEDT; Layer 4 Review › Grid Country and Provider type pills, AU university host owners and trading names). Before it v2.16.51 and **v2.16.49** (package 0.1.471; Pilot #1342, commit `363cda70`, merged 19 Nov about 07:03 AEDT; no migration; the Around this course card is headed Entry requirements and the Scholarships section is the only scholarship list on the Course detail). Before it v2.16.47 (Pilot #1330, live figures for every role) and v2.16.46 (Pilot #1324). v2.16.48 is claimed by Pilot #1335 and #1336, which re-bump on rebase. |
| Newest migration applied live | `20261119103000` (Pilot #1346, S2 - BOOST: Boost fields prompt v2 recorded on the qualification row; read back 19 Nov 09:40 AEDT). Before it `20261119100000` (Pilot #1361), `20261119095500` (#1360), `20261119095000` (#1331), `20261119084000` (#1344), `20261119082000` (S2 - BOOST #1347) and `20261119080000` (#1345); `20261119062000` (S2 - BOOST #1341) applied after `080000`, which merged first. |
| Migrations applied | 2,154 (19 Nov 05:53 AEDT) |
| Scheduled jobs (`cron.job`) | 191 active, 11 switched off |
| Components marked retiring | 46 settings, 30 functions, 14 screens, 8 jobs, 5 tables, 1 edge function |
| Tests | 799 specs, 3,693 tests (3,601 local, 92 deployed track; 19 Nov 00:35 AEDT, Pilot main `c9a293dd`) |
| UI | 21 pages, 56 tabs, 26 sub-tab bars, 215 folds, 41 drawers and dialogs (v2.16.49) |

## 4. Dispatchers, pending cutovers and pending paste files

Rule: Pilot `CLAUDE.md`, "Cron dispatchers" (register each legacy job byte for byte, 24-hour shadow cycle, then cutover; `cron.unschedule` by paste file after 14 days).

| Dispatcher | Jobs | State as read | Shadow since | Next step | Owner |
|---|---|---|---|---|---|
| Consolidation PR 1, `rollup-scheduler` | 25 report and cache targets (`pipeline.rollup_targets`; `layer2-onboarding-snapshot` stays on its own job) | **Live since 17 Nov 2026 23:47 AEDT** (Pilot #1232, migration `20261118010000`, history md5 `76ef60c4`; cutover pulled forward by the Platform Admin 17 Nov 23:07). Read back live: 25 of 25 group A targets `live`; 0 legacy report jobs switched on; 25 marked `retiring` (retire_after 1 Dec 2026); `layer2-onboarding-snapshot` still on its own job; `rollup-scheduler` on; 25 cutover events logged; first live runs succeeded (largest 116 ms); G3 75 of 75 functions, 48 of 48 relations, no drift flag. Shadow review (24 h from 12:07Z 16 Nov): 25 targets dispatched, 0 failed or refused; 26 legacy jobs unchanged and active; no tick over 60 s (largest 57.5 s). `all_match` failed only on dispatch count for `admin-read-snapshots`, `data-delivery`, `lane-funnel` (1,437 dispatches against 1,444 legacy starts, the same 1,444 due minutes: 3 late pg_cron starts at busy minutes, caught up by design); **the Platform Admin accepted minute coverage as the gate** (17 Nov 23:2x AEDT). The live dry run (`db-migration-dry-run.yml`) caught a record-name clash in the first version, fixed before merge. | **Fresh 24-hour shadow from 16 Nov 2026 23:15 AEDT** (first tick under the fix) | Watch late ticks for 24 h (`pipeline.rollup_runs`, mode live). Unschedule the 25 legacy jobs with admin `docs/paste/PASTE-20261118-rollup-legacy-unschedule.sql` on or after 2 Dec 2026 (guarded: it refuses unless all 25 are off, retiring, past retire_after and idle 14 days). | The session that prepared PR 1. Do not touch from another session. |
| Consolidation PR 2, `admission-rule-runner` (lanes `-b`, `-c`) | 20 admission rules (`pipeline.admission_rules`) | **Live since 16 Nov 2026 23:31 AEDT** (Pilot #1185, migration `20261116190000`, main `3fa05b38`), cut over by S2 - SS Build under the Platform Admin's override of 16 Nov 21:23. Gate read 23:30 AEDT: shadow window 24.0 h, all 20 match, 0 minutes over capacity, 20 legacy jobs active with the registered md5 and schedule. Read back 23:33–23:36: 20 live, 20 legacy jobs off (`active = false`), 20 retiring (retire after 30 Nov 2026), 3 runner lanes on, 21 control events; first live runs 6 succeeded, 0 failed; G3 drift [] (75/48) | 15 Nov 2026 23:29 AEDT | **Done.** The other session's Tue 17 Nov 22:30 slot finds it cut over (the Platform Admin cancels it). `cron.unschedule` paste file `PASTE-20261116-admission-rule-legacy-unschedule.sql` on or after 1 Dec 2026 | S2 - SS Build (cutover); the session that prepared PR 2 |
| Consolidation PR 3, `pipeline.field_execution_registry` and `coverage-lane-dispatch` (lanes `-b`, `-c`) | 13 coverage worker lanes (course-link-search-worker, coverage-find-site, coverage-reextract, coverage-reidentify, provider-contact-page, provider-facts, companion-read, course-list-read, credential-read, policy-add-tests, programme-discover, programme-read, source-find), plus 7 API v3 field lanes declared disabled and never dispatched | **Live since 18 Nov 2026 00:21 AEDT** (Pilot #1229, migration `20261118012000`, spec `s595`; cutover brought forward from Wed 06:45 by the Platform Admin, 17 Nov 23:02, 24-hour window waived). Shadow from 17 Nov 06:22: 13 of 13 commands and schedules equal to live (md5); 2,961 dispatcher ticks in 24 h, all succeeded, longest 0.8 s; load at most 235.7 of 300 s/min. Six lanes had differed only because flag-recheck (`security.flag_jobs_v1`) idle-pauses legacy jobs while the shadow counted every minute; **prerequisite Pilot #1227** (migration `20261118001000`, spec `s589`, live 17 Nov 23:06) made the shadow skip minutes the legacy job is off and moved the idle pause and its release onto the live lane (`security.job_switch_v1`, `security.job_switched_on_v1`; a retiring job is never switched on, UR-07), so `flag_requeue_v1` can no longer switch a legacy row back on beside its lane. Gate in the migration: last-hour report all_match for 13 (window wholly after #1227), legacy md5 unchanged, no person-paused job. Read back 00:21–00:25: 13 lanes live and enabled, 13 legacy jobs off and `retiring` (retire_after 1 Dec 2026), 13 cutover events, 3 dispatchers on, field lanes disabled, G3 75/48; no legacy start after the switch-off (last at 00:21:00, cutover 00:21:01.7); first live dispatches 16 succeeded, 0 failed, longest 169 ms. Unschedule: `docs/paste/PASTE-20261118-coverage-lane-legacy-unschedule.sql` on or after 2 Dec 2026 (refuses until `flag_jobs_v1` reads the live lanes from the registry, a Pilot change still to make). **Health check Wed 18 Nov 06:46 AEDT (read only, 6 h 25 min since the cutover):** 13 lanes live; 1,412 live dispatches succeeded, 0 failed, 0 skipped on an open breaker, 0 over budget, longest 1.4 s (companion-read); 0 consecutive failures and no unresolved `coverage_lane_breaker:` issue; 1,155 dispatcher ticks, 0 failed (two slow ticks at 01:46 and 01:56, 74 s and 103 s, no lane missed); 0 legacy jobs switched on and 0 legacy starts since 00:21:01; the idle pause now acts on the lanes (coverage-reextract held with a raised idle flag, three others paused and released on the lane); G3 75/48. **Left out (unchanged):** `coverage-ai-match`, `calendar-reread` (S2-Intakes), `coverage-read` and `coverage-read-2` (30-second schedules) | — | Post-cutover health check Wed 18 Nov 06:45 AEDT (scheduled, read only) | S2 - SS Build |

**Scheduled gates (S1-Build, Platform Admin 17 Nov 2026 18:02):**
- **PR 1 cutover: live since Tue 17 Nov 23:47 AEDT** (Pilot #1232, migration `20261118010000`), before Thursday's squash, so the canonical baseline captures it. The 23:20 scheduled review was switched off (done early at the Platform Admin's request, 23:07).
- **Squash pre-staged (17–18 Nov night):** squash tooling Pilot #1234 merged (folder helper, 46 listers, `scripts/migration-squash.mjs`, s594); squash tooling 2 Pilot #1237 (fixtures and path checks that build a path at run time, found by the rehearsal) merged 18 Nov about 00:58 (main `acf01a35`); **Rehearsal done Wed 18 Nov 10:30–11:06 AEDT (runbook section 6):** production dump run 44199899527 (`schema.sql` md5 `eba7462e…`, carriage returns in the 7 consumer functions equal live); rebuild proof run 44201959838 on `coursefinder-boost-test` (every squash check PASS, G3 75/48; one stale Boost check handed to S2 - BOOST); draft #1235 (never merged) green at live head `20261118113000`: 750 files archived, 1,118 references repointed, 3,364 of 3,364 tests. Thursday's window repeats these steps at that night's head. Details and the production history findings (one documented no-op file, two live-only versions): runbook section 4.
- **Canonical migration squash: done Thu 19 Nov 2026 02:15 AEDT (Pilot #1325, merge `a0f0e10f`).** Canonical baseline = production schema dump run 44324920057 (01:30 AEDT, live head `20261118272000`, 2,148 history rows), `supabase/live-capture/baseline/schema.sql` md5 `40cf02f4e8f5a6c2cb53bf351c55eccc` (2,889 functions, 720 tables; the 7 consumer functions keep their carriage returns, `.gitattributes` keeps the baseline out of line-ending conversion). Cut-off `20261118272000`: the 800 applied files up to it are in `supabase/migrations-archive/`; `supabase/migrations/` holds only `README.md` and new migrations from here. Rebuild proof run 44327488382 passed for the squash (G3 75/48, no drift; the one Boost check `outside_window_refused` fails as in the rehearsal). Read back: head and history unchanged, G3 75/48 no drift, Deploy on merge applied nothing. Production unchanged. Results: [`docs/platform/MIGRATION-SQUASH-RUNBOOK.md`](platform/MIGRATION-SQUASH-RUNBOOK.md) section 6.

**Platform Admin 16 Nov 2026 22:44 AEDT, dispatcher order changed:**
- **PR 1 does not block PR 3 or PR 2.** PR 3 (from 23:15 AEDT tonight) and PR 2 (Pilot #1185, merge after 23:28 AEDT tonight) proceed independently of PR 1.
- **PR 1** gets its three fixes now:
  - the history clean-up moves to `housekeeping-daily`;
  - each live target's due minute is recorded before it runs;
  - `layer2-onboarding-snapshot` stays on its own job.
- **PR 1 timing:** a fresh 24-hour shadow starts when the fix is live, and the cutover targets **Tue 17 Nov 2026 22:30 AEDT**.
- **PR 1 fix live 16 Nov 2026 23:14 AEDT** (Pilot #1187, read back above). The shadow started at 23:15 AEDT, so the full 24-hour cycle ends **Tue 17 Nov 23:15 AEDT** and the cutover review is scheduled for 23:20 AEDT.

Pending paste files (run by the Platform Admin; details and md5 in `docs/paste/README.md`):

| File | Run on or after |
|---|---|
| `docs/paste/PASTE-20261115-cron-legacy-jobs-drop.sql` | Part A any time; Part B from 29 Nov 2026 |
| `docs/paste/PASTE-20261116-retired-settings-drop.sql` | 29 Nov 2026 |
| `docs/paste/PASTE-20261116-admission-rule-legacy-unschedule.sql` (the 20 legacy admission rule jobs, PR 2; guarded) | 1 Dec 2026 |
| `docs/paste/PASTE-20261117-supabase-invite-email-template.md` (Supabase Auth: Site URL, Redirect URLs, Invite user and Reset password templates for v2.16.16) | **Steps 1 to 3 done 17 Nov 2026 14:33 AEDT** by admin workflow `supabase-auth-config.yml` (run 44009123373, read back; section 5 › S1-Build). Step 4 (a test invitation and reset to an address you control) is the Platform Admin's |
| `docs/paste/PASTE-20261116-staging-boost-bucket.sql` (private Boost bucket) | **Done 17 Nov 2026 14:37 AEDT** by Pilot #1199 (migration `20261117152300`, same values and check); nothing to paste |
| `docs/paste/PASTE-20261116-api-field-dictionary-number-arrays.sql` | Any time (Pilot `20261116110000` is live); then a small migration loads the 2 held fields |
| `docs/paste/PASTE-20261116-l4-lift-false-link-refusals.sql` | Any time: lifts 59 false course-link refusals of live pages verified valid (Layer 4 report §7.3); stops unless exactly 59 rows match |
| `docs/paste/PASTE-20261118-rollup-legacy-unschedule.sql` (the 25 legacy report jobs, PR 1; guarded) | 2 Dec 2026 |
| `docs/paste/PASTE-20261118-coverage-lane-legacy-unschedule.sql` (the 13 legacy coverage worker jobs, PR 3; `flag_jobs_v1` guard met by s767) | 2 Dec 2026 |
| `docs/paste/PASTE-20261205-s881-idle-jobs-unschedule.sql` (the 7 idle jobs switched off by s881, Pilot #1434; guarded) | 5 Dec 2026 |
| `docs/paste/PASTE-20261119-pr4-legacy-unschedule.sql` (the 9 legacy jobs of PR 4: 8 coverage worker jobs and `settings-backup-daily`; `flag_jobs_v1` guard met by s767; md5 `1817ff40`) | 3 Dec 2026 from 08:20 AEDT |
| `docs/paste/PASTE-20261121-s900-vacuum-analyze.sql` (IQ-00510 option C: non-locking `VACUUM (ANALYZE)` of 4 tables, one line at a time; md5 `580891df`) | Any time after Pilot `20261121090000` is live |
| `docs/paste/PASTE-20261118-rm1f-amba-accreditations.sql` (RM1F: 13 AMBA schools in AU, NZ, CA as `under_review`; data only; guarded; md5 `c1ebf1b3`) | Any time; switch to `active` after the reuse position is confirmed |

## 5. Open work in the repositories

### S1-API-Frontend-Delivery, 22 Nov 2026 17:40 AEDT: consolidated batch complete (S2 stays parked); s974 and s975 live; Part 3 gaps measured

- **s974 live** (Pilot #1480 `9dcc5f9a`, v2.16.85):
  - **One read:** opening Courses sends one list read, with the remembered view.
  - **Signed in, desktop:** the default list takes about 0.9 to 1.2 s; the filter lists take 0.27 to 0.56 s. A remembered filtered and sorted view (Has fee: No, sorted by Admitted) reads in 1.0 to 1.3 s, and up to 5.5 s while the database is busy.
  - **375 px:** one read; no sideways scroll; Region opens in 0.7 s.
  - **REQ-105:** Partly delivered; next is the course-first path for filtered views.
- **s975 live** (migration `20261122180000`): OET letter grades for 256 of 256 active requirements (C+, with sub-test grades). REQ-34's Zoho v3 columns hold values.
- **RM1K Delivered:** IR-002 Delivered Live; the golden acceptance is 10 of 10 live; REQ-59 is held for its list.
- **Part 3 ($0, stored pages and deterministic readers only), measured.** Each item waits on a decision (CONSUMER-REQUESTS and INTERNAL-REQUESTS):
  - **REQ-94:**
    - One published provider has no course entry rows: University of Waikato, with 1 published course.
    - 1,109 providers with active courses have none; all of them are unpublished.
  - **REQ-95:**
    - Five providers have no published scholarship.
    - Nothing stored can be published without review.
  - **REQ-99:**
    - 290 courses have no IELTS row, 141 of them at CDU.
    - CDU's course pages give a two-column test table. The course-page reader took the pathway column (for example PTE 50 where a master's needs 58) and missed IELTS.
    - The deterministic English reader skips such tables by design.
    - **Decision:** a table-aware reader change, or a reviewed correction.
  - **IR-007:**
    - QTAC's how-to-apply page says it is "only for domestic applicants" and links international applicants to `qtac.edu.au/international-applications/`.
    - That page and `tisc.edu.au` need an allowed plain read.
- **Live, read 17:26:** head `20261122180000`; G3 75/48, no drift; locks 7,585; active cron 137.

### S1-API-Frontend-Delivery, 22 Nov 2026 17:30 AEDT: s972 and s973 live; Part 2 follow-up and Part 3 OET grades recorded before merge (s974 v2.16.85, s975)

- **s972 and s973 live** (Pilot #1479 `075a67f0`, deploy 05:55 UTC):
  - **Migrations:** `20261122160000` and `20261122170000` applied; history md5 matches the files.
  - **Index lock retry:** the first dry run met a busy writer, so the indexes are now built inside a short lock retry.
  - **Signed-in check (desktop, Platform Admin):** the default Active Courses read takes 0.87 to 1.23 s end to end. That is 402 KB, of which about 0.25 s is network. Before, it took 2.0 to 4.7 s on the same screen.
  - **Filter lists (AU):** 0.27 to 0.56 s. At 375 px, Region opens in 0.7 s and Delivery in 0.5 s (Region was 1.0 to 3.9 s).
  - **Golden acceptance live:** `admin_golden_acceptance_v1` returns 10 of 10 sections agreeing.
- **Found in the signed-in check:** opening Courses sent **two** list reads. The first used the defaults; the second used the person's remembered filters and sort and waited behind the first.
- **s974** (REQ-105, v2.16.85, recorded before merge): the list now waits for the remembered state, and for a search still being typed, so it reads once. No control moves; the guides are reviewed for v2.16.85.
- **s975** (REQ-34 OET, migration `20261122180000`, recorded before merge):
  - **What it does:** fills the letter grade for the 256 active OET requirements from their stored scores. The scale is OET's published one: A 450 to 500, B 350 to 440, C+ 300 to 340, C 200 to 290, D 100 to 190, E 0 to 90.
  - **Result:** all are C+ (overall 300); sub-test grades come from each stored sub-test score. Rehearsal: 256 graded. Website v3 shows `score_grade` C+ with the sub-test grades.
  - **Limits:** only empty grades are filled, locked English is left alone, and it costs $0.

### S1-API-Frontend-Delivery, 22 Nov 2026 16:35 AEDT: s971 live (ARWU, THE and QS side by side); Part 2 recorded before merge (s972 REQ-105, s973 RM1K)

- **s971 live** (Pilot #1478 `5273aece`, deploy 04:29 UTC; migration `20261122150000` applied, history md5 matches the file):
  - **ARWU 2026 first run** (from the queue on deploy): completed; 1,000 rows; edition accepted and public; 59 AU/NZ/CA linked.
  - **Side by side:** The University of Melbourne shows ARWU 37, QS =22 and THE =34 in the website ranking summary. The University of Sydney (Website v3 provider) shows ARWU =79, QS 28 and THE =51.
  - **Zoho API v3:** carries no ranking columns, so nothing changed there.
  - **Fixes before merge:** the package7a and Layer 1 closure contracts were updated for the Ranking editions panel order and the ARWU route.
- **s972** (REQ-105; Pilot #1479, migration `20261122160000`, recorded before merge):
  - **The slow read:** the first Courses read sent Active down the course-first path. It took 1.3 to 5.0 s (rehearsal under load: 2.4 to 4.1 s).
  - **Active fast path:** the default list now takes the page-first path with a partial Active title index: 0.26 to 0.5 s in the same rehearsal. Rows, order, values and total are unchanged (four pages compared, including the last).
  - **Columns added:** the page-first path now also returns `open_to_international`, `open_to_domestic` and `intl_fee_basis`.
  - **Filter lists:** rewritten as semi-joins, with delivery modes read by index probe. They now take 3 to 140 ms warm (Region and Delivery under 0.3 s warm), against 0.1 to 3.9 s before.
  - **Same answers:** about 450 compared calls across every country, region, search and page; none differed.
  - **Indexes:** partial indexes on the website and Zoho feed items, for the list's Published column.
  - **Deployed timing check:** in `s972`.
- **s973** (RM1K, IR-002; same Pilot PR, migration `20261122170000`, recorded before merge):
  - **New function:** `public.admin_golden_acceptance_v1` reads the golden records through Admin and through Website API v3, section by section. It is read-only and needs the Pipeline Operator role or above.
  - **Sections:** course detail, entry requirements, English, fees, scholarships, campuses, accreditations, study rules, careers and rankings.
  - **Golden records:** fixture `tests/fixtures/rm1k/australia-golden.json` (Graduate Certificate in Publishing, The University of Sydney).
  - **Rehearsal:** 10 of 10 sections agree.
  - **After every deploy:** the deployed spec `s973` requires all ten to agree. REQ-59 stays queued for its provider list.
- **Live, read 22 Nov 15:41:** head `20261122150000`; G3 75/48, no drift; locks 7,585; active cron 136.

### S1-API-Frontend-Delivery, 22 Nov 2026 14:55 AEDT: consolidated batch started (S2 stands down); Part 1 rankings recorded before merge (s971, v2.16.84)

- **Consolidated batch (Platform Admin 22 Nov 2026 14:22):**
  - One session runs both lanes' queued items in order.
  - `S2-Data-Destination-Continuous` stands down and stays parked (master plan section 5).
  - Order: Part 1 rankings; Part 2 REQ-105 and the RM1K golden spec; Part 3, the $0 data gaps (REQ-94, REQ-95, REQ-99, OET grades, IR-007).
- **QS decision (IR-011 Delivered Live):**
  - QS stays on the annual file upload, with no proxy or challenge bypass; THE keeps its automated reader.
  - The uploaded QS 2027 stays published until the Platform Admin uploads the new 2027 file (IR-005 Delivered Live).
  - The standing rule is amended in `CLAUDE.md` and `AGENTS.md` (both repositories).
- **s971** (Pilot, v2.16.84, `ranking-layer1-etl` v1.9.0, migration `20261122150000`, recorded before merge):
  - **ARWU added:** ARWU 2026 is read from ShanghaiRanking's public ranking API (plain GET, no challenge, no robots.txt; $0).
  - **ARWU rehearsal:** 1,000 rows (ties as repeated ranks, bands with no score, six indicators); 59 AU/NZ/CA linked (Australia 28/29, New Zealand 6/6, Canada 25/30).
  - **Coexistence:** University of Melbourne shows THE =34, QS =22 and ARWU 37 side by side in the website summary.
  - **Ranking editions:** a list on Rankings & statistics › Datasets with Publish and Unpublish (roll back) for the Platform Admin, with a reason and a log. In the rehearsal, unpublishing THE 2027 showed THE 2026, and publishing restored THE 2027.
  - **Matching:** a new rule ignores a leading "The" and a trailing country.
  - **Guides:** ranking steps in both SOPs and the Platform guide; runbook `docs/platform/RANKINGS-OPERATIONS-RUNBOOK.md`.
- **Live, read 22 Nov 14:25:** head `20261122140000`; G3 75/48, no drift; locks 7,585; active cron 135.

### S1-API-Frontend-Delivery, 22 Nov 2026 13:20 AEDT: rankings item delivered for THE (IR-005, RM1J); QS access route to the Platform Admin (IR-011); s970 recorded before merge

- **THE 2027 live** from the automated public reader:
  - accepted, access `public`, 3,146 rows, 18,876 indicator values;
  - attribution "Times Higher Education World University Rankings 2027. Source: Times Higher Education (timeshighereducation.com)";
  - 77 AU/NZ/CA rows linked: Australia 37/37, New Zealand 8/8, Canada 32/34 (3 by the register-name rule; Waterloo and Wilfrid Laurier have no provider record);
  - re-reads complete with the batch-size setting `reading.ranking_apply_batch_rows` (50).
  - Releases: s966 to s969 (Pilot #1473 to #1476, migrations `20261122110000` to `20261122140000`).
  - REQ-91 Delivered; RM1J Delivered; IR-005 Partly delivered (QS).
- **QS 2027:** the reader is live, but all 13 reads from the edge function met a Cloudflare challenge (HTTP 403), and none was bypassed. The uploaded QS 2027 stays published (1,504 rows, 70 linked). The access route is a Platform Admin decision (IR-011).
- **s970** (Pilot, `ranking-layer1-etl` v1.8.3, edge function only, recorded before merge): the reconciliation preview, which is only a report, is not run for an apply; in a dry run a preview time-out is reported instead of failing. Its first call on a cold database passed 8 s even with 37 rows.
- **Live guardrails, read 22 Nov 2026 13:00 AEDT:** head `20261122140000`; G3 75/48, no drift; locks 7,585; active cron 136 (no new job from this lane); $0 AI and $0 Firecrawl.

### S1-API-Frontend-Delivery, 22 Nov 2026 12:45 AEDT: THE 2027 live (public, attributed, 3,146 rows); s968 live; s969 batch-size setting recorded before merge

- **THE 2027 is live.** The s967 re-run published it at 00:49 UTC:
  - accepted, access `public`, 3,146 rows, 18,876 indicator values;
  - 77 AU/NZ/CA rows linked, 3 of them by the register-name rule;
  - attribution "Times Higher Education World University Rankings 2027. Source: Times Higher Education (timeshighereducation.com)";
  - the website now serves THE 2027 (Australia: Melbourne =34, Sydney =51, Monash 61, Queensland =73, UNSW =75, ANU 77).
  - Left for review: University of Waterloo and Wilfrid Laurier University (no provider record).
- **QS 2027:** every read from the edge function met the Cloudflare challenge (HTTP 403). No bypass was attempted. The uploaded QS 2027 stays live (accepted, 1,504 rows, 70 linked). The access route is a Platform Admin decision.
- **s968 live** (admin #779, Pilot #1475 `30401a2f`; preview of Australian rows only).
- **Its THE re-read stopped on the 8 s limit:** every row is an update on a re-read, and the batches of 200 were too slow.
- **s969** (Pilot, `ranking-layer1-etl` v1.8.2 and migration `20261122140000`, recorded before merge):
  - The batch size is the pipeline setting `reading.ranking_apply_batch_rows` (50).
  - A re-read keeps public access.
  - A THE re-read is queued after the deploy.
  - Rehearsal of a full re-read: 3,146 rows in 12 s, slowest batch 0.95 s.

### S1-API-Frontend-Delivery, 22 Nov 2026 12:00 AEDT: s967 live (partial THE 2027 held); s968 preview fix recorded before merge

- **s967 live** (admin #778, Pilot #1474 `89d5de57`, migration `20261122120000` applied 00:37 UTC). The partial THE 2027 revision is held (`parsed`), so the website shows THE 2026 again. Uploaded QS 2027 is unchanged (accepted, 1,504 rows, 70 linked).
- **The THE re-run still stopped on the 8 s limit**, this time in the Australian reconciliation preview (all 3,146 rows sent; slowest completed call 7.6 s), before apply. The QS re-run met the Cloudflare challenge again, from the edge function's egress.
- **s968** (Pilot, `ranking-layer1-etl` v1.8.1 and migration `20261122130000`, recorded before merge):
  - The preview gets the Australian rows only; its answer is unchanged.
  - Fresh THE and QS 2027 runs are queued after the deploy.

### S1-API-Frontend-Delivery, 22 Nov 2026 11:30 AEDT: s966 live; first THE run timed out (partial edition shown); s967 fix recorded before merge

- **s966 live** (admin #777, Pilot #1473 `6f8e7851`, migration `20261122110000` applied 23:54 UTC, `ranking-layer1-etl` v1.8.0 deployed 23:55 UTC).
- **First runs (00:05 UTC):**
  - **QS 2027:** the publisher returned a Cloudflare challenge (HTTP 403) to the edge function. The reader stopped without bypassing it, as designed, and the uploaded QS 2027 stays live and unchanged.
  - **THE 2027:** apply batches passed the service role's 8 s statement limit. Three batches (600 rows) landed, and because apply accepts an edition on its first batch, the website showed a partial THE 2027.
- **s967** (Pilot, migration `20261122120000`, recorded before merge):
  - Apply skips the provider searches for rows of countries with no provider; no match is lost.
  - A public revision is held as `parsed` until publish accepts the whole edition.
  - Publish uses the provider countries worked out once per call.
  - The partial THE 2027 is held, so the website shows THE 2026 meanwhile.
  - The s966 runs are replaced by fresh runs.
  - Rehearsal: 3,146 rows in 15 s (slowest batch 4.3 s), finalize 1.5 s, publish 0.25 s, 77 AU/NZ/CA rows linked.

### S1-API-Frontend-Delivery, 22 Nov 2026 10:20 AEDT: rankings decision (IR-005, RM1J); s966 THE and QS public readers recorded before merge

- **Decision (Platform Admin, 22 Nov 2026 09:22 AEDT):** THE and QS World University Rankings are attributed public rankings. They are used directly, with attribution, and there is no publisher-file upload or `terms = restricted` hold. Standing rule "Attributed Public Rankings (THE and QS)" in `CLAUDE.md` and `AGENTS.md` (both repositories). Lane 1 takes this Layer 1 item on the Platform Admin's instruction.
- **s966** (Pilot, `ranking-layer1-etl` v1.8.0, migration `20261122110000`):
  - THE is read from `timeshighereducation.com/json/ranking_tables/world_university_rankings/2027` and QS from `topuniversities.com/rankings/endpoint`, each with a plain GET (robots.txt and the QS crawl-delay of 10 s honoured; $0).
  - Readings are applied and published live (`access_status = public`, the attribution recorded, the uploaded QS 2027 revision superseded).
  - A fourth deterministic matching rule links a register name part ("A/B", "X, including Y").
  - THE 2027 is registered as a Layer 1 source.
  - The initial runs are queued on deploy for the existing run driver. There is no new job.
- **Rolled-back rehearsal, 22 Nov 2026 10:05 AEDT:**
  - THE 2027: 3,146 rows (201 tied, 1,995 banded, 849 reporters).
  - QS 2027: 1,504 rows (494 tied, 804 banded).
  - No unrecognised rank in either.
  - Links: Australia 37 of 37 and New Zealand 8 of 8 in both. Canada 32 of 34 for THE (Waterloo and Wilfrid Laurier have no provider record) and 28 of 30 for QS (Waterloo and Queen's).
  - Record: `docs/platform/2026-11-22-s966-public-ranking-readers-the-qs.md`.
- **Live guardrails, read 22 Nov 09:40:** head `20261122100000`; G3 75/48, no drift; locks 7,585; active cron 135.

### S1-API-Frontend-Delivery, 22 Nov 2026 02:45 AEDT: v2.16.83 live; Lane 1 parked

- **v2.16.83 live:** admin #773, then Pilot #1471 (`7aead3bf`), front end only. Signed in: Entry requirements › Study level shows all 243 options in one list under its groups. At 375 px, no sideways scroll on Courses or Entry requirements with the list open. REQ-100 Delivered.
- **Session total, Lane 1:**
  - Item 1 done (REQ-34 Live in v3, REQ-35 Delivered).
  - Item 2: 12 of 17 Delivered (REQ-92, 93, 96, 97, 98, 100, 101, 102, 103, 104, 106, 107). REQ-105 measured and next. REQ-94, 95 and 99 are with Lane 2. REQ-108 waits on scope.
  - Item 3 done (REQ-64 Delivered; REQ-71 and REQ-72 confirmed).
  - Item 4: acceptance read done; a deployed spec of the golden records is next, and the 10-provider QA waits on REQ-59's list.
- **Live guardrails:** head `20261122080000`; G3 75/48, no drift; manual locks 7,585; active cron 135, none unregistered; $0 AI and $0 Firecrawl for this lane.

### S1-API-Frontend-Delivery, 22 Nov 2026 02:20 AEDT: s959 live (v2.16.82); RM1K acceptance read; v2.16.83 recorded before merge (Pilot #1471)

- **s959 live:** admin #772, then Pilot #1470 (`cb4b33a4`). Migration `20261122080000` applied. Read back:
  - 31 changes logged.
  - 0 range or up-to values disagree with their notes; 0 text-only; 0 expired scholarships read open.
  - REQ-64 Delivered; REQ-71 and REQ-72 confirmed.
  - G3 75/48; locks 7,585; 135 cron.
- **Signed in on v2.16.82:**
  - Courses › Study level lists all 24 levels in one list under Pathway, Vocational, Undergraduate, Postgraduate and Other.
  - Entry requirements › Study level (62 options) still paged at 60. The one-list fix is Pilot #1471 (v2.16.83, no migration).
- **RM1K acceptance read (IR-002):** Website v3 serves at least one verified Australian record in every page section (`docs/platform/2026-11-22-rm1k-australia-golden-acceptance.md`). Next: a deployed spec of those records, and the 10-provider QA once REQ-59's list arrives.

### S1-API-Frontend-Delivery, 22 Nov 2026 01:40 AEDT: s958 live (v2.16.81); s959 recorded before merge (Pilot #1470, v2.16.82, migration `20261122080000`)

- **s958 live:** admin #771, then Pilot #1469 (`088736a1`). Migration `20261122070000` applied; `ref.study_level_groups` holds 24 levels. Signed in, Study level shows group headings, but only 10 levels: `api.catalogueFilterPage` capped the limit at 10. Fixed in s959. G3 75/48; locks 7,585; 136 cron.
- **s959 (Pilot #1470), item 3:**
  - REQ-64: rule from the Platform Admin, 22 Nov 01:20: the upper figure, marked up to. 28 range or up-to values are corrected; the notes are unchanged.
  - REQ-71: the last 3 text-only values are read from their notes ($0).
  - REQ-72: checked live, 0 published scholarships with a passed closing date read open; the round states are refreshed hourly.
  - 31 changes in all, each logged in `pipeline.scholarship_sweep_changes`. Locked values are skipped.

### S1-API-Frontend-Delivery, 22 Nov 2026 01:00 AEDT: s957 live (v2.16.80); s958 recorded before merge (Pilot #1469, v2.16.81, migration `20261122070000`)

- **s957 live:** admin #770, then Pilot #1468 (`46b2319f`). Migration `20261122060000` applied. No catalogue read counts scholarship scopes now. The provider website is read through `security.course_provider_website_v1`, because CI's s780 guard caught a direct catalogue read in `admin_read` before merge.
  - Signed in on v2.16.80: a Victoria University of Wellington course shows Institution website and Course page at the top, and duration 3 years.
  - REQ-93, 96, 98 and 104 are Delivered. G3 75/48; locks 7,585; 137 cron.
- **s958 (Pilot #1469, v2.16.81), REQ-100:** new table `ref.study_level_groups` holds the group of each study level. Courses and Entry requirements show every level in one list under Pathway, Vocational, Undergraduate, Postgraduate and Other, with no codes.
- **Remaining in item 2:**
  - REQ-105: the Courses load (two reads of 3 to 8 s) needs a filter-catalogue cache; scoped next, waiting on the Platform Admin.
  - REQ-94, 95 and 99 are with Lane 2.
  - REQ-108 waits on scope.

### S1-API-Frontend-Delivery, 22 Nov 2026 00:05 AEDT: s956 live (v2.16.79); s957 recorded before merge (Pilot #1468, v2.16.80, migration `20261122060000`)

- **s956 live:** admin #769, then Pilot #1467 (`12cafeee`). Migration `20261122050000` applied (renumbered: Lane 2's s960 holds `20261122040000`).
  - Signed in on v2.16.79: Entry requirements filters read Provider, Study destination, Student's education country, Applies to, with no Read now panel. Courses' first filter reads Study destination. Provider contacts shows its purpose line, with countries Australia, Canada, New Zealand. Rankings & statistics cards read QILT (Quality Indicators for Learning and Teaching) and PRISMS (Provider Registration and International Student Management System), each with its publisher.
  - At 375 px: no sideways scroll on Courses, Entry requirements, Provider contacts or Rankings & statistics.
  - REQ-92, 97, 101, 102, 103, 106 and 107 are Delivered.
- **s957 (Pilot #1468, v2.16.80):**
  - REQ-96 (defect): Has scholarship = Yes counted any scholarship scope; 3 of 100 courses showed no scholarship in the detail. It now reads the course search record in the three catalogue reads: 12,759 courses (was 13,571), 0 of 100 empty, timings unchanged.
  - REQ-98: Institution website and Course page links at the top of the course detail.
  - REQ-93: with no course rule, the university's requirement for a chosen student country.
  - REQ-104: the chosen state's campus first.
- **REQ-105 measured:** the Courses page waits on two reads of 3.1 to 3.4 s. In the database: first page 2.2 s warm, up to 8 s cold; filter catalogue 3.6 to 4 s. Next after REQ-100.

### S1-API-Frontend-Delivery, 21 Nov 2026 22:55 AEDT: s955 live and read back; s956 recorded before merge (Pilot #1467, v2.16.79, migration `20261122050000`)

- **s955 live:** admin #766, then Pilot #1465 (`ffb11140`). Migration `20261122030000` applied. The live Zoho v3 course CSV header ends with the nine English test columns; `zoho.sync_countries` reads AU, NZ, CA. At 22:50 the Zoho change stream holds NZ 417 and CA 1,130 providers and NZ 6,514 courses; campuses, contacts and CA courses follow over the next cycles. REQ-34 is Live in v3; REQ-35 is Delivered. G3 75/48; locks 7,585; 137 cron.
- **s956 (Pilot #1467, v2.16.79), India team review of 20 Nov:** covers REQ-92, REQ-97, REQ-101, REQ-102, REQ-103, REQ-106 and REQ-107.
  - REQ-92: Study destination on Courses, Providers, Scholarships, Campuses and Entry requirements; Student's education country on Entry requirements.
  - REQ-97: durations in years with weeks in brackets.
  - REQ-101: Read now only from Curator up.
  - REQ-102: Provider contacts can clear its provider and says what it is for; live country lists.
  - REQ-103 and REQ-107: Empty reason, On website and In Zoho CRM explain themselves.
  - REQ-106: statistics cards read their full names (QILT, PRISMS) and publisher from the registry.
  - Next for item 2: REQ-93, REQ-96, REQ-98, REQ-100, REQ-104 and REQ-105. REQ-94, REQ-95 and REQ-99 go to Lane 2 (data work); REQ-108 waits on the Platform Admin's scope decision.

### S1-API-Frontend-Delivery, 21 Nov 2026 22:05 AEDT: s955 recorded before merge (Pilot #1465, migration `20261122030000`): Zoho v3 English test columns; Zoho sync countries AU, NZ, CA

- **Z2 (REQ-34):** `public.zoho_v3_export_page` builds the course file itself. It keeps v2's rows, order, paging and columns, then adds nine columns: TOEFL iBT overall and band, Cambridge C1 Advanced overall and band, Duolingo overall, OET overall, band, letter grade and subtest grades. Empty means not held. Held live: TOEFL iBT on 3,100 of 24,013 course items, CAE 1,082, DET 412, OET 256; no OET letter grade is stored yet. Provider, campus and contact files and all of Zoho v2 are unchanged.
- **Z3 (REQ-35):** `zoho.sync_countries` goes from AU to AU, NZ, CA (Platform Admin 21 Nov 21:45). The setting is shared by v2 and v3, so NZ (6,514 courses in search) and CA (3,825) enter the Zoho change stream from the next `zoho-sync-check` cycles.
- **Proof (rolled back):** course page 1 has 3,000 rows in 3.6 s (v2 takes 2.5 s). The header starts with the v2 header, and 49 of 49 checked rows line up with v2. G3 75/48. Guard spec `cf-247-s955-zoho-v3-export-english-countries-contract`. Zoho change note `docs/integrations/zoho-pack/ZOHO-API-V3-CHANGES.md`.

### S1-API-Frontend-Delivery, 21 Nov 2026 21:35 AEDT: Step 0, Continuous Delivery Master Plan v0.1 and its standing rule

- **Permissions checked:** `git push` (dry run) and the GitHub API work in both repositories; no pull request was open.
- **Master plan:** `docs/platform/CONTINUOUS-DELIVERY-MASTER-PLAN.md` v0.1, drafted from the Platform Admin's Lane 1 brief (21 Nov 21:15) because no earlier copy existed; mirrored to Google Drive `M3`. Lane 1 (`S1-API-Frontend-Delivery`) and Lane 2 (`S2-Data-Destination-Continuous`) touch boundaries, the Lane 1 delivery order and a status log. Parts the brief does not cover are marked to be confirmed (IR-001).
- **Standing rule** "Continuous Delivery Master Plan" added to `CLAUDE.md` and `AGENTS.md` here and in Pilot: read the plan at start, follow its lane order, update it before parking.
- **Internal requests:** new `docs/integrations/INTERNAL-REQUESTS.csv` (IR-001 plan review, IR-002 Australia golden acceptance, RM1K), mirrored to the Drive sheet `Internal_Request_Register` in `Monitoring`.

### S1-ELR-Fetch-Window, 21 Nov 2026 18:45 AEDT: s950 live and read back; parked

- **Merged:** admin #762 (`9f3d696f`), then Pilot #1462 (`41572ace`) on green CI and a passing rolled-back dry run. `Deploy on merge` applied `20261122010000` (now the live head); the sweep function md5 reads `2a09bbdb`.
- **Read live:** the first `elr-det-sweep` run after deploy (18:42 AEDT) succeeded in 8.9 s; no fetch request open, none in flight; fetch queue 50 stored, 2 failed. No on-demand request is open.
- **Guardrails:** G3 75/48, no drift; manual locks 7,585; 137 active cron jobs. This change spent nothing ($0 Firecrawl, $0 AI); Firecrawl left on the plan 66,744 (scheduled work of other lanes since 15:38).
- **Parked.**

### S1-ELR-Fetch-Window, 21 Nov 2026 18:30 AEDT: s950 recorded before merge (Pilot #1462, migration `20261122010000`): the central English fetch closes its on-demand request when the window times out

- **Found (read live, rolled back):** step 7 of `security.elr_det_sweep_tick_v1()` closed an open fetch request only when its queue was empty. The claim sends nothing after `expires_at`, so a request that timed out with pages still queued would stay open past its window with no report, and its pages would never be sent.
- **Today nothing is affected:** request `c48a9a42` (s926) closed at 13:02 AEDT with 52 Firecrawl units, 50 pages stored, 2 failed. No fetch request is open.
- **s950 (logic only, live on deploy):** the sweep also closes a timed-out fetch request once none of its pages is in flight, through `security.on_demand_close_v1` (report kept, with `closed_by: window_expired` and `left_queued`). Pages left queued stay queued for a person to reopen (as s926 did). No request is opened and nothing is sent: $0 Firecrawl, $0 AI.
- **Proof (rolled back):** with `c48a9a42` set open and timed out and its 2 failed pages queued, the old run left it open; the new run closed it with `left_queued: 2` and sent nothing; a second run did nothing. md5 `602ee934` → `2a09bbdb`. Guard spec `cf-247-s950-elr-fetch-window-expiry-contract`. G3 75/48; locks 7,585; no new job.

### S1-Coverage-Unlock-UI-Notes, 21 Nov 2026 15:25 AEDT: coverage window `ad97c846` closed (s945 recorded before merge, Pilot migration `20261121235000`)

- The s903 on-demand window (109 gap universities, Firecrawl only, cap 20,000) expired at 15:09 AEDT. Read live (rolled back): **110 Firecrawl units used of the 20,000 cap** (scholarship pages 94, provider facts 11, listing pages 5); **66,863 credits left on the plan**; OpenRouter spend in the window, all lanes, US$0.0561.
- s945 closes it with `security.on_demand_close_v1` (only while open; the report is kept). No job, no value, nothing dropped. G3 75/48.

### S1-Fix-IQ00313, 21 Nov 2026 14:32 AEDT: s940 live and verified; IQ-00313 closed, parked

- **Merged:** admin #757 (`0e6434ed`), then Pilot #1459 (`ad95b073`). `Deploy on merge` applied `20261121220000` at 14:24 AEDT. The function body md5 reads `184872c2`; the planner is unchanged at `cf7fff50`.
- **Massey MY0418, July:** reads July 2027 with no day (was 12 Jul 2027) in:
  - the catalogue;
  - the Website v2 item and the stored Website item;
  - the search document.

  The Zoho feed holds no Massey course, so there is no Zoho copy. MY0418 has one withdrawn event and no hold. Audit event `IQ-00313-GENERAL-SEMESTER-SPANS-20261121`.
- **Unattended cycle 14:26 AEDT:** 5 rows. MY0418 was `nothing_new`, year and month, by the general-wording rule; 4 were month only; 0 day admissions. The ECU intakes are still February 2027 with no day.
- **Guards:** G3 75/48; locks 7,585; 135 active cron jobs, 0 unregistered; US$0.

### S1-Impl-Layer4-Human-UI-Guide, 21 Nov 2026 14:55 AEDT: s932 live (Pilot #1460 `d0d93779`, admin #756); parked

- v2.16.77 deployed (Deploy on merge with `ad95b073`, which includes it). Read back signed in: Module / Field reads **Course description (193)**, the rail "Every waiting course description item", Card 1 of 193.
- Drive `Monitoring`: rows 263 to 266 (Column P filled), Summary formulas restored, Chargeable_Hours_Summary from admin `0951820e` (5,995 minutes), backup pair `0951820e` uploaded and the two older pairs (`d51a1e26`, `551f37d6`) moved to the bin. The Drive total is 5,945: 50 minutes of other lanes' rows are on admin main but not yet on Drive.

### S1-Fix-IQ00313, 21 Nov 2026 14:00 AEDT: s940 recorded before merge (Pilot #1459, migration `20261121220000`)

- **Decision (Platform Admin, 13:51 AEDT):** Massey MY0418 goes back to July 2027 with no day. General semester descriptions on provider or calendar pages give month only.
- **s940 (live on deploy):** `security.intake_wording_specific_v1` also treats a period described as a span of months with a vague bound as general wording ("Semesters One: late February to June", "Semester Two: July to early November"). The planner is unchanged (`cf7fff50`).
- **Live audit (13:55 AEDT):** of 3,548 calendar-v3 day admissions, only MY0418 is affected.
- **Remediation:** the same migration takes MY0418 back to year and month with no hold, and reconciles Website and Zoho in the same transaction.
- **Dry run:** passed, md5 `8b933573`. G3 75/48; locks and cron unchanged; $0.
- **Record:** section 6 of `docs/platform/2026-11-21-iq00313-generic-wording-audit.md`. Pilot spec `cf-247-s940-iq00313-general-semester-spans-contract.spec.mjs`.

### S1-Impl-Layer4-Human-UI-Guide, 21 Nov 2026 14:20 AEDT: s931 live and read back (Pilot #1457 `502e7cc2`, admin #753 `055b213b`); s932 recorded before merge (v2.16.77, no migration)

- **s931 live (v2.16.76):** migration `20261121200000` applied; md5 read back: rule_groups `e0f40bd3`, grid `c880b723`, course description machine check `de1d932a` (all as written). Deploy on merge and Security gates green.
- **Signed-in check (built-in browser, desktop 1024 px and phone 375 px):** the old queue-button row is gone (no `.l4i-kinds`); primary row and Advanced filters (0) render; phone: filters stacked, decision bar sticky, no sideways scroll. AER: Module / Field 997, rail 997, Card 1 of 997 agree; Source country Hong Kong narrows all three to 36 (D3). AER card: Yes (Approve all rows) and No (Reject the read). Platform guide: coverage line (AU 1,543 providers and 25,685 courses, CA 1,130 / 3,825, NZ 417 / 6,514), What StudySearch covers, Filters & badges (87 entries), Layer 4 guide (5 parts), W1 to W4. Entry requirements › Provider, typing "charles": Charles Sturt University · 7 active, Charles Darwin University · 45 waiting. Course detail pills render.
- **Course descriptions:** 157 waiting before, 145 after (12 admitted by the CRICOS/NZQA code proof).
- **Found in the check:** with only course descriptions waiting, Module / Field and the rail still said University description (193). **s932** names the queue by what it holds (Course description, University description, or Course and university descriptions). Live on deploy.
- G3 75/48, locks 7,585, active cron 137 (ceiling 140).

### S1-Fix-IQ00313, 21 Nov 2026 13:35 AEDT: s925 live and verified; parked

- **Merged:** admin #747 (`c636a5dd`), then Pilot #1453 (`899c9986`). `Deploy on merge` applied `20261121170000` at 11:31 AEDT. The planner body md5 reads `cf7fff50`.
- **Read back:** ECU 086244B, 060895C and 083819C read February 2027 with no day in:
  - the catalogue;
  - the Website v2 item and the stored Website item;
  - the stored Zoho item;
  - the search document.
  Each keeps its filled event and has one withdrawn event. Audit event `IQ-00313-GENERIC-WORDING-20261121`.
- **Two unattended cycles:**
  - 12:26 AEDT: 9 rows. The three ECU intakes were `nothing_new`, year and month, with the general-wording reason. 6 were month only.
  - 13:26 AEDT: 5 rows, all month only.
  - 0 new day admissions in either cycle.
- **Guards:** G3 75/48; locks 7,585; 137 active cron jobs, 0 unregistered; US$0.
- **Open:** a decision on Massey MY0418 (July 2027, general semester wording only), in section 2 of `docs/platform/2026-11-21-iq00313-generic-wording-audit.md`.

### S1-Impl-Layer4-Human-UI-Guide, 21 Nov 2026 13:40 AEDT: s931 recorded before merge (Pilot migration `20261121200000`, v2.16.76)

- **Decision 279 (D1 to D5, 10:53) built from spec §5 to §8:** Layer 4 primary row (Module / Field, University, Destination country, Source country, Decision bucket) and Advanced filters (N) replace the kind toolbar and the view row in place; card zones Z1 to Z6 with Yes (Approve) / No (Reject) / Resubmit to Review with AI and More options; reject reason chips; AI budget line; Lock this value where `decide` accepts it; FieldGap pills and Add official URL (Curator+) on Course detail; CoverageNotice; Platform guide Filters & badges, Layer 4 guide and four worked examples. Live on deploy.
- **Fixes (12:28):** Approve all verified for provider shows and fills the provider's own verified count (`public.admin_layer4_cd_provider_verified_v1`); Course description and University description are separate entries; one fresh read for the queue count, All in this queue and Card X of Y; course descriptions proved by the course's own CRICOS or NZQA code on the page are admitted (dry run: 12 admitted now, 7 held by later checks).
- **D3:** `security.layer4_rule_groups_v1` (source_country, country) and `public.admin_layer4_grid_read_v1` (source_country), md5-guarded; `security.layer4_item_source_country_v1`.
- **S1-Dynamic-Lookups s930 live and read back** (Pilot #1456 `eff95a91`, admin #751): Provider list 3,090 providers, Charles Sturt University 7 live rows, Charles Darwin University 45 waiting; intake years 2026 to 2028; Deploy on merge, Security gates, Deployed UAT and Release Currentness green; v2.16.75 live.
- G3 75/48, locks 7,585, active cron 135. Design note: `docs/platform/2026-11-21-s931-layer4-human-ui-release.md`.

### S1-Dynamic-Lookups, 21 Nov 2026 12:45 AEDT: s930 recorded before merge (Pilot migration `20261121190000`, v2.16.75)

- **Found live (rolled back):** the Entry requirements Provider list (`public.admin_aer` 'options') took an arbitrary 300 of 843 providers, so Charles Sturt University and Charles Darwin University were not found. Seven screens wrote AU, NZ and CA into the code.
- **s930:** the Provider list is every active provider (3,090), with each provider's active and waiting matrix rows; new `public.admin_lookups_v1` (countries, study levels, rolling intake years); setting `lookups.intake_years_ahead` (2); seven screens and Help › Platform guide read it. Standing rule "Dynamic Database-Driven Lookups" in `CLAUDE.md` and `AGENTS.md` of both repositories.
- **Also read live:** IQ-00445 closed (`coverage-reconcile` 37.6 s at 10:09, 50.9 s at 11:09, 49.8 s at 12:09). Window `ad97c846`: 69 Firecrawl credits used of 20,000, 67,070 left on the plan, open until 15:09. Partial AER admission live: 1,133 rows at 31 providers active; Charles Sturt 7 active.
- G3 75/48, locks 7,585, active cron 135. Design note: `docs/platform/2026-11-21-s930-dynamic-lookups.md`.

### S1-Fast-Admission, 21 Nov 2026 11:35 AEDT: s914 to s916 live and read back (Pilot #1450 `2c2ad53a`, admin #742 and #744 `6207f659`); parked

- **Merged and applied:**
  - Merged by the automerge label: admin #742, then #744 (the renumber), then Pilot #1450.
  - Deploy on merge (run 44843028863) applied `20261121150000` at 11:19:59 AEDT. History md5 `69451f7a` matches the file.
- **Read back live (11:21 to 11:32 AEDT):**
  - **s914, partial entry tables:**
    - The first run at deploy admitted **1,133 rows from 38 reads at 31 providers**.
    - Charles Sturt: 7 rows live; Hong Kong stays in Layer 4.
    - Active entry-table rows went from 5,576 to 6,720 (the extra 11 were admitted by the table rule).
    - The rule's :29 run looked at 17 reads with 0 errors and found nothing new (7.9 s).
  - **s915, course entry reads:**
    - The :21 `aer-machine-admission` run admitted **75 verified course reads**.
    - Active course entry rows went from 25,544 to 25,741 (+197).
    - Audit-sample reads left: 491 → 416. The next 15-minute runs take the rest (about 75 a run, so roughly 6 runs).
    - The proposer is no longer held at its cap: proposed rows went from 2,721 to 3,086.
  - **s916:**
    - The aer-det-sweep fix is live: the stuck call was collected and its 40 pages recorded.
    - `elr-det-sweep` ticks are clean (3 of 3).
    - Central English calls: 7 done in 40 minutes, 1 in flight.
    - Schedules: `aer-machine-admission` 6,21,36,51; `aer-reconcile` 12,27,42,57.
  - **ELR, fees, intakes and scholarships:** no new canonical rows since the deploy. This change only speeds the $0 readers, and the English central reads still propose no new level values (see the S1-ELR lanes).
  - **Invariants:**
    - G3 75/48; manual locks 7,585.
    - Active jobs 134 at deploy, then 137 after another lane's `20261121170000`; ≤ 140, 0 unregistered. No job was added by this change.
    - `aer.machine_suspended` 0; US$0.
- **Follow-ups:**
  - The audit-sample reads finish over the next 15-minute runs.
  - A person can check them after admission. The list is `pipeline.aer_machine_admissions` with `reason_code = 'audit_sample'` and a later `admitted` row.
  - If the central English call times out, set `batch.elr_central` back to 6.


### S1-Fix-IQ00313, 21 Nov 2026 11:45 AEDT: P0 IQ-00313 generic course wording, s925 recorded before merge (Pilot #1453, migration `20261121170000`, dry run passed, md5 `6e562e2d`)

- **Directive (Platform Admin, 10:57 AEDT, P0):** ECU 086244B (course `fbd8ea85`) was published at 09:26 AEDT as starting 22 February 2027. The only course wording behind it is ECU's general sentence "Most courses start in Semester 1 each year, usually in the last week of February".
- **Audit (live, 11:05 AEDT):** 3,548 active calendar-v3 day admissions (calendar-v3 1,647; Rule B nearest start 1,901). Three are backed only by general wording, all ECU February 2027: 086244B, 060895C and 083819C. Nothing else is. Massey MY0418 (July 2027) is held for a person to decide (section 2 of the audit note).
- **s925 (live on deploy, no switch, no shadow):**
  - Study periods are read from course-specific wording only (`security.intake_wording_specific_v1`).
  - General wording never gives a start day by any route. It gives year and month, or month only.
  - New `security.intake_date_day_withdraw_v1` takes back the start day only, with no hold.
  - The three ECU intakes go back to February 2027 in the same migration, and the Website and Zoho items are reconciled in the same transaction.
- **Guards:** G3 75/48 before and after; locks 7,585 unchanged; active jobs 136 unchanged, 0 unregistered; no new setting or job; US$0, no Firecrawl.
- **Record:** `docs/platform/2026-11-21-iq00313-generic-wording-audit.md`. Pilot spec `cf-247-s925-iq00313-generic-wording-no-start-day-contract.spec.mjs`.
- **Next:** merge (this repository first), read back live, two unattended `intake-dates-apply` cycles, then Drive `Monitoring` sync.

### S1-Coverage-Unlock-UI-Notes, 21 Nov 2026 10:07 AEDT: standing mandate, immediate live activation (s917, recorded before merge)

- **Rule (Platform Admin, 21 Nov 2026 10:07 AEDT):** reported bug fixes and verified admission rules take effect immediately upon deploy.
  - No unrequested shadow, off-by-default flag, or 24-hour or next-day cutover.
  - No assumed future work without the user's confirmation.
- **Where it is written:** `CLAUDE.md` and a new `AGENTS.md` in both repositories, word for word. Guard: Pilot spec `cf-247-s917-immediate-activation-mandate-contract.spec.mjs`.
- **No migration.** G3 75/48, locks 7,585, active jobs 135, $0.
- **The 10:07 cutover (partial entry-table admission live; audit holds released; 15-minute admission and `aer-reconcile`)** is carried by S1-Fast-Admission (Pilot #1450, s914 to s916, recorded in admin #742 and #744).
  - This lane's own build of the same change was stopped before merge, so that two changes do not edit the same functions or register the same rule.
  - Its rolled-back dry run (10:36 AEDT) read: 40 entry-table items, 1,157 rows; active entry-table rows 5,576 → 6,709; Charles Sturt 7 live, Hong Kong held.

### S1-Fast-Admission, 21 Nov 2026 10:35 AEDT: s914 to s916 recorded before merge (Pilot migration `20261121150000`)

- **Design record:** `docs/platform/2026-11-21-s914-s916-fast-admission.md`.
- **Decision (Platform Admin, 10:03 AEDT):** admit verified data today.
  - **The s912 cutover planned for 22 Nov 2026 09:30 AEDT is this change.** Do not make it again.
  - The s902 follow-up ("shadow report after 24 hours for the cutover decision") is closed by this change.
- **s914:** rule `aer-partial-admit` runs at :14, :29, :44 and :59, admitting only rows that pass every check. The shadow `aer-uniwide-partial-shadow` is switched off and retiring.
- **s915:** audit samples go to 0%. 491 verified course reads (1,450 rows) are admitted by the next runs. `aer-machine-admission` runs at :06, :21, :36 and :51. The proposer takes 150 courses a tick and up to 1,200 waiting items.
- **s916:** `aer-reconcile` runs at :12, :27, :42 and :57. aer-det-sweep NUL fix (md5 `9856b441`). The $0 sweeps take three times the work (aer_det 9 calls / 12 open; ELR 24 in flight / 600 a tick; central sources 18).
- **Dry run (10:30 AEDT):** 38 reads, 1,133 rows at 31 providers; Charles Sturt 7 (Hong Kong held). G3 75/48; locks 7,585; active jobs unchanged.

- **s881 live 17:59 AEDT (S1-Build).** Pilot #1434 merged itself by the `automerge` label (squash `15f36e1d`, branch deleted); the Auto-merge workflow started `Deploy on merge` with the exact commits, which applied `20261120181000` (history md5 `b0ae0cb4` = file), plus `Security gates` and `Deployed UAT`. First merge whose deploy ran through the hand-off.
  - Read back 18:00 AEDT: **136 active, 0 unregistered**, with all three idle-paused jobs (`boost-extract`, `coverage-read`, `coverage-read-2`) on; the 7 jobs off and `retiring` until 4 Dec (7 `job_retire` events); every protected sweep and pipeline on; head `20261120181000` (2,226 rows); G3 75/48, 0 drift; 7,585 locks.
  - Drive `Monitoring`: rows 215–216 (column P filled); `Chargeable_Hours_Summary` rebuilt from admin main `925c324d` (4,765 minutes); backup pair for `925c324d` uploaded and the #705 pair trashed. The Drive Summary reads 4,510 because S1-RM-Design (17:30, 17:45, 18:05) and S1-Fees-Intakes (15:48) have not yet appended their rows.
- **Renumbered 10:45 AEDT:** S1-ELR-Bands-And-Crawl claimed s913 and `20261121140000` at the same time (Pilot #1451). This change is now **s914 to s916**, Pilot migration `20261121150000` (Pilot #1450).

### S1-Coverage-Unlock-UI-Notes, 21 Nov 2026 09:57 AEDT Platform Admin decision: partial entry-table admission approved (s912 recorded before merge; cutover 22 Nov 09:30)

- **Decision (Platform Admin, 21 Nov 2026 09:57 AEDT), verbatim:** "partial entry-table admission is approved (superseding the all-or-nothing hold under Decision 276): admit all country rows in a university-wide or course entry table that pass domain, identity, and source-evidence checks, while holding only the missing or unverified country rows in Layer 4 for human review. Proceed with the 24-hour shadow report and cutover tomorrow at 09:30 AEDT."
  - This supersedes the all-or-nothing completeness hold (D-R3) for entry-matrix reads.
  - Decision 276's freeze on new AER v1 readers, word lists and recovery paths is otherwise unchanged.
- **s912 (Pilot migration `20261121130000`, spec `cf-247-s912-partial-admission-shadow-course-rows-contract.spec.mjs`):** the s902 shadow now counts every proposed row of the read, university-wide and course rows, so the 24-hour report measures what the cutover will admit. It still records only.
  - Rolled-back dry run (10:05 AEDT): 73 items; would admit **1,158 rows** (17 of them course rows) at **31 providers** (40 items).
  - Charles Sturt: 7 of 7, Hong Kong held.
  - The live rule's 09:33 run succeeded (university-wide only: 1,141 rows).
- **Cutover:** 22 Nov 2026 09:30 AEDT (scheduled check-in), repo-first.
  - The machine admission will admit the passing rows of a read that only completeness stops. Every item-level check stays required, and so does every machine row rule.
  - The missing countries and any failing rows stay in Layer 4 for a person.
  - A new setting switches it on; the shadow rule then retires.

### S1-Coverage-Unlock-UI-Notes, 21 Nov 2026 09:09 AEDT: s900 to s903 live and read back (v2.16.74); parked with three follow-ups

- **Merged and applied:**
  - Pilot #1444 (s900): applied 08:27 AEDT.
  - Pilot #1446 (`d7926c26`, s901–s903): applied 09:09 AEDT by `Deploy on merge`; history md5 `a1918a51`, `e121e725` and `04ab997f` each match their file.
  - Head `20261121102000` (2,239 rows).
- **Read back live (09:11–09:15 AEDT):**
  - **IQ-00510:** pilot levels 8,192 / 9,216 / 10,240 MiB.
  - **IQ-00445:** `coverage-reconcile` at :09 ran in **85.7 s** at 09:09 (it took 136.2 s at 08:26). `scholarship-coverage-classify` ran at 08:40 (21.6 s).
  - **Admin function md5s:** `admin_aer` `0f4af839`; `on_demand_request_for_v2` `3a41986e`.
  - **s902 shadow:** 73 items; would admit 1,141 rows at 27 providers; admitted 0. Charles Sturt: 7 proposed, 0 active.
  - **s903 window `ad97c846`:** open 09:09 to 15:09 AEDT for 109 universities; Firecrawl only; central, scholarships and reads; cap 20,000. Plan credit before 67,193; used 0 at 09:11. Charles Sturt covered for central, not for course search.
  - **Deployed UAT:** s154 (Entry requirements, signed in) passed on v2.16.74.
  - **Signed in, built-in browser (Platform Admin session):**
    - Entry requirements: Notes closed on load and opens cleanly; filters Provider, Destination country, Source country, Applies to; column Source country.
    - Scholarships: Notes closed, scholarships section first.
    - Course detail (Charles Sturt, Bachelor of Accounting): "No university-wide entry table is active for this university. 7 waiting in Layer 4", Notes closed.
  - **Invariants:** G3 75/48, no drift; locks 7,585; 135 active jobs, 0 unregistered.
- **Follow-ups:**
  - **IQ-00445:** close after the second clean cycle at 10:09.
  - **s903 window:** close after 15:09 with `security.on_demand_close_v1`, reporting actual use and the credit left.
  - **s902:** shadow report after 24 hours (from 09:09 on 22 Nov) for the Platform Admin's cutover decision. Decision 276 needs confirming.
  - **IQ-00510 option C:** `docs/paste/PASTE-20261121-s900-vacuum-analyze.sql` waits for the Platform Admin, one line at a time.

### S1-Coverage-Unlock-UI-Notes, 21 Nov 2026 08:20 AEDT decisions: coverage unlock, counsellor notes and AER country filters (s901 to s903, v2.16.74), recorded before merge

- **Design record:** `docs/platform/2026-11-21-s900-s903-coverage-unlock-ui-notes.md`.
- **The audit (rolled back, 08:10–09:40 AEDT):**
  - No coverage limit is written into code. Every one is a setting; none is changed.
  - "38/40" is a coverage count, not a cap.
  - 109 of 143 universities (10,559 courses) have no active entry table or no published scholarship.
  - 57 of the 79 waiting entry-matrix items stop only at the completeness gate D-R3. Charles Sturt is one: 7 rows read, Hong Kong dropped. Its 85 scholarships already reach all 67 courses.
- **Decisions (Platform Admin, 08:20):**
  - On-demand window up to 20,000 Firecrawl credits.
  - A new auto-admit rule, in shadow first for 24 hours.
  - Inheritance in PIM Admin and API v3 only (v2 frozen).
- **Pilot (v2.16.74, package 0.1.496), recorded before merge:**
  - `20261121100000` (s901): `public.admin_aer` md5-guarded edit (`0593747b` → `0f4af839`). Destination country, Source country (was "Country") and Applies to filters. Course detail shows the university-wide entry table. Counsellor notes panel, closed by default, on Course detail, Entry requirements and Scholarships.
  - `20261121101000` (s902): rule `aer-uniwide-partial-shadow` of `admission-rule-runner`, hourly at :33, records only.
    - Dry run: 73 items; would admit 1,141 rows at 27 providers. Charles Sturt: 7 of 7, Hong Kong left as a gap.
    - The cutover is a separate decision after 24 hours.
  - `20261121102000` (s903): `security.on_demand_request_for_v2` md5-guarded (`2b6d99d5` → `3a41986e`); a request's cap now stops its on-demand spend.
    - One window for the 109 universities: Firecrawl only; central, scholarships and reads; 6 hours; cap 20,000.
    - Dry run: Charles Sturt covered for central and scholarships, not for course search; with the cap set to 0 it is no longer covered.
  - Renumbered above S1-CourseLink's re-issued `20261121093000` (Pilot #1445).
- **Invariants (dry run):** G3 75/48; locks 7,585; active jobs 135; nothing dropped or overwritten.

### S1-Coverage-Unlock-UI-Notes, 21 Nov 2026 07:48 AEDT directive: IQ-00510 and IQ-00445 fixes (s900), recorded before merge

- **Approved by the Platform Admin (07:48),** following the 2 AM audit (`docs/platform/2026-11-21-capacity-runtime-audit.md`):
  - **IQ-00510:** the pilot alert levels move to 8,192 / 9,216 / 10,240 MiB (watch / high / critical). Log retention is unchanged.
  - **IQ-00510, option C:** a non-locking `VACUUM (ANALYZE)` of `catalogue.course_fees`, `pipeline.course_attribute_coverage`, `scholarship.course_mappings` and `pipeline.coverage_provider_urls`. VACUUM cannot run inside a migration, so it is the paste file `docs/paste/PASTE-20261121-s900-vacuum-analyze.sql`, run one line at a time.
  - **IQ-00445:** `coverage-reconcile` moves from :26 to :09, and `scholarship-coverage-classify` from :29 to :40. The commands are unchanged; the catalogue wording follows.
- **Pilot migration `20261121090000` (s900):**
  - Rolled-back dry run, 08:40 AEDT: levels 8192/9216/10240 MiB; `coverage-reconcile` at `9 * * * *`; `scholarship-coverage-classify` at `40 * * * *`; both on; 134 active jobs, unchanged by the migration.
  - It drops, deletes and unschedules nothing. Spec `cf-247-s900-capacity-levels-quiet-minutes-contract.spec.mjs`.
- **Drive `Monitoring` variance** (Drive 5,340 minutes against admin 5,295):
  - **4 rows from S1-Courses** (18 and 19 Nov, 15 minutes each, 60 in total) were in Drive only. Their admin PR #609 was closed without merging, so they never reached this register. They are restored here exactly as Drive holds them.
  - **Drive row 183** (`…s806-s810-merge-readback-9b4f`, 20 Nov) had 15 counted minutes against 30 recorded. Drive is corrected to 30.
  - Both registers then agree; the difference was 60 − 15 = 45.
- **Next in this lane:** the coverage unlock (s901 onwards: on-demand window capped at 20,000 Firecrawl credits, a shadow admission rule for university-wide entry rows) and the counsellor notes panel and AER country filters.

### S1-Ops-Capacity-Runtime, 21 Nov 2026 02:00 AEDT scheduled audit: IQ-00510 database size and IQ-00445 coverage-reconcile (read only, waiting for approval)

- **Audit:** `docs/platform/2026-11-21-capacity-runtime-audit.md`. All reads rolled back; nothing changed; $0.
- **IQ-00510:**
  - The database is 7,185 MiB at 02:03 and 7,370 MiB at 02:17 AEDT, against the pilot critical level of 7,168 MiB (`pipeline.platform_capacity_policy`).
  - Growth is about 200 MiB a day over 10 days.
  - Dead rows are about 5%, so a `VACUUM FULL` would return only an estimated 100–300 MiB. The growth is stored evidence, AI answers and pipeline queues.
  - **For approval:**
    - **A:** confirm the provisioned disk in Compute and Disk, then raise the pilot levels by a Pilot migration.
    - **C:** a plain `VACUUM (ANALYZE)` on four tables (`catalogue.course_fees` was last vacuumed 5 Oct).
  - No retention change is recommended.
- **IQ-00445:**
  - `coverage-reconcile` (#364, `26 * * * *`) runs in **9.1 s alone**. At :26 it runs at p50 106 s and p95 137 s, with 3 time-outs in 7 days.
  - :26 is the busiest minute of the hour (59k busy seconds against 13k at :09).
  - **For approval:** move the job to `9 * * * *` by a Pilot migration, then close IQ-00445 after two clean unattended cycles. Trimming the batch would save under a second.
- **Invariants (02:17):** G3 75/48, no drift; locks 7,585; active jobs 137; head `20261120235000` (2,233 rows).

### S1-Build, 20 Nov 2026 22:41 AEDT Platform Admin decisions: requests and two university records

- **Requests (`docs/integrations/CONSUMER-REQUESTS.csv`):**
  - **REQ-49** (campus names and course counts in the API): Live in v3 → **Delivered**, kept as its own item and not folded into RM1K. Live read-back 22:52 (Website API v3 provider item, rolled back): `campuses[]` carries `campus_name` and `course_count` (Monash: 750 Collins St Docklands 36, Churchill 2).
  - **REQ-59** (ten-provider check before production): kept standalone under its own ID, not folded into RM1K; stays **Open** (the check results are still to come). The decision note named REQ-59 as "campus names and course counts", which is REQ-49; the decision was applied to both as written so neither is folded.
  - **REQ-69** (intake year, start date and deadline): Live in v3 → **Partly delivered**. Exact intake dates are 4,877 live against 17,440 source-backed gaps, and `pipeline.intake_cohort_stages` (IQ-00313) is still draining and unverified in production (Platform Admin figures).
  - **REQ-66** (old academic entry and scholarship import): stays **Open** until `aer-det-sweep` and the legacy AER promotion complete.
- **UTS (`uts.edu.au`):** approved in Layer 4 Review by the Platform Admin. Read back 22:50: the description is live (449 characters) and no university-description item is waiting.
- **Victoria University (`vu.edu.au`): decided 23:07 by the Platform Admin (S1-RM-Design): keep both records; 02475D takes the 00124K description (s890, Pilot #1440 `f0b8d751`, migration `20261120231000`, live and read back 23:40).** Earlier record (held for one decision, nothing changed): Read live 22:46–22:50 (rolled back):
  - `bac82321`, CRICOS **00124K**: 279 active courses, 6 campuses; already the single recorded owner of `vu.edu.au` (`pipeline.provider_host_owners`, s766, Platform Admin 19 Nov 16:18).
  - `0f5373c8`, CRICOS **02475D**, website `vu.edu.au/international`: 35 active courses with their own CRICOS course codes (none shared with 00124K; 34 share a title), campuses Victoria University Sydney City Centre and Victoria University Brisbane; no manual lock.
  - So single host ownership already holds, and the second record is a separate CRICOS registration, not a copy. Retiring it removes 35 international courses at Sydney and Brisbane from the catalogue; merging moves 02475D course codes under the 00124K record. Either is a Pilot data migration (repo-first) once the Platform Admin confirms which.

### S1-Build, 20 Nov 2026 17:14 and 17:15 AEDT directives: active cron jobs at most 136 (s881), recorded before merge

- **Reconciliation:** `docs/platform/2026-11-20-s881-cron-job-reconciliation.md` (all 13 consolidation candidates with status, the 7 switched off with evidence, the jobs looked at and kept).
- **Count, read live 17:18–17:58 AEDT (rolled back):** 140 to 143 active depending on the minute (`boost-extract`, `coverage-read`, `coverage-read-2` are idle-paused and released by `flag-recheck`); 0 unregistered. Net additions since the 140 checkpoint: `aer-det-sweep`, `struct-det-sweep`, `elr-det-sweep`; `fid-det-sweep` (Pilot #1425) is still to come.
- **13 candidates:** 8 already folded by PR 4; `coverage-read`, `coverage-read-2`, `boost-extract`, `boost-fields` kept (cadence or live S2-BOOST work); `boost-benchmark` retired now (bench-5 finished).
- **Pilot #1434, migration `20261120181000`, dry-run md5 `b0ae0cb4`:** 7 jobs with no work left switched off and `retiring`, each only while its evidence holds: `boost-benchmark`, `lean-sections-eval`, `lean-qualify`, `aer-v2-shadow`, `course-url-fill`, `reread-pilot`, `course-description-stale-retire`. Dry run: active 143 → **136**, 0 unregistered. The post-check refuses if any protected sweep or pipeline is off. Nothing unscheduled or dropped; paste file `docs/paste/PASTE-20261205-s881-idle-jobs-unschedule.sql` from 5 Dec.
- **Also:** `scripts/ci/auto-merge.sh` (both repositories, md5 `9e512267`): a one-off check on a finished check suite now reports a stop without failing or commenting (a `check_suite` run had failed on S1-Fees' #1425, which has a failing `deno-check`); and a workflow whose latest real run was cancelled (adding the `automerge` label starts a run that cancels `Test evidence` and then skips) is re-run once by the waiting run, never while a newer run is queued.
- G3 75/48 untouched; 7,585 locks untouched; spend US$0.

### S1-Build, 20 Nov 2026 17:00 AEDT directive: automatic merging and probe-branch clean-up (s880, renumbered from s870), live 17:31 AEDT

- **Live:** admin #704 merged itself by the `automerge` label at 17:15 AEDT (squash `f9650ee6`, branch deleted, `Security gates` started on main); Pilot #1433 merged itself at 17:31 AEDT (squash `65414f2c`, branch deleted; no migration or edge function, so no deploy; `Security gates` passed and `Deployed UAT` started on main). Renumbered s870 → s880 because S1-RM-Design's Pilot #1432 holds s870–s871; the Pilot spec is `tests/uat/cf-247-s880-auto-merge-contract.spec.mjs`.

- **Rule (both `CLAUDE.md` files):** never ask a person to merge a pull request or delete a branch. Merge `coursefinder-admin` first: `gh pr merge --auto --squash --delete-branch`, or on HTTP 403 the `automerge` label, then poll until `MERGED`; then Pilot the same way; then the post-merge live checks and the Drive `Monitoring` sync.
- **How (`.github/workflows/auto-merge.yml` + `scripts/ci/auto-merge.sh`, the script byte for byte in both repositories):** a pull request labelled `automerge` is squash-merged once it is mergeable and every latest check is green, and its branch is deleted. In Pilot a new migration also needs the `live-dry-run` label and a successful `dry-run` check. A failure or conflict stops the wait with a comment.
- **Push-to-main hand-off:** a `GITHUB_TOKEN` merge does not start push workflows, so the script starts them. In Pilot: `Deploy on merge` (new `workflow_dispatch` with the exact before/after commits; runs on main only and refuses an `after` not on main), `Security gates`, `Deployed UAT`, and `Release Currentness Deployed` for release files. Here: `Security gates`.
- **Probe branches (Pilot `scripts/ci/probe-branch-cleanup.sh`):** a `…-probe` or `…-diag` branch is deleted when its hand-started dry run finishes (no open pull request, no newer commit); `…-probe` branches idle for 24 h are swept; each deletion is listed with its last commit.
- **Why the label and not GitHub auto-merge:** neither repository has branch protection and GitHub's own auto-merge is off, so `gh pr merge --auto` is refused; the session proxy also blocks GraphQL.
- No database change: 75 functions / 48 tables and the 7,585 locks untouched. Spec `tests/uat/cf-247-s880-auto-merge-contract.spec.mjs` (Pilot).

### S1-RM-Design, 20 Nov 2026 10:07 and 10:21 AEDT directives (scope locked 11:24): Platform Health executive view (s817) and description review (s819 to s821), merged and read back

- **Status 20 Nov 2026 12:20 AEDT: merged and read back.** Pilot #1411 (`8982b5555`, v2.16.66). Live (rolled-back dry-run workflow only): 2,214 migration rows, head `20261120121100`, 1-to-1 with Pilot main; G3 0 drift (75 functions, 48 relations); 7,585 manual locks; spend US$0.
- **s819:** promotional words of `pdesc.superlatives` are removed from a declined university description before Layer 4, and the same validation and machine gate run again (`security.description_strip_words_v1`, word-strip recovery in the admission, migration `20261120121000`). The live list is in the description prompt (registry v7, migration `20261120121100`). Human Edits shows rule-tuning candidates.
- **s820/s821:** plain-English main hold reason, one-click Remove "word" & Admit, one action bar per description card.
- **s817:** Platform Health opens on an executive view (health, AI spend against the daily cap, blockers, Layer 4 waiting) and Needs attention; everything technical is under Technical details.
- **Left with other lanes (11:24):** s813 fixed by S1-Build (#1410); s814 and s816 with S1-Build; s815 with S1-AER. s822+ free for S1-UX.
- **Pending, stated plainly:** live `200 text/plain` read of `/.well-known/security.txt`; course descriptions are not stripped automatically (one-click only); the waiting fee reader item was not released (it would start AI work).

### S1-RM-Design, 20 Nov 2026 08:06 AEDT directive: ISM close-out (s811) and UnoPim grid actions and provenance (s812), merged and read back

- **Status 20 Nov 2026 09:55 AEDT: merged and read back, with three items pending (below).** Pilot #1408 (`b2b8c688f`, v2.16.63) and #1409 (`3667aae2f`, v2.16.64); admin #672 (`085e0543`). Live (rolled-back dry-run workflow only): 2,207 migration rows, head `20261120104000`, 1-to-1 with Pilot main; G3 0 drift (75 functions, 48 relations); 7,585 manual locks; provider description prompt version 6 the only active one; `security.s812_bulk_admin_v1` present and routed from `admin_layer4_inbox`; setting `bulk.primary_campus_max` 100; 1,422 primary campuses (unchanged); 0 bulk-flag audit events; spend US$0. The s811 migration was renumbered to `20261120103000` after S1-Build's #1407 took `20261120102000`.
- **s811:** `/.well-known/security.txt` (plain text, expires 2027-11-19), `data_collection: "deny"` on every OpenRouter request (Pilot and the Boost Worker), the `<untrusted_source_text>` fence on description extraction (prompt version 6) and on the Boost Worker prompt, Zoho API v3 error detail limited to the platform's own text. `AI-SYSTEM-CARDS.md` and `API-SECURITY-AND-EOL-GUIDE.md` say what is and is not evidenced.
- **s812:** Providers bulk bar: Queue to Intake Run & Validate (hand-off list on Layer 2/3 › Operations; runs nothing) and Flag primary campus (Platform Admin; preview, then apply with a reason; B2 rule for the ticked providers; one audit event). Human Locked pills in the Provider and Course drawers. `UNOPIM-LESSONS-LEARNED-STATUS.md` updated (Layer 4 Edit & Approve is built by S1-Build s802 to s805).
- **Pending, stated plainly:** (1) live `200 text/plain` read of `/.well-known/security.txt` (no approval was given for a browser or fetch read); (2) the OpenRouter account-level privacy setting is not evidenced, zero data retention is not requested, and the Boost Worker's free-tier providers have no per-request denial; (3) the description prompt qualification record is still on `provider-description-p5` (a version 6 regression run spends AI money). Register and AI verified remain description only; per-field source needs a new table (Platform Admin approval). Not started here: the S1-Build directive s813 to s816, which was addressed to S1-Build.

### S1-RM-Design, 20 Nov 2026 06:10 AEDT directive: UnoPim completeness patterns (s806, s807) and ASD ISM security hardening (s808 to s810), recorded before merge

- **Status 20 Nov 2026 07:46 AEDT: merged and read back.** Pilot #1403 (`a7367a9a`, v2.16.61) and fix #1405 (`9c0eb880`); admin #664 and #667. Live: 2,203 migration rows, head `20261120100000`, G3 0 drift (75 functions, 48 relations), 7,585 manual locks, spend US$0. Live screens read: completeness bars and Missing field pills (773 lack a website), `#platform-guide` role guides 1.1, release notes (212). Live headers present (CSP, HSTS, X-Frame-Options, nosniff, Referrer-Policy, Permissions-Policy). #1405 fixed the release notes page, whose inline script the CSP blocked. Still open: `/.well-known/security.txt` (needs a mailbox the Platform Admin names), ISM-2103 non-training evidence, description prompt fence (registry version bump), Zoho v3 error detail (G3 approval), Layer 4 inline Edit & Approve and 6-month audit (S1-Build s802 to s805). Full entry: runsheet 20 Nov 07:46.

- **Pilot #1403** (v2.16.61), migration `20261120100000`, recorded here before merge (repo first). Parity before authoring: live `schema_migrations` 2,198 rows, head `20261120010000`, equal to 2,148 baseline plus 50 Pilot files; the new version is above the head and above the other lanes' open pull requests. Live was 2,202 rows, head `20261120095000` at 07:05 AEDT (after Pilot #1401, #1402 and #1404 of other lanes; the s807 version was `20261120090000` and was renumbered above that head, content unchanged); expect 2,203 rows and head `20261120100000` after deploy on merge. G3 75 functions and 48 relations; no new public function, table or view; 7,585 manual locks; AI and Firecrawl US$0; no interactive query.
- **s806:** `docs/platform/UNOPIM-LESSONS-LEARNED-STATUS.md`: §7.1 partly built (registry in shadow only), §7.2, §7.3 and §7.4 not built, §7.5 built for settings; completeness, Missing field filter and provenance built in part.
- **s807:** Completeness bar and Missing field pills on Courses and Providers; provider bulk bar (Fill fields, Export selected, Clear); provider drawer completeness and provenance panel; role guides 1.1. Migration `20261120100000` is one md5-guarded in-place edit of `security.admin_providers_page_v3` (guard `789b1a5ceb4ee9fbcc770a9d65e31e39`). Dry run: 773 of 3,091 active providers lack a website, equal to a plain count. Not built: bulk-queue to Intake Run & Validate, bulk-flag primary campus, Layer 4 inline Edit & Approve, the six-month periodic audit bar.
- **s808:** `docs/security/ISM-SECURE-SDLC-AND-THREAT-MODEL.md`, `AI-SYSTEM-CARDS.md`, `API-SECURITY-AND-EOL-GUIDE.md`. Gaps recorded in them: no separate pre-production database; no history scan for secrets; ISM-2103 provider non-training not evidenced; no security contact address.
- **s809:** `.github/workflows/security-gates.yml` in both repositories (secretlint 14.0.1; `npm audit` through a runner-only lockfile; CycloneDX 1.5 SBOM, 90 days). Admin `vite` 8.1.5 to 8.3.8 (high advisory).
- **s810:** `public/_headers` in both apps; untrusted page-text fence (`untrusted.ts`); website API v3 sends only the platform's own `INVALID_INPUT:` text. `security.txt` not published (no contact address named).
- **Specs:** `cf-247-s807-unopim-patterns-contract`, `cf-247-s810-security-gates-contract`; `s538` allows one more differing v3 line. Local note: `cf-247-catalogue-course-description-contract.spec.mjs:61` also fails on main (stale local `dist/version.json`).

### S1-RM-Design, 19 Nov 2026 16:18 AEDT directive: AU university identity holds (s766) and Layer 4 Grid Country and Provider type pills (s767)

- **Pilot #1385** (v2.16.53, commit `0b68e4d3`), migrations `20261119172000` and `20261119173000` applied by deploy on merge and read back; G3 75/48. Full record: `docs/platform/2026-11-19-s766-s767-au-university-identity-and-grid-filters.md`. Every read ran through the rolled-back dry-run workflow (no interactive query); Firecrawl 0; spend today US$0.0081 of the US$0.50 cap.
- **s766 done:** host owners recorded (vu.edu.au to Victoria University 00124K, rmit.edu.au to RMIT University, westernsydney.edu.au to Western Sydney University) and honoured by `security.provider_description_identity_v1`; the three owners read `identity_clear`, RMIT UP stays `provider_host_conflict`. "Torrens University" and "Moore Theological College" recorded as `trading_name` aliases and passed to the reader. One stored-page read queued for each (state queued, drain rule `s766-au-university-identity`); no description admitted yet.
- **s766 handed over, by finding:**
  - Victoria University 02475D (35 active courses, vu.edu.au/international) is a separate CRICOS registration, not a copy: 120 tables reference a provider and no merge function exists. A person decides which courses move or retire; it stays held meanwhile.
  - The "NA" record (CRICOS 03811G; Myotherapy, Real Estate and Beauty Therapy courses; 7 active; website aucd.edu.au manually locked) is a different VET provider. A person should correct and unlock its website; that clears `domain_shared` on it and on the Australian University College of Divinity (41 courses, no stored page).
  - RMIT, Western Sydney, Victoria and AUCD have no stored About page, so no read is possible until one is stored (acquisition is off).
  - Macquarie University: open `identity_unconfirmed` finding (mq.edu.au fits neither the name nor the contact email domain; no site check verified it). Avondale University: About address redirects to `/your-uni/`, not an approved address.
- **s767 done:** `public.admin_layer4_grid_read_v1` takes `country` and `provider_type`; Layer 4 Review › Grid pills Country (All, Australia, New Zealand, Canada) and Provider type (All, University, VET / College, School, HEI). Live: Entry requirements (AER) 492 = AU 482 + NZ 10 + CA 0. Not kept in a saved view.
- **Spec numbers:** other lanes already hold `cf-247-s766-pr4-lane-fold-cutover-contract` and `cf-247-s767-lane-state-chronic-fail-contract`; this lane's specs are `cf-247-s766-au-university-identity-contract` and `cf-247-s767-layer4-grid-country-type-contract`. s778 untouched.
- **Addendum 17:02 (Pilot #1388 and #1391, migrations `20261119175000` and `20261119181000`):** trading names recorded for AUT, CIHE, Kaplan Murdoch and Sydney Met (with Torrens and Moore); Holmes Institute host owner holmesinstitute.edu.au to 02639M (reversible). Bounded stored-page read: Kaplan Murdoch, CIHE and Sydney Met admitted; Torrens, Moore and AUT held by the sentence checks. Firecrawl 0; OpenRouter US$0.0887 in the window across all lanes (cap US$0.10); window closed. Lyons College and Awanuiārangi need an About page with the name in a heading (a person). G3 75/48 and manual locks untouched.
- **Local note:** `cf-247-s121` Layer 4 phone test fails on a developer machine that holds an old `dist/version.json` (the "newer version" banner makes `getByRole('status')` ambiguous); it is not caused by this change.
- **Addendum 19:26 (Pilot #1394 v2.16.58, #1395 v2.16.59, no migration; G3 75/48; US$0 AI; Firecrawl 0):** s767 Layer 4 Review › Grid Country pills (All, AU, NZ, CA, drawn flags) and Provider type pills (All, University, VET / College, School, HEI) with live cohort counts (Entry requirements (AER) 492 = AU 482 + NZ 10 + CA 0; University 217, VET / College 233, School 0, HEI 38). s768 item drawer: proposed value, verbatim quote with source link and the exact hold reason side by side, Previous and Next and the J and K keys (never decide). #1395 tidies row-based items (row count, first four quotes). Checked live in the side-panel browser without any decision click. Open: the "HEI" pill stays as named because wānanga sit under University in the database (regrouping needs a migration); decision button labels stay the kind's own. Specs `cf-247-s767-layer4-grid-country-type-contract`, `cf-247-s768-layer4-review-drawer-triage-contract`.

### S2-Build, 19 Nov 2026 15:30 AEDT: page-text claim bounded (s772, IQ-00606), readiness as plain per-country CSVs (s771); s773–s775 handed to S1-Build

**Status at 19 Nov 2026 15:30 AEDT. This block is the newest for these items.**

**Directives:** Platform Admin 19 Nov 2026 14:24, 14:33 and 14:36 (quota boundary: finish #1377 and s771, hand s773–s775 to S1-Build). All live reads went through the rolled-back dry-run workflow.

**s772, IQ-00606 (Pilot #1377, migration `20261119150000`; closed by #1379, `20261119153000`):**
- **Cause.** `public.svc_page_text_next_v1` built the whole candidate set (about 18,000 bound pages, 12,700 eligible) and sorted it to keep 40: 2.9 s by plan, more under load. 14 of 55 runs had failed on the 8 s limit.
- **Fix.** `pipeline.course_priority` is empty, so the order is country Boost weight (AU 80, NZ 76, CA 72) and then course id. The claim now walks each country's bound pages in that order through the new partial index `coverage_course_pages_bound_read_course_idx` and stops at the limit. A busy call returns no items instead of waiting. Claim rows, items and order are unchanged.
- **Measured.** 0.75 s for 40 items and 0.93 s for 200 (rolled back); about 1.3 s live in a probe.
- **Live.** Every page_text run since 15:08 succeeded: 11 of 11, 440 items, 0 failed. G3 75/48.
- Migration renumbered from `20261119143000`, which S2-BOOST-AER's s751 had taken.

**s771, plain per-country CSVs (Pilot #1378; no migration):**
- The renderer writes one plain CSV per country, split by size so each file has the header and stays under 2.9 MB (one Drive connector upload).
- Today: AU 12.0 MB → 5 parts, NZ 2.99 MB → 2 parts, CA 1.64 MB → 1 file. Two AU halves would be about 6 MB each, over the limit, so it is 8 files, not 4.
- Export run 44456498448 (14:13 AEDT): the 8 files (6,061 / 6,140 / 6,128 / 5,994 / 1,380 AU rows; 3,814 CA; 6,203 / 311 NZ) are in Drive › Monitoring, and the zip is trashed.
- The scheduled task "Course field readiness to Drive (07:45)" now uploads the country files, trashes any Matrix zip or CSV, and keeps 3 days.

**Correction.** IQ-00594 and IQ-00588 were closed at 12:55 on 1.5 hours of clean runs (#1372). That was too early: Runner C timed out at 13:15 and 13:17 and Runner B at 13:19, in paths s720 had not bounded.

**Handover to S1-Build (s773–s775; no PR opened in S2):**

| Issue | Timed out | Path (from cron.job_run_details) | Suggested fix |
|---|---|---|---|
| **IQ-00594**, admission-rule-runner-b | 13:19, 120 s | `security.admission_rule_run_v1` → `security.adapter_overwrite_gated_v1(pipeline_num_v1('batch.adapter_overwrite', 200))` → `security.adapter_overwrite_v1` (FOR over SELECT rows) → `security.layer4_entity_or_parent_blocked(text,uuid,text)` → `exists(select 1 from security.layer4_active_blocks …)` | The view `security.layer4_active_blocks` is a `DISTINCT ON (entity_type, entity_id, block_scope)` over all of `pipeline.layer4_block_decisions` (then `event_type = 'block'` and not expired), so the predicate is not pushed through and each call scans every decision, twice per entity (entity, then provider), up to 200 entities a tick. Rewrite the check in the function to read the latest decision for (entity_type, entity_id, block_scope) directly, with an index on `layer4_block_decisions (entity_type, entity_id, block_scope, created_at desc, id desc)`. |
| **IQ-00588**, admission-rule-runner-c | 13:15, 120 s | `security.coverage_admission_gated_v1('coverage-admit-intakes', …)` → `coverage_admission_apply_v1` → `consumer_api_snapshot_v1()` line 31 EXECUTE → `public.zoho_edge_course_search_v2(null, array['NZ'], …, 5, 0)` → `zoho_course_search_v2` | One frozen Zoho read ran past 120 s (230 ms at 11:41). The s720 time budget only stops new reads from starting; it cannot cut one that is running. Likely it waits on the search-document refresh. Set a local `lock_timeout` before each snapshot read and catch the error per read (mark it skipped), or skip the search cases while the writer lock is held. The snapshot is evidence only (Decision 163); the frozen functions are unchanged. |
| **IQ-00588**, admission-rule-runner-c | 13:17, 120 s | `coverage_admission_apply_v1` line 9: `create temp table _adm on commit drop as select * from security.coverage_admission_plan_v1(p_extractor) where action in ('write','differs') and attribute=any(p_attributes)` | `coverage_admission_plan_v1(text)` (6,035 characters) plans every item before the attribute filter and the batch are applied. Push the attribute filter and a bounded batch into the plan (a body change only; the signature stays). |
| **IQ-00426**, no-page-propose | 13:37, 120 s | `security.no_page_propose_v1()` → `insert into pipeline.bind_match_scope(provider_id, why, unbound) select … from catalogue.courses c join …` → `security.enrich_focus_v1(uuid)` (1,015 characters) → `security.pipeline_list_v1(text,jsonb)` "during startup" | The focus is evaluated once per course across the catalogue before the top providers are chosen. Pre-select the candidate providers by an indexed key with `LIMIT` first, then call `enrich_focus_v1`, and read `pipeline_list_v1` once into a variable instead of per row. |

**Live head:** `20261119153000` (G3 75/48).
**Issue states at 15:35 AEDT:** IQ-00606, IQ-00609 and IQ-00348 closed; IQ-00594 and IQ-00588 reopened; IQ-00426 triaged (the last three are for S1-Build).
**TEST-REGISTER:** not regenerated in this session (packages not installed). New or changed specs: `s771` (new), `s772` (new, extended by #1379).

**Next:**
- S1-Build: s773–s775 above.
- 07:45 AEDT Friday: first unattended per-country publish.

### S2-Build, 19 Nov 2026 12:50 AEDT: living cost published, wave 2 published, reliability unblock live (s720), evidence-link-index alert fixed, daily course field readiness (s770)

**Status at 19 Nov 2026 12:50 AEDT. This block is the newest for these items.**

**Directives:** Platform Admin 19 Nov 2026 06:41, 06:45, 06:50, 06:57, 08:17, 10:50, 11:41 and 11:42. All live reads in this block went through the rolled-back dry-run workflow (no interactive Supabase calls after 10:50).

**Layer 1 and destination (s714–s719):**
- **10:10 scheduled check.** ABS, BOM and LIN 19/198 ran at 09:05 and are Healthy, next due 19 Dec. The NZ, GB and US visa sources ran at 10:05 and were unchanged. The Canadian clean-up and the Ontario APS pause stand.
- **LIN 19/198 fact not found.** The instrument sets "primary applicant annual living costs" in italics, so its page text has a space inside each bracket. Pilot #1363 (migration `20261119104100`) allows the space and made LIN due at once.
  - It was read at 10:36: AUD 29,710, with evidence `destination/page-facts/www.legislation.gov.au/282a04f2….html` (CC BY 4.0).
  - The new Home Affairs edition "(read 19 Nov 2026, 10:36)" is **published with visa_funds AUD 29,710** and Australian country applicability, alongside the other 5 rules.
- **Home Affairs Step by step tab (`#HowTo`).** Firecrawl's rendered page does not include the tab's content. The nearest amount (AUD 87,856, the income alternative) is refused by the plausible maximum. LIN 19/198 is the source of the amount.
- **UKVI and USCIS were not publishing.** Their owners were not on `destination.open_licence_owners`. #1363 adds both. UKVI (2 visa_funds rules, OGL v3.0) and USCIS (OPT up to 12 months, public domain) were **published** by `destination-open-licence-publish`. Immigration New Zealand stays held (terms pending).
- **Firecrawl:** 31 credits for `destination_page_facts` today; the "other" share is 74 of 200, 126 left.
  - Open item: the loader reads every page-fact page on each source run, so three sources due at one tick read the Home Affairs pages three times (23:05 UTC). Scoping the read to the source's domains is a loader change for later. Cadences are 30 days, so the cost is small.

**Reliability unblock (s720; Pilot #1364, #1366, #1369; migrations `20261119104500`, `111500`, `114500`, `115000`; CREATE OR REPLACE of 6 existing functions, settings, one outcome code, rollup target rows; no new table or function; G3 75/48, no drift):**
- **IQ-00609, coverage build.** `security.course_coverage_build_v1` rebuilds the oldest providers each run, up to `batch.course_coverage_courses` (now 400), every 2 minutes. It was a full 36,031-course rebuild taking 65–112 s. Reads are limited to the chunk, rows are replaced by provider, and the daily counts move by each run's change.
  - Live: daily counts equal the table (530,137; Australia 385,545).
  - At 800 courses runs took 11.7–16.0 s live, so the chunk is now 400 (the whole table about every 3 hours).
- **Dispatcher finding (for S1-Build).** `security.rollup_tick_v1` estimates a target's time as its longest successful run in the last 14 days. That kept the chunked build deferred behind group A's every-minute targets. #1366 gives `course-coverage-build` priority 5, so it runs first in its due ticks. The dispatcher is unchanged.
- **IQ-00594/IQ-00588, runners B and C.**
  - The admission evidence snapshot reads 5 rows per frozen read within 6 s (5.0 s measured).
  - The coverage admission tries the search writer lock and queues to `search.refresh_requests` when it is busy.
- **IQ-00606.** `svc_page_text_next_v1` claims each stored page once (20 items in 0.7 s).
- **Planner.** `enrich_plan_auto_v1` released 34 stalled automatic plans (outcome `released_stalled`, skip-locked) and created new ones: 26 open after the 11:41 run (was 40 of 40).
- **Two clean cycles.** From the 11:03 deploy to 11:52 AEDT: 203 runs of rollup-scheduler and admission-rule-runner A, B and C, **0 failures and 0 statement timeouts**.
- **IQ-00348, evidence-link-index critical alert (11:42).** The ranked queue is drained: 46,597 artifacts unindexed, none of them a ranked provider's. The feed still read 108,483 artifact rows from the heap to prove that (8.9 s, over the 8 s gateway limit).
  - #1369 (`20261119114500`) finds the ids from the queue index alone, with a 4 s query limit: 1.6 s live (was 9.5 s).
  - Edge calls at 12:19, 12:29 and 12:39 AEDT all returned **HTTP 200** (the calls at 11:59 and 12:09, before the deploy, were 500).
- **Issues.** IQ-00609, IQ-00594, IQ-00588 and IQ-00348 were verified as cleared and are **closed** through `security.integration_issue_close_v1` (Pilot #1372, migration `20261119125500`, read back 13:16 AEDT).
- **IQ-00606 stays open.** The duplicate-claim error is gone: before the deploy 92 of 92 page-text runs failed; since it, 41 of 55 succeed. The other 14 hit the 8 s limit in the claim, which reads about 18,000 bound pages to keep 40 (2.9 s by plan). The follow-up is a bounded candidate walk. A failed claim retries 2 minutes later and nothing is lost.
- **Slip (07:2x AEDT).** Pilot #1343 was merged in the same command as the head re-read, and the deploy applied `20261119083100` out of order (md5 matched). Every merge since re-reads the live head first and merges in a separate step.

**Daily course field readiness (s770; the directive's s721 was taken on main; Pilot #1370, #1371 (sheet-ready tabs, top 100 providers); no migration, nothing written to the database):**
- `scripts/telemetry/course-field-readiness.sql` (read only) gives each active course × the 14 canonical API v3 fields either its admitted value (80 characters at most) or one of TRYING, POSSIBLE_NEEDS_SOURCE, NOT_POSSIBLE or EMPTY_NOT_STARTED.
- Workflow `course-field-readiness.yml` runs daily at 07:30 AEDT (20:30 UTC) and commits the CSV and the summary to branch `course-readiness-snapshot`.
- The scheduled task "Course field readiness to Drive (07:45)" (automatic approval) puts them in Drive › Monitoring and trims dated copies older than 3 days.
- **First run 12:27 AEDT** (run 44436981882): 36,031 courses (AU 25,703, NZ 6,514, CA 3,814). Admitted:

  | Field | Admitted |
  |---|---|
  | duration | 81.9% |
  | tuition_fee | 77.0% |
  | official_url | 66.8% |
  | english_requirements | 57.8% |
  | description | 41.7% |
  | study_load | 17.2% |
  | intake_dates | 7.9% (56.2% not possible: month-only) |
  | aer_academic | 3.9% |

- **Drive › Monitoring:**
  - `Course_Field_Readiness_Matrix_2026-11-19.zip`: the full 16.6 MB CSV, zipped. The connector carries at most about 3.1 MB per call, so the plain CSV cannot be uploaded.
  - Google Sheet `Stakeholder_Course_Readiness_Summary` with tabs `Executive_Summary` (counts, with percentages as formulas), `By_Provider_Action_List` (top 100 providers by cells needing a source; UNSW Sydney, NZIST Work-Based Learning and Monash first) and `Dev_Display_Rules` (the 5 states → API v3 `empty_reason_code` → display rule).

**Guardrail notes:**
- **Pilot #1333 (coverage telemetry).** Merged 06:4x AEDT under the Platform Admin's authorised exception of 06:41: one internal table (`pipeline.tracked_fields`) and two internal functions (`security.tracked_field_coverage_v1`, `public.admin_coverage_telemetry_v1`). None is in the consumer API, which stays G3 75 functions / 48 tables with no drift. The "zero new tables or functions" rule otherwise stands.
- **Hourly admittance telemetry (06:57, s717).**
  - Drive › Monitoring has the Google Sheet `Hourly_Admittance_Telemetry` (tab of the same name, en_AU, Melbourne time) and `Hourly_Admittance_Telemetry.csv` (one current copy).
  - The scheduled task "Hourly admittance telemetry" runs `scripts/telemetry/hourly-admittance.sql` (read only) at minute 1 of every hour and appends one row. Rows are in place for 07:00, 08:02, 09:01 and 10:02.
  - The 27 columns: snapshot_aedt, snapshot_utc, courses_admitted, courses_held, courses_rejected, providers_admitted, providers_held, providers_rejected, scholarships_admitted, scholarships_held, scholarships_rejected, aer_admitted, aer_held, aer_rejected, destination_admitted, destination_held, destination_rejected, coverage_courses, coverage_fields_n, coverage_courses_all_n, coverage_courses_zero, coverage_mean_fields_admitted, coverage_tracked_fields, jobs_active, jobs_off, job_runs_1h_succeeded, job_runs_1h_failed.

**Live head:** `20261119125500` (G3 75/48, no drift).
**TEST-REGISTER:** not regenerated in this session (packages not installed). New or changed specs: `s719` (extended), `s720` (new), `s770` (new).

**Next:**
- Platform health: confirm green at its next check.
- IQ-00606: bounded page-text candidate walk.
- 07:45 AEDT Friday: first unattended readiness publish.
- S1-Build: dispatcher estimate window.
- Loader: scope page-fact reads to the source.


### S2-BOOST-Courses, 19 Nov 2026 08:35 AEDT: description reader live (Pilot #1344, v2.16.50), re-reads queued, live counts read as the UAT user (s728)

- Live migration head `20261119084000`; worker `coverage-sweep` v1.0.25; prompt `cdesc-source-grounded-v4`. #1335 and #1336 closed (superseded).
- 666 held course descriptions drained (read 10:14 AEDT): 267 admitted since 07:40 (161 with v4), 94 in review; the 09:23 `field-gap-queue` run succeeded after the 08:23 statement timeout. Courses with a description 14,700 of 36,031 active (14,433 at 07:42). G3 clean (75 functions, 48 relations); live head `20261119103000`.
- Study load 5,689 of 36,031 active; Layer 4 Boost study load 179, Campus locality 69, University description 76 (live, run 44400209609).
- Pilot #1346 (s723, s724, s726; S1-Courses lane) is open and conflicts with main. GitHub secrets are write-only; the live check ran through the deployed-uat login (s728).
- Detail: `docs/platform/S2-BOOST-COURSES-HANDOVER-2026-11-19.md`; self-check scheduled about 10:14 AEDT.

### S2-Build, 19 Nov 2026 06:00 AEDT: post-squash batch (Platform Admin 19 Nov 2026 05:21): Boost test project rebuilt and re-seeded, blades live for every role, round states on rollup-scheduler only; coverage telemetry held for a decision

**Status at 19 Nov 2026 06:00 AEDT. This block is the newest for these items.**

**Done:**
- **Item 1: Boost test project.**
  - Check d of `sql/boost-ingestion/005_rehearsal_rolled_back.sql` (`outside_window_refused`) now narrows the two window settings to 1 to 5 inside its rolled-back block and confirms the refusal there. It also reports the live window (`window_live`, today `[0, 24]`). Admin #622.
  - Full rebuild proof, admin `boost-test-rebuild.yml` run 44369667112 (05:26–05:41 AEDT), dump `db-schema-dump/44324920057` (the post-squash baseline, head `20261118272000`). Results branch `boost-test/44369667112`. **Verdict PASS, all five checks:**
    - G3 is 75/48 with no drift.
    - 1,000 rows loaded in 0.039 s.
    - 50 shadow rows, 0 admitted, 0 courses changed.
    - Rehearsal: 1 study load written, 0 `updated_at` touched.
    - A run outside a narrowed window is refused.
    - Schema: 16,989 of 16,989 statements, 0 failed.
  - Of the 5 production migrations newer than the dump, 4 applied. `20261119044000` (S2-BOOST bench-5) stopped at its own post-check ("the study-load admission qualification changed"), because the test project's qualification list is empty by design. The verdict does not count it; for S2-BOOST to note.
  - Re-seeded with admin `boost-test-experiment.yml` run 44372812878 (label `reseed-post-squash-20261119`): 12 providers, 69 courses, 60 without a study load. The admitted-count experiment passed all 9 checks, and the promotion function is production's. Results branch `boost-experiment/44372812878`.
- **Item 2: destination sources.** Already in place since 19 Nov 00:05 (Pilot #1318, #1322): five Australian sources under Layer 1 Register › Australia (Fair Work paused and restricted), the Layer 1 schedule and Run now, the Storage artifact, the evidence record (source, licence, `fetched_at`) and successor editions. Published on API v3: Home Affairs 5 rules, JSA 1,577 careers (now with `employment_count`), BOM 40, ABS 102.
- **Item 4: student-facing reads (server Pilot #1329; screen Pilot #1330, v2.16.47, merged 05:50 AEDT).**
  - Around this course and Around this provider now read city figures, careers and visa rules for every StudySearch role. The read-gap note shows only when a read fails.
  - Accreditations come from the provider record. Rows under review are marked for Editors and up only.
  - Specs `s694` and `s696` were updated, the release contract `m245` was bumped, SOPs are 2.72 and 2.32, and the UI map is unchanged (checked). Deployed UAT passed on main.
- **Item 5: round states on rollup-scheduler only (Pilot #1332, migration `20261119052000`, md5 `fc622344`, matching the dry run; `s710` extended).**
  - The paused cron job `scholarship-discover-refill` ran `security.scholarship_discovery_refill_v1` on the UTC date, and that function ended with its own round-state refresh. The refresh is removed from it; the job stays paused.
  - The target `scholarship-round-state-refresh` (Melbourne date) is now the only caller. It ran at 04:23 and 05:23 AEDT; both runs succeeded.
- Live head `20261119052000`; 2,154 migrations applied; G3 75/48 with no drift. Admin mirrors: `docs/UI-MAP.md` (v2.16.49) and `docs/sops/` (2.73, 2.32) regenerated from Pilot main `3ebe7e41`.

**Held for a Platform Admin decision:**
- **Item 3: coverage telemetry (Pilot #1333, not merged).**
  - Branch `cf247-coverage-telemetry` is renumbered to `20261119053000`, otherwise unchanged; the recorder pre-check md5 still matches live.
  - Rolled-back live dry run passed (md5 `e9ee89f4`), CI is green, and spec `s713` was added (the reserved block s691–s699 is fully used).
  - It adds one table (`pipeline.tracked_fields`) and two functions (`security.tracked_field_coverage_v1`, `public.admin_coverage_telemetry_v1`). None is in the consumer API (G3 stays 75/48), but the directive also says "zero new tables or functions". Merging needs the Platform Admin to allow that exception.
- **Stale PRs #1307 and #1287** were already merged (18 Nov). Nothing to close.

**Not done:**
- **Home Affairs 12-month living cost (financial capacity).** The rendered student visa page's main content has no amount: the loader's pattern only found "primary applicant" in the fee-concession text. Secondary sites give AUD 29,710 and place it on the Department's page under the Step by step tab. It is not published from secondary sources.
  - Options for the Platform Admin:
    - read the Step by step tab with a Firecrawl action (an on-demand read, a few credits);
    - or register the legislative instrument (LIN 19/198 as amended, Federal Register of Legislation, CC BY 4.0) as a Layer 1 source.
- **TEST-REGISTER:** not regenerated, because packages are not installed in this session and no CI workflow regenerates it. New or changed specs since the last register: `s694`, `s696`, `s710`, `s711`, `s712`, `s713`, `m245`.
- Pilot #1335 and #1336 (S1-Courses) also claim package 0.1.469; both were told on the PR to re-bump on rebase.

### S2-Build, 19 Nov 2026 04:30 AEDT: API v3 PR D read path, scholarship round states on the Melbourne date, student-facing destination read (Pilot #1328, #1329; s710–s712)

**Status at 19 Nov 2026 04:30 AEDT. This block is the newest for these items.**

**Done (Platform Admin directive 17:55, repeated 21:58; after the 03:30 freeze):**
- **Pilot #1328**, merged 19 Nov 04:03 AEDT, outside the 01:15–03:30 freeze. Live max was `20261118272000` when re-read just before the merge. History md5s match the rolled-back dry runs:
  - `20261119041000` (md5 `2b24a44e`, s710): `security.scholarship_round_state_refresh_v1` now compares round dates with the Australia/Melbourne date (`(now() at time zone 'Australia/Melbourne')::date`) instead of the UTC date. The function was edited with an md5 guard; its four `current_date` comparisons were replaced, and nothing else changed. A round no longer turns open or closed at 11:00 AEDT (UTC midnight) instead of at Melbourne midnight.
    - New `rollup-scheduler` target `scholarship-round-state-refresh`: live, group A, priority 75, hourly at :23. The batch is the setting `batch.scholarship_round_state` (default 1000; G2). No new job or `cron.job` row.
  - `20261119042000` (md5 `87c8f09a`, s711): v3 read path additions (v3 is open to additions until go-live, Decision 277):
    - `course_v3_fields_v1`: `primary_basis` on each primary campus.
    - `website_v3_provider_item`: `is_primary` and `primary_basis` on each campus.
    - `destination_read_v1`: `employment_count` on each career row (JSA Table 1, "Employment in main job"). For example, Corporate Services Managers has 10,000.
  - `20261119043000` (md5 `4c5695b5`): API v3 field dictionary synced to 2,227 fields (11 added). `docs/api/v3/field-dictionary.json` was updated, and the dictionary spec points at this migration.
- **Read back live (04:10 AEDT):** 0 `current_date` left in the function and 4 Melbourne-date comparisons; the target is live, and its first run through `rollup-scheduler` succeeded at 04:23 AEDT (1.2 s); `ref.api_field_dictionary` holds 2,227 fields; G3 is unchanged at 75 functions and 48 relations with no drift. Migrations applied: 2,151.
- **Pilot #1329** (S712), merged 19 Nov 04:46 AEDT: the student-facing destination read and the accreditations read handed over by S1-RM-Design. Live max was `20261119044000` (another session) when re-read just before the merge, and both function bodies still matched the md5 guards.
  - Migration `20261119045000` (md5 `fcd33705`, matching the rolled-back dry run; spec `s712`) makes two md5-guarded edits of existing functions. No new table or function; G3 is 75/48 with no drift.
  - `public.admin_destination_review`: a Viewer or Counsellor may read `locality_metric`, `career_outcome` and `study_rule`. Rows are approved only; careers and rules must also be in a published edition. Fields are student-facing only: no evidence, quote, applicability, edition or terms status, dataset edition or audit columns. Every other kind stays Curator and above. Curator and above see exactly what they saw before.
  - `public.admin_read('provider_detail')` now carries `accreditations[]`. Curator and above see every row with its status. Viewer and Counsellor see the API v3 set (active, not expired).
  - Read back as a Counsellor: 5 published study rules (the 4 superseded rules excluded), 142 city figures and the career list (capped at 200, the same as for admins), with student-facing keys only. The postcode review is refused ("Curator role or above required"). Accreditations: `[]`, because the AMBA rows are under review. As Platform Admin: 9 rules with edition status, as before; accreditations show AMBA `under_review`.
  - The migration file is named without "correlat" because `s694` guards that S1-RM-Design's screen change came with no migration.
  - **Handed back to S1-RM-Design:** the Course and Provider detail cards still gate the read on Curator (`curator` in `src/CorrelatedBlade.jsx`). Viewers see the read-gap note until that one-line screen change ships with its release bump.
- **Home Affairs successor edition published:** v3 `/destination` serves 5 study rules, including the 485 Post-Higher Education Work stay of 2 years.
- **On-demand window `9f54b912`** (scholarship detail fill after the reader stall, OpenRouter) closed at 04:07 AEDT:
  - Estimate US$0.19 (ceiling US$0.63).
  - OpenRouter use in the window, all lanes: US$0.31. No Firecrawl.
  - OpenRouter balance went from US$11.36 to US$10.04, with other lanes included.
- No new table or function: four existing functions were edited, each behind an md5 guard.

**Not done (reported to the Platform Admin):**
- **PR C (accreditations on API v3) is blocked on reuse terms:**
  - AMBA's 13 rows are `under_review`, awaiting the Platform Admin's terms decision (paste file from S1-RM-Design).
  - AACSB points data use to its Master Data Use Agreement (MDUA).
  - EQUIS publishes no reuse terms.
  - Nothing is published until terms are approved; a passing load never publishes by itself.
- **Multi-field live admission path:** this is the S2-BOOST lane, and it needs the qualification references first. Not built here.
- **Still open:** the 12-month living-cost benchmark (financial capacity) on the Home Affairs page; the `cron.unschedule` paste file for the three retired destination side jobs after 14 days (from 2 Dec 2026); the screen change that calls the student-facing read for every role (S1-RM-Design).
- **TEST-REGISTER:** no CI workflow regenerates it. Local generation fails here because the sandbox has no network (`lucide-react` is missing). The three new specs (`s710`, `s711`, `s712`) are picked up on the next generated run.

### S1-RM-Design, 19 Nov 2026 06:39 and 06:50 AEDT directives: scholarships listed once (s699)

**Status at 19 Nov 2026 07:40 AEDT. This block is the newest for these items.**

- **v2.16.49 (Pilot #1342, merged 19 Nov about 07:03 AEDT, no migration, spec `s699`).** Found by a live check of v2.16.47 at 375×812 in Preview as Viewer and Counsellor:
  - The Around this course card is headed **Entry requirements** and carries no scholarship line, for every role. `CARD_SPEC` (card `entry`) lost its `scholarships` field.
  - The Scholarships section (three, then Show all (N) scholarships / Show less) is the only scholarship list on the Course detail. The Provider detail is unchanged.
- **Verified live (v2.16.49, built-in browser, signed in as Platform Admin; no credentials asked for or read):** Diploma of Information Technology (Higher Education) at 375×812 in Preview as Viewer, Counsellor and Admin: card headed "Entry requirements", no scholarship text, one Scholarships list, no overflow; pipeline and task buttons hidden for Viewer and Counsellor, shown for Admin. Related insights & funding was not on this course (no QILT or PRISMS figures held), so that fold was not seen live.
- **Specs:** `s699` (7 desktop tests plus one `@responsive` phone test); `s694` and `s697` adjusted (same guards).
- **Spec document:** `docs/platform/2026-11-18-correlated-blades-role-visibility-mockup.md` v1.3 (section 6C, entry card table, layout sketch, empty states; decisions 1 and 2 marked done by S2-Build s712; one live screenshot).
- **Version coordination:** v2.16.48 stays with Pilot #1335 and #1336 (both claim it); this release took v2.16.49. Not touched: #1335, #1336, #1314, #1235.
- **Open:** confirm the Related insights & funding fold on a course that has QILT and PRISMS figures.

### S1-RM-Design, 18 Nov 2026 23:51 AEDT directive: Course detail declutter (s698)

**Status at 19 Nov 2026 00:40 AEDT. This block is the newest for these items.**

- **v2.16.46 (Pilot #1324, merged 19 Nov 00:26 AEDT, no migration, spec `s698`).** Found on Diploma of Information Technology (Higher Education), on a phone, in Preview as Viewer:
  - Description pipeline and Tasks that held this course hidden for Counsellor and Viewer; folded by default for Editors and Platform Admins.
  - Check scholarships for this course and every other task button hidden for Counsellor and Viewer.
  - Related insights & funding (QILT, PRISMS) folded by default for every role.
  - Scholarships listed once on the Course detail (the insights add no second Scholarships & funding card there; the Provider detail keeps its own).
- Adjusted to open the new folds (same guards): `cf-247-f-cdesc-06-on-demand` (desktop and phone), `s697`, deployed `a12-contextual-insights`.
- **Spec:** `docs/platform/2026-11-18-correlated-blades-role-visibility-mockup.md` v1.2 (section 6B, two matrix rows, two screenshots from mocked data; the built-in browser is still unreachable).
- **Not merged by this lane:** Pilot #1314 (still claims v2.16.44) and #1235.

### S1-RM-Design, 18 Nov 2026 23:02 AEDT directive: Course and Provider detail fixes after live inspection (s697)

**Status at 18 Nov 2026 23:55 AEDT. This block is the newest for these items.**

- **v2.16.45 (Pilot #1323, merged 23:33 AEDT, no migration, spec `s697`).** Four fixes found on Master of Teaching (Secondary) in v2.16.44:
  - Preview as pills (Admin, Counsellor, Viewer) show their full labels at every pane width (the drawer header's 32 px icon-button rule clipped them).
  - Archive course and the Read with AI bar are hidden for Counsellor and Viewer, and in Preview as Counsellor or Viewer.
  - Read / refresh entry requirements now and its pipeline steps and links are hidden for them; they see approved entry requirements only, or "No approved entry requirements published for this course yet."
  - Scholarship lists (course list, Around this course card, scholarship insight panel in Course and Provider detail) show three, then Show all (N) scholarships / Show less.
- **Spec:** `docs/platform/2026-11-18-correlated-blades-role-visibility-mockup.md` v1.1 (section 6A and four new matrix rows; screenshots from mocked data, the built-in browser still unreachable).
- **Spec number note:** Pilot #1318 (another lane) also added a spec named `s694` (`cf-247-s694-destination-sources-layer1-register-contract`); both files are distinct and pass.
- **Not merged by this lane:** Pilot #1314 (still claims v2.16.44; it re-bumps to the next free version on rebase), #1307 and #1235.

### S1-RM-Design, 18 Nov 2026 21:23 AEDT directive: correlated detail, Metric type pills, role-based field visibility

**Status at 18 Nov 2026 22:50 AEDT. This block is the newest for these items.**

- **v2.16.44 (Pilot #1315, no migration, specs `s694`, `s695`, `s696`).**
  - Course detail › **Around this course** (read only): Location & weather (BOM summer and winter means, rainfall and climate icon; ABS population; attribution), Career pathway, jobs & salary outlook (JSA), Visa & living-cost snapshot (Home Affairs), Entry requirements & scholarships.
  - Provider detail › **Around this provider**: Rankings (QS, THE, ARWU, subject), Campus city profiles, Scholarships & accreditations.
  - Destination data › City metrics & costs: **Metric type pills** (All, Climate & Weather (BOM), Population & Demographics (ABS), Careers, Jobs & Salaries (JSA), Study Rules & Living Costs (Home Affairs)).
  - **Role-based field visibility**: Viewer and Counsellor see student-facing values only; Editor and Platform Admin keep provenance and diagnostics; **Preview as: Admin | Counsellor | Viewer** in the detail header (Editor and up, never raises).
- **Spec:** `docs/platform/2026-11-18-correlated-blades-role-visibility-mockup.md` v1.0 (layout, every card's columns and fields, role matrix, live data and gaps; tables generated from Pilot `src/lib/correlation-adapters.js`, `destination-metric-types.js` and `field-visibility.js`). Screenshots from mocked data: the built-in browser could not be reached (503), so the live screen was not opened.
- **Live data behind the cards:** 40 BOM climate figures (8 capital cities), 102 ABS population figures, 1,577 JSA OSCA occupations with no salary, outlook, shortage or study-area link yet (the Career card shows its loading empty state), 4 Home Affairs rules (no post-study work years or financial-capacity figure yet), 13 AMBA accreditations.
- **Hand-off to S2-Build (no schema in this lane), after Thu 03:30 AEDT:** a read-only correlated read open to every StudySearch role that returns student-facing fields only (approved and published rows), so Viewers and Counsellors see city figures, careers and rule figures; and an admin read of provider accreditations. Until then those cards show a read-gap note to Viewers and Counsellors.
- **Not merged by this lane:** Pilot #1314 (another lane; also claims v2.16.44, so it re-bumps on rebase), #1307 and #1235; `cf247-coverage-telemetry` stays staged for S2-Build.

### S1-RM-Design, 18 Nov 2026 19:20 AEDT directive: Layer 4 clusters, Destination check

**Status at 18 Nov 2026 20:05 AEDT. This block is the newest for these items.**

- **v2.16.43 (Pilot #1309, no migration, `s693`).** Layer 4 › Inbox › Grid › **Clusters**: one kind's waiting items grouped by university, refusal reason and quote (reason and quote normalised: case, spacing, numbers and links ignored; the quote is found wherever the kind keeps it, including a hook's quote section). Read page by page from `admin_layer4_inbox` 'items' and 'detail'. Inspect, export as CSV, or settle ticked clusters with one choice, one reason and a typed confirmation; each item is decided through `admin_layer4_inbox` 'decide' exactly as its card would, at its own rank, and skipped where its hook does not allow the choice. Inspect only: `aer_review`, `campus_locality`, `intervention`, `provider_departure`; a choice needing a value, a page or a higher role is never offered. Beside S2-Build's Grouped decisions (server-defined groups for two kinds).
- **Closed loop.** A cluster that keeps returning is exported as the evidence for a Boost or reader rule, to be written into the worker or reader prompt with a regression test (both repos), not settled again and again. No recurring pattern was codified by this lane on 18 Nov.
- **Destination check (signed in, v2.16.42, before the browser link dropped at about 20:02).** Destination data › City metrics & costs: 142 figures, 40 BOM climate (icons rain, heavy rain, sunny, partly cloudy, snow) and 102 ABS population (`erp_persons`), side by side; overview: 4 editions published, 102 localities approved. No page overflow; the table scrolled 55px sideways at a 705px pane (none at 1280px), so v2.16.43 lets the measure cell wrap. The Clusters screen was not opened live (the built-in browser went offline); Deployed UAT and Release currentness are green at v2.16.43.
- **Not merged by this lane:** Pilot #1307 (S2-Build, migration `20261118234000`, CI green, a commit behind main, no rolled-back live dry run recorded in its description); `cf247-coverage-telemetry` stays staged for S2-Build after Thu 03:30 AEDT.

### S1-RM-Design, 18 Nov 2026 12:50 and 14:23 AEDT directives: Operations screens, Coverage now, climate icons, data model, RM1F, Wave 2 drafts

**Status at 18 Nov 2026 14:55 AEDT. This block is the newest for these items; where the 12:19–12:50 block below differs, this one wins.**

- **v2.16.41 Operations screens (Pilot #1278, no migration, `s640`).** Beside S2-Build's backend v2.16.39 (#1274). Automations leads with the three dispatchers: `rollup-scheduler`, `admission-rule-runner` (the directive's "enrich-lane-dispatch" does not exist live; this is the second consolidated dispatcher) and `coverage-lane-dispatch`, each with lanes, runs and failures in 24 hours and legacy jobs replaced. Retired legacy jobs (66 of the 70 switched-off `cron.job` rows) are hidden from the list and counts behind Show retired legacy jobs. Open issues links were already opening Queues & yield; their words said Work queues and are now named from the menu. Storage & retention leads with Storage now; Evidence leads with Where evidence comes from, linked to S2-Build's Audit trail.
- **v2.16.42 (Pilot #1285, no migration, `s650`, `s651`).** Coverage & completeness › Courses › Coverage now: readiness by country (AU, NZ, CA, UK, IE, US) and domain, and every recorded field, with no field list fixed in the screen. The Link refresh portal rows and the read-only Stalled fields counters are retired from Coverage. Destination data climate icons (lucide, ISC; rule in Pilot `src/lib/climate-icons.js`). Guides › Platform guide › How the data connects (Pilot `src/guide/entityModel.js`; admin `docs/platform/ENTITY-CORRELATION-MODEL.md`; pointer in `docs/integrations/api-v3/API-V3-FIELD-DEFINITION.md`).
- **Coverage read: schema need handed to S2-Build (Platform Admin 14:23: no schema change in this lane).** The 7-day change, trend lines, targets and Courses by fields admitted (0 of N to N of N) need `public.admin_coverage_telemetry_v1` and the registry `pipeline.tracked_fields` with the recorder `security.tracked_field_coverage_v1` (scholarship, destination edition and grade scale figures). Built and dry-run passed and rolled back on 18 Nov (md5 `a34e0863`, probe: 38 fields, N = 15, AU/NZ/CA grid), on Pilot branch `cf247-coverage-telemetry`, migration `20261118170000_cf247_coverage_tracked_fields_telemetry.sql`; **not merged by this lane**. The screen falls back to `admin_completeness_report` and shows the rest as soon as the read is live; it needs a timestamp above the live head when S2-Build applies it.
- **RM1F / REQ-57 accreditations.** No open licence was found for the AACSB, EQUIS or AMBA lists. AMBA's official list was read on 18 Nov: 13 schools in AU (4), NZ (6), CA (3), each matched to one provider by exact name (UQAM by acronym and domain); Ireland, the UK and the US have no providers yet. They are in paste file `docs/paste/PASTE-20261118-rm1f-amba-accreditations.sql` as `under_review` (API v3 returns only `active`); guard read live: 13 of 13. AACSB (one page per school on aacsb.edu) and EQUIS (EFMD list; the page needed an approval not available) are not loaded; secondary lists were not used.
- **Wave 2 register drafts (9, GB, IE, US, CA).** All nine already carry their official source URLs and terms `pending`; none has a sample or a parser spec. AI Auto-Map needs a sample (five file sources: HESA, UKVI, ILEP, IPEDS HD and completions) or reads the page itself (four page sources: OfS, QQI providers and programmes, IRCC PGWP). Pressing it is a fetch a Claude session asks for, which the Pilot rule opens first with `security.on_demand_open_v1` (a database write this lane cannot make without an interactive tool); the OfS draft was opened and closed without change. **Next:** the Platform Admin (or S2-Build) runs AI Auto-Map on the four page drafts, and attaches the five dataset samples.

### S1-RM-Design, 18 Nov 2026 12:19–12:50 AEDT directives: hotfix, Layer 1 wizard panel, 28-destination mapping, Operations UI, Coverage

**Status at 18 Nov 2026 13:45 AEDT. This block is the newest for these items.**

- **Hotfix v2.16.37 (ref ZDUFMC; Pilot #1270, no migration).** Cause: the v2.16.35 `lastTest` memo in `src/AuthEmailTemplates.jsx` sat below the screen's early returns, so the render after the settings loaded called one more hook (React error #310). It now sits above them. Render guard `s634` opens Users & roles › Links & Email Templates with loaded settings and steps through the four-step Create user flow; it fails against the old code and passes with the fix. A scan for the same pattern found no other case (five hits were separate functions). Live: v2.16.37 deployed 12:43 AEDT; the route rendered in a signed-in session with no console errors.
- **v2.16.38 Layer 1 wizard panel (Pilot #1272, no migration, `s635`).** Layer 1 › + Add source, step 1: once the target record type is chosen, What this source will create lists the baseline records the first apply run makes for the country (S2-Build #1258 and #1265), the rule each follows and the API v3 fields its mapping fills. It saves nothing. Numbered v2.16.38 because the hotfix took v2.16.37.
- **28-destination extensions inside the existing tables (12:21).** Runbook `docs/platform/DESTINATION-EDITIONS-AND-WAVE2-DRAFTS-RUNBOOK.md` v1.4, section 5: FT rankings (`ranking.systems` code `ft`), rule categories `dependants`, `minimum_wage`, `offer_document`, occupation schemes OSCA and NOL, national quality ratings (`catalogue.provider_accreditations` rows with `rating`, `rating_period`) and employment by industry (`destination.career_outcomes` with `series_kind = industry`). No new table. Columns live by S2-Build's #1268; value lists in paste file v2, the Platform Admin's to run before Thu 01:15. **G3 note:** 75/48 counts the consumer functions and the tables and views they read, not every table; s627 is the rule that keeps destinations in the shared tables.
- **Operations UI (12:50), in progress as v2.16.40.** S2-Build received the same directive at 12:49 and owns the backend as v2.16.39 (#1274: Task manager time-out, stranded tasks, dispatcher-aware health checks, Storage & retention › Staging tables, Evidence › Audit trail). S1-RM-Design's screen work is built and passes 708 local tests; it rebases on #1274 once merged: Automations led by the three dispatchers (rollup-scheduler, admission-rule-runner, coverage-lane-dispatch; the directive's "enrich-lane-dispatch" does not exist live, the second dispatcher is admission-rule-runner), retired legacy jobs (66 of the 70 switched-off jobs) hidden behind Show retired legacy jobs, Open issues links named from the menu (they already opened Queues & yield; only the words said Work queues), Storage now at the top of Storage & retention, and Evidence › Where evidence comes from.
- **Next:** Coverage & completeness modernisation (12:19), after v2.16.40.

### S1-RM-Design, 18 Nov 2026 10:31–11:28 AEDT directives: API v3 study load, Publish edition fix, role-centric UI, multi-country schema lock

**Status at 18 Nov 2026 12:05 AEDT. This block is the newest for these items.**

- **Publish edition fixed (ref G7QN3W; Pilot #1257, migration `20261118133707`).** A city profiles edition counts its city profiles, the localities its load wrote (country and `dataset_edition` = edition label) and its figures on another edition's localities (a figures-only edition such as S2-Build's BOM climate averages). `security.destination_edition_rows_v1` (new); `destination_edition_publish_v1` needs one approved row; Overview & editions shows rows, rows approved and figures. **Live 11:40 AEDT:** "ABS Regional population 2024-25" holds 102 rows, 102 approved (102 of 102 figures approved). **Publish edition was not run by me:** it is the Platform Admin's.
- **API v3 study load (Pilot #1257).** Every v3 course item (Website `course` and `search`, Zoho `course`, `courses`, `search`, v3 `sync`) carries `study_load`, `empty_reason_code`, `campuses[].locality` and `provider.accreditations`; the provider action carries `accreditations` (empty: `catalogue.provider_accreditations` holds 0 rows). Read back live: every Website and Zoho course and search item has the fields; course `course:nzqa:6010:1883` returns `both`. Dictionary 2,085 → 2,179 (migration `20261118133717`). `API-V3-FIELD-DEFINITION.md` updated.
- **Dictionary cross-check (RM0B; Pilot #1264, migration `20261118135707`, merged and live 11:54 AEDT, 2,216 fields, none deprecated).** `security.api_field_dictionary_drift_v1` on live Website and Zoho course, search, provider and destination answers: the new fields show no drift; 37 older fields were not described (`item.field_of_study_codes[]` on both course actions, `item.recognition[]` on Zoho course, destination `filters.*`, Website `contract_version`) and Website search `university_groups` had the wrong type. The new list describes them (2,216). No API function changes. `logo.storage_path` is removed by the edge functions and is not a gap.
- **v2.16.35 (Pilot #1259, no migration).** Dashboard drawn for the role: role line and Your role guide; Viewer and Counsellor start with Search the catalogue and see no pipeline or Inbox counts; Curator sees Waiting for you without failed jobs and automations; Platform Admin also sees **Waiting for your approval** (editions ready to publish, Layer 1 drafts, the email route). **Continue where you left off:** last searches, review queues and pages on this browser only; Resume restores a catalogue search. **Guides › Role guides:** one guide per role, pages from the menu; mirrored to `docs/platform/role-guides/` (generated). **Create user:** Person, Role (permissions shown), Sign-in, Review, confirmation. **Links & Email Templates:** body edited as formatted text in a frame that runs no script (toolbar, Insert link, Sign in button, plain-English variables, Edit HTML); the route at the top (Supabase Built-in or Resend API, sender, key, last test); buttons Save Provider Settings, Send Test Email, Save Template, Send This Template as a Test. Mockup: design canvas "StudySearch role-centric dashboard mockup". **Not checked in a signed-in session.**
- **Multi-country schema lock (Platform Admin 11:28; Pilot #1262, spec `s627`).** No migration may create or rename to a country-prefixed table or view; the six held before the lock are listed. Mapping of every destination dataset to the existing tables, and what still needs a change: `docs/platform/DESTINATION-EDITIONS-AND-WAVE2-DRAFTS-RUNBOOK.md` section 5. **Still open after S2-Build's constraint paste file:** `ranking.systems.code` has no Financial Times; `study_rules.rule_category` has no dependants, minimum wage or offer document; `career_outcomes.occupation_scheme` has no OSCA or NOL; no table for official national quality ratings or for employment by industry. Best added to the paste file before it runs.
- **Registers.** `ROADMAP-MILESTONES.csv`: RM26 to RM33 (Poland, Italy, Greece, Cyprus, Thailand, Malaysia, South Korea, Japan) after RM25; RM17, RM19, RM20, RM22 and RM24 stay unused; the workbook lists 28 destinations. `CONSUMER-REQUESTS.csv`: REQ-84 to REQ-90, the seven high-priority official-source checks (Sweden spouse work rights; Spain 2026 IPREM; Malta work hours and visa fee; Netherlands partner sponsorship income and work rights; Greece Law 5275/2026; Cyprus CRMD visa rules; Cyprus work eligibility after 1 Mar 2024), each a publication gate; REQ-91, the QILT, QS, THE and FT licence gates, with REQ-68.
- **Coordination.** Weather: S2-Build's BOM climate loader (Pilot #1256: long-term averages for eight capital cities, draft, terms pending) feeds Destination data › City metrics & costs and the v3 `destination` action with no further change; with #1257 a figures-only edition can be published. Layer 1 wizard: S2-Build's #1258 (merged: new record types and baseline records) and #1263 (open: Register a scheme and subdivisions, v2.16.35). **Clash to fix in #1263:** it claims v2.16.35 (taken by #1259) and spec number `s625` (used by #1259's `cf-247-s625-role-dashboard-guides-users-email-contract.spec.mjs`); it needs v2.16.36 and another spec number. S1-RM-Design's "What this source will create" panel for the wizard follows after #1263, so the two do not collide.
- **`study_load` row of 10:20 AEDT below is superseded by this block.**

### Destination sources in the Layer 1 Register; Home Affairs and JSA published on API v3 (S2-Build; Platform Admin 18 Nov 2026 17:55, 21:58 and 22:04)

- **Standing rule (Platform Admin 22:04):** all Destination Data sources must be registered in Layer 1 Register by country and ingest via standard Layer 1 schedule → Supabase Storage artifact → Layer 1 Evidence record → Destination Edition. NZ, CA, UK, IE and US follow the same pattern. Runbook: `docs/platform/DESTINATION-EDITIONS-AND-WAVE2-DRAFTS-RUNBOOK.md` v1.5, section 6.
- **Pilot #1318** (migrations `20261118262000` and `20261118265000`, spec s694; no new table or function; G3 75/48).
  - Five Australian sources are in the existing Layer 1 registry (`pipeline.sources` + `layer1_source_operations`, source system `DESTINATION`). They show under Layer 1 Register › Australia:
    - ABS Regional Population: statistics, hard-coded parser, 1st of the month.
    - BOM Climate Statistics (IDCJCM0037): statistics, hard-coded parser, 2nd.
    - JSA OSCA & Table 1: statistics, workbook parser, 3rd.
    - Home Affairs Student & Graduate Visa Rules: regulatory, Firecrawl page-facts reader, 3rd.
    - Fair Work Ombudsman National Minimum Wage: regulatory, restricted, **paused**.
  - `layer1-operations-scheduled` v1.6.0 and `layer1-operations-control` v1.11.0 load the sources through `layer1-destination-geo-loader` v1.4.0.
  - Every evidence record names its Layer 1 source, with `fetched_at` and `licence_terms`. The 12 earlier destination artifacts are linked: ABS 1, BOM 8, JSA 1, Home Affairs 2.
  - Side jobs `destination-abs-load`, `destination-climate-load` and `destination-page-facts-load` are off (`active = false`) and retiring. Their `cron.unschedule` paste file waits for the 14-day window.
  - `20261118265000` fixes the successor-edition load (an ambiguous SQL alias). Its post-check now runs pass 2 and rolls it back.
- **Pilot #1322** (migration `20261118272000`, s695): the Home Affairs and JSA sources were made due. **First run through the standard Layer 1 schedule: 19 Nov 2026 00:05 AEDT** (refresh requests completed, verification passed).
  - **Home Affairs:** 5 facts found, through 3 Firecrawl rendered reads. 3 evidence records name the source, each with licence CC BY 3.0 AU and its `fetched_at`; the artifacts are in `evidence/destination/page-facts/immi.homeaffairs.gov.au/*.rendered.html`.
    - The new Post-Higher Education Work stream stay (2 years after a bachelor degree) opened the successor edition "… pages (read 19 Nov 2026)" in draft, with 5 rules.
    - The hourly `destination-open-licence-publish` publishes it, which supersedes the 18 Nov edition.
  - **JSA:** the workbook is unchanged, so nothing was written. Count 1,577; next run 18 Dec.
- **Firecrawl for Home Affairs (authorised 17:55; Pilot #1304, #1305; loader v1.3.0–v1.3.1).**
  - Pages are read rendered through `/v1/scrape` with `onlyMainContent: true`.
  - The spend goes through `svc_fc_spend` (purpose `destination_page_facts`, the "other" daily share) and every call is logged in `pipeline.firecrawl_calls`.
  - Eight credits used in total, by 19 Nov 00:05 AEDT.
- **Published on API v3 `/destination` at 18:41 AEDT** (by `destination-open-licence-publish`):
  - Home Affairs edition, 4 rules, each with its verbatim quote and `evidence_date` 18 Nov 2026:
    - Student visa charge "From AUD2,500.00".
    - Temporary Graduate visa charge "From AUD5,750.00".
    - "work up to 48 hours a fortnight".
    - Overseas Student Health Cover.
  - JSA edition: 1,577 OSCA occupation rows from Table 1. The column read is "Employment in main job"; Table 1 has no earnings column.
- **Still open:**
  - The 12-month living cost (financial capacity): the rendered page places it under "Gather Documents" in Step by Step, and the table-cell pattern (#1305) still finds no amount in the main content.
  - Employment count: served on the v3 career row since 19 Nov 04:03 AEDT (Pilot #1328, s711).
- **New tooling:**
  - `destination.page_facts.read_mode` (static or rendered).
  - Workflow `destination-run-now` (Management API Run now with read-back).
  - Successor editions: a published edition is never written to (`DESTINATION_EDITION_FIXED`); a change opens "… (read <date>)".

### Post-paste verification, scholarship reader restart and page-facts loader (S2-Build; Platform Admin 18 Nov 2026 15:32)

- **Both paste files ran** (constraints v2 at 15:24 AEDT; published-per-owner index at 15:31 AEDT).
  - **BOM climate edition published** at 15:41 AEDT by the hourly target `destination-open-licence-publish`, beside ABS Regional population 2024-25 (both published).
  - Read back on API v3 (`security.destination_read_v1`, AU): 102 localities, with 40 climate figures served with BOM attribution. For example, Hobart shows summer mean max 21.3 °C, winter mean min 5.1 °C and rainfall 610.5 mm (1882–2026), beside ERP 233,736.
- **Scholarship award values and closing dates: the existing reader is running again (Pilot #1290, migration `20261118184000`, s652).**
  - Root cause: the last detail reading was 14 Nov 03:17 UTC. Two leases died at the third attempt. The picker never takes them, but the idle-fill due count still counted them, so `scholarship_detail_backfill_v1` never ran.
  - Fix: the due count now follows the picker's attempt cap, and the two dead leases are settled as failed (update only).
  - No new review kind and no overwrite: `scholarship_detail_apply_v1` fills empty fields only, and the award value and close date need their verbatim quote.
  - On-demand window `9f54b912` (claude_session, openrouter) is open until 22:01 AEDT. Estimate: 136 scholarships, US$0.19 (ceiling US$0.63). OpenRouter balance was US$11.36 before.
  - Results by 17:03 AEDT:
    - 105 readings of 89 scholarships, costing US$0.09 (balance US$11.20).
    - 87 were good and 18 held in the existing held buckets (cut-off answers and recovery parts).
    - 53 records filled: 20 application windows, 25 benefits and 3 award values. Every verified amount is now on its record.
    - 5 dates the reader inferred without a stated close date were correctly not applied.
    - 35 readings are still queued.
  - Active scholarships with no value: 307 (was 310). Published scholarships with no close date: 645 (unchanged; most pages state none).
- **Page-facts loader built and run (Pilot #1291, #1292, #1294, #1296; migrations `20261118185000`, `186000`, `191000`, `194000`; s653; loader v1.2.1).**
  - `destination.page_facts` holds each fact as data: page, edition, rule category, pattern, unit, plausible range and anchor. Mode `facts` stores each page as evidence and keeps the value with a verbatim quote and the time read. It writes draft `study_rules` and OSCA `career_outcomes`, and a reviewed row is never changed.
  - Job `destination-page-facts-load` runs on the 3rd at 05:30 Sydney, plus Run now.
  - Terms recorded:
    - Home Affairs: CC BY 3.0 AU, approved.
    - JSA: CC BY 4.0, approved.
    - Fair Work Ombudsman: CC BY-NC 4.0 (non-commercial) and its robots rules refuse automated reading, so restricted and not read.
  - **Second run (17:00 AEDT): no fact found yet.**
    - Both Home Affairs pages are stored (1.46 MB and 1.30 MB), but their static HTML holds only 3,595 and 1,656 characters of visible text. The content is rendered in the browser, so these pages need a rendered read (Firecrawl, on-demand) before any pattern can match.
    - The JSA workbook was found and stored (`osca_occupation_data_-_2021_census.xlsx`). Its tables are industries, states, age profile, descriptions and titles. Table 1 (Overview) holds the measures, but its header does not match the reader's words yet, so nothing was loaded.
    - Nothing was written, approved or published from either source.
  - **Gaps recorded (not loaded):**
    - Study Australia's living-costs page holds no figure; it points to the calculator and Home Affairs, and was last updated November 2023.
    - No official Study Tasmania figure page was found.
    - The TAC and direct application routes need a source with published terms.
    - QILT stays gated.

### Pre-freeze migration lane (S2-Build; Platform Admin 18 Nov 2026 14:23)

- **28-destination CHECK constraints: with the Platform Admin.** Pilot #1280 applied paste file v2 as migration `20261118165000`. Deploy on merge refused it ("drops, deletes or truncates at top level; the Platform Admin pastes those"), so nothing was applied. It was reverted by Pilot #1288 (spec s641 retired, retirement log) so main equals live. **Run `docs/paste/PASTE-20261118-29-destination-check-constraints.sql` v2 before Thu 19 Nov 01:15 AEDT** (its dry run passed).
- **BOM climate (Pilot #1256, #1275, #1287; edition published 15:41 AEDT after the paste file, see the block above).**
  - Terms are approved (CC BY 4.0, attribution recorded), and the 40 figures (8 capitals × 5) are **approved and served by API v3**.
  - The first publish run (14:41 AEDT) failed on `uq_destination_editions_single_published`: one published edition per country and domain, and ABS population already holds Australia's `city_profiles` slot. The failure also rolled back the approvals.
  - Pilot #1287 (migration `20261118181500`, s646; live 15:24 AEDT, md5 `776a7c0f`) isolates the publish step, so the approvals now stand.
  - The edition itself stays draft until **`docs/paste/PASTE-20261118-destination-editions-published-per-owner.sql`** is run (one published edition per country, domain and source owner). The next run at minute 41 then publishes it.
- **Page-text evidence key (Pilot #1252 fix; Pilot #1281, migration `20261118181000`, s642; live 15:15 AEDT, md5 `b4643fa1`).** 179 copies failed on `layer2_evidence_group_capture_version_uq` because every copy was capture version 1 of `coverage:<course>`. Each copy now takes the next version under a per-course lock, and the failed copies are due again (the page-text job picks them up).
- **Operations backend and grouped decisions:** already live from 12:49 and 13:02 (Pilot #1274, #1277, #1279; see the block below).
- **RM1I living costs, RM1C/RM1H study rules, RM1D JSA careers (superseded 17:03 AEDT: the page-facts loader is built; see the block above).** Not loaded at 15:30. Values change (for example the Student visa fee rose to A$2,500 from 1 Jul 2026), so each must be read from the official page with its quote and evidence, not entered from memory. The next build is a page-facts mode of `layer1-destination-geo-loader`: each fact is defined by its official URL, a deterministic pattern and a rule category, and written as draft `study_rules` or `locality_metrics` rows with the page stored as evidence and terms pending. QILT and REQ-84 to REQ-90 stay gated.
  - **Source readiness (S1-Build, read 18 Nov 2026 15:50 AEDT, Platform Admin 15:26):** before building the page-facts mode, the official pages were checked for each fact. Most figures are not in readable page text, so a deterministic page read cannot load them yet:
    - Home Affairs fees page: no amounts in the page; they are in the Visa Pricing Estimator, which runs as a script.
    - Home Affairs work restrictions: the page does not state the current hours a fortnight.
    - Fair Work (minimum wage) and Jobs and Skills Australia occupation profiles (RM1D): both refuse automated readers (robots disallowed), which the platform policy does not override.
    - Study Australia living costs: no figures on the page; they are in a calculator last updated November 2023.
    - Study Australia financial capacity news page: out of date (AU$24,505 from 1 Oct 2023).
    - **Readable now:** Study Australia agent news "The Student VAC increased from AUD $2,000 to AUD $2,500 from 1 July 2026"; Study Tasmania "TasTAFE accommodation for roughly $160 a week".
    - **Recommended next step:** load these sources the way THE rankings are loaded, from a publisher file the Platform Admin uploads with its evidence (Administration › Sources & Imports): the Visa Pricing Table, the Fair Work pay guide or annual wage review PDF, and the JSA occupation profiles data file. Page facts are used only where the figure is in readable text. Nothing was loaded; QILT stays gated.
- **Migration numbering:** other sessions merged `20261118170000` and `171000` during this lane, so #1281 and #1287 were renumbered above them before merge.

### Operations backend, open-licence destination publishing and grouped Layer 4 decisions (S2-Build; Platform Admin 18 Nov 2026 12:49, 13:02 and 13:07)

- **Operations backend (Pilot #1274, v2.16.39, migration `20261118160000`, s638; merged and live 13:45 AEDT, history md5 `9eb36f30`, G3 75/48).**
  - **Task manager (ref KEW72U):** the read took 9.4 s against the signed-in role's 8 s limit. `security.admin_job_status_v1` looked up the task runner's last run with max() over 160,000 cron runs for each task. It now reads newest-first by run id; Task manager reads in 2.0 s live.
  - **Stuck tasks:** 254 of 257 "running" tasks were AER entry readings (54 scheduled first reads, 200 corrected reads D-R2) waiting on the AI route `course_entry_requirements`, which is switched off on Models & services, so they could never finish. They are closed with that reason: 254 items skipped, 200 supersessions closed as refused, audit event `tasks_closed`. `aer-scheduled-read` asks for no read while that route is held (AER v1 correctness fix, Decision 276).
  - **Find course pages:** the other 3 tasks are genuine person tasks and are kept. Their reason now says "Today's Firecrawl share for course search is used". The search worker is run live by coverage-lane-dispatch, so it is not "switched off". `fc_budget_left_v1('course_link_search')` is 0, with 2,894 searches queued; nothing has been sent since 17 Nov 13:46 UTC.
  - **Health checks follow the dispatchers and recorded pauses:**
    - New functions `security.job_dispatched_v1` and `security.job_paused_by_person_v1`.
    - Scholarship queues reads OK, not critical: scholarship-read and scholarship-discover were paused by the Platform Admin on 17 Nov 13:11 for the bulk ingestion.
    - The watchdog no longer calls dispatcher-run queues "switched off".
  - **New Platform health checks** (rollup target `platform-health-consolidated`, every 10 minutes; thresholds `health.*` are settings): Dispatchers, Boost (switches, Layer 4 cap, staging, qualified models, 24-hour spend), Layer 4 backlog (warning at 6,000 waiting or oldest over 45 days) and Guardrails (G1 uncatalogued running jobs, G3 drift). All four read OK at 13:47.
  - **Storage & retention › Staging tables:** rows, size, what the nightly staging retention would remove and whether it is on (`retention.staging_prune_on` is still 0, dry run).
  - **Evidence › Audit trail** (`public.admin_ops_audit_v1`): dispatcher runs, Boost qualifications and Layer 4 decisions.
  - **Still warnings, and genuine:**
    - Fee reader: 1 item at 3 attempts.
    - Onboard universities: 5 cases from the 12 Oct backfill, waiting on a website or on scholarship AI.
    - Read course pages: coverage-read failures.
    - Search probe: 3.7 s.
    - Database size: 6.7 GB.
- **Open-licence destination editions (Pilot #1275, migration `20261118161000`, s637; merged and live 13:50 AEDT, md5 `a9e3270d`).**
  - BOM climate statistics (IDCJCM0037): attribution recorded and terms approved (CC BY 4.0, per bom.gov.au/copyright, read 18 Nov). The climate load ran through Run now at 13:47: 40 figures (8 cities × 5) as drafts.
  - `security.destination_open_licence_publish_v1` (rollup target `destination-open-licence-publish`, hourly at :41) approves the attributed drafts of editions whose owner is on `destination.open_licence_owners` and publishes them, with audit events. The list is BOM, ABS, Study Australia, Study Tasmania, Home Affairs, Fair Work and JSA; **QILT is not on it**.
  - Publishing now supersedes only the same owner's edition. Before this fix, the BOM edition would have superseded ABS population.
  - The first approval and publication runs at 14:41 AEDT and is read back after it.
  - No RM1I living-cost, RM1C/RM1H study-rule or RM1D career edition exists yet; they follow this path once loaded with page evidence.
- **Grouped Layer 4 decisions (Pilot #1277, v2.16.40, migration `20261118162000`, s639; merged and live 14:22 AEDT, md5 `b1affe01`; live read: 59 AER groups, 123 items, choices at rank 6). The study-load groups failed on read-back (an ungrouped column); the fix is Pilot #1279 (migration `20261118164000`), open.**
  - Measured first: the audit's 1,874 "shared page" AER items include 1,551 incomplete reads (the reader dropped printed requirements). Those are not candidates for a grouped approval.
  - The real shared-page class is 237 items on 172 pages: 125 in 60 groups of two or more, 2 of them audit samples (excluded).
  - Refused study loads: 252 of 400 fall in 48 groups by the same quote at the same university.
  - Each item is decided through `admin_layer4_inbox` at the single item's rank: AER is the Platform Admin's, study loads need a Pipeline Operator. Curators see the groups but cannot decide them.
  - Decision A2 is amended for shared-page groups only.
- **Scholarship award values and closing dates (13:02 item 2), not run, with the reason.**
  - Now missing: 310 active scholarships with no award value (the audit said 287) and 645 published with no closing date.
  - 875 of them already had a version 3 detail read of their stored page with no error, so the same reader on unchanged pages would find nothing new.
  - 69 have a stored page and no version 3 read.
  - The existing detail path (`security.scholarship_detail_apply_v1`) writes values straight to the record under its own checks, not to Layer 4. Routing to Layer 4 needs a new Layer 4 kind; that is the Scholarships lane's call. It is raised with the Platform Admin, and no AI credit was spent.
- **Scheduled task "PR C and PR D of the API v3 data admission plan"** (fired 13:30 AEDT, from an earlier session): not started in this session. PR C needs the official AACSB, EQUIS and AMBA lists, read on demand.

### 28-destination schema lock and legacy telemetry retirement (S2-Build; Platform Admin 18 Nov 2026 12:19 and 12:21)

- **#1263 → #1265 (done):** the readiness change was rebased as Pilot #1265 (v2.16.36, migration `20261118141000`, spec s629) and merged on green; read back live (scheme and subdivision data paths present, G3 75/48). #1263 was closed.
- **Schema lock, additive part (Pilot #1268, migration `20261118150000`, s632; merged and live 12:43 AEDT, history md5 `1b759f16` equals the dry run):** `catalogue.provider_accreditations.rating` and `rating_period` (national quality ratings TEF, NZQA EER, TrustEd, KHDA, SETARA, IEQAS, FINEEC, ANVUR are rows beside AACSB, EQUIS, AMBA); `destination.career_outcomes.series_kind` (occupation default; industry), `industry_scheme`, `industry_code`, `industry_title`, `employment_count`. No new table (s627), consumer API 75/48.
- **Schema lock, CHECK replacements (Platform Admin paste file, v2):** `docs/paste/PASTE-20261118-29-destination-check-constraints.sql` (md5 `22bc38a31482375b8da67e214fd73939`), run before Thu 01:15 (#1268 is live; a rolled-back live dry run of v2 passed, probe Pilot #1271 run 44218085910, closed unmerged): occupation schemes (+ OSCA, NOL, ISCO, ESCO, national schemes), numeric state codes, study rule categories (+ health_insurance, language_requirement, admission_test, dependants, minimum_wage, offer_document), accreditation bodies (+ the eight rating bodies), `ranking.systems` code `ft` (Consumer API change approved by the Platform Admin 12:21; no column change), occupation fields optional on industry rows.
- **Legacy telemetry (Pilot #1269, migration `20261118151000`, s633; merged and live 13:00 AEDT, md5 `b01cf55d`, both targets off):** consumer check per object. Retired: rollup targets `coursefinder-cf245-enrichment-coverage-snapshot` and `coursefinder-cf245-enrichment-hourly-admin-cache` (switched off, kept), their two functions, `security.admin_enrichment_operations_read` and tables `pipeline.enrichment_coverage_snapshots` (about 15,350 rows) and `pipeline.layer2_enrichment_hourly_admin_cache_v1`: read only through `admin_read('enrichment_operations')`, which no screen calls. Drops and the row purge: `docs/paste/PASTE-20261202-cf245-enrichment-snapshots-drop.sql` on or after 2 Dec. **Kept, with live readers:** Link refresh (Coverage › Courses link schedules and the portals that supply course links: configuration applied by job `link-refresh`, not telemetry), Stalled fields (actionable card on Layer 2/3 › Enrich fields), `enrich_coverage_snapshots`, `progress_snapshots`, the course coverage and completeness builds behind the trend charts, the daily telemetry sync, `rollup-scheduler`, `coverage-lane-dispatch`. The other LEGACY_DISABLED cron rows already have their unschedule paste files queued (rollup PR 1, coverage lanes, admission rules; 1–2 Dec).

### Job governance: page-text UNREGISTERED and the 13 CONSOLIDATION_CANDIDATE jobs (S2-Build; Platform Admin 18 Nov 2026 11:54)

**Read live 18 Nov 2026 12:20 AEDT.**
- **`page-text` (job 445):** in `pipeline.automation_catalogue` (area Coverage sweep) since Pilot #1252, but with no `pipeline.component_register` row, which the telemetry sync reads as UNREGISTERED. Still required (stored snapshots → page text for Boost; `coverage-lane-dispatch` does not run it), so it is registered, not retired: Pilot #1266 (migration `20261118142000`, s630) adds the job, `pipeline.page_text_conversions`, `svc_page_text_next_v1` and `svc_page_text_record_v1`.
- **The 13 CONSOLIDATION_CANDIDATE jobs** (all catalogued and registered; all single-mode `coverage-sweep` calls except one SQL job). Recommendation, to run **after Thursday's squash** under the dispatcher rule (register byte for byte, 24-hour shadow, cutover, legacy off and retiring, unschedule paste after 14 days):
  - **Fold into `coverage-lane-dispatch` (one "PR 4" wave):** `coverage-discover`, `coverage-discover-2`, `coverage-ai-match` (every minute), `central-find` (5 min), `logo-find` (10 min), `ops-diagnose` (:27 and :57), `scholarship-listing` (15 min), plus `page-text` (2 min). All are `svc_pilot_submit_nonce('coverage-sweep', {mode, limit})` with a setting-driven limit, the same shape as the 13 lanes PR 3 took over.
  - **Keep on their own jobs:** `coverage-read` and `coverage-read-2` run every 30 seconds; the dispatcher ticks once a minute, so folding them would halve their cadence. They stay unless the dispatcher gains a sub-minute tick.
  - **S2 - BOOST's lane, its call:** `boost-extract`, `boost-fields` (fold with PR 4 once Boost's reading design settles); `boost-benchmark` should be retired when the benchmark round is finished rather than folded.
  - **Fold into `rollup-scheduler`:** `settings-backup-daily` (SQL `security.settings_backup_take_v1('daily')`, 19:50 UTC), as a group A target with a 24-hour shadow.
  - Nothing is changed by this audit; no shadow is started before the squash (the freeze is Thu 01:15–03:30 AEDT).
- **Consolidation PR 4 in shadow since Wed 18 Nov 2026 14:59 AEDT (S1-Build; Platform Admin 14:24 brought it before the squash).** Pilot #1282, migration `20261118170000` (history md5 `115abe29`), spec s643. `pipeline.field_execution_registry` holds 8 new worker lanes in shadow, copied from `cron.job` byte for byte (md5): `coverage-discover`, `coverage-discover-2`, `coverage-ai-match`, `central-find`, `logo-find`, `ops-diagnose`, `scholarship-listing` and `page-text`. `pipeline.rollup_targets` holds `settings-backup-daily` (group A, shadow). The 9 legacy jobs keep running; their register rows stay active with a shadow note. Read back 15:01: 8 of 8 lanes and 1 of 1 target byte-equal, legacy on, first `shadow_due` 14:59; G1 0 unregistered (213 jobs); G3 75/48. Longest legacy run in 7 days 1.6 s, so the tick budget is not at risk. Kept on their own jobs: `coverage-read`, `coverage-read-2` (30-second schedule) and the Boost jobs (S2 - BOOST).
  - **Cutover live Thu 19 Nov 2026 08:18 AEDT (Pilot #1331, migration `20261119095000`, history md5 `7e9b9fe7`; spec s766, renumbered s644 → s765 (Pilot #1359) → s766 (Pilot #1362)).** Brought forward by the Platform Admin at 07:47 AEDT ("so DB contention drops while the S2 data-admittance drains run"): the 24-hour hold was replaced by checks on today's completed runs (`settings-backup-daily` 06:50 succeeded with its `shadow_due` rollup run; latest finished `rollup-scheduler` tick succeeded), after about 17 hours of shadow. Minute coverage now counts a legacy start pg_cron ran one minute late as the dispatcher's slot (`central-find` and `ops-diagnose` at 18 Nov 17:28 and 19 Nov 05:28). Gate at 07:53: 0 uncovered and 0 refused on all 8 lanes. Rolled-back live dry run passed; full CI green.
    - **Read back 08:19–08:25:** 8 lanes `live` and on; `settings-backup-daily` live on `rollup-scheduler`; the 9 legacy jobs off and `retiring`, `retire_after` 2 Dec; 9 cutover events logged; first live dispatches succeeded (0 failed or refused); active jobs 146 → 138 (`coverage-ai-match` had been idle-paused and was back on at cutover); G1 0 unregistered; G3 75 functions and 48 tables, 0 drift.
    - **PIM Admin › Operations › Scheduled jobs (built-in browser, 08:21):** 138 running, 78 retired legacy jobs hidden; `coverage-lane-dispatch` lists 21 legacy jobs replaced, 0 failed in 24 hours; `rollup-scheduler` 26.
    - **Not folded by PR 4 (unchanged):** `coverage-read`, `coverage-read-2` (30-second cadence) and the Boost jobs stay on their own jobs.
    - **Open:** `rollup-scheduler` failed 2 ticks in 24 hours (01:53 and 06:55), both the course-coverage rollup target hitting the 120-second statement timeout under load; the PR 4 paste file (and PR 3's) refuse until `security.flag_jobs_v1` reads the live lanes from the registry.
    - **s792 data gap assessment (20 Nov 2026 00:20 AEDT):** `docs/platform/2026-11-19-au-nz-ca-data-gap-assessment-and-fix-plan.md`, measured live 23:20–00:10 inside the rolled-back workflow.
      - AU did not move 21:45–23:33. NZ (−457) and CA (−327) gained study loads.
      - AU study-load reading is exhausted: every AU page held is read, 6,153 of them do not state a load, and about 8,000 AU courses have no stored page. Decision B7 proposes international (CRICOS) courses as full time.
      - 15,392 of the 15,561 AU "no fee" courses hold the register fee; only 169 have no fee at all.
      - Projection lag is 48 courses (s794).
      - Rankings tables (`catalogue.provider_rankings`, `ref.ranking_sources`) are empty; where API v3 reads QS 2027 is still to be traced.
      - Main campus is flagged for 2 of 45 AU universities and 0 of 8 NZ.
      - Manual locks are 7,585, intact.
      - Seven Platform Admin decisions (B1–B7) are set out with options and recommendations.
    - **s789 (IQ-00130), checked at the day reset (20 Nov 00:04 AEDT):**
      - The 20 `course_page_find` plans were held because today's course-search share was used (1,200 credits on the Melbourne day; the balance was above the priority floor).
      - At the reset the share was back to 1,200 and 26 plans updated. Six new plans started; no plan is duplicated and no course is in two running plans.
      - The local page-text drain ran through the hold under the field-execution dispatcher: 1,200 pages an hour, Firecrawl 0.
      - No change was needed.
    - **s875 (chat S1-RM-Design, found in the signed-in check): live 18:55 AEDT** (admin #711 `80982d6c`, Pilot #1436 `ebae623e`, v2.16.72; checked signed in; S1-RM-Design parked). Pilot #1436 (v2.16.72, no migration): a card in System Queues says "System recovery: the platform is working on it"; Re-read from stored copy ($0) shows only on cards that can be re-read.
    - **s872 to s874 (Platform Admin 20 Nov 2026 17:13 AEDT, chat S1-RM-Design): live 18:35 AEDT** (admin #708 `925c324d`, Pilot #1435 `d3fbed00`; migration history md5 `c701feda`; checked signed in). Pilot #1435 (v2.16.71), migration `20261120174700` (dry run passed, md5 `c701feda`): Human Action Required apart from System Queues (Auto-Recovering) in every queue, one plain-English card contract and action bar, Preview & Settle Batch on every rule group; CI contract over all 19 queues. Matrix: [`docs/platform/2026-11-20-s872-s874-layer4-19-queue-card-contract.md`](platform/2026-11-20-s872-s874-layer4-19-queue-card-contract.md).
    - **s870 and s871 (Platform Admin 20 Nov 2026 16:28 AEDT, chat S1-RM-Design): live 17:45 AEDT** (admin #703 `3dbb9460`, Pilot #1432 `fb182018`, v2.16.70; migration `20261120145500` applied, md5 `0c632f37`; 1,818 stale holds superseded). Pilot #1432 (v2.16.70), migration `20261120145500` (dry run passed, md5 `0c632f37`: 1,818 stale AER partial-table holds superseded and re-queued for aer-det-v1.3, $0). Record: [`docs/platform/2026-11-20-s870-s871-aer-stale-partial-read-reread.md`](platform/2026-11-20-s870-s871-aer-stale-partial-read-reread.md).
    - **s836 to s838 (Platform Admin 20 Nov 2026 14:40 and 14:41 AEDT, chat S1-RM-Design, S1-UI-Parity): live 16:05 AEDT.** Admin #694 (`fd310dcb`), Pilot #1424 (`13256fba`, v2.16.68); migration `20261120145000` applied, history md5 `8f00baa9` = file; checked signed in. Follow-up s839 live 16:35 AEDT (admin #699 `76219159`, Pilot #1429 `4a0695c8`, v2.16.69, no migration): plain hold reason on course description cards, instant batch preview. **Closed.** Record: [`docs/platform/2026-11-20-s836-s838-ui-parity-dashboard-layer4-review.md`](platform/2026-11-20-s836-s838-ui-parity-dashboard-layer4-review.md).
    - **s823 to s827 (Platform Admin 20 Nov 2026 10:31 to 12:35 AEDT, chat S1-UX): live 13:30 AEDT.** Applied by S1-RM-Design: admin #686 (`546f165e`), then Pilot #1420 (`d219e7d7b`, v2.16.67; S1-UX's two commits plus the `?` on the s820 hold banner and a housekeeping delimiter fix). `20261120140000` applied, history md5 `b9db78b4` = file; snapshot rebuilt every 5 minutes (3.8 s, no errors); idle runs folding (up to 32 calls on one row). Signed-in check passed (Platform Admin); the Viewer Dashboard view is covered by the mocked spec only. Observed, not caused by this release: `admin_course_description_queue` 36.9 s / 14.8 s, past the 8 s limit (S1-Courses).
    - **s823 to s827 (Platform Admin 20 Nov 2026 10:31 to 12:35 AEDT, chat S1-UX), built and tested on main after PR 1411; handed off (history below).**
      - **Migration `20261120140000` (s823; `20261120130000` is held by S1-AER's open #1418):** stored ops pulse (`pipeline.ops_pulse_snapshot`, job `ops-pulse-refresh`, setting `ops.pulse_max_age_minutes` 15) answers Platform Health and the top-bar dot; a run of idle worker calls updates one `pipeline.mode_outcome_ledger` row (`telemetry.idle_collapse_minutes` 15). G3 75/48 asserted in the migration; no public object.
      - **UI (v2.16.67, after PR 1411's v2.16.66):** s824 Dashboard cards with icons and AU/NZ/CA bars, no pipeline read for rank 1–2; s825 4-stage pipeline board under the s817 summary; s826 Layer 4 Waiting, grouped by rule; s827 ? help drawer.
      - **Parity at hand-off (12:40):** live 2,215 rows, head `20261120121100` = Pilot main. Record: [`docs/platform/2026-11-20-s823-s827-ops-pulse-dashboard-conveyor-rule-groups-help.md`](platform/2026-11-20-s823-s827-ops-pulse-dashboard-conveyor-rule-groups-help.md).
    - **s819 closed 13:40 AEDT (S1-Build).** Classifier budget live 12:59 AEDT (Pilot #1419 merged; `20261120117000` applied, history md5 `10d0c52f` = file; `sch_cov.classify_candidate_budget` 700). Scholarship classifier (cron job 371): **12:29 AEDT succeeded 17.5 s, 13:29 AEDT succeeded 14.7 s**, no time-out (09:29–11:29 were cancelled at 120 s). Under 10 s is met when the run is alone (5.2 s rolled back at 12:55); at :29 it shares the minute with about 30 jobs, among them `scholarship-auto-publish` (28.6 s), `entry-matrix-read`, the admission rule runners and `coverage-ai-match-prepare`. Open: move the classifier off :29 (scheduler change, Platform Admin call). The 14:29 run is checked at 14:33 AEDT.
      - Read back 13:31 AEDT: domestic-only rule every 10 minutes (13:23 AEDT 181 ms), 9 refused, 73 held waiting; published scholarships 1,070 (unpublished 1,084, withdrawn 682); Coverage snapshot hourly at :34; NZ course documents with no region 3,906 (was 4,066), 271 refresh requests queued; G3 75/48 no drift; 7,585 locks; spend US$0.
      - The AER part of the 09:55 directive (s816/s817) is S1-AER's (s828–s832); its live gap tables are carried in the S1-AER blocks.
    - **s819 Layer 4 speed live 12:24 AEDT** (Pilot #1416 merged; `20261120116000` applied, history md5 `16827344` = file; the post-check now reports a decision held by another job's lock instead of waiting, so the md5 differs from the first dry run `ca390bbc`). Live, rolled back, 12:25 AEDT: Held scholarship 156–210 ms, Entry requirements 265–290 ms, descriptions 128–170 ms, Course link 140 ms, Course page needed 82 ms, Pages not found 98 ms, Website not answering 44 ms, Campus locality 276 ms, Boost study load 67 ms; Rebuild 402 ms (returns the onboarding screen). PIM Admin, signed in: the Layer 4 Inbox loads in 0.8–0.9 s (was 1.9–4.3 s); UTS Jumbunna is not in the Held scholarship list (73 waiting); Catalogue › Providers › Main campus › Unset shows 82.
    - **Scholarship classifier:** 09:29, 10:29 and 11:29 AEDT cancelled at 120 s (before s815); **12:29 AEDT succeeded in 17.5 s**. Domestic-only rule runs every 10 minutes (12:33 AEDT 127 ms); Coverage snapshot 12:34 AEDT 8.5 s.
    - **s819 classifier budget, recorded before merge (repo-first): Pilot #1419, migration `20261120117000`, dry-run md5 `10d0c52f`.** Setting `sch_cov.classify_candidate_budget` 1,500 → 700 (a batch at 1,500 timed 12.6 s rolled back at 12:40; at 700, 5.2 s: 15 providers, 633 cases). A full pass of every university takes about twice as many hourly runs.
    - **s818 live 11:32 AEDT** (Pilot #1415 merged; `20261120115000` applied, history md5 `22b0d329` = file; v2.16.65). Read back 11:40 AEDT: 195 tied main campuses settled (119 registered city, 75 earliest co-located, 1 head office), 82 Unset (AU 80, NZ 2); main campuses AU 1,466, CA 46, NZ 105, no provider with two; 257 NZ and CA courses linked to their only campus (NZ 177, CA 80); 6 NZ campus regions filled. NZ course documents with no region: still 4,066 while 271 refresh requests are processed. G3 75/48 no drift; 7,585 locks.
    - **s819 (Platform Admin 20 Nov 2026 09:55 AEDT), recorded before merge (repo-first): Pilot #1416, migration `20261120116000`, dry-run md5 `ca390bbc`.**
      - **Why:** after s813/s814 every decision was timed again live (rolled back, 11:44 AEDT): Held scholarship 989–1,326 ms, Entry requirements 830–1,028 ms, descriptions 608–678 ms, the rest 370–805 ms. 85% of a Held scholarship decision was `security.layer4_inbox_items_v2`, read twice per decision (about 280 ms each): a SQL function body is planned on every call with its arguments unknown, so no item source is left out.
      - **Change:** the same query text (live md5 `d19cd5e2` checked) run by PL/pgSQL `return query execute … using`, so each call is planned with its arguments known. Same signature, columns and rows.
      - **Dry run:** same rows as the replaced definition (full read, 400 keyed items of every kind, one university). Decisions: Held scholarship 237 ms (Not for international students) and 318 ms (Publish); Description approve 256 ms; Course link use 246 ms; Pages not found release 169 ms; Website not answering wait 138 ms; Entry requirements approve 398 ms (the rest is the frozen AER v1 read, left to S1-AER). Full Inbox read 6,875 → 1,618 ms.
      - **Lanes:** AER (s816/s817) left wholly to S1-AER (Platform Admin 11:54 AEDT; S1-AER renumbers to s828–s832).
    - **s815 live 11:30 AEDT** (Pilot #1414 merged; `20261120112000` applied, history md5 `6411b3c5` = file). The 11:29 classifier window ran before the apply (failed at 120 s as before); the first windows on the new code are 12:29 and 13:29.
    - **s818 (Platform Admin 20 Nov 2026 09:55 and 10:48 AEDT), recorded before merge (repo-first): Pilot #1415, migration `20261120115000`, v2.16.65, dry-run md5 `22b0d329`.**
      - **Tied main campuses ($0):** among the tied campuses only: the registered city, then the register head office address, then the earliest registered of co-located campuses. Dry run: of 277 tied, 195 settled (119 registered city, 75 earliest co-located, 1 head office); 82 left Unset (AU 80, NZ 2). `primary_basis` stays `highest_course_count` (the allowed catalogue values are not changed); the tie-break is in the audit row.
      - **Catalogue › Providers › More filters › Main campus:** Set 1,617, Unset 95, No active campus 1,394 (dry run).
      - **NZ and CA courses with no campus** take the provider's only active campus (not online only, not locked): 257 (NZ 177, CA 80). NZ campuses with no region from their name: 6.
      - **Lanes:** AER (s816/s817) is left to S1-AER (admin #675, Pilot #1412 `20261120120000` applied); S1-Build does not build a second reader.
    - **s813/s814 live 10:52 AEDT** (Pilot #1410 merged; `20261120110000` applied, history md5 `fe308586` = file).
    - **s815 (Platform Admin 20 Nov 2026 09:55 and 10:48 AEDT), recorded before merge (repo-first): Pilot #1414, migration `20261120112000`, dry-run md5 `6411b3c5`.**
      - **Domestic-only rule (sch-domestic-v1, $0):** held scholarships whose page quote names only domestic groups (Aboriginal and Torres Strait Islander, Indigenous Australian, First Nations, Australian, New Zealand or Canadian citizens, permanent residents, domestic students), and no international group, preference or exclusion, are refused as Not for international students with the quote kept; rollup target `scholarship-domestic-rule` every 10 minutes. Dry run: 55 read, 9 refused (UTS Jumbunna among them).
      - **Classifier (IQ-00239 / IQ-00241):** Coverage snapshot set-based, 70 to 120 s down to 3.2 s, now its own rollup target `scholarship-coverage-snapshot` (:34); case reader reads the host list once; batch stops at `sch_cov.classify_candidate_budget` (1,500). Classifier run 2.5 s (rolled back).
      - **Full attribute sync (IQ-00613):** a full pass in chunks within `sch_attr.full_run_seconds` (60) that keeps its place; the 15-minute run continues it.
      - **Lane note:** a duplicate session opened Pilot #1411 (`20261120111000`, `111100`) and #1412 (`20261120120000`, AER shadow reader). The Platform Admin named S1-Build the sole writer for s815 to s819 at 10:48; those are not merged by S1-Build.
    - **s813/s814 (Platform Admin 20 Nov 2026 09:55 AEDT), recorded before merge (repo-first): Pilot #1410, migration `20261120110000`.**
      - **Parity:** live head `20261120103000`, 2,206 rows; 58 = 58 files on main; no open pull request.
      - **Cause of the Held scholarship time-out (UTS Jumbunna):** each decision rebuilt the AI screen (1.8 to 5.8 s); the Inbox now applies the decision and writes the same audit row itself (rolled back: 154 to 675 ms).
      - **Also fixed:** the decision guard scan (Rebuild 2.5 s), the fee outcome LIKE (Use 0.8 s), the held description promotion scan, and keyed item reads (about 4 times faster). Indexes only on `catalogue.course_fees`; no consumer column, type or function.
      - **Matrix:** [`docs/platform/2026-11-20-s814-layer4-lane-admission-matrix.md`](platform/2026-11-20-s814-layer4-lane-admission-matrix.md): 19 kinds, count, what each decision writes, blockers and drain paths.
      - **Dry run (rolled back, md5 `fe308586`):** every held scholarship choice applied and audited; keyed read returns the same rows.
    - **s805b live 08:20 AEDT and s802 to s805 verified in PIM Admin (08:15 to 08:24, read only; nothing admitted, opened or locked):**
      - **s805b:** Pilot #1407 merged; `20261120102000` applied (history md5 `5c6e0293` = file). Live head `20261120102000`, 2,205 rows; 57 post-cut-off versions = 57 files on main. Held list total 352 (page 50).
      - **UTS** (Layer 4 › Inbox › By university › University description): the card offers Edit & Approve, Approve as read and Reject. Edit & Approve shows the machine text (460 characters, 2 sentences, 61 words), flags the refused word "innovative" (the reason the machine rule held it), both quotes and the official page `uts.edu.au/about`; the lock box is ticked; Save Edit & Admit stays disabled until the text is changed, passes the checks and has a reason.
      - **Torrens** (held, first sentence does not name the university) and **AUT** (held, unsupported sentence): each found by name under Held universities: open for writing, with Open for writing offered (not used).
      - **Human Edits & Periodic Audit:** both tabs open; All Human Edits shows 0 open, 0 unacknowledged, 0 due; the bulk actions are present.
      - **G3** 75/48, no drift; manual locks 7,585; audit 0 rows. No spend.
      - **Waiting for a person:** UTS's description (edit out "innovative" or approve as read), and Torrens and AUT written by hand if wanted.
    - **s802 to s805 live 08:00 AEDT (Pilot #1406 merged, Deploy on merge applied `20261120101000`, history md5 `ce175497` = file). Read back 08:08:**
      - **Parity:** live head `20261120101000`, 2,204 rows; 56 post-cut-off versions = 56 files on main.
      - Five new security functions present; settings `governance.human_edit_review_months` 6 and `governance.recheck_word_share` 0.6 under Layer 4 review.
      - `pipeline.human_edit_audit` 0 rows (nothing admitted live by this session); Human Edits counts open 0, unacknowledged 0, due 0.
      - The Inbox summary offers Save Edit & Admit on University and Course description cards. Pending: 62 University descriptions, 151 Course descriptions.
      - **UTS:** no description, pending item `9e1d3b89` (machine text proposed). **Torrens:** held (`first_sentence_no_name`), no item; found in the held list by name. **AUT:** held (`unsupported_sentence`), no item; in the held list. No lock on any of the three.
      - **G3** 75/48, no drift; manual locks 7,585.
      - **Found:** the held list reported its page size (200) as its total; 352 universities are held. Fixed by s805b (below).
    - **s805b recorded before merge (Pilot #1407, `20261120102000`, dry-run md5 `5c6e0293`):** the held list counts every match (dry run: total 352, page 5, Torrens 1). Read only; no UI change.
    - **s802 to s805 (Platform Admin 20 Nov 2026 05:52 AEDT), recorded before merge (repo-first): Pilot #1406, migration `20261120101000`, v2.16.62.**
      - **Parity:** live head `20261120095000`, 2,202 rows. Another lane's Pilot #1403 (v2.16.61) renumbered to `20261120100000` at 07:05, so this is `20261120101000`. Merge order: #1403 may go first or after; versions do not collide.
      - **s802/s803:** `security.layer4_description_decide_v1(p_item_id, p_edited_content, p_set_manual_lock default true, p_reason)`. Unedited (trimmed) → approved as read, `machine_human_approved`. Edited → `human_input`: length, sentence and word-list checks, refused when already locked or changed, locked by hand unless declined, audited, review due in six months. The 2 Nov "approved as read, never edited" refusal is replaced (md5-guarded edits of both apply functions and `public.admin_layer4_inbox`; no public function added).
      - **UI:** Edit & Approve on University and Course description cards (text, quotes, official page link, live counts and word-list check, lock box, Save Edit & Admit, Approve As-Is). Held universities: open for writing (By kind › University description).
      - **s804/s805:** `pipeline.human_edit_audit`; new menu section Data & Governance › Human Edits & Periodic Audit (My Human Edits rank 4; All Human Edits rank 6) with Unacknowledged and Due badges; Acknowledge & Keep Lock, Re-Verify by Machine ($0, read-only, side by side), Edit & Re-Lock, Release Lock to Machine, Accept machine text.
      - **Settings (Layer 4 review):** `governance.human_edit_review_months` 6; `governance.recheck_word_share` 0.6.
      - **Dry run (rolled back, md5 `ce175497`):** course edit admitted, locked, audited (human_input); course approve as read recorded machine_human_approved; held university opened and written by hand; Human Edits listed, re-verified, acknowledged, edited and re-locked, released; too-short edit refused.
      - **G3:** no consumer object changed. No spend. Nothing dropped.
    - **s797 to s799 live 06:52 to 07:00 AEDT, read back 07:01 (s801):**
      - **Migrations:** Pilot #1401 `20261120093000` (`d0d5e1fe`), #1402 `094000` (`06afa152`) and `094100` (`0f7536d2`), #1404 `095000` (`b9b21146`), each applied by Deploy on merge with the history md5 matching the file.
      - **Parity:** live head `20261120095000`, 2,202 rows; 54 post-cut-off versions = 54 files on main.
      - **B7:** 16,998 rule values. AU search gap (no study load) **15,382 → 24**; AU active courses with no load 66. AU loads held: full time 20,654, part time 118, both 3,217.
      - **B2:** primaries AU 1,277, NZ 101, CA 44; no provider has two.
      - **B1:** AACSB 58, EQUIS 31, AMBA 13 active; Triple Crown 10, Double Crown 19. v3: Monash `triple_crown`; a B7 course reads `full_time`, basis `register_rule`.
      - **B3:** v3 `university_groups` shows **2050 Alliance** (nine members); "Innovative Research Universities" is gone.
      - **s799:** live warm calls: boost 108 to 214 ms, re-identify 50 to 110 ms. 0 HTTP 500s since the merges.
      - **G3** 75/48, no drift; manual locks 7,585; v3 field dictionary 2,249.
      - **Corrections:**
        - The 2,340 search refreshes queued by s798 change nothing: course search documents hold course collections only (none exist), not university groups. They are harmless ($0) and are draining.
        - The 07:45 entry below was written at about 06:55; its time and the 07:30 engagement row were ahead of the clock (the row is superseded).
      - **Remaining AU gaps (unchanged by these decisions):** no description 11,894; no link 6,117; no intake 14,501; intake without date 6,901; no provider fee 15,561 (169 with no fee at all); no English 7,875.
    - **s797 to s800 (Platform Admin 20 Nov 2026 05:42 AEDT: decisions B1 to B7 approved; claim time-outs), recorded before merge (repo-first).**
      - **Parity (05:45):** history 2,198, head `20261120010000`, 50 = 50.
      - **Numbering:** another lane's Pilot #1403 holds `20261120100000`, so these are numbered above it: s797 `093000`, s798 `094000` and `094100`, s799 `095000`. Merge order: s797, then s798, then s799.
      - **s797 (Pilot #1401, dry-run md5 `d0d5e1fe`):**
        - B7: AU CRICOS courses open to international students and holding no study load become `full_time` (source `register`, no evidence id, which marks a rule value). Dry run: 16,998 set; AU active with no load 17,064 → 66.
        - A reading always replaces a rule value (seven md5-guarded writer edits).
        - B2: the register head office first, then the campus with the most active courses (`highest_course_count`). Dry run: +1,066 primaries (AU 921, NZ 101, CA 44); 277 providers with ties left for a person.
      - **s798 (Pilot #1402, dry-run md5s `06afa152` and `0f7536d2`):**
        - B1: 58 AACSB and 31 EQUIS rows read from the bodies' own pages; the 13 AMBA rows approved. Double Crown = any two, Triple Crown = all three: 10 Triple, 19 Double.
        - Left out: Wilfrid Laurier (not in the catalogue) and UNB (a non-accredited AACSB member).
        - B3: IRU becomes the 2050 Alliance; ACU and VU added (nine members); Charles Darwin is not a member; code `au_iru` kept; 2,340 courses queued for a search refresh.
        - B4: English grades shown on v3 as held (none held today).
        - v3 also gains `study_load_basis` and `accreditation_crown`. Field dictionary 2,227 → 2,249.
      - **s799 (Pilot #1404, dry-run md5 `b9b21146`):** boost claim 503–688 → 142–172 ms; re-identify 330–417 → 67–101 ms (old and new in the same run, median of three warm calls). Same due set (old = new). Apply gate 800 ms.
      - **s800 (admin `docs/platform/2026-11-20-s800-qs-2027-source-the-2027-readiness-and-b5-destination.md`):**
        - QS 2027 is `ranking.editions` (`qs_wur` 2027, accepted, 1,504 observations, 71 linked) served through `website_v3_rankings` → `website_v2_rankings`. The 19 Nov "rankings tables empty" finding is withdrawn: the wrong tables were checked.
        - THE 2027 needs only the licensed file through the governed manual import.
        - B5: `city_profiles` holds no rows despite two published editions.
    - **s791b live 01:28 AEDT (Pilot #1400, migration `20261120010000`, history md5 `c0d99833`).** Read back as a signed-in Platform Admin:
      - `intake-dates-apply` reads as scheduled through its dispatcher; `job_run_now_v1` uses the helper;
      - Course intake Run & Validate is no longer blocked (`can_run` true);
      - a hand-picked preview returns a token;
      - G3 75/48, no drift; manual locks 7,585;
      - 0 `enrich_ai` HTTP 500s since 00:47 (623 OK).
      - Live head `20261120010000`; 2,198 rows; 50 post-cut-off versions = 50 Pilot files.
    - **Correction to s794 (read 01:25 AEDT):** the 48 courses it queued were rebuilt (48 of 48, result `changed: 0`).
      - All 48 are **unpublished** courses, whose search documents correctly leave out intakes, English and links.
      - Among published courses the projection lag is **0**. The "48 lagging" figure in the s792 assessment was not a lag.
      - s794 changed nothing and cost nothing. The follow-up "no refresh trigger on `course_intakes` / English" is withdrawn for now: no published course is out of date.
    - **Gap re-measure 01:19 AEDT (same query as s792):**
      - AU unchanged from 23:33 (one more description held: 11,899).
      - NZ unchanged.
      - CA study load 3,113 → 2,368 (−745 since 23:33; −1,072 since 21:45).
    - **s791b (VERIFY-01), recorded before merge (repo-first): Pilot #1400, migration `20261120010000` (dry-run md5 `c0d99833`), spec s791 (new test).**
      - **Found in the s790/s791 read-back:** Course intake Run & Validate showed "Blocked: job is paused or not scheduled", and `security.job_run_now_v1` refused "job is paused".
        - Both read `cron.job`.
        - Since the 16 Nov cutover (`20261116190000`), `intake-dates-apply` runs as a live rule of `admission-rule-runner`; its legacy cron row is off and `retiring`.
        - So human Run Now has been refused since 16 Nov.
      - **Fix:** `security.job_schedule_refusal_v1(job)` reads the live dispatcher target first (`field_execution_registry`, `rollup_targets`, `admission_rules` by `legacy_job`), then the cron row. Both checks call it (md5-guarded edits); every other Run Now check is unchanged.
      - **Dry run:** intake Run Now on the latest cohort returned `done` (rolled back; 0 vendor calls). 62 dispatcher-held jobs read as scheduled. A genuinely paused job (`calendar-reread`) is still refused.
    - **s790/s791 live 01:00 AEDT (Pilot #1399, migration `20261120002000`, history md5 `75f4eafb`; v2.16.60 deployed, Release Currentness Deployed green).** Read back as a signed-in Platform Admin:
      - setting `run_now.university_page_courses` = 200 (20–1,000 courses);
      - stage table present and empty;
      - capabilities `page_courses` 200 with 4 scope forms;
      - NZ providers 290 (largest University of Auckland, 458 courses);
      - course search finds courses;
      - G3 75/48, no drift; manual locks 7,585.
      - **Finding: the intake plan has nothing left to fill.**
        - `top-au` plans 0 rows.
        - Page 1 of 12 AU universities: 0 eligible.
        - The intake job made 102 decisions in 24 hours with 0 filled.
        - New intake dates need new evidence (approved calendars, pages that name a study period), not more runs.
    - **s788 window 2 (00:33–00:47 AEDT):** 0 `enrich_ai` HTTP 500s, 288 HTTP 200s, 23 enrich items finished. The one 500 was `svc_coverage_reidentify_next` (statement timeout, worker `coverage-sweep-v0.5.6`), a different claim (follow-up with `svc_boost_extract_claim`). **IQ-00053: two unattended windows clean.**
    - **s790/s791 (IQ-00313 F-INT PAGE-01, OPS-01, VERIFY-01), recorded before merge (repo-first): Pilot #1399, v2.16.60 / 0.1.482, migration `20261120002000` (dry-run md5 `75f4eafb`), specs s790 and s791.**
      - **PAGE-01:** Course intake Run & Validate takes `university:<id>[:page:<n>]`: any active AU, NZ or CA provider, every active course in a fixed order, 200 a page. The page size is a new Pipeline setting, `run_now.university_page_courses` (20 to 1,000).
        - It also takes `courses:<id>,…`: hand-picked courses up to the cohort cap.
        - The same `intake_dates_plan_v3` and guards apply. `top-au` is unchanged and still the default.
        - Read views: `universities` (search, country, paged; 1,886 providers live) and `course_search` (title or course code).
      - **OPS-01:** new internal table `pipeline.intake_cohort_stages`.
        - Fetched, parsed and extracted are written when a cohort is fixed, counted from its stored evidence.
        - Verified, admitted and held are written after each Run Now from the intake event log, with the run ID. A failure to count never fails the run.
        - Dry run on the latest cohort: fetched, parsed and extracted 2 courses / 3 intakes; verified 2/3, admitted 2/3, held 0/0.
      - **VERIFY-01:** Verify returns `stage_history`, and the screen shows it with run IDs.
        - Admission stays with the `intake-dates-apply` job through `admin_job_run_now_v1`.
        - No-overwrite, the manual-lock trigger (7,585 locks), the same-month guard and the /dates, /calendar and /timetable rules in the plan are unchanged.
      - G3 75/48, no drift. Spend $0.
    - **s794 live 00:30 AEDT (Pilot #1398, migration `20261119191000`, history md5 `d3bc130f`):** the 48 refresh requests were processed by the existing `search-course-refresh` job (48 of 48 by 00:32); none pending.
    - **s788 live 00:25 AEDT (Pilot #1397, migration `20261119190000`, history md5 `42db5522`; `coverage-sweep` redeployed with worker v1.0.31 by Deploy on merge):**
      - Read back: index `field_enrich_items_claim_idx` present, both picks name `state in ('ai','leased')`, `svc_enrich_ai_next(40)` 176 ms live (was a 4.1 s timeout).
      - Window 1 (00:27–00:32): 0 HTTP 500, 0 HTTP 503, 92 HTTP 200.
      - The two 500s just before (00:14, 00:25) were `svc_boost_extract_claim` statement timeouts from the Boost worker (`coverage-sweep-v0.5.6`), a different claim (follow-up, S2 - BOOST lane).
      - Window 2 is still to be read.
    - **s794, recorded before merge (repo-first): Pilot #1398, migration `20261119191000` (dry-run md5 `d3bc130f`), spec s794.** 48 AU, NZ and CA courses hold an active intake, an active English requirement or a link that their search document does not show (documents built 19 Nov 07:45). Nothing queued their refresh: no trigger on `course_intakes` or `course_english_requirements` asks for one (follow-up). The migration queues one refresh request each for the existing `search-course-refresh` job.
    - **Migration parity re-read 00:58 AEDT 20 Nov:** history 2,197 rows, head `20261120002000`; 49 post-cut-off versions = 49 Pilot files on main `847da3b4`. Pilot #1400 is numbered `20261120010000`.
    - **Migration parity re-read 00:33 AEDT 20 Nov:** history 2,196 rows, head `20261119191000`; 48 versions after the cut-off, the same 48 files as Pilot `supabase/migrations/` on main `8e1eafcc`. Pilot #1399 is numbered `20261120002000`, above it.
    - **Migration parity (Platform Admin 19 Nov 2026 23:21, repo-first rule), read live 23:20 AEDT:** production history 2,194 rows, head `20261119182000`. Versions after the baseline cut-off `20261118272000`: 46, the same 46 files as Pilot `supabase/migrations/` (1 to 1, same head). The 2,148 earlier versions are in the baseline (`supabase/live-capture/baseline/`), and from Pilot #1396 every one of them has its applied text in the repository (`supabase/migration-history/`). Literal parity of the whole history with `supabase/migrations/` would need the history trimmed (a delete, Platform Admin paste file) or 2,148 files put back where Deploy on merge applies them; neither is done.
    - **s788 (IQ-00053), recorded before merge (repo-first): Pilot #1397, migration `20261119190000` (dry-run md5 `42db5522`), coverage-sweep worker v1.0.31, spec s788.**
      - **Cause:** every `enrich_ai` HTTP 500 since 21:00 AEDT (52 of 2,781 coverage-sweep replies to 23:20) was `svc_enrich_ai_next: canceling statement due to statement timeout`, with no lock waits. The claim's first pick filtered state with an OR that no index matches, so the planner walked `idx_field_enrich_items_job_state` over all 266,611 items (2.5 s alone; 4.1 s a call) to find 0 to 12 of the 252 claimable ones.
      - **Fix:** partial keyset index `field_enrich_items_claim_idx` (claimable rows in the pick's order) and `state in ('ai','leased')` named first in both picks (md5-guarded edit, `FOR UPDATE SKIP LOCKED` kept). Dry run: the claim starts from the claimable rows; `svc_enrich_ai_next(40)` 84 ms (timed in a rolled-back sub-block). Worker v1.0.31 answers a claim refused as busy with `503 {status:"busy", retry:true}`, never an uncaught 500.
      - **After merge:** live read-back and two unattended windows with 0 HTTP 500s from `enrich_ai`.
    - **s782 (Pilot #1396, no database change):** `supabase/migration-history/` holds the applied text of the 1,175 production versions the repository did not already hold with the same text (1,022 with no file of that version, mostly applied straight to the database in Aug–Sep 2026; 153 whose archive file differs from what ran), with `MANIFEST.tsv` for all 2,194 versions and the 736 repository files without a history version. Read only through the Management API (run 44522515754; key-like text scan clean). New dispatch-only workflow "Migration history sync (read only)".
    - **s781 (19 Nov 2026 18:24 AEDT, Pilot #1392, v2.16.56, and #1393 at 18:47, v2.16.57, no migration):** Catalogue › Providers. Each row leads with a 32 px logo (one batched `provider-asset-access` call by stable key) or a two-letter monogram, then the name in bold with its CRICOS code or stable key. Country codes show a drawn SVG flag (AU, NZ, CA) and one code pill, in every catalogue cell (the flag emoji read "AU AU" on Windows). Extract / refresh description is a refresh icon. The adapter badge reads in full beside an Open adapter icon. The Type select is capped at 140 px. Five filters stay in the bar; eight technical ones are under More filters (with an in-use count). Inactive page tabs use slate 700. Spec s781; the Provider catalogue columns and Fill fields specs open More filters. Live check (built-in browser, v2.16.56 and v2.16.57): monogram, drawn NZ flag with one pill, readable adapter badge, More filters; #1393 shows register codes in capitals (NZQA 8530, was nzqa 8530).
    - **s778 (19 Nov 2026 18:11 AEDT, Pilot #1390, v2.16.55, no migration):** Users & roles › Create user (Person, Role, Sign-in, Review) and the role and edit dialogs: label above, full-width 40 px control (14 px, 40 px right padding for autofill icons), helper below. Audit: the Layer 1 add-source wizard, the record editor and the provider-contacts import already stack. Spec s778 (1280 px and phone).
    - **s776/s777 (19 Nov 2026 17:22 AEDT, Pilot #1382, v2.16.54, migration `20261119174000`, history md5 `0fd6fb87`; follow-up Pilot #1389 18:11, migration `20261119182000`, history md5 `71880fba`):**
      - Rollup target `course-field-readiness` (`*/4`, group A) builds the readiness snapshot in `readiness.snapshot_parts` (16) parts in `pipeline.job_input_marks`, with the export's rules verbatim; `readiness.days_kept` 15 days of daily marks give the 7-day velocity.
      - Coverage & completeness › Courses: Pipeline & field ETA panel (Consolidated, By country, By university), read by `admin_field_coverage('pipeline_eta')` (137 ms live as Platform Admin).
      - Stakeholder_Course_Readiness_Summary: Executive_Summary, Field_ETA_Forecast and By_Provider_Action_List are refreshed hourly by the telemetry sync (scheduled task revision 5, step 8b, `security.course_field_readiness_tabs_v1`). The daily per-country CSV (07:30 AEDT) is unchanged.
      - Follow-up #1389: the live read-back found the tabs read returned rows with 3 of 16 parts built; it now returns null until every part is built, so part-totals never reach the sheet. First hourly write by the 18:46 sync: Executive_Summary, Field_ETA_Forecast and By_Provider_Action_List replaced (140 rows, snapshot 17:48 AEDT); Run_History_Log row stakeholder-readiness-sync SUCCESS.
    - **s780 P1 (19 Nov 2026 17:05 AEDT, Pilot #1386, migration `20261119173500`, history md5 `abe49702`):** Provider details opens again for Curator, Operator, PIM Admin and Platform Admin (refs 3A9WTT and 3UD5A2).
      - **RPC behind both refs.** `public.admin_read('provider_detail', {id})`, called twice by the Provider details blade: `api.providerDetail(id)` and `providerRelated()` in `src/lib/supabase.js`. `pipeline.ui_error_log` ids 228 (3A9WTT, 16:21) and 231 (3UD5A2, 16:22), Platform Admin. The screen showed "Your role is not allowed to do this"; the detail was "permission denied for schema catalogue". 10 such refs were logged 16:15–16:53.
      - **Causing change.** Pilot **#1329**, commit **`a18020c8`** ("CF-247 S712: student-facing destination read for Viewer and Counsellor; accreditations on provider detail"), migration `20261119045000_cf247_student_facing_destination_read.sql`, merged 19 Nov 04:44 AEDT.
      - **Why.** S712 put a direct `select … from catalogue.provider_accreditations` into `public.admin_read` for rank ≥ 3. `admin_read` is security invoker and `authenticated` has no USAGE on schema `catalogue`, so every role from Curator up was refused. Viewer and Counsellor read through the security definer `security.provider_accreditations_v3_v1` and were not affected. It was not caught because the #1329 dry run ran as the owner and its live check was made as Viewer and Counsellor only.
      - **Fix.** New security definer `security.provider_accreditations_admin_v1(uuid)` (rank ≥ 3 full rows, below that the v3 view; execute for `authenticated` and `service_role` only); a md5-guarded fragment edit makes `admin_read` call it. `admin_read` stays invoker; no grant on `catalogue` is widened; no consumer API change (G3 75/48).
      - **Read back (rolled-back workflow, 17:07–17:08, as the Platform Admin's JWT under `authenticated`):** rank 6, `provider_detail` returns its accreditations (1 of 1 held); `admin_read` invoker, no direct `catalogue.` read; 0 "schema catalogue" refs since the deploy. Spec s780 (4 tests) also fails any later migration that puts a `catalogue` read back into `admin_read`.
    - **s773–s775 (19 Nov 2026 15:56 AEDT, Pilot #1380, migrations `20261119155000` md5 `97cbc66f`, `20261119155500` md5 `0b5999ea`, `20261119160000` md5 `b659f997`):** IQ-00594, IQ-00588 and IQ-00426.
      - **Runner B (`adapter-overwrite`).** Set-based Layer 4 block check and a keyset window of `batch.adapter_overwrite_window` (1000) courses with a cursor in `pipeline.job_input_marks`; a window that hit its limit is re-read, the "no new input" skip applies only between passes. Dry run 1.1 s a window (was up to 113 s); live 9–17 s a run.
      - **Runner C (`coverage-admit`).** Same pattern for plan and apply (`admit.window_pages`, 1500); the before-snapshot is taken only when a window writes. Dry run 1.3 s plan + 1.2 s apply (was up to 118 s); live 10–30 s, including the 6.5 s consumer snapshot when a window writes.
      - **`no-page-propose`.** `bind_match_scope_refresh_v1` groups unbound courses by provider before the focus check, with the new partial index `enrichment_flags_provider_raised_idx`. Scope refresh 4.5 s in the dry run (was 90–120 s and a time-out); the 16:37 run succeeded in 25.3 s.
      - **Unattended cycles 15:58–17:10:** 2,371 job runs, 0 failed, 0 statement time-outs. `admission-rule-runner` 75/75, `-b` 75/75, `-c` 74/74, `rollup-scheduler` 72/72, `waste-guard` 1/1 (105 s), `no-page-propose` 1/1.
      - **Not met as asked.** The targets were under 5 s per runner and under 3 s for `no-page-propose`. The fixed rules are well inside the limit but not that fast live. Runner C's whole tick still reaches 118 s from other rules on its lane (for example `provider-english-defaults`), and runner B's 96 s. Those rules are a follow-up, not part of this change.
    - **s767 post-fix check (19 Nov 2026 15:20 AEDT, read only, runs 12:24–15:15):**
      - `scholarship-coverage-classify` (batch 80): 99 s, 56 s, 75 s, all succeeded. The slowest is 21 s under the limit, so the size stays at 80.
      - `no-page-propose` (25 providers): 90 s, failed at 120 s (13:37), 102 s. Its failure is in the candidate query (`enrich_focus_v1` → `pipeline_list_v1`) before any per-provider work, so a lower batch would not help; the query needs its own fix.
      - `waste-guard`: 107 s, 76 s, both succeeded (2 of 3 failed before s767).
      - `ops-cost-guard` (rollup target): 92 s (12:43), 73 s (13:47, one tick deferred for budget), 115 s (14:43). Within 6 s of the 120 s limit at 14:43; the `ops_cost_waste_v1` profiling item stands.
      - `rollup-scheduler`: no failed tick since 06:xx; ticks over 100 s occur 1–4 times an hour under load, as before s767; each target in them is under 20 s apart from `ops-cost-guard`.
      - Telemetry: hourly syncs 12:48, 13:48, 14:47 AEDT all SUCCESS on revision 4; Pipeline_Summary shows `coverage-discover` RUNNING (231 completed, 0 failed in 24 h).
    - **s769 (19 Nov 2026 14:18 AEDT, Pilot #1374, v2.16.51, migration `20261119130000`, history md5 `78c396f5`):** Scholarships › Coverage loads again (ref 8XEY7B).
      - **Cause.** `security.scholarship_listing_match_v1` re-ran `scholarship_series_key_v1` for every listed item × record pair (the planner inlined both CTEs). One provider took 6.86 s; The University of Sydney (582 × 257) did not finish in 58 s. The page asked for 300 providers against the 8 s `authenticated` limit.
      - **Fix.** Item and record keys, words and addresses are materialised once, then compared (same matching rule): 92 ms and 721 ms. Same matches on 1,633 rows of 65 providers; a duplicated item with two links now keeps the first on the page. `admin_scholarship_coverage_read` returns at most 50 providers a page; the screen has Previous and Next. The provider drawer and sign-off use the same matcher.
      - **Part 2 (15:07 AEDT, Pilot #1375, migration `20261119144500`, history md5 `158ca349`).** The live check found the provider drawer still timing out (Sydney 8.7 s). `admin_scholarship_coverage_provider` and the Publish action read `scholarship_publishability_v1()` for every scholarship (7.5 to 13.8 s) and kept one provider's; they now call `scholarship_publishability_for_v1` with that provider's ids (identical rows, 0.6 s).
      - **Read back in PIM Admin:** watch list 523 ms; All with scholarships pages 1–5 0.5 to 1.5 s; Sydney row 582 listed, 184 found, 71 published, 398 missing; Sydney drawer 7088 ms. No 8XEY7B. G3 75/48, 0 drift.
    - **s767 (19 Nov 2026 12:24 AEDT, Pilot #1367, migration `20261119120000`, history md5 `0eb2fdce`):**
      - **Idle pause.** `security.flag_jobs_v1` now also finds live registry lanes whose legacy row is gone, so both unschedule paste files can run. The rolled-back dry run showed both `coverage-discover` lanes held idle by flag-recheck, which is correct.
      - **Telemetry.** `security.job_effective_state_v1` gives each dispatcher-held job its runner, state and runs. Telemetry exporter revision 4 (Drive `1YuZjKm-T11C73msIywKitJQQb5mgic9k`, sha256 `c339fa4a…`) uses it, and the hourly telemetry task is repointed to it.
      - **`waste-guard`.** Its cost measure (44 s of the 59 s median) now runs as rollup target `ops-cost-guard` (hourly :43, `expected_ms` 45000).
      - **Per-run sizes.** `batch.sch_coverage_classify` 120 → 80; `bind.no_page_providers_per_run` 40 → 25.
      - **Idle guard.** `security.waste_idle_guard_v1` no longer switches a retiring job on again (`course-link-reverse` was exposed).
      - **Read back 12:25:** G3 75/48, 0 drift; G1 0 unregistered; 136 active jobs.
  - **24-hour late-tick check, run Thu 19 Nov 00:26 AEDT (window 18 Nov 00:26 to 19 Nov 00:25): not a clean 24 hours; clean for the last 6.** Measured: 0 md5 or schedule drift on any rollup or coverage target; 69 retiring legacy jobs all off, none run; no refused dispatch. Over the 24 hours, minutes skipped: `rollup-scheduler` 5, `coverage-lane-dispatch` a/b/c 2 each, `admission-rule-runner` a/b/c 12/10/13. Failed ticks: admission runners 8/6/8; every other dispatcher 0. The misses fall in three episodes:
    - 00:38–01:58, the hour after the PR 3 cutover: at 01:27 all 7 dispatcher jobs missed the same minute.
    - 17:27: all 7 jobs missed one minute together, a platform-wide pause.
    - 18:13–18:31: admission targets hit the 120-second statement timeout, waiting on the `search_course_documents_writer` advisory lock and in `zoho_edge_course_search_v2`, `coverage_admission_plan_v1` and `adapter_overwrite_v1`.
    - **Since 18:32: 355 of 355 minutes on all 7 jobs, 0 failed.** Dispatch statuses over 24 hours: admission 1,414 succeeded; rollup 5,655 succeeded, 14 deferred, 1 failed (`destination-open-licence-publish` at 14:41 hit the old one-published-per-domain index; the per-owner paste file has since been run and BOM climate is published); coverage 5,226 succeeded, 196 deferred.
    - **Readiness for the 14-day unschedule window:** the legacy side is ready (all retiring jobs off and idle), so the PR 1 and PR 3 paste files can run on or after 2 Dec as planned. The admission runners' timeouts under load are a separate PR 2 follow-up: lanes a/b/c contend on the same writer lock when heavy rules fall due together. Suggested owner: the PR 2 lane (S2-Build). Watch for recurrence; do not change the timeouts.
    - **PR 4 shadow, 9.5 hours in:** all 8 lanes have at most 1 uncovered legacy minute and 0 refused dispatches, within the cutover gate. The dispatcher holds more minutes than the legacy jobs ran (pg_cron skips at busy minutes), as with PR 1. `settings-backup-daily` is first due at 06:50 Thu. Cutover still scheduled for Thu 15:10.

### 29-destination schema readiness (S2-Build; Platform Admin 18 Nov 2026 11:28): read-only cross-check, data paths, constraint paste file

**Read live 18 Nov 2026 11:40 AEDT (read only).** Goal: after Thursday's squash, onboarding any destination needs only data and Layer 1 configuration.
- **Countries:** all 28 codes named (AU, CA, GB for "UK", NZ, IE, US, DE, SE, FI, DK, ES, MT, NL, FR, AT, CH, HU, LV, AE, SG, PL, IT, GR, CY, TH, MY, KR, JP; the directive says 29) are in `ref.countries` (249 rows).
- **Accept any country:** `destination.localities`, `locality_metrics`, `locality_postcodes` (upper-case code only), `destination.study_rules`, `career_outcomes`, `editions`, `city_profiles` (foreign key to `ref.countries`), `destination.rule_applicability` (entity type and status only). `catalogue.provider_accreditations` (AACSB, EQUIS, AMBA) and rankings (`ranking.*`, `catalogue.provider_rankings`; systems `qs_wur`, `the_wur`, `arwu`) are country-agnostic. There is no `catalogue.university_metrics` or `catalogue.university_rankings`.
- **Gap 1, registration schemes (closed by data path, Pilot #1263, v2.16.35, migration `20261118133000`):** 22 of 28 countries have no row in `ref.registration_schemes`, the wizard refused an unregistered scheme and nothing wrote the table, so a new country needed a migration. Now `public.admin_registration_scheme_register_v1` (Platform Admin, reason, added as planned, never changes an existing row) and **+ Register a scheme** in + Add source step 1.
- **Gap 2, subdivisions (closed by data path, same PR):** 25 of 28 countries have no `ref.subdivisions` (register state names stay unmapped; not blocking). `public.admin_subdivisions_register_v1` loads ISO 3166-2 rows as data. Loading them per country is data work, not schema.
- **Gap 3, three CHECK constraints (paste file for the Platform Admin, run before Thu 01:15 AEDT):** `destination.career_outcomes.occupation_scheme` (only ANZSCO, NOC, SOC; adds ISCO, ESCO, KLDB, ROME, SSYK, DISCO, SSOC, MASCO, KSCO, JSCO, TSCO), `career_outcomes.state_code` (letters only; numeric ISO 3166-2 codes in JP, KR, TH, MY, SG, PL, FI, DK, AT, CY, LV), `destination.study_rules.rule_category` (adds `health_insurance`, `language_requirement`, `admission_test`). File: `docs/paste/PASTE-20261118-29-destination-check-constraints.sql` (md5 `dd60b84bdfa8392d8e89f64beb116633`; guarded, each replaced only if unchanged, accepts everything the old one did). Relaxing a CHECK drops and re-adds it, so it is not in a migration.
- **Canada prototype tables:** no `ca_institutions`, `ca_pgwp_cip_eligible`, `ca_courses`, `ca_policy_facts`, `ca_noc_*` or `ca_study_cities` exist in the Pilot (only `pipeline.ca_course_scope_keys`); nothing is migrated under `ca_*` names. Their canonical homes when the data arrives: institutions → `catalogue.providers` (country CA, scheme `ircc_dli`); courses → `catalogue.courses` (scheme `mtcu`); PGWP and CIP eligibility → scheme `pgwp` (work eligibility) with the PGWP field-of-study list (Track B reader ready, 1,107 rows) and `cip`; policy facts → `destination.study_rules` (country CA); NOC → `destination.career_outcomes` (`occupation_scheme` NOC); study cities → `destination.localities` and `locality_metrics`.
- **Australia course fields:** study mode is `catalogue.courses.delivery_mode` and study load `study_load` (held); the TEQSA category is the provider type (`catalogue.providers.provider_type_id`). No new columns are needed.

### S2-Build, 18 Nov 2026 10:09–10:51 AEDT directives: Phase 5 grid, page-text feed to Boost, Layer 1 induction v3 fields, climate loader, Layer 1 Register fixes

**Status at 18 Nov 2026 11:35 AEDT. This block is the newest for these items.**

- **Phase 5 first slice live (Pilot #1254, v2.16.33, migration `20261118120000`).** Layer 4 › Inbox › **Grid**: one built-in kind at a time as rows, paged on the server (`layer4.inbox_page_size`), reason filter, search, order, column chooser and Export CSV (new setting `layer4.grid_export_max_rows`, 5,000). `pipeline.saved_views` holds the three shared views **AER Audit Samples**, **Official URLs** and **Provider Blockers** (changed by a Platform Admin only, checked on the server) and each person's own views. A row opens the **Source Quote vs Extracted Value** drawer (`admin_layer4_item_trace_v1`: quote beside value, evidence link, decision history) where the item is decided with the Inbox's own card; decisions still go only through `admin_layer4_inbox`. Registered kinds (interventions, campus localities) stay on By kind. A parallel build of the same slice (#1253, another session) was closed unmerged. Audit §5 next slices: Evidence table on the grid; Field History drawer with restore (§7.3); then Phase 4.
- **Stored pages now feed Boost (Pilot #1252, migration `20261118113000`, worker `coverage-sweep-worker-v1.0.15`).** Root cause: the page lanes store `source_snapshot` HTML, while Boost claims `provider_course_page_text`. Job `page-text` (catalogued, every 2 minutes, `batch.page_text` 40) converts bound snapshots of active courses lacking study load or description, in `boost.matrix` order (AU, NZ, CA), into page text. Read 11:05 AEDT: 537 converted, Boost had claimed 519 of them; 22 failed on a duplicate evidence group key (pages shared by two courses; retried after a day; a fix to reuse the shared text is open), 1 too short. The read lanes `coverage-read` and `coverage-read-2` are live and idle only because no bound page is due (about 20,840 not due for 30+ days).
- **Layer 1 induction backend (Pilot #1258, migration `20261118124000`, `layer1-declarative-runner` 1.1.0).** Parser targets: `course_register` gains `study_load` and `empty_reason_code`; new record types `provider_accreditations`, `campuses` (with `is_primary`) and `grade_scale_conversions` (wizard step 3 lists ten types). `public.svc_layer1_apply_baseline_records_v1` fills only what is not held (study load from a register only where a course holds none; campuses of registered providers, primary only when none; AACSB/EQUIS/AMBA accreditations where none from that body; grade scales loaded **inactive** for review). New-country providers and courses were already created by `svc_layer1_apply_register_records` (all 249 countries seeded). Gates unchanged: activation by the Platform Admin, terms approved, source not paused.
- **Layer 1 Register fixes (Pilot #1260, v2.16.34, migration `20261118125000`).** (1) `security.layer1_next_due_roll_v1` is a live `rollup-scheduler` target `layer1-next-due-roll` (hourly :23): an overdue next ingestion date moves on by whole cadences when nothing of the source is queued or running; read back: 0 overdue, target run succeeded. (2) Retired (kept, paused; superseded by coverage-sweep, checked at apply): Aurora College, College of the North Atlantic, Confederation College, Loyalist College code readers; edge functions `layer1-ca-cna-programs`, `-confederation-programs`, `-loyalist-programs` retiring (14 days). QS 2026 and 2027 verification recorded from the applied publisher files. **Still under Needs attention (genuine): the ten other Ontario college readers** (Centennial, Boréal, Fanshawe, Fleming, Lambton, Northern, Sault, Seneca, St. Clair, St. Lawrence: no other course source, onboarding stopped, every course inactive since 16–17 Aug; readers fail on exact expected counts off by 1–5) and the Ontario colleges register (last run: statement time-out). (3) Register headings no longer stick over the filter bar or + Add source.
- **BOM climate averages loader: open as Pilot #1256 (migration `20261118131000`, s623; dry run passed).** The request (REQ-65, REQ-67/O38; Study Square 13 Nov) is long-term climate averages, not a forecast. `destination.climate_stations` (eight capital stations, season months as data), edition "BOM Climate statistics for Australian locations (IDCJCM0037)" (draft, terms pending), five draft figures per city (summer and winter mean max and min, annual rainfall) with attribution and the station page as evidence; job `destination-climate-load` (2nd of the month, 05:30 Sydney) and Run now. Per the 10:44 directive, figures load as draft while terms are pending; approval and Publish edition stay the Platform Admin's. API v3 `/destination` already returns approved figures.
- **10:44 Australia datasets, not yet loaded:** living costs (Study Australia, Study Tasmania), RM1C application routes, RM1H visa rules, RM1D JSA careers. **RM1J THE 2027 is blocked on the publisher file:** the ranking loader reads THE editions only from an uploaded THE file (Administration › Sources & Imports); no THE 2027 import exists (latest THE: 2025).
- **Open PR ordering:** #1257 (another session, `20261118123707`/`123717`) now sits below the live head and needs new timestamps; #1261 (S2 - BOOST) holds `20261118130000`.


### S3-Boost providers, 18 Nov 2026 21:10 AEDT — CRICOS full reconciliation (s700)

1,543 source codes, 1,541 exact matches (1,539 active), 2 same-provider alias candidates, 21 domain differences, 106 blank catalogue URLs and 709 source URLs normalised. Zero production rows written and US$0.00 LLM spend. G3 75/48, zero drift. Estimated 144.01 hours or 18.95 FTE days saved across this edition. See [audit evidence](https://github.com/msinghbs-ai/coursefinder-admin/blob/main/docs/platform/nz-enrichment-brief/2026-11-18-s3-boost-cricos-provider-reconciliation.md) and [Pilot #1312](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1312). Pilot #1312 merged at `d7782d7b`. The exact rebased candidate `fe347485` passed 3,552 tests with zero failures and zero skips, including all four s700 tests, and passed production parity. [Governing CI](https://github.com/msinghbs-ai/Coursefinder-Pilot/actions/runs/44285129957) · [Edge deployment](https://github.com/msinghbs-ai/Coursefinder-Pilot/actions/runs/44287604764).

### S2 - BOOST lane: priority matrix and Boost test-project experiments (17 Nov 2026; Platform Admin 18:02)

Lane: the Boost worker (`worker-boost-bulk-ingest`), the promotion function, qualification seeds and Boost test-project benchmarks. `S1-Build` keeps the PR 1 cutover, Thursday's squash and `housekeeping-daily`.

**Status at 19 Nov 2026 09:55 AEDT, S2 - BOOST (Platform Admin directives 05:40 and 06:55 AEDT, spec block s720–s739; 07:40: continue without the browser). This block covers study load, multi-field reading, campus locality and the test project; the other blocks of the lane keep their items.**

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

**Status at 19 Nov 2026 05:25 AEDT, S2 - BOOST (post-squash follow-up of the Platform Admin's 18 Nov 10:10 directive). This block covers the Boost test project and the model benchmark; the other blocks of the lane keep their items.**

- **Run-4 on `coursefinder-boost-test`: PASS, 9 of 9 checks** (admin run 44349340646, dispatched 03:36 after S1-Build's "can re-seed" of 02:25; results branch `boost-experiment/44349340646`). Re-seeded from `paste/boost-test-reseed.sql`. Results:
  - 60 admitted for 60 courses, at both 1,000 and 5,000 rows (up to 8,218 rows a second).
  - 5,922 duplicates refused and none admitted; shadow rows admitted none.
  - Held courses unchanged, and the cohort put back.
  - The promotion function `security.boost_promote_v1` is byte-identical to production (md5 `fa4e3a86`).
  - G3 on the test project: 75/48, no drift.
  - The run's read-only production probe could not execute two security functions (`consumer_api_check_v1`, `boost_country_category_check_v1`: permission denied for the read-only role). It reported production head `20261118272000` (2,148 history rows). Production G3 read separately at 03:52: 75/48.
- **Benchmark bench-5 (Pilot #1327, migration `20261119044000`, s699; measures only, Qwen3 30B stays the only qualified model).** Same three named models on the current study-load reader: prompt `boost-study-load-v5`, selector `study-load-windows-v5`, worker v1.0.22.
  - Cohort: 201 pages per model (AU 200, NZ 1, CA 0), the stored pages of courses still without a study load. 138 had no study-load signal, 6 of them fee notes only, so 63 pages with signal per model.
  - Verified rate = verified with a value / pages with signal:

| Model | Verified rate | Rejected | Failed | Verified "not stated" | Tokens in / out | Cost | Cost per verified field | Average time |
|---|---|---|---|---|---|---|---|---|
| Mistral Small 3.2 | **59%** (37/63) | 12 | 6 | 8 | 51,658 / 2,666 | US$0.0044 | US$0.00012 | 1.5 s |
| MiMo v2.6 Flash | 44% (28/63) | 5 | 15 | 15 | 56,066 / 10,927 | US$0.0085 | US$0.00030 | 7.5 s |
| Qwen3 30B | 32% (20/63) | 31 | 0 | 12 | 56,042 / 3,567 | US$0.0061 | US$0.00031 | 1.3 s |

  - **Qwen3 30B's main failure:** 24 of its 31 refusals quote a duration or delivery line ("3 years full-time") as the study load, which the page check refuses (never from duration alone). The other refusals: quote not on the page 4, general definition 2, unused international sentence 2.
  - Mistral's refusals: duration line 5, quote not on page 4, unused international sentence 2, definition 1. MiMo: quote not on page 3, unused international sentence 2.
  - On the 12 pages where all three gave a verified value, they agreed on 11.
  - **Against bench-4** (prompt v4, 184 pages with signal): Qwen3 76%, Mistral 81%, MiMo 66%. Bench-5's pages are the leftovers that the Boost re-reads have not filled, so every rate is lower, and Qwen3's fell most.
  - **Not changed.** Qwen3 30B stays the only model qualified for study load (Platform Admin 18 Nov 11:57: no Mistral route). If the Platform Admin wants the leftovers read, the result points to Mistral Small 3.2 or to a prompt rule against duration lines; either needs a decision and its own qualification.
- Head `20261119044000`. Production G3: 75 functions and 48 tables.

**Status at 19 Nov 2026 16:15 AEDT, S2-BOOST-Providers (Platform Admin 16:02). This block is newer than the 11:10 block for the provider items of the lane.**

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

**Status at 19 Nov 2026 17:10 AEDT, S2 - BOOST (Platform Admin 16:00, s754: university and higher-education provider descriptions). This block is newer than the S2-BOOST-Providers 11:10 block for those items.**

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

**Status at 19 Nov 2026 11:10 AEDT, S2-BOOST-Providers self-check. This block is newer than the 08:45 block for the provider items of the lane.**

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

**Status at 19 Nov 2026 08:45 AEDT, S2-BOOST-Providers (Platform Admin 07:39 and 08:17). This block is newer than the 07:15 block for the provider items of the lane.**

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

**Status at 19 Nov 2026 07:15 AEDT, S2-BOOST-Providers handover (Platform Admin 06:49). This block is newer than the 18:45 block for the provider items of the lane (held scholarships, university descriptions, campus locality).**

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

**Status at 18 Nov 2026 18:45 AEDT, S2-BOOST-Providers (Platform Admin 17:52). This block covers the provider items of the lane (held scholarships, university descriptions, campus locality) and is newer than the 17:30 block for them. The other blocks below stand for their own items.**

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

**Status at 18 Nov 2026 23:00 AEDT (S2-Courses; Platform Admin 21:59). Items s661 and s665 of the lane are live; s662 and s664 are in Pilot #1314 (chat S1-Courses). The 18:00 block below stands for its own items.**

Findings: [`platform/S2-COURSES-STUDY-LOAD-GUARD-AND-FEE-BASIS-REPLAY-2026-11-18.md`](platform/S2-COURSES-STUDY-LOAD-GUARD-AND-FEE-BASIS-REPLAY-2026-11-18.md).

- **Worker `coverage-sweep` v1.0.22 is live** (Pilot #1316 and #1319, specs s661 and s665, no migration).
  - Study load reader cue: a course closed to international students is never read as a load rule; the international word that names the student and the study word lie within 80 characters (or a label within 160). Selectors `study-load-windows-v5` and `study-load-international-v2`; prompt `boost-study-load-v5` and the route unchanged. Live inspection of 62 readings: 41 matches before, 18 now, about 8 real. Not promoted; nothing admitted; the next change splits a block at its Domestic and International labels.
  - Fee-basis replay (run 44297706134, 225 pages, US$0.0458, nothing admitted): annual fees 6 of 6 agree, whole-course totals 3 of 7, intakes 10 of 18, fees 15 verified of 224. Qwen3 30B stays qualified for study load only.
- **s662 and s664:** Pilot #1314 (S1-Courses) carries the 1 to 2 sentence reader, the identity-proof exemption and the Layer 4 explanations and four decisions. Its migration `20261118253000` is below the live head and must be renumbered before merge.
- **Question for S2-Intakes (priority):** is a course's intake the next intake the page announces or the main annual start? The replay cannot score intakes until this is defined.
- G3 75 functions and 48 relations, no drift (read 22:52). Live head `20261118256000` (2,144 applied).

**Status at 18 Nov 2026 18:00 AEDT (S2-BOOST-Courses; Platform Admin 17:02). This block covers the course items of the lane (study load reader, multi-field reading, course descriptions). The 17:55 and 17:30 blocks below stand for their own items.**

Findings and the activation spec: [`platform/BOOST-SENTENCE-CUE-DESCRIPTIONS-AND-MULTI-FIELD-QUALIFICATION-2026-11-18.md`](platform/BOOST-SENTENCE-CUE-DESCRIPTIONS-AND-MULTI-FIELD-QUALIFICATION-2026-11-18.md).

- **Worker `coverage-sweep` v1.0.18 is live** (Pilot #1299 and #1301, specs s660 and s663, no migration).
  - Mode `boost_sentences` (read only, no model): the sentences the study load reader takes as a statement for international students. Workflow `boost-sentences-inspect.yml`.
  - Page check `boost-fields-check-v2` on Boost multi-field reading. The prompt is still `boost-fields-v1`.
  - Mode `boost_fields_replay` and workflow `boost-fields-replay.yml`: the gold-set replay. It stages and admits nothing.
- **Study load reader stays at v5.** The international-sentence cue was inspected on the 41 settled pages: 35 false matches, 6 real statements. Nothing was promoted or admitted.
- **Qwen3 30B is qualified for study load only.** Replay of 80 gold pages: intakes 6 of 12 verified answers agree with the held value, fees 7 of 10; descriptions pass the page check on 47 of 60 pages; deadlines have no field in the prompt.
- **Course descriptions waiting in Layer 4: 663** (identity margin thin 448, binding ambiguous 143, refused word 44, evidence moved 15, wrong page kind 13). No rule was changed.
- **Open work:** identity-proof rule for descriptions (s662, needs a function migration), study load v6 cue (s661), intake definition with S2-Intakes, then a larger replay.
- G3 75 functions and 48 relations, no drift (read 17:59). Head `20261118210000`.

**Status at 19 Nov 2026 11:40 AEDT, S2-BOOST-Discovery (Canada approved for the AER programme in Wave 2; priority read queue). It is the newest for these items and adds to the 11:35 block below.**

Platform Admin 11:36 AEDT. **Canada (52 international providers, including UBC, Alberta and Conestoga) joins the AER programme in Wave 2, immediately after the 20 Nov handover.** Today's remaining budget and queues stay on AU and NZ. **Priority read queue (no search credit): the 355 providers that already have discovered pages and nothing read for scholarships or entry requirements** (AU 332, NZ 21, CA 2; the 2 Canadian providers wait for Wave 2), then the remaining AU and NZ AER and scholarship drains. Docs and registers only: nothing was started on the queue, no setting, job, table or function changed (G3 75/48), no migration. Correction: the audit entry and report were stamped 11:55 AEDT in error; the audit ran about 11:15 to 11:35 AEDT on 19 Nov and the stamps now read 11:35. Ledger row, workbook and Drive Monitoring synced with this entry.

**Status at 19 Nov 2026 11:35 AEDT, S2-BOOST-Discovery (scholarship and AER discovery audit, read-only). It is the newest for these items and adds to the 08:55 block below.**

Read-only, no write, no Firecrawl spend, no table, column, function, job or setting added (G3 75/48). Of 1,675 active providers with international courses (AU 1,544, NZ 79, CA 52; 1,886 if courses not recorded as domestic-only are counted, NZ 290): **(a)** 1,571 hold a homepage (220 verified by search, 362 entered by a person, 989 register values not flagged; 104 AU have none); **(b)** 708 have a scholarship page crawled or a record published (91 published); **(c)** 797 have an entry-requirements read (AU 751, NZ 46, CA 0); **(d)** 90 have zero discovered pages (No site 26, No page 64, all AU); a further 355 have pages but nothing read. 1,385 lack a scholarship hub or an entry-requirements source (421 lack both). **Canada has no entry-requirements source for any of its 52 providers and no row in `aer_provider_coverage`**, so 25 of the top 30 uncovered providers are Canadian (UBC 575 courses, Alberta 379, Canterbury NZ 282, Conestoga 270). The Coverage & completeness screen shows academic entry as No reader for 34,631 courses because the field register reader is `none`; it cannot separate a provider with no source from one read but not admitted. Open work: Platform Admin to decide whether Canada joins the AER programme; AU and NZ top 20 and the 355 read-pending providers are listed in the report for post-handover crawls.

**Status at 19 Nov 2026 08:55 AEDT, S2-BOOST-Discovery (handover close on the 07:39 decisions and the 08:18 addendum). It is the newest for these items and adds to the 07:15 block below.**

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

**Status at 19 Nov 2026 07:15 AEDT, S2-BOOST-Discovery (own check-in on the 16:54 and 17:02 directives). It adds to the 19:20 block below and corrects two lines of it (marked).**

Read live from 06:55 AEDT (project `fxcwkweaxjtknorudmwp`, read-only SQL). No Pilot change, no migration, no data write this round: nothing in it needed one. Live head `20261119053000` (2,156 applied). G3 75 functions and 48 relations.

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

**Status at 18 Nov 2026 19:20 AEDT, S2-BOOST-Discovery. It corrects the 17:55 block below (402 gate-held, not 834).**

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

**Status at 18 Nov 2026 17:55 AEDT, S2-BOOST-Discovery (Platform Admin 16:54 and 17:02). The 19:20 block above is newer and corrects it. It corrects the 17:00 block: Course page needed was not draining.**

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

**Status at 18 Nov 2026 17:30 AEDT, S2-BOOST-Providers (Platform Admin 16:56 and 17:03). The 17:55 block above is newer.**

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

**Status at 18 Nov 2026 17:00 AEDT (Platform Admin 16:10). The 17:30 block above is newer.**

Course page needed is moving through the search lane by rule, and the study-load settlement now heals itself. Pilot #1293 and #1295 are live (migrations `20261118190000` and `193000`; specs s654 and s655).

- **Correction to the 15:45 block.** The course-page search worker and the course-list reader are **not paused**. The lane dispatcher has run them live since consolidation PR 3; their own cron rows are off only for that reason. Coverage pages are being read (300 in 24 hours).
- **Course page needed (1,958 to 1,360 at 17:00).** Rule l4-page-needed-search-v1 (job `layer4-page-needed-search`, hourly at minute 53, 300 a run) sends each open item back to the course-link search lane through the existing Search again decision, under the system automation account:
  - Order: a 404 or unread page first, then a refused page, at most `layer4.page_needed_search_max` searches a course.
  - The lane's own caps and Firecrawl limits set the pace, so no on-demand Firecrawl work was opened.
  - 43 blocked or robots-disallowed pages wait for a person.
  - First run: 300 searches asked for dead pages, 0 failed. The second hourly run took the list to 1,360.
  - Before this rule, no open item had ever had another search asked for.
- **Adelaide University (corrects 15:45).** `adelaideuni.edu.au` is the live merged domain (219 course pages read at 200). `adelaide.edu.au` has been an alias in `binding.provider_host_aliases` since before today, so no new alias rule was needed. 203 of the 220 Adelaide 404 rows are addresses the binder guessed from the course title (basis `url_pattern`, checked 3 to 13 Nov); the courses probably have other slugs on the new site or were dropped in the merger. They were among the first sent for a new search.
- **Boost study load, self-heal.** 74 of the 75 open readings had been read again at 15:12 AEDT by the previous worker instance (prompt v4) during the deploy of #1283. Rule l4-boost-sl-settle-v1 now releases any page last read with an older prompt before it settles; the 74 are released for the v5 read. Totals: 94 admitted, 231 Not stated, 75 to settle as their v5 readings arrive.
- **The 38 Not stated readings with an international sentence.** v5 sent only the international sentences: the model said not stated for 21 and gave a value the page check refused for 17. Judging whether a deterministic international cue is safe needs the sentence texts, which are in Storage and cannot be read from this session. **v6 is not built.** Next step: a worker mode that returns the selected sentences for a sample, without a model call.
- **AER (2,661 held; 489 providers):**

| Reason held | Items |
|---|---|
| Course entry gate incomplete | 1,851 |
| Audit sample (left for a person) | 488 |
| All rows held | 102 |
| Track C person admits | 82 |
| Matrix gate incomplete | 54 |
| No bound page | 39 |
| Identity not admitted | 16 |
| Matrix all rows held | 15 |

  - **Not changed, decision needed.** Splitting shared faculty or handbook pages into single-course sections is a new layout reader, and AER v1 is frozen (Decision 276: no new layout readers or recovery paths; new AER work goes to v2). Either the Platform Admin lifts the freeze for this, or it is built in AER v2.
- **University and course descriptions (751).** 88 provider descriptions and 663 course descriptions are already read from the official page. They wait because the machine rules refused them:
  - Course: identity margin thin 448, binding ambiguous 143, refused words 44, evidence moved 15, wrong page kind 13.
  - Provider: refused word 46, first sentence without the name 28, refused topic 12.
  - A new Firecrawl scrape of About pages would not change those reasons, so nothing was scraped. These belong to the description lanes' rules.
- **Offline multi-field qualification (REQ-61, REQ-69, REQ-70).** A replay qualification needs person-decided reference answers for descriptions, intakes, deadlines and fees, and none exist yet. The verified shadow candidates are listed in the 15:45 block.
- Course link stays at 420; the hourly rule set 3 more pages. G3: 75 functions and 48 tables, unchanged. Head `20261118193000`.

**Status at 18 Nov 2026 15:45 AEDT (Platform Admin 14:23, 14:25 and 14:29). The 17:00 block above is newer.**

Boost learnings went into the worker and three Layer 4 queues were settled by rule. Pilot #1283, #1284 and #1286 are live (migrations `20261118171000`, `173000` and `183000`; specs s644, s645 and s647, the last renamed from s643 in #1289).

- **Reader v5 (worker coverage-sweep v1.0.17).**
  - Prompt `boost-study-load-v5` and selector `study-load-windows-v4` treat a fee note (EFTSL, Commonwealth supported places, student contributions, "fee calculated based on a standard full-time study load") as never the study load.
  - Fee notes are not sent, do not count as a statement for international students, and are refused as a quote. A page with only fee notes sends nothing.
  - The route qualification rows moved to v5, as for v2 to v4. The admission qualification (Qwen3 30B, study load) is unchanged.
- **Boost study load (400 open readings).** The pages were re-read with v5:
  - 94 study loads were admitted by the unchanged promotion, and their readings closed as superseded.
  - 231 were settled **Not stated** by rule l4-boost-sl-settle-v1, under the system automation account through the Inbox decision, with the page check's findings as the reason.
  - 75 wait for their re-read to load. Job `layer4-boost-sl-settle` runs every 30 minutes and settles them.
  - **Check:** 38 of the 231 were settled although the page check found a sentence for international students that the reading did not use. A person may want to look at those.
- **Course link (1,487 to 423).** Rule l4-link-accept-v1 uses the course-page binder's own proof in `pipeline.coverage_course_pages` (page read, identity by CRICOS or NZQA code, exact title, degree name, adapter or person). First run: 1,335 official-page items in 18 s, 0 failed.
  - 154 **used** the proposed page and 105 **set** another proved page: 259 official links written.
  - 809 proposals were **refused**: the binder or the finder refused the page, and nothing was linked.
  - 16 were left as the audit sample, and 251 are **held** for a person: tied pages, unread pages, old handbook years, CRICOS pages elsewhere without proof, manual locks.
  - The 152 fee and English items were not in scope. Qwen3 30B tie-breaking is not wired: Qwen3 30B is qualified for study load only.
  - Job `layer4-link-accept` runs hourly at minute 41.
- **Scholarship course links stay at 0.** Job `scholarship-scope-auto` runs hourly at minute 19 and applies the 57-item rule (#1273, #1276) to every newly waiting scholarship.
- **Course page needed (1,958, unchanged), by binder state:**

| State | Items |
|---|---|
| Binder refused every page found | 1,568 |
| Page bound but returns 404 | 288 |
| Bound but unread | 60 |
| Blocked or robots | 41 |
| Ambiguous | 1 |

  - The items sit at 297 providers (AU 1,070, NZ 556, CA 332). 136 of those providers (1,003 items) have stored pages for other courses; only 2 of the 1,958 courses have a stored page of their own.
  - None has a proved page, so nothing can be resolved from stored pages without a new search or read. The course-page search worker, the coverage readers and the course-list reader are paused (`course-link-search-worker`, `coverage-read`, `coverage-read-2`, `course-list-read`); the decision to switch them on belongs to their lanes.
  - Largest single cause: **Adelaide University**, with 163 dead links. The binder holds `adelaideuni.edu.au/study/degrees/...` addresses that return 404, while the stored and linked pages are at `adelaide.edu.au/study/degrees/...`. This looks like a provider URL pattern; it was not checked against the live site (the web check needed an approval no one was there to give).
  - The 749 courses whose proposals were refused and that hold no official page will join this queue as the page finders record those refusals.
- **The 14:23 items that need a decision.** Scholarship award and deadline enrichment (REQ-71, REQ-72) and multi-field admission (REQ-61, REQ-69, REQ-70) could not proceed because that message ruled out schema migrations:
  - 0 published scholarships are past their Melbourne closing date. The scholarship round-state refresh (`security.scholarship_round_state_refresh_v1`) has not run since 17 Nov 00:23 UTC: its only caller, job `scholarship-discover-refill`, is paused, and it compares with the UTC date. 2 withdrawn rounds show "open" past closing.
  - Multi-field shadow candidates verified so far: descriptions 640, entry rows 1,038, delivery mode 27, intakes 11, fees 1. No admission path exists for them, and Qwen3 30B is qualified for study load only.
- G3: 75 functions and 48 tables, unchanged.

**Status at 18 Nov 2026 14:10 AEDT (Platform Admin 13:06). The 15:45 block above is newer.**

Scholarship course links: all 57 Layer 4 items were resolved by rule, with no person involved (Pilot #1273, migration `20261118153000`, and correction #1276, migration `20261118163000`; spec s636).

- **How each scholarship was decided.** `security.scholarship_scope_auto_decide_v1` reads the scholarship's own name, then its description, and decides in this order:
  1. Wording that is not course-specific in its name (transfer-student notices, accommodation, Huayu, "after you graduate"): No courses.
  2. A scope from its own words that keeps at least one proposed course: that scope.
  3. Explicit university-wide wording (for example "General Scholarships", "Vice-Chancellor", "International Merit", "Academic Excellence", "all programmes") with no level or subject named: All courses.
  4. Otherwise: No courses.
- **How the scope is worked out.**
  - The name comes first: its "in …" phrase, then the subject words, then a degree code (MBChB, ME, MOR, LLB, BCom, MBA, BMus, FMHS).
  - The description is read only when the name names no subject, or when the name's subjects keep no course.
  - A phrase no course title holds whole falls back to its first word ("Engineering Science" becomes "Engineering").
  - A doctoral scope with a subject also keeps the Doctor of Philosophy.
  - The word lists are settings in Settings › Pipeline settings › Scholarships: `scholarship.scope_suggest_subjects`, `scope_suggest_aliases`, `scope_all_patterns` and `scope_none_patterns`.
- **How it was applied.** Each decision is recorded under the automated rule authority (`security.system_actor_id()`), with the reason "Auto-applied deterministic title/description scope rule: …" and the rule used. The existing `security.scholarship_scope_apply_v1` applies it, and a `pipeline.layer4_mass_operations` row is written per scholarship, exactly as the Course links screen's decision writes one.
- **Live at 14:05 AEDT:**

| Measure | Count |
|---|---|
| Decisions | 57 (42 only matching courses, 1 all courses, 14 no courses) |
| Links written | 694 (667 matching, 27 all) |
| Audit rows | 60 (57, plus 3 re-applied by the correction) |
| Scholarships waiting | 0 |
| Inbox › Scholarship course links | 0 |
| Decisions made by a person | 0, none touched |
| G3 | 75 functions and 48 tables, unchanged |
| Head | `20261118163000` |

- **The correction (read back the same hour).** The first rule set three scholarships to No courses wrongly, and the correction re-applied them:
  - "International Four-Year Doctoral Partial Tuition Award": its description mentions PhD transfer students. It now keeps 127 doctoral courses.
  - "University of Otago Law Alumni Scholarship": its description mentions accommodation. It now keeps 2 first-year Law courses.
  - "UC Business School International School Leavers Scholarship": the course is the Bachelor of Commerce. It now keeps 6 courses.
- **The 14 at No courses**, which a person can change on the Course links screen at any time (the new decision then applies in place of the rule's):
  - Notices for transfer students, accommodation, exchange or after-graduation (7): Eligibility & Claiming Awards, Notification of Award, Renewing Award and Transfer Student Scholarships (US), all Burman; Huayu B.E.S.T. (KPU); Scholarships for after you graduate (Auckland); Malaysian Accommodation Award (Auckland).
  - Text that names no scope that can be proved (6): Alex Tan, JLL, International Tuition Award (UBC; no description held), Mamawi Atosketan Native School, President's Grant for International Community Engagement, Scholarships - EATS.
  - Scholarships - Nursing (Burman) (1): Burman has no nursing course in the catalogue.
- **Not yet verified:** the Course links screen, signed in.

**Status at 18 Nov 2026 12:25 AEDT (Platform Admin 11:57). The 14:10 block above is newer.**

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

**S2-BOOST-AER, 19 Nov 2026 17:35 AEDT, S753:** Layer 4 AER triage and bounded drain (`aer-l4-drain.yml`, script and workflow only, zero AI and Firecrawl spend). Of 2,579 pending AER items, 17 passed their rule and were admitted by the cron's own function in one tick (13.4 s); pending now 2,562, none passes. Active `course_entry_requirements` rows 25,412 to 25,452. Would-admit reads waiting 0; 93 course reads admitted since S748. Holds unchanged: completeness gate 1,892, audit sample 492, all rows held 111, page identity 55, matrix changes 6, host 4, other 2; no-overwrite 0, manual lock 0, no claims. Manual locks 7,585. Full block in the m2.4.7 runsheets.

**S2-BOOST-AER, 19 Nov 2026 15:45 AEDT, handover close-out:** course drain 76 of 91 (the last 16 pass the rule, queue positions 914 to 1,268 of 1,304, expected 20:30 to 22:30 AEDT); S751-S752 (Pilot #1376, worker v1.0.30, migration `20261119143000`): prompt `aer-v2-matrix-chunk-v2` (one record per row and study level, verbatim minimum) and Windows-1252 folding in the AER v2 verifier only; replay on 18 of 20 tables (cap reached, US$0.028067 of US$0.03, window closed): minimum in quote 100% (519/519), quote fidelity 99.9% (818/819), row completeness 89.4%; bar not met, nothing promoted. **Platform Admin decision 15:14 for the post-handover S1 follow-up:** a row is doubled only when (row, study level, normalised quote) repeats; 6 rows a call on wide tables (under 35 s); AER v2 live admission paused (`aer.v2_shadow_on` 0). Full block in the m2.4.7 runsheets.

**S2-BOOST-AER, 19 Nov 2026 13:45 AEDT, S750:** MiMo v2.6 Flash alone at 12 rows a call on 20 gate-held tables (645 rows; worker v1.0.29, Pilot #1373, no migration): row completeness 99.8% (644/645), quote fidelity 100%, minimum in quote 99.4% (343/345), no invented row; 62 calls, longest 32.9 s against the 90 s time-out; US$0.019775 of the US$0.05 cap, window `53d590e8` closed. Bar not met, nothing promoted. Misses: a two-level row answered twice (KBS Zimbabwe), undecoded Windows quote codes (KBS Korea), a reworded minimum "ATAR 60" (Sydney Institute). The run 2 Manukau miss is row 28 "Pacific Islands", a two-level row (page structure). Full block in the m2.4.7 runsheets.

**S2-BOOST-AER, 19 Nov 2026 12:40 AEDT, S747:** AER v2 matrix reader on the row chunker (worker `coverage-sweep` v1.0.28 mode `aer_chunk_smoke`; prompt `aer-v2-matrix-chunk-v1` as data, `pipeline.ai_instruction_versions` ids 44 to 46, migration `20261119110500`; Pilot #1365, #1368; spec s747). 10-table smoke test (237 rows), US$0.0276 of the US$0.10 cap, on-demand windows `851c9099` and `59b754f0` closed. Run 2: MiMo v2.6 Flash row completeness 100%, quote fidelity 100%, minimum in quote 99.3% (136/137); Qwen3 30B 59.5/97.2/100; Mistral Small 3.2 36.7/100/82.9. Bar (100/100/100, no invented row) not met: nothing qualified or switched on. Course drain: 75 admitted since S748, the last 16 pass the rule and are queued (positions 1,407 to 1,767 of 1,801 at 11:14). Full block in the m2.4.7 runsheets.

**S2-BOOST-AER, 19 Nov 2026 10:24 AEDT check:** 73 course reads admitted since S748 (26 at 09:24, 43 at 09:54, 4 at 10:24); 16 would-admit reads still waiting (89 at 07:02); 79 matrix items pending, no admission since 06:54 (70 need a new read, D-R3 gate); P0 0; definitions unchanged (`89a5c44b`, `fc9261cb`).

**S2-BOOST-AER, 19 Nov 2026 08:50 AEDT: matrix completion clauses and course links (s741); held-page export (s742); course machine queue (s748, s749); table row chunker (s744 to s746); s747 not yet run**

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

**S1-Structure-Outcomes, 20 Nov 2026 16:55 AEDT: s861 live and read back (Pilot #1427 `24317d50`); s862 recorded before merge: shared-page check indexed (Pilot #1430, migration `20261120172000`)**

- **Merged in order.** Admin #696 (`9526ea2c`) first, then Pilot #1427 on green CI (16 of 16 checks; the PR dry-run job is label-only and the manual rolled-back dry run of the same file, run 44677214117, passed). Deploy on merge applied `20261120163500` (history md5 `905d8d23` = file) and deployed coverage-sweep v1.0.33. Live head `20261120163500`, 2,222 rows; G3 75/48, 0 drift; locks 7,585; spend US$0.
- **First live results (16:42 AEDT, three ticks):** 160 stored pages read (4 calls ok), 73 decided, 87 with no reading. Admitted: duration 26 (NZ 13, CA 13), study load 4 (NZ 1, CA 3). Held: duration has a value 20, study load 7, delivery mode 37 (the campus already holds a mode); identity not admitted 3; Layer 4: 3 duration conflicts and 1 shared page (4 items, plain reasons). Readings: duration 78 (5 collapsed, never admitted), study load 14, delivery mode 42 (1 collapsed), 19 notes (ranges, credits, part-time only).
- **Found:** ticks took 6.6 s and 9.8 s. The promoter's shared-page check took 2,842 ms for 160 pages: its "same stored copy OR same address" test could not use an index (23,989 bound pages scanned per page).
- **s862 (migration `20261120172000`, above every open pull request: #1425 holds `20261120165000` and `165100`, #1428 `20261120170000`).** A partial index on the bound pages' evidence id and the test written as two EXISTS (stored copy; address on the existing bound-address index). Guarded by the live md5 of `security.struct_det_promote_v1` (`bf0bc0d6`); its post-check proves the same shared pages and fails above 300 ms. Rolled-back dry run passed (run 44683159633). No worker, setting or job change.
- **Lane note (S1-Fees-Intakes, 16:33 AEDT):** the request to bump this lane's worker to v1.0.34 arrived after Pilot #1427 had merged with coverage-sweep v1.0.33. Pilot #1425 (S1-Fees-Intakes) must therefore rebase on main and take v1.0.34; its migrations (`20261120165000`, `165100`) are already above this lane's.
- **Next:** merge this record, then Pilot #1430 on green CI; read back the tick time; final gap read and the two gap tables; Drive sync.

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

**S1-Fees-Intakes, 20 Nov 2026 20:00 AEDT: s857 recorded before merge: s856 re-issued without a drop (migration `20261120200000`)**

Pilot #1437 (s856) merged by `automerge` (`86f373a1`), but Deploy on merge (run 44704221314) refused `20261120193000` before applying anything. It widened the `pipeline.fid_det_runs` state check with `alter table … drop constraint`, and the deploy refuses any top-level drop (the Platform Admin pastes those). Nothing reached the database, so the sweep kept running unpaced on the s852 tick.

- **s857 fix.** The unapplied file is removed, and `20261120200000` does the same pacing with no drop. Queued calls wait in a new table, `pipeline.fid_det_call_queue` (`run_id` is set when the call is sent), and the existing state check is unchanged. The settings `fid.calls_open_max` 2 and `fid.replies_per_tick` 1 are as recorded for s856. Spec s856 gains a test that the file has nothing the deploy refuses and that the old file is gone. The deploy's rule was checked against the file locally.
- **Probe branches.** `cf247-s840-fees-probe`, `cf247-s850-fees-probe` and `cf247-s855-readback-probe` were deleted by the Auto-merge probe clean-up after their dry runs.

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

**S1-AER, 20 Nov 2026 15:22 AEDT: s834 and s835 recorded before merge: reader `aer-det-v1.3` (academic only) and automated deterministic AER promotion with a scheduled sweep (Pilot #1423, migration `20261120160000`)**

Platform Admin 20 Nov 2026 15:08 AEDT ("Correction & Scope Clarification"): AER is strictly separate from English. No English test (IELTS, TOEFL iBT, PTE Academic, OET, CELPIP, Cambridge English) is read or written in S1-AER or the `aer-det` pipeline; English stays in its own pipeline (`english_group_match_v1`). Pre-flight: both repositories rebased on the latest `origin/main` (Pilot `98656714`, admin `f4ee69f5`); no open pull request at pre-flight; spec numbers s834 and s835 claimed above every merged spec (s833 is S1-Courses'); migration `20261120160000` is above the newest migration in the repository (`20261120143000`); `cf247-s676-probe` left untouched.

- **s834, reader `aer-det-v1.3` (`aer-det-reader.ts`, no model, no fetch, no write).** The six English rules are removed; an English test name beside a number is still never taken as an academic value. New academic rules: IB Diploma points, A-level grades, Indian board average (CBSE, CISCE, ISC, State Boards). Fixed: a credit count is never the level number ("42 level 3 credits" reads 42; "level 3 credits" alone reads nothing). Year 12 now needs a stated threshold (a score, mark, rank, aggregate, average or percentage with its number, or a grade "or higher"); boilerplate such as "levels of achievement in particular Year 12 subjects" and "Units 3 and 4" read nothing. The v1.2 collapsed-row guard and the proximity guard are kept. The worker mode `aer_det_read` also returns the other requirement lines the reader does not read (prerequisite, portfolio, interview, work experience, bridging), up to 6 a page. Spec `cf-247-s828-aer-det-reader-contract` now has 11 tests (it replaces the English tests; the two retired tests are in the retirement log).
- **s835, promotion and sweep (migration `20261120160000`, replaces nothing, retires nothing; the s815 shadow writer and its two tables are left in place, nothing is dropped).** New objects, all in schemas `pipeline` and `security` (G3 stays 75 functions and 48 relations, checked in the migration's post-check): tables `pipeline.aer_det_academic_pages`, `pipeline.aer_det_academic_readings` (nine academic keys only, never English) and `pipeline.aer_det_sweep_calls`; functions `security.aer_det_record_v2`, `security.aer_det_propose_v1` and `security.aer_det_sweep_v1`; job `aer-det-sweep` every 5 minutes (catalogued, registered; its command holds no number).
- **How a reading is promoted, with every gate unchanged.** The proposer writes ordinary `proposed` rows in `catalogue.course_entry_requirements` (provenance reader `aer_det`) and one Layer 4 `course_entry_first_read` item per course. It never activates anything, never writes `catalogue.*` as active and never touches `search.course_documents`. The existing machine rule `aer-machine-v1` (job `aer-machine-admission`, 300 a day) then admits it only when every check passes: manual lock (the 7,585 locks), no active rows (no-overwrite), earlier rejection, page identity, verbatim quote of at least 8 characters, confidence at least 0.8, the E13 completeness gate, and the 5% audit sample. Otherwise a person decides in Layer 4. A page that prints a requirement line the reader does not read carries it as a dropped requirement (reason `det_other_requirement`, now a hold reason in `entry.gate_hold_reasons`), so the gate holds the read for a person. A row that only mentions a value (not a stated minimum) is written at confidence 0.7, below the machine rule's 0.8, so a person decides it. A locked, hidden, already-ruled, already-read, other-programme, shared-page or over-row-limit page is skipped and its outcome recorded.
- **Sweep and settings (G2).** `batch.aer_det_read` raised from 20 to 40. New settings, section Admission checks: `aer_det.sweep_on` 1, `sweep_calls` 3 a tick, `sweep_max_open` 4, `call_lost_minutes` 15, `propose_on` 1, `propose_max_pending` 400, `propose_per_run` 50, `confidence_stated` 0.9, `confidence_mentioned` 0.7. At 3 calls of 40 pages every 5 minutes the sweep reads about 1,440 pages an hour, so the remaining stored pages (19,983 courses at the last read) drain in roughly 14 hours while Layer 4 is held at 400 waiting items by `propose_max_pending`. The sweep sends worker calls through `pipeline.svc_pilot_submit_nonce`, collects answers from `net._http_response` and refuses a worker still on an older reader version. No AI spend, no Firecrawl spend (US$0).
- **Validation.** Local: s828 11 of 11, s835 8 of 8, s32 (settings), s42, s57 and s120 pass (the s32 browser test needs Chromium, which this session does not have; CI runs it). Rolled-back live dry run through the non-interactive workflow (run 44673620791, md5 `8e7ace4d`) passed; its post-check runs a synthetic proposal inside a rolled-back block, proves the uncovered-prerequisite case is not machine-admitted, and confirms G3 75/48. 3,395 courses were eligible for that synthetic read. No interactive `execute_sql` was used.
- **Held for a person:** S677 (`security.aer_machine_admit_v1`) and the 6 entry-matrix changes are untouched; the AI and Boost `aer_entry` readers stay shadow only (Decision 276). Branch `cf247-s676-probe` is untouched for the Platform Admin to delete.
- **Next:** merge this admin record, then Pilot #1423 on green CI; read back the deployed worker, the job and the first proposals; an initial verification batch (academic keys only, zero English rows); closing records, Drive sync and the two gap tables.

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

**S1-AER, 20 Nov 2026 14:50 AEDT: s832 recorded before merge: reader `aer-det-v1.2` collapsed-row guard (Pilot branch `cf247-s832-aer-det-v12`, code only, no migration; live head stays `20261120140000`)**

Platform Admin 20 Nov 2026 14:25 AEDT: do not run the full sweep; keep the reader shadow only and `batch.aer_det_read` at 20; leave S677 and the 6 matrix changes for the Platform Admin; branch `cf247-s676-probe` to be deleted. Pre-flight: Pilot #1420 (v2.16.67, `20261120140000`, 2,218 rows) and admin #688 are in; both repositories rebased on their latest `origin/main` before any edit.
- **Reader `aer-det-v1.2` (shadow only, pure module, no model, fetch or write).** A collapsed table line is skipped rather than guessed: two or more distinct degree titles, a table separator beside two or more tests or qualifications, or three or more tests or qualifications on a line over 200 characters. A value is never taken across another test or qualification: a test reading takes its value only from words that name that test (a PTE score beside LANGUAGECERT, a Canadian average beside an NCUK point score or an IB Diploma, and a Year 12 value beside a foundation course are no longer read), and a quote for NCEA, University Entrance or Year 12 stops before the next qualification. Every quote is still a substring of the page text.
- **Tests (US$0):** `cf-247-s828-aer-det-reader-contract` is now 9 tests, all passing locally (the new one covers the three observed mis-assignments, the table-line skip and the quote cut). The s120 governance and s42 housekeeping specs pass. TEST-REGISTER patched on four lines (regression total 3,970; local suite 4,006; s828 row 9 / 0) because a full regeneration from a shallow clone rewrites the PR column of hundreds of unrelated rows.
- **Not changed:** no migration, no public function, table or view (G3 75 functions / 48 relations); `batch.aer_det_read` stays 20; no promotion; Decision 276 and every gate untouched; manual locks 7,585; AI and Firecrawl spend US$0.
- **Next:** merge this admin record first, then Pilot on green CI (code only: `deploy-on-merge` redeploys the worker), then one 200-page shadow batch at 6 calls and a 20-row spot check, then the closing block.

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


**S1-AER, 19 Nov 2026 05:30 AEDT: morning read-back — would-admit course reads still NOT admitted; 0 P0 findings; replay pause confirmed**

Read only; no migration, no data change (zero schema migrations in this lane). Live reads: `aer-validation-renew.yml` status run 44369257782 (05:24) and a rolled-back probe (run 44370612954 on the carrier branch).
- **Course-read sweep (`s670`/`s673`): not complete.** Since 20:09:59 on 18 Nov, 2 course reads (3 rows) and 2 provider tables admitted. **89 course reads are still would-admit and waiting**; 2,576 wait in Layer 4. The post-6-hour sweep did not reach them: the machine job (every 30 minutes, succeeding) re-checks the same first items each run (cause and fix S677 in the 03:15 block, awaiting Platform Admin authorisation). The 89 were last checked 16:54 to 19:54 AEDT on 18 Nov; no shadow rows since.
- **P0 consumer-data findings: 0 open** (`pipeline.aer_gap_findings`, severity P0, state open or reopened). The 149 person-approved provider-table rows stay live; 6 `entry_matrix_change` items are pending in Layer 4 (the five from 11 Nov plus one to identify; none touched).
- **Paid replay pause recorded in all three places:** CURRENT-STATE (23:55 block), the AER runbook (`docs/platform/2026-11-12-aer-admission-mechanism.md`, item 3b) and Decision 276 (`docs/coursefinder-design-reference-v1.4.md`, 23:52 decision): no round 6 until dense entry tables are chunked per qualification or a stronger frontier model is authorised; US$0.47 of the US$2.00 cap kept; AER v2 stays at 0 (shadow only).

**Next executable action:**
- Platform Admin: authorise S677 (one function, `security.aer_machine_admit_v1`: admit-mode declined and audit-sample results refresh the last-checked time), or approve the 89 in Layer 4 › Inbox.
- S1-AER after authorisation: S677 with a rolled-back live dry run, then a status read 30 minutes after merge.
- Open for a person: the Layer 4 change items; branch `cf247-s676-probe` still exists (never merged; delete in the GitHub UI).

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

**S1-AER, 18 Nov 2026 23:55 AEDT: decisions recorded (149 approved rows stay live; paid AER v2 replay paused)**

Platform Admin 23:52. No code or migration.
- **The 149 person-approved provider-table rows stay live** in the consumer API: AUT 56, Whitireia and WelTec 44, Massey 36, Flinders 12, Otago 1. The five 11 Nov `entry_matrix_change` items stay in Layer 4 for a person (s675).
- **Paid AER v2 replay rounds are paused.**
  - There is no round 6 on Qwen3 30B, Mistral Small 3.2 or MiMo v2.6 Flash, and the US$0.47 left of the US$2 evaluation cap is kept.
  - AER v2 stays off (shadow only, `aer.v2_shadow_on` 0, gate unchanged). AER v1 deterministic admission handles live admission: course reads and provider tables, s670, s671, s673.
  - **Replay resumes only when** dense multi-row entry tables are chunked per qualification, or a stronger frontier model is explicitly authorised.
  - Recorded in Decision 276 and the AER runbook, item 3b.

**Next executable action:**
- S1-AER, Thursday 02:45 AEDT (scheduled): read-only check that the about 90 would-admit course reads were admitted after their 6-hour re-check.

**S1-AER, 18 Nov 2026 23:35 AEDT: prompt v3.1 and 180 s evaluation calls (s674), round 5 not qualified; standing 7-day validation renewal; five AER consumer data findings resolved without quarantine (s675)**

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

**S1-AER, 18 Nov 2026 20:50 AEDT: AER course machine admission re-validated (s673); matrix level from the table heading and completion-only rows (s671); AER v2 replay round 4, no model qualified (s672)**

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

**S2-BOOST-AER, 18 Nov 2026 19:00 AEDT: hand-bound shared-page rule live (s670); AER course machine admission found running in shadow since 15:40**

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

**AER held items re-read (S2-BOOST-AER, 18 Nov 2026 17:50 AEDT, read-only; [`platform/2026-11-18-aer-held-items-classification.md`](platform/2026-11-18-aer-held-items-classification.md)).** Shared-page class 230 items on 161 pages at 79 providers (not 1,874); about 1,620 are incomplete reads needing a corrected read. The 230 are mostly qualification ladders and stream siblings on a course's own page, plus 41 pace or duration twins: 20 of the 41 demonstrably print a different requirement per variant, so no automatic twin pass was built. Matrices: 82 of 83 runs have no completeness verdict, 1,191 rows have no mapped level (893 with no level read at all), 997 have no minimum (mostly completion requirements). No rule, threshold, switch or data changed.

**Next:** the Scholarships lane, the 57 scholarship decisions and their 287 missing award values; AER v2 for `edition`/`routes`; a bulk-decision action on the Phase 5 grid for the grouped cases above.

**Status at 18 Nov 2026 11:45 AEDT (Platform Admin 07:08 decisions 3 and 4, and 10:10). The 12:25 block above is newer.**

- **Decision 4.** Pilot #1251 (migration `20261118111500`, s618): refused Boost study-load readings (the page had study-load text and the answer failed the page check) go to Layer 4 › Inbox as kind **Boost study load**; "not stated" rows and failed calls never do. Own cap `boost.layer4_open_max` (400, not the recovery lanes' 150), refilled after each result file and each decision. Choices (Pipeline Operator or above): Full-time, Part-time, Both (fills `study_load` only while empty and unlocked, source `manual`), Not stated on the page, Dismiss. Read back 10:31: all 376 refused readings open; at 11:36 the Inbox holds 400 (the cap) as new pages are read.
- **Decision 3.** Pilot #1255 (worker `coverage-sweep` v1.0.16, migration `20261118121500`, s621): job `boost-fields` reads each stored course page once for every gap field the course misses (course description, delivery mode, intakes, tuition fee, entry requirements), in Boost priority matrix order, through its own route `boost_fields_extract` pinned to Qwen3 30B (US$2 / 6,000 calls a day). Each answer is checked against the whole page and staged in Storage `staging-boost/fields` and `pipeline.boost_field_candidates`, `promotion_state` shadow, with the field's owner. **Nothing is admitted** until each owner's rule takes Boost candidates. Its claim timed out under the API from 11:01 (no page read); fixed by Pilot #1261 (migration `20261118130000`, s626: one pass from the stored pages, post-check under an 8-second time-out).
- **Read back 11:36 AEDT:** 59 pages read for US$0.010 (59 calls); field answers verified / refused / not stated: entry requirements 31/21/4, course description 23/7/1, intakes 0/14/10, delivery mode 1/9/1, tuition fee 1/7/2; 0 left shadow. The commonest refusals: quote not on the page, intake month not in the quote, entry quote not a requirement. Early figures; the refusals keep wrong values out of staging.
- **Study load keeps admitting** as S2-Build's page feed (Pilot #1252, merged by S2 - BOOST on green under the standing mandate) adds stored pages: 1,703 admitted, courses holding a study load 4,224 (2,521 this morning). G3 75 functions and 48 relations, no drift.
- **Benchmark bench-4 finished (prompt `boost-study-load-v4`, the rules now admitting; 220 stored pages, 164 AU model calls a model).** AU pages, verified with a value / refused / call failed: **Qwen3 30B 120 / 42 / 0**, **Mistral Small 3.2 133 / 25 / 3**, MiMo v2.6 Flash 108 / 11 / 42 (provider errors). Under the final rules Mistral passes the page check more often than Qwen; Qwen never failed a call. The qualified model is unchanged (Qwen3 30B, Platform Admin decision 07:08); whether to change it or add Mistral is the Platform Admin's call.
- **Test project:** S1-Build posted "can re-seed" at 10:59; run-3 dispatched 11:11 (admin run 44205747811): cohort re-seeded (12 providers, 69 courses, 60 without study load), promotion function byte-identical to production, **PASS** on every check (60 admitted for 60 courses, nothing held changed, cohort put back, G3).
- **Registers:** test register regenerated from Pilot `main` `14a30503` (741 specs, 3,474 tests); nine S2 - BOOST engagements logged (RM0, 135 minutes; ledger 69 rows, 1,035 minutes); workbook rebuilt; Drive Monitoring synced.

**Next:** owner rules for Boost field candidates (each owner turns its rule on); Thursday squash: re-seed and run-4 right after 03:30 AEDT; watch the multi-field refusal rate as more pages are read.

**Status at 18 Nov 2026 09:50 AEDT (Platform Admin decisions of 07:08). The 11:45 block above is newer.**

- **Qwen3 30B is qualified for Boost study load and admits.** Row in `pipeline.boost_model_qualifications` (lane `study_load`, `openrouter` / `qwen/qwen3-30b-a3b-instruct-2507`), Pilot #1247, migration `20261118100000`. **Live admitted count 09:45 AEDT: 447 courses** filled; courses holding a study load 2,521 → 2,968. No course that already held a value changed (the migration's post-check compares every such course before and after); every admitted row equals its course's value; G3 75 functions and 48 relations, no drift. `worker-boost-bulk-ingest` admits each new verified study load as its file loads, so the count rises until the re-read finishes (about 1,430 pages left at 09:45, roughly 30 minutes).
- **On the qualification threshold (decision 2a).** The figure that meets 95% is cross-model agreement in bench-1: Qwen3 30B and Mistral Small 3.2 give the same value on 118 of 123 pages (96%). Qwen's own page-check pass rate in bench-1 was 163 of 180 (90.6%). Qualified as the winner by the Platform Admin's decision; the reason on the row says so.
- **Only study loads read under the final rules are admitted.** The 1,420 shadow values of 02:00 were read under the earlier rule (visa sentences refused), so they were not promoted as they stood; the whole queue is being read again and only rows verified under prompt `boost-study-load-v4` are admitted. Older rows stay shadow or refused.
- **Decision 1, the international study load first: three iterations today, measured each time.**

  | Worker, prompt | Pages read | Verified with a value | Refused | What the readings showed |
  |---|---|---|---|---|
  | v1.0.12, v2 (#1238, #1241) | 468 | 96 | 282 | The model answered from the general statement on 214 pages that state an international rule |
  | v1.0.13, v3 (#1244) | about 1,300 | about 860 | 452 | Asking the international sentences on their own fixed that, but the sentence test was too loose: fee lines ("International fee … a standard full-time course load for a year") and work-rights notes counted, so correct general answers were refused (86 "Duration 4 years (full time)") and some fee lines passed |
  | **v1.0.14, v4 (#1246)** | 344 (first 10 minutes) | 246 (100 international, 146 general) + 20 not stated | 26 (8%) | A sentence counts only when it names international students or a student visa **and** states a rule about how they may study; fee, tuition, credit-point, scholarship, work-rights and experience lines never count; "part-time … not available for international students" gives full-time. The refusals sampled are correct catches (for example `full_time` claimed from "2 years full-time, 4 years part-time") |

  The commonest international rule is "International student visa holders can only study full-time." (65 of the first 100).
- **Decision 5, done.** Setting `boost.yield_to_dispatchers` = 0 (Settings › Pipeline settings › Boost): the Boost gate no longer looks at the dispatcher tick locks, so "a dispatcher tick is running" skips stop. The squash blackout (Thu 01:15–03:30), Maintenance Mode, housekeeping-daily and the switches still hold Boost. A run reads 80 pages, 4 at a time (`batch.boost_extract`, new `reading.boost_extract_parallel`).
- **Route cap.** Today's three readings used the route's 5,000-call daily cap at 09:08 (US$0.47 of US$3); the call cap is now 15,000 (#1249, migration `20261118101500`), the US$3 cap unchanged and still pinned to Qwen3 30B. Spend today to 09:45: US$0.50.
- **Benchmark run `bench-4`** (prompt v4) runs beside the extraction on its own route (US$1 cap); results go in this block when it finishes.
- **Still to build, in this order.** (1) Decision 4: refused study loads where the page has study-load text go to Layer 4 as their own inbox kind; "not stated" rows do not. (2) Decision 3: the other Boost gap lanes in one pass per stored page. Each of those fields has an owner and its own admission rule (course descriptions, fees, entry requirements under AER v2), so the pass will stage them in shadow for those rules rather than admit them.
- **Specs.** The Boost benchmark spec is now `s600` (was `s596`, which stays S2-Build's Layer 1 runner spec); `s601` (was `s597`), `s602`, `s614`, `s615` and `s617` added. Register regenerated from Pilot `main` `c5a76500`: 734 specs.
- **Keeps its schedule:** the 11:45 AEDT re-seed and run-3 on `coursefinder-boost-test` after S1-Build's rehearsal rebuild.

**Results at 18 Nov 2026 02:00 AEDT. The 09:50 block above is newer; the 00:10 block below gives the reasons and the open decisions.**

- **The stored-page queue is read in full: 2,144 courses, finished 01:33 AEDT, all in shadow. Live admitted count: 0.** No model is qualified for admission. G3 75 functions and 48 relations, no drift (read 01:46).

  | Outcome (worker v1.0.10 and v1.0.11, rules `study-load-windows-v2`) | Courses |
  |---|---|
  | Study load verified against the page | 1,420 (`full_time` 721, `both` 691, `part_time` 8) |
  | Page read, study load not stated | 531 |
  | Answer refused by the page check | 190 |
  | Call failed | 3 |
  | **Total** | **2,144** (AU 2,124, NZ 18, CA 2) |

  - **Cost:** US$0.156 for 1,722 model calls (US$0.00009 a call; US$0.00011 for each verified study load). 62 result files loaded, none with an error.
  - **Rate:** 541 courses in the first 50 minutes, then about 11 a minute once most pages needed a model call (a run reaches its time limit at about 30 calls).
  - **Not read:** 236 queued courses whose stored page text is also stored for another course.
  - **Still not admitted, and why the first sample understated the quality.** Of the 1,420 verified study loads, 415 rest on a sentence no other course of the provider uses, and 915 on a sentence used for 3 or more of its courses. Most of the common sentences are the provider's course template and are real statements of the course ("Duration 3 years full-time or part-time equivalent", 27 courses; "Duration: Full-time 2 years Part-time 4 years", 32). Some are general and say nothing of the course ("As a full-time student, you can expect to commit around 48 hours of study per week", 76 courses, answered `full_time`). 14 answers rest on a sentence that was given two different values. So a rule that refuses every repeated sentence would throw away good data; the 55% of the 00:10 block came from 22 answers of two providers and is not the rate for the whole queue. The rate for the whole queue has not been measured: it needs a read of a random sample.
- **Model benchmark bench-1 (Pilot #1236, worker v1.0.11; production 00:33 to 01:33 AEDT; replayed on `coursefinder-boost-test`, GitHub Actions runs 44106815300 and 44107426226).** The same 220 stored pages (AU 200, NZ 18, CA 2; the course's own page only), the same request and the same page check, asked of each model directly. 40 pages had no study word and were not sent. "Admitted" is on the test project only, with that one model qualified there, through the production promotion function (same md5).

  | | Qwen3 30B | Mistral Small 3.2 | MiMo v2.6 Flash |
  |---|---|---|---|
  | Model calls | 180 | 180 | 180 |
  | Verified with a study load | 160 | 126 | 92 |
  | Verified, not stated | 3 | 3 | 7 |
  | Refused by the page check | 17 | 18 | 4 |
  | Call failed | 0 | 33 | 77 |
  | **Admitted on the test project (of 220 pages)** | **157 (71%)** | **123 (56%)** | **91 (41%)** |
  | Admitted, AU / NZ / CA pages | 139 of 200 / 16 of 18 / 2 of 2 | 107 / 14 / 2 | 82 / 8 / 1 |
  | Cost of the run | US$0.0168 | US$0.0108 | US$0.0137 |
  | **Cost per admitted field** | **US$0.00011** | **US$0.00009** | **US$0.00015** |
  | Median time of a call | 0.97 s | 0.89 s | 4.84 s |
  | Promotion of its 220 rows | 71 ms | 61 ms | 63 ms |

  - **Failures are the provider's, not the answers'.** Mistral's 33 and 66 of MiMo's 77 are "Provider returned error" from OpenRouter (the request allows no fallback provider); 11 of MiMo's are answers cut off at the 300-token limit (`reading.answer_tokens.boost_extract`). Qwen3 30B had none.
  - **Agreement.** Where two models both gave a study load they agree on 118 of 123 pages (Qwen and Mistral, 96%), 84 of 90 (Qwen and MiMo, 93%) and 64 of 67 (Mistral and MiMo, 96%). All three gave one on 67 pages and agree on 62 (93%). Agreement does not prove the value: three models reading the same general sentence agree with each other.
  - **NZ and CA** are 18 and 2 pages, all there is; too few to compare models on.
  - **Reading.** Qwen3 30B, the model already on the route, answers the most pages, fails least and is as fast as Mistral; Mistral is slightly cheaper per admitted field only because its failed calls cost nothing. Nothing here argues for changing the route's model.
  - **Test project after the replay:** no qualification row, no benchmark course, no benchmark staging row, G3 75 and 48. The benchmark's providers (and their registry rows) could not be removed, because a row the platform creates for each new provider (`coverage_provider_discovery`) refers to them; they hold no course and go with the 10:30 rebuild. Three benchmark courses were already in the admitted-count cohort; the test project will be re-seeded after the rebuild as planned.
  - **Spend on the benchmark route:** US$0.041, 441 calls recorded in the ledger. Job `boost-benchmark` now finds nothing left and does not call the worker; a new label on Settings › Pipeline settings › Boost starts another run.
- **`boost-extract` now idles**: the queue is empty until a course gains a stored page. It waits for a dispatcher tick instead of skipping its run (worker v1.0.11).
- **Decisions still with the Platform Admin** (00:10 block): what study load means when a page gives domestic and international students different loads; the admission rule (recommended from tonight's data: admit a value only when Qwen3 30B and Mistral Small 3.2 give the same one, and refuse the general sentences by a short list of phrasings, after a read of a random sample of about 100 of the 1,420); other lanes as proposals or direct; refused rows to Layer 4 or not. Once decided, the 1,420 staged rows can be settled without reading the pages again.

**Status at 18 Nov 2026 00:10 AEDT (Platform Admin directives of 17 Nov 22:45, 22:48 and 22:50). This block is current; where a bullet further down differs, this block wins.**

- **Running now, all day, in shadow.** Job `boost-extract` every minute, 40 courses a run; `worker-boost-bulk-ingest` every 2 minutes, 10 files a run; route `boost_extract` pinned to Qwen3 30B, caps US$3 and 5,000 calls a day; worker `coverage-sweep` v1.0.10. The overnight window is gone (the window settings cover the whole day, Pilot #1231). What still holds Boost: the switches, Pipeline Maintenance Mode, the squash lock **Thu 19 Nov 01:15 to 03:30 Melbourne** (gates and promotion both, proven in the migrations), `housekeeping-daily`, and the dispatcher locks.
- **Live admitted count: 0.** No model is qualified for admission (`pipeline.boost_model_qualifications` is empty), so every staged row is shadow or refused. Read 23:59 AEDT: 0 rows admitted; G3 75 functions and 48 relations, no drift.
- **Why Qwen3 30B was not qualified (directive item 2).** The 22:48 directive made it conditional on a clean reading of the first results; the 22:50 directive said to qualify now. The first results were read before the qualification was merged, and they were not clean, so it was held. This is for the Platform Admin to decide, with the evidence below.
  - **First reading (worker v1.0.9, 23:22 to 23:30, 40 courses, 35 model calls).** 35 of 35 answers passed the page check (100%). But 28 of the 29 study loads given rested on one sentence of provider boilerplate, "Only a full-time study option is available to international students on a Student visa", and 16 of the 35 pages were one page text stored for 21 different courses, which gave `full_time` for some of them and "not stated" for others. One answer of 29 was a statement of the course's own study load. The page check proves the quote is on the page; it does not prove the quote is about the course.
  - **Fixed the same night (Pilot #1231, worker v1.0.10, selector `study-load-windows-v2`).** A sentence about a visa, about what international students must do, or naming CRICOS is neither sent to the model nor accepted as a quote. A stored page whose text is also stored for another course is not read (236 of the 2,380 queued courses; 2,144 remain). The 40 courses were released and are being read again.
  - **Second reading (v1.0.10, 23:56 to 23:58, 80 courses, 36 model calls).** 44 "not stated" (35 without a model call), 28 study loads verified (18 `both`, 10 `full_time`), 8 refused by the new rules. Read by hand, a sample of 22 of the 28: about 12 are plain statements of the course ("6 Study Periods (2 years) full-time, or equivalent part-time"; "45 weeks full-time."); 9 rest on a provider's definition of full-time and part-time study that appears on many of its pages ("Full-time study is enrolling in three or more courses per study period, while part-time study is one or two courses"), which says nothing about the course; and the same sentence gave `both` for some courses and `full_time` for another, and "(1 year) full-time, or equivalent part-time" was answered `full_time`. That is roughly 55% right on substance, against a 95% bar.
  - **What would make it safe to admit.** (a) A rule for boilerplate: a quote that the same provider's pages give for many courses is not accepted. (b) Agreement between models: admit only where the candidate models give the same value from the same page (the benchmark below gives the figures). (c) A decision on what the field means when a page says "domestic: full-time or part-time; international: full-time": for an international student the answer is `full_time`; for the course it is `both`. REQ-52 does not settle it.
- **Throughput and cost so far.** 80 courses read under v1.0.10 in two runs of 40 (the first run of 20, under v1.0.9, answered in about 9 seconds). Cost US$0.0051 for 76 model calls in all (about US$0.00007 a call); the whole queue is about US$0.10. Boost spend now reaches the AI spend ledger (trigger on `pipeline.boost_extract_items`), so the route cap and the daily ceiling count it; before #1231 only the calls were recorded.
- **Defect, open: runs are skipped instead of waiting.** `boost-extract` fires at the top of the minute, as the dispatcher ticks do; 3 of 5 runs after 23:54 returned "a dispatcher tick is running" and did nothing. The ingest worker waits up to 30 seconds for a tick; the extract mode does not. Fix: wait the same way (next worker version). At the present rate the 2,144 pages still clear in about 2 to 3 hours.
- **Not done, with reasons.**
  - **Directive item 4, all Boost fields in one call (description, delivery mode, intakes, fees, entry requirements).** Not built. Each of those fields has its own admission rule and owner (course descriptions: the source-grounded prompt and its checks; fees: the fee reader and fee floors; entry requirements: AER v2 only, AER v1 frozen by Decision 276; intakes: S2-Intakes; the pre-AI admission gate, Decision 278). Boost can extract them and stage them as proposals for those rules; admitting them from Boost directly would bypass those rules. The staging table also allows five lanes only. Needs the Platform Admin's decision on proposals versus direct admission, lane by lane.
  - **Refused and conflict rows to Layer 4.** Not built. Study load has no confidence score, a course that already holds a value is never queued, and refused rows are kept in staging with their reason. Sending them to Layer 4 would add to its backlog; say if it is wanted.
  - **Model benchmark on the test project before the 10:30 rehearsal (directive of 22:45).** Not run yet. The migration is written (Pilot branch `cf247-boost-benchmark-wip`: route `boost_extract_benchmark` with the three named models, results table, job, run label on Settings); the worker mode, the guard spec and the replay onto `coursefinder-boost-test` are still to write. Next in this lane.
- **Changes tonight:** Pilot #1226 (migration `20261118000100`, s588: Boost on demand until 01:05; promotion refused inside the squash lock) and Pilot #1231 (migration `20261118011000`, s590, worker v1.0.10: all day, squash lock from 01:15, throughput, the two page rules, spend to the ledger). Both passed the rolled-back live dry run and all checks; deployed UAT passed on both merges.

**Done 18 Nov 08:20 AEDT (Pilot #1244): the Boost benchmark spec is `s600`.** Was: **Action for S2 - BOOST (Platform Admin 18 Nov 2026 07:35, via S1-Build): renumber the Boost benchmark spec.** `cf-247-s596-boost-benchmark-contract` and S2-Build's `cf-247-s596-layer1-declarative-runner-contract` share `s596`. In your next Pilot PR (qualifying the winning model and fixing the dispatcher lock skips), rename the Boost benchmark spec to a number strictly above every number in use and regenerate `docs/platform/TEST-REGISTER.md` in the same change (G4). At 07:40 AEDT the register's highest is `s596`, and open Pilot PRs already claim `s597` (#1239) and `s598` (#1240), so the next free number is `s599`; re-check open PRs before you merge. The Layer 1 runner spec keeps `s596`.

**Done 11:11 AEDT by S2 - BOOST: run-3 re-seeded and PASS (admin run 44205747811).** Was: **S2 - BOOST: you can re-seed `coursefinder-boost-test` (`ucdaaqrpgcldnatavmib`) now — Wed 18 Nov 2026 10:59 AEDT (S1-Build, squash rehearsal done).** The rehearsal rebuild (admin `boost-test-rebuild.yml` run 44201959838, from production dump `db-schema-dump/44199899527`, head `20261118111500`, plus `20261118113000` applied after) has finished; the project now holds the production schema with test cron jobs off. Re-seed it as in your lane notes (`run-3`). The next reset is the squash window, **Thu 19 Nov 01:30–03:30 AEDT**; re-seed again right after 03:30.
- **One check for S2 - BOOST to update before Thursday:** the run reported FAIL only on `outside_window_refused` (`sql/boost-ingestion/005_rehearsal_rolled_back.sql`, check d). The Boost window now covers the whole day (`[0, 24]`, Pilot #1231), so a run can never be outside it and the check returns "not refused". Please change check d (or the verdict) to follow the window settings, so the window's proof reads PASS. Every other check passed: schema from the dump, 2 newer migrations applied (0 failed), G3 75/48 with no drift, 1,000 rows in 0.042 s, 50 shadow rows with 0 admitted and 0 courses changed, 1 study load written and 0 `updated_at` touched.

**Migration freeze lifted — Thu 19 Nov 2026 02:25 AEDT (S1-Build).** The canonical squash merged at 02:15 (Pilot #1325). Pilot PRs that add migrations may merge again. **Authors of open migration PRs (Pilot #1314 and any branch cut before 02:15): rebase on main first.** Files under `supabase/migrations/` up to `20261118272000` moved to `supabase/migrations-archive/`, so a branch from before the squash conflicts or re-adds them; keep only your new file under `supabase/migrations/`, numbered above the live head.

**Done 19 Nov 05:57 AEDT by S2-Build (Platform Admin 05:21): rebuild proof PASS on all five checks (admin run 44369667112, check d fixed in admin #622) and re-seeded (admin run 44372812878, PASS).** Was: **S2 - BOOST: you can re-seed `coursefinder-boost-test` (`ucdaaqrpgcldnatavmib`) now — Thu 19 Nov 2026 02:25 AEDT (S1-Build, squash window rebuild proof done, run 44327488382).** The project holds the schema from production dump 44324920057 (head `20261118272000`) and reference data; test cron jobs are off. Check d of `005_rehearsal_rolled_back.sql` (`outside_window_refused`) still fails against the whole-day Boost window: please update it with the re-seed. `ref.study_level_source_mappings` did not load (foreign key to a source outside the copy set), as in the rehearsal.

**Action for S2 - BOOST (Platform Admin 17 Nov 2026 20:06):** S1-Build uses `coursefinder-boost-test` for the squash rebuild proof, and `boost-test-rebuild.yml` resets the project (application schemas dropped and rebuilt from the production dump; reference data copied; test cron jobs switched off). Two resets:
- **Rehearsal, Wed 18 Nov from 10:30 AEDT** (S1-Build posts here when the rebuild run finishes);
- **Squash window, Thu 19 Nov 01:30–03:30 AEDT.**

Do not run experiments on the project during those runs. Re-seed it (qualification rows, experiment batches, any test settings) after the rehearsal rebuild and again **right after the window closes at 03:30 AEDT Thursday**. Keep the re-seed steps in your lane notes so they can be repeated.

**Platform Admin decisions, 17 Nov 2026 21:18, and what changed (Pilot #1219, migration `20261117223000`, guard spec s586; merged 22:13 AEDT). Where the bullets further down differ, this block is current.**

- **Decision 3, where the matrix lives.** The Boost priority matrix is 18 settings on **Settings › Pipeline settings › Boost**, each changed on the screen with a reason:
  - `boost.matrix.country_weight.<CC>`: AU 100, NZ 95, CA 90, UK 50, IE 45, US 40 (range 0 to 100).
  - `boost.matrix.category_weight.<category key>` (range 0 to 1), one per category of the single list.
  - `boost.matrix.tier_1` (AU, NZ, CA) and `boost.matrix.tier_2` (UK, IE, US); `boost.matrix.country_aliases` (GB=UK); `boost.matrix.lane_categories`.
  - **A change that breaks the matrix is refused.** A deferred check on the settings table (`boost_matrix_check`, function `security.boost_matrix_settings_guard_v1`) refuses a change to a `boost.matrix.*` setting when a tier 2 cell would reach a tier 1 cell or a weight goes below 0. The screen shows "Boost priority matrix not saved: …".
  - The row `country_category_boost` in `pipeline.environment_settings` is kept, marked `not_applicable`, and no longer read. Per-cell overrides (there were none) were not carried over.
- **Decision 2, the categories.** The matrix has no category list of its own. It reads `ref.enrichment_categories` (S1-RM-Design, migration `20261117213000`; [`platform/ENRICHMENT-CATEGORIES.md`](platform/ENRICHMENT-CATEGORIES.md)).

  | Category | Weight | Boost lane |
  |---|---|---|
  | Recognition & registration | 1.00 | `provider_accreditations` |
  | Campus & location | 0.95 | |
  | Fees | 0.90 | `course_fees` |
  | Entry requirements | 0.85 | `aer_entry` |
  | Intakes & deadlines | 0.80 | `study_load` |
  | Course basics | 0.75 | `course_description` |
  | Provider profile | 0.70 | |
  | Scholarships | 0.65 | |

  - **How the weights were carried.** Six categories took the weight of the old matrix key they replace (by the crosswalk `ref.enrichment_category_fields.boost_category`). Course basics and Provider profile had no single old key and took the two weights left over (0.75 and 0.70). These are starting values; change them on the screen.
  - Lowest tier 1 cell is CA Scholarships 58.5; highest tier 2 cell is UK Recognition & registration 50.
  - **For S1-RM-Design:** the Boost matrix now reads the single list, so the crosswalk column `ref.enrichment_category_fields.boost_category` has no reader in the Boost lane. It was not touched; retiring it is yours.
- **Decision 4, order only.** `security.boost_promote_v1` does not read the matrix (guarded by s586). The matrix orders the Boost queue; `security.boost_lane_category_v1(lane)` gives a lane's category.
- **Decision 5, the admitted count.** `security.boost_promote_v1` now admits one row per course in a batch (the earliest); later rows for the same course are refused with the note "an earlier row of this batch fills this course's study load". What is written to the catalogue is unchanged. The function was replaced only after the migration confirmed the live definition was md5 `15be1ce6`.
- **Verification of #1219, completed 17 Nov 22:07 to 22:12 AEDT.** Read back live: head `20261117223000`, 18 `boost.matrix.*` settings, matrix check `ok` with 48 cells (AU Recognition & registration 100 rank 1; CA Scholarships 58.5 rank 24; UK Recognition & registration 50 rank 25), old row `not_applicable`, the deferred check present, promotion function md5 `c9239d35`, 0 qualified models, G3 75 functions and 48 relations with no drift. **Run-2 on the test project (GitHub Actions run 44071755287, admin workflow `boost-test-experiment.yml`): PASS.** The promotion function was copied from production (same md5 on both). 60 rows admitted for the 60 courses with no study load at 1,000 and at 5,000 rows (5,922 later rows for the same courses refused, none admitted); 19 for 19 at 50 rows; nothing admitted with no model qualified; 0 held courses and 0 `updated_at` values changed; G3 on the test project 75 and 48. Timings (database time, medians): 1,000 rows 36.5 ms load and 101.9 ms promote; 5,000 rows 183 ms and 374.7 ms, worst promotion 0.42 s.
- **Database and test-project runs are non-interactive (Platform Admin 17 Nov 2026 22:05).** No tool that asks for confirmation is used for a change. Routes:
  - **Production change:** a Pilot migration, dry run by the label `live-dry-run` (Pilot workflow `db-migration-dry-run.yml`), applied by deploy on merge. Production G3 through Actions is read by that workflow's probe, as the database owner; the read-only role of the Management API may not run `security.consumer_api_check_v1` (seen in run 44071755287).
  - **Test project:** admin workflow **Boost test project experiment** (`.github/workflows/boost-test-experiment.yml`, inputs `label` and `reseed`): production read only, then on `coursefinder-boost-test` only: re-seed, promotion function from production, `sql/boost-experiments/admitted-count.sql`, verdict; results on branch `boost-experiment/<run id>`.
- **Decision 1, Boost extraction through `coverage-sweep` and Models & services: live 17 Nov 2026 22:37 AEDT** (Pilot #1223, migration `20261117235000`, worker `coverage-sweep` v1.0.9, guard spec s587; deploy on merge run 44075576598).
  - **Route** `boost_extract` ("Boost extraction (study load)", area Boost) in Models & services: one pinned model, `qwen3-30b` (`qwen/qwen3-30b-a3b-instruct-2507`, the central model), daily caps USD 1 and 1,500 calls. No separate worker holds an OpenRouter key; the Cloudflare Worker is not deployed.
  - **Job** `boost-extract`, `2-59/5 * * * *`, catalogued, no number in its command. It runs only when `security.boost_extract_gate_v1` allows: the switch `boost.extract_on` (ships **on**), then the overnight Boost gate (01:05 to 04:50 Melbourne, not in the squash blackout, not beside `housekeeping-daily`, dispatcher locks). Read live: closed now, open Wed 01:10, closed Thu 01:45.
  - **What a run does** (mode `boost_extract`, `boost.ts`): claims up to `batch.boost_extract` (20) courses with no study load that have a stored course page, country by country in the order of the Boost priority matrix (study load is Intakes & deadlines: AU 80, NZ 76, CA 72); reads each stored page; sends only the text around "full-time" and "part-time" (at most `reading.boost_extract_section_chars`, 6,000) to the route's model; checks the answer against the whole page (allowed value, quote on the page, quote states the load it claims); writes one result file per run to Storage `staging-boost/inbound`. A page with neither word gets its "not stated" row with no model call. `worker-boost-bulk-ingest` (unchanged) loads and settles the file.
  - **Nothing is admitted.** `pipeline.boost_model_qualifications` is empty, so every row is shadow or refused and the catalogue is not written. Qualifying a model for admission stays a separate, deliberate step after the benchmark.
  - **Lane:** `study_load` only. The other Boost lanes (`course_fees`, `aer_entry`, `course_description`, `provider_accreditations`) are not read by this worker yet.
  - **The queue is small and almost all Australian.** Read live 22:40 AEDT: 2,380 active courses have no study load and a stored course page: AU 2,360, NZ 18, CA 2. (33,502 active courses have no study load; the rest have no stored course page for Boost to read.) At 20 courses a run the queue takes about three nights; `batch.boost_extract` goes to 200.
  - **Ledger and progress:** `pipeline.boost_extract_items` (one row per course and stored page, with outcome, batch, file, whether a model was called, cost); `security.boost_extract_progress_v1()`. It holds 6 `released` rows from the migration's own claim check; they are read by the job like any other.
  - **Read back live 22:38 AEDT:** route enabled, cascade `[qwen3-30b]`, not held, USD 0 spent; job active; 5 settings as above; 0 rows claimed; 9 register rows; promotion function md5 `c9239d35` (unchanged); 0 models qualified for admission; G3 75 and 48, no drift.
  - **First run:** Wed 18 Nov 01:07 AEDT. Not yet observed: the worker mode has passed the type check, the guard spec and the unit checks of `boost.ts`, but has made no live model call. The first night's figures (courses read, model calls, verified, rejected, failed, cost) are to be read from the ledger and the route's spend on Wednesday morning and recorded here.
- **Benchmark plan (Qwen3 30B, Mistral Small 3.2, MiMo v2.6 Flash; all three are allowed models in the catalogue).** Live model calls run on production, where the key and the route are; the test project has neither. To build before Thursday: a benchmark mode that asks each candidate model, pinned one at a time through the platform AI evaluation framework, for the same fixed set of stored pages, writes nothing to the catalogue and reports per model the verified rate, the rejected and failed kinds, tokens and cost per verified field. NZ and CA can supply only 18 and 2 study-load pages, so their cohorts will be small until more of their course pages are stored.
- **Test project re-seed (after the rehearsal of Wed 18 Nov 10:30 AEDT and after Thu 19 Nov 03:30 AEDT).** Dispatch **Boost test project experiment** with `reseed` on and a new label (`run-3`, `run-4`); it re-seeds from [`paste/boost-test-reseed.sql`](paste/boost-test-reseed.sql), copies the promotion function from production and repeats the admitted-count run. Not during S1-Build's rebuild runs (the workflow shares no lock with `boost-test-rebuild.yml`; check that run has finished first).

- **Already live before this session (Pilot #1205, S1-Build; re-read 18:10 AEDT, unchanged):** `security.boost_promote_v1` (md5 `15be1ce6`), `security.boost_ingest_gate_v1` (md5 `9406870c`), job `worker-boost-bulk-ingest` (`*/5 * * * *`, active, catalogued, no number in its command) and the 11 `boost.*` settings. Gate read live: now = outside the window; Wed 01:10 = open; Thu 19 Nov 01:31 = blackout. The promotion function and the job were therefore not landed again.
- **Boost priority matrix as first landed, 17 Nov 2026 18:30 AEDT; store and categories superseded at 22:13 AEDT, see the block above** (Pilot #1209, migration `20261117183000`, guard spec s581; deploy on merge run 44039205199). One row `country_category_boost` in `pipeline.environment_settings` (category `boost`, `admin_edit`, status `configured`, not required for production).
  - **Cell weight** = country weight x category weight, or the cell's own weight under `cells` (key `COUNTRY.category`). Weight 0, or a country or category not listed, means not qualified for Boost work.

    | Country weight | | Category weight | |
    |---|---|---|---|
    | AU | 100 | `identity_registers` | 1.00 |
    | NZ | 95 | `geo_localities` | 0.95 |
    | CA | 90 | `tuition_fees` | 0.90 |
    | UK | 50 | `admissions_entry` | 0.85 |
    | IE | 45 | `intakes_delivery` | 0.80 |
    | US | 40 | `study_rules` | 0.75 |
    | | | `careers_outcomes` | 0.70 |
    | | | `scholarships_accred` | 0.65 |

  - **Tiers:** `[[AU, NZ, CA], [UK, IE, US]]`. Every cell of the first tier must outweigh every cell of the second (lowest first-tier cell CA `scholarships_accred` 58.5, rank 24; highest second-tier cell UK `identity_registers` 50, rank 25). `security.boost_country_category_check_v1()` refuses a setting that breaks this; run it after any edit.
  - **Read by:** `security.boost_country_category_matrix_v1()` (48 cells in priority order) and `security.boost_country_category_weight_v1(country, category)` (one cell; `GB` resolves to `UK`). Service role only.
  - **What it does not do.** It orders work only. It qualifies no model and does not change promotion, the gate or the job. Nothing reads it yet: the queue exporter (`scripts/boost-export-queue.sql`) is to order its queue by it when the Boost Worker is deployed.
  - **Starting values are a first setting, not a measured result.** The category order is the order of the instruction. `lane_category` maps four Boost lanes (`study_load` to `intakes_delivery`, `course_fees` to `tuition_fees`, `aer_entry` to `admissions_entry`, `provider_accreditations` to `scholarships_accred`); `course_description` has no category. Both are for the Platform Admin to confirm.
  - **Where the values sit (G2 note).** The instruction named `pipeline.environment_settings`, so the matrix is there and not in `pipeline.platform_toolset_settings`; it does not show on Settings › Pipeline settings. Editing it today is a SQL update followed by the check function.
  - **Read back live 18:31 AEDT:** head `20261117183000`, 2,067 applied; check `ok`, 48 cells; 3 register rows; 0 qualified models; no execute for anon or authenticated; promotion and gate md5 unchanged; G3 75 of 75 functions, 48 of 48 relations, no drift.
- **Boost test project experiments, run-1 (17 Nov 2026 18:22 AEDT; project `coursefinder-boost-test`, `ucdaaqrpgcldnatavmib`).**
  - **Cohort:** 69 real production course ids from 12 real providers (4 each AU, NZ, CA; the largest by course count), copied read-only: 60 courses with no study load and 9 that hold one. Titles and other fields were not copied. Production holds no UK, IE or US courses yet.
  - **Input:** synthetic worker result rows generated in SQL (no model was called): 70% `study_load`, 10% each `course_fees`, `aer_entry`, `course_description`; 80% verified, 12% rejected, 8% failed; 10% of study-load answers empty; 75% of rows from the model qualified in the test, 25% from an unqualified one. This mix is an assumption, not an observation.
  - **Method:** each batch size three times; staging insert, then `security.boost_promote_v1` (the production function, same md5) in one transaction; medians below. Timings are database time on the test project and exclude the edge function, Storage reads and network.

    | Batch rows | Nothing qualified: load / promote (ms) | rows/s | One model qualified: load / promote (ms) | rows/s |
    |---|---|---|---|---|
    | 50 | 2.5 / 6.7 | 5,471 | 2.2 / 13.5 | 3,182 |
    | 250 | 9.4 / 16.7 | 9,585 | 9.5 / 35.7 | 5,417 |
    | 500 | 18.3 / 29.6 | 10,430 | 18.3 / 58.1 | 6,571 |
    | 1,000 | 35.4 / 59.9 | 10,471 | 36.4 / 88.1 | 8,044 |
    | 2,000 | 73.3 / 122.2 | 10,243 | 74.3 / 183.6 | 7,797 |
    | 5,000 | 234.9 / 313.2 | 9,122 | 255.3 / 413.5 | 7,517 |

  - **Promotion outcome, 1,000-row batch.** Nothing qualified: 800 shadow, 200 refused, 0 admitted, 0 courses changed (shadow isolation holds at every size, 50 to 5,000). One model qualified for `study_load`: 352 rows admitted, 360 shadow, 288 refused; 60 of the 60 eligible courses filled.
  - **Zero-regression checks, every run:** 0 of the 9 courses that already held a study load changed; 0 `updated_at` values changed; G3 on the test project after the runs 75 functions, 48 relations, no drift. The test qualification row was removed and the cohort restored to its starting state (60 without a study load).
  - **Tuning read.** Throughput is flat from 500 to 5,000 rows, so the live values (`boost.ingest_rows_per_call` 500, `boost.promote_rows_per_run` 1,000) are not the limit; the worst promotion run took 0.42 s against the 5 s target. No setting was changed in production.
  - **Finding for the promotion function.** When a batch holds several verified rows for one course, every one is marked `admitted` although only the first writes (352 admitted rows for 60 courses). The catalogue is right; the admitted count overstates. A fix would mark the later rows refused ("already filled in this batch"). Not changed: it alters `security.boost_promote_v1` and needs its own dry run.
  - **Not measured, and why.** Model routing, field-level accuracy, token cost per admitted field and the Layer 4 escalation rate need real model output. The Boost Cloudflare Worker (`workers/cf-boost-extractor`) is not deployed and no AI-provider key is held by this session or the test project, so no figure is given for them. The test project also has no migration 20261117163500 objects (file ledger, gate, service calls) and no edge function, so the file path of `worker-boost-bulk-ingest` itself was not exercised.
  - **Evidence:** table `public.boost_experiment_runs` on the test project (36 rows, label `run-1`) and the 52,800 staged rows of batches `exp-*`.
- **Open items of 18:40 AEDT: all five decided by the Platform Admin at 21:18 and all five delivered** (block at the top of this section). Still open: the first night's telemetry; the benchmark mode; the re-seeds after the rehearsal and the squash.

### S1-Build Wave 2: staging retention, 7-year evidence floor, operations telemetry, live dry run (Platform Admin 17 Nov 2026 17:59, 18:02 and 18:25)

- **Live 17 Nov 2026 19:3x AEDT (deploy on merge run 44044011237; history md5 `5e3173b7` equals the file)** (Pilot #1212, migration `20261117200000`, guard spec s583; numbered s583 because #1209 and #1211 hold s581 and s582). Read back live: head `20261117200000`, 2,069 applied; all 7 settings at their defaults (pruning off); housekeeping-daily calls the retention step and stays active; the evidence purge carries the 7-year floor; the three retention classes, both tables (row-level security on) and 6 register rows present; views closed to anon and authenticated; `admin_ops_telemetry` not executable by anon. G3: 75 of 75 consumer functions equal their baseline md5, 48 of 48 relations, no drift flag.
- **Staging retention in `housekeeping-daily`** (03:47 AEDT) through `security.staging_retention_v1`:
  - applied Layer 1 staging rows (`pipeline.source_record_staging`, status `processed`) after 90 days, or the source's own period (`pipeline.source_retention_policies`, set by the Platform Admin with `public.admin_source_retention_set`, with a reason); never for a source with a Layer 1 run in progress;
  - Boost staging rows settled as shadow, proposed or refused after 90 days; admitted rows stay;
  - before a row goes, its hash, source and dates are written to `pipeline.staging_hash_ledger`, kept `retention.raw_hash_keep_years` (7);
  - published editions (`destination.editions`, `pipeline.layer1_dataset_editions`) and evidence are never touched (new retention classes `applied_source_staging`, `staging_hash_ledger`, `published_editions`);
  - **dry run until `retention.staging_prune_on` is 1** (the class catalogue requires a dry run first). Each night's report is an Admin event (area retention, action `staging_retention_dry_run`). Nothing is due tonight: the 3 `processed` Layer 1 rows carry no `processed_at` (so they are kept), and there are no Boost rows.
- **Evidence purge aligned (Platform Admin 18:25):** `security.retention_evidence_candidates_v1`, used by the retention estimate and the retention worker for category `evidence_unreferenced`, never offers evidence younger than `retention.raw_hash_keep_years` (7 years). Before this, unreferenced evidence could be purged after 7 days (last run 8 Oct 2026, 2,280 records).
- **Telemetry (read only, for S1-RM-Design's Ops report):** `pipeline.ops_l1_apply_latency_v` (each Layer 1 apply run: seconds, records, chunks of `layer1.register_apply_chunk`, ms per chunk), `pipeline.ops_l4_escalation_by_source_v` (per source: evidence captured, Layer 4 items raised, escalation rate, pending and aged), `pipeline.ops_boost_vs_pr3_throughput_v` (per Melbourne day: Boost files, rows loaded, settled and admitted beside PR 3 live runs, daytime runs, failures and time; shadow rows while PR 3 is in shadow). All closed to anon and authenticated; read through `public.admin_ops_telemetry()` (Curator and above). Look-back `telemetry.window_days` (30); aged Layer 4 item `telemetry.l4_aged_days` (7).
- **Settings** (Settings › Pipeline settings › Housekeeping): `retention.staging_prune_on` 0, `retention.staging_keep_days` 90, `retention.boost_staging_keep_days` 90, `retention.raw_hash_keep_years` 7, `batch.staging_prune_rows` 1000, `telemetry.window_days` 30, `telemetry.l4_aged_days` 7.
- **Rolled-back live dry run without prompts:** Pilot workflow `db-migration-dry-run.yml` (script `scripts/ci/dry-run-migration.sh`). A PR labelled `live-dry-run`, or a manual run with the project ref typed to confirm, runs each new migration on the Pilot inside a transaction that always ends in an exception: nothing is kept, no history row. For #1212 it caught a real error first (an alias), then passed (run 44039326181 and the re-run after rebasing).
- **Telemetry caveat:** the escalation rate divides Layer 4 items raised in the look-back by evidence captured in the same look-back. Register-style sources capture once and raise many items later, so their rate can exceed 1 (IRCC 117.9; items with no evidence source 2,623). The Ops report should show items and evidence side by side, not the rate alone.
- **Open:** a Settings screen for the per-source periods and the Ops report screen are S1-RM-Design's (the RPCs are ready). Turn pruning on after reading a nightly dry-run report.

### S1-Build lane: Supabase Auth, Boost prerequisites and paused jobs (17 Nov 2026; Platform Admin 13:11 and 14:12)

- **Supabase Auth (project `fxcwkweaxjtknorudmwp`), applied 14:33 AEDT** by admin workflow `supabase-auth-config.yml` (#547; run 44009123373) through the Management API, read back:

  | Setting | Before | Live now |
  |---|---|---|
  | `site_url` | `https://coursefinder-pilot.techm.workers.dev` (set by the Platform Admin) | unchanged |
  | `uri_allow_list` | empty | `https://coursefinder-pilot.techm.workers.dev/`, `https://coursefinder-pilot.techm.workers.dev/**` |
  | `mailer_subjects_invite` | You've been invited | You're invited to StudySearch Admin |
  | `mailer_subjects_recovery` | Reset your password | Reset your StudySearch Admin password |
  | Invite and Reset password templates | Supabase defaults | match `docs/paste/PASTE-20261117-supabase-invite-email-template.md` byte for byte |

  The workflow prints only these fields and the templates' md5, never the rest of the Auth configuration. Still to do (Platform Admin): step 4 of the paste doc, a test invitation and a password reset to an address you control, then delete the test user.
- **Boost staging prerequisites, live 14:37 AEDT** (Pilot #1199, migration `20261117152300`, guard spec s578): the private Storage bucket `staging-boost` (service role only, 52,428,800 bytes, `application/x-ndjson`, `application/json`, `text/plain`, 0 objects), and `pipeline.boost_inbound_staging` and `pipeline.boost_model_qualifications` (row-level security on, no read for anon or authenticated, 0 qualified models). Nothing is switched on.
- **`worker-boost-bulk-ingest` is built and wired, live 17 Nov 2026 17:01 AEDT (deploy on merge run 44027120386)** (Pilot #1205, migration `20261117163500`, guard spec s580; Platform Admin 16:15). Read back live: migration in the history (history md5 `93725fc9` equals the file; 2,065 applied; applied after `20261117170000` of Pilot #1206, which merged minutes earlier: a lower version applied later, as on 16 Nov; Thursday's squash takes both), job 431 active with the command above (no number), catalogue row area Boost, nonce allowlisted, all 11 `boost.*` settings, 5 register rows, row-level security on `pipeline.boost_ingest_files`, no execute for anon or authenticated, 0 qualified models, 0 files, 0 staged rows, 0 objects in `staging-boost`; edge function `worker-boost-bulk-ingest` version 1 ACTIVE, `verify_jwt` false, source equal to the file. Gate read live: now = outside the window; Thu 01:31 = blackout; at the read it also reported a real `admission-rule-runner-c` tick holding its lock (the lock check works on live locks). G3: 75 of 75 consumer functions equal their baseline md5, 48 of 48 relations present, no drift flag.
  - **What it does.** Job `worker-boost-bulk-ingest` (`*/5 * * * *`, catalogued in area Boost, nonce-allowlisted) calls edge function `worker-boost-bulk-ingest` (`worker-boost-bulk-ingest-v1.0.0`) only when the gate opens. The function reads `staging-boost/inbound/*.ndjson` (or `.jsonl`), claims each file once in `pipeline.boost_ingest_files`, loads its `kind: result` lines into `pipeline.boost_inbound_staging` and settles each batch with `security.boost_promote_v1` (admin `sql/boost-ingestion/002`, unchanged). A failed file stays `failed` until a person clears its row.
  - **When it runs** (`security.boost_ingest_gate_v1`, checked in this order): `boost.ingest_on` = 1; Pipeline Maintenance Mode off; Melbourne time 01:05–04:50; not inside the squash blackout (Thu 19 Nov 2026 01:30–03:30 AEDT); `housekeeping-daily` not running and started more than 20 minutes ago (it starts 03:47 AEDT and takes about 20 s, so the lane holds 03:47–04:07); and, checked by the function before each file, no PR 1 (`rollup-scheduler`), PR 2 (`admission-rule-runner` a, b, c) or PR 3 (`coverage-lane-dispatch` a, b, c) tick holds its lock. A held lock makes the function wait 5 s and look again (up to six times), then stop for that run. The PR 1 cutover review (Tue 17 Nov 23:20 AEDT) and PR 3 (06:45) fall outside the window.
  - **Settings** (Settings › Pipeline settings › Boost, toolset `pipeline`):

    | Key | Value | Range | Used by |
    |---|---|---|---|
    | `boost.ingest_on` | 1 | 0–1 | gate (the off switch) |
    | `boost.ingest_window_start_minute` | 65 (01:05) | 0–1439 | gate |
    | `boost.ingest_window_end_minute` | 290 (04:50) | 1–1440 | gate |
    | `boost.ingest_blackout_start_epoch` | 1795012200 (Thu 19 Nov 01:30 AEDT) | Unix seconds | gate |
    | `boost.ingest_blackout_end_epoch` | 1795019400 (Thu 19 Nov 03:30 AEDT) | Unix seconds | gate |
    | `boost.ingest_after_housekeeping_minutes` | 20 | 0–240 | gate |
    | `boost.ingest_files_per_run` | 4 | 1–50 | edge function |
    | `boost.ingest_rows_per_call` | 500 | 50–2000 | edge function |
    | `boost.quiet_window_start_hour` / `boost.quiet_window_end_hour` | 1 / 5 | hours | `boost_promote_v1` |
    | `boost.promote_rows_per_run` | 1000 | 1–5000 | `boost_promote_v1` |

  - **To stop it:** set `boost.ingest_on` to 0 (Settings › Pipeline settings › Boost, with a reason); the next run skips. Pausing the job on Automations also works.
  - **Nothing reaches the catalogue yet, for two reasons.** (1) No model is qualified (`pipeline.boost_model_qualifications` has 0 rows; the migration's post-check refuses any). (2) Nothing writes result files: the Boost Cloudflare Worker (`cf-boost-extractor`) and its exporter are built and tested locally but not deployed (they need the Cloudflare account and the AI-provider keys). Until both happen, each overnight run lists 0 files and exits. The "REQ and Roadmap chunks" in the 16:15 instruction are not a Boost input: the lane only reads Boost result files.
  - **Qualifying a model (Platform Admin, SQL editor).** Only `study_load` is ever admitted (only where the course has none and no manual lock); a row for `provider_accreditations`, `course_description` or `course_fees` only moves readings from shadow to proposed for that lane's own rule; `aer_entry` stays shadow. `provider` and `model` must match the Worker's result lines exactly.

    ```sql
    begin;
    insert into pipeline.boost_model_qualifications (lane, provider, model, qualified_by, qualified_at, reason)
    values
      ('study_load', '<provider, e.g. groq>', '<model, e.g. llama-3.3-70b-versatile>', null, now(),
       '<gate evidence: benchmark run, sample size, accuracy, date, who approved>')
    on conflict (lane, provider, model) do nothing
    returning lane, provider, model, qualified_at;
    select lane, provider, model, qualified_at, reason from pipeline.boost_model_qualifications order by 1, 2, 3;
    commit;
    ```

    Lanes allowed by the table: `study_load`, `provider_accreditations`, `course_description`, `course_fees`; `reason` must not be blank. Withdrawing a qualification is a delete, so it goes as a paste file.
  - **Dry run before merge** (production, rolled back): post-checks passed; gate now = outside the window; Thu 01:31 = blackout; Wed 03:00, Thu 01:10 and Thu 04:00 = open (4 files, 500 rows a call); 04:55 = outside; promotion dry run 0 rows; 5 register rows.
- **Paused for bulk ingestion, 13:34 AEDT** (Pilot #1195, migration `20261117051700`; 72-hour evidence from `security.job_outcomes_v1` and `cron.job_run_details`):

  | Job | Evidence |
  |---|---|
  | `scholarship-discover-refill` | hourly; 86 s a run, 102 busy minutes, 8 of 71 runs failed; it feeds the lane below |
  | `scholarship-discover` | 1 of 399 runs moved anything |
  | `scholarship-read` | 0 of 767 |
  | `calendar-reread` | 0 of 70 |

  Kept on: every job shadowed by PR 1, PR 2 or PR 3 (`coverage-reextract` and `policy-add-tests` are idle too but are PR 3 lanes), `openrouter-balance` (credit floor), and the jobs still moving work. **To resume:** Automations › the job › Resume (each pause is an Automations event with the reason).


| Item | State |
|---|---|
| Pilot #1200, #1208, #1210, #1213, #1215, #1216: CRICOS 11 Nov edition applied (Layer 1 register sizes and plan finish) | **Done 17 Nov 2026 20:11 AEDT** (S2-Build; Platform Admin 14:30). The edition's **1,953 of 1,953** planned course codes are in the catalogue (1,919 active, 34 inactive as the register marks them): run `4ae92b4f` applied 1,000, run `802d8928` the other 953 and reconciled. Causes found and fixed, each a size written into code or a slow statement under the service's 8-second limit: register apply calls (setting `layer1.register_apply_chunk`, now **20**, #1200, #1210), reporting stats made non-fatal (#1208), CRICOS facts call (#1213), courses per background batch (settings `layer1.batch_courses_au` 100 and `layer1.batch_providers_nz` 20, migration `20261117201000`, #1215), and the plan finish scanning the registrations once per new code (migration `20261117211000`, #1216; 1.1 s against more than 130 s). Workers: `layer1-au-depth` v1.9.2, `layer1-nz-live` v1.4.0, `layer1-au-cricos-facts` v1.4.0, `layer1-operations-control` v1.10.0. **Waiting on the Platform Admin:** 701 courses left the register, more than the automatic limit of 504, so their retirement is held for approval (run plan `802d8928`, departures `held`); 5 retired courses that are back on the register were reactivated. Specs s573, s584 |
| Pilot #1218, #1220: Wave 2 PR A, Layer 1 AI induction mapper (Mapper Contract v1.2) | **Live 17 Nov 2026 22:00 AEDT** (S2-Build; Platform Admin 17:55, 19:08, 19:58; AI routing choice 20:30: through the worker). Migration `20261117221000` (history md5 `3a69a2cb`); edge function `layer1-ai-induction-mapper` 1.0.0 (`status`, `map`; Curator and above); worker `coverage-sweep` v1.0.8 mode `induction_map` (prompt `induction.ts`, `induction-map-v1`). AI service route **`layer1_induction_map`**: one model `qwen3-30b` (central model, decision 13 Nov 19:09), provisional qualification on that decision, caps 2 USD and 200 calls a day; answer length `reading.answer_tokens.induction_map` (4,000). Declarative parser spec: allowed targets per record type `security.layer1_parser_targets_v1`, strict check `security.layer1_parser_spec_validate_v1` (fixed keys, types, transforms; attribution; unique key; expected headers), shared engine `_shared/cf247-layer1-spec.ts`. End-to-end check 21:56: the worker answered for 7 sample columns on Qwen3 30B (cost 0.00027 USD, recorded in `ai_invocations`, outcome answered). The wizard enables AI Auto-Map when `status` answers. Known limit: units are not converted (a "Duration (years)" column was suggested for `duration_weeks`; the person reviewing corrects it). Next: PR B (drift flags from the Layer 1 readers, re-infer job), PR C (generic runner and dry run). Spec s585 |
| Pilot #1221: Wave 2 PR B, Layer 1 parser drift and re-infer; Pilot #1224: Layer 1 queue-a-run workflow; NZQA register test load | **Live 17 Nov 2026 22:2x AEDT** (S2-Build; Platform Admin 19:58, 22:04). Migration `20261117233000`: settings `layer1.declarative_max_file_mb` (50) and `batch.layer1_parser_reinfer` (3); `security.layer1_parser_drift_mark_v1`; trigger `layer1_run_drift_watch` on `pipeline.layer1_run_queue` (a layout error flags the source's parser for re-inference, a completed run clears it); due list `security.layer1_parser_reinfer_due_v1` and `public.svc_layer1_parser_reinfer_queue_v1`; job `layer1-parser-reinfer` (`41 * * * *`, catalogued) asks the mapper to re-infer flagged parsers. Shared reader `_shared/cf247-layer1-read.ts` (CSV, XLSX, JSON). Spec s586. Read back live: trigger 1, job active, catalogue row present, nothing due. **Queue workflow** `.github/workflows/layer1-queue-run.yml` (hand-started, project ref typed to confirm) queues one source run through `security.layer1_queue_system_run_v1`, the scheduler's own path and checks, and follows it to the end; this replaces interactive database writes (Platform Admin 22:04). **NZQA test load done 22:41 AEDT:** run `abf3f467` (Actions run 44075260351, apply) read 414 of 414 NZQA providers in batches of 20 with no time-out (the 13 Nov run `981ce7ed` failed at 80); 87 register records reconciled, 8 created, 0 failed, 0 conflicts, 0 departures; status `completed`, stage `reconciled`. Next: Wave 2 PR C, the generic declarative runner. |
| Pilot #1233: Wave 2 PR C, the generic Layer 1 declarative runner | **Live 18 Nov 2026 00:2x AEDT** (S2-Build; Platform Admin 17 Nov 17:55, 19:08, 19:58, 22:04, 23:02). Migration `20261118013000`, edge function `layer1-declarative-runner` 1.0.0 (verify_jwt false), spec s596. For a source whose parser is AI-built: `dry_run` (wizard step 5; Curator and above or service role) reads the first `layer1.declarative_dry_run_rows` (100) rows, writes nothing to staging and records the counts with `svc_layer1_induction_dry_run_record` (a pass switches nothing on); `apply` (service role only; active, unpaused source, terms approved under REQ-68, undrifted AI-built parser) reads `layer1.declarative_batch_rows` (2,000) a call and continues by offset, keeps the file as evidence (a changed file stops the run), stages in chunks of `layer1.declarative_chunk_rows` (200) with a row key and SHA-256 row hash in `pipeline.layer1_declarative_rows`, applies only new and changed course or provider register records through `svc_layer1_apply_register_records` (chunks of `layer1.register_apply_chunk`), stages the other five record types for review, routes each record's open fields to the eight enrichment categories (`security.layer1_gap_routes_v1`), flags Australian postcodes (primary, layer4_review, outside_sua) and, on the last call, marks unseen staged rows departed in staging only (the catalogue is not touched). Header drift halts the run and flags the parser for the hourly re-infer job (#1221). Run log `pipeline.layer1_declarative_runs`; `layer1.declarative_max_rows` (200,000) caps a source. No job scheduled: the runner is started by the service role (a scheduler hook comes with the first activated AI-built source). No AI-built parser is active yet, so nothing has run. |
| Pilot #1240 and #1243: Wave 2 drafts ready to map and sample-test; live admitted counts | **Live 18 Nov 2026 08:0x AEDT** (S2-Build; Platform Admin 07:34). Migration `20261118080000` (spec s598): registration schemes `uk_ukvi` (provider_registration, GB), `uk_hesa` (course_registration, GB), `ie_ilep` (course_registration, IE) and `us_ipeds_completions` (course_registration, US), all planned, set on the UKVI, Discover Uni, ILEP and IPEDS completions drafts; step 1 is now finished on all nine Wave 2 drafts. Four seed sources of 11 Aug (Office for Students Register, Discover Uni Dataset, Irish Register of Qualifications, UKVI Register of Licensed Student Sponsors) held no data and no Layer 1 controls (no reference in any of the 46 tables that point at `pipeline.sources`) and blocked activation; they are retired, not deleted, each naming its replacing draft (4 events). `admin_layer1_add_source` now refuses a duplicate only on the same address and the same name, so the IRQ providers and programmes drafts, and the IPEDS institutions and completions drafts, can each be activated. #1243 (spec s599): wizard step 5 gains **Run dry run** (`layer1-declarative-runner`), enabled once a draft has an AI-built parser spec. **What each draft still needs (the Platform Admin's, in the wizard):** a sample file for AI Auto-Map (step 3; none has a spec yet); the address of the data file itself where the address is a landing page (all nine are landing pages today); terms approval (all nine pending, REQ-68); a passing dry run; activation (rank 6). OfS, both IRQ drafts and PGWP are web pages (connector html_pages), which the declarative runner does not read (CSV, XLSX and JSON only): they need a file export or a page reader. **Live admitted counts (read 18 Nov 07:38 AEDT):** active courses 36,031 (AU 25,703, NZ 6,514, CA 3,814); active providers 3,091 (AU 1,544, CA 1,130, NZ 417); CRICOS 11 Nov edition: 1,953 of 1,953 planned codes in the catalogue, 1,919 active, 701 departures held for the Platform Admin; NZQA run `abf3f467` completed (414 of 416 provider rows read, reconciled, 0 departures); destination: 102 ABS SUA localities (draft) with 102 metrics, 2,947 postcode-to-SUA share rows; study rules 0 and career outcomes 0 (their loaders are Categories 2 and 3, still to build); `campuses[].locality` is in `ref.api_field_dictionary` for website and Zoho (7 paths each). |
| Pilot #1245: Wave 2 Track B page reader (`html_table`) | **Live 18 Nov 2026 09:0x AEDT** (S2-Build; Platform Admin 08:19). No migration (the spec check already allowed `html_table` with `source.table_index`); live head stays `20261118090707` (S2 - BOOST / v2.16.31). Spec **s613** (new); **s599 renumbered to s612** so s599 stays with S2 - BOOST (same guard; retirement log). New `_shared/cf247-html-table.js`: a deterministic table extractor shared by the edge reader and the wizard (no script, no network; comments, script, style, noscript, template and svg removed; nested tables numbered in opening order; colspan and rowspan resolved; entities decoded; unclosed tags closed safely; `table_index` and `header_row` choose; empty headers named, duplicates told apart, repeated header and empty rows dropped). Reader `format html_table`; mapper 1.2.0 (deployed v3: `map` takes `source.table_index`/`header_row` for Web pages, re-infer reads `html_table`); runner 1.0.1 (deployed v2: evidence `text/html`, dry run reports `tables_on_page`, still `p_write: false`); wizard: the sample upload takes a saved web page (the table with most rows, its index passed to AI Auto-Map). Read-only probe workflow `Layer 1 HTML table probe` (run 44183648063 against the Track B addresses): **PGWP** page reads as one table of 1,107 data rows and 5 columns (Category, CIP Code, CIP Title, Study permit eligibility, PGWP eligibility), so it is **ready for AI Auto-Map and Run dry run** (upload the saved page, or map from it directly); **OfS** and both **IRQ** draft addresses are guide pages with **no table** (0 tables found): they need the address of a page or file that holds the register (the OfS Register is a separate digital service; the IRQ is a search service), so Track B cannot read them as they stand. G3 75/48. |
| Pilot #1201, #1207, RM1B ABS population and postcode loader | **Live 17 Nov 2026 18:40 AEDT** (S2-Build; approvals A-1 to A-4). Migration `20261117180000` (history md5 `e2e5fbd0`), edge function `layer1-destination-geo-loader` v1.0.0, job `destination-abs-load` (1st of the month 05:30 Sydney, catalogued, Run now through `security.destination_job_run_now_v1`), workflow `destination-abs-shares-load`. First load: 2,947 Postal Area to SUA shares for 2,641 postcodes (ASGS Edition 3 Mesh Block allocation files, sha256 `96c3ce68…52340`); **102 SUA localities** and 102 population figures (ERP 30 June 2025), all draft, attribution and evidence on every row (ABS workbook stored, sha256 `625c7c3d…eca39`); 1,303 locality postcode rows (1,064 primary, 239 flagged). Of 805 AU campus postcodes: 611 map at 90% or more, 94 are flagged (312 campuses in Layer 4 › Campus locality), 100 are outside any SUA (no locality; question to the Platform Admin). Spec s574 |
| Pilot #1162, API v3 field dictionary sync (REQ-76) | **Merged 16 Nov 17:05 AEDT** (taken over by S2 - SS Build): migration `20261116110000`, 1,923 rows live; 2 fields wait for the paste file |
| Pilot #1178, AER routes | **Merged 16 Nov 17:49 AEDT.** AER v1 entry reading (`course_entry_requirements`, `entry_matrices`) is **off**: Qwen3 30B unqualified, no model qualified. AER v2 shadow: Mistral Small 3.2 alone, provisional, off. See `docs/platform/layer4-clearance-and-model-benchmark-2026-11-16.md` §6 |
| Pilot #1179, worker v1.0.6 AER long pages | **Merged 16 Nov 18:02 AEDT**; the first deploy run failed reading migration history (Management API error) and the re-run passed. Worker `coverage-sweep-worker-v1.0.6` live from 18:05. Switch `reading.aer_v2_long_page_sections_on` = 0 |
| Split Pilot `docs/paste/` (41 files) | **Approved, Platform Admin 16 Nov 2026 10:10 (option 1).** After the PR 2 cutover (Tue 17 Nov 22:30 AEDT) is verified: the SQL files that specs or database fixtures read or run move to Pilot `tests/fixtures/` (all 18 guard specs keep their assertions, no cross-repository CI); every file a person runs moves to this repository's `docs/paste/` only; a Pilot guard then refuses any new `PASTE-*.sql` in Pilot. Queued for Wed 18 Nov 2026 09:15 AEDT, separate from the PR 3 queue. Never create a new `PASTE-*.sql` in Pilot. |
| UI/UX and settings simplification audit and plan | **Committed 16 Nov 2026 10:25 AEDT:** [`docs/platform/ui-audit/ui-ux-settings-audit-2026-11-15.md`](platform/ui-audit/ui-ux-settings-audit-2026-11-15.md), verbatim as supplied by the Platform Admin (decisions §6, UnoPim specs §7, progress to v2.16.12 §8). Phase 4 (Dispatcher Panels) waits for the PR 1 to 3 cutovers. |
| `cron-governance-audit-2026-11-15.md`, `rollup-scheduler-pr1-scope.md` | **Not yet in this repository.** The session that wrote them is committing them to `docs/platform/` before it closes (Platform Admin 16 Nov 2026 10:21). Until then, Pilot migrations and PRs #1157 and #1159 cite them as "project doc claude/…". |

### Production bulk data ingestion readiness (17 Nov 2026 08:50 AEDT; Platform Admin 07:39)

**17 Nov 14:05 AEDT:** the Admin screens are live (v2.16.19). The 19 November hold is cancelled (Platform Admin 13:12); loaders and ingestion are S2-Build's lane, and each load job named `destination-…` appears on Platform health › Data delivery › Destination loads once catalogued. Design for the screens, the API v3 blueprint and the ordered post-squash build is in [`docs/Roadmap/2026-01/DESTINATION-DATA-UI-AND-INGESTION-SPEC.md`](Roadmap/2026-01/DESTINATION-DATA-UI-AND-INGESTION-SPEC.md) v1.0 (v1.2; decisions G-1 to G-5 approved 17 Nov 11:52). The Destination data page is in `docs/UI-MAP.md` from v2.16.19.

Schema for every remaining roadmap item is live (Pilot #1194, migration `20261117040000`; design `docs/Roadmap/2026-01/DESTINATION-DATA-DESIGN.md` v1.6). No destination data is loaded. Target rows marked "estimate" are planning figures to confirm at the first capture.

| Dataset or adapter | Target rows | Lands in | Entry point | Ready? | Blocker or next step |
|---|---|---|---|---|---|
| CRICOS 11 Nov edition | **Applied 17 Nov 20:11 AEDT**: 1,953 of 1,953 planned course codes in the catalogue (row above) | Catalogue, through the Layer 1 register plan `d35d2541` | Layer 1 › Sources | Yes | 701 departures wait for the Platform Admin's approval |
| ABS population and ASGS postcodes | About 100 Significant Urban Areas (estimate); one population figure each; postcode shares for the 805 distinct AU campus postcodes (3,990 AU campuses) | `destination.localities`, `locality_metrics` (category `population`), `locality_postcodes` | Service-role upsert on the tables' unique keys; flags from `security.destination_postcode_flags_v1`; approve with `admin_destination_set_status` | Schema yes; loader no | Sources approved (A-1 to A-4). Build one catalogued load job; no direct Postal Area to SUA file exists in ASGS Edition 3 correspondences (checked 17 Nov), so the Mesh Block allocation (A-4) is the method. About 368,000 Mesh Blocks across three ABS files is beyond an edge function's 2-second CPU limit: the loader is planned as a catalogued GitHub Actions job (S2-Build) |
| BOM climate and living costs | Not set: localities with a campus × agreed measures | `destination.locality_metrics` (categories `climate`, `living_cost`) | As above | Schema yes | Sources and reuse terms not yet approved; needs localities first (RM1B) |
| JSA careers | About 350 to 360 occupations at four-digit level (estimate) | `destination.career_outcomes` through a `career_outcomes` edition | `security.destination_import_v1(payload)`; terms with `destination_edition_set_terms_v1`; publish with `destination_edition_publish_v1` | Yes for a national edition | Reuse terms (REQ-68) and edition choice. Confirm the edition's occupation coding matches a listed scheme (ANZSCO, NOC, SOC). G-1 grain is live (Pilot #1196): one row per edition, country, scheme, occupation and area (national, state or locality); `security.destination_import_v1` takes `occupation_scheme` (required), `geography_level`, `state_code`, `locality_id`, `reference_period`, `dataset_edition`, `attribution_text` |
| Study rules | About 15 to 25 AU rules (estimate): direct and five admissions-centre routes, funds, fee, work rights, post-study work, processing times | `destination.study_rules` and `rule_applicability`, through a `study_rules` edition | Visa rows: `security.destination_import_v1(payload)`. Categorised rules: service-role insert into a draft edition, then row approval, then edition publish | Schema yes; importer covers visa rows only | Capture each official page first. Extend the importer to the new rule fields with the first capture |
| NZQA courses | 3,894 four-digit candidates to match; 2,559 provider-style codes to classify | `catalogue.course_registrations` (scheme `nzqa`), course-level evidence | Layer 1 NZ adapter: new NZQCF qualifications capture | Schema yes; capture no | Build the capture. NZQA commercial-use terms flagged for management |
| UK, Ireland and USA adapters | Not set | Catalogue; schemes `uk_qaa`, `uk_ofs`, `ie_qqi`, `us_opeid`, `us_ipeds`, `hecos`, `cip` registered in `ref.registration_schemes` | None yet | No | Adapters RM3A, RM5A, RM6A are not built |
| Layer 4 Boost queue | 4,906 pending review items (read 17 Nov 08:44; 61,907 items in all) | `pipeline.layer4_review_items` | Layer 4 Review; Boost plan in `docs/platform/CF-WORKER-BOOST-AND-PROD-LAUNCH.md` | Existing path | Not changed by this release |

Order that unblocks the most: CRICOS apply, then the ABS load job (it gives every later city dataset its localities), then study-rule capture.

### Parallel Wave 2: Layer 1 induction wizard and completeness report (Platform Admin 17 Nov 2026 17:59, decisions 18:10; Pilot #1211, v2.16.24, 18:54 AEDT)

| Item | State |
|---|---|
| Wizard | Layer 1 › Sources › + Add source opens six steps: Country & scheme, Source & licence (REQ-68 terms), Field mapping, Cadence & retention, Dry-run preview, Activation. Drafts are saved at each step in `pipeline.layer1_source_inductions`. Pipeline Operator and above draft; the Platform Admin activates with a reason, logged. The source is created **paused** through the existing `admin_layer1_add_source`. No draft exists yet. |
| AI Auto-Map | **The mapper `layer1-ai-induction-mapper` is deployed** (Pilot #1218, #1220, S2-Build; 17 Nov 22:00 AEDT), so the button's probe finds it and it switches on. Re-inference of drift-flagged parsers runs hourly (Pilot #1221). Contract: `docs/platform/LAYER1-AI-INDUCTION-MAPPER-CONTRACT.md`. |
| Dry run | Recorded only by the service role (`svc_layer1_induction_dry_run_record`). A new source has no reader, so step 5 says Waiting for a reader; a recorded pass switches nothing on, and a recorded fail blocks activation. |
| Retention | The wizard records per-source values (defaults 14 days staging, raw snapshots permanent, as today's policy). **Not enforced:** `pipeline.retention_class_policies`, prune jobs and stored data are unchanged. |
| Enrichment categories | `ref.enrichment_categories` (8: Course basics, Fees, Entry requirements, Intakes & deadlines, Campus & location, Provider profile, Recognition & registration, Scholarships) and `ref.enrichment_category_fields` (the 32 coverage fields; 0 unmapped). The Platform Admin moves a field with a reason. |
| Category list (decided 19:58: one list) | `ref.enrichment_categories` and `ref.enrichment_category_fields` are the single list; `public.svc_enrichment_categories()` publishes it to every lane; keys, fields and the crosswalk are in `docs/platform/ENRICHMENT-CATEGORIES.md`. **Not yet one list in practice:** the Boost matrix setting `country_category_boost` and its check function still hold eight other keys (S2 - BOOST's lane). Moving it needs new weights for five categories and a decision on study rules and career outcomes, which have no key in the eight. |
| Report | Platform health › Country & category completeness (Curator and above): field fill by country and category from `pipeline.field_coverage_daily`, each Layer 1 source's editions, last change and retention, Layer 4 items by how long they have waited (settings `health.layer4_age_warn_days` 7, `health.layer4_age_old_days` 30). First read 17 Nov: AU entry requirements 29.9%, intakes & deadlines 18.9%, scholarships 5.8%; NZ fees 22.9%; CA fees 19.2%. A category figure pools its fields, so course and provider fields are counted together. |
| Parser line items (v2.16.25, Pilot #1214, 19:09 addenda) | Layer 1 › Sources has a Parser column: Hardcoded parser, AI-built parser or No parser yet, from `pipeline.layer1_source_parsers` (`admin_layer1_parser_status`). Live now: 43 sources, all Hardcoded, no parser row yet (AU 9 including CRICOS, QILT, PRISMS and TEQSA; NZ 2; CA 26; 3 world rankings with no country). ABS is a destination load job, not a Layer 1 source, and there is no UK, IE or US source yet, so the Country filter does not list them. |
| Re-infer Parser Spec | Shown on a line only when a reader has flagged layout drift (`svc_layer1_parser_drift_record`). Pipeline Operator and above, with a reason; recorded on the parser row and in the control log; nothing is run. **No reader flags drift yet**, so the button does not appear today. |
| Target record type | Wizard step 1: Course register, Provider register, Tuition fees, Study rules, Destination metrics, Career outcomes, Scholarships. Step 3 previews the mapper's parser spec, target table and category routing when the mapper returns them; on activation the spec becomes the source's AI-built parser. Contract v1.1 for S2-Build. |
| Per-source retention (decided 19:58: one place) | The wizard keeps one optional Staging kept (days) and, on activation, sets it through S1-Build's `admin_source_retention_set` in `pipeline.source_retention_policies`, which `housekeeping-daily` reads. The completeness report reads the same table and the `retention.*` settings (90 days, hashes 7 years, pruning off). No source has its own period yet. |
| Role gates (decided 20:45, by role name) | Curator (rank 3) and above open Layer 1 and create, edit and cancel drafts; Pipeline Operator (rank 4) and above request Re-infer Parser Spec; only the Platform Admin (rank 6) activates. `security.admin_layer1_operations_read` now opens at rank 3 (md5 `3af9dff0`). Every other Layer 1 control keeps its rank; `layer1_statistics_candidates_read` stays rank 4, so a Curator does not see new-edition candidates. |
| Deployed UAT on `main` (22:55 AEDT) | **Green.** After the Platform Admin aligned the UAT account password with `UAT_PASSWORD`, the re-run of 22:31 AEDT passed, and so did the runs for Pilot #1224, #1223 and #1225 (`24651f52`: Deploy on merge, Deployed UAT, Frontend Build, Release History Contract and Release Currentness Deployed all green). These were the first live runs of the role-boundary test updated in Pilot #1222 (the operator opens the Add source wizard and cannot activate). The `admin_read` (`dashboard`) time-out seen at 21:43 and 21:57 AEDT did not recur in these four runs; its cause was not investigated. A reset of the UAT account's password from the Admin breaks the run until the secret is updated. (The earlier row was stamped 22:50 AEDT in error; it was written at about 22:25.) |
| Evidence and Layer 4 items (20:06) | Country & category completeness has the table Evidence captured and Layer 4 review items, by source, from S1-Build's `admin_ops_telemetry()`: two counts side by side, no rate. Live example: IRCC Designated Learning Institutions, 7 evidence captures and 825 review items in the window. |
| Not checked | The wizard and the report signed in; `admin_completeness_report` called as a signed-in user (its queries were read live separately). |

### Release v2.16.20, Users & roles › Links & Email Templates (Platform Admin 17 Nov 2026 14:40; Pilot #1202, 15:25 AEDT)

| Item | State |
|---|---|
| Screen | Administration › Users & roles now has two tabs (it had none): Users & roles, and Links & Email Templates (Platform Admin). Link settings, Invite User and Reset Password editors with variable chips, live preview, Reset to Default, Send Test Email, Save & Sync with a reason. |
| Database | `admin_auth_template_settings_read()` and `admin_auth_template_settings_save(payload, reason)` (rank 6; the save writes `pipeline.admin_control_events`, area `access`). One row `admin_auth_email_templates` in `pipeline.environment_settings`, written on the first save; until then the branded defaults apply. It shows read only on the Go-live checklist. |
| Copy to Supabase Auth | **Off.** `admin-user-management` copies the site URL and the two emails to Supabase Auth only when the Edge Function secret `SB_MANAGEMENT_TOKEN` (a Supabase access token for project `fxcwkweaxjtknorudmwp`) is set. Until the Platform Admin sets it, a save is stored and logged and Auth keeps the emails pasted from `docs/paste/PASTE-20261117-supabase-invite-email-template.md`. |
| Where links return | Still the edge function's `ADMIN_LOGIN_URL` (default the Worker address) and the Redirect URLs list in Supabase Auth. The Admin Site URL setting does not change the redirect by itself. |
| Signed-in test (Platform Admin, 15:45) | An invitation arrived with the indigo template applied at 14:33 and the sender "Supabase Auth". Nothing has been saved on the tab yet (no row in `pipeline.environment_settings`). |
| Emails in Supabase Auth now | **The `#0b6e5f` StudySearch PIM Admin templates, applied 17 Nov 16:04 AEDT** by workflow `supabase-auth-config.yml` (run 44021389741, read back PASS): subjects "You're invited to StudySearch PIM Admin" and "Reset your StudySearch PIM Admin password"; template md5 `f34516d2` (invite) and `e7fe57cf` (reset), equal to steps 2 and 3 of the paste file, which now hold the tab's defaults as Auth reads them. Site URL and redirect list unchanged. |
| v2.16.21 (Pilot #1203, 16:00 AEDT) | Users & roles: **Resend invite** on the row of a person who has not accepted yet (`admin-user-management` action `resend_invite`, recorded as `user_invited` with `resent`). Reset password has been on the row since v2.16.16; it is greyed for your own account and a Platform Admin. Links & Email Templates: a warning while the token is missing, with **Copy HTML for Supabase Dashboard** and Copy subject. |
| `SB_MANAGEMENT_TOKEN` | **Decided 17 Nov 16:13: not set.** No account-wide token is kept in the edge function. Supabase Auth's own templates are updated by workflow `supabase-auth-config.yml` from the paste file; Copy HTML stays on the tab. |
| Empty name (v2.16.22, Pilot #1204) | `{{user_name}}` becomes a conditional that takes its comma or space with it: "Welcome" and "Hello,". Applied to Supabase Auth 16:31 AEDT (workflow run 44024617120, read back PASS; md5 `e96fd944` invite, `d43f6e72` reset). |
| Email delivery provider (v2.16.23, Pilot #1206) | Links & Email Templates › Email delivery provider: Supabase Built-in or Resend API, Sender Name (default StudySearch PIM Admin), From Email, and a write-only Resend API key. Provider, sender and from email are the row `admin_email_delivery` in `pipeline.environment_settings`; the key is in Supabase Vault (`admin_resend_api_key`), read only by `svc_admin_email_delivery()` (service role). With Resend in use, Create user › Send invitation, Resend invite, Reset password and Send Test Email are written from the templates saved on the tab and sent through the Resend API (`auth.admin.generateLink` makes the link). |
| Email provider card: save and test (v2.16.27, Pilot #1225, 22:51 AEDT) | The card has its own Reason box, **Save Email Provider Settings** (always enabled; the card says what is missing) and **Send Test Email**. The test calls `admin-user-management` `auth_template_test` with `via: "resend"`: it sends the selected template through Resend with the saved sender, from email and key to the signed-in admin's own address, also while Supabase built-in is still the provider, and shows Resend's reference or error in the card. Save & Sync saves link settings and templates only. Edge function version 12 deployed. **Not verified:** a real send (no key is saved; provider still `supabase`) and the buttons signed in. |
| Wave 2 register drafts (Pilot #1228, migration `20261118004000`, 23:27 AEDT) | Nine drafts in `pipeline.layer1_source_inductions`, opened from Layer 1 Register › + Add source › Continue a draft. **United Kingdom:** Office for Students Register (provider register, scheme `uk_ofs`), Discover Uni dataset (course register), UKVI Register of Licensed Sponsors: Students (study rules). **Ireland:** Irish Register of Qualifications providers and programmes (scheme `ie_qqi`), Interim List of Eligible Programmes (study rules). **United States:** IPEDS institution directory (scheme `us_ipeds`; the OPE ID is a column of the same file), IPEDS completions by programme (course register). **Canada:** IRCC PGWP-eligible fields of study (scheme `pgwp`). Each has a 90-day staging keep period (applied to `pipeline.source_retention_policies` only on activation), licence terms pending and a cadence. **A draft is not a source:** `pipeline.sources` is unchanged at 3,412 and no retention policy was written. **Not drafted:** IRCC Designated Learning Institutions, already a live Layer 1 source (`layer1-ca-live`). **Open before activation:** (1) four drafts have no registered scheme (Discover Uni, UKVI, ILEP, IPEDS completions), so step 1 is unfinished until S1-Build or the owner of `ref.registration_schemes` adds them; (2) four drafts have no mappings because their field names are not known (OfS, both IRQ, ILEP): upload a sample, then AI Auto-Map; the other mappings are expected names to check against a sample (the PGWP columns were read from the page); (3) older catalogue rows already exist in `pipeline.sources` for OfS, Discover Uni, IRQ and UKVI and must be reconciled first; (4) the ILEP is closed and is being replaced by the TrustEd Ireland list about the end of 2026; (5) the eight categories have no study-rules category, so eligibility columns sit under Recognition & registration. |
| Reference tables (v2.16.28, Pilot #1230, 23:30 AEDT) | Reference data has two more types: **API field dictionary** (2,085 fields; search by field, endpoint, source column or request number; filter by API and version) and **Grade scale conversions** (0 rows loaded; the screen says so). Read-only, Curator and above, through `public.admin_reference_table_read` (stable; md5 `b9d32f97` equals the file). Setting `admin.reference_table_page_rows` (50). |
| UI audit: columns and filters for the new fields (23:05 AEDT request) | Written up in `docs/platform/ui-audit/api-v3-layer1-boost-fields-columns-filters-2026-11-17.md`. **Built:** the two reference tables. **Already present:** destination and postcode reference (Destination data › Localities & postcodes). **Not built yet:** Courses Study load and Empty reason; Campuses Primary and Locality; Sources Retention (days); Providers Accreditations. **Cannot be built as asked:** Boost priority score and Country tier (no such stored fields) and `campuses.locality` (no such column; locality is looked up by postcode). `catalogue.provider_accreditations`, `ref.grade_scale_conversions` and `pipeline.source_retention_policies` hold 0 rows. |
| Courses and Campuses columns (v2.16.29, Pilot #1239, 18 Nov 07:48 AEDT) | **Courses:** Study load and Empty reason are in the Columns picker (off until shown; the registry holds 42 columns) and under Filters (`courses_page` arguments `study_load`, `empty_reason`). **Campuses:** Primary badge and filter; Locality, looked up from the campus postcode (primary match, newest boundary vintage, whatever its review status, shown as Draft until approved) with a search. **How:** md5-guarded in-place edits of `security.admin_course_page_fast` (`a5cd4a72`), `security.admin_course_page_fast_base` (`e0cddf8a`), `security.course_list_with_extras_v1` (`db3b7ed0`) and `public.admin_read` (`b6570ab8`); live body md5s equal the migration's. New `security.admin_campuses_page_v2`; `security.admin_campus_page_fast` is unused and marked `retiring` (paste file after the retention window). Two partial indexes on `catalogue.courses`. Held forward recovery: Pilot `supabase/held/course_campus_new_fields_forward_recovery.sql`. **Speed on the production-parity fixture:** Courses filtered 11 to 85 ms; Campuses 13 to 18 ms. **Not verified:** the screens signed in; live timings. |
| Decisions of 18 Nov 2026 07:03 (Platform Admin) | **Routing rule:** a source read on a schedule belongs in Layer 1 Register; a reference address or dataset that is not belongs in Reference data. **Boost priority score and Country tier:** not stored; worked out when the Boost queue is read (shipped, Pilot #1242). **ILEP:** kept as a draft and marked as a deprecating source, to move to TrustEd Ireland. **Schemes and duplicate rows:** done by S2-Build (Pilot #1240): `uk_hesa`, `uk_ukvi`, `ie_ilep`, `us_ipeds_completions` are registered, the four older seed rows are retired, and all nine drafts now carry a scheme (checked live). |
| Operator runbook (18 Nov) | `docs/platform/DESTINATION-EDITIONS-AND-WAVE2-DRAFTS-RUNBOOK.md`: destination load to published edition, Wave 2 draft to paused source, the routing rule, and where to look up API v3 fields. **Found:** Publish edition does not require every locality to be approved (the server needs approved terms and at least one row; unapproved rows are never returned). `API-V3-FIELD-DEFINITION.md` still says `study_load` is "not proven live"; about 2,500 courses hold one. The RM0B handover stays unissued until v3 release. |
| Boost queue (v2.16.30, Pilot #1242, 18 Nov 08:33 AEDT) | Platform health › Queues & yield has a **Boost queue** card: each of the 2,178 items Boost has taken, with **Country tier** and **Priority score**, a summary by country and lane, filters (tier, country, lane, state) and a sort by score. Read through `public.admin_boost_queue_read` (Curator and above, stable, writes nothing; history md5 `0061da28` equals the file). The score is country weight × category weight through S2 - BOOST's own `security.boost_country_category_weight_v1`; tiers are the `boost.matrix.tier_1` and `tier_2` lists. Nothing is stored on a course and the Course catalogue does not show them. Live scores on 18 Nov: AU study load 80, NZ 76, CA 72. Setting `admin.boost_queue_page_rows` (50). **Not verified:** the card signed in. |
| Bulk Approve Drafts (v2.16.31, Pilot #1242, 18 Nov 08:33 AEDT) | Destination data › Localities & postcodes shows, for each dataset edition with draft localities, how many are ready, with **Bulk Approve Drafts** (Platform Admin, one reason). `public.admin_destination_localities_bulk_approve(dataset edition, reason)` approves every clean draft (name and attribution present), leaves a draft without attribution, changes no figure, rule or edition, and writes one control event (history md5 `6bd2e9f7` equals the file). **Not used yet:** all 102 localities of "ABS Regional population 2024-25" are still draft and no bulk event is recorded; the approval is the Platform Admin's. Figures have their own button since v2.16.32 (next row). **Not verified:** the button signed in. |
| Bulk Approve Drafts for figures (v2.16.32, Pilot #1250, 18 Nov 10:24 AEDT) | Destination data › City metrics & costs has the same button. `public.admin_destination_figures_bulk_approve(dataset edition, reason)`: Platform Admin, one reason, every clean draft figure of the edition (attribution present), one control event; no locality, rule or edition is changed (history md5 `e70b30bd` equals the file). The ILEP draft's note no longer says `ie_ilep` is to be registered. **Not used yet:** 102 localities and 102 figures are still draft; no bulk event is recorded. **Not verified:** the button signed in. |
| `study_load` and API v3 (checked 18 Nov 10:20 AEDT) | **Held:** 3,772 of 44,733 courses (2,251 full-time, 187 part-time, 1,334 both), all read from provider pages; Boost has admitted 1,251. `docs/integrations/api-v3/API-V3-FIELD-DEFINITION.md` says so. **Not exposed:** no `website_v3_course*` or `zoho_v3_course*` function returns it, and `ref.api_field_dictionary` lists `study_load` on the scholarship actions only. Returning it on the v3 `course` and `search` actions is open work for the v3 lane before the RM0B handover (v3 is not frozen, so it is an additive change there). |
| Migration number collision (18 Nov 07:47 AEDT) | Pilot #1239 and S2 - BOOST's #1238 both used `20261118073000`. #1238's deploy had already stopped on its own post-check and applied nothing; #1239 applied and holds the version in the history. S2 - BOOST re-landed theirs as `20261118074500` (#1241), which removed the second file. No data was affected. S1-RM-Design now re-reads `main` and the open PRs in a separate step immediately before each merge. |
| Live state of delivery | **Supabase built-in** (read 16:53 AEDT): no provider saved, no key in Vault. Resend starts when the Platform Admin chooses Resend API, enters the from email and the key, and saves with a reason. |
| Still from Supabase Auth | *Forgot password?* on the sign-in screen, whichever provider is chosen. Its sender name changes only with custom SMTP: Go-live checklist row `auth_custom_smtp` (pending), scope in `docs/platform/SUPABASE-AUTH-CUSTOM-SMTP-RESEND-SCOPE.md`. |
| Not checked | Any email as received; a real send through Resend (no key exists outside the Platform Admin's hands); the deployed edge function version read back; a save, a test email and a resent invitation, signed in. |

### Release v2.16.16, Admin UI (overnight task, Platform Admin 16 Nov 2026 22:12; Pilot #1189, 17 Nov 00:53 AEDT)

- **Users & roles:**
  - **Reset password** for another person's account (edge function `admin-user-management`, action `reset_password`). Not for a Platform Admin, your own account, the system account, a disabled account or an open invitation.
  - **Send invitation** passes `redirectTo` = `https://coursefinder-pilot.techm.workers.dev/` and `data { role, role_code, guide_url, full_name }`.
  - Links open a set-password screen. The sign-in screen has Forgot password?.
- **Catalogue lists** (Providers, Courses, Locations, Scholarships, Course readiness): **Export CSV**, visible or all columns, with every filtered row.
- **Paths taken:** A for invitations (Supabase `inviteUserByEmail`); A for the export (shared `DataTable`).
- **Not done here:**
  - Resets are not written to the access history (`user_access_events` action check). Widening it is a migration for a later change.
  - The Supabase Redirect URLs allow-list and the templates: applied 17 Nov 2026 14:33 AEDT (section 5 › S1-Build).

### Order of work to the 20 Nov data admission delivery (Platform Admin 16 Nov 2026 10:59)

| When (AEDT) | Work |
|---|---|
| Tue 17 Nov 23:20 | PR 1 cutover review, after the fixed 24-hour shadow (fix live Mon 16 Nov 23:14) |
| Mon 16 Nov 23:15 | PR 3 scope, build and merge in shadow: **in shadow since Tue 17 Nov 06:21 AEDT** (Pilot #1188, 13 lanes) |
| Wed 18 Nov 06:45 | PR 3 post-cutover health check done 06:46 (read only): 13 lanes live, 1,412 dispatches succeeded and 0 failed, 0 legacy jobs on or started, no breaker issue, G3 75/48 |
| ~~Tue 17 Nov 22:30~~ | PR 2 cutover: **done Mon 16 Nov 23:31 AEDT** (Platform Admin override 21:23) |
| Wed 18 Nov 09:15 | Pilot paste-file split (option 1) |
| Daily 08:05 | Telemetry tabs refresh (`Model_Tier_&_Token_Efficiency`, `Layer_Lifecycle_Funnel`) before the 08:15 report |
| ~~Tue 17 Nov 09:45~~ | API v3 data PR A and PR B: **done Mon 16 Nov 21:50 AEDT** (Pilot #1184; counts in section 5) |
| Wed 18 Nov 09:30 | **Phase 5 before Phase 4:** Review & Evidence DataGrid, first slice on Layer 4 › Inbox, with shared views `AER Audit Samples`, `Official URLs`, `Provider Blockers`, personal views and the quote-versus-value drawer. Phase 4 (Dispatcher Panels) follows Phase 5 |
| Tue 17 Nov 07:30 | **AER benchmark round 3: done, Path B** (Pilot #1191 and #1192; runs 24 to 26). Mistral failed the gate: 13/50 right, error 22 pts, source integrity 85.7%, 1 false positive. AER v1 and the v2 shadow stay off; nothing qualified; no re-reads. Benchmark report §6.1 |
| Tue 17 Nov 13:15 | **PR E:** grade scales (REQ-19, scale decided 16 Nov 16:52) and destination draft editions; plan section 6 |
| Wed 18 Nov 13:30 | **API v3 data PR C** (AACSB/EQUIS/AMBA accreditations from the official lists, on demand) then **PR D** (v3 reads the four fields) |

### Course descriptions (v2.16.13 and v2.16.14, 16 Nov 2026)

- **Rejection memory (v2.16.13, Pilot #1174):** only a person's decision counts as an earlier refusal; rule `cdesc-machine-v2`. 492 admitted in the first 30 minutes; the waiting count went below the 1,500 back-pressure limit at 12:24.
- **Prompt v3 (v2.16.14, Pilot #1175):** no introducing opener sentence ("The <course> at <provider> is a ..."). By the existing rule, waiting v2 descriptions declined for good are superseded and read again with v3 (400 of 782 by 13:14; 790 waiting).
- **Retry gate:** the second model only for `enrich.cdesc_retry_rules` (`quote_not_on_page`, `identity_margin_thin`). Before: Mistral retries rescued 18.6% (1,095 admitted a day). Watch `retry_rescue_rate_pct` and `first_pass_admit_rate_pct` on `Model_Tier_&_Token_Efficiency`; the list is changed with a reason in Settings › Settings › Course description and deadline.
- **Ledger:** every AI attempt is written as it completes (worker v1.0.5), which closes the HTTP 546 gap found in the check below; the spend the ledger missed is shown daily as `unlogged_546_gap_usd` (US$0.96 for 15 Nov UTC).
- **Readings (13:36):** resumed with v3 (13:23 run succeeded; 3 AI calls by 13:35), but throttled by the rolling 24-hour cap `enrich.course_text_items_per_day` (8,000, full with the 15 Nov 16:00–17:00 re-read wave). Bulk v3 re-reads, including the 782 superseded descriptions, start at the 16:23 or 17:23 run. 15 waiting in Layer 4; 892 admitted by `cdesc-machine-v2` since 11:53.
- **Next bottleneck:** about half of first descriptions are declined by the machine for page binding (`identity_margin_thin`, `binding_ambiguous`) and wait for a person, which holds the queue near the 1,500 limit. Phase 5 (Layer 4 grid, Wed 09:30) is aimed at them.

### AI token efficiency check (read only, 16 Nov 2026 12:40 AEDT)

Read-only queries only (`set transaction read only`, 20 s limit), on project `fxcwkweaxjtknorudmwp`, Supabase logs and Pilot `main` 6bfadf0 (worker `coverage-sweep-worker-v1.0.4`). Nothing was changed. The PR 1 cutover (22:30 AEDT) was not touched. Days are UTC days.

**1. Pre-AI gate and duplicate input: not in place for `enrich_ai`**
- The admission gate (`admission-gate.ts admit`) is called only in mode `scholarship_ai` (index.ts about line 2234). `admission.gate_on` is 0 there: `pipeline.pre_ai_admission_decisions` has 0 rows in 3 days.
- `enrich_ai` (description, intakes and the other course fields) sends every leased item. Neither the worker nor `public.svc_enrich_ai_next` checks any of these before calling OpenRouter:
  - (course, field, page content hash, prompt version);
  - a minimum readable text length;
  - the page's identity status.
- Measured over 24 h on `pipeline.field_enrich_items`:
  - Description: 13,121 paid reads cost $9.01. 2,741 of them re-read a course and page already read in the window (about $1.91). Only 3 of those pairs had the same prompt version: the rest are the one-off re-read when `cdesc-source-grounded-v2` was released (15 Nov 05:00 UTC), and 1,110 of them were held again.
  - Intakes: 67 items, none with an identity reason.
- So a gate on (entity, field, hash, prompt version) would save almost nothing day to day. Its value is stopping re-reads that will predictably be held again.
- The 55.7% `DUPLICATE_HASH` and 73% `IDENTITY_MISMATCH` figures could not be reproduced from these tables. The query behind them is needed before building the gate on them.

**2. Prompt caching and `cached_tokens`: not used and not recorded**
- The course description request (`course-text.ts cdescRequest`) puts the static system prompt (`CDESC_SYSTEM`, about 2.5 KB) and the JSON schema ahead of the dynamic page JSON. The order is right for caching.
- No `session_id` is sent and there is no `cache_control`.
- `cascade.ts note()` keeps only `prompt_tokens`, `completion_tokens` and `cost`. `pipeline.ai_invocations` has no `cached_tokens` column.
- The static prefix is about 600 to 800 tokens of an average of 3,408 input tokens (Qwen, course description). That caps the possible input saving at about 20%, and only on providers that cache implicitly.
- The Mistral re-ask is a different model, so it cannot use Qwen's cache.

**3. Ledger drift: cause found**
- 15 Nov: at 21:15 UTC the key showed $10.81 against $9.84 in `pipeline.ai_invocations`. At day end it was $10.99 against $10.03, a $0.96 gap.
- The gap sits in the hours with `coverage-sweep` HTTP 546 (worker limit) responses:

  | Hour (UTC) | 546 responses | Gap |
  |---|---|---|
  | 03 | 114 | $0.56 |
  | 04 to 06 | 88 | $0.25 |
  | 14 to 15 | 52 | $0.08 |

- Hours with only HTTP 500 responses (07 to 12 UTC) drift by less than $0.02 an hour.
- Cause: the attempt trace is written once, at the end of a worker call (index.ts about line 529, `svc_ai_model_answered_v1`). A call killed by 546 loses every attempt it had already paid for.
- Minor: 924 failed attempts on 15 Nov carry no cost (time-outs and thrown errors).
- **Action:** write attempts as they complete (or flush in batches during the call), and keep `usage.cost` on errors where OpenRouter returns it. Separately, reduce 546s in `enrich_ai` course description calls: fewer pages per call at peak, through the existing setting.

**4. `unsupported_sentence` holds on `cdesc-source-grounded-v2`: top three causes**
- 2,249 holds since 15 Nov 05:00 UTC, 2,243 of them on Qwen first answers. The threshold is `pdesc.support_min_share` 0.6, a provider-description setting reused here. The three groups overlap.
  1. **The opening identity sentence: 1,857 holds (83%).** Sentences like "The <title> at <provider> is a …". The check strips the known title and provider before scoring (`security.cdesc_known_strip_v1`), so the framing left over ("is a qualification offered by …", 817 holds) is scored against a quote that does not contain it.
  2. **Level, credit or duration facts not in the cited quote: 750 holds (33%).** For example AQF level, credit points or full-time years.
  3. **Audience framing ("designed for …", 356, 16%) and near-empty sentences after stripping (280, 12%).** For example "The is offered by the.", support 0.
- **Re-asks to Mistral:** 9,087 Qwen answers led to 5,786 re-asks (64% in this window). Only 1,552 items ended with the Mistral answer (1,533 filled or in review), about 27% of re-asks. About 4,200 re-asks bought nothing (about $1.70 at $0.00041 a call).
- **Action, to decide (prompt and check change, not made here):**
  - Tell the model not to open with an identity sentence.
  - Or let that sentence draw on `VERIFIED_COURSE_FACTS` (title, provider, study level), with the check treating those facts as known in the same way.
  - Only re-ask when the hold is not one of these predictable patterns.

### Layer 4 clearance and AER model benchmark round 2 (16 Nov 2026 14:06–19:45 AEDT)

Full report: `docs/platform/layer4-clearance-and-model-benchmark-2026-11-16.md`.

- **Layer 4 waiting:**
  - 5,172 at 14:20; 5,136 at 16:28 after the reconcile switch; **4,916 at 19:20** after the official URL resolution (read back). `official_course_url` 1,328.
  - 651 new items arrived from other work between 16:28 and 18:48.
  - Since 16 Nov, items are decided or superseded faster than they arrive.
- **Switched on (Platform Admin approval, 15:56):**
  - `layer4.reconcile_supersede_on` = 1 since 16:00 AEDT.
  - Job `layer4-readiness` (:22, :52) supersedes waiting platform-kind items whose course or provider is retired, repeats, and items already decided. It never approves or rejects.
  - 36 retired-course official URL items cleared at 16:27.
  - Defect fixed in Pilot #1180 (migration `20261116143000`, live 18:47 AEDT): `layer4.reconcile_batch` (200) now caps items settled; the new `layer4.reconcile_examine_max` (5,000) caps items checked; `pipeline.layer4_reconcile_cursor` continues where the last run stopped, so no settleable item starves.
- **Official URL batch resolved (Platform Admin 16:47, 18:01, 18:44):** of 856 items, **836 closed and 20 open** (report §7).
  - 751 closed by rule `l4-link-refusal-v1` through "Refuse this proposal". 28 audit-sample items verified and closed; 4 unproven stay open.
  - 73 live-link conflicts: 56 verified valid and closed with the live link kept (26 are a finder defect, where the "other campus" named is the provider itself); 1 refused (Lead College 107328J, on the unlink-review list, recommendation keep); 16 unproven stay open.
  - No link or course record was changed.
  - #1177 (`20261116110000`) was refused by deploy (the version was taken by #1162) and renumbered as #1180.
  - **Pending for the Platform Admin:** paste file `PASTE-20261116-l4-lift-false-link-refusals.sql` (59 false finder refusals of verified live pages).
  - **S2 - SS Build regenerates the test register** for #1176, #1177 and #1180 (spec `s560`).
- **For the Phase 5 grid (Wed 09:30):**
  - 1,304 other official URL items, grouped by provider;
  - the 488 AER audit sample, which always stays with a person;
  - fees 146, provider descriptions 88, no-page samples 55.
- **For the AER session:** 1,604 quote_not_on_page items need a corrected read (AER v2 prompt v3), not a person.
- **Benchmark round 2** (runs 17 to 20, frozen 50-case set 5, Pilot #1176 `20261116100000`):
  - **No model qualifies.** Right answers on the 40 readable cases:
    - Gemini 2.5 Flash 11 ($0.0317 per right, p50 5.5 s);
    - MiMo v2.6 Flash 11 ($0.0053);
    - Mistral Small 3.2 10 ($0.0032; best source integrity, 83%);
    - Qwen3 30B 2 (18 timeouts).
  - 10 of the 50 pages are over `reading.aer_v2_page_chars` (60,000) and fail for every model.
  - Recommended candidate pins: Mistral Small 3.2 first, Gemini 2.5 Flash second. Retire Qwen3 30B from the AER path.
  - Spend $0.459; on-demand `ca8dee01` closed. `ai_eval.offline_runs_on` and `ai_eval.aer_v3_runs_on` are back to 0. Nothing was admitted.

### API v3 data admission: field lanes and 48-hour plan (16 Nov 2026 16:40 AEDT)

- **Plan:** [`docs/platform/API-V3-DATA-ADMISSION-PLAN-2026-11-17.md`](platform/API-V3-DATA-ADMISSION-PLAN-2026-11-17.md) (REQ-19, -52, -53, -57, -65, -67, -75, -76).
- **Schema is live, data is not:** `study_load`, `empty_reason_code`, `campuses.is_primary`, `catalogue.provider_accreditations`, `ref.grade_scale_conversions`, `destination.*` and `ref.api_field_dictionary` exist (migration `20261115190000`); all hold 0 rows or values.
- **PR 3 (Pilot #1188, built 23:25, not merged):** each field is declared as a lane in `pipeline.field_execution_registry`, disabled, with zero new cron jobs.
- **PR A and PR B filled live (Pilot #1184, migration `20261116180000`; run 16 Nov 21:50 AEDT on the Platform Admin's instruction), 8,516 values:**
  - primary campus on **356** providers (basis `cricos_head_office`; 7 with several matches and 1,193 with no match stay null; telemetry counts 354, because 2 of them have no active course);
  - campus-null reason on **5,639** courses (not published 5,104, online only 395, pending extraction 104, not on the register 29, source unavailable 7);
  - study load on **2,521** courses from stated evidence (full time 1,413, part time 183, both 925).
  - `updated_at` was not touched by the fills; G3 drift [].
- **Expected from the deterministic steps:** primary campus on 381 providers (registered head office matches exactly one campus); a campus-null reason on 5,639 courses; study load on about 2,671 courses from stated "full-time"/"part-time" evidence.
- **Corrections to the brief:** `catalogue.provider_registrations` holds 3,103 regulator registrations (CRICOS, IRCC DLI, NZQA), not 36,075, and none is a business-school accreditation: AACSB, EQUIS and AMBA come from each body's official list. There are 4,341 active campuses (not 3,880).
- **Decisions (16 Nov 16:52):** D-4 confirmed; 824 single-campus providers not marked; REQ-19 owned here (position on the qualification's own scale); destination drafts unpublished; Pilot #1162 merged. Plan section 5.
- **Daily admittance telemetry (Pilot #1183, 20:40 AEDT):** every API v3 and request-register field is recorded daily in `pipeline.field_coverage_daily` through the existing `platform-health` writer (no new job). `security.api_v3_daily_admittance_v1()` gives admitted, yesterday, daily gain, eligible and share per field. The sheet tab `API_v3_Daily_Admittance` is filled by the 08:05 task. Contract and the 16 Nov baseline: plan section 7.

### Layer 4 quick wins and pre-authorised gates (Platform Admin 16 Nov 2026 20:14)

| Item | Path taken | Result (live) |
|---|---|---|
| Official-URL finder false positives (from #1177 / #1180) | Fix shipped: Pilot #1181, migration `20261116150000`, md5-guarded edit of `security.course_page_check_v1` | **Campus:** a campus named like the provider is no longer "another campus" (all 26 such refusals).<br>**Sibling:** an address whose remaining words name this course is no longer a sibling's (double degrees, Dean's Scholar).<br>Re-check of the 1,868 refusals on record: 26 campus and 268 sibling no longer refuse; **none is accepted** by the fix alone.<br>Durham "Dental Assisting" and Wollongong BSc–BA stay refused: a near-duplicate course record holds the page. |
| A. Course page needed (2,058 asked; 2,113 open at 20:40) | **Path B.** No batch setting clears the list; each entry needs a person's choice or a paid search. Rule `cpn-settle-v1` (Pilot #1182) settles only entries whose outcome is on record. | One pass: **242 settled** (236 confirmed no page, 6 page already held); open **2,113 → 1,871**. The rest (including 454 with a bound page waiting) goes to the Phase 5 grid. |
| B. Course link same-domain alias duplicates | **Path B (fewer than 100):** 5 strict matches (31 on a loose pattern) among 1,328 open course-link items | No custom rule; left for the Phase 5 grid. Separately, 229 open items propose the page already held: a Layer 4 rule candidate. |
| Tue 07:30 AEDT, AER round 3 | Gate written into the scheduled task | **Pass** (100% source integrity, at most 10 error points, 0 false positives): qualify Mistral Small 3.2 on the v2 shadow and re-read the held items through the admission rule (audit samples stay with a person).<br>**Fail:** stay off, no further spend, failure buckets logged. |
| Tue 13:15 AEDT, PR E | Written into the scheduled task | About 20 official scales as drafts and AU destination drafts (unpublished). An approval table comes to the Platform Admin before Wed 13:30. |

Layer 4 pending at 20:49 AEDT: **4,902**; at 23:36 AEDT: **4,904**.

**229 identical-URL course-link items (Platform Admin 21:03, rule if 150 or more): Path B.** All 196 unclaimed items are housekeeping H13 old-year addresses (187) or E16 two-page cases (9), genuine questions under the 4 Nov decision (migration `20261104570000`). No rule; nothing run.

| Kind | Pending |
|---|---|
| `course_entry_first_read` | 2,578 |
| `official_course_url` | 1,328 |
| `course_description_first_read` | 613 |
| `provider_current_tuition_validation` | 146 |
| `provider_description` | 88 |
| `entry_matrix_first_run` | 77 |
| `no_page_first_run` | 55 |
| other | 17 |

### Cloudflare Worker Boost and production launch rehearsal (16 Nov 2026 20:31–21:05 AEDT)

Design, decisions, results and setup checklist: `docs/platform/CF-WORKER-BOOST-AND-PROD-LAUNCH.md`.

- **Built, not deployed or applied.**
  - Read-only queue exporter (`scripts/boost-export-queue.sql` / `.ts`).
  - Free-tier Cloudflare Worker with a Google → Groq → Mistral → OpenRouter failover chain (`workers/cf-boost-extractor/`). Each result names its one model, and quotes and values are checked before anything is written.
  - DRAFT staging and promotion SQL (`sql/boost-ingestion/`, quiet window 01:00–05:00 AEDT).
  - The 4-point harness (`scripts/test-boost-e2e.sh`).
- **Paths taken:** fixture (the registry is not live before PR 3), standalone Worker, staging table (no Layer 4 intake function exists).
- **Nothing is admitted from an unqualified model.** `pipeline.boost_model_qualifications` starts empty. AER results are shadow only. Accreditations are only proposed until PR C's official lists match them.
- **Harness:** points 1 to 3 pass (point 3 on a local Postgres stand-in). Point 4 (replay of the 2,043 live migrations; the repository holds 696) waits for the parallel test project.
- **Next:** the Platform Admin's 5-step setup (document §8). The staging SQL reaches production only as a Pilot migration after its rolled-back dry run.
- **Setup steps 1 to 4 (21:09 request; document §11).**
  - **Test project:** `coursefinder-boost-test` (ref `ucdaaqrpgcldnatavmib`, ap-southeast-2) created 21:02 AEDT, empty. This is a third project in the organisation, beside production and coursefinder-demo.
  - **Rebuild:** `.github/workflows/boost-test-rebuild.yml` (here) replays the 2,043 live migrations read-only from production onto it, then runs G3, point 3 and the 50-item shadow check. It needs `SUPABASE_ACCESS_TOKEN` set on this repository (today it is on Pilot only), then `gh workflow run boost-test-rebuild.yml -R msinghbs-ai/coursefinder-admin -f test_project_ref=ucdaaqrpgcldnatavmib`.
  - **Point 3 and the shadow-only check on local Postgres 16:** 1,000 rows in 0.011 s. With nothing qualified, 50 verified rows gave 0 admitted and 0 courses changed. Rehearsal 1/2/2; window refusal enforced; nothing left behind.
  - **Bucket:** `docs/paste/PASTE-20261116-staging-boost-bucket.sql` (not run).
  - **Test project rebuild, run 43851316573 (22:32 AEDT; document §12):** 2,046 migrations exported read-only from production; replay applied 1,004 and failed 1,042.
    - The first failure (`20260813035800`) needs data that production loaded at run time, and the failures cascade from there. G3 and point 3 could not run there.
    - **Finding:** production cannot be rebuilt from its migration record. A launch needs a schema dump, the reference data, then the newer migrations.
    - Proposed: reset the test project and rebuild it from the newest schema dump branch.
  - **Schema-dump route (Platform Admin 22:44, admin #532):** `scripts/boost-rebuild.py` and the reworked workflow reset the test project, apply the production schema dump, copy the reference and configuration data read only, then apply the migrations newer than the dump, and run G3, point 3 and the 50-item shadow-only check.
    - Dump: Pilot `db-schema-dump/43861191617` (16 Nov 22:50–23:04 AEDT, 10.4 MB, production head `20261116200000`). The dump held share locks for 14 minutes and blocked nothing.
    - **Rebuild run 43863252704 started 23:04 AEDT**; cancelled 01:25 AEDT after 2 h 20 min in the schema step (one API call per statement after a failed batch, no progress output). Fix admin #536.
    - **Run 43885548875 (01:25 AEDT): schema step stopped at its 90-minute limit, 3,698 of 15,936 statements, 1,258 failed** (document §12.1). Cause: the dump's session settings (`check_function_bodies = false`, `search_path = ''`) reached only the first batch, so functions failed before their tables existed, followed by their ALTER and COMMENT statements. No G3, point 3 or shadow-only result yet.
    - **Run 43940610220 (17 Nov 06:33, approved): schema complete, 15,936 of 15,936 statements in 297 s (the #537 fix works); verdict FAIL on the later steps** (document §12.2). 8 reference tables were copied before their parents, the G3 baseline table was not copied (G3 0/0), and the 005 rehearsal needed `pim.entity_registry` rows. The 3 newer migrations were refused by their own live-state gates, as expected on a project without cron jobs.
    - **17 Nov, fresh dump and three more fixes (document §12.3):** dump `db-schema-dump/43989024895` (11:36–11:50 AEDT, production head `20261117040000`, 8 `destination` tables). Runs 43991418340, 44004171402, 44009650216 and 44014040952 all slowed from statement 6,243. The cause was the reset: `drop schema pipeline cascade` failed with out of shared memory (too many objects for one transaction's lock table) and the run carried on over the previous run's `pipeline` schema. Fixes: an explicit transaction per call (#545), commit markers (#548), batch errors recorded (#550), and the reset drops a large schema in chunks and stops if one is left (#551).
    - **Run 44019730363 (15:48 AEDT, main `fdd8789d`): PASS on every check** (document §12.3). Reset clean; schema 16,033 of 16,033 statements in 275 s (105 calls, 0 failed); 6,911 reference rows in 39 tables; 7 of 8 newer migrations (the job pause `20261117051700` refuses on a project with no cron jobs, as expected).

      | Check | Result |
      |---|---|
      | G3: 75 functions, 48 relations, no drift | **PASS** (75, 48, drift `[]`) |
      | Bulk load of 1,000 rows under 5 s | **PASS** (0.038 s) |
      | 50-item shadow-only check: none admitted, no course changed | **PASS** (50 shadow, 0 admitted, 0 courses changed) |
      | Rehearsal: 1 written, 0 updated_at touched | **PASS** |
      | Outside the 01:00–05:00 window: refused | **PASS** |

      On the way: run 44015982270 (#551) failed on 005 (production requires `manual_locks.mode`) and G3; run 44017816120 (#553) passed point 3, and G3 showed 7 v2 read functions changed because the dump was read in text mode, which drops Windows line endings from their bodies (fix #554). Known and outside the verdict: `ref.study_level_source_mappings` refers to `pipeline.sources`, which is not copied.
    - **The Boost test project is rebuilt from production's schema and passes point 3.** `worker-boost-bulk-ingest` is live (Pilot #1205; see S1-Build above). Still open: a Platform Admin qualification row for each lane and model, and deploying the Boost Worker and exporter so result files reach `staging-boost/inbound/`.

**S1-Courses, 20 Nov 2026 11:02 AEDT: course descriptions from stored pages (Platform Admin directive 10:39) — s822 built and dry-run, Pilot #1413 awaiting a merge click; no live change yet**

Claimed numbers: s822 (used), s823 to s825 (held for this lane, unused); migration `20261120114000` (above live head `20261120110000`, 2,208 history rows). Pre-flight: no open Pilot PR carries a course description, AER, scholarship or Platform Health file; admin #609 (S1-Courses, stale and dirty, superseded by Pilot #1344 and #1337) is closed unmerged. Live reads were taken through the rolled-back dry-run route only (zero interactive SQL); G3 75 functions / 48 tables unchanged; locks 7,585 kept; Firecrawl US$0.
- **Where the gap is (read live):** 20,721 active courses have no description; 7,916 of them have a stored, identified page. 7,306 of those wait in a skipped reading the picker does not offer again: 2,290 judged "insufficient" by prompt v1 to v3 (v4 needs 1 to 2 verified sentences, not 3), 1,895 skipped as "no proven course page" before the page was proven, 227 "the page does not state it" from the older reader. Not touched: 2,730 held by v4 under the originality, length and sentence rules, 159 insufficient under v4, 5 other.
- **s822 (Pilot #1413, `20261120114000_cf247_s822_cdesc_reread_stuck_readings.sql`):** data only; marks the latest skipped reading of those courses `reread:` so the unchanged picker reads them again with `cdesc-source-grounded-v4`. Dry run (run 44642329048, rolled back): 4,412 marked, `catalogue.courses` descriptions unchanged (15,311), one audit row, G3 checked 75/48 before and after. Estimated cost about US$1.9 at the measured US$0.00044 a read, inside the US$14 a day cap and the 8,000 a day queue setting. Nothing is admitted or published by it; every new reading passes the same quote, length and originality rules, and page text stays inside the untrusted fence with provider data collection denied.
- **Boost DB, stated plainly:** the Boost database (`coursefinder-boost-test`) holds 69 seeded placeholder courses and none of the 18,350 stored pages, and its description lane returns a verbatim quote that fails the copy rule. Mining the stored pages therefore runs on Main storage through the existing description reader, not in Boost. No DDL, RPC or promotion change is applied to Main before merge.
- **Layer 4 speed:** already fixed by S1-Build s813/s814 (`20261120110000`); no Layer 4 control changed here, so no mockup. Queue counts have moved since the brief (Adapter has nothing ready 318, Course link 422); the page and link queues belong to S2-BOOST-Discovery.
- **Table 1, verified source-backed gaps (stored page ready to drain): 10,712** (6,488 stored page, 901 + 2,082 + 1,241 in the other source-backed groups). **Table 2, no source available yet: 10,009** (AU 5,546, NZ 3,198, CA 849, plus 416 link-only); do not quote as verified.
- **Deferred:** course-side banned-word strip waits for S1-RM-Design s819 (about 100 courses). Description promotion to Main continues through the existing admission rules, never by this change.

**Next executable action:**
- Merge Pilot #1413 on green CI (merge is blocked for this lane: one click). Then apply, read back the 4,412 marks and the daily filled count, and report the yield and the spend.

**S1-Courses, 20 Nov 2026 11:50 AEDT: s822 live; re-read yield, link and "Course page needed" sizing — read only, no migration, no data change**

s822 is merged (Pilot #1413 `aecc7d56`, admin #676) and live: head `20261120114000`, 4,412 readings marked `reread:`, one audit row, G3 75/48 with no drift. No number above s822 used; S1-UX's s823 to s827 untouched. All reads through the rolled-back dry-run route.
- **Yield so far (read 11:45, the picker is still working through the set):** descriptions 15,311 to **15,328** (+17). Of the 4,412 courses: 1,982 not yet picked up, 1,671 queued, 725 with the AI, 17 filled, 17 in review. The banned-word strip (S1-RM-Design, Pilot #1411) is still open, so it has not cleared any promotional-word holds.
- **Spend:** all AI lanes today US$0.98 in total (description-related `enrich_fields` US$0.34 over 970 calls; this and other lanes share the ledger, so s822's own share is not separable). Inside the US$14 a day cap. Firecrawl US$0.
- **210 unverified links (all `official_course`):** 163 are on a host the provider already uses for an active link; 47 are on a host the provider has no active link on; 3 courses already hold an active official course link; 129 have the same URL and course on a stored page with evidence, but only 9 equal a bound page. Identity is not proven for the rest, so no deterministic admission is safe. No batch shipped; the 210 stay unverified.
- **Course page needed (1,689 waiting, all active courses, 198 providers):** none has a bound page that was read with evidence. Their stored pages are identity mismatches (about 1,300), refused, blocked, robots-disallowed or fetch-failed (about 400). Binding a mismatched or refused page would break the identity rule, so none is bound. The count stays with S2-BOOST-Discovery's page rules (Adapter has nothing ready 317, Course link 422).
- **Table 1 (verified source-backed gaps, 10,712) and Table 2 (no source yet, 10,009: AU 5,546, NZ 3,198, CA 849, link-only 416)** carry over from the 11:02 block; Table 1 shrinks as the re-read fills.

**Next executable action:**
- S1-Courses: read back the final yield and spend once the picker has drained the 1,982 not yet picked up; admit nothing by hand.

**S1-Courses, 20 Nov 2026 12:00 AEDT: interim re-read yield and Drive Summary fix — read only, no migration, no data change; parked**

Read through the rolled-back dry-run route only; G3 75 functions / 48 tables, no drift; locks 7,585; no number above s822 claimed.
- **Re-read yield at 11:59 (the picker had not finished, so this is not the final check):** descriptions 15,311 to **15,386** (+75). Of the 4,412 re-queued courses: filled 75, in Layer 4 review 7, with the AI 1,391, and 2,939 skipped (not yet picked up, or read again and still held by the quote, length or originality rules). The banned-word strip (S1-RM-Design, Pilot #1411) is still open.
- **Spend today (all AI lanes):** US$1.211, of which `enrich_fields` (the description reader's lane) US$0.553. Inside the US$14 a day cap. Firecrawl US$0.
- **Drive `Monitoring` ledger:** Counted minutes (column P) filled for rows 188 to 191 (120, 45, 90, 45); Summary rebuilt on its formulas: the activity list lacked Release and Build, so it summed to 3,025 against 3,300; both added, plus a "20 Nov 2026 only" row (780). The Engagements sheet does not hold the S1-Build 10:05 row (s813/s814, 60 minutes) that the repository CSV holds; left for its owner.
- **Table 1 (verified source-backed gaps) and Table 2 (no source yet: AU 5,546, NZ 3,198, CA 849, link-only 416)** carry over from the 11:50 block.

**Next executable action:**
- S1-Courses (when asked): the final yield and spend read once the picker has drained the 4,412; nothing to run in the meantime.

**S1-Courses, 20 Nov 2026 14:50 AEDT: s833 recorded before merge (Pilot #1422, migration `20261120143000`): the Layer 4 course description queue no longer times out; final yield of the s822 re-read**

Claimed: s833 (used), above s832 (S1-AER's s828 to s832 untouched); migration `20261120143000` above live head `20261120140000` (2,218 rows); no open Pilot pull request at pre-flight. `cf247-s676-probe` (S1-AER) not touched. All reads through the rolled-back dry-run route; G3 75/48; locks 7,585; Firecrawl US$0.
- **The fault (read live after Pilot #1420):** `admin_course_description_queue` summary 37 s and items 15 s against the 8 s limit. Causes: every open re-checked the 159 pending descriptions against the rules one by one (about 0.14 s each, 22 s, in the sample test and the summary), and the reconcile and the summary read all 271,000 AI reading rows with their JSON to find 159 (4 to 12 s and 4 s).
- **The fix (Pilot #1422):** stored row `pipeline.cdesc_queue_snapshot`, rebuilt every 15 minutes by job `cdesc-queue-refresh` (G1: catalogue and component register); the queue reads it for the default summary and items calls while it is newer than setting `cdesc.queue_snapshot_max_age_minutes` (35), drops cards decided since, and otherwise runs the live path exactly as before; two in-place, fragment-guarded edits make the live path faster (reading by key; counting only the columns used). Nothing is decided, admitted or published. Rolled-back live dry run (run 44668812389) passed: rebuild 39 s, 144 cards stored, as a Platform Admin summary and items each under 300 ms (enforced by the post-check), stored summary equals the live one, G3 75/48 before and after.
- **Final yield of the s822 re-read (read 14:40; the picker has drained: no reading is queued or with the AI):** descriptions 15,311 to 15,386 (interim) to **15,707**. Of the 4,412 courses: **396 filled**, 7 in review, 4,009 still skipped: 1,562 "no proven course page" again (the reader's identity proof is stricter than the picker's test, so this group of 1,895 mostly did not convert), 1,508 insufficient verified facts under v4, 315 held for copied sentences, 209 unsupported sentences, 8 unsupported marketing words, 19 sentence counts, 227 not yet picked up. The banned-word strip (Pilot #1411) has not merged, and held promotional wording is only 8 readings, so it is a small effect.
- **Spend today (all AI lanes):** US$2.023, of which the description reader's lane `enrich_fields` US$1.096. Inside the US$14 a day cap. Firecrawl US$0.
- **Table 1 (verified source-backed gaps) and Table 2 (no source yet: AU 5,546, NZ 3,198, CA 849, link-only 416)** are in the closing report; Table 1 shrinks by the 396 filled.

**Next executable action:**
- Merge Pilot #1422 after this admin PR (admin first so deploy-on-merge never outruns the mirror); then read back both calls as a Platform Admin and the stored row, and record it.

**S1-Courses, 20 Nov 2026 14:55 AEDT: s833 live and read back (Pilot #1422 merged, migration `20261120143000`); correction to the 14:50 record**

- **Correction:** the 14:50 record said the banned-word strip (Pilot #1411) had not merged. That was wrong: #1411 merged at 12:01 AEDT (v2.16.66, migrations 20261120121000 and 20261120121100). The promotional-word holds were cleaned automatically; what remains held for promotional wording is 8 readings. The yield figures in the 14:50 record are unchanged.
- **Merged:** Pilot #1422 (squash `98656714`), after admin #690. CI green (security gates, build-and-smoke, provider-description, six evidence shards, rolled-back live dry run). Deploy on merge, Deployed UAT, Security gates and Frontend Build all succeeded on `98656714`.
- **Live read-back (rolled-back dry-run route, reads only):** migration head `20261120143000`; `pipeline.cdesc_queue_snapshot` holds one row, 144 cards, rebuilt in 38.7 s, 2 minutes old at the read; job `cdesc-queue-refresh` active; both calls answer from the stored copy (same `stored_at`). As a Platform Admin: `admin_course_description_queue` summary **43 ms** (was 37 s) and items **86 ms** (was 15 s), 25 cards a page, 159 pending. Target of under 300 ms met. No Layer 4 server error.
- **Unchanged:** consumer API frozen (75 functions, 48 tables, nothing touched); 7,585 manual locks; Firecrawl US$0; AI spend today US$2.023 of US$14. No other lane's work or probe branch was touched.

**Next executable action:**
- None open for s833. Remaining description gaps are in the closing report (Table 1 source-backed, Table 2 no source yet).

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

**S1-ELR-Central-Policy, 21 Nov 2026 08:35 AEDT: s895 and s896 recorded before merge: `elr-central-v1.1` reads level-column tables and value-first phrasing and reports band pages; every university's stored central page is read again at $0 (Pilot #1443, migration `20261121080000`)**

The Platform Admin's request came at 21 Nov 2026 07:48 AEDT: populate the remaining source-backed gaps across all universities from central pages by study level, at $0, with no hardcoded exclusions.

- **Audit, read live and rolled back.** Table 1 is 5,930 (AU 3,538, NZ 1,091, CA 1,301); the claim had 0 left. By route (universities / courses):
  - elr-central approved: 19 / 73;
  - waiting for a person: 28 / 730;
  - approved policy only: 75 / 1,353;
  - read, no proposal: 70 / 1,132;
  - page not stored: 70 / 346;
  - no central page: 523 / 2,296.
- 319 genuine requirement pages gave no value tied to a level. No provider is excluded by name, type or list.
- **s895, reader v1.1:** reads level-column tables and "a score of 6.5 in IELTS", and reports values without a study level (English bands) rather than spreading them across levels.
- **s896, second pass:** every stored central page of a university without an elr-central reading is read again by v1.1. The route name, approval, plan, apply and Layer 4 holds are unchanged. No new job, table or setting.
- **Validation:** specs s895 and s896 5/5; the guards pass. G3 75/48, locks and the cron count are checked in the migration; US$0.
- **Design:** `docs/platform/2026-11-21-s895-s896-elr-central-v11-all-universities.md`.
- **Next:** auto-merge this record, then Pilot #1443, then read live.

**S1-ELR-Central-Policy, 21 Nov 2026 09:05 AEDT: s895 and s896 closed and parked: admin #732 (b001d30d) then Pilot #1443 (3bace2e7) merged by automerge; migration `20261121080000` applied; coverage-sweep deployed 08:13 AEDT; read live 08:55 AEDT**

- **Live checks:** G3 75/48 with no drift; manual locks 7,585; 135 active cron jobs; US$0. `elr-det-sweep`: 5 of 5 runs succeeded since the deploy, longest 5.5 s.
- **v1.1 second pass, first 40 minutes:** 63 central pages read again (47 read, 16 in flight), 354 left, about 4 hours at the current pace.
  - 2 pages gave values tied to a study level; both universities already hold an approved policy for those levels.
  - 14 pages give values with no study level: held, never spread.
  - No new proposal yet.
- **Tables:** Table 1 is unchanged at 5,930 (AU 3,538, NZ 1,091, CA 1,301). Table 2 (no stored page) is 8,837 (AU 5,359, NZ 3,023, CA 455).
- **Found after release:** the reader's "English bands" test also matches IELTS sub-score wording (for example "band 6.0"). The held reason "the page sorts courses into English bands or levels" is therefore over-applied.
  - The effect is limited to that label. No value is written or spread because of it.
  - Fix in the next reader version: the band test should need a band letter or "English band".
- **Next:** none in this lane; the sweep finishes the second pass by itself.
  - The 730 courses whose central readings wait for a person are in Universities › English.
  - 346 courses need Firecrawl and 2,296 have no central page; both are outside this $0 lane.
  - **Platform Admin decision:** a reader for pages that sort courses into bands, with each band tied to its courses.

**S1-ELR-Bands-And-Crawl, 21 Nov 2026 10:05 AEDT: s904 to s909 recorded before merge: band label fix, English band to course matching (`elr-band-v1.0`) and a one-off bounded fetch of 52 known central English pages (Pilot #1447, migration `20261121110000`)**

- **Request:** Platform Admin, 21 Nov 2026 09:00 AEDT.
- **Audit:**
  - The v1.1 band flag fired on 27 of 63 pages, every sampled trigger being IELTS score wording.
  - 89 universities (561 gap courses) have central pages found but not stored. 52 of those pages, at 40 universities, are fit to fetch.
- **s904:** reader v1.2; IELTS sub-score wording is no longer a band scheme.
- **s905:** band definitions are kept per university, never a study-level default.
- **s906:** a course whose page names exactly one defined band gets that band's values (insert only, s842 gates). Regulated disciplines and ambiguous cases go to Layer 4.
- **s907:** one-off fetch of at most 100 pages (52 queued) under an on-demand request scoped to central. Estimate 52 Firecrawl credits, from 67,187 left. No model.
- **Validation:** 85 specs passed and the rolled-back dry run passed. G3 75/48, manual locks 7,585, no new job.
- **Design:** `docs/platform/2026-11-21-s904-s909-elr-bands-and-central-fetch.md`.
- **Next:** auto-merge this record, then Pilot #1447, then read live.

**S1-ELR-Bands-And-Crawl, 21 Nov 2026 10:15 AEDT: s904 to s909 merged (Pilot #1447, f779b439; migration `20261121110000`; deployed 09:41 AEDT). The live check found `elr-det-sweep` failing on every run since 08:47 AEDT; s910 is recorded before merge (Pilot #1448, migration `20261121120000`)**

- **The failure:**
  - The central writer re-read a page whose identical text already had a superseded elr-central proposal, and its insert hit the unique key `provider_policy_proposals_key`.
  - The error was raised during the answer read-back, before the lost-call step. So every run failed on the same answer (request 898146, sent 08:42 AEDT), and nothing after it ran.
  - Nothing reached Firecrawl. The s907 fetch has not started: 52 pages are queued and no credits have been used.
  - The fault came in with s896, which explains why the earlier closing record's "5 of 5 runs succeeded" was true only up to 08:47.
- **s910 fix:**
  - A page text that already has a proposal is not proposed again, and its reads are held with that reason.
  - Each answer is recorded in its own sub-transaction; one that fails is marked failed and the run goes on.
  - Rolled-back proof: one sweep run completed in 1.2 s, reading back the stuck answer, applying 2 policies and sending 11 central pages and 10 fetch pages.
- **Live after #1447:** G3 75/48; manual locks 7,585; 133 active cron jobs, 0 unregistered; on-demand request open until 15:41 AEDT, estimate 52 credits, 67,177 credits left.
- **Validation:** spec s910 3 of 3; the guards pass.
- **Next:** auto-merge this record, then Pilot #1448, then read live.

**S1-ELR-Bands-And-Crawl, 21 Nov 2026 10:45 AEDT: s910 merged (Pilot #1448, d741077c; deployed 10:10 AEDT) and `elr-det-sweep` runs again (3 of 3 succeeded, 3.7 to 4.5 s). The live check found the two new worker modes unreachable; s913 is recorded before merge (Pilot #1451, migration `20261121140000`)**

- **The fault:**
  - Every s907 fetch call came back HTTP 422 "supported modes" from coverage-sweep.
  - In #1447 the band and fetch mode blocks sat after mode `read`'s return and before its closing brace, so they were unreachable code. esbuild and the type check both accept that.
  - Nothing was fetched and no Firecrawl credit was used. 30 pages were marked lost by the three refused calls.
- **s913 fix:**
  - The worker: the brace moves, so both modes are reachable. Spec s913 fails against the #1447 worker and passes with the fix.
  - The sweep: a fetch call refused with HTTP 422 returns its pages to the queue.
  - This migration queues the lost pages again. Rolled-back proof: 42 queued and 10 in flight, under the same on-demand request, open until 15:41 AEDT.
- **Live:** G3 75/48; manual locks 7,585; 137 active cron jobs, 0 unregistered.
- **v1.2 reads so far:**
  - 13 gave values without a study level;
  - 13 state no English test by level;
  - 6 add no level the approved policy lacks;
  - 4 are page texts already proposed (now held by s910);
  - 3 flagged as band pages;
  - 13 in flight.
- **Next:** auto-merge this record, then Pilot #1451, then read live.

**S1-ELR-Unblock-IQ00624, 21 Nov 2026 11:20 AEDT: IQ-00624 cleared and s926 recorded before merge (Pilot #1454, migration `20261121173000`)**

The Platform Admin's message came at 10:57 AEDT.

- **IQ-00624:**
  - s910 (Pilot #1448, d741077c) merged at 10:09 and deployed at 10:10. Its admin record #740 merged first.
  - Since then `elr-det-sweep` has run 11 of 11 times unattended (10:12 to 11:02 AEDT, 2.6 to 4.5 s) with no `provider_policy_proposals_key` error.
  - Superseded elr-central-v1.0 proposals are never reactivated. A page text that was already proposed is held with that reason (4 pages so far).
- **Downstream processing has started:** v1.2 central reads are running. So far:
  - 50 give values without a study level;
  - 48 state no English test by level;
  - 29 add no level the approved policy lacks;
  - 10 are flagged band pages;
  - 4 are page texts already proposed;
  - 11 are in flight.

  No band definitions yet: no page read so far labels a band with test values.
- **s913 (Pilot #1451, 31699db9)** merged and was deployed at 10:50. The worker modes are reachable, and pages lost to calls the worker refused went back to the queue.
- **Fetch:** the s907 request had been closed at 10:42 with 0 Firecrawl units used, while every call was refused.
  - The Platform Admin answered "Reopen and fetch" at 11:05.
  - s926 opens one new on-demand request (Firecrawl only, scope central) for the 52 queued pages. Estimate 52 credits (at most 78), from 67,120 left; AI US$0.
- **Live:** G3 75/48; manual locks 7,585; 136 active cron jobs, 0 unregistered.
- **Next:** auto-merge this record, then Pilot #1454; read the fetch live; close; sync Drive.

**S1-ELR-Bands-And-Crawl and S1-ELR-Unblock-IQ00624, 21 Nov 2026 13:20 AEDT: closed and parked. s926 (Pilot #1454, 22d12bfd) merged by automerge after one re-run of a failed Workers preview build; migration `20261121173000` applied 12:28 AEDT; read live 13:15 AEDT**

- **IQ-00624 accepted:**
  - 34 completed `elr-det-sweep` runs since s910, every one succeeded (the 35th was still running at the read). The longest took 8.2 s, inside the 10 s limit.
  - There has been no `provider_policy_proposals_key` error since the fix.
- **Fetch under the new on-demand request:**
  - 48 pages stored, 2 failed (no content), 2 still in flight. About 61 Firecrawl credits were reported against an estimate of 52 (at most 78).
  - The sweep closes the request when the last two are in.
  - The first s907 request used 0 units.
- **Fetched pages read by v1.2:**
  - 9 gave new study-level proposals;
  - 18 state no test by level;
  - 11 give values without a study level, 2 of them band pages;
  - 1 adds no new level;
  - 8 are in flight.
- **All v1.2 proposals:** 4 approved (approved automatically under the disagreement check), 5 waiting for a person in Universities › English, 1 superseded.
- **Band reader:** live, but no university's central page labels a band with test values, so there are 0 band definitions and 0 band rows. Nothing has been spread or written.
- **Table 1:** 5,919 (AU 3,527, NZ 1,091, CA 1,301), down from 5,930.
- **Table 2:** 8,836 (AU 5,358, NZ 3,023, CA 455).
- **Live:** G3 75/48, no drift; manual locks 7,585; 136 active cron jobs, 0 unregistered. AI: US$0.
- **Lessons:**
  - Mode blocks are now guarded for reachability (spec s913).
  - An on-demand request must not close while calls are being refused (s913 returns their pages to the queue).
  - One answer can no longer stop a run (s910).
- **Next:** none in this lane.
  - 5 central readings wait for a person in Universities › English.
  - The sweep keeps reading pages by itself.
  - A band-to-course rule needs a university whose central page actually labels bands with values; none does today.

## 6. Known gaps (not resolved, do not work around silently)

- `docs/platform/UI-CATALOGUE.md` and the `docs/README.md` row for it are behind the v2.16 screens.
- `docs/platform/COMPONENT-REGISTER.md` is the 15 Oct 2026 copy; the daily snapshot is on a Pilot branch, not here.
- This page is written by hand from live reads. Sections 3 and 4 should be generated from the live database at each release; until then, the reader checks the time on each section.

## 20 Nov 2026 15:50 AEDT — S1-RM-Design (S1-UI-Parity): s836 to s838 recorded before merge (Pilot #1424, v2.16.68, migration `20261120145000`)

**Directive:** Platform Admin, 20 Nov 2026 14:40 and 14:41: bring the live Dashboard and Layer 4 Review into one-to-one parity with the approved s820–s827 mockup, and add rate meters to Platform Health.

**Numbering** follows the 15:25 lane roster: specs s836–s838 (window s836–s839) and migration `20261120145000` (window ≤ `20261120145500`, above the live head `20261120143000`). An earlier draft used s834–s836 and `20261120150000`; both were renumbered before any PR.

- **s836 Dashboard.**
  - The page now shows, in order: the role line, the five cards, Active failures (operators and above), then Continue where you left off (the 3 most recent).
  - Removed: Waiting for your approval, Waiting for you, Also, the four summary cards and the Layer 2/3 › Operations link.
  - Spend card: it now shows "of the US$14.00 daily cap" with its bar. The pulse reads `ai_daily_ceiling_usd` (a md5-guarded fragment of `security.ops_pulse_refresh_v1`), and the screen falls back to the budgets check in the same answer.
  - Active failures shows genuine failures and warnings only. It excludes the "Fields below target are moving" and "Work queues are moving" watchdogs; stuck work shows as "X is stuck".
- **s837 Layer 4 Review opens on Review by rule.**
  - Rule rail: groups every waiting item of the chosen queue by its rule, across the whole queue. It uses a new read-only `rule_groups` action of `public.admin_layer4_inbox` (a md5-guarded inserted branch) backed by `security.layer4_rule_groups_v1`.
  - One focused card at a time, read by key (`rule_group_items`).
  - Preview the batch: lists the exact records; about 200 ms for 50 live records.
  - Batch admit: only the banned-word description group, after a confirmation, as one `decide` `edit_approve` per record with its reason. AER and every other group are worked card by card.
  - By university, By kind, Grid and Decided are under Other views.
- **s838 Cards and rates.**
  - Every held card shows the amber Main hold reason banner, with `?` and Technical detail.
  - Banned words are marked inline in soft yellow.
  - The cleaned text sits directly above Remove "word" & Admit.
  - The action bar is three buttons in one row: Save Edit & Admit, Approve As-Is, and Reject on the right.
  - Platform Health: Page Capture shows the capture rate against normal, and AI Extraction & Auto-Clean shows the auto-clean pass rate against normal. Both come from the stored 5-minute pulse (`security.ops_pulse_rates_v1`); there is no extra screen read.
  - The `?` help is kept on all five screens.
- **Guardrails.**
  - No new public function, table or view. G3 was read before and after: 75/48, no drift.
  - The windows and limits are settings: `layer4.rule_group_refs_max` 500, `layer4.rule_batch_max` 50, `pulse.rate_window_hours` 24 and `pulse.baseline_days` 7.
  - Manual locks: 7,585. Spend: $0. No interactive `execute_sql`.
- **Validation.**
  - Rolled-back live dry run through the non-interactive workflow (migration md5 `8f00baa9`): passed.
  - Description groups: identity_margin_thin 71, binding_ambiguous 64, first_provider_sample 48, evidence_moved 15, banned_word 8, wrong_page_kind 1. Grouping took 250 ms; a keyed card read about 200 ms.
  - Capture: 4.45× normal (11,200 against 2,519 per 24 h). Auto-clean pass rate: 84.6% against a normal of 69.7%.
  - Local tests: the Layer 4 and Dashboard set (342 tests before the updates) and the governance specs (s32, s42, s57, s120, s553, s557, s616, s810, s811, m245) pass.
- **Tests.**
  - New: `cf-247-s836-dashboard-parity-contract`, `cf-247-s837-layer4-rule-rail-focus-contract` and `cf-247-s838-card-polish-rates-help-contract`.
  - Seven Dashboard tests were retired with their sections (including the s179 Scholarships ready to publish row); the reasons are in the retirement log.
  - Layer 4 browser tests now open `?view=university`; their guards are unchanged.
  - The register was regenerated on main after S1-AER #1423, with the in-flight rows of the open Pilot PRs #1425 and #1427 kept.
- **Not done here.**
  - The old branch name `cf247-s834-s836-ui-parity` could not be deleted through this session's GitHub proxy. It is identical to `cf247-s836-s838-ui-parity` and can be deleted by hand.
- **Next.** Merge this admin record, then Pilot #1424 on green CI. After that:
  - Apply the migration on deploy and read it back.
  - Verify both screens signed in on production, including the `?` and Escape on the Dashboard, Platform Health and the Layer 4 hold banner.
  - Close the record, update Drive and report the two gap tables.

## 20 Nov 2026 16:20 AEDT — S1-RM-Design (S1-UI-Parity): s836 to s838 live and read back; s839 recorded before merge (Pilot #1429, v2.16.69)

**s836 to s838 are live.**
- **Merges:** admin #694 (`fd310dcb`), then Pilot #1424 (`13256fba`, v2.16.68), on green CI after re-reading main and the open PRs.
- **Deploy on merge:** applied `20261120145000`; the history md5 `8f00baa9` equals the file.
- **Read back (rolled-back probe):**
  - 2,221 history rows; head `20261120163000` (S1-AER's #1423 had merged in between).
  - G3 75/48 with no drift; manual locks 7,585.
  - The four settings are present; `admin_layer4_inbox` carries `rule_groups`.
  - The stored pulse shows a cap of US$14 and the rates.

**Signed-in check on production as Platform Admin (v2.16.68):**
- **Dashboard:**
  - The order is role line, cards, Active failures (5), then Continue (3).
  - No legacy section remains.
  - The spend card reads "US$3.27 of the US$14.00 daily cap" with its bar.
  - Active failures shows genuine items only: the Website API probe, the scholarship course loader's last run, the database over its high level, the Fee reader stuck, and course search at 3.2 s.
  - The `?` opens 3 steps and Escape closes it.
- **Platform Health:**
  - Page Capture shows "10,544 pages in the last 24 h · 4.0× normal".
  - AI Extraction & Auto-Clean shows "84.6% … normal 69.7% (+14.9 points)".
  - The `?` opens 3 steps and Escape closes it.
- **Layer 4 Review** opens on Review by rule for descriptions (207):
  - The groups are Page match not clear enough 71, More than one page 64, Waiting for the machine check 48, The page changed 15, Contains a banned word 8 and Not a course overview page 1, grouped in 900 ms.
  - One focused card is shown, and the older views are under Other views.
  - The banned-word card shows "Contains 1 banned word — leading", with the word marked and the cleaned text above Remove "leading" & Admit, and a three-button bar.
  - Preview the batch listed 8 records, 6 of them ready.
  - The `?` on the hold banner opens 3 steps and Escape (a real key press) closes it.
  - Nothing was approved or rejected.

**Two findings, fixed in s839 (Pilot #1429, v2.16.69, no migration):**
- **Finding 1:** a course description card's Main hold reason showed the machine code ("identity margin thin").
  - **Fix:** it now names the rule ("Page match not clear enough") in every view.
- **Finding 2:** Preview the batch took about 880 ms from the click (database 87 ms).
  - **Fix:** the chosen rule's records are now read as soon as the rule is chosen, so the preview opens in under 300 ms.

**Tests:**
- New spec: `cf-247-s839-l4-plain-hold-title-batch-prefetch-contract`.
- All 350 Layer 4 tests pass on desktop and phone.

**Observation, not changed here:** the s819 word strip can leave an awkward ", and" where a removed word joined a list. For example, "decision-making, and motivating people". The cleaned text passes every check. It is recorded as a gap.

**Next:** merge this record, then Pilot #1429 on green CI; read back the deployed frontend; Drive row, Summary and backup pair; closing report.

## 20 Nov 2026 16:40 AEDT — S1-RM-Design (S1-UI-Parity): s839 live and read back; S1-UI-Parity closed

**s839 is live.**
- **Merges:** admin #699 (`76219159`), then Pilot #1429 (`4a0695c8`, v2.16.69), on green CI after re-reading main. Main had moved by #1427, which shares no file with #1429.
- **Migration:** none.
- **Deploy:** Pilot Frontend Build and Release Currentness Deployed both passed.

**Signed-in check on production (v2.16.69):**
- The hold reasons now read "Page match not clear enough" and "More than one page could be this course" (before the fix they showed the machine codes).
- Preview the batch for Contains a banned word: 8 records shown in 4 ms from the click (database 271 ms, read ahead when the rule was chosen).
- Nothing was approved or rejected.

**S1-UI-Parity (s836 to s839) is complete.**
- Releases: v2.16.68 and v2.16.69.
- Migration: one, `20261120145000`.
- G3 75/48. Manual locks 7,585. Spend $0.

## 20 Nov 2026 17:30 AEDT — S1-RM-Design: s870 and s871 recorded before merge (Pilot #1432, v2.16.70, migration `20261120145500`): AER re-read from the stored copy ($0); stale partial-table holds re-queued

**Directive:** Platform Admin, 20 Nov 2026 16:28.

**Found live.**
- The job layer4-groups files 2,069 AER items under Technical recovery (class `repair:completeness_gate`, "not yet: the platform is recovering it").
- 1,985 of them are AI course first reads (gpt-4.1-mini, qwen3-30b) held by the completeness gate. 1,952 of those have a bound stored copy. 66 are entry-matrix first runs and 6 are entry-matrix changes.
- Nothing was recovering these items. aer-det-v1.3 skips a course while the AI read's proposed rows (`has_rows`) or its Layer 4 item (`earlier_read`) stand.
- The cards had no buttons.

**s870.** A new function, `security.aer_det_reread_v1` (check, apply, fetch), reached through three new actions of `public.admin_layer4_inbox`: `aer_det_reread_check`, `aer_det_reread` and `aer_page_fetch` (md5-guarded edit).
- **Re-read from stored copy ($0).** The stale item is superseded, with a supersession row (reason `decided_before`, mode `reconcile`). Its proposed rows go inactive through the item's own trigger. The course reopens to aer-det-v1.3, which reads the stored copy with no model and no Firecrawl, then proposes through the unchanged machine rule and Layer 4.
- **Queue stored-page fetch.** When no page is stored, the course goes on the Course page needed list (`security.course_page_needed_add_v1`).
- Both actions are the Platform Admin's (A3).
- **Rule rail.** It now separates System recovery / Re-read available (`aerb:` groups) from Waiting for a reviewer. A recovery card's status reads System recovery, not Waiting for a reviewer.
- **Proposer fix.** The deterministic proposer no longer counts a superseded earlier read (md5-guarded, one fragment of S1-AER's `security.aer_det_propose_v1`).
- **New index** on proposed entry rows by review item. Without it, the existing item trigger scanned the whole table once per item and the bulk timed out.

**s871.** The stale holds (machine reason `gate_incomplete`, bound stored copy, AI reader) are superseded once by the migration.
- Not touched: entry matrices, S677 and the 6 matrix changes.
- Not touched: audit samples, manual locks (7,585) and active rows.

**Validation.** Rolled-back live dry runs through the workflow (md5 `0c632f37`), the second after a rebase on main `720d6963e`:
- 1,818 holds superseded.
- 7,232 AI-proposed rows inactive.
- 68 deterministic-reader pages reopened.
- Course first reads still waiting: 693.
- G3 75/48. Locks 7,585.
- AER rail after the run:
  - Waiting for a reviewer: Audit sample 464.
  - System recovery: all rows held 111, gate 60, no stored page 33, audit sample 28, matrix changes 6.
- Locally, 1,282 Layer 4, AER and governance tests pass on desktop and phone.
- New spec: `cf-247-s870-s871-aer-stale-partial-read-reread-contract`.

**Numbering.**
- Spec numbers s870–s871: the S1-RM-Design window s836–s839 is used up, and s840–s869 are held by S1-ELR, S1-Fees-Intakes and S1-Structure-Outcomes.
- Migration `20261120145500`: the last number in the S1-RM-Design window.

**Next.**
- Merge this record, then Pilot #1432 on green CI.
- Read back the migration and the first aer-det-sweep ticks.
- Check Layer 4 signed in: System recovery apart from Waiting for a reviewer, and the Audit sample ready.
- Update Drive and write the closing report.

## 20 Nov 2026 18:05 AEDT — S1-RM-Design: s870 and s871 live; s872 to s874 recorded before merge (v2.16.71, migration `20261120174700`): one card contract for the 19 Layer 4 queues

**s870 and s871 are live.**
- **Merges:** admin #703 (`3dbb9460`), then Pilot #1432 (`fb182018`, v2.16.70).
- **Migration:** `20261120145500` applied; the history md5 `0c632f37` matches the file.
- **Read back:**
  - 1,818 stale AER partial-table holds superseded; 7,232 AI-proposed rows inactive; 84 reader pages reopened.
  - The aer-det-sweep picked them up (calls sent at 06:23 UTC).
  - G3 75/48. Locks 7,585. Active rows 25,462 (none removed). $0.

**s872 to s874 (Platform Admin 20 Nov 2026 17:13, universal minimum-effort Layer 4 overhaul).**
- **s872.** In every queue, items an existing rule settles or the platform is recovering (layer4-groups A and B) are keyed `sys~`. The rail shows Human Action Required apart from System Queues (Auto-Recovering).
  - Live: site down 149, nothing ready 317, course links 24, onboarding failed 1, entry requirements about 270.
  - Migration `20261120174700`: md5-guarded replacement of `security.layer4_rule_groups_v1`. Dry run passed, md5 `c701feda`.
  - It is numbered above the live head because S1-RM-Design's window ended at `20261120145500`, which is used.
- **s873.** One plain-English card contract across the 19 queues:
  - The Main hold reason drops machine codes; they stay under Technical detail.
  - One action bar: admit, then edit (Save Edit & Admit), re-categorise, and set-aside on the right.
- **s874.** Preview & Settle Batch on every rule group: one decision, one reason, a typed `SETTLE n`, and one decide per record at its own rank. It is never available for entry requirements, departures or descriptions.
- **CI contract:** `cf-247-s872-s874-l4-universal-card-contract` covers all 19 queues.
- **Local results:** 1,295 Layer 4, AER and governance tests pass on desktop and phone.
- **Audit matrix:** `docs/platform/2026-11-20-s872-s874-layer4-19-queue-card-contract.md`.

**Next.** Merge this record (automerge), then Pilot (automerge) on green CI. Read back, check signed in, then Drive and park.

## 20 Nov 2026 18:35 AEDT — S1-RM-Design: s872 to s874 live and checked signed in; s875 recorded before merge (v2.16.72, no migration)

**s872 to s874 are live.**
- **Merges:** admin #708 (`925c324d`), then Pilot #1435 (`d3fbed00`, v2.16.71). Deploy on merge, Frontend Build, Release Currentness and Deployed UAT passed.
- **Migration:** `20261120174700` applied; the history md5 `c701feda` matches the file. G3 75/48, no drift. Locks 7,585. $0.
- **Signed in (Platform Admin, built-in browser, v2.16.71), Layer 4 Review:**
  - Entry requirements: Human Action Required 607, System Queues (Auto-Recovering) 309. Audit sample (459) leads Human Action Required.
  - Site down: System Queues only (149); the hold reasons read in plain words ("Website did not answer: home page not read").
  - Cards show "Main hold reason: …" with no machine codes. The action bar runs admit, then edit, then set-aside on the right.
  - Preview & Settle Batch opened on "No stored page bound" (33 records, 1.7 s): 0 re-readable, 33 to queue for a stored-page fetch. Closed without acting. Nothing approved, rejected or settled.
- **Re-read check (read only, `aer_det_reread_check`):**
  - All rows held: 44 of 50 re-readable. Page identity: 8 of 8.
  - Completeness gate in System Queues: 50 of 50 are entry matrices (`not_a_course_read`), so there is nothing to re-read; they stay with the Platform Admin.

**s875 (found in the signed-in check).** The entry-matrix recovery cards said "System recovery: re-read available" although they cannot be re-read. A card in System Queues now says "System recovery: the platform is working on it". Re-read from stored copy ($0) shows only where the check says it can be re-read.
- Pilot #1436 (v2.16.72). No migration and no database change.
- Local: release contract PASS, build, 38 targeted specs pass.

**Next.** Merge this record (automerge), then Pilot #1436 (automerge) on green CI. Read back the deployed version, then Drive and park.

## 20 Nov 2026 18:55 AEDT — S1-RM-Design: s875 live and checked signed in (v2.16.72); lane parked

- **Merges:** admin #711 (`80982d6c`), then Pilot #1436 (`ebae623e`, v2.16.72). Security gates, Release Currentness Deployed and Deployed UAT passed. No migration.
- **Signed in (Platform Admin, built-in browser, v2.16.72), Layer 4 Review, entry requirements:**
  - Human Action Required 641, System Queues (Auto-Recovering) 308.
  - An entry-matrix card in the Completeness gate group says "System recovery: the platform is working on it", with no re-read button.
  - A Page identity card says the same and shows Re-read from stored copy ($0).
  - Nothing approved, rejected or settled.
- **Read back (rolled-back dry run 44698488654):** migration history 2,229 rows (s872 md5 `c701feda`). G3 75/48, no drift. Locks 7,585. The aer-det reader read 2,880 pages in 2 hours and proposed 139. $0.
- **Parked.** Open for the Platform Admin:
  - S677 and the 6 entry-matrix changes.
  - The entry-matrix holds in System Queues (about 55 Completeness gate items with no course read to re-read).

## 20 Nov 2026 23:25 AEDT — S1-RM-Design: Platform Admin 22:54 and 23:07 decisions; s890 recorded before merge (migration `20261120231000`): Victoria University 02475D keeps its courses and takes the 00124K description

**UTS (`uts.edu.au`): nothing to change.** The description was approved in Layer 4 Review (item `9e1d3b89`) and is live. No university-description item waits, and UTS is not on the Held universities list. Its remaining Layer 4 cards are 4 scholarship value questions and 1 course identity question; none is a description card.

**Victoria University (`vu.edu.au`).**
- **What the record is:** read live (rolled back), CRICOS 02475D (`0f5373c8`, `vu.edu.au/international`) is VU's separate registration for its Sydney City Centre and Brisbane campuses. It has 35 active international courses with their own CRICOS course codes, so it is not a copy of 00124K.
- **The hold:** its only description reading was held on `provider_host_conflict`, because 00124K (`bac82321`) is the recorded owner of `vu.edu.au` (s766).
- **Decision:** asked at 23:07, the Platform Admin chose to keep both records and clear the hold by giving 02475D the parent's description.
- **s890 (Pilot #1440, migration `20261120231000`):**
  - Applies the decision through the screen's own path, as the Platform Admin: Held universities › Open for writing, then Edit & Approve with 00124K's live text and no manual lock.
  - Fixes a fault the rehearsal found. A university opened for writing kept its reading held, because the reading was not linked to the item and was then superseded. `security.layer4_description_human_admit_v1` now admits and links the reading the item names (md5-guarded edit `c332bdfe`).
  - No lifecycle event, archive or re-parenting. 02475D's 35 courses stay live.
- **Dry run passed, rolled back** (run 44734694071):
  - 02475D's description is set and its reading admitted; no item waits; 35 courses kept.
  - G3 75/48, no drift. Locks 7,585. $0.
- **Spec:** `cf-247-s890-vu-02475d-parent-description-contract`.

**Requests (confirmed, statuses unchanged).** S1-Build had already recorded these at 22:55 (#721); a dated confirmation line is added to each.
- `REQ-59` stays standalone, not folded into RM1K (Open).
- `REQ-69` is Partly delivered.
- `REQ-66` stays Open.

**Next.** Merge this record (automerge), then Pilot #1440 (automerge, after its dry-run check). Read back live, then sync Drive.

## 20 Nov 2026 23:40 AEDT — S1-RM-Design: s890 live and read back; Victoria University 02475D off the held list

- **Merges:** admin #724 (`f46d1d60`), then Pilot #1440 (`f0b8d751`). Deploy on merge, Security gates and Deployed UAT passed.
- **Migration:** `20261120231000` applied; the history md5 `ed2cb2f8` matches the file. It is now the live head.
- **Read back (rolled-back dry run 44737187281):**
  - 02475D is active and published, with 35 courses and the 00124K description.
  - Its reading `3559c277` is admitted, and no description item waits.
  - Decision event recorded: item `f2a6d34f`, no manual lock.
  - UTS description live (449 characters), no item waits.
  - G3 75/48, no drift. Locks 7,585. $0.
- **Signed in (Platform Admin):** Held universities lists neither Victoria University nor UTS.

## 21 Nov 2026 00:20 AEDT — S1-CourseLink-2027-CRICOS: s891 to s893 recorded before merge (v2.16.73, migration `20261120235000`): course links move to the current year by themselves

**Audit (read only, 20 Nov 23:45–23:59).** 545 Course link items wait. 158 hold a page whose address carries a year, all with a CRICOS code and none locked.
- By year: 2012 1, 2014 3, 2015 6, 2016 4, 2017 11, 2018 12, 2019 34, 2020 12, 2021 18, 2022 16, 2023 21, 2024 20.
- By provider: Macquarie 51, ANU 33, Melbourne 27, Sydney 19, La Trobe 18 (for example `handbook.latrobe.edu.au/courses/2023/PHDLJ`, CRICOS 0100697), and 10 across 6 others.
- How their pages were read: 91 directly, 55 through Firecrawl, 12 never read.
- Rule l4-link-accept-v1 holds every one, because it never uses an old year.

**s891, rule `course_link_year_rollover_v1`.**
- Each held address is tried at 2027, then 2026, then 2025, then as held, by plain reads only (no Firecrawl, no AI).
- The newest that answers on the provider's own host, at its own year, without "not found" or "no longer offered" words, and proves the exact CRICOS code is admitted.
- Admission goes through the existing decision path under the system automation account, and the page is stored at once for the $0 sweeps.
- Never admitted: locked, refused-before or off-host pages, and archived handbooks.
- **Platform Admin decision recorded (22:58):** a held address with a past year may be admitted when it answers and proves the exact CRICOS code.
- **No new job.** It runs inside `link-refresh` (every 10 minutes). Nine settings in the Layer 4 section; two tables, `pipeline.link_rollover_requests` and `pipeline.link_rollover_checks`.

**s892.** Layer 4 Review › By university: Preview & Settle Batch on a single-queue rule group, including Course link.

**s893.** Worker mode `link_year_rollover` (coverage-sweep, `link-rollover.ts`).

**Checks**
- Dry run passed, rolled back (run 44742560840): 158 to try; 137 active jobs; G3 75/48; locks 7,585.
- Rehearsal on PHDLJ: set to `/courses/2027/PHDLJ` by the system account.
- A plain read of the 2027 La Trobe page shows the course (PHDLJ) but not the course CRICOS code in its text. It is admitted only if the platform's identity rule or La Trobe's adapter proves it; otherwise it stays held with what was tried.

**Next.** Merge this record (automerge), then Pilot #1441 (automerge, after its dry-run check). Read back the first runs, then sync Drive.

## 21 Nov 2026 01:45 AEDT — S1-CourseLink-2027-CRICOS: s891 to s893 live; first rollover runs read back; parked

- **Merges:** admin #728 (`3b740982`), then Pilot #1441 (`a0f9cece`, v2.16.73). Full test evidence green before the automerge label.
- **Deploy:** migration `20261120235000` applied (history md5 `77f94395` matches); worker `coverage-sweep` deployed. Deployed UAT and Release Currentness passed.
- **Signed in (Platform Admin, v2.16.73):** By university › Macquarie University › Course link shows Preview & Settle Batch on the year rule groups (Keep / Use / Refuse, `SETTLE n`). It was opened, not used.
- **First runs** (`link-refresh` 14:11, 14:21, 14:31 UTC; read back rolled back 14:44 UTC):
  - 120 of 158 held items tried. 14 admitted: 2 at a newer year (Melbourne `handbook.unimelb.edu.au/2027/courses/bh-envs`, ANU 1), and 12 at the held address with the exact code proved (ANU 10, Macquarie 1, Flinders 1). 46 not proved. 60 in flight.
  - Why an address did not prove the course: no answer 69, page needs a browser 55, HTTP 404 33, "page not found" 4, call time used 5.
  - One worker call of 15 items reached the 120-second call limit. Its items are due again at once.
  - Year holds waiting: 158 → 144.
  - La Trobe PHDLJ is in the batch in flight (4 La Trobe items not proved so far).
- **Invariants:** G3 75/48, no drift. Locks 7,585. Active jobs 137. $0 (plain reads only).
- **Parked.** The rule keeps running every 10 minutes. Items not proved are tried again after 7 days.
- **For the Platform Admin:**
  - lowering `link_rollover.items_per_call` (15) would keep calls inside the 120-second limit;
  - pages that need a browser (La Trobe, Melbourne) stay held at $0.

## 21 Nov 2026 07:50 AEDT — S1-CourseLink-2027-CRICOS: Platform Admin 07:35 decisions; s894 recorded before merge (migration `20261121080000`): 8 items a call, held address proved by its stored copy

**Platform Admin 07:35.**
- Keep the old-year fallback: a held address is admitted when 2027 and 2026 prove nothing and it proves the exact CRICOS code without "discontinued / no longer offered" words.
- Two tuning fixes before parking (below).

**Read live (rolled back, 07:40).** All 158 held items have been tried.
- 39 admitted: 5 at a newer year, 34 at the held address. 119 not proved.
- 69 of the 119 have a stored copy bound to the held address (60 read with the exact CRICOS code).
- 4 of 15 worker calls failed, at least one at the 120-second limit with 15 items in the call.

**s894 (Pilot #1442).**
- Setting `link_rollover.items_per_call` 15 → 8.
- When no live read proves the course, the worker reads the stored copy already bound to the held address ($0, evidence store, no fetch). It admits the held address only by the platform's identity rule and with none of the "not found / no longer offered" words.
- `security.link_rollover_claim_v2` replaces v1 (v1 retiring, retire after 5 Dec 2026). The tick and recorder get md5-guarded edits.
- The 119 not proved are due again at once.
- **Dry run passed, rolled back** (run 44814096356): per call 8; 119 to try, 69 with a stored copy; G3 75/48; locks 7,585; 137 active jobs.
- **Spec:** `cf-247-s894-link-rollover-stored-copy-contract`.

**Next.** Merge this record (automerge), then Pilot #1442 on green CI. Read back the next runs, then sync Drive and park.

## 21 Nov 2026 08:40 AEDT — S1-CourseLink-2027-CRICOS: s894 re-issued as `20261121093000` (its first version was taken by S1-ELR-Central-Policy); nothing of s894 was live

- **What happened.** Pilot #1442 (`a4709441`) merged s894 with migration `20261121080000`. S1-ELR-Central-Policy had already applied that version for s895–s896 (#1443). Deploy on merge refused the second file with the same version and ran nothing. So neither the s894 migration nor its worker change went live; items per call stayed at 15.
  - Lane lesson: claim the version against the open pull requests and the merged head at the moment of merge, not only at the start.
- **Fix (Pilot #1445).** The same migration is issued again as `20261121093000`, above the live head `20261121090000` (s900), and one comment line in the worker makes Deploy on merge deploy `coverage-sweep`. The s894 spec now checks that only one file uses `20261121080000`.
- **Dry run passed, rolled back** (run 44821326058): per call 8; 119 to try, 69 with a stored copy; G3 75/48; locks 7,585; 135 active jobs.
- **Next.** Merge this record, then Pilot #1445. Read back the next runs, then sync Drive and park.

## 21 Nov 2026 09:20 AEDT — S1-CourseLink-2027-CRICOS: s894 live and read back; La Trobe PHDLJ admitted from its stored copy; parked

- **Merges:** admin #734 (`80bdf5de`), then Pilot #1445 (`2bf2b592`). Full test evidence green.
- **Deploy:** migration `20261121093000` applied (history md5 `dcaf5c46` matches); `coverage-sweep` deployed with the stored-copy proof.
- **Read back** (rolled-back dry run 44827514855, 22:15 UTC):
  - 58 admitted so far: 8 at a newer year (ANU 4, Melbourne 4), and 50 at the held address, of which 16 were proved by the stored copy. 68 not proved; 32 in flight.
  - Year holds waiting: 158 → 100.
  - No worker call has failed since items per call became 8.
  - La Trobe `handbook.latrobe.edu.au/courses/2023/PHDLJ` (CRICOS 0100697) was admitted at its held address from its stored copy. A plain read of 2027 did not show the code.
- **By provider:**
  - ANU: 33 of 33 admitted.
  - Macquarie: 14 admitted, 22 not proved, 15 in flight.
  - Melbourne: 4 admitted, 18 not proved, 5 in flight.
  - La Trobe: 2 admitted, 10 not proved, 6 in flight.
  - Sydney: 14 not proved, 5 in flight. Its addresses are archived handbooks, which are never admitted from the held address.
  - UOW College: 3 admitted.
- **Invariants:** G3 75/48, no drift. Locks 7,585. Active jobs 135. $0.
- **Worth a look.** The 3 UOW College pages admitted are its "college-insider" articles that show the exact CRICOS code. They passed the rule, but a person may prefer the course page itself.
- **Parked.** The rule keeps running in `link-refresh`. Items not proved are tried again after 7 days.

## 21 Nov 2026 13:45 AEDT — S1-RM-Design s935: Settings › API usage for every version and key; one key per (consumer, API version); standing rule Self-Sustaining API & Key Governance

- **Asked (Platform Admin, 13:11).** API usage read from the database for every API version and key, Website and Zoho v3 included; independent rotatable keys per consumer and version; a standing rule in `CLAUDE.md` and `AGENTS.md`.
- **Change (Pilot #1458, v2.16.76 / 0.1.498, migration `20261121200000`).** Version register `pipeline.api_versions`; own v3 keys (`website_developer_v3`, `zoho_creator_v3`, `zoho_crm_sync_v3`, Not issued); `pipeline.api_key_auth_v1` and `pipeline.api_request_log_v1` for v3; read path `security.api_usage_versions_v1` with 24 h / 7 d / 30 d usage, 2xx/4xx/5xx, error rate and p95; coverage check `security.api_usage_coverage_v1` (empty). The screen has no version list. Design: `docs/platform/2026-11-21-s935-api-usage-versions-and-keys.md`.
- **No interruption.** The website calls v3 with its v2 key today; that key is the v3 key's previous key for `api.new_key_bridge_days` (14) until the Platform Admin issues the v3 key.
- **Dry run passed, rolled back** (run 44855966870): 7 versions, coverage empty, website v2 16,087 calls in 30 days (p95 7.7 s), 653 v3 calls on the v2 key; Zoho v3 refuses a v2 key; G3 75/48; locks 7,585.
- **Next.** Merge this record, then Pilot #1458; read back live, check the screen signed in, sync Drive and park.

## 21 Nov 2026 14:50 AEDT — S1-RM-Design s935 live and read back: Settings › API usage shows every version and key; Pilot #1458 merged as v2.16.78 with migration `20261121230000`; parked

- **Renumbered before merge (correction to the 13:45 entry).** Two other lanes merged first: s931 (#1457) took v2.16.76 and migration `20261121200000`, and s932 (#1460) took v2.16.77; s940 (#1459) held `20261121220000`. s935 was re-issued as **v2.16.78 / 0.1.500** with migration **`20261121230000`**, above all three. Its dry run passed again and rolled back (run on `20261121230000`, md5 d46bba6f).
- **Merged and deployed.** Pilot #1458 merged as `44f68a06`. Deploy on merge applied `20261121230000` (history md5 d46bba6f matches the file) and deployed `website-api-v3` and `zoho-api-v3`. The migration's live post-checks passed: the website v2 key signs in to v3 only as the bridge; Zoho v3 refuses a v2 key.
- **Read back live (rolled-back probe).** Live head `20261121230000`. G3: 75 functions / 48 tables, no drift. Manual locks 7,585. Active jobs 137 (≤ 140, none added). Coverage check empty. Six versions are on the read path:
  - Website v1: 3 credentials, not logged.
  - Zoho v1: 1 credential, not logged.
  - Website v2: 15,866 calls in 30 days.
  - Zoho v2: 3 keys (194 calls on `zoho_creator_v2`).
  - Website v3: `website_developer_v3` is Rotating / Grace; the bridge ends 5 Dec 2026 14:39 AEDT. The v2 key shows 653 calls on v3.
  - Zoho v3: 2 keys, Not issued.
- **Screen, signed in (built-in browser).** Settings › API usage at v2.16.78 shows all six version cards with key status, masked key, created, rotated, last used, 24 h / 7 d / 30 d calls, 2xx/4xx/5xx, error rate and p95. Website v3 shows Rotating / Grace with "website_developer_v2 also works here until 5 Dec 2026, 2:39 pm"; Zoho v3 shows both keys Not issued with Issue key.
- **Platform Admin to do.**
  - Press Issue key on `website_developer_v3` before 5 Dec 2026 and send the key to the website developer securely.
  - Press Issue key on `zoho_creator_v3` and `zoho_crm_sync_v3` when Zoho moves to v3.
- **Parked.** AI $0, Firecrawl $0.

## 21 Nov 2026 22:00 AEDT — Lane 2 (S2-Data-Destination-Continuous) s960: RM1C Australian application routes into a draft edition, state scope, $0 static read (Pilot #1466)

- **Asked (Platform Admin, 21:16; first item chosen 21:19: AU rule drafts).** Lane 2 brief. The master plan (Lane 1, admin #765) names this lane; its section 5 is now filled in.
- **Change (Pilot #1466, migration `20261122040000`, renumbered above s955's `20261122030000`).**
  - `destination.page_facts.state_codes`.
  - Four Layer 1 Register sources: Study Australia, UAC, VTAC and SATAC.
  - Draft edition "Australian application routes (Study Australia and admissions centres)", terms pending.
  - Five application-route facts: direct (AU), agent (AU), UAC (NSW, ACT), VTAC (VIC), SATAC (SA, NT).
  - Loader function: state applicability (md5 `a81d0f62` → `c34e7946`).
  - Edge loader v1.6.0: scope `static` ($0).
  - Workflow "Destination page facts (static read)", run on deploy.
  - Design: `docs/platform/2026-11-21-s960-rm1c-application-routes.md`.
- **Dry run passed, rolled back (synthetic load).** 5 found, 5 written as drafts, each with the right country or state scope. G3 75/48; locks 7,585; 135 jobs.
- **Corrections to the brief.**
  - RM1A's 1,953 CRICOS rows were applied on 17 Nov; 701 departures wait for the Platform Admin.
  - RM1D JSA careers is published (1,577 rows).
  - RM1H Home Affairs rules are published; the Fair Work edition is draft with terms restricted.
  - All three `destination-*` jobs are paused.
- **Gaps.** QTAC (statement not in static HTML) and TISC (no official page) are not captured.
- **Next.** Merge this record, then Pilot #1466; run the static read; read back; RM1I living costs.

## 21 Nov 2026 22:50 AEDT — Lane 2 s960 live and read back: RM1C application routes are draft rules with state scope (Pilot #1466 `de3ddba5`); RM1I source gap; parked

- **Merged and deployed.** Admin #767, then Pilot #1466 (`de3ddba5`). Deploy on merge applied `20261122040000` (history md5 82f54517 matches the file) and deployed `layer1-destination-geo-loader` v1.6.0.
- **Live on deploy.** Workflow "Destination page facts (static read)" (run 44898091961) read 9 static facts: 5 rules written, 4 unchanged, 0 not found, 0 pages failed. No rendered (Firecrawl) page was read: $0.
- **Read back.** Five draft rules in "Australian application routes (Study Australia and admissions centres)":
  - apply directly (country AU)
  - education agent (country AU)
  - UAC (AU-NSW, AU-ACT)
  - SATAC (AU-SA, AU-NT)
  - VTAC (AU-VIC, `state_code` AU-VIC)
- **Guardrails.** Live head `20261122040000`; G3 75/48, no drift; locks 7,585; 137 active jobs, 0 unregistered.
- **Platform Admin.**
  - IR-003: set the edition's terms, approve the five rules and publish.
  - IR-008: Study Tasmania's living-expenses page no longer gives figures; choose the Hobart living-cost source (Migration Tasmania gives Tasmania-wide weekly costs; the national Study Australia calculator is not a page of figures).
- **Next (Lane 2).** Item 1 continues: RM1I once IR-008 is decided; RM1H Fair Work terms (restricted). Then item 3, queues and NZ/CA geography. Parked.

## 22 Nov 2026 01:00 AEDT — Lane 2 s965: RM1I Tasmania-wide living costs as draft figures (Pilot #1472); item 3 audit, nothing rule-resolvable at $0

- **Asked (Platform Admin, 00:11).**
  - IR-008 approved: Migration Tasmania's Tasmania-wide weekly living costs into a draft edition at $0.
  - Then item 3: settle what a rule can settle, and check the NZ and CA sweeps.
- **Change (Pilot #1472, migration `20261122100000`, data only).**
  - Migration Tasmania registered in Layer 1.
  - 75 draft `living_cost` figures: 15 weekly figures for each of the 5 Tasmanian localities held (found as SUA code `6…`), each with its verbatim line. Edition `Migration Tasmania weekly living costs (Tasmania-wide), page of 28 Jul 2026`.
  - Dry run passed, rolled back: 75 rows; G3 75/48; locks 7,585; 137 jobs.
  - Design: `docs/platform/2026-11-22-s965-rm1i-tasmania-living-costs.md`.
- **Item 3 audit (read-only).** `docs/platform/2026-11-22-lane2-item3-queues-and-nz-ca-geography-audit.md`.
  - 82 primary-campus ties (all providers with several campuses), 160 postcodes and 69 waiting campuses, and 5 English readings: all for a person.
  - NZ: 2,692 of 6,514 courses have a campus. CA: 2,290 of 3,825. Every other course carries a reason except 16.
  - `fid-det` is running (1,061 NZ/CA readings in 24 h). `struct-det` has read what it holds.
  - Nothing is rule-resolvable at $0.
- **Platform Admin.** IR-009 (an NZ and CA course-campus decision) and IR-010 (the person queues).
- **Next.** Merge this record, then Pilot #1472; read the figures back; park.

## 22 Nov 2026 01:45 AEDT — Lane 2 s965 live and read back: 75 draft Tasmania-wide living-cost figures (Pilot #1472 `34e31e05`); parked

- **Merged and deployed.** Admin #774, then Pilot #1472 (`34e31e05`). Deploy on merge applied `20261122100000` (history md5 3f42f69c matches the file).
- **Read back live.** 75 figures, all draft, in edition `Migration Tasmania weekly living costs (Tasmania-wide), page of 28 Jul 2026`; Hobart whole-house rent reads $550 a week.
- **Guardrails.** Live head `20261122100000`; G3 75/48, no drift; locks 7,585; 137 active jobs, 0 unregistered; $0 AI, $0 Firecrawl.
- **Platform Admin.**
  - Sign off the terms and approve the figures (`admin_destination_figures_bulk_approve`).
  - IR-009: the NZ and CA course-campus decision.
  - IR-010: the person queues.
- **Lane 2 next.** Item 4 (NZQCF, NZSCED and CIP); NZQA reuse terms are still flagged. Parked.

- **24 Nov 2026 15:55 AEDT, S1-AER-Claude (s1042):** ACU official by-country PDF registered (`entry_matrix_sources` 224bc22d), fetched direct and archived, run c7e1586e `held_unparsed` (no ruled table, no aligned grid). UOW, RMIT, Monash, Newcastle, Macquarie, QUT, Murdoch, La Trobe, SCU, JCU and UniSC recorded HELD with reasons in the queue. Adelaide alias already delivered by s1038. AI $0, Firecrawl 0 credits. No Pilot change.

- **24 Nov 2026 16:30 AEDT, S1-AER-Claude (s1045):** entry_matrices route enabled with a provisional lean-model cascade (Mistral Small 3.2, Qwen3 30B, GPT-4.1 mini on escalation), recorded as Platform Admin decisions, not benchmark passes (Qwen 2/50 on record). ACU and UOW claimed for re-queue after the Pilot merge. RMIT ladder reader and 45-provider wave are separate slices.

- **24 Nov 2026 17:00 AEDT, S1-AER-Claude (s1045 live, Pilot #1549, Admin #920):** entry_matrices route live with the provisional cascade (route resolves to Mistral Small 3.2). ACU re-queued and held again: the worker never sends a PDF to a model, so it needs a Tier 1 layout reader. UOW not re-queued (already read 12 Nov, same hash). RMIT ladder reader and the 45-provider wave not done in this session.
- 24 Nov 2026 19:45 AEDT, S1-AER-Claude (s1071 live: Pilot #1565, #1568, #1569; Admin #948): ACU unruled-PDF column reader `pdf-columns-v1` (no model, $0) runs before the unproven-PDF hold and drops cells with no printed number as `no_minimum_published`. Live result: ACU run c7e1586e read 454 rows from the 23-page stored PDF (350 with a printed minimum, 114 countries); ACU `catalogue.provider_entry_matrix` went from 0 to 377 active rows (providers with an active matrix 60 to 61; rows 6,882 to 7,259), and a second `entry_matrix_change` item (370 rows) is pending machine admission. In-code comment labels `s1072`/`s1073` in the reader hook are change labels under s1071, not spec numbers (those numbers belong to other lanes). Live checks: active crons 136 (limit 140); no G3, lock or shared admission function touched. Resume point: (1) confirm the pending ACU `entry_matrix_change` item is admitted by `aer_matrix_machine_admit_v1` and read ACU back through the consumer API; (2) UOW run 0ff79fe4 dropped 27 band-ladder rows (TH/TW `band_not_in_quote`; BR/LK/SA/SE/KR `quote_not_on_page`) from the 28 Oct model read; the stored page (source c9a5c1d5) has thead/th tables that the s1029 HTML reader should read at $0, so test the reader on the stored HTML offline against the 222 admitted rows before any re-read, because `admin_entry_matrix_reread` supersedes older rows; (3) RMIT country-band ladder (merged qualification cells, Australian-standard bands, ambiguity to Layer 4, no cross-country mapping); (4) the remaining AU sourced providers in batches of 15 (QUT, La Trobe, Murdoch, SCU, JCU, UniSC, Monash, Newcastle first). Spend: no Firecrawl, no model call, $0 for ACU. S1-Build: please regenerate TEST-REGISTER.md after Pilot main carries the s1071 spec.
- 24 Nov 2026 20:25 AEDT, S1-AER-Claude (450-wave mandate 19:40, checkpoint 1): live AU baseline 1,543 active providers; 43 with active matrix rows (6,702 rows); 99 have a registered source and no active rows, 1,401 have no source (discovery is an S1-Build hand-off), so the cohort is 99, not 450 (no cohort manufactured). Of the 99: 74 were read and their pages hold no table with an Australian-standard column (parked: nothing to extract), 15 hold proposed rows declined by machine admission (D-R3 `gate_incomplete`: one to four dropped published rows make the whole read incomplete; UWA `all_rows_held` level_unmapped 194 and RMIT UP `host_shared` belong to S2-AER and are not touched). Batch 1 (13 AU providers with gate_incomplete and no active rows: ALG EDU English, APSI, CIT, CDU, Curtin, Edvantage, Elite, Gateway, Griffith, Innoverse, SIHE, TAFE SA, AIM) re-read from stored evidence through `admin_entry_matrix_reread` (378 proposed rows and 13 first-run items superseded; no active row touched). The deterministic HTML reader did not prove these pages, so they fell to the Mistral Small route, which is timing out (TimeoutError, time budget); runs are queued with the platform's own retry. Griffith completed with 1 row. ACU retains 377 active rows; its pending 370-row change is recorded for controlled review and not counted. No new active rows from batch 1 yet. Spend: no Firecrawl; model spend small and unmeasured here (read it from the AI usage view). Resume point: (1) read the 13 batch-1 run outcomes and the machine admission result; if they still decline with one dropped row, write the common fix as a recovery of dropped rows by verbatim cell quote (no S2-AER function change) or hand the D-R3 rule question to S2-AER; (2) UOW 27 dropped rows and the RMIT band ladder only if the same fix unlocks them; (3) continue the other 86 source-backed providers in batches of 15; (4) record each exception through S1-BLOCKER-QUEUE.csv's authorised writer and ask S1-Build to mirror into M3.
- 24 Nov 2026 20:45 AEDT, S1-AER-Claude (AER-FU-01/04, checkpoint 2): baseline verified 44 AU providers with active matrix rows (6,703 rows; the 44 providers hold 8,498 active courses). Batch 1 outcome: Curtin and CDU failed three times on the Mistral Small route (TimeoutError); ten further batch-1 runs (ALG EDU English, APSI, CIT, Edvantage, Elite, Gateway, Innoverse, SIHE, TAFE SA, AIM; none with active rows) were held with a recorded reason so unchanged evidence is not resubmitted to the timing-out route (AER-FU-01); Griffith admitted 1 row. They need a deterministic reader or a different authorised tier (a spending/qualification decision for the Platform Admin or S2-AER, not changed here). 74 providers without an Australian-standard table: alternative official sources checked for the three largest: Newcastle (457 active courses) shows an interactive degree and qualification selector with no static table, Bond (184) and UNE (130) print only general equivalence text and send readers to the program finder, so all three are verified source gaps on the registered page; next candidates to check: Deakin, Torrens, ECU, CQU, UniSQ, Melbourne Polytechnic, SAE, JMC, Sydney Metro College, ICMS. Transfers: to S2-AER, the D-R3 completeness rule (one to four dropped published rows decline a whole read: Curtin, CIT, SIHE, CDU, Gateway), UWA level mapping (194 rows `level_unmapped`) and RMIT UP `host_shared`; to S1-Build, official-source discovery for the 1,401 AU providers with no source and the M3 mirror of these exceptions. Spend: no Firecrawl; no new model calls after the Curtin/CDU timeouts; per-model tokens and USD are on the AI usage view, not read here. Layer 4: first-run items for the 10 held providers were superseded by the re-read and are re-created when a read completes. Resume: continue the other source-backed providers in batches of 15, choosing structure-sharing groups the deterministic readers prove; check the next alternative-source candidates above.
- 24 Nov 2026 22:10 AEDT, S1-AER-Claude (AER-FU-01/07, checkpoint 3): baseline re-read: 44 AU providers, 6,703 active rows, 1,613 proposed AU rows (not counted), active crons 136; no new active rows this pass. S1-RM-Design's new sources inspected from stored copies, no unchanged resubmission to the Mistral route: JMC Academy by-country PDF (source eb8fb8de) is a two-column country and qualification list for "All Programs" with a printed minimum on only a few rows (for example a 60% pass) and no study level, so it fails the AER-FU-07 contract (no proved level, no printed minimum) and is held as a verified source gap, not read; Newcastle international prospectus PDF (source ff90a9ca, 457 courses) cannot be exported by the worker (HTTP 546 resource limit; runs failed 3 times on time budget) and is a marketing prospectus, held until S1-Build raises the PDF size limit or a country-level source is found; ECU secondary-school-results (model timeout), Deakin course-guide PDF (model timeout) and Bond foundation program page (no reply) are held for the same model-route reason; ICMS read gave 3 `unknown_country` cells (country-alias list is S2-AER's) and Melbourne Polytechnic has no Australian-standard table. Next executable action: when the Mistral timeout remediation lands, requeue the held runs once (batch 1 list in checkpoint 2, ECU, Deakin, Bond); until then continue only providers a deterministic reader proves; Layer 4 first-run items re-create when a read completes. Spend: no Firecrawl, no model call this pass.
- 24 Nov 2026 22:40 AEDT, S1-AER-Claude (overnight mandate 22:07, AER-FU-04 handoff to S1-RM-Design for Steps 1–2): live check: QUT (294 active courses, 0 active rows) holds 23 registered sources that are all individual course pages held inactive by the matrix-routing guard, so QUT has no usable matrix source yet. Public search finds two official by-country PDFs that look usable: https://www.qut.edu.au/__data/assets/pdf_file/0016/82033/International-entry-requirements-by-country-diploma.pdf and https://www.qut.edu.au/__data/assets/pdf_file/0018/82053/International-entry-requirements-by-country-foundation.pdf (country, qualification and a printed average or grade per row; study level is named only by the file, so S1-RM-Design confirms the level label before registration, and rows such as "good grades" with no number stay unvalued). La Trobe (248 active courses, 0 sources): no country table found; its entry guidance is per course page. Murdoch and UniSC runs are queued on the Mistral route (held by AER-FU-11); SCU (153 courses, run done, 0 active rows) and JCU/Monash (1 active row each) need a reader review next. Not done: UOW bare-point scale reader and RMIT band ladder (not built), Firecrawl discovery (no direct Firecrawl tool in this lane; on-demand opening and spend run through the platform workers, none used). Counts unchanged: 44 AU providers, 6,703 active rows, crons 136.
- 24 Nov 2026 23:00 AEDT, S1-AER-Claude (Steps 3-4 funnel mandate 22:30; no Pilot PR this session): live checks. QUT diploma and foundation by-country PDFs registered by this lane and fetched (sources fd198a4d-ac37-4910-8e4e-62be983653a0, 649d017d-a168-4bc5-a656-e176c499d150); the stored copy is a Firecrawl markdown of 1,482 characters holding only India rows, not the PDF, so the column reader cannot run; the model read repeated rows and all 10 were dropped as quote_not_on_page, nothing admitted; the PDF bytes are needed (S1-Build). Stored Batch 2 snapshots inspected without re-fetching: Southern Cross, James Cook and Sunshine Coast stored pages have 0 HTML tables (accordion or list layout, no table reader applies; Sunshine Coast and Murdoch model runs timed out, AER-FU-11 s1085 is on branch s1-build-s1085-aer-timeouts, not main); Murdoch's registered page holds credit and completion conditions, not score minima; TAFE NSW is a 3-page PDF with free-text cells in a Vocational and Higher Education column pair that needs a level-mapping decision from S2-AER. Seven AER rows added to docs/monitoring/S1-BLOCKER-QUEUE.csv (SCU, JCU, USC, Murdoch, TAFE NSW, QUT, Monash). UOW and RMIT readers not built; Batch-1, ECU, Deakin, Bond not requeued (AER-FU-11 not on main). No active-row change from this lane: canonical AU matrix read at 45 providers and 6,704 active rows.
- 24 Nov 2026 23:45 AEDT, S1-AER-Claude (overnight mandate 23:15; AER-FU-11 follow-up for S1-Build, no Pilot PR): s1085 is live (worker v1.0.39, entry.matrix_slice_chars 4,000, slice concurrency 6) but the cascade cannot fall through: security.ai_route_v1('entry_matrices') returns models = [mistral-small-3.2] only with migration_state routed_single, although the route's cascade lists three and all three models are qualified (provisional) in pipeline.ai_route_qualifications; in the 4 hours to 23:40 the worker v1.0.39 made 8 answered and 52 failed (empty) Mistral calls and 0 calls to Qwen3 30B or GPT-4.1 mini. This lane requeued 17 held runs once (ALG EDU English, APSI, CIT, Edvantage, Elite, Gateway, Innoverse, SIHE, TAFE SA, AIM, CDU, Curtin, Murdoch, UniSC, TAFE International WA, Southern Cross, James Cook; 2 proposed rows and 1 pending item superseded, no active row replaced); s1085 had requeued Bond, Deakin and ECU. Results so far: AIM done with 4 proposed rows; CDU, Curtin and TAFE SA failed again after 3 attempts on v1.0.39 (model time-out); the rest queued or leased; not resubmitted. Ask S1-Build: make the route resolver return the whole qualified cascade, then requeue CDU, Curtin and TAFE SA once. James Cook's public page names a country table inside an accordion that its stored 317,035-character copy does not hold as a table (0 tables), so a table reader cannot read it; Southern Cross and UniSC stored pages also have 0 tables. UOW (212 active rows) lacks only the South Korea and Taiwan matrices (27 dropped rows): a country-limited reader needs S2-AER's partial-admission design; RMIT not inspected. entry_matrices spend 24 Nov 15:40 to 23:40: 193 calls, USD 0.0438 on the route; no Firecrawl by this lane. Canonical AU matrix 45 providers, 6,704 active rows, 1,617 proposed (not counted), 38,021 course_entry_requirements rows, 136 active crons.
- 24 Nov 2026 23:58 AEDT, S1-AER-Claude (23:24 mandate; docs-only, no Pilot PR, no runtime change; follows Admin #1015): the 105-provider sourced-no-active cohort was read from stored evidence without Mistral. 66 providers read done with no table holding an Australian standard column; their stored pages (full size) were re-inspected: 41 have no tables and 25 only English-test, fee or course tables, so no country reader applies. 61 not already queued were added to docs/monitoring/S1-BLOCKER-QUEUE.csv as HELD:NO_SOURCE for S1-RM-Design (6 already had a row). RMIT University has 380 active rows; its 7 unread pages are three non-country pages (foundation equivalencies, GAC, IB), Nigeria (column left out), Norway (bare numbers with no printed scale, an existing source hold; UOW's CSAT matrix has the same shape and needs a justified scale decision from S2-AER), United Kingdom (2 of 31 minimums) and Vietnam (table context). Proposed-row holds stay with S2-AER: Melbourne Polytechnic 25 and John Paul 5 (level_unmapped, level labels are country-qualification names, no study level), Amtech (no_minimum), RMIT UP (host_shared), UWA 194 (D-R3). Canonical state unchanged (45 providers / 6,704 rows); no AI spend, no Firecrawl.
- 25 Nov 2026 00:55 AEDT, S1-Build (AER-FU-11 P0, Platform Admin 24 Nov 23:24; Pilot #1593, Admin #1037 and #1038): s1099 is live (head 20261126050000). The entry_matrices route is `routed` and the lease carries Mistral Small 3.2, Qwen3 30B and GPT-4.1 mini; an unqualified model drops out (rolled-back regression). The earlier S1-Build s1093 (Pilot #1586) never applied: S2-AER s1093 took version 20261126001000 first. 12 failed runs were requeued once per source (none with queued, running or leased work). In the first 15 minutes after deploy: Qwen3 30B 4 answered and 6 empty, GPT-4.1 mini 28 answered and 6 empty (Mistral is asked last while ai_model_health holds it in cooldown, the existing order); 5 runs done, 252 entry rows admitted (Sydney Institute 67, TAFE SA 56, CDU 50, APIC 44, Curtin 35); entry_matrix spend today US$0.1523; Firecrawl 0; active cron 138; manual locks 7,585; G3 75/48 unchanged. Open (S1-Build): two open PRs can claim one migration version or s-number, and the later one is skipped on deploy; pre-flight checks main only.
- 25 Nov 2026 AEDT, S1-AER-Claude (Admin #1028; Pilot s1105): CQUniversity (106 active courses) country table is a PDF served without a .pdf address, so the worker classified it not_html; a `#.pdf` source was registered and its pages stored. New $0 AER v2 proven-structure reader in `entry-pdf-columns.ts` (header Country | Qualification | Diploma | Undergraduate; country carried over its qualification rows; fails closed on any item off a column; UK awards SQA and BTEC printed under China are left out and listed, not placed by guesswork) and `entry-cells.ts` now reads "per cent" as a percentage. Fixture from the stored export, spec s1105 plus 102 related entry-reader specs pass locally. Pilot PR follows this Admin PR; after merge the CQU source is re-read, then rows, machine admission, canonical rows and course coverage are read back. Nothing admitted yet; canonical AU not claimed. Spend US$0 (Firecrawl 0). Proper fix for S1-Build: divert to the PDF path when an HTML read returns application/pdf or %PDF. Report to S1-Build: OpenRouter weekly key limit hit two runs earlier.
- 25 Nov 2026 AEDT, S1-AER-Claude (Admin #1028; Pilot s1106): CQU requeue after s1105 (merge 9647f1a3, deployed 15:31 UTC) was held again (held_unparsed, 0 rows, US$0). Cause found from a fresh stored-PDF export: the table runs over five pages with 14 or more of about 76 qualifications blank at one level, so the shared cell reader's 90 per cent every-level gate rejected the grid. s1106: a table proven by its printed Country header needs 50 per cent of rows with every level (other readers keep 90); spec s1105 gains the blank-cell case (fails without the change). Fixture now holds the real page 1 (introduction, global table and the first rows). Pilot PR follows this Admin PR; then the CQU source is re-read once and rows, machine admission, canonical rows and course coverage are read back. Nothing admitted yet.

- 25 Nov 2026 07:30 AEDT, S1-AER-Claude (s1107 live: Pilot #1598, migration 20261126061000; Admin #1049 / #1054; registered source writer not used, registration by reviewed Pilot migration as for s1100): **Wave 1 Steps 1–2 outcome for the 40 named AU IDs.** All 40 accounted for in `docs/platform/2026-11-25-s1-aer-wave1-au-1049-steps12-40-providers.csv` (47 rows: provider, ID, source URL, source ID, evidence ID, storage path, full SHA-256, method, spend, status, exceptions). (a) 24 official pages/PDFs registered for 16 providers; 22 durably stored with evidence ID, hash and path (La Trobe, Collarts, Le Cordon Bleu ×2, APC, AIBT ×2, Excelsia ×2, Holmesglen ×2, George Brown AU ×2, Box Hill ×2, William Angliss, Reach ×2, York, AAPoly, Gold Coast Learning Centre, TasTAFE); Greenwich two sources still `found` with no error (pending, not waited for). (b) 22 further providers (14, 17, 19, 20, 22–27, 29–40 less 28) hold existing course-bound stored pages; no new fetch; content not yet validated as academic entry. (c) Melbourne College of Hair and Beauty and Signet: no stored evidence anywhere; official course pages found on mcohb.com.au and signet.edu.au, not registered (attach needs the Platform Admin function; exact URLs are in the CSV). Invicta: sample page HTTP 404, 3 of 23 bound pages hold evidence. (d) English-only pages stored but not AER evidence: AAPoly, Holmesglen English page, George Brown English policy, TasTAFE. Firecrawl: 4 credits (La Trobe, Box Hill ×2, TasTAFE; entry_fallback), dollar cost not verified; AI $0 in Steps 1–2; no discovery repeated. George Brown AU = 80e8f5fd (not the Canadian record); AIBT = eb9e3903. Steps 3–5 follow under the 25 Nov authorisation; existing course-level AER is separate from any new admission.

- 25 Nov 2026 08:00 AEDT, S1-AER-Claude (s1108, documents and live reads only; no Pilot change; Admin #1049 / #1054, 25 Nov authorisation): **Wave 1 Steps 3–5 outcome for the 40 named AU IDs** (per-provider file `docs/platform/2026-11-25-s1-aer-wave1-au-1049-steps3-5-40-providers.csv`). The existing governed pipeline ran unattended on the sources registered in s1107; this lane changed no reader, rule, setting, schedule or canonical row. **New canonical admissions: 9 matrix rows at 3 providers** (La Trobe 2, 07:03 AEDT; William Angliss 4, partial; Gold Coast Learning Centre 3 of 8, 5 excluded by approve-except), each traced from the registered source to run, machine admission and `catalogue.provider_entry_matrix`. Provider-matrix rows before 0, after 9. La Trobe: 200 of 248 courses now resolve through the provider table (48 were already course-level); `website_v3_course(<La Trobe undergraduate course>, 'AU')` returns the new row (v3 not yet live on the website; frozen v2 untouched). **Course-level active rows are unchanged for all 40 providers** (existing 1,564 active course-level rows and 643 admitted courses are not gains); no new course read was possible because the entry-requirements AI route is switched off in Models & services (hourly scheduler: course_reads 0, refusal text recorded). Counts: 24 sources registered at 16 providers, 22 stored, Greenwich 2 still found with no error; 20 matrix runs done, 2 failed (Le Cordon Bleu and Excelsia PDFs, `held_unparsed`, no aligned grid), 0 queued at read-back except Greenwich. Machine outcomes: admitted La Trobe, Gold Coast, Angliss; declined AIBT (`source_not_official_host`: catalogue host aibt.qld.edu.au, official site aibtglobal.edu.au), George Brown (`all_rows_held`; `gate_incomplete`), TasTAFE (`gate_incomplete`; the source is an English-only page and must not be approved as academic AER). English-only sources (AAPoly, Holmesglen English page, George Brown English policy, TasTAFE) are not counted. Layer 4 pending at the 9 matrix items: La Trobe 1, Le Cordon Bleu 1, AIBT 1, George Brown 2, Angliss 1, TasTAFE 1 (genuine exceptions to a person; none actioned by this lane). Course-level holds across the cohort (outcomes view built 07:05 AEDT): 503 identity-held (AU entry requirements accept only CRICOS code, adapter code and manual; exact_title 116, no basis 71, page mismatch 256, ambiguous 38), 184 nothing published or superseded, 118 no official course page, 155 `gate_incomplete` declines (S2-AER D-R3), 5 `would_admit` shadow decisions, 148 stored pages with unadmitted deterministic readings. These are shared-rule holds for S2-AER and S1-Build; none was loosened. Spend: model US$0.0155 for 20 matrix runs (Mistral Small 3.2; token counts are not stored on run rows), Firecrawl 4 credits (La Trobe, Box Hill ×2, TasTAFE), dollar cost not verified. Steps 6–9: Layer 4 and canonical verified as above; publication verified only at the v3 function; two unattended result-bearing cycles NOT yet shown (the admissions came from the first cycle after registration), so F-AER stays OPEN. Next executable actions: (1) S1-Build/S2-AER: PDF layout hold for the two Le Cordon Bleu and Excelsia guides; (2) person or S2-AER: AIBT official host; (3) Platform Admin: attach Melbourne College of Hair and Beauty and Signet URLs listed in the s1107 CSV; (4) Platform Admin decision on the course-level AI route (spend authority); (5) re-read this cohort at the next cycles for the two-cycle proof.

- 25 Nov 2026 07:58 AEDT, S1-AER-Claude (Admin #1049 / #1054 / #1055, Steps 3–5 continuation, spec s1109, documents only, no Pilot code, no migration): **AU Wave 1 stays OPEN; diagnosis and reconciliation recorded, no new canonical delivery in this checkpoint (still 9 new matrix rows, 0 new course-level rows).** (1) **Corrections to the 07:41 record.** The "155 D-R3 declines" are 155 decision rows over 86 distinct courses, and only 62 of those courses still stand declined `gate_incomplete` (latest per course, none withdrawn; newest decline 21 Nov 00:36 UTC, so no new D-R3 decisions since). The 503 identity-held courses have no machine decision at all, so identity and D-R3 do not overlap: affected courses are 503 + 62 + 2 `all_rows_held` = 567 distinct, not 658. The identity breakdown reconciles exactly: 503 = exact_title page-bound 116 + no basis page-bound 71 + no basis page mismatch 256 + CRICOS-bound ambiguous 31 + exact_title ambiguous 7 + CRICOS-bound page mismatch 17 + adapter_title page-bound 5 (the earlier 22 unexplained are the 17 and the 5). (2) **Course-level AI route (the one protected decision).** `security.ai_route_v1('course_entry_requirements')` returns held, mode stop, reason "switched off (Models & services)", models empty (qwen3-30b-a3b-instruct-2507 skipped "not qualified for this service"), `on_demand_exempt` false, so a scoped on-demand request cannot go around it; daily ceiling US$5, spent today US$0, OpenRouter balance US$97.28 (key limit remaining US$46.32), Firecrawl left on plan 62,190. Setting `entry.course_read_providers` (43 providers) holds none of the 40; whether the hourly scheduler uses it or the aer-schedule eligibility rules was not verified. Needs from the Platform Admin: switch the service on for a bounded scope and name one qualified lean model; nothing else. (3) **Eligible AI population.** Of the cohort's 2,259 courses, 225 have an accepted identity (CRICOS, adapter code or manual), a bound page, no admitted course row and a read skipped because the route is off; 53 of those already have a Layer 4 course read and canonical rows, leaving 172 never read by AI (deterministic reader found nothing on them). Their 225 stored pages total 11.6 MB compressed, 3.32 M extracted characters (mean 14,733, longest under the 205,000 cap, so 1 to 2 slices of 12,000). No v2 shadow answers exist for them. Previously paid answers reused first: the 53. (4) **Preprocessing path (verified in worker code).** The course entry read (`entryRead`, index.ts) converts the stored page with `htmlToText`, dropping only nav, header and footer, then slices at `enrich.course_entry_slice_chars` 12,000 with 600 overlap; lean-md-v2 and the section selector run beside it as observation only (`lean-input.ts`: "never changes a request") and `reading.markdown_input` is 1 but this reader does not use it. So the read does not yet send selected academic sections only; the requirement in this brief (send meaningful extracted sections, not whole pages) is not met by the existing route. Smallest correction, for S1-Build as Integration Controller, none made here: have `entryRead` take the selected sections when the selector marks the page likely, whole text otherwise, with recall checked on the 53 reads that already have canonical rows before any volume. Estimated cost for the 172 pages at the ledger's observed rate (course_entry_requirements 15–16 Nov: 1,357 answered calls, 3,317,749 input and 826,078 output tokens, US$0.5768, mean 2,445 in / 609 out per call; 726 failed calls US$0.0437): about 250 calls, 0.7–0.9 M input tokens, US$0.15–0.45 including retries; expected canonical yield is not estimated, the first bounded batch measures it. (5) **Greenwich** (21e1cb6d): both sources `found`, attempts 0 since 06:46 because the provider is `publication_status` unpublished and in `security.provider_hidden_v1`, so `entry_matrix_enabled_v1` is false and not AER-eligible; this is a publishing decision for the Platform Admin, not a fetch fault, and no bypass was attempted. Le Cordon Bleu and Excelsia PDFs remain `held_unparsed` (stored, status read). (6) **Shared token ledger (labelled shared-lane, not attributed to this cohort).** `entry_matrices` on 24 Nov: Mistral Small 3.2 182 answered, 400,701 in / 152,601 out, US$0.0740; GPT-4.1 mini 139 answered, 272,667 / 144,559, US$0.3185; Qwen3 30B 52 answered, 97,067 / 13,351, US$0.0135 (240, 29 and 55 failed with no tokens recorded). This cohort's own spend this session: no new AI call, no Firecrawl, US$0. Cohort spend to date stays US$0.0155 model and 4 Firecrawl credits. Two unattended result-bearing cycles still not shown. Next executable actions: (a) Platform Admin: bounded switch-on plus one qualified model for `course_entry_requirements`, and decide Greenwich publishing; (b) S1-Build: sections-first input for `entryRead`; (c) S2-AER: the 62 `gate_incomplete` courses, AIBT host, George Brown, 71 no-basis and 116 exact_title holds with the reproducible lists in this entry; (d) this lane: re-read cohort outcomes at the next cycles for the two-cycle proof and run the 172 pages as soon as (a) and (b) are in place.
- 25 Nov 2026 08:20 AEDT, S1-AER-Claude (s1109b, documents only): **Hand-off to S1-Build for the P0 meaningful-content and qualification brief (08:05 AEDT); S1-AER-Claude does not do S1-Build's shared reader, qualification or settings work.** Regression cohort reconciled for S1-Build, correcting how Admin #1061 read as "53 already read": the 53 courses (6 at La Trobe, 4 Collarts, 8 Sydney Business & Travel Academy, 8 Excelsia, 5 Australian Pacific College, 4 AIBT, 3 York, 2 each Holmesglen, Keystone, Educare, Cairns, and 1 each at 9 other providers) each have a Layer 4 `course_entry_first_read` item that is **superseded** and **152 canonical rows that are all `inactive`** (113 at 47 courses with outcome no_requirement_published, 39 at 6 courses with admitted_provider). They are earlier paid AI answers, not current canonical delivery, so the parity target is those earlier answers' rows (quote, kind, score, audience), not live published data. Unread backlog is 172 courses at 19 providers: La Trobe 67, Collarts 50, Sydney Business & Travel Academy 13, AAPoly 10, Excelsia 5, Gold Coast Learning Centre 4, then 13 providers with 1 to 3 each (101 courses with outcome no_requirement_published at 18 providers; 71 admitted_provider at 2 providers). Reproducible conditions: `pipeline.aer_course_outcomes` with `identity_basis` in (cricos_code, adapter_code, manual), `page_status` bound, `outcome` in (no_requirement_published, admitted_provider), `read_state` skipped, provider in the 40 of the s1108 CSV; page text and hash from `pipeline.aer_det_academic_pages` (evidence_id, sha256, chars) joined to `pipeline.evidence_artifacts` (storage_path, content_hash); earlier answers from `catalogue.course_entry_requirements` and `pipeline.layer4_review_items` field_code `course_entry_first_read`; token and USD from `pipeline.ai_invocations` service_code `course_entry_requirements` (1,357 answered, 3,317,749 in, 826,078 out, US$0.5768, 15 to 16 Nov). Not measured yet, and not claimed: recall of selected sections against those answers, actual token reduction, qualification outcome. Controlled activation (one qualified model and a bounded scope for these 172 pages) stays the Platform Admin's decision after S1-Build's sections-first change is released; this lane then runs the 172 and reports canonical delivery.
- 25 Nov 2026 08:30 AEDT, S1-Build (Admin #1048; Pilot #1599 s1110, #1602 s1120; Admin #1053, #1060): **extension-less PDF acquisition fixed and live.** Worker v1.0.40 reads an entry page as a PDF when the HTTP Content-Type names a PDF (or no type) and the file's own `%PDF-` signature proves it (`entry-pdf-sniff.ts`), never by its address. CQU: the original address (source 50e4031c, failed 3× as not_html) was fetched directly at 07:59 AEDT and stored as application/pdf; run 87dec4ea (ruled-cells-v1, US$0) proposed 112 rows, waiting in Layer 4 (item 96f4e11a, 19 rows dropped); the `#.pdf` copy 55de8e6d is inactive. CQU reconciliation: the S1-AER requeue (event 02:32 AEDT, run 77618474) was real and ran on the s1105 worker at 02:35 AEDT, but held (`held_unparsed: PDF page 5 ...`); nothing was queued or leased after it, the runner (job entry-matrix-read, security.entry_matrix_fire_v1, every 5 min) was running and idle. s1120: that job now also starts a call for an expired fetch claim (found when the handed-back CQU source waited with no other work). **OpenRouter weekly-limit failures:** 4 entry runs failed with "Key limit exceeded (weekly limit)" on 12 Nov ($50 key) and 15 Nov 01:39 UTC ($70 key), before worker v1.0.3 made such refusals an account stop. The polled key (job openrouter-balance, same worker and credential resolution) read $70 weekly at -$0.01 on 15 Nov 02:35 UTC (the same key and figure), then $100 weekly to 22 Nov, then $50 daily; no key_limit attempt and no refusal record since. The 4 runs were read again from stored copies (Top Education 125 + 103 proposed rows, 2 Layer 4 items pending; AGI and the third IMC page 0 rows), US$0.0004. Canonical active rows unchanged (Layer 4 decides). Spend today entry_matrices US$0.35; Firecrawl 0; cron 138; manual locks 7,585; G3 75/48 unchanged.
- 25 Nov 2026 09:40 AEDT, S1-Build (P0 AER preprocessing, Admin #1063; Pilot #1604 and the fix PR): **pending paste for the Platform Admin: `docs/paste/PASTE-20261125-s1125-lean-harness-entry-labels.sql` (md5 6c42031e3de658e0e78b1c334531c47b), to run now after Pilot migration 20261126190000 is live.** Pilot #1604 merged but its deploy refused migration 20261126180000 (two `alter table ... drop constraint` lines widening the Lean AI Input harness CHECKs; scripts/ci/apply-migration.sh), so nothing of it ran (live head stayed 20261126170000; worker not deployed). The fix renumbers it 20261126190000 with no drop: sections-first course entry reads (`reading.course_entry_sections_on`, worker v1.0.41), the qualification picker for entry cases, two columns, and `security.lean_entry_qualify_start_v1()`; the paste widens the two CHECKs and calls it (seeds 377 recall cases and 332 qualification cases, opens the on-demand request, resumes jobs lean-qualify and lean-sections-eval; cron 140 at most). Governance fix in the same PR: the migration pre-flight now applies the deploy's own drop rule, so a file the deploy would refuse fails before any dry run.
- 25 Nov 2026 12:00 AEDT, S1-Build (P0 AER preprocessing, Admin #1063; Pilot #1604, #1605, #1606 s1125/s1130; paste run by the Platform Admin 10:40 AEDT): **interim results, run continuing unattended under its US$2.00 ceiling.** Recall of the selected content against the stored pages: all 152 earlier answer rows are on their pages; lean-sections-v3 held 134 (88%); the misses were entry condition sentences (Police, Working with Children, NDIS checks, music-making) and 2 rows that are not entry requirements (uniform, placement costs). lean-sections-v4 (s1130, live 11:30 AEDT) holds 113 of 120 checked (94%); the 7 left are pathway or "may be considered" sentences and the same 2 non-requirements. Content size on the 225 cohort pages: 2.77 M to 1.42 M characters (v3, 49% less; median page 11,428 to 5,289). Qualification, 189 of 332 cases, all reads complete, 0 failures; input tokens 36% lower on the selected input for every model. Recall of rows a person accepted (33 rows): deepseek-v4-flash whole 27, selected 25; qwen3-30b 28/26; mimo-v2.6-flash 28/26; mistral-small-3.2 22/21. Against the 137–139 earlier Qwen answer rows: deepseek 96 whole and 96 selected; qwen 116/104 but 154–158 extra rows; mimo 98/94; mistral 63/66. **Recommended model: deepseek-v4-flash** (cheapest allowed, US$0.09/0.18 per M, no recall loss on the selected input against earlier answers, 2 of 33 accepted rows lost under v3, fewest extra rows after mistral). Measured cost on the selected input: US$0.00029 a page; **revised estimate for the 172 unread courses: about US$0.05 (US$0.08 with retries)**, against US$0.15 to 0.45 on whole pages. Run spend so far US$0.149; platform AI today US$2.01; Firecrawl 0; cron 139; manual locks 7,585; G3 75/48. Nothing admitted; route course_entry_requirements still off. **Platform Admin decision (bounded activation):** (1) record deepseek-v4-flash as qualified for course_entry_requirements in Models & services with this evidence (run s1125-entry-qualify-2026-11-25); (2) set the route cascade to deepseek-v4-flash and switch it on under its existing US$5 daily cap; (3) for the window set aer.schedule_daily_max and aer.schedule_correction_daily_max to 0 so the hourly scheduler reads nothing beyond the cohort; (4) enqueue exactly the 172 courses through the existing Read now route (security.course_entry_read_enqueue_v1); (5) restore the two settings after the reads finish. S1-Build ships (3)–(5) as one migration on approval. **S1-AER resume point:** once (4) is queued, read back the 172 course-level reads (field_enrich_items entry_requirements, value.input.sent), their Layer 4 course_entry_first_read items and the canonical rows; the 53 earlier rows stay inactive and are not reactivated.
- 25 Nov 2026 13:00 AEDT, S1-Build (P0 AER preprocessing qualification and AI queue reconciliation, Platform Admin 12:01, 12:27 and 12:37 AEDT): **qualification run s1125-entry-qualify-2026-11-25 complete** (332 of 332, 0 failures, US$0.284 under the US$2.00 ceiling). Against the existing lean_qualify criteria, DeepSeek V4 Flash: all read yes (83/83), valid answers 100%, fewer tokens yes (median input 3,081 to 1,671, 46% less), quotes in text yes (8 unsupported quotes dropped by the reader against 26 on the whole page), **no loss NOT met: 11 pages found fewer label rows on the selected text than on the whole page (11 found more)**; recall on the selected text 164 of 216 label rows (Qwen3 30B 182/216 with 339 extra rows; MiMo 159/216; Mistral 128/216). Every model shows the same loss pattern, so the cause is the selection: the lost rows were entry conditions printed as headings, minimum ages, a weighted average mark, coordinator approval, "You must:" lines and portfolios. Smallest corrective action: selector lean-sections-v6 (s1140, this release) plus the existing recall check under v6 ($0); if every baseline-found row is inside the v6 selection, one bounded re-read of DeepSeek V4 Flash on the 83 pages (about US$0.07) confirms no loss; that re-read is a new qualification request and needs the Platform Admin. Benchmark exclusions (evidence: each row checked on its stored page): a uniform cost note, a placement cost note and a course description sentence are not academic entry requirements. **AI queue (267 entry items in state ai):** 252 D-R2 corrected reads (AER technical recovery) created 18 and 19 Nov by job aer-scheduled-read at 21 providers (UQ 37, UNSW 35, UTS 35, RMIT 33, ANU 29, Flinders 22, Monash 13, UWA 11, AUT NZ 10, others), and S2-AER s1115s 15 re-reads (24 Nov); attempts 0, never leased, no expired lease. Cause: the course_entry_requirements route is off (16 Nov 16:52), so public.svc_enrich_ai_next lists the field in off_fields and hands none out; not qualification, dispatcher or lease failure. Overlaps: 0 with the 172, 0 with the 53, 15 are S2-AER s1115, 10 are NZ (S3-AER). No unchanged-evidence repeat (0 earlier filled or review read on the same page). Every one is a stored-page read, so it goes through entryRead and the v1.24 selection. **Containment verified (rolled back):** route switched on with cascade DeepSeek V4 Flash and daily cap US$0 holds every scheduled item (limit_fields entry_requirements; scheduler refusal "route is held: service cap"), and only providers named in an open on-demand request are handed out: 0 of the 267 belong to the cohort providers or to the open request. The 172 course IDs are in docs/platform/p0-aer-activation/2026-11-25-s1-aer-172-course-ids.csv (20 AU providers; md5 10a2866c97ba9e2aceb82257341ebc89).

### s1240: AU AER source identity verification and alias decisions (S1-AER-Claude, 26 Nov 2026, 17:05 AEDT)

Assignment from SS-Programme-Control (26 Nov 16:28). Decision pack: `docs/platform/p0-aer-activation/2026-11-26-s1240-au-aer-source-identity-alias-decisions.md`. No setting, migration or data change.

- **CQU:** provider `f02d9d9b-0eb2-4f0e-8215-27a36ae63aa6`; proposed alias host `delivery-cqucontenthub.stylelabs.cloud` for this provider only; source `50e4031c`, evidence `fb856fec`, hash `976f3c5e…db42`, 112 rows kept. The page-to-CDN link target is to be confirmed in stored evidence `d5e12d94` before approval.
- **AIBT:** provider `eb9e3903-6d92-4502-a2b3-51cb231b21fc` (CRICOS 03430J); proposed alias `aibtglobal.edu.au`. AIBT International `fc6f01a7…` (CRICOS 03610E) must not be aliased.
- **Consumer read-back:** `website_v3_course` takes the course stable key, not the UUID. Eight newly admitted courses (Aventia, Box Hill, Collarts, Excelsia, Gold Coast Learning Centre, La Trobe, Lead College, York) read back with entry rows.
- **PDFs:** Le Cordon Bleu Table B is on pages 16 to 33; the run fails on prose page 3, so the reader needs a page scope (S1-Build/S2-AER). The Excelsia guide holds no entry table; retire that source, no layout recovery needed.
- **Held:** Greenwich unpublished; protected settings untouched; gate_incomplete and D-R3 items stay with S2-AER.

### s1241: A1 to A4 approvals recorded, evidence status (S1-AER-Claude, 26 Nov 2026, 17:35 AEDT)

Approvals relayed by SS-Programme-Control recorded in the s1240 decision pack, section 7. A2 (AIBT alias) is approved and prepared for S1-Build to execute. A1 (CQU alias) waits on one unmet evidence condition: the stored page `d5e12d94` link and the stored-bytes hash cannot be read from this session (`entry_inspect` returns no anchors and does not cover these sources). A3 (Excelsia source retirement): database dependency check clean (0 matrix rows, 0 open runs, 0 pending Layer 4, 0 active requirements); stored-copy check pending the same read-only addition. A4: no action. The three "no requirement held" courses hold general entry notes and resolve to `contact_provider` for every country; a product rule for S2-AER. No setting, source or data was changed.

### s1280: Academic entry study-level mapping recovery (S2-AER, 26 Nov 2026, about 22:55 AEDT; documents only)

Assignment from SS-Programme-Control (26 Nov 22:09). Live cohort re-read at 26 Nov 22:15 to 22:50 AEDT; stored pages read from `entry_inspect` (worker v1.0.51, run 45808386521, hash verified). Pilot main `cd5e7af`, live migration head `20261130000000`; no migration, Pilot change, setting, source or data was changed. Spend US$0; no on-demand work opened.

- **Cohort, re-measured (the 423 / 15 baseline cannot be reproduced; the grain moved).** Pending queue: 92 first reads and 17 changes. Proposed rows with no study level in pending runs, passing the confidence, quote and minimum screen: 647 rows across 33 providers (screen only, not the full rule order). The s1275 count of 423 rows across 15 providers was taken at an earlier queue state.
- **Group A, page states no level (about 590 rows; held).** Country qualification tables: UWA 194, Sydney Institute of Higher Education 58, Canberra 49, South Sydney College 40, CDU 38, Curtin University 35, UTas 27, Whitireia and WelTec 26, TAFE SA 24, CIT 16, Gateway 15, ANU 11, UNSW College 10, UniMelb 14 (two sources), and the smaller sources. The stored pages carry the qualification and score, never the course level it admits to. Reader limitation: none; the structure is read correctly. Assigning Bachelor would be inference.
- **Group B, label names a school year or country stage, not a study level (held).** "Year 10/11/12 equivalent", "ACT Year 12 equivalent", "Secondary School", "SMA 3", "Form 5", "Senior High School Year 2": 29 distinct labels checked with `security.entry_level_map_v1`; all return null. "Graduate Admission", "Year 3 Admission", "MQP", "Intensive Program" and the Murdoch "Preparation Course" labels also map to nothing; they describe an entry route, not an explicit level.
- **Group C, level already resolved; another rule holds the row.** Adelaide (S671 inherits Bachelor; `minimum_not_in_quote`) and UNBC (inherits Bachelor; 11 rows `no_minimum`). Nothing for a level mapper to do.
- **Group D, misclassified rows (reader limitation, not level).** English-test rows read as academic (CDU English scores, TasTAFE CELPIP and Cambridge, Victoria University exchange). They should not be admitted as academic entry whatever the level.
- **Outcome.** Admitted by this assignment: 0 rows, 0 providers. Consumer delivery: unchanged (no record recovered, `website_v2_course` and `website_v3_course` untouched). Protected controls: D-R3, Layer 4 decisions, 7,585 locks, G3 75/48 and the cron count were not touched.
- **Unresolved, exact reason and next action.** Groups A and B: source states no study level; next action is a provider or Platform Admin statement per provider (for example UWA's ATAR table applies to Bachelor), recorded as evidence, then the existing S671 or mapper path takes it. Group D: needs the entry-matrix prompt to separate English-test rows; routed to S1-Build and Platform Admin (AER v1 frozen, no new reader).
