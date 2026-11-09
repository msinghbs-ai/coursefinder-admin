# NZ enrichment brief: verification, release plan and primary metric

**Date:** 23 Oct 2026 (Fri, Melbourne), 20:30
**Follows:** `2026-10-23-nz-enrichment-brief-assessment.md` (approved in principle by the Platform Admin at 20:30; nothing created)
**Status:** plan only. Nothing in this document has been built.

## PART 1 — Verification queries

One correction first: the assessment said "429 universities without an English rule page". The figure is **429 NZ courses** whose institution has no rule page found yet. Fixed in the assessment, with the four checks below added as its section 9.

### 1. Polytechnic count

```sql
select s.provider_name, s.nzqa_type, s.signatory, s.provider_code, p.canonical_name platform_name
from pipeline.nz_cop_status s
left join catalogue.provider_identifiers i on i.scheme='nzqa' and i.identifier=s.provider_code
left join catalogue.providers p on p.id=i.provider_id
where s.nzqa_type='POLLY' order by s.signatory desc, s.provider_name;
```

All 17 are `POLLY`, all `signatory = true`:

| Group | NZQA code → platform name |
|---|---|
| Re-established 1 Jan 2026 (10) | 6006 Ara · 6007 EIT · 6010 MIT · 6004 Unitec · 6011 NMIT · 6013 Otago Polytechnic · 6015 SIT · 6025 Toi Ohomai · 6009 UCOL · 6019 Wintec |
| Still inside NZIST (5) | 6022 Open Polytechnic · 6012 NorthTec · 6024 Tai Poutini · 6017 WITT · 6014 Whitireia and WelTec |
| NZIST entity rows, not polytechnics (2) | 6683 NZIST (head entity) · 6044 NZIST Work-Based Learning (Competenz, Connexis, Careerforce, ServiceIQ, Primary ITO, EarnLearn) |

**Delta explained:** 17 = 10 + 5 + 2. The brief's "~14" omits the Open Polytechnic (which stays in the NZIST federation) and the two NZIST entity rows. The register already shows the brand problem: the five NZIST members carry the register name "New Zealand Institute of Skills and Technology"; the platform keeps their own names and codes. Verify the standalone list against the Government's published decision before seeding item 1; the list above is from memory of the July 2025 decision.

### 2. Backbone cadence

```sql
select jobname, schedule, command, (last 3 runs) from cron.job
where command ilike '%nz_cop%' or jobname ilike '%layer1%' or jobname ilike '%register%';
-- and the Layer 1 source operation for the NZQA directory
select ... from pipeline.layer1_source_operations where authority_name ilike '%NZQA%';
```

| Job / source | Cadence | Last runs |
|---|---|---|
| `nz-cop` (reads signatory status from stored register pages) | every 10 min, but only reads batch files captured within `nz.cop_window_days` (3) of capture | 09:10, 09:20, 09:30 UTC 23 Oct, all succeeded, nothing new to read |
| NZQA provider directory ingestion (Layer 1) | **every 30 days** (`ingestion_cadence_days` 30; Platform Admin decision 8 Oct 2026, "Monthly for both"); verified every 30 days; 415 providers, variance 0% | last capture 3–10 Oct; next ingestion 9 Nov |
| NZQA organisation types (Decision 258) | every 7 days | verified 21 Oct; next 28 Oct |
| `coursefinder-layer1-regulatory-scheduler` | hourly at :05 (drives the above) | 07:05, 08:05, 09:05, succeeded |

**Flag: not weekly.** The signatory read is effectively monthly because it follows the monthly directory capture. It was a deliberate decision on 8 Oct, but during the NZIST transition the brief is right. Recommendation: set the NZQA directory to 7 days until 31 Mar 2027 (a logged settings change on the Layer 1 operations screen, no migration). Included in Release 1.

### 3. Floor settings scope

```sql
select k.iso_alpha2, a.active, a.currency_code, count(distinct p.id) providers,
       count(c.id) filter (where c.lifecycle_status='active') active_courses
from ref.countries k join catalogue.providers p on p.country_id=k.id
left join catalogue.courses c on c.provider_id=p.id
left join pipeline.coverage_admission_countries a on a.country_id=k.id group by 1,2,3;
```

| Country | Admission | Currency | Providers | Active courses | Annual international fee rows | Rows under 8,000 |
|---|---|---|---|---|---|---|
| AU | active | AUD | 1,556 | 26,103 | 8,265 | 109 (1.3%) |
| NZ | active | NZD | 415 | 6,474 | 1,269 | 22 (1.7%) |
| CA | active | CAD | 1,130 | 3,806 | 574 | 66 (11.5%) |

Scope is three countries. **Design:** the floor is not a scalar setting. It is a column, `min_annual_international`, on `pipeline.coverage_admission_countries`, which is already keyed by country and already holds each country's currency. Any country added later carries its own floor (null = no floor, shown as a warning on the settings screen). Edited on Settings › Pipeline settings, logged. Starting values to confirm: NZ 8,000 NZD (the brief), AU 8,000 AUD, CA 8,000 CAD. CA's 11.5% says Canadian pages often quote per-term or per-credit figures the reader has taken as annual; the floor sends those to review, which is the point.

