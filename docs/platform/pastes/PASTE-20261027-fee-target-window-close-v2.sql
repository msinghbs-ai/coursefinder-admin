-- PASTE-20261027-fee-target-window-close-v2.sql   (part B of 2, revised 27 Oct 2026 18:1x; supersedes the v1 close for exact restoration)
-- For: Platform Admin, by hand in the SQL editor of fxcwkweaxjtknorudmwp (NOT coursefinder-demo). Never applied by the agent.
-- Authority: Platform Admin 27 Oct 2026 18:03, fee-window decision 5: "When the 15 in-scope pages settle, present Paste B for manual closure and
-- verify restoration of the original target list." Settled (live, read-only, 18:1x): all 54 in-scope pages read (2 parsed, 52 no values), no
-- out-of-scope fee page of the 42 providers unread, no fee-reader item queued or leased; last read 17:30 AEDT.
-- Why v2: before part A these 42 providers had NO row in pipeline.firecrawl_targets (part A's guard 1). v1 sets the 42 rows to included = false,
-- which leaves a standing override that keeps them off the list even if they later meet the target rule (included = coalesce(override, rule)).
-- v2 removes exactly the 42 rows part A inserted, so the target list is the original one. Today none of the 42 meets the rule, so the effective
-- Firecrawl eligibility is the same either way; the difference is the standing override. (v1 remains available if you prefer no delete.)
-- What it does (one transaction; raises and changes nothing if the live state differs):
--   guard   part A's event exists; exactly 42 target rows carry part A's reason, all for these 42 providers, all included, none changed since part A;
--           no fee page of these providers is found or reading (settled)
--   report  credits spent on these providers since part A (all purposes)
--   restore delete exactly those 42 rows; refresh the cache; then: 0 rows for these providers, 0 included in the cache, total target rows 983
--   log     one admin_control_events row with the credit report and the deleted rows (provider, reason, set_at) for the record
-- Consumer API not touched. Admitted values are not touched.
begin;
do $$
declare v_p uuid[] := array[
    '08eb6ab1-4c76-40b5-994c-861d25b6c1f8',
    '0ba022f8-dd06-49f5-9c96-2e80a3d71e16',
    '104f3038-862c-445d-aaf3-b8727ff756f3',
    '10bbe19c-65a0-49fd-bbd2-64075f157985',
    '12924d5c-3e7d-4c99-a10f-10fc36bb244a',
    '141c895b-9fd5-4c10-9427-bf457593de37',
    '16b21695-cd55-4ea9-a0c5-e7f6fc9c57ef',
    '16fd98a2-1cb8-46f0-bd58-3b598f39e3be',
    '20957823-3db4-4ab6-8706-91a9efeac7b1',
    '24aead57-1eae-469a-9a5b-328451fc86b3',
    '2ad1287c-34a3-44df-b5f3-cf4d8b12d404',
    '48c975a0-5952-47f6-adcf-b830cdc572ac',
    '4b0e9d62-2ad7-4467-911c-1571e30a74d6',
    '4e8fe8de-b6bc-47e8-bbb7-b4dcbf218d30',
    '54ade74a-ce50-42cc-b2ae-98035af055de',
    '551383f9-7732-4588-a843-dd2b97c13f6f',
    '58238b5c-07df-4140-b90f-0280f925f0c7',
    '5e04c6e1-2a45-4fec-9ade-c0cd8ceb6d5f',
    '6ba21067-11bf-45c8-af40-8d0b35018a35',
    '6c582396-501c-43c0-b6fa-d7f41fbf7e2c',
    '6ca59aae-b404-4265-8ace-b77ddb0c23bc',
    '6e7d9112-8671-4ae0-9946-c27105eb731b',
    '7896e9f1-f51d-43b6-ab68-fbcdc5a63f9e',
    '7ccf8b4a-9550-439b-a69d-b5b84d679d4e',
    '7dae6c50-bc55-4f99-866c-1204bb243c79',
    '80029086-9cc4-43d6-bb6f-4b5351a5ca1d',
    '8c43cfec-c6d4-42fc-a9d9-5f0896536681',
    '94556c93-5fd3-4fc7-a03d-41a80653d4b0',
    '9a5d8eb6-ed7b-4e85-856f-0b2f72ba5278',
    'a2a42020-d3ed-495d-8bb6-7418253260af',
    'ac672bf2-086b-4d9f-8aa6-6f3057f58a51',
    'b3a9b9b4-496a-4eb8-8791-47e0a1aee30e',
    'b916ff47-52ae-4a6e-82e1-5d70d48f0eb8',
    'bad56885-f5c6-448f-93fc-3e79e48588f9',
    'bd473ff9-d45a-4447-9b84-cead3c11c01c',
    'd3e46509-5c44-4268-8b7d-9ca5cff7593c',
    'e40dae56-ae8a-4ba4-bc8b-cc7f1c8d1471',
    'efba294e-9b1b-4c2d-a39b-42d91082d3d3',
    'f2ce9118-434a-4999-acb8-cad6b6ef39d5',
    'f4ed3151-b81e-46d9-8a6c-d7e302ab63ae',
    'f89402df-e5a4-4a17-9e88-b19f0dd6435d',
    'fe6f2e1b-a381-4ef8-b41a-cc7a0dedf4b5']::uuid[];
  v_open timestamptz; v_n int; v_credits numeric; v_calls int; v_left int; v_rows jsonb;
begin
  if array_length(v_p, 1) <> 42 then raise exception 'list length changed'; end if;
  select created_at into v_open from pipeline.admin_control_events where action = 'firecrawl_target_window_open' and target = 'fee-target-window-20261027' order by id desc limit 1;
  if v_open is null then raise exception 'part A was not applied; nothing changed'; end if;
  select count(*) into v_n from pipeline.firecrawl_targets where reason like 'fee-target-window-20261027:%';
  if v_n <> 42 then raise exception 'guard: % target rows carry the window reason, expected 42; nothing changed', v_n; end if;
  select count(*) into v_n from pipeline.firecrawl_targets where reason like 'fee-target-window-20261027:%' and provider_id = any(v_p) and included and set_at = v_open;
  if v_n <> 42 then raise exception 'guard: % of the 42 window rows unchanged since part A; nothing changed', v_n; end if;
  select count(*) into v_n from pipeline.firecrawl_targets where provider_id = any(v_p) and reason not like 'fee-target-window-20261027:%';
  if v_n <> 0 then raise exception 'guard: % other target rows for these providers; nothing changed', v_n; end if;
  select count(*) into v_left from pipeline.provider_fact_sources where provider_id = any(v_p) and kind = 'fee_schedule' and status in ('found', 'reading');
  if v_left <> 0 then raise exception 'guard: % fee pages of these providers not settled; nothing changed', v_left; end if;

  select coalesce(sum(u.units), 0), count(*) into v_credits, v_calls from pipeline.coverage_vendor_usage u where u.provider_id = any(v_p) and u.at >= v_open;
  select jsonb_agg(jsonb_build_object('provider_id', provider_id, 'reason', reason, 'set_at', set_at) order by provider_id) into v_rows
    from pipeline.firecrawl_targets where reason like 'fee-target-window-20261027:%';

  delete from pipeline.firecrawl_targets where reason like 'fee-target-window-20261027:%' and provider_id = any(v_p) and set_at = v_open;
  get diagnostics v_n = row_count; if v_n <> 42 then raise exception 'removed % target rows, expected 42; rolled back', v_n; end if;
  perform security.firecrawl_targets_refresh_v1();
  select count(*) into v_n from pipeline.firecrawl_target_cache where provider_id = any(v_p) and included;
  if v_n <> 0 then raise exception '% providers still included after the refresh; rolled back', v_n; end if;
  select count(*) into v_n from pipeline.firecrawl_targets where provider_id = any(v_p);
  if v_n <> 0 then raise exception '% target rows remain for these providers; rolled back', v_n; end if;
  select count(*) into v_n from pipeline.firecrawl_targets;
  if v_n <> 983 then raise exception 'target rows now %, expected 983 (1,025 before the close); rolled back', v_n; end if;

  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('toolsets', 'firecrawl_target_window_close', 'fee-target-window-20261027',
          jsonb_build_object('providers', 42, 'credits_spent', v_credits, 'firecrawl_calls', v_calls, 'bound_credits', 1013, 'within_bound', v_credits <= 1013,
                             'fee_pages_not_settled', v_left, 'opened_at', v_open, 'restored', 'original target list (the 42 window rows removed)',
                             'target_rows_after', 983, 'removed_rows', v_rows), '63ba56cb-48d4-4169-98c2-7c4d1f72925b');
  raise notice 'window closed: % credits in % calls (bound 1013); original target list restored (983 rows)', v_credits, v_calls;
end $$;
commit;
