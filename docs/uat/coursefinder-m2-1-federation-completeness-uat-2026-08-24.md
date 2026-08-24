# CourseFinder M2.1 — Federation University Completeness UAT

**Status:** PASS — backend/canonical UAT  
**Date:** 24 August 2026 AEST  
**Change Control:** CF-CHG-20260823-029  
**Provider:** Federation University Australia (`CRICOS 00103D`)  
**Layer 2 profile:** `au-federation-course-detail`

## Purpose

Prove the M2.1 operational chain on a third Australian university using real first-party Course pages:

`Layer 1 Course identity → Layer 2 acquire-v2 → private Native Evidence → extract-v2 → deterministic Course candidate → safety guards → governed candidate apply → canonical factual completeness`.

Search/publication was not authorised or changed.

## Cohort

Two consecutive five-Course validation batches were run, for ten Courses total. Initial canonical factual completeness for every Course was 3/8 domains = **37.5%**.

Completeness domains used in this M2.1 trial:

1. identity;
2. verification;
3. campus/delivery;
4. official Course URL;
5. Provider-current international tuition;
6. intakes;
7. English requirement;
8. description.

## Final canonical results

| CRICOS Course | Course | Final | Remaining gap(s) |
|---|---|---:|---|
| `0100646` | Bachelor of Criminology and Criminal Justice | **87.5% (7/8)** | Provider-current international tuition |
| `062139A` | Bachelor of Biomedical Science | **87.5% (7/8)** | Provider-current international tuition |
| `085212G` | Bachelor of Community and Human Services | **100% (8/8)** | none |
| `085611C` | Bachelor of Arts | **87.5% (7/8)** | Provider-current international tuition |
| `088661B` | Bachelor of Science (Honours) | **75% (6/8)** | Provider-current international tuition; English requirement |
| `089465J` | Bachelor of Education (Primary) | **87.5% (7/8)** | Provider-current international tuition |
| `115403C` | Bachelor of Physiotherapy | **100% (8/8)** | none |
| `116438F` | Bachelor of Business (Accounting) | **100% (8/8)** | none |
| `116471E` | Bachelor of Information Technology (Cybersecurity) | **100% (8/8)** | none |
| `119893C` | Bachelor of Science (Environmental Science) | **100% (8/8)** | none |

**Average:** **37.5% → 92.5%**, an evidence-backed **+55 percentage-point** canonical completeness uplift.

## Canonical fact cross-check

| CRICOS Course | URL | Provider-current tuition | Intake(s) | English |
|---|---|---|---|---|
| `0100646` | Federation Criminology course page | not yet enriched | March, July | IELTS 6.0 |
| `062139A` | Federation Biomedical Science page | not yet enriched | March, July | IELTS 6.0 |
| `085212G` | Federation Community & Human Services page | **AUD 37,800** | March, July | IELTS 6.5 |
| `085611C` | Federation Bachelor of Arts page | not yet enriched | March | IELTS 6.0 |
| `088661B` | Federation Science Honours page | not yet enriched | March, July | not yet enriched |
| `089465J` | Federation Education Primary page | not yet enriched | March | IELTS 7.5 |
| `115403C` | Federation Physiotherapy page | **AUD 40,500** | March | IELTS 7.0 |
| `116438F` | Federation Business Accounting page | **AUD 39,600** | March, July | IELTS 6.0 |
| `116471E` | Federation IT Cybersecurity page | **AUD 41,400** | March, July | IELTS 6.0 |
| `119893C` | Federation Environmental Science page | **AUD 38,900** | March, July | IELTS 6.0 |

All ten canonical descriptions are now populated from the exact first-party HTML `<meta name="description">` after Course identity confirmation. Provenance is stored through the generic PIM attribute-value model with source and Evidence IDs. Existing descriptions are not overwritten by the Layer 2 apply contract.

## Fee-safety UAT

**PASS.** Federation pages contain domestic CSP/student-contribution/Band amounts alongside international material. Extractor `layer2-course-fact-extract-v2.3+` rejects domestic/Commonwealth/CSP/Band values and low-confidence fee candidates.

The system therefore deliberately leaves five Course tuition domains incomplete rather than promoting values such as generic `$17,399` Band/CSP amounts as international tuition.

Firecrawl was used only on unresolved tuition cases. It returned richer retained Evidence but did not make the ambiguous fees trustworthy, so those domains remain unresolved and are eligible for Layer 3 interpretation/source discovery.

## Description provenance UAT

Initial implementation incorrectly attempted to use `catalogue.course_field_observations`; UAT proved that table is field-of-study taxonomy specific. Both failed apply attempts rolled back transactionally with no partial description writes.

Corrected implementation uses:

- canonical `catalogue.courses.description` only when currently empty;
- PIM attribute `course_description`;
- `pim.attribute_values` for source/evidence provenance;
- first-party meta-description only;
- identity-match required;
- Search/publication mutation explicitly false.

Final result: **10/10 descriptions present and 10/10 PIM provenance rows present.**

## Acquisition/Evidence UAT

Federation Direct HTTP first-party acquisition: **10/10 successful** after correcting one initially mistyped Environmental Science slug during cohort setup. Normal acquisition latency was generally sub-1.5s. Native Evidence is retained in the private `evidence` bucket with Source Profile Version, Job, Provider Attempt, SHA-256 and Supabase Edge runtime provenance.

Firecrawl escalation was exercised on unresolved Course facts. It produced retained structured/HTML/visual-capable Evidence but did not override deterministic safety guards.

## Layer 3 fall-out

Current unresolved Course-domain fall-out:

- Batch 1: 2/5 Courses require further interpretation/source discovery;
- Batch 2: 3/5 Courses require further interpretation/source discovery;
- total: **5/10 Courses have at least one unresolved domain**;
- Layer 4: **0/10 at this stage**.

This is domain fall-out, not Course rejection. Completed facts remain canonical and evidence-backed while unresolved domains stay `not_yet_enriched`.

## Scholarship UAT status

Study Australia Scholarship Layer 2 chain also reached detail extraction PASS during the same M2.1 acceptance period:

`listing Evidence → detail URL discovery → retained detail Evidence → normalisation → deterministic Scholarship detail candidate`.

The RGIT Scholarship for Continuing Students detail candidate was correctly separated from the Scholarship listing/search result and retained without canonical mutation.

## M1 regression

Post-UAT regression PASS:

- Search documents: **33,105**;
- Search published: **0**;
- canonical Courses: **43,461**;
- canonical unpublished Courses: **43,461**.

The frozen M1 Search/publication baseline remains unchanged.

## Admin-panel cross-check

In Admin, search Federation University Australia / CRICOS `00103D`, then verify the ten CRICOS Course codes above.

Expected Course detail values are the final canonical results in this document. Data Quality snapshot was manually refreshed after application at approximately **24 Aug 2026 12:40 AEST**, so the Admin completeness surfaces should no longer be waiting on the normal 15-minute snapshot cycle.

Evidence drill-down should show Federation Layer 2 Evidence under profile `au-federation-course-detail`, provider `Direct HTTP` for the primary accepted facts, with Firecrawl attempts visible only for bounded unresolved-case escalation.

## Gate impact

Backend/live-provider/completeness/Scholarship/M1-regression evidence is now sufficient for this portion of M2.1.

**Remaining acceptance blocker:** SHA-bound deployed authenticated desktop/mobile browser UAT for Layer 2 Platform v1.4 and the simplified Layer 2 Operations/Admin navigation.
