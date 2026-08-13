# CourseFinder — Canada Layer 2A Postsecondary Outcomes Parser UAT v1.2

**Date:** 13 August 2026  
**Database:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`)  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.5.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.7.md`  
**Running build:** `docs/coursefinder-running-build-v2.8.md`  
**Gate result:** **AUTHENTICATED RUNTIME PARSER DRY-RUN PASS**

## Scope

Validate the Statistics Canada PSIS Layer 2A acquisition/parser path using the official WDS source without enabling canonical outcomes APPLY or permitting Layer 2A to create Provider/Course identity.

Source:
- table `37-10-0278-01`;
- PID `37100278`;
- worker `statcan-ca-psis-etl-v0.3.1`;
- Supabase function version `5`;
- `verify_jwt=true`;
- Platform Admin authorisation required.

## Runtime result

The authenticated v0.3.1 execution completed successfully.

Validated:
- WDS cube metadata POST contract — PASS;
- required PSIS dimensions — PASS;
- 248 source-side institution candidates identified;
- private metadata evidence captured with SHA-256;
- bounded WDS series probe — PASS;
- five bounded institution coordinates probed;
- all five returned real vectors/data points with WDS `SUCCESS` and response status code `0`;
- canonical Provider/Course identity writes — disabled;
- canonical outcomes APPLY — disabled;
- source Provider mapping to an existing verified IRCC-DLI Provider remains mandatory.

## Identity boundary

Layer 2A may never create or merge canonical Provider identity from a Statistics Canada institution label.

Accepted mapping path:

`StatsCan source institution member -> pipeline.source_provider_mappings -> existing canonical CA Provider with verified ircc_dli identity`

Provider identity remains:
`CA + ircc_dli + DLI_number`

Course identity remains:
`UUIDv5(verified DLI + namespaced stable local programme key)`

## UAT matrix

| Test | Result |
|---|---|
| JWT / Platform Admin route | **PASS** |
| WDS metadata contract | **PASS** |
| Required dimensions | **PASS** |
| Source institution discovery | **PASS — 248 candidates** |
| Private evidence | **PASS** |
| Bounded real series probe | **PASS — 5/5** |
| Provider identity isolation | **PASS** |
| Course identity isolation | **PASS** |
| Canonical outcomes APPLY | **LOCKED BY DESIGN** |
| Source institution -> DLI mapping | **PENDING** |
| CIP/study-level/audience transforms | **PENDING** |
| Outcomes APPLY/idempotency/integrity | **PENDING** |

## Decision

**Canada StatsCan authenticated runtime parser dry-run gate = PASS.**

The next accepted Layer 2A gate is persistence and UAT of source institution mappings to canonical IRCC-DLI Providers, followed by taxonomy transforms. No Provider, Course, Provider Outcome or benchmark identity may be created from the PSIS parser gate itself.