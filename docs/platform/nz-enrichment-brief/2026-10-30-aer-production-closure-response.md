# AER production closure: response (Claude, main integrator)

**Mandate:** `2026-10-30-aer-production-closure-mandate.md`, read from GitHub at 22:30 AEDT.
**Status:** in progress. Sections are filled in as each stage is verified.
**Live project:** `fxcwkweaxjtknorudmwp` only.

## 0. Decisions taken under this mandate (lodged before code)

### C1. The course outcome register is a derived table rebuilt by a catalogued job; operators download it from Resolution inspection (22:36 AEDT)

Mandate §4 asks for one primary, operator-exportable outcome for every in-scope AU/NZ course.

**Measured constraint:**
- The classification reads every active AU/NZ course (31,854 at 22:35) with its bound page, its stored copy and the entry-identity rule.
- The identity part alone took 3.6 s in a timed read.
- Signed-in users have an 8 s statement limit, so a live read on every open would sit close to time-outs.

**Design:**
- **Table `pipeline.aer_course_outcomes`:** one row per course, derived and read only, never read by the consumer API.
- **Table `pipeline.aer_course_outcome_builds`:** each build's time and its count by outcome. This gives an hourly history of consumer coverage.
- **Job `aer-outcome-register`:**
  - catalogued (G1);
  - checks every 5 minutes;
  - rebuilds when the register is older than setting `aer.outcome_register_every_minutes` (60);
  - one build at a time.
- **Scope:** active courses of providers in the countries of setting `entry.course_read_countries` (AU and NZ today). No country is written into code (G2).
- **One primary outcome per course**, taken in this order:

| # | Outcome | Rule |
|---|---|---|
| 1 | Admitted course requirement | The course has an active course-level row |
| 2 | Admitted provider resolution | The provider has active provider-table rows: the resolver answers from the band table or provider minimum |
| 3 | Awaiting Layer 4 review (course read) | The course's own read waits in Layer 4 |
| 4 | Verified: no requirement on the page | The course's read finished and kept nothing; the reader's reason is kept |
| 5 | Awaiting Layer 4 review (provider table) | The provider's table waits in Layer 4 |
| 6 | No official course URL | No course page was found |
| 7 | Unresolved or mismatched identity | The page is a mismatch or ambiguous, or its identity basis is not accepted for entry requirements |
| 8 | Source unreadable | The read was held or failed, or there is no stored copy |
| 9 | Excluded, with a reason | The provider is outside the entry-read scope, or the course is eligible but its read is deferred (expansion frozen by this mandate) |

  - **Why a waiting provider table comes before URL and identity:** a provider table, once approved, answers for every course of that provider, with or without a course page. Those courses are waiting on review, not on a URL.
  - **Why a verified "nothing on the page" comes before a waiting provider table:** it is a finished, evidenced outcome for the course page itself. The waiting provider table is still named in the row's detail.
  - The register holds 8 outcome codes: the two "awaiting review" rows share the code `awaiting_review` and differ in their detail.
- **Read: `public.admin_aer_outcomes`:**
  - rank 4 (Pipeline Operator) and above, using the A5 idiom;
  - a summary, plus pages of rows for download (setting `aer.outcome_register_page_rows`, 5,000);
  - shows when the register was built and its age.
- **Screen:** Catalogue › Entry requirements › Resolution inspection gains a "Course outcome register" section with the counts and **Download CSV**.
  - It is a section within an existing view, not a new page.
- **Nothing is admitted, read, queued or changed by it.** The consumer API is untouched.

## 1. Verified delivered results (as at 22:53 AEDT)

### 1.1 D5 verified, not re-run

The paste was not re-run. Verified read-only on `fxcwkweaxjtknorudmwp`:

| Check | Result | Source |
|---|---|---|
| `security.entry_matrix_payload_v1` | md5 `5f7eb755` (expected after-md5) | `md5(pg_get_functiondef)`, 22:30 and 22:46 |
| `security.entry_resolve_v1` | md5 `69bbc05f` (expected after-md5) | same |
| D5 consumer baseline | Re-taken by the paste at 22:19:48; re-taken again by migration `20261030280000` at 22:44:48 | `pipeline.consumer_api_baseline.captured_at`, `reason` |
| Consumer functions drifting from the baseline | 0 | Baseline md5 against live, read with the empty search path the baseline uses* |
| `scale_stated` on provider items | 343 of 343 active RMIT items carry it: 310 `true`, 0 `false`, 33 `null` (all 33 have `scale` `none`, case by case) | `security.entry_matrix_payload_v1` over every provider with active rows |
| Through the Website API v2 path | `public.website_v2_provider('provider:cricos:00122a','IN')` returns 33 items for India, each with `scale_stated` | read-only call |
| Existing fields | Unchanged. The India and Taiwan examples carry every issue-5 key with the same values, plus `scale_stated` | same |
| Distinctions kept | No-scale grade `false`; case by case `null` with `scale` `none`; no published requirement is resolver step 5 `contact_provider` (course `0100714`, IN: step 5, unchanged) | `public.website_v2_course('0100714','IN')` |

