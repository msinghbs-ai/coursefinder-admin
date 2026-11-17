#!/usr/bin/env python3
"""Supabase Auth URL configuration and the two branded emails (Platform Admin 17 Nov 2026 14:12; docs/paste/PASTE-20261117-supabase-invite-email-template.md).

  python3 scripts/supabase-auth-config.py check     read only: prints site_url, uri_allow_list, the two subjects and whether the templates match the paste file
  python3 scripts/supabase-auth-config.py apply     sets what differs (site_url, the two redirect URLs added to what is there, both subjects and templates), reads back

Production only (fxcwkweaxjtknorudmwp; coursefinder-demo is refused). This repository is public: only the fields above and the templates' md5 are printed,
never the rest of the Auth configuration (it holds secrets).
"""
import hashlib, json, os, re, sys, urllib.error, urllib.request

PROJECT = os.environ.get("PROJECT", "")
if PROJECT != "fxcwkweaxjtknorudmwp":
    sys.exit(f"refused: project {PROJECT!r} is not fxcwkweaxjtknorudmwp")
TOKEN = os.environ.get("SUPABASE_ACCESS_TOKEN") or sys.exit("SUPABASE_ACCESS_TOKEN is not set")
API = os.environ.get("SUPABASE_API_BASE", "https://api.supabase.com/v1/projects")
PASTE = os.environ.get("PASTE", "docs/paste/PASTE-20261117-supabase-invite-email-template.md")
SITE = "https://coursefinder-pilot.techm.workers.dev"
REDIRECTS = [SITE + "/", SITE + "/**"]


def call(method, body=None):
    req = urllib.request.Request(f"{API}/{PROJECT}/config/auth", method=method, data=json.dumps(body).encode() if body is not None else None,
                                 headers={"Authorization": f"Bearer {TOKEN}", "Content-Type": "application/json"})
    try:
        return json.load(urllib.request.urlopen(req, timeout=60))
    except urllib.error.HTTPError as e:  # the message only; never the request body
        sys.exit(f"{method} config/auth: HTTP {e.code}: {e.read().decode(errors='replace')[:300]}")


def paste():
    """Subject (in backticks after **Subject:**) and the html block that follows it, for Step 2 (invite) and Step 3 (reset password)."""
    text = open(PASTE, encoding="utf-8").read()
    out = {}
    for key, head in (("invite", "## Step 2"), ("recovery", "## Step 3")):
        part = text[text.index(head):]
        subject = re.search(r"\*\*Subject:\*\* `([^`]+)`", part).group(1)
        html = re.search(r"```html\n(.*?)\n```", part, re.S).group(1)
        out[key] = (subject, html)
    return out


def md5(s):
    return hashlib.md5((s or "").encode()).hexdigest()


def summary(cfg, want):
    allow = [u for u in (cfg.get("uri_allow_list") or "").split(",") if u]
    return {
        "site_url": cfg.get("site_url"),
        "uri_allow_list": allow,
        "redirects_present": {u: u in allow for u in REDIRECTS},
        "mailer_subjects_invite": cfg.get("mailer_subjects_invite"),
        "mailer_subjects_recovery": cfg.get("mailer_subjects_recovery"),
        "invite_template_md5": md5(cfg.get("mailer_templates_invite_content")),
        "recovery_template_md5": md5(cfg.get("mailer_templates_recovery_content")),
        "invite_matches_paste": cfg.get("mailer_subjects_invite") == want["invite"][0] and cfg.get("mailer_templates_invite_content") == want["invite"][1],
        "recovery_matches_paste": cfg.get("mailer_subjects_recovery") == want["recovery"][0] and cfg.get("mailer_templates_recovery_content") == want["recovery"][1],
    }


def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "check"
    want = paste()
    before = call("GET")
    s0 = summary(before, want)
    print("before:", json.dumps(s0, indent=1))
    if mode == "check":
        return
    if mode != "apply":
        sys.exit("usage: check | apply")
    patch = {}
    if before.get("site_url") != SITE:
        patch["site_url"] = SITE
    allow = [u for u in (before.get("uri_allow_list") or "").split(",") if u]
    missing = [u for u in REDIRECTS if u not in allow]
    if missing:
        patch["uri_allow_list"] = ",".join(allow + missing)  # adds; never removes an address that is there
    for key in ("invite", "recovery"):
        subject, html = want[key]
        if before.get(f"mailer_subjects_{key}") != subject:
            patch[f"mailer_subjects_{key}"] = subject
        if before.get(f"mailer_templates_{key}_content") != html:
            patch[f"mailer_templates_{key}_content"] = html
    print("changing:", sorted(patch) or "nothing")
    if patch:
        call("PATCH", patch)
    after = call("GET")
    s1 = summary(after, want)
    print("after:", json.dumps(s1, indent=1))
    ok = s1["site_url"] == SITE and all(s1["redirects_present"].values()) and s1["invite_matches_paste"] and s1["recovery_matches_paste"] \
        and set(allow) <= set(s1["uri_allow_list"])
    print("PASS" if ok else "FAIL")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
