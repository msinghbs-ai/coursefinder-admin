# Coursefinder — Pilot to Production Project Plan v1.6

**Status:** Living delivery plan  
**Authoritative runtime:** `coursefinder_Pilot` — Mumbai (`ap-south-1`)  
**Pilot code repository:** `msinghbs-ai/Coursefinder-Pilot`  
**Architecture/design/planning repository:** `msinghbs-ai/coursefinder-admin`

> `Coursefinder-Pilot` remains code/runtime only. All design, database, planning, UAT, guide and roadmap records remain in `coursefinder-admin`.

---

## Current Position

**Phase 0A — RLS / privilege hardening is complete.** The project remains in **Phase 1 — PIM/Admin UI**, with **Phase 1A Regulatory Settings implemented**, and the next major functional build is **Phase 3 — Layer 1 Regulatory Worker**.

Database migrations are applied through **028**.

### Phase status

| Phase | Scope | Status | Remaining estimate |
|---|---|---|---:|
| Phase 0 | Pilot runtime/bootstrap | Complete | 0–1 hr deployment verification as required |
| Phase 0A | RLS / privilege hardening | **Complete** | 0 hrs |
| Phase 1 | PIM/Admin UI | In progress | 14–20 hrs |
| Phase 1A | Regulatory Settings | Implemented | 1–2 hrs runtime visual/UAT verification |
| Phase 2 | Canonical data migration | Not started beyond UI seed | 14–20 hrs |
| Phase 3 | Layer 1 regulatory pipeline | **Next major build** | 14–20 hrs |
| Phase 4 | Layer 2 acquisition/evidence | Planned | 24–32 hrs |
| Phase 5 | Layer 3 AI extraction | Planned | 20–28 hrs |
| Phase 6 | Layer 4 governance | Planned | 18–24 hrs |
| Phase 7 | Search / Website / Zoho APIs | Planned | 20–28 hrs |
| Phase 8 | Zoho Creator integration/UAT | Planned | 20–28 hrs |
| Phase 9 | Website integration/UAT | Planned | 18–24 hrs |
| Production readiness | Security, performance, cutover, hypercare | Planned | 20–28 hrs |

**Planning-equivalent remaining envelope:** approximately **182–248 hrs**. This is a delivery estimate, not a timesheet claim.

---

## Phase 0A Completion Gate

Completed controls:

- 76/76 internal domain tables have RLS enabled;
- zero internal tables directly accessible by `anon`;
- zero internal tables directly accessible by `authenticated`;
- internal schema usage removed from browser roles;
- `service_role` preserved for trusted backend/Worker operations;
- authenticated `public.ui_*` read RPCs regression-tested;
- anonymous RPC execution verified blocked;
- Platform Admin Regulatory Settings regression-tested;
- Supabase Security Advisor rerun with no Critical/Error findings.

Accepted advisor findings:

- INFO `rls_enabled_no_policy` is intentional for deny-by-default server-owned internal schemas;
- WARN authenticated `SECURITY DEFINER` read RPCs are the current explicit Pilot browser boundary and will be reconsidered during API/Edge hardening;
- Auth leaked-password protection remains a production-readiness setting to enable separately.

---

## Next Major Build — Phase 3 Layer 1 Worker

Target flow:

`Enabled Country → Regulatory Source Resolver → Country Adapter → Fetch → Evidence → Reconciliation → Canonical Catalogue → Layer 4 if ambiguous`

### Implementation order

1. Worker framework and service-role Supabase client.
2. Resolve sources from `pipeline.resolve_regulatory_sources(country)`; no hard-coded regulator URLs.
3. Pipeline job lifecycle and retry/backoff framework.
4. Evidence/content-hash capture and source health telemetry.
5. **Australia CRICOS adapter as reference implementation.**
6. Provider/course/location identity reconciliation and idempotent rerun validation.
7. Remaining Pilot country adapters: CA, DE, GB, IE, NZ, US.
8. Seven-country Layer 1 regression and UAT.

### Phase 3 exit gate

For every Pilot country:

- source registry resolves correctly;
- fetch executes using the approved method;
- source health is updated;
- raw/evidence metadata is retained;
- provider/course identity is reproducible;
- reruns are idempotent;
- changes/conflicts are auditable;
- errors are visible in Jobs;
- ambiguous cases can route into Layer 4.

---

## Phase 1 Work Continuing in Parallel

Remaining Admin UI work:

- Provider Detail;
- PIM Families;
- Attribute Groups;
- Attribute Options;
- Completeness Profiles;
- Evidence Viewer;
- role-aware actions;
- pagination/filter/sort/saved state;
- controlled write contracts after read UAT.

---

## Production Security Follow-up

Before final production sign-off:

- enable Supabase leaked-password protection where available;
- review whether authenticated SECURITY DEFINER reads remain appropriate or should move behind Edge/API contracts;
- validate runtime Worker secrets and service-role isolation;
- rerun Security Advisor after each material DDL/API change.

---

## Immediate Next Steps

1. Start Layer 1 Worker framework.
2. Build AU CRICOS adapter first.
3. Add evidence/job/source-health telemetry.
4. Test repeatable/idempotent reconciliation against current Pilot identities.
5. Continue remaining Phase 1 UI in parallel.
6. Expand canonical Pilot data only after Layer 1 identity path is proven.

---

## Revision History

### v1.6
- Marks Phase 0A complete.
- Records migration 028 and security validation outcome.
- Removes RLS hardening from remaining estimate.
- Makes Layer 1 Worker the next major execution phase.
