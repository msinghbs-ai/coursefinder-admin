# CourseFinder M1 Publication UAT — Technical Acceptance

**Date:** 23 August 2026  
**Change Control:** `CF-CHG-20260823-024`  
**Gate:** M1-PUBLICATION-UAT  
**Environment:** `coursefinder_Pilot` / Supabase project `fxcwkweaxjtknorudmwp`  
**Result:** PASS

## Scope

Prove the governed path `canonical → publication readiness → Search → publication → Website / Zoho consumer visibility` without publishing the catalogue broadly.

The controlled profile is `pilot-course-positive-v1` and requires explicit per-Course approval in addition to active AU/NZ identity, stable Course/Provider identity, accepted Search projection and at least one governed Course Evidence relationship.

Approved UAT slice:

- AU CRICOS `102784C` / `course:cricos:00025b:102784c` — 15 evidence links;
- NZQA `109509` / `course:nzqa:8509:109509` — 1 evidence link.

Negative control:

- AU CRICOS `001942A` — Search projected/enriched with 15 evidence links but deliberately not publication-approved.

## Deployed publication controls

Live migration ledger:

- `20260823030241_m1_publication_uat_controlled_profile`;
- `20260823030702_m1_publication_uat_zoho_projection_metadata`;
- `20260823031628_m1_publication_uat_event_profile_fk_index`.

Added private/service-only surfaces:

- `publishing.publication_profiles`;
- `publishing.publication_approvals`;
- `publishing.publication_events`;
- `publishing.course_publication_readiness_v1(uuid,text)`;
- `publishing.set_course_publication_v1(uuid,text,text,text)`;
- `publishing.refresh_course_publication_search_v1()`.

The Zoho DTO contract remains `zoho-course-candidates-v1`; only stale `meta.projection_version='course-v2'` was corrected to accepted `course-v3`.

## UAT evidence

| Test | Result | Evidence |
|---|---|---|
| Publication readiness positive | PASS | AU `102784C` and NZ `109509` both `eligible=true`; governed Evidence links 15 / 1. |
| Search-ready but not publication-approved | PASS | `001942A` rejected with SQLSTATE `42501` and blocker `not_explicitly_approved`; no mutation. |
| Publish AU | PASS | AU moved `unpublished → published`; Website and Zoho channels published. Search refresh changed exactly 1/2 bounded rows as transitions occurred. |
| Internal NZ | PASS | NZ `internal` remained hidden from Website and visible in Zoho. |
| Publish NZ | PASS | NZ `internal → published`; Search changed 1 / 33,104 unchanged; Website returned NZ item. |
| Republish unchanged | PASS | Repeat AU `published` and NZ `internal` calls returned no effective mutation; audit-event count stayed 2 at that checkpoint; dry refresh base/enrichment 0 changed / 33,105 unchanged. |
| Enrichment change | PASS | Existing UQ Semester-2 intake was temporarily set inactive. Dry refresh: base 0 changed, enrichment exactly 1 changed / 33,104 unchanged. Applied Search had one intake instead of two. |
| Enrichment restore / invalidation | PASS | Intake restored to its original `active` status. Enrichment hash returned exactly to `04137771a19f939611fdefcc08ad022ea6b13498f1cb5c531c79b6febea7e0a3`; semantic hash exactly to `df0a0bc59d2eb2a352ffe64453d6339590751fad37982b59cbb58084488ffa6a`; intake count returned 2; global enrichment stage hash returned exactly to `fb0585a82e9fe5bc43e9d34bb0f55968846fefba3cf5cc7a41cd0523814bfd3d`. |
| Internal state separation | PASS | Admin state: `search.projected=true`, canonical/Search publication `internal`, Website channel `unpublished`, Zoho channel `internal`; Zoho returned 1 item. |
| Blocked state separation | PASS | Admin state: `search.projected=true` while canonical/Search and both channel states were `blocked`; Website returned 0. |
| Withdrawal / unpublish | PASS | Controlled Courses transitioned back to `unpublished`; Search consumer visibility removed. |
| Website API | PASS | Published AU/NZ positive items returned only while published. Website is service-role-only and filters `publication_status='published'`. |
| Zoho candidate API | PASS | Published and internal records returned for authorised rank >=2 users; meta now reports `course-v3`. |
| Permission boundary — publication RPC | PASS | anon and authenticated users denied access to `publishing` mutation/readiness functions; service role retains execute. |
| Permission boundary — Website | PASS | authenticated user denied `website_course_search_v2`; service role permitted. |
| Permission boundary — Zoho | PASS | anon denied; authenticated no-role user received `forbidden`; authorised rank 6 succeeded. |
| DTO leakage | PASS | Positive Website and Zoho payload checks found no `evidence`, `review`, `artifact`, `storage_path` or `source_id` leakage. |
| Positive response latency | PASS | First measured Website call 38.591 ms; warm 2.193 ms. First measured Zoho call 128.941 ms; warm 0.693 ms. DB-side measurements on exact-code positive result. |
| Adviser review | PASS | No new publication security warning. Performance adviser identified one missing FK index on `publication_events.profile_code`; fixed by live migration `20260823031628`. |
| Rollback | PASS | Final channel rows 0; canonical non-unpublished Courses 0; Search non-unpublished rows 0. |
| Search baseline restoration | PASS | Final base hash `cd2c8422da31f2fa298053a40563c947780ebdaf09d7b41ff983bc6ef9649d9b`; enrichment stage hash `fb0585a82e9fe5bc43e9d34bb0f55968846fefba3cf5cc7a41cd0523814bfd3d`; full hash `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee` — exactly the accepted pre-UAT content state. |

## Admin/UI semantic verification

Current PIM Admin remains v2.12. Course detail renders a dedicated `Publication & Search state` section from the governed `state_summary`, separate from the display-only readiness section. Live state UAT proved all of the following can coexist without semantic collapse:

- Search projected + Published;
- Search projected + Internal;
- Search projected + Blocked;
- Search projected + Unpublished;
- readiness score independent of publication.

No new visible Admin version is claimed by this gate.

## Final state

The positive-path slice was fully rolled back after testing. There are no consumer-visible Course rows left published/internal/blocked:

- canonical non-unpublished Courses: `0`;
- Search non-unpublished documents: `0`;
- `publishing.entity_states`: `0` rows;
- controlled publication audit events retained: `9`;
- approved profile/allowlist retained for future bounded Pilot use;
- entire catalogue was never published.

## Security/adviser note

The existing Pilot Supabase leaked-password-protection WARN remains governed by `CF-CHG-20260823-022` and is not introduced or resolved by this gate. Existing INFO-level RLS-no-policy findings reflect the established private-schema deny-by-default posture; the new publication tables expose only service-role SELECT and no authenticated/anon table privilege.

## Acceptance

**PASS.** The complete governed AU/NZ publication positive path, state separation, consumer contracts, invalidation, security boundaries, latency and rollback are technically accepted for Pilot. This does not authorise broad catalogue publication or Production go-live.
