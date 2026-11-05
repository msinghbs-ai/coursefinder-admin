# PR #891 Course Catalogue Columns panel CSS fix: independent validation

Validator: agent E. Decision 19:14 §8; Platform Admin 22:46 test gate.

- **Fix:** branch `cf247-course-catalogue-columns-css-fix`, draft PR #891, head `2a52c1b6`.
- **Baseline:** `8a9dc0ba`, the shipped #887 code behind the v2.15.486 production acceptance failure (the Columns panel was clipped).
- **The change:** no database change. Nothing in production was read or written for this check.
- **How I ran it:** both commits were extracted to scratch copies. The branch was not modified.

**Verdict: ready.** The fix removes the collision. The built production bundle's panel is fully usable at desktop width and at 375 px. The new checks fail on the shipped code and pass on the fix, the build hook works, and CI is green. Nothing beyond the class rename, one small in-panel acknowledgement, the checker, the prebuild hook, specs and the register changed.

## (a) No remaining collision; every JSX class is defined

I wrote my own check, independent of the PR's `scripts/verify-css-class-collisions.mjs`. It collects every class used in a selector in every `src/**/*.css`, and every class token in `CatalogueColumns.jsx` plus the Catalogue bar in `mature-main.jsx`.

| | `8a9dc0ba` (shipped) | `2a52c1b6` (fix) |
|---|---|---|
| Classes in `catalogue-columns.css` | 23 | 23 |
| Shared with another stylesheet | 7: **`cc-bar`, `cc-panel`, `cc-count`** (all also in `data-quality.css`), plus `tone-success`, `tone-warning`, `m-table-wrap`, `m-col-resize` | 4: `tone-success`, `tone-warning`, `m-table-wrap`, `m-col-resize` |
| JSX class tokens without any definition | none (22 tokens) | none (22 tokens) |

**The four remaining shared names are the listed shared classes, used deliberately:**

- **Tone classes:** only in compound, prefix-scoped selectors (`.ccol-ack.tone-success`, `.ccol-ack.tone-warning`).
- **Table frame:** `.m-table-wrap.ccol-frame`, also compound.
- **One global rule, unchanged by this PR:** `.m-col-resize:focus-visible` is unscoped. It only styles the focus ring of the shared column-resize handle, which is pre-existing.

**The PR's own checker:** it passes on `2a52c1b6` ("css-classes: PASS"). Pointed at the shipped code with prefix `cc-`, it fails: `admin-pages.css` defines `.cc-scope`, `.cc-snapshot`, `.cc-table`, `.cc-where`, `.cc-provider`, and `data-quality.css` defines `.cc-bar`, `.cc-panel`, `.cc-count`.

## (b) The built bundle: container rules not overridden; checkboxes hit-testable

**Build:** `npm run build`, which runs the prebuild hook including the new checker, then `vite build`. It ran under `flock` for both commits (`VITE_SUPABASE_URL=https://example.supabase.co`).

**Built CSS:**

- **Shipped:** in `dist/assets/index-*.css`, `.cc-bar{display:flex;gap:2px;height:18px;…;overflow:hidden;…}` (data quality's bar) applies to the Columns bar. No `ccol-` rule exists.
- **Fix:** data quality's `.cc-bar` is still there (it is data quality's own), and the panel now has its own `.ccol-bar`, `.ccol-panel` (2 rules) and `.ccol-count` rules.

**Browser hit-test of the built bundle.** I wrote my own Playwright test, a scratch file not in the branch:

- It serves `dist/` through `vite preview` and **injects no stylesheet**: only the built CSS loaded by the page (`index-*.css`).
- It uses the repo's admin mock plus a layout route, opens `#courses`, and opens Columns.
- It checks that the close button is the element under its own centre. Then it scrolls each of the 40 checkboxes to the middle of the panel's own list and checks that the element under its centre is the checkbox or its label.

