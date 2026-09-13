# CF-CHG-20260910-093 — Runtime Operations Follow-on

**Status:** ACTIVE FOLLOW-ON / CF-093 REMAINS REOPENED  
**Updated:** 13 September 2026 AEST

## Purpose

Record the post-PR #72 Scheduled Tasks runtime-operations, observability and efficiency work without rewriting the accepted Preview-bound async Layer 2 authority contract or treating operational maturity as consequential acceptance closure.

## Current implementation

- PR #72 merged as `652c47326a99f3ce10f5b7479af30c4bed6d7391`.
- Pilot main then advanced to `9b450f9ebb48de70bdcdd409f24909ba39cc3a85` for replacement UQ acceptance dispatch.
- Pilot PR #79 is the runtime-operations/efficiency follow-on.
- Pilot PR #80 owns the acceptance-infrastructure recovery for direct deployed-main UQ acceptance.
- Visible accepted release remains v2.15.78 until a browser-visible follow-on is accepted and versioned.

## Observability corrections deployed

Forward-only runtime migrations:

1. Runtime ledger `20260913100615 cf_093_layer2_discovery_terminal_timestamp_observability`; repository source `20260913101000_cf_093_layer2_discovery_terminal_timestamp_observability.sql`.
2. Runtime ledger `20260913102217 cf_093_scheduled_runtime_metrics_read`; repository source `20260913102500_cf_093_scheduled_runtime_metrics_read.sql`.

Neither identity is to be renamed, retimestamped, removed or rewritten.

The terminal timestamp guard applies only when a `layer2_discovery` job reaches a terminal state without an existing `completed_at`. Historical rows are not backfilled. Rollback-only proof verified a real completion timestamp and measurable duration without dispatching ingestion.

The rank-4 `jobs_runtime` read returns only operationally safe derived fields. Runtime proof confirmed:

- authenticated rank-4 succeeds;
- authenticated rank-3 fails with `42501 pipeline_operator role required`;
- anon/public cannot execute the private helper;
- malformed `limit` input degrades to the bounded default rather than throwing a raw cast error;
- raw payload/result/error text, URLs, storage paths and secrets are not returned.

A bounded recent-50 deployed wrapper proof measured about `21.4 ms` execution.

## Runtime baseline

Initial two-day measurements before behavioural tuning:

- `layer2_acquisition_v2` succeeded: 773 jobs; average queue wait about `0.049 s`; average execution about `1.44 s`; median about `1.06 s`.
- `layer2_discovery` completed: 111 historical jobs had no trustworthy execution duration because `completed_at` was missing.
- failed discovery sample: average execution about `62.22 s`, median about `64.61 s`.
- three-day failed-discovery comparison baseline: 25 failed jobs / 111 processed / `1244.86 s` measurable execution / weighted throughput about `5.35 records/min`.

No natural post-correction `layer2_discovery` terminal job has yet occurred. Therefore successful post-change discovery throughput remains **unavailable**, not zero.

## Provider-path evidence

Measured UQ acquisition evidence shows direct HTTP is materially faster than later fallback providers. The measured period includes 50 scrape-do HTTP 401 failures. ScraperAPI also reports credential-unavailable evidence for relevant fallback attempts.

A 401 is a provider authentication/health condition. Do not add it to authorised fallback conditions merely to improve completion rate or throughput. Remediation belongs to the governed provider/secret lifecycle. Do not expose or manufacture credentials.

## Read-path optimisation evidence

Before deployment, the equivalent recent-50 metrics plan projected wide Job rows and measured roughly `112.5 ms` execution / `146.8 ms` planning in the initial run. Narrowing the projection to only required operational fields reduced projected row width from about `1477` bytes to about `60` bytes and the measured comparison run to about `2.6 ms` execution / `5.0 ms` planning. Cache warmth may contribute; do not claim the full delta as causal solely from projection narrowing.

The deployed authenticated wrapper later measured about `21.4 ms` execution and is the runtime reference point.

## Consequential acceptance infrastructure

`CF-093 UQ Acceptance Dispatcher` run `34749286102` on exact main `9b450f9e...` is stuck queued with zero jobs after three attempts. It is not acceptance evidence.

The delegated workflow also used the old PR #72 branch-preview URL. PR #80 changes the maintained corrective acceptance to trigger directly on `main` and target the deployed main Worker `https://coursefinder-pilot.techm.workers.dev` while retaining exact-SHA checkout and authenticated browser execution.

PR #80 is UAT infrastructure only; it does not change database/runtime authority or ingestion semantics.

## PR #79 release gate

Runtime Health is browser-visible. PR #79 currently retains package `0.1.5` and visible v2.15.78 release metadata. Current project instructions require visible UI version correlation, so PR #79 must reconcile release metadata/version before merge and then rerun exact-head CI/review.

Already-deployed observability migrations do not by themselves authorise promoting the browser-visible release.

## Exact next actions

1. Clear PR #80 CI/review and merge only if clean.
2. Use the resulting direct deployed-main UQ run as replacement authoritative acceptance.
3. Reconcile deterministic Jobs/Evidence, exact token/binding/dedupe/cancel and zero generic L3/L4/Search/Publication side effects.
4. RMIT only after UQ clean if still required.
5. Reconcile PR #79 release metadata/version and rerun exact-head checks/review.
6. Wait for legitimate post-fix discovery history before behaviour/performance tuning.
7. Resolve provider credential/health issues through governed secrets/provider configuration before any concurrency increase.

## Authority boundary

Do not weaken Layer 1 authority, Layer 2 deterministic Evidence truth, Layer 3 governance, Layer 4 human authority, Search/Publication separation, ACL/RLS/private-helper/service-role controls or Preview-bound continuation semantics merely to obtain a test or performance PASS.

`CF-CHG-20260910-093` remains reopened until current deployed-main consequential acceptance and final governance reconciliation are complete.