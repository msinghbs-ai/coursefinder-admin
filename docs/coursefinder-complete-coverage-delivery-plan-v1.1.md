# CourseFinder — Consolidated Delivery Plan: Complete Coverage to Production

**Version:** 1.1 · **Date:** 29 September 2026 (10:45 IST) · **Status:** ACTIVE: supersedes v1.0. **Production go-live Friday 3 October 2026** (Platform Admin, 29 Sep 10:01 IST)
**Change control:** CF-CHG-20260915-247 · **Decisions:** Design Reference Decisions 162, 163, 164 · **Production runbook:** `docs/coursefinder-production-environment-runbook-v1.0.md`
**Detail:** `docs/coursefinder-course-attribute-ingestion-v1.0.md` §9 (coverage programme)

---

## 1. Executive summary

The Platform Admin's direction on 29 Sep 2026 was to cover every active Australian course and its scholarships, keep that coverage running, and report progress daily. The target is days, not weeks. This plan pulls everything in the pipeline into four short waves. It puts first the work that gets admitted data into the consumer API fastest, and it keeps the existing safeguards:
- evidence first;
- CRICOS-code identity;
- Layer 3 used only with a qualified, pinned model;
- Layer 4 for anything unsure;
- consumer API snapshots before and after every change.

## 2. Business objectives

| Objective | Measure | Target |
|---|---|---|
| Every course accounted for | Each attribute has a known state: admitted, found and awaiting admission, not published by the provider, blocked, or no website | 100% of active courses within Wave 2 |
| Admitted data in Search and the APIs | Courses with official page, English requirements, intakes and provider tuition | Grows daily; first admission batch in Wave 1 |
| Scholarships published | Scholarships meeting Decision 139, with first-party evidence | First batch in Wave 1; full provider sweep in Wave 2 |
| Ongoing, not one-off | Monthly site re-discovery, 90-day page re-reads, monthly (weekly Oct–Dec) document checks | Running from Wave 0 |
| Visible progress | Daily consumer API update and stakeholder update | 08:49 IST daily from 30 Sep 2026 |

## 3. Current position (29 Sep 2026, 09:25 IST)

| Area | Position |
|---|---|
| Courses | 25,978 active Australian courses. From CRICOS: duration 100%, campus 99.9%, registered tuition 99.3% |
| Admitted from providers | Official page 537, provider tuition 863, English 615, intakes 497 |
| Found on verified pages, awaiting admission rule | Official page 772, English 329, intakes 390, tuition 189 |
| Sweep | 1,538 providers: 109 mapped, 873 queued, 554 website search. 3,460 pages bound, 797 verified by CRICOS code |
| Scholarships | 292 collected from 90 providers; 0 published; 57 meet Decision 139 |
| Semantic search (pgvector) | Extension installed (0.8.2); no embeddings; deferred since CF-033 |
| Completeness | Per-attribute coverage states hourly (v2.15.103); the older equal-weight score is not refreshed on a schedule and not in the APIs |
| UI | 29 stylesheets, 367 distinct colours, four separate token sets, duplicated components. Looks similar but is not uniform |
| Limits | Firecrawl 100,000 credits a month (live 29 Sep; 90,245 available). OpenRouter US$29 prepaid (about US$0.0008 per Layer 3 item). Supabase Pro on Micro compute |

## 4. Scope

### In scope
- Course attributes: official page, English requirements, intake months, provider tuition (through Layer 3), plus the CRICOS attributes already held.
- Scholarships: first-party provider scholarship pages and Study Australia. Published under Decision 139.
- Automated completeness: a score per course and per provider, plus an "accounted for" measure, exposed in the admin UI and the consumer API.
- Consumer API next contract version (additive fields only). Developer communications.
- Daily reporting for the consumer API and stakeholders.
- UI uniformity (shared tokens and components) and outstanding refinements R1, R2, R4, R7–R9, R12, R13, R17, R27.
- Semantic search (pgvector) behind its own Search gate and benchmark.

### Out of scope (this plan)
- New countries (the Canada adapter stays queued after M2.5).
- Changes to Layer 1 (closed by Decision 159).
- Firecrawl AI extraction for admission (not used, Decision 162).

## 5. Project phases (compressed to go-live on 3 October)

The platform goes to production on 3 October in customer-owned accounts. Everything that isn't needed for go-live moves after it. Data admission continues automatically before and after go-live.

