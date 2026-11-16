-- CF-247 Boost ingestion, part 4: rehearsal. Runs the promotion on synthetic rows and ROLLS BACK. Test database only (scripts/test-boost-e2e.sh).
--   psql "$TEST_DB_URL" -v ON_ERROR_STOP=1 -f sql/boost-ingestion/004_rehearsal.sql
begin;
set local statement_timeout = '20s';
-- two courses with no study load (any two active courses of the test database), one with a manual lock on study_load
create temp table r_courses on commit drop as select id from catalogue.courses where lifecycle_status = 'active' and study_load is null order by id limit 3;
do $$ begin if (select count(*) from r_courses) < 3 then raise exception 'rehearsal needs 3 active courses without a study load'; end if; end $$;
insert into pipeline.manual_locks (entity, entity_id, field) select 'course', id, 'study_load' from r_courses order by id offset 2 limit 1;
create temp table r_before on commit drop as select id, updated_at, study_load from catalogue.courses where id in (select id from r_courses);
insert into pipeline.boost_inbound_staging (batch_id, item_key, lane, entity, entity_id, provider, model, prompt_id, prompt_version, prompt_sha256, answer, verdict, worker_status, worker_at)
select 'rehearsal', k, lane, 'course', cid, prov, mdl, 'boost-study-load', 'boost-study-load-v1', repeat('a', 64), ans, ver, st, now()
from (values
  ('q1', 'study_load', 0, 'groq', 'llama-3.3-70b-versatile', '{"study_load":"both","quote":"3 years full-time or 6 years part-time"}'::jsonb, '{"ok":true,"problems":[]}'::jsonb, 'verified'),
  ('q2', 'study_load', 1, 'mistral', 'mistral-small-latest', '{"study_load":"full_time","quote":"full-time"}'::jsonb, '{"ok":true,"problems":[]}'::jsonb, 'verified'),
  ('q3', 'study_load', 2, 'groq', 'llama-3.3-70b-versatile', '{"study_load":"part_time","quote":"part-time"}'::jsonb, '{"ok":true,"problems":[]}'::jsonb, 'verified'),
  ('q4', 'study_load', 1, 'groq', 'llama-3.3-70b-versatile', '{"study_load":"full_time","quote":"on the Mars campus"}'::jsonb, '{"ok":false,"problems":["quote 0 is not on the page"]}'::jsonb, 'rejected'),
  ('q5', 'aer_entry', 0, 'groq', 'llama-3.3-70b-versatile', '{"records":[]}'::jsonb, '{"ok":true,"problems":[]}'::jsonb, 'verified')
) v(k, lane, n, prov, mdl, ans, ver, st)
join lateral (select id cid from r_courses order by id offset v.n limit 1) c on true;
-- qualify ONLY groq/llama for study_load, inside this rolled-back transaction (a real qualification is the Platform Admin's, with a reason)
insert into pipeline.boost_model_qualifications (lane, provider, model, reason) values ('study_load', 'groq', 'llama-3.3-70b-versatile', 'rehearsal only (rolled back)');
select 'dry' as run, security.boost_promote_v1('rehearsal', true, '2026-11-17 02:00+11') as result;
do $$ begin
  perform security.boost_promote_v1('rehearsal', false, '2026-11-17 12:00+11');
  raise exception 'a real run at 12:00 Melbourne time was not refused';
exception when others then
  if sqlerrm not like 'outside the Boost quiet window%' then raise; end if;
  raise notice 'outside the quiet window: refused as expected';
end $$;
select 'real' as run, security.boost_promote_v1('rehearsal', false, '2026-11-17 02:00+11') as result;
select item_key, promotion_state, promotion_note from pipeline.boost_inbound_staging where batch_id = 'rehearsal' order by item_key;
select 'courses' as check, count(*) filter (where c.study_load is distinct from b.study_load) as study_load_written,
       count(*) filter (where c.updated_at is distinct from b.updated_at) as updated_at_touched
from catalogue.courses c join r_before b on b.id = c.id;
rollback;
