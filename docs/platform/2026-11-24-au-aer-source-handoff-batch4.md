# AU AER source hand-off, Batch 4 (S1-RM-Design to S1-AER-Claude)

Spec s1091 (Pilot #1583), plus s1092 for the SAIBT edition defect. Scope: Steps 1–2 only. No reader, rule or admission change.

| Provider | Provider ID | Source ID | Evidence ID | SHA-256 | Stored location | Qualification and scope | Edition |
|---|---|---|---|---|---|---|---|
| Australian Performing Arts Conservatory | 310f6537-ef7e-4e76-8697-30b06fa2af6c | d42f7851-8ada-476f-88be-73f0cad64a81 | 37b0af62-3f38-41f4-9830-bff48f5e5b11 (artifact; source row evidence_id 184fac76-ab46-4e7a-8a24-e23d3f0d8b2a) | 78850689cd0e506fd795729f4cfbcae8bbd763a5e486a60b12b24e90afc0bfc6 | layer2/AU/entry-matrix/310f6537-…/d42f7851-…/78850689….pdf.gz (direct, HTTP 200) | Secondary qualification by country, undergraduate | v4.0, review date Aug 2025 |
| ICHM | d263eab5-2ead-443f-82d1-37800b29a6b0 | da38ee4e-7f7f-49c6-b8ab-5be190629301 | 85875baf-… artifact (source row evidence_id 673829fa-0eb3-445d-bab8-27af369b87f4) | 40d6aec429c8b02bfbd6003e0b385b283ac5dbbb35104250a31a7c1e867cc6d7 | layer2/AU/coverage/d263eab5-…/7dbf9947-…/40d6aec4….html.gz (existing capture of 16 Nov 2026 reused; page not re-fetched) | Country and qualification table (diploma, direct bachelor) | Undated page |
| SAIBT | c001e5eb-bb39-4bf9-8284-ad13b7dd912f | 4bd23307-66df-4a87-9c8f-df0635218023 (v12.0, 404 gone, not stored) | none | none | none | Diploma Stage 1 / Stage 2 and Graduate Certificate, by country | v12.0 gone; v12.1 registered by s1092, fetch pending |

Active courses: APAC 11, ICHM 27, SAIBT 9 (47).

## Source defects
- SAIBT v12.0 PDF answers 404; v12.1 (`admissions-entry-criteria-v12.1_public.pdf`) found and registered in s1092.
- CQU hub document stays `not_html` (3 attempts): the link crawl is S1-Build's task.

## Held (HELD:NO_SOURCE, S1-BLOCKER-QUEUE.csv, Batch 4)
17 providers: Chisholm, ACAP, Australian University of Theology, Australian University College of Divinity, University of Divinity, Strathfield, Skills Institute Australia, Kingston International College, Pacific College of Technology, Macquarie English, Australian Harbour International College, ACBI, Stott's, AITE, Australian Ideal College, Charlton Brown, ACPE (outdated 2020 PDF only), Gordon TAFE (equivalencies page not found).

Spend: 0 model calls and US$0 by this lane; 0 Firecrawl credits (all direct HTTP).
