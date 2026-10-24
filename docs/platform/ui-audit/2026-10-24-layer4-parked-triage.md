# Layer 4 parked-records triage and assisted resolution — decision record

| | |
|---|---|
| Raised | Platform Admin, 24 Oct 2026 23:17 (Melbourne) |
| Change control | CF-CHG-20260915-247; this file is the decision record |
| Hard rule | **Nothing in Layer 4 auto-resolves into production.** Every resolution is a proposal the Platform Admin batch-approves. Read-only work runs alongside R2; write work waits for approvals. Budget: inside the daily Firecrawl budget and the search cap; per-kind estimates before running; stop and report at 50% of budget |
| Status | **Phase 0 census done 24 Oct 23:45 (read-only, live).** Phase 1 batches and Phase 2 build wait for approval of this file |

## Phase 0 — census (live, 24 Oct 2026 23:40)

The mandate's figures (1,975 items, 1,212 aged) were from earlier in the day. Now: **2,011 items, 1,258 older than 7 days, 12 kinds in use** (Counsellor report and Website not answering: 0).

| Kind (screen label) | Items | Aged > 7 d | Oldest | Median age (d) | Providers | AU / NZ / CA | At unpublished providers |
|---|---|---|---|---|---|---|---|
| Held scholarship | 935 | 855 | 12 Oct | 12.3 | 124 | 696 / 118 / 121 | 106 |
| Adapter has nothing ready | 312 | 212 | 12 Oct | 11.8 | 312 | 265 / 31 / 16 | 238 |
| Course link | 230 | 0 | 20 Oct | 1.0 | 36 | 8 / 146 / 76 | 1 |
| Course not on the university's site | 221 | 0 | 17 Oct | 6.6 | 4 | 221 / 0 / 0 | 0 |
| Too few course pages | 138 | 78 | 12 Oct | 12.0 | 138 | 80 / 58 / 0 | 77 |
| Course pages not found | 54 | 0 | 19 Oct | 4.7 | 54 | 51 / 0 / 3 | 45 |
| Course not offered | 49 | 49 | 17 Oct | 7.3 | 1 (ANU) | 49 / 0 / 0 | 0 |
| Website needed | 40 | 40 | 12 Oct | 12.3 | 40 | 40 / 0 / 0 | 40 |
| Adapter proposal failed | 11 | 10 | 12 Oct | 12.3 | 11 | 10 / 1 / 0 | 9 |
| Provider left the register | 10 | 10 | 28 Sep | 26.2 | 10 | 10 / 0 / 0 | 10 (all archived, 0 active courses) |
| Fee fails the check | 9 | 3 | 14 Oct | 5.7 | 8 | 9 / 0 / 0 | 4 |
| Central pages to approve | 2 | 1 | 12 Oct | 6.9 | 2 | 1 / 0 / 1 | 1 |
| **Total** | **2,011** | **1,258** | | | | | **531** |

"Course link" is four different decisions sharing one label:

| Course link — field | Items | Stored reason (example) | Already stale |
|---|---|---|---|
| Fee course-match check (`provider_current_tuition_validation`) | 108 | "Fee reader: course match not sure enough" | 6 (course now has an active fee); 12 have a page bound by hand since |
| Held fee (`provider_current_tuition`: identity quarantine, fee floor) | 75 | "quarantined for re-verification…" / "international fee below the country floor (NZD 8,000)…" | 22 (course now has an active fee); 2 bound by hand since |
| Official page (`official_course_url`) | 44 | "The course page that shows this course's CRICOS code is a different address…" | 0 |
| English (`course_english`) | 3 | | 0 |

Held scholarships, by the existing AI re-check and the original hold reason:

| Re-check result | Items | | Hold reason | Items | Stored copy |
|---|---|---|---|---|---|
| Never re-checked | 424 (100 at unpublished providers) | | "who it is for is not proven by a quote" | 528 | 461 |
| Audience not stated | 299 | | "the value is not proven by a quote" | 294 | 236 |
| Unsettled | 139 (112: page could not be read) | | "the model's reply failed: the page could not be read" | 103 | 0 |
| **International: check and publish** | **50** | | name not on the page | 4 | 4 |
| Not for international | 16 | | other model failures | 6 | 4 |
| International value unclear | 7 | | | | |

**Stale now (the condition has cleared since parking):** 34 held scholarships whose scholarship is now published and 5 whose scholarship is no longer active; 28 fee items whose course now holds an active fee; 14 fee items whose course has since been bound by hand; **217 of the 312 "nothing ready" providers now have at least 3 read pages** (the adapter can be retried). "Too few pages": 0 of 138 have gained 3 readable pages (still blocked).

### Top 20 providers by parked items

