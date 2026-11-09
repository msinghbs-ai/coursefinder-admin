# Work package: Course Catalogue customisable columns and data freshness

| Item | Value |
|---|---|
| Mandate | `docs/platform/2026-11-05-course-catalogue-columns-freshness-1731.md` (Platform Admin, 5 Nov 2026 17:31, verbatim) |
| Allocation | Platform Admin, 5 Nov 2026 19:00: "allocate it as an independent Codex-compatible vertical feature immediately, without waiting for further intake automation work" |
| Developer | **Reassigned 19:14:** Claude agent C (Course Catalogue UI), branch `cf247-course-catalogue-columns`. Codex Cloud discontinued (decision 19:14). Read "Codex" below as agent C. |
| Integration Controller | Claude: independent review, production-schema verification, merge and release only after the normal gates and Platform Admin authorisation |
| Branch | `codex/course-catalogue-columns` (Pilot repo), cut from `main` at cf77ef78 (v2.15.485) |
| Pull request | #886 closed without merge 19:16 (pointer only, no implementation). Agent C opens a new draft PR. |
| Release number | None until integration (hold decision §3) |
| Separate from | Intake Automation Progress UI (16:36 §3–§8): separate workstream, separate PR; nothing from it goes in this PR |
| Hold | The engineering hold stays in force: no merge or deploy without the Platform Admin's release authorisation for this PR |

## 1. Acceptance objective

Operators can customise the Course Catalogue table to inspect course data, adapter state and field freshness. Their choices persist per user across devices and browsers. The table stays accurate and fast, and the underlying enrichment automation does not change.

Required in this one PR:

- configurable columns (search, show and hide, reorder, grouped selector with a count);
- resizable columns with minimum readable widths;
- per-user saved layouts (visible columns, order, widths, sort field, sort direction), restored on another device or browser;
- Reset to default, optional restore of the last saved view, and a clear "saved" acknowledgement;
- an Adapter status column;
- a City column built from the course's linked campuses;
- Last modified and Last data admitted columns;
- server-side sorting across the whole filtered set for Last modified, Last data admitted, Provider, City, Adapter state and Course title.

## 2. What the Integration Controller found at allocation (starting facts, verify again)

| Area | Current state (main at cf77ef78) | Consequence for this PR |
|---|---|---|
| Catalogue screen | `src/mature-main.jsx`, `Catalogue` page `courses`. The `columns('course', …)` list is fixed at 11 columns. The table is the shared `DataTable` (`src/DataTable.jsx`). | Extend these. Do not build a competing course table. |
| Data source | `admin_read` operation `courses_page`, last replaced by `20261030190000_cf247_admin_read_snapshots.sql` (page-first on ids). Existing sort keys: course, provider, city, field, intl_fee, fee, completeness, verified. | Add sort keys inside the same operation, page-first. No per-row calls. |
| Saved state | `useRememberedState` (`src/ui-kit.jsx`) keeps search, filters, sort and direction in **localStorage**, keyed by user. `useColumnWidths` keeps widths in localStorage (`cf-colw:<table>`). | Not cross-device. The mandate needs server-side per-user storage. |
| Server-side per-user preference store | None in production (checked 5 Nov 2026 19:01: no table matching user/operator preference, view, layout or state). | New table and RPCs written beside the consumer API (G3-safe), owner-only by `auth.uid()`. Keep the localStorage state as the offline fallback and do not overwrite it. |
| Adapter state | The provider list already shows an Adapter cell from `admin_adapter_autobuild('states', provider_ids)` (provider-level, per page). | The course column must come from the existing adapter lifecycle and results, inside the page projection. It must not infer "Completed" because an adapter exists. |
| City | `courses_page` already returns `city_names` with sort key `city`. | Confirm it comes from linked campuses, not the provider's headquarters. Add the expandable multi-campus display and state or country context. |

## 3. Backend and frontend contract (Codex confirms or corrects this in the first commit)

**Database (new migration, `-- Replaces:`/`-- Retires:` lines, `comment on table`, no drops):**

