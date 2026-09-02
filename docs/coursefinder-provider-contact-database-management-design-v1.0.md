# CourseFinder Provider Contact Database Management Design v1.0

**Status:** DESIGN ACCEPTED / IMPLEMENTATION PENDING  
**Date:** 2 September 2026  
**Change Control:** CF-CHG-20260902-077  
**Execution Addendum:** A30

## 1. Objective

Provide a dedicated Provider Contacts database-management experience for PIM operators while preserving the accepted A15 acquisition/Evidence model.

The design intentionally separates:
- **source observations** — what an official source or authorised enrichment provider stated at a point in time;
- **managed contact identity** — the logical contact record operators work with;
- **managed versions** — successive curated states of that logical contact;
- **audit/import history** — who changed what, why, and from which file/source.

## 2. Existing A15 foundation

A15 already provides:
- `pipeline.provider_contact_profiles`;
- `pipeline.provider_contact_observations`;
- `pipeline.provider_contact_watch_events`;
- `pipeline.provider_contact_enrichment_attempts`;
- Provider-detail contact projection.

These tables remain authoritative for acquisition lineage and are not converted into mutable PIM rows.

## 3. Planned additive schema

### 3.1 `pipeline.provider_contacts`

Stable logical record.

Suggested fields:
- `id uuid PK`;
- `provider_id uuid NOT NULL FK catalogue.providers`;
- `record_type text` — named_staff/team_contact;
- `lifecycle_status text` — active/inactive/deleted;
- `current_version_id uuid`;
- `created_at/created_by`;
- `updated_at/updated_by`;
- `deleted_at/deleted_by/delete_reason`;
- `restored_at/restored_by`;
- `metadata jsonb`.

A Provider has zero-to-many managed contacts.

### 3.2 `pipeline.provider_contact_versions`

Append-only managed state.

Suggested fields:
- `id uuid PK`;
- `contact_id uuid NOT NULL FK`;
- `version_no integer`;
- `full_name`;
- `job_title`;
- `functional_area`;
- `region_scope`;
- `countries_or_markets`;
- `work_email`;
- `work_phone`;
- `staff_location`;
- `verification_state`;
- `verified_on`;
- `source_class`;
- `source_url`;
- `source_page_title`;
- `source_observation_id uuid`;
- `evidence_id uuid`;
- `import_batch_id uuid`;
- `effective_from/effective_to`;
- `superseded_by`;
- `change_reason`;
- `created_at/created_by`.

Do not update a prior version to make history look current.

### 3.3 `pipeline.provider_contact_import_batches`

- file name;
- SHA-256;
- Evidence artifact ID;
- parser contract/version;
- uploader;
- uploaded/dry-run/applied timestamps;
- status;
- row/create/update/restore/unchanged/skip/conflict/invalid totals;
- rollback marker where applicable.

### 3.4 `pipeline.provider_contact_import_rows`

Retain each row result:
- batch ID;
- source row number;
- source row hash;
- normalised payload;
- mapped Provider ID;
- mapping confidence/reason;
- matched contact ID/version ID;
- proposed action;
- applied action;
- validation/conflict details.

### 3.5 `pipeline.provider_contact_audit_events`

Append-only:
- contact/batch ID;
- event type;
- actor;
- reason;
- timestamp;
- before/after version IDs;
- metadata.

Events include create, edit, verify, deactivate, delete, restore, import, export.

## 4. Existing observation linkage

Add nullable `managed_contact_id` to `pipeline.provider_contact_observations`.

Reconciliation may link multiple observations over time to the same logical managed contact.

The link does not change the original observation's source data, identity hash or Evidence.

## 5. CSV import contract v1

The user-supplied CSV uses 17 fields and 306 rows.

### Mapping

| Source | Target |
|---|---|
| gug_2026_university_name | import source institution label |
| current_institution_name | Provider mapping candidate |
| institution_status | mapping/source metadata |
| staff_name | full_name |
| job_title | job_title |
| functional_area | functional_area |
| region_scope | region_scope |
| countries_or_markets | countries_or_markets |
| email | work_email |
| phone | work_phone |
| staff_location | staff_location |
| contact_record_type | record_type |
| verification_status | verification_state |
| verified_on | verified_on |
| official_source_url | source_url |
| source_page_title | source_page_title |
| notes | source/import notes |

