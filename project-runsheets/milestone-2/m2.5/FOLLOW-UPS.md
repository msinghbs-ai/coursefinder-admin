# M2.5 FOLLOW-UPS

| ID | Item | Impact | Next action | Status |
|---|---|---|---|---|
| M25-FU-001 | Production Supabase project does not exist | M2.5 deployment cannot begin | Confirm organisation, region and supplier cost; create separate Production project | BLOCKED / USER CONFIRMATION |
| M25-FU-002 | Production leaked-password protection not yet provable | Mandatory Production security gate | After project creation enable and UAT under CF-CHG-20260823-022 | OPEN |
| M25-FU-003 | Production GitHub protected environment not yet reconciled | Deployment trust boundary unproven | Inspect/create protected Production environment and SHA-bound workflow after project identity exists | OPEN |
| M25-FU-004 | Production Cloudflare origin/WAF not yet reconciled | Public runtime boundary unproven | Establish Production origin/environment/WAF only after Production app/API identity exists | OPEN |
| M25-FU-005 | Backup/restore/DR not yet proven | Production recovery gate open | Perform controlled backup + restore rehearsal before final acceptance | OPEN |
| M25-FU-006 | Historical 42-Course scheduled remainder | Closure-time snapshot has progressed | Live request is terminal: 42 completed / 219 failed. Review failures separately without reopening M2.4 | RECONCILED / PILOT OPS |
| M25-FU-007 | Zoho Pilot CF-CHG-045 remains ACTIVE/PARTIAL | Parallel integration must not be mistaken for Production cutover | Keep M3 Zoho Pilot separate; no Production Zoho secrets/cutover in M2.5 | OPEN / PARALLEL |
| M25-FU-008 | Platform maturity implementation | Pilot foundation implemented under CF-CHG-20260901-051 | Continue only authorised owning-gate work; do not reopen M2.4 | ACTIVE |
| M25-FU-009 | Evidence Storage lineage mismatch | 205 unmatched objects and 18 regulatory artifact rows lack current path matches | Classify lineage before any cleanup | OPEN / HIGH |
| M25-FU-010 | Capacity notification target unset | Thresholds and observations exist without external escalation | Select notification channel and severity routing | OPEN |
| M25-FU-011 | Platform maturity Admin UI not yet implemented | New gates/capacity/UAT/blocking controls are not yet consolidated in canonical Administration | Add through a separately tested canonical Administration change | OPEN |
| M25-FU-012 | Block enforcement not wired to all owners | Ledger state alone is not universal enforcement | Add enforcement and UAT per operation/publication/Search/data-quality path | OPEN |
| M25-FU-013 | M2.5 targeted CI final status | Source-contract suite wired; terminal status not yet recorded | Record exact final run/build IDs when terminal; correct only demonstrated defects | ACTIVE |
