# Published-provider course data gaps behind Portal UAT (read-only audit)

S2-AER (was S2-RM-Design), 26 Nov 2026 17:05 AEDT, for Atlas (Orchestration Lead) and the Platform Admin. Live read, rolled back, through the rehearsal job (migration head `20261129121500`). $0. Nothing was written.

**Scope:** 34,362 active courses at published providers (`courses.lifecycle_status = 'active'`, `providers.publication_status = 'published'`): AU 24,013, NZ 6,520, CA 3,829.

## Result in one line

The canonical data holds no further correct value that a $0 rule can recover. The "Not recorded" campus city and missing CRICOS seen in UAT are values the platform already serves (Website v3 and `portal.course_detail_v1`), but the concise cards do not show them. The real gaps (fees, intakes, descriptions, URLs, AER reads) need reading or a person, owned by the lanes below.

## Field by field

| Field | Held now | Missing | Recoverable at $0 by rule | Why | Owner |
|---|---|---|---|---|---|
| Course code (CRICOS, AU) | 24,013 of 24,013 AU | 0 | — | No data gap: `courses.course_code` is set on every AU course. Website v3 serves `display_code` ("086056F, CRICOS course code") on 30 of 30 sampled, and portal detail serves `course_code` on 60 of 60. The card badge is s1222. | S1-API-Frontend-Delivery / S2-Build (portal cards) |
| Campus city | 4,279 by a primary campus; a further **15,469** have no primary but every linked campus in one city | 8,509 (no primary, campuses in several cities); 5,377 (no campus link); 727 (primary campus with neither city nor postcode) | 0 to write | For the 15,469, the city is already unambiguous and served: Website v3 `campus_city` 40 of 40 sampled; portal detail `campuses[].city` 44 of 44 where v3 has one. A card that reads only the primary campus shows "Not recorded". The 8,509 need evidence or a person: no manufactured primary or tie-break (design v1.12 C.3). The 727 have no postcode to map. | Card/search mapping: S2-Build (`catalogue.portal_course_search_v1`) and S1-API-Frontend-Delivery; locality data: S1-Build |
| Annual tuition (international) | 9,884 courses with one annual amount; 783 with an indicative annual | 782 with several annual amounts; 15,585 hold only the register total (`registered_total_course`, 24,013 AU rows); 8,111 hold no fee row | 0 | One amount for the 782 is a selection rule already shipped (`portal.primary_fee_v1`, s1222). An annual figure from a register total divided by duration is inference, not a stated value. | Fees: S1-Build; card: s1222 |
| Next intake | 3,160 with a future start date (9.2%) | 20,711 with no intake row; 7 with past dates only (legacy); 0 future label-only rows | 0 (1 course has a staged date not yet in the catalogue) | Nothing staged waits for admission. The gap needs reading (Rule B and calendar inheritance, charter 4). The "Feb 2027" against "February 2027" wording is in scholarship intake labels, not course intakes. | Intakes: S1-RM-Design (was S2-INT); scholarship wording: Scholarships lane |
| Description | 16,101 | 18,261 | 0 | Generation or reading, not a lookup. | S1-Build (was S2-CF) |
| Official course URL | 23,738 | 10,624 | 0 | Search and identity proof, not a lookup. | S1-Build (was S2-CF) |
| AER entry matrix, India (`IN`) | courses at providers with an active `IN` row: 8,449 | 25,913 | 0 | No matrix row lacks a country code (0 active or proposed with a null country), so it is not a normalisation gap. Coverage grows only as matrix reads are admitted: 68 first reads wait, and 13 change items are technical_blocked (Execution Register triage). | S2-AER admission; reads: S1-AER-Claude (AU), S3-AER-ChatGPT (NZ/CA) |
| AER entry matrix, Nepal (`NP`) | 5,170 | 29,192 | 0 | As for India. | As above |
| Any entry matrix | 12,573 | 21,789 | — | — | — |

Scholarship dates (501 of 888 AU without published dates) were not re-measured here: Scholarships lane (S1-Build, S1-Scholarship-Claude).

## Method notes

- **Fee rows:** active, audience international or all. "Annual" means `basis` names annual or year.
- **Campus rows:** active campuses through `course_campuses`.
- **Intake rows:** active rows, measured against the Melbourne calendar day.
- **Samples:** 60 courses drawn at random (hashed id) for the portal against Website v3 comparison; 40 single-city courses for the v3 city check; 30 AU courses for the code check.

## What was not done, and why

- **No backfill was shipped.** Every candidate was either already held and served (course code, the city for 15,469 courses), or would need inference: a primary campus for multi-city courses, an annual fee from a course total, or an intake day from a month. Such values are refused under the platform's evidence rules.
- **Single-writer domains (master plan 3a).** Fees, campus locality, description and URL belong to S1-Build, and intake dates to S1-RM-Design. This audit hands each gap to its owner rather than writing in their domains.
- **No spec, migration or test changed**, so `TEST-REGISTER.md` is unchanged.
- **Guardrails:** G3 75/48, manual locks 7,585, active cron 135, US$0.
