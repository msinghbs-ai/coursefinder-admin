# CourseFinder Master Project Plan v1.66

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE — M1 FROZEN / M2.1 CLOSED / M2.2 NEXT  
**Date:** 25 August 2026  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.65.md`  
**Change Control:** `CF-CHG-20260825-031`

## Programme position

Milestone 1 remains complete/frozen for the governed Pilot baseline.

M2.1 — Layer 2 Platform is now **CLOSED / PASS** after deployed authenticated desktop/mobile UAT on Pilot SHA `cba0e9ecd2f4878bfd51ad5278e60046b1fae581`, GitHub Actions run `32795496640`.

M2.1 establishes Layer 2 as an accepted deterministic platform capability. It does not imply Production readiness, Layer 3 autonomous authority, broad Search publication or consumer cutover.

## Current authoritative milestone sequence

| Milestone | Status | Target | Principal outcome |
|---|---|---|---|
| M1 | CLOSED / PASS / FROZEN | completed 23 Aug 2026 | governed Pilot baseline |
| M2.1 — L2-PLATFORM | **CLOSED / PASS** | completed 25 Aug 2026 | deterministic Course/Scholarship enrichment platform, provider abstraction, Evidence and safe apply |
| M2.2 — SECURITY-PROD-FOUNDATION | **NEXT** | 25 Aug–4 Sep 2026 | Production security/isolation/deployment/restore baseline |
| M2.3 — L2-SCALE-ENRICHMENT | PLANNED | 1–18 Sep 2026 | broad AU/NZ enrichment with controlled cost/storage and evidence economics |
| M2.4 — L3-AI-OPERATIONS | PLANNED | 7–25 Sep 2026 | governed AI interpretation of unresolved Evidence and safe Layer 4 fall-out |
| M2.5 — PROD-READINESS-CUTOVER | PLANNED | 21 Sep–2 Oct 2026 | clean Production environment acceptance and operating handover |

Detailed review: `docs/coursefinder-milestone-2-consolidated-review-v1.0.md`.

## M2.1 accepted capability

- versioned Layer 2 Source Profiles;
- Direct HTTP and governed acquisition-provider routing;
- Vault-only provider credentials;
- Provider Attempt provenance;
- private Native/Normalised Evidence;
- deterministic Course extraction with identity/fee safety guards;
- deterministic candidate apply without Search/publication side-effect;
- completeness measurement and controlled `not_yet_enriched` state;
- real Federation completeness uplift from 37.5% to 92.5% average;
- Scholarship listing→detail extraction proof;
- measured Layer 2→Layer 3 fall-out;
- management-oriented Layer 2 Operations workspace;
- deployed desktop/mobile UAT PASS.

## M2.2 entry criteria and mandatory security work

M2.2 begins from the accepted M2.1 runtime but must not treat Pilot controls as Production approval.

Mandatory tasks:

1. define clean Production environment and trust boundaries;
2. use paid Supabase plan for Production;
3. enable leaked-password protection before Production sign-off;
4. decide privileged MFA/session policy and execute negative RBAC UAT;
5. inventory and review every browser-executable RPC and `SECURITY DEFINER` function;
6. independently disposition `public.layer2_ops_policy_update(...)`;
7. verify exposed schema grants/RLS/view semantics;
8. verify private Storage and signed Evidence access;
9. separate Production/Pilot credentials and CI/CD environments;
10. define backup/PITR decision, RPO/RTO and perform restore test;
11. establish Production Cloudflare deployment and origin/auth isolation;
12. define monitoring/log-retention strategy and incident workflow;
13. run database/API/security/storage/desktop/mobile release UAT;
14. record rollback and final Production gate.

Production Build & Operations Guide: `docs/coursefinder-production-environment-build-operations-guide-v1.0.md`.

## Layer 1–3 Admin maturity target

The Admin IA is now expected to mature beyond the M2.1 Layer 2-only management workspace.

Primary operational surfaces become:

- Layer 1 — Regulatory;
- Layer 2 — Enrichment;
- Layer 3 — AI Interpretation;
- cross-layer Evidence;
- Layer 4 Review Queue remains terminal human resolution.

Each Layer workspace must expose scorecard, queue, detail/evidence drill-through, health, cost/volume where relevant and next action without requiring schema knowledge.

Current IA target: `docs/coursefinder-admin-navigation-information-architecture-v1.3.md`.

## Layer 2 acquisition commercial baseline

Initial recommendation for the scale-out milestone:

- Direct HTTP remains first route where sufficient;
- subscribe to **Firecrawl Standard** as the initial paid richer-Evidence provider;
- keep Scrape.do/ZenRows as governed fallbacks until measured per-domain usage justifies a paid secondary tier;
- do not purchase multiple high-volume subscriptions before factual-resolution/cost telemetry proves need.

## Evidence capacity baseline

Measured Pilot on 25 Aug 2026:

- 1,583 Evidence objects;
- 1,793,315,334 bytes (~1.67 GiB);
- current Layer 2 v2 Native+Normalised sample implies roughly 0.8 MiB per successful Course page pair.

Plan 45–60 GiB for the first broad enrichment pass over the existing 43,461-Course catalogue including discovery/retry/Scholarship headroom.

Supabase Pro currently includes 100 GB file storage. A first broad pass is therefore feasible, but repeated retained full-catalogue snapshots require dedupe, source-specific cadence and retention/tiering controls.

## Guide baseline

Existing maintained guides remain valid for their accepted semantics and are extended by:

- `docs/coursefinder-pim-admin-guide-m2-layer-operations-addendum-v1.0.md`;
- `docs/coursefinder-operations-runbook-m2-production-addendum-v1.0.md`;
- `docs/coursefinder-production-environment-build-operations-guide-v1.0.md`;
- `docs/coursefinder-milestone-governance-standard-v1.0.md`.

## Security-first programme rule

Security is the primary acceptance gate for all future milestones.

No milestone may be called PASS with:

- unexplained Critical/High security findings;
- untested privileged mutation boundaries;
- secrets exposed to browser/client/logs;
- unverified Production restore path;
- an unbounded publication consequence;
- missing automated negative-authorisation tests where roles/privileges changed.

## Publication boundary

M2.1 closure does not alter the frozen publication state. Broad catalogue publication and Production website/Zoho cutover remain separate explicit gates.

## Next authoritative gate

**M2.2 — SECURITY-PROD-FOUNDATION.**

Use `docs/coursefinder-milestone-governance-standard-v1.0.md` as the mandatory structure for M2.2 and all later milestone review meetings.
