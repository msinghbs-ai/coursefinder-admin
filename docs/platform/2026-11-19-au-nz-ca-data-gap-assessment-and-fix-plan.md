# AU, NZ and CA data gap assessment and fix plan (s792)

**Date:** 19 Nov 2026, measured live 23:20–23:55 AEDT (S1-Build). **Brief:** Platform Admin handover 19 Nov 2026 23:15 (chat S1-Build, s792 to s796).
**Method:** every figure is read live from `fxcwkweaxjtknorudmwp`, inside the rolled-back GitHub Actions dry-run workflow (no interactive SQL). Course figures use `search.course_documents` joined to `catalogue.courses`, the same basis as the 21:45 baseline (the AU study-load split 5,296 / 118 / 3,217 matches it exactly).

## 1. Course field gaps: baseline (21:45) and today (23:33)

| Gap (courses) | AU 21:45 | AU 23:33 | NZ 21:45 | NZ 23:33 | CA 21:45 | CA 23:33 |
|---|---:|---:|---:|---:|---:|---:|
| No full-time / part-time value (`study_load`) | 15,382 | 15,382 | 4,643 | **4,186** | 3,440 | **3,113** |
| No study mode | 20 | 20 | 3,386 | 3,386 | 1,204 | 1,204 |
| No campus | 31 | 31 | 3,999 | 3,999 | 1,604 | 1,604 |
| With an `empty_reason_code` | 31 | 31 | 4,004 | 4,004 | 1,604 | 1,604 |
| No description | 11,900 | 11,900 | 4,739 | 4,739 | 2,399 | 2,399 |
| No official course link | 6,120 | 6,119 | 3,448 | 3,448 | 1,077 | 1,077 |
| No intake | 14,502 | 14,502 | 4,293 | 4,293 | 2,126 | 2,126 |
| Intake without a start date | 6,900 | 6,900 | 2,008 | 2,008 | 1,688 | 1,688 |
| No fee published by the provider | 15,561 | 15,561 | 5,023 | 5,023 | 3,082 | 3,082 |
| … of which no fee at all (no register fee either) | | **169** | | | | |
| No English requirement | 7,876 | 7,876 | 4,123 | 4,123 | 1,798 | 1,798 |
| No state | 35 | 35 | 4,066 | 4,066 | 0 | 0 |

Search index: AU 24,013, NZ 6,514, CA 3,814 (34,341 in all three; the brief counts 36,031 active courses in the catalogue).

**What the numbers mean**
- **Fees:** 15,392 of the 15,561 AU courses with "no fee" hold the government register (CRICOS) tuition fee, which API v3 serves as the regulatory tuition. What they lack is a fee published by the provider. Only 169 AU courses have no fee of any kind.
- **Index lag is small:** the gaps are real missing data, not data held in the catalogue but missing from the search index. Held but not projected:
  - AU: 10 courses with active intakes (822 more have only withdrawn intakes, correctly not shown), 21 with active English rows, 3 links;
  - NZ: 75 intakes, 3 English, 22 links;
  - CA: 68 intakes, 1 English.
- **AU did not move between 21:45 and 23:33** on any field. NZ (−457) and CA (−327) gained study loads, so the Boost reader was working through NZ and CA pages in that window.

**AU by provider type (23:50)** — universities are the largest share of every AU gap:

| AU provider type | Courses | No study load | No description | Intake without date | No provider fee | No English | No link |
|---|---:|---:|---:|---:|---:|---:|---:|
| University | 11,778 | 5,646 | 6,235 | 4,231 | 5,835 | 2,005 | 2,912 |
| Private VET | 8,292 | 6,957 | 3,410 | 1,316 | 6,590 | 3,408 | 1,786 |
| Higher education institute | 1,725 | 1,071 | 816 | 815 | 1,262 | 957 | 538 |
| TAFE / polytechnic | 765 | 470 | 303 | 356 | 547 | 351 | 145 |
| School | 748 | 742 | 734 | 24 | 728 | 730 | 498 |
| Other, university college, none | 705 | 496 | 402 | 158 | 599 | 425 | 240 |

## 2. Providers, campuses, accreditations, rankings, groups (23:40)

