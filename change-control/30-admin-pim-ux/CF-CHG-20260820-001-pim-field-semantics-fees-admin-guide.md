# CF-CHG-20260820-001 — PIM field semantics, fee presentation and Admin Guide

**Status:** APPLIED / DB-RPC-GOVERNANCE PASS / FRONTEND SOURCE PASS — DEPLOYED BROWSER UAT PENDING  
**Category:** 30-admin-pim-ux  
**Initiated:** 20 August 2026 10:30 AEST (UTC+10)  
**Origin chat/workstream:** `M1-PIM — Admin/PIM UX & Governance`  
**Governance owner:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Change class:** Admin read-contract / UI semantics / governance / documentation / Zoho-consumer semantics

## Trigger

Validation against the authoritative CRICOS Course Details screen for Swinburne University of Technology — Bachelor of Artificial Intelligence, CRICOS Course Code `121174E` — showed that the deployed Admin Fee presentation preserved the numeric values but obscured the distinct regulatory fee meanings.

The same review established the requirement for durable cross-chat Change Control and a maintained PIM Admin Guide so field meaning, source authority, UI behaviour and downstream Zoho semantics do not depend on conversation history.

## Decision

The canonical fee model is correct for the reference case. It is not redesigned for display convenience.

The governed correction preserves exact canonical observations and identity, corrects Admin projection/read semantics, exposes fee provenance/validity, implements semantic frontend presentation, and defines the curated Zoho contract. Final closure requires deployed authenticated browser verification.

## Exact identity and authoritative reference

Reconciliation uses exact CRICOS identity, never title-only matching.

- Provider: Swinburne University of Technology
- Provider stable key: `provider:cricos:00111d`
- Course: Bachelor of Artificial Intelligence
- CRICOS Course Code: `121174E`
- Course stable key: `course:cricos:00111d:121174e`
- Course UUID: `1b8be4ac-01c0-4b11-888f-083401acd784`

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

`catalogue.course_fees` already stores three active observations for exact CRICOS `121174E`:

- `tuition` — AUD `132900.00`
- `non_tuition` — AUD `0.00`
- `estimated_total_course_cost` — AUD `132900.00`

All preserve `audience=international`, `basis=registered_total_course`, `fee_year=NULL`, source/evidence relationships, source snapshot, verification and validity metadata.

**Canonical model:** ACCEPTED. No fee-value rewrite or canonical schema redesign was authorised.

## Defects discovered

1. **Course-grid fee ambiguity:** the compatibility grid could present a non-CRICOS fee under `Registered fee`.
2. **Admin completeness depended on Search state:** Admin presence was borrowing downstream Search flags instead of canonical relationships.
3. **Course-detail provenance truncation:** fee-level campus, validity, source and verification dimensions were incomplete for Admin audit use.
4. **Frontend zero risk:** truthiness rendering could display legitimate numeric zero as missing.
5. **Frontend semantic flattening:** raw fee type/basis/year presentation did not explain the business meaning.

## Applied DB/RPC correction

Pilot migrations:

- `m1_pim_gov_fee_semantics_read_contract_v1`
- `m1_pim_gov_fee_semantics_acl_fix_v1`

Repository mirrors:

- `supabase/production-migrations/056_m1_pim_gov_fee_semantics_read_contract.sql`
- `supabase/production-migrations/057_m1_pim_gov_fee_semantics_acl_fix.sql`

Accepted effects:

- compatibility fee is deterministic active `tuition + registered_total_course`;
- Admin fee/intake/English presence derives from canonical/relational data, not Search publication flags;
- `security.admin_course_fee_summary(uuid)` groups `cricos_registered`, `provider_current` and `other`;
- fee observations preserve amount/currency/type, basis/load basis, year, audience, campus, validity, source/evidence, snapshot and verification metadata;
- `public.admin_read` remains the governed browser boundary;
- direct authenticated execution of the corrected completeness function was removed.

## Applied frontend correction — PIM Admin v2.3.0

Frontend release head on `main`: `4858a08a2c1ff05f6cb6db60cd504f8d7d9fd4af`.

Files changed:

- `src/main.jsx`
- `src/styles.css`
- `package.json`

Accepted frontend semantics:

- grid column is **CRICOS tuition (total course)**;
- numeric zero uses explicit NULL checks and remains visible;
- human labels are `Tuition Fee`, `Non-Tuition Fee`, `Estimated Total Course Cost`;
- `registered_total_course` is displayed as **Registered total course**;
- `fee_year=NULL` is displayed as **Year: Not supplied by source**;
- Provider-current fees remain in a separate section with an explicit no-evidence empty state;
- each fee observation exposes expandable source/evidence/snapshot/verification/validity/campus metadata;
- `fee_summary.other` surfaces as **Needs semantic review**;
- visible UI version is **PIM Admin v2.3.0** on login and authenticated navigation;
- package version is aligned to `2.3.0`.

No canonical table, migration, RPC, adapter or Search projection changed in this frontend release.

## Semantic after-state

### CRICOS registered fees

| Fee type | Amount | Audience | Basis | Year |
|---|---:|---|---|---|
| Tuition Fee | AUD 132,900 | International | Registered total course | Not supplied by source |
| Non-Tuition Fee | AUD 0 | International | Registered total course | Not supplied by source |
| Estimated Total Course Cost | AUD 132,900 | International | Registered total course | Not supplied by source |

