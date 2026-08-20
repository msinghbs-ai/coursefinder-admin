# CourseFinder Pilot Governed RPC Recovery UAT — 20 August 2026

**Change Control:** `CF-CHG-20260820-015`  
**Origin:** `M1-PIM-FINALISATION — Admin/PIM Operational UI & Browser Acceptance Gate`  
**Runtime target:** `coursefinder-pilot.techm.workers.dev`  
**Deployment repository:** `msinghbs-ai/Coursefinder-Pilot`  
**Status:** **APPLIED — SOURCE/BUILD/DB CONTRACT PASS; DEPLOYED AUTHENTICATED BROWSER RETEST PENDING**

## 1. Runtime failure confirmed

Fresh authenticated browser evidence at approximately 20 August 2026 18:22 AEST showed the deployed Pilot still rendering the legacy shell labelled `UI v1.7.2` and reporting `permission denied for function ui_context`.

Supabase API telemetry from the same retest proved direct legacy browser calls after the earlier `coursefinder-admin/main` redeploy trigger, including:

- `/rest/v1/rpc/ui_context` — 403;
- `/rest/v1/rpc/ui_dashboard` — 403;
- `/rest/v1/rpc/ui_provider_filter_options` — 403;
- `/rest/v1/rpc/ui_courses_decision_page` — 403;
- `/rest/v1/rpc/ui_course_filter_options` — 403;
- `/rest/v1/rpc/ui_qilt_outcomes_page` / `ui_qilt_filter_options` — 403;
- `/rest/v1/rpc/ui_prisms_student_flow_page` / `ui_prisms_filter_options` — 403;
- `/rest/v1/rpc/ui_attributes_list` — 403.

This reclassified the runtime blocker from “post-trigger state unproven” to **confirmed deployment-source mismatch**.

## 2. Deployment-source mismatch

The live Worker name is governed by the separate Pilot repository:

`msinghbs-ai/Coursefinder-Pilot/wrangler.jsonc` → `name = "coursefinder-pilot"`.

The stale Pilot `main` at `464f9c3c3a6634daca9783f8b00048950eca4719` still contained UI v1.7.2 and direct `ui_*` browser calls.

The governance repository `coursefinder-admin` uses a different Worker name (`coursefinder-admin`), so no-content commits there could not replace the `coursefinder-pilot` bundle.

## 3. Governed recovery implementation

Recovery branch:

`fix/governed-admin-read-recovery-20260820`

Pilot PR:

`msinghbs-ai/Coursefinder-Pilot#12`

Applied changes are intentionally limited to two browser-facing files:

- `src/lib/supabase.js` — all database reads now enter through `public.admin_read(text,jsonb)`; legacy `ui_*` browser RPC calls were removed from the API adapter;
- `index.html` — visible `Governed RPC recovery r1` marker added so deployed UAT can correlate the served bundle.

Edge Function operational writes remain unchanged. No Supabase migration, ACL, canonical data, Provider/Course identity, source authority or Search admission changed.

Provider/Course legacy filter-option selectors that do not yet have a governed `admin_read` filter-options contract are intentionally returned as non-authoritative empty option sets rather than reopening retired RPC permissions. Search, list paging and exact identity reads remain available through the governed catalogue page operations.

## 4. Source / build gate

`Pilot Frontend Build` GitHub Actions run #84 completed successfully for recovery head:

`a27c74543456f73be9159ea8b1772188da3330fc`

Result: **PASS**.

PR source review confirmed the database adapter now calls only:

`supabase.rpc('admin_read', { p_operation, p_args })`

for browser database reads. No direct browser `rpc('ui_*', ...)` call remains in `src/lib/supabase.js`.

## 5. Live DB contract UAT

A bounded authenticated Platform Admin transaction exercised the exact operations used by the recovery adapter without mutating data.

| Operation | Result |
|---|---|
| `context` | `platform_admin` — PASS |
| `dashboard` | Providers = 3,085 — PASS |
| `providers_page` exact `00025B` | total = 1 — PASS |
| `courses_page` exact `121174E` | total = 1 — PASS |
| `qilt_outcomes` | 1 bounded item returned — PASS |
| `qilt_filters` | years/metrics/surveys/statuses/providers keys returned — PASS |
| `prisms_student_flow` | 1 bounded item returned — PASS |
| `evidence_page` | 1 bounded item returned — PASS |
| `reviews_page` | valid empty result in sampled state — PASS |
| `attributes` | governed attributes payload returned — PASS |
| `jobs` | 1 bounded item returned — PASS |
| `sources` | 54 rows returned — PASS |

The transaction was rolled back.

## 6. Production publication

After the recovery branch build passed and `Coursefinder-Pilot/main` was rechecked for parallel movement, `main` was fast-forwarded without force from:

`464f9c3c3a6634daca9783f8b00048950eca4719`

to:

`a27c74543456f73be9159ea8b1772188da3330fc`

at approximately 20 August 2026 18:33 AEST.

GitHub records PR #12 as merged at the same head. This update is intended to trigger the existing Cloudflare Git integration for the actual `coursefinder-pilot` Worker.

## 7. Remaining runtime gate

Cloudflare control-plane access is not available in this execution environment, so repository publication alone is not represented as proof that the Worker has completed deployment.

A fresh authenticated browser hard refresh must now prove:

1. the visible `Governed RPC recovery r1` marker is served;
2. Dashboard data loads without `ui_context` permission errors;
3. Supabase telemetry shows `/rest/v1/rpc/admin_read` rather than direct `/rpc/ui_*` calls;
4. Providers and Courses load;
5. exact Provider `00025B` and Course `121174E` succeed through the browser;
6. QILT, PRISMS, Attributes, Evidence, Review Queue and Jobs either load governed data or their correct governed empty/permission state;
7. no legacy SECURITY DEFINER ACL is reopened.

## Verdict

**Recovery source/build:** PASS  
**Governed DB contract:** PASS  
**Pilot main publication:** APPLIED  
**Supabase ACL rollback:** NOT PERFORMED  
**Deployed authenticated browser:** PENDING FRESH RETEST  
**Overall `CF-CHG-20260820-015`: remains BLOCKED until the fresh deployed browser telemetry passes**
