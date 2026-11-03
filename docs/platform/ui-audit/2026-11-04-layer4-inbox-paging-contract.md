# Layer 4 Inbox paging contract (how a kind plugs in)

**Date:** 4 November 2026 · **For:** SS-020 follow-up item 3 (Platform Admin approval 06:53, §1) and any new Layer 4 kind, first the human-assisted recovery interventions (branch `cf247-human-assisted-recovery`).
**Built on:** branch `cf247-l4-inbox-perf`, migration `20261104410000`, spec `s273`. Nothing here changes the consumer API.

## 1. What changes for the Inbox

- The Inbox no longer builds every item to show counts. `summary` and `universities` read counts per kind and university only.
- Items are read one page at a time, for one university or one kind, with the filters applied before any detail is built.
- Expensive evidence is loaded only for the items on screen (`detail` action), and AER rows only when their card is on screen.
- Page sizes are settings (Settings › Pipeline settings, section Layer 4 Inbox), not numbers in code.
- Item identity stays `(kind, ref)`. The cursor stays `(o, created_at, kind, ref)` (UR-04). Decisions, choice keys, labels, ranks and effects are unchanged.

## 2. How a new kind plugs in

A kind outside the built-in list registers one row (mode `kind`) in `pipeline.layer4_inbox_kind_hooks`:

| Column | Function signature (schema `security`, security definer) | Required |
|---|---|---|
| `kind` | the kind key, for example `intervention` (must not be a built-in kind) | yes |
| `kind_fn` | `…_kind_v1() returns jsonb` | yes |
| `counts_fn` | `…_counts_v1() returns jsonb` | yes |
| `page_fn` | `…_page_v1(p_args jsonb) returns jsonb` | yes |
| `detail_fn` | `…_detail_v1(p_ref text) returns jsonb` | no |
| `decide_fn` | `…_decide_v1(p_ref text, p_choice text, p_value text, p_reason text) returns jsonb` | yes |
| `mode` | `kind` (a new kind) or `extend` (adds choices, detail and decisions to a built-in kind) | default `kind` |
| `enabled` | on or off for the Inbox | default on |

Store each function as its full signature text, for example `security.layer4_intervention_inbox_page_v1(jsonb)`. The Inbox resolves each with `to_regprocedure` and only calls functions in schema `security`. A kind whose functions do not exist yet is skipped (listed in `summary.hooks_missing`). An error inside a hook is caught; that kind is skipped for that call (listed in `summary.hooks_failed`) and the rest of the Inbox still loads.

Migration `20261104410000` seeds the `intervention` row with the names below, so the interventions branch needs no change to the Inbox. It may also upsert its own row (`on conflict (kind, mode) do update`).

| Hook | Name seeded for `intervention` |
|---|---|
| kind | `security.layer4_intervention_kind_v1()` |
| counts | `security.layer4_intervention_inbox_counts_v1()` |
| page | `security.layer4_intervention_inbox_page_v1(jsonb)` |
| detail | `security.layer4_intervention_inbox_detail_v1(text)` |
| decide | `security.layer4_intervention_inbox_decide_v1(text,text,text,text)` |

## 2a. Extending a built-in kind (mode `extend`)

A row with `mode = 'extend'` and `kind` set to a built-in kind (for example `aer_review`) adds recovery choices to that kind. It does not change the kind's own choices or paging.

- Uses `kind_fn`, `decide_fn` and, optionally, `detail_fn`. It never uses `counts_fn` or `page_fn`: the built-in kind keeps its own counts and pages.
- **Kind:** `kind_fn()` returns `{choices:[…]}`. These choices are appended after the built-in choices. A key equal to a built-in key is ignored, so the built-in choice wins.
- **When choices appear:** only while both `kind_fn` and `decide_fn` resolve. Without them, the kind looks exactly as it does today.
- **Decide:** only the extension's own choice keys go to `decide_fn`. Built-in keys keep the built-in path. For AER, Approve all, Approve except and Reject the read stay as they are.
- **E13 gate:** extension choices are recovery, not approval, so the E13 hold does not disable them. Approve all and Approve except stay blocked while a read is incomplete. The server keeps this check.
- **Detail:** `detail_fn(ref)` shows recovery state on the card, using the same `{sections, actions}` shape as §3. Its `actions` filter only the extension's choices.

Seeded for the AER recovery decision (Platform Admin 06:58, §1 and §3), mode `extend`, kind `aer_review`:

| Hook | Name |
|---|---|
| kind | `security.layer4_aer_recovery_kind_v1()` |
| detail | `security.layer4_aer_recovery_detail_v1(text)` |
| decide | `security.layer4_aer_recovery_decide_v1(text,text,text,text)` |

