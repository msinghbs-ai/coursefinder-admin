# CF-CHG-20260910-093 — Runtime Operations Follow-on

This document supersedes continuation through Admin PR #34. It does not rewrite or invalidate merged Pilot PR #72 or any applied Pilot migration.

## Current continuity

- Pilot PR #72 is merged.
- Remaining closure/operational work continues in Pilot PR #79 linked to Coursefinder-Pilot issue #74.
- Admin PR #34 is superseded by Admin PR #36 from the same exact prior head plus this continuity record.
- Codex exact-head review is deferred assurance only because usage was exhausted. It must not be represented as completed.
- Gitar is the active reviewer for the replacement follow-on PRs.
- Pilot PR #79 exact corrective head `b01d0a1909c1419fb806d6819e3969224c7d9327` implements the first read-only Scheduled Tasks Runtime Health increment. CF-093 targeted contracts and Pilot Frontend Build are green, Cloudflare preview is green, and Gitar reports `Approved` with its prior navigation-guard finding resolved.

## Runtime baseline — 13 Sep 2026

The Pilot runtime was measured directly before behavioural tuning. No runtime values below are inferred from missing timestamps.

- `layer2_acquisition_v2` / `succeeded`: 773 Jobs in the two-day sample; average queue wait `0.049 s`; 773 measurable executions; average execution `1.44 s`; median execution `1.06 s`; zero terminal Jobs missing `completed_at`.
- `layer2_discovery` / `completed`: 111 Jobs; average queue wait `0.078 s`; zero trustworthy execution durations because all 111 terminal rows are missing `completed_at`.
- `layer2_discovery` / `failed`: 20 Jobs; average queue wait `0.081 s`; average measurable execution `62.22 s`; median `64.61 s`.
- `scheduler_workflow_preview` / `completed`: 12 Jobs; zero measurable queue/runtime delay at stored timestamp precision.
- Current discovery failures include provider exhaustion, `route_stopped:scrape-do:401`, missing provider credentials on some fallback routes, acquisition-budget exhaustion and current-page-not-found outcomes. These are operational findings, not permission to manufacture credentials or weaken routing policy.
- UQ current runtime Preview is policy/profile/route-qualified for governed acquisition-only dispatch and uses the accepted Preview-bound async-discovery continuation contract where discovery is necessary. This supersedes older continuity language that treated every discovery-backed UQ scope as intrinsically non-executable; CF-093 closure nevertheless remains separately gated by current authoritative acceptance criteria.

## First read-only Runtime Health increment

Scheduled Tasks now exposes, from the existing governed Jobs read surface:

- recent Job sample size;
- average queue wait where both `created_at` and `started_at` exist;
- average execution duration where both `started_at` and `completed_at` exist;
- queued/running and failed counts;
- terminal Jobs missing completion timestamps;
- per-Job queue wait, execution duration, total duration, exact start/completion availability and failure/outcome text;
- direct follow-through to Jobs and Evidence.

Missing timestamps render as `Unavailable`, not zero. Existing `attempt_count` is not interpreted as retry count because runtime semantics vary by workload. Throughput, processed/accepted/rejected counts, retry exhaustion, dedupe rate and Evidence yield remain explicitly unavailable in this surface until an accepted governed read contract exposes trustworthy values.

## Governance corrections carried forward

The replacement Admin PR must resolve, not suppress, the previously identified governance defects:

1. use the full scheduler authority identifier `CF-CHG-20260910-093` where ambiguity with older `CF-093` shorthand could occur;
2. preserve mandatory server-side Preview before consequential dispatch;
3. remove obsolete Pilot-head and target assumptions and use current-main, policy-qualified target selection;
4. do not dispatch a target with an execution-policy/profile/route gap;
5. keep applied migration history immutable and forward-only.

## Next operational objective

Scheduled Tasks now moves from functional acceptance toward runtime operational maturity. The next workstream must collect real runtime evidence and tune only from observed data.

Immediate next gate:

1. reconcile why `layer2_discovery` can reach terminal `completed` while `pipeline.jobs.completed_at` remains null;
2. trace the dominant provider-route failure classes, especially `scrape-do:401`, without weakening fail-closed acquisition or credential boundaries;
3. expose additional processed/yield/retry/dedupe/Evidence metrics only through an accepted governed read contract;
4. establish a trustworthy before/after baseline before changing discovery batch size, concurrency or retry policy.

Required operational measurements include:

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

`CF-CHG-20260910-093` does not return to CLOSED/PASS merely because PR #72 merged or because Runtime Health is green. Closure still requires current-main consequential acceptance on genuinely governed targets, deployed-currentness/UAT evidence and authoritative Admin reconciliation. Runtime-efficiency work may continue in parallel, but must not be used to manufacture closure evidence.