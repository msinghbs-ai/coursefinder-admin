# Layer 4 human review UI, source-limitation pills and Platform guide upgrade — Technical Design & UI Specification

**Status:** LOCKED — approved by the Platform Admin 21 Nov 2026 10:53 AEDT (D1–D5, §12; Decision 279). **This document itself changes no application code, edge function or migration;** the implementation PR builds §5–§8 exactly.
**Date:** 21 Nov 2026 · **Chat:** S1-Design-Layer4-Guide · **Lane:** S1-RM-Design (Admin UI fitout; no schema migrations in this lane — any server change below is handed to S1-Build / S2-Build)
**Read from:** Pilot `main` `d741077c` (20 Nov 2026 23:09 UTC, UI v2.16.74), admin `main` `a32402a4`; `docs/UI-MAP.md` (generated, release 2.16.74); live baseline `supabase/live-capture/baseline/schema.sql` plus migrations to `20261121120000`.
**Governs:** the implementation PR(s) that follow. A control, panel or wording not in §5–§8 is out of scope for that PR.

---

## 1. Executive summary

Layer 4 Review has grown five views (Review by rule, By university, By kind, Grid, Decided), three grouping tools (Grouped decisions, Clusters, rule-group Preview & Settle), 19 built-in queues with 2 to 7 choices each, and engineering read-outs (8-character refs, millisecond timings, rule codes) on the cards a reviewer reads. Catalogue screens show empty cells with no reason, and the Platform guide has no filter reference.

This design:
1. **Gives every Layer 4 card the same three decisions** — **Yes (Approve)**, **No (Reject)**, **Resubmit to Review with AI** — mapped onto each queue's existing server choices. No server choice is removed: those that do not map stay under **More options** on the card.
2. **Puts five primary filters on one row** (Module / Field, University, Destination country, Source country, Decision bucket). Every other existing filter and view moves behind **Advanced filters (N)**. Nothing is deleted.
3. **Adds four field-level empty-state pills** to Course detail, Provider detail, Entry requirements (AER), English (ELR) and Scholarships, so no logged-in user sees an unexplained blank.
4. **Upgrades `#platform-guide`** with a searchable Filter & Badge Reference, a Layer 4 guide for counsellors and reviewers, and four worked examples.

**What stays exactly as it is:** every RPC and its arguments, every role gate (AER decisions remain Platform Admin only, one at a time, never in bulk), the AER audit sample, Decision 276's freeze on new AER v1 readers and recovery paths, the consumer APIs (G3: 75 functions and 48 tables), saved views, CSV export, deep links (`?kind=`, `?provider=`, `?view=`, `?ref=`, `?review_at=`) and every `data-l4-*` test hook a spec depends on.

---

## 2. Business objectives

| # | Objective | Measure at acceptance |
|---|---|---|
| O1 | A part-time reviewer can settle a card without reading engineering terms | No rule code, version tag, 8-character ref or millisecond timing visible on a card by default (they stay under **Technical detail**) |
| O2 | One way to decide, on every queue | Every one of the 19 built-in queues shows the same three-button bar, in the same order and position |
| O3 | No silent loss of filters or scripts | Preservation map (§4) row count equals the inventory (§3) row count; contract test fails the build if a listed filter disappears |
| O4 | No unexplained blanks for counsellors and viewers | Every tracked empty field on the five screens shows one of the four pills, or a value |
| O5 | Counsellors can answer "why is this empty?" from the guide | Filter & Badge Reference covers every filter on the six screens; the four worked examples are reachable in two clicks |

---

## 3. Preservation inventory (audited from source, 21 Nov 2026)

### 3.1 Layer 4 Review (`#layer-4-review`, page key `layer4`, Curator and above, one tab: Inbox)

**Views and their controls**

| ID | Control | Where (file) | What it does |
|---|---|---|---|
| L4-V1 | **Review by rule** (default view, s837) | Layer4Focus.jsx | Left rail: every waiting item of one queue grouped by the rule that holds it (`rule_groups`); right: one focused card (`rule_group_items`) |
| L4-V2 | **Other views** toggle | Layer4Inbox.jsx | Shows the four older views |
| L4-V3 | By university | Layer4Inbox.jsx | University list (`universities`), find-a-university search, per-university kind pills, paging |
| L4-V4 | By kind | Layer4Inbox.jsx | One kind across every university (`items`) |
| L4-V5 | Grid | Layer4Grid.jsx | One kind as table rows (`admin_layer4_grid_read_v1`), Source quote drawer (`admin_layer4_item_trace_v1`), J/K keys |
| L4-V6 | Decided | Layer4Inbox.jsx | Last 100 decisions (`decided`) |
| L4-V7 | Group list (operational groups) | Layer4Groups.jsx | Ready for my decision (C), Information needed (D), Technical recovery (B) (`admin_layer4_groups`, `admin_layer4_navigate`) — shown when Other views is open (`GroupBar`) |

**Filters**

