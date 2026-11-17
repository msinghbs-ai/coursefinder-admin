-- =====================================================================================================================================
-- RE-SEED of the Boost experiment cohort. Project coursefinder-boost-test (ucdaaqrpgcldnatavmib) ONLY; never the Pilot
-- (fxcwkweaxjtknorudmwp) and never coursefinder-demo. S2 - BOOST lane (Platform Admin 17 Nov 2026 18:02, 20:06 and 21:18).
-- When: after each rebuild of the test project (squash rehearsal Wed 18 Nov 2026 10:30 AEDT; squash window Thu 19 Nov 2026 01:30-03:30 AEDT).
-- What: 12 real providers (4 each AU, CA, NZ: the largest by course count on 17 Nov 2026) and 69 of their real course ids, 60 with no study
-- load and 9 that hold one. Only ids are real; names and titles are placeholders. Safe to run twice (on conflict do nothing).
-- It refuses to run where the catalogue already holds courses that are not this cohort (that is, on a production database).
-- After it: run the 1,000-row experiment case; expect 60 rows admitted for the 60 courses with no study load, 0 held courses changed.
-- =====================================================================================================================================
do $guard$
begin
  if exists (select 1 from catalogue.courses where stable_key not like 'boostexp:%') then
    raise exception 'Refused: this database holds real courses. Run only on coursefinder-boost-test.';
  end if;
end $guard$;

create temp table p(id uuid, cc text);
insert into p values
('22657140-1cb0-4fa7-91df-90518ea8b35b','AU'),('68022bdf-43e8-44b3-ac14-e9eed9f71e83','AU'),('543b87b8-f0dd-4bc7-80d6-76252cfaabec','AU'),('9d22a19e-c3f7-4012-b738-17bc0b481e7f','AU'),
('788d79de-d55b-435a-b649-06203f9d6b76','CA'),('175462f3-59ea-4370-9c80-e7a06b100137','CA'),('db436563-4650-4820-bd76-0695afcc953d','CA'),('98e591df-d272-481e-9054-2b85a66261be','CA'),
('e096aba7-e1eb-4903-9a63-2bfb71e9a8b8','NZ'),('db910e88-67d1-4d2b-a65c-cea290aa0692','NZ'),('00e5f26c-446e-453c-a3fb-bc5239a4feec','NZ'),('34616965-b2b7-42a7-8da7-50ffbf120958','NZ');
create temp table c(id uuid, p8 text, held int);
insert into c values
('30f349f2-ffe0-4ba1-b20a-ca22b9437dcb','00e5f26c',0),('1f4d3efb-a6fe-41f9-bc5f-21f7fc2116bf','00e5f26c',0),('b0398b23-2f69-40c7-86b1-7f2558c64d23','00e5f26c',0),('059f0499-09a4-4043-97e6-319cca27f4c9','00e5f26c',0),('f894781e-64d7-4413-a296-0cd52060312e','00e5f26c',0),('edd3b858-886b-417e-9265-8c87a5ef18be','00e5f26c',1),
('6d4de6f3-e456-58f4-9cd4-acf7bb7aa875','175462f3',0),('ef44869d-b944-5e80-b238-0f7dee89f67a','175462f3',0),('fc4eb6c1-0cb6-5644-ad92-43def287f7d2','175462f3',0),('a4a1805d-63d7-572a-9b09-53f71e40e789','175462f3',0),('f3283dd9-38e2-5026-8262-03b58ab35dfc','175462f3',0),('0593e308-dea9-5c62-a26e-a0a6aaaa67bb','175462f3',1),
('e9c8a492-c49d-4a0e-bc24-df9bdd95931f','22657140',0),('cfd11310-9d24-4ed2-8b81-86730cdf0a0a','22657140',0),('cb50a7c3-8194-4383-8cae-91a3329fa8ee','22657140',0),('f3c808d5-8fd4-4d6d-8fe5-24d1f91c4381','22657140',0),('04adf6a8-c4ad-45ca-9bdc-fa779d3bbc43','22657140',0),
('94fd8b2f-4dc6-4573-bd6f-37fe328ace4d','34616965',0),('6e24d4f4-55b2-44ff-a7a8-32fe317ff7db','34616965',0),('35f71df7-89ad-4637-afd8-1a9daa2de802','34616965',0),('958f8553-a4f2-4785-b64a-fc65888a6a1b','34616965',0),('7677ccb7-99f7-4eaf-b6ab-a5dbe7ba86e2','34616965',0),('3a52e104-845b-4583-a75d-80f100f3cbb3','34616965',1),
('c6b0f382-7bbb-451a-bfd3-89ad00591f9d','543b87b8',0),('af4c9821-adac-45e9-91cd-6002a5ce780f','543b87b8',0),('22c19503-69e6-4648-9e89-8e2ff26a1de3','543b87b8',0),('23a2393b-f541-4602-8429-903c482e6d55','543b87b8',0),('bac4ed09-706a-4419-8037-afa24e441fa4','543b87b8',0),
('cee45a2c-3dea-434c-92b2-c3bc41067f3b','68022bdf',0),('3f87e273-2a6d-4c17-8a6f-1f4363142e1e','68022bdf',0),('38554d14-7abb-4cbf-bb88-98f147242125','68022bdf',0),('d6187261-1630-4f97-be80-a54ff11ba032','68022bdf',0),('25689123-2492-420c-a3a0-4ae0ef8db9c8','68022bdf',0),('096c33d2-9c45-4ada-9cc8-c7dc1e024a3d','68022bdf',1),
('95b08196-b5f4-5d9e-a6a0-c1b9a95cbb1b','788d79de',0),('414fad31-cc1e-4782-8759-f994b68df92d','788d79de',0),('daea694a-06a4-563b-8077-c69fd192dac8','788d79de',0),('e95e47cb-7384-4108-8690-76c6b382fd12','788d79de',0),('5d7a3219-ec79-401c-b239-4a907da2295f','788d79de',0),
('88ccc657-7f9a-5389-a2a2-557a001a40e9','98e591df',0),('7b90b21c-a984-5df4-8bd0-edb98f522de1','98e591df',0),('9bb19de5-6a4f-5777-85f7-7fa5c0742c65','98e591df',0),('a44a7d6b-5cc3-5af5-816c-360ae82301f0','98e591df',0),('7862f394-6ea3-5c79-b5a9-60ccdfa6eed1','98e591df',0),('7cf2058f-e1f3-59fb-a6ff-bd2039debed2','98e591df',1),
('db9bcdd7-d3b1-40a2-af4e-172c9f4aaf1e','9d22a19e',0),('b644109c-6fb8-43bc-b12e-130331c9df45','9d22a19e',0),('fa7f39d3-8a9a-47ba-bc5e-4e6944e052de','9d22a19e',0),('5768b19a-0c19-4480-ae36-34355480d7fb','9d22a19e',0),('8e92e3fa-c846-476a-b652-38ba527e5177','9d22a19e',0),('4ddf9fcf-75ef-46fb-b7b0-323e4aef07b9','9d22a19e',1),
('f6ff1f7b-3ed3-5dee-ad6b-1a3d6504d23e','db436563',0),('49ca043b-7eaa-5816-aac1-77f28fcc37b2','db436563',0),('f2cedee6-505d-5253-bba6-1c73eaf22f53','db436563',0),('3666c57a-4c4b-5767-be14-1bb996371f72','db436563',0),('c35a1c46-f247-5e4a-9edc-790706af1a15','db436563',0),('2432d1d8-5b74-5245-9b51-cbc34393998f','db436563',1),
('ef93d63b-0891-450c-be54-d2dc78b3803a','db910e88',0),('1cc175e2-ef1c-4a09-a5ac-ad0f80575b50','db910e88',0),('6f0c731c-9829-466f-8fc1-9c7422e4849d','db910e88',0),('b1b6ce46-e740-40f1-8699-a71215692842','db910e88',0),('55a45b48-063e-46f4-a027-53a09b7be1ce','db910e88',0),('2a98cd95-ea03-45ac-aaf3-0524ce7b0962','db910e88',1),
('3b1afc1d-edd1-4009-907e-9b152a158d24','e096aba7',0),('ee3915a0-26b1-411a-8e32-0e3ecd184350','e096aba7',0),('d369cf72-b36c-45cb-936d-5fae22a41776','e096aba7',0),('6312c455-87f7-4cb0-a87f-e15d0b655850','e096aba7',0),('769a6eb7-3709-481d-8fd1-0aba54def0fd','e096aba7',0),('5153f5a3-ed75-42f5-adc5-c18ca84f2c56','e096aba7',1);

