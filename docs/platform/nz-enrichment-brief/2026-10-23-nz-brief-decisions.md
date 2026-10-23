# NZ enrichment brief: decisions, Release 1 artefacts, binding checklist, item 5 spec

**Date:** 23 Oct 2026 (Fri, Melbourne), 20:42 (decisions) / 21:05 (this record)
**Follows:** `2026-10-23-nz-enrichment-brief-assessment.md` and `2026-10-23-nz-brief-verification-and-release-plan.md`
**Status:** plans and artefacts only. Nothing in this document has been applied, deployed or seeded. Every migration below is a draft to be dry-run on the live database, md5-checked and suite-tested through the normal process before it ships.
**Addendum 21:20 (section 8):** O1 closed by the Platform Admin's sources; C1 fully unblocked; build nits N1 to N5 applied to the artefacts below; final apply order in section 8.5.

---

## 1. Decision record

| Ref | Decision (Platform Admin, 20:42) | Acknowledgement |
|---|---|---|
| R1 | Release 1 (items 1, 2, 3, 4, 10, cadence): GO with conditions C1 to C4 | Accepted. Artefacts in section 3. |
| C1 | Item 1 seed data blocked until the Government's published standalone-polytechnic list is fetched and cited as `source_url`; resolve the Open Polytechnic classification against it. Table, re-check job and `transition.recheck_days` proceed. | Accepted. The official list was fetched at 21:00 (section 2): the Open Polytechnic **is one of the ten**, as the federation's anchor; my memory was wrong. The seed stays blocked on one more fetch: the 2026 decision on the four polytechnics left in Te Pūkenga. |
| C2 | NZQA directory cadence 30 → 7 days: a logged settings change, until 31 Mar 2027 | Accepted. Section 3.6. |
| C3 | Fee floors NZ 8,000 NZD, AU 8,000 AUD, CA 8,000 CAD as quarantine floors, column `min_annual_international` on `pipeline.coverage_admission_countries`. Review CA Layer 4 volume after 30 days; if flooding, fix per-term normalisation at the reader, not the floor. | Accepted. Section 3.4; open item in section 6. |
| C4 | 22-row disposition approved (20 withdraw to review, 2 keep flagged). Spot-check the MITO (8 identical) and Tai Poutini (5) clusters during the pass. | Accepted. The spot-check is a step in the migration's dry run (section 3.4): the stored page copy and quote for one MITO row and two Tai Poutini rows are read before the rows move. |
| R2 | Release 2 (RLS) after Release 1 lands, in the three-step order; results recorded before any migration | Accepted. |
| R3 | Release 3 (merge proposals) after Release 2 | Accepted. |
| R5 | Item 5 Option A approved with the three guards plus a fourth: 30-day retraction-rate monitoring on auto-filled `course_url`; tighten binding eligibility if take-backs spike | Accepted. Section 5. |
| R6 | Binding plan approved: 75% in 30 days, 85% by 31 Dec 2026; finder order partly-covered → programme discovery for universities and polytechnics → zero-binding last; the two hourly report lines go live before the push | Accepted. Section 4. |

---

## 2. C1 action: the Government source for the polytechnic list

### 2.1 Sources fetched (21:00, 23 Oct 2026)

