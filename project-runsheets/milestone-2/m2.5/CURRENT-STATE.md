# M2.5 CURRENT STATE

**Status:** ACTIVE / READINESS — BLOCKED ON PRODUCTION PROVISIONING CONFIRMATION  
**Updated:** 1 September 2026  
**Change Control:** `CF-CHG-20260901-049`

## Accepted entry baseline

M2.4 is CLOSED/PASS. Do not reopen it.

Accepted Pilot:
`95f2991e97e76e644bd74f73512b8bf2725fd4b7`

Final M2.4.4 acceptance:
- build `33468512538` PASS;
- UAT `33468512515` PASS;
- desktop 75 passed;
- mobile 76 passed.

## Current programme/design baseline

- Master Project Plan: `docs/coursefinder-master-project-plan-v1.81.md`
- Running Build: `docs/coursefinder-running-build-v2.81.md`
- Platform maturity design: `docs/coursefinder-platform-maturity-design-v1.0.md`
- UAT/performance baseline: `docs/coursefinder-uat-performance-baseline-v1.0.md`
- Implementation backlog: `project-runsheets/milestone-2/m2.5/PLATFORM-MATURITY-IMPLEMENTATION-BACKLOG.md`
- Platform maturity change control: `CF-CHG-20260901-050` — APPLIED / DESIGN BASELINE

M2.4 remains CLOSED/PASS. PM-A1…PM-A12 are future controlled implementation items and do not reopen M2.4.

## Production inventory

No Production CourseFinder Supabase project exists.

Visible Supabase organisation:
- `techM` / `rszbvkqopqfvjldvfnbh`.

Because Supabase project creation is billable, tooling requires explicit organisation confirmation before cost lookup and explicit cost confirmation before project creation.

Production region is also not yet approved.

## Pilot compute / workload sizing note

The Mumbai Pilot runs under the Pro organisation and may be vertically scaled for ingestion/UAT pressure.

Sizing principle:
- benchmark Production steady-state independently from bulk ingestion;
- Website/Zoho are expected to be read-heavy API consumers with caching;
- use compact/versioned consumer bundles and invalidation rather than repeated full reference downloads;
- do not size steady-state Production solely from temporary Firecrawl + UAT contention.

## Current decision

M2.5 governance/readiness is opened. No Production resource has been created and no Pilot resource has been promoted or renamed.

## Next action

Obtain explicit confirmation of:
1. organisation (`techM` if intended);
2. Production region;
then fetch exact Supabase project cost, present it for confirmation, and only after confirmed create the clean Production project.
