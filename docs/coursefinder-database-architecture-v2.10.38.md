# CourseFinder Database Architecture v2.10.38

**Effective:** 20 August 2026  
**Status:** M1-PIM-FINALISATION architecture delta  
**Supersedes for Admin-read behaviour:** v2.10.37  
**Canonical identity semantics:** unchanged

## 1. Scope of this revision

v2.10.38 records the operational Admin/PIM read-boundary and performance changes required for PIM Admin v2.10.0. It does not redesign Provider, Course, Campus, Scholarship or Search identity.

## 2. Browser boundary

The supported browser read path is:

```text
PIM Admin browser
  -> Supabase Auth
  -> public.admin_read(operation, args)
  -> security.* rank-checked helper
  -> canonical / enrichment / evidence / workflow / Search data
```

The browser must not use direct CRUD against internal schemas.

Legacy `public.ui_*` `SECURITY DEFINER` functions are compatibility/internal helpers. Their EXECUTE privilege is revoked from `PUBLIC`, `anon` and `authenticated`; service/internal composition remains available.

## 3. Role boundary

| Read domain | Minimum rank |
|---|---:|
| Catalogue / Insights / Scholarships / Search-Publication | assigned CourseFinder role |
| Review Queue / Evidence | 3 Curator |
| Pipeline Control / Jobs / Sources | 4 Pipeline Operator |
| PIM Configuration | 5 PIM Admin |

Frontend visibility is not the security mechanism. Every routed helper performs its own authenticated/rank check.

## 4. Course list execution model

The normal 26k-scale Course list no longer enriches every candidate Course before pagination.

`security.admin_course_page_fast(jsonb)` executes:

1. canonical Provider/Course/country/study-level/field filtering;
2. exact/partial governed identity search;
3. total count and supported lightweight sort;
4. page limit/offset;
5. fee/readiness/geography/scholarship/Search enrichment only for the bounded page.

This preserves accepted field semantics and changes only execution order.

Derived catalogue-wide fee/completeness filters/sorts retain the accepted legacy helper until an equivalent indexed implementation is independently proven.

### Supporting index

`catalogue.course_fees` adds a partial covering index for the latest active registered-total-course tuition lookup:

```text
(course_id, source_snapshot_at desc, last_verified_at desc, created_at desc)
include (amount, currency_code)
where fee_type = tuition
  and basis = registered_total_course
  and status is active
```

This does not collapse Provider-current fee into CRICOS registered fee.

## 5. Provider and Campus detail

`security.admin_provider_detail(uuid)` repairs the related-page contract by consuming helper `items` payloads and returns bounded Course/Evidence/Campus previews plus totals.

`security.admin_campus_detail(uuid)` provides a structured Campus payload covering identity, Provider, geography, source/evidence, related Courses and Scholarship count.

No synthetic Campus is created by these read helpers.

## 6. PIM configuration read model

The governed PIM helper reads the accepted current tables:

- `pim.attribute_families`;
- `pim.attribute_groups`;
- `pim.attribute_definitions`;
- `pim.attribute_options`;
- `pim.completeness_profiles`;
- `pim.completeness_requirements`;
- `pim.family_groups`;
- `pim.family_attributes`.

`completeness_requirements` are presented as `completeness_profile_rules` in the Admin payload for continuity. No PIM configuration row is manufactured by the read contract.

## 7. Search / Publication overview

`security.admin_publication_overview()` is a read-only derived overview. It reports Search projection counts/version and publishing channel state without redefining canonical Course publication.

A narrow covering index on `search.course_documents` supports the summary counters without cold-scanning the wide Search document rows:

```text
(publication_status, has_fee, has_intake, has_english, has_scholarship, generated_at)
```

## 8. Operational paging

Normal browser list contracts use bounded limits, normally 50 rows, with a server maximum of 200 where applicable. Search/filter/sort is performed server-side.

The v2.10 browser must not restore previous 1,000–2,000 row local-filter patterns.

## 9. Evidence and Pipeline coexistence

Finalisation preserves the independently applied Evidence UX and Pipeline Operations routed contracts already present in the Pilot. The shared `public.admin_read` dispatcher must be treated as a multi-workstream integration point; migrations that replace it must preserve all accepted route branches rather than overwrite unrelated operations.

Repository promotion must therefore verify dispatcher composition after all predecessor migrations are ordered.

## 10. Security posture

Post-finalisation:

- `public.admin_read` authenticated EXECUTE: allowed;
- `public.admin_read` anon EXECUTE: denied;
- legacy browser-facing `public.ui_*` SECURITY DEFINER EXECUTE: denied to authenticated/anon;
- internal tables: no normal browser CRUD grants;
- RLS no-policy internal-table notices remain deny-by-default informational findings;
- Supabase leaked-password protection remains a separate project-level Auth warning.

## 11. UAT evidence

See `docs/uat/coursefinder-m1-pim-finalisation-uat-2026-08-20.md` for exact identity, role denial and performance results.

Deployed authenticated browser acceptance is intentionally not inferred from this architecture revision.
