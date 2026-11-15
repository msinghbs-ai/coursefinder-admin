# Working rules for this repository (coursefinder-admin)

This repository is the live single source of truth for StudySearch (formerly CourseFinder). The code is in `msinghbs-ai/Coursefinder-Pilot`; its `CLAUDE.md` holds the engineering rules (G1 to G4, housekeeping, cron dispatchers).

**Start with `docs/CURRENT-STATE.md`, then `docs/README.md` and `PROJECT_INSTRUCTIONS.md`.**

- **Two repositories, one source of truth (Platform Admin, 16 Nov 2026 09:20; mirrored from Pilot `CLAUDE.md`).** Pilot is code: migrations, edge functions, the frontend, scripts, tests and their fixtures, and documents a script generates and a spec guards. Everything a person or a new session reads is here.
  - Paste files go to `docs/paste/`; audits and scope documents to `docs/platform/` (UI audits to `docs/platform/ui-audit/`); runbooks beside the existing ones in `docs/platform/`. None of these is committed to Pilot from 16 Nov 2026.
  - Every version bump, migration, or UI or scheduler change updates and merges its documents here in the same release cycle: the design document, the SOP mirror (`docs/sops/`), `docs/UI-MAP.md`, the paste file if there is one, the test register (`docs/platform/TEST-REGISTER.md`), the component register, and `docs/CURRENT-STATE.md`. A release is not finished until that PR is merged and read back.
  - A new session starts from `docs/CURRENT-STATE.md` and the live system, not from chat history.
- **UI map and screen help (Platform Admin, 16 Nov 2026 09:04).** `docs/UI-MAP.md` is generated in Pilot (`node scripts/ui-map.mjs --mirror <this repository>`) and never edited by hand. A PR that moves, renames or folds UI controls updates the inline screen help text and regenerates the map in the same release.
- Generated documents here (`docs/UI-MAP.md`, `docs/platform/TEST-REGISTER.md`, `docs/sops/`) are replaced by their generator, never edited.
- Do not create duplicate "current", "final" or "latest" copies of a document; `docs/README.md` names the current one.
- The Supabase project is `fxcwkweaxjtknorudmwp`. The organisation's `coursefinder-demo` project is unrelated and is never targeted.
