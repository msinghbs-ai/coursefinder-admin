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

## Central policy approvals (25 Oct 2026)

Platform Admin 25 Oct 2026 11:34: "Settings › Provider policies does not exist in the UI … 1. WHERE IS THE QUEUE … 2. UNBLOCK ME TODAY: export the current policy proposals as a list … and give me a count-guarded paste file … that approves the ones I mark. … Do NOT build a new panel for this yet."

### 1. Where the queue is

**It has a screen, but nothing that points to it leads there.** Exact navigation (Platform Admin role):

1. **Layer 2/3 Build & enrich › Operations** tab.
2. Scroll below the stage table to the collapsed panel **"Approvals waiting (all universities): 65"** and open it.
3. It shows Fee schedules, then the policy list: the buttons **English policies** | **Academic calendars**, with **Show: Waiting**. Tick rows, then **Approve selected** / **Reject selected**, or approve one at a time (calendars let you edit the months first).
4. For one university only: **Layer 2/3 Build & enrich › Build adapter** (Adapter builder 1.3) for that university shows the same list scoped to it.

Checked live 25 Oct 00:38 UTC as the Platform Admin: the panel's count read (`admin_provider_onboarding` read) returns 65 in 0.16 s; the list read (`admin_provider_policies_read`) returns 16 English and 49 calendar documents waiting in under 0.1 s. Source: `src/Layer23Operations.jsx` line 67 (`<Approvals>`, rank ≥ 4), `src/ProviderOnboarding.jsx` `Approvals`, `src/ProviderPolicies.jsx`.

**Defect D-L4-1 (recorded; fix goes in the follow-on UI mandate, no new panel now): the approval queue for a lane that admits whole-provider defaults is not reachable from any signpost, so it aged without anyone seeing it.**

| # | Signpost | What it says | Fact |
|---|---|---|---|
| a | INDEX "Decisions awaiting Platform Admin" #1 | Settings › Provider policies | Never existed. My error; corrected in INDEX today |
| b | Layer 4 Inbox item "central_to_approve" (`svc_central_ai_record`) | Adapter builder (1.3) or **Providers › Onboarding › Approvals waiting** | The Onboarding tab is retired; the panel moved to Layer 2/3 › Operations |
| c | Gap cause (`gap_causes_snapshot_v1`) | a person approves the university rule (**Layer 4 › Attributes**) | Layer 4 › Attributes retired in v2.15.253 |
| d | Layer 4 Inbox count | 2 "central to approve" items | 65 proposals were waiting: the Inbox counts onboarding stops, not proposals |
| e | The panel itself | Collapsed, below the stage table, a count only | No oldest-waiting age, no link from the Inbox or the Decisions list |

Fix for the follow-on UI mandate (a chip or tab on an existing surface, as instructed): a Layer 4 Inbox kind "Central policy" that counts every waiting proposal, shows the oldest waiting and opens the Operations panel; correct texts b and c; the panel header shows the oldest waiting date.

**Related finding, for your decision (nothing changed):** job `policy-auto-approve` runs every 10 minutes with `central.auto_approve` = true and `central.auto_approve_english_all` = true. AI-read English policies for every university (and AI-read calendars for focus-list universities) are approved **with no person**, unless at least 10 compared course pages exist and more than 50% disagree. That is a whole-provider default admitted automatically, which sits against the 23:17 mandate ("NOTHING in Layer 4 auto-resolves into production"). It comes from your decisions of 15 Oct and 23 Oct 12:40, so I have left it running. Options: keep it, or set `central.auto_approve` off (Settings › Pipeline settings) so every policy comes through this list. The 65 below are the ones that lane does not take: 10 English policies parsed without AI, 6 AI-read English policies it refused (pages disagree), and 49 AI-read calendars outside the focus list.

### 2. The list: 65 waiting (live 25 Oct 2026 00:50 UTC)

| | Rows | Courses it would fill | Note |
|---|---|---|---|
| English | 16 | 140 | 7 are **BLOCKED** (most course pages disagree: R01 R02 R03 R04 R07 R15 R16). The function refuses to approve them (30 of the 140). 3 have no default (R05 R12 R13), so approving fills 0 |
| Calendar | 49 | 42 | 21 give an Intake 1 month; 8 of them fill courses (R18 R28 R35 R39 R59 R61 R64 R65). 28 say "no Intake 1 month found": approving adds nothing, and the paste refuses them |
| **Total** | **65** | **182** | Calendar fills happen only when job `provider-calendar-defaults` runs. **It is OFF** (last run 22 Oct 11:43 UTC; INDEX decision 4) |

"Courses it would fill":
- **English:** the plan's "Will be added" count, worked out 24 Oct about 22:xx UTC and worked out again at approval. It covers active courses with no English requirement, and holds back research degrees, double degrees and named courses.
- **Calendar:** active courses with an official page, no intake, no hand lock and no waiting intake review. For universities this is undergraduate levels only (`calendar.university_levels`).
- **Plan / scope:** for English, how many course pages agree or differ, and how many are held or waiting; for calendars, which levels it applies to.

The quote is the policy's IELTS line where one exists, otherwise its first requirement. For calendars it is the Intake 1 and 2 lines. Quotes are cut at 220 characters.

