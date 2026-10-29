# Layer 4 Skill — GitHub source and portable Kimi Work update

Date: 29 October 2026  
Scope: Skill documentation/package update only. No Layer 4 decisions, catalogue writes or platform code changes performed.

## Completed

The `cf-layer4-triage` / **Layer-4-Review** Skill now has canonical source in GitHub:

- `docs/platform/skills/cf-layer4-triage/SKILL.md` — commit `ce4c9ca23fafae2ebcfb5602143d2c644f0e5a36`
- `docs/platform/skills/cf-layer4-triage/references/action-playbook.md` — commit `deac07374c58a3c3453419f4e3b776807f7282fc`

The existing run/export guide was updated rather than leaving a conflicting full-queue-only SOP:

- `docs/platform/nz-enrichment-brief/2026-10-28-layer4-skill-run-and-export.md` — commit `55ce7d2b7086ac5f7f546171d8f023f9a36686a4`

## New reusable behaviour

The Skill now supports:

```text
layer4-by-kind-qualify
```

On a new workstation, untested connection or previous zero-decision/uncertain batch, this qualification is required before `layer4-clear-all`. It:

- selects one suitable existing kind and excludes higher-risk qualification categories;
- reviews at most 10 oldest items and submits at most five decisions;
- requires the first actual UI decision to be submitted and verified before continuing;
- permits up to four more individually evidenced decisions only after that verification;
- stops on uncertain writes, remaining queue items or UI/network failure;
- reports actual decisions and stable review-item ids, never snapshots or proposed actions as progress.

The provider workflow now also explicitly requires supported decisions rather than proposed-action summaries, prohibits broad By kind snapshots from substituting for provider checkpoints, and requires a new bounded qualification when a checkpoint is unavailable on another workstation.

Existing evidence, no-SQL, no-delete, no-bulk-approval, stored-source and Decided-view safeguards remain in force.

## Portable package verification

The rebuilt `cf-layer4-triage.skill` package passed the Skill validator and ZIP integrity/content checks. It contains exactly:

- `cf-layer4-triage/SKILL.md`
- `cf-layer4-triage/references/action-playbook.md`

Package size: 6,096 bytes.  
SHA-256: `6bdaa4ede2c3d224634f493522877e1a44040cf2532ac6e5f281b3006855422f`

The validated `.skill` package is delivered with the chat response; GitHub holds its canonical text source and operating guide.

## Reuse on another workstation

1. Transfer the delivered `cf-layer4-triage.skill` package to the workstation.
2. In Kimi Desktop **Work → Skills**, import/upload the package. Remove or replace an older copy so there is no ambiguity about the active version.
3. Install/connect Kimi Browser Extension and authenticate Platform Admin separately; no credentials or browser state are included.
4. Invoke the Skill and run `layer4-by-kind-qualify` before any full-queue command.
5. Transfer an in-flight consolidated checkpoint separately only when deliberately resuming an earlier batch. Otherwise start a new batch.

For subsequent changes, edit the GitHub source and regenerate the package from that source. Do not maintain independent workstation-only Skill variants.
