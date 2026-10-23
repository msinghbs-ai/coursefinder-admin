-- Bound-but-empty sweep, 23 Oct 2026 22:30 AEDT, run by Claude on the Platform Admin's 22:24 instruction (ran live; kept for the record).
-- Set: course pages bound > 12 h with no active fee and no active English requirement (3,675: CA 2,499, NZ 1,176).
-- Pages already read with evidence are dated just before their read so the next enqueue tick queues them without a re-read.
begin;
create temp table sweep_set on commit drop as
select p.course_id, p.read_at, p.evidence_id
from pipeline.coverage_course_pages p
where p.status='bound' and p.bound_at < now()-interval '12 hours'
  and not exists (select 1 from catalogue.course_fees f where f.course_id=p.course_id and f.status='active')
  and not exists (select 1 from catalogue.course_english_requirements e where e.course_id=p.course_id and e.status='active');
insert into pipeline.fee_course_requests (course_id, requested_at, requested_by, reason)
select s.course_id,
       case when s.read_at is not null and s.evidence_id is not null then s.read_at - interval '1 second' else now() end,
       '<platform admin uuid>',
       'bound-but-empty sweep 23 Oct 2026 22:24 (Platform Admin): bound > 12 h, no active fee, no active English'
from sweep_set s
on conflict (course_id) do update set requested_at = excluded.requested_at, requested_by = excluded.requested_by, reason = excluded.reason, queued_at = null, outcome = null;
update pipeline.coverage_course_pages p set next_read_at = now(), read_attempts = 0, leased_until = null
from sweep_set s where p.course_id = s.course_id and p.status = 'bound';
insert into pipeline.course_priority (course_id, sort)
select s.course_id, 0 from sweep_set s where not exists (select 1 from pipeline.course_priority cp where cp.course_id = s.course_id);
commit;
-- Result at 22:31: 3,675 swept; fee requests 2,735 queued, 250 not_admitted (identity not allowed for tuition), 690 open until the page is read;
-- fee reader queue 2,703 queued; 3,675 pages reset to read first in line (read lane did 2,132 pages in the previous 24 h, 2,349 already due).
