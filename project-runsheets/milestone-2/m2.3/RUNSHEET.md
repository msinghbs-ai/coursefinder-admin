# Milestone 2.3 Run Sheet

**Status:** ACTIVE  
**Milestone:** M2.3 — Production-Grade Data Operations, Complete Layers 1–4, Decision UX and Acceptance  
**Primary Change Controls:** CF-CHG-20260825-036, CF-CHG-20260825-037, CF-CHG-20260825-038

This file is the append-only execution history for M2.3. It records meaningful execution blocks and evidence; it is not a replacement for Change Control or detailed UAT artifacts.

## 2026-08-26 07:07 AEST — cross-chat continuity baseline

**Intent:** Remove dependence on long ChatGPT conversation history and establish a repository-backed continuation mechanism for M2.3.

**Starting state:**
- M1 is CLOSED / PASS / frozen.
- M2.1 is CLOSED / PASS.
- M2.2 is CLOSED / PASS for accepted Pilot scope.
- CF-CHG-20260825-036, -037 and -038 remain open for M2.3.
- Existing governance identifies the last fully reconciled M2.3 semantic Pilot runtime as `400e06d26cb7147a14971af578607816b0aca342` and exact deployed migration-source synchronisation as `3858a8f9bf4ccfb7bb5aec89fbc239420718e47e`, but newer commits/builds/deployed state must be reconciled before continuation.

**Actions:**
- Established `project-runsheets/` as the durable cross-chat execution ledger.
- Defined a three-file active-phase model: append-only run sheet, replaceable current state, compact continuation prompt.

**Outcome:** PASS — repository-backed continuation structure established.

## 2026-08-26 09:27 AEST — Go 3 final runtime reconciliation

**Intent:** Complete the inherited browser/security/runtime reconciliation and establish a clean permanent desktop/mobile acceptance baseline.

**Actions and findings:**
- Reconciled live Supabase browser bridge architecture and confirmed exposed browser contracts are SECURITY INVOKER while elevated helpers remain non-exposed/private.
- Security Advisor rerun: no WARN/ERROR; INFO-only RLS/no-policy baseline.
- Performance Advisor rerun: INFO-only inherited observations.
- Corrected mobile overlay interaction collision involving Scholarship Selection/M2.3 controls and Data Quality pagination.
- Corrected Layer 2 navigation startup race.
- Aligned permanent UAT with governed PIM Admin v2.15.4 release-notes state.
- Added bounded UAT recovery only for the observed Supabase `JWT issued at future` clock-skew condition; persistent auth/rank failures remain hard failures.
- Confirmed reusable Onboarding database/contracts/Admin workspace exist; prior governance saying implementation was absent was stale.

**Accepted runtime:** `msinghbs-ai/Coursefinder-Pilot@e94383bd4fd3b5718566bc4bb1c19f8cf687de36`.

**Evidence:**
- Frontend Build `32910110978` — PASS; build and browser smoke PASS.
- Deployed UAT `32910110993` — PASS.
- Desktop job `98002494209` — PASS; 26 direct passes plus one transient `evidence_detail` 500 that passed on the governed retry.
- Mobile job `98002494407` — 27/27 PASS.

**Outcome:** PASS for all technically available Go 3 runtime/regression gates. Layer 3 real-provider benchmark remained BLOCKED because no authorised credential was configured.

## 2026-08-26 09:55 AEST — Go 4 Layer 3 provider credential launch

**Intent:** Launch the user-requested M2.3 feature set with operational Layer 4 retained and add a safe Admin path to select OpenRouter and enter an API key for subsequent real-provider testing.

**Implemented:**
- PIM Admin visible release advanced to `v2.15.5`; M2.3 Intelligence runtime marker advanced to `v1.2`; release-note history retained.
- Existing M2.3 Intelligence workspace retains Layer 3, full six-action terminal Layer 4, Refresh, Important Links, Important Dates and Onboarding tabs.
- Added Platform-Admin-only `Layer 3 Provider` UI. It selects the governed profile, accepts the API key in a password field, requires a change reason and never returns/persists the key in browser storage.
- Added Supabase Vault credential bridge migrations `20260825234756_m2_3_layer3_vault_credential_bridge` and `20260825234817_m2_3_layer3_provider_validation_audit`; exact deployed SQL restored to Pilot migrations.
- Added JWT-protected `layer3-provider-control` Edge function; rank 6 required. Save writes encrypted Vault state and non-secret audit lineage. Verify performs one bounded provider call and records connectivity state only.
- Updated `layer3-interpret` to resolve the existing Edge environment secret first, then the governed Vault credential. Layer 3 continues to enforce reservation, rate/day/token/retry/timeout/cost and deterministic-validation boundaries.
- Credential save/verification always leaves the profile PAUSED. Only the separate real-provider quality benchmark may authorise resume.
- Added permanent desktop/mobile UAT for credential UI and updated release-notes/course-detail/M2.3 lifecycle assertions.

**Security evidence:**
- Browser roles have zero direct Vault table grants.
- Credential set/resolve/validation public service wrappers are SECURITY INVOKER and executable by service role only; anon/authenticated execute is false.
- Elevated credential helpers are private `security` functions and not executable by anon/authenticated.
- Post-DDL Security Advisor: INFO-only, no WARN/ERROR.
- Post-DDL Performance Advisor: INFO-only; no Go 4 acceptance-level regression.

**Current credential state:** `openrouter-free-router-v1` is enabled=true, paused=true, `pending_credentials_and_benchmark`; Vault credential configured=false. No key was created or inferred on the user's behalf.

**Go 4 acceptance target:** `msinghbs-ai/Coursefinder-Pilot@87da570d8e6701928e45d532caf11877b6eab369`.

**CI status at this append:** Frontend build PASS; browser smoke and final deployed desktop/mobile UAT still executing. Final acceptance must be reconciled into `CURRENT-STATE.md` / Change Control after those jobs resolve.