### 4. Fee floor semantics

**Confirmed: advisory quarantine.** At admission, an international fee on an annual basis below the country floor goes to Layer 4 with the reason "international fee below the country floor (NZ$8,000 a year)". It is never rejected, never dropped, and the page copy and quote stay attached. The person keeps or removes it.

```sql
select p.canonical_name, c.canonical_title, sl.name, f.amount, f.fee_year, f.confidence, f.source_fee_key
from catalogue.course_fees f ... where country='NZ' and audience='international' and status='active' and amount<8000;
```

All 22 are adapter-read (confidence 1.0, not AI) and each is the course's only fee row. Proposed disposition:

| Provider | Rows | Amounts | Disposition | Why |
|---|---|---|---|---|
| MITO | 8 | NZ$1,189 each | Withdraw to review | Identical figure across 8 apprenticeship certificates: a domestic or programme fee |
| Te Wānanga o Aotearoa | 2 | 1,100–1,250 (2027) | Withdraw to review | Wānanga fees are largely domestic fee-free; not an international figure |
| Institute for Child Protection Studies | 1 | 1,165 | Withdraw to review | Level 5 diploma at that price is domestic |
| Tai Poutini Polytechnic | 5 | 3,173–7,848 | Withdraw to review | Part-year certificates are possible, but TPP's international fees run higher |
| The Learning Connexion | 4 | 3,913–7,044 | Withdraw to review | A Level 7 diploma at 6,909 is implausible for international |
| NZ College of Chinese Medicine | 1 | 7,845 | Keep live, flagged | English-language certificate, short; plausible |
| University of Waikato (CAEL) | 1 | 6,804 | Keep live, flagged | Short English course; plausible |

"Withdraw to review" means status `review`, off the website until decided, restored on approval. 2 kept, 20 withdrawn. Platform Admin's call on any row.

## PART 2 — Release plan (nothing built)

### Release 1: items 1, 2, 3, 4, 10, plus the cadence change

| Item | Migrations | Edge functions | Cron | Settings | Effort | Depends on |
|---|---|---|---|---|---|---|
| 1 Transition flags | `pipeline.provider_transitions` (provider_id, risk: `none` / `nzist_federation_until_2027` / `re_established_2026`, note, as_at, source_url, decided_by), commented, RLS on; seeded with the 15 rows above; shown on the provider page | none (`site_check` and `source_find` modes exist) | one new catalogued job `transition-recheck`, monthly: re-verifies the website and re-runs the source finder for flagged providers | `transition.recheck_days` (30–180, 90) | ½ day | The Government list verified |
| 2 Domain-moved action | `public.admin_provider_domain_moved(provider_id, new_host, reason)` (Platform Admin, logged): rewrites the host on that provider's bound course pages and course-list sources, keeps identity proof and evidence, sets them to read now; UI: Adapter builder › Change website gains "move the course pages too" | none | none (existing read jobs do the re-reads) | none | ½ day | Ships with 1: a transition without this leaves pages in `fetch_failed` until re-searched |
| 3 Signatory authority | `pipeline.nz_cop_status` gains `basis` (`provider_page` / `signatory_list`) and `as_at`; `security.nz_cop_apply_v1` takes the list first, the provider page second; universities move from "decision" to register fact; a new Layer 1 source row for the NZQA signatory list page (weekly) | worker v0.44.0: `nz_cop` mode reads the single signatory list page | existing `nz-cop` and Layer 1 scheduler | NZQA directory `ingestion_cadence_days` 30 → 7 (logged, no migration) | 1 day | robots.txt on the list page checked first |
| 4 Fee floor | `min_annual_international` on `pipeline.coverage_admission_countries` (NZ/AU/CA 8,000, logged); md5-guarded edits to the two admission paths (`svc_fee_ai_record` and the adapter path in `coverage_apply_course_v1`): below floor → Layer 4 with reason; one-off section applying the 22-row disposition above; Settings UI shows the floor per country | none | none | the floor per country | 1 day | Live md5s of both functions taken before the edit |
| 10 NZ proof for English and intakes | none: a logged settings write adding the code proof to NZ `english` and `intakes` identities; UI label for NZ shows "NZQA / programme code" instead of `cricos_code` (`src/PipelineSettings.jsx`) | none | none | identity.attribute for NZ | 1 hour | — |

Full suite, dry run of each migration on the live database, applied before merge, SOPs and change control, as every release today.

**G3 check:** none of these touch `website_*`, `api.*`, `zoho_*` or the shape of any table they read. New columns go on pipeline tables only. `enrols_international` keeps its value for universities (true), with a better basis. Confirmed: no consumer-API change.

### Release 2: item 7, RLS pass