insert into pim.entity_registry (id, entity_type, stable_key) select id, 'provider', 'boostexp:provider:' || id from p on conflict do nothing;
insert into pim.entity_registry (id, entity_type, stable_key) select id, 'course', 'boostexp:course:' || id from c on conflict do nothing;
insert into catalogue.providers (id, stable_key, canonical_name, country_id)
  select p.id, 'boostexp:provider:' || p.id, 'Boost experiment provider ' || left(p.id::text, 8) || ' (' || p.cc || ')', rc.id
    from p join ref.countries rc on rc.iso_alpha2 = p.cc on conflict do nothing;
insert into catalogue.courses (id, stable_key, provider_id, canonical_title, study_load, study_load_source)
  select c.id, 'boostexp:course:' || c.id, p.id, 'Boost experiment course ' || left(c.id::text, 8),
         case when c.held = 1 then 'full_time' end, case when c.held = 1 then 'register' end
    from c join p on left(p.id::text, 8) = c.p8 on conflict do nothing;
create table if not exists public.boost_experiment_runs (id bigint generated always as identity primary key, run_label text, scenario text, batch_rows int,
  rep int, load_ms numeric, promote_ms numeric, by_state jsonb, courses_filled int, held_changed int, updated_at_changed int, at timestamptz default now());
comment on table public.boost_experiment_runs is 'S2 - BOOST experiments (test project only): one row per timed load and promotion run.';

-- expect: 12 providers, 69 courses, 60 with no study load
select (select count(*) from catalogue.providers) as providers, (select count(*) from catalogue.courses) as courses,
       (select count(*) from catalogue.courses where study_load is null) as no_study_load;
