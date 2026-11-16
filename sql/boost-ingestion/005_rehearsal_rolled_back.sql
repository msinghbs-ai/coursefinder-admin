-- CF-247 Boost ingestion, part 5: harness point 3 and the 50-item shadow-only check, in ONE block that always rolls back.
-- Runs on the parallel test project (coursefinder-boost-test, after 001 and 002) or the local stand-in. NEVER on production.
-- It raises 'BOOST_REHEARSAL <json>' at the end, so every row it wrote is rolled back and the caller reads the result from the message
-- (the same "begin ... raise exception" pattern as the Pilot dry runs; works through psql, the Management API and execute_sql).
--   a. 1,000-row bulk load into pipeline.boost_inbound_staging in one statement, timed on the server (must be under 5 s)
--   b. 50 verified rows from four models with pipeline.boost_model_qualifications EMPTY -> a real promotion in the quiet window must admit 0
--      and leave every catalogue.courses row exactly as it was (study_load and updated_at)
--   c. the 5-case rehearsal (one model qualified inside the block): 1 admitted, 2 shadow, 2 refused; a manual lock wins; updated_at untouched
--   d. a real run outside the quiet window is refused
do $boost$
declare
  v_country uuid; v_provider uuid; v_ids uuid[]; v_t0 timestamptz; v_load numeric; v_n int;
  v_shadow jsonb; v_reh jsonb; v_win text := 'not refused'; v_changed_50 int; v_written int; v_touched int; v_lines jsonb;
