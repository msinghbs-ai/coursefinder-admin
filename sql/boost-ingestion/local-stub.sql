-- CF-247 Boost: a minimal stand-in for the live objects 001 and 002 touch, for the local rehearsal ONLY (scripts/test-boost-e2e.sh point 0).
-- Never run on a Supabase project. Shapes copied from fxcwkweaxjtknorudmwp (read only, 16 Nov 2026 20:45 AEDT).
create schema if not exists pipeline; create schema if not exists security; create schema if not exists catalogue; create schema if not exists auth;
do $r$ begin if not exists (select 1 from pg_roles where rolname = 'anon') then create role anon; create role authenticated; create role service_role; end if; end $r$;
do $a$ begin if to_regprocedure('auth.role()') is null then execute $f$create function auth.role() returns text language sql as $b$ select nullif(current_setting('request.jwt.claim.role', true), '') $b$$f$; end if; end $a$;
create table if not exists pipeline.platform_toolset_settings (toolset_key text not null, key text not null, label text not null, help text, kind text not null,
  value jsonb not null, min_value numeric, max_value numeric, unit text, sort int, reason text, updated_by uuid, updated_at timestamptz, section text, used_by text,
  control_class text, home text, home_group text, primary key (toolset_key, key));
create or replace function security.pipeline_num_v1(p_key text, p_default numeric) returns numeric language sql stable as
  $$ select coalesce((select (value #>> '{}')::numeric from pipeline.platform_toolset_settings where toolset_key = 'pipeline' and key = p_key), p_default) $$;
create or replace function security.current_role_rank() returns int language sql as $$ select 0 $$;
create table if not exists pipeline.component_register (kind text, name text, layer text, area text, purpose text, status text, replaces text[], introduced_in text, unique (kind, name));
create table if not exists pipeline.manual_locks (entity text, entity_id uuid, field text);
create schema if not exists ref;
create table if not exists ref.countries (id uuid primary key default gen_random_uuid(), iso_alpha2 char(2) not null, iso_alpha3 char(3) not null, name text not null);
create table if not exists catalogue.providers (id uuid primary key, stable_key text not null, canonical_name text not null, country_id uuid not null references ref.countries(id));
create table if not exists catalogue.courses (id uuid primary key, stable_key text, provider_id uuid references catalogue.providers(id), canonical_title text, lifecycle_status text, study_load text check (study_load is null or study_load in ('full_time','part_time','both')),
  study_load_source text check (study_load_source is null or study_load_source in ('register','provider_page','manual')), study_load_evidence_id uuid, updated_at timestamptz not null default now());
