# StudySearch — ChatGPT Work Layer 4 settlement checkpoint
Date: 1 November 2026 (AEDT)
Batch: L4B-20261101-1020
Status: MANDATORY SAFETY STOP; incomplete pass, no claim of clearance.

## Authority
Read AGENT-OPERATING-MODEL.md, nz-enrichment-brief/INDEX.md, docs/platform/skills/cf-layer4-kbe/SKILL.md and references/action-playbook.md v5 from admin main. User explicitly authorised individual UI decisions, linked verification and automatic continuation. Platform Admin authenticated; live UI v2.15.388. No engineering, SQL, mass approval, AI re-check, Firecrawl, paid read or new source acquisition performed.

## Reconciliation and method
Initial refresh: 1,873 pending, 661 universities, 367 older than seven days; unchanged from earlier baseline. Used By kind; items visibly ordered oldest first. Reasons carry batch id. Each final decision was submitted separately and verified by exact read reference disappearing and the UI Done outcome. Decided view was not used.
Six AER items examined in detail; additional scholarship/course-link screening is not included in that count. Four decisions saved. Two detailed AER reviews left pending. This was not a full pass of all 17 kinds.

## Verified saved decisions
| Provider/source | Read | Evidence | Choice | Destination outcome |
|---|---|---|---|---|
| RMIT Singapore | b4aecc1c | e18a5928-e1b5-4bb3-9bed-2a0e50b5d9f4; ee46bc863b36 | Approve all rows | All 9 rows verified Active in Provider entry matrix |
| RMIT Thailand | 494bcd84 | decacc60-5826-4e0f-ade6-408514eb347e; c48c73f01148 | Approve all rows | All 13 rows verified Active in Provider entry matrix |
| RMIT Sri Lanka | 10995ef9 | fe92ce32-82b1-4e9c-8a5a-59c8c1a8da80; bd95d59dbf01 | Approve all rows | Saved and exact read left queue; 13 rows approved, destination verification unfinished when browser connection timed out |
| ANU Austrian Maturity Certificate | 06cb4705 | 833bd1c9-deb7-4937-8f2f-49660f5f9a9a; 13d0a32e9f07 | Reject the read | Done: no row admitted, waiting row withdrawn; exact read left queue |

Stored HTML copies were opened and inspected through Evidence → View page. Exact source URL searches returned one matching saved copy for each of the four decided reads. ANU currency lookup timed out once (ref QCVBHW), then succeeded on the sole retry.

RMIT Singapore: nine quoted rows match table, qualifications, levels, points and printed calculation scale. Thailand: thirteen rows match Matayom 5/6, explicit four-point CGPA scale and printed Australian percentage bands. Sri Lanka: thirteen rows match O/A Levels, printed points/letter scales and bands. No inferred bands or source values admitted.

Confirmed applied/admitted: 22 rows. Further approved rows pending destination verification: 13. Do not count those 13 as verified admissions until inspected. Excluded rows in three approvals: 0. Exact superseded and retained counts were not exposed/verified; do not invent them.
Reconciled without admission: 1 item (ANU Austrian read).
Deferred UI decisions: 0. Downstream reads/rebuilds/retries initiated: 0.

## Mandatory stop
Controller SKILL.md, Stop conditions: “a shared evidence/decision defect”.
Repeated ANU rank/score inversion confirmed against two stored tables:
- Austria 06cb4705: proposed minimum 70 points, band 3.3; printed columns are entrance rank 70 → indicative qualification score 3.3. Stored table contains eleven data rows but proposed read only one; materially incomplete. Rejected and verified.
- Bulgaria f6f9441d, evidence hash 6643fab04f49: proposed minimum “Program Required Entrance Rank: 97”, scale rank, band 5.8. Stored official table has entrance rank 97 → indicative score 5.8; same reversed interpretation. Left pending once repetition established.
Other ANU queue cards show similar patterns but were not individually adjudicated.
No further review writes after confirming the shared defect. This is an evidence-interpretation safety boundary, not a pause for unrelated Claude engineering.

Browser connection then stopped returning the final destination verification read, ultimately reporting MCP request timed out. The timed-out action was a search-field fill in the destination matrix, not a decision submission. No uncertain duplicate submission exists.

## Exceptions, owners and next action
| Reference/class | Owner | Next action |
|---|---|---|
| ANU f6f9441d and related rank/score reads | Claude/platform engineering; Platform Admin for compatibility acceptance | Investigate rank/band interpretation and completeness, establish affected scope and verify compatibility before resuming review writes. No autonomous reader repair/re-read authorised here. |
| RMIT Sri Lanka 10995ef9 | Layer 4 Controller | Verify 13 destination rows Active after browser recovery; never re-submit saved approval. |
| Adelaide f5a342af, evidence 4d15ff28-5bb9-4205-a6b7-60239ac7f91f | Evidence viewer/platform owner | Stored application/pdf (67.3 KB) metadata accessible, but View page produced no inspectable saved-page viewer; leave pending until stored PDF is inspectable. No source fetch performed. |
| Old course-link cards e.g. WI0858, WI0911 | Layer 4 UI/platform owner | Expose or locate held/proposed URLs and supporting stored evidence; cards supplied choices and reasons but no URLs/evidence. No blind Keep/Use decision. |
| Old scholarship cards | Layer 4 owner | Retain items with absent quotes, identity conflicts or possible duplicates. Examples: Prime Education Group attached RMIT UP and Alphacrucis named awards; cannot infer correct ownership. No publication/refusal performed. |
| Remaining unpassed kinds | Layer 4 Controller | Resume complete oldest-eligible pass after safety boundary cleared, from current live state. |

## Last verified pending counts
These are the last successful live UI counts after decision 4, NOT a final refreshed census: final refresh could not be completed after browser timeout.
| Kind | Pending |
|---|---:|
| course_link | 118 |
| held_scholarship | 137 |
| fee_check | 0 |
| not_offered | 0 |
| not_on_site | 0 |
| website_needed | 41 |
| pages_not_found | 54 |
| too_few_pages | 131 |
| nothing_ready | 315 |
| central_to_approve | 3 |
| onboarding_failed | 1 |
| site_down | 0 |
| provider_departure | 16 |
| no_page_first_run | 55 |
| conjoint_first_run | 5 |
| counsellor_report | 0 |
| aer_review | 993 |
| Total | 1,869 |

Five zero kinds were absent from the live pills; the twelve displayed kind counts sum to the live total. Website needed temporarily rose 41→42 and returned to 41 during concurrent activity; no attribution to this batch. AER fell 997→993 in line with four verified decisions.

Checkpoint is this dated repo record and the current chat. Browser-write capability was proven by saved UI outcomes. Settlement remains incomplete. Resume does not need another general GO, but requires shared-defect compatibility resolution and browser recovery.
