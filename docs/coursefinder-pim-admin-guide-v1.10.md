# CourseFinder PIM Admin Guide v1.10

**UI:** PIM Admin v2.11.0 + Pipeline Ops v1.0 accepted  
**Effective:** 21 August 2026  
**Status:** **CURRENT ADMIN OPERATING GUIDE — M1-PIPELINE-OPS PASS**  
**Supersedes:** `docs/coursefinder-pim-admin-guide-v1.9.md`

## 1. Purpose

This guide retains all accepted PIM v2.11 field/business semantics and adds the accepted Pipeline Operations operating model from `CF-CHG-20260821-016`.

Authoritative Pipeline Ops UAT:

`docs/uat/coursefinder-m1-pipeline-ops-technical-acceptance-2026-08-21.md`

## 2. Browser and role boundary

Supported browser reads remain:

`Supabase Auth → public.admin_read(text,jsonb) → server-side role/rank check → governed internal read`

Rules:

- `public.admin_read` is SECURITY INVOKER;
- authenticated execution is permitted; anon execution is denied;
- normal browser CRUD against internal schemas is not supported;
- legacy authenticated `public.ui_*` SECURITY DEFINER access is not reopened;
- menu visibility is not a security boundary.

| Area | Minimum role |
|---|---|
| Overview / Catalogue / Insights / Scholarships | assigned CourseFinder role |
| Review Queue / Evidence | Curator, rank 3 |
| Pipeline Control / Jobs / Sources | Pipeline Operator, rank 4 |
| PIM Configuration | PIM Admin, rank 5 |
| privileged runtime mutations | explicit governed server action only |

## 3. Current Admin release

Accepted source:

`msinghbs-ai/Coursefinder-Pilot@848e302b19186cb0a751f74f23f06a244c5b0b2d`

Visible marker:

`PIM Admin v2.11 · Pipeline Ops v1.0 · governed`

The Pipeline Ops capability is isolated from the accepted v2.11 shell and upgrades existing Jobs/Sources navigation for rank-4+ users.

## 4. Pipeline Operations operating model

Admins must read the pipeline in this order:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

Do not collapse these stages into one generic success/failure state.

### Layer 1 — Regulatory

Business meaning: authoritative regulatory/identity acquisition where the approved source owns that fact or identity.

Admin checks:

- source/authority and configured adapter scope;
- last successful run/current job;
- dry-run versus APPLY;
- batch cursor and source/scope completion;
- accepted/rejected/conflict counts;
- Evidence retained for the run;
- blocker before replay.

A completed batch is not automatically a completed country/source.

### Layer 2 — Deterministic / Structured Enrichment

Business meaning: structured non-identity enrichment linked to governed canonical entities.

Rules:

- must not redefine Layer 1 identity;
- deterministic rejection/source validation is not the same as a technical parser/runtime failure;
- blocked source coverage remains visible rather than converted into fabricated facts;
- source/evidence/version and enrichment grain remain authoritative.

### Layer 3 — AI Suggestions

Business meaning: AI/model output is a suggestion/claim surface, not canonical authority.

Rules:

- Layer 3 must not silently overwrite Layer 1/2 facts;
- no Suggestions means the layer is not operational; do not infer hidden AI work;
- AI output requires governed review/admission before consequential canonical use.

### Layer 4 — Human Resolution

Business meaning: auditable human resolution of ambiguity/conflict/review work.

Rules:

- decisions must be represented through governed review actions/history;
- direct unlogged canonical overwrite is not a valid Layer 4 decision;
- reviewer identity, reason, evidence and before/after context must remain traceable where applicable.

### Search Admission

Search is a governed derived projection. Successful ingestion/enrichment does not imply Search admission.

Admins should inspect country/enrichment gates independently from Pipeline Job status.

### Publication

Publication is downstream channel state. It is not equivalent to canonical readiness, Search projection or ingestion success.

## 5. Pipeline Control screen

Each layer card should be interpreted using:

