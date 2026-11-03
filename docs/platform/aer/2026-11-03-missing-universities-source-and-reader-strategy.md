# StudySearch — AER missing-university extraction strategy
**Date:** 3 November 2026 (AEDT)  
**Type:** Decision/design handoff for concurrent Claude Workstream C; documentation only, no production changes  
**Authority:** [Operating model](../AGENT-OPERATING-MODEL.md); [AER technical design](../AER-TECHNICAL-DESIGN.md); [catalogue reconciliation](../nz-enrichment-brief/2026-11-02-aer-catalogue-provider-coverage-reconciliation.md).  
**Historical baseline:** 2 November 2026, **not** a fresh 3 November production query.

## Decision and scope
Start with the canonical AU/NZ **catalogue provider population**, not the AER enrolment list. On 2 Nov: **1,476 eligible providers** (AU 1,279; NZ 197); **34 with a linked AER source**; **1,442 without**. These are *source-registry gaps*, not proof that the provider publishes no entry requirements. Prioritise the eight named universities below, then apply the same discovery classifier to every eligible provider. RMIT and UWA are separate **source-present, extraction/review** cases.

**Do not dispatch eight independent paid searches by default.** Existing stored evidence and official-site navigation first, source identity check second, page-type-specific extraction third, Layer 4 admission last. Keep shared work and source hashes reusable. Respect existing ingestion holds, budgets, provider scope, manual locks, and Platform Admin review authority.

## Missing university cohort — individually assigned strategies

| Provider (canonical) | Catalogue provider UUID | Source rows (2 Nov) | Discovery and reader strategy |
|---|---|---:|---|
| Charles Darwin University (CDU) | `6f5cb7f7-7c70-4c06-970f-f368c3a786e2` | 0 | Explore official **cdu.edu.au** international admissions and country/qualification entry guidance. Determine whether undergraduate qualification rules are university-wide or course-specific. Parse structured eligibility/country lists; attach course-page prerequisites separately. Preserve pathway-college boundaries. |
| Deakin University | `c5c5d225-3d4c-4e41-8275-78eddd261073` | 0 | Explore official **deakin.edu.au** international entry requirements, qualification equivalencies and course-specific academic criteria. Distinguish **Deakin University from Deakin College**. If country tables exist, use matrix parser; otherwise course requirement reader plus university-wide rule source. |
| University of New England (UNE) | `fa0e0d13-838a-42ff-b6a3-9cea84bd80b2` | 0 | Explore official **une.edu.au** international entry and degree admissions pages. Inspect whether published requirements are country-level, generic assessment-on-application, or per-course. Capture explicit qualitative conditions as `case_by_case`, not invented numeric minima. Disambiguate UNE from unrelated namesakes. |
| Torrens University Australia | `fec52f92-a8a3-4de8-a862-06f355e4e2f7` | 0 | Explore official **torrens.edu.au** international admissions and course entry pages. Reconcile its *catalogue canonical provider and associated institutions/brands* against source ownership before binding. Use course-first reader for programme-specific rules, separate pathway and postgraduate conditions. |
| Australian Catholic University (ACU) | `030992c3-72c6-452d-8a3b-10ceb0fd77f2` | 0 | Explore official **acu.edu.au** international academic eligibility and qualification/country pathways. Parse country tables or PDFs when present; course-specific prerequisites separately. Preserve any discipline, professional registration and placement conditions without treating them as a numeric score. |
| James Cook University (JCU) | `fe6af182-f5ca-4a3c-bfb4-b0773ff1b113` | 0 | Explore official **jcu.edu.au** international academic admissions, country qualifications and course requirements. Validate campus/jurisdiction and course identity; do not attach Singapore-campus rules to Australian courses without explicit applicable evidence. |
| Central Queensland University (CQU/CQUniversity) | `f02d9d9b-0eb2-4f0e-8215-27a36ae63aa6` | 0 | Explore official **cqu.edu.au** international entry and country qualification requirements. Identify qualification lists/score tables vs general entry explanations, then map course-specific exceptions. Treat CQU and CQUniversity as aliases of the *verified same* catalogue provider only. |
| University of Southern Queensland (UniSQ, formerly USQ) | `551383f9-7732-4588-a843-dd2b97c13f6f` | 0 | Explore official **unisq.edu.au** international entry and programme academic requirements; use **USQ** as a search alias only after verifying identity. Parse course-level criteria and any country equivalency matrix. Do not infer requirements from historic branding or out-of-date pages. |

