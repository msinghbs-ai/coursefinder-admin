# CF-CHG-20260907-236 — Remaining Pre-Production RPC Security Hardening

**Status:** ACTIVE / BOUNDED SECURITY GATE  
**Milestone:** M2.4.5  
**Type:** SECURITY / PRE-PRODUCTION HARDENING  
**Initiated:** 7 September 2026  
**Primary owner:** 70-security-platform  
**Predecessor:** CF-235 Layer 4 public RPC security-boundary hardening

## Trigger

After CF-235 removed the Layer 4 exposed `SECURITY DEFINER` warnings, the Pilot Supabase Security Advisor retained a bounded set of WARN findings:

- `public.scholarship_ai_run_status(uuid)` — anon/authenticated callable `SECURITY DEFINER`;
- `public.scholarship_ai_settings_write(text,jsonb)` — anon/authenticated callable `SECURITY DEFINER`;
- `public.scholarship_runtime_settings_write(jsonb)` — authenticated callable `SECURITY DEFINER`;
- `public.statistics_dataset_registry_read()` — authenticated callable `SECURITY DEFINER`;
- `public.statistics_dataset_registry_write(jsonb)` — authenticated callable `SECURITY DEFINER`;
- `scholarship.normalise_first_party_url(text)` — mutable `search_path`;
- `scholarship.normalise_title(text)` — mutable `search_path`.

## Governed correction

Create a non-exposed `admin_api` schema, move the five privileged implementations into it, preserve their existing internal authentication/rank/budget/data checks, and recreate the same public signatures as `SECURITY INVOKER` wrappers. Public/anon execution remains revoked; authenticated/service-role execution is explicit.

Fix the two deterministic Scholarship normalisation helpers with an explicit `pg_catalog` search path.

No authority rank, Scholarship eligibility semantics, AI budget/profile rule, publication state, Statistics dataset semantics, canonical identity, Search projection or UI behaviour is changed.

## Source implementation

Pilot replay migration:

`supabase/migrations/20260907004500_cf_236_preproduction_rpc_security_hardening.sql`

Initial source commit: `fc9734f4fa1fd3364a7821af7e096d1da560e029`.

## Required acceptance

1. Apply migration to Pilot runtime.
2. Confirm public wrappers are `SECURITY INVOKER`, private implementations remain `SECURITY DEFINER`, and anon cannot execute them.
3. Re-run Supabase Security Advisor; the seven bounded WARN findings above must be absent.
4. Run a deployed targeted desktop smoke on the new Pilot head.
5. Re-run the relevant Scholarship/Statistics functional gates only if impact analysis shows browser or contract code changed. Do not broaden automatically.
6. No visible version promotion unless browser-visible behaviour changes.

## Rollback

Restore the original public function definitions from their owning migrations and remove only the new `admin_api` overloads after dependency verification. Do not modify Scholarship run/settings data, Statistics registry data, canonical catalogue records, publication decisions or audit history as part of rollback.
