# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** IMPLEMENTED / OPERATOR-CATALOGUE + v2.15.77 RELEASE ACCEPTED — ORCHESTRATOR TARGET BUILDER FOLLOW-UP OPEN  
**Initiated:** 2026-09-10 21:44 AEST  
**Updated:** 2026-09-11 12:09 AEST
**Origin:** Scheduled Tasks operator UX review  
**Owner:** CourseFinder programme  
**Primary category:** 30-admin-pim-ux  
**Related categories:** 20-layer1-regulatory-ingestion, 40-layer2-enrichment, 70-security-platform, 80-uat-release-operations

## Baseline and authority

CF-093 extends the accepted CF-092 scheduler baseline without replacing scheduler policy/audit/idempotency semantics and without creating a generic Layer 3 execution bypass.

Authority remains:

`Layer 1 authoritative/reference -> Layer 2 deterministic enrichment -> Layer 3 governed Evidence interpretation -> Layer 4 human exception resolution -> governed consumer/publication boundary`.

Search/Publication remain downstream consequences rather than ingestion stages. Scholarship Provider ownership alone never creates Course eligibility.

## Accepted implementation — Pilot

Pilot functional PR #67 merged to main at `912572203e4f53ac081617b0ea567c9298cab84d`. The accepted operator-catalogue layer provides human task/dataset/target labels, creator/owner/former-user attribution, search-before-pagination, literal/raw/humanised search, personal column visibility/order, explicit panel errors, stale-request sequencing, canonical entity labels, profile identity and immediate queue/Jobs follow-through after Run on demand.

Direct Run on demand remains limited to executable bounded Layer 1–2 policies. Layer 3 remains Evidence/profile/model/revalidation governed. Browser scheduler reads remain on governed public/rank-gated RPC contracts and do not expose retained internal email snapshots.

## Runtime truth

Pilot Supabase CF-093 migration lineage remains reconciled through:

- `20260910194125 cf_093_scheduler_operator_attribution`;
- `20260910194149 cf_093_codex_review_fixes`;
- `20260910213556 cf_093_resolved_actor_search_semantics`;
- `20260910215546 cf_093_scheduler_entity_labels`;
- `20260910221808 cf_093_literal_scheduler_search`;
- `20260910232606 cf_093_scheduler_search_finalizer`;
- `20260911001117 cf_093_scheduler_search_codex_final`.

The public scheduler list wrapper remains SECURITY INVOKER; its private bridge independently requires curator-or-higher rank. No migration-history repair or `--include-all` bypass was introduced. No Production Supabase resource exists.

Security Advisor remains at the known pre-existing **191 INFO / 0 WARN / 0 ERROR** baseline.

## Functional acceptance evidence

Pre-merge functional candidate `780049340a1a282168acffbf429ae09a8cd82864`:

- Pilot Frontend Build `34545457889` — PASS;
- Release History Contract `34545457887` — PASS;
- Cloudflare candidate deployment — PASS.

Post-merge functional main `912572203e4f53ac081617b0ea567c9298cab84d`:

- Release History Contract `34550482710` — PASS;
- Pilot Frontend Build `34550482729` — PASS;
- CourseFinder Deployed UAT `34550482733` — PASS.

## v2.15.77 release-currentness acceptance

PR #68 exact corrective head was `2efcda307bc6fee5b8d626878468151d0b42989d`.

The release surfaces were synchronised without weakening the release-history contract:

- `src/release-currentness-entry.js` = v2.15.77;
- canonical `src/pim-version-entry.js` = v2.15.77 current while retaining v2.15.76 and v2.15.75 history;
- `src/mature-main.jsx` `UI_VERSION='2.15.77'`;
- `index.html` title = v2.15.77;
- maintained release-history contract updated to assert v2.15.77 currentness plus retained prior history.

Pre-merge release evidence:

- Release History Contract `34551291580` — PASS;
- Pilot Frontend Build `34551291667` — PASS;
- Codex P1 release-metadata mismatch corrected;
- exact-head Codex re-review comment `5628109418`: no major issues on reviewed commit `2efcda307b`.

PR #68 merged on 11 Sep 2026 at:

`643eef810ab10ab9679ab6687ee549b0664c5691`

Post-merge release-currentness evidence on that exact main commit:

- Release History Contract `34553234972` — PASS;
- Pilot Frontend Build `34553235073` — PASS;
- CourseFinder Deployed UAT `34553235214` — PASS;
- commit status `coursefinder/deployed-uat/targeted/chromium-desktop` — SUCCESS;
- targeted desktop governed validation — PASS;
- mobile gate — intentionally skipped by targeted-tier routing, not failed.

Cloudflare branch-preview deployment for exact release head `2efcda307b` was successful before merge. Post-merge deployed UAT on `643eef810a` confirms accepted deployed currentness. Visible Pilot Admin release is now **v2.15.77**.

## Explicit remaining scope

CF-093 is **not CLOSED as a full orchestrator**. The following original outcome remains unimplemented and explicitly open:

- universal server-authorised Country/State/Provider/University/entity target builder;
- creation of new bounded schedule/run policies from operator selections only where the runtime can enforce those scopes;
- processing-mode selection such as Automatic governed pipeline / Acquisition only / Reprocess governed Evidence;
- consequential run preview;
- cross-layer construction able to progress L2 -> conditional L3 -> L4 exception routing while preserving distinct Jobs/Evidence/authority boundaries.

Current Run on demand still executes an **existing bounded scheduler policy by policy ID**. Unsupported state/provider/entity scopes must not be simulated client-side.

Before implementing the remaining phase, inventory each ingestion worker/source/profile request schema and expose only server-enforceable bounds. Scholarship, Course enrichment, Contacts, Assets, regulatory/statistical datasets and rankings retain their dataset-specific authority rules.

## Closure decision

The operator-catalogue enhancement and its v2.15.77 release-currentness gate are accepted on Pilot. CF-093 remains active only for the unimplemented target-builder/processing-mode/run-preview/cross-layer construction, unless governance deliberately assigns that scope to a successor Change ID.

Exact next gate:

1. reconcile RUNSHEET / CURRENT-STATE / FOLLOW-UPS / NEXT-CHAT to accepted Pilot main `643eef810ab10ab9679ab6687ee549b0664c5691`, visible v2.15.77;
2. inventory actual executable ingestion contracts;
3. design the server-authorised target builder from runtime truth rather than UI assumptions;
4. retain Layer 3/Evidence, Layer 4, Search/Publication, security, authority and UAT boundaries unchanged.
