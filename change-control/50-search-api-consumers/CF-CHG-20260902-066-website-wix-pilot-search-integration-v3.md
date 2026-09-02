# CF-CHG-20260902-066 — Website / Wix Pilot Search Integration v3

**Status:** IMPLEMENTED / DB TARGETED PASS — WIX HTTP E2E PENDING  
**Category:** 50-search-api-consumers  
**Initiated:** 2 September 2026 10:00 AEST (UTC+10)  
**Origin chat/workstream:** Website search integration / Wix developer handover v3  
**Owner:** CourseFinder Search/API consumer workstream  
**Related security:** 70-security-platform  
**Does not reopen:** M2.4 CLOSED/PASS baseline

## Trigger

Prepare a v3 website field/API handover for a Wix developer, provide an independently rotatable Pilot read credential, expose a bounded Website server API, and define a fast query/cache pattern without exposing Supabase service credentials or granting broad Publication.

## Accepted boundary

`Wix browser -> Wix backend web method -> website-course-api -> governed CourseFinder read RPCs`.

The Website token remains backend-only. It is distinct from Zoho and is stored in CourseFinder only as a SHA-256 verifier. No raw token is committed to source/docs.

## Implementation

Pilot migration ledger:
- `20260902000551 — website_wix_pilot_integration_v3`.

Pilot runtime:
- Edge Function `website-course-api` v1 ACTIVE;
- custom auth `verify_jwt=false` plus explicit Website token verification;
- `private.website_integration_credentials`;
- `private.website_integration_rate_windows`;
- `api.website_integration_auth_v1`;
- `api.website_integration_rate_check_v1`;
- service-only public wrappers `website_edge_auth_v1` and `website_edge_rate_check_v1`;
- normal public/anon/authenticated direct privileges revoked.

API actions:
- search;
- lookup;
- provider_options;
- filter_options;
- reference_bundle.

Rate policy:
- 60/minute per normal action;
- 12/minute for reference_bundle.

Search reuses the current governed v2 Course Search read semantics and existing Layer 4 Search-block enforcement. Exact lookup uses the accepted Website preview exact path.

## Search/performance decision

Retain exact lookup separate from deterministic FTS/search. Do not wait for pgvector. Wix query formation uses structured hard filters, 12-item paging, 250-350 ms debounce, minimum text threshold and detail-on-demand to avoid N+1 calls.

## Current Pilot coverage snapshot

Reference bundle at 2 September 2026:
- Search Courses 33,105 (AU 26,648 / NZ 6,457);
- regulatory tuition 26,457;
- Provider-current tuition 10;
- Intake 10;
- English 10;
- official Course URL 10;
- admitted Scholarship relationship 0.

Coverage is runtime metadata, not a static consumer guarantee.

## Targeted UAT

- valid Website credential hash -> true: PASS;
- invalid hash -> false: PASS;
- Website rate window -> allowed: PASS;
- Website exact preview lookup `082960F` -> Bachelor of Nursing (Honours): PASS;
- Edge Function deployment -> ACTIVE.

External HTTP E2E was not asserted because the execution environment could not resolve the public Supabase hostname. Wix backend integration must prove this first.

## Security

- no service_role/secret key/DB credential in Wix;
- no raw token in repo/document handover;
- private credential and rate tables have RLS and direct anon/authenticated/public privileges revoked;
- Layer 4 Search blocks remain server-side;
- safe error codes/request IDs only;
- Production WAF/gateway remains a later release requirement.

## Publication / future gates

This change grants no broad public Publication, Production cutover, QS/THE consumer admission, or vector/hybrid search authority.

## Documentation

- `docs/coursefinder-website-developer-search-read-contract-v3.0.md`;
- external developer DOCX/XLSX handover generated from the same semantic boundary.

## Rollback

Disable/rotate Website credential; undeploy/revert `website-course-api`; retain canonical/Search data unchanged. Consumer support tables may remain private or be dropped under a later governed rollback.
