# CourseFinder Master Project Plan v1.41

**Status:** AUTHORITATIVE PROGRAMME GOVERNANCE DOCUMENT  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.40.md`  
**Last consolidated:** 20 August 2026  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Running build:** `docs/coursefinder-running-build-v2.45.md`

## Current programme position

| Workstream | Status | Decision |
|---|---|---|
| AU Layer 1 CRICOS identity/geography/field | PASS / ACCEPTED | Preserve 1,546 Provider / 26,648 active Course substrate |
| AU Layer 1 residual completeness remediation | PASS / COMPLETE | `layer1-au-depth-v1.6.0`; zero missing Study Levels; zero unexplained mapping defects |
| AU first-party Course facts | IN PROGRESS / 2 QUALIFIED SOURCES / 10 COURSES BOUNDED | RMIT + UQ accepted; controlled expansion continues |
| QUT Course Facts candidate | DEFERRED / SOURCE-SPECIFIC | Production Edge acquisition returns HTTP 403; APPLY disabled |
| AU QILT Layer 2A | PASS / ACCEPTED | Maintain governed outcomes |
| AU PRISMS Layer 2A | PASS / ACCEPTED | Maintain time-scoped observations |
| AU Scholarships | PASS / FIRST-SOURCE ACCEPTED | Controlled expansion only |
| Search governed projection + FTS | PASS / ACCEPTED | 33,105 documents |
| Vector/semantic Search | REJECTED / NOT ADMITTED | Existing rejection remains in force |
| Search enrichment readiness | BLOCKED / SEPARATE GATE | Layer 2 facts are not automatically consumer-admitted |
| Admin/PIM hardening | PASS / COMPLETE | Existing security/operational acceptance remains in force; residual legacy advisor debt remains separately governed |
| **M1-PIM-GOV — field semantics/change control/Admin Guide** | **DB-RPC-GOVERNANCE PASS + FRONTEND SOURCE PASS / DEPLOYED BROWSER UAT PENDING** | PIM Admin v2.3.0 released to `main`; do not close until deployed exact-code browser walkthrough passes |

## M1-PIM-GOV — first governed semantic walkthrough

Reference Course:

- Provider: Swinburne University of Technology
- Course: Bachelor of Artificial Intelligence
- CRICOS Course Code: `121174E`
- stable Course key: `course:cricos:00111d:121174e`

Identity reconciliation is by exact CRICOS identifier under the correct Provider, never title-only matching.

### Canonical fee result

The canonical model remains accepted without redesign:

- Tuition Fee — AUD 132,900
- Non-Tuition Fee — AUD 0
- Estimated Total Course Cost — AUD 132,900
- basis — `registered_total_course`
- audience — `international`
- fee year — `NULL` because CRICOS does not supply one
- source/evidence/snapshot/verification/validity preserved.

### Read-contract corrections accepted

- Course-grid compatibility fee explicitly selects active CRICOS tuition with `basis=registered_total_course`;
- Admin fee/intake/English presence derives from canonical/relational observations rather than downstream Search flags;
- Course-detail `fee_summary` preserves CRICOS registered, Provider-current and unclassified review buckets;
- fee-level campus, validity, source, evidence, source snapshot and verification metadata are available;
- direct authenticated execution of the corrected internal completeness projection is revoked;
- governed browser reads remain behind `public.admin_read`.

### Frontend source release — PIM Admin v2.3.0

Repository `main` release head:

`4858a08a2c1ff05f6cb6db60cd504f8d7d9fd4af`

Accepted presentation semantics:

- Course grid: **CRICOS tuition (total course)**;
- zero-safe amount rendering;
- human CRICOS fee labels;
- **Registered total course** basis label;
- NULL fee year: **Year: Not supplied by source**;
- separate Provider-current fee section and explicit empty state;
- expandable source/evidence/snapshot/verification/validity/campus drill-down;
- `fee_summary.other` → **Needs semantic review**;
- visible UI version: **PIM Admin v2.3.0** on login and authenticated navigation.

Bounded semantic tests passed for the three fee labels, basis label, NULL-year representation, AUD 0 and AUD 132,900 formatting.

No canonical schema, Course/Provider identity, source adapter, fee observation, Search projection or Zoho/Website publication admission changed in this frontend release.

## Remaining PIM-GOV acceptance gate

`CF-CHG-20260820-001` remains OPEN because the current tool environment cannot independently observe the Cloudflare Worker runtime.

The project operating record identifies `coursefinder-pilot.techm.workers.dev` and GitHub-triggered Cloudflare deployment. However, no Cloudflare control-plane connector is connected, the execution container has no external DNS/network access and the unindexed Worker URL cannot be opened through the available web-search safety path. There is no GitHub Actions run for the release commit, consistent with external Cloudflare Git deployment.

A successful GitHub merge is therefore not treated as deployment proof.

Final deployed browser UAT must prove:

1. visible `PIM Admin v2.3.0`;
2. exact CRICOS `121174E` resolution;
3. CRICOS grid label and zero-safe amounts;
4. three correctly labelled CRICOS fee rows;
5. source-not-supplied year semantics;
6. evidence/provenance drill-down;
7. empty Provider-current state for `121174E`;
8. no unclassified review block for `121174E`;
9. CRICOS vs Provider-current separation on comparison Course `102784C`.

Only then may `CF-CHG-20260820-001` and the first full semantic walkthrough be declared CLOSED / PASS.

## Governance outputs

- `change-control/30-admin-pim-ux/CF-CHG-20260820-001-pim-field-semantics-fees-admin-guide.md`
- `change-control/REGISTER.md`
- `docs/coursefinder-pim-admin-guide-v1.0.md`
- `docs/coursefinder-zoho-consumer-contract-v1.0.md`
- `docs/uat/coursefinder-m1-pim-gov-fee-semantics-uat-2026-08-20.md`
- `docs/uat/coursefinder-m1-pim-gov-frontend-v2.3.0-uat-2026-08-20.md`

## Preserved AU Course Facts state

RMIT + UQ remain the two accepted production-fetchable Provider source classes.

Aggregate accepted bounded state:

- exact CRICOS Courses: 10
- official Course links: 10
- Provider-current international tuition fees: 10
- intake observations: 18
- governed English requirement observations: 32

QUT remains source-specifically DEFERRED due to HTTP 403 from the production Edge runtime. This does not block other AU Course Facts sources.

## Cross-source controls remain mandatory

- stable Provider/Course identifier before names/titles;
- no title-only Course identity;
- source qualification before APPLY;
- authoritative source evidence/version retention;
- exact Provider-published fee year/basis;
- Provider-current fee separation from CRICOS registered total-course fees;
- source-supported campus/intake scope only;
- fail-closed ambiguity handling;
- replay-safe canonical cardinality;
- no canonical `courses.course_url` mutation from Layer 2 links;
- separate Search admission.

## Admin semantic controls remain mandatory

- distinguish NULL, zero, suppressed, not applicable and not-yet-enriched;
- completeness/readiness is not truth or publication approval;
- `last_verified_at` is verification, not approval;
- preserve one-to-many observation grain;
- preserve source/evidence provenance;
- never flatten regulatory and Provider-current fee semantics;
- use exception-first Needs Review semantics for unknown/ambiguous states;
- expose curated consumer contracts rather than internal schema structure.

## Search boundary

Current Search remains:

- Course Documents: 33,105
- fee/intake/English enrichment admitted: 0

Neither Layer 2 APPLY nor PIM semantic/frontend work authorises consumer publication.

## Change Control

- `CF-CHG-20260820-001` — DB-RPC-GOVERNANCE PASS + FRONTEND SOURCE PASS / DEPLOYED BROWSER UAT PENDING
- `CF-CHG-20260820-002` — CLOSED / PASS
- `CF-CHG-20260820-003` — DEFERRED
- `CF-CHG-20260820-004` — CLOSED / PASS

## Next serial/parallel work

### PIM governance/UI

1. observe the GitHub-triggered Cloudflare deployment when runtime access is available;
2. execute the exact `121174E` authenticated browser walkthrough;
3. close `CF-CHG-20260820-001` only after the deployed source → evidence → canonical storage → Admin presentation → change history → curated Zoho contract chain passes;
4. continue semantic audit across Provider, Campus, Intakes, English, Study Level, Field of Study, Scholarships, QILT, PRISMS, Evidence, completeness/lifecycle/publication and Search status.

### AU Course Facts

Continue controlled expansion through qualified production-fetchable Provider sources without weakening exact identity, fee semantics, evidence or separate Search admission.

Database Architecture remains v2.10.37 because the canonical relational model did not change.
