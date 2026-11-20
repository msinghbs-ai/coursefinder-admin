# s890 — Victoria University CRICOS 02475D: keep the record, give it the university's description

Date: 20 Nov 2026. Chat: S1-RM-Design. Decision: Platform Admin, 22:54 and 23:07 AEDT.

## What was read (rolled-back dry runs, no interactive query)

| Record | CRICOS | Website | Active courses | Description | Recorded host owner |
|---|---|---|---|---|---|
| Victoria University (`bac82321`) | 00124K | vu.edu.au | 279 | Admitted 19 Nov (item `a6aec80c`) | Yes (s766) |
| Victoria University (`0f5373c8`) | 02475D | vu.edu.au/international | 35 (Sydney City Centre, Brisbane) | None; reading `3559c277` held on `provider_host_conflict` | No |
| University of Technology Sydney (`9d22a19e`) | 00099F | uts.edu.au | 530 | Approved in Layer 4 (item `9e1d3b89`), live | — |

02475D is a separate registration. Its courses carry their own CRICOS course codes; none is shared with 00124K, although 34 share a title.

## Options put to the Platform Admin (23:07)

1. **Keep both, clear the hold (chosen).** 02475D takes 00124K's description. Nothing leaves the website or Zoho.
2. Retire 02475D through the lifecycle path (`merged` into 00124K, reversible). This hides the record and its 35 courses.
3. Re-parent the 35 courses to 00124K, then archive 02475D. The courses would sit under a CRICOS registration they are not registered to.

## What s890 does

- **The decision**, applied through the screen's own path as the Platform Admin:
  - `admin_layer4_inbox` `description_open_held`, then `decide` `edit_approve` with 00124K's text.
  - `set_manual_lock` false, so the lock count stays 7,585.
  - Audited as human input and listed in Human Edits & Periodic Audit.
- **The fix:** a university opened for writing from a held reading now has that reading admitted and linked to the item. Before, the reading stayed held, or was superseded straight after admission.
- **Guards:** G3 and the lock count before and after; md5 of the edited function; the record states read live; 02475D's course count unchanged.

## Not changed

- No lifecycle event, archive or re-parenting.
- The host owner record.
- UTS.
- The consumer API.
- AI or Firecrawl spend.

## Open

00124K's description says "in Melbourne's west". It now also describes the Sydney and Brisbane registration, as the Platform Admin chose. A person can change 02475D's text in Human Edits & Periodic Audit (Edit & Re-Lock).
