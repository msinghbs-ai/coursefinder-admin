# Admin UI cleanup and course-list enrichment — decision record

**Date:** 24 Oct 2026, 11:27 → 13:00 AEDT (in progress; each phase says what is open)
**Mandate:** Platform Admin, 24 Oct 2026 11:27 (section 9). Audit: [2026-10-24-admin-ui-audit.md](2026-10-24-admin-ui-audit.md) (19 panels, exported 11:13).
**Merge order (each PR's base is the one before):** #683 Phase 0 → #684 Phase 2 → #685 Phase 3 → #686 Phase 1. **Until #683 merges, `coverage-admit` keeps failing every 10 minutes live** (the fix is in that PR).

**Rules:** CF-247 (CLAUDE.md) — additive Website API v2, frozen consumer API (Decision 266), no drops, catalogued jobs, settings not code, decisions before code. **This file is the decision record.** Work is PRs against Coursefinder-Pilot; **nothing merges without Platform Admin review** — none of the PRs below is merged. Net direction: less surface, not more; no new panels.

**On verification:** the mandate names the Kimi browser extension for before/after evidence; this session has no browser, so the "after" column below is what the build and the contract tests prove, and the extension's screenshots go in section 6 when the Platform Admin runs it against the merged release. Where a figure was read from the live database it says so.

---

## 1. Phase 0 — incidents (PR #683, branch `cf247-ui-audit-phase0`, v2.15.341)

### Incident 1 — the global error banner follows a person across screens
**Root cause (code, `src/mature-main.jsx`).** The shell keeps one `error` string; every screen sets it through `onError`, and nothing cleared it on navigation. A statement-timeout from one screen's load (Dashboard or Coverage, typically) therefore stayed on the next screens — Go-live checklist, Users & roles and Guides never raised it; they inherited it. The text shown was the raw Postgres message.
**Fix.** `go()` clears the banner on every navigation. Every error shown to a person goes through `src/lib/errors.js`: a plain sentence for known errors ("The database took too long to answer and stopped the request…"), otherwise the first line with every internal replaced (schema-qualified names and `name(args)` signatures → "a platform step", Firecrawl → "the page-reading service", OpenRouter → "the AI service", job slugs → their words in quotes, UUIDs → "a record", hashes → "a file"), at most 160 characters, never `ERROR:`, `CONTEXT:`, `DETAIL:` or `SQL statement`. The banner adds a six-character reference; the full detail (raw message, code, page, time, who) is written to `pipeline.ui_error_log` through `public.admin_ui_error_report`. The Platform Admin looks it up with `select * from pipeline.ui_error_log where ref = 'AB3K7Q'`. 90-day retention through `ledger-retention` (`retention.ui_error_log_days`).
**Also.** All 49 panels had their own `errText` helper (most left the raw message); every one now calls the shared reading (contract test s95 checks every file).

### Incident 2 — raw PL/pgSQL error (`layer4_course_link_apply_impl`) on three screens
**Root cause (data + code).** Not a display bug first: the job **coverage-admit had failed on every run since 23 Oct 11:40 UTC — 77 runs in 48 h** (read from `cron.job_run_details`). A Decision 263 "take" rule tried to apply a plain `http://` course address (187 such rows in a 45,314-row plan) and `layer4_course_link_apply_impl` refuses anything but `https://`, which aborted the whole batch — 23,928 official-page and 11,249 English plan rows were not admitting. Platform health, Layer 2/3 and Scheduled jobs showed the raw message because the health check, the operations panel and the run history render job messages verbatim.
**Fix.** Migration `20261024006000` (md5-guarded edit of `coverage_admission_apply_v1`): a rule never applies an `http://` address; the row becomes an ordinary pending Layer 4 item ("please check which page is current"). Dry run on a branch: the job ran again (86 written, 39 to Layer 4, 21 decided by rule, 0 errors). Display: `scrubInternals` on health issue titles and detail values, raw ISO stamps shown as dates, the Automations last-error tooltip with the raw text removed.

### Incident 3 — version mismatch (top bar v2.15.339, inner screen v2.15.340)
**Root cause (deployment, not a half-applied release).** The app is a single-page bundle: the shell (top bar, release pill, `UI_VERSION`) is loaded once; each screen is a separate chunk loaded on first visit. v2.15.340 deployed at ~11:18 AEDT while the audit's window was open on the v2.15.339 shell; screens opened after that moment fetched the new chunks, whose guide/SOP footers print "reviewed for v2.15.340 · this app is v2.15.339". The database and worker were fully on v2.15.340 (migration md5 and worker version verified at 11:20). **Nothing was half-applied**; the window was.
**Fix.** `DeployedVersionNotice` reads `public/release-history.json` (written at every build with the current version) after sign-in, on every navigation and every five minutes, and shows "A newer version (vX) has been released; this window is on vY. Reload to update." with a Reload button. Nothing reloads by itself (a person may be mid-edit). The existing chunk-load fallback (reload once when a chunk is missing) stays.
**Found on the way.** The release pill's notes for v2.15.339 and v2.15.340 still showed the v2.15.338 text (the manifest's `RELEASE` block was not updated in those two bumps). Release-notes files for both are added (`docs/release-notes/v2.15.339.md`, `v2.15.340.md`) and the v2.15.341 block is correct.

