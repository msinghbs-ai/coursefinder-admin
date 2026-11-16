# PASTE-20261117 — Supabase Auth: invitation and password reset emails, and the redirect allow-list

**For:** the Platform Admin, in the Supabase dashboard of project `fxcwkweaxjtknorudmwp` only (never `coursefinder-demo`).
**Prepared by:** Pilot release v2.16.16 (Pilot PR #1189; Platform Admin 16 Nov 2026 22:12). No SQL: these are dashboard settings.
**When:** before the next invitation or password reset is sent from Administration › Users & roles. Until step 1 is done, Supabase ignores the admin sign-in address and sends people to the dashboard's Site URL.

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

**Subject:** `You're invited to StudySearch Admin`

**Message body (HTML), paste as is:**

```html
<div style="font-family:Arial,Helvetica,sans-serif;max-width:560px;margin:0 auto;color:#1e293b;line-height:1.5">
  <h2 style="color:#3730a3;margin-bottom:4px">Welcome to StudySearch{{ if .Data.full_name }}, {{ .Data.full_name }}{{ end }}</h2>
  <p style="margin-top:0;color:#64748b">StudySearch Admin · {{ .Email }}</p>

  <p>You have been given access to StudySearch Admin{{ if .Data.role }} as <strong>{{ .Data.role }}</strong>{{ end }}. StudySearch is the course and provider catalogue our counsellors use to advise students on study in Australia, New Zealand and Canada.</p>

  <p style="margin:24px 0">
    <a href="{{ .ConfirmationURL }}" style="background:#4f46e5;color:#ffffff;text-decoration:none;padding:12px 20px;border-radius:8px;font-weight:bold">Accept the invitation and choose your password</a>
  </p>
  <p style="font-size:13px;color:#64748b">The button opens the StudySearch Admin sign-in at {{ .SiteURL }}. You will be asked to choose a password (12 characters or more); after that you sign in with your email and that password. The link works once and expires; if it has expired, ask the Platform Admin to send a new invitation.</p>

  <h3 style="margin-bottom:4px">What you will find</h3>
  <ul style="padding-left:18px">
    <li><strong>Courses</strong>: every course with its provider, study level, fees, intakes, entry and English requirements and the official course page.</li>
    <li><strong>Providers</strong>: universities and colleges, their locations, courses and scholarships.</li>
    <li><strong>Scholarships</strong>: published scholarships and who can apply.</li>
    <li>Search and filters on every list, and <strong>Export CSV</strong> to take a filtered list into Excel.</li>
  </ul>

  <h3 style="margin-bottom:4px">Please test</h3>
  <ol style="padding-left:18px">
    <li>Accept the invitation, choose your password, then sign out and sign in again with it.</li>
    <li>Find a course you know well (search by name), open it and check the fee, intake and entry requirements against the official page.</li>
    <li>Filter Courses by country and study level, then Export CSV › Export visible columns and open the file in Excel.</li>
    <li>Tell us anything that looks wrong, with the course or provider name and what you expected.</li>
  </ol>

  {{ if .Data.guide_url }}<p>New to the platform? Read the <a href="{{ .Data.guide_url }}">Platform guide</a> after you sign in.</p>{{ end }}
  <p style="font-size:12px;color:#94a3b8;margin-top:28px">If you were not expecting this invitation, you can ignore this email; no account is active until the invitation is accepted.</p>
</div>
```

## Step 3 — Reset password template (Authentication › Emails › Templates › Reset password)

**Subject:** `Reset your StudySearch Admin password`

**Message body (HTML), paste as is:**

```html
<div style="font-family:Arial,Helvetica,sans-serif;max-width:560px;margin:0 auto;color:#1e293b;line-height:1.5">
  <h2 style="color:#3730a3;margin-bottom:4px">Reset your StudySearch Admin password</h2>
  <p style="margin-top:0;color:#64748b">{{ .Email }}</p>

  <p>We received a request to reset the password for your StudySearch Admin account{{ if .Data.full_name }}, {{ .Data.full_name }}{{ end }}.</p>

  <p style="margin:24px 0">
    <a href="{{ .ConfirmationURL }}" style="background:#4f46e5;color:#ffffff;text-decoration:none;padding:12px 20px;border-radius:8px;font-weight:bold">Choose a new password</a>
  </p>
  <p style="font-size:13px;color:#64748b">The button opens the StudySearch Admin sign-in at {{ .SiteURL }}, where you choose a new password (12 characters or more). Your current password keeps working until you do. The link works once and expires.</p>

  {{ if .Data.guide_url }}<p>The <a href="{{ .Data.guide_url }}">Platform guide</a> explains each screen.</p>{{ end }}
  <p style="font-size:12px;color:#94a3b8;margin-top:28px">If you did not ask for this, ignore this email; your password does not change.</p>
</div>
```

## Step 4 — Check

1. Users & roles › Create user › Send invitation to a test address you control, with a full name and the Viewer role.
2. The email greets the name, names the role, and its button opens `https://coursefinder-pilot.techm.workers.dev/` (not a supabase.co page). The page asks for a password; after saving it, the workspace opens.
3. Sign out, choose Forgot password? with the same address, and follow the reset email the same way.
4. Delete the test user from Users & roles when done.

If the button opens a Supabase page or the Site URL without asking for a password, step 1 is not saved: check the Redirect URLs list and try a new invitation (old links keep their old address).
