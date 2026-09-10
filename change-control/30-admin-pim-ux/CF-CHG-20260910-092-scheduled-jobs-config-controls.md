# CF-CHG-20260910-092 — Scheduled Jobs configuration, bounded on-demand execution and run follow-through

**Initiated:** 2026-09-10 12:49 AEST  
**Milestone:** M2.4.5 — additive H4 reopening  
**Origin:** M2.4.5 — Scheduled Job Config  
**Owner:** CourseFinder Admin/PIM  
**Primary category:** Admin / PIM UX  
**Change class:** Browser-visible operational configuration + bounded privileged mutation  
**Status:** APPLIED TO SOURCE / TARGETED ACCEPTANCE ACTIVE

## Trigger / requested outcome

Revisit **Administration → Scheduling** so the operator-facing workspace has the same operational maturity and UX clarity as the rest of the Admin application:

- meaningful column naming;
- governed schedule editing;
- a safe **Run on demand** action, especially for Layer 1 / Layer 2 / Layer 3;
- cross-links to Jobs and Evidence;
- readable latest refresh queue and recent run/result history;
- UI/UX parity with canonical Administration modules;
- acceptance through targeted → bounded integration → nominated acceptance.

## Governance reconciliation

H4 Scheduler & Jobs was already CLOSED / PASS under `CF-CHG-20260905-209`. That closure deliberately did **not** add generic historical retry/replay/reset because adapter semantics differ and a generic control could duplicate ingestion or bypass governed safety boundaries.

This record is therefore an **additive H4 reopening**, authorised by the 10 September 2026 user request. It does not invalidate CF-209 and does not reopen unrelated H12/H13 ranking acceptance. The programme feature gate remains H12/H13 in parallel; this change owns only the Scheduling enhancement evidence.

## Accepted starting truth

- Pilot `main` at task reconciliation: `0705195f4667f6562225b52de922f21c6df59aaf`.
- Visible Admin release: **v2.15.75**.
- Pilot package version: `0.1.2` before this source change.
- Production remains untouched; M2.5 remains paused.
- Existing scheduler uses bounded `pipeline.refresh_policies` and queues `pipeline.refresh_requests` for Layer 1–3.
- Layer 1 and Layer 2 dispatchers already consume qualified queued refresh requests; Layer 3 retains its Evidence/profile/qualification constraints.
- Browser Job reads remain through `public.admin_read` via `api.jobs()`.
- Existing pending RLS/security task remains separate; this change must not opportunistically weaken or rewrite RLS/security to obtain a PASS.

## Before

Administration → Scheduling exposes the accepted CF-209 read-only operational surface:

- Source/entity freshness policies;
- columns `Layer / Country / Target / Class / Next due / State`;
- Targeted refresh queue;
- downstream Search refresh signals.

Operators can inspect scheduling state but cannot edit a schedule or queue an existing bounded policy on demand from this workspace. Job/Evidence follow-through is split across separate Operations pages.

## After / source implementation

Pilot source branch: `feature/m245-scheduled-jobs-config-20260910`.

Planned native Administration Scheduling surface:

1. **Schedule Configuration** with operator names:
   - Layer;
   - Country;
   - Scheduled Target;
   - Freshness Policy;
   - Cadence;
   - Next Run;
   - Schedule Status;
   - Actions.
2. **Edit schedule** for cadence / next-run / enabled state, rank gated and reason required.
3. **Run on demand** queues the same bounded target represented by the selected refresh policy. It is not a historical Job replay/reset.
4. **Latest Refresh Queue** makes trigger, target, state, queued/completed timestamps and reason/result easy to follow.
5. **Recent Job Runs** uses the governed Jobs read boundary and links to canonical Jobs and Evidence workspaces.
6. Layer 1 / Layer 2 / Layer 3 contextual links remain inside canonical Administration rather than creating competing navigation.
7. Search-refresh signals remain visible and unchanged.

## Security / authority invariants

