# University Adapter Register

**Status:** CURRENT · **Decision:** 254 (design reference v1.4) · **Change control:** CF-CHG-20260915-247 · **As at:** 5 Oct 2026, 09:30 AEDT
**Design and decision document:** `docs/coursefinder-university-adapters-v1.0.md`

This register lists every target university and its adapter state, with each adapter's reviewed configuration in `configs/`. The live configuration is held in the database (`pipeline.uni_adapters`) and edited in the PIM Admin (Models & services › University adapters). The files here are the reviewed baseline for production. Re-export them at every release gate, and whenever an adapter is admitted or changed.

## How to read this register

- **Next step** for each university comes from the adapter evaluation rules (settings under Firecrawl › Adapter evaluation) and is shown in the live panel, not in this register.
- **Wave** is the planned build order, five adapters at a time, each wave with a NZ and a CA university (see section 5 of the design document, amended 23:41). The Wave column below follows the amended plan.
- **Adapter** is the live state: None, Testing (enabled, not admitting), or Admitting (enabled, admission on for the fields shown in the table above).
- **Wave** shows "Done (wave N)" once the adapter built in that wave is admitting. Waves 1 to 5 ran on 5 Oct 2026 (see the M2.4.7 runsheet entry of 07:30), wave 6 by 08:35 (entry of 08:35) and wave 7 by 09:30 (entry of 09:30). Wave 8 finishes the list. From wave 6, each wave has about 11 universities.

## Adapters with a configuration

45 adapters are configured: 38 admitting and 7 testing. 906 course exclusions are active. 46 central pages are attached for 32 universities. All figures are from the live database at the time above. Calgary has a draft adapter only, so it has no configuration yet and appears only in the table of all target universities.

**Admission by field.** An adapter that is admitting only overwrites the fields ticked for it (intakes, English, fees). A university can be right on one field and wrong on another, so each field is switched on by itself.

**Course exclusions.** A single course can be excluded for one field, with a written reason. An excluded course keeps its held value for that field. Exclusions are switched off when no longer needed, never deleted.

**English rule and Calendar** show each university's central rule, from the latest proposal of that kind: Approved first, then Proposed (waiting in Layer 4 Review › Attributes), then No values (the page was read but no rule was found). A dash means no central page has been read. This is the same rule the Universities tab uses (Coverage & completeness › Universities). An approved English rule fills only courses that have no English requirement from their own page.

**Central pages** counts the central English and key-dates pages a Platform Admin has attached (each configuration file lists them, with the English proposals still waiting).