### Before go-live (29 Sep – 3 Oct)
| # | Work | When | State |
|---|---|---|---|
| A1 | Coverage sweep: find website, discover, bind, read, re-extract | Running | Live |
| A2 | **Admission: official course page and English** from CRICOS-code pages, every 10 minutes, write-only-when-empty, differences to Layer 4, Search gates, snapshots | 29 Sep | Live 29 Sep 10:40 IST |
| A3 | **Intakes held.** A hand-check found about 9 of 14 right, so intakes go to the Layer 3 benchmark instead of admission | 30 Sep – 1 Oct | Held |
| A4 | Tuition from the sweep through Layer 3 (Option A: sweep reads recorded as Layer 2 run items) | 30 Sep | To build |
| A5 | Scholarships: Decision 139 publication with the course-link breadth rule (2 published); scholarship sweep links scholarships to the right courses and picks up award values | 30 Sep – 2 Oct | Rule live; sweep to build |
| A6 | Completeness score and "accounted for", hourly, on the coverage screen and in the daily update | 30 Sep | To build |
| P1 | Customer accounts created (Supabase, GitHub, Cloudflare, OpenRouter, Firecrawl, SMTP, domain) | 30 Sep | Customer |
| P2 | 27 live-only edge functions brought into GitHub; inventory baseline | 30 Sep | MSP |
| P3 | GitHub and Cloudflare moved; Supabase project transferred; verification | 1 Oct | MSP |
| P4 | Credential rotation; production API tokens; developer tests on `api.<domain>` | 2 Oct | MSP + developer |
| P5 | Dress rehearsal and GO/NO-GO (M2.4.9) | 2 Oct | Platform Admin |
| P6 | Go-live check; pilot tokens revoked; developer notified | 3 Oct | MSP |

### After go-live (from 6 Oct)
| # | Work |
|---|---|
| B1 | Consumer API next version (additive): `completeness`, `duration` (R2), status rename (R4), scholarships in all three APIs, the developer's requests |
| B2 | UI uniformity release (one colour and type system, one component kit, en-AU formats, "Layer N" wording) |
| B3 | Semantic search (pgvector) behind a Search gate and benchmark; off by default |
| B4 | Search index tuning (filtered search about 3 s) |
| B5 | Intakes admitted once the Layer 3 benchmark passes and is activated |
| B6 | Compute back to Small once the admission backlog clears |
| B7 | Remaining refinements R1, R7, R9, R13, R17, R27 |

## 7. Estimated effort and running cost

| Item | Estimate |
|---|---|
| Firecrawl | About 30,000–45,000 credits for the first full pass (maps, script-rendered pages, searches); monthly re-discovery afterwards is far lower |
| OpenRouter (Layer 3) | About US$16–20 for tuition on all courses; English and intake checks only for ambiguous cases. The US$29 credit covers the first pass; top up at US$10 |
| Supabase compute | Medium about US$2 a day for 10–14 days (about US$20–28), then back down |
| Storage | About 1.25 GB more gzipped evidence (Pro includes 100 GB; 11 GB in use) |

## 8. Assumptions
- Provider pages that print the course's CRICOS code are the course's own page (checked 13/13).
- "Accounted for" includes "provider does not publish this", which is a valid final state.
- Layer 3 remains pinned to a single qualified model; a passing benchmark never switches a model on by itself.
- The consumer API changes are additive; existing fields keep their meaning.

## 9. Risks

| Risk | Effect | Mitigation |
|---|---|---|
| Sites block reading or need script rendering | Slower coverage, more Firecrawl credits | robots.txt respected; Firecrawl for bound pages only; blocked shown as its own state |
| Tuition basis (annual vs total) misread | Wrong fee shown | Tuition only through Layer 3; unsure goes to Layer 4 |
| Micro compute under sustained load | Slow admin screens or API | Temporary Medium compute; jobs staggered; resource observations hourly |
| OpenRouter credit runs out | Layer 3 pauses | Daily ceiling US$5; balance in the daily update; top-up trigger US$10 |
| Consumer contract change breaks the website | Website errors | Versioned contract; old version kept; snapshots |
| Scholarship data thin (few closing dates, no study level) | Limited filters | Publish what Decision 139 allows; `filters_not_applied` stays in the response |

## 10. Decisions

**Made on 29 Sep 2026 (Platform Admin):**
- Admission rule approved.
- Tuition through Layer 3 by Option A.
- Scholarships published under Decision 139, plus a sweep for more.
- Semantic search in the post-go-live wave, behind a gate.
- Compute raised to Medium.
- Production by 3 Oct in customer-owned accounts.

**Open:**
1. Region for production: keep Mumbai (project transfer, recommended for 3 Oct) or move to Sydney (full migration, runbook §7).
2. Other Layer 2 fetchers (ScraperAPI, Scrape.do, ZenRows, Parsebot) and Apollo: keep or drop for production.
3. The customer's host names for the admin console and the API.
4. The website developer's request (email not yet received in this workspace).
