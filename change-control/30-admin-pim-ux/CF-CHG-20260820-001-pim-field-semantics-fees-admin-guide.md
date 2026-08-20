# CF-CHG-20260820-001 — PIM field semantics, fee presentation and Admin Guide

**Status:** APPLIED / UAT PASS (DB/RPC/GOVERNANCE) — FRONTEND RELEASE PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 10:30 AEST (UTC+10)  
**Origin chat/workstream:** `M1-PIM — Admin/PIM UX & Governance`  
**Governance owner:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Change class:** Admin read-contract / UI semantics / governance / documentation / Zoho-consumer semantics

## Trigger

User validation against the authoritative CRICOS Course Details screen for Swinburne University of Technology — Bachelor of Artificial Intelligence, CRICOS Course Code `121174E` — showed that the deployed Admin Course Fee presentation preserved the numeric values but obscured the distinct regulatory fee meanings.

The same review established the need for durable cross-chat Change Control and a maintained PIM Admin Guide so field meaning, source authority and downstream Zoho semantics can be understood without relying on conversation history.

## Decision

The canonical fee model is correct for the reference case and is not being redesigned for display convenience.

The accepted correction is to:

1. preserve exact canonical fee observations and stable Course identity;
2. correct the Admin read/projection semantics where fee classes or completeness states could be mislabeled;
3. enrich the governed Course-detail read contract with fee-level provenance/validity metadata;
4. document the business semantics and curated Zoho contract;
5. leave final closure pending until the frontend/browser presentation is released and verified.

## Affected surfaces

- `catalogue.course_fees` — audited only; canonical rows unchanged
- `public.ui_course_completeness_list(integer)` — corrected Admin projection semantics
- `security.admin_course_fee_summary(uuid)` — new private role-checked fee summary helper
- `public.admin_read(text,jsonb)` — Course-detail fee summary enrichment
- Course decision grid / Course detail presentation — frontend acceptance pending
- source/evidence and verification visibility
- PIM Admin Guide
- curated Zoho consumer contract
- Change Control / UAT / programme governance

No Provider/Course identity, Layer 1 source, Search admission or canonical Course Facts observation is changed by this workstream.

## Exact identity and source case

Reconciliation used exact CRICOS identity, never title-only matching.

- Provider: Swinburne University of Technology
- Provider stable key: `provider:cricos:00111d`
- Course: Bachelor of Artificial Intelligence
- CRICOS Course Code: `121174E`
- Course stable key: `course:cricos:00111d:121174e`
- Course UUID: `1b8be4ac-01c0-4b11-888f-083401acd784`

Authoritative source facts used for the reference audit:

| CRICOS concept | Source value | Canonical meaning |
|---|---:|---|
| Tuition Fee | AUD 132,900 | `fee_type=tuition`, `basis=registered_total_course` |
| Non Tuition Fee | AUD 0 | `fee_type=non_tuition`, `basis=registered_total_course` |
| Estimated Total Course Cost | AUD 132,900 | `fee_type=estimated_total_course_cost`, `basis=registered_total_course` |
| Audience | International | `audience=international` |
| Fee year | Not supplied | `fee_year=NULL` |
| Course Level | Bachelor Degree | governed Study Level mapping |
| Duration | 156 weeks | canonical Course duration |

## Canonical audit result

`catalogue.course_fees` already stored three active observations for exact CRICOS `121174E`:

- `tuition` — AUD `132900.00`
- `non_tuition` — AUD `0.00`
- `estimated_total_course_cost` — AUD `132900.00`

All use:

- `audience=international`
- `basis=registered_total_course`
- `fee_year=NULL`
- preserved source/evidence relationships
- source snapshot timestamp
- verification timestamp
- validity metadata.

Therefore the canonical database model was accepted; no schema redesign or fee-value rewrite was authorised.

## Additional defects discovered during semantic audit

### 1. Course-grid fee could be mislabeled

The prior `public.ui_course_completeness_list` selected a recent fee observation without explicitly requiring regulatory tuition + registered-total-course basis. Once Provider-current fee observations existed, an annual/current Provider amount could therefore appear under the Admin grid label `Registered fee`.

### 2. Admin completeness depended on downstream Search state

The prior Admin projection borrowed `has_fee`, `has_intake` and `has_english` from `search.course_documents`. Search enrichment is intentionally not admitted, so Search flags can remain false while accepted canonical observations exist.

Admin readiness/data presence must not be defined by downstream publication state.

### 3. Course-detail provenance was incomplete for audit use

The governed Course-detail response carried fee type/amount/currency/basis/year/audience/evidence ID, but did not expose all required fee-level campus, validity, source and verification dimensions.

### 4. Frontend zero display remains a release item

The current grid source uses truthiness-style amount rendering. Numeric zero must be handled with an explicit NULL/undefined test so a valid source `0` is never shown as missing.

## Applied semantic correction

### Pilot migration `m1_pim_gov_fee_semantics_read_contract_v1`

- `public.ui_course_completeness_list(integer)` now selects the compatibility fee deterministically from active `fee_type=tuition` + `basis=registered_total_course` observations;
- Admin `has_fee`, `has_intake`, `has_english` and Scholarship linkage are derived from canonical/relational data, not Search projection flags;
- current compatibility completeness score is explicitly documented as derived/display-only presence, not truth or publication approval;
- private role-checked `security.admin_course_fee_summary(uuid)` returns:
  - `cricos_registered`;
  - `provider_current`;
  - `other` for active semantics that are neither governed CRICOS registered fees nor governed Provider-current fee types;
