import React from 'react'

const FEE_TYPE_LABELS={
  tuition:'Tuition Fee',
  non_tuition:'Non-Tuition Fee',
  estimated_total_course_cost:'Estimated Total Course Cost',
  provider_current_tuition:'Provider-Current Tuition Fee',
}
const FEE_BASIS_LABELS={
  registered_total_course:'Registered total course',
  indicative_annual:'Indicative annual',
  annual:'Annual',
  per_unit:'Per unit',
  per_credit:'Per credit',
  per_term:'Per term',
  per_semester:'Per semester',
}

export default function CourseSemanticDetail({data}){
  const fees=data?.fee_summary??{}
  const cricos=fees.cricos_registered??[]
  const provider=fees.provider_current??[]
  const other=fees.other??[]
  const campuses=data?.campuses??[]
  const entries=data?.entry_summary??{}
  const intakes=entries.intakes??[]
  const english=entries.english_requirements??[]
  const taxonomy=data?.taxonomy_summary??{}
  const levels=taxonomy.study_level_observations??[]
  const fields=taxonomy.field_observations??[]
  return <div className="detail-stack">
    <div className="detail-grid">
      <KV label="Stable key" value={data?.stable_key}/>
      <KV label="Provider" value={data?.provider_name}/>
      <KV label="CRICOS / course code" value={data?.course_code}/>
      <KV label="Lifecycle" value={humanise(data?.lifecycle_status)}/>
      <KV label="Publication" value={humanise(data?.publication_status)}/>
      <KV label="Last verified" value={fmtDate(data?.last_verified_at)}/>
    </div>

    <div className="fee-grid">
      <section className="fee-card">
        <small>REGULATORY</small>
        <h3>CRICOS registered fees</h3>
        <p>Registered total-course facts from CRICOS. They are not annualised and do not substitute for a Provider-current fee.</p>
        <FeeRows rows={cricos}/>
      </section>
      <section className="fee-card">
        <small>PROVIDER-CURRENT</small>
        <h3>Current Provider fee</h3>
        <p>Provider-published fee observations retain their year, basis, scope and evidence separately from CRICOS.</p>
        {provider.length?<FeeRows rows={provider}/>:<div className="empty-note">No current Provider fee evidence loaded. CRICOS values are deliberately not substituted.</div>}
      </section>
    </div>

    {other.length>0&&<section className="fee-card fee-review">
      <small>NEEDS ATTENTION</small>
      <h3>Needs semantic review</h3>
      <p>These active fee observations do not match a governed CRICOS registered or Provider-current fee class.</p>
      <FeeRows rows={other}/>
    </section>}

    <section className="subpanel">
      <h3>Course delivery campuses</h3>
      <p className="semantic-note">These are Course→Campus delivery relationships. Provider address/state is a separate Provider attribute and must not be substituted for Course delivery geography.</p>
      <CampusRows rows={campuses}/>
    </section>

    <div className="fee-grid">
      <section className="subpanel">
        <h3>Intakes</h3>
        <p className="semantic-note">Repeatable Provider-current Course observations. A missing Campus scope means no accepted Campus scope was supplied; it does not mean every Campus.</p>
        <IntakeRows rows={intakes}/>
      </section>
      <section className="subpanel">
        <h3>English entry requirements</h3>
        <p className="semantic-note">Each governed test remains a separate requirement. Overall and component thresholds are not flattened into one generic score.</p>
        <EnglishRows rows={english}/>
      </section>
    </div>

    <section className="subpanel">
      <h3>Taxonomy & source mapping</h3>
      <p className="semantic-note">Canonical taxonomy does not replace source vocabulary. This section shows the source value/code, mapping result and evidence used to reach the canonical Course taxonomy.</p>
      <TaxonomyRows levels={levels} fields={fields}/>
    </section>

    <GenericSection title="Regulatory facts" rows={data?.regulatory_facts}/>
    <GenericSection title="Evidence & history" rows={data?.evidence}/>
    <GenericSection title="Canonical detail" rows={[strip(data,['fee_summary','campuses','entry_summary','taxonomy_summary','regulatory_facts','evidence','intakes','english'])]}/>
  </div>
}

