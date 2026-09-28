export type TaskRepeat = 'none' | 'daily' | 'weekly' | 'monthly';

export interface TaskBlock {
  id: string;
  title: string;
  durationMinutes: number;
  type: 'break' | 'focus'; // break = relaxing/phone time, focus = deep work
  color?: string;
  scheduledTime?: string; // e.g. "09:00", "14:30"
  date?: string; // YYYY-MM-DD
  repeat?: TaskRepeat;
  repeatUntil?: string; // YYYY-MM-DD
  completed?: boolean;
  completedDates?: string[]; // Array of YYYY-MM-DD strings
  goalId?: string;
  repeatDays?: number[];
  repeatMonthDay?: number;
}

export interface FocusSnapshot {
  id: string;
  taskId: string;
  taskTitle: string;
  photoUri: string;
  timestamp: string; // ISO format
  focusMinutesCompleted?: number;
}

export type TimerStatus = 'idle' | 'running' | 'paused' | 'transition-locked' | 'completed';

export type ActiveTab = 'tasks' | 'calendar' | 'timer' | 'gallery' | 'timeline';

