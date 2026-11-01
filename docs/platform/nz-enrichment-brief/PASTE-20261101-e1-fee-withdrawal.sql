-- CF-247 decision pack E1: withdraw 41 of the 46 fees admitted on 30 Oct 2026 (L4B-20261030-0816, audit #25776-25821)
-- PASTE FILE. Not applied by any migration (Pilot CLAUDE.md: changes of this kind go to the Platform Admin as a paste file).
-- Run only after the Platform Admin approves E1 option (a) as revised on 1 Nov 2026 (decision pack E1).
-- Evidence per row: docs/platform/ui-audit/e1-fee-check-admissions-2026-10-30.csv (columns verdict_2026_11_01, evidence_check).
-- Kept, not touched here (amount printed on the stored copy): 4cef7c53, 86782081, f11e1411, 467f5d48, cf286581.
-- What it does: status 'active' -> 'inactive' with a note. Nothing is deleted. The search projection is asked to refresh.
-- Guards: exactly 41 ids; md5 of the sorted ids = 3a9fd3758f1e4f989425478265f68618; all 41 still active provider_current_tuition rows
--   carrying their 30 Oct Layer 4 note; exactly 41 rows updated. Any mismatch aborts with nothing changed.
--   Guards checked read-only on 1 Nov 2026 20:20 AEDT: 41 of 41 rows pass, md5 matches. The file was not run.
-- Rollback: PASTE-20261101-e1-fee-withdrawal-rollback.sql (same ids, inactive -> active, same guards).

begin;
do $$
declare
  v_ids uuid[] := array[
  '00bba4bb-f649-46a7-92fe-7febb78ee71a',
  '01b2b4f4-a6d9-43f9-a12c-03ca792f6ae2',
  '0633bf01-4ff2-47e4-be97-28b4c1b1c50a',
  '0fa6d6ac-a3e8-48ea-ac1a-141f9af155b4',
  '126a9683-8cc9-41eb-9741-46c7a533b9c1',
  '139af6dc-3f33-4bad-9137-747ee49c8214',
  '1535d918-75c8-42ed-ba84-4dcd33249281',
  '167cdbc3-bb0d-4ba1-bc7f-01dec9707eb5',
  '19ddd518-b681-4d56-b7f6-b557cff65d0e',
  '1a197f61-829f-4b2f-85f8-e12ed04c9049',
  '2c4ed57e-1520-4166-9088-a437049b1725',
  '2ebdd039-7b12-41d6-9c7d-34d513ecddec',
  '45478f49-3be6-4864-9394-62f37af957ad',
  '461620e9-b2f9-4af1-b5ab-cdae4fcb5651',
  '4b3adc98-8771-4dd1-8b2c-36953d6c2ff8',
  '5bcb373d-ec8e-4946-a69d-936bf3574b1b',
  '5f4046f2-d02e-487e-a5a5-592b94ce0995',
  '610101d0-8ce9-474f-89f1-f32bb6d85ac2',
  '69c632d7-885a-4aa3-9aa8-5e5399b5615f',
  '7361b16d-37e9-48c8-bc5b-952b9882107d',
  '73ba5346-df96-4318-a6c3-86115a7d5d8e',
  '7578c11f-9a48-48a6-a275-a1782e1179bb',
  '75a7872d-3f5d-4b71-a34a-d430ec3e5918',
  '7dfb2a89-0c1f-4d40-a5d9-3858144bd54b',
  '80b8369e-7e9f-41b2-a1b3-8cf0f481ed8f',
  '8ba8cfab-c578-4f39-870b-70ad3897911b',
  '95b7d1ef-fc15-4bd7-8f0e-f0d14e1c148f',
  '9762bf84-b877-4c98-8e8f-0e0e1ffbfab7',
  'aa33f6c4-b762-4d87-be7c-561d6457f1e8',
  'ab111c8c-6a21-4a3c-85bc-4f893b8fe781',
  'ab1c4f71-d15c-42fb-aa26-d2e8601f3550',
  'b94b3ee7-d3f1-42ac-a632-013f83d467bd',
  'bc994703-2c91-4129-99c4-7f19389a38ef',
  'c8a8303c-632f-4dd3-8af5-e2380854a571',
  'c938bb6f-de0d-48e9-b82d-502324ede91b',
  'cea20a13-ca75-4182-88eb-fdcce0a226b1',
  'd9220e1d-fd07-4564-bc02-7f4f19f0c9ff',
  'dc53fc11-9af9-4651-b815-857539f247d1',
  'e5494461-805f-4ae9-b9de-2283fbbcfe60',
  'e813ffd3-277c-41b5-bda9-48128bcd88ef',
  'ff93d0a3-8288-45b0-adc6-139dc2193353'
  ]::uuid[];
  v_n int; v_md5 text; v_upd int;
begin
  select count(distinct x), md5(string_agg(x::text, ',' order by x)) into v_n, v_md5 from unnest(v_ids) x;
  if v_n <> 41 or v_md5 <> '3a9fd3758f1e4f989425478265f68618' then
    raise exception 'E1 guard: expected 41 ids with md5 3a9fd375…, got % (%)', v_n, v_md5;
  end if;
  select count(*) into v_n from catalogue.course_fees f
   where f.id = any(v_ids) and f.status = 'active' and f.fee_type = 'provider_current_tuition'
     and f.notes like 'CF-247 Layer 4 human decision; review item %[L4B-20261030-0816]%';
  if v_n <> 41 then raise exception 'E1 guard: % of 41 rows are still the active 30 Oct admissions; nothing changed', v_n; end if;

  perform set_config('cf.manual_edit', 'on', true);  -- fixed: the change is a recorded human decision, not a pipeline write
  update catalogue.course_fees f
     set status = 'inactive', updated_at = now(), valid_to = current_date,
         notes = concat_ws(' | ', f.notes, 'E1 withdrawn ' || to_char(now() at time zone 'Australia/Melbourne', 'DD Mon YYYY HH24:MI') ||
                 ' AEDT: admitted by "Enter another address" on a fee check (30 Oct); stored copy does not support the fee as admitted')
   where f.id = any(v_ids) and f.status = 'active';
  get diagnostics v_upd = row_count;
  if v_upd <> 41 then raise exception 'E1 guard: updated % rows, expected 41; rolled back', v_upd; end if;

  insert into pipeline.admin_control_events(area, action, target, detail)
  values ('layer4', 'e1_fee_withdrawal', 'catalogue.course_fees',
          jsonb_build_object('count', v_upd, 'ids_md5', '3a9fd3758f1e4f989425478265f68618', 'decision_pack', 'E1', 'batch', 'L4B-20261030-0816'));
  insert into search.refresh_requests(requested_by) values ('E1 fee withdrawal (41 fees, decision pack E1)');
end $$;
-- Read-back before commit: expect 41 inactive, 5 kept active.
select status, count(*) from catalogue.course_fees where id = any(array[
  '00bba4bb-f649-46a7-92fe-7febb78ee71a',
  '01b2b4f4-a6d9-43f9-a12c-03ca792f6ae2',
  '0633bf01-4ff2-47e4-be97-28b4c1b1c50a',
  '0fa6d6ac-a3e8-48ea-ac1a-141f9af155b4',
  '126a9683-8cc9-41eb-9741-46c7a533b9c1',
  '139af6dc-3f33-4bad-9137-747ee49c8214',
  '1535d918-75c8-42ed-ba84-4dcd33249281',
  '167cdbc3-bb0d-4ba1-bc7f-01dec9707eb5',
  '19ddd518-b681-4d56-b7f6-b557cff65d0e',
  '1a197f61-829f-4b2f-85f8-e12ed04c9049',
  '2c4ed57e-1520-4166-9088-a437049b1725',
  '2ebdd039-7b12-41d6-9c7d-34d513ecddec',
  '45478f49-3be6-4864-9394-62f37af957ad',
  '461620e9-b2f9-4af1-b5ab-cdae4fcb5651',
  '4b3adc98-8771-4dd1-8b2c-36953d6c2ff8',
  '5bcb373d-ec8e-4946-a69d-936bf3574b1b',
  '5f4046f2-d02e-487e-a5a5-592b94ce0995',
  '610101d0-8ce9-474f-89f1-f32bb6d85ac2',
  '69c632d7-885a-4aa3-9aa8-5e5399b5615f',
  '7361b16d-37e9-48c8-bc5b-952b9882107d',
  '73ba5346-df96-4318-a6c3-86115a7d5d8e',
  '7578c11f-9a48-48a6-a275-a1782e1179bb',
  '75a7872d-3f5d-4b71-a34a-d430ec3e5918',
  '7dfb2a89-0c1f-4d40-a5d9-3858144bd54b',
  '80b8369e-7e9f-41b2-a1b3-8cf0f481ed8f',
  '8ba8cfab-c578-4f39-870b-70ad3897911b',
  '95b7d1ef-fc15-4bd7-8f0e-f0d14e1c148f',
  '9762bf84-b877-4c98-8e8f-0e0e1ffbfab7',
  'aa33f6c4-b762-4d87-be7c-561d6457f1e8',
  'ab111c8c-6a21-4a3c-85bc-4f893b8fe781',
  'ab1c4f71-d15c-42fb-aa26-d2e8601f3550',
  'b94b3ee7-d3f1-42ac-a632-013f83d467bd',
  'bc994703-2c91-4129-99c4-7f19389a38ef',
  'c8a8303c-632f-4dd3-8af5-e2380854a571',
  'c938bb6f-de0d-48e9-b82d-502324ede91b',
  'cea20a13-ca75-4182-88eb-fdcce0a226b1',
  'd9220e1d-fd07-4564-bc02-7f4f19f0c9ff',
  'dc53fc11-9af9-4651-b815-857539f247d1',
  'e5494461-805f-4ae9-b9de-2283fbbcfe60',
  'e813ffd3-277c-41b5-bda9-48128bcd88ef',
  'ff93d0a3-8288-45b0-adc6-139dc2193353'
  ]::uuid[]) group by status;
commit;
