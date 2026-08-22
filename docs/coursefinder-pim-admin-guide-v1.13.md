# CourseFinder PIM Admin Guide v1.13

**UI:** PIM Admin v2.12 + Pipeline Ops v1.0 + Evidence v1.0 + Data Quality v1.0  
**Effective:** 22 August 2026  
**Status:** **CURRENT ADMIN OPERATING GUIDE — DATA QUALITY v1.0 ACCEPTED**  
**Supersedes:** `docs/coursefinder-pim-admin-guide-v1.12.md`

## 1. Purpose

This guide retains all accepted v1.12 PIM, Pipeline and Evidence semantics and adds the accepted Data Quality / Readiness operating model.

Operational journey remains:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

Data Quality measures those authorities without collapsing them.

## 2. Browser and role boundary

Supported reads remain:

`Supabase Auth → public.admin_read(text,jsonb) → server-side role/rank check → governed internal read`

| Area | Minimum role |
|---|---|
| Overview / Catalogue / Data Quality overview + exceptions | assigned CourseFinder role |
| Review Queue / Evidence | Curator, rank 3 |
| Pipeline Control / Jobs / Sources | Pipeline Operator, rank 4 |
| PIM Configuration | PIM Admin, rank 5 |
| privileged mutations | explicit governed server action only |

Data Quality does not bypass the Evidence boundary. Evidence links are shown only where a real evidence ID exists and the operator is authorised.

## 3. Data Quality operating model

Do not use a single cross-domain percentage to decide whether a Provider/Course/Campus/Scholarship is complete. Use the relevant readiness domain:

- Identity completeness;
- Regulatory completeness;
- Geography / delivery;
- Taxonomy;
- Regulatory fee;
- Current Provider fee;
- Course URL;
- Intake;
- English requirement;
- Scholarship;
- Evidence;
- Verification / freshness;
- Search admission;
- Publication readiness.

The UI intentionally states `No composite completeness score`.

## 4. State meanings

| State | Operational meaning |
|---|---|
| `present` | Governed value/relationship is present. |
| `source_null` | Accepted authority was checked and supplied no governed value/relationship. |
| `not_applicable` | Domain does not apply under the accepted country/source contract; excluded from denominator. |
| `zero` | Legitimate numeric zero; counts as ready, not missing. |
| `suppressed` | Value exists in a governed suppressed state. |
| `not_yet_enriched` | Required later-layer enrichment has not yet produced an accepted observation. |
| `stale` | Explicit governed verification is absent/older than the accepted freshness threshold. |
| `ambiguous` | Governed mapping/review state is unresolved. |
| `rejected` | Candidate/observation has been explicitly rejected. |

Never manufacture a value to move a record from an exception state to ready.

## 5. Country/source examples

- AU Course with no CRICOS Course Location after accepted source reconciliation may be `source_null`; no synthetic Campus is created.
- AU registered Tuition Fee may legitimately be numeric zero and is `zero`, not missing.
- NZ regulatory tuition is `not_applicable` because the accepted NZ Layer 1 authority has no CRICOS-equivalent registered total-course tuition dimension.
- Missing Provider-current fee, official URL, Intake or English requirement before accepted Provider enrichment is `not_yet_enriched`, not Layer 1 source-null.

## 6. Operational drill-down

Use:

`Domain readiness → state count → Exceptions → canonical entity → Evidence / Review when real`

The overview is one bounded aggregate RPC. Exceptions is one bounded server-paged RPC. Entity/Evidence/Review detail is an explicit operator action; the list does not issue per-row detail RPCs.

The accepted deployed browser path proves Regulatory fee → Course → Source-null = 191, all four pages, a canonical Course detail and a linked CRICOS Regulatory Snapshot Evidence artifact.

## 7. Legacy Course percentage

The old six-signal catalogue score is retained only for compatibility and is labelled:

- `Legacy presence`;
- `Min legacy presence`.

Do not use this score as the authoritative cross-domain readiness measure.

## 8. Search and publication

Search admission is presence in the governed Search projection. It does not imply publication. Publication readiness is independently derived from canonical/channel publication progression. Data Quality must not infer `published` from Search presence.

## 9. Evidence/private boundary

Evidence lineage remains:

`Source → Acquisition Job → Evidence Artifact/Snapshot → Observation/Claim → Canonical Entity/Field → Review/Decision → Search/Publication consequence`

Private Storage stays private. Preview/download remains server-mediated. Data Quality only navigates to Evidence through the existing governed Evidence workspace.

## 10. Accepted release

Pilot head:

`msinghbs-ai/Coursefinder-Pilot@72721c57d2a11a5fb79288c9eadf4e14602a2e14`

Visible marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · governed`

References:

- `CF-CHG-20260821-018` — CLOSED / PASS;
- `docs/coursefinder-data-quality-readiness-contract-v1.0.md`;
- `docs/uat/coursefinder-m1-data-quality-readiness-technical-acceptance-2026-08-21.md`;
- `docs/uat/coursefinder-m1-data-quality-readiness-browser-evidence-2026-08-21.md`.

The platform leaked-password-protection warning and any unrelated transient database timeout remain separate operational/security backlog concerns. Future repeatable browser regression is governed under `M1-UAT-HARNESS`.