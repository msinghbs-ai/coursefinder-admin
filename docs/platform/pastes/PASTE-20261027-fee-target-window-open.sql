-- PASTE-20261027-fee-target-window-open.sql   (revised target-list proposal, part A of 2; replaces PASTE-20261027-fee-target-list-proposal.sql)
-- CF-247. Platform Admin mandate 27 Oct 2026 08:15, item 5: "accompanied by an exact cross-lane inventory and a hard, testable upper bound on
-- pages and credits". PROPOSAL ONLY: NOT applied; returned for separate authority. Workbook: AU-fee-target-list-proposal-2026-10-27.xlsx (v2).
--
-- Why not "restricted to the 54 reads": the fee-schedule lane (worker mode provider_facts) reads every page through Firecrawl and never tries a
-- direct read first, and Firecrawl eligibility is per provider (pipeline.firecrawl_targets). No existing control limits Firecrawl to named pages,
-- so a 54-read-only version needs a worker change (read directly first, as the entry-matrix lane does), which this mandate does not authorise.
-- That change is named in the workbook as an alternative for a decision (it would likely read most of the 54 pages at zero credits).
--
-- This version opens a WINDOW instead: part A puts 42 providers on the target list and returns their 54 refused tuition pages to the reader;
-- part B (PASTE-20261027-fee-target-window-close.sql) takes them off again after the reads settle (target: within 24 hours) and reports
-- the credits actually spent on these providers in the window against the bound below.
-- Cross-lane inventory of what else becomes Firecrawl-eligible for these 42 providers while the window is open (live, 27 Oct 08:3x), with
-- the worst case for a 24-hour window (every item due, every attempt used):
--   fee-schedule pages (the purpose)                54 pages   x 3 attempts x 1 credit       =   162
--   course-page search, queued items                83 items   x 3 attempts x 2 credits      =   498
--   course pages needing the scraper (blocked 5,
--     needs rendering 22, fetch failed 18)          45 pages   x 3 attempts x 1 credit       =   135
--   course-list re-reads (10 lists, max 10 pages)   100 pages  x 1 credit                    =   100
--   site maps (discovery 42, source-find 17)        59 runs    x 2 (map + map search)        =   118
--   english/calendar/other fee pages: 0 (all 'failed' or 'read'; none returns to the reader unless a person resets it)
--   scholarships, central maps, site checks: 0 extra (they already bypass the target list)
--   WORST CASE: 1,013 credits; at most 199 pages scraped, 249 searches, 118 maps. Expected: about 54-120 credits.
-- Hard ceiling that still applies: the Firecrawl daily budget (firecrawl.daily_budget_total 25,000, shares by purpose) and every lane's caps.
-- Testable: part B measures pipeline.coverage_vendor_usage for these 42 providers since this paste's control event and reports it against 1,013.
-- Expected outcome (from the 26 Oct wave: 44 of 167 read pages gave rows; 121 courses admitted, 104 to Layer 4):
--   courses covered by the 54 pages' providers with no provider tuition: 400 (a source covering them, not admissions);
--   expected admitted tuition values: about 40 courses (about 30 more to Layer 4 review). Exclusions kept: 22 PDFs, 33 non-tuition pages, 1 duplicate.
-- Nothing is dropped or deleted. No consumer-API object is touched.
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
  v_s uuid[] := array[
    'dfd37c9a-3bae-4372-90d2-2b0154e6061c',
    'be63650f-f737-4359-b38f-881eca10c39d',
    '183c9a6a-f8d4-4710-b50a-f09eecadfb36',
    'c9793085-a06e-45fb-94fe-459146832dab',
    'f17474e9-7f09-44e8-92fe-62e1bc2c9dad',
    'c2fd5722-03da-4987-a2bb-b59c13c0a08e',
    '5fd3ef83-e528-4f12-b94f-b1fb8cf1f40b',
    '812b3d62-f6f9-4b9d-837e-844e45519fad',
    '405ecfbf-8f87-4410-a8bd-2b76926f5a17',
    '3ee119fa-974e-4296-9574-8f037dbd4def',
    'a4728313-fc9e-4851-aec5-01af1cf7fee6',
    '1f443190-a10b-46c8-a52e-2fb2ded7fe88',
    '027c8ff7-b693-477c-9c15-cca2c0410f86',
    '13836bca-3409-4bb5-8043-fd5779adb8ac',
    'c5c6a9be-9877-4e41-933b-eb0fae281420',
    '46f5176f-e671-438f-8d13-8014c7509aaf',
    'c01bd286-0d81-4d97-84ea-b372cb8f5661',
    '5abfb39c-9149-4a1d-a695-2f9bc9c331c8',
    '6a92247d-6270-4029-b110-030823b8d969',
    '66200434-8d96-4d26-bd9f-bd5fae1ebf04',
    'e222369a-c2df-4e7f-aae9-dbc93178a7fd',
    '28225bd3-d625-429f-8787-fcf71f2b338b',
    '67715ef7-499a-41ff-98a2-7849eed4415a',
    'ae518f69-1f41-41a1-908a-1728a196da7f',
    '90115cdc-7961-42f9-9634-693009611663',
    '3c223709-99f1-4435-b1b6-fc27789e39bf',
    'e3851e59-c709-4af5-b2b1-0de1921a950f',
    'efee9124-675e-4d58-b2f6-6f9506f87766',
    '871167ab-c171-4c4a-8ed1-02a42cbf3acb',
    '8cf311d0-0bd4-4df1-98f0-c67fae5540ae',
    'a618248d-9649-4138-ae4f-85937a058b6c',
    '5e38d8b5-80b2-48ab-8d80-4638e6903193',
    'd590d1c9-b929-4386-b985-899063c8db84',
    '9a49bad4-aa6a-4f4c-bc6f-1f18821efe9c',
    'e626aa17-c407-4170-b6ed-0c469382f61a',
    '4d0a71b0-6e5c-40dd-8246-fdfd1298a6ef',
    '2a8d5116-ccd3-400b-991f-61d159076bc3',
    'b9079f69-004d-40b7-8abe-40ff0fe2d82c',
    '05f77ae8-4169-4de0-96dd-9c968bc7c712',
    'bed69120-b4c9-4f0a-9b36-e9c84a9f5a89',
    '2b1e7dc1-3d8b-4ae0-a25e-bb52f6bdadf5',
    '939b0d3b-191b-4d0e-8f04-2d9c6d6f7cee',
    '3638bdf9-73f0-4287-9e78-f47d399e607e',
    '7e04170d-b524-4582-bd8f-e1c6af8913e9',
    '01c6ad3d-aca9-46cf-b9da-ad09c9956fab',
    'c4ea3327-6a72-476b-a62f-8e33e5108eba',
    '678af8bd-f5e5-49b7-af08-075f2941bbbc',
    '9bede644-8fd1-4e2e-9160-6f7e837e35c0',
    'd796bfaa-680d-4c02-b45b-3d156a74522f',
    '08612552-6f8b-423a-b8cd-545644bc58dc',
    'd877c5de-d08d-4309-893a-8d245c0834b9',
    '7b438428-9176-4947-b7cd-54ffba6c8313',
    'de5852d1-bc37-45c0-9a81-613e0a01b9ac',
    '5bfc24ad-ec36-4622-848f-10988cef56b0']::uuid[];
  v_n int;
