# AER qualification and coverage design assessment — 2 November 2026

**Date:** 2 November 2026, AEDT.
**Status:** assessment dated 2 November 2026 (kept as written). Status update 9 November 2026: the proposal was taken up the same day by the Platform Admin's AER decisions (`2026-11-02-platform-admin-decisions-1450.md`: D-A1 scope, D-A3 stored-copy reads, D-A5 additive tables approved; D-A6 consumer-filter approval under G3 last recorded as open on 3 Nov 2026) and the work is tracked as SS-017 in the execution register (Implementing). Where this page says "proposed", "implementation not started" or that the 30 October hold remains, that was true on 2 November and is no longer current. The qualification-identity and provider-recognition tables approved under D-A5 were not found in the live `catalogue`, `pipeline`, `ref` or `public` schemas on 9 November 2026, so that part is approved, not built.
**Supersedes:** no accepted execution decision; revises the consolidated design from v1.0 to v1.1 at its stable path.
**Change control:** CF-CHG-20260915-247 (CF-247), SS-017.
**Owner:** Platform Admin (semantic/scope decisions); main integrator (subsequent implementation).
**Origin:** StudySearch Codex chat, continuing “RMIT Entry Requirements Review”, conversation 6ae80011-2f3c-83ec-8902-170b20cef19e. Current user mandate: inspect canonical operating model, assess the AER designs against the listed gaps, version the existing design with dated revision and gap register in Admin, preserve change controls, report files/diffs/commit/PR/blockers, no production deployment.
**Classification:** GOVERNANCE / DESIGN ADDENDUM. No code, schema, settings, paid reads or human admission action.

## 1. Outcome

Revised [AER-TECHNICAL-DESIGN.md](../AER-TECHNICAL-DESIGN.md) in place to v1.1. Added section 13 and a history entry, aligned to the concurrently lodged ENTRY-REQUIREMENTS.md Draft 1.2 and its canonical ten-item gap register; retained sections 1–12 as the labelled 29 October baseline, including its historical figures and screenshots. The router remains the sole current-document selector. No parallel “current” design or replacement AER infrastructure.

The design is only partially adequate for the requested end state. Its model and controlled evidence/review infrastructure are reusable. Its country-centred resolver, free-text qualification and bounded provider cohort do not establish portable qualification matching, full country coverage, structured postgraduate rules or a Provider source navigation contract.

This assessment records design/documentary and inspected-code evidence, not a fresh live coverage census or verified admission score. No RMIT IB/GAC/A Level/US diploma threshold is asserted for Nepal or Switzerland.

## 2. Evidence and reconciliation

Reconciliation: main advanced to `9525c94c27ce56e4ad37cf139dc48f456fd6f1aa` during review. Commits `0d71501` (gap assessment), `6cd2c33` (original design Draft 1.2) and `9525c94` (thread index) were preserved. Their report's live counts and specific source failures are prior-snapshot claims, not independently reverified here. This follow-up adds the router-selected consolidated design revision and missing CF-247/SS tracking; it does not replace the ten-item register.

Inspection baseline: Admin main `0d715014292406a038c393cc578031c8bea9bb34`; Pilot main `30a20a2c13c1f5624d84f0bba90859c64884088d` (commit title v2.15.404). These are repository snapshots, not a live deployment attestation.

Read canonical [operating model](../AGENT-OPERATING-MODEL.md), [thread index](INDEX.md), [project instructions](../../../PROJECT_INSTRUCTIONS.md), [router](../../README.md), [PIM principles](../../01-governance/coursefinder-pim-operating-principles-v1.0.md), [change routing](../../../change-control/README.md), change register and owning CF-247 record, current router-selected project plan, running build, architecture/design reference, M2 standing instructions, Pilot CLAUDE.md, lineage and execution register. The router-selected September running-build narrative is historical relative to October/November programme records; it is not used as current runtime truth. No broad programme-status rewrite is justified by this documentation task.

