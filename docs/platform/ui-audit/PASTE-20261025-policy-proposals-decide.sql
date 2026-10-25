-- PASTE FILE — CF-247, Layer 4 triage: decide the waiting English policy and academic calendar proposals (Platform Admin 25 Oct 2026 11:34:
-- "export the current policy proposals as a list ... and give me a count-guarded paste file that approves the ones I mark. I will approve
-- by editing the file").
-- Record: docs/platform/ui-audit/2026-10-24-layer4-parked-triage.md, section "Central policy approvals (25 Oct 2026)": rows R01-R65 there
-- carry the proposed policy, the courses each would fill and the quote from the page. Generated 25 Oct 2026 00:50 UTC (65 waiting).
-- Applied by: the Platform Admin, in the Supabase SQL editor of project fxcwkweaxjtknorudmwp.
--
-- HOW TO USE
--   1. In the list below, put 'approve' or 'reject' in the third column of each row you decide. Leave '' to leave it waiting.
--   2. Set v_expect_approve and v_expect_reject (just below) to how many rows you marked of each.
--   3. Run the whole file. It is all or nothing: if any guard or any single decision fails, nothing is decided and the message names
--      the rows to fix.
--
-- What it does: calls the same function as the screen's Approve / Reject (public.admin_provider_policy_decide), as the Platform Admin,
-- for the marked rows only (rejects first, then approves). Approving a document closes that university's other waiting documents of the
-- same kind (as on screen). Nothing is deleted; no setting, job or gate is changed.
-- What approval does to courses:
--   English: the default is written within about 10 minutes to courses with no English requirement (the "fills" number, as planned
--     24 Oct 22:xx UTC; re-worked at approval). Courses with a requirement, research degrees, double degrees and named courses are not
--     changed. A row marked BLOCKED in the record cannot be approved (most course pages disagree): the function refuses it.
--   Calendar: Intake 1/2 are written to courses with an official page and no intake (universities: undergraduate levels only) by the
--     job provider-calendar-defaults. THAT JOB IS SWITCHED OFF (last run 22 Oct 2026 11:43 UTC; INDEX decision 4), so a calendar
--     approval fills 0 courses until you switch the job on. The notice at the end says whether it is on.
--
-- Guards: decisions are only 'approve', 'reject' or ''; the marked counts match v_expect_*; every marked row is still waiting
-- (status proposed); at most one approval per university and kind; a calendar marked approve must have an Intake 1 month
-- (rows saying "no Intake 1 month found" would add nothing: reject them or leave them).

do $p$
declare
  v_expect_approve constant int := 0;   -- EDIT: number of rows marked 'approve'
  v_expect_reject  constant int := 0;   -- EDIT: number of rows marked 'reject'
  v_admin constant uuid := '63ba56cb-48d4-4169-98c2-7c4d1f72925b';  -- Platform Admin
  v_a int; v_r int; v_bad text; r record; v jsonb; v_failed text := ''; v_done text := ''; v_job boolean;
begin
  create temp table if not exists _pp_marks(ref text, id uuid, decision text);
  truncate _pp_marks;
  insert into _pp_marks(ref, id, decision) values
   ('R01', 'af62d48d-4738-4853-bcfd-c4b177f2b0a4'::uuid, '')   -- Charles Sturt University · AU · English · fills 5
  ,('R02', '19b3df33-2479-4a05-ac89-40c3e6270643'::uuid, '')   -- Deakin University (Deakin) · AU · English · fills 0
  ,('R03', '583ef052-894e-4491-8ccb-15b96094ad65'::uuid, '')   -- Edith Cowan University · AU · English · fills 1
  ,('R04', 'fc68fe15-81ad-42f4-ab8a-e0e61b770217'::uuid, '')   -- Excelsia University College · AU · English · fills 4
  ,('R05', 'eed0d521-5a7b-4f65-8eaa-fbeb66305f52'::uuid, '')   -- Taylors College Sydney · AU · English · fills 0
  ,('R06', '6bf0ea88-b07c-4a1b-94f6-0fe46471bf9b'::uuid, '')   -- Alberta University of the Arts · CA · English · fills 5
  ,('R07', 'fb0fd396-9351-49f5-81f0-004094cbf5f5'::uuid, '')   -- Algonquin College · CA · English · fills 4
  ,('R08', '77e95e3e-bcd7-4740-b7ad-ed158421b329'::uuid, '')   -- British Columbia Institute of Technology · CA · English · fills 28
  ,('R09', '3e109692-b1dd-4ab7-b3c6-47a0c23aff36'::uuid, '')   -- Olds College · CA · English · fills 1
  ,('R10', '55602cfd-f2c9-4706-993d-28ad1683ac76'::uuid, '')   -- Royal Roads University · CA · English · fills 9
  ,('R11', '70e19f28-d877-42a6-a50e-b550ac3f6347'::uuid, '')   -- Thompson Rivers University · CA · English · fills 66
  ,('R12', '7e3c9d20-b11c-4df8-85f1-47abb43c72b6'::uuid, '')   -- New Zealand Aviation Academy Limited · NZ · English · fills 0
  ,('R13', '8fd76b8c-698c-47ff-a0eb-d8c73349958a'::uuid, '')   -- Southern Institute of Technology · NZ · English · fills 0
  ,('R14', '37750352-7443-4f1f-b1de-ef0afa44e42b'::uuid, '')   -- The New Zealand Chiropractic Education Trust Board · NZ · English · fills 1
  ,('R15', 'f55a6c52-c498-46b5-bf1f-034b77e62e40'::uuid, '')   -- Toi Ohomai Institute of Technology · NZ · English · fills 15
  ,('R16', '01d457be-ba69-481a-bfa8-9159e36a9bdf'::uuid, '')   -- Whitireia and WelTec · NZ · English · fills 1
  ,('R17', '1543e9a0-ce95-41aa-ab35-ca7120158ed9'::uuid, '')   -- AIH Higher Education · AU · Calendar · fills 0
  ,('R18', '0a811d85-cdee-4f83-939a-0e5a255621df'::uuid, '')   -- Alphacrucis College · AU · Calendar · fills 6
  ,('R19', '1c7f1fdf-2a06-41c6-a64b-1853330fffdd'::uuid, '')   -- Australian College of Applied Professions, ACAP Un · AU · Calendar · fills 0
  ,('R20', '370d3c63-3c39-4d9f-b114-7ae415c85b88'::uuid, '')   -- Australian College of Applied Professions, ACAP Un · AU · Calendar · fills 0
  ,('R21', '6a72b2d2-88bd-462a-ab2c-341b203499a1'::uuid, '')   -- Charles Darwin University · AU · Calendar · fills 0
  ,('R22', 'cdfedefa-0a14-4288-a4a0-77323c07c326'::uuid, '')   -- Charles Sturt University · AU · Calendar · fills 0
  ,('R23', '9d6eccfb-c264-41b2-86c9-803acf2aeeb5'::uuid, '')   -- Deakin University (Deakin) · AU · Calendar · fills 0
  ,('R24', 'b9a73c0b-5075-4791-8f5f-2d9242f28016'::uuid, '')   -- Deakin University (Deakin) · AU · Calendar · fills 0
  ,('R25', '0f3a8e06-2f1d-4ff2-b424-d05c6dad0979'::uuid, '')   -- Edith Cowan University · AU · Calendar · fills 0
  ,('R26', '7d7ae52f-7ef0-4b3e-b8ac-aaf97405e1f4'::uuid, '')   -- Edith Cowan University · AU · Calendar · fills 0
  ,('R27', '935f6575-1137-444b-9270-1a000db3c351'::uuid, '')   -- Edith Cowan University · AU · Calendar · fills 0
  ,('R28', '82a20a7a-1916-4c8a-916d-4996f5195dc7'::uuid, '')   -- EQUALS International · AU · Calendar · fills 4
  ,('R29', '874811ec-563f-458e-b5f5-cac2029f1709'::uuid, '')   -- EQUALS International · AU · Calendar · fills 0
  ,('R30', 'b490630a-8818-4d47-a288-186eb66aa73e'::uuid, '')   -- EQUALS International · AU · Calendar · fills 0
  ,('R31', 'ec0dbcd0-73cb-4bb4-88ee-18e356fc2eea'::uuid, '')   -- Excelsia University College · AU · Calendar · fills 0
  ,('R32', '99e68070-645b-46f8-9cc8-a284fd51ea3e'::uuid, '')   -- Holmesglen, Holmesglen Institute · AU · Calendar · fills 0
  ,('R33', '041a5015-168f-4387-b0fb-31cb2198f17b'::uuid, '')   -- JMC Academy · AU · Calendar · fills 0
  ,('R34', '2eeb93f6-f684-4b03-a3f3-1daf00a8f9ec'::uuid, '')   -- JMC Academy · AU · Calendar · fills 0
  ,('R35', '2c1b833a-729d-4e62-a9b3-79fcc86160bf'::uuid, '')   -- Kaplan Business School Pty Ltd · AU · Calendar · fills 4
  ,('R36', 'c582bbb5-1d7a-4b78-aa35-43464a9eb1cd'::uuid, '')   -- Kaplan Business School Pty Ltd · AU · Calendar · fills 0
  ,('R37', '7e8f7de3-49a2-4287-9396-68cc37545d68'::uuid, '')   -- Kent Institute Australia · AU · Calendar · fills 0
  ,('R38', '9d1f6550-cfd3-4bb3-97b1-31274a0536ea'::uuid, '')   -- Kent Institute Australia · AU · Calendar · fills 0
  ,('R39', '42ed476b-2009-4ac9-82a7-401ee58cd637'::uuid, '')   -- Melbourne Polytechnic · AU · Calendar · fills 3
  ,('R40', '8f7caf33-798f-40ea-8c20-52838ca96621'::uuid, '')   -- SAE University College · AU · Calendar · fills 0
  ,('R41', 'b70124eb-7d74-4095-a5cc-20f814b08b35'::uuid, '')   -- SAE University College · AU · Calendar · fills 0
  ,('R42', '17e910b1-56bc-443a-bfca-34e0891d216b'::uuid, '')   -- Stanley College · AU · Calendar · fills 0
  ,('R43', 'c531eca8-e370-4731-a7e3-dbe1e4cb94da'::uuid, '')   -- Stanley College · AU · Calendar · fills 0
  ,('R44', 'd1690205-9261-413f-b644-14196f4bb754'::uuid, '')   -- TAFE International Western Australia · AU · Calendar · fills 0
  ,('R45', '3089db6c-69fb-4386-a209-f1e71f482eb7'::uuid, '')   -- TAFE Queensland · AU · Calendar · fills 0
  ,('R46', '3751fea8-8d78-42d2-8042-5cf80983d5b5'::uuid, '')   -- TAFE Queensland · AU · Calendar · fills 0
  ,('R47', '5633d6a8-5360-403e-bab7-24ce7e77c2de'::uuid, '')   -- The Australian College of Physical Education · AU · Calendar · fills 0
  ,('R48', '843364e9-7cbc-4bc2-a542-5e8f9460e7fb'::uuid, '')   -- The Australian College of Physical Education · AU · Calendar · fills 0
  ,('R49', '83827850-bc38-4e39-841a-6583a3299bc9'::uuid, '')   -- UNSW College · AU · Calendar · fills 0
  ,('R50', '7bf2ca8f-11dd-45ff-a88d-27dde5dc97fb'::uuid, '')   -- UTS College · AU · Calendar · fills 0
  ,('R51', '6585c2bb-e8ef-49f6-b449-fcb29eabba62'::uuid, '')   -- Victoria University · AU · Calendar · fills 0
  ,('R52', 'ceea22ed-bffb-4277-aba1-c6a0e5280f66'::uuid, '')   -- VIT (Victorian Institute of Technology) · AU · Calendar · fills 0
  ,('R53', 'f0de3c99-3022-47a8-b5a9-e823ba307262'::uuid, '')   -- Athabasca University · CA · Calendar · fills 0
  ,('R54', '44c836c3-5aa8-4b5e-b168-00d8f76a08c6'::uuid, '')   -- Humber College · CA · Calendar · fills 0
  ,('R55', 'a937a2fc-c4d8-4b72-a156-d461ec916aff'::uuid, '')   -- Niagara College Canada · CA · Calendar · fills 0
  ,('R56', 'a2e15bb1-9438-4755-8dbf-ea8984a2084e'::uuid, '')   -- University of Lethbridge · CA · Calendar · fills 0
  ,('R57', 'e8ecc463-ba95-4279-9914-a0caaefbc089'::uuid, '')   -- University of Northern British Columbia · CA · Calendar · fills 0
  ,('R58', 'a3e262df-0a47-4d58-ad39-7348c51216e0'::uuid, '')   -- University of the Fraser Valley · CA · Calendar · fills 0
  ,('R59', '1be2ae79-4bbf-4587-9163-df81f5f61579'::uuid, '')   -- Auckland University of Technology · NZ · Calendar · fills 10
  ,('R60', '1a713574-ca21-4bd8-bab5-68d9424c0226'::uuid, '')   -- Eastern Institute of Technology · NZ · Calendar · fills 0
  ,('R61', '3e46d516-702a-46c7-bed7-b4d0ac581f54'::uuid, '')   -- Nelson Marlborough Institute of Technology (NMIT) · NZ · Calendar · fills 7
  ,('R62', '8e59c178-9ab7-4002-98ef-2e3a4c2ec05b'::uuid, '')   -- Otago Polytechnic · NZ · Calendar · fills 0
  ,('R63', '486f6992-6478-4416-8b6c-ed8a230ceb9f'::uuid, '')   -- University of Waikato · NZ · Calendar · fills 0
  ,('R64', 'bb8d01db-8bd4-4264-8e1f-bd2b32b1adf0'::uuid, '')   -- Victoria University of Wellington · NZ · Calendar · fills 2
  ,('R65', '7f4db07f-87f2-4b1c-9bef-e4c5f1260ae5'::uuid, '')   -- Western Institute of Technology at Taranaki (WITT) · NZ · Calendar · fills 6
  ;

  select string_agg(ref || ' (' || quote_literal(decision) || ')', ', ') into v_bad from _pp_marks where decision not in ('', 'approve', 'reject');
  if v_bad is not null then raise exception 'decision must be ''approve'', ''reject'' or '''': %', v_bad; end if;
  select count(*) filter (where decision = 'approve'), count(*) filter (where decision = 'reject') into v_a, v_r from _pp_marks;
  if v_a + v_r = 0 then raise exception 'nothing marked: put ''approve'' or ''reject'' in the third column of the rows you decide'; end if;
  if v_a <> v_expect_approve or v_r <> v_expect_reject then
    raise exception 'count guard: marked % approve and % reject, but v_expect_approve = % and v_expect_reject = %', v_a, v_r, v_expect_approve, v_expect_reject;
  end if;
  select string_agg(m.ref || ' (' || coalesce(x.status, 'not found') || ')', ', ') into v_bad
    from _pp_marks m left join pipeline.provider_policy_proposals x on x.id = m.id
   where m.decision <> '' and coalesce(x.status, '') <> 'proposed';
  if v_bad is not null then raise exception 'no longer waiting (decided since the list was made): % — set these to ''''', v_bad; end if;
  select string_agg(refs, '; ') into v_bad from (
    select string_agg(m.ref, ' + ') refs from _pp_marks m join pipeline.provider_policy_proposals x on x.id = m.id
     where m.decision = 'approve' group by x.provider_id, x.kind having count(*) > 1) d;
  if v_bad is not null then raise exception 'one approval per university and kind (approving one closes the others): % — keep one', v_bad; end if;
  select string_agg(m.ref, ', ') into v_bad
    from _pp_marks m join pipeline.provider_policy_proposals x on x.id = m.id
   where m.decision = 'approve' and x.kind = 'intake_calendar'
     and not exists (select 1 from jsonb_array_elements(coalesce(x.proposal->'periods', '[]')) e
                      where e->>'period' in ('trimester 1', 'semester 1', 'term 1', 'session 1', 'study_period 1', 'teaching_period 1')
                        and jsonb_typeof(e->'months') = 'array' and jsonb_array_length(e->'months') >= 1);
  if v_bad is not null then raise exception 'calendar with no Intake 1 month, approving adds nothing: % — reject or leave', v_bad; end if;

  perform set_config('request.jwt.claims', json_build_object('sub', v_admin, 'role', 'authenticated')::text, true);
  perform set_config('request.jwt.claim.sub', v_admin::text, true);
  for r in select m.* from _pp_marks m where m.decision <> '' order by (m.decision = 'approve'), m.ref loop
    begin
      v := public.admin_provider_policy_decide(r.id, r.decision, 'Layer 4 triage paste file 25 Oct 2026 (' || r.ref || ')');
      v_done := v_done || r.ref || ' ' || r.decision || coalesce(' fills ' || (v->>'to_fill'), ' answers ' || (v->>'to_answer') || ' waiting intake reviews', '') || '; ';
    exception when others then v_failed := v_failed || r.ref || ': ' || sqlerrm || '; ';
    end;
  end loop;
  if v_failed <> '' then raise exception 'not applied (rolled back, nothing decided): % — set these rows to '''' and run again', v_failed; end if;
  select coalesce(bool_or(active), false) into v_job from cron.job where jobname = 'provider-calendar-defaults';
  raise notice 'Decided % approve, % reject: %. Calendar defaults job provider-calendar-defaults is %.', v_a, v_r, v_done,
    case when v_job then 'ON (approved calendars fill courses within 10 minutes)' else 'OFF (approved calendars fill no course until it is switched on)' end;
  drop table _pp_marks;
end $p$;

-- Check afterwards:
-- select x.status, x.kind, count(*) from pipeline.provider_policy_proposals x
--  where x.decision_note like 'Layer 4 triage paste file 25 Oct 2026%' group by 1, 2;
