# CourseFinder Master Project Plan v1.71

**Issued:** 25 August 2026  
**Status:** CURRENT  
**Supersedes:** v1.70  
**Programme Change Controls:** CF-CHG-20260825-036 M2.3 ACTIVE / EXPANDED; CF-CHG-20260825-037 Onboarding ACTIVE; CF-CHG-20260825-038 L3/L4 + refresh intelligence ACTIVE

## 1. Programme position

M1 remains frozen. M2.1 and M2.2 are CLOSED/PASS. M2.3 is the production-grade Data Operations and decision-support maturity gate and now operationalises **Layers 1–4 together**.

The separate Production environment remains M2.5. No additional billable hours are inferred by this scope revision; the engagement-time record remains authoritative.

## 2. Authority model

`Layer 1 Authoritative / Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

Layer 4 remains terminal. Search Projection, Search Visibility and Publication remain downstream product states.

## 3. Milestone sequence

| Milestone | Status | Planned-hours baseline | Outcome / focus |
|---|---|---:|---|
| M2.0 | COMPLETE | 8 | programme consolidation / Auto-UAT |
| M2.1 | CLOSED / PASS | 3 | Layer 2 platform foundation |
| M2.2 | CLOSED / PASS | 10 | Security & Production foundation + deterministic Search showcase |
| **M2.3** | **ACTIVE / EXPANDED** | **12 baseline** | production-grade Layer 1; Layer 2 scale; operational Layer 3; operational Layer 4; onboarding; unified Data Operations; Scholarship Selection; Course intelligence; refresh scheduling; links/dates; guides/UAT |
| **M2.4** | **REPURPOSED / PLANNED** | **7** | AI/Data Quality optimisation, full-stack regression and pre-blackout acceptance checkpoint |
| Blackout 16–30 Sep | NO DELIVERY | 0 | no planned project delivery |
| M2.5 | PLANNED | 12 | clean Production stack deployment/restore/security acceptance |
| M3 | PLANNED | 10 | consumer API / Zoho integration |
| M4 | PLANNED | 8 | Search/publication/final Production handover |

## 4. M2.3 consolidated objective

M2.3 delivers one coherent operating platform:

1. production-grade Layer 1 with source certification and source-specific batch/rate/retry policies;
2. Layer 2 scale enrichment, Evidence lifecycle, provider economics and AU/NZ expansion;
3. operational Layer 3 AI interpretation using governed aggregator/provider profiles, server-side secrets, free/low-cost model preference, rate/budget limits and deterministic validation;
4. operational Layer 4 terminal human review with full Evidence/provenance/audit;
5. freshness/event-driven update scheduling across Layers 1–3 instead of indiscriminate frequent reprocessing;
6. Country/Provider/Course onboarding framework using the shared canonical schema;
7. unified Data Operations navigation;
8. Important Links registry and Important Dates/ticker;
9. Course detail QILT/PRISMS/Scholarship context;
10. Scholarship Selection decision-support mini-app;
11. role-based guides/quick tours and consolidated automated UAT.

## 5. Refresh intelligence

Courses/providers do not receive identical refresh frequency. Scheduling must be driven by source authority, source publication cadence, source/evidence hash changes, freshness SLA, known intake/scholarship/regulatory dates and unresolved quality state.

Default policy shape:

- Layer 1: source-specific cadence + change detection;
- Layer 2: on upstream change, source hash change, freshness expiry or important-date window;
- Layer 3: only on unresolved/new/changed Evidence or expired interpretation; unchanged Evidence consumes no LLM request;
- Layer 4: event-driven escalation only;
- Search/consumer projection: after accepted upstream read/canonical changes.

Use governed freshness classes (for example critical, weekly, monthly, term-cycle, annual, event-driven) instead of a single universal schedule.

## 6. Layer 3 architecture

- OpenAI-compatible provider abstraction; OpenRouter is an acceptable initial aggregator.
- Prefer free/zero-cost models where they pass task-quality contracts.
- Model/provider availability is configuration, not architecture; free models can change.
- Secrets remain Vault/server-side; browser stores no API key.
- Version model/profile/prompt/schema/validation configuration.
- Enforce request/day, request/minute, token/output and retry budgets.
- LLM output is untrusted; validate structured output deterministically.
- Layer 3 creates suggestions/candidates and cannot override Layer 1 identity.

## 7. Layer 4 architecture

Layer 4 is the terminal human-resolution layer with approve/edit/reject/return-for-evidence, explicit reasons, actor/time audit, Evidence and cross-layer lineage. No hidden auto-approval.

## 8. Navigation target

Top-level target:

- Dashboard
- Catalogue / PIM
- Onboarding
- Data Operations
- Data Quality
- Scholarship Selection
- Important Links
- Search / Publication where authorised
- Administration / Settings
- Help / Guides

**Data Operations** contains Overview, Layer 1 — Regulatory, Layer 2 — Enrichment, Layer 3 — AI Interpretation, Layer 4 — Human Resolution, Evidence & Provenance and Jobs/Runs.

Important Dates should appear as a compact dashboard/Data Operations ticker and have a maintained detail registry rather than consume excessive top-level navigation.

## 9. Important Links and Dates

Important Links is a governed country/authority/source directory with owner, purpose, last verification, freshness/check cadence, source-profile relationship and status.

Important Dates stores sourced deadlines/windows/data releases with scope, timezone/date semantics, Evidence/source, warning windows and expiry. Dates may trigger targeted refresh jobs but never uncontrolled broad re-ingestion.

## 10. Firecrawl

User-confirmed Firecrawl entitlement: **paid subscription, 5,000 pages/month**. M2.3 must reconcile the live provider registry from stale `free` metadata to the confirmed entitlement and implement monthly usage/remaining-page/batch-budget controls. Direct HTTP remains preferred where sufficient.

## 11. Onboarding/canonical model

Future countries, Providers and Courses use the same canonical Provider/Course/PIM identity model. Country-specific source grain belongs in source-native staging, Evidence, mapping, fact/extension tables and adapters. Do not create parallel country canonical databases/tables unless an explicit architecture review proves the concept cannot be represented safely in the shared model.

## 12. M2.4 repurpose

M2.4 no longer owns first launch of Layer 3. Its scope is AI/Data Quality optimisation, model/provider quality/cost benchmarking, queue tuning, full-stack regression, residual-risk closure and the durable pre-blackout checkpoint.

## 13. M2.3 acceptance

M2.3 closes only when implemented Layers 1–4, onboarding, refresh scheduling, links/dates, Layer 2 scale/Evidence, unified UX, Scholarship Selection, Course contextual intelligence and guides pass automated database/API/security/storage/browser/mobile/performance/replay/AI-validation UAT or residual items are explicitly BLOCKED/DEFERRED with evidence.

Separate Production deployment, broad Publication, Zoho cutover and final handover remain later gates.
