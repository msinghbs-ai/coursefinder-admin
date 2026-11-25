# StudySearch Portal: running build document

**Status at the last checkpoint (26 Nov 2026 09:00 AEDT):** Release 1 is live for UAT on `studysearch-portal.techm.workers.dev`, with course search hardened (s1181). Release 2 is complete end to end: the screens (s1200 to s1202) and their database layer (s1210, live and read back as signed-in Counsellors). Awaiting the Platform Admin's proposal UAT.

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
- "Grad dip" and "grad cert" are not yet read as study levels; s1181 adds them ("adv dip" and "assoc degree" too). Done in s1181.
- An empty or stopword-only search returns every course by title (no error); after s1181 it returns no courses at once unless Study in or a provider is chosen.
- Seen in passing, another lane's work: `public.api_request_log_v1` logs fail with `request_id` uuid versus text (Postgres log 26 Nov 03:31). Not portal work.

## 7. Next executable action

Platform Admin: open Proposals on the portal (desktop and phone):
1. Create a proposal from Saved courses.
2. Edit it, mark it ready and refresh it.
3. Save from two sign-ins at once and check the clash notice.
4. Duplicate it, print the sheet and archive it.
5. Repeat the course search UAT.
6. Decide the privacy notice wording.

S2-Build: act on anything the UAT finds; draft the paste file that removes expired or privacy-requested proposals when the Platform Admin asks; record acceptance here.

## 8. Checkpoint log

- 26 Nov 2026 09:00 AEDT, S2-Build: s1210 live (Pilot #1646); read back as two signed-in Counsellors (save, get, clash with nothing written, refresh, list); G3 75/48, locks 7,585, cron 136, US$0. Release 2 complete end to end; Drive mirror replaced.
- 26 Nov 2026 08:25 AEDT, S2-Build: s1210 Release 2 proposals layer built to the screens' contract (Platform Admin decisions 07:30, brief 07:37), rehearsed as real users (rolled back), recorded before merge.

- 26 Nov 2026 05:45 AEDT, S2-Build: s1181 live (Pilot #1637); read back as a signed-in Counsellor: every spelling of "Master of Nursing in Victoria" returns the same 21 courses in about 0.55 s; G3, locks and cron unchanged; US$0. Drive mirror replaced.
- 26 Nov 2026 05:10 AEDT, S2-Build: s1181 finished and rehearsed (30 messy inputs, 0.03 to 1.55 s; 20 malformed request shapes; no error), recorded before merge.
- 26 Nov 2026 04:20 AEDT, S2-Build: document created at the Platform Admin's request (03:59). Release 1 live; s1180 live; s1181 built and rehearsed.
- 26 Nov 2026 07:15 AEDT, S1-API-Frontend-Delivery: Release 2 screens built (Pilot s1200 to s1202) and checked at 1280 px and 412 px; the contract the screens call is in the design document. The functions are S1-Build's to deploy. Read back before the PR: G3 75/48 no drift, locks 7,585, cron 138, US$0, no `portal_proposal_*` function live yet.
