# DOT intake endpoint (s1344): one consolidated Platform Admin action

**Status (28 Nov 2026, S1-Build):** prepared and shipped **switched off**. No identity exists and no role is assigned. Nothing changes until the Platform Admin takes the action in section 3.
**Instruction:** SS-Programme-Control PC-20261128-1130-DOT-STORAGE-S1-Build ("Prepare smallest endpoint off/guarded and one consolidated exact Admin action for narrow identity/expiry, actual DOT connector and kill switch. Prove rank0 denied…").
**Pilot change:** migration `20261201040000_cf247_s1344_dot_intake_gateway_off.sql`, edge function `dot-intake` (`verify_jwt` on), spec `tests/uat/cf-247-s1344-dot-intake-gateway-off-contract.spec.mjs`.

No secret, password, token or key value appears in this document, and none is ever put in chat, Drive or a repository. DOT holds its own password; the Platform Admin holds the screens.

## 1. What ships (switched off)

| Part | What it does |
|---|---|
| Role `dot_submitter` (rank 0, "DOT evidence submitter") | Names the DOT identity for the endpoint's gate only. Rank 0 is the same as a signed-in user with no role: it opens no admin screen, table, bucket or catalogue read (proof in section 2). |
| Setting `dot_intake.on` (Settings › Settings › Services & limits, "DOT intake endpoint: on") | The kill switch. **0 (shipped):** every upload is refused with `HELD:SWITCHED_OFF` (HTTP 503) before the file is read. **1:** the endpoint accepts uploads from an active, unexpired `dot_submitter`. Changed with a reason, like every setting. |
| Setting `dot_intake.max_bytes` (1 MiB) | The largest JSONL file accepted (HTTP 413 above it). |
| `public.svc_dot_intake_v1` (service role only) | `gate`: switch on, and the caller holds an active, unexpired `dot_submitter` assignment, else `HELD:NOT_DOT_SUBMITTER` (HTTP 403). `submit`: checks the package name and stored path, then calls the existing writer `svc_structured_intake_v1 submit` (submitter `dot`) and writes one audit row (`admin_control_events`, action `dot_intake_submit`). |
| Edge function `dot-intake` | Signed-in callers only. Asks the gate **before reading the file**; checks size, that the SHA-256 DOT states equals the server's own SHA-256 (else 422, nothing stored), UTF-8 JSON lines of objects; stores once at `staging-boost/dot/<package>/<sha256>.jsonl` without overwrite; submits; returns the intake receipt. A replay of the same file finds the stored copy and the writer counts its candidates as duplicates. Errors are fixed codes; only the platform's own `INVALID_INPUT:` text is passed on. |

It writes no canonical row, no evidence record and activates nothing. The existing proof on the platform's stored copies, the course binding and the admission rules decide, as for every intake. **A receipt is not acceptance**, and a held result is not acceptance.

### Rehearsal (rolled back, 28 Nov 2026 11:50 AEDT)

| Check | Result |
|---|---|
| Gate, switch off | `HELD:SWITCHED_OFF` |
| `authenticated` / `anon` may execute `svc_dot_intake_v1` | false / false |
| Bucket `staging-boost` | exists, private, 50 MiB file limit |
| Role | `dot_submitter`, rank 0, active |
| Switch on, a user with no assignment | `HELD:NOT_DOT_SUBMITTER` |
| Switch on, assignment expired yesterday | `HELD:NOT_DOT_SUBMITTER` |
| Switch on, assignment expiring in 14 days | ok, `max_bytes` 1,048,576; the user's effective rank stays 0 |
| Bad package name | `INVALID_INPUT` refusal |
| One test candidate | receipt returned (received 0, refused 1 "unknown provider"); one audit row |
| Post-checks | consumer API 75/48 no drift; active cron, manual locks and role assignments unchanged; switch 0 |

## 2. Proof: a rank-0 signed-in user is refused everywhere (rolled back, 28 Nov 2026)

Run as a signed-in user with no role (`role authenticated`, a JWT subject with no assignment), inside a transaction that was rolled back.

| Path | Result |
|---|---|
| Public functions granted to `authenticated` | 401 in all. 295 check a rank or the service role. Of the other 106, 97 refused, 4 stopped on input validation, and the 3 maintenance actions (status, pause, resume) refused with 42501. |
| What rank 0 can still reach | 4 reads that carry no catalogue or evidence data (integration status, a Layer 4 entity view, publication state, the scholarship AI control read) and its own UI error report. |
| Layer 4 write paths (`l4_api`) | all check a rank |
| Tables granted to `authenticated` (13) | `pipeline` and `ref` refused; `realtime` and `storage` show 0 rows |
| Storage | reads show 0 objects; writes refused by row-level security (the `evidence` bucket has no storage policies; every write there is the service role) |

