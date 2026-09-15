# CF-CHG-20260915-247 — End-to-End Automated Data Admission Programme

**Status:** OPEN — ACTIVE DELIVERY AUTHORITY  
**Opened:** 2026-09-15 AEST  
**Primary owner:** 00-governance-programme  
**Affected surfaces:** Layer 1, Layer 2, Layer 3, Layer 4, Search/API consumers, Admin/PIM operations, Scholarships, Rankings, Statistics, country onboarding, Edge/runtime orchestration and UAT.

## Objective

Close the gap between accepted source/Evidence components and the business outcome: qualified data must flow automatically from source acquisition through governed admission to consumer-ready Search/API state, with human intervention reserved for genuine exceptions.

Programme authority:

`docs/coursefinder-end-to-end-automated-data-admission-roadmap-v1.0.md`

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

This demonstrates that the end-to-end feature is incomplete even though individual Layer 2 and Layer 3 components are accepted.

## Programme decision

Do not continue expanding Layer 2 wave volume merely to create a larger Layer 3 backlog. The immediate engineering priority is the automatic Layer 2 → Layer 3 → admission → Search/API loop.

Existing accepted parsers, adapters, Evidence contracts, provider controls, model profiles and consumer APIs remain reusable. This is not authority to perform a big-bang refactor.

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
4. Live operations UI.
5. AU end-to-end admission proof and scale.
6. NZ + CA pilots on the same engine.
7. GB/US/IE/DE portability and then source-qualified live pilots.
8. Scholarship/Ranking/Statistics operational convergence.
9. Full nominated acceptance matrix.

## Stop rule

Fix bugs and security defects as they arise, but do not let unrelated refactoring, optional parser cleanup or milestone paperwork displace the end-to-end admission outcome. A change blocks this programme only when it affects authority, correctness, recoverability, secure execution or consumer integrity.

## Rollback principle

New orchestration/admission components must be additive until accepted. Existing proven Layer 2/3 functions remain available during migration. Queue/dispatcher/admission can be disabled independently without deleting Evidence or canonical history.

## Current next action

Implement the additive Layer 3 work-queue/dispatcher contract using existing Layer 2 run-item Evidence and existing `layer3-interpret` execution/validation logic. Do not launch larger Course waves until that queue can drain automatically and expose live progress.
