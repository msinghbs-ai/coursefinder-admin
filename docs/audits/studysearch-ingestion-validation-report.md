# StudySearch ingestion, storage and pre-AI enrichment: validation report

**Date:** 14 November 2026 (AEDT) · **Prepared by:** Claude, for the Platform Admin · **Status:** findings for review. No change has been made, deployed or switched on.

**Basis.** Source: Pilot `main` at `c4ffa31` (#1138), worker `coverage-sweep-worker-v0.91.0`. `main` has since moved to `aa34395` (#1140, v2.16.1 UI release); it changes nothing under `supabase/functions/coverage-sweep/`, so every code finding still holds. Open PR #1139 (Lean AI Input Phase 1b step 2, `a8591c95`) was checked for overlap only. Live data: read-only SQL against Supabase `fxcwkweaxjtknorudmwp` between 14:30 and 16:00 AEDT on 14 Nov 2026. Every figure below comes from those queries. The queries are in [`sql/admission-integrity-checks.sql`](sql/admission-integrity-checks.sql) and can be re-run in the SQL Editor. No Firecrawl call, AI call, storage write, setting change or deletion was made.

**Related designs this report builds on, not replaces:** `docs/platform/SHARED-SOURCE-TO-PUBLISHED-ENRICHMENT-DESIGN.md` §11 (F1–F8), `LEAN-AI-INPUT-PHASE0-BASELINE-2026-11-13.md`, `LEAN-AI-INPUT-PHASE1B-SECTION-SELECTION-DESIGN.md`, `LEAN-AI-INPUT-PHASE1B-RECALL-REPORT-2026-11-14.md`, `2026-11-12-aer-admission-mechanism.md`, `2026-11-12-scholarship-admission-mechanism.md` and `docs/scholarships/SCHOLARSHIP-MECHANISM.md` v3.0.

---

## 1. Executive summary

- **Storage integrity is strong.** Across 174,045 evidence records for HTML pages, there are no missing objects, no zero-byte files and no records whose stored hash disagrees with its path. Copies are content-addressed (SHA-256 in the object name), gzip-compressed and private.
- **The waste is in what reaches the AI, not in storage.** There are three measured leaks:
  - **Near-empty pages:** 623 AI calls were made on 346 near-empty scholarship copies, and not one of them produced a scholarship.
  - **Pages that are not one award:** 30% of completed scholarship AI calls in the last 14 days went to pages the model then judged "not a scholarship" or "a listing". That is 7,386 calls, US$4.63, or 20% of completed-call spend (US$23.15).
  - **Repeat reads:** about 10% of paid scholarship reads (US$2.27 in 14 days) re-read content, prompt and model combinations already answered.
- **A keyword-score scholarship gate would not fix the over-triggering.** 96% of the "not a scholarship" pages already carry an award word in their URL, and a long course page in the test fixtures scores as a scholarship page. The levers that work are deterministic page checks (thin, soft-block, soft-404, listing) and an input cache, recorded in shadow first.
- **Silent truncation is still live outside AER.** Scholarship reads cut the page at 14,000 characters and the linked page at 8,000; these limits are written in code, not settings. Course fields, description and deadline cut at 24,000 (`enrich.page_chars`), and central reads at 24,000 written in code. The AER v2 reader shows the right pattern: it holds a page that is too long instead of cutting it.
- **Firecrawl calls are poorly traced.** 99.7% of Firecrawl credits in the last 7 days (29,695 of 29,769) went through call sites that record only units and purpose. Several of those paths treat any returned HTML as "read" without checking the page's own status code.
- **Two cost-record gaps:**
  - **Lost cost on record time-outs:** when the database record times out after a paid scholarship answer, the cost is recorded as US$0 (265 rows in 14 days).
  - **Duplicate stored bytes:** the platform de-duplicates evidence *records* but not stored *bytes*. Unregistered copies hold about 400 MB in the course-page folders and 81 MB in the scholarship folder; in the AU course-page folder (last 30 days), 2,880 of 2,890 are copies of content already registered.

The proposed **Pre-AI Admission and Enrichment Gate** is in the companion design ([`studysearch-pre-ai-admission-gate-design.md`](studysearch-pre-ai-admission-gate-design.md)). It is a small, shadow-first module that reuses the worker's existing converters and checks.

---

## 2. Files inspected

| Area | Files (Pilot repo unless noted) |
|---|---|
| Firecrawl client | `supabase/functions/coverage-sweep/firecrawl.ts` (`scrapeBody`, `searchBody`, `callRecord`, `readOutcome`, `pageHtml`); 35 inline call sites in `coverage-sweep/index.ts`: 21 `/v2/scrape`, 7 `/v2/map`, 3 `/v2/search`, 3 legacy `/v1/search`, 1 generic (`fc_run`). No `/crawl`, batch scrape or JSON-format (`{type:"json", schema}`) extraction is in use. |
| Fetch helpers | `index.ts` `readDirect`, `readSch`, `readSchPage`, `fcMap`, `useFcWhy` (budget check), the `robots.txt` cache |
| Storage writers | `index.ts`: every `c.storage.from("evidence" \| "provider-assets" \| "adapter-captures").upload(...)` call. Database side: `public.svc_coverage_read_record` (live md5 `ebbdc4e45af01c473fd5b681d2237011`) → `public.svc_coursefacts_register_evidence` → `pipeline.evidence_artifacts` |
| Converters and section readers | `lean-input.ts` (lean-md-v1, preflight, observation), `lean-sections.ts` (lean-sections-v1), `aer-v2.ts` (`aerV3Blocks`: lean-blocks-v1 `[B#]` contract, `aerV3Verify`), `extract.ts` (`htmlToText`, `pageDataItems`), `course-text.ts`, `course-entry.ts` |
| Domain readers | `scholarship.ts` (`mainText`, `isListingPage`, `admissionCheck`, `currentlyOffered`), `sch-extract.ts` (sch-extract-v3, `directReadUsable`, `awardSection`), `fees.ts` (`hasFeeAmount`), `answer.ts` (`readAnswer`, `errorCost`) |
| Worker modes traced | `read`, `scholarship_read`, `scholarship_ai`, `enrich_ai`, `entry_ai`, `central_ai`, `fee_ai`, `aer_v2_shadow`, `lean_sections_eval`, `fc_run` |
| Live tables | `storage.buckets`, `storage.objects`, `pipeline.evidence_artifacts`, `pipeline.firecrawl_calls`, `pipeline.coverage_vendor_usage`, `pipeline.scholarship_ai_extractions`, `pipeline.scholarship_ai_queue`, `pipeline.field_enrich_items`, `pipeline.enrich_ai_answers`, `pipeline.ai_input_observations`, `pipeline.ai_invocations`, `pipeline.platform_toolset_settings` |

---

## 3. Format parity matrix

What is asked for, what is kept and what the reader is given, per acquisition path.

| Path (worker mode) | Firecrawl formats requested | `onlyMainContent` | Stored artifact (bucket `evidence`) | Postgres record | Reader input to the AI |
|---|---|---|---|---|---|
| Course page read (`read`) | Direct fetch first. Firecrawl `["rawHtml"]` only as fallback, priority re-render or the international view | `false` | Raw HTML, gzip: `layer2/<AU\|NZ\|CA>/coverage/<provider>/<course>/<sha256>.html.gz` | `evidence_artifacts` `source_snapshot`, `mime_type text/html`, `metadata.gzip true`, `text_sha`, `identity_basis`, `fetched_via`; `coverage_course_pages` | **Fields:** page data + `mainText`, cut at 24,000 (`enrich.page_chars`). **Description and deadline:** `descriptionPageText`, cut at 24,000. **Entry:** `htmlToText` whole, read in slices (12,000 × up to 10), held when too long. **AER v2 shadow:** lean-blocks-v1, held over 60,000 |
| Scholarship page (`scholarship_read`, `scholarship_ai`) | Direct first (`directReadUsable`), else Firecrawl `["rawHtml"]`, `waitFor` 1.5 s | `false` | Raw HTML, gzip: `layer2/AU/scholarships/<provider>/<scholarship\|candidates\|ai/<queue>>/<sha256>.html.gz` (**always AU**, §4.4) | `evidence_artifacts` `scholarship_page` / `_candidate_page` / `_ai_page`, `mime_type application/gzip`; `scholarship_ai_extractions.evidence_id` | `mainText`, cut at **14,000** + linked eligibility page cut at **8,000**, both written in code. Recovery items: award section (6,000) + linked (4,000), from settings |
| Entry matrix source (`entry_ai`) | Rendered hosts: `["rawHtml"]`, `waitFor` from settings. Blocked HTML: `["rawHtml"]`. Blocked PDF: `["markdown"]` | `false` (via `scrapeBody`) | HTML, PDF or Markdown, gzip: `layer2/<CC>/entry-matrix/<provider>/<source>/<sha256>.<html\|pdf\|md>.gz` | Entry-matrix source record (`p_mime` text/html, application/pdf or text/markdown) | Table-row / PDF-cell / grid readers. Markdown has no cell geometry, so the PDF grid readers do not apply |
| Provider home page (`enrich_ai`, address) | `["markdown"]` | `false` | Markdown, gzip: `layer2/<CC>/enrich/<provider>/<sha256>.md.gz` | `enrich_home_page` | Markdown text |
| Provider description (`provider_description`) | `["rawHtml"]` (via `scrapeBody`) | `false` | HTML, gzip: `layer2/<CC>/provider-description/…` | Provider description reads | Source-grounded spans of the stored page |
| Provider facts (`provider_facts`) | `["markdown"]` | **`true`** | Markdown, gzip | `admin_job_items` | Markdown text |
| Site / register discovery (`find_site`, `cricos_peo`) | `["links","markdown"]`, `["markdown"]` | `true` / `false` | — (discovery output) | Candidate tables | Not an AI input (rules) |
| Central policy pages (`central_ai`) | (stored copy) | — | Stored central page text | `central_ai_queue` | `md.slice(0, 24000)`: **24,000 written in code**, no setting |
| Adapters / probes (`fc_run`, `adapter_capture`) | From settings: `rawHtml`, `html` or `markdown`; one capture path adds `{type:"screenshot", fullPage:true}` | `false` | `layer2/<CC>/firecrawl/...`, `layer2/<CC>/adapters/...`; PNG in bucket `adapter-captures` | **`firecrawl_calls`**: full request, HTTP, page status, scrape id, credits, outcome (`readOutcome`) | Adapter readers |

**What the matrix shows:**

1. **No double fetching found.** No path asks Firecrawl for the same URL twice in two formats. Every course and scholarship page is fetched once, direct read first, with Firecrawl only as fallback.
2. **Raw HTML is archived wherever a table-aware reader needs it.** The course, scholarship and entry-matrix paths all keep `rawHtml`, which is what lean-md-v1 and the table-row readers need. Markdown-only paths (provider facts, provider home, blocked PDFs) are discovery or narrative sources; they cannot feed a table-aware or cell-geometry reader. This matches §11 F1 option A: derive Markdown locally from stored HTML rather than paying Firecrawl for a second format.
3. **`onlyMainContent: true` is used in only two places:** register-site discovery (`find_site`) and provider facts. Neither is an AER, fee or scholarship read, so footnotes and side panels are not lost from that evidence.
4. **Firecrawl's JSON extraction (`fcx_`, 5 credits) is budgeted in code but unused.** No `{type:"json"}` format is requested anywhere.

---

## 4. Storage and integrity audit

### 4.1 Buckets

| Bucket | Objects | Size limit | Allowed MIME types | Note |
|---|---|---|---|---|
| `evidence` | 231,216 | 50 MB | png, csv, plain, html, jpeg, zip, json, pdf, xlsx, gzip | Allow-list in place |
| `adapter-captures` | 4,637 | **none** | **any** | No limit or allow-list (§4.6) |
| `provider-assets` | 2,029 | 5 MB | svg, png, jpeg, webp | Allow-list in place |
| `archive` | 119 | none | any | Export archive |

All four buckets are private.

### 4.2 Integrity of current evidence (query S3)

| Evidence type | Records | Missing object | Zero bytes | Path hash ≠ recorded hash |
|---|---|---|---|---|
| `source_snapshot` (HTML, gzip) | 140,713 | 0 | 0 | 0 |
| `scholarship_ai_page` | 15,074 | 0 | 0 | 0 |
| `scholarship_candidate_page` | 8,657 | 0 | 0 | 0 |
| `scholarship_page` | 6,719 | 0 | 0 | 0 |
| `source_snapshot` (Markdown, gzip) | 2,202 | 0 | 0 | 0 |
| other HTML/JSON/PDF snapshots | 680 | 0 | 0 | 0 |

There are also no zero-byte objects anywhere under the current worker folders (query S2).

### 4.3 Idempotency and de-duplication: how it works today

- **Object names are content-addressed.** The worker hashes the decoded page (`sha256(TextEncoder(html))`), gzips the same bytes and writes `<…>/<sha256>.html.gz` with `upsert: true`. Re-reading an unchanged page into the same folder rewrites the same object; it never creates a second one.
- **Unchanged course pages are not re-stored at all.** When the page text hash matches the course's current copy (`svc_coverage_text_sha`), no new object is written and the copy in use is kept.
- **Evidence records are de-duplicated.** `svc_coverage_read_record` reuses an existing `evidence_artifacts` row for the same source, content hash and URL.

**Gap: stored bytes are not de-duplicated across folders.** The object path includes the course id (coverage) or the queue id (scholarship AI). The same content reached from another course or another queue item is stored again, and the database then reuses the first record, so the new object has no record pointing at it.

| Measure | Result |
|---|---|
| AU course-page copies with no evidence record (written 21 Oct to 13 Nov) | 2,890, of which **2,880** have content already registered under another path (query S5) |
| Course-page copies with no evidence record, all countries | AU 2,890 · NZ 2,289 · CA 1,808 (≈ 398 MB) (query S4) |
| `scholarship_ai_page` records duplicating content and URL | 3,808 of 15,074 (25%) (query S7) |
| Scholarship copies with no evidence record | 2,102 (81 MB) |

This costs storage, not correctness: no evidence is lost and no reader loses its proof. The fix is a content-addressed path, such as `layer2/<CC>/pages/<sha256>.html.gz`, with the owner kept in the record. It should be done after the 14-day retention rule has been checked against it (Decision 260).

Copies under `layer2/<CC>/firecrawl/`, `adapters/` and `companion/` have no `evidence_artifacts` row **by design**; their own tables reference them. They are not orphans, although their own references were not audited here.

### 4.4 Naming drift: every scholarship copy is filed under AU

`scholarship_read` and `scholarship_ai` write to `layer2/AU/scholarships/…` whatever the provider's country. Live objects under that prefix belong to providers of **three different countries** (21,583 / 6,471 / 3,485 objects, query S6). The harness sample shows Acadia University (Canada) award pages under `layer2/AU/`. Anything that reports or retains by country prefix is wrong for NZ and CA scholarships. Correcting the prefix for new copies is a one-line change, but retention and report readers must be checked first.

### 4.5 MIME types: two conventions in one column

`evidence_artifacts.mime_type` holds the **content** type for course pages (`text/html`, with `metadata.gzip = true`) but the **container** type for scholarship pages (`application/gzip`). Fourteen PDFs are recorded as `application/pdf` but stored gzipped. Nothing is broken today, because each reader knows its own convention. A shared admission gate needs one rule, so the manifest in the design keeps both fields: `content_mime` and `container`.

### 4.6 Other storage observations

- `adapter-captures` has no size limit or MIME allow-list. A cheap hardening step is to allow `image/png`, `image/webp` and `image/jpeg` at a sensible cap.
- **The page's own HTTP status is not kept in the evidence record.** No `evidence_artifacts.metadata` key holds it. `coverage_course_pages.http_status` holds the transport status of the last read only.

### 4.7 Re-runnable integrity queries

These are in [`sql/admission-integrity-checks.sql`](sql/admission-integrity-checks.sql): S1 buckets · S2 prefix/MIME/zero-byte · S3 missing objects, empty objects, path-hash disagreement and MIME semantics · S4 unregistered objects by prefix · S5 duplicate-content copies · S6 country under the AU prefix · S7 duplicate records · A1–A5 admission and spend · H1 the harness sample. All read-only; all ran inside the default time limit on 14 Nov.

---

## 5. Reader and enrichment trace

### 5.1 How a page becomes an AI input

```
Firecrawl / direct fetch ──► raw HTML (string)
   │  readOutcome-style checks: only in fc_run. Other paths: transport status + "has html" + text-length floors (300 / 1,500)
   ▼
sha256(html) ─► gzip ─► storage.objects  layer2/<CC>/<lane>/…/<sha256>.html.gz      (content-addressed, upsert)
   │
   ▼
svc_*_record ─► pipeline.evidence_artifacts (source, url, hash, path, type, metadata)   (record de-dup: source + hash + url)
   │
   ▼  (later, a queued read: svc_enrich_ai_next / svc_scholarship_ai_next / svc_aer_v2_shadow_next)
download ─► gunzip ─► one of four text forms:
   a) htmlToText / mainText         (scripts, styles, nav, header, footer removed; tables flattened)   course fields, description, scholarship
   b) pageDataItems + htmlToText    ("Label: value" page data first)                                    entry requirements, course fields
   c) leanText (lean-md-v1)          (headings, list items, table rows "Header: cell", offsets kept)    shadow observation, AER v2
   d) aerV3Blocks (lean-blocks-v1)   ("[B<n> @<offset>] …" per block)                                  AER v2 (v3 contract), lean-sections eval
   ▼
bound: cut (fields 24k, description 24k, scholarship 14k + 8k, central 24k)  |  slice (entry 12k × 10)  |  hold (AER v2 > 60k)
   ▼
OpenRouter: pinned model, response_format json_schema strict, provider.require_parameters true, answer limit from settings
   ▼
verifier: every quote checked against the text sent (flat form, letters and digits); AER v3: exact_block + lead_in_block within 3 blocks
   ▼
record (cost on failure too, W32) ─► admission rule in SQL ─► Layer 4 or publish
```

**What already works well:**

- **No raw HTML or JSON reaches a prompt.** Every AI input goes through one of the four converters. JSON-LD and scripts are removed, and page instructions are treated as data.
- **Exact-quote preservation is built in.** Every reader rejects a value whose quote is not in the text it was sent. AER v3 adds ordered proximity (the lead-in must sit within `reading.aer_v3_lead_in_max_blocks` blocks of the quote) and every block keeps its offset in the stored copy. This meets §11 F2's requirement to preserve exact spans and offsets.
- **Model routing is pinned.** A response from a different model is refused (`returned model … not …`).
- **Entry requirements are read whole or held.** The entry reader slices a long page and holds it if it cannot read every slice, and the AER v2 reader holds a page over 60,000 characters. Neither cuts a page silently.

### 5.2 Admission gates that exist today

| Gate | Where | Kind | Effect |
|---|---|---|---|
| Robots.txt | `readDirect`, course `read` | Hard | Not fetched |
| Firecrawl budget, target list, scholarship share, credit reserve | `useFcWhy`, `svc_fc_spend` | Hard, named refusals | Not fetched; reason recorded |
| Direct read usable | `directReadUsable` (800 characters, or 300 with award and eligibility words) | Hard | Falls back to Firecrawl |
| Thin course page | `read`: under 1,500 characters → `needs_render` | Hard | Re-render or wait |
| Identity | `identity(…)`, adapters; stale calendar pages | Hard | `identity_mismatch`; not used |
| Scholarship name on page | `nameOnPage`, discovered pages must mention an award word | Hard (in `scholarship_read` only) | `name_mismatch` |
| Fee amount present | `fee_ai`: `hasFeeAmount` | **Hard pre-AI gate** | Recorded `skipped: no_amount`, **cost 0** |
| Entry page too long | `courseEntryPlan` / AER v2 `page_too_long` | Hard, held | No AI call; held with reason |
| Preflight (likely / unknown / no_signal) | `lean-input.ts` | **Shadow only** | Recorded, never used to skip |
| Section selection | `lean-sections.ts` | **Shadow / evaluation** | Measured offline (2,800 cases) |
| Answer verification | every reader | Hard, post-AI | Unproven values dropped |

The fee reader's `hasFeeAmount` is the proven template for a domain pre-AI gate: deterministic, cheap, recorded with a reason, and never spending.

### 5.3 Root causes

| # | Finding | Evidence | Root cause | Size |
|---|---|---|---|---|
| R1 | **Scholarship AI reads near-empty pages** | 346 stored scholarship copies under 600 compressed bytes received **623 AI calls** (US$0.137); every outcome was `not_scholarship` or an error (query A2) | `scholarship_ai` sends any non-empty HTML. The live path accepts `too_thin` pages from Firecrawl, and the stored-copy path applies no length, soft-block or soft-404 check. The `readOutcome` checks in `firecrawl.ts` are used only by `fc_run` | Small in dollars; proves the leak class |
| R2 | **Over-triggering on pages that are not single awards** | 14 days: `not_scholarship` 6,339 calls (US$3.04) + `listing` 1,047 (US$1.59) = **30% of completed calls, 20% of completed spend** (query A1). Overnight 13–14 Nov the share reached 40–58% of calls per hour | Discovery candidates are read by AI to decide what they are. `isListingPage` exists but is not applied before the AI read. **96%** of `not_scholarship` URLs carry an award word, so a URL/keyword score cannot separate them | US$4.63 / 14 days; the largest avoidable share |
| R3 | **Repeat reads of identical input** | Paid reads repeating the same stored content, prompt version and model: US$1.92 (`admit`) + US$0.35 (`reread`) in 14 days, ≈ 10% (query A3) | No answer cache keyed by content hash + prompt + model + schema (§11 F4). Some repeats are deliberate (a changed linked page or a recovery variant); the gate records which | ≈ US$2.27 / 14 days |
| R4 | **Silent truncation still live** | Scholarship `mainText(html).slice(0, 14000)` and linked `slice(0, 8000)`; central `md.slice(0, 24000)`; course fields, description and deadline cut at `enrich.page_chars` 24,000 | The 14,000, 8,000 and 24,000 (central) limits are **written in code without a setting or a `fixed:` mark**, a G2 gap the s32 guard does not catch because s32 checks migrations, not worker code. The recall report found 85 labelled values beyond the 24,000 cut | Recall, not spend |
| R5 | **Paid answers recorded at US$0** | 265 rows `svc_scholarship_ai_record: canceling statement due to statement timeout` (query A4) | When the success record times out, the catch records the error with `errorCost(e)`, which is 0 for a database error, although the call was paid. The answer is also lost, so the page is read and paid for again | Cost accuracy (F6) |
| R6 | **Answer-limit waste** | 847 `output_truncated` (US$1.36), 439 `no choices`, 246 refusals ("I'm sorry…") | Cut answers are already held and costed (W32); sectioned recovery exists. Refusals and empty answers carry no cost | Watch only |
| R7 | **Firecrawl calls poorly traced; page status ignored on some paths** | 7 days: `firecrawl_calls` 74 calls / 74 credits vs `coverage_vendor_usage` 21,768 rows / 29,695 credits. Course `read` fallback, view render and `entry_ai` render accept `pageHtml(d)` when the API call is OK, without checking `data.metadata.statusCode` | Two Firecrawl clients: the governed one (`firecrawl.ts`, with `callRecord` and `readOutcome`) and about 30 inline call sites. The identity check will usually stop a bad course page later (an error page rarely carries the course's code or title), but a rendered 404 or 5xx page can still be stored as "read" | Traceability; small correctness risk |
| R8 | **Input size inflation in the block contract** | Real fixture `rmit-stored/foundation-equivalencies.html`: AER lane sent 19,329 characters from 6,541 of main text | `[B<n> @<offset>]` labels plus `Header: cell` repetition on table-heavy pages. These are deliberate (proximity and offsets) but are paid input | Measure before changing |
| R9 | **Lean AI Phase 1 has no observations yet** | `ai_input_observations` = 0 rows. The switch was turned on at 00:37 UTC 14 Nov, but the last enrichment answer was at 22:55 UTC 13 Nov (query A5) | **Not a defect:** the enrichment lane has not run since the switch was turned on. The Phase 1 cut and false-negative measurement waits for the lane to resume | Blocks Phase 1 acceptance |

**What was not found:**

- no raw HTML, JSON-LD, base64 or `data:` URI in any traced prompt builder;
- no unbounded context (every read has a cut, a slice plan or a hold);
- no auto-routing across different models;
- no AI call made without its cost being kept, apart from R5;
- no Firecrawl JSON-format spend.

---

## 6. What this means for the gate design

1. **Measure before suppressing.** The 12 Nov design and the Phase 0 baseline both require it, and the data agrees. The scholarship over-triggering (R2) is real but cannot be cut by keywords. Thin, soft-block and soft-404 pages, listings and repeats are deterministic and safe to gate *once their false-negative rate is shown to be zero*.
2. **Reuse, do not duplicate.** The gate must use lean-md-v1, lean-blocks-v1 and lean-sections, not a new sectioner. That keeps one block contract for AER v2, Lean AI and admission (the Phase 1b design rule).
3. **Hold, never cut.** Any budget overflow must park with a reason (F5), following the AER v2 pattern.
4. **Record every rejection.** Today only the fee reader records a pre-AI skip with a reason. Every lane needs the same.

---

## 7. Recommendations

Each item is a separate change, approved separately. Nothing is switched on by this report.

| # | Recommendation | Fixes | Effort | Dependency |
|---|---|---|---|---|
| 1 | Ship the pre-AI admission gate **in shadow** on the scholarship AI lane, then the enrichment and AER v2 lanes (design §4) | R1, R2, R3 (measurement) | Small: one pure module, one table, one insert, settings | After #1139 merges; one import-line conflict to resolve |
| 2 | Keep the cost of a paid scholarship answer when its record fails (`errorCost(e) \|\| spent`) | R5 | Trivial | Included in the proposal patch |
| 3 | Move the scholarship 14,000 / 8,000 and central 24,000 limits to settings, and hold instead of cut, as AER v2 does | R4, G2 | Small | Platform Admin approval of new settings |
| 4 | One Firecrawl client: route the inline scrape and map calls through `firecrawl.ts` (`callRecord`, `readOutcome`, page status) | R7 | Medium (about 30 call sites) | Stage by lane |
| 5 | Content-addressed object paths, with owner links in the record only | §4.3 duplicate bytes | Medium | Retention (Decision 260) review first |
| 6 | Correct the country prefix for new scholarship copies | §4.4 | Trivial | Check retention and report readers first |
| 7 | Add a size limit and MIME allow-list to `adapter-captures` | §4.6 | Trivial | — |
| 8 | Record the page's own status in `evidence_artifacts.metadata` | R7, manifest contract | Small | With item 4 |

---

## Sources

All internal. Pilot repo `msinghbs-ai/coursefinder-pilot` at `c4ffa31`. Admin repo `msinghbs-ai/coursefinder-admin` at `93886de` (documents cited above). Supabase project `fxcwkweaxjtknorudmwp` (read-only queries, 14 Nov 2026).
