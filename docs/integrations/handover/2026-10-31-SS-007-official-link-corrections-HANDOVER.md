# Handover note: official course link corrections (StudySearch SS-007, batch A)

**Status:** **executed and verified** on 31 Oct 2026 between 13:31 and 13:39 AEDT, under Platform Admin decision D1 (31 Oct 2026 13:30). Evidence: transformation record §23 and §23.1.
**For the website developer and the Zoho developer:** sections 1 to 3, 5 and 6, plus the course list CSV. This is a data correction; the API itself has not changed.
**Audience:** Platform Admin, then the website team and the Zoho integration owner.
**Prepared:** 31 Oct 2026, from live reads and rolled-back dry runs on `fxcwkweaxjtknorudmwp`.

## 1. What changes for consumers

- **167 published courses** at 25 providers (all AU and one NZ) lose an official course link that is wrong today: their `official_url` (website) and official course URL (Zoho) become **null**. Null means "not held", as the guides already define it.
- **Why the links are wrong:** today they point to a shared page, not the course's own page:
  - a fee schedule (99 courses);
  - an application, enrolment or ESOS page (33);
  - a course list (45).
  - Ten more of the 177 bindings have no link shown today, so only the binding changes for them.
- **The list:** `docs/platform/ui-audit/2026-10-31-ss007-batch-a-official-links.csv` gives each course's API course id, code, title, provider, the link shown now, and any other spellings of the same page that are also taken away.
- **Nothing else in the response changes.** In the dry run the sample course's response kept every key. Only `official_url` (now null) and `freshness` (the projection time) differed, and restoring the course brought `official_url` back unchanged.

## 2. Compatibility assessment

| Check | Result |
|---|---|
| Endpoints, actions, filters | Unchanged |
| Response shape, keys, types | Unchanged. `official_url` is already nullable; 10,421 of 34,041 course documents carry no link today (live 13:05) |
| Identifiers (course id, provider id, codes) | Unchanged |
| Search behaviour | `has_official_url=true` no longer returns these 167 courses. That is the filter's documented meaning |
| Visibility (Published switch) | Unchanged |
| Website sync (`changed_since`) | These courses' `freshness` moves, so an incremental sync picks them up and clears the stored link |
| Zoho | The course lookup and search read the same projected link, so they also return null. The next Zoho sync picks them up the same way |
| Breaking change | None |

## 3. Version control

- **API contract:** `website-search-v2` unchanged. Developer guide stays at **issue 6** (31 Oct 2026). Zoho guide unchanged.
- **Proposed developer-guide version line** (only if the Platform Admin wants data notices in the guide; the 15 Oct 2026 rule keeps data corrections out of §13):
  > *Issue 6, data notice 31 Oct 2026 (no API change): 167 courses whose official link pointed to a shared fee, application or course-list page now return `official_url: null` until their own page is found. Clear stored links on your next `changed_since` sync.*
- **Platform release:** v2.15.379 (the hold and the governed correction function). The correction itself is a recorded data change: one remediation hold row per course, with its full before state.

## 4. Before and after checks (to run at execution)

| Check | Before (measured 31 Oct 12:50 to 13:31, live) | Expected after | Dry-run result (rolled back) |
|---|---|---|---|
| Published courses in the list showing a link | 167 | 0 | 0 |
| Of these, links that are the bound shared page | 126 | 0 | 0 |
| Of these, other spellings of the same page (e.g. `unisc.edu.au`, `tr4inright.edu.au/fees`, a snapforms application form) | 41 | 0 | 0 |
| Website `website_v2_course` sample (`course:cricos:00003g:000431k`) | `official_url` = UNE 2026 fee page | null; all other keys unchanged | null; only `freshness` also moved |
| Restore of the sample | — | link back | link back, identical value |

**At execution the agent also runs:**
- the same counts;
- a Website search with `has_official_url`;
- a Zoho course lookup for two listed courses;
- the consumer API drift check (`consumer-api-guard`).

## 5. Timing

- **Website and Zoho:** the change reaches them at the next search refresh after each batch. The correction requests the refresh itself; a refresh runs every 10 minutes, subject to its 30-minute gap.
- **Course record:** job `course-url-fill` empties `courses.course_url` at its next daily run, 13:23 AEDT. The links themselves change at once.

## 6. Rollback

- **Per course:** `security.binding_remediation_lift_v1('<course uuid>', 'restore', '<reason>')`. It restores the binding and the link, and requests a refresh.
- **Whole batch:** run that call for each open hold of the batch. The hold rows keep every before state.

## 7. What is not in this batch

- **125 courses on 38 school international pages and two ELICOS level pages:** held for person review (decision D2). 115 of them show such a page as their link today.
- **The 154 release candidates and the 1,012 verification reads:** not part of this change.

## 8. Result (live, 31 Oct 2026 13:39 AEDT)

| Check | Before | After |
|---|---|---|
| Listed courses with a search document | 173 | 173 |
| Website `official_url` present | 167 | **0** |
| Every other item field (md5 over all 173 items, excluding `official_url` and `freshness`) | `900cd49d` | `900cd49d` (unchanged) |
| Zoho `zoho_v2_course`, 8 UNE courses | fee pages | null, with the key still present |
| Website search, UNE, `has_official_url=true` | — | 105 of 130 (the corrected courses drop out) |
| Consumer API drift (`consumer_api_check_v1`) | none | none (75 functions, 48 relations) |
