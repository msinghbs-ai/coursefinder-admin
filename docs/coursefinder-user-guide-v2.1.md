# CourseFinder User Guide v2.1

**Effective:** 23 August 2026  
**Status:** CURRENT — M2.1 LAYER 2 PLATFORM  
**Supersedes:** `docs/coursefinder-user-guide-v2.0.md`  
**Applies to:** frozen M1 AU+NZ baseline plus Layer 2 Platform v1.0

## 1. Operating model

CourseFinder deliberately separates authority and workflow:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`.

Layer 2 enriches canonical entities but does not redefine Layer 1 identity. Successful discovery/acquisition is not approval, Search admission or publication.

## 2. Navigation

Existing M1 navigation remains unchanged. A governed **Layer 2 Config** launcher is available to authorised operations/admin users and opens **Enrichment Source Configuration** as an independent operational console. Pipeline Ops → Jobs/Sources and Evidence remain the related run/provenance screens.

## 3. Roles and access

| Activity | Minimum role |
|---|---|
| View Layer 2 configurations | Pipeline Operator / Operations Support, rank 4 |
| Interpret/manage downstream PIM mapping | PIM/Data Administrator, rank 5, using applicable PIM workflows |
| Validate, pause, resume, enable or disable Layer 2 profile | Platform Admin, rank 6 |

Configuration controls are re-authorised server-side. Browser users never receive service-role secrets, API tokens or credential values.

## 4. Layer 2 configuration screen

The list shows source/profile, country, acquisition method, target entity type, current version, validation, health, freshness/inventory, associated Jobs, Evidence count and owner. Filters support text, country, acquisition method and health.

Open a profile to inspect:

- source/profile identity and authority;
- current immutable version and validation state;
- non-secret acquisition configuration;
- freshness SLA and schedule;
- configuration history/hash/Change Control;
- recent Job and Evidence traceability;
- Platform Admin controls where authorised.

## 5. Configuration states

- **Valid:** structurally and operationally safe enough to dispatch; not proof the source is currently reachable.
- **Invalid:** acquisition must not start.
- **Healthy:** enabled, unpaused, valid and no stronger recent failure/staleness condition.
- **Degraded:** latest failure is newer than latest success.
- **Stale:** successful acquisition is older than the configured freshness SLA.
- **Paused:** temporary operational hold.
- **Disabled:** deliberately unavailable for new acquisition.

For data facts, continue to distinguish `present / source_null / not_applicable / zero / suppressed / not_yet_enriched / stale / ambiguous / rejected`. An inaccessible source is a technical/policy condition, not `source_null`.

## 6. Normal workflow

1. Locate the source/profile in Layer 2 Config.
2. Check current version, validation, health, freshness and owner.
3. Before an acquisition run, confirm the profile is enabled, not paused and valid.
4. Inspect execution in Pipeline Ops → Jobs.
5. Inspect captured artifacts in Evidence.
6. Confirm observations map to existing canonical identity; do not use names/titles alone where a stable identifier exists.
7. Send ambiguity/conflict to Review Queue.
8. Treat Search admission and Publication as separate downstream gates.

## 7. Evidence/provenance

Every governed Layer 2 Job can identify the exact configuration version used. Evidence created from a versioned Job inherits/matches that same version reference. Historical Evidence remains tied to the historical configuration even after a newer version becomes current.

## 8. Freshness and verification

Freshness is measured against the profile SLA and acquisition history. It is not human approval. A fresh source can still contain ambiguous or inapplicable data; an older accepted fact can become stale without becoming false. Check Evidence and the applicable entity/fact verification state before consequential decisions.

## 9. Search/publication consequences

A profile being valid/healthy, a Job succeeding, or Evidence existing does **not** automatically mutate canonical facts, admit them to Search or publish them. Follow the domain-specific mapping/review/Search gate and publication governance.

## 10. Do / Don't

**Do:** use approved source profiles; retain version/Evidence links; respect source authority; distinguish source-null/inaccessible/stale; investigate blockers in Layer 2 Config + Jobs + Evidence.

**Don't:** place secrets in configuration; edit database rows to bypass validation; invent CRICOS/NZQA identifiers; patch canonical data merely to make completeness/health look better; assume successful acquisition equals publication.

## 11. Troubleshooting

- **Invalid:** inspect validation errors; correct through a new governed profile version rather than modifying historical versions.
- **Paused/disabled:** Platform Admin must explicitly resume/enable if appropriate.
- **Stale:** inspect latest successful Job and freshness SLA; retry only under source/rate/policy controls.
- **Degraded/inaccessible:** inspect Jobs error and source policy/network state; do not convert the missing result to source-null.
- **No Evidence:** inspect Job result and acquisition adapter; do not proceed to canonical mapping without required Evidence.
- **Ambiguous mapping:** use Review Queue; do not force a title/name match.

See `docs/coursefinder-data-flow-feature-atlas-v1.0.md` and `docs/coursefinder-operations-runbook-v1.1.md` for deeper operational detail.