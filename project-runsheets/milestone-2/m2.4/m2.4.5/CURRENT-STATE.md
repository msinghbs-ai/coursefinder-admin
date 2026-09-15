# M2.4.5 CURRENT STATE

**Status:** CLOSED / PASS / FROZEN  
**Closed/Reconciled:** 2026-09-15 AEST  
**Accepted Pilot main:** `e62c01cadaf43efa8c3d8ea57625c23874d1b010`  
**Visible accepted release:** v2.15.79 / package 0.1.6  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Successor:** M2.4.6 — Production Operations Model ACTIVE  
**Production:** not provisioned; M2.5 paused until M2.4.9 GO

## Accepted operational truth

CF-093 is CLOSED / PASS / HISTORICAL ONLY and must not be reopened.

CF-245 is CLOSED / PASS after PRs #91–#95. The accepted baseline provides operational telemetry, AU/NZ backlog classification, bounded deterministic enrichment/admission, hourly coverage snapshots and rank-gated Enrichment Operations reporting without weakening Layer authority, Evidence, security or Search/publication boundaries.

Latest accepted AU coverage is 33,105 Search courses, 26,457 regulatory tuition, 487 intake, 520 English requirements, 421 official course URLs, 161 provider-current tuition and 0 website-admitted scholarships. NZ remains blocked from broad enrichment pending governed qualification.

The first dedicated deployed CF-245 run `34925786691` correctly exposed Admin RPC statement timeouts. PR #95 introduced a private persisted hourly reporting cache via applied migration `20260915034453_cf_245_enrichment_hourly_admin_cache_v1`; it changed reporting mechanics only. Final dedicated CF-245 UAT `34926246733`, generic targeted UAT `34926246675`, build/smoke `34926246673` and Cloudflare deployment all PASS.

Real hourly history exists and records intake/English growth from 161/161 to 487/520 on 15 September 2026. Ongoing daily-history interpretation, dispatcher/retry procedures, tuning and scale are successor operations work, not unfinished M2.4.5 implementation.

## Handoff

M2.4.5 is frozen. Continue with `project-runsheets/milestone-2/m2.4/m2.4.6/` and `M2.4.6-M2.4.9-OPERATIONS-PLAN.md`.
