#!/usr/bin/env python3
"""check-provider-queue.py [--base <git ref>]

CI check for docs/monitoring/PROVIDER-ENRICHMENT-QUEUE.csv (design docs/platform/2026-11-23-file-driven-continuous-delivery-design.md,
sections 3, 5, 6 and 8; Platform Admin 23 Nov 2026 20:38 AEDT). It fails when:
  - the header is not the 20 columns in order, a provider_id is repeated, or a row has the wrong number of cells;
  - a status is not PENDING, DONE, PARKED, CLAIMED:<lane>, PR_OPEN:#<n> or HELD:<code> with a code from design section 6;
  - a CLAIMED cell names a lane that does not own that column (single writer per column; the S2 names are accepted as aliases of their
    S1 owners while the consolidation of 23 Nov 2026 settles);
  - active_claim_lane or active_spec_id disagrees with the row's claims;
  - with --base: one pull request changes status columns of more than one owner lane. Releasing a stale claim (CLAIMED:<lane> back to
    PENDING, the 08:00 AEDT digest) and renaming a claim to its S1 lane name are allowed for any column.
"""
import argparse, csv, io, re, subprocess, sys

PATH = 'docs/monitoring/PROVIDER-ENRICHMENT-QUEUE.csv'
HEADER = ['queue_rank', 'tier', 'provider_id', 'provider_name', 'country_code', 'provider_type', 'active_courses', 'source_type',
          'aer_source_url', 'storage_artifact_path', 'url_desc_status', 'aer_status', 'elr_status', 'intake_status', 'scholarship_status',
          'geo_status', 'active_claim_lane', 'active_spec_id', 'last_updated_aedt', 'notes']
OWNER = {  # single writer per status column (design section 11, S1 consolidation)
    'url_desc_status': 'S1-Build', 'aer_status': 'S1-RM-Design', 'elr_status': 'S1-ELR', 'intake_status': 'S1-RM-Design',
    'scholarship_status': 'S1-Build', 'geo_status': 'S1-Build'}
ALIAS = {'S2-CF': 'S1-Build', 'S2-Build': 'S1-Build', 'S2-GEO': 'S1-Build', 'S2-RM-Design': 'S1-RM-Design', 'S2-INT': 'S1-RM-Design',
         'S2-ELR': 'S1-ELR'}
HELD = {'NO_SOURCE', 'SITE_BLOCKED', 'BUDGET_GATE', 'G3_FREEZE', 'IDENTITY_UNRESOLVED', 'NON_ACADEMIC_ONLY', 'PARSER_EDGE_CASE',
        'WAF_OR_JS_BLOCK'}
STATUS = re.compile(r'^(PENDING|DONE|PARKED|CLAIMED:[A-Za-z0-9-]+|PR_OPEN:#\d+|HELD:[A-Z0-9_]+)$')


def lane(name):
    return ALIAS.get(name, name)


def owner_for(row, column):
    """Platform Admin 24 Nov 2026: S3 owns NZ/CA AER; S1 owns AU AER."""
    if column == 'aer_status' and row.get('country_code') in ('NZ', 'CA'):
        return 'S3-AER-ChatGPT'
    return OWNER[column]


def load(text):
    rows = list(csv.reader(io.StringIO(text)))
    return rows[0], [dict(zip(rows[0], r)) for r in rows[1:]], rows[1:]


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--base'); a = ap.parse_args()
    errs = []
    head, rows, raw = load(open(PATH, encoding='utf-8').read())
    if head != HEADER:
        errs.append(f'header is not the 20 queue columns in order: {head}')
    for i, r in enumerate(raw, 2):
        if len(r) != len(HEADER):
            errs.append(f'line {i}: {len(r)} cells, expected {len(HEADER)}')
    seen = set()
    for r in rows:
        pid = r.get('provider_id', '')
        if pid in seen:
            errs.append(f'provider_id {pid} appears twice')
        seen.add(pid)
        claims = set()
        for c, own in OWNER.items():
            v = r.get(c, '')
            if not STATUS.match(v):
                errs.append(f"{r.get('provider_name')}: {c} = '{v}' is not an allowed status")
                continue
            if v.startswith('HELD:') and v[5:] not in HELD:
                errs.append(f"{r.get('provider_name')}: {c} = {v} is not a HELD code from design section 6")
            if v.startswith('CLAIMED:'):
                expected = owner_for(r, c)
                # Old S1 NZ/CA claims are historical and stay valid until their current owner closes them.
                legacy = c == 'aer_status' and expected == 'S3-AER-ChatGPT' and lane(v[8:]) == 'S1-RM-Design'
                if lane(v[8:]) != expected and not legacy:
                    errs.append(f"{r.get('provider_name')}: {c} is owned by {expected}, but {v} names another lane")
                claims.add(lane(v[8:]))
        acl = r.get('active_claim_lane', '')
        if claims and lane(acl) not in claims:
            errs.append(f"{r.get('provider_name')}: active_claim_lane '{acl}' does not match its claims {sorted(claims)}")
        if not claims and acl:
            errs.append(f"{r.get('provider_name')}: active_claim_lane '{acl}' is set but no column is CLAIMED")
        if claims and not r.get('active_spec_id', '').strip():
            errs.append(f"{r.get('provider_name')}: a CLAIMED row needs active_spec_id")
    if a.base:
        try:
            old = subprocess.run(['git', 'show', f'{a.base}:{PATH}'], capture_output=True, text=True, check=True).stdout
        except subprocess.CalledProcessError:
            old = ''
        if old:
            _, orows, _ = load(old)
            before = {r['provider_id']: r for r in orows}
            touched = {}
            for r in rows:
                o = before.get(r['provider_id'])
                if not o:
                    continue
                for c, own in OWNER.items():
                    same_claim = o[c].startswith('CLAIMED:') and r[c].startswith('CLAIMED:') and lane(o[c][8:]) == lane(r[c][8:])
                    if r[c] != o[c] and not same_claim and not (o[c].startswith('CLAIMED:') and r[c] == 'PENDING'):
                        touched.setdefault(owner_for(r, c), set()).add(c)
            if len(touched) > 1:
                errs.append('one pull request changes status columns of more than one owner lane (single writer per column): '
                            + '; '.join(f'{k}: {", ".join(sorted(v))}' for k, v in sorted(touched.items())))
    if errs:
        print(f'{PATH}: {len(errs)} problem(s)')
        for e in errs[:60]:
            print(' -', e)
        sys.exit(1)
    print(f'{PATH}: ok ({len(rows)} rows)')


if __name__ == '__main__':
    main()
