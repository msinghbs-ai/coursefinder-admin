# CF-CHG-20260905-196 — Scholarship Catalogue Coverage Wave 2: UNSW, UQ & UWA

**Status:** IMPLEMENTED / RUNTIME PASS — CONTROLLED DETAIL FANOUT NEXT  
**Milestone:** M2.4.5  
**Layer:** Layer 2 — Scholarship acquisition

## Change

Expanded qualified first-party AU international Scholarship catalogue coverage to three high-course-volume universities that had canonical Scholarship roots but no executable catalogue route:

- UNSW Sydney — `https://www.unsw.edu.au/study/your-future/international-scholarships`
- The University of Queensland — `https://scholarships.uq.edu.au/scholarships?type%5B160%5D=160`
- The University of Western Australia — `https://www.uwa.edu.au/study/scholarships-and-fees/scholarships/international-scholarships`

Each source is registered as first-party/international, weekly freshness, hash-gated, Evidence-required and shared-fetch reusable. Routes retain the governed order direct HTTP → Parse.bot → Firecrawl → ZenRows where enabled.

## Runtime proof

University-scoped preview returned one executable provider and zero route gap for each provider. Three scoped acquisition jobs were dispatched and all succeeded through `direct-http` with HTTP 200 Evidence captured:

- UNSW Evidence `78e56d38-c11d-497b-aa51-c11743dcd49c`
- UQ Evidence `db43eff0-3d88-4d8e-8341-8f6ecc6785d7`
- UWA Evidence `bd19c745-c784-498e-8f04-62514e1358ac`

No canonical mutation or Publication occurred.

## Governance boundary

Catalogue Evidence is enumeration input only. Individual Scholarship detail records must still pass the CF-184/186/190–194 individual-first-party/international semantic gates before canonical-unpublished reconciliation. Broad Publication remains prohibited.
