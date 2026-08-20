# CF-CHG-20260820-013 — Admin operations role boundary and safe Sources projection

**Status:** **CLOSED / PASS — SHARED PIM GATE ACCEPTED; PIPELINE-SPECIFIC FOLLOW-ON TRANSFERRED TO CF-CHG-20260821-016**  
**Category:** `30-admin-pim-ux`  
**Initiated:** 20 August 2026  
**Origin:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Owner:** CourseFinder Admin/PIM governance  
**Reconciled:** 21 August 2026 09:04 AEST

## Governed contract

- Review Queue: Curator+ (rank 3).
- Evidence: Curator+ (rank 3).
- Pipeline Control / Jobs / Sources: Pipeline Operator+ (rank 4).
- PIM Configuration: PIM Admin+ (rank 5).
- Browser reads enter through `public.admin_read`; internal-schema CRUD is not a browser contract.

Migrations 069/070 closed the original direct authenticated Review/Jobs compatibility-helper bypass and exposed a safe rank-4 Sources projection without source implementation configuration.

## Finalisation strengthening

`M1-PIM-FINALISATION` additionally proved and enforced:

- the accepted Admin navigation uses the same rank thresholds as the server contracts;
- an authenticated identity with no CourseFinder role is rejected with SQLSTATE `42501` for Pipeline reads;
- all remaining `public.ui_*` `SECURITY DEFINER` compatibility helpers have browser `EXECUTE` revoked from `PUBLIC`, `anon` and `authenticated` and remain internal/service-compatible;
- Supabase security-advisor regression no longer exposes authenticated `SECURITY DEFINER` browser surfaces;
- the safe browser entrypoint remains `public.admin_read`;
- the deployed v2.11 browser uses governed `/rpc/admin_read` traffic rather than direct legacy `ui_*` browser calls.

## Governance reconciliation

The original version of this record remained textually `OPEN — deployed role-browser UAT pending`, while the authoritative register, Master Project Plan v1.54, Running Build v2.58 and final shared browser Change Control `CF-CHG-20260820-015` classified the common PIM browser gate as CLOSED / PASS.

That mismatch is now resolved explicitly rather than allowing future workstreams to infer precedence.

`CF-CHG-20260820-013` is closed for the scope it introduced: the rank boundary, safe Sources projection, governed browser read boundary and PIM finalisation integration.

The earlier requirement for a dedicated Pipeline Operator browser walkthrough is not discarded. It is transferred to the dedicated follow-on workstream `M1-PIPELINE-OPS` under `CF-CHG-20260821-016`, where it can be tested against the actual Pipeline Operations capability rather than reopening the accepted PIM finalisation release.

## Follow-on boundary transferred to M1-PIPELINE-OPS

The following are now owned by `CF-CHG-20260821-016` if/when Pipeline Operations advances beyond the accepted read-only visibility contract:

1. deployed rank-4 Pipeline Operator browser acceptance for Pipeline Control / Jobs / Sources;
2. filter, paging, exact Job identity and Back/Forward behaviour in the operational workspace;
3. proof that rank-4 payloads do not expose hidden source credentials or implementation configuration;
4. any retry, replay, cancel, schedule, enable/disable or other pipeline mutation action;
5. server-side role checks, idempotency, double-click protection, busy state and audit/evidence requirements for such actions;
6. Source → Job → Evidence relationships where operational navigation is added.

## Closure evidence

- `CF-CHG-20260820-015` — CLOSED / PASS;
- `docs/uat/coursefinder-pim-admin-v2.11-final-browser-acceptance-2026-08-20.md` — PASS;
- `docs/coursefinder-running-build-v2.58.md` — M1-PIM-FINALISATION CLOSED / PASS;
- `docs/coursefinder-master-project-plan-v1.54.md` — shared PIM gate CLOSED / PASS;
- `change-control/REGISTER.md` — authoritative index reflects closure.

## Closure

**Final status:** **CLOSED / PASS.**  
**Residual Pipeline Operations acceptance is carried forward by `CF-CHG-20260821-016`; it is not a reason to reopen the accepted PIM v2.11 release.**
