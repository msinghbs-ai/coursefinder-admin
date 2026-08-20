import React from 'react'

export default function CourseStatePanel({data}){
  const state=data?.state_summary??{}
  const canonical=state.canonical??{}
  const readiness=state.admin_readiness??{}
  const signals=readiness.signals??{}
  const channels=state.consumer_channels??[]
  const search=state.search??{}
  const projection=search.global_projection??{}
  return <section className="subpanel">
    <h3>State & publication</h3>
    <p className="semantic-note">Lifecycle, canonical publication, Admin readiness, channel publication and Search projection are independent states. None should be inferred from another.</p>

    <div className="detail-grid">
      <KV label="Canonical lifecycle" value={humanise(canonical.lifecycle_status)}/>
      <KV label="Canonical publication" value={humanise(canonical.publication_status)}/>
      <KV label="Admin canonical presence readiness" value={scoreLabel(readiness.score)}/>
      <KV label="Consumer channel states" value={channels.length?`${channels.length} recorded`:'No channel publication state recorded'}/>
      <KV label="Search projection" value={search.projected?'Projected':'Not projected'}/>
      <KV label="Search publication" value={search.projected?humanise(search.publication_status):'Not applicable — no Search document'}/>
    </div>

    <div className="fee-grid">
      <section className="fee-card">
        <small>ADMIN READINESS</small>
        <h3>Canonical presence signals</h3>
        <p>{readiness.definition??'Display-only canonical presence readiness.'}</p>
        <div className="mini-list">{Object.entries(signals).map(([key,value])=><div className="fee-row" key={key}><div className="fee-row-main"><b>{humanise(key)}</b><span>{value?'Present':'Missing'}</span></div></div>)}</div>
      </section>

      <section className="fee-card">
        <small>SEARCH PROJECTION</small>
        <h3>Downstream Search admission</h3>
        <p>Search flags describe the derived Search document. They may remain false even when accepted canonical observations exist because enrichment admission is a separate gate.</p>
        {search.projected?<div className="mini-list">
          <StateCompare label="Fee" canonical={signals.fee} projected={search.has_fee}/>
          <StateCompare label="Intake" canonical={signals.intake} projected={search.has_intake}/>
          <StateCompare label="English" canonical={signals.english} projected={search.has_english}/>
          <StateCompare label="Scholarship" canonical={data?.has_scholarship} projected={search.has_scholarship} canonicalLabel="Canonical relationship"/>
        </div>:<div className="empty-note">No Search document currently exists for this Course. This does not alter canonical lifecycle or readiness.</div>}
        <details className="fee-meta"><summary>Projection metadata</summary><div className="fee-meta-grid">
          <KV label="Projection version" value={search.projection_version}/>
          <KV label="Catalogue generation" value={search.catalogue_generation}/>
          <KV label="Generated at" value={fmtDate(search.generated_at)}/>
          <KV label="Projection updated" value={fmtDate(search.updated_at)}/>
          <KV label="Source updated" value={fmtDate(search.source_updated_at)}/>
          <KV label="Global projection rows" value={projection.row_count}/>
          <KV label="Global generation" value={projection.generation}/>
          <KV label="Global rebuilt at" value={fmtDate(projection.rebuilt_at)}/>
        </div></details>
      </section>
    </div>

    <section className="fee-card">
      <small>CONSUMER CHANNELS</small>
      <h3>Channel publication state</h3>
      {channels.length?<div className="mini-list">{channels.map((c,i)=><div className="fee-row" key={`${c.channel_code??'channel'}-${c.locale??i}`}>
        <div className="fee-row-main"><b>{c.channel_name??c.channel_code??'Channel'}</b><span>{humanise(c.publication_status)}</span></div>
        <small>{[c.locale,c.audience?humanise(c.audience):null,c.completeness_score!==null&&c.completeness_score!==undefined?`Channel completeness ${scoreLabel(c.completeness_score)}`:null].filter(Boolean).join(' · ')}</small>
      </div>)}</div>:<div className="empty-note">No publishing.entity_states row exists for this Course. Do not interpret this as published, rejected or incomplete; no channel state has been recorded.</div>}
    </section>
  </section>
}

function StateCompare({label,canonical,projected,canonicalLabel='Canonical presence'}){return <div className="fee-row"><div className="fee-row-main"><b>{label}</b><span>{`${canonicalLabel}: ${canonical?'Yes':'No'} · Search admitted: ${projected?'Yes':'No'}`}</span></div></div>}
function KV({label,value}){return <div className="kv"><small>{label}</small><strong>{value===null||value===undefined||value===''?'—':String(value)}</strong></div>}
function scoreLabel(v){return v===null||v===undefined||v===''?'Not calculated':`${Number(v).toLocaleString()}%`}
function humanise(v){return v===null||v===undefined||v===''?'—':String(v).replaceAll('_',' ').replace(/\b\w/g,c=>c.toUpperCase())}
function fmtDate(v){return v?new Date(v).toLocaleString():'—'}
