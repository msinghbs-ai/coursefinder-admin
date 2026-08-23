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
| Layer 2 Config list/detail/history | Pipeline Operator, rank 4 |
| PIM mapping/governance downstream | PIM Admin, rank 5 |
| Validate/pause/resume/enable/disable source profile | Platform Admin, rank 6 |

Normal Layer 2 reads use `Supabase Auth → public.admin_read(text,jsonb) → security.admin_layer2_config_read`. `admin_read` remains SECURITY INVOKER and anon cannot execute it. Profile-state controls use the JWT-protected `layer2-config-control` Edge Function; browser tokens are checked for Platform Admin rank 6 and only the server-side service client can call `public.layer2_config_control`.

## 3. Reusable configuration contract

Persistent objects:

- `pipeline.layer2_source_profiles` — stable profile identity and current operational state;
- `pipeline.layer2_source_profile_versions` — immutable versioned configuration/hash/validation/governance references;
- `pipeline.jobs.source_profile_version_id` — exact configuration version used for a governed Layer 2 Job;
- `pipeline.evidence_artifacts.source_profile_version_id` — exact generating configuration version, inherited/matched to versioned Job Evidence.

The schema is acquisition-method/provider agnostic. Supported methods include website, Course catalogue/detail, fee schedule, Intake/calendar, English requirements, Scholarship catalogue, document, structured API, JSON, CSV, XLSX, sitemap, search/discovery endpoint and other explicitly approved deterministic mechanisms.

## 4. Configuration semantics

The current version may govern source/country/authority, domain, method, base/discovery URL, URL patterns, include/exclude rules, pagination, non-secret headers, allowed authentication mechanism reference, rate limit, concurrency, timeout, retry/backoff, robots treatment, MIME/payload limits, parser profile, target entity, mapping/stable-ID strategy, regulatory-code extraction, Evidence requirement, freshness SLA, schedule, content-change policy, owner and Change Control/UAT reference.

Credential material is not a permitted configuration field. Secret-like keys (`password`, tokens, API keys, Authorization, cookies, client secrets, etc.) fail validation. Actual credentials stay server-side.

## 5. Pre-execution gate

`security.layer2_assert_profile_executable(profile_id)` blocks dispatch if the profile is missing, disabled, paused, lacks a current version or current validation is not `valid`.

`public.layer2_prepare_job` is service-role only. It invokes the gate and creates a queued Job carrying `source_profile_version_id` and explicit `canonical_mutation_authorised=false`. Future deterministic adapters should enter through this shared preparation contract or an equivalently governed adapter-specific wrapper; they must not insert unversioned Jobs and then patch them later.

## 6. Evidence traceability

The `pipeline.layer2_evidence_version_guard` trigger inherits a Job's non-null profile-version ID into Evidence and rejects mismatches. This prevents Evidence from claiming a different configuration than the Job that generated it.

Do not rewrite historical version references when a profile changes. Create a new profile version and make it current after validation.

## 7. Admin screen behaviour

**Launcher:** `Layer 2 Config`.  
**Screen:** `Enrichment Source Configuration`.

List fields: source/profile, country, method, target entity, version, validation, health, freshness/inventory, Jobs, Evidence, owner. Filters: search, country, method, health.

Profile detail shows the non-secret allowlisted configuration, version/hash/Change Control history, source authority, schedule/SLA and recent Job/Evidence traceability. Platform Admin receives Validate/Pause/Resume/Disable/Enable controls; lower authorised ranks receive read-only configuration.

## 8. Multiple materially different profiles proven

The initial reusable contract represents materially different existing sources on one schema: RMIT Course detail pages, UQ Course catalogue pages, QILT document acquisition, PRISMS XLSX feed and Study Australia Scholarship search/discovery. These examples are proof of contract breadth; they are not permission to infer identical mapping semantics across domains.

## 9. State semantics and failure handling

- `valid`: configuration contract passes; reachability is separate.
- `invalid`: dispatch blocked.
- `paused` / `disabled`: dispatch blocked intentionally.
- `stale`: last success older than SLA; prior Evidence remains provenance, not necessarily current truth.
- `degraded`: newer failure than success.
- `source_null`: successful authoritative acquisition proves omission at the applicable grain.
- `inaccessible`: source could not be obtained; never convert to source-null.
- `not_yet_enriched`: no governed Layer 2 fact has yet been established.
- `ambiguous`: deterministic mapping cannot safely select canonical target; send to review.

## 10. Search/publication consequences

Profile validity, acquisition success and Evidence presence have no automatic Search/publication effect. Mapping must preserve canonical identity/field semantics. Search admission remains source/domain/UAT governed and Publication remains independently controlled.

## 11. Do / Don't

**Do:** version every material configuration change; validate before dispatch; store exact Job/Evidence version link; preserve source authority and grain; use CRICOS/NZQA codes only when actually extracted/sourced; route ambiguity to review.

**Don't:** store secrets in profile JSON; create Provider-specific schema columns; let discovery/acquisition mutate canonical tables directly; use Provider/course names alone as stable identity; manufacture null/zero values; silently reclassify stale/inaccessible data as current/source-null.

## 12. Troubleshooting

1. Check profile enabled/paused state.
2. Check current version and validation errors.
3. Check freshness SLA and latest successful/failing source state.
4. Inspect Pipeline Ops Job result/error/cursor.
5. Confirm Job contains the expected `source_profile_version_id`.
6. Confirm Evidence version matches Job and inspect artifact/source URL/hash.
7. Inspect observation/mapping and Review Queue for ambiguity.
8. Inspect downstream Search admission separately; do not use configuration health as proof of admission/publication.

## 13. Related documents

- `docs/coursefinder-user-guide-v2.1.md`
- `docs/coursefinder-data-flow-feature-atlas-v1.0.md`
- `docs/coursefinder-operations-runbook-v1.1.md`
- `change-control/40-layer2-enrichment/CF-CHG-20260823-029-m2-1-layer2-platform-foundation.md`

## Revision history

### v1.16
- Added reusable/versioned Layer 2 source configuration contract and UI.
- Added pre-execution dispatch guard and Job/Evidence version traceability.
- Added rank-6 state-control boundary and browser-secret restrictions.
- Retains all M1 semantic rules from v1.15 unless explicitly extended above.