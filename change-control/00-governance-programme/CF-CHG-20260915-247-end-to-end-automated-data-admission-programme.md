# CF-CHG-20260915-247 — End-to-End Automated Data Admission Programme

**Status:** OPEN — ACTIVE DELIVERY AUTHORITY  
**Opened:** 2026-09-15 AEST  
**Primary owner:** 00-governance-programme  
**Affected surfaces:** Layer 1, Layer 2, Layer 3, Layer 4, Search/API consumers, Admin/PIM operations, Scholarships, Rankings, Statistics, country onboarding, Edge/runtime orchestration and UAT.

## Objective

Close the gap between accepted source/Evidence components and the business outcome: qualified data must flow automatically from source acquisition through governed admission to consumer-ready Search/API state, with human intervention reserved for genuine exceptions.

Programme authority: `docs/coursefinder-end-to-end-automated-data-admission-roadmap-v1.0.md`  
Actionable operations/monitoring authority: `docs/coursefinder-actionable-operations-monitoring-standard-v1.0.md`

## Runtime finding that triggered this Change Control

The deployed Layer 2 path performs governed acquisition, Evidence normalization, deterministic extraction and item telemetry. Unresolved targets become `layer3_required`; the controlled RMIT proof produced 25/25 Layer 3 fall-outs and no automatic Layer 3 interpretation. A wider runtime check found 2,402 Layer 2 run items in `layer3_required`, proving that increasing Layer 2 volume without a drain path creates operational debt rather than admitted data.

## Programme decision

Do not expand Layer 2 wave volume merely to enlarge the Layer 3 backlog. The immediate engineering priority is the automatic Layer 2 → Layer 3 → deterministic admission/Layer 4 → Search/API loop. Existing accepted parsers, adapters, Evidence contracts, provider controls, model profiles and consumer APIs remain reusable; this is not authority for a big-bang refactor.

The Admin UI/reporting model remains part of the feature outcome. Routine screens must prioritise role-specific actionable, cross-linked metrics; stale totals and decorative diagnostics must not displace execution work.

## Required implementation outcomes

1. Durable idempotent Layer 3 work queue generated automatically from eligible Layer 2 fall-out.
2. Server-owned Layer 3 dispatcher with model-profile qualification, concurrency, RPM/day, cost and retry ceilings.
3. Task-class coverage for the fields actually produced by Course enrichment, with benchmark-passed model routes before execution.
4. Deterministic post-Layer-3 admission policy; AI never receives unrestricted canonical-write authority.
5. Automatic governed Search/API projection after accepted changes.
6. Layer 4 receives only policy-defined exceptions/ambiguities/consequential decisions.
7. Live Admin end-to-end progress: Layer 2 → Layer 3 → Layer 4 → admitted/Search, with Evidence, cost, tokens, latency and stop reasons.
8. Shared source/adapter and field-policy contracts used for AU/NZ/CA and upcoming countries rather than duplicating orchestration per Provider/country.
9. Scholarships, Rankings and Statistics converge on the same operations/control-plane conventions while retaining correct source-specific data semantics.
10. Wix/Website and Zoho remain curated read consumers behind safe API contracts.
11. Every headline operational metric is drillable to the exact Jobs/Evidence/queue/admission/consumer records that produce it.
12. Active runs show target, processed, remaining, L2/L3/L4/admission counts, throughput, ETA, provider/model resource usage and quota headroom with automatic refresh/realtime behaviour.
13. Hourly/daily retained telemetry supports capacity forecasting, backlog burn-down, cost/quota planning and source freshness management.
14. Each Admin screen is reviewed by role and stripped to actionable default data; forensic detail remains available through drill-down.

## Security invariants

- Layer 1 identity authority remains protected.
- Browser does not invoke service-only dispatch/admission helpers directly.
- private Evidence/Vault secrets remain private.
- Layer 3 outputs are candidates; deterministic policy controls admission.
- identity/regulatory/consequential ambiguity routes to Layer 4.
- no source qualification or benchmark is bypassed for throughput.
- API consumers have no canonical-write authority.
- candidate-bound tuition validation may return only an immutable Layer-2 candidate or null; it may not invent, annualise, convert currency, mutate year or strengthen basis.

