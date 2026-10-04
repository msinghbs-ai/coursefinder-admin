# University Adapter Register

**Status:** CURRENT · **Decision:** 254 (design reference v1.4) · **Change control:** CF-CHG-20260915-247 · **As at:** 4 Oct 2026, 23:35 AEDT
**Design and decision document:** `docs/coursefinder-university-adapters-v1.0.md`

This register lists every target university and its adapter state, with each adapter's reviewed configuration in `configs/`. The live configuration is held in the database (`pipeline.uni_adapters`) and edited in the PIM Admin (Models & services › University adapters). The files here are the reviewed baseline for production. Re-export them at every release gate, and whenever an adapter is admitted or changed.

## How to read this register

- **Next step** comes from the adapter evaluation rules (settings under Firecrawl › Adapter evaluation). It refreshes every 5 minutes, so the live panel may differ from this snapshot.
- **Wave** is the planned build order, five adapters at a time, each wave with a NZ and a CA university (see section 5 of the design document, amended 23:41). The Wave column below follows the amended plan.
- **Adapter** is the live state: None, Testing (enabled, not admitting), or Admitting (enabled, admission on).
- Flinders' "no page" figure is high at this time because 74 courses are being read again after the better-page run.

## Adapters with a configuration

| University | State | Configuration | Admitted on | Notes |
|---|---|---|---|---|
| Flinders University (AU) | Admitting | `configs/au-flinders-university.json` | 4 Oct 2026, 22:47 AEDT | Study pages (international block) and CourseLoop handbook. English comes from the central policy. |
| Macquarie University (AU) | Testing | `configs/au-macquarie-university.json` | — | CourseLoop page data only. Wave 1 (adapter for page data). |
| Australian National University (AU) | Testing | `configs/au-australian-national-university.json` | — | Built with the visual builder (draft 3f234771). Fee, duration and mode. Start dates are not on ANU program pages: a linked page or central key dates are needed. Wave 1. |
| Murdoch University (AU) | Testing | `configs/au-murdoch-university.json` | — | CourseLoop page data only. Wave 2 (adapter for start dates). |

## All target universities (57)

