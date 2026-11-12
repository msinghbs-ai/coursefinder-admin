# Destination data sources: AER fields missing from Website API v2 (review)

| | |
|---|---|
| Date | 12 November 2026 |
| Reviewed | `Study-Square-destination-data-sources_1.xlsx` (28 destinations; Country overview, Template map, Still to confirm, one sheet per country) |
| Against | Website API v2 as live on 12 Nov 2026 (`website_v2_course`, `website_v2_provider`, `ref.english_tests`) and developer guide §7.2, §7.3, §7.4, §7.9 |
| Scope | Academic entry requirements (AER) and what the website needs around them: language and admission tests, entry conditions by country of previous education, application route |
| Status | Review only. Nothing in the API is changed. Each item that changes what the website reads needs Platform Admin approval under Decision 266 (G3). Items are tracked as O13–O24 in `WEBSITE-DEVELOPER-REQUIREMENTS.md` |

## 1. Where the spreadsheet asks for entry data

- Every country sheet has two rows:
  - "Courses … entry and English requirements, intakes": Australia `courses` Loaded (the prototype course matrix, 7,855 rows); the other 27 countries `<cc>_courses` To load.
  - "Test requirements: English, local language and admission tests": `courses (test_requirements)`, To add, for all 28.
- Country-specific entry checks:
  - Germany "Entry check for Indian applicants (APS certificate)" (`de_policy_facts`);
  - Poland: NAWA confirmation that a school diploma gives access to higher education (from 1 Jul 2025);
  - Spain: UNEDasiss accreditation;
  - Sweden "English requirements (English 6 / English 7 equivalents)".
- Country overview, column "Test requirements" (accepted tests per country) and column "Application process" (portal, deadlines, intakes).
- Still to confirm: "Course-level English / local language scores are typical levels only — each university's entry requirements page".

## 2. What the API returns today (live check, 12 Nov 2026)

- **Destinations:** only Australia, New Zealand and Canada hold providers and courses (`AU` 1,556, `CA` 1,130, `NZ` 417 providers). The other 25 destinations hold no courses, so they hold no entry data.
- **English tests:** `ref.english_tests` holds `CAE`, `DET`, `IELTS`, `PTE`, `TOEFL_IBT`.
- **Course detail keys:** no teaching language, no admission tests, no application route. The `entry` object carries `min_score`, `min_scores[]`, `benchmark_band`, `prerequisites[]`, `selection_tasks[]`, `requirements_note` and `resolution`.
- **`entry_matrix[]` item keys:** `as_at`, `band`, `conditions`, `country`, `min_grade`, `qualification`, `scale`, `scale_stated`, `study_level`. There is no `quote` and no `source_url`.
- **Coverage within the three countries:** 780 of 29,533 eligible courses have admitted academic entry; 16 providers have an active entry table.

## 3. Missing fields and data

### Language and test requirements

| # | Missing | Spreadsheet evidence | API today |
|---|---|---|---|
| O13 | **Local-language tests:** TestDaF, DSH, Goethe, telc, ÖSD (DE, AT, CH); TCF, TEF, DELF, DALF (FR, Quebec); DELE, SIELE (ES); CILS, CELI, PLIDA, CERT.IT (IT); TOPIK (KR); JLPT (JP); YKI (FI); TISUS (SE); Studieprøven (DK); NT2, CNaVT (NL); Greek certificate (GR, CY) | Country overview "Test requirements" | Five English tests only |
| O14 | **More English tests:** OET, CELPIP, LanguageCert, Michigan English Test, CAEL, MUET, EmSAT English, Oxford Test of English, Trinity ISE, Cambridge C2 Proficiency, UK SELTs (IELTS for UKVI, PTE UKVI) | Australia, Canada, UK, Ireland, Malaysia, UAE, NZ | Not held |
| O15 | **A requirement stated as a level, not a score:** CEFR level (B2, C1), Sweden English 6 / English 7, Denmark English A / B, TOPIK level, JLPT N-level, TestDaF TDN 4 | Most European countries, Korea, Japan | `english_requirements[]` holds a numeric score per test only |
| O16 | **English waiver by country of previous education or English-medium study** | UK (majority English-speaking nationals; degree taught in English with Ecctis check); Germany ("unless previous studies were in English") | Not held; `english_note` is free text |
| O17 | **Teaching language of the course** (decides which language test applies) | Korea and Japan sheets ("show the teaching language"); Country overview "English-taught degrees" | Not held |
| O18 | **Admission tests:** SAT, ACT and test-optional status (US, SG, TH, FI); GMAT, GRE (most countries); UCAT, GAMSAT, LNAT, HPAT, MCAT, LSAT, IMAT, TOLC, MedAT, TestAS, EJU, PCE, TAGE MAGE | Country overview "Test requirements" | Not held |

