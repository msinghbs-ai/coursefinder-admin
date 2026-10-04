# University Adapter Register

**Status:** CURRENT · **Decision:** 254 (design reference v1.4) · **Change control:** CF-CHG-20260915-247 · **As at:** 5 Oct 2026, 07:30 AEDT
**Design and decision document:** `docs/coursefinder-university-adapters-v1.0.md`

This register lists every target university and its adapter state, with each adapter's reviewed configuration in `configs/`. The live configuration is held in the database (`pipeline.uni_adapters`) and edited in the PIM Admin (Models & services › University adapters). The files here are the reviewed baseline for production. Re-export them at every release gate, and whenever an adapter is admitted or changed.

## How to read this register

- **Next step** comes from the adapter evaluation rules (settings under Firecrawl › Adapter evaluation). It refreshes every 5 minutes, so the live panel may differ from this snapshot.
- **Wave** is the planned build order, five adapters at a time, each wave with a NZ and a CA university (see section 5 of the design document, amended 23:41). The Wave column below follows the amended plan.
- **Adapter** is the live state: None, Testing (enabled, not admitting), or Admitting (enabled, admission on for the fields shown in the table above).
- **Wave** shows "Done (wave N)" once the adapter built in that wave is admitting. Waves 1 to 5 ran on 5 Oct 2026 (see the M2.4.7 runsheet entry of 07:30).
- Flinders' "no page" figure is high at this time because 74 courses are being read again after the better-page run.

## Adapters with a configuration

26 adapters are configured: 19 admitting and 7 testing. 54 course exclusions are active. Admitted fields and exclusion counts are taken from the live database at the time above.

**Admission by field.** An adapter that is admitting only overwrites the fields ticked for it (intakes, English, fees). A university can be right on one field and wrong on another, so each field is switched on by itself. For example, Griffith admits English and fees, but its intakes are held because its term months change by year.

**Course exclusions.** A single course can be excluded for one field, with a written reason (for example, a short-course total printed as an annual fee, or an application-open month read as a start). An excluded course keeps its held value for that field. Exclusions are switched off when no longer needed, never deleted, so the history stays. Both controls are honoured by the adapter overwrite, the country identity rule, the page record and the coverage admission of intakes and English.

