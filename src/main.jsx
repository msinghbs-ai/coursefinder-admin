import React, { useEffect, useMemo, useState } from 'react'
import { createRoot } from 'react-dom/client'
import { supabase, invokeAdmin, matchScholarships } from './supabase'
import './styles.css'

const nav = [
  ['Overview',['Dashboard']],
  ['Catalogue',['Providers','Courses','Completeness','Scholarships']],
  ['Enrichment',['Pipeline','Jobs','Review Queue','Evidence']],
  ['PIM',['Attributes','Scholarship Matcher']]
]

function App() {
  const [session, setSession] = useState(null)
  const [page, setPage] = useState('Dashboard')
  const [context, setContext] = useState(null)
  const [error, setError] = useState('')

  useEffect(() => {
    supabase.auth.getSession().then(({ data }) => setSession(data.session ?? null))
    const { data: sub } = supabase.auth.onAuthStateChange((_event, next) => setSession(next))
    return () => sub.subscription.unsubscribe()
  }, [])

  useEffect(() => {
    if (!session) { setContext(null); return }
    invokeAdmin('context').then(setContext).catch(e => setError(e.message))
  }, [session])

  if (!session) return <Login onError={setError} error={error} />

  return (
    <div className="shell">
      <aside>
        <div className="brand"><span>CF</span><div><strong>Coursefinder</strong><small>PIM Admin v2.1</small></div></div>
        <nav>{nav.map(([group,items]) => <div className="nav-group" key={group}><small>{group}</small>{items.map(item => <button key={item} className={page===item?'active':''} onClick={() => setPage(item)}>{item}</button>)}</div>)}</nav>
        <div className="account"><small>{context?.role ?? 'loading...'}</small><div>{context?.user?.email ?? session.user.email}</div><button onClick={() => supabase.auth.signOut()}>Sign out</button></div>
      </aside>
      <main>
        <header><div><h1>{page}</h1><p>Canonical catalogue, enrichment pipeline and Layer 4 curation</p></div><span className="pill">{context?.role ?? '...'}</span></header>
        {error && <div className="alert">{error}<button onClick={()=>setError('')}>×</button></div>}
        {page==='Dashboard' && <Dashboard onError={setError}/>} 
        {page==='Providers' && <Providers onError={setError}/>} 
        {page==='Courses' && <Courses onError={setError}/>} 
        {page==='Completeness' && <Completeness onError={setError}/>} 
        {page==='Pipeline' && <Pipeline onError={setError}/>} 
        {page==='Jobs' && <Jobs onError={setError}/>} 
        {page==='Scholarships' && <Scholarships onError={setError}/>} 
        {page==='Review Queue' && <ReviewQueue onError={setError}/>} 
        {page==='Attributes' && <Attributes onError={setError}/>} 
        {page==='Evidence' && <Evidence onError={setError}/>} 
        {page==='Scholarship Matcher' && <Matcher onError={setError}/>} 
      </main>
    </div>
  )
}

function Login({ onError, error }) {
  const [email,setEmail]=useState(''); const [password,setPassword]=useState(''); const [busy,setBusy]=useState(false)
  async function signIn(e){ e.preventDefault(); setBusy(true); onError(''); const {error}=await supabase.auth.signInWithPassword({email,password}); if(error) onError(error.message); setBusy(false) }
  return <div className="login-wrap"><form className="login-card" onSubmit={signIn}><div className="logo">CF</div><h1>Coursefinder PIM</h1><p>Sign in with your Supabase admin account.</p>{error&&<div className="alert">{error}</div>}<label>Email<input value={email} onChange={e=>setEmail(e.target.value)} type="email" required /></label><label>Password<input value={password} onChange={e=>setPassword(e.target.value)} type="password" required /></label><button className="primary" disabled={busy}>{busy?'Signing in…':'Sign in'}</button></form></div>
}

