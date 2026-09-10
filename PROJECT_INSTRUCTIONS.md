# CourseFinder Project Operating Instructions

**Status:** AUTHORITATIVE CROSS-CHAT OPERATING ENTRY POINT  
**Effective:** 7 September 2026  
**Strengthened:** 10 September 2026  
**Applies to:** Every new or existing CourseFinder implementation, ingestion, enrichment, Admin/PIM, Search/API, Zoho, security, UAT and governance chat/workstream.

## Purpose

This file is the single starting instruction for parallel CourseFinder work. A chat must not assume that its own conversation history is the complete project state.

The GitHub Admin repository `msinghbs-ai/coursefinder-admin` is the authoritative project-governance source. Supabase/migrations and implementation repositories remain authoritative for deployed technical state, but governance decisions, project status, change traceability and operating rules must be reconciled here.

The implementation repository is `msinghbs-ai/Coursefinder-Pilot`. Every material chat must reconcile Admin governance with current Pilot implementation, recent commits/PRs, applicable CI/UAT and deployed runtime before deciding current state or making a change.

Repository, CI and deployed runtime truth take precedence over stale chat or continuity text. If governance documentation is behind implementation, reconcile and update it rather than reverting newer work.

## Current-document and PIM principle gate

Before selecting any versioned governance/design document, read:

- `docs/README.md` — authoritative current-document router; do not infer “latest” from filename ordering.
- `docs/01-governance/coursefinder-pim-operating-principles-v1.0.md` — standing Admin/PIM chat lifecycle, work-item, UI/UX, Settings, end-to-end wiring, UAT and handoff principles.
- `docs/01-governance/coursefinder-troubleshooting-bugfix-recovery-protocol-v1.0.md` — mandatory whenever the task is a bug, failed UAT, regression, runtime incident, large corrective change or recovery/troubleshooting continuation.

Do not infer the current document from filename/version ordering. Follow the document family marked current by `docs/README.md`.

## Mandatory session start

Before making a material CourseFinder change, read/review the latest applicable versions of:

1. `PROJECT_INSTRUCTIONS.md` — this file.
2. `docs/README.md` — current-document router.
3. For Milestone 2 work, `project-runsheets/milestone-2/STANDING-INSTRUCTIONS.md`.
4. For Milestone 2 execution/testing, `project-runsheets/milestone-2/EXECUTION-ADDENDA-A1-A6.md` plus all task-applicable accepted Execution Addenda named by the Standing Instructions.
5. `change-control/README.md` — change-control routing and record rules.
6. `change-control/REGISTER.md` — active/recent change index and overlapping work.
7. The current Master Project Plan selected by `docs/README.md`.
8. The current Running Build selected by `docs/README.md`.
9. The current accepted Database Architecture selected by `docs/README.md`.
10. Current Admin/PIM design/architecture documents selected by `docs/README.md` when UI/PIM/field semantics are involved.
11. Relevant milestone/sub-milestone runsheets, UAT/source-qualification/design documents and overlapping Change Controls.
12. The active milestone/sub-milestone `RUNSHEET.md`, `CURRENT-STATE.md`, `FOLLOW-UPS.md` and `NEXT-CHAT.md` where present.
13. For any bug, failed UAT, regression, runtime incident, troubleshooting or recovery work, `docs/01-governance/coursefinder-troubleshooting-bugfix-recovery-protocol-v1.0.md`.

A chat should inspect implementation repositories and live Supabase/runtime state when the task depends on current deployed behaviour. Do not overwrite newer parallel work based on stale chat context.

For M2 work, task-specific prompts may narrow scope but must not remove the standing M2 authority/security/operations contract or applicable Execution Addenda discipline. Full deployed acceptance is a nominated checkpoint gate, not the default feedback loop for every intermediate change.

## Automatic cross-repository reconciliation

Before reporting status, choosing a baseline or making a material change, determine automatically where tooling permits:

- current milestone/sub-milestone;
- accepted baseline;
- current Admin and Pilot repository heads;
- recent relevant commits and merged/open PRs;
- current implementation state;
- deployed Supabase/Cloudflare/runtime state where applicable;
- current visible application release/version where applicable;
- exact applicable CI/UAT state and run identifiers;
- open Change Controls and overlapping workstreams;
- blockers, risks, technical debt and durable follow-ups;
- applicable security state;
- exact next governed gate.

Use repository/runtime evidence in preference to chat memory. Continuity files are durable handover aids, not a substitute for verifying newer implementation/runtime truth.

