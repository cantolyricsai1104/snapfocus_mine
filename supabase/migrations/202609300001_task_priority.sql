-- Add task urgency without changing or removing existing task data.
alter table public.tasks
  add column if not exists priority integer not null default 1;

alter table public.tasks
  drop constraint if exists tasks_priority_check;

alter table public.tasks
  add constraint tasks_priority_check check (priority between 1 and 3);
