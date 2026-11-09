# Layer 4 review batches: descriptions, English, AER, scholarships (and the other queues behind them)

Prepared 8 November 2026 (about 17:50 AEDT) by the Integration Controller for the Platform Admin. Read-only evidence: live `fxcwkweaxjtknorudmwp`, `security.layer4_inbox_counts_v1`, `security.work_review_ready_v1`, `pipeline.layer4_review_items`, the lane funnel (`pipeline.lane_funnel_readings`, measured 16:42 AEDT).

**Nothing here is a decision.** Every approve, reject or "except" is a person's call in the Layer 4 Inbox. No AI approval is used or implied. The order below is only where a person's time buys the most published data soonest.

## 1. The queue today

| Lane | Waiting | Ready to decide now | Not ready (why) | Approved so far | Published today |
|---|---|---|---|---|---|
| Provider descriptions (kind `provider_description`, provider items) | 4 | 4 | 0 | 0 | 0 providers |
| Course descriptions (same Inbox kind, course items) | 1,208 | 1,191 (funnel, review-ready) | 17 (not itemised here; the Inbox "Ready to decide" filter leaves them out) | 0 ever decided | 163 courses (153 UQ, 10 Federation, from the adapter path) |
| AER (kind `aer_review`) | 605 | **246** (38 of them "Approve except") | 333 technical holds, 26 stale | not measured | 1,304 active entry rows |
| English (course English, kind `course_english`; policy documents are not Inbox items) | 1 course item | 1 | 0 | n/a | 30,591 active English rows; 14,940 courses without a rule |
| Scholarships (kind `held_scholarship`) | 133 across 50 providers (69 late) | 133 | 0 | not measured | published count is on the Scholarships lane |
| Course links (kind `course_link`, `course_page_needed`) | 2,254 + 1,260 | 2,112 `official_course_url` items | n/a | not measured | 33,555 links held |
| Tuition validation (kind `fee_check`, field `provider_current_tuition_validation`) | 136 + 5 + 7 | 141 | n/a | not measured | 92,061 active fees |

Pace measured for AER: 11.8 hours for 1,000 items (about 42 seconds each), so 246 ready AER items are about 2.9 hours. No pace has been measured for the other kinds; the first batch of each is also the measurement.

## 2. Batches, in the order that unblocks the most

