# Course-wise tracker

The morning read. Every active course, every field: filled, or empty **with a named cause**. Regenerated from the live database by `docs/platform/tracker/course-wise-tracker.sql` (read-only), maintained nightly under the overnight outcomes mandate (record: `docs/platform/ui-audit/2026-10-25-overnight-outcomes.md`).

## How to read it

| Column | Meaning |
|---|---|
| **Filled** | The course holds an active value (the same tests the catalogue list uses). |
| **Empty, lane working** | Empty, and the recorded cause is one an automatic lane is still working (search, AI page match, re-read, fee reader). |
| **Blocked** | Empty, and the cause needs a person, a decision, a source, or a reader not yet built. |
| **No cause** | Empty with no cause recorded. The target is 0, and it is 0 in this edition. |

Causes come from the hourly gap-cause snapshot (`pipeline.gap_cause_snapshots`) where it covers the field. Elsewhere the cause is named in the row.

---

## Edition 1: 25 Oct 2026 18:15 AEDT (baseline)

Gap-cause snapshot 06:00 UTC. Active courses: AU 26,103 · NZ 6,474 · CA 3,814. The 24 h delta column starts from this edition.

### New Zealand (6,474 active courses)

| Field | Filled | Empty, lane working | Blocked | No cause | 24 h | Top causes |
|---|---|---|---|---|---|---|
| fee | 1,384 (21%) | 4,362 | 728 | 0 | baseline | no page: search and AI page match found none (2,030, automatic); fee reader found no fee on the page (836, automatic); no page: web search queued (562, automatic) |
| English | 2,354 (36%) | 2,728 | 1,392 | 0 | baseline | no page found (1,656, automatic); web search queued (562, automatic); web search stopped for this university (469, needs a person) |
| intakes | 2,139 (33%) | 3,038 | 1,297 | 0 | baseline | no page found (2,031, automatic); web search queued (562, automatic); web search stopped for this university (469, needs a person) |
| duration | 2,337 (36%) | 3,656 | 481 | 0 | baseline | no page found (2,017, automatic); AI: the page does not state it (714, automatic); web search queued (561, automatic) |
| campus | 2,332 (36%) | 3,667 | 475 | 0 | baseline | no page found (1,826, automatic); AI: the page does not state it (781, automatic); web search queued (519, automatic) |
| delivery | 2,972 (46%) | 3,434 | 68 | 0 | baseline | no page found (2,004, automatic); web search queued (558, automatic); AI: the page does not state it (517, automatic) |
| link | 3,042 (47%) | 2,950 | 482 | 0 | baseline | no page found (2,002, automatic); web search queued (562, automatic); web search stopped for this university (469, needs a person) |
| description | 0 (0%) | 0 | 6,474 | 0 | baseline | no course-description reader yet (B2, O3); blocked: reader not built |
| entry | 0 (0%) | 0 | 6,474 | 0 | baseline | entry-requirements reader not built (O4 step A PR, NZ first); blocked: reader not built |
| title | 6,473 (100%) | 0 | 1 | 0 | baseline | the register gives no title (SIT NZQA 3954 "--"; quarantine paste awaiting the Platform Admin) |

### Australia (26,103 active courses)

| Field | Filled | Empty, lane working | Blocked | No cause | 24 h | Top causes |
|---|---|---|---|---|---|---|
| fee | 26,103 (100%) | 0 | 0 | 0 | baseline | AU international fees come from the CRICOS register (`fees.countries` = NZ, CA by Platform Admin choice) |
| English | 16,917 (65%) | 1,627 | 7,559 | 0 | baseline | **provider not published, enrichment paused (6,037, needs a person)**; AI: page gives no IELTS, university English rule approved but covers other study levels (1,140, needs a person); no page found (609, automatic) |
| intakes | 9,390 (36%) | 3,993 | 12,720 | 0 | baseline | **provider not published, enrichment paused (9,848, needs a person)**; AI: page gives no start dates, university calendar approved but covers other levels (1,928, needs a person); no page found (1,697, automatic) |
| duration | 26,103 (100%) | 0 | 0 | 0 | baseline | from the CRICOS register |
| campus | 26,072 (100%) | 29 | 2 | 0 | baseline | not tried yet (8, automatic); no page found (7, automatic); provider not published (2) |
| delivery | 26,083 (100%) | 20 | 0 | 0 | baseline | no page found / page does not state it (automatic) |
| link | 18,622 (71%) | 3,636 | 3,845 | 0 | baseline | **provider not published (3,767, needs a person)**; no page found (1,684, automatic); page not read: fetch failed (1,021, automatic) |
| description | 163 (1%) | 0 | 25,940 | 0 | baseline | no course-description reader yet (B2, O3); blocked: reader not built |
| entry | 0 (0%) | 0 | 26,103 | 0 | baseline | entry-requirements reader not built (AU Group of Eight follows NZ) |
| title | 26,103 (100%) | 0 | 0 | 0 | baseline | — |

