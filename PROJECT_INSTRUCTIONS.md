# CourseFinder Project Operating Instructions

**Status:** AUTHORITATIVE CROSS-CHAT OPERATING ENTRY POINT  
**Effective:** 26 August 2026  
**Applies to:** Every new or existing CourseFinder implementation, ingestion, enrichment, Admin/PIM, Search/API, Zoho, security, UAT and governance chat/workstream.

## Purpose

This file is the single starting instruction for parallel CourseFinder work. A chat must not assume that its own conversation history is the complete project state.

The GitHub Admin repository `msinghbs-ai/coursefinder-admin` is the authoritative project-governance source. Supabase/migrations and implementation repositories remain authoritative for deployed technical state, but governance decisions, project status, change traceability and operating rules must be reconciled here.

## Mandatory session start

Before making a material CourseFinder change, read/review the latest applicable versions of:

1. `PROJECT_INSTRUCTIONS.md` — this file.
2. For Milestone 2 work, `project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md`.
3. For Milestone 2 execution/testing, `project-runsheets/milestone-2/EXECUTION-ADDENDA-A1-A6.md`.
4. `change-control/README.md` — change-control routing and record rules.
5. `change-control/REGISTER.md` — active/recent change index and overlapping work.
6. Latest `docs/coursefinder-master-project-plan-*.md`.
7. Latest `docs/coursefinder-running-build-*.md`.
8. Latest accepted `docs/coursefinder-database-architecture-*.md`.
9. Latest Admin/PIM design-decision document when UI/PIM/field semantics are involved.
10. Relevant milestone/sub-milestone runsheets, UAT/source-qualification/design documents and overlapping Change Controls.

A chat should inspect implementation repositories and live Supabase state when the task depends on current deployed behaviour. Do not overwrite newer parallel work based on stale chat context.

For M2 work, task-specific prompts may narrow scope but must not remove the standing M2 authority/security/operations contract or A1–A6 execution discipline. Full deployed acceptance is a nominated checkpoint gate, not the default feedback loop for every intermediate change.

## Change-control trigger

Create or update a Change Control record when work materially changes, corrects or governs any of the following:

- canonical identity or field meaning;
- source authority, precedence, evidence or transformation;
- schema/table/RPC/API contract;
- ingestion/enrichment mapping or grain;
- Admin/PIM behaviour, labels, filters, ordering, cross-links or workflows;
- Search/publication/consumer behaviour;
- Zoho-facing field semantics or payload contract;
- security/permissions/platform behaviour;
- production/release/operational behaviour;
- a defect whose correction changes observable platform behaviour.

Minor spelling-only documentation edits do not require their own Change ID unless they correct field meaning or operating guidance.

## Change record ownership

- Use stable IDs: `CF-CHG-YYYYMMDD-NNN`.
- Record the exact originating chat/workstream and absolute initiation timestamp with timezone.
- Route the record to the category that owns the **primary semantic impact**, not merely the repository where code changed.
- Cross-reference secondary categories/surfaces inside the record instead of duplicating the same change record.
- The chat that initiates or materially advances the change is responsible for keeping that record current through APPLY/UAT/CLOSED or documenting handoff.
- Git commits and migrations are implementation evidence; they do not replace the Change Control record.

## Category routing

Use the category hierarchy documented in `change-control/README.md`:

- `00-governance-programme/`
- `10-architecture-data-model/`
- `20-layer1-regulatory-ingestion/`
- `30-admin-pim-ux/`
- `40-layer2-enrichment/`
- `50-search-api-consumers/`
- `60-zoho-integration/`
- `70-security-platform/`
- `80-uat-release-operations/`

If a change spans multiple categories, choose one primary owner and list the others under **Affected surfaces / Related workstreams**.

## Common CourseFinder design principles

All workstreams must preserve these principles unless an explicitly accepted architecture decision supersedes them:

- stable source identifiers before names;
- authoritative source/evidence/version preserved;
- Layer 2 enrichment must not redefine Layer 1 identity;
- source rows do not automatically become canonical/published data;
- Search, website and Zoho are derived/curated consumers, not identity authorities;
- do not manufacture missing source values;
- distinguish source-null, zero, suppressed, not-applicable and not-yet-enriched states;
- human Admin surfaces are decision tools, not raw-table viewers;
- use dense, filterable, sortable, resizable, cross-clickable decision grids where applicable;
- use shared searchable/typeable comboboxes for governed filters;
- expose source/evidence/verification/change context with minimum navigation;
- country display/filter conventions, currency semantics and other shared UI primitives should remain uniform across screens;
- visible UI version must correlate browser-facing changes;
- design for minimum routine workforce and maximum safe deterministic/agent automation;
- human review should focus on ambiguous identity, semantic conflicts, low-confidence mappings and consequential decisions.

## Field-semantics rule

Never flatten materially different concepts simply because they share a primitive type.

Examples:

- CRICOS `Tuition Fee`, `Non Tuition Fee` and `Estimated Total Course Cost` are different regulated fee concepts.
- A Provider-current annual tuition value is not the same semantic fact as a CRICOS registered total-course fee.
- Provider State/Region is not the same predicate as “Provider has a campus in this State”.
- `last_verified_at` is a verification signal, not automatically human approval.
- completeness is a quality/coverage signal, not truth.
- zero is not missing.
- title/name is not a stable identity key.

When uncertainty exists, preserve the source grain and evidence and open/change-control the semantic question rather than forcing a convenient mapping.

## Admin/PIM documentation obligation

When a field or workflow becomes sufficiently complex that an administrator could reasonably misinterpret it, update the maintained PIM Admin Guide with:

- business meaning;
- canonical table/field/API name;
- source authority and source vocabulary;
- grain/cardinality;
- nullable/zero/suppressed semantics;
- currency/year/audience/basis/scope where relevant;
- source/evidence relationship;
- verification/freshness meaning;
- Search/consumer relevance;
- Zoho-facing mapping where approved;
- what the Admin should validate against the source;
- common traps and invalid assumptions.

## Before implementation handover

A material change is not complete until the relevant record contains:

- actual implementation refs (migration/commit/issue/PR);
- semantic before/after;
- bounded UAT and result;
- security/ACL checks where relevant;
- visible UI version when applicable;
- rollback/reversion path;
- final status and closure timestamp, or a clearly named blocker/handoff owner.

Update the running-build/master-plan only when the programme status genuinely changes. Do not bump canonical architecture merely for a UI/read-contract change.

## Cross-chat operating expectation

When opening a new CourseFinder chat, the opening prompt should tell it to read this file first. Existing chats should also re-read it whenever their work becomes material, overlaps another workstream, or changes scope.

This file is intentionally concise enough to be read every session. Detailed rules belong in the referenced milestone/addenda/category/change/UAT/design documents.
