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
| Firecrawl spend | $0 | | |
| Unapproved AI spend | $0 | | |

## 4. Approvals needed (exceptions only)

Only rows held for `HELD:BUDGET_GATE` or `HELD:G3_FREEZE` appear here. If the list is empty, no decision is needed today.

| Provider | Lane | Reason code | What is needed | Cost or impact |
|---|---|---|---|---|
| None | | | | |

## 5. Notes

Stale claims released in the last 24 hours, lanes parked, and anything the Platform Admin should know in one line each.
