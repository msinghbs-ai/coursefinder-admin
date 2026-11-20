# Course structure reader and sweep (s860, s861)

**Date:** 20 Nov 2026 (S1-Structure-Outcomes). **Brief:** Platform Admin 20 Nov 2026 15:19 and 15:22 AEDT. **Pilot:** #1427, migration `20261120163500`, worker coverage-sweep v1.0.33. **Spend:** US$0 (no model, no Firecrawl).

## 1. What it does

| Step | What happens | Where |
|---|---|---|
| Read | Every 5 minutes the job `struct-det-sweep` sends the stored bound pages of courses that lack a duration, study load or study mode to the worker (2 calls of 40 pages) | `security.struct_det_sweep_v1` |
| Extract | The worker reads each page from storage and returns readings with verbatim quotes | `struct-det-reader.ts`, mode `struct_det_read` |
| Record | Pages and readings are written once per page copy; a new page copy is read when it lands | `security.struct_det_record_v1`, `pipeline.struct_det_pages`, `pipeline.struct_det_readings` |
| Decide | One agreed value into an empty, unlocked field on the course's own page; otherwise Layer 4 | `security.struct_det_promote_v1`, `pipeline.struct_det_outcomes` |
| Publish | Each admitted course is rebuilt in search by the existing job | `search.course_refresh_requests`, `search-course-refresh` |

## 2. Fields and values

| Field | Values admitted | Never admitted |
|---|---|---|
| Duration | full-time length in years, months, weeks or semesters | ranges, maxima/minima, part-time-only, trimesters, terms, credit points |
| Study load | full_time, part_time, both (`study_load_source` provider_page, with the evidence id) | lines about international or domestic students or a visa |
| Delivery mode | on_campus, online, blended, on_campus_and_online (labelled lines only) | "flexible", "varies" |

## 3. Settings (Settings › Pipeline settings, Admission checks)

| Setting | Value | Meaning |
|---|---:|---|
| `struct_det.sweep_on` | 1 | send pages to the reader |
| `struct_det.sweep_calls` | 2 | calls a tick |
| `struct_det.sweep_max_open` | 3 | calls waiting at once |
| `struct_det.pages_per_call` | 40 | pages a call |
| `struct_det.call_lost_minutes` | 15 | a call with no answer is lost |
| `struct_det.promote_on` | 1 | admit agreed values |
| `struct_det.promote_per_run` | 150 | pages decided a tick |
| `struct_det.admit_stated` | 1 | admit "3 years full-time" sentences as well as labelled lines |
| `struct_det.layer4_max_pending` | 200 | Layer 4 items waiting at most |

To stop it: set `struct_det.sweep_on` and `struct_det.promote_on` to 0.

## 4. Baseline (20 Nov 2026 15:26 AEDT, read live)

| Field (courses) | AU 24,013 | NZ 6,514 | CA 3,814 |
|---|---:|---:|---:|
| No duration | 0 | 4,080 (647 with a stored page) | 2,458 (1,151) |
| No study load | 24 | 4,186 (690) | 2,368 (977) |
| No study mode | 20 | 3,386 (262) | 1,204 (152) |
| Regulatory code | CRICOS 24,013 | NZQA 6,514 | DLI 3,814; PGWP 0 |

## 5. Open for a Platform Admin decision

- NZQF level and credits: 6,267 NZ course titles state "(Level N)" from the NZQA register; credits are in the stored register evidence. No catalogue field holds them.
- PGWP eligibility: no register of eligible programmes is held.
- Layer 4 shows these items as `layer4_review_items` (fields `duration`, `study_load`, `delivery_mode`, reader `struct_det`); a dedicated Inbox kind is a follow-up for the UI lane.
