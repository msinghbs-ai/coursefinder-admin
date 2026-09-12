# M2.4.5 NEXT CHAT

## Current pickup — 12 September 2026

- Milestone: **M2.4.5 ACTIVE / PRE-PRODUCTION HARDENING**.
- M2.5 remains PAUSED at P0; no Production Supabase exists.
- Accepted Pilot main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- Visible accepted release: v2.15.78.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Active change: `CF-CHG-20260910-093`.
- PR #72: OPEN / DRAFT / mergeable, head `a7283139a9e6088933be68fa69f75d2e9eb71fbe`.
- Exact-head Frontend Build `34681032426`: PASS.
- Exact-head Cloudflare preview: PASS/deployed.
- Codex exact-head review: unresolved. Fresh review request comment `5645005516` was posted at `2026-09-12 09:26:27Z`; no review submission or new quota response was present at reconciliation time. Earlier requests were blocked only by code-review usage quota.

## Accepted large-university Layer 2 result

**UQ PASS:** corrected scope 251 executable + 131 fresh terminal negatives. Corrected rerun batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f` = 248 `resolved_l2` + 3 `layer3_required`, no failures; same-token replay PASS; completion-anchored fresh-Preview dedupe PASS; no generic L3/Search/Publication side effects.

**RMIT PASS:** Preview `c3e73796-d2d3-486e-b3a4-83afc54b806d` = 500 scoped / 261 queueable / 239 discovery / zero qualification gaps. Bounded retry closed 15 transient/unattempted items. Final discovery = 2 selected + 237 terminal negatives. Batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f` = 213 `resolved_l2` + 50 `layer3_required`, zero outstanding/failure. 263 succeeded L2 jobs; zero Search refresh signals; canonical/Search authority false.

RMIT replay/dedupe live timing window elapsed before a second authenticated invocation. Do not run another 500-course batch solely to recreate it; UQ supplies live proof for the same corrected contract and targeted UAT covers completion dedupe.

## Layer 3 runtime truth

Owning CF-CHG-20260825-038 is CLOSED/PASS and accepted the Layer 3 execution boundary and pinned real-provider benchmark.

Runtime profile `openrouter-free-router-v1`:

- profile id `0b02920e-a021-48f5-ba47-75082fdcce13`;
- OpenRouter / `nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`;
- enabled=true / paused=false;
- Pilot environment `pilot_qualified` / enabled=true;
- benchmark `a8e4b6c8-8a7b-45b4-a8df-c5a3bb4e8407` PASS: 5/5 provider semantic + 13/13 controls, 5 calls, 315 input / 462 output tokens, USD 0 observed cost, max latency 2811ms;
- limits: 20 RPM, 50/day, retry ceiling 1, timeout 30s, cost ceiling USD 0;
- allowed Course classes: course_description, official_course_url, delivery_mode, duration.

Eligible current large-university set: **53 `layer3_required` items = 3 UQ + 50 RMIT**. Runtime lineage audit confirms all 53 have eligible retained `text/html` Evidence through succeeded `layer2_provider_attempts`; existing interpretations for this cohort: 0.

`layer3-interpret` v9 is ACTIVE, `verify_jwt=true`, and validates the caller with `auth.getUser()` before reservation. Normal Admin/PIM UI already invokes this exact path using the signed-in Supabase session. The deployed UAT harness also signs in through normal Supabase Auth with repository-held UAT credentials, but its current Layer 3 test intentionally stops before an external model call.

Repository/database connector access does not expose a legitimate user JWT or the GitHub Actions UAT secret values. Do not mint/extract credentials, use service-role SQL, or direct-call privileged functions merely to obtain a live-provider PASS.

Runtime `uat_ref=pending-live-provider-uat` is stale descriptive metadata relative to CF-038 CLOSED/PASS. Current executable gate is `pilot_qualified` + enabled + unpaused. Reconcile the stale text only through governed forward change when appropriate; it is not an operational reason to weaken or bypass the accepted contract.

## Exact next actions

1. Through a normal logged-in Admin/PIM session, open **Layer 3 / 4 Operations → Layer 3 → Governed Layer 2 Evidence queue**.
2. Select one eligible UQ/RMIT Evidence item and the appropriate supported task, retain the existing qualified profile, and run **Run eligible interpretation**. Start with one call only; do not bulk-run the 53 items merely for acceptance.
3. Inspect the resulting interpretation and capture status, validator result, returned model, external call count, input/output tokens, cost, latency, selected Evidence and any Layer 4 review item.
4. Verify zero unauthorized Layer 1 mutation, automatic Layer 4 approval and Search/Publication side effects. Only expand to a very small second/third representative sample if the first call is clean and there is a specific coverage reason.
5. Record observed metrics in `SYSTEM-METRICS.md`; do not infer unavailable values.
6. Obtain exact-head Codex review; quota exhaustion or silence is not approval.
7. Re-run exact-head CI/UAT/runtime if any code/runtime metadata changes.
8. Merge PR #72 only after required gates are clean. Accepted main/release remain unchanged until then.
9. After CF-093 closes: Monash → Melbourne → ANU → UTS → UWA → Sydney → UNSW through normal qualification only.

## Pickup text

> Continue CF M2.4.5 / CF-CHG-20260910-093 from repository/runtime truth. Accepted Pilot main is `63c7107cfce2d8f607fc378af4881d0ba28ca879`, visible release v2.15.78. PR #72 is draft/open/mergeable at `a7283139a9e6088933be68fa69f75d2e9eb71fbe`; Frontend Build `34681032426` and Cloudflare preview PASS. A fresh exact-head Codex request was posted as PR comment `5645005516`, but no actual review result is present yet. UQ and RMIT large-University Layer 2 acceptance are PASS. There are 53 eligible `layer3_required` items (3 UQ + 50 RMIT), all with retained text/html Evidence through the exact candidate-selection lineage, and zero existing interpretations. Existing Course Layer 3 profile is Pilot-qualified and benchmark-PASS under CF-038. Next use a normal authenticated Admin/PIM session for a one-call bounded live-provider interpretation, record metrics and safety effects, then obtain exact-head Codex before merge. Do not bypass JWT/user identity, expose UAT secrets, enable generic scheduler L3, recreate expired RMIT replay timing, or manufacture policy/profile/configuration.