### Academic entry by country of previous education (R19)

| # | Missing | Spreadsheet evidence | API today |
|---|---|---|---|
| O19 | **Entry conditions that are not grades:** APS certificate (DE, for India, China, Vietnam), NAWA diploma confirmation (PL), UNEDasiss accreditation (ES), foundation or preparatory year (Studienkolleg DE, preparatory year PL, VWU AT), entrance exam for some foreign applicants (CH ECUS) | Germany, Poland, Spain, Austria, Switzerland | Only grade rows; `conditions` is free text |
| O20 | **`quote` and `source_url` on `entry_matrix[]` items** (and `source_url` on `resolution.rows[]`) | Spreadsheet source rule: every value linked to its official source | Missing on matrix items; the approved "check the source" wording (O9) has no link to point to. `min_scores[]` already carries both |
| O21 | **Qualification codes and a qualification list by country of education** in `reference` | Needed for a "your qualification" picker | `qualification` is free text; `study_level` on matrix rows is the provider's own label |
| O22 | **Search by academic entry:** a `has_academic_entry` filter (and optionally `edu_country` on `search`) | Course Finder parity with `has_english` | `search` takes neither |

### Application process

| # | Missing | Spreadsheet evidence | API today |
|---|---|---|---|
| O23 | **Application route and limits:** national or central portal (UCAS, uni-assist, universityadmissions.se, Studyinfo, optagelse.dk, Studielink, Études en France, Universitaly, OUAC, OCAS, Common App), limited places or numerus fixus, application deadline | Country overview "Application process"; `applications (process)` To add | `intakes[].application_deadline` mostly null; no route or limit field. Much of this is country-level reference data, not course data |

### Coverage

| # | Missing | Spreadsheet evidence | API today |
|---|---|---|---|
| O24 | **The other 25 destinations** (UK, IE, US, DE, SE, FI, DK, ES, MT, NL, FR, AT, CH, PL, HU, IT, GR, LV, CY, AE, TH, SG, MY, KR, JP) and **local study-level frameworks** (for example Malta MQF 6–8) | Every country sheet "To load" | `country_codes` AU, NZ, CA; study levels for those three only |

## 4. Suggested order

1. **O20** quote and source link on entry-table rows: the data is held; smallest change.
2. **O13–O17** tests, levels, teaching language and English waivers: reference rows plus additive fields. These map onto the AER v2 country packs (`docs/platform/AER-DESIGN-V2-PROPOSAL.md` §3.9).
3. **O19** non-grade conditions as entry rows of their own type (credential check, foundation required, entrance exam).
4. **O18** admission tests; **O21–O22** qualification codes and search filter.
5. **O23** application route as country reference data.
6. **O24** new destinations: a data programme of its own, registers first (Decision 261).

## 5. Rules that apply

- Additive only on Website API v2; nothing renamed or removed; null means not held.
- Every item from O13 to O23 changes what the website reads, so each needs the Platform Admin's explicit approval (Decision 266), recorded in its migration, with the consumer API baseline re-taken.
- Each approved item gets a developer guide issue with a section 13 line.
- Values are kept as printed. No grade or score is converted between countries, and the API never decides eligibility.
