# Request register – rules for any agent or chat

**Version:** 1.0 (15 Nov 2026) · **Owner:** Platform Admin · **Change control:** CF-247

Platform Admin, 15 Nov 2026: work on the request register may come from other LLMs and chats (ChatGPT, Codex, other Claude chats). Every change must record when it was made, by which tool and in which chat, and follow the same rules.

## The file

`docs/integrations/CONSUMER-REQUESTS.csv` is the master list of developer and stakeholder requests (REQ-nn). The shared Google Sheet "StudySearch Requests – Status", the Claude working register and the weekly check are all rebuilt from it. Change the CSV only; never edit those copies directly.

This repo is **public**.

## Columns

| Column | What goes in it |
|---|---|
| `req_id` | REQ-nn. Never change or reuse one. A new request takes the next number after the highest existing REQ. |
| `module` | One of: Courses, Intakes, Fees, English tests, Academic entry (AER), Providers, Campuses, Scholarships, Rankings and outcomes, API and integration, Data and reference |
| `request` | The ask, in plain words |
| `status` | One of: Delivered, Live in v3, Partly delivered, API change, New field needed, Open, Declined |
| `requested_by` | Divya, Raghav, Sujata, Saurabh (or "A / B") |
| `date_asked` | YYYY-MM-DD |
| `evidence` | What proves the status (function, field, file, query result) |
| `response_so_far` | Dated log, newest last: `YYYY-MM-DD HH:MM [tool · chat]: what was done` |
| `next_action` | The next step |
| `decision_needed` | No, or the decision and who makes it |
| `source` | Email subject, PDF name or call note |
| `repo_item` | R / O / Z item in WEBSITE-DEVELOPER-REQUIREMENTS.md |
| `build_home` | Where it gets built (API v3, Data work, Zoho setting …) |
| `updated_at` | Date and time of this change, Melbourne time: `YYYY-MM-DD HH:MM` |
| `updated_by` | The tool that made the change: Claude, ChatGPT, Codex … |
| `chat_name` | The name of the chat or session the change came from, exactly as it shows in that tool |

## Rules

1. Change only `CONSUMER-REQUESTS.csv` (and, for a new R/O/Z item, its row in `WEBSITE-DEVELOPER-REQUIREMENTS.md`). Never edit the Google Sheets, the roadmap files or other documents.
2. Status meanings:
   - **Delivered**: the API the developer uses today serves the whole request.
   - **Live in v3**: API v3 serves the whole request.
   - **Partly delivered**: only part of it is served.
   Put the evidence for the status in `evidence`.
3. On every row you change, set `updated_at`, `updated_by` and `chat_name`, and add one line to `response_so_far` in the format above. Keep all earlier text.
4. REQ items belong only in this register. Never put REQ IDs in roadmap (RM) files.
5. Confidential: no Study Square staff comments, email text, attachments, API keys or personal email addresses. Staff comments stay in the Platform Admin's working sheet only.
6. Use Australian English and plain language.
7. Work on a branch named `docs/requests-<tool>-YYYY-MM-DD` and open a PR. Do not merge it. In the PR description, list each REQ changed with its status before and after, plus the tool and chat name. Changes that affect the consumer APIs wait for developer comms before release.
8. Before you finish, re-read the CSV from the branch and check that:
   - it still has 16 columns on every row;
   - every `req_id` is unique;
   - every `status` and `module` value is from the lists above.