## Continuous execution / anti-loop rule

Routine safe execution must not wait for a user `proceed` message. M247-FU-020/021/022 are mandatory: scheduled runs execute the exact carried-forward critical-path action after minimum reconciliation; implementation/CI/review/qualification are not data admission; DATA ADMISSION requires authoritative before/after proof through L2, L3, deterministic admission/L4, canonical delta, Search/API and Evidence/model/resource telemetry. One non-advancing run without a hard external blocker forces a changed executable approach; two is `SCHEDULER EXECUTION FAILURE`.

The only normal reasons to wait are a hard external API/quota/tool execution limit, authentication/approval requirement, safety boundary or genuine authority/security blocker. Exact run IDs and next actions must be persisted before tool/context exhaustion.

## Gate D execution state — 17 September 2026

Durable Layer 3 queue/security/handoff primitives are deployed and tuition candidate lineage is preserved. 610 explicit tuition fall-out records have proposed candidate context; 598 retain fee-candidate arrays. The tuition-specific profile remains correctly paused until benchmark PASS.

Latest trusted lifecycle baseline is 2,511 `layer3_required` / 2,423 `resolved_l2` / 815 cancelled / 10 blocked; Layer 3 work queue is 0. Evidence latest trusted total is 30,925. No larger Layer 2 wave is authorised.

Pilot PR #99 candidate-bound branch corrective head is **`58115985856bace75fecb10422dea5220ea4cee4`**. The exact worker source is deployed as `layer3-cf245-tuition-benchmark` runtime **v6**, worker `cf247-tuition-benchmark-v1.3.1-candidate-bound`.

Qualification evidence:

- request 6324: FAIL provider 0/4, controls 2/4, 13 calls, 18,799 input + 610 output, USD 0, max latency 6.609 s;
- request 6325 on diagnostic v1.3: FAIL provider 0/4, controls 0/4, 11 calls, 6,678 input + 35 output, USD 0, max latency 0.901 s; this isolated `json_object` transport as a regression;
- v1.3.1 restores strict JSON-schema transport while retaining focused Evidence and all fail-closed validators;
- request **6326** is submitted through the governed server path and at continuity cut remains queued in `net.http_request_queue` with the correct tuition benchmark URL and 120-second timeout. Do not submit a duplicate while unresolved.

The four positive corpus records were rechecked against canonical `catalogue.course_fees` and retained `pipeline.evidence_artifacts`; all are UQ 2027 international `indicative_annual` AUD tuition facts with retained Evidence. If 6326 still fails semantic positives after controls recover, inspect retained Evidence exact text before any further prompt/model change.

`layer3-interpret` still requires final `provider_current_tuition_validation` candidate-context execution integration before the first bounded live cohort.

## Gate-D qualification interpretation correction — 18 September 2026

A narrower execution interpretation incorrectly made universal positive tuition resolution a prerequisite for operating the Layer 3 route. That is not the programme design. Layer 3 must resolve only facts explicitly supported by retained Evidence and the immutable Layer-2 candidate set. Safe abstention/no-candidate, ambiguity, conflict, low confidence or validator rejection is a valid outcome when the durable work item is deterministically transferred to Layer 4 with Evidence lineage, candidate context, interpretation/audit record, reason/failure class and model/provider telemetry.

Accordingly, qualification must prove two behaviours: supported facts resolve without mutation; unsupported/ambiguous facts fail closed and route correctly to Layer 4. A safe refusal to infer an unsupported annual/indicative basis is not grounds to block all Layer 3 execution. Existing security, service-role, identity, Evidence, migration, admission and Search/publication boundaries remain unchanged.

## Delivery order

1. Complete Gate D qualification + candidate-context Layer 3 execution/drain.
2. Post-L3 deterministic admission policy + Search projection.
3. Live actionable operations UI with cross-linked metrics and resource forecasts.
4. AU end-to-end admission proof and scale.
5. NZ + CA pilots on the same engine.
6. GB/US/IE/DE portability and source-qualified live pilots.
7. Scholarship/Ranking/Statistics operational convergence.
8. Full nominated acceptance matrix plus hourly/daily operational reporting acceptance.

