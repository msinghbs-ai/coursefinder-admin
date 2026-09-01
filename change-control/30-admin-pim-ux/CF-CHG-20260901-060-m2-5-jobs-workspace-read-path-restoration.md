# CF-CHG-20260901-060 — M2.5 Jobs Workspace Read-Path Restoration

**Status:** ACTIVE / CORRECTIVE IMPLEMENTATION  
**Category:** 30-admin-pim-ux  
**Initiated:** 1 September 2026, Australia/Melbourne  
**Owner:** M2.5 Platform/Admin operations  
**Parent readiness gate:** `CF-CHG-20260901-049`  
**M2.4 baseline:** remains CLOSED/PASS.

## Trigger

User UAT on deployed Admin v2.15.19 showed:

- `#jobs` rendered **0 records**;
- Layer 2 was simultaneously reporting active background qualification/enrichment state;
- the deployed Worker was visibly serving repository version v2.15.19.

Live Pilot runtime proves Jobs are present:
- total Jobs: **3,964**;
- recent 24h: **1,082**;
- running: **2**;
- failed: **237**;
- completed/succeeded: **3,720**;
- Layer 2 Jobs: **2,643**.

Therefore the defect is read-path/UI routing, not missing pipeline history.

## Root cause

Current `src/lib/supabase.js` contains a historical compatibility guard:

- when `adminRead('jobs')` or `adminRead('sources')` is called;
- and the browser route is exactly `#jobs` / `#sources`;
- the helper returns `[]` without calling the governed RPC.

That guard was introduced when Jobs/Sources were owned by the separate Pipeline Ops overlay.

Current v2.15.19 reality:
- `index.html` no longer mounts `pipeline-ops-root`;
- `pipeline-ops-entry.jsx` is no longer loaded by the shell;
- canonical `mature-main.jsx` renders its own `OperationalList operation="jobs"`.

The stale guard therefore suppresses the only live Jobs read and manufactures an empty result.

## Existing governed server contract

The preferred server contract already exists:

`admin_read('pipeline_jobs_page', ...)`

It provides:
- server paging;
- query;
- Layer;
- status;
- mode;
- country;
- job type;
- failure class;
- completion class;
- latest-first sorting;
- source/provider context;
- run counts;
- Evidence counts;
- duration/cursor;
- created timestamps.

`pipeline_job_detail` provides expandable detail with:
- run semantics;
- scope/entity impact;
- requested/started/completed timestamps;
- error detail;
- linked/referenced Evidence;
- safe-action policy.

No database migration is required for CF-060.

## Corrective implementation

1. Export the existing `JobsWorkspace` and `SourcesWorkspace` from `pipeline-ops-entry.jsx`.
2. Mount those governed paged workspaces directly from canonical `mature-main.jsx` routes:
   - Jobs → `JobsWorkspace`;
   - Sources → `SourcesWorkspace`.
3. Remove the stale Jobs/Sources route suppression from `adminRead`.
4. Keep role/rank enforcement server-side.
5. Do not add mutation/retry/reset authority.
6. Bump maintained Admin source/release version to v2.15.20.
7. Add source/build + deployed Jobs UAT.

## Acceptance

- Jobs route does not call the suppressed legacy empty path.
- `pipeline_jobs_page` is the canonical Jobs read.
- Current/past jobs are shown with timestamp/status/layer information.
- server total is non-zero when live database contains Jobs.
- Layer 2 jobs are visible.
- detail expansion uses `pipeline_job_detail`.
- no generic retry/replay/reset mutation is introduced.
- full build passes.
- deployed browser UAT sees current Admin version and a non-zero Jobs result.

## Explicit non-goals

- no rewriting/deleting pipeline history;
- no reopening M2.4;
- no Production provisioning;
- no autonomous replay;
- no Firecrawl quota change;
- no Layer 3 authority change.
