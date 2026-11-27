-- DOT Batch 07 (Admin #1327, #1329): seven AU scholarship value and scope corrections.
-- Prepared by S1-Scholarship-Claude; corrected and rehearsed by S1-Build, 28 Nov 2026 07:40 AEDT (SS-Programme-Control 07:21 P0).
-- WHO RUNS IT: the Platform Admin, in the SQL editor, as one paste (it deletes five mis-classified tier rows, so it cannot be a migration).
-- What it does:
--   * each award is changed only from its exact wrong state; an already-corrected award is skipped; any other state stops the whole paste;
--   * only the threshold tiers are removed (code AND value matched, exact counts checked); the real benefit tiers stay
--     (Deakin Merit 20%, Deakin Excellence 25%, Bond 25%); Deakin VC gains its 50% and 100% outcome tiers;
--   * eligibility thresholds are kept as criteria (Bond CPA 85; Griffith GUIPRS sponsor living support AUD 36,000 a year);
--   * Griffith GUIPRS: full tuition fee offset, up to 3 years FTE doctoral (+6 months possible) or 2 years research masters, OSHC and SSAF
--     (official page, checked 28 Nov 2026); Curtin keeps its 4-year undergraduate and 2-year Masters by Coursework caps, WA campus, 2027 or 2028;
--   * stops if any award, tier or criterion is under a manual lock, or if Griffith International Academic Merit is not withdrawn (it stays withdrawn);
--   * checks lifecycle and publication status are unchanged, refreshes the course savings and writes one pipeline.admin_control_events row.
-- Rehearsed rolled back twice in one transaction (live, 28 Nov 2026 07:35): run 1 applied all seven, run 2 changed nothing; audit rows 1.
-- Course savings (rehearsal): Deakin Merit 244 award_not_structured -> calculated; Bond 69 -> calculated; Griffith GUIPRS +10 calculated;
--   Deakin VC 213 award_scope_unresolved -> award_not_structured (outcome-dependent tier, no saving claimed); Curtin 14 and Griffith Merit 10 unchanged.
-- Replaces: the earlier version of this file (md5 dcff155bda1d17259643e0410500a36c), whose tier deletes and inserts were not guarded by value or count.
begin;

set local lock_timeout = '5s';

create temp table if not exists b07_before on commit drop as
select s.id, s.lifecycle_status, s.publication_status from scholarship.scholarships s
 where s.id in ('cb5ca7fc-377e-5755-add3-caeef7e89fd2','0c491130-f85e-572a-a1f2-60d59b1c6580','02a97aaf-a9b8-5076-aa2f-8dee0fa80487',
                '0eda3e72-f897-50fc-aebb-ad0ed84edee7','b183651c-b74b-5da2-acb8-6e070f929027','b9e31f81-2a5b-5131-ae7d-5afe18f1f5fb',
                'c255cd55-a6fb-5c6f-a213-83518a41fd93');

do $b07$
declare
  v_ids uuid[] := array['cb5ca7fc-377e-5755-add3-caeef7e89fd2','0c491130-f85e-572a-a1f2-60d59b1c6580','02a97aaf-a9b8-5076-aa2f-8dee0fa80487',
                        '0eda3e72-f897-50fc-aebb-ad0ed84edee7','b183651c-b74b-5da2-acb8-6e070f929027','b9e31f81-2a5b-5131-ae7d-5afe18f1f5fb',
                        'c255cd55-a6fb-5c6f-a213-83518a41fd93']::uuid[];
  v_s scholarship.scholarships%rowtype; n int; v_done text[] := '{}'; v_skip text[] := '{}';
begin
  -- Guard: all seven exist, none is under a manual lock (the award, its tiers or its criteria)
  if (select count(*) from scholarship.scholarships where id = any(v_ids)) <> 7 then raise exception 'b07: expected 7 scholarships'; end if;
  select count(*) into n from pipeline.manual_locks l
   where l.entity_id::text in (select id::text from unnest(v_ids) id
                               union all select t.id::text from scholarship.award_tiers t where t.scholarship_id = any(v_ids)
                               union all select c.id::text from scholarship.criteria c where c.scholarship_id = any(v_ids));
  if n > 0 then raise exception 'b07: % manual lock(s) on these awards; nothing changed', n; end if;
  if (select publication_status from scholarship.scholarships where id = 'b9e31f81-2a5b-5131-ae7d-5afe18f1f5fb') is distinct from 'withdrawn' then
    raise exception 'b07: Griffith International Academic Merit is no longer withdrawn; stop and review';
  end if;

  -- 1. Deakin International 20% Merit Scholarship: 20%. The 60 and 65 tiers are previous-study thresholds; the 20% tier is the award and stays.
  select * into v_s from scholarship.scholarships where id = 'cb5ca7fc-377e-5755-add3-caeef7e89fd2';
  if v_s.award_percentage = 65 then
    update scholarship.scholarships set award_percentage = 20, award_value_is_maximum = false,
      award_value_text = '20% of total tuition fees (as stated on the offer letter) for the normal duration of the program',
      award_applies_to_fee_type = 'tuition_fee', award_duration_basis = 'program_duration', updated_at = now()
     where id = v_s.id and award_percentage = 65;
    delete from scholarship.award_tiers where scholarship_id = v_s.id
       and ((tier_code = 'page_tier_p2' and percentage = 60) or (tier_code = 'page_tier_p3' and percentage = 65));
    get diagnostics n = row_count; if n <> 2 then raise exception 'b07 #1: expected 2 threshold tiers, found %', n; end if;
    v_done := array_append(v_done, 'deakin_merit');
  elsif v_s.award_percentage = 20 and not exists (select 1 from scholarship.award_tiers where scholarship_id = v_s.id and percentage in (60, 65)) then
    v_skip := array_append(v_skip, 'deakin_merit');
  else raise exception 'b07 #1: unexpected state (award_percentage %)', v_s.award_percentage; end if;

  -- 2. Deakin International Scholarship for Excellence: 25%. The 75 and 80 tiers are previous-study thresholds; the 25% tier stays.
  select * into v_s from scholarship.scholarships where id = '0c491130-f85e-572a-a1f2-60d59b1c6580';
  if v_s.award_percentage = 80 then
    update scholarship.scholarships set award_percentage = 25, award_value_is_maximum = false,
      award_value_text = '25% of total tuition fees (as stated on the offer letter) for the normal duration of the program',
      award_applies_to_fee_type = 'tuition_fee', award_duration_basis = 'program_duration', updated_at = now()
     where id = v_s.id and award_percentage = 80;
    delete from scholarship.award_tiers where scholarship_id = v_s.id
       and ((tier_code = 'page_tier_p2' and percentage = 75) or (tier_code = 'page_tier_p3' and percentage = 80));
    get diagnostics n = row_count; if n <> 2 then raise exception 'b07 #2: expected 2 threshold tiers, found %', n; end if;
    v_done := array_append(v_done, 'deakin_excellence');
  elsif v_s.award_percentage = 25 and not exists (select 1 from scholarship.award_tiers where scholarship_id = v_s.id and percentage in (75, 80)) then
    v_skip := array_append(v_skip, 'deakin_excellence');
  else raise exception 'b07 #2: unexpected state (award_percentage %)', v_s.award_percentage; end if;

  -- 3. Deakin Vice-Chancellor's International Scholarship: 50% or 100% by outcome, so a maximum of 100% with two benefit tiers.
  select * into v_s from scholarship.scholarships where id = '02a97aaf-a9b8-5076-aa2f-8dee0fa80487';
  if v_s.award_percentage = 100 and not v_s.award_value_is_maximum then
    if exists (select 1 from scholarship.award_tiers where scholarship_id = v_s.id) then raise exception 'b07 #3: tiers already present; review'; end if;
    update scholarship.scholarships set award_value_is_maximum = true,
      award_value_text = '100% or 50% of tuition fees (depending on scholarship outcome) for the normal duration of the program',
      award_applies_to_fee_type = 'tuition_fee', award_duration_basis = 'program_duration', updated_at = now()
     where id = v_s.id and award_value_is_maximum = false;
    insert into scholarship.award_tiers(scholarship_id, tier_code, label, percentage, display_order, source_id, evidence_id, notes)
    values (v_s.id, 'published_award_1', '50% of tuition fees (depending on scholarship outcome)', 50, 1, v_s.source_id, v_s.evidence_id, 'Deakin VC International Scholarship page; DOT Batch 07'),
           (v_s.id, 'published_award_2', '100% of tuition fees (depending on scholarship outcome)', 100, 2, v_s.source_id, v_s.evidence_id, 'Deakin VC International Scholarship page; DOT Batch 07');
    v_done := array_append(v_done, 'deakin_vc');
  elsif v_s.award_value_is_maximum and (select count(*) from scholarship.award_tiers where scholarship_id = v_s.id and tier_code in ('published_award_1','published_award_2')) = 2 then
    v_skip := array_append(v_skip, 'deakin_vc');
  else raise exception 'b07 #3: unexpected state'; end if;

  -- 4. Bond University College Academic Excellence Scholarship: 25%. 85% is the CPA eligibility threshold (kept as a criterion); the 25% tier stays.
  select * into v_s from scholarship.scholarships where id = '0eda3e72-f897-50fc-aebb-ad0ed84edee7';
  if v_s.award_percentage = 85 then
    update scholarship.scholarships set award_percentage = 25, award_value_is_maximum = false,
      award_value_text = '25% tuition fee reduction for the duration of the recipient''s undergraduate degree at Bond University',
      award_applies_to_fee_type = 'tuition_fee', award_duration_basis = 'program_duration', updated_at = now()
     where id = v_s.id and award_percentage = 85;
    delete from scholarship.award_tiers where scholarship_id = v_s.id and tier_code = 'page_tier_p2' and percentage = 85;
    get diagnostics n = row_count; if n <> 1 then raise exception 'b07 #4: expected 1 threshold tier, found %', n; end if;
    insert into scholarship.criteria(scholarship_id, criterion_type, operator, value_text, value_number, human_text, is_mandatory, machine_evaluable, status, source_id, evidence_id, confidence, value_json)
    select v_s.id, 'academic_minimum', '>=', 'CPA', 85, 'Achieve a minimum Cumulative Percentage Average (CPA) of 85% in the Bond University College Foundation Program, as the top-performing student in the cohort. This is the eligibility threshold, not the award value.', true, false, 'active', v_s.source_id, v_s.evidence_id, 0.9, '{"by":"DOT Batch 07"}'
     where not exists (select 1 from scholarship.criteria c where c.scholarship_id = v_s.id and c.criterion_type = 'academic_minimum');
    v_done := array_append(v_done, 'bond_buc');
  elsif v_s.award_percentage = 25 and not exists (select 1 from scholarship.award_tiers where scholarship_id = v_s.id and percentage = 85) then
    v_skip := array_append(v_skip, 'bond_buc');
  else raise exception 'b07 #4: unexpected state (award_percentage %)', v_s.award_percentage; end if;

  -- 5. Griffith University International Postgraduate Research Scholarship (GUIPRS): a full tuition fee offset for the tenure.
  --    AUD 36,000 a year is the minimum living support a sponsored applicant must hold (eligibility, kept as a criterion), not the award.
  select * into v_s from scholarship.scholarships where id = 'b183651c-b74b-5da2-acb8-6e070f929027';
  if v_s.award_amount = 36000 then
    update scholarship.scholarships set award_amount = null, award_currency_code = null, award_percentage = 100, award_value_type = 'percentage',
      award_value_is_maximum = false,
      award_value_text = 'Full tuition fee offset for the tenure of the award: up to 3 years full-time equivalent for doctoral candidates (an extension of up to 6 months may be approved) and up to 2 years for research masters. Also covers a standard Overseas Student Health Cover policy and the Student Services and Amenities Fee. A living allowance is a separate award and is not part of this value.',
      award_applies_to_fee_type = 'tuition_fee', award_duration_basis = 'program_duration', updated_at = now()
     where id = v_s.id and award_amount = 36000;
    insert into scholarship.criteria(scholarship_id, criterion_type, operator, value_text, human_text, is_mandatory, machine_evaluable, status, source_id, evidence_id, confidence, value_json)
    select v_s.id, 'published_eligibility_narrative', 'source_text', null, 'Applicants who already hold a sponsorship or scholarship for living expenses may apply when it is at least AUD 36,000 a year and evidence is provided. This is an eligibility condition, not the award value.', false, false, 'active', v_s.source_id, v_s.evidence_id, 0.9, '{"by":"DOT Batch 07"}'
     where not exists (select 1 from scholarship.criteria c where c.scholarship_id = v_s.id and c.value_json->>'by' = 'DOT Batch 07');
    v_done := array_append(v_done, 'griffith_guiprs');
  elsif v_s.award_amount is null and v_s.award_percentage = 100 then
    v_skip := array_append(v_skip, 'griffith_guiprs');
  else raise exception 'b07 #5: unexpected state (award_amount %)', v_s.award_amount; end if;

  -- 6. Griffith International Academic Merit Scholarship: stays withdrawn; exact commencement window and exclusions recorded.
  select * into v_s from scholarship.scholarships where id = 'b9e31f81-2a5b-5131-ae7d-5afe18f1f5fb';
  if v_s.study_start_label is distinct from 'Trimester 3, 2025 to 2027' then
    update scholarship.scholarships set study_start_label = 'Trimester 3, 2025 to 2027', updated_at = now() where id = v_s.id;
    v_done := array_append(v_done, 'griffith_merit_window');
  else v_skip := array_append(v_skip, 'griffith_merit_window'); end if;
  insert into scholarship.criteria(scholarship_id, criterion_type, operator, value_text, human_text, is_mandatory, machine_evaluable, status, source_id, evidence_id, confidence, value_json)
  select v_s.id, 'published_eligibility_narrative', 'source_text', null, 'Applies to tuition fees only for students commencing in Trimester 3, 2025 or any trimester in 2026 or 2027. Students who defer commencement to 2028 or later are not eligible. Excludes Higher Degree Research, non-award, Study Abroad, Diploma programs, Masters Qualifying Program, MBA (5158), Bachelor of Medical Science, Bachelor of Dental Health Science, Master of Dentistry, Doctor of Medicine and the other listed programs. Full-time enrolment is required.', true, false, 'active', v_s.source_id, v_s.evidence_id, 0.9, '{"by":"DOT Batch 07"}'
   where not exists (select 1 from scholarship.criteria c where c.scholarship_id = v_s.id and c.value_json->>'by' = 'DOT Batch 07');

  -- 7. Curtin Global Merit Scholarship: 20% (unchanged), WA campus, commencing 2027 or 2028, up to 4 years (undergraduate) or 2 years (Masters by Coursework).
  select * into v_s from scholarship.scholarships where id = 'c255cd55-a6fb-5c6f-a213-83518a41fd93';
  if v_s.award_duration_basis is null and v_s.award_percentage = 20 then
    update scholarship.scholarships set award_duration_basis = 'program_duration', study_start_label = '2027 or 2028',
      award_value_text = '20% of the tuition fee of the course, credited for up to 4 years for an undergraduate degree or up to 2 years for a Masters by Coursework, for students commencing at a Curtin Western Australian campus in 2027 or 2028 (not transferable to a campus or partner outside Western Australia)',
      updated_at = now()
     where id = v_s.id and award_duration_basis is null;
    v_done := array_append(v_done, 'curtin_global_merit');
  elsif v_s.award_duration_basis = 'program_duration' and v_s.study_start_label = '2027 or 2028' then
    v_skip := array_append(v_skip, 'curtin_global_merit');
  else raise exception 'b07 #7: unexpected state'; end if;

  -- Publication and lifecycle unchanged for all seven (Griffith Academic Merit stays withdrawn)
  if exists (select 1 from scholarship.scholarships s join b07_before b using (id)
              where s.lifecycle_status is distinct from b.lifecycle_status or s.publication_status is distinct from b.publication_status) then
    raise exception 'b07: a lifecycle or publication status changed';
  end if;

  -- Affected course savings, then one audit row
  if cardinality(v_done) > 0 then
    for n in 1..7 loop perform scholarship.refresh_course_financial_calculations(null, v_ids[n]); end loop;
    insert into pipeline.admin_control_events(area, action, target, detail, actor)
    values ('scholarship', 'b07_value_corrections', 'scholarship.scholarships',
            jsonb_build_object('source', 'DOT Batch 07 (Admin #1327, #1329); corrected paste S1-Build 28 Nov 2026', 'applied', to_jsonb(v_done), 'already_correct', to_jsonb(v_skip), 'ids', to_jsonb(v_ids)),
            security.system_actor_id());
  end if;
  raise notice 'b07: applied % ; already correct %', v_done, v_skip;
end $b07$;

select left(s.name, 40) as scholarship, s.lifecycle_status, s.publication_status, s.award_percentage, s.award_amount, s.award_value_is_maximum,
       s.award_duration_basis, s.study_start_label,
       (select string_agg(t.tier_code || '=' || t.percentage::text, ' ' order by t.display_order) from scholarship.award_tiers t where t.scholarship_id = s.id) as tiers
  from scholarship.scholarships s
 where s.id in ('cb5ca7fc-377e-5755-add3-caeef7e89fd2','0c491130-f85e-572a-a1f2-60d59b1c6580','02a97aaf-a9b8-5076-aa2f-8dee0fa80487','0eda3e72-f897-50fc-aebb-ad0ed84edee7',
                'b183651c-b74b-5da2-acb8-6e070f929027','b9e31f81-2a5b-5131-ae7d-5afe18f1f5fb','c255cd55-a6fb-5c6f-a213-83518a41fd93')
 order by s.name;

commit;
