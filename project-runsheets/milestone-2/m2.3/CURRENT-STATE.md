# M2.3 Current State

**Status:** ACTIVE / GO 4 UI-RUNTIME LAUNCHED / OPENROUTER CREDENTIAL HANDOFF READY  
**Updated:** 26 August 2026 09:55 AEST  
**Primary Change Controls:** CF-CHG-20260825-036, CF-CHG-20260825-037, CF-CHG-20260825-038

## Programme baseline

- M1: CLOSED / PASS / FROZEN.
- M2.1: CLOSED / PASS.
- M2.2: CLOSED / PASS for accepted Pilot scope.
- M2.3: APPROVED / IN PROGRESS.
- M2.4: NOT STARTED / blocked by M2.3 acceptance.
- broad Publication and Production cutover remain unauthorised.

## Last fully accepted deployed runtime

Go 3 Pilot SHA `e94383bd4fd3b5718566bc4bb1c19f8cf687de36`:

- Frontend Build `32910110978` — PASS;
- browser smoke — PASS;
- Deployed UAT `32910110993` — PASS;
- desktop `98002494209` — PASS;
- mobile `98002494407` — PASS, 27/27.

## Go 4 acceptance target

Pilot SHA `87da570d8e6701928e45d532caf11877b6eab369`.

Visible release:

- PIM Admin `v2.15.5`;
- M2.3 Intelligence `v1.2`.

Frontend build and browser smoke are PASS. Final deployed desktop/mobile UAT is executing at this state write. Do not call Go 4 deployed-accepted until both jobs pass.

## Deployed M2.3 UI

The current feature set includes:

- Layer 3 governed model-profile and Evidence interpretation workspace;
- **Layer 3 Provider** Platform-Admin credential workspace;
- terminal Layer 4 queue, complete review package and all six governed actions;
- bounded Refresh policies/requests/Search-refresh signals;
- Important Links;
- source-precise Important Dates;
- reusable Country / Provider / Course Onboarding;
- Scholarship Selection with explicit fact/derived/missing distinctions;
- PIM release-note overlay maintained from the visible version control.

## Layer 3 Provider handoff

The Platform Admin may select `openrouter-free-router-v1` and enter the OpenRouter API key in **Layer 3 Provider** after Go 4 deployed UAT passes.

Credential architecture:

- browser password input; not stored in browser/localStorage;
- JWT-protected rank-6 Edge control;
- Supabase Vault storage;
- service-role-only SECURITY INVOKER public wrappers;
- non-exposed private elevated helpers;
- non-secret audit lineage only;
- bounded **Verify provider** call;
- saving/verifying always leaves the profile PAUSED.

Current profile state:

- enabled: true;
- paused: true;
- model: `openrouter/free`;
- validation: `pending_credentials_and_benchmark`;
- Vault credential configured: false.

**Current external gate:** BLOCKED — USER CREDENTIAL NOT YET CONFIGURED / QUALITY BENCHMARK NOT RUN.

## Layer 3 Edge runtime

`layer3-provider-control`: ACTIVE, JWT verified, v1, ID `4f380c4e-d5da-49dd-ad00-73a6486930a9`.

`layer3-interpret`: ACTIVE, JWT verified, v2, ID `33dd7564-990a-4b15-a884-35ac609c2258`; environment secret is checked first and the governed Vault credential second. Existing zero-call, eligibility, limit, deterministic-validation and Layer 4 escalation contracts remain.

## Current migration tail added by Go 4

- `20260825234756_m2_3_layer3_vault_credential_bridge`;
- `20260825234817_m2_3_layer3_provider_validation_audit`.

Exact deployed SQL is source-controlled in Pilot migrations.

## Security / performance

- Security Advisor: INFO-only, no WARN/ERROR after Go 4 DDL.
- Browser roles have no direct Vault grants.
- Credential service wrappers are not executable by anon/authenticated.
- Performance Advisor: INFO-only inherited findings; no Go 4 acceptance-level regression.

## Onboarding reconciliation

The earlier statement that Onboarding was absent was stale. Migration `20260825202903_m2_3_onboarding_lifecycle_foundation`, private case/audit structures, governed browser contracts and the Admin workspace are deployed. CF-CHG-037 remains open for representative lifecycle/negative-path acceptance rather than implementation.

## Exact next dependency order

1. Reconcile final Go 4 deployed desktop/mobile jobs for SHA `87da570d…` and record PASS or evidence-backed failure.
2. If PASS, user enters OpenRouter key in **Layer 3 Provider** → **Save credential** → **Verify provider**. Do not paste the credential into chat or governance.
3. Reconcile profile state. If connectivity verifies, it must be `credential_verified_pending_benchmark` and still PAUSED.
4. Run the bounded real-provider Layer 3 quality benchmark; retain model/profile/prompt/validator/token/cost/latency/result/Evidence/UAT lineage.
5. Only after explicit benchmark PASS decide whether Layer 3 profile resume is authorised.
6. Complete representative Onboarding lifecycle rollback/negative-path UAT.
7. Complete remaining CF-CHG-036 production-grade Layer 1/2, guides and final M2.3 PASS/BLOCKED/DEFERRED classification.
8. Do not start M2.4 until that classification is established.

## Handoff rule

Before ending each M2.3 execution chat, append the actual outcome to `RUNSHEET.md`, replace this current-state file with deployed truth, and rewrite `NEXT-CHAT.md` so continuation never depends on chat history.