| Ref | Provider | Ctry | Kind | Proposed policy | Courses it would fill | Plan / scope | Days waiting | Evidence quote (from the page) | Page | Proposal id |
|---|---|---|---|---|---|---|---|---|---|---|
| R01 | Charles Sturt University | AU | English | Undergraduate: IELTS 6 (bands 5.5+); Research: IELTS 6.5 (bands 6+); Postgraduate: IELTS 6 (bands 6+) · caveats: read_by_ai | 5 | agree 5, differ 49, held 5, waiting 3 · BLOCKED (most pages differ) | 1 | "for undergraduate courses have obtained an Academic IELTS or equivalent within the last 2 years with: 1. a minimum overall score of 6.0 2. no individual score below 5.5" | https://study.csu.edu.au/international/how-to-apply/course-entry-requirements | `af62d48d-4738-4853-bcfd-c4b177f2b0a4` |
| R02 | Deakin University (Deakin) | AU | English | Undergraduate: IELTS 5.5; Research: IELTS 6; Postgraduate: IELTS 6 · caveats: read_by_ai | 0 | agree 0, differ 239, held 13, waiting 0 · BLOCKED (most pages differ) | 1 | "/ 5.5 / 10 weeks / - Most Deakin University undergraduate programs<br>- Deakin Study Abroad and Exchange programs /" | https://www.deakin.edu.au/international-students/entry-requirements/english/dueli/english-courses | `19b3df33-2479-4a05-ac89-40c3e6270643` |
| R03 | Edith Cowan University | AU | English | Undergraduate: IELTS 6 (bands 6+); Postgraduate: IELTS 6 (bands 6+) · caveats: read_by_ai | 1 | agree 75, differ 78, held 18, waiting 0 · BLOCKED (most pages differ) | 1 | "IELTS Academic (including IELTS Academic UKVI) - Overall band minimum score of 6.0 (no individual band less than 6.0). Results are valid for two years" | https://www.ecu.edu.au/future-students/course-entry/english-proficiency-bands | `583ef052-894e-4491-8ccb-15b96094ad65` |
| R04 | Excelsia University College | AU | English | Undergraduate: IELTS 6; Postgraduate: IELTS 6 · caveats: read_by_ai | 4 | agree 12, differ 24, held 8, waiting 0 · BLOCKED (most pages differ) | 1 | "Comparative scores for recognised tests are included below:  /     /     /     / / --- / --- / --- / / **IELTS Academic** / **PTE Academic** / **Cambridge English: Advanced (CAE)** / / 6 / 50 / 52 /" | https://excelsia.edu.au/study/future-students/ | `fc68fe15-81ad-42f4-ab8a-e0e61b770217` |
| R05 | Taylors College Sydney | AU | English | (no default) · 93 named courses, 142 exceptions held back | 0 | agree 0, differ 0, held 1, waiting 0 | 1 | "Bachelor of Advanced Computing / USFP Standard Entry Requirements IELTS: 5.5 (5.5)" | https://www.taylorssydney.edu.au/wp-content/uploads/taylors-college-sydney-updated-usfp-english-language-requirements.pdf | `eed0d521-5a7b-4f65-8eaa-fbeb66305f52` |
| R06 | Alberta University of the Arts | CA | English | Undergraduate: Cambridge 176, DET 120, IELTS 6.5, PTE 56, TOEFL iBT 83 (bands 20+); Postgraduate: Cambridge 176, DET 120, IELTS 6.5, PTE 56, TOEFL iBT 83 (bands 20+) · caveats: level_not_stated | 5 | agree 0, differ 0, held 0, waiting 0 | 1 | "International English Language Test (IELTS) (external link)- An overall score of 6.5 or higher." | https://www.auarts.ca/future-students/how-to-apply/how-to-apply-for-a-bachelors-degree/academic-requirements/english-requirements-for-bachelors-degree | `6bf0ea88-b07c-4a1b-94f6-0fe46471bf9b` |
| R07 | Algonquin College | CA | English | Undergraduate: IELTS 9; Postgraduate: IELTS 9 · caveats: level_not_stated | 4 | agree 0, differ 20, held 34, waiting 0 · BLOCKED (most pages differ) | 1 | "The IELTS nine (9) band score system grades scores consistently." | https://training.algonquincollege.com/ielts-test-centre | `fb0fd396-9351-49f5-81f0-004094cbf5f5` |
| R08 | British Columbia Institute of Technology | CA | English | Undergraduate: DET 105, IELTS 6, PTE 52, TOEFL iBT 82; Postgraduate: DET 105, IELTS 6, PTE 52, TOEFL iBT 82 · caveats: level_not_stated | 28 | agree 0, differ 1, held 1, waiting 0 | 1 | "IELTS test with an overall score of 6.0 or greater" | https://www.bcit.ca/flexible-learning/part-time-courses-programs/part-time-course-requirements-registration/flexible-learning-english-language-proficiency | `77e95e3e-bcd7-4740-b7ad-ed158421b329` |
| R09 | Olds College | CA | English | Undergraduate: DET 110, IELTS 6 (bands 6+), PTE 55; Postgraduate: DET 110, IELTS 6 (bands 6+), PTE 55 · 1 named courses, 0 exceptions held back · caveats: level_not_stated | 1 | agree 0, differ 0, held 0, waiting 0 | 1 | "International English Language Testing System(IELTS - Academic Stream) - a score of 6.0 or higher in each band" | https://www.oldscollege.ca/admissions/international-admissions/english-language-proficiency.html | `3e109692-b1dd-4ab7-b3c6-47a0c23aff36` |
| R10 | Royal Roads University | CA | English | Undergraduate: IELTS 6.5 (bands 6+), TOEFL iBT 88 (bands 20+), PTE 60 (bands 58+), DET 120 · 1 named courses, 0 exceptions held back · caveats: higher_unlisted | 9 | agree 0, differ 0, held 22, waiting 0 | 1 | "IELTS-Academic: 6.5 overall with no single band score less than 6.0" | https://www.royalroads.ca/admission/english-language-requirements | `55602cfd-f2c9-4706-993d-28ad1683ac76` |
| R11 | Thompson Rivers University | CA | English | Undergraduate: IELTS 5; Postgraduate: IELTS 5 · 1 named courses, 0 exceptions held back · caveats: level_not_stated, higher_unlisted | 66 | agree 0, differ 2, held 2, waiting 6 | 1 | "The FCE(First Certificate in English) will be considered at the IELTS 5.0+ for placement purposes." | http://www.tru.ca/truworld/future-students/english-requirements.html | `70e19f28-d877-42a6-a50e-b550ac3f6347` |
| R12 | New Zealand Aviation Academy Limited | NZ | English | (no default) · 1 named courses, 1 exceptions held back | 0 | agree 0, differ 0, held 2, waiting 0 | 1 | "ond language (ESOL), applicants are required to meet a minimum English score of IELTS 5.5 (with no bands under 5.0) for the Level 5 training course, and minimum English score of IELTS 6.0 (with no bands under 5.5) for th" | https://newzealandaviation.co.nz/students/english-requirement | `7e3c9d20-b11c-4df8-85f1-47abb43c72b6` |
| R13 | Southern Institute of Technology | NZ | English | (no default) · 81 named courses, 3 exceptions held back | 0 | agree 0, differ 0, held 207, waiting 0 | 1 | "nrolled Nursing programmes where International students are required to provide IELTS 6.5 across all bands." | https://www.sit.ac.nz/Home/FAQs/International-FAQs/PID/7327/evl/0/CategoryID/125/CategoryName/Studying-English-English-Language-Requirements | `8fd76b8c-698c-47ff-a0eb-d8c73349958a` |
| R14 | The New Zealand Chiropractic Education Trust Board | NZ | English | Undergraduate: IELTS 7.5 (bands 7+); Postgraduate: IELTS 7.5 (bands 7+) · caveats: level_not_stated | 1 | agree 0, differ 0, held 0, waiting 0 | 1 | "The New Zealand Chiropractic Board requires registered chiropractors to have an IELTS overall score of 7.5, with no individual score under 7.0." | https://chiropractic.ac.nz/study-with-us/international-students/english-language-requirements | `37750352-7443-4f1f-b1de-ef0afa44e42b` |
| R15 | Toi Ohomai Institute of Technology | NZ | English | Undergraduate: IELTS 6 (bands 6+); Postgraduate: IELTS 7 (bands 7+) · caveats: read_by_ai | 15 | agree 5, differ 10, held 126, waiting 0 · BLOCKED (most pages differ) | 1 | "New Zealand Diploma in Early Childhood Education and Care (Level 5) / IELTS Academic score of 6.0 with no band score lower than 6.0 is required, or an equivalent relevant English Proficiency Outcome as outlined in NZQF-r" | https://www.toiohomai.ac.nz/sites/default/files/inline-files/English%20Requirement-%20ECE.pdf | `f55a6c52-c498-46b5-bf1f-034b77e62e40` |
| R16 | Whitireia and WelTec | NZ | English | Undergraduate: IELTS 5.5 (bands 5+); Research: IELTS 6.5 (bands 6+); Postgraduate: IELTS 6 (bands 5.5+) · caveats: read_by_ai | 1 | agree 1, differ 33, held 81, waiting 0 · BLOCKED (most pages differ) | 1 | "Academic score of 5.5 with no band score lower than 5" | https://www2.nzqa.govt.nz/assets/About-us/Our-rules-fees-and-policies/NZQA-Rules/2025/Table-for-internationally-recognised-English-proficiency-outcomes-for-international-students.pdf | `01d457be-ba69-481a-bfa8-9159e36a9bdf` |
| R17 | AIH Higher Education | AU | Calendar | no Intake 1 month found · read: winter school Jul, semester 2, block 5 Aug, semester 2, block 6 Sep, semester 2, block 7 Oct, semester 2, block 8 Nov, summer school Jan, semester 1, block 1 Feb, semester 1, block 2 Mar, semester 1, block 3 Apr, semester 1, block 4 May | 0 | college: all levels | 1 | "(no quote stored)" | https://aih.edu.au/students/important-dates/ | `1543e9a0-ce95-41aa-ab35-ca7120158ed9` |
| R18 | Alphacrucis College | AU | Calendar | Intake 1 Feb, Intake 2 Apr (from terms) · read: term 1 Feb, term 2 Apr, term 3 Jul, term 4 Nov | 6 | college: all levels | 1 | "Term 1  February / March / Term 2  April" | https://www.ac.edu.au/key-dates/ | `0a811d85-cdee-4f83-939a-0e5a255621df` |
| R19 | Australian College of Applied Professions, ACAP University College | AU | Calendar | Intake 1 Feb, Intake 2 May (from trimesters) · read: trimester 1 Feb, trimester 2 May, trimester 3 Sep | 0 | university: undergraduate levels only | 1 | "Teaching weeks: Mon 2 Feb – Fri 1 May / Teaching weeks: Mon 8 Feb – Fri 30 Apr / Teaching weeks: Mon 25 May – Fri 21 Aug / Teaching weeks: Mon 31 May – Fri 20 Aug" | https://www.acap.edu.au/student-resources/key-dates/ | `1c7f1fdf-2a06-41c6-a64b-1853330fffdd` |
| R20 | Australian College of Applied Professions, ACAP University College | AU | Calendar | Intake 1 Feb (from trimesters) · read: trimester 1 Feb | 0 | university: undergraduate levels only | 1 | "Trimester 1, 2027 orientation week runs from Monday February 1 to Thursday February 4 2027 - mark it in your calendar!" | https://www.acap.edu.au/student-resources/new-students/orientation-essential-information/ | `370d3c63-3c39-4d9f-b114-7ae415c85b88` |
| R21 | Charles Darwin University | AU | Calendar | no Intake 1 month found · read: semester 3 2025 Nov, semester 1 2026 Mar, term 1 2026 Feb | 0 | university: undergraduate levels only | 1 | "(no quote stored)" | https://www.cdu.edu.au/international/how-apply | `6a72b2d2-88bd-462a-ab2c-341b203499a1` |
| R22 | Charles Sturt University | AU | Calendar | Intake 1 Jan (from terms) · read: micro-session 6 Oct, year-long period 6 Nov, year-long period 5 Nov, session 3 Nov, term 1 Jan | 0 | university: undergraduate levels only | 1 | "11 January 2027 / 2027 Term 1 Begins / **Term code:** Session 1," | https://about.csu.edu.au/our-university/important-dates | `cdfedefa-0a14-4288-a4a0-77323c07c326` |
| R23 | Deakin University (Deakin) | AU | Calendar | Intake 1 Mar, Intake 2 Jul (from trimesters) · read: trimester 1 Mar, trimester 2 Jul, trimester 3 Nov | 0 | university: undergraduate levels only | 1 | "Trimester 1: 2 March - 12 June / Trimester 1: 1 March - 21 May / Trimester 2: 6 July - 16 October / Trimester 2: 5 July - 24 Sept" | https://leadership.deakin.edu.au/academic-calendars | `9d6eccfb-c264-41b2-86c9-803acf2aeeb5` |
| R24 | Deakin University (Deakin) | AU | Calendar | Intake 1 Mar, Intake 2 Jul (from trimesters) · read: trimester 2 Jul, trimester 3 Nov, trimester 1 Mar | 0 | university: undergraduate levels only | 1 | "Trimester 2, 2026. The teaching period begins Monday 6 July. / Monday 2 March / Trimester 1 teaching period begins" | https://www.deakin.edu.au/study/key-dates | `b9a73c0b-5075-4791-8f5f-2d9242f28016` |
| R25 | Edith Cowan University | AU | Calendar | no Intake 1 month found · read: summer session Jan, semester 1 orientation Feb, semester 1 lectures commence Feb, semester 2 orientation Jul, semester 2 lectures commence Jul | 0 | university: undergraduate levels only | 1 | "(no quote stored)" | https://intranet.ecu.edu.au/student/dates-and-events/important-dates | `0f3a8e06-2f1d-4ff2-b424-d05c6dad0979` |
| R26 | Edith Cowan University | AU | Calendar | no Intake 1 month found · read: study period 1 Jan, study period 2 Mar, study period 3 May, study period 4 Jun, study period 5 Aug, study period 6 Oct | 0 | university: undergraduate levels only | 1 | "(no quote stored)" | https://studyonline.ecu.edu.au/academic-calendars | `7d7ae52f-7ef0-4b3e-b8ac-aaf97405e1f4` |
| R27 | Edith Cowan University | AU | Calendar | no Intake 1 month found · read: semester 2, 2026 Jul | 0 | university: undergraduate levels only | 1 | "(no quote stored)" | https://www.ecu.edu.au/future-students/applying/important-dates | `935f6575-1137-444b-9270-1a000db3c351` |
| R28 | EQUALS International | AU | Calendar | Intake 1 Jan, Intake 2 May (from trimesters) · read: trimester 1 Jan, trimester 2 May, trimester 3 Sep | 4 | college: all levels | 1 | "first intake in January / Study period / 9 Jan – 31 Mar 2023 / second intake in May / Study period / 08 May – 31 Jul 2023" | https://equals.edu.au/wp-content/uploads/2023/10/hsh.pdf | `82a20a7a-1916-4c8a-916d-4996f5195dc7` |
| R29 | EQUALS International | AU | Calendar | no Intake 1 month found · read: higher ed orientation 1 Jan, higher ed orientation 2 Apr, higher ed orientation 3 Aug, vet orientation 1 Jan, vet orientation 2 Apr, vet orientation 3 Jul, vet orientation 4 Oct | 0 | college: all levels | 1 | "(no quote stored)" | https://equals.edu.au/orientation-dates/ | `874811ec-563f-458e-b5f5-cac2029f1709` |
| R30 | EQUALS International | AU | Calendar | no Intake 1 month found · read: diploma of nursing feb intake Feb, diploma of nursing may intake May, diploma of nursing oct intake Oct, diploma of nursing jun intake Jun, diploma of nursing aug intake Aug | 0 | college: all levels | 1 | "(no quote stored)" | https://equals.edu.au/forms-and-downloads/ | `b490630a-8818-4d47-a288-186eb66aa73e` |
| R31 | Excelsia University College | AU | Calendar | no Intake 1 month found · read: november intake Nov, april intake Apr, september intake bece Sep, september intake grad dip of early child Sep, april intake grad dip of early childhood Apr, november intake grad dip of early childh Nov, november intake bachelor of early childh Nov | 0 | university: undergraduate levels only | 1 | "(no quote stored)" | https://excelsia.edu.au/current-students/calendar/ | `ec0dbcd0-73cb-4bb4-88ee-18e356fc2eea` |
| R32 | Holmesglen, Holmesglen Institute | AU | Calendar | no Intake 1 month found · read: semester one Feb/Mar | 0 | college: all levels | 1 | "(no quote stored)" | https://www.holmesglen.edu.au/content/dam/holmesglen/pdf/study-with-us/HE-Courses-Academic-Calendar.pdf | `99e68070-645b-46f8-9cc8-a284fd51ea3e` |
| R33 | JMC Academy | AU | Calendar | Intake 1 Feb, Intake 2 Jun (from trimesters) · read: trimester 1 Feb, trimester 2 Jun, trimester 3 Sep, semester 1 Feb, semester 2 Aug | 0 | college: all levels | 1 | "Trimester commences 9th February 2026 / Trimester commences 1st June 2026" | https://www.jmcacademy.edu.au/international/intake-dates-study-modes/ | `041a5015-168f-4387-b0fb-31cb2198f17b` |
| R34 | JMC Academy | AU | Calendar | Intake 1 Jun, Intake 2 Sep (from trimesters) · read: trimester 1 Jun, trimester 2 Sep, trimester 3 Feb, trimester 4 Jun, trimester 5 Sep, semester 1 Aug, semester 2 Feb, semester 3 Aug | 0 | college: all levels | 1 | "Trimester Starts: 1 June 2026 / Trimester Starts: 21 September 2026" | https://www.jmcacademy.edu.au/study-at-jmc/intake-and-census-dates/ | `2eeb93f6-f684-4b03-a3f3-1daf00a8f9ec` |
| R35 | Kaplan Business School Pty Ltd | AU | Calendar | Intake 1 Mar (from trimesters) · read: trimester 1 Mar | 4 | college: all levels | 1 | "Start of teaching date / 16 Mar / Start of teaching date / 15 Mar" | https://www.kbs.edu.au/documents/academic-calendar | `2c1b833a-729d-4e62-a9b3-79fcc86160bf` |
| R36 | Kaplan Business School Pty Ltd | AU | Calendar | no Intake 1 month found · read: trimester 1x May, trimester 2x Sep, trimester 3x Dec | 0 | college: all levels | 1 | "(no quote stored)" | https://www.kbs.edu.au/admissions/important-dates/accelerated-trimesters | `c582bbb5-1d7a-4b78-aa35-43464a9eb1cd` |
| R37 | Kent Institute Australia | AU | Calendar | no Intake 1 month found · read: trimester t1 s 2024 May, trimester t2 2024 Jul | 0 | college: all levels | 1 | "(no quote stored)" | https://kent.edu.au/academic-calendar/ | `7e8f7de3-49a2-4287-9396-68cc37545d68` |
| R38 | Kent Institute Australia | AU | Calendar | no Intake 1 month found · read: semester 1 term 1 Jan, semester 2 term 2 Apr, semester 2 term 3 Jul, semester 2 term 4 Oct | 0 | college: all levels | 1 | "(no quote stored)" | https://kent.edu.au/wp-content/uploads/DOC-Academic-Calendar-VET-2026.pdf | `9d1f6550-cfd3-4bb3-97b1-31274a0536ea` |
| R39 | Melbourne Polytechnic | AU | Calendar | Intake 1 Jan, Intake 2 Apr (from terms) · read: term 2 Apr, term 3 Jul, semester 2 orientation Jul, term 4 Oct, term 1 Jan/Feb, semester 1 orientation week Feb, semester 2 orientation week Jul | 3 | college: all levels | 1 | "Mon 12 Apr - Term 2 Commences / Mon 20 Apr - Term 2 Commences / Tue 22 Apr - Term 2 Commences / Mon 2 Feb - Term 1 Commences / Tue 28 Jan - Term 1 Commences / Tue 30 Jan - Term 1 Commences" | https://www.melbournepolytechnic.edu.au/students/academic-calendars/vet-calendar/ | `42ed476b-2009-4ac9-82a7-401ee58cd637` |
| R40 | SAE University College | AU | Calendar | Intake 1 Feb (from trimesters) · read: trimester 1 Feb | 0 | university: undergraduate levels only | 1 | "Trimester 1 1-5 February 2027" | https://sae.edu.au/current-students/orientation-key-dates/ | `8f7caf33-798f-40ea-8c20-52838ca96621` |
| R41 | SAE University College | AU | Calendar | Intake 1 Feb, Intake 2 May (from trimesters) · read: trimester 1 Feb, trimester 2 May, trimester 3 Sep | 0 | university: undergraduate levels only | 1 | "Monday 2 February 2026 / Monday 25 May 2026" | https://sae.edu.au/wp-content/uploads/2025/12/2026-Academic-Calendar.pdf | `b70124eb-7d74-4095-a5cc-20f814b08b35` |
| R42 | Stanley College | AU | Calendar | Intake 1 Mar, Intake 2 Aug (from semesters) · read: semester 1 Mar, semester 2 Aug, semester 3 Nov | 0 | college: all levels | 1 | "9 March 2026 / 8 March 2027 / 24 August 2026 / 23 August 2027" | https://www.highereducation.stanleycollege.edu.au/course/bachelor-of-business/ | `17e910b1-56bc-443a-bfca-34e0891d216b` |
| R43 | Stanley College | AU | Calendar | no Intake 1 month found · read: semester 1, 2026 Mar, semester 2, 2026 Aug, summer semester, 2026 Nov, semester 1, 2027 Mar, semester 2, 2027 Aug, summer semester, 2027 Nov | 0 | college: all levels | 1 | "(no quote stored)" | https://www.highereducation.stanleycollege.edu.au/essential-information/important-dates/ | `c531eca8-e370-4731-a7e3-dbe1e4cb94da` |
| R44 | TAFE International Western Australia | AU | Calendar | Intake 1 Feb, Intake 2 Jul (from semesters) · read: semester 1 Feb, semester 2 Jul | 0 | college: all levels | 1 | "Semester 1 2026 Monday 2 February – Friday 3 July / Semester 2 2026 Monday 20 July – Friday 11 December" | https://www.tafeinternational.wa.edu.au/tafe-courses/key-dates | `d1690205-9261-413f-b644-14196f4bb754` |
| R45 | TAFE Queensland | AU | Calendar | no Intake 1 month found · read: online intake 1 Jan, online intake 2 Mar, online intake 3 Apr, online intake 4 Jun, online intake 5 Jul, online intake 6 Sep, online intake 7 Nov | 0 | college: all levels | 1 | "(no quote stored)" | https://tafeqld.edu.au/content/dam/tafe/en/documents/pdfs/current-students/academic-calendar/academic-calendar-2026.pdf | `3089db6c-69fb-4386-a209-f1e71f482eb7` |
| R46 | TAFE Queensland | AU | Calendar | no Intake 1 month found · read: semester 1 2027 Jan, april 2027 intake Apr, semester 2 2027 Jul | 0 | college: all levels | 1 | "(no quote stored)" | https://tafeqld.edu.au/international/how-to-apply/application-process/key-dates | `3751fea8-8d78-42d2-8042-5cf80983d5b5` |
| R47 | The Australian College of Physical Education | AU | Calendar | Intake 1 Mar, Intake 2 Aug (from semesters) · read: semester 2 Aug, semester 1 Mar | 0 | college: all levels | 1 | "3 August 2026 (Semester 2) / 1 March 2027 (Semester 1)" | https://acpe.edu.au/courses/bachelor-of-physical-activity-for-health-pathway-to-education/ | `5633d6a8-5360-403e-bab7-24ce7e77c2de` |
| R48 | The Australian College of Physical Education | AU | Calendar | Intake 1 Mar, Intake 2 Aug (from semesters) · read: semester 1 Mar, semester 2 Aug, quadmester 4 Oct, quadmester 1 Feb, quadmester 2 Apr, quadmester 3 Jul | 0 | college: all levels | 1 | "Semester 1 – Monday 1 March 2027 / Semester 1 / 2 March / Semester 2 – Monday 2 August 2027 / Semester 2* / 3 August" | https://acpe.edu.au/admissions/acpe-key-intake-dates/ | `843364e9-7cbc-4bc2-a542-5e8f9460e7fb` |
| R49 | UNSW College | AU | Calendar | no Intake 1 month found · read: standard term 1 Mar, standard term 2 Jul/Sep | 0 | college: all levels | 1 | "(no quote stored)" | https://my.unswcollege.edu.au/content/dam/pdfs/unsw-college/calendars/2026-a-std-march-intake.pdf | `83827850-bc38-4e39-841a-6583a3299bc9` |
| R50 | UTS College | AU | Calendar | no Intake 1 month found · read: welcome week Feb | 0 | college: all levels | 1 | "(no quote stored)" | https://utscollege.edu.au/current-students/new-student/student-orientation/academic-programs-welcome-week | `7bf2ca8f-11dd-45ff-a88d-27dde5dc97fb` |
| R51 | Victoria University | AU | Calendar | no Intake 1 month found · read: study block 1 Jan, study block 2 Mar, study block 3 May, study block 4 Jun, study block 5 Aug, study block 6 Oct | 0 | university: undergraduate levels only | 1 | "(no quote stored)" | https://online.vu.edu.au/academic-calendar | `6585c2bb-e8ef-49f6-b449-fcb29eabba62` |
| R52 | VIT (Victorian Institute of Technology) | AU | Calendar | no Intake 1 month found · read: mba 241 intake – 1 Jan, mba 242 intake – 2 Mar, mba 243 intake – 3 May, mba 244 intake – 4 Jul, mba 245 intake – 5 Aug, mba 246 intake – 6 Oct, term 1 (mba 251 intake – 1) Jan, term 2 (mba 252 intake – 2) Mar, term 3 (mba 253 intake – 3) May, term 4 (mba 254 intake – 4) Jun, term 5 (mba 255 intake – 5) Aug, term 5s (mba 255 intake – 5s) Oct, term 6 (mba 256 intake – 6) Oct, term 1 (mba 261 intake – 1) Jan, term 2 (mba 262 intake – 2) Mar, term 3 (mba 263 intake – 3) May, term 4 (mba 264 intake – 4) Jun, term 5 (mba 265 intake – 5) Aug, term 6 (mba 266 intake – 6) Oct | 0 | college: all levels | 1 | "(no quote stored)" | https://vit.edu.au/key-dates/higher-education-offshore | `ceea22ed-bffb-4277-aba1-c6a0e5280f66` |
| R53 | Athabasca University | CA | Calendar | no Intake 1 month found · read: fees effective period start Sep, fees effective period end Aug | 0 | university: undergraduate levels only | 1 | "(no quote stored)" | https://www.athabascau.ca/calendar/undergraduate/fees-refunds-and-financial-assistance/students-outside-canada.html | `f0de3c99-3022-47a8-b5a9-e823ba307262` |
| R54 | Humber College | CA | Calendar | no Intake 1 month found · read: fall 2026 Sep, winter 2027 Jan | 0 | college: all levels | 1 | "(no quote stored)" | https://humber.ca/study-at-humber/attend/academic-calendar | `44c836c3-5aa8-4b5e-b168-00d8f76a08c6` |
| R55 | Niagara College Canada | CA | Calendar | no Intake 1 month found · read: fall 2026 semester Sep | 0 | college: all levels | 1 | "(no quote stored)" | https://www.niagaracollege.ca/dualcredit/dates | `a937a2fc-c4d8-4b72-a156-d461ec916aff` |
| R56 | University of Lethbridge | CA | Calendar | no Intake 1 month found · read: summer May, fall Sep, winter Jan | 0 | university: undergraduate levels only | 1 | "(no quote stored)" | https://www.ulethbridge.ca/ross/admissions/grad/deadlines | `a2e15bb1-9438-4755-8dbf-ea8984a2084e` |
| R57 | University of Northern British Columbia | CA | Calendar | no Intake 1 month found · read: september semester Sep, may semester May, spring intersession May | 0 | university: undergraduate levels only | 1 | "(no quote stored)" | https://www.unbc.ca/calendar/undergraduate/semester-dates | `e8ecc463-ba95-4279-9914-a0caaefbc089` |
| R58 | University of the Fraser Valley | CA | Calendar | no Intake 1 month found · read: fall semester Sep, winter semester Jan, summer semester full session May, summer semester early session May, summer semester late session Jul | 0 | university: undergraduate levels only | 1 | "(no quote stored)" | https://www.ufv.ca/calendar/current/General/ScheduleOfEvents.htm | `a3e262df-0a47-4d58-ad39-7348c51216e0` |
| R59 | Auckland University of Technology | NZ | Calendar | Intake 1 Feb, Intake 2 Jul (from semesters) · read: semester 1 Feb, semester 2 Jul, summer school Nov | 10 | university: undergraduate levels only | 1 | "23 February  First day of classes / 22 February  First day of classes / 13 July  First day of classes / 12 July  First day of classes" | https://www.aut.ac.nz/study/semester-dates | `1be2ae79-4bbf-4587-9163-df81f5f61579` |
| R60 | Eastern Institute of Technology | NZ | Calendar | no Intake 1 month found · read: semester 2 Jul, term 3 Jul | 0 | college: all levels | 1 | "(no quote stored)" | https://www.eit.ac.nz/wp-content/uploads/programme-app-packs/int%20Programme%20Matrix.pdf | `1a713574-ca21-4bd8-bab5-68d9424c0226` |
| R61 | Nelson Marlborough Institute of Technology (NMIT) | NZ | Calendar | Intake 1 Feb, Intake 2 Jul (from semesters) · read: semester 1 Feb, semester 2 Jul | 7 | college: all levels | 1 | "Semester 1 → 16 February - 03 July / Semester 1 → 15 February - 02 July / Semester 2 → 20 July - 27 November / Semester 2 → 19 July - 26 November" | https://www.nmit.ac.nz/study/planning-your-studies/academic-dates | `3e46d516-702a-46c7-bed7-b4d0ac581f54` |
| R62 | Otago Polytechnic | NZ | Calendar | no Intake 1 month found · read: semester 1 (term 1) Feb, semester 1 (term 2) Apr, semester 2 (term 3) Jul, semester 2 (term 4) Oct | 0 | college: all levels | 1 | "(no quote stored)" | https://www.op.ac.nz/explore/events-and-important-dates/important-dates | `8e59c178-9ab7-4002-98ef-2e3a4c2ec05b` |
| R63 | University of Waikato | NZ | Calendar | no Intake 1 month found · read: trimester a Mar, trimester b Jul, trimester c/g Nov | 0 | university: undergraduate levels only | 1 | "(no quote stored)" | https://www.waikato.ac.nz/about/calendar/important-dates/teaching-and-assessment-periods/ | `486f6992-6478-4416-8b6c-ed8a230ceb9f` |
| R64 | Victoria University of Wellington | NZ | Calendar | Intake 1 Feb, Intake 2 Jul (from trimesters) · read: trimester 1 Feb, trimester 2 Jul, trimester 3 Nov | 2 | university: undergraduate levels only | 1 | "Classes start for all students—23 February 2026 / Classes start for all students—6 July 2026" | https://www.wgtn.ac.nz/international/prepare-to-study/orientation/orientation-and-start-dates | `bb8d01db-8bd4-4264-8e1f-bd2b32b1adf0` |
| R65 | Western Institute of Technology at Taranaki (WITT) | NZ | Calendar | Intake 1 Feb, Intake 2 Jul (from semesters) · read: semester 1 Feb, semester 2 Jul | 6 | college: all levels | 1 | "Semester 1: Monday, 23 February – Friday, 3 July / Semester 1: Monday, 22 February – Friday, 2 July / Semester 2: Monday, 20 July – Friday, 27 November / Semester 2: Monday, 19 July – Friday, 26 November" | https://www.witt.ac.nz/information-and-enrolment/domestic/important-dates/ | `7f4db07f-87f2-4b1c-9bef-e4c5f1260ae5` |

