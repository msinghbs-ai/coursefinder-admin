-- M1-PIM-GOV Course detail helper ACL fix v1
-- Applied to coursefinder_Pilot after authenticated role-context UAT exposed
-- that the invoker public.admin_read wrapper could not execute the new
-- role-checked helpers in the non-exposed security schema.

revoke execute on function security.admin_course_entry_summary(uuid) from public, anon;
revoke execute on function security.admin_course_taxonomy_summary(uuid) from public, anon;

grant execute on function security.admin_course_entry_summary(uuid) to authenticated, service_role;
grant execute on function security.admin_course_taxonomy_summary(uuid) to authenticated, service_role;

-- Both helpers remain SECURITY DEFINER with internal current_role_rank()
-- checks. This grant makes them callable by the governed public.admin_read
-- invoker path; it does not expose the security schema as a browser API.
