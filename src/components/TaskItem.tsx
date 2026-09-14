import React, { useState } from 'react';
import { TaskBlock } from '../types';
import { Coffee, Flame, ChevronUp, ChevronDown, Trash2, Clock, Check } from 'lucide-react';
import { Haptics } from '../services/haptics';
import { isTaskCompletedOnDate, getTodayDateString } from '../utils/dateUtils';

interface TaskItemProps {
  task: TaskBlock;
  index: number;
  totalTasks: number;
  isActive: number;
  selectedDateStr?: string;
  onUpdate: (id: string, updates: Partial<TaskBlock>) => void;
  onDelete: (id: string) => void;
  onToggleComplete?: (id: string) => void;
  onMoveUp: (index: number) => void;
  onMoveDown: (index: number) => void;
  onSelect: (index: number) => void;
  onDragStartTask?: (index: number) => void;
  onDragOverTask?: (e: React.DragEvent, index: number) => void;
  onDropTask?: (index: number) => void;
  onDragEndTask?: () => void;
  onTouchReorder?: (fromIndex: number, toIndex: number) => void;
  isDragging?: boolean;
  isDragOver?: boolean;
}

export const TaskItem: React.FC<TaskItemProps> = ({
  task,
  index,
  totalTasks,
  isActive,
  selectedDateStr,
  onUpdate,
  onDelete,
  onToggleComplete,
  onMoveUp,
  onMoveDown,
  onSelect,
  onDragStartTask,
  onDragOverTask,
  onDropTask,
  onDragEndTask,
  isDragging = false,
  isDragOver = false,
}) => {
  const isFocus = task.type === 'focus';
  const isCurrentlyActive = isActive === index;
  const targetDate = selectedDateStr || getTodayDateString();
  const isDone = isTaskCompletedOnDate(task, targetDate);

  const [isEditingDuration, setIsEditingDuration] = useState(false);
  const [tempDuration, setTempDuration] = useState(task.durationMinutes.toString());

  const toggleType = (e: React.MouseEvent) => {
    e.stopPropagation();
    const nextType = isFocus ? 'break' : 'focus';
    onUpdate(task.id, {
      type: nextType,
      color: nextType === 'focus' ? '#FF6B00' : '#8B5CF6',
    });
    Haptics.impactAsync('light');
  };

  const adjustDuration = (e: React.MouseEvent, delta: number) => {
    e.stopPropagation();
    const current = task.durationMinutes;
    const next = Math.max(1, Math.min(360, current + delta));
    onUpdate(task.id, { durationMinutes: next });
    Haptics.selectionAsync();
  };

  const handleSaveCustomDuration = (e: React.MouseEvent | React.FormEvent) => {
    e.stopPropagation();
    const val = parseInt(tempDuration, 10);
    if (!isNaN(val) && val > 0) {
      onUpdate(task.id, { durationMinutes: Math.min(360, val) });
    }
    setIsEditingDuration(false);
    Haptics.selectionAsync();
  };

  return (
    <div
      id={`task-item-${task.id}`}
      draggable
      onDragStart={(e) => {
        e.dataTransfer.setData('text/plain', index.toString());
        onDragStartTask?.(index);
      }}
      onDragOver={(e) => onDragOverTask?.(e, index)}
      onDrop={(e) => {
        e.preventDefault();
        onDropTask?.(index);
      }}
      onDragEnd={() => onDragEndTask?.()}
      onClick={() => onSelect(index)}
      className={`group relative p-3 rounded-2xl transition-all duration-200 cursor-pointer border ${
        isDragging
          ? 'opacity-40 scale-[0.98] border-dashed border-[#FF6B00]'
          : isDragOver
          ? 'border-[#FF6B00] ring-2 ring-[#FF6B00]/40 translate-y-1'
          : isCurrentlyActive
          ? isFocus
            ? 'bg-gradient-to-r from-[#18120B] to-[#121214] border-[#FF6B00]/40 shadow-[0_0_20px_rgba(255,107,0,0.15)]'
            : 'bg-gradient-to-r from-[#16131E] to-[#121214] border-purple-500/40 shadow-[0_0_20px_rgba(139,92,246,0.15)]'
          : isDone
          ? 'bg-[#121216]/60 hover:bg-[#15151A] border-white/[0.04] opacity-65'
          : 'bg-[#16161A]/90 hover:bg-[#1C1C22] border-white/[0.08]'
      }`}
    >
      {/* Current Active Indicator Pill */}
      {isCurrentlyActive && (
        <div className="absolute -top-2.5 left-4 px-2 py-0.5 rounded-full text-[10px] font-bold tracking-wider uppercase flex items-center gap-1 shadow-md bg-white text-black">
          <span
            className="w-1.5 h-1.5 rounded-full animate-ping"
            style={{ backgroundColor: isFocus ? '#FF6B00' : '#8B5CF6' }}
          />
          Active Now
        </div>
      )}

      <div className="flex items-center justify-between gap-2.5">
        {/* Leftmost: Checkbox to toggle Task Done */}
        <button
          type="button"
          onClick={(e) => {
            e.stopPropagation();
            onToggleComplete?.(task.id);
          }}
          title={isDone ? 'Mark as incomplete' : 'Mark as done'}
          className={`w-6 h-6 rounded-full flex items-center justify-center shrink-0 border transition-all active:scale-90 ${
            isDone
              ? 'bg-emerald-500 border-emerald-400 text-black shadow-[0_0_10px_rgba(16,185,129,0.4)] scale-105'
              : 'border-white/25 bg-white/5 hover:border-emerald-400/70 hover:bg-emerald-500/10 text-transparent hover:text-emerald-400'
          }`}
        >
          <Check className={`w-3.5 h-3.5 stroke-[3] ${isDone ? 'text-black' : 'opacity-0 hover:opacity-100'}`} />
        </button>

        {/* Icon & Badge */}
        <button
          type="button"
          onClick={toggleType}
          title={`Click to switch to ${isFocus ? 'Break' : 'Focus'}`}
          className={`w-9 h-9 rounded-xl flex items-center justify-center shrink-0 border transition-transform active:scale-95 ${
            isDone
              ? 'bg-white/5 border-white/5 text-neutral-500'
              : isFocus
              ? 'bg-[#FF6B00]/15 border-[#FF6B00]/30 text-[#FF6B00]'
              : 'bg-purple-500/15 border-purple-500/30 text-purple-300'
          }`}
        >
          {isFocus ? <Flame className="w-4 h-4 fill-current" /> : <Coffee className="w-4 h-4" />}
        </button>

        {/* Center: Title & optional recurrence info */}
        <div className="flex-1 min-w-0">
          <h4
            className={`font-semibold text-sm truncate transition-colors ${
              isDone
                ? 'line-through text-neutral-400 font-medium'
                : 'text-neutral-100'
            }`}
          >
            {task.title}
          </h4>
          {(task.repeat && task.repeat !== 'none') || task.scheduledTime ? (
            <div className="flex items-center gap-1.5 text-[10px] text-neutral-400 mt-0.5">
              {task.scheduledTime && (
                <span className="font-mono text-neutral-400">{task.scheduledTime}</span>
              )}
              {task.repeat && task.repeat !== 'none' && (
                <span className="px-1.5 py-0.5 rounded bg-white/5 text-[9px] text-neutral-400">
                  {task.repeat === 'daily'
                    ? 'Repeats Daily'
                    : task.repeat === 'weekly'
                    ? 'Repeats Weekly'
                    : 'Repeats Monthly'}
                </span>
              )}
            </div>
          ) : null}
        </div>

        {/* Right: Duration Stepper or Inline Custom Editor */}
        {!isEditingDuration ? (
          <div className="flex items-center gap-1 bg-black/40 px-2 py-1 rounded-xl border border-white/5 shrink-0">
            <button
              type="button"
              onClick={(e) => adjustDuration(e, -5)}
              className="w-5 h-5 rounded flex items-center justify-center text-neutral-400 hover:text-white hover:bg-white/10 text-xs font-mono"
              title="Decrease 5 minutes"
            >
              -
            </button>
            <button
              type="button"
              onClick={(e) => {
                e.stopPropagation();
                setIsEditingDuration(true);
                setTempDuration(task.durationMinutes.toString());
              }}
              className="flex items-center gap-1 px-1 hover:bg-white/10 rounded"
              title="Click to customize exact minutes"
            >
              <Clock className="w-3 h-3 text-neutral-400" />
              <span className="text-xs font-mono font-bold text-white whitespace-nowrap">
                {task.durationMinutes}m
              </span>
            </button>
            <button
              type="button"
              onClick={(e) => adjustDuration(e, 5)}
              className="w-5 h-5 rounded flex items-center justify-center text-neutral-400 hover:text-white hover:bg-white/10 text-xs font-mono"
              title="Increase 5 minutes"
            >
              +
            </button>
          </div>
        ) : (
          <div
            onClick={(e) => e.stopPropagation()}
            className="flex items-center gap-1 bg-black/80 px-2 py-1 rounded-xl border border-[#FF6B00]/40 shrink-0"
          >
            <input
              type="number"
              min={1}
              max={360}
              value={tempDuration}
              onChange={(e) => setTempDuration(e.target.value)}
              className="w-10 bg-transparent text-white font-mono text-xs font-bold text-center focus:outline-hidden"
              autoFocus
              onKeyDown={(e) => {
                if (e.key === 'Enter') handleSaveCustomDuration(e);
              }}
            />
            <span className="text-[10px] font-mono text-neutral-400">m</span>
            <button
              type="button"
              onClick={handleSaveCustomDuration}
              className="w-5 h-5 bg-[#FF6B00] text-black rounded flex items-center justify-center ml-0.5"
            >
              <Check className="w-3 h-3 stroke-[3]" />
            </button>
          </div>
        )}

        {/* Reorder Chevrons / Delete Actions */}
        <div className="flex items-center gap-0.5 shrink-0">
          <div className="flex flex-col">
            <button
              type="button"
              disabled={index === 0}
              onClick={(e) => {
                e.stopPropagation();
                onMoveUp(index);
              }}
              className="p-1 text-neutral-500 hover:text-white disabled:opacity-20 disabled:hover:text-neutral-500 transition-colors"
              title="Move Up"
            >
              <ChevronUp className="w-3.5 h-3.5" />
            </button>
            <button
              type="button"
              disabled={index === totalTasks - 1}
              onClick={(e) => {
                e.stopPropagation();
                onMoveDown(index);
              }}
              className="p-1 text-neutral-500 hover:text-white disabled:opacity-20 disabled:hover:text-neutral-500 transition-colors"
              title="Move Down"
            >
              <ChevronDown className="w-3.5 h-3.5" />
            </button>
          </div>

          <button
            type="button"
            onClick={(e) => {
              e.stopPropagation();
              onDelete(task.id);
            }}
            className="p-1.5 text-neutral-500 hover:text-red-400 transition-colors ml-0.5 rounded-lg hover:bg-red-500/10"
            title="Delete task"
          >
            <Trash2 className="w-3.5 h-3.5" />
          </button>
        </div>
      </div>
    </div>
  );
};
