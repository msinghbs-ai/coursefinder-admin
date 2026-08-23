# CourseFinder PIM Admin Guide v1.16

**Effective:** 23 August 2026  
**Status:** CURRENT — M2.1 LAYER 2 PLATFORM  
**Supersedes:** `docs/coursefinder-pim-admin-guide-v1.15.md`  
**Change Control:** `CF-CHG-20260823-029`

## 1. Authority boundary

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`.

Layer 2 acquisition does not redefine Layer 1 identity and never directly authorises canonical mutation. Configuration, execution, Evidence, observation/mapping, Search admission and Publication remain separate governed stages.

## 2. Role/access requirements

| Surface/action | Minimum role |
|---|---|
| Layer 2 Config list/detail/history/diff | Pipeline Operator, rank 4 |
| Create a validated immutable configuration version | PIM Admin, rank 5 |
| PIM mapping/governance downstream | PIM Admin, rank 5 |
| Validate current profile / pause / resume / enable / disable | Platform Admin, rank 6 |

Normal Layer 2 reads use `Supabase Auth → public.admin_read(text,jsonb) → security.admin_layer2_config_read`. `admin_read` remains SECURITY INVOKER and anon cannot execute it. Configuration version creation and profile-state controls use the JWT-protected `layer2-config-control` Edge Function. The Edge Function re-checks rank, then uses the server-side service client to call service-role-only database functions. Version creation requires rank 5; operational state controls require rank 6.

## 3. Reusable configuration contract

Persistent objects:

- `pipeline.layer2_source_profiles` — stable profile identity and current operational state;
- `pipeline.layer2_source_profile_versions` — immutable versioned configuration/hash/validation/governance references;
- `pipeline.jobs.source_profile_version_id` — exact configuration version used for a governed Layer 2 Job;
- `pipeline.evidence_artifacts.source_profile_version_id` — exact generating configuration version, inherited/matched to versioned Job Evidence.

The schema is acquisition-method/provider agnostic. Supported methods include website, Course catalogue/detail, fee schedule, Intake/calendar, English requirements, Scholarship catalogue, document, structured API, JSON, CSV, XLSX, sitemap, search/discovery endpoint and other explicitly approved deterministic mechanisms.

## 4. Configuration semantics

The current version may govern source/country/authority, domain, method, base/discovery URL, URL patterns, include/exclude rules, pagination, non-secret headers, allowed authentication mechanism reference, rate limit, concurrency, timeout, retry/backoff, robots treatment, MIME/payload limits, parser profile, target entity, mapping/stable-ID strategy, regulatory-code extraction, Evidence requirement, freshness SLA, schedule, content-change policy, owner and Change Control/UAT reference.

Credential material is not a permitted configuration field. Secret-like keys (`password`, tokens, API keys, Authorization, cookies, client secrets, etc.) fail validation. `security.layer2_sanitise_config` recursively removes secret-like keys from browser current/history projections as a second defence if privileged malformed data ever bypassed normal validation. Actual credentials remain server-side.

Acquisition method and target entity type are stable profile identity in this foundation. If either meaning changes, create a different profile rather than changing the meaning of historical versions.

## 5. Configuration version workflow

PIM Admin or Platform Admin can use **Create new version** in profile detail. The editor starts from the current sanitised configuration. The operator supplies the owning Change Control and optional UAT reference and chooses **Validate & create version**.

`public.layer2_create_profile_version(...)` is service-role only and re-checks the supplied actor as rank 5 or higher. It:

1. requires an object and Change Control reference;
2. requires acquisition method/target to match stable profile identity;
3. runs `security.layer2_validate_profile_config` before insertion;
4. computes the configuration hash;
5. inserts a new immutable version with creator/governance metadata;
6. marks the prior valid version `superseded`;
7. atomically updates `current_version_id` and the profile SLA/schedule where supplied.

An invalid configuration fails before version creation/current-pointer change. Duplicate identical configuration is rejected rather than manufacturing a new version number.

## 6. Pre-execution gate

`security.layer2_assert_profile_executable(profile_id)` blocks dispatch if the profile is missing, disabled, paused, lacks a current version or current validation is not `valid`.

`public.layer2_prepare_job` is service-role only. It invokes the gate and creates a queued Job carrying `source_profile_version_id` and explicit `canonical_mutation_authorised=false`. Future deterministic adapters should enter through this shared preparation contract or an equivalently governed adapter-specific wrapper; they must not insert unversioned Jobs and then patch them later.

## 7. Evidence traceability

The `pipeline.layer2_evidence_version_guard` trigger inherits a Job's non-null profile-version ID into Evidence and rejects mismatches. This prevents Evidence from claiming a different configuration than the Job that generated it.

Do not rewrite historical version references when a profile changes. Historical Jobs/Evidence stay tied to the generating version.

## 8. Admin screen behaviour

**Launcher:** `Layer 2 Config`.  
**Screen:** `Enrichment Source Configuration`.

List fields: source/profile, country, method, affected Provider/entity scope, version, validation, health, last success, inventory, Jobs/Evidence and blocker. Filters: search, country, method, health.

Profile detail shows the recursively sanitised configuration, affected Provider/target, current version/hash/governance, **Changes from previous version**, configuration history, source authority, last success/failure/blocker, schedule/SLA and recent Job/Evidence traceability. Rank 5+ receives governed version creation. Platform Admin receives Validate-current/Pause/Resume/Disable/Enable operational controls.

## 9. Multiple materially different profiles proven

The initial reusable contract represents materially different existing sources on one schema: RMIT Course detail pages, UQ Course catalogue pages, QILT document acquisition, PRISMS XLSX feed and Study Australia Scholarship search/discovery. These examples prove contract breadth; they are not permission to infer identical mapping semantics across domains.

## 10. State semantics and failure handling

- `valid`: configuration contract passes; reachability is separate.
- `invalid`: dispatch blocked.
- `superseded`: historical valid version no longer current; historical provenance remains valid.
- `paused` / `disabled`: dispatch blocked intentionally.
- `stale`: last success older than SLA; prior Evidence remains provenance, not necessarily current truth.
- `degraded`: newer failure than success.
- `source_null`: successful authoritative acquisition proves omission at the applicable grain.
- `inaccessible`: source could not be obtained; never convert to source-null.
- `not_yet_enriched`: no governed Layer 2 fact has yet been established.
- `ambiguous`: deterministic mapping cannot safely select canonical target; send to review.

## 11. Search/publication consequences

Profile validity, acquisition success and Evidence presence have no automatic Search/publication effect. Mapping must preserve canonical identity/field semantics. Search admission remains source/domain/UAT governed and Publication remains independently controlled.

## 12. Do / Don't

**Do:** version every material configuration change; use the governed editor rather than manual DB/source edits; validate before dispatch; store exact Job/Evidence version link; preserve source authority and grain; use CRICOS/NZQA codes only when actually extracted/sourced; route ambiguity to review.

**Don't:** store secrets in profile JSON; overwrite historical versions; create Provider-specific schema columns; let discovery/acquisition mutate canonical tables directly; use Provider/course names alone as stable identity; manufacture null/zero values; silently reclassify stale/inaccessible data as current/source-null.

## 13. Troubleshooting

1. Check profile enabled/paused state.
2. Check current version and validation errors.
3. For rejected version creation, read the returned validation error; do not bypass it through SQL/environment/source edits.
4. Check freshness SLA and latest successful/failing source state.
5. Inspect Pipeline Ops Job result/error/cursor.
6. Confirm Job contains the expected `source_profile_version_id`.
7. Confirm Evidence version matches Job and inspect artifact/source URL/hash.
8. Inspect observation/mapping and Review Queue for ambiguity.
9. Inspect downstream Search admission separately; do not use configuration health as proof of admission/publication.

## 14. Related documents

- `docs/coursefinder-user-guide-v2.1.md`
- `docs/coursefinder-data-flow-feature-atlas-v1.0.md`
- `docs/coursefinder-operations-runbook-v1.1.md`
- `docs/coursefinder-database-architecture-v2.10.41.md`
- `change-control/40-layer2-enrichment/CF-CHG-20260823-029-m2-1-layer2-platform-foundation.md`

## Revision history

### v1.16
- Added reusable/versioned Layer 2 source configuration contract and UI.
- Added rank-5 governed configuration version creation and configuration diff/history.
- Added recursive browser-side projection sanitisation at the database read layer.
- Added pre-execution dispatch guard and Job/Evidence version traceability.
- Added rank-6 operational state-control boundary.
- Retains all M1 semantic rules from v1.15 unless explicitly extended above.