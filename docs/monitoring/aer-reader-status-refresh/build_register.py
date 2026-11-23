import csv, sys, re, collections, os
import json, argparse
ap=argparse.ArgumentParser(); ap.add_argument('--work',required=True); ap.add_argument('--updated',required=True); ap.add_argument('--out',required=True)
ap.add_argument('--prev'); ap.add_argument('--sheet-json')
a=ap.parse_args(); D=a.work.rstrip('/')+'/'; updated=a.updated; out=a.out
prev={}
if a.prev and os.path.exists(a.prev):
    for r in csv.DictReader(open(a.prev,encoding='utf-8')): prev[r['provider_id']]=int(r['aer_admitted_courses'] or 0)
def slices(fn, tag, nf):
    if not os.path.exists(D+fn): return {},set(),0
    rows={}; seen=set(); bad=0
    for line in open(D+fn, encoding='utf-8'):
        line=line.rstrip('\n')
        parts=line.split('~'); head=parts[0]
        if not head.startswith(tag): continue
        seen.add(int(head[1:]))
        for r in parts[1:]:
            f=r.split('|')
            if len(f)!=nf: bad+=1; continue
            rows[f[0]]=f
    return rows, seen, bad
A,sa,ba=slices('A.out','A',20); B,sb,bb=slices('B.out','B',6)
print('A rows',len(A),'slices',len(sa),'bad',ba,'| B rows',len(B),'slices',len(sb),'bad',bb, file=sys.stderr)
STATUS=['Fully Working','Partial - Low Confidence','Stuck in Layer 4','Site Blocked','No Reader Yet']
recs=[]
for pid,f in A.items():
    (_,cc,ptype,code,name,active,adm,off,shared,nourl,held,pend,reason,fb,lastrun,pread,pblk,nread,nother,nblk)=f
    active,adm,off,shared,nourl,held,pend,fb,pread,pblk,nread,nother,nblk=map(int,(active,adm,off,shared,nourl,held,pend,fb,pread,pblk,nread,nother,nblk))
    b=B.get(pid,[pid,'','','','0','0'])
    url,shape,path,msrc,mall=b[1],b[2],b[3],int(b[4]),int(b[5])
    has='Yes' if nread>0 else ('Draft' if (nother>0 or nblk>0) else 'No')
    srccount=nread+nother
    pct=round(100.0*adm/active,1) if active else 0.0
    # source type (deterministic)
    if url and re.search(r'\.pdf(\?|$)',url,re.I): st='PDF_TABLE'
    elif shape.startswith('html_table'): st='HTML_TABLE'
    elif shape.startswith('selector') or shape.startswith('accordion'): st='HTML_ACCORDION'
    elif url and msrc>0: st='HTML_TABLE'
    elif not url and path and active and shared*2>=active: st='SHARED_HUB_s670'
    elif not url and path: st='HTML_COURSE_PAGE'
    else: st='Unknown'
    blocked=(has!='Yes' and nblk>0) or (pread>=5 and pblk*2>=pread)
    stuck_reason=reason in ('all_rows_held','gate_incomplete','identity_not_admitted','no_bound_page')
    if blocked and adm==0: rs='Site Blocked'
    elif has=='No' and adm==0: rs='No Reader Yet'
    elif has=='Yes' and pct>=80 and held+pend==0: rs='Fully Working'
    elif has in ('Yes','Draft') and held+pend>0 and (pct<25 or stuck_reason): rs='Stuck in Layer 4'
    elif adm>0: rs='Partial - Low Confidence'
    elif blocked: rs='Site Blocked'
    else: rs='No Reader Yet'
    recs.append(dict(country_code=cc,provider_id=pid,provider_name=name.strip(),provider_type=ptype,national_code=code,has_registered_source=has,source_count=srccount,
        aer_source_url=url,source_type=st,storage_artifact_path=path,active_courses=active,aer_admitted_courses=adm,aer_admitted_pct=f'{pct:.1f}',
        courses_with_official_url=off,courses_on_shared_hub_s670=shared,courses_no_url=nourl,aer_held_l4_count=held,aer_pending_queue_count=pend,
        l4_blocker_reason=reason,fallback_to_course_row_count=fb,last_reader_run_utc=lastrun,daily_admitted_delta=(str(adm-prev[pid]) if pid in prev else ('new' if prev else 'n/a')),reader_status=rs,owner_lane='S2-RM-Design',updated_at_aedt=updated))
order={'AU':0,'NZ':1,'CA':2}
recs.sort(key=lambda r:(order[r['country_code']],-r['active_courses'],r['provider_name'].lower()))
rk=collections.Counter()
for r in recs: rk[r['country_code']]+=1; r['rank']=rk[r['country_code']]
cols=['country_code','rank','provider_id','provider_name','provider_type','national_code','has_registered_source','source_count','aer_source_url','source_type','storage_artifact_path','active_courses','aer_admitted_courses','aer_admitted_pct','courses_with_official_url','courses_on_shared_hub_s670','courses_no_url','aer_held_l4_count','aer_pending_queue_count','l4_blocker_reason','fallback_to_course_row_count','last_reader_run_utc','daily_admitted_delta','reader_status','owner_lane','updated_at_aedt']
with open(out,'w',newline='',encoding='utf-8') as fh:
    w=csv.DictWriter(fh,fieldnames=cols,lineterminator='\n'); w.writeheader(); [w.writerow(r) for r in recs]
