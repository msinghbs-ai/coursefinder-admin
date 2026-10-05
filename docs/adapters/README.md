# University Adapter Register

**Status:** CURRENT · **Decision:** 254 (design reference v1.4) · **Change control:** CF-CHG-20260915-247 · **As at:** 5 Oct 2026, 18:51 AEDT
**Design and decision document:** `docs/coursefinder-university-adapters-v1.0.md`

This register lists every target university and its adapter state, with each adapter's reviewed configuration in `configs/`. The live configuration is held in the database (`pipeline.uni_adapters`) and edited in the PIM Admin (Models & services › University adapters). The files here are the reviewed baseline for production. Re-export them at every release gate, and whenever an adapter is admitted or changed.


> **Adapter pattern sheet (6 Oct 2026):** for every provider worked so far, `ADAPTER-PATTERN-SHEET.md` (and `adapter-pattern-sheet.csv`) shows where intakes, fees, English and delivery sit on the provider's site. It also shows the special adapter settings, central pages, blockers and next step. `ADAPTER-LESSONS.md` is the playbook of lessons learnt. Both are rebuilt after every adapter wave. This register's university tables below remain the reviewed baseline for the target universities.

## How to read this register

- **Next step** for each university comes from the adapter evaluation rules (settings under Firecrawl › Adapter evaluation) and is shown in the live panel, not in this register.
- **Wave** is the planned build order, five adapters at a time, each wave with a NZ and a CA university (see section 5 of the design document, amended 23:41). The Wave column below follows the amended plan.
- **Adapter** is the live state: None, Testing (enabled, not admitting), or Admitting (enabled, admission on for the fields shown in the table above).
- **Wave** shows "Done (wave N)" once the adapter built in that wave is admitting. Waves 1 to 5 ran on 5 Oct 2026 (see the M2.4.7 runsheet entry of 07:30), wave 6 by 08:35, wave 7 by 09:30 and wave 8, the last of the target list, by 10:30 (entries of the same times). From wave 6, each wave had about 11 universities. Every target university has now been through a wave. Wave 9 (entry of 11:35) went beyond the target list to 25 more providers, mostly polytechnics and TAFEs; they are listed in their own table below. From 11:48 to 18:04 (entry of 18:04) adapters were moved to the international view and given delivery, exit awards and entry requirements, and MacEwan got a calendar adapter in testing. "Waiting on decision" means the next step waits on one of the open decisions in section 14 of the design document.

## Adapters with a configuration

76 adapters are configured: 65 admitting and 11 testing. 2161 course exclusions are active (2159 on adapters). 126 central pages are attached for 64 providers. All figures are from the live database at the time above. Calgary (draft only), Notre Dame, Fraser Valley and Kwantlen have no adapter, so they have no configuration and appear only in the table of all target universities. MacEwan has a calendar adapter in testing (level and credits only). Kwantlen has 2 active exclusions without an adapter (median-earnings figures read as fees), which are counted in the total above. NorthTec, WITT and Whitireia and WelTec are divisions of one catalogue provider (New Zealand Institute of Skills and Technology), each with its own provider record and adapter; their configurations keep the catalogue name as `catalogue_name`. Admitted fields now include delivery and exit awards (5 Oct, 11:48 and 15:22).

**Admission by field.** An adapter that is admitting only overwrites the fields ticked for it (intakes, English, fees). A university can be right on one field and wrong on another, so each field is switched on by itself.

**Course exclusions.** A single course can be excluded for one field, with a written reason. An excluded course keeps its held value for that field. Exclusions are switched off when no longer needed, never deleted.

**English rule and Calendar** show each university's central rule, from the latest proposal of that kind: Approved first, then Proposed (waiting in Layer 4 Review › Attributes), then No values (the page was read but no rule was found). A dash means no central page has been read. This is the same rule the Universities tab uses (Coverage & completeness › Universities). An approved English rule fills only courses that have no English requirement from their own page.

**Central pages** counts the central English and key-dates pages a Platform Admin has attached (each configuration file lists them, with the English proposals still waiting).

