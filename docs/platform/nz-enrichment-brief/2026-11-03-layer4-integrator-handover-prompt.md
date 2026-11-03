# Handover prompt — Layer 4 defects for the active Integration Controller

Paste into the session that owns StudySearch merges and deployments. Australian English.

You are the active Integration Controller. A separate Claude session audited 24 Layer 4 items and did not touch Pilot. Read:
- `docs/platform/nz-enrichment-brief/2026-11-03-layer4-upstream-evidence-audit.md`
- `docs/platform/nz-enrichment-brief/2026-11-03-layer4-upstream-evidence-decisions-1922.md`
- `docs/platform/nz-enrichment-brief/2026-11-03-layer4-university-review.csv`

Verify each finding yourself before changing anything. Reuse existing issue fingerprints and the execution register. Record the mandate before code. Follow normal release gates. Do not merge in parallel with other work.

**Standing rule from the Platform Admin:** every Layer 4 decision is recorded in that CSV with its required fields, and parallel development is expected. Pull before writing to it, and add rows rather than overwrite them.

## Priority 1: wrong and bypassed fees
1. **AI fee reader unit defect.** `fee_country_profiles` AU is 8 units a year and its note says 48 credit points, but the reader divides credit points by 8. Murdoch 096011C row `52bc162c` holds 12,600; the page says 37,800 for the 1-year course. Fix it for all countries: distinguish units from credit points, and use the page's stated load where it gives one.
2. **Review the 15 rows** with "a full-time year is 8" and more than 8 points. Murdoch is confirmed. Check the 6 UNSW rows. The others may be right because some are real unit counts.
3. **Holds bypassed.** Murdoch and Western Sydney 121432C (`0e01cb0c`) got active AI fee rows about 2 minutes after a `fee_crosscheck` hold. `fee_crosscheck_guard_v1` covers adapter fees only. Make the AI fee reader respect raised holds and active fee exclusions.
4. **Watch 088407E and 092696A.** Holds were released at 19:36 and both are requeued to the next Enrich fields task. Neither page fee (44,300, 50,360) may be admitted.
5. **Consumer exposure.** All 15 courses show unpublished, but this was not tested against the Website and Zoho APIs. If wrong values are visible, treat it as P0. Scholarship `saving_per_year` for Murdoch is derived from the wrong fee.

Correct wrong active values only by a governed route, with Platform Admin approval where rules require it.

## Priority 2: Layer 4 can show evidence and record an honest result
6. **Link stored copies.** 2,358 pending `official_course_url` items have no `evidence_id`; 2,032 have a stored copy of the proposed address. Fee cards also say no stored copy is linked, even when the course page is stored. Fix it once.
7. **Honest refuse choice.** 2,193 items have no held page and no evidence link, so "Keep the page we hold" is false for them. Add a refuse-this-proposal outcome that does not imply a held page.
8. **Duplicate close route** for held scholarships. Macquarie ref 1184 duplicates published `a347e086`.

These change the Layer 4 UI or functions. They need no consumer API change.

## Priority 2a: course link growth (Platform Admin decisions, 3 Nov 20:29)
Read `2026-11-03-layer4-course-link-growth-review.md`.
- **Refused pages with no held page:** stop raising a per-proposal item. Keep the refusal in `pipeline.page_rejections`. Put the course on one "Course page needed" list grouped by university (Decision 179), with add the page, search again and no page exists. Convert the 2,252 existing items, keeping history. This replaces item 7 for those items. Nothing is admitted by this change.
- **Held page in dispute:** these items stay in Layer 4.
- **Wording:** the CRICOS-differs reason must not mention CRICOS for non-Australian providers.
- **Measure:** report Firecrawl credit use by the search lanes that feed refusals.

- **Approved address rules (366 items):** run as logged rules under Decision 263, one university at a time. Before each run, validate the whole group: same course, stored copy matches, audience correct. Items that fail stay in Layer 4. Adelaide 207: keep the held `adelaide.edu.au` page and stop raising the `adelaideuni.edu.au` pattern. Canberra 100: use the no-year address. Simon Fraser 59: use the no-term address. Exact patterns and findings are in the review file. Re-reads must store evidence as normal. Do not change manual bindings. Record each rule run in the review CSV, adding rows.

## Priority 3: sources and ownership
9. **Approved reads.** VU ref 1323 and Bond ref 1230: Firecrawl and the AI read are approved for these two items only. Run them through the scholarship path, with evidence stored as normal. Bond's queue entry holds a stored path, so it will reuse the old copy unless a fresh read is forced. If no safe governed route exists, add a single-item read control rather than hand-writing rows.
10. **Ownership.** 21 pending held scholarships come from state-government listing pages across 5 provider records. Several names point to other institutions (ACU, MACC, RMIT UP, Alphacrucis). Reconcile through governed housekeeping, with no silent reassignment. Check owners before spending credits.
11. **Staging addresses.** Held 1184 and 7 published Macquarie records use `/staging/`. Check whether official addresses should replace them.
12. **Shared binding.** 088407E and 095881J are both active with the same title and page. The page states 095881J.

## Report back
For each fix, give the issue ID, release, production verification and affected Layer 4 refs. Report submitted, saved, admitted, exceptions and new arrivals separately. Do not close the programme from a deployment or a queue reduction.
