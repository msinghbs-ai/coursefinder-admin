# Coursefinder Admin Guide v1.5

## Runtime Architecture

Coursefinder separates application delivery from backend pipeline execution:

**Cloudflare**
- Serves the React/Vite Pilot application.
- Does not require the Supabase service-role secret for Layer 1.

**Supabase Edge Functions**
- Execute regulatory ingestion and controlled reset operations.
- Require valid Supabase JWTs.
- Perform an additional server-side Platform Admin authorization check.
- Use the service role internally for service-only RPCs and private evidence writes.

**PostgreSQL**
- Stores canonical catalogue, PIM, reference data, Pipeline Jobs, evidence metadata and Search Projection.

**Supabase Storage**
- Stores regulatory evidence privately.

## Layer 1 — Australia / CRICOS

The Pilot Edge Function is `layer1-register-etl`.

Execution path:

`Platform Admin → Settings → Edge Function → Regulatory Settings source resolution → CRICOS CKAN discovery → Institutions + Courses CSV → SHA-256/evidence → reconciliation RPC → canonical catalogue → Search Projection finalisation → retained statistics`

The Edge Function follows the proven one-hit pattern previously used in the demo project, while retaining the v2.9.1 security and governance model.

## Controlled UAT Modes

### Dry-run 100
- Fetch current source.
- Store evidence.
- Hash resources.
- Parse the full CRICOS Courses source.
- Select deterministic first 100 records.
- No catalogue mutation.

### Apply 100
- Requires `APPLY 100` confirmation.
- Reconciles provider and course identities.
- Adds/updates CRICOS registrations.
- Calls `svc_layer1_finalize_catalogue()`.
- Rebuilds Search Projection.
- Returns canonical statistics.

### Idempotency re-run
The same deterministic first 100 records are applied again. Expected outcome: no duplicate regulator-derived entities or registrations and stable catalogue statistics.

## Retained Statistics

A successful Apply returns:
- `providers`
- `courses`
- `cricos_provider_registrations`
- `cricos_course_registrations`
- `search_documents`
- `search_generation`

These values are produced after Search Projection rebuild, so Dashboard, Provider/Course browsing and search-derived views use the updated canonical population.

## AU UAT Reset

The `pilot-reset` Edge Function is restricted to Platform Admin and requires `RESET AU UAT` confirmation.

The reset:
- deletes CRICOS course registrations;
- deletes CRICOS provider registrations;
- removes regulator-created `course:cricos:*` entities;
- removes regulator-created `provider:cricos:*` entities;
- clears CRICOS canonical-source verification markers from seeded demo entities;
- rebuilds Search Projection.

The reset preserves:
- Auth users and roles;
- PIM model/configuration;
- reference data;
- Regulatory Source configuration;
- Pipeline Job history;
- evidence files and evidence metadata.

### Validated Reset Baseline
The reset has been executed successfully and returned:
- Providers: **7**
- Courses: **35**
- CRICOS Course Registrations: **0**
- CRICOS Provider Registrations: **0**
- Search Documents: **35**
- Search Generation: **3**

It removed 95 regulator-created Courses and 2 regulator-created Providers from the prior controlled Apply.

## Security Boundary

Browser users never receive the Supabase service-role key.

Platform Admin authentication is evaluated twice:
1. Supabase Edge Function JWT verification.
2. `svc_layer1_authorize_platform_admin` server-side role authorization.

Internal schemas remain directly inaccessible to browser roles; Edge Functions call service-only RPCs.

## Operational Rule

Do not manually edit regulator-created stable keys or CRICOS registration records during Layer 1 UAT. Use the controlled Apply/Reset cycle so reconciliation and idempotency remain testable.

## Next Gate

From the clean baseline:
1. Edge Function Dry-run 100.
2. Edge Function Apply 100.
3. Confirm canonical and Search Projection statistics increase together.
4. Edge Function Apply same 100 again.
5. Confirm no duplicate entities/registrations and stable statistics.
6. Add CRICOS Locations and Course Locations.
7. Increase controlled batch size before full AU ingestion.
