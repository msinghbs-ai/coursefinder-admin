# Paste-ready prompt: Website API v3 build session

Copy everything inside the box into a continuous build session working on `msinghbs-ai/Coursefinder-Pilot`.

```
Build Website API v3 under CF-247, Decision 277.

Read first, in this order (coursefinder-admin, main):
1. docs/README.md (document router)
2. docs/integrations/api-v3/WEBSITE-API-V3-BUILD-BRIEF.md (scope, work packages, decisions)
3. docs/integrations/api-v3/CONSUMER-REQUESTS-REGISTER-2026-11-12.csv (REQ-01 to REQ-83, status and evidence as at 12 Nov 2026)
4. docs/integrations/WEBSITE-DEVELOPER-REQUIREMENTS.md (register of record: R1-R34, O1-O31; rule 1; R28 start_date_status)
5. docs/platform/DATA-PIPELINE-OPERATING-MODEL.md section 3.6 and docs/coursefinder-design-reference-v1.4.md Decision 277 and Decision 266

Hard rules:
- Do not alter, drop, rename or retype anything Website API v2 or Zoho API v2 reads (G3, S57 must stay green).
- v3 = new edge function website-api-v3 + public.website_v3_* functions over the same data, keys, auth, rate limit and request log.
- v3 additions merge on green until the website goes live on v3 (no comms hold). Record each in WEBSITE-DEVELOPER-REQUIREMENTS (status + History) and the v3 guide change list.
- Items marked "Decision needed" (D-1 to D-5, WP-3, WP-4) are not built until the Platform Admin records the decision.
- Null means not held. No defaults, no estimates.
- Standard gates: full suite 0 failed / 0 skipped, md5-guarded functions, dry run on live, immediate production acceptance on a bounded workload, change-control entry in the runsheet set.

Build order (brief section 4):
1. WP-0: v3 copy (edge function, website_v3_* wrappers, contract tests passing against v3) + repo R28 start_date_status.
2. WP-1.1 campus names and course counts (repo R23; rebuild the cf247-devapi-r23-r24 work as v3, do not merge into v2) and WP-1.2 nationality_eligibility_status (repo R24).
3. WP-1.3 scholarship linked-course paging (repo R29): courses_page, courses_page_size (1-200), linked_courses_total; no paging = first 200.
4. WP-1.4 to WP-1.7 and WP-2.1 (OET, CELPIP).
5. WP-6: v3 developer guide issue with field dictionary (repo R33) and the "Where to find it" answers.

Report at each work package: what was built, test evidence, live acceptance result, and the register rows updated.
```
