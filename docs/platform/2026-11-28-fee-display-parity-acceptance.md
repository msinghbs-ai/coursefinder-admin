# Fee display, label and identity parity across AU, NZ and CA (evening closure)

S1-API-Frontend-Delivery, 28 Nov 2026 16:15 AEDT, for PC-20261128-EVENING-COUNTRY-NEUTRAL-CLOSURE (canonical command PR #1293 comment 7234089440). Read only: live database, `website_v3_course`, `zoho_v3_course`, the Portal's own database functions and the Portal source. US$0. No migration, job, table, PR to Pilot or consumer change. Fee evidence and candidate reconciliation stay with S1-Data-Gaps, field applicability and fee grain with S1-RM-Design, reader and writer tracing with S2-RM-Design, and all writes and release with S1-Build.

## Result in one paragraph

No surface double counts: Website v3 and Zoho v3 (identical payloads) serve one fee per course, never a total and never a sum of components, and the Portal says on screen that fee lines are not added together. Currency and the course-code label follow the course's own country (AUD, NZD, CAD; CRICOS course code, NZQA qualification number, Program code). The gaps are about what is not shown: 207 AU courses hold a registered total but no tuition amount, so no fee reaches Website or Zoho for them; 124 zero tuition rows reach the consumer history as zero; non-tuition and the registered total are never delivered by v3; the Portal card shows nothing for a course that holds only a registered fee while Website shows it. Two small Portal code points assume Australia when data is missing (default currency AUD, "(CRICOS)" label by fee type). None is a data error proved by source, and none needs a consumer contract change to be decided.

## Reconciliation of the live counts (active courses, 28 Nov)

The directive's figures (27,043 registered tuition rows, 47 differing sums, 187 total only, 7,005 zero non-tuition) cover a wider scope than active courses. Over active AU courses (25,703), read from `catalogue.course_fees` with basis `registered_total_course`:

| Class | Courses | What it is |
|---|---|---|
| Total equals tuition plus non-tuition | 25,481 | 19,018 with both components above zero; 6,380 with zero non-tuition; 27 with zero tuition and a positive non-tuition equal to the total; 56 with everything zero |
| Positive total, tuition and non-tuition both zero | 41 | These are the "differing sums" in this scope |
| Total only, no component rows | 181 | 166 with a positive total and 15 with a zero total |

So none of the 41 differing courses is two populated components that disagree with a stated total: each has both components at zero with a positive total, which looks the same as the 166 total-only courses. Whether the register zero means "not stated" or a true zero needs the CRICOS source row; this lane does not declare an error. Totals above zero with no tuition amount: 41 + 166 = 207. No fee at all (total zero): 71. Tuition rows with amount 0: 124 (68 of them with a positive total).

## What each surface shows (fixtures read through both consumers)

| Fixture (AU unless stated) | Canonical | Website v3 and Zoho v3 `tuition` | Portal course detail |
|---|---|---|---|
| 086056F (tuition = total, non-tuition 0) | 73,844.82 each | 73,844.82, source regulatory, annual 73,845 flagged derived | three registered lines, "not annualised" |
| 095928K (tuition and non-tuition above 0) | 113,700 + 1,095, total 114,795 | 113,700 (tuition only), annual 37,900 flagged derived | not read |
| 108686A | 57,454 + 250, total 57,704 | 57,454, annual 23,711 flagged derived | not read |
| 118175H (provider annual fee held) | registered 72,000 plus provider 46,080 | 46,080 per year, not derived | not read (the Portal source puts the provider annual fee first and registered lines under "Other recorded fee lines") |
| 069918F (tuition 0, non-tuition 0, total 18,000) | total 18,000 | null; history carries one entry of 0 | total 18,000 line and a registered tuition line of A$0 |
| 068544F (total only, zero) | total 0 | null, empty history | not checked |
| NZ 113114 | NZD 28,000 annual | NZD 28,000, label "NZQA qualification number" | not read |
| CA 0024 | CAD 15,476.78 indicative annual | CAD 15,476.78, label "Program code" | not read |

Website v3 and Zoho v3 matched byte for byte on `tuition` in the fixtures compared (086056F, 069918F, 068544F, 061750A, 000334M, NZ 113114, CA 0024). Where a provider annual fee exists it is served in preference to the registered tuition; the registered tuition stays in `tuition_history`.

## Findings

1. **No double count.** One component per course is served; sums and totals are never added (fixtures 086056F, 095928K, 108686A, 118175H).
2. **Derived annual is labelled.** `annual_is_derived: true` accompanies every annual figure computed from a registered total and duration. The Portal does not use it. The guide already states the saving estimate is marked as an estimate (Decision 247).
3. **Hidden totals.** 207 AU courses with a positive registered total and no tuition amount serve no fee on Website or Zoho. The total and non-tuition component are not in the v3 payload for any course, so a "total cost" cannot be shown there. Adding them is an additive v3 field (v3 is open before go-live; v2 stays frozen); the Platform Admin and S1-RM-Design decide whether it is wanted.
4. **Zero shown as a value.** 124 AU courses carry a tuition amount of 0 in `tuition_history` (68 with a positive total), and the Portal's "Other recorded fee lines" prints it as A$0. Data meaning (not stated or true zero) is for S1-Data-Gaps with the source row.
5. **Portal and Website differ by design for registered-only courses.** The Portal card and "Tuition per year" show only a stated annual provider fee (`portal.primary_fee_v1`); a registered-only course reads "Not recorded" there and shows the registered tuition on Website. Known rule from FB-5.1-01 (12 courses show 2027 because 2026 is indicative; about 800 indicative-only courses show no card fee).
6. **Two Portal code points assume Australia on missing data.** `money()` in `portal/src/lib/format.js` falls back to AUD when a fee has no currency; `feeLabel` in `courseDetailFormat.js` adds "(CRICOS)" by fee type, which is correct today because only AU holds registered fee types, but would mislabel a future country that holds them. Proposed as one reusable gap for S1-Build (configuration-first: take the label from the registration scheme, show no symbol when the currency is missing). No PR raised from this lane.

## Country-neutral identity and fixtures

- `ref.registration_schemes` already holds scheme, kind (course or provider registration, field of study), country and status: CRICOS, MTCU, NZQA and IRCC DLI active for AU, CA and NZ; planned rows exist for UK (HESA, OfS, QAA, UKVI), Ireland (QQI, ILEP) and the US (IPEDS) and others (first 20 rows read). Identity by country plus scheme plus code needs no new country table. Consumer code labels are data-driven (AU "CRICOS course code", NZ "NZQA qualification number", CA "Program code", with some CA courses on a StudySearch-issued code); 866 of 24,013 AU codes are not six digits plus a letter, and no code is missing in AU, NZ or CA.
- Currency symbol formatting in the Portal formatter, run in Node: AUD A$, NZD NZ$, CAD CA$, GBP £, EUR €, USD $.
- **Two future-country fixtures were not run.** The directive does not name the two countries; the roadmap (`DESTINATION-DATA-DESIGN.md` v1.11, section G) has UK, Ireland and US adapter contracts. No row was inserted and nothing was activated. Platform Admin or S2-RM-Design to name the two; the registry and formatter evidence above already show no AU-only dependency for GBP, EUR or USD display.

## Guides

The Admin platform guide (`src/guide/platformGuide.js`) says the course-page tuition and the registered CRICOS cost are two different values, and that a scholarship saving without an annual fee is estimated from the registered cost and marked as an estimate. Both agree with runtime. It does not describe the two points that differ by surface (finding 3 and 5) or zero registered amounts (finding 4). One sentence for each belongs in the next genuine Pilot release; no guide-only Pilot PR was opened (final-head CI and deploy for a text change). The NZ and CA wording in the scholarship guide (A$, NZ$, C$) differs from the Portal's CA$ symbol; to align in the same release.

## Not checked, and holds

- Signed-in Portal rendering (needs a person to sign in on the Portal), the 412 px layout, and graduate outcome value formatting (`outcomeValue` formats only the AUD unit).
- Fee components for NZ and CA in the Portal detail (only provider annual rows exist there).
- Nothing was written, unpublished or deleted. G3, locks, Layer 4, spend and cron unchanged.
