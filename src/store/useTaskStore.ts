import { create } from 'zustand';
import { TaskBlock, TimerStatus, ActiveTab } from '../types';
import { audioManager } from '../services/audioManager';
import { Haptics } from '../services/haptics';
import { getTodayDateString } from '../utils/dateUtils';

const INITIAL_TASKS: TaskBlock[] = [
  {
    id: 'task-1',
    title: 'Scroll Phone & Twitter',
    durationMinutes: 15,
    type: 'break',
    color: '#8B5CF6', // Calm Lavender
    scheduledTime: '09:00',
  },
  {
    id: 'task-2',
    title: 'Learn Python Backend',
    durationMinutes: 45,
    type: 'focus',
    color: '#FF6B00', // Electric Orange
    scheduledTime: '09:30',
  },
  {
    id: 'task-3',
    title: 'Coffee & Stretch Break',
    durationMinutes: 15,
    type: 'break',
    color: '#3B82F6', // Soft Slate Blue
    scheduledTime: '10:30',
  },
  {
    id: 'task-4',
    title: 'Code SnapFocus Architecture',
    durationMinutes: 60,
    type: 'focus',
    color: '#CCFF00', // Focus Lime
    scheduledTime: '11:00',
  },
  {
    id: 'task-5',
    title: 'Lunch & Fresh Air Walk',
    durationMinutes: 30,
    type: 'break',
    color: '#10B981', // Calm Mint
    scheduledTime: '12:30',
  }
];

const STORAGE_KEY = 'snapfocus_tasks_v2';
const LOCAL_DATA_OWNER_KEY = 'snapfocus_tasks_owner_v1';
let activeDataUserId: string | null = null;

function scopedStorageKey() {
  return activeDataUserId ? `${STORAGE_KEY}:${activeDataUserId}` : STORAGE_KEY;
}

function sortTasksChronologically(tasks: TaskBlock[]): TaskBlock[] {
  return [...tasks].sort((a, b) => {
    if (a.scheduledTime && b.scheduledTime) {
      const [hA, mA] = a.scheduledTime.split(':').map(Number);
      const [hB, mB] = b.scheduledTime.split(':').map(Number);
      const minA = (isNaN(hA) ? 0 : hA) * 60 + (isNaN(mA) ? 0 : mA);
      const minB = (isNaN(hB) ? 0 : hB) * 60 + (isNaN(mB) ? 0 : mB);
      return minA - minB;
    }
    if (a.scheduledTime) return -1;
    if (b.scheduledTime) return 1;
    return 0;
  });
}

function loadStoredTasks(): TaskBlock[] {
  const today = getTodayDateString();
  const ensureDefaults = (items: TaskBlock[]) =>
    items.map((item) => ({
      ...item,
      date: item.date || today,
      repeat: item.repeat || 'none',
    }));

  if (typeof window === 'undefined') return sortTasksChronologically(ensureDefaults(INITIAL_TASKS));
  try {
    const data = localStorage.getItem(scopedStorageKey());
    if (data) {
      const parsed = JSON.parse(data);
      if (Array.isArray(parsed) && parsed.length > 0) {
        return sortTasksChronologically(ensureDefaults(parsed));
      }
    }
  } catch {
    // fallback
  }
  return sortTasksChronologically(ensureDefaults(INITIAL_TASKS));
}

function saveTasks(tasks: TaskBlock[]) {
  if (typeof window === 'undefined') return;
  try {
    localStorage.setItem(scopedStorageKey(), JSON.stringify(tasks));
  } catch {
    // ignore
  }
}

interface TaskStoreState {
  tasks: TaskBlock[];
  activeTaskIndex: number;
  timerStatus: TimerStatus;
  timeRemaining: number; // in seconds
  activeTab: ActiveTab;
  isCameraModalOpen: boolean;
  activeBreakEndedBlock: TaskBlock | null;
  pendingFocusBlock: TaskBlock | null;
  alarmHapticInterval: number | null;

  // Actions
  setTasks: (tasks: TaskBlock[]) => void;
  addTask: (task: Omit<TaskBlock, 'id'>) => void;
  updateTask: (id: string, updates: Partial<TaskBlock>) => void;
  deleteTask: (id: string) => void;
  reorderTasks: (fromIndex: number, toIndex: number) => void;
  scheduleTask: (id: string, scheduledTime: string, date?: string) => void;
  toggleTaskCompleted: (id: string, dateStr?: string) => void;
  sortTasksByTime: () => void;
  setActiveTab: (tab: ActiveTab) => void;
  
