# PR #887 Course Catalogue columns: independent pre-release validation

Validator: agent E. Decision 19:14 §8 (Platform Admin, 5 Nov 2026).

- **Branch:** `cf247-course-catalogue-columns`, head `1844a073`, base `cf77ef78` (v2.15.485). Migration `20261106300000_cf247_course_catalogue_columns.sql`. Inspected read-only; the branch was not modified.
- **Production:** `fxcwkweaxjtknorudmwp`, read only (light catalogue reads, 20:43 AEDT).
- **Fixtures:** run in my own databases `e_pr887` (kept for probes) and `e_pr887_before` (baseline benchmark, since dropped), from an extracted copy of the branch.

## Re-validation at head `e07a4122` (5 Nov 2026, 22:47–22:55 AEDT; Platform Admin 22:46 test gate)

**Current verdict: ready.** Both conditions of the first validation are met (forward-recovery documentation; deploy window :11–:12), and the recommendation (no blanket fixture grant) is done.

Changes since `1844a073`:

- two G2 recovery switches;
- production-equivalent fixture grants;
- forward-recovery documentation;
- a merge of main (#888, my parity tooling);
- colours from `tokens.css` and times from the shared `fmtTime`.

Rules followed: production read only (SELECT), the branch not modified, and my own databases `e_pr887n` and `e_pr887n2`, since dropped. The fixture ran from an extracted copy of `e07a4122`.

### (a) The recovery switches work and default on

| Setting | Default | Range | Unit | Label and `used_by` |
|---|---|---|---|---|
| `catalogue_layout.server_layouts_on` | 1 | 0–1 | on (1) / off (0) | yes / yes |
| `catalogue_layout.new_sorts_on` | 1 | 0–1 | on (1) / off (0) | yes / yes |

**My own probe** in `e_pr887n`: two Viewers (Alice, Bob) saved layouts with the switch on. Then I set `server_layouts_on` = 0.

| Call | Result |
|---|---|
| Alice `read` | `{"layout": null, "server_layouts": false, "save_count": 0, …}` (her saved layout is not returned) |
| Alice `save`, Alice `reset`, Bob `restore` | Each `{"saved": false, "reset": false, "restored": false, "server_layouts": false}` |
| Scans of `pipeline.admin_table_layouts` across those four calls | 3 before, 3 after: no read of the table |
| Row hash of the whole table, before against after | Unchanged: nothing written, rows kept |
| Switch back to 1, then read | Alice `{"sort":"admitted","columns":["canonical_title","provider_name"],"direction":"desc"}`, Bob `{"columns":["canonical_title","city_names"]}`: both exactly as saved |
| `new_sorts_on` = 0, then read | `new_sorts=false` reported to the screen, and the saved sort (`admitted`) is kept on the server |

**Screen side** (`CatalogueColumns.jsx`, `mature-main.jsx`):

- **Server layouts off.** With `server_layouts === false`, saves and resets stay in that browser and show a warning; Restore is hidden.
- **New sorts off.** With `new_sorts === false`, the Last data admitted and Adapter status headings stop being sort buttons. A list sorted on either falls back to Course.
- **Limit (by design).** The new-sorts switch stops the screen offering the two sorts, but `courses_page` still accepts `sort=admitted|adapter` if called directly. The documented fix-forward migration covers the server code.

The PR's own cases add four recovery-switch checks: **60 database cases pass**.

### (b) Fixture grants equal production; the new grants are as stated

**Production ACLs**, read at 22:49 AEDT, equal `production-grants.txt` for all 10 functions:

| Function | Production ACL |
|---|---|
| `api.website_v2_label_month(text)` | `{postgres=X/postgres}` |
| `public.admin_read(text,jsonb)` | postgres, authenticated, service_role |
| `security.admin_course_page_fast(jsonb)` | postgres, authenticated, service_role |
| `security.admin_course_page_fast_base(jsonb)` | postgres, service_role |
| `security.admin_course_page_search_state(jsonb)` | postgres, authenticated, service_role |
| `security.admin_course_page_unfiltered_fast(jsonb)` | postgres, authenticated, service_role |
| `security.current_role_rank()` | postgres, authenticated, service_role |
| `security.pipeline_num_v1(text,numeric)` | default (PUBLIC) |
| `security.provider_university_groups(uuid)` | default (PUBLIC) |
| `security.university_group_provider_ids(text)` | postgres, service_role |

- **Fixture.** The run reports **"PASS function grants equal production's for the 10 live functions (no blanket grant)"**. The blanket `grant execute on all functions … to authenticated` is gone. `grants.sql` sets each ACL, and `run.sh` diffs them against the file.
- **Schema usage** in the fixture matches production's (read at 22:49):
  - `pipeline`, `catalogue`, `ref`, `pim`, `scholarship` and `search`: service_role only;
  - `security` and `api`: authenticated and service_role;
  - `public` and `auth`: everyone.
- **Default privileges.** The `public` schema default privileges for `postgres` match production's (functions and tables to authenticated and service_role).
- **New objects**, as stated:
  - `public.admin_table_layout` is `{postgres, authenticated, service_role}` through the public-schema default privileges (anon refused: probed, `permission denied`).
  - `pipeline.admin_table_layouts` and `admin_table_columns` are granted to no API role (checked by `run.sh`). They are also unreachable because `pipeline` has no USAGE for anon or authenticated in production.
  - The seven `security.course_*` helpers are revoked from public, anon and authenticated.
- **Two live functions are stubbed.** `admin_course_page_search_state` (live `9d323993…`) and `ui_courses_decision_page` (live `5e8e9f86…`) are stubs in the fixture, as before (stubs.sql). Their ACLs equal production's. Neither is edited by the change.

### (c) Guarded md5s still live (22:49 AEDT)

| Function | Live |
|---|---|
| `security.admin_course_page_fast(jsonb)` | `2dc6ee8ba523afeec04d862f3a2ced8a` |
| `security.admin_course_page_fast_base(jsonb)` | `afbef16111a09e3680061547bbb1329a` |
| `public.admin_read(text,jsonb)` | `6b1bb9d569bd13390f76803f9a710053` |
| `security.admin_course_page_unfiltered_fast(jsonb)` | `5db669272a3fa612b1268ef8502a9b7c` |

- **Unchanged since the first validation:** `current_role_rank` `d709d92d…`, `pipeline_num_v1` `09f9b155…`, `provider_university_groups` `6debe54e…`, `university_group_provider_ids` `180e8612…`, `website_v2_label_month` `4263b5ad…`.
- **Not yet in production:** the latest applied migration is still `20261105090000`, and neither the new tables nor the `catalogue_layout.*` settings exist yet.

### (d) Consumer API untouched

- No edge function changes between `1844a073` and `e07a4122`.
- The migration still creates or alters no `website_*`, `zoho_*`, `svc_website_settings_v1` or `api.*` object, and no catalogue, search, scholarship or ref table.
- s57 passes on the new head, with s32, s42, s120 and the PR's contract spec: **25 passed**.

### (e) Owner-only, sorting and last-admitted accuracy unchanged

- **Owner-only.** With the switch on, each Viewer reads back only their own layout. anon is refused. The PR's cases (one row a person and screen, every row the caller's own, no user can be named) pass.
- **Sorting and last-admitted are byte for byte the same as at `1844a073`.** After the migration, `admin_course_page_fast` is `3ba78b0e5dcc09c9eda5753304c32ace` and `admin_course_page_fast_base` is `7203f7c62678618154c65ef4ada0e5be`, identical to the first validation. The only function the new commits changed is `public.admin_table_layout`.
- **Compatibility.** All 13 compatibility sets: same rows, order, fields and totals.
- **Cases.** The last-admitted cases (later skips, review items, retracted fills and unchanged rows ignored; null when unknown) and the server-side sort cases across pages all pass.
- **Benchmark.** Same as before, within run-to-run noise. Every page is under the 3,000 ms budget; the pre-existing city and state-filter pages take about 1.9–2.2 s.