- **Sources/configuration** — governed source inventory, not a secrets/config dump;
- **Last successful run** — most recent completed operational run for that layer;
- **Current job** — current running job if present;
- **Evidence** — associated Evidence count; Evidence remains private provenance;
- **Records** — discovered/selected/processed/accepted/rejected when persisted;
- **Changes** — creates/updates/unchanged/conflicts when persisted;
- **Ambiguity** — review-required ambiguity, separate from technical failure;
- **Duration** — runtime duration, not proof of completeness;
- **Resume cursor** — persisted offset/next cursor/has-more state;
- **Blocker** — reason another run/replay should not proceed blindly;
- **Next allowed action** — governed operational guidance, not an automatic mutation;
- **CC/UAT reference** — console acceptance reference plus run-level reference if the adapter persisted one.

If a run predates CC/UAT persistence, `Not persisted` is valid; do not manufacture a reference.

## 6. Jobs workspace

Jobs are server-paged at bounded page size and may be filtered by layer, status, mode, country, job type, completion class and failure class.

Important distinctions:

- `DRY_RUN` means no governed apply was requested by that run mode;
- `APPLY` identifies an applying run; it does not by itself prove Search or Publication success;
- `partial_batch` means more source scope remains;
- `source_or_scope_complete` means the adapter explicitly reports no more scope for that cursor/run;
- `completed_scope_unknown` means the historic run completed but did not persist enough cursor semantics to claim whole-source completion;
- `governed_blocker` is not a parser crash;
- `source_validation` is not automatically a technical runtime defect;
- `ambiguity_count` is human-review ambiguity, not parser failure.

Expand a job to inspect error text, source, run semantics, direct entity/provider scope and Evidence.

## 7. Job → Evidence → entity impact

Evidence navigation is read-only and retains the Evidence security boundary.

The impact view may show:

- affected canonical entity;
- Provider context;
- current canonical publication state;
- whether a Course is currently projected into Search;
- current Search publication state;
- downstream publishing-channel state where available.

These downstream states are current related state. Do not assert they were caused by that Evidence unless a separate governed admission/publication record proves the causal transition.

## 8. Sources workspace

Rank-4 Sources shows operationally safe source information:

- label/type/country;
- status/trust rank;
- last success/failure/check;
- freshness/health;
- running/problem jobs;
- Evidence count;
- Provider scope where applicable;
- selected non-secret configuration such as worker/scope/coverage role/identity scheme/transport.

Do not expose scraper credentials, tokens, hidden headers or private adapter secrets to normal browser payloads.

## 9. Retry, replay and reset rule

There is no generic Retry Everything, Replay Everything or Reset Everything action in the accepted Pipeline Ops console.

Current generic retry/replay/reset controls remain disabled because safe execution depends on the owning adapter and run semantics.

A future mutation requires, at minimum:

- explicit server-side action contract and role check;
- exact source/country/entity/batch scope;
- preserved Evidence/hash where replay depends on source snapshot;
- deterministic idempotency or documented replay semantics;
- typed/explicit confirmation for destructive action;
- audit/change-history entry;
- busy/double-click protection;
- bounded retry/error handling and rollback path.

The former generic whole-Pilot Reset Database card is not part of the promoted Admin surface. Existing Layer 1 bounded APPLY/continue/idempotency controls remain separate because they carry explicit country, offset, batch and confirmation semantics.

## 10. Retained PIM semantic rules

The v1.9 and earlier accepted rules remain in force, including:

- stable source identifiers before names;
- CRICOS registered total-course costs are distinct from Provider-current fees;
- zero is not missing;
- Provider State/Region is not the same predicate as campus presence in a State;
- completeness is a coverage/quality signal, not truth;
- `last_verified_at` is not automatically human approval;
- Evidence is provenance, not a public file list;
- Search and Publication are derived/curated consumers, not identity authorities.

Reference Course `121174E` remains a regression case for CRICOS fee semantics.

## 11. Current operational caveats

At Pipeline Ops acceptance the live system correctly reports:

- one stale Layer 1 running job requiring investigation before replay;
- Layer 2 blocked job state requiring blocker resolution;
- Layer 3 no current Suggestions;
- Layer 4 no current Review Queue/Actions;
- 33,105 Search Course Documents with four enrichment gates still blocked.

These conditions are operational work to resolve in their owning workstreams. Admins must not bypass them with generic replay/reset.