So the DOT identity, holding only `dot_submitter`, can do nothing on the platform except call `dot-intake` while the switch is on and its assignment is unexpired.

## 3. The Platform Admin's one action

Do these in order. Steps A to C open the route; step D proves it; step E closes it.

### A. Create the DOT identity (narrow, with expiry)

1. Administration › **Users & roles** (`#users-roles`) › **Create user**.
2. Email: DOT's own mailbox (the Platform Admin chooses it). Name: "DOT intake".
3. Mode: **Invite** (DOT sets its own password from the one-time link; nobody else sees it).
4. Role: **DOT evidence submitter** (rank 0) only. Do not add a second role.
5. Role expiry: a date no more than **14 days** ahead (it can be renewed on the user's row). After it, the endpoint refuses DOT with `HELD:NOT_DOT_SUBMITTER`.
6. Create. If the role is not offered in the list, stop and tell S1-Build; do not choose another role.

### B. The DOT connector (what DOT runs)

DOT signs in with Supabase Auth (email and password grant) using the project's **publishable** key, and sends one multipart POST per JSONL file:

```bash
# DOT_ACCESS_TOKEN: the access token from DOT's own sign-in. Never pasted into chat, Drive or a repository.
curl -sS -X POST "https://fxcwkweaxjtknorudmwp.supabase.co/functions/v1/dot-intake" \
  -H "Authorization: Bearer $DOT_ACCESS_TOKEN" \
  --form-string "package=<package-name>" \
  --form-string "sha256=$(sha256sum <file>.jsonl | cut -d' ' -f1)" \
  -F "file=@<file>.jsonl;type=application/x-ndjson"
```

- `package`: 3 to 81 lower-case letters, digits, dot, dash or underscore.
- The file: UTF-8, one JSON object per line, each a candidate in the DOT INTAKE CONTRACT v1.0 shape (structured intake, s1321: domain, provider, course where AER, provisional key, scope, facts, 1 to 8 proofs with final https URL, quote and SHA-256; at most 50 candidates).
- The reply is the intake receipt: received, duplicates and refused, with each refusal's reason. Proof, binding and admission run afterwards on the platform's own stored copies; the result (admitted, or an exact `HELD:` reason) is read back on the receipt's items.

| HTTP | Meaning |
|---|---|
| 200 | stored and submitted; receipt returned (`replay: true` when the same file was already stored) |
| 401 | not signed in |
| 403 | `HELD:NOT_DOT_SUBMITTER` (no role, or it expired) |
| 503 | `HELD:SWITCHED_OFF` |
| 400 / 413 / 415 / 422 | bad form, too large, not JSON lines of objects, SHA-256 mismatch or the platform's own `INVALID_INPUT` refusal; nothing submitted |

### C. Open the switch

Settings › Settings › Services & limits › **DOT intake endpoint: on** → **1**, with a reason (for example "DOT intake verification, PC-20261128-1130").

### D. One controlled verification test

With the switch on, DOT sends one small file built from the **first exact-course slice whose proof is already a stored copy** (not B15's receipted candidate, which is not replayed as a new gain):

1. The same file with a wrong `sha256` → 422 `sha256_mismatch`; nothing stored.
2. The file with its true `sha256` → 200, a receipt with `received` ≥ 1.
3. The same file again → 200, `replay: true`, every candidate a duplicate.
4. Switch to 0 → the next call is 503 `HELD:SWITCHED_OFF`.
5. S1-Build reads back the stored object, the audit row and each candidate's outcome after the admission ticks and records them in S1-Build M3. Only a genuinely eligible canonical admission, holding through **two unattended cycles**, counts as accepted.

### E. Close or roll back

| To | Do |
|---|---|
| Stop all DOT uploads now | Switch `dot_intake.on` to **0** (refused before any file is read) |
| End DOT's access | Users & roles › DOT's row › Disable, or remove the role; or let the expiry pass |
| Undo the change | Nothing to drop: with the switch at 0 and no assignment the endpoint does nothing. Stored files stay as the record (no delete). |

## 4. What this does not change

- The Drive pickup route stays; this is an additional route, off by default.
- R2's audit-only original files are **not** institutional usable evidence. The next exact-course slice reuses stored proof; source evidence is then qualified and registered through the existing AER matrix, ELR and scholarship mechanisms. A receipt or a held result is never called full acceptance.
- G3 (75/48), the 7,585 manual locks, active cron (≤ 140), spend caps, Layer 4 human decisions and every admission gate are unchanged.
