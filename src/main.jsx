import React, { useEffect, useMemo, useState } from 'react'
import { createRoot } from 'react-dom/client'
import { adminRead, invokeAdmin, supabase } from './supabase'
import './styles.css'

const UI_VERSION='2.4.0'

const NAV = [
  ['Overview', [['Dashboard',1]]],
  ['Catalogue', [['Providers',1],['Courses',1],['Campuses',1],['Completeness',1],['Scholarships',1]]],
  ['Insights / Enrichment', [['Outcomes (QILT)',1],['Student Flow (PRISMS)',1]]],
  ['Governance', [['Evidence',3],['Review Queue',3]]],
  ['Operations', [['Jobs',4],['Sources',4]]],
  ['PIM', [['Attributes',5]]],
]

const TITLES = {
  Dashboard:'Operational overview', Providers:'Providers', Courses:'Courses', Campuses:'Campuses',
  Completeness:'Completeness & readiness', Scholarships:'Scholarships', Evidence:'Evidence & history',
  'Review Queue':'Review Queue', Jobs:'Pipeline Jobs', Sources:'Regulatory Sources', Attributes:'PIM Governance',
  'Outcomes (QILT)':'Outcomes (QILT)', 'Student Flow (PRISMS)':'Student Flow (PRISMS)'
}

const FEE_TYPE_LABELS={tuition:'Tuition Fee',non_tuition:'Non-Tuition Fee',estimated_total_course_cost:'Estimated Total Course Cost',provider_current_tuition:'Provider-Current Tuition Fee'}
const FEE_BASIS_LABELS={registered_total_course:'Registered total course',indicative_annual:'Indicative annual',annual:'Annual',per_unit:'Per unit',per_credit:'Per credit',per_term:'Per term',per_semester:'Per semester'}

function App() {
  const [session,setSession]=useState(null)
  const [context,setContext]=useState(null)
  const [page,setPage]=useState('Dashboard')
  const [error,setError]=useState('')

  useEffect(()=>{
    supabase.auth.getSession().then(({data})=>setSession(data.session??null))
    const {data:sub}=supabase.auth.onAuthStateChange((_event,next)=>setSession(next))
    return ()=>sub.subscription.unsubscribe()
  },[])
  useEffect(()=>{
    if(!session){setContext(null);return}
    invokeAdmin('context').then(setContext).catch(e=>setError(e.message))
  },[session])

  if(!session) return <Login error={error} onError={setError}/>
  const rank=context?.role_rank??0
  return <div className="shell">
    <aside>
      <div className="brand"><span>CF</span><div><strong>Coursefinder</strong><small>PIM Admin v{UI_VERSION}</small></div></div>
      <nav>{NAV.map(([group,items])=>{
        const allowed=items.filter(([,min])=>rank>=min)
        if(!allowed.length)return null
        return <div className="nav-group" key={group}><small>{group}</small>{allowed.map(([item])=><button key={item} className={page===item?'active':''} onClick={()=>setPage(item)}>{item}</button>)}</div>
      })}</nav>
      <div className="account"><small>{context?.role??'loading...'}</small><div>{context?.user?.email??session.user.email}</div><button onClick={()=>supabase.auth.signOut()}>Sign out</button></div>
    </aside>
    <main>
      <header><div><h1>{TITLES[page]??page}</h1><p>Governed canonical catalogue, evidence and PIM operations</p></div><span className="pill">{context?.role??'...'}</span></header>
      {error&&<div className="alert">{error}<button onClick={()=>setError('')}>×</button></div>}
      <Page page={page} rank={rank} onError={setError}/>
    </main>
  </div>
}

function Login({error,onError}){
  const [email,setEmail]=useState(''),[password,setPassword]=useState(''),[busy,setBusy]=useState(false)
  async function submit(e){e.preventDefault();setBusy(true);onError('');const {error:x}=await supabase.auth.signInWithPassword({email,password});if(x)onError(x.message);setBusy(false)}
  return <div className="login-wrap"><form className="login-card" onSubmit={submit}><div className="logo">CF</div><h1>Coursefinder PIM</h1><p>Authorised staff access only. <span className="ui-version">PIM Admin v{UI_VERSION}</span></p>{error&&<div className="alert">{error}</div>}<label>Email<input type="email" value={email} onChange={e=>setEmail(e.target.value)} required/></label><label>Password<input type="password" value={password} onChange={e=>setPassword(e.target.value)} required/></label><button className="primary" disabled={busy}>{busy?'Signing in…':'Sign in'}</button></form></div>
}

