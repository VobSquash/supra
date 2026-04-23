# admin-reset-password (Edge Function)

Admin-only password change for member support cases.

## What it does
- Verifies caller session from `Authorization` header.
- Requires caller profile type `administrator` or `elivated`.
- Sets a new password for `target_profile_id` (or by `target_email` lookup).
- Writes an audit row to `public.admin_password_resets_audit`.
- Enforces a simple per-admin rate limit (20/hour) using the audit table.
- Handles legacy rows where `profiles.id` may not match `auth.users.id` by falling back to email lookup.

## Required SQL
Apply:
- `supabase/sql/profiles_admin_mutations.sql`
- `supabase/sql/admin_password_resets_audit.sql`

## Required function secrets
Set in Supabase project:
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`

## Deploy
```bash
supabase functions deploy admin-reset-password
```

Then set **Verify JWT = OFF** for this function in the Supabase dashboard.
The function performs caller verification internally using `auth.getUser()` and role checks.

## Invoke payload
```json
{
  "target_profile_id": "uuid-here",
  "new_password": "temp-password-123",
  "reason": "admin_support"
}
```

Alternative payload:
```json
{
  "target_email": "member@example.com",
  "new_password": "temp-password-123",
  "reason": "admin_support"
}
```
