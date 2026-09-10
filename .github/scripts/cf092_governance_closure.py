from pathlib import Path

CC_PATH='change-control/30-admin-pim-ux/CF-CHG-20260910-092-scheduled-jobs-config-controls.md'

cc=Path(CC_PATH)
s=cc.read_text()
s=s.replace('**Status:** PILOT RUNTIME APPLIED / FINAL ACCEPTANCE ACTIVE','**Status:** CLOSED / PASS',1)
s=s.replace('CF-092 remains **ACTIVE / NOT ACCEPTED** until those final gates pass.','CF-092 is **CLOSED / PASS**. CF-209 remains the prior H4 rollback baseline; M2.4.5 remains active for other governed work.',1)
closure='''

## Final closure — 10 Sep 2026

- Pilot PR #66 merged to `main` at `9305eb3a004d12724ec26b6bab65e1d4b1ab2239`.
- Visible Admin release is **v2.15.76**; canonical `VERSION`, `UI_VERSION`, release-currentness metadata and HTML title are synchronized, with v2.15.75 retained in release history.
- Final pre-merge head `04cf18ca798546f9f71b786187d23b1f4b777d96`: Pilot Frontend Build `34469936532` PASS; Release History Contract `34469936531` PASS.
- Bounded PR-preview acceptance `34468684736` PASS: CF-092 source contract, deployed Scheduled Tasks/canonical navigation and the exact PR #65 QS workbook-shape regression.
- Rollback-only mutation acceptance proved unauthenticated denial, rank-3 denial and rank-4 Pipeline Operator acceptance for an exact no-effective-change schedule edit; the transaction was rolled back and left zero acceptance audit rows. Run-on-demand was not invoked merely for testing.
- Post-merge main build `34470101950` PASS; release-history contract `34470101944` PASS; Cloudflare Worker build/deploy PASS for the merged SHA.
- Post-merge deployed UAT `34470101936` attempt 1 encountered a repeatable-in-that-attempt HTTP 500 from legacy CF-102 `admin_read('course_detail')`. The same exact Course read subsequently succeeded under authenticated rank-4 runtime verification, and unchanged workflow rerun **attempt 2** completed PASS with evidence/status publication. The transient failure is retained as recovery evidence and was not hidden by weakening UAT.
- Pilot Supabase scheduler wrappers remain SECURITY INVOKER with independently rank-gated non-exposed bridges. Security Advisor remains at the known 191 INFO-only `rls_enabled_no_policy` baseline with no new High/Critical finding from CF-092.
- Production was not changed.

### Accepted operator semantics

- Scheduled Tasks is a primary **Data Operations** workspace immediately before Evidence.
- Schedule editing is available for exact bounded recurring Layer 1–3 policies with cadence bounds, optimistic concurrency and durable actor/reason audit.
- Direct **Run on demand** is limited to executable Layer 1–2 policies and creates/reuses exact bounded `manual_governed` refresh requests without changing recurring cadence or next-run time.
- Layer 3 remains Evidence/profile/model/revalidation-qualified through its native governed workflow; no generic autonomous AI run path was added.
- Browser Job reads remain through `public.admin_read`; historical Jobs are never reset or replayed from Scheduled Tasks.

### Rollback

Use CF-209 as the previously accepted H4 operational baseline if CF-092 UI/operator controls must be backed out. Preserve scheduler policies, Jobs, Evidence and audit history; do not roll back by deleting operational history.
'''
if '## Final closure — 10 Sep 2026' not in s:
    s += closure
cc.write_text(s)

reg=Path('change-control/REGISTER.md')
s=reg.read_text()
row='| CF-CHG-20260910-092 | 30-admin-pim-ux | Scheduled Tasks configuration and governed run control | CLOSED / PASS | `30-admin-pim-ux/CF-CHG-20260910-092-scheduled-jobs-config-controls.md` |\n'
if 'CF-CHG-20260910-092' not in s:
    marker='|---|---|---|---|---|\n'
    s=s.replace(marker,marker+row,1)
reg.write_text(s)

