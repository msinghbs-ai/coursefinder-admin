# Course entry identity: pages shared by records of one programme

**Status:** for Platform Admin decision. **Prepared:** S1-Build, 26 Nov 2026 05:40 AEDT, under the 03:59 AEDT accelerated delivery mandate. Nothing has been changed; the safeguard is in force.

## Why this matters now

This one identity rule is now the largest single block on course entry admissions in Australia.

| Cohort (AU, active, open to international students, no active entry rows) | Courses | Held by this rule |
|---|---|---|
| Deterministic reader found requirements, refused only on identity (`not_admitted`) | 521 (46 providers, 4,735 readings, no AI needed) | 513 bound by `exact_title` |
| Never AI-read and not yet refused | 2,159 | 2,028 fail the identity rule or the read gate's course page check; only 131 pass (Window 4) |
| Window 3 (446 university courses read 26 Nov) | 446 | 299 held by the read gate, 188 of them as a "shared page" |

## What the evidence shows

Measured live (rolled back) on the 521 `not_admitted` courses:

- **Shared titles:** 520 of 521 share their exact title with another active course record at the same provider. They are the same programme recorded more than once, for example by campus or study mode.
- **Admitted siblings:** 518 of 520 have a same-title sibling whose entry requirements are already admitted (active).
- **Proven pages:** 90 courses (20 providers) are bound to the exact page that is already proven by CRICOS code or adapter for their same-title sibling, and that sibling has active rows.
- **Page binding:** 381 of the 521 pages are bound to that one course only; 516 are on the provider's own domain.

In Window 3, the read gate's course page check (`security.course_page_check_v1`) refused 188 pages as "shared by several courses ... nothing on it shows this course". The sample, Victoria University's Master of Counselling (international page), names the course and its level. It shows no other title or course, but more than one course record is bound to it.

## Why the safeguard exists

- **Rule:** AU entry requirements accept a page only on a CRICOS code, an adapter code or a person (`pipeline.coverage_admission_countries.identities`), because a title alone cannot say which record a page belongs to.
- **Siblings:** the evidence supports keeping that. 520 of 521 titles are not unique at their provider.
- **Wrong row admitted:** the risk is a sibling whose requirements genuinely differ (an online or international version), whose rows would be admitted from the other record's page.

## Options

1. **Keep the rule (no change).** These courses stay held. Recovery comes only from a CRICOS-proven page per record (a course page job), an adapter, or a person.
2. **Proven sibling page (smallest change; recommended).** For entry requirements, accept a page that is already proven by CRICOS code or adapter for a sibling record with the same provider, normalised title and qualification level, where the sibling's entry rows are active.
   - The same deterministic checks still apply (variant, shared-page and over-row-limit holds, quote and admission rules).
   - Releases 90 courses now from stored readings at $0, and more as siblings are proven.
3. **Programme-level admission.** Admit entry rows once per programme (provider, normalised title, level) and show them on every sibling record, keeping each record's own proof for fees and intakes.
   - The widest release: most of the 518 at once.
   - It changes the admission model, and needs a design and a G3 check of how the consumer API shows rows per record.

Every option keeps the US$5.00 daily limit, the 7,585 manual locks, G3 and Layer 4 for genuine decisions.
