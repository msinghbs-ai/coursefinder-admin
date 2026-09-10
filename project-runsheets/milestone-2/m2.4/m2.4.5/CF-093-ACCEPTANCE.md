# CF-093 Acceptance Plan

**Status:** TARGETED ACCEPTANCE ACTIVE — CODEX RE-REVIEW PENDING

Targeted acceptance sequence:

1. Source/contract tests for workflow catalogue, human-readable labels and technical-ID progressive disclosure.
2. Frontend build/type/lint/unit gates required by current Pilot CI.
3. Targeted browser UAT for Scheduled Tasks desktop and bounded tablet/mobile behaviour.
4. Security negative paths: anonymous/insufficient-rank denial; no browser service-role/provider secrets; server-authorised target options only.
5. Runtime verification of on-demand dispatch preserving cadence/next-run and avoiding duplicate active requests.
6. Conditional Layer 3 proof only through an accepted Evidence/profile/model route; no generic L3 bypass.
7. Jobs/Evidence lineage and result follow-through.
8. Codex review on the implementation PR before merge when the code/schema diff is ready.
9. One nominated deployed acceptance after merge/deploy.

## 11 Sep 2026 current gate

Latest Pilot head after the fourth Codex correction: `e2f4e85fa33719882183366e6c6f8de9ee582eef`.

- Codex P2 search-before-pagination: corrected.
- Codex P2 refresh-queue distinguishability: corrected.
- Codex P2 deleted/banned account state: corrected.
- Codex P2 stale scheduler search-response race: corrected using request-generation sequencing; superseded loads cannot mutate result, busy or error state.
- Focused CF-093 regression contract updated for the stale-response guard.
- Pilot Frontend Build `34531234046`: PASS (`build-and-smoke`, including local browser smoke).
- Release History Contract `34531233874`: PASS.
- Fresh Codex review requested against `e2f4e85fa33719882183366e6c6f8de9ee582eef`.

**Merge/deploy gate:** HOLD until Codex returns on the corrected head with no new actionable findings, then reconcile release-currentness and run nominated deployed acceptance.

Do not broaden to Production. M2.5 remains paused.
