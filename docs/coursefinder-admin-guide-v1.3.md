# Coursefinder — Admin Guide v1.3

## Layer 1 — Controlled Regulatory Ingestion

Layer 1 is the authoritative regulatory ingestion layer. Platform Admin operates it from **Settings → Regulatory Sources**.

### Australia CRICOS UAT workflow

The AU control intentionally separates validation from writes:

1. **Dry-run (100)** — downloads the configured CRICOS Institutions and Courses resources, stores private evidence, records hashes/job/source health and parses the first 100 selected course records. No catalogue changes occur.
2. **Apply first 100** — performs regulator identity reconciliation and may create/link Providers, Courses and CRICOS registrations. The administrator must type `APPLY 100` before the action is enabled.
3. **Re-run same 100** — repeats the exact controlled slice to prove idempotency. The expected result is no duplicate entity or registration creation.

### What the administrator must review

After an apply, review the result panel for:

- Providers created / linked;
- Courses created / linked;
- Conflicts;
- Evidence file count;
- Job ID;
- parsed and selected record counts.

The administrator must sample affected catalogue records and confirm that regulator identifiers, provider ownership and course titles are reconciled correctly before increasing the ingestion scope.

### Safety boundaries

- Only Platform Admin can trigger browser-based Layer 1 runs.
- Browser requests use the authenticated Supabase session; `LAYER1_RUN_KEY` is not exposed to users.
- Full CRICOS ingestion is not presented in the Pilot UI until controlled UAT passes.
- Ambiguous identities must not be silently merged.
- Every run records job and source-health telemetry.
- Regulatory evidence remains private and hash-addressed.

## Current AU UAT baseline

The first successful AU dry-run parsed 26,738 CRICOS course records and selected 100. Two CRICOS evidence CSVs were stored with SHA-256 hashes, and no provider/course/registration writes were made.

## Next operational gate

Run **Apply first 100**, inspect reconciliation, then **Re-run same 100**. Only after duplicate-free idempotency and sampled identity validation should AU scope be expanded.
