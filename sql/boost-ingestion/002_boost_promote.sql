-- CF-247 Boost ingestion, part 2: promotion (DRAFT for a Pilot migration; NOT applied to fxcwkweaxjtknorudmwp by this change).
-- Replaces: nothing
-- Retires: nothing
-- G1: no new job. G2: window and batch size from settings (001). G3: no consumer API object is changed; study_load is an API v3 column (open to
-- additions until v3 go-live, Decision 277) and is written only where it is null, without touching updated_at, so the v2 sync deltas do not move.
--
-- security.boost_promote_v1(p_batch, p_dry, p_now): settles up to boost.promote_rows_per_run staged rows of one batch, in one transaction.
--   worker_status not 'verified'                     -> refused  (the worker's own checks failed; its problems are the note)
--   lane aer_entry                                  -> shadow   (AER v1 is frozen; AER v2 admits only through its own rule after qualification)
--   (lane, provider, model) not qualified            -> shadow   (pipeline.boost_model_qualifications is empty until the Platform Admin qualifies one)
--   study_load, qualified, course study_load null,
--     no manual lock on study_load                   -> admitted (study_load, study_load_source provider_page, study_load_evidence_id; updated_at untouched)
--   study_load, qualified, value already held or locked -> refused (never overwrites; a manual lock always wins)
--   provider_accreditations, qualified              -> proposed (D-3: a page reading is checked against the body's official list first; PR C owns that)
--   course_description, course_fees, qualified      -> proposed (each lane's own admission rule decides: course_description_check_v1, the fee reader)
-- Outside the quiet window (Melbourne time, settings) a real run is refused; a dry run reports what it would do and changes nothing.

create or replace function security.boost_promote_v1(p_batch text, p_dry boolean default true, p_now timestamptz default now())
returns jsonb language plpgsql security definer set search_path to '' as $function$
declare
  v_start int := security.pipeline_num_v1('boost.quiet_window_start_hour', 1)::int;
  v_end   int := security.pipeline_num_v1('boost.quiet_window_end_hour', 5)::int;
  v_rows  int := security.pipeline_num_v1('boost.promote_rows_per_run', 1000)::int;
  v_hour  int := extract(hour from (p_now at time zone 'Australia/Melbourne'))::int;
  v_out   jsonb;
begin
  if current_user <> 'postgres' and coalesce(auth.role(), '') <> 'service_role' and security.current_role_rank() < 6 then
    raise exception 'Platform Admin or service role required';
  end if;
  if not p_dry and not (v_hour >= v_start and v_hour < v_end) then
    raise exception 'outside the Boost quiet window (% to % Melbourne time; now %)', v_start, v_end, v_hour;
  end if;
  perform pg_advisory_xact_lock(hashtext('cf247:boost_promote'));

  create temp table if not exists cf_boost_plan (id bigint primary key, lane text, entity_id uuid, evidence_id uuid, answer jsonb,
    state text, note text) on commit drop;
  truncate cf_boost_plan;

  insert into cf_boost_plan (id, lane, entity_id, evidence_id, answer, state, note)
  select s.id, s.lane, s.entity_id, s.evidence_id, s.answer,
    case
      when s.worker_status <> 'verified' then 'refused'
      when s.lane = 'aer_entry' then 'shadow'
      when q.model is null then 'shadow'
      when s.lane = 'study_load' and (c.study_load is not null
           or exists (select 1 from pipeline.manual_locks l where l.entity = 'course' and l.entity_id = s.entity_id and l.field in ('study_load', 'study_load_source', 'study_load_evidence_id')))
        then 'refused'
      when s.lane = 'study_load' and s.answer->>'study_load' is null then 'refused'
      when s.lane = 'study_load' then 'admitted'
      else 'proposed' end,
    case
      when s.worker_status <> 'verified' then 'worker: ' || coalesce((select string_agg(x, '; ') from jsonb_array_elements_text(s.verdict->'problems') x), s.worker_status)
      when s.lane = 'aer_entry' then 'AER shadow reading (admitted only by the AER rule after qualification)'
      when q.model is null then 'model not qualified for this lane: ' || coalesce(s.provider, '?') || ' / ' || coalesce(s.model, '?')
      when s.lane = 'study_load' and c.study_load is not null then 'course already holds a study load'
      when s.lane = 'study_load' and exists (select 1 from pipeline.manual_locks l where l.entity = 'course' and l.entity_id = s.entity_id
           and l.field in ('study_load', 'study_load_source', 'study_load_evidence_id')) then 'a manual lock holds this course''s study load'
      when s.lane = 'study_load' and s.answer->>'study_load' is null then 'page does not state a study load'
      when s.lane = 'study_load' then null
      when s.lane = 'provider_accreditations' then 'check against the body''s official list (D-3, PR C)'
      else 'for the lane''s own admission rule' end
  from pipeline.boost_inbound_staging s
  left join pipeline.boost_model_qualifications q on q.lane = s.lane and q.provider = s.provider and q.model = s.model
  left join catalogue.courses c on s.lane = 'study_load' and c.id = s.entity_id
  where s.batch_id = p_batch and s.promotion_state = 'staged'
  order by s.id
  limit v_rows;

  if not p_dry then
    -- study_load: only where null, one row per course (the earliest verified row of the batch), updated_at not touched
    update catalogue.courses c
       set study_load = p.answer->>'study_load', study_load_source = 'provider_page', study_load_evidence_id = p.evidence_id
      from (select distinct on (entity_id) * from cf_boost_plan where state = 'admitted' order by entity_id, id) p
     where c.id = p.entity_id and c.study_load is null;
    update pipeline.boost_inbound_staging s set promotion_state = p.state, promotion_note = p.note, promoted_at = p_now
      from cf_boost_plan p where s.id = p.id;
  end if;

  select jsonb_build_object('batch', p_batch, 'dry', p_dry, 'melbourne_hour', v_hour, 'window', jsonb_build_array(v_start, v_end),
           'rows', coalesce(sum(n), 0), 'by_state', coalesce(jsonb_object_agg(state, n) filter (where state is not null), '{}'::jsonb))
    into v_out
    from (select state, count(*) n from cf_boost_plan group by state) x;
  return v_out;
end $function$;
revoke all on function security.boost_promote_v1(text, boolean, timestamptz) from public, anon, authenticated;
comment on function security.boost_promote_v1(text, boolean, timestamptz) is
  'CF-247 Boost: settles staged Boost rows of one batch in one transaction (quiet window, settings boost.*). Admits only study_load from qualified models '
  'where the course has none and no manual lock; proposes the other lanes to their own rules; keeps AER and unqualified models as shadow readings.';
