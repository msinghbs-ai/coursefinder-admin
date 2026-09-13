# CF-CHG-20260910-093 — Runtime Operations Follow-on

This document supersedes continuation through Admin PR #34. It does not rewrite or invalidate merged Pilot PR #72 or any applied Pilot migration.

## Current continuity — 13 September 2026

- Pilot PR #72 is merged and remains immutable historical implementation evidence.
- Runtime/operational maturity continues in Pilot PR #79 / issue #74.
- Admin PR #36 / issue #35 is the authoritative governance follow-on; PR #34 is superseded without losing its carried-forward findings.
- Pilot PR #79 exact current head: `849f6f50e810bd77a6b3e02ef765df9c43f541db`.
- Accepted visible release remains **v2.15.78**. PR #79 is an unmerged candidate and does not itself promote a release.
- M2.5 remains paused. Production remains unchanged.
- `CF-CHG-20260910-093` remains **REOPENED** pending genuine consequential acceptance; runtime-operations maturity does not close it.
- Codex remains deferred assurance only. Gitar is the active reviewer.

## Exact-head validation

For Pilot head `849f6f50e810bd77a6b3e02ef765df9c43f541db`:

- CF-093 Fresh Reconstruction run `34751520430` — PASS.
- CF-093 Targeted Recovery run `34751520442` — PASS.
- Pilot Frontend Build run `34751520437` — PASS.
- Cloudflare commit preview — PASS (`849f6f50`).
- Gitar prior findings are resolved; current PR review threads are all resolved. The final UI correction separates governed runtime-read errors from the legacy generic Jobs-panel error state.

## Runtime baseline

Direct Pilot measurements before behavioural tuning:

- `layer2_acquisition_v2` successful sample: 773 Jobs; average queue wait `0.049 s`; average execution `1.44 s`; median execution `1.06 s`.
- Before the telemetry correction, 111 `layer2_discovery` Jobs were terminal `completed` with no trustworthy `completed_at`; completed-run duration/throughput therefore remained unavailable.
- Initial failed-discovery sample: 20 Jobs; average queue wait `0.081 s`; average execution `62.22 s`; median `64.61 s`.
- Three-day failed-discovery comparison baseline: 25 Jobs, 111 records processed, `1244.86 s` total measurable execution, weighted throughput `5.35 records/min`.
- Queue scheduling is not the primary bottleneck; discovery/provider acquisition is.

### UQ provider-route evidence

Profile `au-uq-course-catalogue` remains enabled and unpaused. Governed route order remains direct-http → Firecrawl → scrape-do → scraperapi → ZenRows.

Observed three-day attempt evidence:

- direct-http succeeded: 912 attempts, ~`1047.8 ms` average;
- direct-http extraction failure: 201, ~`360.4 ms`;
- Firecrawl extraction failure: 201, ~`2293.7 ms`;
- scrape-do extraction failure: 149, ~`4175.5 ms`;
- ZenRows extraction failure: 141, ~`5621.9 ms`;
- scrape-do HTTP 401: 50, ~`236.9 ms`;
- ScraperAPI is later in the route chain but relevant runtime attempts report credential unavailable.

`401` is intentionally not an authorised fallback condition. Do not add it merely to increase throughput. It remains an authentication/provider-health failure to be remediated through the governed provider/secret lifecycle. No secret value is recorded here.

## Increment 1 — Runtime Health UI

Scheduled Tasks now has an operational Runtime Health surface that distinguishes unavailable values from zero and exposes, where trustworthy data exists:

- queue wait, execution and completion timing;
- processed/failed work and derived throughput;
- Evidence produced and verified Evidence as separate counters;
- retry exhaustion and dedupe/replay only when the runtime actually records those counters;
- sanitised failure class;
- Jobs/Evidence follow-through;
- terminal Jobs missing completion timestamps.

Existing `attempt_count` is not represented as retry count because its semantics vary by workload. Evidence creation is not represented as Evidence acceptance; most artifacts remain unreviewed, so no artificial acceptance/yield percentage is calculated.

## Increment 2 — terminal discovery timestamp correction

Defect classification: **implementation / observability defect**.

Root cause: successful/partial Layer 2 discovery could persist terminal `status='completed'` and result counters without `completed_at`, while failed terminal paths did write it.

Forward-only correction:

