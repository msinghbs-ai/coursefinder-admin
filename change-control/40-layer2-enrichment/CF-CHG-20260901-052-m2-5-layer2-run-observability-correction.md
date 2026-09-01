# CF-CHG-20260901-052 — M2.5 Layer 2 Run Observability Correction

**Status:** ACTIVE / CORRECTIVE IMPLEMENTATION  
**Category:** 40-layer2-enrichment  
**Initiated:** 1 September 2026, Australia/Sydney  
**Owner:** M2.5  
**Parent readiness gate:** `CF-CHG-20260901-049`  
**Related platform foundation:** `CF-CHG-20260901-051`  
**Closed baseline preserved:** `CF-CHG-20260830-048` remains CLOSED/PASS

## Originating defect

Operator report from the M2.5 continuation while using the accepted Layer 2 — Enrichment workspace:

- selected **State → VIC**;
- clicked **Start production enrichment**;
- scope statistics were returned;
- **Recent acquisition attempts** had no timestamp and did not visibly update;
- **Current progress** showed no Jobs and did not expose prior completed Jobs;
- **Recent managed runs** had no timestamp and did not visibly update after the action.

This is treated as an M2.5 corrective operations/observability defect. It does **not** reopen M2.4 or alter the accepted Layer 1/2 authority model.

## Live investigation evidence

Pilot project: `fxcwkweaxjtknorudmwp`.

Observed runtime:
- authenticated `layer2-sync-control` POSTs reached the Pilot Edge Function and returned HTTP 200;
- VIC subdivision: `62b431e1-444b-435f-b738-ab33031a2c73`;
- current VIC preview: 10,576 Layer 1 Courses / 609 institutions / 1 qualified Provider / 608 pending qualification or retry / 271 Courses currently carrying governed URLs;
- latest VIC qualification check `c355a098-b042-48ca-8b0d-870e3e2e8451` completed at 2026-09-01 06:02:50 UTC with `nothing_to_qualify` and zero selected Providers;
- historical VIC production wave `1bb1504d-7bad-42d9-b059-4adeaf9118c7` is terminal `completed`: 261 queueable, 42 completed, 219 failed, 6,562 missing-URL scope rows;
- the linked wave items still retain 261 distinct child Job IDs.

Root causes:
1. `security.admin_layer2_parent_runs()` projects child Jobs/Evidence only while wave-item status is `dispatched`. Once wave items become `completed` or `failed`, prior Jobs disappear from the operator projection although lineage remains in the database.
2. Layer 2 UI already receives `started_at` / `completed_at` for recent acquisition attempts and multiple timestamps for recent managed batches, but does not render them.
3. `public.layer2_background_scope_service()` labels the request `background_qualification_scheduled` even when the qualification service returns `nothing_to_qualify`; this makes a successful no-op/retry-window check look like new work was scheduled.
4. The post-action UI refresh swallows read failures, so an accepted request can be followed by stale screen data without operator-visible warning.
5. With no active parent, the UI falls back to the latest terminal parent under the heading **Current progress**, creating an ambiguous current-vs-history presentation.

## Corrective outcome

Implement a bounded correction that:
- preserves child Job/Evidence lineage after production-wave completion/failure;
- renders acquisition-attempt and managed-run timestamps;
- distinguishes an active parent run from the latest terminal production run;
- makes the action result explicit when qualification is in retry/deferred state and no new production wave is created;
- returns/displays the server observation timestamp for the action;
- surfaces post-action refresh failure instead of silently swallowing it;
- retains existing Firecrawl quota, qualification retry, authority, Evidence, Search and Publication boundaries.

## Semantic / authority impact

No canonical field semantics change.  
No Layer 1 identity change.  
No Layer 2 authority expansion.  
No Search/Publication admission change.  
No quota/retry weakening.  
No Production project/cutover authorisation.

## Planned implementation

Pilot:
- additive M2.5 migration replacing only affected secured read/background orchestration functions;
- Layer 2 operator UI correction;
- release version increment and release note;
- targeted deployed UAT covering timestamps, terminal-run Job lineage and no-op qualification feedback.

## UAT

Required:
1. SQL contract proof for terminal VIC parent: retained child Jobs > 0 after wave-item terminal states;
2. browser targeted Layer 2 UAT:
   - acquisition attempts show a timestamp;
   - managed runs show a timestamp;
   - latest terminal production run is labelled as historical/latest, not active;
   - Jobs count remains visible for the terminal VIC lineage;
   - action status distinguishes `qualification_waiting` from actual scheduled qualification/production;
3. existing Layer 2 navigation/security/Evidence path remains intact;
4. Security Advisor and Performance Advisor: 0 WARN / 0 ERROR.

Full M2.4 acceptance is not authorised or required for this corrective M2.5 change.

## Rollback

- restore the prior secured function definitions from the preceding migrations;
- revert the Layer 2 UI/version commits;
- no destructive data rollback is required because the change does not delete or rewrite retained Evidence/Jobs/canonical values.
