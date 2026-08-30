# Next Chat — M2.4.3 Final Corrective Integration, Acceptance & Closure

## Status at handoff

M2.4.2 is CLOSED / PASS under CF-CHG-20260827-044. Its addenda are reconciled in:
`project-runsheets/milestone-2/m2.4/m2.4.2/ADDENDA-CLOSURE-RECONCILIATION.md`.

Do not reopen M2.4.2 merely because standing addenda or deliberately carried follow-ups remain active.

M2.4.3 remains ACTIVE under CF-CHG-20260829-047.

Latest Pilot corrective source:
`eaab5a7b6fc7bfaddb2b6863e23f5033184fa4b7`.

Corrective runtime:
- migration `20260830011809_m2_4_3_acceptance_dashboard_timeout_hardening`;
- dashboard recent-activity expression indexes added with no output/access/authority semantic change;
- Evidence recent-activity top-10 plan verified on new index at ~3.25 ms execution.

Pre-gates:
- targeted deployed UAT `33285369673`: PASS;
- frontend build/local smoke `33285369676`: PASS.

Historical first final-acceptance attempt:
- acceptance marker `3a8a31310ea7147016374d6c818d08034ba0be64`;
- run `33284867253`: FAIL;
- desktop 50/50 PASS;
- mobile 48 PASS / 1 persistent failure;
- persistent failure was inherited Layer 2 provider-acquisition test observing `admin_read(operation=dashboard)` HTTP 500;
- Postgres logs proved statement timeouts on both attempts;
- one separate mobile performance miss recovered on retry;
- frontend build `33284867261`: PASS;
- failure remains immutable evidence.

## Mandatory start

1. Read `PROJECT_INSTRUCTIONS.md`.
2. Read `project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md`.
3. Read A1–A6 plus A7, A8, A10, A12, A13, A14 and A15.
4. Read `change-control/README.md`, `change-control/REGISTER.md`, and active `CF-CHG-20260829-047`.
5. Read latest Master Project Plan, Running Build, DB Architecture and Admin/PIM design decisions.
6. Read M2.4.2 `ADDENDA-CLOSURE-RECONCILIATION.md` so standing governance is not confused with an open M2.4.2 gate.
7. Read M2.4.3 `RUNSHEET.md`, `CURRENT-STATE.md`, `FOLLOW-UPS.md` and this file.
8. Reconcile current heads of `msinghbs-ai/coursefinder-admin` and `msinghbs-ai/Coursefinder-Pilot`.
9. Reconcile deployed Supabase migrations, Edge functions, cron/jobs, current Security/Performance Advisors and applicable Actions.
10. Repository/runtime truth is authoritative; do not rely on stale chat assumptions.

## Execution order

Proceed autonomously:

1. Confirm corrective source `eaab5a7b6fc7bfaddb2b6863e23f5033184fa4b7` remains current and no parallel source superseded it.
2. Nominate a new bounded integration candidate from this exact corrective lineage.
3. Run bounded integration desktop/mobile.
4. If bounded integration PASS:
   - recheck runtime/advisors/heads;
   - nominate one replacement final acceptance candidate;
   - run final acceptance desktop/mobile.
5. If final acceptance PASS:
   - CLOSE/PASS CF-CHG-20260829-047;
   - CLOSE/PASS M2.4.3;
   - update REGISTER, RUNSHEET, CURRENT-STATE, FOLLOW-UPS, NEXT-CHAT;
   - update Master Project Plan / Running Build / DB Architecture / Admin-PIM decisions where programme state changed;
   - preserve all historical failed-gate evidence;
   - only then assess whether M2.4.4 may begin.
6. If any gate fails:
   - retain exact failure as immutable evidence;
   - diagnose only the failing defect/contract;
   - do not weaken thresholds, authority, security, Evidence or test semantics merely to obtain PASS;
   - apply targeted correction and repeat the minimum required gate sequence.

## Boundaries that must not regress

- Layer 1 remains canonical identity/regulatory authority.
- Layer 2 remains deterministic source/Evidence authority.
- Layer 3 consumes governed Evidence and cannot directly rewrite canonical Layer 1/2 truth.
- Layer 4 remains terminal human resolution.
- Search/Publication/Zoho admission remains separately governed.
- A14 telemetry remains mandatory.
- A15 contact intelligence is CLOSED/PASS and must remain frozen/protected.
- RMIT 212-record promotion remains separately blocked pending an already-authorised exact frozen-set executor; do not invent a privileged bypass.
- NZ first-party Layer 2 enrichment remains deferred pending source qualification.
- A10 paging/tablet behaviour, A12 contextual granularity, A13 route/Evidence transparency and A8 release-note surface remain standing accepted behaviour.

## Long-running automation rule

If a bounded integration or final acceptance matrix is still running after the substantive work is complete and is expected to exceed about five minutes, do not hold the chat open just to wait.

Instead:
- record exact run IDs, head SHA, current stage and next decision rule in CURRENT-STATE/NEXT-CHAT;
- do not start a duplicate candidate while the run is active;
- finish the chat with the exact pickup point;
- the following chat checks those run IDs first.

## Closure condition

M2.4.3 is CLOSED only after:
- corrective bounded integration desktop/mobile PASS;
- replacement final acceptance desktop/mobile PASS;
- final runtime/advisor/head reconciliation;
- documentation/change-control reconciliation.

Do not start M2.4.4 before all four are true.
