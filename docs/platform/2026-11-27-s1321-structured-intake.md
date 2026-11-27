# Structured data intake (s1321)

S1-Build, 27 Nov 2026. Assignment: SS-Programme-Control 27 Nov 2026 21:08 AEDT, approved scoped development exception 1. Pilot migration `20261130200000`, worker `coverage-sweep-worker-v1.0.60` (mode `intake_verify`). Candidate contract and how to submit: `docs/intake/README.md`.

## Flow

**1. File.** The submitter's file sits in this repository, in `docs/intake/<submitter>/<batch>.jsonl`.

**2. Submit.** The Pilot workflow *Structured intake* reads the file at a named commit and calls `public.svc_structured_intake_v1('submit')`. The writer:
- checks each candidate against a closed list;
- stores each candidate once, keyed by `(submitter, candidate_key)` and by a content key (course and facts);
- starts the worker once.

**3. Prove.** `security.structured_intake_next_v1` leases candidates together with the newest stored copy of each proof page inside `aer.stale_source_days`.
- The worker proves each quote on that stored copy (`intake.ts`, `intake-quote-v1`). The match is exact on the characters; only white space and typographic forms are folded.
- A page with no stored copy is read once directly (robots.txt respected, no Firecrawl, no model, $0). It is registered as ordinary evidence (action `store`) and reused afterwards.

**4. Decide.** `security.structured_intake_record_v1` decides academic entry candidates in this order:
1. Every quote must be on the stored copy, or the candidate is rejected.
2. The course code must be printed on a proof page.
3. The requirement quote must be on the course's own bound page.
4. The value and its scale must be printed in the quote.
5. A course with active rows is compared. A manual lock, a waiting read or an earlier rejection or return by a person holds the candidate.
6. Otherwise the candidate becomes one ordinary proposed course entry row with a Layer 4 `course_entry_first_read` item (reader `structured_intake`).

Requirements the submitter did not supply are carried as a dropped requirement, so the completeness gate never treats a partial submission as the whole page. The existing machine rules then decide: `aer-machine-v1`, or `aer-course-partial-v1` for the proved rows.

Scholarship candidates are proved and held with their reasons. Activation authority stays with the Platform Admin.

## Contract for later processing workers

A Cloudflare or other processing worker submits the same candidate shape (domain, provider, course and code, scope, facts, proof quotes). The platform proves the quotes on its own stored copies and uses the existing writers. No worker writes canonical rows directly.

## Rehearsal: DOT batch01, on the live head, rolled back

| Candidate | Result in the rehearsal |
|---|---|
| Avondale 059850D (Bachelor of Theology), IB Diploma 24 points | **Proposed**: one row and one Layer 4 item, on stored copy `92d4edcd` (18 Nov 2026) of the bound page. Machine check `gate_incomplete` (other routes not supplied), so `aer-course-partial-v1` admits the proved row. |
| Avondale 057303C (Bachelor of Business) | Compared (9 active rows) |
| University of Divinity 037861E (PhD) | Compared (5 active rows) |
| AUT 054688E (Master of Divinity) | No stored copy of `aut.edu.au/course/MDIV20/`. Live, it is read once directly. The course's bound page is still `actheology.edu.au`, so the candidate is held at bound page differs until the AUT relink. |
| Three scholarship candidates (Divinity RSS and RFS, SMBC 100 for 100) | Held: rounds closed 15 Nov 2026, no current amount, or a restricted scope |

No consumer object (75/48), lock, decided Layer 4 item or cron job changed. Next took 753 ms.

## Settings (G2)

| Setting | Value |
|---|---|
| `structured_intake.on` | 1 |
| `structured_intake.verify_batch` | 20 |
| `structured_intake.confidence_verified` | 0.9 |
| `structured_intake.max_items_per_submit` | 50 |
| `structured_intake.max_proofs` | 8 |
| `structured_intake.fetch_on` | 1 |
