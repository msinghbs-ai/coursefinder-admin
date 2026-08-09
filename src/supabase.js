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
  const { data, error } = await supabase.functions.invoke('pim-admin-v2-1', {
    body: { operation, ...payload }
  })
  if (error) throw error
  if (data?.error) throw new Error(data.error)
  return data
}

export async function matchScholarships(profile, courseId = null) {
  const { data, error } = await supabase.functions.invoke('scholarship-match-v2-1', {
    body: { profile, course_id: courseId || null }
  })
  if (error) throw error
  if (data?.error) throw new Error(data.error)
  return data
}
