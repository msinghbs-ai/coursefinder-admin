# CF-093 Acceptance Plan

**Status:** OPERATOR-CATALOGUE + v2.15.77 RELEASE CURRENTNESS ACCEPTED — TARGET BUILDER FOLLOW-UP OPEN  
**Updated:** 11 Sep 2026 12:09 AEST

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

Pilot runtime migration lineage remains reconciled through `20260911001117 cf_093_scheduler_search_codex_final`. No Production Supabase resource exists.

## Security / authority acceptance

Accepted boundaries remain:

- public scheduler list wrapper is SECURITY INVOKER;
- private bridge independently requires curator-or-higher rank;
- browser list does not expose retained email snapshots;
- direct Run on demand is limited to executable bounded Layer 1–2 policies;
- Layer 3 remains Evidence/profile/model/revalidation governed;
- schedule actions preserve cadence/next-run semantics unless the operator explicitly edits the schedule;
- Search/Publication are not implied ingestion consequences;
- no Production Supabase resource exists.

Security Advisor remains at the known 191 INFO / 0 WARN / 0 ERROR baseline.

## v2.15.77 release-currentness acceptance

Pilot PR #68 `CF-093: publish v2.15.77 release currentness` completed the source/version synchronisation without weakening the release-history gate.

Exact corrective head before merge: `2efcda307bc6fee5b8d626878468151d0b42989d`.

Synchronized surfaces:

1. `src/release-currentness-entry.js` = v2.15.77;
2. `src/pim-version-entry.js` canonical release history = v2.15.77 current, while retaining v2.15.76 and v2.15.75;
3. `src/mature-main.jsx` `UI_VERSION='2.15.77'`;
4. `index.html` title = v2.15.77;
5. maintained release-history contract updated for v2.15.77 currentness and retained prior history.

Pre-merge release head evidence:

- Release History Contract `34551291580` — PASS;
- Pilot Frontend Build `34551291667` — PASS;
- Codex P1 canonical-release finding was corrected;
- exact-head Codex re-review result in PR comment `5628109418`: no major issues on reviewed commit `2efcda307b`.

PR #68 merged to main on 11 Sep 2026 at merge commit:

`643eef810ab10ab9679ab6687ee549b0664c5691`

Post-merge acceptance on that exact main commit:

- Release History Contract `34553234972` — PASS;
- Pilot Frontend Build `34553235073` — PASS;
- CourseFinder Deployed UAT `34553235214` — PASS;
- deployed commit status `coursefinder/deployed-uat/targeted/chromium-desktop` — SUCCESS;
- targeted desktop governed validation — PASS;
- mobile gate — intentionally skipped by targeted validation-tier routing, not failed.

Cloudflare branch-preview deployment of the exact release head `2efcda307b` was successful before merge. Main post-merge deployed UAT passed against `643eef810a`, confirming the deployed release-currentness path is accepted.

Visible Pilot Admin release is now **v2.15.77**.

## Remaining non-accepted orchestration scope

The following is still not implemented and is not closed by the v2.15.77 release-currentness acceptance:

- universal server-authorised Country/State/Provider/University/entity target builder;
- construction of new bounded run/schedule policies from operator selections;
- processing-mode selection (Automatic governed pipeline / Acquisition only / governed Evidence reprocess);
- consequential run preview;
- new L2 -> conditional L3 -> L4 orchestration construction.

Current Run on demand still executes an existing bounded scheduler policy by `policy_id`. These remaining capabilities must be implemented only after worker/source/profile request schemas are inventoried and the requested scope can be enforced server-side.

## Exact next gate

1. Keep CF-093 open for the unimplemented target-builder/orchestration construction, or assign that work a successor Change ID explicitly.
2. Reconcile RUNSHEET / CURRENT-STATE / FOLLOW-UPS / NEXT-CHAT to accepted Pilot main `643eef810ab10ab9679ab6687ee549b0664c5691`, visible v2.15.77.
3. Inventory actual executable ingestion contracts before exposing Country/State/Provider/University/entity target construction or processing-mode choices.
4. Do not simulate unsupported scopes client-side and do not weaken Layer 3/Evidence, Layer 4, Search/Publication, authority or UAT boundaries.
