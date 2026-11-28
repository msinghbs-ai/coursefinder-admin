# S1-Data-Gaps: fee reconciliation and country-neutral identity (28 Nov 2026, evening)

**Instruction:** `PC-20261128-EVENING-COUNTRY-NEUTRAL-CLOSURE` (with `PRODUCTION-COMPLETION`); Admin #1293 comment 7234089440, mandate #1271.
**Written:** 28 Nov 2026 16:10 AEDT. **Method:** read-only queries and rolled-back fixtures through the dry-run route. No production write, no Pilot change, no migration, no new table, no Firecrawl, no container, US$0.

## 1. Fee reconciliation (AU, live read)

| Check | Result |
|---|---|
| Registered rows: tuition / non-tuition / total | 27,043 / 27,043 / 27,230 (reproduces Programme Control's counts) |
| Tuition + non-tuition equals total | 26,996 |
| Sums that differ | 47: all have tuition 0 and non-tuition 0 with a positive registered total |
| Zero non-tuition | 7,005: valid zero component, keep |
| Total only (no itemisation) | 187; 5 also carry a provider-current annual fee that the consumer already serves |
| Annual/indicative basis alias overlap | 1 same-year group (indicative_annual vs total_indicative), distinct components; 31 courses carry more than one provider basis across years |
| Semantic duplicates (`security.course_fee_dedupe_v1`, proof mode) | 0 |
| Tuition rows on inactive-lifecycle courses | 1,521 (explains 27,043 against 25,522 on active courses) |

**Classification.** The 47 are totals published without itemisation, not proven errors. A total is not tuition, so it is not copied into tuition, not summed twice and not turned into an annual figure without proven load and duration. The consumer already returns tuition as null for them (fail-safe). The 187 need official source evidence. The multi-basis courses are served one basis at a time, and a derived annual is labelled `annual_is_derived` (sampled: a 30,000 total shown with a derived 15,294 annual and the basis label `total_indicative`).

**No correction is proposed.** Source proof comes first, through the existing routes: a stored PDF container read, or an on-demand Firecrawl request, then the authorised correction and supersession path with locks and audit preserved. CRICOS facts were not deleted, overwritten or double-counted.

## 2. Country-neutral identity

Live read (all counts are 0 unless stated): registration scheme against provider country mismatches; registration `country_id` mismatches; active fees with null currency; active fees whose currency differs from the country default; CRICOS registrations outside AU; active AU courses without CRICOS; non-AU rows using AU-only fee types. 220 active registrations use scheme codes that are not in `ref.registration_schemes` (list gap, detail pending). NZ and CA use scheme-keyed registrations and local currency; CA shows registration is optional (3,538 of 3,829 active courses have no code). Identity runs through `ref.countries`, provider country and registration scheme plus code. No CRICOS-only mandatory field and no AU default were found outside AU.

**Contract fixtures (rolled back).** Programme Control has not named the two future destinations, so GB (`uk_hesa`, GBP) and IE (`ie_qqi`, EUR) were used as stand-ins. Neither is activated.

| Fixture | Result |
|---|---|
| GB and IE provider, course, registration, fee | Accepted without CRICOS and without any new table; dedupe proof 0 |
| Invalid currency code | Rejected by the foreign key |
| Duplicate alias row | Handled by the one-current trigger |
| CRICOS registration on a GB course | **Accepted** (`never_mixed_with` is not enforced) |
| NULL currency | **Accepted** |
| AUD fee on a GB course | **Accepted** (no country-currency guard) |

No live row is affected today. The three accepted cases are one reusable technical gap for S1-Build and S1-RM-Design: enforce them through the existing triggers when a new country is admitted. No country-specific table or migration is needed to add a destination.

## 3. Footprint and holds

Code, migration and database delta: none. Spend: US$0. Holds: official source evidence for the 47 and 187 (S1-Build, stored container read or on-demand Firecrawl); the two fixture countries to be named by Programme Control; plus the standing S1-Data-Gaps holds in the coordination document (CQU 084516K, CDU 107256J, SAIBT 081518K, TAFE 2027 fee selection, Federation 2027 fee, UNE s1334, Adelaide identity, WSU 064020M, RMIT 077512F, S1-DG-8).
