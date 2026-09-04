# CF-CHG-20260904-106 — Layer 1 Depth UAT Control RLS Hardening

**Status:** IMPLEMENTED / TARGETED PASS  
**Date:** 4 September 2026 (Australia/Sydney)  
**Milestone:** M2.4.5  

## Issue
`public._layer1_depth_uat_control` existed with RLS disabled and was surfaced by the Supabase security advisory path.

## Change
Pilot migration `20260904010329_enable_rls_layer1_depth_uat_control.sql` enables row-level security.

## Access verification
- RLS enabled: true;
- `anon` SELECT grant: false;
- `authenticated` SELECT grant: false;
- `service_role` SELECT grant: true;
- `service_role` has BYPASSRLS, preserving controlled worker/UAT access;
- no database functions currently reference `_layer1_depth_uat_control`.

No permissive browser policy was added. The resulting `RLS Enabled No Policy` INFO lint is intentional deny-by-default behaviour for this control table.

## Result
The prior exposed-table security condition is removed without opening an authenticated/browser read path or changing Layer 1 canonical data.
