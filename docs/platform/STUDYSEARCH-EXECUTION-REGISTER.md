**S2-RM-Design, 24 Nov 2026 22:15 AEDT (cross-country AER admission and blocker gate): active-course counts added for the 12 change-item providers; no live change.**
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
| Change to an admitted table (13 items) | Flinders `0a42da16` (4), Massey `229dc07d` (38), Whitireia and WelTec `40f9891f` (97), Auckland Univ. of Technology `39301fa8` (63), Otago `ab12c7f8` (0), ANU `e47a940d` (15), Lincoln `248374d1` (110), Waikato `00e5f26c` (40), Auckland `e096aba7` (126), Top Education Institute `c8a3391d` (228, two items), Waikato Institute of Technology `742eef0a` (193), ACU `030992c3` (370) | 1,269 | Admission | `change_of_admitted_table`: a change to an admitted table stays with a person | machine check rule `change_of_admitted_table` on each item | Platform Admin (Layer 4 Approve, Approve except or Reject) | A person decides; Top Education Institute's two items read two different source pages (see the active-courses table below) |
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

The 13 items stay with a person (Layer 4 Approve, Approve except or Reject); the machine check returns `change_of_admitted_table` on every one. Correction to the 20:15 row: Top Education Institute's two items read two different source pages, so they are not duplicates. Platform: active matrix rows 7,261 (7,259 at 20:10); covered courses 10,729; the machine admitted nothing in the last 24 hours (9 `aer-machine-v1` declines). No reusable non-inferential rule was found. The 53 proposed rows failing value-in-quote are misreads (the value is not in the quote, or the quote is cut), not a normalisation fault. **M3 mirror:** S1-Build writes the Google Sheet; the figures above are the verified live counts to sync.

**Reader contract gaps found (for the F-AER handover contract):** every proposed row must carry `course_id` or a `level_label` that is a course level (not an applicant qualification), and a named country or recognised qualification. Rows without them cannot be admitted by any rule and are not weakened.