function Page({page,rank,onError}){
  if(page==='Dashboard')return <Dashboard onError={onError}/>
  if(page==='Providers')return <EntityList operation="providers" detailOperation="provider_detail" type="provider" onError={onError}/>
  if(page==='Courses')return <EntityList operation="courses" detailOperation="course_detail" type="course" onError={onError}/>
  if(page==='Campuses')return <EntityList operation="campuses" detailOperation="campus_detail" type="campus" onError={onError}/>
  if(page==='Completeness')return <Completeness onError={onError}/>
  if(page==='Scholarships')return <EntityList operation="scholarships" detailOperation="scholarship_detail" type="scholarship" onError={onError}/>
  if(page==='Outcomes (QILT)')return <QiltInsights onError={onError}/>
  if(page==='Student Flow (PRISMS)')return <PrismsInsights onError={onError}/>
  if(page==='Evidence'&&rank>=3)return <SimpleList operation="evidence" onError={onError}/>
  if(page==='Review Queue'&&rank>=3)return <SimpleList operation="reviews" onError={onError}/>
  if(page==='Jobs'&&rank>=4)return <SimpleList operation="jobs" onError={onError}/>
  if(page==='Sources'&&rank>=4)return <SimpleList operation="sources" onError={onError}/>
  if(page==='Attributes'&&rank>=5)return <Attributes onError={onError}/>
  return <section className="panel"><p>This role is not authorised for the selected workspace.</p></section>
}

function useRead(operation,args,onError){
  const [data,setData]=useState(null),[busy,setBusy]=useState(true)
  useEffect(()=>{let live=true;setBusy(true);adminRead(operation,args).then(x=>{if(live)setData(x)}).catch(e=>onError(e.message)).finally(()=>{if(live)setBusy(false)});return()=>{live=false}},[operation,JSON.stringify(args),onError])
  return [data,busy]
}
function useDebounced(value,delay=300){const [v,setV]=useState(value);useEffect(()=>{const t=setTimeout(()=>setV(value),delay);return()=>clearTimeout(t)},[value,delay]);return v}

function Dashboard({onError}){
  const [data,busy]=useRead('dashboard',{},onError)
  if(busy)return <Loading/>
  const cards=[['Providers',data?.providers],['Courses',data?.courses],['Campuses',data?.campuses],['Scholarships',data?.scholarships],['Jobs',data?.jobs],['Open reviews',data?.open_reviews],['Evidence',data?.evidence],['Attributes',data?.attributes]]
  return <><div className="cards">{cards.map(([k,v])=><section className="metric" key={k}><small>{k}</small><strong>{v??'—'}</strong></section>)}</div><section className="panel"><h2>Admin security boundary</h2><p>Browser reads use the governed <code>admin_read</code> RPC. Internal catalogue, pipeline, scholarship and PIM schemas remain closed behind RLS and explicit role checks.</p></section></>
}

function EntityList({operation,detailOperation,type,onError}){
  const [rows,busy]=useRead(operation,{limit:type==='course'?2000:1000},onError)
  const [q,setQ]=useState(''),[selected,setSelected]=useState(null),[detail,setDetail]=useState(null),[detailBusy,setDetailBusy]=useState(false)
  const list=Array.isArray(rows)?rows:[]
  const filtered=useMemo(()=>list.filter(r=>JSON.stringify(r).toLowerCase().includes(q.toLowerCase())),[list,q])
  async function open(row){const id=row.course_id??row.id;setSelected(id);setDetailBusy(true);try{setDetail(await adminRead(detailOperation,{id}))}catch(e){onError(e.message)}finally{setDetailBusy(false)}}
  if(busy)return <Loading/>
  const cols=columnsFor(type)
  return <><section className="panel"><div className="toolbar"><input placeholder={`Search ${type}s`} value={q} onChange={e=>setQ(e.target.value)}/><span>{filtered.length} shown</span></div><ResizableTable workspace={`entity-${type}`} columns={cols} rows={filtered} rowKey={r=>r.course_id??r.id} selectedKey={selected} onRowClick={open} render={(r,c)=>renderCell(r,c.key,type)}/></section>{selected&&<Detail type={type} data={detail} busy={detailBusy} onClose={()=>{setSelected(null);setDetail(null)}}/>}</>
}

