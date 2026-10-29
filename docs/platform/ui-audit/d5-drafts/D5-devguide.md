# D5 — developer guide text (issue 6) for the integrator

Target: admin `docs/integrations/developer-pack/StudySearch-Website-API-v2-Developer-Guide.md` (the master), then `build.sh`.
Also: `ENTRY-REQUIREMENTS-RENDERING-NOTE.md` (one paragraph, §5 below). `gen_api.py`: no change (entry rows are not field-listed in the OpenAPI file).
Publish only after the Platform Admin has applied the consumer paste and the live examples are re-measured (§4).

## 1. Title block

`subtitle: "website-api-v2 · Version 2 · Issue 6 · DD Month 2026 · Pilot"`

## 2. §7.9 changes

### 2.1 `resolution` table, the `rows[]` row — replace the field list

| `rows[]` | `qualification`, `study_level`, `min_grade`, `scale`, `scale_stated`, `band`, `conditions`, `quote`, `as_at`, `edition`, `case_by_case` |

### 2.2 "Show it like this" — add a fourth bullet after `case_by_case`

- **A row with `scale_stated` `false`:** the provider prints a grade but does not state the grading scale on its page. Show: **"Published requirement: [min_grade]. The provider does not state a grading scale on this page; check the source or contact the provider."** Show `min_grade` exactly as printed. Do not add a percentage, an ATAR equivalent, a band or any other scale, and do not compare it with the student's results. This is a published minimum, not case by case: `case_by_case` is `false` and `outcome` stays `minimum_published`.

### 2.3 New paragraph after the `entry_matrix[]` paragraph

**`scale_stated`** (on each `entry_matrix` item and each `resolution.rows[]` item; always present): whether the provider states the grading scale of `min_grade`.

| Value | Meaning | `scale` | Show |
|---|---|---|---|
| `true` | A grade with a stated scale | the scale, for example `"percentage"` | As today: the minimum with its scale |
| `false` | A grade printed with no stated scale | `null` | "Published requirement: [min_grade]. The provider does not state a grading scale on this page; check the source or contact the provider." |
| `null` | No minimum on a scale is stated (case by case) | `"none"` | "This qualification is considered case by case", as today |

A row from the course's own page (`resolution` `step` 1) always has `scale_stated` `null`. Use `scale_stated === false` as the only test for the "does not state a grading scale" wording; `true` and `null` keep the rendering you have.

### 2.4 Examples

Refresh the measured `entry_matrix` examples (each item now ends with `"scale_stated": true`, and the Taiwan `none` row with `"scale_stated": null`), for example:

```json
{ "country": "IN", "study_level": "Bachelor degrees", "qualification": "All India Senior School Certificate (AISSC) – 10+2",
  "min_grade": "Minimum average of 65%", "scale": "percentage", "band": "65%",
  "conditions": { "best_n": null, "alternatives": [], "subject_minimums": [] }, "as_at": "2026-10-26", "scale_stated": true }
```

Add one illustrative row (label it "shape only": on DD Month 2026 no admitted row is in this state yet):

```json
{ "country": "CN", "study_level": "Bachelor degrees", "qualification": "…",
  "min_grade": "375", "scale": null, "band": null,
  "conditions": { "best_n": null, "alternatives": [], "subject_minimums": [] }, "as_at": "…", "scale_stated": false }
```

Show "Published requirement: 375. The provider does not state a grading scale on this page; check the source or contact the provider."

### 2.5 "Integrating" — the Other consumers bullet

- **Other consumers:** treat `entry`, `entry_matrix` and `scale_stated` as optional; a value not held is `null` or empty, never a placeholder.

## 3. §12 Acceptance tests — new row

| 23 | Entry, scale stated | `provider` with `provider_id` provider:cricos:00122a returns `scale_stated` on every `entry_matrix` item (`true` on N rows, `null` on M rows on DD Month 2026); a row with `scale_stated` `false` is shown with the "does not state a grading scale" wording, never as a percentage, band or case by case |

(Measured on 30 Oct 2026 in a rolled-back dry run: 343 items, 310 `true`, 33 `null`, 0 `false`; re-measure live after the paste.)

## 4. §13 Changes to this guide — new line

| DD Month 2026 (issue 6) | `entry_matrix[]` items and `entry.resolution.rows[]` items gain `scale_stated`: `false` when the provider prints a grade but does not state its grading scale (`scale` is `null`; show the "does not state a grading scale" wording), `true` when the scale is stated, `null` for case by case. Section 7.9 and acceptance test 23 updated |

## 5. `ENTRY-REQUIREMENTS-RENDERING-NOTE.md` — add after the first paragraph

When a row has `scale_stated` `false` (a grade printed without its grading scale; `scale` is `null`), show **"Published requirement: [min_grade]. The provider does not state a grading scale on this page; check the source or contact the provider."** Show the grade as printed; never add a percentage, ATAR equivalent or band. It is not case by case.

## 6. Not in the developer pack (internal only)

The workspace recording path (R1), the md5 guards, the paste, the baseline gap and the dry-run evidence are platform work and stay out of the guide (Platform Admin 15 Oct 2026 17:24).
