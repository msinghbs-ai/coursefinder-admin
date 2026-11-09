# Admin menu review: which tabs fit the current mechanism, and which to merge or retire

**Date:** 3 November 2026, 20:33 to 22:00 AEDT
**Asked by:** Platform Admin, 3 Nov 2026 20:33: "review the repo again, i want your recommendation based on current mechanism which tab is aligned with current design and which can be retired ... create a current mockup and final mockup"
**Status:** RECOMMENDATION. Nothing has been changed in Pilot. Each merge or retirement needs the Platform Admin's decision first (standing rule: ask before merging views; list their actions first).
**Mock-ups:** Design canvas "StudySearch Admin Menu Review" (https://claude.ai/artifact/8hxx9qgcFkxNkXSsVJJyGw): Current menu (C-01 to C-53), Final menu (F-01 to F-47), every tab at a glance.

## 1. What was read

| Source | Detail |
|---|---|
| Pilot code | `main` at `793f642`, v2.15.439: `src/nav-map.js`, page routing in `src/mature-main.jsx`, header comments of every screen component |
| Admin docs | `docs/README.md`; `docs/platform/UI-SIMPLIFICATION-REVIEW.md` (v1.0, proposed); `ui-audit/2026-10-24-admin-ui-audit.md` and `2026-10-24-ui-cleanup-mandate.md`; `nz-enrichment-brief/2026-11-01-role-guides-usability-operability-review.md` (UR-01 to UR-17, especially UR-09 and UR-12); `nz-enrichment-brief/2026-11-03-enrichment-controls-audit.md`; `STUDYSEARCH-EXECUTION-REGISTER.md` |
| Live admin | Signed in as Platform Admin in the browser pane; every one of the 53 tabs opened once (3 Nov, about 21:00 to 21:30 AEDT); section headings, button and input counts and page height recorded |
| Screen use | `pipeline.admin_screen_opens` (read only), 20 Oct to 3 Nov 2026. About 89% of all opens come from the automated test account, so this review uses **opens by people only** |

Criteria (UR-12): low use alone is not a reason to retire. A tab is merged or retired only where its job is already done somewhere else (named), or the mechanism behind it was retired by an earlier decision.

## 2. The current mechanism, in one paragraph

Registers (Layer 1) feed the catalogue. University adapters (Layer 2/3, since the Layer 3 AI check retired on 12 Oct) build, admit and enrich, steered from Layer 2/3 › Operations, Universities, Enrich fields, Enrichment plan and the Adapter builder (manual mode). Anything that needs a person goes to the one Layer 4 Inbox. Task manager shows what runs now; Jobs keeps history; Automations holds the schedules. Platform health, Work queues and the Integration queue (2 Nov) watch the platform. Firecrawl is the only page service (4 Oct); OpenRouter is the AI aggregator. The catalogue is for validation, not drill-down (4 Oct). From 3 Nov, enrichment must run from operator UI controls and the scheduler, not by hand.

## 3. Verdict for every tab

Opens = screen opens by people since 20 Oct. Height = live page height in pixels on 3 Nov.

| ID | Page › Tab | Opens | Height | Verdict | Why | Recommendation |
|---|---|---|---|---|---|---|
| C01 | Dashboard | 93 | 1,465 | Keep | Summary-first start page | — |
| C02 | Courses | 108 | 3,753 | Keep | Core validation list, used on phone | — |
| C03 | Providers › Providers | 81 | 4,397 | Keep | Published switch, list editing | — |
| C04 | Providers › Campuses | 10 | 2,708 | Keep | Unique data | — |
| C05 | Providers › Logos & assets | 4 | 3,677 | Keep | Reviewed and kept on 18 Oct; logos feed the website API | — |
| C06 | Providers › Archived | 4 | 1,428 | Keep | Recovery path for archiving | — |
| C07 | Provider contacts | 9 | 2,577 | Keep | Decision 30 Sep: stays under Catalogue | — |
| C08 | Scholarships › Scholarships | 19 | 3,525 | Keep | Published only (4 Oct) | — |
| C09 | Scholarships › Coverage | 3 | 2,008 | Fix | Its "Settings and jobs" fold repeats Layer 2/3 › Scholarships | Move the fold to Layer 2/3 › Scholarships |
| C10 | Entry requirements › Provider entry matrix | 23 | 4,839 | Keep | New AER module (W1, 29 Oct) | — |
| C11 | Entry requirements › Course entry requirements | 13 | 48,882 | Fix | Renders about 49,000 px | Page on the server (100 rows) |
| C12 | Entry requirements › Sources, reads and holds | 12 | 4,675 | Keep | Unique to AER | — |
| C13 | Entry requirements › Resolution inspection | 4 | 1,473 | Keep | Audit view behind each AER value | Review after AER acceptance |
| C14 | Rankings › Overview | 18 | 1,677 | Keep | Entry point | — |
| C15 | Rankings › Compare | 12 | 1,085 | Keep | Used by three people | — |
| C16 | Rankings › Outcomes (QILT) | 6 | 2,589 | Merge | Raw table of a dataset that already has a Datasets row | Datasets › View data |
| C17 | Rankings › Student flow (PRISMS) | 2 | 2,415 | Merge | Same as QILT | Datasets › View data |
| C18 | Rankings › Datasets | 4 | 4,783 | Keep | One home per dataset and its editions | Gains QILT and PRISMS views |
| C19 | Reference data | 12 | 17,982 | Fix | 150 buttons, every row expanded | Page; edit in a drawer |
| C20 | Coverage › Courses | 22 | 4,138 | Fix | Link refresh is a setting, not a measure | Link refresh and portals → Settings |
| C21 | Coverage › Attributes | 17 | 10,239 | Fix | 500 buttons; has become a second enrichment run panel | Keep measures; run controls → Enrich fields; review readiness → Inbox header |
| C22 | Coverage › Progress | 19 | 4,371 | Merge | Overlaps Layer 2/3 › Operations and Pipeline yield; one user | Journeys and hourly history → Operations; Firecrawl and AI today → Services & limits |
| C23 | Layer 1 Register › Sources | 12 | 11,576 | Fix | One Sources list works as decided; rows render expanded | Collapse rows; page All layers |
| C24 | Layer 2/3 › Operations | 28 | 4,062 | Fix | The right control screen; a header strip (about 104 inputs) repeats on all nine Layer 2/3 tabs | Header strip on Operations only; takes in Progress |
| C25 | Layer 2/3 › Flags | 5 | 8,246 | Keep | Decision 261 flag unit | — |
| C26 | Layer 2/3 › Universities | 8 | 16,484 | Keep | One row per university | Gains one-click Build per row |
| C27 | Layer 2/3 › Course sources | 1 | 74,424 | Fix | Unique source-finder control; 1,991 buttons | Page (50 universities); show focus rule (controls audit item 6) |
| C28 | Layer 2/3 › Enrichment plan | 2 | 1,794 | Fix | Automatic plans fell to 2 a day; Cancel leaves child tasks; manual run never used | Controls audit items 4 and 8 |
| C29 | Layer 2/3 › Build adapter | 3 | 5,378 | Merge | Last opened 23 Oct; Universities row and Adapter builder do the same job | Builder step 0 and a Universities row action |
| C30 | Layer 2/3 › Adapter builder | 18 | 1,778 | Keep | Manual mode (22 Oct) | Gains one-click Build |
| C31 | Layer 2/3 › Enrich fields | 7 | 1,939 | Fix | The working manual control (281 tasks in 14 days) | Add spend estimate, dedupe, retry, export (audit items 7, 9, 10); take Coverage run controls |
| C32 | Layer 2/3 › Scholarships | 3 | 2,395 | Keep | Scholarship set-up home | Gains the Coverage settings fold |
| C33 | Layer 4 Review › Inbox | 120 | 19,739 | Fix | Most-used working screen; hit a database time-out during this review | Faster load; page each group |
| C34 | Platform health › Health checks | 36 | 10,887 | Fix | Still shows a Layer 3 block; links Capacity to a moved tab | Remove block; link Go-live checklist |
| C35 | Platform health › Work queues | 2 | 19,060 | Merge | Same question as Pipeline yield | New tab "Queues & yield" |
| C36 | Platform health › Integration queue | 0 | 6,981 | Keep | Defect register (2 Nov); assurance-critical | Pipeline yield → Queues & yield |
| C37 | Platform health › Storage & retention | 7 | 4,770 | Keep | 2 GB database goal | — |
| C38 | Scheduled jobs › Automations | 41 | 40,811 | Fix | 486 buttons; "Layer 3 AI" area; the refresh-schedules section is the old M2.3 model and nothing processes its Layer 2 requests (controls audit item 3) | Retire refresh schedules and the Layer 3 area; collapse areas |
| C39 | Scheduled jobs › Jobs | 25 | 3,930 | Keep | History (6 Oct decision) | — |
| C40 | Scheduled jobs › Task manager | 40 | 5,799 | Keep | 6 and 11 Oct decisions | — |
| C41 | Evidence | 29 | 4,848 | Keep | Evidence-first rule | — |
| C42 | Settings › Settings | 18 | 8,247 | Keep | Gains Link refresh | — |
| C43 | Settings › API usage | 6 | 15,270 | Keep | Consumer API control | — |
| C44 | Settings › Backup & restore | 8 | 410 | Keep | Recovery | — |
| C45 | Models & services › Services | 9 | 793 | Merge | Switches only; limits and set-up for the same services sit on two other tabs | New tab "Services & limits" |
| C46 | Models & services › AI & OpenRouter | 4 | 11,781 | Keep | AI configuration home | Gains AI model switches |
| C47 | Models & services › Toolsets & limits | 6 | 1,718 | Merge | Serper, ScrapingBee and Search pass still shown after Firecrawl-only (4 Oct) | Services & limits; retire those three cards |
| C48 | Models & services › Fetchers | 3 | 1,990 | Merge | ScraperAPI, Scrape.do, ZenRows and Parsebot dropped for go-live (29 Sep) | Services & limits; retire dropped fetchers |
| C49 | Go-live checklist | 3 | 9,880 | Fix | Lists Layer 3 model profiles and dropped Layer 2 providers | Remove those gates |
| C50 | Users & roles | 9 | 4,032 | Keep | Role control | — |
| C51 | Guides › Platform guide | 20 | 12,942 | Fix | Legacy names (UR-09) | Update names with this change |
| C52 | Guides › Platform Admin SOP | 3 | 17,205 | Keep | SOP (UR-12) | — |
| C53 | Guides › Operator SOP | 3 | 13,154 | Keep | SOP (UR-12) | — |

**Totals:** 30 keep, 15 keep and fix, 8 merge, 0 whole tabs deleted outright. 10 sections retire (section 5).

## 4. Proposed final menu (47 tabs, same 22 pages)

| Section | Page | Tabs |
|---|---|---|
| Home | Dashboard | Dashboard |
| Catalogue | Courses | Courses |
| | Providers | Providers · Campuses · Logos & assets · Archived |
| | Provider contacts | Provider contacts |
| | Scholarships | Scholarships · Coverage |
| | Entry requirements | Provider entry matrix · Course entry requirements · Sources, reads and holds · Resolution inspection |
| | Rankings & statistics | Overview · Compare · Datasets (with View data for QILT and PRISMS) |
| | Reference data | Reference data |
| Data pipeline | Coverage & completeness | Courses · Attributes (measures only) |
| | Layer 1 Register | Sources |
| | Layer 2/3 Build & enrich | Operations (+ journeys, hourly) · Universities (+ Build per row) · Enrich fields (+ standing queue, stalled fields, provider descriptions) · Enrichment plan · Adapter builder (+ step 0 Build) · Course sources · Flags · Scholarships (+ settings fold) |
| | Layer 4 Review | Inbox (+ review readiness header) |
| Operations | Platform health | Health checks · **Queues & yield** (new: Work queues + Pipeline yield) · Integration queue · Storage & retention |
| | Scheduled jobs | Automations · Jobs · Task manager |
| | Evidence | Evidence |
| Platform settings | Settings | Settings (+ Link refresh) · API usage · Backup & restore |
| | Models & services | **Services & limits** (new: Services + Toolsets & limits + Fetchers) · AI & OpenRouter (+ model switches) |
| | Go-live checklist | Go-live checklist |
| Administration | Users & roles | Users & roles |
| Guides | Guides | Platform guide · Platform Admin SOP · Operator SOP |

Old addresses of merged tabs redirect to their new home (`LEGACY` in `nav-map.js`), as for earlier retirements.

## 5. Sections to retire

| Section | Where | Why |
|---|---|---|
| Refresh schedules and one-off runs | Scheduled jobs › Automations (`ScheduledJobsWorkspace.jsx`) | Old M2.3 refresh model; no function processes Layer 2 requests (206 queued since September); Layer 1 registers run from Layer 1 › Sources |
| Layer 3 AI area | Scheduled jobs › Automations | Layer 3 retired 12 Oct |
| Layer 3 block | Platform health › Health checks | Layer 3 retired 12 Oct |
| Serper card | Models & services › Toolsets & limits | Firecrawl only (4 Oct) |
| ScrapingBee card | Models & services › Toolsets & limits | Firecrawl only (4 Oct) |
| Search pass | Models & services › Toolsets & limits | Serper-based; Firecrawl only (4 Oct) |
| Dropped acquisition providers | Models & services › Fetchers | Dropped for go-live (29 Sep) |
| Layer 3 model profiles gate | Go-live checklist | Layer 3 retired |
| Dropped Layer 2 providers gate | Go-live checklist | Dropped for go-live (29 Sep) |
| "Courses with each field" | Coverage › Progress | Duplicates Coverage › Attributes |

Each retirement also retires its scripts, jobs and tables in the same change, with data kept 14 days (housekeeping standard, 15 Oct), and updates the component register.

## 6. Defects seen during the review (not menu decisions)

1. Layer 4 › Inbox: "The database took too long to answer" on load (about 21:10 AEDT). The banner then stayed on later screens.
2. Every Layer 2/3 tab repeats the same header strip (about 104 inputs and three "Show the … universities" folds).
3. Platform health links Capacity to `#platform-health?tab=readiness`, which moved to the Go-live checklist on 20 Oct.

## 7. Suggested build order (once decided)

1. Retire the dead sections (section 5): no screen loses a working control.
2. Paging fixes for the five longest screens (C27, C11, C38, C33, C19).
3. Services & limits, and Queues & yield (two new tabs from merges).
4. Layer 2/3 consolidation (Progress, Build adapter, Coverage run controls, scholarship settings).
5. QILT and PRISMS into Datasets; Link refresh into Settings.
6. Guide, SOP and component register updates in the same releases.

One release per step, each with a version-pill entry; no consumer API change.
