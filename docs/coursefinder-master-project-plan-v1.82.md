# CourseFinder Master Project Plan v1.82

**Issued:** 23 September 2026  
**Status:** CURRENT  
**Supersedes:** v1.81  
**Programme position:** M1 FROZEN; M2.0–M2.4.6 CLOSED/PASS; M2.4.7 ACTIVE under CF-CHG-20260915-247; M2.4.8–M2.4.9 PLANNED; M2.5 PAUSED (readiness only) until M2.4.9 GO; M3 Zoho Pilot ACTIVE/PARTIAL in parallel

## 1. Programme position

M2.4.0–M2.4.6 are CLOSED/PASS. M2.4.4 closed under `CF-CHG-20260830-048` at accepted Pilot `95f2991e97e76e644bd74f73512b8bf2725fd4b7`, build `33468512538` PASS, final acceptance `33468512515` PASS. M2.4.7 is ACTIVE under `CF-CHG-20260915-247`, governed by the end-to-end automated admission outcome rather than raw wave volume. This corrects v1.81, which recorded M2.4 as fully closed and M2.5 as active; the document router has treated M2.4.7 as active and M2.5 as paused since CF-247 opened.

M2.5 — Clean Production Stack Deployment, Restore & Security Acceptance — is **PAUSED / READINESS ONLY** under `CF-CHG-20260901-049`. Readiness and governance may be prepared, but Production establishment must not start until M2.4.9 records GO.

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
| M2.0–M2.4.6 | CLOSED / PASS | accepted historical | Pilot operational maturity and pre-Production acceptance |
| **M2.4.7** | **ACTIVE** | not yet baselined | first complete automated admission run, end to end, on a controlled AU wave |
| M2.4.8 | PLANNED | not yet baselined | consumer and data-operations readiness |
| M2.4.9 | PLANNED | not yet baselined | Production dress rehearsal and explicit GO/NO-GO |
| M2.5 | PAUSED / READINESS ONLY | 12 | clean Production stack deployment / restore / security acceptance |
| Blackout 16–30 Sep | STATUS TO BE CONFIRMED | 0 | CF-247 delivery continued within this window; formal status (lifted or varied) to be recorded |
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

## 15. M2.4.5 Provider assets and ranking expansion addendum — 3 September 2026

CF-091 adds pre-Production completion work without changing the current architecture baseline:
- H11: Provider/university primary-logo completeness and governed source discovery;
- H12: ARWU 2025 + multi-year ARWU and University Diversity/HDI in Statistics & Rankings;
- H13: dual ranking acquisition through uploaded parser Evidence and governed API/Parse.bot endpoints.

Commercial aggregators including Hotcourses remain discovery/reconciliation sources by default; first-party/publisher/government authority and Evidence are preserved. Parse.bot credentials remain Vault-only and API/file acquisition must converge on a common editioned staging/validation/apply path.

## Path to Production handover (added v1.82)

Verified position at 23 September 2026: every component of the automated admission pipeline exists, but no complete run has yet happened end to end. Scheduled jobs are healthy but idle (no Layer 2 work queued since 15 September; last Evidence 19 September). The Layer 3 dispatcher is built but not scheduled, no qualified profile is active, and no field has yet been admitted through Layer 3.

| Stage | Milestone | Exit condition |
|---|---|---|
| 1 | M2.4.7 | Activation gate, scheduled Layer 3 dispatcher, confirmed admission policy, Search/API projection, honest scheduled-job telemetry; one controlled AU run admits real data end to end with an Evidence trail |
| 2 | M2.4.8 | Consumer APIs stable; Scholarships/Rankings/Statistics on the shared control plane; single Data Operations view with an L1→L4 trace per run; a second qualified model per active task class |
| 3 | M2.4.9 | All eleven roadmap Definition-of-Done items, security and performance matrices, and a restore rehearsal pass; explicit GO/NO-GO recorded |
| 4 | M2.5 → M3 → M4 | Production establishment under CF-049 gates, then consumer API/Zoho, then Search/publication and final handover |

Open decisions: activation authority; whether portability (NZ/CA pilots, GB/US/IE/DE tests) is required before handover or after M2.5; formal blackout status; hour baselines for M2.4.7–M2.4.9; Production organisation, cost and region.
