-- Calendar reminder preference per task.
alter table public.tasks
  add column if not exists reminder_minutes_before integer not null default 10;
