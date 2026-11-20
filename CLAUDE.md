# Working rules for this repository (coursefinder-admin)

This repository is the live single source of truth for StudySearch (formerly CourseFinder). The code is in `msinghbs-ai/Coursefinder-Pilot`; its `CLAUDE.md` holds the engineering rules (G1 to G4, housekeeping, cron dispatchers).

**Start with `docs/CURRENT-STATE.md`, then `docs/README.md` and `PROJECT_INSTRUCTIONS.md`.**

- **Two repositories, one source of truth (Platform Admin, 16 Nov 2026 09:20; mirrored from Pilot `CLAUDE.md`).** Pilot is code: migrations, edge functions, the frontend, scripts, tests and their fixtures, and documents a script generates and a spec guards. Everything a person or a new session reads is here.
  - Paste files go to `docs/paste/`; audits and scope documents to `docs/platform/` (UI audits to `docs/platform/ui-audit/`); runbooks beside the existing ones in `docs/platform/`. None of these is committed to Pilot from 16 Nov 2026.
  - Existing files (paste split, 18 Nov 2026, Pilot #1248): Pilot has no `docs/paste/` folder. The paste files a Pilot spec, database fixture, workflow trigger or evidence classifier reads are byte-for-byte test fixtures in Pilot `tests/fixtures/paste/` (Pilot spec `s616`); every other paste file is here only. `docs/paste/README.md` lists every pending paste file with its md5, and names the two pending files that also have a Pilot fixture copy.
  - Every version bump, migration, or UI or scheduler change updates and merges its documents here in the same release cycle: the design document, the SOP mirror (`docs/sops/`), `docs/UI-MAP.md`, the paste file if there is one, the test register (`docs/platform/TEST-REGISTER.md`), the component register, and `docs/CURRENT-STATE.md`. A release is not finished until that PR is merged and read back.
  - A new session starts from `docs/CURRENT-STATE.md` and the live system, not from chat history.
- **UI map and screen help (Platform Admin, 16 Nov 2026 09:04).** `docs/UI-MAP.md` is generated in Pilot (`node scripts/ui-map.mjs --mirror <this repository>`) and never edited by hand. A PR that moves, renames or folds UI controls updates the inline screen help text and regenerates the map in the same release.
- Generated documents here (`docs/UI-MAP.md`, `docs/platform/TEST-REGISTER.md`, `docs/sops/`) are replaced by their generator, never edited.
- **Merging is automatic; never ask a person to merge or clean up (Platform Admin, 20 Nov 2026 17:00; s880; mirrored from Pilot `CLAUDE.md`).** Never stop and ask the user to merge a pull request or delete a branch.
  - **This repository first.** Merge the `coursefinder-admin` pull request before the Pilot one. Try `gh pr merge <n> --auto --squash --delete-branch`; when the session proxy refuses it (`HTTP 403`, GraphQL is blocked, and GitHub's own auto-merge is off in both repositories), add the `automerge` label instead (`gh pr edit <n> --add-label automerge`, or by REST `gh api repos/<owner>/<repo>/issues/<n>/labels -f "labels[]=automerge"`). Poll `gh pr view <n> --json state` (by REST `gh api repos/<owner>/<repo>/pulls/<n> --jq .merged`) until it is `MERGED` before touching Pilot.
  - **Then Pilot**, the same way, and wait until it is `MERGED` before the post-merge live checks and the Drive `Monitoring` sync.
  - **What the label does** (`.github/workflows/auto-merge.yml` and `scripts/ci/auto-merge.sh`, the script byte for byte the same in both repositories): once the pull request is mergeable and every check is green, it is squash-merged and its branch deleted; a failing check or a conflict stops the wait with a comment. Here the script then starts `Security gates` (a `GITHUB_TOKEN` merge does not start push workflows); in Pilot it also starts `Deploy on merge`, `Deployed UAT` and `Release Currentness Deployed`.
  - **Probe branches.** Never leave a throwaway branch behind. Pilot's Auto-merge workflow deletes `…-probe` and `…-diag` branches after their dry run and sweeps idle `…-probe` branches; delete any other throwaway branch yourself when you are done with it.
- Do not create duplicate "current", "final" or "latest" copies of a document; `docs/README.md` names the current one.
- The Supabase project is `fxcwkweaxjtknorudmwp`. The organisation's `coursefinder-demo` project is unrelated and is never targeted.

### Standing Mandate: Immediate Live Activation (No Unrequested Shadow or Future Deferrals)

Platform Admin, 21 Nov 2026 10:07 AEDT. Non-negotiable; it applies to every change in both repositories.

1. **Reported Bugs & Verified Fixes Ship Live Immediately:** Every reported bug fix, UI/filter fix, parser fix, or verified deterministic admission rule MUST take effect **immediately upon deploy** in the same PR.
2. **Zero Unrequested Shadow Soaks or Delayed Cutovers:** NEVER place a bug fix or verified admission rule into shadow-only mode, behind an off-by-default flag, or on a 24-hour / next-day cutover timer unless the user explicitly instructs a shadow period first.
3. **No Assumed Future Work:** NEVER defer a reported fix to "tomorrow", "a future lane", or "a follow-up PR" without explicit user confirmation. Either ship and activate the complete fix immediately in the current PR, or—if a hard guardrail conflict exists—ask the user for an immediate decision before writing deferred code.
