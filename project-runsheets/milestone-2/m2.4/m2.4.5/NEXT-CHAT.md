# M2.4.5 NEXT CHAT

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
