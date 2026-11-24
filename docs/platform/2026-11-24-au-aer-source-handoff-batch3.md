# AU AER source hand-off, Batch 3 (S1-RM-Design to S1-AER-Claude)

Platform Admin brief 24 Nov 2026 22:15 AEDT (AER-FU-04, Steps 1 and 2 only). Migration `20261125190000` (s1086), Pilot #1581, Admin #1000. Stored by the existing `entry-matrix-read` worker on 24 Nov 2026 between 11:20 and 11:30 UTC (22:20 to 22:30 AEDT).

## Stored sources

| Provider | Active courses | Provider ID | Source URL | Source ID | Evidence ID | SHA-256 content hash | Read via |
|---|---|---|---|---|---|---|---|
| Queensland University of Technology (diploma) | 294 | 2c4f515c-c146-4e90-ba8a-294130aa1f40 | https://www.qut.edu.au/__data/assets/pdf_file/0016/82033/International-entry-requirements-by-country-diploma.pdf | fd198a4d-ac37-4910-8e4e-62be983653a0 | 4ac8c62f-1146-40ae-a4c2-459d10e5920b | 14a2a3626bf12af209d42145da9a777c90bf0c837fb7332d72546c86d7a1918f | Firecrawl |
| Queensland University of Technology (foundation) | (same 294) | 2c4f515c-c146-4e90-ba8a-294130aa1f40 | https://www.qut.edu.au/__data/assets/pdf_file/0018/82053/International-entry-requirements-by-country-foundation.pdf | 649d017d-a168-4bc5-a656-e176c499d150 | 472debaa-7900-4ec0-acef-6b1c518cfbe2 | 60b909a55d3e504ebfc7914f7297a2fc193c2b229d592c35d3ce06e24e1db4df | Firecrawl |
| TAFE International Western Australia | 102 | 7339c659-60a6-4839-ba65-e1f5b926bdf8 | https://www.tafeinternational.wa.edu.au/tafe-courses/tafe-admission-requirements | 8bdc520c-78c1-4652-9e66-1f60fc7f1202 | e07da7bd-838e-41fd-b0f8-53cac29d6490 | d263786cf8b3cb3a9d19cc204b5989a94fdecd7f671119fe611c6b7b785960ed | direct |

Courses represented: 396 active courses (QUT 294, TAFE International WA 102). QUT's two PDFs were registered by another session at 11:15 UTC; this lane confirmed them and handed them over.

| Provider | Qualification and level | Edition | Structure |
|---|---|---|---|
| QUT | Diploma and foundation entry by country (secondary qualifications) | Current QUT asset paths; edition date not stated in the file name, S1-AER to read from the PDF | PDF country table (two files) |
| TAFE International WA | Year 10/11 and Year 12 equivalents by country, with English equivalents; VET certificate to diploma | Page about 76 days old at search; no year stated | HTML table: country, Year 10/11 equivalent, Year 12 equivalent, English equivalent |

## Platform automatic first run (not started by this lane)

| Provider | Run state | Rows admitted | Detail |
|---|---|---|---|
| QUT diploma | done | 0 | PDF read produced no rows: a PDF table reader gap, S1-AER or S2-AER work |
| QUT foundation | done | 0 | Same |
| TAFE International WA | queued | none yet | First slice timed out; the worker retries |

Model cost recorded by the platform for these runs so far: about US$0.002. S1-RM-Design made no model calls.

## Not stored

| Provider | Source | State | Reason |
|---|---|---|---|
| Central Queensland University | https://delivery-cqucontenthub.stylelabs.cloud/api/public/content/country-specific-academic-requirements?v=edf51706 (source ID 50e4031c-da08-489e-a34a-e87659820ede) | `found`, attempts 2 of 3, error `not_html` | The CQU content-hub endpoint does not return a page the existing reader accepts. Its text says the scores follow 2024 entrance-exam cut-offs, so edition currency needs S1-AER's check as well. Recorded in the pending-task register |
