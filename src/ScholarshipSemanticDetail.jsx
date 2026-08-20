import React from 'react'

export default function ScholarshipSemanticDetail({data}){
  const semantic=data?.semantic_summary??{}
  const cycles=semantic.cycles??[]
  const unscoped=semantic.unscoped??{}
  const hasUnscoped=Object.values(unscoped).some(v=>Array.isArray(v)&&v.length)
  return <div className="detail-stack">
    <div className="detail-grid">
      <KV label="Stable key" value={data?.stable_key}/>
      <KV label="Provider" value={data?.provider_name??'Not provider-owned / not resolved to one Provider'}/>
      <KV label="Type" value={humanise(data?.type??data?.scholarship_type)}/>
      <KV label="Audience" value={humanise(data?.audience)}/>
      <KV label="Lifecycle" value={humanise(data?.lifecycle_status)}/>
      <KV label="Publication" value={humanise(data?.publication_status)}/>
      <KV label="Application required" value={data?.application_required===true?'Yes':data?.application_required===false?'No':'Not supplied'}/>
      <KV label="Award summary" value={data?.award_value_text}/>
    </div>

    <section className="subpanel">
      <h3>Scholarship provenance</h3>
      <p className="semantic-note">Record source/evidence establishes provenance. It does not replace the cycle-specific source/evidence attached to windows, eligibility, scopes, tiers or coverage.</p>
      <div className="fee-meta-grid">
        <KV label="Source" value={sourceLabel(semantic.record_provenance?.source)??data?.source_url}/>
        <MetaLink label="Source URL" value={sourceUrl(semantic.record_provenance?.source)??data?.source_url}/>
        <KV label="Evidence ID" value={semantic.record_provenance?.evidence?.id??data?.evidence_id}/>
        <MetaLink label="Evidence source" value={semantic.record_provenance?.evidence?.source_url}/>
        <KV label="Evidence captured" value={fmtDate(semantic.record_provenance?.evidence?.captured_at)}/>
        <KV label="Confidence" value={confidenceLabel(data?.confidence)}/>
      </div>
    </section>

    <section className="subpanel">
      <h3>Offering cycles</h3>
      <p className="semantic-note">Cycles are time-scoped scholarship offerings. Windows, scopes, eligibility, tiers and coverage stay attached to the cycle that published them.</p>
      {cycles.length?cycles.map(c=><Cycle key={c.id??c.cycle_code} cycle={c}/>):<div className="empty-note">No structured Offering Cycle loaded. Do not infer a current year from the Scholarship record alone.</div>}
    </section>

    {hasUnscoped&&<section className="fee-card fee-review">
      <small>NEEDS ATTENTION</small>
      <h3>Scholarship-level / unscoped observations</h3>
      <p>These observations have no Offering Cycle relationship. They remain visible for review and are not silently attached to a cycle.</p>
      <Unscoped value={unscoped}/>
    </section>}

    <GenericSection title="Identifiers" rows={data?.identifiers}/>
    <GenericSection title="Evidence history" rows={data?.evidence}/>
    <GenericSection title="Scholarship record" rows={[strip(data,['semantic_summary','identifiers','cycles','windows','scopes','criterion_groups','criteria','award_tiers','coverage','evidence'])]}/>
  </div>
}

