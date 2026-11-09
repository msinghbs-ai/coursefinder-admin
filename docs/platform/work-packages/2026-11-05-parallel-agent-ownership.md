# Parallel Claude agents: workstream ownership (from 5 Nov 2026 19:14)

Source: Platform Admin decision 5 Nov 2026 19:14, `docs/platform/2026-11-05-centralise-development-claude-parallel-agents-1914.md` (verbatim). Codex Cloud is discontinued as a contributor.

**Integration Controller: Claude (main session).** It alone:

- prioritises work, resolves dependencies and reviews changes;
- integrates branches and controls releases;
- assigns release numbers and verifies production;
- maintains the execution register and the integration queue.

Agents never merge, deploy or write to production.

## Ownership (exclusive; no two agents edit the same function, migration or file)

| Agent | Workstream | Branch / PR | Owns (exclusive) | Migration versions reserved |
|---|---|---|---|---|
| A | Developer API R23/R24: campus names and course counts; scholarship nationality status | `cf247-devapi-r23-r24` (new draft PR) | New versions or additive edits of the website v2 provider and scholarship read path; Pilot `tests/uat/` R23/R24 specs and fixture; admin `docs/integrations/` developer guide Issue 8 draft and G3 approval package | `20261106100000`–`20261106199999` |
| B | Provider descriptions: complete and integrate Codex PR #877 | `codex/provider-description-autonomy`, PR #877 (transferred to Claude) | Everything #877 touches: `supabase/functions/coverage-sweep/description.ts` and `index.ts`, provider-description functions, `src/ProviderDescriptionRunValidate.jsx`, `src/provider-description-run-api.js`, its fixtures and workflow | `20261106200000`–`20261106299999` (the #877 migration must be renumbered: `20261105010000` is already applied in production by v2.15.479) |
| C | Course Catalogue UI: customisable columns, server-side per-user layouts | `cf247-course-catalogue-columns` (new draft PR; replaces closed #886) | Course page of `src/mature-main.jsx` (`columns()`, the catalogue list component), `src/DataTable.jsx`, `src/table-resize.js`, the `useRememberedState` / `useColumnWidths` extension, `admin_read` `courses_page`, the new per-user layout table and RPCs | `20261106300000`–`20261106399999` |
| D | Intake Automation Progress UI (decision 16:36 §3–§8) | `cf247-intake-progress-ui` (new draft PR) | `src/ProcessResults.jsx`, `src/process-results-api.js`, new progress components, read-only progress and history functions, the Pause/Resume bridge to the existing job toggle | `20261106400000`–`20261106499999` |
| E | Independent validation: production-schema parity, regression and release readiness | `cf247-validation-parity` (draft PR for tooling only) | `tests/fixtures/prod-parity/`, `scripts/prod-parity*.mjs`; validation reports under admin `docs/platform/validation/` | none |

## Shared files: rules

| File or area | Rule |
|---|---|
| `src/mature-main.jsx` | C only. D does not touch it; D works inside the existing Process results screen. |
| `src/nav-map.js`, release manifest, release history, `public/release-history.json` | Integration Controller only, at integration. |
| `docs/platform/TEST-REGISTER.md` (Pilot) | Each agent regenerates it in its own PR. The Controller regenerates again when integrating. |
| `.github/workflows/*` | Agents add their own new workflow file and do not edit an existing one. Exception: B keeps #877's own workflow. |
| The intake scheduler (`intake_dates_plan_v3`, `intake-dates-apply`) | Nobody. The intake workstream is closed except for P0 issues (18:35). D reads it only. |
| Execution register and integration queue (admin repo) | Integration Controller only. |
| Production | Read-only for agents, under the load policy: heavy reads only at minutes :x6–:x8; no reads at :35–:42 or :47–:48. No writes. |

## Machine limits

The workspace has 2 CPUs and 7 GB of memory. To keep five agents from thrashing it:

- Playwright and `vite build` run one at a time under `flock /tmp/claude-0/locks/heavy.lock`.
- Each agent's local PostgreSQL databases are prefixed with its letter (`a_`, `b_`, …).
- The full governed suite runs in each PR's CI. Locally, agents run their own specs plus `s32`, `s42`, `s57`, `s120` and `s121` where relevant.

## Retained PRs not assigned to an agent

| PR | Disposition |
|---|---|
| #875 AER selector fix (held) | Retained, held under the engineering hold. E assesses its readiness against current production. |
| #879 Codex intake complete scan / preview paging | Retained, awaiting a Platform Admin decision. It addresses the 5-row Preview limit, but the intake workstream is closed except for P0 issues. Its migration version `20261105020000` collides with main (`cf247_intake_calendar_v2`). |

## Next capabilities (reserved 5 Nov 2026 20:02; implementation starts after #877 is integrated, because both touch coverage-sweep)

| Workstream | Branch (proposed) | Migration versions reserved | Discovery |
|---|---|---|---|
| Course descriptions | `cf247-course-descriptions-complete` | `20261106500000`–`20261106549999` | `work-packages/2026-11-06-course-descriptions-discovery.md` |
| English requirements | `cf247-english-requirements-complete` | `20261106550000`–`20261106599999` | `work-packages/2026-11-06-english-requirements-discovery.md` |