| # | Provider | Country | Items | Aged | Kinds |
|---|---|---|---|---|---|
| 1 | The University of Sydney | AU | 139 | 139 | held scholarship 139 |
| 2 | University of Wollongong | AU | 117 | 6 | not on site 111, held scholarship 6 |
| 3 | Torrens University Australia | AU | 69 | 1 | not on site 68, fee check 1 |
| 4 | Waikato Institute of Technology | NZ | 54 | 0 | course link 45, held scholarship 9 |
| 5 | Australian National University | AU | 53 | 50 | not offered 49, fee check 2, course link 1, held scholarship 1 |
| 6 | "N/A" (unnamed on the register, unpublished) | AU | 45 | 45 | held scholarship 44, website needed 1 |
| 7 | University of Auckland | NZ | 44 | 28 | held scholarship 28, course link 16 |
| 8 | Auckland University of Technology | NZ | 38 | 0 | course link 38 |
| 9 | The University of Melbourne | AU | 35 | 1 | not on site 34, held scholarship 1 |
| 10 | Simon Fraser University | CA | 34 | 2 | course link 32, held scholarship 2 |
| 11 | Massey University | NZ | 33 | 33 | held scholarship 33 |
| 12 | The University of Queensland | AU | 25 | 25 | held scholarship 25 |
| 13 | University of Lethbridge | CA | 25 | 25 | held scholarship 25 |
| 14 | RMIT University | AU | 25 | 25 | held scholarship 25 |
| 15 | RMIT University Pathways | AU | 24 | 23 | held scholarship 23, nothing ready 1 |
| 16 | Royal Roads University | CA | 24 | 24 | held scholarship 24 |
| 17 | Flinders University | AU | 22 | 22 | held scholarship 22 |
| 18 | Central Queensland University | AU | 21 | 21 | held scholarship 21 |
| 19 | University of Technology Sydney | AU | 17 | 17 | held scholarship 17 |
| 20 | Murdoch University | AU | 16 | 16 | held scholarship 16 |

### Classification per kind

