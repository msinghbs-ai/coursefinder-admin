-- PASTE FILE — CF-247 target route, TRANCHE 2 (Platform Admin, speed reconfiguration S4-1, 25 Oct 2026 22:05)
-- Record: docs/platform/ui-audit/2026-10-25-speed-reconfiguration.md (S4). FOR REVIEW BEFORE APPLYING.
-- Applied by: the Platform Admin, Supabase SQL editor, project fxcwkweaxjtknorudmwp.
--
-- PART A (ready): the Canadian fee-schedule gap. Seven Canadian colleges have fee-schedule pages found tonight that the fetch lane
-- turned away because they are not Firecrawl targets (recorded as "budget" — the mislabel S4-3 fixes). One named override row each
-- in pipeline.firecrawl_targets (included = true). Their failed fee pages go back to 'found' with attempts 0 (no row deleted).
-- Effect: they become targets for every Firecrawl lane (fee pages now; course search under the daily cap and per-course stops).
--
-- | # | Provider (stable key)                                   | Active courses | No international fee | Fee pages waiting |
-- |---|---------------------------------------------------------|----------------|----------------------|-------------------|
-- | 1 | Okanagan College (ca:ircc_dli:o19395299488)             | 80             | 51                   | 3                 |
-- | 2 | Selkirk College (ca:ircc_dli:o19360990072)              | 14             | 7                    | 2                 |
-- | 3 | Vancouver Community College (ca:ircc_dli:o19279717512)  | 8              | 8                    | 2                 |
-- | 4 | North Island College (ca:ircc_dli:o19301182602)         | 3              | 1                    | 2                 |
-- | 5 | Yukon University (ca:ircc_dli:o19604209351)             | 2              | 2                    | 1                 |
-- | 6 | Coast Mountain College (ca:ircc_dli:o110095977911)      | 1              | 1                    | 2                 |
-- | 7 | College of New Caledonia (ca:ircc_dli:o19360977332)     | 1              | 1                    | 2                 |
-- Totals: 109 active courses, 71 without an international fee. Fee pages re-queued: 18 (14 found tonight, all now 'failed' after
-- 3 refused tries, plus 4 older failed ones at the same providers): about 18 credits to fetch.
-- Dry run 25 Oct 22:45 (rolled back): 7 override rows, 18 fee pages back to 'found'; guards passed.
--
-- PART B (NOT YET WRITTEN, on purpose): TAFEs / wānanga / ITOs, selected from the weekly line's worst-named list (Platform Admin
-- 24 Oct standing rule and 25 Oct S4-1: "selected from the worst-named list in the weekly line, not size alone"). The weekly line runs
-- Monday 08:36 AEDT; Part B is added from its list and comes back to the Platform Admin for review then.
--
-- Count guards: exactly 7 providers found by stable key, all published and active, none already carrying an override row;
-- exactly 7 rows inserted; the fee pages re-queued are only those 7 providers' fee_schedule rows in 'failed' or 'found'.

do $p$
declare
  v_admin constant uuid := '63ba56cb-48d4-4169-98c2-7c4d1f72925b';  -- Platform Admin
  v_keys constant text[] := array['provider:ca:ircc_dli:o19395299488','provider:ca:ircc_dli:o19360990072','provider:ca:ircc_dli:o19279717512',
    'provider:ca:ircc_dli:o19301182602','provider:ca:ircc_dli:o19604209351','provider:ca:ircc_dli:o110095977911','provider:ca:ircc_dli:o19360977332'];
  v_n int; v_ins int; v_rq int;
begin
  select count(*) into v_n from catalogue.providers p
   where p.stable_key = any (v_keys) and p.publication_status = 'published' and p.lifecycle_status = 'active'
     and not exists (select 1 from pipeline.firecrawl_targets t where t.provider_id = p.id);
  if v_n <> 7 then raise exception 'count guard: expected 7 eligible providers without an override, found %', v_n; end if;
  insert into pipeline.firecrawl_targets(provider_id, included, reason, set_by, set_at)
  select p.id, true, 'Tranche 2 Part A (Platform Admin 25 Oct 2026 22:05, speed reconfiguration S4-1): Canadian fee-schedule gap; standard paths, daily cap and per-course stops', v_admin, now()
    from catalogue.providers p where p.stable_key = any (v_keys);
  get diagnostics v_ins = row_count;
  if v_ins <> 7 then raise exception 'count guard: inserted %, expected 7 (rolled back)', v_ins; end if;
  update pipeline.provider_fact_sources f set status = 'found', attempts = 0, updated_at = now(),
         parse_summary = coalesce(f.parse_summary, '{}'::jsonb) || jsonb_build_object('requeued', 'Tranche 2 Part A, 25 Oct 2026 (was refused: not a Firecrawl target)')
   where f.kind = 'fee_schedule' and f.status in ('failed', 'found')
     and f.provider_id in (select p.id from catalogue.providers p where p.stable_key = any (v_keys));
  get diagnostics v_rq = row_count;
  if v_rq > 20 then raise exception 'count guard: % fee pages to re-queue, expected 18 (rolled back)', v_rq; end if;
  raise notice 'Tranche 2 Part A: % override rows added; % fee pages re-queued; firecrawl-targets includes them within a minute', v_ins, v_rq;
end $p$;

-- Check (after a minute): select tc.name, tc.included, tc.override_reason from pipeline.firecrawl_target_cache tc
--   join pipeline.firecrawl_targets t using (provider_id) where t.reason like 'Tranche 2%' order by 1;
