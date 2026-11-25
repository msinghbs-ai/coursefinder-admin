# Course entry identity: pages shared by records of one programme

**Status:** decided. The Platform Admin approved option 2 at 06:57 AEDT on 26 Nov 2026, with the safeguards below. It is implemented in Pilot s1191. **Prepared:** S1-Build, 26 Nov 2026 05:40 AEDT, under the 03:59 AEDT accelerated delivery mandate. Nothing has been changed; the safeguard is in force.

## Why this matters now

This one identity rule is now the largest single block on course entry admissions in Australia.

| Cohort (AU, active, open to international students, no active entry rows) | Courses | Held by this rule |
|---|---|---|
| Deterministic reader found requirements, refused only on identity (`not_admitted`) | 521 (46 providers, 4,735 readings, no AI needed) | 513 bound by `exact_title` |
| Never AI-read and not yet refused | 2,159 | 2,028 fail the identity rule or the read gate's course page check; only 131 pass (Window 4) |
| Window 3 (446 university courses read 26 Nov) | 446 | 299 held by the read gate, 188 of them as a "shared page" |

## What the evidence shows

Measured live (rolled back) on the 521 `not_admitted` courses:

- **Shared titles:** 520 of 521 share their exact title with another active course record at the same provider. They are the same programme recorded more than once, for example by campus or study mode.
- **Admitted siblings:** 518 of 520 have a same-title sibling whose entry requirements are already admitted (active).
- **Proven pages:** 90 courses (20 providers) are bound to the exact page that is already proven by CRICOS code or adapter for their same-title sibling, and that sibling has active rows.
- **Page binding:** 381 of the 521 pages are bound to that one course only; 516 are on the provider's own domain.

In Window 3, the read gate's course page check (`security.course_page_check_v1`) refused 188 pages as "shared by several courses ... nothing on it shows this course". The sample, Victoria University's Master of Counselling (international page), names the course and its level. It shows no other title or course, but more than one course record is bound to it.

## Why the safeguard exists

- **Rule:** AU entry requirements accept a page only on a CRICOS code, an adapter code or a person (`pipeline.coverage_admission_countries.identities`), because a title alone cannot say which record a page belongs to.
- **Siblings:** the evidence supports keeping that. 520 of 521 titles are not unique at their provider.
- **Wrong row admitted:** the risk is a sibling whose requirements genuinely differ (an online or international version), whose rows would be admitted from the other record's page.

## Options

1. **Keep the rule (no change).** These courses stay held. Recovery comes only from a CRICOS-proven page per record (a course page job), an adapter, or a person.
2. **Proven sibling page (smallest change; recommended).** For entry requirements, accept a page that is already proven by CRICOS code or adapter for a sibling record with the same provider, normalised title and qualification level, where the sibling's entry rows are active.
   - The same deterministic checks still apply (variant, shared-page and over-row-limit holds, quote and admission rules).
   - Releases 90 courses now from stored readings at $0, and more as siblings are proven.
3. **Programme-level admission.** Admit entry rows once per programme (provider, normalised title, level) and show them on every sibling record, keeping each record's own proof for fees and intakes.
   - The widest release: most of the 518 at once.
   - It changes the admission model, and needs a design and a G3 check of how the consumer API shows rows per record.

Every option keeps the US$5.00 daily limit, the 7,585 manual locks, G3 and Layer 4 for genuine decisions.

## Decision (Platform Admin, 26 Nov 2026 06:57 AEDT)

Option 2 is approved for academic entry requirements only. Each safeguard is a condition in `security.entry_sibling_identity_v1` (s1191):

| Safeguard | Condition |
|---|---|
| Provider, normalised programme title and qualification level match | Same `provider_id`; title normalised as in `security.course_entry_shared_page_v1`; same `study_level_id` |
| The same official page is verified through CRICOS or an approved adapter | The sibling's own binding to the same URL has basis `cricos_code` or `adapter_code`. That basis comes from the sibling's own proof, never from another sibling, so the proof is not transitive. |
| Applicability to the target variant and international audience | The target is open to international students; its page is bound and read; the page is not a domestic page; the read gate's course page check refuses it for no reason other than a shared page |
| No contradictory campus, study mode, pathway, edition or programme-specific requirements | None of the target's own stored readings names a campus, study mode, pathway, edition or intake |
| Existing safeguards stay enforced | Only the identity line of `security.aer_det_propose_v1` changes (md5 guarded). The shared-page, variant, over-row-limit, quote and score rules, Layer 4 and the fast admission are unchanged. |

**Not permitted:** title-only identity, transitive sibling identity, copying canonical rows from the sibling (the course's own stored readings are proposed), and any change to fee, intake or other field identity. The post-check confirms `security.coverage_identity_allowed` is unchanged.

**Rehearsal:** 69 deterministic pages released. The negative cases hold: no proven sibling is refused, not open to international students is refused, and the only sibling bases used are CRICOS. One proposer run proposed 20 of those pages to Layer 4.

**Outstanding:** the AI read gate (`security.enrich_fields_slice_v1`) and the AI recorder (`security.enrich_entry_record_v1`) do not use the rule yet. The 2,028 never-AI-read identity-held courses wait for that.

