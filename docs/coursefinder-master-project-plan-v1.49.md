# CourseFinder Master Project Plan v1.49

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.48.md`  
**Last consolidated:** 20 August 2026 13:26 AEST (UTC+10)  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Running build:** `docs/coursefinder-running-build-v2.53.md`

## Current programme position

The accepted AU Layer 1, Layer 2, Search-isolation and existing Admin/PIM-hardening baselines remain unchanged.

Current `M1-PIM-GOV` semantic gates:

| Change | State |
|---|---|
| `CF-CHG-001` Fee semantics | Technical/frontend source PASS through v2.8; deployed browser UAT pending |
| `CF-CHG-005` QILT/PRISMS | Technical/frontend source PASS through v2.8; deployed browser UAT pending |
| `CF-CHG-006` Evidence provenance | Technical/frontend source PASS through v2.8; deployed browser UAT pending |
| `CF-CHG-007` Catalogue paging/exact identity | Technical/frontend source PASS through v2.8; deployed browser UAT pending |
| `CF-CHG-008` Provider/Course/Campus geography | Technical/frontend source PASS through v2.8; deployed browser UAT pending |
| `CF-CHG-009` Intake/English | Technical/frontend source PASS through v2.8; deployed browser UAT pending |
| `CF-CHG-010` Taxonomy lineage | Technical/frontend source PASS through v2.8; deployed browser UAT pending |
| `CF-CHG-011` Scholarship compound semantics | DB/RPC/security + frontend source PASS in v2.8; deployed browser UAT pending |

## Scholarship semantic decision

The canonical relational Scholarship model is accepted. The Admin and downstream consumer contracts must preserve its relationships rather than flattening them.

A Scholarship cycle can own multiple:

- Application Windows;
- explicit Scopes;
- eligibility groups/criteria;
- Award Tiers;
- Coverage/benefits.

Eligibility group parentage and conjunction are business logic. A flat criterion list is semantically unsafe.

### Logic rules

- `all` groups preserve conjunction across governed requirements/child groups;
- `any` groups preserve alternatives under their parent logic;
- `machine_evaluable=false` is a review/evaluation characteristic, not ineligibility;
- no Scope rows is absence of structured Scope rows, not universal applicability.

## Australia Awards reference

The current 2027 cycle proves the compound model:

- 2 Application Windows;
- root General eligibility group = mandatory `all` with 7 direct criteria;
- child Participating-country pathway = mandatory `any` with 2 direct criteria;
- 9 Coverage components;
- no structured Scope rows.

The Admin/Zoho contracts must retain this hierarchy.

## RMIT Scholarship reference

RMIT David Phillips Memorial Scholarship proves a different shape:

- recurring cycle;
- source-only closing text rather than exact window dates;
- Provider include Scope resolved to RMIT University (RMIT);
- AUD 5,000 annual Award Tier;
- one eligibility group.

The source text `Mid September each year - check website for exact dates` must not be converted into a fabricated precise date.

## Governed read/security

Pilot migration:

`m1_pim_gov_scholarship_semantics_v1`

Repository mirror:

`supabase/production-migrations/065_m1_pim_gov_scholarship_semantics.sql`

The browser contract is:

`public.admin_read('scholarship_detail')` → role-checked `security.admin_scholarship_semantic_summary(uuid)`.

Direct authenticated execution of legacy `public.ui_scholarship_detail(uuid)` is removed.

## PIM Admin v2.8.0

The Scholarship detail is now organised by semantic grain:

- Scholarship provenance;
- Offering Cycles;
- Application Windows;
- Applicability Scopes;
- recursive Eligibility Logic;
- Criteria;
- Award Tiers;
- Coverage / benefits;
- exception-first unscoped observations.

This retains v2.7 Course semantics and prior QILT/PRISMS/Evidence/catalogue functionality.

## Governance contracts

Current:

- PIM Admin Guide v1.4;
- Zoho Consumer Contract v1.2;
- v2.8 Scholarship UAT;
- central Change Control register through `CF-CHG-011`.

Zoho v1.2 defines a relational child-object design for Scholarship cycles/windows/scopes/groups/criteria/tiers/coverage. It explicitly blocks flat eligibility Boolean/text representations and universal-scope inference.

## Consumer boundary

Admin representation does not grant Search, Website or Zoho publication.

Scholarship consumer admission must prove that:

- temporal cycle/window cardinality is retained;
- scope include/exclude is retained;
- empty Scope is not interpreted as universal;
- eligibility parentage/conjunction is lossless;
- Award Tier and Coverage stay separate;
- evidence exposure is appropriate;
- versioning/backward compatibility is defined.

## Preserved programme baselines

- AU CRICOS: 1,546 Providers / 26,648 active Courses;
- Layer 1 adapter: `layer1-au-depth-v1.6.0`;
- AU Course Facts: RMIT + UQ / 10 bounded Courses;
- QUT: deferred/source-specific HTTP 403;
- QILT/PRISMS accepted state unchanged;
- Search Course Documents: 33,105;
- fee/intake/English Search enrichment admitted: 0;
- vector Search remains rejected/not admitted.

## Remaining acceptance boundary

The current environment cannot independently observe the Cloudflare runtime. Source publication is not deployment proof. Open PIM semantic Change Controls close only after their deployed authenticated browser acceptance criteria pass.

## Next M1-PIM-GOV work

1. final branch/main reconciliation and non-force publication of PIM Admin v2.8.0;
2. deployed browser UAT when runtime observation is available;
3. semantic audit of lifecycle, publication, completeness/readiness and Search state as a coordinated model;
4. continue curated Zoho contract work without automatically admitting internal/Admin fields;
5. create a new Change Control only where a material semantic or security defect is proven.

Database Architecture remains v2.10.37 because the canonical relational model did not change.
