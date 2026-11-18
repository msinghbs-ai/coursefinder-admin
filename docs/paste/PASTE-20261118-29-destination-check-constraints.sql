-- PASTE-20261118-29-destination-check-constraints.sql
-- CF-247 29-destination readiness (S2-Build; Platform Admin 18 Nov 2026 11:28). For the Platform Admin to run in the Supabase SQL editor of
-- fxcwkweaxjtknorudmwp BEFORE Thursday 19 Nov 2026 01:15 AEDT (migration freeze; the canonical squash then captures the relaxed constraints).
-- Why a paste file: relaxing a CHECK constraint drops and re-adds it, and drops go to the Platform Admin (Pilot CLAUDE.md).
--
-- Read live 18 Nov 2026 11:40 AEDT, three constraints reject valid values for destinations beyond AU, CA, GB, NZ and US:
--   1. destination.career_outcomes.occupation_scheme allows only ANZSCO, NOC and SOC. The EU, Nordic and Asian destinations publish occupations
--      in ISCO-08 / ESCO or a national scheme (Germany KldB, France ROME, Sweden SSYK, Denmark DISCO, Singapore SSOC, Malaysia MASCO,
--      Korea KSCO, Japan JSCO, Thailand TSCO).
--   2. destination.career_outcomes.state_code must match ^[A-Z]{2,3}$. ISO 3166-2 subdivision codes are numeric in Japan, Korea, Thailand,
--      Malaysia, Singapore, Poland, Finland, Denmark, Austria, Cyprus and Latvia (for example JP-13, KR-11, FI-18, LV-011).
--   3. destination.study_rules.rule_category allows application_route, visa_funds, work_rights, post_study_work, visa_fee and processing_time.
--      Health insurance (Australia OSHC; statutory cover in Germany and the Netherlands), English or language requirements and admission tests
--      (Study Square ruling of 13 Nov: admission tests as a general note) have no category. Added here; remove any you do not want before running.
-- Each constraint is replaced only if its live definition is still the one read above; the new definitions accept everything the old ones did.
-- Nothing else is changed. Read back at the end.

begin;

do $$
declare v text;
begin
  select pg_get_constraintdef(oid) into v from pg_constraint where conrelid = 'destination.career_outcomes'::regclass and conname = 'career_outcomes_occupation_scheme_check';
  if v <> 'CHECK (((occupation_scheme IS NULL) OR (occupation_scheme = ANY (ARRAY[''ANZSCO''::text, ''NOC''::text, ''SOC''::text]))))' then
    raise exception 'career_outcomes_occupation_scheme_check is not the definition read on 18 Nov: %', v;
  end if;
  select pg_get_constraintdef(oid) into v from pg_constraint where conrelid = 'destination.career_outcomes'::regclass and conname = 'career_outcomes_state_code_check';
  if v <> 'CHECK (((state_code IS NULL) OR (state_code ~ ''^[A-Z]{2,3}$''::text)))' then
    raise exception 'career_outcomes_state_code_check is not the definition read on 18 Nov: %', v;
  end if;
  select pg_get_constraintdef(oid) into v from pg_constraint where conrelid = 'destination.study_rules'::regclass and conname = 'study_rules_rule_category_check';
  if v <> 'CHECK (((rule_category IS NULL) OR (rule_category = ANY (ARRAY[''application_route''::text, ''visa_funds''::text, ''work_rights''::text, ''post_study_work''::text, ''visa_fee''::text, ''processing_time''::text]))))' then
    raise exception 'study_rules_rule_category_check is not the definition read on 18 Nov: %', v;
  end if;
end $$;

alter table destination.career_outcomes drop constraint career_outcomes_occupation_scheme_check;
alter table destination.career_outcomes add constraint career_outcomes_occupation_scheme_check
  check (occupation_scheme is null or occupation_scheme = any (array['ANZSCO','NOC','SOC','ISCO','ESCO','KLDB','ROME','SSYK','DISCO','SSOC','MASCO','KSCO','JSCO','TSCO']));

alter table destination.career_outcomes drop constraint career_outcomes_state_code_check;
alter table destination.career_outcomes add constraint career_outcomes_state_code_check
  check (state_code is null or state_code ~ '^[A-Z0-9]{1,3}$');

alter table destination.study_rules drop constraint study_rules_rule_category_check;
alter table destination.study_rules add constraint study_rules_rule_category_check
  check (rule_category is null or rule_category = any (array['application_route','visa_funds','work_rights','post_study_work','visa_fee','processing_time',
                                                             'health_insurance','language_requirement','admission_test']));

insert into pipeline.admin_control_events(area, action, target, detail, actor)
values ('destination', 'check_constraints_relaxed', '29-destination readiness',
        jsonb_build_object('paste_file', 'PASTE-20261118-29-destination-check-constraints.sql',
                           'constraints', jsonb_build_array('career_outcomes_occupation_scheme_check', 'career_outcomes_state_code_check', 'study_rules_rule_category_check')), auth.uid());

commit;

-- read back
select conrelid::regclass, conname, pg_get_constraintdef(oid)
  from pg_constraint
 where conname in ('career_outcomes_occupation_scheme_check', 'career_outcomes_state_code_check', 'study_rules_rule_category_check')
 order by 1, 2;
