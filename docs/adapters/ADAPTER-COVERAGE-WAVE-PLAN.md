# Adapter Coverage Wave Plan: closing the 980-provider gap

**Status:** IN PROGRESS (scheduled overnight wave runs from 7 Oct 2026, 00:09 AEDT) · **Change control:** CF-CHG-20260915-247 (M2.4.7) · **As at:** 7 Oct 2026, 07:05 AEDT (progress log; sections 1 to 8 as at 6 Oct 23:50)
**Companions:** `docs/coursefinder-university-adapters-v1.0.md` (design, Decision 254), `docs/adapters/ADAPTER-LESSONS.md` (playbook), `docs/adapters/README.md` (register).
**Source:** Platform Admin, 6 Oct 2026 23:00 and 23:13 (how many providers lack adapters, why admission is under 80%, plan waves, clean up tasks, queue for Layer 3 and Layer 4, plan around the Layer 2 approach).

## 1. Where we are (live database, 6 Oct 2026)

Active courses: 34,960 across 1,867 providers. "Admitting" means the provider's adapter has admission switched on with at least one field admitted. It does not mean every field is admitted (see the field view below).

| Country | Providers | Adapter exists | No adapter | Admitting | Courses admitting |
|---|---:|---:|---:|---:|---:|
| AU | 1,546 | 760 | 786 | 637 | 19,532 of 26,103 (75%) |
| NZ | 287 | 100 | 187 | 54 | 3,693 of 6,475 (57%) |
| CA | 34 | 27 | 7 | 15 | 1,763 of 2,382 (74%) |
| **Total** | **1,867** | **887** | **980** | **706** | **24,988 of 34,960 (71.5%)** |

**Why admission is under 80%.** The 10,000-odd courses outside admission split in two:

| Cause | Providers | Courses | Share |
|---|---:|---:|---:|
| No adapter | 980 | 5,646 | 16.1% |
| Adapter exists, not admitting (held at the Qualify gate) | 181 | 4,326 | 12.4% |

- 943 of the 980 providers without an adapter have fewer than 20 courses each (4,114 courses). Cost per adapter is the same as for a large provider, so the long tail is slow to close.
- Of the 181 not-admitting adapters, 54 pass at least one Qualify field (AU 35, NZ 15, CA 4) and 127 pass none (AU 88, NZ 31, CA 8). The earlier Qualify run showed AU 37 of 124, CA 4 of 12 and NZ 16 of 46 passing. Those results are not admitted (standing decision, "Not yet").
- On the provider-level measure, 80% of active courses is 27,968, about 2,980 more than today. On the per-field measure the gap is much larger (see the field view).

**Coverage by field (added 6 Oct, 23:55 AEDT, correcting the headline).** The 71.5% above is the share of courses whose provider admits at least one field. By field the picture is lower:

| Field | Courses whose adapter admits it | Share | Courses that hold a value today | Share |
|---|---:|---:|---:|---:|
| Intakes | 17,167 | 49.1% | 11,493 | 32.9% |
| English | 18,518 | 53.0% | 16,711 | 47.8% |
| Page fee (provider current tuition) | 14,765 | 42.2% | 8,020 | 22.9% |

Of the 706 admitting adapters, 258 admit one field, 264 two, 130 three, 49 four and 5 five. The 80% target needs a decision on which measure applies: provider-level (any field), or per field. Per-field is the stricter and more useful measure, and this plan should be read against it. Reaching 80% on every field needs many more adapters and many more admitted fields, not only the waves below.

## 2. Readiness of the 980 providers without an adapter

Tracks follow the lessons playbook (section 1): at least 2 read course pages means the adapter can be built now; fewer means page discovery comes first. Counts are from stored pages, not a live web check.

| Track | Meaning | AU | NZ | CA | Providers | Courses |
|---|---|---:|---:|---:|---:|---:|
| E | 2 or more read pages | 126 | 14 | 3 | 143 | 1,123 |
| F | Pages bound, fewer than 2 read | 237 | 137 | 0 | 374 | 1,515 |
| G | No pages | 112 | 30 | 0 | 142 | 918 |
| H | No own website (none or an aggregator) | 311 | 6 | 4 | 321 | 2,090 |
| | **Total** | 786 | 187 | 7 | **980** | **5,646** |

Stored page state across all providers: 21,959 read and bound, 7,033 identity mismatch, 763 needs render, 365 fetch failed, 226 blocked, 106 robots disallowed. Track F is mostly these render, fetch and blocked pages.

