# CourseFinder Database Architecture v2.10.45

**Status:** CURRENT ADDITIVE M2.5 ARCHITECTURE  
**Date:** 1 September 2026  
**Supersedes:** v2.10.44; all unchanged accepted architecture remains authoritative.  
**Change Control:** `CF-CHG-20260901-051`

## M2.5 additions

### Environment-specific enablement

`pipeline.environment_source_gates` separates Pilot and Production permission for source capabilities. A country/source record being usable in Pilot never implies Production approval.

Capability is independent for Provider ingestion, Course ingestion, Scholarship ingestion, Layer 2 enrichment and consumer/Search exposure.

The lifecycle is:

`seed_only → source_identified → source_qualified → pilot_ingestion → pilot_uat_pass → production_approved → production_enabled → monitored`.

No Production row is seeded automatically.

### Scraper and AI environment gates

`pipeline.layer2_provider_environment_gates` and `pipeline.layer3_profile_environment_gates` sit above existing acquisition/model profile configuration.

They do not duplicate credentials, task profiles, quotas, prompts or benchmarks. They answer one additional question: **is this already-qualified integration authorised in this environment?**

Production enablement therefore requires separate Production state even when Pilot qualification already exists.

### Capacity observations

`pipeline.platform_capacity_policy` stores configurable planning thresholds.

`pipeline.platform_capacity_observations` records:
- database logical bytes;
- cumulative PostgreSQL temp bytes/files;
- Evidence Storage object count/bytes;
- Evidence artifact count;
- unmatched object/artifact counts;
- largest relations;
- Evidence planning policy;
- backup/PITR reconciliation state.

The existing `pipeline.evidence_capacity_policy` remains authority for the Evidence planning envelope; M2.5 does not create a competing Evidence capacity model.

### Retention classes

`pipeline.retention_class_policies` distinguishes immutable governance history from potentially transient operational state.

Policy definition does not itself confer deletion authority. Destructive implementation requires a separate bounded purge change with dry-run and integrity proof.

### Layer 4 block decisions

`pipeline.layer4_block_decisions` is append-only and independent from the existing field-override and publication-decision ledgers.

Scopes:
- operational;
- publication;
- Search;
- data-quality quarantine.

Latest non-expired decision determines effective state for that scope. Unblock is a superseding event, not deletion. The ledger preserves actor, reason, timestamps, optional expiry/review and approval context.

### Platform UAT and workload catalogues

`pipeline.platform_uat_catalogue` records accepted Pilot domains and not-yet-run Production gates.

`pipeline.performance_workload_profiles` records serving/ingestion/concurrency profiles while hard ceilings remain:
- 3,000 ms RPC/detail;
- 250 kB management/page;
- 60 kB filter/options.

## Security boundary

Private `pipeline` tables are not directly exposed to anonymous clients.

Read/write access uses secured functions with explicit role checks. Layer 4 block mutation requires rank 5. Internal block evaluation is service-role only.

## Production boundary

No Production database/project exists at this architecture revision. These tables are deployed only in Pilot to establish the control model. Production rows/resources require CF-049 provisioning approval and subsequent Production UAT.
