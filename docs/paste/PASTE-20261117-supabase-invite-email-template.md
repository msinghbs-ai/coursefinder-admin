# PASTE-20261117 — Supabase Auth: invitation and password reset emails, and the redirect allow-list

**For:** the Platform Admin, in the Supabase dashboard of project `fxcwkweaxjtknorudmwp` only (never `coursefinder-demo`).
**Prepared by:** Pilot release v2.16.16 (Pilot PR #1189; Platform Admin 16 Nov 2026 22:12). No SQL: these are dashboard settings.
**When:** before the next invitation or password reset is sent from Administration › Users & roles. Until step 1 is done, Supabase ignores the admin sign-in address and sends people to the dashboard's Site URL.

## From v2.16.20: edit the emails in the Admin (17 Nov 2026)

The two emails can now be edited on Administration › Users & roles › Links & Email Templates (Platform Admin). The templates below stay valid until a save there is copied to Supabase Auth.

Decision (Platform Admin 17 Nov 2026 16:13): no Supabase account token is kept in the edge function, so the tab does not write to Supabase Auth. After a save on the tab, bring steps 2 and 3 below up to date (Copy HTML for Supabase Dashboard gives the exact text) and run workflow `supabase-auth-config.yml` in apply mode, or paste the copied HTML in the dashboard. Step 1 (the redirect allow-list) is applied by the same workflow.

From 17 Nov 2026 16:10 AEDT the templates in steps 2 and 3 are the `#0b6e5f` StudySearch PIM Admin defaults of Links & Email Templates (Pilot migration `20261117152700`), written as Supabase Auth reads them; from 16:45 a person with no name is greeted without a stray comma. The sender name is set with custom SMTP: `docs/platform/SUPABASE-AUTH-CUSTOM-SMTP-RESEND-SCOPE.md`.

## What the release sends

| Email | Sent by | Link returns to | Template data |
|---|---|---|---|
| Invite user | Users & roles › Create user › Send invitation (`admin-user-management`, `inviteUserByEmail`) | `https://coursefinder-pilot.techm.workers.dev/` (admin sign-in) | `{{ .Data.full_name }}`, `{{ .Data.role }}`, `{{ .Data.guide_url }}` |
| Reset password | Users & roles › Reset password (another person, not a Platform Admin), or Forgot password? on the sign-in screen | the same admin sign-in | the person's saved metadata (invited people have `guide_url`; accounts created with a password may not) |

The link signs the person in and opens **Choose a new password** (invitation: **Welcome**). They choose a password of 12 characters or more, then go on to the workspace.

## Step 1 — URL Configuration (Authentication › URL Configuration)

1. **Site URL:** `https://coursefinder-pilot.techm.workers.dev`
2. **Redirect URLs:** add both of these and save:
   - `https://coursefinder-pilot.techm.workers.dev/`
   - `https://coursefinder-pilot.techm.workers.dev/**`
3. Keep `http://localhost:5173/**` only if someone develops locally; remove any other address you do not recognise.

If a later production address replaces the Worker, add it here first, then set the edge function secret `ADMIN_LOGIN_URL` to it (https only; a supabase.co address is refused and the Worker is used).

## Step 2 — Invite user template (Authentication › Emails › Templates › Invite user)

**Subject:** `You're invited to StudySearch PIM Admin`

**Message body (HTML), paste as is:**

```html
<div style="font-family:Arial,Helvetica,sans-serif;max-width:560px;margin:0 auto;color:#18211d">
  <div style="background:#0b6e5f;color:#ffffff;padding:18px 24px;border-radius:8px 8px 0 0">
    <strong style="font-size:18px">StudySearch PIM Admin</strong>
  </div>
  <div style="border:1px solid #d6ddd9;border-top:0;padding:24px;border-radius:0 0 8px 8px">
    <h2 style="margin:0 0 4px;color:#0b6e5f">Welcome{{ if .Data.full_name }}, {{ .Data.full_name }}{{ end }}</h2>
    <p style="margin:0 0 16px;color:#5d6b64">{{ .Email }}</p>
    <p>You have been given access to StudySearch PIM Admin as <strong>{{ .Data.role }}</strong>.</p>
    <p style="margin:24px 0"><a href="{{ .ConfirmationURL }}" style="background:#0b6e5f;color:#ffffff;text-decoration:none;padding:12px 20px;border-radius:6px;font-weight:bold">Accept the invitation</a></p>
    <p style="font-size:13px;color:#5d6b64">The button opens the Admin sign-in, where you choose a password of 12 characters or more. If the button does not work, copy this address into your browser:<br>{{ .ConfirmationURL }}</p>
    <p>New to the platform? Read the <a href="https://coursefinder-pilot.techm.workers.dev/#platform-guide" style="color:#0b6e5f">Platform guide</a> after you sign in.</p>
    <p style="font-size:12px;color:#5d6b64;margin-top:24px">If you were not expecting this invitation, you can ignore this email.</p>
  </div>
</div>
```

## Step 3 — Reset password template (Authentication › Emails › Templates › Reset password)

**Subject:** `Reset your StudySearch PIM Admin password`

**Message body (HTML), paste as is:**

```html
<div style="font-family:Arial,Helvetica,sans-serif;max-width:560px;margin:0 auto;color:#18211d">
  <div style="background:#0b6e5f;color:#ffffff;padding:18px 24px;border-radius:8px 8px 0 0">
    <strong style="font-size:18px">StudySearch PIM Admin</strong>
  </div>
  <div style="border:1px solid #d6ddd9;border-top:0;padding:24px;border-radius:0 0 8px 8px">
    <h2 style="margin:0 0 4px;color:#0b6e5f">Reset your password</h2>
    <p style="margin:0 0 16px;color:#5d6b64">{{ .Email }}</p>
    <p>Hello{{ if .Data.full_name }} {{ .Data.full_name }}{{ end }}, a password reset was requested for your StudySearch PIM Admin account ({{ .Data.role }}).</p>
    <p style="margin:24px 0"><a href="{{ .ConfirmationURL }}" style="background:#0b6e5f;color:#ffffff;text-decoration:none;padding:12px 20px;border-radius:6px;font-weight:bold">Choose a new password</a></p>
    <p style="font-size:13px;color:#5d6b64">Your current password keeps working until you choose a new one. If the button does not work, copy this address into your browser:<br>{{ .ConfirmationURL }}</p>
    <p>The <a href="https://coursefinder-pilot.techm.workers.dev/#platform-guide" style="color:#0b6e5f">Platform guide</a> explains each screen.</p>
    <p style="font-size:12px;color:#5d6b64;margin-top:24px">If you did not ask for this, you can ignore this email; nothing changes.</p>
  </div>
</div>
```

## Step 4 — Check

1. Users & roles › Create user › Send invitation to a test address you control, with a full name and the Viewer role.
2. The email greets the name, names the role, and its button opens `https://coursefinder-pilot.techm.workers.dev/` (not a supabase.co page). The page asks for a password; after saving it, the workspace opens.
3. Sign out, choose Forgot password? with the same address, and follow the reset email the same way.
4. Delete the test user from Users & roles when done.

If the button opens a Supabase page or the Site URL without asking for a password, step 1 is not saved: check the Redirect URLs list and try a new invitation (old links keep their old address).