The 37 largest providers with no adapter (20 or more courses each) hold 1,532 courses and sit across tracks. Examples: New Zealand Institute of Skills and Technology (two records, 231 and 72 courses), University of Calgary (179), University of Notre Dame Australia (131), Skills Group Training (63), Academies Australasia (34), Holmes Institute (two records, 25 and 20), UOW College Australia (20), Bendigo TAFE and Kangan Institute (20). Duplicate provider records need a person to merge or confirm before building.

## 3. Operating model: Layer 2, adapter, Layer 3, Layer 4

Every course field follows one path. Nothing skips a gate and nothing activates by itself.

| Step | What happens | Cost | Gate |
|---|---|---|---|
| Layer 2 (find and read) | Firecrawl finds and reads the provider's own course pages and keeps the evidence in Supabase. Aggregator pages are never used. | About 1 credit a page read, about 2 credits a course for Find | Evidence stored; identity check passes |
| Adapter | A provider's reading rules read the stored pages (no credits). Preview, then `admin_adapter_measures`, then Qualify | None | Platform Admin admits each field with a reason |
| Layer 3 | Fields the adapter cannot read go to the pinned, cheapest qualified non-Anthropic cascade (about 80% success first, then escalate). Items that stay unsettled park | Small model cost | Cascade is controlled from the UI |
| Layer 4 | What Layer 3 cannot settle goes to a person, each with a plain-English reason | Reviewer time | A person approves, edits or rejects |

Rules that stay in force: no web fetching by wave agents (stored pages only); no direct table changes; exclude by course, not by URL, when a page is shared; domestic-only providers keep an adapter but do not admit; a passing check never auto-activates admission.

## 4. Waves

Gains are an upper bound if every course in the wave is admitted. Earlier waves admitted roughly a third of built adapters on first pass, so plan on a third of the upper bound unless Qualify blockers are fixed.

| Wave | Scope | Providers | Courses | Upper-bound gain | Layer 2 work | Decision needed |
|---|---|---:|---:|---:|---|---|
| 0 | Clean up queued and stuck work (section 5) | n/a | n/a | none | None | Approve what to cancel or re-queue |
| 1 | Largest 37 with no adapter | 37 | 1,532 | +4.4 points | Re-read blocked pages only | Merge or confirm duplicate records; Notre Dame domain (decision 10); Calgary rebind rule |
| 2 | Track E, the rest (2 or more read pages), grouped by site platform so one pattern serves several | up to 143 | up to 1,123 | up to +3.2 points | None (stored pages) | None |
| 3 | Qualify 54 not-admitting adapters with at least one passing field | 54 | to measure | to measure | None | Admit by field, per adapter (Platform Admin) |
| 4 | Repair 127 adapters that pass nothing (rebind, pattern, exclusions per lessons sections 2 to 4) | 127 | to measure | to measure | Targeted re-reads | None until repaired adapters re-qualify |
| 5 | Track F: re-read the render, fetch and blocked pages, then build as track E | 374 | 1,515 | up to +4.3 points | About 1 credit a page for the render, fetch and blocked pages of these providers (to be counted before approval) | Credit budget |
| 6 | Track G: Find, then build as track E | 142 | 918 | up to +2.6 points | About 1,800 credits | Credit budget |
| 7 | Track H: find each provider's own site; NZ ITOs and domestic-only providers keep an adapter without admission | 321 | 2,090 | up to +6.0 points | Site discovery | Whether small providers get adapters, or a CRICOS-only tier |

Reaching 80% on the provider-level measure: waves 1 and 2 reach about 79% at the upper bound, and wave 3 (admitting held adapters) closes the rest. On the per-field measure, wave 3 should admit every field that qualifies, and wave 4 repairs adapters for fields that fail. Waves 5 to 7 take coverage towards 95% but cost the most per course.

Per-wave gates: preview on stored pages, measure with `admin_adapter_measures`, Qualify, then admit by field with a reason. Each wave records its configurations in `docs/adapters/configs/` and updates the register the same day. Five providers is a reviewable wave for one person; this plan uses larger waves only where adapters share a template, because review time is the bottleneck.

## 5. Wave 0: tasks to clean up (listed, nothing changed)

Live counts at 23:50 AEDT. The task manager covers only running or queued work; finished work belongs in the Jobs tab (6 Oct decision).

