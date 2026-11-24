#!/usr/bin/env python3
"""Build docs/monitoring/Scholarship_University_Reader_Status.csv (S1-Build, daily 08:00 AEDT with the AER register).

Inputs (all read-only):
  --aer   the AER_University_Reader_Status.csv built in the same run: the provider set, country, rank, code and name
          (the same 1,886-style set: AU, NZ and CA providers with an active course, ranked by active courses).
  --work  the refresh work folder holding S.out (one line per scholarship slice) and D.out (the next-action dictionary),
          both from rolled-back live reads of pipeline.scholarship_provider_coverage, scholarship.scholarships,
          scholarship.scopes, scholarship.criteria and pipeline.scholarship_listing_pages (sliceS.sql.tmpl, sliceD.sql.tmpl).
Column rules are in docs/monitoring/aer-reader-status-refresh/README.md (Scholarship register).
"""
import argparse, csv, sys

COLS = ['country_code', 'rank', 'provider_code', 'provider_name', 'has_registered_source', 'source_count', 'scholarship_hub_url',
        'reader_status', 'parser_mode', 'active_courses', 'scholarship_linked_courses', 'scholarship_coverage_pct', 'published_awards',
        'gpa_scale_status', 'firecrawl_credits_used', 'l4_blocker_reason', 'next_action']
FIELDS = ['provider_id', 'active', 'linked', 'sch_active', 'sch_published', 'candidates', 'listing_pages', 'layer4_open', 'fc30',
          'cov_published', 'top_reject', 'disposition', 'next_action_ix', 'gpa_scaled', 'gpa_unscaled', 'hub_url', 'admitted']
FULL = 80.0  # percent of active courses linked to a published award for "Fully Working" (same bar as the AER register)


def num(v):
    try:
        return int(float(v))
    except (TypeError, ValueError):
        return 0


def read_slices(path, prefix):
    rows = {}
    for line in open(path, encoding='utf-8'):
        line = line.rstrip('\n')
        if not line.startswith(prefix):
            continue
        for part in line.split('~')[1:]:
            if not part:
                continue
            f = part.split('|')
            if len(f) != len(FIELDS):
                sys.exit(f'slice row has {len(f)} fields, expected {len(FIELDS)}: {part[:120]}')
            rows[f[0]] = dict(zip(FIELDS, f))
    return rows


def status(r):
    published, l4, linked, active = num(r['cov_published'] or r['sch_published']), num(r['layer4_open']), num(r['linked']), num(r['active'])
    pct = 100.0 * linked / active if active else 0.0
    if l4 > 0 or (num(r['sch_active']) > 0 and published == 0):
        return 'Stuck in L4'
    if published > 0:
        return 'Fully Working' if pct >= FULL else 'Partial - Low Confidence'
    return 'No Reader Yet'


def gpa_status(r):
    s, u = num(r['gpa_scaled']), num(r['gpa_unscaled'])
    if not s and not u:
        return 'No GPA thresholds'
    parts = ([f'Scale stated ({s})'] if s else []) + ([f'No scale stated ({u})'] if u else [])
    return '; '.join(parts)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--aer', required=True)
    ap.add_argument('--work', required=True)
    ap.add_argument('--out', required=True)
    a = ap.parse_args()
    data = read_slices(f'{a.work}/S.out', 'S')
    dline = next((l.rstrip('\n') for l in open(f'{a.work}/D.out', encoding='utf-8') if l.startswith('D0~')), None)
    if not dline:
        sys.exit('the next-action dictionary (D0) is missing')
    dic = dline.split('~')[2:]
    aer = list(csv.DictReader(open(a.aer, encoding='utf-8')))
    missing = [r['provider_id'] for r in aer if r['provider_id'] not in data]
    if missing:
        sys.exit(f'{len(missing)} AER providers have no scholarship row (first {missing[0]}): raise the S slice count')
    out = []
    for ar in aer:
        r = data[ar['provider_id']]
        src = num(r['candidates']) + num(r['listing_pages'])
        active, linked = num(r['active']), num(r['linked'])
        l4 = num(r['layer4_open'])
        ix = r['next_action_ix']
        if r['disposition'] == '':
            nxt = 'No scholarship coverage row yet'
        else:
            nxt = dic[int(ix)] if ix.isdigit() and int(ix) < len(dic) else ''
        out.append({
            'country_code': ar['country_code'], 'rank': ar['rank'], 'provider_code': ar['national_code'], 'provider_name': ar['provider_name'],
            'has_registered_source': 'Yes' if src else 'No', 'source_count': src, 'scholarship_hub_url': r['hub_url'],
            'reader_status': status(r),
            'parser_mode': 'Listing reader (direct-first, s992) + page reads' if num(r['listing_pages']) else ('Candidate page reads (direct-first)' if num(r['candidates']) else 'None'),
            'active_courses': active, 'scholarship_linked_courses': linked,
            'scholarship_coverage_pct': f'{(100.0 * linked / active if active else 0.0):.1f}%',
            'published_awards': num(r['cov_published'] or r['sch_published']), 'gpa_scale_status': gpa_status(r),
            'firecrawl_credits_used': num(r['fc30']),
            'l4_blocker_reason': f'LAYER4_OPEN ({l4})' if l4 else ((r['top_reject'] or 'none').upper()),
            'next_action': nxt})
    with open(a.out, 'w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fieldnames=COLS, lineterminator='\n')
        w.writeheader()
        w.writerows(out)
    from collections import Counter
    print(len(out), 'providers;', dict(Counter(r['reader_status'] for r in out)), file=sys.stderr)


if __name__ == '__main__':
    main()
