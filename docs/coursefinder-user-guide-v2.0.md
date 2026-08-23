# CourseFinder User Guide v2.0

**Effective:** 23 August 2026  
**Status:** CURRENT — M1 HANDOVER GUIDE  
**Supersedes:** all v1.x User Guide revisions  
**Applies to:** PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · Access Admin v1.0 · Publication Governance v1.0

## 1. Operating model

CourseFinder separates authority and workflow deliberately:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

Search admission is not publication. Completeness is not truth. Zero is not missing. Missing regulatory source data must not be manufactured to improve completeness.

## 2. Deployed navigation

**Overview:** Dashboard.  
**Catalogue:** Providers, Courses, Campuses, Scholarships.  
**Enrichment & Insights:** Outcomes (QILT), Student Flow (PRISMS).  
**Data Quality:** Completeness, Evidence, Review Queue.  
**Operations:** Jobs, Sources, Attributes, Settings.  
**Platform Administration:** Users & Roles is an Access Admin v1.0 capability for Platform Admins.

Menu visibility is role-filtered.

## 3. Roles

| Role | Primary use | Minimum boundaries |
|---|---|---|
| Counsellor | Read trusted catalogue facts and readiness/publication state | rank 1 read surfaces |
| Reviewer / Curator | Resolve evidence-backed ambiguity and review exceptions | rank 3 Evidence + Review Queue |
| PIM / Data Administrator | Govern PIM attributes and data-quality configuration | rank 5 Attributes/PIM Configuration |
| Integration / Operations Support | Run and diagnose sources, jobs, pipeline and deterministic replay | rank 4 Jobs/Sources/Pipeline control |
| Platform Admin | Platform settings, identities, roles, privileged security/operational controls | rank 6 Settings + Users & Roles |

## 4. Catalogue use

### Providers
Use canonical Provider identity. Provider State/Region is not equivalent to “Provider has a Campus in this State”. Inspect lifecycle, publication, verification and Evidence before consequential changes.

### Courses
Prefer stable source identity; for Australian regulatory Courses use CRICOS Course code where supplied. Do not use title alone as identity. Course detail combines facts from different authorities; inspect source, grain and verification before interpreting them.

### Campuses
Do not create synthetic Campuses merely to improve completeness. Missing Campus relationships may represent genuine source absence or unresolved mapping.

### Scholarships
Scholarship eligibility, scope and cycle can be compound. Do not flatten uncertain eligibility into a simple true/false claim.

## 5. Evidence

Evidence is private and operational. Navigate the chain:

`Source → Acquisition Job → Evidence Artifact/Snapshot → Observation/Claim → Canonical Entity/Field → Review/Decision → Search/Publication consequence`.

Before accepting a consequential fact, check source authority, acquisition time, content hash/version, associated job, affected entity, extracted fact and current/superseded state.

## 6. Completeness and readiness

Accepted state vocabulary:

`present / source_null / not_applicable / zero / suppressed / not_yet_enriched / stale / ambiguous / rejected`.

The Data Quality aggregate is a timestamped operational snapshot refreshed every 15 minutes. Exception drill-down remains live and server-paged. The aggregate snapshot timestamp is not the verification time of an individual entity.

Use domain readiness rather than assuming a single composite percentage has equal meaning across regulatory identity, geography, taxonomy, fees, URL, Intake, English, Scholarship, Evidence, freshness, Search and publication.

## 7. Layer 1–4 and operations

**Layer 1 Regulatory:** authoritative registration/identity facts. Preserve exact source meaning, including source-null and zero.  
**Layer 2 Enrichment:** governed Provider/University facts such as Provider-current tuition, official Course URL, Intake and English; never redefine Layer 1 identity.  
**Layer 3 AI:** suggestions remain non-authoritative until governed acceptance.  
**Layer 4 Human:** resolve ambiguity/conflict with evidence and auditable decision context.

Use **Jobs** for execution history/status and **Sources** for governed source inventory/health. Fix causes and replay deterministically; do not patch downstream rows merely to make a job appear healthy.

## 8. Search and publication

Accepted Search projection: `course-v3`, 33,105 AU+NZ Course documents. At handover all 33,105 Search documents are unpublished.

CRICOS registered tuition and Provider-current tuition are separate facts. Provider-current annual-comparable Search tuition is admitted only where governed. Official URL, Intake and English are admitted for explicitly UAT-approved Course Facts. QILT/PRISMS are not invented at Course grain.

Broad catalogue publication remains unauthorised by Pilot UAT. Publication is a separate gate after Search readiness.

## 9. Change Control

Check `change-control/REGISTER.md` before changing a shared surface. Material identity, semantic, source, schema/RPC/API, UI workflow, Search/publication, Zoho, security or operational changes require a `CF-CHG-*` record.

## 10. Troubleshooting

- Missing menu: check effective role/rank and expiry.
- Cannot find Course: search by stable ID/CRICOS code and clear restrictive filters.
- Missing value: determine whether it is source-null, not-applicable or not-yet-enriched before escalating.
- Stale aggregate: check Data Quality snapshot time, then use live exceptions.
- Evidence inaccessible: requires rank 3 and remains private.
- Failed job: follow `docs/coursefinder-operations-runbook-v1.0.md`.
- Search mismatch: verify Search admission and projection state before touching publication.
- Publication mismatch: compare canonical publication state, Search publication state and channel state separately.

## 11. Security

Normal browser reads use `Supabase Auth → public.admin_read(text,jsonb) → server rank check → governed internal read`.

The service-role key must never be exposed to the browser. Pilot leaked-password protection remains a documented temporary exception only and is a mandatory Production go-live gate.

## 12. References

- `PROJECT_INSTRUCTIONS.md`
- `change-control/REGISTER.md`
- `docs/coursefinder-pim-admin-guide-v1.15.md`
- `docs/coursefinder-operations-runbook-v1.0.md`
- `docs/coursefinder-data-quality-readiness-contract-v1.0.md`
- `docs/coursefinder-publication-governance-contract-v1.0.md`
- `docs/coursefinder-database-architecture-v2.10.40.md`

## Revision history

### v2.0
- Reconciled to deployed PIM Admin v2.12 navigation and role filtering.
- Removed obsolete Course Collections/Categories navigation and unsupported vector-search guidance from older User Guides.
- Added Evidence, live/snapshot Data Quality semantics, Search admission, publication and the current Pilot security boundary.