function Cycle({cycle}){
  const groups=cycle.eligibility_groups??[]
  const roots=groups.filter(g=>!g.parent_group_id)
  return <section className="fee-card">
    <div className="fee-row-main"><b>{cycleLabel(cycle)}</b><span>{humanise(cycle.status??'status not supplied')}</span></div>
    <small>{[cycle.intake_label,validityLabel(cycle)].filter(Boolean).join(' · ')}</small>
    <details className="fee-meta"><summary>Cycle source & evidence</summary><div className="fee-meta-grid">
      <KV label="Cycle code" value={cycle.cycle_code}/><KV label="Academic year" value={cycle.academic_year}/>
      <KV label="Source" value={sourceLabel(cycle.source)}/><MetaLink label="Source URL" value={sourceUrl(cycle.source)}/>
      <KV label="Evidence ID" value={cycle.evidence?.id}/><MetaLink label="Evidence source" value={cycle.evidence?.source_url}/>
      <KV label="Evidence captured" value={fmtDate(cycle.evidence?.captured_at)}/>
    </div></details>

    <h4>Application windows</h4>
    <WindowRows rows={cycle.application_windows??[]}/>

    <h4>Applicability scopes</h4>
    <ScopeRows rows={cycle.scopes??[]}/>

    <h4>Eligibility logic</h4>
    {roots.length?<div className="mini-list">{roots.map(g=><EligibilityGroup key={g.id} group={g} allGroups={groups} depth={0}/>)}</div>:<div className="empty-note">No structured eligibility groups loaded for this cycle. Do not infer that every applicant is eligible.</div>}

    <h4>Award tiers</h4>
    <AwardRows rows={cycle.award_tiers??[]}/>

    <h4>Coverage / benefits</h4>
    <CoverageRows rows={cycle.coverage??[]}/>
  </section>
}

function WindowRows({rows}){
  if(!rows.length)return <div className="empty-note">No structured Application Window loaded.</div>
  return <div className="mini-list">{rows.map((w,i)=><div className="fee-row" key={w.id??i}>
    <div className="fee-row-main"><b>{w.label??w.round_code??'Application window'}</b><span>{humanise(w.status??'status not supplied')}</span></div>
    <small>{windowTiming(w)}</small>
    {w.metadata?.source_closing_text&&<p className="semantic-note">Source closing text: {w.metadata.source_closing_text}</p>}
    <details className="fee-meta"><summary>Window source & evidence</summary><div className="fee-meta-grid">
      <KV label="Round code" value={w.round_code}/><KV label="Application method" value={humanise(w.application_method)}/>
      <MetaLink label="Application URL" value={w.application_url}/><KV label="Source" value={sourceLabel(w.source)}/>
      <MetaLink label="Source URL" value={sourceUrl(w.source)}/><KV label="Evidence ID" value={w.evidence?.id}/>
      <MetaLink label="Evidence source" value={w.evidence?.source_url}/>
    </div></details>
  </div>)}</div>
}

function ScopeRows({rows}){
  if(!rows.length)return <div className="empty-note">No structured scope rows loaded for this cycle. This does not mean universal Provider/Course applicability; eligibility rules may define the audience separately.</div>
  return <div className="mini-list">{rows.map((s,i)=><div className="fee-row" key={s.id??i}>
    <div className="fee-row-main"><b>{`${humanise(s.include_exclude??'include')} ${humanise(s.scope_type??'scope')}`}</b><span>{scopeTarget(s.target)}</span></div>
    <details className="fee-meta"><summary>Scope source & evidence</summary><div className="fee-meta-grid">
      <KV label="Source" value={sourceLabel(s.source)}/><MetaLink label="Source URL" value={sourceUrl(s.source)}/>
      <KV label="Evidence ID" value={s.evidence?.id}/><MetaLink label="Evidence source" value={s.evidence?.source_url}/>
    </div></details>
  </div>)}</div>
}

function EligibilityGroup({group,allGroups,depth}){
  const children=allGroups.filter(g=>g.parent_group_id===group.id)
  return <div className="fee-row" style={{marginLeft:Math.min(depth,3)*16}}>
    <div className="fee-row-main"><b>{group.label??group.group_code??'Eligibility group'}</b><span>{conjunctionLabel(group.conjunction)}</span></div>
    <small>{group.is_mandatory===false?'Optional group':'Mandatory group'}</small>
    {(group.criteria??[]).length?<div className="mini-list">{group.criteria.map((c,i)=><Criterion key={c.id??i} criterion={c}/>)}</div>:<div className="empty-note">No direct criteria in this group.</div>}
    {children.map(child=><EligibilityGroup key={child.id} group={child} allGroups={allGroups} depth={depth+1}/>)}
    <details className="fee-meta"><summary>Group source & evidence</summary><div className="fee-meta-grid">
      <KV label="Group code" value={group.group_code}/><KV label="Parent group" value={group.parent_group_id??'Top-level'}/>
      <KV label="Source" value={sourceLabel(group.source)}/><MetaLink label="Source URL" value={sourceUrl(group.source)}/>
      <KV label="Evidence ID" value={group.evidence?.id}/><MetaLink label="Evidence source" value={group.evidence?.source_url}/>
    </div></details>
  </div>
}

