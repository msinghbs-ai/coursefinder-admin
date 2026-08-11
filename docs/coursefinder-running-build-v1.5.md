# Coursefinder — Running Build v1.5

**Status:** Active Pilot build record  
**Environment:** `coursefinder_Pilot` — Mumbai (`ap-south-1`)  
**Supabase project ref:** `fxcwkweaxjtknorudmwp`  
**Pilot code:** `msinghbs-ai/Coursefinder-Pilot`  
**Architecture / planning / UAT records:** `msinghbs-ai/coursefinder-admin`

---

## Current Build Position

Coursefinder has completed the mandatory **Phase 0A — RLS / privilege hardening** gate and can proceed to Layer 1 Worker implementation while the remaining Phase 1 Admin UI continues in parallel.

Database migrations are now applied through **028**.

### Security validation after migration 028

- Internal domain tables checked: **76**.
- RLS enabled: **76 / 76**.
- RLS disabled: **0**.
- Internal tables directly accessible by `anon`: **0**.
- Internal tables directly accessible by `authenticated`: **0**.
- Internal schema `USAGE` revoked from browser roles.
- `service_role` access preserved for server/Worker processing.
- Existing `public.ui_*` authenticated RPC boundary remains operational.
- Anonymous execution of `public.ui_*` RPCs: **none**.

### Authenticated UI regression after hardening

Validated using the Pilot Platform Admin identity:

- role: `platform_admin`, rank 6;
- Providers: 7;
- Courses: 35;
- Search documents: 35;
- Attributes: 3;
- Regulatory Sources: 9;
- Dashboard/Search generation remains available;
- zero-row Pilot areas such as Jobs, Reviews, Campuses, Collections and Scholarships continue to return normally rather than failing permission checks.

### Security Advisor result

No Critical/Error findings remain for the Pilot application boundary.

Accepted INFO:

- `rls_enabled_no_policy` across internal schemas. This is intentional: browser roles have no internal schema/table access and consume curated RPC/API contracts instead. Do **not** add permissive policies simply to remove these INFO notices.

Accepted/known WARN:

- authenticated `SECURITY DEFINER` `ui_*` read functions. These are the intentional Pilot application boundary, have fixed search paths/auth checks, are not executable by `anon`, and remain read-only. Longer-term hardening can move these reads behind Edge/API contracts.
- Supabase Auth leaked-password protection is disabled. This is a project Auth setting and must be enabled before production readiness if supported by the selected Supabase plan/settings.

Reference remediation:

- RLS no policy: https://supabase.com/docs/guides/database/database-linter?lint=0008_rls_enabled_no_policy
- Authenticated SECURITY DEFINER: https://supabase.com/docs/guides/database/database-linter?lint=0029_authenticated_security_definer_function_executable
- Password security: https://supabase.com/docs/guides/auth/password-security#password-strength-and-leaked-password-protection

---

## Current Phase Status

- Phase 0 — Pilot Runtime Bootstrap: **Complete**
- Phase 0A — RLS / Privilege Hardening: **Complete**
- Phase 1 — PIM/Admin UI: **In Progress**
- Phase 1A — Regulatory Settings: **Implemented**
- Phase 3 — Layer 1 Regulatory Worker: **Next major functional build**

---

## Immediate Next Build Sequence

1. Build Layer 1 Worker framework and service-role source resolver integration.
2. Implement Australia CRICOS as the reference country adapter.
3. Add pipeline job/evidence/source-health telemetry.
4. Validate idempotent reruns and identity reconciliation.
5. Add remaining country adapters.
6. Continue Provider Detail / PIM Families / Attribute Groups / Options / Completeness Profiles / Evidence Viewer in parallel.
7. Expand canonical Pilot data once Layer 1 identity reconciliation is proven.

---

## Revision History

### v1.5
- Marks Phase 0A complete.
- Records migration 028.
- Records 76/76 RLS coverage and zero browser direct-table access.
- Records authenticated UI regression validation.
- Records accepted Security Advisor INFO/WARN findings and production Auth password-protection action.
