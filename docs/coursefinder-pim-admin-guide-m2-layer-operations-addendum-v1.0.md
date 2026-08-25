# CourseFinder PIM/Admin Guide — M2 Layer Operations Addendum v1.0

**Status:** CURRENT ADDENDUM  
**Date:** 25 August 2026  
**Parent guide:** `docs/coursefinder-pim-admin-guide-v1.17.md`  
**Change Control:** `CF-CHG-20260825-031`

## Purpose

This addendum updates the accepted PIM/Admin operating guidance for the M2 operating model. It does not change canonical field semantics from the parent guide. It adds how administrators should interpret and operate Layer 1, Layer 2, Layer 3 and Layer 4 workspaces.

## Layer 1 — Regulatory

**Business meaning:** authoritative/regulatory acquisition and reconciliation.  
**Admin validates:** source identity, source version/date, record counts, freshness, Evidence and reconciliation exceptions.  
**Do not assume:** a successful download means canonical acceptance; a newer file automatically supersedes source semantics; a Layer 2 source can redefine Layer 1 identity.

Common actions:

- inspect source health/freshness;
- inspect last successful run;
- compare discovered/accepted/rejected/unchanged counts;
- open Evidence;
- investigate identity/reconciliation conflicts;
- re-run only through governed ingestion controls.

## Layer 2 — Enrichment

**Business meaning:** deterministic first-party Course and Scholarship acquisition/extraction used to fill factual gaps without redefining Layer 1 identity.

Primary measures:

- eligible entities;
- processed entities;
- factual domains resolved;
- completeness before/after;
- paid provider attempts;
- cost/credits;
- Evidence growth;
- items marked `L3 required`.

Provider routing semantics:

- Direct HTTP is preferred where sufficient;
- richer/rendered provider use is an escalation based on factual outcome/Evidence quality;
- HTTP 200 is not equivalent to correct Course identity or factual resolution;
- provider credentials are write-only and must never be displayed back to an operator;
- a Provider Trial is a qualification/benchmark function, not evidence that Layer 2 itself is experimental.

Safe Course-fact rules:

- preserve exact Provider/Course stable identity;
- do not use a merely similar current Course when the governed source page is missing;
- keep Provider-current tuition separate from CRICOS regulated tuition concepts;
- domestic CSP/student-contribution/Band values must not be accepted as international tuition;
- unresolved facts remain `not_yet_enriched` rather than invented;
- Layer 2 apply does not authorise Search or Publication.

## Layer 3 — AI Interpretation

**Business meaning:** AI-assisted interpretation of retained Evidence only after deterministic Layer 2 cannot safely resolve the required domain.

Administrator should see:

- unresolved domain/entity;
- exact input Evidence;
- model/profile/prompt version;
- structured suggestion;
- confidence;
- deterministic validation result;
- accepted/rejected/retry/escalated state;
- token/API cost and latency;
- Layer 4 fall-out.

Rules:

- AI output is not a source authority;
- AI must not manufacture a source-null fact;
- AI must not redefine Layer 1 identity;
- a high confidence score does not override a failed deterministic validation;
- consequential or unresolved ambiguity escalates to Layer 4;
- no silent Search/publication side effect.

## Layer 4 — Human Review

Layer 4 is terminal human resolution. It should contain exception work only after deterministic and AI-assisted paths are exhausted or a policy requires human judgment.

The reviewer must see:

- entity identity;
- disputed/missing domain;
- source and Evidence;
- Layer 2 result;
- Layer 3 suggestion/validation where applicable;
- current canonical value;
- downstream consequence;
- available decision actions;
- audit trail.

## Evidence storage awareness

Evidence is a governed operational asset, not an unlimited debug dump.

Administrators should monitor:

- current Storage utilisation;
- growth by layer/source/provider;
- duplicate/unchanged snapshots;
- held/referenced Evidence that must not be deleted;
- source-specific retention class;
- storage alerts at 60%, 75% and 90%.

Do not manually delete Evidence merely to reduce storage usage if it supports a canonical fact, review decision, Change Control, UAT or legal/audit hold.

## Security operating rules

- never paste service-role, Vault or vendor secrets into tickets/chat/screenshots;
- do not use shared privileged accounts;
- verify environment before any run/change;
- advanced configuration requires the governed role/rank;
- browser-visible success does not prove server-side authorisation; automated negative RBAC UAT is required;
- a privileged RPC/security warning must be explicitly dispositioned before Production release.

## Admin escalation path

- incorrect source identity / regulated fact → Layer 1/source governance;
- deterministic acquisition/extraction failure → Layer 2 operations;
- ambiguous retained Evidence → Layer 3 interpretation;
- unresolved/consequential decision → Layer 4 review;
- Search/publication issue → Publishing/consumer governance;
- access/permission/security issue → Platform Admin/security workstream.
