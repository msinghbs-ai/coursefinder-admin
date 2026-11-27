-- DOT Batch 07 (Admin #1327, #1329, #1334): the five threshold tier rows only. Revised by S1-Build 28 Nov 2026 09:10 AEDT.
-- WHO RUNS IT: the Platform Admin, in the SQL editor, AFTER Pilot migration s1333 (20261201014000) is live. s1333 makes every other correction
-- (values, Deakin VC tiers, threshold criteria, Griffith GUIPRS tenure, Curtin caps, savings refresh, audit); CF-247 keeps deletes out of migrations.
-- What it does: stops unless s1333's values are live and no tier is under a manual lock; removes each threshold tier only when its code AND value
-- match (Deakin Merit 60 and 65, Deakin Excellence 75 and 80, Bond 85), never more than one row each; checks the real benefit tiers (20, 25, 25)
-- remain; refreshes those three awards' course savings and writes one pipeline.admin_control_events row.
-- Rehearsed rolled back after s1333, twice (live, 28 Nov 2026 09:05): run 1 removed 5, run 2 removed 0.
-- Replaces: the earlier versions of this file (md5 dcff155bda1d17259643e0410500a36c and 4194b1ae6d73a918a5e9d55e8a79666b).
begin;

set local lock_timeout = '5s';
do $b07t$
declare n int; v_total int := 0; r record;
begin
  -- Only after the s1333 migration: each award must already carry its corrected value
  if (select award_percentage from scholarship.scholarships where id = 'cb5ca7fc-377e-5755-add3-caeef7e89fd2') <> 20
     or (select award_percentage from scholarship.scholarships where id = '0c491130-f85e-572a-a1f2-60d59b1c6580') <> 25
     or (select award_percentage from scholarship.scholarships where id = '0eda3e72-f897-50fc-aebb-ad0ed84edee7') <> 25 then
    raise exception 'b07 tiers: the value corrections (Pilot migration s1333) are not live yet; nothing changed';
  end if;
  if exists (select 1 from pipeline.manual_locks l join scholarship.award_tiers t on l.entity_id::text = t.id::text
              where t.scholarship_id in ('cb5ca7fc-377e-5755-add3-caeef7e89fd2','0c491130-f85e-572a-a1f2-60d59b1c6580','0eda3e72-f897-50fc-aebb-ad0ed84edee7')) then
    raise exception 'b07 tiers: a tier is under a manual lock; nothing changed';
  end if;
  for r in select * from (values ('cb5ca7fc-377e-5755-add3-caeef7e89fd2'::uuid, 'page_tier_p2', 60::numeric), ('cb5ca7fc-377e-5755-add3-caeef7e89fd2'::uuid, 'page_tier_p3', 65::numeric),
                                 ('0c491130-f85e-572a-a1f2-60d59b1c6580'::uuid, 'page_tier_p2', 75::numeric), ('0c491130-f85e-572a-a1f2-60d59b1c6580'::uuid, 'page_tier_p3', 80::numeric),
                                 ('0eda3e72-f897-50fc-aebb-ad0ed84edee7'::uuid, 'page_tier_p2', 85::numeric)) v(sid, code, pct) loop
    delete from scholarship.award_tiers where scholarship_id = r.sid and tier_code = r.code and percentage = r.pct;
    get diagnostics n = row_count;
    if n > 1 then raise exception 'b07 tiers: % rows matched % % %', n, r.sid, r.code, r.pct; end if;
    v_total := v_total + n;
  end loop;
  -- the real benefit tiers stay (20%, 25%, 25%)
  if (select count(*) from scholarship.award_tiers where scholarship_id in ('cb5ca7fc-377e-5755-add3-caeef7e89fd2','0c491130-f85e-572a-a1f2-60d59b1c6580','0eda3e72-f897-50fc-aebb-ad0ed84edee7') and tier_code = 'page_tier_p1') <> 3 then
    raise exception 'b07 tiers: a benefit tier is missing; nothing changed';
  end if;
  if v_total > 0 then
    perform scholarship.refresh_course_financial_calculations(null, x) from unnest(array['cb5ca7fc-377e-5755-add3-caeef7e89fd2','0c491130-f85e-572a-a1f2-60d59b1c6580','0eda3e72-f897-50fc-aebb-ad0ed84edee7']::uuid[]) x;
    insert into pipeline.admin_control_events(area, action, target, detail, actor)
    values ('scholarship', 'b07_threshold_tiers_removed', 'scholarship.award_tiers', jsonb_build_object('rows', v_total, 'source', 'DOT Batch 07; Pilot s1333 then this paste'), security.system_actor_id());
  end if;
  raise notice 'b07 tiers: % threshold tier(s) removed (5 expected the first time, 0 on a re-run)', v_total;
end $b07t$;

select left(s.name, 40) as scholarship, s.award_percentage, (select string_agg(t.tier_code || '=' || t.percentage::text, ' ' order by t.display_order) from scholarship.award_tiers t where t.scholarship_id = s.id) as tiers
  from scholarship.scholarships s where s.id in ('cb5ca7fc-377e-5755-add3-caeef7e89fd2','0c491130-f85e-572a-a1f2-60d59b1c6580','0eda3e72-f897-50fc-aebb-ad0ed84edee7') order by s.name;
commit;
