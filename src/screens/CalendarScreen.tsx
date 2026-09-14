import React, { useState, useEffect, useMemo, useRef } from 'react';
import { useTaskStore } from '../store/useTaskStore';
import { TaskBlock, TaskRepeat } from '../types';
import {
  Calendar as CalendarIcon,
  ChevronLeft,
  ChevronRight,
  Plus,
  Clock,
  Flame,
  Coffee,
  Play,
  CheckCircle2,
  X,
  Sparkles,
  Sliders,
  Trash2,
  MoveVertical,
  Repeat
} from 'lucide-react';
import { Haptics } from '../services/haptics';
import { MonthView } from '../components/calendar/MonthView';
import { YearView } from '../components/calendar/YearView';
import { formatDateToYMD, isTaskScheduledOnDate, isTaskCompletedOnDate } from '../utils/dateUtils';

const START_HOUR = 0; // 00:00 (Full 24-hour schedule)
const END_HOUR = 23; // 23:00
const HOUR_HEIGHT = 80; // pixels per hour (1.33px per minute)

type CalendarViewMode = 'day' | 'month' | 'year';

function parseTimeToMinutes(timeStr?: string): number {
  if (!timeStr) return 9 * 60;
  const [hStr, mStr] = timeStr.split(':');
  const h = parseInt(hStr, 10);
  const m = parseInt(mStr, 10);
  return (isNaN(h) ? 9 : h) * 60 + (isNaN(m) ? 0 : m);
}

function formatMinutesToTime(mins: number): string {
  const normalized = Math.max(0, Math.min(23 * 60 + 59, mins));
  const h = Math.floor(normalized / 60);
  const m = normalized % 60;
  return `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}`;
}

function formatTimeRange(startStr?: string, durationMins: number = 25): string {
  const startMin = parseTimeToMinutes(startStr);
  const endMin = startMin + durationMins;
  return `${formatMinutesToTime(startMin)} – ${formatMinutesToTime(endMin)}`;
}

interface LayoutItem {
  task: TaskBlock;
  startMin: number;
  endMin: number;
  top: number;
  height: number;
  col: number;
  totalCols: number;
  leftPercent: number;
  widthPercent: number;
  zIndex: number;
}

