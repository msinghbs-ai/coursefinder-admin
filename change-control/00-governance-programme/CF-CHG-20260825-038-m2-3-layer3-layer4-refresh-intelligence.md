# CF-CHG-20260825-038 — M2.3 Layer 3/4 Launch, Refresh Intelligence & Important Dates

**Status:** CLOSED / PASS  
**Category:** 00-governance-programme  
**Initiated:** 25 August 2026 22:26 AEST (+10:00)  
**Closed:** 26 August 2026 12:23 AEST (+10:00)  
**Owner:** CourseFinder programme / Data Operations

## Decision and authority boundary

M2.3 operationalises governed Layer 3 AI Interpretation and terminal Layer 4 Human Resolution together with bounded Refresh, Important Links and Important Dates.

`Layer 1 authoritative/regulatory → Layer 2 deterministic acquisition/extraction → Layer 3 AI-assisted Evidence interpretation → Layer 4 human resolution`.

Layer 4 remains terminal. Search Projection, Search Visibility and Publication remain downstream. Layer 3 cannot directly mutate Layer 1 identity or canonical Course values.

## Accepted Layer 3 provider state

Profile code remains `openrouter-free-router-v1`, but the router-wide `openrouter/free` model selection is explicitly **not accepted** because its first quality benchmark failed through nondeterministic free-model routing.

Accepted configured model:

`nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`

Current governed state:

- aggregator: OpenRouter;
- enabled: true;
- paused: false;
- validation state: `benchmark_passed`;
- requests/minute: 20;
- requests/day: 50;
- max input/output: 12,000 / 1,200 tokens;
- retry ceiling: 1;
- timeout: 30 seconds;
- initial cost ceiling: USD 0.

## Credential architecture

The Platform-Admin-only **Layer 3 Provider** workspace writes the API key once through a JWT-protected rank-6 Edge control to Supabase Vault. The key is never returned to the browser or stored in browser/localStorage. Only non-secret configured/verified state and audit metadata are returned.

Public credential service wrappers remain SECURITY INVOKER and service-role-only. Private elevated helpers are not executable by anon/authenticated. Browser roles have no direct Vault table grants.

`layer3-interpret` resolves the existing environment secret first and the governed Vault credential second while retaining zero-call, rate/day/token/retry/timeout/cost and deterministic-validation controls.

## Real-provider benchmark evidence

Credential verification succeeded before quality acceptance. The initial router-wide configuration then failed the quality benchmark and remained unaccepted.

After pinning the model, benchmark run:

`a8e4b6c8-8a7b-45b4-a8df-c5a3bb4e8407`

passed:

- 5/5 provider semantic cases;
- 13/13 control cases;
- valid extraction;
- no-candidate handling;
- malformed/unsupported/hallucinated candidate rejection;
- unavailable-model rejection;
- unchanged-Evidence zero-call;
- changed/expired/revalidation eligibility;
- retry/RPM/day/timeout/cost controls;
- no silent fallback;
- observed cost USD 0;
- maximum observed provider latency 2.811 s;
- 315 input / 462 output tokens.

Only after this explicit PASS was the profile resumed. The one-time unauthenticated benchmark trigger was removed and the retained benchmark endpoint is JWT-protected and returns HTTP 410.

## Layer 4 acceptance

All six terminal actions passed rollback-only UAT:

1. Approve;
2. Edit and Approve;
3. Reject;
4. Request More Evidence;
5. Return to Layer 2;
6. Return to Layer 3.

Approve/Edit-and-Approve created Search refresh signals only after accepted canonical change. Reject created no Search signal. More Evidence/Return L2/Return L3 created only bounded refresh/revalidation work and did not imply canonical acceptance.

The browser exposes status/field filtering, before/proposed values, Evidence/L2/L3 lineage, configured/returned model context, validator/token/cost context, decision history, reason capture and edited final JSON value where applicable.

## Refresh / Important Links / Important Dates

Refresh remains source/profile/entity bounded and cannot independently perform uncontrolled ingestion/model calls/human approval/Search publication.

Important Dates preserve source precision. Permanent UAT verifies exact date-only values, source-vague handling, no manufactured timestamps and country-reference no-ingestion semantics.

Important Links remains an operational directory and does not become semantic authority.

## Accepted browser/runtime evidence

Final Pilot source:

`msinghbs-ai/Coursefinder-Pilot@260ed6a0d19b80ad666d74b90aa13e735e802a6a`

Visible release:

- PIM Admin `v2.15.5`;
- M2.3 Intelligence `v1.2`.

Evidence:

- Frontend Build `32917685085` — PASS;
- browser smoke — PASS;
- Deployed UAT `32917685022` — PASS;
- desktop `98024710961` — PASS;
- mobile `98024711090` — 29/29 PASS.

## Security / performance

Final Security Advisor: INFO-only; no WARN/ERROR.

Final Performance Advisor: INFO-only; remaining unindexed-FK/unused-index/Auth connection-strategy notices are backlog. The benchmark-job profile FK introduced during Go 5 was indexed before closure.

## Rollback / reversion

- If Layer 3 provider/model quality regresses, pause the profile immediately before further calls.
- Provider/model changes require governed revalidation/benchmark before resume.
- Browser regressions may be reverted at source SHA level and must pass permanent deployed UAT.
- Database contract corrections use forward migrations; historical deployed migration files are not rewritten.
- Layer 4 canonical authority and downstream Search gating cannot be bypassed by rollback.

## Acceptance

**CLOSED / PASS.** The credential gate, real-provider benchmark, Layer 3 execution boundary, terminal Layer 4 actions, Refresh, Important Links/Dates, security and deployed desktop/mobile regression have all met the accepted M2.3 Pilot/UAT gate.
