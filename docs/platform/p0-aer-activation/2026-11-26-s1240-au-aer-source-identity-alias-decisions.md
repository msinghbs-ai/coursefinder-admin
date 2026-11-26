# s1240: AU AER source identity verification and alias decisions (for Platform Admin approval)

S1-AER-Claude, 26 Nov 2026, AEDT. Assignment from SS-Programme-Control (26 Nov 16:28). Nothing here changes a setting. `aer.provider_host_aliases` is untouched until the Platform Admin approves.

## 1. Decision A: Central Queensland University (CQU)

| Item | Value |
|---|---|
| Internal provider | `f02d9d9b-0eb2-4f0e-8215-27a36ae63aa6`, Central Queensland University, CRICOS 00219C, website `https://www.cqu.edu.au` |
| Proposed alias | `f02d9d9b-0eb2-4f0e-8215-27a36ae63aa6:delivery-cqucontenthub.stylelabs.cloud` |
| Stored source | `50e4031c-da08-489e-a34a-e87659820ede`, `https://delivery-cqucontenthub.stylelabs.cloud/api/public/content/country-specific-academic-requirements?v=edf51706`, status read, read via direct, found via manual |
| Document edition | `v=edf51706` in the address; the PDF itself carries no separate edition date in the stored record |
| Evidence | `fb856fec-1957-4291-869b-e6b977a0b8b8`, content hash `976f3c5eb6af5d4013840e4fe81d107f3d741d624093ebfb7e8e7954b543db42`, captured 25 Nov 2026 07:59 (Melbourne), `layer2/AU/entry-matrix/f02d9d9b…/50e4031c…/976f3c5e….pdf.gz` |
| Run | `87dec4ea-856b-486b-b5f6-27ec1afb3ee4` done, reader `pdf-columns-v1`, 112 rows kept, 19 dropped (`no_minimum_published`) |
| Retired copy | `55de8e6d-385a-409f-a759-aa3585f9bb3a` (`…#.pdf`), inactive, same content hash, run failed. Not to be revived. |
| Official page | `4ff4010f-5c81-4c47-bc83-59ac30465541`, `https://www.cqu.edu.au/study/international/entry-requirements/academic-requirements`, firecrawl, evidence `d5e12d94-87cd-4370-81be-75ead282663d`, hash `670d076bcee242bf9adf79e0be008a3b03d77ee23bdd91774c133ace33d55ed1`, captured 11 Nov 2026 |
| Machine decision | `source_not_official_host` (host differs from `www.cqu.edu.au`) |

Verification. The Platform Admin's independent check says the official page links to the CDN host. A plain page read of the live page (WebFetch, which drops link targets) confirms the page text points readers to a "country specific academic requirements document" but could not show the link target. The stored page copy (`d5e12d94`) is gzipped storage and is not readable from this session. **Action for the approver or S2-AER:** confirm the link target inside the stored copy before approval. Pointing the check at that evidence is a read-only step.

Scope check. The alias is for one provider and one host. The host is a CDN that serves CQU's content hub, so the alias must not be shared with any other provider. CQU is not ACU. The matrix rows held under ACU (377) are a separate defect for S2-AER.

## 2. Decision B: Australian Institute of Business and Technology (AIBT)

| Item | Value |
|---|---|
| Internal provider | `eb9e3903-6d92-4502-a2b3-51cb231b21fc`, "Australia Institute of Business and Technology", stable key `provider:cricos:03430j`, catalogue website `http://aibt.qld.edu.au/` |
| Proposed alias | `eb9e3903-6d92-4502-a2b3-51cb231b21fc:aibtglobal.edu.au` |
| Do not alias | `fc6f01a7-66fb-4fd3-aa9d-93e82535230d` AIBT International, CRICOS 03610E, `aibti.edu.au`. A different registered entity. |
| Identity evidence | Platform Admin independent check: Queensland Skills Gateway lists `aibtglobal.edu.au` for RTO 41138; Study Australia lists CRICOS 03430J. CRICOS 03430J matches the internal stable key. |
| Stored source 1 | `cfd07ffe-9ef9-40ac-8b0c-291692de1f22`, `https://aibtglobal.edu.au/courses/study/diploma-leadership-management/`, read via stored, evidence `15aa5655-14b8-438a-929f-6ec3ca00730f`, hash `3e977a9dc58fa0bac954e00764985a624571f8ad66894c7d206e6bb2efee2604`, captured 18 Nov 2026 11:48, run `d1ec9ef0-c5a9-45e2-8670-28713cb4a49b` done kept 1 |
| Stored source 2 | `5bf468bf-679d-46e4-a691-b414226f1765`, `https://aibtglobal.edu.au/about/course-terms/`, direct, evidence `94a7a625-ee43-4679-8f60-f79389f4dc76`, hash `274c5c3c20d4028293d97a3d2173d0c00afa7e22003a4f58aabf48de27546c92`, captured 25 Nov 2026 06:50, run `19fbeb31-110d-4c50-8c32-484f7de020e2` done kept 0 |
| Machine decision | `source_not_official_host` (catalogue website host is `aibt.qld.edu.au`) |