| Where | State | Count | Oldest | Proposed action |
|---|---|---:|---|---|
| `pipeline.jobs` | queued | 6 | 11 Sep | Review each; cancel those superseded by the 5 Oct waves |
| `pipeline.jobs` | blocked | 5 | 12 Aug | Review the block reason; cancel or unblock |
| `pipeline.layer2_fanout_tasks` | queued | 33 | 3 Sep | Check against the current Layer 2 plan; cancel stale |
| `pipeline.layer3_work_items` | failed | 4,271 | 18 Sep | Group by reason; re-queue the fixable, park the rest with a reason |
| `pipeline.layer3_work_items` | layer4_required | 2,212 | 18 Sep | Confirm each has a Layer 4 item and a plain reason |
| `pipeline.layer3_work_items` | no_candidate | 28,231 | 29 Sep | Waiting for evidence; re-queue per provider as adapters and Layer 2 reads land |
| `pipeline.layer4_review_items` | pending | 1,473 | 13 Sep | course_intake 1,099, official_course_url 226, course_english 125, tuition validation 17, scope resolution 6; pattern-analyse for deterministic admission before a person reviews |
| `pipeline.layer4_review_items` | superseded | 8,907 | 19 Sep | Already closed; no action |

No cancel, delete or re-queue runs without the Platform Admin approving the list first.

## 6. Queueing into Layer 3 and Layer 4 as waves land

- A course field an adapter cannot read, or that is excluded, creates a Layer 3 work item with a reason (not readable, domestic page, whole-course total, two options, stale year).
- Layer 3 uses only the pinned cheap cascade. Items it cannot settle park, then go to Layer 4 with a plain reason, for example "two international fees printed, which applies?".
- Layer 4 groups repeated decisions (onshore or offshore, page or catalogue when they disagree, 2026 or 2027 fee) so one answer clears many items.
- Repeated Layer 4 patterns become adapter rules or exclusions, and the item count falls.

## 7. Risks and hidden effort

| Risk | Effect | Mitigation |
|---|---|---|
| Low first-pass admit rate | Coverage grows slower than the upper bounds | Fix the common Qualify blockers first (wave 4); build by template |
| Review capacity | Waves queue behind the Platform Admin | Group by platform; admit by field; batch decisions |
| Credit spend on small providers | Credits go to providers with few international courses | Credit budget per wave; Firecrawl only for providers that enrol international students |
| Duplicate and merged provider records | Adapters bind to the wrong courses | Person confirms before building |
| Domestic-only providers (NZ ITOs) | Cannot admit | Keep adapter, do not admit, report |
| NZ and CA `enrols_international` is not set | Cannot rank those providers by international relevance | Set from Layer 1 or by hand before waves 5 to 7 |
| Sites that block the reader | Re-reads waste credits | One re-read only; rendered read or hand entry |

## 8. Assumptions

- Active means `lifecycle_status = 'active'`; every course is currently unpublished, so "admitting" is data coverage, not publication.
- Track counts use stored pages, so "no pages" means none stored, not none on the web.
- The 80% target is by courses, not providers. Which field measure applies is an open decision.
- The Qualify results are not admitted, page-wins is applied nowhere, D3 and D8 are not built, and the 169 double degrees stay held (D11).

## 9. Progress log

