# M2.5 FOLLOW-UPS

| ID | Item | Impact | Next action | Status |
|---|---|---|---|---|
| M25-FU-001 | Production Supabase project does not exist | M2.5 deployment cannot begin | Confirm organisation, region and supplier cost; create separate Production project | BLOCKED / USER CONFIRMATION |
| M25-FU-002 | Production leaked-password protection not yet provable | Mandatory Production security gate | After project creation enable and UAT under CF-CHG-20260823-022 | OPEN |
| M25-FU-003 | Production GitHub protected environment not yet reconciled | Deployment trust boundary unproven | Inspect/create protected Production environment and SHA-bound workflow after project identity exists | OPEN |
| M25-FU-004 | Production Cloudflare origin/WAF not yet reconciled | Public runtime boundary unproven | Establish Production origin/environment/WAF only after Production app/API identity exists | OPEN |
| M25-FU-005 | Backup/restore/DR not yet proven | Production recovery gate open | Perform controlled backup + restore rehearsal before final acceptance | OPEN |
| M25-FU-006 | 42-Course Pilot Layer 2 scheduled remainder | Background Pilot work exists | Let governed Pilot scheduler continue independently; do not treat as Production seed truth or M2.5 blocker | OPEN / NON-BLOCKING |
| M25-FU-007 | Zoho Pilot CF-CHG-045 remains ACTIVE/PARTIAL | Parallel integration must not be mistaken for Production cutover | Keep M3 Zoho Pilot separate; no Production Zoho secrets/cutover in M2.5 | OPEN / PARALLEL |
