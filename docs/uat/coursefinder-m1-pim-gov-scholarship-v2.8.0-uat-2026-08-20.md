# CourseFinder M1-PIM-GOV Scholarship Semantic UAT — PIM Admin v2.8.0

**Date:** 20 August 2026  
**Executed:** 20 August 2026 13:26 AEST (UTC+10)  
**Change Control:** `CF-CHG-20260820-011`  
**Workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Frontend release:** `PIM Admin v2.8.0`  
**Repository:** `msinghbs-ai/coursefinder-admin`  
**Feature branch:** `m1-pim-gov-scholarship-semantics-v2-8-20260820`  
**Status:** **DB/RPC/SECURITY + FRONTEND SOURCE UAT PASS — DEPLOYED AUTHENTICATED BROWSER UAT PENDING**

## Purpose

Prove that Scholarship Admin semantics preserve the relational/time-scoped model rather than flattening Offering Cycles, Application Windows, Scopes, eligibility logic, Award Tiers, Coverage and evidence into disconnected fields.

## Defects proven before correction

- backend `ui_scholarship_detail` returned `cycles` and `windows`, while the frontend expected different keys and therefore did not provide the intended first-class cycle/window presentation;
- `criterion_groups` and `criteria` were separate raw tables, losing parent/child and `all` / `any` logical meaning;
- raw Scope UUIDs were not a safe Admin semantic representation;
- child provenance was not presented in the context of the child observation;
- future unscoped observations had no exception-first presentation;
- direct authenticated EXECUTE on legacy `public.ui_scholarship_detail(uuid)` was true.

## Applied backend contract

Pilot migration: `m1_pim_gov_scholarship_semantics_v1`  
Repository mirror: `supabase/production-migrations/065_m1_pim_gov_scholarship_semantics.sql`

The governed `semantic_summary` nests cycle-specific children under the correct Offering Cycle and keeps a separate `unscoped` bucket for `cycle_id=NULL` child observations.

## Authenticated reference UAT — Australia Awards Scholarships

Scholarship UUID: `95cbac08-2699-597b-a511-c9ca2161b540`.

Executed through `public.admin_read('scholarship_detail',...)` as Postgres role `authenticated` with assigned Platform Admin JWT subject.

| Assertion | Result |
|---|---:|
| Offering Cycles | 1 |
| Application Windows | 2 |
| Eligibility Groups | 2 |
| Top group conjunction | `all` |
| Child group conjunction | `any` |
| Child parent-group ID retained | PASS |
| Top-group direct criteria | 7 |
| Child-group direct criteria | 2 |
| Coverage components | 9 |
| Structured Scopes | 0 |
| Unscoped criteria | 0 |

**Verdict:** PASS.

The result proves the 9 criteria cannot be safely represented as one flat list because the participating-country group is an `any` child of a mandatory `all` group.

No structured Scope rows are loaded for Australia Awards. UAT explicitly does not infer universal Provider/Course scope from that absence.

## Authenticated reference UAT — RMIT David Phillips Memorial Scholarship

Scholarship UUID: `e9b61e99-5a67-5706-a533-df84dba16d80`.

| Assertion | Result |
|---|---|
| Offering Cycle | `recurring` |
| Application Windows | 1 |
| Exact window timestamps | not supplied |
| Source closing text | `Mid September each year - check website for exact dates` |
| Scope rows | 1 |
| Scope | include Provider |
| Resolved Provider | RMIT University (RMIT) |
| Award Tiers | 1 |
| Award value | AUD 5,000 |
| Award basis | annual |
| Eligibility Groups | 1 |

**Verdict:** PASS.

The source closing text is retained without manufacturing a September date.

## Security UAT

After the migration:

- `anon` EXECUTE on `security.admin_scholarship_semantic_summary(uuid)` = false;
- `authenticated` EXECUTE on the non-exposed helper = true so the invoker `admin_read` can dispatch;
- direct authenticated EXECUTE on `public.ui_scholarship_detail(uuid)` = false;
- authenticated EXECUTE on `public.admin_read(text,jsonb)` = true.

The helper is `SECURITY DEFINER`, uses a restricted search path and enforces assigned CourseFinder role via `security.current_role_rank()`.

**Verdict:** PASS.

## Frontend source UAT — PIM Admin v2.8.0

Initial feature-branch comparison against v2.7 base `1e5c8dbb59f7e06fe3aff03ae71a5fdfb0c60082` showed:

- branch ahead 3 / behind 0;
- `src/ScholarshipSemanticDetail.jsx` — added;
- `src/main.jsx` — 3 additions / 2 deletions only;
- `package.json` — one version-line change.

`main.jsx` changes are limited to:

- import `ScholarshipSemanticDetail`;
- visible `UI_VERSION='2.8.0'`;
- route Scholarship detail to the semantic component.

The component source explicitly contains:

- Offering Cycles;
- Application Windows;
- Applicability Scopes;
- recursive Eligibility Logic;
- `ALL of the following` / `ANY of the following` labels;
- Criterion mandatory/machine-evaluable/confidence context;
- Award Tiers;
- Coverage / benefits;
- source closing text preservation;
- no-scope warning that absence does not imply universal applicability;
- Needs Attention for Scholarship-level/unscoped observations;
- child source/evidence drill-down.

**Frontend source semantic verdict:** PASS.

## Build/runtime limitation

The current execution container does not have a reliable external DNS path for an independent Vite dependency/bootstrap build. A GitHub source publication is also not proof that the externally integrated Cloudflare Worker has deployed the release.

Accordingly this UAT does **not** claim independent clean-bundle or deployed-browser PASS.

## Deployed browser UAT required for closure

1. visible `PIM Admin v2.8.0`;
2. open Australia Awards Scholarships and confirm one 2027 Offering Cycle and two distinct Application Windows;
3. confirm General eligibility displays **ALL of the following**;
4. confirm Participating-country pathway is nested and displays **ANY of the following**;
5. confirm 7 + 2 criteria remain attached to the correct groups;
6. confirm nine Coverage/benefit rows remain separate;
7. confirm no structured Scope state is presented as absence, not universal applicability;
8. open RMIT David Phillips Memorial Scholarship and confirm provider include-scope resolves to RMIT University (RMIT);
9. confirm `Mid September each year - check website for exact dates` is visible without an invented date;
10. confirm AUD 5,000 / annual Award Tier;
11. confirm source/evidence drill-down is reachable on cycle and children;
12. regression-check v2.7 Course detail, QILT/PRISMS, Evidence and full-catalogue paging.

## Final verdict

**Canonical Scholarship model:** unchanged / accepted  
**DB/RPC semantic contract:** PASS  
**Authenticated ACL/security:** PASS  
**Frontend source semantics:** PASS  
**Consumer admission:** unchanged / not granted  
**Deployed authenticated browser UAT:** PENDING