**Domain names above are official-site discovery starting points, not yet verified AER landing URLs.** Store the exact verified page(s), source ownership, provenance and section types in the existing source registry/provider UI path. Do not create fictional URLs or infer that any particular matrix is published until inspected.

## Existing sources with held or incomplete admission — *not* missing universities
| Provider | UUID | 2 Nov evidence | Required recovery |
|---|---|---|---|
| RMIT | `8e1adb6c-e069-43db-9584-bd054255e702` | 36 sources; 380 active matrix rows, 187 other rows | Work from the stored source and existing band-ladder, IB/GAC and other qualification attempts. Resolve source slices, band identity, quoted row completeness, country/global qualification identity and per-course band linking. Do not rewrite active rows without governed replacement. |
| UWA | `9109fe0c-9f44-4e2d-a136-eb00dec24701` | 1 source; zero active matrix, 236 non-active rows (177 proposed + 59 superseded) | Diagnose the exact Layer 4 read and **eight dropped rows**, preserve active-history semantics, re-extract every country/qualification table with row-level fidelity and E13/D-R3 completeness checks; prepare a corrected replacement for Platform Admin review. Official starting source: https://www.uwa.edu.au/study/how-to-apply/pathways-and-eligibility/international-and-overseas-qualifications. |

## Reader selection contract
1. **HTML table:** preserve original headers, merged context, qualification/country/level, score *and scale*, row quote, section and exact evidence; never blend adjacent rows.
2. **PDF:** use the existing column-fidelity evidence gate; hold on ambiguous column boundaries, do not invent scores.
3. **Rendered pages:** use permitted render/Firecrawl only when direct/stored reading cannot capture the content. Deduplicate by URL and content hash.
4. **Course-specific:** bind a requirement only to a strongly identified course and explicit applicable audience; avoid domestic-ATAR leakage into international rules.
5. **Global qualifications:** IB/GAC/A Levels are globally applicable only when the source says so; do not clone to arbitrary countries.
6. **No numeric matrix:** classify explicit qualitative/case-by-case guidance or legitimate source absence with proof; never create a synthetic entry score.
7. **Postgraduate:** treat degree equivalency, GPA, research/discipline and work-experience conditions separately from undergraduate tables.