function columnsFor(type){
  if(type==='provider')return [{key:'canonical_name',label:'Provider',width:260},{key:'country_code',label:'Country',width:100},{key:'city',label:'City',width:160},{key:'lifecycle_status',label:'Lifecycle',width:120},{key:'publication_status',label:'Publication',width:130},{key:'course_count',label:'Courses',width:90}]
  if(type==='course')return [{key:'canonical_title',label:'Course',width:300},{key:'provider_name',label:'Provider',width:240},{key:'level_code',label:'Level',width:130},{key:'field_of_study',label:'Field',width:180},{key:'fee_amount',label:'CRICOS tuition (total course)',width:190},{key:'completeness_score_v2',label:'Complete',width:110}]
  if(type==='campus')return [{key:'name',label:'Campus',width:240},{key:'provider_name',label:'Provider',width:260},{key:'country_code',label:'Country',width:100},{key:'city',label:'City',width:160},{key:'status',label:'Status',width:120},{key:'course_count',label:'Courses',width:90}]
  return [{key:'name',label:'Scholarship',width:280},{key:'provider_name',label:'Provider',width:240},{key:'scholarship_type',label:'Type',width:150},{key:'audience',label:'Audience',width:130},{key:'award_value_text',label:'Award',width:160},{key:'publication_status',label:'Publication',width:130}]
}
function renderCell(r,key){
  const v=r[key]
  if(key==='canonical_name'||key==='canonical_title'||key==='name')return <b>{v??'—'}</b>
  if(key==='fee_amount')return v===null||v===undefined||v===''?'—':`${r.fee_currency??''} ${Number(v).toLocaleString()}`.trim()
  if(key==='completeness_score_v2')return <Score value={v??r.completeness_score}/>
  return v===null||v===undefined||v===''?'—':String(v)
}

function QiltInsights({onError}){
  const limit=50
  const [query,setQuery]=useState(''),[survey,setSurvey]=useState(''),[metric,setMetric]=useState(''),[provider,setProvider]=useState(''),[status,setStatus]=useState(''),[year,setYear]=useState(''),[offset,setOffset]=useState(0),[sort,setSort]=useState('provider'),[direction,setDirection]=useState('asc')
  const [selected,setSelected]=useState(null),[providerDetail,setProviderDetail]=useState(null),[providerBusy,setProviderBusy]=useState(false)
  const debounced=useDebounced(query)
  const [filters]=useRead('qilt_filters',{survey_code:survey||null},onError)
  const args={limit,offset,query:debounced||null,survey_code:survey||null,metric_code:metric||null,provider_id:provider||null,status:status||null,year:year||null,sort,direction}
  const [data,busy]=useRead('qilt_outcomes',args,onError)
  const rows=data?.items??[], total=Number(data?.total??0)
  const cols=[
    {key:'provider_name',label:'Provider',width:250,sortKey:'provider'},
    {key:'country_code',label:'Country',width:90},
    {key:'survey_name',label:'Survey',width:180,sortKey:'survey'},
    {key:'metric_name',label:'Metric',width:240,sortKey:'metric'},
    {key:'metric_value',label:'Value',width:110,sortKey:'value'},
    {key:'national_benchmark',label:'National benchmark',width:150,sortKey:'benchmark'},
    {key:'response_count',label:'Responses',width:110,sortKey:'responses'},
    {key:'collection_year_to',label:'Collection year',width:130,sortKey:'year'},
    {key:'audience',label:'Audience',width:130},{key:'status',label:'Status',width:110}
  ]
  function resetOffset(fn){return v=>{setOffset(0);fn(v)}}
  function changeSort(k){if(!k)return;setOffset(0);if(sort===k)setDirection(direction==='asc'?'desc':'asc');else{setSort(k);setDirection('asc')}}
  async function openProvider(id){if(!id)return;setProviderBusy(true);try{setProviderDetail(await adminRead('provider_detail',{id}))}catch(e){onError(e.message)}finally{setProviderBusy(false)}}
  return <>
    <section className="panel insight-intro"><h2>QILT Provider outcomes</h2><p>Structured Provider-level outcomes enrichment. Provider links are available because these accepted observations resolve to canonical Provider IDs; the outcome observation does not redefine Provider identity.</p></section>
    <section className="panel"><div className="filters"><input className="filter-search" placeholder="Search provider, survey, metric or source key" value={query} onChange={e=>{setQuery(e.target.value);setOffset(0)}}/><ComboFilter label="Survey" options={filters?.surveys??[]} value={survey} onChange={resetOffset(setSurvey)}/><ComboFilter label="Metric" options={filters?.metrics??[]} value={metric} onChange={resetOffset(setMetric)}/><ComboFilter label="Provider" options={filters?.providers??[]} value={provider} onChange={resetOffset(setProvider)} valueKey="id"/><ComboFilter label="Year" options={filters?.years??[]} value={year} onChange={resetOffset(setYear)} valueKey="value" labelKey="label"/><ComboFilter label="Status" options={filters?.statuses??[]} value={status} onChange={resetOffset(setStatus)}/></div>
      <GridStatus busy={busy} total={total} offset={offset} count={rows.length}/>
      <ResizableTable workspace="insights-qilt" columns={cols} rows={rows} rowKey={r=>r.id} selectedKey={selected?.id} onRowClick={setSelected} sort={sort} direction={direction} onSort={changeSort} render={(r,c)=>c.key==='provider_name'?<button className="cell-link" onClick={e=>{e.stopPropagation();openProvider(r.provider_id)}}>{r.provider_name}</button>:formatInsightCell(r,c.key)}/>
      <Pager total={total} limit={limit} offset={offset} onOffset={setOffset}/>
    </section>
    {selected&&<InsightDetail title={`${selected.provider_name} — ${selected.metric_name}`} row={selected} onClose={()=>setSelected(null)}/>} 
    {providerDetail&&<Detail type="provider" data={providerDetail} busy={providerBusy} onClose={()=>setProviderDetail(null)}/>} 
  </>
}

