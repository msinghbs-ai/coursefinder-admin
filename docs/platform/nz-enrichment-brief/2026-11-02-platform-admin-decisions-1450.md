# Platform Admin decisions, 2 Nov 2026 ~14:50 AEDT (recorded verbatim from the in-session question answers)

| # | Question (as asked) | Answer (verbatim) |
|---|---|---|
| 1 | E16 group (a), 12 wrong course links: contain the part-B way plus mark each page binding `page_refused` (no URL retraction, no course-url-fill pause, a binding state not used before)? | "Yes, include page_refused (Recommended)" |
| 2 | Griffith 0101621 (parent master's fee 47,000 a year vs CRICOS 21,047 for half a year): quarantine this one fee (unverified, per-course exclusion, one Layer 4 fee item)? | "Quarantine it (Recommended)" |
| 3 | Intake fill job (v2.15.405, off): which rule fills exact start dates from the approved university calendar? | "Named period only (Recommended)" — fill only where the page names the period (e.g. "Semester 1"). |
| 4 | University descriptions: approve the new Layer 4 review type `provider_description` and the 5-university pilot ceiling (US$1 AI, 20 page reads ≈ 34 Firecrawl credits)? | "Approve type and pilot" |

Also recorded: production writes through the database tool need the Platform Admin present to approve each prompt (12:56 attempt auto-cancelled; 14:46 H11 event #28614 and H24 event #28615 applied with approval).

## Consequences
- 1 → run `ui-audit/e16plan3/contain-links-A.sql` then `layer4-A.sql` in :x6–:x8 windows.
- 2 → run `ui-audit/e16plan3/f3-quarantine.sql` (Part U for the 2 unclear fees stays commented out).
- 3 → the fill job's date rule is changed to named-period-only before it is switched on; month-only rows keep month only; years only where printed.
- 4 → release the provider description reader (migration renamed to sort after 20261102080000), then the pilot: `pdesc.provider_keys` = the five keys, `pdesc.ai_usd_max` = 1, `pdesc.firecrawl_reads_max` = 20, acquisition switches and `pdesc.enabled` = 1, job activated — each a separate recorded step.

# AER decisions, 2 Nov 2026 ~15:25 AEDT (in-session answers, verbatim)

| # | Question (as asked) | Answer (verbatim) |
|---|---|---|
| D-A1 | Replace the 28 Oct ~40-provider AER limit with the 1,476-provider scope (AU 1,279, NZ 197), for inventory and source discovery only (no paid reads, no admission)? | "Yes, inventory and discovery (Recommended)" |
| D-A2 | Bounded RMIT re-read of its 7 held sources (IB, GAC, UK, Nigeria, Vietnam, Norway, Foundation) from copies already stored, no new page reads, once the reader fixes are released? | "Yes, stored copies only (Recommended)" |
| D-A3 | Lift the 30 Oct AER ingestion hold for re-reading stored copies only, under a daily AI ceiling? | "Lift for stored copies, US$2/day" |
| D-A5 | Approve new additive tables for qualification identity and provider recognition (no synthetic GLOBAL country)? | "Approve the tables (Recommended)" |

Still open: D-A4 (record the E11/E12 cost ceilings), D-A6 (G3 approval for any consumer qualification filter or new response field), D-A7 (Monday 08:00 report destination).
Every recovered minimum still goes through Layer 4; no automatic admission; the D-A3 ceiling sits inside the US$14/day platform total enforced since v2.15.404.
