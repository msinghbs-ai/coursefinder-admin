# StudySearch Admin – UI catalogue (every screen, what it shows, what it does)

**Version:** 1.18 (8 Nov 2026, platform release v2.15.494)
**Change control:** CF-247; SS-020 admin menu consolidation (Decision 269)
**Source:** read from the Pilot repository code at `origin/main` 725fc7f6 (`src/nav-map.js` PAGES, SECTIONS and LEGACY, `src/mature-main.jsx` `pageBody`, each screen's component), not from older documents.
**Rule:** every release that adds, removes or changes a screen, tab, panel, column, action or setting updates this page in the same change-control entry and raises its version. Proposed simplifications are in `UI-SIMPLIFICATION-REVIEW.md`; the SS-020 decisions are in `ui-audit/2026-11-03-admin-menu-keep-merge-retire-review.md` (C01–C53) and `ui-audit/2026-11-03-ss020-execution-mandate-2159.md`.

Roles (rank): 1 Viewer · 2 Counsellor · 3 Curator · 4 Pipeline Operator · 5 PIM Admin (shown in the header as "PIM Operator") · 6 Platform Admin.

**The menu at v2.15.457: 47 tabs on 20 pages** (counted from `PAGES` in `nav-map.js`; a page without tabs counts as one tab). SS-020 took it from 53 tabs: Toolsets & limits and Fetchers joined Services (step 3); Work queues became Queues & yield, taking Pipeline yield (step 3); Progress left Coverage and Build adapter left Layer 2/3 (step 4); Outcomes (QILT) and Student flow (PRISMS) became View data on Datasets (step 5). No role minimum was lowered or raised, except Rankings › Datasets (see 2.7). Every old address still opens the right place (section 7).

In the tab tables below, **Key** is the tab's address (`#<page slug>?tab=<key>`; the first tab needs no `tab=`), and **Min** is the lowest rank that may open it. A page shows in the menu when the role can open at least one of its tabs. A lower role that follows a link to a tab it cannot open sees which role opens it, and the first tab it may open instead.

---

## 0. App shell (all pages)

| Part | What it shows / does | Source |
|---|---|---|
| Sidebar | Sections: (top) Dashboard · Catalogue · Data pipeline · Operations · Platform settings · Administration · Guides. A page shows only if the role can open one of its tabs. Health dot on Platform health. Account box (role, email, Sign out) | `nav-map.js` SECTIONS; `mature-main.jsx` |
| Header | Breadcrumbs, title and subtitle from nav-map; Health pill (rank ≥3, re-read every 5 min); version pill (opens the release notes); role pill | `mature-main.jsx`, `ReleaseNotes.jsx` |
| Credit banner | Firecrawl, OpenRouter, adapter AI allowance, scholarship scraper cap when low (rank ≥3; every 5 min); link to Models & services (opens Services & limits since v2.15.455); × hides until reload | `CreditBanner.jsx` |
| Snapshot stamp (v2.15.373, W34/W35) | On screens read from a cached snapshot (Coverage › Courses and Attributes, toolset notices, Services & limits, Layer 2/3 › Operations (Progress), Dashboard › Also, Coverage › Every field by country, Platform health › Why values are missing): "Counted <date time> (<age>)" (or "Counted now" when read live) and a **Stale: older than n min** chip past its setting; Completeness shows the build and last-check time. Drill-downs and one university's figures stay live | `SnapshotStamp.jsx`, `SnapshotNote` in `course-coverage.jsx`; jobs `admin-read-snapshots`, `course-coverage-snapshot` |
| Layer notices | Notices that need a person (Action needed, Action outside StudySearch, Optional), each with the one thing to do and a Go to button that opens the exact card or setting; Acknowledge (Platform Admin, reason). Shown on Layer 1, Layer 4 and **Layer 2/3 › Operations only** (v2.15.454: no longer repeated on every Layer 2/3 tab). Information-only notices are on Services & limits › Notices | `Toolsets.jsx` LayerNotices; `mature-main.jsx` |
| Refused-tab handoff | A tab the role cannot open names the role that can, and shows the first tab the role may open | `nav-map.js` refusedTab, ROLE_NAMES |

---

## 1. Overview

### 1.1 Dashboard — `dashboard`, rank 1 (`Dashboard.jsx`)
- **Waiting for you:** one line per queue (count, oldest, Open); "All clear" list.
- **Tiles:** Providers, Courses, Scholarships, Open reviews.
- One link line: how the platform is progressing and what is running, on Layer 2/3 › Operations (v2.15.456; was Coverage › Progress).
- Read only.

## 2. Catalogue

### 2.1 Courses — `courses`, rank 1 (`Catalogue type=course`, drawer `CourseDetailPolish.jsx` and `RecordEditor.jsx`)
- **List:** search (course, provider, code, stable key).
  - Filters: country, state, provider, group, level; advanced: field, delivery, has fee/intake/English, international, has scholarship, min legacy presence, freshness, status, publication.
  - Columns: course, provider, course code (the printed code, else the StudySearch code marked SS; v2.15.271), state, level, field, CRICOS tuition, legacy presence, verified.
  - Search also finds StudySearch codes (e.g. UBC-MA-014).
  - Buttons: Compare, Add course (rank ≥5), Edit in list (rank ≥3).
- **Drawer:**
  - Pills and fact cards: the course code with its kind (CRICOS course code, program code, StudySearch code), tuition used and its source, CRICOS cost, intakes, English, campuses, last checked.
  - Course editor: page, title, duration, delivery, description, tuition, intakes, English, finder address; reason; release lock; archive/restore.
  - Evidence and history (v2.15.366; rank ≥3): the button at the top right opens one overlay (full screen on a phone) with the course's timeline.
    - The timeline covers page discovery and reads, page changes, AI matches and fills, admissions and refusals, the fee reader, cross-checks, edits by a person, entry requirement reads and scholarship links. Each entry shows its date, outcome, source and evidence; filters by kind; newest first.
    - Structured values are told in words, for example "4 rows for review, 2 not kept" (v2.15.368).
    - Close with the button or Escape; focus returns to the evidence button.
  - Scholarships for the course; an empty list says why and offers "Check scholarships for this course" (task).
  - Academic entry requirements (v2.15.361):
    - the course's own requirement rows, all statuses, with quote, source, as-at date and audience;
    - the last read and what it did not keep;
    - the resolution for a chosen country of prior education (course rule → course row for the country → course band → provider minimum → contact the provider; case by case kept);
    - countries offered India, Nepal, Singapore first, then A to Z; the choice is remembered; a change only asks the resolver, never starts a read;
    - Platform Admin: "Read from the stored page" (reason; one course; the rows wait in Layer 4 as Course entry first read).
    - Read only; "Open in Entry requirements" and "Inspect resolution" open the workspace.
  - "More about this course" fold: Layer 4 correction and publishing decision, insights, additional information.
- Operated from a phone (guarded by `s121`).

### 2.2 Providers — `providers` (4 tabs)

| Tab | Key | Min | What it shows | What it does |
|---|---|---|---|---|
| Providers | `providers` | 1 | Provider list and drawer | Published switch, editing, tasks |
| Campuses | `campuses` | 1 | Every campus | Edit in list (rank ≥3) |
| Logos & assets | `assets` | 4 | Logo tiles and table | Opens the provider (upload is in its drawer) |
| Archived | `archived` | 3 | Providers and courses not active, with why | Restore, bulk restore |

- **Providers:**
  - List filters: country, state, group, status, publication.
  - Columns: provider, Adapter (Platform Admin: open/create adapter and its state), country, state, city, courses, group, Evidence count, lifecycle, Published switch (rank ≥5: hides from Wix, Zoho and the website and pauses background work), verified, Scholarship search (On, or Off · directory site).
  - Drawer: logo upload (rank ≥5); summary (courses, scholarships, contacts, campuses); Scholarship search flag (rank ≥4 changes it with a reason); "Fill in from website" and "Find scholarships now" (tasks); provider editor (archive checklist and restore; regulatory contact; internal-only block); world rankings; academic entry requirements (rows, 50 a page, and Sources and reads; read only, "Open in Entry requirements"); Layer 4 fold.
- **Campuses:** campus, provider, country, state, city, courses, status; generic drawer.
- **Logos & assets:** tiles (providers, with a logo, no logo); logo table with Open provider.
- **Archived:** why, when, by whom; Restore and bulk restore (server `can_restore`); provider departures banner.

### 2.3 Provider contacts — `contacts`, rank 1 (`ProviderContactsWorkspace.jsx`)
- **Tiles:** active, providers covered, stale or unverified, deleted.
- **Grid:** 13 columns with a column chooser. Filters: country, provider, status, type, source, verification, email, phone, freshness.
- **Drawer:** contact details, source observations, history; edit, verify today, deactivate, delete, restore (rank ≥5).
- **CSV import** with dry run (rank ≥5); export.

### 2.4 Scholarships — `scholarships` (2 tabs)

| Tab | Key | Min | What it shows | What it does |
|---|---|---|---|---|
| Scholarships | `list` | 1 | Published scholarships and each one's record | Change a fact (reason), read again, Layer 4 fold |
| Coverage | `coverage` | 3 | Each provider measured against its own listing page | Find, watch, sign off, publish, hold |

- **Scholarships:** list (scholarship, provider, type, who it is for, value, courses, closes). Drawer (`ScholarshipRecord.jsx`): one row per fact with source, quote and Change (reason) or "Let automation update this"; evidence and extraction (7 steps); hand-change history; "Read again now" (task); Layer 4 fold (correct, revert, publishing decision, suggest a record).
- **Coverage** (`ScholarshipCoverage.jsx`): tiles (published, watch list, with a listing page, signed off); auto-published in the last 3 days, with Hold; provider table (listed, found, published, missing, other, state) with bulk "find scholarships" (≤50); provider panel (watch, read listing again, sign off, find now, runs; listing pages; the two record tables with publish, international, hold/withdraw, release).
  - **Changed in v2.15.456:** the "Settings and jobs" fold left this tab. A line says the scholarship settings and jobs are on Layer 2/3 › Scholarships.
- Scholarship extraction (the AI that reads scholarship pages) is on Models & services › AI & OpenRouter.

### 2.5 Entry requirements — `entry` (4 tabs; `AerWorkspace.jsx`; server `public.admin_aer`)
Academic entry requirements as a managed data module. Admission of AI-read rows stays in Layer 4.

| Tab | Key | Min | What it shows | What it does |
|---|---|---|---|---|
| Provider entry matrix | `matrix` | 1 | Provider rows by country and level | Edit in list, Add requirement (rank ≥3) |
| Course entry requirements | `course` | 1 | Course rows; Course-level reading by provider | Edit in list, Add requirement (rank ≥3) |
| Sources, reads and holds | `sources` | 1 | Each official source and its latest read | Read again (rank 6, reason) |
| Resolution inspection | `resolve` | 1 | How one course resolves for one country | Read only |

- **Summary** above every tab: active, waiting in Layer 4, quarantined, withdrawn or superseded, sources held, courses with requirements. Every tile has words as well as colour.
- **Provider entry matrix:** filters (provider, country, level, status, kind, band, edition, intake year, read state; text search) with chips and Clear filters; columns provider, country, level, qualification, band, minimum, scale, kind, edition, as-at, status pill, quote, source, updated; server sorting, 50 a page, a Columns menu. Edit in list for active or quarantined rows (reason once a session).
- **Course entry requirements:** filters (provider, course, kind, for, status, band, as-at range; text search); columns course, kind, requirement, score and basis, band, for, country, as-at, status, quote, source.
  - **Course-level reading** (changed in v2.15.454): the provider table shows **100 providers a page** with a pager. The totals and the Provider picker still count every provider.
- **Sources, reads and holds:** filters (provider, fetch state, read state; text search); columns provider, source and type, fetch, stored copy (opens Evidence), latest read with tries, rows and rows not kept, hold or error, cost, Layer 4, last read and next refresh.
- **Resolution inspection:** choose a course and a country; the outcome and rule used, the five-rule table, the rows returned with quotes, and what the website does not use.
- **Row drawer** (every tab): status and version, the requirement and its conditions (rank ≥3 edits conditions as parts), quote, source, stored copy, reading run, Layer 4 item; Withdraw, Quarantine and Restore (rank ≥3, reason); history of every change by a person.
- The entry-requirement review readiness line moved from Coverage › Attributes to Layer 4 › Inbox (v2.15.456).

### 2.6 Rankings & statistics — `rankings` (3 tabs)

| Tab | Key | Min | What it shows | What it does |
|---|---|---|---|---|
| Overview | `overview` | 1 | One card per shown dataset (QILT, PRISMS, QS, THE and any added) | View data, Open dataset, Compare |
| Compare | `compare` | 1 | Up to 6 providers or courses across the datasets | Pick providers or courses and a year per dataset |
| Datasets | `datasets` | 1 | View data for QILT and PRISMS; the dataset register and ranking imports (rank ≥4) | View data (every role); add and edit datasets, imports (rank ≥4) |

- **Overview:** the QILT and PRISMS cards have **View data** (v2.15.457; was Open dataset to their own tab), which opens Datasets on that dataset. QS and THE cards have an edition picker, Open Dataset and Compare. Dataset drill-down: publisher institution, linked provider, rank, score.
- **Datasets** (changed in v2.15.457):
  - **View data bar** (every role): "View data: QILT outcomes" and "View data: PRISMS student flow". Each opens the dataset's table of raw published figures with its filters (the old Outcomes (QILT) and Student flow (PRISMS) tabs). The address is `?tab=datasets&data=qilt` or `&data=prisms`; pressing the button again closes it.
  - **Dataset register** (rank ≥4): name, short key, type, publisher, Shown switch, Imports link; QILT and PRISMS rows also have View data; Add dataset (new datasets start hidden).
  - **Ranking imports** (rank ≥4): register a publisher file (system, edition, files, metadata), parse and validate, apply edition; imported files with jobs and XLSX export.
  - Because QILT and PRISMS data were open to every role, the tab now opens at rank 1. The register and imports keep their rank 4 minimum inside the tab (confirmation requested, section 8).

### 2.7 Reference data — `reference`, rank 3 (one list with a type filter: All · Key dates · Reference sources, `?type=dates|links`)
- **Key dates** (changed in v2.15.454): the list is **read only, 50 dates a page** (date, what, country and scope, kind, precision, source site, warn days). **Edit** (or Open, below the editing role) opens one date in a drawer with its editors (date, what, source wording, kind, precision, source address, warn days), Cancel date and Restore. Add date; show cancelled; recent changes.
- **Reference sources:** tiles (sites in use, never a university website, not checked); site list with expandable rows (uses, category, country, status, on); check now or check all; retire or restore; recent changes.
- Ranking imports are on Rankings & statistics › Datasets.

## 3. Data pipeline

### 3.1 Coverage & completeness — `coverage` (2 tabs)

| Tab | Key | Min | What it shows | What it does |
|---|---|---|---|---|
| Courses | `courses` | 1 | How complete each course is; link refresh schedules | Link refresh edits (rank ≥4) |
| Attributes | `attributes` | 1 | Each attribute across all courses (measures only) | Read only; links to Enrich fields |

- **Courses:** filters; tiles (completeness score, accounted for, fully complete); bands by attributes admitted; daily trend table.
  - **Link refresh** (`LinkRefresh.jsx`): how often each kind of course link is re-checked (all countries, a country or a provider; the most specific wins) and which portals supply links; Pipeline Operator and above change them. It stays here for now (open decision, section 8).
- **Attributes** (changed in v2.15.456: **read only**):
  - Key figures per attribute; coverage against the 80% target by source; completeness by attribute (9 states; click to list courses); coverage by pipeline stage; field coverage by country.
  - **Stalled fields** are listed without run buttons. Each row has **Fill on Enrich fields**, which opens Layer 2/3 › Enrich fields with its country and field chosen (`?country=&field=`).
  - Fill the gaps (standing queue) and Provider descriptions moved to Layer 2/3 › Enrich fields; the review readiness line moved to Layer 4 › Inbox.
  - "By area" fold (providers, courses, campuses, scholarships; exceptions list).
- **Progress retired as a tab (v2.15.456):** its Overview, Journeys and hourly history are on Layer 2/3 › Operations; Firecrawl and AI today is on Models & services › Services & limits. "Courses with each field" retired in v2.15.452 (it repeated Attributes). Running now opens Scheduled jobs › Task manager; Levers opens Settings.

### 3.2 Layer 1 Register — `layer1`, rank 4 (one Sources page with a layer filter: Registers (Layer 1) · All layers, `?layer=all`)
- **Registers (Layer 1)** (`layer1-operations-entry.jsx`): health tiles as filters; source list (country, type, health, last run, schedule). Open row: why it needs attention, facts, edition found, live run progress; run now, check, pause, recover, apply edition, approve departures; settings (Platform Admin: address, authority domains, format, schedule, check/load days, warn/stop %, fewest/most records); edition history. Add source (Platform Admin).
- **All layers:** every source the pipeline reads (status, trust rank, last success, freshness, running and problem jobs, evidence, last error, configuration). Read only.
- The Layer 1 refresh cadence is still edited on Scheduled jobs › Automations (open decision, section 8).

### 3.3 Layer 2/3 Build & enrich — `layer2` (8 tabs, in this order since v2.15.456)

| Tab | Key | Min | What it shows | What it does |
|---|---|---|---|---|
| Operations | `operations` | 3 | Each stage, the jobs behind it, Progress (overview, journeys, every hour), layer notices | Pause, resume, run now; onboarding pace; governed actions (Platform Admin) |
| Universities | `universities` | 3 | One row per university; Build adapter for one university or all, with the waves | Build, Qualify, Admit, switch, read again |
| Enrich fields | `enrich` | 3 | Stalled fields, the standing queue, enrichment tasks, provider descriptions, fee reader | Fill now, Release holds, start, retry, export |
| Enrichment plan | `plan` | 3 | Each university's plan from its own gaps, with estimates | Run now (rank ≥4), cancel, retry, export |
| Adapter builder | `builder` | 5 | Step 0 one-click Build, then the manual builder steps | Build, propose, test, qualify, admit (running steps Platform Admin) |
| Course sources | `sources` | 3 | Each university's course sources and what the finder found, 50 a page | Find again, stop, add, approve |
| Flags | `flags` | 3 | Raised flags with evidence and the toolset used before | Raise, release |
| Scholarships | `scholarships` | 4 | Finding and reading scholarships by country; Settings and jobs | Countries, settings, jobs, skip rules, publishing controls |

- **Operations** (`Layer23Operations.jsx` and, since v2.15.456, `Progress.jsx`):
  - The layer notices strip (shown on this tab only).
  - Each stage of finding, building, admitting and enriching: universities working, waiting and stopped for a person (each opens Layer 4 › Inbox on that kind), and the scheduled jobs behind it with pause, resume and run now; onboarding switch and pace (Platform Admin, reason).
  - **Governed actions** (Platform Admin, Decision 268): preview against the live system (preconditions, rolled-back dry run, action hash and expiry), then Approve and run once with a reason; result, post-checks, audit event and history.
  - **Progress** (moved here from Coverage in v2.15.456; `?view=` overview or journeys):
    - **Lane funnels (v2.15.494, read: Curator 3 and above; `LaneFunnels.jsx`, below Operations):** one row per automated lane (intake dates, fees, English, course and provider descriptions, AER, scholarships, discovery): state, jobs on, last attempt and result, stage transfer and published data in the last 24 hours (kept apart from the job result), waiting for a person, oldest waiting, credits. Open a lane for its stage table (now, oldest waiting, last 24 hours, counted-at; a stage not counted shows unknown, never 0), hold and failure reasons, jobs with pause, resume and run now (the job's catalogue rank, with a reason), switches and settings with range and unit, and issue references. Counts refresh every `lane_funnel.refresh_minutes` by job `lane-funnel` (records only, spends nothing).
    - **Overview:** group picker (all universities, pilot, top 50 Australia); tiles; Needs attention (stopped universities by reason, each opening Journeys; Firecrawl and OpenRouter notices); the journey stages and Done; every hour of the last 24 (snapshots kept 90 days). Firecrawl and AI today is on Services & limits.
    - **Journeys:** filter panel (group, country, stage, held up by, only held up, find); one row per university with its stage pills, fields filled, scholarship journey, held up by and Next step; a selected university shows its steps and its run-on-demand actions (find scholarships, read course pages again, Qualify adapter (rank ≥4), read scholarship pages again, search again, retry onboarding (Platform Admin, reason)).
- **Universities** (`AdaptersWorkspace.jsx`, merged; `BuildAdapter.jsx`):
  - The list reads one page at a time (page size setting `layer23.universities_page_size`); filters, name search and order apply on the server; **Show more**; "N shown of M"; **Tick every row shown** (up to `layer23.universities_tick_max`). A `?provider=` link opens that university.
  - Bulk actions: Qualify, Admit, switch on/off, read cycle, read again. Open row: coverage tiles; switch, Qualify and Admit; build and test; read schedule, central pages, fee range and rules, hosted courses, Firecrawl target; history; courses.
  - **Build** row action (v2.15.456; hidden at phone width): opens a **Build adapter** panel at the top for that university (`?build=<university>`): its eight fields as Ready, Review or Not ready, what each would add, and Admit for the Ready fields (Platform Admin, reason). Close returns to the list.
  - **"Build adapter: every university and the waves"** fold: the full Build adapter list (tick universities to build, name a wave) and the waves, open to Curators and Operators here.
- **Enrich fields** (changed in v2.15.456; `FieldCoverage.jsx` run part, `EnrichFields.jsx`, `FeeReader.jsx`):
  - **Stalled fields** (moved from Coverage › Attributes): Fill now, and Release holds and fill (with a reason). A link from Attributes highlights the chosen field.
  - **Fill the gaps** (the standing queue, moved from Attributes).
  - **Enrich fields task:** choose countries or universities and fields, Preview (what is missing, what stored pages can fill, estimated AI and scraper spend, items another task holds), Start; tasks with their items; Retry failed items; export as CSV; field sources per country (Platform Admin, reason).
  - **Provider descriptions** (moved from Attributes).
  - **Fee reader** (AI fee reader).
- **Enrichment plan** (`EnrichPlan.jsx`): plans needing a person first; each university's steps (website, contacts and central pages, course pages, adapter, admit, missing fields, scholarships) with why, fields and estimate; Run now from the on-demand allowance (Pipeline Operator); Cancel (also cancels its tasks); retry failed steps; export.
- **Adapter builder** (`AdapterBuilderTab.jsx`; running steps Platform Admin):
  0. **Step 0: one-click Build** (v2.15.456; a fold, open unless a university is chosen): readiness by field for every university, the waves, and Admit for the Ready fields (Decision 267).
  1. Provider: website, contacts, central pages and approvals.
  2. Course pages: find with Firecrawl, add by hand, capture samples.
  3. Model proposes the adapter; save in testing and apply; qualify; admit.
  4. Adjust by hand (editor; validate and admit).
- **Course sources** (`CourseSources.jsx`; changed in v2.15.454): metrics (every university); countries the finder works on and the list addresses it tries; the university table **50 a page** with a pager (a search or a country chip goes back to the first page); each university's sources and why; find again, stop, add, approve.
- **Flags** (`FlagsPanel.jsx`): raised flags on providers, course fields or jobs, with why and the tools used before; raise and release (the item goes back into its queue).
- **Scholarships** (changed in v2.15.456):
  - **Finding scholarships:** countries switched on and the sources for each.
  - **Reading scholarships:** discovery and reading by country, refusals, the jobs and their limits.
  - **Settings and jobs** fold (moved from Scholarships › Coverage): skip rules and the publishing (Layer 4) jobs and settings; switch a job on or off and change how many it handles per run (Platform Admin).
- **Build adapter retired as a tab (v2.15.456):** its old address opens Universities (`?tab=build&provider=X` opens the Build panel for X).

### 3.4 Layer 4 Review — `layer4` (1 tab)

| Tab | Key | Min | What it shows | What it does |
|---|---|---|---|---|
| Inbox | `inbox` | 3 | Everything that needs a person, grouped by university; Decided | Each item's choices, with a reason |

- **Inbox** (`Layer4Inbox.jsx`): items by university, each saying why it is here and what each choice does; filters by kind (`?kind=`) and university (`?provider=`); counsellor reports (Fixed, Not changed); provider and course descriptions (approve as read or reject; the Course description pill shows review capacity and a review pack ordered by university with objective flags, v2.15.494); AER items (Platform Admin approves, rejects or approves except ticked rows, one at a time); Decided lists decisions taken (who, when, choice, reason).
- **Review readiness line** (v2.15.456, moved from Coverage › Attributes): one header line, "Entry-requirement review readiness", with the count in each readiness class. It is drawn after the Inbox loads and stays silent if its read fails, so it never holds the Inbox up. Decisions stay one item at a time.
- Operated from a phone (guarded by `s121`).

## 4. Operations

### 4.1 Platform health — `health` (4 tabs)

| Tab | Key | Min | What it shows | What it does |
|---|---|---|---|---|
| Health checks | `checks` | 3 | Overall status, open issues by area, the checks, 14-day chart; Screen use (rank 6) | Links to where each issue is fixed |
| Queues & yield | `queues` | 3 | Pipeline yield (rank ≥5) above the work-queue watchdog | Run the watchdog, read its report |
| Integration queue | `integration` | 5 | The integration defect register and the operating mode | Read only |
| Storage & retention | `storage` | 6 | Storage categories with rule, size, would go | Preview, purge, stop, audit |

- **Health checks** (changed in v2.15.452): no Layer 3 block. The queue check of Layer 2 run items and the Layer 4 review backlog shows as "Layer 2 and 4 queues", without its two Layer 3 sub-checks. Database size links to the Go-live checklist (where Capacity is). **Screen use** (Platform Admin): every page and tab with how often people opened it, those not opened first, with the retirement checks.
- **Queues & yield** (new in v2.15.455; same key as the old Work queues, so old addresses still open it):
  - **Pipeline yield** (PIM Admin and above, as before; moved from Integration queue): each lane stage by stage, plan outcomes, the field backlog and its forecast.
  - **Work queues** (`QueueWatch.jsx`): each enrichment queue's state every 15 minutes (Stuck and Out of toolset alert the Platform Admin), self-retries logged.
- **Integration queue** (`IntegrationQueue.jsx`): failures found by the checks, grouped by fingerprint, with owner, fix, deployment and verification, and the operating mode. Read only. Pipeline yield left this tab in v2.15.455.
- **Storage & retention** (`RetentionScreen.jsx`): categories; preview, purge (reason and typed key), stop, run audit; runs.

### 4.2 Scheduled jobs — `jobs` (3 tabs)

| Tab | Key | Min | What it shows | What it does |
|---|---|---|---|---|
| Automations | `automations` | 4 | Every scheduled job by area; Refresh schedules and one-off runs | Pause, resume, run now, frequency, batch size (rank ≥5) |
| Jobs | `jobs` | 4 | Job history | Filters, detail, admit passing fields of a task result |
| Task manager | `tasks` | 4 | Long-running admin tasks | Pause, resume, cancel with a reason |

- **Automations** (`Automations.jsx`):
  - **Areas start closed** (v2.15.454). Each closed header shows how many automations, how many paused and how many failed in 24 hours; open an area to see its rows (how often, last run, last 24 h, state, change). A search, or the Paused or Failed in 24h filter, opens the areas that match.
  - The "Layer 3 AI" area is gone (v2.15.452). Its three live jobs are under Course pages (Prepare AI course page matching, AI course page matching) and Admission (Settle fee periods), unchanged.
  - Then **Refresh schedules and one-off runs** (`m2-3-intelligence-entry.jsx` Refresh): schedule policies (edit, run on demand for Layer 1 registers only), refresh queue, runtime health. It stays because its Edit schedule is the only working control of the Layer 1 register cadence (open decision, section 8).
- **Jobs** (`pipeline-ops-entry.jsx`): job history with 8 filters; expandable detail (register run batches; admin task result with Admit the passing fields; generic run detail with evidence and hashes).
- **Task manager** (`AdminTasks.jsx`): tasks running or waiting (pause, resume, cancel with reason); task detail; the running-jobs board (old Running now and Live activity addresses open it).

### 4.3 Evidence — `evidence`, rank 3 (`EvidenceWorkspace.jsx`)
- Search; 17 filters (including UUID and hash).
- Table: artifact, source, layer, type, captured, extraction, freshness, status, job, integrity.
- Drawer: preview or download (signed link, 60 s), lineage, hash, observations, affected records, claims and reviews, storage controls.

## 5. Platform settings

### 5.1 Settings — `environment` (3 tabs)

| Tab | Key | Min | What it shows | What it does |
|---|---|---|---|---|
| Settings | `settings` | 6 | Every pipeline setting by step; outside-service keys | Change a value with a reason; set or rotate keys |
| API usage | `api` | 4 | Calls to the consumer API version URLs by key and action | Refresh now; rotate, switch or end keys (rank 6) |
| Backup & restore | `backup` | 6 | Daily backups of the Published switch and setting values | Compare, download as SQL, restore all or part |

- **Settings** (`PipelineSettings.jsx`, `SettingsRegister.jsx`, `EnvironmentMigrationWorkspace` integrations):
  - Pipeline numbers by step (find, identify, budgets); recent changes.
  - Settings register: controls check banner; cards (job sizes, re-read and retry, onboarding); each setting with value, unit, range, what uses it, last change and reason; Save needs an inline reason. Policy cards (capacity thresholds, evidence storage thresholds, retention rules, provider fee profiles and basis rules).
  - External services and stored key names: only the services in use are listed (Firecrawl and direct reads; dropped providers left the list in v2.15.452). Address, limits and routing link to Models & services › Services & limits.
  - Keys: page services, Apollo, OpenRouter profile, production automation, consumer API tokens (Zoho, website).
- **API usage** (`ApiUsagePanel.jsx`): statistics from the daily roll-up (or Refresh now): calls, success and failure, last sign-in, full and delta syncs, bandwidth, load size; key rotation, switch off/on, end an old key early (Platform Admin; a new key is shown once).
- **Backup & restore** (`SettingsBackup.jsx`): daily at 6:50 am Melbourne, by hand and before every restore; pick a backup to see what differs and who changed it last; download as SQL; restore all, providers, settings or ticked rows.

### 5.2 Models & services — `services` (2 tabs)

| Tab | Key | Min | What it shows | What it does |
|---|---|---|---|---|
| Services & limits | `services` | 4 | One card per outside service: Firecrawl, Direct read, OpenRouter, Database jobs and edge calls, Notices; Other page services | Switches, limits, budgets, fetcher settings (changes Platform Admin, reason) |
| AI & OpenRouter | `ai` | 3 | The AI configuration and AI model switches (rank ≥4); Scholarship extraction | Model order, qualify, make active, guards, key |

- **Services & limits** (new in v2.15.455; Services, Toolsets & limits and Fetchers in one tab, one card per service, `ServicesLimits` in `mature-main.jsx`):
  - **Firecrawl allowance and spend (v2.15.494, first card, read only, Curator 3 and above; `FirecrawlAcceptance.jsx`):** plan allowance, platform limit and stop-at; live remaining credits with age and a flag when the vendor shows more than the plan; last sync of job `firecrawl-credit` and next run; the reserved floor and room above it; daily share used and left per group with the last 7 Melbourne days; usage by group and purpose. Credits only. Limits change only in the card below.
  - **Firecrawl:** switch; monthly cap and reserve (toolset card: mode Observe only or Stop at limits, key and plan, daily budget settings: on/off, credits a day, share per purpose, search stop, scholarship cap per university, central pages refresh); the course-page search budget (this month's credits and the monthly cap); **Firecrawl and AI today** (moved from Coverage › Progress in v2.15.456: used, share and refused per purpose, AI spend against each guard, OpenRouter balance); Firecrawl credits by university (with Refused today, by university, and Search again); the fetcher settings (address, credential, concurrency, rate, time-out, capabilities).
  - **Direct read:** switch, and its fetcher settings (rate, calls at once, time limit).
  - **OpenRouter:** balance, spend today against each daily guard, credit floor and mode, spend by day. Models and the key are on AI & OpenRouter.
  - **Database jobs and edge calls:** scheduled jobs, edge function calls, and the pipeline job sizes, re-reads and retries.
  - **Notices:** every toolset notice on every layer and what each one asks (information-only notices live here).
  - **Other page services** fold: anything else still registered (for example a custom gateway kept switched off), read when opened.
  - Retired in v2.15.452: the Serper, ScrapingBee, Search pass and Sample runs cards, and the dropped fetchers (ScraperAPI, Scrape.do, ZenRows). Their records stay.
- **AI & OpenRouter** (changed in v2.15.455):
  - AI configuration (`AiConfig.jsx`, rank ≥4): OpenRouter account (balance, floor, warning, mode, credit floor edit, key set and verify — Platform Admin); AI uses (model, calls and spend today, daily guard, state; central pages model and switch; adapter proposal model); scholarship AI models (order, qualify, make active); model profiles and prompts; recent AI changes.
  - **AI model switches** (rank ≥4; moved from Services): each model on or off (only after it passed its test; off also switches off its cascade steps), 7-day calls and cost, retired models.
  - **Scholarship extraction** (every role that opens the tab; changes Platform Admin): cost today, model order, models waiting to be qualified or added, instructions, page answers. Curators see this section only.

### 5.3 Go-live checklist — `migration`, rank 6
- Production environment values; Supabase Production migration manifest (status per component).
- Gates: Layer 1 source capabilities and the Layer 2 acquisition providers in use. The Layer 3 model profiles gate and the dropped providers' gates retired in v2.15.452.
- Capacity (was Platform health › Capacity): production boundary, capacity tiles, evidence lineage, backup/PITR, largest relations, workload profiles, retention policy (dry run).
- UAT and accepted domains.

## 6. Administration and guides

### 6.1 Users & roles — `users`, rank 6 (`access-roles-entry.jsx`)
- Role help; tiles; user directory (auth state, roles, effective role, last sign-in); roles with expiry; disable; create user; recent access changes.

### 6.2 Guides — `guide` (3 tabs)

| Tab | Key | Min | What it shows |
|---|---|---|---|
| Platform guide | `guide` | 1 | How it works, who does what, your role, daily routine, the screens, signal → action, admin duties, alert emails, what changed |
| Platform Admin SOP | `admin-sop` | 3 | Versioned SOP; download as Markdown |
| Operator SOP | `operator-sop` | 3 | Versioned SOP; download as Markdown |

- The guide and both SOPs were updated in each SS-020 release (v2.15.452 to v2.15.457); copies in the Pilot repo `docs/sops/`.

---

## 7. Old addresses and where they lead (LEGACY redirects, v2.15.457)

Every old menu entry, tab, alias and Administration section still opens a page, so bookmarks and guide links keep working. Read from `LEGACY`, `LEGACY_ADMIN_SECTIONS`, `MOVED_L1` and `resolveTarget` in `nav-map.js`. An address that matches nothing opens the Dashboard.

### 7.1 Old page addresses (`#<old address>`)

| Old address | Opens |
|---|---|
| `campuses` | Providers › Campuses |
| `provider-contacts` | Provider contacts |
| `completeness`, `data-quality-readiness`, `attributes`, `data-model` | Coverage & completeness › Attributes |
| `course-coverage` | Coverage & completeness › Courses |
| `live-activity`, `activity` | Scheduled jobs › Task manager |
| `compare` | Rankings & statistics › Compare |
| `outcomes-qilt` | Rankings & statistics › Datasets, View data: QILT (`data=qilt`) — SS-020 step 5 |
| `student-flow-prisms` | Rankings & statistics › Datasets, View data: PRISMS (`data=prisms`) — SS-020 step 5 |
| `layer-1-operations`, `layer-1-regulatory`, `regulatory-settings`, `layer-1-authority` | Layer 1 Register (Registers) |
| `sources`, `pipeline-sources` | Layer 1 Register, All layers (`layer=all`) |
| `api-usage` | Settings › API usage |
| `storage-retention` | Platform health › Storage & retention |
| `onboarding`, `layer-2-enrichment` | Layer 2/3 › Universities |
| `layer-2-operations` | Layer 2/3 › Operations |
| `scrapers`, `scrapers-fetchers` | Models & services › Services & limits |
| `layer-3-ai-interpretation`, `layer-3-ai`, `layer-3-ai-validation` | Layer 2/3 › Universities (an old Layer 3 `tab=models` opens Models & services) |
| `layer-4-human-resolution`, `review-queue` | Layer 4 Review › Inbox |
| `jobs-schedules` | Scheduled jobs |
| `jobs` | Scheduled jobs › Jobs |
| `scheduled-tasks`, `refresh-scheduling` | Scheduled jobs › Automations |
| `important-dates` | Reference data, Key dates (`type=dates`) |
| `important-links` | Reference data, Reference sources (`type=links`) |
| `settings` | Go-live checklist |
| `statistics-rankings` | Rankings & statistics |
| `administration` | Models & services › Services & limits |

Old page names written as words (for example "Layer 4 — Human Resolution" or "Statistics & Rankings") are turned into addresses the same way and follow this table; a current page label or slug opens that page.

### 7.2 Old Administration sections (`#administration?section=…`)

| Section | Opens |
|---|---|
| `overview`, `layer2-providers` | Models & services › Services & limits |
| `sources-imports`, `statistics-datasets` | Rankings & statistics › Datasets |
| `layer1-sources` | Layer 1 Register |
| `provider-assets` | Providers › Logos & assets |
| `layer2-sources`, `onboarding` | Layer 2/3 › Universities |
| `pim` | Coverage & completeness › Attributes |
| `users-roles` | Users & roles |
| `environment-migration` | Settings |
| `platform` | Go-live checklist |

### 7.3 Old tabs on current pages (`#<page>?tab=<old tab>`)

| Old tab | Opens | Since |
|---|---|---|
| Coverage › `progress` | Layer 2/3 › Operations (keeps `view=overview` or `journeys`) | v2.15.456 (SS-020 step 4) |
| Coverage › `progress&view=running` | Scheduled jobs › Task manager | v2.15.301 |
| Coverage › `progress&view=levers` | Settings › Settings | v2.15.301 |
| Layer 2/3 › `build` | Layer 2/3 › Universities; `provider=X` opens the Build panel for X (`build=X`) | v2.15.456 (SS-020 step 4) |
| Models & services › `limits`, `fetchers` | Models & services › Services & limits | v2.15.455 (SS-020 step 3) |
| Platform health › `integration&view=yield` | Platform health › Queues & yield | v2.15.455 (SS-020 step 3) |
| Platform health › `queues` (Work queues) | Platform health › Queues & yield (same key) | v2.15.455 (SS-020 step 3) |
| Rankings › `qilt`, `prisms` | Rankings & statistics › Datasets with `data=qilt` or `data=prisms` | v2.15.457 (SS-020 step 5) |
| Platform health › `readiness` | Go-live checklist | v2.15.301 |
| Scholarships › `extraction` | Models & services › AI & OpenRouter | v2.15.301 |
| Scholarships › `publishing` | Scholarships › Coverage | v2.15.253 |
| Scholarships › `links` | Scholarships › Scholarships | v2.15.174 |
| Coverage › `flags` | Layer 2/3 › Flags | v2.15.301 |
| Coverage › `domains` | Coverage › Attributes | v2.15.124 |
| Coverage › `universities` | Layer 2/3 › Universities | v2.15.200 |
| Coverage › `reports` | Layer 4 › Inbox, kind Counsellor report | v2.15.300 |
| Layer 1 › `imports` | Rankings & statistics › Datasets | v2.15.301 |
| Layer 1 › `dates`, `links` | Reference data, Key dates or Reference sources | v2.15.301 |
| Layer 1 › `onboarding` | Layer 2/3 › Universities | v2.15.301 |
| Layer 1 › `scholarships` | Layer 2/3 › Scholarships | v2.15.301 |
| Layer 1 › any other tab | Layer 1 Register | v2.15.301 |
| Reference data › `imports` | Rankings & statistics › Datasets | v2.15.301 |
| Reference data › `dates`, `links` | Reference data with that type | v2.15.301 |
| Layer 2/3 › `start`, `history`, `profiles`, `adapters`, `onboarding` | Layer 2/3 › Universities | v2.15.200, v2.15.300 |
| Scheduled jobs › `schedules` | Scheduled jobs › Automations | v2.15.124 |
| Scheduled jobs › `priority` | Layer 2/3 › Universities | v2.15.300 |
| Layer 4 › `review`, `sendback`, `flags`, `rules`, `blocks` | Layer 4 › Inbox, kind Course link | v2.15.252–v2.15.300 |
| Layer 4 › `aireview` | Layer 4 › Inbox, kind Held scholarship | v2.15.300 |
| Layer 4 › `websites` | Layer 4 › Inbox, kind Website needed | v2.15.300 |
| Layer 4 › `attributes` | Layer 4 › Inbox, kind Central page to approve | v2.15.300 |
| Layer 4 › `publishing` | Scholarships › Coverage | v2.15.253 |
| Providers › `onboarding` | Layer 2/3 › Universities | v2.15.258 |

## 8. Open decisions (SS-020 items parked, from the execution register)

These are left as they are until the Platform Admin decides. They are recorded as **DECISION REQUIRED — SS-020** in `STUDYSEARCH-EXECUTION-REGISTER.md`.

| Item | Where it is now | Why it is parked | Options |
|---|---|---|---|
| Link refresh and portals | Coverage & completeness › Courses | Decision 269 (C20, C42) moves it to Settings › Settings, but that tab is Platform Admin only, while Pipeline Operators and above change link refresh today. Moving it would take it away from ranks 4 and 5 | (a) Settings › Settings; (b) a rank 4 home under Settings; (c) leave it on Coverage › Courses |
| Refresh schedules and one-off runs (Layer 1 refresh cadence) | Scheduled jobs › Automations | Decision 269 (C38) retires the section, but its Edit schedule is the only working control of how often the Layer 1 registers run. The schedule on Layer 1 › Sources writes a value no job reads | Make Layer 1 › Sources' schedule edit the Layer 1 refresh policies, then retire the section; until then it stays |
| Page count | — | Decision 269 and the mandate say 47 tabs on 22 pages; the review's own final table and the menu have 20 pages. Treated as a counting error | Confirm 47 tabs on 20 pages |
| Rankings › Datasets minimum role | Rankings & statistics › Datasets, rank 1 | QILT and PRISMS data were open to every role, so the tab now opens at rank 1; the dataset register and imports stay rank 4 inside it | Confirmation requested |

## 9. Drop-down options by country (checked live 14 Oct 2026, v2.15.270)

Kept as checked on 14 Oct; some screens named here have since moved (Progress is on Layer 2/3 › Operations, Priority queue and Websites to find retired, Data Quality is Coverage › Attributes).

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
| 1.18 | 8 Nov 2026 | v2.15.494: Lane funnels panel on Layer 2/3 › Operations; Firecrawl allowance and spend card on Models & services › Services & limits (Firecrawl); Layer 4 Inbox Course description pill: review capacity and review pack; Settings › Pipeline settings: section Lane funnels (10 settings). Backend-only changes rolled into the note (intake year change, fee plausibility guard, provider description retry, English gap funnel, scholarship coverage states) have no screen. |
| 1.17 | 4 Nov 2026 | v2.15.452, v2.15.454–v2.15.457: SS-020 admin menu consolidation (Decision 269), 47 tabs on 20 pages. Every page rewritten against the released code with each tab's key, minimum rank, what it shows and what it does; retired sections removed (Layer 3 areas and blocks, Serper, ScrapingBee, Search pass, Sample runs, dropped fetchers and gates, Courses with each field); Automations areas start closed; paging on Course sources, Course-level reading and Key dates; Queues & yield; Services & limits with one card per service; AI model switches on AI & OpenRouter; Progress on Layer 2/3 › Operations; Build adapter on Universities and as step 0 of the Adapter builder; Attributes read only, run controls on Enrich fields; scholarship settings on Layer 2/3 › Scholarships; Inbox readiness line; QILT and PRISMS as View data on Rankings › Datasets. New section 7 (every old address and where it leads) and section 8 (parked SS-020 decisions). Screens retired before SS-020 that were still listed (Live activity, Priority queue, the old Layer 4 tabs, Scrapers & fetchers, Data model, the separate Sources page) removed. Drop-down section renumbered 9. |
| 1.16 | 30 Oct 2026 | v2.15.373: snapshot stamp on cached screens (W34/W35). |
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
