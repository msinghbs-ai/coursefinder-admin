# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** IMPLEMENTED / OPERATOR-CATALOGUE ACCEPTED — ORCHESTRATOR TARGET BUILDER FOLLOW-UP OPEN  
**Initiated:** 2026-09-10 21:44 AEST  
**Updated:** 2026-09-11 11:31 AEST  
**Origin:** Scheduled Tasks operator UX review  
**Owner:** CourseFinder programme  
**Primary category:** 30-admin-pim-ux  
**Related categories:** 20-layer1-regulatory-ingestion, 40-layer2-enrichment, 70-security-platform, 80-uat-release-operations

## Baseline and authority

CF-093 extends the accepted CF-092 / v2.15.76 scheduler baseline. It does not replace scheduler policy/audit/idempotency semantics and does not create a generic Layer 3 execution bypass.

Authority remains:

`Layer 1 authoritative/reference -> Layer 2 deterministic enrichment -> Layer 3 governed Evidence interpretation -> Layer 4 human exception resolution -> governed consumer/publication boundary`.

Search/Publication remain downstream consequences rather than ingestion stages. Scholarship Provider ownership alone never creates Course eligibility.

## Requested operator model

The target end state remains:

`Job / Dataset -> Country -> Scope -> Target -> Processing mode -> Run now or Schedule`.

CF-093 has now delivered the reusable **Scheduled Tasks operator catalogue/read-control layer** on top of existing bounded policies. The separate arbitrary scope/target construction/orchestration portion is not yet implemented and must not be claimed as accepted functionality.

## Accepted implementation — Pilot

Pilot implementation PR **#67** merged to `main` at:

- merge commit: `912572203e4f53ac081617b0ea567c9298cab84d`;
- functional candidate reviewed before merge: `780049340a1a282168acffbf429ae09a8cd82864`;
- package candidate: `0.1.4`.

Accepted operator-catalogue behaviour includes:

- human-readable task/dataset/target labels with technical IDs retained as secondary audit detail;
- source-profile identity retained when both source and profile IDs exist;
- Provider/Course/Campus/Scholarship entity targets resolved to governed business labels where available;
- search across dataset, country, target, creator, owner and technical identifiers before pagination;
- literal `%`, `_` and escape-safe search semantics;
- raw and humanised dataset search such as `course_facts` and `Course Facts`;
- durable Created By attribution and optional Owner presentation;
- deleted/currently banned users shown as former users without destroying immutable audit identity;
- system/bootstrap/legacy policies explicitly non-human;
- per-user browser-local column visibility/order with hydration-before-persistence and Reset view;
- sticky Actions and direct Jobs/Evidence follow-through;
- explicit per-panel unavailable/error states instead of false empty operational state;
- sequenced policy and supporting-panel loads so stale responses cannot overwrite newer operator state;
- post-edit page reset/clamp and post-run queue/Jobs refresh;
- direct Run on demand still limited to executable bounded Layer 1–2 policies;
- Layer 3 remains Evidence/profile/model/revalidation governed.

Browser list reads do not project retained internal email snapshots.

## Database/runtime evidence

Pilot Supabase project: `fxcwkweaxjtknorudmwp`.

Applied CF-093 migration lineage currently ends at:

- `20260910194125 cf_093_scheduler_operator_attribution`;
- `20260910194149 cf_093_codex_review_fixes`;
- `20260910213556 cf_093_resolved_actor_search_semantics`;
- `20260910215546 cf_093_scheduler_entity_labels`;
- `20260910221808 cf_093_literal_scheduler_search`;
- `20260910232606 cf_093_scheduler_search_finalizer`;
- `20260911001117 cf_093_scheduler_search_codex_final`.

The public scheduler list wrapper remains `SECURITY INVOKER`; its private security bridge independently requires curator-or-higher rank. Production Supabase does not exist and no Production state was changed.