### Incident 4 — "Fully complete courses" 5,660 → 0 on 20 Oct
**Root cause (metric definition, not identity re-verification).** On 20 Oct three attributes with no reader yet — `deadline`, `academic_entry`, `description` (state `no_reader`, 36,391 rows each) — joined the coverage matrix. A course counted as fully complete only when *every* attribute, readable or not, was admitted, so no course could be complete from that day. The headline completeness % also fell 59.4 → 57.3 for the same reason (the three joined the denominator). Identity re-verification (23–24 Oct) did not touch it.
**Fix.** Migration `20261024006000` (md5-guarded edit of `course_completeness_build_v1`): a course's `attributes` count is the attributes the platform can read; fully complete = all of them admitted. Live recount: **5,894** courses qualify today (5,660 on 19 Oct — the trend is intact). The headline completeness % keeps counting the unreadable attributes on purpose: that is the real gap the website developer sees (entry requirements is their #1). The 20–23 Oct rows stay as written (those days' matrices are gone) and the Coverage screen says why in one line above the trend table.

**PR #683 contents:** `src/lib/errors.js`; shell changes; 49 panels' `errText`; PlatformHealth/Automations scrubbing; Coverage note; migration `20261024006000_cf247_ui_audit_phase0.sql`; release notes v2.15.339/340; test s95; v2.15.341 bump; SOPs 1.82. Dry run passed; full suite SUITE_341.

---

## 2. Phase 1 — strip internals from list views (PR #686, branch `cf247-ui-audit-phase1`, v2.15.344 — stacked last so the version chain stays linear)

PHASE1_BODY

---

## 3. Phase 2 — course-list enrichment (PR #684, branch `cf247-ui-audit-phase2`, v2.15.342)

**What the audit missed.** The Courses list already carries the columns the mandate asks for — International fee (`intl_fee_amount`, currency, year), Tuition Only (CRICOS registered total, AU only), City (`city_names`) and State / Region — added 23 Oct (v2.15.330) and read from the **same path as the blade** (`security.admin_course_page_fast_base` behind `admin_read('courses_page')`). Read live on 24 Oct for the first 200 rows per country: AU 44 with an international fee, 200 with a CRICOS total, 200 with a city and state; NZ 76 fees, 93 cities, 200 states; CA 16 fees, 32 cities, 200 states. The 07:22 report "list not showing tuition fees" was a stale tab (rows loaded before the fees were admitted). What was missing: the **fee basis**, and **sorting** on the two columns (only course, provider, field, modified and verified sorted).
**Fix (migration `20261024007000`, md5-guarded edit of the list function, additive on the admin read path only).** `intl_fee_basis` joins the row; sort keys `intl_fee` and `city` sort the filtered set with one indexed lookup per course (dry run: three sorted pages in 771 ms). Screen: the International fee column shows "AUD 38,000 (2026) · per year" with the basis as the blade prints it, sorts, and renders "—" when empty; City sorts; existing filters (country, fee, freshness, state) are untouched. The CRICOS column stays AU-only (Platform Admin 23 Oct 13:24).
**Verified on samples (dry run on a branch):** NZ sorted by fee descending, AU sorted by city ascending, CA with fees sorted descending — all three return fees with basis `annual` and cities with states.
**Data-quality leak found on the way:** at least one AU campus has a street address as its city ("1 Brazier Drive, Townsville") → Phase 3 list.

---

## 4. Phase 3 — dedupe and data-quality leaks (PR #685, branch `cf247-ui-audit-phase3`, v2.15.343)

