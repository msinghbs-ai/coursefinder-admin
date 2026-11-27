-- DOT Batch 07 (Admin #1327): seven AU scholarship value and scope corrections. Prepared by S1-Scholarship-Claude, 28 Nov 2026.
-- Data only; no schema change; no manual lock, G3, hold or scholarship_status change. Each update is guarded by the wrong value it replaces,
-- so a re-run changes nothing. Run in one transaction; the closing select is the read-back. Then run
-- scholarship.refresh_course_financial_calculations(null, <id>) for each id and log one pipeline.admin_control_events row.
begin;

-- 1. Deakin International 20% Merit Scholarship: 20% (65 and 60 were previous-study thresholds)
update scholarship.scholarships set award_percentage=20, award_value_is_maximum=false,
  award_value_text='20% of total tuition fees (as stated on the offer letter) for the normal duration of the program',
  award_applies_to_fee_type='tuition_fee', award_duration_basis='program_duration', updated_at=now()
 where id='cb5ca7fc-377e-5755-add3-caeef7e89fd2' and award_percentage=65;
delete from scholarship.award_tiers where scholarship_id='cb5ca7fc-377e-5755-add3-caeef7e89fd2' and tier_code in ('page_tier_p1','page_tier_p2','page_tier_p3');

-- 2. Deakin International Scholarship for Excellence: 25% (75 and 80 were previous-study thresholds)
update scholarship.scholarships set award_percentage=25, award_value_is_maximum=false,
  award_value_text='25% of total tuition fees (as stated on the offer letter) for the normal duration of the program',
  award_applies_to_fee_type='tuition_fee', award_duration_basis='program_duration', updated_at=now()
 where id='0c491130-f85e-572a-a1f2-60d59b1c6580' and award_percentage=80;
delete from scholarship.award_tiers where scholarship_id='0c491130-f85e-572a-a1f2-60d59b1c6580' and tier_code in ('page_tier_p1','page_tier_p2','page_tier_p3');

-- 3. Deakin Vice-Chancellor's International Scholarship: 50% and 100% outcome tiers, maximum 100%
update scholarship.scholarships set award_percentage=100, award_value_is_maximum=true,
  award_value_text='100% or 50% of tuition fees (depending on scholarship outcome) for the normal duration of the program',
  award_applies_to_fee_type='tuition_fee', award_duration_basis='program_duration', updated_at=now()
 where id='02a97aaf-a9b8-5076-aa2f-8dee0fa80487' and award_value_is_maximum=false;
insert into scholarship.award_tiers(scholarship_id,tier_code,label,percentage,display_order,source_id,evidence_id,notes)
select s.id,'published_award_1','50% of tuition fees (depending on scholarship outcome)',50,1,s.source_id,s.evidence_id,'Deakin VC International Scholarship page; DOT Batch 07'
  from scholarship.scholarships s where s.id='02a97aaf-a9b8-5076-aa2f-8dee0fa80487' and not exists (select 1 from scholarship.award_tiers t where t.scholarship_id=s.id);
insert into scholarship.award_tiers(scholarship_id,tier_code,label,percentage,display_order,source_id,evidence_id,notes)
select s.id,'published_award_2','100% of tuition fees (depending on scholarship outcome)',100,2,s.source_id,s.evidence_id,'Deakin VC International Scholarship page; DOT Batch 07'
  from scholarship.scholarships s where s.id='02a97aaf-a9b8-5076-aa2f-8dee0fa80487' and (select count(*) from scholarship.award_tiers t where t.scholarship_id=s.id)=1;

-- 4. Bond University College Academic Excellence Scholarship: 25% (85% is the CPA eligibility; Foundation 063151G stays unmapped)
update scholarship.scholarships set award_percentage=25, award_value_is_maximum=false,
  award_value_text='25% tuition fee reduction for the duration of the recipient''s undergraduate degree at Bond University',
  award_applies_to_fee_type='tuition_fee', award_duration_basis='program_duration', updated_at=now()
 where id='0eda3e72-f897-50fc-aebb-ad0ed84edee7' and award_percentage=85;
delete from scholarship.award_tiers where scholarship_id='0eda3e72-f897-50fc-aebb-ad0ed84edee7' and tier_code in ('page_tier_p1','page_tier_p2');
insert into scholarship.criteria(scholarship_id,criterion_type,operator,value_text,value_number,human_text,is_mandatory,machine_evaluable,status,source_id,evidence_id,confidence,value_json)
select s.id,'academic_minimum','>=','CPA',85,'Achieve a minimum Cumulative Percentage Average (CPA) of 85% in the Bond University College Foundation Program, as the top-performing student in the cohort. This is the eligibility threshold, not the award value.',true,false,'active',s.source_id,s.evidence_id,0.9,'{"by":"DOT Batch 07"}'
  from scholarship.scholarships s where s.id='0eda3e72-f897-50fc-aebb-ad0ed84edee7' and not exists (select 1 from scholarship.criteria c where c.scholarship_id=s.id and c.criterion_type='academic_minimum');

-- 5. Griffith University International Postgraduate Research Scholarship: tuition fee offset (not AUD 36,000; the sponsor living-support minimum is an eligibility figure)
update scholarship.scholarships set award_amount=null, award_currency_code=null, award_percentage=100, award_value_type='percentage', award_value_is_maximum=false,
  award_value_text='Tuition fee offset for the tenure of the award (also covers OSHC and the Student Services and Amenities Fee). A living allowance is a separate award and is not part of this value.',
  award_applies_to_fee_type='tuition_fee', award_duration_basis='program_duration', updated_at=now()
 where id='b183651c-b74b-5da2-acb8-6e070f929027' and award_amount=36000;

-- 6. Griffith International Academic Merit Scholarship (withdrawn; stays withdrawn): exact commencement window and exclusions
update scholarship.scholarships set study_start_label='Trimester 3, 2025 to 2027', updated_at=now()
 where id='b9e31f81-2a5b-5131-ae7d-5afe18f1f5fb' and study_start_label is distinct from 'Trimester 3, 2025 to 2027';
insert into scholarship.criteria(scholarship_id,criterion_type,operator,value_text,human_text,is_mandatory,machine_evaluable,status,source_id,evidence_id,confidence,value_json)
select s.id,'published_eligibility_narrative','source_text',null,'Applies to tuition fees only for students commencing in Trimester 3, 2025 or any trimester in 2026 or 2027. Students who defer commencement to 2028 or later are not eligible. Excludes Higher Degree Research, non-award, Study Abroad, Diploma programs, Masters Qualifying Program, MBA (5158), Bachelor of Medical Science, Bachelor of Dental Health Science, Master of Dentistry, Doctor of Medicine and the other listed programs. Full-time enrolment is required.',true,false,'active',s.source_id,s.evidence_id,0.9,'{"by":"DOT Batch 07"}'
  from scholarship.scholarships s where s.id='b9e31f81-2a5b-5131-ae7d-5afe18f1f5fb' and not exists (select 1 from scholarship.criteria c where c.scholarship_id=s.id and c.value_json->>'by'='DOT Batch 07');

-- 7. Curtin Global Merit Scholarship: WA campus, 2027 or 2028, duration (20% unchanged)
update scholarship.scholarships set award_duration_basis='program_duration', study_start_label='2027 or 2028',
  award_value_text='20% of the tuition fee of the course, credited for up to 4 years for an undergraduate degree or up to 2 years for a Masters by Coursework, for students commencing at the Western Australian campus in 2027 or 2028',
  updated_at=now()
 where id='c255cd55-a6fb-5c6f-a213-83518a41fd93' and award_duration_basis is null;

select id, left(name,34) n, award_percentage, award_amount, award_value_is_maximum, award_duration_basis,
  (select string_agg(percentage::text,'/' order by display_order) from scholarship.award_tiers t where t.scholarship_id=s.id) tiers
  from scholarship.scholarships s where id in ('cb5ca7fc-377e-5755-add3-caeef7e89fd2','0c491130-f85e-572a-a1f2-60d59b1c6580','02a97aaf-a9b8-5076-aa2f-8dee0fa80487','0eda3e72-f897-50fc-aebb-ad0ed84edee7','b183651c-b74b-5da2-acb8-6e070f929027','b9e31f81-2a5b-5131-ae7d-5afe18f1f5fb','c255cd55-a6fb-5c6f-a213-83518a41fd93') order by name;
commit;
