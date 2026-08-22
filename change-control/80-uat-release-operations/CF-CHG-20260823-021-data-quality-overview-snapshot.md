# CF-CHG-20260823-021 — Data Quality overview snapshot and concurrent UAT hardening

**Status:** IMPLEMENTING / UAT  
**Category:** `80-uat-release-operations`  
**Initiated:** 23 August 2026 07:00 AEST (UTC+10)  
**Origin:** M1-UAT-HARNESS first authenticated deployed desktop/mobile run  
**Owner:** CourseFinder release operations / Admin data quality  
**Affected surfaces:** Data Quality overview read path, Admin dashboard startup, Playwright deployed UAT, Supabase operational scheduling  
**Change class:** performance/reliability hardening; no canonical or readiness-semantic change

## 1. Trigger

The first automatically triggered authenticated deployed Playwright run successfully authenticated both desktop Chromium and Pixel 7/mobile projects using the governed Curator UAT identity, but reproduced `public.admin_read` HTTP 500 responses under concurrent startup.

Postgres evidence shows the 500s are statement-timeout cancellations. The authenticated browser role has an 8 second statement timeout. Direct cold-path measurement of `public.admin_read('data_quality_overview', '{}')` reached approximately 10.65 seconds, while a warm result can be sub-second. The prior browser acceptance therefore represented a warm-cache best case rather than a safe production read contract.

The Admin Dashboard read also became vulnerable to timeout while the heavy Data Quality scans were running concurrently. Its Recent Activity query currently unions all Job/Review/Evidence rows before limiting to 10.

## 2. Decision

Do **not** increase the browser statement timeout and do **not** weaken the UAT harness by ignoring transient 5xx responses.

The governed design is:

1. keep `data_quality_exceptions` live and bounded/paged;
2. compute aggregate `data_quality_overview` out-of-band into a private timestamped server snapshot for AU+NZ, AU and NZ;
3. serve browser overview reads from that snapshot;
4. expose snapshot computation time so operators can distinguish freshness from live drill-down;
5. refresh snapshots on a governed database schedule and permit service-only/manual recomputation without browser service-role exposure;
6. bound each Dashboard recent-activity source before the final cross-source top-10 sort;
7. retain HTTP 5xx as an automated UAT failure;
8. enrich future runtime evidence with the failing `admin_read` operation name, without capturing passwords/tokens.

## 3. Invariants

- The nine-state vocabulary and all Data Quality domain semantics remain unchanged.
- Expected AU+NZ regulatory-fee values remain: Present 26,326; Source-null 191; Not applicable 6,457; Zero 131; readiness 99.28%.
- No canonical Provider/Course/Campus/Scholarship data is rewritten by snapshot refresh.
- Search projection does not become publication.
- Evidence remains private.
- Browser roles do not receive service-role credentials or direct access to snapshot storage/refresh helpers.
- A snapshot timestamp is authoritative for aggregate freshness; exception drill-down remains a live server query.

## 4. Minimum acceptance

- private snapshot storage and refresh helper ACL PASS;
- initial AU+NZ/AU/NZ snapshot payloads equal live computation for the governed metric contract;
- browser `data_quality_overview` p95-style repeated reads comfortably below the authenticated 8-second timeout, target <500 ms warm and <1 s cold-cache server read;
- Data Quality Source-null 191 exception paging remains unchanged;
- Dashboard startup read remains below timeout under concurrent UAT;
- automated desktop/mobile deployed run authenticates successfully and records zero unexpected 5xx;
- build/suite discovery/browser smoke PASS;
- governance records exact migration, scheduler and UAT evidence before closure.

## 5. Rollback

Restore `security.admin_data_quality_read` overview dispatch to `security.data_quality_overview_impl`, remove the scheduled snapshot refresh and private snapshot table after preserving acceptance evidence. No canonical data rollback is required.