- repository source migration: `20260913101000_cf_093_layer2_discovery_terminal_timestamp_observability.sql`;
- deployed Pilot migration identity: `20260913100615 cf_093_layer2_discovery_terminal_timestamp_observability`;
- preserve both identities exactly; do not rename, retimestamp, delete or rewrite either history;
- runtime trigger `pipeline.layer2_discovery_terminal_timestamp_v1` stamps `clock_timestamp()` only for a terminal `layer2_discovery` row whose completion timestamp is null;
- no historical completed rows were backfilled;
- rollback-only proof verified a synthetic terminal Job received a measurable `2.009 s` duration and was then rolled back.

No natural `layer2_discovery` Job had run after this migration at the latest check, so natural post-fix throughput remains **not yet observed**. Do not create consequential work solely to prove it.

## Increment 3 — governed runtime metrics read

Repository source migration: `20260913102500_cf_093_scheduled_runtime_metrics_read.sql`.

Deployed Pilot migration identity: **`20260913102217 cf_093_scheduled_runtime_metrics_read`**. Preserve the distinct source/deployment identities; applied runtime history is immutable.

The new `jobs_runtime` operation is available only through the governed Admin read chain:

- `public.admin_read('jobs_runtime', ...)` → `security.admin_jobs_runtime_read_v1(...)`;
- authenticated caller required;
- rank `>=4` / pipeline-operator authority required inside the helper;
- helper EXECUTE: `authenticated=true`, `anon=false`, `public=false`;
- authenticated rank-4 rollback-only proof succeeded;
- authenticated rank-3 curator proof failed closed with `42501 pipeline_operator role required`;
- malformed `limit='abc'` safely defaults to 50 instead of raising a cast error;
- normal `limit=5` returns exactly five rows;
- runtime boundary proof returned no raw `payload`, `result`, `error_text`, `source_url` or `storage_path` keys.

The contract exposes only safe derived operational values: timestamps, profile identity, processed/selected/accepted/failed counters where recorded, retry exhaustion, dedupe replay, Evidence/verified-Evidence counts, throughput when a real duration exists, and sanitised failure classes.

### Read-performance tuning evidence

Before → Change → After → Result for the new read contract:

- **Before:** equivalent recent-50 query projected wide `pipeline.jobs j.*`; measured row width ~1477 bytes, planning ~`146.8 ms`, execution ~`112.5 ms`.
- **Change:** project only required Job columns and derived counters before Evidence joins.
- **After:** equivalent bounded plan measured row width ~60 bytes, planning ~`5.0 ms`, execution ~`2.6 ms`.
- **Deployed wrapper proof:** authenticated rank-4 `public.admin_read('jobs_runtime', limit=50)` measured `21.4 ms` execution including wrapper/security/JSON construction.
- **Result:** materially lighter measured read path without changing security/authority semantics. Cache warmth may contribute to the plan-to-plan timing delta, so the entire improvement is not attributed solely to projection width.

No batch-size, discovery concurrency or retry-policy change has been made.

## Preserved boundaries

Every increment continues to preserve:

- Layer 1 regulatory/identity authority;
- deterministic Evidence-preserving Layer 2;
- exact Preview/token/fingerprint/identity provenance where applicable;
- Layer 3 Evidence/profile/model/revalidation governance;
- Layer 4 human-resolution authority;
- Search/Publication separation;
- rank/ACL/RLS/private-helper/service-role boundaries;
- fail-closed generic async discovery outside explicit governed continuations;
- immutable applied migration history.

## Exact next operational gate

1. Observe the next legitimate/natural post-migration `layer2_discovery` terminal Job and verify real `completed_at` and throughput; do not manufacture a run.
2. Use the deployed `jobs_runtime` read to accumulate comparable discovery measurements and failure-class/Evidence history.
3. Remediate scrape-do 401 and ScraperAPI credential/provider health through the governed secret/provider lifecycle; do not weaken fallback semantics.
4. Once enough post-fix natural history exists, record a genuine discovery **Before → Change → After → Result** comparison.
5. Only then consider batch/chunk size, concurrency, retry fairness/bounds, dedupe or provider-route efficiency tuning.
6. Keep CF-CHG-20260910-093 consequential acceptance separate: closure still requires a legitimate current-main policy-qualified target plus deployed-currentness/UAT evidence.

## Closure

`CF-CHG-20260910-093` remains REOPENED. Runtime Health, telemetry correction and the governed runtime-metrics read improve operational maturity but do not satisfy the separate consequential-acceptance closure gate.