  // Timer Controls
  startRoutine: (fromIndex?: number) => void;
  pauseTimer: () => void;
  resumeTimer: () => void;
  resetRoutine: () => void;
  skipToNextTask: () => void;
  adjustTimeRemaining: (secondsDelta: number) => void;
  tick: () => void;

  // Photo-Gated Transition
  triggerBreakLock: () => void;
  triggerFastTestTransition: () => void;
  openCameraModal: () => void;
  closeCameraModal: () => void;
  unlockWithPhotoCapture: () => void;
}

export const useTaskStore = create<TaskStoreState>((set, get) => ({
  tasks: loadStoredTasks(),
  activeTaskIndex: 0,
  timerStatus: 'idle',
  timeRemaining: loadStoredTasks()[0]?.durationMinutes * 60 || 600,
  activeTab: 'tasks',
  isCameraModalOpen: false,
  activeBreakEndedBlock: null,
  pendingFocusBlock: null,
  alarmHapticInterval: null,

  setTasks: (tasks) => {
    saveTasks(tasks);
    set({ tasks });
  },

  scheduleTask: (id, scheduledTime, date) => {
    const updated = get().tasks.map((t) =>
      t.id === id ? { ...t, scheduledTime, date: date || t.date } : t
    );
    const sorted = sortTasksChronologically(updated);
    saveTasks(sorted);
    set({ tasks: sorted });
    Haptics.notificationAsync('success');
  },

  toggleTaskCompleted: (id, dateStr) => {
    const targetDate = dateStr || getTodayDateString();
    const currentTasks = get().tasks;
    const targetTask = currentTasks.find((t) => t.id === id);
    if (!targetTask) return;

    const completedDates = targetTask.completedDates || [];
    const isCurrentlyDone =
      completedDates.includes(targetDate) ||
      (!targetTask.repeat || targetTask.repeat === 'none' ? !!targetTask.completed : false);

    let nextCompletedDates: string[];
    if (isCurrentlyDone) {
      nextCompletedDates = completedDates.filter((d) => d !== targetDate);
    } else {
      nextCompletedDates = [...completedDates, targetDate];
    }

    const nextCompletedBool = !isCurrentlyDone;

    const updated = currentTasks.map((t) =>
      t.id === id
        ? {
            ...t,
            completed: nextCompletedBool,
            completedDates: nextCompletedDates,
          }
        : t
    );

    saveTasks(updated);
    set({ tasks: updated });

    if (nextCompletedBool) {
      audioManager.playUnlockSound();
      Haptics.notificationAsync('success');
    } else {
      Haptics.selectionAsync();
    }
  },

  sortTasksByTime: () => {
    const sorted = sortTasksChronologically(get().tasks);
    saveTasks(sorted);
    set({ tasks: sorted });
    Haptics.impactAsync('light');
  },

  addTask: (taskData) => {
    const newTask: TaskBlock = {
      ...taskData,
      id: `task-${Date.now()}`,
      date: taskData.date || getTodayDateString(),
      repeat: taskData.repeat || 'none',
      repeatUntil: taskData.repeatUntil,
      color: taskData.color || (taskData.type === 'focus' ? '#FF6B00' : '#8B5CF6'),
    };
    const updated = [...get().tasks, newTask];
    const sorted = taskData.scheduledTime ? sortTasksChronologically(updated) : updated;
    saveTasks(sorted);
    set({ tasks: sorted });
    Haptics.impactAsync('light');
  },

  updateTask: (id, updates) => {
    const updated = get().tasks.map((t) => (t.id === id ? { ...t, ...updates } : t));
    saveTasks(updated);
    const { activeTaskIndex, timerStatus, tasks } = get();
    if (timerStatus === 'idle' && tasks[activeTaskIndex]?.id === id && updates.durationMinutes !== undefined) {
      set({ tasks: updated, timeRemaining: updates.durationMinutes * 60 });
    } else {
      set({ tasks: updated });
    }
  },

  deleteTask: (id) => {
    const currentTasks = get().tasks;
    let updated = currentTasks.filter((t) => t.id !== id);
    if (updated.length === 0) {
      updated = [
        {
          id: `task-${Date.now()}`,
          title: 'Deep Focus Session',
          durationMinutes: 25,
          type: 'focus',
          color: '#FF6B00',
          scheduledTime: '10:00',
        },
      ];
    }
    saveTasks(updated);
    const newActiveIndex = Math.max(0, Math.min(get().activeTaskIndex, updated.length - 1));
    set({
      tasks: updated,
      activeTaskIndex: newActiveIndex,
      timeRemaining: updated[newActiveIndex]?.durationMinutes * 60 || 300,
    });
    Haptics.impactAsync('medium');
  },

  reorderTasks: (fromIndex, toIndex) => {
    const tasks = [...get().tasks];
    const [moved] = tasks.splice(fromIndex, 1);
    tasks.splice(toIndex, 0, moved);
    saveTasks(tasks);
    set({ tasks });
    Haptics.selectionAsync();
  },

  setActiveTab: (tab) => {
    set({ activeTab: tab });
    Haptics.impactAsync('light');
  },

  startRoutine: (fromIndex = 0) => {
    const { tasks } = get();
    if (tasks.length === 0) return;
    const index = Math.max(0, Math.min(fromIndex, tasks.length - 1));
    const currentTask = tasks[index];

    set({
      activeTaskIndex: index,
      timerStatus: 'running',
      timeRemaining: currentTask.durationMinutes * 60,
      activeTab: 'timer',
    });
    Haptics.notificationAsync('success');
  },

  pauseTimer: () => {
    set({ timerStatus: 'paused' });
    Haptics.impactAsync('light');
  },

  resumeTimer: () => {
    set({ timerStatus: 'running' });
    Haptics.impactAsync('medium');
  },

  resetRoutine: () => {
    const { tasks, activeTaskIndex, alarmHapticInterval } = get();
    audioManager.stopTransitionAlarm();
    if (alarmHapticInterval) {
      clearInterval(alarmHapticInterval);
    }
    const currentTask = tasks[activeTaskIndex] || tasks[0];
    set({
      timerStatus: 'idle',
      timeRemaining: currentTask ? currentTask.durationMinutes * 60 : 600,
      activeBreakEndedBlock: null,
      pendingFocusBlock: null,
      isCameraModalOpen: false,
      alarmHapticInterval: null,
    });
    Haptics.impactAsync('heavy');
  },

  skipToNextTask: () => {
    const { tasks, activeTaskIndex } = get();
    if (activeTaskIndex < tasks.length - 1) {
      const nextIndex = activeTaskIndex + 1;
      const nextTask = tasks[nextIndex];
      set({
        activeTaskIndex: nextIndex,
        timeRemaining: nextTask.durationMinutes * 60,
      });
      Haptics.impactAsync('medium');
    }
  },

  adjustTimeRemaining: (secondsDelta) => {
    const current = get().timeRemaining;
    const updated = Math.max(5, current + secondsDelta);
    set({ timeRemaining: updated });
    Haptics.selectionAsync();
  },

  triggerBreakLock: () => {
    const { tasks, activeTaskIndex, alarmHapticInterval } = get();
    if (alarmHapticInterval) {
      clearInterval(alarmHapticInterval);
    }

    const breakBlock = tasks[activeTaskIndex];
    // Next block should be focus (or wrap around/fallback to next available block)
    const nextBlock = tasks[activeTaskIndex + 1] || {
      id: 'next-focus',
      title: 'Deep Work Session',
      durationMinutes: 45,
      type: 'focus',
      color: '#FF6B00',
    };

    // Play loop alarm sound!
    audioManager.startTransitionAlarm();

    // Trigger haptic pulses
    Haptics.alarmPattern();
    const hapticId = window.setInterval(() => {
      Haptics.alarmPattern();
    }, 1200);

    set({
      timerStatus: 'transition-locked',
      activeBreakEndedBlock: breakBlock,
      pendingFocusBlock: nextBlock,
      alarmHapticInterval: hapticId,
      activeTab: 'timer',
    });
  },

  triggerFastTestTransition: () => {
    // For quick demo testing: instantly triggers the photo-gated lock screen!
    const { tasks, activeTaskIndex } = get();
    const current = tasks[activeTaskIndex] || tasks[0];
    const isBreak = current?.type === 'break';
    
    if (!isBreak) {
      // Find the first break task or set current to break temporarily
      const breakIdx = tasks.findIndex((t) => t.type === 'break');
      if (breakIdx !== -1) {
        set({ activeTaskIndex: breakIdx });
      }
    }
    get().triggerBreakLock();
  },

  openCameraModal: () => {
    set({ isCameraModalOpen: true });
    Haptics.impactAsync('medium');
  },

  closeCameraModal: () => {
    // Only close if NOT in mandatory transition lock!
    const { timerStatus } = get();
    if (timerStatus === 'transition-locked') {
      // Cannot dismiss camera while transition locked
      Haptics.notificationAsync('warning');
      return;
    }
    set({ isCameraModalOpen: false });
  },

  unlockWithPhotoCapture: () => {
    const { tasks, activeTaskIndex, alarmHapticInterval } = get();

    // 1. Immediately kill alarm & haptic loop
    audioManager.stopTransitionAlarm();
    if (alarmHapticInterval) {
      clearInterval(alarmHapticInterval);
    }

    // Mark completed for the ended break block
    const today = getTodayDateString();
    const updatedTasks = tasks.map((t, idx) => {
      if (idx === activeTaskIndex) {
        const cDates = t.completedDates || [];
        return {
          ...t,
          completed: true,
          completedDates: cDates.includes(today) ? cDates : [...cDates, today],
        };
      }
      return t;
    });
    saveTasks(updatedTasks);

    // 2. Advance to next block (or next focus task)
    let nextIndex = activeTaskIndex + 1;
    if (nextIndex >= updatedTasks.length) {
      nextIndex = 0; // loop routine
    }

    const nextTask = updatedTasks[nextIndex];

    set({
      tasks: updatedTasks,
      timerStatus: 'running',
      activeTaskIndex: nextIndex,
      timeRemaining: nextTask.durationMinutes * 60,
      isCameraModalOpen: false,
      activeBreakEndedBlock: null,
      pendingFocusBlock: null,
      alarmHapticInterval: null,
      activeTab: 'timer',
    });

    Haptics.notificationAsync('success');
  },

  tick: () => {
    const { timerStatus, timeRemaining, tasks, activeTaskIndex, triggerBreakLock } = get();
    if (timerStatus !== 'running') return;

    if (timeRemaining <= 1) {
      const currentTask = tasks[activeTaskIndex];
      if (currentTask && currentTask.type === 'break') {
        // Break has ended! Trigger transition lock!
        triggerBreakLock();
      } else {
        // Focus task ended! Check if there is next task
        audioManager.playUnlockSound();
        Haptics.notificationAsync('success');

        const today = getTodayDateString();
        const updatedTasks = tasks.map((t, idx) => {
          if (idx === activeTaskIndex) {
            const cDates = t.completedDates || [];
            return {
              ...t,
              completed: true,
              completedDates: cDates.includes(today) ? cDates : [...cDates, today],
            };
          }
          return t;
        });
        saveTasks(updatedTasks);

        if (activeTaskIndex < updatedTasks.length - 1) {
          const nextIndex = activeTaskIndex + 1;
          const nextTask = updatedTasks[nextIndex];
          set({
            tasks: updatedTasks,
            activeTaskIndex: nextIndex,
            timeRemaining: nextTask.durationMinutes * 60,
            timerStatus: 'running',
          });
        } else {
          set({
            tasks: updatedTasks,
            timerStatus: 'completed',
            timeRemaining: 0,
          });
        }
      }
    } else {
      set({ timeRemaining: timeRemaining - 1 });
    }
  },
}));

/** Loads this account's local cache; legacy browser data is claimed only once. */
export function setTaskDataUser(userId: string | null) {
  if (activeDataUserId === userId) return;
  activeDataUserId = userId;
  if (!userId || typeof window === 'undefined') return;

  try {
    const scoped = localStorage.getItem(scopedStorageKey());
    let serialized = scoped;
    if (!serialized && !localStorage.getItem(LOCAL_DATA_OWNER_KEY)) {
      serialized = localStorage.getItem(STORAGE_KEY);
      localStorage.setItem(LOCAL_DATA_OWNER_KEY, userId);
    }
    const parsed = serialized ? JSON.parse(serialized) : null;
    const tasks = Array.isArray(parsed)
      ? sortTasksChronologically(parsed)
      : sortTasksChronologically(INITIAL_TASKS.map((item) => ({
          ...item,
          date: item.date || getTodayDateString(),
          repeat: item.repeat || 'none',
        })));
    saveTasks(tasks);
    useTaskStore.setState({ tasks, activeTaskIndex: 0 });
  } catch {
    // If browser storage is unavailable, keep the in-memory list.
  }
}
