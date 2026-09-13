# CF-CHG-20260910-093 — Runtime Operations Follow-on

This document supersedes continuation through Admin PR #34. It does not rewrite or invalidate merged Pilot PR #72 or any applied Pilot migration.

## Current continuity

- Pilot PR #72 is merged and remains immutable historical implementation evidence.
- Remaining closure/operational work continues in Pilot PR #79 linked to Coursefinder-Pilot issue #74.
- Admin PR #34 is superseded by Admin PR #36 from the same exact prior head plus this continuity record.
- Codex exact-head review remains deferred assurance and must not be represented as completed.
- Gitar is the active reviewer for the follow-on PRs.
- Pilot PR #79 exact current head is `3d6b6a90893cf12a7fef9346dcacd24d2ddd2e8f`.
- Exact-head validation on `3d6b6a9...`: CF-093 Fresh Reconstruction run `34750872835` PASS; CF-093 Targeted Recovery run `34750872803` PASS; Pilot Frontend Build run `34750872795` PASS; Cloudflare commit preview PASS; Gitar exact-head response reports Approved / no issues.
- Visible accepted release remains v2.15.78. PR #79 is an unmerged runtime-operations candidate and does not promote a new visible release.

## Runtime baseline — 13 Sep 2026

The Pilot runtime was measured directly before behavioural tuning. No runtime values below are inferred from missing timestamps.

- `layer2_acquisition_v2` / `succeeded`: 773 Jobs in the initial two-day sample; average queue wait `0.049 s`; 773 measurable executions; average execution `1.44 s`; median execution `1.06 s`; zero terminal Jobs missing `completed_at`.
- Before telemetry correction, `layer2_discovery` / `completed`: 111 Jobs; average queue wait `0.078 s`; zero trustworthy execution durations because all 111 terminal rows were missing `completed_at`.
- Initial `layer2_discovery` / `failed`: 20 Jobs; average queue wait `0.081 s`; average measurable execution `62.22 s`; median `64.61 s`.
- Three-day failed-discovery baseline used for later before/after comparison: 25 failed Jobs, 111 records processed, `1244.86 s` total measurable execution and weighted throughput `5.35 records/min`.
- `scheduler_workflow_preview` / `completed`: 12 Jobs; effectively zero stored queue/runtime delay at stored timestamp precision.

### UQ provider-route evidence

Affected profile `au-uq-course-catalogue` remains enabled and unpaused. Governed route order is direct-http → Firecrawl → scrape-do → scraperapi → ZenRows.

Observed three-day attempt evidence:

- direct-http: 912 successful attempts, average latency about `1047.8 ms`;
- direct-http extraction failures: 201, about `360.4 ms` average;
- Firecrawl extraction failures: 201, about `2293.7 ms` average;
- scrape-do extraction failures: 149, about `4175.5 ms` average;
- ZenRows extraction failures: 141, about `5621.9 ms` average;
- scrape-do HTTP 401 failures: 50, about `236.9 ms` average;
- provider zero-result paths are also materially slower on scrape-do/ZenRows than direct acquisition.

`401` is not an authorised fallback condition. Do not add it merely to improve throughput. A 401 is an authentication/provider-health condition and must remain fail-closed until the governed credential/provider-health path is corrected. ScraperAPI is later in the configured route chain but runtime evidence currently reports credential unavailable for relevant fallback attempts. No secret value is recorded here.

## First read-only Runtime Health increment

Scheduled Tasks now exposes, from the existing governed Jobs read surface:

- recent Job sample size;
- average queue wait where both `created_at` and `started_at` exist;
- average execution duration where both `started_at` and `completed_at` exist;
- queued/running and failed counts;
- terminal Jobs missing completion timestamps;
- per-Job queue wait, execution duration, total duration, exact start/completion availability and failure/outcome text;
- direct follow-through to Jobs and Evidence.

Missing timestamps render as `Unavailable`, not zero. Existing `attempt_count` is not interpreted as retry count because runtime semantics vary by workload. Processed/accepted/rejected counts, retry exhaustion, dedupe rate and Evidence yield remain unavailable in this surface until an accepted governed read contract exposes trustworthy values.

## Corrective telemetry increment

Defect classification: **implementation / observability defect**.

