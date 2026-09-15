# CF-CHG-20260915-247 — End-to-End Automated Data Admission Programme

**Status:** OPEN — ACTIVE DELIVERY AUTHORITY  
**Opened:** 2026-09-15 AEST  
**Primary owner:** 00-governance-programme  
**Affected surfaces:** Layer 1, Layer 2, Layer 3, Layer 4, Search/API consumers, Admin/PIM operations, Scholarships, Rankings, Statistics, country onboarding, Edge/runtime orchestration and UAT.

## Objective

Close the gap between accepted source/Evidence components and the business outcome: qualified data must flow automatically from source acquisition through governed admission to consumer-ready Search/API state, with human intervention reserved for genuine exceptions.

Programme authority:

`docs/coursefinder-end-to-end-automated-data-admission-roadmap-v1.0.md`

Actionable operations/monitoring authority:

`docs/coursefinder-actionable-operations-monitoring-standard-v1.0.md`

## Runtime finding that triggered this Change Control

The current deployed `layer2-batch-runner` successfully performs governed acquisition, Evidence normalization, deterministic extraction and item telemetry. When deterministic extraction cannot resolve the target it marks the item `layer3_required` and completes/reconciles Layer 2. It does **not** enqueue or invoke a Layer 3 worker.

The deployed `layer3-interpret` function is a valid evidence-bound single-interpretation execution path with model/profile/rate/cost/validator controls, but the current Admin implementation invokes it from an operator `Run eligible interpretation` action. The general Course Evidence queue is therefore not continuously drained.

Current RMIT controlled-scale proof on 15 September 2026:

- 25 targets;
- 25 processed;
- 0 resolved deterministically in Layer 2;
- 25 marked/escalated `layer3_required`;
- 0 blocked;
- vendor cost USD 0;
- no corresponding automatic Layer 3 interpretations.

A wider runtime check at 2026-09-15 09:27 UTC found **2,402 Layer 2 run items in `layer3_required` state** and no active queued/running Layer 2 work. This confirms that continuing to increase Layer 2 volume without completing the Layer 3 drain would increase operational debt rather than admitted data.

## Programme decision

Do not continue expanding Layer 2 wave volume merely to create a larger Layer 3 backlog. The immediate engineering priority is the automatic Layer 2 → Layer 3 → admission → Search/API loop.

Existing accepted parsers, adapters, Evidence contracts, provider controls, model profiles and consumer APIs remain reusable. This is not authority to perform a big-bang refactor.

The Admin UI and reporting model is also part of the feature outcome. Routine screens must be refactored around role-specific decisions and actionable, cross-linked metrics. Stale totals, duplicated diagnostics and decorative data must be removed or moved behind progressive disclosure.

## Required implementation outcomes

1. Durable idempotent Layer 3 work queue generated automatically from eligible Layer 2 fall-out.
2. Server-owned Layer 3 dispatcher with model-profile qualification, concurrency, RPM/day, cost and retry ceilings.
3. Task-class coverage for the fields actually produced by Course enrichment, with benchmark-passed model routes before execution.
4. Deterministic post-Layer-3 admission policy; AI never receives unrestricted canonical-write authority.
5. Automatic governed Search/API projection after accepted changes.
6. Layer 4 receives only policy-defined exceptions/ambiguities/consequential decisions.
7. Live Admin end-to-end progress: Layer 2 → Layer 3 → Layer 4 → admitted/Search, with Evidence, cost, tokens, latency and stop reasons.
8. Shared source/adapter and field-policy contracts used for AU/NZ/CA and upcoming countries rather than duplicating orchestration per Provider/country.
9. Scholarships, Rankings and Statistics converge on the same operations/control-plane conventions while retaining their correct source-specific data semantics.
10. Wix/Website and Zoho remain curated read consumers behind safe API contracts.
11. Every headline operational metric is clickable/drillable to the exact Jobs/Evidence/queue/admission/consumer records that produce it.
12. Active runs show target, processed, remaining, L2/L3/L4/admission counts, throughput, ETA, provider/model resource usage and quota headroom with automatic refresh/realtime behaviour.
13. Hourly and daily retained telemetry supports capacity forecasting, backlog burn-down, cost/quota planning and source freshness management.
14. Each Admin screen is reviewed by role and stripped to actionable default data; raw diagnostics and forensic detail remain available through drill-down, not as default clutter.

## Role/UI operating rule

