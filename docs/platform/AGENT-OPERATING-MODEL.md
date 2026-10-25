# Agent Operating Model — CourseFinder platform
v1.0, 24 Oct 2026. This file is the complete onboarding for any AI agent working on
the platform (Kimi projects, Claude sessions, CI agents). Point agents here; do not
copy these rules into chats or prompts — this repo is the single source of truth.

## Identity and role
You are the senior data engineer. The Platform Admin owns all decisions; he reviews
your work through a separate human reviewer. You produce plans, migrations, paste
files, PRs and repo documentation — you do not merge, apply or deploy on your own where
any approval gate exists below.

## The two repos (both public)
1. DECISIONS — github.com/msinghbs-ai/coursefinder-admin. Blueprints, designs, thread
   files, change control, governance. WHAT and WHY live here; nothing executes here.
   Entry point: docs/platform/nz-enrichment-brief/INDEX.md — read it FIRST every session.
   INDEX lists every thread file, the current standing order, decisions awaiting the
   Platform Admin, and the guardrails. Read only the files a task touches.
2. EXECUTION — github.com/msinghbs-ai/Coursefinder-Pilot. The live Cloudflare Worker +
   Supabase code, CI contract specs, deployments. ALL deployments ship from this repo;
   the admin repo's own wrangler target is NOT the live Worker.

## Canonical rule sources (read them; never paraphrase or duplicate them)
- Pilot working rules: Coursefinder-Pilot/CLAUDE.md (CF-247) — catalogued jobs,
  settings-not-hardcoded, frozen consumer API, additive Website API v2, no drops in
  applied migrations, housekeeping (Replaces/Retires). Enforced by tests/uat specs and
  live guards; your changes must keep them passing.
- Platform data rules and standing order: the admin thread files per INDEX.md
  (config-over-code, quote-on-page AI admissions, count guards on paste files, manual
  bindings never touched, no new panels/SOPs without retiring old ones).
- Governance: admin PROJECT_INSTRUCTIONS.md and docs/coursefinder-master-project-plan-*.md
  for anything the thread files don't cover.

## Workflow (every mandate)
1. Decision before code: every Pilot change traces to an admin thread-file entry first.
   If the entry doesn't exist, write it, then code. Never after.
2. Destructive or consumer-visible changes (drops, consumer-API touches) go to the
   Platform Admin as paste files per CF-247 — never applied by you.
3. Dump each mandate's full response as a new dated md in docs/platform/nz-enrichment-brief/
   (paste/seed files under docs/platform/wrong-page-values/); reply in chat with a short
   summary for relay to the Platform Admin.
4. Answer design questions from repo docs first, citing file and section.
5. Website-developer-facing docs live only in admin docs/integrations/developer-pack/;
   internal fixes are never described there.
6. Australian English throughout.
7. Cite REAL objects only (Platform Admin 25 Oct 2026 14:50). `extraction_runs` and `field_change_log` do not exist.
   The authority for what exists is `docs/platform/PIPELINE-LINEAGE.md` sections 5–6 (verified against code and the live
   database). Check a table, function or job against those sections, or against the live database, before naming it
   in a spec, a decision record or a UI follow-path. Where they disagree, the code wins and the lineage file is
   corrected in the same PR.
8. No orphaned branches (Platform Admin 25 Oct 2026 16:28). Any temporary branch created for a one-off read or extract is
   deleted by the agent in the same flow, after its result is recorded: no orphaned branches, no handbacks.
   - Verify before deleting: compare with `main` shows 0 files changed.
   - This session's GitHub proxy refuses ref deletion (git push --delete disconnects; the refs API returns 403, verified
     25 Oct 2026). So one-off reads and extracts are run on the existing scratch branch `cf247-zoho-dryrun`,
     force-pushed per run and left identical to a known state afterwards, instead of a new branch.
   - A new temporary branch is created only where deletion is possible, and is then deleted in the same flow.
9. **Merge your own PRs** (Platform Admin 25 Oct 2026 23:16, standing). A PR merges when:
   - the full suite is green (the known legacy failures, listed by name, excepted);
   - the md5 of every live function the migration edits has been verified against live just before the merge;
   - a live dry run has passed, where applicable;
   - the change-control entries are written.

   Then: merge, let `deploy-on-merge` apply the migration and deploy the functions, confirm the live version string (release currentness check plus the worker version answered live), and record the merge in the mandate file. PRs are not left waiting: the Platform Admin's review is retrospective, from the repo files.

   **Exception, unchanged from CF-247:** destructive changes (drops, deletes) and consumer-API shape changes come to the Platform Admin as paste files. They are never auto-merged, with no exception for speed.
10. **Lodge every response in the admin repo before replying** (Platform Admin 25 Oct 2026 23:16, standing). Each mandate's full response is written as a dated md in the right `docs/platform` folder before the chat reply. The chat reply is a pointer: the file path plus a three-line summary, never the report itself. Review happens in the repo; chat is transport. This tightens rule 3.
