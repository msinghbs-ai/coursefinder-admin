# CF-CHG-20260902-077 — Provider Contact Database Management

**Status:** DESIGN ACCEPTED / IMPLEMENTATION PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 2 September 2026 16:24 AEST (+10:00)  
**Origin chat/workstream:** CourseFinder M2.5 addendum — dedicated Provider Contacts module  
**Owner:** M2.5 Admin/PIM workstream  
**Change class:** schema / Admin-PIM / import-export / audit / privacy / UAT

## Trigger

Create a separate **Provider Contacts** Admin module linked to canonical Provider identity, supporting multiple contacts per university/provider, mass import, individual management, soft-delete/restore, fluid searchable/sortable columns, column filters/order controls, and PIM-admin import/export from the module itself.

The first import contract is based on the user-supplied file:

`Australian_42_Universities_International_Recruitment_Contacts_2026_SUPABASE.csv`

The raw attachment is not committed to the repository by this Change Control. At implementation it must enter through the governed private Evidence/import path.

## Relationship to A15

This change **extends, and does not replace, A15** (`CF-CHG-20260829-046`).

A15 remains authority for:
- Layer 2 first-party contact discovery;
- contact observations;
- source/Evidence/freshness;
- contact watch events;
- optional licensed professional enrichment.

CF-077 adds a managed PIM registry/workspace above those source observations so operators can curate a stable logical contact record without rewriting historical Evidence.

## Baseline attachment profile

The supplied CSV contains:
- 306 rows;
- 17 columns;
- 42 source university names;
- 41 current institution names because legacy/merged institution naming is present;
- 291 `named_staff` rows;
- 15 `team_contact` rows.

Important import-quality characteristics:
- `staff_name` is nullable for team contacts;
- email is not present on every row;
- phone is not present on every row;
- staff location is sparse;
- one institution merger/alias pattern can produce duplicate logical contacts if matching is performed only on source university name;
- verification/source URL/page title are part of the source contract and must be retained.

## Governing data-management principles

1. **Provider remains identity authority.** A contact cannot create, merge or rename a Provider.
2. **One logical contact has a stable managed ID.** Source observations and manual/import revisions attach to that logical contact.
3. **Source Evidence is not edited in place.** A manual/import correction creates a new managed version or resolution event while the original A15/source observation remains historically traceable.
4. **Delete means reversible soft-delete.** No routine UI action hard-deletes contact history, Evidence, import rows or audit events.
5. **Restore is a first-class action.** Restore creates an auditable state transition and reactivates the managed contact without erasing the deletion event.
6. **Imports are dry-run first and idempotent.** File hash, row hash, provider mapping, duplicate detection and proposed create/update/restore/skip/conflict actions are previewed before APPLY.
7. **Provider alias/merger handling is explicit.** Source institution names map through governed Provider aliases/crosswalks to `provider_id`; ambiguous mappings are review items, never guessed.
8. **Professional/public contact boundary remains.** A15 privacy and licensed-data restrictions remain in force; no personal-email/mobile reveal is introduced.
9. **Freshness is explicit.** Verification/observed dates are retained and filterable; missing freshness is not manufactured.
10. **Exports are role-gated and auditable.** Export is a managed Admin action, not a public consumer endpoint.
11. **Search/Website/Zoho admission is unchanged.** No consumer publication is authorised by CF-077.

## Planned logical data model

Additive private structures:

- `pipeline.provider_contacts`
  - stable managed contact identity;
  - `provider_id` FK;
  - record type (`named_staff` / `team_contact`);
  - lifecycle status (`active`, `inactive`, `deleted`);
  - created/updated/deleted/restored actor/time metadata.

- `pipeline.provider_contact_versions`
  - append-only managed versions;
  - name/title/function/region/markets/email/phone/location;
  - source class/import batch/source URL/page title/verification state;
  - effective and supersession timestamps;
  - link to A15 observation/Evidence where available.

- `pipeline.provider_contact_import_batches`
  - file name/hash, Evidence ID, actor, parser version;
  - dry-run/apply state and totals.

- `pipeline.provider_contact_import_rows`
  - row number/hash;
  - raw-normalised source payload;
  - provider mapping result;
  - proposed/applied action;
  - validation/conflict messages.

- `pipeline.provider_contact_audit_events`
  - create/edit/verify/delete/restore/import/export events;
  - actor/time/reason;
  - before/after references rather than destructive overwrite.

