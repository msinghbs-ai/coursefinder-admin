# CourseFinder M2 → Production Delivery Plan / TSOW v1.1

**Issued:** 25 August 2026  
**Status:** CURRENT  
**Supersedes:** v1.0  
**Programme baseline:** Master Project Plan v1.68  
**Change Control:** CF-CHG-20260825-032

## 1. Purpose

v1.1 preserves the accepted M2→Production delivery structure and milestone authority boundaries while adding the governed M2.2 Friday 28 August Search/showcase acceleration and Supabase Pro security re-evaluation.

No technical task status in this TSOW is an automatic billable-time entry.

## 2. Time baseline

The prior accepted programme record confirms **11 engagement hours through 25 August 2026** and **59 remaining planned hours**. Those figures are retained until separately reconciled from confirmed time entries.

M2.2 retains the prior **10-hour baseline allocation** for planning purposes. The added acceleration increases technical scope/sequence but does not fabricate extra confirmed hours. If actual M2.2 effort exceeds the accepted baseline, record the variance only when the engagement time is confirmed.

Supabase Pro is an expense, not engineering time.

## 3. M2.2 detailed technical scope

| Work package | Deliverable / acceptance evidence | Current state |
|---|---|---|
| Governance reconciliation | current CC/register/plan/runtime/architecture reconciled | COMPLETE |
| Supabase Pro reconciliation | live plan/region/project state verified; former Free constraints reviewed | PARTIAL PASS; leaked-password remains blocked |
| Auth/RBAC/RPC hardening | privileged mutations server-enforced; negative authorisation evidence | IN PROGRESS; Layer 2 direct RPC remediation PASS |
| RLS/schema/grant security | current effective browser/service boundaries inventoried | IN PROGRESS; Search gate RLS WARN retained |
| Storage/Vault/Edge security | private Evidence/secret boundaries and endpoint auth dispositions | IN PROGRESS |
| Production trust architecture | clean Pilot/Production separation, region, secrets, Auth, Storage | DESIGN PASS |
| Production CI/CD architecture | protected Production environment, scoped secrets, SHA/UAT promotion | DESIGN PASS; implementation depends on later Production environment |
| Recovery architecture | Pro backup/PITR decision framework, RPO/RTO, restore procedure/evidence | DESIGN PASS; Production restore DEFERRED to establishment gate |
| Search Projection reconciliation | current AU/NZ projection/version/hash/coverage | PASS |
| Exact Search preview | stable code/ID lookup contract, private/server boundary | IMPLEMENTED / performance UAT active |
| FTS/filter Search preview | query + country/provider/level/field/location/tuition/Intake/English/Scholarship filters | IMPLEMENTED / performance UAT active |
| pgvector evaluation | extension/corpus/model/profile/index readiness measured | COMPLETE decision: candidate only |
| Vector/hybrid relevance benchmark | FTS vs vector vs hybrid with reproducible embedding profile | DEFERRED because no governed embedding profile/corpus exists |
| Website developer contract | request/filter/pagination/DTO/errors/auth/versioning/browser/server rules | COMPLETE |
| Showcase cohort | real accepted AU/NZ examples with provenance/unresolved behaviour | COMPLETE |
| Admin/showcase regression | desktop/mobile deployed browser regression on final SHA | IN PROGRESS |
| Consolidated UAT/evidence | security/Search/database/browser regression evidence | IN PROGRESS |
| Milestone meeting record | Friday objective/status/refs/UAT/risks/costs/hours/next gate | COMPLETE draft / live update required |

## 4. Explicitly retained later scope

The following are **not silently absorbed by M2.2**:

- clean Production Supabase project establishment/cutover;
- final Production Storage/Vault/Auth credential authority;
- executed Production restore acceptance;
- broad website Publication or anonymous consumer access;
- final consumer/API exposure model;
- Zoho cutover;
- final Production Search/publication handover;
- final vector/hybrid acceptance if a future embedding profile is introduced.

These retain their later programme gates unless a future approved programme Change Control changes them.

## 5. Friday showcase deliverable

The meeting-ready demonstration should show one coherent operational story:

1. accepted M2.1 Layer 2 lifecycle;
2. real Source/Profile → Provider Attempt → Evidence → canonical/unresolved outcome;
3. current AU/NZ Catalogue/Search state;
4. Provider-current enrichment and completeness uplift;
5. Evidence/provenance;
6. Production/Supabase Pro security progression;
7. Search Projection/version/hash/publication state;
8. exact + deterministic FTS/filter behaviour using real records;
9. pgvector evidence and decision, without claiming a vector PASS;
10. website developer DTO/request/security contract;
11. next path to clean Production and final consumer release.

## 6. Current risks/blockers

- leaked-password protection remains disabled despite Pro entitlement;
- rich Search preview wrapper latency remains above the direct indexed query path and is not yet a Production performance PASS;
- no governed embedding provider/model/profile exists, so vector/hybrid relevance is not testable without inventing an unauthorised dependency;
- final deployed desktop/mobile UAT has not yet been reconciled to the latest Pilot SHA;
- Search gate tables without RLS remain a documented defence-in-depth item even though current browser roles have no Search schema/direct table access;
- Production release/recovery cannot close before the clean Production environment exists.

## 7. Acceptance rule

M2.2 closes only as PASS when its security and implemented-scope automated UAT gates pass. Otherwise it closes/hands over only as BLOCKED with evidence or explicitly DEFERRED for later-authority items. A successful Friday demonstration alone is not milestone acceptance.