The table was generated in the database and transcribed here; the transcription was checked byte for byte against the database's md5 (`3d53a2d00aa9061f94235a1e030f4110`, 65 rows).

**My read, to help you mark (you decide; nothing is applied):**
- **Reject (wrong page or not an admission rule):**
  - R07 Algonquin: an IELTS test-centre page; the "9" is the band scale.
  - R11 Thompson Rivers: an FCE placement line. It is not an admission requirement, and it would write IELTS 5 to 66 courses.
  - R08 BCIT: a part-time / flexible-learning page; check it before it reaches 28 full-time courses.
  - R16 Whitireia and WelTec: the national NZQA table, not the provider's policy.
  - R02 Deakin: the DUELI English-course page.
- **Likely approve:**
  - English: R06 Alberta University of the Arts (IELTS 6.5, bachelor page), R09 Olds, R10 Royal Roads.
  - Calendars: R59 AUT, R61 NMIT, R64 Victoria University of Wellington, R65 WITT, R44 TAFE International WA, R18 Alphacrucis, R35 Kaplan Business School.
- **Check first:**
  - R14 NZ Chiropractic: 7.5 is the registration board's requirement.
  - R28 EQUALS: the calendar is a 2023 PDF.
  - R39 Melbourne Polytechnic: the VET calendar.
  - R22 Charles Sturt: Term 1 in January.
  - Where a university has two calendars, approve one: R33 over R34 for JMC (R34 numbers its trimesters from June); R19 over R20 for ACAP; R23 or R24 for Deakin; R41 over R40 for SAE; R48 over R47 for ACPE; R42 for Stanley.