| Run | Wave | Providers built (testing) | Proposals queued | Needs a person (skipped) | Live after the run |
|---|---|---|---|---|---|
| 7 Oct 00:09 AEDT | 1 and 2 (track E, largest first) | Academies Australasia Institute, People Potential (NZ, domestic only), Academy of Education and Innovation Australia, Australian Institute of Advanced Studies, Step Into Training Services, NSW Business College / Sydney College | 2 (AEI English; SITS English, one course) | Calgary, Notre Dame (open decisions); Stott's, Canberra Training School / CBTC, ANIE / Australian Academy of English, Bendigo TAFE and Kangan (merged records); MITO (domestic ITO); The King's University (one page per discipline); ANE College, SP International College, Tradies and Subbies (aggregator links only); UOW College Australia (9 of 10 read pages are news, entry-requirement or fee-schedule pages; rebind first) | 893 adapters (706 admitting, 185 testing); 974 providers without an adapter holding 5,513 active courses |
| 7 Oct 01:11 AEDT | 2 (track E, largest first) | Innovative College, Griffin College, Lawson College Australia, Australian College of Christianity, Adventure Works (NZ, domestic only), Emily Carr University of Art + Design (CA) | 1 (Innovative College English, 11 courses) | As above, plus Gradskill, Rama Raghav / ACE, ACDT / ACIT, You Study (multi-brand records) and Veritas, Green Valley, Omeo, Lions Institute and the "N/A" record (no website on record) | 899 adapters (706 admitting, 193 not admitting); 968 providers without an adapter holding 5,439 active courses |
| 7 Oct 02:11 AEDT | 2 (track E, largest first) | Unity College Australia, Iona Columba College, School of Audio Engineering (NZ), Construction Training Australia, Academy of Interactive Entertainment, NZ Welding School (NZ) | 1 (SAE Auckland English and intakes, 2 courses) | As above, plus the second "N/A" record (everthought.edu.au, no provider name) | 905 adapters (706 admitting, 199 not admitting); 962 providers without an adapter holding 5,385 active courses |
| 7 Oct 03:11 AEDT | 2 (track E, largest first) | Aurora Training Institute, AICOL, Capital Training (NZ, domestic only), Marcus Oldham College, Milestones English Academy, MIT Institute | 0 | As above, plus Grenfell Institute of Technology Australia, Australian Leap College, International Technical Institute and St Peters International College (no website on record) | 911 adapters (706 admitting, 205 not admitting); 956 providers without an adapter holding 5,348 active courses |
| 7 Oct 04:11 AEDT | 2 (track E, largest first) | Woodstock International, Access Recognised Training Australia, AICBT, Bayside College, Excel Ministries Charitable Trust (NZ), Good Shepherd College - Te Hepara Pai (NZ) | 1 (AICBT fee, 4 courses, confirm CRICOS-only) | As above, plus Future Education Group and Australian Careers Business College (no website on record) | 917 adapters (706 admitting, 211 not admitting); 950 providers without an adapter holding 5,321 active courses |
| 7 Oct 05:09 AEDT | 2 (track E) and 3 (held adapters) | UOW College Australia, MCFE, Alpha Educational Institute (NZ), Feats (NZ), SPCNM (NZ), Australasia Language College and 12 schools; admitted held fields: Macquarie english, UWA intakes (rolled back), Yoobee english and intakes, AEI english (#3), Innovative College english (#6) | 1 (Alpha english, thin) | As above, plus FC Education / FIT College, Rockhampton Grammar, RMIT UP (multi-brand) and Department of Education | 935 adapters (710 admitting); 932 providers without an adapter holding 5,238 active courses; admitted share intakes 49.3%, English 54.5%, fee 42.2% |
| 7 Oct 06:52 AEDT | 3 (held adapters) | None built (track E with a website is now 79 providers of 3 or fewer courses); admitted held fields: Vision College intakes, ASA Institute of Higher Education intakes, USQ - Sydney Education Centre english | 3 (National Art School fee, YWAM Training Perth intakes, SITCM intakes; all thin) | As above | 935 adapters (717 admitting); 932 providers without an adapter holding 5,238 active courses; admitted share intakes 49.4%, English 54.6%, fee 42.2% |

First-run finding: four of six track E providers had nothing admissible on their stored pages. Track E counts read pages, not readable facts, so the upper bounds in section 4 for wave 2 are optimistic; expect about a third of providers to pass one field.

Second-run finding: one of six providers passed a field (English). Small VET providers keep fees and intakes in brochures or per-course PDFs, on support subdomains or behind "Contact us", so wave 2 mostly yields English. Fees and intakes for these providers need Layer 2 work on PDFs and central pages (wave 5 budget) rather than more adapters.

Third-run finding: one of six providers passed (two courses). The remaining track E providers mostly have only 2 to 6 read pages, so proposals will be thin. Better yield now needs Layer 2 work on central fee, dates and English pages (wave 5) and rebinding courses held on listing or fees pages, rather than more adapters on stored pages.

Fourth-run finding: none of six providers passed a field. Three of the six are ELICOS colleges (AICOL, Milestones, MIT Institute), whose pages print rolling weekly starts, per-week or central fees and no entry score, so the adapter has nothing admissible to read; the other three print copy and menu links only. The remaining track E providers with their own website have 5 or 6 active courses and 2 to 5 read pages. Continuing wave 2 on stored pages now yields almost nothing; the better next step is Layer 2 work on central fee, dates and English pages (wave 5) and the queued admit decisions, or pausing the overnight run.

Fifth-run finding: one of six providers passed a field (AICBT fee, 4 courses), the first fee proposal from the overnight runs, because the page printed one programme fee per course that matches the CRICOS figure. The other five had no fee, date or English fact on any stored page. Track E providers with their own website now have 4 or fewer active courses; the recommendation after the fourth run stands (pause or redirect to Layer 2, wave 5).

Seventh-run finding: no track E provider was built; 3 held adapters were admitted, all with values that already agreed with the catalogue, so coverage of admitted fields rose but no catalogue value changed. Of about 30 held adapters measured, most fee passes fail rule 7 (unlabelled whole-course figures, fee year, standing decisions). The next gains need Platform Admin rules on fee labelling and fee year, then Layer 2 (wave 5).
