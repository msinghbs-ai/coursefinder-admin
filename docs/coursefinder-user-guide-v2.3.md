# CourseFinder User Guide v2.3

**Effective:** 25 August 2026  
**Status:** CURRENT — M2.2 SECURITY / SEARCH SHOWCASE  
**Supersedes:** v2.2; all unchanged M2.1 workflows remain applicable.  
**Change Controls:** CF-CHG-20260825-032, -033, -034, -035

## Current product model

CourseFinder remains an international-student Course and related-data aggregation, discovery and comparison platform. University admissions, application processing, offer processing and visa processing remain outside scope.

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Projection / Search Visibility → Publication`.

Layer 4 remains terminal. Search/publication are downstream product states, not enrichment layers.

## M2.2 security change

Layer 2 execution-policy changes still use **Layer 2 Operations**, but the browser no longer executes the privileged policy RPC directly. The authenticated save path now crosses the JWT-enforced Layer 2 configuration-control service, which re-checks role/rank before applying the change.

Users must never receive service-role credentials, Vault values or acquisition-provider credentials in browser views.

## Search / Friday showcase

The current Admin supports a coherent demonstration of:

- Catalogue Provider/Course regulatory identity;
- Layer 2 Provider-current facts;
- factual completeness and deliberately unresolved domains;
- Evidence/provenance;
- Layer 2 Operations and Provider Attempts;
- Search Projection/version/status;
- Publication state.

M2.2 also includes a bounded **server-side** Search/read preview for website-developer discussion. It is not a public website API and it does not change Publication status.

Search modes under discussion:

- exact Course code/stable-ID lookup;
- deterministic FTS;
- structured hard filters;
- vector/hybrid only after a reproducible embedding model/profile and benchmark exist.

## Presentation rules

- Regulatory tuition and Provider-current tuition are separate facts and must remain separately labelled.
- Missing Intake, English, Scholarship or fee information remains unavailable/unresolved; never infer a demo value.
- Evidence/provenance is visible in Admin workflows, but internal Evidence IDs/storage paths/review comments are not consumer website fields.
- Search relevance never establishes canonical Course identity.
- `unpublished` remains a real downstream state and cannot be bypassed merely to make a showcase appear complete.

## Supabase Pro

The Supabase organisation is now Pro. This changes entitlement, not automatic control state. Leaked-password protection is currently still disabled and remains an open security control until the managed platform reports it enabled and automated UAT verifies the state.

## Related current documents

- `docs/coursefinder-m2-2-security-production-search-showcase-architecture-v1.0.md`
- `docs/coursefinder-website-developer-search-read-contract-v1.0.md`
- `docs/coursefinder-operations-runbook-v1.3.md`
- `docs/coursefinder-milestone-meeting-2026-08-28-m2-2-showcase.md`
