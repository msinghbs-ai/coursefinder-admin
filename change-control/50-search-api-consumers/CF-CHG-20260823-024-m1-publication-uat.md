# CF-CHG-20260823-024 — M1 governed publication and consumer positive-path UAT

**Status:** PROPOSED / IMPLEMENTATION AUTHORISED  
**Category:** 50-search-api-consumers  
**Initiated:** 23 August 2026 12:55 AEST (UTC+10)  
**Origin chat/workstream:** `M1-PUBLICATION-UAT — Governed Publication, Consumer API & End-to-End Positive-Path Gate`  
**Owner:** CourseFinder Search/API/consumer governance  
**Change class:** Publication semantics / consumer visibility / controlled Pilot release UAT

## Requested outcome

Define and prove the complete governed path:

`canonical → publication readiness → Search refresh → publication → Website / Zoho consumer visibility`

using a deliberately bounded AU/NZ Pilot slice. Do not publish the full catalogue and do not infer publication readiness from Search projection presence alone.

## Reconciled starting state

- Admin governance head at initiation: `msinghbs-ai/coursefinder-admin@c61da6a0cb9a7af43ffae4bb2d0d09f3f2d2bb6b`.
- Pilot implementation head at initiation: `msinghbs-ai/Coursefinder-Pilot@23b2b98284a1c4e694ab37cb4d22c6d8a76b21fa`.
- Open PRs in Admin at initiation: none.
- Search admission control `CF-CHG-20260823-023`: CLOSED / PASS; accepted `course-v3`, 33,105 AU+NZ documents, publication unchanged.
- Live `publishing.entity_states`: zero rows before this workstream.
- Live `catalogue.courses`: all 43,461 canonical Courses `unpublished` before this workstream.
- Live Search documents: AU+NZ projected, all unpublished before this workstream.
- Website API: `api.website_course_search_v2(...)`, service-role-only, filters Search documents to `publication_status='published'`.
- Zoho candidate API: `api.zoho_course_candidates_v1(...)`, authenticated/rank-gated, accepts Search `published` or `internal` rows.
- No existing governed publish/unpublish RPC was present.

## Overlap / affected surfaces

Primary category: `50-search-api-consumers`.

Affected surfaces / related workstreams:

- `30-admin-pim-ux` — existing lifecycle/publication/Search presentation under `CF-CHG-20260820-012`;
- `60-zoho-integration` — existing Zoho candidate contract;
- `70-security-platform` — publication mutation ACL and consumer permission boundaries;
- `80-uat-release-operations` — bounded positive path, rollback and latency evidence;
- `CF-CHG-20260823-023` — accepted Search `course-v3` substrate, not reopened semantically.

A pre-implementation documentation inconsistency was identified: `change-control/REGISTER.md` marks `CF-CHG-20260820-012` CLOSED/PASS while its detailed record retains older browser-UAT-pending closure text. This workstream does not use that stale text as publication authority and will re-prove state/consumer alignment on the controlled slice.

## Proposed governed publication profile

Profile code: `pilot-course-positive-v1`.

A Course may transition to `internal` or `published` under this Pilot-UAT profile only when all are true:

1. entity is explicitly allowlisted/approved for this profile;
2. canonical Course exists and lifecycle is `active`;
3. country is AU or NZ;
4. canonical Course stable key, Provider stable key, Course title and Course code are present;
5. the Course is present in the accepted Search projection;
6. at least one governed Course Evidence relationship is present;
7. the requested target state is one of the governed publication states.

The profile deliberately does **not** manufacture or require the same Layer 2 enrichment coverage for AU and NZ. Missing NZ Course URL/intake/English/current-provider-fee remain truthful `not_yet_enriched` states under the existing Data Quality contract. This profile is a bounded Pilot transport/positive-path profile, not a claim that all AU/NZ Courses are production-publication-ready.

Initial approved slice, resolved by stable key rather than title identity:

- AU CRICOS `102784C` — `course:cricos:00025b:102784c`;
- NZQA `109509` — `course:nzqa:8509:109509`.

Pre-UAT evidence links: AU 15; NZ 1.

## Planned state semantics

| Governed state | Canonical / Search publication | Website channel | Zoho channel | Expected consumer visibility |
|---|---|---|---|---|
| `published` | `published` | `published` | `published` | Website + Zoho |
| `internal` | `internal` | `unpublished` | `internal` | Zoho only |
| `unpublished` | `unpublished` | `unpublished` | `unpublished` | neither |
| `blocked` | `blocked` | `blocked` | `blocked` | neither |

`Search ready/projected` remains an independent operational state and does not itself mutate publication.

## Required UAT

- profile eligibility and non-allowlisted rejection;
- publish;
- republish unchanged / idempotency;
- enrichment change and deterministic Search invalidation;
- withdrawal / unpublish;
- rollback;
- Search refresh;
- Website API visibility;
- Zoho candidate API visibility;
- permission boundaries;
- no Evidence/internal/review leakage in consumer DTOs;
- cache/projection invalidation;
- response latency;
- governed Admin publication/Search/channel state agrees with actual consumer visibility;
- full catalogue remains unpublished except the intentionally active UAT state at each step.

## Rollback plan

Rollback is bounded to the two approved Course stable keys and new publication-control surfaces:

1. transition both UAT Courses to `unpublished`;
2. refresh Search and verify Website/Zoho invisibility;
3. remove/revoke profile approvals if required;
4. if the migration itself must be reverted, drop only the new publication-control functions/tables after returning both Courses and their channel states to the pre-change state;
5. do not alter Course identity, Layer 1/Layer 2 facts, Evidence artifacts, Search enrichment gates or the remaining catalogue.

## Implementation refs

Pending.

## UAT

Pending.

## Closure

**Final status:** OPEN / PROPOSED  
**Closed at:** N/A