function PrismsInsights({onError}){
  const limit=50
  const [query,setQuery]=useState(''),[subdivision,setSubdivision]=useState(''),[studyArea,setStudyArea]=useState(''),[sector,setSector]=useState(''),[remoteness,setRemoteness]=useState(''),[suppressed,setSuppressed]=useState(''),[offset,setOffset]=useState(0),[sort,setSort]=useState('geography'),[direction,setDirection]=useState('asc'),[selected,setSelected]=useState(null)
  const debounced=useDebounced(query)
  const [filters]=useRead('prisms_filters',{},onError)
  const args={limit,offset,query:debounced||null,subdivision_code:subdivision||null,study_area_code:studyArea||null,sector_code:sector||null,remoteness_area:remoteness||null,suppressed:suppressed===''?null:suppressed,sort,direction}
  const [data,busy]=useRead('prisms_student_flow',args,onError)
  const rows=data?.items??[],total=Number(data?.total??0)
  const cols=[
    {key:'source_row',label:'Source row',width:100},
    {key:'source_geography_name',label:'Geography',width:220,sortKey:'geography'},
    {key:'subdivision_code',label:'State / Region',width:130,sortKey:'state'},
    {key:'source_study_area_name',label:'Study area',width:240,sortKey:'study_area'},
    {key:'source_sector_code',label:'Sector',width:150},
    {key:'source_remoteness_area',label:'Remoteness',width:160},
    {key:'period_end',label:'Period',width:120,sortKey:'period'},
    {key:'enrolments',label:'Enrolments',width:120,sortKey:'enrolments'},
    {key:'commencements',label:'Commencements',width:140,sortKey:'commencements'},
    {key:'suppressed',label:'Suppressed',width:110}
  ]
  function resetOffset(fn){return v=>{setOffset(0);fn(v)}}
  function changeSort(k){if(!k)return;setOffset(0);if(sort===k)setDirection(direction==='asc'?'desc':'asc');else{setSort(k);setDirection('asc')}}
  const suppressionOptions=[{code:'false',name:'Not suppressed'},{code:'true',name:'Suppressed'}]
  return <>
    <section className="panel insight-intro"><h2>PRISMS Student Flow</h2><p>Time-scoped geography / study-area / sector observations. This accepted source does not publish canonical Provider or Course dimensions, so this workspace deliberately provides no Provider/Course mapping or cross-link.</p></section>
    <section className="panel"><div className="filters"><input className="filter-search" placeholder="Search geography, study area, sector or remoteness" value={query} onChange={e=>{setQuery(e.target.value);setOffset(0)}}/><ComboFilter label="State / Region" options={filters?.subdivisions??[]} value={subdivision} onChange={resetOffset(setSubdivision)}/><ComboFilter label="Study area" options={filters?.study_areas??[]} value={studyArea} onChange={resetOffset(setStudyArea)}/><ComboFilter label="Sector" options={filters?.sectors??[]} value={sector} onChange={resetOffset(setSector)}/><ComboFilter label="Remoteness" options={filters?.remoteness??[]} value={remoteness} onChange={resetOffset(setRemoteness)}/><ComboFilter label="Suppression" options={suppressionOptions} value={suppressed} onChange={resetOffset(setSuppressed)}/></div>
      <GridStatus busy={busy} total={total} offset={offset} count={rows.length}/>
      <ResizableTable workspace="insights-prisms" columns={cols} rows={rows} rowKey={r=>r.id} selectedKey={selected?.id} onRowClick={setSelected} sort={sort} direction={direction} onSort={changeSort} render={(r,c)=>formatPrismsCell(r,c.key)}/>
      <Pager total={total} limit={limit} offset={offset} onOffset={setOffset}/>
    </section>
    {selected&&<InsightDetail title={`PRISMS source row ${selected.source_row??'—'}`} row={selected} onClose={()=>setSelected(null)} note="Source-grain observation only. No Provider/Course identity is inferred."/>}
  </>
}