function Criterion({criterion}){
  return <div className="fee-row">
    <div className="fee-row-main"><b>{humanise(criterion.criterion_type??'criterion')}</b><span>{criterion.operator??'—'}</span></div>
    <p>{criterion.human_text??criterion.value_text??criterionValue(criterion)}</p>
    <small>{[criterion.is_mandatory===false?'Optional':'Mandatory',criterion.machine_evaluable?'Machine-evaluable':'Human/source review',`Confidence: ${confidenceLabel(criterion.confidence)}`].join(' · ')}</small>
    <details className="fee-meta"><summary>Criterion source & evidence</summary><div className="fee-meta-grid">
      <KV label="Source" value={sourceLabel(criterion.source)}/><MetaLink label="Source URL" value={sourceUrl(criterion.source)}/>
      <KV label="Evidence ID" value={criterion.evidence?.id}/><MetaLink label="Evidence source" value={criterion.evidence?.source_url}/>
    </div></details>
  </div>
}

function AwardRows({rows}){
  if(!rows.length)return <div className="empty-note">No structured Award Tier loaded for this cycle.</div>
  return <div className="mini-list">{rows.map((a,i)=><div className="fee-row" key={a.id??i}>
    <div className="fee-row-main"><b>{a.label??a.tier_code??'Award tier'}</b><span>{awardValue(a)}</span></div>
    <small>{[humanise(a.basis),a.maximum_amount?`Maximum ${money(a.maximum_amount,a.currency_code)}`:null].filter(Boolean).join(' · ')}</small>
    {a.notes&&<p>{a.notes}</p>}
    <details className="fee-meta"><summary>Tier source & evidence</summary><div className="fee-meta-grid"><KV label="Source" value={sourceLabel(a.source)}/><MetaLink label="Source URL" value={sourceUrl(a.source)}/><KV label="Evidence ID" value={a.evidence?.id}/><MetaLink label="Evidence source" value={a.evidence?.source_url}/></div></details>
  </div>)}</div>
}

function CoverageRows({rows}){
  if(!rows.length)return <div className="empty-note">No structured Coverage rows loaded for this cycle.</div>
  return <div className="mini-list">{rows.map((c,i)=><div className="fee-row" key={c.id??i}>
    <div className="fee-row-main"><b>{humanise(c.coverage_type??'coverage')}</b><span>{coverageValue(c)}</span></div>
    {c.notes&&<p>{c.notes}</p>}
    <details className="fee-meta"><summary>Coverage source & evidence</summary><div className="fee-meta-grid"><KV label="Source" value={sourceLabel(c.source)}/><MetaLink label="Source URL" value={sourceUrl(c.source)}/><KV label="Evidence ID" value={c.evidence?.id}/><MetaLink label="Evidence source" value={c.evidence?.source_url}/></div></details>
  </div>)}</div>
}

