# M2.3 Current State

**Status:** ACTIVE / RECONCILIATION REQUIRED BEFORE NEXT MATERIAL CHANGE  
**Updated:** 26 August 2026 07:07 AEST  
**Primary Change Controls:** CF-CHG-20260825-036, CF-CHG-20260825-037, CF-CHG-20260825-038

## Accepted programme baseline

- M1: CLOSED / PASS / FROZEN.
- M2.1: CLOSED / PASS.
- M2.2: CLOSED / PASS for accepted Pilot scope.
- M2.3: APPROVED / IN PROGRESS and not yet accepted.
- Production cutover/broad Publication remain outside the presently accepted M2.3 boundary unless newer governance explicitly changes that.

## Current authoritative references

Before relying on any SHA, migration, run number, database object or UI behaviour in this file, reconcile:

1. `PROJECT_INSTRUCTIONS.md`;
2. `change-control/README.md` and `change-control/REGISTER.md`;
3. latest master project plan, running build, database architecture and Admin/PIM design decisions;
4. CF-CHG-20260825-036, -037 and -038;
5. current `msinghbs-ai/Coursefinder-Pilot` main branch and deployed UAT;
6. live Supabase migrations/schema/functions/advisors/security state;
7. latest CI, deployed-browser desktop and mobile UAT results.

Newer accepted repository/deployed evidence takes precedence over all values below.

## Known continuation boundary

The next continuation must begin by reconciling the version of `m2_3_non_exposed_browser_bridge_hardening` that is actually deployed and restoring its exact deployed SQL to Pilot migrations if source/deployed drift remains.

Then, in dependency order:

1. rerun Supabase Security Advisor and verify the new public `SECURITY DEFINER` WARN findings are gone;
2. rerun Performance Advisor and retain findings/evidence;
3. rerun Onboarding, Important Date, private-helper, anonymous and rank rollback-only contracts against the final bridge architecture;
4. reconcile Pilot `main`, all builds and deployed UAT after `5a129b47…` and any later frontend/test commits;
5. diagnose and fix inherited deployed Layer 2 `course_filters`, navigation and performance failures without regressing newer parallel work;
6. complete Layer 4 all-six-action rollback UAT and prove Search signals change only after an accepted canonical change;
7. complete Layer 3 zero-call, revalidation, private-helper, Edge-auth and secret-leakage regressions;
8. complete Layer 1, Layer 2, Evidence, Search and Publication regressions;
9. rerun permanent deployed desktop and mobile UAT;
10. update CF-CHG-036/037/038, Change Control REGISTER and Running Build to reflect final migrations, Admin implementation and actual CI/UAT outcomes;
11. continue remaining CF-CHG-036 acceptance work for production-grade Layer 1/2 operations, QILT/PRISMS, Scholarships/Scholarship Selection and guides.

## Current blockers / risks to verify rather than assume

- Source/deployed drift may exist for browser-bridge hardening SQL.
- Supabase Security Advisor may still show public `SECURITY DEFINER` warnings until exact deployed/source reconciliation is complete.
- Layer 2 deployed `course_filters`, navigation and/or performance failures are inherited and must be reproduced before correction.
- Layer 4 terminal action coverage and Search-after-accepted-change behaviour are not yet accepted.
- Layer 3 private-helper/auth/secret-leakage regression gates are not yet accepted.
- Full permanent desktop/mobile deployed regression is still required after final fixes.
- CF-CHG-036 broader production-grade Layer 1/2, QILT/PRISMS, Scholarship Selection and guide acceptance remains outstanding.

## Completion rule for this phase

M2.3 may be called accepted only when every in-scope gate is PASS, explicitly DEFERRED outside M2.3, or BLOCKED with evidence and an accepted residual-risk decision. A green frontend build alone is insufficient.

## Handoff rule

Before ending any future M2.3 execution chat:

- append the actual execution outcome and evidence to `RUNSHEET.md`;
- replace stale content in this file with reconciled current truth;
- rewrite `NEXT-CHAT.md` so the next chat can continue without referring to conversation history.
