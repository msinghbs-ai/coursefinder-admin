# M2.4.6 Execution Priority — Admission First

**Effective:** 15 September 2026 AEST  
**Directive:** move accepted data to governed consumers quickly; do not turn every operational improvement into a prerequisite.

## Permanent stop rule

A newly discovered issue may block the active gate only when it directly prevents one of:

1. safe deterministic admission of already-qualified Evidence-backed data;
2. required security/identity/Layer authority;
3. Search/API consumer correctness;
4. bounded recovery from an active runtime failure.

Everything else is recorded as a follow-up for the owning later gate and must not expand M2.4.6.

Do not redesign working accepted paths merely because an improvement is possible. Prefer reuse of accepted runtime functions, bounded data admission and measurable consumer output.

## Admission-first sequence

1. Admit all currently eligible deterministic qualified fields using accepted replay/admission functions.
2. Apply governed Search projection and verify the website API consumes the new values.
3. Keep ambiguous values in the existing Layer 3/Layer 4 backlog rather than blocking deterministic fields.
4. Complete only the minimum dispatcher/recovery controls necessary to avoid duplicate or unsafe execution.
5. Hand accepted consumer-ready data to M2.4.8/API consumers continuously; do not wait for every enrichment domain to reach 100% coverage.

## Current runtime evidence

On 15 September 2026 the accepted CF-245 official-URL admission path checked 272 latest qualified candidates, admitted 269 and produced 122 canonical changes. Search projection applied those 122 changes and raised `official_course_url` coverage to **527** of 33,105 Search courses.

The current website v3.1 search contract returns the admitted URLs together with regulatory tuition, intake summaries and English summaries. Example runtime query with `has_link=true` returned total **527**.

The accepted observed-artifact replay path currently reports 0 additional deterministic intake courses and 0 additional deterministic English courses, so that path is exhausted for present Evidence. The remaining **457** provider-current-tuition candidates are explicitly classified for Layer 3 validation and do not block website handover of already-admitted fields.

## Boundary

Do not bypass source qualification, Evidence, exact identity, Layer 4 blocks or Search admission gates to increase counts. Provider-current tuition may progress independently through the existing Layer 3 validation path; it is not a prerequisite for handing the current website dataset to the consumer team.
