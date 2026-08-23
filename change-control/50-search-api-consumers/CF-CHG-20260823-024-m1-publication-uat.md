# CF-CHG-20260823-024 — M1 governed publication and consumer positive-path UAT

**Status:** CLOSED / PASS  
**Category:** 50-search-api-consumers  
**Initiated:** 23 August 2026 12:55 AEST (UTC+10)  
**Closed:** 23 August 2026  
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
- Open Admin PRs at initiation: none.
- Search admission `CF-CHG-20260823-023`: CLOSED / PASS; accepted `course-v3`, 33,105 AU+NZ documents, publication unchanged.
- Live `publishing.entity_states`: zero rows before this workstream.
- Live `catalogue.courses`: all 43,461 canonical Courses `unpublished` before this workstream.
- Live Search documents: all 33,105 AU+NZ Search documents `unpublished` before this workstream.
- Website API: `api.website_course_search_v2(...)`, service-role-only, published Search records only.
- Zoho candidate API: `api.zoho_course_candidates_v1(...)`, authenticated/rank-gated, published/internal Search records.
- No governed publish/unpublish RPC existed before this workstream.

## Overlap / affected surfaces

Primary category: `50-search-api-consumers`.

Cross-referenced surfaces:

- `30-admin-pim-ux` — lifecycle/publication/Search state presentation;
- `60-zoho-integration` — Zoho candidate contract;
- `70-security-platform` — publication ACL and consumer permission boundaries;
- `80-uat-release-operations` — bounded positive path, rollback and latency evidence;
- `CF-CHG-20260823-023` — accepted Search `course-v3` substrate, not reopened semantically.

A pre-existing documentation inconsistency was identified: `REGISTER.md` marked `CF-CHG-20260820-012` CLOSED/PASS while that detailed record retained older browser-UAT-pending closure text. This gate did not rely on that stale text and re-proved Admin/consumer state alignment directly.

## Accepted governed publication profile

Profile: `pilot-course-positive-v1`.

A Course may transition to `internal` or `published` under the Pilot profile only when all are true:

1. entity is explicitly approved for the profile;
2. canonical Course exists and lifecycle is `active`;
3. country is AU or NZ;
4. stable Course identity, stable Provider identity, Course title and Course code are present;
5. the Course exists in the accepted Search projection;
6. at least one governed Course Evidence relationship exists.

The profile does not manufacture Layer 2 enrichment. Truthful NZ Course URL/intake/English/current-provider-fee gaps remain gaps. The profile is a bounded Pilot transport/positive-path control, not blanket AU/NZ publication approval.

Approved UAT slice, resolved by stable key rather than title:

- AU CRICOS `102784C` — `course:cricos:00025b:102784c` — 15 governed evidence links;
- NZQA `109509` — `course:nzqa:8509:109509` — 1 governed evidence link.

Negative control:

- AU CRICOS `001942A` was Search projected/enriched with 15 evidence links but deliberately not publication-approved. Publication was rejected with blocker `not_explicitly_approved`.

## Accepted state semantics

| Governed state | Canonical / Search publication | Website | Zoho | Consumer visibility |
|---|---|---|---|---|
| `published` | `published` | `published` | `published` | Website + Zoho |
| `internal` | `internal` | `unpublished` | `internal` | Zoho only |
| `unpublished` | `unpublished` | `unpublished` | `unpublished` | neither |
| `blocked` | `blocked` | `blocked` | `blocked` | neither |

`Search ready/projected` remains independent and does not mutate publication.

## Implementation refs

Accepted Pilot source:

`msinghbs-ai/Coursefinder-Pilot@16ce78e25e78c2324e056a7b8cb6024d4a0428a8`

Pilot PR #28: `M1 publication UAT governed controls` — merged after Frontend Build run `32614972686` passed.

Live/mirrored migration ledger:

- `20260823030241_m1_publication_uat_controlled_profile`;
- `20260823030702_m1_publication_uat_zoho_projection_metadata`;
- `20260823031628_m1_publication_uat_event_profile_fk_index`.

Durable governance:

- `docs/coursefinder-publication-governance-contract-v1.0.md`;
- `docs/coursefinder-running-build-v2.65.md`;
- `docs/coursefinder-master-project-plan-v1.63.md`;
- `docs/uat/coursefinder-m1-publication-uat-technical-acceptance-2026-08-23.md`.

## Technical UAT

**PASS.** Tests completed autonomously:

- positive publication readiness for both approved Courses;
- non-approved Search-ready Course rejection;
- publish;
- republish unchanged / idempotency;
- internal visibility;
- blocked visibility;
- withdrawal / unpublish;
- explicit Search refresh;
- Website positive/negative visibility;
- Zoho published/internal visibility;
- controlled enrichment change and deterministic invalidation;
- exact enrichment restoration;
- permission boundaries;
- no Evidence/review/artifact/storage/source-id leakage in consumer DTOs;
- response latency;
- Admin state versus actual consumer visibility;
- full rollback.

Key measured results:

- unchanged republish: no new event at the checkpoint; Search dry refresh base/enrichment `0 changed / 33,105 unchanged`;
- controlled UQ intake change: exactly `1` enrichment row changed / `33,104` unchanged; base unchanged;
- restoration returned the Course enrichment/semantic hashes and global enrichment stage hash exactly;
- Website measured 38.591 ms first positive call / 2.193 ms warm;
- Zoho measured 128.941 ms first positive call / 0.693 ms warm;
- positive payload leakage scan: no governed private Evidence/review/storage/source identifiers.

During UAT two defects were found and resolved before closure:

1. Zoho candidate metadata still declared Search `course-v2`; corrected to accepted `course-v3` without DTO expansion.
2. Performance adviser identified missing FK coverage for `publishing.publication_events.profile_code`; corrected by migration `20260823031628`.

## UI / state verification

PIM Admin remains v2.12. Course detail renders a dedicated `Publication & Search state` section independently from display-only readiness/completeness. Live UAT proved Search projected can coexist with `published`, `internal`, `blocked` and `unpublished` states, with Website/Zoho channel state agreeing with actual consumer visibility.

No new visible Admin version is claimed.

## Rollback / final deployed state

The positive-path slice was fully rolled back after testing.

Final live state:

- `publishing.entity_states`: `0` rows;
- canonical Courses with publication state other than `unpublished`: `0`;
- Search Course documents with publication state other than `unpublished`: `0`;
- controlled immutable publication audit events retained: `9`;
- profile/allowlist retained as private bounded Pilot capability;
- no full-catalogue publication occurred.

Accepted Search content was restored exactly:

- base hash `cd2c8422da31f2fa298053a40563c947780ebdaf09d7b41ff983bc6ef9649d9b`;
- enrichment stage hash `fb0585a82e9fe5bc43e9d34bb0f55968846fefba3cf5cc7a41cd0523814bfd3d`;
- full hash `b4660ebc15851620bd111c82a74a19899c43a4560e5d2eb571b40e3c64bf77ee`.

## Security note

No new publication-specific security warning remains. The existing Supabase leaked-password protection warning remains governed separately under `CF-CHG-20260823-022` as a bounded Pilot exception and mandatory Production go-live gate.

## Closure

**Final status:** **CLOSED / PASS**.

M1-PUBLICATION-UAT accepts the bounded governed Pilot publication positive path and consumer contracts. It does **not** authorise broad catalogue publication or Production go-live.
