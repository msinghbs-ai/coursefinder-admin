# CF-CHG-20260904-105 — Scholarship Landscape Coverage Reconciliation

**Status:** IMPLEMENTED / RECONCILIATION ACTIVE  
**Date:** 4 September 2026 (Australia/Sydney)  
**Milestone:** M2.4.5  
**Parent:** CF-CHG-20260903-083

## Decision
Reopen Australian scholarship completeness using external scholarship catalogues only to understand the likely coverage landscape and identify missing candidates.

External discovery sources are not authorities for canonical scholarship facts, Provider identity or publication. Their URLs/counts remain private pipeline provenance and completeness evidence.

Accepted route:
`landscape discovery -> candidate inventory -> first-party university verification -> canonical unpublished scholarship -> Layer 4 applicability/scope decision -> publication gate`.

## Runtime implementation
Pilot migration `20260904010542_cf_105_scholarship_coverage_benchmark.sql` adds private `pipeline.scholarship_coverage_benchmarks` with RLS, browser grants revoked and service-role-only access.

Initial landscape observations captured on 4 September 2026 demonstrate that the previous canonical inventory is materially incomplete for several major Australian universities. Exact third-party observations remain internal operational evidence rather than a published CourseFinder reference.

## Completeness implication
The previous live canonical count of 186 cannot be treated as the Australian completeness baseline. M2.4.5 scholarship completion requires provider-by-provider reconciliation, first-party verification, deduplication and Layer 4 resolution where scope is ambiguous.

## Security
The benchmark table is private, RLS-enabled, has no `anon`/`authenticated` grants and is available to the service role for controlled acquisition/reconciliation.

## Publication boundary
No landscape observation is admitted to Search, Website/Wix or Zoho. First-party university evidence remains the publication authority.
