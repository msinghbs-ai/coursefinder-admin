# CourseFinder Layer 2 Operations & Evidence Lifecycle v1.0

**Status:** M2.1 IMPLEMENTED FOUNDATION / DEPLOYED BROWSER + ACQUIRE-v2 UAT PENDING  
**Change Control:** `CF-CHG-20260823-029`, related Admin IA `CF-CHG-20260823-030`  
**Scope:** Layer 2 Course and Scholarship enrichment only

## Product boundary

Layer 2 acquires and deterministically extracts **Course** and **Scholarship** enrichment for international-student CourseFinder. QILT and PRISMS are not Layer 2 acquisition sources; their governed Layer 1 observations remain available as Course decision context.

Layer 2 never writes directly to Layer 4. The fall-out path is:

`Layer 2 unresolved → Layer 3 Evidence interpretation → Layer 4 only if Layer 3/automation remains unresolved or conflicting`.

## Backend operating process

The operational unit is intentionally small:

`Execution Policy → Run Batch → Run Item → Job → Provider Attempt → Native Evidence → Normalised Evidence → Deterministic extraction → L2 resolved OR L3 required`.

### Execution Policy

One policy exists per governed Layer 2 enrichment source. Management controls only:

- automation: Manual / Daily / Weekly / Disabled;
- batch size;
- provider-routing strategy;
- maximum paid attempts per item;
- optional vendor-unit / monetary ceiling;
- automatic Layer 3 hand-off;
- identity-mismatch stop guard.

Current default is **Manual / batch 10 / Direct HTTP then best-value fallback / maximum 2 paid attempts**.

### Run Batch

A batch freezes the Source Profile Version and execution policy used for that run. It records total targets, processed count, L2-resolved count, L3 escalations, blocked records, vendor units and cost.

### Run Item

One Course or Scholarship acquisition target. The item links to the actual Job, selected Provider, Evidence count, fields targeted/resolved, provider units/cost and blocker.

### Job and Provider Attempt

Jobs retain source-profile-version lineage. Provider Attempts retain transport/provider telemetry. API credentials are never stored in attempt telemetry.

## Direct HTTP network provenance

The CourseFinder browser/Admin shell is served behind Cloudflare Worker `coursefinder-pilot.techm.workers.dev`, but **Direct HTTP acquisition is not executed by that Worker**.

`layer2-acquire` and `layer2-acquire-v2` execute the outbound `fetch()` from the Supabase Edge Function runtime. Therefore the destination university/source sees **Supabase Edge outbound network egress**, not the Cloudflare Worker IP.

Supabase hosted Edge Functions are globally distributed and do **not** provide a guaranteed static egress IP. Historical Layer 2 Direct HTTP attempts before acquisition-v2 did not record the observed public egress IP, so an exact historical public IP cannot be reconstructed from CourseFinder records.

Acquisition v2 records instead the stable runtime provenance that Supabase exposes:

- `runtime_platform = supabase_edge`;
- `runtime_region = SB_REGION`;
- `runtime_execution_id = SB_EXECUTION_ID`;
- `runtime_deployment_id = DENO_DEPLOYMENT_ID`;
- `egress_identity = supabase_edge_dynamic_non_static`.

If a future source requires IP allow-listing, use a governed static-egress proxy rather than pretending the Supabase Edge IP is stable.

## Acquisition runtime versioning

Existing `layer2-acquire` remains available as rollback.

New runtime: `layer2-acquire-v2`.

Every v2 result records `runtime_version=layer2-acquire-v2` on the Job and Evidence metadata. Runtime deployment ID is also retained so an Evidence artifact can be traced to the exact deployed Edge Function version.

## Evidence: one row per fetch

Every successful acquisition fetch creates a new Evidence Artifact row even if the content is unchanged.

This is deliberate. A fetch proves that the source was re-observed at a point in time.

For each logical Evidence family v2 records:

- `evidence_group_key`;
- monotonically increasing `capture_version`;
- `supersedes_evidence_id`;
- `valid_from` and previous artifact `valid_to`;
- SHA-256 `content_hash`;
- `content_changed` flag;
- Source Profile Version;
- Job / Provider Attempt / provider identity;
- source URL and capture time;
- runtime version/region/execution/deployment;
- HTTP status and a bounded non-secret provider-header telemetry set.

A byte-for-byte identical re-fetch remains a new capture version because verification time matters.

## Private Evidence storage

