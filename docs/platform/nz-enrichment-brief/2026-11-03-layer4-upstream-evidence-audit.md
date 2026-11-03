# Layer 4 upstream evidence audit (3 November 2026, 19:50 AEDT)

**Mandate:** `2026-11-03-layer4-upstream-evidence-claude-prompt.md`. **Decisions:** `2026-11-03-layer4-upstream-evidence-decisions-1922.md`. **Item detail:** `2026-11-03-layer4-university-review.csv`.

| Measure | Result |
|---|---|
| Items audited | 24, all still pending |
| Ready for a decision | 2 |
| Decisions submitted, saved or admitted | 0 |
| Firecrawl credits used by this audit | 0 |
| Live queue | 5,031 (Course link 3,320, AER 557, University description 385) |

Method: read-only live queries and stored copies opened through the existing `admin-evidence-access` route in the signed-in browser session. No migration, merge, deployment, queue change or decision.

## Audit verdict on the checkpoint
Counts hold: 24 unique refs, 9 providers, 0 submitted, 0 admitted. The stop for University description was justified by the playbook as written. Corrections:

| Checkpoint claim | Finding |
|---|---|
| Four fee holds have no linked stored copy | Incorrect. All four courses have a stored page read on 2 Nov. The fee card simply does not show it. |
| Seven of ten scholarships unreadable, plus 2, 1 and 1 | These add to 11. Live data shows 6 unreadable, 2 owner conflicts, 1 stale, 1 duplicate. |
| 385 university descriptions | 4 are university descriptions and 381 are course descriptions. |
| Macquarie duplicate not confirmed | Now confirmed on stored evidence. "331 linked courses" was not rechecked. |

## Missing information by kind
| Kind | Items | Real gap | Layer |
|---|---|---|---|
| Course link | 10 | Stored copies exist but are not linked to the item; no page held; no honest way to refuse a bad proposal | Layer 2 and Layer 4 |
| Fee | 4 | 2 pages are not this course; 1 unit error; 1 audience unclear | Layer 2 and Layer 3 |
| Scholarship | 10 | 6 never read; 2 wrong holder; 1 stale round; 1 duplicate with no UI route | Layer 2 and Layer 4 |

## Common causes
1. **Stored copies not linked to course-link items.** 2,358 pending course-link items have no evidence link; 2,032 (86%) have a stored copy of the proposed address. One fix in the item build or inbox read would show evidence on most of them, at no read cost.
2. **"Keep the page we hold" has nothing to keep.** 2,193 pending course-link items have no held page and no evidence link, so refusing a bad proposal means choosing a false statement. The route needs an honest refuse choice.
3. **AI fee reader misreads credit points (new defect).** It divides by 8 units a year, so 24 credit points is treated as 3 years. Murdoch 096011C holds 12,600 where the page says 37,800 for the 1-year course, and scholarship savings are derived from that figure. 15 rows use this calculation with more than 8 points. Murdoch is confirmed; 6 UNSW rows look wrong and need checking; the others may be right, because some are real unit counts. All 15 courses show `publication_status` unpublished; whether the consumer API exposes them was not tested.
4. **The AI fee reader ignores fee holds (new defect).** Exactly 2 courses have an active provider fee while their hold is raised: Murdoch and Western Sydney. Each value was admitted about 2 minutes after the hold. The guard stops adapter fees only.
5. **Listing pages held under the wrong provider.** State-government listing pages (21 pending items across 5 provider records) sit under holders such as Lexis TESOL and Prime Education, while titles name ACU, MACC, RMIT UP and Alphacrucis. Reading them first would spend credits on an ownership problem.
6. **No duplicate choice for held scholarships.** Publish, Not for international students and Not a scholarship are all wrong for Macquarie ref 1184.
7. **Staging addresses.** Macquarie's held record and 7 published records use a `/staging/` address. Official-page replacement should be checked.

## Item notes
- **Macquarie 1184:** duplicate of published `a347e086`. Same title and provider, up to AUD 10,000, international. Official page: one-off, open year round. The inactive Study Australia record says "annually"; the official page does not.
- **Bond 1230:** the stored quote is January 2026 only, and applications closed 26 Nov 2025. The 19 Oct re-check said the page names international students, but the stored quote does not. Current availability is unknown.
- **Western Sydney 6496144:** course identity matches (121432C, 2 years), but $37,141 sits beside a Commonwealth Supported Places label. Leave pending.

## Ready for named approval
| Ref | Course | Choice | Why |
|---|---|---|---|
| 6526827 | Swinburne 088407E, Bachelor of ICT (Professional) | Keep the CRICOS total | Stored page states CRICOS 095881J, a separate active course record |
| 6526834 | Swinburne 092696A, Graduate Diploma of Project Management | Keep the CRICOS total | Stored page is the Swinburne Online, online-only version, with no CRICOS code shown |

Neither shows the registered total is current; each only keeps the page fee out.

## Firecrawl need
Only a few reads are justified now: VU 1323 and Bond 1230. Six others wait for owner checks. No platform-governed single-item read route was confirmed for scholarships; the existing path includes an AI read, which is still not approved here.

## Owners and resume point
| Item | Owner |
|---|---|
| Causes 1 to 4 and 6 (code changes) | Active integrator; another session deployed v2.15.434 to 436 during this audit |
| Ownership housekeeping and consumer exposure check | Active integrator |
| The two ready items | Platform Admin approval, then Claude submits |

**Resume:** submit 6526827 first, verify it leaves waiting and the page fee stays out, then 6526834. Other kinds resume provider by provider after causes 1 and 2 are fixed. The programme is not complete.