| University | State | Admitted fields | Admitted on | Active exclusions | English rule | Calendar | Central pages | Configuration | Notes |
|---|---|---|---|---:|---|---|---:|---|---|
| Flinders University (AU) | Admitting | intakes, English, fees | 4 Oct 2026, 22:47 AEDT | 0 | Approved | No values | 0 | `configs/au-flinders-university.json` | 174 intakes and 158 fees held after the overwrite. English from the central policy. |
| Murdoch University (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 06:08 AEDT | 0 | No values | No values | 0 | `configs/au-murdoch-university.json` | 178 intakes, 160 fees, 41 IELTS held after the overwrite. |
| The University of Melbourne (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 06:08 AEDT | 0 | No values | Proposed | 0 | `configs/au-the-university-of-melbourne.json` | 89 intakes held after the overwrite. No fee or IELTS on stored pages. |
| University of Canterbury (NZ) | Admitting | intakes, English, fees | 5 Oct 2026, 06:08 AEDT | 0 | — | — | 0 | `configs/nz-university-of-canterbury.json` | 148 intakes and 70 fees held after the overwrite. |
| University of Technology Sydney (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 06:08 AEDT | 0 | No values | Proposed | 0 | `configs/au-university-of-technology-sydney.json` | 130 intakes, 307 IELTS read. International fees need the fee PDF. |
| Charles Darwin University (AU) | Admitting | intakes, fees | 5 Oct 2026, 06:29 AEDT | 8 | Approved | Proposed | 1 | `configs/au-charles-darwin-university.json` | 147 intakes and 130 fees. 8 short-course totals excluded. |
| Griffith University (AU) | Admitting | English, fees | 5 Oct 2026, 06:29 AEDT | 0 | No values | No values | 1 | `configs/au-griffith-university.json` | 252 fees and 252 IELTS. Intakes held: the 2027 calendar has T1 March, T2 July, T3 September, not Feb/Jul/Oct. |
| James Cook University (AU) | Admitting | intakes, fees | 5 Oct 2026, 06:29 AEDT | 1 | No values | Proposed | 2 | `configs/au-james-cook-university.json` | 20 intakes and 2 fees. Diploma of Higher Education fee (Singapore) excluded. IELTS held. |
| Lincoln University (NZ) | Admitting | intakes, fees | 5 Oct 2026, 06:29 AEDT | 1 | Proposed | No values | 2 | `configs/nz-lincoln-university.json` | 57 intakes and 30 fees. LI0511 intakes excluded. |
| Massey University (NZ) | Admitting | intakes, fees | 5 Oct 2026, 06:29 AEDT | 3 | — | — | 0 | `configs/nz-massey-university.json` | 10 intakes and 79 fees. 3 fees excluded (GDDRS, UDBRB, UBAVT). |
| Thompson Rivers University (CA) | Admitting | intakes | 5 Oct 2026, 06:29 AEDT | 0 | — | — | 0 | `configs/ca-thompson-rivers-university.json` | 36 intakes. No fee reader (per-semester calculator only). |
| Vancouver Island University (CA) | Admitting | intakes, fees | 5 Oct 2026, 06:29 AEDT | 4 | Proposed | — | 1 | `configs/ca-vancouver-island-university.json` | 27 intakes and 25 fees. Liberal Studies and Global Studies (cancelled) excluded. |
| Australian Catholic University (AU) | Admitting | intakes, English | 5 Oct 2026, 07:06 AEDT | 3 | No values | Approved | 2 | `configs/au-australian-catholic-university.json` | 90 intakes and 25 IELTS. 3 intakes excluded. Fees wait on the international view. |
| Central Queensland University (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 07:06 AEDT | 0 | Approved | Approved | 1 | `configs/au-central-queensland-university.json` | 66 intakes, 66 fees, 55 IELTS. Rebound to handbook pages for the international view. |
| La Trobe University (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 07:06 AEDT | 1 | Approved | No values | 0 | `configs/au-la-trobe-university.json` | 100 intakes, 100 fees, 95 IELTS from the international view. Dental fee to confirm. |
| Royal Roads University (CA) | Admitting | intakes | 5 Oct 2026, 07:06 AEDT | 15 | — | — | 0 | `configs/ca-royal-roads-university.json` | 13 intakes. Scholarship amounts excluded as fees (pages print whole-program tuition only). |
| University of Waikato (NZ) | Admitting | intakes, fees | 5 Oct 2026, 07:06 AEDT | 4 | Proposed | No values | 2 | `configs/nz-university-of-waikato.json` | 70 intakes and 21 fees. WI0250 intakes and 3 sub-year fees excluded. |
| Western Sydney University (AU) | Admitting | intakes, fees | 5 Oct 2026, 07:06 AEDT | 13 | Approved | No values | 1 | `configs/au-western-sydney-university.json` | 138 intakes and 21 fees. 7 intakes and 6 fees excluded. |
| University of the Sunshine Coast (AU) | Admitting | intakes, fees | 5 Oct 2026, 07:38 AEDT | 29 | Proposed | No values | 2 | `configs/au-university-of-the-sunshine-coast.json` | 93 intakes and 23 fees. Fees admitted from 07:36 under the fee-year rule; 28 fee readings excluded (2024/2025 tables, not annual, 2026 label with 2027 figures). |
| Curtin University (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 08:31 AEDT | 18 | Proposed | Proposed | 1 | `configs/au-curtin-university.json` | Wave 6. 202 intakes, 3 fees, 257 IELTS held = adapter. Fees wait on the international view. |
| Deakin University (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 08:31 AEDT | 93 | Approved | Proposed | 1 | `configs/au-deakin-university.json` | Wave 6. 144 intakes, 189 fees, 185 IELTS held = adapter. Domestic-view pages and site-menu months excluded. |
| Queensland University of Technology (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 08:31 AEDT | 3 | Approved | No values | 2 | `configs/au-queensland-university-of-technology.json` | Wave 6. 140 intakes, 122 fees, 138 IELTS held = adapter. 3 general-reader readings excluded. |
| RMIT University (AU) | Admitting | English, fees | 5 Oct 2026, 08:31 AEDT | 1 | Proposed | Proposed | 1 | `configs/au-rmit-university.json` | Wave 6. 271 fees, 362 IELTS. Intakes held: 56 pages list fewer intakes than held (decision). |
| Swinburne University of Technology (AU) | Admitting | intakes, English | 5 Oct 2026, 08:31 AEDT | 6 | Proposed | Proposed | 1 | `configs/au-swinburne-university-of-technology.json` | Wave 6. 212 intakes, 219 IELTS. Fees held: pages show 2026, the catalogue holds 2027 (decision). |
| The University of Queensland (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 08:31 AEDT | 4 | Approved | Proposed | 1 | `configs/au-the-university-of-queensland.json` | Wave 6. 316 intakes, 312 fees, 316 IELTS held = adapter. 3 fees held back. |
| University of Alberta (CA) | Admitting | English | 5 Oct 2026, 08:31 AEDT | 3 | No values | — | 1 | `configs/ca-university-of-alberta.json` | Wave 6. 16 IELTS. No fee or start dates on the pages. |
| University of Victoria (CA) | Admitting | intakes, English | 5 Oct 2026, 08:31 AEDT | 10 | No values | No values | 2 | `configs/ca-university-of-victoria.json` | Wave 6. 70 intakes, 3 IELTS. No international fee on the pages. |
| University of Wollongong (AU) | Admitting | intakes, English | 5 Oct 2026, 08:31 AEDT | 2 | Proposed | Proposed | 1 | `configs/au-university-of-wollongong.json` | Wave 6. 208 intakes, 210 IELTS. No annual fee published. |
| Adelaide University (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 09:27 AEDT | 70 | Approved | Approved | 2 | `configs/au-adelaide-university.json` | Wave 7. 229 intakes, 199 fees, 246 IELTS held = adapter. Half-year and online totals, and online intakes, excluded. |
| Auckland University of Technology (NZ) | Admitting | intakes, English | 5 Oct 2026, 09:27 AEDT | 73 | No values | No values | 2 | `configs/nz-auckland-university-of-technology.json` | Wave 7. 137 intakes, 138 IELTS. Fees held: tuition only or with the student services levy (decision). |
| Edith Cowan University (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 09:27 AEDT | 17 | Proposed | Proposed | 1 | `configs/au-edith-cowan-university.json` | Wave 7. 144 intakes, 138 fees, 149 IELTS held = adapter. Graduate certificate totals and 4 domestic-only pages excluded. |
| Federation University Australia (AU) | Admitting | English, fees | 5 Oct 2026, 09:27 AEDT | 60 | Proposed | Proposed | 1 | `configs/au-federation-university-australia.json` | Wave 7. 9 fees, 100 IELTS. Intakes held: domestic-view pages. |
| Monash University (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 09:27 AEDT | 15 | Proposed | Proposed | 1 | `configs/au-monash-university.json` | Wave 7. 266 intakes, 262 fees, 260 IELTS held = adapter. Scholarship and domestic fees, 2 intakes held back. |
| The University of Sydney (AU) | Admitting | intakes | 5 Oct 2026, 09:27 AEDT | 82 | Approved | Proposed | 2 | `configs/au-the-university-of-sydney.json` | Wave 7. 21 intakes. Domestic-view pages; fee and IELTS load in the browser. |
| University of Canberra (AU) | Admitting | intakes, English | 5 Oct 2026, 09:27 AEDT | 52 | Approved | No values | 1 | `configs/au-university-of-canberra.json` | Wave 7. 94 intakes, 97 IELTS. Fees are not on the stored pages (the browser loads them). |
| University of Lethbridge (CA) | Admitting | intakes | 5 Oct 2026, 09:27 AEDT | 13 | Proposed | No values | 2 | `configs/ca-university-of-lethbridge.json` | Wave 7. 3 intakes. 186 courses bound to the wrong pages (decision). |
| University of Tasmania (AU) | Admitting | intakes, English | 5 Oct 2026, 09:27 AEDT | 4 | Proposed | Proposed | 1 | `configs/au-university-of-tasmania.json` | Wave 7. 96 intakes, 39 IELTS. Fees held: annual figures for years that are not 100 credit points (decision). |
| Victoria University (AU) | Admitting | English | 5 Oct 2026, 09:27 AEDT | 298 | Approved | Proposed | 1 | `configs/au-victoria-university.json` | Wave 7. 7 IELTS. Domestic-view pages; per-semester fees (decision). |
| Australian National University (AU) | Testing | — | — | 0 | No values | No values | 0 | `configs/au-australian-national-university.json` | Not admitted: needs central start dates and English (second-page source). |
| Bond University Limited (AU) | Testing | — | — | 0 | No values | No values | 0 | `configs/au-bond-university-limited.json` | Not admitted: fees are per semester only, and IELTS is on a second page. |
| Macquarie University (AU) | Testing | — | — | 0 | No values | No values | 0 | `configs/au-macquarie-university.json` | Not admitted: page-data fee path saved, 0 fees read. |
| Mount Royal University (CA) | Testing | — | — | 0 | — | — | 0 | `configs/ca-mount-royal-university.json` | Not admitted: nothing admissible (fee, English and start months are central only). |
| Simon Fraser University (CA) | Testing | — | — | 0 | — | — | 0 | `configs/ca-simon-fraser-university.json` | Not admitted: 3 intakes only. |
| The University of Western Australia (AU) | Testing | — | — | 0 | No values | Proposed | 0 | `configs/au-the-university-of-western-australia.json` | Not admitted: fees only in the fee calculator. |
| University of Auckland (NZ) | Testing | — | — | 0 | — | — | 0 | `configs/nz-university-of-auckland.json` | Not admitted: 45 intakes differ from held values. |

## All target universities (57)

Rebuilt from the live database at the time above, with the same figures as the Universities tab. "Held" counts courses with a value, whatever its source; the brackets show how many came from an adapter and from a central rule. The page-finding columns of earlier versions (confirmed page, no page, not readable, next step) now live in the PIM Admin evaluation panel.

| University | Country | Courses | Pages read | Intakes held (adapter / central) | English held (adapter / central) | Fees held (adapter) | Adapter | English rule | Calendar | Wave |
|---|---|---:|---:|---|---|---|---|---|---|---|
| Flinders University | AU | 476 | 315 | 223 (174 / 0) | 305 (0 / 197) | 208 (120) | Admitting | Approved | No values | Done |
| Macquarie University | AU | 461 | 270 | 82 (0 / 0) | 111 (6 / 0) | 0 (0) | Testing | No values | No values | Wave 1 |
| The University of Western Australia | AU | 327 | 282 | 76 (68 / 0) | 154 (25 / 0) | 0 (0) | Testing | No values | Proposed | Wave 2 |
| Australian National University | AU | 423 | 308 | 18 (0 / 0) | 0 (0 / 0) | 7 (0) | Testing | No values | No values | Wave 1 |
| The University of Melbourne | AU | 441 | 380 | 91 (89 / 0) | 0 (0 / 0) | 0 (0) | Admitting | No values | Proposed | Done (wave 1) |
| Murdoch University | AU | 267 | 224 | 181 (178 / 0) | 42 (3 / 0) | 160 (160) | Admitting | No values | No values | Done (wave 2) |
| La Trobe University | AU | 248 | 237 | 104 (83 / 0) | 141 (74 / 64) | 100 (100) | Admitting | Approved | No values | Done (wave 3) |
| Simon Fraser University | CA | 208 | 152 | 39 (3 / 0) | 0 (0 / 0) | 0 (0) | Testing | — | — | Wave 1 |
| Bond University Limited | AU | 180 | 162 | 35 (0 / 0) | 0 (0 / 0) | 0 (0) | Testing | No values | No values | Wave 3 |
| Griffith University | AU | 297 | 261 | 261 (261 / 0) | 255 (252 / 0) | 254 (17) | Admitting | No values | No values | Done (wave 3) |
| James Cook University | AU | 127 | 122 | 21 (20 / 0) | 16 (5 / 0) | 2 (2) | Admitting | No values | Proposed | Done (wave 4) |
| Charles Darwin University | AU | 175 | 153 | 147 (147 / 0) | 22 (0 / 15) | 149 (113) | Admitting | Approved | Proposed | Done (wave 4) |
| Central Queensland University | AU | 106 | 88 | 67 (60 / 6) | 63 (46 / 14) | 66 (66) | Admitting | Approved | Approved | Done (wave 4) |
| Mount Royal University | CA | 38 | 33 | 14 (0 / 0) | 0 (0 / 0) | 0 (0) | Testing | — | — | Wave 2 |
| Western Sydney University | AU | 325 | 300 | 150 (138 / 0) | 23 (0 / 1) | 153 (21) | Admitting | Approved | No values | Done (wave 5) |
| University of Canterbury | NZ | 280 | 162 | 151 (148 / 0) | 10 (0 / 0) | 70 (70) | Admitting | — | — | Done (wave 1) |
| University of the Sunshine Coast | AU | 148 | 144 | 103 (93 / 0) | 2 (0 / 0) | 128 (23) | Admitting | Proposed | No values | Done (wave 5) |
| Australian Catholic University | AU | 149 | 143 | 100 (90 / 9) | 28 (25 / 0) | 104 (0) | Admitting | No values | Approved | Done (wave 5) |
| Thompson Rivers University | CA | 76 | 48 | 36 (36 / 0) | 0 (0 / 0) | 0 (0) | Admitting | — | — | Done (wave 3) |
| Vancouver Island University | CA | 44 | 32 | 30 (27 / 0) | 0 (0 / 0) | 25 (25) | Admitting | Proposed | — | Done (wave 4) |
| Royal Roads University | CA | 31 | 17 | 13 (13 / 0) | 0 (0 / 0) | 0 (0) | Admitting | — | — | Done (wave 5) |
| The University of Sydney | AU | 655 | 432 | 30 (21 / 0) | 487 (0 / 482) | 0 (0) | Admitting | Approved | Proposed | Done (wave 7) |
| University of British Columbia | CA | 575 | 275 | 200 (0 / 0) | 221 (0 / 0) | 0 (0) | None | — | — | Find re-run on ubc.ca |
| University of Alberta | CA | 379 | 81 | 1 (0 / 0) | 22 (16 / 0) | 0 (0) | Admitting | No values | — | Done (wave 6) |
| University of Technology Sydney | AU | 530 | 359 | 183 (130 / 0) | 310 (307 / 0) | 145 (0) | Admitting | No values | Proposed | Done (wave 2) |
| Monash University | AU | 582 | 385 | 287 (266 / 0) | 264 (260 / 0) | 266 (262) | Admitting | Proposed | Proposed | Done (wave 7) |
| Curtin University | AU | 373 | 293 | 230 (202 / 0) | 262 (257 / 0) | 3 (3) | Admitting | Proposed | Proposed | Done (wave 6) |
| University of Auckland | NZ | 458 | 264 | 219 (212 / 0) | 106 (0 / 0) | 12 (0) | Testing | — | — | Wave 2 |
| Victoria University of Wellington | NZ | 273 | 0 | 0 (0 / 0) | 0 (0 / 0) | 0 (0) | None | No values | No values | Wave 6, not admitted |
| University of Otago | NZ | 252 | 4 | 1 (0 / 0) | 1 (0 / 0) | 0 (0) | None | No values | Proposed | Wave 6, not admitted |
| Massey University | NZ | 265 | 155 | 15 (10 / 0) | 20 (2 / 0) | 79 (79) | Admitting | — | — | Done (wave 3) |
| University of Waikato | NZ | 278 | 71 | 71 (70 / 0) | 0 (0 / 0) | 21 (21) | Admitting | Proposed | No values | Done (wave 5) |
| Victoria University | AU | 280 | 134 | 110 (0 / 0) | 27 (7 / 12) | 0 (0) | Admitting | Approved | Proposed | Done (wave 7) |
| University of Victoria | CA | 234 | 128 | 94 (70 / 0) | 6 (3 / 0) | 0 (0) | Admitting | No values | No values | Done (wave 6) |
| University of Lethbridge | CA | 199 | 13 | 4 (3 / 0) | 0 (0 / 0) | 0 (0) | Admitting | Proposed | No values | Done (wave 7) |
| Swinburne University of Technology | AU | 412 | 238 | 215 (212 / 0) | 225 (219 / 0) | 114 (0) | Admitting | Proposed | Proposed | Done (wave 6) |
| University of Calgary | CA | 179 | 22 | 1 (0 / 0) | 0 (0 / 0) | 0 (0) | None | No values | No values | Wave 7, draft only |
| University of Tasmania | AU | 221 | 102 | 98 (96 / 0) | 82 (39 / 0) | 37 (0) | Admitting | Proposed | Proposed | Done (wave 7) |
| Lincoln University | NZ | 199 | 63 | 61 (57 / 0) | 3 (0 / 0) | 30 (30) | Admitting | Proposed | No values | Done (wave 4) |
| Adelaide University | AU | 498 | 251 | 242 (229 / 0) | 463 (236 / 227) | 199 (199) | Admitting | Approved | Approved | Done (wave 7) |
| The University of Notre Dame Australia | AU | 131 | 0 | 0 (0 / 0) | 0 (0 / 0) | 0 (0) | None | No values | No values | Wave 8 (scheduled 09:49) |
| Federation University Australia | AU | 195 | 125 | 105 (95 / 0) | 112 (93 / 0) | 112 (0) | Admitting | Proposed | Proposed | Done (wave 7) |
| University of Northern British Columbia | CA | 76 | 47 | 19 (0 / 0) | 0 (0 / 0) | 0 (0) | None | — | — | Wave 8 (scheduled 09:49) |
| University of Canberra | AU | 212 | 121 | 111 (94 / 0) | 182 (97 / 81) | 1 (0) | Admitting | Approved | No values | Done (wave 7) |
| Athabasca University | CA | 50 | 35 | 8 (0 / 0) | 0 (0 / 0) | 0 (0) | None | — | — | Wave 8 (scheduled 09:49) |
| Grant MacEwan University | CA | 44 | 6 | 0 (0 / 0) | 0 (0 / 0) | 0 (0) | None | — | — | Wave 8 (scheduled 09:49) |
| University of the Fraser Valley | CA | 44 | 11 | 10 (0 / 0) | 0 (0 / 0) | 0 (0) | None | — | — | Wave 8 (scheduled 09:49) |
| Kwantlen Polytechnic University | CA | 37 | 7 | 2 (0 / 0) | 0 (0 / 0) | 0 (0) | None | — | — | Wave 8 (scheduled 09:49) |
| RMIT University | AU | 507 | 384 | 309 (83 / 0) | 369 (109 / 0) | 305 (77) | Admitting | Proposed | Proposed | Done (wave 6) |
| University of Wollongong | AU | 367 | 341 | 210 (208 / 0) | 220 (210 / 0) | 0 (0) | Admitting | Proposed | Proposed | Done (wave 6) |
| Auckland University of Technology | NZ | 257 | 190 | 145 (137 / 0) | 145 (138 / 0) | 6 (0) | Admitting | No values | No values | Done (wave 7) |
| Queensland University of Technology | AU | 294 | 210 | 147 (140 / 0) | 201 (138 / 63) | 122 (122) | Admitting | Approved | No values | Done (wave 6) |
| Edith Cowan University | AU | 172 | 155 | 145 (144 / 0) | 150 (149 / 0) | 144 (138) | Admitting | Proposed | Proposed | Done (wave 7) |
| Southern Cross University | AU | 153 | 128 | 99 (0 / 0) | 118 (0 / 6) | 0 (0) | None | Approved | Proposed | Wave 8 (scheduled 09:49) |
| University of New England | AU | 130 | 121 | 92 (0 / 0) | 80 (0 / 78) | 13 (0) | None | Approved | Proposed | Wave 8 (scheduled 09:49) |
| The University of Queensland | AU | 383 | 355 | 332 (316 / 0) | 353 (3 / 1) | 315 (261) | Admitting | Approved | Proposed | Done (wave 6) |
| Deakin University | AU | 252 | 212 | 194 (144 / 0) | 244 (175 / 56) | 196 (189) | Admitting | Approved | Proposed | Done (wave 6) |

## Recording rule

- When an adapter is set up, changed or admitted, re-export its configuration to `configs/{country}-{university-slug}.json`, including `config` (with `term_months`), `admit_fields`, the active `exclusions` (course code, title, field, reason), `central_rules` (English rule and calendar state, attached central pages, English proposals waiting), `results` and the admit reason and date. `page_roles` is kept where it was written. Update its row above and append an entry to the M2.4.7 runsheet set.
- The export must match the live row field by field (md5 of each pattern, path and pick value). The 4 Oct export of Flinders was checked this way. The 5 Oct 07:30 export of all 26 configurations was checked the same way: every pattern (140) by md5, and each whole `security.uni_adapter_json` value, admit reason and exclusion list against the live rows. The 5 Oct 08:35 export of all 35 configurations was checked the same way: every pattern (189) by md5, plus each whole `security.uni_adapter_json` value, admit reason, exclusion list (222), attached central page (30) and waiting English proposal (by md5 of its content). The 5 Oct 09:30 export of all 45 configurations was checked the same way: every pattern (246) by md5, plus each whole `security.uni_adapter_json` value, admit reason, exclusion list (906), attached central page (46) and waiting English proposal (28).
