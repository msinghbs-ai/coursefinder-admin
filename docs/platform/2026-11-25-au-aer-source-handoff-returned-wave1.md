# AU AER source hand-off: returned providers wave 1 (S1-RM-Design to S1-AER-Claude)

Platform Admin, 24 Nov 2026 23:47 AEDT, AER-FU-04, Admin #1019 and #1027. Steps 1 and 2 only: sources found, registered and stored by the existing `entry-matrix-read` job. No reader, rule or admission change. Spend: US$0.00, no Firecrawl credits used by this lane (all reads direct HTTP).

## Stored and ready (edition as printed on the document or page)

| Provider (active courses) | Source ID | Evidence ID (artifact) | SHA-256 | Stored location | Qualification and scope | Edition |
|---|---|---|---|---|---|---|
| UNSW College (23) | 6cd4ad1b-83e0-43f5-8f42-36d89d24b2a8 | 0de927d0-41bb-450b-8c08-1e3155948276 | 678efdc71173a59a17c36f092db8eee11135121bacb81d25306226b00f6ebb86 | layer2/AU/entry-matrix/93c852cf-6df7-4161-82bd-ca95941cc227/6cd4ad1b-83e0-43f5-8f42-36d89d24b2a8/678efdc7….pdf.gz | Global Student Guide: Diploma, Foundation and Pre-Masters entry by country | "International Pathways 2025"; confirm it is the current edition |
| UNSW College (23) | 7d9a1f30-b815-4736-b69a-4d8bb7330cb7 | 44cd25ef-eeaa-4213-b7a2-595aa185f459 | b079a66e94c02186149cde3acf9874407ffdc43a63ff39a7132c8b9a07c6a69a | layer2/AU/entry-matrix/93c852cf-…/7d9a1f30-…/b079a66e….html.gz | Accepted Semester 1 results for conditional diploma offers, by country | Current page, undated |
| Kent Institute Australia (see register) | 7e0835af-4f40-48c0-b3ba-6eaa30372bff | 507a9025-86ac-408f-bd93-5f5d5f009efa | 70a880764deee54bf525d095e5c1e7ef01a6f6731d67a50426cd083b3907a892 | layer2/AU/entry-matrix/b3d3ae78-318c-4061-b19a-a734b86c9f85/7e0835af-…/70a88076….pdf.gz | Academic entry equivalences by country | Undated |
| AIH Higher Education (29) | 5130afb6-43a0-4f80-b19c-455283dcc662 | 2970e760-ebb2-4d15-803b-91596d244d20 | 35103341ffd283368124a70b62069a19d86f4a0492d5e99a4bdf04e779e717f6 | layer2/AU/entry-matrix/12924d5c-3e7d-4c99-a10f-10fc36bb244a/5130afb6-…/35103341….html.gz | Undergraduate and postgraduate academic entry, English equivalence | Current page |
| AIH Higher Education (29) | 7bff7c04-b246-48a6-99b6-243319ed72c7 | 1feb1b67-6b3a-4a84-8d0b-83064e9d4055 | a04a0ce58fcdbcd9c3a98e88636044da095708d090082e585e283e27d2ea5fa7 | layer2/AU/entry-matrix/12924d5c-…/7bff7c04-…/a04a0ce5….html.gz | International students entry requirements overview | Current page |
| Ozford (14) | 359796aa-02f7-48fc-8a00-405a24b0566a | 2ace747d-dd7d-486d-adcb-c0d09accde28 | dd1f0f762c7f101b9f6574e7f0e65c5bf3ea92ebdc0dfddba256460c8f5a7e38 | layer2/AU/entry-matrix/a1193021-e436-4e0f-8591-4fef64a53476/359796aa-…/dd1f0f76….html.gz | Undergraduate minimum entry (Year 12 or equivalent, Foundation, Certificate IV) | Current page |
| Ozford (14) | 5ac45615-a5d2-4057-986b-bcf3bf6187d5 | 6901d215-abb1-4a58-8801-4d70fcac2938 | 4d271e6596ca129afcdabba00dcac25a1f6c004595b4583f7777d69f2e7961af | layer2/AU/entry-matrix/a1193021-…/5ac45615-…/4d271e65….html.gz | Postgraduate entry requirements (MBA, MPA, Graduate Diploma) | Current page |
| Skills Australia Institute (15) | cb28d9ba-1014-4923-a3be-939c6a2cc5a9 | 1061d140-37a3-4033-858f-59d3605131a6 | 66269c1b3aac820cf54ba3904dba8067438659e841dfd3c88d67061c78fd4da0 | layer2/AU/entry-matrix/c4160a2b-7787-4be9-a772-b6f095c334c8/cb28d9ba-…/66269c1b….html.gz | Admission entry requirements, international students (general, no country table) | Current page |
| UWS College (5) | a8c211f3-afd0-4ecc-8a13-c2255842fc99 | 1ac7da7b-d6b0-454b-bc50-363d20894378 | 92aadee2605f (prefix; full hash in `pipeline.entry_matrix_sources.content_hash`) | Reused stored copy (read_via stored) | Western Sydney University entry qualifications by country (v07), including the college diploma columns | v07; confirm whether the college column set is complete |

## Registered, not yet stored

| Provider | URL | State |
|---|---|---|
| Western Sydney University International College (15) | .../wp-content/uploads/Academic-entry-requirements-June-2025.pdf and .../Academic-Entry-Requirements-Flyer-2104.pdf | found, awaiting worker read (s1100). The s1095 flyer URL returned 404 and was replaced. |
| Ozford (14) | https://ozford.edu.au/high-school/entry-requirements | found, awaiting worker read (s1100). The s1095 URL returned 404 and was replaced. |
| Queensland International Business Academy (12) | https://www.qiba.edu.au/?p=445, ?p=82 | found, awaiting worker read (s1100) |
| Academia International (14) | https://www.academia21.com/international-students/entry-requirements | found, awaiting worker read (s1100) |
| Skills Australia Institute (15) | .../allpdfs/international-student-brochure.pdf | HTTP 200 but `pdf_too_large`; needs a larger PDF limit or another read route (S1-Build). Contains the entry requirements section on page 24 of the brochure dated 28 Aug 2024. |

## Defects found for S1-Build

1. Two migrations named s1094 shared version 20261126003000 (Canadian scholarship hubs and my Kent registration). Only one applied. The unapplied file is `20261126003000_cf247_s1094_au_aer_source_acquisition_wave2_batch1.sql`; Kent was re-registered in s1096. The duplicate file on main should be retired.
2. `pdf_too_large` on the Skills Australia brochure (above).

## Held (no official source found; searched twice where noted)

Shafston (31), Sydney State College (16), Academy of Education and Innovation (19), Australian National Academy of Education (19), Durban International College (19), Perth College of Business and Technology (18), Institute of Management and Computing (17), Lyons College (17), Jabin Hopkins (16), Mercury Institute of Victoria (12), Edvantage (12), Pioneer International College (10), Elite Education Institute (10), Training Masters (10). Central Australian College (29), Bentley (27), Melbourne City Institute of Education (20) and Datum (29) have only per-course Year 10, 11 and 12 criteria, already stored, with no equivalency table on their sites.
