import React, { useEffect, useMemo, useState } from 'react'
import { createRoot } from 'react-dom/client'
import { supabase, invokeAdmin, matchScholarships } from './supabase'
import './styles.css'

const nav = ['Dashboard', 'Scholarships', 'Review Queue', 'Attributes', 'Evidence', 'Scholarship Matcher']

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
        <nav>{nav.map(item => <button key={item} className={page===item?'active':''} onClick={() => setPage(item)}>{item}</button>)}</nav>
        <div className="account"><small>{context?.role ?? 'loading...'}</small><div>{context?.user?.email ?? session.user.email}</div><button onClick={() => supabase.auth.signOut()}>Sign out</button></div>
      </aside>
      <main>
        <header><div><h1>{page}</h1><p>Canonical PIM, evidence and Layer 4 curation</p></div><span className="pill">{context?.role ?? '...'}</span></header>
        {error && <div className="alert">{error}<button onClick={()=>setError('')}>×</button></div>}
        {page==='Dashboard' && <Dashboard />}
        {page==='Scholarships' && <Scholarships onError={setError} />}
        {page==='Review Queue' && <ReviewQueue onError={setError} />}
        {page==='Attributes' && <Attributes onError={setError} />}
        {page==='Evidence' && <Evidence onError={setError} />}
        {page==='Scholarship Matcher' && <Matcher onError={setError} />}
      </main>
    </div>
  )
}

function Login({ onError, error }) {
  const [email,setEmail]=useState(''); const [password,setPassword]=useState(''); const [busy,setBusy]=useState(false)
  async function signIn(e){ e.preventDefault(); setBusy(true); onError(''); const {error}=await supabase.auth.signInWithPassword({email,password}); if(error) onError(error.message); setBusy(false) }
  return <div className="login-wrap"><form className="login-card" onSubmit={signIn}><div className="logo">CF</div><h1>Coursefinder PIM</h1><p>Sign in with your Supabase admin account.</p>{error&&<div className="alert">{error}</div>}<label>Email<input value={email} onChange={e=>setEmail(e.target.value)} type="email" required /></label><label>Password<input value={password} onChange={e=>setPassword(e.target.value)} type="password" required /></label><button className="primary" disabled={busy}>{busy?'Signing in…':'Sign in'}</button></form></div>
}

function Dashboard(){
  const [stats,setStats]=useState({courses:'—',providers:'—',avg:'—',scholarships:'—'})
  useEffect(()=>{Promise.all([
    supabase.from('catalogue_stats').select('*').single(),
    supabase.from('scholarship_catalogue_v2').select('id',{count:'exact',head:true})
  ]).then(([a,b])=>setStats({courses:a.data?.courses??'—',providers:a.data?.providers??'—',avg:a.data?.avg_completeness??'—',scholarships:b.count??'—'}))},[])
  return <><div className="cards">{[['Courses',stats.courses],['Providers',stats.providers],['Scholarships',stats.scholarships],['Avg completeness',stats.avg+'%']].map(([k,v])=><section className="metric" key={k}><small>{k}</small><strong>{v}</strong></section>)}</div><section className="panel"><h2>V2.1 operating model</h2><div className="flow"><span>Layer 1<br/><b>Regulatory</b></span><i>→</i><span>Layer 2<br/><b>Evidence</b></span><i>→</i><span>Layer 3<br/><b>Normalise</b></span><i>→</i><span>Layer 4<br/><b>Human curate</b></span></div></section></>
}

