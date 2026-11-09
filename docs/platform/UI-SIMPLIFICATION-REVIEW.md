# StudySearch Admin – UI simplification review and proposed menu

**Version:** 1.0 (12 Oct 2026, platform release v2.15.260) — **PROPOSED, nothing changed yet**
**Change control:** CF-247
**Asked by:** Platform Admin, 12 Oct 2026 20:47: "Document all UI design, functionality and features in the repo and give your opinion on how to properly organise it in the nav menu and categories. I want to simplify and question every line of data that is overcomplicated and not required for operations and maintenance of the platform and external toolset."
**Basis:** `UI-CATALOGUE.md` v1.0 (read from the code). Each item below cites where it is.

---

## 1. Opinion in brief

The admin has grown by adding a panel each time a need came up. It now has 30 screens across 7 menu sections, and the same job can often be done in 2 to 4 places:
- admit an adapter (3 places)
- approve central pages (2)
- enter a website (2)
- pause or run a job (3)
- read job history (4)
- set the Firecrawl limit (4)
- enter service keys (3)

About a third of what is on screen is developer-level detail, or is left over from retired features (Layer 3, the old Layer 4 tabs). Examples of the developer-level detail: ids, hashes, raw JSON, cron strings, worker versions and model codes.

What day-to-day operation and maintenance actually needs is much smaller. Five things:
1. What needs a person today.
2. Onboarding and admission progress.
3. The review queues.
4. Health, jobs and costs of the outside services (Firecrawl, OpenRouter, Serper, ScrapingBee, Wix and Zoho).
5. Settings and keys in one place.

Recommendation: three principles, a smaller menu (section 3), and three delivery waves (section 5). The first wave changes no behaviour.

## 2. Principles for every line on screen

1. **One home per task.** Each job is done on one screen. Other screens link to it; they do not repeat it.
2. **Operations language on screen.** Ids, hashes, raw JSON, cron strings, worker versions, model codes, change-control references and table names are hidden. They move to a collapsed "Technical details" block, visible to the Platform Admin only, where they are genuinely needed for fault-finding. Otherwise they are removed.
3. **Nothing from retired features.** Layer 3, the AI send-back, Fee rules, Flagged values, the Layer 4 publishing tab and "Fetch an area" are removed from labels, filters, statuses, help text and code.
4. **Reasons captured the same way everywhere.** Use an inline reason box, never a browser pop-up. Today reasons are captured three different ways.
5. **A screen a role cannot use is not shown to it.** No links to pages the role cannot open, and no tabs that only explain that the role cannot act.

## 3. Proposed menu