| Batch | Scope | Items | Where | What an approval does (as the Inbox states it) | Verify afterwards |
|---|---|---|---|---|---|
| **RB-1** | Provider descriptions: Monash University, University of Wollongong, Charles Darwin University, The University of Queensland | 4 | Inbox kind University description | Approve as read: published from the official page, shown on the website from its next read. Reject: nothing published, the university is read again after the set wait. Earlier controller finding, not a decision: the Wollongong read (`59a264e9`) looked wrong; read it before deciding. | Funnel stage "Active providers holding a description" rises from 0 by the number approved; the provider's description is in the Website and Zoho projection within about 10 minutes |
| **RB-2** | AER, ready items. Sub-batches follow the pack: 187 complete and unlocked (Approve all rows or Reject), 20 complete with a page-address lock, 25 Approve except (unlocked), 13 Approve except with a lock, plus 1 added since the pack. Start with **RMIT (303 waiting)**, then Monash 66, AUT 46, QUT 38, ANU 22 | 246 | Inbox kind Entry requirements. Item-level tables: `docs/platform/aer-review-pack-20261108.md` section 10 | Approve all rows: every waiting row becomes active once the identity, completeness, scale and basis checks pass; the source's earlier rows are superseded. Approve except: ticked rows stay out with your reason. Reject: every waiting row is withdrawn | Funnel stage "Active course entry rows" rises from 1,304; no row from a rejected read is active; the course page shows the requirement in the Website and Zoho projection |
| **RB-3a** | Course descriptions, **quality sample first**: one course from each of 50 providers (list in section 3) | 50 | Inbox kind University description, filter to a ref | Approve as read publishes the description quoted from the official page. A rejection or a change in this sample tells the Controller to hold the rest of the queue | Funnel "Active courses holding a description" rises by the number approved; the sample's refs show on the Website |
| **RB-3b** | Course descriptions by provider, largest first: Toi Ohomai (17), Whitireia and WelTec (17), Waikato Institute of Technology (16), University of Canterbury (16), UCOL (15), Victoria University of Wellington (14), University of Otago (13), then Lincoln, Melbourne and ANU (12 each). The top 10 are 144 items; 463 providers in all | 1,158 after RB-3a | same | same. 580 first admissions are held behind the provider cap (a setting, `enrich.*`); an approved item behind the cap is not published until the cap allows it, which the check after each batch looks for | same |
| **RB-4** | English: the 1 course English item (Queensland University of Technology, 30 Oct) and the policy readings in `docs/paste/ENG-20261108-english-policy-review-pack.md` in the Pilot repo (29 readings, 7 look misread: read these first) | 1 + 29 | Inbox for the course item; the policy readings are decided as the pack describes | Approving a policy reading is what lets the existing English jobs apply it to courses that have no rule (14,940 today), as the pack describes | Funnel "Courses with no active English rule" falls; "Active course English rows" rises |
| **RB-5** | Scholarships held: late first (69 late). Largest: Wesley College Melbourne 11, Australian Harbour International College 9, University of Alberta 9 (5 late), UNSW Sydney 8 (3 late), The Geelong College 5, The University of Sydney 5 (5 late), Department of Education 5 | 133 | Inbox kind Held scholarship | Publish: taken as for international students and offered, the hourly publish checks still apply. Not international / Not a scholarship / Duplicate: refused, not asked again | Published scholarship count rises by the number approved; each is in the Website and Zoho scholarship feed |
| **RB-6** (same Inbox, not asked for by name) | Tuition validation 141 (Waikato Institute of Technology 41, Burman University 27, College of the North Atlantic 15, Thompson Rivers University 15, Canadore College 12) and course links 2,112 (University of Auckland 197, Macquarie 62, Manukau 62, Whitireia 61, UNSW 52) | 141 + 2,112 | Inbox kinds Fee fails the check, Course link | per the Inbox choices | Funnel fee and disc stages |

The scholarship lane also holds decisions that are not Inbox items (text-only award publication 243, opening Canada, New Zealand and non-university search 1,208, the three recovery switches). They are recorded once in the register and are not repeated here.

## 3. RB-3a sample (50 courses, one per provider; refs are the first 8 characters of the review item id)