rs=Path('project-runsheets/milestone-2/m2.4/m2.4.5/RUNSHEET.md')
s=rs.read_text().replace('**Updated:** 2026-09-08 AEST','**Updated:** 2026-09-10 AEST',1)
block='''## Latest additive H4 enhancement — CF-092 CLOSED / PASS — 10 September 2026

- Prior CF-209 Scheduler/Jobs closure remains historical rollback baseline and is not overwritten.
- Pilot PR #66 merged at `9305eb3a004d12724ec26b6bab65e1d4b1ab2239`; visible Admin release **v2.15.76**.
- Scheduled Tasks is now a primary Data Operations route before Evidence with friendly schedule columns, paged policy visibility, audited editing, queue/Job results and Jobs/Evidence/Layer follow-through.
- Direct run-on-demand is bounded to executable Layer 1–2 schedules; Layer 3 remains Evidence/profile/model-qualified.
- Preview acceptance `34468684736` PASS; final-head build `34469936532` PASS; release-history `34469936531` PASS.
- Post-merge build `34470101950` PASS and deployed UAT `34470101936` attempt 2 PASS after an attempt-1 transient legacy CF-102 `course_detail` HTTP 500 that did not reproduce.
- Production unchanged; M2.4.5 remains ACTIVE for other current governed work.

'''
marker='## Latest accepted hardening/runtime gate — CF-244 / CF-241\n'
if '## Latest additive H4 enhancement — CF-092 CLOSED / PASS' not in s:
    s=s.replace(marker,block+marker,1)
rs.write_text(s)

cs=Path('project-runsheets/milestone-2/m2.4/m2.4.5/CURRENT-STATE.md')
s=cs.read_text()
block='''## CF-092 Scheduled Tasks configuration — CLOSED / PASS — 10 September 2026

- **Accepted Pilot main:** `9305eb3a004d12724ec26b6bab65e1d4b1ab2239` after PR #66.
- **Visible Admin release:** v2.15.76.
- Scheduled Tasks is the canonical Data Operations scheduler workspace immediately before Evidence; duplicate Administration Scheduling UI/route footprint is removed.
- Exact bounded Layer 1–3 schedules can be edited with optimistic concurrency and durable operator/reason audit. Direct Run on demand is limited to executable Layer 1–2 schedules; Layer 3 remains Evidence/profile/model/revalidation governed.
- CF-092 preview acceptance `34468684736` PASS; final pre-merge build `34469936532` PASS; release-history `34469936531` PASS.
- Post-merge build `34470101950` PASS; Cloudflare Worker deployment PASS; deployed UAT `34470101936` attempt 2 PASS. Attempt 1 hit a transient legacy CF-102 `course_detail` HTTP 500; unchanged rerun passed and the exact read also succeeded in runtime verification.
- Rollback-only security acceptance proved no-auth/rank-3 denial and rank-4 no-effective-change edit success with full rollback and zero residual audit rows.
- Security Advisor remains at the known 191 INFO-only RLS baseline; separate RLS remediation remains out of scope. Production unchanged.
- The 10 Sep admin-main roadmap parks generic dataset ETL / ARWU / Diversity fixtures for future work; stale continuity naming H12 as the immediate next gate is superseded. Near-term ranking continuation remains QS-focused unless newer repository/runtime truth changes it.

'''
if '## CF-092 Scheduled Tasks configuration — CLOSED / PASS' not in s:
    s=s.replace('# M2.4.5 CURRENT STATE\n','# M2.4.5 CURRENT STATE\n\n'+block,1)
cs.write_text(s)

fu=Path('project-runsheets/milestone-2/m2.4/m2.4.5/FOLLOW-UPS.md')
s=fu.read_text()
row='| M245-FU-030 | H4 / CF-092 | Scheduled Tasks configuration, audited schedule editing and bounded Layer 1–2 run control | CLOSED / PASS | PR #66 → Pilot `9305eb3a004d12724ec26b6bab65e1d4b1ab2239`; v2.15.76; preview `34468684736` PASS; post-merge build `34470101950` PASS; deployed UAT `34470101936` attempt 2 PASS after retained transient attempt-1 CF-102 failure. |\n'
if 'M245-FU-030' not in s:
    marker='|---|---|---|---|---|\n'
    s=s.replace(marker,marker+row,1)
fu.write_text(s)

