# Structured intake files

A research or processing worker (DOT first, later the Cloudflare reader) puts its candidates here. One file is one batch: `docs/intake/<submitter>/<batch>.jsonl`, with one candidate on each line. The platform never takes a candidate on trust. Every quote is proved on the platform's own stored copy of the page it names.

## How a file is taken

1. Merge the file in this repository.
2. In Pilot, run **Actions › Structured intake** with:
   - action `submit`;
   - the file path;
   - `ref` = the commit of the merged file;
   - `by` = who is acting.
3. The governed writer `public.svc_structured_intake_v1` stores each candidate once (submitter key and content key). The worker (coverage-sweep `intake_verify`) then proves the quotes. It reuses the stored copy; a page with no copy inside `aer.stale_source_days` is read once directly (robots.txt respected, $0) and kept as evidence. The decision uses the existing writers.
4. Run the same workflow with action `list` to see each candidate's status. Run it with action `verify` to prove waiting candidates again.

## Direct route from the pickup folder (s1326, 28 Nov 2026)

The route needs no admin commit, pull request or CI (SS-Programme-Control 28 Nov 2026 00:01 AEDT).

1. S1-Build collects a READY_FOR_PICKUP package from the submitter's Drive pickup folder.
2. It checks the package manifest's sha256 for each ready file and leaves every `DO-NOT-SUBMIT` file out.
3. It runs **Actions › Structured intake** with:
   - action `submit`;
   - file `drive/<submitter>/<batch>.jsonl`;
   - `content` = base64 of the gzip of the file's bytes;
   - `sha256` = the manifest's hash;
   - `source` = `drive:<file id>`;
   - `by` = who is acting.
4. If the bytes do not match the stated sha256, nothing is sent.

The source and hash are written to the writer's log (`by`). The writer, the submitter and content keys, the proof on stored copies and every decision are the same as the admin-commit route. The admin-commit route still works.

## Candidate contract (s1321)

| Field | Rule |
|---|---|
| `domain` | `aer` or `scholarship` |
| `provider_id`, `course_id`, `course_code` | The course must belong to the provider and carry that code. Academic entry candidates must name a course. |
| `provisional_key` | The submitter's own key. It is unique per submitter. |
| `scope` | `exact_course` is the only scope proposed. Any other scope is held. |
| `facts` | An object. For academic entry: `min_value` with `scale` (the number and the scale word must both be printed in the requirement quote), `qualification_code` (`IB_DP` needs "International Baccalaureate" or "IB" in the quote), `minimum` (text), `comparison_only`, `complete` (set `true` only when the candidate covers every requirement on the page). |
| `proof` | 1 to `structured_intake.max_proofs` entries, each with `final_url` (https), `quote` (8 to 300 characters, exact) and `sha256`. |

## Outcomes

| Status | Meaning |
|---|---|
| `proposed` | One proposed course entry row with a Layer 4 `course_entry_first_read` item (reader `structured_intake`). The machine rules `aer-machine-v1` and `aer-course-partial-v1` admit it, or a person decides. |
| `compared` | The course already has active rows. The comparison is kept, and replacing or adding to them is a person's decision. |
| `held` | A reason is recorded, for example: no bound page, the bound page differs, identity, value not in the quote, a lock, a waiting read, a person's earlier decision, a scholarship reason, or no stored copy. |
| `rejected` | A quote is not printed on the stored copy. |

Scholarship candidates are proved and held with their reasons. Activation authority stays with the Platform Admin.

## Files

| File | sha256 | Taken |
|---|---|---|
| `dot/batch01-20261127.jsonl` | `ed745e6660b251326268d972968558a6f8778882b987fa5c90d87ecaa468c256` | s1321 |
