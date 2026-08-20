# CourseFinder Zoho Consumer Contract v1.3

**Status:** GOVERNED CURATED CONTRACT — STATE MODEL EXTENSION  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-zoho-consumer-contract-v1.2.md`  
**Change Control:** `CF-CHG-20260820-001`, `008`, `009`, `011`, `012`  
**Scope:** semantic mapping contract only; no Website/Zoho/Search publication admission is implied.

All unchanged Provider/Course/Fee/Campus/Intake/English/Scholarship/QILT/PRISMS rules from v1.0-v1.2 remain in force. v1.3 prevents lifecycle, publication, readiness and Search operations from collapsing into one consumer `Status` field.

## 1. No generic multi-authority Status field

Zoho must not derive one field such as `Status`, `Published`, `Ready` or `Active` from several independent CourseFinder state systems.

Where admitted, use distinct names with distinct authorities.

## 2. Course state fields

| API name | Zoho label | Type | Class | Consumer meaning |
|---|---|---|---|---|
| `lifecycle_status` | Lifecycle Status | string | canonical | canonical entity lifecycle only |
| `publication_status` | Canonical Publication | string | canonical publication | canonical publication state; not channel/Search state |
| `channel_publication` | Channel Publication | object[] | channel publication | optional repeating channel/locale state when explicitly admitted |
| `admin_readiness` | Admin Readiness | object | internal/diagnostic | optional namespaced operational diagnostic only |
| `search_projection` | Search Projection | object | internal/diagnostic | optional namespaced Search operational state only |
| `last_verified_at` | Last Verified | datetime | governance | verification timestamp, not approval/publication |

## 3. Canonical lifecycle

`lifecycle_status` is safe for business use only with its canonical meaning.

Do not convert:

- `active` → published;
- `inactive` → deleted;
- `active` → available on Website;
- `active` → Search-visible.

Any consumer-specific availability decision requires its own governed rule.

## 4. Canonical publication

`publication_status` means the canonical entity publication state.

It is not interchangeable with:

- `publishing.entity_states.publication_status` for a specific channel;
- `search.course_documents.publication_status`;
- Admin readiness;
- Search projection presence.

If Zoho requires its own publication state, that state should be defined through a Zoho-specific consumer admission/channel contract rather than copied from whichever internal state appears convenient.

## 5. Channel publication object

If channel-specific publication is admitted, expose repeating objects such as:

| API name | Type | Notes |
|---|---|---|
| `channel_code` | string | stable consumer channel identity |
| `channel_name` | string | display label |
| `locale` | string | channel locale |
| `audience` | string | governed channel audience |
| `publication_status` | string | channel-specific state only |
| `published_at` | datetime | nullable |
| `unpublished_at` | datetime | nullable |
| `completeness_score` | decimal | channel-specific diagnostic if governed/admitted |
| `last_checked_at` | datetime | operational timestamp |

### Empty list semantics

`channel_publication=[]` means:

**no channel publication state has been recorded/admitted for this payload.**

It must not be interpreted as `unpublished`, `published`, `rejected`, `blocked` or incomplete.

## 6. Admin readiness object

Admin readiness should normally remain an internal diagnostic rather than a core Zoho business field.

If there is a genuine operational requirement to expose it, namespace it explicitly:

```text
admin_readiness.score
admin_readiness.registration_present
admin_readiness.structure_present
admin_readiness.fee_present
admin_readiness.intake_present
admin_readiness.english_present
admin_readiness.description_present
```

Contract statement:

**Admin readiness is display-only canonical presence; it is not truth, approval, freshness or publication.**

Zoho workflow must never auto-publish or auto-approve solely because `admin_readiness.score=100`.

## 7. Search projection object

Search state is an internal/operational diagnostic and should not be the authority for Zoho publication.

If exposed for integration monitoring, use a separate namespaced object:

| API name | Type | Meaning |
|---|---|---|
| `projected` | boolean | a Search Course Document exists |
| `publication_status` | string | Search document publication state only |
| `projection_version` | string | Search projection contract version |
| `catalogue_generation` | integer | projection generation |
| `generated_at` | datetime | Search generation timestamp |
| `updated_at` | datetime | Search document update timestamp |
| `fee_admitted` | boolean | Fee is present in Search projection |
| `intake_admitted` | boolean | Intake is present in Search projection |
| `english_admitted` | boolean | English requirement is present in Search projection |
| `scholarship_admitted` | boolean | Scholarship relationship is present in Search projection |

### Critical rule

`search_projection.projected=true` does **not** mean:

- Zoho published;
- Website published;
- Search publicly visible;
- canonical approved;
- all canonical enrichment admitted.

## 8. Canonical presence versus Search admission

Zoho integrations must not use Search flags as a proxy for canonical presence.

Reference `102784C` at the governed audit:

- canonical Fee present = true;
- canonical Intake present = true;
- canonical English present = true;
- Search Fee admitted = false;
- Search Intake admitted = false;
- Search English admitted = false.

This is intentional under the explicit Search enrichment gate.

If Zoho receives Provider-current Fee/Intake/English in a future consumer admission, it must consume them from the governed curated canonical contract, not infer them from Search flags.

## 9. Search global projection metadata

Global Search projection generation/row-count/hash is useful for integration reconciliation but is not normally part of each business Course object.

If Zoho integration monitoring needs it, expose it through a separate operational endpoint/job manifest, not as Course business state.

## 10. Reference mixed-state combinations

Valid Course state can include:

```text
lifecycle_status = active
publication_status = unpublished
admin_readiness.score = 83.33
channel_publication = []
search_projection.projected = true
search_projection.publication_status = unpublished
search_projection.fee_admitted = false
```

Consumers must tolerate this combination without treating it as contradictory or coercing all fields into one status.

## 11. Admission boundary

v1.3 defines state meaning only.

Before any state class is admitted to Zoho, confirm:

- the business reason for exposing it;
- the authoritative source/classification;
- empty/NULL semantics;
- whether it is business state or operational diagnostics;
- workflow behaviour does not infer publication/approval incorrectly;
- backward-compatible versioning is defined.

Search operational state and Admin readiness should default to **not exposed** unless an integration-monitoring use case explicitly requires them.
