# M2.4.2 — Current State

**Status:** ACTIVE — IMPLEMENTATION / TARGETED UAT; NOT YET ACCEPTED  
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

The existing architecture already includes `layer2_execution_policies`, `layer2_run_batches`, `layer2_run_items`, provider attempts, Evidence lifecycle, governed read/control functions and acquisition/extraction Edge runtimes. M2.4.2 extends/reconciles these contracts rather than creating duplicate concepts.

## Implemented first operational-maturity slice

- production-shaped Layer 2 operator workspace added;
- one-active-batch protection, heartbeat/stale recovery substrate and governed profile concurrency added;
- provider/source attempt telemetry, Evidence summary, scope/queueability and explicit Layer 3 fall-out visibility added;
- trial controls removed from the routine Layer 2 path;
- NZ Layer 2 Course deferral remains explicit;
- targeted deployed Stage A desktop run `33001852982` PASS;
- first-party deterministic scope-discovery worker/substrate deployed and mirrored, but broad discovery/full enrichment is not yet accepted.

## Addendum A8 — current slice: operator-first Sync

User/operator feedback on 27 August 2026 requires the next Layer 2 slice to reduce routine sync to country + university/catalogue-provider selection rather than exposing internal profile/provider mechanics.

Current implementation target:

`Country → University / catalogue provider → Scope preview → Sync / Recheck → Progress → Results`

Rules:
- only authorised Layer 2 profiles are launchable;
- NZ Course enrichment remains deferred/non-launchable;
- scope preview must distinguish catalogue, queueable and source-limited records before launch;
- if URLs are not governed/queueable, primary action becomes deterministic discovery rather than inferred enrichment;
- acquisition-vendor routing remains automatic under governed policy; manual Firecrawl/Scrape.do/etc. selection stays Advanced;
- active-run duplicate protection remains authoritative;
- normal operators are not expected to edit provider credentials/routes/concurrency.

### Reported provider-configuration defect

Firecrawl concurrency editing was reported as not saved. Current deployed value is still `2` (`rate_limit_per_minute=30`, `timeout_seconds=90`). The existing editor submits concurrency but lacks an explicit persistence acknowledgement/server-value verification contract. This slice must:
- validate provider bounds;
- persist the edit;
- re-read the saved provider from the server;
- display the persisted value / success state;
- prove close/reopen persistence in targeted UAT.

Profile execution concurrency and acquisition-provider concurrency must remain distinct and clearly labelled.

## Immediate work

1. Add governed operator Sync preview/control over existing profile/batch/discovery objects.
2. Replace routine source list as the primary launcher with country + university/catalogue-provider selectors and a clear scope/action card.
3. Fix and UAT acquisition-provider persistence, using Firecrawl concurrency as representative case.
4. Continue deterministic discovery across authorised AU profiles and convert governed candidates to queueable managed runs.
5. Execute representative/full authorised AU enrichment and capture performance/economics/Evidence/fall-out.
6. Complete Stage B desktop/mobile and exactly one final frozen Stage C candidate only after implementation/full-run evidence is stable.

## Acceptance state

M2.4.2 is not CLOSED/PASS. Stage A has passed for the first operational workspace slice, but A8 selector/sync/provider-persistence UAT, full authorised-run evidence, Stage B and final Stage C remain open.