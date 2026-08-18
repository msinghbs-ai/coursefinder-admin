# CourseFinder Admin / PIM Design Decisions v1.5

**Status:** AUTHORITATIVE CROSS-CHAT UX / OPERATING CONTRACT  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-admin-pim-design-decisions-v1.4.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.27.md`

v1.5 retains the v1.4 Course decision-workspace standard and clarifies geography, Course Links and Fee semantics after live AU completeness revalidation.

## Course decision-workspace standard

Progressive filtering remains:

`Country -> State/Region -> Provider -> Study Level -> Field of Study -> Delivery -> data-quality/freshness -> governance status`

State/Region is enabled as an authoritative filter only from canonical Course delivery geography:

`Course -> Course Campus -> Campus -> subdivision`

Provider postal/primary subdivision is not a substitute for Course delivery State/Region.

## Required quality/readiness dimensions

Expose separately:
- Has Campus / Missing Campus;
- Has State/Region / Missing State/Region;
- Has Course Link / Missing Course Link;
- Has Fee / Missing Fee;
- Has Intake / Missing Intake;
- Has English requirement / Missing English requirement;
- Has Scholarship / Missing Scholarship;
- minimum completeness;
- Never Verified / stale verification;
- Lifecycle / Publication.

A missing value means the canonical structured-data relation is absent. It is not a claim that the real-world course lacks that fact.

## Related-record navigation

Course rows/drawers should cross-click into condensed related records for:
- Provider;
- Locations/Campuses;
- Links;
- Fees;
- Intakes;
- English requirements;
- Scholarships;
- Evidence;
- accepted outcomes/student-flow observations where relevant.

`Locations` and `Links` are different concepts and must not be labelled interchangeably.

## Geography display

### Provider

Show separately:
- **Primary/Postal geography** — only direct authoritative Provider geography stored on the Provider;
- **Campus coverage** — distinct canonical State/Region values reached through Provider Campuses.

For multi-state Providers, campus coverage is the operational geography used for Course availability/filtering.

### Campus

Display canonical State/Region only when `subdivision_id` is populated from an accepted source mapping.

Do not silently translate city/postcode/address text into State/Region in the browser.

### Current AU state

Until the bounded CRICOS geography replay gate passes, AU may legitimately show State/Region as missing even though the source location address contains State text. The UI must reflect canonical truth rather than frontend inference.

## Course Links display

`catalogue.course_links` is the multi-link source-of-truth.

Course workspace should group links by semantic type, for example:
- Primary Course Page;
- International Course Page;
- Handbook / Course Guide;
- Fees;
- Apply.

Show source/freshness/evidence status where useful. `courses.course_url` is a compatibility/current-primary field and should not be presented as the complete link model.

## Fee display

Fee rows are temporal observations. At minimum show:
- audience;
- year;
- amount + currency;
- fee type;
- basis/load basis;
- optional campus scope;
- source/freshness.

Do not collapse multiple valid fee observations into one number without a defined selection rule.

For the international-student product experience, the preferred current fee may later be selected by an explicit consumer contract using audience + year + basis + campus context.

## Automation/work-queue rule

The preferred enrichment loop remains:

`detect missing/stale -> acquire authoritative source -> resolve canonical entity -> extract -> compare -> auto-apply deterministic evidence-backed facts -> queue ambiguity -> verify -> update completeness`

Priority AU work queues now include:
- Missing Campus State/Region;
- Unmapped published State token;
- Missing Course Link;
- Missing International Fee;
- Stale Course Link;
- Stale Fee;
- Ambiguous provider/course page mapping.

No job may fill these queues by guessing state, fee or URL from unrelated fields.
