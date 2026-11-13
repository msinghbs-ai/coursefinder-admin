# Lean AI Input — Phase 0 measured baseline (13 November 2026)

**Mandate:** Platform Admin 13 Nov 2026 22:51 AEDT, "StudySearch — Lean AI Input and Evidence Optimisation" (selected options C→A, A, A, selective A, readable WebP, conditional PNG conversion; mandatory improvements 1–8).
**Design:** [SHARED-SOURCE-TO-PUBLISHED-ENRICHMENT-DESIGN.md §11](SHARED-SOURCE-TO-PUBLISHED-ENRICHMENT-DESIGN.md#11-lean-ai-input-and-evidence-snapshots--design-recommendations-13-november-2026-pending-platform-admin-sign-off).
**Tracked under:** F-OPS.08 (Models & Services v2.16.0 workstream), Pilot draft #1128 stays the one AI backend; Lean AI Input builds beside it, never a second ledger, dashboard or settings editor.
**Method:** read-only SQL against Pilot `fxcwkweaxjtknorudmwp` (22:30–23:20 AEDT), worker source at Pilot `main` `ddad217d`, #1128 head `3eb2ade3`. No Firecrawl call, AI call, setting change or deletion was made.

## 1. Headline findings

| # | Finding | Evidence | What it means |
|---|---|---|---|
| 1 | **The 775 KB `extraction-input.json` files are not an AI cost.** | 11,617 files under `layer2/v2/normalized` and `layer2/v2/discovery`, last written 1 Oct 2026; no current worker or migration reads or writes `extraction-input.json` | They are retired Layer 3 staging copies (Layer 3 retired 12 Oct). Storage-housekeeping item only (step 9 review), not an AI-input leak. |
| 2 | **Actual AI requests are bounded in code, not page-sized.** | Every OpenRouter call site cuts its input: course text 24,000 chars (`enrich.page_chars`), entry slices 12,000 chars × up to 10, intake calendar 24,000, central reads 14,000 | Typical request is a few thousand tokens (scholarship lane, the only lane with recorded tokens: 43,699 calls, p50 1,780 / p95 4,132 / p99 5,181 / max 7,756 input tokens, avg 450 output). |
| 3 | **The bound is silent truncation.** | `descriptionPageText()` = `htmlToText(main…).slice(0, pageChars)`; the cut is not recorded | A fact after character 24,000 is never seen, and the miss is recorded as "the page does not state it". This is a possible false-negative path (mandatory improvement 4) and breaks F5 ("split/park with reason, not truncate"). Size of the effect is **not yet measurable** — the cut is not logged (Phase 1 records it). |
| 4 | **Tables are flattened.** | `htmlToText()` turns `</td>`/`</th>` into line breaks; header-to-cell association is lost | Fee, intake and entry tables reach the model as loose words (mandatory improvement 3). |
| 5 | **Most enrichment spend is on items that end without a value.** | `enrich_fields` lane, last 14 days: 52,354 calls, **US$81.04** (79% of all AI spend, US$103.0) | See §2. |
| 6 | **The same page is sent twice when it has both a description and a deadline item.** | 5,974 pages in 14 days had paid description **and** deadline items; each has its own call over the same 24,000-char page | One-pass multi-field reading (mandatory improvement 2) is a measured saving — but the description prompt `cdesc-source-grounded-v1` is pinned, so merging calls needs requalification (Phase 2). |
| 7 | **Repeat reads come from prompt-version supersession.** | description items "superseded … read again with cdesc-source-grounded-v1": 1,363 items, US$1.58; "reread: v0.72.0 mapping": 733 items, US$1.12 | Legitimate re-reads, but a content/section/prompt/model/schema fingerprint (mandatory improvement 5) is needed to prove which re-reads changed input. |
| 8 | **Token usage is not recorded for the main lane.** | Only `scholarship_ai_extractions` keeps `tokens_in/out`; `field_enrich_items`, `central_ai_queue`, `fee_reader_queue`, `entry_matrix_runs` keep cost only | #1128 adds `pipeline.ai_invocations` (model, attempt, tokens, cost per call). Lean AI Input adds the **input side** (bytes, source text length, cut, hash, preflight) beside it, keyed to the same item. |
| 9 | **Firecrawl: a screenshot added no credits.** | `pipeline.firecrawl_calls`: `["rawHtml", screenshot fullPage]` = 1 credit on 4,670 of 4,689 calls (others 4–11 credits, multi-page/PDF); `["rawHtml"]` = 1 credit on 15,686 | Measured, not assumed. `rawHtml + markdown` together has **no recorded call yet**; Firecrawl documents scrape as 1 credit/page for markdown, HTML or both. Not needed for existing evidence (local conversion, option A); one bounded probe before any new acquisition path asks for both. |

## 2. Where the enrichment money went (14 days to 13 Nov 2026 23:00 AEDT)

| Field | Ended with a value (`filled`) | Ended without (`skipped`) | Held for a person (`review`) | Spend on items with no value | Cost per filled item |
|---|---|---|---|---|---|
| Entry requirements | 8,876 · US$19.20 | 3,064 · US$9.57 | 2,433 · US$7.78 | 26% | US$0.0041 |
| Description | 5,240 · US$7.80 | 10,637 · US$14.99 | 587 · US$0.88 | 63% | US$0.0045 |
| Deadline | 795 · US$1.03 | 10,482 · US$14.86 | — | **94%** | **US$0.0200** |
| Intakes | 210 · US$0.19 | 3,257 · US$2.61 | — | 93% | US$0.0133 |
| English | 29 · US$0.02 | 2,804 · US$2.39 | — | 99% | US$0.0830 |

"Filled" is the reader's state, not canonical admission; cost per **retained canonical value** is the acceptance measure and needs the Phase 1 link (§4).

Top "no value" reasons by spend: deadline "the page does not state it" 4,844 items US$6.27; deadline "date not in quote" 2,044 US$3.28; English "page does not state it" 2,632 US$2.12; description held for copying 1,188 US$1.93; deadline "rolling" 1,259 US$1.86; intakes "page does not state it" 2,340 US$1.56; entry "page does not state it" 1,977 US$1.47.

Daily enrichment spend: US$1.3–1.8 a day (4–9 Nov) rose to US$6.9 (10 Nov), US$16.0 (11 Nov), US$30.1 (13 Nov, to 08:00 UTC). The central model was changed to `qwen/qwen3-30b-a3b-instruct-2507` at 08:09 UTC with reason "too much usage"; no enrichment AI call has been recorded since.

## 3. What this changes in the plan

- **Not a 775 KB payload problem.** The saving is in (a) not paying for pages that cannot answer, (b) not sending a page twice, (c) not re-reading unchanged input, and (d) sending the relevant section in full instead of the first 24,000 characters.
- **The preflight must stay shadow-only until measured.** "Page does not state it" spend is large, but the same cut-at-24,000 that makes those misses cheap to skip may also be causing some of them. Skipping before the cut is measured would hide false negatives.
- **Model qualification (MiMo-V2.6-Flash, Mistral Small 4) waits for #1128's service routes** and runs per service with real structured-output and quote-validation tests; nothing is activated by a pass.

## 4. Phase 1 (this release) — observe first, change nothing that admits

1. **Structured text converter** `lean-md-v1` (worker module `lean-input.ts`): headings kept as headings, tables kept as rows with their header names (`Header: value | Header: value`), each block with its offset in the text; deterministic, versioned, local — no vendor.
2. **Per-call input observation** for the enrichment reads (course fields, description, deadline, entry): service, field, item, source evidence hash, prompt version, model, characters of source text, characters sent, **whether and where the text was cut**, sent-input SHA-256, structured-text size, high-recall preflight verdict (`likely` / `unknown` / `no_signal`), and the content/prompt/model/schema fingerprint. Written beside #1128's `ai_invocations`, never into it.
3. **High-recall preflight in shadow:** recorded, never used to skip. Its false-negative rate is measured against the reader's own outcome before any suppression is proposed.
4. **No change** to prompts, models, admission rules, budgets, credit floor, Firecrawl acquisition or the consumer API.

Acceptance for Phase 1: observations recorded for real reads after deployment; cut rate and preflight false-negative rate reported per field from production data; zero change in admitted values attributable to the release.

## 5. Platform Admin decision — controlled Phase 1 rolled-back rehearsal (13 November 2026)

**Decision: A, approved in scope.** Platform Admin authorises the S2/Lean AI Input engineer to run a **transaction-scoped, explicitly rolled-back production-parity rehearsal** of Pilot **#1131**, migration `20261113400000_cf247_lean_ai_input_observations.sql`, using the actual permission prompt where the Supabase connector requires it. This is *test authority*, not authorisation for uncontrolled SQL, permanent production mutation, deployment, new paid OpenRouter reads, Firecrawl, admission changes, enabled preflight or consumer API changes. Permission via a connector's Supabase approval prompt must still be explicitly granted through that interface; this document cannot respond to the prompt.

**Approved test shape:** use the exact reviewed migration on the current final PR head, one explicit transaction BEGIN → migration → check new table/settings/ACL/functions, bounded insert/report/purge and idempotence → ROLLBACK; verify no residual objects, row count/settings differences or external side effects. Ensure the observation writer cannot alter `field_enrich_items`, model inputs, classifications, budget, admission or normal workers; keep preflight `no_signal` strictly shadow. Treat any nontransactional/external side effect as out of scope and obtain an appropriate route before executing. A failure is diagnosed, not an excuse to bypass the gate.

**Release remains conditional:** finish outstanding **#1131** CI checks on its final head and reconcile shared worker version and migration order with **#1128** (Models & Services), which is not independently production-approved. One Integration Controller owns the qualified merge/deploy. After deployment independently verify function checksum and settings, confirm observation is emitted only on actual permitted AI reads, and measure cut and false-negative rates without starting a new paid run solely for instrumentation. Two unattended runs count only when the existing scheduled lane can legitimately operate and net canonical/consumer outputs remain unchanged. The Phase 0 finding that 775 KB retired JSON is not an OpenRouter payload is **closed**; the silent 24,000-character cut and duplicated description/deadline calls remain **unresolved** and require their own regression-proved optimisation.

**Quality qualification:** a shadow preflight returning no_signal and no filled values is not sufficient evidence that suppression is safe, because the existing 24,000-character cut may produce false-negative outputs. Compare against full original evidence and independent positive/negative labelled cases before authorising any F3 skip. No automatic skip in this release. Preserve actual role/grant and migration-lock tests, including concurrent writers, retention, observability failures and rollback.

## 6. Rehearsal and reconciliation status (13 November 2026, 23:59 AEDT)

- **Rehearsal not yet run.** On 13 Nov 2026 the Supabase connector asked for approval twice: at about 23:25 for the first draft, and at 23:50 for the exact migration plus checks after Decision A. Neither prompt was answered within the connector's 120-second limit, so nothing executed. A baseline read just before the second attempt showed `pipeline.ai_input_observations`, `svc_ai_input_observe_v1`, `ai_input_observation_report_v1` and the three `reading.input_observ*` settings **absent**, with 1,417 settings rows and 231,948 `field_enrich_items` rows (last updated 12:34 UTC). The gate was not bypassed.
- **Prepared rehearsal (final head):**
  1. `BEGIN`.
  2. The exact migration `20261113400000`, md5 `df7a7055cfc8ab2940ab74eaf49614d8`.
  3. The same file again, as an idempotence check.
  4. Checks:
     - columns, indexes, RLS and purpose comment;
     - security-definer status and ACLs (anon/authenticated denied, service_role allowed);
     - setting values, ranges and `used_by`;
     - the writer: bad preflight value stored as null, bad UUID stored as null, an empty row skipped, `[]` and non-array input;
     - bounded purge of an expired row;
     - report output;
     - function-definition md5s;
     - unchanged settings count and `field_enrich_items` count and last update.
  5. A forced exception (`REHEARSAL_RESULT …`) aborts the transaction, so nothing can commit.
  6. A separate read confirms that no objects or rows remain.
  - Not covered by one transaction: **concurrent writers**. These stay with the CI database fixtures and the post-deploy check.
- **Reconciliation with #1128:**
  - #1128 now uses worker v0.85.0 and v0.86.0, so #1131 is renumbered **v0.87.0**. It is rebased on main `cba5f8f1` (Pilot head `c60a316b`). Whichever PR merges second rebases on the single `WORKER` line.
  - Migration order: #1128 uses `20261113377000`–`20261113390000`; #1131 uses `20261113400000`. They touch different objects, and neither depends on the other.
- **CI:** all 12 checks passed on the previous head `f8590558`. CI is re-running on `c60a316b` (only the version renumber changed).
- **Not merged, not deployed.** Merge and deploy wait for the rehearsal result and green CI on the final head, under the Integration Controller.
- **F3 skip qualification (Platform Admin, 13 Nov):** no automatic skip. Before any F3 skip is proposed, the false-negative check must use the **full original evidence** and **independently labelled** positive and negative cases, not the reader's own outcomes on 24,000-character-cut text.
