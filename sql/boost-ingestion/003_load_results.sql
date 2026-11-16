-- CF-247 Boost ingestion, part 3: load one Worker result file into pipeline.boost_inbound_staging in ONE transaction.
--   psql "$DB_URL" -X -v ON_ERROR_STOP=1 -f sql/boost-ingestion/003_load_results.sql < result-<batch>-<offset>.ndjson
-- Idempotent: a row already loaded (same batch and item) is left as it is. Writes nothing outside the staging table; no trigger fires.
begin;
set local statement_timeout = '20s';
create temp table boost_lines (line text) on commit drop;
\copy boost_lines (line) from pstdin with (format csv, quote e'\x01', delimiter e'\x02')
with j as (select line::jsonb j from boost_lines where btrim(line) <> ''), ins as (
  insert into pipeline.boost_inbound_staging (batch_id, item_key, lane, entity, entity_id, evidence_id, source_url, provider, model, prompt_id, prompt_version,
    prompt_sha256, selector, answer, verdict, worker_status, attempts, worker_at)
  select j->>'batch_id', j->>'item_key', j->>'lane', j->>'entity', (j->>'entity_id')::uuid, nullif(j->>'evidence_id', '')::uuid, j->>'source_url',
         j->>'provider', j->>'model', j->>'prompt_id', j->>'prompt_version', j->>'prompt_sha256', j->>'selector', j->'answer', j->'verdict', j->>'status',
         coalesce(j->'attempts', '[]'::jsonb), (j->>'at')::timestamptz
  from j where j->>'kind' = 'result'
  on conflict (batch_id, item_key) do nothing
  returning 1)
select (select count(*) from j) as lines, (select count(*) from ins) as loaded;
commit;