function Scholarships({onError}){
  const [rows,setRows]=useState([]); const [q,setQ]=useState('')
  useEffect(()=>{supabase.from('scholarship_catalogue_v2').select('*').order('provider_name').order('canonical_name').limit(200).then(({data,error})=>error?onError(error.message):setRows(data??[]))},[onError])
  const shown=useMemo(()=>rows.filter(r=>(`${r.canonical_name} ${r.provider_name}`.toLowerCase().includes(q.toLowerCase()))),[rows,q])
  return <section className="panel"><div className="toolbar"><input placeholder="Search scholarships or providers" value={q} onChange={e=>setQ(e.target.value)}/><span>{shown.length} records</span></div><div className="table-wrap"><table><thead><tr><th>Scholarship</th><th>Provider</th><th>Year</th><th>Value</th><th>Application</th><th>Status</th></tr></thead><tbody>{shown.map(r=><tr key={r.id}><td><b>{r.canonical_name}</b></td><td>{r.provider_name}</td><td>{r.academic_year}</td><td>{r.value_percent_max?`${r.value_percent_max}%`:r.value_amount_max?`${r.currency??''} ${r.value_amount_max}`:r.value_text??'—'}</td><td>{r.application_mode??'—'}</td><td><span className="pill">{r.status}</span></td></tr>)}</tbody></table></div></section>
}

function ReviewQueue({onError}){
  const [rows,setRows]=useState([]); const [selected,setSelected]=useState(null); const [detail,setDetail]=useState(null); const [busy,setBusy]=useState(false)
  const load=()=>invokeAdmin('review.list',{status:'open',limit:100}).then(r=>setRows(r.data??[])).catch(e=>onError(e.message))
  useEffect(load,[])
  async function open(id){setSelected(id); try{setDetail(await invokeAdmin('review.get',{review_queue_id:id}))}catch(e){onError(e.message)}}
  async function act(action){if(!selected)return; setBusy(true); try{await invokeAdmin('review.resolve',{review_queue_id:selected,action,notes:'Actioned from PIM Admin v2.1'}); setDetail(null); setSelected(null); await load()}catch(e){onError(e.message)}finally{setBusy(false)}}
  return <div className="split"><section className="panel"><h2>Open review items</h2>{rows.map(r=><button className={`review-row ${selected===r.id?'selected':''}`} key={r.id} onClick={()=>open(r.id)}><span><b>{r.review_type??r.reason}</b><small>{r.entity_type} · priority {r.priority}</small></span><span>{new Date(r.created_at).toLocaleDateString()}</span></button>)}</section><section className="panel detail"><h2>Review detail</h2>{!detail?<p>Select an item.</p>:<><p><b>{detail.item.reason}</b></p><p>{detail.item.detail}</p><pre>{JSON.stringify(detail.item.proposed_changes??detail.item.llm_guess??{},null,2)}</pre>{detail.evidence?.signed_url&&<a className="primary link" href={detail.evidence.signed_url} target="_blank" rel="noreferrer">Open evidence</a>}<div className="actions"><button disabled={busy} onClick={()=>act('approve')}>Approve</button><button disabled={busy} onClick={()=>act('reject')}>Reject</button><button disabled={busy} onClick={()=>act('needs_research')}>Needs research</button></div></>}</section></div>
}

function Attributes({onError}){
 const [rows,setRows]=useState([]); const [aliases,setAliases]=useState([])
 useEffect(()=>{Promise.all([supabase.from('pim_attribute_definitions').select('*').order('entity_type').order('display_order'),supabase.from('pim_attribute_aliases').select('*,pim_attribute_definitions(code,name)').order('alias')]).then(([a,b])=>{if(a.error)onError(a.error.message); else setRows(a.data??[]); if(b.error)onError(b.error.message); else setAliases(b.data??[])})},[onError])
 return <div className="split"><section className="panel"><h2>Global attributes</h2><div className="table-wrap"><table><thead><tr><th>Code</th><th>Entity</th><th>Type</th><th>Filter</th></tr></thead><tbody>{rows.map(r=><tr key={r.id}><td><b>{r.code}</b><small>{r.name}</small></td><td>{r.entity_type}</td><td>{r.data_type}</td><td>{r.is_filterable?'Yes':'No'}</td></tr>)}</tbody></table></div></section><section className="panel"><h2>University aliases</h2>{aliases.map(a=><div className="alias" key={a.id}><b>{a.alias}</b><span>→ {a.pim_attribute_definitions?.name??'Attribute'}</span></div>)}</section></div>
}