- No browser direct table reads are introduced for Jobs.
- `scheduler_policy_control` is authenticated and requires Pipeline Operator rank (rank >= 4).
- The mutation accepts only `edit_schedule` or `queue_now`.
- On-demand execution is limited to Layer 1–3 and requires an exact existing bounded policy target.
- A duplicate queued/running request for the same bounded target is returned rather than duplicated.
- Every mutation requires a governance reason and records this Change Control.
- No generic retry/replay/reset of a historical Job is introduced.
- No implicit canonical publication, Search admission, Provider/Course identity rewrite, Evidence deletion or service-role exposure is introduced.
- Layer 3 continues to obey its existing Evidence/profile/model qualification contracts.
- Production is out of scope.

## Supabase/runtime reconciliation

Read-only Pilot inspection on 10 September 2026 confirmed:

- Pilot project `coursefinder_Pilot` is ACTIVE_HEALTHY;
- 13 Layer 1–3 refresh policies exist, of which 11 are enabled;
- `public.admin_read` is SECURITY INVOKER in deployed runtime;
- deployed `public.refresh_policy_upsert_v2` is also SECURITY INVOKER despite older migration history containing a later SECURITY DEFINER alteration.

That historical/runtime drift is **not** repaired under this change. The new mutation must be independently rank gated and its grants/advisors verified. Pending RLS/security remediation remains separate.

## Implementation references

Pilot source commits recorded so far:

- `c47a1ec1644a333836cbfd9018a9c6460340dbf5` — bounded scheduler mutation migration;
- `2ff6d18316a8c1544a5594ba28e201850cd27114` — native Scheduled Jobs React workspace;
- `caeb380da7d1b686c4bf173da1140b2b55a25d07` — package `0.1.3` candidate;
- `1be4c6fd03d53fd844f276b7aef81438607efac6` — package changelog candidate;
- `9c80519cdb0a5cd3fcca3a997f2df87d075b7ccb` — source/security contract UAT;
- `1290713265f23a4b6296591028792d580502b131` — read-only deployed UI UAT candidate.

A temporary DOM-enhancer implementation was detected as non-compliant with A2 and removed before acceptance. Native React integration is the only acceptable candidate.

## Acceptance gates

### Targeted source / security

- frontend build;
- CF-092 source/security contract;
- no direct browser Jobs table read;
- rank/anonymous negative path for scheduler mutation;
- exact bounded target / duplicate-active guard;
- no generic Job replay/reset;
- Security Advisor after DDL;
- Performance Advisor disposition if new finding appears.

### Bounded integration

- Administration → Scheduling via canonical navigation;
- friendly Schedule Configuration columns;
- Edit schedule dialog opens and requires reason;
- Run on demand control visible only to authorised operator UI state and independently enforced server-side;
- Latest Refresh Queue readable;
- Recent Job Runs readable with Jobs/Evidence links;
- Layer 1 / Layer 2 / Layer 3 links resolve to canonical workspaces;
- no browser/server errors.

### Consequential mutation validation

Use a rollback-only or no-effective-change authenticated operator test. Do not alter a live production-shaped cadence merely to demonstrate the control. Prove that an exact bounded policy can be edited/queued and that insufficient-rank/anonymous attempts fail.

### Full acceptance

Run the nominated deployed acceptance matrix once against the final candidate SHA after targeted and bounded gates pass. A later source change invalidates the candidate.

## Release/version

Browser-visible behaviour requires a new visible release after functional acceptance. Do not publish the new visible version until the final accepted source/runtime candidate is known. Canonical `RELEASES` history must be updated; a temporary currentness overlay alone is not sufficient.

## Rollback

- Revert the Pilot feature commits and restore the prior native `Refresh` Scheduling component.
- Remove/revoke `public.scheduler_policy_control` if the DB migration has been deployed.
- Existing `refresh_policies`, `refresh_requests`, Jobs and Evidence history must be retained; rollback must not delete operational history.
- CF-209 accepted read-only scheduler/job behaviour is the fallback baseline.

## Current decision

**SOURCE IMPLEMENTATION ACTIVE / ACCEPTANCE NOT YET CLAIMED.**

Do not close this record until native integration, CI/build, runtime DDL/security verification, bounded deployed UAT and release-currentness gates are complete.