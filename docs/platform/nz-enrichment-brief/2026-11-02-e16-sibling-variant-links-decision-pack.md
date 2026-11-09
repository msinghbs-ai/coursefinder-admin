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

## Per-course confirmation (read only, 2 Nov 07:00 AEDT)

**Files:** `ui-audit/e16-sibling-variant-cohort-2026-11-02.csv` (77 rows) and `…-summary.md`. The cohort rebuilds exactly: md5 `1374432181…`.

| Class | Courses | md5 of sorted ids |
|---|---|---|
| Confirmed sibling award (62) or older handbook year (5) | **67** | `e30cf5d986d2ace0ffe94b9e440853fe` |
| False positive (Lennox 108224J) | 1 | `e35721bbc7b03411168843d6b8571f41` |
| Unclear: the handbook code does not name the award (La Trobe 3, UniMelb 5, Canberra 1) | 9 | `c88d5936b30660d357732503bf78dd79` |

- **Fees read from the sibling page on confirmed courses:** 31 fees on 31 courses, fee ids md5 `fa15331cda52edbb2d4ea0cff1cd6c26`. This set replaces stream B's 31: it drops Lennox and adds La Trobe 102427B.
- **By provider:** RMIT 18, UniMelb 14, La Trobe 8, Griffith 7, others the rest.
- **No hand locks** on any of the 77.
- **Classification limit:** stored copies are in storage and could not be read here, so classes are judged from the title and URL slug. The 9 unclear courses need a person.

**What this changes in the options:**
- **E16-2 alone is not enough.**
  - On 26 confirmed courses, course_url itself is the sibling page.
  - 18 courses have no course_url.
  - On 4 Griffith courses, the sibling link is marked primary.
- The course's own page is held as an active link on about 25 courses, possibly 14 more, and not at all on 38.
- So containment (E16-4: show no link rather than a wrong one) is needed for most confirmed courses. E16-2/E16-3 help only where the own page is held and primary/course_url point to it.

**Revised recommendation:**
1. E16-1 (prevention).
2. E16-4 on the **67 confirmed** courses (SS-007 hold route: URL null at the website and Zoho; reversible).
3. E16-5 on the **31 confirmed fees** (E1 way, count-guarded, rollback).
4. A person reviews the 9 unclear courses.
5. E16-2/E16-3 as follow-up hygiene for the 239 multi-link courses.

## Containment plan under the 07:21 direction (read only, 2 Nov 07:29–08:00 AEDT). Nothing executed

Files: `ui-audit/e16plan/` (report.md, batches.json, fees.sql, guardcheck.sql). All cohort md5s re-verified.

**Finding 1: most of the cohort comes from an approved rule, not a mis-binding.**
- The hourly job `exit-awards-apply` (:37; `security.exit_awards_apply_v2`, enabled per university through the adapter's `admit_fields` 'exit_awards') links a nested or exit award to its parent course's page.
- It also writes the parent's annual fee, with the note "Award within the course on this page (n years…): annual fee as the course, whole fee … (annual × n)".
- It covers **53 of the 67** confirmed and 8 of the 9 unclear.
- It ignores remediation holds, so any hold on these would be rewritten within the hour.
- Of the 31 sibling-page fees, 29 are this rule's output. 17 of those equal the CRICOS fee once scaled to the award length. Only **2 are straight misreads** (Flinders 105122F, UQ 116548M).

**Finding 2: the existing hold contains only 12 of the 67.**
- `binding_remediation_apply_v1` acts only where the coverage page is bound to the wrong URL. It would contain 12 (Bond 3, Collarts 2, USyd 2, Flinders, SISTC, Torrens, UQ, UTS).
- It refuses 55: 49 are bound to another page (often the course's own), and 6 RMIT are already `mismatch`.
- Side effect: retracting 12 recent URL fills would push the fill retraction rate over 5%, and `course-url-fill` would pause itself platform-wide.

**Finding 3: no reusable Layer 4 items.** None of the 77 has a pending course-link or fee item, and no governed function raises an ad-hoc item. A hold does not appear on any screen today.

**Finding 4: page blocks not honoured.** USyd 000723J and 105221C, and UTS 114585M, have page blocks since 8 Oct, yet the same pages are bound and shown.

**Decision needed before any write** (the 07:21 direction: "the existing classification is a candidate assessment, not proof"):
1. **Is a nested or exit award's link to its parent page, written by the approved exit-award rule, valid?**
   - It is valid where the parent page names the award as available within the course (the 07:21 direction: "genuine shared-page exceptions"; "validate the exact section or programme-specific evidence").
   - If yes, the 53 rule-covered courses are not defects once their evidence shows the parent page names the award. That evidence check is part of E16-1.
   - The fees are the rule's documented derivation and stay.
2. **For the remaining 14 confirmed not covered by the rule, plus the 2 misread fees:** contain them. Use the hold where it applies; otherwise set the wrong links to `unverified` with a count-guarded paste (E15 Part 1 pattern), and withdraw the 2 fees the E1 way.
3. **If exit-award links are not valid for some or all universities:** switch those exit-award rows off (`admin_exit_awards('off')`, Platform Admin signed in, reversible), then contain as in 2. Also decide whether to accept the URL-fill pause or raise its limit first, and whether to raise the 67 Layer 4 link items by paste.