tot=collections.Counter(); st=collections.Counter(); act=collections.Counter(); admc=collections.Counter()
for r in recs: tot[r['country_code']]+=1; st[(r['country_code'],r['reader_status'])]+=1; act[r['country_code']]+=r['active_courses']; admc[r['country_code']]+=r['aer_admitted_courses']
print('totals',dict(tot),'active',dict(act),'admitted',dict(admc))
for cc in ['AU','NZ','CA']: print(cc,{s:st[(cc,s)] for s in STATUS})
print('all',{s:sum(st[(c,s)] for c in 'AU NZ CA'.split()) for s in STATUS})
stuck=sorted([r for r in recs if r['reader_status']=='Stuck in Layer 4'],key=lambda r:-r['active_courses'])[:5]
for r in stuck: print('STUCK',r['country_code'],r['provider_name'],r['active_courses'],r['aer_admitted_pct'],r['aer_held_l4_count'],r['aer_pending_queue_count'],r['l4_blocker_reason'])
uni=[r for r in recs if r['provider_type'] in ('university','university_college','wananga')]
print('universities',collections.Counter(r['country_code'] for r in uni), collections.Counter(r['reader_status'] for r in uni))

if a.sheet_json:
    HE={'AU':('university','university_college','higher_education_institute'),'NZ':('university','wananga','tafe_polytechnic'),'CA':None}
    tabcols=['rank','provider_id','provider_name','national_code','has_registered_source','source_count','reader_status','aer_source_url','source_type','storage_artifact_path','active_courses','aer_admitted_courses','aer_admitted_pct','courses_with_official_url','courses_on_shared_hub_s670','courses_no_url','aer_held_l4_count','aer_pending_queue_count','l4_blocker_reason','fallback_to_course_row_count','last_reader_run_utc','daily_admitted_delta','owner_lane','updated_at_aedt','provider_type']
    tabs={}; summ=[]
    def agg(rs):
        c=collections.Counter(r['reader_status'] for r in rs); act=sum(r['active_courses'] for r in rs); ad=sum(r['aer_admitted_courses'] for r in rs)
        return [str(len(rs)),str(c['Fully Working']),str(c['Stuck in Layer 4']),str(c['Partial - Low Confidence']),str(c['No Reader Yet']),str(c['Site Blocked']),f"{act:,}",f"{ad:,}",(f"{100*ad/act:.1f}%" if act else '0.0%'),str(sum(r['aer_held_l4_count'] for r in rs)),str(sum(r['aer_pending_queue_count'] for r in rs))]
    names={'AU':'Australia (AU_Universities)','NZ':'New Zealand (NZ_Universities)','CA':'Canada (CA_Universities)'}
    allscope=[]
    for cc in ['AU','NZ','CA']:
        rs=[r for r in recs if r['country_code']==cc and (HE[cc] is None or r['provider_type'] in HE[cc])]
        for i,r in enumerate(rs,1): r=dict(r); r['rank']=i
        tabs[cc+'_Universities']=[tabcols]+[[ (i if c=='rank' else r[c]) for c in tabcols] for i,r in enumerate(rs,1)]
        summ.append(['',names[cc]]+agg(rs)); allscope+=rs
    summ.append(['','Total (university and higher-education tabs)']+agg(allscope))
    summ.append(['','Whole register (every provider with active courses; CSV in git)']+agg(recs))
    tot_ad=sum(r['aer_admitted_courses'] for r in recs); tot_act=sum(r['active_courses'] for r in recs)
    delta=(sum(r['aer_admitted_courses'] for r in recs)-sum(prev.values())) if prev else None
    json.dump({'tabs':tabs,'summary_rows':summ,'kpi':{'admitted':tot_ad,'active':tot_act,'delta':delta,
        'sources_yes':sum(1 for r in recs if r['has_registered_source']=='Yes'),'sources_any':sum(1 for r in recs if r['has_registered_source']!='No'),
        'held':sum(r['aer_held_l4_count'] for r in recs),'pending':sum(r['aer_pending_queue_count'] for r in recs),'fallback':sum(r['fallback_to_course_row_count'] for r in recs),
        'fw':sum(1 for r in recs if r['reader_status']=='Fully Working'),'stuck':sum(1 for r in recs if r['reader_status']=='Stuck in Layer 4'),'blocked':sum(1 for r in recs if r['reader_status']=='Site Blocked'),'providers':len(recs)}},open(a.sheet_json,'w'))
    print('sheet tabs', {k:len(v)-1 for k,v in tabs.items()})
