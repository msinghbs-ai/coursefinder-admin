# StudySearch identity inventory (SS-013)

**Version:** 1.0, 31 Oct 2026, platform release v2.15.383.
**Authority:**
- Platform Admin, 31 Oct 2026 10:23: rebrand, do not rename technical identifiers.
- Platform Admin, 31 Oct 2026 14:27: inventory, implement the presentation and documentation changes, preserve identifiers.
**Method:** repository grep (Pilot and Admin) and live database reads, 31 Oct 2026 14:30 to 15:00 AEDT.

**Naming rule:**
- **StudySearch** is the product. **CourseFinder** is its former name.
- **"Course Finder"** (two words) is a feature of the client website (with University Finder and Scholarship Finder) and is never renamed.
- "course finder page" in lower case is a provider's own course search page: an ordinary phrase, not the brand.

## 1. Renamed (now StudySearch)

| Where | What | When |
|---|---|---|
| Admin UI: browser title, brand mark, navigation, screens, release notes | "StudySearch PIM Admin"; no screen says CourseFinder (guard s6, extended to every `src/` file) | v2.15.241 (11 Oct); verified in full in v2.15.383 |
| Database messages shown to users (role errors and similar) | 82 functions say "StudySearch" | v2.15.241 |
| Reports and job catalogue | Hourly report "StudySearch hourly stats"; no job label, setting label or help text says CourseFinder (live, 31 Oct) | Before 31 Oct; verified |
| Test names (8 specs) and workflow names ("StudySearch Deployed UAT", "StudySearch Lightweight UX Audit", base-URL input descriptions) | Renamed; guarded by s6 | v2.15.383 |
| Component register and table comment for `pipeline.platform_capacity_policy` | "StudySearch policy thresholds" | v2.15.383 |
| Active Admin documents: document router heading, Agent Operating Model, this inventory, operational limits | "StudySearch (formerly CourseFinder)" on first mention | 31 Oct (Admin) |
| Developer packs (Website API v2, Zoho API v2) | Already "StudySearch …" | Earlier issues |

## 2. Retained for compatibility (not renamed)

| Identifier | Where used | Why it stays | To change it |
|---|---|---|---|
| Repositories `coursefinder-admin`, `Coursefinder-Pilot` | CI, agents, project instructions, links in records | Renaming breaks links and automation | Separate approval with a dependency list |
| Worker and host `coursefinder-pilot.techm.workers.dev`; `package.json` name `coursefinder-pilot` | Deployed tests, release check, CI base URL, website and Zoho configuration | It is the live address | A custom domain or Worker rename, approved separately |
| Supabase project display name `coursefinder_Pilot` | Supabase console only | Cosmetic; can change with the repository proposal | Approval with the repository question |
| Browser storage keys and events (`coursefinder:pim:…`, `coursefinder:provider-logo-refresh`, `coursefinder:compare-selection:v1`, 6 files) | Users' saved screens, columns and comparisons | Renaming resets every user's saved choices | Only with a migration of stored keys |
| Database functions and secrets (`coursefinder_runtime_edge_base_url`, credential names `coursefinder_website_wix_pilot_v1`, `coursefinder_zoho_pilot_v1`, `coursefinder_pilot_automation`, `coursefinder_layer3_profile_*`, `coursefinder_l2_provider_*`) | Edge dispatch, consumer authentication, vault | Technical identifiers; secrets and consumer keys | Not planned |
| Consumer API error text "CourseFinder service unavailable" (`website-course-api`, `zoho-course-api`, `zoho-api-v2`) | Website and Zoho consumers | Frozen consumer contract (G3) | Platform Admin approval under G3 |
| Crawler user agents ("CourseFinder Contact Discovery/1.2", "CourseFinder Provider Asset Import/1.0"); `robots.txt` matching on "coursefinder" (`coverage-sweep/extract.ts`) | Provider websites see and may allow-list this name | Renaming could change what providers' robots rules allow | Decision: rename with a dual-match period |
| OpenRouter request headers (`HTTP-Referer: https://coursefinder.app`, `X-Title: CourseFinder Layer 3 …`) in `layer3-provider-control` | OpenRouter usage reports | Hand-deployed edge function; cosmetic | With the next change to that function |
| Course identity names `coursefinder:<country>:…` (Layer 1) | Stored identity keys | Stored data keys | Not planned |
| Release history before v2.15.80 and the accepted recovery release notes (`src/release-history-legacy.js`, `public/release-history.json`, `release-manifest.js` accepted releases) | Release record | History is never rewritten | Never |
| Admin history: `change-control/`, `project-runsheets/`, `docs/daily-updates/`, `docs/uat/`, dated records, versioned documents `docs/coursefinder-*-vX.md` | Audit record | History is never rewritten | Never (superseding issues use the new name) |
| Admin current document names `docs/coursefinder-*.md` | Linked from the router and records | File names are references | A new issue of a document uses a StudySearch file name; the old file stays as history |

## 3. Unresolved dependencies (for separate decisions)

1. **Repository, Worker and domain names:**
   - one proposal with the full dependency list: CI workflows, deployed tests, release-currentness, agent instructions, website and Zoho configuration;
   - redirect plan.
2. **Consumer error text:** a G3 change to the three consumer edge functions, with a guide line. Low value; recommend leaving it until a consumer release.
3. **Crawler identity:**
   - add "StudySearch" to the user agents while still honouring "coursefinder" rules in `robots.txt`;
   - recommend doing it with the next crawler change.

## 4. Guard

`tests/uat/cf-247-s6-studysearch-contract.spec.mjs` fails the build if any of the following uses the former name:
- any `src/` file (outside the release history);
- the current release notes;
- any test name;
- any workflow name.

It also checks that the retained identifiers above are still in place.
