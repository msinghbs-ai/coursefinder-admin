-- COURSE-WISE-TRACKER generator (CF-247 overnight outcomes mandate, 25 Oct 2026). Read-only. Returns one markdown text column `md`.
-- Definitions (per active course, per field):
--   FILLED            the course holds an active value (the same tests the catalogue list uses).
--   EMPTY-WITH-CAUSE  empty, with a recorded cause that an automatic lane is still working (gap-cause "automatic").
--   BLOCKED           empty, with a recorded cause that needs a person, a decision, a source or an unbuilt reader.
--   UNCAUSED          empty with no cause recorded in the latest gap-cause snapshot (target 0; usually snapshot lag).
-- Baseline for 24 h deltas: pipeline.gap_cause_snapshots 24 h before the latest snapshot.
with params as (select (select max(at) from pipeline.gap_cause_snapshots) snap),
c as (
  select c.id, c.provider_id, k.iso_alpha2::text cc,
    exists (select 1 from catalogue.course_fees f where f.course_id=c.id and coalesce(f.status,'active')='active') f_fee,
    exists (select 1 from catalogue.course_english_requirements e where e.course_id=c.id and coalesce(e.status,'active')='active') f_english,
    exists (select 1 from catalogue.course_intakes i where i.course_id=c.id and coalesce(i.status,'active')='active') f_intakes,
    c.duration_value is not null f_duration,
    exists (select 1 from catalogue.course_campuses x where x.course_id=c.id) f_campus,
    (nullif(btrim(c.delivery_mode),'') is not null or exists (select 1 from catalogue.course_campuses x where x.course_id=c.id and nullif(btrim(x.delivery_mode),'') is not null)) f_delivery,
    exists (select 1 from catalogue.course_links l where l.course_id=c.id and l.link_type='official_course' and l.status='active') f_link,
    nullif(btrim(c.description),'') is not null f_description,
    false f_entry,
    not (c.canonical_title ~ '^[\W\d_]*$') f_title,
    (p.publication_status is not distinct from 'published' and coalesce(p.lifecycle_status, 'active') = 'active') pub
  from catalogue.courses c join catalogue.providers p on p.id=c.provider_id join ref.countries k on k.id=p.country_id
  where c.lifecycle_status='active' and k.iso_alpha2 in ('AU','NZ','CA')),
fields(field, attr, ord) as (values ('fee','fee',1),('English','english',2),('intakes','intakes',3),('duration','duration',4),('campus','campus',5),('delivery','delivery',6),('link','official_page',7),('description',null,8),('entry',null,9),('title',null,10)),
filled as (
  select cc, f.field, f.attr, f.ord, count(*) total,
    count(*) filter (where case f.field when 'fee' then f_fee when 'English' then f_english when 'intakes' then f_intakes when 'duration' then f_duration when 'campus' then f_campus
                     when 'delivery' then f_delivery when 'link' then f_link when 'description' then f_description when 'entry' then f_entry else f_title end) filled,
    count(*) filter (where not pub and not case f.field when 'fee' then f_fee when 'English' then f_english when 'intakes' then f_intakes when 'duration' then f_duration when 'campus' then f_campus
                     when 'delivery' then f_delivery when 'link' then f_link when 'description' then f_description when 'entry' then f_entry else f_title end) empty_unpub
  from c cross join fields f group by cc, f.field, f.attr, f.ord),
g as (select s.* from pipeline.gap_cause_snapshots s, params where s.at = params.snap),
g24 as (select s.country_code, s.attribute, sum(s.courses) empty24 from pipeline.gap_cause_snapshots s, params where s.at = params.snap - interval '24 hours' group by 1,2),
gc as (select country_code cc, attribute, sum(courses) filter (where automatic) auto_n, sum(courses) filter (where not automatic) person_n from g group by 1,2),
top3 as (select cc, attribute, string_agg(cause || ' (' || courses || (case when automatic then ', automatic' else ', needs a person' end) || ')', '; ' order by rn) causes
         from (select country_code cc, attribute, cause, courses, automatic, row_number() over (partition by country_code, attribute order by courses desc) rn from g) z where rn <= 3 group by 1,2),
