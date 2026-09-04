# CF-CHG-20260904-113 — Federation & RMIT Scholarship Detail Evidence

**Status:** IMPLEMENTED / TARGETED PASS
**Milestone:** M2.4.5
**Area:** Layer 2 / Scholarships

## Purpose
Advance familiar Federation University and RMIT Scholarship examples from first-party URL verification into the governed Evidence/source-record stage for milestone validation.

## Applied wave
Evidence/source-record links were created for four first-party detail pages:
- Federation Merit Scholarship — 2026, international, 20% tuition reduction.
- Federation Global Merit Scholarship — 2027, international, 25% tuition reduction.
- RMIT Academic Merit Scholarship for South East Asia — international, 20% tuition reduction.
- RMIT Future Leaders Scholarship — international, 20% tuition reduction, eligible intakes from 2026.

Federation Pathways Scholarship remains `first_party_verified` because this run did not obtain a fresh detail capture; it was not promoted merely to make the milestone numbers look complete.

## Governance
- University-owned pages are the fact authority.
- Evidence and `pipeline.scholarship_source_records` must exist before the trace advances to `detail_acquired`.
- No canonical Scholarship row is fabricated.
- No Layer 4/publication decision is bypassed.
- No Search/Website/Zoho admission occurs.
