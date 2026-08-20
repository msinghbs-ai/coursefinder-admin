# CourseFinder Running Build v2.41

**Status:** CURRENT RUNNING BUILD  
**Date:** 20 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.40.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.37.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.37.md`  
**Layer 2 UAT:** `Coursefinder-Pilot/docs/m1-l2-au-course-facts-uq-uat-2026-08-20.md`

## Build delta

`M1-L2-AU-COURSE-FACTS` remains **IN PROGRESS**, with a second Provider-owned source class now independently accepted.

Qualified AU Course Facts sources:

1. RMIT University official Course pages
2. The University of Queensland official program pages

The UQ gate proves the current relational/evidence contract across a second Provider website rather than relying on RMIT-specific behaviour.

## Preserved Layer 1 baseline

- AU Providers: 1,546
- active CRICOS Courses: 26,648
- missing Study Level: 0
- 34 Campus gaps: authoritative source absence
- unexplained Layer 1 mapping defects: 0
- production adapter: `layer1-au-depth-v1.6.0`

## Qualified Layer 2 sources

### RMIT

- source: `au_rmit_official_course_pages`
- Provider CRICOS: `00122A`
- worker: `coursefacts-au-rmit-v0.2.0`
- status: qualified

### UQ

- source: `au_uq_official_program_pages`
- Provider CRICOS: `00025B`
- worker: `coursefacts-au-uq-v0.1.0`
- status: qualified

Bounded UQ Courses:

- `102784C` — Bachelor of Computer Science (Honours)
- `082960F` — Bachelor of Nursing (Honours)

## Aggregate accepted Course Facts state

Across RMIT and UQ:

- qualified source classes: 2
- bounded exact CRICOS Courses: 4
- official Course links: 4
- provider-current international fees: 4
- intakes: 6
- governed English requirements: 14

No canonical Provider/Course identity changed.

## UQ fee/intake/English result

`102784C`:

- 2027 international indicative annual fee: AUD 60,952
- starts: 22 February 2027 and 26 July 2027
- international closing dates retained for both starts
- IELTS / TOEFL iBT / PTE thresholds retained

`082960F`:

- 2027 international indicative annual fee: AUD 48,080
- international start: 22 February 2027
- international closing date retained
- higher Nursing IELTS / TOEFL iBT / PTE thresholds retained

Unsupported UQ BE/CES alternatives were not coerced into existing English-test identities.

## UAT

UQ fresh-source dry-run: PASS.  
UQ APPLY: PASS.  
UQ replay: PASS.  
UQ ambiguity rejection: PASS.  
Canonical Course URL mutation: 0.  
CRICOS registered-fee collision: 0.

Replay reused the same UQ source-record IDs for unchanged page hashes and preserved exact canonical counts: 2 links / 2 fees / 3 intakes / 6 English rows.

## Security

`coursefacts-au-uq` uses the existing one-time Pilot nonce model.

Verified submit-service execution rights:

- anon: false
- authenticated: false
- service_role: true

## Search isolation

Search remains unchanged:

- Course Documents: 33,105
- `has_fee=true`: 0
- `has_intake=true`: 0
- `has_english=true`: 0

No Search enrichment admission occurred.

## Production migration delta

Applied and repository-synchronised:

- `20260820003557_m1_l2_au_coursefacts_uq_source_v1`
- `20260820003830_m1_l2_au_coursefacts_uq_acceptance_v1`

## Current serial position

1. `M1-L1-AU-CRICOS-COMPLETENESS` — PASS / COMPLETE
2. `M1-L2-AU-COURSE-FACTS` — IN PROGRESS / TWO SOURCE CLASSES QUALIFIED
3. controlled Course/provider source expansion — ACTIVE NEXT
4. Search enrichment readiness — BLOCKED / SEPARATE GATE

The accepted Layer 1 identity substrate, PIM hardening decision and vector-search rejection remain unchanged.