| Section | Pages (tabs) | Changes from today |
|---|---|---|
| **Today** | Dashboard · Live activity | Dashboard becomes the single "waiting for a person" list (Live activity's list merges into it). Live activity keeps "what is running" only. |
| **Catalogue** | Courses · Providers (Providers, Campuses, Contacts, Archived) · Scholarships (List, Coverage) · Rankings & statistics (Overview, Compare, Datasets) | Provider contacts becomes a Providers tab. Logos & assets becomes a "No logo" filter on Providers. QILT and PRISMS raw tables move under Datasets as "View data". Ranking imports moves to Datasets (one dataset, one home for its editions). Scholarships › Extraction moves to Data admission. |
| **Data admission** (was Data pipeline) | Onboarding · Layer 1 Register (Sources, Scholarship countries) · Layer 2 (Adapters, Adapter builder, Scholarship discovery & AI) · Layer 4 Review (Review queue, AI could not decide, Websites to find) · Coverage | Onboarding becomes its own page, first in the section: it is the journey everything else serves. Coverage Courses and Attributes become one page. Scholarship settings and jobs appear once, under Layer 2. Extraction (model order, qualification, instructions) moves here as "Scholarship AI". |
| **Operations** | Platform health · Jobs & tasks (Automations, Tasks & history, Priority queue) · Evidence | Jobs and Task manager merge into "Tasks & history". The second scheduling screen (Refresh schedules, Runtime health, Search refresh signals) is retired or folded in, if no longer used. The read-only Sources page is retired; Layer 1 › Sources is the one source list. Capacity moves to Platform settings. |
| **Platform settings** (Platform Admin) | Services & limits · AI models · Pipeline settings · Storage & capacity · Users & roles · Go-live checklist | **Services & limits** replaces Settings keys, Scrapers & fetchers and the Toolsets part of Models & services: one card per outside service (key, on/off, plan, limits, notices, usage). **AI models** is the model switches. **Storage & capacity** merges Capacity, Storage & retention and Platform resources. Data model is retired or moved under a Technical details block. Go-live checklist is hidden until cut-over. |
| **Guides** | Platform guide · Platform Admin SOP · Operator SOP | Unchanged. |

The result is 6 sections and about 20 screens (from 7 and 30). Every task has one home.

## 4. Line-by-line questions

Recommendation key:
- **Remove:** delete it.
- **Merge:** one home; the others link to it.
- **Move:** relocate it.
- **Tech:** hide it in the Platform Admin "Technical details" block.
- **Fix:** correct it.
- **Verify:** check it is still used before removing it.

### 4.1 Left over from retired features (remove)
| Item | Where | Recommendation |
|---|---|---|
| "Layer 3 · AI checks" area | Live activity (`LiveActivity.jsx` AREAS) | Remove |
| "Sent back to Layer 3" status; the `layer3` block in Advanced JSON | Layer 4 Review queue | Remove |
| "Layer 3 items stuck over 1 hour" | Platform health details | Remove |
| "Awaiting Layer 3" / "Layer 3 · AI interpreted" badges | Course drawer (StateTrail) | Remove |
| "AI check (Layer 3)" state; "(Layer 3 or Layer 4)" hint | Coverage › Attributes | Remove |
| "OpenRouter / Layer 3" key form (profile select) | Settings | Replace with one OpenRouter key field |
| "Layer 3 model profiles" gate | Go-live checklist | Remove |
| "Bounded Layer 1–3 schedules", "Open Layer 3", "Layer 3 Evidence interpretation" | Scheduled jobs › Automations (refresh schedules) | Remove |
| Layer 3 wording in subtitles and help | Priority queue, Evidence, Users & roles help ("sends work back to the AI", "approves fee rules"), Platform guide "How it works" and the `layer2` screen text ("Fetch an area", "Overview", "History") | Fix text |
| "Searching for a page (retired)" purpose; `LAYER[3]` label; `l3v-*` CSS class names | Layer 2 › Scholarships; LayerNotices; several screens | Remove |
| "Publishing decision" in the Layer 4 fold of scholarship, course and provider drawers | Drawers | Remove (publishing is on Scholarships › Coverage and the Published switch) |
| `retired_layer2` category once purged | Storage & retention | Remove after the purge |

### 4.2 Code that never runs (remove; no visible change)
| Item | Where |
|---|---|
| `providers`/`onboarding` case (unreachable since v2.15.258) | `mature-main.jsx` pageBody |
| Stale `UI_VERSION='2.15.78'` and `UI_FIXES`. The visible version is corrected afterwards by `pim-version-entry.js`; use `release-manifest.js` directly instead | `mature-main.jsx` |
| Unused components: `InternationalContacts`, `CourseSemantics`, `OperationalList`, `DashboardSkeleton`, `Fresh`, `ActivityFeed`, `Attention`; `completenessMode` branch | `mature-main.jsx` |
| About 60% of `CourseDetailPolish.jsx`: Overview, FeesPanel, RequirementsPanel, DecisionFacts, Locations, Regulatory, Evidence (SHA), OperationalState, section reordering | Course drawer |
| About half of `layer1-operations-entry.jsx`: old cards, settings, `Details` with hashes, self-mount, about 25 KB of styles | Layer 1 |
| Second access-admin shell (sidebar "Access Admin v1.0", "Back to Admin", AccessBootstrap observer) | Users & roles |
| Ranking import URL mode; `ErrorState`, `safe_actions` (Jobs); `scopeQuery` (Layer 4); `costText` (Scrapers); `scope` state (Coverage) | various |

### 4.3 One home per task (merge)
| Task | Today | Proposed home |
|---|---|---|
| Admit an adapter's fields | Adapters (bulk and row), Adapter builder 3.4 and step 4, Onboarding (auto), Jobs detail and Task detail ("Admit the passing fields") | Adapters (bulk and row) and Onboarding (automatic). Builder links there. |
| Approve central pages | Adapter builder 1.3, Onboarding › Approvals waiting | One "Approvals" queue (Layer 4 Review tab or Onboarding); Builder 1.3 links to it |
| Enter a website | Adapter builder 1.1, Layer 4 › Websites to find | Websites to find; Builder 1.1 links to it |
| Adapter editor | Adapters row "Build and test", Builder step 4 | Builder only |
| Pause / run a job | Automations, Task manager › Running now, Live activity (read) | Automations |
| Job history | Jobs, Automations › Runtime health and Refresh queue, Task manager last 15 minutes, Live activity | Tasks & history |
| Firecrawl monthly limit and reserve | Scrapers & fetchers (editable), Settings (read-only), Models & services, credit banner | Services & limits (Firecrawl card); banner links there |
| Service keys | Settings, Scrapers & fetchers drawer, "Key saved" chips on Models & services | Services & limits |
| Fetch throughput numbers | Settings 2/3, Toolsets Read and Find pages and Runs, Scrapers rate, concurrency and timeout | Services & limits (per service) and Pipeline settings (per step), no overlap |
| Scholarship settings and jobs | Layer 1 › Scholarships, Layer 2 › Scholarships, Scholarships › Coverage fold | Layer 2 › Scholarship discovery & AI |
| Change a value on a record | Record editor "Change" and Layer 4 "Correct this value" (two histories) | Record editor only |
| Publish or hold | Published switch, Coverage, Layer 4 publishing decision, Publication filter | Published switch (providers) and Coverage (scholarships) |
| Restore archived | Archived tab and the drawers | Archived tab; drawers link |
| Sources list | Layer 1 › Sources (editable), Operations › Sources (read-only) | Layer 1 › Sources |
| Storage and capacity | Capacity, Storage & retention, Settings "Platform resources", Capacity "Retention policy" | Storage & capacity |
| Waiting for a person | Dashboard, Live activity (different sources) | Dashboard |
| Compare buttons | 4 cards and "Open Compare" | One Compare tab |

### 4.4 Developer-level data on screen (Tech block, or remove)
| Item | Where | Recommendation |
|---|---|---|
| "stable key" in search placeholders | Courses, Providers, Campuses | Remove from placeholder (search can still match) |
| "Legacy presence" column and filter | Courses | **Verify**, then remove |
| "Evidence" count column | Providers | Remove (open Evidence from the drawer) |
| Generic drawer showing database fields and object dump | Campuses | Replace with a fixed set of fields |
| Raw worker result keys ("key N") in "Last result"; raw function names | Live activity | Plain summary; names in Tech |
| Raw job codes, cron strings, worker and API call names, US$ to 4 decimals | Automations, Task manager | Tech; money to cents |
| Hashes, UUID filters, MIME, storage controls | Evidence | Tech; keep search, preview and download for operators |
| Worker versions, `apply_gate`, `identity_scheme`, trust rank | Sources | Retire the page (see 4.3) |
| Cursor and offset, failure classes, change-control and UAT references | Jobs detail | Tech |
| Schema and relation names, temp bytes, lineage counters, workload payload budgets, CF-056 | Capacity | Tech under Storage & capacity |
| Raw JSON editors (request template, capabilities, billing) | Scrapers & fetchers | Tech |
| `window.prompt` asking for "Final value (JSON)" | Layer 4 Review "Edit and approve"; Layer 4 correction fold | Replace with a typed form |
| Model codes, prompt version, cost per page to 4 decimals, editable raw system prompt | Scholarships › Extraction, AI could not decide | Model labels on screen; prompt editing in Tech |
| Reroute counts (course items sent to adapters, items sent to AI) | AI could not decide | Remove (migration housekeeping) |
| "A15 source observations", raw import batch id, "Catalogue module" | Provider contacts | Remove or rename |
| Raw search query and tried URLs | Websites to find | Keep, collapsed ("What was tried") |
| "Key name" column, "Absolute Evidence paths", "Vault secrets", "Largest tables" | Settings | Tech |
| Raw QILT/PRISMS columns picked automatically (ids, codes) | Outcomes, Student flow | Fixed, named columns |
| Version strings throughout the guide text ("v2.15.258, bug 12/10-01") | Platform guide | Keep only in "What changed" |
| Internal ids to paste ("Its ID (from the record's page)") | Key dates | Replace with a record picker |

### 4.5 Rarely needed (fold away, or open from where it is used)
| Item | Where | Recommendation |
|---|---|---|
| "How an adapter goes from built to admitting" (static help) | Adapters | Move to the Platform guide |
| "Page fees against CRICOS (dry run)" | Adapters | Fold (it changes nothing) |
| Pilot panel | Onboarding | Remove after the 48-hour pilot ends (14 Oct) |
| Qualification sample, Try a page, model instructions | Scholarships › Extraction | Fold under Scholarship AI |
| Search pass, sample runs, Firecrawl support report | Models & services | Fold under the Firecrawl and Serper cards |
| Campuses tab | Providers | Keep, simplified (campuses already show in the provider drawer) |
| Provider contacts CSV import | Contacts | Keep, Platform Admin only |
| Go-live checklist | Platform settings | Hide until cut-over |
| Data model (read-only raw tables) | Platform settings | **Verify** use; retire or Tech |
| Datasets "Shown" switch | Rankings › Datasets | **Verify** (the cards may be driven by the patch script `StatisticsDatasetEnhancer.js`); keep only if it works |
| Refresh schedules and one-off runs (second scheduling model) | Scheduled jobs › Automations | **Verify** whether any policy still runs that cron does not; retire if not |

### 4.6 Inconsistencies (fix)
| Item | Where | Fix |
|---|---|---|
| Rank 5 is "PIM Admin" in the guide but "PIM Operator" in the header and contacts | Shell, guide, contacts | One name |
| Footer "a passing check never admits by itself" while auto-admit is on | Onboarding | Fix text |
| Logos & assets opens at rank 4, but uploading needs rank 5 | Providers | Fold into the Providers filter (see 3) |
| Links to pages the role cannot open (Dashboard tiles, Live activity buttons) | Dashboard, Live activity | Check `canOpen` |
| Country lists differ (AU/NZ only; AU/NZ/CA; plus GB/US/IE) | Key dates, Logos, Contacts, Coverage "By area" | One country list |
| Priority queue opens at rank 3, the rest of Scheduled jobs at rank 4 | Scheduled jobs | Align |
| Model and service switches: "PIM Operator and above" in the code note, "Platform Admin" in the page header | Models & services | One rule |
| "Toolsets and limits" link names a card, not a page | LayerNotices | Link to the page |
| Reason capture: pop-up, inline field or automatic, depending on the screen | Adapters, Layer 1, LayerNotices, Coverage skip rules, Reference sources, Task manager | Inline everywhere |
| Six scripts outside React patch the page after it renders (`index.html`) | Shell, Rankings, Evidence, Layer 4, version pill | Move each into its React screen; remove the patch layer |

## 5. Delivery waves

| Wave | Scope | Behaviour change | Size |
|---|---|---|---|
| 1. Clean-up | 4.1 retired leftovers, 4.2 code that never runs, 4.6 text and role-name fixes, reasons inline | None (wording and dead code only) | 1 release |
| 2. One home per task | 4.3 merges; 4.4 Technical details block; 4.5 folds | Buttons move; nothing is lost | 2–3 releases |
| 3. Menu | Section 3 menu, the Services & limits page, Storage & capacity, Onboarding as its own page; old addresses redirect | Menu changes; SOPs and guide rewritten | 1–2 releases |

Each wave is tested with the full local suite, recorded in CF-247, and updates `UI-CATALOGUE.md`, the System reference, the Platform guide and the SOPs.

## 6. Decisions needed from the Platform Admin
1. Approve the proposed menu (section 3), or say which part to change.
2. Retire Operations › Sources (read-only duplicate)?
3. Retire the Refresh schedules screen, if checking shows no policy still runs that cron does not?
4. Remove the Layer 4 "Publishing decision" and "Correct this value" from the drawers, leaving one way to change a value?
5. Retire Data model (read-only raw tables)?
6. Start with Wave 1 (no behaviour change)?

## Version history
| Version | Date | Change |
|---|---|---|
| 1.0 | 12 Oct 2026 | First issue: opinion, principles, proposed menu, line-by-line questions, waves, decisions. |
