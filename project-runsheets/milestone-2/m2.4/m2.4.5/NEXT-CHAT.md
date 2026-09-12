# M2.4.5 NEXT CHAT

## Current pickup — 12 September 2026

- Milestone: **M2.4.5 ACTIVE / PRE-PRODUCTION HARDENING**.
- M2.5 remains PAUSED at P0; no Production Supabase project exists.
- Accepted Pilot `main`: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: **v2.15.78**.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Active change: `CF-CHG-20260910-093`.
- Active Pilot PR #72: `m245/cf093-async-discovery-20260912` at `692ba7ef93e19d833963d96dab2558b340eaea17`.
- Exact-head Frontend Build `34657854675`: PASS.
- Cloudflare PR preview: deployed successfully.
- Exact-head Codex result: **not present / pending**.

## UQ acceptance result

Fresh Preview token `df7affe7-8d65-4527-a834-e8ac879afb06` proved UQ 382 scope executable with 156 queueable + 226 discovery and zero profile/policy/route/oversize/discovery-config gaps.

A fresh Run now was dispatched after the recent-dispatch dedupe window cleared. All 226 historical-unresolved discovery Courses were retried, proving the retry hardening works while preserving history.

Terminal latest dispositions:

- 115 current_page_not_found;
- 79 identity_mismatch;
- 27 ambiguous;
- 5 likely_match with selected current URLs.

Seven bounded discovery Jobs ran. Final pg_net request `5759` returned HTTP 500:

`layer2_scope_profile_batch_service: scheduler async discovery did not produce a current selected URL for every preview-bound discovery course`

No deterministic Layer 2 batch handoff occurred. This is a correct fail-closed acceptance failure, not a PASS. RMIT was therefore not run.

## Repository/runtime blocker

Pilot runtime already records the five PR #72 logical migrations under immutable applied versions:

`20260911231544`, `20260911231600`, `20260911231845`, `20260911232205`, `20260911232239`.

PR #72 source currently names the corresponding migration files `20260912010000`–`20260912010400`. Do not alter applied Pilot migration history. Reconcile repository source identity before merge and rerun exact-head gates after any branch change.

## Layer 3 state

Do not enable generic scheduler Layer 3. The existing Course Evidence interpretation profile remains governed by profile/model/revalidation and its live-provider acceptance. The failed UQ run did not invoke Layer 3.

## First actions in the next chat

1. Read `PROJECT_INSTRUCTIONS.md`, `docs/README.md`, M2 Standing Instructions/Addenda, troubleshooting/recovery protocol, CF-093 and current M2.4.5 continuity.
2. Reconcile current Admin/Pilot heads, PR #72 head, CI/Codex, Pilot migration/runtime and Cloudflare before acting.
3. Inspect retained UQ discovery Jobs/Evidence and representative first-party official pages for the 115/79/27 unresolved outcomes.
4. Qualify/correct the UQ discovery/search and identity-confirmation contract without lowering CRICOS/detail proof or fabricating URLs/config.
5. Reconcile PR #72 migration source identities with immutable runtime truth.
6. Run targeted retry/binding regression.
7. When the failed UQ binding is no longer active under the governed contract, run a fresh UQ Preview → Run now → discovery continuations → deterministic Layer 2 acceptance.
8. Only on UQ PASS: prove same-token replay + fresh-preview dedupe, then run RMIT 500-course proof.
9. After clean Layer 2 proof, assess Layer 3 only through the existing Evidence/profile/model/revalidation contract.
10. Final exact head requires clean Codex + CI/UAT/runtime acceptance before merge/deploy.

## Subsequent AU qualification wave

After UQ and RMIT pass: Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW, using normal qualification only.

## Pickup text

> Continue CF M2.4.5 / CF-CHG-20260910-093 from repository/runtime truth. Accepted Pilot main is `63c7107cfce2d8f607fc378af4881d0ba28ca879`, visible release v2.15.78. PR #72 is the active forward candidate at `692ba7ef93e19d833963d96dab2558b340eaea17`; Frontend Build `34657854675` and Cloudflare preview are PASS, but no exact-head Codex result is present. Fresh UQ Preview `df7affe7-8d65-4527-a834-e8ac879afb06` was executable for 382 Courses (156 queueable/226 discovery), and all 226 unresolved discovery Courses were retried. Final dispositions were 115 current_page_not_found, 79 identity_mismatch, 27 ambiguous and 5 likely_match/selected. Final pg_net request `5759` failed closed because every Preview-bound discovery Course did not have a current selected URL, so deterministic L2 did not hand off and RMIT was not run. Also reconcile PR #72 repository migration filenames `20260912010000`–`20260912010400` against immutable Pilot-applied identities `20260911231544`, `20260911231600`, `20260911231845`, `20260911232205`, `20260911232239` without rewriting runtime history. Resolve UQ discovery qualification first, rerun UQ, then RMIT, then bounded existing Layer 3; merge/deploy only after exact-head Codex/CI/UAT/runtime acceptance is clean.
