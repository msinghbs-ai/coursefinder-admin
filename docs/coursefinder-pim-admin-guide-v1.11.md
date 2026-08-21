# CourseFinder PIM Admin Guide v1.11

**UI:** PIM Admin v2.12 + Pipeline Ops v1.0 + Evidence v1.0  
**Effective:** 21 August 2026  
**Status:** **CURRENT ADMIN OPERATING GUIDE — M1-EVIDENCE-UX CLOSED / PASS**  
**Supersedes:** `docs/coursefinder-pim-admin-guide-v1.10.md`

## 1. Purpose

This guide extends the accepted Pipeline Ops/PIM operating model with the dedicated Evidence, Provenance & Change-History workspace governed by `CF-CHG-20260821-017`.

Evidence is a first-class Admin capability spanning Layer 1–4. It is not a generic file browser and it does not collapse source, extraction, review and publication authority into one state.

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

Menu visibility is not the security boundary. A manual browser/RPC call below the required rank must still fail server-side.

## 3. Evidence operating model

Read Evidence lineage as:

`Source → Acquisition Job → Evidence Artifact/Snapshot → Observation/Claim → Canonical Entity/Field → Review/Decision → Search/Publication consequence`

Interpret each node separately:

- **Layer 1** Evidence may support regulatory identity/facts only within that source's governed authority;
- **Layer 2** observations are deterministic/structured enrichment and must not redefine Layer 1 identity;
- **Layer 3** claims/suggestions are non-authoritative until governed review/admission;
- **Layer 4** decisions are auditable human resolution and do not rewrite historical source Evidence;
- Search/publication fields shown from Evidence are current downstream context unless a separate governed record proves a causal admission/publication transition.

## 4. Evidence list and filters

The accepted workspace supports:

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

Country and Source are context-aware. Selecting a Country constrains Source options to that Country; changing Country clears an incompatible selected Source; clearing Country restores the complete Source set.

The list should answer: what source produced the artifact, through which job/layer, when it was acquired, whether extraction occurred, whether it is current/stale/conflicting, and whether the private object exists.

## 5. Evidence detail

Evidence detail may display governed metadata and relationships including:

- source authority/public URL;
- acquisition/capture timestamp;
- content hash;
- snapshot/version and explicit validity window;
- safe Storage metadata such as object availability, MIME, size and timestamps;
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
| `rejected` | A value/claim was explicitly rejected and its audit history remains. |
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

National snapshots can contain tens of thousands of observations. The accepted Pilot corpus contains an Evidence artifact with **103,315** observations.

Operational rule:

- up to 500 observations: inline bounded observation loading is permitted;
- above 500 observations: do not automatically invoke bulk observation expansion;
- retain the governed observation count;
- load bounded affected-entity lineage;
- drill through the canonical entity/value for exact context.

Accepted performance measurements:

- Evidence page, 50 rows, warm: ~55.7 ms;
- high-volume detail: ~181.0 ms;
- first 100 entity links for the 103,315-observation artifact: ~459.1 ms;
- entity-link query temp spill: 0 blocks.

A cold Evidence-list execution of ~3.64 seconds was observed before buffers warmed; loading state must remain visible rather than presenting a blank screen.

## 9. Private object preview/download

Evidence Storage remains private.

The browser must not receive a service-role credential, database credential, private key or generic public bucket access.

Accepted access flow:

1. authorised browser submits Evidence UUID + preview/download mode;
2. `admin-evidence-access` requires a valid user JWT;
3. CourseFinder role rank is rechecked and must be 3+;
4. service-role credentials resolve the private object only server-side;
5. permitted access receives a signed URL with a 60-second expiry;
6. the signed URL is temporary access, not authority to make the Evidence bucket public.

Unsupported preview MIME types remain unavailable rather than being coerced into unsafe inline rendering.

Browser/network UAT confirmed normal governed `admin_read` calls and `admin-evidence-access` signed-access calls without service-role credential exposure.

## 10. Pipeline Ops coexistence

Pipeline Ops v1.0 remains accepted and coexists with Evidence v1.0.

The release retains:

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

A production Platform Admin account should not be downgraded merely to reproduce a denial already proven at the authoritative server boundary. The accepted UAT combines rank-3 success, below-rank denial, rank-gated UI source review and authenticated browser behaviour.

## 12. Accepted release state

Pilot PR:

`msinghbs-ai/Coursefinder-Pilot#14`

Final candidate head:

`89c1c35ac7b10047588440c78820d5d5b2acc5ad`

Merged Pilot head:

`d036fa64c190db98ed44c33fe265d0b47860f97e`

Visible marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · governed`

Build:

`Pilot Frontend Build #99 / 32439107994 — PASS`

Country-aware Source filter migration:

`20260821021205 — m1_evidence_ux_country_source_filter_v1`

Authenticated browser acceptance items 1–10 are PASS under:

`docs/uat/coursefinder-m1-evidence-ux-technical-acceptance-2026-08-21.md`

`CF-CHG-20260821-017` is **CLOSED / PASS**.
