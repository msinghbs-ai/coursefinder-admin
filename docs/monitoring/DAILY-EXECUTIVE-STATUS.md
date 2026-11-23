# Daily Executive Status

**Owner:** `S1-Build`. **Updated:** 08:00 AEDT each day. **Design:** `docs/platform/2026-11-23-file-driven-continuous-delivery-design.md`.
**Sources:** `docs/monitoring/PROVIDER-ENRICHMENT-QUEUE.csv`, `docs/monitoring/AER_University_Reader_Status.csv`, the live health and coverage reads.

**Report date:** DD Mmm YYYY 08:00 AEDT. **Status:** Not yet reported (template).

## 1. Queue burndown by lane

Counts are rows in the queue file (1,886 providers). Velocity is the change in `DONE` over the last 24 hours.

| Lane | Domain | DONE | CLAIMED | PENDING | HELD | PARKED | 24h velocity (rows) |
|---|---|---|---|---|---|---|---|
| `S2-RM-Design` | AER | | | | | | |
| `S2-CF` | URLs and descriptions | | | | | | |
| `S2-INT` | Intakes and deadlines | | | | | | |
| `S2-Build` | Scholarships | | | | | | |
| `S2-GEO` | Campus locality | | | | | | |
| ELR owner | English requirements | | | | | 1,886 | n/a |

## 2. Live coverage

Active courses: 36,046 (denominator).

| Field | Courses covered | Coverage (%) | Change in 24h (percentage points) |
|---|---|---|---|
| Academic entry (AER) | | | |
| English requirements (ELR) | | | |
| Official course URLs | | | |
| Course descriptions | | | |
| Exact intake dates | | | |
| Scholarships | | | |
| Campus locality (geo) | | | |

## 3. Guardrails

| Guardrail | Target | Today | OK? |
|---|---|---|---|
| G3 frozen API (functions and relations) | 75 and 48, no drift | | |
| Manual locks | 7,585 | | |
| Active cron jobs | 140 or fewer | | |
| Platform spend (Firecrawl and AI, micro-budget) | US$5.00 a day or less (charter 23 Nov 2026) | | |

### Spend log (micro-budget, US$5.00 a day)

Each paid call by a lane is one line: time (AEDT), lane, provider or course, service (Firecrawl or AI), US$ amount, and the running total for the day.

| Time (AEDT) | Lane | Target | Service | US$ | Day total |
|---|---|---|---|---|---|
| None | | | | | |

## 4. Approvals needed (exceptions only)

Only exceptions appear here (charter 23 Nov 2026): `HELD:BUDGET_GATE` (above US$5.00 a day, or paid Tier 2 or Tier 3 crawling), `HELD:G3_FREEZE`, and any change that would touch the 7,585 manual locks, take active cron jobs above 140, or withdraw live admitted records in bulk without replacements. If the list is empty, no decision is needed today.

| Provider | Lane | Reason code | What is needed | Cost or impact |
|---|---|---|---|---|
| None | | | | |

## 4a. Technical Blockers & Ready-to-Solve S1 Queue

One entry per `HELD` provider (except `HELD:BUDGET_GATE` and `HELD:G3_FREEZE`, which are in section 4), so the solver lane can start without asking.

| Provider | Spec | Code | Solver | Source | Exact error | Proposed fix |
|---|---|---|---|---|---|---|
| University of Auckland (`e096aba7-e1eb-4903-9a63-2bfb71e9a8b8`) | s993 → s996 | `HELD:PARSER_EDGE_CASE` | `S1-RM-Design` (Opus) | Stored: `layer2/NZ/entry-matrix/e096aba7-e1eb-4903-9a63-2bfb71e9a8b8/7cd70eba-dbf9-424f-b1d7-6024fc0266c4/7fda9075….pdf.gz` (A–I) and `…/ffb992a7-f91a-433d-b038-28130055e26d/308a1c39….pdf.gz` (J–Z); read direct, HTTP 200, 28 Oct 2026 | `held_unparsed: PDF page 2: "No direct entry for secondary qualifications. Applicants wil" crosses a column edge` (and `"for secondary qualifications" crosses a column edge`). Thrown by `gridRows` in Pilot `supabase/functions/coverage-sweep/pdf.ts` line 143; entry-matrix runs failed, 0 rows | Add a horizontally merged cell to `gridRows`: when an item crosses a column edge and no vertical rule runs at that edge inside the item's row band, place it in one cell spanning those columns (a note, never a minimum); still fail closed when a vertical rule is there. Re-run the two stored PDFs ($0) and admit through the strict-proof verifier |
| UNSW Sydney (`22657140-1cb0-4fa7-91df-90518ea8b35b`) | s993 | `HELD:IDENTITY_UNRESOLVED` | `S1-Build` (duplicates with S2-CF, IR-027) | `layer2/AU/entry-matrix/22657140-…` (2027 international UG entry table PDF) | 622 table rows (21 labels) excluded by a Layer 4 reviewer; relink found 0 one-to-one courses; 4 labels match 2 active unpublished courses each | Resolve the 4 duplicate course pairs (IR-027), then re-run the relink as Layer 4 cards; the other 17 labels need the printed course mapped by a person |
| The University of Queensland (`e55396d2-869a-46ef-9d17-841c7eab1313`) | s993 | `HELD:IDENTITY_UNRESOLVED` | `S1-Build` (duplicate with S2-CF, IR-027) | `layer2/AU/entry-matrix/e55396d…` (International minimum entry score guide PDF) | 113 table rows (5 labels) excluded by a Layer 4 reviewer; Bachelor of Pharmacy (Honours) matches 2 active unpublished courses | Resolve the duplicate (IR-027), then relink as Layer 4 cards |

## 5. Notes

Stale claims released in the last 24 hours, lanes parked, and anything the Platform Admin should know in one line each.