export const CalendarScreen: React.FC = () => {
  const { tasks, addTask, updateTask, scheduleTask, deleteTask, startRoutine, setActiveTab, toggleTaskCompleted } = useTaskStore();

  const [viewMode, setViewMode] = useState<CalendarViewMode>('day');
  const [selectedDate, setSelectedDate] = useState<Date>(new Date());
  const [activeEventModal, setActiveEventModal] = useState<TaskBlock | null>(null);
  const [isSlotModalOpen, setIsSlotModalOpen] = useState(false);
  const [selectedHourSlot, setSelectedHourSlot] = useState<string>('10:00');

  // Event modal edit state
  const [modalScheduledTime, setModalScheduledTime] = useState<string>('09:00');
  const [modalDuration, setModalDuration] = useState<number>(25);
  const [modalRepeat, setModalRepeat] = useState<TaskRepeat>('none');
  const [modalRepeatUntil, setModalRepeatUntil] = useState<string>('');
  const [hasRepeatUntil, setHasRepeatUntil] = useState<boolean>(false);

  // Drag & Drop State
  const [draggingTaskId, setDraggingTaskId] = useState<string | null>(null);
  const [dragTargetMinutes, setDragTargetMinutes] = useState<number | null>(null);
  const timelineRef = useRef<HTMLDivElement | null>(null);

  // Modal form state for adding new or selecting existing task
  const [modalMode, setModalMode] = useState<'pick-existing' | 'create-new'>('pick-existing');
  const [newTaskTitle, setNewTitle] = useState('');
  const [newTaskDuration, setNewDuration] = useState<number>(25);
  const [newType, setNewType] = useState<'focus' | 'break'>('focus');
  const [isCustomDuration, setIsCustomDuration] = useState(false);
  const [newTaskRepeat, setNewTaskRepeat] = useState<TaskRepeat>('none');
  const [newTaskRepeatUntil, setNewTaskRepeatUntil] = useState<string>('');
  const [newSlotTime, setNewSlotTime] = useState<string>('10:00');

  // Time indicator for current hour/minute
  const [currentMinutesFromMidnight, setCurrentMinutesFromMidnight] = useState<number>(() => {
    const now = new Date();
    return now.getHours() * 60 + now.getMinutes();
  });

  useEffect(() => {
    const interval = setInterval(() => {
      const now = new Date();
      setCurrentMinutesFromMidnight(now.getHours() * 60 + now.getMinutes());
    }, 30000);
    return () => clearInterval(interval);
  }, []);

  // Auto-scroll timeline to daytime/current hour on mount when in Day view
  useEffect(() => {
    if (viewMode === 'day' && timelineRef.current) {
      const now = new Date();
      const currentH = now.getHours();
      const scrollHour = currentH >= 7 && currentH <= 21 ? Math.max(0, currentH - 1) : 8;
      timelineRef.current.scrollTop = scrollHour * HOUR_HEIGHT;
    }
  }, [viewMode]);

  // Hours array for grid rendering (00:00 to 23:00)
  const hours = useMemo(() => {
    const arr: string[] = [];
    for (let h = START_HOUR; h <= END_HOUR; h++) {
      arr.push(`${h.toString().padStart(2, '0')}:${h.toString().padStart(2, '0')}`);
    }
    return arr;
  }, []);

  // 7-day week carousel
  const weekDays = useMemo(() => {
    const days = [];
    const curr = new Date(selectedDate);
    const dayOfWeek = curr.getDay(); // 0 is Sun
    const distanceToMonday = (dayOfWeek + 6) % 7;
    const monday = new Date(curr);
    monday.setDate(curr.getDate() - distanceToMonday);

    for (let i = 0; i < 7; i++) {
      const d = new Date(monday);
      d.setDate(monday.getDate() + i);
      days.push(d);
    }
    return days;
  }, [selectedDate]);

  const selectedDateStr = useMemo(() => formatDateToYMD(selectedDate), [selectedDate]);

  // Tasks scheduled strictly for the selected date (cuz tasks are for 1 day unless repeated)
  const scheduledTasks = useMemo(() => {
    return tasks
      .filter((task) => isTaskScheduledOnDate(task, selectedDateStr))
      .map((task, idx) => {
        let time = task.scheduledTime;
        if (!time) {
          const startH = 9 + Math.floor(idx * 0.75);
          const startM = (idx % 2) * 30;
          time = `${startH.toString().padStart(2, '0')}:${startM.toString().padStart(2, '0')}`;
        }
        return {
          ...task,
          scheduledTime: time,
        };
      });
  }, [tasks, selectedDateStr]);

  // Calendar layout calculation with accurate minute positioning and collision columns
  const layoutItems = useMemo<LayoutItem[]>(() => {
    if (scheduledTasks.length === 0) return [];

    // Sort chronologically: earliest start time first. If equal, longer duration first
    const sorted = [...scheduledTasks].sort((a, b) => {
      const diff = parseTimeToMinutes(a.scheduledTime) - parseTimeToMinutes(b.scheduledTime);
      if (diff !== 0) return diff;
      return b.durationMinutes - a.durationMinutes;
    });

    const items: Array<{
      task: TaskBlock;
      startMin: number;
      endMin: number;
      top: number;
      height: number;
      col: number;
    }> = [];

    // Assign columns using interval graph coloring
    for (let i = 0; i < sorted.length; i++) {
      const task = sorted[i];
      const startMin = parseTimeToMinutes(task.scheduledTime);
      const duration = Math.max(10, task.durationMinutes || 25);
      const endMin = startMin + duration;

      const top = ((startMin - START_HOUR * 60) / 60) * HOUR_HEIGHT;
      const height = Math.max(52, (duration / 60) * HOUR_HEIGHT);

      // Find all overlapping previous items
      const usedCols = new Set<number>();
      for (let j = 0; j < items.length; j++) {
        const prev = items[j];
        if (startMin < prev.endMin && prev.startMin < endMin) {
          usedCols.add(prev.col);
        }
      }

      let col = 0;
      while (usedCols.has(col)) {
        col++;
      }

      items.push({
        task,
        startMin,
        endMin,
        top,
        height,
        col,
      });
    }

    // Compute clean side-by-side column positioning
    return items.map((item) => {
      const overlapping = items.filter(
        (other) => item.startMin < other.endMin && other.startMin < item.endMin
      );
      const totalCols = Math.max(...overlapping.map((o) => o.col)) + 1;

      const colWidth = 98 / totalCols;
      const leftPercent = 1 + item.col * colWidth;
      const widthPercent = Math.max(20, colWidth - 1);
      const zIndex = 10 + item.col;

      return {
        ...item,
        totalCols,
        leftPercent,
        widthPercent,
        zIndex,
      };
    });
  }, [scheduledTasks]);

  const handleOpenSlot = (hourStr: string) => {
    setSelectedHourSlot(hourStr);
    setNewSlotTime(hourStr);
    setIsSlotModalOpen(true);
    setModalMode('pick-existing');
    setNewTaskRepeat('none');
    setNewTaskRepeatUntil('');
    Haptics.impactAsync('light');
  };

  const handleAssignExistingTask = (taskId: string) => {
    scheduleTask(taskId, newSlotTime || selectedHourSlot, selectedDateStr);
    setIsSlotModalOpen(false);
    Haptics.notificationAsync('success');
  };

  const handleCreateAndScheduleTask = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newTaskTitle.trim()) return;

    addTask({
      title: newTaskTitle.trim(),
      durationMinutes: newTaskDuration,
      type: newType,
      color: newType === 'focus' ? '#FF6B00' : '#8B5CF6',
      scheduledTime: newSlotTime || selectedHourSlot,
      date: selectedDateStr,
      repeat: newTaskRepeat,
      repeatUntil: newTaskRepeat !== 'none' && newTaskRepeatUntil ? newTaskRepeatUntil : undefined,
    });

    setIsSlotModalOpen(false);
    setNewTitle('');
    setNewDuration(25);
    setIsCustomDuration(false);
    Haptics.notificationAsync('success');
  };

  const openTaskModal = (task: TaskBlock) => {
    setActiveEventModal(task);
    setModalScheduledTime(task.scheduledTime || '09:00');
    setModalDuration(task.durationMinutes || 25);
    setModalRepeat(task.repeat || 'none');
    setModalRepeatUntil(task.repeatUntil || '');
    setHasRepeatUntil(Boolean(task.repeatUntil));
  };

  const handleStartTaskTimer = (task: TaskBlock) => {
    const idx = tasks.findIndex((t) => t.id === task.id);
    if (idx !== -1) {
      startRoutine(idx);
    } else {
      startRoutine(0);
    }
    setActiveEventModal(null);
    setActiveTab('timer');
  };

  const handleDeleteTask = (taskId: string, e?: React.MouseEvent) => {
    if (e) e.stopPropagation();
    deleteTask(taskId);
    if (activeEventModal?.id === taskId) {
      setActiveEventModal(null);
    }
    Haptics.notificationAsync('success');
  };

  // Adjust time of active modal task via quick shift steppers
  const handleShiftTaskTime = (deltaMinutes: number) => {
    if (!activeEventModal) return;
    const currentMin = parseTimeToMinutes(modalScheduledTime || activeEventModal.scheduledTime);
    const newMin = Math.max(START_HOUR * 60, Math.min((END_HOUR - 1) * 60 + 45, currentMin + deltaMinutes));
    const newTimeStr = formatMinutesToTime(newMin);
    setModalScheduledTime(newTimeStr);
    scheduleTask(activeEventModal.id, newTimeStr);
    setActiveEventModal((prev) => (prev ? { ...prev, scheduledTime: newTimeStr } : null));
    Haptics.impactAsync('light');
  };

  // Direct typed time slot
  const handleUpdateModalTime = (newTimeStr: string) => {
    if (!activeEventModal || !newTimeStr) return;
    setModalScheduledTime(newTimeStr);
    scheduleTask(activeEventModal.id, newTimeStr);
    setActiveEventModal((prev) => (prev ? { ...prev, scheduledTime: newTimeStr } : null));
  };

  // Direct typed duration
  const handleUpdateModalDuration = (newDur: number) => {
    if (!activeEventModal) return;
    const clamped = Math.max(1, Math.min(360, newDur));
    setModalDuration(clamped);
    updateTask(activeEventModal.id, { durationMinutes: clamped });
    setActiveEventModal((prev) => (prev ? { ...prev, durationMinutes: clamped } : null));
  };

  // Update repeat option
  const handleUpdateModalRepeat = (newRepeat: TaskRepeat) => {
    if (!activeEventModal) return;
    setModalRepeat(newRepeat);
    updateTask(activeEventModal.id, { repeat: newRepeat });
    setActiveEventModal((prev) => (prev ? { ...prev, repeat: newRepeat } : null));
    Haptics.selectionAsync();
  };

  // Update repeat until date
  const handleUpdateModalRepeatUntil = (newUntil: string) => {
    if (!activeEventModal) return;
    setModalRepeatUntil(newUntil);
    updateTask(activeEventModal.id, { repeatUntil: newUntil || undefined });
    setActiveEventModal((prev) => (prev ? { ...prev, repeatUntil: newUntil || undefined } : null));
  };

  // Toggle forever vs specific date
  const handleToggleRepeatForever = (forever: boolean) => {
    if (!activeEventModal) return;
    setHasRepeatUntil(!forever);
    const nextUntil = forever ? undefined : (modalRepeatUntil || formatDateToYMD(new Date(Date.now() + 30 * 86400000)));
    if (!forever && nextUntil) {
      setModalRepeatUntil(nextUntil);
    }
    updateTask(activeEventModal.id, { repeatUntil: nextUntil });
    setActiveEventModal((prev) => (prev ? { ...prev, repeatUntil: nextUntil } : null));
  };

  // Drag and drop event handlers
  const handleTimelineDragOver = (e: React.DragEvent) => {
    e.preventDefault();
    e.dataTransfer.dropEffect = 'move';
    if (!timelineRef.current) return;

    const rect = timelineRef.current.getBoundingClientRect();
    const offsetY = e.clientY - rect.top + timelineRef.current.scrollTop;
    const minutesFromStart = Math.max(0, (offsetY / HOUR_HEIGHT) * 60);

    const snapped = Math.round(minutesFromStart / 15) * 15 + START_HOUR * 60;
    const clamped = Math.max(START_HOUR * 60, Math.min((END_HOUR - 1) * 60 + 45, snapped));
    setDragTargetMinutes(clamped);
  };

  const handleTimelineDrop = (e: React.DragEvent) => {
    e.preventDefault();
    const taskId = e.dataTransfer.getData('text/plain') || draggingTaskId;
    if (taskId && dragTargetMinutes !== null) {
      const newTimeStr = formatMinutesToTime(dragTargetMinutes);
      scheduleTask(taskId, newTimeStr, selectedDateStr);
      Haptics.notificationAsync('success');
    }
    setDraggingTaskId(null);
    setDragTargetMinutes(null);
  };

  const DURATION_PRESETS = [10, 15, 25, 30, 45, 60];

  // Header Title depending on view mode
  const headerTitle = useMemo(() => {
    if (viewMode === 'year') {
      return selectedDate.getFullYear().toString();
    }
    if (viewMode === 'month') {
      return selectedDate.toLocaleDateString('en-US', { month: 'long', year: 'numeric' });
    }
    return selectedDate.toLocaleDateString('en-US', { month: 'long', year: 'numeric' });
  }, [viewMode, selectedDate]);

  // Navigate back/forward depending on view mode
  const handleNavigate = (direction: 'prev' | 'next') => {
    const delta = direction === 'next' ? 1 : -1;
    const nextD = new Date(selectedDate);

    if (viewMode === 'year') {
      nextD.setFullYear(nextD.getFullYear() + delta);
    } else if (viewMode === 'month') {
      nextD.setMonth(nextD.getMonth() + delta);
    } else {
      nextD.setDate(nextD.getDate() + delta * 7);
    }

    setSelectedDate(nextD);
    Haptics.selectionAsync();
  };

  const handleJumpToCurrent = () => {
    setSelectedDate(new Date());
    Haptics.impactAsync('light');
  };

  return (
    <div className="flex-1 flex flex-col h-full bg-[#0E0E11] text-white overflow-hidden pb-20 select-none">
      {/* Top Calendar Date Header & View Switcher */}
      <div className="bg-[#141418] border-b border-white/10 px-4 pt-2.5 pb-2.5 shrink-0">
        <div className="flex items-center justify-between mb-2">
          {/* Title with Calendar Icon */}
          <div className="flex items-center gap-2">
            <CalendarIcon className="w-5 h-5 text-[#FF6B00]" />
            <h1 className="text-base font-bold text-white tracking-tight">
              {headerTitle}
            </h1>
          </div>

          {/* View Mode Switcher: Day | Month | Year */}
          <div className="flex bg-black/60 p-0.5 rounded-xl border border-white/10 text-xs font-semibold">
            {(['day', 'month', 'year'] as CalendarViewMode[]).map((mode) => (
              <button
                key={mode}
                type="button"
                onClick={() => {
                  setViewMode(mode);
                  Haptics.selectionAsync();
                }}
                className={`px-2.5 py-1 rounded-lg capitalize transition-all ${
                  viewMode === mode
                    ? 'bg-[#FF6B00] text-black font-extrabold shadow-sm'
                    : 'text-neutral-400 hover:text-white'
                }`}
              >
                {mode}
              </button>
            ))}
          </div>

          {/* Prev / Today / Next Controls */}
          <div className="flex items-center gap-1 bg-black/40 p-0.5 rounded-xl border border-white/10">
            <button
              type="button"
              onClick={() => handleNavigate('prev')}
              className="p-1 hover:text-white text-neutral-400 rounded-lg"
              title="Previous"
            >
              <ChevronLeft className="w-4 h-4" />
            </button>
            <button
              type="button"
              onClick={handleJumpToCurrent}
              className="px-2 py-0.5 text-xs font-semibold text-neutral-300 hover:text-white"
            >
              {viewMode === 'year' ? 'This Year' : viewMode === 'month' ? 'This Month' : 'Today'}
            </button>
            <button
              type="button"
              onClick={() => handleNavigate('next')}
              className="p-1 hover:text-white text-neutral-400 rounded-lg"
              title="Next"
            >
              <ChevronRight className="w-4 h-4" />
            </button>
          </div>
        </div>

        {/* 7-Day Week Carousel Strip (Shown only in Day View) */}
        {viewMode === 'day' && (
          <div className="grid grid-cols-7 gap-1 text-center">
            {weekDays.map((d, i) => {
              const isToday = d.toDateString() === new Date().toDateString();
              const isSelected = d.toDateString() === selectedDate.toDateString();
              const dayName = d.toLocaleDateString('en-US', { weekday: 'narrow' });
              const dayNum = d.getDate();
              const dStr = formatDateToYMD(d);
              const dayHasTasks = tasks.some((t) => isTaskScheduledOnDate(t, dStr));

              return (
                <button
                  key={i}
                  type="button"
                  onClick={() => {
                    setSelectedDate(d);
                    Haptics.selectionAsync();
                  }}
                  className={`py-1.5 rounded-xl flex flex-col items-center justify-center relative transition-all ${
                    isSelected
                      ? 'bg-[#FF6B00] text-black font-extrabold shadow-md'
                      : isToday
                      ? 'bg-white/10 text-white font-bold border border-white/20'
                      : 'text-neutral-400 hover:text-white hover:bg-white/5'
                  }`}
                >
                  <span className="text-[10px] uppercase font-bold tracking-wider">{dayName}</span>
                  <span className="text-sm font-mono mt-0.5">{dayNum}</span>
                  {dayHasTasks && (
                    <span
                      className={`w-1 h-1 rounded-full mt-0.5 ${
                        isSelected ? 'bg-black' : 'bg-[#FF6B00]'
                      }`}
                    />
                  )}
                </button>
              );
            })}
          </div>
        )}
      </div>

      {/* Main View Container */}
      {viewMode === 'month' ? (
        <MonthView
          currentDate={selectedDate}
          onSelectDate={(d) => {
            setSelectedDate(d);
            setViewMode('day');
          }}
          tasks={tasks}
        />
      ) : viewMode === 'year' ? (
        <YearView
          currentYear={selectedDate.getFullYear()}
          onSelectMonth={(mIdx) => {
            setSelectedDate(new Date(selectedDate.getFullYear(), mIdx, 1));
            setViewMode('month');
          }}
          onSelectDate={(d) => {
            setSelectedDate(d);
            setViewMode('day');
          }}
          tasks={tasks}
        />
      ) : (
        /* Day View Continuous Timeline with Overlapping Columns */
        <div
          ref={timelineRef}
          onDragOver={handleTimelineDragOver}
          onDrop={handleTimelineDrop}
          className="flex-1 overflow-y-auto relative px-2.5 pt-2"
          style={{ scrollBehavior: 'smooth' }}
        >
          {/* Blank view notice if no tasks are scheduled for this selected day */}
          {layoutItems.length === 0 && (
            <div className="sticky top-2 z-20 mb-3 mx-auto max-w-sm px-3.5 py-2 rounded-xl bg-[#1A1A22]/90 border border-white/10 backdrop-blur-md flex items-center justify-between text-xs text-neutral-300 shadow-md">
              <span className="text-neutral-400">
                Blank view for {selectedDate.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}
              </span>
              <button
                type="button"
                onClick={() => handleOpenSlot('10:00')}
                className="text-[11px] font-bold text-[#FF6B00] hover:underline flex items-center gap-1"
              >
                <Plus className="w-3.5 h-3.5" />
                Schedule Block
              </button>
            </div>
          )}

          {/* Current Time Red Bar Indicator */}
          {selectedDate.toDateString() === new Date().toDateString() &&
            currentMinutesFromMidnight >= START_HOUR * 60 &&
            currentMinutesFromMidnight <= (END_HOUR + 1) * 60 && (
              <div
                className="absolute inset-x-0 z-30 flex items-center pointer-events-none"
                style={{
                  top: `${((currentMinutesFromMidnight - START_HOUR * 60) / 60) * HOUR_HEIGHT + 8}px`,
                }}
              >
                <div className="w-2.5 h-2.5 rounded-full bg-red-500 shadow-[0_0_8px_rgba(239,68,68,0.9)] ml-11 -mr-1 animate-ping" />
                <div className="w-2 h-2 rounded-full bg-red-500 ml-11 -mr-1" />
                <div className="flex-1 h-[1.5px] bg-red-500 shadow-[0_0_8px_rgba(239,68,68,0.7)]" />
                <span className="text-[9px] font-mono text-red-400 bg-black/80 px-1 py-0.5 rounded mr-2 ml-1">
                  {formatMinutesToTime(currentMinutesFromMidnight)}
                </span>
              </div>
            )}

          {/* Live Drag-and-Drop Indicator Line & Badge */}
          {draggingTaskId && dragTargetMinutes !== null && (
            <div
              className="absolute inset-x-0 z-40 flex items-center pointer-events-none transition-all duration-75"
              style={{
                top: `${((dragTargetMinutes - START_HOUR * 60) / 60) * HOUR_HEIGHT + 8}px`,
              }}
            >
              <div className="w-2.5 h-2.5 rounded-full bg-[#FF6B00] ml-11 -mr-1 shadow-[0_0_10px_rgba(255,107,0,1)]" />
              <div className="flex-1 h-[2px] bg-[#FF6B00] shadow-[0_0_8px_rgba(255,107,0,0.8)]" />
              <span className="text-[10px] font-mono font-bold text-black bg-[#FF6B00] px-2 py-0.5 rounded-full mr-2 ml-1 shadow-md animate-pulse">
                Reschedule to {formatMinutesToTime(dragTargetMinutes)}
              </span>
            </div>
          )}

          {/* Outer Grid Layout: Left Hours + Right Events Canvas */}
          <div className="flex relative">
            {/* Left Time Column (Labels) */}
            <div className="w-11 shrink-0 select-none">
              {hours.map((hourStr) => (
                <div
                  key={hourStr}
                  style={{ height: `${HOUR_HEIGHT}px` }}
                  className="pt-0 text-right pr-2"
                >
                  <span className="text-[11px] font-mono font-medium text-neutral-500 block -translate-y-2">
                    {hourStr}
                  </span>
                </div>
              ))}
            </div>

            {/* Right Continuous Timeline Stage */}
            <div
              className="flex-1 relative border-l border-white/[0.08]"
              style={{ height: `${hours.length * HOUR_HEIGHT}px` }}
            >
              {/* Background Grid Dividing Lines */}
              {hours.map((hourStr, idx) => (
                <div
                  key={hourStr}
                  onClick={() => handleOpenSlot(hourStr)}
                  style={{
                    top: `${idx * HOUR_HEIGHT}px`,
                    height: `${HOUR_HEIGHT}px`,
                  }}
                  className="absolute inset-x-0 border-b border-white/[0.06] hover:bg-white/[0.02] cursor-pointer transition-colors group"
                >
                  {/* Subtle Half-Hour Dashed Guide */}
                  <div className="absolute inset-x-0 top-1/2 border-b border-white/[0.03] border-dashed pointer-events-none" />

                  {/* Quick Add Hint on Empty Hover */}
                  <div className="opacity-0 group-hover:opacity-60 flex items-center gap-1.5 text-[11px] text-neutral-400 pl-3 pt-1 transition-opacity">
                    <Plus className="w-3 h-3 text-[#FF6B00]" />
                    <span>Schedule at {hourStr}</span>
                  </div>
                </div>
              ))}

              {/* Positioned Event Blocks */}
              {layoutItems.map((item) => {
                const { task, top, height, leftPercent, widthPercent, zIndex } = item;
                const isFocus = task.type === 'focus';
                const isBeingDragged = draggingTaskId === task.id;
                const isDone = isTaskCompletedOnDate(task, selectedDateStr);

                return (
                  <div
                    key={task.id}
                    draggable
                    onDragStart={(e) => {
                      e.dataTransfer.setData('text/plain', task.id);
                      setDraggingTaskId(task.id);
                      Haptics.impactAsync('light');
                    }}
                    onDragEnd={() => {
                      setDraggingTaskId(null);
                      setDragTargetMinutes(null);
                    }}
                    onClick={(e) => {
                      e.stopPropagation();
                      openTaskModal(task);
                      Haptics.impactAsync('medium');
                    }}
                    style={{
                      top: `${top}px`,
                      height: `${height}px`,
                      left: `${leftPercent}%`,
                      width: `${widthPercent}%`,
                      zIndex: isBeingDragged ? 50 : zIndex,
                    }}
                    className={`absolute rounded-2xl p-2.5 cursor-pointer transition-all duration-150 flex flex-col justify-between select-none overflow-hidden ${
                      isBeingDragged
                        ? 'opacity-40 scale-95 ring-2 ring-[#FF6B00]'
                        : 'hover:brightness-110 active:scale-[0.99]'
                    } ${
                      isDone
                        ? 'bg-[#121216]/90 border border-emerald-500/30 text-neutral-300 opacity-75'
                        : isFocus
                        ? 'bg-[#1C120B] border border-[#FF6B00]/50 text-white shadow-[0_4px_16px_rgba(0,0,0,0.6)]'
                        : 'bg-[#181124] border border-purple-500/50 text-white shadow-[0_4px_16px_rgba(0,0,0,0.6)]'
                    }`}
                  >
                    {/* Top Bar: Color Bar Pill & Title */}
                    <div className="flex items-start justify-between gap-1.5 min-w-0">
                      <div className="flex items-start gap-2 min-w-0 flex-1">
                        {/* Accent Vertical Indicator Bar */}
                        <div
                          className={`w-1 rounded-full shrink-0 my-0.5 self-stretch min-h-[20px] ${
                            isDone ? 'bg-emerald-500' : isFocus ? 'bg-[#FF6B00]' : 'bg-purple-400'
                          }`}
                        />

                        <div className="min-w-0 flex-1 overflow-hidden">
                          <div className="flex items-center gap-1.5 justify-between">
                            <h4
                              className={`font-bold text-xs truncate leading-tight ${
                                isDone ? 'line-through text-neutral-400 font-medium' : 'text-white'
                              }`}
                            >
                              {task.title}
                            </h4>
                            {isDone && (
                              <CheckCircle2 className="w-3.5 h-3.5 text-emerald-400 shrink-0" />
                            )}
                          </div>
                          <div className="flex items-center gap-1.5 text-[10px] text-neutral-300 font-mono mt-0.5 truncate">
                            <Clock className="w-2.5 h-2.5 text-neutral-400 shrink-0" />
                            <span className="truncate">
                              {formatTimeRange(task.scheduledTime, task.durationMinutes)}
                            </span>
                            <span className="text-neutral-400 shrink-0">• {task.durationMinutes}m</span>
                            {task.repeat && task.repeat !== 'none' && (
                              <span className="text-[#FF6B00] text-[9px] font-bold uppercase shrink-0">
                                • {task.repeat}
                              </span>
                            )}
                          </div>
                        </div>
                      </div>
                    </div>

                    {/* Bottom Status Row for larger items */}
                    {height >= 68 && (
                      <div className="flex items-center justify-between mt-1 pt-1 border-t border-white/5 text-[9px] text-neutral-400 font-mono">
                        <span className="truncate capitalize">{task.type} Block</span>
                        <span className="text-[#FF6B00] font-bold">Tap to edit</span>
                      </div>
                    )}
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      )}

      {/* Floating Action Button (FAB) to Add / Schedule */}
      <button
        type="button"
        onClick={() => handleOpenSlot('10:00')}
        className="absolute bottom-20 right-5 z-30 w-12 h-12 rounded-full bg-[#FF6B00] hover:bg-[#FF8533] text-black font-extrabold flex items-center justify-center shadow-[0_8px_25px_rgba(255,107,0,0.5)] active:scale-95 transition-all"
        title="Schedule Task on Calendar"
      >
        <Plus className="w-6 h-6 stroke-[3]" />
      </button>

      {/* Modal 1: Tap Slot -> Assign Existing Task or Create New Task Block */}
      {isSlotModalOpen && (
        <div
          className="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm flex items-end sm:items-center justify-center p-0 sm:p-4 animate-in fade-in duration-200"
          onClick={() => setIsSlotModalOpen(false)}
        >
          <div
            className="w-full sm:max-w-md bg-[#16161A] text-white rounded-t-3xl sm:rounded-3xl p-5 border border-white/15 shadow-2xl animate-in slide-in-from-bottom duration-200 max-h-[90vh] overflow-y-auto"
            onClick={(e) => e.stopPropagation()}
          >
            {/* Modal Header */}
            <div className="flex items-center justify-between pb-3 border-b border-white/10">
              <div className="flex items-center gap-2">
                <Clock className="w-4 h-4 text-[#FF6B00]" />
                <h3 className="font-bold text-sm text-white">
                  Schedule Task on {selectedDate.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}
                </h3>
              </div>
              <button
                type="button"
                onClick={() => setIsSlotModalOpen(false)}
                className="p-1 text-neutral-400 hover:text-white rounded-lg"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            {/* Mode Switcher Tabs */}
            <div className="flex bg-black/50 p-1 rounded-xl border border-white/10 my-3 text-xs">
              <button
                type="button"
                onClick={() => setModalMode('pick-existing')}
                className={`flex-1 py-1.5 rounded-lg font-bold transition-colors ${
                  modalMode === 'pick-existing'
                    ? 'bg-white text-black shadow-sm'
                    : 'text-neutral-400 hover:text-white'
                }`}
              >
                From Tasks Queue ({tasks.length})
              </button>
              <button
                type="button"
                onClick={() => setModalMode('create-new')}
                className={`flex-1 py-1.5 rounded-lg font-bold transition-colors ${
                  modalMode === 'create-new'
                    ? 'bg-[#FF6B00] text-black shadow-sm'
                    : 'text-neutral-400 hover:text-white'
                }`}
              >
                Create New Block
              </button>
            </div>

            {/* Tab 1: Pick from Tasks Queue */}
            {modalMode === 'pick-existing' && (
              <div className="space-y-2 max-h-60 overflow-y-auto pr-1">
                <div className="flex items-center justify-between mb-2">
                  <span className="text-[11px] text-neutral-400">Target Time Slot:</span>
                  <input
                    type="time"
                    value={newSlotTime}
                    onChange={(e) => setNewSlotTime(e.target.value)}
                    className="px-2 py-1 rounded-lg bg-black/60 border border-white/20 text-white font-mono text-xs"
                  />
                </div>
                {tasks.map((task) => (
                  <div
                    key={task.id}
                    onClick={() => handleAssignExistingTask(task.id)}
                    className="p-3 rounded-2xl bg-black/40 hover:bg-white/10 border border-white/10 cursor-pointer flex items-center justify-between transition-colors group"
                  >
                    <div className="flex items-center gap-2.5 min-w-0">
                      <div
                        className={`w-7 h-7 rounded-xl flex items-center justify-center shrink-0 ${
                          task.type === 'focus'
                            ? 'bg-[#FF6B00]/20 text-[#FF6B00]'
                            : 'bg-purple-500/20 text-purple-300'
                        }`}
                      >
                        {task.type === 'focus' ? <Flame className="w-4 h-4" /> : <Coffee className="w-4 h-4" />}
                      </div>
                      <div className="min-w-0">
                        <span className="text-xs font-bold text-white truncate block">
                          {task.title}
                        </span>
                        <span className="text-[10px] text-neutral-400 font-mono">
                          {task.durationMinutes}m duration • {task.type.toUpperCase()}
                        </span>
                      </div>
                    </div>

                    <div className="flex items-center gap-1.5">
                      <button
                        type="button"
                        onClick={(e) => handleDeleteTask(task.id, e)}
                        className="p-1.5 rounded-xl hover:bg-red-500/20 text-neutral-500 hover:text-red-400 transition-colors"
                        title="Delete Task"
                      >
                        <Trash2 className="w-3.5 h-3.5" />
                      </button>
                      <button
                        type="button"
                        className="px-2.5 py-1 rounded-xl bg-white/10 group-hover:bg-white text-white group-hover:text-black text-xs font-semibold"
                      >
                        Schedule
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            )}

            {/* Tab 2: Create New Block Form */}
            {modalMode === 'create-new' && (
              <form onSubmit={handleCreateAndScheduleTask} className="space-y-3 pt-1">
                <div className="flex items-center justify-between">
                  <span className="text-xs text-neutral-400 font-semibold">Block Type:</span>
                  <div className="flex bg-black/40 p-0.5 rounded-xl border border-white/10 text-xs">
                    <button
                      type="button"
                      onClick={() => setNewType('focus')}
                      className={`px-3 py-1 rounded-lg font-bold transition-colors ${
                        newType === 'focus' ? 'bg-[#FF6B00] text-black' : 'text-neutral-400 hover:text-white'
                      }`}
                    >
                      Focus
                    </button>
                    <button
                      type="button"
                      onClick={() => setNewType('break')}
                      className={`px-3 py-1 rounded-lg font-bold transition-colors ${
                        newType === 'break' ? 'bg-purple-600 text-white' : 'text-neutral-400 hover:text-white'
                      }`}
                    >
                      Break
                    </button>
                  </div>
                </div>

                <input
                  type="text"
                  required
                  value={newTaskTitle}
                  onChange={(e) => setNewTitle(e.target.value)}
                  placeholder="Task title (e.g., Learn Python Backend)"
                  className="w-full px-3.5 py-2 rounded-xl bg-black/60 border border-white/15 text-sm text-white focus:outline-hidden focus:border-[#FF6B00]"
                />

                {/* Time Slot Input */}
                <div className="flex items-center justify-between">
                  <span className="text-xs text-neutral-400 font-semibold">Start Time:</span>
                  <input
                    type="time"
                    value={newSlotTime}
                    onChange={(e) => setNewSlotTime(e.target.value)}
                    className="px-3 py-1.5 rounded-xl bg-black/60 border border-white/15 text-white font-mono font-bold text-xs focus:outline-hidden focus:border-[#FF6B00]"
                  />
                </div>

                {/* Duration Picker */}
                <div className="space-y-2">
                  <div className="flex items-center justify-between text-[11px] text-neutral-400 font-semibold">
                    <span>Duration:</span>
                    <button
                      type="button"
                      onClick={() => setIsCustomDuration(!isCustomDuration)}
                      className="text-[#FF6B00] hover:underline flex items-center gap-1"
                    >
                      <Sliders className="w-3 h-3" />
                      <span>{isCustomDuration ? 'Quick Presets' : 'Custom Minutes'}</span>
                    </button>
                  </div>

                  {!isCustomDuration ? (
                    <div className="flex flex-wrap gap-1.5">
                      {DURATION_PRESETS.map((mins) => (
                        <button
                          key={mins}
                          type="button"
                          onClick={() => setNewDuration(mins)}
                          className={`px-3 py-1 rounded-xl text-xs font-mono font-bold border transition-colors ${
                            newTaskDuration === mins
                              ? 'bg-white text-black border-white'
                              : 'bg-white/5 border-white/10 text-neutral-300 hover:bg-white/10'
                          }`}
                        >
                          {mins}m
                        </button>
                      ))}
                    </div>
                  ) : (
                    <div className="flex items-center justify-between gap-3 p-2 bg-black/40 rounded-xl border border-white/10">
                      <button
                        type="button"
                        onClick={() => setNewDuration(Math.max(1, newTaskDuration - 5))}
                        className="w-7 h-7 rounded-lg bg-white/10 text-white font-mono text-xs"
                      >
                        -5
                      </button>
                      <div className="flex items-center gap-1">
                        <input
                          type="number"
                          min={1}
                          max={360}
                          value={newTaskDuration}
                          onChange={(e) => setNewDuration(Math.max(1, parseInt(e.target.value) || 1))}
                          className="w-16 px-2 py-0.5 bg-white/10 border border-white/20 rounded-lg text-center font-mono font-bold text-white text-sm focus:outline-hidden"
                        />
                        <span className="text-xs font-mono text-neutral-400">min</span>
                      </div>
                      <button
                        type="button"
                        onClick={() => setNewDuration(newTaskDuration + 5)}
                        className="w-7 h-7 rounded-lg bg-white/10 text-white font-mono text-xs"
                      >
                        +5
                      </button>
                    </div>
                  )}
                </div>

                {/* Recurrence setting */}
                <div className="space-y-1.5 pt-2 border-t border-white/10">
                  <span className="text-xs text-neutral-400 font-semibold flex items-center gap-1">
                    <Repeat className="w-3 h-3 text-[#FF6B00]" />
                    Repeat:
                  </span>
                  <div className="grid grid-cols-4 gap-1 text-xs">
                    {[
                      { id: 'none', label: '1 Day' },
                      { id: 'daily', label: 'Daily' },
                      { id: 'weekly', label: 'Weekly' },
                      { id: 'monthly', label: 'Monthly' },
                    ].map((opt) => (
                      <button
                        key={opt.id}
                        type="button"
                        onClick={() => setNewTaskRepeat(opt.id as TaskRepeat)}
                        className={`py-1 px-1 rounded-xl font-bold transition-all text-center ${
                          newTaskRepeat === opt.id
                            ? 'bg-[#FF6B00] text-black'
                            : 'bg-white/5 text-neutral-400 hover:bg-white/10'
                        }`}
                      >
                        {opt.label}
                      </button>
                    ))}
                  </div>

                  {newTaskRepeat !== 'none' && (
                    <div className="pt-2 flex items-center justify-between text-xs">
                      <span className="text-neutral-400 text-[11px]">Repeat until:</span>
                      <input
                        type="date"
                        min={selectedDateStr}
                        value={newTaskRepeatUntil}
                        onChange={(e) => setNewTaskRepeatUntil(e.target.value)}
                        className="px-2 py-1 rounded-lg bg-black/60 border border-white/15 text-white font-mono text-xs"
                      />
                    </div>
                  )}
                </div>

                {/* Confirm Button */}
                <button
                  type="submit"
                  id="confirm-calendar-block-btn"
                  className="w-full mt-2 py-3 px-4 rounded-2xl bg-gradient-to-r from-[#FF6B00] via-[#FF8533] to-[#FF6B00] text-black font-extrabold text-sm flex items-center justify-center gap-2 shadow-lg hover:brightness-110 active:scale-[0.98] transition-all cursor-pointer"
                >
                  <CheckCircle2 className="w-4 h-4 stroke-[2.5]" />
                  <span>Confirm Block</span>
                </button>
              </form>
            )}
          </div>
        </div>
      )}

      {/* Modal 2: Event Details, User Custom Time Slot Typing, Recurrence & Actions */}
      {activeEventModal && (
        <div
          className="fixed inset-0 z-50 bg-black/80 backdrop-blur-sm flex items-center justify-center p-4 animate-in fade-in duration-200"
          onClick={() => setActiveEventModal(null)}
        >
          <div
            className="w-full max-w-sm bg-[#18181E] text-white rounded-3xl p-5 border border-white/20 shadow-2xl animate-in zoom-in-95 duration-200 max-h-[92vh] overflow-y-auto"
            onClick={(e) => e.stopPropagation()}
          >
            {/* Header */}
            <div className="flex items-center justify-between pb-2 border-b border-white/10">
              <span
                className={`text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-full ${
                  activeEventModal.type === 'focus'
                    ? 'bg-[#FF6B00]/20 text-[#FF6B00]'
                    : 'bg-purple-500/20 text-purple-300'
                }`}
              >
                {activeEventModal.type === 'focus' ? 'Deep Focus Block' : 'Break Block'}
              </span>
              <button
                type="button"
                onClick={() => setActiveEventModal(null)}
                className="p-1 text-neutral-400 hover:text-white"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <h3 className="text-lg font-bold text-white mt-3">
              {activeEventModal.title}
            </h3>

            {/* Time summary range */}
            <div className="flex items-center gap-2 text-xs font-mono text-neutral-400 mt-2">
              <span className="flex items-center gap-1 text-white font-bold">
                <Clock className="w-3.5 h-3.5 text-[#FF6B00]" />
                {formatTimeRange(modalScheduledTime, modalDuration)}
              </span>
              <span>•</span>
              <span>{modalDuration} Minutes</span>
            </div>

            {/* Editable Time Slot Inputs (Image 2 Requirement: Type the timeslot) */}
            <div className="mt-4 pt-3 border-t border-white/10 space-y-2.5">
              <div className="flex items-center justify-between">
                <span className="text-[11px] font-semibold text-neutral-300 flex items-center gap-1">
                  <Clock className="w-3 h-3 text-[#FF6B00]" />
                  Custom Time Slot:
                </span>
                <span className="text-[10px] text-neutral-500 font-mono">Type exact start & duration</span>
              </div>

              <div className="grid grid-cols-2 gap-2">
                {/* Start Time input */}
                <div>
                  <label className="text-[10px] uppercase font-bold text-neutral-400 block mb-1">
                    Start Time
                  </label>
                  <input
                    type="time"
                    value={modalScheduledTime}
                    onChange={(e) => handleUpdateModalTime(e.target.value)}
                    className="w-full px-3 py-1.5 rounded-xl bg-black/60 border border-white/15 text-white font-mono font-bold text-sm focus:outline-hidden focus:border-[#FF6B00]"
                  />
                </div>

                {/* Duration input */}
                <div>
                  <label className="text-[10px] uppercase font-bold text-neutral-400 block mb-1">
                    Duration (min)
                  </label>
                  <input
                    type="number"
                    min={5}
                    max={360}
                    value={modalDuration}
                    onChange={(e) => handleUpdateModalDuration(parseInt(e.target.value, 10) || 1)}
                    className="w-full px-3 py-1.5 rounded-xl bg-black/60 border border-white/15 text-white font-mono font-bold text-sm focus:outline-hidden focus:border-[#FF6B00]"
                  />
                </div>
              </div>
            </div>

            {/* Quick Reschedule Steppers */}
            <div className="mt-3 pt-3 border-t border-white/10">
              <span className="text-[11px] font-semibold text-neutral-400 flex items-center gap-1 mb-2">
                <MoveVertical className="w-3 h-3 text-[#FF6B00]" />
                Shift / Reschedule Time:
              </span>
              <div className="grid grid-cols-4 gap-1.5">
                <button
                  type="button"
                  onClick={() => handleShiftTaskTime(-30)}
                  className="py-1.5 rounded-xl bg-white/5 hover:bg-white/10 text-neutral-300 text-xs font-mono font-bold"
                >
                  -30m
                </button>
                <button
                  type="button"
                  onClick={() => handleShiftTaskTime(-15)}
                  className="py-1.5 rounded-xl bg-white/5 hover:bg-white/10 text-neutral-300 text-xs font-mono font-bold"
                >
                  -15m
                </button>
                <button
                  type="button"
                  onClick={() => handleShiftTaskTime(15)}
                  className="py-1.5 rounded-xl bg-white/5 hover:bg-white/10 text-neutral-300 text-xs font-mono font-bold"
                >
                  +15m
                </button>
                <button
                  type="button"
                  onClick={() => handleShiftTaskTime(30)}
                  className="py-1.5 rounded-xl bg-white/5 hover:bg-white/10 text-neutral-300 text-xs font-mono font-bold"
                >
                  +30m
                </button>
              </div>
            </div>

            {/* Recurrence Settings: Repeat Everyday, Every Month, Repeat Till When */}
            <div className="mt-3 pt-3 border-t border-white/10 space-y-2">
              <span className="text-[11px] font-semibold text-neutral-300 flex items-center gap-1">
                <Repeat className="w-3 h-3 text-[#FF6B00]" />
                Repeat / Recurrence:
              </span>

              {/* Cadence options */}
              <div className="grid grid-cols-4 gap-1.5">
                {[
                  { id: 'none', label: '1 Day' },
                  { id: 'daily', label: 'Daily' },
                  { id: 'weekly', label: 'Weekly' },
                  { id: 'monthly', label: 'Monthly' },
                ].map((opt) => (
                  <button
                    key={opt.id}
                    type="button"
                    onClick={() => handleUpdateModalRepeat(opt.id as TaskRepeat)}
                    className={`py-1.5 px-2 rounded-xl text-xs font-bold transition-all ${
                      modalRepeat === opt.id
                        ? 'bg-[#FF6B00] text-black font-extrabold shadow-sm'
                        : 'bg-white/5 text-neutral-300 hover:bg-white/10'
                    }`}
                  >
                    {opt.label}
                  </button>
                ))}
              </div>

              {/* Repeat until date if repeating */}
              {modalRepeat !== 'none' && (
                <div className="p-2.5 rounded-xl bg-black/40 border border-white/10 space-y-2 mt-2">
                  <div className="flex items-center justify-between">
                    <span className="text-[11px] font-medium text-neutral-300">Repeat until:</span>
                    <div className="flex items-center gap-1.5">
                      <button
                        type="button"
                        onClick={() => handleToggleRepeatForever(true)}
                        className={`text-[10px] font-bold px-2 py-0.5 rounded-md ${
                          !hasRepeatUntil ? 'bg-white/20 text-white' : 'text-neutral-500 hover:text-white'
                        }`}
                      >
                        Forever
                      </button>
                      <button
                        type="button"
                        onClick={() => handleToggleRepeatForever(false)}
                        className={`text-[10px] font-bold px-2 py-0.5 rounded-md ${
                          hasRepeatUntil ? 'bg-[#FF6B00]/20 text-[#FF6B00]' : 'text-neutral-500 hover:text-white'
                        }`}
                      >
                        Date
                      </button>
                    </div>
                  </div>

                  {hasRepeatUntil && (
                    <input
                      type="date"
                      min={selectedDateStr}
                      value={modalRepeatUntil}
                      onChange={(e) => handleUpdateModalRepeatUntil(e.target.value)}
                      className="w-full px-3 py-1.5 rounded-xl bg-black/60 border border-white/15 text-white font-mono text-xs focus:outline-hidden focus:border-[#FF6B00]"
                    />
                  )}
                </div>
              )}
            </div>

            {/* Mark as Done Toggle */}
            <div className="mt-3 pt-3 border-t border-white/10">
              {(() => {
                const isModalDone = isTaskCompletedOnDate(activeEventModal, selectedDateStr);
                return (
                  <button
                    type="button"
                    onClick={() => {
                      toggleTaskCompleted(activeEventModal.id, selectedDateStr);
                      Haptics.notificationAsync(isModalDone ? 'warning' : 'success');
                    }}
                    className={`w-full py-2 px-3 rounded-xl flex items-center justify-center gap-2 text-xs font-bold transition-all border ${
                      isModalDone
                        ? 'bg-emerald-500/20 border-emerald-500/40 text-emerald-300 hover:bg-emerald-500/30'
                        : 'bg-white/5 border-white/10 text-neutral-300 hover:bg-white/10 hover:text-white'
                    }`}
                  >
                    <CheckCircle2 className={`w-3.5 h-3.5 ${isModalDone ? 'text-emerald-400' : 'text-neutral-400'}`} />
                    <span>{isModalDone ? 'Marked as Done (Click to Undo)' : 'Mark as Done for this day'}</span>
                  </button>
                );
              })()}
            </div>

            {/* Actions: Start Timer or Delete Task */}
            <div className="mt-4 flex items-center gap-2">
              <button
                type="button"
                onClick={() => handleStartTaskTimer(activeEventModal)}
                className="flex-1 py-3 px-4 rounded-2xl bg-white text-black font-extrabold text-xs tracking-wide flex items-center justify-center gap-1.5 shadow-lg hover:bg-neutral-200 active:scale-95 transition-all"
              >
                <Play className="w-3.5 h-3.5 fill-current" />
                <span>Start Timer</span>
              </button>

              <button
                type="button"
                onClick={() => handleDeleteTask(activeEventModal.id)}
                className="py-3 px-4 rounded-2xl bg-red-500/15 hover:bg-red-500/25 text-red-400 border border-red-500/30 font-bold text-xs flex items-center justify-center gap-1.5 active:scale-95 transition-all"
                title="Delete task from calendar and tasks queue"
              >
                <Trash2 className="w-3.5 h-3.5" />
                <span>Delete</span>
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
