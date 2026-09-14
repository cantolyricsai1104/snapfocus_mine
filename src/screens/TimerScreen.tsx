import React, { useEffect } from 'react';
import { useTaskStore } from '../store/useTaskStore';
import { TimerRing } from '../components/TimerRing';
import {
  Play,
  Pause,
  SkipForward,
  RotateCcw,
  Camera,
  ArrowRight,
  Flame,
  Coffee,
  Plus,
  Minus,
  Sparkles,
  AlertTriangle
} from 'lucide-react';
import { Haptics } from '../services/haptics';

export const TimerScreen: React.FC = () => {
  const {
    tasks,
    activeTaskIndex,
    timerStatus,
    timeRemaining,
    pauseTimer,
    resumeTimer,
    resetRoutine,
    skipToNextTask,
    adjustTimeRemaining,
    tick,
    triggerBreakLock,
    triggerFastTestTransition,
    openCameraModal,
  } = useTaskStore();

  const currentTask = tasks[activeTaskIndex] || {
    id: 'default',
    title: 'Focus Session',
    durationMinutes: 25,
    type: 'focus' as const,
    color: '#FF6B00',
  };

  const nextTask = tasks[activeTaskIndex + 1];
  const isFocus = currentTask.type === 'focus';
  const isRunning = timerStatus === 'running';
  const isPaused = timerStatus === 'paused';

  // Tick interval for active timer
  useEffect(() => {
    let interval: number | null = null;
    if (isRunning) {
      interval = window.setInterval(() => {
        tick();
      }, 1000);
    }
    return () => {
      if (interval) clearInterval(interval);
    };
  }, [isRunning, tick]);

  const togglePlayPause = () => {
    if (isRunning) {
      pauseTimer();
    } else {
      resumeTimer();
    }
  };

  return (
    <div
      className={`flex-1 flex flex-col justify-between p-5 transition-colors duration-500 overflow-y-auto ${
        isFocus ? 'bg-[#0A0A0C]' : 'bg-[#121214]'
      }`}
    >
      {/* Main Center Area: Timer Progress Ring */}
      <div className="flex-1 flex flex-col items-center justify-center my-auto">
        <TimerRing
          totalSeconds={currentTask.durationMinutes * 60}
          remainingSeconds={timeRemaining}
          type={currentTask.type}
          taskTitle={currentTask.title}
          isPaused={isPaused}
        />

        {/* Quick Stepper Buttons (+1m, +5m, -1m) */}
        <div className="flex items-center gap-2 mt-2">
          <button
            type="button"
            id="timer-minus-1m"
            onClick={() => adjustTimeRemaining(-60)}
            className="px-2.5 py-1 rounded-xl bg-white/5 hover:bg-white/10 text-neutral-400 hover:text-white border border-white/5 text-xs font-mono flex items-center gap-1 active:scale-95 transition-all"
            title="Subtract 1 minute"
          >
            <Minus className="w-3 h-3" />
            <span>1m</span>
          </button>

          <button
            type="button"
            id="timer-plus-1m"
            onClick={() => adjustTimeRemaining(60)}
            className="px-2.5 py-1 rounded-xl bg-white/5 hover:bg-white/10 text-neutral-400 hover:text-white border border-white/5 text-xs font-mono flex items-center gap-1 active:scale-95 transition-all"
            title="Add 1 minute"
          >
            <Plus className="w-3 h-3" />
            <span>1m</span>
          </button>

          <button
            type="button"
            id="timer-plus-5m"
            onClick={() => adjustTimeRemaining(300)}
            className="px-2.5 py-1 rounded-xl bg-white/5 hover:bg-white/10 text-neutral-400 hover:text-white border border-white/5 text-xs font-mono flex items-center gap-1 active:scale-95 transition-all"
            title="Add 5 minutes"
          >
            <Plus className="w-3 h-3" />
            <span>5m</span>
          </button>

          {/* Instant Test Lock button */}
          <button
            type="button"
            id="test-trigger-alarm-instant"
            onClick={() => {
              if (currentTask.type === 'break') {
                triggerBreakLock();
              } else {
                triggerFastTestTransition();
              }
            }}
            className="px-2.5 py-1 rounded-xl bg-red-500/20 hover:bg-red-500/30 text-red-300 border border-red-500/30 text-xs font-mono flex items-center gap-1 active:scale-95 transition-all"
            title="Simulates 00:00 trigger to test lock and alarm"
          >
            <AlertTriangle className="w-3 h-3 text-red-400" />
            <span>Simulate 00:00</span>
          </button>
        </div>
      </div>

      {/* Bottom Section: Next Up Card & Controls */}
      <div className="space-y-4 pb-14">
        {/* Next Up Preview Card */}
        {nextTask ? (
          <div className="bg-[#18181D]/90 backdrop-blur-md p-3 rounded-2xl border border-white/10 flex items-center justify-between">
            <div className="flex items-center gap-2.5 min-w-0">
              <div
                className={`w-7 h-7 rounded-lg flex items-center justify-center shrink-0 ${
                  nextTask.type === 'focus'
                    ? 'bg-[#FF6B00]/20 text-[#FF6B00]'
                    : 'bg-purple-500/20 text-purple-300'
                }`}
              >
                {nextTask.type === 'focus' ? (
                  <Flame className="w-4 h-4" />
                ) : (
                  <Coffee className="w-4 h-4" />
                )}
              </div>
              <div className="min-w-0">
                <span className="text-[10px] uppercase font-bold tracking-wider text-neutral-400">
                  Next Up ({nextTask.durationMinutes}m)
                </span>
                <p className="text-xs font-semibold text-white truncate">
                  {nextTask.title}
                </p>
              </div>
            </div>

            {nextTask.type === 'focus' && (
              <span className="text-[10px] font-mono font-bold px-2 py-0.5 rounded bg-black/60 text-[#CCFF00] border border-[#CCFF00]/30 flex items-center gap-1 shrink-0">
                <Camera className="w-2.5 h-2.5" /> Photo-Gated
              </span>
            )}
          </div>
        ) : (
          <div className="bg-[#18181D]/60 p-2.5 rounded-2xl border border-white/5 text-center text-xs text-neutral-400">
            Final task in the current routine.
          </div>
        )}

        {/* Primary Controls Row */}
        <div className="flex items-center justify-center gap-4">
          {/* Reset */}
          <button
            type="button"
            id="timer-reset-button"
            onClick={resetRoutine}
            className="w-12 h-12 rounded-2xl bg-[#1C1C22] hover:bg-white/10 text-neutral-400 hover:text-white flex items-center justify-center border border-white/10 transition-colors active:scale-95"
            title="Reset Timer"
          >
            <RotateCcw className="w-5 h-5" />
          </button>

          {/* Big Play / Pause Button */}
          <button
            type="button"
            id="timer-play-pause-button"
            onClick={togglePlayPause}
            className={`w-20 h-20 rounded-full flex items-center justify-center font-bold shadow-xl active:scale-95 transition-all ${
              isFocus
                ? 'bg-[#FF6B00] text-black shadow-[0_10px_35px_rgba(255,107,0,0.4)]'
                : 'bg-white text-black shadow-[0_10px_35px_rgba(255,255,255,0.25)]'
            }`}
          >
            {isRunning ? (
              <Pause className="w-8 h-8 fill-current" />
            ) : (
              <Play className="w-8 h-8 fill-current translate-x-0.5" />
            )}
          </button>

          {/* Skip */}
          <button
            type="button"
            id="timer-skip-button"
            onClick={skipToNextTask}
            disabled={activeTaskIndex >= tasks.length - 1}
            className="w-12 h-12 rounded-2xl bg-[#1C1C22] hover:bg-white/10 text-neutral-400 hover:text-white disabled:opacity-30 disabled:hover:bg-[#1C1C22] flex items-center justify-center border border-white/10 transition-colors active:scale-95"
            title="Skip to next task"
          >
            <SkipForward className="w-5 h-5" />
          </button>
        </div>
      </div>
    </div>
  );
};
