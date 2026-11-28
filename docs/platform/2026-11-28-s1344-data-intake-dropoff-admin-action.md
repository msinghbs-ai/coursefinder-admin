# DOT data-intake drop-off (s1344): one consolidated Platform Admin action

**Status (28 Nov 2026 12:20 AEDT, S1-Build):** increment 1 built, corrected after the Programme Control review PC-20261128-S1-BUILD-REVIEW (12:02) and rehearsed again (rolled back); in release (Pilot #1753). No identity exists and no role is assigned, so nothing can use the drop-off until the Platform Admin takes the action in section 3.
**Instructions:** SS-Programme-Control PC-20261128-1130-DOT-STORAGE-S1-Build (smallest endpoint, narrow identity with expiry, kill switch, rank-0 proof) and **PC-20261128-DOT-STORAGE-APPROVED** (Platform Admin approval: dedicated private data-intake bucket, restricted DOT upload identity, automatic Edge Function processing, existing Admin UI controls; supersedes the staging-boost/dot proposal, which was never shipped).
**Pilot change:** migration `20261201040000_cf247_s1344_data_intake_dropoff.sql`, edge function `dot-intake` (`verify_jwt` on), spec `tests/uat/cf-247-s1344-data-intake-dropoff-contract.spec.mjs`.

No secret, password, token or key value appears in this document, and none is ever put in chat, Drive or a repository. DOT holds its own password; the Platform Admin holds the screens.

## 1. What ships (increment 1)

| Part | What it does |
|---|---|
| Bucket `data-intake` | Private, separate from BOOST, no storage policies: no signed-in user can list, read, write or delete in it. Only the edge function (service role) writes there, and only new objects (no overwrite). File types: PDF, HTML, JSON, JSONL, text. |
| Paths (derived by the server, never taken from the caller) | `dot/<country>/<provider id>/<package>/files/<sha256>.<ext>` for each original; `dot/<country>/<provider id>/<package>/manifest-<sha256>.json` for the READY manifest, written last. |
| `pipeline.data_intake_packages`, `pipeline.data_intake_files` | One row per package (uploading → received or refused; the structured intake receipt kept on it; attempts and last attempt) and per original (server SHA-256, bytes, MIME, the source address DOT states). A finalised package takes no more files. Nothing is deleted; `cleared_at` only hides a package from the active view. |
| Role `dot_submitter` (rank 0, "DOT evidence submitter") | Names the DOT identity for the gate only. Rank 0 opens no admin screen, table, bucket or catalogue read (proof in section 2). |
| Setting `data_intake.on` (Settings › Settings › Services & limits, "Data intake drop-off: on") | The kill switch, shipped **on** as approved: with no one holding the role, nothing can use it. **0** refuses every call with `HELD:SWITCHED_OFF` (HTTP 503) before any file is read. Changed with a reason. |
| Setting `data_intake.role_max_days` (14) | The DOT role works only when its expiry is set and no further ahead than this many days; an open-ended or longer assignment is refused with `HELD:EXPIRY_NOT_BOUNDED`. |
| Setting `data_intake.max_bytes` (25 MiB) | The largest original or manifest accepted (HTTP 413 above it; the bucket's own ceiling is 50 MiB). |
| `public.svc_data_intake_v1` (service role only) | `gate`: switch on and an active, unexpired `dot_submitter` assignment, else `HELD:NOT_DOT_SUBMITTER`. `upload`: the provider must be in the stated country; the path must be the derived one. `finalise`: every original the manifest lists must be recorded and every candidate must name the package's provider, else `HELD:MANIFEST_INCOMPLETE` (the package stays open); then the existing writer `svc_structured_intake_v1 submit` (submitter `dot`), whose receipt is kept; replay returns the same receipt. One audit row per finalise. `status`. |
| Edge function `dot-intake` | Signed-in callers only; asks the gate **before reading the file**; checks size, that the SHA-256 DOT states equals the server's own (else 422, nothing stored), that the MIME matches the extension and that a PDF starts `%PDF-`. Errors are fixed codes; only the platform's own `INVALID_INPUT:` text is passed on. |

It writes no canonical row and activates nothing. Proof on the platform's stored copies, the course binding, Layer 4, manual locks and the admission rules decide, as for every intake. **A receipt or a held result is not acceptance.**

### Review corrections (PC-20261128-S1-BUILD-REVIEW, rehearsed rolled back 12:15 AEDT)

| Review point | Correction | Rehearsal |
|---|---|---|
| Expiry not enforced (null allowed) | Expiry required and at most `data_intake.role_max_days` ahead | no expiry: `HELD:EXPIRY_NOT_BOUNDED`; 60 days: held; 14 days: ok |
| Concurrent finalise not serialised | One writer per package (transaction advisory lock on provider and package) in upload and finalise | lock present in the live definition |
| A changed manifest could replay the old receipt | A finalised package answers only its own manifest; another manifest is refused ("needs a new package") | same manifest: replay; changed: refused |
| Storage written before database checks (orphans) | `precheck_upload` and `precheck_finalise` run every check first and write nothing; storage only after they pass; the path is derived from the bytes, so a retry after a stored-but-unrecorded upload finds the same object and records it | precheck wrote 0 rows; incomplete manifest precheck: held, attempts unchanged; late upload precheck: refused |
| Candidate-level refusals | Finalise returns received, duplicate and refused counts beside the receipt (each refusal with its reason) | 1 refused shown |

### Proof with the real role assigned (rolled back, 12:16 AEDT)

A signed-in user holding **only `dot_submitter`** (expiry 13 days): effective rank 0. Of every public function granted to `authenticated`, 387 refused, 6 stopped on input validation and 8 returned: `admin_ui_error_report` (its own report), `admin_screen_open` (records nothing below rank 1), `admin_credit_notices` (returns an empty list below rank 3), `admin_provider_logo_capability` (its own rank and aggregate logo-finder counts, no provider data), `admin_integrations_status`, `layer4_effective_entity`, `layer4_publication_state`, `scholarship_ai_control_read`. Tables in pipeline and ref granted to `authenticated`: all refused. Storage objects in data-intake, evidence, staging-boost and aer-artifacts: 0 visible. A direct write into data-intake: refused. Calling `svc_data_intake_v1` directly: refused (service role only).

### Rehearsal (rolled back, 28 Nov 2026 11:50 AEDT)

| Check | Result |
|---|---|
| Bucket | `data-intake`, private, 50 MiB ceiling, 0 storage policies |
| `authenticated` may execute `svc_data_intake_v1` / read `data_intake_files` | false / false |
| Switch on, a user with no assignment | `HELD:NOT_DOT_SUBMITTER` |
| Active assignment (14 days) | gate ok, 26,214,400 bytes |
| Upload an original; the same again | recorded; replay, no second row |
| Wrong country for the provider; a path other than the derived one | refused (`INVALID_INPUT`) |
| Manifest listing an original not uploaded | `HELD:MANIFEST_INCOMPLETE` (1 missing) |
| Manifest with a candidate of another provider | `HELD:MANIFEST_INCOMPLETE` (1 other provider) |
| Complete manifest | received; structured intake receipt kept (the test candidate refused by the writer: "an academic entry candidate names its course") |
| Finalise again | replay, the same receipt |
| Upload after finalise | refused: the package is finalised |
| Audit rows | 1 |
| Assignment expired | `HELD:NOT_DOT_SUBMITTER` |
| Post-checks | consumer API 75/48 no drift; active cron, manual locks and role assignments unchanged |

## 2. Proof: a rank-0 signed-in user is refused everywhere (rolled back, 28 Nov 2026)

Run as a signed-in user with no role, inside a transaction that was rolled back.

| Path | Result |
|---|---|
| Public functions granted to `authenticated` | 401 in all. 295 check a rank or the service role. Of the other 106, 97 refused, 4 stopped on input validation, and the 3 maintenance actions (status, pause, resume) refused with 42501. |
| What rank 0 can still reach | 4 reads that carry no catalogue or evidence data (integration status, a Layer 4 entity view, publication state, the scholarship AI control read) and its own UI error report. |
| Layer 4 write paths (`l4_api`) | all check a rank |
| Tables granted to `authenticated` (13) | `pipeline` and `ref` refused; `realtime` and `storage` show 0 rows |
| Storage | reads show 0 objects; writes refused by row-level security |

So the DOT identity, holding only `dot_submitter`, can do nothing on the platform except call `dot-intake` while the switch is on and its assignment is unexpired.

## 3. The Platform Admin's one action

### A. Create the DOT identity (narrow, with expiry)

1. Administration › **Users & roles** (`#users-roles`) › **Create user**.
2. Email: DOT's own mailbox (the Platform Admin chooses it). Name: "DOT intake".
3. Mode: **Invite** (DOT sets its own password from the one-time link; nobody else sees it).
4. Role: **DOT evidence submitter** (rank 0) only. No second role.
5. Role expiry: **required**, no more than **14 days** ahead (renew on the user's row). Without an expiry, or with a longer one, every call is refused with `HELD:EXPIRY_NOT_BOUNDED`; after it, with `HELD:NOT_DOT_SUBMITTER`.
6. Create. If the role is not offered, stop and tell S1-Build; do not choose another role.

### B. The DOT connector (what DOT runs)

DOT signs in with Supabase Auth (email and password) using the project's **publishable** key, then for each READY subset uploads every original and finalises the manifest last:

```bash
# DOT_ACCESS_TOKEN: the access token from DOT's own sign-in. Never pasted into chat, Drive or a repository.
EP="https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1/dot-intake"
ID=(--form-string "country=AU" --form-string "provider_id=<provider uuid>" --form-string "package=<package-name>")
# 1. each original (PDF, HTML, JSON, JSONL or text), with the address it was read from
curl -sS -X POST "$EP" -H "Authorization: Bearer $DOT_ACCESS_TOKEN" "${ID[@]}" --form-string "action=upload" \
  --form-string "sha256=$(sha256sum <original>.pdf | cut -d' ' -f1)" --form-string "source_url=<https address>" -F "file=@<original>.pdf;type=application/pdf"
# 2. the READY manifest, last: {"files":[{"sha256":"…"}], "items":[ structured intake candidates, DOT INTAKE CONTRACT v1.0 ]}
curl -sS -X POST "$EP" -H "Authorization: Bearer $DOT_ACCESS_TOKEN" "${ID[@]}" --form-string "action=finalise" \
  --form-string "sha256=$(sha256sum manifest.json | cut -d' ' -f1)" -F "file=@manifest.json;type=application/json"
# 3. state and receipt at any time
curl -sS -X POST "$EP" -H "Authorization: Bearer $DOT_ACCESS_TOKEN" "${ID[@]}" --form-string "action=status"
```

| HTTP | Meaning |
|---|---|
| 200 | upload recorded (`replay: true` if already held) or finalise received (receipt; `replay: true` on a repeat) |
| 401 / 403 / 503 | not signed in / `HELD:NOT_DOT_SUBMITTER` or `HELD:EXPIRY_NOT_BOUNDED` / `HELD:SWITCHED_OFF` |
| 409 | `HELD:MANIFEST_INCOMPLETE` (missing originals or another provider's candidate; upload them and finalise again; nothing stored), the package is finalised, or a different manifest for a finalised package |
| 400 / 413 / 415 / 422 | bad form or identity, too large, wrong type, SHA-256 mismatch or the platform's own `INVALID_INPUT` refusal |

### C. Switch

`data_intake.on` ships **on**. Settings › Settings › Services & limits › **Data intake drop-off: on** → 0 stops every call at once, with a reason.

### D. Controlled verification test (actual DOT upload)

1. DOT uploads the next eligible READY subset's originals (**not B15**, which is admitted and is not replayed) and finalises.
2. Negative checks DOT runs once: a wrong `sha256` (422, nothing stored); a manifest before its originals (409 incomplete); an upload after finalise (409); the same finalise again (same receipt, no new rows).
3. S1-Build reads back the stored objects, the package and file rows, the audit row and each candidate's outcome after the admission ticks, and records them in S1-Build M3. Only a genuinely eligible canonical admission, holding through **two unattended cycles** with consumer read-back, counts as accepted.

### E. Close or roll back

| To | Do |
|---|---|
| Stop all DOT calls now | `data_intake.on` → 0 |
| End DOT's access | Users & roles › DOT's row › Disable, or remove the role; or let the expiry pass |
| Undo | Nothing to drop: with no assignment the endpoint does nothing. Stored files and rows stay as the record (no delete). |

## 4. Next increments (S1-Build, in this lane, continuing now)

1. Register each finalised package's originals once as evidence (existing evidence bucket and catalogue, with hash and source lineage) so the proof reuses the exact verified source; reconcile an edition or representation difference once (B15: stored a7fea7ff… against DOT's 53896af8…, both quotes found).
2. Existing Operations › Data Delivery panel: package lifecycle counts, errors, receipt links, last and next attempt, age and size; authorised Process now / Retry eligible / Pause through the existing settings and the existing recovery dispatcher (no new cron or queue); clearing from the active view only after a durable receipt and downstream ownership.
3. Receipt and canonical status reconciliation (PC-20261128-DOT-ADMISSION-ALIGNMENT): Layer 4 items left pending after their row is active.

The Drive pickup route stays until the direct route is accepted. R2's audit-only originals are not institutional evidence: source evidence is qualified and registered through the existing AER matrix, ELR and scholarship mechanisms. G3 (75/48), the 7,585 manual locks, active cron (≤ 140), spend caps, Layer 4 human decisions and every admission gate are unchanged.
