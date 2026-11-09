# Daily course field reports per provider: New Zealand, Australia and Canada

Platform Admin, 21 Oct 2026 (New Zealand) and 22 Oct 2026, 22:56: "prepare Excel sheet like nz to include au and ca as well daily".

- **Same workbook for each country:** `nz-fields/NZ-course-data-<date>.xlsx`, `au-fields/AU-course-data-<date>.xlsx`, `ca-fields/CA-course-data-<date>.xlsx`, built by `scripts/data-admission/build_nz_fields.py` (the result's `country` picks the country). Sheets: Read me, `<CC>` summary, Per provider, Long list, Courses, Entry requirements, Scholarships, Toolset use; New Zealand also has Resolutions & lessons (`nz-resolutions.json`).
- **Start line:** New Zealand 20 Oct 2026 (worked out, see `NZ-FIELDS-README.md`); Australia and Canada the first day recorded by job `provider-field-daily` (21 Oct 2026).
- **Produced by:** the daily scheduled task (7:15 am Melbourne), once per country: run the query below with `XX` replaced by `NZ`, `AU` and `CA`, run the course detail query in its parts, then the builder on the saved results: `python3 scripts/data-admission/build_nz_fields.py <query result> <detail part 0> <detail part 1> ...`.
- **Course detail (Platform Admin, 31 Oct 2026: "include each course with all course field values and scholarship field and entry field"):** the Courses sheet has one row per active course with the value of every course field (an empty field shows why it is not held), Entry requirements has each provider's entry rules (active and proposed), and Scholarships each active scholarship of the country's providers. Without detail files the builder makes the workbook as before.

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

## Course detail query (replace every `XX` with the country code, `NN` with its number of parts and `PP` with the part, 0 to NN − 1)

The result is too large for one call, so it is read in parts (by provider). Parts per country: **NZ 2, AU 8, CA 2** (each part about 3 MB or less on 31 Oct 2026). The builder stops if a part is missing.

```sql
with cv as (select course_id, max(provider_id::text)::uuid provider_id, jsonb_object_agg(attribute, state) filter (where state <> 'admitted') s, max(computed_at) at
              from pipeline.course_attribute_coverage where country_code = 'XX' and mod(abs(hashtext(provider_id::text)), NN) = PP group by course_id),
pv as (select distinct provider_id from cv)
select jsonb_build_object('kind', 'course_detail', 'country', 'XX', 'part', PP, 'parts', NN, 'day', (now() at time zone 'Australia/Melbourne')::date,
  'coverage_at', (select max(at) from cv),
  'courses', (select jsonb_agg(jsonb_build_array(
      coalesce(p.display_name, p.canonical_name), coalesce(co.display_title, co.canonical_title), co.course_code,
      (select string_agg(distinct l.url, ' | ') from catalogue.course_links l where l.course_id = co.id and l.status = 'active' and l.link_type = 'official_course'),
      sl.name, fs.name,
      case when co.duration_value is not null then trim(to_char(co.duration_value, 'FM999990.##') || ' ' || coalesce(co.duration_unit, '')) end,
      co.delivery_mode,
      (select string_agg(distinct k.name || coalesce(' (' || cc.delivery_mode || ')', ''), ' | ') from catalogue.course_campuses cc join catalogue.campuses k on k.id = cc.campus_id where cc.course_id = co.id),
      (select string_agg(distinct k.city, ' | ') from catalogue.course_campuses cc join catalogue.campuses k on k.id = cc.campus_id where cc.course_id = co.id and nullif(btrim(k.city), '') is not null),
      co.open_to_international, co.open_to_domestic,
      (select string_agg(f.currency_code || ' ' || to_char(f.amount, 'FM999,999,990.00') || ' ' || coalesce(f.basis, '') || coalesce(' ' || f.fee_year, '') || ' (' || f.audience || ')', ' | ' order by f.fee_year desc nulls last, f.amount)
         from catalogue.course_fees f where f.course_id = co.id and f.status = 'active' and f.fee_type = 'provider_current_tuition'),
      (select string_agg(f.currency_code || ' ' || to_char(f.amount, 'FM999,999,990.00') || coalesce(' ' || f.fee_year, ''), ' | ' order by f.fee_year desc nulls last)
         from catalogue.course_fees f where f.course_id = co.id and f.status = 'active' and f.fee_type = 'tuition'),
      (select string_agg(coalesce(i.intake_label, '') || coalesce(' ' || i.intake_year, '') || coalesce(' start ' || i.start_date, ''), ' | ' order by i.start_date nulls last, i.intake_label)
         from catalogue.course_intakes i where i.course_id = co.id and coalesce(i.status, 'active') = 'active'),
      (select string_agg(distinct i.application_deadline::text, ' | ') from catalogue.course_intakes i where i.course_id = co.id and coalesce(i.status, 'active') = 'active' and i.application_deadline is not null),
      (select string_agg(coalesce(t.code, t.name, 'test') || ' ' || coalesce(to_char(e.overall_score, 'FM990.##'), '') || coalesce(' ' || nullif(e.component_scores::text, '{}'), ''), ' | ' order by t.code)
         from catalogue.course_english_requirements e left join ref.english_tests t on t.id = e.english_test_id where e.course_id = co.id and e.status = 'active'),
      (select string_agg(a.option_type || ': ' || coalesce(a.name, a.code, ''), ' | ' order by a.display_order nulls last) from catalogue.course_academic_options a where a.course_id = co.id),
      (select string_agg(r.kind || ' [' || r.status || ']: ' || left(coalesce(nullif(r.description, ''), r.min_grade, r.quote, ''), 300), ' | ' order by r.status, r.kind)
         from catalogue.course_entry_requirements r where r.course_id = co.id and r.status in ('active', 'proposed')),
      left(nullif(btrim(co.description), ''), 2000),
      cv.s) order by coalesce(p.display_name, p.canonical_name), coalesce(co.display_title, co.canonical_title)) from cv join catalogue.courses co on co.id = cv.course_id join catalogue.providers p on p.id = co.provider_id
        left join ref.study_levels sl on sl.id = co.study_level_id left join ref.fields_of_study fs on fs.id = co.primary_field_id),
  'entry', (select jsonb_agg(jsonb_build_array(coalesce(p.display_name, p.canonical_name), m.matrix_kind, m.status, m.level_label, sl.name, coalesce(m.country_code, k.iso_alpha2::text),
      m.qualification_name, m.benchmark_band, m.min_grade, m.min_value, m.grade_scale, m.audience, m.intake_year, m.edition, left(m.quote, 500), m.source_url, m.as_at) order by coalesce(p.display_name, p.canonical_name), m.matrix_kind, m.level_label)
      from catalogue.provider_entry_matrix m join pv on pv.provider_id = m.provider_id join catalogue.providers p on p.id = m.provider_id
      left join ref.study_levels sl on sl.id = m.study_level_id left join ref.countries k on k.id = m.country_id where m.status in ('active', 'proposed')),
  'scholarships', (select jsonb_agg(jsonb_build_array(coalesce(p.display_name, p.canonical_name), s.name, s.scholarship_type, s.audience,
      s.award_value_text, s.award_value_type, s.award_amount, s.award_currency_code, s.award_percentage, s.award_value_is_maximum, s.award_applies_to_fee_type, s.award_fee_basis, s.award_duration_basis,
      s.application_required, s.application_open_date, s.application_close_date, s.academic_year, coalesce(s.study_start_label, s.study_start_date::text), array_to_string(s.nationalities, ', '),
      left(s.description, 1000), s.source_url, s.publication_status) order by coalesce(p.display_name, p.canonical_name), s.name)
      from scholarship.scholarships s join pv on pv.provider_id = s.provider_id join catalogue.providers p on p.id = s.provider_id where s.lifecycle_status = 'active')
)::text report;
```
