# Handover note: academic entry corrections and `course_general` (StudySearch D9) — DRAFT

**Status: PROPOSED — not live.** Prepared 27 Nov 2026 by S1-Build for the Platform Admin to send. The change (Pilot #1709, s1286) is released only after the Platform Admin confirms this note was sent to both developers. The released note carries the release date.
**Audience:** the website developer (Wix); the Zoho developer (section 4).
**Guides:**
- Website API v2: issue 8 draft, sections 7.9 and 13.
- Website API v3: issue 1, section 7.9.

**Address and key:** unchanged.

## 1. What changes

Three corrections to the academic entry data the API returns. Nothing is renamed or removed, and no field changes type.

| # | Where | Before | After |
|---|---|---|---|
| 1 | `entry.requirements_note`, and `entry.resolution` for international readers | Could include a requirement the provider states for **domestic students only** (for example "Equivalent to Australian Year 12.") | Domestic-only requirements are not returned. The API serves international students |
| 2 | `entry.resolution` (with `edu_country`) | When the provider publishes nothing for the student's country, the answer was always `contact_provider`, even when the course states a requirement for all international students | **New value `rule: "course_general"`** (`step` 5, `scope: "all_countries"`): the course's own requirement for all international students, as the provider states it (for example "Bachelor's degree (or equivalent) in a relevant discipline"). `contact_provider` remains when the course states none |
| 3 | `entry.requirements_note` | A minimum grade without a numeric score (for example "GPA of 5.0 on a 7-point scale") was left out | It is included, in the provider's words |

## 2. `course_general`: how to show it

- `rows[]` have the same fields as `course_override` rows: `text`, `min_grade`, `min_score`, `min_score_basis`, `quote`, `as_at` and `case_by_case`.
- Show each row's `text` as the provider states it, with "Applies to all international applicants" and `as_at`.
- `outcome` is `minimum_published` when a row holds a grade or score, otherwise `case_by_case`. Show `case_by_case` rows with the existing case-by-case wording.
- `course_general` does **not** say the student's own qualification is equivalent or that the student is eligible. It is the course's general requirement; the provider decides equivalence. Keep the "check with the provider" link beside it.
- The order is unchanged for the first four steps. A country-specific answer (`course_override`, `course_country_row`, `band_ladder`, `provider_minimum`) always comes first. `course_general` comes only when none applies, and `contact_provider` only after it.
- Wording about course length, pathways or possible routes (for example "to complete the masters in 2 years", "may include Foundation Studies") is never used for `course_general`. It stays in `requirements_note`.

## 3. What to do

1. Add `course_general` to the values your page handles for `entry.resolution.rule`. A page that does not know the value should show `rows[].text` like `course_override`, never "no data".
2. Expect fewer `contact_provider` answers. On the measured sample (27 Nov 2026, India), about 8,760 courses answer `course_general`. These counts change as data is checked.
3. No full reload is needed: changed courses come again in the next `sync` deltas.
4. Run acceptance tests 20 and 28 (guide section 12) and send any failure with its `request_id`.

## 4. For the Zoho developer

`zoho-api-v2` course items carry the same `entry.requirements_note`:
- domestic-only requirements are no longer included;
- a minimum grade without a numeric score (for example "GPA of 5.0 on a 7-point scale") is now included.

No field is added, renamed or removed in the Zoho API. Map `requirements_note` as today. The next deltas carry the corrected text.
