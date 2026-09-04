# CF-CHG-20260904-114 — Scholarship Provider Stats Evidence Progress

**Status:** IMPLEMENTED / TARGETED PASS
**Milestone:** M2.4.5
**Area:** Layer 2 / Scholarships / Admin PIM

## Change
`pipeline.scholarship_provider_stats` now also reports `evidence_acquired_total`, counting trace rows where both governed verification Evidence and a Scholarship source record are linked.

## Why
The provider summary must distinguish a URL that has merely been verified from a Scholarship detail that has actually entered the governed acquisition/evidence chain.

## Security
The view remains private: `anon` and `authenticated` have no direct access; `service_role` retains read access. Admin/PIM consumes the data through the guarded Scholarship operations RPC.