- **Leave or reject:** the 28 "no Intake 1 month found" calendars. Approving adds nothing; rejecting closes them until the next read.

### 3. Approval path (works today, no screen needed)

Paste file `docs/platform/ui-audit/PASTE-20261025-policy-proposals-decide.sql` (Supabase SQL editor):

1. Put `'approve'` or `'reject'` in the third column of each row you decide; leave `''` for the rest.
2. Set `v_expect_approve` / `v_expect_reject` to the counts you marked.
3. Run it.

It calls the same function as the screen (`public.admin_provider_policy_decide`) as the Platform Admin, rejects first, then approves. It is all or nothing.

Guards:
- the counts must match;
- every marked row must still be waiting;
- one approval per university and kind;
- no calendar approval without an Intake 1 month;
- any refusal by the function (for example a BLOCKED English row) rolls back everything and names the row.

The closing notice says, per row, how many courses it fills, and whether `provider-calendar-defaults` is on.

Dry runs against live, all rolled back:
- The unmarked file stops at "nothing marked" (the 65-row list parses).
- R06 + R18 + R59 approve with R07 reject decided 3 + 1; R06 fills 5; the calendar job was reported OFF.
- R17 approve was refused: no Intake 1 month.
- R01 approve was refused and everything rolled back: "This default does not match most course pages (5 agree, 49 differ)".

For the calendar approvals to fill courses, `provider-calendar-defaults` must also be switched on (Scheduled jobs, or Layer 2/3 › Operations › job list). That is INDEX decision 4 and stays your call.