### Canada (3,814 active courses)

| Field | Filled | Empty, lane working | Blocked | No cause | 24 h | Top causes |
|---|---|---|---|---|---|---|
| fee | 672 (18%) | 2,931 | 211 | 0 | baseline | page shows no single international fee (824, automatic); no page found (734, automatic); fee reader found no fee on the page (704, automatic) |
| English | 2,010 (53%) | 529 | 1,275 | 0 | baseline | university English rule approved but covers other levels (531, needs a person); university English rule not found (344, needs a person); no page found (337, automatic) |
| intakes | 1,613 (42%) | 1,198 | 1,003 | 0 | baseline | no page found (733, automatic); calendar approved but covers other levels (396, needs a person); calendar not found (377, needs a person) |
| duration | 1,324 (35%) | 2,485 | 5 | 0 | baseline | AI: the page does not state it (1,409, automatic); no page found (733, automatic); fetch failed (170, automatic) |
| campus | 2,082 (55%) | 1,729 | 3 | 0 | baseline | page does not state it (672, automatic); no page found (663, automatic); fetch failed (169, automatic) |
| delivery | 2,502 (66%) | 1,312 | 0 | 0 | baseline | no page found (728, automatic); page does not state it (452, automatic); fetch failed (171, automatic) |
| link | 2,664 (70%) | 1,092 | 58 | 0 | baseline | no page found (731, automatic); fetch failed (173, automatic); not read yet (90, automatic) |
| description | 0 (0%) | 0 | 3,814 | 0 | baseline | no course-description reader yet |
| entry | 0 (0%) | 0 | 3,814 | 0 | baseline | entry reader not built (CA after AU and NZ) |
| title | 3,814 (100%) | 0 | 0 | 0 | baseline | — |

### What the baseline says, in one line per country

- **NZ:** one cause sits under every field: about 2,000 courses have no course page found, and about 560 wait in the search queue. Binding (search) is the lever. The cap went from 100 to 200 tonight (O6).
- **AU:** the big blocked blocks are **unpublished providers** (6,037 English, 9,848 intakes, 3,767 links). Enrichment is paused for them by design. The lever is a person's publish decision, not a lane.
- **CA:** fees are the gap (18%). The fee reader did not cover CA at all until tonight (O1 widened its scope).

## Spend to date (mandate budget: 30,000 Firecrawl credits, $25 AI; working AI stop $15, see the record)

| Initiative | Firecrawl credits | AI (US$) | Line |
|---|---|---|---|
| O1 fees (fee-schedule pages, fee reader) | 22 | 0.18 | 3–6k credits |
| O2 intakes (Enrich fields re-read, 354 items) | 0 | 0.04 | — |
| O3 descriptions | 0 | 0 | ~500 + $2 (reader in a later release) |
| O4 NZ entry matrices | 0 | 0 | ~1.5k (reader in a PR) |
| O5 scholarships (372 AI re-checks queued) | 0 | 0.00 | ~500 |
| O6 searches (cap 200) | 200 | 0.00 | — |
| O7 titles | 0 | 0 | — |
| **Total since 18:00 AEDT** | **224** | **0.22** | stop at 22,500 / $15 |

Balances at baseline: Firecrawl 336,089 credits remaining; OpenRouter US$20.77.

## Top 20 providers by course count (share of active courses with the field filled)