function Unscoped({value}){return <div className="detail-grid">{Object.entries(value??{}).map(([k,v])=><KV key={k} label={humanise(k)} value={Array.isArray(v)?`${v.length} observation(s)`:String(v??'—')}/>)}</div>}
function GenericSection({title,rows}){if(rows===undefined||rows===null)return null;const list=Array.isArray(rows)?rows:[rows];if(!list.length)return null;const keys=[...new Set(list.flatMap(r=>Object.keys(r??{})))].slice(0,10);return <section className="subpanel"><h3>{title}</h3><div className="table-wrap"><table><thead><tr>{keys.map(k=><th key={k}>{humanise(k)}</th>)}</tr></thead><tbody>{list.map((r,i)=><tr key={r?.id??i}>{keys.map(k=><td key={k} className="truncate">{fmt(r?.[k])}</td>)}</tr>)}</tbody></table></div></section>}
function KV({label,value}){return <div className="kv"><small>{label}</small><strong>{value===null||value===undefined||value===''?'—':String(value)}</strong></div>}
function MetaLink({label,value}){return <div className="kv"><small>{label}</small>{value?<a href={value} target="_blank" rel="noreferrer">{value}</a>:<strong>—</strong>}</div>}
function sourceLabel(v){return v?.label??v?.source_label??null}
function sourceUrl(v){return v?.url??v?.source_url??null}
function cycleLabel(c){return c.academic_year?`${c.academic_year} — ${c.intake_label??c.cycle_code??'Offering cycle'}`:c.intake_label??c.cycle_code??'Offering cycle'}
function validityLabel(v){if(!v?.valid_from&&!v?.valid_to)return 'No explicit validity window supplied';return `${v.valid_from?fmtDateOnly(v.valid_from):'Open start'} → ${v.valid_to?fmtDateOnly(v.valid_to):'Open end'}`}
function windowTiming(w){const parts=[];if(w.opens_at)parts.push(`Opens ${fmtDate(w.opens_at)}`);if(w.closes_at)parts.push(`Closes ${fmtDate(w.closes_at)}`);return parts.join(' · ')||'Exact open/close timestamp not supplied; source text retained where available'}
function conjunctionLabel(v){if(v==='all')return 'ALL of the following';if(v==='any')return 'ANY of the following';return humanise(v??'conjunction not supplied')}
function scopeTarget(target){if(!target||!Object.keys(target).length)return 'Target not resolved';for(const k of ['provider','course','course_collection','study_level','field','country','campus']){const v=target[k];if(v)return `${humanise(k)}: ${v.name??v.code??v.stable_key??v.id}`}return 'Target not resolved'}
function criterionValue(c){if(c.value_number!==null&&c.value_number!==undefined)return String(c.value_number);if(c.value_codes?.length)return c.value_codes.join(', ');if(c.value_json)return JSON.stringify(c.value_json);return 'Source rule retained'}
function awardValue(a){if(a.amount!==null&&a.amount!==undefined)return money(a.amount,a.currency_code);if(a.percentage!==null&&a.percentage!==undefined)return `${Number(a.percentage).toLocaleString()}%`;return 'Value described in notes/source'}
function coverageValue(c){const parts=[];if(c.percentage!==null&&c.percentage!==undefined)parts.push(`${Number(c.percentage).toLocaleString()}%`);if(c.amount!==null&&c.amount!==undefined)parts.push(money(c.amount,c.currency_code));if(c.duration_value!==null&&c.duration_value!==undefined)parts.push(`${c.duration_value} ${c.duration_unit??''}`.trim());return parts.join(' · ')||'Benefit applies as described'}
function money(v,currency){return `${currency??''} ${Number(v).toLocaleString()}`.trim()}
function confidenceLabel(v){return v===null||v===undefined?'Not supplied':`${Math.round(Number(v)*100)}%`}
function humanise(v){return v===null||v===undefined||v===''?'—':String(v).replaceAll('_',' ').replace(/\b\w/g,c=>c.toUpperCase())}
function fmtDate(v){return v?new Date(v).toLocaleString():'—'}
function fmtDateOnly(v){if(!v)return '—';const d=new Date(`${String(v).slice(0,10)}T00:00:00`);return Number.isNaN(d.valueOf())?String(v):d.toLocaleDateString()}
function fmt(v){if(v===null||v===undefined||v==='')return '—';if(typeof v==='object')return JSON.stringify(v);return String(v)}
function strip(obj,keys){return Object.fromEntries(Object.entries(obj??{}).filter(([k])=>!keys.includes(k)))}
