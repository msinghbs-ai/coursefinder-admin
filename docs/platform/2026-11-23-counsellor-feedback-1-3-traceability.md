# Counsellor feedback rounds 1 to 3: traceability and reconciliation

**Prepared:** 23 Nov 2026 16:10 AEDT, decisions added 16:30 AEDT, by Claude (`S1-RM-Design`, roadmap, request register and governance) · **Roadmap item:** RM0G
**Sources (Google Drive, `Feedback` folder):** `studySearch-Feedback-1` (India team, 20 Nov 2026, points 1 to 19), `studySearch-Feedback-2.docx` (India counselling team, 22 Nov 2026, sections 1 to 4 and suggestions 1 to 4), `Feedback StudySearch-3.docx` (23 Nov 2026, items FB3-1 to FB3-6). Also the `UI-UX-and-Architecture-Audit` Drive folder (`design-and-ui-audit/04-live-findings-counsellor-and-admin.md`, `Mockups/MOCKUP-SPEC-AND-RETIREMENT-MAP.md`, 23 Nov 2026).
**Changes made by this work:** register CSVs and governance documents in `coursefinder-admin` only. No Pilot code, migration, live data, setting or job was changed. The live figures below come from read-only queries on project `fxcwkweaxjtknorudmwp` at about 16:00 AEDT on 23 Nov 2026.

## 1. Feedback 3: new requests

| Item | What the counsellors saw | Request | Lane | Priority | Live check (23 Nov 16:00) | Next step |
|---|---|---|---|---|---|---|
| FB3-1 | Searching "Nursing" also shows Accounting, Teaching and other courses | REQ-113 | `S1-API-Frontend-Delivery` (search box and result order), `S3-Backend-Pipeline` (search read) | P1 | Free-text search was 1.6 to 5.8 s under load (REQ-105). Not yet reproduced: the exact screen, filters and words are needed | Reproduce signed in as Counsellor; title and field-of-study matches rank first; unrelated courses are not returned for a single subject word |
| FB3-2 | La Trobe shows only Doctor of Nursing; James Cook shows no Nursing; both pages said the database took too long | REQ-114 (+ IR-022) | `S3-Backend-Pipeline` (time-outs), `S2-RM-Design` Priority 2 (entry reader and Admin parity), `S2-CF` (JCU course coverage) | P1 | La Trobe has **8 active Nursing courses** (Bachelor of Nursing and 4 variants, combined degree, Master of Nursing, Master of Nursing Practice, Doctor of Nursing), all unpublished. James Cook has **1** (Bachelor of Nursing Science). So La Trobe is a read or time-out problem, and James Cook is also a coverage gap. Entry rows: s1000 serves 10,441 courses on v3. **Admin parity checked:** the Admin entry read (`admin_entry_requirements`) and `website_v3_course` both call `security.entry_resolve_v3`; `admin_aer` names `entry_resolve_v1` only in a definition guard, not as its reader. So the legacy-path gap is not present; the remaining entry gap is coverage | S3 hardens the time-out (IR-022); S2-CF checks JCU's register courses; S2-RM-Design Priority 2 (CDU layout, the 284 reads at 0.70, high-yield universities) raises entry coverage |
| FB3-3 | Not every course clicked "Compare" appears; want a heart/bookmark, a "Saved courses" view, and a compare table of fees, length, location, intakes, academic and English entry and scholarships (not rankings and survey results) | REQ-115 (links REQ-111) | `S1-API-Frontend-Delivery` (Mockups / Counsellor UI redesign) | P1 (compare defect), P2 (saved list and new columns) | Comparison workspace exists for staff; the course columns asked for are all in the v3 course read and the mockup course drawer | Fix the compare selection in the current screen now; saved list and compare columns go in the mockup build |
| FB3-4 | Provider contacts: none for La Trobe with "Active" selected | REQ-116 (links REQ-22) | `S1-API-Frontend-Delivery` (empty state); data owner per REQ-22 | P2 | **Data, not the filter:** La Trobe has 0 named contacts. The platform holds 31 named contacts at 11 providers (and 3,054 contact points), REQ-22 | Screen says "No named contact held for this provider" instead of a blank list; Platform Admin decides on REQ-22 (import of university contacts) |
| FB3-5 | "2 regions" / "4 regions" instead of the state and campus names | REQ-117 | `S1-API-Frontend-Delivery` (display), `S2-GEO` (campus locality) | P2 | Campus localities are served on the v3 provider action (`campuses[].locality`, RM0E) | Show state and campus names (for example "VIC: Bundoora, Bendigo") with the count only as overflow |
| FB3-6 | Label whether Study Square represents each provider (Represented / Direct / Not represented), with any nationality or market restrictions | REQ-118 (+ IR-023) | Data contract: Platform Admin decision, then `S2-RM-Design` design document; UI: `S1-API-Frontend-Delivery` | P2 | No field holds this today. It is Study Square's own commercial data, not something the platform can read from a provider's site | Platform Admin names the source and owner (section 5 proposes a contract) |