Operational screens must answer: what is running, what changed, what is blocked, what was admitted, what resource headroom remains, when the scope is forecast to finish, and what action is next.

Role-specific defaults:

- Platform Admin — system/security/runtime/quota/API health and alerts;
- PIM/Data Admin — source freshness, qualified scope, coverage gaps, admission yield and blocked work;
- Reviewer — only genuine Layer 4/quality exceptions and supporting Evidence;
- Counsellor/business user — curated consumer data/freshness, not pipeline internals;
- Integration/ops support — Wix/Zoho/Search projection/API health, failures, versions and lineage drill-down.

No new metric/card is accepted without a defined operator action or decision it supports.

## Continuous monitoring / execution rule

From this Change Control onward, routine safe execution must not wait for a user `proceed` message.

An hourly autonomous monitoring/execution cycle is authorised to:

- reconcile Admin/Pilot/runtime/CI truth;
- capture L1/L2/L3/L4/admission/Search/API progress and resource metrics;
- continue the next safe implementation or execution step;
- record material state in the hourly monitoring record and continuity files;
- report what was achieved during the hour and the exact next action.

The only normal reasons to wait are a hard external API/quota/tool execution limit, authentication/approval requirement, safety boundary or genuine authority/security blocker. The exact external blocker must be recorded when this occurs.

Work must be bounded to available chat/tool/runtime limits. Before tool/context exhaustion, persist evidence, pending run IDs and exact continuation state to the repository so the next hourly cycle continues rather than duplicating work.

## Testing/acceptance scope

Acceptance is not one AU university. The programme roadmap defines functional, portability, data-family, security and performance matrices.

Required live/qualified pilots:

- AU accepted Course profiles;
- NZ Course pilot only after independent source/profile qualification;
- CA qualified pilot using accepted authoritative identities.

Required portability before each later-country activation:

- GB, US, IE and DE adapter-contract fixtures for JSON/API, HTML, sitemap/index, CSV/XLSX and PDF/static forms where applicable;
- one qualified live pilot per country after source authority is accepted;
- unchanged replay, changed data, identity ambiguity, deletion/retirement and recovery tests.

Operational UI acceptance additionally requires:

- live progress without manual refresh for active work;
- cross-click reconciliation from headline metric to underlying records;
- hourly/daily reporting from retained telemetry rather than stale screenshots;
- measured throughput/resource forecasts;
- role-specific screen simplification and progressive disclosure;
- no statement-timeout regression from operational reporting.

## Security invariants

- Layer 1 identity authority remains protected.
- Browser does not invoke service-only dispatch/admission helpers directly.
- private Evidence/Vault secrets remain private.
- Layer 3 outputs are candidates; a deterministic policy service controls admission.
- identity/regulatory/consequential ambiguity routes to Layer 4.
- no source qualification or benchmark is bypassed for throughput.
- API consumers have no canonical-write authority.

## Delivery order

1. Automatic Layer 3 queue and dispatcher.
2. Course-fact task profiles/benchmarks required by actual fall-out.
3. Post-L3 admission policy + Search projection.
4. Live actionable operations UI with cross-linked metrics and resource forecasts.
5. AU end-to-end admission proof and scale.
6. NZ + CA pilots on the same engine.
7. GB/US/IE/DE portability and then source-qualified live pilots.
8. Scholarship/Ranking/Statistics operational convergence.
9. Role-by-role Admin screen refactoring to remove non-actionable bloat while retaining drill-down diagnostics.
10. Full nominated acceptance matrix plus hourly/daily operational reporting acceptance.

## Stop rule

Fix bugs and security defects as they arise, but do not let unrelated refactoring, optional parser cleanup or milestone paperwork displace the end-to-end admission outcome. A change blocks this programme only when it affects authority, correctness, recoverability, secure execution or consumer integrity.

## Rollback principle

New orchestration/admission/components must be additive until accepted. Existing proven Layer 2/3 functions remain available during migration. Queue/dispatcher/admission/live-monitor components can be disabled independently without deleting Evidence or canonical history.

## Current next action

Implement the additive Layer 3 work-queue/dispatcher contract using existing Layer 2 run-item Evidence and existing `layer3-interpret` execution/validation logic. In parallel, define the compact live-run read model required by the actionable operations standard so the same state machine is observable without a second analytics-heavy reporting path. Do not launch larger Course waves until that queue can drain automatically and expose live progress.