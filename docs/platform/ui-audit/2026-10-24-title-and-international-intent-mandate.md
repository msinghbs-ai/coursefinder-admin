# Mandate — title verification (NZ) and international-intent pages (AU)

| | |
|---|---|
| Raised | Platform Admin, 24 Oct 2026 19:05 (Melbourne) |
| Status | Platform Admin 24 Oct 19:12: Defect 1's read-only title measuring runs now, in parallel (done 19:55, section A below; reported before any design). Defect 2 detection waits for R2. Writes wait for batch approvals |
| Change control | CF-CHG-20260915-247; this file is the decision record |
| Hard rules | No course is ever deleted. Unverifiable courses are QUARANTINED (off the website, status change, reversible) only through count-guarded paste files the Platform Admin applies. No auto-quarantine. Every quarantine, alias or variant write carries provenance (who, what, quote, when). Budget within the existing search cap and Firecrawl daily budget; similarity threshold and batch size are settings keys |

## Defect 1 — NZ: register titles vs what providers publish (example: Otago)

1. **Quantify first (read-only):** for NZ active courses, register title vs the bound page's title/heading; similarity distribution; count below a threshold; the worst 20 with both titles quoted. Decides the approach before any writes.
2. **Verify pass** (courses below threshold): AI judges against the provider's published pages (stored copies first; Firecrawl search/map on the provider domain for the exact title only where storage is silent). Three outcomes, each with an evidence quote:
   - FOUND (variant: abbreviation, reordering, branding) → keep; record the published title as an alias; the binding is not churned.
   - NOT FOUND (on the register, not offered on the site to internationals) → quarantine candidate. First fed to the zero-yield flow's `page_rejections` / re-find (the right page may sit under another title); only after re-find fails does it reach Layer 4 as "not offered".
   - PAGE STATES IT → keep, note.
3. **Human gate:** Layer 4 items with both titles, the AI's quote and verdict; the Platform Admin decides removals in batches.
4. **Budget:** NZ providers by course count; settings keys for the similarity threshold and batch size.

## Defect 2 — AU: links must land on the international-intent page (example: Monash)

1. **Detect** (stored copies first): AI identifies pages whose primary content is domestic with an international entry point (button, tab, link). Quantify per provider before acting; Monash-family (multi-tab course pages) first.
2. **Resolve, in order:** (a) derive the international URL (the button's href, same site) and re-bind through the standard bind → reidentify → re-read chain; (b) where no international variant exists, annotate the course (confirm the reader captures international intent; fix if not); (c) flag for Layer 4.
3. **Readers:** fee, English and intake readers prefer international-stated values where a page carries both (quote-on-page keeps provenance). Check today's readers; fix any that take the domestic value silently.
4. Same budget discipline and settings keys as Defect 1.

## Cross-cutting

- Both flows **consume** `page_rejections` (S1 semantics) and do not duplicate the zero-yield flow.
- Sequencing: Defect 1 quantification and Defect 2 detection may run in parallel (read-only); writes wait for batch approvals.
- Contract tests: title-variant alias recording; international-variant re-bind chain; reader international preference.

## Division of labour vs the zero-yield flow (draft; confirmed when built)

| Flow | Question it answers | Input | Output |
|---|---|---|---|
| Zero-yield (v2.15.338) | "Is this bound page the wrong page?" (a read admits nothing) | Bound pages with no admitted values | `page_rejections` + re-find |
| Defect 1 title verification | "Does this course exist as the provider publishes it?" | Register title vs page title below threshold | Alias (FOUND), note (STATES IT), or → `page_rejections`/re-find, then Layer 4 "not offered" |
| Defect 2 international intent | "Is this the right variant of a correct page?" | Bound pages that are right but domestic-first | Re-bind to the international URL, annotation, or Layer 4 |

Neither new flow decides that a page is wrong on its own evidence: a wrong page goes to `page_rejections` and the zero-yield/S1 re-find, as today.

## Output owed (when the chain clears)

1. Both quantifications with samples. 2. Designs with settings keys and budget estimates. 3. Layer 4 proposal batches with evidence quotes. 4. This division-of-labour note, confirmed. 5. Anything blocked (expected: batch decisions only).

## A. Defect 1 quantification — read-only, 24 Oct 2026 19:55

**Method.** NZ active courses with a bound page (3,343 of 6,474; the other 3,131 have no page to compare and are outside this measure). Register title = `catalogue.courses.canonical_title` with "(Level n)" removed; published title = the page's title from the provider site map (`pipeline.coverage_provider_urls.title`, the segment that is not the provider's name), else the readable last part of the page address (decoded; generic endings such as "about", "overview" skipped). Pages whose address carries no title (query-string pages, codes like `dipglobalc`) and no stored title are counted separately: they need the stored copy read (the verify pass). Similarity = token-set ratio (0–1) on lower-cased words, common words removed; computed off the database (no extension installed, nothing written). Full below-threshold list: `docs/platform/ui-audit/2026-10-24-d1-nz-title-below-threshold.csv` (447 rows).

