import React from 'react';
import { motion } from 'motion/react';
import { Sparkles, ShieldCheck } from 'lucide-react';

interface TimerRingProps {
  totalSeconds: number;
  remainingSeconds: number;
  type: 'focus' | 'break';
  taskTitle: string;
  isPaused: boolean;
}

export const TimerRing: React.FC<TimerRingProps> = ({
  totalSeconds,
  remainingSeconds,
  type,
  taskTitle,
  isPaused,
}) => {
  const isFocus = type === 'focus';
  const progress = totalSeconds > 0 ? Math.max(0, Math.min(1, (totalSeconds - remainingSeconds) / totalSeconds)) : 0;
  
  // Format MM:SS
  const minutes = Math.floor(remainingSeconds / 60);
  const seconds = remainingSeconds % 60;
  const formattedTime = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;

  const radius = 110;
  const circumference = 2 * Math.PI * radius;
  const strokeDashoffset = circumference * (1 - progress);

  const primaryColor = isFocus ? '#FF6B00' : '#8B5CF6';
  const glowColor = isFocus ? 'rgba(255, 107, 0, 0.25)' : 'rgba(139, 92, 246, 0.25)';

  return (
    <div className="relative flex flex-col items-center justify-center my-4">
      {/* Outer Subtle Ambient Glow */}
      <div
        className="absolute w-64 h-64 rounded-full blur-3xl pointer-events-none transition-colors duration-500"
        style={{ backgroundColor: glowColor }}
      />

      {/* SVG Progress Ring */}
      <div className="relative w-64 h-64 flex items-center justify-center">
        <svg className="w-full h-full -rotate-90 transform" viewBox="0 0 260 260">
          {/* Background Track */}
          <circle
            cx="130"
            cy="130"
            r={radius}
            stroke="currentColor"
            strokeWidth="8"
            fill="transparent"
            className="text-white/[0.06]"
          />
          {/* Active Progress Stroke */}
          <motion.circle
            cx="130"
            cy="130"
            r={radius}
            stroke={primaryColor}
            strokeWidth="9"
            strokeDasharray={circumference}
            initial={false}
            animate={{ strokeDashoffset }}
            transition={{ duration: 0.8, ease: 'easeInOut' }}
            strokeLinecap="round"
            fill="transparent"
          />
        </svg>

        {/* Center Contents */}
        <div className="absolute inset-0 flex flex-col items-center justify-center text-center p-4">
          {/* Phase Badge */}
          <div
            className={`flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold tracking-wider uppercase mb-1.5 border ${
              isFocus
                ? 'bg-[#FF6B00]/15 text-[#FF6B00] border-[#FF6B00]/30'
                : 'bg-purple-500/15 text-purple-300 border-purple-500/30'
            }`}
          >
            {isFocus ? (
              <>
                <Sparkles className="w-3 h-3" />
                Focus Mode
              </>
            ) : (
              <>
                <ShieldCheck className="w-3 h-3" />
                Break Block
              </>
            )}
          </div>

          {/* Large Countdown Digits */}
          <span className="font-mono text-5xl font-extrabold tracking-tight text-white select-none drop-shadow-sm">
            {formattedTime}
          </span>

          {/* Current Task Title */}
          <p className="text-xs text-neutral-300 font-medium max-w-[170px] truncate mt-1">
            {taskTitle}
          </p>

          {/* Paused / Gated Indicator */}
          {isPaused ? (
            <span className="mt-1.5 text-[10px] uppercase font-bold tracking-widest text-amber-400 bg-amber-400/10 px-2 py-0.5 rounded">
              Paused
            </span>
          ) : !isFocus ? (
            <span className="mt-1 text-[10px] text-purple-300/80 font-mono">
              📸 Photo-Gated on 00:00
            </span>
          ) : (
            <span className="mt-1 text-[10px] text-neutral-400 font-mono">
              Screen Awake
            </span>
          )}
        </div>
      </div>
    </div>
  );
};
