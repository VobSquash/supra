-- Audit + free-tier-friendly rate-limit support for admin password resets.
-- Apply before deploying the `admin-reset-password` edge function.

create table if not exists public.admin_password_resets_audit (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  requested_by_profile_id uuid not null,
  requested_by_email text,
  target_profile_id uuid not null,
  target_email text,
  reason text not null default 'admin_support'
);

create index if not exists idx_admin_password_resets_audit_requested_by_created_at
  on public.admin_password_resets_audit (requested_by_profile_id, created_at desc);

create index if not exists idx_admin_password_resets_audit_target_created_at
  on public.admin_password_resets_audit (target_profile_id, created_at desc);

alter table public.admin_password_resets_audit enable row level security;

drop policy if exists "admin_password_resets_audit_select_admin_or_elevated" on public.admin_password_resets_audit;
create policy "admin_password_resets_audit_select_admin_or_elevated"
  on public.admin_password_resets_audit
  for select
  to authenticated
  using (public._is_admin_or_elevated_profile());