function ComboFilter({label,options,value,onChange,valueKey='code',labelKey='name'}){
  const selected=options.find(o=>String(o?.[valueKey]??'')===String(value??''))
  const [text,setText]=useState(selected?.[labelKey]??'')
  useEffect(()=>setText(selected?.[labelKey]??''),[value,JSON.stringify(options)])
  const id=`combo-${label.toLowerCase().replace(/[^a-z0-9]+/g,'-')}`
  function change(v){setText(v);const match=options.find(o=>String(o?.[labelKey]??'').toLowerCase()===v.toLowerCase()||String(o?.[valueKey]??'')===v);onChange(match?String(match[valueKey]):'')}
  return <label className="combo-filter"><small>{label}</small><div><input list={id} value={text} placeholder={`All ${label.toLowerCase()}`} onChange={e=>change(e.target.value)}/>{text&&<button type="button" title={`Clear ${label}`} onClick={()=>{setText('');onChange('')}}>×</button>}</div><datalist id={id}>{options.map((o,i)=><option key={`${o?.[valueKey]??i}`} value={String(o?.[labelKey]??o?.[valueKey]??'')}>{o?.count!==undefined?`${o.count} records`:''}</option>)}</datalist></label>
}

function GridStatus({busy,total,offset,count}){return <div className="grid-status"><span>{busy?'Refreshing…':`${total.toLocaleString()} records`}</span><small>{count?`Showing ${offset+1}–${offset+count}`:'No matching rows'}</small></div>}
function Pager({total,limit,offset,onOffset}){const end=Math.min(total,offset+limit);return <div className="pager"><button disabled={offset===0} onClick={()=>onOffset(Math.max(0,offset-limit))}>Previous</button><span>{total?`${offset+1}–${end} of ${total}`:'0 records'}</span><button disabled={offset+limit>=total} onClick={()=>onOffset(offset+limit)}>Next</button></div>}

function useGridWidths(workspace,columns){
  const defaults=()=>Object.fromEntries(columns.map(c=>[c.key,c.width??160]))
  const [widths,setWidths]=useState(()=>{try{return {...defaults(),...JSON.parse(localStorage.getItem(`cf-grid-widths:${workspace}`)||'{}')}}catch{return defaults()}})
  useEffect(()=>{setWidths(prev=>{const next={...defaults(),...prev};return next})},[workspace,columns.map(c=>c.key).join('|')])
  useEffect(()=>{try{localStorage.setItem(`cf-grid-widths:${workspace}`,JSON.stringify(widths))}catch{}},[workspace,widths])
  function beginResize(e,key){e.preventDefault();e.stopPropagation();const startX=e.clientX,start=widths[key]??160;function move(ev){setWidths(w=>({...w,[key]:Math.max(80,Math.min(520,start+(ev.clientX-startX)))}))}function up(){document.removeEventListener('mousemove',move);document.removeEventListener('mouseup',up)}document.addEventListener('mousemove',move);document.addEventListener('mouseup',up)}
  function reset(){const next=defaults();setWidths(next);try{localStorage.removeItem(`cf-grid-widths:${workspace}`)}catch{}}
  return {widths,beginResize,reset}
}

