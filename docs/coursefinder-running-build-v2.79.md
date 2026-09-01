# CourseFinder Running Build v2.79

**Status:** M1 FROZEN / M2.1–M2.4 CLOSED-PASS / M2.4.0–M2.4.4 CLOSED-PASS  
**Date:** 1 September 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.78.md`  
**Master Project Plan:** `docs/coursefinder-master-project-plan-v1.79.md`  
**Closed Change Control:** `CF-CHG-20260830-048`

## Accepted Pilot

`msinghbs-ai/Coursefinder-Pilot@95f2991e97e76e644bd74f73512b8bf2725fd4b7`.

## Final acceptance

- frontend build `33468512538`: PASS;
- deployed acceptance `33468512515`: PASS;
- chromium-desktop: 75 passed;
- chromium-mobile: 76 passed;
- acceptance desktop and mobile status contexts: success.

Historical final candidate `41428941a1bae18f6e53ac37f81ae54ef5704b1a` / UAT `33460038608` remains immutable FAIL evidence.

## Accepted M2.4.4 runtime

Layer 2:
- stable parent `c65e67a6-3b2e-47e3-832a-57118fe5cf5f`;
- scope wave `1bb1504d-7bad-42d9-b059-4adeaf9118c7`;
- route `scraper_first`;
- 261 queueable production Courses;
- 219 completed/dispatched;
- 42 scheduled remainder;
- 0 failed;
- no active production batch/provider attempt at closure.

Runtime hardening:
- selected-provider Firecrawl handoff;
- terminal partial batches no longer block later waves;
- Firecrawl invocation chunks capped for Edge timeout safety;
- stale successful acquisitions recover without duplicate vendor calls;
- child progress refreshes parent heartbeat;
- parent metrics and Evidence counts are aggregated without fan-out.

UI/operations:
- canonical Layer 1/2/3/4 Operations navigation;
- central Administration with canonical section deep links/history restoration;
- production Layer 2 parent progress and Jobs/Evidence links;
- concise Layer 3 operator summary;
- responsive detail blades;
- Scholarship decision support under canonical Scholarships workspace;
- A25 Evidence preview/screenshot integrity retained.

Security/advisors:
- Security Advisor 146 INFO / 0 WARN / 0 ERROR;
- Performance Advisor 172 INFO / 0 WARN / 0 ERROR;
- FU-020 resolved: no anon/authenticated direct grants to inspected RLS-disabled pipeline tables and no anon/authenticated pipeline schema usage;
- no blanket RLS changes.

## Boundaries

No Production cutover, broad Publication, Website/Zoho production cutover, RMIT frozen promotion, deferred NZ Layer 2 expansion or autonomous Layer 3 canonical mutation is authorised by this build.

## Next

M2.4 is closed. Start the next milestone only after reading the current Master Plan, Standing Instructions, closed `CF-CHG-20260830-048`, and current runtime truth.
