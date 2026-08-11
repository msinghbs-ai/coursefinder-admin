# Coursefinder Running Build v1.9

## Current Phase
Phase 3 — Layer 1 Regulatory Pipeline: AU CRICOS Edge Function UAT.

## Current Runtime Boundary
- Cloudflare: React/Vite SPA delivery only.
- Supabase Auth: user authentication and Platform Admin identity.
- Supabase Edge Functions: Layer 1 execution and controlled Pilot reset.
- PostgreSQL: canonical catalogue, PIM, job state, reconciliation and Search Projection.
- Supabase Storage: private regulatory evidence.

## Completed
- Mumbai Pilot database and authenticated Admin UI.
- Phase 0A RLS/privilege hardening.
- Phase 1A Regulatory Settings.
- 26,738 CRICOS course records parsed from the current official dataset.
- Controlled 100-record dry-run passed.
- Controlled 100-record APPLY passed: 2 providers created, 95 courses created, 5 existing courses linked, 0 conflicts.
- Idempotency catalogue check passed: 100 CRICOS course registrations with no duplicate regulator-created courses.
- Previous Cloudflare Worker synchronous/async runtime path superseded by Supabase Edge Functions.
- `layer1-register-etl` Edge Function deployed with `verify_jwt=true` and Platform Admin authorization.
- `pilot-reset` Edge Function deployed with `verify_jwt=true` and Platform Admin authorization.
- Cloudflare config returned to static SPA delivery; Layer 1 service-role execution is no longer required in Cloudflare.

## Migration Status
Applied through migration **036**.

Migration 036 adds service-role-only:
- `public.svc_layer1_finalize_catalogue()` — rebuilds Search Projection and returns canonical catalogue statistics after Apply.
- `public.svc_layer1_reset_au_uat()` — removes only AU CRICOS UAT additions/registrations and restores the seeded catalogue boundary.

## Reset Cross-Check — PASSED
Before reset after controlled CRICOS Apply:
- Providers: 9
- Courses: 130
- CRICOS Course Registrations: 100
- CRICOS Provider Registrations: 2
- Search Documents: 35 — identified as stale derived state requiring post-Apply finalisation.

After `svc_layer1_reset_au_uat()`:
- Providers: **7**
- Courses: **35**
- CRICOS Course Registrations: **0**
- CRICOS Provider Registrations: **0**
- Search Documents: **35**
- Search Generation: **3**
- Deleted regulator-created Courses: 95
- Deleted regulator-created Providers: 2

Auth, PIM/reference/source configuration, Pipeline Job history and evidence were preserved.

## UI Controls
Settings → Regulatory Sources now supports:
1. Dry-run first 100.
2. Apply first 100 with explicit `APPLY 100` confirmation.
3. Re-run same 100 for idempotency.
4. Reset AU UAT with explicit `RESET AU UAT` confirmation.
5. Retained post-Apply statistics: Providers, Courses, CRICOS registrations, Search Documents and Search Generation.

## Immediate Gate
From the clean **7 Provider / 35 Course / 35 Search Document** baseline:
1. Run Edge Function Dry-run 100.
2. Run Edge Function Apply 100.
3. Verify catalogue statistics and Search Projection rise together.
4. Re-run the same 100 and confirm counts remain stable.
5. Then add CRICOS Locations + Course Locations and progress to larger/full AU ingestion.
