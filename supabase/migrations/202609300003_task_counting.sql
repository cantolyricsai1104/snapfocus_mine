-- Optional daily counting support for goals and tasks.
alter table public.tasks
  add column if not exists count_target integer;

alter table public.tasks
  add column if not exists count_unit text;

alter table public.tasks
  add column if not exists count_by_date jsonb not null default '{}'::jsonb;

alter table public.goals
  add column if not exists task_count_target integer;

alter table public.goals
  add column if not exists task_count_unit text;
