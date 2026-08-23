# CourseFinder PIM Admin Guide v1.15

**UI:** PIM Admin v2.12 + Pipeline Ops v1.0 + Evidence v1.0 + Data Quality v1.0 + Access Admin v1.0 + Publication Governance v1.0  
**Effective:** 23 August 2026  
**Status:** CURRENT ADMIN OPERATING GUIDE — M1 HANDOVER  
**Supersedes:** `docs/coursefinder-pim-admin-guide-v1.14.md`

## 1. Authority and role boundary

Operational authority:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

Minimum browser role boundary:

| Area | Minimum role |
|---|---|
| Overview / Catalogue / Completeness | assigned CourseFinder role |
| Review Queue / Evidence | Curator / Reviewer, rank 3 |
| Pipeline Control / Jobs / Sources | Pipeline Operator / Operations Support, rank 4 |
| PIM Configuration / Attributes | PIM Admin, rank 5 |
| Settings / Users & Roles | Platform Admin, rank 6 |

Normal reads use `Supabase Auth → public.admin_read(text,jsonb) → server rank check → governed internal read`.

## 2. Deployed menu

**Overview:** Dashboard.  
**Catalogue:** Providers, Courses, Campuses, Scholarships.  
**Enrichment & Insights:** Outcomes (QILT), Student Flow (PRISMS).  
**Data Quality:** Completeness, Evidence, Review Queue.  
**Operations:** Jobs, Sources, Attributes, Settings.  
**Platform Administration:** Users & Roles is an independently versioned Access Admin v1.0 capability.

Obsolete User Guide references to Course Collections, Categories as top-level menu items, generic Pipeline/Jobs navigation, or accepted vector-search behaviour are not part of the current deployed menu/contract.

## 3. Complex field semantic matrix

| Field / domain | Business meaning | Source authority | Grain | Null / zero semantics | Evidence | Freshness | Search implication | Zoho mapping |
|---|---|---|---|---|---|---|---|---|
| Provider identity | Canonical education-provider identity | governed regulatory/stable source identifiers | Provider | missing stable identity is blocking; name is not identity | source registration / mapping evidence | source verification dependent | Provider identity feeds Course Search relationship; not publication authority | stable Provider mapping only where approved |
| Provider State / Region | Provider-address geography | authoritative Provider/location source | Provider/address | null means unavailable/unknown at that grain | source address evidence | source verification dependent | may filter Provider context; must not imply Campus presence | map only to equivalent Provider-address concept |
| Campus | Governed Provider location relationship | regulatory/provider location source | Campus + Provider relation | source absence may be `source_null`; do not synthesize | Course Location / Provider evidence | verification dependent | Course geography may derive only from accepted Campus/location relationships | approved Campus mapping only |
| Course identity / CRICOS code | Stable Course identity and AU regulatory registration identifier | CRICOS for AU; governed stable national/provider key elsewhere | Course / registration | missing stable identity blocks deterministic matching; title is never sufficient | regulatory source row/snapshot | verification dependent | identity anchor for Search document | map stable identifiers, not display title as identity |
| CRICOS registered Tuition Fee | Regulated CRICOS tuition amount for the registered Course | CRICOS Layer 1 | Course registration / regulatory fee fact | `zero` is a real value; `source_null` is missing at source; NZ is `not_applicable` under current authority | CRICOS evidence snapshot | tied to regulatory refresh/verification | separate `regulatory_tuition_*`; not legacy `has_fee` | keep separate from Provider-current fee |
| CRICOS Non Tuition Fee | Regulated non-tuition amount | CRICOS Layer 1 | Course registration | zero is not missing; source-null stays source-null | CRICOS evidence | regulatory verification | not Provider-current tuition | separate field where Zoho contract exposes it |
| Provider-current tuition | Current fee published by Provider for international Course audience/scope | approved first-party Provider source | Course + fee year + basis + audience + campus/intake scope as applicable | absent before enrichment=`not_yet_enriched`; zero only when explicitly sourced | Provider page/schedule artifact | source verification + fee year | admitted only via governed Search enrichment gate; annual scalar only for `annual` / `indicative_annual` | separate from CRICOS registered tuition |
| Official Course URL | First-party canonical Course page | approved Provider source | Course | absent pre-enrichment=`not_yet_enriched`; rejected/ambiguous remain distinct | fetched page/evidence artifact | URL/source verification | admitted only when source-specific Search gate passes | map only as official URL |
| Intake availability | Provider-published intake options | approved Provider source | Course + campus/mode/intake/date scope | absence pre-enrichment is not source-null unless acquisition proved it | Provider evidence | time-sensitive; verify against current intake cycle | repeating structured options; do not flatten to one lossy date | preserve repeating scope where contract supports it |
| English requirement | Provider-published English entry requirement | approved Provider source | Course + test/pathway/audience/scope | absence pre-enrichment=`not_yet_enriched`; ambiguity requires review | Provider admissions/course evidence | verification dependent | repeating structured options; no invented Course-level scalar | map only approved structured requirement |
| Scholarship | Relational funding opportunity and eligibility/scope | Provider/governed scholarship source | Scholarship + Provider/Course/country/audience/cycle eligibility relations | unknown eligibility is not false; expired/rejected state remains explicit | scholarship evidence | cycle/closing-date sensitive | Search admission only where explicitly supported; current course-v3 coverage is zero | preserve eligibility/scope semantics where approved |
| QILT | Provider/outcome signal | governed QILT source | Provider/study-area/outcome grain | missing remains missing; do not assign Course value without valid mapping | QILT evidence | source-period dependent | blocked from Course-grain Search where mapping would invent semantics | only map at approved grain |
| PRISMS | International student-flow signal | governed PRISMS source | Provider/flow/cohort/time grain | missing remains missing | PRISMS evidence | period dependent | blocked from Course-grain Search where mapping would invent semantics | only map at approved grain |
| last_verified_at | Timestamp of verification activity | governed verification process | entity/fact depending object | null means never verified; does not equal human approval | linked source/evidence/review | itself is freshness signal | may influence readiness/freshness, never truth by itself | map only if consumer meaning is identical |
| completeness/readiness | Operational coverage state | derived from governed domain rules | entity + readiness domain | uses `present/source_null/not_applicable/zero/suppressed/not_yet_enriched/stale/ambiguous/rejected` | drill to source/evidence/review | aggregate snapshot every 15 minutes; exceptions live | Search readiness is a separate domain, not automatic admission | do not flatten to one truth score |
| Search admission | Whether fact/entity is admitted to accepted Search projection | governed Search domain/source gates | Search document/fact | relational presence alone is insufficient | gate + source UAT + projection evidence | refresh/hash dependent | directly controls derived Search projection | Search state is not canonical/Zoho publication authority |
| Publication | Whether content is authorised for consumer visibility | publication governance control | canonical Course + Search/channel state | unpublished is deliberate state, not missing | publication decision/UAT | action-time dependent | separate from Search admission | Zoho channel visibility follows approved publication contract |

