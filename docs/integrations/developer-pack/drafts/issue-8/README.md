# Developer pack: Issue 8 release candidate (internal)

**Status (9 Nov 2026): RELEASE CANDIDATE. Not released, not sent.** The published pack (Issue 7, `docs/integrations/developer-pack/`) is unchanged and is what the developer uses until the release.

Issue 8 adds `campus_id`, `campus_name` and `course_count` to provider `campuses[]` (R23) and `nationality_eligibility_status` to scholarships (R24). The Platform Admin approved the consumer change (G3) on 9 Nov 2026 on conditions; see `docs/platform/approvals/2026-11-06-g3-r23-r24-approval-package.md` §11. Pilot release candidate: draft PR #945. The figures and examples in the guide were measured on 9 Nov 2026 on the live project (section 8 and the examples) by evaluating the new builders inside rolled-back transactions; the API does not return the new fields yet.

## Files

| File | What it is |
|---|---|
| `StudySearch-Website-API-v2-Developer-Guide-Issue-8-RC.md` | The guide, Issue 8. Section 13 lists the API change only (new fields); the measured figures are refreshed |
| `gen_api.py` | Writes the OpenAPI and Postman files into this folder (run it from here) |
| `StudySearch-Website-API-v2.openapi.json`, `StudySearch-Website-API-v2.postman_collection.json` | Generated (schemas `ProviderCampus` and `NationalityEligibilityStatus`) |
| `examples/` | Before and after examples (campuses, scholarship nationality) |
| `HANDOVER-NOTE.md` | The developer-facing note, versioned (Issue 8, note 1.0). Sent with the guide |
| `../../handover/2026-11-09-R23-R24-campuses-nationality-HANDOVER.md` | The internal versioned handover: compatibility assessment and verification |

## On release (Integration Controller; after the migration has applied and been verified, approval package §11.4)

1. Re-measure the figures in guide section 8 and 7.4/7.5, and check the examples against the live API (they are measured from the new builders in rolled-back transactions, not from the API).
2. Set the release date: the subtitle `[RELEASE DATE: set at release]`, the section 13 line, `HANDOVER-NOTE.md` and `gen_api.py` (`info.version`). Remove the "Issue 8 (release candidate)" banner at the top of the guide.
3. Copy the guide over `../../StudySearch-Website-API-v2-Developer-Guide.md`, `gen_api.py` over `../../gen_api.py`, update the footer text in `../../polish.py` (issue number and date), run `../../build.sh` (Word, PDF, OpenAPI, Postman).
4. Send the guide (Word and PDF), the OpenAPI file, the Postman collection, the examples and `HANDOVER-NOTE.md`. Keys go by a secure channel only. Nothing in the pack names repositories, hashes or internal tools.
5. Update `../../../WEBSITE-DEVELOPER-REQUIREMENTS.md` (R23 and R24 to Done) and `docs/integrations/handover/README.md`.