The final Codex P1 concerning a hypothetical environment where repository-only migration `20260911054000` had already become the remote head was reconciled against actual runtime truth and closed as non-actionable: Pilot has `20260911001117` as its latest CF-093 runtime identity, `coursefinder-demo` is still on older 20260810 lineage, and there is no Production Supabase project. No migration-history repair or `--include-all` bypass was introduced.

## Codex correction record

Material Codex findings corrected during implementation include:

1. search before pagination and filtered totals;
2. distinguishable refresh-queue targets;
3. deleted/banned actor classification;
4. canonical entity labels;
5. stale policy-search sequencing;
6. post-submit busy-state race;
7. resolved owner/creator search;
8. post-edit page validity;
9. isolation of policy search from supporting reads;
10. source-profile identity preservation;
11. literal search handling;
12. immediate queue/Jobs follow-through after Run on demand;
13. truthful supporting-panel error state;
14. clean migration replay finalisation;
15. post-run search-generation race;
16. focused UAT migration/currentness references;
17. overlapping panel refresh sequencing;
18. humanised plus raw dataset-domain search;
19. exact applied migration identity retention;
20. personal-column hydration before persistence;
21. former-user rendered-label search semantics.

## Acceptance evidence

Exact pre-merge candidate `780049340a1a282168acffbf429ae09a8cd82864`:

- Pilot Frontend Build `34545457889` — PASS;
- Release History Contract `34545457887` — PASS;
- Cloudflare candidate deployment — PASS.

Post-merge main `912572203e4f53ac081617b0ea567c9298cab84d`:

- Release History Contract `34550482710` — PASS;
- Pilot Frontend Build `34550482729` — PASS;
- CourseFinder Deployed UAT `34550482733` — PASS; desktop governed validation PASS, mobile gate correctly skipped by targeted-tier routing.

Security Advisor remains at the pre-existing **191 INFO / 0 WARN / 0 ERROR** baseline; no CF-093 security regression was introduced.

## Visible release currentness

The functional merge is accepted, but visible release synchronisation is intentionally a separate final step rather than being hidden inside the implementation merge.

Pilot PR **#68 — `CF-093: publish v2.15.77 release currentness`** is the current release gate. It must synchronise:

- `src/release-currentness-entry.js`;
- `src/pim-version-entry.js` retained release history;
- `src/mature-main.jsx` `UI_VERSION`;
- `index.html` title;
- maintained release-history contract;
- resulting build/deployed currentness evidence.

Until PR #68 passes and merges, **v2.15.76 remains the accepted visible release** even though CF-093 functional code is deployed on Pilot main.

## Explicit remaining scope

The following original CF-093 outcome is **not yet implemented** and remains open rather than being inferred from the improved policy catalogue:

- universal server-authorised scope/target builder;
- creation of a new bounded schedule/run from Country/State/Provider/University/entity selections where the underlying worker actually supports that scope;
- explicit processing-mode selection such as Automatic governed pipeline / Acquisition only / Reprocess governed Evidence;
- consequential run preview before constructing a new bounded dispatch;
- cross-layer orchestrator that can progress L2 -> conditional L3 -> L4 exception routing while retaining distinct Jobs/Evidence/authority boundaries.

Current Run on demand still executes an **existing bounded scheduler policy by policy ID**. Unsupported state/provider/entity scopes must not be simulated client-side.

Before implementing this remaining phase, inventory each ingestion worker/source/profile request schema and expose only server-enforceable bounds. Scholarship, Course enrichment, Contacts, Assets, regulatory/statistical datasets and rankings retain their dataset-specific authority rules.

## Closure decision

CF-093 is therefore **not CLOSED as a full orchestrator**. The operator-catalogue enhancement is accepted on Pilot; the remaining target-builder/orchestration construction is a durable follow-up under this Change Control unless governance assigns it a successor Change ID.

Exact next gate:

1. complete PR #68 v2.15.77 source/release currentness and deployed acceptance;
2. reconcile RUNSHEET / CURRENT-STATE / FOLLOW-UPS / NEXT-CHAT with the accepted operator-catalogue state;
3. then design the remaining target builder from actual executable ingestion contracts, not from UI assumptions.
