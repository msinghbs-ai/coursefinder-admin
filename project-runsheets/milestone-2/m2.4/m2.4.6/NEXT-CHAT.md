# M2.4.6 NEXT CHAT

## Active baseline — 15 September 2026

Start from repository/runtime truth. Follow `PROJECT_INSTRUCTIONS.md` and `docs/README.md` first.

Primary programme reference:

`project-runsheets/milestone-2/m2.4/M2.4.6-M2.4.9-OPERATIONS-PLAN.md`

Active sub-milestone continuity:

- `project-runsheets/milestone-2/m2.4/m2.4.6/RUNSHEET.md`
- `project-runsheets/milestone-2/m2.4/m2.4.6/CURRENT-STATE.md`
- `project-runsheets/milestone-2/m2.4/m2.4.6/FOLLOW-UPS.md`

Accepted predecessor baseline:

- M2.4.5: CLOSED / PASS / FROZEN;
- CF-245: CLOSED / PASS;
- Pilot main: `e62c01cadaf43efa8c3d8ea57625c23874d1b010`;
- Pilot Supabase: `fxcwkweaxjtknorudmwp`;
- visible accepted release: v2.15.79 / package 0.1.6;
- dedicated CF-245 UAT `34926246733`: PASS;
- generic targeted UAT `34926246675`: PASS;
- build/smoke `34926246673`: PASS;
- Production is not provisioned and M2.5 remains paused until M2.4.9 GO.

## Active objective

Execute **M2.4.6 — Production Operations Model**. Prove how the platform is operated day to day before scaling it.

## Exact continuation sequence

1. Reconcile current scheduler/dispatcher/run-item/provider-attempt/Evidence/telemetry implementation against Gate B of the M2.4.6 RUNSHEET.
2. Document the existing dispatcher/wave owner, scope eligibility, Evidence reuse-first path, deterministic L2 path, bounded L3/L4 handling and stop conditions.
3. Reconcile retry, parking, stale recovery, idempotency, quota/cost and concurrency controls.
4. Separate existing capability from genuine gaps; do not redesign working accepted paths.
5. Open a new Change Control only for material implementation gaps.
6. Prove the completed operating model on bounded qualified AU work, then close/freeze M2.4.6 for M2.4.7 controlled scale.

Do not reopen CF-093. Do not use M2.4.6 for broad AU/NZ scaling, consumer integration work or Production provisioning; those belong to M2.4.7, M2.4.8 and M2.4.9/M2.5 respectively.
