import { createClient } from '@supabase/supabase-js'

const url = import.meta.env.VITE_SUPABASE_URL
const key = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY

if (!url || !key) console.warn('Missing VITE_SUPABASE_URL or VITE_SUPABASE_PUBLISHABLE_KEY')

export const supabase = createClient(url ?? '', key ?? '', {
  auth: { persistSession: true, autoRefreshToken: true, detectSessionInUrl: true }
})

export async function adminRead(operation, payload = {}, options = {}) {
  let query = supabase.rpc('admin_read', {
    p_operation: operation,
    p_args: payload,
  })
  if (options.signal) query = query.abortSignal(options.signal)
  const { data, error } = await query
  if (error) throw error
  return data
}

export async function invokeAdmin(operation, payload = {}, options = {}) {
  const data = await adminRead(operation, payload, options)
  if (operation === 'context') {
    return {
      role: data?.role ?? 'unassigned',
      role_rank: data?.role_rank ?? 0,
      user: { id: data?.user_id ?? null, email: data?.email ?? null },
    }
  }
  return data
}

export async function matchScholarships() {
  return {
    status: 'relational_workspace',
    matches: [],
    message: 'Scholarship eligibility remains governed by relational scopes, cycles, criteria, tiers and coverage. Automated matching is not promoted by this gate.'
  }
}
