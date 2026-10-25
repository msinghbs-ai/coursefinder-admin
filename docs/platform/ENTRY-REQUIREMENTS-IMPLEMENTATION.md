# Academic entry requirements — verification and implementation (decision record)

Platform Admin, 25 Oct 2026 14:36: "Mandate — academic entry requirements: verify the research, build the model. … CF-247; decision record. The design doc (docs/platform/ENTRY-REQUIREMENTS.md) is a PROPOSAL — where provider reality differs, reality wins and the doc is corrected in the same PR (doc-as-code)."

## Sequencing (as mandated)

1. **Part 1** (verify against live sources): **done today**, read-only.
2. **Part 2** (build) is one release. It queues **after Track B release 1** in the standing order and does **not** displace Track A (S1, 8a). It may be split, see "Build order".
3. **Part 3** (diagrams): kept current in `ENTRY-REQUIREMENTS.md`. Corrected today in the same commit as this file.
4. The B1 spec (`nz-enrichment-brief/2026-10-24-nz-field-admission.md` section 5) is **extended by this design, not replaced**. The merge is noted in both files (Part 2.3).

---

## Part 1 — verification against live sources (25 Oct 2026)

**Method.** The 40 providers are the top 20 per country from the live catalogue (published, by active courses):
- **AU:** the 8 Group of Eight universities plus the 12 largest other universities.
- **NZ:** the 8 universities plus the 12 largest institutes of technology / polytechnics. NZIST Work-Based Learning (an industry training organisation with no international entry table) and the Open Polytechnic (distance) were left out; Unitec was included as the design's example.

Each provider's own site was searched and fetched today (WebSearch / WebFetch).

**Quote caution.** Quotes came back through the fetch tool's page summariser. They are near-verbatim, not byte copies. Every quote is re-checked byte for byte against the stored copy before it is used as a test fixture or admitted (the reader's quote-on-page check does this by design).

### 1.1 What the 40 providers actually publish

