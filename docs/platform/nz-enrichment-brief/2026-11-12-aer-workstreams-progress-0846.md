# AER workstreams A and B: progress, 12 Nov 2026 08:46 AEDT

Mandate: Platform Admin 11 Nov 2026 (grid reader decisions 1 and 2, parallel workstreams A and B, acceptance measured by production admission outcomes); "Proceed" 11 Nov 2026 23:32; 12 Nov 2026 08:46: "Follow the guidelines and operation model, if CI is green merge the PR, if this mandate needs updating reflect at relevant admin docs" (Agent operating model v1.14, rule 9 restated).

## Workstream A: the waiting country tables

| Step | Result |
|---|---|
| Pilot #1048 (F-AER.09) | Merged 12 Nov 2026 on green CI (11 checks); Deploy on merge, frontend build and deployed UAT green |
| `security.har_aer_recheck_v1` | Live md5 528244db64872b3b01e60d35bd8dde30, equal to the rolled-back dry run; an empty-read request also clears once the provider's own country table is live |
| Re-read of UWA, Federation, Adelaide, Charles Darwin | 4 runs queued 21:46 UTC with the current reader (sources 74306034, 58c60102, 18e64f94, 01139439); each goes to Layer 4 or rule D1 |
| UTas | Approvable: approve 5284a753 and reject the duplicate 73615b9a (person action) |
| UTS, CSU, Curtin, Wollongong, VU | Need reader fixes (not re-reads): heading-prefixed quotes, AQF rows with no country, paraphrased rows, band not in quote, GCE O Level |
| Monash, Adelaide host, Curtin host, VU duplicate provider | Open: source and host fixes |

## Workstream B: course-by-qualification grids (UNSW, Sydney, UQ, Auckland)

Branch `cf247-f-aer-08-pdf-grid` (not yet a PR): step 1 aligned grid proof, step 2 grid cells to requirement rows (5,734 minimums from UNSW, Sydney and UQ fixtures, none dropped by the parser), Auckland fixtures.

Step 3, course links (decision 2), measured on the fixtures against the live catalogue:

| University | By CRICOS code | By exact title, provider and level (unique) | Ambiguous (two catalogue courses) | No exact match |
|---|---:|---:|---:|---:|
| Sydney | 89 of 89 | – | 0 | 0 |
| UNSW | (no code printed) | 44 | 4 | 17 |
| UQ | (no code printed) | 46 | 1 | 7 |

Ambiguous and unmatched labels are never guessed: they get AI candidates and go to a person in Layer 4. Rows not linked to a course are flagged by the D-R3 gate and cannot be admitted. A per-course qualification row (IB or GCE A Level for one course) needs a course on `catalogue.provider_qualification_requirements` (new columns, additive; no consumer API reads this table), so a course minimum is never admitted as a provider-wide one.

Not complete: acceptance is the recovery of about 6,000 held minimums with production admission outcomes, not reader execution or merged PRs.
