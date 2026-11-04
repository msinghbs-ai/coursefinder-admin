<!-- Platform Admin direction, received 4 Nov 2026 12:16 AEDT in the Integration Controller session; recorded verbatim before code. -->

StudySearch — RMIT AER Layer 4 Settlement and Recovery

Continue the existing AER and human-assisted recovery workstreams.

Platform Admin observation: RMIT has 303 waiting AER items. The mobile Layer 4 interface now exposes recovery actions, but reviewers need a clear, efficient path to admit valid records.

Immediate example: RMIT Diploma of Commerce, CRICOS 111278B, held under E13 with four waiting rows and two dropped requirements ("score_without_basis"). The existing stored evidence is available; the last attempt was refused.

Required work

1. Reconcile all 303 RMIT items against current live status and avoid stale or duplicate actions.

2. Classify every item into:
   - Ready for authorised admission.
   - Technically blocked, with recovery possible.
   - Needs missing evidence or manual input.
   - Invalid, stale or superseded.

3. For E13 cases, use the existing recovery contract to distinguish a correctable extraction from a deterministic repeat failure. Do not repeatedly spend AI credits on unchanged evidence when the reader has not been corrected.

4. For the Diploma of Commerce example, validate whether the current reader can resolve "score_without_basis" from the stored source. If yes, execute the approved bounded re-read through the normal platform route. Otherwise create or update the human-assisted intervention requesting the exact missing evidence or correction.

5. Present review-ready RMIT items first, with existing Layer 4 approve actions enabled only when all applicable guards pass.

6. Preserve item-by-item admission, human authority, source quotation, audience, manual locks and audit history. No blanket approval.

7. Replace the mobile Recovery case raw JSON with a readable summary, failure classification, next action, and expandable list of related items.

8. Add a university-level summary: pending, review-ready, technically held, human input required, admitted and unresolved. Selecting the AER pill should filter to the appropriate university's pending AER items.

9. Demonstrate one full lifecycle: held → corrected extraction → review-ready → authorised approval → active catalogue rows → consumer verification.

10. Record submitted, saved, admitted and published counts separately in the existing Admin execution register.

Objective: Give a reviewer actionable RMIT AER decisions rather than forcing them to inspect 303 mixed items or repeatedly reject incomplete reads. Keep other universities progressing independently.
