# M1-PIM-FINALISATION UAT — 20 August 2026

**Workstream:** Admin/PIM Operational UI & Browser Acceptance Gate  
**UI candidate:** PIM Admin v2.10.0  
**Pilot:** `coursefinder_Pilot`  
**Outcome:** **DB/RPC/SECURITY/PERFORMANCE + FRONTEND SOURCE PASS; DEPLOYED AUTHENTICATED BROWSER UAT PENDING**

## 1. Gate rule

This UAT does not convert source/SQL success into browser acceptance. Applicable `30-admin-pim-ux` Change Controls remain OPEN until a deployed authenticated browser walkthrough passes.

## 2. Live data scale observed

| Domain | Pilot count observed |
|---|---:|
| active AU Courses accepted substrate | 26,648 |
| Search Course documents | 33,105 |
| Evidence artifacts | 1,567 |
| Pipeline Jobs | 1,325 |
| Pipeline Sources | 54 |
| Review Queue | 0 |
| PIM Attribute Families | 3 |
| PIM Attribute Groups | 13 |
| PIM Attribute Definitions | 3 |
| PIM Attribute Options | 0 |
| PIM Completeness Profiles | 0 |

A zero Review/Option/Profile count was treated as a governed empty state, not a load failure and not an instruction to manufacture rows.

## 3. Confirmed pre-finalisation defects

| Assertion | Result |
|---|---|
| Evidence screen could fetch up to 2,000 rows and filter locally | FAIL confirmed |
| Operations/PIM source paths could request 1,000–2,000 rows | FAIL confirmed |
| URL/history retained list filters/page/detail | FAIL confirmed; v2.9 state was in-memory |
| stale-request cancellation | FAIL confirmed; no `AbortController` path |
| Provider related Course/evidence payload | FAIL confirmed; wrapper read `rows` while helper returns `items` |
| UQ Provider related Courses | FAIL confirmed: UI wrapper returned 0 while canonical count was 382 |
| default Course page latency | FAIL confirmed: ~5.27 s DB-side for 50 rows |
| authenticated legacy `public.ui_*` SECURITY DEFINER compatibility surfaces | FAIL confirmed |

## 4. Applied DB/RPC regression

### Exact identity

| Test | Expected | Result |
|---|---|---|
| Course query `121174E` | exactly one Course | PASS |
| Provider query `00025B` | exactly one Provider | PASS |
| Evidence UUID query | exactly one artifact | PASS |
| Pipeline Job UUID query | exactly one Job | PASS |

No title-only identity logic was introduced.

### Bounded payloads

| Test | Result |
|---|---|
| normal Catalogue page size | 50 rows | PASS |
| Evidence operational page | bounded/paged | PASS |
| Pipeline Jobs page | bounded/paged | PASS |
| Pipeline Sources page | bounded/paged | PASS |
| Provider detail related Courses | total 382 / preview 25 for UQ | PASS |
| Provider detail related evidence | bounded page contract | PASS |

### PIM Configuration

`admin_read('attributes')` returns the corrected current-schema collections:

- Families;
- Groups;
- Attribute Definitions;
- Options;
- Completeness Profiles;
- Completeness Requirements as `completeness_profile_rules`;
- Family relationships.

The prior obsolete `pim.attributes` mapping was not retained.

## 5. Performance UAT

Measured using PostgreSQL `EXPLAIN (ANALYZE, FORMAT JSON)` against the Pilot data. These numbers are database-side execution times, not browser/network timings.

| Path | Measured execution |
|---|---:|
| **old default Course page, 50** | **~5,272 ms** |
| **v2.10 default Course page, 50** | **~260 ms** |
| exact CRICOS Course `121174E` | ~167 ms |
| AU/VIC Provider-sorted Course page | ~963 ms |
| Provider page, 50 | ~212 ms |
| Campus page, 50 | ~109 ms |
| Evidence page, 50 | ~134 ms |
| Pipeline Jobs page, 50 | ~517 ms |
| Pipeline Sources page, 50 | ~32 ms |
| QILT page, 50 | ~157 ms |
| PRISMS page, 50 | ~297 ms |
| PIM Configuration read | ~28 ms |
| Provider detail, UQ | ~96 ms |
| Course semantic detail, cold first sample | ~1,452 ms |
| Course semantic detail, immediate warm repeat | ~47 ms |

Default Course list DB execution improved by roughly 95% (~20x). The fast path performs canonical filtering/count/sort before pagination and computes fee/readiness/geography/scholarship/Search fields only for the bounded page.

### Search / Publication cold-read fix

The first wide-table Search/Publication aggregate measured ~2.95 s cold. A narrow covering summary index was added over the required Search state fields. The underlying summary aggregate then used an index-only scan at ~33 ms in the measured UAT.

