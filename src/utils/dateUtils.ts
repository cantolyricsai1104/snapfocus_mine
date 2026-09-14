import { TaskBlock } from '../types';

export function formatDateToYMD(d: Date): string {
  const year = d.getFullYear();
  const month = (d.getMonth() + 1).toString().padStart(2, '0');
  const day = d.getDate().toString().padStart(2, '0');
  return `${year}-${month}-${day}`;
}

export function getTodayDateString(): string {
  return formatDateToYMD(new Date());
}

export function isTaskScheduledOnDate(task: TaskBlock, dateStr: string): boolean {
  const taskDate = task.date || getTodayDateString();
  const repeat = task.repeat || 'none';

  if (repeat === 'none') {
    return taskDate === dateStr;
  }

  // If repeat is active, task only recurs on or after its initial scheduled date
  if (dateStr < taskDate) {
    return false;
  }

  // Check repeatUntil boundary if provided
  if (task.repeatUntil && dateStr > task.repeatUntil) {
    return false;
  }

  if (repeat === 'daily') {
    return true;
  }

  if (repeat === 'weekly') {
    const taskD = new Date(taskDate + 'T00:00:00');
    const targetD = new Date(dateStr + 'T00:00:00');
    return taskD.getDay() === targetD.getDay();
  }

  if (repeat === 'monthly') {
    const taskDay = parseInt(taskDate.split('-')[2] || '1', 10);
    const targetDay = parseInt(dateStr.split('-')[2] || '1', 10);
    return taskDay === targetDay;
  }

  return false;
}

export function isTaskCompletedOnDate(task: TaskBlock, dateStr: string): boolean {
  if (task.completedDates && task.completedDates.includes(dateStr)) {
    return true;
  }
  // For non-repeating single day tasks, fallback to task.completed
  if (!task.repeat || task.repeat === 'none') {
    return !!task.completed;
  }
  return false;
}
