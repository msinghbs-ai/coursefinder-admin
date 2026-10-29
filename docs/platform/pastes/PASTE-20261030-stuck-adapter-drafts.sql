-- =====================================================================================
-- CF-247: close five adapter drafts stuck in 'capturing'. Governed paste, operator action.
-- Prepared by lane N on 30 Oct 2026. NOT EXECUTED. Run by the Platform Admin (or on his
-- explicit instruction) in the Supabase SQL editor of project fxcwkweaxjtknorudmwp ONLY.
--
-- Reconciliation:   PASTE-20261030-stuck-adapter-drafts-RECONCILIATION.md (same folder).
-- End state:        status 'error'. This is an existing value, already written by
--                   public.svc_adapter_draft_record when the worker reports an error
--                   (19 drafts already hold it). No new status is introduced.
-- Error record:     the same shape that function writes. One entry is appended to
--                   `proposals`: {at, kind:'error', model:null, cost:0, error, source}.
-- Not changed:      captures, samples, cost_usd, reason, comments, provider_onboarding,
--                   provider_onboarding_events. Nothing is deleted.
-- Effect:           Vardhan Institute (150489ef) and AIBT / Sydney International School
--                   (6a6b10a5) are no longer blocked by admin_adapter_builder's "current
--                   samples are still being captured" guard (their newest draft is one of
--                   these). Kulin (43c9cabe) already has newer drafts.
-- Expected counts:  5 drafts updated, 1 admin_control_events row inserted.
-- Snapshot md5 before (id|provider|status|captures|proposals|cost|created|updated, ordered by
-- id): b8e5c62ac9612834d8d56037b158fac4 (taken 30 Oct 2026 about 07:10 AEDT).
-- =====================================================================================

begin;

-- ---------------------------------------------------------------- 1. Preconditions
do $pre$
declare
  v_ids constant uuid[] := array[
    '5c8a27a6-0ab7-4d5d-9d56-4780acb2b69f',  -- Vardhan Institute, 27 Oct 16:46 UTC
    '6780a06b-0d3d-45c2-918a-e4bcc379300b',  -- Vardhan Institute, 27 Oct 17:16 UTC (retry)
    '957b620b-dd36-474d-af23-191ac12804c3',  -- AIBT / Sydney Intl School, 27 Oct 20:58 UTC
    '4563a4d7-1b08-4da8-a441-679c91a5c272',  -- AIBT / Sydney Intl School, 27 Oct 21:28 UTC (retry)
    '6a3ee319-267b-4b42-92a8-6a603e53f3e1'   -- Kulin Institute, 29 Oct 12:10 UTC
  ]::uuid[];
  v_n int;
  v_snap text;
