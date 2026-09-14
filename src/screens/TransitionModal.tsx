import React, { useEffect } from 'react';
import { useTaskStore } from '../store/useTaskStore';
import { Camera, ShieldAlert, Lock, Flame } from 'lucide-react';
import { Haptics } from '../services/haptics';

export const TransitionModal: React.FC = () => {
  const {
    timerStatus,
    activeBreakEndedBlock,
    pendingFocusBlock,
    openCameraModal,
  } = useTaskStore();

  const isLocked = timerStatus === 'transition-locked';

  if (!isLocked) return null;

  const nextTitle = pendingFocusBlock?.title || 'Deep Work Session';

  const handleOpenPhoto = () => {
    Haptics.impactAsync('heavy');
    openCameraModal();
  };

  return (
    <div
      id="transition-lock-overlay"
      className="absolute inset-0 z-50 bg-[#0A0A0C] text-white flex flex-col justify-between p-6 overflow-hidden animate-in fade-in duration-300 select-none"
    >
      {/* Background Animated Strobe/Pulse Accent */}
      <div className="absolute -top-32 -left-32 w-80 h-80 rounded-full bg-red-600/20 blur-3xl animate-pulse pointer-events-none" />
      <div className="absolute -bottom-32 -right-32 w-80 h-80 rounded-full bg-[#FF6B00]/20 blur-3xl animate-pulse pointer-events-none" />

      {/* Top Header: Lock Status Badge */}
      <div className="relative z-10 flex items-center justify-between pt-2">
        <div className="flex items-center gap-2 px-3 py-1 rounded-full bg-red-500/20 border border-red-500/40 text-red-300 text-xs font-bold uppercase tracking-wider animate-bounce">
          <ShieldAlert className="w-4 h-4 text-red-400" />
          <span>Screen Locked</span>
        </div>
      </div>

      {/* Center Hero Typography */}
      <div className="relative z-10 my-auto text-center flex flex-col items-center">
        {/* Pulsing Lock Icon */}
        <div className="w-16 h-16 rounded-3xl bg-white/10 border border-white/20 flex items-center justify-center text-white mb-6 shadow-[0_0_30px_rgba(255,255,255,0.2)]">
          <Lock className="w-8 h-8 text-[#FF6B00]" />
        </div>

        <h1 className="text-4xl sm:text-5xl font-black tracking-tight text-white uppercase leading-none">
          Break is Over.
        </h1>

        <div className="mt-4 p-4 rounded-2xl bg-white/[0.05] border border-white/10 max-w-xs w-full backdrop-blur-md">
          <div className="flex items-center justify-center gap-1.5 text-xs text-[#FF6B00] font-bold uppercase tracking-wider mb-1">
            <Flame className="w-3.5 h-3.5 fill-current" />
            <span>Next Mission</span>
          </div>
          <p className="text-lg font-bold text-white leading-snug">
            {nextTitle}
          </p>
        </div>

        <p className="mt-5 text-sm text-neutral-400 max-w-xs leading-relaxed">
          Put down your phone. Take a real-time photo of your desk or notebook to dismiss the alarm and unlock your focus session.
        </p>
      </div>

      {/* Bottom Giant Circular Action Button */}
      <div className="relative z-10 pb-6 flex flex-col items-center gap-3">
        <button
          type="button"
          id="trigger-camera-shutter-modal"
          onClick={handleOpenPhoto}
          className="w-full py-4 px-6 rounded-2xl bg-gradient-to-r from-[#FF6B00] via-[#FF8533] to-[#FF6B00] bg-size-200 text-black font-black text-base uppercase tracking-wider flex items-center justify-center gap-3 shadow-[0_15px_35px_rgba(255,107,0,0.45)] hover:brightness-110 active:scale-[0.97] transition-all cursor-pointer"
        >
          <Camera className="w-6 h-6 stroke-[2.5]" />
          <span>📸 Take Photo to Start</span>
        </button>

        <span className="text-[11px] text-neutral-500 font-mono tracking-tight">
          Dismissing is disabled until photo proof is captured
        </span>
      </div>
    </div>
  );
};