Suggested choice keys and labels:

| Key | Label |
|---|---|
| `reread_stored` | Re-read from stored evidence |
| `request_evidence` | Request official evidence |
| `ai_analyse` | Ask AI to analyse the failure |
| `open_intervention` | Open human input |

"Reject the read" is the existing built-in `reject`.

The recovery detail should carry:

- the recommended recovery;
- whether human input is needed;
- the owner;
- the next attempt;
- the last attempt's result and status;
- the read's grouped case, if it has one.

The Inbox already shows the E13 facts from `public.layer4_aer_review_read` on the card: waiting rows, dropped requirements, failure reasons and stored-copy links.

Because `aer_review` is not keyed per provider row, a registry row is unique on `(kind, mode)`.

## 3. What each hook returns

**Kind:** `{label, order, choices:[{key, label, returns, input?, rank?, reason?, link?}]}`. This is the same shape as `security.layer4_inbox_kinds_v1()`. `input` may be `url`, `text` (shown as a text area) or absent. `rank` is the lowest role rank that may choose it (default 4). The Inbox merges it into `kinds` under the registered key.

**Counts:** `{kind, n, oldest, late, by_provider:[{provider_id, n, oldest}]}`. Use one aggregate read; never build items or read evidence. `provider_id` null means the Platform group. `late` uses the setting `layer4.target_days`.

**Page:** `p_args` = `{provider_id?, limit (1–200), after_at?, after_ref?}`.
- Returns `{kind, items:[…], before?}`.
- Items are ordered by `created_at`, then `ref` in the kind's own order. Return only items strictly after `(after_at, after_ref)` when given, at most `limit`.
- Each item has `kind, ref (text), provider_id, provider, subject, why, suggestion, created_at, late`. It may have more fields (for example `overdue`, `missing_fact`); the Inbox passes them through.
- Do not put evidence on page rows.
- `before` (recommended) is the count of this kind's items, for the same `provider_id`, at or before the cursor. Without it, the range on screen counts from the pages already seen.

**Detail (lazy):** called only when a reviewer opens one item. Returns `{sections:[{key, title, body}], actions:[{key, allowed, why?}]}`.
- `body` is text or an object of label → value.
- The Inbox shows the sections collapsed. Once detail has loaded, it shows only the choices whose `actions` entry has `allowed` true.

**Decide:** the Inbox first checks sign-in, Curator rank (3), that the choice exists in the kind, and the choice's rank. It then calls `decide_fn(ref, choice, value, reason)` and returns its reply.
- The hook enforces its own per-item rules and **writes its own** `pipeline.admin_control_events` row (`area 'layer4', action 'inbox_decide'`). The Inbox does not add a second row for hook kinds.
- The reply is `{ok, returns, result, event_id, request?, outcome?}`. When `ok` is false, the screen shows `request` as the follow-up, not as an error.

## 4. Budgets a kind must meet

At production scale on the fixture (about 5,000 items over about 200 universities):

| Read | Budget |
|---|---|
| counts | 150 ms |
| page | 100 ms |
| detail | 300 ms |

The Inbox's own first-load reads are proved under 300 ms each (`summary`, `universities`, first `items` page) by `tests/fixtures/l4-inbox-perf`. Within its kind, a page must return every item exactly once.

## 4a. Pill navigation (06:58 §2)

- **University kind pill:** opens `items {provider_id, kind}`, read on the server.
- **Heading:** the exact count of pending review items of that kind for that university. For AER, the proposed row count is shown separately on each card. The university's active course count is not used for this count.
- **University name:** shows all kinds.
- **Persistence:** the selection (university and kind) is kept in the address and through paging, refresh and decisions.
- **Counts after a decision:** they are re-read from the server.

## 5. Server actions on `public.admin_layer4_inbox` (unchanged names)

| Action | Arguments | Reads |
|---|---|---|
| `summary` | none | kinds (built-in plus hooks), counts by kind, total, late, universities, page-size settings |
| `universities` | `kind?, country?, q?, limit, offset` | counts by university (built-in plus hook `by_provider`), names and course counts for the page only |
| `items` | `provider_id` and/or `kind`, `limit`, cursor `after_o, after_at, after_kind, after_ref` | one page, built-in and hook kinds merged in `(o, created_at, kind, ref)` order; returns `total, before, more, items` |
| `detail` (new) | `items:[{kind, ref}]`, at most one page | stored-copy facts for built-in items; `detail_fn` for hook items |
| `decided`, `decide` | as before | as before; a hook kind decides through `decide_fn` |