begin
  -- a. Exactly these 5 rows exist, all still 'capturing', never touched since creation,
  --    with nothing captured, nothing proposed and nothing spent.
  select count(*) into v_n
    from pipeline.uni_adapter_drafts d
   where d.id = any (v_ids)
     and d.status = 'capturing'
     and d.captures = '[]'::jsonb
     and d.proposals = '[]'::jsonb
     and d.cost_usd = 0
     and d.updated_at = d.created_at
     and d.created_at < now() - interval '1 hour';   -- well past the 30-minute capture time-out the onboarding step uses
  if v_n <> 5 then
    raise exception 'PRECONDITION a failed: expected 5 untouched capturing drafts, found %', v_n;
  end if;

  -- b. Row snapshot unchanged since reconciliation.
  select md5(string_agg(concat_ws('|', id, provider_id, status, captures::text, proposals::text,
                                  cost_usd::text, created_at::text, updated_at::text), ';' order by id))
    into v_snap
    from pipeline.uni_adapter_drafts where id = any (v_ids);
  if v_snap is distinct from 'b8e5c62ac9612834d8d56037b158fac4' then
    raise exception 'PRECONDITION b failed: snapshot md5 is %, expected b8e5c62ac9612834d8d56037b158fac4', v_snap;
  end if;

  -- c. Provider of each draft is as reconciled.
  select count(*) into v_n from pipeline.uni_adapter_drafts d
   where (d.id, d.provider_id) in (
     ('5c8a27a6-0ab7-4d5d-9d56-4780acb2b69f'::uuid, '150489ef-8ffd-4aa5-b742-191b86942b9c'::uuid),
     ('6780a06b-0d3d-45c2-918a-e4bcc379300b'::uuid, '150489ef-8ffd-4aa5-b742-191b86942b9c'::uuid),
     ('957b620b-dd36-474d-af23-191ac12804c3'::uuid, '6a6b10a5-8b31-438d-9c43-fd6299f034e3'::uuid),
     ('4563a4d7-1b08-4da8-a441-679c91a5c272'::uuid, '6a6b10a5-8b31-438d-9c43-fd6299f034e3'::uuid),
     ('6a3ee319-267b-4b42-92a8-6a603e53f3e1'::uuid, '43c9cabe-af15-4738-b032-6aef94706079'::uuid));
  if v_n <> 5 then
    raise exception 'PRECONDITION c failed: draft/provider pairs differ (% of 5 match)', v_n;
  end if;

  -- d. No onboarding run is still working on any of them. The 2 onboarding rows that point at a
  --    stuck draft are both stopped with capture_failed; none is in an active step.
  select count(*) into v_n from pipeline.provider_onboarding o
   where o.draft_id = any (v_ids)
     and o.status in ('website','course_pages','capturing','proposing','applying','qualifying','scholarships','queued');
  if v_n <> 0 then
    raise exception 'PRECONDITION d failed: % active onboarding row(s) still reference these drafts', v_n;
  end if;
  select count(*) into v_n from pipeline.provider_onboarding o
   where o.draft_id = any (v_ids) and o.status = 'stopped' and o.stop_reason = 'capture_failed';
  if v_n <> 2 then
    raise exception 'PRECONDITION d2 failed: expected 2 stopped/capture_failed onboarding rows on these drafts, found %', v_n;
  end if;

  -- e. No adapter autobuild references them.
  select count(*) into v_n from pipeline.adapter_autobuilds a where a.draft_id = any (v_ids);
  if v_n <> 0 then
    raise exception 'PRECONDITION e failed: % adapter_autobuilds row(s) reference these drafts', v_n;
  end if;

  -- f. The audit row has not already been written (the paste is not being run twice).
  select count(*) into v_n from pipeline.admin_control_events
   where area = 'toolsets' and action = 'adapter_draft_close' and target = 'cf247-stuck-capturing-20261030';
  if v_n <> 0 then
    raise exception 'PRECONDITION f failed: audit row already present (% rows); paste already run?', v_n;
  end if;

  raise notice 'Preconditions passed: 5 drafts, snapshot b8e5c62a, 0 active references.';
end
$pre$;

-- ---------------------------------------------------------------- 2. Audit row (before and after)
insert into pipeline.admin_control_events (area, action, target, detail, actor)
select 'toolsets',
       'adapter_draft_close',
       'cf247-stuck-capturing-20261030',
       jsonb_build_object(
         'reason', 'CF-247 Platform Admin 30 Oct 2026: five adapter drafts left in capturing after their sample-capture '
                   'call was refused or lost by the edge runtime (no capture result was ever recorded). '
                   'Closed as error, the existing failure status. Nothing deleted.',
         'paste', 'laneN/STUCK-DRAFTS-PASTE.sql',
         'to_status', 'error',
         'count', 5,
         'before', (select jsonb_agg(jsonb_build_object('id', d.id, 'provider_id', d.provider_id, 'status', d.status,
                                                        'created_at', d.created_at, 'updated_at', d.updated_at,
                                                        'proposals', d.proposals) order by d.created_at)
                      from pipeline.uni_adapter_drafts d
                     where d.id in ('5c8a27a6-0ab7-4d5d-9d56-4780acb2b69f','6780a06b-0d3d-45c2-918a-e4bcc379300b',
                                    '957b620b-dd36-474d-af23-191ac12804c3','4563a4d7-1b08-4da8-a441-679c91a5c272',
                                    '6a3ee319-267b-4b42-92a8-6a603e53f3e1'))),
       '63ba56cb-48d4-4169-98c2-7c4d1f72925b'::uuid;   -- Platform Admin (actor used on earlier paste events)

