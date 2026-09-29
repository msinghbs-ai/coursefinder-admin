# CourseFinder — Consolidated Delivery Plan: Complete Coverage to Production

**Version:** 1.0 · **Date:** 29 September 2026 · **Status:** ACTIVE (supersedes the 28 Sep "Upcoming plan" list; milestone gates M2.4.8, M2.4.9 and M2.5 unchanged)
**Change control:** CF-CHG-20260915-247 · **Decisions:** Design Reference Decision 162, Decision 163
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

## 5. Project phases

### Wave 0 — Running now (29 Sep)
| Item | State |
|---|---|
| Coverage statistics (Data Quality → Course coverage) | Live |
| Coverage sweep: find website, discover, bind, read, re-extract, document checks | Live, on schedules |
| Firecrawl 100,000 plan: budget guard, concurrency 20, held pages released, discovery 8 providers per call | Live 29 Sep |
| Layer 3 throughput 15,000 a day with a US$5 a day ceiling | Live |
| Daily update (consumer API + stakeholders) | Scheduled 08:49 IST daily |

### Wave 1 — Days 1–2 (29–30 Sep): first admission
| # | Work | Depends on |
|---|---|---|
| 1.1 | Admit sweep values from CRICOS-verified pages: official page, English, intakes. Write only where empty; differences go to Layer 4 with a plain reason. Search gates opened. Snapshots before and after | Platform Admin approval of the admission rule |
| 1.2 | Route sweep tuition through Layer 3 (Option A: sweep reads recorded as Layer 2 run items; no Layer 3 schema change) | Platform Admin choice of route |
| 1.3 | Publish the 57 scholarships that meet Decision 139 (R8 batches). Snapshots before and after | Platform Admin approval |
| 1.4 | Completeness v1: score and "accounted for" per course, provider and platform, rebuilt hourly in the coverage build, kept daily | None |
| 1.5 | Temporary compute upgrade (Micro → Medium) for the sweep window | Platform Admin action in the Supabase dashboard |

### Wave 2 — Days 2–5 (30 Sep – 3 Oct): full sweep
| # | Work |
|---|---|
| 2.1 | Finish discovery for all providers with a website, and read every bound page |
| 2.2 | Second pass for ambiguous and unmatched courses: Firecrawl search for "course title + CRICOS code" per course, so identity is still by CRICOS code |
| 2.3 | Websites for the 554 providers without one; providers still without a website after the search are reported by name |
| 2.4 | Scholarship sweep: scholarship pages kept from site maps (currently excluded from course binding), read, structured deterministically. Amounts and eligibility checked by Layer 3 where a qualified task exists; otherwise Layer 4. Published under Decision 139 |
| 2.5 | Layer 3 benchmark of Mistral Small 3.2 for English and intakes. Activation is a separate, recorded step after approval |
| 2.6 | Tuition through Layer 3 at the US$5/day ceiling (about 6,000 items a day). OpenRouter top-up when the balance falls below US$10 |

### Wave 3 — Days 5–10 (3–8 Oct): consumer and experience
| # | Work |
|---|---|
| 3.1 | Consumer API next version (additive): `completeness`, `duration` (R2), status rename (R4). Scholarships in the website and Zoho APIs as well as Wix. Changes the developer requested (pending receipt of the request). Old version kept in parallel |
| 3.2 | Developer update with newly admitted statistics and the change list |
| 3.3 | UI uniformity release: one token file, one component kit, en-AU number and date formats, "Layer N" wording, 11px minimum text, light-only recorded (or dark mode) |
| 3.4 | Semantic search: embeddings for course title, provider and study area. Hybrid ranking behind a Search gate, benchmarked against current results. Off by default |
| 3.5 | Search index tuning (filtered search currently about 3 s) |
| 3.6 | Layer 4 queue for differences between sweep and admitted values |

### Wave 4 — Days 10–14 (8–12 Oct): readiness
| # | Work |
|---|---|
| 4.1 | M2.4.8 consumer and data-ops readiness |
| 4.2 | M2.4.9 dress rehearsal and GO/NO-GO |
| 4.3 | Compute back to Small or Micro once the backlog is admitted (by measured load) |
| 4.4 | Remaining refinements R1 (entry requirements), R7 (description), R9, R13 (publication gate), R17, R27 |
| 4.5 | Production environment plan (M2.5, after GO) |

## 6. Milestones

| Milestone | Target date | Exit evidence |
|---|---|---|
| First sweep admission batch in Search | 30 Sep 2026 | Snapshots identical outside the admitted rows; daily update shows the jump |
| First scholarships published | 30 Sep 2026 | 57 visible through the scholarship API |
| Every course accounted for | 3 Oct 2026 | No course in "site known, page not found" without a recorded reason |
| Consumer API next version available | 8 Oct 2026 | Contract tests, developer confirmation |
| GO/NO-GO | 12 Oct 2026 | M2.4.9 record |

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

## 10. Decisions awaiting the Platform Admin
1. Admission rule for sweep values on CRICOS-verified pages (Wave 1.1).
2. Route for sweep tuition to Layer 3 (Wave 1.2).
3. Publication of the 57 scholarships meeting Decision 139 (Wave 1.3).
4. Temporary compute upgrade (Wave 1.5).
5. When to switch on semantic search (Wave 3.4).
6. Contents of the website developer's request (Wave 3.1).
