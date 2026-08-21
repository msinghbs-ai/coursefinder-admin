# CourseFinder PIM Admin Guide v1.11

**UI candidate:** PIM Admin v2.12 + Pipeline Ops v1.0 + Evidence v1.0  
**Effective:** 21 August 2026  
**Status:** **CANDIDATE — M1-EVIDENCE-UX AUTHENTICATED BROWSER GATE BLOCKED**  
**Retains:** `docs/coursefinder-pim-admin-guide-v1.10.md`

## 1. Purpose

This candidate guide extends the accepted PIM Admin Guide v1.10 with the dedicated Evidence, Provenance & Change-History workspace governed by `CF-CHG-20260821-017`.

Until the authenticated browser gate closes PASS, v1.10 remains the accepted production operating guide. All v1.10 Pipeline Ops, PIM semantics, role boundaries and security rules remain in force.

## 2. Role boundary

The browser read path remains:

`Supabase Auth → public.admin_read(text,jsonb) → server-side role/rank check → governed internal read`

| Area | Minimum role |
|---|---|
| Overview / Catalogue / Insights / Scholarships | assigned CourseFinder role |
| Review Queue / Evidence | Curator, rank 3 |
| Pipeline Control / Jobs / Sources | Pipeline Operator, rank 4 |
| PIM Configuration | PIM Admin, rank 5 |
| privileged mutations | explicit governed server action only |

Menu visibility is not the security boundary. A manual browser/RPC call below the required role must still fail server-side.

## 3. Evidence operating model

Evidence is a first-class cross-layer operational capability, not a file list.

Read lineage as:

`Source → Acquisition Job → Evidence Artifact/Snapshot → Observation/Claim → Canonical Entity/Field → Review/Decision → Search/Publication consequence`

Do not collapse these nodes into one authority state.

- Layer 1 Evidence may support regulatory identity/facts only within the source's governed authority.
- Layer 2 observations are deterministic/structured enrichment and must not redefine Layer 1 identity.
- Layer 3 claims/suggestions are non-authoritative until governed review/admission.
- Layer 4 decisions are auditable human resolution; they do not rewrite historical source evidence.
- Search/publication fields shown from Evidence are current downstream context unless a separate governed record proves a causal admission/publication transition.

## 4. Evidence list and filters

The candidate workspace supports:

- country;
- source;
- layer;
- entity type;
- canonical entity UUID;
- Provider scope;
- acquisition job UUID/status;
- evidence type;
- MIME type;
- verification date range;
- freshness;
- content hash prefix;
- operational status;
- extraction state;
- unresolved-conflict state.

The list should expose enough information to answer: what source produced this artifact, through which job/layer, when it was acquired, whether extraction occurred, whether it is current/stale/conflicting, and whether the private object exists.

## 5. Evidence detail

Evidence detail may display governed metadata and relationships including:

- source authority/public URL;
- acquisition/capture timestamp;
- content hash;
- snapshot/version and explicit validity window;
- safe storage metadata such as object availability, MIME, size and timestamps;
- associated job;
- extracted observations where operationally bounded;
- affected Provider/Course/Campus/Scholarship entities;
- current versus source-null/rejected/superseded observation state;
- verification state;
- linked Change Control identifiers;
- claims/review cases/actions when persisted;
- current Search/publication context.

Valid empty states must remain explicit. Do not manufacture claims, review decisions, conflicts, supersession or Change Control links merely to make the workspace appear populated.

## 6. Value-state distinctions

| State | Meaning |
|---|---|
| `source_null` | Source/observation explicitly contains no usable value. |
| `missing_extraction` | Evidence exists but no governed canonical observation was extracted/materialised. |
| `stale` | Evidence is outside the governed freshness expectation or explicitly stale. |
| `conflict` | Competing evidence/claim/review state is unresolved. |
| `rejected` | A value/claim was explicitly rejected and its audit history must remain. |
| `superseded` | A newer governed observation/artifact replaces prior current use without deleting history. |
| `current` | Current retained value within its governed source/scope. |

Zero is a real value when the source supplied zero; zero must never be converted to source-null.

## 7. Canonical ↔ Evidence navigation

Bidirectional traceability is required.

From Provider/Course/Campus/Scholarship detail, the Evidence action scopes the Evidence workspace to that canonical entity.

From Course value structures, a row carrying a governed `evidence_id` may open the exact supporting artifact. This applies to registered/current fees and may also apply to intake/English/other nested observations where the identifier is persisted.

From Evidence, affected canonical entities can be opened directly in their catalogue detail workspace.

Operators should prefer these governed links over ad-hoc internal database queries.

## 8. High-volume snapshots

National snapshots can contain tens of thousands of observations. The live AU regulatory corpus contains an Evidence artifact with **103,315** observations.

Operational rule:

- up to 500 observations: inline bounded observation loading is permitted;
- above 500 observations: do not automatically invoke bulk observation expansion;
- retain the governed observation count;
- load bounded affected-entity lineage;
- drill through the canonical entity/value for exact context.

Current live performance after the Pipeline Ops entity-impact optimisation:

- Evidence page 50 rows, warm: ~55.7 ms;
- high-volume detail: ~181.0 ms;
- first 100 entity links for the 103,315-observation artifact: ~459.1 ms;
- entity-link query temp spill: 0 blocks.

A cold Evidence-list execution of ~3.64 seconds was observed before buffers warmed; it is retained as cold-start evidence and the UI must show loading state rather than blank content.

## 9. Private object preview/download

Evidence Storage remains private.

The browser must not receive a raw private object path as an access mechanism, service-role credentials, passwords, API keys, tokens or a generic public bucket URL.

Candidate access flow:

1. authorised browser submits Evidence UUID + preview/download mode;
2. `admin-evidence-access` requires a valid JWT;
3. CourseFinder role rank is rechecked and must be 3+;
4. service-role credentials resolve the private object only server-side;
5. permitted access receives a signed URL with a 60-second expiry;
6. raw storage path is not returned as the browser access contract.

Unsupported preview MIME types should remain unavailable rather than being coerced into unsafe inline rendering.

## 10. Pipeline Ops coexistence

Pipeline Ops v1.0 remains accepted and must coexist with Evidence v1.0.

The reconciled candidate retains:

- Pipeline Ops launcher/runtime entry point;
- Layer 1–4 Pipeline Control/Jobs/Sources semantics;
- rank-4 Pipeline Operator boundary;
- final paged Evidence entity-impact optimisation;
- no generic Retry Everything / Replay Everything / Reset Everything mutation.

Evidence changes must not remove or replace those accepted capabilities.

## 11. Security interpretation

Expected architecture remains:

- `public.admin_read` SECURITY INVOKER;
- browser roles do not gain direct internal-schema CRUD;
- private Evidence tables/Storage remain default-deny/server-mediated;
- legacy browser-executable SECURITY DEFINER helpers are not reopened;
- rank-3 Curator is sufficient for Evidence but insufficient for rank-4 Pipeline Operations;
- platform-wide Auth leaked-password-protection warning remains a separate security backlog item and is not an Evidence boundary justification.

## 12. Release state

Candidate Pilot branch:

`m1-evidence-ux-operational-workspace`

Candidate PR:

`msinghbs-ai/Coursefinder-Pilot#14`

Reconciled candidate head:

`ab682a561a3121c1ca51c0fd3d9b427c539eb049`

Build run #97 and Cloudflare branch-preview deployment are PASS. Server role/security/performance checks are PASS.

The remaining blocker is authenticated interactive browser acceptance against the preview/deployed runtime. Until that closes, this v1.11 guide is a candidate extension and v1.10 remains production-authoritative.