nc=Path('project-runsheets/milestone-2/m2.4/m2.4.5/NEXT-CHAT.md')
nc.write_text('''# M2.4.5 NEXT CHAT

## Accepted active baseline — 10 September 2026

- Accepted Pilot `main`: **`9305eb3a004d12724ec26b6bab65e1d4b1ab2239`** after PR #66 / CF-092.
- Visible Admin release: **v2.15.76**.
- CF-092 Scheduled Tasks configuration is **CLOSED / PASS**; CF-209 remains its prior H4 rollback baseline.
- Scheduled Tasks is a primary Data Operations route before Evidence. Schedule edit is audited/concurrency-safe for bounded Layer 1–3 recurring policies. Direct Run on demand is bounded to executable Layer 1–2 policies; Layer 3 remains Evidence/profile/model/revalidation-qualified.
- Preview acceptance `34468684736` PASS; final-head build `34469936532` PASS; final-head release history `34469936531` PASS.
- Post-merge build `34470101950` PASS and Cloudflare Worker deployment PASS.
- Post-merge deployed UAT `34470101936` attempt 2 PASS. Attempt 1 encountered a transient legacy CF-102 `course_detail` HTTP 500; the exact read subsequently succeeded and unchanged rerun passed. Keep this as recovery evidence rather than weakening UAT.
- Pilot Security Advisor remains at the known 191 INFO-only `rls_enabled_no_policy` baseline; RLS remediation remains separate.
- Production unchanged; M2.5 remains a separately governed trust boundary.

## Current roadmap correction

Admin main commit `0a03167b3834bd9570586361846e6f39f8b2a672` parks generic dataset ETL architecture, ARWU and University Diversity fixtures for future work. Do **not** resume the stale H12 ARWU/Diversity gate merely because older continuity says it is next.

Near-term Statistics & Rankings work is intentionally **QS-focused** unless a newer governed Change Control/repository state supersedes this decision. Future generic dataset architecture remains roadmap-only.

## Mandatory start for the next chat

1. Read `PROJECT_INSTRUCTIONS.md` and the current-document router in `docs/README.md`.
2. Reconcile current `coursefinder-admin` main, `Coursefinder-Pilot` main, open PRs/Change Controls, current Pilot Supabase runtime and latest CI/UAT/deployment before acting.
3. Read current M2.4.5 RUNSHEET/CURRENT-STATE/FOLLOW-UPS/NEXT-CHAT plus applicable Standing Instructions/Addenda and recovery protocol.
4. Treat CF-092 as closed unless a new scheduler defect is reproduced; do not reopen CF-209/CF-092 merely to revisit already accepted work.
5. Reconcile the current QS ranking hardening/recovery state and identify the exact next open gate from repository/runtime truth. Generic ARWU/Diversity ETL remains parked unless explicitly re-authorised.

## Pickup text

> Continue CourseFinder M2.4.5 from repository/runtime truth. Accepted Pilot main is `9305eb3a004d12724ec26b6bab65e1d4b1ab2239`, visible Admin release v2.15.76. CF-092 Scheduled Tasks configuration is CLOSED/PASS; preview acceptance `34468684736`, final-head build `34469936532`, release history `34469936531`, post-merge build `34470101950`, and deployed UAT `34470101936` attempt 2 are PASS. Attempt 1's transient legacy CF-102 course_detail 500 is retained as recovery evidence. Production is unchanged. The admin-main roadmap now parks generic dataset ETL/ARWU/Diversity work; reconcile current QS-focused ranking hardening and all open Change Controls before choosing the exact next gate.
''')

wl=Path('project-runsheets/milestone-2/m2.4/m2.4.5/WORK-ITEM-LEDGER.md')
if wl.exists():
    s=wl.read_text()
    row='| 2026-09-10 21:19 | OPERATIONS | Scheduled Tasks configuration and governed run control | H4 | CF-CHG-20260910-092 | Pilot `9305eb3a004d12724ec26b6bab65e1d4b1ab2239`; v2.15.76 | preview 34468684736; deployed 34470101936 attempt 2 PASS | CLOSED / PASS |\n'
    if '2026-09-10 21:19 | OPERATIONS | Scheduled Tasks configuration' not in s:
        s += '\n'+row
    wl.write_text(s)