| University | Country | Courses | Confirmed page | No page | Not readable | Intakes | English | Adapter | Next step | Wave |
|---|---|---:|---:|---:|---:|---:|---:|---|---|---|
| Flinders University | AU | 476 | 315 | 118 | 43 | 223 | 305 | Admitting | Admitting | Done |
| Macquarie University | AU | 461 | 270 | 25 | 166 | 82 | 111 | Testing | Adapter for page data | Wave 1 |
| The University of Western Australia | AU | 327 | 119 | 15 | 193 | 40 | 44 | None | Adapter for page data | Wave 2 |
| Australian National University | AU | 423 | 405 | 18 | 0 | 17 | 0 | None | Adapter for start dates | Wave 1 |
| The University of Melbourne | AU | 441 | 354 | 83 | 4 | 86 | 0 | None | Adapter for start dates | Wave 1 |
| Murdoch University | AU | 267 | 224 | 27 | 16 | 3 | 42 | Testing | Adapter for start dates | Wave 2 |
| La Trobe University | AU | 248 | 239 | 7 | 2 | 23 | 88 | None | Adapter for start dates | Wave 3 |
| Simon Fraser University | CA | 208 | 152 | 54 | 2 | 39 | 0 | None | Adapter for start dates | Wave 1 |
| Bond University Limited | AU | 180 | 162 | 17 | 1 | 35 | 0 | None | Adapter for start dates | Wave 3 |
| Griffith University | AU | 297 | 260 | 32 | 5 | 41 | 254 | None | Adapter for start dates | Wave 3 |
| James Cook University | AU | 127 | 122 | 5 | 0 | 21 | 16 | None | Adapter for start dates | Wave 4 |
| Charles Darwin University | AU | 175 | 153 | 19 | 3 | 0 | 163 | None | Adapter for start dates | Wave 4 |
| Central Queensland University | AU | 106 | 88 | 17 | 1 | 7 | 24 | None | Adapter for start dates | Wave 4 |
| Mount Royal University | CA | 38 | 33 | 5 | 0 | 14 | 0 | None | Adapter for start dates | Wave 2 |
| Western Sydney University | AU | 325 | 295 | 30 | 0 | 150 | 22 | None | Adapter for English | Wave 5 |
| University of Canterbury | NZ | 280 | 162 | 63 | 55 | 149 | 11 | None | Adapter for English | Wave 1 |
| University of the Sunshine Coast | AU | 148 | 144 | 0 | 4 | 79 | 2 | None | Adapter for English | Wave 5 |
| Australian Catholic University | AU | 149 | 143 | 5 | 1 | 98 | 28 | None | Adapter for English | Wave 5 |
| Thompson Rivers University | CA | 76 | 48 | 22 | 6 | 36 | 0 | None | Adapter for English | Wave 3 |
| Vancouver Island University | CA | 44 | 32 | 12 | 0 | 28 | 0 | None | Adapter for English | Wave 4 |
| Royal Roads University | CA | 31 | 17 | 8 | 6 | 10 | 0 | None | Adapter for English | Wave 5 |
| The University of Sydney | AU | 655 | 424 | 208 | 23 | 20 | 487 | None | Find pages first | Find run, then re-evaluate |
| University of British Columbia | CA | 575 | 275 | 278 | 22 | 200 | 221 | None | Find pages first | Find run, then re-evaluate |
| University of Alberta | CA | 379 | 81 | 291 | 7 | 1 | 36 | None | Find pages first | Find run, then re-evaluate |
| University of Technology Sydney | AU | 530 | 358 | 161 | 11 | 55 | 309 | None | Find pages first | Wave 2 |
| Monash University | AU | 582 | 296 | 223 | 63 | 270 | 263 | None | Find pages first | Find run, then re-evaluate |
| Curtin University | AU | 373 | 109 | 260 | 4 | 36 | 86 | None | Find pages first | Find run, then re-evaluate |
| University of Auckland | NZ | 458 | 264 | 149 | 45 | 219 | 106 | None | Find pages first | Wave 2 |
| Victoria University of Wellington | NZ | 273 | 0 | 206 | 67 | 0 | 0 | None | Find pages first | Find run, then re-evaluate |
| University of Otago | NZ | 252 | 2 | 188 | 62 | 0 | 0 | None | Find pages first | Find run, then re-evaluate |
| Massey University | NZ | 265 | 155 | 106 | 4 | 12 | 20 | None | Find pages first | Wave 3 |
| University of Waikato | NZ | 278 | 71 | 204 | 3 | 70 | 0 | None | Find pages first | Wave 5 |
| Victoria University | AU | 280 | 134 | 137 | 9 | 110 | 29 | None | Find pages first | Find run, then re-evaluate |
| University of Victoria | CA | 234 | 128 | 104 | 2 | 60 | 6 | None | Find pages first | Find run, then re-evaluate |
| University of Lethbridge | CA | 199 | 13 | 142 | 44 | 1 | 0 | None | Find pages first | Find run, then re-evaluate |
| Swinburne University of Technology | AU | 412 | 238 | 148 | 26 | 214 | 225 | None | Find pages first | Find run, then re-evaluate |
| University of Calgary | CA | 179 | 22 | 157 | 0 | 1 | 0 | None | Find pages first | Find run, then re-evaluate |
| University of Tasmania | AU | 221 | 102 | 82 | 37 | 8 | 83 | None | Find pages first | Find run, then re-evaluate |
| Lincoln University | NZ | 199 | 60 | 102 | 37 | 58 | 3 | None | Find pages first | Wave 4 |
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

- When an adapter is set up, changed or admitted, re-export its configuration to `configs/{country}-{university-slug}.json`, including `config`, `page_roles`, `results` and the admit reason and date. Update its row above and append an entry to the M2.4.7 runsheet set.
- The export must match the live row field by field (md5 of each pattern, path and pick value). The 4 Oct export of Flinders was checked this way.
