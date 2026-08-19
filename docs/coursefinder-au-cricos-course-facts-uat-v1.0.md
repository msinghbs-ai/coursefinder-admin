# CourseFinder AU CRICOS Course Facts UAT v1.0

**Gate:** `M1-L1-AU-CRICOS-FACTS`  
**Status:** PASS / ACCEPTED  
**Date:** 19 August 2026  
**Architecture baseline:** `docs/coursefinder-database-architecture-v2.10.30.md`  
**Accepted substrate:** 1,546 AU Providers / 26,648 AU Courses

## 1. Gate decision

The AU CRICOS regulatory Course facts completion gate is **PASS / ACCEPTED**.

The current authoritative CRICOS Courses export was audited completely, useful omitted regulatory facts were persisted against the existing canonical Course identities, and full dry-run/APPLY/replay/idempotency/completeness UAT passed.

No CRICOS Course identity was created, replaced or name-matched by this work.

CRICOS fee observations remain regulatory total-course facts only. No annual fee was manufactured and Search fee admission remains blocked.

## 2. Source snapshot and evidence

Authoritative resource:
- resource id: `48cacf69-2082-415e-9595-f17d0c3a4af0`;
- resource name: `CRICOS Courses.csv`;
- resource last modified: `2026-08-04T08:04:20.717556Z`;
- byte size: 7,408,124;
- SHA-256: `fc2f2ef81c0b3c63dd47e1b01c7e5cf22f708c892e70f71707dbb421baed6945`;
- accepted evidence id: `11e23b34-f86e-42ee-8093-a5ab70bfdfd2`;
- evidence path: `regulatory/AU/cricos/2026-08-19T07-11-08-369Z-courses.csv`.

Source reconciliation:
- nonblank source records: 26,738;
- active `Expired=No` records: 26,648;
- expired records: 90;
- active distinct CRICOS Course codes: 26,648;
- active distinct CRICOS Provider codes: 1,546.

This reconciles exactly to the accepted AU canonical substrate.

## 3. Complete CRICOS Courses field classification

| # | CRICOS field | Active populated | Classification | Accepted handling |
|---|---|---:|---|---|
| 1 | CRICOS Provider Code | 26,648 | Canonical core | Existing Provider registration identity; never rewritten by this gate |
| 2 | Institution Name | 26,648 | Source-only evidence | Denormalised Provider label retained in source evidence; canonical Provider name remains separately governed |
| 3 | CRICOS Course Code | 26,648 | Canonical core | Existing Course registration identity; exact code required for resolution |
| 4 | Course Name | 26,648 | Canonical core | Existing canonical Course title; no title matching introduced |
| 5 | VET National Code | 10,214 | Relational observation | Retained on regulatory observation; not promoted to Course identity because Provider-level duplicate code pairs exist |
| 6 | Dual Qualification | 26,648 | Relational observation | Retained as source-backed boolean |
| 7 | Field of Education 1 Broad Field | 26,648 | Source-only evidence / validation | Parent classification is derivable from accepted ASCED narrow field |
| 8 | Field of Education 1 Narrow Field | 26,648 | Relational observation + primary projection | Existing accepted primary field observation retained |
| 9 | Field of Education 1 Detailed Field | 26,648 | Source-only evidence | No new detailed-field canonical contract authorised in this gate |
| 10 | Field of Education 2 Broad Field | 1,856 | Source-only evidence / validation | Parent classification derivable from secondary narrow field |
| 11 | Field of Education 2 Narrow Field | 1,856 | Relational observation | Added as non-primary field observation where distinct; source relation preserved |
| 12 | Field of Education 2 Detailed Field | 1,855 | Source-only evidence | No new detailed-field canonical contract authorised in this gate |
| 13 | Course Level | 26,648 | Canonical core | Existing accepted Course-level mapping retained |
| 14 | Foundation Studies | 26,648 | Relational observation | Retained as source-backed boolean |
| 15 | Work Component | 26,648 | Relational observation | Retained as source-backed boolean |
| 16 | Work Component Hours/Week | 6,172 | Relational observation when valid | Typed numeric value retained; source text remains evidence |
| 17 | Work Component Weeks | 7,057 source populated / 7,053 typed | Relational observation when valid | Four negative `-1` values are not normalised into canonical numeric facts; retained in evidence only |
| 18 | Work Component Total Hours | 7,050 source populated / 7,049 typed | Relational observation when valid | One negative `-20` value excluded from typed fact; retained in evidence only |
| 19 | Course Language | 26,648 | Relational observation | Exact CRICOS vocabulary retained; no unsupported normalisation |
| 20 | Duration (Weeks) | 26,648 | Canonical core | Existing accepted duration retained |
| 21 | Tuition Fee | 26,457 | Relational observation | Exact CRICOS registered total-course tuition observation; not annualised |
| 22 | Non Tuition Fee | 26,457 | Relational observation | Distinct registered non-tuition observation; explicit zero retained |
| 23 | Estimated Total Course Cost | 26,648 | Relational observation | Distinct CRICOS estimated total-course-cost observation |
| 24 | Expired | 26,648 active rows | Explicitly excluded from this active facts APPLY | Used to bound source lifecycle; 90 expired records remain source evidence and do not mutate the accepted active substrate in this gate |

