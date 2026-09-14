# M2.4.5 NEXT CHAT

## Active baseline — 14 September 2026 AEST

- Milestone: **M2.4.5 — Pre-Production Hardening**.
- M2.5 remains paused; no Production Supabase project exists.
- Active Change Control: **CF-CHG-20260910-093 — REOPENED for final runtime/governance closure**.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Current Pilot main: **`7196c5d2fade8830ec371c663b008e8a47e01f74`**.
- Visible accepted/recovery release: **v2.15.79 / package 0.1.6**.
- Pilot PR #90 merged and promoted v2.15.79 to the accepted recovery baseline after the release-currentness/deployed validation sequence.
- v2.15.78 remains immutable retained history, but is no longer the active recovery release.
- Admin PR #37 remains the governance reconciliation vehicle and must be reconciled to this newer Pilot/runtime truth before merge.

## CF-093 runtime / acceptance state

The Preview-bound Scheduled Tasks / Layer 2 authority contract remains accepted. Preserve:

- same-actor Preview before consequential dispatch;
- exact Preview token/fingerprint/binding/identity provenance;
- deterministic Evidence-preserving Layer 2;
- bounded provider/policy/credential/budget qualification;
- no generic scheduler Layer 3 auto-approval;
- Layer 4 human authority for unresolved outcomes;
- no implicit Search/Publication consequence;
- forward-only immutable migration history.

Six-university discovery remains terminal at **1,676 / 1,676 distinct courses accounted for**. RMIT deterministic Layer 2 batch `74b4b16f-20f0-4b61-a9e0-632d824f001a` previously reached terminal `partial` at **263 / 263 processed**, with provider/source latency identified as the dominant efficiency constraint. Do not relax identity matching or increase dispatcher/provider concurrency without comparable evidence.

## Dispatcher / metrics baseline

The merged runtime-operations work added governed Administration → Scraper Config tuning and comparable run metrics while retaining existing security and authority boundaries.

Current guardrails/evidence retained from the accepted implementation:

- ordinary transport wave cap 4;
- scraper-first cap 2;
- pg_net ceiling 120 seconds;
- rank-4 sanitized metrics read; lower rank/anonymous denied;
- rank-5+ tuning only;
- mandatory governance reason and tuning audit trail;
- in-flight batch `policy_snapshot` remains immutable;
- provider credentials/routing remain separate controls;
- no automatic tuning from metrics alone.

Last comparable RMIT signal recorded before release acceptance: active throughput about **2.68 items/min**, Firecrawl current-profile average attempt about **14.64 s**, extraction about **1.94 s**, and zero HTTP 429s. The evidence pointed to provider/source latency rather than dispatcher concurrency as the bottleneck.

## Deployed UAT recovery completed

After v2.15.79 promotion, Pilot main `7196c5d2fade8830ec371c663b008e8a47e01f74` received targeted deployed UAT run **`34819914624`**.

Initial attempt:

- 5 Layer 1 deployed tests passed;
- NZQA real authority/count validation failed twice because `layer1-operations-control` returned HTTP 500;
- CRICOS and other Layer 1 checks passed;
- the failure was treated as runtime/recovery evidence, not as permission to weaken the UAT contract.

Recovery action:

- failed job `103900330312` was re-run as job `103960817860`;
- replacement attempt completed **SUCCESS**;
- commit status is now **`coursefinder/deployed-uat/targeted/chromium-desktop = success`** for `7196c5d...`.

This clears the immediate red GitHub Actions status. Retain the first NZQA HTTP 500 as transient runtime evidence and watch recurrence rather than suppressing it.

## Exact next gate

1. Reconcile Admin PR #37 and CF-CHG-20260910-093 to accepted Pilot main `7196c5d...`, v2.15.79 and deployed UAT recovery run `34819914624` attempt 2 PASS.
2. Merge the Admin governance reconciliation only when its exact head reflects this final Pilot/runtime truth.
3. Keep CF-093 REOPENED until REGISTER/RUNSHEET/CURRENT-STATE/FOLLOW-UPS and the Change Control itself are reconciled and the final closure decision is evidenced; do not infer CLOSED/PASS only from the release promotion.
4. Begin/continue evidence-led operational monitoring using the existing CF Batch Metrics / SYSTEM-METRICS model. Measure real governed runs only; do not create synthetic production-like load merely to produce metrics.
5. Track at minimum throughput, queue wait/execution time, provider response p50/p95, extraction p50/p95, retries, Evidence counts, field-resolution yield, provider unit/budget consumption, HTTP 429/5xx/error rates, terminal outcomes and any recurrence of `admin_read`/NZQA runtime 5xx.
6. Hold dispatcher/provider settings steady until another legitimately comparable governed run provides evidence for a change.
7. Keep M2.5 paused unless separately authorised.

## Operating expectation for continuation

Proceed autonomously through normal governed decisions and recovery/re-run loops instead of stopping for repeated `proceed` confirmations. Stop only for a true authorisation, security, destructive/irreversible or externally unavailable capability boundary. Before tool/runtime limits, update this handover and the other continuity files with exact repo heads, run IDs, blockers and the first next action.