Design family assessed:
- [ENTRY-REQUIREMENTS.md](../ENTRY-REQUIREMENTS.md), draft 1.1: Part A mentions postgraduate entry; Part B country/qualification grain and resolver; Part C country selector. Its illustrative “you meet” wording conflicts with the later no-eligibility rule and must not be used as product copy.
- [ENTRY-REQUIREMENTS-IMPLEMENTATION.md](../ENTRY-REQUIREMENTS-IMPLEMENTATION.md), Part 1: 40-provider research sample, multiple source shapes and level patterns; Part 2 and decisions 7–10: implementation and consumer/edition controls.
- [28 October Step B decision](../ENTRY-REQUIREMENTS-STEP-B-DECISION-2026-10-28.md): bounded RMIT course read and serving slice.
- [28 October programme decision](../ENTRY-REQUIREMENTS-PROGRAMME-DECISION-2026-10-28.md), P1/P2/P3/P9: restricted provider execution scope, official sources, Layer 4 and frozen consumer shape.
- [AER operations decision](../AER-OPERATIONS-WORKSPACE-DECISION-2026-10-29.md), W1–W26, linked by the canonical design: existing workspace and governance. Detailed later implementation remains subject to Pilot reconciliation.
- [AER technical design](../AER-TECHNICAL-DESIGN.md), original sections 1, 4, 5, 7–12: bounded scope, free-text qualification, country resolver, UI, frozen feed and historical limits.
- [Closure mandate](2026-10-30-aer-production-closure-mandate.md), §2/§4: freeze expansion and require honest course outcomes; [closure response](2026-10-30-aer-production-closure-response.md), C1: course outcome register.
- [Transformation record](2026-10-31-studysearch-transformation.md), §27–28: retired adapter admission rule and additive entry scores. The adapter Rule 4 retirement does **not** retire AER resolver rule 4.

Pilot code inspected at the stated head:
- `supabase/migrations/20261026001000_cf247_entry_matrix_step_a.sql`: real provider-linked source registry, unique provider/URL; matrix country required, qualification name text; course requirement kinds and evidence. This founding migration is structural evidence, not a claim that no later migrations exist.
- `src/AerWorkspace.jsx`: matrix has qualification text search and column, provider/country/level filters; no explicit qualification-family filter in that inspected filter block. Add requirement uses a required country. The proposed explicit pathway filter extends existing search.
- Search reconciled `20261028001000_cf247_entry_step_b_course_read_resolver.sql`, `20261030280000_cf247_d5_scale_stated_marker.sql`, and consumer baseline: existing country signature and D5 marker. Do not describe the old “every number has a scale” summary as the entire later D5 contract.
- Pipeline lineage §1 confirms matrix/course landing objects and Provider international-enrolment/registration authority. No invented extraction/history objects are specified.

The prior chat was retrieved as supporting context. Its proposed portable-qualification workflow is useful rationale, not evidence of live coverage or authority to lift a hold. The current explicit user request governs this task.

## 3. Assessment against the canonical gap register

The [canonical ten-item gap register](2026-11-02-aer-qualification-coverage-gap-assessment.md) landed on main during this review. Reuse its AER-GAP-01–10 identifiers; the eight assessment groups below map to those existing gaps and do not create another register.

All rows below remain **OPEN** for implementation or coverage verification. “Partial” describes existing design support, not a completed gap. Priorities are proposed, not a resequencing of active production work.

