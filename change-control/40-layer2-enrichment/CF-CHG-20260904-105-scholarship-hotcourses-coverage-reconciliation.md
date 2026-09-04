# CF-CHG-20260904-105 — Scholarship Hotcourses Coverage Reconciliation

**Status:** IMPLEMENTED / RECONCILIATION ACTIVE  
**Date:** 4 September 2026 (Australia/Sydney)  
**Milestone:** M2.4.5  
**Parent:** CF-CHG-20260903-083

## Decision
Reopen Australian scholarship completeness. Hotcourses Abroad is approved only as a Layer 2 discovery/coverage benchmark. It is not an authority for canonical scholarship facts, Provider identity or publication.

Accepted route:
`Hotcourses discovery benchmark -> candidate inventory -> first-party university verification -> canonical unpublished scholarship -> Layer 4 applicability/scope decision -> publication gate`.

## Runtime implementation
Pilot migration `20260904010542_cf_105_scholarship_coverage_benchmark.sql` adds private `pipeline.scholarship_coverage_benchmarks` with RLS, browser grants revoked and service-role-only access.

Seeded observations verified on 4 September 2026:
- Australia: 591 Hotcourses scholarships (country benchmark);
- University of Melbourne: 106 vs 5 current canonical;
- Australian National University: 55 vs 14 current canonical;
- Monash University: 46 vs 13 current canonical.

These numbers measure discovery coverage only. They must not be copied directly into canonical scholarship records.

## Completeness implication
The previous live canonical count of 186 cannot be treated as an Australian completeness baseline. M2.4.5 scholarship completion now requires provider-by-provider reconciliation, official-source verification, deduplication and Layer 4 resolution where scope is ambiguous.

## Security
The benchmark table is private, RLS-enabled, has no `anon`/`authenticated` grants and is available to the service role for controlled acquisition/reconciliation.

## Publication boundary
No benchmark observation is admitted to Search, Website/Wix or Zoho. Canonical scholarship publication remains governed separately.