*A first read in my own session showed 3 `api.*` vector functions differing. Re-read with `search_path` empty (as `consumer_api_rebaseline_v1` runs), all 3 match. This was a session artefact, not drift.

**The two failed runs before success:**
- **16:5x:** CRLF line endings changed the inserted text.
- **18:50:** the SQL editor's auto-indent changed it.
- Both rolled back on the md5 guard with nothing changed (live status, 17:01 and 18:55).

### 1.2 v2.15.375 released

| Step | Evidence |
|---|---|
| Integration | Branch `cf247-v2-15-375` from main `a8e02461` with `cf247-d5-lane` merged. Migrations numbered `20261030280000` and `20261030290000`. Release ceremony 2.15.375 / 0.1.302; `release:verify` PASS |
| Live dry run of `20261030290000` | `admin_aer` `09dbbaf2` → `5e58f5d6`, applied then rolled back |
| Live md5s just before merge (22:42) | `5f7eb755`, `69bbc05f`, `09dbbaf2` |
| Local full suite | **1,271 passed, 0 failed, 0 skipped** (10.2 min, 22:42) |
| Test register | Regenerated (s182 added); admin commit before change control |
| Change control | Appended to all 5 files, verified by fresh clone (admin `25e35aab`) |
| PR | #765, squash-merged as `6f006619` |
| Post-merge workflows | Deploy on merge, Release History Contract, **Release Currentness Deployed** (`41050259866`), **CourseFinder Deployed UAT** (`41050259817`, targeted) and Pilot Frontend Build: all success |
| Live after deploy (22:46) | `admin_aer` `5e58f5d6`; migrations 20261030280000 and 20261030290000 recorded in `supabase_migrations.schema_migrations`; consumer drift 0 |

The worker's live version string could not be read directly: this session's proxy refuses the workers.dev host and the job-log download. The evidence is the green Release Currentness Deployed run, which asserts it.

### 1.3 Course outcome register (decision C1): built, not yet shipped

- **Branch:** `cf247-v2-15-376` (`4967c0b8`). It contains:
  - migration `20261030300000_cf247_aer_course_outcome_register`;
  - the Resolution inspection section with Download CSV;
  - specs s184 (8 tests: contract and mocked browser) and s185 (deployed, read only);
  - release ceremony 2.15.376 / 0.1.303.
- **Passing locally:** s184 8 of 8, with s32, s42, s57 and s120.
- **Live dry run of the build (rolled back, 22:38):** 31,855 courses, built in 13.2 s; a 5,000-row download page read in 51 ms.
- **Held before merge:** the live dry run of the whole migration file (post-check, job, grants) did not complete. The database tool's server asked the session a question at about 22:50 and got no answer, so the tool stopped. The full suite, merge and post-deploy verification wait for database access to return.

## 2. Current measured position (live, 22:35 to 22:45)

### 2.1 Course outcome register (first cut, from the C1 classification run live)

| Outcome | AU | NZ | Total | Of published providers |
|---|---:|---:|---:|---:|
| Admitted course requirement | 0 | 0 | **0** | 0 |
| Admitted provider resolution (RMIT table) | 507 | 0 | **507** | 507 |
| Awaiting Layer 4: course read | 349 | 349 | 698 | 698 |
| Awaiting Layer 4: provider table | 5,210 | 2,357 | 7,567 | 7,567 |
| Verified: no requirement on the page | 45 | 71 | 116 | 116 |
| No official course URL | 1,669 | 638 | 2,307 | 1,430 |
| Unresolved or mismatched identity | 7,397 | 2,832 | 10,229 | 9,745 |
| Source unreadable (held long pages) | 6 | 1 | 7 | 7 |
| Excluded: eligible, read deferred (expansion frozen) | 905 | 17 | 922 | 922 |
| Excluded: provider outside the entry-read scope | 9,292 | 209 | 9,501 | 9,214 |
| **Active AU/NZ courses** | **25,380** | **6,474** | **31,854** | |

The C1 build run at 22:38 counted 31,855, one course more. The register's own build after release supersedes these figures.

### 2.2 Layer 4 AER queue (unchanged since 16:48)

| Kind | Pending | Rows proposed | Providers |
|---|---:|---:|---:|
| Course entry first read | 997 | 3,579 | 14 |
| Provider table, first run | 54 | 2,168 | 28 |
| Provider table, change (RMIT) | 4 | 37 | 1 |

- **Decisions:** 0 AER decisions since 29 Oct; 0 since the 16:45 mandate.
- **Active rows:** course 0; matrix 343 (RMIT).
- **Consumer-admitted coverage:** 1 provider (RMIT) by provider table, 507 courses; 0 course-level.
- **Reviewer effort:** estimated, not measured, because throughput is still 0. At the manifest's rates (1 minute per course item, 3 minutes per provider item), about 16.6 h for course items and 2.9 h for provider items, about 19.5 h in all.
- **Leverage:**
  - The 58 provider-table items, about 3 h, would let the resolver answer for up to 7,567 more courses at 28 providers.
  - The 997 course items, about 17 h, cover 698 courses outside RMIT.
  - Manifest step 2 (provider tables) is therefore the highest-value review.
