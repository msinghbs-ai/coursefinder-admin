# CourseFinder Master Project Plan v1.70

**Issued:** 25 August 2026  
**Status:** CURRENT  
**Supersedes:** v1.69  
**Programme Change Controls:** CF-CHG-20260825-032 CLOSED/PASS; CF-CHG-20260825-036 M2.3 ACTIVE / EXPANDED

## 1. Programme position

M1 remains frozen. M2.1 and M2.2 are CLOSED/PASS. M2.3 remains active and is expanded into the **production-grade Data Operations maturity gate** for Layer 1 and Layer 2 plus governed Scholarship decision support and Course contextual intelligence.

The separate Production environment remains M2.5. Calling Layer 1 “production-grade” means accepted, operational, source-vetted and Production-quality in behaviour; it does not rename/promote the Pilot project or spend M2.5 deployment authority.

No additional billable hours are inferred by this scope revision. The existing engagement-time record remains authoritative.

## 2. Authority model

`Layer 1 Authoritative / Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

Layer 4 remains terminal. Search Projection, Search Visibility and Publication remain downstream product states.

## 3. Current milestone sequence

| Milestone | Status | Planned hours baseline | Outcome / current focus |
|---|---|---:|---|
| M2.0 | COMPLETE | 8 | programme consolidation / Auto-UAT |
| M2.1 | CLOSED / PASS | 3 | Layer 2 platform foundation |
| M2.2 | CLOSED / PASS | 10 | Security & Production foundation + bounded deterministic Search showcase |
| **M2.3** | **ACTIVE / EXPANDED** | **12 baseline** | production-grade Layer 1; Layer 2 scale; unified Data Operations UX; Scholarship Selection; Course contextual intelligence; guides/UAT |
| M2.4 | PLANNED | 7 | governed Layer 3 AI Operations / pre-blackout gate |
| Blackout 16–30 Sep | NO DELIVERY | 0 | no planned project delivery |
| M2.5 | PLANNED | 12 | clean Production stack deployment/restore/security acceptance |
| M3 | PLANNED | 10 | consumer API / Zoho integration |
| M4 | PLANNED | 8 | Search/publication/final Production handover |

## 4. M2.3 consolidated objective

M2.3 must deliver a coherent operating platform rather than isolated pipeline screens:

1. make accepted Layer 1 regulatory ingestion production-grade and non-experimental;
2. validate and centrally govern source-specific batch/concurrency/rate/retry/resume limits across regulatory Providers/Courses and accepted sources;
3. mature Layer 2 scale batching, provider economics, retry/resume, Evidence lifecycle and AU/NZ deterministic enrichment;
4. unify the Layer 1 → Layer 4 journey under one Data Operations parent menu;
5. remove redundant navigation and dead-end technical pages;
6. provide Course detail contextual QILT/PRISMS signals where source grain genuinely applies;
7. create a transparent Scholarship Selection mini-app for University/Course/Scholarship decision support;
8. issue role-based Admin/User Guides with screen mock-ups/representative screenshots and quick tours;
9. prove all implemented scope through automated database/API/security/storage/browser/performance/replay UAT.

## 5. Production-grade Layer 1 acceptance

Every accepted regulatory source must have an evidenced operational policy covering, where applicable:

- authority/source identity;
- source-native pagination/batch limits;
- CourseFinder batch-size cap;
- concurrency;
- requests/rate window;
- timeout;
- retries/backoff;
- resume cursor/checkpoint;
- maximum safe run window;
- freshness SLA;
- idempotent replay behaviour;
- identity/count/hash invariants;
- failure/rollback recovery;
- current status: READY / CONDITIONAL / BLOCKED.

Source policy should be centrally visible/configured rather than hidden in worker constants wherever practical.

## 6. Unified Data Operations IA target

**Data Operations** becomes the parent operational workspace with:

- Overview;
- Layer 1 — Regulatory;
- Layer 2 — Enrichment;
- Layer 3 — AI Interpretation (readiness/handoff until M2.4);
- Layer 4 — Human Resolution;
- Evidence & Provenance;
- Jobs / Runs.

The UX must show the end-to-end data journey and use drill-down rather than duplicated top-level menu entries.

Recommended broader Admin navigation target:

- Dashboard;
- Catalogue / PIM;
- Data Operations;
- Data Quality;
- Scholarship Selection;
- Search / Publication where authorised;
- Administration / Settings;
- Help / Guides.

## 7. Scholarship Selection

Build a decision-support mini-app that combines governed Provider, Course and Scholarship facts and supports explicit filter/ranking criteria such as study destination, Provider, field/Course, level, tuition, Scholarship value/type, eligibility constraints where supported, intake/cycle and closing date.

Rules:

- ranking logic and weights must be inspectable;
- every result must explain why it matched/ranked;
- missing/unresolved data must reduce confidence rather than be treated as zero;
- no fabricated eligibility/value/fact;
- source Evidence must be reachable;
- do not claim universal “best University” status;
- remain outside admissions/application/offer/visa workflow authority.

## 8. Course detail contextual intelligence

Course detail should consolidate, where applicable:

- canonical/regulatory facts;
- Provider-current Layer 2 facts;
- CRICOS regulatory fee semantics separately from Provider-current annual tuition;
- QILT contextual outcomes with source grain/reporting period;
- PRISMS contextual student-flow/provider/course signals only where accepted mapping genuinely applies;
- relevant Scholarship links/coverage;
- Evidence/provenance/freshness;
- completeness/unresolved state;
- Search/publication state.

Provider-level QILT/PRISMS signals must not be represented as unsupported Course-level facts.

## 9. Documentation and role quick tours

Maintain deployed-state guides for Platform Admin, PIM/Data Administrator, Reviewer, Counsellor/decision-support user and Integration/operations support.

Each guide path should include page purpose, recommended sequence, screen mock-ups or representative screenshots, semantic traps, batch/retry guidance and links across Data Operations, Evidence, Course detail and Scholarship Selection.

## 10. M2.3 inherited/runtime evidence

- M2.2 CLOSED/PASS on Pilot SHA `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`.
- First real M2.3 UQ batch: 3/3 Layer 2 resolved after one bounded retry, 3 vendor units, USD 0 vendor cost.
- Modern Evidence dedupe/idempotent replay and capacity controls are implemented.
- Paid Firecrawl entitlement/cost authority remains unverified and cannot be used implicitly.
- NZ first-party Layer 2 Course-detail profile coverage requires qualification/implementation.

## 11. Acceptance gate

M2.3 closes only when production-grade Layer 1 source policies, representative/broad Layer 2 scale, unified Data Operations UX, contextual Course detail, Scholarship Selection, role guides and consolidated automated UAT pass or any residual item is explicitly BLOCKED/DEFERRED with evidence.

M2.3 does not grant separate Production deployment, Layer 3 execution authority, broad Publication, Zoho cutover or final Production handover.
