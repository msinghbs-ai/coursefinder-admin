-- CF-247 paste file, 19 Oct 2026: Phase 5 leftovers (Platform Admin 09:29: "Phase 5: hardening, plus retiring the leftovers above").
-- Project: fxcwkweaxjtknorudmwp (StudySearch). Paste into the Supabase SQL editor and run as one block.
--
-- What it does, in one transaction (all or nothing):
--   1 Checks security.zz_probe_v1() is still the one-off probe reviewed on 19 Oct 2026 (md5 of its definition). It holds no data; its
--     body would remove every row of pipeline.course_field_source if anyone ran it, so it is dropped rather than kept.
--   2 Checks nothing names it (functions, scheduled jobs). If something does, it stops.
--   3 Drops it and marks it retired in the component register.
-- No data is removed, so there is no archive export. The consumer API is not touched (Decision 266).
begin;
do $p5$
begin
  if md5(pg_get_functiondef('security.zz_probe_v1()'::regprocedure)) <> '89b3cf434b40885911f64d536f854b14' then
    raise exception 'security.zz_probe_v1 differs from the definition reviewed; nothing dropped';
  end if;
  if exists (select 1 from pg_proc where prosrc ~ 'zz_probe_v1' and oid <> 'security.zz_probe_v1()'::regprocedure)
     or exists (select 1 from cron.job where command ~ 'zz_probe') then
    raise exception 'something still names security.zz_probe_v1; nothing dropped';
  end if;
end $p5$;
drop function security.zz_probe_v1();
update pipeline.component_register set status = 'retired', note = coalesce(note, '') || ' | dropped by paste file 19 Oct 2026', updated_at = now()
 where kind = 'function' and name = 'security.zz_probe_v1';
do $chk$ begin
  if to_regprocedure('security.zz_probe_v1()') is not null then raise exception 'not dropped'; end if;
  if jsonb_array_length(security.consumer_api_check_v1() -> 'drift') <> 0 then raise exception 'consumer API drift'; end if;
end $chk$;
commit;
