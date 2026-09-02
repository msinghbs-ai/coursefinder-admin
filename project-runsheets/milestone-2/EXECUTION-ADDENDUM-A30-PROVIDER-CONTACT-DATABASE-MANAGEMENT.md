# Milestone 2 Execution Addendum A30 — Provider Contact Database Management

**Status:** AUTHORITATIVE ADDENDUM — ACTIVE  
**Effective:** 2 September 2026  
**Applies to:** M2.5 and later until superseded  
**Change Control:** CF-CHG-20260902-080

## Purpose

Turn accepted A15 Provider contact intelligence into a dedicated, maintainable Admin/PIM data-management module without weakening A15 source authority, Evidence lineage, privacy or consumer boundaries.

## Standing rule

**A15 acquires and proves contact observations. A30 manages logical contact records.**

Do not make source observations directly editable merely to satisfy CRUD requirements.

## Required module

Create **Catalogue → Provider Contacts** as a first-class route.

The module must support:
- multiple contacts per Provider;
- global search;
- server-side column filtering/sorting;
- reorderable/resizable/show-hide columns;
- individual record management;
- source/Evidence/history/audit context;
- soft-delete;
- restore deleted contact;
- mass import;
- filtered export;
- import/export history.

Provider detail retains its concise International contacts section and must deep-link to the module pre-filtered by Provider.

## Data principles

- canonical `catalogue.providers.id` is the mandatory parent key;
- Provider aliases/legacy names are mapping inputs, not new identities;
- logical contact IDs remain stable through title/region/email changes;
- versions/history are append-only;
- A15 observations remain immutable source history;
- deletion is reversible state, not physical deletion;
- Evidence and import artifacts follow existing private Storage rules;
- consumer exposure remains separately governed.

## Import contract v1

Initial CSV fields:

`gug_2026_university_name,current_institution_name,institution_status,staff_name,job_title,functional_area,region_scope,countries_or_markets,email,phone,staff_location,contact_record_type,verification_status,verified_on,official_source_url,source_page_title,notes`

Baseline attachment characteristics:
- 306 rows;
- 42 source university names;
- 41 current institution names;
- 291 named staff;
- 15 team contacts.

The parser must not require staff name for `team_contact` and must not require email or phone when the row is otherwise valid.

## Import gate

Every import uses:

`upload → Evidence registration → parse → Provider mapping → validation → duplicate/conflict classification → dry-run → APPLY`

Required dry-run classes:
- create;
- update/supersede;
- restore;
- unchanged;
- duplicate/skip;
- provider_unmatched;
- provider_ambiguous;
- invalid;
- conflict.

Re-import of the same file or same logical rows must be idempotent.

## Deletion / restore

Routine Admin delete:
- marks the logical contact deleted;
- records actor/time/reason;
- closes the current managed version where applicable;
- retains all source observations, versions, Evidence and audit history.

Restore:
- records a restore event;
- reactivates the logical contact;
- never erases the delete event.

Hard delete is an exceptional maintenance action requiring separate destructive-change authority.

## Grid / UX

Default columns:
- Provider;
- Contact / Team;
- Job title;
- Functional area;
- Region;
- Countries / markets;
- Email;
- Phone;
- Record type;
- Verification;
- Verified on;
- Source;
- Status.

Quick filters:
- Country;
- Provider;
- Record type;
- Active/Inactive/Deleted;
- First-party/Manual/Enriched/Imported source;
- Verification state;
- Has email;
- Has phone;
- freshness/staleness.

The grid must remain responsive and avoid document-level horizontal overflow. Dense desktop data may use an internal horizontal scroll owner while tablet/mobile progressively reduce visible columns and use the record drawer for detail.

## Role boundary

Import/export/create/edit/delete/restore is privileged PIM/Data Admin work. Exact rank must reuse current runtime authority and be verified before implementation.

Direct table access for browser roles remains prohibited.

## Privacy

A30 inherits A15:
- public professional information only for first-party capture;
- no LinkedIn HTML scraping;
- no personal-email/mobile reveal through licensed enrichment by default;
- source/provider terms must be respected;
- export does not turn Admin data into public publication.

## Consumer boundary

No automatic admission to:
- Search;
- public Website/Wix;
- Zoho;
- other external API consumers.

Consumer projection requires its own contract and approval.

## Acceptance

Permanent targeted UAT must cover:
- import parser;
- Provider mapping;
- duplicate/idempotency;
- create/edit/delete/restore;
- version/audit preservation;
- search/filter/sort/grid state;
- export;
- role/anonymous negatives;
- responsive desktop/tablet/mobile;
- A15 regression;
- no consumer publication change.

## Layer 4 parking rule

Imports must distinguish deterministic duplicates from judgement cases.

- exact repeated source/payload row → deterministic duplicate skip;
- non-identical duplicate candidate → Layer 4;
- Provider ambiguity → Layer 4;
- managed-manual versus incoming first-party conflict → Layer 4;
- provider-unmatched/invalid rows remain import validation/review failures unless separately promoted by a later rule.

Layer 4 parked rows do not block deterministic APPLY. The import batch uses applied_with_review_pending while linked Layer 4 items remain pending.

Provider Contact Layer 4 actions are domain-specific and must not reuse or weaken the generic course-scalar approval path. Accepted actions are merge existing, accept incoming, keep existing, keep separate, map Provider and apply, or reject import. All actions are auditable and preserve original Evidence/import rows.
