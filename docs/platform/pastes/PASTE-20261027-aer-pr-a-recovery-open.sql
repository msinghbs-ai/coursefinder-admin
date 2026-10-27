-- PASTE FILE — AER PR A: D3 controlled recovery of the affected RMIT runs, OPEN (CF-247)
-- For: Platform Admin, by hand in the SQL editor of fxcwkweaxjtknorudmwp (NOT coursefinder-demo). Never applied by the agent.
-- Authority: Platform Admin 27 Oct 2026 14:35, Priority 2: "After deploy verification: D3 controlled recovery of the affected runs only, and read
-- Qatar once. No re-read of the 25 complete runs or the 3 D2 pages." PR A (#715, worker v0.48.8) merged and verified live (version 215, 17 files
-- byte for byte the repo's at c9d333a2). Record: admin docs/platform/aer-v1.1-build-log.md.
--
-- One transaction; raises and changes nothing if the live state differs:
--   guard   entry.providers is exactly UTS + WSU (RMIT out); the D3 re-read function is the guarded one (md5 ca394b60…); RMIT runs are exactly:
--           25 done; queued Singapore, Sri Lanka, Thailand, UK, Vietnam, Qatar; failed Norway, Nigeria and the 3 D2 pages; all 36 sources read.
--   hold    Vietnam (PR B, not yet built) is held: state 'failed' with the reason, attempts and history unchanged, so it is not read now.
--           After PR B it is re-queued by D3 (its hold is kept in its history).
--   D3      Norway is re-queued by the D3 function (its failed result, error and attempts stay in its history). Under v0.48.8 it is held before any
--           AI read ("no printed scale"), terminal: no AI cost.
--   open    RMIT is added to entry.providers. The scheduled entry-matrix-read job (every 5 minutes) then reads only what is claimable for RMIT:
--           Singapore, Sri Lanka, Thailand, UK, Qatar (AI) and Norway (held, no AI). Nothing else is claimable: the 25 complete runs are done, the
--           D2 pages and Nigeria are failed, Vietnam is held, and no RMIT source is due for fetching (all read 26 Oct; refresh after 30 days).
--   after   apply PASTE-20261027-aer-pr-a-recovery-close.sql once the six runs have settled (none queued or leased).
-- The reads within the lane's attempt limit are the lane's normal behaviour (Singapore 1 left, Sri Lanka/Thailand/UK 2, Qatar 3).
-- Nothing deleted. Consumer API not touched.

begin;

do $paste$
declare v_rmit constant text := '8e1adb6c-e069-43db-9584-bd054255e702'; v_n int; v_s text; v_r jsonb;
begin
  if (select value from pipeline.platform_toolset_settings where toolset_key = 'pipeline' and key = 'entry.providers')
     <> '["9d22a19e-c3f7-4012-b738-17bc0b481e7f", "1719c3ba-1ddf-483e-935e-c750124ba99c"]'::jsonb then
    raise exception 'guard: entry.providers is not exactly UTS + WSU; nothing changed'; end if;
  if md5(pg_get_functiondef('public.admin_entry_matrix_reread(uuid[],text)'::regprocedure)) <> 'ca394b60216ef06dfc2ce9db265e8efe' then
    raise exception 'guard: the D3 re-read function changed; nothing changed'; end if;
  select string_agg(split_part(s.url, '/country-equivalency/', 2) || ':' || r.state, ',' order by split_part(s.url, '/country-equivalency/', 2)) into v_s
    from pipeline.entry_matrix_runs r join pipeline.entry_matrix_sources s on s.id = r.source_id where r.provider_id = v_rmit::uuid and r.state <> 'done';
  if v_s <> 'foundation-equivalencies:failed,global-assessment-certificate:failed,international-baccalaureate:failed,nigeria:failed,norway:failed,qatar:queued,singapore:queued,sri-lanka:queued,thailand:queued,united-kingdom:queued,vietnam:queued' then
    raise exception 'guard: RMIT runs not as expected (%); nothing changed', v_s; end if;
  select count(*) into v_n from pipeline.entry_matrix_runs where provider_id = v_rmit::uuid and state = 'done';
  if v_n <> 25 then raise exception 'guard: % done RMIT runs, expected 25; nothing changed', v_n; end if;
  select count(*) into v_n from pipeline.entry_matrix_sources where provider_id = v_rmit::uuid and status = 'read';
  if v_n <> 36 then raise exception 'guard: % RMIT sources read, expected 36; nothing changed', v_n; end if;

  -- hold Vietnam until PR B
  update pipeline.entry_matrix_runs set state = 'failed', updated_at = now(),
         error = 'held: AER PR B (table context) not yet built; not read in the PR A recovery (Platform Admin 27 Oct 2026 14:35)'
   where id = '33eba77e-ba83-4ffa-bd1b-267ffe6aa14c' and state = 'queued';
  get diagnostics v_n = row_count; if v_n <> 1 then raise exception 'Vietnam hold: % rows; rolled back', v_n; end if;

  -- D3: Norway
  perform set_config('request.jwt.claims', '{"sub":"63ba56cb-48d4-4169-98c2-7c4d1f72925b","role":"authenticated"}', true);
  v_r := public.admin_entry_matrix_reread(array['28a5471d-c63a-469a-ac67-eec9af3764fd']::uuid[],
           'AER PR A (#715, v0.48.8) controlled recovery: Norway is held under the printed-scale rule (Platform Admin 27 Oct 2026)');
  if (v_r->>'runs')::int <> 1 then raise exception 'Norway re-read: %; rolled back', v_r; end if;

  -- open: RMIT into entry.providers
  update pipeline.platform_toolset_settings set value = value || to_jsonb(v_rmit), updated_at = now(), updated_by = '63ba56cb-48d4-4169-98c2-7c4d1f72925b',
         reason = 'Platform Admin 27 Oct 2026 14:35: AER PR A controlled recovery (Singapore, Sri Lanka, Thailand, UK, Norway held, Qatar once); closed by PASTE-20261027-aer-pr-a-recovery-close.sql'
   where toolset_key = 'pipeline' and key = 'entry.providers';
  get diagnostics v_n = row_count; if v_n <> 1 then raise exception 'entry.providers: % rows; rolled back', v_n; end if;

  select count(*) into v_n from pipeline.entry_matrix_runs r where r.provider_id = v_rmit::uuid and r.state = 'queued' and r.attempts < security.pipeline_num_v1('entry.matrix_attempts', 3);
  if v_n <> 6 then raise exception 'claimable RMIT runs %, expected 6; rolled back', v_n; end if;

  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('entry_matrix', 'recovery_open_paste', 'RMIT AER PR A recovery',
          jsonb_build_object('claimable', array['singapore','sri-lanka','thailand','united-kingdom','qatar','norway'], 'vietnam', 'held until PR B',
                             'norway_reread', v_r, 'worker', 'coverage-sweep-worker-v0.48.8'), '63ba56cb-48d4-4169-98c2-7c4d1f72925b'::uuid);
  raise notice 'recovery open: 6 runs claimable';
end $paste$;

commit;
