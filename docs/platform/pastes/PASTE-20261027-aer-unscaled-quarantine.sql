-- PASTE FILE — AER RMIT pilot: quarantine 20 active entry-matrix rows whose bare numbers have no printed scale (CF-247)
-- For: Platform Admin, to apply by hand in the Supabase SQL editor of project fxcwkweaxjtknorudmwp (NOT coursefinder-demo). Never applied by the agent.
-- Decision: Platform Admin 27 Oct 2026 (answer at ~15:0x to the scale question): "hold every bare-number column whose scale is not printed or
-- otherwise explicitly evidenced on the official source. Do not infer or invent a generic 'points' scale. Prepare a count-guarded manual paste
-- to withdraw/quarantine the 20 affected active rows: 9 China Gao Kao and 11 Germany Abitur. Preserve their evidence and history; do not delete
-- anything. Keep China and Germany's unaffected rows active". Record: admin docs/platform/aer-v1.1-build-log.md (27 Oct, PR A).
--
-- What it does (one transaction; raises and changes nothing if the live state differs):
--   guard 1  exactly these 20 rows are active (id-list md5 d1dfa72f…): RMIT, China "Gao Kao (National College Entrance Examination, NCEE) -
--            Beijing" (9: "375"-"506", reader-labelled "points") and Germany "Abitur/Fachhochschulreife" (11: "2.0"-"6", reader-labelled
--            "points"); the official pages print no scale for either column;
--   act      the 20 rows are quarantined by the schema's own mapping (decision 7, 26 Oct 21:39): status 'unverified' with
--            provenance.aer_flag = 'quarantined' and the reason; quote, evidence, run, identity and version are kept; nothing deleted;
--   guard 2  20 quarantined; China's other 13 rows (Gao Er, Gao San) stay active; Germany has no other column, so it has 0 active rows after;
--            RMIT active rows 363 -> 343;
--   log      one admin_control_events row.
-- Re-admission: only when the applicable scale is explicitly supported by official source evidence and passes the quote, identity and review
-- gates (a new read under the PR A rule; these rows are not restored by hand).
-- Consumer API: not touched (entry-matrix tables are not in the consumer baseline).

begin;

do $paste$
declare v_ids uuid[] := array[
    '096c5a74-1bb9-4c0f-90ad-46f03cf47417','1123cacb-2fad-4169-8a48-f03a9f08775f','3c095014-dded-4222-9eaa-466e4c716ebe','51729a15-bb9d-43be-af24-72f2f967f8dd',
    '5f777f76-37ee-4c0b-a4d6-940006db2950','6a228594-3129-4afd-99d8-7def2852a7c3','6f02aa96-4c6e-455f-bc74-8a89d5f360bc','74a7b1e5-fbbf-44f5-b15a-122b9e0e188f',
    '79970382-d84d-42b4-8eff-622c564f3568','894f0125-ba87-4c5b-bb0f-4dc72099e0d4','a183d6c9-2744-4451-aa79-f1eb3e601dbc','a32ea56b-0379-4eb4-b3da-44ca5c367ab2',
    'a3a50b08-d57c-4a0d-8e60-e5e126790cc6','aa0c348a-9c96-427f-b8c4-1931ae2ce2c7','bc4600a8-de20-40e9-91dd-2a6dff62699c','c296e0ff-4430-48eb-b736-72b8b0484710',
    'c3a5df72-6b6f-48d0-83bf-d47a663bb510','d5015473-9983-41dc-99d3-d62651bb9167','d9742d09-162e-484a-b3d8-f9184fa08a3b','e76f5f68-8c5c-49d6-8f8f-553c112943a3']::uuid[];
  v_n int; v_h text;
begin
  if cardinality(v_ids) <> 20 or md5(array_to_string(array(select x::text from unnest(v_ids) x order by 1), ',')) <> 'd1dfa72f47acae5b0b042b82a19a5394' then
    raise exception 'the id list changed'; end if;
  select count(*), md5(string_agg(id::text, ',' order by id)) into v_n, v_h from catalogue.provider_entry_matrix
   where status = 'active' and provider_id = '8e1adb6c-e069-43db-9584-bd054255e702'
     and ((country_code = 'CN' and qualification_name = 'Gao Kao (National College Entrance Examination, NCEE) - Beijing')
       or (country_code = 'DE' and qualification_name = 'Abitur/Fachhochschulreife'));
  if v_n <> 20 or v_h <> 'd1dfa72f47acae5b0b042b82a19a5394' then
    raise exception 'guard 1: % active rows (md5 %), expected 20 (d1dfa72f…); nothing changed. Ask the agent to regenerate.', v_n, v_h; end if;

  update catalogue.provider_entry_matrix m set status = 'unverified', updated_at = now(),
         status_reason = 'quarantined: bare numbers with no printed scale (Platform Admin 27 Oct 2026; AER PR A rule)',
         provenance = coalesce(m.provenance, '{}'::jsonb) || jsonb_build_object('aer_flag', 'quarantined', 'aer_flag_reason', 'no printed scale', 'aer_flag_at', now())
   where m.id = any(v_ids) and m.status = 'active';
  get diagnostics v_n = row_count;
  if v_n <> 20 then raise exception 'guard 2: quarantined %, expected 20; rolled back', v_n; end if;
  select count(*) into v_n from catalogue.provider_entry_matrix where status = 'active' and provider_id = '8e1adb6c-e069-43db-9584-bd054255e702' and country_code = 'CN';
  if v_n <> 13 then raise exception 'guard 2: % China rows still active, expected 13; rolled back', v_n; end if;
  select count(*) into v_n from catalogue.provider_entry_matrix where status = 'active' and provider_id = '8e1adb6c-e069-43db-9584-bd054255e702' and country_code = 'DE';
  if v_n <> 0 then raise exception 'guard 2: % Germany rows still active, expected 0; rolled back', v_n; end if;
  select count(*) into v_n from catalogue.provider_entry_matrix where status = 'active' and provider_id = '8e1adb6c-e069-43db-9584-bd054255e702';
  if v_n <> 343 then raise exception 'guard 2: % RMIT rows active, expected 343; rolled back', v_n; end if;

  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('entry_matrix', 'quarantine_paste', 'RMIT bare-number columns with no printed scale',
          jsonb_build_object('rows', 20, 'china_gao_kao', 9, 'germany_abitur', 11, 'id_list_md5', 'd1dfa72f47acae5b0b042b82a19a5394', 'rmit_active_after', 343),
          '63ba56cb-48d4-4169-98c2-7c4d1f72925b'::uuid);
  raise notice 'quarantined 20 rows';
end $paste$;

commit;