| ID | Filter | View | Server argument |
|---|---|---|---|
| L4-F1 | Kind pills (queue) with counts, incl. **All** | all views (All hidden in Review by rule) | `kind` |
| L4-F2 | Rule group rail: All in this queue · **Human Action Required** · **System Queues (Auto-Recovering)** | Review by rule | `rule_groups` keys `cd:*`, `aer:*`, `aerb:*`, `sys~*` |
| L4-F3 | Find a university (text) | By university | `universities.q` |
| L4-F4 | University's kind pill | By university | `items.provider_id` + `kind` |
| L4-F5 | AER order: Ready to decide (N) · All waiting | By university, AER | `admin_layer4_aer_queue` |
| L4-F6 | Why items are held (AER hold reasons) | By university / By kind, AER | `admin_layer4_aer_queue {hold_reasons}` (Layer4HoldReasons.jsx) |
| L4-F7 | Grid › Kind (select) | Grid | `kind` |
| L4-F8 | Grid › Reason contains | Grid | `why_contains` |
| L4-F9 | Grid › Search (item or university) | Grid | `q` |
| L4-F10 | Grid › Order (Oldest / Newest first) | Grid | `sort` |
| L4-F11 | Grid › Country pills (All, AU, NZ, CA) with live counts | Grid | `country` (provider's country) |
| L4-F12 | Grid › Provider type pills (All, University, VET / College, School, HEI) with live counts | Grid | `provider_type` |
| L4-F13 | Grid › Saved views (shared: AER Audit Samples, Official URLs, Provider Blockers; personal) · Custom | Grid | `admin_saved_views_read_v1` |
| L4-F14 | Course description queue: ready first and trust-policy sample | By university / By kind, descriptions | `admin_course_description_queue` (CourseDescriptionPanel.jsx) |
| L4-F15 | Held universities (no machine text) list | By kind, descriptions | `description_held_list` |

**Bulk and group actions**

| ID | Action | Where | Server path | Gate |
|---|---|---|---|---|
| L4-B1 | Preview & Settle Batch (one decision, one reason, typed `SETTLE n`) | Review by rule rail, per group; By university rule groups (Layer4SettleBox) | `decide` per record | each record's own rank; never AER |
| L4-B2 | Remove the words & admit n (banned-word descriptions) | Batch preview, group `cd:banned_word` | `decide` `edit_approve` + `set_manual_lock` per record | rank 4 |
| L4-B3 | Re-read n from stored copy ($0) | Batch preview, recovery groups | `aer_det_reread` | rank 6 |
| L4-B4 | Queue stored-page fetch for n | Batch preview, recovery groups | `aer_page_fetch` | rank 6 |
| L4-B5 | Grouped decisions | Grid | `admin_layer4_group_decide_read_v1`, `admin_layer4_group_decide_v1` | per item rank, typed confirmation |
| L4-B6 | Clusters (kind, university, reason, quote) and export | Grid | `items`, `detail`, `decide` per item | per item rank |
| L4-B7 | Export CSV (up to `layer4.grid_export_max_rows`) | Grid | `admin_layer4_grid_read_v1 {export}` | — |
| L4-B8 | Save as my view · Update shared view · Remove my view | Grid | `admin_saved_view_save_v1`, `admin_saved_view_archive_v1` | shared: Platform Admin |
| L4-B9 | Open for writing (held universities) | By kind, descriptions | `description_open_held` | rank 4 |
| L4-B10 | Mass operations: provider departures, quality findings, history | Layer 4 (Batches) embed, m2-3-intelligence-entry.jsx | `layer4_provider_departures_read`, `layer4_provider_departure_decide`, `layer4_quality_*`, `layer4_mass_operations_history`, `layer4_mass_summary`, `layer4_review_groups`, `layer4_review_bulk_decide`, `layer4_scholarship_scope_*` | as server |

**Card (one item) contract today** (`Item` in Layer4Inbox.jsx)

| ID | Element | Notes |
|---|---|---|
| L4-C1 | Header: kind chip, provider, subject, CRICOS / course code, created date, age in days, **Ref 8 chars** | Ref is engineering detail |
| L4-C2 | Main hold reason (`CardHold`, `plainHold`) | already plain English (s873) |
| L4-C3 | Recovery action (`AerRecoveryAction`) | rank 6 |
| L4-C4 | Progress / lifecycle (`ItemLifecycle`, `admin_layer4_lifecycle`) | folds "What the platform holds", "Event history, times and steps" |
| L4-C5 | Evidence line: Stored copy, captured date, newer copy warning, source link, Open the course record | |
| L4-C6 | Kind-specific body: fee held / proposed; page we hold vs new page; counsellor report; first-run sample; AER rows (`layer4_aer_review_read`) and course links; hook sections (`detail`); description and sentences with quotes; held scholarship | |
| L4-C7 | Edit & Approve (`DescriptionEditAdmit`), Save Edit & Admit, Approve As-Is | rank 4 |
| L4-C8 | Choice bar ordered primary · edit · re-categorise · aside (`orderChoices`) with role tooltips and hand-off line | server ranks |
| L4-C9 | Confirm panel: what happens next, inputs (url, provider, count, text, scholarship, rows, courses), reason chips (descriptions), reason (min 4, AER 5 chars) | |
| L4-C10 | Header metrics: Waiting for a person, Older than N days; Review readiness line | |

**Queues (built-in kinds) and their server choices** — from `public.admin_layer4_inbox` summary (baseline) plus s802 (`edit_approve`), s662/s664 (`approve_provider`, `reread`):

| Queue | Server choices (key: label, rank if not default 4) |
|---|---|
| course_link | keep · use · enter · refuse |
| held_scholarship | publish · not_international · not_scholarship · duplicate |
| website_needed | website · cricos_only · archive (5) |
| pages_not_found | website · pages · release · cricos_only |
| too_few_pages | pages · cricos_only |
| nothing_ready | adapter (link) · rebuild (5) · cricos_only |
| central_to_approve | open (link) |
| onboarding_failed | retry (5) · builder (link) |
| site_down | website · archive (5) · wait |
| not_offered | archive_course (5) · keep |
| fee_check | course (link) · keep |
| counsellor_report | report_fixed · report_not_changed · course (link) |
| not_on_site | archive_course (5) · keep · course (link) |
| no_page_first_run | approve · has_page · reject |
| conjoint_first_run | approve · parent · reject |
| aer_review | approve (6) · approve_except (6) · reject (6) |
| provider_description | edit_approve · approve · reject · approve_provider · reread |
| course_page_needed | add_page · search_again · no_page |
| provider_departure | closed (6) · merged (6) · reviewed (6) |
| Registered hook kinds (e.g. `course_english`, human-input requests) | provide_url · attach_document · select_source · enter_value · correct_value · confirm_identity · confirm_scope · search_again · confirm_not_published · return_technical · reject_evidence (allowed per item by the hook) |

### 3.2 Courses (`#courses`, Viewer and above)

| ID | Filter / action | Server argument (`courses_page`) |
|---|---|---|
| C-F1…F5 | Country · State / Region · Provider · University group · Study level | country_code, subdivision_code, provider, university_group, level |
| C-F6…F21 | (advanced) Field · Delivery · Has fee · Has intake · Has English · Course description · Study load · Empty reason · International students · Has scholarship · Minimum completeness · Freshness · Status · Publication | as named |
| C-F22 | Missing field pills: Fee · Intake · English · Scholarship · Description · Study load | hasFee=false etc. |
| C-F23 | Search (course, provider, CRICOS / course code, stable key) | query |
| C-A1 | Choose columns · CSV export · drill-down presets (`#courses?f_…`) | — |
| C-D1 | Course detail folds and cards (UI-MAP lines 26–61), incl. Notes panel (s901), Layer 4 corrections (`Layer4Intervention`: `layer4_effective_entity`, `layer4_override_*`, `layer4_publication_state`, `publication_control_*`) | — |

### 3.3 Providers (`#providers`, 4 tabs)

| ID | Filter / action | Server argument (`providers_page`) |
|---|---|---|
| P-F1…F5 | Country · Type · Status · Description · University group | country_code, provider_type, lifecycle, description, university_group |
| P-F6…F14 | More filters (8 + region): State / Region · Publication · Adapter · Description quality · Description admission · Description source · Website feed · Zoho feed · Main campus | as named |
| P-F15 | Missing field pills: Description · Website · City · State / Region · Type · Phone · Email · Address · Established year | missing |
| P-A1 | Bulk bar: Fill descriptions · Queue to Intake Run & Validate · Flag primary campus · Export selected CSV | `ProviderBulkBar`, `BulkPrimaryCampus` |
| P-T1 | Campuses tab: Country · Region · Provider · Primary · Locality | campuses_page |
| P-T2 | Logos & assets (Pipeline Operator+) · Archived (Curator+): Providers · Courses not active | — |

### 3.4 Entry requirements — AER (`#entry-requirements`, 4 tabs) — `admin_aer` actions summary, options, row, update, add, reread, resolve, lifecycle, course_search, course_programme, course_batch(_preview), evidence_options; `admin_aer_outcomes`, `admin_aer_schedule`

| ID | Tab | Filters |
|---|---|---|
| A-F1 | Provider entry matrix | Provider · **Destination country** · **Source country** · **Applies to** (University-wide / One course) · Study level · Status · Kind · Band · Search · Edition · Intake year · Read |
| A-F2 | Course entry requirements | Provider · Course · Kind · For (audience) · Status · Band · As at from · As at to · Search |
| A-F3 | Sources, reads and holds | Provider · Fetch · Read state · Search |
| A-F4 | Resolution inspection | Course · Country of prior education (five-rule resolver) |
| A-A1 | Columns · Add an entry requirement · Withdraw · Restore · Quarantine · Read again · Read next batch | as server |

### 3.5 English language requirements — ELR (no page of its own)

| ID | Where | Filter / action | Server |
|---|---|---|---|
| E-F1 | Courses filter / Missing pill | Has English · English | courses_page |
| E-F2 | Coverage › Attributes › English policies | Show policies · Document type · Stage · course groups and "No rule yet" · Run `policy-add-tests` | `admin_provider_policies_read`, `admin_provider_policy_decide(_bulk)`, `admin_provider_english_status_read`, `admin_provider_english_groups_set_v1`, `admin_automation_control` |
| E-F3 | Layer 4 hook kind `course_english` (regulated-discipline holds, s884–s886) | hook choices | `admin_layer4_inbox` |
| E-J1 | Jobs (unchanged): `elr-det-sweep` (elr-det-v1.0, elr-central-v1.0/1.1, elr-band-v1.0), `policy-add-tests` | Scheduled jobs |

### 3.6 Scholarships (`#scholarships`, 2 tabs)

| ID | Filter / action |
|---|---|
| S-F1 | List: Country · Provider · Audience · Course · Award type · Nationality · Student nationality · Also not stated · How to apply · Has description · Has benefits · Has sponsor · Has closing date · Detail read · State · Round · Course links · Detail recovery · Source stale |
| S-F2 | Coverage (Curator+): Which providers (Watch list · All with scholarships · All providers) · Which pages (All · New · Known · Site map and listing) · Which sample pages (All · Where a model disagrees) · Extraction results · Instructions to the model |
| S-A1 | Notes panel (AttachmentNotes, s901) · scholarship record folds (courses and why linked; evidence and extraction) |

### 3.7 Guides (`#platform-guide`, 4 tabs) — Platform guide (`src/guide/platformGuide.js`, 12 parts), Role guides, Platform Admin SOP, Operator SOP. Contract: reviewed version = UI version; every menu page has an entry (Decision 209).

**Inventory coverage:** every ID above (L4-V, L4-F, L4-B, L4-C, the 19 queues and hook kinds, C-, P-, A-, E-, S- and the Guides) has a row or a group row in §4. The implementation PR's contract test (a) counts the IDs on both sides and fails if they differ.

---

## 4. Preservation & Migration Map

Rule: **K** = kept where it is · **M** = moved (same control, same server argument, new place) · **R** = relabelled only · **N** = new. **Nothing is deleted. Nothing is duplicated**: a control that moves leaves no copy behind.

### 4.1 Layer 4 filters and views

| From (ID) | To | Map | Notes |
|---|---|---|---|
| L4-F1 Kind pills | **Primary row › Module / Field** (one select; options = queues with counts, grouped by module: Course data, Entry requirements, English, Fees, Scholarships, Providers, Descriptions) | M + R | same `kind` argument; deep link `?kind=` unchanged |
| L4-F3 Find a university, L4-F9 Grid search | **Primary row › University** (type-ahead, provider id) | M | needs `provider_id` on `rule_groups` and `admin_layer4_grid_read_v1` (see D3); until then filters by `q` |
| L4-F11 Country pills | **Primary row › Destination country** (All, AU, NZ, CA) | M + R | same `country` argument; counts kept |
| — | **Primary row › Source country** | N | AER and ELR rows only (student's country of prior education). Needs a server argument (D3). Disabled with tooltip on other modules |
| L4-F2 rule-group rail sections | **Primary row › Decision bucket**: Ready to decide · Needs information · System recovery · All | M + R | Ready = Human Action Required groups; System recovery = `aerb:` / `sys~` groups; Needs information = hook kinds asking for input (L4-V7 group D) |
| L4-F2 rule groups (list) | Left rail, unchanged, under the primary row | K | |
| L4-F12 Provider type, L4-F8 Reason contains, L4-F10 Order, L4-F13 Saved views, L4-F5 AER order, L4-F6 Why held, L4-F14 description queue modes | **Advanced filters (N)** panel (N = how many are set) | M | panel closed by default; a set advanced filter shows as a removable chip under the primary row |
| L4-V2…V7 Other views | **Advanced filters › View** (By university, By kind, Grid, Decided, Groups) | M | `?view=` deep links unchanged |
| L4-B5 Grouped decisions, L4-B6 Clusters, L4-B7 Export, L4-B8 view save | **Advanced filters › Tools** | M | |
| L4-B1…B4 Preview & Settle Batch | Rail group row, unchanged; batch bar uses the three-decision labels (§5.3) | K + R | |
| L4-B9, L4-F15 Held universities | Descriptions module, unchanged | K | |
| L4-B10 Mass operations | unchanged (Batches embed) | K | |
| L4-C10 header metrics | kept; "Older than N days" kept | K | |
| L4-C1 Ref 8 chars, "Grouped n in x ms", "shown in x ms (database y ms)", rule codes, version tags | **Technical detail** fold on the card / rail footer, closed | M | O1 |

### 4.2 Layer 4 choices → three decisions

| Queue | **Yes (Approve)** | **No (Reject)** | **Resubmit to Review with AI** | **More options** (kept, unchanged) |
|---|---|---|---|---|
| course_link | use | refuse | — (D2) | keep · enter |
| held_scholarship | publish | not_scholarship | — | not_international · duplicate |
| website_needed | website (enter it) | — | — | cricos_only · archive (5) |
| pages_not_found | pages | — | release (re-try) | website · cricos_only |
| too_few_pages | pages | — | — | cricos_only |
| nothing_ready | — | — | rebuild (5) | adapter (link) · cricos_only |
| central_to_approve | open (link) | — | — | — |
| onboarding_failed | — | — | retry (5) | builder (link) |
| site_down | website | archive (5) | — | wait |
| not_offered | keep | archive_course (5) | — | — |
| fee_check | keep | — | — | course (link) |
| counsellor_report | report_fixed | report_not_changed | — | course (link) |
| not_on_site | keep | archive_course (5) | — | course (link) |
| no_page_first_run | approve | reject | — | has_page |
| conjoint_first_run | approve | reject | — | parent |
| aer_review | approve (6) | reject (6) | `aer_det_reread` ($0, 6) where the card's server check says *rereadable*; otherwise hidden | approve_except (6) |
| provider_description | approve | reject | reread | edit_approve · approve_provider |
| course_page_needed | add_page | no_page | search_again | — |
| provider_departure | reviewed (6) | closed (6) | — | merged (6) |
| hook kinds (e.g. course_english) | correct_value / enter_value / confirm_* (first allowed) | reject_evidence | search_again where allowed | the rest, as the hook allows |

Rules:
- A button whose choice is missing for that queue is **not drawn** (never shown disabled without reason). A card always has at least one of the three or a link.
- Rank gates, inputs and confirm panels are the server choice's own (L4-C8, L4-C9). A button the person's rank cannot take shows the existing hand-off line.
- **No (Reject)** opens the 1-click reason chips: **Wrong course · Outdated year · Bad parse · Not offered**, plus free text. The chip fills the existing reason field (min length unchanged). Description queues keep their existing `ReasonChips` and add these four.
- **Yes (Approve)** shows **Lock this value** (off by default) where the server's `decide` accepts `set_manual_lock` for that choice (D4). Where it does not, the toggle is not drawn.

### 4.3 Catalogue, AER, ELR, Scholarships, Guides

| From | To | Map |
|---|---|---|
| C-F1…F23, P-F1…F15, P-A1, P-T1, P-T2 | unchanged | K |
| A-F1…F4 (incl. s901 Destination / Source country / Applies to) | unchanged | K |
| E-F1…F3, E-J1 | unchanged | K |
| S-F1…S-A1 | unchanged | K |
| Blank value cells on Course detail, Provider detail, AER, ELR, Scholarships | **Empty-state pill** (§6) | N |
| Empty reason labels (`EMPTY_REASON_LABELS`: not published by provider, not on register, online only, waiting to be read, source unavailable) | reused as the source of *Not stated on institution page* and *No official website / course URL* | K (reused, not duplicated) |
| Platform guide parts | kept; three parts added (§7) | K + N |
| Notes panel (AttachmentNotes) | kept; worked examples link to it | K |

**Scripts, jobs and RPCs:** every RPC in §3 is called with the same arguments. No job is added, rescheduled or retired. No edge function changes. The only server changes are optional read arguments (D3) and possibly a lock flag (D4), each a separate S1-Build / S2-Build migration numbered above the live head, md5-guarded, and outside this lane.

---

## 5. Layer 4 Review — locked wireframes and component contract

### 5.1 Screen (desktop, ≥ 1024 px)

```
┌─ Layer 4 Review ─────────────────────────────────────────────────────────────────────────────┐
│ [Waiting for a person  1,956 · 143 universities]   [Older than 14 days  212]                 │
│ Review readiness: …(unchanged ReviewReadinessLine)…                                          │
├──────────────────────────────────────────────────────────────────────────────────────────────┤
│ Module / Field [Entry requirements (AER) 79 ▾]  University [Find a university…      ]       │
│ Destination country [All|AU|NZ|CA]  Source country [Any ▾]  Decision bucket [Ready to decide ▾]│
│ [Advanced filters (2)]                                                    [↻ Refresh]        │
│  ✕ Provider type: University   ✕ Saved view: AER Audit Samples                               │
├───────────────────────────────┬──────────────────────────────────────────────────────────────┤
│ Waiting, grouped by rule      │  Completeness gate (partial table read)   Card 3 of 57       │
│ ─ All in this bucket     57   │                                   [◀ Previous] [Next ▶]      │
│ ─ Completeness gate …    57 👁│ ┌──────────────────────────────────────────────────────────┐ │
│ ─ Audit sample            1 👁│ │  (review card, §5.2)                                      │ │
│                               │ └──────────────────────────────────────────────────────────┘ │
│ [Preview & Settle Batch]      │                                                              │
│ ▸ Technical detail            │                                                              │
└───────────────────────────────┴──────────────────────────────────────────────────────────────┘
```

Phone (< 640 px, Platform Admin works Layer 4 from the phone): primary row stacks one filter per line; rail collapses to a **Rule: [select]** line above the card; the decision bar is sticky at the bottom of the card.

### 5.2 Review card (one item)

Values in the wireframes (addresses, quotes, counts) are illustrative only; the card shows the item's own stored data.

```
┌──────────────────────────────────────────────────────────────────────────────────────────┐
│ Entry requirements · Charles Sturt University · CRICOS 00005F       2 Nov 2026 · 19 days │
│ Field: University-wide entry table — source country Hong Kong                             │
├──────────────────────────────────────────────────────────────────────────────────────────┤
│ Proposed value                     │ Live value now                                       │
│  HKDSE 18 points (best 5 subjects) │  — Not stated on institution page                    │
├──────────────────────────────────────────────────────────────────────────────────────────┤
│ Official source  https://study.csu.edu.au/international/entry …  ↗   saved 18 Nov 2026    │
│ “Applicants presenting the HKDSE require a minimum of 18 points…”  (quote highlighted)    │
├──────────────────────────────────────────────────────────────────────────────────────────┤
│ Why it is held   The read dropped a row the page publishes, so the table waits for a      │
│                  person.  (i) Hint                                                         │
├──────────────────────────────────────────────────────────────────────────────────────────┤
│ [ Yes (Approve) ]  [ No (Reject) ]  [ Resubmit to Review with AI ]        More options ▾  │
│  Only the Platform Admin decides entry requirements.          (hand-off line, if needed) │
├──────────────────────────────────────────────────────────────────────────────────────────┤
│ ▸ Progress and history     ▸ Evidence and stored copy     ▸ Technical detail             │
└──────────────────────────────────────────────────────────────────────────────────────────┘
```

**(i) Hint tooltip** (one per hold reason; text comes from one table, `HOLD_HINTS`, keyed by the existing rule-group key):

```
┌ Completeness gate ─────────────────────────────────────────────┐
│ What it means: the page lists a row the machine did not read.  │
│ Example: the page lists 8 countries, the read has 7.           │
│ Choose Yes if every row shown matches the page.                │
│ Choose No if a row is wrong. The missing row stays waiting.    │
└────────────────────────────────────────────────────────────────┘
```

Card zones, in this order, and nothing else at the top level:

| Zone | Content | Source (existing) |
|---|---|---|
| Z1 Entity | Module label, provider, course title, CRICOS / course code, created date, age; the **Field** line (target field in plain words) | `it.kind`, `it.provider`, `it.subject`, `d.course_code`, `d.field_code` → plain label |
| Z2 Values | **Proposed value** beside **Live value now** (or an empty-state pill, §6) | `d.proposed`, `d.before`, AER rows, `quoteValuePairs` |
| Z3 Source | Clickable official URL ↗, saved date, newer-copy warning, verbatim quote with the extracted value highlighted (`<mark>`) | `d.source_url`, `t.evidence`, quote pairs |
| Z4 Why | Plain hold reason (`holdLabelOf`, `plainHold`) + (i) Hint | unchanged helpers |
| Z5 Decide | Three-decision bar, More options, hand-off line, confirm panel | §4.2 |
| Z6 Folds (closed) | Progress and history (`ItemLifecycle`); Evidence and stored copy (stored copy link, Open the course record, AER course links, hook sections); Technical detail (Ref, rule code, reader version, raw why text, timings) | unchanged components |

AER cards keep their row table (with "Approve except…" under More options and the existing tick rules). Multi-row cards show Z2 as the existing row table, each row with its quote.

### 5.3 Decision bar states

| State | Yes | No | Resubmit | Shown text |
|---|---|---|---|---|
| Idle | enabled | enabled | enabled if mapped and allowed | — |
| Rank too low | hidden choice → hand-off line | same | same | "Only a {role} decides this; ask a {role}." |
| Completeness-gated (AER) | disabled | enabled | enabled if rereadable | "Held: this read is incomplete." (existing) |
| Confirm open (Yes) | — | — | — | What happens next · input if the choice needs one · [Lock this value] · Reason · [Confirm] [Cancel] |
| Confirm open (No) | — | — | — | Reason chips: Wrong course · Outdated year · Bad parse · Not offered · Reason · [Confirm] [Cancel] |
| Confirm open (Resubmit) | — | — | — | "Queued for another read. It comes back here for Yes or No." · AI budget line (§5.4) · Reason · [Confirm] |
| Busy | all disabled, "Saving…" | | | |
| Server asks for more (`ok:false`) | confirm stays open | | | the server's `request` text (existing) |
| Done | card leaves; next card focuses | | | server ack (existing `ack`) |

Batch bar (Preview & Settle Batch): the decision select lists only the three decisions that map for the group's queue; typed `SETTLE n` confirmation, minimum reason and per-record rank are unchanged. AER groups keep "decided one card at a time".

### 5.4 Resubmit to Review with AI — routing contract

Resubmit never creates a new reader, prompt, model route or recovery path. It calls the queue's **existing** re-read choice:

| Queue | Existing path called | Cost | Returns to Layer 4 as |
|---|---|---|---|
| aer_review | `aer_det_reread` (deterministic reader on stored copy) — only when the server check says *rereadable* | $0, no AI, no Firecrawl | new AER read for Yes / No |
| provider_description (course and university) | `reread` (s664, 1–2 sentences) | AI under `budgets.ai_daily_ceiling_usd` and the description service's cap | new description card |
| course_page_needed | `search_again` | search-lane daily share | course page found → course_link card |
| pages_not_found | `release` | adapter re-run | as before |
| nothing_ready / onboarding_failed | `rebuild` / `retry` (rank 5) | adapter builder model as configured in Models & Services | as before |
| hook kinds | `search_again` where the hook allows it | per hook | per hook |

- Before confirm, the panel shows **AI budget today: US$x of US$y used** from the existing budget read; when the ceiling is reached, Resubmit is disabled with "Today's AI budget is used; try tomorrow or decide Yes / No." Staged results follow the current staging rules (Decision 276 and the 21 Nov 09:57 partial-admission decision): nothing Resubmit returns is admitted without the same machine rule and a Layer 4 Yes.
- A queue with no existing re-read path does not draw the button. A general "AI re-extract any field" service is **out of scope** (D2).

### 5.5 Advanced filters panel

```
┌ Advanced filters ────────────────────────────────────────────────────────────┐
│ View        (•) Review by rule  ( ) By university  ( ) By kind  ( ) Grid  ( ) Decided  ( ) Groups │
│ Provider type [All ▾]     Reason contains [        ]     Order [Oldest first ▾] │
│ Saved views  [AER Audit Samples] [Official URLs] [Provider Blockers] [mine…]   │
│ AER          (•) Ready to decide first  ( ) All waiting     [Why items are held] │
│ Tools        [Grouped decisions] [Clusters] [Export CSV] [Save as my view]     │
│                                                    [Clear advanced] [Close]   │
└──────────────────────────────────────────────────────────────────────────────┘
```

Controls appear only where they work today (e.g. Saved views and Tools only with View = Grid; AER only with Module = Entry requirements). The counter N counts set advanced filters. State is kept for the browser tab with the existing `l4i-sel` / `l4i-pos` session keys.

### 5.6 Wording rules (card and filters)

| Engineering term today | Shown instead |
|---|---|
| `proposed` (AER row), `pending` (review item), `unverified` | Waiting for your decision |
| `active` | Live |
| `superseded` | Replaced by a newer read |
| rule keys `cd:*`, `aer:*`, `aerb:*`, `sys~*`, reader versions (`aer-det-v1.3`) | plain group name; code under Technical detail |
| `Ref 1a2b3c4d`, ms timings | Technical detail only |

---

## 6. Source-limitation pills (logged-in users)

### 6.1 The four pills

| Pill | Meaning | Shown when (first match wins, top to bottom) | Action |
|---|---|---|---|
| **In Layer 4 review (N waiting)** | A value is proposed and a person decides it | a pending `pipeline.layer4_review_items` row (or pending AER / ELR row) exists for this entity and field | Curator+: link to Layer 4 filtered to the item; Viewer / Counsellor: no link, tooltip "A reviewer is checking this value." |
| **University-wide rule applies** | The course has no own value; a university-wide row covers it | AER: university-wide active row for the source country (five-rule resolver rules 3–4); ELR: central English policy for the study level; Scholarships: university-wide scholarship link | link to the provider's entry table / English policy / scholarship list |
| **No official website / course URL on file** | Nothing can be read because no address is held | provider `website` empty, or course has no official course URL (`no_course_url`), or empty reason `source_unavailable` with no address | Admin / Editor (Curator rank 3+): **Add official URL** — one field, https only, validated on the provider's own host, saved through the existing course-link / website choice path |
| **Not stated on institution page** | The page was read and does not state it | empty reason `not_published_by_provider`, AER `not_stated` scale, description `not_stated`, or reader result "read, not found" | link to the stored copy (Curator+); tooltip with read date |

Precedence: **In review** beats the rest (it may fill the gap soon); then **University-wide**; then **No URL**; then **Not stated**. If none matches the cell shows "—" with the existing empty reason label, never a bare blank.

### 6.2 Where they appear

| Screen | Fields |
|---|---|
| Course detail | Fee, Intake, English, Entry requirements, Scholarships, Description, Study load, Course URL |
| Provider detail | Website, Description, City, Phone, Email, Main campus, Entry table |
| Entry requirements (AER) matrix and course tabs | Minimum, Scale, Source row for a source country |
| English (Course detail English card; Coverage › English policies) | Overall score, band |
| Scholarships record | Course links, Closing date, Value |

Component: one `FieldGap` pill (shared kit, `ui-kit`), props `{state, count, href, canAct, onAddUrl}`; states from one pure function `gapStateOf(field, record)` covered by a unit test for each precedence row. Pills read data already returned by `course_detail`, `provider_detail`, `admin_aer` and the scholarship record; where a count is not returned, see D3.

### 6.3 Coverage notice (Platform guide and Catalogue Home)

```
┌ ⓘ What StudySearch covers ─────────────────────────────────────────── [Dismiss] ┐
│ Countries live: Australia, New Zealand, Canada.                                   │
│ Values come from official registers (CRICOS, NZQA, DLI list) and each             │
│ institution's own pages. A blank shows why: in review, university-wide rule,       │
│ no official address, or not stated on the page.   [How to read the pills →]       │
└───────────────────────────────────────────────────────────────────────────────────┘
```

Role-aware: Viewer and Counsellor see the text above; Curator+ also see "Add an official address from the pill on the record." Dismissal kept per user (existing remembered-state helper). Country list read from the existing `firecrawl.target_countries` setting, not hard-coded.

---

## 7. Platform guide upgrade (`#platform-guide`)

New parts added to `PARTS` (existing 12 kept, in order): **Filters & badges**, **Layer 4 guide**, **Worked examples**.

### 7.1 Filter & Badge Reference

```
┌ Filters & badges ────────────────────────────────────────────────────────────┐
│ [Search filters and badges…            ]   Screen [All ▾]                    │
├──────────────┬────────────────────┬──────────────────────────┬───────────────┤
│ Screen       │ Filter / badge     │ What it looks at         │ Use it when…  │
├──────────────┼────────────────────┼──────────────────────────┼───────────────┤
│ Entry req.   │ Destination country│ Where the university is  │ You want AU   │
│              │                    │ (AU, NZ, CA)             │ universities  │
│ Entry req.   │ Source country     │ Where the student's prior│ A student from│
│              │                    │ qualification is from    │ India asks…   │
│ Entry req.   │ Applies to         │ University-wide row or   │ A course shows│
│              │                    │ one course               │ no own row    │
│ Layer 4      │ Decision bucket    │ Ready / Needs info /     │ …             │
│              │                    │ System recovery          │               │
└──────────────┴────────────────────┴──────────────────────────┴───────────────┘
```

Data: new `src/guide/filterReference.js`, one entry per §3 filter ID (screen, label, what it queries in plain words, when to use it, roles that see it) and one per badge / pill. **Contract test** (new spec in the implementation PR): every `FilterSelect` / `PagedFilterSelect` / `TriFilter` label on the six screens and every Layer 4 primary / advanced filter has an entry, and the reviewed version equals the UI version (same rule as Decision 209). The admin copy is generated, never edited by hand.

### 7.2 Layer 4 guide for counsellors and reviewers

Sections: (1) How to tell a record is under review (the **In Layer 4 review** pill; counsellors cannot open Layer 4, Curators and above can); (2) The card, zone by zone; (3) Yes / No / Resubmit and what each does next; (4) Who may decide what (rank table: AER and provider departures Platform Admin; archive Platform Admin / PIM Admin; most others Pipeline Operator; Curators read and correct records); (5) Reporting a wrong value as a counsellor (Zoho → Counsellor report, unchanged).

### 7.3 Four worked examples

| # | Example | Walkthrough (screens and what the user sees) |
|---|---|---|
| W1 | **University-wide AER inheritance — Charles Sturt University (00005F)** | Course detail → Entry requirements card shows *University-wide rule applies* for India; the Hong Kong row shows *In Layer 4 review (1 waiting)*; Entry requirements › Provider entry matrix with Destination country = AU, Source country = Hong Kong, Applies to = University-wide; Layer 4 card for the dropped row; after Yes the row is Live and the pill becomes the value |
| W2 | **Scholarship attachment rules** | Named course vs study-level / faculty rule vs university-wide (from AttachmentNotes); why a new course shows *University-wide rule applies* or nothing yet; *Check scholarships for this course* |
| W3 | **Central English policy vs Nursing / Medicine holds** | Central English page sets the score per study level (*University-wide rule applies*); a Bachelor of Nursing at the same university shows *In Layer 4 review* because regulated disciplines with higher bands are held (`course_english`, s884–s886); the reviewer sees the central page quote and decides Yes / No |
| W4 | **A course with no website / URL** | Course detail shows *No official website / course URL on file*; a Curator uses **Add official URL** (own host, https); the course link is read again and returns values or a *Not stated on institution page* pill; a counsellor sees the pill and reports it from Zoho if they know the page |

Examples carry dates and figures as read at release and are re-checked at each release review (Decision 209). They name no customer-confidential data.

---

## 8. Component contract (implementation PR builds only these)

| Component | New / changed | File | Contract |
|---|---|---|---|
| `L4PrimaryFilters` | new | src/Layer4PrimaryFilters.jsx | five filters (§5.1), maps to existing args; emits `{kind, provider_id, country, source_country, bucket}` |
| `L4AdvancedFilters` | new | src/Layer4AdvancedFilters.jsx | §5.5; hosts moved controls, no new server call |
| `L4DecisionBar` | new | src/Layer4DecisionBar.jsx | §4.2 mapping table `THREE_DECISIONS` in `src/lib/l4-rules.js`; uses existing `choose` / `go` of `Item` |
| `RejectReasonChips` | new | src/Layer4DecisionBar.jsx | four chips + free text, fills reason |
| `HOLD_HINTS` | new data | src/lib/l4-rules.js | one hint per rule-group key; fallback hint |
| `Item` (card) | changed | src/Layer4Inbox.jsx | zones Z1–Z6 (§5.2); every `data-l4-*` hook kept |
| `Layer4Inbox` | changed | src/Layer4Inbox.jsx | primary row + advanced panel replace the kind toolbar and view group; views kept |
| `Layer4Focus`, `Layer4Grid` | changed (labels, ms read-outs to Technical detail) | | no logic change |
| `FieldGap`, `gapStateOf` | new | src/ui-kit, src/lib/field-gap.js | §6 |
| `CoverageNotice` | new | src/CoverageNotice.jsx | §6.3 |
| Guide parts | new | src/guide/filterReference.js, src/guide/layer4Guide.js, src/guide/workedExamples.js, src/PlatformGuide.jsx | §7 |
| Specs | new | tests/uat/… | (a) §4 map completeness, (b) three-decision mapping per queue, (c) `gapStateOf` precedence, (d) guide filter coverage, (e) UI-MAP regenerated |

Not built: any new panel, dashboard, setting, job, reader, prompt, model route, or bulk AER action.

---

## 9. Assumptions

1. Layer 4 stays Curator and above; Counsellor and Viewer see review state only through the pill.
2. "Module / Field" groups the existing queues; it does not add a field-level index on the server unless D3 is approved.
3. Resubmit uses only existing re-read paths (§5.4).
4. Version pill bumps once for the UI release, with release notes listing the visible changes.
5. No consumer API change; Website v2 and v3 and Zoho untouched.

## 10. Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Three buttons hide a choice reviewers use often (e.g. course_link *keep*) | slower decisions | More options is one click and remembers the last opened state per queue; acceptance session on the mock-up first |
| Source country and University filters need server arguments | filters can't narrow the rail fully | D3: either a small read-only migration by S1-Build, or ship University by text search and Source country on AER / ELR only |
| Mapping "Yes" to *keep* on some queues reads oddly | wrong decision | labels show the queue's own wording under the button (e.g. "Yes — keep the course") |
| Spec hooks (`data-l4-choice`, `data-l4-view`) break | CI red | buttons keep `data-l4-choice={server key}`; contract test (b) |
| Parallel lanes touching Layer4Inbox.jsx | merge conflicts | announce in CURRENT-STATE; one PR; re-read main and open PRs before merging |
| Guide examples go stale | wrong guidance | release review (Decision 209) re-reads figures |

## 11. Project phases, milestones and estimated hours (implementation, after sign-off)

| Phase | Work | Milestone | Est. hours |
|---|---|---|---|
| 0 | ~~Interactive mock-up artefact~~ — skipped by D1 (21 Nov 2026) | — | 0 |
| 1 | Primary / advanced filters, decision bar, card zones, wording | Layer 4 UI on preview | 10 |
| 2 | `FieldGap` pills on five screens, Add official URL, Coverage notice | Pills on preview | 8 |
| 3 | Guide: filter reference, Layer 4 guide, worked examples, contract tests | Guide on preview | 6 |
| 4 | Read-only server arguments (D3), migration by S1-Build | Migration merged and read back | 4 |
| 5 | Full targeted specs, UI-MAP regen, release notes, signed-in browser test (desktop + 375 px), admin docs | Release live and accepted | 4 |
| | **Total** | | **28–32** |

## 12. Decisions requested (Platform Admin)

| # | Question | Options (recommended first) |
|---|---|---|
| D1 | Approve this design as the locked spec? | Approve as written · Approve with changes listed · Rework |
| D2 | Resubmit to Review with AI scope | Existing re-read paths only (§5.4) · Also build a general field re-extraction service (new AI service, new prompt, AER v2 lane; separate design) |
| D3 | University and Source country filters on Layer 4 | Small read-only server arguments by S1-Build (provider_id, source_country on `rule_groups` and the grid read) · Client-side only (University by text search; Source country on AER / ELR cards only) |
| D4 | Lock toggle on Yes | Only where `decide` already accepts `set_manual_lock` · Extend `decide` to accept the lock on every Yes (server change) |
| D5 | Who sees *Add official URL* | Curator (rank 3) and above · Pipeline Operator (rank 4) and above |

**Signed off (Platform Admin, 21 Nov 2026 10:53 AEDT; recorded as Decision 279 in `docs/coursefinder-design-reference-v1.4.md`):**

| # | Decision |
|---|---|
| D1 | **Approved as the locked spec.** Phase 0 (the separate interactive mock-up) is skipped: implementation builds the locked §5–§8 wireframes and component contract directly. Estimated hours become 28–32. |
| D2 | **Existing re-read paths only** (§5.4). Decision 276 and the daily AI spend ceiling (`budgets.ai_daily_ceiling_usd`) apply. No general field re-extraction service. |
| D3 | **Small read-only server arguments**: `provider_id` and `source_country` on `rule_groups` and `admin_layer4_grid_read_v1`. They ship live in the implementation release: one migration above the live head, md5-guarded, merged repo-first. Phase 4 is in scope. |
| D4 | **Lock this value** (off by default) is shown on Yes only where `decide` already accepts `set_manual_lock` for that choice. No change to `decide`. |
| D5 | **Add official URL** is shown to Curator (rank 3) and above. |

Under the standing mandate of 21 Nov 2026 10:07 AEDT (immediate live activation), every part of §5–§8 is live on deploy: no feature flag, shadow period or delayed cutover.

## 13. Notes

- Records the direction of the S1-Design-Layer4-Guide brief (21 Nov 2026). Decisions recorded as Decision 279 in `docs/coursefinder-design-reference-v1.4.md` and in `docs/CURRENT-STATE.md`. Spec numbers are assigned at implementation, strictly above the live maximum.
- Figures (1,956 waiting, 79 AER matrix items, Charles Sturt) are from 20–21 Nov 2026 admin records and are re-read before the mock-up.
