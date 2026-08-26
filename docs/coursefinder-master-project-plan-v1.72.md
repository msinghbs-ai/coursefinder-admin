# CourseFinder Master Project Plan v1.72

**Issued:** 26 August 2026  
**Status:** CURRENT  
**Supersedes:** v1.71  
**Programme Change Controls:** CF-CHG-20260825-036 CLOSED/PASS with NZ L2 deferral; CF-CHG-20260825-037 CLOSED/PASS; CF-CHG-20260825-038 CLOSED/PASS

## 1. Programme position

M1 remains frozen. M2.1 and M2.2 are CLOSED/PASS. **M2.3 is now CLOSED/PASS for its accepted Pilot/UAT scope**, with NZ first-party Layer 2 Course enrichment explicitly deferred to future NZ source qualification/onboarding.

M2.4 is therefore unblocked but remains not started. The separate Production environment remains M2.5. Broad Publication and Zoho cutover remain later governed gates.

No additional billable hours are inferred by this status transition; the engagement-time record remains authoritative.

## 2. Authority model

`Layer 1 Authoritative / Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

Layer 4 remains terminal. Search Projection, Search Visibility and Publication remain downstream product states.

## 3. Milestone sequence

| Milestone | Status | Planned-hours baseline | Outcome / focus |
|---|---|---:|---|
| M2.0 | COMPLETE | 8 | programme consolidation / Auto-UAT |
| M2.1 | CLOSED / PASS | 3 | Layer 2 platform foundation |
| M2.2 | CLOSED / PASS | 10 | Security & Production foundation + deterministic Search showcase |
| **M2.3** | **CLOSED / PASS — NZ L2 EXPANSION DEFERRED** | **12 baseline** | production-grade Layers 1–4, onboarding, Data Operations, decision UX, refresh, links/dates, Scholarship Selection and consolidated automated UAT |
| **M2.4** | **PLANNED / UNBLOCKED** | **7** | AI/Data Quality optimisation, provider/model quality/cost monitoring, queue tuning, full-stack regression, residual-risk closure and pre-blackout checkpoint |
| Blackout 16–30 Sep | NO DELIVERY | 0 | no planned project delivery |
| M2.5 | PLANNED | 12 | clean Production stack deployment/restore/security acceptance |
| M3 | PLANNED | 10 | consumer API / Zoho integration |
| M4 | PLANNED | 8 | Search/publication/final Production handover |

## 4. M2.3 accepted outcome

M2.3 accepted the following coherent Pilot/UAT operating platform:

1. production-grade Layer 1 source operations with bounded retry/resume and AU CRICOS/NZ NZQA recovery evidence;
2. shared Layer 2 deterministic acquisition/extraction, Evidence lifecycle, provider economics and AU representative scale controls;
3. operational Layer 3 with server-side/Vault credentials, bounded provider budgets, deterministic validation and a benchmark-approved pinned OpenRouter model;
4. operational Layer 4 terminal human review with all six governed actions and downstream Search signalling only after accepted canonical change;
5. freshness/event-driven scheduling and unchanged-Evidence zero-call behaviour;
6. reusable Country/Provider/Course onboarding using the shared canonical schema;
7. Data Operations decision surfaces, Important Links and source-precise Important Dates;
8. QILT/PRISMS context at their correct grains;
9. Scholarship Selection with explicit sourced/derived/unresolved separation and no eligibility inference;
10. role-based M2.3 operating guidance and permanent desktop/mobile automated regression.

## 5. Accepted runtime

Final M2.3 Pilot runtime:

`msinghbs-ai/Coursefinder-Pilot@260ed6a0d19b80ad666d74b90aa13e735e802a6a`

Evidence:

- Frontend Build `32917685085` — PASS;
- browser smoke — PASS;
- Deployed UAT `32917685022` — PASS;
- desktop `98024710961` — PASS;
- mobile `98024711090` — 29/29 PASS.

Visible browser release remains PIM Admin `v2.15.5` and M2.3 Intelligence `v1.2`.

## 6. Layer 3 accepted model

The router-wide `openrouter/free` configuration failed the governed benchmark and is not accepted.

Accepted model:

`nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`

Benchmark `a8e4b6c8-8a7b-45b4-a8df-c5a3bb4e8407` passed 5/5 provider semantic cases and 13/13 controls at USD 0 observed cost. Model/provider availability remains configuration rather than architecture; any future model/profile change requires governed revalidation/benchmark before resume.

## 7. NZ Layer 2 deferral

NZ authoritative Layer 1 is accepted. A dedicated NZ first-party Layer 2 Course enrichment source/profile is not currently configured.

This is explicitly **DEFERRED** to future NZ source qualification/onboarding. The shared Layer 2 platform and onboarding architecture are the accepted mechanism for that work; no NZ-specific canonical fork is authorised.

## 8. M2.4 scope

M2.4 no longer owns first launch of Layer 3. It may now begin when authorised and should focus on:

- Layer 3 model/provider quality and cost monitoring/rebenchmarking;
- Data Quality optimisation and queue tuning;
- Layer 1–4 full-stack regression;
- inherited performance/advisor backlog prioritisation only where workload evidence justifies change;
- residual-risk closure and durable pre-blackout acceptance checkpoint;
- explicit carry-forward of the NZ first-party Layer 2 deferral if not separately scheduled.

M2.4 must not silently expand into Production establishment, broad Publication or Zoho cutover.

## 9. Security / performance baseline

M2.3 closes with Security Advisor and Performance Advisor at INFO-only. Remaining RLS-no-policy notices on private tables, unindexed-FK/unused-index notices and Auth connection-strategy guidance are programme backlog unless later workload/security evidence elevates them.

## 10. Later gates

- M2.5: separate Production environment build/restore/security/cutover acceptance.
- M3: consumer API / Zoho integration.
- M4: Search/publication/final Production handover.

M2.3 closure does not authorise broad Publication, Production cutover or Zoho migration.
