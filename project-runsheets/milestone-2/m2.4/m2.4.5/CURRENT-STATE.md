# M2.4.5 CURRENT STATE

**Status:** ACTIVE / H1 IMPLEMENTED — TARGETED UAT ACTIVE / H2 STARTED  
**Updated:** 2026-09-03 10:45 AEST  
**Change Control:** CF-CHG-20260903-087

## Entry baseline

- M2.4.4 remains CLOSED / PASS / FROZEN.
- M2.5 Production readiness was reconciled at 2026-09-03 10:13 AEST and remains blocked at P0 because no Production Supabase project exists and Production organisation/region/name/cost are unconfirmed.
- M2.4.5 is inserted to complete Pilot/Admin/PIM hardening before P0 resumes.
- Pilot repo head at intake: `ce8ab734a1d4bb4743b09b09f3ae45a47bb9d7dc`.
- Admin repo pre-M2.4.5 head: `3dec3218abceca6ec7139c6fa931d931fd9be805`.
- targeted deployed UAT on Pilot head: SUCCESS, run `33696909480`.

## Initial priorities

P1. Admin IA/UI simplification and duplicate-setting audit.  
P2. Scraper Config enable/disable + effective routing consolidation.  
P3. Scholarship PIM grid/filter/order maturity.  
P4. Scheduler/Jobs operational review.  
P5. Manual PIM record pattern.  
P6. Publication automation control plane, disabled by default.  
P7. Production migration inventory/telemetry update after each material change.  
P8. Faster targeted UAT.  
P9. Milestone meeting evidence/time-interaction ledger.


## H1/H2 execution state — 2026-09-03 10:45 AEST

- Pilot source advanced to H1/H2 lineage ending `87eba42de1e03c9761b927f2cb59a793cd10215f` before final workflow routing.
- Visible Admin release: **v2.15.45**.
- H1 implemented under CF-088. Administration labels/ranks/breadcrumbs/cards share one metadata model. Users & Roles is embedded in Administration; legacy `#users-roles`, `#attributes` and `#settings` resolve to canonical sections.
- Historic rank-3 Scheduling/Onboarding hidden routes remain because central Administration is rank 4; redirecting them would alter permissions.
- H2 runtime inventory: Direct HTTP, Scrape.do, ScraperAPI, Firecrawl and ZenRows enabled; Parse.bot and Custom gateway disabled. Firecrawl records 5,000 monthly units / 250 reserve / 30 requests-min / concurrency 5 / 90s timeout.
- Production migration manifest: all tracked components source-ready; all target states pending. No Production project exists.
- Pilot roles remain viewer 1, counsellor 2, curator 3, pipeline_operator 4, PIM Operator 5, Platform Admin 6.
- Targeted CI is running; no full acceptance run requested.