| Ctry | # | Provider | Courses | Fee | English | Intakes | Duration | Campus | Delivery | Link | Description |
|---|---|---|---|---|---|---|---|---|---|---|---|
| AU | 1 | UNSW Sydney | 667 | 100% | 65% | 70% | 100% | 100% | 100% | 70% | 0% |
| AU | 2 | The University of Sydney | 655 | 100% | 94% | 11% | 100% | 100% | 100% | 61% | 0% |
| AU | 3 | Monash University | 582 | 100% | 96% | 55% | 100% | 100% | 100% | 67% | 0% |
| AU | 4 | University of Technology Sydney (UTS) | 530 | 100% | 90% | 57% | 100% | 100% | 100% | 68% | 0% |
| AU | 5 | RMIT University (RMIT) | 507 | 100% | 98% | 64% | 100% | 100% | 100% | 80% | 0% |
| AU | 6 | Adelaide University | 498 | 100% | 93% | 51% | 100% | 100% | 100% | 51% | 0% |
| AU | 7 | Flinders University | 476 | 100% | 75% | 51% | 100% | 100% | 100% | 82% | 0% |
| AU | 8 | Macquarie University | 461 | 100% | 80% | 20% | 100% | 100% | 100% | 59% | 0% |
| AU | 9 | The University of Newcastle (UoN) | 457 | 100% | 93% | 43% | 100% | 100% | 100% | 45% | 0% |
| AU | 10 | The University of Melbourne (UniMelb) | 441 | 100% | 64% | 41% | 100% | 100% | 100% | 88% | 0% |
| AU | 11 | Australian National University | 423 | 100% | 95% | 5% | 100% | 100% | 100% | 100% | 0% |
| AU | 12 | Swinburne University of Technology | 412 | 100% | 94% | 53% | 100% | 100% | 100% | 58% | 0% |
| AU | 13 | The University of Queensland | 383 | 100% | 97% | 87% | 100% | 100% | 100% | 93% | 40% |
| AU | 14 | Curtin University | 373 | 100% | 98% | 66% | 100% | 100% | 100% | 81% | 0% |
| AU | 15 | University of Wollongong | 367 | 100% | 69% | 68% | 100% | 100% | 100% | 93% | 0% |
| AU | 16 | The University of Western Australia | 327 | 100% | 78% | 74% | 100% | 100% | 100% | 88% | 0% |
| AU | 17 | Western Sydney University | 325 | 100% | 94% | 58% | 100% | 100% | 100% | 93% | 0% |
| AU | 18 | Griffith University | 297 | 100% | 99% | 89% | 100% | 100% | 100% | 89% | 0% |
| AU | 19 | Queensland University of Technology | 294 | 100% | 95% | 65% | 100% | 100% | 100% | 72% | 0% |
| AU | 20 | Victoria University | 280 | 100% | 86% | 43% | 100% | 100% | 100% | 48% | 0% |
| NZ | 1 | University of Auckland | 458 | 53% | 46% | 62% | 45% | 66% | 70% | 72% | 0% |
| NZ | 2 | University of Canterbury | 280 | 56% | 5% | 73% | 75% | 18% | 61% | 77% | 0% |
| NZ | 3 | University of Waikato | 278 | 22% | 82% | 40% | 37% | 37% | 39% | 39% | 0% |
| NZ | 4 | Victoria University of Wellington | 273 | 35% | 82% | 34% | 36% | 30% | 39% | 56% | 0% |
| NZ | 5 | Massey University | 265 | 45% | 9% | 11% | 62% | 34% | 62% | 63% | 0% |
| NZ | 6 | Auckland University of Technology | 257 | 44% | 91% | 65% | 68% | 65% | 74% | 79% | 0% |
| NZ | 7 | University of Otago | 252 | 37% | 82% | 7% | 15% | 23% | 31% | 68% | 0% |
| NZ | 8 | NZIST Work-Based Learning | 231 | 0% | 0% | 0% | 0% | 0% | 0% | 0% | 0% |
| NZ | 9 | Southern Institute of Technology | 207 | 0% | 46% | 50% | 31% | 33% | 57% | 58% | 0% |
| NZ | 10 | Lincoln University | 199 | 39% | 60% | 44% | 46% | 87% | 89% | 47% | 0% |
| NZ | 11 | Eastern Institute of Technology | 184 | 0% | 58% | 50% | 52% | 50% | 51% | 53% | 0% |
| NZ | 12 | Otago Polytechnic | 182 | 42% | 47% | 45% | 51% | 42% | 51% | 51% | 0% |
| NZ | 13 | Ara Institute of Canterbury | 178 | 17% | 59% | 35% | 43% | 34% | 43% | 48% | 0% |
| NZ | 14 | Toi Ohomai Institute of Technology | 156 | 22% | 60% | 57% | 60% | 47% | 58% | 60% | 0% |
| NZ | 15 | Nelson Marlborough Institute of Technology (NMIT) | 148 | 0% | 44% | 41% | 41% | 41% | 43% | 46% | 0% |
| NZ | 16 | Waikato Institute of Technology | 144 | 1% | 50% | 49% | 10% | 49% | 51% | 53% | 0% |
| NZ | 17 | Manukau Institute of Technology | 144 | 18% | 34% | 47% | 38% | 44% | 47% | 47% | 0% |
| NZ | 18 | NorthTec | 122 | 9% | 45% | 29% | 36% | 35% | 35% | 36% | 0% |
| NZ | 19 | Whitireia and WelTec | 116 | 20% | 44% | 21% | 43% | 40% | 48% | 46% | 0% |
| NZ | 20 | Universal College of Learning (UCOL) | 115 | 30% | 32% | 35% | 35% | 36% | 36% | 36% | 0% |
| CA | 1 | University of British Columbia (UBC) | 575 | 48% | 94% | 44% | 33% | 55% | 56% | 60% | 0% |
| CA | 2 | University of Alberta | 379 | 0% | 89% | 0% | 2% | 34% | 36% | 59% | 0% |
| CA | 3 | Conestoga College | 270 | 6% | 0% | 49% | 69% | 46% | 97% | 98% | 0% |
| CA | 4 | University of Victoria | 234 | 1% | 82% | 41% | 43% | 42% | 50% | 60% | 0% |
| CA | 5 | Simon Fraser University (SFU) | 208 | 2% | 36% | 33% | 21% | 35% | 46% | 74% | 0% |
| CA | 6 | University of Lethbridge | 199 | 0% | 92% | 85% | 44% | 87% | 89% | 82% | 0% |
| CA | 7 | University of Calgary | 179 | 1% | 34% | 3% | 2% | 7% | 9% | 18% | 0% |
| CA | 8 | Durham College | 144 | 0% | 22% | 95% | 8% | 75% | 96% | 96% | 0% |
| CA | 9 | College of the North Atlantic | 105 | 32% | 7% | 47% | 26% | 83% | 100% | 49% | 0% |
| CA | 10 | Sheridan College | 105 | 4% | 1% | 69% | 61% | 70% | 73% | 73% | 0% |
| CA | 11 | Camosun College | 91 | 54% | 13% | 84% | 93% | 95% | 100% | 100% | 0% |
| CA | 12 | University of Manitoba | 87 | 0% | 30% | 0% | 0% | 0% | 0% | 2% | 0% |
| CA | 13 | Okanagan College | 80 | 36% | 6% | 59% | 98% | 91% | 100% | 100% | 0% |
| CA | 14 | University of Northern British Columbia | 76 | 3% | 93% | 28% | 7% | 32% | 36% | 62% | 0% |
| CA | 15 | Thompson Rivers University | 76 | 8% | 3% | 47% | 3% | 67% | 80% | 63% | 0% |
| CA | 16 | Cambrian College | 72 | 75% | 25% | 100% | 100% | 100% | 100% | 100% | 0% |
| CA | 17 | La Cité collégiale | 61 | 90% | 0% | 0% | 0% | 93% | 93% | 93% | 0% |
| CA | 18 | Algonquin College | 58 | 0% | 83% | 9% | 14% | 84% | 100% | 93% | 0% |
| CA | 19 | Loyalist College | 57 | 28% | 0% | 89% | 0% | 89% | 98% | 98% | 0% |
| CA | 20 | Canadore College | 52 | 33% | 2% | 17% | 96% | 92% | 96% | 98% | 0% |

Entry and title are left out of the provider table: entry is 0% everywhere, and title is 100% everywhere except SIT 3954.