| ID | Priority / finding | Existing evidence and shortfall | Required closure evidence | Owner / gate |
|---|---|---|---|---|
| AER-GAP-01 / AER-GAP-04 | P1 — Portable qualifications: partial | Design §4 stores qualification text against country; §5 resolves by country. No explicit identity/awarding-system/applicability model. IB/GAC held-source history is not proof of admitted coverage | Distinct IB Diploma, GAC, GCE A Level variants and US diploma routes; provider-quoted applicability; NP/CH examples with the same global policy only where supported; restrictions and ambiguous scope held | Platform Admin approves semantics; integrator designs additive mapping |
| AER-GAP-02 / AER-GAP-03 | P1 — UK and remaining countries: unverified completeness | Original research includes RMIT UK A Levels, so UK is not wholly absent from design. It does not prove current GB sources, extraction or active admission. Country dropdown omission alone proves neither publication nor absence | Per-provider official country inventory versus discovered/stored/read/proposed/active/held; explicit GB, NP, CH checks and every published country; source and timestamp per discrepancy | Integrator census; source qualification and human review; no new ingestion yet |
| AER-GAP-05 | P1 — Master's/postgraduate: partial | Original Part A mentions bachelor's assessment; course kinds include prior qualification/experience; study levels exist. No complete structured coursework/research route or alternative-rule coverage | Provider/course evidence for prior degree, field, GPA/classification basis, duration/recognition, experience, research prerequisites, alternatives and exceptions; no Year 12 default | Platform Admin semantic review; programme-specific source evidence |
| AER-GAP-06 | P1 — All eligible AU/NZ providers: scope gap | Technical design §1 and P1 limit execution to the research cohort plus Federation; current settings/reads are not the final eligible-provider denominator | Dated identity-deduplicated census from canonical registrations and international eligibility, published/unpublished distinctions, excluded/unknown reasons; all eligible non-university providers included; stages reconcile to denominator | Platform Admin approves expansion separately; 30 Oct hold remains |
| AER-GAP-08 | P1 — Qualification-first filters: partial | Qualification text search exists, but country is still the core lookup axis; global qualifications can disappear with country filtering | Existing workspace supports provider + destination route + qualification; country-specific supported lists; NP/CH global selection; independent provider table and clearly unconfirmed course minimum; dependent-choice resets | Integrator UI/read contract; G3 if consumers affected |
| AER-GAP-07 | P1 — Official URLs on Provider entity: partial | Sources already have provider_id and URL. Design does not define a canonical primary navigation URL and complete Provider-facing source collection | Provider drawer shows reviewed official primary link plus country/global/PG/course/PDF links, scopes, edition, last verification and holds; exact requirement evidence retained; no duplicate registry | Integrator proposes minimal additive designation/read path; G3 for Provider consumer payload |
| AER-GAP-10 | P1 — Qualified lookup and evidence: extension required | Five-rule resolver is reusable but country + free text is insufficient; provider table is not proof of course band; D5 permits an honest no-stated-scale display | Exact qualification/applicability match within accepted precedence; specific restrictions/conflicts visible; same review and active-only rules; missing band, no scale, case-by-case and no published requirement remain distinct | Platform Admin semantics/G3; existing Layer 4 authority |
| AER-GAP-09 | P2 — Completeness and freshness: partial | Source/read holds and course outcome register exist; course outcome is not a full provider × qualification × country × route census | Reconciled inventory funnel, dated denominator, source/edition verification, bounded refresh proposal and human queue capacity; no fabricated complete coverage or automatic retry/activation | Integrator proposal; G1/G2 if jobs/settings change; hold and spend gates |

## 4. Required acceptance cases for later implementation

These are design acceptance criteria, not tests run in this task. Add or adjust governed tests only under G4, with the mandate named; reuse existing central guards.

1. **RMIT, IB, Nepal and Switzerland:** given an active provider-quoted global IB Diploma policy, both contexts can view that policy before course selection. Without admitted evidence, show missing/held/review context; never invent a threshold.
2. **GAC / A Levels / US diploma:** each follows its own exact credential/board/variant and provider conditions. AS Levels, IB certificates and diploma-plus-AP routes do not accidentally match another qualification. Country restrictions continue to apply.
3. **UK gap:** a published GB source missing from ingestion appears as an Admin gap. UK input aliasing does not create duplicate reference countries. It must not turn a UK-only A Level rule into a global policy.
4. **Course band:** the provider table remains viewable when the course prints no usable band. Course-specific minimum stays unconfirmed and prerequisites remain visible; no ATAR conversion or “eligible” claim.
5. **Postgraduate:** a master's coursework case asks for the published prior-degree/discipline/grade/experience route; a research case preserves its research conditions and alternatives. Undergraduate scores are not substituted.
6. **Provider denominator:** eligible AU/NZ universities and non-university providers each have a reconciled record or evidenced exclusion/unknown outcome; missing official pages and inaccessible sources are counted distinctly from verified absence.
7. **Provider links:** primary and related official sources are reachable from the existing Provider drawer with scope, dates, evidence and hold reasons. URL replacement keeps history and does not overwrite manual bindings.
8. **Safety and compatibility:** proposed/quarantined/superseded/inactive rows do not become consumer choices; role boundaries and Layer 4 remain; D5 no-scale, case-by-case and no-published-value outcomes differ; old consumer calls retain their baseline; phone, keyboard and dependent-filter behaviour pass.

