# D5 — AER-ROLE-GUIDES.md update text for the integrator

Target: admin `docs/platform/AER-ROLE-GUIDES.md`. Plain language; apply once the consumer paste and the workspace change are both live (until the consumer paste is applied, the workspace refuses "Not stated on the page", and the 5.2 exclusion rule as written today still holds).

## §1.4 Scale, basis and completeness — replace the Scale bullet

- **Scale** (`percentage`, `points`, `aggregate`, `gpa`, `letter`, `rank`, `none`, or **Not stated on the page**). A numeric value always needs a real scale (W7). `none` means the row states no minimum on a scale (case by case). **Not stated on the page** means the source prints a grade (for example "minimum 75") but does not say on what scale: the grade is kept exactly as printed, with no numeric value and no scale. The website receives it as `scale_stated: false` and shows "Published requirement: [grade]. The provider does not state a grading scale on this page; check the source or contact the provider." (decision A4).

## §3.1 Correct an active or quarantined row — add after the existing steps

**A printed grade with no stated scale.** If the source prints a grade but no grading scale, set **Scale** to *Not stated on the page* and clear **Value**. Keep **Minimum** exactly as printed (it must still be in the quote). Give the reason, for example "no grading scale stated on the page". Never choose a scale the page does not print, and never put the grade in Value.

## §3.5 Case by case or contact the provider? — rename and add a third case

**Heading:** *Case by case, no stated scale, or contact the provider?*

Add after the first paragraph:

When a source prints a **grade without its grading scale** ("minimum 75", with no "%", "points", "GPA" or similar on the page), record the qualification with the grade as printed, Scale *Not stated on the page* and no numeric value. This is a published requirement, not case by case: the resolver answers "minimum published" and the website shows the no-scale wording.

## §5.2 Checks before approving — replace the A4 block

**A printed grade with no stated scale (decision A4, Platform Admin 30 Oct 2026; D5):**
- The source prints a grade or number (for example "minimum 75") but states no grading scale on the page.
- **Do not** approve a row that the reader has given an inferred scale (percentage, points, GPA, ATAR equivalent or band). Exclude it with **Approve except**, with the reason "no grading scale stated on the page".
- Then a Curator records it correctly in the workspace (3.1 or 3.3): the grade as printed, Scale *Not stated on the page*, no numeric value, with the same reason. It reaches the website as `scale_stated: false` with the approved wording: *"Published requirement: [grade]. The provider does not state a grading scale on this page; check the source or contact the provider."*
- Keep it distinct from **case by case** (no minimum stated; scale `none`) and from **no published requirement** (nothing recorded; contact the provider).
- Rows already quarantined for "bare numbers with no printed scale" are not changed automatically. A Curator checks each against its source before correcting and restoring it.

## §6.1 What reaches the consumer — add a bullet

- Each `entry_matrix` row and each resolution row carries `scale_stated`: `true` (a stated scale), `false` (a grade printed without its scale; `scale` is `null`), `null` (case by case, and every row from a course's own page). It is read from the row as admitted; nothing is inferred.

## §6.2 Rendering rules (owned by the website team) — add a bullet

- A row with `scale_stated` `false`: show "Published requirement: [grade]. The provider does not state a grading scale on this page; check the source or contact the provider." Never add a percentage, ATAR equivalent or band, and never treat it as case by case (developer guide §7.9).

## §6.3 Zoho — unchanged

(`zoho-api-v2` is unchanged and carries no entry requirements.)

## §8 Quick reference — add a row to the scale/outcome table (if present)

| Grade printed, no scale | Scale *Not stated on the page*; no value | `scale_stated: false`; outcome minimum published |

## History — new row

| DD Month 2026 | D5 (decision A4, admin §11.2): "Not stated on the page" scale; 1.4, 3.1, 3.5, 5.2, 6.1, 6.2 |