function Evidence({onError}){
 const [rows,setRows]=useState([])
 useEffect(()=>{supabase.from('evidence_artifacts').select('id,entity_type,entity_id,url,artifact_type,mime_type,fetched_at,storage_path').order('fetched_at',{ascending:false}).limit(100).then(({data,error})=>error?onError(error.message):setRows(data??[]))},[onError])
 async function open(id){try{const r=await invokeAdmin('evidence.signed_url',{evidence_id:id,expires_seconds:600}); window.open(r.signed_url,'_blank','noopener,noreferrer')}catch(e){onError(e.message)}}
 return <section className="panel"><h2>Evidence repository</h2><div className="table-wrap"><table><thead><tr><th>Entity</th><th>Type</th><th>Fetched</th><th>Source</th><th></th></tr></thead><tbody>{rows.map(r=><tr key={r.id}><td>{r.entity_type??'—'}</td><td>{r.artifact_type??r.mime_type??'page'}</td><td>{new Date(r.fetched_at).toLocaleString()}</td><td className="truncate">{r.url}</td><td>{r.storage_path&&<button onClick={()=>open(r.id)}>Signed link</button>}</td></tr>)}</tbody></table></div></section>
}

function Matcher({onError}){
 const [form,setForm]=useState({citizenship_code:'IN',target_study_level:'postgraduate',target_field_of_study:'',wam:'80',gpa:'',atar:'',ielts_overall:'7'}); const [result,setResult]=useState(null); const [busy,setBusy]=useState(false)
 const set=(k,v)=>setForm(f=>({...f,[k]:v}))
 async function run(e){e.preventDefault();setBusy(true);try{const profile={...form,wam:num(form.wam),gpa:num(form.gpa),atar:num(form.atar),ielts_overall:num(form.ielts_overall)};setResult(await matchScholarships(profile))}catch(e){onError(e.message)}finally{setBusy(false)}}
 return <div className="split"><form className="panel form" onSubmit={run}><h2>Student profile</h2><label>Citizenship<input value={form.citizenship_code} onChange={e=>set('citizenship_code',e.target.value.toUpperCase())}/></label><label>Study level<input value={form.target_study_level} onChange={e=>set('target_study_level',e.target.value)}/></label><label>Field of study<input value={form.target_field_of_study} onChange={e=>set('target_field_of_study',e.target.value)}/></label><div className="grid2"><label>WAM<input value={form.wam} onChange={e=>set('wam',e.target.value)}/></label><label>GPA<input value={form.gpa} onChange={e=>set('gpa',e.target.value)}/></label><label>ATAR<input value={form.atar} onChange={e=>set('atar',e.target.value)}/></label><label>IELTS<input value={form.ielts_overall} onChange={e=>set('ielts_overall',e.target.value)}/></label></div><button className="primary" disabled={busy}>{busy?'Matching…':'Match scholarships'}</button></form><section className="panel"><h2>Results</h2>{!result?<p>Run a profile to evaluate structured scholarship criteria.</p>:<><div className="cards compact"><section className="metric"><small>Eligible</small><strong>{result.summary?.eligible??0}</strong></section><section className="metric"><small>Possible</small><strong>{result.summary?.possible??0}</strong></section><section className="metric"><small>Not eligible</small><strong>{result.summary?.not_eligible??0}</strong></section></div>{result.matches?.map(m=><div className="match" key={m.scholarship_id}><div><b>{m.scholarship_name}</b><small>{m.provider_name}</small></div><span className={`pill ${m.match_status}`}>{m.match_status}</span></div>)}</>}</section></div>
}

const num=v=>v===''||v==null?null:Number(v)
createRoot(document.getElementById('root')).render(<React.StrictMode><App/></React.StrictMode>)