## 4. Current accepted Search facts

Accepted projection is `course-v3`, 33,105 AU+NZ Course documents. At handover 33,105/33,105 Search documents are unpublished.

Current admitted Course Facts include Provider-current tuition, official URL, Intake and English for 10 explicitly UAT-approved Courses. Regulatory tuition remains a separate Layer 1 fact. QILT/PRISMS are not invented at Course grain. Vector/hybrid remains outside the accepted Search path.

## 5. Evidence and Data Quality

Evidence is private and decision-oriented. Administrators should be able to trace source → job → artifact → observation → canonical field/entity → review → Search/publication consequence.

Data Quality aggregate readiness is a timestamped snapshot refreshed every 15 minutes. Exception drill-down is live and server-paged. Never use the aggregate timestamp as the individual record verification timestamp.

## 6. Publication and Pilot boundary

Publication Governance v1.0 proved only a bounded positive-path Pilot allowlist. Broad catalogue publication remains unauthorised. Current final Pilot state is unpublished.

The leaked-password-protection warning is a bounded Pilot exception under `CF-CHG-20260823-022` and a mandatory Production go-live gate.

## 7. Change Control obligation

Before any material change, review `PROJECT_INSTRUCTIONS.md`, `change-control/REGISTER.md`, overlapping category records and current governance. Update the owning Change Control through APPLY/UAT/CLOSED or record a blocker/handoff.

## 8. Related guides

- `docs/coursefinder-user-guide-v2.0.md`
- `docs/coursefinder-operations-runbook-v1.0.md`
- `docs/coursefinder-data-quality-readiness-contract-v1.0.md`
- `docs/coursefinder-publication-governance-contract-v1.0.md`
- `docs/coursefinder-database-architecture-v2.10.40.md`

## Revision history

### v1.15
- Final M1 handover reconciliation.
- Added role-specific deployed navigation.
- Added cross-domain complex-field semantic matrix required by `PROJECT_INSTRUCTIONS.md`.
- Reconciled Search `course-v3`, publication, Data Quality snapshot/live semantics and Production security exception.