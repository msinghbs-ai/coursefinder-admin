# CourseFinder Master Project Plan v1.81

**Issued:** 1 September 2026  
**Status:** CURRENT  
**Supersedes:** v1.80  
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

- Running Build: `docs/coursefinder-running-build-v2.81.md`;
- DB Architecture: `docs/coursefinder-database-architecture-v2.10.50.md`;
- Admin/PIM Decisions: `docs/coursefinder-admin-pim-design-decisions-v1.31.md`;
- Production Change Control: `CF-CHG-20260901-049`.

## 10. Post-M2.4 platform maturity design

CF-CHG-20260901-050 is APPLIED as a design baseline only.

Authoritative future-maturity references:
- `docs/coursefinder-platform-maturity-design-v1.0.md`;
- `docs/coursefinder-uat-performance-baseline-v1.0.md`;
- `project-runsheets/milestone-2/m2.5/PLATFORM-MATURITY-IMPLEMENTATION-BACKLOG.md`.

The backlog contains PM-A1…PM-A12 covering country/source onboarding, Provider collections/G8, Scholarship relationships, manual intervention/blocking/entity creation, scraper/AI onboarding, storage/capacity, retention, consumer caching, UAT catalogue and workload isolation.

These do not reopen M2.4 and are not automatically M2.5 closure requirements. Each must be implemented only within its allocated M2.5/M3/M4/future gate.

## 11. Immediate next action

Before any billable Supabase Production project is created:
1. confirm intended Supabase organisation;
2. approve Production region;
3. fetch exact supplier project cost;
4. present and confirm cost;
5. create the clean Production project only after confirmation.


## 12. QS / THE ranking context addendum — 2 September 2026

CF-CHG-20260902-063 / A29 adds a design-approved M2.5+ workstream for:
- QS World University Rankings 2026 and 2027;
- Times Higher Education World University Rankings 2026;
- 5–10 years of historical editions where official publisher access and reuse conditions permit;
- editioned Layer 1 publisher-authoritative Provider context;
- governed Provider crosswalk, source Evidence, methodology/version retention and historical trend display;
- Provider/detail and comparison UX after bounded Pilot implementation.

Current authority:
- `docs/coursefinder-university-ranking-data-design-v1.0.md`;
- `docs/coursefinder-database-architecture-v2.10.46.md`;
- `docs/coursefinder-admin-pim-design-decisions-v1.26.md`;
- `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A29-QS-THE-WORLD-RANKINGS.md`.

This is design/readiness scope only at this checkpoint. It does not claim deployed schema, live ranking ingestion, Production enablement, or Search/Website/Zoho publication.


## 13. Layer 2 acquisition consolidation addendum — 2 September 2026

CF-CHG-20260902-081 / A31 implements the Pilot foundation for shared Layer 2 acquisition across Course facts, Scholarships and Provider assets/logos.

The change is cost/operations maturity work and does not reopen M2.4 or change the M2.5 Production gate. Full crawls follow source volatility rather than blanket daily execution, while same-URL Evidence can be reused across independent extraction profiles.

Current design authority:
- DB Architecture `v2.10.48`;
- Admin/PIM Decisions `v1.29`;
- A31;
- CF-CHG-20260902-081.

Parse.bot is only a disabled onboarding slot pending trial API qualification. Firecrawl remains the active rendered fallback.


## 14. Scholarship catalogue→detail and Provider asset promotion addendum — 3 September 2026

CF-CHG-20260903-083 / A32 extends A31 with a governed production-shaped pattern for large Provider Scholarship catalogues and Provider-logo promotion.

Current Pilot proof:
- seven first-party AU Scholarship catalogue entrypoints acquired/normalised;
- five yielded enumerated candidates and two correctly remain needs-review;
- 52 catalogue candidate links recorded;
- six individual first-party Scholarship detail pages completed acquisition/normalisation/extraction;
- six stable URL-identified canonical Scholarship roots created, all unpublished;
- six Layer 4 `scope_resolution` review items pending;
- two primary Provider logos promoted into managed hashed asset storage;
- changed surface remains 0 WARN / 0 ERROR.

This does not authorise broad Scholarship population, scope acceptance, Search/Website/Zoho admission or Production cutover.


## 15. Environment & Production Supabase portability addendum — 3 September 2026

CF-CHG-20260903-084 / A33 establishes the Administration and migration-control foundation for a clean Production Supabase project in a separate tenancy/project.

Production migration is explicitly multi-plane:
Database/Auth data + Vault/credentials + Storage bucket configuration + Storage object bytes + Edge Functions + custom secrets + Auth settings/project keys + cron + extensions/project settings + CORS/origins + Evidence path verification.

Pilot Evidence portability snapshot at this gate:
- 17,400 Evidence rows;
- 17,391 relative Storage paths;
- 0 absolute Evidence Storage paths;
- 0 Pilot Supabase URLs in Evidence source/metadata;
- 17,626 Storage objects;
- 2 private buckets;
- 14 cron jobs;
- 7 Vault secrets.

Admin UI v2.15.43 adds Administration → Environment & Migration. It does not create Production or waive the separate organisation/region/cost approval gate.
