# Coursefinder — Admin Guide v1.2

> **Pilot environment:** Mumbai (`ap-south-1`)  
> **Audience:** Curator, Pipeline Operator, PIM Admin and Platform Admin

---

## Security Model After Phase 0A

Coursefinder uses a deny-by-default browser model.

`Browser user → authenticated public RPC/API → internal domain schemas`

The browser does **not** access `ref`, `catalogue`, `pim`, `scholarship`, `integration`, `pipeline`, `search`, `publishing`, `workflow` or `security` tables directly.

### Current controls

- all 76 internal domain tables have RLS enabled;
- `anon` has no direct internal table access;
- `authenticated` has no direct internal table access;
- browser roles do not have internal schema usage;
- `service_role` is reserved for trusted server/Worker operations;
- `public.ui_*` read RPCs remain the current authenticated Pilot UI boundary;
- `anon` cannot execute those RPCs;
- Platform Admin Regulatory Settings performs server-side role enforcement.

### Why many tables show “RLS enabled, no policy”

This is intentional. These schemas are server-owned and are not meant to expose row-level browser policies. Do not create permissive `SELECT true` policies merely to silence Supabase Advisor INFO messages.

### SECURITY DEFINER warning

Supabase Advisor reports WARN for authenticated `SECURITY DEFINER` `ui_*` functions. In the Pilot these are intentional read-only contracts required to cross the deny-by-default internal schema boundary. Keep fixed `search_path`, explicit grants, authentication/role checks and read-only behaviour. Reassess them when the production Edge/API boundary is implemented.

### Password protection follow-up

Supabase Auth leaked-password protection is currently disabled. Enable it before production sign-off where supported by the selected plan/project settings.

---

## Platform Admin — Regulatory Settings

Settings → Regulatory Sources remains Platform Admin-only.

Layer 1 source resolution follows:

`Country → approved regulatory source(s) → trust order → system configuration → runtime secret → country adapter`

Workers use `service_role`; regulator URLs and runtime secrets must never be embedded into browser code.

---

## Change and Security Validation Process

For every material database/API change:

1. apply a numbered migration;
2. confirm RLS/grants remain deny-by-default;
3. regression-test authenticated RPCs;
4. confirm anonymous access remains blocked;
5. rerun Supabase Security Advisor;
6. record accepted INFO/WARN findings with rationale;
7. update Running Build and Project Plan in `coursefinder-admin`.

---

## Phase Status

- Phase 0 — complete.
- Phase 0A — complete.
- Phase 1 — Admin UI in progress.
- Phase 1A — Regulatory Settings implemented.
- Phase 3 — Layer 1 Worker is the next major functional build.

---

## Revision History

### v1.2
- Documents the completed Phase 0A RLS/privilege model.
- Records deny-by-default browser access and service-role separation.
- Explains accepted Advisor INFO/WARN findings.
- Adds leaked-password protection production follow-up.