function FeeRows({rows}){
  if(!rows?.length)return <div className="empty-note">No fee observations.</div>
  return <div className="mini-list">{rows.map((r,i)=>{
    const missing=r.amount===null||r.amount===undefined||r.amount===''
    const currency=r.currency??r.currency_code??''
    return <div className="fee-row" key={r.id??i}>
      <div className="fee-row-main"><b>{feeTypeLabel(r.fee_type)}</b><span>{missing?'Amount not supplied':`${currency} ${Number(r.amount).toLocaleString()}`.trim()}</span></div>
      <small>{[feeBasisLabel(r.basis),feeYearLabel(r.fee_year),r.audience?humanise(r.audience):'Audience not supplied'].join(' · ')}</small>
      <details className="fee-meta"><summary>Source & evidence</summary><div className="fee-meta-grid">
        <KV label="Source" value={sourceLabel(r.source)??r.source_id}/>
        <MetaLink label="Source URL" value={sourceUrl(r.source)}/>
        <KV label="Evidence ID" value={r.evidence?.id??r.evidence_id}/>
        <MetaLink label="Evidence source" value={r.evidence?.source_url}/>
        <KV label="Source snapshot" value={fmtDate(r.source_snapshot_at)}/>
        <KV label="Last verified" value={fmtDate(r.last_verified_at)}/>
        <KV label="Validity" value={validityLabel(r)}/>
        <KV label="Campus scope" value={r.campus_id??'Not campus-scoped in this observation'}/>
      </div></details>
    </div>
  })}</div>
}

function CampusRows({rows}){
  if(!rows?.length)return <div className="empty-note">No accepted Course delivery Campus relationship.</div>
  return <div className="mini-list">{rows.map((r,i)=><div className="fee-row" key={r.id??i}>
    <div className="fee-row-main"><b>{r.name??'Unnamed Campus'}</b><span>{[r.subdivision_code,r.city,r.postcode].filter(Boolean).join(' · ')||'Location not supplied'}</span></div>
    <small>{[humanise(r.delivery_mode??'delivery mode not supplied'),r.is_primary?'Primary relationship':'Additional relationship',humanise(r.status??'status not supplied')].join(' · ')}</small>
    <details className="fee-meta"><summary>Campus & relationship evidence</summary><div className="fee-meta-grid">
      <KV label="Campus stable key" value={r.stable_key}/>
      <KV label="Campus code" value={r.campus_code}/>
      <KV label="Country" value={r.country_code}/>
      <KV label="Subdivision" value={r.subdivision_name??r.subdivision_code}/>
      <KV label="Address" value={[r.address_line1,r.address_line2,r.city,r.postcode].filter(Boolean).join(', ')||'Not supplied'}/>
      <KV label="Campus source" value={sourceLabel(r.campus_source)}/>
      <MetaLink label="Campus source URL" value={sourceUrl(r.campus_source)}/>
      <KV label="Campus evidence ID" value={r.campus_evidence?.id}/>
      <MetaLink label="Campus evidence source" value={r.campus_evidence?.source_url}/>
      <KV label="Relationship source" value={sourceLabel(r.relationship_source)}/>
      <MetaLink label="Relationship source URL" value={sourceUrl(r.relationship_source)}/>
      <KV label="Relationship evidence ID" value={r.relationship_evidence?.id}/>
      <MetaLink label="Relationship evidence source" value={r.relationship_evidence?.source_url}/>
      <KV label="Last verified" value={fmtDate(r.last_verified_at)}/>
      <KV label="Validity" value={validityLabel(r)}/>
    </div></details>
  </div>)}</div>
}