| Published title from | Courses | 1.00 | 0.90–0.99 | 0.80–0.89 | 0.70–0.79 | 0.60–0.69 | 0.50–0.59 | < 0.50 |
|---|---|---|---|---|---|---|---|---|
| Page title (site map) | 1,213 | 1,138 | 11 | 18 | 11 | 5 | 7 | 23 |
| Page address | 1,840 | 1,543 | 41 | 97 | 37 | 25 | 25 | 72 |
| No readable title (stored copy needed) | 290 | — | — | — | — | — | — | — |

- **2,681 of 3,053 measurable (88%) match exactly**; below 0.8: 205 (6.7%); **below 0.7: 157 (5.1%)**; below 0.6: 127.
- Below 0.7 by provider (measurable): Otago 13 of 227, Whitireia and WelTec 12 of 65, Te Whare Wānanga o Awanuiārangi 9 of 36, International Education Group 7 of 8, Te Wānanga o Raukawa 6 of 55, EIT 6 of 101, Toi Ohomai 6 of 93, AUT 5 of 197, Otago Polytechnic 4 of 118.
- No readable title: VUW 67, UCOL 52, AUT 39, University of Auckland 23, Otago Polytechnic 17, Laidlaw 13, Lincoln 10, Otago 10.
- Otago (the mandate's example): by page title 2 of 176 below 0.7; by address 11 of 41; 10 without a readable title.

### Worst 20 (both titles quoted; my reading of each, not yet AI-judged)

| # | Score | From | Provider | Register title | Published title | Reading |
|---|---|---|---|---|---|---|
| 1 | 0.07 | page title | Ara Institute of Canterbury | Graduate Diploma in Laboratory Technology (Level 7) | Skip to main content | title extraction noise (page title "Skip to main content") |
| 2 | 0.11 | url slug | Whitireia and WelTec | New Zealand Diploma in Information Systems (Level 6) | lower hutt events centre 2025 | wrong page (graduation venue) |
| 3 | 0.13 | url slug | C4 Group Limited | New Zealand Certificate in Security (Foundation) (Level 3) | NZCIS 3 MG.pdf | wrong page (PDF course guide) |
| 4 | 0.13 | url slug | University of Otago | Bachelor of Education (Teaching) (Level 7) | course v1:HEDC+8PCD101+Continuous | wrong page (Otago MOOC course page) |
| 5 | 0.14 | url slug | Whitireia and WelTec | New Zealand Diploma in Hospitality Management (Level 5) | lower hutt events centre 2025 | wrong page (graduation venue) |
| 6 | 0.14 | url slug | Adventure Works Limited | Te Tiwhikete Kaiarahi Taiohi - Aotearoa (Taumata 4) | youth work qualification nz | variant? (marketing page "youth work qualification") |
| 7 | 0.15 | page title | PEETO, The Multi-Cultural Learning Centr | New Zealand Certificate in English Language (Level 2) | NZCEL Level2 | variant (NZCEL Level 2) |
| 8 | 0.15 | page title | Auckland Institute of Studies Limited | Bachelor of Business (Level 7) | Hospitality Management Qualification | wrong page (different qualification) |
| 9 | 0.15 | page title | SPI Institute Ltd - South Pacific Island | New Zealand Certificate in Electrical Pre-Trade (Level 3) | Level 3 | variant/noise (title "Level 3") |
| 10 | 0.15 | url slug | Whitireia and WelTec | Bachelor of Applied Business Management (Level 7) | lower hutt events centre 2025 | wrong page (graduation venue) |
| 11 | 0.16 | url slug | NorthTec | Graduate Diploma in Business Information Systems (Level 7) | academic calendar | wrong page (academic calendar) |
| 12 | 0.16 | url slug | Auckland University of Technology | Certificate in Professional Cookery (Level 3) | robert.richardson | wrong page (staff profile) |
| 13 | 0.17 | page title | Toi Ohomai Institute of Technology | Te Tohu Paetahi Whakaako K&#333;hungahunga | Bachelor of Teaching Early Childhood Education | variant (Māori register title, English published) |
| 14 | 0.17 | url slug | Fire & Emergency New Zealand | New Zealand Certificate in Fire and Rescue Services (Level 2) | teachers and schools | wrong page (schools page) |
| 15 | 0.17 | url slug | Kiwidotcom Education Group Limited | New Zealand Certificate in English Language (Level 2) | nzcel l3 | wrong level (NZCEL L3 for an L2 course) |
| 16 | 0.17 | url slug | Yoobee Colleges Limited | New Zealand Certificate in Makeup Artistry and Hairstyling (Level 4) | level 4 | variant (level-4 tab of the certificate page) |
| 17 | 0.18 | url slug | Air New Zealand Limited | New Zealand Diploma in Aviation (General Aviation) (Level 5) | engineering new students nz | wrong page (engineering new students) |
| 18 | 0.19 | url slug | Anamata Charitable Trust | Te Taupuatanga o te Whanau | facilities locations | wrong page (facilities) |
| 19 | 0.19 | url slug | Eastern Institute of Technology | Bachelor of Arts (Maori) (Level 7) | graduate continues voyage of learning | wrong page (news item) |
| 20 | 0.19 | url slug | Manukau Institute of Technology and Unit | Te Tohu Paetahi Tikanga Rangatira aa-Tapuhi | bachelor of nursing maaori level 7 | variant (Māori register title, English published) |

### What the measure says about the approach (for the Platform Admin before any design)

1. **Title divergence is small where we hold a page:** 88% exact, 5% below 0.7. The NZQA-register-vs-published gap the mandate describes is real but narrow on bound pages.
2. **Most of the worst cases are wrong pages, not title variants** (12 of the worst 20: graduation venues, a calendar, a staff profile, a PDF, a MOOC course, a news item). Those belong to the zero-yield / `page_rejections` re-find (S1), not to an alias. The verify pass should hand them there first — which the mandate already orders.
3. **Genuine variants exist and are the alias case:** Māori-language register titles published in English (Toi Ohomai, Manukau), level shorthand ("NZCEL Level 2"), a level tab of a certificate page.
4. **Some low scores are title-extraction noise** ("Skip to main content", "Level 3"): the verify pass reads the page heading from the stored copy, not the site-map title.
5. **The bigger "not offered" question is the 3,131 NZ courses with no bound page at all** (48%). They have nothing to compare; whether they are offered to internationals is answered by search (and the zero-yield/S1 flow), not by this title pass.
6. **Suggested threshold to start:** 0.7 (setting, adjustable), which puts 157 measurable + 290 unreadable = 447 courses into the verify pass; budget: stored copies first (no Firecrawl), AI judgement on the page heading and body — design and cost estimate follow once the Platform Admin has seen this.
