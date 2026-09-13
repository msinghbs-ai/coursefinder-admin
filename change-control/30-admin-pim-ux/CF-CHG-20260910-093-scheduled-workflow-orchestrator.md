# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** ACTIVE — EXACT-HEAD CODEX REVIEW PENDING / CORRECTIVE ACCEPTANCE PAUSED  
**Initiated:** 2026-09-10 AEST  
**Reconciled:** 2026-09-13 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Active Pilot PR:** #72 (`m245/cf093-async-discovery-20260912`)  
**Candidate head:** `a035714aa5bd9b4d88ae47a59c877b3514a1f287`  
**Visible accepted release:** v2.15.78

## Objective

Complete the bounded Scheduled Tasks run-on-demand contract for large AU Course Facts scopes without weakening Layer 1 authority, deterministic Layer 2 Evidence truth, Layer 3 Evidence/profile/model/revalidation governance, Layer 4 human resolution, Search/Publication separation or rank/ACL boundaries.

## Current decision

PR #72 remains OPEN / DRAFT / mergeable but governance-blocked. The previously identified exact-token/provenance/write-time-identity/dedupe/terminal-accounting defects now have forward fixes and exact-head CI/reconstruction is green. Fresh Codex review of the current exact head remains the next independent gate. Corrective UQ/RMIT discovery, Layer 3, merge and release remain paused until that review is reconciled.

## Current exact-head evidence

- Candidate head `a035714aa5bd9b4d88ae47a59c877b3514a1f287`.
- CF-093 Targeted Recovery `34726688848`: **PASS**.
- CF-093 Fresh Reconstruction `34726688865`: **PASS** — complete ordered PR-added CF-093 migration chain replay on a fresh reconstructed accepted-main dependency baseline.
- Pilot Frontend Build `34726688863`: **PASS**.
- Cloudflare preview: **PASS/deployed at `a035714a`**.
- Fresh exact-head Codex request: PR comment `5649524865`; no exact-head technical review submission observed at reconciliation. Silence is not approval.

## Forward runtime hardening

Applied/checked-in forward migration:

`20260912232827_cf_093_preview_provenance_terminal_dedupe_hardening`

It enforces:

1. accepted selected/terminal discovery outcomes linked through provider attempt/job provenance to the exact Preview token;
2. fail-closed handoff when a supplied Preview binding is absent/cancelled/expired/mismatched;
3. every `discovery_started` profile must have reusable async handoff or explicit terminal-only completion before completion dedupe can suppress recovery;
4. explicit terminal-only and mixed actionable/terminal accounting;
5. preservation of the first cancellation time/reason on idempotent replay.

Deployed worker:

- `layer2-scope-discover-scheduled-v1.3.10`;
- Edge version 29;
- SHA `665c56ade30fa89b517255bb023c8ce1a15f88df3935845baeeba17cca21c051`;
- existing custom nonce/auth boundary retained.

Worker v1.3.10 revalidates the bound identity after network acquisition and before Evidence/candidate writes, evaluates exact title identity against original and prefix-stripped canonical titles, records qualified terminal basis metadata, and preserves `discovery_zero_results` provider-attempt telemetry.

## Reconstruction / migration currentness

Applied migrations remain immutable. The UQ reconstruction bootstrap `20260912005000` precedes immutable `20260912005948` in source/runtime history. The maintained reconstruction workflow now replays every PR-added CF-093 migration from `20260911231544` through `20260912232827` in order; exact-head run `34726688865` passed.

This proof is specifically the complete CF-093 PR migration chain against a reconstructed accepted-main dependency baseline. It does not assert that unrelated historical operational-data migrations are independently reconstructable, and no unrelated identity/source data is fabricated to make the proof pass.

## Authority boundaries retained

- Layer 1 identity/source authority unchanged.
- Layer 2 deterministic Evidence truth preserved and fail-closed.
- `layer3_required` is an L2 disposition only; generic scheduler Layer 3 remains prohibited.
- Layer 4 human resolution remains separate.
- Search/Publication remains separately governed.
- No URL/profile/route/zero-result marker/identity/Evidence may be manufactured for acceptance.
- Direct ad-hoc mutation of Supabase migration history remains prohibited.

## Historical large-university evidence

Retain for evidence only:

- UQ batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`: 248 `resolved_l2` + 3 `layer3_required`.
- RMIT batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f`: 213 `resolved_l2` + 50 `layer3_required`.

Previous hardened snapshots:

| Cohort | Scoped | Queueable | Reopened discovery | Retained terminal negatives |
|---|---:|---:|---:|---:|
| UQ | 382 | 251 | 54 | 77 |
| RMIT | 500 | 263 | 27 | 210 |

No corrective UQ/RMIT rediscovery has been dispatched after the current hardening. The next accepted counts must come from new authenticated Previews after the exact-head Codex gate closes.

## Exact next gates

1. Reconcile fresh Codex review for exact head `a035714...`; forward-fix any reproducible P1/P2 with the smallest safe change only.
2. After any change, rerun exact-head Targeted Recovery, complete CF-093 reconstruction, Frontend Build and Cloudflare currentness; request another exact-head Codex review.
3. When Codex/CI/runtime are clean, run new authenticated UQ/RMIT Previews and only the currently actionable corrective discovery scopes.
4. Reconcile only newly selected/changed deterministic Layer 2 work and prove exact-token/fingerprint/dedupe/cancel behaviour plus zero generic Layer 3/Layer 4 auto-approval/Search/Publication side effects.
5. Recalculate Layer 3 eligibility only after deterministic Layer 2 acceptance closes.
6. Merge/release remains prohibited until every runtime, UAT, security/authority, Codex and governance gate is clean.

## Next AU qualification wave

Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW remains deferred until CF-093 closes. Cohort membership is not authority to manufacture configuration.