**Step A, role-usage proof (read-only, before any migration):**
1. `information_schema.role_table_grants` for `anon` and `authenticated` on the 43 tables: if neither role has a grant, PostgREST cannot read them whatever RLS says.
2. Every `security invoker` function or view executable by `authenticated` that references any of the 43 (`pg_get_functiondef` / `pg_get_viewdef` text search), since those run as the caller.
3. 7 days of `pg_stat_statements` and the API logs for statements by `anon`/`authenticated` naming any of the 43.
Result recorded in the admin repo before Step B.

**Step B, migration:** `enable row level security` on each of the 43 with no policies (service_role and the platform's `security definer` functions bypass RLS; nothing else gets through), a `comment on table` line stating why, catalogue untouched. The housekeeping contract (s42) and the consumer-API guard run before merge. Effort: ½ day plus the proof.

### Release 3: item 6, merge proposals

- `pipeline.merge_proposals` (id, provider_id, kind: `same_title_level` / `same_code` / `rebrand`, left_course_id, right_course_id, reason, evidence jsonb, state: `proposed` / `merged` / `kept_both` / `dismissed`, decided_by, decided_at, created_at), commented, RLS on; seeded with the 62 same-title pairs.
- `security.merge_proposals_scan_v1()`, catalogued weekly job `merge-proposals` (Sunday): same title and level and campus within a provider, or the same NZQA course code.
- Layer 4 › Merge proposals screen: Keep both / Merge into left / Dismiss, each with a reason, logged.
- `public.admin_course_merge(left, right, reason)` (Platform Admin): moves fees, intakes, campus links and links the left course lacks, sets the right course's `lifecycle_status` to `merged` with `merged_into`. The website already hides non-active courses, so no shape change.
- Nothing merges by itself. Effort: 2 days.

### Item 5, options analysis (not implemented)

**The problem:** 13.9% of NZ courses carry `course_url`; 53.5% have a bound, identity-proofed page. About 2,560 NZ courses have a page the website and Zoho cannot show.

| Option | What happens | For | Against |
|---|---|---|---|
| **A. Fill `course_url` from the bound page where empty** (logged admission) | A job writes the bound page's final address into `course_url` only where it is null, only from pages bound with an identity proof (never `mismatch` or `ambiguous`), honouring manual locks, and re-fills when the binding changes | ~2,560 NZ courses (and the AU/CA equivalents) gain a link with no API change; reversible (logged, `enrich_value_retractions` pattern); the developer guide needs no reissue because a nullable field is simply populated more often | A wrong binding becomes visible to students; the 23 Oct take-backs show bindings have been wrong, though those were `mismatch` pages, which this excludes |
| **B. Leave it** | Nothing changes | No risk | Students see no link on 40% of courses that have one; Zoho the same |
| **C. API change: a new `official_page_url` field beside `course_url`** | Adds a field to the consumer shape | Keeps `course_url` as the register's own link | Needs Decision 266 approval, a baseline re-take, a developer-pack reissue, website work; delivers nothing A does not |

**Recommendation: A**, with the three guards (proven binding only, locks honoured, re-fill on change) and a one-line note to the website developer that the field is now filled more often. It is a G3 decision because it changes what students see, so it waits for the Platform Admin's yes.

## PART 3 — Primary metric: course-page binding

**Current:** 3,467 of 6,474 active NZ courses have a bound page (**53.5%**).

```sql
-- providers bucketed by share of their courses bound
select bucket, count(*) providers, sum(courses), sum(bound) from (...) group by 1;
```

| Providers | Bound share | Providers | Courses | Bound |
|---|---|---|---|---|
| Well covered | ≥ 80% | 42 | 1,210 | 1,042 |
| Partly covered | 30–79% | 83 | 3,952 | 2,355 |
| Barely covered | 1–29% | 26 | 474 | 70 |
| None | 0% | 136 | 838 | 0 |

**The levers, and how far each has run on NZ:**

| Lever | Run on NZ so far | What it would reach |
|---|---|---|
| Source finder (`source_find`: learns the course-page pattern, reads robots and site maps, Firecrawl map) | 30 of 287 providers with courses (15 found, 6 tested, 9 none); NZ is enabled | The 83 partly-covered providers hold 1,597 unbound courses: the biggest pool, and the finder works best where some pages are already known |
| Course list reader (`course_list_read`) | 24 providers, 34 lists, 24 read | Fills in where a finder gives a list page |
| Programme reader (`programme_discover` / `programme_read`) | 0 NZ providers | Universities and polytechnics with programme site maps |
| Page search and AI match (already running) | the remaining cause for 1,693 + 1,056 courses | Slow and credit-bound; the finder should replace it where it can |

**Target:** 75% within 30 days (about 1,400 more courses bound), 85% by 31 Dec 2026. The route is the source finder over the 257 NZ providers it has never run on, starting with the 83 partly-covered ones, then programme discovery for the universities and polytechnics. The 136 providers with nothing bound hold only 13% of courses and are mostly brochure-site PTEs; they come last. No new crawler. The hourly report gains two lines: NZ bound % and courses bound in the last 24 hours.

**Next decision from the Platform Admin:** go on Release 1 as scoped (including the cadence and disposition choices above), and a yes or no on item 5 option A.