| Build | Width | Bar (class, height, overflow) | Panel | Checkboxes hit-testable | Close button | Result |
|---|---|---|---|---|---|---|
| `8a9dc0ba` | 1440 | `cc-bar`, **18 px, hidden** | 380 × 640 | **0 / 40** | **no** | **fails**: the acceptance defect reproduced from the built bundle |
| `8a9dc0ba` | 375 | `cc-bar`, 18 px, hidden | 343 × 716 | 40 / 40 | yes | passes (on a phone the panel sits outside the clipped bar) |
| `2a52c1b6` | 1440 | `ccol-bar`, 44 px, visible | 380 × 640 | **40 / 40** | **yes** | **passes** |
| `2a52c1b6` | 375 | `ccol-bar`, 44 px, visible | 343 × 716 | **40 / 40** | **yes** | **passes** |

## (c) The new tests fail on the shipped code and pass on the fix

I ran the PR's contract spec, with its checker, against each commit's source (local Playwright, `pw-5291`, desktop and phone projects).

| Test (from `2a52c1b6`) | On `2a52c1b6` | On `8a9dc0ba` |
|---|---|---|
| No class of the Columns screen is defined by another stylesheet | pass | **fails** (collisions listed) |
| All stylesheets loaded: all 40 checkboxes clickable, acknowledgement shows (desktop) | pass | **fails** (checkbox not under the pointer) |
| Same at phone width | pass | fails. On the shipped code the phone panel's checkboxes are reachable (my built test above), so this fails only because the new in-panel acknowledgement does not exist there, not because of the clipping. |
| Existing phone frame test (selector renamed to `.ccol-frame`) | pass | fails (the shipped code has `.cc-frame`): a selector artefact, not the defect |
| The other 7 tests | pass | pass |
| **Total** | **11 passed** | 4 failed, 7 passed |

The two decisive tests, the collision check and the desktop hit-test, fail on the shipped code for the reason of the defect and pass on the fix.

**One design note:** the PR's hit-tests load every `src` stylesheet as one injected style tag on the dev server, which approximates production's cascade. This validation adds the stronger check against the actual built bundle: (b) above.

## (d) Nothing else changed

`git diff --stat 8a9dc0ba 2a52c1b6`:

- `docs/platform/TEST-REGISTER.md` (regenerated: totals 2,013 → 2,016 tests, the Columns contract row);
- `package.json` (`ui:classes` script; `prebuild` gains `node scripts/verify-css-class-collisions.mjs`);
- `scripts/verify-css-class-collisions.mjs` (new);
- `src/CatalogueColumns.jsx`;
- `src/catalogue-columns.css`;
- `src/mature-main.jsx` (one line);
- `tests/integration/course-columns-postgres.spec.mjs` (one selector);
- the Columns contract spec.

**After normalising the prefix** (`cc-` → `ccol-` in the shipped files):

- `catalogue-columns.css` is **identical**: a pure rename.
- `CatalogueColumns.jsx` differs only by a new `ack` prop on `ColumnsControl` and one `<span className="ccol-ack …" data-layout-ack-panel aria-hidden="true">` that repeats the save acknowledgement inside the panel. On a phone the open panel covers the bar. It is `aria-hidden` because the bar's `role="status"` copy still announces.
- `mature-main.jsx` renames the bar, sort, acknowledgement and frame classes, and passes `ack`.

This in-panel acknowledgement is a small UI addition beyond a pure rename. It is tested, and harmless. No migration, function, setting or consumer API file changed.

## (e) The prebuild hook does not break the build

- **Local:** `npm run build` (prebuild: release verify, CSS collision check, release history; then `vite build`) completed for `2a52c1b6`.
- **CI on `2a52c1b6`:** Workers Builds (coursefinder-pilot), build-and-smoke, release-history-contract and course-columns-isolated-postgres all succeeded. The Workers build therefore runs the hook and passes.
- **Guards against future collisions:** the hook refuses a build if another stylesheet ever defines a `ccol-` class, or if `catalogue-columns.css` defines an unprefixed class outside its listed shared classes.

## Conditions

None. Recommended: when acceptance is repeated on production after release, open Course catalogue › Columns at desktop width and tick a column. That is the step that failed in v2.15.486.