Open point. The RTO 41138 to CRICOS 03430J link rests on the two registers the Platform Admin cited. I did not re-fetch them. The catalogue website `aibt.qld.edu.au` should also be refreshed to `aibtglobal.edu.au` by the owner of provider records (S2-AER) so the host rule stops depending on an alias.

## 3. Consumer read-back with official course identifiers

`public.website_v3_course(p_identifier, p_edu_country)` resolves through `search.course_documents.course_stable_key` (lower-case). The UUID is not accepted; this is the cause of the earlier `NOT_FOUND`. Using stable keys with country `IN`, read-back returned entry-requirement resolution rows for these newly admitted courses (no error):

| Provider | Stable key | Rows |
|---|---|---|
| Aventia Institute | `course:cricos:03473j:108773b` | 1 |
| Box Hill Institute | `course:cricos:02411j:120271a` | 3 |
| Collarts | `course:cricos:03392k:0100338` | 2 |
| Excelsia University College | `course:cricos:02664k:0101531` | 4 |
| Gold Coast Learning Centre | `course:cricos:03268c:0100042` | 1 |
| La Trobe University | `course:cricos:00115m:055088k` | 3 |
| Lead College | `course:cricos:03636f:0101416` | 1 |
| York Business Institute | `course:cricos:03549e:106425e` | 1 |

Three other recently admitted courses (Australian College of Business Intelligence, Australian College of Community and Health Services, DNA Kingston Training) returned resolution step 5 with no rows. They are not read-back failures of this cohort; they resolve to "no requirement held" and are listed for S2-AER.

## 4. PDF layout recovery

| Provider | Source | Finding |
|---|---|---|
| Le Cordon Bleu | `395c1ea5-6a76-42e5-9fd1-daedf35e5eac`, `AAGCEN25513.pdf`, hash `cc73667d579f1ec7cb16c3269cc845d185e4b91fad591304bbe29f9f5aa9fe2e` | Student Selection and Admission Policy v10.0, approved 18 Dec 2024, 34 pages. Table B "Academic Entry Requirements by Country of Education" runs pages 16 to 33: one continuous table, repeated header, a Country column plus 11 qualification columns, one row per country. Table A (page 15) is non-country. The run failed with `held_unparsed: PDF page 3: "7." is outside the rules of its column`. Page 3 is not part of Table B; the reader is failing the whole document on a page that holds no entry table. |
| Excelsia | `a9e409bc-0560-4598-a940-994fde3374a2`, `International-Students-Guide.pdf`, hash `c5919a6454c18d5a4fabcf93bd66deac310b02ede3950a7b69c5be1224c90b92` | International Students Guide, "Version 2026". It has no academic entry-requirements table (tables are weekly living costs, climate, help desk), and says course requirements are in the course brochures. The failure (`PDF page 2: "5" is in a column without row rules`) is the reader meeting a non-entry table. **No layout recovery is needed.** The guide is the wrong source for entry rows; its source row should be retired. Excelsia entry rows already come from its course pages (4 rows read back above). |

Proposed recovery for Le Cordon Bleu, within the existing qualified framework (`pdf-columns-v1` or the ruled-grid reader): restrict the reader to the pages that hold the entry tables (a page range 15 to 33) instead of failing the document on an earlier prose page. This is a reader-scope change and goes to S1-Build with S2-AER; it is not made in this lane. I could not fetch the PDF from this sandbox (the host is not on the allow-list), so the page range above comes from a page read, not from the stored copy. A stored-copy check with `entry_inspect` (read-only, s1049) should confirm before any reader change.

## 5. Held, unchanged

- Greenwich stays unpublished and hidden.
- Protected settings (`aer.provider_host_aliases`, publishing) untouched.
- William Angliss, George Brown and TasTAFE `gate_incomplete`, the 155 D-R3 decision rows and the ACU/CQU matrix-row ownership are S2-AER items.

## 6. Approval requested

1. Approve alias A (CQU) after the link target in stored evidence `d5e12d94` is confirmed.
2. Approve alias B (AIBT `eb9e3903…` only).
3. Approve retiring the Excelsia guide source `a9e409bc…`.
4. Approve S1-Build/S2-AER scoping Le Cordon Bleu's reader to its Table B pages.

After approval, the CQU and AIBT machine decisions are re-read and admission and consumer read-back are verified in the next cycle.
