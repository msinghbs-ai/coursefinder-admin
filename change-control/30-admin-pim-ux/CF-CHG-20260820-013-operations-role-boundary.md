# CF-CHG-20260820-013 — Admin operations role boundary and safe Sources projection

**Status:** DB/RPC/SECURITY PASS + v2.10 FRONTEND ROLE ALIGNMENT PASS — DEPLOYED ROLE-BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026  
**Origin:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Owner:** CourseFinder Admin/PIM governance

## Governed contract

- Review Queue: Curator+ (rank 3).
- Evidence: Curator+ (rank 3).
- Pipeline Control / Jobs / Sources: Pipeline Operator+ (rank 4).
- PIM Configuration: PIM Admin+ (rank 5).
- Browser reads enter through `public.admin_read`; internal-schema CRUD is not a browser contract.

Migrations 069/070 closed the original direct authenticated Review/Jobs compatibility-helper bypass and exposed a safe rank-4 Sources projection without source implementation configuration.

## Finalisation strengthening

`M1-PIM-FINALISATION` additionally proved and enforced:

- the v2.10 navigation uses the same rank thresholds as the server contracts;
- an authenticated identity with no CourseFinder role is rejected with SQLSTATE `42501` for Pipeline reads;
- all remaining `public.ui_*` `SECURITY DEFINER` compatibility helpers have browser `EXECUTE` revoked from `PUBLIC`, `anon` and `authenticated` and remain internal/service-compatible;
- Supabase security-advisor rerun no longer reports authenticated `SECURITY DEFINER` browser surfaces;
- the safe browser entrypoint remains `public.admin_read`.

## Browser acceptance still required

A real deployed Pipeline Operator account/browser walkthrough has not been fabricated. Final closure requires deployed verification that:

1. Pipeline menu visibility matches rank 4;
2. direct unauthorised navigation fails gracefully;
3. Jobs/Sources page, filter and Back/Forward behaviour work in the deployed browser;
4. the browser payload does not expose hidden source configuration.

## Closure

**Final status:** OPEN — deployed role-browser UAT pending.  
**Do not close from source/SQL evidence alone.**