| Audit row | Finding (live, 24 Oct) | Fix | Justification |
|---|---|---|---|
| Dashboard vs Layer 4 duplicate inbox counts | both read the same RPC (`admin_layer4_inbox 'summary'`): one source, two renderings, by the 20 Oct decision "Keep, Waiting = Inbox" | the Dashboard now states the Inbox **once** — the total, how many kinds, how many are late — and opens Layer 4 Review by kind (`?view=kind`); the per-kind rows live only on Layer 4 (closes audit rows 1 and 11) | the mandate: keep the Layer 4 count, Dashboard links to it |
| Scholarship counts 2,059 vs 1,436 | 2,059 = every record including 623 retired; 1,436 = active; 1,106 = published | the Dashboard tile states "1,106 — published · 1,436 active · 623 retired", the same three figures the Scholarships screen uses; two additive keys on the dashboard read (`scholarships_active`, `scholarships_published`; migration `20261024008000`, md5-guarded; the 10-minute snapshot refreshed) | one set of numbers on both screens |
| Ranking-import UI labelled "REFERENCE DATA" inside Rankings › Datasets | the kicker text was left from the 20 Oct move | kicker reads "Rankings & statistics / Ranking imports" | closes audit row 6 |
| Header rendered twice on Provider contacts | the screen drew its own hero (kicker + h2 + blurb) under the shell's page header | the hero keeps only its action buttons; the shell header stays | closes audit row 4 |
| Archived provider named "N/A" | **19 providers**, not one: CRICOS providers whose register *trading name* is "N/A"/"NA"/"n/a" (codes 03623M, 03815C, 04152G, …), 18 active-unpublished with 137 courses between them; the legal name was never kept | screens show "Unnamed on the register (03623M)" in italics instead of the placeholder (list rows and detail titles); **data fix logged for Layer 1**: the CRICOS read must keep the legal name when the trading name is a placeholder — a register change, not a UI one | corrected where the data allows, quarantined with the reason where it does not |
| Blank course-name row | one NZQA record (Southern Institute of Technology, code 3954) titled "--" by the register; unpublished | same rendering: "Unnamed on the register (3954)" | as above |
| Address as a city (found in Phase 2) | one active campus, Townsville Grammar School – Annandale, city "1 Brazier Drive" | corrected to Townsville (count-guarded, exactly one row) | a plain data error with an obvious right value |
| Near-duplicate scholarships ("2026 ECU Sri Lanka Undergraduate Scholarship" vs "… for International Students") | two register listings with distinct pages | **not changed**: both exist on the university's site; merging them is a scholarship-ownership decision for the Platform Admin, not a display fix | refused, see section 5 |
| Truncated provider name ("…BMIHMS at To") | Torrens University Australia's register name is a 255-character multi-brand string, truncated at the register | **not changed here**: the fix is a display name ("Torrens University Australia") on the provider record — a data correction the Platform Admin sets on the Providers screen, logged | refused as a UI change; one-line data fix offered |

**PR #685 contents:** `src/Dashboard.jsx`, `src/Layer4Inbox.jsx` (`?view=kind`), `src/ProviderContactsWorkspace.jsx`, `src/mature-main.jsx` (kicker, `displayName`), migration `20261024008000_cf247_ui_audit_phase3_dedupe.sql`, test s97, dashboard contract updated, v2.15.343. Dry run passed (dashboard read carries the two new keys; the campus reads Townsville). Full suite 1,856 passed (4 known legacy failures).

---

## 5. Refused removals (audit-flagged items judged load-bearing)

| Audit row | Kept | Why |
|---|---|---|
| Providers › adapter states "Admitting", "Testing", "Auto (register rules)" | kept as plain words, not removed | they are the admission state of a university's adapter — an operator decision surface (Decision 254/255), not plumbing |
| Reference data › "Never a university website" flag | kept, reworded on the row | it is the operating rule that stops the finder taking a directory site as a university's own; removing it would hide why a site is skipped |
| Settings › page-identity proofs per country | kept | Platform Admin controls (G2); the audit itself calls this the cleanest panel |
| Provider contacts › staff names, phone, email | kept, role-gated as before (Curator+) | the panel's purpose is recruitment contacts; the audit asked to confirm gating, not to remove |
| Models & services › model identifiers | kept behind the existing "inspect" detail, removed from the list row | model routing must stay pinned to individually qualified models (CLAUDE.md); a person approving a model needs its exact identifier once, in the detail |
| Scholarships › near-duplicate ECU rows | kept | two distinct register listings with their own pages; merging is a data-ownership decision, not a display fix |
| Providers › Torrens' 255-character register name | kept | the register value is what it is; the fix is a display name set on the record by the Platform Admin (one line), not a UI rule that shortens names |
| Go-live checklist › environment internals | role-gated to Platform Admin, not removed | the cutover needs them; nobody else does |

