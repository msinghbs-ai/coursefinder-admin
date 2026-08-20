-- M1-PIM-FINALISATION operational/detail read contracts
-- Bounded Review Queue; repaired Provider detail; structured Campus detail;
-- Search/Publication overview. No canonical identity or field semantics change.

create or replace function security.admin_operational_page(p_operation text,p_args jsonb default '{}'::jsonb)
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog, security, workflow, auth
as $$
declare
  v_rank integer:=0;
  v_limit integer:=least(greatest(coalesce(nullif(p_args->>'limit','')::integer,50),1),200);
  v_offset integer:=greatest(coalesce(nullif(p_args->>'offset','')::integer,0),0);
  v_query text:=nullif(trim(coalesce(p_args->>'query','')),'');
  v_sort text:=lower(coalesce(nullif(p_args->>'sort',''),'created'));
  v_dir text:=case when lower(coalesce(nullif(p_args->>'direction',''),'desc'))='asc' then 'asc' else 'desc' end;
  v_result jsonb;
begin
  if auth.uid() is null then raise exception 'authentication required' using errcode='42501'; end if;
  select security.current_role_rank() into v_rank;
  if p_operation<>'reviews_page' then raise exception 'unsupported operational page: %',p_operation using errcode='22023'; end if;
  if v_rank<3 then raise exception 'curator role required' using errcode='42501'; end if;

  with base as (
    select r.id,r.entity_id,r.domain,r.field_code,r.candidate_claim_id,r.previous_review_id,
           r.reopen_reason,r.priority,r.status,r.assigned_to,r.created_at,r.updated_at,r.closed_at
    from workflow.review_queue r
    where (v_query is null
      or r.id::text=v_query
      or coalesce(r.entity_id::text,'')=v_query
      or coalesce(r.candidate_claim_id::text,'')=v_query
      or coalesce(r.domain,'') ilike '%'||v_query||'%'
      or coalesce(r.field_code,'') ilike '%'||v_query||'%'
      or coalesce(r.reopen_reason,'') ilike '%'||v_query||'%')
      and (nullif(p_args->>'status','') is null or r.status=p_args->>'status')
      and (nullif(p_args->>'domain','') is null or r.domain=p_args->>'domain')
  ), numbered as (select *,count(*) over() total_count from base), ordered as (
    select * from numbered order by
      case when v_sort='priority' and v_dir='asc' then priority end asc,
      case when v_sort='priority' and v_dir='desc' then priority end desc,
      case when v_sort='status' and v_dir='asc' then lower(coalesce(status,'')) end asc,
      case when v_sort='status' and v_dir='desc' then lower(coalesce(status,'')) end desc,
      case when v_sort in ('created','updated') and v_dir='asc' then (case when v_sort='updated' then updated_at else created_at end) end asc,
      case when v_sort in ('created','updated') and v_dir='desc' then (case when v_sort='updated' then updated_at else created_at end) end desc,
      priority desc nulls last,created_at desc,id
    limit v_limit offset v_offset
  )
  select jsonb_build_object(
    'items',coalesce(jsonb_agg(to_jsonb(o)-'total_count'),'[]'::jsonb),
    'total',coalesce(max(total_count),0),'limit',v_limit,'offset',v_offset,'sort',v_sort,'direction',v_dir,
    'filters',jsonb_build_object(
      'statuses',coalesce((select jsonb_agg(jsonb_build_object('code',x.status,'name',initcap(replace(x.status,'_',' ')),'count',x.n) order by x.status) from (select status,count(*) n from workflow.review_queue where status is not null group by status) x),'[]'::jsonb),
      'domains',coalesce((select jsonb_agg(jsonb_build_object('code',x.domain,'name',initcap(replace(x.domain,'_',' ')),'count',x.n) order by x.domain) from (select domain,count(*) n from workflow.review_queue where domain is not null group by domain) x),'[]'::jsonb)
    )
  ) into v_result from ordered o;
  return v_result;
end
$$;

revoke execute on function security.admin_operational_page(text,jsonb) from public, anon;
grant execute on function security.admin_operational_page(text,jsonb) to authenticated, service_role;

