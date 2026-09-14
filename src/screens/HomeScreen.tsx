import React, { useState, useMemo } from 'react';
import { useTaskStore } from '../store/useTaskStore';
import { TaskItem } from '../components/TaskItem';
import {
  Plus,
  Clock,
  Sparkles,
  Coffee,
  Flame,
  AlertTriangle,
  CheckCircle2,
  Calendar,
  X,
  Sliders,
  ChevronLeft,
  ChevronRight,
  Repeat,
} from 'lucide-react';
import { Haptics } from '../services/haptics';
import { TaskRepeat } from '../types';
import {
  formatDateToYMD,
  getTodayDateString,
  isTaskScheduledOnDate,
  isTaskCompletedOnDate,
} from '../utils/dateUtils';

export const HomeScreen: React.FC = () => {
  const {
    tasks,
    activeTaskIndex,
    startRoutine,
    addTask,
    updateTask,
    deleteTask,
    reorderTasks,
    toggleTaskCompleted,
    setActiveTab,
    triggerFastTestTransition,
    resetRoutine,
    timerStatus,
  } = useTaskStore();

  // Date navigation state
  const [selectedDate, setSelectedDate] = useState<Date>(new Date());
  const selectedDateStr = useMemo(() => formatDateToYMD(selectedDate), [selectedDate]);
  const todayStr = getTodayDateString();
  const isToday = selectedDateStr === todayStr;

  const handleNavigateDate = (offsetDays: number) => {
    const next = new Date(selectedDate);
    next.setDate(next.getDate() + offsetDays);
    setSelectedDate(next);
    Haptics.selectionAsync();
  };

  const dateDisplayText = useMemo(() => {
    if (isToday) {
      return `Today, ${selectedDate.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}`;
    }
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    if (selectedDateStr === formatDateToYMD(yesterday)) {
      return `Yesterday, ${selectedDate.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}`;
    }
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    if (selectedDateStr === formatDateToYMD(tomorrow)) {
      return `Tomorrow, ${selectedDate.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}`;
    }
    return selectedDate.toLocaleDateString('en-US', {
      weekday: 'short',
      month: 'short',
      day: 'numeric',
    });
  }, [selectedDate, isToday, selectedDateStr]);

  // Tasks scheduled for the chosen date
  const dateTasks = useMemo(() => {
    return tasks.filter((t) => isTaskScheduledOnDate(t, selectedDateStr));
  }, [tasks, selectedDateStr]);

  const [isAddingTask, setIsAddingTask] = useState(false);
  const [newTitle, setNewTitle] = useState('');
  const [newDuration, setNewDuration] = useState<number>(25);
  const [isCustomMode, setIsCustomMode] = useState(false);
  const [newScheduledTime, setNewScheduledTime] = useState('10:00');
  const [newType, setNewType] = useState<'focus' | 'break'>('focus');
  const [newRepeat, setNewRepeat] = useState<TaskRepeat>('none');
  const [hasRepeatUntil, setHasRepeatUntil] = useState(false);
  const [newRepeatUntil, setNewRepeatUntil] = useState('');

  // Drag and drop state for tasks
  const [draggedIndex, setDraggedIndex] = useState<number | null>(null);
  const [dragOverIndex, setDragOverIndex] = useState<number | null>(null);

  // Compute statistics for the selected day's tasks
  const focusMinutes = dateTasks.filter((t) => t.type === 'focus').reduce((acc, t) => acc + t.durationMinutes, 0);
  const breakMinutes = dateTasks.filter((t) => t.type === 'break').reduce((acc, t) => acc + t.durationMinutes, 0);

  // Day progression statistics
  const completedTasksCount = useMemo(() => {
    return dateTasks.filter((t) => isTaskCompletedOnDate(t, selectedDateStr)).length;
  }, [dateTasks, selectedDateStr]);

  const totalTasksCount = dateTasks.length;
  const progressPercent = totalTasksCount > 0
    ? Math.round((completedTasksCount / totalTasksCount) * 100)
    : 0;

  const completedFocusMinutes = useMemo(() => {
    return dateTasks
      .filter((t) => t.type === 'focus' && isTaskCompletedOnDate(t, selectedDateStr))
      .reduce((acc, t) => acc + t.durationMinutes, 0);
  }, [dateTasks, selectedDateStr]);

  const DURATION_PRESETS = [5, 10, 15, 25, 30, 45, 60];

  const handleCreateTask = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newTitle.trim()) return;

    const validatedDuration = Math.max(1, Math.min(360, Number(newDuration) || 25));

    addTask({
      title: newTitle.trim(),
      durationMinutes: validatedDuration,
      type: newType,
      color: newType === 'focus' ? '#FF6B00' : '#8B5CF6',
      scheduledTime: newScheduledTime || undefined,
      date: selectedDateStr,
      repeat: newRepeat,
      repeatUntil: newRepeat !== 'none' && hasRepeatUntil && newRepeatUntil ? newRepeatUntil : undefined,
    });

    Haptics.notificationAsync('success');
    setNewTitle('');
    setNewDuration(25);
    setIsCustomMode(false);
    setNewRepeat('none');
    setHasRepeatUntil(false);
    setNewRepeatUntil('');
    setIsAddingTask(false);
  };

  const handleMoveUp = (index: number) => {
    if (index > 0) reorderTasks(index, index - 1);
  };

  const handleMoveDown = (index: number) => {
    if (index < tasks.length - 1) reorderTasks(index, index + 1);
  };

  const handleDragStartTask = (index: number) => {
    setDraggedIndex(index);
    Haptics.impactAsync('light');
  };

  const handleDragOverTask = (e: React.DragEvent, index: number) => {
    e.preventDefault();
    e.dataTransfer.dropEffect = 'move';
    if (dragOverIndex !== index) {
      setDragOverIndex(index);
    }
  };

  const handleDropTask = (targetIndex: number) => {
    if (draggedIndex !== null && draggedIndex !== targetIndex) {
      reorderTasks(draggedIndex, targetIndex);
      Haptics.notificationAsync('success');
    }
    setDraggedIndex(null);
    setDragOverIndex(null);
  };

  const handleDragEndTask = () => {
    setDraggedIndex(null);
    setDragOverIndex(null);
  };

  return (
    <div className="flex-1 flex flex-col h-full bg-[#0E0E11] text-white overflow-y-auto px-4 pt-2 pb-24">
      {/* Header with App Concept & Focus/Break Stats */}
      <div className="mb-4">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-black tracking-tight text-white flex items-center gap-2">
              SnapFocus
              <span className="text-[11px] font-mono font-semibold px-2 py-0.5 rounded-full bg-[#FF6B00]/20 text-[#FF6B00] border border-[#FF6B00]/30">
                Tasks
              </span>
            </h1>
          </div>

          <button
            type="button"
            id="test-break-alarm-btn"
            onClick={triggerFastTestTransition}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-red-500/15 hover:bg-red-500/25 text-red-300 border border-red-500/30 text-xs font-semibold active:scale-95 transition-all shadow-sm"
            title="Immediately triggers the Break Ends Alarm & Photo Lock for testing"
          >
            <AlertTriangle className="w-3.5 h-3.5 text-red-400 animate-pulse" />
            <span>Test Alarm</span>
          </button>
        </div>

        {/* Focus and Break Summary Stat Cards */}
        <div className="grid grid-cols-2 gap-2 mt-3.5">
          <div className="bg-[#16161A] p-2.5 rounded-2xl border border-white/[0.08] flex flex-col">
            <div className="flex items-center gap-1.5 text-[#FF6B00] text-[11px]">
              <Flame className="w-3.5 h-3.5 text-[#FF6B00]" />
              <span>Deep Focus</span>
            </div>
            <span className="text-base font-bold font-mono text-[#FF6B00] mt-1">
              {focusMinutes}m
            </span>
          </div>

          <div className="bg-[#16161A] p-2.5 rounded-2xl border border-white/[0.08] flex flex-col">
            <div className="flex items-center gap-1.5 text-purple-400 text-[11px]">
              <Coffee className="w-3.5 h-3.5 text-purple-400" />
              <span>Break Time</span>
            </div>
            <span className="text-base font-bold font-mono text-purple-300 mt-1">
              {breakMinutes}m
            </span>
          </div>
        </div>
      </div>

      {/* Routine Tasks Queue Section */}
      <div className="flex-1 flex flex-col">
        {/* Header with TASKS QUEUE + Date Navigation + Add Block button */}
        <div className="flex items-center justify-between mb-3 px-0.5 gap-2">
          {/* Left: Tasks Queue Label + Interactive Date Navigation */}
          <div className="flex items-center gap-2 flex-wrap">
            <h2 className="text-sm font-black text-white tracking-wide uppercase">
              Tasks Queue
            </h2>

            {/* Date Navigator: < [Date Picker] > */}
            <div className="flex items-center bg-[#18181E] border border-white/10 rounded-xl px-1 py-0.5 shadow-sm">
              <button
                type="button"
                id="prev-date-btn"
                onClick={() => handleNavigateDate(-1)}
                className="p-1 rounded-lg text-neutral-400 hover:text-white hover:bg-white/10 active:scale-95 transition-all"
                title="Previous Day"
              >
                <ChevronLeft className="w-3.5 h-3.5" />
              </button>

              {/* Tappable Date Pill with hidden date input for picking any date */}
              <label
                className="relative cursor-pointer px-2 py-0.5 rounded-lg flex items-center gap-1.5 hover:bg-white/10 text-xs font-semibold text-neutral-200 hover:text-white transition-all select-none"
                title="Tap to select specific date"
              >
                <Calendar className="w-3 h-3 text-[#FF6B00]" />
                <span className="font-mono text-[11px] whitespace-nowrap">{dateDisplayText}</span>
                <input
                  type="date"
                  value={selectedDateStr}
                  onChange={(e) => {
                    if (e.target.value) {
                      const [y, m, d] = e.target.value.split('-').map(Number);
                      setSelectedDate(new Date(y, m - 1, d));
                      Haptics.selectionAsync();
                    }
                  }}
                  className="sr-only"
                />
              </label>

              <button
                type="button"
                id="next-date-btn"
                onClick={() => handleNavigateDate(1)}
                className="p-1 rounded-lg text-neutral-400 hover:text-white hover:bg-white/10 active:scale-95 transition-all"
                title="Next Day"
              >
                <ChevronRight className="w-3.5 h-3.5" />
              </button>
            </div>

            {/* Jump to Today if viewing a different date */}
            {!isToday && (
              <button
                type="button"
                onClick={() => {
                  setSelectedDate(new Date());
                  Haptics.selectionAsync();
                }}
                className="text-[10px] font-bold font-mono px-2 py-0.5 rounded-full bg-[#FF6B00]/15 text-[#FF6B00] border border-[#FF6B00]/30 hover:bg-[#FF6B00]/25 transition-all"
              >
                Today
              </button>
            )}
          </div>

          {/* Right: Add Block Toggle Button */}
          <button
            type="button"
            id="add-task-toggle-button"
            onClick={() => {
              setIsAddingTask(!isAddingTask);
              Haptics.impactAsync('light');
            }}
            className="flex items-center gap-1 text-xs font-semibold text-white bg-[#FF6B00] hover:bg-[#FF8533] px-3 py-1.5 rounded-xl shadow-md transition-all active:scale-95 shrink-0"
          >
            <Plus className="w-3.5 h-3.5" />
            <span>Add Block</span>
          </button>
        </div>

        {/* Day Progression Bar under Task Queue */}
        {totalTasksCount > 0 && (
          <div className="mb-3.5 p-3 rounded-2xl bg-[#15151A] border border-white/[0.08] shadow-sm">
            <div className="flex items-center justify-between text-xs mb-1.5">
              <div className="flex items-center gap-1.5">
                <CheckCircle2
                  className={`w-3.5 h-3.5 ${
                    progressPercent === 100 ? 'text-emerald-400' : 'text-[#FF6B00]'
                  }`}
                />
                <span className="font-bold text-neutral-200">
                  {progressPercent === 100 ? 'All Tasks Done! Fantastic 🎉' : 'Daily Progress'}
                </span>
              </div>
              <div className="flex items-center gap-2 font-mono text-[11px]">
                <span className="text-neutral-400">
                  <strong className="text-white font-bold">{completedTasksCount}</strong>/{totalTasksCount} done
                </span>
                <span
                  className={`font-bold px-1.5 py-0.5 rounded-md ${
                    progressPercent === 100
                      ? 'bg-emerald-500/20 text-emerald-300'
                      : 'bg-white/10 text-neutral-300'
                  }`}
                >
                  {progressPercent}%
                </span>
              </div>
            </div>

            {/* Visual Progress Bar Track & Gradient Fill */}
            <div className="w-full h-2 rounded-full bg-white/10 overflow-hidden relative">
              <div
                className={`h-full rounded-full transition-all duration-500 ease-out ${
                  progressPercent === 100
                    ? 'bg-gradient-to-r from-emerald-500 to-teal-400 shadow-[0_0_12px_rgba(16,185,129,0.5)]'
                    : 'bg-gradient-to-r from-[#FF6B00] via-amber-500 to-emerald-400'
                }`}
                style={{ width: `${progressPercent}%` }}
              />
            </div>

            {/* Focus time details */}
            {focusMinutes > 0 && (
              <div className="flex items-center justify-between text-[10px] text-neutral-400 mt-1.5 font-mono">
                <span>Focus Completed: {completedFocusMinutes}m / {focusMinutes}m</span>
                {progressPercent === 100 && (
                  <span className="text-emerald-400 font-semibold">100% Target Reached</span>
                )}
              </div>
            )}
          </div>
        )}

        {/* Add Task Form Card with Custom/Preset Duration, Recurrence, and Prominent Confirm Button */}
        {isAddingTask && (
          <form
            onSubmit={handleCreateTask}
            className="mb-4 p-4 bg-[#18181E] rounded-3xl border border-white/20 shadow-2xl flex flex-col gap-3.5 animate-in fade-in slide-in-from-top-2 duration-200"
          >
            {/* Type selector */}
            <div className="flex items-center justify-between">
              <span className="text-xs font-bold text-white uppercase tracking-wider flex items-center gap-1.5">
                <Sparkles className="w-3.5 h-3.5 text-[#FF6B00]" />
                Configure New Block
              </span>
              
              <div className="flex bg-black/50 p-1 rounded-xl border border-white/10 text-xs">
                <button
                  type="button"
                  onClick={() => setNewType('focus')}
                  className={`px-3 py-1 rounded-lg font-bold transition-colors ${
                    newType === 'focus'
                      ? 'bg-[#FF6B00] text-black shadow-sm'
                      : 'text-neutral-400 hover:text-white'
                  }`}
                >
                  Focus
                </button>
                <button
                  type="button"
                  onClick={() => setNewType('break')}
                  className={`px-3 py-1 rounded-lg font-bold transition-colors ${
                    newType === 'break'
                      ? 'bg-purple-600 text-white shadow-sm'
                      : 'text-neutral-400 hover:text-white'
                  }`}
                >
                  Break
                </button>
              </div>
            </div>

            {/* Task Title Input */}
            <div>
              <label htmlFor="new-task-title-input" className="block text-[11px] text-neutral-400 font-semibold mb-1">
                Task Title
              </label>
              <input
                id="new-task-title-input"
                type="text"
                required
                value={newTitle}
                onChange={(e) => setNewTitle(e.target.value)}
                placeholder={newType === 'focus' ? 'e.g., Learn Python Backend' : 'e.g., Scroll Phone / Stretch'}
                className="w-full px-3.5 py-2.5 rounded-xl bg-black/60 border border-white/15 text-white placeholder:text-neutral-500 text-sm focus:outline-hidden focus:border-[#FF6B00]"
              />
            </div>

            {/* Duration Section: Presets + Custom Option */}
            <div className="space-y-2">
              <div className="flex items-center justify-between">
                <span className="text-[11px] text-neutral-400 font-semibold flex items-center gap-1">
                  <Clock className="w-3 h-3 text-neutral-400" />
                  Duration Selection:
                </span>
                
                <button
                  type="button"
                  onClick={() => setIsCustomMode(!isCustomMode)}
                  className="text-[11px] text-[#FF6B00] hover:underline flex items-center gap-1 font-semibold"
                >
                  <Sliders className="w-3 h-3" />
                  <span>{isCustomMode ? 'Use Quick Presets' : 'Custom Minutes'}</span>
                </button>
              </div>

              {/* Quick Preset Buttons */}
              {!isCustomMode ? (
                <div className="flex flex-wrap items-center gap-1.5">
                  {DURATION_PRESETS.map((mins) => (
                    <button
                      key={mins}
                      type="button"
                      onClick={() => {
                        setNewDuration(mins);
                        Haptics.selectionAsync();
                      }}
                      className={`px-3 py-1.5 rounded-xl text-xs font-mono font-bold border transition-all ${
                        newDuration === mins
                          ? 'bg-white text-black border-white shadow-md scale-105'
                          : 'bg-white/5 border-white/10 text-neutral-300 hover:bg-white/10'
                      }`}
                    >
                      {mins}m
                    </button>
                  ))}
                  
                  <button
                    type="button"
                    onClick={() => setIsCustomMode(true)}
                    className="px-2.5 py-1.5 rounded-xl text-xs font-mono text-[#FF6B00] border border-[#FF6B00]/40 bg-[#FF6B00]/10 hover:bg-[#FF6B00]/20"
                    title="Enter custom minutes"
                  >
                    Custom...
                  </button>
                </div>
              ) : (
                /* Custom Duration Stepper & Numeric Input */
                <div className="p-2.5 rounded-2xl bg-black/40 border border-white/10 flex items-center justify-between gap-3">
                  <div className="flex items-center gap-2">
                    <button
                      type="button"
                      onClick={() => setNewDuration(Math.max(1, newDuration - 5))}
                      className="w-8 h-8 rounded-xl bg-white/10 hover:bg-white/20 text-white font-mono font-bold text-sm flex items-center justify-center transition-colors"
                    >
                      -5
                    </button>
                    <button
                      type="button"
                      onClick={() => setNewDuration(Math.max(1, newDuration - 1))}
                      className="w-7 h-7 rounded-lg bg-white/5 hover:bg-white/15 text-neutral-300 font-mono text-xs flex items-center justify-center transition-colors"
                    >
                      -1
                    </button>
                  </div>

                  <div className="flex items-center gap-1.5">
                    <input
                      id="custom-duration-input"
                      type="number"
                      min={1}
                      max={360}
                      value={newDuration}
                      onChange={(e) => setNewDuration(Math.max(1, parseInt(e.target.value) || 1))}
                      className="w-16 px-2 py-1 bg-white/10 border border-white/20 rounded-xl text-center font-mono font-bold text-white text-base focus:outline-hidden focus:border-[#FF6B00]"
                    />
                    <span className="text-xs font-mono text-neutral-400">minutes</span>
                  </div>

                  <div className="flex items-center gap-2">
                    <button
                      type="button"
                      onClick={() => setNewDuration(newDuration + 1)}
                      className="w-7 h-7 rounded-lg bg-white/5 hover:bg-white/15 text-neutral-300 font-mono text-xs flex items-center justify-center transition-colors"
                    >
                      +1
                    </button>
                    <button
                      type="button"
                      onClick={() => setNewDuration(newDuration + 5)}
                      className="w-8 h-8 rounded-xl bg-white/10 hover:bg-white/20 text-white font-mono font-bold text-sm flex items-center justify-center transition-colors"
                    >
                      +5
                    </button>
                  </div>
                </div>
              )}
            </div>

            {/* Optional Recurrence Settings: Repeat everyday, week, month */}
            <div className="pt-2 border-t border-white/10 space-y-2">
              <div className="flex items-center justify-between">
                <span className="text-[11px] text-neutral-400 font-semibold flex items-center gap-1">
                  <Repeat className="w-3 h-3 text-[#FF6B00]" />
                  Repeat / Recurrence:
                </span>
                <span className="text-[10px] text-neutral-500 font-mono">Optional</span>
              </div>

              {/* Recurrence Cadence Buttons */}
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
                    onClick={() => {
                      setNewRepeat(opt.id as TaskRepeat);
                      Haptics.selectionAsync();
                    }}
                    className={`py-1.5 px-2 rounded-xl text-xs font-bold transition-all ${
                      newRepeat === opt.id
                        ? 'bg-[#FF6B00] text-black shadow-sm font-extrabold'
                        : 'bg-white/5 text-neutral-300 hover:bg-white/10'
                    }`}
                  >
                    {opt.label}
                  </button>
                ))}
              </div>

              {/* Optional Repeat Until Date if Repeating */}
              {newRepeat !== 'none' && (
                <div className="p-2.5 rounded-xl bg-black/40 border border-white/10 space-y-2 mt-1">
                  <div className="flex items-center justify-between">
                    <span className="text-[11px] font-medium text-neutral-300">Repeat until:</span>
                    <div className="flex items-center gap-1.5">
                      <button
                        type="button"
                        onClick={() => setHasRepeatUntil(false)}
                        className={`text-[10px] font-bold px-2 py-0.5 rounded-md ${
                          !hasRepeatUntil ? 'bg-white/20 text-white' : 'text-neutral-500 hover:text-white'
                        }`}
                      >
                        Forever
                      </button>
                      <button
                        type="button"
                        onClick={() => setHasRepeatUntil(true)}
                        className={`text-[10px] font-bold px-2 py-0.5 rounded-md ${
                          hasRepeatUntil ? 'bg-[#FF6B00]/20 text-[#FF6B00]' : 'text-neutral-500 hover:text-white'
                        }`}
                      >
                        Until Date
                      </button>
                    </div>
                  </div>

                  {hasRepeatUntil && (
                    <input
                      type="date"
                      min={selectedDateStr}
                      value={newRepeatUntil}
                      onChange={(e) => setNewRepeatUntil(e.target.value)}
                      className="w-full px-3 py-1.5 rounded-xl bg-black/60 border border-white/15 text-white font-mono text-xs focus:outline-hidden focus:border-[#FF6B00]"
                    />
                  )}
                </div>
              )}
            </div>

            {/* Optional Calendar Schedule Time */}
            <div className="flex items-center justify-between pt-1 border-t border-white/10">
              <span className="text-[11px] text-neutral-400 font-semibold flex items-center gap-1">
                <Calendar className="w-3 h-3 text-neutral-400" />
                Schedule on Calendar:
              </span>
              <input
                id="new-task-time-picker"
                type="time"
                value={newScheduledTime}
                onChange={(e) => setNewScheduledTime(e.target.value)}
                className="px-2.5 py-1 rounded-xl bg-black/60 border border-white/15 text-xs font-mono text-white focus:outline-hidden focus:border-[#FF6B00]"
              />
            </div>

            {/* Confirmation & Cancel Action Buttons */}
            <div className="pt-2 flex items-center gap-2">
              <button
                type="button"
                onClick={() => setIsAddingTask(false)}
                className="px-4 py-3 rounded-2xl bg-white/5 hover:bg-white/10 text-neutral-400 hover:text-white text-xs font-semibold flex items-center justify-center gap-1 transition-colors"
              >
                <X className="w-3.5 h-3.5" />
                <span>Cancel</span>
              </button>

              <button
                type="submit"
                id="confirm-block-btn"
                className="flex-1 py-3 px-4 rounded-2xl bg-gradient-to-r from-[#FF6B00] via-[#FF8533] to-[#FF6B00] text-black font-extrabold text-sm flex items-center justify-center gap-2 shadow-[0_4px_20px_rgba(255,107,0,0.35)] hover:brightness-110 active:scale-[0.98] transition-all cursor-pointer"
              >
                <CheckCircle2 className="w-4 h-4 stroke-[2.5]" />
                <span>Confirm Block</span>
              </button>
            </div>
          </form>
        )}

        {/* Vertical Tasks List or Blank View if no tasks for selected day */}
        {dateTasks.length === 0 ? (
          <div className="py-10 px-4 rounded-3xl bg-[#141418] border border-dashed border-white/10 flex flex-col items-center justify-center text-center space-y-2.5 my-2">
            <div className="w-10 h-10 rounded-2xl bg-white/5 flex items-center justify-center text-neutral-500">
              <Calendar className="w-5 h-5 text-neutral-400" />
            </div>
            <div>
              <p className="text-xs font-bold text-neutral-200">
                No tasks scheduled for {dateDisplayText}
              </p>
              <p className="text-[11px] text-neutral-500 mt-0.5">
                Tasks created for 1 day only appear on their scheduled date.
              </p>
            </div>
            <button
              type="button"
              onClick={() => {
                setIsAddingTask(true);
                Haptics.impactAsync('light');
              }}
              className="mt-1 px-3 py-1.5 rounded-xl bg-[#FF6B00]/15 hover:bg-[#FF6B00]/25 text-[#FF6B00] border border-[#FF6B00]/30 text-xs font-bold transition-colors flex items-center gap-1.5"
            >
              <Plus className="w-3.5 h-3.5" />
              <span>Add Block for this day</span>
            </button>
          </div>
        ) : (
          <div className="space-y-2.5">
            {dateTasks.map((task, index) => (
              <TaskItem
                key={task.id}
                task={task}
                index={index}
                totalTasks={dateTasks.length}
                selectedDateStr={selectedDateStr}
                isActive={timerStatus !== 'idle' && tasks[activeTaskIndex]?.id === task.id ? index : -1}
                isDragging={draggedIndex === index}
                isDragOver={dragOverIndex === index}
                onDragStartTask={handleDragStartTask}
                onDragOverTask={handleDragOverTask}
                onDropTask={handleDropTask}
                onDragEndTask={handleDragEndTask}
                onUpdate={updateTask}
                onDelete={deleteTask}
                onToggleComplete={(id) => toggleTaskCompleted(id, selectedDateStr)}
                onMoveUp={handleMoveUp}
                onMoveDown={handleMoveDown}
                onSelect={() => {
                  const globalIdx = tasks.findIndex((t) => t.id === task.id);
                  if (globalIdx !== -1) {
                    if (timerStatus === 'idle') {
                      startRoutine(globalIdx);
                    } else {
                      setActiveTab('timer');
                    }
                  }
                }}
              />
            ))}
          </div>
        )}
      </div>
    </div>
  );
};
