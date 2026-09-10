# CF-093 Acceptance Plan

**Status:** PLANNED

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

Do not broaden to Production. M2.5 remains paused.
