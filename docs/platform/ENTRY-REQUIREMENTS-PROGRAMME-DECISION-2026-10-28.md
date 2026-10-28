# AER programme completion — decision record (consolidated mandate)

**Lodged 28 Oct 2026, about 23:4x AEDT, before any Pilot change under this mandate.**

**Mandate.** Platform Admin, 28 Oct 2026 23:22: "Consolidated programme mandate — complete the approved AER plan". It supersedes the bounded-slice and one-re-read instructions.

**Build-order authority.** `ENTRY-REQUIREMENTS-IMPLEMENTATION.md`, Part 2 (2.1–2.5), and decisions 7–10 (25 Oct 2026). This record applies that plan. It does not rename its steps or redefine completion. In particular, "Step B" here means the plan's own **Step B: PDF matrices**, and "Step C" means **JavaScript-only sources**. The bounded RMIT slice of 28 Oct was the course-level and serving work (B1–B5); it is reported as such.

## 1. What this mandate settles

| # | Topic | Decision (from the mandate) | Effect |
|---|---|---|---|
| P1 | Provider scope | The approved provider plan is Part 1's 40 providers: AU top 20, NZ top 20, plus Federation from the AER pilot. "Do not expand beyond the approved provider plan." **RMIT stays outside matrix reading scope.** | `entry.providers` is widened, by migration and with this reason, to the planned providers whose official source is found and routed. RMIT is not added. The 26 Oct 21:39 decision 4 ("top 20 waits for pilot sign-off") is superseded by this mandate. Pilot sign-off by spreadsheet is unavailable (P6) |
| P2 | Sources | Stored official pages only; robots.txt respected; Firecrawl only within the approved source-reading rules | Official entry-requirements URLs are seeded as `found_via = 'manual'` sources, one migration per wave, count-guarded, with the URL evidence recorded. Central-page discovery stays as built |
| P3 | Admission | Existing Layer 4 whole-run admission (`entry.matrix_first_run_review` stays 1). Gates are never weakened | Every new provider's first read goes to a person. Admitted rows remain the only consumer-visible rows |
| P4 | Step B (PDF) | Built through the existing reading capability, with a column-fidelity proof against the stored PDF before any row reaches Layer 4. Misalignment fails closed. No partial tables | Section 3 |
| P5 | Step C (JavaScript) | Rendered read where the rendered official page contains the requirements; otherwise an evidenced "contact provider" outcome | Section 4 |
| P6 | Customer spreadsheet | Not requested again. Acceptance is source-anchored. The spreadsheet diff is recorded as externally unavailable | No spreadsheet result is claimed |
| P7 | Residue | BH126, the 37 proposed RMIT rows, UTS's pending item and held sources go through their existing Layer 4 and source routes. No D6+ saga. Reader corrections only where a source route's acceptance requires them, structure-driven | The earlier BH126 decisions stand |
| P8 | Human UI actions | If signed-in Platform Admin actions are unavailable, they are listed once in the consolidated handback; other lanes continue | Section 6 |
| P9 | Consumer API | Shape frozen as shipped (#720). Verified against admitted data as coverage lands | No further consumer-shape change without explicit authority |
| P10 | Automation | Only what the plan authorises: catalogued jobs, settings-controlled scope and pacing, unchanged-page hash skip, edition handling (decision 8: `entry-matrix-edition-check`, `entry.edition_check_days` 90), measured AI spend, acceptance reporting, governed review | No uncounted jobs and no new status values |

## 2. Waves (HTML first; no reader change needed to start them)

1. **Wave H (HTML, Step A routes).** The planned HTML providers with a confirmed official page are seeded and added to `entry.providers`. The existing reader reads them; rows go to Layer 4.
   - A page whose shape the reader cannot hold is reported as a source gate: the reason is recorded, never skipped silently.
2. **Wave P (PDF, Step B).** VU (two records), Federation, WSU's published table, and the plan's PDF providers (UNSW, Sydney 2026, UQ, Adelaide, UTS per-course, Curtin, Macquarie, Auckland) where the official PDF is available.
3. **Wave J (JavaScript, Step C).** Newcastle, Swinburne, Griffith, Canterbury, Victoria University of Wellington, Whitireia and WelTec.
4. **No matrix / course-only / refused.** QUT, EIT, NorthTec, UCOL and Toi Ohomai: an evidenced "contact provider" outcome, or the course-page reader (B1) where course pages publish requirements.

## 3. Step B — PDF route

- **PDF text with positions:** each text item keeps its page, x and y. Lines are rebuilt by y, and columns by x ranges taken from the table's header row.
- **Column-fidelity proof, before any AI read:** a table is "aligned" only when every data row's cells fall inside the header's column ranges, with no cell straddling two ranges, and the row count is consistent. Anything else is `held_unparsed` with the reason (fails closed: UQ / Macquarie-style misalignment).
- **What the reader sees:** the aligned table is given as table lines (cells joined by " | "), exactly as for HTML. Quote, scale and completeness checks run unchanged against that text.
- **Same objects:** the same sources, runs, evidence, identity, completeness and Layer 4 controls. No new tables. Edition and intake year are kept from the PDF where printed.

## 4. Step C — JavaScript route

- A source marked as needing rendering is fetched once through Firecrawl (rendered HTML), within the existing Firecrawl spend checks and only where robots.txt allows. The rendered copy is stored as evidence and read like any HTML page.
- If the rendered copy holds no requirements table, the source is closed with the evidenced outcome "not published in the rendered page — contact provider", and is not retried until the page hash changes.

## 5. Acceptance (per provider and source route)

The report reconciles:
- sources found and stored;
- sources read;
- rows proposed, admitted, quarantined and held;
- published minimums against extracted minimums (the manifest, where a table is parsed);
- open evidence gates with their exact reasons;
- consumer-visible results.

## 6. Gates that stay with the Platform Admin

- Layer 4 decisions: every first read, the BH126 item `cf71cca1`, UTS's pending item and the 37 RMIT rows.
- Destructive changes and any new consumer-shape change.
- Anything the plan does not answer. Such a question parks its lane only; the other lanes continue.

## 7. Source inventory used for seeding (checked 28 Oct 2026 with the worker's robots rule and user agent)

| Route | Provider | Official source | Note |
|---|---|---|---|
| HTML | Flinders | flinders.edu.au/international/apply/entry-requirements/undergraduate-entry-requirements | table |
| HTML | UWA | uwa.edu.au/study/how-to-apply/pathways-and-eligibility/international-and-overseas-qualifications | table |
| HTML | UOW | uow.edu.au/study/international/representatives/international-entry-requirements/ | table |
| HTML | Waikato | waikato.ac.nz/study/apply/international/entry-requirements-for-international-students/ | table |
| HTML | Massey | massey.ac.nz/…/entry-requirements-for-international-students/ | heading per country |
| HTML | MIT | manukau.ac.nz/study/international-students/how-to-apply/entry-requirements-academic/ | table |
| HTML | NMIT | nmit.ac.nz/international/entry-requirements | table |
| HTML | Otago Polytechnic | op.ac.nz/international/apply-and-enrol/entry-requirements | table |
| HTML | SIT | sit.ac.nz/International/How-to-Apply | table |
| HTML | Ara | ara.ac.nz/academic-equivalence | table |
| HTML | Wintec | wintec.ac.nz/international/international-academic-entry-requirements | table |
| HTML | Unitec | unitec.ac.nz/international/study-with-us/country-specific-criteria/ | table |
| HTML (Firecrawl fallback) | AUT, Otago, Lincoln | official international entry pages | 403 to direct read; the worker falls back to Firecrawl within its rules |
| HTML | ANU | study.anu.edu.au indicative entry requirement pages (one per qualification) | per-qualification pages |
| HTML (prose) | Swinburne | swinburne.edu.au/international-students/countries/… | per-country prose |
| PDF | UNSW, Sydney, UQ, Adelaide, Curtin, WSU, Macquarie (3), Auckland (2), VU, Federation | official PDFs | parked `pdf_step_b` until the PDF route ships |
| JS | VUW, Whitireia/WelTec, Newcastle, Griffith | official pages render client-side | Step C |
| None | QUT, EIT, NorthTec, UCOL, Canterbury, Toi Ohomai (English only), Melbourne (list without minimums), Monash (per-course) | — | contact-provider outcome or course-page route; not seeded as matrices |