function ResizableTable({workspace,columns,rows,rowKey,render,onRowClick,selectedKey,sort,direction,onSort}){
  const {widths,beginResize,reset}=useGridWidths(workspace,columns)
  return <><div className="grid-actions"><button type="button" onClick={reset}>Reset columns</button></div><div className="table-wrap"><table className="resizable-table"><colgroup>{columns.map(c=><col key={c.key} style={{width:widths[c.key]}}/>)}</colgroup><thead><tr>{columns.map(c=><th key={c.key} style={{width:widths[c.key]}}><button className={c.sortKey?'sort-head':'plain-head'} type="button" disabled={!c.sortKey} onClick={()=>c.sortKey&&onSort?.(c.sortKey)}>{c.label}{c.sortKey&&sort===c.sortKey?<span>{direction==='asc'?' ↑':' ↓'}</span>:null}</button><span className="resize-handle" onMouseDown={e=>beginResize(e,c.key)} /></th>)}</tr></thead><tbody>{rows.length?rows.map((r,i)=>{const key=rowKey?.(r)??i;return <tr key={key} className={selectedKey===key?'selected-row':''} onClick={()=>onRowClick?.(r)}>{columns.map(c=><td key={c.key}>{render?render(r,c):fmt(r[c.key])}</td>)}</tr>}):<tr><td colSpan={columns.length}><div className="empty-note">No matching records.</div></td></tr>}</tbody></table></div></>
}

function formatInsightCell(r,key){const v=r[key];if(key==='metric_value'||key==='national_benchmark')return v===null||v===undefined?'—':Number(v).toLocaleString();if(key==='response_count')return v===null||v===undefined?'—':Number(v).toLocaleString();if(key==='status')return <span className="pill">{humanise(v??'unknown')}</span>;return v===null||v===undefined||v===''?'—':String(v)}
function formatPrismsCell(r,key){const v=r[key];if(key==='enrolments'||key==='commencements')return r.suppressed&&v===null?<span className="suppressed">Suppressed</span>:v===null||v===undefined?'—':Number(v).toLocaleString();if(key==='suppressed')return v?<span className="pill warn-pill">Suppressed</span>:<span className="pill">No</span>;if(key==='source_sector_code')return humanise(v??'');return v===null||v===undefined||v===''?'—':String(v)}

function InsightDetail({title,row,onClose,note}){return <section className="panel detail-panel"><div className="toolbar"><div><small>INSIGHT DETAIL</small><h2>{title}</h2>{note&&<p className="semantic-note">{note}</p>}</div><button onClick={onClose}>Close</button></div><div className="detail-grid">{Object.entries(row??{}).filter(([,v])=>!Array.isArray(v)&&!(v&&typeof v==='object')).map(([k,v])=><KV key={k} label={humanise(k)} value={k.includes('url')&&v?<a href={v} target="_blank" rel="noreferrer">{v}</a>:fmt(v)}/>)}</div></section>}

function Detail({type,data,busy,onClose}){return <section className="panel detail-panel"><div className="toolbar"><div><small>{type.toUpperCase()} DETAIL</small><h2>{detailTitle(type,data)}</h2></div><button onClick={onClose}>Close</button></div>{busy?<Loading/>:!data?<p>No detail returned.</p>:type==='course'?<CourseDetail data={data}/>:type==='scholarship'?<ScholarshipDetail data={data}/>:<GenericDetail data={data}/>}</section>}
function detailTitle(type,d){return type==='provider'?d?.canonical_name:type==='course'?d?.canonical_title:type==='campus'?d?.name:d?.name}

