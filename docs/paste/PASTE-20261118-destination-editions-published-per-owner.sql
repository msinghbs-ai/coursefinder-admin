-- PASTE-20261118-destination-editions-published-per-owner.sql (18 Nov 2026 15:05 AEDT, S2-Build; Platform Admin 18 Nov 2026 13:07 and 14:23)
-- For the Platform Admin to run in the Supabase SQL editor of fxcwkweaxjtknorudmwp (before Thursday 19 Nov 2026 01:15 AEDT is best, so the
-- squash captures it). Why a paste file: replacing an index drops it, and drops go to the Platform Admin (the deploy refuses them).
--
-- Read live 18 Nov 2026 14:42 AEDT: destination.editions has uq_destination_editions_single_published on (country_id, domain) where status is
-- published, so Australia can have only one published city_profiles edition. ABS Regional population 2024-25 holds it; the BOM Climate
-- statistics edition (terms approved, 40 figures) cannot be published beside it, and the hourly job destination-open-licence-publish records
-- "waiting" (Pilot #1287). Publishing already replaces only the same owner's edition (Pilot #1275).
-- This makes the rule one published edition per country, domain and source owner: the new index is created first, then the old one dropped.
-- Nothing else changes; no row is touched. After it, the next hourly run (minute 41) publishes the BOM edition.

begin;

do $$
begin
  if pg_get_indexdef('destination.uq_destination_editions_single_published'::regclass)
     <> 'CREATE UNIQUE INDEX uq_destination_editions_single_published ON destination.editions USING btree (country_id, domain) WHERE (status = ''published''::text)' then
    raise exception 'uq_destination_editions_single_published is not the definition read on 18 Nov';
  end if;
end $$;

create unique index uq_destination_editions_published_per_owner on destination.editions (country_id, domain, source_owner) where status = 'published';
comment on index destination.uq_destination_editions_published_per_owner is
  'CF-247 18 Nov 2026 (Platform Admin): one published edition per country, domain and source owner (ABS population and BOM climate are both city_profiles).';
drop index destination.uq_destination_editions_single_published;

insert into pipeline.admin_control_events(area, action, target, detail, actor)
values ('destination', 'edition_index_replaced', 'destination.editions',
        jsonb_build_object('paste_file', 'PASTE-20261118-destination-editions-published-per-owner.sql',
                           'old', 'uq_destination_editions_single_published (country_id, domain)', 'new', 'uq_destination_editions_published_per_owner (country_id, domain, source_owner)'),
        auth.uid());

commit;

-- read back
select indexrelid::regclass, pg_get_indexdef(indexrelid) from pg_index where indrelid = 'destination.editions'::regclass and indisunique;
select (select count(*) from security.consumer_api_functions_v1()) consumer_functions, (select count(*) from security.consumer_api_relations_v1()) consumer_relations; -- expect 75 and 48
