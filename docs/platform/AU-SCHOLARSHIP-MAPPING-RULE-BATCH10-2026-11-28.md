# AU scholarship course mapping: DOT Batch 10 (WSU Master of Health Science 064020M) and the `sweep_level_field_scope` rule

Prepared by S1-Scholarship-Claude, 28 Nov 2026. Live reads only; nothing changed. Source: DOT `StudySearch-AU-10-WSU-PRECHECK_PENDING.md`.

## 1. The three WSU mappings (course 4909352d, Sydney City, 160 credit points)

| Award | Mapping | Live proof | Finding | Action |
|---|---|---|---|---|
| Honours Scholarship `8269136a` | `2b22f8c7` | levels `[undergraduate, postgraduate_coursework]`, text "...Bachelor Honours year" | The page's own level sentence says Bachelor Honours only. The level list wrongly adds postgraduate coursework. | Exclude the course. Keep the award and its Bachelor Honours mappings. |
| Cowley PhD Scholarship in Medicine `0683711d` | `1ffe1408` | levels `[]`, fields `asced-06`, text is only the award name | PhD only ("full-time domestic and international PhD applicants"). With no level, the rule linked every level in the field. | Exclude the course. Keep the award. |
| AUS Access Scholarship `14f501db` | `5dcf9699` | levels UG and PG coursework, text "70 credit points or less" | Read on the official page today: for WSU Vietnam students (UEH academic achievement). Ineligible if "applying to study a program located at Sydney City campus", or if studying "more than 80 credit points to complete the program". The course is Sydney City and 160 credit points, so it fails twice. | Exclude the course. Keep the award and its other mappings. Vietnam nationality is not recorded as a criterion (nationality list empty); owner S1-Build, add it so a generic offer is not shown to all international applicants. |

Evidence id discrepancy: the DOT note cites `cce57012-e3ab-4628-a833-66e286873b2f` for the Honours mapping. Live, that id is the Honours award's own evidence (candidate 7159, `scholarship-sweep-v0.4.6`); the mapping's evidence is `7d7121ba-5ecf-4217-900c-af3883d1749b` (Decision 139 sweep, same award). Both belong to the same award; apply the correction by mapping id, not by evidence id.

Why a direct change is not enough: `scholarship_sweep_apply_v1` rebuilds mappings with `mapped_by` null and flips a changed row back to `mapped`. The durable route is the existing person decision, `pipeline.scholarship_scope_decisions` (`layer4_scholarship_scope_bulk_decide`), which `scholarship_mapping_decision_guard` enforces on every later sweep. That needs a signed-in decider. Not applied by this session.

## 2. Is the rule wrong elsewhere? Read-only counts (heuristic, not confirmed per record)

`sweep_level_field_scope` holds 129,065 system-made mappings across 1,285 awards. Two failure patterns are confirmed on the WSU records and measurable:

| Pattern | Mappings | Awards | Providers | On published awards |
|---|---:|---:|---:|---:|
| A. Level "postgraduate coursework" listed but not supported by the award's own level sentence, mapped to a master's, graduate certificate or graduate diploma | 5,385 | 67 | 31 | 2,122 |
| B. PhD, doctoral or HDR award with no level, linked to non-research courses by field alone | 1,972 | 35 | 11 | 389 |

Pattern A is an extractor output problem (the reader returns a level the sentence does not state). Pattern B is in `scholarship_sweep_apply_v1`: its guard stops field-only linking when levels are listed but unrecognised, not when they are empty.

## 3. Shared rule fix (owner S1-Build; Pilot migration; not made here)
1. In `scholarship_sweep_apply_v1`, keep a level only if its words appear in `levels_text` (a postgraduate level needs postgraduate, master, graduate certificate or diploma, coursework or similar).
2. When levels are empty and the award name or fields text states PhD, doctoral or HDR, link only `doctorate` and `masters_research`; any other empty-level award stays as now (123 awards, 34 providers).
3. Re-run the sweep for the affected awards; mappings made or decided by a person stay. No award is unpublished: only course mappings change.
Check before shipping: the 5,385 and 1,972 are heuristics; read a sample per provider first.

## 4. Sydney City 2027 award
No Sydney City scholarship exists in canonical data (name and URL check, provider 1719c3ba: only AUS Access matches). The DOT terms (AUD 5,000 or 10,000 a year alternatives, up to two years, 160-credit maximum AUD 10,000 or 20,000, first-time 2027 commencement, subclass 500, Sydney City only, merit and limited allocations, no application) are for the owner route to admit through the reader, not by hand. Not created.