## Stop / rollback principle

Fix bugs and security defects as they arise, but do not let unrelated refactoring or paperwork displace the end-to-end admission outcome. New orchestration/admission components remain additive until accepted; queue/dispatcher/admission/live-monitor components can be disabled independently without deleting Evidence or canonical history.

## Current next action

Correct the qualification/routing contract forward-only so safe abstention and other policy-defined unresolved outcomes are accepted only when they produce the correct durable Layer-4 disposition and handover. Require exact-head CI/UAT, then execute a 10–25-item existing Evidence-backed cohort. Admit only validated authorised candidates; send unresolved/ambiguous/rejected/low-confidence outcomes to Layer 4. Capture M247-FU-021 through canonical and Search/API consequences. Do not weaken validation and do not launch larger Course waves until bounded drain is proven.

**NO DATA ADMISSION PROVEN** until the bounded cohort satisfies M247-FU-021.

## Exact-head repair campaign — 21 September 2026

PR #99 exact head `9b05918bcc59a1d68da54e1bbc6b9c15c6d9b051` now enforces the sole-target candidate contract and executes it in CI. Frontend Build `35555240917/#2478` and Release History Contract `35555240881/#156` PASS; Gitar reports no issues and the PR remains draft.

This is repository assurance only. Deployed runtime remains benchmark v11, interpreter v5 and dispatcher v4. Live state is 2,511 L2 `layer3_required`, 10 L3 `layer4_required`, 1 L3 `parked`, 59 L4 pending, Evidence 32,040, field admissions 1,216, fees 79,730 and Search documents 33,105. No CF-247 admission delta is proven.

Ordered blockers before any drain are: task/profile/auth-safe dispatcher reservation; benchmark PASS binding to exact prompt/schema/validator/model version; deterministic idempotent admission/L2 reconciliation/canonical/Search projection; then a description-first generic handler and tiny exact-head deployed cohort. Intake and English remain out of scope until explicit policies and validators exist. The 1,780 finding is a row cohort with overlapping unresolved fields, not authority for a bulk enqueue.

## Delivery evidence — 21 September 2026 14:05 AEST

CF-247 dispatcher/reservation slice is now closed across repository, CI and Pilot runtime. PR #99 exact head is `c8866b573480b337ed86494f9817c98c69629c79`; workflows `35555931223/#2479` and `35555931237/#157` pass. Pilot migration `20260921040446_cf247_task_profile_scoped_reservation` is applied and `layer3-work-dispatch` is ACTIVE v5 at hash `f72a01945792207f73af03eb40c6d74748fbf6766d4f8142d6db7a74c2897d66`.

The deployed path now reserves only the requested task/profile, revalidates profile eligibility in the reservation transaction, uses one-at-a-time reservation with full-call remaining-time protection, and fails closed across reserved/interpreting error states. RPC execution remains restricted to postgres/service_role; the legacy global reservation RPC is retired. The parked item was not retried. Runtime remains 10 Layer-4-required + 1 parked, with no provider call, token, cost, canonical or Search/API admission delta.

The next governed unit is benchmark-version binding (slice 3). Larger L2 waves, new cohorts and the parked tuition item remain paused.

### Migration-ledger reconciliation — 21 September 2026 14:12 AEST

Gitar aligned the repository migration filename to the already-applied Pilot ledger without changing SQL bytes. PR #99 exact head is now `e7b6d5b3ab345511c99fa66e35e65b89fab4d581`; Pilot Frontend Build `35560006737/#2480` and Release History Contract `35560006759/#158` both PASS. Repository file `20260921040446_cf247_task_profile_scoped_reservation.sql` now matches runtime migration `20260921040446`. Dispatcher v5/hash, queue counts and zero-call telemetry are unchanged. Slice 2 remains closed; slice 3 benchmark binding is next.