function IntakeRows({rows}){
  if(!rows?.length)return <div className="empty-note">No accepted Intake observations.</div>
  return <div className="mini-list">{rows.map((r,i)=><div className="fee-row" key={r.id??i}>
    <div className="fee-row-main"><b>{r.intake_label??`Intake ${r.intake_year??''}`.trim()}</b><span>{r.start_date?fmtDateOnly(r.start_date):'Start date not supplied'}</span></div>
    <small>{[`Year: ${r.intake_year??'Not supplied'}`,r.application_deadline?`Application deadline: ${fmtDateOnly(r.application_deadline)}`:'Application deadline not supplied',r.campus_id?`Campus: ${r.campus?.name??r.campus_id}`:'Campus scope: Not supplied by source'].join(' · ')}</small>
    <details className="fee-meta"><summary>Source & evidence</summary><div className="fee-meta-grid">
      <KV label="Status" value={humanise(r.status)}/>
      <KV label="Confidence" value={confidenceLabel(r.confidence)}/>
      <KV label="Source observation key" value={r.source_intake_key}/>
      <KV label="Source" value={sourceLabel(r.source)}/>
      <MetaLink label="Source URL" value={sourceUrl(r.source)}/>
      <KV label="Evidence ID" value={r.evidence?.id}/>
      <MetaLink label="Evidence source" value={r.evidence?.source_url}/>
      <KV label="Evidence captured" value={fmtDate(r.evidence?.captured_at)}/>
    </div></details>
  </div>)}</div>
}

function EnglishRows({rows}){
  if(!rows?.length)return <div className="empty-note">No accepted English requirement observations.</div>
  return <div className="mini-list">{rows.map((r,i)=><div className="fee-row" key={r.id??i}>
    <div className="fee-row-main"><b>{r.test_name??r.test_code??'English requirement'}</b><span>{r.overall_score===null||r.overall_score===undefined?'Overall score not supplied':`Overall ${Number(r.overall_score).toLocaleString()}`}</span></div>
    <small>{componentLabel(r.component_scores)}</small>
    <details className="fee-meta"><summary>Requirement provenance</summary><div className="fee-meta-grid">
      <KV label="Test code" value={r.test_code}/>
      <KV label="Scope" value={humanise(r.scope)}/>
      <KV label="Status" value={humanise(r.status)}/>
      <KV label="Confidence" value={confidenceLabel(r.confidence)}/>
      <KV label="Validity" value={validityLabel(r)}/>
      <KV label="Last verified" value={fmtDate(r.last_verified_at)}/>
      <KV label="Source observation key" value={r.source_requirement_key}/>
      <KV label="Source" value={sourceLabel(r.source)}/>
      <MetaLink label="Source URL" value={sourceUrl(r.source)}/>
      <KV label="Evidence ID" value={r.evidence?.id}/>
      <MetaLink label="Evidence source" value={r.evidence?.source_url}/>
    </div></details>
  </div>)}</div>
}

function TaxonomyRows({levels,fields}){
  if(!levels?.length&&!fields?.length)return <div className="empty-note">No taxonomy source-lineage observations.</div>
  return <div className="mini-list">
    {levels?.map((r,i)=><div className="fee-row" key={`level-${r.id??i}`}>
      <div className="fee-row-main"><b>Study Level</b><span>{`${r.source_value??'Source value not supplied'} → ${r.canonical_level?.name??r.canonical_level?.code??'Canonical mapping not supplied'}`}</span></div>
      <small>{[r.scheme?`Scheme: ${r.scheme}`:null,r.registration_code?`Registration: ${r.registration_code}`:null,r.mapping_status?`Mapping: ${humanise(r.mapping_status)}`:null].filter(Boolean).join(' · ')}</small>
      <details className="fee-meta"><summary>Mapping evidence</summary><div className="fee-meta-grid">
        <KV label="Canonical code" value={r.canonical_level?.code}/>
        <KV label="Source snapshot" value={fmtDate(r.source_snapshot_at)}/>
        <KV label="Observed" value={fmtDate(r.observed_at)}/>
        <KV label="Last verified" value={fmtDate(r.last_verified_at)}/>
        <KV label="Source" value={sourceLabel(r.source)}/>
        <MetaLink label="Source URL" value={sourceUrl(r.source)}/>
        <KV label="Evidence ID" value={r.evidence?.id}/>
        <MetaLink label="Evidence source" value={r.evidence?.source_url}/>
      </div></details>
    </div>)}
    {fields?.map((r,i)=><div className="fee-row" key={`field-${r.id??i}`}>
      <div className="fee-row-main"><b>Field of Study</b><span>{`${[r.source_field_code,r.source_field_name].filter(Boolean).join(' / ')||'Source field not supplied'} → ${r.canonical_field?.name??r.canonical_field?.code??'Canonical mapping not supplied'}`}</span></div>
      <small>{[r.canonical_field?.code?`Canonical: ${r.canonical_field.code}`:null,r.is_primary?'Primary':'Additional',r.status?humanise(r.status):null].filter(Boolean).join(' · ')}</small>
      <details className="fee-meta"><summary>Mapping evidence</summary><div className="fee-meta-grid">
        <KV label="Observed" value={fmtDate(r.observed_at)}/>
        <KV label="Source" value={sourceLabel(r.source)}/>
        <MetaLink label="Source URL" value={sourceUrl(r.source)}/>
        <KV label="Evidence ID" value={r.evidence?.id}/>
        <MetaLink label="Evidence source" value={r.evidence?.source_url}/>
      </div></details>
    </div>)}
  </div>
}

