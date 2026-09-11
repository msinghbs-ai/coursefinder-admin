# CF-CHG-20260910-093 Acceptance

**Status:** CLOSED / PASS — ACCEPTED TARGET-BUILDER BOUNDARY  
**Updated:** 11 Sep 2026

## Accepted baseline

- Pilot functional target-builder PR **#69** merged as `85bc068d379ed3fc9231d167cf524e56419e80f9`.
- Release-currentness PR **#70** merged as `cfc4702ba57a58ea31936dcabbd96fdd765194e2`.
- Visible PIM Admin release: **v2.15.78**.
- Post-merge Release History Contract `34579029903` — **PASS**.
- Post-merge Pilot Frontend Build `34579029934` — **PASS**.
- Post-merge CourseFinder Deployed UAT `34579029850` — **PASS**.
- Codex review of the exact v2.15.78 release head `aa4fb9be7c0567b557092f52c218475fae9ba5a3` reported no major issues before merge.

## Accepted Phase A

Scheduled Tasks retains the accepted operator controls from v2.15.77: business-readable task/target labels, server-side search, durable creator/owner attribution, personal column preferences, audited bounded schedule edit, bounded Layer 1–2 Run on demand and explicit Jobs/Evidence follow-through. Layer 3 remains Evidence/profile/model/revalidation governed and Layer 4 remains audited human resolution.

## Accepted Phase B — governed target builder

The accepted executable slice is deliberately narrow:

- **Dataset:** Course Facts enrichment.
- **Country:** AU only.
- **Scope:** Country, State/Territory or University/Provider through server-authorised Layer 2 scope services.
- **Processing mode:** Acquisition + deterministic Layer 2 only.
- **Preview:** mandatory server-side preview before consequential dispatch; actor-bound, exact-target/mode-bound and time-limited.
- **Qualification:** current valid source-profile version, required deterministic Layer 2 execution policy and per-profile scope no larger than the existing 1,000-course downstream contract.
- **Dispatch:** live runnable-scope revalidation, exact-target locking, cross-operator recent-dispatch reuse and atomic empty-start rejection.
- **Follow-through:** underlying Layer 2 Jobs/Evidence remain authoritative for actual processing state.

The browser `scheduler_workflow_run_now_v1` path remains retired; governed execution uses the accepted v2 path.

## Runtime lineage

Applied Pilot migrations are immutable and include:

1. `20260911021144 cf_093_scheduler_workflow_builder_slice`
2. `20260911021847 cf_093_scheduler_workflow_bridge_acl_fix`
3. `20260911022312 cf_093_scheduler_workflow_preview_token_idempotency`
4. `20260911023721 cf_093_scheduler_workflow_codex_second_pass`
5. `20260911025332 cf_093_scheduler_workflow_codex_third_pass`
6. `20260911031554 cf_093_scheduler_workflow_codex_fourth_pass`
7. `20260911052952 cf_093_scheduler_execution_policy_qualification`
8. `20260911065626 cf_093_scheduler_policy_and_scope_limit_qualification`

No applied migration was retimestamped or rewritten.

## Nominated functional acceptance

The final consequential acceptance used a genuinely policy-qualified AU Course Facts scope rather than the known-ineligible RMIT UP/Nova candidates. The accepted UQ scope preview covered **382 courses**. Dispatch was accepted; same-token retry and a second fresh-preview dispatch reused the original recent dispatch rather than creating duplicate acquisition. The underlying Layer 2 batch progressed and produced governed Evidence. No generic Layer 3 interpretation, Layer 4 resolution, Search admission or Publication side effect was observed from the target-builder run.

Earlier RMIT UP and Nova findings remain useful negative evidence: a scope without the required deterministic Layer 2 execution policy must fail closed before paid discovery/acquisition rather than manufacturing a policy to make UAT pass.

## Security and authority acceptance

- Anonymous and low-rank execution remain denied.
- Private helpers remain outside the browser-facing contract and browser execution remains through authenticated/rank-gated public wrappers.
- Unsupported processing modes and unenforceable scopes remain unavailable/fail closed.
- Layer 1 authority is unchanged.
- Layer 3 Evidence/profile/model/revalidation rules are unchanged.
- Layer 4 remains human/exception resolution.
- Search and Publication remain separate governed boundaries.
- The existing Security Advisor informational RLS baseline was not weakened to pass CF-CHG-20260910-093.

## UAT recovery reconciliation

The first post-functional-merge deployed UAT run failed because the ranking workflow test still asserted historical visible release `v2.15.74`; its retry also observed a transient `admin_read('dashboard')` 500. The release-currentness follow-up corrected only the stale version-currentness assertion to derive the expected version from the maintained release-currentness source. No server-error assertion, authority boundary or UAT guardrail was relaxed. The subsequent post-merge deployed UAT for `cfc4702...` passed.

## Explicitly not authorised by this acceptance

- generic automatic L2 -> L3 -> L4 orchestration;
- generic Layer 3 Evidence reprocessing;
- arbitrary Layer 1 target construction;
- NZ Layer 2 Course enrichment;
- recurring country/state scope construction;
- recurring university construction without a separately accepted enforceable contract;
- implicit Search or Publication actions.

These remain future governed work and must not be inferred from this CLOSED/PASS change.

## Closure gate

CF-CHG-20260910-093 is accepted and may be closed at the boundary above. Governance continuity must point to Pilot main `cfc4702ba57a58ea31936dcabbd96fdd765194e2`, visible v2.15.78, and the three green post-merge gates listed above. M2.4.5 remains ACTIVE overall and this closure does not advance M2.5 from its paused P0 gate.