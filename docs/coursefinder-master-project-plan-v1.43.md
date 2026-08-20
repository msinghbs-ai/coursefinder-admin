# CourseFinder Master Project Plan v1.43

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.42.md`  
**Last consolidated:** 20 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Running build:** `docs/coursefinder-running-build-v2.47.md`

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS identity/geography/field | PASS / ACCEPTED | Preserve 1,546 Provider / 26,648 active Course substrate |
| AU Layer 1 residual completeness remediation | PASS / COMPLETE | `layer1-au-depth-v1.6.0`; zero missing Study Levels; zero unexplained mapping defects |
| AU first-party Course facts | IN PROGRESS / 2 QUALIFIED SOURCES / 10 COURSES BOUNDED | RMIT + UQ accepted; controlled expansion continues |
| QUT Course Facts candidate | DEFERRED / SOURCE-SPECIFIC | Production Edge acquisition returns HTTP 403; APPLY disabled |
| AU QILT Layer 2A | PASS / ACCEPTED | 2,033 Provider outcome observations retained |
| AU PRISMS Layer 2A | PASS / ACCEPTED | 2,270 raw observations / 1,135 paired source rows retained |
| AU Scholarships | PASS / FIRST-SOURCE ACCEPTED | Controlled expansion only |
| Search governed projection + FTS | PASS / ACCEPTED | 33,105 documents |
| Vector/semantic Search | REJECTED / NOT ADMITTED | Existing rejection remains in force |
| Search enrichment readiness | BLOCKED / SEPARATE GATE | Layer 2 facts are not automatically consumer-admitted |
| Admin/PIM hardening | PASS / COMPLETE | Existing acceptance remains in force |
| M1-PIM-GOV fee semantics | TECHNICAL + FRONTEND SOURCE PASS / DEPLOYED BROWSER PENDING | `CF-CHG-20260820-001` |
| M1-PIM-GOV Insights restoration | TECHNICAL + FRONTEND SOURCE PASS / DEPLOYED BROWSER PENDING | `CF-CHG-20260820-005` |
| **M1-PIM-GOV Evidence provenance** | **DB/SECURITY + FRONTEND SOURCE PASS / DEPLOYED BROWSER PENDING** | `CF-CHG-20260820-006`; full current evidence corpus is now represented in governed source |

## PIM Admin v2.5.0

v2.5.0 retains v2.3 fee semantics and v2.4 Insights restoration and introduces an explicit Evidence provenance workspace.

### Evidence operating contract

Evidence is provenance, not canonical truth or approval.

Current live corpus:

- 1,567 evidence artifacts;
- 43 distinct sources;
- 8 evidence types.

The prior generic UI cap of 1,000 omitted 567 current artifacts. The v2.5 governed source requests all current artifacts within the existing Admin limit and exposes explicit provenance semantics rather than arbitrary JSON-key columns.

Required visible meaning includes:

- Source;
- Evidence Type;
- Source Type;
- Captured At;
- Validity;
- MIME;
- Content Hash;
- Source URL;
- Storage path;
- metadata;
- supersession context where populated.

Current corpus contains no populated `supersedes_evidence_id`; this absence is displayed explicitly rather than inferred as missing data corruption.

### Evidence security boundary

The Evidence projection itself was `SECURITY DEFINER` with direct authenticated EXECUTE. `m1_pim_gov_evidence_acl_v1` removes that direct browser surface while retaining the Curator-or-higher governed `public.admin_read('evidence',...)` path.

Assigned Platform Admin UAT proves all 1,567 rows remain accessible after ACL hardening.

No evidence artifact or source record is modified by this Admin change.

## Preserved fee semantic reference

Exact CRICOS `121174E` remains the first fee reference:

- Tuition Fee — AUD 132,900;
- Non-Tuition Fee — AUD 0;
- Estimated Total Course Cost — AUD 132,900;
- `basis=registered_total_course`;
- `audience=international`;
- `fee_year=NULL` because the source does not supply a year;
- Provider-current section remains separate.

## Preserved Insights semantics

QILT remains Provider outcomes enrichment with accepted Provider cross-link.

PRISMS remains aggregate geography/study-area/sector/remoteness/time data with no manufactured Provider/Course identity and source-row-preserving pairing.

Current retained counts:

- QILT: 2,033;
- PRISMS raw: 2,270;
- PRISMS paired: 1,135;
- AU-VIC + higher_education: 112.

## Governance outputs

- `docs/coursefinder-pim-admin-guide-v1.0.md`
- `docs/coursefinder-zoho-consumer-contract-v1.0.md`
- `docs/uat/coursefinder-m1-pim-gov-fee-semantics-uat-2026-08-20.md`
- `docs/uat/coursefinder-m1-pim-gov-insights-v2.4.0-uat-2026-08-20.md`
- `docs/uat/coursefinder-m1-pim-gov-evidence-v2.5.0-uat-2026-08-20.md`
- `change-control/REGISTER.md`

The PIM Admin Guide already defines the correct Evidence semantics; no semantic-guide version bump is required merely because the operational workspace now complies with it.

## Consumer boundary

Search remains:

- Course Documents: 33,105
- fee/intake/English enrichment admitted: 0

Admin visibility does not itself admit evidence, QILT, PRISMS or Provider-current facts to Search, Website or Zoho.

## Current Change Control

- `CF-CHG-20260820-001` — fee semantics/Admin Guide — technical + source PASS, deployed browser pending
- `CF-CHG-20260820-002` — UQ first expansion — CLOSED / PASS
- `CF-CHG-20260820-003` — QUT acquisition — DEFERRED
- `CF-CHG-20260820-004` — UQ v3 expansion — CLOSED / PASS
- `CF-CHG-20260820-005` — Insights restoration — technical + source PASS, deployed browser pending
- `CF-CHG-20260820-006` — Evidence provenance — DB/security + source PASS, deployed browser pending

## Next PIM-GOV work

1. continue semantic audit of Scholarship, Provider, Campus, lifecycle/publication, completeness, Review Queue and source/operations presentation;
2. create separate Change Control only for materially distinct defects;
3. preserve the canonical model unless a genuine semantic/storage gap is proven;
4. complete deployed browser UAT for open PIM governance changes when runtime observation becomes available;
5. keep Search/Website/Zoho admission independently governed.

Database Architecture remains v2.10.37 because no canonical relational model changed.