- `pipeline.admin_user_layouts` (or the name Codex justifies):
  - columns: `user_id uuid` (= `auth.uid()`), `screen text`, `layout jsonb` (columns, order, widths, sort, direction, version), `saved_at timestamptz`;
  - primary key (`user_id`, `screen`);
  - RLS or a security-definer RPC that only reads and writes the caller's own row.
- RPCs: read own layout, save own layout (validated against the column registry, size-capped), reset own layout. A read-only role can save its own layout but nothing else.
- `courses_page` extension, additive only:
  - new projected fields: adapter status, last modified, last data admitted, plus the mandate's groups where verified data contracts exist;
  - new sort keys: `modified`, `admitted`, `adapter` (existing `course`, `provider` and `city` keep working);
  - page-first, bounded; benchmark against the production course volume (about 35,700 courses).
- Timestamps:
  - Last modified = the latest persisted change to the course record.
  - Last data admitted = the latest admitted course field or authorised enrichment value, from the platform's authoritative admission or audit records (verify which tables against the schema).
  - A scheduled read, rejected proposal, unchanged update or catalogue refresh is never an admission.
  - With no trustworthy timestamp, show null, displayed as "Unknown".
- Any operational limit (page size, layout size, maximum columns) is a setting under G2, never a number in code.
- Guard every replaced function on its live md5.

**Frontend:**

- Columns control above the table, grouped as Identity, Course information, Pipeline and enrichment, and Lifecycle and timestamps.
- Only fields with a verified data contract are offered.
- Course title and course code are always available.
- Resizable columns, minimum widths, sticky header, horizontal scroll, stable layout while paging, keyboard access.
- Existing row click, search, filters and paging unchanged.
- Field states shown as: populated, missing, pending extraction, waiting for review, held by validation, not applicable, failed. These use the existing field-state definitions, never a misleading zero or "No".
- Active sort and selected-column count are visible.

## 4. Automation compatibility record (required in the PR body)

Record Reuses, Changes, Replaces, Retires, Conflicts and Protects for:

- course lifecycle processing;
- adapters and enrichment;
- search and index refresh;
- manual locks and admission controls;
- filters and paging;
- existing personal settings;
- Website and Zoho consumer contracts.

Background automation plans and admission authority are unchanged.

## 5. Tests (production-representative; no synthetic-only acceptance)

- One governed spec (`// Guards: Platform Admin mandate 5 Nov 2026 17:31, Course Catalogue columns`) plus an isolated-Postgres fixture carrying production constraints, roles, RLS and function signatures for the tables touched.
- It covers all 15 cases of mandate §10, including:
  - sign-out and sign-in restore;
  - a second user's layout is unaffected;
  - a read-only role;
  - server-side sort across pages;
  - multiple cities for one course;
  - adapter status not inferred;
  - last modified differs from last admitted;
  - Unknown rather than invented timestamps;
  - performance with many columns.
- Phone layout is covered by an `@responsive` test (the Course catalogue list is an `s121` screen).
- The test register is regenerated in the same PR (G4).
- `s32`, `s42`, `s57`, `s120` and the website contract specs stay green.

## 6. Milestones

| ID | Deliverable | Owner | Exit check |
|---|---|---|---|
| CC-1 | Audit and contract commit on the draft PR: §2 facts confirmed or corrected, chosen timestamp sources named with their tables, migration and RPC signatures, column registry, compatibility record | Codex | Integration Controller accepts the contract in a PR review comment |
| CC-2 | Feature complete on the branch: migration, RPCs, UI, fixture, spec, register; full local suite and PR checks green; benchmark recorded | Codex | All four PR checks green; fixture parity confirmed against production |
| CC-3 | Independent integration review: live md5 guards, production read-only preview of the new `courses_page` on real data, consumer API untouched | Claude | Review recorded in the execution register |
| CC-4 | Release on the Platform Admin's authorisation; post-deploy verification from the Admin UI (mandate §11) | Claude, then the Platform Admin | Operational acceptance recorded in the execution register |