## 2. Feedback 1 (20 Nov 2026): reconciliation

| Point | Feedback | Request | State | Evidence |
|---|---|---|---|---|
| 1, 6 | Entry requirements Country shows NZ; destination country option | REQ-92 | Done / Verified Live | s956 (Pilot #1467) |
| 2 | Scholarships missing | REQ-95 | In progress | s984 (Pilot #1490); s985 (Pilot #1492): Torrens 0 → 2 published, overall 1,078 → 1,080; Charles Darwin and Lincoln wait for the listing reader (S2-Build slice 2) |
| 3, 11 | Providers missing from entry requirements | REQ-94 | In progress | s983 (Pilot #1489); s1000 (Pilot #1491): academic entry 2,250 → 10,441 courses on v3; 24,839 courses still hold no admitted row |
| 4 | Entry requirements not shown on course selection | REQ-93 | Done / Verified Live | s957 (Pilot #1468) |
| 5.1 | Duration in years | REQ-97 | Done / Verified Live | s956 |
| 5.2 | Links to the institution and course pages | REQ-98 | Done / Verified Live | s957 |
| 5.3 | IELTS, PTE and TOEFL | REQ-99 | In progress | Table-aware English reader decision (CDU fixture, design v1.11 A.3 and A.4) |
| 7, 14 | Study levels limited; all levels in the list | REQ-100 | Done / Verified Live | s958, s959 (Pilot #1469 to #1471) |
| 8 | RMIT shows the data team's sources | REQ-101 | Done / Verified Live | s956 |
| 9, 18 | Clear the selected provider in Contacts; purpose of Contacts | REQ-102 | Done / Verified Live | s956 |
| 10 | Empty reason unclear | REQ-103 | Done / Verified Live | s956; glossary in v2.16.86 (REQ-112) |
| 12 | Victoria search shows Adelaide | REQ-104 | Done / Verified Live | s957 |
| 13 | Lag | REQ-105 | In progress | s972, s974 (Pilot #1479, #1480); s977 (Pilot #1482, v2.16.86): filtered reads 0.33 to 0.35 s; free-text search 1.6 to 5.8 s under load; IR-013 decision; IR-022 |
| 15 | "Has scholarship" shows none | REQ-96 | Done / Verified Live | s957 |
| 16 | Full forms of QILT, PRISMS, THE and QS | REQ-106 | Done / Verified Live | s956 (statistics cards show full names and publisher) |
| 17 | Zoho and Website feed matched | REQ-107 | Done / Verified Live | s956 |
| 19 | Search and click statistics for monetisation | REQ-108 | Open (to be scoped) | Clicks happen on the website; scope with the website team |

## 3. Feedback 2 (22 Nov 2026): reconciliation

| Section | Feedback | Request | State | Evidence |
|---|---|---|---|---|
| 1 | Performance lags | REQ-105 | In progress | As Feedback 1 point 13 |
| 2 | Fewer filters | REQ-112 | Done / Verified Live | v2.16.86 (Pilot #1482): counselling filter bar for Counsellor and Viewer. The live audit still shows a dead Filters button and operator screens in the Counsellor menu (IR-021) |
| 3 | Fee sort low/high; intake filter; results follow fee range and intake | REQ-112 | Done / Verified Live | v2.16.86; intake data improved by s986 and s987 (Pilot #1493, #1494): exact-date intakes 4,914 → 5,242 rows |
| 3 | Publication, Empty reason and Description unclear | REQ-112, REQ-103 | Done / Verified Live | Glossary in v2.16.86 |
| 3 | Entry requirements missing institution-wise and destination-wise | REQ-94 | In progress | s1000 |
| 3 | Same provider options after changing destination | REQ-112 | Done / Verified Live | Each list narrows to the destination (v2.16.86) |
| 4 | Fee structures and campus or location mappings inaccurate | REQ-123 | Newly Logged | No example given. NZ and CA: 667 campus links hold no source or evidence (audit 23 Nov 13:17) |
| 4 | Bachelor of Business Analytics not in the NZ search; not found on the "Appoly website" | REQ-119 | Newly Logged | Live: 6 NZ Business Analytics courses, all postgraduate (Waikato, Yoobee, EIT, Auckland ×3); no NZ bachelor of that title in the catalogue. Provider and "Appoly website" to be clarified |
| 4 | Only IELTS shown (PTE and TOEFL missing) | REQ-99 | In progress | As Feedback 1 point 5.3 |
| 4 | International Excellence Scholarship (20%) missing while five others are listed | REQ-121 | Newly Logged | Live: awards of that name are held for several providers (for example "JCU International Excellence Scholarship"). The provider is not named in the feedback |
| 4 | Individual (band) English scores missing | REQ-122 | Newly Logged | Links REQ-99; the mockup course drawer shows sub-scores; whether each test's band score is stored is not yet verified |
| 4 | La Trobe programme is now Master of Business Analytics and AI | REQ-120 | Newly Logged | Live: La Trobe still holds "Master of Business Analytics" (active), with the Graduate Certificate, Graduate Diploma and Bachelor |
| S1 | Assessment by student profile | REQ-109 | In progress / Mapped to Mockups (scoping) | Counselling bar covers destination, level, field, intake, fee and English score; profile fields to be scoped |
| S2 | IELTS, PTE and TOEFL not-less-than score | REQ-112 | Done / Verified Live | v2.16.86 |
| S3 | Universities by GPA, low to high | REQ-110 | Open (decision) | Platform Admin to choose the entry figure and grading scale |
| S4 | Select several, compare, export | REQ-111 | In progress / Mapped to Mockups | Joined with FB3-3 (REQ-115) |

**Items the brief asked to confirm are tracked:** intake-wise filtering (REQ-112, Done), student-profile eligibility and GPA (REQ-109, REQ-110, Open), acronym tooltips for QILT, PRISMS, THE and QS (REQ-106, Done), partner search and click analytics (REQ-108, Open). None was missing from the register.

## 4. Counsellor UI clean-up from the UI-UX and architecture audit (IR-021)

From `04-live-findings-counsellor-and-admin.md` (Counsellor, desktop and 375 px, 23 Nov 10:20 to 11:00), all for `S1-API-Frontend-Delivery`, mapped to the Mockups build (`MOCKUP-SPEC-AND-RETIREMENT-MAP.md`):

1. Opening a course or provider calls operator reads (`admin_course_edit_read`, `admin_provider_edit_read`, `admin_jobs`: 403; `provider-asset-access`: 404), which writes error reports and shows "Your role is not allowed to do this". The banner then follows the user to the next page.
2. Duplicate reads on one open (`admin_course_destination_read`, `admin_aer` matrix list, `admin_provider_destination_read`, `admin_jobs`, each twice).
3. The Courses Filters button is hidden for rank 2 or below in code but still shows, and does nothing.
4. Published switches show to Counsellors in the Providers list; Coverage & completeness is in the Counsellor menu.
5. Raw strings on screen: "Unnamed on the register (3954)", `on_campus`, `layer4.drain_max_attempts`, and raw database text ("canceling statement due to statement timeout") on the Go-live checklist.
6. The full BoM and ABS licence text repeats on every campus card; one attribution line per record is enough.
7. The Counsellor role guide says "reviewed for v2.16.61" in app v2.16.86.
8. At 375 px: the contacts toolbar clips its Clear button; four stat tiles stack before any data.

The acceptance rules in the mockup spec (no 403 or 404 call for a Counsellor, no horizontal overflow at 375 px, no operator text in the Counsellor build) are the tests for this item.

## 5. Proposed data contract: Study Square representation status (FB3-6, IR-023)

For the Platform Admin's decision. Nothing is built until it is approved.

| Field | Meaning | Values |
|---|---|---|
| `representation_status` | Study Square's relationship with the provider | `represented` (Study Square is an appointed agent), `direct` (Study Square applies directly, no agency agreement), `not_represented`, null = not recorded |
| `restriction_scope` | Who the status applies to | `all_markets`, or a list of student nationalities or source markets (ISO country codes) where it applies or is excluded |
| `effective_from`, `effective_to` | The dates the agreement covers | Dates (Melbourne) |
| `source`, `recorded_by`, `recorded_at`, `reason` | Who said so and when | Study Square partnerships team; changes logged with a reason |

Proposed rules: it is entered by Study Square staff in Admin (or imported from their partner list), never read from a website; it is Admin-only until the Platform Admin decides whether the website or Zoho may see it (G3: if served, it is a new v3 field beside the frozen v2 surface); a provider without a row shows "Not recorded", not "Not represented". If approved, `S2-RM-Design` adds it to `DESTINATION-DATA-DESIGN.md` and `S1-API-Frontend-Delivery` builds the label.

## 6. Hand-offs

| To | Items |
|---|---|
| `S1-API-Frontend-Delivery` | REQ-113 (with S3), REQ-115, REQ-116, REQ-117, REQ-118 (after the decision), REQ-122 (display), IR-021 |
| `S3-Backend-Pipeline` | IR-022 (time-outs on counsellor reads and raw database errors), REQ-113 search read, REQ-114 |
| `S2-RM-Design` | REQ-114 entry coverage (Priority 2, after s1000; Admin and v3 reads already on `security.entry_resolve_v3`, checked in `pg_proc` 23 Nov 16:00), IR-023 (contract, after the decision) |
| `S2-CF` | REQ-119 (NZ course coverage), REQ-120 (La Trobe title), REQ-114 (La Trobe's 8 unpublished Nursing courses: publication; James Cook Nursing: discovery) |
| `S2-GEO` | REQ-117 (campus locality), REQ-123 campus part |
| `S2-Build` | REQ-121 (scholarship), IR-024 (duplicate IR-017 number), REQ-116 / REQ-22 partner contact source (decision 16:22), the Drive mirror of the master plan on its next integration pass |
| India team | Clarifications in REQ-113, REQ-119, REQ-121, REQ-123 |

## 7. Platform Admin decisions (23 Nov 2026 16:22 AEDT)

| Item | Decision | Next |
|---|---|---|
| REQ-116 / REQ-22: university contacts | No web scraper for university staff contacts. Source: Study Square partner records, entered in Admin and/or imported from Zoho CRM partner contacts. Data owner: `S2-Build` (partner and Zoho sync). | `S2-Build` builds the partner contact source. `S1-API-Frontend-Delivery` shows "No partner contacts recorded for this provider" when none is held. |
| REQ-118 / IR-023: representation status and market restrictions | Approved on the contract in section 5. Source of truth: the Study Square partner agreement register (Admin, plus CSV or Zoho sync), never scraped. | `S2-RM-Design` finalises the additive v3 schema and contract (v2 stays frozen under G3); then `S1-API-Frontend-Delivery` builds the Counsellor badge and filter. |
| REQ-110: GPA ordering | Never sort raw numbers across different grading scales. Sort by the normalised percentage (0 to 100) from `grade_scale_conversions`, scoped to the selected applicant country and qualification scale: India percentage or 10-point CGPA by default for Indian applicants, otherwise AU 7.0 GPA or ATAR. Courses with no score sort last (`NULLS LAST`). | `S2-RM-Design` defines the deterministic conversion rows and lookup rule. Live 23 Nov 16:25: `ref.grade_scale_conversions` already exists (`scale_code`, `raw_min_value`, `raw_max_value`, `normalized_0_100`, `source_url`) and holds 0 rows. Then `S1-API-Frontend-Delivery` exposes the GPA sort. |
| REQ-114 routing (FB3-2) | La Trobe's 8 unpublished Nursing courses and James Cook's single Nursing course go to `S2-CF` (course publication and discovery), beside `S3` (the 8 s statement time-out, IR-022) and `S2-RM-Design` Priority 2 (AER coverage). | As listed. |
| Drive mirror of the master plan | Left to `S2-Build` on its next integration pass. | `S2-Build` |