function Dashboard({onError}){
  const [stats,setStats]=useState({courses:'—',providers:'—',avg:'—',scholarships:'—',jobs:'—',reviews:'—',evidence:'—',attributes:'—'})
  const [layers,setLayers]=useState([])
  useEffect(()=>{Promise.all([
    supabase.from('catalogue_stats').select('*').single(),
    supabase.from('scholarship_catalogue_v2').select('id',{count:'exact',head:true}),
    supabase.from('ingest_jobs').select('id',{count:'exact',head:true}),
    supabase.from('review_queue').select('id',{count:'exact',head:true}).in('status',['open','in_review']),
    supabase.from('evidence_artifacts').select('id',{count:'exact',head:true}),
    supabase.from('pim_attribute_definitions').select('id',{count:'exact',head:true}),
    supabase.from('ingest_jobs').select('layer,status,created_at,completed_at').order('created_at',{ascending:false}).limit(200)
  ]).then(([a,b,c,d,e,f,g])=>{
    const err=[a,b,c,d,e,f,g].find(x=>x.error)?.error; if(err) onError(err.message)
    setStats({courses:a.data?.courses??'—',providers:a.data?.providers??'—',avg:a.data?.avg_completeness??'—',scholarships:b.count??'—',jobs:c.count??'—',reviews:d.count??'—',evidence:e.count??'—',attributes:f.count??'—'})
    setLayers(layerSummary(g.data??[]))
  })},[onError])
  return <><div className="cards">{[['Courses',stats.courses],['Providers',stats.providers],['Scholarships',stats.scholarships],['Avg completeness',stats.avg+'%'],['Jobs',stats.jobs],['Open review',stats.reviews],['Evidence',stats.evidence],['Global attributes',stats.attributes]].map(([k,v])=><section className="metric" key={k}><small>{k}</small><strong>{v}</strong></section>)}</div><section className="panel"><h2>Layer operating status</h2><div className="layer-grid">{layers.map(l=><div className="layer-card" key={l.layer}><div><span className={`status-dot ${l.state}`}></span><b>Layer {l.layer}</b></div><small>{l.name}</small><strong>{l.count}</strong><span>{l.last ? `Last activity ${new Date(l.last).toLocaleString()}` : 'No tracked activity'}</span></div>)}</div></section></>
}

function Providers({onError}){
  const [rows,setRows]=useState([]); const [q,setQ]=useState('')
  useEffect(()=>{supabase.from('providers').select('id,canonical_name,country_code,city,website,lifecycle,publication,updated_at').order('canonical_name').limit(1000).then(({data,error})=>error?onError(error.message):setRows(data??[]))},[onError])
  const shown=useMemo(()=>rows.filter(r=>`${r.canonical_name} ${r.country_code} ${r.city??''}`.toLowerCase().includes(q.toLowerCase())),[rows,q])
  return <section className="panel"><div className="toolbar"><input placeholder="Search provider, country or city" value={q} onChange={e=>setQ(e.target.value)}/><span>{shown.length} shown</span></div><div className="table-wrap"><table><thead><tr><th>Provider</th><th>Country</th><th>City</th><th>Lifecycle</th><th>Publication</th></tr></thead><tbody>{shown.map(r=><tr key={r.id}><td><b>{r.canonical_name}</b>{r.website&&<small>{r.website}</small>}</td><td>{r.country_code}</td><td>{r.city??'—'}</td><td>{r.lifecycle}</td><td>{r.publication}</td></tr>)}</tbody></table></div></section>
}

function Courses({onError}){
  const [rows,setRows]=useState([]); const [q,setQ]=useState('')
  useEffect(()=>{supabase.from('course_completeness_v2').select('*').order('provider_name').order('canonical_title').limit(1000).then(({data,error})=>error?onError(error.message):setRows(data??[]))},[onError])
  const shown=useMemo(()=>rows.filter(r=>`${r.canonical_title} ${r.provider_name} ${r.level_code??''} ${r.field_of_study??''}`.toLowerCase().includes(q.toLowerCase())),[rows,q])
  return <section className="panel"><div className="toolbar"><input placeholder="Search course, provider, level or field" value={q} onChange={e=>setQ(e.target.value)}/><span>{shown.length} shown / first 1,000</span></div><div className="table-wrap"><table><thead><tr><th>Course</th><th>Provider</th><th>Level</th><th>Field</th><th>Fee</th><th>IELTS</th><th>Scholarships</th><th>Complete</th></tr></thead><tbody>{shown.map(r=><tr key={r.course_id}><td><b>{r.canonical_title}</b></td><td>{r.provider_name}</td><td>{r.level_code??'—'}</td><td>{r.field_of_study??'—'}</td><td>{r.fee_amount?`${r.fee_currency??''} ${r.fee_amount}`:'—'}</td><td>{r.ielts_overall??'—'}</td><td>{r.scholarship_status??'unknown'} <small>{r.scholarship_count??0} linked</small></td><td><Score value={r.completeness_score_v2??r.completeness_score}/></td></tr>)}</tbody></table></div></section>
}

