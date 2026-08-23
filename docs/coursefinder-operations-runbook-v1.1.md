# CourseFinder Operations Runbook v1.1

**Effective:** 23 August 2026  
**Status:** CURRENT — M2.1 LAYER 2 PLATFORM  
**Supersedes:** `docs/coursefinder-operations-runbook-v1.0.md`  
**Audience:** Integration/Operations Support, Pipeline Operator, PIM Admin, Platform Admin

## 1. Operating principles

1. Read `PROJECT_INSTRUCTIONS.md`, `change-control/REGISTER.md` and the owning Change Control before material action.
2. Preserve `Layer 1 → Layer 2 → Layer 3 → Layer 4 → Search Admission → Publication` authority boundaries.
3. Configuration is separate from execution; successful acquisition is not canonical mutation authority.
4. Never repair a failed pipeline by inventing canonical values or manually editing downstream derived rows.
5. Evidence/version traceability is part of the operation, not optional logging.
6. Search admission and publication remain separate controls.
7. Production security gates are stricter than bounded Pilot exceptions.

## 2. Layer 2 pre-flight

Before a Layer 2 run:

- confirm environment/project and owning Change Control;
- open **Layer 2 Config** and verify source/profile identity, authority and target entity;
- confirm `enabled=true`, `paused=false`, current version exists and validation is `valid`;
- inspect acquisition method, discovery/base URL, inclusion/exclusion, pagination, rate/concurrency/timeout/retry, robots treatment, MIME/payload limits, parser/mapping/stable-ID strategy, Evidence requirement, freshness SLA and schedule;
- confirm no credential/token material is stored in configuration;
- identify expected stable identifier (including CRICOS/NZQA extraction only where source provides it);
- confirm Evidence/storage requirements and rollback path;
- use bounded acquisition when parser/source structure changed.

The generic dispatch gate (`security.layer2_assert_profile_executable`) blocks disabled, paused, missing-version or invalid profiles before acquisition. Generic preparation (`public.layer2_prepare_job`) is service-role only and stamps the exact configuration version onto the Job.

## 3. Normal Layer 2 refresh

1. Inspect profile status and current version in Layer 2 Config.
2. Validate configuration when a new/current version has changed.
3. Dispatch through the governed adapter/preparation path; never insert an unversioned Job manually.
4. Monitor Pipeline Ops → Jobs for acquisition result, duration, counts, retry/cursor and blocker.
5. Confirm Evidence exists before mapping canonical facts.
6. Verify Evidence carries the same profile-version ID as its Job.
7. Extract observations; preserve source grain and source-null/zero semantics.
8. Map only against stable canonical identity. Route ambiguity/conflict to Review Queue.
9. Apply canonical mapping only through the applicable governed mapping contract.
10. Run Search admission separately if the source/domain gate is approved.
11. Publication remains a separate action.
12. Record Job/Evidence/UAT references in the Change Control.

## 4. Profile configuration change

A material profile change creates a new immutable version; do not edit historical configuration in place.

1. Capture old version/hash and source evidence.
2. Create the new version with Change Control/UAT reference.
3. Run pre-execution validation.
4. Correct validation failures by creating/correcting the candidate version; do not bypass the validator.
5. Test the new source/parser behaviour on bounded scope.
6. Make the validated version current only under the owning control process.
7. Verify subsequent Jobs reference the new version while historical Jobs/Evidence retain old references.
8. Update Guide/Atlas if administrator-visible behaviour or semantics changed.

## 5. Pause / disable

Only Platform Admin (rank 6) may Validate/Pause/Resume/Disable/Enable via the browser control surface. The Edge Function re-checks JWT user context and rank; the underlying database control function is not executable by `anon` or `authenticated`.

- **Pause:** temporary hold. Existing Evidence/history stays visible. New generic acquisition must fail pre-flight.
- **Disable:** deliberate source/profile shutdown. Use for retired/unapproved sources or material unresolved policy/source risk.
- **Resume/Enable:** confirm the current version remains valid and source authority/policy is still approved before reactivation.

Do not use pause/disable to hide a data-quality problem; record the blocker and affected entities.

