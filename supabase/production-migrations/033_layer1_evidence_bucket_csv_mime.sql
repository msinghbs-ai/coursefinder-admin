-- Coursefinder Pilot migration 033
-- Allow Layer 1 regulatory CSV evidence in the private evidence bucket.

update storage.buckets
set allowed_mime_types = array[
  'application/pdf',
  'text/html',
  'text/plain',
  'text/csv',
  'application/json',
  'image/png',
  'image/jpeg'
]::text[]
where id = 'evidence';
