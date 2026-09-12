# M2.4.5 CURRENT STATE

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 LARGE-UNIVERSITY L2 ACCEPTANCE PASS; L3/CODEX GATES OPEN  
**Reconciled:** 2026-09-12 AEST  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Visible accepted release:** v2.15.78  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 remains PAUSED at P0

## Active implementation candidate

- Pilot PR #72: `CF-093: complete Preview-bound async Layer 2 discovery`.
- Branch: `m245/cf093-async-discovery-20260912`.
- Exact head: `a7283139a9e6088933be68fa69f75d2e9eb71fbe`.
- Base main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- PR state: OPEN / DRAFT / mergeable.
- Exact-head Pilot Frontend Build `34681032426`: PASS.
- Cloudflare exact-head commit/branch preview: PASS/deployed.
- Exact-head Codex review: BLOCKED by Codex review-usage limit; no technical review finding is present. No merge until an exact-head review can be obtained or the governance gate is explicitly changed.

## Repository/runtime reconciliation

PR #72 now uses the immutable Pilot-applied migration identities for the CF-093 async-discovery and completion-dedupe capability. Applied history has not been rewritten or retimestamped. The latest targeted UAT correction at `a7283139...` aligns `cf-093-terminal-negative-freshness-dedupe.spec.mjs` with applied migration `20260912031356_cf_093_scheduler_terminal_negative_freshness_dedupe.sql`.

The preceding head `eec6fbbf...` failed Frontend Build `34677940824` at UAT discovery because that test still referenced nonexistent alias `20260912032000...`; the exact-head correction is green. The same failed run also exposed older unrelated release/navigation assertion debt; those historical tests were not rewritten as part of CF-093.

## UQ 382-course consequential acceptance — PASS

The corrected Preview-bound contract completed UQ discovery with:

- 382 scoped Courses;
- 251 executable Layer 2 targets;
- 131 fresh governed terminal negatives;
- no unnecessary rediscovery after the terminal-negative correction;
- no unresolved/transient discovery outcomes.

Final corrected discovery history established 245 CRICOS-verified selected current URLs and 131 governed terminal negatives across the original discovery set. Deterministic Layer 2 reproduced the same stable terminal result on the corrected rerun:

- batch `5b2bac73-0cd4-4a7f-9487-2baf3ab1443f`;
- 248 `resolved_l2`;
- 3 `layer3_required`;
- 0 failed/outstanding items;
- same-token replay PASS with `idempotent_replay=true`;
- fresh-Preview dedupe PASS after completion-anchored dedupe correction.

An accidental pre-correction duplicate UQ batch was governed-cancelled with zero processed items and produced no new Evidence/canonical consequence.

Authority checks were clean: no generic Layer 3 execution, Search refresh, Layer 4 publication decision, publication event or publication approval was created by the scheduler/L2 path.

## RMIT 500-course consequential acceptance — PASS

Fresh Preview token `c3e73796-d2d3-486e-b3a4-83afc54b806d` proved:

- 500 scoped Courses;
- 261 initially queueable;
- 239 Preview-bound discovery;
- zero profile/policy/route/oversize/discovery-config gaps;
- scope fingerprint `14ff4e15dd39bc46f785f4e03ca3b3dc`.

The first discovery chain failed closed at request `5965` with 15 unresolved/transient Courses. A governed bounded retry of exactly those 15 under the same active binding completed without threshold/profile relaxation.

Final RMIT discovery:

| Outcome | Courses |
|---|---:|
| CRICOS-verified selected current URL | 2 |
| Governed terminal negative | 237 |
| **Total** | **239** |

Handoff started deterministic batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f` for 263 targets = 261 prior queueable + 2 newly selected. Terminal batch result at `2026-09-12 06:11:31.218367Z`:

| L2 item status | Count |
|---|---:|
| `resolved_l2` | 213 |
| `layer3_required` | 50 |
| **Total** | **263** |

Batch status is `partial` only because 50 items require the separately governed Layer 3 path. There were 263 succeeded `layer2_acquisition_v2` jobs and no generic Layer 3 jobs. Search refresh signals during the batch window: 0. Runtime handoff explicitly recorded `canonical_mutation_authorised=false` and `search_publication_authorised=false`.

RMIT same-token/fresh-Preview timing proof was not executed before its completion-anchored 30-minute dedupe window elapsed. Do not launch a duplicate 500-course run solely to recreate that expired timing window. The dedupe implementation is covered by the corrected UQ live proof and targeted CF-093 migration/UAT contract.

## Layer 3 state

- Generic scheduler Layer 3 remains prohibited.
- Existing Course Evidence interpretation profile `openrouter-free-router-v1` remains governed by Evidence/profile/model/revalidation and benchmark reference `a8e4b6c8-8a7b-45b4-a8df-c5a3bb4e8407`.
- Current large-university L2 acceptance produced 3 UQ + 50 RMIT `layer3_required` dispositions. These are eligibility signals only; they do not authorise automatic AI execution.
- The next runtime gate is to inspect current qualified Layer 3 provider/profile/revalidation/live-provider state, then run only a bounded acceptance against eligible Evidence if all prerequisites remain qualified.

## Next AU qualification wave

After the Layer 3 and merge gates are clean, normal qualification order remains:

1. Monash University
2. The University of Melbourne
3. Australian National University
4. University of Technology Sydney
5. The University of Western Australia
6. The University of Sydney
7. UNSW Sydney

No cohort membership authorises fabricated execution policy, profile, route or discovery configuration.

## Exact next gate

1. Reconcile PR #72 description and remaining CF-093 governance/metrics to current runtime truth.
2. Inspect existing Course Layer 3 profile/provider/model/revalidation/live-provider qualification and the 53 eligible UQ/RMIT L2 dispositions.
3. Run only a bounded Layer 3 acceptance if the existing contract is currently qualified; do not enable generic scheduler L3.
4. Obtain exact-head Codex review when usage capacity permits. Current blocker is tool quota, not a review finding.
5. Keep exact-head CI/UAT/runtime green; merge PR #72 only after all required gates are satisfied.
6. Accepted main and visible release remain unchanged until merge/release governance completes.

## Standing boundaries

M2.4.4 remains CLOSED/PASS/FROZEN. Layer 1 authority, deterministic Layer 2 Evidence truth, Layer 3 revalidation governance, Layer 4 human resolution and Search/Publication separation remain unchanged. No Production Supabase project exists.
