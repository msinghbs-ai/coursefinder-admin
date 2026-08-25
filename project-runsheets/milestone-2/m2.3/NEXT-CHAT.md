# M2.3 Next Chat Continuation Prompt

Copy/paste the block below into the next CourseFinder chat.

---

**M2.3 — CONTINUE FROM REPOSITORY RUN SHEET**

Before doing any work, read `PROJECT_INSTRUCTIONS.md` in `msinghbs-ai/coursefinder-admin`, then follow all referenced current governance documents and applicable Change Controls.

Also read, in full:

- `project-runsheets/README.md`
- `project-runsheets/milestone-2/m2.3/RUNSHEET.md`
- `project-runsheets/milestone-2/m2.3/CURRENT-STATE.md`
- this `NEXT-CHAT.md`

Do not rely on prior chat history as project state. Do not rely on SHAs, migration names, run numbers, counts or assumptions in this prompt where newer accepted repository, deployed Supabase/runtime, CI/UAT or Change Control state exists. Reconcile current GitHub and deployed state first and inherit newer parallel work rather than overwriting or regressing it.

The immediate continuation is outcome-oriented and must proceed autonomously in dependency order:

1. Re-read/reconcile the actually deployed version of `m2_3_non_exposed_browser_bridge_hardening`; if Pilot migration source differs from deployed SQL, restore the exact deployed SQL to Pilot migrations before further semantic changes.
2. Rerun Supabase Security Advisor and verify the new public `SECURITY DEFINER` WARN findings are gone; retain evidence.
3. Rerun Performance Advisor; retain evidence and address only findings that are in-scope/material to this gate.
4. Rerun Onboarding, Important Date, private-helper, anonymous and rank rollback-only contracts against the final bridge architecture.
5. Reconcile Pilot `main`, builds and deployed UAT after `5a129b47…` and every subsequent frontend/test commit. Treat current repo/runtime as authoritative.
6. Reproduce, diagnose and fix the inherited deployed Layer 2 `course_filters`, navigation and performance failures. Do not mask failures by weakening tests.
7. Complete Layer 4 rollback UAT for all six terminal actions and prove Search signals change only after an accepted canonical change.
8. Complete Layer 3 zero-call, revalidation, private-helper, Edge-auth and secret-leakage regression coverage.
9. Complete Layer 1, Layer 2, Evidence, Search and Publication regressions.
10. Rerun permanent deployed desktop and mobile UAT after all fixes.
11. Update CF-CHG-20260825-036, CF-CHG-20260825-037 and CF-CHG-20260825-038, `change-control/REGISTER.md` and the Running Build so they reflect the actual final migrations, Admin implementation, deployed state and CI/UAT outcomes.
12. Continue remaining CF-CHG-036 acceptance work: production-grade Layer 1/2 operations, QILT/PRISMS, Scholarships/Scholarship Selection and guide acceptance.

Automated UAT is the default. Execute database/API/security/deployed-browser UAT autonomously wherever technically possible. Do not ask me to perform routine technical UAT that can be automated. Only hand over a gate as **PASS**, **BLOCKED with evidence**, or **explicitly DEFERRED**.

Before ending the chat, always:

- append a meaningful execution block to `project-runsheets/milestone-2/m2.3/RUNSHEET.md`;
- replace stale state in `CURRENT-STATE.md` with reconciled current truth;
- rewrite `NEXT-CHAT.md` to the exact next dependency-ordered continuation;
- update applicable Change Controls/governance documents when programme state materially changed.

The goal is that the following chat can continue from the repository alone without referring back to this conversation.

---
