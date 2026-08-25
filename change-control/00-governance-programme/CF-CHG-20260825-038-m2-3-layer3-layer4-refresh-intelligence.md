# CF-CHG-20260825-038 — M2.3 Layer 3/4 Launch, Refresh Intelligence & Important Dates

**Status:** APPROVED / IN PROGRESS — UI/RUNTIME LAUNCHED; REAL-PROVIDER BENCHMARK PENDING USER CREDENTIAL  
**Category:** 00-governance-programme  
**Initiated:** 25 August 2026 22:26 AEST (+10:00)  
**Last reconciled:** 26 August 2026 09:55 AEST (+10:00)  
**Owner:** CourseFinder programme / Data Operations

## Decision and authority boundary

M2.3 operationalises governed Layer 3 AI Interpretation and terminal Layer 4 Human Resolution together with bounded refresh intelligence, Important Links and Important Dates.

`Layer 1 authoritative/regulatory → Layer 2 deterministic acquisition/extraction → Layer 3 AI-assisted Evidence interpretation → Layer 4 human resolution`.

Layer 4 is terminal. Search Projection, Search Visibility and Publication remain downstream states. Layer 3 cannot mutate Layer 1 identity or canonical Course values directly.

## Layer 3 provider operating contract

The deployed `openrouter-free-router-v1` profile remains:

- aggregator `openrouter`;
- endpoint `https://openrouter.ai/api/v1`;
- configured model `openrouter/free`;
- enabled `true`;
- paused `true`;
- current validation state `pending_credentials_and_benchmark`;
- requests/minute 20;
- requests/day 50;
- max input/output 12,000 / 1,200 tokens;
- retry ceiling 1;
- timeout 30 seconds;
- initial cost ceiling USD 0.

### Governed credential path — implemented

Go 4 removes the previous tooling limitation that prevented an authorised credential from being configured/verifiably managed through CourseFinder Admin.

Applied migrations:

- `20260825234756_m2_3_layer3_vault_credential_bridge`;
- `20260825234817_m2_3_layer3_provider_validation_audit`.

The browser now exposes a Platform-Admin-only **Layer 3 Provider** workspace. The operator can select the governed OpenRouter profile, enter an API key in a password input and provide a mandatory reason. The key is submitted once to the JWT-protected Edge control and is not returned to the browser or persisted in browser storage.

Server-side handling:

- credential is stored/replaced in Supabase Vault;
- only non-secret configured/updated state is returned to Admin;
- credential writes and verification are immutably audit-recorded without storing the secret in the audit table;
- public service wrappers are SECURITY INVOKER and service-role-only;
- private SECURITY DEFINER helpers are non-executable by anon/authenticated;
- browser roles have no direct Vault table grants;
- setting or verifying a credential always leaves the profile PAUSED.

Current Vault credential state at reconciliation: **not configured**. No credential has been fabricated or inferred.

### Edge runtime

`layer3-provider-control`:

- ID `4f380c4e-d5da-49dd-ad00-73a6486930a9`;
- version 1;
- ACTIVE;
- `verify_jwt=true`;
- deployed SHA-256 `4dbbcbb36fc6a0936c83f2d386cdb46a1892b3571d539292bc8fcdd18c61d2d5`.

It requires effective Platform Admin rank 6. `set_credential` stores the Vault secret; `verify_credential` makes one bounded connectivity call using the configured profile and records the returned provider model/result. Verification is not the quality benchmark.

`layer3-interpret`:

- ID `33dd7564-990a-4b15-a884-35ac609c2258`;
- version 2;
- ACTIVE;
- `verify_jwt=true`;
- deployed SHA-256 `c0fad5ef9e9fd282eab3735cc180c80456b1ef4b709e2b7d6d1d97523c7d22bf`.

It preserves the original environment-secret path first and then resolves the governed Vault credential. Existing eligibility, unchanged-Evidence zero-call, RPM/day/token/retry/timeout/cost ceilings, deterministic validation and Layer 4-only escalation remain intact.

