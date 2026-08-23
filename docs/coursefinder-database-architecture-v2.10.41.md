# CourseFinder Database Architecture v2.10.41

**Effective:** 23 August 2026  
**Status:** CURRENT — M2.1 LAYER 2 CONFIGURATION FOUNDATION  
**Supersedes:** `docs/coursefinder-database-architecture-v2.10.40.md`  
**Change Control:** `CF-CHG-20260823-029`  
**Canonical identity semantics:** unchanged

## 1. Scope

All accepted v2.10.40/M1 architecture remains in force. This revision adds a reusable, versioned Layer 2 acquisition/configuration control plane. It does not redefine Provider/Course/Campus/Scholarship identity, automatically mutate canonical data, admit data to Search or publish data.

## 2. Authority sequence

`Source Configuration → Acquisition → Evidence → Observation/Extraction → Canonical Mapping → Review where required → Search Admission → Publication`

Layer 2 configuration and acquisition are upstream operational authority only. Layer 1 remains regulatory identity authority where applicable.

## 3. Persistent Layer 2 configuration model

### `pipeline.layer2_source_profiles`
Stable operational profile identity tied to `pipeline.sources` with reusable `profile_key`, domain, acquisition method, target entity type, authority class, enabled/paused state, owner, freshness SLA, schedule, current-version reference and last-inventory metadata.

### `pipeline.layer2_source_profile_versions`
Immutable configuration versions containing configuration JSON, deterministic hash, validation state/result, Change Control/UAT references, creator and timestamp. Historical Jobs/Evidence keep their original version reference after a new version becomes current.

The model supports website/catalogue/detail/document/API/JSON/CSV/XLSX/sitemap/search/discovery and other approved deterministic methods without Provider-specific schema changes.

## 4. Execution/Evidence traceability

`pipeline.jobs.source_profile_version_id` records the exact version used for a Layer 2 Job. `pipeline.evidence_artifacts.source_profile_version_id` records the generating version. `pipeline.layer2_evidence_version_guard` inherits a versioned Job reference into Evidence and rejects a mismatch.

`security.layer2_assert_profile_executable(profile_id)` rejects missing, disabled, paused, unversioned or invalid profiles before acquisition. `public.layer2_prepare_job(...)` is service-role only and stamps the exact version plus `canonical_mutation_authorised=false`.

## 5. Configuration governance

`security.layer2_validate_profile_config(jsonb)` validates the reusable contract and rejects unsafe/incomplete profiles including secret-like keys, Evidence-disabled profiles and out-of-bounds execution settings.

`public.layer2_create_profile_version(...)` is service-role only and re-checks the actor as PIM Admin rank 5 or higher. It validates before creating a new immutable version, marks the prior accepted version superseded and atomically changes the current-version pointer.

Acquisition method and target entity type are stable profile identity in this foundation; changing either requires a new profile rather than mutating historical meaning.

## 6. Browser security boundary

Layer 2 list/detail/history reads remain under the accepted `Supabase Auth → public.admin_read(text,jsonb) → server-side rank check` boundary. `public.admin_read` remains SECURITY INVOKER and anonymous execution is denied.

Direct profile/version tables are RLS-enabled with no browser-role grants. `security.layer2_sanitise_config(jsonb)` recursively strips secret-like keys from current/history configuration before browser projection even if malformed privileged data were inserted outside the normal validator.

State controls use JWT-protected Edge Function `layer2-config-control` → role re-check → service-role-only database RPC. PIM Admin rank 5 may create a validated new configuration version; Platform Admin rank 6 is required for validate/pause/resume/enable/disable state controls.

## 7. Indexing

Indexes cover profile method/state, profile/version lookup, Job/Evidence version lookup and `layer2_source_profiles.current_version_id` FK. The current-version covering index was added after Supabase performance lint identified the initial omission.

## 8. Initial contract breadth

One schema represents five materially different accepted/existing source classes for contract UAT: Provider Course detail, Course catalogue, QILT document, PRISMS XLSX feed and Scholarship search/discovery. These examples prove platform breadth; they do not make their mapping grains interchangeable.

## 9. M1 regression state

Post-change live regression checks retain:

- Search: 33,105 `course-v3` documents = 26,648 AU + 6,457 NZ;
- Search published: 0;
- canonical Courses: 43,461, all `publication_status=unpublished`.

No M2.1 migration writes canonical Course facts or Search documents.

## 10. Related documents

- `docs/coursefinder-data-flow-feature-atlas-v1.0.md`
- `docs/coursefinder-pim-admin-guide-v1.16.md`
- `docs/coursefinder-user-guide-v2.1.md`
- `docs/coursefinder-operations-runbook-v1.1.md`
- `change-control/40-layer2-enrichment/CF-CHG-20260823-029-m2-1-layer2-platform-foundation.md`
