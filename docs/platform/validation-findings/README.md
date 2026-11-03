# Independent validation findings (interim path)

**Decision:** D7 (Platform Admin, 3 Nov 2026 13:09). The existing integration queue (`pipeline.integration_issues`) is the primary, durable destination for the hourly independent ChatGPT validation.

## Interim path

Use this path until the validator writes to the queue directly.

**What the validator does**

- Write one Markdown file per run, named `YYYY-MM-DD-HHMM-validation.md`.
- For each finding, give:
  - a stable fingerprint;
  - severity;
  - field and country;
  - the evidence (the query and the result);
  - the time observed.

**How the Integration Controller ingests a file**

1. Read new files on each checkpoint.
2. Look up each fingerprint with `security.integration_issue_upsert_v1`. An existing issue is updated (`observed_again`); a closed issue that recurs is reopened as a regression; a new fingerprint creates an issue.
3. Append the issue reference to the finding in the file and commit, so every finding is traceable to an issue.

There is no automatic Claude-to-ChatGPT communication; it has not been demonstrated.