Root cause: the Layer 2 discovery success/partial terminal path could set `pipeline.jobs.status='completed'` and persist `result.processed`/`result.failed` without a `completed_at`, while failed terminal paths wrote the timestamp. This made successful discovery duration and throughput unmeasurable.

Smallest safe correction:

- Repository source migration: `20260913101000_cf_093_layer2_discovery_terminal_timestamp_observability.sql` on Pilot PR #79.
- Deployed Pilot migration identity: `20260913100615 cf_093_layer2_discovery_terminal_timestamp_observability`.
- The difference between repository filename timestamp and deployed migration ledger ID is retained as deployment identity; neither history is rewritten or retimestamped.
- Runtime trigger `pipeline.layer2_discovery_terminal_timestamp_v1` stamps `clock_timestamp()` only when a `layer2_discovery` row enters a terminal state with `completed_at IS NULL`.
- It does not change routing, batch/chunk size, concurrency, retry policy, provider fallback, Evidence, canonical acceptance, Search or Publication.
- Historical completed rows remain unchanged. Missing historical timestamps remain unknown rather than being fabricated.
- Rollback-only runtime proof inserted a synthetic terminal discovery Job inside a transaction, verified `completed_at` was stamped with a measurable `2.009 s` duration, then rolled back. No discovery, Evidence or canonical mutation occurred.

Rollback/reversion, if required, must be a new forward-only migration dropping the trigger/function; do not rewrite this applied migration.

## Governance corrections carried forward

The replacement Admin PR must resolve, not suppress, the previously identified governance defects:

1. use the full scheduler authority identifier `CF-CHG-20260910-093` where ambiguity with older `CF-093` shorthand could occur;
2. preserve mandatory server-side Preview before consequential dispatch;
3. use current-main, policy-qualified target selection;
4. never dispatch a target with an execution-policy/profile/route gap;
5. keep applied migration history immutable and forward-only.

## Next operational objective

The telemetry write defect is corrected in Pilot runtime. Behavioural efficiency tuning is still gated on trustworthy natural-run evidence.

Immediate next gate:

1. observe the next legitimate `layer2_discovery` terminal Job and confirm the deployed trigger yields a real `completed_at`; do not dispatch consequential work merely to make this proof green;
2. extend the governed rank-4 Jobs read contract only as necessary to expose trustworthy processed/selected/failed counts, derived throughput, failure class, retry exhaustion/dedupe and Evidence yield without exposing secrets/private Evidence;
3. remediate scrape-do/provider credential-health through the governed provider/secret lifecycle rather than weakening 401/fallback behaviour;
4. compare discovery Before → Change → After once enough post-correction natural runs exist;
5. only then consider evidence-backed batch/chunk size, concurrency or retry changes.

Required operational measurements remain:

- queue wait and execution duration;
- processed items and effective throughput;
- deterministic Layer 2 versus discovery workload mix;
- retry/attempt/exhaustion behaviour;
- dedupe/replay outcomes;
- failure/completion classes;
- Evidence yield and accepted/applied results where exposed by governed interfaces;
- per-policy/provider/scope last success and failure;
- scheduler/acquisition/processing phase timing where runtime already exposes those boundaries.

Missing values remain unknown. Do not manufacture measurements, routes, policies, profiles, URLs, capabilities or credentials.

## Tuning authority

Tuning is allowed only when the relevant setting already exists in governed configuration and a before/after bounded comparison can be produced. Candidate areas are batch/chunk size, concurrency, retry bounds, freshness/cadence, query/index performance and dedupe windows.

Every material tuning change must preserve:

- Layer 1 regulatory/identity authority;
- deterministic, Evidence-preserving Layer 2;
- exact Preview/token/fingerprint/identity provenance;
- Layer 3 Evidence/profile/model/revalidation governance;
- Layer 4 human resolution;
- Search/Publication separation;
- rank/ACL/private-helper/service-role boundaries;
- fail-closed generic async discovery outside explicitly governed Preview-bound continuation contracts.

## Closure

`CF-CHG-20260910-093` does not return to CLOSED/PASS because PR #72 merged, Runtime Health is green, or the telemetry defect is corrected. Closure still requires current-main consequential acceptance on genuinely governed targets, deployed-currentness/UAT evidence and authoritative Admin reconciliation. Runtime-efficiency work may continue in parallel but must not manufacture closure evidence.