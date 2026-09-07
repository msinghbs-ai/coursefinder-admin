# CF-CHG-20260907-236 — Remaining Pre-Production RPC Security Hardening

**Status:** CLOSED / BOUNDED SECURITY PASS  
**Milestone:** M2.4.5  
**Type:** SECURITY / PRE-PRODUCTION HARDENING  
**Initiated:** 7 September 2026  
**Closed:** 7 September 2026  
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

A non-exposed `admin_api` schema now holds the five privileged implementations. Their existing internal authentication/rank/budget/data checks are retained and the same public signatures are exposed only as `SECURITY INVOKER` wrappers. Public/anon execution remains revoked; authenticated/service-role execution is explicit.

The two deterministic Scholarship normalisation helpers now have an explicit `pg_catalog` search path.

No authority rank, Scholarship eligibility semantics, AI budget/profile rule, publication state, Statistics dataset semantics, canonical identity, Search projection or UI behaviour changed.

## Source implementation

Pilot replay migration:

`supabase/migrations/20260907004500_cf_236_preproduction_rpc_security_hardening.sql`

Source/runtime head: `fc9734f4fa1fd3364a7821af7e096d1da560e029`.

## Acceptance evidence

- Pilot migration `cf_236_preproduction_rpc_security_hardening`: applied successfully.
- Runtime introspection: all five `public` wrappers are `SECURITY INVOKER`; matching `admin_api` implementations remain `SECURITY DEFINER`; ACLs contain no anon execute grant.
- Supabase Security Advisor after the migration: **0 WARN findings**. Remaining findings are INFO-level RLS/no-policy notices for direct-table-denied schemas; no permissive policy was introduced merely to silence the advisor.
- Pilot Frontend Build: run `34070155296` — **PASS**.
- CourseFinder Deployed UAT: run `34070155325` — **PASS**, targeted desktop tier.
- Performance Advisor: only INFO-level existing index/FK/auth-allocation observations; no WARN/ERROR introduced by this change.
- Impact analysis did not identify browser/contract changes in the accepted Scholarship or Statistics functional surfaces, so those accepted gates were not broadened unnecessarily.
- No visible release promotion was made because the correction is security-boundary-only.

## Closure decision

CF-236 is **CLOSED / BOUNDED SECURITY PASS**. The pre-production security-advisor WARN gate is green. Any future direct-table/RLS or index optimisation work must be treated as separately governed changes rather than by weakening the current RPC-mediated access model.

## Rollback

If later regression evidence identifies an issue, restore the original public function definitions from their owning migrations and remove only the new `admin_api` overloads after dependency verification. Do not modify Scholarship run/settings data, Statistics registry data, canonical catalogue records, publication decisions or audit history as part of rollback.