## Layer 4 — deployed operational workspace

`security.layer4_course_scalar_resolve_impl` remains the only canonical Course scalar authority. The browser/runtime exposes all six terminal actions:

1. Approve;
2. Edit and Approve;
3. Reject;
4. Request More Evidence;
5. Return to Layer 2;
6. Return to Layer 3.

The current M2.3 Intelligence Layer 4 tab includes status/field filtering, before/proposed values, Evidence/L2/L3 references, mandatory decision reason, edited final JSON value where applicable and the governed `layer4_review_context` package including Evidence source, configured/returned L3 model, validator/token/cost context and decision history. Search-refresh signalling remains downstream of successful canonical approve/edit-and-approve only.

## Refresh / Important Links / Important Dates

Refresh remains source/profile/entity bounded. The scheduler continues to select bounded work only and does not itself perform uncontrolled ingestion/model calls/human approval/Search publication.

Important Dates Admin uses the source-precision contract and deployed UAT verifies date-only values `2026-11-30` and `2027-02-22`, source-vague handling, no manufactured timestamps and country-reference no-ingestion semantics.

## Onboarding integration

The M2.3 Intelligence workspace includes the reusable Country / Provider / Course Onboarding lifecycle implemented under CF-CHG-20260825-037. Layer 3 Ready means eligibility/configuration readiness only and never bypasses the provider benchmark.

## Security / performance reconciliation

Post-Go-4 Security Advisor: **INFO-only**. No WARN/ERROR. The new private credential audit table has RLS enabled with no browser policy by design. Advisor reference for that baseline class: https://supabase.com/docs/guides/database/database-linter?lint=0008_rls_enabled_no_policy

Post-Go-4 Performance Advisor: **INFO-only**. Existing unindexed-FK/unused-index/Auth connection-strategy observations remain programme backlog; the new credential bridge adds no acceptance-level performance finding. References: https://supabase.com/docs/guides/database/database-linter?lint=0001_unindexed_foreign_keys and https://supabase.com/docs/guides/database/database-linter?lint=0005_unused_index

## Browser release / acceptance target

Visible release:

- PIM Admin `v2.15.5`;
- M2.3 Intelligence `v1.2`.

Go 3 fully accepted runtime remains `e94383bd4fd3b5718566bc4bb1c19f8cf687de36`, build `32910110978` PASS, deployed UAT `32910110993` PASS, desktop `98002494209` PASS and mobile `98002494407` PASS.

Go 4 acceptance target is `87da570d8e6701928e45d532caf11877b6eab369`. Frontend build is PASS; browser smoke and final deployed desktop/mobile UAT were executing at this reconciliation write and must be updated to final outcome before this SHA is called deployed-accepted.

## Real-provider benchmark gate

Once the authorised Platform Admin enters the OpenRouter API key in **Layer 3 Provider** and selects **Verify provider**:

1. confirm profile state becomes `credential_verified_pending_benchmark` if connectivity succeeds;
2. keep the profile PAUSED;
3. execute the bounded benchmark covering valid extraction, no-candidate, malformed output, unsupported/hallucinated candidate rejection, unavailable provider/model, timeout/retry/RPM/day/cost ceilings, unchanged-Evidence zero-call, changed/expired/revalidation eligibility and fallback behaviour;
4. persist configured and returned model, profile, prompt/validator versions, token/cost/latency/result/quality/Evidence/UAT/Change Control lineage;
5. only then decide whether resume is authorised.

**Current provider gate: BLOCKED — USER CREDENTIAL NOT YET CONFIGURED / QUALITY BENCHMARK NOT RUN.**

## Acceptance

This Change Control is not closed solely by launching the UI. The noncredential Layer 3/Layer 4/refresh/Admin foundations are implemented and under permanent deployed regression. Real-provider execution remains blocked until the user supplies the authorised credential and the quality benchmark passes. M2.4 does not begin before the complete M2.3 acceptance boundary is established.
