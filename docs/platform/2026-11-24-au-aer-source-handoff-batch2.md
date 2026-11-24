# AU AER source hand-off, Batch 2 (S1-RM-Design to S1-AER-Claude)

Platform Admin brief 24 Nov 2026 21:38 and 22:15 AEDT (AER-FU-04, Steps 1 and 2 only). Migration `20261125150000` (s1078), Pilot #1576, Admin #984.
All five sources were registered through `pipeline.entry_matrix_sources` (found_via `manual`, rank 3) and stored by the existing `entry-matrix-read` worker on 24 Nov 2026 at 10:56 UTC (21:56 AEDT). Stored copies are under `layer2/AU/entry-matrix/<provider>/<source>/<hash>`; S1-AER can parse them without re-fetching.

## Stored sources

| Provider | Active courses | Provider ID | Source URL | Source ID | Evidence ID | SHA-256 content hash | Read via |
|---|---|---|---|---|---|---|---|
| Murdoch University | 267 | fbe38fea-5f2c-4946-9097-1de27ea0940f | https://www.murdoch.edu.au/study/international-students/entry-requirements/previous-tertiary-study | 232fc7e5-01ce-4da5-a9ee-a2cb4704b625 | 5305f165-46af-4458-9e92-89b32fa68bd3 | 1fbeca8fe210d66b2068cf167e6dd3b5b27d22b2732f627c59166ff9c55cffca | direct |
| Southern Cross University | 153 | f30cd2cd-01fc-458e-a061-b7aa5faa8a00 | https://www.scu.edu.au/study/international-study/how-to-apply-international-future-students/admission-requirements/ | 640997d9-b388-4715-b2bb-e79e51ea40c5 | 728b810d-f68e-4b15-a521-40a62e49a4d4 | 4289dbbd6412ffe492d924310cc29c3ef80c2d5fc15f62bb19e8b6d73bb7a419 | direct |
| University of the Sunshine Coast | 148 | 42ea5eb7-d243-4e4d-a780-22858a090377 | https://usc.edu.au/study/international-students/how-to-apply/step-2-check-entry-requirements/undergraduate-program-admission-requirements | f8fea36c-93c3-455c-8d21-95304874ff57 | c74b8869-3d2f-4205-acc8-767b6a9e1568 | 6146b5023b029c936e2a9ef6d8aabfccc139ea7bd35b0a6f43283b3a36077141 | direct |
| James Cook University | 128 | fe6af182-f5ca-4a3c-bfb4-b0773ff1b113 | https://www.jcu.edu.au/applying-to-jcu/international/coursework/academic-and-english-language-entry-requirements | 4e19eff3-692b-4e75-92a2-3c2f635b4c67 | 4e75cb90-a30c-43b1-b27b-ab0c2aeda626 | 46f97174010c0989e8e3df3b63e36f9703e2ab56e35bb4434a3a989f199d6a90 | Firecrawl |
| TAFE NSW | 106 | 430a7fd4-6c32-41d8-b756-0ebbd16b2c0c | https://cd.tafensw.edu.au/api/-/media/Files/PDFs/International/TAFE-International-Academic-Requirements-by-Country.pdf | 7bdad32f-5001-4d45-81db-575d21b17ec0 | e10f55f3-43f2-4ad8-8fe1-c97ae8246a34 | 1a8a091db4e13d03afebad6cca5f26209ded1afd2a7e3092933253eaf0a164f8 | direct |

802 active courses across the five providers.

## Qualification, level, edition and structure

Structure notes come from the live pages as found on 24 Nov 2026; confirm against the stored copy.

| Provider | Qualification and level | Edition | Structure |
|---|---|---|---|
| Murdoch | Previous tertiary study by country (bachelor AQF 7 or equivalent, undergraduate and postgraduate minimums); secondary-by-country pages not yet registered | Current page (Murdoch publishes 2027 guides) | HTML table: country group, qualification, undergraduate minimum, postgraduate minimum |
| Southern Cross | Undergraduate "Academic Score by Country" (equivalent to Australian Year 12) | Current page; the 2026 international guide points to it | HTML country table |
| UniSC | Secondary qualifications and minimum grades, grouped by country; global qualifications first | Current page (lists Trimester 1 2027 dates elsewhere on the site) | HTML list grouped by country |
| JCU | Coursework undergraduate and postgraduate academic and English pathways | Edition currency not confirmed: search metadata puts the page at about 92 days old and the sister capped-courses page carries a 2027 intake table; the old 2013 to 2018 JCU PDFs were rejected as outdated editions | HTML, country detail may sit on sub-pages: S1-AER to check |
| TAFE NSW | Year 10 and Year 12 equivalents by country for VET and higher education | Current PDF (about 130 days old); an older 2024 copy exists and was not registered | PDF country grid |

## Outcome of the platform's automatic first run (not started by this lane)

The existing worker queued extraction runs on these sources straight after the fetch. S1-RM-Design did no reader or admission work.

| Provider | Run state | Rows admitted | Detail |
|---|---|---|---|
| JCU | done | 3 | Review item raised |
| Southern Cross | done | 2 | Review item raised |
| Murdoch | failed | none | Model timed out on slice 2 of 3; retry within the attempts setting |
| UniSC | failed | none | Model timed out; retry within the attempts setting |
| TAFE NSW | failed | none | `held_unparsed`: PDF grid not aligned. Needs a PDF grid reader, which is S1-AER or S2-AER work, not Steps 1 and 2 |

Model cost recorded by the platform for these runs: about US$0.0033 in total (mistral-small-3.2). S1-RM-Design made no model calls.

## Held in Batch 2 (pending-task register, `HELD:NO_SOURCE`)

La Trobe (248), Collarts (139), Holmesglen (44), Le Cordon Bleu Australia (69): no country table published; criteria are per course or a Year 12 equivalent statement only.
