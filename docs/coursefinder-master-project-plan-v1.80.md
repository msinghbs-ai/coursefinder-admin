# CourseFinder Master Project Plan v1.80

**Issued:** 1 September 2026  
**Status:** CURRENT  
**Supersedes:** v1.79  
**Programme position:** M1 FROZEN; M2.1–M2.4 CLOSED/PASS; M2.5 ACTIVE / READINESS; M3 Zoho Pilot ACTIVE/PARTIAL in parallel

## 1. Programme position

M2.4 is CLOSED/PASS. M2.4.4 closed under `CF-CHG-20260830-048` at accepted Pilot `95f2991e97e76e644bd74f73512b8bf2725fd4b7`, build `33468512538` PASS, final acceptance `33468512515` PASS.

M2.5 — Clean Production Stack Deployment, Restore & Security Acceptance — is now **ACTIVE / READINESS** under `CF-CHG-20260901-049`.

Production remains a separate trust boundary. No Production Supabase project exists yet and no Pilot environment has been promoted or renamed.

## 2. M2.5 outcome

M2.5 must establish and accept:
- separate paid-plan Supabase Production project;
- Production Auth/RBAC/session hardening;
- Production-only secrets/Vault/vendor credentials;
- private Evidence Storage;
- accepted schema/migrations and controlled data establishment;
- protected GitHub Production CI/CD;
- Cloudflare Production deployment/origin/WAF;
- backup/restore/DR;
- monitoring/alerts/runbooks;
- Production-specific targeted → integration → final desktop/mobile UAT.

## 3. Readiness truth

Current Supabase project inventory:
- `coursefinder_Pilot` / `fxcwkweaxjtknorudmwp` / ap-south-1;
- `coursefinder-demo` / `gfryvshbeptxwbzjomhe` / ap-southeast-2;
- unrelated inactive `ARR`;
- **no CourseFinder Production project**.

Visible Supabase organisation:
- `techM` / `rszbvkqopqfvjldvfnbh`.

Paid project creation is blocked until explicit organisation, quoted project cost and Production region confirmation are captured.

## 4. Milestone sequence

| Milestone | Status | Planned-hours baseline | Outcome / focus |
|---|---|---:|---|
| M2.0–M2.4 | CLOSED / PASS | accepted historical | Pilot operational maturity and pre-Production acceptance |
| **M2.5** | **ACTIVE / READINESS** | **12** | clean Production stack deployment / restore / security acceptance |
| Blackout 16–30 Sep | NO DELIVERY | 0 | no planned project implementation/deployment/UAT |
| M3 | ACTIVE / PARTIAL (Zoho Pilot) / broader milestone later | 10 | consumer API / Zoho integration |
| M4 | PLANNED | 8 | Search/publication/final Production handover |

The historical delivery sequence places M2.5 implementation after the blackout. Readiness/governance may be prepared beforehand; supplier/resource spend and billable delivery are not inferred.

## 5. M2.5 security gates

Production cannot close PASS with:
- leaked-password protection unproven;
- unexplained WARN/ERROR/Critical/High security findings;
- exposed service-role/provider credentials;
- unverified RLS/grants/views/SECURITY DEFINER boundaries;
- missing anon/insufficient-rank negative tests;
- unproven private Evidence access;
- untested restore/rollback;
- unprotected deployment path.

`CF-CHG-20260823-022` leaked-password protection is a mandatory Production gate.

## 6. Current Pilot carry-forward

Layer 2 Pilot background parent:
- parent `c65e67a6-3b2e-47e3-832a-57118fe5cf5f`;
- wave `1bb1504d-7bad-42d9-b059-4adeaf9118c7`;
- 219/261 completed at M2.4 closure;
- 42 governed scheduled remainder;
- not a Production seed authority and not an M2.5 blocker.

## 7. Parallel Zoho boundary

`CF-CHG-20260827-045` remains ACTIVE/PARTIAL for Zoho Creator Pilot integration. M2.5 does not authorise Zoho Production cutover or Production Zoho secrets.

## 8. Explicit exclusions

M2.5 does not automatically authorise:
- broad Publication;
- Website Production cutover;
- Zoho Production cutover;
- RMIT frozen promotion;
- deferred NZ first-party L2 expansion;
- M4 final handover.

## 9. Current baselines

- Running Build: `docs/coursefinder-running-build-v2.80.md`;
- DB Architecture: v2.10.44 plus accepted M2.4.4 migrations;
- Admin/PIM Decisions: v1.24 plus accepted M2.4.4 standing addenda;
- Production Change Control: `CF-CHG-20260901-049`.

## 10. Immediate next action

Before any billable Supabase Production project is created:
1. confirm intended Supabase organisation;
2. approve Production region;
3. fetch exact supplier project cost;
4. present and confirm cost;
5. create the clean Production project only after confirmation.
