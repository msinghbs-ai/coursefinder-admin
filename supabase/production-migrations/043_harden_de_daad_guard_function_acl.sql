-- CourseFinder production migration 043
-- Restrict the DE DAAD canonical identity guard function to service-side roles.

revoke all on function catalogue.guard_de_daad_provider_registration()
from public, anon, authenticated;

grant execute on function catalogue.guard_de_daad_provider_registration()
to postgres, service_role;