### Provider-current fees

Provider-current tuition remains a separate semantic class retaining Provider-published year/basis. It never overwrites or substitutes CRICOS registered total-course fees.

### Unclassified fee semantics

Any active fee observation that is neither governed CRICOS registered nor governed Provider-current remains in `fee_summary.other` and is presented as **Needs semantic review** rather than silently reclassified.

## UAT evidence

DB/RPC/governance UAT:

- `docs/uat/coursefinder-m1-pim-gov-fee-semantics-uat-2026-08-20.md`

Frontend source/semantic UAT:

- `docs/uat/coursefinder-m1-pim-gov-frontend-v2.3.0-uat-2026-08-20.md`

Passed to date:

1. exact CRICOS identity for `121174E`;
2. three canonical CRICOS fee concepts preserved;
3. numeric zero preserved in storage/RPC and frontend display logic;
4. NULL fee year preserved and semantically labelled;
5. source/evidence/snapshot/verification/validity/campus data exposed through governed read and frontend drill-down;
6. Provider-current and CRICOS fee classes separated;
7. compatibility grid fee made deterministic CRICOS tuition/registered-total-course;
8. Admin data-presence separated from Search publication state;
9. direct browser EXECUTE removed from corrected internal completeness function;
10. frontend fee type/basis/year labels pass bounded semantic tests;
11. v2.3.0 frontend source is published on `main` by fast-forward with no backend changes.

## Deployment/browser verification status

The project operating record identifies `coursefinder-pilot.techm.workers.dev` as the Worker and GitHub-triggered deployment as the release path.

Current tool environment cannot independently observe the Worker runtime because no Cloudflare control-plane connector is connected, the execution container has no external DNS/network access, and the unindexed Worker URL cannot be opened through the available web-search safety path. The repository also has no GitHub Actions run for this commit, consistent with an external Cloudflare Git integration.

Therefore merge success is **not** being treated as deployment proof.

Final deployed UAT must confirm:

1. login/navigation displays `PIM Admin v2.3.0`;
2. exact Course `121174E` resolves by CRICOS code;
3. grid label is `CRICOS tuition (total course)`;
4. Course detail shows AUD 132,900 / AUD 0 / AUD 132,900 under the three correct CRICOS concepts;
5. each CRICOS row shows Registered total course / source-not-supplied year / International;
6. source/evidence drill-down is reachable;
7. Provider-current section is empty for `121174E` and CRICOS is not substituted;
8. `fee_summary.other=[]` means no Needs semantic review block for `121174E`;
9. comparison Course `102784C` keeps CRICOS and Provider-current fee sections separate.

## Documentation / consumer contract

- PIM Admin Guide: `docs/coursefinder-pim-admin-guide-v1.0.md`
- curated Zoho contract: `docs/coursefinder-zoho-consumer-contract-v1.0.md`
- Change Control register: `change-control/REGISTER.md`

The Zoho contract remains definition-only. This work does not automatically admit fees to Website/Zoho/Search publication.

## Security note

The corrected completeness function no longer exposes direct authenticated execution. Other legacy `ui_*` SECURITY DEFINER/RLS/Auth advisor findings are separate pre-existing PIM-hardening debt and are not silently closed here.

## Rollback

Frontend rollback is independently reversible by restoring the preceding `src/main.jsx`, `src/styles.css` and package version. Backend rollback restores the prior governed Admin wrapper/projection definitions and removes the private fee helper if required. Canonical `catalogue.course_fees` rows must not be deleted or rewritten because this change never modified them.

## Decision / status history

| Timestamp | Status | Decision / event | Reference |
|---|---|---|---|
| 20 Aug 2026 10:30 AEST | PROPOSED | Change initiated from CRICOS/Admin fee comparison and request for formal field-semantics governance | `M1-PIM — Admin/PIM UX & Governance` |
| 20 Aug 2026 10:35 AEST | PROPOSED | Change Control moved into category hierarchy; project-wide operating instructions established | `M1-PIM — Admin/PIM UX & Governance` |
| 20 Aug 2026 | AUDITED | Exact `121174E` canonical fee rows and provenance validated; canonical model accepted | `M1-PIM-GOV` |
| 20 Aug 2026 | APPLIED | Governed Admin fee/completeness read contract corrected in Pilot; canonical facts unchanged | Pilot fee semantic migrations |
| 20 Aug 2026 | UAT PASS — PARTIAL GATE | DB/RPC/governance semantics and curated Zoho contract passed | DB/RPC UAT document |
| 20 Aug 2026 11:05 AEST | FRONTEND SOURCE RELEASED | PIM Admin v2.3.0 semantic presentation merged to `main`; bounded zero/NULL/label tests passed | `4858a08a`; frontend UAT document |
| 20 Aug 2026 11:05 AEST | OPEN — RUNTIME UAT | Cloudflare/deployed authenticated browser observation remains required before closure | `M1-PIM-GOV` |

## Closure

**Final status:** OPEN — DB/RPC/GOVERNANCE PASS + FRONTEND SOURCE PASS / DEPLOYED BROWSER UAT PENDING  
**Closed at:** N/A  
**Outcome:** Canonical fee semantics accepted, Admin read-contract defects corrected, PIM Admin Guide and curated Zoho contract established, and PIM Admin v2.3.0 semantic frontend released to `main`. Final closure requires the deployed exact-code browser walkthrough.
