-- Shared, per-account SnapFocus data for the web and Flutter clients.
-- Run once in Supabase Dashboard > SQL Editor.

create table if not exists public.tasks (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  id text not null,
  title text not null,
  duration_minutes integer not null default 25,
  type text not null check (type in ('focus', 'break')),
  color text not null default '#E97965',
  scheduled_time text,
  task_date date not null default current_date,
  repeat_rule text not null default 'none' check (repeat_rule in ('none', 'daily', 'weekly', 'monthly')),
  repeat_until date,
  completed boolean not null default false,
  completed_dates date[] not null default '{}',
  goal_id text,
  repeat_days integer[] not null default '{}',
  repeat_month_day integer,
  position integer not null default 0,
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

create table if not exists public.pillars (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  id text not null,
  name text not null,
  color text not null,
  emoji text not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

create table if not exists public.goals (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  id text not null,
  pillar_id text not null,
  name text not null,
  metric_type text not null default 'time',
  target_value double precision not null default 0,
  current_value double precision not null default 0,
  unit text not null default 'minutes',
  task_title text,
  task_weekdays integer[] not null default '{}',
  task_duration_minutes integer not null default 25,
  task_time text,
  duration_months integer not null default 3,
  duration_weeks integer not null default 0,
  duration_value integer not null default 3,
  duration_unit text not null default 'month',
  started_on date,
  task_repeat text not null default 'weekly',
  task_month_day integer not null default 1,
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

create table if not exists public.proof_photos (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  id text not null,
  task_id text,
  task_title text,
  goal_id text,
  object_path text,
  remote_url text,
  captured_at timestamptz not null default now(),
  focus_minutes integer,
  updated_at timestamptz not null default now(),
  primary key (user_id, id),
  check (object_path is not null or remote_url is not null)
);

create table if not exists public.proof_notes (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  goal_id text not null,
  note_date date not null,
  note text,
  updated_at timestamptz not null default now(),
  primary key (user_id, goal_id, note_date)
);

alter table public.tasks enable row level security;
alter table public.pillars enable row level security;
alter table public.goals enable row level security;
alter table public.proof_photos enable row level security;
alter table public.proof_notes enable row level security;

grant select, insert, update, delete on public.tasks, public.pillars,
  public.goals, public.proof_photos, public.proof_notes to authenticated;

do $$
declare table_name text;
begin
  foreach table_name in array array['tasks', 'pillars', 'goals', 'proof_photos', 'proof_notes'] loop
    execute format('drop policy if exists %I on public.%I', table_name || '_owner_access', table_name);
    execute format(
      'create policy %I on public.%I for all to authenticated using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()))',
      table_name || '_owner_access', table_name
    );
  end loop;
end $$;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('snapfocus-proofs', 'snapfocus-proofs', false, 10485760, array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do update set public = false, file_size_limit = 10485760,
  allowed_mime_types = array['image/jpeg', 'image/png', 'image/webp'];

drop policy if exists "Users manage their SnapFocus proof images" on storage.objects;
create policy "Users manage their SnapFocus proof images"
on storage.objects for all to authenticated
using (bucket_id = 'snapfocus-proofs' and (storage.foldername(name))[1] = (select auth.uid())::text)
with check (bucket_id = 'snapfocus-proofs' and (storage.foldername(name))[1] = (select auth.uid())::text);

-- Realtime lets the two clients reflect edits while both are open.
do $$
declare table_name text;
begin
  foreach table_name in array array['tasks', 'pillars', 'goals', 'proof_photos', 'proof_notes'] loop
    if not exists (
      select 1 from pg_publication_tables
      where pubname = 'supabase_realtime'
        and schemaname = 'public'
        and tablename = table_name
    ) then
      execute format('alter publication supabase_realtime add table public.%I', table_name);
    end if;
  end loop;
end $$;
