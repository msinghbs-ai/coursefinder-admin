# StudySearch Admin – UI catalogue (every screen, what it shows, what it does)

**Version:** 1.16 (30 Oct 2026, platform release v2.15.373)
**Change control:** CF-247
**Source:** read from the Pilot repository code (`src/nav-map.js`, `src/mature-main.jsx` `pageBody`, each screen's component, `index.html`), not from older documents.
**Rule:** every release that adds, removes or changes a screen, tab, panel, column, action or setting updates this page in the same change-control entry and raises its version. Proposed simplifications are in `UI-SIMPLIFICATION-REVIEW.md`.

Roles (rank): 1 Viewer · 2 Counsellor · 3 Curator · 4 Pipeline Operator · 5 PIM Admin (shown in the header as "PIM Operator") · 6 Platform Admin.

---

## 0. App shell (all pages)

| Part | What it shows / does | Source |
|---|---|---|
| Sidebar | Sections: (top) Dashboard · Catalogue · Data pipeline · Operations · Platform settings · Administration · Guides. A page shows only if the role can open one of its tabs. Health dot on Platform health. Account box (role, email, Sign out) | `nav-map.js` SECTIONS; `mature-main.jsx` |
| Header | Breadcrumbs, title and subtitle from nav-map; Health pill (rank ≥3, re-read every 5 min); version pill (made a "Release notes" button by `pim-version-entry.js`); role pill | `mature-main.jsx` |
| Credit banner | Firecrawl, OpenRouter, adapter AI allowance, scholarship scraper cap when low (rank ≥3; every 5 min); link to Models & services; × hides until reload | `CreditBanner.jsx` |
| Snapshot stamp (v2.15.373, W34/W35) | On screens read from a cached snapshot (Completeness › Courses and Attributes, Toolset notices on Layer pages, Toolsets & limits and Progress, Dashboard › Also, Coverage › Every field by country, Platform health › Why values are missing): "Counted <date time> (<age>)" (or "Counted now" when read live) and a **Stale: older than n min** chip past its setting; Completeness shows the build and last-check time (`SnapshotNote`) (Pipeline settings › Platform upkeep / Enrichment). Drill-downs and one university's figures stay live | `SnapshotStamp.jsx`, `SnapshotNote` in `course-coverage.jsx`, `fmtAge` in `lib/format.js`; jobs `admin-read-snapshots`, `course-coverage-snapshot` |
| Layer notices | On Layer 1/2/4 pages: notices that need a person (Action needed, Action outside StudySearch, Optional), each with the one thing to do, a Go to button that opens and scrolls to the exact card or setting (`card=` and `at=` in the address), and the universities listed with Search again or a website box; Acknowledge (Platform Admin, reason). Information-only notices (Nothing to do) are on Toolsets and limits, linked from the layer page (v2.15.268) | `Toolsets.jsx` LayerNotices, Notice, noticePlan; `mature-main.jsx` focusTarget |
| Scripts outside React that patch the page after it renders | `StatisticsDatasetEnhancer.js` (Rankings cards and dataset registry), `ranking-dataset-header.js`, `evidence-acquisition-provenance-entry.js`, `layer4-mass-operations-entry.jsx`, `pim-version-entry.js` (version text, release notes), `release-currentness-entry.js` | `index.html` |

---

## 1. Overview

### Dashboard — `dashboard`, rank 1 (`Dashboard.jsx`)
- **Waiting for you:** one line per queue (count, oldest, Open); "All clear" list.
- **Tiles:** Providers, Courses, Scholarships, Open reviews.
- A link to Coverage & completeness › Progress. (The health strip, Layers and Recent activity were retired in v2.15.266.)
- Read only (`admin_waiting_read`, `admin_read` dashboard).

### Live activity — retired in v2.15.266
- `#live-activity` and `activity` open Coverage & completeness › Progress › Running now (worker errors with Mark as seen moved there).

## 2. Catalogue

### Courses — `courses`, rank 1 (`Catalogue type=course`, drawer `CourseDetailPolish.jsx` and `RecordEditor.jsx`)
- **List:** search (course, provider, code, stable key).
  - Filters: country, state, provider, group, level; advanced: field, delivery, has fee/intake/English, international, has scholarship, min legacy presence, freshness, status, publication.
  - Columns: course, provider, course code (the printed code, else the StudySearch code marked SS; v2.15.271), state, level, field, CRICOS tuition, legacy presence, verified.
  - Search also finds StudySearch codes (e.g. UBC-MA-014).
  - Buttons: Compare, Add course (rank ≥5), Edit in list (rank ≥3).
- **Drawer:**
  - Pills and fact cards: the course code with its kind (CRICOS course code, program code, StudySearch code), tuition used and its source, CRICOS cost, intakes, English, campuses, last checked.
  - Course editor: page, title, duration, delivery, description, tuition, intakes, English, finder address; reason; release lock; archive/restore.
  - Evidence and history (v2.15.366; rank ≥3): the button at the top right opens one overlay (full screen on a phone) with the course's timeline. The blade no longer embeds "What happened to this course"; a line in the blade points to the button.
    - The timeline covers page discovery and reads, page changes, AI matches and fills, admissions and refusals, the fee reader, cross-checks, edits by a person, entry requirement reads and scholarship links. Each entry shows its date, outcome, source and evidence; filters by kind; newest first.
    - Structured values are told in words, for example "4 rows for review, 2 not kept" (v2.15.368).
    - Close with the button or Escape; focus returns to the evidence button.
  - Scholarships for the course (shown again since v2.15.366); an empty list says why and offers "Check scholarships for this course" (task).
  - Academic entry requirements (v2.15.361, Track C Step B):
    - the course's own requirement rows, all statuses, with quote, source, as-at date and audience;
    - the last read and what it did not keep;
    - the resolution for a chosen country of prior education (course rule → course row for the country → course band → provider minimum → contact the provider; case by case kept);
    - countries offered India, Nepal, Singapore first, then A to Z (v2.15.366; the same order in every Entry requirements country selector); the choice is remembered; a change only asks the resolver, never starts a read; the selector wraps inside its card on a phone (v2.15.368);
    - Platform Admin: "Read from the stored page" (reason; one course; the rows wait in Layer 4 as Course entry first read).
    - Read only; since v2.15.363 "Open in Entry requirements" and "Inspect resolution" open the workspace (Catalogue › Entry requirements), where rows are managed.
  - "More about this course" fold: Layer 4 correction and publishing decision, insights, additional information.

### Providers — `providers`
- **Providers** (rank 1):
  - List filters: country, state, group, status, publication.
  - Columns: provider, Adapter (Platform Admin: open/create adapter and its state), country, state, city, courses, group, Evidence count, lifecycle, Published switch (rank ≥5: hides from Wix, Zoho and the website and pauses background work), verified.
  - Scholarship search column (v2.15.271): On, or Off · directory site.
  - Drawer:
    - Logo upload (rank ≥5).
    - Summary: courses, scholarships, contacts, campuses.
    - Scholarship search flag (v2.15.271): On or Off (Off automatically when the only website known is a directory site); rank ≥4 turns it on with the own website and a reason, or off with a reason.
    - "Fill in from website" (Firecrawl) and "Find scholarships now" (tasks).
    - Provider editor (values; archive checklist and restore; regulatory contact; internal-only block).
    - World rankings.
    - Academic entry requirements (v2.15.361): the provider's entry rows with status, country and level filters, 50 a page. Each row shows its quote, source, stored copy, as-at date or edition, and the read with its Layer 4 state. Read only; since v2.15.363 "Open in Entry requirements" opens the workspace filtered to the provider.
      - Sources and reads (v2.15.362): each official source (web page, PDF, page read rendered; at most 50) with its fetch state and its latest read: state, page basis, cost, rows proposed, rows not kept, a hold or error with its reason, and its Layer 4 item. Open when no row was kept. Read only.
    - Layer 4 fold.
- **Campuses** (rank 1):
  - List: campus, provider, country, state, city, courses, status.
  - Edit in list (rank ≥3).
  - Generic drawer (database fields as cards; "More detail" object dump).
- **Logos & assets** (rank 4):
  - Tiles: providers, with a logo, no logo.
  - Logo table with Open provider.
  - Upload happens in the provider drawer (rank ≥5).
- **Archived** (rank 3):
  - Providers and courses that are not active: why, when, by whom.
  - Restore and bulk restore (server `can_restore`); provider departures banner.

### Provider contacts — `contacts`, rank 1 (`ProviderContactsWorkspace.jsx`)
- **Tiles:** active, providers covered, stale or unverified, deleted.
- **Grid:** 13 columns with a column chooser.
  - Filters: country, provider, status, type, source, verification, email, phone, freshness.
- **Drawer:**
  - Contact details, "A15 source observations", history.
  - Edit, verify today, deactivate, delete, restore (rank ≥5).
- **CSV import** with dry run (rank ≥5); export.

### Scholarships — `scholarships`
- **Scholarships** (rank 1):
  - List: scholarship, provider, type, who it is for, value, courses, closes.
  - Drawer (`ScholarshipRecord.jsx`):
    - One row per fact, with source, quote and Change (reason) or "Let automation update this".
    - Evidence & extraction (7 steps); hand-change history; "Read again now" (task).
    - Layer 4 fold: correct, revert, publishing decision, suggest a record.
- **Coverage** (rank 3, `ScholarshipCoverage.jsx`):
  - Tiles: published, watch list, with a listing page, signed off.
  - Auto-published in the last 3 days, with Hold.
  - Provider table: listed, found, published, missing, other, state. Bulk "find scholarships" (≤50).
  - Provider panel:
    - Watch; read listing again; sign off; find now; runs and their journey.
    - Listing pages; the two record tables with publish, international, hold/withdraw, release.
  - "Settings and jobs" fold: skip rules, plus the Layer 2/4 scholarship settings and jobs.
- **Extraction** (rank 3; changes are Platform Admin, `ScholarshipExtraction.jsx`):
  - Tiles: AI admission, models in order, pages waiting or read today, AI cost today.
  - Actions: AI admission on/off; re-check watch list; second model confirms; re-read parked.
  - Model order editor; models table (qualification results, cost per page; Qualify, Make active).
  - Qualification sample (label, leave out).
  - Model instructions (editable, versioned).
  - Try a page; recent answers with quotes.

### Entry requirements — `entry` (v2.15.363, `AerWorkspace.jsx`; server `public.admin_aer`)
Academic entry requirements as a managed data module (decision record `AER-OPERATIONS-WORKSPACE-DECISION-2026-10-29.md`). Admission of AI-read rows stays in Layer 4.
- **Summary** above every tab, for the provider filtered (or all):
  - active (reaches the website);
  - waiting in Layer 4;
  - quarantined;
  - withdrawn or superseded;
  - sources held (with total and reading);
  - courses with requirements (active rows, courses waiting).

  Every tile has words as well as colour.
- **Provider entry matrix** (rank 1):
  - Filters: provider, country, study level (mapped or as published), status (active by default), kind, band, edition, intake year, read state; text search on qualification, quote and level. Chips show what is set, with Clear filters.
  - Columns: provider, country, level, qualification, band, minimum, scale, kind, edition, as-at, status pill (Active, Waiting in Layer 4 with a Layer 4 link, Quarantined, Withdrawn, Superseded; "by hand" for added rows), quote, source, updated. Sorting on the server; 50 a page; a Columns menu (show or hide, remembered in the browser).
  - Edit in list (rank ≥3): for active or quarantined rows only. A reason is required once per session. The editable fields are qualification, level as published, mapped level, band, minimum, value, scale, edition, intake year and as-at. Errors show under the row.
  - Add requirement (rank ≥3), from the provider's own source and its stored copy.
- **Course entry requirements** (rank 1):
  - Filters: provider, course title or code, kind, for (audience), status, band, as-at from and to; text search.
  - Columns: course, kind, requirement, score and basis, band, for, country, as-at, status, quote, source.
  - Edit in list (rank ≥3): requirement, minimum, value, scale, course score, printed basis, band, as-at.
  - Add requirement (rank ≥3).
- **Sources, reads and holds** (rank 1):
  - Filters: provider, fetch state, read state (Read, Reading, Held, Fetch failed, Not read); text search on address or error.
  - Columns: provider (with "outside reading scope"), source and type (web page, PDF, rendered page), fetch, stored copy (date and hash, opens Evidence), latest read pill with tries, rows and rows not kept, hold or error or the reasons rows were not kept, cost, Layer 4, last read and next refresh.
  - Read again (rank 6): one source, with a reason. Not offered for a source held as unreadable, out of scope, or already reading.
- **Resolution inspection** (rank 1): choose a course and a country. It shows:
  - the outcome pill (A minimum is published, Considered case by case, Contact the provider) and the rule used;
  - a five-row table of what each rule looks for, the active rows found and whether it was used, did not apply (and why) or was not reached;
  - the rows returned, with their quotes;
  - what the website does not use (rows waiting in Layer 4, quarantined rows, course rows waiting).
- **Row drawer** (every tab):
  - status and version pills;
  - the requirement and its conditions; rank ≥3 edits conditions as parts (best of N, subject minimums, alternative routes);
  - the full quote, the source and the stored copy;
  - the reading run (model, worker, page basis, cost) and the Layer 4 item;
  - created and updated times;
  - Withdraw, Quarantine and Restore (rank ≥3, with a reason; Restore only after a workspace withdrawal or quarantine);
  - History: every change by a person with when, who, what, before, after and reason.

### Rankings & statistics — `rankings`
- **Overview** (rank 1):
  - Cards: QILT, PRISMS, QS and THE (edition, observations, mapped), each with Open dataset and Compare; coverage notes.
  - Dataset drill-down: publisher institution, linked provider, rank, score; Link (rank as allowed).
- **Compare** (rank 1): up to 6 providers or courses across QILT, PRISMS, QS and THE, each with its own year selector.
- **Outcomes (QILT)** and **Student flow (PRISMS)** (rank 1): filters and a table of raw published figures; columns are picked automatically from the data.
- **Datasets** (rank 4): dataset registry (name, short key, type, publisher, Shown switch, imports); Add dataset.

### Reference data — `reference`
- **Ranking imports** (rank 4):
  - Register a publisher file (system, edition, files, advanced metadata), then parse and validate, apply edition.
  - Imported files list with jobs and XLSX export (edge functions `ranking-publisher-import`, `ranking-publisher-control`, `ranking-evidence-export`).
- **Key dates** (rank 3):
  - Dates edited in place: what, kind, precision, source, warn days, cancel or restore.
  - Add date (tied record id, refresh layer); recent changes.
- **Reference sources** (rank 3):
  - Tiles: sites in use, never a university website, not checked.
  - Site list (uses, category, country, status, on); check now or check all; retire or restore; recent changes.

## 3. Data pipeline

### Coverage & completeness — `coverage`
- **Courses** (rank 1):
  - Filters; tiles (completeness score, accounted for, fully complete).
  - Bands by attributes admitted; daily trend table.
  - Link refresh schedules and portals that supply course links.
- **Attributes** (rank 1):
  - Key figures per attribute.
  - Coverage against the 80% target by source.
  - Completeness by attribute (9 states; click to list courses).
  - Coverage by pipeline stage (10 states).
  - "By area" fold (providers, courses, campuses, scholarships; exceptions list).
- **Progress** (rank 3, `Progress.jsx`, v2.15.266; read `admin_progress_read(view, args)`), four views (`?view=`):
  - **Overview:** group picker (all universities, pilot, top 50 Australia); tiles (universities and done, need a person, scholarships published and found, course pages in the last hour, Firecrawl today); Needs attention (stopped universities by reason, each opening Journeys; Firecrawl and OpenRouter notices); the seven journey stages and Done (each opening Journeys); courses with intakes, English, fee and delivery (when picked → now for a group); Firecrawl shares and AI spend today; every hour of the last 24 (snapshots kept 90 days).
  - **Journeys** (as the approved mock-up since v2.15.267): filter panel (group, country, stage, held up by: needs a person, waiting for course pages, scholarship credits used, search stopped or held, AI reading pages; Only held up; find; count, sorted by courses); one row per university: courses, adapter journey as seven stage pills (amber when held), fields filled (intakes, English, fee, delivery %), scholarship journey (found, with the AI, published; or not searched yet), held up by (or Nothing), Next step button. A selected university shows its steps (stage, from–to, last note) and now, and its run-on-demand actions: Find scholarships now, Read course pages again, Qualify adapter (rank ≥4, tasks with progress), Read the scholarship pages with AI again, Search again, Retry onboarding when stopped (Platform Admin, reason); links to its adapter, the Adapter builder and Scholarships.
  - **Running now:** tiles (running, failing in 24 h, paused, Firecrawl last hour and refused); every scheduled job by journey stage with how often (in words since v2.15.267), Running / Waiting / Failing / Paused, last 24 h, last result (what the worker reported, or succeeded / failed and when), Pause / Resume / Run now (Platform Admin); a job opens to the universities it worked on in the last hour or, when it touched none, the universities now at its stage (marked), each with Open journey; Workers sending back errors with Mark as seen (rank ≥4). Refreshes every 20 s; filter "Only what is busy or needs attention".
  - **Levers:** onboarding pace, Firecrawl daily budget and AI guards: value now, what it did today, Change (opens the screen where it is changed); Run on demand links.

### Layer 1 Register — `layer1`
- **Sources** (rank 4, `layer1-operations-entry.jsx`):
  - Health tiles as filters; source list (country, type, health, last run, schedule).
  - Open row:
    - Why it needs attention; facts; edition found; live run progress.
    - Run now, check, pause, recover, apply edition, approve departures.
    - Settings (Platform Admin): address, authority domains, format, schedule, check/load days, warn/stop %, fewest/most records.
    - Edition history.
  - Add source (Platform Admin).
- **Scholarships** (rank 4, `ScholarshipLayer layer=1`):
  - Countries switched on for scholarships.
  - Settings (number or switch, range, last change).
  - Jobs (schedule, runs and failures over 7 days, pause).

### Layer 2 Discovery & reading — `layer2`
- **Operations › Governed actions** (Platform Admin only, `GovernedActions.jsx`, v2.15.360, Decision 268):
  - Operations approved here instead of run as SQL. Each action shows the live state it acts on, then **Preview against the live system**:
    - each precondition, expected and now, pass or fail;
    - a dry run that is rolled back;
    - the action hash, and when the approval expires.
  - **Approve and run** (with a reason) runs it once. A repeated click runs nothing. The result shows Done, Refused or Failed (nothing changed), with the post-checks and the audit event, and a history of every attempt.
  - **First and only action: Close the AER PR A recovery.** It shows the six runs' outcomes and costs, the proposed, active and quarantined counts, the reading scope now and after, and the pages left as they are.
- **Adapters** (rank 4, `AdaptersWorkspace.jsx`):
  - List filters and bulk actions: Qualify, Admit, switch on/off, read cycle, read again.
  - The list reads one page at a time (v2.15.371, W33; page size setting `layer23.universities_page_size`). Filters, name search and name order apply to the whole list on the server. **Show more** reads the next page; "N shown of M" and the adapter tally count every matching university. **Tick every row shown** ticks every matching row, up to `layer23.universities_tick_max`. A `?provider=` link opens that university directly.
  - Open row:
    - Coverage tiles.
    - Switch, Qualify and Admit; build and test (editor).
    - Read schedule; central pages; fee range and rules; hosted courses; Firecrawl target.
    - History; courses.
  - Page cards: how an adapter goes live, Firecrawl runs, targets and credits, what each university needs next, page fees against CRICOS (dry run), fee range settings.
- **Adapter builder** (rank 5; running steps Platform Admin, `AdapterBuilderTab.jsx`):
  1. Provider: website, contacts, central pages and approvals.
  2. Course pages: find with Firecrawl, add by hand, capture samples.
  3. Model proposes the adapter; save in testing and apply; qualify; admit.
  4. Adjust by hand (editor; validate and admit).
- **Onboarding** (rank 3; actions Platform Admin, `ProviderOnboarding.jsx`):
  - Auto-admit note; a link to Progress for the pilot and the top 50 (the Pilot panel was retired in v2.15.266); 7-stage strip with pace and estimate.
  - Tiles; list with filters, journey drawer, retry/stop, onboard universities not yet queued.
  - Onboarding settings (on, auto-admit, start new ones, how many at once, run as me); approvals waiting (fee schedules, English policies, calendars).
- **Scholarships** (rank 4, `ScholarshipLayer layer=2`):
  - Discovery and reading by country; Firecrawl credits for scholarships; worker answers (6 h).
  - Settings and jobs.

### Layer 4 Review — `layer4`
- **Review queue** (rank 3, `m2-3-intelligence-entry.jsx`):
  - Tiles: waiting, oldest, suggested reject or approve.
  - Filters: status, task, mine/unassigned.
  - Views:
    - One by one: context, edit form, note, approve, reject, edit and approve, more evidence, send back; keys R/A/E/N.
    - Bulk decisions: preview, typed confirm; provider departures; errors and improvements; decision history.
    - Team and forecast.
- **AI could not decide** (rank 3, `ScholarshipAiReview.jsx`):
  - Tiles: waiting, model order, rerouted counts.
  - Cards: each model's answer with proofs; Admit the chosen answer or Refuse; read the waiting pages again.
- **Websites to find** (rank 3, `WebsitesToFind.jsx`): university, courses, what was tried, website box and Save.

## 4. Operations

### Platform health — `health`
- **Health checks** (rank 3):
  - Overall status and tiles (critical, warning, information).
  - Open issues by area, with a link to fix; checks table; 14-day chart.
- **Capacity** (rank 6, `platform-maturity-entry.jsx`):
  - Production boundary banner; overview and governance counts.
  - Capacity tiles; evidence lineage counters; temp activity; backup/PITR.
  - Largest relations; workload profiles; retention policy (dry run).

### Scheduled jobs — `jobs`
- **Automations** (rank 4):
  - Cron jobs by area: how often, batch size, last run, 24 h runs and failures; pause, resume, run now, change frequency, batch size (rank ≥5 and the job's control rank); recent changes.
  - Then **Refresh schedules and one-off runs** (`ScheduledJobsWorkspace.jsx`): schedule policies table (13 columns, edit, run on demand), refresh queue, runtime health, search refresh signals.
- **Priority queue** (rank 3):
  - Course-page search budget (used, cap, left, waiting; Save cap, Platform Admin).
  - Pinned to the front; current order (first 60); add to the front; recent changes.
- **Jobs** (rank 4, `pipeline-ops-entry.jsx`):
  - Job history with 8 filters.
  - Expandable detail: register run batches; admin task result with Admit the passing fields; or generic run detail with evidence and hashes.
- **Task manager** (rank 4, `AdminTasks.jsx`):
  - Tasks running or waiting (pause, resume, cancel with reason).
  - A link to Coverage & completeness › Progress › Running now (Task manager's own Running now board was retired in v2.15.266).
  - Task detail.

### Evidence — `evidence`, rank 3 (`EvidenceWorkspace.jsx`)
- Search; 17 filters (including UUID and hash).
- Table: artifact, source, layer, type, captured, extraction, freshness, status, job, integrity.
- Drawer: preview or download (signed link, 60 s), lineage, hash, observations, affected records, claims and reviews, storage controls.

### Sources — `sources`, rank 4 (read only)
- Card per source across layers: status, trust rank, last success, freshness, running and problem jobs, evidence, last error, configuration.

## 5. Platform settings

### Settings — `environment`, rank 6 (`PipelineSettings.jsx`, `EnvironmentMigrationWorkspace` integrations, `PlatformResourcesPanel.jsx`)
- Pipeline numbers: find (queue counts, search cap), identify (country × attribute rules), budgets (read-only Firecrawl limit and reserve); recent changes.
- **Settings register (v2.15.269, `SettingsRegister.jsx`):**
  - **Controls check banner:** it says every running job reads its sizes from settings, or lists the jobs that do not.
  - **Cards:** Job sizes (33), Re-read and retry (19) and Onboarding (8).
  - **Each setting** shows its value, unit and range, what uses it, and the last change and reason. Save needs an inline reason (Platform Admin).
  - **Policy cards:** capacity thresholds, evidence storage thresholds, retention rules, and provider fee profiles and basis rules (on or off, review date). Each value is edited in its cell with a reason.
- External services overview and stored key names.
- Platform resources and cost (database, cache, jobs, storage, monthly toolset cost; editable cost model).
- Keys:
  - Firecrawl, ZenRows and other providers.
  - Apollo.
  - "OpenRouter / Layer 3" (profile select).
  - Production automation.
  - Consumer API tokens (Zoho, website).

### Scrapers & fetchers — `scrapers`, rank 4 (`layer2-provider-entry.jsx`)
- Fetch service registry: adapter, base URL, credential, concurrency, rate, timeout, Firecrawl monthly limit and reserve, capabilities.
- Edit (Platform Admin, including raw JSON templates); set or rotate key; add provider.

### Models & services — `services`, rank 4 (`ModelsServices.jsx`, `AiConfig.jsx`, `Toolsets.jsx`, `FirecrawlCredits.jsx`, `FirecrawlWork.jsx`)
Tabs (v2.15.264): **Services** (`?tab=services`, default) · **AI & OpenRouter** (`?tab=ai`) · **Toolsets & limits** (`?tab=limits`; the credit banner and Firecrawl links open it).
- AI & OpenRouter (`AiConfig.jsx`, reads `admin_ai_config_read`): OpenRouter account card (balance, floor, warning, mode switch, credit floor edit, key set and verify — Platform Admin); AI uses card (use, model, calls and spend today, editable daily guard, state; central pages model select and switch; adapter proposal model); Scholarship AI models card (`ScholarshipAiModels`: order editor, qualify, make active); Model profiles and prompts card; Recent AI changes.
- On/off switches for page-fetching services and AI models (7-day calls and cost, tests); retired models; recent changes.
- Toolsets and limits: one card per toolset.
  - Mode: Observe only, or Stop at limits.
  - Key and plan.
  - OpenRouter balance, floor, daily guards, spend by day.
  - Settings by section: key and plan limits, use, daily guards, target universities, read pages, find pages, runs, daily budget (Firecrawl, v2.15.262: on/off, credits a day, share per purpose, search stop, scholarship cap per university, central pages refresh).
- Firecrawl credits by university (v2.15.262, collapsed card, rank ≥3 to view): today's budget per purpose (used, share, %, refused) and billed today; window last hour / 24 h / 7 days; Flagged only; per university credits by purpose, correct pages, wrong Firecrawl pages, credits per correct page, flag (Search stopped, No pages from 100+ credits, Mostly wrong pages, High scholarship use); Search again (Platform Admin, reason) on a stopped university. **Refused today, by university** (v2.15.265): university, country, search order (Top 50 / Australia, 30+ courses / Overseas / Small provider), refused count, why (directory site, fewer than 30 courses, scholarship cap, central pages not due, search stopped, share or day's total used, by purpose), Search held chip with Search again. Reads `admin_firecrawl_credits`, writes `admin_firecrawl_search_resume`.
- Firecrawl credits and support report; search pass; sample runs.

### Data model — `dataModel`, rank 5
- Read-only tables of families, groups, attributes, options, completeness profiles (raw columns, 200-row limit).

### Storage & retention — `retention`, rank 6 (`RetentionScreen.jsx`)
- Categories with rule, size now, would go, status.
- Preview, purge (reason and typed key), stop, run audit; runs.

### Go-live checklist — `migration`, rank 6
- Production environment values; Supabase Production migration manifest (status per component).
- Gates: Layer 1 sources, Layer 2 providers, Layer 3 model profiles.
- UAT and accepted domains.

## 6. Administration and guides

### Users & roles — `users`, rank 6 (`access-roles-entry.jsx`)
- Role help; tiles; user directory (auth state, roles, effective role, last sign-in); roles with expiry; disable; create user; recent access changes.

### Guides — `guide`
- **Platform guide** (rank 1): how it works, who does what, your role, daily routine, the screens, signal → action, admin duties, alert emails, what changed.
- **Platform Admin SOP** and **Operator SOP** (rank 3): versioned; download as Markdown; copies in `docs/sops/`.

---

## 7. Drop-down options by country (checked live 14 Oct 2026, v2.15.270)

Raised by the Platform Admin (14 Oct 2026, 07:13): "Courses > state filter is not showing options for nz and Canada. Cross check all filters across all pages." Counts are the options each list offers for Australia / New Zealand / Canada, read live through the same calls the screens make.

| Page › filter | AU | NZ | CA | Status |
|---|---|---|---|---|
| Courses › Country | 3 countries | | | OK |
| Courses › State / Region / Province | 8 | 15 | 10 | **Fixed in v2.15.270** (was 0 for NZ and CA). A course without a campus region takes its university's region |
| Courses › Provider | 1,556 | 287 | 82 | OK; now also follows the region |
| Courses › Study level | 20 | 5 | 4 | OK |
| Courses › Delivery | 4 | 4 | 4 | **Fixed**: was "on_campus" only; now On campus, Online, Blended, On campus and online from the course itself |
| Courses › University group | 4 | 0 | 0 | Groups exist for Australia only; the empty list now says so |
| Courses › Field | 79 | 0 | 0 | Data gap: NZ and Canadian courses have no field classification yet; the empty list says so |
| Courses › list column State / Region, Has state | | | | **Fixed**: NZ and CA rows show the university's region (was "—") |
| Providers › Country, State / Region | 8 | 15 | 12 | OK (read from providers) |
| Campuses › Region | 8 | (15) | (12) | Regions list, but no NZ or Canadian campuses are recorded |
| Scholarships › Country, Provider | yes | yes | yes | OK |
| Provider contacts › Country | 6 countries | | | OK; **fixed**: the Provider picker now follows the country |
| Rankings › Country, State | 8 | 5 | 8 | OK |
| Coverage, Evidence, Pipeline, Link refresh › Country | yes | yes | yes | OK |
| Progress › Country | yes | yes | yes | OK |
| Websites to find › Country | yes | yes | yes | **Fixed**: the list kept only the chosen country |
| Priority queue › State | 8 | 15 | 12 | OK; label now "State or region" |
| Data Quality › Scope | yes | yes | yes | **Fixed**: Canada was refused; it is computed when opened (about 2 s). "All" stays Australia and New Zealand (stored snapshots) |
| Key dates › Country | yes | yes | yes | **Fixed**: Canada added |
| Layer 1 › Regulatory sources | yes | yes | yes | **Fixed**: Canada is in scope |
| Layer 4 › fee Currency | AUD | NZD | CAD | **Fixed**: CAD added |
| Enrichment operations, Provider assets › Country | yes | yes | yes | **Fixed**: Canada was refused or left out (logo cohort AU 39, NZ 8, CA 32) |
| Scholarship record › amount | | | | **Fixed**: no longer labelled A$ (the university's own currency is used) |

Found while checking, not changed: about half of Canadian courses (5,250 of 10,394) hold a long source identifier in "CRICOS / course code"; PRISMS and QILT are Australian data sets.

## Version history
| Version | Date | Change |
|---|---|---|
| 1.0 | 12 Oct 2026 | First issue, read from the code at v2.15.260. |
| 1.11 | 28 Oct 2026 | v2.15.361: Academic entry requirements in the Provider drawer and the Course detail blade (Track C Step B). |
| 1.12 | 29 Oct 2026 | v2.15.362: Provider drawer › Academic entry requirements › Sources and reads (AER programme). |
| 1.15 | 30 Oct 2026 | v2.15.371: Layer 2/3 › Universities reads one page at a time with server-side filters, search and order (Show more; Tick every row shown ticks every match). v2.15.370 had no screen change. |
| 1.14 | 29 Oct 2026 | v2.15.366–v2.15.368: Course detail evidence and history overlay (blade history removed), course scholarships back with an explained empty state, priority country order, phone row drawer and notice fixes, evidence values in words, country selector fits a phone. |
| 1.13 | 29 Oct 2026 | v2.15.363: Catalogue › Entry requirements (AER operations workspace): four tabs, summary, filters, Columns, Edit in list, Add requirement, lifecycle, history, Read again, Resolution inspection; drawer sections become shortcuts. |
| 1.9 | 14 Oct 2026 | v2.15.271: course code column and StudySearch codes; Scholarship search flag on Providers and in the provider panel. |
| 1.8 | 14 Oct 2026 | v2.15.270: section 7, drop-down options by country; region, delivery and country fixes. |
| 1.7 | 13 Oct 2026 | v2.15.269: settings register and policy tables on Pipeline settings; Firecrawl Find pages settings (map sizes, search results, search-stop window); proxy for every read. |
| 1.6 | 13 Oct 2026 | v2.15.268: notices say what to do, open the exact card, act in place; information-only notices on Toolsets and limits. |
| 1.5 | 13 Oct 2026 | v2.15.267: Progress › Journeys as the mock-up; Running now universities for every job. |
| 1.4 | 13 Oct 2026 | v2.15.266: Coverage & completeness › Progress; Live activity, the Pilot panel, the Dashboard health strip, Layers and Recent activity, and Task manager's Running now retired. |
| 1.3 | 13 Oct 2026 | v2.15.265: Refused today, by university on the Firecrawl credits card. |
| 1.2 | 13 Oct 2026 | v2.15.264: Models & services tabs; AI & OpenRouter. |
| 1.1 | 12 Oct 2026 | v2.15.262: Firecrawl daily budget settings and the Firecrawl credits by university card. |