Existing `pipeline.provider_contact_observations` remains the source-observation history. Implementation should add a nullable managed-contact link rather than migrate or rewrite accepted A15 Evidence.

## CSV v1 mapping

| CSV column | Managed meaning |
|---|---|
| `gug_2026_university_name` | source institution label / import reference only |
| `current_institution_name` | Provider mapping candidate, resolved to canonical `provider_id` |
| `institution_status` | source mapping/legacy status metadata |
| `staff_name` | contact name |
| `job_title` | job title |
| `functional_area` | functional area |
| `region_scope` | region/territory scope |
| `countries_or_markets` | market/country scope |
| `email` | professional/work email |
| `phone` | public work phone |
| `staff_location` | staff location |
| `contact_record_type` | named staff vs team contact |
| `verification_status` | source verification state |
| `verified_on` | verified/freshness date |
| `official_source_url` | official first-party source |
| `source_page_title` | retained source-page context |
| `notes` | governed source/import note |

## Matching / duplicate rules

Preferred logical identity evidence, strongest first:
1. canonical Provider + normalised institutional work email;
2. canonical Provider + licensed/first-party external person identifier when authorised;
3. canonical Provider + normalised name + job title + region/market;
4. for team contacts: canonical Provider + source URL + team/function/region.

A weak match must not silently merge contacts. Ambiguous rows become `conflict/review`.

Dry-run result classes:
- create;
- update/supersede;
- restore;
- unchanged;
- duplicate/skip;
- provider_unmatched;
- provider_ambiguous;
- invalid;
- conflict.

## Provider Contacts module

Primary placement: **Catalogue → Provider Contacts**.

Required operator capabilities:
- server-paged management grid;
- global search across Provider, name, title, function, region, market and email;
- per-column filters;
- sortable columns;
- reorderable/resizable/show-hide columns;
- persisted user view preferences where supported;
- Provider/country/record-type/status/source/verification/freshness filters;
- active/inactive/deleted toggle;
- deep-link to Provider detail;
- Provider detail deep-link back to a pre-filtered Contacts view;
- individual contact drawer/edit workflow;
- source/Evidence/history/audit tabs;
- soft-delete and restore;
- mass import;
- filtered export;
- import/export history.

## Import workflow

`Upload → register private Evidence → parse → map Providers → validate → duplicate/conflict reconciliation → dry-run preview → APPLY → audit/report`

APPLY must be atomic per accepted row and resumable at batch level. One bad row must not corrupt accepted rows or require re-uploading the file.

## Export workflow

PIM/Data Admin or higher may export:
- current filtered view;
- selected columns;
- current managed records;
- optionally include inactive/deleted records;
- optionally include version/audit metadata where authorised.

Exports must not include private Evidence object contents or hidden provider credentials/secrets.

## Permissions

Use the existing CourseFinder role/rank model; do not invent a browser-only permission model.

At minimum:
- authenticated operational roles may read according to existing Admin policy;
- contact create/edit/delete/restore/import/export requires PIM/Data Admin-equivalent privilege or higher;
- direct private-table access remains revoked;
- mutations occur through role-checked server/RPC boundaries;
- anonymous and insufficient-rank negatives are permanent UAT.

Exact role-rank mapping is an implementation-time reconciliation against current runtime authority.

## UAT

Targeted acceptance must cover:
- schema/RLS/grants and anonymous negatives;
- multi-contact Provider cardinality;
- A15 observation/history preservation;
- CSV 17-column parser contract;
- 42-university Provider crosswalk including merged/legacy-name case;
- duplicate/idempotent re-import;
- team contact with no staff name;
- missing email/phone acceptance where otherwise valid;
- dry-run create/update/restore/skip/conflict counts;
- individual edit with append-only version history;
- soft-delete then restore;
- search/filter/sort/column ordering;
- filtered export;
- desktop/tablet/mobile responsive grid/drawer;
- no Search/Website/Zoho consumer change;
- Security/Performance Advisor disposition.

## Rollback

Until implementation, rollback is documentation-only.

After implementation, rollback must disable the Provider Contacts module/read-mutation surface and reverse additive schema only if no accepted managed history depends on it. Accepted A15 observations/Evidence must never be deleted as rollback convenience.

## Current disposition

Design is accepted. No Pilot schema, UI route, import batch, contact mutation or consumer publication is claimed by this record yet.