## 6. Provider mapping

Never bind by display name alone at APPLY time.

Resolution order:
1. exact canonical/provider stable identity where supplied;
2. accepted source-scoped Provider alias;
3. deterministic normalised current institution name;
4. legacy/merged alias mapping;
5. unresolved review.

The supplied attachment contains a merger/legacy naming case resulting in 42 source names but 41 current institution names. The dry-run must prove that duplicate logical contacts are not created because two legacy labels resolve to the same current Provider.

## 7. Logical contact matching

Use strongest deterministic evidence available:
- Provider + institutional work email;
- Provider + authorised external person ID;
- Provider + normalised person name + title + region;
- team contact: Provider + official source URL + function/team + region.

Never merge on name alone.

If two candidate contacts remain plausible, classify `conflict` and require review.

## 8. Record validation

### Named staff
At least:
- Provider mapping; and
- staff name; and
- one meaningful assignment/contact/source field.

### Team contact
At least:
- Provider mapping; and
- team/function/title/source context.

Email and phone are optional.

## 9. Module interaction design

### Header
- title: Provider Contacts;
- total/current/deleted/stale/unmapped counts;
- Import;
- Export;
- Add Contact.

### Grid
Searchable and server-paged.

Default visible columns:
Provider, Contact/Team, Job title, Functional area, Region, Markets, Email, Phone, Verification, Verified on, Source, Status.

Column menu:
- show/hide;
- reorder;
- resize;
- reset to default.

Sorting:
- single or multi-column;
- Provider, contact, title, region, verified date and status supported server-side.

### Filters
- Country;
- Provider;
- record type;
- lifecycle status;
- source class;
- verification status;
- has email;
- has phone;
- freshness;
- region/market.

### Row drawer
Tabs:
1. Contact;
2. Assignment;
3. Source & Verification;
4. History;
5. Audit.

Actions are privilege-aware.

## 10. Delete / restore

Delete is a state transition.

Default list hides deleted rows but exposes a Deleted filter.

Restore is available from:
- deleted-row action;
- record drawer;
- import dry-run when a row matches a deleted contact.

A restore does not reuse or modify the delete audit event.

## 11. Import UX

1. Upload CSV.
2. Show detected contract and file hash.
3. Map/validate Providers.
4. Show totals and row issues.
5. Preview create/update/restore/unchanged/skip/conflict.
6. Permit downloadable error/review report.
7. APPLY privileged accepted rows.
8. Show batch result and audit link.

The operator should not need to leave Provider Contacts for normal import operations.

## 12. Export UX

Export respects the active view:
- current filters;
- selected columns;
- current sort;
- include-deleted toggle if authorised.

Offer a separate "Full managed export" for PIM/Data Admin where version/audit metadata is required.

Export should contain data, not private Evidence file contents.

## 13. Performance

All grid reads must be server-paged and indexed for common filter/sort predicates.

Global search should use bounded text search over the managed current projection rather than transferring all contacts to the browser.

Representative acceptance should include at least tens of thousands of contacts even though the first AU dataset is only 306 rows.

## 14. Security

- private pipeline storage;
- no direct anon/authenticated table grants;
- role-checked read/mutation/export/import RPC/server boundaries;
- export audit;
- file upload MIME/size/hash validation;
- formula-injection-safe CSV export;
- no secrets/internal Evidence object paths in exported data.

## 15. Publication boundary

The Admin module does not imply public use.

Search/Website/Zoho fields, caching, freshness and privacy policy require a separate consumer-admission Change Control.

## 16. Initial implementation sequence

P1 — additive schema + secured read/mutation contracts.  
P2 — CSV v1 parser + Provider crosswalk + dry-run/import batch ledger.  
P3 — Provider Contacts grid + drawer + Provider deep-links.  
P4 — delete/restore + history/audit.  
P5 — filtered/full export with audit and CSV safety.  
P6 — targeted DB/API/browser/security/performance UAT.  
P7 — documentation/release notes and final bounded integration nomination.

No Production deployment or consumer publication is authorised by design acceptance alone.