### Implementation touchpoints (verify against current Pilot main before editing)
- [Reader architecture and resolver](../AER-TECHNICAL-DESIGN.md), sections 3–6: `pipeline.entry_matrix_sources`, `pipeline.entry_matrix_runs`, `catalogue.provider_entry_matrix`, `catalogue.course_entry_requirements`, `security.entry_resolve_v1`.
- [Existing first-stage source attachment](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/supabase/migrations/20261026001000_cf247_entry_matrix_step_a.sql) and central-page discovery.
- [HTML/PDF completeness gate](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/supabase/migrations/20261026010000_cf247_entry_matrix_completeness_guard.sql).
- [Reader retry/re-read](https://github.com/msinghbs-ai/Coursefinder-Pilot/blob/main/supabase/migrations/20261026008000_cf247_entry_matrix_reread.sql).
- [AER Layer 4 completeness findings](../nz-enrichment-brief/2026-11-02-aer-layer4-readiness-assessment.md) and [D-R2/D-R3 design](../nz-enrichment-brief/2026-11-03-aer-dr2-dr3-design.md).
- Reconfirm objects in `docs/platform/PIPELINE-LINEAGE.md` and actual Pilot source; linked migrations are historical design touchpoints, not proof of current live function signatures.

## Parallel Claude implementation order
**A. Read-only snapshot:** Freshly reconcile all 1,476 previously eligible providers to current catalogue state, source links, active matrix, course-only AER, recent runs, and Layer 4 items. Record deltas rather than asserting old counts are live.

**B. Eight-provider discovery:** One bounded, source-first investigation per missing university; verify official AER landing URL(s), audience, qualification coverage, page shape and stable identity; create an accountable source inventory for each. Do not trigger paid acquisition by default.

**C. Shared reader improvements:** Group the eight by source shape (HTML, PDF, rendered, course-specific, global/postgrad). Fix common parsers centrally; provider-specific adapters only for demonstrably unique source shapes. Record quote, field scale, row identity, original table boundaries and section inventory.

**D. Admission-safe recovery:** Submit complete proposals through existing AER Layer 4. Preserve all manual and previously active values. Apply D-R2/D-R3 or their live successor gates to supersede flawed pending reads, prohibit silent missing-row admission and retain audit trails. No bulk approval.

**E. Assurance:** Incremental catalogue-first coverage report and source-change fingerprints. Separate `no_source`, `source_found`, `read_held`, `awaiting_layer4`, `active`, `course_only`, and evidenced nonpublication as **report classifications**, not new database status values. Report 7/30-day movements and owner blockers in existing AER UI/alerts; avoid whole-site hourly crawling.

**F. Integration ownership:** Workstream C owns discovery and reader development. Workstream A integrates autonomous classification, D handles retries and paid-result persistence, E supplies regression evaluation. **Only the Integration Controller merges, deploys, or initiates governed production writes.** Honour active parallel development and current releases.

## Acceptance and closure
- Each of the eight missing universities has verified source URLs or an evidence-backed blocked outcome, correct provider binding and a recorded reader route; no fabricated tables.
- Each recoverable provider has an evidence-backed proposed AER record set, with Layer 4 decision status and verified active/consumer outcome separately reported.
- RMIT and UWA show truthful source-present/review-held classifications; UWA dropped rows are each reconciled.
- Course-level, country-level, global qualification and postgraduate coverage remain distinct.
- New provider gaps are found from the canonical catalogue without manual naming. No unauthorised spending, changed consumer API, or Layer 4 bypass.
- Pass governed V1–V4 checks; close only after production verification. Report unresolved blockers explicitly.

---

## Running sheet: execution status (Integration Controller; SS-017 and SS-018)

### 3 Nov 2026, 18:30 AEDT

- **Evidence cut-off:** live `fxcwkweaxjtknorudmwp` at 18:28.
- **Repo refs:** Pilot `main` at v2.15.433 (`e29aa7fa`). Admin at this commit.
- **The Platform Admin's 18:17 independent validation was re-checked live and matches**, with one addition: RMIT's matrix also holds 167 superseded and 20 unverified rows.
- **Reporting rule (Platform Admin 18:17):** discovery and AI reads are not admissions. Each provider is reported per stage, and closes only on a verified production outcome or with an evidence-backed blocker.

**Per-provider status (live 18:28)**

| Provider | Sources | Extraction | Layer 4 | Admitted (active) | Consumer published | Status, blocker |
|---|---:|---|---|---:|---|---|
| CDU | 0 | — | 0 pending | 0 | — | Verified source in paste file (attach after v2.15.435) |
| UniSQ | 0 | — | 0 | 0 | — | Verified source in paste file. Country table is behind a selector; rendered-read pilot approved 18:14 |
| UNE | 0 | — | 0 | 0 | — | General rule only (evidenced, no table). Source in paste file |
| Torrens | 0 | — | 0 | 0 | — | General rule only. Source in paste file |
| ACU | 0 | — | 0 | 0 | — | Requirement PDF link not yet verified; recovery approved 18:14 |
| CQU | 0 | — | 0 | 0 | — | Country document link not exposed; stored copy `2eac8bc6`; recovery approved 18:14 |
| JCU | 0 | — | 0 | 0 | — | Selector-only, course-specific; rendered-read pilot approved 18:14 |
| Deakin | 0 | — | 0 | 0 | — | Site refuses free reads; stored copy `5106f65f`. 218 of 252 courses have bound stored pages awaiting the scheduled course reader (priority change in v2.15.435) |
| UWA | 1 | Read held (8 China rows dropped) | 1 pending (completeness gate refuses) | 0 | — | Reader fix (workstream B, branch `cf247-ops-b2`), then a governed re-read for Platform Admin review |
| RMIT | 36 | 7 held reads (reasons recorded) | 298 pending | 380 matrix, 1 course | — | Global qualifications, Nigeria and Norway reader fixes (workstream B), then the D-R2/D-R3 recovery path |

**Workstream status**

| Item | Branch / PR | Release dependency | Expected activation | Blocker |
|---|---|---|---|---|
| Coverage reconciliation and AER counts (workstream C) | `cf247-ops-c`, v2.15.434 (full suite running) | None | 3 Nov evening | — |
| Missing-university sources, inventory, priority input, per-provider status | `cf247-ops-c-aer-missing`, v2.15.435 | v2.15.434 | 3 Nov evening; paste applied right after | — |
| ACU, CQU and Deakin link recovery; JCU and UniSQ rendered pilot | same branch, follow-up paste | v2.15.435 | 4 Nov | Within existing Firecrawl limits; the budget pack is pending |
| Reader fixes (ranges, dropped values, subject prerequisites, global qualifications) | `cf247-ops-b2` | v2.15.429 (live) | 4 Nov | — |
| Scheduled AER reader (D6) | v2.15.427, live; activated 16:20 (#28754) | — | Running hourly at :13 | Back-pressure: 539 of 600 waiting in Layer 4 |

**Verified rows:** none yet for the eight-university cohort.

### 3 Nov 2026, 19:00 AEDT

**v2.15.435 deployed**
- Merge `ccdf3e06`. Full suite: 1,665 passed.
- Migration `20261104090000`: live md5 `bfb8c32b7089f762ba2d8c1b93ad71ba`.
- `aer_course_population_v1` is now `0eb8ddc8`: followed providers first, then the largest shortfall, behind `coverage.aer_reader_priority_on`.
- The inventory holds 8 rows.

**Sources attached (18:57)**
- 4 rows added to `pipeline.entry_matrix_sources` (`found_via` manual), applied from paste `PASTE-20261104-aer-missing-university-sources.sql` (md5 0e74484f), with all guards passed:
  - CDU: `/international/how-apply/entry-requirements`
  - UniSQ: `/international/apply/entry-requirements`
  - UNE: `/international/apply/eligibility/academic-requirements`
  - Torrens: `/apply-online/admissions-criteria`
- **Stage:** source attached only. Not yet read, not in Layer 4, not admitted, not published.
- **Next:** the existing entry-matrix-read job reads them directly (no Firecrawl). Each first read goes to Layer 4.

**JCU and UniSQ rendered-read pilot: not started**
- The paste `PASTE-20261104-aer-render-pilot.sql` (md5 c0db5751) adds `jcu.edu.au` and `unisq.edu.au` to `entry.render_hosts` and attaches the JCU page. At most 6 scrapes.
- At 18:59 the database tool asked for an interactive confirmation, and the client cancelled it automatically. Nothing ran.
- **Blocker:** a person must run the paste file, or be present to confirm it.

**Still pending**
- ACU, CQU and Deakin link recovery, blocked: the stored copies need the service role to read from storage.
- UWA and RMIT: waiting on the worker reader fixes (v2.15.437).
