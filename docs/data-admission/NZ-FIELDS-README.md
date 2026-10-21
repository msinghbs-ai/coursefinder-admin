# Daily New Zealand field report per provider

Platform Admin, 21 Oct 2026: "Prepare the nz data per uni including all fields before and at present" and "Produce it daily please".

- **Source:** `pipeline.provider_field_daily` on the StudySearch Pilot database (read-only). Job `provider-field-daily` records one row per provider every day at about 6:55 am Melbourne time. 20 Oct 2026 for New Zealand was worked out afterwards (held on 21 Oct minus what Enrich fields tasks and enrichment plans filled that day). It is the start line.
- **Output:** `nz-fields/NZ-course-data-<date>.xlsx`. It shows each provider's 14 course fields and 9 provider fields at the start, the previous day and today, with the changes. The workbook has five sheets: Read me, NZ summary, Per provider, Long list and Toolset use.
- **Toolset use (from 22 Oct 2026):** `pipeline.toolset_use_daily`, job `toolset-use-daily` at about 6:58 am Melbourne, records the day before per provider and tool (course-page search, page reads, AI page match, AI field reader, fee reader, scholarship AI, other scraper credits, flags raised): used, worked, did not work, credits and AI US$. The sheet shows the last recorded day and the 7 days to it.
- **Produced by:** a daily scheduled task (7:15 am Melbourne). It runs the query below and `python3 scripts/data-admission/build_nz_fields.py <saved result>`, then recalculates the workbook, commits it here and sends it to the Platform Admin.

## Query

```sql
with d as (select max(snapshot_date) dd from pipeline.provider_field_daily where country_code='NZ' and source='job'),
p as (select max(x.snapshot_date) pd from pipeline.provider_field_daily x, d where x.country_code='NZ' and x.snapshot_date < d.dd)
select jsonb_build_object('today', d.dd, 'previous', p.pd, 'baseline', '2026-10-20',
  'tools_day', (select max(snapshot_date) from pipeline.toolset_use_daily where country_code = 'NZ'),
  'tools', (select jsonb_agg(z) from (
     select coalesce(pr2.display_name, pr2.canonical_name) name, u.tool,
            sum(u.used) filter (where u.snapshot_date = m.md) used, sum(u.ok) filter (where u.snapshot_date = m.md) ok, sum(u.failed) filter (where u.snapshot_date = m.md) failed,
            sum(u.credits) filter (where u.snapshot_date = m.md) credits, sum(u.cost_usd) filter (where u.snapshot_date = m.md) cost,
            sum(u.used) w_used, sum(u.ok) w_ok, sum(u.failed) w_failed, sum(u.credits) w_credits, sum(u.cost_usd) w_cost
       from pipeline.toolset_use_daily u join catalogue.providers pr2 on pr2.id = u.provider_id,
            (select max(snapshot_date) md from pipeline.toolset_use_daily where country_code = 'NZ') m
      where u.country_code = 'NZ' and u.snapshot_date > m.md - 7
      group by pr2.id, 1, 2) z),
  'rows', jsonb_agg(jsonb_build_object('name', coalesce(pr.display_name, pr.canonical_name), 'website', pr.website, 'courses', t.courses,
     't', t.course_filled, 'tp', t.provider_held, 'y', y.course_filled, 'yp', y.provider_held, 'b', b.course_filled, 'bp', b.provider_held)))::text report
from d cross join p join pipeline.provider_field_daily t on t.snapshot_date = d.dd and t.country_code = 'NZ'
join catalogue.providers pr on pr.id = t.provider_id
left join pipeline.provider_field_daily y on y.provider_id = t.provider_id and y.snapshot_date = p.pd
left join pipeline.provider_field_daily b on b.provider_id = t.provider_id and b.snapshot_date = '2026-10-20'
group by d.dd, p.pd;
```