---

## 6. Before / after evidence (extension run)

To be filled by the Platform Admin's Kimi extension run against the merged release: one row per panel changed, screenshot before (from the 11:13 audit) and after.

| Panel | Before (audit) | After (build) | Extension evidence |
|---|---|---|---|
| Go-live checklist, Users & roles, Guides | raw `canceling statement due to statement timeout` banner | no banner unless the screen itself fails; then one plain line with a reference | — |
| Layer 2/3, Platform health, Scheduled jobs | `ERROR: the link must be a full https:// web address CONTEXT: PL/pgSQL function layer4_course_link_apply_impl(...)` | "A course page address was not a secure (https) web address, so it was left for a person to check." — and the job no longer fails | — |
| All inner panels vs top bar | v2.15.340 vs v2.15.339 | a reload notice when the deployed version differs | — |
| Coverage › Progress | Fully complete 0 since 20 Oct, unexplained | 5,894 from the next nightly build; a note explains 20–24 Oct | — |
| Courses | fee / city present but unsortable, no basis | sortable, basis shown, "—" when empty | — |
| Dashboard | per-kind Inbox rows repeated from Layer 4; Scholarships 2,059 "every status" | one Inbox line with the total → Layer 4 by kind; Scholarships 1,106 published · 1,436 active · 623 retired | — |
| Provider contacts | two headers | one | — |
| Rankings › Datasets | kicker "Reference data / Ranking imports" | "Rankings & statistics / Ranking imports" | — |
| Providers › Archived, Courses | "N/A", "--" | "Unnamed on the register (code)" | — |
PHASE1_ROWS

---

## 7. Decisions (docs-and-questions rule)

| # | Decision | Why |
|---|---|---|
| U1 | Errors are sanitised in the app, not in the database functions that produce them | the raw text is still the right thing to log; only the screen changes (presentation-layer rule) |
| U2 | The error reference is random (6 characters, no vowels or lookalikes) and logged with the full detail; the log is a table, not a panel | "no new panels"; the Platform Admin reads it by SQL and it feeds the hygiene report later |
| U3 | The version-skew fix is a notice with a Reload button, never an automatic reload | a person may be mid-edit; the chunk-missing fallback already reloads when a screen cannot load at all |
| U4 | Headline completeness keeps counting attributes with no reader; only "fully complete" changes to readable attributes | the developer's gaps are real gaps; hiding them in the headline would be the dishonest fix |
| U5 | The coverage-admit fix is a behaviour change in a database function inside a "presentation-layer" mandate | Phase 0 says incidents first and root-cause; a dead job is the incident; the fix is the smallest one (the row waits for a person) and is md5-guarded |
| U6 | Phase 2 adds a basis field and two sort keys to the admin read path rather than a new RPC | the mandate: the same read path the blade uses; additive; the website API is not involved |
| U7 | Internal identifiers move behind the existing "inspect" detail (one place), never deleted from the read path | support still needs them; the list never shows them |

---

## 8. Runbook addition (one section)

**An error with a reference.** When a person reports "ref AB3K7Q", run `select at, page, message, detail from pipeline.ui_error_log where ref = 'AB3K7Q'` on the project; `detail->>'message'` is the raw error. When a screen shows "A newer version … Reload to update", the person reloads; nothing else is needed.

---

## 9. Mandate as received (24 Oct 2026, 11:27)

> Admin UI cleanup and course-list enrichment, from the 24 Oct UI audit. Phase 0 — incidents first: the global error banner (generic message + reference, root cause); the raw PL/pgSQL error on three screens; the version mismatch (investigate; a half-applied release is a deployment defect); the "fully complete" drop to 0. Phase 1 — strip internals from list views (composite IDs, GUIDs, SHA fragments, HTTP codes, model IDs, cron syntax, env var names, Supabase refs, credit balances); move support-useful items behind "inspect"; Go-live internals role-gated or removed. Phase 2 — the Courses list shows the annual international fee (basis as-is) and campus city/state from the same read path as the blade; sortable; "—" when empty; verify on AU + NZ + CA. Phase 3 — Dashboard vs Layer 4 duplicate counts; ranking-import relabel; scholarship counts reconciled on screen; "N/A" provider and blank course name; duplicated header. Constraints: presentation-layer + additive read fields; no drops, status changes, consumer API changes, new panels or SOPs; every removal justified against the audit row; UAT contracts pass; extension verifies each phase. Output: incident reports, PR list, before/after per panel, refusals.