| University | State | Admitted fields | Admitted on | Active exclusions | Configuration | Notes |
|---|---|---|---|---:|---|---|
| Flinders University (AU) | Admitting | intakes, English, fees | 4 Oct 2026, 22:47 AEDT | 0 | `configs/au-flinders-university.json` | 174 intakes and 158 fees held after the overwrite. English from the central policy. |
| Murdoch University (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 06:08 AEDT | 0 | `configs/au-murdoch-university.json` | 178 intakes, 160 fees, 41 IELTS held after the overwrite. |
| The University of Melbourne (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 06:08 AEDT | 0 | `configs/au-the-university-of-melbourne.json` | 89 intakes held after the overwrite. No fee or IELTS on stored pages. |
| University of Canterbury (NZ) | Admitting | intakes, English, fees | 5 Oct 2026, 06:08 AEDT | 0 | `configs/nz-university-of-canterbury.json` | 148 intakes and 70 fees held after the overwrite. |
| University of Technology Sydney (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 06:08 AEDT | 0 | `configs/au-university-of-technology-sydney.json` | 130 intakes, 307 IELTS read. International fees need the fee PDF. |
| Charles Darwin University (AU) | Admitting | intakes, fees | 5 Oct 2026, 06:29 AEDT | 8 | `configs/au-charles-darwin-university.json` | 147 intakes and 130 fees. 8 short-course totals excluded. |
| Griffith University (AU) | Admitting | English, fees | 5 Oct 2026, 06:29 AEDT | 0 | `configs/au-griffith-university.json` | 252 fees and 252 IELTS. Intakes held: the 2027 calendar has T1 March, T2 July, T3 September, not Feb/Jul/Oct. |
| James Cook University (AU) | Admitting | intakes, fees | 5 Oct 2026, 06:29 AEDT | 1 | `configs/au-james-cook-university.json` | 20 intakes and 2 fees. Diploma of Higher Education fee (Singapore) excluded. IELTS held. |
| Lincoln University (NZ) | Admitting | intakes, fees | 5 Oct 2026, 06:29 AEDT | 1 | `configs/nz-lincoln-university.json` | 57 intakes and 30 fees. LI0511 intakes excluded. |
| Massey University (NZ) | Admitting | intakes, fees | 5 Oct 2026, 06:29 AEDT | 3 | `configs/nz-massey-university.json` | 10 intakes and 79 fees. 3 fees excluded (GDDRS, UDBRB, UBAVT). |
| Thompson Rivers University (CA) | Admitting | intakes | 5 Oct 2026, 06:29 AEDT | 0 | `configs/ca-thompson-rivers-university.json` | 36 intakes. No fee reader (per-semester calculator only). |
| Vancouver Island University (CA) | Admitting | intakes, fees | 5 Oct 2026, 06:29 AEDT | 4 | `configs/ca-vancouver-island-university.json` | 27 intakes and 25 fees. Liberal Studies and Global Studies (cancelled) excluded. |
| Australian Catholic University (AU) | Admitting | intakes, English | 5 Oct 2026, 07:06 AEDT | 3 | `configs/au-australian-catholic-university.json` | 90 intakes and 25 IELTS. 3 intakes excluded. Fees wait on the international view. |
| Central Queensland University (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 07:06 AEDT | 0 | `configs/au-central-queensland-university.json` | 66 intakes, 66 fees, 55 IELTS. Rebound to handbook pages for the international view. |
| La Trobe University (AU) | Admitting | intakes, English, fees | 5 Oct 2026, 07:06 AEDT | 1 | `configs/au-la-trobe-university.json` | 100 intakes, 100 fees, 95 IELTS from the international view. Dental fee to confirm. |
| Royal Roads University (CA) | Admitting | intakes | 5 Oct 2026, 07:06 AEDT | 15 | `configs/ca-royal-roads-university.json` | 13 intakes. Scholarship amounts excluded as fees (pages print whole-program tuition only). |
| University of Waikato (NZ) | Admitting | intakes, fees | 5 Oct 2026, 07:06 AEDT | 4 | `configs/nz-university-of-waikato.json` | 70 intakes and 21 fees. WI0250 intakes and 3 sub-year fees excluded. |
| University of the Sunshine Coast (AU) | Admitting | intakes | 5 Oct 2026, 07:06 AEDT | 1 | `configs/au-university-of-the-sunshine-coast.json` | 93 intakes. 073869J intakes excluded. Fees held (2026 or 2027 label in doubt). |
| Western Sydney University (AU) | Admitting | intakes, fees | 5 Oct 2026, 07:06 AEDT | 13 | `configs/au-western-sydney-university.json` | 138 intakes and 21 fees. 7 intakes and 6 fees excluded. |
| Australian National University (AU) | Testing | — | — | 0 | `configs/au-australian-national-university.json` | Not admitted: needs central start dates and English (second-page source). |
| Bond University Limited (AU) | Testing | — | — | 0 | `configs/au-bond-university-limited.json` | Not admitted: fees are per semester only, and IELTS is on a second page. |
| Macquarie University (AU) | Testing | — | — | 0 | `configs/au-macquarie-university.json` | Not admitted: page-data fee path saved, 0 fees read. |
| Mount Royal University (CA) | Testing | — | — | 0 | `configs/ca-mount-royal-university.json` | Not admitted: nothing admissible (fee, English and start months are central only). |
| Simon Fraser University (CA) | Testing | — | — | 0 | `configs/ca-simon-fraser-university.json` | Not admitted: 3 intakes only. |
| The University of Western Australia (AU) | Testing | — | — | 0 | `configs/au-the-university-of-western-australia.json` | Not admitted: fees only in the fee calculator. |
| University of Auckland (NZ) | Testing | — | — | 0 | `configs/nz-university-of-auckland.json` | Not admitted: 45 intakes differ from held values. |

## All target universities (57)

| University | Country | Courses | Confirmed page | No page | Not readable | Intakes | English | Adapter | Next step | Wave |
|---|---|---:|---:|---:|---:|---:|---:|---|---|---|
| Flinders University | AU | 476 | 315 | 118 | 43 | 223 | 305 | Admitting | Admitting | Done |
| Macquarie University | AU | 461 | 270 | 25 | 166 | 82 | 111 | Testing | Adapter for page data | Wave 1 |
| The University of Western Australia | AU | 327 | 119 | 15 | 193 | 40 | 44 | Testing | Adapter for page data | Wave 2 |
| Australian National University | AU | 423 | 405 | 18 | 0 | 17 | 0 | Testing | Adapter for start dates | Wave 1 |
| The University of Melbourne | AU | 441 | 354 | 83 | 4 | 86 | 0 | Admitting | Adapter for start dates | Done (wave 1) |
| Murdoch University | AU | 267 | 224 | 27 | 16 | 3 | 42 | Admitting | Adapter for start dates | Done (wave 2) |
| La Trobe University | AU | 248 | 239 | 7 | 2 | 23 | 88 | Admitting | Adapter for start dates | Done (wave 3) |
| Simon Fraser University | CA | 208 | 152 | 54 | 2 | 39 | 0 | Testing | Adapter for start dates | Wave 1 |
| Bond University Limited | AU | 180 | 162 | 17 | 1 | 35 | 0 | Testing | Adapter for start dates | Wave 3 |
| Griffith University | AU | 297 | 260 | 32 | 5 | 41 | 254 | Admitting | Adapter for start dates | Done (wave 3) |
| James Cook University | AU | 127 | 122 | 5 | 0 | 21 | 16 | Admitting | Adapter for start dates | Done (wave 4) |
| Charles Darwin University | AU | 175 | 153 | 19 | 3 | 0 | 163 | Admitting | Adapter for start dates | Done (wave 4) |
| Central Queensland University | AU | 106 | 88 | 17 | 1 | 7 | 24 | Admitting | Adapter for start dates | Done (wave 4) |
| Mount Royal University | CA | 38 | 33 | 5 | 0 | 14 | 0 | Testing | Adapter for start dates | Wave 2 |
| Western Sydney University | AU | 325 | 295 | 30 | 0 | 150 | 22 | Admitting | Adapter for English | Done (wave 5) |
| University of Canterbury | NZ | 280 | 162 | 63 | 55 | 149 | 11 | Admitting | Adapter for English | Done (wave 1) |
| University of the Sunshine Coast | AU | 148 | 144 | 0 | 4 | 79 | 2 | Admitting | Adapter for English | Done (wave 5) |
| Australian Catholic University | AU | 149 | 143 | 5 | 1 | 98 | 28 | Admitting | Adapter for English | Done (wave 5) |
| Thompson Rivers University | CA | 76 | 48 | 22 | 6 | 36 | 0 | Admitting | Adapter for English | Done (wave 3) |
| Vancouver Island University | CA | 44 | 32 | 12 | 0 | 28 | 0 | Admitting | Adapter for English | Done (wave 4) |
| Royal Roads University | CA | 31 | 17 | 8 | 6 | 10 | 0 | Admitting | Adapter for English | Done (wave 5) |
| The University of Sydney | AU | 655 | 424 | 208 | 23 | 20 | 487 | None | Find pages first | Find run, then re-evaluate |
| University of British Columbia | CA | 575 | 275 | 278 | 22 | 200 | 221 | None | Find pages first | Find run, then re-evaluate |
| University of Alberta | CA | 379 | 81 | 291 | 7 | 1 | 36 | None | Find pages first | Find run, then re-evaluate |
| University of Technology Sydney | AU | 530 | 358 | 161 | 11 | 55 | 309 | Admitting | Find pages first | Done (wave 2) |
| Monash University | AU | 582 | 296 | 223 | 63 | 270 | 263 | None | Find pages first | Find run, then re-evaluate |
| Curtin University | AU | 373 | 109 | 260 | 4 | 36 | 86 | None | Find pages first | Find run, then re-evaluate |
| University of Auckland | NZ | 458 | 264 | 149 | 45 | 219 | 106 | Testing | Find pages first | Wave 2 |
| Victoria University of Wellington | NZ | 273 | 0 | 206 | 67 | 0 | 0 | None | Find pages first | Find run, then re-evaluate |
| University of Otago | NZ | 252 | 2 | 188 | 62 | 0 | 0 | None | Find pages first | Find run, then re-evaluate |
| Massey University | NZ | 265 | 155 | 106 | 4 | 12 | 20 | Admitting | Find pages first | Done (wave 3) |
| University of Waikato | NZ | 278 | 71 | 204 | 3 | 70 | 0 | Admitting | Find pages first | Done (wave 5) |
| Victoria University | AU | 280 | 134 | 137 | 9 | 110 | 29 | None | Find pages first | Find run, then re-evaluate |
| University of Victoria | CA | 234 | 128 | 104 | 2 | 60 | 6 | None | Find pages first | Find run, then re-evaluate |
| University of Lethbridge | CA | 199 | 13 | 142 | 44 | 1 | 0 | None | Find pages first | Find run, then re-evaluate |
| Swinburne University of Technology | AU | 412 | 238 | 148 | 26 | 214 | 225 | None | Find pages first | Find run, then re-evaluate |
| University of Calgary | CA | 179 | 22 | 157 | 0 | 1 | 0 | None | Find pages first | Find run, then re-evaluate |
| University of Tasmania | AU | 221 | 102 | 82 | 37 | 8 | 83 | None | Find pages first | Find run, then re-evaluate |
| Lincoln University | NZ | 199 | 60 | 102 | 37 | 58 | 3 | Admitting | Find pages first | Done (wave 4) |
| Adelaide University | AU | 498 | 251 | 236 | 11 | 233 | 463 | None | Find pages first | Find run, then re-evaluate |
| The University of Notre Dame Australia | AU | 131 | 0 | 64 | 67 | 0 | 0 | None | Find pages first | Find run, then re-evaluate |
| Federation University Australia | AU | 195 | 125 | 67 | 3 | 105 | 111 | None | Find pages first | Find run, then re-evaluate |
| University of Northern British Columbia | CA | 76 | 47 | 27 | 2 | 19 | 0 | None | Find pages first | Find run, then re-evaluate |
| University of Canberra | AU | 212 | 121 | 84 | 7 | 111 | 182 | None | Find pages first | Find run, then re-evaluate |
| Athabasca University | CA | 50 | 35 | 15 | 0 | 8 | 0 | None | Find pages first | Find run, then re-evaluate |
| Grant MacEwan University | CA | 44 | 6 | 31 | 7 | 0 | 0 | None | Find pages first | Find run, then re-evaluate |
| University of the Fraser Valley | CA | 44 | 11 | 32 | 1 | 10 | 0 | None | Find pages first | Find run, then re-evaluate |
| Kwantlen Polytechnic University | CA | 37 | 7 | 23 | 7 | 2 | 0 | None | Find pages first | Find run, then re-evaluate |
| RMIT University | AU | 507 | 384 | 114 | 9 | 306 | 369 | None | Admitted as it is | No adapter now |
| University of Wollongong | AU | 367 | 341 | 17 | 9 | 202 | 220 | None | Admitted as it is | No adapter now |
| Auckland University of Technology | NZ | 257 | 183 | 34 | 40 | 127 | 141 | None | Admitted as it is | No adapter now |
| Queensland University of Technology | AU | 294 | 210 | 79 | 5 | 146 | 201 | None | Admitted as it is | No adapter now |
| Edith Cowan University | AU | 172 | 155 | 14 | 3 | 84 | 150 | None | Admitted as it is | No adapter now |
| Southern Cross University | AU | 153 | 128 | 24 | 1 | 99 | 118 | None | Admitted as it is | No adapter now |
| University of New England | AU | 130 | 121 | 7 | 2 | 92 | 80 | None | Admitted as it is | No adapter now |
| The University of Queensland | AU | 383 | 352 | 24 | 7 | 329 | 353 | None | Admitted as it is | No adapter now |
| Deakin University | AU | 252 | 212 | 31 | 9 | 182 | 244 | None | Admitted as it is | No adapter now |
## Recording rule

- When an adapter is set up, changed or admitted, re-export its configuration to `configs/{country}-{university-slug}.json`, including `config` (with `term_months`), `admit_fields`, the active `exclusions` (course code, title, field, reason), `results` and the admit reason and date. `page_roles` is kept where it was written. Update its row above and append an entry to the M2.4.7 runsheet set.
- The export must match the live row field by field (md5 of each pattern, path and pick value). The 4 Oct export of Flinders was checked this way. The 5 Oct 07:30 export of all 26 configurations was checked the same way: every pattern (140) by md5, and each whole `security.uni_adapter_json` value, admit reason and exclusion list against the live rows.