No structured source column is silently discarded.

## 4. Retention decisions

### Dual Qualification

Retained as a canonical relational regulatory observation.

Source distribution:
- Yes: 1,858;
- No: 24,790.

### Foundation Studies

Retained as a canonical relational regulatory observation.

Source distribution:
- Yes: 69;
- No: 26,579.

### Work Component

Retained as a canonical relational regulatory observation, together with valid typed work quantities.

Source distribution:
- Yes: 6,246;
- No: 20,402.

Thousands separators such as `1,000` are treated as numeric formatting only. Five genuinely negative source quantities are not converted into canonical positive values and remain available through evidence.

### Course Language

Retained as an exact-source regulatory observation. No language taxonomy normalisation is implied by this gate.

Observed values:
- English: 26,612;
- Korean: 21;
- Chinese (NFD): 6;
- Mandarin: 5;
- Chinese (NEC): 3;
- French: 1.

## 5. VET National Code identity assessment

VET National Code is useful, but it is not safe as a Course identity key in the current canonical model.

Source facts:
- populated rows: 10,214;
- distinct Provider + VET-code pairs: 10,212;
- duplicate Provider-level pairs: 2.

Verified duplicate examples:
- Provider `03009M`, VET code `BSB60120`: CRICOS Courses `108545C` and `117354B`;
- Provider `03862G`, VET code `BSB40520`: CRICOS Courses `104016E` and `117836F`.

Decision: preserve VET National Code as a source-backed relational observation and do not redefine CRICOS Course identity.

## 6. Accepted database contract

### `catalogue.course_regulatory_observations`

New private/RLS-enabled table for time-scoped regulatory Course facts. It preserves:
- canonical `course_id`;
- registration scheme/code;
- VET National Code;
- Dual Qualification;
- Foundation Studies;
- Work Component and valid work quantities;
- Course Language;
- `source_id`;
- `evidence_id`;
- `source_snapshot_at`;
- content hash;
- current/superseded/withdrawn lifecycle;
- validity and verification timestamps.

Snapshot uniqueness is governed by Course + source + scheme + registration code + source snapshot.

### `catalogue.course_fees`

Added `source_snapshot_at` so regulatory fee observations preserve the exact asserting source version.

Accepted CRICOS fee semantics:
- audience: `international`;
- currency: `AUD`;
- basis: `registered_total_course`;
- `fee_year`: `NULL`;
- annualised: **false**;
- fee types: `tuition`, `non_tuition`, `estimated_total_course_cost`.

Blank Tuition/Non Tuition fields do not create observations. Explicit zero is retained as a valid source value.

## 7. Fee completeness after APPLY

| Fee type | Active rows | Explicit zero | Minimum | Maximum |
|---|---:|---:|---:|---:|
| Tuition | 26,457 | 131 | 0.00 | 846,500.00 |
| Non Tuition | 26,457 | 7,558 | 0.00 | 211,096.00 |
| Estimated Total Course Cost | 26,648 | 74 | 0.00 | 854,000.00 |

Total accepted CRICOS registered total-course fee observations: **79,562**.

Current/year-specific Provider fee rows remain: **0**.

## 8. Full dry-run UAT

The exact hash-verified snapshot was parsed and reconciled in bounded service-role batches before APPLY.

Result:
- batches: 11;
- source rows: 26,648 active;
- matched: 26,648;
- Course identity misses: 0;
- proposed regulatory fact creates: 26,648;
- proposed fee observations: 79,562;
- secondary FoE narrow mapped: 1,856;
- secondary FoE unmapped: 0;
- invalid boolean values: 0;
- invalid fee values: 0;
- invalid typed work-number values: 5.

Pre-APPLY fact and fee counts remained zero, proving dry-run non-mutation.

## 9. APPLY UAT

Result:
- matched: 26,648 / 26,648;
- Course identity misses: 0;
- regulatory fact rows created: 26,648;
- fact updates: 0;
- fact supersessions: 0;
- fee rows created: 79,562;
- fee updates: 0;
- fee supersessions: 0;
- secondary FoE narrow mapped: 1,856;
- invalid boolean values: 0;
- invalid fee values: 0;
- invalid typed work-number values: 5.

