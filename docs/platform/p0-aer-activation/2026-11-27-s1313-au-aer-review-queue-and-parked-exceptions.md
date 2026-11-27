# s1313 — AU AER review queue and parked exceptions (S1-AER-Claude, 27 Nov 2026 16:50 AEDT)

Response to SS-Programme-Control "Continue operational reader recovery" (16:03) and the P0 production data delivery direction (16:29). No database, source or setting change was made. Canonical data gain this release: **none**. Consumer API: nothing changed.

## 1. Parked exceptions (recorded once, not retried)
| Source | Reason | Needs |
|---|---|---|
| QUT PDFs `649d017d`, `fd198a4d` | Direct PDF read refused; stored copies are Firecrawl markdown | Original bytes (not obtainable by authorised means) |
| Newcastle prospectus `ff90a9ca` | Stops the worker; no page-range input | Engine freeze exception |
| UniSQ `unisq.edu.au/international/apply/entry-requirements` | Country grades load through a JavaScript selector; stored page holds only GCE and IB text | Rendered-page read (unsupported) |
| ECU `ecu.edu.au/future-students/course-entry/secondary-school-results` and agent-support page | Country listing not in the stored text | Rendered-page read (unsupported) |
| ICMS admission page | English-test rows only, not academic entry | Out of scope for AER |

## 2. Evidence-ready human decisions (Layer 4, already pending, ranked by rows)
Each item already holds its proposed rows, source and run. The blocker is the machine gate, so a person's decision (or the named engine/alias decision) is the route.

| Provider | Layer 4 item | Proposed rows | Machine gate result | Route |
|---|---|---|---|---|
| UWS College / Western Sydney (PDF) | c7f13eaa-080e-4495-a79f-60fb6fb3d4b5 | 461 | host_shared | Alias decision (S1-Build), then re-evaluate |
| RMIT University Pathways | 2bdceeb2-5179-4e2f-817b-656d3c7ef716 | 210 | host_shared | Alias decision (S1-Build) |
| University of Western Australia | 84bfe5b0-ed1b-493f-897b-ff18f9090e1b | 194 | all_rows_held | Person confirms, or printed-level reading (S2-AER) |
| Australian Learning Group | a9901cea-d182-4f2e-81a5-468b2a060452 | 110 | gate_incomplete | D-R3 decision (S2-AER) |
| TAFE South Australia | 00117ac8-b512-4bdd-a984-24b40432333e | 56 | gate_incomplete | D-R3 decision |
| Charles Darwin University | 4b1c8d84-af88-464c-b107-a2a40986581d | 50 | gate_incomplete | D-R3 decision |
| Macquarie University | 079de2d0-2f1d-47ab-959a-55cbc519dea6 | 46 | gate_incomplete | D-R3 decision |
| Australian Professional Skills Institute | 0abceb71-861a-4802-90fa-79859dcbceba | 44 | all_rows_held | Person confirms |
| Empyrean Education Institute | c9245f96-d125-4e3a-a70a-6868ac9c4c66 | 37 | all_rows_held | Person confirms |
| Curtin University | 205adbd4-a8dd-4281-a102-10b1f1e8d95a | 35 | all_rows_held (source host s30991.pcdn.co is a CDN) | Host alias, then person confirms |
| Canberra Institute of Technology | b6d8ed53-a51e-479f-bd6d-8ef5b6a4052d | 34 | gate_incomplete | D-R3 decision |
| University of Tasmania | 5284a753-45cd-4b55-a335-30dd59f81f59 | 27 | all_rows_held | Person confirms |
| Melbourne Polytechnic | 1517f886-998c-4661-97d3-91c182077476 | 25 | all_rows_held | Person confirms |
| Australian National University | 7e66129d-538e-44f7-9eca-6439e12931ae | 11 | all_rows_held | Person confirms |
| UNSW College | bf5285d8-cd76-4e96-95e7-875e3973c53d | 10 | all_rows_held | Person confirms |
| University of Melbourne | dcf9300f-5744-42c9-8550-94f12919d3f1, 261f23b6-470c-47f0-b617-5301d3abf8cd | 9 each | all_rows_held | Person confirms |
| Victoria University | 2d723220-008c-4e4e-8c79-d33483b3f154 | 5 | host_shared | Alias decision |

Smaller items (Gateway, Curtin College, ICHM, Sydney Institute, John Paul, TasTAFE, George Brown, AIH, Quality College) follow the same routes. Non-Australian items on the queue (Otago, Kwantlen, Royal Roads, UNBC, Victoria CA, MacEwan, Athabasca, NZ polytechnics) are not this lane.

## 3. Routes by owner
- **S1-Build:** host-alias decisions for UWS College, RMIT UP, Curtin and Victoria University (protected setting `aer.provider_host_aliases`); then re-evaluate through existing admission controls.
- **S2-AER:** D-R3 completeness for pages with no Australian standard column (ALG, TAFE SA, CDU, Macquarie, CIT); printed-level reading for UWA and Curtin.
- **People (Layer 4):** the all_rows_held items above, using the item's stored evidence.
- Carried forward unchanged: A1 CQU alias, A2 AIBT alias, A3 Excelsia retirement, Le Cordon Bleu page scope.