- Course-detail fee observations preserve type, amount, currency, basis/load basis, year, audience, campus scope, validity, source, evidence, source snapshot and last verification metadata;
- `public.admin_read` remains the governed browser read boundary and enriches only `course_detail` with the new fee summary.

### Pilot migration `m1_pim_gov_fee_semantics_acl_fix_v1`

Direct `authenticated` execution of the corrected completeness projection was revoked; browser access remains behind `public.admin_read`.

Repository mirrors:

- `supabase/production-migrations/056_m1_pim_gov_fee_semantics_read_contract.sql`
- `supabase/production-migrations/057_m1_pim_gov_fee_semantics_acl_fix.sql`

## Semantic after-state

### CRICOS registered fees

Admin/read-contract meaning is explicitly regulatory whole-course cost:

| Fee type | Amount | Audience | Basis | Year |
|---|---:|---|---|---|
| Tuition Fee | AUD 132,900 | International | Registered total course | Not supplied by source |
| Non-Tuition Fee | AUD 0 | International | Registered total course | Not supplied by source |
| Estimated Total Course Cost | AUD 132,900 | International | Registered total course | Not supplied by source |

### Provider-current fees

Provider-current tuition remains a separate class with its own Provider-published year/basis. It never overwrites or substitutes the CRICOS registered total-course observations.

### Unclassified future fee semantics

Any active fee observation that is neither `registered_total_course` nor a governed `provider_current_*` fee is placed in `fee_summary.other` rather than being silently mislabeled. Frontend should present that state as `Needs semantic review`.

## UAT

Detailed evidence: `docs/uat/coursefinder-m1-pim-gov-fee-semantics-uat-2026-08-20.md`.

Passed:

1. exact CRICOS identity for `121174E`;
2. three canonical CRICOS fee concepts preserved;
3. numeric zero preserved;
4. NULL fee year preserved;
5. source/evidence/snapshot/verification/validity exposed through governed Course-detail read;
6. Provider-current and CRICOS fee classes separated on bounded comparison Courses;
7. Course-grid compatibility fee made deterministic CRICOS tuition/registered-total-course;
8. Admin data-presence signals separated from Search publication flags;
9. direct browser EXECUTE removed from the corrected internal completeness function;
10. governed `public.admin_read` continued to function under assigned Admin role.

## Documentation / consumer contract

Created:

- `docs/coursefinder-pim-admin-guide-v1.0.md`
- `docs/coursefinder-zoho-consumer-contract-v1.0.md`
- `docs/uat/coursefinder-m1-pim-gov-fee-semantics-uat-2026-08-20.md`

The Zoho document defines a curated semantic contract only. It does not admit the fields to Website/Zoho publication automatically.

## Frontend/browser acceptance still required

The UI/PIM implementation workstream must release and browser-verify:

1. Course grid label clearly states `CRICOS tuition (total course)` or equivalent;
2. zero-safe amount rendering;
3. human fee labels for Tuition / Non-Tuition / Estimated Total Course Cost;
4. `fee_year=NULL` shown as `Not supplied by source` rather than an unexplained dash/error;
5. Provider-current fee section remains separate with explicit empty state;
6. source/evidence/snapshot/verification/validity/campus drill-down is reachable;
7. `fee_summary.other` produces `Needs semantic review`;
8. visible UI version is incremented;
9. browser UAT reconciles exact CRICOS `121174E` end-to-end.

Repository source inspected during this change already contained a newer `PIM Admin v2.2` Course-detail separation than the originally observed deployed `v1.7.2` screen. The deployment/browser state must therefore be explicitly verified rather than assuming source equals production.

## Security note

The corrected completeness function no longer appears as a directly executable authenticated browser-definer surface after the ACL migration.

Other legacy `ui_*` SECURITY DEFINER / RLS / Auth advisor findings remain separate pre-existing PIM-hardening debt. They are not closed by this change.

## Rollback

- restore the previous governed `public.admin_read` wrapper and `public.ui_course_completeness_list` definitions;
- remove the private fee-summary helper if no longer referenced;
- restore prior ACL only with explicit security-governance approval;
- do not delete or rewrite canonical `catalogue.course_fees` rows because this change did not modify them.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 20 Aug 2026 10:30 AEST | PROPOSED | Change initiated from CRICOS/Admin fee comparison and request for formal field-semantics governance | `M1-PIM — Admin/PIM UX & Governance` |
| 20 Aug 2026 10:35 AEST | PROPOSED | Change Control moved into category hierarchy; project-wide operating instructions established | `M1-PIM — Admin/PIM UX & Governance` |
| 20 Aug 2026 | AUDITED | Exact `121174E` canonical fee rows and provenance validated; canonical model accepted | `M1-PIM-GOV` |
| 20 Aug 2026 | APPLIED | Governed Admin fee/completeness read contract corrected in Pilot; canonical facts unchanged | Pilot migrations `m1_pim_gov_fee_semantics_read_contract_v1`, `m1_pim_gov_fee_semantics_acl_fix_v1` |
| 20 Aug 2026 | UAT PASS — PARTIAL GATE | DB/RPC/governance semantics and curated Zoho contract passed; frontend/browser release remains pending | `docs/uat/coursefinder-m1-pim-gov-fee-semantics-uat-2026-08-20.md` |

## Closure

**Final status:** OPEN — APPLIED / DB-RPC-GOVERNANCE UAT PASS / FRONTEND RELEASE PENDING  
**Closed at:** N/A  
**Outcome:** Canonical fee semantics accepted; Admin read-contract defects corrected; PIM Admin Guide and curated Zoho contract established. Final closure requires the browser/frontend semantic release and exact-code walkthrough.