begin
  if array_length(v_p,1) <> 42 or array_length(v_s,1) <> 54 then raise exception 'list length changed'; end if;
  if md5(array_to_string(array(select x::text from unnest(v_p) x order by 1), ',')) <> md5('08eb6ab1-4c76-40b5-994c-861d25b6c1f8,0ba022f8-dd06-49f5-9c96-2e80a3d71e16,104f3038-862c-445d-aaf3-b8727ff756f3,10bbe19c-65a0-49fd-bbd2-64075f157985,12924d5c-3e7d-4c99-a10f-10fc36bb244a,141c895b-9fd5-4c10-9427-bf457593de37,16b21695-cd55-4ea9-a0c5-e7f6fc9c57ef,16fd98a2-1cb8-46f0-bd58-3b598f39e3be,20957823-3db4-4ab6-8706-91a9efeac7b1,24aead57-1eae-469a-9a5b-328451fc86b3,2ad1287c-34a3-44df-b5f3-cf4d8b12d404,48c975a0-5952-47f6-adcf-b830cdc572ac,4b0e9d62-2ad7-4467-911c-1571e30a74d6,4e8fe8de-b6bc-47e8-bbb7-b4dcbf218d30,54ade74a-ce50-42cc-b2ae-98035af055de,551383f9-7732-4588-a843-dd2b97c13f6f,58238b5c-07df-4140-b90f-0280f925f0c7,5e04c6e1-2a45-4fec-9ade-c0cd8ceb6d5f,6ba21067-11bf-45c8-af40-8d0b35018a35,6c582396-501c-43c0-b6fa-d7f41fbf7e2c,6ca59aae-b404-4265-8ace-b77ddb0c23bc,6e7d9112-8671-4ae0-9946-c27105eb731b,7896e9f1-f51d-43b6-ab68-fbcdc5a63f9e,7ccf8b4a-9550-439b-a69d-b5b84d679d4e,7dae6c50-bc55-4f99-866c-1204bb243c79,80029086-9cc4-43d6-bb6f-4b5351a5ca1d,8c43cfec-c6d4-42fc-a9d9-5f0896536681,94556c93-5fd3-4fc7-a03d-41a80653d4b0,9a5d8eb6-ed7b-4e85-856f-0b2f72ba5278,a2a42020-d3ed-495d-8bb6-7418253260af,ac672bf2-086b-4d9f-8aa6-6f3057f58a51,b3a9b9b4-496a-4eb8-8791-47e0a1aee30e,b916ff47-52ae-4a6e-82e1-5d70d48f0eb8,bad56885-f5c6-448f-93fc-3e79e48588f9,bd473ff9-d45a-4447-9b84-cead3c11c01c,d3e46509-5c44-4268-8b7d-9ca5cff7593c,e40dae56-ae8a-4ba4-bc8b-cc7f1c8d1471,efba294e-9b1b-4c2d-a39b-42d91082d3d3,f2ce9118-434a-4999-acb8-cad6b6ef39d5,f4ed3151-b81e-46d9-8a6c-d7e302ab63ae,f89402df-e5a4-4a17-9e88-b19f0dd6435d,fe6f2e1b-a381-4ef8-b41a-cc7a0dedf4b5') then raise exception 'provider list changed'; end if;
  select count(*) into v_n from pipeline.firecrawl_targets where provider_id = any(v_p);
  if v_n <> 0 then raise exception 'guard 1: expected 0 existing target rows for these providers, found %', v_n; end if;
  select count(*) into v_n from pipeline.firecrawl_target_cache where provider_id = any(v_p) and included;
  if v_n <> 0 then raise exception 'guard 1: % of these providers are already Firecrawl targets', v_n; end if;
  select count(*) into v_n from pipeline.provider_fact_sources
   where id = any(v_s) and provider_id = any(v_p) and kind = 'fee_schedule' and status = 'failed' and parse_summary->>'error' = 'target_list_refused';
  if v_n <> 54 then raise exception 'guard 1: expected 54 refused fee-schedule pages, found %', v_n; end if;

  insert into pipeline.firecrawl_targets(provider_id, included, reason, set_by, set_at)
  select x, true, 'fee-target-window-20261027: Platform Admin decision (paste A): read 54 refused fee-schedule pages; closed by paste B', '63ba56cb-48d4-4169-98c2-7c4d1f72925b', now() from unnest(v_p) x;
  get diagnostics v_n = row_count; if v_n <> 42 then raise exception 'guard 2: inserted % target rows, expected 42', v_n; end if;
  perform security.firecrawl_targets_refresh_v1();
  select count(*) into v_n from pipeline.firecrawl_target_cache where provider_id = any(v_p) and included;
  if v_n <> 42 then raise exception 'guard 2: % providers included after the refresh, expected 42', v_n; end if;

  update pipeline.provider_fact_sources set status = 'found', attempts = 0, updated_at = now()
   where id = any(v_s) and kind = 'fee_schedule' and status = 'failed' and parse_summary->>'error' = 'target_list_refused';
  get diagnostics v_n = row_count; if v_n <> 54 then raise exception 'guard 2: reset % pages, expected 54', v_n; end if;

  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('toolsets', 'firecrawl_target_window_open', 'fee-target-window-20261027',
          jsonb_build_object('providers', 42, 'pages_returned_to_found', 54, 'worst_case_credits', 1013, 'worst_case_pages', 199,
                             'reason', 'Platform Admin decision: fee-schedule pages refused by the Firecrawl target list (bounded window; closed by paste B)'),
          '63ba56cb-48d4-4169-98c2-7c4d1f72925b');
end $$;
commit;
