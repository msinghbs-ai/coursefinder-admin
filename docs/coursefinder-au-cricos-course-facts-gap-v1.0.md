# CourseFinder AU CRICOS Course Facts Gap v1.0

**Status:** VERIFIED M1 DATA GAP  
**Date:** 19 August 2026  
**Applies to:** accepted AU CRICOS Layer 1 substrate

## Finding

The accepted AU Layer 1 ingestion correctly retains CRICOS Provider/Course identity, Course level, duration, ASCED field, Locations and Course Locations, but it does not currently persist all useful structured Course facts exposed by CRICOS.

Live Mumbai verification on 19 August 2026:
- AU Courses: 26,648;
- AU Courses with `catalogue.course_fees`: 0;
- total `catalogue.course_fees` rows: 0;
- AU Course Links: 0;
- AU Course Intakes: 0;
- AU English requirement rows: 0.

The current `layer1-au-depth` adapter maps Course identity/title, level, duration and field but does not map CRICOS tuition/cost fields.

## CRICOS facts that must be assessed for Layer 1 retention

The authoritative CRICOS Course record exposes structured fields including:
- Tuition Fee;
- Non Tuition Fee;
- Estimated Total Course Cost;
- Dual Qualification;
- Foundation Studies;
- Work Component;
- Work Component Hours/Week;
- Work Component Weeks;
- Work Component Total Hours;
- Course Language;
- Duration (Weeks);
- Field of Education values;
- Course Level;
- registration/expiry state.

Official source references:
- CRICOS open dataset: `https://data.gov.au/data/dataset/cricos`
- CRICOS live course register: `https://cricos.education.gov.au/`

## Canonical decision

A CRICOS-registered Tuition Fee is a Layer 1 regulatory/base-source observation because it is supplied by the accepted identity authority against an exact CRICOS Course code.

It must not be confused with a provider's current annual/intake/campus-specific marketed fee.

Recommended model:

`CRICOS registered fee -> catalogue.course_fees (source=CRICOS, audience=international, basis=registered_total_course, observed_at/snapshot validity)`

Later first-party enrichment may add separate rows such as:

`Provider 2027 international tuition -> catalogue.course_fees (source=provider, fee_year=2027, basis=annual/per-credit/total as stated, campus/intake validity where available)`

Provider facts supplement the CRICOS regulatory observation; they do not overwrite its evidence/history.

Non-tuition fee and estimated total course cost must retain their distinct semantics rather than being collapsed into tuition.

## Required UAT gate

1. Inventory the complete current CRICOS Courses field set from the accepted source snapshot.
2. Classify each source field as canonical core, relational observation, source-only evidence or deliberately excluded.
3. Add deterministic parsing for accepted omitted regulatory facts.
4. Map tuition/non-tuition/total cost without fabricating annualisation.
5. Preserve CRICOS source ID, evidence ID, source snapshot and observation validity.
6. Dry-run full AU and report source-populated/null counts per field.
7. APPLY bounded/full reconciliation.
8. Replay with 0 duplicate observations and deterministic changed/unchanged behaviour.
9. Confirm Search Fee readiness remains blocked until the appropriate Fee Search gate is separately accepted.
10. Update Admin completeness to distinguish `has_cricos_registered_fee` from `has_current_provider_fee` where useful.

## Programme consequence

`M1-L2-AU-COURSE-FACTS` should not begin by re-scraping fees that already exist in CRICOS.

The next AU data sequence should be:
1. `M1-L1-AU-CRICOS-FACTS` — close accepted regulatory-source omissions, including registered cost fields;
2. `M1-L2-AU-COURSE-FACTS` — first-party current Course URL, current fee schedule, intakes and English requirements, matched by accepted CRICOS identity;
3. publish separate Search readiness only after each fact domain passes its own UAT gate.
