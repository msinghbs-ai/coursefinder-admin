# CourseFinder Admin Navigation & Information Architecture v1.3

**Status:** CURRENT — M2 CONSOLIDATED LAYER 1–3 OPERATIONS TARGET  
**Date:** 25 August 2026  
**Supersedes:** v1.2  
**Related Change Controls:** `CF-CHG-20260823-030`, `CF-CHG-20260823-029`, `CF-CHG-20260825-031`

## Principle

Layer 1, Layer 2 and Layer 3 are now first-class operational capabilities and must be understandable from the primary Admin without exposing the internal schema as the information architecture.

Authority remains:

`Layer 1 Authoritative/Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`.

Layer 4 is terminal. Search/Publication are downstream product states, not Layer 5.

## Primary sidebar target

| Group | Menu item | Purpose | Minimum role/rank |
|---|---|---|---:|
| Overview | Dashboard | cross-platform health, blockers, cost, freshness and next actions | 1 |
| Catalogue | Providers | canonical Provider decision workspace | 1 |
| Catalogue | Courses | canonical Course decision workspace | 1 |
| Catalogue | Campuses | canonical Campus/geography workspace | 1 |
| Catalogue | Scholarships | canonical Scholarship workspace | 1 |
| Data Operations | **Layer 1 — Regulatory** | authoritative source ingestion, freshness, reconciliation and evidence | 4 |
| Data Operations | **Layer 2 — Enrichment** | deterministic first-party Course/Scholarship acquisition, extraction, completeness and provider routing | 4 |
| Data Operations | **Layer 3 — AI Interpretation** | unresolved Evidence interpretation, model/prompt versioning, validation, cost and escalation | 4 read / 5 run/config |
| Data Operations | Evidence | cross-layer provenance and versioned artifact workspace | 3 |
| Insights | Outcomes (QILT) | governed Provider/study-area outcomes context | 1 |
| Insights | Student Flow (PRISMS) | governed Provider/state/sector/cohort international-student context | 1 |
| Quality & Review | Completeness | factual and decision-context completeness/readiness | 1 |
| Quality & Review | Layer 4 Review Queue | terminal human resolution workload | 3 |
| Publishing & Consumers | Search | Search projection state/eligibility/diagnostics | governed role |
| Publishing & Consumers | Publication | explicit publication/channel controls | governed role |
| Governance & Platform | Attributes | PIM taxonomy/attribute governance | 5 |
| Governance & Platform | Access | Admin user/role management | 6 |
| Governance & Platform | Settings | privileged platform configuration | 6 |

## Layer 1 — Regulatory workspace

Management scorecard:

- country/source;
- authority class;
- last successful acquisition;
- source version/hash/date;
- freshness state;
- records discovered/accepted/rejected/unchanged;
- creates/updates/conflicts;
- Evidence artifacts;
- current blocker;
- next scheduled/allowed action.

Operations queue:

- source runs;
- reconciliation exceptions;
- identity conflicts;
- stale sources;
- ingestion failures;
- Evidence drill-through.

Advanced drill-down:

- source parser/config version;
- file/API endpoint;
- acquisition job;
- raw Evidence;
- schema/mapping diagnostics;
- replay/idempotency information.

Layer 1 must never be visually presented as merely another scraper pipeline. It is the authoritative/regulatory baseline.

## Layer 2 — Enrichment workspace

Management scorecard:

- country/provider/source-profile coverage;
- Courses/Scholarships eligible;
- scheduled/processed/resolved/unresolved;
- completeness before/after;
- Direct HTTP vs paid provider use;
- provider success and factual-resolution rate;
- cost/credits;
- Evidence growth;
- items requiring Layer 3;
- current blockers.

Operations queue:

- batches and run items;
- provider attempts;
- identity mismatch/guard failures;
- deterministic extraction candidates;
- accepted/rejected/skipped facts;
- stale/failed sources;
- Scholarship discovery/detail paths.

Advanced drill-down:

- Source Profile/version;
- provider route and credential readiness without secret disclosure;
- provider headers/cost units;
- Native/Normalised Evidence;
- extractor version;
- exact candidate apply consequence.

Layer 2 is an accepted deterministic platform capability. **Trials** are qualification/benchmark tools and must not make the primary workspace look experimental.

## Layer 3 — AI Interpretation workspace

Management scorecard:

- unresolved queue by country/provider/domain;
- pending/processed/accepted/rejected/retried/escalated;
- precision/validation pass rate from sampled/ground-truthed cases;
- token/API cost;
- latency;
- oldest queue age;
- Layer 4 fall-out.

Operations queue:

- Evidence item/domain;
- canonical entity;
- model profile;
- prompt/profile version;
- deterministic preconditions;
- AI suggestion;
- confidence;
- deterministic validation result;
- accepted/rejected/retry/escalate state;
- cost/latency.

Advanced drill-down:

- model/provider request metadata;
- exact Evidence inputs;
- prompt template/version;
- structured output;
- validation rule results;
- token/usage details;
- failure/retry trace.

Layer 3 must never invent missing source facts, redefine Layer 1 identity or silently auto-publish. Layer 3 output is a suggestion/interpretation until accepted by the governed apply contract.

## Evidence workspace

Evidence remains cross-layer rather than duplicated per workspace. Every Layer workspace deep-links to the same private Evidence surface.

Minimum filters:

- country;
- layer;
- source;
- Provider/Course/Scholarship;
- job/batch/run item/provider attempt;
- Evidence type/MIME;
- hash/version;
- acquisition/verification date;
- status/current/superseded;
- unresolved/conflict state.

## Dashboard maturity

Dashboard should answer, without drilling into diagnostics:

1. Are regulatory sources current?
2. How much of the catalogue is enriched?
3. What is paid acquisition costing?
4. What is stuck in Layer 3/4?
5. Is Evidence storage healthy?
6. Are Search/publication states safe?
7. Are there security/operational blockers?

Recommended cards:

- L1 Freshness;
- L2 Coverage / Completeness Uplift;
- L2 Paid Provider Spend;
- L3 Queue / Resolution;
- L4 Backlog;
- Evidence Storage %;
- Failed Jobs;
- Security/Release Gate;
- Search Published Count.

## Common UI rules

- primary screens use scorecard → queue → detail drawer/page;
- tables must be filterable, sortable, pageable and resilient at catalogue scale;
- filters use shared searchable/typeable controls;
- status terms are consistent: `healthy`, `degraded`, `stale`, `blocked`, `not configured`, `not yet run`;
- every consequential action explains authority and downstream consequence;
- secrets are never echoed back;
- provider HTTP success alone is never shown as factual-resolution success;
- desktop provides full operations/configuration; mobile must support health, queue review and safe drill-down;
- advanced diagnostics use progressive disclosure;
- avoid duplicate menu entries for Source Profiles, Providers, Trials and Jobs when they are layer-specific drill-downs;
- QILT/PRISMS retain their true contextual grain and remain under Insights;
- there is no admissions/application/visa workflow implied by this IA.

## Preferred route families

- `/data-operations/layer1`
- `/data-operations/layer2`
- `/data-operations/layer3`
- `/data-operations/evidence`
- `/quality/completeness`
- `/quality/layer4-review`
- `/publishing/search`
- `/publishing/publication`

Route refactoring must preserve existing security/RPC/Evidence contracts and requires browser UAT.