function Completeness({onError}){
  const [rows,setRows]=useState([])
  useEffect(()=>{supabase.from('course_completeness_v2').select('*').order('completeness_score_v2',{ascending:true}).limit(500).then(({data,error})=>error?onError(error.message):setRows(data??[]))},[onError])
  const fields=[['Registration','has_registration'],['Structure','has_structure'],['Fee','has_fee'],['Intake','has_intake'],['English','has_english'],['Description','has_description']]
  const summary=fields.map(([label,key])=>[label,rows.filter(r=>r[key]).length])
  return <><div className="cards">{summary.map(([k,v])=><section className="metric" key={k}><small>{k} present</small><strong>{rows.length?Math.round(v/rows.length*100):0}%</strong></section>)}</div><section className="panel"><h2>Lowest completeness courses</h2><div className="table-wrap"><table><thead><tr><th>Course</th><th>Provider</th><th>Score</th><th>Reg</th><th>Fee</th><th>Intake</th><th>English</th><th>Description</th><th>Scholarship</th></tr></thead><tbody>{rows.map(r=><tr key={r.course_id}><td><b>{r.canonical_title}</b></td><td>{r.provider_name}</td><td><Score value={r.completeness_score_v2}/></td><td>{yn(r.has_registration)}</td><td>{yn(r.has_fee)}</td><td>{yn(r.has_intake)}</td><td>{yn(r.has_english)}</td><td>{yn(r.has_description)}</td><td>{r.scholarship_status??'unknown'}</td></tr>)}</tbody></table></div></section></>
}

function Pipeline({onError}){
  const [jobs,setJobs]=useState([]); const [reviews,setReviews]=useState([]); const [evidenceCount,setEvidenceCount]=useState(0); const [fieldCount,setFieldCount]=useState(0)
  useEffect(()=>{Promise.all([
    supabase.from('ingest_jobs').select('*').order('created_at',{ascending:false}).limit(200),
    supabase.from('review_queue').select('id,status,source_layer,review_type,created_at').order('created_at',{ascending:false}).limit(200),
    supabase.from('evidence_artifacts').select('id',{count:'exact',head:true}),
    supabase.from('field_values').select('id',{count:'exact',head:true})
  ]).then(([a,b,c,d])=>{const err=[a,b,c,d].find(x=>x.error)?.error;if(err)onError(err.message);setJobs(a.data??[]);setReviews(b.data??[]);setEvidenceCount(c.count??0);setFieldCount(d.count??0)})},[onError])
  const ls=layerSummary(jobs)
  return <><div className="layer-grid">{ls.map(l=><section className="layer-card" key={l.layer}><div><span className={`status-dot ${l.state}`}></span><b>Layer {l.layer}</b></div><h3>{l.name}</h3><p>{layerDescription(l.layer)}</p><strong>{l.count} tracked jobs</strong><small>{l.last?`Last ${new Date(l.last).toLocaleString()}`:'No ingest job recorded'}</small></section>)}</div><div className="cards"><section className="metric"><small>Evidence artifacts</small><strong>{evidenceCount}</strong></section><section className="metric"><small>Field values</small><strong>{fieldCount}</strong></section><section className="metric"><small>Open Layer 4</small><strong>{reviews.filter(r=>['open','in_review'].includes(r.status)).length}</strong></section><section className="metric"><small>Total reviews</small><strong>{reviews.length}</strong></section></div><section className="panel"><h2>Pipeline responsibilities</h2><div className="flow"><span>Layer 1<br/><b>Regulatory truth</b></span><i>→</i><span>Layer 2<br/><b>Evidence acquisition</b></span><i>→</i><span>Layer 3<br/><b>LLM normalisation</b></span><i>→</i><span>Layer 4<br/><b>Human curate</b></span></div></section></>
}

