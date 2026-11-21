# Zoho API v3: changes against v2

**For:** Divya (Zoho Creator and Zoho CRM). **Address:** `zoho-api-v3` (same keys scheme as v2, its own v3 key). Zoho API v2 keeps running unchanged beside it.

This lists what v3 returns differently from v2, newest first. Fields, columns and actions are only added; ignore what you do not use.

## 21 Nov 2026

1. **Course CSV export (`export`, entity `course`): English test columns.** The v2 columns stay first, unchanged and in the same order. Nine columns are added at the end:

   | Column | What it holds |
   |---|---|
   | `toefl_ibt_overall` | Lowest TOEFL iBT overall score the course accepts |
   | `toefl_ibt_band` | Lowest TOEFL iBT section score, where the course states one |
   | `cae_overall` | Lowest Cambridge C1 Advanced overall score |
   | `cae_band` | Lowest Cambridge C1 Advanced component score, where stated |
   | `det_overall` | Lowest Duolingo English Test score (Duolingo has an overall score only) |
   | `oet_overall` | Lowest OET overall score (numeric scale) |
   | `oet_band` | Lowest OET subtest score (numeric scale), where stated |
   | `oet_grade` | OET letter grade the course asks for (for example `B`), where stated |
   | `oet_subtest_grades` | OET letter grade for each subtest, for example `Listening B, Reading B, Speaking B, Writing C+` |

   An empty cell means not held, not "no requirement". The export response reports `api_version: "zoho-v3"` for the course file. The provider, campus and contact files are the v2 files.

2. **Countries in the change stream and CSV: Australia, New Zealand and Canada.** The setting `zoho.sync_countries` now holds AU, NZ and CA (it was AU only). Because the setting is shared, **v2 `sync` and `export` include New Zealand and Canada as well**. New Zealand and Canada providers, campuses, contacts and courses arrive through the normal delta sync over the next cycles. Each item carries its `country_code`, so you can filter or route them.

## Earlier v3 additions (13 to 21 Nov 2026)

`search`, `course`, `courses`, `scholarships`, `scholarship` and `rankings` carry the v3 additions described in the Website API v3 guide: intake start-date status, description excerpt, the top five scholarships of a course, entry requirements by the student's country of previous education (`edu_country`), scholarship detail fields and paging.
