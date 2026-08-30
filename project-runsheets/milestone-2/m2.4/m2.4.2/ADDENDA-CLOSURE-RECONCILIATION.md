# M2.4.2 — Addenda Closure Reconciliation

**Status:** AUTHORITATIVE CLOSURE MAP  
**Effective:** 30 August 2026  
**Milestone status:** M2.4.2 CLOSED / PASS under CF-CHG-20260827-044.

## Interpretation rule

M2.4.2 being CLOSED / PASS does **not** mean every execution addendum is retired or every operational follow-up is complete.

Three states must be distinguished:

1. **Accepted and closed for M2.4.2 scope** — the required behaviour was implemented/validated sufficiently for the M2.4.2 acceptance gate.
2. **Standing governance** — the addendum continues to govern later milestones and must not be marked obsolete merely because M2.4.2 closed.
3. **Carry-forward follow-up** — a deliberately deferred/blocking item remains open outside the accepted M2.4.2 scope and is tracked in FOLLOW-UPS / later milestones.

## Addenda reconciliation

| Addendum | M2.4.2 disposition | Continuing requirement |
|---|---|---|
| A1–A6 | ACCEPTED / STANDING | Targeted→integration→acceptance discipline, primary navigation, shared adapters, CI control, UX/performance evidence, naming remain mandatory. |
| A7 | ACCEPTED / STANDING | UAT efficiency review and avoidance of overlapping full matrices remain mandatory. |
| A8 | ACCEPTED / STANDING | Top-right Release Notes overlay remains the single operator release/version surface; obsolete footer stays removed. |
| A9 | ACCEPTED FOR M2.4.2 / STANDING L2 MODEL | Country/State/University scope-first sync, ordered Direct HTTP→Firecrawl→governed fallback routing, and routine-screen cleanup are accepted. |
| A10 | ACCEPTED / STANDING PLATFORM RULE | Large filters/selectors remain server-paged to 10; tablet/coarse-pointer no-autofocus and dependent-scope clearing remain mandatory. |
| A11 | STRATEGY ACCEPTED / ROLLOUT CONTINUES | Evidence-driven AU/NZ scale-out strategy is accepted; national catalogue completion was explicitly not an M2.4.2 exit requirement. |
| A12 | ACCEPTED / STANDING PRESENTATION RULE | QILT/PRISMS/country-equivalent statistics and Scholarships remain contextualised on Provider/Course blades at true source grain. |
| A13 | ACCEPTED / STANDING UX/EVIDENCE RULE | Anchored filters, visible acquisition route and linked Evidence/screenshot proof remain accepted behaviour. |
| A14 | ACCEPTED / STANDING TELEMETRY RULE | Layer 2 scraper/provider and Layer 3 model call/token/cost/latency telemetry remains mandatory for every new execution path. |
| A15 | CLOSED / PASS AS SEPARATE ACCEPTED SLICE | Provider international contact intelligence closed under CF-CHG-20260829-046; its authority/privacy/quality rules remain protected. |

A9 and A11 are embedded in the M2.4.2 RUNSHEET rather than separate top-level addendum files. Their absence as standalone files does not mean they were lost.

## M2.4.2 acceptance evidence

- CF-CHG-20260827-044: CLOSED / PASS.
- Corrective Stage C accepted Pilot: `093010fada8391c93626b59e59c678064f4961c3`.
- Corrective acceptance run `33219089690`: 45/45 desktop PASS and 45/45 mobile PASS.
- Historical failed Stage C `33215640328` remains immutable evidence.
- A15 final accepted Pilot: `f6741a0cc29c5fea236e85b9042f8079762c6993`.
- A15 final acceptance `33251745111`: 48/48 desktop PASS and 48/48 mobile PASS.

## Deliberate carry-forwards not blocking M2.4.2 closure

The following were not silently closed:

- NZ first-party Layer 2 Course enrichment: DEFERRED pending source-pattern qualification/onboarding.
- RMIT 212-record canonical promotion: BLOCKED pending an already-authorised exact frozen-set executor; RMIT refresh remains disabled.
- Federation source-limited residual: retained as explicit limitation; no weakened identity rule.
- Remaining provider source-seed/data-quality issues: cross-layer Layer 1/Layer 4 follow-up.
- A10 platform-wide migration of any future >10-option selector: standing rule.
- A11 AU/NZ multi-university rollout: operational continuation, not an M2.4.2 acceptance prerequisite.
- A14 telemetry: standing rule.
- Apollo enrichment credential/configuration: non-blocking.
- Zoho pilot/cutover: separate governed consumer workstream.

The Layer 3 source-pattern model-quality blocker that was carried from M2.4.2 has since been resolved in M2.4.3 without lowering its threshold.

## Current successor state

M2.4.3 remains ACTIVE under CF-CHG-20260829-047.

Latest corrective state after failed first final-acceptance attempt:
- first M2.4.3 final acceptance `33284867253`: desktop PASS, mobile FAIL due inherited dashboard statement timeout during Layer 2 provider-acquisition UAT;
- corrective migration `20260830011809_m2_4_3_acceptance_dashboard_timeout_hardening`;
- corrective Pilot source `eaab5a7b6fc7bfaddb2b6863e23f5033184fa4b7`;
- targeted deployed UAT `33285369673`: PASS;
- frontend build/local smoke `33285369676`: PASS.

Next required sequence:
`bounded integration desktop/mobile → replacement final acceptance → M2.4.3 closure`.

M2.4.4 must not begin until M2.4.3 formally closes.
