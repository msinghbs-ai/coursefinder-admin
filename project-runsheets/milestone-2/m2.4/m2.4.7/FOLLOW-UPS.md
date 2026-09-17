# M2.4.7 FOLLOW-UPS

| ID | Workstream | Status | Exact next action |
|---|---|---|---|
| M247-FU-001 | End-to-end automation | ACTIVE / PRIMARY | Queue foundation is deployed and the tuition handoff now preserves deterministic Layer 2 candidate context. Update the server Layer 3 execution path to consume that bounded candidate context, then qualify and dispatch only after benchmark PASS. |
| M247-FU-002 | Layer 3 task coverage | BLOCKING | Benchmark `provider_current_tuition_validation` as candidate + Evidence validation, not raw-Evidence extraction. Require semantic provider cases + safety controls to PASS before unpausing. |
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
| M247-FU-016 | Monitoring integrity | BLOCKING METRIC TRUST | Standardise hourly metrics on authoritative direct source tables/read model with timestamp + source identity so false backlog deltas cannot be reported as admission gains. |
| M247-FU-017 | Generic Layer 3 provenance | ACTIVE | 1,780 current `layer3_required` items have only generic blocker provenance. Add explicit unresolved-field/task provenance before any dispatch; do not infer task class from the generic marker. |
| M247-FU-018 | Tuition candidate lineage | IMPLEMENTED / VERIFY EXECUTION | Runtime + Pilot migrations add immutable `candidate_context` to Layer 3 work items and bind it to normalized extraction Evidence. Runtime reconciliation finds 610 explicit fee fall-out records with candidate lineage; 610 have proposed tuition and 598 retain fee-candidate arrays. Next: consume this context in `layer3-interpret` and its benchmark, enforcing output membership/no-strengthening validators. |
| M247-FU-019 | Gitar bounded self-resolution | ACTIVE SUPPORTING CONTROL | Use Gitar review/self-fix as the preferred first remediation path for ordinary implementation, lint/type, test, CI and non-authority UI defects when a PR is blocked. After any Gitar-generated commit, re-read the exact diff and exact-head CI/UAT before acceptance. Gitar must not weaken or autonomously redefine Layer 1 authority, identity, security/RLS/service-role boundaries, Evidence lineage, applied migration history, Layer 3 admission policy, Layer 4 routing, Search/publication authority, secrets or governance controls merely to make checks green. Security/data-authority/migration/governance-sensitive changes remain governed review gates. If Gitar cannot resolve a defect after one bounded repair cycle, return to root-cause diagnosis rather than repeatedly requesting equivalent fixes. |
| M247-FU-020 | Scheduler execution invariant | ACTIVE / BLOCKING CONTROL | Scheduled CF-247 runs are execution runs, not recurring analysis. Each Admission Watch run must either change critical-path code/runtime state or stop on a specific hard external blocker. Re-reading the same known blocker, repeating reconciliation, or reporting STALLED without attempting the next authorised implementation/execution step is a scheduler execution failure. Once a root cause is established, the next run must pick up that exact corrective step automatically. |
| M247-FU-021 | Admission proof contract | ACTIVE / REQUIRED FOR GATE ADVANCEMENT | A scheduler may claim data-admission progress only with authoritative before/after proof: L2 status delta, L3 work-item creation/reservation/result, deterministic admission or Layer-4 disposition, canonical field delta where admitted, and Search/API consumer projection delta or explicit governed no-op. Include item/entity identifiers or bounded cohort/run identifiers, Evidence lineage, timestamps, failure/retry counts, model/provider usage and resource/quota headroom. Code/CI/review progress must be reported separately from data-admission progress. |
| M247-FU-022 | Iteration carry-forward | ACTIVE / MANDATORY | Every non-terminal scheduled run must persist the exact next critical-path action and why it is next, so the following run continues from that action without rediscovering project history. When the current gate is not advanced, record the concrete attempted operation and blocker. When the gate advances, update RUNSHEET/CURRENT-STATE/FOLLOW-UPS/NEXT-CHAT as applicable so the next iteration begins at the new gate. |

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