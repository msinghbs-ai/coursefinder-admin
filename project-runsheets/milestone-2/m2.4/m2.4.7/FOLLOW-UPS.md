# M2.4.7 FOLLOW-UPS

| ID | Workstream | Status | Exact next action |
|---|---|---|---|
| M247-FU-001 | End-to-end automation | ACTIVE / PRIMARY | Queue/handoff, candidate-bound validation, service-owned interpretation and dispatcher are implemented. Correct the qualification/routing contract so safe abstention/ambiguity can proceed to Layer 4, then exact-head CI/UAT and dispatch only the first 10–25 existing Evidence-backed tuition items. |
| M247-FU-002 | Layer 3 task coverage | BLOCKING / ROUTING QUALIFICATION ACTIVE | `provider_current_tuition_validation` is candidate + Evidence validation, not extraction. Historical 6326 provider 0/4 + controls 4/4 demonstrated that safe refusal on unsupported UQ annual/indicative basis can be correct behaviour. Qualification must now prove supported resolution plus safe abstention/rejection→Layer-4 routing; do not require universal positive resolution and do not weaken validators. |
| M247-FU-003 | Post-L3 admission | ACTIVE | Add deterministic field-policy admission service. AI output remains candidate input; identity/regulatory/consequential ambiguity routes Layer 4. |
| M247-FU-004 | Search/API propagation | ACTIVE | Trigger incremental governed Search/API projection only after accepted canonical change; prove consumer delta/no-op semantics. |
| M247-FU-005 | Live Admin progress | ACTIVE | Add active-run L2/L3/L4/admitted/remaining counters, progress %, Evidence, calls/tokens/cost/latency and stop reasons with polling/realtime refresh. |
| M247-FU-006 | AU scale | PAUSED UNTIL AUTOMATION LOOP | Resume RMIT/UQ waves after automatic L3 drain/admission is proven; avoid creating a larger undrained backlog. |
| M247-FU-007 | NZ pilot | BLOCKED ON QUALIFICATION | Independently qualify a first-party NZ Course enrichment profile, then run the same shared orchestration without AU-specific shortcuts. |
| M247-FU-008 | CA pilot | PENDING SHARED LOOP | Use accepted CA authoritative identities and one qualified first-party enrichment pilot to prove the same queue/admission engine. |
| M247-FU-009 | GB/US/IE/DE portability | PLANNED | Run adapter-contract fixtures for API/JSON, HTML, sitemap, CSV/XLSX, PDF/static and identity ambiguity; then one qualified live pilot per country after source authority acceptance. |
| M247-FU-010 | Scholarships convergence | ACTIVE LATER TRACK | Keep current Scholarship ETL/extraction semantics but move scheduling/state/telemetry/control-plane behaviour behind shared operations conventions. |
| M247-FU-011 | Rankings convergence | ACTIVE LATER TRACK | Keep publisher/edition/evidence identity deterministic; align jobs/telemetry/control-plane conventions, not numeric ingestion with AI. |
| M247-FU-012 | Statistics convergence | ACTIVE LATER TRACK | Preserve observation grain/suppression; align ETL operations, Evidence and consumer projection conventions. |
| M247-FU-013 | Evidence reuse | DEFERRED UNTIL MEASURED | Tune shared-fetch reuse only if repeated acquisition materially affects cost/latency after the end-to-end loop works. |
| M247-FU-014 | Retry/refactor cleanup | DEFERRED UNTIL MEASURED | Refine or retire duplicated functions only when touched, blocking scale or replaced by accepted shared orchestration. No big-bang refactor. |
| M247-FU-015 | Website/Zoho handover | CONTINUOUS | Keep already-admitted data available through curated APIs while automation coverage expands; do not wait for 100% completeness. |
| M247-FU-016 | Monitoring integrity | BLOCKING METRIC TRUST | Standardise hourly metrics on authoritative direct source tables/read model with timestamp + source identity so false backlog deltas cannot be reported as admission gains. Lifecycle `status` is backlog authority; do not substitute legacy `outcome_code`. |
| M247-FU-017 | Generic Layer 3 provenance | ACTIVE | 1,780 previously observed `layer3_required` items have only generic blocker provenance. Add explicit unresolved-field/task provenance before dispatch; do not infer task class from the generic marker. |
| M247-FU-018 | Tuition candidate lineage | IMPLEMENTED / VERIFY EXECUTION | Runtime + Pilot migrations preserve immutable `candidate_context` and bind it to normalized extraction Evidence. 610 explicit fee fall-out records have proposed tuition; 598 retain fee-candidate arrays. Use the same bounded context in Layer 3. Explicitly supported candidates may validate; unsupported/ambiguous candidates must abstain/reject and route to Layer 4 with the immutable candidate and Evidence handover. |
| M247-FU-019 | Gitar bounded self-resolution | ACTIVE SUPPORTING CONTROL | Use Gitar review/self-fix as the preferred first remediation path for ordinary implementation, lint/type, test, CI and non-authority UI defects when a PR is blocked. After any Gitar-generated commit, re-read the exact diff and exact-head CI/UAT before acceptance. Gitar must not weaken or autonomously redefine Layer 1 authority, identity, security/RLS/service-role boundaries, Evidence lineage, applied migration history, Layer 3 admission policy, Layer 4 routing, Search/publication authority, secrets or governance controls. If one bounded repair cycle cannot resolve a defect, return to root-cause diagnosis rather than repeatedly requesting equivalent fixes. |
| M247-FU-020 | Scheduler execution invariant | ACTIVE / BLOCKING CONTROL | Scheduled CF-247 runs are execution runs, not recurring analysis. Each Admission Watch run must either change critical-path code/runtime state or stop on a specific hard external blocker. Re-reading the same known blocker, repeating reconciliation, or reporting STALLED without attempting the next authorised implementation/execution step is scheduler execution failure. |
| M247-FU-021 | Admission proof contract | ACTIVE / REQUIRED FOR GATE ADVANCEMENT | A scheduler may claim data-admission progress only with authoritative before/after proof: L2 status delta, L3 work-item creation/reservation/result, deterministic admission or Layer-4 disposition, canonical field delta where admitted, and Search/API consumer projection delta or explicit governed no-op. Include bounded cohort/run identifiers, Evidence lineage, timestamps, failure/retry counts, model/provider usage and resource/quota headroom. Code/CI/review/qualification progress is separate. |
| M247-FU-022 | Iteration carry-forward | ACTIVE / MANDATORY | Current exact handoff is the Gate-D routing correction: locate and correct any contract that treats safe abstention/no-candidate/ambiguity as route-level failure instead of a Layer-4 disposition. Require exact-head CI/UAT, then run a 10–25-item Evidence-backed cohort and capture M247-FU-021. Do not return to schema/profile rediscovery unless authoritative truth changes. |

