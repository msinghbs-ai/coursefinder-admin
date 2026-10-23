-- NZ field admission, 24 Oct 2026 00:40–01:05 AEDT, run live by Claude on the Platform Admin's 00:35 mandate (kept for the record).
-- A. 832 NZ fee requests (count-guarded): bound NZ page, tuition proof allowed by the country policy, stored copy, no international fee,
--    no request in 2 days, nothing queued or leased for the course, no pending Layer 4 fee item. Dated just before the page read so the
--    next enqueue tick queues them without a re-read. Result: 832 queued to the fee reader at the first tick.
begin;
create temp table _nzfee on commit drop as
select c.id course_id, p.read_at, p.evidence_id, pr.id provider_id
from pipeline.coverage_course_pages p join catalogue.courses c on c.id=p.course_id and c.lifecycle_status='active' join catalogue.providers pr on pr.id=p.provider_id join ref.countries k on k.id=pr.country_id
where k.iso_alpha2='NZ' and p.status='bound' and p.evidence_id is not null and p.read_at is not null and security.coverage_identity_allowed(p.provider_id, p.identity_basis, 'tuition')
  and not exists (select 1 from catalogue.course_fees f where f.course_id=c.id and f.status='active' and f.audience='international')
  and not exists (select 1 from pipeline.fee_course_requests q where q.course_id=c.id and (q.queued_at is null or q.queued_at>now()-interval '2 days' or q.requested_at>now()-interval '2 days'))
  and not exists (select 1 from pipeline.fee_reader_queue q where q.course_id=c.id and q.state in ('queued','leased'))
  and not exists (select 1 from pipeline.layer4_review_items l where l.entity_id=c.id and l.field_code='provider_current_tuition' and l.status='pending');
do $g$ declare n int; begin select count(*) into n from _nzfee; if n <> 832 then raise exception 'expected 832, found %', n; end if; end $g$;
insert into pipeline.fee_course_requests (course_id, requested_at, requested_by, reason)
select course_id, read_at - interval '1 second', '<platform admin uuid>', 'NZ field admission 24 Oct 2026 00:35 (Platform Admin): bound NZ page, tuition proof allowed, no international fee' from _nzfee
on conflict (course_id) do update set requested_at = excluded.requested_at, requested_by = excluded.requested_by, reason = excluded.reason, queued_at = null, outcome = null;
commit;
-- B. Central policy pages (English policy, intake calendar) enqueued through the existing function for every NZ provider (10 rows: 1 English, 9 calendars)
--    and every CA provider (17 rows). CA fee requests were NOT fired: CA tuition admission is gated on 8a (DLI proofs) per addendum A1.
select sum(security.central_ai_enqueue_v1(pr.id)) from catalogue.providers pr join ref.countries k on k.id=pr.country_id where k.iso_alpha2 in ('NZ');
select sum(security.central_ai_enqueue_v1(pr.id)) from catalogue.providers pr join ref.countries k on k.id=pr.country_id where k.iso_alpha2 in ('CA');
