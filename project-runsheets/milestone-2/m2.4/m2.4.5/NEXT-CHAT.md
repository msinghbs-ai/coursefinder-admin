# M2.4.5 NEXT CHAT

## Active baseline — 13 September 2026

- Milestone: **M2.4.5 — Pre-Production Hardening**. M2.5 remains paused; Production unchanged.
- Accepted visible PIM Admin release remains **v2.15.78**.
- Pilot PR #72 remains immutable merged CF-093 implementation history.
- Active Pilot PR: **#79**, branch `m245/cf093-runtime-ops-efficiency-20260913`, exact head **`849f6f50e810bd77a6b3e02ef765df9c43f541db`**.
- Pilot tracker: issue #74.
- Active Admin governance PR: **#36**, branch `m245/cf093-runtime-ops-followon-20260913`; PR #34 remains superseded/closed without merge.
- Admin tracker: issue #35.
- `CF-CHG-20260910-093` remains **REOPENED**; runtime operations do not close consequential acceptance.
- Codex remains deferred assurance only. Gitar is active reviewer.

## Pilot #79 exact-head state

Head `849f6f50e810bd77a6b3e02ef765df9c43f541db`:

- Fresh Reconstruction `34751520430` — PASS.
- Targeted Recovery `34751520442` — PASS.
- Frontend Build `34751520437` — PASS.
- Cloudflare preview — PASS.
- Gitar prior findings resolved; all current inline review threads resolved.

Implemented candidate UI:

- Scheduled Tasks Runtime Health;
- trustworthy queue/execution timing with `Unavailable` for absent data;
- processed/failed work and weighted throughput when measurable;
- Evidence produced and verified Evidence separately;
- retry exhaustion/dedupe only when explicitly recorded;
- sanitised failure classes;
- Jobs/Evidence follow-through;
- generic Jobs error and governed runtime-read error are separate states.

## Pilot Supabase runtime

Project: `fxcwkweaxjtknorudmwp`.

Two forward-only runtime-operations migrations are deployed:

1. Runtime ledger `20260913100615 cf_093_layer2_discovery_terminal_timestamp_observability`; repository source `20260913101000_cf_093_layer2_discovery_terminal_timestamp_observability.sql`.
2. Runtime ledger `20260913102217 cf_093_scheduled_runtime_metrics_read`; repository source `20260913102500_cf_093_scheduled_runtime_metrics_read.sql`.

Preserve source and runtime identities exactly. Never rename, retimestamp, delete or rewrite applied history.

Terminal-timestamp trigger:

- only stamps `completed_at` when a `layer2_discovery` Job enters a terminal state with no timestamp;
- historical missing completion timestamps were not backfilled;
- rollback-only synthetic proof measured `2.009 s` and rolled back;
- no natural discovery Job had run after deployment at last check, so natural post-fix throughput is **not yet observed**.

Governed runtime metrics contract:

- `public.admin_read('jobs_runtime', ...)` → rank-checked private helper;
- authenticated helper EXECUTE = yes; anon/public = no;
- rank-4 authenticated proof succeeds;
- rank-3 curator proof fails closed with `42501`;
- malformed `limit='abc'` defaults to 50;
- unsafe raw keys (`payload`, `result`, `error_text`, source URL, storage path) are not returned;
- recent-50 deployed wrapper measured about **21.4 ms execution** in bounded proof.

## Performance evidence

Deterministic Layer 2 remains fast: 773 successful `layer2_acquisition_v2` Jobs in initial sample, average queue `0.049 s`, average execution `1.44 s`, median `1.06 s`.

Discovery remains the bottleneck. Failed-discovery three-day baseline: 25 Jobs / 111 processed / `1244.86 s` measurable execution / weighted throughput **5.35 records/min**.

UQ provider evidence:

- direct-http 912 success, ~1047.8 ms average;
- Firecrawl extraction failures ~2293.7 ms;
- scrape-do extraction failures ~4175.5 ms;
- ZenRows extraction failures ~5621.9 ms;
- scrape-do HTTP 401: 50 attempts, ~236.9 ms;
- ScraperAPI relevant fallbacks report credential unavailable.

Do not add 401 to fallback. Treat it as authentication/provider-health and remediate through governed provider/secret lifecycle.

Read-contract optimisation already measured:

- Before: wide `j.*` equivalent recent-50 plan, ~1477-byte rows, planning ~146.8 ms, execution ~112.5 ms.
- Change: narrow required projection before Evidence joins.
- After: ~60-byte rows, planning ~5.0 ms, execution ~2.6 ms.
- Cache warmth may contribute; do not attribute the complete delta solely to projection width.

No concurrency, batch/chunk-size or retry-policy tuning has been made.

## Exact next gate

1. Observe the next **natural legitimate** `layer2_discovery` terminal Job and confirm real `completed_at` plus derived throughput. Do not dispatch work solely to prove the metric.
2. Accumulate comparable discovery history via `jobs_runtime`.
3. Remediate scrape-do/ScraperAPI provider health through governed credential lifecycle; keep 401 fail-closed.
4. Compare discovery Before → Change → After → Result once enough post-correction history exists.
5. Only then tune batch/chunk size, concurrency, retry fairness/bounds, dedupe or provider routing if measurements support it.
6. Keep CF-CHG-20260910-093 closure separate; consequential acceptance still requires a legitimate current-main policy-qualified target and deployed-currentness/UAT evidence.

## Recovery pickup

> Continue M2.4.5 from repository/runtime truth. Read PROJECT_INSTRUCTIONS.md, docs/README.md router, M2.4.5 Standing Instructions/addenda, troubleshooting protocol, current RUNSHEET/CURRENT-STATE/FOLLOW-UPS/NEXT-CHAT and `CF-093-RUNTIME-OPS-FOLLOW-ON.md`. Pilot PR #79 head is `849f6f50e810bd77a6b3e02ef765df9c43f541db`; Fresh Reconstruction `34751520430`, Targeted Recovery `34751520442`, Frontend Build `34751520437`, Cloudflare and current Gitar threads are green/resolved. Pilot has deployed telemetry migration `20260913100615` and runtime-metrics migration `20260913102217`; preserve repository filenames `20260913101000...` and `20260913102500...` separately. The `jobs_runtime` rank-4 contract is deployed and ACL-proven. No natural post-telemetry-fix discovery run exists yet. Discovery/provider acquisition remains the bottleneck; do not weaken 401/fallback/security semantics. First collect natural post-fix discovery evidence and remediate provider health, then tune only from measured Before → Change → After results. CF-CHG-20260910-093 remains reopened and M2.5 remains paused.