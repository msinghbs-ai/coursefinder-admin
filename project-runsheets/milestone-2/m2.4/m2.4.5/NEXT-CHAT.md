# M2.4.5 NEXT CHAT

## Current exact pickup — CF-093 — 11 September 2026 11:32 AEST

- Pilot PR **#67** is merged. Current accepted functional Pilot main for CF-093 is **`912572203e4f53ac081617b0ea567c9298cab84d`**.
- CF-092 remains the rollback baseline; CF-093 extends it without changing the Layer authority chain.
- Post-merge acceptance on `912572203...`:
  - Release History Contract **`34550482710` PASS**;
  - Pilot Frontend Build **`34550482729` PASS**;
  - CourseFinder Deployed UAT **`34550482733` PASS**; targeted desktop governed validation passed and the mobile gate was intentionally skipped by validation-tier routing.
- Pilot Supabase CF-093 runtime lineage ends at **`20260911001117 cf_093_scheduler_search_codex_final`**. Public scheduler list remains SECURITY INVOKER with a private curator-rank gate. No Production Supabase project exists.
- The final Codex P1 about an environment already having repository-only `20260911054000` as a remote head was reconciled as non-actionable: no CourseFinder runtime has that state. No migration-history repair or `--include-all` bypass was introduced.
- Accepted CF-093 operator-catalogue functionality: human task/dataset/target labels, creator/owner/former-user attribution, search-before-pagination, literal/raw/humanised search, personal column visibility/order, explicit panel errors, stale-request sequencing, canonical entity labels, profile identity, and immediate queue/Jobs follow-through after Run on demand.
- **Important remaining scope:** current Run on demand still operates on an existing bounded `policy_id`. A true Country/State/Provider/University/entity target builder, processing-mode selector, run preview and new cross-layer orchestration construction are **not implemented** and must not be claimed as accepted.
- Visible Admin release is still **v2.15.76** until the separate release-currentness gate passes.
- Pilot PR **#68 — CF-093: publish v2.15.77 release currentness** is open on branch `release/cf093-v2.15.77-20260911`. It has staged the v2.15.77 current release entry and HTML title. Before merge it must also synchronise canonical retained release history, `mature-main.jsx` `UI_VERSION`, and the release-history contract without dropping v2.15.76 history. Codex review was requested in PR comment `5628027212`.
- Production remains unchanged. M2.5 remains paused at P0.

## Immediate next actions

1. Check PR #68 CI and Codex review first.
2. Complete v2.15.77 canonical source/version synchronisation; do not accept a release overlay that leaves governed source/version history inconsistent.
3. Run release-history + frontend build, merge PR #68 only when green, then verify Cloudflare/deployed currentness and nominated deployed UAT.
4. Update CF-093, REGISTER, RUNSHEET, CURRENT-STATE, FOLLOW-UPS and NEXT-CHAT with exact release commit/run IDs.
5. Keep CF-093 open (or explicitly create a successor Change Control) for the still-unimplemented target-builder/orchestration construction. Do not simulate unsupported scopes in the client.

## Governing documents

Start with `PROJECT_INSTRUCTIONS.md`, `docs/README.md`, Milestone 2 Standing Instructions, applicable addenda, CF-087 and CF-093. Apply the troubleshooting/recovery protocol to any PR #68 CI/UAT regression rather than weakening release/security/authority contracts.
