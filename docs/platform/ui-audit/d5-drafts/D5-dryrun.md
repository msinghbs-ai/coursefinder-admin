# D5 — live rolled-back dry run (30 Oct 2026, project fxcwkweaxjtknorudmwp)

Script: both migration files verbatim (R1 first, then the consumer migration), wrapped in `begin; … raise exception 'DRYRUN …'; rollback;`.
Fixture inside the transaction only: an active course row naming band "65%" on RMIT BH126 (`0100714`), so the resolver reaches step 3 (no live course reaches steps 2–4 today: no course row is active). Session claims: Platform Admin `63ba56cb…` for the `admin_aer` calls.
After the run, live was re-read: `entry_matrix_payload_v1` `be5478d0…`, `entry_resolve_v1` `492ece03…`, `admin_aer` `09dbbaf2…` (unchanged), fixture row count 0, baseline `captured_at` still 28 Oct.

## md5 (inside the transaction, after both files)

| Function | Before (live) | After | |
|---|---|---|---|
| `security.entry_matrix_payload_v1(uuid,text)` | `be5478d0402620cbc4c701a1e590856e` | `5f7eb75596fd2758871b1df71b859109` | edited |
| `security.entry_resolve_v1(uuid,text)` | `492ece033520ad81cd0046c5a851bedb` | `69bbc05f650191954a22af09c0c85c74` | edited |
| `public.admin_aer(text,jsonb)` | `09dbbaf2aadc78e1c992d21a1048e661` | `5e58f5d6126b3b2fe026e376a56c7686` | edited (R1) |
| `public.website_v2_course(text)` | `50d22c3ccfc2a00bedb5c9cee762eec4` | same | untouched |
| `public.website_v2_course(text,text)` | `1c10b34fc4ea57398638d26ac9e21279` | same | untouched |
| `public.website_v2_provider(text)` | `0894cdb1d4b14ac8af2f5aa07c9f7ebb` | same | untouched |
| `public.website_v2_provider(text,text)` | `3f622be6721d89289866c459cf178079` | same | untouched |

Re-run check: `edit_once` on an already-edited function returns "already applied" and changes nothing.

## Pre-existing keys byte-identical

Each payload before vs after, with only `scale_stated` removed from the entry rows, compared as text: **all true** — `provider` (no country), `provider` IN, `provider` NZ, `course` (no country), `course` IN, `course` NZ.
Items carrying the key after: provider 343/343, IN 33/33, NZ 11/11; course IN resolution rows 3/3, NZ 1/1.
Marker over all 343 active items: `true` 310, `null` 33, `false` 0.

## The three rows

**Stated scale** (`provider` IN, AISSC, band 65%):
- before: `{"band":"65%","as_at":"2026-10-26","scale":"percentage","country":"IN","min_grade":"Minimum average of 65%","conditions":{…},"study_level":"Bachelor degrees","qualification":"All India Senior School Certificate (AISSC) – 10+2"}`
- after: the same + `"scale_stated": true`

**Case by case** (`provider` NZ, NCEA, band 65%):
- before: `{"band":"65%","as_at":"2026-10-26","scale":"none","country":"NZ","min_grade":"Achieved NCEA Level 3 with Merit average","conditions":{…},"study_level":"Bachelor degrees","qualification":"National Certificate of Educational Achievement (NCEA)"}`
- after: the same + `"scale_stated": null`
- `course` NZ resolution: step 3, outcome `case_by_case`, row `case_by_case: true`, `scale_stated: null` (before: same without the key).

**Printed grade, no stated scale** (mechanism demonstration on the India "State Boards … Minimum average of 70%" band-65% row, recorded through `admin_aer` inside the rolled-back transaction; not one of the 20 quarantined Gao Kao rows):
- before: `{… "scale":"percentage", "min_grade":"Minimum average of 70%", …}`
- after the marker: the same + `"scale_stated": true`
- after a person records "Not stated on the page": `{… "scale": null, "min_grade": "Minimum average of 70%", …, "scale_stated": false}`
- `course` IN resolution after recording: step 3, outcome `minimum_published`; that row `scale: null`, `case_by_case: false`, `scale_stated: false`; the other two rows `true`.

## R1 behaviour

- Before the consumer marker is live: `not_stated` refused — "\"Not stated on the page\" can be chosen once the website marker is live (D5)".
- After: accepted; `changed 2`; history `scale: "percentage" -> null; min_value: 70 -> null` with the reason.
- A number without a scale afterwards: refused — "a numeric value needs its scale (percentage, points, GPA, ...)".
