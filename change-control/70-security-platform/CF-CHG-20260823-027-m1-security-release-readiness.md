# CF-CHG-20260823-027 — M1 Security, ACL & Release Readiness Gate

**Status:** **IN PROGRESS**  
**Category:** `70-security-platform`  
**Initiated:** 23 August 2026 16:24 AEST (UTC+10)  
**Origin:** CourseFinder chat — `12. M1-SECURITY-RELEASE`  
**Owner:** CourseFinder security/platform governance  
**Affected surfaces:** `80-uat-release-operations`, Admin/PIM, Pipeline, Evidence, Search/publication, Supabase Auth/RBAC/RLS/Storage/Edge Functions, Zoho boundaries  
**Change class:** final security/ACL/release closure audit

## 1. Requested outcome

Perform the independent Milestone 1 release-security closure gate against the actual deployed Pilot after PIM, Pipeline, Evidence, Search/publication and documentation work.

Audit browser-executable RPCs, `SECURITY DEFINER` functions, grants, role/rank enforcement, RLS, Storage, Evidence, Edge Functions, secrets, compatibility surfaces, anon/authenticated exposure, publication APIs, Zoho boundaries, leaked-password protection and Supabase advisors. Run authorised and negative UAT. Remove obsolete diagnostic/UAT/temporary surfaces before PASS.

## 2. Reconciled baseline

Governance baseline at initiation:

- Master Project Plan v1.64;
- Running Build v2.66;
- Database Architecture v2.10.40;
- Admin/PIM Design Decisions v1.13;
- User Guide v2.0;
- PIM Admin Guide v1.15;
- Operations Runbook v1.0;
- Change Control Register current through `CF-CHG-20260823-025` at the initial read;
- subsequent reconciliation found parallel Performance work already owns `CF-CHG-20260823-026` and Pilot `main` had advanced to `1bcb96d26f7c701ec6cf91d771016cb6405f51b2`.

This record therefore uses `CF-CHG-20260823-027`; the transient duplicate 026 security record is being removed without altering the legitimate Performance record.

Known overlapping security control:

- `CF-CHG-20260823-022` — Supabase leaked-password protection — **DEFERRED FOR PILOT / MANDATORY PRODUCTION GO-LIVE GATE**.

## 3. Initial live audit findings

Live project: `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`).

Initial security-advisor run retains the known `auth_leaked_password_protection` WARN plus INFO-only `RLS enabled / no policy` findings on private/internal schemas.

Initial RPC catalogue confirmed the intended browser boundary `public.admin_read(text,jsonb)` was authenticated-only, but two legacy `public.ui_providers_page(...)` compatibility overloads were still directly executable by `authenticated`. Current Admin browser code uses `admin_read` only and repository search found no current browser reference to those overloads.

Applied live migration `20260823062726_m1_security_release_remove_legacy_provider_rpc`, dropping both obsolete overloads. Post-change live enumeration returns exactly one browser-executable application RPC in `public`: `public.admin_read(text,jsonb)`; anon EXECUTE remains denied.

Initial Edge Function inventory shows numerous active diagnostic/UAT/probe surfaces (including `pilot-reset`, `layer1-runtime-uat`, `layer1-depth-uat`, `cricos-depth-inspect`, `layer1-au-full-gate`, `layer1-nz-source-inspect`, `layer1-nz-gate-uat`, `search-vector-gate`, and multiple CA `*-probe` / `*-audit` functions). This must be reconciled before PASS because the gate explicitly requires diagnostic/UAT surfaces to be removed or explicitly proven to be required governed runtime surfaces.

## 4. UAT plan

- enumerate every browser-executable RPC and direct table/view exposure;
- verify server-side rank checks for Admin, Evidence, Pipeline, PIM Configuration, Access Admin and publication controls;
- prove anon and lower-rank negative cases;
- verify service-only helpers remain unavailable to browser roles;
- inspect RLS and Storage bucket/policy state;
- audit active Edge Functions, JWT/custom-auth boundary and diagnostic/UAT residue;
- verify publication and Zoho consumer boundaries remain unpublished/private unless explicitly admitted;
- rerun Supabase security advisors after any DDL/ACL correction;
- record residual accepted risks and final PASS/BLOCKED/DEFERRED state.

## 5. Rollback

The compatibility cleanup can be reversed by recreating the two wrapper overloads that delegated to `public.admin_read`, but they should not be restored unless a governed consumer still requires them. The accepted `public.admin_read(text,jsonb)` contract and current role semantics are unchanged.

Edge Function retirement must preserve accepted source-ingestion production adapters and newer parallel work. No Edge Function will be overwritten merely to satisfy this gate without reconciling current ownership and runtime dependencies.

## 6. Status

**IN PROGRESS.** Final closure is not yet claimed.
