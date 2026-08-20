# CourseFinder PIM Admin v2.11 — Final Deployed Browser Acceptance UAT

**Date:** 20 August 2026  
**Acceptance time:** 22:42 AEST  
**Verdict:** **PASS**  
**Change Control:** `CF-CHG-20260820-015`  
**Deployed Pilot head:** `b3867cc89bbfd3f76def01993a70868318016ef0`

## Purpose

Close the remaining deployed authenticated browser and visual/interaction gate for M1-PIM-FINALISATION after the governed RPC recovery and v2.11 UX maturity remediation.

## Preconditions already passed

- `public.admin_read(text,jsonb)` is the governed browser read boundary and remains SECURITY INVOKER;
- authenticated EXECUTE on `admin_read` = yes; anon = no;
- public SECURITY DEFINER functions executable by authenticated = 0;
- public SECURITY DEFINER functions executable by anon = 0;
- legacy `ui_*` SECURITY DEFINER functions executable by authenticated = 0;
- Pilot Frontend Build run #86 passed on Node 22.23.2 with 0 reported vulnerabilities;
- exact Provider `00025B` and Course `121174E` regressions passed;
- AU governed filter UAT returned 8 State/Region options, 1,546 Course Provider options, 20 Study Levels and 79 Fields.

## Deployed release proof

The operator confirmed the Cloudflare-served interface loaded with the visible marker:

`PIM Admin v2.11 · governed`

`Coursefinder-Pilot/main` was independently rechecked and remained at the accepted release head:

`b3867cc89bbfd3f76def01993a70868318016ef0`

## Runtime telemetry

Fresh authenticated browser activity from approximately **22:37–22:41 AEST** used:

`/rest/v1/rpc/admin_read`

Observed acceptance-window results:

- HTTP 200 responses only for the fresh governed browser RPC requests;
- no new direct legacy `/rpc/ui_*` browser calls;
- no fresh 4xx or 5xx API responses;
- no ACL compatibility exception was introduced.

## Visual and interaction acceptance

The operator explicitly reported:

**`v2.11 visual UAT pass`**

This accepts the deployed v2.11 interaction set, including:

- semantic Dashboard icons and restrained status colour;
- Operational Pulse, Recent Activity and Attention / Next Actions;
- populated governed Provider filters;
- populated governed Course Country/State/Provider/Study Level/Field and decision filters;
- exact Provider/Course search behaviour;
- fixed Brand/Account regions with independently scrollable navigation and lower menu reachability;
- responsive/off-canvas navigation;
- usable table/detail interactions without the prior permission-driven blank states.

## Final decision

**PASS — M1-PIM-FINALISATION deployed browser and visual acceptance gate is complete.**

`CF-CHG-20260820-015` is closed. The shared browser blocker for `CF-CHG-20260820-001` and `005`–`014` is also satisfied and those records may be classified CLOSED / PASS in the authoritative register.

No Provider/Course identity, CRICOS fee semantics, provenance authority, Search admission, publication boundary or internal-schema browser privilege was changed to achieve this acceptance.