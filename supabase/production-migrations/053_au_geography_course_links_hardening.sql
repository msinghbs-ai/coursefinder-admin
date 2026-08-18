-- CourseFinder production migration 053
-- AU geography + Course Links hardening
-- Applied live as Supabase migration: au_geography_course_links_hardening

create or replace function ref.resolve_subdivision_exact(p_country_id uuid, p_source_state text)
returns uuid
language sql
stable
security invoker
set search_path = ref
as $$
  select s.id
  from ref.subdivisions s
  where s.country_id = p_country_id
    and nullif(btrim(p_source_state),'') is not null
    and (
      upper(s.code) = upper(btrim(p_source_state))
      or lower(s.name) = lower(btrim(p_source_state))
      or upper(regexp_replace(s.code, '^.*-', '')) = upper(btrim(p_source_state))
    )
  order by case
    when upper(s.code) = upper(btrim(p_source_state)) then 0
    when lower(s.name) = lower(btrim(p_source_state)) then 1
    else 2
  end, s.id
  limit 1
$$;

revoke all on function ref.resolve_subdivision_exact(uuid,text) from public, anon, authenticated;
grant execute on function ref.resolve_subdivision_exact(uuid,text) to service_role;

create table if not exists catalogue.course_links (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references catalogue.courses(id) on delete cascade,
  link_type text not null,
  url text not null,
  audience text,
  locale text,
  label text,
  is_primary boolean not null default false,
  status text not null default 'active' check (status in ('active','inactive','deprecated','unverified')),
  valid_from date,
  valid_to date,
  source_id uuid references pipeline.sources(id),
  evidence_id uuid references pipeline.evidence_artifacts(id),
  confidence numeric check (confidence is null or (confidence >= 0 and confidence <= 1)),
  last_verified_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint course_links_url_not_blank check (btrim(url) <> ''),
  constraint course_links_type_not_blank check (btrim(link_type) <> ''),
  constraint course_links_valid_range check (valid_to is null or valid_from is null or valid_to >= valid_from),
  unique(course_id, link_type, url)
);

create index if not exists course_links_course_idx on catalogue.course_links(course_id);
create index if not exists course_links_type_status_idx on catalogue.course_links(link_type,status);
create index if not exists course_links_source_idx on catalogue.course_links(source_id);
create index if not exists course_links_evidence_idx on catalogue.course_links(evidence_id);
create unique index if not exists course_links_one_primary_active_idx
  on catalogue.course_links(course_id)
  where is_primary and status='active';

alter table catalogue.course_links enable row level security;
revoke all on catalogue.course_links from public, anon, authenticated;
grant select,insert,update,delete on catalogue.course_links to service_role;

comment on table catalogue.course_links is 'Evidence-backed relational URLs for canonical Courses. courses.course_url remains a compatibility/current-primary field, not the multi-link source of truth.';

-- Service RPC changes applied live in this migration:
-- 1. svc_layer1_apply_location_records now resolves exact canonical subdivisions through
--    ref.resolve_subdivision_exact(), accepting full ISO code, exact subdivision name, or
--    exact ISO suffix (e.g. NSW -> AU-NSW). It never infers state from city/postcode and
--    reports unmapped_subdivision when a published token cannot be resolved.
-- 2. svc_layer1_apply_register_records now accepts direct provider state/address/postcode
--    source fields, resolves state through the same exact function, and reports
--    provider_unmapped_subdivision. No geography is fabricated when source state is absent.
--
-- Full function definitions are the live migration body held in Supabase migration history.
-- Keep this repository migration paired with architecture v2.10.27 and the worker update.