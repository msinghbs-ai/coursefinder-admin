# Lane 2 item 3: human and rule queues, NZ and CA course-campus geography (audit, 22 Nov 2026)

**Lane:** 2 (`S2-Data-Destination-Continuous`) · **Asked:** Platform Admin, 22 Nov 2026 00:11 AEDT ("settle any deterministic or rule-resolvable items … at $0") · **Method:** read-only, rolled-back live probes, 22 Nov 2026 00:30 to 00:50 AEDT. Nothing was changed.

## Findings

| Queue | Live count | Rule-resolvable at $0? | Why |
|---|---|---|---|
| Providers with campuses but no primary campus (RM1E) | 82 (AU 80, NZ 2) | No | Every one has two or more active campuses; none has a single campus. These are the ties the 20 Nov rule (register head office, then most active courses) left for a person. |
| Postcodes needing Layer 4 review | 160 postcodes (169 locality rows) | No | Each postcode splits across localities below `destination.postcode_primary_min_share` (0.9); choosing one is a person's decision (`admin_destination_postcode_resolve`). |
| Campuses waiting for a locality | 69 | No | They wait on the postcode reviews above. |
| Central English readings waiting for a person | 5 (last recorded 21 Nov 13:20) | No | A person approves them in Universities › English. |
| NZ active courses with a campus (RM4B, REQ-39, REQ-81) | 2,692 of 6,514 (the brief's 3,999 is out of date) | No | Every NZ course without a campus already carries a reason: 3,507 not published by the provider, 268 online only, 35 pending extraction, 7 source unavailable. Only 5 have no reason. |
| CA active courses with a campus (RM2A) | 2,290 of 3,825 | No | Same pattern: 1,368 not published by the provider, 119 online only, 37 pending extraction. Only 11 have no reason. |

The NZQA and DLI registers list providers and their delivery sites, not which course runs at which site. They cannot link a course to a campus, so no source-backed course-campus rule is available from them.

## Sweep progress (NZ and CA)

| Sweep | Last 24 hours | Totals on NZ and CA courses |
|---|---|---|
| `fid-det-v1.0` (fees, intakes, deadlines) | 286 runs; 1,061 readings; pass 5 | Intakes: 248 admitted, 1,584 held (NZ 914, CA 670), 58 incomplete. Deadlines: 3 admitted, 34 rolling. Fees: 15 admitted (NZ). 56 ambiguous. |
| `struct-det-v1.0` (duration, study load, delivery mode) | 3 calls; 8 outcomes | Duration: 547 admitted, 368 already held, 86 Layer 4 conflicts. Study load: 19 admitted. Delivery mode: 2 admitted. The sweep has read the pages it holds; more needs new page reads (Firecrawl). |

## What would move these

- **A person:** the 82 primary-campus ties (Providers › Flag primary campus), the 160 postcodes (Destination data), and the 5 English readings.
- **A Platform Admin decision:** NZ and CA course-campus links need either a per-course provider source (a rendered read, Firecrawl cost) or acceptance of the "not published by the provider" reasons as final.
