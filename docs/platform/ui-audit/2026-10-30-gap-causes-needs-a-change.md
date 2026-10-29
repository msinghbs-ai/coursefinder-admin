# Why values are missing — every "needs a change" row (30 Oct 2026)

**What this is:** the complete list behind the hourly phone report's "needs a change" line. The phone report keeps its 260-word limit and shows only the largest rows; this file holds all of them, so none is left out.

**Cut-off:** a row is listed when nothing automatic covers its cause ("needs a change") and it affects 20 or more courses. That gives **47 rows**.

**Source and age of the evidence:**
- Snapshot from job `gap-causes` (job 294), run at **23:55 AEDT on 29 Oct** (12:55 UTC). It is stored under the label 12:00 UTC because the job stamps the start of the hour (see the monitoring note at the end).
- The provider columns were recomputed read-only at 00:12 AEDT on 30 Oct. A session copy of `security.gap_causes_snapshot_v1()` was grouped by provider and wrote nothing. Every row total matched the snapshot exactly.

**Owner and governed action, by cause:**

| Cause (as shown in the app) | Owner | Governed action |
|---|---|---|
| … university rule / calendar **not found** | Adapter builder | Add the provider's central page (Adapter builder › central page). |
| … rule / calendar **gives no values** | Adapter builder | Attach the right central page; the one read gives nothing. |
| … rule / calendar **approved** (rule covers other study levels) | Platform Admin | Decide whether the rule should cover this course's level. The platform does not widen a rule by itself. |
| … **waiting for approval** | Layer 4 reviewer | Decide the proposed rule in Layer 4 › Attributes. |
| page not read: **robots_disallowed** | none (source availability) | Record as a known gap; the site does not allow reading. |
| page proof (…) **not admitted for this field** | Platform Admin | Settings › Identify the page: decide whether this proof admits the field. Identity gates stay as they are. |
| no page: **web search stopped** | Pipeline Operator | Search again or a Find course pages task. This is **paid**, so it needs a spend line (WS8). |
| **campus has no city** | Curator | Add the city to the campus record. |

## The 47 rows