begin
  -- production holds about 35,700 courses; a rebuilt test project holds none
  if (select count(*) from catalogue.courses) > 100 then raise exception 'refused: more than 100 courses, this looks like production'; end if;
  if (select count(*) from pipeline.boost_model_qualifications) <> 0 then raise exception 'refused: the qualification list is not empty'; end if;

  -- synthetic provider and 53 courses (rolled back with everything else)
  select id into v_country from ref.countries order by id limit 1;
  if v_country is null then
    insert into ref.countries (iso_alpha2, iso_alpha3, name) values ('ZZ', 'ZZZ', 'Boost rehearsal') returning id into v_country;
  end if;
  insert into catalogue.providers (id, stable_key, canonical_name, country_id) values (gen_random_uuid(), 'boost-rehearsal', 'Boost Rehearsal Institute', v_country)
    returning id into v_provider;
  insert into catalogue.courses (id, stable_key, provider_id, canonical_title, lifecycle_status, updated_at)
    select gen_random_uuid(), 'boost-rehearsal-' || g, v_provider, 'Rehearsal course ' || g, 'active', now() - interval '3 days' from generate_series(1, 53) g;
  select array_agg(id order by stable_key) into v_ids from catalogue.courses where provider_id = v_provider;
  create temp table b_before on commit drop as select id, study_load, updated_at from catalogue.courses where provider_id = v_provider;

  -- a. 1,000 rows, one statement, timed on the server
  select jsonb_agg(jsonb_build_object('item_key', 'sl-' || g, 'entity_id', gen_random_uuid())) into v_lines from generate_series(1, 1000) g;
  v_t0 := clock_timestamp();
  insert into pipeline.boost_inbound_staging (batch_id, item_key, lane, entity, entity_id, provider, model, prompt_id, prompt_version, prompt_sha256, answer, verdict, worker_status, worker_at)
  select 'bench-1000', j->>'item_key', 'study_load', 'course', (j->>'entity_id')::uuid, 'groq', 'llama-3.3-70b-versatile', 'boost-study-load', 'boost-study-load-v1', repeat('a', 64),
         '{"study_load":"full_time","quote":"3 years full-time"}'::jsonb, '{"ok":true,"problems":[],"quotes_checked":1}'::jsonb, 'verified', now()
  from jsonb_array_elements(v_lines) j;
  get diagnostics v_n = row_count;
  v_load := round(extract(epoch from clock_timestamp() - v_t0)::numeric, 3);
  if v_n <> 1000 then raise exception 'bulk load wrote % rows', v_n; end if;

  -- b. 50 verified rows, four models, nothing qualified: a real promotion in the window admits nothing
  insert into pipeline.boost_inbound_staging (batch_id, item_key, lane, entity, entity_id, provider, model, prompt_id, prompt_version, prompt_sha256, answer, verdict, worker_status, worker_at)
  select 'shadow-50', 'sl-' || g, 'study_load', 'course', v_ids[g], (array['google', 'groq', 'mistral', 'openrouter'])[1 + g % 4],
         (array['gemini-2.5-flash', 'llama-3.3-70b-versatile', 'mistral-small-latest', 'mistralai/mistral-small-3.2-24b-instruct'])[1 + g % 4],
         'boost-study-load', 'boost-study-load-v1', repeat('b', 64), '{"study_load":"both","quote":"3 years full-time or 6 years part-time"}'::jsonb,
         '{"ok":true,"problems":[],"quotes_checked":1}'::jsonb, 'verified', now()
  from generate_series(1, 50) g;
  v_shadow := security.boost_promote_v1('shadow-50', false, '2026-11-17 02:00+11');
  select count(*) into v_changed_50 from catalogue.courses c join b_before b on b.id = c.id
   where c.id = any (v_ids[1:50]) and (c.study_load is distinct from b.study_load or c.updated_at is distinct from b.updated_at);
  if coalesce((v_shadow->'by_state'->>'admitted')::int, 0) <> 0 or v_changed_50 <> 0 then
    raise exception 'shadow-only check failed: % admitted, % courses changed', v_shadow->'by_state'->>'admitted', v_changed_50;
  end if;

  -- c. the 5-case rehearsal on courses 51 to 53 (53 carries a manual lock); only groq/llama qualified, inside this block
  insert into pipeline.manual_locks (entity, entity_id, field) values ('course', v_ids[53], 'study_load');
  insert into pipeline.boost_inbound_staging (batch_id, item_key, lane, entity, entity_id, provider, model, prompt_id, prompt_version, prompt_sha256, answer, verdict, worker_status, worker_at)
  select 'rehearsal', k, lane, 'course', v_ids[n], prov, mdl, 'boost-study-load', 'boost-study-load-v1', repeat('c', 64), ans, ver, st, now()
  from (values
    ('q1', 'study_load', 51, 'groq', 'llama-3.3-70b-versatile', '{"study_load":"both","quote":"3 years full-time or 6 years part-time"}'::jsonb, '{"ok":true,"problems":[]}'::jsonb, 'verified'),
    ('q2', 'study_load', 52, 'mistral', 'mistral-small-latest', '{"study_load":"full_time","quote":"full-time"}'::jsonb, '{"ok":true,"problems":[]}'::jsonb, 'verified'),
    ('q3', 'study_load', 53, 'groq', 'llama-3.3-70b-versatile', '{"study_load":"part_time","quote":"part-time"}'::jsonb, '{"ok":true,"problems":[]}'::jsonb, 'verified'),
    ('q4', 'study_load', 52, 'groq', 'llama-3.3-70b-versatile', '{"study_load":"full_time","quote":"on the Mars campus"}'::jsonb, '{"ok":false,"problems":["quote 0 is not on the page"]}'::jsonb, 'rejected'),
    ('q5', 'aer_entry', 51, 'groq', 'llama-3.3-70b-versatile', '{"records":[]}'::jsonb, '{"ok":true,"problems":[]}'::jsonb, 'verified')
  ) v(k, lane, n, prov, mdl, ans, ver, st);
  insert into pipeline.boost_model_qualifications (lane, provider, model, reason) values ('study_load', 'groq', 'llama-3.3-70b-versatile', 'rehearsal only (rolled back)');
  v_reh := security.boost_promote_v1('rehearsal', false, '2026-11-17 02:00+11');

  -- d. outside the window
  begin
    perform security.boost_promote_v1('rehearsal', false, '2026-11-17 12:00+11');
  exception when others then
    v_win := case when sqlerrm like 'outside the Boost quiet window%' then 'refused' else 'error: ' || sqlerrm end;
  end;

  select count(*) filter (where c.study_load is distinct from b.study_load), count(*) filter (where c.updated_at is distinct from b.updated_at)
    into v_written, v_touched from catalogue.courses c join b_before b on b.id = c.id;

  raise exception 'BOOST_REHEARSAL %', jsonb_build_object(
    'bulk_1000', jsonb_build_object('rows', v_n, 'seconds', v_load, 'under_5s', v_load < 5),
    'shadow_50', jsonb_build_object('result', v_shadow, 'courses_changed', v_changed_50),
    'rehearsal', jsonb_build_object('result', v_reh, 'states', (select jsonb_object_agg(item_key, promotion_state || coalesce(' (' || promotion_note || ')', ''))
                                                                  from pipeline.boost_inbound_staging where batch_id = 'rehearsal')),
    'outside_window', v_win, 'study_load_written', v_written, 'updated_at_touched', v_touched, 'database', current_database(),
    'server_version', current_setting('server_version'));
end $boost$;
