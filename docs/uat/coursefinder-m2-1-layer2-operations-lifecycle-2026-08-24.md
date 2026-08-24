# CourseFinder M2.1 Layer 2 Operations & Evidence Lifecycle UAT — 24 Aug 2026

**Change Control:** `CF-CHG-20260823-029`, related navigation `CF-CHG-20260823-030`  
**Overall state:** PARTIAL PASS / DEPLOYED BROWSER + ACQUIRE-v2 LIVE INVOCATION PENDING

## Backend foundation

PASS:

- `pipeline.layer2_execution_policies` deployed;
- only active Course/Scholarship Layer 2 profiles seeded;
- default policy = Manual / batch 10 / direct-first best-value routing / max 2 paid attempts;
- `pipeline.layer2_run_batches` and `pipeline.layer2_run_items` deployed;
- Layer 2 runtime provenance fields added to Provider Attempts;
- Evidence retention/review/version fields added;
- unique capture-version guard deployed;
- `security.admin_layer2_ops_read` role-gated;
- `public.layer2_ops_policy_update` PIM-Admin gated;
- direct `anon` / `authenticated` SELECT on new operational tables is false;
- QILT/PRISMS remain excluded from Layer 2 execution profiles.

## Acquisition runtime v2

DEPLOYED / UAT PENDING:

- Edge Function `layer2-acquire-v2` version 1 ACTIVE;
- `verify_jwt=true`;
- Course/Scholarship profile gate enforced;
- source-bound URL gate retained;
- provider routing retained;
- each successful fetch writes private Evidence;
- each fetch receives `evidence_group_key` + incrementing `capture_version` + supersession lineage;
- default `standard_365` retention metadata written;
- runtime metadata includes `SB_REGION`, `SB_EXECUTION_ID`, `DENO_DEPLOYMENT_ID` and `supabase_edge_dynamic_non_static` egress identity;
- storage hierarchy changed to `layer2/v2/{country}/{domain}/{profile}/{date}/{job}/{attempt}/vN-kind.ext`.

A live authenticated browser/Edge invocation is still required before v2 replaces the existing acquisition worker.

## Admin / navigation

IMPLEMENTED / DEPLOYED UAT PENDING:

- Layer 2 Platform visible version bumped to v1.4;
- primary sidebar simplified to `Data Enrichment → Layer 2 Operations / Evidence`;
- former Pipeline Control, Source Registry, Source Config, Providers, Trials and Jobs removed as separate primary destinations;
- those capabilities remain drill-down actions from Layer 2 Operations;
- Layer 2 Operations shows sources, schedule/batch/routing, provider readiness, Evidence summary and recent runs;
- QILT/PRISMS remain under Insights and are not displayed as Layer 2 targets;
- schedule dialog exposes only automation mode, batch size, routing and paid-attempt ceiling;
- unresolved L2 outcome is `L3 required`; no direct Layer 2 → Layer 4 control exists.

Automated deployed navigation UAT was updated to enforce the simplified menu and workspace.

## Evidence retention

PASS as policy metadata; destructive purge intentionally not enabled.

- v2 Layer 2 Evidence receives a minimum 365-day retention horizon;
- referenced/held Evidence must not be automatically purged;
- M2.1 does not enable automatic destructive deletion at day 365;
- a future retention sweeper requires explicit reference/hold checks and its own security/UAT gate.

## Network provenance finding

Confirmed from implementation:

- CourseFinder Admin browser entry is served behind Cloudflare Worker;
- Direct HTTP source fetch is executed inside Supabase Edge Function;
- therefore destination sees Supabase Edge network egress, not Cloudflare Worker egress;
- exact historical public egress IP was not recorded and cannot be reconstructed from existing CourseFinder Evidence;
- Supabase Edge egress is not guaranteed static;
- v2 records execution region/instance/deployment as auditable runtime provenance.

## Remaining gate

M2.1 cannot close from this increment alone. Required next evidence:

1. deployed browser UAT for Layer 2 Platform v1.4;
2. authenticated `layer2-acquire-v2` direct-HTTP run producing v2 Evidence and runtime provenance;
3. v2 provider attempt with one configured paid provider proving provider telemetry + Evidence lineage;
4. normalisation + Course/Scholarship extraction from v2 Evidence;
5. L2-resolved versus L3-required hand-off measurement;
6. scheduler/runner activation only after batch-selection semantics are accepted; current schedule policy is stored/governed but production automatic batch execution is not yet authorised.