| University | State | Admitted fields | Admitted on | Active exclusions | English rule | Calendar | Central pages | Configuration | Notes |
|---|---|---|---|---:|---|---|---:|---|---|
| Murdoch University (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 06:08 AEDT | 0 | No values | No values | 0 | `configs/au-murdoch-university.json` | 178 intakes, 160 fees, 41 IELTS held after the overwrite. |
| University of Canterbury (NZ) | Admitting | intakes, English, fees | 5 Oct 2026, 06:08 AEDT | 3 | — | — | 0 | `configs/nz-university-of-canterbury.json` | 148 intakes and 70 fees held after the overwrite. |
| James Cook University (AU) | Admitting | intakes, fees | 5 Oct 2026, 06:29 AEDT | 1 | No values | Proposed | 2 | `configs/au-james-cook-university.json` | 20 intakes and 2 fees. Diploma of Higher Education fee (Singapore) excluded. IELTS held. |
| Thompson Rivers University (CA) | Admitting | intakes | 5 Oct 2026, 06:29 AEDT | 0 | — | — | 0 | `configs/ca-thompson-rivers-university.json` | 36 intakes. No fee reader (per-semester calculator only). |
| Western Sydney University (AU) | Admitting | intakes, fees | 5 Oct 2026, 07:06 AEDT | 18 | Approved | No values | 1 | `configs/au-western-sydney-university.json` | 138 intakes and 21 fees. 7 intakes and 6 fees excluded. |
| Queensland University of Technology (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 08:31 AEDT | 3 | Approved | No values | 2 | `configs/au-queensland-university-of-technology.json` | Wave 6. 140 intakes, 122 fees, 138 IELTS held = adapter. 3 general-reader readings excluded. |
| The University of Queensland (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 08:31 AEDT | 4 | Approved | Proposed | 1 | `configs/au-the-university-of-queensland.json` | Wave 6. 316 intakes, 312 fees, 316 IELTS held = adapter. 3 fees held back. |
| University of Tasmania (AU) | Admitting | intakes, English | 5 Oct 2026, 09:27 AEDT | 4 | Approved | Proposed | 1 | `configs/au-university-of-tasmania.json` | Wave 7. 96 intakes, 39 IELTS. Fees held: annual figures for years that are not 100 credit points (decision). |
| University of Northern British Columbia (CA) | Admitting | intakes, fees | 5 Oct 2026, 10:23 AEDT | 1 | Approved | No values | 2 | `configs/ca-university-of-northern-british-columbia.json` | Wave 8. 3 intakes, 2 fees. Most bindings are calendar pages. |
| Nelson Marlborough Institute of Technology (NMIT) (NZ) | Admitting | intakes, English | 5 Oct 2026, 11:21 AEDT | 71 | Approved | — | 2 | `configs/nz-nelson-marlborough-institute-of-technology.json` | Wave 9. Intakes and English admitted. All fees held back (domestic). |
| Ara Institute of Canterbury (NZ) | Admitting | intakes, English, fees | 5 Oct 2026, 11:21 AEDT | 14 | Approved | — | 2 | `configs/nz-ara-institute-of-canterbury.json` | Wave 9. All fields admitted. 6 fees, 5 intakes and 3 English held back. |
| Unitec (NZ) | Admitting | intakes, English, fees | 5 Oct 2026, 11:29 AEDT | 13 | Approved | — | 1 | `configs/nz-unitec.json` | Wave 9. All fields admitted. 13 readings held back. |
| Waikato Institute of Technology (Wintec) (NZ) | Admitting | intakes, delivery | 5 Oct 2026, 12:08 AEDT | 73 | — | — | 2 | `configs/nz-waikato-institute-of-technology.json` | Wave 9. Intakes admitted. All fees held back (domestic), 3 intakes. |
| University of Alberta (CA) | Admitting | English, delivery | 5 Oct 2026, 12:09 AEDT | 3 | Approved | — | 1 | `configs/ca-university-of-alberta.json` | Wave 6. 16 IELTS. No fee or start dates on the pages. |
| Charles Sturt University (AU) | Admitting | intakes, English, fees, delivery | 5 Oct 2026, 12:10 AEDT | 17 | Approved | Proposed | 2 | `configs/au-charles-sturt-university.json` | Wave 9. All fields admitted. 15 fees (2026 tables, study abroad, Master of Philosophy) and 2 intakes held back. |
| TAFE South Australia (AU) | Admitting | intakes, English, fees, delivery | 5 Oct 2026, 12:10 AEDT | 16 | Approved | No values | 3 | `configs/au-tafe-south-australia.json` | Wave 9. All fields admitted. 15 fees held back. |
| University of Wollongong (AU) | Admitting | intakes, English, delivery | 5 Oct 2026, 12:10 AEDT | 2 | No values | Proposed | 1 | `configs/au-university-of-wollongong.json` | Wave 6. 208 intakes, 210 IELTS. No annual fee published. |
| TAFE International Western Australia (AU) | Admitting | intakes, English, delivery | 5 Oct 2026, 12:10 AEDT | 94 | Approved | No values | 2 | `configs/au-tafe-international-western-australia.json` | Wave 9. Intakes and English admitted. All fees held back (semester or whole-course totals). |
| Australia Institute of Business and Technology (AIBT) (AU) | Admitting | intakes, English, fees, delivery | 5 Oct 2026, 12:11 AEDT | 27 | — | No values | 0 | `configs/au-australia-institute-of-business-and-technology.json` | Wave 9. All fields admitted. 9 fees (52 weeks on the page, longer in the catalogue) and 9 older CRICOS codes held back. |
| Edith Cowan University (AU) | Admitting | intakes, English, fees, delivery | 5 Oct 2026, 12:11 AEDT | 17 | Approved | Proposed | 1 | `configs/au-edith-cowan-university.json` | Wave 7. 144 intakes, 138 fees, 149 IELTS held = adapter. Graduate certificate totals and 4 domestic-only pages excluded. |
| Southern Institute of Technology (NZ) | Admitting | intakes, English, delivery | 5 Oct 2026, 12:11 AEDT | 39 | — | — | 1 | `configs/nz-southern-institute-of-technology.json` | Wave 9. Intakes and English admitted. All general-reader fees held back. |
| Vancouver Island University (CA) | Admitting | intakes, fees, delivery | 5 Oct 2026, 12:11 AEDT | 4 | Approved | — | 1 | `configs/ca-vancouver-island-university.json` | 27 intakes and 25 fees. Liberal Studies and Global Studies (cancelled) excluded. |
| Alphacrucis College (AU) | Admitting | intakes, English, delivery | 5 Oct 2026, 12:11 AEDT | 1 | Approved | No values | 4 | `configs/au-alphacrucis-college.json` | Wave 9. Intakes and English admitted. Fees held back (domestic per-subject only). The parser English proposal (7.0 for every level) was to be rejected; it was superseded at 11:35 by the written-out rule. |
| Lincoln University (NZ) | Admitting | intakes, fees, delivery | 5 Oct 2026, 12:11 AEDT | 14 | Approved | No values | 2 | `configs/nz-lincoln-university.json` | 57 intakes and 30 fees. LI0511 intakes excluded. |
| Swinburne University of Technology (AU) | Admitting | intakes, English, delivery | 5 Oct 2026, 12:11 AEDT | 6 | Approved | Proposed | 1 | `configs/au-swinburne-university-of-technology.json` | Wave 6. 212 intakes, 219 IELTS. Fees held: pages show 2026, the catalogue holds 2027 (decision). |
| Manukau Institute of Technology (NZ) | Admitting | intakes, English, fees, delivery | 5 Oct 2026, 12:12 AEDT | 46 | — | — | 1 | `configs/nz-manukau-institute-of-technology.json` | Wave 9. All fields admitted. 9 pages not for international students and 6 fees held back. |
| Whitireia and WelTec (NZIST) (NZ) | Admitting | intakes, English, fees, delivery | 5 Oct 2026, 12:12 AEDT | 3 | Approved | — | 3 | `configs/nz-whitireia-and-weltec.json` | Wave 9. All fields admitted. 8 fees and 1 intake held back. NZIST division; catalogue name is New Zealand Institute of Skills and Technology. |
| Deakin University (AU) | Admitting | intakes, English, fees, delivery | 5 Oct 2026, 12:14 AEDT | 91 | Approved | Proposed | 1 | `configs/au-deakin-university.json` | Wave 6. 144 intakes, 189 fees, 185 IELTS held = adapter. Domestic-view pages and site-menu months excluded. |
| Eastern Institute of Technology (EIT) (NZ) | Admitting | intakes, English, delivery | 5 Oct 2026, 12:14 AEDT | 75 | Approved | — | 3 | `configs/nz-eastern-institute-of-technology.json` | Wave 9. Intakes and English admitted. 37 courses not offered to international students held back. |
| Otago Polytechnic (NZ) | Admitting | intakes, English, fees, delivery | 5 Oct 2026, 12:14 AEDT | 30 | — | — | 2 | `configs/nz-otago-polytechnic.json` | Wave 9. All fields admitted. 30 readings held back. |
| Collarts (AU) | Admitting | intakes, delivery | 5 Oct 2026, 12:15 AEDT | 20 | Approved | Proposed | 2 | `configs/au-collarts.json` | Wave 9. Intakes admitted. 12 intakes and 8 wrong catalogue fees held back. |
| University of the Sunshine Coast (AU) | Admitting | intakes, fees, delivery | 5 Oct 2026, 12:15 AEDT | 29 | Approved | No values | 2 | `configs/au-university-of-the-sunshine-coast.json` | 93 intakes and 23 fees. Fees admitted from 07:36 under the fee-year rule; 28 fee readings excluded (2024/2025 tables, not annual, 2026 label with 2027 figures). |
| Massey University (NZ) | Admitting | intakes, fees, delivery | 5 Oct 2026, 12:16 AEDT | 3 | — | — | 0 | `configs/nz-massey-university.json` | 10 intakes and 79 fees. 3 fees excluded (GDDRS, UDBRB, UBAVT). |
| TAFE Queensland (AU) | Admitting | English, fees, delivery | 5 Oct 2026, 12:16 AEDT | 82 | Approved | Proposed | 3 | `configs/au-tafe-queensland.json` | Wave 9. English and fees admitted. Intakes held back. |
| Central Queensland University (AU) | Admitting | intakes, English, fees, delivery | 5 Oct 2026, 12:18 AEDT | 0 | Approved | Approved | 1 | `configs/au-central-queensland-university.json` | 66 intakes, 66 fees, 55 IELTS. Rebound to handbook pages for the international view. |
| Charles Darwin University (AU) | Admitting | intakes, fees, delivery | 5 Oct 2026, 12:18 AEDT | 8 | Approved | Proposed | 1 | `configs/au-charles-darwin-university.json` | 147 intakes and 130 fees. 8 short-course totals excluded. |
| WITT (NZIST) (NZ) | Admitting | English, fees, delivery | 5 Oct 2026, 12:18 AEDT | 5 | — | — | 3 | `configs/nz-witt.json` | Wave 9. English and fees admitted. Intakes held back (next intake only). NZIST division; catalogue name is New Zealand Institute of Skills and Technology. |
| University of Lethbridge (CA) | Admitting | intakes, delivery | 5 Oct 2026, 12:20 AEDT | 9 | Approved | No values | 2 | `configs/ca-university-of-lethbridge.json` | Wave 7. 3 intakes. 186 courses bound to the wrong pages (decision). |
| University of New England (AU) | Admitting | intakes, fees, delivery | 5 Oct 2026, 12:20 AEDT | 14 | Approved | Proposed | 1 | `configs/au-university-of-new-england.json` | Wave 8. 89 intakes, 99 fees. Online-only courses, short-course totals and the 2027 fee list excluded; 82 courses narrowed to their international on-campus months. |
| University of British Columbia (CA) | Admitting | intakes, English, fees, delivery | 5 Oct 2026, 12:21 AEDT | 39 | Approved | Proposed | 2 | `configs/ca-university-of-british-columbia.json` | Wave 8. 196 intakes, 216 fees, 220 IELTS held = adapter (graduate programme pages). Short course-based programme fees and wrong-campus pages excluded. |
| Auckland University of Technology (NZ) | Admitting | intakes, English, delivery | 5 Oct 2026, 12:21 AEDT | 75 | Approved | No values | 2 | `configs/nz-auckland-university-of-technology.json` | Wave 7. 137 intakes, 138 IELTS. Fees held: tuition only or with the student services levy (decision). |
| Adelaide University (AU) | Admitting | intakes, English, fees, delivery | 5 Oct 2026, 12:21 AEDT | 64 | Approved | Approved | 2 | `configs/au-adelaide-university.json` | Wave 7. 229 intakes, 199 fees, 246 IELTS held = adapter. Half-year and online totals, and online intakes, excluded. |
| Melbourne Polytechnic (AU) | Admitting | intakes, English, fees, delivery | 5 Oct 2026, 12:21 AEDT | 77 | Approved | Proposed | 4 | `configs/au-melbourne-polytechnic.json` | Wave 9. All fields admitted. 27 not-for-international, closed or old-registration courses held back. |
| Monash University (AU) | Admitting | intakes, English, fees, delivery | 5 Oct 2026, 12:28 AEDT | 17 | Approved | Proposed | 1 | `configs/au-monash-university.json` | Wave 7. 266 intakes, 262 fees, 260 IELTS held = adapter. Scholarship and domestic fees, 2 intakes held back. |
| Royal Roads University (CA) | Admitting | intakes, delivery | 5 Oct 2026, 12:29 AEDT | 15 | — | — | 0 | `configs/ca-royal-roads-university.json` | 13 intakes. Scholarship amounts excluded as fees (pages print whole-program tuition only). |
| Torrens University Australia (AU) | Admitting | intakes, English, delivery | 5 Oct 2026, 12:29 AEDT | 49 | No values | Proposed | 1 | `configs/au-torrens-university-australia.json` | Wave 9. Intakes and English admitted. 29 intakes and 20 English held back (single past starts, shared pages). |
| Athabasca University (CA) | Admitting | intakes, fees, delivery | 5 Oct 2026, 13:41 AEDT | 1 | Approved | No values | 11 | `configs/ca-athabasca-university.json` | Wave 8. Testing only: online only, no study permit (decision). |
| UNSW Sydney (AU) | Admitting | intakes, fees, delivery | 5 Oct 2026, 15:11 AEDT | 40 | Approved | Proposed | 2 | `configs/au-unsw-sydney.json` | Wave 9. Intakes and fees admitted. 34 fees held back (graduate certificate totals, borderline graduate diplomas, 6 wrong bindings). The English rule failed the agreement check (catalogue holds 6.0). |
| Toi Ohomai Institute of Technology (NZ) | Admitting | English, delivery | 5 Oct 2026, 15:14 AEDT | 0 | — | No values | 3 | `configs/nz-toi-ohomai-institute-of-technology.json` | Wave 9. English admitted. Intakes held back (domestic view). |
| Flinders University (AU) | Admitting | intakes, English, fees, delivery | 5 Oct 2026, 15:18 AEDT | 7 | Approved | No values | 0 | `configs/au-flinders-university.json` | 174 intakes and 158 fees held after the overwrite. English from the central policy. |
| The University of Sydney (AU) | Admitting | intakes, delivery | 5 Oct 2026, 15:20 AEDT | 82 | Approved | Proposed | 2 | `configs/au-the-university-of-sydney.json` | Wave 7. 21 intakes. Domestic-view pages; fee and IELTS load in the browser. |
| Victoria University (AU) | Admitting | intakes, English, delivery | 5 Oct 2026, 15:24 AEDT | 198 | Approved | Proposed | 1 | `configs/au-victoria-university.json` | Wave 7. 7 IELTS. Domestic-view pages; per-semester fees (decision). |
| Australian Catholic University (AU) | Admitting | intakes, English, fees, delivery | 5 Oct 2026, 15:27 AEDT | 3 | No values | Approved | 2 | `configs/au-australian-catholic-university.json` | 90 intakes and 25 IELTS. 3 intakes excluded. Fees wait on the international view. |
| Curtin University (AU) | Admitting | intakes, English, fees, delivery | 5 Oct 2026, 15:31 AEDT | 31 | Approved | Proposed | 1 | `configs/au-curtin-university.json` | Wave 6. 202 intakes, 3 fees, 257 IELTS held = adapter. Fees wait on the international view. |
| University of Waikato (NZ) | Admitting | intakes, fees, delivery | 5 Oct 2026, 15:31 AEDT | 18 | Approved | No values | 2 | `configs/nz-university-of-waikato.json` | 70 intakes and 21 fees. WI0250 intakes and 3 sub-year fees excluded. |
| University of Victoria (CA) | Admitting | intakes, English, fees, delivery | 5 Oct 2026, 15:32 AEDT | 14 | Approved | No values | 2 | `configs/ca-university-of-victoria.json` | Wave 6. 70 intakes, 3 IELTS. No international fee on the pages. |
| University of Technology Sydney (AU) | Admitting | intakes, English, fees, delivery | 5 Oct 2026, 15:33 AEDT | 2 | No values | Proposed | 0 | `configs/au-university-of-technology-sydney.json` | 130 intakes, 307 IELTS read. International fees need the fee PDF. |
| The University of Newcastle (AU) | Admitting | English, fees | 5 Oct 2026, 15:33 AEDT | 34 | Approved | Proposed | 3 | `configs/au-the-university-of-newcastle.json` | Wave 9. English admitted. Intakes held back (domestic first term); fees held back (browser only). |
| La Trobe University (AU) | Admitting | intakes, English, fees, delivery, exit awards | 5 Oct 2026, 16:05 AEDT | 1 | Approved | No values | 0 | `configs/au-la-trobe-university.json` | 100 intakes, 100 fees, 95 IELTS from the international view. Dental fee to confirm. |
| University of Canberra (AU) | Admitting | intakes, English, delivery, exit awards | 5 Oct 2026, 17:03 AEDT | 52 | Approved | No values | 1 | `configs/au-university-of-canberra.json` | Wave 7. 94 intakes, 97 IELTS. Fees are not on the stored pages (the browser loads them). |
| Federation University Australia (AU) | Admitting | English, fees | 5 Oct 2026, 17:07 AEDT | 64 | Approved | Proposed | 1 | `configs/au-federation-university-australia.json` | Wave 7. 9 fees, 100 IELTS. Intakes held: domestic-view pages. |
| Southern Cross University (AU) | Admitting | intakes, English, fees, delivery, exit awards | 5 Oct 2026, 17:10 AEDT | 30 | Approved | Proposed | 1 | `configs/au-southern-cross-university.json` | Wave 8. 87 intakes, 85 fees, 91 IELTS held = adapter. Pages with a 2027 fee and no printed year excluded. |
| Griffith University (AU) | Admitting | English, fees, delivery, exit awards | 5 Oct 2026, 17:16 AEDT | 0 | No values | No values | 1 | `configs/au-griffith-university.json` | 252 fees and 252 IELTS. Intakes held: the 2027 calendar has T1 March, T2 July, T3 September, not Feb/Jul/Oct. |
| RMIT University (AU) | Admitting | English, fees, delivery, exit awards | 5 Oct 2026, 17:17 AEDT | 2 | Approved | Proposed | 1 | `configs/au-rmit-university.json` | Wave 6. 271 fees, 362 IELTS. Intakes held: 56 pages list fewer intakes than held (decision). |
| The University of Melbourne (AU) | Admitting | intakes, English, fees, delivery, exit awards | 5 Oct 2026, 17:23 AEDT | 16 | No values | Proposed | 0 | `configs/au-the-university-of-melbourne.json` | 89 intakes held after the overwrite. No fee or IELTS on stored pages. |
| Australian National University (AU) | Testing | — | — | 24 | No values | No values | 0 | `configs/au-australian-national-university.json` | Not admitted: needs central start dates and English (second-page source). |
| Bond University Limited (AU) | Testing | — | — | 4 | No values | No values | 0 | `configs/au-bond-university-limited.json` | Not admitted: fees are per semester only, and IELTS is on a second page. |
| Grant MacEwan University (CA) | Testing | — | — | 4 | Approved | No values | 4 | `configs/ca-grant-macewan-university.json` | 18:04 export. Testing only: bespoke calendar adapter (Platform Admin 12:12) reads level and credits from the 2027-2028 calendar programme pages; no intakes, English, fee or delivery pattern, so nothing is admitted. |
| Macquarie University (AU) | Testing | — | — | 131 | No values | No values | 0 | `configs/au-macquarie-university.json` | Not admitted: page-data fee path saved, 0 fees read. |
| Mount Royal University (CA) | Testing | — | — | 0 | — | — | 0 | `configs/ca-mount-royal-university.json` | Not admitted: nothing admissible (fee, English and start months are central only). |
| NorthTec (NZIST) (NZ) | Testing | — | — | 134 | — | — | 1 | `configs/nz-northtec.json` | Wave 9. Testing only, not admitted: 40 courses bound to the academic-calendar document. NZIST division; catalogue name is New Zealand Institute of Skills and Technology. |
| Simon Fraser University (CA) | Testing | — | — | 4 | — | — | 0 | `configs/ca-simon-fraser-university.json` | Not admitted: 3 intakes only. |
| TAFE NSW (AU) | Testing | — | — | 3 | No values | Proposed | 3 | `configs/au-tafe-nsw.json` | Wave 9. Testing only, not admitted: no usable fields. |
| The Open Polytechnic of New Zealand (NZ) | Testing | — | — | 2 | — | — | 0 | `configs/nz-open-polytechnic.json` | Wave 9. Testing only, not admitted: distance study only. |
| The University of Western Australia (AU) | Testing | — | — | 0 | No values | Proposed | 0 | `configs/au-the-university-of-western-australia.json` | Not admitted: fees only in the fee calculator. |
| University of Auckland (NZ) | Testing | — | — | 62 | — | — | 0 | `configs/nz-university-of-auckland.json` | Not admitted: 45 intakes differ from held values. |

## All target universities (57)

Rebuilt from the live database at the time above, with the same figures as the Universities tab. "Held" counts courses with a value, whatever its source; the brackets show how many came from an adapter and from a central rule. The page-finding columns of earlier versions (confirmed page, no page, not readable, next step) now live in the PIM Admin evaluation panel.

| University | Country | Courses | Pages read | Intakes held (adapter / central) | English held (adapter / central) | Fees held (adapter) | Adapter | English rule | Calendar | Wave |
|---|---|---:|---:|---|---|---|---|---|---|---|
| Flinders University | AU | 476 | 336 | 223 (61 / 0) | 305 (0 / 197) | 208 (115) | Admitting | Approved | No values | Done |
| Macquarie University | AU | 461 | 270 | 82 (19 / 0) | 111 (6 / 0) | 0 (0) | Testing | No values | No values | Wave 1, testing (not admitted) |
| The University of Western Australia | AU | 327 | 283 | 76 (68 / 0) | 154 (25 / 0) | 0 (0) | Testing | No values | Proposed | Wave 2, testing (not admitted) |
| Australian National University | AU | 423 | 322 | 18 (0 / 0) | 0 (0 / 0) | 7 (0) | Testing | No values | No values | Wave 1, testing (not admitted) |
| The University of Melbourne | AU | 441 | 380 | 160 (82 / 0) | 156 (156 / 0) | 139 (136) | Admitting | No values | Proposed | Done (wave 1) |
| Murdoch University | AU | 267 | 224 | 181 (178 / 0) | 42 (3 / 0) | 160 (160) | Admitting | No values | No values | Done (wave 2) |
| La Trobe University | AU | 248 | 240 | 160 (40 / 0) | 176 (38 / 58) | 170 (137) | Admitting | Approved | No values | Done (wave 3) |
| Simon Fraser University | CA | 208 | 152 | 39 (3 / 0) | 0 (0 / 0) | 0 (0) | Testing | — | — | Wave 1, testing (not admitted) |
| Bond University Limited | AU | 180 | 162 | 132 (97 / 0) | 0 (0 / 0) | 0 (0) | Testing | No values | No values | Wave 3, testing (not admitted) |
| Griffith University | AU | 297 | 261 | 261 (261 / 0) | 255 (252 / 0) | 258 (17) | Admitting | No values | No values | Done (wave 3) |
| James Cook University | AU | 127 | 122 | 21 (20 / 0) | 16 (5 / 0) | 2 (2) | Admitting | No values | Proposed | Done (wave 4) |
| Charles Darwin University | AU | 175 | 153 | 147 (147 / 0) | 22 (0 / 15) | 149 (113) | Admitting | Approved | Proposed | Done (wave 4) |
| Central Queensland University | AU | 106 | 88 | 67 (60 / 6) | 63 (46 / 14) | 66 (66) | Admitting | Approved | Approved | Done (wave 4) |
| Mount Royal University | CA | 38 | 33 | 14 (0 / 0) | 0 (0 / 0) | 0 (0) | Testing | — | — | Wave 2, testing (not admitted) |
| Western Sydney University | AU | 325 | 300 | 179 (29 / 0) | 24 (0 / 1) | 181 (121) | Admitting | Approved | No values | Done (wave 5) |
| University of Canterbury | NZ | 280 | 214 | 196 (193 / 0) | 11 (0 / 0) | 95 (95) | Admitting | — | — | Done (wave 1) |
| University of the Sunshine Coast | AU | 148 | 144 | 103 (93 / 0) | 2 (0 / 0) | 128 (23) | Admitting | Approved | No values | Done (wave 5) |
| Australian Catholic University | AU | 149 | 143 | 114 (104 / 9) | 52 (23 / 0) | 112 (8) | Admitting | No values | Approved | Done (wave 5) |
| Thompson Rivers University | CA | 76 | 48 | 36 (36 / 0) | 0 (0 / 0) | 0 (0) | Admitting | — | — | Done (wave 3) |
| Vancouver Island University | CA | 44 | 32 | 30 (27 / 0) | 0 (0 / 0) | 25 (25) | Admitting | Approved | — | Done (wave 4) |
| Royal Roads University | CA | 31 | 17 | 13 (13 / 0) | 0 (0 / 0) | 0 (0) | Admitting | — | — | Done (wave 5) |
| The University of Sydney | AU | 655 | 432 | 32 (23 / 0) | 487 (0 / 482) | 0 (0) | Admitting | Approved | Proposed | Done (wave 7) |
| University of British Columbia | CA | 575 | 326 | 228 (224 / 0) | 255 (254 / 0) | 256 (256) | Admitting | Approved | Proposed | Done (wave 8) |
| University of Alberta | CA | 379 | 222 | 1 (0 / 0) | 22 (16 / 0) | 0 (0) | Admitting | Approved | — | Done (wave 6) |
| University of Technology Sydney | AU | 530 | 360 | 302 (131 / 0) | 310 (187 / 0) | 268 (123) | Admitting | No values | Proposed | Done (wave 2) |
| Monash University | AU | 582 | 385 | 308 (287 / 0) | 288 (284 / 0) | 306 (294) | Admitting | Approved | Proposed | Done (wave 7) |
| Curtin University | AU | 373 | 293 | 234 (13 / 0) | 262 (8 / 0) | 261 (251) | Admitting | Approved | Proposed | Done (wave 6) |
| University of Auckland | NZ | 458 | 327 | 220 (213 / 0) | 107 (0 / 0) | 12 (0) | Testing | — | — | Wave 2, testing (not admitted) |
| Victoria University of Wellington | NZ | 273 | 0 | 0 (0 / 0) | 0 (0 / 0) | 0 (0) | None | Approved | No values | Wave 6, waiting on decision |
| University of Otago | NZ | 252 | 4 | 1 (0 / 0) | 1 (0 / 0) | 0 (0) | None | Approved | Proposed | Wave 6, waiting on decision |
| Massey University | NZ | 265 | 166 | 16 (10 / 0) | 20 (2 / 0) | 81 (81) | Admitting | — | — | Done (wave 3) |
| University of Waikato | NZ | 278 | 114 | 104 (5 / 0) | 0 (0 / 0) | 51 (20) | Admitting | Approved | No values | Done (wave 5) |
| Victoria University | AU | 280 | 134 | 120 (46 / 0) | 107 (61 / 12) | 0 (0) | Admitting | Approved | Proposed | Done (wave 7) |
| University of Victoria | CA | 234 | 139 | 94 (70 / 0) | 6 (3 / 0) | 1 (1) | Admitting | Approved | No values | Done (wave 6) |
| University of Lethbridge | CA | 199 | 164 | 78 (77 / 0) | 0 (0 / 0) | 0 (0) | Admitting | Approved | No values | Done (wave 7) |
| Swinburne University of Technology | AU | 412 | 238 | 216 (213 / 0) | 227 (221 / 0) | 114 (0) | Admitting | Approved | Proposed | Done (wave 6) |
| University of Calgary | CA | 179 | 22 | 1 (0 / 0) | 0 (0 / 0) | 0 (0) | None | Approved | No values | Wave 7, waiting on decision |
| University of Tasmania | AU | 221 | 123 | 99 (97 / 0) | 83 (40 / 0) | 37 (0) | Admitting | Approved | Proposed | Done (wave 7) |
| Lincoln University | NZ | 199 | 91 | 77 (71 / 0) | 3 (0 / 0) | 72 (58) | Admitting | Approved | No values | Done (wave 4) |
| Adelaide University | AU | 498 | 252 | 239 (231 / 0) | 463 (234 / 227) | 203 (201) | Admitting | Approved | Approved | Done (wave 7) |
| The University of Notre Dame Australia | AU | 131 | 0 | 0 (0 / 0) | 0 (0 / 0) | 0 (0) | None | Approved | No values | Wave 8, waiting on decision |
| Federation University Australia | AU | 195 | 125 | 105 (95 / 0) | 112 (93 / 0) | 112 (0) | Admitting | Approved | Proposed | Done (wave 7) |
| University of Northern British Columbia | CA | 76 | 47 | 19 (3 / 0) | 0 (0 / 0) | 2 (2) | Admitting | Approved | No values | Done (wave 8) |
| University of Canberra | AU | 212 | 121 | 113 (93 / 0) | 182 (96 / 81) | 1 (0) | Admitting | Approved | No values | Done (wave 7) |
| Athabasca University | CA | 50 | 50 | 35 (33 / 0) | 0 (0 / 0) | 39 (0) | Admitting | Approved | No values | Wave 8, testing only (waiting on decision) |
| Grant MacEwan University | CA | 44 | 43 | 0 (0 / 0) | 0 (0 / 0) | 0 (0) | Testing | Approved | No values | Wave 8, testing (calendar adapter, waiting on decision) |
| University of the Fraser Valley | CA | 44 | 11 | 10 (0 / 0) | 0 (0 / 0) | 0 (0) | None | Approved | No values | Wave 8, waiting on decision |
| Kwantlen Polytechnic University | CA | 37 | 7 | 2 (0 / 0) | 0 (0 / 0) | 0 (0) | None | Approved | Proposed | Wave 8, waiting on decision |
| RMIT University | AU | 507 | 390 | 314 (83 / 0) | 369 (109 / 0) | 354 (129) | Admitting | Approved | Proposed | Done (wave 6) |
| University of Wollongong | AU | 367 | 341 | 243 (239 / 0) | 250 (239 / 0) | 0 (0) | Admitting | No values | Proposed | Done (wave 6) |
| Auckland University of Technology | NZ | 257 | 200 | 155 (145 / 0) | 158 (146 / 0) | 7 (0) | Admitting | Approved | No values | Done (wave 7) |
| Queensland University of Technology | AU | 294 | 210 | 189 (185 / 0) | 236 (173 / 63) | 162 (162) | Admitting | Approved | No values | Done (wave 6) |
| Edith Cowan University | AU | 172 | 155 | 145 (144 / 0) | 150 (149 / 0) | 144 (138) | Admitting | Approved | Proposed | Done (wave 7) |
| Southern Cross University | AU | 153 | 128 | 101 (87 / 0) | 118 (90 / 6) | 89 (85) | Admitting | Approved | Proposed | Done (wave 8) |
| University of New England | AU | 130 | 121 | 92 (91 / 0) | 80 (0 / 78) | 107 (101) | Admitting | Approved | Proposed | Done (wave 8) |
| The University of Queensland | AU | 383 | 355 | 332 (316 / 0) | 353 (3 / 1) | 315 (261) | Admitting | Approved | Proposed | Done (wave 6) |
| Deakin University | AU | 252 | 212 | 194 (144 / 0) | 244 (175 / 56) | 197 (191) | Admitting | Approved | Proposed | Done (wave 6) |

## Wave 9 providers outside the target list (25)

Added by wave 9 (entry of 11:35). They are not in the Firecrawl target list of 57 (`security.firecrawl_targets_fast`, included); the figures come from the same functions, keyed by provider. Charles Sturt, Newcastle, Torrens and Toi Ohomai are in the Firecrawl provider list but not marked as included targets.

| University | Country | Courses | Pages read | Intakes held (adapter / central) | English held (adapter / central) | Fees held (adapter) | Adapter | English rule | Calendar | Wave |
|---|---|---:|---:|---|---|---|---|---|---|---|
| Alphacrucis College | AU | 75 | 64 | 55 (54 / 0) | 51 (51 / 0) | 0 (0) | Admitting | Approved | No values | Done (wave 9) |
| Australia Institute of Business and Technology (AIBT) | AU | 58 | 47 | 35 (35 / 0) | 46 (37 / 0) | 16 (16) | Admitting | — | No values | Done (wave 9) |
| Charles Sturt University | AU | 67 | 56 | 33 (32 / 0) | 54 (5 / 42) | 51 (32) | Admitting | Approved | Proposed | Done (wave 9) |
| Collarts | AU | 139 | 94 | 94 (82 / 0) | 81 (0 / 66) | 8 (0) | Admitting | Approved | Proposed | Done (wave 9) |
| Melbourne Polytechnic | AU | 85 | 62 | 44 (36 / 0) | 50 (37 / 0) | 30 (30) | Admitting | Approved | Proposed | Done (wave 9) |
| TAFE International Western Australia | AU | 103 | 89 | 89 (89 / 0) | 89 (89 / 0) | 0 (0) | Admitting | Approved | No values | Done (wave 9) |
| TAFE Queensland | AU | 98 | 87 | 78 (0 / 0) | 63 (63 / 0) | 64 (41) | Admitting | Approved | Proposed | Done (wave 9) |
| TAFE South Australia | AU | 81 | 70 | 37 (35 / 0) | 35 (34 / 0) | 9 (8) | Admitting | Approved | No values | Done (wave 9) |
| The University of Newcastle | AU | 457 | 192 | 180 (3 / 0) | 176 (5 / 0) | 182 (107) | Admitting | Approved | Proposed | Done (wave 9) |
| Torrens University Australia | AU | 182 | 120 | 104 (91 / 0) | 107 (95 / 0) | 0 (0) | Admitting | No values | Proposed | Done (wave 9) |
| UNSW Sydney | AU | 667 | 465 | 459 (445 / 0) | 264 (0 / 255) | 298 (279) | Admitting | Approved | Proposed | Done (wave 9) |
| Ara Institute of Canterbury | NZ | 178 | 85 | 56 (53 / 0) | 82 (76 / 0) | 27 (17) | Admitting | Approved | — | Done (wave 9) |
| Eastern Institute of Technology (EIT) | NZ | 184 | 95 | 36 (28 / 0) | 61 (28 / 0) | 0 (0) | Admitting | Approved | — | Done (wave 9) |
| Manukau Institute of Technology | NZ | 144 | 67 | 37 (36 / 0) | 37 (30 / 0) | 19 (19) | Admitting | — | — | Done (wave 9) |
| Nelson Marlborough Institute of Technology (NMIT) | NZ | 148 | 66 | 60 (54 / 0) | 59 (57 / 0) | 0 (0) | Admitting | Approved | — | Done (wave 9) |
| Otago Polytechnic | NZ | 182 | 62 | 52 (45 / 0) | 56 (35 / 0) | 33 (33) | Admitting | — | — | Done (wave 9) |
| Southern Institute of Technology | NZ | 207 | 128 | 103 (101 / 0) | 95 (93 / 0) | 0 (0) | Admitting | — | — | Done (wave 9) |
| Toi Ohomai Institute of Technology | NZ | 156 | 92 | 73 (73 / 0) | 76 (74 / 0) | 35 (0) | Admitting | — | No values | Done (wave 9) |
| Unitec | NZ | 80 | 48 | 45 (42 / 0) | 41 (26 / 0) | 30 (30) | Admitting | Approved | — | Done (wave 9) |
| WITT (NZIST) | NZ | 89 | 41 | 35 (35 / 0) | 11 (11 / 0) | 11 (11) | Admitting | — | — | Done (wave 9) |
| Waikato Institute of Technology (Wintec) | NZ | 144 | 76 | 71 (66 / 0) | 72 (0 / 0) | 0 (0) | Admitting | — | — | Done (wave 9) |
| Whitireia and WelTec (NZIST) | NZ | 116 | 53 | 24 (24 / 0) | 39 (37 / 0) | 20 (20) | Admitting | Approved | — | Done (wave 9) |
| TAFE NSW | AU | 107 | 100 | 0 (0 / 0) | 0 (0 / 0) | 0 (0) | Testing | No values | Proposed | Wave 9, testing (not admitted) |
| NorthTec (NZIST) | NZ | 123 | 38 | 0 (0 / 0) | 38 (0 / 0) | 0 (0) | Testing | — | — | Wave 9, testing (not admitted) |
| The Open Polytechnic of New Zealand | NZ | 92 | 70 | 4 (4 / 0) | 0 (0 / 0) | 0 (0) | Testing | — | — | Wave 9, testing (not admitted) |

## Live fixes behind the adapters

| Migration | What it changed | Pull request | Check |
|---|---|---|---|
| 20261005001470 | Written-out English rules: fix described in section 14.1 of the design document | Pilot PR #316 | See the 10:30 entry |
| 20261005001480 (`cf247_adapter_requeue_and_stale_extra`) | Applying a text-only adapter no longer sends needs_render pages back for a Firecrawl read; the adapter's page record clears `adapter_extra` when the new reading has none | Pilot PR #317 (merged) | Statement md5 `1f3d0473f87374a289358ff2c48c4148` equals the file in PR #317; recorded live as version 20261005003319 |
| 20261005001490 (`cf247_adapter_delivery_mode`) | Delivery read by adapters (admitted field `delivery`) | Pilot PR #318 (merged as `9f43815`) | Statement md5 `a83044fca347203e7ac750a77dd43c33` equals the file |
| 20261005001500 (`cf247_delivery_wording_and_scholarship_alignment`) | Delivery wording; scholarships aligned (11:48) | Pilot PR #318 (merged as `9f43815`) | Statement md5 `57423f76d6be63fb8bcaffb455e83de1` equals the file |
| 20261005001510 (`cf247_international_view_and_credit_fees`) | International view (`page_view`) and per-credit fees (Athabasca, 12:12 and 13:25) | Pilot PR #318 (merged as `9f43815`) | Statement md5 `b7679e14f24fc3482ab28bb9cf89b317` equals the file |
| 20261005001520 (`cf247_international_view_pages_named`) | International view pages named | Pilot PR #318 (merged as `9f43815`) | Statement md5 `3e06d14ccc9011909951537d3891afd7` equals the file |
| 20261005001530 (`cf247_view_reads_and_course_page_rates`) | View reads and course-page rates | Pilot PR #318 (merged as `9f43815`) | Statement md5 `d4996cea3b524215aadc0a89ceeeddab` equals the file |
| 20261005001540 (`cf247_exit_awards_and_fee_from_total`) | Exit awards (admitted field `exit_awards`) and annual fee from a whole-course fee (`fee_total` / `course_years`) | Pilot PR #318 (merged as `9f43815`) | Statement md5 `b005449824c572e3885a79640a828945` equals the file |
| 20261005001550 (`cf247_location_requirement_exclusion_withdraw`) | Location, entry requirement, exclusion withdrawal | Pilot PR #318 (merged as `9f43815`) | Statement md5 `2b60ad7e513b7e0c8799753aa3ecf00d` equals the file |
| 20261005001560 (`cf247_delivery_from_location_other_requirements`) | Delivery from location; other requirements (16:49) | Pilot PR #318 (merged as `9f43815`) | Statement md5 `a04060d8dfc30d7e85d2a3c820762ea4` equals the file |
| 20261005001570 (`cf247_provider_whole_course_fee_range`) | Whole-course fee range per university (section 16 of the design document) | Pilot PR #318 (merged as `9f43815`) | Statement md5 `0d18058e8436d2988e626af2cf18bfa6` equals the file |

## Recording rule

- When an adapter is set up, changed or admitted, re-export its configuration to `configs/{country}-{university-slug}.json`, including `config` (with `term_months`), `admit_fields`, the active `exclusions` (course code, title, field, reason), `central_rules` (English rule and calendar state, attached central pages, English proposals waiting), `results` and the admit reason and date. `page_roles` is kept where it was written. Update its row above and append an entry to the M2.4.7 runsheet set.
- The export must match the live row field by field (md5 of each pattern, path and pick value). The 4 Oct export of Flinders was checked this way. The 5 Oct 07:30 export of all 26 configurations was checked the same way: every pattern (140) by md5, and each whole `security.uni_adapter_json` value, admit reason and exclusion list against the live rows. The 5 Oct 08:35 export of all 35 configurations was checked the same way: every pattern (189) by md5, plus each whole `security.uni_adapter_json` value, admit reason, exclusion list (222), attached central page (30) and waiting English proposal (by md5 of its content). The 5 Oct 09:30 export of all 45 configurations was checked the same way: every pattern (246) by md5, plus each whole `security.uni_adapter_json` value, admit reason, exclusion list (906), attached central page (46) and waiting English proposal (28). The 5 Oct 10:30 export of all 50 configurations was checked the same way: every pattern (268) by md5, plus each whole `security.uni_adapter_json` value, admit reason, exclusion list (994), attached central page (61) and waiting English proposal (8). The 5 Oct 11:47 export of all 75 configurations was checked the same way: every pattern (404) by md5, plus each whole `security.uni_adapter_json` value, admit reason, exclusion list (1960), attached central page (113) and waiting English proposal (3). The 5 Oct 18:51 export of all 76 configurations was checked the same way: every pattern (526) by md5, plus each whole `security.uni_adapter_json` value (now with `page_view`), admit reason, exclusion list (2159), attached central page (126) and waiting English proposal (none).
