# s1312: AER-FU-12 source recovery, QUT and Newcastle (S1-AER-Claude, 27 Nov 2026)

Assignment from SS-Programme-Control, 27 Nov 15:19 AEDT (routed by S1-Build 15:10, development freeze kept). Live reads and public-page checks, 27 Nov 15:20 to 16:10 AEDT. AI US$0, Firecrawl US$0. No source, setting, configuration, lock or Layer 4 item changed; no retry of an unchanged failed read.

## 1. QUT by-country PDFs (sources `649d017d` foundation, `fd198a4d` diploma)

| Check | Finding |
|---|---|
| Stored copies | Firecrawl markdown (956 and 1,025 bytes, mime `text/markdown`), not the PDFs. Runs `b85d56de` and `95f0b40f` (24 Nov 22:24 AEDT) done, kept 0. |
| Why not the PDF | The setting `reading.entry_pdf_firecrawl_on` (1) makes a refused PDF fall back to Firecrawl text; QUT refuses the direct read. |
| Plain read now | A plain read of both PDF addresses from this session also fails at the site (client error, nothing retrieved). The same refusal, so original bytes are not obtainable by the authorised plain-HTTP route. Policy: a refusal is reported, never bypassed (Charter section 2). |
| Public index copy | A public search index shows both PDFs hold many countries (for example Bahrain, Bangladesh, Botswana, Brazil, China, Colombia, India, Indonesia on the diploma list). The stored 1 KB markdown is therefore a partial rendering and cannot stand for the document. |
| Alternative official page | The QUT international applying page (`https://www.qut.edu.au/study/applying/international-applying`) links no by-country page and says requirements are per course. |

**Not obtainable under the current mechanism.** The stored text cannot be read as the full table, the original bytes cannot be acquired, and requalifying configuration `28b85b35` on the same 1 KB copy would repeat the failed read. It qualifies again automatically when the stored copy changes (S1-Build note); nothing here changes it.

**Two ways forward, both outside this lane's authority:**
1. **Platform Admin supplies the original PDFs** (downloaded in a browser from the two addresses) for storage as evidence with their SHA-256. This needs an upload route for entry-matrix sources; none exists today (the upload route covers QS rankings only). A request to S2-AER and S1-Build under the freeze.
2. **Platform Admin decision to ask QUT** (international admissions) for permission or a feed. Site policy is respected meanwhile.

**Correction to the record.** CURRENT-STATE says QUT holds 0 entry rows. Live: QUT has 294 documented courses, of which **172 hold active course-level rows** (read from course pages). The consumer API returns a requirement for India on 59 of 60 sampled covered QUT courses (course override), 1 contact provider. The 122 without rows are mostly identity-unresolved pages (90) or held reads over the row limit (about 25 pages with 23 to 125 requirements against a limit of 19), so the by-country PDFs would add a provider-level fallback, not a first coverage.

## 2. Newcastle

| Source | Finding |
|---|---|
| Prospectus PDF `ff90a9ca` (direct, stored, 13,792,426 bytes, hash `e208356a…76da4ca`) | Run `fd5a7407` failed: stopped after three tries, time budget. The worker stops on this file (HTTP 546), even read-only. |
| Page scope | The engine reads the first N pages only (`entry.pdf_max_pages` 40, one PDF per call). There is no page-range input, and reader configurations (s1310) override only `reading.entry_*` settings, not page range. A bounded section read of pages beyond the first 20 is therefore not possible without a worker change. That change is a freeze exception; recorded, not made. |
| Agent page `0ac82ec0` (rendered) | No table; a public page check confirms it states requirements by level of study, "vary by country and program", with no country table. Not a source of rows. |
| Other official pages found | `internationalcollege.newcastle.edu.au/entry-requirements` has a by-country table for the **Newcastle International College (CIE)**, a separate pathway entity from the University; it must not be attached to University courses. The University's admissions manual (policies.newcastle.edu.au) states general rules, not country tables. |

**Live position (catalogue, 27 Nov).** 457 documented courses: 89 hold course-level rows, 41 have a Layer 4 item pending, **327 hold nothing**. The blocker for those is an unproven course page (108 no bound page, 91 mismatched, 4 ambiguous, 49 bound without identity basis), a source integrity and relink matter (S1-Build, S1-Data-Gaps, s1306), not the prospectus.

## 3. Requalification

No reader configuration was requalified: the evidence did not change for QUT (same refused source) or Newcastle (same stored PDF and agent page), and the engine would repeat the identical outcome. They requalify automatically when the stored copy changes.

## 4. Decisions needed (exception, not retries)

| Ref | Need | Owner |
|---|---|---|
| AER-FU-12-a | Original QUT PDF bytes, by Platform Admin download and an upload route for entry-matrix evidence (or QUT permission) | Platform Admin, S2-AER, S1-Build |
| AER-FU-12-b | Page-range input for the stored-PDF reader (freeze exception) so the Newcastle prospectus is read in bounded sections, with the page ranges that hold the by-country tables confirmed first | S2-AER (design), S1-Build (release) |
| AER-FU-12-c | Course page proof for Newcastle (327), already on S1-Build and S1-Data-Gaps | S1-Build |

Acceptance (new canonical rows for QUT or Newcastle read with a configuration, then consumer read-back) is **not met** in this pass: none could be produced without new capability.
