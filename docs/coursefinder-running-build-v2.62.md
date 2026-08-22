# CourseFinder Running Build v2.62

**Status:** **M1-DATA-QUALITY-READINESS CLOSED / PASS — DATA QUALITY v1.0 ACCEPTED**  
**Date:** 22 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.61.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.38.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.13.md`  
**Admin/PIM decisions:** `docs/coursefinder-admin-pim-design-decisions-v1.12.md`

## Accepted release position

Current accepted Admin runtime:

`PIM Admin v2.12 + Pipeline Ops v1.0 + Evidence v1.0 + Data Quality v1.0`

Accepted Pilot head:

`msinghbs-ai/Coursefinder-Pilot@72721c57d2a11a5fb79288c9eadf4e14602a2e14`

Visible marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · governed`

## Data Quality v1.0 accepted capability

- domain readiness instead of one authoritative equal-weight completeness percentage;
- nine states: present, source-null, not-applicable, zero, suppressed, not-yet-enriched, stale, ambiguous, rejected;
- Provider/Course/Campus/Scholarship scope;
- country/source authority preserved;
- regulatory fee kept separate from Provider-current fee;
- Search admission kept separate from publication readiness;
- one bounded overview RPC and one server-paged Exceptions RPC;
- explicit aggregate → exception → canonical entity → Evidence/Review drill-down;
- historical six-signal Course percentage retained only as `Legacy presence`.

## Accepted Data Quality numbers

AU+NZ Course regulatory fee:

- present positive: 26,326;
- source-null: 191;
- not-applicable: 6,457;
- zero: 131;
- applicable: 26,648;
- readiness: 99.28%.

Course geography: 26,614 present / 34 source-null / 6,457 not-yet-enriched / 80.39%.

Course taxonomy: 26,648 present / 6,457 not-yet-enriched / 80.50%.

## Build and deployed-browser acceptance

- Pilot PR #18 build #103: PASS;
- Pilot PR #19 label-remediation build #105: PASS;
- AU Course Catalogue: 26,648;
- all-country Course Catalogue: 43,461;
- deployed Data Quality overview: PASS;
- Regulatory fee Source-null Exceptions: 191 total, all four pages: PASS;
- canonical Course drill-down: PASS;
- real Evidence detail route to CRICOS Regulatory Snapshot/private Evidence workspace: PASS.

Final browser evidence:

`docs/uat/coursefinder-m1-data-quality-readiness-browser-evidence-2026-08-21.md`

## Security/read boundary

Supported browser path remains:

`Supabase Auth → public.admin_read(text,jsonb) → server-side role/rank check → governed internal read`

- Data Quality overview/exceptions: assigned CourseFinder role;
- Evidence / Review Queue: Curator+ rank 3;
- Pipeline Control / Jobs / Sources: Pipeline Operator+ rank 4;
- anon `admin_read`: denied;
- Data Quality private implementation helpers are not direct browser APIs.

## Performance

Accepted controlled Data Quality samples:

- AU+NZ overview warm ~836.6 ms with zero temp spill;
- 50-row AU regulatory-fee source-null page ~155.8 ms with zero temp spill;
- representative cold overview after spill removal ~4.0 s.

Two unattributed statement timeouts occurred earlier in the final broad manual-UAT session before the successful Evidence navigation. They do not invalidate the proven final path, but automated network/trace capture is now required by the follow-on `M1-UAT-HARNESS` workstream.

## Preserved programme baselines

- PIM v2.11 semantics retained in PIM Admin v2.12;
- Pipeline Ops v1.0 accepted;
- Evidence v1.0 accepted;
- Data Quality v1.0 accepted;
- AU CRICOS 1,546 Providers / 26,648 Courses;
- AU+NZ 1,955 Providers / 33,105 Courses;
- Search projection 33,105 Courses;
- accepted AU Layer 1 adapter remains `layer1-au-depth-v1.6.0`;
- no canonical identity, factual value, Search admission or publication authority changed.

Database Architecture v2.10.38 remains current because Data Quality is a governed read/operational UX addition rather than a canonical architecture change.

## Current gates

**M1-PIM-FINALISATION: CLOSED / PASS.**  
**M1-PIPELINE-OPS: CLOSED / PASS.**  
**M1-EVIDENCE-UX: CLOSED / PASS.**  
**M1-DATA-QUALITY-READINESS: CLOSED / PASS.**