| Ref | Provider | Course |
|---|---|---|
| a10b1204 | Academy of Interactive Technology | Diploma of Information Technology |
| 68df7ce9 | Apex Australia Vocational Education | General English |
| ff8e8919 | Ashton College; Ashton English | Advanced Diploma of Hospitality Management |
| 335d1c99 | Atlantis College of Management | Advanced Diploma of Information Technology |
| 3d68f9cb | Australasia International School | Certificate III in Beauty Services |
| 84219005 | Australian College of Culinary and Management Pty Ltd | Diploma of Hospitality Management |
| cda36c01 | Australian College of Professional Careers Pty Ltd | Advanced Diploma of Program Management |
| 43b134bf | Bay of Plenty Technical Institute Limited | New Zealand Certificate in Equine Skills (Level 3) |
| 2601c8a8 | Christian Heritage College | Bachelor of Education (Primary) |
| 7c93cd67 | D P TRAINING PTY LTD | Certificate IV in Community Services |
| f2f84bd5 | Danford College | Advanced Diploma of Building and Construction (Management) |
| 9fdaf0d9 | Education Training & Employment Australia | Advanced Diploma of Leadership and Management |
| bae891d6 | English in Paradise; ELSTON EDUCATION & TRAINING | Diploma of Business |
| 247f6d32 | Global Institute of Training and Education Pty Ltd | Certificate III in Individual Support |
| 001f8443 | Gold Coast International College | Certificate IV in Fitness |
| bace6a85 | Greenhill Institute Pty Ltd | Diploma of Leadership and Management |
| 39bcacf2 | Holmesglen, Holmesglen Institute | Certificate IV in Cyber Security |
| 65410895 | Kingston Academy of Australia | Certificate III in Early Childhood Education and Care |
| 43982839 | Lexis TESOL Training Centres | Advanced Diploma of Leadership and Management |
| 1694be4c | Lotus College | Diploma of Project Management |
| ea445892 | Loyalist College | Radiation Safety |
| ecf419e9 | Manukau Institute of Technology and Unitec - Unitec | Master of Landscape Architecture (Level 9) |
| ecd137eb | Marriott Academy | Diploma of Hospitality Management |
| 28f7e94f | Mastery Institute Australia | Diploma of Hospitality Management |
| 46434076 | McIver College | Diploma of Hospitality Management |
| 0e5b5903 | Melbourne Institute of Australia | Graduate Diploma of Management (Learning) |
| aa77fa13 | MELBOURNE INSTITUTE OF TRAINING AND EDUCATION | Certificate IV in Disability Support |
| 574ec542 | MILESTONES EDUCATION ACADEMY (group) | Graduate Diploma of Management (Learning) |
| ae7d52fa | National Training Centre of Australia (group) | Certificate IV in Kitchen Management |
| 34c81c04 | New Zealand College of Chinese Medicine Limited | New Zealand Certificate in English Language (Academic) (Level 4) |
| b22ca0e5 | New Zealand School of Food and Wine Limited | New Zealand Certificate in Food and Beverage Service (Level 4) |
| 44a6a7af | PLATINUM COLLEGE OF TECHNOLOGY AND BUSINESS | Certificate IV in Kitchen Management |
| e94607ba | Polytechnic Victoria Pty Ltd | Diploma of Automotive Technology |
| a5573ca7 | Prime Education Group Pty Ltd | Diploma of Hospitality Management |
| 0d3d1ee6 | Salford College | Certificate IV in Kitchen Management |
| 55298d66 | SIGNATURE TRAINING PTY. LTD. | Advanced Diploma of Hospitality Management |
| efe161b0 | Southern Academy of Business and Technology | Diploma of Finance and Mortgage Broking Management |
| ce8e315a | Sydney Metropolitan English Institute | English for Academic Purposes (EAP) |
| ff744007 | Teach First NZ Charitable Trust | Master of Community Action & Social Impact (Level 9) |
| 4396712f | The Open Polytechnic of New Zealand | New Zealand Certificate in Information Technology Essentials (Level 4) |
| ada1a681 | The Performance College | Graduate Diploma of Management (Learning) |
| b0a78dc4 | Top Education Institute (group) | Graduate Diploma of Data Analytics |
| 7bb7d171 | Tower Australian College Pty Ltd | Advanced Diploma of Information Technology |
| 01bacb82 | TrEd College | Diploma of Hospitality Management |
| 2aee9830 | Unity School of Education | Advanced Diploma of Leadership and Management |
| 8985178a | University of Canterbury | Postgraduate Certificate in Product Design (Level 8) |
| 9e4c65fc | University of Waikato | Master of Disability and Inclusion Studies (Level 9) |
| 607c65cb | VIA Education | Advanced Diploma of Marketing and Communication |
| 4a1afe3c | WIC SYDNEY | Certificate III in Commercial Cookery |
| adc7b5fc | WIN English Centre / WIN College | Certificate IV in Financial Services |

The sample is deterministic (one pending item per provider, ordered by a hash of the provider id) and mixes vocational, English-language, New Zealand and university providers.

## 4. What the Controller does after each batch

1. Re-reads the lane funnel for the stage named in the batch and records the before and after in the Execution Register, with the item refs.
2. Confirms the approved items were admitted (not left waiting behind a hold) and published; any approved item that did not advance is a defect, diagnosed and recorded, not left.
3. Reads the Website and Zoho projection for a sample of the approved items after the next sync cycle.
4. Reports the number of items a reviewer decided per hour for that kind, which becomes the measured pace for the next batch.
