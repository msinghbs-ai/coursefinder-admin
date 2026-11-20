# s891 to s893 — Course links move to the current year by themselves

Date: 21 Nov 2026. Chat: S1-CourseLink-2027-CRICOS. Decision: Platform Admin, 20 Nov 2026 22:58 AEDT.

## Audit (read only)

| Measure | Count |
|---|---|
| Course link items waiting | 545 |
| Held because the address carries a year | 158 |
| With a CRICOS code | 158 |
| Under a manual lock | 0 |

| Year in the address | Items |
|---|---|
| 2024 | 20 |
| 2023 | 21 |
| 2022 | 16 |
| 2021 | 18 |
| 2020 | 12 |
| 2019 | 34 |
| 2012 to 2018 | 37 |

| Provider | Items | Address shape |
|---|---|---|
| Macquarie University | 51 | `handbook.mq.edu.au/YYYY/DegreesDiplomas/...` |
| Australian National University | 33 | `programsandcourses.anu.edu.au/YYYY/program/{code}` |
| The University of Melbourne | 27 | `handbook.unimelb.edu.au/YYYY/courses/{code}` |
| The University of Sydney | 19 | `sydney.edu.au/handbooks/archive/YYYY/...` |
| La Trobe University | 18 | `handbook.latrobe.edu.au/courses/YYYY/{code}` |
| Six others | 10 | Mixed |

## Rule `course_link_year_rollover_v1` (s891)

1. **Candidates**, newest first: the upcoming year (2027), the current year (2026), the year before (2025), then the held address. A year is found as a path segment (`/2023/`), a `-2023` ending or a query value (`?year=2023`). An archived handbook (`/archive/`) is never offered as the held fallback.
2. **Plain read** of each candidate: robots.txt is respected, with a 20-second time-out. Firecrawl and AI are never used.
3. **Live page:**
   - HTTP 200 on the same host;
   - not moved to a home, search or error page, or to another year;
   - no words from setting `link_rollover.page_markers` (for example "page not found", "no longer offered", "not offered in {year}");
   - at least `link_rollover.min_chars` of text, unless the university's adapter reads the page's own data.
4. **This course:** the platform's identity rule must prove it: `cricos_code` (Australia), or `nzqa_code` / `adapter_code`.
5. **Decision** (database), through `public.layer4_review_decide` under the system automation account:
   - the held address proved: approved;
   - a newer year proved: that address is set.
   - The proved page's stored copy becomes the course page's reading (`public.svc_coverage_read_record`), so the $0 sweeps read it without a re-read.
   - Never admitted: a locked page, a page refused before, or one off the provider's own host.
6. **Schedule:** inside the job `link-refresh` (every 10 minutes), through `security.link_refresh_with_rollover_v1`. A rollover error never stops the link refresh. An item where nothing proved the course is tried again after `link_rollover.retry_days` (7).

## Settings (Settings › Pipeline settings › Layer 4)

| Setting | Value |
|---|---|
| `link_rollover.on` | 1 |
| `batch.link_rollover` | 60 |
| `link_rollover.items_per_call` | 15 |
| `link_rollover.in_flight_max` | 4 |
| `link_rollover.retry_days` | 7 |
| `link_rollover.min_chars` | 1500 |
| `link_rollover.page_markers` | 9 phrases |
| `link_rollover.fetches_at_once` | 4 |
| `link_rollover.request_lost_minutes` | 30 |

## Preview & Settle Batch in By university (s892)

A rule group whose cards are all of one queue that can be settled in a batch (Course link, among others; never entry requirements, departures or descriptions) has a settle box: one decision, one reason, and `SETTLE n` typed to confirm. Each card is decided on its own at the person's rank.

## Limits known at merge

- A handbook drawn by script (La Trobe, Melbourne) may not show the course CRICOS code in a plain read. Such a page is admitted only when the identity rule or the university's adapter proves it; otherwise it stays in Layer 4 with what was tried.
- Sydney's archived handbook addresses have no current-year page at the same path. They stay held.
