# CF-CHG-20260823-027 — M1 Security, ACL & Release Readiness Gate

**Status:** **BLOCKED**  
**Category:** `70-security-platform`  
**Initiated:** 23 August 2026 16:24 AEST (UTC+10)  
**Assessed:** 23 August 2026 AEST  
**Origin:** CourseFinder chat — `12. M1-SECURITY-RELEASE`  
**Owner:** CourseFinder security/platform governance  
**Affected surfaces:** `80-uat-release-operations`, Admin/PIM, Pipeline, Evidence, Search/publication, Supabase Auth/RBAC/RLS/Storage/Edge Functions, Zoho boundaries  
**Change class:** final security/ACL/release closure audit

## 1. Requested outcome

Perform the independent Milestone 1 release-security closure gate against the actual deployed Pilot after PIM, Pipeline, Evidence, Search/publication and documentation work. PASS requires diagnostic/UAT/temporary surfaces to be removed and residual risks to be explicit.

## 2. Reconciled baseline and parallel-work protection

Initial governance baseline was Master Project Plan v1.64, Running Build v2.66, Database Architecture v2.10.40, Admin/PIM Decisions v1.13, User Guide v2.0, PIM Admin Guide v1.15 and Operations Runbook v1.0.

During reconciliation, parallel M1 Performance work was found to already own `CF-CHG-20260823-026`, and Pilot `main` had advanced to `1bcb96d26f7c701ec6cf91d771016cb6405f51b2`. The transient duplicate security 026 record was removed; this work is correctly keyed as `CF-CHG-20260823-027`. No newer Performance/Layer 1 code was overwritten.

Overlapping accepted risk:

- `CF-CHG-20260823-022` — leaked-password protection — deferred for Pilot only; mandatory before Production go-live.

## 3. Implemented security cleanup

Live project: `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`).

Two obsolete authenticated compatibility overloads of `public.ui_providers_page(...)` were still browser-executable although current Admin code uses only `public.admin_read(text,jsonb)`.

Applied live migration:

- `20260823062726_m1_security_release_remove_legacy_provider_rpc`.

Mirrored Pilot source:

- `supabase/migrations/20260823062726_m1_security_release_remove_legacy_provider_rpc.sql`;
- commit `f829eea9be1a21363ae59781bf3c47b314f6c1c5`.

Post-change live enumeration proves the only browser-executable application RPC in `public` is:

- `public.admin_read(text,jsonb)` — authenticated only, anon denied, SECURITY INVOKER.

## 4. Technical UAT result

Detailed evidence:

- `docs/uat/coursefinder-m1-security-release-technical-acceptance-2026-08-23.md`.

Passed controls include:

- no direct anon/authenticated table grants across application schemas;
- remaining public compatibility views are `security_invoker=true` and have no browser SELECT grants;
- anon `admin_read` denial;
- Curator rank 3 Evidence access succeeds;
- Curator rank 3 Pipeline access is denied with SQLSTATE `42501`;
- Platform Admin rank 6 Pipeline/PIM reads succeed;
- Access Admin helper RPCs are service-role only;
- publication readiness/mutation RPCs are service-role only;
- `evidence` Storage bucket is private with no browser Storage policies;
- Evidence signed access requires JWT + Curator rank and produces short-lived signed URLs;
- publication/Zoho boundary remains closed: zero publication entity states and zero published Search documents;
- admitted privileged Edge paths keep service-role credentials server-side.

Supabase Security Advisor after cleanup has no observed Critical/Error findings. INFO `RLS enabled / no policy` findings are explained by the intentional private-schema deny-by-default architecture and the absence of browser table grants. The known leaked-password WARN remains governed by `CF-CHG-20260823-022`.

Performance Advisor contains INFO-only items and remains owned by the separate Performance workstream.

## 5. Blocking finding — active diagnostic/UAT Edge surfaces

The live Edge inventory still contains numerous explicitly diagnostic, UAT, reset, probe or rejected-gate functions, including examples such as:

- `pilot-reset`;
- `layer1-runtime-uat`;
- `layer1-depth-uat`;
- `cricos-depth-inspect`;
- `layer1-au-full-gate`;
- `layer1-nz-source-inspect`;
- `layer1-nz-gate-uat`;
- `search-vector-gate`;
- multiple CA `*-probe` / `*-audit` functions.

Some production functions with `verify_jwt=false` implement a valid custom-auth path. Live `layer1-au-depth` v1.6.0, for example, requires a consumed one-time Pilot nonce or a validated JWT plus Platform Admin authorisation before privileged service operations. These should not be confused with unauthenticated public functions.

Nevertheless, the active diagnostic/UAT/probe inventory directly fails the requested release criterion that those surfaces be removed before PASS. The connected Supabase management surface available for this audit does not expose safe Edge-function undeploy/delete, and several functions overlap newer Layer 1/CA work. Tombstoning or redeploying them without current-owner reconciliation would violate the no-overwrite rule.

## 6. Residual risks

### Blocking

1. Diagnostic/UAT/probe/reset/rejected Edge functions remain ACTIVE and require governed decommission/reclassification.
2. Their ownership/source must be reconciled with current Layer 1/CA work before destructive removal.

### Accepted Pilot-only

3. Supabase leaked-password protection remains disabled under `CF-CHG-20260823-022`; Production release remains blocked until enabled.

### Explained/non-blocking

4. RLS-with-no-policy INFO findings implement intentional private-schema deny-by-default and have no browser direct table grants.
5. Performance INFO findings are governed by the separate M1 Performance workstream.

## 7. Required re-test before PASS

- agree the final Edge-function allowlist with current Layer 1/2 owners;
- undeploy obsolete diagnostic/UAT/probe/reset/rejected functions;
- prove custom authentication for every remaining `verify_jwt=false` Edge Function;
- rerun Edge inventory, browser RPC ACL, role-rank negative UAT, Storage/Evidence boundary, publication/Zoho boundary and Security Advisor;
- enable leaked-password protection before any Production PASS.

## 8. Rollback

The Provider compatibility cleanup can be reversed by recreating the two removed wrapper overloads, but they should not be restored without a governed consumer. `public.admin_read(text,jsonb)` and all accepted role semantics were unchanged.

## 9. Closure state

**BLOCKED WITH EVIDENCE.**

Database/browser/Storage/Evidence/publication ACL posture passed after compatibility cleanup. The overall M1 security release gate is not PASS because the explicit diagnostic/UAT/temporary Edge cleanup criterion remains unmet.