function Jobs({onError}){
  const [rows,setRows]=useState([]); const [filter,setFilter]=useState('all')
  const load=()=>supabase.from('ingest_jobs').select('*').order('created_at',{ascending:false}).limit(500).then(({data,error})=>error?onError(error.message):setRows(data??[]))
  useEffect(load,[onError])
  const shown=filter==='all'?rows:rows.filter(r=>String(r.layer??'other')===filter)
  return <section className="panel"><div className="toolbar"><div className="tabs">{['all','1','2','3','4','other'].map(x=><button key={x} className={filter===x?'active-tab':''} onClick={()=>setFilter(x)}>{x==='all'?'All':x==='other'?'Other':`Layer ${x}`}</button>)}</div><button onClick={load}>Refresh</button></div><div className="table-wrap"><table><thead><tr><th>Created</th><th>Layer</th><th>Kind</th><th>Country</th><th>Status</th><th>Counters</th><th>Duration</th><th>Error</th></tr></thead><tbody>{shown.map(r=><tr key={r.id}><td>{new Date(r.created_at).toLocaleString()}</td><td>{r.layer??'—'}</td><td><b>{r.job_kind}</b></td><td>{r.country_code??'—'}</td><td><span className={`pill job-${r.status}`}>{r.status}</span></td><td><code>{compactJson(r.counters)}</code></td><td>{duration(r.started_at,r.completed_at)}</td><td className="truncate">{r.error_message??'—'}</td></tr>)}</tbody></table></div></section>
}

function Scholarships({onError}){
  const [rows,setRows]=useState([]); const [q,setQ]=useState('')
  useEffect(()=>{supabase.from('scholarship_catalogue_v2').select('*').order('provider_name').order('canonical_name').limit(500).then(({data,error})=>error?onError(error.message):setRows(data??[]))},[onError])
  const shown=useMemo(()=>rows.filter(r=>(`${r.canonical_name} ${r.provider_name}`.toLowerCase().includes(q.toLowerCase()))),[rows,q])
  return <section className="panel"><div className="toolbar"><input placeholder="Search scholarships or providers" value={q} onChange={e=>setQ(e.target.value)}/><span>{shown.length} records</span></div><div className="table-wrap"><table><thead><tr><th>Scholarship</th><th>Provider</th><th>Year</th><th>Value</th><th>Application</th><th>Status</th></tr></thead><tbody>{shown.map(r=><tr key={r.id}><td><b>{r.canonical_name}</b></td><td>{r.provider_name}</td><td>{r.academic_year}</td><td>{r.value_percent_max?`${r.value_percent_max}%`:r.value_amount_max?`${r.currency??''} ${r.value_amount_max}`:r.value_text??'—'}</td><td>{r.application_mode??'—'}</td><td><span className="pill">{r.status}</span></td></tr>)}</tbody></table></div></section>
}

function ReviewQueue({onError}){
  const [rows,setRows]=useState([]); const [selected,setSelected]=useState(null); const [detail,setDetail]=useState(null); const [busy,setBusy]=useState(false); const [status,setStatus]=useState('open')
  const load=()=>invokeAdmin('review.list',{status:status==='all'?undefined:status,limit:200}).then(r=>setRows(r.data??[])).catch(e=>onError(e.message))
  useEffect(load,[status])
  async function open(id){setSelected(id); try{setDetail(await invokeAdmin('review.get',{review_queue_id:id}))}catch(e){onError(e.message)}}
  async function act(action){if(!selected)return; setBusy(true); try{await invokeAdmin('review.resolve',{review_queue_id:selected,action,notes:'Actioned from PIM Admin v2.1'}); setDetail(null); setSelected(null); await load()}catch(e){onError(e.message)}finally{setBusy(false)}}
  return <div className="split"><section className="panel"><div className="toolbar"><h2>Review items</h2><select value={status} onChange={e=>setStatus(e.target.value)}><option value="open">Open</option><option value="in_review">In review</option><option value="resolved">Resolved</option><option value="rejected">Rejected</option><option value="all">All</option></select></div>{rows.map(r=><button className={`review-row ${selected===r.id?'selected':''}`} key={r.id} onClick={()=>open(r.id)}><span><b>{r.review_type??r.reason}</b><small>{r.entity_type} · layer {r.source_layer??'—'} · priority {r.priority}</small></span><span>{new Date(r.created_at).toLocaleDateString()}</span></button>)}</section><section className="panel detail"><h2>Review detail</h2>{!detail?<p>Select an item.</p>:<><p><b>{detail.item.reason}</b></p><p>{detail.item.detail}</p><pre>{JSON.stringify(detail.item.proposed_changes??detail.item.llm_guess??{},null,2)}</pre>{detail.evidence?.signed_url&&<a className="primary link" href={detail.evidence.signed_url} target="_blank" rel="noreferrer">Open evidence</a>}<div className="actions"><button disabled={busy} onClick={()=>act('approve')}>Approve</button><button disabled={busy} onClick={()=>act('reject')}>Reject</button><button disabled={busy} onClick={()=>act('needs_research')}>Needs research</button></div></>}</section></div>
}

