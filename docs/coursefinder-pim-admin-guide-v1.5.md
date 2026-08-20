# CourseFinder PIM Admin Guide v1.5

**Status:** LIVING GOVERNANCE GUIDE — STATE MODEL UPDATE  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-pim-admin-guide-v1.4.md`  
**Change Control:** `CF-CHG-20260820-001`, `008`, `009`, `010`, `011`, `012`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`

All unchanged v1.0-v1.4 rules remain in force. v1.5 formalises lifecycle, publication, Admin readiness, consumer-channel state and Search projection/admission as separate state classes.

## 1. Do not use one generic Status field

A Course may simultaneously be:

- canonical lifecycle `active`;
- canonical publication `unpublished`;
- 83.33% Admin canonical-presence ready;
- absent from all `publishing.entity_states` channel records;
- present in Search as a projected but `unpublished` document;
- canonically enriched with Fee/Intake/English while Search has not admitted those enrichments.

These states are not contradictory because they answer different questions.

Admin labels, filters, automation and consumer mappings must identify the state class explicitly.

## 2. Canonical lifecycle

**Primary meaning:** the operating/existence state of the canonical entity.

For Course, current storage is `catalogue.courses.lifecycle_status`.

Examples include `active`, `inactive`, `suspended` or another governed lifecycle value.

Rules:

- lifecycle does not grant publication;
- lifecycle does not imply completeness;
- lifecycle does not imply a Search document exists;
- `active + unpublished` is valid;
- downstream consumers must not reinterpret `active` as `published` or `available to students` without a separate publication/admission decision.

## 3. Canonical publication

**Primary meaning:** canonical entity publication state stored on the entity record.

For Course, current storage is `catalogue.courses.publication_status`.

Rules:

- this is distinct from lifecycle;
- this is distinct from per-channel `publishing.entity_states`;
- this is distinct from `search.course_documents.publication_status`;
- canonical `unpublished` does not prove a downstream Search document is absent;
- canonical publication must not be inferred from completeness/readiness.

Admin should label this **Canonical publication** where ambiguity is possible.

## 4. Admin canonical-presence readiness

Current Course Admin readiness is a display/operational measure across six canonical signals:

1. registration;
2. structure;
3. fee;
4. intake;
5. English;
6. description.

It is explicitly:

**display-only six-signal canonical presence readiness; not truth, approval, freshness or publication.**

Rules:

- use **Admin readiness**, **Canonical presence readiness** or similarly qualified wording;
- avoid generic `Complete`, `Completeness` or `Ready` when the meaning is not shown;
- a missing signal must not be manufactured merely to improve score;
- 100% does not grant publication;
- less than 100% does not necessarily make the Course false/invalid;
- Search flags must never be used as the source of canonical presence signals.

## 5. Consumer-channel publication state

**Primary storage:** `publishing.entity_states` with `publishing.channels`.

This is the channel/locale-specific publication state for a canonical entity.

Important dimensions include:

- channel code/name;
- audience;
- locale;
- channel publication status;
- published/unpublished timestamps;
- channel completeness score where governed;
- last checked/updated timestamps.

### Empty-state semantics

If no `publishing.entity_states` row exists:

**No consumer-channel publication state is recorded.**

Do not coerce that absence to:

- published;
- unpublished;
- rejected;
- incomplete;
- approved;
- blocked.

An empty relationship is an empty relationship until a channel-state record exists.

## 6. Search projection presence

**Primary storage:** `search.course_documents`.

`search_projected=true` means a derived Search Course Document exists for that canonical Course.

It does **not** mean:

- Website published;
- Zoho published;
- Search result publicly visible;
- canonically approved;
- all canonical enrichment admitted.

The Search document has its own `publication_status` and operational metadata.

Admin labels should include **Search** or **Search projection** so it cannot be mistaken for canonical publication.

## 7. Search enrichment admission

Search enrichment flags such as:

- `has_fee`;
- `has_intake`;
- `has_english`;
- `has_scholarship`

state what the current Search document/projector admitted.

They do not answer whether those observations exist canonically.

### Reference — 102784C

At the governed audit:

Canonical/Admin signals:

- fee present: true;
- intake present: true;
- English present: true.

Search document:

- fee admitted: false;
- intake admitted: false;
- English admitted: false.

This is valid because Search enrichment has its own explicit admission gate.

## 8. Global Search projection state

`search.projection_state` is operational metadata for the projection as a whole.

At the v2.9 state audit, Course Search state was:

- projection code: `courses`;
- generation: 12;
- row count: 33,105;
- projection version: `course-v2`;
- enrichment gate: `explicit`;
- Fee/Intake/English/Scholarship admitted coverage: 0.

This is useful for diagnosing projection freshness/synchronisation. It is not canonical Course truth or publication authority.

## 9. Admin state presentation

### Course grid

Recommended decision-grid fields:

- Lifecycle;
- Canonical publication;
- Admin readiness;
- Search projection state.

Do not display four different state concepts under ambiguous headings such as `Status`, `Complete` or `Published`.

### Course detail

The **State & publication** panel should explain:

- canonical lifecycle;
- canonical publication;
- Admin readiness and signals;
- channel publication records or explicit absence;
- Search projection presence/status;
- canonical-vs-Search enrichment admission;
- projection version/generation/freshness metadata.

## 10. Automation/change signals

Automation may signal:

- Search out of sync;
- canonical state changed;
- channel state changed;
- Search projection changed;
- enrichment exists canonically but is not admitted to Search;
- stale projection generation.

Automation must not auto-publish merely because readiness improved or Search projection exists.

## 11. `last_verified_at` remains separate

Verification/freshness metadata is not a sixth status system to merge into approval.

`last_verified_at` answers when the fact/entity was rechecked under its governed process. It does not mean:

- approved;
- published;
- Search-synchronised;
- complete.

## 12. Reference state examples

### CRICOS 121174E

At the v2.9 audit:

- Lifecycle: Active;
- Canonical publication: Unpublished;
- Admin readiness: 50.00%;
- Channel publication records: none;
- Search projected: Yes;
- Search publication: Unpublished;
- canonical fee present: Yes;
- Search fee admitted: No.

### CRICOS 102784C

At the v2.9 audit:

- Lifecycle: Active;
- Canonical publication: Unpublished;
- Admin readiness: 83.33%;
- Channel publication records: none;
- Search projected: Yes;
- Search publication: Unpublished;
- canonical Fee/Intake/English: present/present/present;
- Search Fee/Intake/English: not admitted/not admitted/not admitted.

These examples are maintained because they demonstrate valid mixed-state combinations rather than idealised all-green records.
