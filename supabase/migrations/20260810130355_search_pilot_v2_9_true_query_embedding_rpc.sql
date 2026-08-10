create or replace function public.hybrid_search_query_embedding_pilot_v2_9(
  p_query text,
  p_query_embedding vector(1536),
  p_country char(2) default null,
  p_level text default null,
  p_limit integer default 20
)
returns table(
  course_id uuid,
  provider_name text,
  canonical_title text,
  level_code text,
  fused_score double precision,
  text_rank bigint,
  vector_rank bigint
)
language sql
stable
set search_path = public, search_pilot
as $$
with text_candidates as (
  select d.course_id,
         row_number() over(order by ts_rank_cd(d.search_tsv, websearch_to_tsquery('english', p_query)) desc, d.course_id) as rnk
  from search_pilot.course_documents d
  where d.publication='published'
    and (p_country is null or d.country_code=p_country)
    and (p_level is null or d.level_code=p_level)
    and (coalesce(trim(p_query),'')='' or d.search_tsv @@ websearch_to_tsquery('english', p_query))
  order by ts_rank_cd(d.search_tsv, websearch_to_tsquery('english', p_query)) desc, d.course_id
  limit 80
),
vector_candidates as (
  select cv.course_id,
         row_number() over(order by cv.embedding <=> p_query_embedding) as rnk
  from search_pilot.course_vectors cv
  join search_pilot.course_documents d on d.course_id=cv.course_id
  where p_query_embedding is not null
    and d.publication='published'
    and (p_country is null or d.country_code=p_country)
    and (p_level is null or d.level_code=p_level)
  order by cv.embedding <=> p_query_embedding
  limit 80
),
fused as (
  select coalesce(t.course_id,v.course_id) as course_id,
         t.rnk as tr,
         v.rnk as vr,
         (coalesce(1.0/(60+t.rnk),0) + coalesce(1.0/(60+v.rnk),0))::double precision as score
  from text_candidates t full outer join vector_candidates v using(course_id)
)
select d.course_id,d.provider_name,d.canonical_title,d.level_code,f.score,f.tr,f.vr
from fused f
join search_pilot.course_documents d on d.course_id=f.course_id
order by f.score desc,d.canonical_title
limit least(greatest(coalesce(p_limit,20),1),50)
$$;

revoke all on function public.hybrid_search_query_embedding_pilot_v2_9(text,vector,character,text,integer) from public, anon, authenticated;
grant execute on function public.hybrid_search_query_embedding_pilot_v2_9(text,vector,character,text,integer) to service_role;
