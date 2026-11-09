# Developer pack: Issue 8 release candidate (internal)

**Status (9 Nov 2026 19:18 AEDT): FINAL Issue 8, prepared for the release. Not yet released, not yet sent.** The Platform Admin formally authorised the G3 change on 9 Nov 2026 at 19:18 AEDT, in chat. The published pack (Issue 7, `docs/integrations/developer-pack/`) is unchanged and is what the developer uses until the release day.

Issue 8 adds `campus_id`, `campus_name` and `course_count` to provider `campuses[]` (R23) and `nationality_eligibility_status` to scholarships (R24). See `docs/platform/approvals/2026-11-06-g3-r23-r24-approval-package.md` §9 and §11 for the approval record and the release steps. The figures and examples in the guide were measured on 9 Nov 2026 on the live project (section 8 and the examples) by evaluating the new builders inside rolled-back transactions; the API does not return the new fields until the release.

## Files

| File | What it is |
|---|---|
| `StudySearch-Website-API-v2-Developer-Guide-Issue-8.md` | The guide, Issue 8 (final). Section 13 lists the API change only; the measured figures are refreshed. The release day is worded as "the day it is released, announced in the cover note" |
| `StudySearch-Website-API-v2-Developer-Guide-Issue-8.docx`, `.pdf` | The guide built for sending (built with the `build.sh` steps and the Issue 8 footer; the footer reads "release day announced in the cover note") |
| `gen_api.py` | Writes the OpenAPI and Postman files into this folder (run it from here) |
| `StudySearch-Website-API-v2.openapi.json`, `StudySearch-Website-API-v2.postman_collection.json` | Generated (schemas `ProviderCampus` and `NationalityEligibilityStatus`) |
| `examples/` | Before and after examples (campuses, scholarship nationality) |
| `HANDOVER-NOTE.md` | The developer-facing note, versioned (Issue 8, note 1.1). Sent with the guide |
| `../../../handover/2026-11-09-R23-R24-cover-email-wix-developer.md` | The cover email to the Wix developer, ready to send (the release day is filled in when it is sent) |
| `../../handover/2026-11-09-R23-R24-campuses-nationality-HANDOVER.md` | The internal versioned handover: compatibility assessment and verification |

## On release (Integration Controller; after the migration has applied and been verified, approval package §11.4)

1. Re-measure the figures in guide section 8 and 7.4/7.5, and check the examples against the live API (they are measured from the new builders in rolled-back transactions, not from the API). If a figure moved, correct it in the guide and rebuild.
2. The release day is already worded as "the day it is released, announced in the cover note". Only if the Platform Admin asks for a dated line: set it in the subtitle, the section 13 first column, `HANDOVER-NOTE.md`, `gen_api.py` (`info.version`) and the footer in `../../polish.py`.
3. Copy the guide over `../../StudySearch-Website-API-v2-Developer-Guide.md`, `gen_api.py` over `../../gen_api.py`, update the footer text in `../../polish.py` (issue number and release line), run `../../build.sh` (Word, PDF, OpenAPI, Postman). The Word and PDF files in this folder are the same build and may be sent as they are.
4. Send the guide (Word and PDF), the OpenAPI file, the Postman collection, the examples and `HANDOVER-NOTE.md` with the cover email. Keys go by a secure channel only. Nothing in the pack names repositories, hashes or internal tools.
5. Update `../../../WEBSITE-DEVELOPER-REQUIREMENTS.md` (R23 and R24 to Done) and `docs/integrations/handover/README.md`.
