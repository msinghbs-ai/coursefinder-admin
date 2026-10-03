# Scholarship sources review — 3 Oct 2026 (20:45 AEST)

Platform Admin asked (20:38) for a review of six scholarship sources, the Hotcourses scholarship position, and a plan for global coverage. Each site was read on the night with the normal fetcher first and the coverage-sweep worker (direct read, Firecrawl fallback) where that failed. Outcomes are recorded here so the design and the source registry can be compared against them later.

## What CourseFinder holds today (live, 20:20 AEST)

| Measure | Value |
|---|---|
| Active scholarships | 1,235, all Australian providers (NZ and CA: none) |
| By source | first-party provider pages 998 · Study Australia list 204 · first-party detail 26 · provider detail re-reads 6 · DFAT Australia Awards 1 |
| Audience (read from wording, Decision 244) | 311 international · 187 international and domestic · 278 domestic · 459 not stated |
| Published / ready | 123 published · 177 ready (international and both) |
| Course links | 131,859 (11,780 courses; 1,140 scholarships); 0 candidates waiting review |
| Stated award value / criteria / close date | 1,106 / 916 / 180 |

## Hotcourses — what was captured

Decision 232 (2 Oct): Hotcourses course directories for Canada (172 pages) and New Zealand (64 pages) were captured through Firecrawl with robots.txt respected — site maps, listing pages and 208 institution profiles — as hints and counts only. **No Hotcourses scholarship sitemap or category pages were captured**; the stored pages carry no scholarship links. The scholarship section address tried tonight (`/study/scholarships/australia/...`) is gone. Hotcourses terms bar commercial use without IDP's written consent; legal review stands before any further use. Position: Hotcourses is not a scholarship source for CourseFinder.

## The six sources

| Source | Read on the night | What it is | Structure seen | Fields per listing | Access and terms | Use for CourseFinder |
|---|---|---|---|---|---|---|
| internationalscholarships.com | Home page read; `/scholarships/search` gone | Commercial aggregator (same company as IEFA); claims 2,000+ awards | Search by field, host country, nationality | Amount, eligibility (citizenship, level, field, gender) | Contact details behind registration; no API/sitemap seen; no reuse terms seen | Comparison list only — not a source of record |
| iefa.org | Home and Browse Awards read (worker) | Same aggregator, international-student focus | Quick search: field of study (c.70 values), country of study (all countries), nationality | Not shown without drill-down | Registration for details; no API; no reuse terms seen | Comparison list; a benchmark for the field taxonomy |
| edupass.org databases page | 403 to the normal fetcher; read by the worker | Curated list of ~20 third-party scholarships and databases for international students in the US | Categories: competitions, women, developing countries, worldwide | Name, one-line description, link | Static page, no terms seen | Seed list of **funder** scholarships (Aga Khan, AAUW, Fulbright …) for the US — pointers, not records |
| studyaustralia.gov.au scholarships | Page read; search tool is script-rendered (no text) | Australian Government portal; the Course Search tool lists provider and government scholarships | Categories named: Australia Awards, Australia for ASEAN, RTP, provider scholarships, Quad Fellowship, state/regional | Provider, value, closing date, eligibility, link (in the tool) | Government site; already a CourseFinder source (204 records) | Keep; move the search-tool read to the worker (script-rendered) so new listings are picked up |
| dfat.gov.au Australia Awards | robots.txt timed out for both fetchers tonight | Government-funded scholarships by partner country (country profiles, dates, participating institutions) | One page per partner country | Country, eligibility, benefits, dates | Government; already a CourseFinder source (1 record) | Keep; read per-country profiles (c.30) on a schedule with a retry on robots timeout |
| internationalstudent.com scholarships | Read | Aggregator (registration to see details); lists Fulbright, Rotary, fellowships, loans | By host country, field, nationality, award name | Host contact | Registration; no API; no reuse terms seen | Comparison list only |

## Findings that shape the design

1. **Aggregators are not sources of record.** None of the four commercial sites publishes an API, a sitemap or reuse terms that allow ingestion; details sit behind registration. Their value is the taxonomy (field × host country × nationality) and as a completeness benchmark, as Decision 232 already says for course directories.
2. **Government portals are the sources of record for government money** — Study Australia (AU), DFAT (Australia Awards), and their equivalents (Education New Zealand / Manaaki scholarships; EduCanada / Vanier, Banting; Study UK / Chevening, GREAT; Fulbright and EducationUSA for the US).
3. **Provider pages are the source of record for provider money** (998 of 1,235 today), and that is where the course link lives — the counsellor's question is "for this course, what can this student get".
4. **Funder scholarships (Aga Khan, AAUW, Rotary, Quad) are a third kind**: not tied to a provider, tied to the student's nationality and field. They need a nationality dimension the schema does not yet carry as a first-class field (today it is a criterion).
5. Three questions therefore decide the module: the source registry (which classes of source per country), the record model (provider-tied / government / funder; nationality as a dimension), and the serving layer (selection for a course + a semantic search over criteria for the website and Zoho).
