**S1-Data-Gaps, 28 Nov 2026 07:48 AEDT (SS-Programme-Control 07:06, feedback and source integrity): no change; cause found for VU 092944A intake dates and decision S1-DG-8 raised. US$0, no Pilot change or PR.**
- **Cause.** VU's own `/international` course pages are refused as shared pages by the pattern `/international(-students?)?/?$` (220 AU pages, 103 VU), so intake reading stops at `course_identity_unresolved` for 092944A. A VU-only line in `binding.identity_exceptions` was rehearsed (rolled back): 102 of 103 pass, 092944A proved. It waits for the Platform Admin (S1-DG-8).
- **Verified, no change needed.** January is withdrawn on 092944A and not served. 115486F shows the registered total 135,200 and a derived annual 33,800; no Melbourne fee was copied. Batch 08 sources identity checked (UNE and TAFE Queensland on the right providers, no duplicates); apply not run yet (870 fees, 348 intakes as at baseline).
- **Canonical gains:** none. Feedback FB-4A.8-01, FB-4B.3-01 and FB-6.C04-01 notes updated; none resolved. Record: `docs/platform/data-ingestion/2026-11-28-s1-data-gaps-vu-feedback-source-integrity.md`.

**S1-Data-Gaps, 27 Nov 2026 16:48 AEDT (SS-Programme-Control 16:30, P0 production data delivery): no change; evidence-ready AU review pack and relink exception recorded. US$0, no Pilot change or PR.**
- **Canonical gains from this lane: none** (no writer; nothing admissible without a person or the reader). Relink took 164 of 227 (read 16:31); the reader has not read the bound candidates (152 found searches, 0 verified rebinds, 0 links changed). Recorded as the known reader exception; not investigated again.
- **Waiting for a person (live reads, 16:31 to 16:45 AEDT):** AU `judgement_ready` items: 66 academic entry and 22 English. Group A: 33 Newcastle entry rows that are scholarship offers (recommend Reject). Group B: 33 entry rows from 20 providers (Platform Admin review). Group C: 17 clean English requirements; group D: 5 with conflicting readings (Curator). The other 835 AU entry items are technical blocks (completeness gate and nothing_to_admit) owned by S2-AER.
- **Pack:** `docs/platform/data-ingestion/2026-11-27-s1-data-gaps-au-review-pack.md` and `.csv` (88 rows with Layer 4 item ids). Drive copy in the shared folder.

**S1-Data-Gaps, 27 Nov 2026 13:50 AEDT: s1306 live and read back (Pilot #1726, merge `b2aac678`, migration `20261130153000`; Admin #1292 merged first).**
- **Read back from the live database (rolled-back reads, 13:37 to 13:47):** migration head `20261130153000`; the three relink functions carry the change; audit event once; consumer API 75/48; locks 7,585.
- **Relink consumption:** by 13:46 relink had taken 96 of the 227 (Swinburne 58 trying, 14 absent; WSU 20 trying, 2 absent); 17 candidates read, all HTTP 404 or mismatch so far. Verified recoveries: 0 so far (a page counts only on a proved CRICOS code). Wave 2 (Sydney 240, Adelaide 215, Alberta 155, Torrens 46, UNSW 29) is not released until wave 1's yield is read.
- **Audience (Phase B inspection of stored copies, 100 pages):** CDU and WSU course pages carry both audiences with a toggle; Swinburne and Kaplan pages are mixed; no audience parameter was found, so no international address can be derived. Record section 12.7 to 12.9.
- **Spend:** US$0.

**S1-Data-Gaps, 27 Nov 2026 13:30 AEDT (S1-DG-6, SS-Programme-Control 13:07; Admin #1271): s1306 claimed and rehearsed, recorded before merge (Pilot #1726, migration `20261130153000`).**
- **Record:** `docs/platform/data-ingestion/2026-11-27-s1-data-gaps-international-source-integrity-batch1.md`, section 12.
- **Why the 227 were not taken (traced live, rolled-back reads):** course relink selects a page only when its read status is on `relink.statuses` or the page is on a retired host. The cohort's pages are `fetch_failed` (HTTP 404), on neither list. 156 earlier relink rows were also stuck `trying` after a person's Find course pages task reset their search rows on 12 Nov. Eligibility (`work_item_eligible_v1`) and the asked signal (`source_proof_relink_asked_v1`) were not the cause.
- **Change:** three existing functions (`course_relink_provider_v1`, `course_relink_order_v1`, `course_relink_tick_v1`; live source checked by md5 against the s1196 text) take a page that failed with HTTP 404 or 410 while a relink request is queued for its course, and relink leaves out an address its own earlier attempt already tried. No new job, queue, scheduler, table or setting. Rehearsed after the migration: Swinburne 105 courses given candidates (15 absent), WSU 24 (2 absent). No page is counted recovered until the reader proves the CRICOS code.
- **No_route classification (5,025):** no page row 1,686; read with identity 1,665; gone page 1,029; fetch failed other 212; blocked 164; robots disallowed 149; unread 95; too thin 13; needs render 9. Only the gone pages go to relink, per provider, never all at once.
- **Decision S1-DG-7 raised:** approve `hbook.westernsydney.edu.au` as a WSU extra domain so discovery maps the current handbook (no URL guessing, no host replacement).
- **Spend:** US$0. **Test register:** `cf-247-s1306-s1-data-gaps-relink-gone-pages-contract`, 4 tests.

**S1-Data-Gaps, 27 Nov 2026 12:40 AEDT: s1302 live and read back (Pilot #1721, merge `de566f66b`, migration `20261130134500`; Admin record #1282 merged first).**
- **Read back from the live database (rolled-back reads, 12:30 to 12:38):** migration head `20261130134500`; the 227 requests are queued for relink (Swinburne 176, WSU 38, CDU 9, Kaplan Business School 4); the audit event is recorded once; consumer API 75/48; manual locks 7,585; active cron jobs 133 to 136 across the reads (other lanes toggling, none added by this change, checked inside the migration).
- **Not yet shown:** four minutes after deploy the relink job had not yet taken the queued requests. The earlier relink rows were unchanged in shape (Swinburne 140 trying, 29 absent, 1 found; WSU 28 trying, 10 absent, 3 found; CDU 22 absent; Kaplan Business School 5 absent). No relinked or rebound page is claimed. Next read: relink outcomes per provider, then the pages bound by CRICOS proof.
- **Spend:** US$0. **Test register:** `cf-247-s1302-s1-data-gaps-relink-priority-providers-contract`, 3 tests.

**S1-Data-Gaps, 27 Nov 2026 12:20 AEDT (S1-DG-5 option A, SS-Programme-Control 12:00; Admin #1271): s1302 claimed and rehearsed, recorded before merge (Pilot branch `s1-data-gaps-s1302`, migration `20261130134500`).**
- **Record:** `docs/platform/data-ingestion/2026-11-27-s1-data-gaps-international-source-integrity-batch1.md`, section 11.
- **Measured (stored worker data, $0):** Swinburne has 165 bound pages that return HTTP 404 and WSU 35 (retired year handbook paths); 227 courses at Swinburne (176), WSU (38), CDU (9) and Kaplan Business School (4) are parked as held, no route.
- **Change:** one counted update moves those 227 requests to the existing relink route. No link, page, value, lock, job or setting is written. Rehearsed rolled back on live: 227 queued, cron 135, locks 7,585, consumer API 75/48.
- **Not done, with reason:** no page was opened from this session, so no audience is proved and no link is admitted. The 33 suspect links, the CDU Master of Engineering 107552A identity and the WSU Graduate Diploma year path wait for S1-Build's worker verification or the relink result. Kaplan's 5 unlinked courses already had three futile relinks and are not requeued.
- **For S1-Build:** 5,031 requests platform-wide held `no_route`; the year rollover refuses a host change or year range (WSU `handbook.` to `hbook.`).

**S2-RM-Design, 27 Nov 2026 12:05 AEDT: DR-19 s1295 live (Pilot #1718, migration `20261130120000`) and read back; operational acceptance shown on a live record.**
- **Paging (live):** UNSW (667 courses), page 2: offset 150, 150 read, next 300, 367 remaining, in 1.24 s against the 8-second limit.
- **Acceptance (one record end to end):**
  - **Diagnosed:** account refusal ("HTTP 403 Key limit exceeded"), now a resolved absence.
  - **Routed:** the s1277 hand-back.
  - **Processed:** filled by the pinned qwen3-30b route on 26 Nov at 22:51.
  - **Recovered:** class `verified`, applicability `international_source_verified`.
  - **Delivered:** Website v3 serves it matching the catalogue exactly (`served_and_verified`, `matches_canonical = true`).
  - The example is an operational failure. No unsupported-source case has completed the chain yet.
- **s1277 overall of 554:** 47 filled, 472 evidence holds, 8 sent to Layer 4, 27 leased.
- **Guardrails:** G3 75/48, locks 7,585, cron 134.

**S1-Data-Gaps, 27 Nov 2026 (International Course Source Integrity, SS-Programme-Control 11:28; Admin #1271): batch 1 recorded. Read only; no spec, migration, link, recipe or value changed; US$0.**
- **Record:** `docs/platform/data-ingestion/2026-11-27-s1-data-gaps-international-source-integrity-batch1.md`.
- **Measured:** Swinburne 411 active, 172 without a current official link; CDU 175, 21; Kaplan Business School 34, 5; WSU 306, 29. All five provider recipes are generic domain patterns, none audience-qualified.
- **33 suspect links** (international-tagged, domestic path): Canberra Training School 17, Step Into 5, others 11 (AU 32, NZ 1). Suspects only; a URL is a signal, not proof.
- **Observed patterns (unqualified, search extracts):** Swinburne has a dedicated `/study/course/international/` path plus a banner switch; CDU is one shared URL with an audience header and `?year=`; WSU is a shared handbook (current `hbook.` host, retired year paths).
- **Identity suspects:** WSU Graduate Diploma in Health Service Management links to the retired 2023-2024 handbook path (same CRICOS 0101796, not a missing course); CDU Master of Engineering 107552A (156 weeks) points at the 2-year `seng02` page.
- **Limit:** no rendered page was opened (no SQL-readable page text, shell has no provider access). Nothing is verified.
- **Decision S1-DG-5 (open):** worker-path verification of the named cohorts, then corrections only through `cf245_admit_official_url_record_v1` or the Layer 4 course-link route.

**S2-RM-Design, 27 Nov 2026 11:45 AEDT (DR-19 slice 4, SS-Programme-Control 11:28): s1295 claimed and rehearsed. Recorded before merge.**
- **Paging:** `public.admin_pim_provider_trace_v1(provider, field, class, limit, offset)` pages at `pim.trace_page_size` (150) and accounts for the whole provider (`active_courses`, `next_offset`, `remaining`, `complete`). Rehearsed on the largest provider (UNSW, 667 courses): a 67-course page took 504 ms, so a 150-course page takes about 1.1 s against the 8-second limit.
- **International applicability:** six evidence-only states, taken from the link audience (S1-Build source integrity) and the held rows, never from a URL; s1294's domestic-path suspects read as ambiguous. On UNSW descriptions, page 1: 100 international source verified, 50 not checked.
- **Recovery cause:** taken from the route register, attempts and planner state. On UWA academic entry: 33 identity unproven, 17 insufficient evidence, 22 no eligible work from the planner.
- **Knowledge:** history lists the course's integration issues and the recovery-knowledge patterns their remedies use, referenced rather than recorded again.
- **Not built here:** the common reader-creation interface (S2-Build). Frontend exposure is for the Admin UI owner through the existing admin reads.

**S2-RM-Design, 27 Nov 2026 00:28 AEDT (scheduled DR-19 check): s1277 realised gain.**
- **Of 554 handed back:** 13 filled (all descriptions), 176 skipped, 5 sent to Layer 4, 27 being read, 333 waiting; 0 refused again by the account.
- **Field-level check:** all 13 filled descriptions are verified in the catalogue and served by Website v3 matching the catalogue text exactly.
- **The skips are evidence holds, not operational:** sentence count 13, insufficient verified course facts 10, date not in the quote 11, quote not on the page 5, rolling applications 5.
- **Spend:** AI spend since midnight is US$0.05.

**S2-RM-Design, 26 Nov 2026 23:20 AEDT: DR-19 s1282 live (Pilot #1698, migration `20261130040000`) and read back. s1277 realised gain measured at the field level.**
- **s1282 live:** the trace returns cause, second opinion and audience; policy `ai_account_refusal` is present; G3 75/48, locks 7,585, cron 135.
- **s1277 realised (23:13) of 554 handed back:** 5 filled, 109 skipped, 2 sent to Layer 4, 27 being read, 411 waiting. AI spend today is US$3.23 of the US$10.00 ceiling.
  - All 5 filled descriptions are verified in the catalogue and served by Website v3 matching the catalogue text exactly (`served_and_verified`, `matches_canonical = true`).
  - The skips are genuine evidence holds (date not in the quote 11, quote not on the page 5, rolling applications 5, sentence count 7). They are insufficient evidence, not account refusals.
- **Open:** the Platform Admin decision on the human-assisted stronger-model step (off, no pinned model). S2-AER and S1-Build to name the four domestic-labelled requirements by course. S1-Build to check the entry-route spend (US$1.94 against US$1.00) and to make account refusals non-counting in the worker. S1-RM-Design to update the field register's academic_entry producer.

**S2-RM-Design, 26 Nov 2026 23:05 AEDT (DR-19 slice 3, SS-Programme-Control 22:32): s1282 claimed and rehearsed. Recorded before merge.**
- **Causes kept apart** under the stable class: account refusal (configured `service_limit` rows), technical failure, insufficient evidence, no source, unproven identity.
- **Second opinion:** the trace names the existing human-assisted recovery class and reads its stronger-model step live. It is off (`har.ai_escalate_on` = 0) with no pinned model, so no AI second opinion runs. Switching it on is a Platform Admin spend and qualification decision.
- **Audience:** held entry and fee rows by audience. In the UWA rehearsal, 2 of 40 courses hold only domestic entry rows. The v3 resolver serves no domestic row (0 of 2,607 courses holding them, for an India applicant). The four domestic-labelled requirements in API responses need naming by S2-AER and S1-Build.
- **Retained strategy:** recovery policy `ai_account_refusal` (defer and recheck, no attempt used).
- **Budgets:** AI ceiling US$10 a day and paid cap US$5 a day (live settings). The entry route is set at US$1.00 a day but spent US$1.94 today. No US$5.00 AER-only setting exists.
- **s1277 realised (22:49):** 52 skipped, 2 to Layer 4, 500 waiting, 0 filled.
- **Guardrails:** G3 75/48, locks 7,585, cron unchanged, no new spend.

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

**S2-RM-Design, 26 Nov 2026 22:25 AEDT: DR-19 s1277 live (Pilot #1690, migration `20261130010000`; dry run and test evidence green after one s42 fix: the recovery function is quoted `$function$`).**
- **Read back live:** the recovery ran at deploy (22:18): 554 items handed back to the existing AI worker (506 descriptions, 45 deadlines, 2 intakes, 1 English) and 554 absences resolved; 0 eligible operational failures left.
- **Not yet claimed:** at 22:22 all 554 were still `ai`. The measure's `cost_usd` (US$0.23) is the cost already recorded on those items from earlier attempts, not new spend. AI spend today is US$3.11 of the US$5.00 ceiling.
- **Realised gain:** fields filled, and descriptions served by Website v3 equal to the catalogue, are read by `security.pim_operational_recovery_measure_v1` and the record trace at the next check.
- **Guardrails:** G3 75/48, locks 7,585, active cron 137 (s1277 adds none and asserts the count unchanged).

**S2-RM-Design, 26 Nov 2026 22:15 AEDT (DR-19 slice 2, SS-Programme-Control 21:36): s1277 claimed and rehearsed: operational-failure recovery, resolution history and field-level delivery. Recorded before merge.**
- **Diagnosis:** the 554 open absences are account refusals (OpenRouter weekly key limit and HTTP 401), not evidence. Their items used all 3 attempts during the outage. They were due again from 13 to 23 Nov, but nothing re-read them: the worker claims only items in state `ai` under 3 attempts.
- **Recovery (live on deploy):** each item goes back once to the existing AI worker (attempts at most 2, so the cap of 3 holds). Manual locks are honoured and the absences resolved; nothing is deleted. Rehearsed: 554 handed back (506 descriptions, 45 deadlines, 2 intakes, 1 English) and 0 eligible left. The estimated cost is about US$0.21 within the worker's caps; today's AI spend before this is US$3.04 of the US$5.00 ceiling.
- **Configurable classification:** three `recovery_error_classes` rows (`service_limit`) name the refusal wording.
- **Trace additions:** resolution history (resolved absences; Layer 4 decisions with change references) and field-level Website v3 delivery set against the platform state. Presence is never treated as accuracy.
- **Routed:** academic entry still shows "no automatic producer" (`field_register.reader = none` despite the s1274 planner step; S1-RM-Design). Refusals still count as attempts in the worker (S1-Build). Today's course_entry_requirements AI spend was US$1.94 against s1261's US$1.00 a day route (S1-Build to check).
- **Guardrails:** G3 75/48, locks 7,585, cron unchanged, no new job.

**S1-Data-Gaps, 26 Nov 2026 20:20 AEDT (Atlas brief 19:50, Platform Admin Portal UAT data-gap pass): CA international eligibility, $0 intakes and official URL alignment audited; read only, nothing written, no spec or migration claimed.**
- **Record:** `docs/platform/data-ingestion/2026-11-26-s1-data-gaps-ca-eligibility-intakes-url-audit.md`. Every figure was read through the hand-started rolled-back rehearsal (no interactive SQL).
- **International eligibility:** all 3,829 CA courses are `open_to_international = true` from an `institution_rule` with no page evidence; 288 nursing and regulated-health courses (96 nursing and midwifery, 192 other) at 40 providers, all true, none locked. No stored statement says domestic-only for Canada (false readings platform-wide: AU 4, NZ 265, CA 0). `security.enrich_apply_v1` fills only a null flag, so the governed path cannot lower a `true`; nothing was set.
- **Intakes:** 3,160 future-dated (9.2%); 19,951 stored pages read with evidence; `fid-det-sweep` (active) has processed 11,982; 7,133 bound pages remain, 211 in its provider types (they drain on their own) and 6,922 outside `fees.provider_types` (AU private VET 6,141, NZ private VET 447, AU schools 246, NZ wānanga 88). Observed yield 185 of 15,209 pages (1.2%), so about 80 more courses at most. The 7 past-only rows and the 14 intake locks are untouched.
- **URLs:** 146 courses hold an active URL whose own page failed identity or host (CA 64, NZ 47, AU 35); 123 are manual-locked and 23 are not. `needs_better_source_url` is the existing Course page needed queue (Decision 179: a held page stays with a person). Nothing was moved.
- **Decisions needed:** S1-DG-1 (CA domestic-only reader, step one read-only), S1-DG-2 (`fees.provider_types` for private VET, schools and wānanga), S1-DG-3 (the 23 courses).
- **Guardrails:** live head `20261129210000`; G3 75/48 untouched; manual locks 7,585; active cron 137 (none added); US$0. TEST-REGISTER unchanged (no test added, changed or retired). The Drive running build document is not editable by this connection; its entry text is in the record (section 7).

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

**S2-AER (was S2-RM-Design), 26 Nov 2026 17:05 AEDT (Atlas brief 16:22: Portal UAT data-gap pass over 34,362 published-provider courses): read-only audit; no backfill shipped; nothing written.**
- **Audit:** `docs/platform/2026-11-26-portal-published-course-gap-audit.md`.
- **CRICOS:** 0 missing; all 24,013 AU courses carry a code, served by Website v3 and portal detail.
- **Campus city:** already unambiguous and served for a further 15,469 courses (no primary campus, all campuses in one city). The card's "Not recorded" is a mapping gap for S2-Build and S1-API-Frontend-Delivery. 8,509 multi-city courses need evidence; no manufactured primary.
- **Fees:** 15,585 courses hold only the register total. An annual figure from it would be inference. One canonical fee is `portal.primary_fee_v1` (s1222).
- **Intakes:** 3,160 future-dated (9.2%); 20,711 with no row; nothing staged waits (S1-RM-Design).
- **Description and URL:** 18,261 and 10,624 missing (S1-Build).
- **AER:** `IN` at providers covering 8,449 courses, `NP` 5,170; 0 matrix rows without a country. Coverage grows only by admitted reads.
- **Not changed:** no spec claimed, no migration, no test change. G3 75/48, locks 7,585, cron 135, $0.

**S2-RM-Design, 25 Nov 2026 00:16 AEDT (scheduled read-back against the 22:15 baseline): 3 first reads approved by a person; Website and Zoho v3 verified; no machine admission.**

**SCH-FU-04 / S3-Scholarship-ChatGPT — 26 Nov 2026 15:16 AEDT, autonomous acceptance.** Request 625e62fc remains closed (84/84 FC, audit 68201), never reopen. NZ 120 published/13 providers, 86 active unpublished, 206 combined active; one publication fewer since closure, no new NZ candidate reads or admission events. R0 linked 606: 237 read, 367 unread (Auckland69, Canterbury295, Otago3; ordinary cap held), 4 read-undecided (Otago3, VUW1), no leases. Existing W01 45 IDs retained. No eligible due unleased candidate, queued NZ AI item, or publishable unpublished award. Holds overlap: 55 missing value, 39 closed, 3 resident/citizen, 2 edition. Scheduled NZ FC1 since closure, no NZ AI extraction records; account 60925, OpenRouter US$91.55; G3 75/48, locks7585, cron138. Data Delivery security.data_delivery_v1() NZ120/13 published, 8 admitted-not-published providers, 9 domestic/ineligible, 58 insufficient evidence, 1 not attempted/vendor failure, 200 searched-none; 17 NZ pending reviews. Global stream 1753 reading/72 review/617 decisions in 24h, 256 read and 24 publisher successes, recovery healthy; Website global 1206/1206 matched; Zoho comparison unavailable, stages null. Not evidence of two NZ result-bearing end-to-end cycles after closure.

**Shared code coordination: proposed s1236**, not found in Pilot/Admin searches; S1-Build must confirm reservation and ownership before release, coordinate S1-Scholarship-Claude and S2-Scholarship-Readers. WITT listing 1751 zero sections, candidate 48478 listing_page rejection; exact stored source 0071e251-23a7-436d-b446-2ed042c2bdca SHA256 0adf7961337837dbc51fa6d43550026af9d5a2be0688eaf3423583ec9dfc9319. Official https://www.witt.ac.nz/international-students/international-scholarships has programme/benefit table and 2027 international tuition eligibility. Extend existing label splitter, no new reader; exact row scope, exclude n/a/pending approval/missing course page/ambiguous duplicate names; preserve shared terms, require provider/course identity, fail closed. A reconstructed fixture is not qualification against stored raw bytes. Lincoln extraction 76851, evidence 1948b015-e6b5-4d4e-a3c9-d71b101d71c6: verified NZD15000 A average, NZD10000 B average, two academic_minimum criteria and full taught masters scope; canonical dac3ea6d-9a89-5fe5-a784-6b8923bbb9ac scalar 15000 not marked maximum, two coverage rows, zero tiers/academic criteria, 14 mappings. Conditional benefit may be overstated. No NZD7000 or B+ inference; no AND combination of grade alternatives. Five unmatched: li7770 Global Management and Marketing, li7772 Finance (title candidates only), li7580 Planning (duration unproved), li0426/li7403 Landscape Architecture (ambiguous credits), Parks Management no matching title. Verify exact programme/duration, preserve existing links; shared existing normaliser/matcher correction via governed integration, replay checked stored answer, no direct canonical writes or consumer API change. NZTC publication/consumer proof retained. Acceptance requires two scheduled result-bearing acquisition/read→checked extraction→admission→automatic publication→consumer lineage cycles. No new queue/scheduler/spend or cap bypass. Continue existing claims and eligible stored recovery. S1-Build owns register regeneration.


**S3-Scholarship-ChatGPT / SCH-FU-04 — 26 Nov 2026 10:41:45 AEDT: request 625e62fc-fd69-47d1-9858-216dcb4a76e7 CLOSED.** Admin #937 / Pilot #1574 / Admin #981. Expired 25 Nov 03:40:21 AEDT; 0 active candidate, listing or AI leases at closure, exact five NZ providers/purpose/cap rechecked under lock. Existing `security.on_demand_close_v1` executed; production readback state closed, audit 68201. 84/84 Firecrawl credits consumed (sch_scrape), account 61,289 credits and OpenRouter US$91.64 at closure; report US$1.3538 all-lane AI window, not request-attributed. NZ Qwen3-30B scoped-provider extraction records within original authority window: 240, 377,341 input/214,699 output tokens, US$0.12089247, 20 errors (records, not proved distinct vendor calls). No new vendor acquisition or policy change in closure operation. Four original capped providers Auckland/Canterbury/Otago/VUW are again held by ordinary controls; Lincoln not held. Do not reopen/extend.

**Delivery proof:** initial 84/84 listings and 501 sections recorded earlier; linked candidate universe expanded to 606 (237 read, 367 unread, 2 other, 4 read-undecided), 0 leases. Scoped-provider admissions since opening 35 (34 during original authority window): Canterbury 26, Auckland 3, Lincoln 3, VUW 2, Otago 1 after expiry. Seven of these currently published and Website v3 SQL RPC returned all seven. Country-wide NZ 112→121 published (+9), 12→13 publishing providers, 54→86 active unpublished, combined 166→207 (+41); country-wide changes not attributed solely to request. Five result-bearing NZ automatic publication cycles on 24 Nov 22:29 (1), 23:29 (2), 25 Nov 00:29 (1), 01:29 (1), 02:29 (4); nine publication events, not necessarily nine distinct newly admitted awards. Lincoln Master's candidate 44346 admitted/published as dac3ea6d-9a89-5fe5-a784-6b8923bbb9ac, 14 mapped courses; extraction 76851 checked true, evidence 1948b015-e6b5-4d4e-a3c9-d71b101d71c6, records NZD15000 A average and NZD10000 B average (not B+), no NZD7000 proof. Canonical scalar amount 15000, zero tier rows, no canonical academic criterion; 5 named programmes unmatched. This is incomplete tier/grade/course mapping, not verified benefit-tier acceptance. NZTC candidate 48781 admitted/published as 93166720-cea2-5d96-a70a-186cfe37e751 NZD10000 with one mapped programme. Website v3 and Zoho v3 SQL RPC readback confirmed both, Zoho matches 14/14 and 1/1 respectively. No external Wix/Zoho credentialled HTTP proof. WITT candidate 48478 rejected `listing_page`, stored evidence 0071e251-23a7-436d-b446-2ed042c2bdca; amount NZD1500 is one programme row, not an umbrella award; preserve gate and recover individual programme rows through existing reader.

**Continuation:** 86 active unpublished NZ; 0 pass current publication checks. Holds (overlapping): 55 no stated value, 39 closed, 3 citizen/resident restriction, 2 another edition. Verified-benefit replay query found no eligible missing scalar value; no unleased due eligible candidate or queued NZ AI item in focused checks. Four scoped universities ordinary cap-held; preserve 367 unread linked candidates for normal eligibility/cadence, don't reset retries. Review exact Lincoln tier/grade mapping defect and WITT listing split through existing qualified/gated reader path with Integration Controller, retain W01 claims (#1024/#1034), continue eligible NZ providers as they become due. No direct canonical edits, no new cron, request, pipeline or cap. G3 75/48 drift [], manual locks 7585, active cron 138 at 10:41. S1-Build canonical register writer; country-wise Sheet evidence and Running Build checkpoint follow. Completion of request closure does not close SCH-FU-04 whole territory.

- **Active matrix rows:** 7,261 → 7,263 (+2 net). Five rows were made active from three Layer 4 first-read approvals: Australian Institute (23:18; AU Year 12 and AQF Certificate IV, bachelor), Conestoga College (00:18; CA OSSD 65%) and Simon Fraser University (00:18; CN Senior Middle School).
- **Pending:** first-run reads 65 → 68 (new reads for Quality College of Australia and Victoria University, 23:45); change items 13, unchanged.
- **No change:** covered courses 10,729 (the coverage table refreshes in chunks); active course rows 27,969, with none new; machine admissions in the last 24 hours: none (the 9 earlier declines have aged out).
- **Consumer check:** a Conestoga bachelor course (country CA) resolves `provider_minimum` on `entry_resolve_v3`; Website v3 and Zoho v3 `item.entry` both serve "OSSD … minimum cumulative average of 65%", as at 24 Nov 2026. A Simon Fraser bachelor course (CN) serves today's row on Website v3; that row prints no minimum (`scale none`).
- **Guardrails:** G3 75/48, locks 7,585, active cron 138, $0.

**S2-RM-Design, 24 Nov 2026 23:05 AEDT (AER admission validator and Layer 4 triage): 13 change items triaged; s995 re-rehearsed; no live change.**

**S3-Scholarship-ChatGPT / SCH-FU-04 — Admin #1030 execution, 25 Nov 2026 00:01 AEDT.** Existing R0 five and NZ-W01 45 provider IDs retained from #1024 (no reselection); independent official source discovery and verified existing evidence used without waiting for AI or another chat. Live NZ published 115/12 providers, active unpublished 72, combined 187 vs 166 at request opening (+21), 21 admission events; no additional publication above 115 since #1024. 545 scoped candidates: 150 read, 395 unread, 66 read-undecided, zero leases. Three new published awards verified previously via Website v3 and Zoho v3 (511 award-course associations); two result-bearing automatic publication cycles at 22:29 and 23:29 AEDT verified in #1024. No complete wave acceptance. New writes: Whitecliffe L1774/audit67087, Toi Ohomai L1775/audit67088, NZTC C48781/audit67095; Yoobee L1771 registered concurrently, not attributed or duplicated. Whitecliffe and Yoobee read zero sections, Toi Ohomai waiting_scraper; OP L1766 waiting_scraper, EIT L1767 read zero. NZTC source page verified international NZD10000 programme-specific benefit, candidate unread, no canonical identity inferred. Lincoln Manaaki is eligible for scheduled auto-publish; Master's 44346/89853 next 00:18:26 AEDT; WITT 48478/90564 next 00:25:40 AEDT. Full stored HTML unavailable in this connector; direct raw HTTP requests for IPU/WITT/Lincoln failed DNS resolution in this runtime, official indexed pages verified separately, no raw immutable evidence claim. No forced same-answer or paid reruns. Request 625e62fc-fd69-47d1-9858-216dcb4a76e7 open, cap84, used69, remaining15, expiry 03:40 AEDT; account62753, OpenRouter99.45, request-window all-lane USD0.2875. NZ Qwen 91 extraction records, 155036 input/81040 output tokens, USD0.0488562, 7 errors, not exclusively request/session-attributed. G3 75/48 no drift, locks7585, active cron138; no protected setting/API/cron or manual lock changes by this lane. Existing publication gate: Lincoln Manaaki eligible, remaining cases mostly closed, missing value, edition or residency; no global publish call. Actual per-provider window metrics below for S1-Build, who owns generated CSV and Sheet refresh. Resume: existing R0/W01 queues, independent individual official award sources where available, shared table/label mapping defects only through governed release, and settle/close request within expiry/cap.

**Provider-level continuation (same 50 claims; 25 Nov 00:01 checkpoint onward).** Prior publication baseline per row from #1024; provider-wide listings total/read/failed and candidates total/stored/read/unread/pending. New sections, A/R/D events, Firecrawl and AI extraction record/token/USD/error metrics from 24 Nov 23:54:12 AEDT (session start), not necessarily assistant-attributed; recorded zero is zero ledger events in window. Exact previously recorded official/source IDs/hash in preceding #1024 table; new evidence and source actions here. Unreviewed rows explicitly labelled reconciliation only. Steps 1–5 not completed merely by discovery or queued state.

| Wave/batch | Provider (UUID) | Active courses | Listings total/read/failed | Candidates total/stored/read/unread/pending | New sections | A/R/D events | Published before→now; unpublished; linked courses | FC units; AI model records/input/output/USD/errors | Execution outcome / blocker / next action |
|---|---|---:|---|---|---:|---|---|---|---|
| R0/1 | University of Auckland (`e096aba7-e1eb-4903-9a63-2bfb71e9a8b8`) | 458 | 36/31/0 | 1133/1063/1064/67/3 | 0 | 0/0/0 | 39→39; 16; 426 | 0; none | R0: stored CSC full tuition waiver (existing human-checked answer 33226; canonical value missing; v3 detail answer 39024 did not prove value). Existing tier normaliser/Controller review; no human decision overwritten or duplicate paid request. |
| R0/2 | University of Canterbury (`db910e88-67d1-4d2b-a65c-cea290aa0692`) | 282 | 41/37/0 | 637/309/309/328/45 | 0 | 0/1/0 | 3→3; 18; 255 | 0; qwen/qwen3-30b-a3b-instruct-2507 1/1615/751/0.0003868/0 | R0: existing candidate drain and verified published China/India High Achievers; retain existing request and queues. |
| R0/3 | University of Otago (`ab12c7f8-e368-453d-9dfe-4ab8bd744829`) | 252 | 15/11/0 | 205/205/205/0/13 | 0 | 0/0/0 | 22→22; 1; 250 | 0; none | R0: official pathway listing candidate 46566 stored evidence 5a1c9749-82d7-46fd-a731-39a3aba3d62d; checked NZD 15000 Global Scholarship appears within multi-award page, not a single award; section proof needed, no replay of identical AI. |
| R0/4 | Victoria University of Wellington (`34616965-b2b7-42a7-8da7-50ffbf120958`) | 273 | 4/3/0 | 126/126/126/0/9 | 0 | 0/0/0 | 14→14; 11; 263 | 0; none | R0: existing stored candidate adjudication; no duplicate reads. |
| R0/5 | Lincoln University (`248374d1-0629-41cd-a6f4-0804c422a4ff`) | 199 | 2/2/0 | 56/56/56/0/3 | 0 | 0/0/0 | 2→2; 5; 1 | 0; none | R0: Manaaki canonical b5731268-87c4-5bb2-ab98-623477bf3a1d publishable under existing gate; wait scheduled publisher; Master's 44346 evidence 1948b015-e6b5-4d4e-a3c9-d71b101d71c6, queue 89853 next 25 Nov 00:18 UTC? exact UTC 24 Nov 13:18:26Z = 25 Nov 00:18 AEDT. Official https://www.lincoln.ac.nz/study/scholarships/international-scholarships/ indexed source supports A average 15000 and B average 10000, not B+; 7000 not independently proved; full stored HTML access unavailable, no inference. |
| W01-B1/1 | NZIST Work-Based Learning (Competenz, Connexis, Careerforce, ServiceIQ, Primary ITO, EarnLearn) (`1b8f2f2f-d3d2-455e-a9fd-5a65744352ec`) | 229 | 0/0/0 | 1/1/1/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Claim retained; live counts reconciled only, source/eligibility outcome from existing W01 row; not processed anew. |
| W01-B1/2 | Ara Institute of Canterbury (`87576ec2-c4b0-4a00-ab94-64422c77d545`) | 178 | 2/2/0 | 75/41/41/6/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Ara 1750 read 33 sections, existing candidate settlement; no new verified award; preserve closed-round and provider gate. |
| W01-B1/3 | Toi Ohomai Institute of Technology (`38f8ea71-2269-407c-aab6-68a5f09fc01a`) | 157 | 1/0/1 | 17/17/17/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Official current hub https://www.toiohomai.ac.nz/services/fees-and-finance/scholarships new listing 1775 audit 67088; waiting_scraper failure, retry 25 Nov 23:58 AEDT, no override. Specific Southern Cross first-year nursing source does not by itself prove international eligibility; retain hold. |
| W01-B1/4 | Nelson Marlborough Institute of Technology (NMIT) (`dbf22c45-062e-4c5d-92a9-aaabd8c452f7`) | 148 | 1/1/0 | 27/22/22/5/17 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | NMIT official hub 1752 read; current 2027 school-leaver award up to NZD5000 for international students in NZ secondary schools, eligible Bachelor except nursing or civil engineering diploma; existing 18 sections/linked candidates settle; no duplicate. |
| W01-B1/5 | Manukau Institute of Technology and Unitec - MIT (`becd7287-5ede-4a62-800e-b2cd15d62c33`) | 144 | 0/0/0 | 10/10/10/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | MIT official international fee page https://www.manukau.ac.nz/study/international-students/how-to-apply/fees-and-study-costs/ does not prove named scholarship; no inferred entitlement. |
| W01-B1/6 | NorthTec (`d72e0120-a3a2-4909-8ddf-bcad1ec60150`) | 122 | 0/0/0 | 5/5/5/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Official https://www.northtec.ac.nz/info/scholarships school-leaver and study-progression explicit domestic eligibility; no acquisition for unchanged domestic offers. |
| W01-B1/7 | Universal College of Learning (UCOL) (`adeb0bbb-5b07-4130-aaeb-ad404bf40ff7`) | 115 | 0/0/0 | 4/4/4/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Official https://www.ucol.ac.nz/study-at-ucol/fund-your-study/scholarships/ucol-scholarships stored candidate 28266/evidence bd341b37-8f02-4c2b-a45e-e1f5961cc7bb; FAQ mentions international scholarships but no precise international amount/scope; prior human rejection preserved; no identical read. |
| W01-B1/8 | The Open Polytechnic of New Zealand (`f6b3e3a9-cc45-4770-8fb6-0d068f50732f`) | 93 | 0/0/0 | 3/3/3/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Open Polytechnic source search did not produce a current explicit international named award; prior stored verdicts retained. |
| W01-B1/9 | Western Institute of Technology at Taranaki (WITT) (`fd76fddc-fc8e-496d-bf89-c466d8efeb17`) | 89 | 1/1/0 | 4/4/3/1/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | WITT 1751 read zero, stored source 0071e251-23a7-436d-b446-2ed042c2bdca, SHA256 0adf7961337837dbc51fa6d43550026af9d5a2be0688eaf3423583ec9dfc9319; existing candidate 48478/queue 90564 next 25 Nov 00:25:40 AEDT; programme-specific 2027 tuition table, exclude n/a and pending NZQA approvals, no duplicate. Direct public raw HTTP failed DNS in session. |
| W01-B1/10 | Te Wānanga o Aotearoa (`ea0f4e14-e790-4c62-886f-3ec5bc040b4a`) | 86 | 0/0/0 | 1/1/1/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Official https://www.twoa.ac.nz/nga-tauira/te-kopuretanga-scholarships requires current learner portal for detailed conditions; no public international value/scope proof, preserve hold. |
| W01-B1/11 | New Zealand Management Academies Limited (`5e1a25b3-94d3-4e9a-8cc1-98dacd3bfd62`) | 78 | 0/0/0 | 4/4/4/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | NZMA public funding page https://www.nzma.ac.nz/courses/fees-free is a fees-free/trades-funding page, not proof of an eligible international scholarship; retain hold. |
| W01-B1/12 | New Zealand Institute of Skills and Technology (NZIST) (`27349414-019b-4c0b-a38d-db92aaaf5e68`) | 72 | 0/0/0 | 1/1/1/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Claim retained; live counts reconciled only, source/eligibility outcome from existing W01 row; not processed anew. |
| W01-B1/13 | Te Wānanga o Raukawa (`f145b8e9-36dd-4f96-b1f5-bb453ced3a45`) | 63 | 0/0/0 | 1/1/1/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Official https://www.wananga.com/fees-and-funding describes iwi/community funding, no verified eligible international provider-owned award; hold. |
| W01-B1/14 | Te Whare Wānanga o Awanuiārangi (`5c067273-5f41-4da0-a16c-b2eac17f4306`) | 52 | 0/0/0 | 7/7/7/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Official https://www.wananga.ac.nz/enrolment/paying-for-study/scholarships/ lists closed 2026 awards, no current verified international offer; preserve hold. |
| W01-B1/15 | Yoobee Colleges Limited (`e503631d-05b4-44dd-b438-77c9dfc0c1e5`) | 52 | 1/1/0 | 20/19/19/1/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Official https://www.yoobee.ac.nz/international-students/scholarships: two international awards with capped tuition reductions (25% general, NZD10000 Master's), listing 1771 registered concurrently; read zero sections, possible generic singular heading/value banner reader defect, do not duplicate source/lease. Shared reader fixture/Controller release only after stored markup verification. |
| W01-B2/1 | University of Waikato (`00e5f26c-446e-453c-a3fb-bc5239a4feec`) | 279 | 5/5/0 | 143/143/143/0/0 | 0 | 0/0/0 | 8→8; 1; 265 | 0; none | Waikato existing five listings read; ordinary cadence, no duplicate. |
| W01-B2/2 | Massey University (`229dc07d-c573-44a3-b5dc-cc423cc2c300`) | 265 | 7/7/0 | 447/447/447/0/2 | 0 | 0/0/0 | 17→17; 8; 220 | 0; qwen/qwen3-30b-a3b-instruct-2507 1/1575/962/0.0004461/0 | Massey 44334/44335 stored, Qwen 90075/90076 next 25 Nov 00:18 AEDT, no duplicate or retry override. |
| W01-B2/3 | Auckland University of Technology (`39301fa8-bff2-4389-bbcd-32d8415fae04`) | 257 | 4/3/1 | 25/25/25/0/4 | 0 | 0/0/0 | 1→1; 1; 2 | 0; none | AUT 1749 read 4 sections, existing candidates settle; no duplicate. |
| W01-B2/4 | Eastern Institute of Technology (`ea5a3fa6-31f4-4553-9cfd-6bff49c36a6b`) | 189 | 1/1/0 | 212/212/212/0/0 | 0 | 0/0/0 | 0→0; 1; 0 | 0; none | EIT listing 1767 read zero sections; review alternate official named award source and international scope, current Pharazyn record citizen/resident hold preserved. |
| W01-B2/5 | Otago Polytechnic (`cd27693c-6c80-42f4-8b76-1ed2d94e0b45`) | 182 | 2/1/1 | 15/15/15/0/0 | 0 | 0/0/0 | 3→3; 1; 21 | 0; none | OP listing 1766 waiting_scraper failure, retry 25 Nov 23:57:59 AEDT; do not reset unchanged retry. |
| W01-B2/6 | Waikato Institute of Technology (`742eef0a-1341-46ef-a4ab-4d105c47be9b`) | 144 | 121/109/3 | 163/163/163/0/6 | 0 | 0/0/0 | 0→0; 1; 0 | 0; none | Claim retained; live counts reconciled only, source/eligibility outcome from existing W01 row; not processed anew. Ordinary cap held; no bypass. |
| W01-B2/7 | The International Travel College of New Zealand Limited (`e037d54a-6735-4f60-818d-e2a077d436e8`) | 3 | 3/3/0 | 50/45/45/0/1 | 0 | 0/0/0 | 0→0; 1; 0 | 0; none | Historical ITC article 43849/43868; range and old offer not a verified current named award, no reopen. |
| W01-B2/8 | Te Aratika Industry Training Limited (`cad8ab1d-cb95-40a1-9d9f-da2bb53263b3`) | 1 | 0/0/0 | 88/88/88/0/1 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | NZQA national award candidate 28818 is not a Te Aratika institutional award; existing host gate overly permissive, do not admit. |
| W01-B2/9 | Manukau Institute of Technology and Unitec - Unitec (`66f6fcc9-15f8-46e6-b3b3-0576ab4bcce3`) | 80 | 10/9/1 | 115/115/115/0/0 | 0 | 0/0/0 | 2→2; 6; 25 | 0; none | Claim retained; live counts reconciled only, source/eligibility outcome from existing W01 row; not processed anew. |
| W01-B2/10 | Crown Institute of Studies Limited (`fefd6555-c2b7-43e4-93bc-a5e935ed4a01`) | 13 | 0/0/0 | 4/4/4/0/0 | 0 | 0/0/0 | 0→0; 1; 0 | 0; none | Claim retained; live counts reconciled only, source/eligibility outcome from existing W01 row; not processed anew. |
| W01-B2/11 | Tai Poutini Polytechnic (`faa04942-5af1-418c-8214-c5aa2523c39d`) | 42 | 0/0/0 | 1/1/1/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Claim retained; live counts reconciled only, source/eligibility outcome from existing W01 row; not processed anew. |
| W01-B2/12 | Skills Active Te Mahi Ako Limited (`0ede4eef-4117-4362-8a64-131efcb31c38`) | 41 | 0/0/0 | 2/1/1/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Claim retained; live counts reconciled only, source/eligibility outcome from existing W01 row; not processed anew. |
| W01-B2/13 | Future Skills Academy Limited (`a1a229cc-1915-475c-9d0a-727eeb45a20b`) | 36 | 0/0/0 | 2/2/2/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Future Skills source search did not produce a verified named international award; do not enqueue guessed URL. |
| W01-B2/14 | BCITO Limited (`7bf176e6-4c08-4068-a837-d991c5be8f22`) | 33 | 0/0/0 | 9/9/9/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Claim retained; live counts reconciled only, source/eligibility outcome from existing W01 row; not processed anew. |
| W01-B2/15 | Whitecliffe Education Limited (`29fabe13-e9fe-497c-ae2b-bd6d08b5c46b`) | 32 | 1/1/0 | 5/4/4/1/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Official https://www.whitecliffe.ac.nz/apply/scholarships/ new listing 1774 audit 67087; read, zero sections; individual current award links to inspect, domestic-only MBIL source excluded; no admission claimed. |
| W01-B3/1 | MITO Limited (`49852ffc-1db7-47ec-83aa-f8ff5ba1408b`) | 31 | 2/2/0 | 29/29/29/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Claim retained; live counts reconciled only, source/eligibility outcome from existing W01 row; not processed anew. |
| W01-B3/2 | Connexis Inc. (`0b99ef17-5251-4f65-b2ed-7b6909711df3`) | 20 | 0/0/0 | 23/23/23/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Claim retained; live counts reconciled only, source/eligibility outcome from existing W01 row; not processed anew. |
| W01-B3/3 | Bethlehem Tertiary Institute (`d5e0d1c6-9f24-4ce2-869e-dec769f4c3a2`) | 19 | 0/0/0 | 2/2/2/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Claim retained; live counts reconciled only, source/eligibility outcome from existing W01 row; not processed anew. |
| W01-B3/4 | Marine and Specialised Technologies Academy of New Zealand Limited (`5ac7d2c3-d3a6-48f1-ad44-178f5397ead5`) | 18 | 0/0/0 | 1/1/1/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Claim retained; live counts reconciled only, source/eligibility outcome from existing W01 row; not processed anew. |
| W01-B3/5 | New Zealand Tertiary College Limited (`8bd0b377-7722-41fa-be2e-0a0984e37f36`) | 17 | 0/0/0 | 3/2/2/1/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Official programme page https://www.nztertiarycollege.ac.nz/mtl-early-childhood-education-lp shows limited NZD10000 international offer; candidate 48781 audit 67095 newly registered, unread. Award name is descriptive only, preserve single-award eligibility and exact programme match. |
| W01-B3/6 | Soshi Gakuen New Zealand Incorporated (`51463a53-dd3f-4dfc-a6d8-bce081dacfb0`) | 16 | 1/1/0 | 2/2/2/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | IPU official https://www.ipu.ac.nz/international-students/enrolments-and-assistance/scholarships-1 lists SEG B/C 5000/3000 per year and mayor 1000 first-year tuition. Existing listing 419 zero sections; candidate 28366 evidence c4d5d699-0faf-43b6-b177-4590b729dccf. Reader split/ownership and current eligibility proof needed; no duplicate paid acquisition. |
| W01-B3/7 | Hair Industries Support Opportunities Charitable Trust (`dcbae90d-184a-4ef3-8ba6-445b1a1db5f4`) | 14 | 0/0/0 | 1/1/1/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Claim retained; live counts reconciled only, source/eligibility outcome from existing W01 row; not processed anew. |
| W01-B3/8 | Auckland Institute of Studies Limited (`a3fd5f9f-1ffc-4192-b458-ce1d7a7e87b3`) | 13 | 0/0/0 | 3/2/2/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | AIS official student-life page mentions academic tuition reduction but not precise international value, existing achievement-award candidate 28403/evidence ab6f7f37-d41b-43b4-8cbb-eabf6df93de1 rejected. No inferred amount or reopening. |
| W01-B3/9 | Te Rito Maioha Early Childhood New Zealand Incorporated (`e87c62e4-3fab-4c30-b3b8-efb5f6d133cb`) | 13 | 0/0/0 | 27/27/27/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Claim retained; live counts reconciled only, source/eligibility outcome from existing W01 row; not processed anew. |
| W01-B3/10 | Cavalli College Limited (`28f7449a-e676-498a-95c5-1800cceb678b`) | 12 | 0/0/0 | 2/2/2/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Claim retained; live counts reconciled only, source/eligibility outcome from existing W01 row; not processed anew. |
| W01-B3/11 | Pacific International Hotel Management School Limited (`55de2ff5-7a90-4899-b074-8803bfbe51d7`) | 10 | 0/0/0 | 2/2/2/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Claim retained; live counts reconciled only, source/eligibility outcome from existing W01 row; not processed anew. |
| W01-B3/12 | Apprentice Training New Zealand 2010 Trust (`5a29f893-d591-44ad-819b-0562566f1d18`) | 9 | 0/0/0 | 1/1/1/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Claim retained; live counts reconciled only, source/eligibility outcome from existing W01 row; not processed anew. |
| W01-B3/13 | School of Audio Engineering (NZ) Limited (`cc164a3e-f622-40ca-91fb-99b4a2defe88`) | 9 | 1/0/1 | 2/2/2/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Claim retained; live counts reconciled only, source/eligibility outcome from existing W01 row; not processed anew. |
| W01-B3/14 | Te Kōhanga Reo National Trust Board (`f8d06b5c-aed0-4704-8731-77ccb36e4a0f`) | 9 | 2/2/0 | 5/5/5/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Claim retained; live counts reconciled only, source/eligibility outcome from existing W01 row; not processed anew. |
| W01-B3/15 | Techtorium New Zealand Institute of Information Technology Limited (`9a6e3ec4-f640-442d-9b71-632508d1fcf8`) | 8 | 0/0/0 | 2/2/2/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0; none | Techtorium targeted official search returned no current international award; existing person refusal protected. |


**S3-Scholarship-ChatGPT / SCH-FU-04 — 24 Nov 2026, late-evening NZ-W01 provider checkpoint.** Prior #1016 merged-main records initial 84/84 listings, 501 sections. At 23:33 AEDT NZ 115 published/12 providers and 70 active unpublished (112/54 at request opening; +19 combined active); 19 admission events and 3 newly admitted published. Scoped request 625e62fc-fd69-47d1-9858-216dcb4a76e7 open, expiry 25 Nov 03:40 AEDT, FC69/84 and account 62894 at 23:33, all-lane AI USD0.2496. New independent official hubs Otago Polytechnic listing 1766/audit 67067 and EIT listing 1767/audit 67068 registered, waiting at readback. WITT listing 1751 returned zero sections; existing exact official HTML evidence 0071e251-23a7-436d-b446-2ed042c2bdca, SHA-256 0adf7961337837dbc51fa6d43550026af9d5a2be0688eaf3423583ec9dfc9319, evidence bucket verified, Qwen qualified route open. Stored replay candidate 48478/queue 90564, audit 67070, no new acquisition. Lincoln candidate 44346/queue 89853 still scheduled 00:48 AEDT, no inferred amount or grade. Publication gate later found 71 active unpublished, one publishable; closed/value/residency/edition holds preserved. G3 75/48 drift[], locks 7585, cron 137 at 23:33; no global settings or API changes. W01 same-cohort batches below retain first 15 IDs, next 30 ranked from live eligible catalogue; R0 scoped five tracked separately. S1-Build owns generated country-wise register sync. Continue existing processing, verify consumer and two result-bearing cycles, close request after settlement within expiry/cap.

**Provider-level checkpoint, same cohort:** 45 W01 providers selected (not completed), plus five R0. Provider-wide listing/candidate totals and linked courses are live; new listing/section/admission/FC/model figures are measured since 21:40 AEDT request opening, not solely attributable to this chat. A/R/D = admission ledger events, not unique canonical gains. Prior observed published counts used where available; otherwise current enrolment baseline. Sources are representative existing pointers, not exhaustive official-source inventory; candidate URLs may require ownership review. Unknown expenditure not inferred. Existing historical rejection reasons are retained; no human rejection reopened.

| Wave/batch | Provider (UUID) | Active courses | Official/source evidence pointer | Listings total/read/new | Candidates total/stored/read/unread/pending | Sections new | Admission events A/R/D | Published before→now; unpublished; linked courses | FC units (scoped); AI model records/input/output/USD/errors | Holds and next action |
|---|---|---:|---|---|---|---:|---|---|---|---|
| R0/1 | University of Auckland (`e096aba7-e1eb-4903-9a63-2bfb71e9a8b8`) | 458 | L1740 https://www.auckland.ac.nz/en/law/study-with-us/pacific-at-auckland-law-school/scholarships-awards-for-pacific-students.html (waiting); C32040 https://www.geothermal.auckland.ac.nz/lpdp-scholarship-2025 [evidence d8aef1e3-6cb0-443f-9c47-85d99a0bc81b] | 36/31/5 | 1133/1061/1062/69/1 | 67 | 0/1/0 | 39→39; 16; 426 | 3 (3); qwen/qwen3-30b-a3b-instruct-2507: 1/1778/994/0.000476/0 | another edition of this scholarship is listed; applications have closed; no stated award value; international_not_stated; listing_page; no_named_title; not_a_scholarship — settle existing reader/AI |
| R0/2 | University of Canterbury (`db910e88-67d1-4d2b-a65c-cea290aa0692`) | 282 | L1746 https://www.canterbury.ac.nz/news-and-events/news/2026/spring-scholarship-round-is-now-open (waiting); C46774 https://www.canterbury.ac.nz/study/getting-started/scholarships/equity-scholarships/equity-international-scholarships#award-s-university-of-canterbury-india-high-achievers-scholars [evidence f29df23d-1341-4b85-ba71-34c46cb82a33] | 41/37/4 | 637/304/304/333/49 | 404 | 16/6/1 | 1→3; 17; 255 | 4 (4); qwen/qwen3-30b-a3b-instruct-2507: 29/49945/28040/0.0134065/0 | applications have closed; no stated award value; international_not_stated; listing_page; no_named_title; not_a_scholarship — settle existing reader/AI |
| R0/3 | University of Otago (`ab12c7f8-e368-453d-9dfe-4ab8bd744829`) | 252 | L1743 https://www.otago.ac.nz/international/future-students/subjects-courses/postgraduate-study/scholarships/phd (waiting); C41413 https://www.otago.ac.nz/courses/scholarships/dr-sulaiman-daud-125th-jubilee-postgraduate-scholarship [evidence f1aed20d-044c-4e04-926d-40ff9bba2c4f] | 15/11/4 | 205/205/205/0/13 | 20 | 0/16/0 | 22→22; 1; 250 | 40 (40); qwen/qwen3-30b-a3b-instruct-2507: 17/27640/15093/0.0088199/1 | no stated award value; domestic_only; international_not_stated; listing_page; no_named_title; not_a_scholarship — settle existing reader/AI |
| R0/4 | Victoria University of Wellington (`34616965-b2b7-42a7-8da7-50ffbf120958`) | 273 | L1736 https://homepages.ecs.vuw.ac.nz/Users/Ian/SummerScholarships2011 (waiting); C47224 https://www.wgtn.ac.nz/scholarships/current/william-purdie-bursary [evidence fa071667-9476-40c6-808f-c61d4e084074] | 4/3/1 | 126/126/126/0/9 | 8 | 2/7/1 | 14→14; 11; 263 | 18 (18); qwen/qwen3-30b-a3b-instruct-2507: 13/24297/13142/0.0078789/1 | applications have closed; no stated award value; domestic_only; international_not_stated; listing_page; no_named_title; not_a_scholarship — settle existing reader/AI |
| R0/5 | Lincoln University (`248374d1-0629-41cd-a6f4-0804c422a4ff`) | 199 | L10 https://www.lincoln.ac.nz/study/scholarships/international-scholarships (read); C46564 https://www.lincoln.ac.nz/study/scholarships/international-scholarships#award-s-china-scholarship-council-csc-phd-scholarships [evidence 64f369cc-e67f-4649-a78d-86dc1ec2748e] | 2/2/0 | 56/56/56/0/3 | 2 | 2/2/1 | 1→2; 5; 1 | 4 (4); qwen/qwen3-30b-a3b-instruct-2507: 10/9443/5653/0.0071396/4 | applications have closed; no stated award value; international_not_stated; listing_page; no_named_title; not_a_scholarship — Lincoln candidate 44346/89853 retry due 25 Nov 00:48 AEDT; verify exact tiers |
| W01-B1/1 | NZIST Work-Based Learning (Competenz, Connexis, Careerforce, ServiceIQ, Primary ITO, EarnLearn) (`1b8f2f2f-d3d2-455e-a9fd-5a65744352ec`) | 231 | C27731 http://www.nzist.ac.nz/prime-ministers-scholarship [evidence a68da36c-6497-41ce-bcef-26ee46ded15d] | 0/0/0 | 1/1/1/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0 (0); no extraction recorded | domestic_only; listing_page — review existing verdict; no identical paid retry |
| W01-B1/2 | Ara Institute of Canterbury (`87576ec2-c4b0-4a00-ab94-64422c77d545`) | 178 | L1750 https://www.ara.ac.nz/student-services/supporting-your-study/scholarships/ (read); C28032 https://www.ara.ac.nz/student-services/supporting-your-study/scholarships/rama-family-trust-scholarship [evidence 64bc4ada-01c3-4f70-8590-fa26c85b8d36] | 2/2/1 | 75/41/41/13/0 | 33 | 0/0/0 | 0→0; 0; 0 | 1 (0); no extraction recorded | domestic_only; international_not_stated; listing_page; no named scholarship title; no_named_title — settle existing reader/AI |
| W01-B1/3 | Toi Ohomai Institute of Technology (`38f8ea71-2269-407c-aab6-68a5f09fc01a`) | 157 | C43500 https://www.toiohomai.ac.nz/tags/scholarship-winner [evidence 38601615-e0ee-460f-a9e0-f4669e54438f] | 0/0/0 | 17/17/17/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0 (0); no extraction recorded | domestic_only; international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B1/4 | Nelson Marlborough Institute of Technology (NMIT) (`dbf22c45-062e-4c5d-92a9-aaabd8c452f7`) | 148 | L1752 https://www.nmit.ac.nz/study/finance-your-study/scholarships (read); C43414 https://www.nmit.ac.nz/study/request-transcripts-and-awards [evidence ff731888-20e1-4040-b339-971f039f52b3] | 1/1/1 | 27/16/16/11/14 | 18 | 0/0/0 | 0→0; 0; 0 | 1 (0); no extraction recorded | international_not_stated; listing_page; no_named_title; not_a_scholarship — settle existing reader/AI |
| W01-B1/5 | Manukau Institute of Technology and Unitec - MIT (`becd7287-5ede-4a62-800e-b2cd15d62c33`) | 144 | C28265 https://www.manukau.ac.nz/research-and-publications/highly-commended-paper-award [evidence d61396c3-c120-48fb-b1b5-c9b48430531b] | 0/0/0 | 10/10/10/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0 (0); no extraction recorded | domestic_only; international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B1/6 | NorthTec (`d72e0120-a3a2-4909-8ddf-bcad1ec60150`) | 122 | C25413 https://www.northtec.ac.nz/post/yes-event-2023-awards-night-a-roaring-success [evidence 50988250-cbb0-4e35-ac46-0442bc25d42c] | 0/0/0 | 5/5/5/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B1/7 | Universal College of Learning (UCOL) (`adeb0bbb-5b07-4130-aaeb-ad404bf40ff7`) | 115 | C28269 https://www.ucol.ac.nz/study-at-ucol/fund-your-study/scholarships/te-mataora-maori-and-pasifika-trades-training [evidence cd42d8bd-ab8d-49fd-9b74-0bbb9b341623] | 0/0/0 | 4/4/4/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0 (0); no extraction recorded | domestic_only; international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B1/8 | The Open Polytechnic of New Zealand (`f6b3e3a9-cc45-4770-8fb6-0d068f50732f`) | 93 | C25417 https://www.openpolytechnic.ac.nz/maori/scholarships-for-maori [evidence a9f8f3f9-f200-4387-be9a-0c80a198879c] | 0/0/0 | 3/3/3/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0 (0); no extraction recorded | domestic_only; international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B1/9 | Western Institute of Technology at Taranaki (WITT) (`fd76fddc-fc8e-496d-bf89-c466d8efeb17`) | 89 | L1751 https://www.witt.ac.nz/international-students/international-scholarships (read); C28255 https://www.witt.ac.nz/make-a-financial-support-appointment-scholarships [evidence b30e56c1-4143-4f61-9b87-1ba6e87bb63d] | 1/1/1 | 4/4/3/1/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page; no_named_title; not_a_scholarship — WITT stored candidate 48478/Qwen 90564; validate programme tiers |
| W01-B1/10 | Te Wānanga o Aotearoa (`ea0f4e14-e790-4c62-886f-3ec5bc040b4a`) | 85 | C25414 https://www.twoa.ac.nz/nga-tauira/te-kopuretanga-scholarships [evidence 22d06848-5405-4948-9b60-d352c828c1f6] | 0/0/0 | 1/1/1/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B1/11 | New Zealand Management Academies Limited (`5e1a25b3-94d3-4e9a-8cc1-98dacd3bfd62`) | 77 | C28336 https://www.nzma.ac.nz/student-life/success-story-chelsea-wins-multiple-awards [evidence 697d01f3-cf15-42d3-85b4-2a103d934c5b] | 0/0/0 | 4/4/4/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B1/12 | New Zealand Institute of Skills and Technology (NZIST) (`27349414-019b-4c0b-a38d-db92aaaf5e68`) | 72 | C28337 http://www.nzist.ac.nz/prime-ministers-scholarship [evidence d475d91d-6f57-4bf1-a5e4-bf91a9a34837] | 0/0/0 | 1/1/1/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0 (0); no extraction recorded | domestic_only; listing_page — review existing verdict; no identical paid retry |
| W01-B1/13 | Te Wānanga o Raukawa (`f145b8e9-36dd-4f96-b1f5-bb453ced3a45`) | 63 | C28313 https://www.wananga.com/post/luke-rowe-recipient-of-the-2026-fulbright-ngā-pae-o-te-māramatanga-scholar-award [evidence 760c0e24-b900-49c3-b105-9c008058ca52] | 0/0/0 | 1/1/1/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B1/14 | Te Whare Wānanga o Awanuiārangi (`5c067273-5f41-4da0-a16c-b2eac17f4306`) | 52 | C25373 https://www.wananga.ac.nz/enrolment/paying-for-study/scholarships/masters-thesis-scholarships-thesis-only [evidence a5ff12e1-e555-4c71-9572-b7c9c96bd26d] | 0/0/0 | 7/7/7/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0 (0); no extraction recorded | domestic_only; international_not_stated; not_offered — review existing verdict; no identical paid retry |
| W01-B1/15 | Yoobee Colleges Limited (`e503631d-05b4-44dd-b438-77c9dfc0c1e5`) | 52 | C28332 https://www.yoobee.ac.nz/success-stories/award-winning-graduate [evidence fc8d35e1-2d14-4bf0-8069-73423970cb1c] | 0/0/0 | 19/19/19/0/0 | 0 | 0/0/0 | 0→0; 0; 0 | 0 (0); no extraction recorded | domestic_only; international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B2/1 | University of Waikato (`00e5f26c-446e-453c-a3fb-bc5239a4feec`) | 279 | L1 https://www.waikato.ac.nz/study/scholarships/find-a-scholarship (read); C29839 https://www.waikato.ac.nz/study/scholarships/find-a-scholarship/vice-chancellors-international-excellence-scholarship-for-the-pacific [evidence 8003b8c3-b533-42a9-bcd8-32f145801774] | 5/5/0 | 143/143/143/0/0 | 0 | 0/0/0 | 8→8; 1; 265 | 0 (0); no extraction recorded | no stated award value; international_not_stated; listing_page; no_named_title; not_a_scholarship — recover only proven missing fields; preserve holds |
| W01-B2/2 | Massey University (`229dc07d-c573-44a3-b5dc-cc423cc2c300`) | 265 | L9 https://www.massey.ac.nz/study/scholarships-and-awards (read); C44315 https://www.massey.ac.nz/study/scholarships-and-awards#award-s-allan-and-grace-kay-overseas-scholarship [evidence 1337ec80-9121-4178-9a0d-8af3940ecf2d] | 7/7/0 | 447/447/447/0/2 | 0 | 0/4/0 | 17→17; 8; 220 | 0 (0); qwen/qwen3-30b-a3b-instruct-2507: 4/6374/4263/0.0019163/0 | applications have closed; no stated award value; provider page limits it to citizens and residents; domestic_only; international_not_stated; listing_page; no_named_title; not_a_scholarship — settle existing reader/AI |
| W01-B2/3 | Auckland University of Technology (`39301fa8-bff2-4389-bbcd-32d8415fae04`) | 257 | L1749 https://www.aut.ac.nz/study/fees-and-scholarships/scholarships-and-awards-at-aut/international-scholarships (read); C12562 https://www.aut.ac.nz/study/fees-and-scholarships/scholarships-and-awards-at-aut/manaaki-new-zealand-government-scholarships/manaaki-new-zealand-scholarships-faqs [evidence 21201c2f-2a1d-49e8-b337-2e2e26d6f957] | 4/3/1 | 25/25/25/0/4 | 4 | 0/0/0 | 1→1; 1; 2 | 5 (0); no extraction recorded | no stated award value; domestic_only; international_not_stated; listing_page; no_named_title; not_a_scholarship — settle existing reader/AI |
| W01-B2/4 | Eastern Institute of Technology (`ea5a3fa6-31f4-4553-9cfd-6bff49c36a6b`) | 188 | L1767 https://www.eit.ac.nz/students/scholarships/ (waiting); C27783 https://www.eit.ac.nz/2017/06/scholarship-celebrates-educators-legacy [evidence 73d78e3a-7cb7-4ba2-a6b1-aa1f698145d8] | 1/0/1 | 212/212/212/0/0 | 0 | 0/0/0 | 0→0; 1; 0 | 0 (0); no extraction recorded | provider page limits it to citizens and residents; international_not_stated; listing_page; no_named_title; not_a_scholarship — hub 1767; verify international and current round |
| W01-B2/5 | Otago Polytechnic (`cd27693c-6c80-42f4-8b76-1ed2d94e0b45`) | 182 | L1766 https://www.op.ac.nz/international/fees-and-scholarship/international-scholarships (waiting); C30341 https://www.op.ac.nz/international/fees-and-scholarship/international-scholarships/2027-otago-polytechnic-international-scholarships [evidence f7e735ce-9348-442a-b9d9-cd9f9a38f5fa] | 2/1/1 | 15/15/15/0/0 | 0 | 0/0/0 | 3→3; 1; 21 | 0 (0); no extraction recorded | no stated award value; international_not_stated; listing_page; no_named_title; not_a_scholarship — hub 1766; settle and verify programme values |
| W01-B2/6 | Waikato Institute of Technology (`742eef0a-1341-46ef-a4ab-4d105c47be9b`) | 144 | L85 https://www.wintec.ac.nz/study-at-wintec/scholarship-finder/altrusa-international-inc.-of-cambridge-scholarship-award (read); C41266 https://www.wintec.ac.nz/student-resources/support-services/scholarships/scholarship-list/scholarship-item/wintec-adult-learner-awards [evidence 12782021-eeda-40f8-8aed-42f8721e8d5f] | 121/109/0 | 163/163/163/0/6 | 0 | 0/0/0 | enrolment 0→0; 1; 0 | 0 (0); no extraction recorded | cap held; applications have closed; provider page limits it to citizens and residents; award of another body; domestic_only; international_not_stated; listing_page; no_named_title — ordinary provider cap; no bypass |
| W01-B2/7 | The International Travel College of New Zealand Limited (`e037d54a-6735-4f60-818d-e2a077d436e8`) | 3 | L653 https://itc.co.nz/6-travel-and-tourism-industry-insiders-show-their-support-for-itc-scholarships/ (read); C28467 https://www.itc.co.nz/were-giving-away-20-scholarships [evidence 4c242af9-5549-4bfa-945d-20836e7675ca] | 3/3/0 | 50/45/45/0/1 | 0 | 0/4/0 | enrolment 0→0; 1; 0 | 0 (0); qwen/qwen3-30b-a3b-instruct-2507: 4/12721/2956/0.0021589/0 | applications have closed; international_not_stated; listing_page; no_named_title; not_a_scholarship — candidate 43868 old 2011 offer, preserve hold |
| W01-B2/8 | Te Aratika Industry Training Limited (`cad8ab1d-cb95-40a1-9d9f-da2bb53263b3`) | 1 | C44183 https://www2.nzqa.govt.nz/maori/ringa-toi/category-award-winners-2024 [evidence 95895877-0435-4484-990d-199cabb4e854] | 0/0/0 | 88/88/88/0/1 | 0 | 0/1/0 | enrolment 0→0; 0; 0 | 0 (0); qwen/qwen3-30b-a3b-instruct-2507: 1/2291/571/0.0004004/0 | international_not_stated; listing_page; no_named_title; not_a_scholarship — candidate 28818 national NZQA award, ownership mismatch; controller review, do not admit |
| W01-B2/9 | Manukau Institute of Technology and Unitec - Unitec (`66f6fcc9-15f8-46e6-b3b3-0576ab4bcce3`) | 80 | L216 https://www.unitec.ac.nz/masters-scholarships-guidelines/ (read); C28147 https://www.unitec.ac.nz/application-and-funding/scholarships-and-awards/school-of-architecture-postgraduate-scholarships [evidence ce656745-b59f-46e7-8a21-01f2bfd37b96] | 10/9/0 | 115/115/115/0/0 | 0 | 0/0/0 | enrolment 2→2; 6; 25 | 0 (0); no extraction recorded | applications have closed; no stated award value; domestic_only; international_not_stated; listing_page; no_named_title; not_a_scholarship — recover only proven missing fields; preserve holds |
| W01-B2/10 | Crown Institute of Studies Limited (`fefd6555-c2b7-43e4-93bc-a5e935ed4a01`) | 13 | C28399 https://crown.ac.nz/southeast-asia-scholarship [evidence a117b6b7-38d9-48f1-a358-f310c83b2209] | 0/0/0 | 4/4/4/0/0 | 0 | 0/0/0 | enrolment 0→0; 1; 0 | 0 (0); no extraction recorded | applications have closed; domestic_only; international_not_stated; listing_page; no_named_title; not_a_scholarship — recover only proven missing fields; preserve holds |
| W01-B2/11 | Tai Poutini Polytechnic (`faa04942-5af1-418c-8214-c5aa2523c39d`) | 42 | C25374 https://tpp.ac.nz/explore/scholarships/2023-recipients [evidence 8fba8477-4f28-4472-881a-b763654a2f61] | 0/0/0 | 1/1/1/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B2/12 | Skills Active Te Mahi Ako Limited (`0ede4eef-4117-4362-8a64-131efcb31c38`) | 41 | C25365 https://www.temahiako.org.nz/about-us/te-mahi-ako-awards-and-scholarships [evidence 2d08390b-ade7-401a-93f0-ac7868bb8f03] | 0/0/0 | 2/1/1/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B2/13 | Future Skills Academy Limited (`a1a229cc-1915-475c-9d0a-727eeb45a20b`) | 36 | C25549 https://futureskills.co.nz/international/international-scholarships/special-kenya-scholarships [evidence 00875736-7732-4ba3-895a-14b46181f7ae] | 0/0/0 | 2/2/2/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | none recorded — review existing verdict; no identical paid retry |
| W01-B2/14 | BCITO Limited (`7bf176e6-4c08-4068-a837-d991c5be8f22`) | 33 | C43462 https://bcito.org.nz/ej-award-form [evidence 6df5a15b-f1c4-43fa-ba27-4a4cc4bbfa1d] | 0/0/0 | 9/9/9/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page; no_named_title; not_a_scholarship; not_offered — review existing verdict; no identical paid retry |
| W01-B2/15 | Whitecliffe Education Limited (`29fabe13-e9fe-497c-ae2b-bd6d08b5c46b`) | 32 | C28364 https://www.whitecliffe.ac.nz/6-months-fees-free-scholarship-whitecliffe [evidence 65d1e056-626e-4526-863f-3b3599139456] | 0/0/0 | 4/4/4/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | domestic_only — review existing verdict; no identical paid retry |
| W01-B3/1 | MITO Limited (`49852ffc-1db7-47ec-83aa-f8ff5ba1408b`) | 31 | L1152 https://www.mito.org.nz/current-learners/scholarships-and-finance (read); C43982 https://www.mito.org.nz/employers#checklist [evidence fed9c6eb-1f0f-46d0-9720-a33ec540945a] | 2/2/0 | 29/29/29/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | domestic_only; international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B3/2 | Connexis Inc. (`0b99ef17-5251-4f65-b2ed-7b6909711df3`) | 20 | C36138 https://connexis.org.nz/ambassador-stories/opportunities-are-aplenty-for-this-excellence-awards-finalist-as-he-finds-his-feet-in-a-rewarding-career/carl-moffit [evidence 71b50297-97fd-47f6-bd51-603cdaab2c3b] | 0/0/0 | 23/23/23/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page; no_named_title; not_a_scholarship; not_offered — review existing verdict; no identical paid retry |
| W01-B3/3 | Bethlehem Tertiary Institute (`d5e0d1c6-9f24-4ce2-869e-dec769f4c3a2`) | 19 | C25848 https://bti.ac.nz/about-us/awards-an-ratings [evidence 19d63ae6-98d2-43b4-a8a8-57d187722ed6] | 0/0/0 | 2/2/2/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B3/4 | Marine and Specialised Technologies Academy of New Zealand Limited (`5ac7d2c3-d3a6-48f1-ad44-178f5397ead5`) | 18 | C26015 https://www.mastacademy.com/post/the-apprentice-of-the-year-award-ofpanz [evidence 1c6e8b0c-9be6-4bc8-893e-b5689a94304e] | 0/0/0 | 1/1/1/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B3/5 | New Zealand Tertiary College Limited (`8bd0b377-7722-41fa-be2e-0a0984e37f36`) | 17 | C28395 https://www.nztertiarycollege.ac.nz/early-childhood-education-profiles/graduates-award-winning-journey-perseverance-and-passion [evidence efb56390-7be5-42a0-85da-9c6eb36a29a0] | 0/0/0 | 2/2/2/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B3/6 | Soshi Gakuen New Zealand Incorporated (`51463a53-dd3f-4dfc-a6d8-bce081dacfb0`) | 16 | L419 https://www.ipu.ac.nz/international-students/enrolments-and-assistance/scholarships-1 (read); C28366 https://www.ipu.ac.nz/international-students/enrolments-and-assistance/scholarships-1 [evidence c4d5d699-0faf-43b6-b177-4590b729dccf] | 1/1/0 | 2/2/2/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B3/7 | Hair Industries Support Opportunities Charitable Trust (`dcbae90d-184a-4ef3-8ba6-445b1a1db5f4`) | 14 | C28400 https://hito.org.nz/hito-awards-entry-forms [evidence 5080d0fa-e433-436c-8ed8-2a6494785465] | 0/0/0 | 1/1/1/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B3/8 | Auckland Institute of Studies Limited (`a3fd5f9f-1ffc-4192-b458-ce1d7a7e87b3`) | 13 | C28401 https://www.ais.ac.nz/study/study-at-ais/ais-scholarships [evidence 5d84498b-97ea-4b8c-b20d-e16e1a6f3445] | 0/0/0 | 3/2/2/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B3/9 | Te Rito Maioha Early Childhood New Zealand Incorporated (`e87c62e4-3fab-4c30-b3b8-efb5f6d133cb`) | 13 | C28391 https://ecnz.ac.nz/international-study-grant [evidence d86681c4-a152-4f42-afce-95dc56f5c8b6] | 0/0/0 | 27/27/27/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | domestic_only; international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B3/10 | Cavalli College Limited (`28f7449a-e676-498a-95c5-1800cceb678b`) | 12 | C26321 https://cavallicollege.nz/cavalli-college-receives-highly-commended-recognition-at-the-2026-itenz-awards [evidence 7c0f5cc1-2b1b-4f54-a573-43760945b26c] | 0/0/0 | 2/2/2/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B3/11 | Pacific International Hotel Management School Limited (`55de2ff5-7a90-4899-b074-8803bfbe51d7`) | 10 | C28418 https://pihms.ac.nz/students/pihms-scholarships [evidence 54a91888-9dd8-4dac-8683-d1b5df039422] | 0/0/0 | 2/2/2/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | domestic_only; international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B3/12 | Apprentice Training New Zealand 2010 Trust (`5a29f893-d591-44ad-819b-0562566f1d18`) | 9 | C28412 https://atnz.org.nz/for-learners/ko-ken-tool-scholarships-winners-2026 [evidence c722bc5b-5529-4c04-bd87-2fb790d91619] | 0/0/0 | 1/1/1/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B3/13 | School of Audio Engineering (NZ) Limited (`cc164a3e-f622-40ca-91fb-99b4a2defe88`) | 9 | C43598 https://www.sae.ac.nz/insights/ngati-whatua-orakei-and-sae-announce-scholarship-partnership [evidence 5b9daedb-4b4c-47b6-80b1-734656689201] | 0/0/0 | 2/2/2/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page; no_named_title; not_a_scholarship — review existing verdict; no identical paid retry |
| W01-B3/14 | Te Kōhanga Reo National Trust Board (`f8d06b5c-aed0-4704-8731-77ccb36e4a0f`) | 9 | L1190 https://www.kohanga.ac.nz/te-whare-ako/he-manu-pirere-scholarships (read); C28407 https://www.kohanga.ac.nz/te-whare-ako/he-manu-pirere-scholarships/nga-karahipi-matauranga-matua [evidence 7b428f7b-9c13-4aea-b845-32953077f9df] | 2/2/0 | 5/5/5/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page — review existing verdict; no identical paid retry |
| W01-B3/15 | Techtorium New Zealand Institute of Information Technology Limited (`9a6e3ec4-f640-442d-9b71-632508d1fcf8`) | 8 | C28457 https://techtorium.ac.nz/techtorium-wins-best-of-the-best-in-community-contribution-westpac-business-awards [evidence 51606b88-3468-403e-9fd8-6f76093aca52] | 0/0/0 | 2/2/2/0/0 | 0 | 0/0/0 | enrolment 0→0; 0; 0 | 0 (0); no extraction recorded | international_not_stated; listing_page; no_named_title; not_a_scholarship; refused_by_person — review existing verdict; no identical paid retry |


**S3-Scholarship-ChatGPT / SCH-FU-04 — 24 Nov 2026 23:23 AEDT.** Pilot #1574 / Admin #981 deployed; prior Admin #1002 listing drain recorded. Request `625e62fc-fd69-47d1-9858-216dcb4a76e7` remains open (expiry 25 Nov 03:40 AEDT, 84-credit cap). Initial 84/84 listing pages read, 501 new sections. 545 linked candidates: 129 read, 416 unread, 68 read with no admission verdict, 16 admitted-status (includes historical), no active candidate leases at 23:22:46. Admission ledger since request: 13 events (Canterbury 10, VUW 2, Lincoln 1); 1 newly admitted award currently published. NZ 112→113 published, 54→66 active unpublished, combined 166→179; 12 publishing/16 active providers. Lincoln CSC PhD new scholarship `6203f1ef-e055-5356-af17-489c9056107f`, evidence b27a4973-5496-4de1-b040-6e63bd5393e1, mapped course `f0e6f7da-e956-437f-833a-e6e9a744aabf`; existing Website v2/v3 SQL RPC readback succeeded using the actual stable key; Zoho v3 top RPC returns full tuition. No external consumer credentialled HTTP check. Scheduled reader and publication runs recorded successful (reader latest 23:20, publisher 22:29 AEDT); actual canonical events span multiple read batches, two complete result-bearing end-to-end publication cycles not yet proved. Lincoln Master's candidate 44346: official stored evidence 1948b015-e6b5-4d4e-a3c9-d71b101d71c6, SHA-256 6986c4e6e166984d8e96d2842aec56054556c2afc7cd58716353b01db4fbf964; value null and no admission verdict. Existing Qwen queue 89853, attempts 0, next_try_at 25 Nov 00:48:21 AEDT; stored copy resolved by picker. Do not reset retry or invent tiers; earlier excerpt says B average for NZ$10,000, so verify all programme/grade combinations from official snapshot via existing qualified reader. Four Lincoln monetary awards 2500/3000/5000/10000 confirmed previously. Request FC 69/84 consumed (15 remaining), account 62904; OpenRouter $0.2262 all-lane window, NZ scholarship extraction ledger Qwen 62 records, 105203 input/54202 output tokens, $0.0343149, 6 errors; no other recorded NZ extraction model, not exclusively request-attributed. G3 75/48 drift [], locks 7585, active cron 136. No cap extension, job/setting/API edits.

**Independent NZ source work, same-cohort continuation:** registered and enqueued four verified provider-owned hubs, guarded against duplicate listings/stored snapshots and cross-country writes, existing caps retained: AUT `1749` audit 67041 (https://www.aut.ac.nz/study/fees-and-scholarships/scholarships-and-awards-at-aut/international-scholarships); Ara `1750` audit 67042 (https://www.ara.ac.nz/student-services/supporting-your-study/scholarships/); WITT `1751` audit 67045 (https://www.witt.ac.nz/international-students/international-scholarships); NMIT `1752` audit 67046 (https://www.nmit.ac.nz/study/finance-your-study/scholarships). All four read successfully in existing pipeline at 23:22 AEDT. AUT 9 members/4 award sections, 9 candidates/5 read/2 admitted-status (0 new linked admissions); Ara 55/33, 53 candidates/22 read/4 admitted-status (0 new linked admissions, canonical active 0); WITT 0 members despite official source's programme-specific automatic 2027 award table, requiring existing reader table/benefit-tier mapping proof; NMIT 25/18, 25 candidates/0 read. Three hubs yielded 55 award sections, not canonical awards. Massey and Waikato listings already read; Massey candidates 44334/44335 stored and existing queue 90075/90076 due 00:48 AEDT; Waikato 907/908 completed, do not duplicate. IPU listing 419 and candidate 28366 already stored, listing_page/international_not_stated rejection despite public page identifying awards: investigate stored evidence, do not repeat paid acquisition. Ara candidate 28055 Rika Fund title rejection, 2026 round closed on public listing; preserve current-round gate. Te Aratika candidate 28818 is NZQA national secondary award, not provider-owned; ITC 43868 past 2011 page; do not admit. Ranked 15 eligible sourced-zero-active review cohort: NZIST Work-Based Learning 231 courses, Ara 178, Toi Ohomai 157, NMIT 148, MIT 144, NorthTec 122, UCOL 115, Open Polytechnic 93, WITT 89, Te Wānanga o Aotearoa 85, NZMA 77, NZIST 72, Te Wānanga o Raukawa 63, Te Whare Wānanga o Awanuiārangi 52, Yoobee 52. Existing candidate verdicts mostly domestic_only/international_not_stated/listing_page/not_a_scholarship; UCOL includes refused_by_person, preserve; NZIST both stored sources domestic-only, no ownership inference. No forced identical retry or mass re-admission. Exact resume: continue 416 scoped unread and 68 undecided through scheduled gates while FC capacity remains; recheck Qwen 89853 after its scheduled retry and provider-specific tier evidence, WITT table reader and independent AUT/Ara/NMIT candidate settlement, then next eligible providers (up to 15) in same 45-provider wave. Close request only after settlement or expiry/cap prevents further authorised work; record residual holds and actual costs, no extension. S1-Build owns generated CSV/Sheet sync. M3 mirror after merged main; no new tracker.

- **Triage (Execution Register, S2-AER section):** 0 of 13 can be bulk-approved now. Every item is `technical_blocked` (`matrix_source`) because its read dropped published rows; Approve is refused.
  - Across the 13 reads: 1,269 proposed rows; 449 unchanged, 7 changed scores, 813 added; 187 active rows would be superseded; 541 rows fail value proof; 50 have a blank level.
  - Remedy: corrected re-reads from stored copies by the reader owners.
- **Reusable fix routed:** six country aliases (Hong Kong (China), HK, Taiwan(China), SG, Macedonia, and the misspellings Bangaldesh and Phillipines). No equivalence is inferred.
- **s995 (Pilot #1502):** not superseded. `security.aer_matrix_machine_exclusions_v1` is unchanged (md5 `51ad50c5…`) and UWA's 194 rows still wait. Re-rehearsed 23:00: 186 rows admitted; active matrix 7,261 → 7,447; counter 10,729 → 10,795 (+66); real answers 0 (UWA India answers: 152 course_override, 176 contact_provider before and after).
  - Remaining value: correct bachelor ATAR-band rows that answer only once UWA courses carry an ATAR band. Kept as a draft; if it is merged, its migration timestamp must be renumbered above the head.
- **Baseline for the 00:10 read-back:** active matrix 7,261; covered 10,729; 0 machine admissions in the last 24 hours.
- **Guardrails:** G3 75/48, locks 7,585, cron and $0 all unchanged.

**S2-RM-Design, 24 Nov 2026 22:15 AEDT (cross-country AER admission and blocker gate): active-course counts added for the 12 change-item providers; no live change.**

**S3-Scholarship-ChatGPT / SCH-FU-04, 24 Nov 2026 22:28 AEDT:** Pilot #1574 / Admin #981 live; request `625e62fc-fd69-47d1-9858-216dcb4a76e7` audit 66899, expiry 25 Nov 03:40 AEDT, remains open. All 84/84 listings read, no failures (Auckland 31, Canterbury 37, Otago 11, VUW 3, Lincoln 2); 501 new award sections. NZ published 112/12 providers unchanged; active unpublished 54→56; two new admission events (Lincoln and VUW), two duplicate and five rejected events. Later linked-candidate snapshot: 545 distinct candidates, 506 unread, 39 read (5 admitted status, 5 duplicate, 21 rejected, 8 unclassified); statuses are not new admission counts. Lincoln candidate 44346, evidence 1948b015-e6b5-4d4e-a3c9-d71b101d71c6, stored HTML exists, deterministic value null and no admit status; source excerpt shows B average for NZ$10,000, do not assume B+; reuse stored evidence and qualified extraction before patch. Four Lincoln canonical monetary awards 2500/3000/5000/10000, only 10000 published. FC request 39/84, account 63077, AI all lanes $0.1026; scholarship lane Qwen 114 calls $0.06768208 (not NZ-attributed; tokens not retrieved). G3 75/48 no drift, locks 7585, cron 137. Independent existing listings: AUT 3, Massey 7, Waikato 5, NZIST 0; no fresh source claimed. Resume: let existing candidate reader settle, prioritise stored Lincoln 44346 via existing extraction, verify canonical/consumer and two cycles, close request after settlement; no extension or global changes. S1-Build owns status CSV sync. M3 mirror pending.

- **Counts:** the 12 providers carry 3,024 active courses, 1,167 of them covered now, under 13 pending `entry_matrix_change` items (1,284 proposed rows). The table is in the Execution Register's S2-AER blocker section.
- **Correction:** Top Education Institute's two items read two different source pages, so they are not duplicates.
- **Live state:** active matrix rows 7,261; covered courses 10,729; 0 machine admissions in the last 24 hours (9 declines).
- **Gates unchanged:** the 13 human change items, blank-level rows and host_shared RMIT Pathways all stay gated.
- **Rules:** none shipped. The 53 value-not-in-quote rows are reader misreads.
- **Guardrails:** G3 75/48, locks 7,585, cron and $0 all unchanged.

**S3-AER-ChatGPT NZ/CA continuous recovery, 24 Nov 2026, s1064, OPEN (no canonical gain yet).** The production source-backed no-active backlog is now **54 providers** (NZ 19, CA 35) across **70 sourced** NZ/CA providers (35 per country). All currently stored NZ/CA source versions already have a run; do not queue unchanged files just to repeat paid models. Canada: 15 failed runs were unproved HTML/PDF structures, seven were AI timeouts, and seven unclaimed first-read Layer 4 reviews hold 49 proposed rows, zero machine-eligible (KPU 16 incomplete quote; Royal Roads 16 study level; UNBC 11 unsupported quotation; Athabasca 2 level; MacEwan 2 quote/value; Langara 1 level; Mount Royal 1 level). S2-AER owns shared mapper/admission and was handed evidence in Admin PR #935 (comment 7123451972). Registered two official UNBC country-PDF child sources (India source 284d4bba-a25b-48e5-a61d-3ba54656a5cb and Cameroon 8e6c0adf-3385-4fb2-ae1e-8e545d746ab5): the previous UNBC URL was only a country index, PDFs include 2022 and 2021 draft imprints, so edition currency remains unverified and no grade is admitted; PDF-family handover to S1-AER at Pilot #1557 (comment 7123660210). Pilot #1558 (s1064 NZ/CA deterministic HTML academic sections and s1065 Wave5 scoped sources) is still in governed CI, last head c5eec252, with security/type-check/dry-run green and full-suite shard 2 passed after fixing printed ATAR score-of 65 as rank. Its migration includes guarded $0 replay of Otago Polytechnic, Wintec and VUW stored copies, plus five Wave5 Canadian source allowlist entries; **not deployed**. Admin #941 merged after conflict-safe rebase; no duplicate Test Register, UI, cron, AU or S2 admission changes. CA-wide AER remains OFF, frozen G3 75/48 and 7,585 manual locks intact. **Exact resume:** wait for last #1558 full-suite and description gates; if failure, repair only failed check on exact head, else Integration Controller merge/deploy; verify migration and deployed worker, guarded three NZ reread outcomes and five CA source acquisitions; then validate quotation, country/level/course, existing S2 partial/machine gates, new active canonical rows and consumer visibility; require two result-bearing unattended cycles. If no eligible rows, continue the first 15 CA unproved-structure providers with stored evidence, not another broad discovery wave. All 54 no-active providers remain unaccepted.

**S3-AER-ChatGPT NZ/CA — F-AER Steps 3–5 evidence, 24 Nov 2026, s1064 (UNACCEPTED pending canonical gain).** Live Wave4 migration `20261124210000` present; scope remains only NZ/CA, Canada global schedule OFF. Wave4 sourced cohort 32 providers: 32 sources (30 read / 1 found / 1 failed), 33 runs, 380 active canonical rows unchanged since 16:17 AEDT; 271 proposed (not admissions); no session-created Wave4 run IDs or new canonical rows. Auckland A–I: 126 proposed, 94 course-linked and 32 ambiguous/unlinked, latest review `04a4ad2a-a098-41b3-9a80-cd689e2b435f` is `entry_matrix_change` and requires a person. CA initial zero-active seven-provider first-run cohort: 49 proposed rows; machine gate `ok=false` for every review (KPU 16 gate_incomplete quote_too_short; Royal Roads 16 all_rows_held level_unmapped; UNBC 11 gate_incomplete 3 quote_not_on_page; Athabasca 2 level_unmapped; MacEwan 2 value_not_in_quote; Langara 1 level_unmapped; Mount Royal 1 level_unmapped). S2-AER handoff on Admin PR #935 conversation comment 7123451972; no shared admission gate changed. NZ/CA deterministic parser and guarded replay in Pilot #1558 `s1064`: failing full-suite synthetic ATAR-score wording repaired on branch (latest head `56cb2ec9`); green security/type-check/dry-run, remaining governed CI pending, not yet deployed, hence no extracted/admitted gain claimed. Wave5 45 (3×15) only eight sourced, 37 pending; five CA URLs registered live, 3 NZ sources reused; zero new Wave5 canonical records. Two `entry-matrix-read` cron executions succeeded at 16:54 and 16:59 AEDT (the scheduler ran; no admission implied). Production guardrails G3 75/48, 7,585 manual locks, cron ≤140. Mandatory next acceptance: merged/ deployed reader → exact stored evidence row integrity and identity → existing S2 machine/partial checks → active canonical insert → consumer read-back → two further unattended result-bearing cycles; until then F-AER remains OPEN.



**S3-Scholarship-ChatGPT — NZQA only, 24 Nov 2026: atomic recovery patch preparation.** Platform Admin authorised a time-limited, purpose-scoped on-demand listing recovery for Auckland (31), Canterbury (37), Otago (11), VUW (3) and Lincoln (2). Existing Canadian eligibility exception preserved; ordinary caps, account reserves, human admission and manual locks unchanged. Prior audit 66524 queued Lincoln and Waikato; no new admission or publication claimed. Shared hold function change assigned to Integration Controller for governed release; spec and migration numbering subject to controller reconciliation. S1-Build owns scholarship_status sync. No paid extraction initiated.


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

**S1-Impl-Layer4-Human-UI-Guide, 21 Nov 2026 13:40 AEDT: s931 recorded before merge (Pilot migration `20261121200000`, v2.16.76).** Decision 279 §5 to §8 built and live on deploy: Layer 4 primary row and Advanced filters (N); card zones with Yes / No / Resubmit to Review with AI and More options; reject chips; AI budget line; Lock this value; FieldGap pills and Add official URL; CoverageNotice; Platform guide Filters & badges, Layer 4 guide, worked examples. Fixes: Approve all verified for provider count, Course / University description split, one read for every Layer 4 count, CRICOS/NZQA code proof of course descriptions (12 admitted in the dry run). D3 filter arguments md5-guarded. s930 (v2.16.75) live and read back. G3 75/48, locks 7,585, cron 135.

## 21 Nov 2026 13:45 AEDT — S1-RM-Design s935: Settings › API usage for every version and key; one key per (consumer, API version); standing rule Self-Sustaining API & Key Governance

- **Asked (Platform Admin, 13:11).** API usage read from the database for every API version and key, Website and Zoho v3 included; independent rotatable keys per consumer and version; a standing rule in `CLAUDE.md` and `AGENTS.md`.
- **Change (Pilot #1458, v2.16.76 / 0.1.498, migration `20261121200000`).** Version register `pipeline.api_versions`; own v3 keys (`website_developer_v3`, `zoho_creator_v3`, `zoho_crm_sync_v3`, Not issued); `pipeline.api_key_auth_v1` and `pipeline.api_request_log_v1` for v3; read path `security.api_usage_versions_v1` with 24 h / 7 d / 30 d usage, 2xx/4xx/5xx, error rate and p95; coverage check `security.api_usage_coverage_v1` (empty). The screen has no version list. Design: `docs/platform/2026-11-21-s935-api-usage-versions-and-keys.md`.
- **No interruption.** The website calls v3 with its v2 key today; that key is the v3 key's previous key for `api.new_key_bridge_days` (14) until the Platform Admin issues the v3 key.
- **Dry run passed, rolled back** (run 44855966870): 7 versions, coverage empty, website v2 16,087 calls in 30 days (p95 7.7 s), 653 v3 calls on the v2 key; Zoho v3 refuses a v2 key; G3 75/48; locks 7,585.
- **Next.** Merge this record, then Pilot #1458; read back live, check the screen signed in, sync Drive and park.

**S1-Impl-Layer4-Human-UI-Guide, 21 Nov 2026 14:20 AEDT: s931 live and read back (Pilot #1457 `502e7cc2`, admin #753); s932 recorded before merge (v2.16.77).** Migration `20261121200000` md5s read back as written. Signed-in desktop and 375 px: old toolbar retired, primary row, Advanced filters (N), three-decision bar, pills and upgraded guide render; AER counts agree (997; Hong Kong 36). 12 course descriptions admitted by the code proof (157 to 145). s932: the description queue is named by what it holds. G3 75/48, locks 7,585, cron 137.

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

**S1-Coverage-Unlock-UI-Notes, 21 Nov 2026 15:25 AEDT: coverage window `ad97c846` closed (s945, Pilot migration `20261121235000`).** 110 Firecrawl units of the 20,000 cap (scholarships 94, provider facts 11, listings 5); 66,863 credits left on the plan; OpenRouter US$0.0561 in the window (all lanes). Closed with `security.on_demand_close_v1`; report kept.

**S1-ELR-Fetch-Window, 21 Nov 2026 18:30 AEDT: s950 recorded before merge (Pilot #1462, migration `20261122010000`).** The central English page fetch now closes its on-demand request when the window times out (once nothing is in flight), keeping its report and counting the pages left queued. Logic only: no request opened, nothing sent, $0. Rolled-back proof: a timed-out request with 2 queued pages stayed open under the old run and closed under the new one with nothing sent.

**S1-ELR-Fetch-Window, 21 Nov 2026 18:45 AEDT: s950 live and read back; parked.** Admin #762, Pilot #1462 (`41572ace`); migration `20261122010000` is the live head; sweep md5 `2a09bbdb`; first run after deploy succeeded (8.9 s); no fetch request open; G3 75/48; locks 7,585; 137 cron; $0.

## 21 Nov 2026 20:30 AEDT — S1-RM-Design: s951 P0, website-api-v3 and zoho-api-v3 answered 503 since s935

The website developer reported HTTP 503 `SERVICE_UNAVAILABLE` on `website-api-v3` (search and destination; request ids `2cd7d848-f518-4276-90f3-8cdfdf6b7e2e` and `abe9f30c-afd7-4ad8-be33-984ca86c162f`).

- **Cause, read live.** Since s935 (#1458, deployed about 18:11 AEDT), both v3 functions call `pipeline.api_key_auth_v1` and `pipeline.api_request_log_v1` with `svc.schema("pipeline")`.
  - The API gateway serves only the public schema, so every call got HTTP 406 (edge logs, 07:11 to 09:11 UTC). Every v3 call answered 503 before any key was checked.
  - The v2 and v1 APIs were not affected.
- **Fix: Pilot migration `20261122020000` (s951), live on deploy.**
  - It adds the service-role-only entry points `public.api_key_auth_v1` and `public.api_request_log_v1`, which call the pipeline functions unchanged.
  - Both v3 functions now call these with `svc.rpc`. Spec s935 now fails any `.schema("pipeline"|"security"|"private").rpc(` in the v3 functions.
  - G3 stays at 75 functions and 48 relations; no key changed.
  - The rule text (Pilot `CLAUDE.md`, key governance item 1) now names the entry points.
- **Also noticed, not changed:** `provider-contact-import` and `ranking-publisher-import` write to `pipeline` tables with `.schema("pipeline")`. They are likely refused the same way and should be checked.

**S1-API-Frontend-Delivery, 21 Nov 2026 21:35 AEDT: Step 0.** Continuous Delivery Master Plan v0.1 (drafted from the Lane 1 brief) in `docs/platform/` and Drive `M3`; standing rule in `CLAUDE.md` and `AGENTS.md` of both repositories; `INTERNAL-REQUESTS.csv` created. Next: Zoho v3 export (REQ-34, REQ-35).

**S1-API-Frontend-Delivery, 21 Nov 2026 22:05 AEDT: s955 recorded before merge (Pilot #1465, migration `20261122030000`).** Zoho v3 course export adds TOEFL iBT, CAE, DET and OET columns (REQ-34, Z2); `zoho.sync_countries` AU, NZ, CA for v2 and v3 (REQ-35, Z3). Live on deploy; $0.

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

**S1-API-Frontend-Delivery, 21 Nov 2026 22:55 AEDT: s955 live; s956 recorded before merge (Pilot #1467, v2.16.79).** Zoho v3 English test columns and NZ/CA sync live (REQ-34 Live in v3, REQ-35 Delivered); India team UI fixes REQ-92, 97, 101, 102, 103, 106, 107 merging.

**S1-API-Frontend-Delivery, 22 Nov 2026 00:05 AEDT: s956 live (v2.16.79, 7 India requests Delivered); s957 recorded before merge (Pilot #1468, v2.16.80: REQ-93, 96, 98, 104).**

**S1-API-Frontend-Delivery, 22 Nov 2026 01:00 AEDT: s957 live (v2.16.80; REQ-93, 96, 98, 104 Delivered); s958 recorded before merge (Pilot #1469, v2.16.81, REQ-100).**

**S1-API-Frontend-Delivery, 22 Nov 2026 01:40 AEDT: s958 live (v2.16.81, REQ-100 groups); s959 recorded before merge (Pilot #1470, v2.16.82: REQ-64, REQ-71, REQ-72 checked; one-page levels).**

**S1-API-Frontend-Delivery, 22 Nov 2026 02:20 AEDT: s959 live (REQ-64 Delivered; REQ-71, REQ-72 confirmed); RM1K acceptance read (every Australia section served by v3); v2.16.83 recorded before merge (Pilot #1471).**

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

**S1-API-Frontend-Delivery, 22 Nov 2026 02:45 AEDT: v2.16.83 live (REQ-100 Delivered); Lane 1 parked.** Items 1 and 3 done; item 2: 12 of 17 Delivered (REQ-105 next; REQ-94, 95, 99 with Lane 2; REQ-108 waits on scope); item 4 acceptance read done, deployed spec and REQ-59 QA next.

## 22 Nov 2026 01:45 AEDT — Lane 2 s965 live and read back: 75 draft Tasmania-wide living-cost figures (Pilot #1472 `34e31e05`); parked

- **Merged and deployed.** Admin #774, then Pilot #1472 (`34e31e05`). Deploy on merge applied `20261122100000` (history md5 3f42f69c matches the file).
- **Read back live.** 75 figures, all draft, in edition `Migration Tasmania weekly living costs (Tasmania-wide), page of 28 Jul 2026`; Hobart whole-house rent reads $550 a week.
- **Guardrails.** Live head `20261122100000`; G3 75/48, no drift; locks 7,585; 137 active jobs, 0 unregistered; $0 AI, $0 Firecrawl.
- **Platform Admin.**
  - Sign off the terms and approve the figures (`admin_destination_figures_bulk_approve`).
  - IR-009: the NZ and CA course-campus decision.
  - IR-010: the person queues.
- **Lane 2 next.** Item 4 (NZQCF, NZSCED and CIP); NZQA reuse terms are still flagged. Parked.

**S1-API-Frontend-Delivery, 22 Nov 2026 10:20 AEDT: rankings decision recorded (Platform Admin 09:22, IR-005, RM1J); s966 THE and QS public readers recorded before merge.** THE 2027 (3,146 rows) and QS 2027 (1,504 rows) read from the publishers' public JSON with a plain GET, published live with attribution, $0; rehearsal links AU 37/37, NZ 8/8, CA 32/34 (THE) and 28/30 (QS).

**S1-API-Frontend-Delivery, 22 Nov 2026 11:30 AEDT: s966 live; THE first run timed out (partial edition briefly shown), QS challenged by Cloudflare (no bypass); s967 apply scope and hold-until-published fix recorded before merge.**

**S1-API-Frontend-Delivery, 22 Nov 2026 12:00 AEDT: s967 live (partial THE 2027 held; website on THE 2026); s968 preview fix (v1.8.1) recorded before merge.**

**S1-API-Frontend-Delivery, 22 Nov 2026 12:45 AEDT: THE 2027 live (public, attributed, 3,146 rows, 77 AU/NZ/CA linked); QS 2027 public read blocked by a Cloudflare challenge (uploaded QS 2027 stays live); s969 batch-size setting recorded before merge.**

**S1-API-Frontend-Delivery, 22 Nov 2026 13:20 AEDT: rankings item delivered for THE (THE 2027 public and attributed, 3,146 rows, 77 AU/NZ/CA linked; REQ-91 and RM1J Delivered); QS public read blocked by a Cloudflare challenge, access route to the Platform Admin (IR-011); s970 recorded before merge.**

**S1-API-Frontend-Delivery, 22 Nov 2026 14:55 AEDT: consolidated batch started (S2 stands down); IR-011 and IR-005 Delivered Live (QS by annual upload); s971 v2.16.84 (ARWU reader, ranking editions publish and roll back, ranking SOP and runbook) recorded before merge.**

**S1-API-Frontend-Delivery, 22 Nov 2026 16:35 AEDT: s971 live (ARWU 2026 public, 1,000 rows, 59 AU/NZ/CA linked; THE, QS and ARWU side by side); s972 (REQ-105, Courses list on its Active index, filter lists by semi-join) and s973 (RM1K golden acceptance across Admin and Website v3, 10 of 10) recorded before merge.**

**S1-API-Frontend-Delivery, 22 Nov 2026 17:30 AEDT: s972 and s973 live (default Courses read 0.87-1.23 s signed in, filter lists 0.27-0.56 s; golden acceptance 10 of 10 live); s974 (one list read on opening Courses, v2.16.85) and s975 (OET letter grades for 256 requirements) recorded before merge.**

**S1-API-Frontend-Delivery, 22 Nov 2026 17:40 AEDT: consolidated batch complete; S2 stays parked. s974 (v2.16.85) and s975 live; REQ-105 Partly delivered (default list about 1 s, one read on opening; filtered views still slower); RM1K Delivered (IR-002 Delivered Live); OET letter grades 256 of 256; REQ-94, REQ-95, REQ-99 and IR-007 measured at $0, decisions needed.**

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

**S2-RM-Design, 23 Nov 2026 17:12 AEDT: s1009 live (Pilot #1497 `7e41c95`; migration `20261123170000` applied, md5 55c7bc84; `coverage-sweep` deployed with reader aer-det-v1.4).** Read back 16:58 AEDT: strict proof (`aer-course-proof-v1`) admitted 25 rows for 24 courses on its first tick; admitted courses (canonical rule) 10,441 → 10,461; active entry rows 27,929 → 27,954; the v1.4 sweep re-read 720 stored pages ($0), 15 older held reads superseded, 7 new v1.4 reads proposed; Website and Zoho v3 checked live: University of New England, Bachelor of Nursing returns rule 1 "Guaranteed ATAR: 65.00" (v2 step 5, frozen). Pending AER reads by reason: active_rows_exist 296, all_rows_held 249 (from 284), partial 75, no_bound_page 38, identity_not_admitted 11, not checked 7. Guardrails: 75/48 no drift; locks 7,585; active cron 135; `aer.machine_min_confidence` 0.8. The AER university register is S1-Build's (`docs/monitoring/AER_University_Reader_Status.csv`, daily 08:00 AEDT); this lane wrote none. Step 2 sized: entry-table rows held only for want of a linked course: UNSW 622, UQ 113 (course identity first); CDU's 45 entry-table rows wait as a Layer 4 first run since 3 Nov (layout case); proposed tables UWA 194, Victoria University 126, Macquarie 107.

**S2-RM-Design, 23 Nov 2026 16:09 AEDT (Platform Admin 15:52, Priority 2 Step 1): s1009 (Pilot, migration `20261123170000`, reader aer-det-v1.4) recorded before merge.** Strict-proof rule `aer-course-proof-v1` (third pass of `security.aer_partial_admit_v1`, every 15 min): a held course entry row becomes active only when it is for international or all applicants, an academic kind, its value word for word in its quote, with no maximum/"up to", no age and not a mark in one named subject (added after 99 of the 165 candidates proved to be "CBSE ... 65% in English" stored as an overall average); 5% audit share kept; `aer.machine_min_confidence` 0.8 untouched. Rehearsed live (rolled back): one tick admitted 25 rows in 24 items, 0 errors. Ledger de-duplication (item 2): not built: 0 repeated declines for one item in 7 days; the repeated hashes are one shadow plus one admit row per item by design, and shared pages. Reader v1.4: no maximum/"up to" read as a minimum; the quote carries its value; no overall average from one subject's mark; "International Baccalaureate" no longer cut to "International" (a v1.3 bug). The sweep re-reads stored pages of courses with no active entry row at $0, and an older held deterministic read gives way to the v1.4 read (not audit samples, claimed items, locks or courses with active rows).

**S2-RM-Design, 23 Nov 2026 13:17 AEDT: s1000 live (Pilot #1491 `675b14d`; migration `20261123100000` applied by Deploy on merge, run 45098467095); NZ/CA campus-link evidence audit recorded.** Acceptance (REQ-94 → Pilot #1491 → `security.entry_resolve_v3`, v3 course read, coverage rule): academic entry admitted by the canonical rule **2,250 → 10,441 courses (+8,191; 6.24% → 28.97% of 36,046, +22.7 points)**; 17,000 existing evidence-backed course entry rows now served (no new canonical rows: the rows were already active). Website and Zoho v3 checked live by keyed function calls for named courses (`edu_country` IN): Certificate III in Roof Plumbing (Austra College), Certificate IV in Automotive Mechanical Overhauling (New England College Perth) and Bachelor of Science, Bachelor of Commerce (Curtin) now return rule 1 with the course's rows on Website v3 and Zoho v3, where v2 still returns step 5 (frozen). Held: 442 courses hold only non-academic rows (notes, work experience, portfolio); 324 hold only an age limit (not served as an academic minimum); 24,839 active courses have no admitted entry row. The stored coverage table (daily readiness report) recomputes in provider chunks over about 3.5 hours (`rollup-scheduler`); at 13:10 it read 2,254 admitted and will reach the canonical figure as each chunk runs. Live 13:11: G3 75/48, no drift; locks 7,585; active cron 136 (unchanged by s1000). NZ/CA campus links: 667 without source or evidence (NZ 494, CA 173); 0 have course-level evidence; 30 conflict with an online delivery mode; 7 sit at multi-campus providers; none withdrawn (`docs/platform/2026-11-23-nz-ca-campus-links-evidence-audit.md`).

**S2-RM-Design, 23 Nov 2026 12:56 AEDT (Platform Admin 12:29, Priority 1: AER admission recovery): s1000 (Pilot, migration `20261123100000`) recorded before merge; database only, no version bump.** Found live (rolled-back read-backs, head `20261123060000`): 8,957 active courses (AU 8,601, NZ 356) read `academic_entry` no_reader while holding active, quoted, evidence-backed course entry rows for international or all applicants (8,515 with the academic kinds, the audit's figure). The rows are canonical already; `security.entry_resolve_v1` rule 1 reads only `override` rows and the coverage rule counts only override, matrix and provider-minimum rows, so Website and Zoho v3 answer "contact the provider" and coverage reports no reader. The v1 resolver feeds frozen v2 (`website_v2_course` → `entry_course_payload_v1`), so it is not edited (G3). s1000 adds `security.entry_resolve_v3` (v1's answer, except step 5 becomes the course's own academic rows as rule 1; an age limit is left out: 1,119 such rows), uses it in `website_v3_course` (Zoho v3 follows) and the Admin resolve views, and counts the same rows in field coverage. Rehearsed live and rolled back: academic entry coverage 2,250 → 10,441 courses (+8,191, +22.7 points of 36,046); in a 300-course sample 285 were step 5 and 0 remain; 0 other answers changed; Zoho v3 follows. v2 unchanged. Not done here: `docs/platform/TEST-REGISTER.md` (the generator needs `@playwright/test`, which this session cannot install); S2-Build's next register run includes the s1000 spec. s1001 stays with S2-Build.

**S2-Build, 23 Nov 2026 06:35 AEDT (scheduled run of the Platform Admin batch queued 22 Nov 2026 22:01 and its 22:57 addendum; S1 usage credit exhausted): s977 (v2.16.86, Pilot #1482, migration `20261123000000`) recorded before merge. REQ-105 closed for filtered and sorted Courses lists (set-based state path, each call planned with its own values: Australia + New South Wales by International fee 2.6-7.3 s before, 0.26 s list and 0.35 s through admin_read over eight calls in a rolled-back rehearsal; same rows, order and totals on eight lists); seven-filter counselling bar for Counsellor and Viewer with Clear / Reset (Operators and Platform Admins keep every filter); intake, fee range and English score filters; Settings › API usage in one compact table; Website API v3 search planned per call. Decisions needed: IR-012 (frozen Website API v2 latency), IR-013 (database load at :19-:23 and :49-:53), IR-014 (red Health: consumer snapshot and AER P0), IR-015 ($0 data gaps). Live 05:32: head `20261122230000`; G3 75/48, no drift; locks 7,585; active cron 134.**

**S2-Build, 23 Nov 2026 07:30 AEDT: s977 live (admin #789, then Pilot #1482 `775ea3d0`, v2.16.86); migration `20261123000000` applied by Deploy on merge (history md5 2a02cec0 matches the file). Live read-back: Australia + New South Wales by International fee 0.35 s steady over eight calls (1.19 s first call), Victoria 0.33 s, Website API v3 keyword search 0.51 s steady (no generic-plan slowdown); in the 07:20 job window (7 cron jobs running) the same read took 1.6-2.7 s (4.9 s first call), so under-load reads stay above 1.5 s until IR-013 (job staggering or compute) is decided; no 8 s timeout seen. REQ-105 stays Partly delivered for that reason. Guardrails live 07:15: G3 75/48, no drift; locks 7,585; active cron 134; $0 AI and Firecrawl by S2-Build. Counsellor and Viewer screens could not be checked signed in (the deployed UAT signs in as one user); TEST-REGISTER.md not regenerated (packages unavailable). Decisions needed: IR-012, IR-013, IR-014, IR-015; REQ-109 to REQ-111 scoping. Parked.**

**S2-Build, 23 Nov 2026 08:15 AEDT (Platform Admin consolidated morning batch, 07:16 and 07:45 AEDT): s978 (Pilot #1483, migration `20261123010000`, no version bump: database only) recorded before merge.** (1) Health `aer:p0` and IQ-00367: all 31 critical AER findings were false positives. 1,133 provider-table rows admitted by the partial admission rule `aer-partial-v1` (s914, Platform Admin 21 Nov 10:03) read as "not admitted" because their Layer 4 item stays pending for the rows held back. `security.aer_current_findings_v1` now accepts a row named by an admitted `aer-partial-v1` ledger row (Decision 276: correctness fix only). (2) IQ-00555: coverage-sweep's HTTP 500s (59 in 24 h) were `svc_scholarship_listing_next` timing out at 8 s. Provider checks now run once per provider (29) instead of per due page (339), and the host check only on pages that passed: 10.4 s under load before, 5.3 s after. (3) IR-013: aer-source-discover, field-gap-queue, aer-machine-admission, cdesc-queue-refresh and layer4-readiness move out of :19-:23 and :49-:53 (none to :00-:02; commands unchanged; layer2-onboarding-snapshot kept as a dispatcher shadow target). (4) $0 re-read: the existing `aer_det_reread_v1` rule supersedes the 106 stale AI course entry reads that have a stored copy and reopens them to aer-det-v1.3. Layer 4 goes from 1,580 to 1,474 in the dry run; nothing is approved or rejected. Of the "687 group-B" figure, 606 are already deterministic reads waiting for a person and 33 have no stored page, so the rule does not take them. Measured and not changed: the 48 international scholarships that look publishable are held by the publishability check (31 hand-check holds, 14 citizen-only, 3 other); 5,837 FID intake readings are months or terms with no date, held by the no-overwrite rule, so they cannot add exact intakes; provider description holds are identity and source policy holds (no switch was off; 2,291 admitted by rule); no pending Layer 4 item has a manual lock, and none of the 1,580 met a supersede rule. Courses text search took 1.4-5.4 s (filter itself 0.58 s); the Zoho v2 probe query (frozen) takes 2.4 s quiet because the frozen function materialises every matching row, so an index cannot fix it. Live 07:20: head `20261123000000`; G3 75/48, no drift; locks 7,585; active cron 136 (above the 134 asked; no job paused, decision needed); canonical AER 26,995, exact intakes 4,896, scholarships 1,074, provider descriptions 2,216.

**S2-Build, 23 Nov 2026 08:40 AEDT: s978 live (admin #791, then Pilot #1483 `b5dea68e`); migration `20261123010000` applied by Deploy on merge; s979 (Pilot #1484, migration `20261123020000`, data only) recorded before merge.** Live read-back 08:25-08:31: head `20261123010000`; both function edits present; five job schedules moved as planned; 106 stale AI course entry reads superseded and reopened to aer-det-v1.3 ($0); Layer 4 pending 1,484 (was 1,580). The 08:27 aer-reconcile run left **0 open AER P0 findings**, and Health check `aer:p0` resolved. The one critical check left is `consumer_snapshot:failing` (search_master_page2, the frozen Zoho v2 search; IR-012 keeps v2 frozen). The listing claim took 2.8 s at :28 (10.4 s under load before), with 0 HTTP 5xx since deploy. Job scholarship-listing, and coverage-read and coverage-read-2 (at 08:29), were switched off outside S2-Build, so active cron is now **134** (IR-016) and IQ-00555 and IQ-00029 have no fresh run to verify and stay open. s979 closes IQ-00367 and IQ-00239 (0 classify failures in 24 h). G3 75/48, no drift; locks 7,585; canonical AER 26,995 (unchanged: no new admission at $0); $0 AI and Firecrawl by S2-Build.

**S2-Build, 23 Nov 2026 09:10 AEDT: s979 live (Pilot #1484 `584754cd`; IQ-00367 and IQ-00239 closed, read back 08:54); s980 (Pilot #1486, no migration) and s981 (Pilot #1487, migration `20261123030000`) recorded before merge.** s980 (Platform Admin 08:47: stop failed dry-run notices; make migration pre-flight permanent). No push or pull-request run had failed. The four failed `Database migration dry run (rolled back)` runs were hand-started rehearsals and read-back probes: three probe typos and one real catch (run 45068758936, the s978 post-check timeout, fixed before its PR). The workflow now has two jobs. `dry-run` is the gate: pull requests to `main` that add a migration and carry `live-dry-run`, with no push trigger. It runs `scripts/ci/migration-preflight.mjs` against main and the live head before the dry run and fails hard. `rehearsal` is for hand-started runs: it reports failures as warnings and cannot satisfy the gate. A probe error prints `PROBE-ERROR` instead of failing. `.githooks/pre-push` runs the pre-flight locally. Standing rule "Migration Pre-flight Before Any Push (s980)" is in CLAUDE.md and AGENTS.md in both repositories. Verified live before merge: gate self-test PR #1485 green (pre-flight against live head 20261123020000, closed unmerged); rehearsal of an applied file reported a pre-flight failure as a warning, run green; probe typo printed PROBE-ERROR, run green; the s980 PR started no dry run. s981 (IQ-00555): after s978 the listing claim still timed out twice under load (21:37 and 21:52 UTC). `security.fc_sch_held_v1` now checks the cap before the eligibility rule (same rule and answers; parity checked in the migration), with a covering index. Rehearsed: hold check for 31 providers 58 ms (was about 1.6 s quiet), claim 1.7 s. Under load at 08:46 (22 jobs running) the Courses NSW-by-fee read took 5.3 s, text search 5.1 s and the Zoho v2 probe 4.8 s, so REQ-105 stays Partly delivered under load. Health: only `consumer_snapshot:failing` is left (frozen Zoho v2, IR-012). Branches `s2-build-reads` and `s2-build-am-reads` could not be deleted from this session (proxy refuses ref deletes); the `…-probe` branch is swept by Auto-merge. Live 08:54: head `20261123020000`; G3 75/48; locks 7,585; active cron 135; Layer 4 pending 1,483.

**S2-Build, 23 Nov 2026 10:00 AEDT: s980 live (Pilot #1486; dry-run gate and rehearsal job in use: the s982 rehearsal ran its pre-flight against live head 20261123030000) and s981 live (Pilot #1487, migration `20261123030000` applied; hold check 0.8 s for 34 providers at :52); s982 (Pilot #1488, migration `20261123040000`) recorded before merge.** After s981 the listing claim still took 5.5-7.6 s. EXPLAIN ANALYZE showed the planner running the host check on all 348 due pages before the provider filter. s982 puts the passing providers' pages in their own materialised step first: the claim takes 537 ms rehearsed at 09:54, against 7.6 s at 09:52. The last coverage-sweep 5xx was at 22:37 UTC (before s981); 4 since s978 in all. **Health has no critical check open at 09:51** (`consumer_snapshot:failing` resolved after the job stagger). Live 09:51: G3 75/48, no drift; locks 7,585; active cron 135; Layer 4 pending 1,483; AER 26,996, exact intakes 4,896, scholarships 1,074, provider descriptions 2,216.

**S2-RM-Design, 23 Nov 2026 11:25 AEDT (Platform Admin brief 11:11 AEDT): frozen design and governance contracts recorded; documents only.** `docs/Roadmap/2026-01/DESTINATION-DATA-DESIGN.md` v1.11, section "Frozen design and governance contracts": (A) AER admission: the brief's precedence mapped onto the unchanged resolver, a step-5 reason (`source_blocked`, `domestic_only`, `pathway_only`, `not_published_by_provider`) as a new v3 field beside `resolution.note` (the course `empty_reason_code` list is not widened), table rules N1 to N9 with CDU as the fixture, test and grade mappings, and the partial-admission rule that keeps `aer:p0` at 0; (B) scholarship publishability P1 to P10 with the Melbourne-date round state on the live values `open`, `closed`, `opening_soon`, `check_provider`; (C) Layer 4 close-by-rule predicates and five sign-off batches (82 primary-campus ties, 160 postcodes, 69 campuses, 5 English readings, 701 CRICOS departures); (D) QTAC and TISC: plain reads on 23 Nov found no official international route on either centre's own pages, so no state rule is written and the national rules cover QLD and WA; RM1C and RM1I publish checklists; JSA attribution; a QILT gate setting; RM1G teaching-language and NZ and CA study-load rules; (E) API v3 freeze audit, 13 items, all additive (ARWU and `primary_basis` values are missing from dictionary issue 1); (F) NZQCF, NZSCED and CIP native codes, one level mapping, and the campus-link reason contract; (G) UK, Ireland and USA adapter contracts and an AI Auto-Map ceiling of US$14.75; (H) one Platform Admin checklist, H-01 to H-12. **Nothing was built, deployed, approved or published; no live read was made (figures are the latest recorded ones); no Pilot file changed.** New requests IR-017 to IR-020. Build works from the section's order table under specs `s1000` to `s1008`. Open for the Platform Admin: sign H-01 to H-12.

**S2-Build, 23 Nov 2026 10:10 AEDT: s982 live (Pilot #1488, migration `20261123040000` applied by Deploy on merge); parked.** Listing claim 557 ms live at 10:08 (7.6 s at 09:52 before s982; 10.4 s under load before s978). No coverage-sweep 5xx since 22:37 UTC (before s981). Health has no critical check. IQ-00555 and IQ-00029 stay open until a day of clean listing runs. Live 10:08: head `20261123040000`; G3 75/48, no drift; locks 7,585; active cron 134. Open for the Platform Admin: non-AER Layer 4 rule-group settlement needs an approve or reject choice per group (not run); 606 deterministic AER reads stay for a person, one by one; under-load Courses reads (5.1-5.3 s at 08:46 with 22 jobs running) keep REQ-105 Partly delivered; branches `s2-build-reads` and `s2-build-am-reads` need deleting by someone with write access.

**S2-RM-Design, 23 Nov 2026 12:19 AEDT (Platform Admin review of admin #797, 12:10): design v1.12, targeted reconciliation; documents only.** The contracts in `docs/Roadmap/2026-01/DESTINATION-DATA-DESIGN.md` are the **implementation baseline**, not production-verified. Seven corrections, checked against the live system by three rolled-back probes (Pilot `db-migration-dry-run` rehearsals 45093300850, 45093450408, 45093457903; head `20261123060000`): (1) no NZ or CA `register_rule` study load (NZ 4,172 and CA 2,362 courses have none; none register-sourced); (2) no course-campus link without course evidence; the 257 s818 links of 20 Nov (NZ 177, CA 80) stay as the accepted decision, withdrawal optional (H-09); (3) primary-campus tie-breaks and the below-90% postcode batch withdrawn (95 providers without a primary campus stay unresolved); (4) P8: provider-wide scholarships pass with a stated scope (0 of 1,140 unpublished are held by the course-link checks); (5) TISC recorded as unreachable, not as absence of guidance; IR-007 open for TISC; (6) QILT is served live in v3 (3,164 rows, 118 providers), so any gate needs approval and a developer notice (H-12); (7) `[D]` names corrected (`status`, `pipeline.aer_machine_admissions`, `catalogue.provider_entry_matrix`). Approvals reconciled row by row: decisions left are H-01 and H-02 (publish) and the optional H-03, H-06, H-08, H-09 and H-12; IR-017 and IR-019 closed. Build order handed to S2-Build: `s1001`, `s1000`, `s1002`, `s1007`, then `s1004`–`s1006` and `s1008`; each completes only with the production acceptance record (design section I). No Pilot or live change; the probe branch was deleted by the Auto-merge workflow.

**S2-Build, 23 Nov 2026 12:05 AEDT (Platform Admin batch 11:10, "Data Admissions unblock, AER and scholarship coverage"): s983 (Pilot #1489, migration `20261123050000`) and s984 (Pilot #1490, migration `20261123060000`) recorded before merge.** Measured first (rolled-back read-backs 11:11-11:55; head `20261123040000`):
- **AER, 615 deterministic course reads in Layer 4:** 284 have every row at confidence 0.70, and the samples are genuinely wrong ("Units 3 and 4" read as a score of 4), so they stay held. 347 are held whole by the completeness gate, which flags a printed "other requirement" the reader skipped; 933 of their rows pass every machine row rule, and none of those courses had an active entry row.
- **Scholarships:** of the unpublished active records, 193 are held only by "no stated award value". 13 of them state the value in their stored note. The rest of the 48 international candidates are held by a person's hand check (31) or are citizens-only (14); those holds stand.
- **s983:** `security.aer_partial_admit_v1` gains rule `aer-course-partial-v1`, row-level partial admission for course reads stopped only by the gate. It applies the same policy as s914, with no lock, no overwrite and every row rule kept; the item stays in Layer 4 for the rest. `security.aer_current_findings_v1` counts these rows as admitted. Rehearsed over two ticks: **933 rows on 347 courses, active AER 26,996 → 27,929**, 0 false P0.
- **s984:** the hourly `scholarship_auto_publish_v1` reads the award value from the stored note of a text-only record before its publishability check: tuition percentage, tiers taken as the upper figure marked "up to" (REQ-64), and explicit amounts in the provider country's currency. Rehearsed over one tick: 16 values read, **12 now publish**.
- **Not changed:** the 0.70-confidence reads and the hand-checked or citizens-only scholarships (a person's holds and genuine rules); FID intake readings (months, no dates); Firecrawl fetches ($0 rule).

Live 11:11: G3 75/48; locks 7,585; active cron 134; Layer 4 pending 1,483.

**S2-Build, 23 Nov 2026 12:40 AEDT: s983 and s984 live (Pilot #1489 and #1490; migrations `20261123050000` and `20261123060000` applied by Deploy on merge); parked.** Read back live at 12:31:
- **AER:** active course entry rows rose from **26,996 to 27,929** (+933). All are from rule `aer-course-partial-v1`, on 347 courses, with 0 open P0 findings.
- **Scholarships:** the 12:29 publishing tick read values from 16 stored notes and **published 12**, so published is now **1,078**. Before the change the count was 1,066, because 8 scholarships whose closing date had passed (Melbourne date) were withdrawn automatically at 11:29 (REQ-72).
- **Unchanged at $0:** exact intakes 4,896 (FID readings carry months, not dates) and provider descriptions 2,216 (identity and source policy holds).
- **Health:** one critical check is open, `alerts:not_collected`. Five platform alerts have waited since 08:30 because the alert destination (the "Work queue alerts" scheduled task, not owned by this account) is not collecting them. It is unrelated to these releases and needs its owner to restart it.
- **Coverage-sweep:** no 5xx since 22:37 UTC. The one 5xx in the last hour came from the Boost bulk-ingest worker, a different lane.
- **Guardrails:** G3 75/48, no drift; locks 7,585; active cron 136 (coverage-read and coverage-read-2 switched back on outside S2-Build; cap 140); Layer 4 pending 1,483 (the 347 course items stay for their held rows); $0 Firecrawl and AI by S2-Build.
- **Left for a person:** 284 deterministic course reads at confidence 0.70 (unreliable reads; a better reader is AER v2 work); 31 hand-checked and 14 citizens-only scholarships; the CDU two-column pathway layout (REQ-99) needs a new layout reader, which Decision 276 sends to AER v2.

**S2-Build, 23 Nov 2026 13:10 AEDT (Platform Admin 13:00: parallel data-admission lane registration): ownership recorded in `docs/platform/CONTINUOUS-DELIVERY-MASTER-PLAN.md` section 3a; documents only.**
- **Single-writer domains:** S2-CF (official course URL, course description), S2-INT (exact intake dates, application deadlines), S2-GEO (campus locality, city statistics; read-only until the Platform Admin confirms `destination.*` passes from parked Lane 2), the AER/ELR owner (English requirements; the Platform Admin names the next writing chat), AER (`s1000` preserved with S2-RM-Design, Pilot #1491), S2-Build (scholarships, `s1001`) and S3 (spend gate, Firecrawl containment, Layer 4 hygiene).
- **Integration owner:** S2-Build, for dispatchers and schedules, `course_coverage_build_v1`, health and consumer checks, v3 serving and the developer hold, migration numbering at merge, versions, spec claims and shared registers.
- **Specs:** claimed centrally in the plan; next free `s985`; `s1003` unassigned. No migration timestamp or version is held in advance.
- **Checked live 13:05:** every scheduled job is mapped to one owner; the only open pull request is #1491.
- **Duplicate avoided:** S2-Build had measured the same AER resolver gap 12:47-12:58 and stopped before writing any file, because `s1000` covers it.

**S2-Build, 23 Nov 2026 13:20 AEDT: Platform Admin ownership decisions of 13:13 recorded in plan section 3a; documents only.**
- **City statistics:** `destination.*` passes from parked Lane 2 to S2-GEO. S2-GEO stays read-only until it reports its discovery findings and the Platform Admin unlocks writes.
- **English requirements** (`enrich:english`): stays with S1-ELR, or a dedicated S2-ELR session when one opens, and is parked. None of the five active lanes writes ELR code.
- **Rest of the 12:47 AER brief:** the CDU two-column layout, the 284 reads at confidence 0.70, the high-yield universities and ingress hash de-duplication go to S2-RM-Design as Priority 2, strictly after Pilot #1491 (`s1000`) merges on green.
- **Next:** S2-Build starts `s1001` (scholarship coverage for Charles Darwin, Lincoln and Torrens, plus the guardrail against scholarship extraction answers being cut off).

**S2-Build, 23 Nov 2026 14:00 AEDT (Platform Admin 13:13: s1001 scholarship coverage for Charles Darwin, Lincoln and Torrens, plus the M3 extraction cut-off guardrail): s985 (Pilot #1492, migration `20261123110000`) recorded before merge.** Measured first (rolled-back read-backs 13:25-13:50):
- **Cut-offs:** in 48 hours 68 of 430 scholarship extraction calls (15.8%) stopped at the 4,500-token limit. All were candidate pages listing many awards (school pages); successful answers are 1,518 tokens at p90. A cut answer went to the next model as the same whole-page request and cut again (21 items). s985 sends it as the existing two-part read (`sectioned-v1`). The limit is not raised, because that would make runaway answers dearer, not complete.
- **Torrens:** its 3 international pages were refused as "not a university provider" because its joined trading names include "Language Centre". s985 switches on the IQ-00215 legal-name test (shipped off on 4 Nov; it brings only Torrens into scope) and re-admits the 3 candidates through the canonical admission function. Rehearsed: Family scholarship (35%) and Motivational scholarship (25%) pass every check and publish on the next hourly tick.
- **Charles Darwin and Lincoln:** refused by their own pages (domestic only, international not stated, not a scholarship page); no refusal came from a cut answer. Their international awards sit on listing pages that need the listing reader (job `scholarship-listing` has been off since 08:29), which is the discovery gap for slice 2.
- **Not built:** a nationality rule. The readings mix code formats (AUS against the host code AU), so domestic awards would publish.
- **Spec claim:** `s985` taken (central table); `s1001` stays for the P1-P10 reconciliation fixture.

**S2-Build, 23 Nov 2026 14:45 AEDT: s985 live (Pilot #1492 merged 13:58; admin #804).** Live read-backs 14:05 to 14:40:
- **Deployed:** migration head `20261123110000`. The legal-name switch is on. `svc_scholarship_ai_record` now sends a cut answer to the next model as the two-part read (`sectioned-v1`).
- **Torrens University Australia:** 3 candidates admitted. The 14:29 auto-publish tick published **Family scholarship** and **Motivational scholarship**, so Torrens went from 0 to 2 published. Published scholarships overall went from 1,078 to 1,080.
- **Cut-off guardrail not yet seen live:** no extraction has run since 03:21 AEDT. All 39 queued items are `admit` items with no stored page copy. Stored-first is on and the scholarship Firecrawl lane is on budget hold ("no room left in today's Firecrawl share for scholarships"; $0 Firecrawl, S3 containment), so the picker takes nothing. The fire job still calls the worker about 255 times an hour, and each call returns 0 items after 16 to 32 seconds, because its "due" count includes items the picker cannot take. Both the guardrail check and that wasted-call fix are S2-Build scholarship work.
- **Guards:** locks 7,585; active cron 133; $0 Firecrawl; no new AI use.
- **Charles Darwin and Lincoln:** unchanged at 0 published. Their international awards are on listing pages; slice 2 is a $0 listing read.

**S2-Build, 23 Nov 2026 16:20 AEDT (Platform Admin 15:39, 15:40 and 15:54): s989 (Pilot #1496, migration `20261123160000`) recorded before merge; TEST-REGISTER regenerated; AER University Reader Status register handed to S1-Build.**
- **s989 empty-call fix:** `security.scholarship_ai_fire_v1` counted every queued item as due, but the picker takes only items whose provider is not hidden and that either the Firecrawl lane may fetch or that have a stored copy. While the scholarship Firecrawl lane was on budget hold, the 39 queued admit items (none with a stored copy) produced about 255 worker calls an hour, each returning 0 items after 16 to 32 seconds. The fire job now counts only items the picker can take, bounded by what the send loop uses (worst case 182 ms). Rehearsed, rolled back: 1 call a minute instead of about 4 empty ones, now the existing idle fill from stored official pages (3 detail items; stored copies only, $0 Firecrawl, scholarship AI $0.10 today).
- **TEST-REGISTER:** regenerated with `node scripts/test-register.mjs` (Pilot main plus s989). It adds `s1000` (S2-RM-Design), `s986` and `s987` (S2-INT) and `s989` (958 specs, 4,389 tests), and replaces the hand-added rows of `s974` to `s985` with the generator's own text. A local stub stood in for the missing `lucide-react` package so that the 4 UI specs importing it could be listed; nothing about the stub is committed.
- **Hand-off (Platform Admin 15:54):** the AER University Reader Status register (`docs/monitoring/AER_University_Reader_Status.csv`, the Drive sheet `Monitoring / AER_University_Reader_Status` and its daily sync) is owned by `S1-Build`. S2-Build stopped work on it (read-only discovery only; nothing written) and records the transfer in plan section 3a.
- **Next (S2-Build):** merge s989; slice 2, the $0 direct read of the Charles Darwin and Lincoln listing pages, with live verification of the two-part cut-off read.

**S2-Build, 23 Nov 2026 18:30 AEDT (Platform Admin 15:39, 17:45 and 17:49): s989 live; s992 (Pilot #1500, migration `20261123190000`, worker v1.0.35) recorded before merge; TEST-REGISTER regenerated.**
- **s989 live (Pilot #1496, merged 16:35):** scholarship worker calls fell from 65 to 2 a quarter-hour; extraction restarted (4 in the first 30 minutes).
- **Why Charles Darwin and Lincoln were at 0 (measured):** Charles Darwin's finder is an APEX app that lists nothing without a browser session. Its international awards are on official pages (`/international/how-apply/scholarships`, `/international/scholarships`) that were never listing sources, and its Vice-Chancellor's High Achievers record is held for want of a stated value. Lincoln holds only the closed CSC award; its international page (listing source #10) prints the Flagship and master's awards in sections, but its next read was 15 Dec. Listing pages were read through the scraper first, S3 s976 holds Firecrawl at a zero daily total, and while the lane was held the picker took only pages with a stored copy (39 admit items had waited since 03:21).
- **s992:** (1) Listing pages are read directly first; the direct copy is used only when it gives items, and otherwise the scraper is tried as before (refused at the zero total). (2) `lanes.stored_first_on` 1 to 0 (used only by the three scholarship lanes). Copy-less pages are read directly; a page that cannot be read directly waits 30 minutes. The migration requires the zero total, so the change is $0. (3) The two Charles Darwin pages are registered as listing sources and, with Lincoln #10, read first (367 sources are due). Rehearsed: the picker takes 12 items (was 0); the next listing call takes those three pages.
- **Firecrawl window (Platform Admin 17:49):** not opened. s976's zero total refuses on-demand spend too, so a window needs `firecrawl.daily_budget_total` raised. That is S3's setting and a Platform Admin decision.
- **TEST-REGISTER** regenerated (961 specs, 4,400 tests): s985 to s989, s992 and s1000; s990 joins when Pilot #1498 merges.
- **Queue:** Charles Darwin and Lincoln stay `CLAIMED:S2-Build` (s992) until the live read-back after deploy.

**S2-Build, 23 Nov 2026 19:35 AEDT: s992 live (Pilot #1500, merged 19:13, deployed 19:15; migration renumbered to `20261123200000` after S2-INT s994 took `20261123190000`); parked.**
- **Live read-back 19:25:** `lanes.stored_first_on` is 0. Worker v1.0.35 read both new Charles Darwin listing sources directly ($0, 2 items each). The only linked award is Australia Awards, already held; the Global Merit and International College awards are printed in sections with no per-award link. Lincoln #10's direct copy gave no items, fell back to the scraper and was refused (`waiting_scraper`); an earlier scraper read found only 2 items, so Firecrawl would not fix it. The next S2-Build step is a heading-based award splitter that feeds each section to the two-part read.
- **Cut-off escalation live:** 3 cut answers since 14:30 and 1 next-model item queued as `sectioned-v1`.
- **Stuck items:** the 39 admit items were tried directly, did not open, and wait 30 minutes ($0).
- **Published:** 1,081 (1,078 this morning; Torrens +2). G3 75/48 with no drift; locks 7,585; active cron 136; scholarship AI $0.01 in 12 hours; Firecrawl $0.
- **Firecrawl window (Charles Darwin and Lincoln):** not opened. S3 s976's zero total refuses on-demand spend, and the blocker is the page layout, not fetching.
- **Queue:** both rows stay `CLAIMED:S2-Build` (s992) with notes, because the section splitter continues them.
- **Docs:** design doc section 10 mirrors Drive blueprint Section 6 (Platform Admin 18:48). TEST-REGISTER regenerated from Pilot main (965 specs, 4,419 tests; adds s990 and s994).

## 24 Nov 2026 18:50 AEDT — S1-RM-Design s1073: scholarship publication recovery from existing data (Platform Admin 18:02)

- Assignment: existing admission and publication backlog only; no readers, no source discovery, no new jobs, US$0 AI, zero Firecrawl, no rule relaxation.
- Baseline: 1,096 published, 114 providers, 492 active unpublished, 72 scholarship Layer 4 pending across 31 providers.
- s1073 (rehearsed, md5 9677bd3e): the citizens-and-residents publication check accepts precise international wording; 9 awards. 18 more are already publishable for the hourly run.
- Report and decisions for a person: `docs/platform/2026-11-24-s1-rm-design-scholarship-publication-recovery.md`.
- 19:35 AEDT outcome: s1073 live (Pilot #1567, migration `20261125060000`); unattended cycles 18:29 (22) and 19:29 (25, all 9 s1073); published 1,143 (+47), providers 127 (+13), active unpublished 476; Layer 4 pending 72 (31 providers). $0.

## S2-AER reader handoffs — 24 November 2026 17:20 AEDT

Source: live rolled-back read of the pending `entry_matrix_first_run` items stopped at `gate_incomplete` (machine check D-R3). Source artefacts are the stored copy of each run's source (`pipeline.entry_matrix_sources.url` via the run; stored under `aer-artifacts/<provider>/`). Admission validation is not weakened: the reader must produce rows whose quote is on the stored page and whose grade, band or value is printed in the quote.

**Allocation.** AU rows go to S1-AER-Claude; NZ and CA rows go to S3-AER-ChatGPT. Paste-ready instruction: *Re-read the listed provider sources from the stored copy ($0, tier 1). For each run below, output only rows whose `quote` is verbatim on the stored page (reason `quote_not_on_page`) or whose grade, band and value are printed inside the quote (reason `grade_not_in_quote`, `band_not_in_quote`, `value_not_in_quote`, `value_without_scale`). Do not change `security.aer_matrix_machine_check_v1` or `aer-partial-v1`; verify the admission outcome after the re-read and report proposed versus admitted from `pipeline.aer_matrix_machine_admissions`.*

### Quotation not found on the page (13)

| Country | Provider | Provider ID | Run ID | Reason |
|---|---|---|---|---|
| AU | Kaplan Business School | `5fac5555-18f9-4bc7-91e4-e1466f8e33e3` | `b6bb7a20-60e2-4608-863c-9929920bf8cb` | quote_not_on_page |
| AU | Deakin College | `d090e283-9894-49ce-baf3-e9d47f80e468` | `0f18e898-4c90-430c-8618-52e9981e0d18` | quote_not_on_page |
| AU | Australian Learning Group | `c433c71e-7ffd-4603-bfc7-06bc0a849bb4` | `350d0edb-926f-46c5-8e08-dc87badd58e3` | quote_not_on_page |
| AU | Murdoch College | `1b8db821-3b4c-4c17-a7d7-6819923352d6` | `d6a696da-8f9b-4fe4-8f4d-598ec3fd2022` | quote_not_on_page |
| AU | Federation University | `9cc8ef21-52ec-4c18-849a-598ba1072459` | `1f327610-269d-479d-b7d2-f34a22edc560` | quote_not_on_page |
| AU | TAFE Queensland | `bf68c5a3-77c4-4ab8-8c84-6d99e435b1f5` | `fb537618-7e7e-44c4-85cd-f82423920395` | quote_not_on_page |
| AU | Curtin College | `0ba022f8-dd06-49f5-9c96-2e80a3d71e16` | `9f4ca424-e02f-435f-8ef2-2eb208905cab` | quote_not_on_page |
| AU | University of Wollongong | `62e61a02-9fcb-4c5e-bb11-1c43bed6eee6` | `0ff79fe4-77d0-4be6-946e-901a2c1180f3` | quote_not_on_page |
| AU | Australian National University | `e47a940d-186f-4a17-bb22-2b794b73248c` | `f75baa9e-f4c2-448b-a413-ab2e133177c7` | quote_not_on_page |
| NZ | Queenstown Resort College | `4f9da0a5-cdb7-4f6c-8b21-93e5d03840bb` | `03dd63da-74af-49eb-9944-7790b504b4f6` | quote_not_on_page |
| NZ | School of Audio Engineering NZ | `cc164a3e-f622-40ca-91fb-99b4a2defe88` | `522d7e16-0737-4ad3-9ff7-e95ab738a3ef` | quote_not_on_page |
| NZ | Yoobee Colleges | `e503631d-05b4-44dd-b438-77c9dfc0c1e5` | `1c65ac04-7ef1-435e-9f31-616503e75ec0` | quote_not_on_page |
| CA | University of Northern (CA) | `0d47cf4f-7389-4d92-b7a7-8a2eba6ea1e6` | `a9d561ae-61b6-40d1-8fac-b4ae83b8b8c0` | quote_not_on_page |

### Grade, band or value not supported by the quotation (14)

| Country | Provider | Provider ID | Run ID | Reason |
|---|---|---|---|---|
| AU | Curtin University | `982fb12f-41ed-4358-9d1b-d7422b3089dd` | `8b4e3d3b-d402-4a6c-9b6e-b78ef1385732` | grade/band/value not in quote |
| AU | University of Technology Sydney | `9d22a19e-c3f7-4012-b738-17bc0b481e7f` | `4ef170a5-6d2f-418a-9c31-ba7635b4127f` | grade/band/value not in quote |
| AU | Sydney Institute of Higher Education | `8c43cfec-c6d4-42fc-a9d9-5f0896536681` | `1a614b73-be86-4aa3-882d-22b3c11475ab` | grade/band/value not in quote |
| AU | Curtin College | `0ba022f8-dd06-49f5-9c96-2e80a3d71e16` | `31fdb5de-9a77-4c37-9fe0-373eebb9bf33` | grade/band/value not in quote |
| AU | Australian Professional (APCI) | `ec4594c0-b71d-4c8d-8226-b6ee1c22a908` | `61b2e3cc-f436-4fa4-946d-a8a2ce15c674` | grade/band/value not in quote |
| AU | TAFE South Australia | `f9f630ea-f6ca-43d9-85a2-571dec0255e2` | `92e8223b-6940-4f5c-88ec-48f4fc1e4974` | grade/band/value not in quote |
| AU | Canberra Institute of Technology | `d02a8a1b-f4be-4d98-a857-242e66a0f354` | `2331fd3d-2fce-43a9-9079-3266cd2d4455` | grade/band/value not in quote |
| AU | Charles Darwin University | `6f5cb7f7-7c70-4c06-970f-f368c3a786e2` | `3f8b9d04-a106-47a5-ab75-fabb769bc21f` | grade/band/value not in quote |
| AU | Charles Sturt University | `f34fae5e-b5b9-4c82-a6ca-44bf0803020e` | `ab9e52d9-cd6b-4788-8cfd-04ce82270e8e` | grade/band/value not in quote |
| AU | Macquarie University | `188103a5-1aba-4f99-bd3e-0416659086d3` | `19450c90-3991-43b1-a0b7-979f76c3fed3` | grade/band/value not in quote |
| NZ | Laidlaw College | `4fdf1c36-59eb-47e8-802d-39aea9f39b37` | `e2d0c5d6-bbf5-4627-8772-572c3c914153` | grade/band/value not in quote |
| NZ | Christchurch Institute (CIC) | `9fefeda5-cf10-4832-81f9-c2779e9cf45c` | `28201956-3a5b-447d-bf5c-b07cf2726f0b` | grade/band/value not in quote |
| CA | MacEwan University | `50efbfe2-b917-4cf7-be50-4a53c9a718d7` | `a27ae540-5870-4109-9417-bf289880ae11` | grade/band/value not in quote |
| CA | Kwantlen Polytechnic University | `3e436a48-1f61-4690-9fbd-4c749f3acfef` | `b3e7224a-4662-4459-ba71-b3bd84ea968b` | grade/band/value not in quote |

### Blank-country rows (46 rows, 8 providers; reader output, not a mapping gap)

Provider ID prefixes: `0e1532b8`, `16fd98a2`, `36086f5e`, `473c55a7`, `7dae6c50`, `83dea26c`, `8bec3062`, `db4c5deb`. The reader returned no country and an unrecognised qualification; owners fix the reader output for the country or qualification the page names. Regions (Europe, Pacific Islands) and scope words with an unrecognised qualification are not mapped by S2-AER (no inferred equivalence).

## S2-AER AER admission blocker register — 24 November 2026 20:15 AEDT

Live read (rolled back) at 20:10 AEDT, migration head `20261125060000`. **Baseline:** proposed rows AU 1,593, NZ 831, CA 50 (2,474); active matrix rows AU 6,702, NZ 540, CA 17 (7,259) at 61 providers with active data. Pending Layer 4: 63 `entry_matrix_first_run` items (44 gate_incomplete, 15 all_rows_held, 1 host_shared, 1 no_rows, 1 earlier_rejection, 1 `aer-matrix-machine-v1-except` for Griffith, 5 rows to admit, 4 held by rule, which the machine settles on its next cycle) and 13 `entry_matrix_change` items. Proposed rows by owner item: 1,205 under first-run items, 1,269 under change items.

**What is executable by the machine is already flowing.** Nothing remaining is blocked by a shared mapping defect that can be fixed without inferring equivalence: the stored level wording on proposed rows is either empty or an applicant qualification, not a course level (see Reader contract gaps).

| Group | Provider IDs (prefix) | Rows | Blocked step | Exact reason | Evidence | Owner | Next action |
|---|---|---|---|---|---|---|---|
| Change to an admitted table (13 items) | Flinders `0a42da16` (4), Massey `229dc07d` (38), Whitireia and WelTec `40f9891f` (97), Auckland Univ. of Technology `39301fa8` (63), Otago `ab12c7f8` (0), ANU `e47a940d` (15), Lincoln `248374d1` (110), Waikato `00e5f26c` (40), Auckland `e096aba7` (126), Top Education Institute `c8a3391d` (228, two items), Waikato Institute of Technology `742eef0a` (193), ACU `030992c3` (370) | 1,269 | Admission | `change_of_admitted_table`: a change to an admitted table stays with a person | machine check rule `change_of_admitted_table` on each item | Platform Admin (Layer 4 Approve, Approve except or Reject) | Technical recovery first: every item is `technical_blocked` (dropped published rows); see the triage table below. Top Education Institute's two items read two different source pages |
| No level and no course on the row | AU/NZ providers (8 with level_unmapped; John Paul College `1791f436`, Melbourne `de6d32b0`, Empyrean `1d1f9816`, Tasmania `719403bc`, ANU `e47a940d`, UWA `9109fe0c`, Royal Roads `57695444`, Langara `89bab0e8`, Mount Royal `d38d9f8a`, Athabasca `e450a320`) | 314 held (291 with no `level_label`); platform-wide 491 proposed rows have neither level label nor course | Mapping | `level_unmapped`: the reader wrote no `study_level_id` and no usable `level_label` | `held_back_by_rule` on the all_rows_held items | S1-AER-Claude (AU), S3-AER-ChatGPT (NZ/CA) | Reader writes the course level or the course link the page names; no inference by S2-AER |
| Applicant qualification in the level field | UWA and others | about 150 | Mapping | `level_label` holds text such as "Year 12 Equivalent" (40), "Year 10 Equivalent" (31), "Secondary School" (16), "MQP" (9), "Graduate Admission" (8), "Year 3 Admission" (8): an applicant qualification or an ambiguous entry point, not a course level | `unmapped_labels` read 20:10 | Reader owners | Reader puts these in `qualification_name`; level stays the course level |
| Quotation not on the page (13) and value not in quotation (14) | listed in the handoff section above | n/a | Evidence | `quote_not_on_page`; `grade_not_in_quote`, `band_not_in_quote`, `value_not_in_quote` | handoff tables | S1-AER-Claude (AU), S3-AER-ChatGPT (NZ/CA) | Re-read from stored copy, tier 1 |
| Blank country (46 rows, 8 providers) and 20 non-alias mapping exceptions | `0e1532b8`, `16fd98a2`, `36086f5e`, `473c55a7`, `7dae6c50`, `83dea26c`, `8bec3062`, `db4c5deb` | 46 and 20 items | Mapping | no country named; scope words with no recognised qualification; regions | s1070 classification | Reader owners | Reader names the country or qualification the page prints |
| No rows, earlier rejection | Newcastle `1822b40a` (UoN agents entry requirements page), Otago Polytechnic `cd27693c` | 0 | Layer 4 | `no_rows` (read proposes no row); `earlier_rejection` (a person rejected an earlier read of this source) | machine check output | Platform Admin | A person decides |
| host_shared | RMIT Pathways | n/a | Identity | shared host with RMIT (508 active courses); source ownership not independently proved | s1048 read-back | S2-AER | Held until source ownership is proved |
| Other | Provider-specific: South Pacific College `c40603c2` (`course_unlinked` 1), Amtech `bf0d1a82` (`no_minimum` 1), Victoria University `34616965` (`applicability_unresolved` 1), King's University `370a325f` (`minimum_not_in_quote` 1) | 4 | Evidence | as named | `held_back_by_rule` | Territorial reader owners | Reader fix or person |

**Active courses for the 12 change-item providers** (S2-RM-Design, live read rolled back 24 Nov 2026 22:15 AEDT, migration head `20261125150000`; active = `lifecycle_status = 'active'`; covered = `security.aer_covered_courses_v1()`):

| Provider | ID (prefix) | Active courses | Covered now | Active matrix rows | Proposed rows | Pending change items |
|---|---|---|---|---|---|---|
| Flinders University | `0a42da16` | 483 | 131 | 12 | 4 | 1 (11 Nov), undergraduate page |
| University of Auckland | `e096aba7` | 458 | 13 | 20 | 126 | 1 (24 Nov 04:19), programme-specific PDF A to I |
| Australian National University | `e47a940d` | 377 | 279 | 231 | 15 | 1 (11 Nov), IB page; its 15 proposed rows sit outside the item's run |
| University of Waikato | `00e5f26c` | 279 | 166 | 35 | 40 | 1 (24 Nov 00:55) |
| Massey University | `229dc07d` | 265 | 52 | 36 | 38 | 1 (11 Nov) |
| Auckland University of Technology | `39301fa8` | 257 | 185 | 56 | 63 | 1 (11 Nov) |
| University of Otago | `ab12c7f8` | 252 | 55 | 1 | 0 | 1 (11 Nov), no proposed row |
| Lincoln University | `248374d1` | 199 | 4 | 58 | 110 | 1 (24 Nov 00:55) |
| Australian Catholic University | `030992c3` | 149 | 128 | 377 | 370 | 1 (24 Nov 08:30), country PDF |
| Waikato Institute of Technology | `742eef0a` | 144 | 106 | 36 | 193 | 1 (24 Nov 06:25) |
| Whitireia and WelTec | `40f9891f` | 116 | 11 | 44 | 97 | 1 (11 Nov) |
| Top Education Institute | `c8a3391d` | 45 | 37 | 21 | 228 | 2 (24 Nov 06:50), two different source pages (imc.edu.au 125 rows; own page 103 rows), not duplicates |
| **Total (12 providers)** | | **3,024** | **1,167** | **927** | **1,284** | 13 |

The 13 items stay with a person (Layer 4 Approve, Approve except or Reject); the machine check returns `change_of_admitted_table` on every one. Correction to the 20:15 row: Top Education Institute's two items read two different source pages, so they are not duplicates. Platform: active matrix rows 7,261 (7,259 at 20:10); covered courses 10,729; the machine admitted nothing in the last 24 hours (9 `aer-machine-v1` declines). No reusable non-inferential rule was found. The 53 proposed rows failing value-in-quote are misreads (the value is not in the quote, or the quote is cut), not a normalisation fault. **Triage of the 13 `change_of_admitted_table` items** (S2-RM-Design, live read rolled back 24 Nov 2026 23:00 AEDT). Rows are compared with the active rows of the same source on country, qualification, level, kind, band and course. "Superseded" means active rows of that source that an approval would supersede. "Fail value proof" means the row has no minimum, or its value is not in its quote. "Blank level" means no level and no course.

| Item | Provider (prefix) | Active (same source) | Proposed | Unchanged | Changed score | Added | Superseded | Net active Δ | Fail value proof | Blank level | Read problem | Safe to bulk approve |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `c2160eb7` | Australian Catholic University (`030992c3`) | 377 | 370 | 333 | 0 | 37 | 44 | +326 | 31 | 0 | PDF; 13 published rows dropped (Macedonia; CAPE, GED, WASSCE named with no country); 5 duplicate-identity groups | No (technical_blocked) |
| `fab889ea` | Top Education Institute (imc.edu.au page) (`c8a3391d`) | 19 | 125 | 0 | 0 | 125 | 19 | +106 | 100 | 0 | incomplete; 25 dropped (Bangaldesh, Hong Kong (China), Phillipines, Taiwan(China)); 23 duplicate groups | No (technical_blocked) |
| `b039b107` | Top Education Institute (own page) (`c8a3391d`) | 2 | 103 | 0 | 0 | 103 | 2 | +101 | 78 | 0 | incomplete; 20 dropped (same four names); 19 duplicate groups | No (technical_blocked) |
| `6a0ee5c4` | Waikato Institute of Technology (`742eef0a`) | 36 | 193 | 3 | 6 | 184 | 27 | +166 | 153 | 0 | complete (html-table-v1) but 4 rows dropped (no worded header); 1 duplicate group | No (technical_blocked) |
| `04a4ad2a` | University of Auckland (`e096aba7`) | 2 | 126 | 2 | 0 | 124 | 0 | +126 | 0 | 4 | PDF; 1 dropped (grid piece without course column); 32 rows with no linked course | No (technical_blocked) |
| `23367623` | Lincoln University (`248374d1`) | 58 | 110 | 0 | 0 | 110 | 58 | +52 | 60 | 0 | incomplete; 4 dropped (Cambridge Pre-U, Middle Eastern Countries, South Pacific Countries); 1 column-label row | No (technical_blocked) |
| `7a980fce` | Whitireia and WelTec (`40f9891f`) | 44 | 97 | 44 | 0 | 53 | 0 | +97 | 49 | 44 | 4 dropped (Worldwide, WW; 2 quote not on page) | No (technical_blocked) |
| `e633ab92` | Auckland University of Technology (`39301fa8`) | 56 | 63 | 35 | 1 | 27 | 20 | +43 | 35 | 2 | 6 dropped (Worldwide); 1 column-label row | No (technical_blocked) |
| `c0c90fdb` | University of Waikato (`00e5f26c`) | 0 | 40 | 0 | 0 | 40 | 0 | +40 | 18 | 0 | incomplete; 6 section headings dropped (first column not a country or qualification); its 35 active rows come from another source | No (technical_blocked) |
| `ed07fb13` | Massey University (`229dc07d`) | 36 | 38 | 31 | 0 | 7 | 5 | +33 | 17 | 0 | 3 dropped (HK, SG, Worldwide); 2 rows not admissible as read | No (technical_blocked) |
| `e28f7bf8` | Flinders University (`0a42da16`) | 12 | 4 | 1 | 0 | 3 | 11 | -7 | 0 | 0 | 4 dropped (quote not on page) | No (technical_blocked) |
| `4749cc27` | University of Otago (`ab12c7f8`) | 1 | 0 | 0 | 0 | 0 | 1 | -1 | 0 | 0 | no row; 1 dropped (unknown qualification) | No (technical_blocked) |
| `78bde88f` | Australian National University (`e47a940d`) | 0 | 0 | 0 | 0 | 0 | 0 | +0 | 0 | 0 | no row; 16 IB rows dropped (quote too short); its 15 proposed rows sit outside this read | No (technical_blocked) |
| **Total** | 12 providers | **643** | **1,269** | **449** | **7** | **813** | **187** | **+1,082** | **541** | **50** | | **0 of 13** |

**What this means for Layer 4.** None of the 13 can be bulk-approved now. The platform classifies every one as `technical_blocked`, class `matrix_held`, route `matrix_source` (`security.aer_route_v1`), because each read dropped published rows that no admitted row covers. The review packet recommends "Do not approve: technical recovery", and Approve is refused ("nothing would change"). The remedy is a corrected re-read from the stored copy ($0, tier 1) by the reader owners: S1-AER-Claude for AU, S3-AER-ChatGPT for NZ. A person then decides on the re-read. Closest to safe once re-read: Auckland (`04a4ad2a`: 124 added, 0 superseded, 0 value failures; leave out the 4 blank-level and 32 unlinked rows) and Waikato (`c0c90fdb`: 40 added, 0 superseded; 18 value failures to leave out). Destructive on approval: Flinders (`e28f7bf8`, 11 superseded for 4), Otago (`4749cc27`, its 1 active row superseded for none), ACU (`c2160eb7`, 44 superseded) and Lincoln (`23367623`, all 58 replaced by re-keyed rows). The 1,284 figure includes ANU's 15 proposed rows that sit outside its change read; the 13 reads hold 1,269. Blank-level rows, the value-not-in-quote rows and host_shared RMIT Pathways stay gated; `change_of_admitted_table` stays human-gated in code.

**Reusable, non-inferential fix found (routed, not shipped here):** six dropped labels are printed country names the country mapping does not hold. Hong Kong (China) and HK → HK; Taiwan(China) → TW; SG → SG; Macedonia → MK (former name); and the printed misspellings Bangaldesh → BD and Phillipines → PH. These are spelling and naming aliases, not equivalence. Worldwide, WW, regions and qualifications named with no country stay unmapped. The aliases help only a re-read, so they go to the country-mapping owner and the reader owners with the re-reads. **Wording defect (for the owner of `security.aer_review_packet_v1`):** for every route other than review or matrix_except, the packet's refusal text names "the completeness gate (D-R3)", even when the gate is not applicable and the real cause is dropped rows.

**M3 mirror:** S1-Build writes the Google Sheet; the figures above are the verified live counts to sync.

**Reader contract gaps found (for the F-AER handover contract):** every proposed row must carry `course_id` or a `level_label` that is a course level (not an applicant qualification), and a named country or recognised qualification. Rows without them cannot be admitted by any rule and are not weakened.

## S2-AER wave 1 (s1093 cohort) — 25 November 2026 00:20 AEDT, in flight

Cohort: the 16 sources whose runs failed before s1085 with "no deterministic reader proved this table, and the entry_matrices route has no qualified model", read again by s1093 (Pilot #1585, migration `20261126001000`) plus Otago Polytechnic and Waikato Institute of Technology, which share the cohort's runs. Steps 1–2 (source discovery, stored evidence) were already held by the territorial lanes; this lane did not re-acquire. State read 00:15 AEDT: 6 done, 10 leased, 8 queued, 1 failed. Admission by the existing machine and partial rules follows on its 15-minute cycle; **no canonical gain is claimed yet.** Active matrix rows at the read: AU 6,706, NZ 540, CA 17; proposed 2,500.

| Provider (country, ID prefix) | Active courses | Active matrix rows before | Run result | Proposed after | Layer 4 hold | Next action |
|---|---|---|---|---|---|---|
| Otago Polytechnic (NZ, `cd27693c`) | 182 | 0 | done, 112 rows, 12 dropped, $0.1104 | 112 | `earlier_rejection`: a person rejected an earlier read | Person decides in Layer 4 |
| Waikato Institute of Technology (NZ, `742eef0a`) | 144 | 36 | done, 193 rows, 4 dropped, $0.0681 | 193 | `change_of_admitted_table` | Person decides |
| Victoria University (AU, `0f5373c8`) | 35 | 0 | done, 5 rows, $0.0016 | 5 | none yet | Machine check on next cycle; identity rule `host_shared` applies |
| Quality College of Australia (AU, `2f724366`) | 10 | 0 | done, 1 row, $0.0002 | 1 | none yet | Machine check on next cycle |
| Victoria University of Wellington (NZ, `34616965`) | 273 | 0 | done, 0 rows, $0.0047 | 0 | earlier `applicability_unresolved` | Reader owner (S3) |
| AUSTRA College (AU, `627b6f76`) | 28 | 0 | done, 0 rows, 1 dropped | 0 | none | Reader owner (S1) |
| Macquarie University (AU, `188103a5`) | 380 | 49 | failed, 107 proposed rows from an earlier read | 107 | none | Inspect the failure on the next pass |
| In flight (leased or queued): Canterbury (NZ `db910e88`), Alberta (CA `db436563`, two sources), Simon Fraser (CA `d47b6006`, two sources), Conestoga (CA `7b35d38d`), Salford College (AU `cda51a7c`), Open Polytechnic (NZ `f6b3e3a9`), Whitecliffe (NZ `29fabe13`), Victoria (CA `98e591df`), Manitoba (CA `cffa9cab`), UBC (CA `175462f3`), NZ School of ... (NZ `fe2e938f`), College of the North Atlantic (CA `4812a855`), Sheridan (CA `cc24d184`), Durham (CA `c79c40ee`), Lethbridge (CA `b509ab5c`), Calgary (CA `ad7bb2f7`) | see master plan | 0 | pending | n/a | n/a | Read outcomes after the worker drains, then group by result |

Spend this wave so far (from the run rows): about $0.19 in lean-model calls (Mistral Small 3.2), no Firecrawl. Not claimed: any admission, newly covered course, or consumer read-back.



## AER named acquisition wave 1 — 25 November 2026

Platform Admin: finite Steps 1–2 only; 100 distinct providers selected from the existing country-wise reader register, excluding recorded active claims and the existing AU wave register; live checked active courses, no matrix source, no active matrix and no queued/leased/running matrix run at selection. Recheck immediately before action; claims may change, so this is a coordination assignment, not a production lease. No substitution without orchestrator reconciliation. Existing production pipelines continue. S1-Build canonical writer; orchestrator updates existing Sheet after outcomes.

| Chat | Batch | Country | Provider | Provider ID | Active courses | Initial status |
|---|---:|---|---|---|---:|---|
| S1-AER-Claude | 1 | AU | La Trobe University | 4f86e09a-557c-4544-a0a3-3eb5dc8468a9 | 248 | Assigned, not acquired |
| S1-AER-Claude | 1 | AU | Collarts | 53eaf404-8f22-46ff-a208-b0e82da4284e | 139 | Assigned, not acquired |
| S1-AER-Claude | 1 | AU | Le Cordon Bleu Australia Pty Limited | 2968fe36-b879-4b53-8318-664ed56d291a | 69 | Assigned, not acquired |
| S1-AER-Claude | 1 | AU | Australian Pacific College, Southern Cross High School, English Unlimited Sydney, English Unlimited Melbourne | 658d593d-cd4a-4940-9927-0d471776284e | 63 | Assigned, not acquired |
| S1-AER-Claude | 1 | AU | Australia Institute of Business and Technology | eb9e3903-6d92-4502-a2b3-51cb231b21fc | 56 | Assigned, not acquired |
| S1-AER-Claude | 1 | AU | Excelsia University College | c537423d-028a-4b06-b135-003f2c6c393d | 51 | Assigned, not acquired |
| S1-AER-Claude | 1 | AU | Holmesglen, Holmesglen Institute | 4b0e9d62-2ad7-4467-911c-1571e30a74d6 | 44 | Assigned, not acquired |
| S1-AER-Claude | 1 | AU | George Brown College | 80e8f5fd-1b38-4292-90ab-adafc9884381 | 44 | Assigned, not acquired |
| S1-AER-Claude | 1 | AU | Greenwich English College, Greenwich Management College | 21e1cb6d-9c85-431f-b354-43b7370e5f40 | 42 | Assigned, not acquired |
| S1-AER-Claude | 1 | AU | Box Hill Institute | 104f3038-862c-445d-aaf3-b8727ff756f3 | 37 | Assigned, not acquired |
| S1-AER-Claude | 1 | AU | William Angliss Institute | 5c234f7f-a84c-46ae-b2ef-bfa75b59badd | 37 | Assigned, not acquired |
| S1-AER-Claude | 1 | AU | Reach Community College Pty Ltd | 8495927d-cbd8-426d-814c-fa87d1a966e7 | 37 | Assigned, not acquired |
| S1-AER-Claude | 1 | AU | York Business Institute Pty. Ltd. | 9aa61e05-ec5e-4468-8d2e-c3c6fb984f37 | 36 | Assigned, not acquired |
| S1-AER-Claude | 1 | AU | Aventia Institute Pty Ltd | c33ab783-ac3e-43a6-b00d-ce9ac4356ec5 | 36 | Assigned, not acquired |
| S1-AER-Claude | 1 | AU | AAPoly, AMI Education | f0c0f1dc-e628-4bb7-9943-727f32b26d50 | 36 | Assigned, not acquired |
| S1-AER-Claude | 2 | AU | Gold Coast Learning Centre | f2ec4927-522c-42a7-8de4-33ada6684595 | 36 | Assigned, not acquired |
| S1-AER-Claude | 2 | AU | Lead College Pty Ltd | 4b41907a-5f10-4aaf-863d-ec5f5cec37a8 | 34 | Assigned, not acquired |
| S1-AER-Claude | 2 | AU | Melbourne College of Hair and Beauty; Melbourne College of Training & Assessment | 566d1775-00c8-49da-8029-8d8a1291fe48 | 32 | Assigned, not acquired |
| S1-AER-Claude | 2 | AU | The Canberra Training School Pty Ltd, Canberra Business and Technology College | 9aed1f1c-6281-494f-a141-d8ebd4572b85 | 32 | Assigned, not acquired |
| S1-AER-Claude | 2 | AU | Australian Vocational Training Academy Pty Ltd | e2b73078-8636-459c-8d19-9129122fb301 | 32 | Assigned, not acquired |
| S1-AER-Claude | 2 | AU | TasTAFE | f16868c3-5487-487f-92cd-88e63116765c | 32 | Assigned, not acquired |
| S1-AER-Claude | 2 | AU | AUSTRALIAN HEALTH AND MANAGEMENT INSTITUTE PTY LTD | 1df6d6f3-f957-46c1-8611-9047a84b1e61 | 31 | Assigned, not acquired |
| S1-AER-Claude | 2 | AU | Educare College | 28ffde14-bf9d-404e-bbe7-fd97bdf56bb1 | 30 | Assigned, not acquired |
| S1-AER-Claude | 2 | AU | Macallan College Pty Ltd | 87e9331c-a879-483c-8df7-337a2be7731d | 30 | Assigned, not acquired |
| S1-AER-Claude | 2 | AU | Acquire Training Solutions Pty Ltd, Laneway International College | f71e9851-e4eb-4855-9931-eb42a4daef8d | 30 | Assigned, not acquired |
| S1-AER-Claude | 2 | AU | Apex Australia Vocational Education | 4bd30aeb-ffe4-4c0d-9794-db5ff7513628 | 29 | Assigned, not acquired |
| S1-AER-Claude | 2 | AU | Education Training & Employment Australia | 92355fb2-bf7a-42ed-81a4-598b5953145a | 29 | Assigned, not acquired |
| S1-AER-Claude | 2 | AU | Signet Institute of Australia | fe18f1f7-a15a-4328-a5db-fd67af56ca6c | 29 | Assigned, not acquired |
| S1-AER-Claude | 2 | AU | Australian Sovereign College | 496cda02-c474-41f7-9358-3cf435164dc7 | 28 | Assigned, not acquired |
| S1-AER-Claude | 2 | AU | Supreme Business College Pty Ltd | 71362bf9-2a99-4eb1-a76f-b5382dab9130 | 28 | Assigned, not acquired |
| S1-AER-Claude | 3 | AU | Business College Online, Dragon College of Business, Australian City International College,Australian Vocational Institute, Sydney City English College | 7304f7c0-3097-49a6-a1e2-37b46e4e75ce | 28 | Assigned, not acquired |
| S1-AER-Claude | 3 | AU | Institute Of Science Management And Technology | 89addf70-055c-4895-8e54-df7b9ffae4d6 | 28 | Assigned, not acquired |
| S1-AER-Claude | 3 | AU | Britts College Pty Ltd | 93aaad55-812a-482c-ad1e-7df0ac0a5a76 | 28 | Assigned, not acquired |
| S1-AER-Claude | 3 | AU | Australian Institute of Language and Further Education | 9b833af0-5ac9-4764-9266-318e81641f1c | 28 | Assigned, not acquired |
| S1-AER-Claude | 3 | AU | NATIONAL POLYTECHNIC OF AUSTRALIA PTY LTD | 9e69f830-39aa-4d64-a55d-1ccb12d420b6 | 28 | Assigned, not acquired |
| S1-AER-Claude | 3 | AU | The Sydney Business & Travel Academy,  Sydney English Language Academy | e3e541d8-c2f4-4923-a54a-024ee209276e | 28 | Assigned, not acquired |
| S1-AER-Claude | 3 | AU | Trinity Institute (Australia) | b93a1c45-c912-4711-a381-df226f3db646 | 27 | Assigned, not acquired |
| S1-AER-Claude | 3 | AU | Keystone College of Business and Technology | c188e2fc-deb4-45a4-a593-6c4560890bcb | 27 | Assigned, not acquired |
| S1-AER-Claude | 3 | AU | Cairns College of English & Business | 26eabe05-21e4-4257-9bd2-6c0cf161b23d | 26 | Assigned, not acquired |
| S1-AER-Claude | 3 | AU | Invicta Technical College | 2ca823cc-8641-4828-926a-e0627055582b | 26 | Assigned, not acquired |
| S2-AER | 1 | AU | Brisbane College of Australia ; Brisbane College of English | 8cc6fece-de98-424d-8033-0fdd92cdee00 | 26 | Assigned, not acquired |
| S2-AER | 1 | AU | Australian College of Studies Co. | 981b9811-9f4e-4825-b7af-cc47b5ebf6f5 | 26 | Assigned, not acquired |
| S2-AER | 1 | AU | TrEd College | bba5dcf0-c9dc-4fa3-bd00-bc0638c78c22 | 26 | Assigned, not acquired |
| S2-AER | 1 | AU | West Australian Institute of Further Studies | bd32bbd0-d59f-4201-bb23-8eadd2a4afb7 | 26 | Assigned, not acquired |
| S2-AER | 1 | AU | Cass Training International College | 0cca4a32-4649-4d79-bb46-49cfecf161b9 | 25 | Assigned, not acquired |
| S2-AER | 1 | AU | WIN English Centre /  WIN College | 36db369a-8c74-440f-b561-455262867050 | 25 | Assigned, not acquired |
| S2-AER | 1 | AU | Southern Cross Education Institute, North Melbourne Grammar College | 5d21e4d4-73b4-4ad6-b100-199264540e72 | 25 | Assigned, not acquired |
| S2-AER | 1 | AU | Envirotech Education | 6c79c82b-5cde-49b7-9998-13af66d28b47 | 25 | Assigned, not acquired |
| S2-AER | 1 | AU | Abbey College Australia, Abbey Training | 8e7141b4-d366-4860-819e-86c54586dc12 | 25 | Assigned, not acquired |
| S2-AER | 1 | AU | Entrepreneur Education | ad99fbcf-e690-499b-bbae-bc81ef892fc8 | 25 | Assigned, not acquired |
| S2-AER | 1 | AU | Australian College of Technology | e6396c9e-c655-47b5-b2a1-820f48910206 | 25 | Assigned, not acquired |
| S2-AER | 1 | AU | Nortwest Pty Ltd | 15e47a21-94a7-4984-aca8-cbbbecbfaab6 | 24 | Assigned, not acquired |
| S2-AER | 1 | AU | ILSC - Australia; ILSC - Brisbane; ILSC - Sydney; ILSC Perth; ILSC Adelaide; ILSC Melbourne; Greystone College | 5d0e3147-4dcb-4152-8f21-6a2a5ce51bc6 | 24 | Assigned, not acquired |
| S2-AER | 1 | AU | Australian International College of Skills & Education Pty Ltd | 70b6688c-2ca3-49cd-8eb8-9f35297d6c35 | 24 | Assigned, not acquired |
| S2-AER | 1 | AU | Auscanus Institute of Australia | 98f6df2b-f06c-4963-8aa1-7375e4b367d4 | 24 | Assigned, not acquired |
| S2-AER | 2 | AU | The Centre of Excellence | f7281274-2d50-49d2-98db-a68d3467a86b | 24 | Assigned, not acquired |
| S2-AER | 2 | AU | Pivot Education Pty Ltd | 03f447ae-f200-44f1-b58a-6581c00b9743 | 23 | Assigned, not acquired |
| S2-AER | 2 | AU | INTERNATIONAL INSTITUTE OF EDUCATION | 1241fe08-1fff-45c7-9c76-2857ec5a53dc | 23 | Assigned, not acquired |
| S2-AER | 2 | AU | Lexis TESOL Training Centres | 159328df-fb4b-4bb8-a6b8-5f24546437a3 | 23 | Assigned, not acquired |
| S2-AER | 2 | AU | Albright Institute of Business and Language; Albright Institute of English | 4790a6ab-7e93-42d6-b0ac-757d68040f7d | 23 | Assigned, not acquired |
| S2-AER | 2 | AU | Alliance College | 9edc07c5-fc46-407e-8432-6ac240f34da8 | 23 | Assigned, not acquired |
| S2-AER | 2 | AU | Canterbury Technical Institute Pty Ltd | 28828d80-3ce9-47af-b2b2-b9b08ee5d514 | 22 | Assigned, not acquired |
| S2-AER | 2 | AU | Aboard Training Australia | 449f1b2d-5f7f-4ef3-9fe1-a89c2f8bbe49 | 22 | Assigned, not acquired |
| S2-AER | 2 | AU | Protea College | 823d398f-5e99-47c9-96a8-eff642853fa8 | 22 | Assigned, not acquired |
| S2-AER | 2 | AU | Glen Institute | a7499e11-54b6-4edf-a301-390b0d4f39ad | 22 | Assigned, not acquired |
| S2-AER | 2 | AU | English in Paradise; ELSTON EDUCATION & TRAINING | ae1a5efb-620e-4690-849b-155ff6390d3b | 22 | Assigned, not acquired |
| S2-AER | 2 | AU | Queensland Academy of Technology | aead951c-991f-4bd6-b969-ac047a083276 | 22 | Assigned, not acquired |
| S2-AER | 2 | AU | Helix College Pty Ltd | bb0e5aed-a647-48f0-b625-80038c3a2cdf | 22 | Assigned, not acquired |
| S2-AER | 2 | AU | Rockford College | d446e6a4-14a8-4e15-8646-5b8e2906adf3 | 22 | Assigned, not acquired |
| S2-AER | 2 | AU | Fusion College of Technology Pty Ltd | ef15a84d-4edf-4d20-9eef-3cee7b315f10 | 22 | Assigned, not acquired |
| S3-AER-ChatGPT | 1 | NZ | NZIST Work-Based Learning (Competenz, Connexis, Careerforce, ServiceIQ, Primary ITO, EarnLearn) | 1b8f2f2f-d3d2-455e-a9fd-5a65744352ec | 229 | Assigned, not acquired |
| S3-AER-ChatGPT | 1 | NZ | Eastern Institute of Technology | ea5a3fa6-31f4-4553-9cfd-6bff49c36a6b | 189 | Assigned, not acquired |
| S3-AER-ChatGPT | 1 | NZ | Toi Ohomai Institute of Technology | 38f8ea71-2269-407c-aab6-68a5f09fc01a | 157 | Assigned, not acquired |
| S3-AER-ChatGPT | 1 | NZ | NorthTec | d72e0120-a3a2-4909-8ddf-bcad1ec60150 | 122 | Assigned, not acquired |
| S3-AER-ChatGPT | 1 | NZ | Te Wānanga o Aotearoa | ea0f4e14-e790-4c62-886f-3ec5bc040b4a | 86 | Assigned, not acquired |
| S3-AER-ChatGPT | 1 | NZ | New Zealand Institute of Skills and Technology (NZIST) | 27349414-019b-4c0b-a38d-db92aaaf5e68 | 72 | Assigned, not acquired |
| S3-AER-ChatGPT | 1 | NZ | Skills Group Training Limited | 014118a6-54ea-4f36-ba05-a363b73b7979 | 63 | Assigned, not acquired |
| S3-AER-ChatGPT | 1 | NZ | Te Whare Wānanga o Awanuiārangi | 5c067273-5f41-4da0-a16c-b2eac17f4306 | 52 | Assigned, not acquired |
| S3-AER-ChatGPT | 1 | NZ | Tai Poutini Polytechnic | faa04942-5af1-418c-8214-c5aa2523c39d | 42 | Assigned, not acquired |
| S3-AER-ChatGPT | 1 | NZ | Skills Active Te Mahi Ako Limited | 0ede4eef-4117-4362-8a64-131efcb31c38 | 41 | Assigned, not acquired |
| S3-AER-ChatGPT | 1 | NZ | Skills Update Limited | 3f48840c-8038-42a0-805e-8f7974301b23 | 33 | Assigned, not acquired |
| S3-AER-ChatGPT | 1 | NZ | BCITO Limited | 7bf176e6-4c08-4068-a837-d991c5be8f22 | 33 | Assigned, not acquired |
| S3-AER-ChatGPT | 1 | NZ | Te Rūnanga-o-Tūranganui-a-Kiwa | 2a97c91d-9340-49fa-a437-6c76ea01edd9 | 32 | Assigned, not acquired |
| S3-AER-ChatGPT | 1 | CA | Canadore College | 425b1fad-a4ef-4a21-8590-c7fa9b671107 | 52 | Assigned, not acquired |
| S3-AER-ChatGPT | 1 | CA | College of the Rockies | d5a30625-74a1-43ff-83bb-81b2bf587cb2 | 41 | Assigned, not acquired |
| S3-AER-ChatGPT | 2 | CA | British Columbia Institute of Technology | 60b274ad-14cf-4343-9e1a-9779fd5466b1 | 30 | Assigned, not acquired |
| S3-AER-ChatGPT | 2 | CA | Burman University | 9e46baf2-694b-4d79-889e-b956d144c930 | 27 | Assigned, not acquired |
| S3-AER-ChatGPT | 2 | CA | Selkirk College | 6cc65e88-af6c-4fa9-b4a8-512d37b01d4f | 14 | Assigned, not acquired |
| S3-AER-ChatGPT | 2 | CA | Emily Carr University of Art and Design | 8bcdcee6-a7cb-4731-83cc-4f116e423914 | 12 | Assigned, not acquired |
| S3-AER-ChatGPT | 2 | CA | Aurora College | 69ac4368-98a0-4471-b265-d1e16fcb1ed0 | 11 | Assigned, not acquired |
| S3-AER-ChatGPT | 2 | CA | Vancouver Community College | 5a2a154f-1e11-4851-aa96-0a172ba5314d | 9 | Assigned, not acquired |
| S3-AER-ChatGPT | 2 | CA | Alberta University of the Arts | ea8e3df4-564a-4b12-907d-c8af9d38865e | 5 | Assigned, not acquired |
| S3-AER-ChatGPT | 2 | CA | Northwestern Polytechnic | 21818449-895c-45eb-82a6-b91bee0cece0 | 4 | Assigned, not acquired |
| S3-AER-ChatGPT | 2 | CA | North Island College | 1386ffc1-e991-463c-bb22-39380cca67a1 | 3 | Assigned, not acquired |
| S3-AER-ChatGPT | 2 | CA | Mohawk College | 0af6c3f4-752e-42e3-b818-74c2eaf31671 | 2 | Assigned, not acquired |
| S3-AER-ChatGPT | 2 | CA | Justice Institute of British Columbia | b0f95837-8e85-4936-8166-b40b48e1044f | 2 | Assigned, not acquired |
| S3-AER-ChatGPT | 2 | CA | Yukon University | ca2dacb0-297a-4067-a899-59eb7b381ae6 | 2 | Assigned, not acquired |
| S3-AER-ChatGPT | 2 | CA | Coast Mountain College | 3a48beb7-d61f-468c-b93c-6fa61ab96921 | 1 | Assigned, not acquired |
| S3-AER-ChatGPT | 2 | CA | Olds College | a29ecd44-67c5-4839-820e-3a5778dbc1df | 1 | Assigned, not acquired |
| S3-AER-ChatGPT | 2 | CA | College of New Caledonia | e7af5ef9-f719-4b94-b6b5-abf88071b9ce | 1 | Assigned, not acquired |

Completion: one outcome per named ID with official URL, source ID, evidence ID, hash, stored artifact, type, scope/edition, acquisition method, credits/USD, exact blocker/next action. No new tracking file or queue.


## S2-AER AU wave 1 — Steps 1–2 for 30 named providers (Admin #1049) — 25 November 2026

Method: existing platform state read live (rolled back): `pipeline.coverage_course_pages`, `pipeline.evidence_artifacts`, `pipeline.provider_central_search` and `pipeline.aer_source_discover_requests`; four public site searches (Brisbane College, Southern Cross, ILSC, The Centre of Excellence). No Firecrawl, no AI, no extraction, no admission work, and no source registered (registering a source makes the existing entry-matrix-read job fetch and then read it, which is Step 3). Expenditure by this lane: $0. The shell host list refuses provider sites, so no new page was fetched directly.

**Result.** 26 of 30 providers already hold stored evidence of official course pages (the sample below is the most recently read one per provider; each provider has 12 to 25 evidence artifacts and 3 to 26 bound course pages). The platform's central search found no by-country, qualification-equivalency or admission-guide page for any of the 30; its outcome for 25 is `course_pages_found`, for 3 `no_entry_page` and for 3 `refused`. For these small VET and English providers the entry requirements sit on each course page. Four providers have no stored source (Brisbane College, Southern Cross Education Institute, ILSC, The Centre of Excellence).

**Ambiguous names, resolved by exact match:** Australian College of Technology = `e6396c9e` (academies.edu.au; the separate `0e63f975` is Australian College of Technology and Business, not in this wave); ILSC Australia / Greystone College = `5d0e3147` (the Greystone record `2723853b` has 1 course); Lexis TESOL Training Centres = `159328df` (five Lexis English school records are separate); English in Paradise / Elston = `ae1a5efb`.

| # | Provider | Provider ID | Source URL (sample official page) | Source type | Evidence ID | Storage path | SHA-256 | Method | Spend | Steps 1–2 | Blockers |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Brisbane College of Australia | `8cc6fece-de98-424d-8033-0fdd92cdee00` | none stored | n/a | none | none | none | none this lane | $0 | Not done | Discovery found no entry page. Site search (this lane) shows official course pages with per-course entry requirements (for example `https://bc.edu.au/Courses/Business-`, `https://bc.edu.au/Veterinary-Nursing`: IELTS 6.0 or equivalent plus high school certificate); the 6 bound pages were never read. Next: the existing coverage reader reads them; no by-country page exists |
| 2 | Australian College of Studies | `981b9811-9f4e-4825-b7af-cc47b5ebf6f5` | https://www.acos.edu.au/course/diploma-of-early-childhood-education-and-care/ | official course page (entry requirements per course) | `4944295a-7006-42fd-a42a-1a259e01fbd6` | `layer2/AU/coverage/981b9811-9f4e-4825-b7af-cc47b5ebf6f5/af5fed32-d3bc-46ef-b428-4693386a2130/513c5a12c80833859aeb02e9511a638a06c5b08a690beaa57317b39cb2414407.html.gz` | `513c5a12c80833859aeb02e9511a638a06c5b08a690beaa57317b39cb2414407` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 3 | TrEd College | `bba5dcf0-c9dc-4fa3-bd00-bc0638c78c22` | https://www.tredcollege.edu.au/courses/general-english | official course page (entry requirements per course) | `a419c538-aa9f-4f73-9ff0-88f952bf060e` | `layer2/AU/coverage/bba5dcf0-c9dc-4fa3-bd00-bc0638c78c22/297907f5-6c4c-440f-b10c-1e78d0146e53/cac4b2454774c48e9f0589f3512222305e10988d98107552c1612725891a9a7e.html.gz` | `cac4b2454774c48e9f0589f3512222305e10988d98107552c1612725891a9a7e` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 4 | West Australian Institute of Further Studies | `bd32bbd0-d59f-4201-bb23-8eadd2a4afb7` | https://waifs.wa.edu.au/course/chc52025-diploma-of-community-services/ | official course page (entry requirements per course) | `adfa14e3-0c28-4f3a-9757-847870a949dd` | `layer2/AU/coverage/bd32bbd0-d59f-4201-bb23-8eadd2a4afb7/488bdec1-110a-4918-9269-5839ad2473c1/88a37a5572181b9c198cc630f43095ecc81235fa4b1d2e1ce3245071d2395077.html.gz` | `88a37a5572181b9c198cc630f43095ecc81235fa4b1d2e1ce3245071d2395077` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 5 | Cass Training International College | `0cca4a32-4649-4d79-bb46-49cfecf161b9` | https://ctic.com.au/fns60217-advanced-diploma-of-accounting/ | official course page (entry requirements per course) | `b8a04d25-c457-4805-8380-4f0285922cf4` | `layer2/AU/coverage/0cca4a32-4649-4d79-bb46-49cfecf161b9/3d3b22f2-ec5f-40cb-be43-076f13378d0d/93dd6bd1dc0a3050549e42cdc995a5a20719079145dff3f0c1b8c20f9f08e990.html.gz` | `93dd6bd1dc0a3050549e42cdc995a5a20719079145dff3f0c1b8c20f9f08e990` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 5a | WIN College (record: WIN English Centre / WIN College) | `36db369a-8c74-440f-b561-455262867050` | https://wincollege.edu.au/courses/english-courses/general-english-courses/ | official course page (entry requirements per course) | `523dbb35-cc7a-4e27-9386-1e032c677189` | `layer2/AU/coverage/36db369a-8c74-440f-b561-455262867050/7db4e80f-fb45-497a-a530-8e0f77137f81/572ec74bb5a9c56ffa358a1b85e7bf6622d0002ca417c58b57d2f29bc3455839.html.gz` | `572ec74bb5a9c56ffa358a1b85e7bf6622d0002ca417c58b57d2f29bc3455839` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); 21 evidence artifacts, 20 bound course pages read; requirements are per course page |
| 6 | Southern Cross Education Institute | `5d21e4d4-73b4-4ad6-b100-199264540e72` | none stored | n/a | none | none | none | none this lane | $0 | Not done | Two provider records for the name: `5d21e4d4` (scei.com.au, 25 courses, used here) and `94089ade` (scei-he.edu.au, 9 courses). Discovery outcomes no_entry_page and refused; site search of scei.com.au returned nothing. Needs a browser or a person to find the page |
| 7 | Envirotech Education | `6c79c82b-5cde-49b7-9998-13af66d28b47` | https://www.envirotech.edu.au/international-certificate-iv-in-marine | official course page (entry requirements per course) | `b39c7722-629b-483e-b9e8-bc0641070121` | `layer2/AU/coverage/6c79c82b-5cde-49b7-9998-13af66d28b47/aa82d753-d31d-45e7-a3fe-3b6cb32e96d3/30373fe7c8649a4191099a23b5fb7f7fa48c12236fe3193ad5c751480cfb8dbc.html.gz` | `30373fe7c8649a4191099a23b5fb7f7fa48c12236fe3193ad5c751480cfb8dbc` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 8 | Abbey College Australia | `8e7141b4-d366-4860-819e-86c54586dc12` | https://abbeycollege.edu.au/diploma-of-community-services/ | official course page (entry requirements per course) | `8547af8a-cc3b-4b6b-8faa-d20e8375aa5f` | `layer2/AU/coverage/8e7141b4-d366-4860-819e-86c54586dc12/713628e5-cae7-4e60-b8b9-d2d42e122e04/c53ac1522457079596c64a4b2fb3b13329fcdcb9defbd3e84d9a93b7d72a585e.html.gz` | `c53ac1522457079596c64a4b2fb3b13329fcdcb9defbd3e84d9a93b7d72a585e` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 9 | Entrepreneur Education | `ad99fbcf-e690-499b-bbae-bc81ef892fc8` | https://www.entrepreneur.edu.au/faculties/faculty-of-design/cua60320_advanced_diploma_of_graphic_design/ | official course page (entry requirements per course) | `60b135ce-3526-4d24-8481-6bb41a893256` | `layer2/AU/coverage/ad99fbcf-e690-499b-bbae-bc81ef892fc8/f8dfe8a5-b413-4669-85c4-a0a559c4b585/b839062e8d5bc5eed51f2de40544ce3bc95b45efb710fd585f672e079d283e2f.html.gz` | `b839062e8d5bc5eed51f2de40544ce3bc95b45efb710fd585f672e079d283e2f` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 10 | Australian College of Technology | `e6396c9e-c655-47b5-b2a1-820f48910206` | https://academies.edu.au/courses-syd-travel-tourism/ | official course page (entry requirements per course) | `a8f68a1c-326e-40da-bea6-efdaf42b5633` | `layer2/AU/coverage/e6396c9e-c655-47b5-b2a1-820f48910206/e9ffe2a2-6864-48c3-9d90-a4c9acc16f67/6d4e8ceb7fd3991060007917132ad5bccc27ba89013fccf162cf375b9c318c2a.html.gz` | `6d4e8ceb7fd3991060007917132ad5bccc27ba89013fccf162cf375b9c318c2a` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 11 | Nortwest Pty Ltd | `15e47a21-94a7-4984-aca8-cbbbecbfaab6` | https://nortwest.edu.au/Project_Management.aspx?page_name=Cookery%20%26%20Hospitality | official course page (entry requirements per course) | `c3d65616-c550-41ba-bd8a-8051146672a7` | `layer2/AU/coverage/15e47a21-94a7-4984-aca8-cbbbecbfaab6/c5283630-9414-4d71-bef1-4a660b80e567/6ba3f6955fe0570699c38a3526d4070fe12cbb185bb2ef83e4df69d1bd9ee3f0.html.gz` | `6ba3f6955fe0570699c38a3526d4070fe12cbb185bb2ef83e4df69d1bd9ee3f0` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 12 | ILSC Australia | `5d0e3147-4dcb-4152-8f21-6a2a5ce51bc6` | none stored | n/a | none | none | none | none this lane | $0 | Not done | Provider records: ILSC `5d0e3147` (used) and Greystone Institute `2723853b` (1 course, not part of this wave). Discovery outcomes no_entry_page and refused; site search returned only a general student-life page, no entry requirements |
| 13 | Australian International College of Skills & Education | `70b6688c-2ca3-49cd-8eb8-9f35297d6c35` | https://aicse.edu.au/certificate-iii-in-early-childhood-education-and-care/ | official course page (entry requirements per course) | `62a60eac-2e18-4e2f-ae68-560bc5b06772` | `layer2/AU/coverage/70b6688c-2ca3-49cd-8eb8-9f35297d6c35/1f6f1403-7100-440a-827f-371a5b6422c2/9aedab39f02ce73e47c242474d101ce484bb4ceb79063ad4a483ac2e4eadb89c.html.gz` | `9aedab39f02ce73e47c242474d101ce484bb4ceb79063ad4a483ac2e4eadb89c` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 14 | Auscanus Institute of Australia | `98f6df2b-f06c-4963-8aa1-7375e4b367d4` | https://auscanus.edu.au/courses/diploma-of-community-services/ | official course page (entry requirements per course) | `b6de04e3-dd6e-4910-ab27-017e1314cd0d` | `layer2/AU/coverage/98f6df2b-f06c-4963-8aa1-7375e4b367d4/51c38cb8-78fd-4545-ab42-429d06ea4150/6a0d47c5077ae7c42db123b4f16f11d8a4b402cccf3bbfeb24dd2ef913193785.html.gz` | `6a0d47c5077ae7c42db123b4f16f11d8a4b402cccf3bbfeb24dd2ef913193785` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 15 | The Centre of Excellence | `f7281274-2d50-49d2-98db-a68d3467a86b` | none stored | n/a | none | none | none | none this lane | $0 | Not done | 17 evidence artifacts exist for the provider but no course page is bound to a course, so none is shown as a source here. Discovery outcomes no_entry_page and refused; site search of coe.vic.edu.au returned nothing |
| 16 | Pivot Education | `03f447ae-f200-44f1-b58a-6581c00b9743` | https://pivoteducation.edu.au/courses/advanced-general-english/ | official course page (entry requirements per course) | `4bed1feb-9b60-41e2-9153-6a8a276aa0cf` | `layer2/AU/coverage/03f447ae-f200-44f1-b58a-6581c00b9743/548c4e00-0c10-4b5a-baee-ae0cec46d78a/a75389871ac844deb000d6bb4950c4a88fb46e5421b80bf1eb165483616e8da5.html.gz` | `a75389871ac844deb000d6bb4950c4a88fb46e5421b80bf1eb165483616e8da5` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 17 | International Institute of Education | `1241fe08-1fff-45c7-9c76-2857ec5a53dc` | https://elearning.iie.edu.au/course/index.php?categoryid=41 | official course page (entry requirements per course) | `c204913e-59a0-4974-95f1-e80f5716ebc0` | `layer2/AU/coverage/1241fe08-1fff-45c7-9c76-2857ec5a53dc/3e71534b-31ce-4995-97f0-e16746d03a93/14061b568177c1543efc52445407fb79736ab6a182b445418e20f0269c7c2685.html.gz` | `14061b568177c1543efc52445407fb79736ab6a182b445418e20f0269c7c2685` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 18 | Lexis TESOL Training Centres | `159328df-fb4b-4bb8-a6b8-5f24546437a3` | https://lexis-training.com/courses/certificate-iv-in-marketing-and-communication/ | official course page (entry requirements per course) | `7021c948-b495-4c86-ada9-bff64e439b73` | `layer2/AU/coverage/159328df-fb4b-4bb8-a6b8-5f24546437a3/db1b0890-a2e4-4e38-8a69-99f7368f642d/c7c7a888f10e9b50d141a2ce97d9691986299efef875e054f6e6b0d556271a85.html.gz` | `c7c7a888f10e9b50d141a2ce97d9691986299efef875e054f6e6b0d556271a85` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 19 | Albright Institute | `4790a6ab-7e93-42d6-b0ac-757d68040f7d` | https://albrightinstitute.edu.au/international-english-language-testing-system-ielts/ | official course page (entry requirements per course) | `eb59641f-50e6-4d2a-af20-161cb575bdc3` | `layer2/AU/coverage/4790a6ab-7e93-42d6-b0ac-757d68040f7d/1eb2b2d9-bbc0-4ed7-b757-05326a2f6524/c738771bb7964a79bac0d885876edff3ee0036aba4a5805778b7359bc9fbc159.html.gz` | `c738771bb7964a79bac0d885876edff3ee0036aba4a5805778b7359bc9fbc159` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 20 | Alliance College | `9edc07c5-fc46-407e-8432-6ac240f34da8` | https://alliancecollege.edu.au/alliance-courses/certificate-iii-in-carpentry/ | official course page (entry requirements per course) | `caf318fd-fe18-4068-a13e-b54bbb1562b8` | `layer2/AU/coverage/9edc07c5-fc46-407e-8432-6ac240f34da8/36b9391a-9591-4b23-a573-52cfbc85ac22/619e1473bd30e1b67d39b6d59b5ff60fdf404f5f8c71573689e480d67b21dc7f.html.gz` | `619e1473bd30e1b67d39b6d59b5ff60fdf404f5f8c71573689e480d67b21dc7f` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 21 | Canterbury Technical Institute | `28828d80-3ce9-47af-b2b2-b9b08ee5d514` | https://cti.qld.edu.au/courses/aged-care-community-services/diploma-of-community-services/ | official course page (entry requirements per course) | `5dbd7eac-37ef-4c67-9fd7-3b7e0c0bf274` | `layer2/AU/coverage/28828d80-3ce9-47af-b2b2-b9b08ee5d514/bbe9c7a7-96aa-4909-812d-4e59bfec11ff/1fbec06e8c9304cfc916b42f89b70473ee0e565c47b2f4eca578ca6376ed3f33.html.gz` | `1fbec06e8c9304cfc916b42f89b70473ee0e565c47b2f4eca578ca6376ed3f33` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 22 | Aboard Training Australia | `449f1b2d-5f7f-4ef3-9fe1-a89c2f8bbe49` | https://ataustralia.edu.au/iv-in-automotive-mechanical-diagnosis/ | official course page (entry requirements per course) | `70afe69e-0a8e-4736-98bc-9c7060adfed6` | `layer2/AU/coverage/449f1b2d-5f7f-4ef3-9fe1-a89c2f8bbe49/64117c87-88b5-4247-9f3e-444a6c950586/086467a0009719bf0dd17b3da47e33b888a7c3885a36cb3dac98733cd76dd8e3.html.gz` | `086467a0009719bf0dd17b3da47e33b888a7c3885a36cb3dac98733cd76dd8e3` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 23 | Protea College | `823d398f-5e99-47c9-96a8-eff642853fa8` | https://protea.edu.au/courses/cpc33020-certificate-iii-in-bricklaying-and-blocklaying-cricos-116242g/ | official course page (entry requirements per course) | `d2c8e636-a1b7-4427-84a5-109705a7a444` | `layer2/AU/coverage/823d398f-5e99-47c9-96a8-eff642853fa8/9f31f477-2eca-44c3-9392-740e2ac24b06/3b0982ff8f786ed0a345306e4c889892586e80714cbcf9f458b3e5c4590f40a9.html.gz` | `3b0982ff8f786ed0a345306e4c889892586e80714cbcf9f458b3e5c4590f40a9` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 24 | Glen Institute | `a7499e11-54b6-4edf-a301-390b0d4f39ad` | https://glen.edu.au/advanced-diploma-of-civil-construction-design/ | official course page (entry requirements per course) | `78948606-fbb4-4ac2-ba1d-dde6110ba34f` | `layer2/AU/coverage/a7499e11-54b6-4edf-a301-390b0d4f39ad/03d96d7b-9aa0-4722-a15a-947ba0d25a34/de3e3c79fe81718c621395932020a30dfc267f07a14d580c846a28505df4df34.html.gz` | `de3e3c79fe81718c621395932020a30dfc267f07a14d580c846a28505df4df34` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 25 | English in Paradise / Elston | `ae1a5efb-620e-4690-849b-155ff6390d3b` | https://eet.edu.au/cert-iv-design/ | official course page (entry requirements per course) | `63fd4ac5-d4e3-4574-9f1e-689d7d00c04f` | `layer2/AU/coverage/ae1a5efb-620e-4690-849b-155ff6390d3b/610bab1c-84b6-460e-be1c-f208dbc10987/0da0c040476e60628d4b99b48b6fea9303b1c465600e2abb6469baa1e25cdb8f.html.gz` | `0da0c040476e60628d4b99b48b6fea9303b1c465600e2abb6469baa1e25cdb8f` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 26 | Queensland Academy of Technology | `aead951c-991f-4bd6-b969-ac047a083276` | https://qat.qld.edu.au/international/business/bsb60420-international-advanced-diploma-in-leadership-and-management/ | official course page (entry requirements per course) | `f5474a44-dbda-4576-92dc-55c5efde3e4b` | `layer2/AU/coverage/aead951c-991f-4bd6-b969-ac047a083276/5d728783-125b-4c7b-8eb7-82fc54b51051/2075c7c5c764f78fc0c217e20a68d7a7c22a8b00e152b4b887ba6bb5bf0e0bd7.html.gz` | `2075c7c5c764f78fc0c217e20a68d7a7c22a8b00e152b4b887ba6bb5bf0e0bd7` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 27 | Helix College | `bb0e5aed-a647-48f0-b625-80038c3a2cdf` | https://helixcollege.edu.au/cpc30220-certificate-iii-in-carpentry/ | official course page (entry requirements per course) | `af1efad4-aeba-4a8c-a5f6-b98510210682` | `layer2/AU/coverage/bb0e5aed-a647-48f0-b625-80038c3a2cdf/a63d3c4b-0989-4e1f-8750-940674d78ddd/626004427e4d6d3ff7b38fb798c55df18f26f4e72e224e78acd3a16368ddf396.html.gz` | `626004427e4d6d3ff7b38fb798c55df18f26f4e72e224e78acd3a16368ddf396` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 28 | Rockford College | `d446e6a4-14a8-4e15-8646-5b8e2906adf3` | https://rockford.edu.au/course/chc52025-diploma-of-community-services/ | official course page (entry requirements per course) | `d07b5abe-6737-42a5-9348-d58785d2ec9a` | `layer2/AU/coverage/d446e6a4-14a8-4e15-8646-5b8e2906adf3/462975c1-44bb-4846-a983-da364985686c/81d11ad6bc97cce135c3f10c5715db116d9996d872b80170c46e171e03de48ef.html.gz` | `81d11ad6bc97cce135c3f10c5715db116d9996d872b80170c46e171e03de48ef` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |
| 29 | Fusion College of Technology | `ef15a84d-4edf-4d20-9eef-3cee7b315f10` | https://fusioncollege.edu.au/courses/cpc30326-certificate-iii-in-carpentry | official course page (entry requirements per course) | `b56c422c-bce2-4b25-b804-daafeb265012` | `layer2/AU/coverage/ef15a84d-4edf-4d20-9eef-3cee7b315f10/fa54fdff-72cf-4228-bfea-1f52b06da741/2d6336633757f9e8ae1c2c513ae4f839801d2518d631097cd9319ae4770bd3c7.html.gz` | `2d6336633757f9e8ae1c2c513ae4f839801d2518d631097cd9319ae4770bd3c7` | prior stored fetch (existing coverage reader, direct HTTP) | $0 this lane | Done for course-specific requirements; by-country source not found | The platform's central search found no by-country or equivalency page (outcome course_pages_found); requirements are per course page |

**Correction (25 Nov 07:50): the first table omitted WIN College; row 5a adds it. The 30 rows are 1–29 plus 5a.**

**Account:** 30 of 30 providers accounted for: 26 with stored course-page evidence and no by-country source found; 4 with no stored source (rows 1, 6, 12, 15). Steps 3–5 not started. Next executable action: the existing coverage reader reads Brisbane College's 6 bound pages; a person or browser session locates entry pages for Southern Cross Education Institute, ILSC and The Centre of Excellence; Firecrawl is only needed for pages that direct HTTP cannot read (Nortwest has 2 `blocked` pages, Queensland Academy of Technology 1 `needs_render`).


## Named Wave 1 — limited Steps 3–5 authorisation (25 November 2026)

Platform Admin authorises S2-AER and S3-AER to advance the same 60 provider IDs already recorded above under Admin #1049. S1-AER remains Steps 1–2. Independent live baseline: AU 26/30 providers with 478 successfully read bound course pages; NZ 8/13 with 254; CA 12/17 with 318. All 60 have zero registered matrix sources, zero active and proposed matrix rows at this check. Existing course-level admission/coverage baseline must be read separately before processing. Pilot #1597 remains draft/unmerged. Use existing course-level AER reader and authorised evidence, validate content before extraction, hold missing evidence and scope exceptions; do not wait on #1597 for independent evidence-backed work. No automatic next wave, scheduler, cap changes or direct canonical writes. Report each assigned ID with Steps 3–5 outputs, before/after canonical rows and distinct covered courses, genuine holds, usage and next action; verify consumer read-back and existing automated result-bearing cycles where available. Orchestrator updates existing AER Sheets after reporting.


## Named Wave 1 — S1-AER limited Steps 3–5 authorisation, 25 November 2026

Platform Admin authorises the same 40 S1-AER AU IDs under Admin #1049 to advance to Steps 3–5, extending #1054 to the full original 100-provider wave. Independent 07:00 AEDT: 24 registered sources at 16 providers; 22 with matching evidence metadata/hash/path at 15 providers; Greenwich two pending; 37 providers with 1,220 successfully read, course-bound pages. No usable read evidence at Melbourne College of Hair and Beauty, Signet and Invicta. Four Firecrawl credits logged (entry_fallback), exact dollar cost not verified. Matrix active 0, proposed 3 (La Trobe 2, AIBT 1). Existing course-level active rows and coverage must be separated from new admissions. Source content, applicability and actual storage bytes not independently inspected; lane's referenced 47-row CSV not visible to orchestrator; retain its detailed status entry and file promptly. AU_Universities AC–AI monitoring fields updated/verified all 40 IDs; preserve canonical generated fields. No new cohorts or schedules; process evidence-backed Steps 3–5 via existing paths, settle missing sources and genuine holds without bypass. Report provider-level before/after canonical rows, distinct covered courses, consumer evidence, expenditure and precise next action.



### S1-AER-Claude Wave 1 Steps 1–2 outcome (25 November 2026 07:30 AEDT)

25 Nov 2026 07:30 AEDT, S1-AER-Claude (s1107 live: Pilot #1598, migration 20261126061000; Admin #1049 / #1054; registered source writer not used, registration by reviewed Pilot migration as for s1100): **Wave 1 Steps 1–2 outcome for the 40 named AU IDs.** All 40 accounted for in `docs/platform/2026-11-25-s1-aer-wave1-au-1049-steps12-40-providers.csv` (47 rows: provider, ID, source URL, source ID, evidence ID, storage path, full SHA-256, method, spend, status, exceptions). (a) 24 official pages/PDFs registered for 16 providers; 22 durably stored with evidence ID, hash and path (La Trobe, Collarts, Le Cordon Bleu ×2, APC, AIBT ×2, Excelsia ×2, Holmesglen ×2, George Brown AU ×2, Box Hill ×2, William Angliss, Reach ×2, York, AAPoly, Gold Coast Learning Centre, TasTAFE); Greenwich two sources still `found` with no error (pending, not waited for). (b) 22 further providers (14, 17, 19, 20, 22–27, 29–40 less 28) hold existing course-bound stored pages; no new fetch; content not yet validated as academic entry. (c) Melbourne College of Hair and Beauty and Signet: no stored evidence anywhere; official course pages found on mcohb.com.au and signet.edu.au, not registered (attach needs the Platform Admin function; exact URLs are in the CSV). Invicta: sample page HTTP 404, 3 of 23 bound pages hold evidence. (d) English-only pages stored but not AER evidence: AAPoly, Holmesglen English page, George Brown English policy, TasTAFE. Firecrawl: 4 credits (La Trobe, Box Hill ×2, TasTAFE; entry_fallback), dollar cost not verified; AI $0 in Steps 1–2; no discovery repeated. George Brown AU = 80e8f5fd (not the Canadian record); AIBT = eb9e3903. Steps 3–5 follow under the 25 Nov authorisation; existing course-level AER is separate from any new admission.


## S2-AER AU wave 1 — Steps 3–5 for the 30 named providers (Admin #1054) — 25 November 2026

**Finding (measured live, rolled back).** The existing course-level pipeline had already read the stored pages. Of the 478 eligible courses across 26 providers, every course has an entry-requirements read: 292 filled, 159 skipped, 39 failed. Course-level requirements stay in `catalogue.course_entry_requirements` and are not forced into country matrices. The deterministic academic reader (`aer-det-v1.3`) found no reading on any of these VET and English pages (all 'no_reading'): their requirements are IELTS and a high school certificate, and the English requirement is a separate pipeline.

**Before (25 Nov 2026, 07:00 AEDT).** Active course-level rows 776; courses covered 292 of 478 eligible; Layer 4 `course_entry_first_read`: 292 approved, 39 superseded, 0 pending. Skipped reasons: page does not state it 59; no proven course page 34; Layer 4 superseded 39; earlier read waits in Layer 4 8; corrected read refused 7; no row met the admission rules 7; no quoted requirement 4; route off 1. Failed: held_partial (slice not read whole) 36; no answer recorded after 3 tries 3.

**Action (s1114, Pilot).** The 39 failed course reads are read again once through `security.course_entry_read_enqueue_v1` (stored page, no Firecrawl, model reader `course-entry-v1`); estimate about US$0.10 at US$0.00265 a course against a balance far above the floor. Output goes to Layer 4 or the unchanged machine rule. Nothing admitted by hand, G3 75/48 and manual locks asserted after, rolled-back rehearsal passed (md5 a7fd2971).

**Held, not retried:** 39 superseded AI reads (the completeness gate held them; the deterministic reader found nothing); 34 pages not proved to be the course's page (binding, not extraction); 7 corrected reads refused (D-R2). The four providers without stored evidence (Brisbane College, Southern Cross Education Institute, ILSC, The Centre of Excellence) keep their Steps 1–2 blockers. Outcome table follows after the reads finish.


### S1-AER-Claude Wave 1 Steps 3–5 outcome (25 November 2026 08:00 AEDT)

25 Nov 2026 08:00 AEDT, S1-AER-Claude (s1108, documents and live reads only; no Pilot change; Admin #1049 / #1054, 25 Nov authorisation): **Wave 1 Steps 3–5 outcome for the 40 named AU IDs** (per-provider file `docs/platform/2026-11-25-s1-aer-wave1-au-1049-steps3-5-40-providers.csv`). The existing governed pipeline ran unattended on the sources registered in s1107; this lane changed no reader, rule, setting, schedule or canonical row. **New canonical admissions: 9 matrix rows at 3 providers** (La Trobe 2, 07:03 AEDT; William Angliss 4, partial; Gold Coast Learning Centre 3 of 8, 5 excluded by approve-except), each traced from the registered source to run, machine admission and `catalogue.provider_entry_matrix`. Provider-matrix rows before 0, after 9. La Trobe: 200 of 248 courses now resolve through the provider table (48 were already course-level); `website_v3_course(<La Trobe undergraduate course>, 'AU')` returns the new row (v3 not yet live on the website; frozen v2 untouched). **Course-level active rows are unchanged for all 40 providers** (existing 1,564 active course-level rows and 643 admitted courses are not gains); no new course read was possible because the entry-requirements AI route is switched off in Models & services (hourly scheduler: course_reads 0, refusal text recorded). Counts: 24 sources registered at 16 providers, 22 stored, Greenwich 2 still found with no error; 20 matrix runs done, 2 failed (Le Cordon Bleu and Excelsia PDFs, `held_unparsed`, no aligned grid), 0 queued at read-back except Greenwich. Machine outcomes: admitted La Trobe, Gold Coast, Angliss; declined AIBT (`source_not_official_host`: catalogue host aibt.qld.edu.au, official site aibtglobal.edu.au), George Brown (`all_rows_held`; `gate_incomplete`), TasTAFE (`gate_incomplete`; the source is an English-only page and must not be approved as academic AER). English-only sources (AAPoly, Holmesglen English page, George Brown English policy, TasTAFE) are not counted. Layer 4 pending at the 9 matrix items: La Trobe 1, Le Cordon Bleu 1, AIBT 1, George Brown 2, Angliss 1, TasTAFE 1 (genuine exceptions to a person; none actioned by this lane). Course-level holds across the cohort (outcomes view built 07:05 AEDT): 503 identity-held (AU entry requirements accept only CRICOS code, adapter code and manual; exact_title 116, no basis 71, page mismatch 256, ambiguous 38), 184 nothing published or superseded, 118 no official course page, 155 `gate_incomplete` declines (S2-AER D-R3), 5 `would_admit` shadow decisions, 148 stored pages with unadmitted deterministic readings. These are shared-rule holds for S2-AER and S1-Build; none was loosened. Spend: model US$0.0155 for 20 matrix runs (Mistral Small 3.2; token counts are not stored on run rows), Firecrawl 4 credits (La Trobe, Box Hill ×2, TasTAFE), dollar cost not verified. Steps 6–9: Layer 4 and canonical verified as above; publication verified only at the v3 function; two unattended result-bearing cycles NOT yet shown (the admissions came from the first cycle after registration), so F-AER stays OPEN. Next executable actions: (1) S1-Build/S2-AER: PDF layout hold for the two Le Cordon Bleu and Excelsia guides; (2) person or S2-AER: AIBT official host; (3) Platform Admin: attach Melbourne College of Hair and Beauty and Signet URLs listed in the s1107 CSV; (4) Platform Admin decision on the course-level AI route (spend authority); (5) re-read this cohort at the next cycles for the two-cycle proof.

- 25 Nov 2026 07:58 AEDT, S1-AER-Claude (Admin #1049 / #1054 / #1055, Steps 3–5 continuation, spec s1109, documents only, no Pilot code, no migration): **AU Wave 1 stays OPEN; diagnosis and reconciliation recorded, no new canonical delivery in this checkpoint (still 9 new matrix rows, 0 new course-level rows).** (1) **Corrections to the 07:41 record.** The "155 D-R3 declines" are 155 decision rows over 86 distinct courses, and only 62 of those courses still stand declined `gate_incomplete` (latest per course, none withdrawn; newest decline 21 Nov 00:36 UTC, so no new D-R3 decisions since). The 503 identity-held courses have no machine decision at all, so identity and D-R3 do not overlap: affected courses are 503 + 62 + 2 `all_rows_held` = 567 distinct, not 658. The identity breakdown reconciles exactly: 503 = exact_title page-bound 116 + no basis page-bound 71 + no basis page mismatch 256 + CRICOS-bound ambiguous 31 + exact_title ambiguous 7 + CRICOS-bound page mismatch 17 + adapter_title page-bound 5 (the earlier 22 unexplained are the 17 and the 5). (2) **Course-level AI route (the one protected decision).** `security.ai_route_v1('course_entry_requirements')` returns held, mode stop, reason "switched off (Models & services)", models empty (qwen3-30b-a3b-instruct-2507 skipped "not qualified for this service"), `on_demand_exempt` false, so a scoped on-demand request cannot go around it; daily ceiling US$5, spent today US$0, OpenRouter balance US$97.28 (key limit remaining US$46.32), Firecrawl left on plan 62,190. Setting `entry.course_read_providers` (43 providers) holds none of the 40; whether the hourly scheduler uses it or the aer-schedule eligibility rules was not verified. Needs from the Platform Admin: switch the service on for a bounded scope and name one qualified lean model; nothing else. (3) **Eligible AI population.** Of the cohort's 2,259 courses, 225 have an accepted identity (CRICOS, adapter code or manual), a bound page, no admitted course row and a read skipped because the route is off; 53 of those already have a Layer 4 course read and canonical rows, leaving 172 never read by AI (deterministic reader found nothing on them). Their 225 stored pages total 11.6 MB compressed, 3.32 M extracted characters (mean 14,733, longest under the 205,000 cap, so 1 to 2 slices of 12,000). No v2 shadow answers exist for them. Previously paid answers reused first: the 53. (4) **Preprocessing path (verified in worker code).** The course entry read (`entryRead`, index.ts) converts the stored page with `htmlToText`, dropping only nav, header and footer, then slices at `enrich.course_entry_slice_chars` 12,000 with 600 overlap; lean-md-v2 and the section selector run beside it as observation only (`lean-input.ts`: "never changes a request") and `reading.markdown_input` is 1 but this reader does not use it. So the read does not yet send selected academic sections only; the requirement in this brief (send meaningful extracted sections, not whole pages) is not met by the existing route. Smallest correction, for S1-Build as Integration Controller, none made here: have `entryRead` take the selected sections when the selector marks the page likely, whole text otherwise, with recall checked on the 53 reads that already have canonical rows before any volume. Estimated cost for the 172 pages at the ledger's observed rate (course_entry_requirements 15–16 Nov: 1,357 answered calls, 3,317,749 input and 826,078 output tokens, US$0.5768, mean 2,445 in / 609 out per call; 726 failed calls US$0.0437): about 250 calls, 0.7–0.9 M input tokens, US$0.15–0.45 including retries; expected canonical yield is not estimated, the first bounded batch measures it. (5) **Greenwich** (21e1cb6d): both sources `found`, attempts 0 since 06:46 because the provider is `publication_status` unpublished and in `security.provider_hidden_v1`, so `entry_matrix_enabled_v1` is false and not AER-eligible; this is a publishing decision for the Platform Admin, not a fetch fault, and no bypass was attempted. Le Cordon Bleu and Excelsia PDFs remain `held_unparsed` (stored, status read). (6) **Shared token ledger (labelled shared-lane, not attributed to this cohort).** `entry_matrices` on 24 Nov: Mistral Small 3.2 182 answered, 400,701 in / 152,601 out, US$0.0740; GPT-4.1 mini 139 answered, 272,667 / 144,559, US$0.3185; Qwen3 30B 52 answered, 97,067 / 13,351, US$0.0135 (240, 29 and 55 failed with no tokens recorded). This cohort's own spend this session: no new AI call, no Firecrawl, US$0. Cohort spend to date stays US$0.0155 model and 4 Firecrawl credits. Two unattended result-bearing cycles still not shown. Next executable actions: (a) Platform Admin: bounded switch-on plus one qualified model for `course_entry_requirements`, and decide Greenwich publishing; (b) S1-Build: sections-first input for `entryRead`; (c) S2-AER: the 62 `gate_incomplete` courses, AIBT host, George Brown, 71 no-basis and 116 exact_title holds with the reproducible lists in this entry; (d) this lane: re-read cohort outcomes at the next cycles for the two-cycle proof and run the 172 pages as soon as (a) and (b) are in place.
- 25 Nov 2026 08:20 AEDT, S1-AER-Claude (s1109b, documents only): **Hand-off to S1-Build for the P0 meaningful-content and qualification brief (08:05 AEDT); S1-AER-Claude does not do S1-Build's shared reader, qualification or settings work.** Regression cohort reconciled for S1-Build, correcting how Admin #1061 read as "53 already read": the 53 courses (6 at La Trobe, 4 Collarts, 8 Sydney Business & Travel Academy, 8 Excelsia, 5 Australian Pacific College, 4 AIBT, 3 York, 2 each Holmesglen, Keystone, Educare, Cairns, and 1 each at 9 other providers) each have a Layer 4 `course_entry_first_read` item that is **superseded** and **152 canonical rows that are all `inactive`** (113 at 47 courses with outcome no_requirement_published, 39 at 6 courses with admitted_provider). They are earlier paid AI answers, not current canonical delivery, so the parity target is those earlier answers' rows (quote, kind, score, audience), not live published data. Unread backlog is 172 courses at 19 providers: La Trobe 67, Collarts 50, Sydney Business & Travel Academy 13, AAPoly 10, Excelsia 5, Gold Coast Learning Centre 4, then 13 providers with 1 to 3 each (101 courses with outcome no_requirement_published at 18 providers; 71 admitted_provider at 2 providers). Reproducible conditions: `pipeline.aer_course_outcomes` with `identity_basis` in (cricos_code, adapter_code, manual), `page_status` bound, `outcome` in (no_requirement_published, admitted_provider), `read_state` skipped, provider in the 40 of the s1108 CSV; page text and hash from `pipeline.aer_det_academic_pages` (evidence_id, sha256, chars) joined to `pipeline.evidence_artifacts` (storage_path, content_hash); earlier answers from `catalogue.course_entry_requirements` and `pipeline.layer4_review_items` field_code `course_entry_first_read`; token and USD from `pipeline.ai_invocations` service_code `course_entry_requirements` (1,357 answered, 3,317,749 in, 826,078 out, US$0.5768, 15 to 16 Nov). Not measured yet, and not claimed: recall of selected sections against those answers, actual token reduction, qualification outcome. Controlled activation (one qualified model and a bounded scope for these 172 pages) stays the Platform Admin's decision after S1-Build's sections-first change is released; this lane then runs the 172 and reports canonical delivery.

**Correction after the first release (25 Nov 2026, about 08:30 AEDT).** s1114 (Pilot #1601) merged and queued nothing: all 36 courses with a failed read had already been read again afterwards (24 filled, 23 skipped), so the 39 failed items are history. Spend US$0. The measured gap is 16 eligible courses whose newest read was superseded by s871 and that the deterministic reader could not read (provider counts: Pivot Education 8, Cass Training 4, Envirotech, Australian College of Studies, WAIFS and Rockford 1 each). s1115 reads those 16 once through the same course-level reader (stored page, estimate about US$0.04). Rehearsal passed (md5 9b734bf1).


## S2-AER AU wave 1 — Steps 3–5 outcome for the 30 named providers (Admin #1054) — 25 November 2026, about 08:50 AEDT

**Result in one line.** The existing course-level pipeline had already extracted, normalised, mapped and admitted what these pages state: 776 active course-level rows covering 292 of 478 eligible courses before this wave, and the same after it so far. Nothing new is admitted yet because the last re-read is waiting for the shared model worker.

**What was done.** (1) Measured all 30 providers against `catalogue.course_entry_requirements`, `pipeline.field_enrich_items`, the deterministic reader tables and Layer 4. (2) The deterministic academic reader read all stored pages and found no academic reading on any (VET and English pages state IELTS and a high school certificate; the English test is its own pipeline). (3) s1114 (Pilot #1601) queued nothing: all 36 courses with a failed read had already been read again. (4) s1115 (Pilot #1603, migration 20261126170000, rehearsal md5 9b734bf1) queued 15 course reads for courses whose newest read was superseded and unread (estimate US$0.0398) through `security.course_entry_read_enqueue_v1`. Admitted by hand: none.

**Open item for S1-Build (not mine to change).** The 15 items sit in state `ai`, with 267 entry-requirements items in that state platform-wide (oldest 18 Nov; last update 22:22 AEDT). The AI worker is not draining that queue. Until it does, the 15 courses cannot report. Next action: when the queue moves, read the 15 results (rows proposed, completeness-gate holds, Layer 4 items) and record them here.

**Skipped reasons (159):** page does not state it 59; no proven course page 34 (binding, belongs to the course-link lane); Layer 4 superseded 39 (16 courses unread, now queued; the rest read later); earlier read waits in Layer 4 8; corrected read refused 7; no row met the admission rules 7; no quoted requirement 4; route off 1.

**Expenditure.** Model: US$0 recorded so far (15 queued, estimate US$0.0398, balance US$97.23, floor US$0.50). Firecrawl: US$0. **G3** 75/48 asserted by both migrations; manual locks unchanged (7,585). **Consumer verification:** no consumer object changed; admissions did not change, so no consumer read-back is due until the 15 reads finish.

**Providers without usable evidence (Steps 1–2 blockers kept):** Brisbane College of Australia, Southern Cross Education Institute, ILSC Australia / Greystone, The Centre of Excellence (and Australian College of Technology has 3 pages, 0 covered).

| Provider | Eligible courses | Active rows (before = after so far) | Courses covered (before = after so far) | Failed items (history) | Skipped | Layer 4 pending |
|---|---|---|---|---|---|---|
| Abbey College Australia | 23 | 64 | 23 | 9 | 1 | 0 |
| Aboard Training Australia | 11 | 23 | 11 | 0 | 0 | 0 |
| Albright Institute | 19 | 74 | 15 | 0 | 4 | 0 |
| Alliance College | 17 | 40 | 16 | 0 | 1 | 0 |
| Auscanus Institute of Australia | 23 | 56 | 23 | 2 | 0 | 0 |
| Australian College of Studies | 17 | 44 | 11 | 9 | 9 | 0 |
| Australian College of Technology | 3 | 0 | 0 | 0 | 3 | 0 |
| Australian International College of Skills & Education | 22 | 59 | 14 | 5 | 19 | 0 |
| Brisbane College of Australia | 0 | 0 | 0 | 0 | 0 | 0 |
| Canterbury Technical Institute | 22 | 38 | 19 | 0 | 1 | 0 |
| Cass Training International College | 21 | 14 | 9 | 0 | 12 | 0 |
| English in Paradise / Elston | 20 | 2 | 2 | 0 | 18 | 0 |
| Entrepreneur Education | 23 | 49 | 21 | 8 | 3 | 0 |
| Envirotech Education | 22 | 20 | 8 | 0 | 14 | 0 |
| Fusion College of Technology | 21 | 46 | 19 | 2 | 3 | 0 |
| Glen Institute | 17 | 34 | 15 | 1 | 4 | 0 |
| Helix College | 20 | 30 | 13 | 0 | 7 | 0 |
| ILSC Australia | 0 | 0 | 0 | 0 | 0 | 0 |
| International Institute of Education | 8 | 0 | 0 | 0 | 8 | 0 |
| Lexis TESOL Training Centres | 7 | 8 | 7 | 0 | 0 | 0 |
| Nortwest Pty Ltd | 6 | 4 | 2 | 0 | 5 | 0 |
| Pivot Education | 11 | 5 | 3 | 0 | 8 | 0 |
| Protea College | 15 | 30 | 15 | 0 | 0 | 0 |
| Queensland Academy of Technology | 15 | 21 | 8 | 1 | 9 | 0 |
| Rockford College | 22 | 87 | 20 | 1 | 3 | 0 |
| Southern Cross Education Institute | 0 | 0 | 0 | 0 | 0 | 0 |
| The Centre of Excellence | 0 | 0 | 0 | 0 | 0 | 0 |
| TrEd College | 8 | 0 | 0 | 0 | 9 | 0 |
| WIN College | 19 | 25 | 15 | 1 | 5 | 0 |
| West Australian Institute of Further Studies | 16 | 3 | 3 | 0 | 13 | 0 |


## S2-AER AU wave 1 — reconciliation and current-state recovery review (Admin #1066 follow-up) — 25 November 2026, 12:40 AEDT

**1. Reconciliation (distinct course IDs, newest item per course, read live and rolled back).**
- Eligible courses: **426** distinct (not 478; 478 was an earlier page and item count). Newest state: 292 filled (every one holds an active row), 15 queued (`ai`), 119 skipped, 0 failed, 0 without an item. 292 + 15 + 119 = 426.
- Reported outcomes **490** = 505 items counted by attempt (292 filled + 159 skipped + 39 failed), including 2 items on courses outside the eligible set. Attempts are not courses.
- Failed: 36 courses had a failed attempt; all 36 have a later filled or skipped item. **Current failures: 0.** The 47 later outcomes are items (24 filled + 23 skipped on those courses, as counted by attempt).
- Re-reads: 16 intended, **15 queued**; the 16th has a pending Layer 4 item on another field (rule in the s1115 selection) and is the one course still showing "Layer 4 superseded".
- Layer 4: pending items for the 30 providers: **11** (8 `course_english`, 3 `course_description_first_read`); **0 entry (academic) items pending**. The 8 "earlier read waits in Layer 4" outcomes are 8 historical skips (the first read they waited for is no longer pending); they are current skips but not current Layer 4 items.

**2. Current-state review of the skipped cohorts (119 courses).** No stored rows exist to replay in any cohort (all `value.rows` empty), so no previously paid answer can be reused. Deterministic reader `aer-det-v1.3` read stored pages for 59/59 not-stated, 33/34 unbound, 8/8 waiting, 7/7 refused, 7/7 admission-rule and 4/4 no-quote courses: **0 readings on all**, with these uncovered lines:
- **Not stated (59):** 48 pages have no uncovered line; 11 have only generic lines (formal or informal learning, work or life experience; interview; units of competency). No secondary-school qualification, academic prerequisite or conditional entry statement was missed by the deterministic scan in this cohort.
- **Unbound (34):** all but 1 are now bound and read with a proof (cricos_code 20, exact_title 9, manual 4); 1 is `page_refused` (identity mismatch). They were skipped before the page was proven (E16). The deterministic reader finds no reading on their pages. Re-reading needs the model route, so it waits for S1-Build's qualification.
- **Genuine academic statements found in held cohorts (6 courses; need the model route or a person):** prior diploma or advanced diploma or two years' workplace experience (waiting); AQF Level 5 or above, or a Certificate III or IV (corrected read refused, Glen Institute); completed units of competency (waiting). The rest of the held lines are interview, language-literacy-numeracy test, placement and job-ready program text, which are not academic requirements.
- **English kept separate:** none of the above rows is an English requirement; the 8 pending Layer 4 items are the English pipeline.

**3. Not done, and why.** (a) The 15 queued reads have no outcome: 267 `ai` items platform-wide, newest update 08:22 AEDT, none moved in four hours; S1-Build owns the queue and the model qualification, so no AI was enabled or queued here. (b) No migration or re-read was added (Operating Model: no separate migration for routine re-reads). (c) The shared AU/NZ/CA items (503 identity-held, 62 D-R3 declines, 2 all-rows-held, 152 inactive rows over 53 courses, NZ `no_bound_page` and `active_rows_exist`, Canadian identity restriction) were not started in this pass and are the next executable work. (d) Australian College of Technology: 3 stored pages, 1 course read with proof (skipped as unproven) and 2 pages refused or not read by identity (`mismatch`, `page_refused`); no usable course page for the rest.

**4. Acceptance read-back (12:37 AEDT).** Canonical admissions 776 rows, 292 courses covered: unchanged, zero new. G3 75/48 with 0 drift. Manual locks 7,585. Active crons 137. Spend this pass: model US$0, Firecrawl US$0, no calls; wave total model spend recorded on the 30 providers' items US$0.4435 (all earlier). Consumer read-back: none due, nothing changed. Two unattended result-bearing cycles: not started, nothing to observe until the 15 reads complete.

**Next executable actions.** (1) S1-Build: drain the `ai` queue and qualify course-entry; then read the 15 outcomes and request the 33 proven-page re-reads and the 6 courses with academic statements through Run Now. (2) Start the shared AU/NZ/CA groups, beginning with the 503 identity-held courses. (3) Source recovery for Brisbane College, Southern Cross Education Institute, ILSC and The Centre of Excellence stays open.


## S2-AER — shared AU/NZ/CA admission recovery: measured defects and protected holds — 25 November 2026, about 15:30 AEDT

Read live and rolled back; no Pilot change, no migration, no AI call, US$0 model, 0 Firecrawl credits. G3 75/48, manual locks 7,585, crons 137 were last read at 12:37 and no change was made since. Population: S1-AER's 40-provider cohort (1,711 active courses in the probe) plus every AU/NZ/CA pending first-read item.

**Correction to the 12:40 entry.** Only **3** of the 34 "no proven course page" courses pass `security.course_page_proven_v1` today (313494f9 and 783d10d3, provider prefix 15e47a, and ca9f91b1, provider prefix 0cca4a). The earlier "33 bound and read with a proof" counted page status and identity labels, not the strict gate (identity basis present and title check not refused). The academic-statement list is **7** courses, not 6: 7214934f, 83a6597f, b6fa01c1, ef9dc7b0, f7f59fa4, fa54fdff, fbaa476c (full IDs in the probe list: 7214934f-6011-4a13-958b-cdba8ff1d897, 83a6597f-2654-47dd-b861-443bccf00ae5, b6fa01c1-1ac2-4ab6-9e79-d5d3fa2e4545, ef9dc7b0-196f-4887-bd1a-9fae39307f66, f7f59fa4-4c16-4043-b65e-5988c9544b94, fa54fdff-72cf-4228-bfea-1f52b06da741, fbaa476c-1b21-4d25-b6c5-2e691e209538). These 3 + 7 do not overlap the 15 queued s1115 courses (each course has one newest state). Hold until the course-entry route is qualified; request through Run Now, not a migration.

**1. Identity-held courses (cohort, 503 by S1-AER's count): measured causes.**
- 280 bound pages with no basis or exact/adapter title and no active row: **115 already pass the governed title identity** (`aer_title_identity_ok_v1`, switch on, bases exact_title/title_level/degree_name/adapter_title, AU and NZ); they wait for the AI route, not for identity. The rest fail it for stated reasons: another active course is bound to the same page 85; page heading differs from the course title 47; ambiguous match 12 (+4 adapter title); page not on the provider's own site 9; level not provable 5; level mismatch 2; cross-provider page 1.
- 74 bound pages with no identity basis were never successfully read: 43 are HTTP 404 on a guessed address (bases url_pattern 23, url_list 12, title_search 7, url_year 1), 16 need rendering, 5 return 403, 7 failed with 200, 3 never read. 21 of the 43 have a live alternative page at match score 0.6 or more (12 at 0.8 or more), **but none meets the binder's own rule** (best for the course by margin 0.1, best for the page by margin 0.1, no other course bound to it, not refused), so no rebind is safe. The binder's rule was not weakened.
- 17 CRICOS-bound "mismatches" are correct refusals: generic listing pages (SBTA "Timetable and Fees", TAFE Tasmania "International") that print many CRICOS codes.
- 256 page mismatches: sampled pages are wrong pages (Enquire, an intranet page, a different course code). They need page rediscovery, not looser acceptance.

**2. Pending first-read items (all AU/NZ/CA: 561 = AU 519 + NZ 42), newest machine decision on each.**
- `active_rows_exist` 386 (AU 382, NZ 4): the course already holds active rows, mostly a partial admission (rule aer-course-partial-v1, s983) whose remaining printed requirements (subject prerequisites, det_other_requirement) need a corrected read or a person. Rule text: "replacing them is a person's decision". Protected.
- `all_rows_held` 126: 131 proposed rows, 122 of them domestic-audience (ATAR and similar) held by the row-level audience rule, 8 international, 1 for all; 5 quotes under the length rule. Policy, not a defect.
- `no_bound_page` 38 (NZ 29, AU 9): 39 of the 41 items sampled for restoration are on courses with a manual lock on the page address; they are protected. One AU course is restorable; it is not worth a release on its own.
- `identity_not_admitted` 11 (NZ 9, AU 2): NZ entry requirements accept only nzqa_code, adapter_code and manual; these pages proved adapter_title or degree_name. Policy.

**3. Canada.** `aer.eligible_countries` is AU and NZ only, and the Canadian row in `pipeline.coverage_admission_countries` carries no `entry_requirements` identity list, so Canadian course-level reads cannot be admitted. Enabling Canada and naming its accepted bases is an admission-scope decision for the Platform Admin, not a defect.

**4. What this lane did not do, and why.** No identity acceptance was relaxed, no lock touched, no AI used, no migration added. Every cohort above is either correct protective behaviour, a Platform Admin decision, or waits on the course-entry model route (S1-Build). The measured defect classes that could become corrections after a decision: (a) release dead guessed-address bindings so the existing coverage binder and discovery pick the course up (needs the binder owner's agreement, since 0 safe rebinds exist today); (b) a corrected read for the partial admissions (AI route).

**Decisions and owners.** Platform Admin: Canadian course-level scope and accepted identity bases; whether domestic-audience rows may be admitted alongside international ones (currently held). S1-Build: course-entry route qualification and the `ai` queue (267 items); render and 403 reads for the 21 pages. S2-AER next: after the route opens, request the 15 queued, 3 proven and 7 statement courses once through Run Now and read the outcomes; two unattended cycles after that.

**S2-Build, 25 Nov 2026 18:30 AEDT (Platform Admin 17:13, Portal Release 1 search activation): s1153 (Pilot #1616, migration `20261127020000`, edge function `portal-search-embed`) recorded before merge.** `public.portal_course_search_v1(p_args)` and `catalogue.portal_course_search_v1` are built to the as-built contract in the portal design doc. Stage 1 reads the words into filters from the live tables: country, state, campus city (with ABS urban-area postcodes so suburbs count), study level and budget. Stage 2 ranks with the existing `search.course_candidates_v1`. Fewer than 3 exact matches bring near misses and relaxations: third-cheapest fee + 5%, rounded up to A$1,000, within +30%. Vectors (`openai/text-embedding-3-small` via OpenRouter, data collection denied) live under a new profile `portal-default`, because the frozen `api.zoho_course_candidates_v1` uses the same ranker; Zoho and website results cannot change. The backfill runs on a new registry lane of the existing dispatcher (no cron job) in steps of 1,500; one statement for all 34,362 jobs timed out in rehearsal. A trigger re-queues a course when its semantic text changes. 1,690 active courses with no search document were sent to the existing refresh. The spec number moved to s1153 because S1-Build took s1152 and `20261127010000` first. Rehearsed on live data, rolled back: nursing under A$40,000 in Melbourne returns ACU Fitzroy and IHM North Melbourne first; data science masters in Sydney or Brisbane returns QUT, CDU, Sydney, UTS and Western Sydney. G3 75/48, 7,585 locks and active cron are unchanged (post-checks).

**S2-Build, 28 Nov 2026 11:57 AEDT: s1341 live (Pilot #1750, merged 10:13; picker md5 `f9cf2487`). Productive selector cycles verified. Instructions: PC-20261128-0931-S2-Build, addenda 1000 and 1018.**

- **Cycles:** ten `scholarship_discover` calls from 10:20 to 11:50, each 200 with 30 leased. From 10:40 every call read 29 and left 1 `waiting_scraper`; before s1341, 29 or 30 of every 30 were `waiting_scraper`.
- **Reads since 10:13:**

  | Provider | Read | Admitted | Rejected | Waiting for AI admission |
  |---|---|---|---|---|
  | RMIT | 158 | 2 | 95 | 61 |
  | QUT | 107 | 4 | 64 | 39 |
  | UQ College | 16 | 0 | 16 | 0 |

  - UQ College: the 14 false fee-table labels were rejected `section_missing` through the existing lifecycle after #1742. 1 was refused by the protected provider-type hold, and 1 was rejected as domestic only. Candidate 22521 is unchanged.
  - `864f2e01` (8 pages) and `1719c3ba` (1 page) came back `scrape_failed`; not yet traced.
- **Canonical admissions: 7 new active records** (candidates admitted from 10:43 to 11:46 AEDT):
  - 3 published, and each is returned by the consumer API `public.website_v2_scholarship(stable_key)`:
    - QUT `e2011942` "From virtual sites to real opportunities: using VR to inspire young women in construction";
    - `22657140` `7ce3be4d` "SQA Undergraduate Research Scholarship";
    - RMIT `ee91ea66` "PhD Scholarship in Generative AI for Intelligent Process Safety Management".
  - 4 unpublished, held by the existing publication checks: QUT `f5e96298`, `12c3d59b` and `d836f9bb`; RMIT `96ea2e03`.
  - Corrections: 0.
- **QUT:**
  - On-demand request `272c1e34` has used 137 of its 150 units; it stops at its cap or at 14:14.
  - Listing 1429: 68 items, partial; it continues hourly from its saved place (`next_url` page 19).
- **Costs:** Firecrawl 137 units (monthly plan, US$0 marginal). AI: the existing admission queue's own reads. No Cloudflare container run by S2-Build.
- **Register:** canonical register refresh is S1-Build's (no refresh by S2-Build). `retry.scholarship_waiting_scraper_hours` stays 1; no approval was requested.

**S2-Build, 28 Nov 2026 10:00 AEDT: s1333 (splitter) live (Pilot #1742, merged 09:01, worker v1.0.62); s1341 recorded before merge (Pilot branch `s2-s1341-candidate-window-free-first`, migration `20261201030000`). Instruction PC-20261128-0931-S2-Build.**

- **Number collision:** S1-Build also used `s1333`, for the Batch 07 scholarship value corrections (migration `20261201014000`). Both rows stay in the plan. This lane's next change takes `s1341`.
- **The 29 of 30 capped leases, traced live (rolled-back reads, 09:55 to 10:00 AEDT):**
  - 1,959 candidate pages are due.
  - Cap-blocked: 1,742 pages at 23 providers (AU 687, CA 1,055). Their paid read is refused by `security.fc_sch_held_v1`: 20 providers by the per-university cap, 3 by the spend rule.
  - Readable either way: 217 pages at 5 providers (RMIT 191, UQ College 16, three others 10).
  - In the last two hours, 0 candidates were read directly and 8 through Firecrawl (6 QUT, on demand).
  - Cause: the window takes each country's oldest pages first, and the cap-blocked pages are older. The one-hour waiting-for-scraper retry returns them every hour, so RMIT's 191 (attempts 0, due, no refusal, no Firecrawl call since 25 Nov) and UQ College's 16 never reach the 600-page window.
- **s1341 (the existing selector; no setting changed):**
  - The candidate picker puts the pages of providers readable either way first.
  - A provider whose paid read is refused, and which no open on-demand request covers, keeps its free direct read (DR-15) after them.
  - Rehearsed rolled back: 30 leased in 1.26 s, every one readable — QUT 7 (on demand), UQ College 7, RMIT 7, the provider `864f2e01` 7, and 2 more.
  - The picker contracts and the governance contracts pass locally.
- **Proposal, not needed for this fix:** `retry.scholarship_waiting_scraper_hours` stays 1. The proposal for raising it (1 to 24) is recorded in the S2-Build Drive document with its population and rollback. It is no longer required for throughput after s1341, and nothing is changed without approval.
- **UQ College's 14 false labels:** they leave through the existing lifecycle. When an award candidate is read, the v1.0.62 splitter no longer finds its section, so the read records `section_missing`, which the database rejects; no model is called. The next complete read of the hub marks those members as no longer present. Candidate 22521 and its holds are unchanged.

**S2-Build, 28 Nov 2026 08:45 AEDT: s1332 live (Pilot #1741, merged 08:13; migration `20261201010000` applied); s1333 recorded before merge (Pilot branch `s2-s1333-award-field-labels`, worker v1.0.62, no migration).**

- **s1332, read back live:**
  - Picker definition md5 `470411a9…`.
  - Every `scholarship_discover` call since 08:10 returns 200 and leases 30 candidates. Before the change, every call since 27 Nov 20:00 failed with a statement time-out.
  - Of each 30 leased, 29 wait for a paid read: those providers are held by their paid Firecrawl limits (1,655 `university_cap` refusals in two days). See the decision below.
- **QUT listing 1429, recovered:**
  - Read at 08:23 through the on-demand request `272c1e34` (open until 14:14 AEDT, cap 150 units).
  - 6 pages read, 63 items and 63 members (was 30), state partial; it continues at 09:23 by the existing partial retry.
  - 17 new QUT candidates.
  - First candidate reads through Firecrawl: 1 read and waiting in the AI queue, 1 duplicate of an admitted record.
  - Firecrawl used so far: 8 units of 150 (`sch_scrape`, within the monthly plan, US$0 marginal).
- **UQ College hub (listing 2412), read directly at 08:22 ($0), complete:**
  - 20 items. The real awards are Integrated English Scholarship (award section), UQ English Language Scholarship (link to UQ's award, already held under UQ as 09c117a6; the duplicate rule applies), and the 2027–2028 Integrated English block.
  - **Defect found:** the s1037 label splitter also read the "Scholarship value" fee tables as 14 "awards" named by their rows ("Scholarship value - $8,585.00").
  - 15 UQ College award candidates were created (1 real, 14 from the defect). None is read yet: UQ College is tier 3, and the window is filled by tier 0 and 1 candidates that wait for paid reads.
  - Candidate 22521, the provider type and the holds are unchanged; the migration checks 22521 byte for byte.
- **s1333 (fix for the defect above):**
  - `catalogue.ts labelSections`: a label that names a field of an award ("Scholarship value", "Award amount", "Scholarship eligibility" and the like) is part of the award above it, and a table cell is never a tier.
  - A regression case reconstructing UQ College is added to the s1037 spec (same guard). S1-Build: the test register needs regenerating (one test added).
  - The s1037, s1035 and s1051 splitter specs and the 181 specs that read the worker source pass locally (browser-only specs need the dev server, which this sandbox lacks; CI runs them).
  - Worker v1.0.62 (v1.0.61 was the latest). S1-Build is told of this shared runner change in this entry and in the handover.
  - The 14 defect candidates already created take the normal read and admission route; they cannot be admitted under UQ College while its provider-type hold stands. The next weekly read of the hub no longer lists them.
- **Decision for the Platform Admin (not changed here):** `retry.scholarship_waiting_scraper_hours` is 1.
  - About 1,500 candidates of providers held by their paid limits re-enter the 600-row window every hour. The free direct read fails for nearly all of them (29 of 30 per call), so readable lower-tier candidates (UQ College, tier 3) do not get a turn.
  - Raising the setting, for example to 24, would free the window. It is a platform-wide scheduling value, so it is left for a decision.

**S2-Build, 28 Nov 2026 08:05 AEDT: s1332 recorded before merge (Pilot branch `s2-s1332-scholarship-reader-recovery`, migration `20261201010000`, no worker change). Scholarship reader exceptions (SS-Programme-Control 28 Nov 2026 07:22 AEDT, P0).**

- **Found live (rolled-back reads, DR-19 and the worker ledger):**
  - Candidate reading is stalled for every provider, not only QUT. Every `scholarship_discover` call since 27 Nov 2026 20:00 AEDT failed with `svc_scholarship_candidate_next: canceling statement due to statement timeout` (`pipeline.mode_outcome_ledger`, HTTP 500). 2,073 candidates are due; QUT's 75 have not been leased since 24 Nov.
  - Cause: the directory-site rule `security.third_party_host_v1` is asked once per page of the 600-page window and takes 6.6 s of the 8 s limit. It reads only the page's site host, and the window holds about 40 hosts.
  - QUT listing 1429: read on 24 Nov through Firecrawl (pages 1 to 3, 30 items; the direct copy gives no items). Page 4, and every first page since, was refused `university_cap`. QUT has used its whole per-university scholarship allowance (150 units in the rolling 30-day window, spent 12 to 24 Nov), so paid reads wait until mid-December. Across providers, 1,655 `university_cap` refusals in two days.
  - UQ College candidate 22521 (`/scholarships`, now `/apply/scholarships`) is a hub of award blocks. It was read once as one page (8 Oct, direct, HTTP 200) and rejected `no_named_title`. It is not a listing source, so the existing award-section readers (s1035 headings, s1037 labels and tiers) never split it.
- **Change (existing mechanisms only):**
  1. `public.svc_scholarship_candidate_next` asks the directory-site rule once per distinct site host of its window. Every other rule, order and limit is unchanged.
  2. QUT gets one Claude-session on-demand Firecrawl request (`security.on_demand_open_v1`), scoped to the `scholarships` purpose group and capped at 150 units (s903), for the existing six-hour window. Listing 1429 is read again now. The scheduled listing and candidate lanes do the reads.
  3. UQ College's hub is registered as a manual listing source and read now, as s1043 registered the Charles Darwin hub.
     - Candidate 22521, the provider type and every admission and eligibility rule are untouched; the migration checks that 22521 is byte-for-byte unchanged.
     - Each award candidate takes the normal read and admission route, with its holds.
     - Decision 1 (provider type) stays with the Platform Admin.
- **Rehearsed (rolled back, live data):**
  - The picker returns 30 in 439 ms; before the change it took 4.8 s warm and timed out under load.
  - The same pages pass: 2,325 due rows, 0 differ, 2 on directory sites.
  - The on-demand request opens scoped and capped, with Firecrawl 59,133 left on the plan and OpenRouter US$81.63.
  - The listing picker leases 1429 and the UQ College hub first.
  - Spend: Firecrawl within the monthly plan (`ops_cost.fc_usd_per_credit` 0), at most 150 units; no model is called by this change.
- **Guards:** pre-flight passed; the scholarship picker contracts (s1199, s1054, s226, s29, s34, r4b) and the governance contracts (s42, s57, s980, s120, s616) pass locally. G1 to G3 unchanged; 7,585 locks and the active cron jobs are checked unchanged; nothing is dropped or deleted. No new reader, queue, job, setting or admission path.
- **Next:** merge, then verify recovered pages, extracted candidates and admission outcomes for QUT and UQ College, and record them here.

**S2-Build, 27 Nov 2026 14:20 AEDT: s1304 merged (Pilot #1725, migration `20261130160000`, worker v1.0.59). The reader lifecycle runs unattended in production for academic entry and scholarships; first results below. Acceptance is not complete.**
- **Academic entry, RMIT (production, read back 14:15 AEDT):**
  - **Detected and proposed:** the held template `country_page_generic_heading` at 13:49, by job 337's lifecycle step.
  - **Qualified at 13:49** on stored copies with deterministic readers only, $0. Of 8 samples, 6 positive pages passed the completeness guard with the country taken from the address. No deterministic reader proved the RMIT tables. The 2 negative pages (foundation, global assessment) stayed held. Mode: guard then routed model.
  - **Activated at 13:54** as a separate step, under the Charter item 1 authority recorded in the knowledge pattern. 35 held pages were re-queued.
  - **Re-reads:** they now go through the existing `entry_matrices` route (Mistral Small 3.2). At 14:15: 21 queued, 12 queued after `time budget`, 1 `held_incomplete` (a column left out), 1 with no model answer. No rows yet.
  - **Throughput:** job 337 called the worker 6 times in 30 minutes, and the model reads of RMIT pages exceed the call's time budget. This is the existing route's throughput, flagged to S2-AER. Admission, publication and consumer read-back for RMIT are pending these reads.
- **Academic entry, unsupported structures:** 7 PDF providers recorded as `HELD:READER_RELEASE_REQUIRED` (pattern `reader_config:aer_matrix:pdf_layout_unproven`). They are not proposed again until the stored copy changes.
- **Scholarships (production):**
  - 123 zero-item pages recorded as `HELD:NOT_A_LISTING` for the scholarship owner.
  - 2 provider proposals qualified at 13:52 on stored copies (link hosts). Neither gained an item, so both are `HELD:READER_RELEASE_REQUIRED` and prevented from repeating on the same copies.
  - No scholarship configuration has qualified yet, so activation (held for the Platform Admin) has not been exercised in production.
- **Knowledge (s1292 store):** 133 outcomes so far, 1 successful.
- **Guards:** G3 75/48, locks and cron unchanged (all migrations' post-checks passed). No new job; $0 at qualification.
- **Next for this lane:**
  - watch the RMIT re-reads to admission and consumer read-back, then the next proposals each cycle;
  - for scholarships, extend the qualified configuration options where stored copies show the reason (listing cards without award words), as a governed reader release.

**S2-Build, 27 Nov 2026 13:10 AEDT: s1303 merged and deployed (Pilot #1724, migration `20261130143000`, worker v1.0.57); live correction and s1304 (scholarships) recorded before merge.**
- **s1303 live read-back (12:58 AEDT):**
  - The functions are present.
  - No lifecycle step has run yet: the entry-matrix job (`security.entry_matrix_fire_v1`, job 337 every 5 minutes) calls the worker only while entry-matrix work is due. It made 0 entry_ai calls in 2 hours, so no proposal was made. RMIT's 36 pages are still held.
- **s1304 corrects this:** job 337 runs the lifecycle step itself and counts queued qualification samples as due work (anchored, md5-guarded).
  - Rehearsal (rolled back, on live s1303): the job's step proposed RMIT, with 8 samples due, and the worker call went out.
- **s1304, scholarships, on the same lifecycle:**
  - **0-item listing pages** (347 at 99 providers) are classed:
    - help, status or application pages, and one award's own page (for example UPEI `display?awardid=`, or Wintec award pages under its own scholarship finder), are recorded once each as `HELD:NOT_A_LISTING` for the scholarship owner;
    - other listings get a provider proposal. Rehearsal: 196 not a listing, 151 at 83 providers proposed.
  - **Configuration** (data only): hosts the listing links its awards to, from links whose own words name an award, at least two per host.
  - **Qualification:** on stored copies with the existing listing readers, before and after adding the hosts; no fetch, no model.
  - **Activation:** its own step, held as `HELD:ACTIVATION_AUTHORITY`. No standing authority covers scholarship reader configurations; the Platform Admin can grant one through `security.ops_learning_eligibility_set_v1`.
  - **No gain:** a listing that gains nothing is held as `HELD:READER_RELEASE_REQUIRED`.
  - **Rehearsal:** samples leased for Langara and Western Sydney.
- **Release:** migration `20261130150000`; worker v1.0.58.
- **Guards:** G3 75/48; locks and cron unchanged; no job; $0.
- **For S1-Scholarship-Claude:**
  - not-a-listing records are outcomes of `reader_config:sch_listing:not_a_listing` (Recovery knowledge);
  - an active configuration only adds hosts to the listing read; the listing record, candidates and admission are unchanged.

**S2-Build, 27 Nov 2026 12:45 AEDT: reader lifecycle renumbered s1303 (academic entry) and s1304 (scholarships).**
- **Why:** S2-AER merged Pilot #1719 as s1296, with migration `20261130123000` and worker v1.0.55, the numbers this lane had claimed at 12:10.
- **New numbers:** migration `20261130143000`, worker v1.0.57. v1.0.56 is left for S1-Build s1298 (#1722).
- **Rehearsed again** (rolled back, 12:44 AEDT), with the same result as before:
  - RMIT proposal: 8 samples;
  - a model-dependent pass from simulated sample reads;
  - the activation step re-queued 35 pages;
  - India was taken from the page address.
- **PRs:** Pilot #1720 closed; a new Pilot pull request follows.

**S2-Build, 27 Nov 2026 12:10 AEDT: Autonomous PIM reader lifecycle, academic entry (s1296), recorded before merge; s1297 (scholarships) claimed. SS-Programme-Control 11:27.**
- **What it does:**
  - **Detect:** held entry-matrix templates are detected on the existing entry-matrix read.
  - **Reuse or propose:** an active provider reader configuration is reused, or one is proposed as a versioned Layer 2 source profile. The configuration is data only: the address country and registered `reading.entry_*` overrides.
  - **Qualify:** each proposal is qualified on stored copies by the same worker code, with deterministic readers only (no model, no fetch, $0).
  - **Activate:** a separate, audited step, only under the standing authority the class's knowledge pattern records (Charter item 1). Otherwise `HELD:ACTIVATION_AUTHORITY`.
  - **Process:** held pages are read again through `admin_entry_matrix_reread`.
  - **Learn:** every outcome goes into the s1292 recovery knowledge, with prevention and no-yield blocks.
- **Structures the existing readers cannot prove** (14 PDFs) are held as `HELD:READER_RELEASE_REQUIRED`.
- **Release:** migration `20261130123000`; worker v1.0.55; implementation record `docs/platform/2026-11-27-autonomous-pim-reader-lifecycle.md`.
- **Live baseline:** 452 entry-matrix sources at 259 providers; 50 held_unparsed at 15 providers, including RMIT's 36 country pages.
- **Rehearsal (rolled back, 12:03 AEDT):**
  - RMIT proposal: 8 samples, 6 positive and 2 negative.
  - Simulated sample reads: a model-dependent pass.
  - Activation step: 35 pages re-queued; India resolved from the address.
  - 13 PDF providers classified.
- **Guards:** G3 75/48; locks and cron unchanged; no new job; $0 at qualification. Re-reads after activation use the existing entry_matrices route and its caps.
- **For S2-AER:** the entry-matrix loop now carries an optional `reader_config` (`svc_entry_matrix_next` one key; worker `reader-config.ts`). Nothing changes when none is active.
- **For S1-Build:**
  - regenerate the TEST-REGISTER for `cf-247-s1296-reader-lifecycle-contract` (6 tests), per §3b;
  - s1296 uses Layer 2 source profiles as the reader-configuration store, the store the #1271 design prefers. Please agree the shared interface before #1271's recipe replay uses the same profiles.

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
- S1-AER-Claude, 26 Nov 2026 15:50 AEDT (SS-Programme-Control assignment: Australian AER autonomous PIM delivery and acceptance; spec s1219, documents only, no Pilot code, no migration, no setting change): reconciliation of the 40-provider AU cohort and of the autonomous route. US$0 spent, Firecrawl 0, no AI call by this lane since 25 Nov 07:00.
- **Cohort state, read live at 15:05 AEDT (outcomes view built 15:05).** Courses with admitted course-level AER 732 (643 at 25 Nov 07:05, +89); active course-level rows 1,954 (1,564, +390); identity-held 395 (503, minus 108); awaiting Layer 4 58 (27); admitted by provider matrix 243; nothing published 131; no official course page 108; excluded 44. Provider matrix unchanged: 9 active rows at 3 providers (La Trobe 2, William Angliss 4, Gold Coast Learning Centre 3).
- **Attribution (not claimed as autonomous delivery).** All 390 new rows are `gpt-4.1-mini` entries from S1-Build's bounded course entry read windows (25 Nov 18:00 hour 42 rows over 10 courses; 26 Nov 09:00 hour 157 over 37; 10:00 hour 191 over 42), each a scoped request with the route off afterwards. Largest: Collarts 40 courses; then Gold Coast Learning Centre 6, Lead College, York Business Institute and Aventia 5 each. All 89 new courses are at providers with publication_status `published`. No new row in this cohort came from an unattended scheduled route since 25 Nov 07:00, so this cohort adds **no** unattended result-bearing cycle to PIM acceptance yet (two cycles stay S1-Build's, with the evidence above as the starting record).
- **Matrix and source recovery: nothing has moved since 25 Nov 07:18, and the autonomous route does not retry these.** Greenwich (21e1cb6d): both sources `found`, 0 attempts; the provider is unpublished and hidden, so the fetch refuses it by design (Platform Admin: publish or leave). Le Cordon Bleu and Excelsia guide PDFs: run `failed`, source status `read`, not requeued (no reader version change); the two PDFs need a layout reader or a qualified model, same class as ACU (s1071) and CQU (s1105, s1106). CQU (4ff4010f 0 rows; 50e4031c): run done 25 Nov 08:04 with **112 rows kept**, declined 08:18 `source_not_official_host` (host `delivery-cqucontenthub.stylelabs.cloud`); the retired copy 55de8e6d is inactive. AIBT: declined the same rule (aibtglobal.edu.au against aibt.qld.edu.au). William Angliss: 4 rows admitted partial at 07:14, then declined `gate_incomplete` 13:18 for its further read; George Brown (`all_rows_held`, `gate_incomplete`) and TasTAFE (`gate_incomplete`; the source is English-only) unchanged. ACU holds 377 active matrix rows. Layer 4 pending platform-wide: 92 `entry_matrix_first_run`, 17 `entry_matrix_change`.
- **Reusable defect found: official source on a different host.** The machine admission's host rule has a Platform Admin alias list, `aer.provider_host_aliases` (s1038, first entry adelaide.edu.au). CQU (112 rows waiting) and AIBT need the same decision; the Curtin CDN host was left unaliased earlier ("not decided"). Not changed by this lane (a protected setting). **Platform Admin decision requested:** alias `delivery-cqucontenthub.stylelabs.cloud` for CQU (evidence needed first: that cqu.edu.au links to that file; not verified in this record) and `aibtglobal.edu.au` for AIBT.
- **Spec reservations reconciled with the record** (Master Plan table status cells updated in this change): s1042 documents only, closed; s1049 Pilot #1557 merged and deployed 24 Nov; s1106 Pilot #1596 merged 25 Nov (s1105 #1595, s1071 #1565, #1568, #1569 also merged); CQU re-read through 50e4031c done after s1106. S1-Build to confirm no objection to closing the three; no other reservation held by this lane.
- **Autonomous mechanism, verified from live state and Admin #1146 to #1166 (not re-derived):** `coverage-read` and `aer-det-sweep` run unattended on stored pages; the revisit step s1171 has 0 pages due until 5 Dec; course entry AI runs only as bounded windows (route off between); 2,028 never-AI-read courses wait on the shared programme page identity decision. 176 cohort courses still match the read-skipped definition at 15:05. Consumer read-back: all 89 new courses are at published providers (database state); the read through `website_v3_course` with the course UUID returned NOT_FOUND, so the identifier form is not established and **the consumer read-back by this lane is not verified**; S1-Build's records carry read-backs by official course identifier (for example 120328M). Data Delivery: the AU AER counts above can be compared to the snapshot; no screen change from this lane.
- **Next, in order:** (1) Platform Admin: the two host aliases and the Greenwich publishing decision; (2) S1-Build or S2-AER: PDF layout reader for Le Cordon Bleu and Excelsia guides, then requeue by reader version; (3) S2-AER: George Brown, TasTAFE and Angliss `gate_incomplete`; (4) this lane, after (1): re-read machine decisions for CQU and AIBT and verify admission and consumer read-back by official identifier; (5) this lane: record the next two scheduled cycles' new cohort rows (none expected until the next window or identity decision).



## S2-AER — Global Autonomous PIM, shared AER mechanisms: admission failures reconciled by rule — 26 November 2026, about 15:30 AEDT

Read live (read-only queries; the matrix check `security.aer_matrix_machine_check_v1` is stable). No Pilot change, no migration, no AI, US$0 model, 0 Firecrawl credits. Pilot #1502 (s995) is still an open draft, last updated 23 Nov; its UWA course-to-ATAR-band dependency and decision are unresolved, so it is retained and not touched.

**1. Course-level entry (Layer 4 `course_entry_first_read`, pending, newest machine decision).**

| Rule | Items | Kind | Owner of the next step |
|---|---|---|---|
| `active_rows_exist` | 566 (386 at 25 Nov 13:00) | Protected: partial admissions (s983) leave the remaining printed requirements pending; replacing admitted rows is a person's decision | Person, or a corrected read when the AI route is open (S1-Build) |
| `all_rows_held` | 147 | Policy: row rules (domestic-audience rows, quote length) | Platform Admin policy on audience |
| `no_bound_page` | 38 | Protected: manual locks on the page address (39 of 41 sampled 25 Nov) | Territorial lanes |
| `identity_not_admitted` | 11 | Policy: NZ accepts nzqa_code, adapter_code, manual only | Platform Admin |
| `partial` (admitted, item still pending for the rest) | 4 | Working as designed | n/a |

The 566 is growth, not a defect: 184 partial admissions were made in the last 24 h and each leaves a pending residual.

**2. Country matrix (`entry_matrix_first_run` 92, `entry_matrix_change` 17), checked with the matrix machine rule.**
- `gate_incomplete` (D-R3) 56: the reader dropped published rows whose quote was not on the page (`quote_not_on_page`) or whose grade was not inside the stored quote (`grade_not_in_quote`). Sampled dropped quotes are real requirements (for example NCEA Level 2 credits, IB passes), and are cut at about 120 characters.
- `all_rows_held` 29; `change_of_admitted_table` 17 (a change to an admitted table is a person's decision); `host_shared` 3; `source_not_official_host` 2 (aibtglobal.edu.au for aibt.qld.edu.au; a CQU content-hub host); `earlier_rejection` 1; `no_rows` 1.
- All 109 carry the check's own next action: a person decides in Layer 4. None is eligible for the approved matrix machine rule today.

**3. Machine ledger, last 24 h (`pipeline.aer_machine_admissions`).** Admitted 363 courses (`aer-machine-v1`), 184 partial admissions; declined `active_rows_exist` 364 rows on 180 courses, `gate_incomplete` 185 (181 courses), `all_rows_held` 45 (24), `identity_not_admitted` 21 (20). The last admission was 10:59 AEDT and the last decline 14:48 AEDT, so cycles are running and the machine-eligible queue is spent. Historic D-R3: 1,503 courses had `gate_incomplete` as their newest decision at 25 Nov; all have no rows, their items are superseded, 1,488 are skipped "Layer 4 superseded (not admitted)" and 15 are the s1115 queued reads.

**4. Technical versus Layer 4.**
- Genuine Layer 4 or protected: every rule above except D-R3 quote handling.
- One candidate technical defect, **not yet proven**: D-R3 `quote_not_on_page` and `grade_not_in_quote`, where stored quotes are capped near 120 to 300 characters and the grade can sit beyond the cap. Proving it needs the stored page text beside the dropped quote (storage object, not reachable by SQL). It is the reader's quote check, which is an approved evidence safeguard; the confidence threshold (0.8 course, 0.9 matrix) and the D-R3 gate are not changed by this finding. If proven, the smallest correction is in the AER v2 reader's quote capture, not the gate.

**5. Consumer resolution (not matrix counts).** Sample of 25 courses admitted in the last 24 h: all 25 resolve through `public.website_v2_course` and all 25 return a populated `item.entry` (requirements_note, scores, prerequisites). The consumer `entry_requirements` object carries only the English basis; that frozen shape is unchanged (G3). The first sample course has 6 canonical active prior-qualification rows and their text is in `entry.requirements_note`. A full 363-course read times out the function, so 25 is a sample, not a census.

**Not done:** no admission opportunity was found that the existing approved rules do not already take; no reusable mapping defect (applicant country, qualification, level, grading scale) was found in these populations. Two unattended result-bearing cycles are not verified: admission-bearing cycles ran at about 10:48 to 10:59 AEDT and none since.

**Next executable action:** prove or disprove the quote-capture defect on 10 sampled D-R3 items (stored page text against the dropped quote); if proven, ship the smallest AER v2 reader correction through the governed route and re-read only the affected stored items. Coordination: S1-AER-Claude and S3-AER-ChatGPT for their territorial queues, S1-Build for the corrected-read route.

### s1240: AU AER source identity verification and alias decisions (S1-AER-Claude, 26 Nov 2026, 17:05 AEDT)

Assignment from SS-Programme-Control (26 Nov 16:28). Decision pack: `docs/platform/p0-aer-activation/2026-11-26-s1240-au-aer-source-identity-alias-decisions.md`. No setting, migration or data change.

- **CQU:** provider `f02d9d9b-0eb2-4f0e-8215-27a36ae63aa6`; proposed alias host `delivery-cqucontenthub.stylelabs.cloud` for this provider only; source `50e4031c`, evidence `fb856fec`, hash `976f3c5e…db42`, 112 rows kept. The page-to-CDN link target is to be confirmed in stored evidence `d5e12d94` before approval.
- **AIBT:** provider `eb9e3903-6d92-4502-a2b3-51cb231b21fc` (CRICOS 03430J); proposed alias `aibtglobal.edu.au`. AIBT International `fc6f01a7…` (CRICOS 03610E) must not be aliased.
- **Consumer read-back:** `website_v3_course` takes the course stable key, not the UUID. Eight newly admitted courses (Aventia, Box Hill, Collarts, Excelsia, Gold Coast Learning Centre, La Trobe, Lead College, York) read back with entry rows.
- **PDFs:** Le Cordon Bleu Table B is on pages 16 to 33; the run fails on prose page 3, so the reader needs a page scope (S1-Build/S2-AER). The Excelsia guide holds no entry table; retire that source, no layout recovery needed.
- **Held:** Greenwich unpublished; protected settings untouched; gate_incomplete and D-R3 items stay with S2-AER.

## S1-Build — PIM go-live acceptance evidence and D1 to D5 execution — 26 November 2026, 17:00 AEDT

**Decisions D1 to D5** (Platform Admin, relayed 15:09) are recorded in Admin #1167 before execution.

**D1, Adelaide retired host (s1196, Pilot #1667, live 16:00).**
- **Impact:** exactly one provider, Adelaide University: `adelaide.edu.au`, with 56 active courses' pages and 9,399 stored addresses. Official subdomains and alternative domains at other providers are untouched.
- **Reconciliation, 56 not 55:** 35 found nothing on the new site, 14 had a verified new-host page later replaced, 4 found, 2 queued, 1 never queued. The 12:37 "55" was a miscount.
- **Change:**
  - relink and the site-map binder never use a retired host;
  - the trigger `course_page_retired_host_guard` refuses any machine write onto one, from all 14 writers;
  - 75 courses asked again; 4 left open (2 locked, 2 other).
- **No regression, proven in a rolled-back rehearsal:**
  - 0 retired-host candidates;
  - no retired-host binding created;
  - a machine move onto the retired host is refused; manual moves and moves onto the new host apply.
- **Live by 16:50:**
  - 14 courses re-bound to `adelaideuni.edu.au`;
  - 54 of 75 requests settled;
  - 42 pages remain on the retired host while relink keeps trying;
  - canonical requirements and the 7,585 locks are unchanged.
- **Site-map finding:** the current site's own site map still lists old-host addresses (9,462 stored, none on the new host). s1196 keeps the binder from using them; relink builds new-host addresses from verified page forms.

**D2.** The 35 courses are retained. No lifecycle change, unpublishing or row removal.

**Holmesglen `lean-md-v3`, first live verification (s1197, Pilot #1669).**
- The stored Holmesglen page went through the existing recall job under worker v1.0.48.
- The labelled line is in the lean text (`gold_in_lean` true; false under v1.0.45 and `lean-md-v2`). $0.
- s1198 switches the job off again.

**F-OPS.16, unattended result-bearing cycles, measured live:**
- **Scholarships: three cycles evidenced end to end.** Each was found by the site-map scan, read and extracted on the scheduled qwen3-30b route (US$20 daily cap), admitted, published and read back through `website_v2_scholarship`, with no on-demand request for the provider:
  - 26 Nov 02:27, UNSW Academic Excellence Award;
  - 08:44, International Priority Program Scholarship;
  - 11:14, IUGS Entrance Scholarship.
- **Academic entry: none.**
  - Every row admitted in 72 hours came from S1-Build's bounded on-demand windows.
  - The machine admission job ran unattended but admitted window output.
  - Blocked by the scheduled course entry route's US$0 daily cap (Platform Admin, 25 Nov 18:26).
  - **Protected decision required:** a scheduled daily cap for `course_entry_requirements` (gpt-4.1-mini, qualified), inside the US$5.00 platform limit.

**F-OPS.13 to F-OPS.21, against evidence:**

| Item | State | Evidence or what is open |
|---|---|---|
| F-OPS.13 field state | Delivered by S1-RM-Design (s1160, s1161, read back 25 Nov); not re-verified by S1-Build | — |
| F-OPS.14 one planner | Partly evidenced | Planner proposes academic entry steps; cron 138 of 140. Automatic enrolment of a new provider not yet evidenced |
| F-OPS.15 replacement safety | Open | Changed, unchanged and recovered-page evidence (S1-RM-Design). s1196 adds that no binding moves onto a retired host |
| F-OPS.16 unattended cycles | Open | Scholarships evidenced (3). Academic entry 0, pending the protected cap decision |
| F-OPS.17 Data Delivery | Open | s1217, s1218, s1221 live and desktop read back (S1-API-Frontend-Delivery); live 412 px phone read-back not done |
| F-OPS.18 requests | Open | `pim.requests` has no database source (`not_projected`) |
| F-OPS.19 permissions | Partly evidenced | Role gate read per role and role-gate tests (Pilot #1663) |
| F-OPS.20 model and spend | Not verified by S1-Build | — |
| F-OPS.21 monitoring | Open | s1175 and s1221 delivered workers, stalls, consumer read-back and freshness. s1176 (live 26 Nov 22:34) adds every cron job by jobid, every lane, rule and target with state, heartbeat, next run and outcomes; read back signed in at measured 1024 and 412 px. Still open: requests, AER and description consumer read-back |

**PIM go-live is not complete.**

**D3, D4, D5 and reservations:**
- D3: the compatibility check passed, but the session proxy refuses settings writes (HTTP 403). The Platform Admin enables **Automatically delete head branches**.
- D4: 2,107 branches revalidated with recovery SHAs; deletion refused in this session; 0 deleted.
- D5: 118 snapshot branches removable, 44 kept.
- Lists and steps: `2026-11-26-repository-branch-inventory.md`.
- 32 stale reservation statuses corrected; `s1042`, `s1049` and `s1106` closed.

**Spend:** US$0 this session. Firecrawl: none called directly; Adelaide's site-map read uses the existing $0 sitemap path.

## S2-AER — William Angliss, George Brown and TasTAFE: matrix holds classified; shared course-label defect corrected (s1252) — 26 November 2026, about 17:30 AEDT

Read live; one reusable defect found and corrected through the existing shared validator `security.entry_course_link_v1` (Pilot s1252, branch `s2-aer-link`). Rolled-back rehearsal passed (run 45762396713). Spend US$0, no Firecrawl, no AI. G3 75/48 untouched; confirmed and rejected course links are asserted unchanged by the migration itself.

**Where the three providers stand.** All 15 course-level entry decisions for TasTAFE (11) and William Angliss (4) are machine-admitted. George Brown has none at course level. What is outstanding is four pending `entry_matrix_first_run` items (created 24 Nov):

| Item | Page | Rule | Verdict |
|---|---|---|---|
| William Angliss `2d93558d` | International entry requirements page | D-R3 `gate_incomplete` | **Genuine evidence hold.** The page names no applicant countries ("your home country" placeholders, 3 unknown_country) and the reader also dropped 5 rows from one narrative sentence. The gate is correct; no matrix can be built from this page. |
| TasTAFE `fd87539f` | English entry requirements (LANGUAGECERT, MET, DET, English programme tables) | D-R3 `gate_incomplete`, 5 unknown_country | **Wrong domain, not a validator defect.** These are English-test rows, offered to the academic matrix lane. They belong to the English AER lane; a person rejects or redirects the academic item. |
| George Brown `d15783d6` | English Language Requirements Policy PDF | D-R3, 2 `grade_not_in_quote` | **Wrong domain**, same as TasTAFE (English policy wording). |
| George Brown `00fdaefe` | Recruitment, Admissions and Enrolment Policy PDF (NSW) | `all_rows_held`: course_unlinked 4, no_minimum 1, minimum_not_in_quote 1 | **Mixed.** The course_unlinked hold is a reusable technical defect (below). no_minimum (unit-completion rows with no score) and minimum_not_in_quote are genuine row holds. |

**The defect.** Labels such as "RII60520 Advanced Diploma of Civil Construction Design" could never link to a catalogue course, for two reasons in shared code: `security.entry_course_label_levels_v1` names only degree-level words, so a Diploma or Advanced Diploma label never reached the exact-title step; and a printed national training package code (RII60520) is not part of the catalogue title. The catalogue holds the courses (for example CRICOS 111102D Advanced Diploma of Civil Construction Design).

**The correction (s1252, migration `20261129133000`).** One md5-guarded edit of `entry_course_link_v1` (live md5 f6ef02c5…): only when the established level helper names no level, take the level from the existing mapper `security.entry_label_levels_v1`, strip a leading training package code, and link only on this provider, an active course, the level named, and exactly one exact title. Conjoint and slashed labels are excluded; cached "unresolved" labels that name no level are evaluated again. Nothing is forced and nothing decided is changed.

**Measured effect (rehearsal, rolled back).** 27 unresolved labels name no level; **9 link** (6 providers; 5 carry a training package code, 2 of them George Brown's); 0 ambiguous. Unresolved links 162 to 153. The other George Brown labels stay unresolved because the catalogue has no such title ("Marketing & Communications" against "Marketing and Communication", Community Services (Case Management), the ICT telecommunications title).

**What the correction does not do.** It does not admit anything. A linked label reaches admission only when its matrix item is read again through the existing governed route; the George Brown item `00fdaefe` keeps its stored `course_linked: false` rows until then, and its other holds remain. So the gain is 9 course links now, with admission to follow from a re-read, not a count of rows.

**CQU and AIBT source identity (S1-AER-Claude).** Both are `source_not_official_host` on pending first-run items: AIBT source host `aibtglobal.edu.au` against the provider host `aibt.qld.edu.au`; CQU source host `delivery-cqucontenthub.stylelabs.cloud` against `cqu.edu.au`. Verification needs official evidence that each source host is the provider's own (a page on the provider's own site linking to or naming it). This session could not fetch the AIBT site (approval not granted) and holds both for S1-AER-Claude to verify; the host rule is not relaxed and no alias is added.

**Register:** the generated TEST-REGISTER is not regenerated here. A from-main regeneration would drop rows for lanes whose Admin entries are merged ahead of their Pilot PRs. S1-Build to include `cf-247-s1252-vet-course-label-identity-contract` (3 tests) in its next regeneration.

### s1241: A1 to A4 approvals recorded, evidence status (S1-AER-Claude, 26 Nov 2026, 17:35 AEDT)

Approvals relayed by SS-Programme-Control recorded in the s1240 decision pack, section 7. A2 (AIBT alias) is approved and prepared for S1-Build to execute. A1 (CQU alias) waits on one unmet evidence condition: the stored page `d5e12d94` link and the stored-bytes hash cannot be read from this session (`entry_inspect` returns no anchors and does not cover these sources). A3 (Excelsia source retirement): database dependency check clean (0 matrix rows, 0 open runs, 0 pending Layer 4, 0 active requirements); stored-copy check pending the same read-only addition. A4: no action. The three "no requirement held" courses hold general entry notes and resolve to `contact_provider` for every country; a product rule for S2-AER. No setting, source or data was changed.

**Live read-back, 26 Nov 2026 about 17:15 AEDT (Pilot #1672 merged, deploy succeeded, migration `20261129133000` applied).** `entry_course_link_v1` md5 changed from f6ef02c5… to 1f0084c6…; unresolved links 162 to 153; 9 new confirmed title links, as rehearsed. George Brown gained 2 (BSB60320 Advanced Diploma of Human Resource Management; RII60520 Advanced Diploma of Civil Construction Design). Its Graduate Diploma of Management (Learning) label already named a level, so it was unchanged and its remaining labels have no catalogue title. The other 7: Australian Institute of Design (3 training package codes), Australia Institute of Business and Management, ICHM, New Zealand Management Academies, The Open Polytechnic of New Zealand. No confirmed or rejected link changed (asserted in the migration). George Brown item `00fdaefe` still holds its stored `course_linked: false` rows until its read is repeated through the existing governed route.

## S2-AER — Stored AER evidence inspected; LCB table scope proven; shared PDF reader scope (s1253) — 26 November 2026, about 19:00 AEDT

Assignment "Stored AER evidence inspection and shared PDF reader recovery" (Operating Model v1.26; Admin #1191 A1 to A4). Existing mechanism first: the workflow `aer-entry-inspect` and worker `entry_inspect` already export a stored copy (hash verified, PDF items per page), but the workflow listed only sources with a pending first read, so CQU, Excelsia and LCB could not be selected. Pilot #1677 adds selection by source id (at most 12 UUIDs, each validated), a PDF page range, bounded link targets for stored HTML (at most 40, each at most 300 characters) and a scope check; the export reaches the job log only, service permissions are unchanged, nothing is written, fetched or sent to a model. US$0.

**Verified from the stored copies (stored-copy SHA-256 equals the recorded evidence hash in every case).**

| Source | Stored copy | Finding |
|---|---|---|
| LCB policy PDF `395c1ea5` (evidence `ceadd22b`, hash `cc73667d…fe2e`, 34 pages) | all 34 pages exported | **Table A is page 15** (international qualifications, own title). **Table B is pages 16 to 32** (by country of education, 17 pages, header repeated on each). **Page 33 is Table C** (English proficiency by country), not Table B: the scope that S1-Build's note and the assignment give (16 to 33) is one page too long. Pages 1 to 14 and 34 hold text and other ruled tables. |
| LCB why it held | run `9d433f42`, 24 Nov | `held_unparsed: PDF page 3 "7." is outside the rules of its column`. The ruled-cell reader proves every page it is given and holds the whole document at the first text it cannot place; page 3 is a numbered list, not an entry table. |
| CQU CDN PDF `50e4031c` (evidence `fb856fec`) and `55de8e6d` (evidence `a6ec487b`) | 5 pages, hash `976f3c5e…db42`, URL `…/country-specific-academic-requirements?v=edf51706` (the second source adds `#.pdf`) | **Both sources store the same bytes** (same hash); `v=edf51706` is the edition. Page 1 is a general statement; pages 2 to 4 are the Country, Qualification, Diploma, Undergraduate table (Canada to Oman). |
| CQU official page `4ff4010f` (evidence `d5e12d94`, hash `670d076b…5ed1`) | HTML, 349,036 characters, 0 tables, title "Academic Requirements - CQUniversity" | The page is stored and its hash verified, but the existing export returns no link targets (title, h1 and table markup only), so **the page naming the CDN document is not yet proven**. The `links` return in #1677 reads it after deploy. |
| Excelsia guide PDF `a9e409bc` (evidence `3783261c`, hash `c5919a64…0b92`, 34 pages) | all 34 pages | **No academic entry table.** The only entry wording is one general sentence on page 6 (undergraduate admission is on an Australian Year 12 result or the equivalent university entrance examination in the applicant's country; postgraduate on an undergraduate degree; IELTS). Nothing is country-specific. A3 (retire the source) is supported: the stored-copy check now agrees with the database dependency check (0 matrix rows, 0 runs, 0 Layer 4, 0 active requirements). |

**Shared correction (worker v1.0.49, Pilot #1677).** `entry-pdf-scope.ts` keeps the pages that carry a PDF's academic entry tables: a scope starts at a page titled "Table <letter> - ... Academic Entry Requirements ...", continues over following pages only while they draw a table, and ends at a page titled as another table or with no ruled table. `entry_ai` uses it only when the whole-document read already holds, and only when the same proven ruled-cell reader proves the scoped pages; a read that was not held changes nothing, and a scope the reader does not prove stays held. Table A and Table B keep their own titles in the text, so the table and qualification distinction is preserved. For LCB the scope is pages 15 to 32. No new reader, queue, scheduler or paid call; AER v1 rows are not touched (a correctness fix in the shared proof path, per Decision 276).

**Not done in this change.** The LCB re-read (the run is `failed` at attempt 1 of 3) is released only after the deploy shows the scoped read proves on the stored copy (`scope_check`); whether the proven Table B then passes D-R3 is unknown until that read. D-R3 quote-capture: no stored page text has been compared with a dropped quote yet (the page-text export for the 120 to 300 character cap is the next read). General academic notes versus country requirements: Excelsia confirms the pattern (a general sentence, no country table); the consumer rule (general note resolves to `contact_provider`) is unchanged and awaits a product decision.

Spec `cf-247-s1253-entry-pdf-table-page-scope-contract.spec.mjs`; test register for s1252 and s1253 left to S1-Build.

### s1253 live read-back (S2-AER, 26 Nov 2026, about 20:10 AEDT; Pilot #1677 and Admin #1200 merged, deploy succeeded, worker v1.0.49)

- **CQU A1 evidence.** The stored official page `4ff4010f` (hash `670d076b…5ed1`, verified) links to `https://delivery-cqucontenthub.stylelabs.cloud/api/public/content/country-specific-academic-requirements` (no `?v=`). The stored document `50e4031c` and `55de8e6d` (same bytes, hash `976f3c5e…db42`, verified) is that path with `?v=edf51706`. The page names the document by path; the edition `edf51706` is on the stored source URL, not stated by the page. Page link and stored-bytes hash are therefore both read from stored evidence; A1 (S1-AER-Claude, S1-Build) can proceed on them.
- **LCB scope is right but not sufficient.** `scope_check` on the stored PDF: whole document holds at page 3 (as the 24 Nov run); scope is pages 15 to 32 (Table A p15, Table B from p16); the scoped read still holds at **page 15: "* Score is based on Advanced…" crosses a column edge** (the footnote under Table A). The shared reader fails closed there, correctly, so the scope alone does not recover LCB. Pilot #1680 (worker v1.0.50, read-only) adds the drawn rules and the per-page proof so the exact cause can be read from the stored copy before any further change; no reader change is made on a guess.

### S1-Build, 26 Nov 2026 19:45 AEDT: academic entry activation (s1274, s1261)

| Stage | Status |
|---|---|
| Built | s1274 planner hand-off, s1261 route; both rehearsed rolled back |
| Deployed | Not yet: s1274 merges first (admin record first) |
| Operationally processing | Not yet: needs an automatic plan to queue reads, then s1261 |
| Canonically admitted | Not yet |
| Published and consumer verified | Not yet |
| Fully accepted | Not yet: two unattended result-bearing cycles required |

- **Evidence:** the rolled-back rehearsal queued 22 reads (AU 20, NZ 2), locks 7,585 unchanged, route held at US$0 until s1261.
- **s1260 deviation:**
  - A1 was satisfied after execution, from stored evidence (s1253).
  - A3 (Excelsia) is unmet until its stored PDF is inspected.
- **Cron:** no retirement recommended (Master Plan status log 19:45).

### s1253 LCB reader cause and correction (S2-AER, 26 Nov 2026, about 21:15 AEDT; Pilot #1684, worker v1.0.51)

- **Cause, read from the stored LCB PDF (hash verified; Pilot #1680 added drawn rules and per-page proof to the read-only inspection).** With the table-page scope live, the scoped read still held at page 15. One page at a time, pages 16 to 31 prove; pages 15 and 32 fail. Both carry a note between the table's last rule and the page-footer band ("* Score is based on Advanced Levels where A*=6, A=5…"). The footer rules (drawn at y 55.4, 43.4 and 22.4 on every page) are joined to the table above them by the grid reader, so the note lies inside the grid and fails closed ("crosses a column edge"). The two defects are independent: page 3 (numbered list, outside the tables) and the footer note (inside the extended grid).
- **Correction (retry only).** When the scoped read still holds, the scoped pages are read once more without their running footer (the items and rules below the topmost lower-third horizontal rule drawn at the same place on every one of three or more pages). Replayed on the stored copy's exported geometry: pages 15, 16 and 32 prove; page 16 reads the same table lines before and after; the scale footnote is kept as free text; the footer text (version, approval date, page number) is the only content left out. A read that passes today never reaches this code. No migration, setting, queue, model call or spend; consumer API untouched.
- **Table and qualification distinctions.** Table A (page 15) is by international qualification (IB, Cambridge International, Edexcel, OxfordAQA) with no country; Table B (pages 16 to 32) is by country of education; Table C (page 33, English proficiency by country) is outside the scope. Each keeps its own title in the read text, so a downstream row cannot take a Table A qualification as a country or an English-test country as an academic requirement.

### s1253 live result and hand-offs (S2-AER, 26 Nov 2026, about 22:30 AEDT; worker v1.0.51 live, Pilot #1677, #1680, #1684 merged)

- **LCB live proof.** `scope_check` on the stored PDF (hash verified): whole document still holds at page 3 (as before); scope pages 15 to 32; the scoped read proves with the running footer left out: 18 tables of 4 columns (Table A page 15, 4 rows; Table B pages 16 to 32, 12 to 16 rows a page).
- **LCB re-read through the existing queue** (`admin_entry_matrix_reread`, on-demand request `9952f617`, opened first, closed with actual use: Firecrawl 0; OpenRouter balance US$91.41 to US$91.36 across all lanes in the window; this source about US$0.004). The read now passes the proof gate and reaches the model path, which splits the proven text into **36 slices**; slice 1 timed out ("Signal timed out") on each of the three attempts. That is the known call time-out against long answers (AER-FU-11, cascade deadline decision with the Platform Admin, S1-Build), not a reader or evidence defect, so no rows were produced and nothing was changed. LCB Table A and B rows therefore wait for that decision, or for a deterministic reader of the LCB layout (a PDF_TABLE matcher, pre-authorised by the Charter, but a new reader outside this assignment).
- **Excelsia (A3).** Stored-copy check now agrees with the database check: the guide has no academic entry table (one general sentence on page 6). A3 can proceed.
- **CQU (A1).** Evidence read from stored copies: the official page links to the CDN document path; both CDN sources store the same bytes (hash `976f3c5e…db42`). S1-AER-Claude and S1-Build can use it for the alias decision.
- **General academic notes versus country requirements.** Excelsia's general Year 12 sentence and CQU's page 1 statement stay as notes; nothing was converted to a country requirement, and consumer resolution is unchanged (no country equivalence manufactured).
- **Not done.** D-R3 quote-capture: no dropped quote has yet been compared with its stored page text (the stored dropped-row quotes are capped near 120 to 300 characters; the inspection can now return the page text, so this is the next read). Test register for s1252 and s1253 (S1-Build).
- **Owners.** S1-Build: AER-FU-11 time-out decision and test register. S1-AER-Claude: CQU alias (A1) and Excelsia retirement (A3) on the evidence above. Platform Admin: whether LCB gets a deterministic reader or waits for the model route.

### S1-Build, 26 Nov 2026 21:10 AEDT: 24×7 operation (s1276) and scheduled entry activation (s1261)

- **s1274:** live 20:12 AEDT.
- **s1261:** activated on the existing dispatcher, job 358. No automatic plan was due for the eligible providers until about 3 Dec (redo interval).
- **s1276:** daytime quiet hours off through their audited setting; no job, cap or limit changed.
- **Policy:** Agent Operating Model v1.28 and Master Plan §2.
- **Verification:**
  - continuous processing: the five jobs run by day, and entry items are handed out within the US$1.00 cap;
  - delivery: admissions and consumer read-back are recorded at the next checkpoint.

### S1-Build, 26 Nov 2026 21:55 AEDT: initial AI allocations (s1277, D8)

- **Change:** academic entry route US$5.00 a day; platform AI ceiling US$10 a day; Firecrawl unchanged at 1,500 credits a day.
- **Status:** rehearsed rolled back; in release.
- **Live as of 21:55:** s1261 (21:22 AEDT) and s1276.

## 26 Nov 2026 22:40 AEDT — S1-RM-Design s1176 (DR-16) slice A: PIM monitoring by jobid, every worker, lane, rule and target (Pilot #1693, recorded before merge)

- **Assignment:** SS-Programme-Control 21:34 AEDT, session takeover. Discovery from admin #1173, #1177 and #1184 reused, not repeated.
- **Defect corrected:** s1175 joined the scheduler summary to `cron.job` by job name and covered only the Data Delivery primary jobs (7). s1176 reads `cron.job_run_details` by `jobid` and covers every `cron.job` row, `pipeline.field_execution_registry` lane, `pipeline.rollup_targets` target and `pipeline.admission_rules` rule.
- **Objects:**
  - `security.data_delivery_jobs_v1()` (the jobs read);
  - columns `ops`, `ops_measured_at`, `ops_took_ms`, `ops_error` and `ops_failed_at` on `pipeline.data_delivery_job_runs`;
  - one block in `security.data_delivery_refresh_v1`;
  - `security.pim_operations_v1()` replaced with additions;
  - `public.admin_pim_jobs_v1()`;
  - five `pim.jobs_*` settings.
- **Rehearsals:** five rolled-back runs. Defects found and fixed before the PR:
  - an ambiguous column;
  - a non-inlinable classifier function (300,000 calls; replaced by an inline expression);
  - planner re-running aggregates (CTEs materialised);
  - the helper table's CHECK constraint (moved to new columns, no drop);
  - the payload size (full list moved to the admin read);
  - idle pauses read as held;
  - stalls judged on unknown periods.
- **Rehearsal result:** 312 components, active 190, idle 19, held 13, degraded 2, retired 85, shadow 1; 135 workers; read 18.4 s in the background.
- **Owner findings (evidence only, nothing changed):** `ops-cost-guard` deferred 9,349 of 9,380 (last ran 25 Nov); `coursefinder-data-quality-overview-refresh` 910 of 912 (21 Nov). S1-Build owns dispatcher capacity.
- **Guardrails:** G3 75/48, locks 7,585, cron count asserted unchanged; no job, schedule or register row changed; nothing dropped; US$0.


### s1292-AER: Academic entry study-level mapping recovery (S2-AER, 26 Nov 2026, about 22:55 AEDT; documents only; first recorded as s1280, a number S1-Build already holds for the audience rule)

Assignment from SS-Programme-Control (26 Nov 22:09). Live cohort re-read at 26 Nov 22:15 to 22:50 AEDT; stored pages read from `entry_inspect` (worker v1.0.51, run 45808386521, hash verified). Pilot main `cd5e7af`, live migration head `20261130000000`; no migration, Pilot change, setting, source or data was changed. Spend US$0; no on-demand work opened.

- **Cohort, re-measured (the 423 / 15 baseline cannot be reproduced; the grain moved).** Pending queue: 92 first reads and 17 changes. Proposed rows with no study level in pending runs, passing the confidence, quote and minimum screen: 647 rows across 33 providers (screen only, not the full rule order). The s1275 count of 423 rows across 15 providers was taken at an earlier queue state.
- **Group A, page states no level (about 590 rows; held).** Country qualification tables: UWA 194, Sydney Institute of Higher Education 58, Canberra 49, South Sydney College 40, CDU 38, Curtin University 35, UTas 27, Whitireia and WelTec 26, TAFE SA 24, CIT 16, Gateway 15, ANU 11, UNSW College 10, UniMelb 14 (two sources), and the smaller sources. The stored pages carry the qualification and score, never the course level it admits to. Reader limitation: none; the structure is read correctly. Assigning Bachelor would be inference.
- **Group B, label names a school year or country stage, not a study level (held).** "Year 10/11/12 equivalent", "ACT Year 12 equivalent", "Secondary School", "SMA 3", "Form 5", "Senior High School Year 2": 29 distinct labels checked with `security.entry_level_map_v1`; all return null. "Graduate Admission", "Year 3 Admission", "MQP", "Intensive Program" and the Murdoch "Preparation Course" labels also map to nothing; they describe an entry route, not an explicit level.
- **Group C, level already resolved; another rule holds the row.** Adelaide (S671 inherits Bachelor; `minimum_not_in_quote`) and UNBC (inherits Bachelor; 11 rows `no_minimum`). Nothing for a level mapper to do.
- **Group D, misclassified rows (reader limitation, not level).** English-test rows read as academic (CDU English scores, TasTAFE CELPIP and Cambridge, Victoria University exchange). They should not be admitted as academic entry whatever the level.
- **Outcome.** Admitted by this assignment: 0 rows, 0 providers. Consumer delivery: unchanged (no record recovered, `website_v2_course` and `website_v3_course` untouched). Protected controls: D-R3, Layer 4 decisions, 7,585 locks, G3 75/48 and the cron count were not touched.
- **Unresolved, exact reason and next action.** Groups A and B: source states no study level; next action is a provider or Platform Admin statement per provider (for example UWA's ATAR table applies to Bachelor), recorded as evidence, then the existing S671 or mapper path takes it. Group D: needs the entry-matrix prompt to separate English-test rows; routed to S1-Build and Platform Admin (AER v1 frozen, no new reader).

### S1-Build, 26 Nov 2026 23:15 AEDT: first autonomous AER cycle integrity (s1280)

| Check | Outcome |
|---|---|
| Source identity (4 courses) | Right: each row quotes its own official course page |
| Audience | Defect: "Australian Year 12 or equivalent" labelled domestic. Fixed by worker v1.0.52 and s1280 (701 rows, 671 courses). IQ-00683 |
| Extraction (121558M BSB wording) | Faithful to the page; provider page conflict. IQ-00684, Layer 4 |
| Normalisation and admission | Rows admitted as read; no lock affected |
| Consumer projection | Website v2 and v3 read back after deploy (pending) |

## 26 Nov 2026 22:50 AEDT — S1-RM-Design s1176 live and read back (Pilot #1693)

- **Deploy:** run 45811790352 succeeded; head `20261130020000`; live bodies match the file (md5 `8834aabe`, `f6d87f0b`, `7c0bb6da`).
- **Gate:** the first dry-run gate failed on a lock timeout, because the first version added columns to `pipeline.data_delivery_job_runs`, which the every-minute count holds. Moved to the new table `pipeline.pim_jobs_snapshot`; passed on the next push.
- **Background count:** the first unattended run was at 22:45:23, 15.6 s, no error, on its own run.
- **UAT:** signed in as Platform Admin, measured 1024 × 768 and 412 × 915, no sideways scroll; "0 of 136 scheduled jobs" stalled.
- **Finding:** course sync copies (website and Zoho) hold no academic entry and no course description. The v2 course read serves entry at about 1.5 s per course. Next: a rotating verified sample.

### S1-Build, 26 Nov 2026 23:45 AEDT: AER consumer read-back

- **s1280 live:**
  - 701 rows corrected; 0 domestic equivalent-route rows remain.
  - Website v3 serves the Year 12 route as a note with no domestic label.
- **New finding: an age read as a score.** Website v2 served `min_score 18` for an age (1,402 rows on 1,365 courses). s1284 is in release.


### 27 Nov 2026 09:55 AEDT: S1-Build morning check (scheduled)

- **24×7 operation.** The five former quiet-hours jobs ran after 08:00 with every run succeeded: `coverage-ai-match-prepare` 48, `fee-reader` 97, `scholarship-ai-extract` 97, `course-description-machine` 42 and `provider-description-read` 20. Model calls since 08:00 (counts and outcomes are in the AI invocation log):
  - course entry: 1 (answered);
  - scholarship extraction: 2;
  - scholarship eligibility: 6;
  - Portal search embedding: 12.

  Portal search latency was not measured.
- **AER unattended cycles since run 593 (22:13).**
  - The hourly runs from 23:13 to 07:13 and at 09:13 read 0 courses.
  - The 08:13 run read 1 course: 115246M, through the stored page and gpt-4.1-mini ($0.0012). It admitted 4 rows (prior qualification, two general notes, interview), and all are served on Website v2.
  - One row is an application instruction classed as a prior qualification ("Applicants should submit certified transcripts..."). S2-AER should reclassify it to `general_note`. If it is not reclassified, D9 `course_general` would serve it, so the S2-AER fix should come first.
  - The eligible backlog (`security.aer_schedule_courses_v1(100000, true)`, rolled back) is 0 courses: the eligible pool is exhausted.
  - Layer 4 waiting is 859.
- **Spend today (AEDT).** AI US$0.78 in total, of which academic entry is US$0.0012. Both are within the US$5 entry cap and the US$10 platform ceiling (D8).
- **s1274 planner hand-off.** All 34 enrich plans since 22:13 were requested by a person. 0 automatic plans have an `academic_entry` step with entry reads; the step shows only a page revisit (`est_credits` 1). The automatic planner stays held by the redo interval (about 3 Dec), so the second result-bearing cycle depends on new eligible courses.


### s1293: Academic entry classification and Feedback 3 to 6 recovery (S2-AER, 27 Nov 2026, about 10:55 AEDT; recorded before merge)

Assignment from SS-Programme-Control (27 Nov 09:57 AEDT). Live reads 27 Nov 10:00 to 10:50 AEDT. Pilot main `cd5e7af`-line; live and main migration head `20261130091500`; open claim `20261130103000` (#1709, S1-Build, held). This change takes `20261130110000` (S2 slot, above every head and claim). Spend US$0; no on-demand work opened; no setting, source or lock changed.

- **Priority 1, 115246M (Certificate III in Individual Support, Job Training Institute).**
  - Trace: row `22128bf6`, active `prior_qualification`, audience all, description "Applicants should submit certified transcripts of all academic achievements, including secondary school education", quote "Certified transcripts of all academic achievements, including secondary school education". Layer 4 item `a7a8e264` (approved 26 Nov 21:18 UTC, one decision), reader `enrich_ai`, prompt `course-entry-v1`, model gpt-4.1-mini, worker v1.0.53. Stored evidence `3b1a392d` (`layer2/AU/coverage/78527141…/adef9b87…/9127385b….html.gz`, content hash `9127385b5e3fb5b9…`, captured 26 Nov 20:25 UTC, page text `53d8fe60…`). The stored page text could not be downloaded from this session, so the surrounding page wording was not re-read; the row's own description and quote name no qualification an applicant must hold.
  - Correction (Pilot s1293, worker v1.0.54 and migration `20261130110000`): an active `prior_qualification` or `minimum_grade` row with no score and no grade whose **description** is a document-submission instruction and names no qualification level (Year 10 to 12, certificate III or IV, diploma, bachelor, degree, AQF, honours, master, doctorate, equivalent) becomes `general_note`; provenance keeps the earlier kind; every id is logged; locked courses are skipped; one integration issue. The live predicate matches exactly two rows: 115246M `22128bf6` (`prior_qualification`) and 112659C `b8e01ffa` ("Certified copies of three most recent school reports", `minimum_grade`). Seven rows whose quote tells how to apply but whose description states a qualification (114707F, 114708E, 114709D, 092440C, 103162C, 113749D, 0100425) are left as read; "Submit a copy of minimum Year 12 or equivalent" (113935B, 119104D) names a level and is left as read.
  - D9 (#1709): `course_general` takes `minimum_grade` and `prior_qualification` rows for international or all students with no country; its safeguards exclude duration, pathway and route wording only, so this wording would have been served as a requirement. After this correction both rows are `general_note` and the D9 kind filter excludes them. Re-verified after merge in the next entry.
- **Priority 2, La Trobe Bachelor of Nursing 113570D: held, exact reason.** No entry row, no Layer 4 item, no entry read ever queued. The page `https://www.latrobe.edu.au/courses/bachelor-of-nursing` is bound by `exact_title` (h1 equals the title, host `latrobe.edu.au`, no other course bound to the URL). Entry reads allow `cricos_code`, `adapter_code` and `manual` for Australia. The own-site title route (`aer.title_identity_on` 1) needs a score margin of 0.1 and this binding scores 1.000 against a runner-up of 1.000, so `security.aer_title_identity_courses_v1()` excludes it and `aer_course_population_v1()` does not list it. One of six La Trobe exact-title bindings tied this way (107440J Master of Nursing is another); none holds rows. The page adapter records `student_type: domestic`, so the stored copy may be the domestic view. Not bypassed. Next action: identity re-proof of the page (CRICOS code or adapter code on an international view), or a Platform Admin manual binding. The other six La Trobe nursing courses: 020935J, 113571C, 113572B and 117009H carry manual locks (left alone; 020935J's earlier reads also failed on an OpenRouter weekly key limit and were superseded); 113662M's page states no entry requirement ("the page does not state it"); 024379M holds 3 active rows.
- **Priority 3, Adelaide College Diploma in Business Studies: no match, not inferred.** No course titled "Diploma in Business Studies" exists under Murdoch College, The University of Adelaide College, Kaplan International College Adelaide (provider `1b8db821`); it holds "Diploma of Business" 069094G and 113489H (both on `murdochcollege.edu.au/diploma-of-business`). Adelaide University holds 115770B "Diploma in Business Studies" (page on `adelaideuni.edu.au`) and 115659A "Associate Degree in Business Studies" (page on `adelaide.edu.au`), 0 active rows each, page identity basis not recorded. The University of Adelaide holds an inactive "Diploma in Business" 099358G. The three titles and codes are distinct catalogue records; nothing links them. Next action: the CRICOS register entry for 115770B and 115659A (registered provider and course name) against the reported course, then link or leave separate by decision.
- **Backlog.** Nothing further was admitted in this entry. The Feedback 3 to 6 cohort list is not named in the records read (S1-Build's "seven courses move to course_general" is recorded without codes); the academic-entry backlog continues with S1-Build's scheduled reads, and the eligible pool was 0 at 09:55.

#### s1293 live and read back (S2-AER, 27 Nov 2026, about 11:30 AEDT; Pilot #1715 `197fadf8`, Admin #1267)

- **Deployed.** Pilot #1715 merged; `Deploy on merge` run 45911082014 succeeded (worker v1.0.54 and migration `20261130110000`); live migration head `20261130110000`.
- **Corrected rows (read live).** 115246M `22128bf6`: `prior_qualification` to `general_note`, still active, audience all. 112659C `b8e01ffa`: `minimum_grade` to `general_note`, still active, audience all. Provenance keeps the earlier kind; 1 `admin_control_events` row (`document_instruction_not_requirement`) lists both ids; 1 integration issue (`aer:kind:document-instruction-read-as-requirement`). No other row changed.
- **D9.** The D9 `course_general` source set (active `minimum_grade` or `prior_qualification`, international or all, no country) holds 0 rows for 115246M and 0 for the 112659C wording, so #1709 cannot promote them. The sibling wordings that name a level or a qualification stay as read.
- **Consumer read (shared payload `security.entry_course_payload_v1`, India).** 115246M gives no `prerequisites` entry for the transcripts sentence; it appears once in `requirements_note` with the other two general notes; `selection_tasks` still holds the international application form; resolution `contact_provider` (no country row, D9 not live). Website v2, v3 and Zoho v2 take this payload.
- **Guardrails.** Consumer API 75 functions / 48 relations, no drift; locks 7,585; active cron 137; nothing dropped; US$0.

### 27 Nov 2026 10:50 AEDT: operational learning acceptance (s1292, AOM v1.29, Master Plan §6.8)

| Proof | Production evidence (live, read-only) |
|---|---|
| 1. Successful and unsuccessful knowledge retained | 23 patterns in `pipeline.ops_remedy_knowledge` (6 automatic). The 8 new lessons hold 14 outcomes (9 successful, 5 failed), recorded through `security.ops_learning_record_v1` once per evidence signature. Visible at Platform health > Technical details > Recovery knowledge (`public.admin_ops_learning_v1`) |
| 2. Known recurring issue detected, recovered and independently verified | IQ-00598 (`job_failed:layer4-interventions`), recurrences 18, 19, 21 and 27 Nov. Controller runs 1952, 2206, 2444 and 2725, all `confirm_condition_cleared` verified with no agent. Independent: `layer4-interventions` ran 3 of 3 successfully after 08:54, against 2 failures in 48 runs the 24 hours before |
| 3. Ineffective unchanged attempt prevented | `security.ops_learning_retry_check_v1` refuses the unchanged 115246M read ("the same evidence already failed"). `record_capacity_profile` was refused 243 times in 7 days. Blocks active: `fee_integrity_recheck` (prevented 1) and `layer4_admission_recheck` (prevented 1) |
| 4. Protected exception held | `consumer_projection:frozen_correction_needs_notice` is refused ("needs admin authority"), so D9 (#1709) stays held. Jobs 87, 108 and 378 remain inactive (D11) |
| 5. Unaffected production | 0 failed scheduled runs out of 1,922 in the hour; rollup deferrals 20 of 306; Data Delivery current at 10:21; main Deployed UAT passed (45911343052); G3 75/48; locks 7,585; active cron 137; AI today US$0.79, of which s1292 US$0 |

Open: the AER selector and the other lanes do not yet call the retry check before a repeat. Only provider description and the controller gate consult it today. The next slice is for the lane owners: S2-AER for the AER selector.


### s1296: AER selector, recovery signature and domestic-statistic drops (S2-AER, 27 Nov 2026, about 13:00 AEDT; recorded before merge; Pilot branch `s2-aer-u`, migration `20261130123000`, worker v1.0.55)

Assignment from SS-Programme-Control (27 Nov 11:27 AEDT). S2-Build keeps the shared reader lifecycle; S1-Build keeps international source integrity. Number note: the study-level record first filed here as s1292 is now `s1292-AER` (S1-Build holds s1292 for operational learning; s1295 is Pilot's PIM DR19 migration).

- **Findings (live, read-only).** The AI route was off 19 to 26 Nov (protected control). The flat 30-day timer then blocked every course touched in that window or superseded by the deterministic re-read, so the eligible AER pool read near empty. Genuine unread work is about 1,000 to 1,300 courses (page unproven at the first read, or D-R2 not read). 2,283 "page does not state it" reads are correctly held until the copy changes.
- **E13 reconciled.** 120 reads made, 306 asks refused because the AI route was off (protected limit), 172 asks already handled, about 400 genuine incomplete reads. The 478 asks that never reached a read no longer count against the pilot total.
- **Change.** `security.aer_first_read_state_v1` classifies every course (never read, not a read, no result, no row, page limit, row limit, incomplete read) and gives eligibility and a signature (bound copy and reader revision). `aer_schedule_courses_v1` reads from it, so an unchanged copy is not read again, the deterministic outcome is respected, and a technical failure retries after `aer.schedule_technical_retry_hours`. The tick is clamped to `aer.schedule_paid_share` of the paid cap. Outcomes go to the existing `ops_remedy_knowledge` (`aer_first_read:*`). Eleven G2 settings. No cron, lock, consumer object or setting value changed; G3 75/48 held.
- **Worker v1.0.55.** A dropped domestic cut-off statistic (median, lowest, highest, cut-off, entry score range, with no requirement word and no international, English test, visa or "or equivalent" wording) is recorded as `domestic_route_statistic` and no longer holds the read. Live measure: 124 of 1,331 incomplete reads drop only such statistics; 79 more are mixed.
- **Evidence for S2-Build (item 6).** The remaining 1,331 incomplete courses (264 providers, most at UQ, UTS, UNSW, RMIT, Flinders) drop quotes that are not contiguous on the page: heading or label prefixes, stitched table cells, ellipsis joins, paraphrases. A reader that keeps one contiguous on-page quote per requirement is needed. 198 more are shared-page cases and 294 corrected reads were refused as still incomplete.
- **Still open.** Feedback 3 to 6 course list, La Trobe 113570D (protected identity tie), Adelaide CRICOS check. Two unattended result-bearing cycles and consumer read-back follow the merge and are recorded in the next entry.

### s1301: Feedback-first AU academic entry recovery (S1-AER-Claude, 27 Nov 2026, 13:35 AEDT)

Decision record: `docs/platform/p0-aer-activation/2026-11-27-s1301-feedback-first-au-aer-recovery.md`. US$0 AI and Firecrawl; no reader run, no setting, lock, source or Layer 4 change.

- **Reported courses.** All 12 reported course records (13 with the two Swinburne and three VU codes) already deliver an academic entry requirement for India; Nepal on 10 of 13. The three Nepal "contact provider" cases (Swinburne 063366D, VU 092944A, VU 105139H) are correct because no Nepal row is published and none is inferred. No re-read is needed; any Portal gap is projection (D9).
- **Real gaps.** Newcastle 327, CDU 64, Deakin 62, Victoria University 12, MIT 9 courses with no row, matrix or pending item. Cause is mostly an unproven course page (S1-Build source integrity, S2-AER identity), not a reader fault. The other twelve cohort providers have none.
- **Feedback register.** Nine academic-entry rows updated with this evidence (six to Retest required).
- **Carried forward.** A1, A3 and the Le Cordon Bleu scope wait on the read-only `entry_inspect` addition; A2 prepared for S1-Build; A4 untouched.

#### s1296 live and cycle 1 read back (S2-AER, 27 Nov 2026, about 13:35 AEDT; Pilot #1719 `88af5e7f`, Admin #1279; follow-up s1296b recorded before merge, migration `20261130153000`)

- **Live after #1719:** migration `20261130123000` applied; 11 settings and 2 patterns (`aer_first_read:*`) present; G3 75/48, locks 7,585, active cron 136, none added. The selector now classifies 5,148 courses without an entry row and offers 1,496 across 291 providers (was 0): 1,262 not a read, 164 incomplete reads that dropped only domestic statistics, 38 no result after a copy change, 25 no row after a reader change, 7 row limit. 2,038 unchanged "page does not state it" reads, 1,246 incomplete reads that need a new reader structure, 247 no-row reads and 77 row-limit reads stay held, by design.
- **Cycle 1 (run 611, 13:13 AEDT):** 800 first reads enqueued inside the paid clamp (cap US$5.00, lane share 0.6, room 1,123). Ten minutes later: 64 courses with new entry rows (57 active, 231 proposed, 5 inactive rows), cost about US$0.57. 627 of the 800 were skipped at once as "no proven course page (E16)" (US$0, not an AI read).
- **Finding and fix (s1296b):** a course with no page bound to it cannot be read, so a 24-hour timer re-offers it for nothing. The selector now holds such a course until a page is bound (`aer.no_page_pattern`); those courses are course-link work for S1-Build and S2-CF, not a reading problem.

#### s1296 two unattended cycles proved (S2-AER, 27 Nov 2026, about 14:30 AEDT; Pilot #1719 `88af5e7f`, #1727, #1728; Admin #1279, #1291)

- **Number clash:** s1296b merged as `20261130153000` (#1727), which S1-Data-Gaps s1306 had already applied under another name. The deploy refused it and nothing ran. #1728 renamed the unapplied file to `20261130163000` (label `main-green-fix`); s1296b is live (`aer.no_page_pattern` present; Deploy on merge and Deployed UAT passed).
- **Selector after s1296b:** 5,062 courses classified, 696 offered (was 0 before s1296); 722 no-page courses wait for a bound page; 2,052 unchanged "page does not state it" reads and 1,246 incomplete reads that need a new reader structure stay held.
- **Cycle 1 (run 611, 13:13 AEDT):** 800 first reads (627 skipped at once as no proven page, US$0). **Cycle 2 (run 612, 14:13 AEDT):** 573 genuine first reads inside the paid clamp (cap US$5.00, lane share 0.6, room 799).
- **Canonical gain (read at about 14:28 AEDT):** 314 courses across 35 providers hold new entry rows from the two cycles: 459 active, 863 proposed (to Layer 4 under the existing gate), 12 inactive. Cost US$2.14 of the US$5.00 day. `entry_resolve_v3` serves the new rows (checked on two courses, country IN). Cycle 2 reads were still finishing (102 in AI) at the time of the count.
- **Guardrails held:** G3 75/48, manual locks 7,585, active cron 136, no manual or Layer 4 decision made by the machine, D9 not touched.
- **Exception to review (item 7, audience):** some machine-admitted international-audience rows quote an Australian qualification ("Australian Year 12", NSW HSC). The audience label on those rows needs a person's check; recorded for S1-Build's audience validation, not changed here.

### s1312: AER-FU-12 source recovery, QUT and Newcastle (S1-AER-Claude, 27 Nov 2026, 16:15 AEDT)

Record: `docs/platform/p0-aer-activation/2026-11-27-s1312-aer-fu-12-source-recovery.md`. US$0; no source, setting, configuration or retry.

- **QUT PDFs.** The stored copies are 1 KB scraper text because QUT refuses the direct PDF read; a plain read from this session is refused too, so original bytes are not obtainable by the authorised route and no bypass is used. Needs Platform Admin to supply the PDFs (with an entry-matrix upload route) or QUT permission.
- **Correction.** QUT does hold entry rows: 172 of 294 courses active, India resolves on 59 of 60 sampled. The PDFs would add a provider-level fallback for the rest.
- **Newcastle.** The prospectus (13.8 MB) stops the worker; the engine has no page-range input, so a bounded section read needs a freeze exception. The agent page has no table; the one by-country table found belongs to Newcastle International College, a separate entity, not to be attached to University courses. 327 of 457 courses hold nothing, mainly for unproven course pages (S1-Build).
- **Requalification.** None: evidence unchanged. Acceptance not met.

### AER-FU-12 (S2-AER, 27 Nov 2026, about 15:50 AEDT; SS-Programme-Control 15:41; development freeze kept): RMIT re-reads, QUT and Newcastle admission

No Pilot change, setting or re-read was made (US$0). Read-only live checks only.

- **RMIT, configuration `37a63107`, 35 runs (19 failed, 16 queued; 9 failed and 11 queued still in the last 40 minutes; 0 new matrix rows).**
  - **Recoverable, time limits (21):** 13 hit the worker time budget (4 failed, 9 queued) and 8 failed on model "Signal timed out" or no answer (slice 3, 5, 7 of 16). Cause: 16 slices at `entry.matrix_slice_concurrency` 6 take three waves, and the first model call may use 40 s of the 110 s worker budget. The slice size is already at its minimum (4,000 characters). Retrying on the same setting repeats the failure, so no re-read was made.
  - **Unblock (Platform Admin, no code):** on Settings set `entry.matrix_slice_concurrency` from 6 to 12 (its existing upper bound; 16 slices then fit two waves), with a reason; then run the existing `admin_entry_matrix_reread` on the 19 failed sources. The setting is global to entry-matrix reads, so watch the first run for provider rate limits.
  - **Recoverable extraction, needs a code change (7), held by the freeze:** 4 `held_incomplete` (column "Diploma of Upper Secondary School" left out) and 3 `held_unparsed` ("not a country table": page heading "Country or region" names no country). Needs a preprocessing change to the country-table detector and the column gate; routed to S2-Build under a freeze exception.
  - **Genuine Layer 4 decisions: none** among the 35. The 380 active RMIT matrix rows are unchanged.
- **QUT.** 172 of 294 courses hold active rows (280 with the proposed ones). The two by-country PDFs stay blocked at source (s1312). **Genuine Layer 4:** 108 courses hold 246 proposed rows, 244 of them beside active rows; the machine rule holds them ("active_rows_exist", uncovered drops), so a person decides whether to add them. About 30 courses have no row and no changed copy (read, no result), so they are not read again.
- **Newcastle.** 89 of 457 courses hold active rows. **All 41 proposed rows are scholarship offers** ("base ATAR of 95+... $5,000 scholarship"), not academic requirements, so the held status is right. The machine cannot reject; a scholarship-wording class in the reader is a code change (freeze exception), or a person rejects them in Layer 4. Most of the other courses have no proven page (course-link work). No new rows today.
- **Actual new rows today (since 13:00 AEDT, selector cycles, active):** QUT 196 rows on 39 courses; RMIT 190 on 42 (course level, not matrix); Newcastle 0. `entry_resolve_v3` serves them (a QUT course returned 5 rows and an RMIT course 7, country IN).
- **Exception noted:** about 16 of 513 machine-admitted rows today (QUT 9, RMIT 3, UNE 2, SCU 1, UTS 1) contain "must submit/provide" wording; most are real requirements (work experience with a CV). Not changed.

### Recover already-extracted AER requirements (S2-AER, 27 Nov 2026, about 16:40 AEDT; SS-Programme-Control 16:08; development freeze kept)

Record only. No Pilot change, setting, re-read or admission (US$0). No canonical row was admitted: no existing mechanism recovers these records without weakening a rule.

- **How D-R3 works (read from the live functions).** `entry_matrix_gate_v1` holds a read until every dropped published row is covered by an admitted row (the first 40 letters of the dropped quote appear in an admitted quote). `entry_matrix_review_apply_v1` refuses even a person's Approve while the gate fails. The only recovery the gate names is a corrected read. `entry.matrix_gate_ignore_reasons` could skip a reason, but that would weaken completeness, so it was not touched.
- **Why a re-read is not offered.** ALG, CIT, CDU and Curtin each already have 2 to 4 earlier reads, all on worker v1.0.39 and the same model; the only matrix reader changes since are CQU column readers (s1105, s1106). A re-read repeats an unchanged failed read.
- **ALG (110 rows waiting, 2 dropped):** India, `grade_not_in_quote` (the grade "4 passes" lies beyond the quote's end); Cuba, `quote_not_on_page` (quote cut mid-text, accented text). **CIT (34 waiting, 5 dropped):** Kenya, Myanmar, Malaysia, Nigeria `grade_not_in_quote` (the model joined two printed grades); Ghana `quote_not_on_page`. **CDU (50 waiting, 18 dropped):** 17 `band_not_in_quote`, 1 `grade_not_in_quote`; each quote is printed whole and carries its grade, so the model's band or grade text is what fails.
- **Platform-wide:** 109 matrix items pending, 88 stopped by D-R3. 7 are stopped only by grade or band text (CDU 18 rows, Macquarie 4, UTS 3, Laidlaw 3, Christchurch 3, Sydney Institute of Higher Education 2, Charles Sturt 2); 24 include `quote_not_on_page` (ALG and CIT among them).
- **Curtin (35 rows) and UWA (194 rows):** complete reads (0 dropped); every row held as `level_unmapped`. The level is inherited only from a heading or file name that prints it (`aer.matrix_level_inherit_on`); neither source URL or title prints one, and an unstated level is never inferred. A person can decide these in Layer 4 today.
- **Smallest freeze exceptions (S2-Build):**
  1. `entry.ts` lines 355 and 365: when the quote is verified on the page but the model's grade or band text is not in it, keep the row, set that text null and record it in `conditions` (the same treatment as `valueRemoved` and `reading.entry_value_null_on`), behind a new setting. The quote proof is unchanged. This clears the 7 runs and ALG India and CIT's four grade rows.
  2. `quote_not_on_page` (ALG Cuba, CIT Ghana and the other 22): needs a read-only comparison of the quote with the stored page text (accents, line breaks, the 120-character cut) before any change; S1-AER-Claude's `entry_inspect` can do it.
  3. Curtin and UWA: a person confirms in Layer 4, or a source-level printed-level reading is added if the stored PDF or page prints one.
- **Consumer:** nothing changed, so there is nothing new to read back.

## s1313 — AU AER review queue and parked exceptions (S1-AER-Claude, 27 Nov 2026 16:50 AEDT)
- QUT, Newcastle, UniSQ and ECU parked as unsupported; ranked Layer 4 queue and owner routes in docs/platform/p0-aer-activation/2026-11-27-s1313-au-aer-review-queue-and-parked-exceptions.md. No data change; consumer unchanged.

### P0 Australian production data delivery (S2-AER, 27 Nov 2026, about 16:50 AEDT; SS-Programme-Control 16:29)

No Pilot change, per-university CI or unchanged read. Known blockers (RMIT matrix time limits, D-R3 drops, Curtin and UWA levels, QUT PDFs) were not re-investigated; they are in the entries above.

- **Actual canonical gains since 13:00 AEDT (entry requirements, existing readers):** 1,567 active course rows on 394 courses across 35 providers, plus 121 proposed rows to Layer 4 (cycles 611 and 612 and the $0 deterministic and AI readers). No matrix rows admitted.
- **Selector now:** 4,755 courses without an entry row; 123 eligible (all Australian: UNSW 43, UTS 31, Flinders 24, UQ 9, Monash 9, UWA 7). Everything else is held for an unchanged copy, an unchanged reader, a bound page (course-link work) or a Layer 4 decision.
- **HELD:BUDGET_GATE (Charter d):** run 614 (16:13 AEDT) refused: US$5.85 spent today across all lanes against the US$5.00 cap (UTC day, resets 11:00 AEDT 28 Nov). Entry matrices took US$3.63 of it (80 calls), mostly RMIT re-reads that failed on model and worker time limits and admitted 0 rows; enrich fields took US$2.87; entry reading under the selector US$2.61. The 123 eligible courses read in the first tick after the reset. The RMIT cost is the reason the unblock request (`entry.matrix_slice_concurrency` 6 to 12, in the AER-FU-12 entry) matters: until it is applied each retry spends the cap for no row.
- **Human decisions prepared:** Curtin 35 and UWA 194 complete matrix rows (level not printed) and QUT's 108 courses with 246 extra proposed rows are Layer 4 items with their evidence attached; Newcastle's 41 scholarship-wording rows are Reject candidates.
- **Verification:** `website_v3_course` serves the new entry rows (ANU course `course:cricos:00120c:119048g`, country IN: `entry`, `entry_requirements` and `english_requirements` keys, the quoted GPA 4.5/7.0 row). `zoho_edge_course_lookup_v1` (frozen v2) carries no entry field, so Zoho Creator is unchanged by design.

### AUT E16 identity hold: diagnosis and reusable defect (S2-AER, 27 Nov 2026, about 19:40 AEDT; SS-Programme-Control 19:06)

Read-only. No setting, alias, binding, admission, read or spend was changed. AUT is parked and independent work continues.

- **Courses:** Australian University of Theology (provider `provider:cricos:02650e`, website actheology.edu.au), Master of Divinity, two active courses with one title: 054688E (`ba9b7130-6e32-4c04-9555-d4261109b027`) and 083099G (`91a27e8c-e935-469c-a99c-aeeca8d662d8`).
- **Stored evidence verified (storage metadata):** both snapshots are on the provider's own host, `https://www.actheology.edu.au/course/MDIV20/` (the `aut.edu.au/course/MDIV20/` address only appears in the course links and `course_url`). Evidence 9552a256 (054688E) and 5d8dcfee (083099G) carry the same sha256 `31728dce…a4d4e0` as their object names (13,273 bytes, same etag); the two page-text objects share hash `98155a76…224e` (7,323 bytes, same etag). Both pages are already `bound`, read, `identity_basis = cricos_code`, h1 "Master of Divinity", page title "Course – Australian University of Theology". Not verified: the printed English and Chinese CRICOS codes on the page. The page text cannot be read from the AER session, so that quote check stays open.
- **Exact failing sub-check:** not the shared-course test and not the official-host test. `security.course_page_check_v1` returns `rule = name` ("the page address and title do not name this programme"). `shared` needs at least 2 other courses on the page (1 here), the host is the provider's own, and `proved` is true. The check judges the page title ahead of the h1, so the generic site title plus the address segment `mdiv20` share no word stem with "Master of Divinity". Called with the page's own h1 and its proof, both courses pass (`identity_proof`).
- **Existing mechanism cannot express it:** `binding.identity_exceptions` is empty and supports only `shared_page` and `nested_award`, neither of which touches the name rule. `binding.provider_host_aliases` is not the cause. `aer_v2_identity_settle_v1` settles only `ambiguous` pages (these are `bound`) and also needs a heading that names the course. Adding an own-code identifier "MDIV20" would pass both courses and so infer 083099G's eligibility, and it is a manual catalogue edit. Nothing was changed.
- **054688E alone not proved:** a person's or S1-Build's scoped decision is needed, and paid reads are held by `HELD:BUDGET_GATE` until 11:00 AEDT 28 Nov in any case.
- **Reusable defect (for S1-Build, freeze exception):** E16's name rule uses `coalesce(page_title, h1)`, so a generic site title refuses pages whose h1 names the programme. Measured live: 217 of 1,096 E16 "no proven course page" refusals are the name rule; for 101 courses at 57 providers the check passes when given the page's own h1 and proof. Smallest governed fix: judge the name rule on the page title **or** the h1, with every other E16 rule unchanged, and keep the CRICOS-code-in-page-text proof as the tie-break for same-title courses sharing a page (054688E and 083099G). Needs a guard test with both AUT courses and a refusal case.
- **Reuse:** Avondale 059850D and the MIT rows already hold 10 to 13 rows each from earlier cycles; the remaining ones are D-R3 incomplete reads (freeze exceptions E1 to E3), not E16, so nothing was re-read. UQ110742B stays awaiting its pending Layer 4 item `e72a41dc-5c95-4296-8caf-e20bbb40b406` (domestic ATAR rows); no duplicate item was created and the four international Foundation observations were not mixed into it.

### RMIT FB-6.C10-01 (077512F) correction pack and admission processing findings (S2-AER, 28 Nov 2026, about 07:50 AEDT; SS-Programme-Control 07:05)

Read-only. No row, setting or read was changed. Every write route to an entry row (`public.admin_aer` add, update, withdraw, quarantine; `security.course_entry_review_apply_v1`; `security.course_entry_correction_v1`; `security.aer_machine_withdraw_v1`) requires a signed-in person with an assigned role or an actor id. The AER session has neither, and a raw update would bypass the audit trail, so the correction is prepared for a person to apply rather than forced.

- **Course:** RMIT Master of Marketing MC197 (`e0016887-5587-4153-80b8-971c012c7e72`), stored page evidence e1070b50-a6ac-4abc-a289-1c53c6456054 (recorded hash 1de4ff8e…20af9, original not byte-verified, per the DOT note). Source for the audience reading: DOT file StudySearch-AU-09-RMIT-PRECHECK_PENDING.md (rendered lines 504–550); the stored page text could not be read from the AER session.
- **Correction pack (apply with `admin_aer` add then withdraw, reason "FB-6.C10-01 audience per DOT 28 Nov"):**
  1. `e12fc2fe` GPA 2.7/4 "to be considered for a CSP": active, audience all. Add the same quote and description with audience domestic, then withdraw the old row. It is a Commonwealth-supported-place minimum, not an international one.
  2. `59a41640` work experience 2 years (any discipline + work, 1.5-year route): active, audience all. DOT places this route in the earlier (domestic) section, not the international one. Re-add as domestic, withdraw the all-audience row.
  3. `66c49515` 1.5-year route, quote runs on into the "OR any discipline + work" alternative: active, audience all. Withdraw; add the international 1.5-year row (recognised bachelor's equivalent or higher in business or a related discipline, OR RMIT Graduate Certificate in Marketing) from the current page, and the work-experience alternative as domestic.
  4. Keep: `dce8f37a` (international 2-year route, any discipline), `7481a7fd` (qualification within ten years), `e2d8ae8b` (Graduate Certificate in Marketing, 48 credit points) and `4dd84946` (credit-only scope, review only).
- **Same class, 14 active rows at 5 providers (audience all, quote about a Commonwealth supported place):** RMIT 10 (`38214e88`, `48139017`, `e12fc2fe`, `e209238d`, `ac6521b0`, `0d847cc4`, `c2fae58b`, `d6f6f294`, `a5e5a15d`, `1cdf41db`), CDU `f96bb734`, UQ `da70dbe9`, Canberra `110f2767`, UTS `777c0d0a`. Each needs the same audience correction by a person. The smallest governed fix for S1-Build is to treat a Commonwealth supported place (CSP) statement as domestic in the worker's audience normaliser (like `domestic_route_statistic`), with a guard test. Needs a freeze exception.
- **Admission processing (for S1-Build):** 956 course first-read Layer 4 items are pending; 760 of them are for courses that already hold active rows, 379 also hold proposed rows (831 proposed rows, 669 older than 24 hours, 377 older than 7 days). Sampling the oldest 200 with `aer_machine_check_v1`: 140 `active_rows_exist`, 41 `no_bound_page`, 11 `all_rows_held`, 8 `identity_not_admitted`, none eligible, so the held rows are person decisions by rule, not a machine miss. The real processing defect is timeouts: `admission-rule-runner` (a, b, c) failed on `aer_partial_admit_v1` line 167 and the named-requirement CTE, `aer-reconcile` on `coverage_identity_allowed`, and `aer-scheduled-read` on `course_entry_shared_page_v1`, 2 to 4 of about 1,440 runs each in 24 hours, on statement timeout. S1-Build should index or bound those reads.
- **Cycles:** runs 625 to 629 read nothing because today's paid cap is used (US$7.48 across all lanes, UTC day 27 Nov). The 11:13 and 12:13 AEDT cycles are the first with room; their result is recorded by a follow-up at 12:35 AEDT. AUT stays parked on the E16 name-rule fix; D9 consumer communication and every admission control are unchanged.

### Deakin 114205F correction pack and shared-chat coordination (S2-AER, 28 Nov 2026, about 09:40 AEDT; instruction CHAT-INIT-20261128)

Read-only; nothing applied (every entry-row write route needs a signed-in person with an assigned role).

- **Coordination:** the S2-AER permanent Drive document (M3 / Chats, `1YA0avvT…`) now holds the acknowledgement of CHAT-INIT-20261128, the latest outcome and the chronological history; read back verified. The Drive mirror of these Admin records is the document itself, not a separate file.
- **Deakin Master of Health Management 114205F (FB-6.C13-01), live rows verified:** `a41dec2a` (minimum_grade, audience all, min_entry_score 70, "Course Director approval and a WAM of 70 or more" for a choice within the course) and `c0ea0653` (minimum_grade, min_entry_score 60, a unit-level WAM for Minor Research Project A) are not admission minimums, yet the consumer shows them as the entry minimum. Correction pack for a person: withdraw both with `admin_aer` (lifecycle withdraw, reason "FB-6.C13-01: WAM is a specialisation or unit condition, not an admission minimum"). The four admission routes stay: `1e07dedc` related-discipline bachelor, `e6b8b074` any-discipline bachelor, `903a8d79` two years of work experience, `c54b6026` interview and merit. Grouping them into routes is a consumer or schema change, not an AER row edit (S1-Build, not done).
- **Same class (for S1-Build's worker rule):** 263 active rows with a min_entry_score on a quote naming a Weighted Average Mark, 200 courses at 17 providers. Not all are wrong (some are genuine WAM admission minimums), so each needs the quote's context judged; the proposed worker rule is to keep a WAM that sits in an admission sentence and move a unit or specialisation WAM to a note.

### PC-20261128-0931-S2-AER: signed-in route for the RMIT and Deakin packs, matrix proposed-row classification, DOT AU12/AU13 state (S2-AER, 28 Nov 2026, about 10:25 AEDT)

Read-only. Acknowledged in the S2-AER Drive document at 09:55 AEDT. No row changed, no spend, no Firecrawl or container run.

- **Actionable route for S1-Build (existing, no new code):** Catalogue › Entry requirements › Course entry requirements, role **Curator (rank 3) or above**, signed in (`public.admin_aer`; platform guide task "Correct, add, withdraw or quarantine an entry requirement row"). The course Add accepts requirement kind, audience (international, domestic or all), country, quote, source URL and the stored copy, a printed value must appear in the quote, and Withdraw needs a reason. A proposed row is decided in Layer 4, never here. Audience cannot be edited in place, so a correction is Add the row with the right audience, then Withdraw the old one.
- **Exact RMIT 077512F (course `e0016887…`, DOT file AU-09, stored copy e1070b50, hash unverified per DOT):** (1) Add domestic, kind minimum_grade, value 2.7, scale GPA, quote "The minimum GPA to be considered for a CSP is 2.7 out of 4.0.", then Withdraw `e12fc2fe`. (2) Add `59a41640`'s quote as audience domestic, then Withdraw `59a41640`. (3) Withdraw `66c49515` and Add the international 1.5-year route (business or related bachelor, or RMIT Graduate Certificate in Marketing) from the current page. Keep `dce8f37a`, `7481a7fd`, `e2d8ae8b`, `4dd84946`.
- **Exact Deakin 114205F (FB-6.C13-01):** Withdraw `a41dec2a` and `c0ea0653` (a course-option WAM and a unit WAM; quotes verified live). Keep `1e07dedc`, `e6b8b074`, `903a8d79`, `c54b6026`.
- **No broad rule:** the other 13 CSP rows and the 263 WAM-quote rows are not authorised by this pack. Each needs its own quote context judged (admission sentence versus option or unit) and the audience of its section proved; only the rows named above are proved. The E16 h1 fallback (101 courses, 57 providers) stays a sample qualification, not an approval.
- **Matrix proposed rows, live 10:05 AEDT, all 4,080 classified by the existing check on each pending item:** change of an admitted table 1,767 rows / 38 items; incomplete gate (partial and incomplete) 1,019 / 42; host shared 676 / 3; all rows held 260 / 26; stale copy 246 / 5; earlier rejection 112 / 1. Same 4,080 total as the instruction (its partial 632 + incomplete 366 + all held 281 = 1,279 equals 1,019 + 260; 21 rows move between two classes on the live check). Every item is a person's decision by rule; none is machine-eligible, so no unchanged evidence was re-read and no blanket approval is proposed. Eligible residue is the partial-admission class on the course path: #1739 admitted 1 row at 09:14 AEDT (AC associate degree in ministry, row `8bef2acc`) and strict-proof 1 row at 07:59 AEDT (ANU, `255a1dfc`); 09:29 admitted 0.
- **Cycles:** 632 (09:13 AEDT) read nothing on the paid cap (US$7.49 used). 134 Australian courses are eligible for the 11:13 and 12:13 AEDT cycles; two result-bearing cycles are not proved yet and are recorded at the 12:35 AEDT checkpoint.
- **DOT AU12/AU13:** Monash 115586B (Design and Arts, page `F2014?international=true`, bound and read, 0 rows, selector class row_limit: the earlier read hit the row limit) and Macquarie 099175C (bound page read, no row kept, course URL empty, so the domestic selector cannot be told from the international one) stay PRECHECK_PENDING; the source and identity issues go to S1-Build, no submission. Flinders 020926K already holds 1 active row: no duplicate AER. Container PDF row ingestion is S1-Build's; no S2-AER dependency found.

- **S2-AER, PC-20261128-1000-S2-AER (acknowledged 28 Nov 2026 10:25 AEDT; Claude Code, Sonnet 5.5): zero-yield trace of the matrix reader (live read, no spend, no rescrape, nothing written to the database).**
  - **Course pass (09:29/09:44/09:59 looked_at 0):** not a selector fault. Cycle 632 (09:13) read nothing on the paid cap (US$7.485 used, cap US$5); the cap resets at 11:00 AEDT, so 11:13 is the first cycle with room. 134 Australian courses stay eligible; no admitted row was gained by selector exclusion.
  - **Matrix, exact stored trace.** The 4,080 proposed rows sit on pending items, each run through `security.aer_matrix_machine_check_v1`:
    - **Stale copy, 15 items (8 providers), all read on 29 Oct 2026.** The source's current stored copy has a different hash, and every one has a newer run on the current copy (28 Nov 00:19 to 04:19 AEDT). Six of the newer runs have a pending change item that a person decides: UWA `0215cdb6` (run `0cfb3a81`), Flinders `fe063dc3`, ANU Belgium `160350b7`, ANU Singapore `33509b99`, ANU undergraduate program `303b430e`, ANU Vietnam `afe77091`. Two are done with 0 admitted and no item (ANU Bosnia run `6caf42cd`, 5 dropped; ANU Croatia run `c7888b98`, 8 dropped). Seven re-reads FAILED with "Signal timed out" after 3 attempts and have no item (UOW `1a857162` slice 5 of 18, Massey `8b6def6a`, Manukau `ec7aa4d2`, ANU USA `aef66834`, ANU Hong Kong `342d5c64`, Whitireia `b839b446`, Otago `60c982bc`). The old 29 Oct items are superseded by these runs; superseding or rejecting them is a Layer 4 person decision, not made here.
    - **Changed admitted table:** the five newer change items above (Flinders, ANU x4) fail `change_of_admitted_table` by rule; a person compares old and new.
    - **Partial / incomplete (D-R3), UWA `0215cdb6`:** 146 of 156 rows wait; the reader dropped 20 published rows (IE 9 and KE 9 `quote_not_on_page`: quotes are cut and end in "...Must include"/"...Selection Rank Aggregate"; NO 2 `grade_not_in_quote`), leaving IE, KE and NO with no row. The read is incomplete, so it needs a corrected read or a rejection by a person. NMIT `cdb8ec0f` is the same class (Pacific Islands, `unknown_country` 2).
    - **All rows held:** Melbourne India CBSE/ISC `261f23b6` and India State Board `dcf9300f`: 9 rows each held back by `level_unmapped`.
    - **No rows:** Newcastle agents page `5aa58072` proposes no row.
  - **Defect for S1-Build (existing queue, no new reader):** the matrix reader's model calls time out ("Signal timed out") on 7 of the 15 re-reads, the same timeout class as admission-rule-runner and aer-reconcile; the machine cannot reach a decision on a source it cannot read. No unchanged run repeated; the re-reads wait for the timeout fix or the 11:00 cap reset and a person's choice to retry.
  - **RMIT 077512F and Deakin 114205F:** the exact packs are in #1330, #1342 and #1345. A Curator (rank 3 or above) applies them in Catalogue > Entry requirements; not applied, zero canonical corrections.
  - **Costs:** no spend, no Firecrawl, no container run. Next: prove the 11:13 and 12:13 AEDT cycles at 12:35 AEDT.

- **S2-AER, PC-20261128-1018 and -1050 (acknowledged 28 Nov 2026 11:55 AEDT; Claude Code, Sonnet 5.5): first result-bearing cycles proved (live read, no spend by this lane, no Firecrawl or container run).**
  - **Cycle 634 (11:13 AEDT) after the 11:00 cap reset:** the paid cap had room (US$0.024 spent for the UTC day), and the course pass queued 134 Australian course reads (cycle 633 at 10:13 read 0 on the old cap).
  - **Machine admission, observed in `pipeline.aer_machine_admissions` (mode admit, outcome admitted), 11:15 to 11:44 AEDT:** 78 courses, 294 rows, active in `catalogue.course_entry_requirements` (the active rows on those courses equal the rows admitted in each slot). 11:15 slot: `aer-course-partial-v1` 33 courses/148 rows and `aer-machine-v1` 29/89; 11:30 slot: partial 6/19 and machine 10/38. Providers: UNSW 31 courses/140 rows, UTS 24/66, UQ 4/24, Deakin College 1/16, UWA 3/15, Flinders 4/11, Strathfield College 5/10, Monash 5/10, Milner 1/2. Before the reset: 2 rows (07:59 and 09:14). Active rows platform-wide: 32,121 on 11,134 courses; 996 course first-read items still pending (people decide by rule).
  - **B15 UTS 107049E (Bachelor of Design Honours), PC-1018:** admitted 11:44 AEDT by `aer-course-partial-v1`, 1 active row (course `0219207d`), source https://www.uts.edu.au/courses/bachelor-of-design-honours, as_at 2026-11-17. The row is one route for non-UTS applicants (equivalent bachelor in Photography, Product Design, Fashion and Textiles or Visual Communication, WAM 65.0 or above), case by case, no course-wide minimum; the threshold is not applied to other courses. Consumer proof: `website_v3_course('course:cricos:00099f:107049e','AU')` returns that route in `entry.resolution` (rule course_override, outcome case_by_case, min_score null). UNSW 031354F also reads back its rows. S1-Build owns any direct submission receipt; none is needed for this row.
  - **TIWA, PC-1050:** TAFE International Western Australia has 0 provider-matrix rows and one source (`tafeinternational.wa.edu.au/tafe-courses/tafe-admission-requirements`) whose only run failed with 0 rows. Not repeated. The shared table goes through the existing provider-matrix route and exact course exceptions through the course route, once S1-Build qualifies the stored copy; no new architecture.
  - **Container matrix PDF (PC-1018):** no qualified already extracted container matrix PDF is in the database for this lane (no new source row); the existing admission path and one-slot gateway are S1-Build's. Nothing prepared by guesswork.
  - **Still open:** 12:13 AEDT read cycle not yet run (second result-bearing read cycle); RMIT 077512F and Deakin 114205F packs need a Curator; 7 matrix re-reads timed out (S1-Build). No spend by this lane.