## Scheduler execution invariant

The primary scheduled execution loop must optimise for governed state transition, not report production. Minimal reconciliation is allowed only to prove the intended action is still safe and current. A run that has adequate access and an already-known corrective action must attempt that action during the run.

Evidence of advancement is classified separately:

- **Implementation advancement:** exact commit/PR/runtime change plus exact-head validation.
- **Qualification advancement:** benchmark/profile state transition with semantic and safety results.
- **Data-admission advancement:** authoritative item-level or bounded-cohort proof from L2 fall-out through L3 outcome and deterministic admission/L4.
- **Consumer advancement:** Search/API projection delta or governed no-op proof tied to the admitted canonical change.

A report must not describe implementation/reconciliation work as data admission.

## Stop rule

The delivery outcome is governed admission, not parser count or scheduler activity. Bugs/security/tooling proceed in parallel. They block the primary track only when they affect authority, correctness, recoverability, secure execution or consumer integrity. A scheduler may stop without critical-path advancement only for a concrete external tool/API/quota/auth/approval boundary or a newly discovered governance/safety blocker that makes the intended action unsafe.

**NO DATA ADMISSION PROVEN** at the request-6326 handoff.
## 18 September 2026 — qualification/routing correction

Layer 4 is the governed terminal path after deterministic and AI-assisted resolution are exhausted. Safe Layer-3 abstention is therefore progress when it is durably handed to Layer 4 with Evidence and attempt context. The project must not wait for every tuition item to become an AI-positive result before proving bounded drain.
