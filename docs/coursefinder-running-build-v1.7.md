# Coursefinder — Running Build v1.7

**Status:** Active Pilot build record  
**Environment:** `coursefinder_Pilot` — Mumbai (`ap-south-1`)  
**Supabase project ref:** `fxcwkweaxjtknorudmwp`  
**Pilot code:** `msinghbs-ai/Coursefinder-Pilot`

## Current Position

- Phase 0 Runtime: complete.
- Phase 0A RLS / privilege hardening: complete.
- Phase 1 PIM/Admin UI: in progress.
- Phase 1A Regulatory Settings: complete.
- Phase 3 Layer 1 Regulatory Worker: in progress and runtime-ready for AU dry-run UAT.

## Layer 1 Runtime Readiness

Health endpoint validated at `layer1-v0.1.1` with:

- `SUPABASE_URL`: present;
- `SUPABASE_SERVICE_ROLE_KEY`: present;
- `LAYER1_RUN_KEY`: present;
- static asset binding: present;
- `configured=true`.

Pilot PR #5 merged as `3f7c9221295f95d47e8775d38229f33382e34174`.

Worker version advances to `layer1-v0.1.2` and supports two trigger paths:

1. machine/operations trigger using `x-layer1-key`;
2. signed-in Platform Admin trigger using Supabase access token and server-side role validation.

The browser never receives `LAYER1_RUN_KEY` or the Supabase service-role key.

## Migration 032

`032_layer1_platform_admin_trigger_auth.sql` adds service-role-only `svc_layer1_authorize_platform_admin(user_id)`.

The function validates an active role rank of 6 or higher and honours role expiry.

## Regulatory Settings UI

Settings now includes **Run AU dry-run (100)**.

The action:

- uses the signed-in Supabase session;
- requests `country=AU`;
- forces `apply=false`;
- limits selection to 100 records;
- displays parsed/selected record count, evidence status and job reference;
- refreshes source health after completion.

Dry-run records evidence, job telemetry and source health but does not change canonical catalogue entities.

## Immediate Next Gate

1. Verify Cloudflare deployment of `3f7c922...`.
2. Confirm health endpoint reports `layer1-v0.1.2`.
3. Sign in as Platform Admin.
4. Open Settings → Regulatory Sources.
5. Run **AU dry-run (100)**.
6. Validate CRICOS discovery, Institutions/Courses CSV parsing, evidence object, content hashes, pipeline job and source-health telemetry.
7. If clean, perform controlled AU apply with 100 records.
8. Repeat the identical apply to prove idempotency before increasing scope.

## Repository Boundary

`Coursefinder-Pilot` remains code/runtime only. All design, migrations, UAT evidence, plans, guides and handover remain in `coursefinder-admin`.
