# CF-CHG-20260901-062 — Course Skills, Career Pathways & Labour-Market Intelligence

**Status:** DESIGN ACCEPTED / IMPLEMENTATION PENDING  
**Opened:** 1 September 2026, Australia/Melbourne  
**Primary category:** 10-architecture-data-model  
**Milestone:** M2.5 platform maturity  
**Origin:** CourseFinder project chat — Jobs/skills intelligence addendum

## Problem / opportunity

CourseFinder needs to present international students with skills developed by a Course and related career/job information for Australia and New Zealand. A naïve scalar jobs/skills field would collapse distinct sources, taxonomies, time periods and claims and could manufacture outcomes.

## Decision

Adopt Execution Addendum A17 and the governed relational model documented in:
- `project-runsheets/milestone-2/EXECUTION-ADDENDUM-A17-COURSE-SKILLS-CAREER-LABOUR-MARKET-INTELLIGENCE.md`
- `docs/coursefinder-course-skills-career-labour-market-design-v0.1.md`
- `docs/coursefinder-career-skills-demo-operator-guide-v0.1.md`
- `docs/coursefinder-career-skills-implementation-guide-v0.1.md`

## Semantic before / after

Before:
- no accepted canonical Course→skills→occupation→market model;
- no governed AU/NZ source adapter design;
- career statements risk being treated as Course scalars.

After:
- separate Course-developed skills, occupation skills, career pathways, market observations, registration and migration policy;
- AU canonical occupation identity uses OSCA; NZ uses NOL where available;
- native ANZSCO observations remain explicitly versioned during transition;
- all mappings and time-series observations preserve Evidence/provenance.

## Affected surfaces

- architecture/data model;
- Layer 1 reference ingestion;
- Layer 2 enrichment;
- Layer 3 interpretation;
- Layer 4 review;
- Course blade;
- comparison UX;
- Search/API/Website/Zoho consumer projections;
- guides/UAT.

## Source authorities

See A17/design source register. Official primary sources include ABS, Jobs and Skills Australia, Stats NZ, NZ Tertiary Education Commission/Tahatū, Immigration NZ and first-party education/accreditation sources.

## Implementation gate

Design only at this change. Implementation must:
1. create schema/migrations with RLS/grants;
2. build bounded source adapters;
3. run reference/concordance UAT;
4. build Course evidence extraction;
5. benchmark Layer 3 mappings;
6. implement Layer 4 review;
7. implement Course blade/Compare;
8. pass desktop/mobile/security/API budgets;
9. separately approve consumer publication.

## Security/privacy

No personal job-seeker data is required. Private Evidence remains inaccessible to public consumers. AI/provider secrets remain server-side. Migration data is policy reference, not personalised immigration advice.

## Rollback

Until implementation, rollback is documentation removal. Once schema/adapters exist, owning implementation Change Controls must provide migration/feature-gate rollback and preserve Evidence/history.

## Closure criteria

Close only after an implementation Change Control records migrations/commits, bounded AU+NZ UAT, browser UAT, security/ACL tests, performance/payload tests, guide updates and consumer-publication disposition.
