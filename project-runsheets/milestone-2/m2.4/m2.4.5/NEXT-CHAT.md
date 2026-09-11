# M2.4.5 NEXT CHAT

## Current exact pickup — CF-093 — 11 September 2026 12:09 AEST

- Pilot PR **#67** is merged. CF-093 operator-catalogue functionality is accepted.
- Pilot PR **#68** is also merged. Current accepted Pilot main is **`643eef810ab10ab9679ab6687ee549b0664c5691`** with visible Admin release **v2.15.77**.
- v2.15.77 is synchronised across release currentness, canonical release history, shell `UI_VERSION`, HTML title and the maintained release-history contract. Canonical history retains v2.15.76 and v2.15.75.
- PR #68 exact corrective head before merge was **`2efcda307bc6fee5b8d626878468151d0b42989d`**. Codex exact-head re-review comment **`5628109418`** reported no major issues on `2efcda307b`.
- Pre-merge release evidence: Release History Contract **`34551291580` PASS** and Pilot Frontend Build **`34551291667` PASS**.
- Post-merge acceptance on `643eef810a`:
  - Release History Contract **`34553234972` PASS**;
  - Pilot Frontend Build **`34553235073` PASS**;
  - CourseFinder Deployed UAT **`34553235214` PASS**;
  - commit status `coursefinder/deployed-uat/targeted/chromium-desktop` **SUCCESS**;
  - targeted desktop governed validation passed; mobile gate was intentionally skipped by targeted-tier routing rather than failed.
- Cloudflare branch-preview deployment of exact release head `2efcda307b` succeeded before merge; deployed UAT on merge commit `643eef810a` verifies accepted deployed currentness.
- Pilot Supabase CF-093 runtime lineage still ends at **`20260911001117 cf_093_scheduler_search_codex_final`**. Public scheduler list remains SECURITY INVOKER with an independent curator-rank private gate. No Production Supabase resource exists.
- Security Advisor remains at the known **191 INFO / 0 WARN / 0 ERROR** baseline.
- **Important remaining scope:** current Run on demand still operates on an existing bounded `policy_id`. A true server-authorised Country/State/Provider/University/entity target builder, processing-mode selector, consequential run preview and new L2 -> conditional L3 -> L4 orchestration construction are **not implemented** and must not be claimed as accepted.
- CF-093 therefore remains open for that explicit target-builder/orchestration follow-up unless governance assigns it to a successor Change ID.
- Production remains unchanged. M2.5 remains a separate trust boundary.

## Immediate next actions

1. Reconcile RUNSHEET / CURRENT-STATE / FOLLOW-UPS / REGISTER to accepted Pilot main `643eef810ab10ab9679ab6687ee549b0664c5691`, visible v2.15.77.
2. Inventory actual executable worker/source/profile request schemas for each ingestion family.
3. Design the server-authorised target builder only from runtime-enforceable Country/State/Provider/University/entity bounds.
4. Keep processing-mode, run-preview and cross-layer construction explicit and governed; do not simulate unsupported scopes client-side.
5. Preserve Layer 3/Evidence, Layer 4, Search/Publication, security, authority and UAT boundaries.

## Governing documents

Start with `PROJECT_INSTRUCTIONS.md`, `docs/README.md`, Milestone 2 Standing Instructions, applicable addenda, CF-087 and CF-093. Apply the troubleshooting/recovery protocol to any new regression rather than weakening release/security/authority contracts.