| Kind | STALE (re-check now) | AI-RESOLVABLE (Firecrawl + AI, quote-on-page) | HUMAN-ONLY | OBSOLETE (close with reason) |
|---|---|---|---|---|
| Held scholarship (935) | 34 now published, 5 inactive | 50 "check and publish" (approval batch now); 16 "not for international" (refuse batch); 731 re-read of the stored copy (424 never re-checked, 299 audience, 7 value, 1 other); 103 without a stored copy need one fresh read each | Pages that state no audience after the second pass stay human (expected the bulk of the 299) | — |
| Adapter nothing ready (312) | 217 now have ≥3 read pages: retry onboarding | The adapter-build path from the proposals; 74 published first | — | 238 at unpublished providers: deprioritised, not closed (Published switch decides) |
| Course link — official page (44) | 0 | AI page match with S1 negative evidence; proposal pre-filled | — | — |
| Course link — fee course-match (108) | 6 fee now active, 12 bound by hand | AI re-read of the stored copy for the course match (quote) | Matches the AI still cannot settle | — |
| Course link — held fee (75) | 22 fee now active | Identity quarantine (8a) items: reidentify under the per-country rule | Fee-floor items (policy: a fee below the country floor is a judgement) | — |
| Course link — English (3) | — | — | Yes (3) | — |
| Not on site (221; UoW 111, Torrens 68, UniMelb 34, Adelaide 8) | — | Firecrawl map + search per provider with S1 negative evidence; AI match proposes a page | What is left after re-find: register lists it, site does not — a person decides archive (quarantine paste) | — |
| Too few pages (138) | 0 | Firecrawl map for the course-listing URL, proposed as a course-list source; 61 published first | — | 77 at unpublished providers: deprioritised |
| Pages not found (54) | — | Firecrawl map/search with negative evidence | — | 45 at unpublished providers: deprioritised |
| Not offered (49, all ANU) | — | — | — | **Platform Admin chose "archive" on 17 Oct**: quarantine paste (status change, reversible). See question 1 |
| Website needed (40) | — | Search for the official domain; identity verified before proposing | — | All 40 unpublished: last in line |
| Adapter proposal failed (11) | — | — | Surface in the next approval batch | — |
| Provider left the register (10) | Re-check the register | — | Merged-into decisions | All 10 archived, 0 active courses: close with paste if the register confirms |
| Fee fails the check (9) | Re-read under the current floors | — | What still fails becomes a floor item | — |
| Central pages to approve (2) | — | — | Surface in the next approval batch (policy approval is a person's by design) | — |

## Phase 1 — resolution designs and budget estimates (proposals only)

Ordered by age × count. AI cost from the live lanes' 14-day averages: scholarship reader US$0.0005 a page, enrich reader US$0.0006, fee reader US$0.0032. Firecrawl: search 2 credits, page 1, map 1.

| # | Kind | Path | Firecrawl | AI | Lands as |
|---|---|---|---|---|---|
| 1 | Stale sweep (all kinds) | Re-check conditions above; close the item with reason "condition cleared" | 0 | 0 | Close-batch for approval (≈ 300 items: 39 scholarships, 34 fee items, 217 onboarding retries, 9 fee-check re-reads) |
| 2 | Held scholarship | Existing scholarship AI reader (the one B4 extends; nothing built twice) over stored copies: eligibility, deadline, countries, audience with quotes; 103 without a copy get one fresh page each | ≈ 103 | ≈ US$0.40 | Approve-batch (completes) / stays with the filled fields visible (thin) |
| 3 | Course link: official page + not on site + pages not found | Firecrawl map per provider (stored maps first, ≤ 14 days old reused) and search per course under the cap; AI match proposes; quote required; S1 `page_rejections` consumed | ≈ 60 maps + ≤ 2 × 319 searches ≈ 700 (inside the 100/day cap: about a week) | ≈ US$0.20 | Pre-filled Layer 4 decisions |
| 4 | Too few pages | Map for the course-listing URL, published providers first | ≈ 61 now (138 all) | — | Course-list source proposals |
| 5 | Nothing ready | Retry the 217 with pages; adapter-build path takes over | 0 unless target | ≈ US$0.40 | Existing onboarding flow |
| 6 | Fee check | Re-read under current floors | ≤ 9 | ≈ US$0.03 | Clears or becomes a floor item |
| 7 | Not offered (ANU 49) | Quarantine paste per the 17 Oct choice (or Defect 1 hand-off — question 1) | 0 | 0 | Paste file |
| 8 | Provider left the register | Register re-check; close via paste if gone | 0 | 0 | Paste file |
| 9 | Central pages (2) + proposal failed (11) | Surfaced in the next approval batch | 0 | 0 | Your batch |
| 10 | Website needed (40, all unpublished) | Domain search + identity check | ≈ 80 | ≈ US$0.03 | Proposals (last) |

**Total ≈ 1,000 Firecrawl credits over about a week (≈ 10% of one day's share), under US$1.50 of AI.** Stop-and-report at 50% of the day's course-search share.

## Phase 2 — the learning loop (design; build after approval)

1. **Decision capture (additive).** New table `pipeline.layer4_proposals`: kind, ref, proposed choice and value, evidence quote, evidence id, model, prompt version, confidence, created at; on decision: decision (approve / reject / variant), decider, decided at, the final value. Every Layer 4 decision path writes its row (today: `layer4_decisions` for review items, `admin_control_events` for Inbox decisions — both kept). No existing table changes shape.
2. **Weekly accuracy report per kind**: AI-proposal acceptance rate, split by provider type (university / polytechnic / private / TAFE) and country; the rejected proposals with their quotes are the material for prompt refinement and few-shot examples (no fine-tuning).
3. **Auto-admit escalation (settings, off by default):** `layer4.auto_admit_threshold` (0.95), `layer4.auto_admit_min_decisions` (50), `layer4.auto_admit_cycle_days` (7), `layer4.auto_admit_sample_one_in` (10), and per kind `layer4.auto_admit.<kind>` (0). When a kind holds ≥ threshold over ≥ min decisions for a full cycle, the platform **proposes** auto-admit for that kind with 1-in-N sampling to Layer 4; the Platform Admin switches it on. A passing rate never switches anything on by itself.
4. The 1,258 aged items go first; age is itself signal (aged items that are still not stale are the human-only pool).

## The queue after (expected)

| Kind | Now | After Phase 1 (expected) | Permanently human |
|---|---|---|---|
| Held scholarship | 935 | ≈ 250–350 (pages that never state the audience or value) | Yes, for pages silent on audience |
| Nothing ready | 312 | ≈ 240 (the unpublished ones, parked until published) | No |
| Course link | 230 | ≈ 60 (fee-floor items, unsettled matches, English) | Fee-floor items: yes |
| Not on site | 221 | ≈ 80–120 (register lists, site does not) | Yes: archive is a person's choice |
| Too few pages / pages not found | 192 | ≈ 130 (mostly unpublished) | No |
| Not offered | 49 | 0 (quarantined by paste) | — |
| Website needed | 40 | ≈ 15 | No |
| Others (fee check, departures, failed proposals, central) | 32 | ≈ 15 | Central approvals and merge decisions: yes |
| **Total** | **2,011** | **≈ 800–900** | |

Kinds that will always need a person: fee-floor decisions, register-vs-site archive decisions, provider merges, central-policy approvals, counsellor reports, and scholarships whose page never states who it is for.

## Questions for the Platform Admin

1. **Not offered (49, all ANU):** the mandate hands these to Defect 1 (title verification), but Defect 1 is NZ and these are ANU programmes with your 17 Oct "archive" choice already recorded. Quarantine them by paste now, or route them through a re-find first?
2. **Approve Phase 1 batch 1:** the stale sweep (≈ 300 closes, no spend) and the 50 "check and publish" + 16 "not for international" scholarship proposals. I prepare them as paste-style proposal batches for your approval.
3. **Approve the Phase 2 design** (proposal table, weekly report, auto-admit settings off).
