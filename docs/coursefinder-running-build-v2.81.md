# CourseFinder Running Build v2.81

**Status:** M1 FROZEN / M2.1–M2.4 CLOSED-PASS / M2.5 ACTIVE-READINESS  
**Date:** 1 September 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.80.md`  
**Master Project Plan:** `docs/coursefinder-master-project-plan-v1.81.md`  
**Active Change Control:** `CF-CHG-20260901-049`

## Accepted Pilot source candidate

`msinghbs-ai/Coursefinder-Pilot@95f2991e97e76e644bd74f73512b8bf2725fd4b7`.

This is the accepted source/deployment candidate entering M2.5. It is **not** Production truth.

Final M2.4.4 evidence:
- build `33468512538` PASS;
- acceptance `33468512515` PASS;
- desktop 75 passed;
- mobile 76 passed;
- Security 146 INFO / 0 WARN / 0 ERROR;
- Performance 172 INFO / 0 WARN / 0 ERROR.

## Production readiness state

No CourseFinder Production Supabase project exists.

Visible projects:
- `coursefinder_Pilot` / ap-south-1;
- `coursefinder-demo` / ap-southeast-2;
- unrelated inactive `ARR`.

Visible organisation:
- `techM` / `rszbvkqopqfvjldvfnbh`.

Production project:
- project ref: NOT PROVISIONED;
- region: NOT APPROVED;
- supplier cost: NOT QUOTED/CONFIRMED;
- Auth: NOT ESTABLISHED;
- Storage: NOT ESTABLISHED;
- Vault/secrets: NOT ESTABLISHED;
- Production CI/CD: NOT ESTABLISHED;
- Cloudflare Production: NOT ESTABLISHED;
- restore/DR: NOT PROVEN;
- Production UAT: NOT RUN.

## M2.5 rule

Do not:
- rename or promote Pilot to Production;
- reuse Pilot secrets blindly;
- create billable Production resources without required confirmation;
- infer Production security from Pilot acceptance.

## Production mandatory security

`CF-CHG-20260823-022` leaked-password protection must PASS in Production.

Production also requires:
- Auth/RBAC/session regression;
- RLS/grants/views/RPC/SECURITY DEFINER audit;
- anon/negative tests;
- private Evidence;
- server-only secrets;
- Security Advisor disposition;
- restore/rollback proof;
- SHA-bound Production acceptance.

## Scheduling

16–30 September 2026 remains a no-planned-delivery blackout. M2.5 engineering baseline remains 12 planned hours.

## Parallel work

Zoho Creator Pilot `CF-CHG-20260827-045` remains ACTIVE/PARTIAL and separate. No Zoho Production cutover is authorised by M2.5 readiness.

## Platform maturity design baseline

No runtime change is asserted by CF-CHG-20260901-050.

Future controlled backlog:
- PM-A1 Country & Source Onboarding Maturity;
- PM-A2 Provider Collections / G8;
- PM-A3 Scholarship Relationship Operations;
- PM-A4 Manual Intervention & Blocking;
- PM-A5 Manual Entity Creation;
- PM-A6 Scraper Onboarding Framework;
- PM-A7 AI Onboarding Framework;
- PM-A8 Storage, Capacity & Notification;
- PM-A9 Retention, Purge & Housekeeping;
- PM-A10 Consumer Cache & Dataset Versioning;
- PM-A11 Platform UAT Catalogue;
- PM-A12 Performance & Workload Isolation.

See `docs/coursefinder-platform-maturity-design-v1.0.md`.

## M2.5 Pilot corrective state

Layer 2 run observability is corrected under `CF-CHG-20260901-052` without reopening M2.4.

Current Pilot source head at this checkpoint:
`9fa8f590c8370bf600f1495794f9205fabbdf8a7`.

Admin UI version:
**v2.15.15**.

Deployed correction:
- `20260901062200 m2_5_layer2_run_observability_correction`;
- terminal production parents retain child Jobs/Evidence after wave items become completed/failed;
- acquisition attempts and managed runs display timestamps;
- active work is separated from latest terminal production history;
- qualification retry-window no-op checks return `qualification_waiting`;
- post-action operator refresh errors are visible.

VIC proof:
- historical request `1bb1504d-7bad-42d9-b059-4adeaf9118c7`: 261 total / 42 completed / 219 failed;
- retained lineage: 261 Jobs / 783 Evidence artifacts;
- bounded check `c876a8fb-5f03-4433-85ab-5af7e96cee63`: zero eligible Providers, zero new production wave requests, zero new Course Jobs.

CF-052 targeted deployed UAT:
- run `33477539721`;
- job `99760830965`;
- Chromium desktop: **2 passed / 0 failed**.

Post-change advisors remain:
- Security 146 INFO / 0 WARN / 0 ERROR;
- Performance 174 INFO / 0 WARN / 0 ERROR.

## Next

Obtain explicit organisation + Production region confirmation, then obtain and confirm Supabase project cost before provisioning the Production project.