Canonical AU Provider and Course counts remained 1,546 / 26,648.

## 10. Replay and idempotency UAT

The same source id, evidence id, SHA and `source_snapshot_at` were replayed with APPLY enabled.

Result:
- fact created: 0;
- fact updated: 0;
- fact unchanged: 26,648;
- fact superseded: 0;
- fee created: 0;
- fee updated: 0;
- fee unchanged: 79,562;
- fee superseded: 0;
- duplicate fact identity groups: 0;
- duplicate fee source-key groups: 0;
- current regulatory fact rows per AU Course: exactly 1 for all 26,648 Courses;
- annualised CRICOS fee rows: 0;
- wrong CRICOS fee currency/audience rows: 0;
- negative fee rows: 0;
- wrong fee evidence rows: 0;
- wrong fact evidence rows: 0.

Structural idempotency: **PASS**.

## 11. Secondary Field of Education UAT

CRICOS secondary narrow-field source rows: 1,856.  
Resolved source rows: 1,856.  
Missing accepted observations: 0.

Current AU primary field observations remain 26,648.

Current AU non-primary observations are 1,640 because 216 Courses assert the same narrow field in both primary and secondary positions. Those rows correctly reuse the existing source-field relation instead of creating a duplicate observation or changing primary assignment.

## 12. Edge runtime UAT

Operational worker: `layer1-au-cricos-facts-v1.0.4`.

The worker:
- uses the fixed official CRICOS Courses resource metadata endpoint;
- verifies resource name, source `last_modified`, active count and optional expected SHA;
- scans the full CSV but materialises only the requested active slice;
- resolves exact CRICOS Provider + Course identity;
- calls the service-role-only set-based fact RPC;
- writes no Search projection;
- is bounded to a maximum of 500 records per invocation.

Rejected runtime experiments:
- 5,000 records: Edge worker resource limit;
- 2,500 records: resource/discovery envelope rejected;
- 1,000 records: Edge worker resource limit.

These rejected runs performed no APPLY.

Accepted 500-record post-APPLY dry-run smoke:
- HTTP 200;
- selected: 500;
- matched: 500;
- fact unchanged: 500;
- fee observations/unchanged: 1,488;
- fact creates/updates: 0 / 0;
- fee creates/updates: 0 / 0;
- Course misses: 0;
- secondary field mapped: 40;
- exact source SHA and snapshot verified.

Operational runtime gate: **PASS at 500 records per invocation**.

## 13. Search admission boundary

`search.enrichment_gates` remains:
- projection: `courses`;
- domain: `course_fee`;
- status: `blocked`;
- approval reference: `Await M1-L2-AU-COURSE-FACTS UAT`;
- approved_at: null.

Search remains:
- Search Documents: 33,105;
- `has_fee=true`: 0.

A Search dry-run after catalogue APPLY staged 33,105 unchanged documents with `with_fee=0`.

Therefore the new CRICOS regulatory fees have **not** entered Search.

## 14. Security and performance review

- new regulatory observation table has RLS enabled and no direct client policy;
- internal write RPC remains service-role only;
- one-time Pilot nonce/platform-admin execution boundary retained;
- no new Search/public DTO exposure introduced;
- advisor review found no new blocking issue attributable to this gate;
- unrelated pre-existing Admin/PIM `SECURITY DEFINER`, Auth leaked-password-protection and general unused-index advisories remain assigned to their existing hardening workstreams.

## 15. Source-control implementation

Pilot implementation includes:
- `supabase/migrations/20260819070540_m1_l1_au_cricos_course_facts_v1.sql`;
- `supabase/migrations/20260819070817_m1_l1_au_cricos_facts_nonce_allowlist.sql`;
- `supabase/migrations/20260819071211_m1_l1_au_cricos_course_facts_set_based.sql`;
- `supabase/migrations/20260819073424_m1_l1_au_cricos_facts_safe_update_patch.sql`;
- `supabase/functions/layer1-au-cricos-facts/index.ts`.

## 16. Gate conclusion

**M1-L1-AU-CRICOS-FACTS = PASS / ACCEPTED.**

The accepted AU Layer 1 substrate remains exactly 1,546 Providers / 26,648 Courses, now with complete classified handling of the current CRICOS Courses source and governed regulatory Course facts.

Next serial data gate: `M1-L2-AU-COURSE-FACTS` for Provider-owned current Course URLs, current/year-specific fee schedules, intakes and English requirements. Search fee admission remains a later, separate gate.
