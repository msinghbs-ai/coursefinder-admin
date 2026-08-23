# CourseFinder M1 Final Acceptance — Technical Acceptance

**Workstream:** M1-ACCEPTANCE  
**Change Control:** `CF-CHG-20260823-028`  
**Date:** 23 August 2026 AEST  
**Live project:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`, Mumbai / `ap-south-1`)  
**Gate:** **PASS**

## 1. Acceptance rule

Milestone 1 may close only when each declared M1 gate is either:

- CLOSED / PASS;
- deliberately deferred outside M1 with an explicit owner/gate;
- explicitly rejected/not admitted; or
- covered by a documented bounded residual risk that does not invalidate the Pilot baseline.

This gate does not implement new product features.

## 2. Governance reconciliation

Authoritative start sequence was followed:

- `PROJECT_INSTRUCTIONS.md`;
- `change-control/README.md`;
- `change-control/REGISTER.md`;
- Master Project Plan v1.64;
- Running Build v2.66;
- Database Architecture v2.10.40;
- Admin/PIM Design Decisions v1.13;
- current M1 UAT and Change Control records.

Precursor gates reconciled as PASS: PIM Finalisation, Pipeline Ops, Evidence UX, Data Quality Readiness, UAT Harness, Access Admin, Search Enrichment, Publication UAT, Guides/Ops Handover, Performance/Responsiveness and Security/Release. `CF-CHG-20260823-022` remains explicitly deferred for Pilot and mandatory for Production. M1-SEARCH-VECTOR remains rejected/not admitted.

## 3. Repository responsibility / source authority

- Admin repository is authoritative for governance, Change Control, release state, acceptance and baseline documents.
- Pilot repository is authoritative for deployed runtime/migrations/Edge implementation.
- Pilot `main` resolved to `133b81734e435f9dea5ffb3ddd943e71d2930696`, containing the final security allowlist migration mirror.
- Admin pre-acceptance `main` resolved to `79a9d01946551e9b4bce6667b5d02225117203fe`, whose latest change registered Performance and Security closure.
- The final accepted deployed browser performance run remains `32622164346` against Pilot SHA `1bcb96d26f7c701ec6cf91d771016cb6405f51b2`; subsequent Pilot commits are security-only and do not redefine accepted Admin UI semantics.

## 4. Final live count baseline — PASS

| Metric | Live value |
|---|---:|
| Providers — all countries | 3,085 |
| Courses — all countries | 43,461 |
| AU Providers | 1,546 |
| AU Courses | 26,648 |
| NZ Providers | 409 |
| NZ Courses | 6,457 |
| AU+NZ Search documents | 33,105 |
| Published Search documents | 0 |
| `publishing.entity_states` | 0 |
| Accepted embeddings | 0 |
| Embedding jobs | 0 |
| Query embedding cache | 0 |
| Evidence artifacts | 1,567 |
| Pipeline jobs | 1,325 |

Counts match the declared M1 baseline.

## 5. Canonical / integrity smoke — PASS

Bounded live integrity checks returned zero for:

- Courses referencing a missing Provider;
- Search documents referencing a missing Course;
- Search documents referencing a missing Provider;
- duplicate Provider stable keys;
- duplicate Course stable keys;
- duplicate Search Course IDs.

No canonical identity mutation was performed.

## 6. AU/NZ Layer 1 and enrichment reconciliation — PASS

Live source and domain state confirms the accepted data surfaces remain present:

- CRICOS Providers/Courses/Locations source active, trust rank 10, with successful acquisition recorded;
- NZQA Education Organisations source active with successful acquisition recorded;
- QILT ESS/GOS/GOS-L/SES structured sources active, trust rank 95, with successful runs recorded;
- PRISMS structured source active, trust rank 95, with successful run recorded;
- scholarship sources remain registered and governed;
- RMIT/UQ/QUT first-party Course source definitions remain registered, with only UAT-approved RMIT/UQ Course Facts admitted to Search.

Live domain row smoke:

- provider outcomes: 2,033;
- student-flow observations: 2,270;
- scholarships: 4;
- scholarship scopes: 3;
- first-party Course-Fact source records: 14;
- course fees: 79,572;
- course intakes: 18;
- course English requirements: 32;
- governed course links: 10.

QILT/PRISMS remain at their governed provider/study-area/flow/cohort grains and are not invented at Course grain.

## 7. Search / FTS / vector — PASS

`search.projection_state` remains:

- projection: `courses`;
- projection version: `course-v3`;
- generation: 22;
- row count: 33,105;
- base hash: `cd2c8422da31f2fa298053a40563c947780ebdaf09d7b41ff983bc6ef9649d9b`;
- enrichment hash: `fb0585a82e9fe5bc43e9d34bb0f55968846fefba3cf5cc7a41cd0523814bfd3d`;
- combined hash: `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`;
- refresh function: `search.refresh_course_documents_v3`;
- enrichment gate: `domain_and_source_explicit`.

Final live dry-run `search.refresh_course_documents_v3(false)` returned:

- base: 0 new / 0 changed / 0 removed / 33,105 unchanged;
- enrichment: 0 changed / 33,105 unchanged;
- generation unchanged at 22.

Vector remains intentionally closed: 0 embeddings / 0 jobs / 0 query cache rows. M1-SEARCH-VECTOR is rejected/not admitted, not silently incomplete.

## 8. Publication / Website / Zoho — PASS

Final Pilot state is closed:

- 0 published Search documents;
- 0 publication entity-state rows;
- no broad catalogue publication authority.

The accepted publication UAT proved a bounded two-Course positive path and exact rollback. Current final state therefore correctly remains all unpublished. Website/Zoho remain governed consumers, not identity or publication authorities.

## 9. Security / ACL / RLS / Storage smoke — PASS with documented Production residual

Final public function ACL enumeration proves exactly one application browser RPC executable by `authenticated`:

- `public.admin_read(text,jsonb)`;
- SECURITY INVOKER;
- anon EXECUTE denied.

Evidence Storage bucket remains:

- private;
- 50 MiB maximum;
- MIME restricted.

Security Advisor result:

- no Critical/Error findings observed;
- INFO-only `RLS enabled / no policy` findings consistent with the accepted private deny-by-default architecture;
- one WARN: Leaked Password Protection Disabled.

The WARN is governed by `CF-CHG-20260823-022` as a Pilot-only exception and mandatory Production go-live gate. It does not invalidate M1 Pilot acceptance.

## 10. Performance / responsiveness smoke — PASS

The final accepted deployed performance gate remains GitHub Actions run `32622164346`, with all measured desktop/mobile interactive paths inside the 3,000 ms wall-time budget and payload budgets satisfied.

The final live Performance Advisor contains INFO-only unindexed-FK and unused-index observations. These are not demonstrated blockers in the accepted measured Admin/Search paths and are explicitly carried as optimisation watch items rather than hidden M1 defects.

## 11. Documentation / operations — PASS

Current accepted operational documents remain:

- User Guide v2.0;
- PIM Admin Guide v1.15;
- Operations Runbook v1.0;
- Data Quality Readiness Contract v1.0;
- Publication Governance Contract v1.0.

No guide requires a semantic correction from the final live smoke.

## 12. Explicit post-M1 items

Not part of the accepted M1 closure:

1. leaked-password protection before Production cutover;
2. any future vector/hybrid Search admission;
3. QUT Course Facts acquisition expansion;
4. broad catalogue publication / Production channel cutover;
5. physical deletion of retired Edge tombstone slugs;
6. Production identity model review for retained custom-auth ingestion workers;
7. additional country expansion and wider enrichment coverage beyond the accepted AU/NZ baseline;
8. INFO-only performance-advisor cleanup unless future measurement demonstrates a regression.

## 13. Final verdict

**PASS — COURSEFINDER MILESTONE 1 COMPLETE FOR THE GOVERNED PILOT BASELINE.**

The programme may now treat M1 as frozen. Any later technical or semantic change that touches the frozen baseline must use a new Change Control and explicitly state whether it supersedes, extends or invalidates the M1 baseline. Production readiness is not implied by this Pilot acceptance.