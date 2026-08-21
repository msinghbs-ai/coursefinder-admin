# CF-CHG-20260821-017 — M1-EVIDENCE-UX Operational Evidence Workspace

**Category:** `30-admin-pim-ux`  
**Initiated:** 21 August 2026, 09:40 AEST  
**Closed:** 21 August 2026, 12:36 AEST  
**Status:** **CLOSED / PASS — implementation, current-volume UAT, role/security UAT and authenticated browser acceptance complete**  
**Workstream:** `M1-EVIDENCE-UX`  
**Primary repository:** `msinghbs-ai/Coursefinder-Pilot`  
**Governance repository:** `msinghbs-ai/coursefinder-admin`

## 1. Purpose

Promote Evidence from a narrow provenance/file-list surface into a first-class Admin operational workspace spanning Layer 1 regulatory evidence, Layer 2 deterministic/structured enrichment, Layer 3 AI suggestions, Layer 4 human resolution and current Search/publication consequence state, without changing authority semantics or weakening the private evidence boundary.

Accepted lineage:

`Source → Acquisition Job → Evidence Artifact/Snapshot → Extracted Observation/Claim → Canonical Entity/Field → Review/Decision → Search/Publication consequence`

## 2. Reconciled baseline

This workstream was reconciled after `M1-PIPELINE-OPS` advanced in parallel. The accepted baseline retained throughout implementation was:

- `CF-CHG-20260820-006` — Evidence provenance/private-boundary baseline — CLOSED / PASS;
- `CF-CHG-20260820-015` — PIM Admin v2.11 browser/security baseline — CLOSED / PASS;
- `CF-CHG-20260821-016` — Pipeline Ops v1.0 — CLOSED / PASS;
- Master Project Plan v1.56;
- Running Build v2.59;
- Database Architecture v2.10.38;
- PIM Admin Guide v1.10;
- accepted Pipeline Ops source tree preserved before Evidence promotion.

No newer parallel Pipeline Ops capability was overwritten.

## 3. Accepted implementation

Pilot PR:

`msinghbs-ai/Coursefinder-Pilot#14`

Final candidate head:

`89c1c35ac7b10047588440c78820d5d5b2acc5ad`

Merged Pilot head:

`d036fa64c190db98ed44c33fe265d0b47860f97e`

