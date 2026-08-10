import { createClient } from '@supabase/supabase-js'

const url = import.meta.env.VITE_SUPABASE_URL
const key = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY

if (!url || !key) {
  console.warn('Missing VITE_SUPABASE_URL or VITE_SUPABASE_PUBLISHABLE_KEY')
}

export const supabase = createClient(url ?? '', key ?? '', {
  auth: { persistSession: true, autoRefreshToken: true, detectSessionInUrl: true }
})

export async function invokeAdmin(operation, payload = {}) {
  if (operation === 'context') {
    const { data, error } = await supabase.rpc('ui_context')
    if (error) throw error
    return {
      role: data?.role ?? 'unassigned',
      role_rank: data?.role_rank ?? 0,
      user: {
        id: data?.user_id ?? null,
        email: data?.email ?? null,
      },
    }
  }

  throw new Error(`Admin write operation '${operation}' is not yet promoted to the v2.9.1 Mumbai API bridge.`)
}

export async function matchScholarships() {
  return {
    status: 'pilot_not_seeded',
    matches: [],
    message: 'Scholarship matching will activate after the scholarship pilot dataset is loaded into coursefinder_Pilot.'
  }
}
