# M2.4.6 FOLLOW-UPS

| ID | Workstream | Status | Exact next action |
|---|---|---|---|
| M246-FU-001 | Dispatcher / waves | ACTIVE | Reconcile existing dispatcher, scheduler and wave creation/selection paths; identify exact runtime owner and eligibility gates. |
| M246-FU-002 | Evidence reuse | ACTIVE | Verify reuse-first behaviour and when a new provider acquisition is permitted versus existing Evidence replay. |
| M246-FU-003 | Layer authority | ACTIVE | Reconcile deterministic L2, bounded L3 and L4 escalation/stop conditions; preserve fail-closed authority. |
| M246-FU-004 | Retry / parking / stale recovery | ACTIVE | Map retry classes, retry ceilings, parked/blocked states, stale recovery and idempotent replay contracts. |
| M246-FU-005 | Quota / cost controls | ACTIVE | Reconcile provider budgets, rate/concurrency controls, paid-attempt ceilings and operator-visible stop reasons. |
| M246-FU-006 | Operator ownership | ACTIVE | Determine task/wave creator/owner attribution, deleted-user handling and practical operator intervention/audit requirements. |
| M246-FU-007 | Metrics | ACTIVE | Use accepted CF-245 hourly coverage/outcome telemetry; add only missing run/wave attribution needed for operations. |
| M246-FU-008 | AU bounded exercise | BLOCKED ON GATE B–E | Run representative qualified AU operation only after operating contract is explicit. |
| M246-FU-009 | NZ operation | BLOCKED ON QUALIFICATION | Do not copy AU assumptions; operate NZ only when governed source/profile/discovery/policy qualification exists. |
| M246-FU-010 | Scale | DEFERRED | Broad provider/state/country scale belongs to M2.4.7. |
| M246-FU-011 | Consumer/support readiness | DEFERRED | Website/API/support operationalisation belongs to M2.4.8. |
| M246-FU-012 | Production rehearsal | DEFERRED | Environment/rollback/full rehearsal belongs to M2.4.9. |

## Guardrails

CF-093 remains closed. CF-245 is accepted predecessor evidence. M2.5 and Production remain paused. Any material implementation gap discovered during M2.4.6 must be routed through a new Change Control and the applicable troubleshooting/recovery protocol when defect-like.
