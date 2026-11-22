

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
