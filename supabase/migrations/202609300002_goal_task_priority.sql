-- Store the priority of the recurring task generated from a goal.
alter table public.goals
  add column if not exists task_priority integer not null default 1;

alter table public.goals
  drop constraint if exists goals_task_priority_check;

alter table public.goals
  add constraint goals_task_priority_check
  check (task_priority between 1 and 3);
