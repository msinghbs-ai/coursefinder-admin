# M2.4.6 CURRENT STATE

**Status:** ACTIVE — ADMISSION-FIRST PRODUCTION OPERATIONS MODEL  
**Reconciled:** 2026-09-15 AEST  
**Accepted Pilot baseline:** `e62c01cadaf43efa8c3d8ea57625c23874d1b010`  
**Visible accepted release:** v2.15.79 / package 0.1.6  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 paused until M2.4.9 GO

## Current decision

M2.4.6 is not an open-ended logic-hardening exercise. The active priority is to keep safe deterministic admission moving and hand consumer-ready data to the website team as soon as it passes existing authority/Evidence/Search gates.

A new issue blocks the gate only if it directly prevents safe deterministic admission, required security/identity/Layer authority, Search/API correctness, or bounded recovery from an active failure. Other improvements are deferred to their owning later gate.

See `EXECUTION-PRIORITY.md`.

## Runtime admission completed in this reconciliation

Existing accepted CF-245 functions were reused; no new admission semantics were introduced.

Official URL admission:

- 272 latest qualified candidates checked;
- 269 eligible/applied;
- 122 canonical changes;
- governed Search projection applied 122 changed rows;
- current website/Search official-course-URL coverage: **527**.

Website consumer verification:

- `website-integration-v3.1-pilot` runtime search with `has_link=true` returns total **527**;
- returned records include official course URL, regulatory tuition, intake summary, English summary and explicit provider-current-tuition null/value semantics;
- this confirms the newly admitted URL data is already available through the website consumer contract.

Observed Evidence replay:

- current replay preview selected 465 observed records;
- additional deterministic intake candidates: **0**;
- additional deterministic English candidates: **0**;
- provider-current-tuition candidates requiring Layer 3 validation: **457**.

Therefore intake/English replay is currently exhausted and must not be repeatedly reworked. The 457 ambiguous tuition candidates are a separate Layer 3 workstream and do not block website handover of already-admitted fields.

## Dispatcher/operations reconciliation

Existing runtime already provides server-owned/rank-gated wave dispatch, qualified-scope checks, wave-size clamping, per-profile serialization, continuation scheduling, stale recovery, Evidence/telemetry and explicit NZ Course-enrichment blocking.

Demonstrated improvements such as request-level deduplication, shared-Evidence reuse configuration and generic retry classification remain useful, but they may become M2.4.6 blockers only if a bounded operational exercise proves they prevent safe execution. Do not let them recursively expand the gate.

## Current Search/website position

- Search courses: 33,105;
- regulatory tuition present: 26,326 plus explicit zero/source-null/not-applicable states;
- intake coverage: 487;
- English coverage: 520;
- official course URLs: **527**;
- provider-current tuition: 161;
- website-admitted scholarships: 0.

## Exact next action

Run one bounded qualified AU operational exercise using existing accepted paths. Fix only defects that actually block safe execution/admission. Then close M2.4.6 and move to M2.4.7 controlled scale; website/API handover of the current admitted dataset proceeds in parallel rather than waiting for enrichment perfection.