## 5. Governance and change-control entry

Initiated 2 November 2026 AEDT; exact origin above. Before: v1.0 mixed a 29 October live snapshot with a country-first design and bounded cohort. After: v1.1 preserves that snapshot, records a proposed qualification/applicability extension and the canonical ten-item gap register and this assessment. Affected surfaces: source/evidence model, Provider entity, AER workspace, resolver, coverage reporting, coursework/research rules and potential consumer contract. Current change affects Markdown only.

No accepted guardrail changes. No new database objects are asserted. Reuse the existing matrix/source/course tables, workspace, evidence and human-review paths. The owning CF-247 record is appended, not replaced; its large size required blob retrieval because the contents endpoint returned empty content for the oversized file. Change register, router, thread index and execution register are cross-linked in the same commit.

Scope authority: this request authorises assessment and documentation. It does not approve the final semantic design as implemented, enlarge `entry.providers`, lift the closure hold, schedule reads, approve rows, change consumer shape, merge Pilot changes or deploy production. The operating model's routine self-merge instruction does not override explicit semantic-review controls or this no-production constraint. This design PR is left for semantic review.

UI release/version: N/A; no runtime/UI change. Security/ACL, Vault, evidence storage and consumer deployment checks: N/A to the Markdown mutation; future implementation must verify them. UAT: documentation checks only (paths, versions, gap IDs, scope boundaries and diff); no runtime or coverage acceptance claimed. Rollback: revert the documentation commit through a reviewable PR, preserving the historical records; no database rollback required.

## 6. Blockers and exact next gate

No blocker to preparing the design revision. Implementation remains gated by:
- Platform Admin review of portable qualification/applicability semantics, postgraduate route structure and the final provider denominator;
- live schema/read-path and source inventory reconciliation before any migration; no live database or official-provider-page census was performed here;
- explicit G3 authority for any changed consumer field, filter, signature or behaviour, with developer guide issue/version, handover, release and change reference;
- explicit lifting of the 30 October ingestion hold with scope/spend/review capacity; this revision does not activate anything;
- row-by-row authorised human review and official-source availability for actual coverage.

Next: main integrator reviews SS-017 and produces the minimal additive implementation proposal and read-only census, citing this gap register. Platform Admin decides the semantic/API/expansion gates. Do not queue ingestion or deploy on the strength of this report.

## 7. Verification and handoff

Final reconciliation: preserved later main records `2026-11-02-aer-continuous-assurance-mandate.md`, `2026-11-02-aer-consolidated-development-mandate-1445.md` and `2026-11-02-platform-admin-decisions-1450.md`. The consolidated mandate treats Draft 1.2 and the ten-gap assessment as its architectural baseline, calls for ongoing assurance and still requires explicit reconciliation of earlier holds before conflicting production actions. This PR is the documentation assessment only; it does not claim to implement that wider mandate.

Documentation PR: https://github.com/msinghbs-ai/coursefinder-admin/pull/380 (seven Markdown files). Cross-links and version/gap-ID checks passed. Repository build checks are reported on the PR. GitHub also automatically generated an Admin branch preview; no production promotion or Pilot deployment was requested.

The review branch/commit/PR and its file diff are the immutable implementation references for this documentation change (GitHub PR metadata). No runtime tests were added; no production tests, reads or deployments run. The PR must pass its applicable documentation/build checks before acceptance. A new work branch is a durable review branch attached to the PR, not a disposable probe branch.

Continue in the existing StudySearch implementation chat. Suggested handoff: “Read the canonical operating model, router, SS-017 and the 2 November AER gap register. Reconcile Pilot and live objects read-only. Propose the smallest additive qualification/applicability and Provider source design plus a dated eligible-provider/source denominator. Preserve the ingestion hold, G3, human admission and no-production boundary until the corresponding gates are explicitly decided.”