| Publishing shape | AU (20) | NZ (20) | Reader route |
|---|---|---|---|
| HTML: one page per country | RMIT (`/entry-requirements/country-equivalency/{country}`) | AUT also has per-country pages (`/international/{country}/entry-requirements`) beside its big table | HTML table reader |
| HTML: one big table / page | Flinders (ATAR-ladder table), UOW (one page, tab per country), UWA (one page, section per qualification) | Waikato, Massey, AUT, Otago, Lincoln, Unitec, MIT, Otago Polytechnic, Wintec (table per country), Ara, NMIT, SIT | HTML table reader |
| HTML: one page per qualification | Melbourne (per qualification, courses by name), ANU (per qualification, rank bands) | — | HTML table reader |
| HTML on each course page (server-rendered country dropdown) | Monash | — | Course-page reader (B1 extension) |
| PDF only (yearly or versioned file) | UNSW, Sydney, UQ, Adelaide, UTS (per-course PDF), Curtin, Western Sydney, VU, Macquarie (PDF; layout came out unaligned) | Auckland (per-programme PDFs A–I and J–Z) | PDF reader (central-page reading already takes PDFs, `cs:index.ts:1158`; table fidelity to be proven) |
| JavaScript selector, data not in the HTML | Newcastle (degree × country), Swinburne (selector; the India country page gives a bachelor minimum), Griffith (per degree) | Canterbury (checker app), Victoria University of Wellington, Whitireia and WelTec | Not readable by the HTML reader. Phase C: rendered read (Firecrawl) or "contact provider" |
| Course pages / prospectus only, no matrix | — | EIT, NorthTec | Course-page reader (B1) only |
| No international matrix | QUT (domestic-style conversion table only; overseas Year 12: contact) | — | "Contact provider" |
| Site refused the fetch (unknown) | — | UCOL, Toi Ohomai (Toi Ohomai's "Academic entry extract" PDF holds only an IELTS-by-level table) | Retry through the normal reader; else "contact provider" |

| | AU | NZ | Total |
|---|---|---|---|
| Readable as HTML | 7 (incl. Monash via course pages) | 12 | **19** |
| PDF only | 9 | 1 | **10** |
| JavaScript only | 3 | 3 | **6** |
| No matrix / course-only / unknown | 1 | 4 | **5** (QUT; EIT, NorthTec, UCOL, Toi Ohomai) |

(19 + 10 + 6 + 5 = 40. Swinburne counts as JavaScript only; its country page also gives a partial HTML row.)

### 1.2 Grain of the minimum (the model's key test)

| Grain | AU | NZ |
|---|---|---|
| **Provider-wide**: one minimum per country / qualification (optionally per study level) | Adelaide (single ATAR-70 equivalent), Curtin, Western Sydney (Foundation / Diploma / UG / PG), VU (Foundation → PhD), Swinburne (bachelor minimum) | Waikato, Massey, AUT (Diploma / Bachelor), Otago (UG), Lincoln (Bachelor / pathway diploma / pathway certificate), Unitec, MIT, Otago Polytechnic, Ara, NMIT, SIT (Diploma / Degree), Wintec (Cert L4 / Dip L5 academic / Dip L5 vocational / Degree) |
| **Band ladder**: the provider's benchmark bands converted per country, the course naming its band | RMIT (65 %–90 % bands → A-level points; levels Foundation / Pathways / Diploma / Bachelor), Flinders (ATAR 60–95 rows × 14 qualifications), UOW (Foundation / Diploma / Bachelor groups 1–3), UWA (score → ATAR equivalent), ANU (selection rank → score) | — |
| **Per course**: a course × qualification table | UNSW, Sydney, UQ, UTS (PDF), Monash (course page), Melbourne (per-qualification pages listing courses), Macquarie (PDF) | Auckland (programme × qualification, PDF) |

**The design's main assumption, that the provider-level country matrix is "the dominant pattern", holds for NZ (12 of the 13 NZ providers with a readable matrix; Auckland is per programme) but not for the AU Group of Eight.** In the Group of Eight:
- 5 of 8 set the minimum per course (UNSW, Sydney, UQ, Monash, Melbourne);
- 2 use band ladders (ANU, UWA);
- only Adelaide publishes one provider-wide minimum.

Across AU's 20: 5 provider-wide, 5 band ladders, 7 per course, 2 unreadable (Newcastle, Griffith), 1 none (QUT).

### 1.3 One sample row per provider

**AU (20)**

| Provider | Shape / benchmark | Sample row (country · qualification · minimum · applies to) | Quote (near-verbatim) |
|---|---|---|---|
| UNSW | PDF, per degree; INT ATAR + each qualification's scale | India AISSCE 85, ISC 92, State Board 98 · B Commerce | "B Commerce 92 8.2 15 19.5 80 24 36 16 3.4 1 85 3.7 85 92 98 9 1300…" (PDF row) |
| Sydney | PDF guide (2026; the 2027 edition is blocked by robots.txt), per course; CBSE as an aggregate out of 20 | India CBSE 19, ISC 94 · B Commerce | "B Commerce 012849G 3 Feb/Aug 56,300 7.0 (6.0) 96 (17/19) 96 38 17/19 3.85 85% 16.2 1.5 24 19 94 95" |
| Monash | Course page, country dropdown (server-rendered) | India CBSE 81 %, ISC 76 % · Commerce B2001 | "All India Senior School Certificate Examination81%" |
| Adelaide University | PDF, one minimum for the whole university (ATAR 70) | India Class 12, 70 % best four | "Successful completion of Class 12 (10+2) with an average of at least 70% in the best four approved subjects" |
| Melbourne | One page per qualification, courses listed | India CBSE / ISC 82 · Commerce (prerequisites English, Mathematics) | "Commerce 82 English and Mathematics" |
| ANU | One page per qualification, rank bands | India CBSE: rank 70 → 10.5 | "Program Required Entrance Rank / Indicative score required … 70 10.5 / 80 14.0 / 90 17.0" |
| UQ | PDF, per program (column alignment fragile) | B Commerce: ATAR 84, A-level 10 (India 70 inferred from alignment) | "Bachelor of Commerce 3 1, 2 - $56,800 84 10 32 73.33 75 …" |
| UWA | One page, conversion to ATAR equivalent | India ISC average 60 = ATAR 70 | "Indian School Certificate Average / ATAR Equivalent … 60 70 / 70 80 / 75 85" |
| UTS | HTML method + per-course PDF | India AISSC 14.0, ISC 83 · Bachelor of Business (ATAR 80) | (PDF table cell; method text "A1=4, A2=3.5, B1=3, …") |
| RMIT | One page per country, bands × levels | UK A-levels, Bachelor 65 % band: 7 points (CDD) | "Minimum 7 points for 3 A Level subjects. i.e. CDD" |
| Flinders | One table, ATAR ladder | ATAR 60 → India CBSE 65 | "60 \| 55% \| 6 \| 15 \| 24 \| 7 \| 70 \| 65 \| B \| 65 …" |
| Macquarie | HTML lists accepted qualifications; PDF per course (unaligned) | India: accepted HSSC / AISSC / ISC; no score extracted | "Indian Higher Secondary Certificate (HSSC); All India Senior School Certificate (AISSC); Indian School Certificate (ISC)" |
| Newcastle | JavaScript selector | — (no data in the HTML) | — |
| Swinburne | JavaScript selector; India country page | India bachelor: CBSE / ICSE 60 % | "60 per cent for CBSE and ICSE, 65 per cent for HSEB and PSEB, and 62 per cent for other State Boards" |
| Curtin | PDF (linked from the domestic-overseas page) | India CBSE 60 % best four | "A grade average of at least 60% from the best four subjects." |
| Wollongong | One page, tab per country; Foundation / Diploma / Bachelor groups | India CBSE: 7.0 / 8.0 / 10.5 / 14 / 16; ISC 55 % … 88 % | "Completed year XII \| 55% \| 65% \| 77% \| 84% \| 88%" |
| Western Sydney | PDF, per country × level | India CBSE undergraduate 60 % best four | "Successful completion of AISCE (CBSE) with an overall GPA of 60% in best 4 core subjects" |
| Griffith | Per degree, behind a selector | — | — |
| QUT | No international matrix | — (overseas Year 12: contact) | — |
| Victoria University | PDF, Foundation → PhD | India CBSE bachelor 65 % (diploma 60 %) | "Completed with an overall average of at least 65%" |

**NZ (20)**

| Provider | Shape / benchmark | Sample row | Quote (near-verbatim) |
|---|---|---|---|
| Auckland | PDF per programme (2027 A–I, J–Z) | India (specified boards) 75, other boards 80 · BA; English 70 % | "All applicants must achieve an overall average of 75% with a minimum of 70% in English." |
| Canterbury | JavaScript checker | — | — |
| Waikato | One page, row per country; one undergraduate minimum | India 75 % best four, English 60 % | "Achieve an average of 75% over the best four academic subjects with a minimum 60% in English" |
| Victoria University of Wellington | JavaScript selector (only generic IB / A-level text) | UK: three A-levels at C | "UK: Three GCE A-Level passes at grade C or higher" |
| Massey | One page, heading per country | India AISSC 75 %, English 60 % | "All India Senior School Certificate (AISSC) Year 12 with an overall average of 75% and a minimum of 60% in English" |
| AUT | Big table + per-country pages; Diploma / Bachelor | India Bachelor 75 % in four subjects, English 60 % | "12 years of schooling with an overall average of 75% in four academic subjects, including a min 60% in English" |
| Otago | One page, section per country (UG); diploma / foundation in a PDF | India 75 %, English 60 % | "12 years of schooling, an overall average of 75%, and minimum of 60% in English" |
| Lincoln | One page, three tables (Bachelor / pathway diploma / certificate) | India Bachelor 75 %, English 60 % | "Applicants must have completed 12 years of schooling and a minimum average of 75%, and 60% in English." |
| Unitec | One big table; Diploma / Degree | China: Diploma 65 %, Degree 80 % | "Senior Year 3 Certificate of Graduation with 80% average" |
| MIT | One big table (same template as Unitec) | China: Diploma 65 %, Degree 80 % | "Senior Year 3 Certificate of Graduation with 65% average" |
| Otago Polytechnic | One big table (+ procedure document); NCEA L2 / L3 | China: L2 65 %, L3 80 % | "Senior High School Graduate Certificate with 80% average" |
| Wintec | One page, table per country; Cert L4 / Dip L5 (academic, vocational) / Degree | China Diploma L5 academic 60–69 % | "Graduation certificate from a Senior High School with an average of 60-69% in core subjects in year 12." |
| Ara | One big table; Diploma / Degree | China Degree: Gaokao tier-two cut-off (yearly external table) | "National University Entrance Examination (Gaokao) Tier two cut-off scores as per the current year approved Gaokao table" |
| NMIT | One big table; Cert & Diploma / Degree | China Degree: graduation certificate with B average | "Senior High School Graduation Certificate with B average." (byte-check 25 Oct: the page splits the first letter in markup, so tag-stripped text reads "S enior …"; the reader joins markup-split words before the quote check) |
| SIT | One big table; Diploma / Bachelor | China: qualification only, no grade ("only a guide") | "High school graduates" |
| Whitireia and WelTec | JavaScript (only the heading loads) | — | — |
| EIT | Course pages / prospectus only | — | "Please refer to the specific entry criteria for your programme which can be found in the International Prospectus" (byte-check 25 Oct: corrected, the page has no final full stop) |
| NorthTec | Course pages / prospectus (likely) | — | — |
| UCOL | Site refused the fetch | — | — |
| Toi Ohomai | Site refused; regulations PDF has IELTS only | — | — |

### 1.3a Byte-check of the Part 1 quotes (25 Oct 2026, Track C)

The Part 1 quotes came through the fetch summariser, so each was checked against the raw page text before it became the reader's test data. A one-off workflow on the scratch branch fetched each source page, stripped tags, and compared the quote. The workflow was removed in the same flow (rule 8).

| Result | Count | Providers |
|---|---|---|
| Exact | 17 | UNSW, Sydney, UQ, UWA, UTS, Flinders, Macquarie, Wollongong, VU, Waikato, Victoria University of Wellington, Massey, Unitec, MIT, Otago Polytechnic, Ara, SIT |
| Exact after whitespace normalisation | 6 | Adelaide, ANU, RMIT, Curtin, Auckland, Wintec |
| Corrected | 2 | EIT (no final full stop on the page); NMIT (first letter split in markup; text is verbatim once words are joined) |
| Fetch refused (not verified; kept as "unverified" in the fixtures) | 7 | Monash 403, Melbourne 403, Swinburne network unreachable, Western Sydney 406, AUT 403, Otago 403, Lincoln 403 |

The 25 verified quotes are the reader's test data (`tests/fixtures/entry-matrix/part1-quotes.json` on branch `cf247-entry-matrix`). The 7 refused ones are carried as `unverified` and are not used as pass/fail cases. The tables above already show the corrected text.

### 1.4 Deviations the model must carry (reality wins)

1. **Per-course rows are common in AU.** A matrix row may belong to a course, not only to the provider (UNSW, Sydney, UQ, UTS, Monash, Melbourne, Macquarie, Auckland).
2. **Band ladders.** RMIT, Flinders, UOW, UWA and ANU convert the provider's *benchmark band* (65 %, ATAR 60, rank 70, group 1–3) rather than a level. The course names its band, so resolution needs two steps: course → band → country row.
3. **Study levels vary per provider:** Foundation, Pathways, Diploma, Associate, Bachelor (and Bachelor groups), Masters, PhD; in NZ, Cert L4 / Dip L5 academic / vocational / Degree, or NCEA L2 / L3.
4. **One cell can give several routes:** "Gaokao 65 % *or* one year of university study *or* Foundation", or the Ara Gaokao tier table.
5. **Rows with no threshold:** "Assessment on application", "case by case", "High school graduates", "qualification only" (SIT, NMIT India, Lincoln UK, Massey UK).
6. **Sub-qualification splits:** India CBSE vs ISC vs state boards (often different minimums); Canada and India by province / state.
7. **Bundled English minimum** ("75 % with 60 % in English"). This belongs to the academic row as a subject condition, not the English-test field.
8. **Editions:** per-intake PDFs (UNSW 2027, Auckland 2027, UQ `2026-09`, VU `2026-09`, Western Sydney `_v07`). The row keeps its edition and intake year; supersession happens by edition.
9. **robots.txt:** Sydney's 2027 guide is disallowed. The platform respects robots (no bypass), so Sydney stays on the 2026 edition and is flagged for a person.
10. **The design's "existing" scholarship minimum-academic field does not exist.** There is no such column in schema `scholarship` and no such key in `website_v2_scholarship` / `_scholarships`. B4 must add it before the website can carry it.

---

## Part 2 — build (queued after Track B release 1; one release)

### 2.1 Tables (additive; no drops; `comment on table`; RLS on; Replaces: nothing; Retires: nothing)

**`catalogue.provider_entry_matrix`**: one admitted row = one published minimum.

| Column | Type | Note |
|---|---|---|
| `id` | uuid pk | |
| `provider_id` | uuid fk | |
| `course_id` | uuid fk null | **Added (1.4 #1):** set for per-course tables (UNSW, Sydney …) |
| `matrix_kind` | text | **Added:** `provider_minimum` \| `band_ladder` \| `course_minimum` \| `rank_band` |
| `benchmark_band` | text null | **Added (1.4 #2):** e.g. "65%", "ATAR 60", "rank 70", "group 2" |
| `study_level` | text null | Provider's own label kept (`level_label`), mapped to `ref.study_levels` where it maps (`study_level_id` null otherwise) |
| `country_code` | text fk `ref.countries` | Country of prior education |
| `qualification_name` | text | As published ("All India Senior School Certificate (CBSE)") |
| `min_grade` | text null | As published ("CDD", "75%", "B average"); null for "assessment on application" |
| `min_value` | numeric null | Parsed value when unambiguous |
| `grade_scale` | text null | `percentage` \| `points` \| `aggregate` \| `gpa` \| `letter` \| `rank` \| `none`; **no numeric value without a scale** (B1 rule) |
| `conditions` | jsonb | **Added (1.4 #4, #7):** subject minimums ("English 60 %"), best-N rule, alternatives `[{route, min_grade, scale}]` |
| `audience` | text | `international` (default) |
| `edition` | text null | **Added (1.4 #8):** "2027", "v07" |
| `intake_year` | int null | |
| `quote` | text | Verbatim, ≤ 300 chars |
| `source_url`, `evidence_id`, `content_hash` | | |
| `as_at` | date | |
| `status` | text | Existing vocabulary: active / inactive / superseded / unverified |
| `provenance` | jsonb | `{reader, model, run_id, versions, settings_hash}`; with 2.2 version stamps when that lands |

**`catalogue.course_entry_requirements`.** This is the B1 table, with plural naming to match `course_english_requirements`. The design's singular `course_entry_requirement` is corrected. B1's columns stay, and this design adds:
- B1's kinds `prior_qualification`, `minimum_grade`, `subject_prerequisite`, `portfolio_interview`, `work_experience`, `other`;
- the design's `override` and `general_note`;
- `min_entry_score` + `min_entry_score_basis` (the course's band, e.g. "ATAR 92", "65 %");
- `benchmark_band` (links the course to a band-ladder row);
- `provenance` jsonb.

### 2.2 Matrix reader

- **Discovery.** Central-page discovery (`central_find`, `cs:central.ts`) gains the page type **`entry_requirements`**. Candidates are URL and link-text patterns from Part 1 (`country-equivalency`, `entry-requirements`, `international-qualifications`, `academic-equivalence`, `admission-by-country`, `overseas-qualifications`) plus linked PDFs.
- **Stored first.** Firecrawl is used only where storage holds no copy. robots.txt is respected.
- **AI extract** (pinned, individually qualified model: `entry.matrix_model`):
  - returns country rows with a quote per row;
  - the database admits a row only when its quote is on the stored page and a numeric value has a scale;
  - unknown countries / levels are skipped with the reason;
  - large one-page tables are read in slices (`entry.matrix_max_rows_per_page`).
- **First run per provider goes to Layer 4.** A new kind, "Entry matrix (first run)", shows sample rows beside the page. The matrix is admitted only on the person's approval. Later reads of an unchanged page are skipped (`content_hash`); a changed page re-reads and its differences go to Layer 4.
- **Acceptance report** (Track B release 3): the kind is counted like every other proposal.
- **Settings:**

| Key | Default | Range / unit |
|---|---|---|
| `entry.countries` | ["AU","NZ"] | list |
| `entry.matrix_model` | pinned id | — |
| `entry.matrix_min_confidence` | 0.85 | 0.5–1 |
| `entry.matrix_max_rows_per_page` | 400 | 50–2,000 rows |
| `entry.matrix_first_run_review` | 1 | 0–1; stays 1 |
| `batch.entry_matrix` | 4 | 1–20 pages a run |
| `entry.matrix_refresh_days` | 30 | 7–180 days; re-read only if the hash changed |

- **Job:** `entry-matrix-read`, catalogued in the `automation_catalogue` line.

### 2.3 Course-level: rides B1 (merge noted in both files)

The B1 spec (field-admission section 5) is **extended**:
- same Enrich-fields field `entry_requirements`, stored page only, up to `entry.max_rows_per_course` (6) rows, `entry.min_confidence` 0.8;
- adds the kinds `override` / `general_note`, `min_entry_score` and `benchmark_band`;
- Monash-style course-page country dropdowns (server-rendered) are read into `provider_entry_matrix` rows with `course_id` set.

B1's validation rules stand:
- the quote is on the page;
- no score without a scale;
- no row that repeats the English requirement;
- international rows name international applicants.

### 2.4 Consumer API (additive)

- **Course payload** gains `entry: {min_score, min_score_basis, benchmark_band, prerequisites[], selection_tasks[], requirements_note}`.
- **Provider payload** gains `entry_matrix: [{country, study_level, qualification, min_grade, scale, band, course_code?, conditions, as_at}]`.
- An optional `?edu_country=` narrows the matrix in both payloads.

**Approval.** G3 freezes the consumer API. This mandate is the Platform Admin's explicit instruction for additive fields on the course and provider payloads. The migration will carry: `-- Consumer API change approved: Platform Admin, 25 Oct 2026 14:36, "Consumer API: additive entry fields on course and provider payloads per Part C of the design; frozen-API rules apply"`. It updates `tests/uat/consumer-api-baseline.json` and re-takes the baseline (`security.consumer_api_rebaseline_v1`).

**Conflict noted.** The earlier B1 spec said "exposed later through a new website function, never by changing an existing one". The mandate supersedes it for these two payloads; nothing is renamed or removed.

**Resolution order** (per student, per course):
1. A course override row (`course_entry_requirements` kind `override`).
2. A per-course matrix row (`course_id` = course, student's country).
3. The band ladder: the course's `benchmark_band` → provider row for that band and country.
4. The provider minimum for the student's country and the course's study level.
5. Otherwise **"Requirements for your qualification aren't published — contact the provider"**. Never invented.

**Developer pack.** The website team gets `docs/integrations/developer-pack/` with the resolution order and a worked example: a student from India, RMIT Bachelor of Engineering. The example is written **at release, from admitted rows**, never from made-up values.

Part 1 shows RMIT is a band ladder. The example will therefore show both steps:
1. The course page names its band (to be read; e.g. "65 %").
2. The RMIT India page converts that band to the CBSE / ISC minimum.

Section 13 of the guide lists the new fields.

### 2.5 Build order inside the release (within Part 2's queue slot)

| Step | Scope | Providers covered at the end |
|---|---|---|
| A | Tables, settings, Layer 4 kind, HTML matrix reader (page per country, big table, page per qualification), first-run review | 19 HTML providers (AU 7, NZ 12) |
| B | PDF matrices through the existing central-page PDF read; column-fidelity check (UQ / Macquarie alignment risk) before any row reaches Layer 4 | +10 (UNSW, Sydney 2026, UQ, Adelaide, UTS, Curtin, WSU, VU, Macquarie, Auckland) |
| C | JavaScript-only sources: rendered read through Firecrawl where the data is in the rendered page; otherwise "contact provider" and a Layer 4 note | Newcastle, Swinburne, Griffith, Canterbury, Victoria University of Wellington, Whitireia and WelTec (6) |
| — | No matrix / course-only / refused: the course-page reader (B1) and "contact provider" | QUT, EIT, NorthTec, UCOL, Toi Ohomai |

- **Contract tests:**
  - s111: tables, settings rows, RLS, append of provenance, no numeric value without a scale;
  - s112: reader admission rules and first-run Layer 4 routing;
  - s113: consumer API additive keys and the frozen-baseline update;
  - s114: resolution-order function.
- **Estimate:** A about 2.5 days; B about 1.5 days; C about 1 day; consumer API + developer pack about 1 day.
- **AI cost:** one call per matrix page or slice. About 40 providers × 1–20 pages comes to well under US$5 at the current pinned model. Firecrawl applies only where storage is silent.
- **Doc-as-code:**
  - PIPELINE-LINEAGE.md section 1 gains the two fields;
  - sections 2–4 gain the `entry-matrix-read` lane;
  - `ENTRY-REQUIREMENTS.md` stays in step in the same PRs.

---

## Part 3 — diagrams

Both mermaid diagrams in `ENTRY-REQUIREMENTS.md` were corrected today:
- **ER diagram:** `course_id`, `matrix_kind`, `benchmark_band`, `conditions` and `edition` added; plural `course_entry_requirements`; the scholarship minimum-academic box is marked "not built (B4)".
- **Toolset flow:** PDF and JavaScript branches, robots.txt respected, Layer 4 first run, resolution-order step.

They are kept current in each build PR.

## Decisions for the Platform Admin

1. **Consumer API placement:** confirm additive keys inside the existing course and provider payloads (as the mandate reads), rather than a new website function (as B1 had said).
2. **Sydney 2027:** the guide is robots-disallowed. Keep the 2026 edition with a "superseded edition" flag until the provider's page allows it, or a person enters it.

---

## Decisions 25 Oct 2026 14:50 (Platform Admin; recorded before code)

| # | Decision | Effect |
|---|---|---|
| 7 | **Website feed confirmed:** "additive fields on the EXISTING course and provider payloads; no separate function. The mandate is the explicit frozen-API approval." | Part 2.4 stands as written. The migration's approval line quotes the 14:36 mandate and this confirmation. The B1 note in `nz-enrichment-brief/2026-10-24-nz-field-admission.md` section 5 and the merge note in `ENTRY-REQUIREMENTS.md` section E are updated, so the question is closed |
| 8 | **Sydney:** "keep the 2026 edition as CURRENT (not "superseded" — nothing has replaced it; the 2027 guide is unavailable, not released-over). Edition + as_at stored as normal; display shows "2026 admissions guide". Add a catalogued quarterly re-check for the 2027 guide (robots-respected; logs still-blocked). Normal supersession applies when a later edition lands." | Sydney rows: `status` active, `edition` '2026', display label "2026 admissions guide". New catalogued job `entry-matrix-edition-check`: quarterly, robots.txt respected, logs "still blocked" to `admin_control_events`. Setting `entry.edition_check_days` (90, range 30–180, days) |
| 9 | **Part 2 build plan approved as planned:** Step A (tables + HTML reader + Layer 4 first run, 19 providers); B (PDF tables, +10); C (JavaScript only, +6); about 6 days, after Track B release 1; Track A not displaced | Queued in the standing order |
| 10 | **Rendering rule for the developer pack:** "a matrix row WITHOUT a minimum (the "case by case" rows — SIT/China, NMIT/India, Ara's Gaokao pointer) must render as "this qualification is considered case by case", never as "no data" and never as an automatic pass." | Line recorded in `docs/integrations/developer-pack/ENTRY-REQUIREMENTS-RENDERING-NOTE.md` now. It is folded into the Developer Guide (section on entry fields, plus section 13 API changes) when the fields ship. The API marks such rows with `min_grade` null and `scale` 'none', and the resolution order returns them as a case-by-case result, not as "contact the provider" and not as met |

These close decision items 1 and 2 of this file.