-- ---------------------------------------------------------------- 3. The update (no delete)
update pipeline.uni_adapter_drafts d
   set status     = 'error',
       proposals  = d.proposals || jsonb_build_array(jsonb_build_object(
                      'at', now(),
                      'kind', 'error',
                      'model', null,
                      'cost', 0,
                      'error', case d.id
                        when '6780a06b-0d3d-45c2-918a-e4bcc379300b' then
                          'Sample capture did not finish: the edge runtime returned 502 after 73 s (27 Oct 2026 17:17 UTC); no capture was recorded.'
                        when '6a3ee319-267b-4b42-92a8-6a603e53f3e1' then
                          'Sample capture did not finish: the edge runtime refused the call with 503 after 10 s (29 Oct 2026 12:10 UTC); no capture was recorded.'
                        else
                          'Sample capture did not finish: no capture call reached the worker within 30 minutes; no capture was recorded.'
                      end,
                      'source', 'CF-247 paste cf247-stuck-capturing-20261030 (Platform Admin, 30 Oct 2026)')),
       updated_at = now()
 where d.id in ('5c8a27a6-0ab7-4d5d-9d56-4780acb2b69f','6780a06b-0d3d-45c2-918a-e4bcc379300b',
                '957b620b-dd36-474d-af23-191ac12804c3','4563a4d7-1b08-4da8-a441-679c91a5c272',
                '6a3ee319-267b-4b42-92a8-6a603e53f3e1')
   and d.status = 'capturing'
   and d.proposals = '[]'::jsonb;

-- ---------------------------------------------------------------- 4. Post-checks (raise = whole transaction rolls back)
do $post$
declare
  v_ids constant uuid[] := array['5c8a27a6-0ab7-4d5d-9d56-4780acb2b69f','6780a06b-0d3d-45c2-918a-e4bcc379300b',
                                 '957b620b-dd36-474d-af23-191ac12804c3','4563a4d7-1b08-4da8-a441-679c91a5c272',
                                 '6a3ee319-267b-4b42-92a8-6a603e53f3e1']::uuid[];
  v_n int;
begin
  -- 4a. Exactly 5 drafts now 'error', each with exactly one appended error entry from this paste.
  select count(*) into v_n from pipeline.uni_adapter_drafts d
   where d.id = any (v_ids) and d.status = 'error'
     and jsonb_array_length(d.proposals) = 1
     and d.proposals->0->>'kind' = 'error'
     and d.proposals->0->>'source' like 'CF-247 paste cf247-stuck-capturing-20261030%'
     and d.captures = '[]'::jsonb and d.cost_usd = 0;
  if v_n <> 5 then raise exception 'POST-CHECK 4a failed: % of 5 drafts closed as expected', v_n; end if;

  -- 4b. None of the 5 is still capturing.
  select count(*) into v_n from pipeline.uni_adapter_drafts where id = any (v_ids) and status = 'capturing';
  if v_n <> 0 then raise exception 'POST-CHECK 4b failed: % still capturing', v_n; end if;

  -- 4c. Exactly one audit row from this paste, with count 5 and 5 before-images.
  select count(*) into v_n from pipeline.admin_control_events
   where area = 'toolsets' and action = 'adapter_draft_close' and target = 'cf247-stuck-capturing-20261030'
     and (detail->>'count')::int = 5 and jsonb_array_length(detail->'before') = 5;
  if v_n <> 1 then raise exception 'POST-CHECK 4c failed: % audit rows', v_n; end if;

  -- 4d. The two blocked providers are unblocked: their newest draft is no longer capturing/proposing.
  select count(*) into v_n from (
    select distinct on (provider_id) provider_id, status
      from pipeline.uni_adapter_drafts
     where provider_id in ('150489ef-8ffd-4aa5-b742-191b86942b9c','6a6b10a5-8b31-438d-9c43-fd6299f034e3')
     order by provider_id, created_at desc) t
   where t.status in ('capturing','proposing');
  if v_n <> 0 then raise exception 'POST-CHECK 4d failed: % provider(s) still blocked by a newest draft in capturing/proposing', v_n; end if;

  -- 4e. Nothing else touched: onboarding rows and events for these drafts unchanged in count.
  select count(*) into v_n from pipeline.provider_onboarding_events where draft_id = any (v_ids);
  if v_n <> 7 then raise exception 'POST-CHECK 4e failed: expected 7 onboarding events on these drafts, found %', v_n; end if;

  raise notice 'Post-checks passed: 5 drafts closed as error, 1 audit row. Remaining capturing drafts overall: %',
    (select count(*) from pipeline.uni_adapter_drafts where status = 'capturing');
