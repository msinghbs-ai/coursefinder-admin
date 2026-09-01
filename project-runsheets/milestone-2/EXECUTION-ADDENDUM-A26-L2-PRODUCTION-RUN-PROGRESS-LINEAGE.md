# M2 Execution Addendum A26 — Layer 2 Production Run, Job, Evidence & Progress Lineage

**Status:** CLOSED / PASS — ACCEPTED M2.4.4 STANDING BEHAVIOUR
**Effective:** 1 September 2026  
**Primary Change Control:** `CF-CHG-20260830-048`  
**Applies to:** Layer 2 operator execution, Jobs & Runs, Evidence, Dashboard/operations scorecards, scheduling and production-readiness acceptance.

## Purpose

Finalise the Layer 2 operator execution model so the production action, its operator message, underlying run/job lifecycle, Evidence lineage and dashboard progress all describe the same governed workload.

This addendum extends A14, A17, A21, A23 and A25. It must not create a second Layer 2 execution path or regress the quota-aware background model already accepted under A23.

## A26.1 — Single production action

The normal Layer 2 workspace must expose one primary production-oriented action for the selected governed scope.

The action must:
- resolve Country / State / University scope from the Layer 1 catalogue;
- preview qualification, queueable Course count, provider quota/budget and accepted production wave before dispatch;
- create or resolve one governed parent run identity;
- dispatch qualification first only where required;
- dispatch the accepted production Course wave when eligible;
- schedule remaining eligible Courses automatically when policy permits;
- preserve duplicate/concurrent-run protection;
- never expose manual provider-by-provider or hard-coded Wave-1 controls as the primary production journey.

The button wording may evolve, but its semantics must be explicit: the operator is starting governed background Layer 2 production work, not a one-off browser scrape.

## A26.2 — Operator message contract

Immediately after action, the UI must return a concise, durable status message containing:
- parent run short ID;
- selected scope;
- execution phase: qualification / queued production / running production / waiting on quota / complete / blocked;
- dispatched-now count;
- scheduled remainder;
- next automatic action or scheduler responsibility;
- clear link to Jobs & Runs;
- clear link to Evidence when Evidence exists.

Messages must not imply completion merely because the initial request was accepted.

## A26.3 — Run / job alignment

A Layer 2 workload must use a stable parent-run identity across its lifecycle.

Every child job or scheduler continuation must retain enough lineage to reconcile to that parent run, including:
- parent run ID;
- scope and scope identifier;
- execution mode/profile;
- provider/acquisition route;
- wave/continuation sequence where applicable;
- status and timestamps;
- heartbeat/stale state;
- selected / processed / resolved / escalated / blocked / failed / unchanged counts where applicable;
- vendor units/cost/latency where supplied;
- retry/resume relationship.

Jobs & Runs must not display an unrelated generic job as the "current Layer 2 run" when an A26 parent run exists.

Historical job rows remain immutable execution evidence.

## A26.4 — Evidence alignment

Every Layer 2 Evidence artifact produced by an A26 workload must be attributable to:
- the governed parent run;
- the child job/provider attempt that produced it where applicable;
- Provider/Course/entity context where known;
- acquisition route and capture timestamp;
- Evidence type and MIME/format under A25.

The operator must be able to traverse:
`Layer 2 run → child job/attempt → Evidence`

and from an Evidence item back to its producing run/job context where that context exists.

No provider-wide or null/empty Evidence inheritance is permitted.

## A26.5 — Dashboard runtime progress

The canonical Dashboard / operations overview must expose meaningful runtime progress for Layers 1–4, with Layer 2 using the A26 parent run as authority when active.

At minimum Layer 2 runtime monitoring must show:
- phase and current status;
- parent run short ID;
- selected scope;
- target / selected / processed counts;
- resolved Layer 2;
- escalated to Layer 3;
- blocked / failed;
- current wave and scheduled remainder where applicable;
- percentage based on reconciled run counters, not decorative timers;
- last heartbeat / last progress timestamp;
- elapsed runtime;
- current acquisition route;
- vendor budget/units when supplied;
- Evidence artifact count for the run;
- next automatic action / scheduler state;
- blocker/retry state if operator intervention is required.

The Dashboard must distinguish:
- active runtime progress;
- queued/scheduled future work;
- terminal completion;
- stale/stuck work;
- historical totals.

Do not present a generic "Running" badge without progress context when measurable counters exist.

## A26.6 — Cross-surface consistency

For the same active Layer 2 run:
- Layer 2 workspace;
- Dashboard;
- Jobs & Runs;
- Evidence

must show consistent status, counts and lineage.

If a surface is using a different data grain, it must label that grain explicitly rather than presenting contradictory numbers.

## A26.7 — Production-readiness acceptance

A26 is not accepted until automated UAT proves:
1. one primary Layer 2 background-production action;
2. no primary manual hard-coded Wave-1/provider routing controls;
3. action response includes parent run identity and next scheduler behaviour;
4. parent run and child jobs reconcile;
5. Evidence links to the producing run/job lineage;
6. Dashboard shows measurable active Layer 2 runtime progress and scheduled remainder;
7. terminal run state reconciles across Dashboard, Layer 2, Jobs & Runs and Evidence;
8. stale/blocked state is visible without manufacturing progress;
9. desktop/tablet/mobile layout remains usable;
10. existing A14/A23/A25 telemetry, quota and Evidence integrity rules remain intact.

## A26.8 — Current implementation sequencing

At the time this addendum was recorded, Pilot candidate `aa824aa6abe943e6beebf4aaab361f29d54678ef` was under active A17–A25 bounded integration in deployed UAT run `33416346862`.

Do not push A26 implementation onto the Pilot branch until that run is terminal. Preserve the active integration evidence, then implement A26 from the settled repository/runtime head using targeted validation before any replacement integration/final-acceptance nomination.

## Non-goals

A26 does not authorise:
- Production environment cutover;
- broad Publication;
- Website/Zoho cutover;
- bypassing Layer 1 authority;
- autonomous Layer 3 AI execution beyond existing governed policy;
- deletion or rewriting of historical runs/jobs/Evidence.

## Closure disposition — 1 September 2026
- Accepted under closed `CF-CHG-20260830-048` / M2.4.4.
- Replacement final acceptance `33468512515` PASS on desktop and mobile.
- This addendum remains standing behavioural/governance guidance where applicable, but does not keep M2.4.4 open.
