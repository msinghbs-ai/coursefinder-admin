-- CourseFinder production migration 042
-- Germany Layer 1 safety gate: prevent canonical writes from the current DAAD
-- International Programmes feed until a stable non-name Provider identifier is
-- available through an approved HRK/DAAD identity mapping.
--
-- Architecture v2.9.1 is unchanged: names/titles never act as identity.

create or replace function catalogue.guard_de_daad_provider_registration()
returns trigger
language plpgsql
set search_path = catalogue, ref, pg_temp
as $$
begin
  if lower(coalesce(new.registration_scheme, '')) = 'daad'
     and exists (
       select 1
       from catalogue.providers p
       join ref.countries c on c.id = p.country_id
       where p.id = new.provider_id
         and upper(c.iso_alpha2::text) = 'DE'
     ) then
    raise exception using
      errcode = '23514',
      message = 'DE DAAD canonical APPLY blocked: DAAD programme feed does not expose a stable provider identifier; resolve sanctioned HRK/provider identity mapping before writes';
  end if;

  return new;
end
$$;

drop trigger if exists trg_guard_de_daad_provider_registration
  on catalogue.provider_registrations;

create trigger trg_guard_de_daad_provider_registration
before insert or update of registration_scheme, registration_code, provider_id
on catalogue.provider_registrations
for each row
execute function catalogue.guard_de_daad_provider_registration();

comment on function catalogue.guard_de_daad_provider_registration() is
'Phase 1 DE safety gate. Blocks registration_scheme=daad canonical Provider writes for Germany while the DAAD International Programmes feed supplies academy name only and no stable Provider identifier. Remove/supersede only after approved HRK/DAAD Provider identity mapping passes UAT.';