function CourseDetail({data}){
  const fees=data?.fee_summary??{},cricos=fees.cricos_registered??[],provider=fees.provider_current??[],other=fees.other??[]
  return <div className="detail-stack"><div className="detail-grid"><KV label="Stable key" value={data.stable_key}/><KV label="Provider" value={data.provider_name}/><KV label="CRICOS / course code" value={data.course_code}/><KV label="Lifecycle" value={data.lifecycle_status}/><KV label="Publication" value={data.publication_status}/><KV label="Last verified" value={fmtDate(data.last_verified_at)}/></div><div className="fee-grid"><section className="fee-card"><small>REGULATORY</small><h3>CRICOS registered fees</h3><p>Registered total-course fee facts from CRICOS. These are not annualised and are not a substitute for the provider's current published fee.</p><FeeRows rows={cricos}/></section><section className="fee-card"><small>PROVIDER-CURRENT</small><h3>Current Provider fee</h3><p>Provider-published fee observations retain their fee year, basis, campus/intake scope and evidence separately from CRICOS.</p>{provider.length?<FeeRows rows={provider}/>:<div className="empty-note">No current Provider fee evidence loaded. CRICOS values are deliberately not substituted.</div>}</section></div>{other.length>0&&<section className="fee-card fee-review"><small>NEEDS ATTENTION</small><h3>Needs semantic review</h3><p>These active fee observations do not match a governed CRICOS registered or Provider-current fee class. They are shown for review and are not reclassified automatically.</p><FeeRows rows={other}/></section>}<Section title="Regulatory facts" value={data.regulatory_facts}/><Section title="Campuses" value={data.campuses}/><Section title="Evidence & history" value={data.evidence}/><Section title="Canonical detail" value={strip(data,['fee_summary','regulatory_facts','campuses','evidence'])}/></div>
}
function FeeRows({rows}){if(!rows?.length)return <div className="empty-note">No fee observations.</div>;return <div className="mini-list">{rows.map((r,i)=>{const missing=r.amount===null||r.amount===undefined||r.amount==='',currency=r.currency??r.currency_code??'';return <div className="fee-row" key={r.id??i}><div className="fee-row-main"><b>{feeTypeLabel(r.fee_type)}</b><span>{missing?'Amount not supplied':`${currency} ${Number(r.amount).toLocaleString()}`.trim()}</span></div><small>{[feeBasisLabel(r.basis),feeYearLabel(r.fee_year),feeAudienceLabel(r.audience)].join(' · ')}</small><details className="fee-meta"><summary>Source & evidence</summary><div className="fee-meta-grid"><KV label="Source" value={r.source?.label??r.source_id}/><MetaLink label="Source URL" value={r.source?.url}/><KV label="Evidence ID" value={r.evidence?.id??r.evidence_id}/><MetaLink label="Evidence source" value={r.evidence?.source_url}/><KV label="Source snapshot" value={fmtDate(r.source_snapshot_at)}/><KV label="Last verified" value={fmtDate(r.last_verified_at)}/><KV label="Validity" value={feeValidityLabel(r)}/><KV label="Campus scope" value={r.campus_id??'Not campus-scoped in this observation'}/></div></details></div>})}</div>}
function feeTypeLabel(v){return FEE_TYPE_LABELS[v]??humanise(v??'Fee')}
function feeBasisLabel(v){return FEE_BASIS_LABELS[v]??humanise(v??'Basis not supplied')}
function feeYearLabel(v){return v===null||v===undefined||v===''?'Year: Not supplied by source':`Year: ${v}`}
function feeAudienceLabel(v){return v?humanise(v):'Audience not supplied'}
function feeValidityLabel(r){if(!r?.valid_from&&!r?.valid_to)return 'No explicit validity window supplied';return `${r.valid_from?fmtDate(r.valid_from):'Open start'} → ${r.valid_to?fmtDate(r.valid_to):'Open end'}`}
function humanise(v){return String(v).replaceAll('_',' ').replace(/\b\w/g,c=>c.toUpperCase())}

function ScholarshipDetail({data}){const known=['identifiers','offering_cycles','application_windows','scopes','criterion_groups','criteria','award_tiers','coverage','evidence'];return <div className="detail-stack"><div className="detail-grid"><KV label="Provider" value={data.provider_name}/><KV label="Type" value={data.type??data.scholarship_type}/><KV label="Audience" value={data.audience}/><KV label="Lifecycle" value={data.lifecycle_status}/><KV label="Publication" value={data.publication_status}/><KV label="Source" value={data.source_url}/></div>{known.map(k=>data[k]!==undefined&&<Section key={k} title={k.replaceAll('_',' ')} value={data[k]}/>)}<Section title="Scholarship record" value={strip(data,known)}/></div>}
function GenericDetail({data}){return <div className="detail-stack"><div className="detail-grid">{Object.entries(data??{}).filter(([,v])=>!Array.isArray(v)&&!(v&&typeof v==='object')).slice(0,18).map(([k,v])=><KV key={k} label={humanise(k)} value={fmt(v)}/>)}</div>{Object.entries(data??{}).filter(([,v])=>Array.isArray(v)||(v&&typeof v==='object')).map(([k,v])=><Section key={k} title={humanise(k)} value={v}/>)}</div>}

