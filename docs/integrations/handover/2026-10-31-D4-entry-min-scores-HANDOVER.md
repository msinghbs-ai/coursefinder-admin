# Handover note: `entry.min_scores[]`, several entry scores per course (StudySearch D4)

**Status:** released in v2.15.382 (PR #772, `115e40b3`), verified live at 14:24 AEDT on 31 Oct 2026.
**Audience:** the website developer; the Zoho developer for information.
**Guide:** Website API v2 developer guide **issue 7** (31 Oct 2026): §7.9, acceptance test 24 and the §13 line.

## 1. What is new

The course detail (`course` action) has a new key, `entry.min_scores`. It lists every entry score the course publishes, one item per route, exactly as the provider prints it:

| Field | Type | Meaning |
|---|---|---|
| `score` | number | The minimum as printed |
| `basis` | string | The short label recorded with the score (may not name the route) |
| `audience` | string | `international`, `all` or `domestic` |
| `scale` | string or null | The grading scale, only where the provider states one; never worked out |
| `quote` | string | The provider's own words; always names the route. **Show this** |
| `source_url` | string | The page the score was read from |
| `as_at` | date | When the source stated it |

- **Order:** international, all, domestic.
- **Always present:** `[]` when no score is held.

## 2. How to show it

- Show the scores as a list headed "Entry scores published for this course", one line per item, using `quote`, with international first.
- Never convert between routes, never call them "equivalent", and never compare them with the student's results.

## 3. Compatibility assessment

| Check | Result |
|---|---|
| Existing keys, types and values | Unchanged, including `min_score` and `min_score_basis` (same rule, same values) |
| Endpoints, actions, filters, identifiers | Unchanged |
| Search and sync | Unchanged (they do not carry `entry`) |
| Breaking change | None. A client that ignores unknown keys (acceptance test 18) is unaffected |
| Zoho | `zoho_v2_course` returns the same `entry` object, so it gains the same additive key. The Zoho guide does not describe `entry`, so it is not reissued |
| Size | At most about 1 KB per course |

## 4. Coverage

- **Courses holding scores:** 41 (116 items).
- **Courses with more than one route:** 24, all Monash. These are the courses where `min_score` alone showed only one route.
- **Courses that return `min_score: null` but list their scores in `min_scores`:** 2 (`021276J`, `111153D`).

## 5. Verification (live, 14:24 AEDT)

| Check | Result |
|---|---|
| Website `course`: courses with `min_scores` | 41 courses, 116 items; 24 courses with more than one item |
| `0101331` | 6 items; the first is `international`, IB 26 |
| `0100714` (`edu_country` IN) | 1 item ("2026 ATAR 73.00", domestic); `min_score` 73 and `resolution` unchanged |
| Zoho `zoho_v2_course` | `entry.min_scores` present |
| Consumer API drift after re-baseline | none |