### Expensive derived Course paths

Catalogue-wide fee/completeness filters/sorts continue to use the accepted semantic calculation and were not silently redefined. The v2.10 normal grid does not expose fee/readiness as clickable sort controls until those derived paths are independently optimised.

## 6. Security UAT

### Browser entrypoint and internal CRUD

PASS:

- `public.admin_read` is the normal browser read entrypoint;
- no direct browser table grants were found on internal Catalogue/Pipeline/Workflow/PIM/Scholarship/Search/Publishing/Security schemas;
- v2.10 frontend source contains no Supabase `.from(...)` internal-table reads.

### Role denials

A simulated authenticated identity with no CourseFinder role received SQLSTATE `42501` for:

- Evidence (`curator role required`);
- Pipeline (`pipeline_operator role required`);
- PIM Configuration (`pim_admin role required`).

PASS.

### Legacy browser-executable SECURITY DEFINER functions

All `public.ui_*` `SECURITY DEFINER` compatibility functions were revoked from `PUBLIC`, `anon` and `authenticated`, while internal/service compatibility was retained.

Post-change privilege inspection showed:

- `public.admin_read`: authenticated EXECUTE = yes; anon = no;
- legacy `public.ui_*` SECURITY DEFINER: authenticated EXECUTE = no; anon = no; service_role = yes.

Supabase security-advisor rerun no longer reported authenticated `SECURITY DEFINER` browser surfaces.

### Remaining advisor items

- `rls_enabled_no_policy` INFO notices remain on internal tables. With no browser grants these act as deny-by-default surfaces and are not treated as a browser-access defect.
- Supabase Auth leaked-password protection remains a project-level warning. It is **not fixed by this gate**.
- performance advisor informational FK/index housekeeping remains separate technical debt.

## 7. Frontend source/transformation UAT

The integration branch entrypoint is `src/finalisation.jsx`; visible package/UI version is 2.10.0.

The build guard/source transform was executed locally against the exact staged finalisation source with TypeScript JSX transpilation.

Result:

```text
required_markers: 8
errors: 0
transformed_bytes: 50030
has_campus_map: true
history_fix: true
evidence_filters: true
fee_sort_disabled: true
readiness_sort_disabled: true
```

Additional scan found no frontend bulk-read constants for 1,000/2,000/5,000 rows and no direct Supabase table `.from(...)` calls in the transformed shell.

The source guard specifically protects:

- Campuses → Campus detail routing;
- preservation of current list URL/scroll before detail history push;
- latest Evidence page/filter payload mapping;
- disabling known slow fee/readiness sort controls from the normal Course grid.

### Build environment limitation

The available execution container could not resolve GitHub/npm network access and the repository has no GitHub Actions workflow. Therefore this record does **not** claim a complete fresh `npm install && npm run build` from the remote integration branch. The transformed JSX/source gate passed; Cloudflare/Git-integrated production build remains part of deployment acceptance.

## 8. UI behaviour implemented in v2.10 source

PASS at source level:

- governed role-aware information architecture;
- URL-backed query/filter/page/sort/detail state;
- browser `popstate` handling and scroll state;
- cancellable RPC requests;
- debounce for operational search;
- loading skeletons;
- empty/error/retry/permission states;
- responsive sidebar/nav breakpoints;
- sticky headers/context;
- resizable columns persisted in browser storage;
- structured Provider/Campus detail;
- accepted Course/Scholarship semantic detail retained;
- Australian English/Australia-Sydney display formatting;
- CRICOS registered total-course tuition label remains distinct from Provider-current fee semantics.

## 9. Deployed browser UAT — NOT YET PASSED

The following require the real deployed authenticated app and must remain open:

- first paint and refresh latency over the actual network;
- no blank/error route after Cloudflare build/deploy;
- desktop/laptop visual responsiveness;
- filters/page/sort/scroll survive real cross-click + browser Back/Forward;
- rapid search/filter changes do not allow stale response overwrite;
- exact IDs searchable through real browser controls;
- column resize/sticky context usability;
- every visible menu route useful/real;
- role-specific menu visibility with real Viewer/Curator/Pipeline Operator/PIM Admin accounts;
- graceful unauthorised route behaviour;
- Cloudflare build/runtime console/network error check.

## 10. Gate verdict

**PARTIAL PASS / HOLD FOR DEPLOYED AUTHENTICATED BROWSER UAT.**

The database, RPC/security boundary, 26k-scale normal Course read, frontend source contract and governance documentation are ready for deployment testing. `CF-CHG-20260820-015` and applicable predecessor PIM Change Controls must not be closed until that browser gate passes.
