# M2.4.1 — Next Chat

Continue **M2.4.1 — Layer 1 Regulatory Operations Maturity & Automation** only. Do not begin M2.4.2 feature work.

## Mandatory checkpoint

Read the M2.4.1 RUNSHEET, CURRENT-STATE and FOLLOW-UPS plus current Change Control `CF-CHG-20260826-043`, then reconcile current Pilot main/runtime/Supabase before changing anything.

Accepted starting milestone baseline remains M2.4.0 PASS at `ba846abb8f55c0c28d65de9e676bd29ed09a3ab4`.

Latest M2.4.1 implementation sequence at handover:

- `e6899a893bc89ec18bdf01a151c0e0ee77573946` — Layer 1 v2.15.7 operations UI/control-plane integration. Frontend build passed; deployed targeted UAT `32962485153` failed because the targeted harness incorrectly ran nine permanent suites and `openLayer1()` returned the legacy host instead of the new Layer 1 dialog.
- `b58d49294f6b9ad1921443d52c8641bbc2df35e6` — harness correction: real Layer 1 dialog adapter, one-suite Stage A, explicit cache restore/save, Chromium install without repeated OS-dependency setup, stale release assertion removed.

## Immediate next action

1. Inspect the exact build and deployed Stage A result for `b58d4929…`.
2. If PASS, continue real AU/NZ Layer 1 source-validation and operations lifecycle proof.
3. If FAIL, diagnose only the failing Layer 1 deterministic/runtime contract and fix it; do not broaden the active suite.
4. Then complete scheduler → governed Layer 1 recheck execution, retry/resume/idempotency/hash no-change and housekeeping proof.
5. Only after Stage A is green and implementation is complete, promote one candidate to bounded Stage B desktop/mobile integration.
6. Only after Stage B PASS, nominate one frozen SHA for exactly one complete Stage C deployed desktop/mobile acceptance matrix.

Do not update Running Build/Master Project Plan or close the Change Control until the exact Stage C SHA passes and all guides/runbooks/security evidence match deployed state.
