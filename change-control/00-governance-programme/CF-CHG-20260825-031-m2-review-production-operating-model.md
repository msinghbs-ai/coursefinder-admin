# CF-CHG-20260825-031 — M2 Consolidated Review, Production Operating Model & Security-First Milestone Governance

**Status:** APPLIED — AUTHORITATIVE M2 DELIVERY / PRODUCTION / HOURS BASELINE  
**Category:** 00-governance-programme  
**Initiated:** 25 August 2026 11:24 AEST (+10:00)  
**Updated:** 25 August 2026 19:05 AEST (+10:00)  
**Origin chat/workstream:** Milestone 2- REVIEW  
**Owner:** CourseFinder programme governance  
**Change class:** cross-cutting programme / production / operations / UI maturity / delivery governance

## Trigger

M2.1 completed its final deployed browser acceptance and the programme moved from Pilot-scale Layer 2 learning into production-grade Layer 1–3 operations. The Supabase Free-plan threshold was exceeded, requiring explicit capacity, vendor, operational and Production-environment planning.

The programme also requires a durable delivery/hour baseline for milestone meetings and billing review. The previous leadership schedule contained separate M2/M3/M4 enrichment gates and overlapping September Production targets; these are now consolidated into a single governed M2 programme and reconciled with the explicit 16–30 September no-delivery period.

## Decision

1. M2.1 remains CLOSED / PASS only against the final SHA-bound deployed UAT evidence.
2. Layer 2 is an accepted deterministic platform capability, not an experiment.
3. Consolidate the former AU structured-enrichment, AU Scholarship and NZ enrichment workstreams into Milestone 2 sub-gates.
4. Adopt the following authoritative sequence and hour envelope:
   - M2.0 Programme Consolidation & Auto-UAT — 8 h recorded;
   - M2.1 Layer 2 Platform — 3 h recorded;
   - M2.2 Security & Production Foundation — 10 h;
   - M2.3 L2 Scale Enrichment & L1/L2 UX Maturity — 12 h;
   - M2.4 L3 AI Operations & Pre-Blackout Gate — 7 h;
   - 16–30 Sep — 0 h / no project delivery;
   - M2.5 Full Production Stack Deployment & Acceptance — 12 h;
   - M3 Consumer API / Zoho — 10 h;
   - M4 Search / Publication / Production Handover — 8 h.
5. Total post-M1 planned engineering envelope is 70 h, with 11 h recorded through 25 Aug and 59 h remaining planned.
6. Active delivery weeks target approximately 8–12 h. The 22–28 Aug period is capped at 12 h under the current plan.
7. Production deployment is included in the programme and is a clean trust boundary, not a renamed Pilot environment.
8. Mature Admin IA around explicit Layer 1, Layer 2 and Layer 3 operational workspaces while retaining Layer 4 as terminal human resolution.
9. Security remains the primary milestone acceptance criterion.
10. Supabase/vendor/Cloudflare subscription/usage charges are expenses at actual supplier cost and are separate from engineering hours.

## Detailed TSOW / delivery authority

New authoritative detailed delivery plan:

`docs/coursefinder-m2-production-delivery-plan-tsow-v1.0.md`

New master programme baseline:

`docs/coursefinder-master-project-plan-v1.67.md`

These documents define task-level hours, Production-stack scope, automated UAT, weekly hour distribution, blackout period and the standing milestone-meeting record.

## Production stack explicitly included

- separate paid-plan Supabase Production project;
- governed schema/migrations and Layer 1 authoritative seed/re-ingestion;
- Supabase Auth/RBAC/session hardening;
- RLS/grants/views/RPC/`SECURITY DEFINER` security audit;
- private Evidence Storage and retention/monitoring controls;
- Vault/server-only vendor credentials;
- Layer 1 regulatory operations;
- Layer 2 deterministic enrichment and provider routing;
- Layer 3 governed AI interpretation;
- Layer 4 terminal human review;
- Admin/PIM Layer 1–4 operational UX;
- GitHub protected Production CI/CD with SHA-bound automated UAT;
- Cloudflare Production environment/origin/auth/WAF controls;
- backup/restore/DR exercise;
- monitoring, alerting, troubleshooting and management reporting;
- consumer API/Zoho integration;
- Search/publication governance and final Production handover.

## Affected surfaces / related workstreams

- 00-governance-programme — programme sequencing, milestone meetings and hour envelope;
- 30-admin-pim-ux — Layer 1/2/3 menu and workspace maturity;
- 40-layer2-enrichment — broad enrichment, provider routing and evidence economics;
- 50-search-api-consumers — later M3/M4 consumer/Search/publication gates;
- 70-security-platform — Production Auth/RBAC, exposed RPCs, secrets, backups and isolation;
- 80-uat-release-operations — Production deployment, automated UAT, monitoring, restore and handover.

## Current security finding carried forward

A 25 August 2026 Supabase Security Advisor review reports two externally facing WARN items requiring Production disposition:

1. leaked password protection disabled — mandatory Production gate under `CF-CHG-20260823-022`;
2. `public.layer2_ops_policy_update(...)` is `SECURITY DEFINER` and executable by `authenticated`.

The Layer 2 mutation function performs an `auth.uid()` actor match and server-side minimum role-rank check before updating policy rows. It is not treated as a demonstrated privilege bypass, but M2.2 must independently threat-model it, minimise the exposed contract, verify grants/search_path and either preserve it with explicit accepted rationale/UAT or replace it with a narrower mutation boundary.

## Evidence capacity baseline

Measured Pilot Storage on 25 August 2026:

- Evidence objects: 1,583;
- Evidence bytes: 1,793,315,334 bytes (~1.67 GiB);
- current Layer 2 v2 Native + Normalised samples consume roughly 0.8 MiB per successful Course-page acquisition pair.

Budget 45–60 GiB for the initial broad enrichment pass. Repeated retained full-catalogue snapshots require dedupe, lifecycle and source-specific cadence controls.

## Expense baseline

Supabase Pro upgrade from 25 August 2026 is recorded as an M2.1 platform expense. Amount remains actual supplier invoice/receipt value rather than an inferred AUD amount.

Firecrawl or other paid scraper subscriptions are future project expenses only when actually purchased/approved.

## UAT / evidence

M2.1 final deployed browser acceptance remains bound to:

- Pilot SHA `cba0e9ecd2f4878bfd51ad5278e60046b1fae581`;
- GitHub Actions deployed UAT run `32795496640`;
- desktop job `97645884152` — PASS;
- mobile job `97645884483` — PASS;
- desktop artifact `9544813710`, SHA-256 digest `663e5f6c9a2c8f43f8ac5196399104e0c0bc9a2e08560738d657489f60bfba34`;
- mobile artifact `9544904988`, SHA-256 digest `5a4ff270f8abfd233b7fec67d9a516eefd5111b636899b30bbfe95376d85a433`.

Future M2.2–M4 gates must use the milestone governance standard and automated UAT matrix.

## Blackout

**16 September through 30 September 2026 inclusive: no planned implementation, deployment, UAT or project delivery. Planned engineering hours: 0.**

Emergency work requires separate explicit authorisation and time recording.

## Rollback

This change is programme/governance/documentation only. Rollback is reversion to the prior master plan and removal of the detailed delivery-plan document. It does not itself mutate canonical data, Search, Publication or runtime schema.

## Closure

**Current status:** APPLIED — authoritative M2 delivery/Production/hour baseline established.  
**Next technical gate:** M2.2 — Security & Production Foundation.  
**Next milestone-meeting source:** `docs/coursefinder-m2-production-delivery-plan-tsow-v1.0.md`.
