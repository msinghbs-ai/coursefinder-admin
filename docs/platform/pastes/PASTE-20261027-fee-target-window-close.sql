-- PASTE-20261027-fee-target-window-close.sql   (revised target-list proposal, part B of 2)
-- Apply after part A, once the 54 pages have settled (none 'found' or 'reading') or 24 hours after part A, whichever is first.
-- PROPOSAL ONLY: NOT applied; returned for separate authority together with part A.
-- What it does (one transaction): takes the 42 providers off the Firecrawl target list again (included = false, kept with its reason; nothing is
-- deleted), refreshes the target cache, and reports the credits spent on these providers since part A against the 1,013-credit bound.
-- It raises (rolls back) only if part A was not applied. A spend above the bound is reported in the control event and as a notice, not hidden.
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
  v_open timestamptz; v_n int; v_credits numeric; v_pages int; v_left int;
begin
  select created_at into v_open from pipeline.admin_control_events where action = 'firecrawl_target_window_open' and target = 'fee-target-window-20261027' order by id desc limit 1;
  if v_open is null then raise exception 'part A was not applied; nothing changed'; end if;
  select coalesce(sum(units), 0), count(*) into v_credits, v_pages from pipeline.coverage_vendor_usage where provider_id = any(v_p) and at >= v_open;
  select count(*) into v_left from pipeline.provider_fact_sources where provider_id = any(v_p) and kind = 'fee_schedule' and status in ('found', 'reading');
  update pipeline.firecrawl_targets set included = false, set_at = now(), reason = reason || ' | window closed (paste B)'
   where provider_id = any(v_p) and reason like 'fee-target-window-20261027:%' and included;
  get diagnostics v_n = row_count; if v_n <> 42 then raise exception 'closed % target rows, expected 42', v_n; end if;
  perform security.firecrawl_targets_refresh_v1();
  select count(*) into v_n from pipeline.firecrawl_target_cache where provider_id = any(v_p) and included;
  if v_n <> 0 then raise exception '% providers still included after the refresh', v_n; end if;
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('toolsets', 'firecrawl_target_window_close', 'fee-target-window-20261027',
          jsonb_build_object('providers', 42, 'credits_spent', v_credits, 'firecrawl_calls', v_pages, 'bound_credits', 1013,
                             'within_bound', v_credits <= 1013, 'fee_pages_not_settled', v_left, 'opened_at', v_open),
          '63ba56cb-48d4-4169-98c2-7c4d1f72925b');
  raise notice 'window closed: % credits in % calls (bound 1013); % fee pages not yet settled', v_credits, v_pages, v_left;
end $$;
commit;