Accepted visible release marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · governed`

Accepted capabilities:

- country, source, layer, entity type, canonical entity/provider scope, acquisition job, job status, evidence type, MIME, verification dates, freshness, hash, status, extraction state and unresolved-conflict filtering;
- Country-aware Source options, including stale Source reset when Country changes;
- Evidence decision grid with acquisition, extraction, freshness, conflict, job, integrity and private-object context;
- source authority/acquisition job/artifact/observation/entity/review/Search-publication lineage;
- Provider/Course/Campus/Scholarship → Evidence scoped navigation;
- Evidence → canonical entity navigation;
- exact evidence-bearing fee/intake/English/value → supporting Evidence artifact where a governed `evidence_id` exists;
- explicit source-null, missing-extraction, stale, conflict, rejected, current and superseded states;
- safe preview/download through the existing short-lived signed private-access service;
- high-volume guard preventing automatic bulk expansion above 500 observations.

No Provider/Course identity, source authority, ingestion behaviour, Search admission, publication rule or private Storage policy was changed.

## 4. Deployed Evidence server contract

The workspace consumes the existing governed `public.admin_read(text,jsonb)` Evidence routes:

- `evidence_page`;
- `evidence_filters`;
- `evidence_detail`;
- `evidence_observations`;
- `evidence_entities`.

`public.admin_read` remains SECURITY INVOKER and internal Evidence tables remain private/server-mediated.

The browser object-access path remains `admin-evidence-access`, which rechecks the authenticated CourseFinder role and issues permitted short-lived signed access only.

Country-aware Source metadata was added during browser UAT via:

`20260821021205 — m1_evidence_ux_country_source_filter_v1`

The migration adds `country_code` to governed Evidence Source filter metadata only. It does not mutate canonical or Evidence facts.

## 5. Current live corpus at acceptance

- Evidence artifacts: **1,567**;
- represented sources: **43**;
- represented acquisition jobs: **1,113**;
- artifacts with extracted observations: **387**;
- missing-extraction artifacts: **1,180**;
- artifacts containing source-null observations: **1**;
- private Evidence Storage objects: **1,540**;
- largest observed regulatory artifact: **103,315 observations/entity links**.

Claims/reviews/open conflicts and explicit supersession remain legitimate empty states where no persisted record exists.

## 6. Performance UAT

Measured against the current live Supabase state after the accepted Pipeline Ops entity-impact optimisation:

| Gate | Result |
|---|---:|
| Evidence page, 50 rows, warm | **~55.7 ms — PASS** |
| Representative high-volume Evidence detail | **~181.0 ms — PASS** |
| First 100 entity links for 103,315-observation snapshot | **~459.1 ms — PASS** |
| Temp spill on entity-link page | **0 temp blocks — PASS** |
| Legacy 103,315-observation bulk expansion | **suppressed by browser above 500 observations — PASS** |

A cold Evidence-list execution of ~3.64 seconds was retained as real cold-start evidence; the UI provides loading state rather than a blank surface.

## 7. Role/security UAT

PASS evidence:

- rank-3 Curator successfully reads Evidence through `public.admin_read`;
- an authenticated identity without a qualifying CourseFinder role is denied with SQLSTATE `42501`;
- candidate navigation hides Evidence below rank 3;
- Platform Admin authenticated browser access passed;
- `public.admin_read` remains SECURITY INVOKER;
- private Evidence tables and Storage remain server-mediated;
- service-role credentials remain server-side;
- signed evidence object access expires after 60 seconds;
- inspected browser network showed governed `admin_read` 200 responses, `admin-evidence-access` 204 preflights and authorised 200 access calls without raw private Storage/service-role credential exposure;
- no broad authenticated internal-schema CRUD or generic Evidence Storage URL was introduced.

The server-side role boundary is authoritative; no production Platform Admin role mutation or throwaway lower-role account was created merely to reproduce the already-proven denial in browser presentation state.

## 8. Build/deployment and browser UAT

GitHub Actions:

`Pilot Frontend Build #99 / 32439107994 — PASS`

Cloudflare branch preview deployment for candidate `89c1c35a`:

**PASS**

Authenticated browser UAT:

| Item | Result |
|---|---|
| role boundary | PASS — combined server enforcement, rank-gated UI and authenticated browser evidence |
| authorised Evidence list/filter/paging | PASS |
| canonical → Evidence deep link | PASS |
| evidence-bearing fee/intake/English → exact artifact | PASS |
| Evidence → canonical return | PASS |
| high-volume drawer behaviour | PASS |
| signed Preview / Download | PASS |
| browser network/private-boundary inspection | PASS |
| Country → Source contextual filtering, AU and CA | PASS |
| narrow/responsive Evidence layout | PASS |

The browser-discovered Country→Source defect was corrected and re-tested before promotion. Australia now exposes Australian Evidence sources only; Canada exposes Canadian sources only; clearing Country restores the full source set.

## 9. Rollback / release rule

Frontend rollback is the previous accepted PIM v2.11 + Pipeline Ops v1.0 tree. The Country-aware Source migration is additive metadata only and can be reverted by restoring the prior Evidence filter helper if ever necessary; it does not require canonical-data rollback.

No database rollback is required for abandoning historical UI-only Evidence changes because the core Evidence read/storage contract pre-existed this workstream.

## 10. Governing references

- Pilot PR `#14` — merged;
- Pilot merged head `d036fa64c190db98ed44c33fe265d0b47860f97e`;
- UAT: `docs/uat/coursefinder-m1-evidence-ux-technical-acceptance-2026-08-21.md`;
- Admin Guide: `docs/coursefinder-pim-admin-guide-v1.11.md`;
- Supabase filter metadata migration: `20260821021205 — m1_evidence_ux_country_source_filter_v1`.

## 11. Verdict

**CLOSED / PASS.**

M1-EVIDENCE-UX is accepted as the first-class Layer 1–4 Evidence, Provenance & Change-History operational workspace. Future Evidence mutations, review-decision workflows or authority-semantic changes require their own applicable Change Control rather than extending `017` implicitly.
