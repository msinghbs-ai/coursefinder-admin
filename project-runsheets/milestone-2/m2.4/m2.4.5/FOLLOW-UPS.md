# M2.4.5 FOLLOW-UPS

| ID | Workstream | Item | Status | Exact next action |
|---|---|---|---|---|
| M245-FU-032 | CF-093 / large-university L2 | UQ/RMIT corrective acceptance | **CLOSED / SUPERSEDED BY ACCEPTED IMPLEMENTATION** | Historical only; do not reopen CF-093. |
| M245-FU-033 | CF-093 / repo-runtime currentness | Accepted runtime/repository state | **CLOSED / PASS** | Preserve immutable applied migration identities and accepted v2.15.79 baseline. |
| M245-FU-040 | CF-093 / reconstruction | Ordered migration replay | **CLOSED / PASS** | Re-run only under a future Change Control if a new migration change requires it. |
| M245-FU-034 | CF-093 / Codex | Exact-head review | **CLOSED** | Historical assurance evidence retained. |
| M245-FU-044 | CF-093 / targeted recovery CI | Targeted contracts | **CLOSED / PASS** | Historical evidence retained. |
| M245-FU-045 | CF-093 / Frontend + smoke | Build/browser smoke | **CLOSED / PASS** | Historical evidence retained. |
| M245-FU-055 | CF-093 / continuation recovery | Bounded retry behaviour | **CLOSED / ACCEPTED** | Preserve behaviour as platform baseline. |
| M245-FU-056 | CF-093 / detail identity drift | Fail closed before candidate write | **CLOSED / ACCEPTED** | Preserve behaviour as platform baseline. |
| M245-FU-057 | CF-093 / Preview resolver provenance | Exact Preview token provenance | **CLOSED / ACCEPTED** | Preserve behaviour as platform baseline. |
| M245-FU-058 | CF-093 / terminal freshness | Layer 1 identity invalidates terminal freshness | **CLOSED / ACCEPTED** | Preserve behaviour as platform baseline. |
| M245-FU-059 | CF-093 / mixed handoff | Preserve valid pre-existing queueable URLs | **CLOSED / ACCEPTED** | Preserve behaviour as platform baseline. |
| M245-FU-060 | CF-093 / worker deployment | Reviewed/deployed worker currentness | **CLOSED / ACCEPTED** | Future worker changes require their own Change Control where material. |
| M245-FU-053 | CF-093 / UQ workflow | Historical workflow-dispatch blocker | **CLOSED / NO LONGER ACTIVE** | Do not revive this blocker or CF-093. |
| M245-FU-035 | Layer 3 | Separate governed Layer 3 | **SEPARATE WORKSTREAM** | Route future Layer 3 work under its own active/new Change Control. |
| M245-FU-036 | AU qualification wave | Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW | **AVAILABLE FOR SEPARATE GOVERNED WORK** | Fold relevant AU coverage work into CF-245 only where it serves the approved operational-enrichment plan; otherwise retain separate scope. |
| M245-FU-061 | Runtime operations | Metrics and performance monitoring | **ACTIVE / OWNED BY CF-245** | Implement common hourly/daily enrichment funnel reporting with field-level coverage, latency, Evidence, failures and cost/yield. |
| M245-FU-063 | CF-245 telemetry | 245 successful acquisitions produced no item-level telemetry and zero canonical mutation authorisation | **ACTIVE / PRIORITY 1** | Reconcile the 245 jobs across attempts, Evidence, extraction/candidate/admission and publication stores; count exact stop reasons. |
| M245-FU-064 | CF-245 admission | `canonical_mutation_authorised=false` reason visibility | **ACTIVE** | Add/derive governed reason codes and counts for capture-only, no extraction, no eligible field, unchanged, identity/authority/Preview gate, L3/L4 requirement, publication ineligibility and runtime/provider blockers. |
| M245-FU-065 | CF-245 demand | AU/NZ missing/stale enrichment backlog | **ACTIVE** | Classify missing/stale official URL, intake, English, provider-current tuition and scholarship coverage as queueable, blocked, not-applicable or awaiting qualification. |
| M245-FU-066 | CF-245 coverage | Pilot-sized refresh-policy footprint | **ACTIVE** | Expand bounded AU/NZ refresh/work policies only after telemetry proves the path; retain country/source qualification and provider guardrails. |
| M245-FU-067 | CF-245 publication | Evidence-to-consumer reconciliation | **ACTIVE** | Trace Evidence → extracted candidate → admitted fact → Search/publication → website/API-visible field and measure deltas. |
| M245-FU-068 | CF-245 Admin reporting | Enrichment Operations report/dashboard | **PLANNED** | Keep Scheduled Tasks for scheduler health/config; add outcome-focused backlog, throughput, field coverage, yield, blocker/error and cost reporting with job/Evidence drill-down. |
| M245-FU-069 | CF-245 tuning | Evidence-led dispatcher/provider tuning | **BLOCKED UNTIL METRICS** | Do not change frequency/concurrency first; tune batch/wave/concurrency/routing/retries/cost ceilings only from comparable before/after evidence and audited tuning events. |
| M245-FU-062 | Country/source expansion | Canada and future countries/sources | **FUTURE / NEW CHANGE CONTROL REQUIRED** | Do not mix Canada/future-country onboarding into CF-245 AU/NZ operational completion unless separately approved. |
| M245-FU-008 | H7 | Production migration data/telemetry freshness | ACTIVE | Production remains unprovisioned. |
| M245-FU-009 | H8 | Further Addenda/Bugs/Features | ACTIVE | Route material items through Change Control. |
| M245-FU-010 | H9 | Faster UAT | OPEN | Retain targeted → bounded → nominated broad acceptance. |
| M245-FU-011 | H10 | Meeting/status evidence | ACTIVE | Maintain exact heads, runtime/UAT evidence and blockers. |
| M245-FU-027 | H14 / CF-207 | External-consumer API-key lifecycle | OPEN / GOVERNED | Continue separately. |

## Current priority — 15 September 2026

1. CF-093 remains CLOSED / PASS / historical only.
2. Execute CF-245 Gate A/B first: make real enrichment outcome measurable before tuning scheduler frequency/concurrency.
3. Explain the recent 245-acquisition / 245-Evidence / zero-canonical-mutation pattern with exact reason counts.
4. Generate governed AU/NZ missing/stale demand and expand bounded coverage only after telemetry is trustworthy.
5. Reconcile consumer-visible coverage from Evidence to publication.
6. Keep M2.5 paused and Production unprovisioned.
