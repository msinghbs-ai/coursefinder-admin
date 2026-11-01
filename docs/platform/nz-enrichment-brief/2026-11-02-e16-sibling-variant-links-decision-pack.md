# E16: published course pages and fees from a sibling programme (decision pack, 2 Nov 2026 06:40 AEDT)

**Found by:** SS-015 Gate B stream (read-only, 2 Nov 05:50–06:20). Two examples were confirmed independently by the integrator. Evidence: `2026-11-02-ss015-gate-b-data-integrity.md` §4b, §4c and P1-A.
**Severity:** P1. It becomes P0 if a fee read from another programme's page is treated as incorrect published data, as E1 was.
**Nothing has been changed.** The 2 Nov 05:18 decisions do not cover this cohort.

## What is wrong

| Course | What the website and Zoho show | Should be |
|---|---|---|
| RMIT Graduate Diploma of Advertising (103222G) | Master of Advertising page; AUD 45,120 | Its own page. This page is held (= course_url) but is not the one shown |
| Griffith Graduate Certificate in Professional Accounting (107421A) | Master of Professional Accounting page; AUD 42,500 (the Master's rate) | Its own page. Not held |

**Two causes:**
1. **Linking does not check the qualification level.** The course-page sweep (`provider_course_page_sweep`) binds a Graduate Certificate or Diploma to its parent Master's page, or to an older year's handbook. 61 courses are found by a title-vs-URL level check. The check is a heuristic: at least one false positive is known (Lennox 108224J).
2. **When a course has several active official links and none is primary, the projection shows the most recently verified one, not course_url.** 239 courses hold more than one active official link:
   - 165 hold a reviewer link (made before the E15 fix), which is shown on 164 of them;
   - 33 hold different pages with no primary, and 10 of 10 sampled show a sibling or older-year page.

**Cohort:** 77 AU courses (the union of the two groups; md5 of the sorted ids `1374432181aca2abb3ec525448b66923`):
- 53 show a provider fee;
- 31 of those fees were read from the sibling page itself.

## Options (decide each line)

| # | Action | Type | Effect | Guards and rollback | Recommended |
|---|---|---|---|---|---|
| E16-1 | **Prevention (engineering):** the course-page sweep and binding refuse a page whose qualification level differs from the course title's (setting-driven, provider exceptions allowed). Fixture-tested | Engineering release | New wrong bindings stop. No existing data changes | Spec with real examples, including the Lennox false positive as an allowed exception | **Yes** |
| E16-2 | **Projection tie-break (engineering):** when no official link is primary, show the link equal to course_url, then the most recent. Consumer API shape unchanged; values change on the affected courses | Engineering release that changes published values (not shape) on up to 33 courses | RMIT-type courses show their own page | Before/after list of every changed URL; can be reverted by release | **Yes** |
| E16-3 | **Make the reviewer link primary on the 165** (the same repair as E15 Part 1, generalised): old links made inactive | Data correction, count-guarded paste | One link per course, = course_url | Paste with exact ids, md5 and rollback, prepared before running | Yes, after E16-2 |
| E16-4 | **Contain the confirmed sibling-variant courses:** a person confirms each of the 77 against its stored page (removing false positives); confirmed courses go into the SS-007 hold route, so the website shows URL null rather than a wrong page | Data correction, UI or count-guarded | Students no longer sent to another programme | Per-course evidence list; reversible (release the hold) | Yes |
| E16-5 | **Withdraw the provider fees read from the sibling page** on confirmed courses (up to 31), the E1 way | Data correction, count-guarded paste with rollback | Those courses show no provider tuition (CRICOS fee kept where held) | Exact ids, md5, rollback | Yes |

**Order:**
1. E16-1 and E16-2 (engineering, released together after the E13 gate);
2. E16-4 confirmation list (read-only preparation; I can start now);
3. then E16-3, E16-4 and E16-5 as guarded data tranches.

**Answer format:** "Approve E16-1 … E16-5", or one by one.

**SS-015 effect:** Gate B line 4 (bindings blocked) stays **Fail** until at least E16-1 is live and the cohort is contained (E16-4/E16-5) or accepted as residual P1 with containment.
