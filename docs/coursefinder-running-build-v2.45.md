# CourseFinder Running Build v2.45

**Status:** CURRENT GOVERNED SOURCE BUILD — CLOUDFLARE RUNTIME OBSERVATION PENDING  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.44.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.41.md`  
**PIM-GOV DB/RPC UAT:** `docs/uat/coursefinder-m1-pim-gov-fee-semantics-uat-2026-08-20.md`  
**PIM-GOV frontend UAT:** `docs/uat/coursefinder-m1-pim-gov-frontend-v2.3.0-uat-2026-08-20.md`

## Build delta

v2.45 preserves the accepted v2.44 canonical/Layer 2 state and advances only the PIM Admin frontend/governance lane.

### `M1-PIM-GOV`

Status is now:

**DB/RPC/GOVERNANCE PASS + FRONTEND SOURCE PASS — DEPLOYED AUTHENTICATED BROWSER UAT PENDING**.

`PIM Admin v2.3.0` has been released to repository `main` at:

`4858a08a2c1ff05f6cb6db60cd504f8d7d9fd4af`

Frontend release semantics:

- Course grid label is **CRICOS tuition (total course)**;
- numeric zero is zero-safe and no longer truthiness-rendered as missing;
- CRICOS fee types have governed human labels;
- `registered_total_course` displays as **Registered total course**;
- NULL fee year displays as **Year: Not supplied by source**;
- Provider-current fees remain separate with an explicit empty state;
- fee source/evidence/snapshot/verification/validity/campus metadata is available through expandable drill-down;
- unclassified active fee observations surface as **Needs semantic review**;
- visible UI version is **PIM Admin v2.3.0** on login and authenticated navigation;
- package version is aligned to `2.3.0`.

No canonical schema, Provider/Course identity, adapter, fee observation, Search projection or consumer admission changed in the frontend release.

## Exact reference case retained

CRICOS `121174E` remains the first governed semantic reference.

Canonical/read-contract facts remain:

- Tuition Fee — AUD 132,900;
- Non-Tuition Fee — AUD 0;
- Estimated Total Course Cost — AUD 132,900;
- basis — `registered_total_course`;
- audience — `international`;
- fee year — `NULL` because the source does not supply a year;
- Provider-current fee observations — none;
- unclassified `other` fee observations — none.

The frontend source now represents those states explicitly without changing the canonical values.

## Frontend source UAT

Bounded semantic display tests passed for:

- Tuition / Non-Tuition / Estimated Total Course Cost labels;
- Registered total course basis label;
- NULL year → Not supplied by source;
- AUD 0 preservation;
- AUD 132,900 formatting.

Repository publication was a clean fast-forward from the previous `main` baseline with only:

- `src/main.jsx`;
- `src/styles.css`;
- `package.json`.

## Runtime verification boundary

The project operating record identifies `coursefinder-pilot.techm.workers.dev` and GitHub-triggered Cloudflare deployment.

The current ChatGPT environment cannot independently observe that Worker because no Cloudflare control-plane connector is connected, the execution container has no external DNS/network access and the unindexed Worker URL cannot be opened through the available web-search safety path.

No GitHub Actions run exists for the frontend commit, consistent with the external Cloudflare Git integration.

Therefore v2.45 does **not** claim deployed runtime PASS. `CF-CHG-20260820-001` remains OPEN until the authenticated browser walkthrough proves the deployed UI is v2.3.0 and displays the reference case correctly.

## Preserved AU Layer 1 baseline

- Providers: 1,546
- active CRICOS Courses: 26,648
- production adapter: `layer1-au-depth-v1.6.0`
- missing Study Level: 0
- 34 Campus gaps: authoritative source absence
- unexplained Layer 1 mapping defects: 0

## Preserved AU Course Facts state

- qualified source classes: RMIT + UQ
- exact bounded CRICOS Courses: 10
- official Course links: 10
- Provider-current international fees: 10
- intakes: 18
- governed English requirements: 32
- QUT source candidate: DEFERRED / HTTP 403 from production Edge runtime

Provider-current fees remain separate from CRICOS registered total-course fees.

## Search isolation

- Search Course Documents: 33,105
- fee/intake/English enrichment admitted: 0

No PIM semantic/frontend change broadens Search or consumer publication.

## PIM governance migrations retained

- `m1_pim_gov_fee_semantics_read_contract_v1`
- `m1_pim_gov_fee_semantics_acl_fix_v1`

Repository mirrors:

- `supabase/production-migrations/056_m1_pim_gov_fee_semantics_read_contract.sql`
- `supabase/production-migrations/057_m1_pim_gov_fee_semantics_acl_fix.sql`

## Change Control

- `CF-CHG-20260820-001` — DB-RPC-GOVERNANCE PASS + FRONTEND SOURCE PASS / DEPLOYED BROWSER UAT PENDING
- `CF-CHG-20260820-002` — CLOSED / PASS
- `CF-CHG-20260820-003` — DEFERRED
- `CF-CHG-20260820-004` — CLOSED / PASS

## Documentation decision

Updated:

- Running Build → v2.45
- Master Project Plan → v1.41
- frontend semantic UAT document
- `CF-CHG-20260820-001`
- Change Control register

Not updated because the canonical relational contract did not change:

- Database Architecture remains v2.10.37
- Search contract unchanged
- Zoho admission state unchanged
- Layer 1 identity contract unchanged

## Current serial/parallel position

1. `M1-L1-AU-CRICOS-COMPLETENESS` — PASS / COMPLETE
2. `M1-L2-AU-COURSE-FACTS` — IN PROGRESS / 2 QUALIFIED SOURCES / 10 COURSES BOUNDED
3. `M1-PIM-GOV` — DB-RPC-GOVERNANCE PASS + FRONTEND SOURCE PASS / DEPLOYED BROWSER UAT PENDING
4. further AU Course Facts coverage — ACTIVE
5. Search enrichment readiness — BLOCKED / SEPARATE GATE
