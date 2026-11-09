# CF-247 — Catalogue-driven AER provider coverage reconciliation
**Platform Admin mandate:** 2 November 2026, based on missing universities reported in catalogue; **status:** documented design/production read-only baseline; no source acquisition, admission or scheduler deployment completed.

**Authority:** `docs/platform/AGENT-OPERATING-MODEL.md`, AER Draft 1.2 §F, `2026-11-02-aer-qualification-coverage-gap-assessment.md`, `2026-11-02-aer-continuous-assurance-mandate.md`, current SS execution register and ingestion/admission holds.

## Live read-only baseline (2 Nov)
Catalogue eligibility: `ref.countries.iso_alpha2 in ('AU','NZ')`, provider `lifecycle_status='active'`, `publication_status='published'`, `enrols_international=true`.

| Population | Eligible | AER source linked | No AER source | At least one active provider matrix | Source but no active matrix |
|---|---:|---:|---:|---:|---:|
| AU | 1,279 | 19 | 1,260 | 5 | 14 |
| NZ | 197 | 15 | 182 | 8 | 7 |
| Total | 1,476 | 34 | 1,442 | 13 | 21 |

These are **source registry and provider-matrix metrics only**. A missing provider-matrix row does not prove absent course-level requirements or an absent university web page; a provider source may be read but held pending Layer 4.

### Named-provider census
| Canonical catalogue provider | Provider UUID | Source rows | Active provider matrix rows | Other matrix rows |
|---|---|---:|---:|---:|
| Charles Darwin University | `6f5cb7f7-7c70-4c06-970f-f368c3a786e2` | 0 | 0 | 0 |
| Deakin University (Deakin) | `c5c5d225-3d4c-4e41-8275-78eddd261073` | 0 | 0 | 0 |
| University of New England | `fa0e0d13-838a-42ff-b6a3-9cea84bd80b2` | 0 | 0 | 0 |
| Torrens University Australia (canonical name includes associated institutions) | `fec52f92-a8a3-4de8-a862-06f355e4e2f7` | 0 | 0 | 0 |
| Australian Catholic University | `030992c3-72c6-452d-8a3b-10ceb0fd77f2` | 0 | 0 | 0 |
| James Cook University | `fe6af182-f5ca-4a3c-bfb4-b0773ff1b113` | 0 | 0 | 0 |
| Central Queensland University | `f02d9d9b-0eb2-4f0e-8215-27a36ae63aa6` | 0 | 0 | 0 |
| University of Southern Queensland | `551383f9-7732-4588-a843-dd2b97c13f6f` | 0 | 0 | 0 |
| RMIT University (RMIT) | `8e1adb6c-e069-43db-9584-bd054255e702` | 36 | 380 | 187 |
| The University of Western Australia | `9109fe0c-9f44-4e2d-a136-eb00dec24701` | 1 | 0 | 236 |

RMIT 36 source rows have multiple successful and failed reading runs; failures include IB, GAC, UK, Nigeria, Vietnam, Norway. UWA's source has a completed run but no active provider matrix. **Do not equate either with a proven Layer 4 disposition without checking the exact review item IDs and evidence.**

## Mandatory architecture correction
The AER assurance population must be recomputed from the **canonical `catalogue.providers` joined to `ref.countries`**, not from `entry.providers`, already-enrolled AER jobs, sampled universities or existing `entry_matrix_sources`. Those are execution scope and coverage results, not the provider universe.

### Detection query design
- Eligible provider projection with stable provider ID, jurisdiction, status, international intent and counts of eligible active courses; record genuine ambiguity separately.
- LEFT JOIN / NOT EXISTS to `pipeline.entry_matrix_sources` for **missing_source_registry**, but classify provider official source discovered externally only after source-evidenced validation; do not interpret zero rows as source not published.
- Correlate source `status`, latest run `state/error`, `catalogue.provider_entry_matrix` active/non-active and `catalogue.course_entry_requirements` by eligible courses; include Layer 4 pending/returned/rejected by exact entity/kind.
- Distinguish `not_discovered`, `source_held`, `reader_failed`, `awaiting_layer4`, `active_verified`, `course_only`, `source_not_published_evidenced`, `not_applicable_evidenced`, with existing admission status vocabulary unchanged (these are report dispositions, not new canonical status values).
- Group shared reader faults by root cause and deduplicate per source/providing institution; no per-university manual issue requests.
- Preserve related-provider identities: Deakin University ≠ Deakin College; RMIT ≠ RMIT UP; University of New England ≠ similarly named schools; Torrens canonical associated aliases require careful source-provider binding.
- Provider URL capture: verified primary AER landing URL plus evidence-linked country, global qualification, postgraduate and course-specific pages in Provider entity from existing canonical source objects.

## Scheduling/operations
1. Build **read-only** catalogue-to-AER coverage snapshot and a diff against prior snapshots using an approved existing job mechanism. Hourly lightweight reconciliation must consume existing database metadata, **not crawl all 1,476 sites hourly**.
2. Prioritise source-discovery queue for university/tertiary providers (including the named eight missing universities) and eligible providers with international courses. Coverage across other provider categories remains included in the denominator with route-specific outcomes, not assumed to have university-style matrices.
3. Introduce config-governed source-navigation checks only at approved cadence and after reconciling current 30 Oct ingestion holds and 28 Oct provider-scope restrictions. Stored-first; source discovery and evidence-classification before any paid reader.
4. Existing Layer 4 remains the only human academic admission route; RMIT/UWA review states need exact live review reconciliation; no automated/bulk AER approval.
5. Surface AU/NZ roll-up, eligible sources, zero-source, held extraction, pending review, active/consumer-visible, oldest holds, 7-/30-day deltas under existing Coverage & completeness → AER. Reuse alerting and weekly Monday 08:00 Australia/Sydney report; never send per-provider noise.
6. Assign an SS execution-register ID after checking current register; maintain baseline and release evidence. No claim of working automation until deployed scheduler + UI/report + alert verified.

## Acceptance
- Named universities above appear in the catalogue-to-AER gap queue without hand registration.
- RMIT and UWA appear as source-present but distinct review/extraction/admission states; no misleading `no source` labels.
- AU 1,279 / NZ 197 reconciliation matches baseline or explains exact live deltas at each run.
- A provider may have no matrix but valid course-level requirements; report separately, not simply no entry requirements.
- Global IB/GAC cases are counted as globally applicable provider rules, not country clones.
- Root-cause dedup, safe restart, no uncontrolled paid reads, no Layer 4 bypass and evidenced closures proven by governed tests.
- Run output references exact provider IDs and source/review evidence, and is part of the normal progress report.

**Execution state:** This document lodges the mandate and measured starting point only. No automatic reader jobs or production workflow changed in this session.