### Other

- **CI on `e07a4122`:** Workers Builds, build-and-smoke, release-history-contract and course-columns-isolated-postgres all succeeded.
- **Forward recovery** is now documented (docs §5.2): the two switches, Reset to default, a fix-forward migration guarded on the after-md5s above, and dropping indexes only by paste file with `drop index concurrently`.
- **Deploy window** is documented as :11–:12 (docs §5.1).

---

## First validation (head `1844a073`), kept for the record

**Verdict at `1844a073`: ready with conditions. Superseded by the re-validation above.** All six checks pass. The two conditions are documentation and deploy timing.

## (a) Guarded md5s are still live

| Function | Guard | Live, 20:43 AEDT | Result |
|---|---|---|---|
| `security.admin_course_page_fast(jsonb)` (edited) | `2dc6ee8ba523afeec04d862f3a2ced8a` | `2dc6ee8ba523afeec04d862f3a2ced8a` | match |
| `security.admin_course_page_fast_base(jsonb)` (edited) | `afbef16111a09e3680061547bbb1329a` | `afbef16111a09e3680061547bbb1329a` | match |
| `public.admin_read(text,jsonb)` (not edited, relied on) | `6b1bb9d569bd13390f76803f9a710053` | `6b1bb9d569bd13390f76803f9a710053` | match |
| `security.current_role_rank()`, `security.pipeline_num_v1(text,numeric)` | `d709d92d…`, `09f9b155…` | same | match |

