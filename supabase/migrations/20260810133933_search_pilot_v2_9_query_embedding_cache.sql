create table if not exists search_pilot.query_embedding_cache (
  cache_key text primary key,
  model text not null,
  profile_version text not null,
  embedding vector(1536) not null,
  created_at timestamptz not null default now(),
  last_used_at timestamptz not null default now(),
  hit_count bigint not null default 0,
  expires_at timestamptz not null default (now() + interval '7 days')
);

create index if not exists query_embedding_cache_expires_idx
  on search_pilot.query_embedding_cache (expires_at);

create or replace function public.query_embedding_cache_get_pilot_v2_9(
  p_cache_key text,
  p_model text,
  p_profile_version text
)
returns table(embedding vector(1536), hit_count bigint)
language plpgsql
security definer
set search_path = public, search_pilot
as $$
begin
  update search_pilot.query_embedding_cache q
     set last_used_at = now(), hit_count = q.hit_count + 1
   where q.cache_key = p_cache_key
     and q.model = p_model
     and q.profile_version = p_profile_version
     and q.expires_at > now();

  return query
  select q.embedding, q.hit_count
    from search_pilot.query_embedding_cache q
   where q.cache_key = p_cache_key
     and q.model = p_model
     and q.profile_version = p_profile_version
     and q.expires_at > now();
end;
$$;

create or replace function public.query_embedding_cache_put_pilot_v2_9(
  p_cache_key text,
  p_model text,
  p_profile_version text,
  p_embedding vector(1536),
  p_ttl_seconds integer default 604800
)
returns void
language sql
security definer
set search_path = public, search_pilot
as $$
insert into search_pilot.query_embedding_cache(cache_key, model, profile_version, embedding, expires_at)
values (
  p_cache_key,
  p_model,
  p_profile_version,
  p_embedding,
  now() + make_interval(secs => least(greatest(coalesce(p_ttl_seconds,604800),60),2592000))
)
on conflict (cache_key) do update
set model = excluded.model,
    profile_version = excluded.profile_version,
    embedding = excluded.embedding,
    created_at = now(),
    last_used_at = now(),
    hit_count = 0,
    expires_at = excluded.expires_at;
$$;

revoke all on function public.query_embedding_cache_get_pilot_v2_9(text,text,text) from public, anon, authenticated;
revoke all on function public.query_embedding_cache_put_pilot_v2_9(text,text,text,vector,integer) from public, anon, authenticated;
grant execute on function public.query_embedding_cache_get_pilot_v2_9(text,text,text) to service_role;
grant execute on function public.query_embedding_cache_put_pilot_v2_9(text,text,text,vector,integer) to service_role;