All source content remains in the existing private Supabase Storage bucket:

`evidence`

The bucket is not public. Browser access must continue through governed Evidence APIs/workspace rather than direct public object URLs.

Current bucket supports HTML, JSON, text, CSV, XLSX, ZIP, PDF, PNG and JPEG, with a 50 MB object limit.

### v2 object hierarchy

New Layer 2 acquisition objects are organised as:

`layer2/v2/{country}/{domain}/{profile}/{YYYY}/{MM}/{DD}/{job_id}/{attempt_id}/v{capture_version}-{kind}.{ext}`

Example:

`layer2/v2/au/course_facts/au-rmit-course-detail/2026/08/24/<job>/<attempt>/v3-html.html`

Storage hierarchy is for operations/lifecycle efficiency only. Admin reviewers should navigate relational lineage, not bucket folders.

## Evidence retention

Layer 2 acquisition-v2 assigns:

- `retention_class = standard_365`;
- `retain_until = captured_at + 365 days`;
- `review_state = unreviewed`.

**365 days is a minimum review/retention horizon, not an unconditional deletion date.** Evidence that remains referenced by accepted observations/candidates, active review or a hold must not be automatically removed.

M2.1 does not silently delete Evidence at day 365. Expired artifacts become retention candidates only after reference/hold checks. A destructive retention sweeper requires its own bounded security/UAT gate.

This deliberately favours auditability over aggressive storage cleanup during Pilot/M2.

## Admin Evidence review hierarchy

The Admin UI should present Evidence using this logical hierarchy:

`Country → Data type → University/source → Run → Course/Scholarship → Provider Attempt → Native Evidence → Normalised Evidence → Extraction candidate/decision`.

The reviewer should normally see only:

- source and Course/Scholarship identity;
- provider used;
- capture time and freshness;
- Evidence type;
- content changed / unchanged;
- extraction outcome;
- L3/L4 consequence.

Technical items such as storage path, content hash, runtime execution ID, provider response headers and raw metrics belong under **Details / Diagnostics**.

## Provider logging and cost telemetry

Provider logging is deliberately separated from Evidence content.

Provider Attempt / run telemetry may retain non-secret information such as:

- provider key and adapter;
- HTTP status;
- latency;
- response bytes/MIME;
- provider request/trace identifier where returned;
- rate-limit headers;
- credit/request-cost headers where returned;
- retries/fallback reason;
- vendor units;
- effective account-plan cost when configured;
- Evidence IDs produced;
- extraction success and fields resolved.

Do not persist API keys, auth headers, provider cookies or full provider debug payloads as operational telemetry.

Provider choice is based on **cost per evidence-backed resolved Course/domain**, correctness and reliability, not cheapest request or HTTP 200.

## Simplified Admin navigation

Main navigation is intentionally reduced to:

```text
Overview
Catalogue
  Providers
  Courses
  Campuses
  Scholarships
Data Enrichment
  Layer 2 Operations
  Evidence
Insights
  Outcomes (QILT)
  Student Flow (PRISMS)
Quality & Review
  Completeness
  Review Queue
Governance & Platform
  Attributes
  Settings / Access
```

The previous Pipeline Control / Source Registry / Source Config / Acquisition Providers / Acquisition Trials / Jobs items remain operational capabilities but are **drill-down controls inside Layer 2 Operations**, not six separate management-menu destinations.

## Layer 2 Operations workspace

The first screen shows only:

1. four compact KPIs: enrichment sources, provider methods ready, Evidence count, items needing review;
2. Enrichment Plan: Country + Courses/Scholarships + University/source + schedule + batch + routing;
3. Provider Health: provider readiness, concurrency, last test and cost/rate status;
4. Evidence summary;
5. Recent Runs: processed / L2 resolved / sent to L3 / cost.

Management actions are limited to:

- Schedule / automation policy;
- Run bounded trial;
- Configure provider (drill-down);
- Advanced source configuration (drill-down);
- Open Evidence;
- Open Jobs/diagnostics.

No large configuration JSON or verbose provider logs belong on the first management screen.

## Layer 3 / Layer 4 UI consequence

Layer 2 shows only `L3 required` as an outcome. It does not create a direct `Send to Layer 4` action.

Layer 3 is responsible for Evidence interpretation/reconciliation. Only its unresolved/conflicting fall-out is presented in the Layer 4 Review Queue.

This keeps operator behaviour aligned with the four-layer authority model.