function Attributes({onError}){
 const [rows,setRows]=useState([]); const [aliases,setAliases]=useState([]); const [values,setValues]=useState([]); const [families,setFamilies]=useState([]); const [groups,setGroups]=useState([])
 useEffect(()=>{Promise.all([
   supabase.from('pim_attribute_definitions').select('*,pim_attribute_groups(name)').order('entity_type').order('display_order'),
   supabase.from('pim_attribute_aliases').select('*,pim_attribute_definitions(code,name)').order('alias'),
   supabase.from('field_values').select('*').order('created_at',{ascending:false}).limit(200),
   supabase.from('pim_attribute_families').select('*').order('entity_type'),
   supabase.from('pim_attribute_groups').select('*').order('entity_type').order('display_order')
 ]).then(results=>{const err=results.find(x=>x.error)?.error;if(err)onError(err.message);setRows(results[0].data??[]);setAliases(results[1].data??[]);setValues(results[2].data??[]);setFamilies(results[3].data??[]);setGroups(results[4].data??[])})},[onError])
 return <><div className="cards"><section className="metric"><small>Families</small><strong>{families.length}</strong></section><section className="metric"><small>Groups</small><strong>{groups.length}</strong></section><section className="metric"><small>Definitions</small><strong>{rows.length}</strong></section><section className="metric"><small>Values</small><strong>{values.length}</strong></section></div><div className="split"><section className="panel"><h2>Global attributes</h2><div className="table-wrap"><table><thead><tr><th>Code</th><th>Entity</th><th>Group</th><th>Type</th><th>Filter</th></tr></thead><tbody>{rows.map(r=><tr key={r.id}><td><b>{r.code}</b><small>{r.name}</small></td><td>{r.entity_type}</td><td>{r.pim_attribute_groups?.name??'—'}</td><td>{r.data_type}</td><td>{r.is_filterable?'Yes':'No'}</td></tr>)}</tbody></table></div></section><section className="panel"><h2>University aliases</h2>{aliases.length?aliases.map(a=><div className="alias" key={a.id}><b>{a.alias}</b><span>→ {a.pim_attribute_definitions?.name??'Attribute'}</span></div>):<p>No aliases configured.</p>}</section></div><section className="panel"><h2>Recent custom attribute values</h2><div className="table-wrap"><table><thead><tr><th>Entity</th><th>Field</th><th>Value</th><th>Layer</th><th>Confidence</th><th>Review</th><th>Preferred</th></tr></thead><tbody>{values.map(v=><tr key={v.id}><td>{v.entity_type}</td><td><b>{v.field_code}</b></td><td>{renderValue(v)}</td><td>{v.source_layer}</td><td>{v.confidence??'—'}</td><td>{v.review_status}</td><td>{v.is_preferred?'Yes':'No'}</td></tr>)}</tbody></table></div></section></>
}

function Evidence({onError}){
 const [rows,setRows]=useState([])
 useEffect(()=>{supabase.from('evidence_artifacts').select('id,entity_type,entity_id,url,artifact_type,mime_type,fetched_at,storage_path').order('fetched_at',{ascending:false}).limit(200).then(({data,error})=>error?onError(error.message):setRows(data??[]))},[onError])
 async function open(id){try{const r=await invokeAdmin('evidence.signed_url',{evidence_id:id,expires_seconds:600}); window.open(r.signed_url,'_blank','noopener,noreferrer')}catch(e){onError(e.message)}}
 return <section className="panel"><h2>Evidence repository</h2><div className="table-wrap"><table><thead><tr><th>Entity</th><th>Type</th><th>Fetched</th><th>Source</th><th></th></tr></thead><tbody>{rows.map(r=><tr key={r.id}><td>{r.entity_type??'—'}</td><td>{r.artifact_type??r.mime_type??'page'}</td><td>{new Date(r.fetched_at).toLocaleString()}</td><td className="truncate">{r.url}</td><td>{r.storage_path&&<button onClick={()=>open(r.id)}>Signed link</button>}</td></tr>)}</tbody></table></div></section>
}