function GenericSection({title,rows}){
  if(rows===undefined||rows===null)return null
  const list=Array.isArray(rows)?rows:[rows]
  return <section className="subpanel"><h3>{title}</h3>{list.length?<div className="table-wrap"><table><thead><tr>{genericKeys(list).map(k=><th key={k}>{humanise(k)}</th>)}</tr></thead><tbody>{list.map((r,i)=><tr key={r?.id??i}>{genericKeys(list).map(k=><td key={k} className="truncate">{fmt(r?.[k])}</td>)}</tr>)}</tbody></table></div>:<div className="empty-note">No records.</div>}</section>
}

function genericKeys(rows){return [...new Set(rows.flatMap(r=>Object.keys(r??{})))].filter(k=>!['source','evidence'].includes(k)).slice(0,10)}
function KV({label,value}){return <div className="kv"><small>{label}</small><strong>{value===null||value===undefined||value===''?'—':String(value)}</strong></div>}
function MetaLink({label,value}){return <div className="kv"><small>{label}</small>{value?<a href={value} target="_blank" rel="noreferrer">{value}</a>:<strong>—</strong>}</div>}
function sourceLabel(source){return source?.label??source?.source_label??source?.name??null}
function sourceUrl(source){return source?.url??source?.source_url??null}
function feeTypeLabel(v){return FEE_TYPE_LABELS[v]??humanise(v??'Fee')}
function feeBasisLabel(v){return FEE_BASIS_LABELS[v]??humanise(v??'Basis not supplied')}
function feeYearLabel(v){return v===null||v===undefined||v===''?'Year: Not supplied by source':`Year: ${v}`}
function validityLabel(r){if(!r?.valid_from&&!r?.valid_to)return 'No explicit validity window supplied';return `${r.valid_from?fmtDateOnly(r.valid_from):'Open start'} → ${r.valid_to?fmtDateOnly(r.valid_to):'Open end'}`}
function componentLabel(v){if(!v||typeof v!=='object'||!Object.keys(v).length)return 'Component thresholds not supplied';return Object.entries(v).map(([k,x])=>`${humanise(k)} ${x}`).join(' · ')}
function confidenceLabel(v){return v===null||v===undefined?'Not supplied':`${Math.round(Number(v)*100)}%`}
function humanise(v){return v===null||v===undefined||v===''?'—':String(v).replaceAll('_',' ').replace(/\b\w/g,c=>c.toUpperCase())}
function fmtDate(v){return v?new Date(v).toLocaleString():'—'}
function fmtDateOnly(v){if(!v)return '—';const d=new Date(`${String(v).slice(0,10)}T00:00:00`);return Number.isNaN(d.valueOf())?String(v):d.toLocaleDateString()}
function fmt(v){if(v===null||v===undefined||v==='')return '—';if(typeof v==='object')return JSON.stringify(v);return String(v)}
function strip(obj,keys){return Object.fromEntries(Object.entries(obj??{}).filter(([k])=>!keys.includes(k)))}
