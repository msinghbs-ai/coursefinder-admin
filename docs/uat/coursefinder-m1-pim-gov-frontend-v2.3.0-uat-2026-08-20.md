# CourseFinder M1-PIM-GOV Frontend Semantic UAT — PIM Admin v2.3.0

**Date:** 20 August 2026  
**Change Control:** `CF-CHG-20260820-001`  
**Workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Frontend release:** `PIM Admin v2.3.0`  
**Repository:** `msinghbs-ai/coursefinder-admin`  
**Main release head:** `4858a08a2c1ff05f6cb6db60cd504f8d7d9fd4af`  
**Status:** **SOURCE/SEMANTIC UAT PASS — DEPLOYED AUTHENTICATED BROWSER UAT PENDING**

## 1. Purpose

Complete the frontend portion of the first governed semantic walkthrough for exact CRICOS Course Code `121174E` without altering canonical data, Provider/Course identity, Search admission or the governed Admin RPC boundary.

This UAT extends `docs/uat/coursefinder-m1-pim-gov-fee-semantics-uat-2026-08-20.md`, whose DB/RPC/governance gate already passed.

## 2. Frontend implementation

`PIM Admin v2.3.0` implements the following governed presentation rules:

1. Course grid compatibility amount is labelled **CRICOS tuition (total course)**.
2. Fee amount rendering uses explicit NULL/undefined/empty checks; numeric `0` is not treated as missing.
3. CRICOS Course detail uses explicit human labels:
   - `tuition` → `Tuition Fee`;
   - `non_tuition` → `Non-Tuition Fee`;
   - `estimated_total_course_cost` → `Estimated Total Course Cost`.
4. `registered_total_course` renders as **Registered total course**.
5. `fee_year=NULL` renders as **Year: Not supplied by source**.
6. Provider-current fees remain in a separate **Current Provider fee** section with an explicit empty state when no accepted Provider-current fee exists.
7. Each fee observation includes an expandable **Source & evidence** block exposing source, source URL where present, evidence ID/source URL where present, source snapshot, last verified, validity and campus scope.
8. `fee_summary.other` is surfaced under **Needs semantic review** and is never silently reclassified.
9. Visible version is `PIM Admin v2.3.0` in both the login screen and authenticated navigation brand.
10. Package version is aligned to `2.3.0`.

## 3. Source changes

Frontend-only files changed:

- `src/main.jsx`
- `src/styles.css`
- `package.json`

No migration, RPC, source adapter, canonical table or Search projection changed in this frontend release.

## 4. Bounded semantic tests

Pure display-logic tests were executed against the accepted reference semantics.

| Test | Expected | Result |
|---|---|---|
| `tuition` label | `Tuition Fee` | PASS |
| `non_tuition` label | `Non-Tuition Fee` | PASS |
| `estimated_total_course_cost` label | `Estimated Total Course Cost` | PASS |
| `registered_total_course` basis | `Registered total course` | PASS |
| `fee_year=NULL` | `Year: Not supplied by source` | PASS |
| amount `0` / `AUD` | `AUD 0` | PASS |
| amount `132900` / `AUD` | `AUD 132,900` | PASS |

These tests directly cover the semantic presentation failures identified from CRICOS `121174E`.

## 5. Source/repository UAT

- feature branch was based exactly on prior `main` head `ea2b78f2ff04c1eca3b2962fdf230c8c06b3e58c`;
- branch remained `ahead 3 / behind 0` before publication;
- only three frontend files changed;
- `main` was rechecked for parallel movement immediately before publication;
- `main` was fast-forwarded without force to `4858a08a2c1ff05f6cb6db60cd504f8d7d9fd4af`.

**Result:** PASS.

## 6. Build/deployment verification limitation

The project operating record identifies `coursefinder-pilot.techm.workers.dev` as the Cloudflare Worker and GitHub-triggered deployment as the deployment path.

In this ChatGPT execution environment:

- no Cloudflare control-plane connector is connected;
- the execution container has no external DNS/network access;
- the Worker URL is not indexed by the available web search path and therefore cannot be opened by the web tool under its URL-safety rules;
- the repository has no GitHub Actions run for this commit, consistent with an external Cloudflare Git integration rather than Actions.

Therefore a successful GitHub fast-forward is **not** being represented as proof of successful Cloudflare deployment.

## 7. Deployed browser UAT still required

Once the GitHub-triggered Cloudflare deployment is visible, validate with the existing authorised Pilot login:

1. Login page shows **PIM Admin v2.3.0**.
2. Navigate to `Courses` and search exact CRICOS code `121174E`.
3. Confirm grid column is **CRICOS tuition (total course)**.
4. Open the exact Course and confirm **CRICOS registered fees** contains:
   - Tuition Fee — AUD 132,900;
   - Non-Tuition Fee — AUD 0;
   - Estimated Total Course Cost — AUD 132,900.
5. Confirm each CRICOS row displays **Registered total course · Year: Not supplied by source · International**.
6. Expand **Source & evidence** and confirm source/evidence/snapshot/verification/validity/campus fields are reachable.
7. Confirm **Current Provider fee** shows the explicit empty state for `121174E` and does not substitute CRICOS values.
8. Confirm no `Needs semantic review` block is present for `121174E` because `fee_summary.other=[]`.
9. As a separation check, open `102784C` and confirm CRICOS registered tuition and Provider-current 2027 indicative annual tuition remain in separate sections.

## 8. Verdict

**Frontend source semantic implementation:** PASS  
**Zero/NULL display logic:** PASS  
**Version visibility in source:** PASS  
**Repository publication:** PASS  
**Cloudflare runtime/deployment:** NOT OBSERVED FROM CURRENT TOOL ENVIRONMENT  
**Authenticated deployed browser walkthrough:** PENDING  
**Overall `CF-CHG-20260820-001`: OPEN until deployed browser walkthrough passes**
