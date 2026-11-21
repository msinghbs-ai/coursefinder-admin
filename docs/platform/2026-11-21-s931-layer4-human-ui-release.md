# Layer 4 human review UI, source-limitation pills and Platform guide (CF-247 s931, v2.16.76)

**Date:** 21 Nov 2026 · **Chat:** S1-Impl-Layer4-Human-UI-Guide · **Decision:** 279 (Platform Admin 21 Nov 2026 10:53 AEDT: D1 to D5) and the four fixes of 12:28 AEDT · **Spec:** `docs/design/2026-11-21-layer4-human-ui-and-guide-spec.md` §5 to §8 · **Pilot migration:** `20261121200000`

Everything below is live on deploy (standing mandate 21 Nov 2026 10:07): no flag, shadow period or delayed cutover.

## 1. What a reviewer sees now

| Part | Before | Now |
|---|---|---|
| Filter rows | A row of queue buttons, then a view row (Review by rule, Other views, By university, By kind, Grid, Decided) | One primary row: **Module / Field**, **University**, **Destination country**, **Source country** (entry requirements only), **Decision bucket**. The views and the AER order are under **Advanced filters (N)**; N counts what is set, each set filter shows as a removable chip |
| Card | Kind chip, Ref, hold reason, lifecycle, evidence, body, a bar of every choice | Z1 entity and Field line · Z4 why with **(i) Hint** · Z2 proposed value beside the live value · Z3 official source and stored copy · Z5 **Yes (Approve) / No (Reject) / Resubmit to Review with AI** and **More options** · Z6 folds: Progress and history, Evidence and course links, **Technical detail** (Ref, rule code, raw reason) |
| No (Reject) | Free-text reason | One-click reasons **Wrong course · Outdated year · Bad parse · Not offered**, plus free text |
| Resubmit | Separate recovery button (AER) or Re-read choice | The queue's own re-read path only (§5.4, D2): AER re-reads the stored copy with no AI ($0); descriptions show **AI budget today: US$x of US$y used** before confirm |
| Lock this value | — | On Yes where `decide` already accepts `set_manual_lock` (Edit & Approve of descriptions), off by default (D4) |
| Wording | proposed, active, superseded | Waiting for your decision · Live · Replaced by a newer read |

The mapping of every queue's server choices to the three decisions is `THREE_DECISIONS` in Pilot `src/lib/l4-rules.js` (spec §4.2). Every `data-l4-*` hook, view, bulk action, RPC and role gate is kept; the preservation map is `src/lib/l4-preservation-map.js`.

## 2. The four fixes (Platform Admin 21 Nov 2026 12:28)

| # | Found | Fix |
|---|---|---|
| 1 | **Approve all verified for provider** was typed with the queue's count (for example 207) while `decide` checks the provider's own verified count (for example 2), so every attempt was refused ("Type 2 in the box") | New read `public.admin_layer4_cd_provider_verified_v1(ref)` counts exactly as `decide` does. The button reads **Approve all verified for provider (N)** and fills N and a reason; one click on Confirm admits them |
| 2 | The queue labelled **University description** also served course descriptions (`cd:*` rule groups) | Module / Field lists **Course description** (rule groups `cd:*`) and **University description** (the rest) with their own counts; the card chip says which |
| 3 | Course descriptions whose page the course's own CRICOS or NZQA code proves stayed in Layer 4 as **Page match not clear enough** when the page was first found by an AI match or shared its address | md5-guarded edit of `security.course_description_machine_check_v1`: the code on the page is the proof. Every later check still applies. Rolled-back dry run: 19 waiting with a code proof; **12 admitted** in the migration through `course_description_machine_admit_v1`, 3 held (newer page copy), 4 held (refused word) |
| 5 | After a decision the queue count, the rail's **All in this queue** and **Card X of Y** could differ (205, 206, 207) | After every single or batch decision the rule groups are read again; all three counts come from that one read |

## 3. D3: read-only filter arguments

`security.layer4_rule_groups_v1` takes `source_country` and `country` (it already read `provider_id`); `public.admin_layer4_grid_read_v1` takes `source_country`. Both md5-guarded. `security.layer4_item_source_country_v1(kind, ref, country)` says whether a waiting entry-requirements item carries a row for that source country. Dry run: AER 1,144 waiting; Source country India 41, Hong Kong 36.

## 4. Source-limitation pills and the guide

- **FieldGap** (`src/ui-kit.jsx`, `gapStateOf` in `src/lib/field-gap.js`) on Course detail: Tuition, Intakes, English, course page. Precedence: In Layer 4 review > University-wide rule applies > No official website / course URL on file > Not stated on institution page; otherwise "—" with the empty reason label.
- **Add official URL** (D5): Curator (rank 3) and above, https only, on the provider's own host, saved through the course editor's `set_official_url`.
- **CoverageNotice**: countries from the live lookups (`public.admin_lookups_v1`).
- **Help › Platform guide**: Filters & badges (every filter on Layer 4, Courses, Providers, Entry requirements, English and Scholarships, and every badge), Layer 4 guide, four worked examples (W1 Charles Sturt University, W2 scholarships, W3 central English and Nursing holds, W4 no course address).

## 5. Tests and guardrails

- Pilot spec `cf-247-s931-layer4-human-ui-guide-contract` (7 tests): (a) map completeness, (b) three decisions per queue, (c) `gapStateOf` precedence, (d) guide filter coverage at the UI version, (e) UI map regenerated, the migration contract and a mocked browser test of the bar, chips, Advanced filters and the count sync.
- G3 75/48; manual locks 7,585; active cron unchanged (no job). Nothing dropped or deleted. Spend: none.
