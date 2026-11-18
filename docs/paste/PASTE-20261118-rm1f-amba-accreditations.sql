-- PASTE-20261118-rm1f-amba-accreditations.sql
-- CF-247 RM1F / REQ-57 (S1-RM-Design; Platform Admin 18 Nov 2026 14:23: "Load verified AACSB, EQUIS, and AMBA accreditations into
-- catalogue.provider_accreditations matched by exact provider name/domain"; no schema change in this lane, so this is a data paste file).
-- For the Platform Admin to run in the Supabase SQL editor of fxcwkweaxjtknorudmwp. Data only: no table, column, constraint or function changes.
--
-- What it loads: the 13 AMBA-accredited schools in Australia, New Zealand and Canada, read on 18 Nov 2026 from AMBA's own list
-- (https://www.associationofmbas.com/business-schools/accreditation/accredited-schools), each matched to one active provider by its exact
-- name (UQAM by its acronym and uqam.ca). Ireland, the UK and the US have no providers in the catalogue yet, so their schools are not loaded.
--
-- Rows go in as status 'under_review'. API v3 returns only 'active' accreditations (security.provider_accreditations_v3_v1), so nothing
-- reaches the website or Zoho until the Platform Admin switches them on. Reason: no open licence was found for any of the three lists
-- (AACSB points data requests to its Master Data Use Agreement; EFMD and AMBA publish web pages without stated reuse terms). Accreditation
-- status is a public fact, but confirm the reuse position, then run the commented block at the end.
--
-- Not in this file: AACSB and EQUIS. Their official lists (aacsb.edu one page per school, efmdglobal.org EQUIS list) were not read in full
-- on 18 Nov; secondary lists were not used as sources. They follow in a second file once read from the official pages.
--
-- Guards: each provider id must still carry the name it was matched on; an existing row for the same provider, body and unit is left
-- alone (unique key uq_provider_accreditations_unit). Nothing is updated or deleted. Read back at the end.

begin;

create temp table _amba (provider_id uuid, expect_name text, unit text) on commit drop;
insert into _amba values
  ('188103a5-1aba-4f99-bd3e-0416659086d3', 'Macquarie University', 'Macquarie Business School, Macquarie University'),
  ('543b87b8-f0dd-4bc7-80d6-76252cfaabec', 'Monash University', 'Monash Business School, Monash University'),
  ('2c4f515c-c146-4e90-ba8a-294130aa1f40', 'Queensland University of Technology', 'QUT Graduate School of Business, Queensland University of Technology'),
  ('68022bdf-43e8-44b3-ac14-e9eed9f71e83', 'The University of Sydney', 'University of Sydney Business School'),
  ('229dc07d-c573-44a3-b5dc-cc423cc2c300', 'Massey University', 'Massey Business School, Massey University'),
  ('ab12c7f8-e368-453d-9dfe-4ab8bd744829', 'University of Otago', 'Otago Business School, University of Otago'),
  ('e096aba7-e1eb-4903-9a63-2bfb71e9a8b8', 'University of Auckland', 'University of Auckland Business School'),
  ('db910e88-67d1-4d2b-a65c-cea290aa0692', 'University of Canterbury', 'University of Canterbury Business School, University of Canterbury'),
  ('00e5f26c-446e-453c-a3fb-bc5239a4feec', 'University of Waikato', 'Waikato Management School, University of Waikato'),
  ('34616965-b2b7-42a7-8da7-50ffbf120958', 'Victoria University of Wellington', 'Wellington School of Business and Government, Victoria University of Wellington'),
  ('6ffcf73f-1fb9-467e-81e8-12cd9c54ac9b', 'Université du Québec à Montréal', 'École des Sciences de la Gestion, UQAM'),
  ('140703e7-5d00-4007-88d6-4084148c6736', 'École des Hautes Études Commerciales de Montréal (HEC Montréal)', 'HEC Montreal'),
  ('cffb854b-5d63-43b1-96fe-23bcd0c1917e', 'Université d’Ottawa/University of Ottawa', 'Telfer School of Management, University of Ottawa');

do $g$
declare v int;
begin
  select count(*) into v from _amba a join catalogue.providers p on p.id = a.provider_id
   where p.canonical_name = a.expect_name and coalesce(p.lifecycle_status, 'active') = 'active';
  if v <> 13 then raise exception 'guard: % of 13 providers still match their names; nothing loaded', v; end if;
end $g$;

insert into catalogue.provider_accreditations (provider_id, body_code, accredited_unit_name, status, source_url, content_hash, verified_at)
select a.provider_id, 'AMBA', a.unit, 'under_review',
       'https://www.associationofmbas.com/business-schools/accreditation/accredited-schools',
       md5('AMBA|' || a.unit || '|2026-11-18'), timestamptz '2026-11-18 14:40:00+11'
  from _amba a
 where not exists (select 1 from catalogue.provider_accreditations x
                    where x.provider_id = a.provider_id and x.body_code = 'AMBA' and coalesce(x.accredited_unit_name, '') = a.unit);

-- Read back: expect 13 AMBA rows under review (fewer only if some were already there)
select k.iso_alpha2 as country, p.canonical_name, x.accredited_unit_name, x.status
  from catalogue.provider_accreditations x join catalogue.providers p on p.id = x.provider_id join ref.countries k on k.id = p.country_id
 where x.body_code = 'AMBA' order by 1, 2;

commit;

-- After the reuse position is confirmed (Platform Admin), switch them on so API v3 returns them:
-- update catalogue.provider_accreditations set status = 'active', updated_at = now()
--  where body_code = 'AMBA' and status = 'under_review'
--    and source_url = 'https://www.associationofmbas.com/business-schools/accreditation/accredited-schools';
