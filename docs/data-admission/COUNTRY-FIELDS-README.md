# Daily course field reports per provider: New Zealand, Australia and Canada

Platform Admin, 21 Oct 2026 (New Zealand) and 22 Oct 2026, 22:56: "prepare Excel sheet like nz to include au and ca as well daily".

- **Same workbook for each country:** `nz-fields/NZ-course-data-<date>.xlsx`, `au-fields/AU-course-data-<date>.xlsx`, `ca-fields/CA-course-data-<date>.xlsx`, built by `scripts/data-admission/build_nz_fields.py` (the result's `country` picks the country). Sheets: Read me, `<CC>` summary, Per provider, Long list, Toolset use; New Zealand also has Resolutions & lessons (`nz-resolutions.json`).
- **Start line:** New Zealand 20 Oct 2026 (worked out, see `NZ-FIELDS-README.md`); Australia and Canada the first day recorded by job `provider-field-daily` (21 Oct 2026).
- **Produced by:** the daily scheduled task (7:15 am Melbourne), once per country: run the query below with `XX` replaced by `NZ`, `AU` and `CA`, then the builder on each saved result.

## Query (replace every `XX` with the country code)

```sql
with d as (select max(snapshot_date) dd from pipeline.provider_field_daily where country_code='XX' and source='job'),
p as (select max(x.snapshot_date) pd from pipeline.provider_field_daily x, d where x.country_code='XX' and x.snapshot_date < d.dd),
b as (select case when 'XX' = 'NZ' then date '2026-10-20' else (select min(snapshot_date) from pipeline.provider_field_daily where country_code='XX' and source='job') end bd)
select jsonb_build_object('country', 'XX', 'today', d.dd, 'previous', p.pd, 'baseline', b.bd,
  'measures', case when 'XX' = 'NZ' then security.nz_resolution_measures_v1('NZ') end,
  'tools_day', (select max(snapshot_date) from pipeline.toolset_use_daily where country_code = 'XX'),
  'tools', (select jsonb_agg(z) from (
     select coalesce(pr2.display_name, pr2.canonical_name) name, u.tool,
            sum(u.used) filter (where u.snapshot_date = m.md) used, sum(u.ok) filter (where u.snapshot_date = m.md) ok, sum(u.failed) filter (where u.snapshot_date = m.md) failed,
            sum(u.credits) filter (where u.snapshot_date = m.md) credits, sum(u.cost_usd) filter (where u.snapshot_date = m.md) cost,
            sum(u.used) w_used, sum(u.ok) w_ok, sum(u.failed) w_failed, sum(u.credits) w_credits, sum(u.cost_usd) w_cost
       from pipeline.toolset_use_daily u join catalogue.providers pr2 on pr2.id = u.provider_id,
            (select max(snapshot_date) md from pipeline.toolset_use_daily where country_code = 'XX') m
      where u.country_code = 'XX' and u.snapshot_date > m.md - 7
      group by pr2.id, 1, 2) z),
  'rows', jsonb_agg(jsonb_build_object('name', coalesce(pr.display_name, pr.canonical_name), 'website', pr.website, 'courses', t.courses,
     't', t.course_filled, 'tp', t.provider_held, 'y', y.course_filled, 'yp', y.provider_held, 'b', bb.course_filled, 'bp', bb.provider_held)))::text report
from d cross join p cross join b join pipeline.provider_field_daily t on t.snapshot_date = d.dd and t.country_code = 'XX'
join catalogue.providers pr on pr.id = t.provider_id
left join pipeline.provider_field_daily y on y.provider_id = t.provider_id and y.snapshot_date = p.pd
left join pipeline.provider_field_daily bb on bb.provider_id = t.provider_id and bb.snapshot_date = b.bd
group by d.dd, p.pd, b.bd;
```
