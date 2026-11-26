# StudySearch Portal: running build document

**Status at the last checkpoint (26 Nov 2026 13:28 AEDT):** Release 1 is live for UAT on `studysearch-portal.techm.workers.dev`; Release 2 is complete end to end (s1200 to s1202, s1210). Course details and the Entry Requirements screen are live (s1215 screens on s1214 reads); s1216 adds the provider website, the provider's entry matrix, and city, length and fee on Entry Requirements rows, ready for the screens to show. Daytime quiet hours (s1213) are live.

**How this document is kept.**
- It is updated at every material delivery checkpoint until the Platform Admin accepts the portal: a change claimed, recorded, merged, live, or blocked.
- The source is the admin repository, `docs/platform/STUDYSEARCH-PORTAL-BUILD-DOCUMENT.md`.
- The Google Doc in Drive `M3 > Portal` is its mirror. Each update replaces the Drive copy, because no Google Docs editor is connected to the sessions. With the Google Docs connector turned on, it would be edited in place and keep one link.
- Nothing is removed at a checkpoint: decisions, history and controls are carried forward, and superseded items are marked, not deleted.
- The design and decisions document stays `docs/platform/2026-11-25-studysearch-portal-design-decisions-and-plan.md`. This document tracks delivery against it.

## 1. Ownership

| Who | Owns | Numbers |
| :---- | :---- | :---- |
| Platform Admin (Mandeep) | Acceptance; Cloudflare Worker, domain `portal.studysearch.ai` and Supabase redirect URLs (sessions have no Cloudflare access); users and roles (in Admin) | n/a |
| S1-API-Frontend-Delivery | `portal/` Worker, sign-in and role guards, Dashboard, Courses screen, Universities & Providers, Scholarships, Saved courses; the `portal` data layer | s1141 to s1149 |
| S2-Build | Course search function (`catalogue.portal_course_search_v1`, public entry), `portal_search` settings, the course meaning vectors (`portal-default` profile), search hotfixes; the Release 2 proposals data layer | s1153, s1180, s1181, s1210 |
| S1-RM-Design (PIM) | Not portal work; holds s1162 to s1179 and migration versions `20261128010000` to `20261128190000`, which shapes the numbering of portal fixes | n/a |

## 2. Decisions (carried forward)

| Date (AEDT) | Decision | By |
| :---- | :---- | :---- |
| 25 Nov 10:37 | Viewers (rank 1) browse courses, providers and scholarships; they cannot save courses or see proposals. Counsellors (rank 2) and above save. | Platform Admin |
| 25 Nov 10:45 | Every Counsellor and above sees every proposal (one team); row-level security leaves room for a partner rule later. | Platform Admin |
| 25 Nov | A separate Worker from the same Pilot repository, `portal/`; first on `*.workers.dev`, then `portal.studysearch.ai`. Users and roles managed only in Admin. | Platform Admin brief 12:47 |
| 25 Nov | Student record holds a reference and given name with family initial only. Proposals are archived, never deleted. PDFs come from Cloudflare Browser Rendering, falling back to browser print. | Design document |
| 25 Nov 12:26 | Courses use `portal_search.visibility_scope = active`; providers and scholarships show published records only. | Platform Admin |
| 25 Nov | Embedding model `openai/text-embedding-3-small` (1,536 dimensions), pinned in a setting. Course search is additive and checked against the frozen consumer API (75 functions, 48 relations). Internships are never inferred. | Platform Admin |
| 25 Nov 22:43 | Search scope stays on the 34,362 courses of published providers. The 1,690 courses at 261 unpublished or archived providers stay out of the shared search documents, and join automatically when the provider is published. | Platform Admin |
| 26 Nov 03:45 | Course search must tolerate any typing ("make it idiot proof"): extra or leading spaces, case, punctuation and similar never cause a failure. | Platform Admin |
| 26 Nov 03:59 | This running build document is kept in Drive `M3 > Portal` and updated at every delivery checkpoint until final acceptance. | Platform Admin |
| 26 Nov 07:30 | Release 2 data layer: the screens' contract functions (list, get, save, refresh) on the brief's pipeline tables, row level security and append-only versions; the student record holds identity (reference, given name, family initial) plus academic facts (country of education, qualification, result, English result, destination, preferred intake, budget); a save on an older version writes nothing unless forced; `ready` is a status. | Platform Admin (question answers) |
| 26 Nov 07:37 | Release 2 backend matches the live screens one to one; proposals expire for review 12 months after the last save (`expires_at`), nothing removed automatically. | Platform Admin brief |
| 26 Nov 09:30 | Course search must not feel slow, most on first-time and broad phrases: profile it live, tune the meaning index and plan, pre-warm the Dashboard example searches, and never wait on the embedding service; US$0, no new cron. | Atlas brief for the Platform Admin |
| 26 Nov 11:59 | Zero-cost daytime CPU and I/O isolation: the heaviest per-minute background jobs run overnight so portal searches stay sub-second in counsellor and UAT hours, without a larger compute tier; no retired job activated, active cron jobs at most 138. | Platform Admin, through Atlas |
| 26 Nov 12:02 | Expandable Course Details and an Entry Requirements screen in the portal (S1-API-Frontend-Delivery), backed by read-only portal reads of published-provider courses that leave the consumer API untouched. | Atlas brief |
| 26 Nov 15:18 | S2-Build may wire the s1216 fields into the portal screens while S1-API-Frontend-Delivery is busy, so the Release 1 and 2 screens are complete. | Platform Admin, through Atlas |

