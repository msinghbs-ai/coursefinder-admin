# M2.4.5 NEXT CHAT

## Current exact pickup — CF-093 Scheduled Workflow Orchestrator — 11 September 2026

- Accepted Pilot `main` remains **`9305eb3a004d12724ec26b6bab65e1d4b1ab2239`** after PR #66 / CF-092.
- Visible Admin release remains **v2.15.76**. Do not promote a newer visible release until CF-093 merge/deployed-currentness acceptance passes.
- CF-092 Scheduled Tasks configuration remains **CLOSED / PASS** and is the accepted rollback baseline.
- Active implementation is Pilot PR **#67**, branch `m245/scheduled-workflow-orchestrator-20260910`, exact current head **`029a56480d72898f083e1d7d873df7237dceab4b`**.
- Exact-head CI is green: Pilot Frontend Build **`34540590328` PASS** and Release History Contract **`34540590332` PASS**.
- Exact-head Codex re-review was requested in PR comment **`5626630031`** and is the immediate pre-merge gate. At the last reconciliation no Codex review newer than `407f63effb` had landed yet.
- Latest corrections cover fresh-migration replay finalisation, post-run search-generation ordering and the focused CF-093 UAT contract. The earlier entity labels, profile identity, literal search, panel error truthfulness, queue refresh, actor attribution and stale-search protections remain in place.
- Pilot runtime already has the equivalent final scheduler bridge semantics through migrations `20260910194125`, `20260910194149`, `20260910213556`, `20260910215546`, `20260910221808`. The repository adds `20260911054000_cf_093_scheduler_search_finalizer.sql` so a clean repository replay finishes with the same semantics without rewriting already-applied Pilot migration history.
- The public scheduler wrapper remains `SECURITY INVOKER`; the private bridge is independently curator-rank-gated. Layer 3 remains Evidence/profile/model-qualified and is not made generically runnable from Scheduled Tasks.
- Production is unchanged and M2.5 remains paused at P0.

## Immediate next decision rule

1. Check PR #67 Codex review for exact head `029a5648...` before creating another candidate.
2. If Codex reports an actionable finding, apply the smallest safe correction under CF-093, run targeted exact-head CI/UAT and request exact-head re-review again.
3. If Codex reports no actionable finding, reconcile/resolve applicable review threads, confirm exact-head CI remains green, then proceed through the governed merge and nominated deployed-currentness acceptance sequence.
4. Only after merged/deployed PASS: reconcile visible release/version and Release Notes, run nominated deployed UAT/security checks, update CF-093 + REGISTER + RUNSHEET/CURRENT-STATE/FOLLOW-UPS/NEXT-CHAT and close CF-093 if all acceptance targets are satisfied.
5. Do not silently combine Layer 3. The UI may describe `L2 → conditional L3/L4`, but Layer 3 execution must retain separate governed Evidence/profile/model eligibility and lineage.

## Governing documents

Start from `PROJECT_INSTRUCTIONS.md`, `docs/README.md`, Milestone 2 Standing Instructions, applicable A1–A20/A29/A30 addenda, current M2.4.5 continuity files, CF-087 and CF-093. Because CF-093 has been in corrective review, apply the current troubleshooting/bug-fix/recovery protocol to any further finding.

## Superseded roadmap note

Older continuity naming H12 ARWU/Diversity as the immediate next feature gate is superseded by newer repository/runtime truth. Generic dataset ETL/ARWU/Diversity remains parked unless separately re-authorised. CF-093 review/acceptance is the current exact gate.
