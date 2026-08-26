# M2.4.0 — Integration Cleanup, Test-Liability Removal & Acceptance Rebase

**Status:** CLOSED / PASS  
**Parent:** M2.4  
**Closed:** 26 August 2026 20:43 AEST (+10:00)  
**Governance:** inherit `PROJECT_INSTRUCTIONS.md`, `STANDING-INSTRUCTIONS.md` and A1–A6.

## Objective

Clear the Go 7 navigation/test integration liability before further feature work. Produce one stable, primary-navigation-based test architecture and one accepted Pilot checkpoint so M2.4.1 can mature Layer 1 without inheriting stale launchers, duplicate navigation or expensive CI feedback loops.

## Accepted checkpoint

**Accepted Pilot SHA:** `ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`  
**Browser release:** PIM Admin `v2.15.6`  
**Frontend Build:** `32958795576` — PASS  
**Full deployed acceptance:** `32958795547` — PASS  
**Desktop acceptance job:** `98146317262` — PASS  
**Mobile acceptance job:** `98146317373` — PASS

The acceptance SHA contains the final acceptance marker only. The browser/runtime implementation carried into it includes the accepted M2.4.0 navigation/test cleanup and the Course page first-render contention fix from working SHA `ecc81dfbf5e6e985eb84b4974c50b0657aac10a0`.

## Starting facts reconciled

- M2.3 accepted baseline was `260ed6a0d19b80ad666d74b90aa13e735e802a6a`.
- Go 7 introduced PIM Admin v2.15.6 and the streamlined menu.
- Initial Go 7 full deployed UAT failed because inherited suites still searched for removed `Layer 2 Operations` and floating `M2.3 Intelligence` launchers.
- Post-Go7 Pilot commits were explicitly treated as unaccepted working state until this rebase completed.
- A1–A6 were adopted to prevent full-matrix-as-development-loop behaviour and distributed navigation coupling from recurring.

## Gate A — inventory/static cleanup — PASS

Completed:

- removed the `Layer 2 Operations` compatibility alias from permanent navigation support;
- introduced `tests/uat/support/navigation.mjs` shared primary-navigation adapters;
- migrated affected permanent Layer 2, M2.3, provider-governance, Scholarship and navigation suites to shared adapters;
- removed permanent UAT dependence on `.m23-launcher`, `.l3cred-launcher` and other hidden/floating launcher selectors;
- reduced deterministic primary-navigation/UI waits to fail-fast bounds while retaining longer limits for genuinely asynchronous work;
- made primary navigation mobile-safe;
- separated the M2.4 navigation/content audit from permanent functional acceptance into the lightweight audit workflow;
- implemented targeted → integration → acceptance tiers in deployed UAT CI;
- retained hidden implementation bridges only where replacing them inside M2.4.0 would have created unnecessary workspace-rewrite risk. They are not accepted operator navigation and permanent UAT does not depend on them.

Layer 1's accepted operator journey is primary `Data Operations → Layer 1 — Regulatory`; generic Settings is not the normal operator path and Platform Settings/destructive authority remains separately rank-gated.

## Gate B — targeted desktop/mobile — PASS

Final targeted working SHA before integration promotion: `ecc81dfbf5e6e985eb84b4974c50b0657aac10a0`.

Targeted workflow run `32954022764`:

- desktop `98131600073` — PASS;
- mobile `98131600295` — PASS.

Coverage included streamlined primary navigation, Layer 1, Layer 2 platform/provider/trials, Layer 3/4/Onboarding, Layer 3 provider credential boundary, Scholarship Selection, Guides and release notes.

## Gate C — bounded integration — PASS

Integration marker SHA: `70244120258cf47d25575bc8af4dbb71fee0daf3`.  
Integration workflow run: `32958008107`.

- desktop `98143894774` — 29-test integration matrix PASS;
- mobile `98143894861` — integration matrix PASS.

The bounded matrix included Data Quality, screen-state persistence, performance, affected Layer 1–4 navigation/security and immediate upstream/downstream regression.

### Performance blocker resolved without weakening the gate

The first integration attempt exposed a real inherited desktop `courses_page` miss against the unchanged 3,000 ms budget: 3,035 ms then 4,669 ms on retry. Mobile passed the same contract.

Investigation showed the Course page RPC itself was not intrinsically a multi-second SQL path; first navigation was contending with the large Course filter-catalogue request. The mature shell was changed to prioritise the first Course page response and load filter metadata immediately afterwards, preserving the same governed data and security semantics.

Retained desktop integration evidence after the fix:

- `courses_page`: **1,985 ms** — PASS against 3,000 ms budget;
- `courses_page` payload: **80,557 bytes**;
- `course_filters`: HTTP 200, **257,659 bytes** against the existing 350,000-byte payload budget;
- no RPC/payload threshold was widened;
- no role, RLS, grant, Evidence, canonical or Search semantics were changed.

## Gate D — one full acceptance matrix — PASS

One acceptance candidate was nominated after Gates B and C passed:

`ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`

Exactly one complete permanent deployed matrix was then run on that SHA:

- build `32958795576` — PASS;
- deployed UAT `32958795547` — PASS;
- desktop `98146317262` — PASS;
- mobile `98146317373` — PASS.

The acceptance tier included Data Quality, performance, Layer 2 platform/provider/trials, primary navigation, Course Detail polish, screen-state persistence, Layer 3/4 intelligence, Layer 3 credential governance, Scholarship Selection and release notes.

## Supabase/runtime reconciliation

- Pilot Supabase project `coursefinder_Pilot` / `fxcwkweaxjtknorudmwp` remained `ACTIVE_HEALTHY` during cleanup.
- M2.4.0 introduced no database DDL.
- Security/RLS/role/rank/Edge/Vault/Evidence boundaries were not weakened to obtain PASS.
- Existing advisor technical debt remains carry-forward rather than being hidden inside a navigation/test cleanup gate.

## Exit-gate result

PASS:

- permanent UAT no longer depends on floating operational launchers or obsolete menu names;
- shared navigation adapters are in place;
- deterministic UI failures use bounded/fail-fast navigation handling;
- targeted desktop/mobile validation PASSed;
- bounded integration PASSed;
- the unchanged Course performance budget PASSed with retained evidence;
- one nominated SHA PASSed one full desktop/mobile deployed permanent matrix;
- CF-CHG-20260826-040 is closed against the accepted runtime;
- CF-CHG-20260826-042 staged-testing governance is validated by execution;
- Running Build/Register/Master Plan are advanced only after proof;
- M2.4.1 is now the next feature gate.

## Rollback / reversion

If a regression attributable to M2.4.0 is discovered, revert the M2.4.0 browser/navigation/test changes to the last accepted M2.3 runtime `260ed6a0d19b80ad666d74b90aa13e735e802a6a` or to the relevant pre-change source commit. No M2.4.0 database rollback is required because this cleanup introduced no DDL.

## Next gate

Proceed to **M2.4.1 — Layer 1 Regulatory Operations Maturity & Automation** under the existing sub-milestone plan, Standing Instructions and A1–A6. M2.4.1 must inherit the accepted primary navigation, CI staging discipline, security boundaries and durable follow-up register rather than reopening M2.4.0 architecture.