## 6. Source-null, inaccessible and stale handling

- **source_null:** authoritative content was successfully acquired and the field was absent at the relevant grain. Preserve Evidence.
- **inaccessible:** source was not obtained due to network/auth/policy/403/anti-bot/format failure. Do not mark facts source-null.
- **stale:** last successful acquisition exceeds freshness SLA. Retain previous provenance, mark freshness and re-acquire under policy.
- **zero:** sourced zero remains zero; never convert to missing.
- **not_yet_enriched:** no governed Layer 2 observation exists yet.

## 7. Evidence version mismatch

The `pipeline.layer2_evidence_version_guard` trigger automatically inherits a non-null Job profile-version ID and rejects a different supplied version.

If an adapter encounters a mismatch error:

1. stop the run rather than removing the guard;
2. inspect Job `source_profile_version_id` and adapter context;
3. confirm the Evidence belongs to that Job/source/version;
4. correct the adapter or Job association;
5. rerun bounded acquisition;
6. retain failed-run evidence/logs where applicable.

## 8. Unsafe/invalid configuration

Validation blocks unsupported acquisition/target types, missing discovery location, excessive timeout/concurrency/payload values, `evidence_required=false`, and secret-like keys such as passwords/tokens/API keys/Authorization/cookies/client secrets.

Secrets belong in approved server-side secret storage/environment bindings only. The browser receives neither the secret nor an arbitrary raw server configuration dump.

## 9. Failed acquisition

1. Record profile key/version, Job ID, source, timestamps and error.
2. Classify: policy/robots/auth/network/rate-limit/payload/MIME/parser/identity/mapping/storage/Evidence.
3. Inspect source and Evidence snapshot where acquisition reached Evidence creation.
4. Fix the owning configuration/adapter; do not patch canonical rows.
5. Respect retry/backoff and rate/concurrency controls.
6. Resume only where cursor semantics are deterministic and proven.
7. Otherwise rerun bounded scope.
8. Verify no duplicate identities/Evidence and no unintended Search/publication consequence.

Escalate **BLOCKED** if source authority/access remains unresolved or deterministic mapping cannot be proven.

## 10. Security verification

For Layer 2 platform changes verify:

- `public.admin_read` remains SECURITY INVOKER; anon denied;
- direct Layer 2 profile tables remain inaccessible to browser roles;
- `public.layer2_config_control` and `public.layer2_prepare_job` remain service-role only;
- `layer2-config-control` Edge Function has `verify_jwt=true` and Platform Admin rank check for state control;
- stored profile configuration contains no secret-like keys;
- browser config view renders only approved non-secret fields;
- no new broad browser-executable SECURITY DEFINER function appears.

Supabase's `RLS enabled/no policy` informational lint on private schemas is expected where the design intentionally denies direct table access and routes authorised reads through governed functions. Treat any new WARN/ERROR separately; do not add permissive policies just to silence INFO.

## 11. Replay / traceability UAT

For a deterministic adapter/profile revision:

- validate candidate profile;
- prepare/run bounded Job and record profile-version ID;
- confirm Evidence inherits the same version ID;
- repeat stable acquisition and verify no unintended identity duplication/churn;
- verify canonical mapping is separately authorised;
- verify Search projection/publication remain unchanged unless explicitly in scope;
- retain automated UAT evidence and update Change Control.

## 12. Related screens/documents

- Layer 2 Config — configuration/version/health/history/control.
- Pipeline Ops → Jobs/Sources — execution/source operational state.
- Evidence — artifact/job/source/observation provenance.
- Review Queue — ambiguous/conflicting deterministic mapping.
- Completeness — downstream readiness state.
- `docs/coursefinder-data-flow-feature-atlas-v1.0.md` — lifecycle, diagrams and screen mock-up.
- `docs/coursefinder-pim-admin-guide-v1.16.md` — semantic/admin contract.
- `docs/coursefinder-user-guide-v2.1.md` — role-specific operating guidance.

All v1.0 M1 operational procedures remain applicable unless superseded by the Layer 2 controls above.