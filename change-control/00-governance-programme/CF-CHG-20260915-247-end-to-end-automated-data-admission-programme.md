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

Resolve request **6326** first. On full semantic+safety PASS, complete exact-head `layer3-interpret` candidate-context integration/CI/UAT and run only a 10–25-item existing Evidence-backed cohort through L3 → deterministic admission/L4 → Search/API proof. On FAIL, use the exact failure classes; if controls recover but positives remain null, verify retained Evidence exact support before one further bounded corrective change. Do not weaken qualification and do not launch larger Course waves.

**NO DATA ADMISSION PROVEN** until the bounded cohort satisfies M247-FU-021.