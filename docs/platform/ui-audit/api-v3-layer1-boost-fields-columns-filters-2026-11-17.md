# UI audit: columns and filters for the new API v3, Layer 1 and Boost fields

**Asked:** Platform Admin, 17 Nov 2026 23:05 AEDT (chat S1-RM-Design).
**Checked against:** the live Pilot database (read only) and Pilot `main` at v2.16.27, 17 Nov 2026 23:10 to 23:30 AEDT.
**Status (18 Nov 2026 08:00 AEDT):** 3b shipped in v2.16.28. 1a, 1b, 2b and 2c shipped in v2.16.29 (Pilot #1239). 1c shipped in v2.16.30 (worked out on the Boost queue, not stored; Pilot #1242). 2a and 3a are not built. The table below is the audit as written on 17 Nov.

## 1. What each item needs, and what is held today

| # | Asked for | Held in the database today | On screen today | Finding |
|---|---|---|---|---|
| 1a | Courses: Study load column and filter | `catalogue.courses.study_load`: 925 both, 1,413 full-time, 183 part-time, 42,212 empty | Not shown on Courses | To build. The value exists for about 2,500 of 44,700 courses. |
| 1b | Courses: Empty reason filter chip and badge | `catalogue.courses.empty_reason_code`: 5,104 not published by provider, 395 online only, 104 pending extraction, 29 not on register, 7 source unavailable, 39,094 none | Not a column or filter on the list | To build. |
| 1c | Boost priority score and Country tier filter | **No such fields exist.** No column named for a Boost score or a country tier is in any table. Boost priority is the matrix setting on Settings › Pipeline settings (S2 - BOOST) | Matrix only | Cannot be built as asked. Needs a decision: which stored value is the score, and what a country tier is. |
| 2a | Providers: Accreditations badge and body filter | `catalogue.provider_accreditations` exists and holds **0 rows** | Not shown | To build, but every provider would read "none" until a loader fills the table. |
| 2b | Campuses: Primary badge and toggle | `catalogue.campuses.is_primary`: 356 of 4,356 campuses | Not on the Campuses list | To build. |
| 2c | Campuses: Locality column and search | **`catalogue.campuses` has no `locality` column.** A campus reaches a locality through its postcode (`destination.locality_postcodes`, 1,303 rows; `destination.localities`, 102) | Destination data › Localities & postcodes lists localities and postcodes | To build as a looked-up column (postcode to locality); needs care where a postcode sits in more than one locality. |
| 3a | Sources: Retention (days) column and filter | `pipeline.source_retention_policies` holds **0 rows**; every source follows the platform period | Platform health › Storage & retention; the wizard's step 4; the completeness report | To build on Sources. Today every row would show the platform period. |
| 3b | Read-only views: Grade scale conversions, API field dictionary | `ref.api_field_dictionary`: 2,085 rows. `ref.grade_scale_conversions`: **0 rows** | **Shipped in v2.16.28** on Reference data | Done. Grade scale conversions says plainly that none are loaded. |
| 3c | Read-only view: destination and postcode reference | `destination.*` tables | Already on Destination data › Localities & postcodes (Curator and above) | Already present; not rebuilt. Its search was not re-tested in this audit. |

## 2. Why the list columns are a larger change than a reference view

The Courses, Providers and Campuses lists are read through `admin_read` (`courses_page`, `providers_page`, `campuses_page`), with per-person saved layouts, a column register and server-side filters. A new column with a filter changes the page function, the filter options, the column register, the saved-layout rules and their guards together. `catalogue.courses`, `catalogue.campuses` and `catalogue.provider_accreditations` are tables the consumer API reads, so they are read only, never altered (G3).

The `admin_read` `dashboard` call timed out under load twice on 17 Nov 2026 (21:43 and 21:57 AEDT). New filters on the same read path should be measured before they ship.

## 3. Proposed order for the remaining work

| Slice | Contents | Depends on |
|---|---|---|
| A | Courses: Study load column and filter; Empty reason badge and filter | Nothing. Data is held. |
| B | Campuses: Primary badge and toggle; Locality column and search | A rule for a postcode in several localities |
| C | Sources: Retention (days) column and filter | Nothing; shows the platform period until a source has its own |
| D | Providers: Accreditations badge and body filter | A loader that fills `catalogue.provider_accreditations` |
| E | Boost priority score and Country tier | A decision on what these two values are and where they are stored |

## 4. Not verified

- No screen was checked in a signed-in session.
- The destination and postcode screen was read in code only.