rows as (
  select f.cc, f.ord, f.field, f.total, f.filled, f.total - f.filled empty,
    case when f.attr is not null and gc.cc is not null then least(coalesce(gc.auto_n,0), f.total-f.filled)
         else 0 end ewc,
    case when f.attr is not null and gc.cc is not null then least(coalesce(gc.person_n,0) + f.empty_unpub, greatest(f.total-f.filled - coalesce(gc.auto_n,0),0))
         else f.total - f.filled end blocked,
    case when f.attr is not null and gc.cc is not null then greatest(f.total-f.filled - coalesce(gc.auto_n,0) - coalesce(gc.person_n,0) - f.empty_unpub, 0) else 0 end uncaused,
    case when f.attr is not null and gc.cc is not null then t3.causes || case when f.empty_unpub > 0 then '; provider not published, enrichment paused (' || f.empty_unpub || ', needs a person)' else '' end
         when f.field = 'fee' and f.cc = 'AU' then 'AU international fees come from the CRICOS register (fees.countries = NZ, CA by Platform Admin choice); course not on the register with a fee (needs a person / policy)'
         when f.field = 'duration' and f.cc = 'AU' then 'AU duration comes from the CRICOS register; not on the register with a duration (needs a person / source)'
         when f.field = 'description' then 'no course-description reader yet (B2, O3; release queued after S1 / Track B release 1) — blocked: reader not built'
         when f.field = 'entry' then 'entry-requirements reader not built (O4 step A PR; NZ first) — blocked: reader not built'
         when f.field = 'title' and f.total - f.filled > 0 then 'register gives no title (e.g. SIT NZQA 3954 "--"; quarantine paste awaiting the Platform Admin)'
         when f.field = 'title' then '—'
         when f.attr is not null then 'not in the gap-cause snapshot for this country (gap_causes covers this field for other countries only)'
         else '—' end causes,
    case when f.attr is not null and g24.empty24 is not null and gc.cc is not null then (coalesce(gc.auto_n,0)+coalesce(gc.person_n,0)) - g24.empty24 end delta_empty
  from filled f left join gc on gc.cc=f.cc and gc.attribute=f.attr left join top3 t3 on t3.cc=f.cc and t3.attribute=f.attr left join g24 on g24.country_code=f.cc and g24.attribute=f.attr),
prov as (
  select c.cc, coalesce(p.display_name, p.canonical_name) name, count(*) n,
    round(100.0*avg(f_fee::int)) fee, round(100.0*avg(f_english::int)) eng, round(100.0*avg(f_intakes::int)) intk, round(100.0*avg(f_duration::int)) dur,
    round(100.0*avg(f_campus::int)) cam, round(100.0*avg(f_delivery::int)) del, round(100.0*avg(f_link::int)) lnk, round(100.0*avg(f_description::int)) dsc,
    row_number() over (partition by c.cc order by count(*) desc) rn
  from c join catalogue.providers p on p.id=c.provider_id group by c.cc, p.id, p.display_name, p.canonical_name)
select (select snap from params) snap_at,
  string_agg(format(E'| %s | %s | %s (%s%%) | %s | %s | %s | %s | %s |', r.field, r.total, r.filled, round(100.0*r.filled/nullif(r.total,0)), r.ewc, r.blocked, r.uncaused,
     coalesce(case when r.delta_empty is null then 'baseline' when r.delta_empty > 0 then '+' || r.delta_empty || ' empty' else r.delta_empty || ' empty' end, 'baseline'),
     replace(r.causes, '|', '/')), E'\n' order by r.cc, r.ord) filter (where r.cc='AU') au,
  string_agg(format(E'| %s | %s | %s (%s%%) | %s | %s | %s | %s | %s |', r.field, r.total, r.filled, round(100.0*r.filled/nullif(r.total,0)), r.ewc, r.blocked, r.uncaused,
     coalesce(case when r.delta_empty is null then 'baseline' when r.delta_empty > 0 then '+' || r.delta_empty || ' empty' else r.delta_empty || ' empty' end, 'baseline'),
     replace(r.causes, '|', '/')), E'\n' order by r.cc, r.ord) filter (where r.cc='NZ') nz,
  string_agg(format(E'| %s | %s | %s (%s%%) | %s | %s | %s | %s | %s |', r.field, r.total, r.filled, round(100.0*r.filled/nullif(r.total,0)), r.ewc, r.blocked, r.uncaused,
     coalesce(case when r.delta_empty is null then 'baseline' when r.delta_empty > 0 then '+' || r.delta_empty || ' empty' else r.delta_empty || ' empty' end, 'baseline'),
     replace(r.causes, '|', '/')), E'\n' order by r.cc, r.ord) filter (where r.cc='CA') ca,
  (select string_agg(format('| %s | %s | %s | %s%% | %s%% | %s%% | %s%% | %s%% | %s%% | %s%% | %s%% |', p.cc, p.rn, replace(left(p.name,60),'|','/'), p.n, p.fee, p.eng, p.intk, p.dur, p.cam, p.del, p.lnk, p.dsc), E'\n' order by p.cc, p.rn) from prov p where p.rn <= 20) providers
from rows r