create or replace function security.admin_provider_detail(p_provider_id uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog, security, public, catalogue, pipeline, ref, scholarship, auth
as $$
declare
  v_rank integer:=0;
  v_base jsonb;
  v_courses jsonb;
  v_evidence jsonb;
  v_campuses jsonb;
begin
  if auth.uid() is null then raise exception 'authentication required' using errcode='42501'; end if;
  select security.current_role_rank() into v_rank;
  if v_rank<1 then raise exception 'assigned CourseFinder role required' using errcode='42501'; end if;

  v_base:=public.ui_provider_detail(p_provider_id);
  if v_base is null then return '{}'::jsonb; end if;
  v_courses:=public.ui_provider_related_courses(p_provider_id,25,0,null,null,null);
  v_evidence:=public.ui_provider_related_evidence(p_provider_id,25,0,null,null);

  with base as (
    select ca.id,ca.stable_key,ca.name,ca.campus_code,ca.city,ca.postcode,ca.status,ca.publication_status,
           sd.code subdivision_code,sd.name subdivision_name,
           (select count(*)::int from catalogue.course_campuses cc where cc.campus_id=ca.id) course_count
    from catalogue.campuses ca left join ref.subdivisions sd on sd.id=ca.subdivision_id
    where ca.provider_id=p_provider_id
  ), numbered as (select *,count(*) over() total_count from base), ordered as (
    select * from numbered order by lower(name),id limit 25
  )
  select jsonb_build_object('items',coalesce(jsonb_agg(to_jsonb(o)-'total_count'),'[]'::jsonb),'total',coalesce(max(total_count),0),'limit',25,'offset',0)
    into v_campuses from ordered o;

  return v_base || jsonb_build_object(
    'courses_page',coalesce(v_courses,jsonb_build_object('items','[]'::jsonb,'total',0,'limit',25,'offset',0)),
    'evidence_page',coalesce(v_evidence,jsonb_build_object('items','[]'::jsonb,'total',0,'limit',25,'offset',0)),
    'campuses_page',coalesce(v_campuses,jsonb_build_object('items','[]'::jsonb,'total',0,'limit',25,'offset',0)),
    'courses',coalesce(v_courses->'items','[]'::jsonb),
    'evidence',coalesce(v_evidence->'items','[]'::jsonb),
    'scholarship_count',(select count(*) from scholarship.scholarships s where s.provider_id=p_provider_id),
    'history',jsonb_build_object('created_at',v_base->'created_at','updated_at',v_base->'updated_at','last_verified_at',v_base->'last_verified_at')
  );
end
$$;

revoke execute on function security.admin_provider_detail(uuid) from public, anon;
grant execute on function security.admin_provider_detail(uuid) to authenticated, service_role;

create or replace function security.admin_campus_detail(p_campus_id uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog, security, catalogue, pipeline, ref, scholarship, auth
as $$
declare v_rank integer:=0; v_result jsonb;
begin
  if auth.uid() is null then raise exception 'authentication required' using errcode='42501'; end if;
  select security.current_role_rank() into v_rank;
  if v_rank<1 then raise exception 'assigned CourseFinder role required' using errcode='42501'; end if;

  select jsonb_build_object(
    'id',ca.id,'stable_key',ca.stable_key,'name',ca.name,'campus_code',ca.campus_code,
    'provider_id',ca.provider_id,'provider_name',coalesce(p.display_name,p.canonical_name),
    'country_code',co.iso_alpha2,'country_name',co.name,'subdivision_code',sd.code,'subdivision_name',sd.name,
    'city',ca.city,'address_line1',ca.address_line1,'address_line2',ca.address_line2,'postcode',ca.postcode,
    'latitude',ca.latitude,'longitude',ca.longitude,'phone',ca.phone,'website',ca.website,
    'status',ca.status,'publication_status',ca.publication_status,'valid_from',ca.valid_from,'valid_to',ca.valid_to,
    'last_verified_at',ca.last_verified_at,'created_at',ca.created_at,'updated_at',ca.updated_at,
    'source',jsonb_build_object('source_id',ca.source_id,'source_label',s.label,'source_type',s.source_type,'source_url',s.url),
    'evidence',case when e.id is null then '[]'::jsonb else jsonb_build_array(jsonb_build_object('id',e.id,'type',e.evidence_type,'source_url',e.source_url,'storage_path',e.storage_path,'content_hash',e.content_hash,'captured_at',e.captured_at)) end,
    'courses_page',coalesce((
      with base as (
        select c.id,c.stable_key,c.canonical_title,c.course_code,c.lifecycle_status,c.publication_status,cc.delivery_mode,cc.is_primary
        from catalogue.course_campuses cc join catalogue.courses c on c.id=cc.course_id
        where cc.campus_id=ca.id
      ), numbered as (select *,count(*) over() total_count from base), ordered as (
        select * from numbered order by lower(canonical_title),id limit 25
      )
      select jsonb_build_object('items',coalesce(jsonb_agg(to_jsonb(o)-'total_count'),'[]'::jsonb),'total',coalesce(max(total_count),0),'limit',25,'offset',0) from ordered o
    ),jsonb_build_object('items','[]'::jsonb,'total',0,'limit',25,'offset',0)),
    'scholarship_count',(select count(distinct ss.scholarship_id) from scholarship.scopes ss where ss.campus_id=ca.id and coalesce(ss.include_exclude,'include')='include')
  ) into v_result
  from catalogue.campuses ca
  join catalogue.providers p on p.id=ca.provider_id
  join ref.countries co on co.id=ca.country_id
  left join ref.subdivisions sd on sd.id=ca.subdivision_id
  left join pipeline.sources s on s.id=ca.source_id
  left join pipeline.evidence_artifacts e on e.id=ca.evidence_id
  where ca.id=p_campus_id;
  return coalesce(v_result,'{}'::jsonb);
end
$$;

revoke execute on function security.admin_campus_detail(uuid) from public, anon;
grant execute on function security.admin_campus_detail(uuid) to authenticated, service_role;

create index if not exists search_course_documents_admin_summary_idx
  on search.course_documents(publication_status,has_fee,has_intake,has_english,has_scholarship,generated_at);

create or replace function security.admin_publication_overview()
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog, security, search, publishing, auth
as $$
declare v_rank integer:=0; v_result jsonb;
begin
  if auth.uid() is null then raise exception 'authentication required' using errcode='42501'; end if;
  select security.current_role_rank() into v_rank;
  if v_rank<1 then raise exception 'assigned CourseFinder role required' using errcode='42501'; end if;
  select jsonb_build_object(
    'course_documents',jsonb_build_object(
      'total',count(*),'published',count(*) filter(where publication_status='published'),
      'unpublished',count(*) filter(where publication_status='unpublished'),
      'has_fee',count(*) filter(where has_fee),'has_intake',count(*) filter(where has_intake),
      'has_english',count(*) filter(where has_english),'has_scholarship',count(*) filter(where has_scholarship),
      'latest_generated_at',max(generated_at)
    ),
    'projection',coalesce((select jsonb_build_object(
      'projection_code',ps.projection_code,'generation',ps.generation,'rebuilt_at',ps.rebuilt_at,'row_count',ps.row_count,
      'content_hash',ps.content_hash,'projection_version',ps.metadata->>'projection_version','enrichment_gate',ps.metadata->>'enrichment_gate'
    ) from search.projection_state ps where ps.projection_code='courses'),'{}'::jsonb),
    'channels',coalesce((select jsonb_agg(jsonb_build_object(
      'code',ch.code,'name',ch.name,'audience',ch.audience,'status',ch.status,
      'entity_state_count',coalesce(st.entity_state_count,0),'published_count',coalesce(st.published_count,0)
    ) order by ch.code)
      from publishing.channels ch
      left join (select channel_code,count(*) entity_state_count,count(*) filter(where publication_status='published') published_count from publishing.entity_states group by channel_code) st on st.channel_code=ch.code
    ),'[]'::jsonb)
  ) into v_result from search.course_documents;
  return v_result;
end
$$;

revoke execute on function security.admin_publication_overview() from public, anon;
grant execute on function security.admin_publication_overview() to authenticated, service_role;
