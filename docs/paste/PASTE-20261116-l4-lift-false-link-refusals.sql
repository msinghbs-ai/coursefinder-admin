-- PASTE-20261116-l4-lift-false-link-refusals.sql
-- For: the Platform Admin, on Supabase project fxcwkweaxjtknorudmwp only (never coursefinder-demo).
-- Why: Platform Admin 16 Nov 2026 18:44 AEDT asked for the 73 Layer 4 live-link conflicts to be resolved against stored page evidence, with any
--      refusal deletion prepared as a paste file rather than run by an agent. 56 of the 73 were verified valid: the proposed page is already the
--      course's active official page and the stored binding check proves it is that course's page. The course-link finder's refusals of those
--      pages (pipeline.page_rejections, source binding_check) are false conflicts:
--        - 26 "another campus" refusals name the provider itself as the other campus (Durham College, University of Calgary, The University of
--          Melbourne, University of New England): a finder defect;
--        - 30 "another course's address" refusals where the page title names this exact course (ACU double degrees, Wollongong Dean's Scholar and
--          double degrees, Durham Dental Assisting, Melbourne MA, Newcastle Electrical Engineering): the address was read as a sibling course's.
--      The Layer 4 items are already closed ("Keep the page we hold", run 6 of pipeline.layer4_link_refusal_runs). The live links and the course
--      records were not changed. While these refusals stay, the finder treats each live page as refused for its course
--      (security.course_link_hold_basis_v1 route rejected; security.course_link_reactivated_v1 lists it), so it may propose other pages again.
-- What: deletes exactly 59 rows (56 courses; 3 Wollongong pages are held with and without a trailing slash). Nothing else.
-- Prepared by: S2-CF (Course Module session), 16 Nov 2026, admin report docs/platform/layer4-clearance-and-model-benchmark-2026-11-16.md section 3.5.
-- Run: paste the whole file into the SQL editor. It stops (and changes nothing) unless exactly 59 matching rows exist.

begin;

