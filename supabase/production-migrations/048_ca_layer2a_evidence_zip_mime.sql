-- 048_ca_layer2a_evidence_zip_mime.sql
-- Statistics Canada WDS full-table CSV downloads are delivered as ZIP archives.

update storage.buckets
set allowed_mime_types = case
  when allowed_mime_types is null then array['application/zip']::text[]
  when not ('application/zip'=any(allowed_mime_types)) then array_append(allowed_mime_types,'application/zip')
  else allowed_mime_types
end
where id='evidence';
