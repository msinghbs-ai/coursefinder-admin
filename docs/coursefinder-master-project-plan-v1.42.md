# CourseFinder Master Project Plan v1.42

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.41.md`  
**Last consolidated:** 20 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Running build:** `docs/coursefinder-running-build-v2.46.md`

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
| M1-PIM-GOV fee semantics | DB-RPC-GOVERNANCE + FRONTEND SOURCE PASS / DEPLOYED BROWSER PENDING | `CF-CHG-20260820-001` remains open only for deployed browser verification |
| **M1-PIM-GOV Insights restoration** | **DB-RPC-SECURITY + FRONTEND SOURCE PASS / DEPLOYED BROWSER PENDING** | `CF-CHG-20260820-005`; restore accepted QILT/PRISMS workspaces without weakening hardened browser boundary |

## PIM Admin v2.4.0 governed source state

v2.4.0 retains the accepted v2.3.0 CRICOS/Provider-current fee semantics and restores the authoritative v1.7 Insights UX contract.

### Insights / Enrichment

First-class workspaces:

- **Outcomes (QILT)**
- **Student Flow (PRISMS)**

Common interaction contract:

- server-side search/filter/sort/pagination where the source projection supports it;
- typeable structured filters;
- dense decision grids;
- evidence/source visibility;
- canonical cross-click only where mapping is accepted;
- right-side detail preserving list/filter state;
- persistent drag-to-resize columns with Reset columns;
- visible UI version.

### QILT semantic rule

QILT remains Provider outcomes enrichment.

Current live governed read returns 2,033 observations across four accepted QILT surveys. Canonical Provider cross-click is allowed because the observation carries accepted canonical `provider_id`. Source/evidence and outcome cohort/survey/metric semantics remain distinct from Provider identity.

### PRISMS semantic rule

PRISMS remains aggregate Student Flow observations at source geography/study-area/sector/remoteness/time grain.

Current live source state:

- 2,270 raw observations;
- 1,135 paired source rows;
- 112 paired rows for AU-VIC + higher_education.

The governed projection preserves `source_row` so repeated labels cannot collapse distinct source rows. Current accepted data does not contain Provider/Course dimensions; the Admin must not infer or manufacture them.

Suppressed values remain suppressed, not zero.

## Hardened Insights browser boundary

Pilot migration:

`m1_pim_gov_insights_admin_read_acl_v1`

Repository mirror:

`supabase/production-migrations/058_m1_pim_gov_insights_admin_read_acl.sql`

The browser uses:

`public.admin_read` → private role-checked `security.admin_insights_read` → accepted projection.

Direct `authenticated` EXECUTE is revoked from all four public QILT/PRISMS SECURITY DEFINER projection/filter functions.

Role-context UAT under the assigned Platform Admin identity passed for QILT, PRISMS and filters. This change does not alter canonical observation data.

## Fee semantic chain retained

Exact reference CRICOS `121174E` was regression-tested after the new Admin wrapper:

- Tuition Fee AUD 132,900;
- Non-Tuition Fee AUD 0;
- Estimated Total Course Cost AUD 132,900;
- Provider-current rows 0;
- unclassified rows 0.

Thus `CF-CHG-20260820-005` does not regress `CF-CHG-20260820-001`.

## Governance documents

Current relevant set:

- `docs/coursefinder-pim-admin-guide-v1.0.md`
- `docs/coursefinder-admin-pim-design-decisions-v1.7.md` and later superseding design decisions
- `docs/coursefinder-zoho-consumer-contract-v1.0.md`
- `docs/uat/coursefinder-m1-pim-gov-fee-semantics-uat-2026-08-20.md`
- `docs/uat/coursefinder-m1-pim-gov-frontend-v2.3.0-uat-2026-08-20.md`
- `docs/uat/coursefinder-m1-pim-gov-insights-v2.4.0-uat-2026-08-20.md`
- `change-control/REGISTER.md`

The living PIM Admin Guide already states the correct QILT Provider-level and PRISMS aggregate-grain semantics. It is not version-bumped merely to repeat the same semantic rule.

## Search and consumer boundary

Search remains:

- Course Documents: 33,105
- fee/intake/English enrichment admitted: 0

Restoring an Admin workspace does not admit QILT/PRISMS/fees to Search, Website or Zoho. Consumer publication remains subject to its own governed contract/gate.

## Current Change Control

- `CF-CHG-20260820-001` — fee semantics / Admin Guide — technical + frontend source PASS, deployed browser pending
- `CF-CHG-20260820-002` — UQ first Course Facts expansion — CLOSED / PASS
- `CF-CHG-20260820-003` — QUT source acquisition — DEFERRED
- `CF-CHG-20260820-004` — UQ second coverage expansion — CLOSED / PASS
- `CF-CHG-20260820-005` — Insights workspaces/governed read restoration — technical + frontend source PASS, deployed browser pending

## Next PIM-GOV work

1. verify the GitHub-triggered Cloudflare runtime shows PIM Admin v2.4.0 when runtime access is available;
2. complete deployed browser walkthrough for `CF-CHG-001` and `CF-CHG-005`;
3. close either record only when its deployed acceptance criteria pass;
4. continue the semantic audit through Provider, Campus, Intake, English, Study Level, Field of Study, Scholarships, Evidence, completeness/lifecycle/publication and Search status;
5. create new Change Control only for separately material defects; do not use UI convenience to redesign canonical schemas.

Database Architecture remains v2.10.37 because no canonical relational model changed.
