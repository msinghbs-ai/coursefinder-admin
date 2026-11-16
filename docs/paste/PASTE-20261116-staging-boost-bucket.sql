-- PASTE FILE for the Platform Admin. Project fxcwkweaxjtknorudmwp ONLY (never coursefinder-demo).
-- CF-247 Boost (Platform Admin 16 Nov 2026 21:09; docs/platform/CF-WORKER-BOOST-AND-PROD-LAUNCH.md §8 step 2):
-- the PRIVATE Storage bucket staging-boost that the Boost exporter writes to (outbound/) and the Boost Worker writes results to (inbound/).
-- Idempotent: running it again changes nothing. It writes one row to storage.buckets and nothing else; no table, function, job or setting.
--
-- Service-role only: the bucket is private, and NO storage.objects policy names it, so only the service role (which bypasses RLS) can read
-- or write it. The block refuses (and rolls back) if the bucket is public or if any storage.objects policy for anon or authenticated would
-- let them reach it (a policy that names staging-boost, or one with no bucket_id condition at all).
-- outbound/ and inbound/ are path prefixes inside the bucket; Storage has no folders to create.
--
-- The same through the Storage API (service role key), if preferred:
--   curl -sS -X POST "https://fxcwkweaxjtknorudmwp.supabase.co/storage/v1/bucket" \
--     -H "Authorization: Bearer $SUPABASE_SERVICE_ROLE_KEY" -H "apikey: $SUPABASE_SERVICE_ROLE_KEY" -H "Content-Type: application/json" \
--     -d '{"id":"staging-boost","name":"staging-boost","public":false,"file_size_limit":52428800,"allowed_mime_types":["application/x-ndjson","application/json","text/plain"]}'
--   (an "already exists" answer means it is there; then run the CHECK block below on its own)
begin;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('staging-boost', 'staging-boost', false, 52428800, array['application/x-ndjson', 'application/json', 'text/plain'])
on conflict (id) do nothing;

-- CHECK
do $chk$
declare v_public boolean; v_bad text;
begin
  select public into v_public from storage.buckets where id = 'staging-boost';
  if v_public is null then raise exception 'refused: staging-boost was not created'; end if;
  if v_public then raise exception 'refused: staging-boost must be private (it is public); nothing was changed'; end if;
  select string_agg(policyname, ', ') into v_bad
    from pg_policies
   where schemaname = 'storage' and tablename = 'objects'
     and (roles && array['anon', 'authenticated', 'public']::name[])
     and (coalesce(qual, '') ~* 'staging-boost' or coalesce(with_check, '') ~* 'staging-boost'
          or (coalesce(qual, '') !~* 'bucket_id' and coalesce(with_check, '') !~* 'bucket_id'));
  if v_bad is not null then
    raise exception 'refused: storage.objects policies would let anon or authenticated reach staging-boost: %; nothing was changed', v_bad;
  end if;
  raise notice 'staging-boost: private, service role only';
end $chk$;

select id, public, file_size_limit, allowed_mime_types, created_at from storage.buckets where id = 'staging-boost';

commit;
