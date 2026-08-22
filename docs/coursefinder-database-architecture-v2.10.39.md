# CourseFinder Database Architecture v2.10.39

**Effective:** 23 August 2026  
**Status:** **CURRENT — ACCESS ADMIN v1.0 + DATA QUALITY SNAPSHOT HARDENING ACCEPTED**  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.38.md`  
**Canonical identity semantics:** unchanged

## 1. Scope

All accepted v2.10.38 canonical/read-boundary decisions remain in force. This revision records two durable operational architecture additions:

1. governed Platform Admin identity/RBAC administration with private audit history;
2. timestamped Data Quality aggregate snapshots with live exception drill-down.

Neither addition changes Provider/Course/Campus/Scholarship identity, source authority, Search admission or publication semantics.

## 2. Browser read boundary retained

Supported browser reads remain:

```text
Browser
  -> Supabase Auth
  -> public.admin_read(operation, args)
  -> security.* authenticated/rank-checked helper
  -> governed canonical/enrichment/evidence/workflow/search data
```

Internal schemas are not normal browser CRUD surfaces.

## 3. Access Admin v1.0 boundary

Privileged identity administration uses:

```text
Platform Admin browser
  -> normal Supabase user JWT
  -> admin-user-management Edge Function
  -> server-side CourseFinder rank-6 validation
  -> Supabase service-role authority inside function only
  -> Auth Admin operation + service-only RBAC/audit helper
```

The browser never receives the service-role key.

### Durable audit relation

`security.user_access_events`

Records governed access-management events including:

- `user_created`;
- `user_invited`;
- `roles_replaced`;
- `user_disabled`;
- `user_enabled`.

Audit payloads carry safe before/after state and metadata; passwords/tokens are excluded by contract.

### Service-only helper functions

- `public.svc_admin_access_snapshot()`;
- `public.svc_admin_access_replace_roles(uuid,uuid,text[],timestamptz)`;
- `public.svc_admin_access_guard_disable(uuid,uuid)`;
- `public.svc_admin_access_log_event(uuid,uuid,text,jsonb,jsonb,jsonb)`.

Normal `anon`/`authenticated` direct execution is denied. The JWT-protected Edge Function is the privileged service boundary.

### Lockout invariants

Server logic prevents:

- Platform Admin self-disable;
- self-removal of `platform_admin`;
- removing/disabling the last active Platform Admin;
- expiry on `platform_admin` in v1;
- unknown/inactive or empty role assignments.

Effective access remains the highest active unexpired assignment in `security.user_roles` / `security.roles`.

## 4. Data Quality aggregate snapshot model

The Data Quality state/domain semantics remain those accepted under CF-CHG-018. Only aggregate execution changes.

Browser contract:

```text
Data Quality overview
  -> public.admin_read('data_quality_overview', ...)
  -> rank check
  -> private timestamped snapshot

Data Quality exception state
  -> public.admin_read('data_quality_exceptions', ...)
  -> rank check
  -> live bounded/paged classification query
```

The aggregate and drill-down therefore have deliberately different freshness characteristics.

### Private snapshot storage

`security.data_quality_overview_snapshots`

Stores governed aggregate payloads for:

- AU+NZ;
- AU;
- NZ.

The stored payload records its computation timestamp/duration so Admin operators can distinguish snapshot freshness from live exceptions.

Snapshot storage is not directly executable/readable as a generic browser surface.

### Refresh

Server-side refresh helper:

`security.refresh_data_quality_overview_snapshots()`

Database schedule:

```text
job: coursefinder-data-quality-overview-refresh
schedule: */15 * * * *
command: select security.refresh_data_quality_overview_snapshots();
```

The first observed scheduled execution on 23 August 2026 completed successfully. Heavy AU+NZ recomputation is intentionally out-of-band rather than consuming the authenticated 8-second browser statement-timeout budget.

## 5. Dashboard bounded recent activity

Dashboard Recent Activity no longer unions all Job/Review/Evidence rows before applying its final top-10 limit. Each source is bounded first, then the small result sets are merged/sorted.

This is an execution-model change only; activity authority/meaning is unchanged.

## 6. Live migrations

This revision records:

- `20260822111848 — m1_access_roles_admin_v1`;
- `20260822210828 — m1_data_quality_overview_snapshot_core_v1`;
- `20260822210926 — m1_admin_dashboard_recent_activity_bounded_v1`;
- `20260822210938 — m1_data_quality_overview_snapshot_schedule_v1`;
- `20260822211428 — m1_data_quality_snapshot_visibility_v1`.

The Supabase migration ledger is authoritative for these live changes; mirrored Pilot migration source is retained where implemented by the workstream.

## 7. Performance result

Representative authenticated server-side measurements after hardening:

- Data Quality overview snapshot read: approximately 16–22 ms warm;
- overview read during scheduled recomputation: approximately 16 ms;
- Dashboard: approximately 75 ms warm / 558 ms during concurrent refresh;
- AU+NZ recomputation: approximately 9–12 s out-of-band.

The browser statement timeout remains 8 seconds; it was not increased to accommodate the former aggregate design.

## 8. Security posture

- `public.admin_read` remains the normal authenticated read boundary;
- Evidence remains Curator+ rank 3 and private;
- Pipeline operations remain Pipeline Operator+ rank 4;
- Access Admin requires Platform Admin rank 6 through the Edge Function boundary;
- private/security tables remain deny-by-default to normal browser roles;
- the pre-existing Supabase leaked-password-protection warning remains separate from these changes.

## 9. UAT authority

Accepted Pilot runtime:

`msinghbs-ai/Coursefinder-Pilot@e877e3e28cd281ff3751a70bc500eeb0d8f31963`

Final deployed authenticated UAT run `32600027592` passed all three governed tests on both desktop and Pixel-7/mobile projects with zero recorded HTTP 4xx/5xx or console/page errors.

## 10. Architecture outcome

**Accepted.** Access Admin v1.0 and timestamped Data Quality aggregation are durable operational architecture. Canonical entity identity, evidence authority, Search projection and publication boundaries remain unchanged.
