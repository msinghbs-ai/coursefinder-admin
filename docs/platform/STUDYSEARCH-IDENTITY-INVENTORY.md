# StudySearch identity inventory (SS-013)

**Version:** 1.1, 31 Oct 2026 (decisions D8 to D10 recorded; crawler proposal §5). 1.0: platform release v2.15.383.
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

## 3. Dependencies and decisions

**Decided (Platform Admin, 31 Oct 2026 19:22):**
- **D8:** repository names, Cloudflare Worker identifiers, Supabase identifiers, domains and consumer API routes stay as they are. StudySearch remains the product identity. Renaming is revisited only when it has a demonstrable operational benefit.
- **D9:** the consumer error wording "CourseFinder service unavailable" stays. Any future change to consumer-visible text follows G3: a developer-guide issue, a version line, a compatibility assessment and a handover.
- **D10:** the crawler identity and its matching behaviour stay. The backwards-compatible proposal is §5; it is not deployed.

**Earlier list of dependencies (kept for reference):**

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

## 5. Crawler user agent: backwards-compatible proposal (D10; not deployed)

### Today

- **Main worker (`coverage-sweep`):**
  - It sends `Mozilla/5.0 (compatible; CourseFinder-Pilot/coverage-0.1; +https://coursefinder-pilot.techm.workers.dev)` for page reads, robots.txt, site maps, logos and home pages.
  - Its robots.txt reader (`extract.ts`, `robotsAllows`) obeys a group whose `User-agent` contains `coursefinder`; otherwise it obeys `*`.
- **Other edge functions:** about 25 Layer 1 and statistics readers send their own short agents, such as `CourseFinder-Pilot/Seneca-0.3.1`, `coursefinder-pilot-nz/1.2` and `coursefinder-au-cricos-facts/1.1`.
- **Separate identities:** contact discovery and provider asset import send "CourseFinder Contact Discovery/1.2" and "CourseFinder Provider Asset Import/1.0".

### Risks of a plain rename

- A provider that allows `CourseFinder` by name (in robots.txt or a firewall allow-list) would block a new name.
- A provider that disallows `CourseFinder` by name would silently start being read under a new name. That would breach the rule that robots.txt is respected.
- Firewall services score unknown agents and may challenge them, which costs Firecrawl credits as reads fall back.

### Proposal

1. **Keep the old token and add the new one in the same string.** For example: `Mozilla/5.0 (compatible; StudySearch/coverage-0.1; CourseFinder-Pilot; +https://coursefinder-pilot.techm.workers.dev)`.
   - Allow-lists that match `CourseFinder` keep matching.
   - The new name becomes visible.
2. **Robots reading obeys both names.**
   - Use the group naming `studysearch` or `coursefinder`.
   - If both exist, obey the more restrictive result for each path.
   - Use `*` only when neither is named.
   - Robots.txt is never read more permissively than today.
3. **Measure before changing.**
   - Before the change, the worker should record, during the robots.txt reads it already makes, which providers name `coursefinder` (allow or disallow). This needs no extra requests.
   - Firewall challenges seen per day give the baseline.
   - No new paid reads.
4. **Change in one place.**
   - One shared constant for the worker.
   - The Layer 1 readers move to `StudySearch-…; CourseFinder-Pilot/…` when each is next changed, not as a separate project.
5. **Watch for 30 days.**
   - Measure page-read success rate, `blocked` and `robots_disallowed` counts per provider against the baseline.
   - Stop and revert if either rises by more than an agreed margin.

### Approvals and effort

- **Approval:** a worker release (G2/G4 governed, outside the consumer API). Platform Admin approval of the wording and of the 30-day watch.
- **Effort:** about half a day including tests.
- **Consumer impact:** none.