function Completeness({onError}){
  const [rows,busy]=useRead('completeness',{limit:2000},onError)
  if(busy)return <Loading/>
  const list=Array.isArray(rows)?rows:[],core=r=>['has_registration','has_structure','has_fee','has_intake','has_english','has_description'].every(k=>Boolean(r[k])),ready=list.filter(core).length
  const rowsShown=[...list].sort((a,b)=>(a.completeness_score_v2??0)-(b.completeness_score_v2??0)).slice(0,1000)
  const cols=[{key:'canonical_title',label:'Course',width:300},{key:'provider_name',label:'Provider',width:240},{key:'completeness_score_v2',label:'Score',width:110},{key:'readiness',label:'Readiness',width:130},{key:'missing',label:'Missing',width:260}]
  return <><div className="cards"><section className="metric"><small>Core-ready</small><strong>{list.length?Math.round(ready/list.length*100):0}%</strong></section><section className="metric"><small>Needs enrichment</small><strong>{list.length-ready}</strong></section><section className="metric"><small>Loaded courses</small><strong>{list.length}</strong></section></div><section className="panel"><h2>Operational readiness</h2><p>“Core-ready” means the governed completeness signals for registration, structure, fee, intake, English and description are all present. It does not by itself publish a course to Search.</p><ResizableTable workspace="completeness" columns={cols} rows={rowsShown} rowKey={r=>r.course_id} render={(r,c)=>c.key==='canonical_title'?<b>{r.canonical_title}</b>:c.key==='completeness_score_v2'?<Score value={r.completeness_score_v2}/>:c.key==='readiness'?<span className="pill">{core(r)?'Core-ready':'Needs enrichment'}</span>:c.key==='missing'?(['registration','structure','fee','intake','english','description'].filter(x=>!r[`has_${x}`]).join(', ')||'—'):fmt(r[c.key])}/></section></>
}

function SimpleList({operation,onError}){
  const [rows,busy]=useRead(operation,{limit:1000},onError)
  if(busy)return <Loading/>
  const list=Array.isArray(rows)?rows:[]
  if(!list.length)return <section className="panel"><p>No records.</p></section>
  const keys=Object.keys(list[0]).filter(k=>!['metadata','source_metadata','system_config'].includes(k)).slice(0,9),cols=keys.map(k=>({key:k,label:humanise(k),width:k.includes('name')||k.includes('label')?240:160}))
  return <section className="panel"><ResizableTable workspace={`simple-${operation}`} columns={cols} rows={list} rowKey={(r,i)=>r.id??r.source_id??i} render={(r,c)=><span className="truncate">{fmt(r[c.key])}</span>}/></section>
}

function Attributes({onError}){const [data,busy]=useRead('attributes',{limit:2000},onError);if(busy)return <Loading/>;return <div className="detail-stack"><div className="cards">{[['Families',data?.families?.length],['Groups',data?.groups?.length],['Attributes',data?.attributes?.length],['Options',data?.options?.length],['Completeness profiles',data?.completeness_profiles?.length]].map(([k,v])=><section className="metric" key={k}><small>{k}</small><strong>{v??0}</strong></section>)}</div><Section title="Completeness profiles" value={data?.completeness_profiles}/><Section title="Attribute families" value={data?.families}/><Section title="Attribute groups" value={data?.groups}/><Section title="Attributes" value={data?.attributes}/></div>}

function Section({title,value}){if(value===undefined||value===null)return null;return <section className="subpanel"><h3>{title}</h3>{Array.isArray(value)?<JsonTable rows={value}/>:typeof value==='object'?<JsonTable rows={[value]}/>:<p>{String(value)}</p>}</section>}
function JsonTable({rows}){if(!rows?.length)return <div className="empty-note">No records.</div>;const keys=[...new Set(rows.flatMap(r=>Object.keys(r??{})))].slice(0,10);return <div className="table-wrap"><table><thead><tr>{keys.map(k=><th key={k}>{humanise(k)}</th>)}</tr></thead><tbody>{rows.map((r,i)=><tr key={r?.id??i}>{keys.map(k=><td key={k} className="truncate">{fmt(r?.[k])}</td>)}</tr>)}</tbody></table></div>}
function KV({label,value}){return <div className="kv"><small>{label}</small><strong>{value??'—'}</strong></div>}
function MetaLink({label,value}){return <div className="kv"><small>{label}</small>{value?<a href={value} target="_blank" rel="noreferrer">{value}</a>:<strong>—</strong>}</div>}
function Score({value}){const n=Math.round(Number(value??0));return <span className="score"><b>{n}%</b><i style={{width:`${Math.max(0,Math.min(100,n))}%`}}/></span>}
function Loading(){return <section className="panel"><p>Loading…</p></section>}
function fmt(v){if(v===null||v===undefined||v==='')return '—';if(typeof v==='object')return JSON.stringify(v);return String(v)}
function fmtDate(v){return v?new Date(v).toLocaleString():'—'}
function strip(obj,keys){return Object.fromEntries(Object.entries(obj??{}).filter(([k])=>!keys.includes(k)))}

createRoot(document.getElementById('root')).render(<React.StrictMode><App/></React.StrictMode>)