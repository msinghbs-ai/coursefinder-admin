# CF-CHG-20260829-046 — Institute International Contact Intelligence

**Status:** ACTIVE — A15 IMPLEMENTATION / TARGETED UAT
**Category:** 40-layer2-enrichment
**Initiated:** 29 August 2026
**Origin chat/workstream:** M2.4.3 addendum — institute manager / international contact details
**Owner:** M2.4.3 workstream
**Change class:** schema/enrichment/privacy/UI/UAT/operations

## Trigger

User requested Provider/Institute detail to include institute manager / international-course contact details, deterministic scraping of university International/Regional Manager contact pages across AU/NZ, and optional licensed professional enrichment/job-title change monitoring.

## Governing design

A15 introduces **international contact intelligence** without creating a new identity authority.

1. First-party university pages are preferred and stored as governed Layer 2 Evidence-backed observations.
2. Licensed professional enrichment (for example Apollo/ZoomInfo-equivalent APIs) is secondary context and must never overwrite first-party university-published contact facts.
3. LinkedIn HTML scraping is not authorised. Any LinkedIn-derived field must arrive through a licensed/authorised enrichment provider or a first-party university page that links to the profile.
4. Personal-email/mobile reveal is disabled by default. The initial provider adapter searches title/domain and stores professional profile/title context only.
5. Provider/Course identity, Search and Publication authority are unchanged.
6. Every contact retains source class, source URL/provider, observed/verified timestamps, territory text/codes, and Evidence where available.
7. Job-title/contact changes create explicit watch events rather than silently replacing history.
8. A14 telemetry extends to contact discovery/enrichment attempts: provider, calls, units/credits where available, latency, cost where available, outcome and timestamps.

## Initial target cohort

Derived from governed catalogue rather than a hard-coded list:
- AU: 52 providers with governed website and University naming;
- NZ: 8 providers with governed website and University/Te Pūkenga naming;
- total initial profiles: 60.

## UI

Provider detail receives a dedicated **International contacts** section above generic object dumps:
- name / team;
- job title;
- territory/market assignment;
- work email / work phone when first-party or licensed business-contact data permits;
- source class badge;
- source/provider link;
- observed/verified freshness;
- Evidence link for first-party scrape;
- recent title/contact-change signals.

Course detail may later consume Provider contact context read-only, but A15 first acceptance is Provider-detail only.

## Acceptance

Targeted automated UAT must prove:
- profile seed count by AU/NZ;
- anonymous/direct-table negatives;
- Provider detail read projection;
- first-party precedence over licensed enrichment;
- no personal-email/phone reveal in the Apollo search adapter;
- change-watch event creation;
- browser Provider blade rendering;
- Security/Performance Advisors no new WARN/ERROR;
- no canonical/Search/Publication mutation.


## Implementation checkpoint — 29 August 2026

Pilot implementation refs:
- `190a1e9d6c8ec7f8eea6c6c5692e778233e030cd` — private contact schema + Provider-detail projection;
- `5bc47a2291add9cc1c14e168d108d49de2fa9814` — nonce allowlist;
- `88be2c7c1c6a16d9006e357db7a319e7f6b443cd` — service-role bridge;
- `938a5440f2000593bafc5c9d267a19369731198e` — Apollo adapter through service bridge;
- `4f2b36ba2b3c26549f519322513ca7d37348723b` — structured table precedence;
- `0269c59443f46abd07cc88dda4bde94106dbe959` — governed Provider origins/subdomains;
- `bc87d580f6924b53f47028b199122b64d393ee44` — meaningful contact-change semantics;
- `305fcb1fe6246aa418ae1877a1b79748f2199307` — transport URL normalization + provider lookup;
- `5b8ad0717076a55348f8054a43d943bfa8ddcf45` — governed Firecrawl fallback + A14-style acquisition telemetry;
- `24d5ddc68c3f7bef0cf86debca83bd291a1400ea` — Provider blade International contacts;
- `e0c32e0b8a21847be1ba1756d2ff3eea4c41091e` — PIM Admin v2.15.10 release notes;
- `80ee906c91c09026586bd717e7c41235b679dbfa` — permanent A15 deployed UAT;
- `1c6fa1992a8068b408df1ef9bcb7cb59a535bf2c` — A15 UAT tier wiring.

Live evidence:
- initial target cohort: 52 AU + 8 NZ = 60 governed contact profiles;
- UQ final structured proof: 8 current first-party regional-manager territory rows with institutional emails and Evidence;
- targeted deployed browser UAT: PASS, run `33221965310`;
- initial noisy UQ probes retained as rejected/non-current historical Evidence rather than deleted;
- ACU direct HTTP 403 and three malformed NZ canonical website values discovered during rollout and handled without Layer 1 overwrite.

Open before closure:
- complete and reconcile the 60-profile first-party rollout;
- verify Firecrawl fallback proof on blocked sites;
- verify Apollo credential/configuration and bounded no-reveal search if configured;
- run Security/Performance Advisors;
- integration + final acceptance per M2 execution discipline;
- close/update documentation and exact runtime refs.

## Runtime/security checkpoint — 29 August 2026

- Current A15 security advisor: 135 INFO / 0 WARN / 0 ERROR.
- Current A15 performance advisor: 171 INFO / 0 WARN / 0 ERROR.
- Apollo Pilot probe: configuration BLOCKED because `APOLLO_API_KEY` is not configured; probe confirmed `personal_email_requested=false` and `phone_requested=false`. This is non-blocking for first-party rollout.
- Current first-party worker after rollout efficiency hardening: `provider-contact-discover-scheduled-v1.2.3` / Edge v9.
