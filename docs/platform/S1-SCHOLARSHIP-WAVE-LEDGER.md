# S1-Scholarship-Claude AU wave ledger

Owner: S1-Scholarship-Claude (AU / CRICOS scholarships only). Read live from the database at 24 Nov 2026 12:40 UTC (23:40 Melbourne); rows are per provider. This is evidence for S1-Build's register refresh; it does not change `scholarship_status`, the queue CSV or the checker.

Reading the columns: batch = 15-provider groups in the order their listing pages were first queued (batch 1 includes the CDU, Adelaide and Wave 3 hubs; 2 = R1, 3 = R2/R3, 4 = R4, 5 to 6 = R5, not yet read). Pages = manual listing pages read/queued. Candidates = listing members extracted. Adm/Rej/Skip = admission outcomes of those candidates (Skip = existing skip rules). Unread/AI = candidates not yet read / read and waiting in the AI queue. Published = active and published awards, before the recovery (current minus those admitted by it) then now. FC = Firecrawl credits logged against the provider since 08:45 UTC (all lanes). Linked-course coverage was not verified this checkpoint. Official sources: each row's pages are the provider's own `/scholarship` or hub pages (host fenced); next action is the next scheduled run unless stated.

| Batch | Provider | Courses | Pages | Cands | Adm/Rej/Skip | Unread/AI | Published | FC | Blocker / next action |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Adelaide University | 499 | 7/13 | 6 | 0/4/0 | 2/0 | 24 to 24 | 2 | link-only hub; trace candidates 45566 to 45569, 4466, 4467 (SCH-FU-01) |
| 1 | Charles Darwin University | 175 | 5/8 | 8 | 8/0/0 | 0/0 | 0 to 6 | 3 | Australia Awards, NT Government admitted but unpublished: find reason (SCH-FU-01) |
| 1 | Collarts | 139 | 1/2 | 0 | 0/0/0 | 0/0 | 0 to 0 | 4 | read the waiting page |
| 1 | University of Notre Dame Australia | 131 | 1/1 | 0 | 0/0/0 | 0/0 | 6 to 6 | 1 | none; complete |
| 1 | Melbourne Polytechnic | 87 | 2/2 | 24 | 0/11/0 | 2/11 | 0 to 0 | 3 | settle AI queue (11) |
| 1 | Box Hill Institute | 38 | 1/1 | 0 | 0/0/0 | 0/0 | 0 to 0 | 2 | no award members found; defer |
| 2 | Western Sydney University | 334 | 9/12 | 10 | 0/6/0 | 2/2 | 21 to 21 | 3 | settle |
| 2 | La Trobe University | 248 | 6/9 | 16 | 0/8/0 | 1/7 | 14 to 14 | 21 | settle AI queue (7) |
| 2 | Le Cordon Bleu Australia | 69 | 6/8 | 0 | 0/0/0 | 0/0 | 2 to 2 | 3 | none found |
| 2 | Holmesglen | 45 | 6/9 | 3 | 0/0/0 | 3/0 | 1 to 1 | 1 | read 3 |
| 2 | Victoria University (0f5373c8) | 35 | 6/9 | 9 | 0/7/0 | 2/0 | 3 to 3 | 17 | settle |
| 2 | UQ College | 4 | 9/12 | 0 | 0/0/0 | 0/0 | 0 to 0 | 15 | none found |
| 2 | RMIT University Pathways | 3 | 9/12 | 84 | 0/79/0 | 4/1 | 0 to 0 | 2 | mostly noise; settle |
| 3 | RMIT University | 510 | 6/12 | 208 | 1/104/0 | 94/0 | 37 to 37 | 1 | 94 unread: continue candidate reads |
| 3 | Macquarie University | 461 | 3/3 | 1 | 0/1/0 | 0/0 | 25 to 25 | 3 | complete |
| 3 | University of Wollongong | 367 | 9/12 | 87 | 0/6/1 | 75/6 | 18 to 18 | 5 | 75 unread: continue |
| 3 | Griffith University | 298 | 6/9 | 21 | 3/3/0 | 4/11 | 13 to 13 | 25 | 3 admitted, publish pending; settle AI |
| 3 | Queensland University of Technology | 294 | 3/3 | 69 | 0/0/0 | 69/0 | 14 to 14 | 7 | provider hold (fc_sch_held): HELD, S1-Build review |
| 3 | Victoria University (bac82321) | 280 | 6/12 | 5 | 0/4/0 | 1/0 | 9 to 9 | 9 | settle |
| 3 | University of Tasmania | 221 | 3/3 | 315 | 0/122/192 | 1/0 | 9 to 9 | 129 | held; UTAS prize skip rule applied, genuine international awards untouched |
| 3 | University of Canberra | 212 | 3/4 | 1 | 0/1/0 | 0/0 | 5 to 5 | 2 | complete |
| 3 | Bond University | 185 | 9/12 | 6 | 0/2/0 | 3/1 | 3 to 3 | 2 | settle |
| 3 | TAFE NSW | 109 | 3/5 | 58 | 1/55/0 | 0/2 | 2 to 2 | 3 | 1 admitted, publish pending |
| 3 | Central Queensland University | 106 | 6/11 | 0 | 0/0/0 | 0/0 | 4 to 4 | 3 | none found |
| 3 | University of Southern Queensland | 64 | 3/3 | 2 | 0/2/0 | 0/0 | 6 to 6 | 1 | complete |
| 3 | Australian College of Applied Professions | 27 | 6/12 | 5 | 0/4/0 | 0/1 | 2 to 2 | 8 | settle |
| 3 | Engineering Institute of Technology | 14 | 3/4 | 0 | 0/0/0 | 0/0 | 2 to 2 | 3 | none found |
| 3 | UWS College | 5 | 6/12 | 6 | 0/4/0 | 2/0 | 0 to 0 | 9 | settle |
| 4 | Australian National University | 426 | 3/3 | 7 | 0/2/0 | 0/5 | 26 to 26 | 2 | settle AI |
| 4 | Murdoch University | 267 | 3/3 | 1 | 0/0/0 | 0/1 | 14 to 14 | 2 | settle |
| 4 | Federation University | 195 | 3/3 | 2 | 0/2/0 | 0/0 | 23 to 23 | 1 | complete |
| 4 | Southern Cross University | 153 | 3/8 | 1 | 0/0/0 | 1/0 | 2 to 2 | 4 | read waiting pages |
| 4 | TAFE Queensland | 100 | 3/9 | 8 | 0/1/0 | 7/0 | 0 to 0 | 2 | read 7 |
| 4 | Chisholm Institute | 34 | 3/8 | 2 | 0/1/0 | 1/0 | 0 to 0 | 6 | 2 page failures; retry |
| 4 | Protea College | 23 | 3/3 | 1 | 0/0/0 | 1/0 | 0 to 0 | 3 | read 1 |
| 5 | University of the Sunshine Coast | 148 | 0/2 | 0 | n/a | 0/0 | 11 to 11 | 0 | pages queued, not read |
| 5 | Intl College of Management Sydney | 65 | 0/3 | 0 | n/a | 0/0 | 4 to 4 | 0 | queued |
| 5 | SAE University College | 57 | 0/2 | 36 | 1/35/0 | 0/0 | 1 to 2 | 0 | 1 new award published |
| 5 | Stott's Colleges group | 35 | 0/1 | 0 | n/a | 0/0 | 0 to 0 | 2 | queued |
| 5 | Stanley College | 27 | 0/2 | 0 | n/a | 0/0 | 0 to 0 | 0 | queued |
| 5 | Aust. College of Physical Education | 23 | 0/3 | 0 | n/a | 0/0 | 2 to 2 | 0 | queued |
| 5 | Polytechnic Institute Australia | 21 | 0/1 | 0 | n/a | 0/0 | 0 to 0 | 0 | queued |
| 5 | Jabin Hopkins Institute | 16 | 0/1 | 0 | n/a | 0/0 | 0 to 0 | 0 | queued |
| 5 | Sydney International School of Technology | 9 | 0/2 | 0 | n/a | 0/0 | 0 to 0 | 0 | queued |
| 6 | Torrens University Australia | 182 | 0/2 | 6 | 1/5/1 | 0/0 | 7 to 7 | 0 | 1 admitted, publish pending |
| 6 | Avondale University | 21 | 0/2 | 0 | n/a | 0/0 | 9 to 9 | 0 | queued |
| 6 | MIT Melbourne Institute of Technology | 19 | 0/1 | 0 | n/a | 0/0 | 3 to 3 | 0 | queued |
| 6 | Leaders Institute | 14 | 0/2 | 0 | n/a | 0/0 | 0 to 0 | 0 | queued |
| 6 | Edith Cowan College | 12 | 0/2 | 0 | n/a | 0/0 | 0 to 0 | 0 | queued |
| 6 | Melbourne Institute of Technology | 12 | 0/3 | 0 | n/a | 0/0 | 2 to 2 | 0 | queued |
| 6 | Sydney Institute of Business and Technology | 9 | 0/1 | 4 | 0/4/0 | 0/0 | 0 to 0 | 0 | queued |
| 6 | Sydney Polytechnic Institute | 9 | 0/2 | 0 | n/a | 0/0 | 0 to 0 | 0 | queued |
| 6 | Marcus Oldham College | 6 | 0/3 | 0 | n/a | 0/0 | 0 to 0 | 0 | queued |
| 6 | Sydney Institute of Higher Education | 5 | 0/2 | 0 | n/a | 0/0 | 0 to 0 | 0 | queued |
| 6 | Technical Advanced Training | 2 | 0/1 | 0 | n/a | 0/0 | 0 to 0 | 0 | queued |
| 6 | Churchill Institute of Higher Education | 2 | 0/2 | 0 | n/a | 0/0 | 0 to 0 | 0 | queued |

Totals at 12:40 UTC: 59 providers, 14 recovery admissions across these providers (CDU 8, Griffith 3, RMIT 1, TAFE NSW 1, SAE 1, Torrens 1; counts differ from the 15 in the checkpoint by the candidate window), AU published 871 across 68 providers. Firecrawl D1 window `52160ace` open (43 `sch_map` credits); `b7034c96` closed (204 credits). Providers with no active award and Tier 0/1 (33) were mapped by D1; their discovery results are not yet in this table.
