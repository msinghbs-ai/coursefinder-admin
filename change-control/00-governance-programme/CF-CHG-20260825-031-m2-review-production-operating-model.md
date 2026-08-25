# CF-CHG-20260825-031 — M2 Consolidated Review, Production Operating Model & Security-First Milestone Governance

**Status:** APPLIED — DOCUMENTATION / GOVERNANCE BASELINE  
**Category:** 00-governance-programme  
**Initiated:** 25 August 2026 11:24 AEST (+10:00)  
**Origin chat/workstream:** Milestone 2- REVIEW  
**Owner:** CourseFinder programme governance  
**Change class:** cross-cutting programme / production / operations / UI maturity governance

## Trigger

M2.1 has completed its final deployed browser acceptance and the programme is moving from Pilot-scale Layer 2 learning into production-grade Layer 1–3 operations. The Supabase Free-plan storage threshold has also been exceeded, requiring explicit capacity, vendor, operational and Production-environment planning.

The programme now needs one repeatable milestone-review format that can be recalled at every milestone meeting and that treats security, evidence, UAT, cost, operations and supportability as first-class acceptance gates.

## Decision

1. Close M2.1 only against the final SHA-bound deployed UAT evidence.
2. Treat Layer 2 as an accepted deterministic production capability, not an experiment. Provider trials remain a qualification/benchmark tool, not a statement that Layer 2 itself is experimental.
3. Mature Admin IA around explicit Layer 1, Layer 2 and Layer 3 operational workspaces while retaining Layer 4 as terminal human resolution.
4. Establish a Production build/operations guide before any Production project creation or data cutover.
5. Adopt a security-first milestone governance standard for every future milestone.
6. Use current measured Evidence growth to drive storage and retention planning rather than estimating from file-count alone.
7. Prefer Direct HTTP first; use a paid rendered acquisition provider only where outcome/evidence quality requires it. Firecrawl Standard is the initial recommended paid Layer 2 subscription for broad enrichment because the accepted M2.1 benchmark showed materially richer Evidence on ambiguous cases. Scrape.do remains a governed secondary/fallback provider until measured production volumes justify a paid fallback tier.

## Affected surfaces / related workstreams

- 30-admin-pim-ux — Layer 1/2/3 menu and workspace maturity;
- 40-layer2-enrichment — broad enrichment, provider routing, evidence economics;
- 70-security-platform — Production Auth/RBAC, exposed RPCs, secrets, backups, isolation;
- 80-uat-release-operations — Production build, operating runbook, monitoring, support and bug reporting;
- Search/publication remain downstream and are not implicitly authorised.

## Current security finding carried forward

A 25 August 2026 Supabase Security Advisor review reports two externally facing WARN items requiring Production disposition:

1. leaked password protection disabled — already a mandatory Production gate under `CF-CHG-20260823-022`;
2. `public.layer2_ops_policy_update(...)` is `SECURITY DEFINER` and executable by `authenticated`.

The Layer 2 mutation function currently performs an `auth.uid()` actor match and server-side minimum role-rank check before updating policy rows, so this is not treated as an immediate demonstrated privilege bypass. It is nevertheless a Production hardening item: independently threat-model it, minimise its exposed contract, verify grants/search_path, and either preserve it with explicit accepted rationale/UAT or replace it with a narrower mutation boundary.

## Evidence capacity baseline

Measured Pilot Storage on 25 August 2026:

- Evidence objects: 1,583;
- Evidence bytes: 1,793,315,334 bytes (~1.67 GiB);
- most existing capacity is regulatory-source Evidence;
- current Layer 2 v2 Native + Normalised samples consume roughly 0.8 MiB per successful Course-page acquisition pair.

Planning assumption for a one-pass 43,461-Course catalogue enrichment is approximately 35 GiB for Native + Normalised Course-page Evidence before discovery pages, retries, Scholarships and safety margin. Budget **45–60 GiB** for the initial broad enrichment pass. Do not use monthly full-snapshot retention without dedupe/lifecycle controls; a naïve monthly 12-cycle full refresh can exceed 400 GiB/year.

Supabase Pro currently includes 100 GB file storage; overage is billed per GB. Initial broad enrichment fits the included quota if evidence remains disciplined, but recurring retained snapshots require a formal retention/dedup/tiering policy.

## New maintained documents

- `docs/coursefinder-milestone-2-consolidated-review-v1.0.md`;
- `docs/coursefinder-production-environment-build-operations-guide-v1.0.md`;
- `docs/coursefinder-milestone-governance-standard-v1.0.md`;
- `docs/coursefinder-admin-navigation-information-architecture-v1.3.md`.

## UAT / evidence

M2.1 final deployed browser acceptance is bound to:

- Pilot SHA `cba0e9ecd2f4878bfd51ad5278e60046b1fae581`;
- GitHub Actions deployed UAT run `32795496640`;
- desktop job `97645884152` — PASS;
- mobile job `97645884483` — PASS;
- desktop artifact `9544813710`, SHA-256 digest `663e5f6c9a2c8f43f8ac5196399104e0c0bc9a2e08560738d657489f60bfba34`;
- mobile artifact `9544904988`, SHA-256 digest `5a4ff270f8abfd233b7fec67d9a516eefd5111b636899b30bbfe95376d85a433`.

## Rollback

This record introduces governance/documentation only. Rollback is reversion of the new documents and restoration of the previous navigation decision. It does not mutate canonical data, Search, Publication or deployed schema.

## Closure

**Current status:** APPLIED — documentation/governance baseline established.  
**Next gate:** M2.2 Security & Production Foundation acceptance.