create temp table l4_lift(course_id uuid, url text) on commit drop;
insert into l4_lift(course_id, url) values
  -- ACU: Bachelor of Arts (Western Civilisation)/Master of Teaching (Secondary)
  ('562bc7e7-30da-4806-b636-fb27c32156cf'::uuid, 'https://www.acu.edu.au/course/bachelor-of-arts-western-civilisationmaster-of-teaching-secondary'),
  -- ACU: Bachelor of Arts / Bachelor of Laws
  ('435dcd5b-66ea-4ed9-ad6a-bcc09a35575d'::uuid, 'https://www.acu.edu.au/course/bachelor-of-artsbachelor-of-laws'),
  -- ACU: Bachelor of Arts/Bachelor of Business
  ('ae2c5486-48c0-4716-b3a3-4381c4bcad5a'::uuid, 'https://www.acu.edu.au/course/bachelor-of-artsbachelor-of-business'),
  -- ACU: Bachelor of Arts/Master of Teaching (Secondary)
  ('ed42675a-0fb0-45ec-b300-1e96a823f500'::uuid, 'https://www.acu.edu.au/course/bachelor-of-artsmaster-of-teaching-secondary'),
  -- ACU: Bachelor of Biomedical Science / Bachelor of Laws
  ('7420fb5c-ee9a-44cd-8260-2162089db1d2'::uuid, 'https://www.acu.edu.au/course/bachelor-of-biomedical-sciencebachelor-of-laws'),
  -- ACU: Bachelor of Computer Science/Master of Data Science
  ('82fe9631-55f7-4b72-960e-3faa4461bb42'::uuid, 'https://www.acu.edu.au/course/bachelor-of-computer-sciencemaster-of-data-science'),
  -- ACU: Bachelor of Criminology and Criminal Justice/Bachelor of Laws
  ('b7d9fe8a-cdc3-4d9c-8624-40c88b308530'::uuid, 'https://www.acu.edu.au/course/bachelor-of-criminology-and-criminal-justicebachelor-of-laws'),
  -- ACU: Bachelor of Education (Secondary)/Bachelor of Arts
  ('accca99c-c3a4-41a7-893d-fd1d50817e6b'::uuid, 'https://www.acu.edu.au/course/bachelor-of-education-secondarybachelor-of-arts'),
  -- ACU: Bachelor of Education (Secondary)/Bachelor of Arts (Design, Innovation and Technologies)
  ('19f558bf-bb02-43d2-9d0b-26eb7b6dd7b2'::uuid, 'https://www.acu.edu.au/course/bachelor-of-education-secondarybachelor-of-arts-design-innovation-and-technologies'),
  -- ACU: Bachelor of Education (Secondary)/Bachelor of Exercise Science
  ('587ccc19-652f-45d1-a460-e950c4c050a5'::uuid, 'https://www.acu.edu.au/course/bachelor-of-education-secondarybachelor-of-exercise-science'),
  -- ACU: Bachelor of Exercise and Sports Science/Bachelor of Nutrition Science
  ('a7950d66-4975-46e6-859b-876ff76e1366'::uuid, 'https://www.acu.edu.au/course/bachelor-of-exercise-and-sports-sciencebachelor-of-nutrition-science'),
  -- ACU: Bachelor of Human Rights/Bachelor of Criminology and Criminal Justice
  ('6f031dad-3c2c-4f8f-9ccb-507e7b3dc97d'::uuid, 'https://www.acu.edu.au/course/bachelor-of-human-rightsbachelor-of-criminology-and-criminal-justice'),
  -- ACU: Bachelor of Human Rights/Bachelor of Laws
  ('406fc895-0984-4c58-adaf-46ea7aed1978'::uuid, 'https://www.acu.edu.au/course/bachelor-of-human-rightsbachelor-of-laws'),
  -- ACU: Bachelor of Laws / Bachelor of Global Studies
  ('f96dba1a-4d82-42ba-b212-0740ddb5e1cf'::uuid, 'https://www.acu.edu.au/course/bachelor-of-lawsbachelor-of-global-studies'),
  -- ACU: Bachelor of Psychological Science/Bachelor of Laws
  ('9af44835-2f60-4617-a089-9fc2b30f5176'::uuid, 'https://www.acu.edu.au/course/bachelor-of-psychological-sciencebachelor-of-laws'),
  -- ACU: Bachelor of Psychological Science/Bachelor of Criminology and Criminal Justice
  ('471b567c-fe9f-41ac-a402-eccf3b36c475'::uuid, 'https://www.acu.edu.au/course/bachelor-of-psychological-sciencebachelor-of-criminology-and-criminal-justice'),
  -- ACU: Bachelor of Psychological Science/Bachelor of Exercise and Sports Science
  ('6dc1f22c-15f6-4f4a-8e30-17ce52de794a'::uuid, 'https://www.acu.edu.au/course/bachelor-of-psychological-sciencebachelor-of-exercise-and-sports-science'),
  -- ACU: Bachelor of Psychological Science/Bachelor of Nutrition Science
  ('3bfac4e3-a842-4db8-a5ee-b98505977187'::uuid, 'https://www.acu.edu.au/course/bachelor-of-psychological-sciencebachelor-of-nutrition-science'),
  -- ACU: Bachelor of Theology / Bachelor of Laws
  ('bf7af2fb-0404-4ffe-865f-9e6fdc4bfb41'::uuid, 'https://www.acu.edu.au/course/bachelor-of-theologybachelor-of-laws'),
  -- ACU: Bachelor of Theology/Bachelor of Philosophy
  ('df1cca2a-23cc-49c6-8801-669635fa6f21'::uuid, 'https://www.acu.edu.au/course/bachelor-of-theologybachelor-of-philosophy'),
  -- ACU: Bachelor of Theology/Bachelor of Global Studies
  ('c52f2c94-7c81-4ba5-b4c9-8801dabd4959'::uuid, 'https://www.acu.edu.au/course/bachelor-of-theologybachelor-of-global-studies'),
  -- Durham College: Artificial Intelligence Analysis, Design and Implementation
  ('71acde1e-8242-5360-b878-7eea7976575c'::uuid, 'https://durhamcollege.ca/programs/artificial-intelligence-analysis-design-and-implementation-graduate-certificate'),
  -- Durham College: Biomedical Engineering Technology
  ('76d5096e-5ece-5b99-a199-1dee72ff4bcc'::uuid, 'https://durhamcollege.ca/programs/biomedical-engineering-technology'),
  -- Durham College: Carpentry and Renovation Technician
  ('19ee01dd-4ddc-5fa6-bb1b-5e8a571c9368'::uuid, 'https://durhamcollege.ca/programs/carpentry-and-renovation-technician'),
  -- Durham College: Civil Engineering Technician
  ('890e5049-08e2-5754-8fb5-24fa44f80359'::uuid, 'https://durhamcollege.ca/programs/civil-engineering-technician'),
  -- Durham College: Communicative Disorders Assistant
  ('9d2a8726-6a44-5bce-bb53-6e767984fcb0'::uuid, 'https://durhamcollege.ca/programs/communicative-disorders-assistant-graduate-certificate'),
  -- Durham College: Computer Programming
  ('43cc9f4e-69ab-50a4-83bb-8aabd8ef4417'::uuid, 'https://durhamcollege.ca/programs/computer-programming-two-year'),
  -- Durham College: Computer Systems Technician
  ('e9b029c0-16e8-59e1-a0e5-45a9c72ccb0d'::uuid, 'https://durhamcollege.ca/programs/computer-systems-technician-two-year'),
  -- Durham College: Dental Assisting
  ('a73aa87b-4775-5728-92c0-87869c033a0d'::uuid, 'https://durhamcollege.ca/programs/dental-assisting-levels-i-and-ii'),
  -- Durham College: Dental Assisting (Levels I And II)
  ('dab1a1bd-3881-5581-9073-4a890dcde3a6'::uuid, 'https://durhamcollege.ca/programs/dental-assisting-levels-i-and-ii'),
  -- Durham College: Dental Hygiene
  ('e9dcf590-e999-5594-beb4-d104c57a6fdf'::uuid, 'https://durhamcollege.ca/programs/dental-hygiene'),
  -- Durham College: Early Childhood Education
  ('282f8c29-df77-5c0f-8dab-efc35b4ca629'::uuid, 'https://durhamcollege.ca/programs/early-childhood-education-ece'),
  -- Durham College: Fine Arts – Advanced
  ('aa2e6a35-49da-5bb5-bbcd-a918586678b8'::uuid, 'https://durhamcollege.ca/programs/fine-arts-advanced'),
  -- Durham College: Massage Therapy
  ('9d260411-dc32-53a9-a84f-0e560de68cf6'::uuid, 'https://durhamcollege.ca/programs/massage-therapy'),
  -- Durham College: Music Business
  ('7d74383b-e17c-5070-8e63-7619fb0aff81'::uuid, 'https://durhamcollege.ca/programs/music-business-administration'),
  -- Durham College: Pre-Health Sciences Pathway
  ('fd806fdf-a0ef-59bd-ae57-6770167d1d5d'::uuid, 'https://durhamcollege.ca/programs/pre-health-sciences-pathway-to-certificates-and-diplomas'),
  -- Durham College: Social Service Worker
  ('1fd54b22-dc8c-505b-8985-cfb67c779988'::uuid, 'https://durhamcollege.ca/programs/social-services-worker'),
  -- Durham College: Video Production
  ('8e2bf2d1-b708-5861-96d0-48667cdbf90d'::uuid, 'https://durhamcollege.ca/programs/video-production'),
  -- Melbourne: Graduate Diploma in Urban Horticulture
  ('6b1bf2ea-9fbd-4fe4-89cd-1ec5bf97027d'::uuid, 'https://study.unimelb.edu.au/find/courses/graduate/graduate-diploma-in-urban-horticulture/'),
  -- Melbourne: Master of Arts (Advanced Seminar and Shorter Thesis)
  ('ea89136a-3569-45ba-91a4-821720173f97'::uuid, 'https://study.unimelb.edu.au/find/courses/graduate/master-of-arts-advanced-seminar-shorter-thesis/'),
  -- Melbourne: Master of Dance
  ('4c6f22e0-0cb5-4aca-bbb0-620b1c2e1652'::uuid, 'https://study.unimelb.edu.au/find/courses/graduate/master-of-dance/'),
  -- Melbourne: Master of Music (Research)
  ('4a5a7ea0-edb0-4291-8bb1-a059a277d49b'::uuid, 'https://study.unimelb.edu.au/find/courses/graduate/master-of-music-research/'),
  -- Melbourne: Master of Music Therapy
  ('cfee2639-6c38-485d-873b-f934d4c08a97'::uuid, 'https://study.unimelb.edu.au/find/courses/graduate/master-of-music-therapy/'),
  -- Newcastle: Bachelor of Electrical and Electronic Engineering (Honours)
  ('b5d0f4e8-793b-4e34-8909-93b1824837eb'::uuid, 'https://www.newcastle.edu.au/degrees/bachelor-of-electrical-and-electronic-engineering-honours-mathematics'),
  -- Calgary: Bachelor of Arts Anthropology
  ('2085d8bd-9d3c-5ce3-a57f-de960a39f2f0'::uuid, 'https://www.ucalgary.ca/future-students/undergraduate/explore-programs/anthropology-arts'),
  -- Calgary: Bachelor of Arts Psychology
  ('1a2d2b8b-c03a-50ce-b7eb-d818cc0d80b7'::uuid, 'https://www.ucalgary.ca/future-students/undergraduate/explore-programs/psychology-arts'),
  -- Calgary: Bachelor of Science Archaeology
  ('08a1751e-a3b5-5e90-aa60-3968d60921fd'::uuid, 'https://www.ucalgary.ca/future-students/undergraduate/explore-programs/archaeology-science'),
  -- Calgary: Bachelor of Science Geography
  ('e81d5a1c-dbb3-50b7-902a-5be75ad2555b'::uuid, 'https://www.ucalgary.ca/future-students/undergraduate/explore-programs/geography-science'),
  -- Calgary: Bachelor of Science in Sustainable Systems Engineering
  ('7b9a125f-f9dd-55b1-85e1-6b03e6f54780'::uuid, 'https://schulich.ucalgary.ca/sustainable-systems/bsc-sustainable-systems-engineering'),
  -- UNE: Bachelor of Business
  ('4cacabf5-8925-4734-a853-fdcf88a0ab92'::uuid, 'https://www.une.edu.au/study/courses/bachelor-of-business'),
  -- Wollongong: Bachelor of Arts in Western Civilisation - Bachelor of International Studies
  ('1b2c9488-d716-479e-8fdb-ba6c2393fc86'::uuid, 'https://www.uow.edu.au/study/courses/bachelor-of-arts-in-western-civilisation---bachelor-of-int-studies'),
  -- Wollongong: same, trailing slash
  ('1b2c9488-d716-479e-8fdb-ba6c2393fc86'::uuid, 'https://www.uow.edu.au/study/courses/bachelor-of-arts-in-western-civilisation---bachelor-of-int-studies/'),
  -- Wollongong: Bachelor of Computer Science (Dean's Scholar)
  ('2f90a63f-a9a9-4f3c-a456-80fc2e4974b5'::uuid, 'https://www.uow.edu.au/study/courses/bachelor-of-computer-science-deans-scholar'),
  -- Wollongong: Bachelor of Information Technology (Dean's Scholar)
  ('d78d261c-a49a-439d-9eec-f732f2ce77cf'::uuid, 'https://www.uow.edu.au/study/courses/bachelor-of-information-technology-deans-scholar'),
  -- Wollongong: same, trailing slash
  ('d78d261c-a49a-439d-9eec-f732f2ce77cf'::uuid, 'https://www.uow.edu.au/study/courses/bachelor-of-information-technology-deans-scholar/'),
  -- Wollongong: Bachelor of Medical and Health Sciences (Honours) (Dean's Scholar)
  ('15242dcb-372f-4b16-88fb-8407f12493b4'::uuid, 'https://www.uow.edu.au/study/courses/bachelor-of-medical-and-health-sciences-honours-deans-scholar'),
  -- Wollongong: same, trailing slash
  ('15242dcb-372f-4b16-88fb-8407f12493b4'::uuid, 'https://www.uow.edu.au/study/courses/bachelor-of-medical-and-health-sciences-honours-deans-scholar/'),
  -- Wollongong: Bachelor of Science - Bachelor of Arts
  ('6bd02d3d-c659-481f-995f-5e8fcd6eebe2'::uuid, 'https://www.uow.edu.au/study/courses/bachelor-of-science-smah---bachelor-of-arts'),
  -- Wollongong: Bachelor of Science (Honours) (Dean's Scholar)
  ('73565c4e-c1f3-4a86-a61a-bc303074d98f'::uuid, 'https://www.uow.edu.au/study/courses/bachelor-of-science-honours-deans-scholar---smah');

do $c$
declare n int := (select count(*) from pipeline.page_rejections pr join l4_lift x on x.course_id = pr.course_id and x.url = pr.url where pr.source = 'binding_check');
begin
  if n <> 59 then raise exception 'expected 59 binding_check refusals to lift, found %; nothing changed', n; end if;
end $c$;

with d as (
  delete from pipeline.page_rejections pr using l4_lift x
   where x.course_id = pr.course_id and x.url = pr.url and pr.source = 'binding_check'
  returning pr.course_id, pr.url, pr.reason)
insert into pipeline.admin_control_events(area, action, target, detail, actor)
select 'layer4', 'paste', 'pipeline.page_rejections', jsonb_build_object('paste', 'PASTE-20261116-l4-lift-false-link-refusals.sql', 'deleted', count(*),
       'rows', jsonb_agg(jsonb_build_object('course_id', course_id, 'url', url, 'reason', reason))), auth.uid() from d;

select count(*) as left_over from pipeline.page_rejections pr join l4_lift x on x.course_id = pr.course_id and x.url = pr.url where pr.source = 'binding_check';  -- expect 0

commit;