| # | Country | Attribute | Cause | Courses | Providers | Largest providers (courses) | Owner |
|---|---|---|---|---:|---:|---|---|
| 1 | AU | intakes | calendar not found | 3,646 | 609 | Australian University College of Divinity 41; Aventia Institute 35; Datum College / Fluent Education 25; Business College Online group 24; Bentley College 24; AICSE 23 | Adapter builder |
| 2 | AU | intakes | calendar approved (other levels) | 1,732 | 58 | University of Sydney 229; University of Melbourne 169; Macquarie 125; Flinders 116; James Cook 96; Western Sydney 77 | Platform Admin |
| 3 | AU | english | English rule not found | 1,440 | 404 | Australasian International Academy 21; English in Paradise / Elston 20; ACAH 18; Capital College 16; University of Divinity 16; AIAS 16 | Adapter builder |
| 4 | AU | english | English rule approved (other levels) | 1,084 | 86 | Bond 93; Flinders 76; University of Melbourne 66; UWA 47; TAFE NSW 42; ICMS / Aspire group 34 | Platform Admin |
| 5 | AU | intakes | calendar gives no values | 1,081 | 69 | ANU 234; Murdoch 43; York Business Institute 31; AITE 29; AHMI 29; George Brown College 26 (a Canadian college listed under AU, see data note) | Adapter builder |
| 6 | CA | english | English rule approved (other levels) | 531 | 17 | Durham 112; SFU 96; Camosun 79; Cambrian 53; Canadore 50; Langara 38 | Platform Admin |
| 7 | NZ | intakes | calendar not found | 459 | 76 | Massey 114; Open Polytechnic 64; BCITO 22; NZ School of Education 22; Auckland 15; Canterbury 13 | Adapter builder |
| 8 | NZ | english | English rule not found | 430 | 76 | Massey 142; Te Whare Wānanga o Awanuiārangi 36; NZ Tertiary College 15; People Potential 13; Skills Active 11; Cavalli College 9 | Adapter builder |
| 9 | CA | intakes | calendar approved (other levels) | 396 | 10 | Conestoga 128; UBC 90; SFU 78; MacEwan 43; Calgary 27; Georgian 13 | Platform Admin |
| 10 | CA | intakes | calendar not found | 377 | 14 | Alberta 220; La Cité collégiale 34; Algonquin 33; Okanagan 31; Confederation 12; Selkirk 9 | Adapter builder |
| 11 | CA | english | English rule not found | 344 | 12 | Okanagan 75; Sheridan 75; Loyalist 56; College of the North Atlantic 44; College of the Rockies 41; Georgian 15 | Adapter builder |
| 12 | AU | english | English rule gives no values | 303 | 47 | Top Education / ANIMC 23; Gamma Education 23; Global College Australasia 20; Salford College 19; Academies Australasia 18; Sunraysia TAFE 18 | Adapter builder |
| 13 | NZ | english | English rule gives no values | 278 | 5 | Canterbury 203; Auckland 39; MIT and Unitec 18; Laidlaw 14; Wintec 4 | Adapter builder |
| 14 | CA | english | English rule gives no values | 264 | 1 | Conestoga 264 | Adapter builder |
| 15 | NZ | intakes | calendar approved (other levels) | 201 | 3 | Otago 179; Ara 18; Toi Ohomai 4 | Platform Admin |
| 16 | NZ | fee | proof `degree_name` not admitted | 182 | 16 | Canterbury 65; Waikato 36; Auckland 26; SIT 19; AUT 10; Lincoln 7 | Platform Admin |
| 17 | NZ | english | English rule approved (other levels) | 174 | 12 | Otago 37; WITT 29; Waikato 29; Victoria Wellington 25; Lincoln 12; Whitireia and WelTec 11 | Platform Admin |
| 18 | CA | intakes | calendar gives no values | 125 | 11 | Victoria 44; Canadore 19; Mount Royal 17; Capilano 16; Camosun 12; The King's University 6 | Adapter builder |
| 19 | CA | fee | proof `adapter_title` not admitted | 115 | 4 | Lethbridge 93; Victoria 10; UBC 9; Athabasca 3 | Platform Admin |
| 20 | NZ | intakes | calendar waiting for approval | 115 | 7 | Victoria Wellington 58; AUT 29; Otago Polytechnic 7; NMIT 7; EIT 6; WITT 6 | Layer 4 reviewer |
| 21 | AU | intakes | calendar waiting for approval | 110 | 17 | Australian Ideal College 28; Laneway / Acquire Training 27; AHSI 17; College of Sports & Fitness 7; Sarina Russo 5; EQUALS 4 | Layer 4 reviewer |
| 22 | AU | intakes | robots_disallowed | 99 | 9 | Newcastle 45; UWA 28; Melbourne City Institute 16; St Aidan's 3; Sunshine Coast 3; Chisholm 1 | none |
| 23 | AU | delivery | robots_disallowed | 97 | 9 | Newcastle 45; UWA 27; Melbourne City Institute 16; St Aidan's 3; Sunshine Coast 2; Chisholm 1 | none |
| 24 | AU | official_page | robots_disallowed | 77 | 9 | Newcastle 45; UWA 13; Melbourne City Institute 10; St Aidan's 3; Sunshine Coast 2; UTS 1 | none |
| 25 | CA | english | English rule waiting for approval | 74 | 4 | Thompson Rivers 44; Royal Roads 18; BCIT 6; Algonquin 6 | Layer 4 reviewer |
| 26 | NZ | campus_region | campus has no city | 60 | 16 | NZ Tertiary College 17; NZ College of Chinese Medicine 5; Waikato School of Hairdressing 5; ATNZ 5; Regent Training 5; NZIS 3 | Curator |
| 27 | NZ | intakes | calendar gives no values | 57 | 5 | Whitireia and WelTec 29; SIT 14; NorthTec 5; Wintec 5; Lincoln 4 | Adapter builder |
| 28 | CA | english | proof `nzqa_code` not admitted | 53 | 1 | College of the North Atlantic 53 (an NZ proof kind on a Canadian provider, see data note) | Platform Admin |
| 29 | CA | fee | proof `nzqa_code` not admitted | 53 | 1 | College of the North Atlantic 53 | Platform Admin |
| 30 | CA | intakes | proof `nzqa_code` not admitted | 53 | 1 | College of the North Atlantic 53 | Platform Admin |
| 31 | CA | official_page | proof `nzqa_code` not admitted | 53 | 1 | College of the North Atlantic 53 | Platform Admin |
| 32 | CA | intakes | calendar waiting for approval | 48 | 5 | UNBC 26; Niagara 10; Lethbridge 9; Fraser Valley 2; Athabasca 1 | Layer 4 reviewer |
| 33–40 | NZ | campus, delivery, duration, english, fee, intakes, international, official_page (one row each) | web search stopped | 44 each | 1 | NZ Management Academies 44 | Pipeline Operator (paid) |
| 41 | AU | english | robots_disallowed | 40 | 7 | Melbourne City Institute 16; UWA 13; Newcastle 5; St Aidan's 3; UTS 1; Gippsland Grammar 1 | none |
| 42 | AU | intakes | proof `adapter_code` not admitted | 32 | 1 | Macquarie 32 | Platform Admin |
| 43–46 | AU | delivery, english, intakes, official_page (one row each) | web search stopped | 31 each | 1 | Academy of Interactive Technology 31 | Pipeline Operator (paid) |
| 47 | NZ | english | English rule waiting for approval | 26 | 2 | SIT 25; NZ Aviation Academy 1 | Layer 4 reviewer |

**Rows by owner:**

| Owner | Rows | What it takes |
|---|---:|---|
| Adapter builder | 12 | Central pages. This is the largest effort: rows 1 and 3 alone span 609 and 404 mostly small providers. |
| Platform Admin | 13 | Rule level scope (6 rows) and page-proof admission (7 rows), all through existing settings and decisions. |
| Layer 4 reviewer | 5 | Rule approvals, which are human. |
| Pipeline Operator | 12 | Two providers, with paid search. |
| Curator | 1 | Campus cities. |
| none (robots) | 4 | Source availability. |

## Data notes for follow-up (not changed)

1. **George Brown College (Toronto) is counted under AU** (26 courses in row 5): the provider record's country should be checked by a Curator.
2. **College of the North Atlantic (CA) has 53 pages bound with proof `nzqa_code`,** a New Zealand qualification proof. The identity gate correctly refuses it. How it was bound is part of the WS4 identity investigation.
3. Some provider names are joined trading names (for example "Business College Online, Dragon College of Business, …"). The table shortens them. The data is as stored.

## Monitoring note

The snapshot is stamped with the start of the hour, so a run at 23:55 is labelled 23:00 AEDT (12:00 UTC) and looks 55 minutes older than it is. The hourly report read it at 23:20 as "11:00 UTC, about 80 minutes old". In fact it was the 22:55 run, 25 minutes old. Every run in the last 24 hours succeeded. The fix is set out in the 30 Oct reconciliation (`2026-10-30-enrichment-health-reconciliation.md`, WS7).
