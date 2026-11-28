-- PASTE-20261128-s1350-dot-connector-key.sql (CF-247 s1350, S1-Build, 28 Nov 2026; Platform Admin approval 13:05 AEDT "implement a private
-- StudySearch DOT Intake API connector"). Run once in the Supabase SQL editor of project fxcwkweaxjtknorudmwp, after Pilot migration
-- 20261201080000 (s1350) is live. It (1) widens the key store's platform check from (zoho, website) to (zoho, website, dot): one constraint is
-- replaced, every existing row still passes, nothing else is removed; (2) adds DOT's connector key row NOT ISSUED (a random hash nobody holds).
-- Then issue the key on Settings > API usage (row "DOT intake connector v1", Rotate; shown once). Re-running it changes nothing.
begin;
do $g$ begin
  if (select count(*) from private.api_keys where platform not in ('zoho', 'website', 'dot')) > 0 then raise exception 'stop: an unexpected platform is already present'; end if;
  if not exists (select 1 from pipeline.api_versions where platform = 'dot' and api_version = 'v1') then raise exception 'stop: migration 20261201080000 (s1350) is not live yet'; end if;
end $g$;
alter table private.api_keys drop constraint api_keys_platform_check, add constraint api_keys_platform_check check (platform = any (array['zoho', 'website', 'dot']));
insert into private.api_keys (key_name, platform, api_version, consumer, token_sha256, enabled, rate_per_minute, note)
values ('dot_intake_connector_v1', 'dot', 'v1', 'DOT (evidence agent)',
        encode(extensions.digest(encode(extensions.gen_random_bytes(32), 'hex'), 'sha256'), 'hex'), true, 60,
        'CF-247 s1350 (28 Nov 2026): DOT''s key for the dot-intake connector. [not issued] Nobody holds this key yet: rotate it on Settings > API usage to issue it (shown once).')
on conflict (key_name) do nothing;
insert into pipeline.api_key_events (key_name, event, note)
select 'dot_intake_connector_v1', 'switched_on', 'CF-247 s1350: own key for dot v1 added (not issued)'
 where not exists (select 1 from pipeline.api_key_events where key_name = 'dot_intake_connector_v1');
do $c$ declare c jsonb := security.api_usage_coverage_v1(); begin
  if jsonb_array_length(coalesce(c->'missing_versions', '[]'::jsonb)) > 0 or jsonb_array_length(coalesce(c->'missing_keys', '[]'::jsonb)) > 0 then raise exception 'stop: API usage would miss %', c; end if;
end $c$;
commit;
-- Read back (expect one row: dot_intake_connector_v1 | dot | v1 | true):
select key_name, platform, api_version, enabled from private.api_keys where key_name = 'dot_intake_connector_v1';