If a continuity or governance document is stale relative to accepted implementation/runtime truth, update/reconcile the document. Do not roll back newer valid work simply to make an older document true.

Do not ask the user to restate project history, architecture, previous decisions, milestone status, repository locations, open follow-ups or next steps when the governed repositories/runtime already contain that information.

## Project status reporting

When asked to review, continue, report status, identify what is next or provide a project update, determine and report at minimum:

- overall phase and active sub-milestone;
- accepted baseline and current implementation/deployed head;
- current visible release where applicable;
- material completed gates since the accepted checkpoint;
- active workstreams;
- open Change Controls;
- blockers, risks, technical debt and follow-ups;
- database/architecture changes only where they genuinely changed;
- runtime/deployment changes;
- security/UAT state;
- exact next gate/action.

Distinguish historical checkpoints from current truth. If governance and implementation disagree, explicitly reconcile the discrepancy.

## Bug / troubleshooting / recovery gate

A corrective chat must not start from chat memory alone. Before changing implementation it must reconcile:

- the exact failing/passing CI/UAT run and intended suite routing;
- current implementation repository head(s);
- current deployed Supabase/runtime/configuration state;
- current visible version/release authority;
- owning Change Control and active milestone continuity files;
- whether the failure is implementation, data, UAT-contract, deployment/currentness, environment/configuration, governance drift or mixed.

Use the recovery sequence defined in `docs/01-governance/coursefinder-troubleshooting-bugfix-recovery-protocol-v1.0.md`: evidence first, smallest safe fix, targeted validation, bounded integration where needed, then one nominated broader acceptance. Never weaken a correct authority/security/data rule merely to make a test pass. Never promote a browser-visible release while its required functional gate is red, cancelled or unrun.

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

Preserve the standing authority chain:

`Layer 1 Regulatory / Authoritative → Layer 2 Deterministic Enrichment → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution → governed Search / Publication / consumer boundary`.

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

## Security-first rule

Security remains a primary acceptance gate. Preserve correct security, identity, evidence and data-authority boundaries even when doing so exposes an implementation or UAT failure.

Where relevant reconcile browser-executable routes, SECURITY DEFINER functions, grants, RLS, exposed schemas/views, role/rank enforcement, private helpers/tables, Edge/server authentication, Storage/Evidence access, Vault/provider secrets and rollback/restore impact.

Do not expose service-role keys, database credentials, provider secrets or private Evidence to browser/client code. Do not weaken a correct security or authority rule merely to obtain a PASS.

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

## Continuity and handover obligation

During substantial work maintain the active milestone/sub-milestone continuity files as applicable:

- `RUNSHEET.md` — gates, sequence, acceptance and completion state;
- `CURRENT-STATE.md` — current factual implementation/deployment/release/UAT state;
- `FOLLOW-UPS.md` — unresolved durable issues, risks, evidence, owner and exact next action;
- `NEXT-CHAT.md` — exact continuation point, repository heads, pending workflows/blockers and first next action.

Do not turn continuity files into chat transcripts. Keep them factual, current and useful to the next chat.

Update the Master Project Plan, Running Build, database architecture, Admin/PIM design documents, guides, runbooks and release/version history only when the corresponding governed state actually changes.

Before ending substantial work, reconcile Change Control and continuity state so another chat can continue without requiring the user to restate project history.

## Before implementation handover

A material change is not complete until the relevant record contains:

- actual implementation refs (migration/commit/issue/PR);
- semantic before/after;
- bounded UAT and result;
- security/ACL checks where relevant;
- visible UI version when applicable;
- rollback/reversion path;
- final status and closure timestamp, or a clearly named blocker/handoff owner.

For troubleshooting/recovery work, handover must additionally include defect classification/root cause, exact failed and passing run IDs, OPEN/CLOSED recovery gates, deployed/runtime state, and the exact next targeted action.

Update the Running Build/Master Project Plan only when programme status genuinely changes. Do not bump canonical architecture merely for a UI/read-contract change.

## Cross-chat operating expectation

Every new CourseFinder chat inherits this file as the cross-chat operating entry point. The user should only need to provide the task; the chat must discover and reconcile the common project context from the governed repositories/runtime.

Existing chats should also re-read it whenever their work becomes material, overlaps another workstream, or changes scope.

For a bug/troubleshooting/recovery continuation, the chat must also follow `docs/01-governance/coursefinder-troubleshooting-bugfix-recovery-protocol-v1.0.md` and reconcile current repo/runtime/UAT truth before any fix.

This file is intentionally concise enough to be read every session. Detailed rules belong in the referenced milestone/addenda/category/change/UAT/design documents.
