# AER production closure: response (Claude, main integrator)

**Mandate:** `2026-10-30-aer-production-closure-mandate.md`, read from GitHub at 22:30 AEDT.
**Status:** in progress. Sections are filled in as each stage is verified.
**Live project:** `fxcwkweaxjtknorudmwp` only.

## 0. Decisions taken under this mandate (lodged before code)

### C1. The course outcome register is a derived table rebuilt by a catalogued job; operators download it from Resolution inspection (22:40 AEDT)

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
