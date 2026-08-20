# CourseFinder M1-PIM-GOV Fee Semantics UAT — 20 August 2026

**Change Control:** `CF-CHG-20260820-001`  
**Workstream:** `M1-PIM-GOV — Field Semantics, Change Control & Admin Guide`  
**Pilot:** `coursefinder_Pilot` / `fxcwkweaxjtknorudmwp`  
**Status:** **DB/RPC/GOVERNANCE PASS — FRONTEND RELEASE PENDING**

## 1. Scope

Validate the first governed Provider/Course semantic walkthrough using CRICOS Course Code `121174E` and prove that the canonical storage and governed Admin read contract preserve the regulatory fee meanings without title-based identity, annualisation, zero-loss or Search-state substitution.

This UAT does not declare the full workstream PASS. Browser presentation, visible UI versioning and frontend semantic UAT remain required before `CF-CHG-20260820-001` can close.

## 2. Exact identity

The audit resolved the Course by exact CRICOS Course Code, not title.

- Provider: Swinburne University of Technology
- Provider stable key: `provider:cricos:00111d`
- Course: Bachelor of Artificial Intelligence
- CRICOS Course Code: `121174E`
- Course stable key: `course:cricos:00111d:121174e`
- Course UUID: `1b8be4ac-01c0-4b11-888f-083401acd784`

Title-only reconciliation is prohibited because similarly titled Courses can exist under different Providers/codes with different facts.

## 3. Authoritative source facts

The CRICOS source case presents:

| Concept | Value |
|---|---:|
| Tuition Fee | AUD 132,900 |
| Non Tuition Fee | AUD 0 |
| Estimated Total Course Cost | AUD 132,900 |
| Fee basis | Whole registered course |
| Audience | International |
| Fee year | Not supplied |
| Course Level | Bachelor Degree |
| Duration | 156 weeks |

## 4. Canonical storage validation

`catalogue.course_fees` contains three active rows for the exact Course:

| `fee_type` | Amount | Currency | Basis | Audience | Fee year |
|---|---:|---|---|---|---|
| `tuition` | 132900.00 | AUD | `registered_total_course` | international | NULL |
| `non_tuition` | 0.00 | AUD | `registered_total_course` | international | NULL |
| `estimated_total_course_cost` | 132900.00 | AUD | `registered_total_course` | international | NULL |

All three observations retain source/evidence relationships, source snapshot time, verification time and validity metadata.

**Result:** PASS.

Key semantic assertions:

- numeric zero is preserved as a real source value;
- NULL fee year is preserved because CRICOS does not supply a fee year for this observation;
- no annual fee is manufactured;
- the three regulatory concepts remain distinct even where two amounts are numerically equal.

## 5. Defects identified before correction

### 5.1 Course grid fee ambiguity

`public.ui_course_completeness_list` selected a recent fee row without requiring a regulatory fee type/basis. Once Provider-current rows existed, a Provider-current annual amount could therefore be surfaced under the Admin grid label `Registered fee`.

### 5.2 Search state used as Admin data-presence state

The same Admin projection borrowed `has_fee`, `has_intake` and `has_english` from `search.course_documents`. Search enrichment is intentionally not admitted yet, so those flags can be false while accepted canonical observations exist.

This made the Admin readiness signal semantically dependent on downstream publication state.

### 5.3 Course-detail provenance truncation

The governed Course-detail response already retained fee type/amount/currency/basis/year/audience/evidence ID, but did not surface all fee-level validity, campus, source and verification dimensions needed for the Admin audit contract.

### 5.4 Browser zero/display risk

The existing grid renderer uses a truthiness-style amount check. A legitimate numeric zero can therefore be rendered as missing. Frontend correction remains an acceptance item.

## 6. Applied Pilot changes

### Migration `m1_pim_gov_fee_semantics_read_contract_v1`

- made the compatibility grid fee deterministic: active `fee_type=tuition` + `basis=registered_total_course`;
- changed Admin presence signals to canonical/relational existence checks rather than Search flags;
- added role-checked private `security.admin_course_fee_summary(uuid)`;
- enriched `public.admin_read('course_detail', ...)` with `fee_summary` groups:
  - `cricos_registered`;
  - `provider_current`;
  - `other` for active unclassified future fee semantics;
- retained fee type, amount, currency, year, audience, basis/load basis, campus, validity, source, evidence, source snapshot and verification data.

### Migration `m1_pim_gov_fee_semantics_acl_fix_v1`

- removed direct `authenticated` execution of `public.ui_course_completeness_list(integer)`;
- retained browser access through the governed `public.admin_read` boundary.

Repository mirrors:

- `supabase/production-migrations/056_m1_pim_gov_fee_semantics_read_contract.sql`
- `supabase/production-migrations/057_m1_pim_gov_fee_semantics_acl_fix.sql`

