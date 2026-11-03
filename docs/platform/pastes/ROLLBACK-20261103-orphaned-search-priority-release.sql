-- ROLLBACK-20261103-orphaned-search-priority-release.sql (CF-247 workstream D): restores requested_at exactly from
-- pipeline.ops_lane_priority_snapshots for batch orphan-priority-20261103. A row whose requested_at was set again since (a newer task took
-- the course) is left as it is and listed in restore_note; every other row gets its snapshot value back whatever its state now. Count-guarded:
-- restored + left must equal the batch's unrestored rows. Nothing is deleted.
begin;
do $$
declare v_n int; v_left int; v_r int; c_batch text := 'orphan-priority-20261103';
begin
  select count(*) into v_n from pipeline.ops_lane_priority_snapshots where batch = c_batch and restored_at is null;
  if v_n = 0 then raise exception 'batch % has nothing to restore', c_batch; end if;
  update pipeline.ops_lane_priority_snapshots x set restored_at = now(), restore_note = 'left: requested_at set again since (' || s.requested_at || ')'
    from pipeline.course_link_search s where x.batch = c_batch and x.restored_at is null and s.course_id = x.course_id and s.requested_at is not null;
  get diagnostics v_left = row_count;
  update pipeline.course_link_search s set requested_at = x.requested_at
    from pipeline.ops_lane_priority_snapshots x where x.batch = c_batch and x.restored_at is null and s.course_id = x.course_id and s.requested_at is null;
  get diagnostics v_r = row_count;
  update pipeline.ops_lane_priority_snapshots set restored_at = now(), restore_note = 'restored' where batch = c_batch and restored_at is null
     and course_id in (select course_id from pipeline.course_link_search);
  if v_r + v_left <> v_n then raise exception 'count guard: % restored + % left <> % in the batch; rolled back', v_r, v_left, v_n; end if;
  insert into pipeline.admin_control_events(area, action, target, detail)
  values ('ops', 'lane_priority_restore', 'course_link_search', jsonb_build_object('batch', c_batch, 'restored', v_r, 'left_newer_task', v_left));
  raise notice 'restored % rows, left % (a newer task set them)', v_r, v_left;
end $$;
commit;
