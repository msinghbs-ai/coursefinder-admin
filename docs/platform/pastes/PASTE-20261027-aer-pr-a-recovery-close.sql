-- PASTE FILE — AER PR A: D3 controlled recovery of the affected RMIT runs, CLOSE (CF-247)
-- For: Platform Admin, by hand in the SQL editor of fxcwkweaxjtknorudmwp, after PASTE-20261027-aer-pr-a-recovery-open.sql and once the six
-- recovery runs have settled. Never applied by the agent. Record: admin docs/platform/aer-v1.1-build-log.md.
-- guard  RMIT is in entry.providers; no RMIT run is queued or leased (the recovery reads have settled); Vietnam is still held.
-- close  entry.providers goes back to exactly UTS + WSU (the state before the open paste). One admin_control_events row. Nothing deleted.

begin;

do $paste$
declare v_rmit constant text := '8e1adb6c-e069-43db-9584-bd054255e702'; v_n int;
begin
  if (select value from pipeline.platform_toolset_settings where toolset_key = 'pipeline' and key = 'entry.providers')
     <> '["9d22a19e-c3f7-4012-b738-17bc0b481e7f", "1719c3ba-1ddf-483e-935e-c750124ba99c", "8e1adb6c-e069-43db-9584-bd054255e702"]'::jsonb then
    raise exception 'guard: entry.providers is not UTS + WSU + RMIT; nothing changed'; end if;
  select count(*) into v_n from pipeline.entry_matrix_runs where provider_id = v_rmit::uuid and state in ('queued', 'leased');
  if v_n <> 0 then raise exception 'guard: % RMIT runs still queued or leased; wait and apply again; nothing changed', v_n; end if;
  if not exists (select 1 from pipeline.entry_matrix_runs where id = '33eba77e-ba83-4ffa-bd1b-267ffe6aa14c' and state = 'failed' and error like 'held: AER PR B%') then
    raise exception 'guard: Vietnam is no longer held; nothing changed'; end if;

  update pipeline.platform_toolset_settings set value = '["9d22a19e-c3f7-4012-b738-17bc0b481e7f", "1719c3ba-1ddf-483e-935e-c750124ba99c"]'::jsonb,
         updated_at = now(), updated_by = '63ba56cb-48d4-4169-98c2-7c4d1f72925b',
         reason = 'Platform Admin 27 Oct 2026: AER PR A controlled recovery closed; RMIT out of scope again'
   where toolset_key = 'pipeline' and key = 'entry.providers';
  get diagnostics v_n = row_count; if v_n <> 1 then raise exception 'entry.providers: % rows; rolled back', v_n; end if;

  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('entry_matrix', 'recovery_close_paste', 'RMIT AER PR A recovery', jsonb_build_object('entry_providers', 'UTS + WSU (restored)'),
          '63ba56cb-48d4-4169-98c2-7c4d1f72925b'::uuid);
  raise notice 'recovery closed';
end $paste$;

commit;