## 3. Implementation history

| When (AEDT) | Change | Lane | Pilot | Admin record | State |
| :---- | :---- | :---- | :---- | :---- | :---- |
| 25 Nov 12:55 | Portal lane registered (plan item 10); design document mirrored | S1-API-Frontend-Delivery | n/a | plan log | Done |
| 25 Nov 13:35 | s1141 scaffold: `portal/` Worker, sign-in, role guard, Dashboard search bar | S1-API-Frontend-Delivery | [#1609](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1609) | plan log | Merged |
| 25 Nov 14:49 | s1142 sign-in separates a refused key from a wrong password; brand panel | S1-API-Frontend-Delivery | [#1610](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1610) | plan log | Merged |
| 25 Nov 15:08 | s1143 data layer (migration `20261126230000`): schema `portal`, saved shortlists, providers, scholarships, lookups, settings | S1-API-Frontend-Delivery | [#1612](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1612) | plan log | Live |
| 25 Nov 17:03 | s1144 to s1149 Release 1 screens | S1-API-Frontend-Delivery | [#1613](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1613) | plan log | Live |
| 25 Nov 18:51 | s1153 course search and the course vector backfill (migration `20261127020000`, worker v1.0.46) | S2-Build | [#1616](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1616) | [#1091](https://github.com/msinghbs-ai/coursefinder-admin/pull/1091), [#1093](https://github.com/msinghbs-ai/coursefinder-admin/pull/1093), [#1103](https://github.com/msinghbs-ai/coursefinder-admin/pull/1103) | Live |
| 25 Nov 20:09 | s1153 follow-up: vector batch 25 (writes of 150 timed out) | S2-Build | [#1622](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1622) | [#1106](https://github.com/msinghbs-ai/coursefinder-admin/pull/1106) | Live; backfill 34,362 of 34,362, US$0.051567 |
| 25 Nov 22:45 | Scope decision recorded (published providers only) | S2-Build | n/a | [#1110](https://github.com/msinghbs-ai/coursefinder-admin/pull/1110) | Done |
| 26 Nov 00:15 | s1180 hotfix: "Master of Nursing in Victoria" failed once its phrase vector was cached; the ranker's meaning branch had an ambiguous `course_id` (42702). Migration `20261128075000` | S2-Build | [#1633](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1633) | [#1113](https://github.com/msinghbs-ai/coursefinder-admin/pull/1113), [#1116](https://github.com/msinghbs-ai/coursefinder-admin/pull/1116) | Live |
| 26 Nov 05:10 | s1181 hardening: search timed out (57014, limit 8 s) in the filter step, which read every candidate course's vector (10 to 15 s). Fix: typed text folded one way; malformed fields ignored; the vector index searched once, words through the text index, ranking fused over the matches; city matching in one query; empty searches answer at once; grad dip and grad cert as levels; 3 new settings. Migration `20261128105000` | S2-Build | [#1637](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1637) | [#1121](https://github.com/msinghbs-ai/coursefinder-admin/pull/1121), live record (this checkpoint) | Live; read back as a Counsellor: every spelling 21 courses in about 0.55 s |
| 26 Nov 07:15 | s1200 to s1202 Release 2 screens: Proposals list, proposal editor (reorder, notes, soft-lock and conflict handling), live refresh difference (Accept all / Keep my version), and the two-page student sheet with Save as PDF / Print from browser print CSS. Built against the contract in the design document; the `portal_proposal_*_v1` functions are not live yet, so the screens show "not switched on yet". No migration | S1-API-Frontend-Delivery | Pilot (this change) | this change | Built; waiting for the functions |
| 26 Nov 08:25 | s1210 Release 2 proposals layer: `pipeline.portal_proposals`, append-only `portal_proposal_versions`, `portal_activity`, `portal_user_prefs` (RLS, no table grants); `portal_proposal_list/get/save/refresh_v1` matching the screens, `portal_proposal_archive_v1`, `portal_activity_touch/list_v1`, `portal_prefs_save_v1`; eleven portal settings. Migration `20261129003000` | S2-Build | [#1646](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1646) | [#1133](https://github.com/msinghbs-ai/coursefinder-admin/pull/1133), live record (this checkpoint) | Live; read back as two Counsellors: save, get (others_recent), clash (nothing written), refresh, list |
| 26 Nov 11:00 | s1211 search latency (migration `20261129040000`): 16 MB one-bit meaning index with exact scoring of 300 candidates; city and filter steps by key from the topic set; countries and levels through their indexes; phrase meanings kept 30 days and renewed on use; Dashboard example searches pre-warmed. Rehearsed: same results as s1181; Master of Nursing in Victoria 0.16 s (was 1.52 s cold), city searches 0.2 to 0.48 s (were 0.38 to 1.05 s) | S2-Build | [#1651](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1651) | [#1145](https://github.com/msinghbs-ai/coursefinder-admin/pull/1145) | Live; meaning step superseded by s1212 |
| 26 Nov 11:25 | s1212 (migration `20261129050000`): the s1211 live read-back showed the compact meaning index pushed out of memory by the pipeline's load and slower warm, so the meaning step reads the full-vector index again by default (`portal_search.meaning_index`, full or compact); the other s1211 changes stay. Rehearsed: same results as s1181; city searches 0.21 to 0.42 s (were 0.40 to 0.80 s) | S2-Build | [#1653](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1653) | [#1147](https://github.com/msinghbs-ai/coursefinder-admin/pull/1147), live record (this checkpoint) | Live; read back paired with s1181 |
| 26 Nov 12:20 | s1213 daytime quiet hours (migration `20261129060000`): coverage-ai-match-prepare, fee-reader, scholarship-ai-extract, course-description-machine and provider-description-read do no work 08:00 to 20:00 Melbourne (95,352 job-seconds a day, about 47,700 by day); settings `pipeline.quiet_hours.*` | S2-Build | [#1654](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1654) (migration renumbered `20261129070000`) | [#1150](https://github.com/msinghbs-ai/coursefinder-admin/pull/1150) | Live |
| 26 Nov 12:25 | s1214 portal reads (migration `20261129080000`): `public.portal_course_detail_v1` (one course in full) and `public.portal_aer_list_v1` (paged academic and English requirements; setting `portal.aer_page_size`), Viewer and above | S2-Build | [#1656](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1656) | [#1151](https://github.com/msinghbs-ai/coursefinder-admin/pull/1151), live record (this checkpoint) | Live; read back as the Platform Admin |
| 26 Nov 12:25 | s1214 portal reads (migration `20261129080000`): `public.portal_course_detail_v1` (one course in full) and `public.portal_aer_list_v1` (paged academic and English requirements; setting `portal.aer_page_size`), Viewer and above | S2-Build | branch `s2-s1214-portal-detail-aer` | recorded before merge (this checkpoint) | Rehearsed |
| 26 Nov 12:45 | s1215 Course details, Entry Requirements (AER) and new-tab links (migration `20261129090000`): inline Course details panel on Courses, Saved courses and Entry Requirements (overview, campuses and delivery, fee lines as recorded, intakes and deadlines, entry and English, provider-level career outcomes, official source); new Entry Requirements screen after Courses (Viewer and Counsellor; Save and Add to proposal Counsellor only); one `ExtLink` component so every outside link opens in a new tab; reads S2-Build's `portal_course_detail_v1` and `portal_aer_list_v1`; new `portal_study_levels_v1` for the level filter | S1-API-Frontend-Delivery | Pilot branch `s1-portal-details-aer-s1215` | plan log | Recorded before merge |
| 26 Nov 13:15 | s1216 detail fields (migration `20261129100000`): `provider_website`, `entry_matrix` (capped by `portal.entry_matrix_max_rows`) and `entry_matrix_total` in the course detail read; `city`, `state_code`, `duration_value`, `duration_unit` and `annual_tuition_fee` on Entry Requirements rows | S2-Build | [#1658](https://github.com/msinghbs-ai/Coursefinder-Pilot/pull/1658) | [#1158](https://github.com/msinghbs-ai/coursefinder-admin/pull/1158), live record (this checkpoint) | Live; read back as the Platform Admin |
| 26 Nov 15:40 | s1220 screens (frontend only): Course details shows the provider website and the provider's entry matrix (for the student's country when chosen; count note when capped); Entry Requirements cards show location, length and tuition per year. Checked in Chromium at 1280 px and 412 px | S2-Build | branch `s2-s1220-portal-detail-wiring` | recorded before merge (this checkpoint) | Specs and browser check passed |

## 4. Protected controls (unchanged by any portal change)

- Frozen consumer API (G3): 75 functions and 48 relations, no drift, checked before and after each migration.
- Manual locks: 7,585, untouched.
- Active cron jobs: 140 or fewer. The portal adds none; course vectors run on the existing dispatcher lane `portal-search-embed`.
- Spend: US$5.00 a day across the platform. Only the `coverage-sweep` worker calls OpenRouter, with provider data collection denied.
- No migration drops or deletes. Each migration passes pre-flight, a rolled-back rehearsal and the `live-dry-run` gate. Admin pull request first, then Pilot, both through the `automerge` label.
- Settings, not code, hold every operational value (G2: toolsets `portal` and `portal_search`). Lists read the live database. Fixes go live on deploy, with no shadow mode.
- AER v1 is frozen. The website and Zoho APIs are never changed by portal work.

## 5. Outstanding dependencies

| Item | Owner | Blocks |
| :---- | :---- | :---- |
| Connect `portal.studysearch.ai` to the Worker, and add its Supabase redirect URL | Platform Admin | Production address (UAT runs on `*.workers.dev`) |
| Confirm Browser Rendering on the free Cloudflare plan | Closed 26 Nov: not needed. The student sheet uses the browser's own print, so no Browser Rendering quota is used | n/a |
| Privacy notice wording | Platform Admin | Proposals (retention decided 26 Nov 07:37: 12 months after the last save, `expires_at`) |
| A paste file to remove expired or privacy-requested proposals (versions are append only, so it lifts the trigger inside one reviewed transaction) | S2-Build drafts, Platform Admin runs | Retention and privacy requests being acted on |
| City filter on Universities & Providers; "only with scholarships" | Data lanes (function change first) | Release 1 screen gaps listed in the design document |
| Scholarship intake wording is mixed ("Feb 2027", "February 2027") | Scholarships data lane | Clean intake filter |
| Career outcome rows | Course data lanes | Outcome matching (wired automatically as rows admit) |
| Google Docs connector in these sessions | Platform Admin (optional) | Updating this document in place with one link |
| Deploy `portal_proposal_list_v1`, `_get_v1`, `_save_v1`, `_refresh_v1` and the proposal tables to the contract in the design document ("Release 2 contract: student proposals"), with the limits and soft-lock window as settings | S1-Build | Every Release 2 screen (they show "not switched on yet" until then). On deploy, repeat the checks signed in as a Counsellor: create, reorder, save, conflict, refresh, print |
| Retention period and privacy notice wording for proposals (already listed above, now needed before real students are entered) | Platform Admin | Using Proposals with real student data |
| Leftover Pilot branches `s2-s1170-portal-hybrid-fix` and `s2-s1182-portal-proposals` (no PR); the session proxy refuses branch deletion (HTTP 403) | Any session with delete rights | Housekeeping only |

## 6. Open issues seen during UAT

- Course search time-outs on some phrases: fixed by s1181 (live 26 Nov 05:45). Superseded, kept for history.
- The first search after a quiet spell is slower than the rest (cold database cache): reduced from 10 to 15 s to about 2.7 s by s1181.
- Course search still felt slow in UAT on 26 Nov (Atlas brief 09:30): calls of 0.3 to 3.9 s, the cold meaning index read from disk and city searches reading whole tables. Fix s1211 (recorded before merge); a phrase not yet embedded ranks by words on its first search and by meaning from the next.
- Search time on the shared database follows the scheduled pipeline's load (about 13,500 job-seconds an hour; 29 to 41 runs overlap each minute): the same warm search took 0.15 s at one moment and 6 s at another. A Platform Admin decision: compute size, or keeping the heaviest per-minute jobs off UAT hours. Recorded in the plan.
- Daytime quiet hours (s1213) are live: the five held jobs return in about 0.1 s by day, cron load per 10 minutes fell by half and more, and a fixed CPU benchmark went from 2.36 s to 1.28 s within minutes. Medium compute is shared CPU (Supabase documentation; Large and above have dedicated vCPUs); if searches still vary in UAT, compute size is the remaining lever (a cost decision).
- "Grad dip" and "grad cert" are not yet read as study levels; s1181 adds them ("adv dip" and "assoc degree" too). Done in s1181.
- An empty or stopword-only search returns every course by title (no error); after s1181 it returns no courses at once unless Study in or a provider is chosen.
- Seen in passing, another lane's work: `public.api_request_log_v1` logs fail with `request_id` uuid versus text (Postgres log 26 Nov 03:31). Not portal work.
- Entry Requirements and Course details show only what is admitted; gaps close as the data lanes admit rows and need no screen change. Career outcomes are provider-level, never course-level. Two things the screens cannot show from S2-Build's reads yet (passed to S2-Build in the Master Plan): the provider's country-by-country entry matrix and website in the detail read, and city, length and fee on the Entry Requirements list items.

## 7. Next executable action

Platform Admin: open Proposals on the portal (desktop and phone):
1. Create a proposal from Saved courses.
2. Edit it, mark it ready and refresh it.
3. Save from two sign-ins at once and check the clash notice.
4. Duplicate it, print the sheet and archive it.
5. Repeat the course search UAT (first-time phrases, broad words, a city, the Dashboard examples).
6. Daytime quiet hours approved (s1213); after a day of UAT, say whether more jobs should join the list or the window should change (Settings › Pipeline settings › Scheduling).
7. Decide the privacy notice wording.
8. Open a course on Courses and choose Course details; check each section and that missing values say Not recorded. Repeat on Saved courses.
9. Open Entry Requirements: choose Study in, a student's country of education and a study level; save a course and add one to a proposal. Sign in as a Viewer and check Save and Add to proposal are not shown.
10. Click an outside link (course page, provider website, scholarship page) and check it opens in a new tab.

S2-Build: act on anything the UAT finds, including the course detail and entry requirements reads (s1214) once S1-API-Frontend-Delivery wires them; draft the paste file that removes expired or privacy-requested proposals when the Platform Admin asks; record acceptance here.

## 8. Checkpoint log

- 26 Nov 2026 15:40 AEDT, S2-Build: s1220 portal screens for the s1216 fields recorded before merge (cross-lane on the Platform Admin's authority).
- 26 Nov 2026 13:28 AEDT, S2-Build: s1216 live (Pilot #1658): provider website and entry matrix in course detail (2 rows in 112 ms on a sample course), city, length and fee on Entry Requirements rows; G3 75/48, locks 7,585, cron 135, US$0; Drive mirrors replaced.
- 26 Nov 2026 13:15 AEDT, S2-Build: s1216 detail fields recorded before merge (provider website, entry matrix, city, length, annual tuition).
- 26 Nov 2026 12:35 AEDT, S2-Build: s1213 read back live (held jobs about 0.1 s by day, cron load halved, CPU benchmark 2.36 s to 1.28 s); s1214 live (Pilot #1656): course detail 60 ms, entry requirements 147 ms, anon refused; G3 75/48, locks 7,585, cron 136, US$0; Drive mirror replaced.
- 26 Nov 2026 12:25 AEDT, S2-Build: s1213 live (Pilot #1654); s1214 portal course detail and entry requirements reads recorded before merge.
- 26 Nov 2026 12:20 AEDT, S2-Build: s1213 daytime quiet hours recorded before merge (five background jobs, 95,352 job-seconds a day, overnight only); active cron 138; G3 75/48; locks 7,585; US$0.
- 26 Nov 2026 11:45 AEDT, S2-Build: s1212 live (Pilot #1653); paired live read-back with s1181: same results, city searches faster, meaning searches on par; G3 75/48, locks 7,585, cron 138; Drive mirror replaced.
- 26 Nov 2026 11:25 AEDT, S2-Build: s1211 live (Pilot #1651, admin #1145); live paired read-back: city searches faster, compact meaning index not holding its gain under the pipeline's load; s1212 recorded before merge; Dashboard examples pre-warmed live (five phrases cached). G3 75/48, locks 7,585, cron 138, US$0.00.
- 26 Nov 2026 11:00 AEDT, S2-Build: s1211 search latency claimed and recorded before merge (migration 20261129040000): measured live, rehearsed against s1181 with the same results, migration 38 s; G3 75/48, locks 7,585, no cron, US$0.00.
- 26 Nov 2026 09:00 AEDT, S2-Build: s1210 live (Pilot #1646); read back as two signed-in Counsellors (save, get, clash with nothing written, refresh, list); G3 75/48, locks 7,585, cron 136, US$0. Release 2 complete end to end; Drive mirror replaced.
- 26 Nov 2026 08:25 AEDT, S2-Build: s1210 Release 2 proposals layer built to the screens' contract (Platform Admin decisions 07:30, brief 07:37), rehearsed as real users (rolled back), recorded before merge.

- 26 Nov 2026 05:45 AEDT, S2-Build: s1181 live (Pilot #1637); read back as a signed-in Counsellor: every spelling of "Master of Nursing in Victoria" returns the same 21 courses in about 0.55 s; G3, locks and cron unchanged; US$0. Drive mirror replaced.
- 26 Nov 2026 05:10 AEDT, S2-Build: s1181 finished and rehearsed (30 messy inputs, 0.03 to 1.55 s; 20 malformed request shapes; no error), recorded before merge.
- 26 Nov 2026 04:20 AEDT, S2-Build: document created at the Platform Admin's request (03:59). Release 1 live; s1180 live; s1181 built and rehearsed.
- 26 Nov 2026 07:15 AEDT, S1-API-Frontend-Delivery: Release 2 screens built (Pilot s1200 to s1202) and checked at 1280 px and 412 px; the contract the screens call is in the design document. The functions are S1-Build's to deploy. Read back before the PR: G3 75/48 no drift, locks 7,585, cron 138, US$0, no `portal_proposal_*` function live yet.
- 26 Nov 2026 09:20 AEDT, S1-API-Frontend-Delivery: the portal entry now installs the shared stale-tab guard (Pilot s1203, `portal/src/lib/chunkReload.js`), and `portal/public/_headers` sets `index.html` no-cache and `/assets/*` immutable. A portal tab left open across a deploy reloads once on a stale-chunk error. No data, setting or screen change.