| Source | What it states | Use |
|---|---|---|
| Ministry of Education, "Regional Polytechnics to be re-established from 2026", published 14 Jul 2025, updated 18 Jul 2025: https://www.education.govt.nz/news/regional-polytechnics-be-re-established-2026 | The ten re-established from 1 Jan 2026: Ara, EIT, NMIT, SIT, Toi Ohomai, Wintec, "Unitec Institute of Technology and Manukau Institute of Technology (MIT) – to merge and stand-alone", "Otago Polytechnic – to stand alone within the federation", "Universal College of Learning (UCOL) – to stand-alone within the federation", "The Open Polytechnic of New Zealand – to serve as the anchor polytechnic of the new federation". NorthTec, WITT, Whitireia/WelTec and Tai Poutini "will remain within Te Pūkenga … while they work toward financial and operational viability. Decisions on their future are expected in the first half of 2026." | **Primary `source_url` for the ten and for the four "remain in Te Pūkenga" rows** |
| TEC, "Update on vocational education and training – 26 September 2025": https://www.tec.govt.nz/strategic-initiatives/vocational-education-system/changes-to-the-vocational-education-and-training-vet-system/vet-updates/vet-update-26-september-2025 | Confirms the federation (Open Polytechnic anchor, with Otago Polytechnic and UCOL, each with its own council); the four "will have decisions made in the first half of 2026 about their future pathway"; Workforce Development Councils end at the end of 2026. No 2027 date given. | Secondary citation on the federation rows |
| TEC, "Ten institutes of technology and polytechnics announced": https://www.tec.govt.nz/news-and-consultations/ten-institutes-of-technology-and-polytechnics-announced | Page returned no content (noindex) | Not usable |
| Newsroom, 22 Jul 2026 (officials' warning on the reforms); Wellington.Scoop on Whitireia/WelTec | Not readable from here (robots / client error) | Not usable |

### 2.2 What this resolves, and what is still open

- **Resolved:** the Open Polytechnic is re-established on 1 Jan 2026 as the federation anchor (risk `re_established_2026`, note "federation anchor"). Otago Polytechnic and UCOL are standalone within the federation. Unitec and MIT merge into one standalone entity (two register codes, 6004 and 6010, one entity: the platform keeps both provider rows until the register merges them; the transition row notes the merger).
- **Resolved:** the brief's "~14" is right as entities: 10 standalone (11 register codes) + 4 remaining in Te Pūkenga = 14; the register's 17 `POLLY` rows add the two NZIST entity rows (6683 and 6044).
- **Resolved at 20:52 (addendum, section 8):** the 31 Mar 2026 Beehive release, the TEC NZIST page (20 Jul 2026) and the Ministry's VET redesign page give the 2026 decision: NorthTec, WITT and Whitireia and WelTec stand alone from 1 Jan 2027 (legally established 1 Oct 2026, Federation support); Tai Poutini transfers its operations to the Open Polytechnic from 1 Jan 2027; NZIST is disestablished on or before 31 Mar 2027. The seed below is the final one.

### 2.3 How `source_url` is cited

Each row of `pipeline.provider_transitions` carries `source_url` (the page), `source_quote` (the sentence copied from it), `as_at` (the page's publication date) and `decided_by` (the Platform Admin who approved the seed). A row with no `source_url` cannot be inserted (check constraint). The re-check job never changes `risk`; only a person does, with a new source.

Seed, final after the 20:52 addendum (**not applied**; ships as its own migration after the table):

| Provider (register code) | risk | note | source_url | as_at |
|---|---|---|---|---|
| Ara 6006, EIT 6007, NMIT 6011, SIT 6015, Toi Ohomai 6025, Wintec 6019 | `re_established_2026` | standalone from 1 Jan 2026 | education.govt.nz (14 Jul 2025) | 2025-07-14 |
| Unitec 6004, MIT 6010 | `re_established_2026` | merged into one standalone entity; two register codes until NZQA merges them | education.govt.nz | 2025-07-14 |
| Otago Polytechnic 6013, UCOL 6009 | `re_established_2026` | standalone within the federation | education.govt.nz; tec.govt.nz (26 Sep 2025) | 2025-07-14 |
| Open Polytechnic 6022 | `re_established_2026` | anchor of the federation | education.govt.nz; tec.govt.nz | 2025-07-14 |
| NorthTec 6012, WITT 6017, Whitireia and WelTec 6014 | `standalone_from_2027` | stand-alone from 1 Jan 2027; legally established 1 Oct 2026; Federation support; exits NZIST 1 Jan 2027 | beehive.govt.nz (31 Mar 2026); tec.govt.nz NZIST page (20 Jul 2026) | 2026-03-31 |
| Tai Poutini 6024 | `operations_transfer_2027` | operations transfer to Open Polytechnic from 1 Jan 2027; brand/domain migration expected; **recheck_days 14** (highest migration risk in the register) | beehive.govt.nz (31 Mar 2026); education.govt.nz VET redesign page | 2026-03-31 |
| NZIST 6683 | `nzist_entity` | disestablished on or before 31 Mar 2027 | education.govt.nz VET redesign page | 2026-03-31 |
| NZIST Work-Based Learning 6044 | `nzist_entity` | transitional entity, not a polytechnic; follows NZIST's disestablishment | education.govt.nz (14 Jul 2025) | 2025-07-14 |

---

## 3. Release 1 implementation artefacts (drafts; nothing applied)

Conventions for every migration: `-- Replaces:` and `-- Retires:` lines; `comment on table` for each new table; RLS on; catalogue row before `cron.schedule`; `component_register` rows; no drop or delete; every edit to a live function through `pg_temp.edit_once(sig, md5, edits)` with the md5 taken at build time (the md5s quoted below are the live ones at 20:50 on 23 Oct and must be re-checked before apply). Release bump, SOPs, change control and the full suite as usual.

### 3.1 Item 1: transition register and re-check (effort ½ day; dependency: C1 for the seed only)

`supabase/migrations/2026102xNNNNNN_cf247_nz_provider_transitions.sql`

```sql
-- CF-247 (Oct 2026). NZ brief decisions C1 (Platform Admin 23 Oct 2026 20:42): the NZ polytechnic transition is recorded per provider
-- from the Government's published list, with its source; a monthly job re-checks each flagged provider's website and re-runs the
-- source finder for it, because domains and brands move during the transition. C1 closed 23 Oct 2026 20:52 (Beehive 31 Mar 2026, TEC
-- NZIST page 20 Jul 2026, MoE VET redesign page): the seed ships as the next migration, every row with its Government source.
-- Replaces: nothing
-- Retires: nothing
create table pipeline.provider_transitions (
  provider_id uuid primary key references catalogue.providers(id) on delete cascade,
  -- addendum 20:52: standalone_from_2027 and operations_transfer_2027 added; the three 2027 standalones are not federation members
  risk text not null check (risk in ('none', 're_established_2026', 'standalone_from_2027', 'operations_transfer_2027', 'nzist_federation_until_2027', 'nzist_entity')),
  note text,
  recheck_days int check (recheck_days between 7 and 180),  -- per-provider override of transition.recheck_days (Tai Poutini 14)
  source_url text not null check (source_url ~* '^https://'),
  source_quote text,
  as_at date not null,
  decided_by uuid,
  last_checked_at timestamptz,
  last_check jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
comment on table pipeline.provider_transitions is 'CF-247 23 Oct 2026 (NZ brief C1): NZ providers in the polytechnic transition, each with the Government page it comes from (source_url, quote, as_at). risk is set by a person with a source; the monthly transition-recheck job only records last_check.';
alter table pipeline.provider_transitions enable row level security;
revoke all on pipeline.provider_transitions from public, anon, authenticated;

insert into pipeline.platform_toolset_settings(toolset_key, key, label, help, kind, value, min_value, max_value, unit, sort, section, used_by, reason)
values ('pipeline', 'transition.recheck_days', 'Transition: re-check every',
        'How often a provider in the NZ polytechnic transition has its website checked and its course source found again (Layer 1 › Providers › Transition).',
        'number', '30'::jsonb, '7', '180', 'days', 150, 'Job sizes', 'job transition-recheck', 'Platform Admin 23 Oct 2026 20:42: NZ brief Release 1')
on conflict (toolset_key, key) do nothing;

create or replace function security.transition_recheck_v1() returns jsonb
 language plpgsql security definer set search_path to '' as $f$
declare v_n int := 0; r record;
begin
  for r in select t.provider_id from pipeline.provider_transitions t
            where t.risk <> 'none'
              and coalesce(t.last_checked_at, 'epoch') < now() - make_interval(days => coalesce(t.recheck_days, security.pipeline_num_v1('transition.recheck_days', 30)::int))
            order by t.last_checked_at nulls first limit security.pipeline_num_v1('batch.transition_recheck', 5)::int loop
    -- the website check and the source finder already exist (worker modes site_check and source_find); this queues them
    perform security.site_check_enqueue_v1(r.provider_id, 'transition re-check');   -- existing enqueue, name to confirm at build
    perform security.source_find_enqueue_v1(r.provider_id, 'transition re-check');  -- existing enqueue, name to confirm at build
    update pipeline.provider_transitions set last_checked_at = now(), updated_at = now() where provider_id = r.provider_id;
    v_n := v_n + 1;
  end loop;
  return jsonb_build_object('rechecked', v_n);
end $f$;
revoke execute on function security.transition_recheck_v1() from public, anon, authenticated;

insert into pipeline.platform_toolset_settings(toolset_key, key, label, help, kind, value, min_value, max_value, unit, sort, section, used_by, reason)
values ('pipeline', 'batch.transition_recheck', 'Transition: providers re-checked a run', 'Providers the monthly transition re-check handles in one run.', 'number', '5'::jsonb, '1', '50', 'providers', 151, 'Job sizes', 'job transition-recheck', 'Platform Admin 23 Oct 2026 20:42')
on conflict (toolset_key, key) do nothing;

insert into pipeline.automation_catalogue(jobname, label, purpose, layer, schedule_text, owner_setting)
values ('transition-recheck', 'NZ transition re-check', 'Website check and course source found again for providers in the NZ polytechnic transition', 'Layer 1', 'daily at 03:41, each provider every transition.recheck_days', 'transition.recheck_days');
select cron.schedule('transition-recheck', '41 3 * * *', $$select security.transition_recheck_v1()$$);

insert into pipeline.component_register(kind, name, layer, purpose, status, replaces, introduced_in) values
 ('table', 'pipeline.provider_transitions', 'Layer 1', 'NZ polytechnic transition per provider, with the Government source', 'active', '{}', '<version>'),
 ('function', 'security.transition_recheck_v1', 'Layer 1', 'Monthly re-check of transition providers', 'active', '{}', '<version>'),
 ('job', 'transition-recheck', 'Layer 1', 'Runs security.transition_recheck_v1 daily; each provider every transition.recheck_days', 'active', '{}', '<version>')
on conflict (kind, name) do nothing;
```

Notes: the two `*_enqueue_v1` names are placeholders for the existing enqueue paths of the `site_check` and `source_find` modes; their exact names are taken from the live catalogue at build time (no new worker mode). UI: a "Transition" column on Layer 1 › Providers for NZ, read-only, showing risk, note, recheck days and the source link. Seed migration (separate file, second in the apply order) is unblocked by the addendum; its rows are the section 2.3 table, each with `source_quote` copied from the cited page at build.

### 3.2 Item 2: domain-moved action (effort ½ day; ships with item 1)

```sql
-- CF-247. NZ brief Release 1 item 2: when a provider's website moves (NZIST transition), the bound course pages and course-list
-- sources move with it, keeping their identity proof and evidence, and are read again first in line. Platform Admin only, logged.
-- Replaces: nothing
-- Retires: nothing
create or replace function public.admin_provider_domain_moved(p_provider_id uuid, p_new_host text, p_reason text) returns jsonb
 language plpgsql security definer set search_path to '' as $f$
declare v_old text; v_pages int := 0; v_lists int := 0; v_reason text := btrim(coalesce(p_reason, ''));
begin
  if auth.uid() is null or coalesce(security.current_role_rank(), 0) < 6 then raise exception 'Platform Admin required' using errcode = '42501'; end if;
  if length(v_reason) < 4 then raise exception 'give a reason (kept in the log)'; end if;
  if p_new_host !~* '^[a-z0-9.-]+\.[a-z]{2,}$' then raise exception 'give the new host only, e.g. www.example.ac.nz'; end if;
  select lower(regexp_replace(website, '^https?://([^/]+).*$', '\1')) into v_old from catalogue.providers where id = p_provider_id;
  if v_old is null then raise exception 'the provider has no website to move from'; end if;
  if v_old = lower(p_new_host) then raise exception 'the website already is %: nothing to move', v_old; end if;  -- N5: no-op refused, nothing logged
  update pipeline.coverage_course_pages g
     set url = regexp_replace(g.url, '^(https?://)' || regexp_replace(v_old, '\.', '\\.', 'g'), '\1' || lower(p_new_host), 'i'),
         next_read_at = now(), read_attempts = 0, leased_until = null
   where g.course_id in (select id from catalogue.courses where provider_id = p_provider_id)
     and g.status in ('bound', 'ambiguous') and g.url ~* ('^https?://' || regexp_replace(v_old, '\.', '\\.', 'g') || '(/|$)');
  get diagnostics v_pages = row_count;
  update pipeline.provider_course_lists l
     set url = regexp_replace(l.url, '^(https?://)' || regexp_replace(v_old, '\.', '\\.', 'g'), '\1' || lower(p_new_host), 'i'), updated_at = now()
   where l.provider_id = p_provider_id and l.url ~* ('^https?://' || regexp_replace(v_old, '\.', '\\.', 'g') || '(/|$)');
  get diagnostics v_lists = row_count;
  perform set_config('cf.manual_edit', 'on', true);
  update catalogue.providers set website = 'https://' || lower(p_new_host), updated_at = now() where id = p_provider_id;
  insert into pipeline.admin_control_events(area, action, target, detail, actor)
  values ('layer1', 'provider_domain_moved', p_provider_id::text, jsonb_build_object('from', v_old, 'to', lower(p_new_host), 'pages', v_pages, 'lists', v_lists, 'reason', v_reason), auth.uid());
  return jsonb_build_object('from', v_old, 'to', lower(p_new_host), 'pages_moved', v_pages, 'lists_moved', v_lists);
end $f$;
revoke execute on function public.admin_provider_domain_moved(uuid, text, text) from public, anon;
grant execute on function public.admin_provider_domain_moved(uuid, text, text) to authenticated;
```

UI: Adapter builder › 1.1 Change website gains a tick "Move the course pages too" that calls this after the website check passes. Pages whose new address does not answer fall to `fetch_failed` and the page search takes over, as today. Contract test: the regex moves only the host, keeps the path and query, never touches `mismatch` pages, and the same host raises 'nothing to move' (N5).

### 3.3 Item 3: signatory authority from the NZQA list (effort 1 day; dependency: the list page URL confirmed and robots-checked before build)

- **Layer 1:** a new `layer1_source_operations` row, "NZQA Code of Practice signatory list", `ingestion_cadence_days` 7, `expected_count_kind` 'signatory_rows', authority domain nzqa.govt.nz. The list URL is confirmed at build (the NZQA site moved its Code pages in 2024; the exact address is taken from the live site and checked against robots.txt, as every Layer 1 source is).
- **Worker v0.44.0:** `nz_cop` mode gains `kind: 'list'`: reads the stored list page, returns `{provider_name, nzqa_code?, signed_at?}` rows; recorded in `pipeline.nz_cop_reads` with `reader = 'list-v1'`.
- **Migration:**

```sql
-- Replaces: nothing (security.nz_cop_apply_v1 edited in place, md5-guarded)
-- Retires: nothing
alter table pipeline.nz_cop_status add column basis text not null default 'provider_page' check (basis in ('provider_page', 'signatory_list')),
                                    add column as_at date;
create table pipeline.nz_cop_list_rows (provider_code text, provider_name text not null, signed_at date, read_at timestamptz not null default now(), path text not null, primary key (provider_name, path));
comment on table pipeline.nz_cop_list_rows is 'CF-247 Oct 2026 (NZ brief item 3): rows of the NZQA Code of Practice signatory list page, one row per signatory per read; the register fact for enrols_international.';
alter table pipeline.nz_cop_list_rows enable row level security;
-- security.nz_cop_apply_v1 (live md5 b3be6eb8e63cddd2d23f9cffdd221c89 at 20:50 23 Oct): the list decides first
select pg_temp.edit_once('security.nz_cop_apply_v1()', '<md5 at build>', array[
  array[$o$           case when s.signatory then true when s.explicit_no then false when s.nzqa_type = 'UNI' then true end val,$o$,
        $n$           -- N4: a list row matched by provider_code applies; a list row older than 45 days is ignored here (the provider page decides);
           -- a name-only match never applies here: it becomes a Layer 4 proposal (see below)
           case when l.provider_code is not null then true when s.signatory then true when s.explicit_no then false end val,$n$],
  array[$o$           case when s.signatory then 'NZQA Code of Practice signatory' when s.explicit_no then 'NZQA Code of Practice: not a signatory'
                when s.nzqa_type = 'UNI' then 'NZQA Code of Practice: NZ university (must be a signatory to enrol international students; Platform Admin 20 Oct 2026)' end basis$o$,
        $n$           case when l.provider_code is not null then 'NZQA Code of Practice signatory list (' || l.read_at::date || ')' when s.signatory then 'NZQA Code of Practice signatory'
                when s.explicit_no then 'NZQA Code of Practice: not a signatory' end basis$n$],
  array[$o$      join catalogue.providers p on p.id = r.provider_id$o$,
        $n$      join catalogue.providers p on p.id = r.provider_id
      left join lateral (select x.provider_code, x.read_at from pipeline.nz_cop_list_rows x
                          where x.provider_code = s.provider_code
                            and x.read_at > now() - make_interval(days => security.pipeline_num_v1('nz.cop_list_max_age_days', 45)::int)
                          order by x.read_at desc limit 1) l on true$n$]]);

-- N4: name-only matches become proposals for a person (never applied here); a stale list is logged, not silently held
create or replace function security.nz_cop_list_proposals_v1() returns int
 language plpgsql security definer set search_path to '' as $f$
declare v_n int := 0;
begin
  insert into pipeline.layer4_review_items(entity_type, entity_id, field_code, evidence_id, before_value, proposed_value, layer2_state, layer3_state, status, escalation_reason, change_control_ref)
  select 'providers', p.id, 'enrols_international', null, to_jsonb(p.enrols_international), 'true'::jsonb, 'proposed', 'none', 'open',
         'NZQA signatory list names "' || x.provider_name || '" (name match only, no code): confirm it is this provider', 'CF-CHG-20260915-247 NZ brief item 3 (N4)'
    from pipeline.nz_cop_list_rows x
    join catalogue.providers p on security.provider_name_matches_v1(x.provider_name, p.canonical_name) and security.coverage_country(p.id) = 'NZ'
   where x.provider_code is null and x.read_at > now() - make_interval(days => security.pipeline_num_v1('nz.cop_list_max_age_days', 45)::int)
     and not exists (select 1 from pipeline.layer4_review_items l where l.entity_type = 'providers' and l.entity_id = p.id and l.field_code = 'enrols_international' and l.status = 'open');
  get diagnostics v_n = row_count;
  if not exists (select 1 from pipeline.nz_cop_list_rows x where x.read_at > now() - make_interval(days => security.pipeline_num_v1('nz.cop_list_max_age_days', 45)::int)) then
    insert into pipeline.admin_control_events(area, action, target, detail, actor)
    values ('layer1', 'nz_cop_list_stale', 'NZ', jsonb_build_object('note', 'no signatory list read within nz.cop_list_max_age_days; provider pages decide until the next read'), null);
  end if;
  return v_n;
end $f$;
revoke execute on function security.nz_cop_list_proposals_v1() from public, anon, authenticated;
insert into pipeline.platform_toolset_settings(toolset_key, key, label, help, kind, value, min_value, max_value, unit, sort, section, used_by, reason)
values ('pipeline', 'nz.cop_list_max_age_days', 'NZQA signatory list: valid for', 'A signatory list read older than this no longer decides; the provider''s own register page decides until the next list read (logged).', 'number', '45'::jsonb, '7', '120', 'days', 152, 'Job sizes', 'job nz-cop', 'NZ brief item 3 (N4), 23 Oct 2026')
on conflict (toolset_key, key) do nothing;
```

Effect: the eight universities move from the 20 Oct decision basis to a register fact once their codes appear on the list; a provider on neither the list nor its page as a signatory keeps "No only when stated" (a blank is never a No). The hard filter stays: `enrols_international = false` or null never shows as open to international students. `security.provider_name_matches_v1` is the existing name matcher from Layer 1 (name confirmed at build). `security.nz_cop_list_proposals_v1()` is called by `nz_cop_fire_v1` after each apply.

### 3.4 Item 4: fee floor (effort 1 day; dependency: live md5s of both admission functions)

```sql
-- CF-247. NZ brief decisions C3 and C4 (Platform Admin 23 Oct 2026 20:42). An international fee on an annual basis below the country's
-- floor is quarantined: it goes to Layer 4 with the reason and is not shown until a person decides. Never rejected, never dropped.
-- Replaces: nothing (public.svc_fee_ai_record and security.coverage_apply_course_v1 edited in place, md5-guarded)
-- Retires: nothing
alter table pipeline.coverage_admission_countries add column min_annual_international numeric;
comment on column pipeline.coverage_admission_countries.min_annual_international is 'Floor for an international fee on an annual basis, in the country''s currency; below it the fee is quarantined to Layer 4 (NZ brief C3, 23 Oct 2026). Null: no floor (shown as a warning on Settings › Pipeline settings).';
update pipeline.coverage_admission_countries a set min_annual_international = 8000, updated_at = now()
  from ref.countries k where k.id = a.country_id and k.iso_alpha2 in ('NZ', 'AU', 'CA');
insert into pipeline.admin_control_events(area, action, target, detail, actor) values
 ('toolsets', 'setting', 'pipeline.min_annual_international', jsonb_build_object('NZ', 8000, 'AU', 8000, 'CA', 8000, 'reason', 'Platform Admin 23 Oct 2026 20:42: NZ brief C3, quarantine floors'), '<applier uuid, verified at build>');  -- N3

create or replace function security.fee_below_floor_v1(p_course_id uuid, p_amount numeric, p_basis text) returns numeric
 language sql stable security definer set search_path to '' as $f$
  -- returns the floor when the fee is below it (annual basis only), else null
  select a.min_annual_international from catalogue.courses c join catalogue.providers p on p.id = c.provider_id
    join pipeline.coverage_admission_countries a on a.country_id = p.country_id
   where c.id = p_course_id and coalesce(p_basis, 'annual') = 'annual' and a.min_annual_international is not null and p_amount < a.min_annual_international
$f$;

-- (a) AI fee reader: public.svc_fee_ai_record (live md5 87f3a16a63d691b3195ee1ab857fe7c7 at 20:50): the outcome case gains a first branch
--     "when security.fee_below_floor_v1(x.course_id, x.yearly, 'annual') is not null then 'review'" with v_note 'below the country floor';
--     the Layer 4 item's escalation_reason reads 'international fee below the country floor (<currency> <floor> a year)'.
--     Exact old/new strings are copied from the live definition at build time (the case expression spans several lines).
-- (b) adapter path: security.coverage_apply_course_v1 (live md5 0f3beaac5ed5d4f2ded8a125f569cdfc at 20:50): after the
--     'positive fee amount required' check, if security.fee_below_floor_v1(p_course_id, amount, fee_basis) is not null the row is inserted
--     with status 'review' and a pipeline.layer4_review_items row (field_code 'provider_current_tuition', escalation_reason as above) instead
--     of status 'active'.

-- C4: the 22 NZ rows below NZ$8,000 (all adapter-read, each the course's only fee row)
create temp table _floor on commit drop as
select f.id, p.canonical_name provider, c.canonical_title course, f.amount, f.evidence_id
  from catalogue.course_fees f join catalogue.courses c on c.id = f.course_id join catalogue.providers p on p.id = c.provider_id
  join ref.countries k on k.id = p.country_id
 where k.iso_alpha2 = 'NZ' and f.audience = 'international' and f.status = 'active' and f.basis = 'annual' and f.amount < 8000;
-- keep flagged (2): English-language certificates, plausible
insert into pipeline.layer4_review_items(entity_type, entity_id, field_code, evidence_id, before_value, proposed_value, layer2_state, layer3_state, status, escalation_reason, change_control_ref)
select 'courses', f.id, 'provider_current_tuition', x.evidence_id, null, jsonb_build_object('amount', x.amount), 'admitted', 'none', 'open',
       'international fee below the country floor (NZ$8,000 a year); kept live, flagged (short English course)', 'CF-CHG-20260915-247 NZ brief C4'
  from _floor x join catalogue.course_fees f on f.id = x.id where x.provider in ('New Zealand College of Chinese Medicine Limited', 'University of Waikato');
-- withdraw to review (20): off the website until decided; restored on approval
update catalogue.course_fees f set status = 'review', updated_at = now()
  from _floor x where f.id = x.id and x.provider not in ('New Zealand College of Chinese Medicine Limited', 'University of Waikato');
insert into pipeline.layer4_review_items(entity_type, entity_id, field_code, evidence_id, before_value, proposed_value, layer2_state, layer3_state, status, escalation_reason, change_control_ref)
select 'courses', f.id, 'provider_current_tuition', x.evidence_id, jsonb_build_object('amount', x.amount, 'status', 'active'), jsonb_build_object('amount', x.amount, 'status', 'review'), 'withdrawn', 'none', 'open',
       'withdrawn to review: international fee below the country floor (NZ$8,000 a year)', 'CF-CHG-20260915-247 NZ brief C4'
  from _floor x join catalogue.course_fees f on f.id = x.id
 where x.provider not in ('New Zealand College of Chinese Medicine Limited', 'University of Waikato');
-- N3: the actor is the person applying the migration; the uuid is re-verified against auth.users at build (migrations run without a JWT, so auth.uid() is null)
insert into pipeline.admin_control_events(area, action, target, detail, actor)
values ('layer4', 'fee_floor_pass', 'NZ', jsonb_build_object('withdrawn', 20, 'kept_flagged', 2, 'reason', 'Platform Admin 23 Oct 2026 20:42: NZ brief C4'), '<applier uuid, verified at build>');
```

F2 (21:00): the C4 pass is NZ-only. The 109 AU and 66 CA annual international fees under the new floor stay live until they are read again, because the guarded edits apply at admission only; they are reviewed deliberately after the CA per-term normalisation work (open item O6). Build check: the adapter path inserts `basis` as `nullif(btrim(p_payload->>'fee_basis'), '')`, which can be null; before apply, the share of adapter-read international fees with a null basis is measured per country, and `fee_below_floor_v1` is called with the real basis (a null basis is not treated as annual; it is logged as a gap instead).

Dry-run steps (C4 spot-check): before the rows move, the dry run prints, for one MITO row and two Tai Poutini rows, the stored page copy's fee line and the adapter's quote, so the Platform Admin sees whether the figure is the domestic fee; the result is recorded in change control with the release. Settings UI: the country row on Settings › Pipeline settings shows the floor with its currency; the website is unaffected (a `review` row is not returned, as today). G3: none.

### 3.5 Item 10: NZ code proof for English and intakes (effort 1 hour; no migration)

NZ pages bound by their programme code carry the proof label `cricos_code` (the generic "found by code" basis). The NZ identity lists for `english` and `intakes` hold `nzqa_code` but not `cricos_code`, so 79 English and 88 intake gaps are blocked ("page proof (cricos_code) not admitted for this field").

Settings writes (logged through the existing path, run as the Platform Admin on Settings › Identify the page, or as SQL):

```sql
select public.admin_pipeline_settings_write('identity.attribute', jsonb_build_object('country', 'NZ', 'attribute', 'english',
  'identities', '["adapter_code","adapter_title","degree_name","exact_title","nzqa_code","cricos_code","title_level","host_page","manual"]'::jsonb,
  'reason', 'NZ brief Release 1 item 10 (Platform Admin 23 Oct 2026 20:42): a page bound by its programme code proves English for NZ'));
select public.admin_pipeline_settings_write('identity.attribute', jsonb_build_object('country', 'NZ', 'attribute', 'intakes',
  'identities', '["adapter_code","adapter_title","degree_name","exact_title","nzqa_code","cricos_code","title_level","host_page","manual"]'::jsonb,
  'reason', 'NZ brief Release 1 item 10 (Platform Admin 23 Oct 2026 20:42): a page bound by its programme code proves intakes for NZ'));
```

UI (`src/PipelineSettings.jsx`): the IDENTITIES label map shows `cricos_code` as "Course code on the page (CRICOS in AU; NZQA / programme code in NZ)" for NZ rows. No column or value rename.

### 3.6 C2: NZQA directory cadence 30 → 7 days (no migration; logged)

Done on Layer 1 › Source operations (the Platform Admin changes the cadence with a reason), or as SQL through the same logged path:

```sql
update pipeline.layer1_source_operations
   set ingestion_cadence_days = 7, verification_cadence_days = 7, updated_by = auth.uid(), updated_at = now(),
       change_reason = 'Platform Admin 23 Oct 2026 20:42 (NZ brief C2): weekly until 31 Mar 2027 during the NZIST transition. Previous: ' || change_reason
 where source_id = '<NZQA provider directory source_id, re-verified at build>';  -- live value e410b159-614e-45ef-b8f4-902c7b516257 at 20:50 23 Oct (N3)
insert into pipeline.admin_control_events(area, action, target, detail, actor)
values ('layer1', 'cadence', 'NZQA provider directory', jsonb_build_object('before_days', 30, 'after_days', 7, 'until', '2027-03-31', 'reason', 'NZ brief C2'), auth.uid());
```

A reminder entry in the runsheet: revert to 30 days after 31 Mar 2027 unless the transition is extended. `nz.cop_window_days` (3) stays: the signatory reader follows each weekly capture within three days.

### 3.7 Release 1 summary

| Item | Migration | Worker | Cron | Settings | Effort | Blocked by |
|---|---|---|---|---|---|---|
| 1 transition register | yes (table, function, job); seed separate | no | `transition-recheck` daily 03:41 | `transition.recheck_days`, `batch.transition_recheck` | ½ day | C1 for the seed |
| 2 domain moved | yes (one function) + UI | no | no | no | ½ day | ships with 1 |
| 3 signatory list | yes (columns, table, apply edit) + Layer 1 source | v0.44.0 | existing | new source weekly | 1 day | list URL confirmed |
| 4 fee floor | yes (column, function, two guarded edits, C4 pass) + UI | no | no | floors per country | 1 day | md5s at build |
| 10 NZ proof | no (two logged settings writes) + UI label | no | no | identity.attribute NZ | 1 hour | — |
| C2 cadence | no (logged change) | no | no | source cadence | 10 min | — |

G3 check across all six: no change to `website_*`, `api.*`, `zoho_*` or the shape of any table they read; new columns on pipeline tables only; `enrols_international` keeps its values with a better basis. Confirmed: no consumer-API change.

---

## 4. Pre-binding-push checklist (R6)

Order of events: lines live → baseline recorded → finder runs.

| # | Step | How | Done when |
|---|---|---|---|
| 1 | Binding snapshot table and function | `pipeline.binding_snapshots(at, country_code, courses, bound, bound_24h)` (commented, RLS on) written hourly by `security.binding_snapshot_v1()` from `catalogue.courses` × `pipeline.coverage_course_pages` (status `bound`); catalogued job `binding-snapshot` at :58 | first row present |
| 2 | Hourly report gains two lines | The hourly scheduled task's prompt reads the latest snapshot and reports "NZ courses with a bound page: n of m (x%)" and "Courses bound in the last 24 h: n (NZ n, AU n, CA n)" | one report shows both lines |
| 3 | Baseline recorded | The first snapshot after step 2 is copied into the change-control entry as the baseline: NZ 3,467 of 6,474 (53.5%) at 20:10 on 23 Oct; AU and CA figures taken at the same time | entry written and verified in a fresh clone |
| 4 | Finder budget check | Firecrawl daily budget by purpose (`svc_fc_spend`) and the OpenRouter balance read; the finder's map calls fit inside the day's share (one map per provider, 1 credit) | figures in the entry |
| 5 | Finder run order loaded | `pipeline.source_find_runs` queue seeded in the order below (a logged action, as a Read-pages task from Scheduled jobs so it shows on the Task manager) | task visible with its place in line |
| 6 | Gap engine cause check | After the first 24 h, the gap-cause snapshot's "no page" causes for NZ compared with the baseline (1,693 + 1,056) | reported in the hourly report |

Finder run order (the 83 partly-covered NZ providers, by unbound courses, then universities and polytechnics for programme discovery, then the 136 zero-binding providers last). The first 20, with bound/active courses ("finder ran" means a run exists; it is re-run with the step-carry-over finder, v0.40.2):

1. University of Waikato (117/278, finder ran) · 2. University of Auckland (348/458, finder ran) · 3. Victoria University of Wellington (169/273, finder ran) · 4. Massey University (166/265, finder ran) · 5. Lincoln University (104/199, finder ran) · 6. Southern Institute of Technology (120/207, finder ran) · 7. Eastern Institute of Technology (110/184, finder ran) · 8. NMIT (77/148, finder ran) · 9. Ara (108/178, finder ran) · 10. Wintec (77/144, finder ran) · 11. Toi Ohomai (93/156, finder ran) · 12. Otago Polytechnic (123/182, finder ran) · 13. University of Otago (195/252, finder ran) · 14. Whitireia and WelTec (65/116, finder ran) · 15. WITT (43/89, finder ran) · 16. Yoobee Colleges (17/52, finder ran) · 17. Unitec (52/80, finder ran) · 18. Future Skills Academy (15/36) · 19. New Zealand School of Education (23/42) · 20. People Potential (13/32).

The remaining 63 partly-covered providers (PTEs with 2 to 52 courses each) follow in the same order; the full list is produced by the query in the verification doc at run time so it reflects that day's binding. Universities and polytechnics in positions 1 to 15 and 17 are also the programme-discovery set (programme site maps or lists, worker modes `programme_discover` and `programme_read`), run after their finder pass.

Targets: 75% (about 4,855 bound) by 22 Nov 2026; 85% (about 5,500) by 31 Dec 2026. Measured from the baseline snapshot, never from a figure in a chat.

---

## 5. Item 5, Option A build spec (approved; not built)

**Purpose:** a course whose own page is proven gets that page's address in `course_url` when the field is empty, so the website and Zoho can show the link. No change to the consumer API shape: a nullable field is populated more often.

**Objects**

- `pipeline.course_url_fills` (course_id primary key, url, evidence_id, identity_basis, filled_at, retracted_at, retract_reason), commented, RLS on. One row per fill; a retraction closes it (never deleted).
- `security.course_url_fill_v1()`: the fill job, catalogued, daily at 02:23 (and callable from Read with AI's handoff so a newly bound page fills the same day).
- The fill is an admission: logged in `admin_control_events` (area `catalogue`, action `course_url_filled`, count per run), and each row keeps `evidence_id` so the page copy is the proof.

**The four guards**

| # | Guard | How it is enforced |
|---|---|---|
| 1 | Proven binding only | Source rows: `pipeline.coverage_course_pages` with `status = 'bound'`, `identity_basis is not null`, `read_status = 'read'`, `evidence_id is not null`; `mismatch` and `ambiguous` never qualify; the address written is the page's `candidates->>'final_url'` (after redirects), else `url` |
| 2 | Manual locks honoured | `pipeline.manual_locks` (entity `course`, field `course_url`) excludes the course; a `course_url` a person set is never touched (the fill writes only where `course_url is null`, and the `manual_lock_guard` trigger keeps a locked value anyway) |
| 3 | Re-fill on binding change | When a course's binding changes (new `evidence_id` or `status` leaves `bound`), the job retracts the fill (`retracted_at`, reason `binding changed` / `page no longer bound`), empties `course_url` only if it still equals the filled value, and fills again from the new binding when it qualifies |
| 4 | 30-day retraction-rate monitoring | The query below runs in the hourly report and on Operations; if the 30-day retraction rate of filled values exceeds `course_url.max_retraction_pct` (setting, 1 to 20, 5), the fill job pauses itself (logged) and the Platform Admin tightens eligibility (for example, exclude `identity_basis in ('title_search', 'ai_match')`) before resuming |

**Retraction monitoring query** (the figure the hourly report prints as "course_url fills: n filled in 30 days, n taken back (x%)"):

```sql
-- N1 (addendum): counts fills, not grouped rows. The Platform Admin's message referred to "the corrected SQL above" without the text,
-- so this is the corrected form written at 21:20; it is confirmed at build.
with f as (select retracted_at, retract_reason from pipeline.course_url_fills where filled_at > now() - interval '30 days')
select count(*) filled,
       count(*) filter (where retracted_at is not null) retracted,
       round(100.0 * count(*) filter (where retracted_at is not null) / nullif(count(*), 0), 2) retraction_pct,
       (select jsonb_object_agg(coalesce(retract_reason, 'kept'), n) from (select retract_reason, count(*) n from f group by 1) r) by_reason
  from f;
```

**Settings:** `course_url.fill_enabled` (0/1, 1), `course_url.max_retraction_pct` (1 to 20, 5), `batch.course_url_fill` (100 to 5,000, 2,000). All on Settings › Pipeline settings.

**Dry run before apply:** count of courses that would fill per country (NZ expected about 2,560), with ten sample rows (course, page, basis) shown to the Platform Admin.

**One-line developer note** (for the website developer, section 13 of the next developer-pack issue, no API change): "`course_url` is now populated for courses whose official page the platform has verified; its meaning and type are unchanged."

**G3:** no shape change; the field already exists and is already read. The baseline is not re-taken.

---

## 6. Open items

| # | Item | Owner | Due |
|---|---|---|---|
| O1 | **Closed 20:52:** the Platform Admin supplied the Beehive release (31 Mar 2026), the TEC NZIST page (20 Jul 2026) and the Ministry's VET redesign page; seed finalised (section 2.3, addendum section 8) | — | closed |
| O2 | **CA floor 30-day review** (C3): Layer 4 volume for CA fees below CA$8,000 after 30 days of the floor; if flooding, fix per-term and per-credit normalisation in the fee reader (worker), not the floor | Claude, hourly report flags it; Platform Admin decides | 30 days after Release 1 lands |
| O3 | **Item 5 retraction-rate check at 30 days:** the monitoring query's figure after 30 days of fills; tighten eligibility if above `course_url.max_retraction_pct` | Claude, hourly report; Platform Admin decides | 30 days after the fill job's first run |
| O4 | NZQA directory cadence back to 30 days after 31 Mar 2027 unless the transition is extended (C2) | Platform Admin | 1 Apr 2027 |
| O5 | Signatory list page URL confirmed and robots-checked (item 3 dependency) | Claude, at build | before Release 1 build |
| O6 | **AU/CA sub-floor rows (F2):** the 109 AU and 66 CA annual international fees under the 8,000 floor stay live until re-read; review them deliberately after the CA per-term normalisation (O2), not as part of the NZ C4 pass | Platform Admin decides; Claude lists them | with O2 |

---

## 8. Addendum, 23 Oct 2026 21:20: O1 closed, C1 fully unblocked, build nits N1 to N5

### 8.1 Sources supplied by the Platform Admin (20:52)

| # | Source | What it states | Used for |
|---|---|---|---|
| 1 | Beehive, Minister Simmonds, 31 Mar 2026: https://www.beehive.govt.nz/release/new-chapter-remaining-four-polytechnics-2027 | NorthTec, WITT, Whitireia and WelTec stand alone from 1 Jan 2027 with Federation support; Tai Poutini transfers its operations to The Open Polytechnic of New Zealand from 1 Jan 2027 | `source_url` for the four rows |
| 2 | TEC NZIST page, updated 20 Jul 2026 | The three legally established 1 Oct 2026 by Orders in Council, operational 1 Jan 2027; NZIST disestablished by 31 Mar 2027 | second citation for the three standalones |
| 3 | Ministry of Education, redesign-of-VET page | Tai Poutini transfer confirmed; NZIST disestablished on or before 31 Mar 2027 | second citation for Tai Poutini; `source_url` for NZIST 6683 |

### 8.2 Schema change before the seed

`pipeline.provider_transitions.risk` gains `standalone_from_2027` and `operations_transfer_2027` (section 3.1 updated). The three 2027 standalones are **not** federation members and never carry `nzist_federation_until_2027`. A per-provider `recheck_days` override is added so Tai Poutini re-checks every 14 days (the global `transition.recheck_days` stays 30).

### 8.3 Final seed rows (section 2.3 updated; ships as the second migration in the apply order)

| Provider | risk | note | source | as_at | recheck |
|---|---|---|---|---|---|
| NorthTec 6012, WITT 6017, Whitireia and WelTec 6014 | `standalone_from_2027` | stand-alone from 1 Jan 2027; legally established 1 Oct 2026; Federation support; exits NZIST 1 Jan 2027 | Beehive 31 Mar 2026; TEC NZIST page | 2026-03-31 | setting (30) |
| Tai Poutini 6024 | `operations_transfer_2027` | operations transfer to Open Polytechnic from 1 Jan 2027; brand/domain migration expected | Beehive 31 Mar 2026; MoE VET redesign | 2026-03-31 | **14** |
| NZIST 6683 | `nzist_entity` | disestablished on or before 31 Mar 2027 | MoE VET redesign | 2026-03-31 | setting |
| the ten re-established, NZIST WBL 6044 | as in section 2.3 | | | | |

### 8.4 Build nits applied

| Nit | Where | Change |
|---|---|---|
| N1 | section 5 | Retraction-monitoring query rewritten to count fills (a 30-day CTE of fills; retraction % over fills; reasons as a sub-aggregate). The message said "the corrected SQL above" without the text, so the form in section 5 is Claude's and is confirmed at build. |
| N2 | section 3.4 | The second `layer4_review_items` insert (the 20 withdrawn rows) written out in full: before/proposed values, `layer2_state` 'withdrawn', reason text, change-control ref. |
| N3 | sections 3.4 and 3.6 | Hard-coded uuids replaced by `<applier uuid, verified at build>` and `<source_id, re-verified at build>`; the actor is the person applying the migration (migrations run without a JWT, so `auth.uid()` cannot be used there), checked against `auth.users` before apply. |
| N4 | section 3.3 | `nz_cop_apply_v1` applies a list row only when it matches by `provider_code` and is within `nz.cop_list_max_age_days` (45, a setting); older rows fall back to the provider-page basis; name-only matches become Layer 4 proposals through `security.nz_cop_list_proposals_v1()`, never applied; a stale list (no read within the window) is logged in `admin_control_events`. |
| N5 | section 3.2 | `admin_provider_domain_moved` raises "the website already is <host>: nothing to move" when the new host equals the current one, logging nothing; added to the contract test. |

### 8.5 Final apply order for Release 1 (nothing applied yet)

Each migration: dry run on the live database with its tail check → md5 of the edited functions re-taken and compared with the file → full suite (only the 4 known legacy failures) → apply → history md5 equals the file → merge → deployed workflows → change control in the four files, verified in a fresh clone.

| Order | Artefact | Kind | Depends on |
|---|---|---|---|
| 1 | `..._cf247_nz_provider_transitions.sql` (table with the final enum and `recheck_days`, `transition_recheck_v1`, settings, catalogue row, job) | migration | enqueue function names confirmed from the live catalogue |
| 2 | `..._cf247_nz_provider_transitions_seed.sql` (the rows of 8.3 and 2.3 with `source_quote`) | migration | 1; quotes copied from the cited pages at build |
| 3 | `..._cf247_provider_domain_moved.sql` + Adapter builder tick + contract test (incl. N5) | migration + UI | 1 (ships in the same release) |
| 4 | C2: NZQA directory cadence 30 → 7 (logged change on Layer 1 › Source operations) | settings | none |
| 5 | Item 10: two `admin_pipeline_settings_write` calls for NZ `english` and `intakes` + UI label | settings + UI | none |
| 6 | `..._cf247_fee_floor.sql` (column, `fee_below_floor_v1`, two md5-guarded edits, C4 pass with the MITO and Tai Poutini spot-check in the dry run) + Settings UI | migration + UI | live md5s of `svc_fee_ai_record` and `coverage_apply_course_v1` at build |
| 7 | Item 3: Layer 1 source row for the signatory list (URL confirmed, robots-checked) → worker v0.44.0 (`nz_cop` list read) → `..._cf247_nz_cop_signatory_list.sql` (columns, `nz_cop_list_rows`, `nz_cop_apply_v1` edit, `nz_cop_list_proposals_v1`, `nz.cop_list_max_age_days`) | source + worker + migration | O5; live md5 of `nz_cop_apply_v1` at build |
| 8 | Release bump (one release for 1 to 7, or two if item 3's list URL is not ready: items 1, 2, 4, 5, 6 first, item 3 after), SOPs, change control | release | all above |

Items 4 and 5 are settings-only and can go first on their own if the Platform Admin wants the NZ English and intake gaps moving before the migrations land.

---

## 7. Thread (every later comment and reply on this brief is appended here, in order)

### 23 Oct 2026, 20:49 — Platform Admin

> Next time any following comments and response dump it in the file as well.

### 23 Oct 2026, 20:52 — Claude

Understood. From here on, every comment on this thread and the reply to it are appended to this section with the time, committed through the normal process (admin repo `main`, change control untouched unless a decision changes), before the reply is sent in chat. Decisions that change the plan are also reflected in sections 1 to 6 so the document stays the single record; the thread keeps the wording as given.

### 23 Oct 2026, 20:52 — Platform Admin

> Addendum to the NZ brief decisions file (O1 CLOSED — C1 fully unblocked).
> SOURCES (fetched by Platform Admin via web, 23 Oct 2026): (1) beehive.govt.nz/release/new-chapter-remaining-four-polytechnics-2027 (Minister Simmonds, 31 Mar 2026): NorthTec, WITT, Whitireia and WelTec stand-alone from 1 Jan 2027 with Federation support; Tai Poutini transfers its operations to The Open Polytechnic of New Zealand from 1 Jan 2027. (2) tec.govt.nz NZIST page (updated 20 Jul 2026): the three legally established 1 Oct 2026 via Orders in Council, operational 1 Jan 2027; NZIST disestablished by 31 Mar 2027. (3) education.govt.nz redesign-of-VET page: Tai Poutini transfer confirmed; NZIST disestablished on or before 31 Mar 2027.
> SCHEMA CHANGE REQUIRED before the seed: the risk enum on pipeline.provider_transitions needs two new values — 'standalone_from_2027' and 'operations_transfer_2027' — because the three standalones are NOT federation members (do not use 'nzist_federation_until_2027' for them). Seed rows: NorthTec 6012, WITT 6017, Whitireia & WelTec 6014: 'standalone_from_2027', note "stand-alone from 1 Jan 2027; legally established 1 Oct 2026; Federation support; exits NZIST 1 Jan 2027", source beehive 31 Mar 2026, as_at 2026-03-31. Tai Poutini 6024: 'operations_transfer_2027', note "operations transfer to Open Polytechnic from 1 Jan 2027; brand/domain migration expected", sources beehive + MoE, as_at 2026-03-31. Set its transition.recheck_days to 14 — highest migration risk in the register. NZIST 6683: keep 'nzist_entity', note "disestablished on or before 31 Mar 2027", source MoE redesign page, as_at 2026-03-31.
> BUILD NITS to fix in the draft artefacts: N1. Replace the item-5 retraction monitoring query (counts grouped rows, not fills) with: [the corrected SQL above]. N2. Complete the literal '...' placeholder in the second layer4_review_items insert in section 3.4 — it is incomplete SQL today. N3. Re-verify the hardcoded UUIDs (actor 63ba56cb-..., layer1 source e410b159-...) at build time; the actor must be the person applying the migration. N4. Item 3 signatory join: provider_code matches admit automatically; name-match-only candidates go to Layer 4 as proposals, never auto-applied. A list row older than 45 days downgrades to the provider-page basis instead of holding silently. N5. admin_provider_domain_moved: raise a no-op exception when p_new_host equals the current host; add to the contract test.
> Update the decisions file (addendum section + seed table now unblocked), re-issue the Release 1 artefacts with N1–N5 applied, and report back with the final apply order.

### 23 Oct 2026, 21:20 — Claude

Done: section 8 (addendum) added; sections 2.2, 2.3, 3.1, 3.2, 3.3, 3.4, 3.6, 5 and 6 updated in place; O1 closed. N1's "corrected SQL above" was not in the message, so the query in section 5 is Claude's corrected form, confirmed at build. One note on N3: migrations applied through the management API run without a JWT, so the actor cannot be `auth.uid()`; it is the applier's uuid, verified against `auth.users` and written into the file before apply. The final apply order is section 8.5. Still nothing applied, deployed or seeded.

### 23 Oct 2026, 20:56 — Platform Admin

> Two pre-apply flags on the Release 1 artefacts (append to the thread):
> F1. Fix the stale header comment in ..._cf247_nz_provider_transitions.sql ("ships in a later migration once C1 clears") — C1 is closed; the comment is the audit trail.
> F2. Record a decision on existing AU/CA sub-floor rows: the C4 pass is NZ-only (22 rows); the 109 AU + 66 CA rows under the new floor stay live until re-read because the guarded edits only apply at admission. Decision: keep the pass NZ-only; add an open item to review AU/CA rows deliberately after the CA per-term normalisation work (O2). Also confirm at build that the adapter admission path passes the real fee basis (never null) into fee_below_floor_v1, since the floor checks annual basis only.
> Proceed with apply order 8.5 otherwise unchanged.

### 23 Oct 2026, 21:30 — Claude

F1 fixed in section 3.1 (the header now records C1's closure and its sources). F2 recorded: the pass stays NZ-only; open item O6 added for the 109 AU and 66 CA rows, tied to O2; the null-basis check is written into section 3.4 as a build step (the adapter path can insert a null basis today, so `fee_below_floor_v1` will be called with the real basis and a null basis is logged as a gap rather than treated as annual). Build of Release 1 starts now in the 8.5 order; each step is appended here as it lands.

### 23 Oct 2026, 21:55 — Claude (build progress, apply order 8.5)

| Step | State | Detail |
|---|---|---|
| 1 Transition table, re-check job, settings | built, dry-run clean | migration `20261023023000_cf247_nz_provider_transitions.sql`; the re-check queues the existing website check and the finder's "find again" (the same path as Course sources › Find again) |
| 2 Transition seed | built, dry-run clean (17 rows) | `20261023024000_cf247_nz_provider_transitions_seed.sql`; the MoE VET redesign page was fetched (published 1 Jan 2026, updated 26 Jun 2026) and quoted for Tai Poutini and NZIST; the Beehive page redirects the fetch, so its three rows carry the Platform Admin's summary as the quote, marked as such |
| 3 Domain-moved action | built, dry-run clean (same host refused: "the website already is www.auckland.ac.nz: nothing to move") | `20261023025000_cf247_provider_domain_moved.sql`; Adapter builder tick "Move the course pages too" |
| 4 C2 cadence | **applied and logged** | NZQA provider directory 30 → 7 days (ingestion and verification); next ingestion 30 Oct |
| 5 Item 10 | **applied and logged** | NZ `english` and `intakes` identities now include the page-code proof; UI label follows in the release |
| 6 Fee floor | built, dry-run clean | `20261023026000_cf247_fee_floor.sql`; quarantine status is the existing `unverified` (the website reads `active` only, so no constraint or G3 change); a NZ$3,000 test fee through the apply path went to Layer 4 with "international fee below the country floor (NZD 8,000 a year): NZD 3,000.00"; F2 basis check: 0 active international fees have a null basis |
| 7 Item 3 signatory list | not started | needs the list URL and worker v0.44.0; second release |
| 8 Release | v2.15.334 / 0.1.261 in the full suite now | SOPs 1.75 |

### 23 Oct 2026, 21:17 — Platform Admin

> Are you amending the same repo file?

### 23 Oct 2026, 21:18 — Claude

Yes. Every comment and reply since 20:49 has been appended to this one file (section 7, Thread), in the admin repo on `main`. The decisions themselves were also updated in place in sections 1 to 6 and the addendum (section 8). No other file holds the thread; the change-control entries in the four runsheet files only record releases.

### 23 Oct 2026, 21:29 — Claude (Release 1 live)

Release 1 is live as v2.15.334 (PR #676), apply order 8.5 steps 1 to 6 and 8. The four migrations were applied in order after the full suite (1,802 passed, only the 4 known legacy failures); each history md5 equals its file. Live: 17 transition rows (11 / 3 / 1 / 2), Tai Poutini re-check 14 days, floors NZ/AU/CA 8,000, 20 NZ fees quarantined and 2 flagged (22 Layer 4 items), job `transition-recheck` at 03:41. Step 7 (item 3, signatory list) is the next release. Correction: the progress entry above stamped "21:55" was written at about 21:15.

### 23 Oct 2026, 21:49 — Platform Admin (diagnostic and direction mandate)

> You are the senior data engineer for this platform. This is a DIAGNOSTIC AND DIRECTION
> mandate, not a build mandate. Produce findings with evidence (queries + results), a
> prioritised fix plan, and the questions in PART 6 answered or flagged. Nothing new is
> built, no UI is added, no SOP is written until the Platform Admin approves the plan.
> Follow-up prompts stop here: everything I would re-ask manually must become a standing
> job or report after this.
>
> ## PART 1 — Throughput: why admission is slow (numbers, not impressions)
>
> For each active worker mode (40-odd): runs/day, items processed, success %, median queue
> wait, and where its output lands. Then:
> 1. QUEUE AUTOPSY: which work queues empty, when, and WHY — no eligible work, blocked by
>    budget/lease/rate limit, or starved upstream. Empty is only healthy if the eligible
>    work is genuinely done; prove it per queue.
> 2. BOTTLENECK DECOMPOSITION: values admitted per day per field per country (NZ, AU, CA),
>    30-day trend. The Platform Admin has already raised job counts and AI limits and
>    admission stayed slow — so locate the real constraint: worker concurrency, Firecrawl
>    daily budget (svc_fc_spend vs cap), OpenRouter concurrency/cost caps, lease/lock waits,
>    upstream binding coverage, or review-queue drain. Show the stage that binds.
> 3. BUDGET HEADROOM: actual Firecrawl + OpenRouter daily usage vs limits for the last 30
>    days. If headroom exists while queues starve, the scheduler — not budget — is the bug.
>
> ## PART 2 — Retry pathology: wrong pages tried over and over
>
> 1. Distribution of read_attempts on course pages: how many URLs have failed 5+, 10+, 20+
>    times. List the top 20 by attempts with provider, URL, last failure cause.
> 2. For each: is the failure recorded as negative evidence? Does the source finder / page
>    search / AI match consume negative evidence to exclude or deprioritise it? Is there a
>    circuit breaker (attempts cap → different mode → human task)? If not, propose the
>    minimal one: escalating backoff, exclusion list consumed by all modes, and a
>    "stuck pages" weekly report instead of silent retries.
> 3. Prove learning: a provider where the finder previously chose wrong pages — did the
>    pattern change after failure data existed?
>
> ## PART 3 — Freshness: latest-year fees and requirements
>
> 1. Courses with multiple fee rows across years: which year is active, and what rule
>    chose it? Audit 50 random multi-year courses: is the latest fee_year active?
>    Find cases where an older year is live.
> 2. Same for English requirements and intakes: is there an as_at/supersession rule, and
>    does the reader prefer the newest when a page states multiple? Show mismatches.
> 3. Where the rule is wrong or absent, propose the fix as a READER behaviour with
>    provenance, not a one-off SQL patch.
>
> ## PART 4 — Config-over-code audit
>
> 1. Every hardcoded constant introduced into worker/edge function code in the last 90
>    days: value, file/function, and whether a platform_toolset_settings key exists.
>    List the ones a Platform Admin should control but can't.
> 2. Rule: from now on, any new tunable ships as a settings key with min/max/unit/section
>    (the existing convention), or the PR is rejected. State the acceptance check.
> 3. UI bloat inventory: admin components/panels added in 90 days, each with its named
>    human consumer and usage; flag those with no consumer or duplicated purpose for
>    retirement. No new panel without a consumer in the PR description.
> 4. Docs budget: count and 90-day growth of SOPs, user guides, Layer 4 escalation reasons.
>    Propose the consolidation rule (e.g. Layer 4 reasons capped to a canonical catalogue;
>    a new SOP must merge or retire an existing one; the repo docs folder needs an owner
>    and a quarterly prune job).
>
> ## PART 5 — Self-sustainability package (the point of this exercise)
>
> Convert my manual review patterns into standing platform jobs + reports. Propose, with
> effort: (a) a weekly self-audit job that regenerates the field coverage matrix, gap-cause
> breakdown, binding %, queue health and budget burn, written to a report table the admin
> app already renders; (b) a stuck-work report (circuit-breaker victims, Layer 4 aging,
> quarantine volume per country); (c) a freshness report (multi-year fee mismatches,
> stale as_at on requirements); (d) a country-readiness checklist generator — given a new
> country, list exactly which settings/identities/floors/calendars/currencies must be
> seeded, so onboarding is config + data, no code. CA is live: use it as the test case for
> "could we onboard a third country in a week with zero migrations?"
>
> ## PART 6 — Answer or flag these
>
> 1. Which queues does the Platform Admin mean by "getting empty"? (name them and show
>    their last 7 days)
> 2. Two or three concrete "wrong page tried over and over" examples (course, URL, attempts)
> 3. Two concrete "latest-year fee not picked" examples (course, rows, what's active)
> 4. CA onboarding: what is still NZ/AU-shaped in code that would block the next country?
> 5. Current Firecrawl + OpenRouter plan tiers and monthly spend vs cap.
> 6. Who uses the admin UI besides the Platform Admin? (determines how much UI config is
>    justified vs dangerous)
>
> ## OUTPUT
> 1. Findings 1–5 with evidence and the single bottleneck named.
> 2. Prioritised fix plan: QUICK WIN (this week, unblocks admission volume) vs
>    STRUCTURAL (circuit breakers, self-audit, config rule) vs LATER (UI prune, docs
>    budget enforcement). Effort on each.
> 3. The answers to Part 6, or the exact data you need from me.
> 4. One number to rule them all: proposed as the platform's standing health metric,
>    reported hourly, that tells me at a glance whether admission is healthy.
> Append this and the response to the thread file per the standing convention.

### 23 Oct 2026, 21:56 — Claude (diagnostic findings and fix plan; nothing built)

All evidence below came from read-only queries against the live project on 23 Oct 2026. Nothing was changed, built or scheduled.

#### The single bottleneck

**Course-page binding, held back by the course-page search scheduler, not by budget.** Values can only be admitted for courses that have a proven own page. The search lane that finds those pages picked **0** courses today while **12,916** search credits were left in its daily share and **2,816** courses were queued. Every downstream reader (fees, English, intakes) is starved of new pages, so raising job counts and AI limits could not move admission.

#### Finding 1 — Throughput

**1a. Per-mode outcomes are not measurable for more than a few hours.** Worker responses are kept about 6 hours and `edge_request_log` is capped at 50,000 rows, so there is no durable per-mode ledger of runs, items, success % and queue wait. That gap is itself finding 1a; the per-mode table the mandate asks for can only be produced once a ledger exists (quick win Q3).

**1b. Empty ticks, from the logs that do exist (calls per day):**

| Mode | Calls/day | Typical result |
|---|---|---|
| discover | ~1,334 | `providers []` |
| reextract | ~747 | nothing to do |
| cricos_peo | ~746 | nothing to do |
| link_search | ~737 | picked 0 |
| reidentify | ~587 | nothing to do |

**1c. Queue autopsy (live `admin_queue_watch` and picker gates):**

| Queue | Pending | State | Why it is empty or slow | Healthy? |
|---|---|---|---|---|
| Course-page search | 2,816 | picks 0 | gates, see table below | **No**: blocked by the scheduler |
| Source find | 1,596 | 1 per hour | one lease at a time, slow step | **No**: starved by design |
| Central AI | 99 | stuck | no progress in the window | **No** |
| Onboarding | 12 | stuck | no progress in the window | **No** |
| Companion read | — | failing | errors on every run | **No** |
| Fee / English / intake readers | low | "empty" | no new bound pages upstream | Empty, but **starved upstream**, not done |

**Course-page search gates (where the 2,816 sit):**

| Gate that holds them | Courses | Providers |
|---|---|---|
| Stopped: 30 searches with no correct page (`fc_search_stopped_v1`) | 1,483 | 22 |
| Not a Firecrawl target (`target_only`) | 1,130 | 136 |
| No active recipe | 128 | 33 |
| Provider unpublished | 16 | 1 |
| Eligible | 59 | 36 (all NZ) |

Even the 59 eligible courses were not picked: the focus gate (`enrich_focus_v1`) and site-list gate run after these, so the lane spends every tick on a list that filters to zero.

**1d. Bottleneck decomposition (weekly, what was admitted):**

| Week of | AU international fees admitted | NZ page bindings that stuck |
|---|---|---|
| 28 Sep | 3,574 | 2,128 |
| 5 Oct | 4,142 | 945 |
| 12 Oct | 746 | 141 |
| 19 Oct | 11 | 255 of 1,810 tried |

Admission fell with binding, a week ahead of it each time. CA has no meaningful admission series yet. Worker concurrency, OpenRouter concurrency and lease waits are not the binding stage: the AI lane was load-tested to 20 calls at once with no errors, and enrich AI spent only US$3.23 in 7 days.

**1e. Budget headroom:**

| Budget | Limit | Used | Headroom |
|---|---|---|---|
| Firecrawl daily total | 25,000 units | — | per share below |
| Course-search daily share | 13,000 | 21 Oct 15,962; 22 Oct 7,994; 23 Oct **0** (12,916 left at check) | large |
| Course-search monthly cap | 200,000 credits | 97,662 | 102,338 |
| Firecrawl balance | — | 338,002 above reserve | large |
| OpenRouter (enrich AI) | low-balance warning at US$10 | US$3.23 in 7 days (plus ~US$2 load test) | large |

Headroom exists while queues starve, so by the mandate's own test **the scheduler is the bug**.

#### Finding 2 — Retry pathology

- **Read attempts per URL are capped at about 3**, so no URL reaches 5+. The real retry problem is one level up: the **course** keeps getting new wrong pages. 2,555 courses have had 5–9 different pages tried and 27 have had 10 or more.
- **No negative evidence is kept.** A rejected page is not recorded anywhere that search, AI match or the source finder reads, so the same kind of wrong page (listings, theses, news) is offered again.
- **No circuit breaker beyond the blunt 30-search stop**, which then parks the whole provider (1,483 courses) instead of sending the course to a different mode or a human.
- **No proof of learning.** For SIT and Massey (below) the wrong-page pattern continued after earlier failures existed; nothing consumed them.

Proposed minimal breaker: (1) escalating backoff per course (1, 3, 7, 30 days), (2) a `page_rejections` exclusion list read by search, AI match and the finder, (3) after N distinct wrong pages the course moves to "needs a person" in the existing Layer 4 queue, and (4) a weekly stuck-pages report instead of silent retries.

#### Finding 3 — Freshness

- **Fees:** 397 AU and 121 NZ courses hold more than one active fee year; the website shows the newest, so most are cosmetic, but **34 AU courses have an older year live and no newer active row** (e.g. TAFE Queensland Diploma of Travel and Tourism Management; Charles Sturt Bachelor of Social Science (Psychology)). Canterbury Diploma in Commerce carries a 2028 fee that looks wrong. There is no supersession rule in the reader: a new year is added, the old one is not retired.
- **Intakes:** 100% have no year or date. **English:** 99.9% have no validity or as_at date. So there is no basis for "newest wins" today.
- **Fix as reader behaviour:** when the reader admits a fee for year Y with provenance, it marks older active years for the same course and basis `superseded` with a pointer to the new row; a fee year more than one year ahead goes to review. English and intake readers record `as_at` (the page's stated year or the read date) and prefer the newest stated year when a page lists several.

#### Finding 4 — Config over code

- Worker code holds **36 literal pool concurrencies, 49 literal timeouts and several `max_tokens` literals**; only 11 values read settings (`wsNum`). Most of these a Platform Admin should be able to tune (pool sizes, timeouts, tokens per call) but cannot.
- **Rule:** any new tunable ships as a `platform_toolset_settings` key with min, max, unit and section, or carries a `-- fixed:` / `// fixed:` comment saying why it is a safety constant. **Acceptance check:** a CI script scans the diff of `worker/` and `supabase/functions/` for new numeric literals in pool, timeout, limit, retry, batch and token positions and fails the PR unless the line reads a setting or has a `fixed:` comment.
- **UI:** 84 admin jsx files, 112 added or changed in 90 days. Only **one human** acted in the admin app in 30 days (the Platform Admin, 20,142 actions), so every panel's named consumer is the same person; the test for retirement becomes "used in 30 days" and "duplicates another panel".
- **Docs:** 770 admin-repo docs, all but one added in 90 days; 418 are versioned copies. RUNSHEET and NEXT-CHAT are about 1.07 MB each; the change-control file has 409 entries. SOPs are 79 KB with 154 history lines. Layer 4 has 22,422 items with **72 distinct reason shapes** and 112 pending.

#### Finding 5 — Self-sustainability package (proposed, with effort)

| Item | What it does | Effort |
|---|---|---|
| (a) Weekly self-audit job | Writes field coverage matrix, gap causes, binding %, queue health and budget burn to one report table; one existing report panel renders it | 1.5 days |
| (b) Stuck-work report | Circuit-breaker victims, Layer 4 ageing, quarantine volume per country | 1 day (after S1) |
| (c) Freshness report | Courses with an older fee year live, future-dated fees, missing as_at on English and intakes | 0.5 day |
| (d) Country-readiness generator | Given a country code, lists every setting, identity, floor, calendar, currency and admission row that exists or is missing | 1.5 days |

CA as the test case: CA has admission and floor rows, but the readers and identities were shaped on NZ and AU (see Q4), so the honest answer to "a third country in a week with zero migrations" is **not yet**: (d) will list the code-shaped blockers precisely.

#### Prioritised fix plan

| Priority | Fix | Why | Effort |
|---|---|---|---|
| **Quick win** Q1 | Review the `target_only` gate (1,130 courses) and replace the 30-search provider stop with a per-course stop | Releases up to 2,600 queued courses to the search lane that has unused credit | 0.5–1 day |
| Quick win Q2 | Stop empty-tick modes firing every minute: back off when the last N ticks found nothing | ~4,000 empty calls a day; frees worker slots | 0.5 day |
| Quick win Q3 | Durable per-mode outcome ledger (mode, items, ok, failed, wait, landed) kept 90 days | Makes Finding 1's table and the health metric possible | 1 day |
| Quick win Q4 | Clear the stuck central AI (99), onboarding (12) and failing companion read | Three queues at zero progress | 0.5 day |
| **Structural** S1 | Negative-evidence exclusion list plus escalating backoff plus hand-off to Layer 4 | Ends wrong-page loops | 2 days |
| Structural S2 | Fee-year supersession and as_at in the readers (Finding 3) | Latest year wins with provenance | 1.5 days |
| Structural S3 | Settings acceptance check in CI and move the top pool, timeout and token literals to settings | Config over code | 1.5 days |
| Structural S4 | Self-audit, stuck-work and freshness reports (a)–(c) | Replaces manual review prompts | 3 days |
| Structural S5 | Country-readiness generator (d), run on CA | Proves or disproves the one-week onboarding | 1.5 days |
| **Later** L1 | UI prune: retire panels unused in 30 days or duplicated | One human user | 1–2 days |
| Later L2 | Docs budget: split RUNSHEET and NEXT-CHAT, archive versioned copies, Layer 4 reasons capped to a canonical catalogue, a new SOP must merge or retire one, quarterly prune job | Docs at 1 MB per file | 2 days |

#### Part 6 answers

| # | Answer |
|---|---|
| Q1 | The "empty" queues are the **fee, English and intake readers** (starved: no new bound pages), and the **course-page search lane** (2,816 queued, picks 0). Last 7 days: course-search units 21 Oct 15,962, 22 Oct 7,994, 23 Oct 0; NZ bindings that stuck 255 of 1,810 tried this week; AU fees admitted 11 this week. A per-day 7-day table per queue needs the Q3 ledger, because detailed logs only go back about 6 hours. |
| Q2 | SIT Bachelor of Applied Management: 15 different pages tried. Massey Master of Veterinary Science: 14. SIT NZ Certificate in Retail: 13 (Auckland Bachelor of Urban Planning: 11; UTas Master of Fine Arts was bound to a figshare thesis). |
| Q3 | TAFE Queensland Diploma of Travel and Tourism Management and Charles Sturt Bachelor of Social Science (Psychology): an older fee year is the only active row; no newer year was admitted or the newer read was not applied. |
| Q4 | NZ/AU-shaped: identity rules that use NZQA and CRICOS codes; the CRICOS/PEO worker mode; country-specific fee basis words; directory sources that exist only for NZQA and CRICOS. These need to become per-country rows; (d) will list each. |
| Q5 | **Needs you.** Firecrawl and OpenRouter plan tiers and monthly caps are not stored in the platform. Known: Firecrawl daily budget 25,000 units, monthly search cap 200,000 (97,662 used), balance 338,002 above reserve; OpenRouter spend about US$5 in 7 days with a US$10 low-balance warning. Please send the two plan names and their monthly limits. |
| Q6 | Nobody else in practice: 9 accounts, 6 signed in within 30 days, but only the Platform Admin performed actions. UI config is therefore justified only where you use it; a wrong setting has no second reviewer, so range limits on every setting matter more than more panels. |

#### One number to rule them all

**Proven course pages per 24 hours that went on to admit at least one value**, reported hourly, with the target set as a setting. It moves only when binding works and the readers consume it, so it catches both today's failure (search picks 0) and any downstream stall. It needs the Q3 ledger to report it.

#### Asked of you

1. Approve, change or reorder the fix plan; nothing is built until you do.
2. The Firecrawl and OpenRouter plan tiers and monthly caps (Q5).

### 23 Oct 2026, 22:11 — Platform Admin (consolidated mandate) and 22:40 — Claude (plan)

The consolidated mandate (throughput, gap detection at hours, schema additions) supersedes the sequencing in the 21:56 entry above. Mandate and plan are in their own file by instruction: [2026-10-23-platform-throughput-gap-schema.md](2026-10-23-platform-throughput-gap-schema.md). Plan and estimate only; nothing built until approved.

### 23 Oct 2026, 22:24 — Platform Admin (hours-scale re-sequence) and 22:31 — Claude (sweep run)

Recorded in section 10 of [2026-10-23-platform-throughput-gap-schema.md](2026-10-23-platform-throughput-gap-schema.md). Sweep run live: 3,675 courses, 2,735 fee reads queued at once.
