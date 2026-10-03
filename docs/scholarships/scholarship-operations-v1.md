# Scholarships — how they are run (v1, 3 Oct 2026, 23:45 AEST)

How scholarship data comes in, how it is published, how it is joined to courses, what runs on a schedule, and what happens when a provider changes a value. Decisions 139, 211, 212, 244–249. Live state at 23:45 AEST.

## 1. Where the data comes from

| Source | What it gives | How it is read | Today |
|---|---|---|---|
| Provider's own scholarship pages (source of record for provider money) | Name, value, who qualifies, dates, study levels, page | Discovery (provider site maps) → page read by the coverage-sweep worker → fixed readers for audience, nationality, value, tiers, criteria | 998 + 32 detail records |
| Study Australia scholarship list (Australian Government) | Provider and government scholarships with links to the provider page | Source refresh (ETL scheduler) → provider page read as above | 204 records |
| DFAT Australia Awards | Government scholarships by partner country | Source refresh; per-country profiles to be read (plan step 4) | 1 record |
| Registered CRICOS course cost | Course tuition used to estimate a saving where no annual fee is published | Layer 1 register | 4,987 courses with linked scholarships |
| Provider annual international tuition (course pages) | The fee a percentage scholarship is worked out from | Layer 2 course page reads (Decision 212; Decision 242 when built) | 3,450 pairs |

Aggregators and course directories (Hotcourses, IEFA, internationalscholarships.com, internationalstudent.com) are not sources — benchmarks only (Decision 232; sources review of 3 Oct).

## 2. Pipeline and who owns each step

| Step | Layer | What happens | Person needed? |
|---|---|---|---|
| Find | Layer 2 | Provider scholarship pages found from site maps and the Study Australia list | No |
| Read | Layer 2 | Page stored as evidence; value, tiers, dates, criteria, study levels read by fixed rules (quote kept) | No |
| Interpret | Layer 2 rules (Layer 3 AI only for change checks) | Audience (Decision 244), nationality (246), value label (248) | No |
| Link to courses | Layer 4 (Course links) | Study levels / fields / named courses on the page → decided course links; a scholarship's links are decided once (Decision 182) | Only where the page is broader than one rule can settle |
| Cost per course | Automation | Saving per year from the provider annual fee, else estimated from CRICOS (Decision 247) | No |
| **Publish** | **Layer 4 › Scholarship publishing** (Decision 249) | A Platform Admin publishes the ready list with an approval note; holds or releases one | **Yes** |
| Withdraw | Automation | Nightly review withdraws a published one that no longer passes a check (Decision 139) | No (republish is a person's step) |
| Serve | Search / website / Zoho | Course attribute and Zoho `scholarships` action carry published, international, linked scholarships | No |

Publishing is a person's decision, so it sits in Layer 4 with the other decisions. Layer 3 is AI checking only; it never publishes.

## 3. What makes a scholarship ready to publish

Active; international or international-and-domestic (read from wording); a stated value (single value, page tiers, or recorded by hand); a provider page; at least one decided course link not broader than the page; not limited to citizens or residents; not held by a person; not "no longer offered". Anything else is held, with the reason shown on Scholarship publishing.

## 4. How a scholarship reaches a course (the course attribute)

`search.course_documents.scholarship_options` — read by course search, the website and the Zoho course API — holds, for each course, the scholarships that are **published, open to international students, and linked to that course by a decided course link** (Decision 247). Each carries: name, value label (Decision 248), audience, nationalities, close date, page, and **saving per year with its basis** (provider annual fee, or "estimated from the registered course cost"). `has_scholarship` is true when there is at least one.

Kept in step by job `scholarship-course-attribute` every 15 minutes (courses linked to any scholarship changed, published, withdrawn or re-costed since the last run) and a full sweep at 06:51 AEST. At 23:00: 6,060 courses show scholarships; 3,348 with a saving.

## 5. Savings

Percentage-of-tuition scholarships only. Fee used, in order: the provider's annual international tuition for the scholarship's year (else latest); otherwise, for Australia, registered CRICOS tuition ÷ registered duration in years (at least one) — recorded as `estimated_annual_from_registered_total` and shown as an estimate. Never from an "up to" value, a range, or a fixed amount. Recalculated nightly at 06:41 AEST and whenever a fee or the scholarship changes. 13,406 of 22,240 course–scholarship pairs have a saving (3,450 from provider fees, 9,956 estimated).

## 6. When a provider changes something

| Change | What happens | When counsellors see it |
|---|---|---|
| New scholarship on the provider site | Found by discovery, read, audience/nationality/value read; course links proposed; appears on Scholarship publishing as ready or held | After a person publishes it |
| Value or percentage changes | Page re-read (published and ready: at least every 30 days — job scholarship-reread-cadence) updates the record unless set by hand; change logged in `pipeline.scholarship_sweep_changes` | Course attribute within 15 minutes; saving at 06:41 |
| Tuition fee changes | New fee recorded by Layer 1/2; saving recalculated | 06:41 next morning |
| Close date passes / page says no longer offered | Record updated; fails a check | Withdrawn at 06:17 |
| Audience changes to domestic only | Fails a check | Withdrawn at 06:17; a person can republish |
| A value set by hand | Never overwritten; "Let automation update this" hands it back | — |

## 7. Scheduled jobs (all on Scheduled jobs › Automations, area Scholarships)

| Job | When (AEST) | What |
|---|---|---|
| scholarship-discover-refill | hourly at :23 | Lines up providers for discovery |
| scholarship-discover | every 10 min | Finds scholarship pages on provider sites |
| scholarship-read | every 5 min | Reads due pages (20 a run) |
| coursefinder-scholarship-etl-scheduler | hourly at :43 | Source refresh (Study Australia and other qualified feeds) |
| coursefinder-scholarship-ai-change-scheduler | every 6 h at :17 | AI change checks (Layer 3) |
| scholarship-scope-apply | hourly at :19 | Applies decided course-link rules |
| scholarship-audience | hourly at :41 | Audience from wording (Decision 244) |
| scholarship-nationality | hourly at :43 | Nationality from wording (Decision 246) |
| scholarship-course-attribute | every 15 min | Course attribute for changed scholarships (Decision 247) |
| scholarship-reread-cadence | daily 05:37 | Published and ready re-read at least every 30 days |
| scholarship-publication-review | daily 06:17 | Withdraws published ones that fail a check (Decision 139) |
| scholarship-savings | daily 06:41 | Savings per year (Decisions 212, 247) |
| scholarship-course-attribute-full | daily 06:51 | Full course attribute sweep |
| coursefinder-scholarship-maintenance | Sunday 15:20 | Weekly clean-up |

## 8. Next to build

Changed-since-published list on Scholarship publishing (a value change on a published scholarship shown for a person to confirm); DFAT per-country profiles and the Study Australia search tool through the worker; NZ and CA provider readers; UK and US government readers; pgvector search (`scholarship_search_v1`); Reviewer role on the 459 not-stated.
