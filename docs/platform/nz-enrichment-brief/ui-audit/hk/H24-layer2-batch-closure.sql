-- CF-247 housekeeping H24: guarded closure of the one genuinely completed Layer 2 batch that is still 'running'. Project fxcwkweaxjtknorudmwp ONLY.
-- PREPARED READ-ONLY 2 Nov 2026 11:15-11:26 AEDT. NOT RUN. The integrator runs it. Nothing is deleted.
-- Authority: Platform Admin decision pack 2 Nov 2026 10:56, Decision 6 ("H24: Prepare guarded closure of genuinely completed background batches").
-- Replaces: nothing. Retires: nothing. Existing status values only (layer2_run_batches status check: queued|running|completed|partial|failed|cancelled).
--
-- THE RULE USED IS THE PLATFORM'S OWN: public.layer2_run_batch_reconcile(uuid) (live def md5 d6891d2358457b5fac43f64d073815b1):
--   total=0 -> failed; processed<total -> running; blocked=total -> failed; blocked>0 or l3>0 -> 'partial'; else 'completed';
--   completed_at is set when processed = total. "partial" is therefore the normal FINISHED state of a batch that sent work on to Layer 3.
--
-- (A) Batch dc4fabeb-532a-4536-9cbd-50d042e09f8c - CLOSE (this file)
--   Live 2 Nov 11:15: status running, trigger schedule, idempotency_key 'coverage-sweep-l3:2026-09-29', profile 84448b19-6110-4b14-bd30-f9e383ab8cc8
--   (au-coverage-sweep-course-pages), started 29 Sep 15:02 AEDT, heartbeat_at = updated_at = 2026-10-11 21:55:27.503004+00 (12 Oct 08:55 AEDT),
--   completed_at null, target 61,211 = processed 61,211, resolved_l2 0, escalated_l3 61,211, blocked 0, vendor_units 0, vendor_cost_usd 0.
--   Items (index layer2_run_items_batch_status_idx): layer3_required 61,211; 0 queued/discovering/acquiring/extracting.
--   Under the reconcile rule this batch is 'partial' with completed_at set. It is the only queued/running batch on its profile.
--   CAUTION (read before running): this is the sweep profile's shared "open batch ... reused across days". Two live writers append to it:
--     public.svc_coverage_tuition_handoff_record(uuid,text,text,integer) (md5 963e419e1285efacb7e00edcf98f6421) and
--     public.layer3_fact_claim_service(text,integer,text,text) (md5 831241fbf4f996f85ad185e688a08739).
--   Both look up status in ('queued','running') for the profile and, if none, create a new batch under an advisory lock with key
--   'coverage-sweep-l3:<UTC date>[:<task class>]' (designed fallback; no key collision with the 29 Sep key). So after closure the next hand-off
--   opens a fresh batch: expected behaviour, not a fault. Neither writer is in git (live-only; governance gap noted in the disposition).
--   No item has been added since 12 Oct, so no work is lost: Layer 3 reads layer3_required items/handoffs, not the batch status.
--   This update deliberately does NOT call layer2_run_batch_reconcile, because that would also rewrite vendor_units/vendor_cost_usd from item sums;
--   only status and completed_at change. completed_at := heartbeat_at (the last recorded progress), not now().
--
-- (B) The 34 'partial' batches - NO CHANGE (correctly closed already). Live 2 Nov 11:15, every one has completed_at set, processed = target,
--   item status counts summing to target, 0 in-flight items, and escalated_l3 > 0, so the reconcile rule gives 'partial' for each:
--   32 have only resolved_l2 + layer3_required items; 2 also hold 1 blocked item (ed73a37e-70a9-4c59-bfeb-adbbf43e674f, a27f7ab9-3da3-46af-b680-64f27ef507d8).
--   Setting any of them to 'completed' would misstate them (work went to Layer 3), so none qualifies. Their only visible effect is a display count:
--   security.admin_layer_status_summary_compute() counts status in ('queued','running','partial') as "active_batches" (35 today).
--   That is a code fix (count partial only where completed_at is null, as layer2_run_batch_start/cancel already do), listed in the health proposal.
--   Ids (created order): eb52b6e2 fef3ab42 6abe8558 aaf5809a 3e279662 39ecbae1 ed73a37e a51a2832 97e87f8e e138028e ea5b6c92 38054e92 39326aec
--   67b20344 159c955e 352907bd 4fe4b0ac 21025aec eee74644 5b2bac73 c8a33237 74b4b16f 7f73a6fa a27f7ab9 797da1cb fc49b117 0ec8d042 3ac3d82c
--   0d2ad86f ef3b4db0 13f33fcf dbeb2d8b 9cb940ec 22e7ffac (34; 27 Aug - 29 Sep).

