# M2.4.5 NEXT CHAT

## Active baseline — 13 September 2026

- Milestone: **M2.4.5 — Pre-Production Hardening**. M2.5 remains paused; no Production Supabase project exists.
- Active Change Control: **CF-CHG-20260910-093 — REOPENED**.
- Visible accepted release remains **v2.15.78**.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- PR #72 is **MERGED** as `652c47326a99f3ce10f5b7479af30c4bed6d7391`.
- Pilot `main` is `9b450f9ebb48de70bdcdd409f24909ba39cc3a85` before the current follow-on PRs.
- Pilot PR #79: Scheduled Tasks runtime operations/efficiency, current known head `849f6f50e810bd77a6b3e02ef765df9c43f541db`; browser-visible Runtime Health means release-currentness/version reconciliation is required before merge.
- Pilot PR #80: `CF-093: repair exact-main UQ acceptance trigger`, initial exact head `f0633d2737f439e6cd72816fadb5f3979e34141b`.
- Admin PR #36 is superseded as a merge candidate: it is 70 commits ahead / 79 behind current Admin main with merge base `401a107d...` and contains stale governance assertions.
- Clean Admin reconciliation branch: `m245/cf093-runtime-ops-governance-reconcile-20260913`, based directly on current Admin main `900780deedd34b7461bfe71cfba8f477116c1f74`.

## Deployed runtime-operations state

Pilot runtime carries the forward-only observability changes:

- `20260913100615 cf_093_layer2_discovery_terminal_timestamp_observability`; repository source `20260913101000_cf_093_layer2_discovery_terminal_timestamp_observability.sql`.
- `20260913102217 cf_093_scheduled_runtime_metrics_read`; repository source `20260913102500_cf_093_scheduled_runtime_metrics_read.sql`.

Preserve deployment-ledger and repository-source identities separately; do not rewrite migration history.

The discovery terminal-timestamp trigger has rollback-only proof. Historical missing timestamps were not backfilled. No natural `layer2_discovery` job has yet occurred after the correction, so successful post-change discovery throughput remains **not yet observed**.

The governed `jobs_runtime` read is rank-4, denies anon/public helper execution, rejects rank-3, does not expose raw payload/result/error text/URLs/storage paths/secrets, and measured about `21.4 ms` execution for the bounded recent-50 runtime proof.

## Runtime bottleneck evidence

Queue wait is not the primary observed bottleneck. Discovery/provider acquisition remains the active efficiency issue.

Measured UQ evidence includes 50 scrape-do HTTP 401 failures and materially slower fallback-provider paths. ScraperAPI also reports credential-unavailable evidence for relevant fallback attempts. Do **not** add 401 as a fallback condition merely to improve throughput. Remediate provider authentication/health through the governed provider/secret lifecycle.

## Consequential acceptance recovery

After PR #72 merged, exact main `9b450f9e...` attempted replacement UQ acceptance through `CF-093 UQ Acceptance Dispatcher` run `34749286102`. Its latest attempt remains **queued with zero jobs materialised after three attempts** and is not acceptance evidence.

The delegated UQ workflow also targeted the old PR #72 branch-preview URL, so even a successful dispatcher would not have proved deployed-main currentness.

PR #80 corrects only that UAT infrastructure:

- direct UQ acceptance trigger when the maintained workflow change lands on `main`;
- deployed-main browser target `https://coursefinder-pilot.techm.workers.dev`;
- exact workflow SHA checkout;
- authenticated Admin/PIM Preview -> Run Now path;
- evidence artifact retention;
- no database/runtime authority, discovery route, retry/fallback, Layer 3/4, Search or Publication semantic change.

## Exact next gate

1. Complete PR #80 CI/review. Merge only if exact-head checks are clean.
2. Use the resulting direct deployed-main UQ acceptance run as the replacement authoritative consequential proof.
3. Validate exact Preview token/fingerprint/binding/dedupe/cancel semantics, deterministic Layer 2 Jobs/Evidence, and zero generic L3/L4/Search/Publication side effects.
4. Run RMIT only if UQ is clean and the current acceptance contract still requires it.
5. Reconcile PR #79 browser-visible release metadata/version, rerun exact-head CI/review, then merge only if clean.
6. Observe natural post-fix discovery history before making any throughput/concurrency/batch/retry tuning claim.
7. Resolve governed provider authentication/health before considering higher concurrency.
8. Keep CF-CHG-20260910-093 reopened until genuine consequential acceptance and final governance reconciliation complete.

## Authority/security boundary

Preserve Layer 1 authority, deterministic Evidence-preserving Layer 2, exact Preview-bound async continuation only where explicitly governed, Layer 3 Evidence/profile/model/revalidation governance, Layer 4 human authority, Search/Publication separation, rank/ACL/private-helper/service-role boundaries and immutable forward-only migration history. Missing telemetry remains unknown, never zero by assumption.

Codex remains deferred assurance where usage is unavailable and must not be represented as completed. Gitar is the active exact-head reviewer for current material follow-on heads.