function Matcher({onError}){
 const [form,setForm]=useState({citizenship_code:'IN',target_study_level:'postgraduate',target_field_of_study:'',wam:'80',gpa:'',atar:'',ielts_overall:'7'}); const [result,setResult]=useState(null); const [busy,setBusy]=useState(false)
 const set=(k,v)=>setForm(f=>({...f,[k]:v}))
 async function run(e){e.preventDefault();setBusy(true);try{const profile={...form,wam:num(form.wam),gpa:num(form.gpa),atar:num(form.atar),ielts_overall:num(form.ielts_overall)};setResult(await matchScholarships(profile))}catch(e){onError(e.message)}finally{setBusy(false)}}
 return <div className="split"><form className="panel form" onSubmit={run}><h2>Student profile</h2><label>Citizenship<input value={form.citizenship_code} onChange={e=>set('citizenship_code',e.target.value.toUpperCase())}/></label><label>Study level<input value={form.target_study_level} onChange={e=>set('target_study_level',e.target.value)}/></label><label>Field of study<input value={form.target_field_of_study} onChange={e=>set('target_field_of_study',e.target.value)}/></label><div className="grid2"><label>WAM<input value={form.wam} onChange={e=>set('wam',e.target.value)}/></label><label>GPA<input value={form.gpa} onChange={e=>set('gpa',e.target.value)}/></label><label>ATAR<input value={form.atar} onChange={e=>set('atar',e.target.value)}/></label><label>IELTS<input value={form.ielts_overall} onChange={e=>set('ielts_overall',e.target.value)}/></label></div><button className="primary" disabled={busy}>{busy?'Matching…':'Match scholarships'}</button></form><section className="panel"><h2>Results</h2>{!result?<p>Run a profile to evaluate structured scholarship criteria.</p>:<><div className="cards compact"><section className="metric"><small>Eligible</small><strong>{result.summary?.eligible??0}</strong></section><section className="metric"><small>Possible</small><strong>{result.summary?.possible??0}</strong></section><section className="metric"><small>Not eligible</small><strong>{result.summary?.not_eligible??0}</strong></section></div>{result.matches?.map(m=><div className="match" key={m.scholarship_id}><div><b>{m.scholarship_name}</b><small>{m.provider_name}</small></div><span className={`pill ${m.match_status}`}>{m.match_status}</span></div>)}</>}</section></div>
}

function Score({value}){const n=Number(value??0);return <span className={`score ${n>=80?'good':n>=60?'mid':'low'}`}>{Number.isFinite(n)?`${Math.round(n)}%`:'—'}</span>}
function layerSummary(jobs){const defs=[[1,'Regulatory'],[2,'Evidence'],[3,'LLM Normalisation'],[4,'Human Curation']];return defs.map(([layer,name])=>{const j=jobs.filter(x=>x.layer===layer);const failed=j.filter(x=>x.status==='failed').length;const running=j.filter(x=>['running','queued','in_progress'].includes(x.status)).length;return {layer,name,count:j.length,last:j[0]?.created_at??null,state:failed?'bad':running?'warn':j.length?'good':'idle'}})}
function layerDescription(layer){return ({1:'Official registers and canonical provider/course identity.',2:'Website discovery, scraping and evidence acquisition.',3:'LLM extraction, normalisation and confidence routing.',4:'Human review, corrections and canonical approval.'})[layer]}
function yn(v){return <span className={v?'yes':'no'}>{v?'✓':'—'}</span>}
function duration(a,b){if(!a)return '—';const end=b?new Date(b):new Date();const s=Math.max(0,Math.round((end-new Date(a))/1000));return s<60?`${s}s`:s<3600?`${Math.round(s/60)}m`:`${(s/3600).toFixed(1)}h`}
function compactJson(v){if(!v)return '—';const s=JSON.stringify(v);return s.length>80?s.slice(0,77)+'…':s}
function renderValue(v){if(v.value_text!=null)return v.value_text;if(v.value_number!=null)return String(v.value_number);if(v.value_boolean!=null)return String(v.value_boolean);if(v.value_date!=null)return v.value_date;if(v.value_code!=null)return v.value_code;if(v.value_json!=null)return compactJson(v.value_json);return '—'}
const num=v=>v===''||v==null?null:Number(v)
createRoot(document.getElementById('root')).render(<React.StrictMode><App/></React.StrictMode>)