| Item | AU | NZ | CA | Note |
|---|---|---|---|---|
| Active providers | 1,544 | 417 | 1,130 | 3,091 in all |
| Without a description | 613 | 108 | 180 | 2,190 hold one (matches the 2,189 in the brief) |
| University-type providers | 45 | 8 (plus 3 wānanga) | 0 typed `university` | 53 in all; CA universities are typed otherwise (to map) |
| Universities without a description | 7 | 2 | – | AU: Victoria University (the record live today has none), UTS, RMIT, Western Sydney, Torrens (and two Torrens sub-units), Macquarie, Avondale |
| Universities with a main campus flagged | 2 of 45 | 0 of 8 | – | `campuses.is_primary` (brief said 3 of 53) |
| Accreditations | AMBA 13, all `under_review` | | | AACSB and EQUIS not loaded; API returns none (only approved are served) |
| Rankings | `catalogue.provider_rankings` and `ref.ranking_sources` are **empty** | | | The brief says QS 2027 is loaded; where API v3 reads rankings from must be traced before THE 2027 is added |
| University groups | Go8, ATN, IRU, RUN (`ref.institution_collections`) | | | IRU members held: Flinders, La Trobe, James Cook, Murdoch, Canberra, Griffith, Western Sydney (7) |
| Destination data | schema `destination` exists: career outcomes 1,577 rows, localities 102, locality metrics 142, editions 10 | | | Some destination data is held; assess before any import (RM1D, RM1I) |

**Worker and budget health (23:45):**
- Manual locks: 7,585, intact.
- `enrich_ai`: all 52 HTTP 500s since 21:00 were claim time-outs. Fixed in s788 (Pilot #1397, below).
- Page text: 1,200 pages converted an hour (17,252 done, 25 failed, 6 too short), Firecrawl 0. The local drain runs while `day_budget` holds the search lane.
- 20 `course_page_find` plans are held on `day_budget`: today's course-search share is used (1,200 credits on the Melbourne day; the balance is well above the priority floor). They stay running and resume when the day share resets.

## 3. Root cause and smallest fix, by impact (AU first)

### Part A: fixes within S1 authority

| # | Gap | Cause | Smallest fix | Expected gain | Gate |
|---|---|---|---|---|---|
| A1 | AU no description 11,900 (universities 6,235) | Course AI reader (`enrich_ai`) claims timed out (52 HTTP 500s) | **s788** claim index and busy status (Pilot #1397) | Description reads resume at full rate inside the existing AI ceiling | Migration (repo-first, done) |
| A2 | AU intake without date 6,900 (universities 4,231); NZ 2,008; CA 1,688 | Intake run and validation (F-INT) cannot page a whole university, keep stage history or verify / admit selected courses | **s790/s791** IntakeRunValidate: full pagination, saved cohorts, stage history, Verify / Admit read-back (no overwrite, locks kept) | Up to 6,900 AU courses can get exact dates from stored pages | Migration + UI; no spend |
| A3 | AU study load 15,382 unchanged 21:45–23:33 | The Boost reader worked through NZ and CA in this window | **s793** check `boost.matrix` order puts AU first (brief: "Australia first"); claim limits under 15 s | AU share of the 1,200 pages an hour | Setting only |
| A4 | Held but not projected: AU 10 intakes, 21 English, 3 links; NZ 75 / 3 / 22; CA 68 / 1 | Projection not re-run for those courses | **s794** re-project the named courses (bounded) | About 200 courses | None |
| A5 | 20 search plans held on `day_budget` | Daily course-search share used | **s789** verify they resume at the day reset with no duplicate plans | Search resumes; no new authority | None |
| A6 | Fee reporting | "No fee" counts courses that do hold the register fee | Report "no provider fee" and "no fee at all" separately (dashboards and this register) | Clarity: AU true gap 169 | None |

### Part B: decisions or approvals needed

| # | Decision | Options | Recommendation |
|---|---|---|---|
| B1 | AACSB, EQUIS and the 13 AMBA rows | (a) approve the 13 AMBA rows as they are; (b) load AACSB and EQUIS from their public lists, then approve all three together; (c) hold | **(b)**: load all three, approve together, label "Triple Crown" (all three), "Double Crown" (any two), and no label for one |
| B2 | Main campus rule (D-4, REQ-75) | (a) the campus named "main" or the head office on the register; (b) the campus with the most courses; (c) set by hand | **(a), then (b) where the register is silent**, with a hand override; affects 43 AU and 8 NZ universities |
| B3 | IRU becomes the 2050 Alliance (REQ-77) | (a) rename the group and add ACU and VU; (b) keep IRU and add a new group | **(a)**, and check the held members: Canberra is held, Charles Darwin is not |
| B4 | OET letter grades | (a) show the grade letters as held; (b) map letters to a band | **(a)** show as held; map only if the website asks |
| B5 | Destination data (RM1D, RM1I) | (a) assess what the `destination` schema already holds; (b) import outside sources | **(a)** first: 1,577 career-outcome rows and 102 localities are already held |
| B6 | New paid crawling | (a) none; (b) raise the daily course-search share | **(a)**: the local page-text drain and the stored-page readers have work for days at no Firecrawl cost |

## 4. Status of this plan
- s788 (A1) is in Pilot #1397; s782 (migration history in the repository) is in Pilot #1396.
- A2 to A6 follow in this order: s789 check at the day reset, s790/s791, s793, s794.
- Part B waits on the Platform Admin.
