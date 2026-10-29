# D5 — WEBSITE-DEVELOPER-REQUIREMENTS.md update text (O9) for the integrator

Target: admin `docs/integrations/WEBSITE-DEVELOPER-REQUIREMENTS.md`. Apply when the consumer paste is applied and guide issue 6 is published; fill the migration numbers and the date.

## 1. Header line

**Version:** 2.5 (DD Month 2026; O9 done: `scale_stated` marker; developer guide issue 6)

## 2. O9 row — replace

| O9 | ~~Printed grade with no stated scale (Platform Admin decision A4, 30 Oct 2026)~~ **Done DD Month 2026 (D5; approval Platform Admin 30 Oct 2026 08:45, admin decision §11.2; migrations `2026103xxxxxxx_cf247_d5_scale_stated_marker` (Platform Admin paste) and `2026103xxxxxxx_cf247_d5_aer_scale_not_stated`; guide issue 6)** | A provider page may print a grade (for example "minimum 75") without saying on what scale. Website API v2 now carries `scale_stated` on each `entry_matrix` item and each `entry.resolution.rows[]` item: `false` printed grade with no stated scale (`scale` `null`), `true` stated scale, `null` case by case (course-page rows always `null`). It is read from the admitted row (`min_grade` as printed, no scale held); nothing is inferred, normalised or converted, and it stays distinct from case by case and from no published requirement (no row; `contact_provider`). No existing key, outcome or edge function changed. The approved wording principle for the website: *"Published requirement: [grade]. The provider does not state a grading scale on this page; check the source or contact the provider."* | Measured DD Month 2026: N items `true`, M `null`, K `false` (30 Oct 2026 dry run: 310 / 33 / 0 of 343). A person records the case in the AER workspace (scale "Not stated on the page", with a reason; role guides 1.4, 3.1, 5.2); nothing is admitted automatically. **Rendering is the website team's work** (guide §7.9 and acceptance test 23). |

## 3. History — new first row

| 2.5 | DD Month 2026 | O9 done (D5): additive `scale_stated` on `entry_matrix[]` items and `entry.resolution.rows[]` items; developer guide issue 6 (§7.9 rendering rule, acceptance test 23, §13 line). |

## 4. System reference

Admin `docs/platform/SYSTEM-REFERENCE.md` §4b: one line under the entry fields — "`scale_stated` (D5): true stated scale, false printed grade with no stated scale (`grade_scale` null), null case by case; built in `security.entry_matrix_payload_v1` and `security.entry_resolve_v1`."