end
$post$;

commit;

-- Expected messages:
--   NOTICE: Preconditions passed: 5 drafts, snapshot b8e5c62a, 0 active references.
--   INSERT 0 1
--   UPDATE 5
--   NOTICE: Post-checks passed: 5 drafts closed as error, 1 audit row. Remaining capturing drafts overall: 19
--           (19 if no new capture started in the meantime; the 19 older stuck drafts are out of scope)
--   COMMIT
-- If any check raises, the transaction rolls back and nothing is changed.


-- =====================================================================================
-- ROLLBACK: SEPARATE BLOCK. Run only if the Platform Admin decides to reverse the change.
-- Restores the exact pre-paste row state (verified against the snapshot md5) and logs it.
-- Left commented out so it cannot run together with the paste above.
-- =====================================================================================
/*
begin;

do $rb_pre$
declare v_n int;
begin
  select count(*) into v_n from pipeline.uni_adapter_drafts d
   where d.id in ('5c8a27a6-0ab7-4d5d-9d56-4780acb2b69f','6780a06b-0d3d-45c2-918a-e4bcc379300b',
                  '957b620b-dd36-474d-af23-191ac12804c3','4563a4d7-1b08-4da8-a441-679c91a5c272',
                  '6a3ee319-267b-4b42-92a8-6a603e53f3e1')
     and d.status = 'error'
     and jsonb_array_length(d.proposals) = 1
     and d.proposals->0->>'source' like 'CF-247 paste cf247-stuck-capturing-20261030%';
  if v_n <> 5 then
    raise exception 'ROLLBACK PRECONDITION failed: % of 5 drafts are in the state this paste left them (changed since?)', v_n;
  end if;
end
$rb_pre$;

update pipeline.uni_adapter_drafts d
   set status = 'capturing', proposals = '[]'::jsonb, updated_at = d.created_at
 where d.id in ('5c8a27a6-0ab7-4d5d-9d56-4780acb2b69f','6780a06b-0d3d-45c2-918a-e4bcc379300b',
                '957b620b-dd36-474d-af23-191ac12804c3','4563a4d7-1b08-4da8-a441-679c91a5c272',
                '6a3ee319-267b-4b42-92a8-6a603e53f3e1')
   and d.status = 'error'
   and jsonb_array_length(d.proposals) = 1
   and d.proposals->0->>'source' like 'CF-247 paste cf247-stuck-capturing-20261030%';

insert into pipeline.admin_control_events (area, action, target, detail, actor)
values ('toolsets', 'adapter_draft_close_rollback', 'cf247-stuck-capturing-20261030',
        jsonb_build_object('reason', 'Rollback of paste cf247-stuck-capturing-20261030', 'count', 5),
        '63ba56cb-48d4-4169-98c2-7c4d1f72925b'::uuid);

do $rb_post$
declare v_snap text;
begin
  select md5(string_agg(concat_ws('|', id, provider_id, status, captures::text, proposals::text,
                                  cost_usd::text, created_at::text, updated_at::text), ';' order by id))
    into v_snap
    from pipeline.uni_adapter_drafts
   where id in ('5c8a27a6-0ab7-4d5d-9d56-4780acb2b69f','6780a06b-0d3d-45c2-918a-e4bcc379300b',
                '957b620b-dd36-474d-af23-191ac12804c3','4563a4d7-1b08-4da8-a441-679c91a5c272',
                '6a3ee319-267b-4b42-92a8-6a603e53f3e1');
  if v_snap is distinct from 'b8e5c62ac9612834d8d56037b158fac4' then
    raise exception 'ROLLBACK POST-CHECK failed: snapshot md5 % does not match the original', v_snap;
  end if;
  raise notice 'Rollback complete: 5 drafts restored byte-for-byte (snapshot b8e5c62a).';
end
$rb_post$;

commit;
*/
