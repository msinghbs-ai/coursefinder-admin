# CF-093 Acceptance Plan

**Status:** OPERATOR-CATALOGUE FUNCTIONAL ACCEPTANCE PASS — RELEASE CURRENTNESS ACTIVE — TARGET BUILDER FOLLOW-UP OPEN  
**Updated:** 11 Sep 2026 11:33 AEST

## Accepted functional gate

Pilot PR #67 merged to main at `912572203e4f53ac081617b0ea567c9298cab84d`.

Pre-merge candidate `780049340a1a282168acffbf429ae09a8cd82864`:

- Pilot Frontend Build `34545457889` — PASS;
- Release History Contract `34545457887` — PASS;
- Cloudflare candidate deployment — PASS;
- Codex corrections reconciled through the exact-head review cycle.

Post-merge main `912572203e4f53ac081617b0ea567c9298cab84d`:

- Release History Contract `34550482710` — PASS;
- Pilot Frontend Build `34550482729` — PASS including local browser smoke;
- CourseFinder Deployed UAT `34550482733` — PASS;
- deployed targeted desktop governed validation — PASS;
- mobile gate — intentionally skipped by targeted validation-tier routing rather than failed.

Pilot runtime migration lineage is reconciled through `20260911001117 cf_093_scheduler_search_codex_final`. Production is unchanged.

## Security / authority acceptance

Accepted boundaries remain:

- public scheduler list wrapper is SECURITY INVOKER;
- private bridge independently requires curator-or-higher rank;
- browser list does not expose retained email snapshots;
- direct Run on demand is limited to executable bounded Layer 1–2 policies;
- Layer 3 remains Evidence/profile/model/revalidation governed;
- schedule actions preserve cadence/next-run semantics unless the operator explicitly edits the schedule;
- Search/Publication are not implied ingestion consequences;
- no Production deployment or Production Supabase resource exists.

Security Advisor remains at the known 191 INFO / 0 WARN / 0 ERROR baseline.

## Release-currentness gate

Visible release remains v2.15.76 until the final source/version synchronisation passes.

Pilot PR #68 — `CF-093: publish v2.15.77 release currentness` — is the current release gate. It must keep these surfaces consistent:

1. `src/release-currentness-entry.js` current release;
2. `src/pim-version-entry.js` canonical retained history with v2.15.76 retained;
3. `src/mature-main.jsx` `UI_VERSION`;
4. `index.html` title;
5. maintained release-history contract;
6. build/preview/deployed-currentness evidence.

Initial PR #68 staging intentionally exposed the version mismatch to the existing release-history guard: Frontend Build passed while Release History Contract failed. That failure is correct and must be fixed by synchronising the source surfaces, not by weakening the contract. Codex review is requested on PR #68.

## Remaining non-accepted orchestration scope

The following is not part of the accepted functional gate yet:

- universal server-authorised Country/State/Provider/University/entity target builder;
- construction of new bounded run/schedule policies from operator selections;
- processing-mode selection (Automatic governed pipeline / Acquisition only / governed Evidence reprocess);
- consequential run preview;
- new L2 -> conditional L3 -> L4 orchestration construction.

Current Run on demand still executes an existing bounded scheduler policy by `policy_id`. These remaining capabilities must be implemented only after worker/source/profile request schemas are inventoried and the requested scope can be enforced server-side.

## Exact next gate

1. Complete PR #68 canonical v2.15.77 synchronisation.
2. Require green release-history and frontend CI.
3. Merge only after required Codex/review findings are resolved.
4. Run deployed currentness/UAT on the release head.
5. Reconcile Change Control and continuity.
6. Continue the target-builder/orchestration phase without claiming unsupported scopes.