No canonical Provider/Course identity and no canonical fee observation was rewritten by these corrections.

## 7. RPC UAT

UAT used an existing assigned Platform Admin identity in a bounded transaction context.

### 7.1 `121174E`

`public.admin_read('course_detail', ...)` returned:

- 3 `fee_summary.cricos_registered` observations;
- Tuition AUD 132,900;
- Non-Tuition AUD 0;
- Estimated Total Course Cost AUD 132,900;
- `fee_year=NULL` retained;
- source/evidence/snapshot/verification/validity metadata present;
- `provider_current=[]`;
- `other=[]`.

**Result:** PASS.

### 7.2 CRICOS vs Provider-current separation

Bounded comparison Course `102784C` returned:

- CRICOS registered tuition: AUD 47,495, `registered_total_course`;
- Provider-current tuition: AUD 60,952, `indicative_annual`, fee year 2027;
- three CRICOS fee rows retained;
- no unclassified `other` fee rows.

Bounded comparison Course `111279A` showed:

- CRICOS registered tuition: AUD 74,880;
- Provider-current tuition: AUD 37,440 annual, fee year 2027.

**Result:** PASS — two semantic classes remain separate even when both are present for one canonical Course.

## 8. Admin operational completeness UAT

On the first 5,000 rows returned by the corrected Admin projection:

- canonical fee present: 4,207 rows;
- the signal is now based on accepted `catalogue.course_fees` relationships rather than intentionally blocked Search fee flags;
- score range in the sample: 0–50.

No active Course-specific `pim.completeness_profiles` profile was present during this audit. The compatibility score is therefore explicitly treated as **derived/display-only presence**, not truth, approval or Search publication readiness.

**Result:** PASS for semantic separation; a future governed completeness profile remains a separate design task.

## 9. Security boundary UAT

Post-fix privilege checks:

| Check | Expected | Result |
|---|---|---|
| `authenticated` direct EXECUTE on `public.ui_course_completeness_list(integer)` | false | PASS |
| `authenticated` EXECUTE on governed `public.admin_read(text,jsonb)` | true | PASS |
| role-checked private fee helper callable through governed path | true for assigned role | PASS |
| `public.admin_read('courses', {'limit':5})` under assigned Platform Admin identity | 5 rows | PASS |

The security advisor no longer reports the corrected completeness function as a directly exposed browser-definer surface.

Other legacy `ui_*` SECURITY DEFINER / RLS / Auth advisor findings remain pre-existing PIM-hardening debt. They were not introduced by this change and are not silently closed by this UAT.

## 10. Documentation/governance outputs

- `docs/coursefinder-pim-admin-guide-v1.0.md`
- `docs/coursefinder-zoho-consumer-contract-v1.0.md`
- this UAT record
- `CF-CHG-20260820-001`
- central `change-control/REGISTER.md`

## 11. Frontend/browser acceptance criteria — pending

The implementation/UI workstream must complete and browser-verify all of the following before final closure:

1. visible Course grid label clearly identifies the compatibility amount as **CRICOS tuition (total course)** or equivalent;
2. fee amounts use explicit NULL checks so numeric `0` is displayed, not converted to `—`;
3. Course detail shows human labels for `Tuition Fee`, `Non-Tuition Fee` and `Estimated Total Course Cost`;
4. CRICOS `fee_year=NULL` is displayed semantically as **Not supplied by source**, not as an error and not silently invented;
5. Provider-current fees remain a separate section with an explicit empty state where absent;
6. fee drill-down exposes source/evidence, source snapshot, last verified, validity and campus scope where present;
7. any `fee_summary.other` observation is surfaced as **Needs semantic review** rather than being presented as CRICOS or Provider-current;
8. visible UI version is incremented for the frontend release;
9. browser UAT verifies CRICOS `121174E` end-to-end using exact code identity.

## 12. Rollback

If the read-contract correction must be rolled back:

- restore the prior `public.admin_read` wrapper and `public.ui_course_completeness_list` definitions from the preceding governed migration;
- drop/revoke the private fee-summary helper if no longer referenced;
- restore prior ACL only if explicitly authorised by security governance.

Canonical `catalogue.course_fees` rows do not require rollback because this change does not modify their data.

## 13. Verdict

**DB/RPC semantic gate: PASS**  
**Canonical identity/data preservation: PASS**  
**CRICOS vs Provider-current separation: PASS**  
**Zero/NULL semantics: PASS at storage/RPC**  
**Governed Zoho semantic contract: PASS for definition; not consumer-admitted**  
**Frontend/browser semantic gate: PENDING**  
**Overall `M1-PIM-GOV` first walkthrough: IN PROGRESS — not yet full PASS**