- **Version.** The latest applied version is `20261105090000`, so `20261106300000` sorts after it and collides with nothing.
- **After md5s (fixture).** `admin_course_page_fast` → `3ba78b0e5dcc09c9eda5753304c32ace`, `admin_course_page_fast_base` → `7203f7c62678618154c65ef4ada0e5be`. `admin_read` is unchanged.
- **Idempotent.** A second application finds both edits already applied.

## (b) RLS and grants are owner-only

These were checked in `e_pr887` after the migration, with my own probes.

> **Note:** the fixture's `run.sh` runs `grant execute on all functions in schema public, security to authenticated` before the migration. That is not production-representative. My probes therefore read the actual ACLs of the objects this change creates, and test the paths that do not depend on that blanket grant.

**Static ACLs:**

| Object | ACL and settings |
|---|---|
| `public.admin_table_layout(text,jsonb)` | EXECUTE to `authenticated` only (PUBLIC and anon revoked) |
| `pipeline.admin_table_layouts` | No grants; RLS on; no policies (no direct access for any API role) |
| `pipeline.admin_table_columns` | No grants; RLS on |
| The seven new `security.course_*` helpers | Not executable by `authenticated` |

**Probe results:**

| Probe | Result |
|---|---|
| Alice (Viewer) saves a layout, passing `"user_id": <Bob>` in the arguments | Saved to **Alice's** row. The argument is ignored; the function always uses `auth.uid()`. |
| Bob (Viewer) reads before saving | `layout = null`. He does not see Alice's layout. |
| Bob saves, then reads | His own columns. |
| Alice reads | Her own columns. Bob's save did not touch her row. |
| Alice selects or updates `pipeline.admin_table_layouts` directly | `permission denied for table admin_table_layouts` (both) |
| Signed-in person with no role calls `admin_table_layout('read')` | `assigned StudySearch role required` |
| anon calls `admin_table_layout` | `permission denied for function admin_table_layout` |
| anon selects `admin_table_layouts` or `admin_table_columns` | `permission denied` (both) |
| Signed-in person calls `security.course_list_extras_v1` | `permission denied for function course_list_extras_v1` |
| Bob restores with no previous layout | Refused: "there is no earlier saved layout to restore" |

The rows end up keyed by owner: Alice's `[canonical_title, provider_name]` and Bob's `[canonical_title, city_names]`. The PR's own 56 database cases also pass, including the role, ownership and size-limit cases.

## (c) No consumer API object is touched

- **Spec.** `tests/uat/cf-247-s57-consumer-api-frozen.spec.mjs` passes on the branch copy (3 tests), alongside s32, s42, s120 and the PR's contract spec: 24 passed.
- **Migration.** It creates, alters or drops no `website_*`, `website_edge_*`, `website_api_v2_*` or `zoho_edge_*` function, nothing in schema `api`, and no `svc_website_settings_v1`. It adds no column to any table. It only reads `api.website_v2_label_month` (`4263b5ad…`, unchanged), and `pipeline.website_sync_items` and `zoho_sync_items`, read only.
- **Edge functions.** The PR changes no edge function, so the s57 edge-file baseline is unchanged.
- **Indexes.** The four new indexes are on pipeline ledgers (`field_enrich_items`, `adapter_overwrite_changes`, `layer4_admission_checks`, `course_intake_date_events`). An index does not change the column shape the consumer baseline records.

## (d) courses_page backward compatibility

The PR's `compat.sql` runs the same 13 existing argument sets before and after the migration in the fixture (35,712 courses, 171,004 field items, 214,206 field states):

| Sets | Sorts | Result |
|---|---|---|
| 1–13 | course, provider, city, null sort, modified, verified, fee, intl_fee, field; filtered and unfiltered; paging | **Same rows, same order, same fields and same totals.** The only difference is the added fields. |

**Additional benchmark, my own.** I ran the same argument sets on a fixture before the migration (`e_pr887_before`), with the two new sort keys replaced by `course`, to separate the cost of the new extras from pre-existing cost:

