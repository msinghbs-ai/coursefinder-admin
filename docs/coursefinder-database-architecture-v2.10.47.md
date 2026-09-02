# CourseFinder Database Architecture v2.10.47

**Status:** CURRENT ADDITIVE M2.5 ARCHITECTURE  
**Date:** 2 September 2026  
**Supersedes:** v2.10.46; all unchanged accepted architecture remains authoritative.  
**Change Controls:** `CF-CHG-20260902-063`, `CF-CHG-20260902-077`

## Inherited ranking domain

The QS/THE ranking architecture introduced in v2.10.46 remains unchanged.

## Provider contact managed-registry extension

A15 already stores private Provider contact acquisition state and observations:
- `pipeline.provider_contact_profiles`;
- `pipeline.provider_contact_observations`;
- `pipeline.provider_contact_watch_events`;
- `pipeline.provider_contact_enrichment_attempts`.

A30/CF-077 adds a **logical managed-contact layer** above those source observations.

Planned additive entities:
- `pipeline.provider_contacts` — stable logical contact identity linked many-to-one to `catalogue.providers`;
- `pipeline.provider_contact_versions` — append-only managed state/history;
- `pipeline.provider_contact_import_batches` — file/import lifecycle;
- `pipeline.provider_contact_import_rows` — row-level mapping, validation and action ledger;
- `pipeline.provider_contact_audit_events` — create/edit/delete/restore/import/export audit history.

`pipeline.provider_contact_observations` may gain a nullable `managed_contact_id` link. This linkage must not rewrite the accepted A15 observation payload, identity hash or Evidence.

## Identity rule

Provider identity remains canonical in `catalogue.providers`.

A contact import may use institution names/aliases to resolve a Provider, but may not create, merge or rename Providers as a side effect.

A managed contact has its own stable UUID and can survive title, region, email or source changes through versioning.

## Deletion rule

Routine deletion is soft and reversible.

A deleted managed contact retains:
- source observations;
- managed versions;
- Evidence references;
- import lineage;
- audit events.

Restore is a new auditable state transition.

## Import rule

Import batches are hash-addressed, dry-run first and idempotent.

Each row retains:
- row hash;
- Provider mapping result;
- duplicate/match result;
- validation;
- proposed action;
- applied action.

Ambiguous Provider/contact matches remain unresolved rather than guessed.

## Security

Private contact-management tables are not directly exposed to anonymous/browser roles.

Reads and mutations use secured role-checked boundaries. Import/export/create/edit/delete/restore require current PIM/Data Admin-equivalent authority or higher, reconciled against runtime role ranks during implementation.

## Evidence / privacy

A15 first-party/Evidence precedence and licensed-data privacy rules remain unchanged.

Raw uploaded contact files are private Evidence/import artifacts, not repository fixtures or public assets.

## Consumer boundary

No Search/Website/Zoho admission is authorised.

## Deployment boundary

This revision is **design authority only** for the managed contact registry. It does not claim that the new tables, migrations, module or import data are deployed in Pilot or Production.
