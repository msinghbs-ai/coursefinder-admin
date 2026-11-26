

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
- **Active matrix rows:** 7,261 → 7,263 (+2 net). Five rows were made active from three Layer 4 first-read approvals: Australian Institute (23:18; AU Year 12 and AQF Certificate IV, bachelor), Conestoga College (00:18; CA OSSD 65%) and Simon Fraser University (00:18; CN Senior Middle School).
- **Pending:** first-run reads 65 → 68 (new reads for Quality College of Australia and Victoria University, 23:45); change items 13, unchanged.
- **No change:** covered courses 10,729 (the coverage table refreshes in chunks); active course rows 27,969, with none new; machine admissions in the last 24 hours: none (the 9 earlier declines have aged out).
- **Consumer check:** a Conestoga bachelor course (country CA) resolves `provider_minimum` on `entry_resolve_v3`; Website v3 and Zoho v3 `item.entry` both serve "OSSD … minimum cumulative average of 65%", as at 24 Nov 2026. A Simon Fraser bachelor course (CN) serves today's row on Website v3; that row prints no minimum (`scale none`).
- **Guardrails:** G3 75/48, locks 7,585, active cron 138, $0.

**S2-RM-Design, 24 Nov 2026 23:05 AEDT (AER admission validator and Layer 4 triage): 13 change items triaged; s995 re-rehearsed; no live change.**
- **Triage (Execution Register, S2-AER section):** 0 of 13 can be bulk-approved now. Every item is `technical_blocked` (`matrix_source`) because its read dropped published rows; Approve is refused.
  - Across the 13 reads: 1,269 proposed rows; 449 unchanged, 7 changed scores, 813 added; 187 active rows would be superseded; 541 rows fail value proof; 50 have a blank level.
  - Remedy: corrected re-reads from stored copies by the reader owners.
- **Reusable fix routed:** six country aliases (Hong Kong (China), HK, Taiwan(China), SG, Macedonia, and the misspellings Bangaldesh and Phillipines). No equivalence is inferred.
- **s995 (Pilot #1502):** not superseded. `security.aer_matrix_machine_exclusions_v1` is unchanged (md5 `51ad50c5…`) and UWA's 194 rows still wait. Re-rehearsed 23:00: 186 rows admitted; active matrix 7,261 → 7,447; counter 10,729 → 10,795 (+66); real answers 0 (UWA India answers: 152 course_override, 176 contact_provider before and after).
  - Remaining value: correct bachelor ATAR-band rows that answer only once UWA courses carry an ATAR band. Kept as a draft; if it is merged, its migration timestamp must be renumbered above the head.
- **Baseline for the 00:10 read-back:** active matrix 7,261; covered 10,729; 0 machine admissions in the last 24 hours.
- **Guardrails:** G3 75/48, locks 7,585, cron and $0 all unchanged.

**S2-RM-Design, 24 Nov 2026 22:15 AEDT (cross-country AER admission and blocker gate): active-course counts added for the 12 change-item providers; no live change.**
- **Counts:** the 12 providers carry 3,024 active courses, 1,167 of them covered now, under 13 pending `entry_matrix_change` items (1,284 proposed rows). The table is in the Execution Register's S2-AER blocker section.
- **Correction:** Top Education Institute's two items read two different source pages, so they are not duplicates.
- **Live state:** active matrix rows 7,261; covered courses 10,729; 0 machine admissions in the last 24 hours (9 declines).
- **Gates unchanged:** the 13 human change items, blank-level rows and host_shared RMIT Pathways all stay gated.
- **Rules:** none shipped. The 53 value-not-in-quote rows are reader misreads.
- **Guardrails:** G3 75/48, locks 7,585, cron and $0 all unchanged.

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
- 25 Nov 2026 AEDT, S1-AER-Claude (Admin #1028; Pilot s1105): CQUniversity (106 active courses) country table is a PDF served without a .pdf address, so the worker classified it not_html; a `#.pdf` source was registered and its pages stored. New $0 AER v2 proven-structure reader in `entry-pdf-columns.ts` (header Country | Qualification | Diploma | Undergraduate; country carried over its qualification rows; fails closed on any item off a column; UK awards SQA and BTEC printed under China are left out and listed, not placed by guesswork) and `entry-cells.ts` now reads "per cent" as a percentage. Fixture from the stored export, spec s1105 plus 102 related entry-reader specs pass locally. Pilot PR follows this Admin PR; after merge the CQU source is re-read, then rows, machine admission, canonical rows and course coverage are read back. Nothing admitted yet; canonical AU not claimed. Spend US$0 (Firecrawl 0). Proper fix for S1-Build: divert to the PDF path when an HTML read returns application/pdf or %PDF. Report to S1-Build: OpenRouter weekly key limit hit two runs earlier.
- 25 Nov 2026 AEDT, S1-AER-Claude (Admin #1028; Pilot s1106): CQU requeue after s1105 (merge 9647f1a3, deployed 15:31 UTC) was held again (held_unparsed, 0 rows, US$0). Cause found from a fresh stored-PDF export: the table runs over five pages with 14 or more of about 76 qualifications blank at one level, so the shared cell reader's 90 per cent every-level gate rejected the grid. s1106: a table proven by its printed Country header needs 50 per cent of rows with every level (other readers keep 90); spec s1105 gains the blank-cell case (fails without the change). Fixture now holds the real page 1 (introduction, global table and the first rows). Pilot PR follows this Admin PR; then the CQU source is re-read once and rows, machine admission, canonical rows and course coverage are read back. Nothing admitted yet.

**S2-Build, 25 Nov 2026 18:30 AEDT (Platform Admin 17:13, Portal Release 1 search activation): s1153 (Pilot #1616, migration `20261127020000`, edge function `portal-search-embed`) recorded before merge.** `public.portal_course_search_v1(p_args)` and `catalogue.portal_course_search_v1` are built to the as-built contract in the portal design doc. Stage 1 reads the words into filters from the live tables: country, state, campus city (with ABS urban-area postcodes so suburbs count), study level and budget. Stage 2 ranks with the existing `search.course_candidates_v1`. Fewer than 3 exact matches bring near misses and relaxations: third-cheapest fee + 5%, rounded up to A$1,000, within +30%. Vectors (`openai/text-embedding-3-small` via OpenRouter, data collection denied) live under a new profile `portal-default`, because the frozen `api.zoho_course_candidates_v1` uses the same ranker; Zoho and website results cannot change. The backfill runs on a new registry lane of the existing dispatcher (no cron job) in steps of 1,500; one statement for all 34,362 jobs timed out in rehearsal. A trigger re-queues a course when its semantic text changes. 1,690 active courses with no search document were sent to the existing refresh. The spec number moved to s1153 because S1-Build took s1152 and `20261127010000` first. Rehearsed on live data, rolled back: nursing under A$40,000 in Melbourne returns ACU Fitzroy and IHM North Melbourne first; data science masters in Sydney or Brisbane returns QUT, CDU, Sydney, UTS and Western Sydney. G3 75/48, 7,585 locks and active cron are unchanged (post-checks).

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