| Page | Before | After | Difference |
|---|---|---|---|
| 50 rows, unfiltered, course | 64 ms | 86 ms | +22 ms (page extras) |
| 50 rows, modified | 50 ms | 78 ms | +27 ms |
| 200 rows | 80 ms | 207 ms | +127 ms |
| 50 rows, city sort | 1,740 ms | 1,830 ms | +90 ms (city sort was already slow) |
| 50 rows, AU-VIC filter, course | 1,731 ms | 1,866 ms | +135 ms (filter was already slow) |
| New sorts: admitted desc, adapter asc | – | 130 ms, 250 ms | – |

Every page stays inside the 3,000 ms budget. The roughly 1.7 s of the city sort and the AU-VIC filter is pre-existing, not caused by this change.

## (e) lock_timeout and index builds are safe

- **Lock.** The migration sets `set local lock_timeout = '5s'` (marked `-- fixed:`), so a busy table makes the migration fail cleanly instead of queueing writers behind it.
- **Index builds.** The four `create index` statements are plain (not `CONCURRENTLY`; one migration transaction). Each holds its table's SHARE lock for the build.

| Index | Production size (20:43) | Fixture build at similar volume |
|---|---|---|
| `field_enrich_items_course_filled_idx` (partial) | 171,472 rows, 120 MB | 20.7 ms (171,004 rows) |
| `adapter_overwrite_changes_course_at_idx` | 34,392 rows, 9.3 MB | 15.4 ms |
| `layer4_admission_checks_entity_admitted_idx` (partial) | 1,447 rows | 2.0 ms |
| `course_intake_date_events_course_filled_idx` (partial) | 2,012 rows | 2.4 ms |

- **Production time.** Production will be slower than the fixture: 120 MB on disk against a fresh local heap. Expect well under a second per index.
- **Deploy window.** The PR documents one: apply at :11–:12 or :31–:32, never at :26 or the :x6 heavy minutes. Under the current schedules I would also avoid :02 and :32 (`first-run-verify`), so **:11–:12 is the safest**.
- **Overlap with #889.** #889 also creates an index on `course_intake_date_events` (`run_at desc`); the two do not conflict.

## (f) Settings comply with G2

| Key | Label | Range | Unit | `used_by` |
|---|---|---|---|---|
| `catalogue_layout.max_bytes` | yes | 2000–64000 | bytes | yes |
| `catalogue_layout.max_columns` | yes | 5–100 | columns | yes |
| `catalogue_layout.width_min_px` | yes | 40–200 | pixels | yes |
| `catalogue_layout.width_max_px` | yes | 300–2400 | pixels | yes |

- **No hard-coded operational values.** The functions read all four through `security.pipeline_num_v1`. The only code value is the deploy `lock_timeout`, marked `-- fixed:`. s32 passes.
- **Housekeeping.** `-- Replaces: nothing` and `-- Retires: nothing` are present, and both new tables have a `comment on table`. Nothing is dropped. No job is added, and no switch is turned on.

## Other gates

| Check | Result |
|---|---|
| CI on `1844a073` | Workers Builds, release-history-contract, build-and-smoke and course-columns-isolated-postgres: success |
| Production-schema parity in the PR | `production-parity.txt` covers 42 tables: columns, constraints, foreign keys, indexes, triggers, RLS, policies and grants |
| Admission and automation | No ledger or catalogue write. "Last data admitted" is read only from ledgers that record admitted values. |

## Forward recovery (missing from the PR's doc)

1. **Restore the page.** Issue a new migration that restores `admin_course_page_fast` and `admin_course_page_fast_base` to `2dc6ee8b…` and `afbef161…`, guarded on the after-md5s `3ba78b0e…` and `7203f7c6…`.
2. **What can stay.** The layout tables, the `admin_table_layout` RPC and the settings can stay; they are read only by the new screen. The screen falls back to the browser-only layout.
3. **What cannot be dropped by migration.** Dropping the tables or indexes goes to the Platform Admin as a paste file after `hygiene.retire_after_days`.

## Conditions

1. **Recovery doc.** Add the forward-recovery section above to `docs/course-catalogue-columns.md`.
2. **Deploy window.** Apply at :11–:12 (not :02, :26, :32 or the :x6 heavy minutes).
3. **Recommended, not blocking:** remove the blanket `grant execute on all functions … to authenticated` from the fixture. Replace it with the production grants of the live functions it loads, so the fixture's own role cases test the real ACLs.
