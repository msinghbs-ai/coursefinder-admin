# Lean AI Input — Phase 1b: source-aware section selection (design, 14 November 2026)

**Status:** design for review. Nothing here is built, activated or approved.
**Mandate:** Platform Admin 13 Nov 2026 22:51 and 14 Nov 2026 10:42 ("continue Phase 1b … preserving complete relevant evidence, table structure, source references and independent negative-case validation; do not automatically skip source pages based on truncated 24,000-character inputs").
**Depends on:** Phase 1 (Pilot #1131: `lean-input.ts` `lean-md-v1`, input observations) merged and verified.
**Tracked under:** F-OPS.08 (Models & Services v2.16.0); one AI backend (#1128 routes); existing evidence inspector and Data Delivery screens only.

## 1. Problem

Course text, deadline and course-fields reads send the **first 24,000 characters** of a page (`enrich.page_chars`). Anything after that is never read, and the miss is recorded as "the page does not state it". Tables reach the model flattened, without their column headers.

Phase 1 measures how often this happens. Phase 1b removes the cut **without losing recall**.

## 2. Rule

Every read sends **all of the page that could hold the field, complete and in page order, with its structure and source offsets**, and nothing that cannot. Text is never cut:

- If the relevant text is longer than one request, it is **split into ordered parts**, each a complete set of whole sections.
- If it exceeds the service's part limit, it is **held for a person in Layer 4** with the reason "relevant text too long to read".

A page with **no selected section is sent in full**, in parts if needed, exactly as an unknown page is today. Phase 1b never skips a page.

## 3. Selection (deterministic, local, versioned `lean-sections-v1`)

Input: the stored page as `lean-md-v1` blocks (headings, paragraphs, list items, table rows with column headers; each block with `source_at`, its offset in the stored page).

1. **Anchors per field** come from the Phase 1 high-recall signal lists, widened with headings seen in adapter configurations. Examples: Fees, Key dates, Entry requirements, English language, Intakes, How to apply. Matching is on headings and on block text. A weak signal still selects.
2. **Section, not sentence.** A matching block selects its whole section: everything from its heading to the next heading of the same or higher level.
3. **Tables whole.** If any row matches, the whole table is sent, with its header row, caption and the heading above it.
4. **Context kept.** The section's heading path (for example "International students › Fees › 2027") is sent with it. So are the block before and after when they are short notes (asterisks, "per year", "indicative"), so that units, periods and the student group are never lost.
5. **Page data first.** `__NEXT_DATA__`-style page data that names the field is always included (it is already sent today).
6. **Offsets kept.** Each sent block carries `[§n @source_at]`, so a quote maps back to its exact place in the stored page. Values keep `storage_path` plus a source range as evidence.
7. **Order and size.** Selected blocks stay in page order with duplicates removed. Size limits are settings per service (G2), never literals.

## 4. Validation before any paid call (zero AI cost)

Selection is validated **offline against stored evidence and independent labels**, not against the reader's own outcomes on cut text.

| Label set | Source (independent of the AI reader) | Used for |
|---|---|---|
| Positives | Values read by tested adapters (exact reads, Decision 254); values entered or confirmed by a person in Layer 4; central-policy rules with evidence | **Recall:** the gold quote or value must sit inside the selected text |
| Negatives | Pages a person confirmed carry no value for the field (Layer 4 "not stated" decisions); pages with a structurally verified absence (for example, a fee table present with no international row) | **Precision of absence:** selection may still send these pages, but "no section" must not be claimed where a person found one |
| Beyond-the-cut set | Pages longer than 24,000 characters where the full page holds the field and the first 24,000 do not | The cut's real false-negative rate |

**Gate for any service to move on:** selection recall at or above a setting-held threshold (proposed 99.5%) per field on the positive set, with zero misses on the beyond-the-cut set. The miss list is reviewed by a person.

The harness runs on stored HTML only (no Firecrawl, no OpenRouter). It is registered as a task (G1) with a report in the existing Data Delivery evidence view.

## 5. Shadow, then qualified switch-over (separate approvals)

1. **1b-1, build:** `lean-sections.ts` plus the offline recall harness and report. No worker change.
2. **1b-2, shadow:** the worker computes the selection beside the current input and records its size and parts in the Phase 1 observations. The request sent is unchanged.
3. **1b-3, qualify per service:** the new input format means a new prompt version, so each service is requalified with real structured-output and quote-validation tests on stored evidence, under the normal model and spend controls.
4. **1b-4, activate:** a per-service switch, set by the Platform Admin after qualification. A pass never switches anything on by itself.

The combined description and deadline read is **out of scope**. It needs its own requalification of `cdesc-source-grounded-v1`.

## 6. Acceptance (from the 13 Nov mandate)

- Fewer unnecessary tokens per retained valid field.
- No loss of source facts or evidence, and no false-negative filtering. Measured against the independent labels above, not against cut reads.
- No incorrect admissions. Admission rules are unchanged.
- Useful retained canonical output per US dollar goes up.
- Website and Zoho results unchanged except for gains, checked over two unattended cycles.

## 7. Risks

| Risk | Mitigation |
|---|---|
| An anchor list misses a site's wording | High-recall lists widened from adapter headings. A page with no selection is sent in full. The recall gate is on independent positives |
| Sending whole pages in parts raises cost on long pages | Measured in shadow (1b-2) before any switch. The part limit and Layer 4 hold are settings |
| Context lost when a section is split | Parts break only at section boundaries, and every part repeats its heading path |
| The prompt format changes model behaviour | Requalification per service (1b-3) |
