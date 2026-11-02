# AU catalogue export — evidence report (2 Nov 2026)

Direction: Platform Admin 11:10 and 11:18 AEDT, 2 Nov 2026 (complete read-only AU export; Priority 1). Field mapping: `2026-11-02-au-export-field-mapping.md`.

## Result

| Item | Value |
|---|---|
| Workflow | `AU catalogue export` (`.github/workflows/au-catalogue-export.yml`), run **41384815706**, dispatched 14:45:46 AEDT on main `5c983d87` |
| Artifact | `au-catalogue-export-41384815706` (id 13116405007), 252,381,529 bytes, private, expires 16 Nov 2026 (14 days). Download: repository › Actions › run 41384815706 › Artifacts |
| Contents | `csv/*.csv` (35 datasets), `au-catalogue-export.xlsx` (Index + 32 dataset sheets; 1 dataset CSV only, reason in the Index: a value over Excel's 32,767-character cell limit), `manifest.json` |
| Manifest checks | **83 of 83 pass** (full list: `2026-11-02-au-export-run-41384815706-checks.txt`) |
| Snapshot method | Measured first (551,929 rows, 294 pages, ~611 queries, estimate 992 s → per_dataset). 34 short REPEATABLE READ READ ONLY snapshots, each started in a quiet minute; check "per-dataset snapshots stayed inside quiet minutes": PASS, 0 crossed |
| Peak memory | 381 MB resident, 210 MB heap (first run 41377240304 ran out of memory at ~4 GB during verification; fixed in #800) |
| Credentials / data in git or logs | None. Logs and step summary carry counts, timings and md5s only |

## Datasets (rows = distinct ids in every case)

| Dataset | Rows | md5 |
|---|---:|---|
| courses (all AU courses held) | 26,912 | 7641b8f0… |
| course_fees | 179,621 | 3bd3f2d3… |
| course_intakes | 28,437 | 40be2a82… |
| course_entry_requirements | 2,649 | 9d076f72… |
| english_requirements | 27,134 | 5f2e108b… |
| course_scholarships | 101,422 | e863adcc… |
| scholarship_master (+ award tiers 761, criteria 4,503, criterion groups 142, application windows 49, offering cycles 187, identifiers 1,897) | 1,804 | 048f6236… |
| provider_rankings | 0 (no AU rankings held; exported empty with columns) | 5852af87… |
| provider_entry_matrices | 2,335 | 3d4ae03d… |
| course_links | 20,247 | 6b38212b… |
| course_campuses | 48,732 | d785cf86… |
| course_identifiers | 26,912 | 8c184cdb… |
| course_pages_held | 24,240 | 869d9964… |
| search_course_documents (Website API v2 projection) | 23,732 | 96585ba4… |
| layer4_course_review_items | 21,827 | 16eaa86a… |
| providers | 1,556 | 4cf2287f… |
| ref_sources (+ reference tables) | 3,137 | 0a10ba19… |
| **website_api_v2_field_reconciliation** (derived: database value, projection value, consumer field) | 593,300 (23,732 courses × 25 fields) | 09625d45… |
| **field_state_reconciliation** (derived) | 430,592 (26,912 courses × 16 fields) | 2e476684… |
| data_dictionary_and_coverage (derived) | 582 | e84173fd… |

Website API subset: 23,732 courses flagged `in_website_api_v2` = 23,732 AU rows in `search.course_documents` (two checks, PASS).

## Limitations (recorded, not hidden)
- Per-dataset snapshots ran between about 14:56 and 15:11 AEDT. E16 containment writes ran in the same window (events #28616 link containment 14:56, #28617 Layer 4, #28618 F1 fees and #28619 F3 quarantine 15:06). For those 14 courses the links and fees datasets show the state at their own snapshot time, which `manifest.json` records per dataset.
- All 26,912 AU courses carry course publication status `unpublished`; consumer visibility follows the provider status and the Layer 4 search block (3,180 AU courses blocked). The consumer-visible flags in the export apply both.
- "Not applicable" is never assigned (no field-resolution decisions exist); the field-state sheet reports it as 0, not as a conclusion.
- No AU provider rankings are held.
- The artifact could not be downloaded into the integrator's workspace (GitHub's artifact storage host is outside its network allowlist); completion was verified from the run's manifest checks, step summary and log. The Platform Admin downloads it from the Actions run page.
