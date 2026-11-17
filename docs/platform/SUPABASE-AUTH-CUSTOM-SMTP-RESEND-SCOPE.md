# Supabase Auth custom SMTP through Resend — scope

**Version:** 1.0, 17 Nov 2026 16:30 AEDT
**Decision:** Platform Admin, 17 Nov 2026 16:13 (chat S1-RM-Design): scope Resend for Supabase Auth email and add it to the production setup checklist; configure DNS and SMTP after the Thursday 19 Nov migration squash.
**Status:** scoped, not started. Go-live checklist row `auth_custom_smtp` is **pending** (Pilot migration `20261117163000`).
**Project:** Supabase `fxcwkweaxjtknorudmwp` only (never `coursefinder-demo`).

## Executive summary

Invitation and password reset emails from the Admin are sent by Supabase's built-in mail service. It shows the sender as "Supabase Auth", is meant for testing, and limits how many emails go out each hour. Sending through Resend from our own domain lets the emails arrive from **StudySearch PIM Admin**, improves delivery, and lifts the hourly limit. The email wording does not change: it stays the `#0b6e5f` template set on Users & roles › Links & Email Templates.

## Business objectives

- Staff recognise the sender and trust the invitation or reset email.
- Emails reach the inbox rather than spam.
- Enough hourly capacity to invite a team in one sitting.

## Target configuration

| Setting (Supabase Auth › Emails › SMTP Settings) | Value |
|---|---|
| Enable custom SMTP | On |
| Host | `smtp.resend.com` |
| Port | `465` |
| Username | `resend` |
| Password | A Resend API key limited to sending (a secret; never written to a repository, a document or the Admin) |
| Sender name | `StudySearch PIM Admin` |
| Sender email | An address on the verified sending domain, for example `no-reply@<sending domain>` (to be decided) |

## In scope

1. Resend account and a sending-only API key.
2. Sending domain added to Resend and verified by DNS records (SPF and DKIM as Resend lists them for the domain; a DMARC record if the domain has none).
3. Custom SMTP switched on in Supabase Auth with the values above.
4. Auth email rate limit reviewed once custom SMTP is on.
5. Test: one invitation and one password reset to an address we control; check sender name, branding, link target and that the message passes SPF and DKIM.
6. Go-live checklist row `auth_custom_smtp` marked done, and `docs/CURRENT-STATE.md` updated.

## Out of scope

- Any change to the email wording or the Links & Email Templates screen.
- Other email (website enquiries, Zoho, marketing).
- Moving the Admin to a new web address.
- Keeping any Supabase or Resend account token in an edge function (Platform Admin decision 17 Nov 2026 16:13).

## Assumptions

- A domain the organisation controls is available for sending, and someone can add DNS records to it.
- Email volume is low (staff invitations and resets), so Resend's entry plan is expected to be enough; confirm the current plan limits when the account is created.
- Template updates keep going through the admin workflow `supabase-auth-config.yml`, with Copy HTML on the tab as the fallback.

## Prerequisites and dependencies

| Item | Owner | Note |
|---|---|---|
| Choose the sending domain and sender address | Platform Admin | A subdomain kept for sending (for example `mail.<domain>`) protects the main domain's reputation |
| DNS access for that domain | Platform Admin | Records can take from minutes to a day to verify |
| Resend account owner and billing | Platform Admin | |
| Thursday 19 Nov migration squash complete | Platform Admin | Configure after it, as directed |
| If SMTP is to be applied by workflow instead of the dashboard | S1-Build lane (owns `scripts/supabase-auth-config.py`) | Needs the Resend key as a GitHub secret; the script must never print it |

## Risks

| Risk | Effect | Treatment |
|---|---|---|
| DNS records wrong or slow to verify | Emails fail or land in spam | Verify in Resend before switching SMTP on; keep the built-in service until the test passes |
| Sender address not on the verified domain | Resend rejects the send | Sender email must match the verified domain exactly |
| API key exposed | Others could send as us | Sending-only key; stored only in Supabase Auth settings (and a GitHub secret if the workflow is used); rotate if in doubt |
| SMTP fault after switch-on | No invitations or resets arrive | Turning custom SMTP off returns to the built-in service at once |
| Hourly limit still too low for a bulk invite | Some invitations are delayed | Raise the Auth email rate limit after switch-on |

## Phases and estimated hours

| Phase | Work | Estimate |
|---|---|---|
| 1. Prepare | Resend account, API key, choose domain and sender address | 0.5 h |
| 2. DNS | Add records, wait for verification | 0.5 h (plus waiting time) |
| 3. Configure | SMTP settings in Supabase Auth, rate limit review | 0.5 h |
| 4. Test and record | Invitation and reset test, checklist row, current state | 0.5 h |
| **Total** | | **About 2 hours of hands-on time** |

## Milestones

1. Sending domain verified in Resend.
2. Custom SMTP on; test invitation and reset received from StudySearch PIM Admin.
3. Go-live checklist row closed.

## Notes

- Hidden effort is most likely in DNS: who holds the domain, and whether an existing SPF or DMARC record needs merging rather than adding.
- When a separate Production project is created, repeat steps 3 and 4 there; the verified domain and DNS records are reused.
