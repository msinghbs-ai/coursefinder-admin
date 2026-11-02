# Proposal — provider description limit 900 → 1,200 characters (held for approval)

**Status:** proposed, not applied. **Prepared under:** Platform Admin direction 2 Nov 2026 23:24 §1 Descriptions ("Prepare the 1,200-character setting adjustment with regression testing"; items recorded as proposed until approval is explicit).

## Why

The pilot read of Charles Darwin University's About page (2 Nov 16:16) gave four well-quoted sentences (210, 232, 231, 240 characters; 916 in all). It was held because the limit (`pipeline.pdesc.max_chars`) is 900. A limit of 1,200 allows five sentences of that length.

## What protects quality at 1,200

- Nothing in the path cuts a description (release `cf247-pdesc-page-choice`): the worker keeps sentences and quotes whole, and validation holds a sentence that is cut or ends in an ellipsis (`incomplete_sentence`).
- A read over the limit is held (`length`), never trimmed.
- The Website API returns the description column whole; Zoho does not carry it.
- Regression: CDU-shaped 916-character read passes whole to the projection at 1,200; 1,250 held; cut condition and ellipsis held.

## To apply (after approval)

Paste in the SQL editor, or approve and the Integration Controller applies it with the reason and control event below. It only changes a value of 900.

```sql
-- ---------------------------------------------------------------- 4 description length: 900 -> 1,200 characters
-- Authority: Platform Admin 2 Nov 2026 23:24 (admin docs/platform/nz-enrichment-brief/2026-11-02-overnight-continuous-delivery-direction-2324.md
-- §1 Descriptions: "Prepare the 1,200-character setting adjustment with regression testing. Preserve original source evidence. Avoid cutting
-- essential conditions or publishing fragments as complete descriptions."). Pilot evidence: Charles Darwin University's read of its About
-- page (2 Nov 2026 16:16) gave four well-quoted sentences of 210, 232, 231 and 240 characters, 916 in all, and was held at 900. 1,200 allows
-- five such sentences. Nothing is cut to fit: a longer description is held (rule length), a fragment is held (rule incomplete_sentence).
-- Only a value of 900 (the v2.15.406 default) is changed; any other value set by a person is left as it is.
do $len$
declare v_pa uuid; v_n int; v_now jsonb;
begin
  select value into v_now from pipeline.platform_toolset_settings where toolset_key = 'pipeline' and key = 'pdesc.max_chars';
  if v_now = to_jsonb(1200) then raise notice 'pdesc.max_chars already 1,200'; return; end if;
  select ur.user_id into v_pa from security.user_roles ur join security.roles r on r.code = ur.role_code
   where r.rank = 6 and r.status = 'active' and (ur.expires_at is null or ur.expires_at > now()) order by ur.user_id limit 1;
  update pipeline.platform_toolset_settings set value = to_jsonb(1200), updated_by = v_pa, updated_at = now(),
         reason = 'CF-247 Platform Admin 2 Nov 2026 23:24 (overnight direction §1 Descriptions): 1,200 characters (pilot: CDU 916 characters in 4 well-quoted sentences held at 900); nothing is cut to fit'
   where toolset_key = 'pipeline' and key = 'pdesc.max_chars' and value = to_jsonb(900);
  get diagnostics v_n = row_count;
  if v_n = 1 then
    insert into pipeline.admin_control_events(area, action, target, detail, actor)
    values ('toolsets', 'setting', 'pipeline.pdesc.max_chars', jsonb_build_object('before', 900, 'after', 1200,
            'reason', 'Platform Admin 2 Nov 2026 23:24, overnight direction §1 Descriptions'), v_pa);
  else
    raise notice 'pdesc.max_chars is % (set by a person), left as it is', v_now;
  end if;
end $len$;

```

Rollback: set `pdesc.max_chars` back to 900 on Settings › Pipeline settings with a reason.
