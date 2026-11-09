# Consumer handover pack, current as at v2.15.382 / v2.15.383 (31 Oct 2026)

**What the Platform Admin sends.** Nothing here has been confirmed as received or implemented by the website or Zoho developers. Their confirmation is recorded in `../WEBSITE-DEVELOPER-REQUIREMENTS.md` when it arrives.

| # | Item | For | Type | Files | What the developer must validate |
|---|---|---|---|---|---|
| 1 | Website API v2 developer guide, **issue 7** | Website | API change (additive) | `../developer-pack/StudySearch-Website-API-v2-Developer-Guide.{md,docx,pdf}`, OpenAPI and Postman beside it | Acceptance tests 1 to 24. New in issue 7: test 24 (`entry.min_scores[]`) |
| 2 | Several entry scores, `entry.min_scores[]` | Website (Zoho for information) | API change (additive) | `2026-10-31-D4-entry-min-scores-HANDOVER.md` | Course `0101331` returns 6 items, international first. Show `quote` per line. Existing `min_score` use is unaffected. A client that ignores unknown keys still works |
| 3 | Official course links corrected | Website and Zoho | **Data correction, no API change** | `2026-10-31-SS-007-official-link-corrections-HANDOVER.md` and the manifest `../../platform/ui-audit/2026-10-31-ss007-batch-a-official-links.csv` (177 courses; 167 had a link) | After a `changed_since` sync, the listed courses show no official link. Stored copies of the old links are cleared. `has_official_url=true` no longer returns them |
| 4 | Page size | Website | Recommendation | `../WEBSITE-DEVELOPER-REQUIREMENTS.md` O12 | Optional: request 20 results per page where 20 or fewer are shown; 50 stays supported |
| 5 | Faster course results (v2.15.381) | Website and Zoho | Internal; no API or data change | none | Nothing to change. Responses are byte-identical |
| 6 | Zoho API v2 developer guide | Zoho | No change this round | `../zoho-pack/StudySearch-Zoho-API-v2-Developer-Guide.*` (issue 4, 19 Oct 2026) | `zoho_v2_course` also returns `entry` (since 28 Oct) including `min_scores` (31 Oct). This is additive and not yet described in the Zoho guide; describe it in the next Zoho issue if Zoho uses it |

**Consistency checks (31 Oct 2026 15:10, live):**
- The guide example for `0100714` and the acceptance test 24 counts match live responses.
- The manifest matches the 177 open remediation holds.
- Consumer API drift: none.
