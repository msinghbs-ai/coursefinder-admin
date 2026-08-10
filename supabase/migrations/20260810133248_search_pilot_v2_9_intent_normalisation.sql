create table if not exists search_pilot.intent_aliases (
  id bigserial primary key,
  alias text not null,
  canonical_term text not null,
  alias_kind text not null default 'semantic',
  level_hint text null,
  priority int not null default 100,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  unique(alias, alias_kind)
);

insert into search_pilot.intent_aliases(alias,canonical_term,alias_kind,level_hint,priority) values
('artificial intelligence','artificial intelligence','semantic',null,10),
('ai','artificial intelligence','semantic',null,20),
('machine learning','machine learning','semantic',null,10),
('cyber security','cybersecurity','semantic',null,10),
('cybersecurity','cybersecurity','semantic',null,10),
('information technology','information technology','semantic',null,10),
('it','information technology','semantic',null,50),
('data science','data science','semantic',null,10),
('data analytics','data analytics','semantic',null,10),
('business analytics','business analytics','semantic',null,10),
('software engineering','software engineering','semantic',null,10),
('information systems','information systems','semantic',null,10),
('industry focused','industry professional applied','semantic',null,20),
('industry focus','industry professional applied','semantic',null,20),
('career focused','professional applied','semantic',null,20),
('career focus','professional applied','semantic',null,20),
('short postgraduate','postgraduate short course','semantic',null,20),
('postgrad','postgraduate','semantic',null,20),
('undergrad','undergraduate','semantic',null,20),
('bachelor','bachelor','level','bachelor',10),
('undergraduate','undergraduate','level','bachelor',10),
('masters','masters','level','masters',10),
('master''s','masters','level','masters',10),
('master','masters','level','masters',20),
('graduate certificate','graduate certificate','level','graduate_certificate',10),
('graduate diploma','graduate diploma','level','graduate_diploma',10),
('doctoral','doctoral','level','doctoral',10),
('phd','doctoral research','level','doctoral',10)
on conflict(alias,alias_kind) do update set
  canonical_term=excluded.canonical_term,
  level_hint=excluded.level_hint,
  priority=excluded.priority,
  is_active=true;

create or replace function public.intent_normalize_pilot_v2_9(p_query text)
returns table(original_query text, normalized_query text, inferred_level text, applied_aliases jsonb)
language plpgsql
security definer
set search_path = public, search_pilot
as $$
declare
  q text := regexp_replace(lower(trim(coalesce(p_query,''))), '\s+', ' ', 'g');
  a record;
  applied jsonb := '[]'::jsonb;
  lvl text := null;
begin
  if q = '' then
    return query select coalesce(p_query,''), '', null::text, '[]'::jsonb;
    return;
  end if;

  select ia.level_hint into lvl
  from search_pilot.intent_aliases ia
  where ia.is_active and ia.alias_kind='level' and ia.level_hint is not null
    and q ~ ('(^|[^a-z0-9])' || regexp_replace(ia.alias, '([\\.\\+\\*\\?\\[\\^\\]\\$\\(\\)\\{\\}=!<>|:\\-])', '\\\1', 'g') || '([^a-z0-9]|$)')
  order by length(ia.alias) desc, ia.priority asc
  limit 1;

  for a in
    select alias, canonical_term
    from search_pilot.intent_aliases
    where is_active and alias_kind='semantic' and lower(alias) <> lower(canonical_term)
    order by length(alias) desc, priority asc
  loop
    if q ~ ('(^|[^a-z0-9])' || regexp_replace(a.alias, '([\\.\\+\\*\\?\\[\\^\\]\\$\\(\\)\\{\\}=!<>|:\\-])', '\\\1', 'g') || '([^a-z0-9]|$)') then
      q := regexp_replace(
        q,
        '(^|[^a-z0-9])' || regexp_replace(a.alias, '([\\.\\+\\*\\?\\[\\^\\]\\$\\(\\)\\{\\}=!<>|:\\-])', '\\\1', 'g') || '([^a-z0-9]|$)',
        '\1' || a.canonical_term || '\2',
        'g'
      );
      applied := applied || jsonb_build_array(jsonb_build_object('alias',a.alias,'canonical',a.canonical_term));
    end if;
  end loop;

  q := regexp_replace(q, '\s+', ' ', 'g');
  return query select p_query, trim(q), lvl, applied;
end;
$$;

revoke all on function public.intent_normalize_pilot_v2_9(text) from public, anon, authenticated;
grant execute on function public.intent_normalize_pilot_v2_9(text) to service_role;
