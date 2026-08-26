# M2.4.2 — Current State

**Status:** ACTIVE — RECONCILIATION / IMPLEMENTATION NOT YET ACCEPTED  
**Started:** 27 August 2026 04:28 AEST (+10:00)  
**Change Control:** `CF-CHG-20260827-044` — ACTIVE  
**Accepted starting Pilot:** `ed41ea4d7d6672e871cd4ce401bfca24fe3eb64d`  
**Visible browser baseline:** PIM Admin `v2.15.7`

## Accepted inherited baseline

- M2.4.1 CLOSED/PASS.
- AU/NZ Layer 1 authority, source validation, Evidence, queue, retry/resume, variance, scheduling, security and housekeeping contracts are frozen dependencies.
- Layer 2 remains deterministic acquisition/extraction.
- Layer 3 receives governed unresolved fall-out only.
- Layer 4/Search/Publication authority remains unchanged.
- NZ first-party Layer 2 Course enrichment remains DEFERRED unless separately qualified/authorised.

## Start reconciliation

Pilot `main` was verified at the accepted M2.4.1 SHA when M2.4.2 began.

Deployed Pilot Supabase initial counts:

- Layer 2 source profiles: 6;
- profile versions: 13;
- acquisition providers: 6;
- profile-provider routes: 26;
- provider attempts: 103;
- execution policies: 4;
- run batches: 1;
- run items: 3;
- Evidence artifacts: 1,699.

The existing architecture already includes `layer2_execution_policies`, `layer2_run_batches`, `layer2_run_items`, provider attempts, Evidence lifecycle, governed read/control functions and acquisition/extraction Edge runtimes. M2.4.2 will extend/reconcile these contracts rather than create duplicate concepts.

## Immediate work

1. Reconcile authorised source/profile/provider catalogue and explicit NZ deferral.
2. Reconcile current browser Layer 2 workspace and advanced/experimental paths.
3. Reconcile execution-policy, batch/item, provider-attempt, Evidence, completeness and Layer 3 fall-out contracts.
4. Reconcile current Edge functions, scheduler/cron, secrets boundary and current provider budget controls.
5. Implement additive operational maturity gaps.
6. Execute representative/full authorised AU enrichment and capture performance/economics/Evidence/fall-out.
7. Complete staged A → B → exactly one final C acceptance candidate.

## Acceptance state

M2.4.2 is not CLOSED/PASS. No full authorised-run or final Stage C evidence exists yet.