begin;
do $h24$
declare v_n int; v_bad int;
begin
  -- Guard 1: the batch is exactly as read on 2 Nov 11:15
  select count(*) into v_n from pipeline.layer2_run_batches
   where id = 'dc4fabeb-532a-4536-9cbd-50d042e09f8c' and status = 'running' and completed_at is null
     and target_count = 61211 and processed_count = 61211 and escalated_l3_count = 61211 and blocked_count = 0 and resolved_l2_count = 0
     and heartbeat_at = timestamptz '2026-10-11 21:55:27.503004+00' and updated_at = timestamptz '2026-10-11 21:55:27.503004+00';
  if v_n <> 1 then raise exception 'H24: batch dc4fabeb is no longer as read on 2 Nov 11:15 (it moved or was changed); stop and re-read'; end if;
  -- Guard 2: every item is finished and the item count is unchanged (keyed index on batch_id, status)
  select count(*), count(*) filter (where status in ('queued','discovering','acquiring','extracting'))
    into v_n, v_bad from pipeline.layer2_run_items where batch_id = 'dc4fabeb-532a-4536-9cbd-50d042e09f8c';
  if v_n <> 61211 or v_bad <> 0 then raise exception 'H24: items % (expected 61211), in flight % (expected 0)', v_n, v_bad; end if;
  -- Guard 3: no heartbeat within health.stuck_hours (the batch is idle, not working)
  if exists (select 1 from pipeline.layer2_run_batches where id = 'dc4fabeb-532a-4536-9cbd-50d042e09f8c'
              and heartbeat_at > now() - make_interval(hours => security.pipeline_num_v1('health.stuck_hours', 4)::int)) then
    raise exception 'H24: the batch has a recent heartbeat; stop';
  end if;

  update pipeline.layer2_run_batches
     set status = 'partial', completed_at = heartbeat_at, updated_at = now()
   where id = 'dc4fabeb-532a-4536-9cbd-50d042e09f8c' and status = 'running' and completed_at is null;
  get diagnostics v_n = row_count; if v_n <> 1 then raise exception 'H24: closed % batches, expected 1', v_n; end if;

  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('housekeeping', 'h24_layer2_batch_close', 'pipeline.layer2_run_batches',
          jsonb_build_object('batch', 'dc4fabeb-532a-4536-9cbd-50d042e09f8c', 'before', jsonb_build_object('status','running','completed_at',null,'updated_at','2026-10-11 21:55:27.503004+00'),
                             'after', jsonb_build_object('status','partial','completed_at','2026-10-11 21:55:27.503004+00'),
                             'rule', 'public.layer2_run_batch_reconcile: processed = target and escalated_l3 > 0 -> partial',
                             'partial_batches_unchanged', 34,
                             'authority', 'Platform Admin decision pack 2 Nov 2026 10:56, Decision 6 (H24)'), null);
end $h24$;

-- Read-back (expect 1 row: partial, completed_at 2026-10-11 21:55:27.503004+00, counts unchanged; and 0 queued/running batches on the profile):
select id, status, completed_at, heartbeat_at, target_count, processed_count, escalated_l3_count, vendor_units, vendor_cost_usd
  from pipeline.layer2_run_batches where id = 'dc4fabeb-532a-4536-9cbd-50d042e09f8c';
select count(*) open_on_profile from pipeline.layer2_run_batches where profile_id = '84448b19-6110-4b14-bd30-f9e383ab8cc8' and status in ('queued','running');
-- If not as expected: rollback;  otherwise: commit;
-- After commit, watch the next coverage-sweep tuition hand-off: a new batch 'coverage-sweep-l3:<date>...' appearing is expected.

-- ROLLBACK after commit (only while no new batch is open on the profile: layer2_one_active_batch_per_profile_idx allows one queued/running batch):
-- select count(*) from pipeline.layer2_run_batches where profile_id='84448b19-6110-4b14-bd30-f9e383ab8cc8' and status in ('queued','running');  -- must be 0
-- update pipeline.layer2_run_batches set status='running', completed_at=null, updated_at=timestamptz '2026-10-11 21:55:27.503004+00'
--  where id='dc4fabeb-532a-4536-9cbd-50d042e09f8c' and status='partial';  -- expect 1
-- If a new batch has opened meanwhile, do not roll back: the writers are already using the new batch, which is the designed path.
