# CourseFinder Running Build v2.72

**Status:** M1 FROZEN / M2.1 CLOSED-PASS / M2.2 CLOSED-PASS / **M2.3 ACTIVE — GO 4 PROVIDER UI LAUNCHED**  
**Date:** 26 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.71.md`  
**Change Controls:** `CF-CHG-20260825-036`, `CF-CHG-20260825-037`, `CF-CHG-20260825-038`

## Programme authority

Master Project Plan `v1.71` and M2→Production Delivery Plan / TSOW `v1.4` remain current. M2.3 is the operational Layers 1–4 / Data Operations / Onboarding acceptance gate. M2.4 remains blocked until the complete M2.3 PASS/BLOCKED/DEFERRED boundary is established.

## Last fully accepted runtime

Go 3 accepted Pilot source:

`e94383bd4fd3b5718566bc4bb1c19f8cf687de36`

Evidence:

- Frontend Build `32910110978` — PASS;
- browser smoke — PASS;
- Deployed UAT `32910110993` — PASS;
- desktop `98002494209` — PASS;
- mobile `98002494407` — PASS, 27/27.

## Go 4 target runtime

Pilot source:

`87da570d8e6701928e45d532caf11877b6eab369`

Visible browser release:

- PIM Admin `v2.15.5`;
- M2.3 Intelligence `v1.2`.

Go 4 adds the governed Layer 3 provider credential control while retaining the operational Layer 4, Refresh, Important Links, Important Dates, Onboarding and Scholarship Selection workspaces.

At this document write, Frontend Build is PASS. Browser smoke and permanent deployed desktop/mobile UAT are executing; this SHA is not called deployed-accepted until both deployed jobs pass.

## Layer 3 credential architecture

Applied migrations:

- `20260825234756_m2_3_layer3_vault_credential_bridge`;
- `20260825234817_m2_3_layer3_provider_validation_audit`.

The Platform Admin can select `openrouter-free-router-v1` in the **Layer 3 Provider** dialog and enter the OpenRouter API key. The browser submits it once; it is stored in Supabase Vault and is not returned or persisted in browser storage. Credential save and verification are audited without storing the secret in the audit table.

Public credential service wrappers are SECURITY INVOKER and service-role-only. Private SECURITY DEFINER helpers are not executable by anon/authenticated. Browser roles have no direct Vault table grants.

## Layer 3 Edge runtime

`layer3-provider-control`:

- ID `4f380c4e-d5da-49dd-ad00-73a6486930a9`;
- version 1;
- ACTIVE;
- `verify_jwt=true`;
- SHA-256 `4dbbcbb36fc6a0936c83f2d386cdb46a1892b3571d539292bc8fcdd18c61d2d5`.

`layer3-interpret`:

- ID `33dd7564-990a-4b15-a884-35ac609c2258`;
- version 2;
- ACTIVE;
- `verify_jwt=true`;
- SHA-256 `c0fad5ef9e9fd282eab3735cc180c80456b1ef4b709e2b7d6d1d97523c7d22bf`.

The interpretation runtime checks the prior Edge environment secret first and the governed Vault secret second, preserving compatibility. All eligibility, zero-call, limit and deterministic-validation controls remain.

## Current OpenRouter state

Profile `openrouter-free-router-v1`:

- aggregator `openrouter`;
- model `openrouter/free`;
- enabled `true`;
- paused `true`;
- validation `pending_credentials_and_benchmark`;
- Vault credential configured `false` at the 09:55 AEST reconciliation.

No credential has been created or inferred. The profile must remain PAUSED after user credential entry/verification until the real-provider quality benchmark passes.

## Layer 4

The M2.3 Intelligence workspace exposes the terminal Layer 4 queue, filters, complete review package, before/proposed values and all six governed actions: Approve, Edit and Approve, Reject, Request More Evidence, Return to Layer 2 and Return to Layer 3. Search refresh remains downstream of successful accepted canonical changes only.

## Onboarding

The prior v2.71 statement that no reusable Onboarding implementation existed is superseded. Migration `20260825202903_m2_3_onboarding_lifecycle_foundation` and the deployed Admin workspace implement the shared nine-stage lifecycle. CF-CHG-037 remains open only for representative lifecycle/negative-path acceptance, not implementation.

## Important Dates / refresh / decision intelligence

The deployed UI retains source-precise Important Dates, bounded refresh targeting, Important Links and transparent Scholarship Selection semantics. Missing data is not converted to zero or inferred eligibility.

## Advisor state

- Security Advisor: INFO-only; no WARN/ERROR after Go 4 credential DDL.
- Performance Advisor: INFO-only; inherited unindexed-FK/unused-index/Auth connection-strategy observations remain backlog.

## Current gate state

- M1 — CLOSED / PASS / FROZEN;
- M2.1 — CLOSED / PASS;
- M2.2 — CLOSED / PASS;
- M2.3 — ACTIVE / IN PROGRESS;
- CF-CHG-036 — IN PROGRESS / core Pilot UX-runtime implemented;
- CF-CHG-037 — IN PROGRESS / implemented; representative lifecycle acceptance remains;
- CF-CHG-038 — IN PROGRESS / UI-runtime launched; real-provider benchmark blocked until user enters authorised OpenRouter credential;
- M2.4 — NOT STARTED / BLOCKED BY M2.3;
- broad Publication — NOT AUTHORISED;
- Production cutover — NOT AUTHORISED.

## Exact next gate

After Go 4 deployed desktop/mobile PASS, the Platform Admin may enter the OpenRouter API key in **Layer 3 Provider**, select **Save credential**, then **Verify provider**. Keep the profile PAUSED. The following execution must immediately reconcile the verification state and run the bounded real-provider benchmark before any Layer 3 resume decision.

In parallel, complete the remaining representative Onboarding lifecycle and final M2.3 PASS/BLOCKED/DEFERRED classification.

## Commercial/time boundary

Technical execution does not create billable-time entries. The maintained engagement-time record remains authoritative.
