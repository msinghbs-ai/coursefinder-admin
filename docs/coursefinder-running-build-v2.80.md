# CourseFinder Running Build v2.80

**Status:** M1 FROZEN / M2.1–M2.4 CLOSED-PASS / M2.5 ACTIVE-READINESS  
**Date:** 1 September 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.79.md`  
**Master Project Plan:** `docs/coursefinder-master-project-plan-v1.80.md`  
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

## Next

Obtain explicit organisation + Production region confirmation, then obtain and confirm Supabase project cost before provisioning the Production project.
