# CourseFinder Admin/PIM Design Decisions v1.33

**Status:** CURRENT M2 DESIGN DECISIONS  
**Date:** 25 September 2026  
**Supersedes:** v1.32  
**Change Controls:** CF-CHG-20260903-083, CF-CHG-20260903-084, CF-CHG-20260915-247

## Decisions 38–123
Decisions 38–83 from v1.31 and Decisions 84–123 from v1.32 remain authoritative and unchanged.

## Decision 124 — Provider-rule admission runs on a schedule and is audited separately
Deterministic provider-rule admission (Decision 106) runs every 15 minutes, after rule stamping every 5 minutes. Each admission is recorded in its own audit table with the rule, the amount and the exact page text that satisfied the check. Review items it settles are marked "superseded", never "approved", so a person's decision and a rule's are never confused. First run: 160 UQ items admitted, 89 courses gained their indicative annual fee, and the Layer 4 queue fell from 330 to 151.

## Decision 125 — Layer 3 while no model is qualified
Until a model passes two consecutive clean benchmark runs (Decision 91), Layer 3 enqueue keeps running (it makes no AI calls, so new items can be settled by provider rules), while AI dispatch and admission stay paused.

## Decision 126 — Test-only fixes may go straight to main
Changes that touch only test files may be committed directly to main (programme owner, 25 September 2026). All checks still run on the push, and any app, database or function change still goes through a pull request.

## Decision 127 — Live-site tests check current behaviour, not pinned values
Live-site tests read the current version from the release manifest instead of a hard-coded version, and use patterns where exact wording or version numbers routinely change. Stale expectations are fixed to the current behaviour while keeping each test's intent. A full check of every live-site test against the current app is the first item of P3.

## Decision 128 — Ranking editions are validated and applied automatically
Ranking editions are validated and applied automatically by the Layer 1 Ranking ETL; mapping exceptions remain traceable separately, and every edition stays visible in the import history. A new country for an existing edition is treated as an extension (add country data), never as a replacement of the accepted edition. This records a behaviour that changed earlier without a numbered decision.
