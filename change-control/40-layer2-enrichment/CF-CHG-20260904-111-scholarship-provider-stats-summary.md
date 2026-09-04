# CF-CHG-20260904-111 — Scholarship Provider Stats Summary

**Status:** IMPLEMENTED / TARGETED PASS  
**Date:** 4 September 2026 (Australia/Sydney)  
**Milestone:** M2.4.5  
**Parents:** CF-CHG-20260904-105 / CF-CHG-20260904-107 / CF-CHG-20260904-110

## Objective
Maintain a live provider-level scholarship summary for rapid operational review and milestone demonstration without relying on manually maintained counters.

## Runtime implementation
Pilot migration `20260904114500_cf_111_scholarship_provider_stats_summary.sql` creates `pipeline.scholarship_provider_stats` as a live derived view over canonical Scholarships, acquisition trace, Layer 4/publication linkage and internal landscape coverage observations.

Fields include:
- canonical total;
- published/unpublished total;
- traced candidate total;
- first-party verified total;
- Layer 4 linked total;
- canonical linked total;
- publication-decision linked total;
- internal landscape benchmark total where available;
- indicative coverage gap;
- canonical-to-landscape percentage;
- benchmark and trace timestamps.

The landscape fields are operational discovery/completeness signals only. They are not source authority and are not consumer-facing references.

## Initial milestone wave snapshot
- Australian National University: 14 canonical / 2 first-party verified / 55 landscape signal / 25.5% canonical-to-landscape.
- Federation University Australia: 3 canonical / 3 first-party verified.
- Monash University: 13 canonical / 2 first-party verified / 46 landscape signal / 28.3% canonical-to-landscape.
- RMIT University: 6 canonical / 2 first-party verified.
- University of Melbourne: 5 canonical / 4 first-party verified / 106 landscape signal / 4.7% canonical-to-landscape.

All current canonical Scholarship roots remain unpublished at this checkpoint.

## Security
The view is private to the pipeline schema. Direct grants are revoked from `public`, `anon` and `authenticated`; `service_role` retains SELECT for controlled operations.

## Operating rule
Use this summary as the quick operational dashboard source. Counts derive live from authoritative internal tables and must not be manually overwritten.
