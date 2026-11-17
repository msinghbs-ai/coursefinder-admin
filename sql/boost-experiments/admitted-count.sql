-- S2 - BOOST experiment: load and promotion on the Boost test project (coursefinder-boost-test ONLY; run by .github/workflows/boost-test-experiment.yml,
-- which refuses any other project). Needs the cohort of docs/paste/boost-test-reseed.sql. {{RUN_LABEL}} is replaced by the workflow.
-- What it does: for batches of 50, 1,000 and 5,000 synthetic worker rows over the 69 cohort courses (three times each, one model qualified for
-- study_load in the test only), it times the staging insert and security.boost_promote_v1 and records the outcome in public.boost_experiment_runs.
-- It also runs one 1,000-row batch with nothing qualified (shadow isolation). The test qualification row is removed and the cohort put back.
-- Expect (Platform Admin 17 Nov 2026 21:18, decision 5): admitted rows = courses filled; 60 admitted for the 60 courses with no study load.
update pipeline.platform_toolset_settings set value = to_jsonb(5000) where toolset_key = 'pipeline' and key = 'boost.promote_rows_per_run';
do $x$
declare
  v_label text := '{{RUN_LABEL}}'; v_sc text; v_sizes int[]; v_n int; v_rep int; v_batch text;
  t0 timestamptz; t1 timestamptz; t2 timestamptz; v_out jsonb; v_filled int; v_held int; v_upd int;
begin
  create temp table cohort on commit drop as
    select id, study_load as base_load, updated_at as base_upd, row_number() over (order by id) - 1 as k from catalogue.courses where stable_key like 'boostexp:%';
  if (select count(*) from cohort) <> 69 then raise exception 'the cohort is not seeded (69 courses expected, % found)', (select count(*) from cohort); end if;
  delete from public.boost_experiment_runs where run_label = v_label;
  foreach v_sc in array array['shadow', 'qualified'] loop
    delete from pipeline.boost_model_qualifications;
    v_sizes := case when v_sc = 'shadow' then array[1000] else array[50, 1000, 5000] end;
    if v_sc = 'qualified' then
      insert into pipeline.boost_model_qualifications (lane, provider, model, qualified_by, qualified_at, reason)
      values ('study_load', 'experiment', 'synthetic-a', null, now(), 'S2 - BOOST experiment on the test project only; synthetic worker output');
    end if;
    foreach v_n in array v_sizes loop
      for v_rep in 1..3 loop
        v_batch := format('%s-%s-%s-%s', v_label, v_sc, v_n, v_rep);
        delete from pipeline.boost_inbound_staging where batch_id = v_batch;
        update catalogue.courses c set study_load = h.base_load, study_load_source = case when h.base_load is null then null else 'register' end,
               study_load_evidence_id = null, updated_at = h.base_upd
          from cohort h where h.id = c.id and (c.study_load is distinct from h.base_load);
        t0 := clock_timestamp();
        insert into pipeline.boost_inbound_staging (batch_id, item_key, lane, entity, entity_id, source_url, provider, model, prompt_id, prompt_version,
          prompt_sha256, answer, verdict, worker_status, attempts, worker_at)
        select v_batch, 'item-' || i,
               (array['study_load','study_load','study_load','study_load','study_load','study_load','study_load','course_fees','aer_entry','course_description'])[(i % 10) + 1],
               'course', h.id, 'https://example.org/boostexp/' || i, 'experiment', case when i % 4 = 3 then 'synthetic-b' else 'synthetic-a' end,
               'exp', '1', repeat('0', 64),
               case when (i % 10) < 7 then jsonb_build_object('study_load', case when (i / 10) % 10 = 9 then null else (array['full_time','part_time','both'])[(i % 3) + 1] end)
                    else jsonb_build_object('value', i) end,
               case when i % 25 < 20 then '{"problems": []}'::jsonb else '{"problems": ["quote not found on page"]}'::jsonb end,
               case when i % 25 < 20 then 'verified' when i % 25 < 23 then 'rejected' else 'failed' end, '[]'::jsonb, now()
          from generate_series(1, v_n) i join cohort h on h.k = i % (select count(*) from cohort);
        t1 := clock_timestamp();
        v_out := security.boost_promote_v1(v_batch, false, '2026-11-18 02:00+11'::timestamptz);
        t2 := clock_timestamp();
        select count(*) filter (where h.base_load is null and c.study_load is not null),
               count(*) filter (where h.base_load is not null and c.study_load is distinct from h.base_load),
               count(*) filter (where c.updated_at is distinct from h.base_upd)
          into v_filled, v_held, v_upd from catalogue.courses c join cohort h on h.id = c.id;
        insert into public.boost_experiment_runs (run_label, scenario, batch_rows, rep, load_ms, promote_ms, by_state, courses_filled, held_changed, updated_at_changed)
        values (v_label, v_sc, v_n, v_rep, extract(epoch from t1 - t0) * 1000, extract(epoch from t2 - t1) * 1000, v_out->'by_state', v_filled, v_held, v_upd);
      end loop;
    end loop;
  end loop;
  delete from pipeline.boost_model_qualifications;
  update catalogue.courses c set study_load = h.base_load, study_load_source = case when h.base_load is null then null else 'register' end,
         study_load_evidence_id = null, updated_at = h.base_upd
    from cohort h where h.id = c.id and (c.study_load is distinct from h.base_load);
end $x$;
select json_build_object(
  'label', '{{RUN_LABEL}}',
  'promote_md5', md5(pg_get_functiondef('security.boost_promote_v1(text,boolean,timestamptz)'::regprocedure)),
  'quals_after', (select count(*) from pipeline.boost_model_qualifications),
  'no_study_load_after', (select count(*) from catalogue.courses where study_load is null),
  'duplicate_rows_refused', (select count(*) from pipeline.boost_inbound_staging where batch_id like '{{RUN_LABEL}}-%' and promotion_note like 'an earlier row of this batch%'),
  'g3', security.consumer_api_check_v1(),
  'cases', (select json_agg(x order by x.scenario, x.batch_rows) from (
     select scenario, batch_rows, count(*) reps,
            round((percentile_cont(0.5) within group (order by load_ms))::numeric, 1) load_ms,
            round((percentile_cont(0.5) within group (order by promote_ms))::numeric, 1) promote_ms,
            round(max(promote_ms), 1) promote_ms_max,
            round(batch_rows / nullif((percentile_cont(0.5) within group (order by load_ms + promote_ms))::numeric / 1000, 0)) rows_per_sec,
            min(coalesce((by_state->>'admitted')::int, 0)) admitted_min, max(coalesce((by_state->>'admitted')::int, 0)) admitted_max,
            min(courses_filled) filled_min, max(courses_filled) filled_max, max(held_changed) held_changed, max(updated_at_changed) updated_at_changed,
            min(by_state::text) by_state
       from public.boost_experiment_runs where run_label = '{{RUN_LABEL}}' group by 1, 2) x)) as r;
