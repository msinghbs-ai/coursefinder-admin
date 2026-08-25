# CourseFinder Master Project Plan v1.68

**Issued:** 25 August 2026  
**Status:** CURRENT  
**Supersedes:** v1.67  
**Programme Change Control:** CF-CHG-20260825-032

## 1. Baseline rule

This version preserves every accepted scope, milestone authority boundary, technical dependency, blackout period and confirmed-hour rule from v1.67 except where this document explicitly changes M2.2 sequencing for the Friday 28 August 2026 showcase objective.

M1 remains frozen. M2.1 remains CLOSED/PASS. No M2.2 acceleration grants broad Publication, Production website exposure, Zoho cutover or final Production handover authority.

## 2. Authority model

`Layer 1 Authoritative / Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

Layer 4 remains terminal. Search Projection, Search Visibility and Publication remain downstream product states.

## 3. Current milestone sequence

| Milestone | Window / status | Planned hours baseline | v1.68 scope/status |
|---|---|---:|---|
| M2.0 | COMPLETE | 8 | milestone planning, consolidation, automated-UAT operating model |
| M2.1 | CLOSED / PASS | 3 | accepted Layer 2 platform foundation; inherited unchanged |
| **M2.2** | 26 Aug–4 Sep / ACTIVE EARLY | **10 baseline hours** | Security & Production Foundation **plus governed Friday Search/showcase acceleration** |
| M2.3 | planned | 12 | retains later authority; scope not silently absorbed by M2.2 |
| M2.4 | planned | 7 | retains later authority |
| Blackout | 16–30 Sep | 0 | no planned engineering work |
| M2.5 | planned | 12 | clean Production establishment/cutover gate, including restore evidence as applicable |
| M3 | planned | 10 | consumer/API/Zoho integration authority remains here unless future CC changes it |
| M4 | planned | 8 | Search/publication/final Production handover authority remains here unless future CC changes it |

The v1.67 programme baseline recorded **11 confirmed hours through 25 August 2026** and **59 remaining planned hours**. v1.68 does not fabricate or retrospectively allocate new billable hours. Search/showcase technical acceleration is tracked as scope/task status independently from confirmed engagement time. Any estimate change requires explicit time/TSOW reconciliation.

## 4. M2.2 consolidated objective

M2.2 now combines:

1. Production/security foundation maturity;
2. Supabase Pro entitlement and security-control re-evaluation;
3. Production trust/recovery/release architecture;
4. bounded Search/pgvector technical acceleration;
5. website-developer Search/read contract preparation;
6. showcase-level Admin/PIM maturity using accepted implemented capability;
7. complete automated UAT for implemented scope;
8. current governance/task/evidence records.

## 5. M2.2 task plan

| ID | Task | Status | Gate / evidence |
|---|---|---|---|
| M2.2-01 | reconcile governance/runtime/parallel CC state | COMPLETE | CF-CHG-032/033/034/035 |
| M2.2-02 | verify Supabase Pro live entitlement | PASS | org plan `pro` |
| M2.2-03 | re-evaluate Free-tier Auth/security deferrals | IN PROGRESS / BLOCKED item | leaked-password remains disabled |
| M2.2-04 | current RPC/SECURITY DEFINER/grant/RLS inventory | IN PROGRESS | direct Layer 2 RPC issue remediated; Search gate RLS WARN retained |
| M2.2-05 | harden Layer 2 privileged policy mutation | PASS implementation/security regression | Edge v3 + EXECUTE revoke |
| M2.2-06 | confirm Pilot/Production trust architecture | COMPLETE design | M2.2 architecture v1.0 |
| M2.2-07 | define Production CI/CD separation | COMPLETE design / implementation later gate | clean Production + protected env required |
| M2.2-08 | define Pro backup/PITR/RPO/RTO/restore gate | COMPLETE design / restore DEFERRED | Production restore executes after clean project exists |
| M2.2-09 | reconcile current Search Projection | PASS | 33,105 docs; generation 22 |
| M2.2-10 | implement bounded exact Search preview | IMPLEMENTED / PERF UAT ACTIVE | service-only lookup v1 |
| M2.2-11 | implement bounded FTS/filter preview | IMPLEMENTED / PERF UAT ACTIVE | service-only Search preview v1 |
| M2.2-12 | benchmark FTS/query plans | PARTIAL PASS | direct AU FTS ~18 ms; wrapper optimisation active |
| M2.2-13 | evaluate pgvector runtime/corpus/profile | COMPLETE decision | candidate only; 0 embeddings/models |
| M2.2-14 | vector/hybrid relevance benchmark | DEFERRED / NOT ACCEPTED | no governed embedding model/profile/corpus |
| M2.2-15 | website developer read contract | COMPLETE | contract v1.0 |
| M2.2-16 | representative showcase cohort | COMPLETE | real UQ/RMIT examples; no fabricated facts |
| M2.2-17 | deployed desktop/mobile regression | IN PROGRESS | current SHA automated workflow |
| M2.2-18 | milestone meeting record | COMPLETE / live-update required | 28 Aug record |
| M2.2-19 | final consolidated M2.2 acceptance | BLOCKED pending controls/UAT | cannot PASS while material Auth/UAT items remain |

## 6. Friday 28 August showcase gate

The Friday milestone can defensibly demonstrate:

- M2.1 Layer 2 lifecycle and Evidence/provenance;
- current AU/NZ canonical/Search corpus;
- real Provider-current tuition/Intake/English examples;
- factual completeness and safe unresolved behaviour;
- Supabase Pro entitlement and security hardening progress;
- Production trust model;
- deterministic exact Search + FTS/filter design/read contract;
- measured pgvector decision: available infrastructure, not falsely accepted;
- website-developer request/DTO/security/versioning discussion;
- explicit current Publication limitation.

A Friday showcase READY state does not equal M2.2 PASS if security/UAT blockers remain.

## 7. Search sequencing change

M2.2 may implement and UAT a **bounded Pilot/server-side read preview** and developer contract ahead of M3/M4. It may not:

- enable broad public Publication;
- expose service-role secrets to browser code;
- make raw Search/Catalogue tables the website contract;
- authorise final Production website traffic;
- establish Zoho cutover authority;
- treat vector/hybrid as accepted without the benchmark.

## 8. Supabase Pro change

The former Free-plan constraint is retired as a programme assumption. Pro entitlement is confirmed. Controls formerly deferred **only** because of Free must now be re-evaluated individually. Current leaked-password protection remains disabled and blocks full M2.2 security PASS until enabled/verified or the programme explicitly changes the acceptance requirement.

Supabase Pro subscription is a project expense and is not engineering time. The actual billing amount must be sourced from the billing record, not estimated here.

## 9. Recovery boundary

M2.2 defines the Production recovery design. The clean Production project is still established later. An executed Production restore test is therefore retained for the accepted Production establishment/release gate; M2.2 must not claim DR PASS without it.

## 10. Current overall status

**M2.2: ACTIVE / BLOCKED FROM PASS, SHOWCASE PREPARATION SUBSTANTIALLY READY.**

Primary blockers/remaining gates:

- leaked-password protection remains disabled;
- final deployed desktop/mobile UAT must complete against final Pilot SHA;
- Search preview wrapper performance needs optimisation or explicit bounded non-acceptance;
- vector/hybrid remains deferred until a governed embedding profile exists;
- later Production environment/recovery/consumer/publication authorities remain intentionally unspent.
