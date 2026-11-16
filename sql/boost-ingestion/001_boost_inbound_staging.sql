-- CF-247 Boost ingestion, part 1: the staging table (DRAFT for a Pilot migration; NOT applied to fxcwkweaxjtknorudmwp by this change).
-- Platform Admin, 16 Nov 2026 20:31, Boost Program step 3, path B: no Layer 4 ingress function takes rows from an outside reader (read only check,
-- 16 Nov 2026 20:43 AEDT: only security.layer4_intervention_raise_v1, which raises interventions), so Boost results land in their own table and
-- are promoted from there by security.boost_promote_v1 (002).
-- To apply: copy into Pilot as supabase/migrations/<next version>_cf247_boost_inbound_staging.sql under the Pilot release contract
-- (rolled-back live dry run, guard spec, s32/s42/s57 green, release bump, admin documents). It runs on the parallel test database first
-- (scripts/test-boost-e2e.sh, point 3).
-- Replaces: nothing
-- Retires: nothing
-- G1: no new job (promotion is run by the Platform Admin in the quiet window, or later by a lane of coverage-lane-dispatch once
--     pipeline.field_execution_registry declares it). G2: the window and batch size are settings below. G3: no consumer API object is read or changed.

set local lock_timeout = '3s';

create table if not exists pipeline.boost_inbound_staging (
  id              bigint generated always as identity primary key,
  batch_id        text not null,
  item_key        text not null,
  lane            text not null check (lane in ('study_load', 'provider_accreditations', 'aer_entry', 'course_description', 'course_fees')),
  entity          text not null check (entity in ('course', 'provider')),
  entity_id       uuid not null,
  evidence_id     uuid,
  source_url      text,
  provider        text,                       -- the AI provider that answered (google, groq, mistral, openrouter); null when every step failed
  model           text,                       -- the one pinned model that answered: every row is bound to exactly one model
  prompt_id       text not null,
  prompt_version  text not null,
  prompt_sha256   text not null check (prompt_sha256 ~ '^[0-9a-f]{64}$'),
  selector        text,                       -- lean-sections-v3 when only a section selection was sent; null when the whole page was
  answer          jsonb,
  verdict         jsonb not null,             -- the worker's deterministic checks: ok, problems, quotes_checked
  worker_status   text not null check (worker_status in ('verified', 'rejected', 'failed')),
  attempts        jsonb not null default '[]'::jsonb,
  worker_at       timestamptz not null,
  loaded_at       timestamptz not null default now(),
  promotion_state text not null default 'staged'
                  check (promotion_state in ('staged', 'shadow', 'proposed', 'admitted', 'refused')),
  promotion_note  text,
  promoted_at     timestamptz,
  unique (batch_id, item_key)
);
comment on table pipeline.boost_inbound_staging is
  'CF-247 Boost (Platform Admin 16 Nov 2026 20:31): one row per item answered by the Boost Worker (free-tier failover chain), loaded from staging-boost/inbound. '
  'Every row names the one provider and model that answered. Nothing here is catalogue data: security.boost_promote_v1 decides, in the quiet window, '
  'what is admitted (only lanes and models in pipeline.boost_model_qualifications), proposed to the lane owner, kept as a shadow reading, or refused.';
create index if not exists boost_inbound_staging_state_idx on pipeline.boost_inbound_staging (promotion_state, lane);
create index if not exists boost_inbound_staging_entity_idx on pipeline.boost_inbound_staging (entity_id);

-- which (lane, provider, model) may be ADMITTED. Empty by design: a passing qualification never switches anything on by itself; the Platform Admin
-- adds a row (with a reason) after the model passes the lane's gate. Until then every verified row stays a shadow reading.
create table if not exists pipeline.boost_model_qualifications (
  lane         text not null check (lane in ('study_load', 'provider_accreditations', 'course_description', 'course_fees')),
  provider     text not null,
  model        text not null,
  qualified_by uuid,
  qualified_at timestamptz not null default now(),
  reason       text not null check (length(btrim(reason)) > 0),
  primary key (lane, provider, model)
);
comment on table pipeline.boost_model_qualifications is
  'CF-247 Boost: the (lane, provider, model) pairs whose verified answers security.boost_promote_v1 may admit. Rows are added only by the Platform Admin '
  'after the model passes that lane''s qualification; never by a job or a benchmark run. aer_entry is not a lane here: AER is admitted only by its own rule.';

-- settings (G2): the quiet window in Melbourne time and the rows promoted per transaction
insert into pipeline.platform_toolset_settings (toolset_key, key, label, help, kind, value, min_value, max_value, unit, sort, section, used_by, reason)
values
  ('pipeline', 'boost.quiet_window_start_hour', 'Boost promotion: quiet window starts (Melbourne hour)', 'Boost rows are promoted only from this hour (Melbourne time).',
   'number', to_jsonb(1), 0, 23, 'hour', 900, 'Boost', 'security.boost_promote_v1', 'CF-247 Boost, Platform Admin 16 Nov 2026 20:31 (01:00-05:00 AEDT)'),
  ('pipeline', 'boost.quiet_window_end_hour', 'Boost promotion: quiet window ends (Melbourne hour)', 'Boost rows are promoted only before this hour (Melbourne time).',
   'number', to_jsonb(5), 1, 24, 'hour', 901, 'Boost', 'security.boost_promote_v1', 'CF-247 Boost, Platform Admin 16 Nov 2026 20:31 (01:00-05:00 AEDT)'),
  ('pipeline', 'boost.promote_rows_per_run', 'Boost promotion: rows per run', 'Rows one promotion run settles, in one transaction.',
   'number', to_jsonb(1000), 1, 5000, 'rows', 902, 'Boost', 'security.boost_promote_v1', 'CF-247 Boost: 1,000 rows in one transaction under 5 s (harness point 3)')
on conflict (toolset_key, key) do nothing;

insert into pipeline.component_register (kind, name, layer, area, purpose, status, replaces, introduced_in) values
  ('table', 'pipeline.boost_inbound_staging', 'Layer 2', 'Boost', 'Boost Worker results waiting for promotion', 'active', '{}', 'boost-001'),
  ('table', 'pipeline.boost_model_qualifications', 'Layer 2', 'Boost', 'Models whose Boost answers may be admitted, per lane', 'active', '{}', 'boost-001')
on conflict do nothing;
