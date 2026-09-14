import React, { useState, useEffect } from 'react';
import { Volume2, VolumeX, Smartphone, Monitor } from 'lucide-react';
import { audioManager } from '../services/audioManager';

interface MobileFrameProps {
  children: React.ReactNode;
  activeMode: 'focus' | 'break' | 'neutral';
}

export const MobileFrame: React.FC<MobileFrameProps> = ({ children, activeMode }) => {
  const [isMuted, setIsMuted] = useState(false);
  const [currentTime, setCurrentTime] = useState('09:41');
  const [isFramed, setIsFramed] = useState(true);
  const [isVibrating, setIsVibrating] = useState(false);

  useEffect(() => {
    const updateClock = () => {
      const d = new Date();
      const h = d.getHours().toString().padStart(2, '0');
      const m = d.getMinutes().toString().padStart(2, '0');
      setCurrentTime(`${h}:${m}`);
    };
    updateClock();
    const interval = setInterval(updateClock, 10000);
    return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    const handleTactilePulse = () => {
      setIsVibrating(true);
      setTimeout(() => setIsVibrating(false), 200);
    };
    window.addEventListener('tactile-pulse', handleTactilePulse);
    return () => window.removeEventListener('tactile-pulse', handleTactilePulse);
  }, []);

  const toggleMute = () => {
    const next = !isMuted;
    setIsMuted(next);
    audioManager.setMuted(next);
  };

  const frameBg = activeMode === 'focus' 
    ? 'bg-[#0A0A0C]' 
    : activeMode === 'break' 
    ? 'bg-[#121214]' 
    : 'bg-[#0E0E11]';

  return (
    <div className="min-h-screen w-full bg-[#050507] text-white flex flex-col items-center justify-center p-0 sm:p-4 md:p-6 select-none font-sans overflow-x-hidden">
      {/* Top Floating Control Bar for Web Dev Preview */}
      <header className="w-full max-w-md hidden sm:flex items-center justify-between py-2 px-3 mb-2 text-xs text-neutral-400">
        <div className="flex items-center gap-2">
          <span className="font-bold tracking-tight text-white flex items-center gap-1.5">
            <span className="w-2 h-2 rounded-full bg-[#FF6B00] animate-pulse"></span>
            SnapFocus Mobile
          </span>
          <span className="px-1.5 py-0.5 rounded text-[10px] font-mono bg-white/10 text-neutral-300">
            Expo MVP
          </span>
        </div>
        
        <div className="flex items-center gap-2">
          <button
            id="toggle-sound-button"
            onClick={toggleMute}
            aria-label={isMuted ? 'Unmute Audio' : 'Mute Audio'}
            className="flex items-center gap-1 px-2.5 py-1 rounded-full bg-white/5 hover:bg-white/10 text-neutral-300 transition-colors border border-white/10 text-[11px]"
            title="Toggle Sound Effects & Alarm"
          >
            {isMuted ? <VolumeX className="w-3.5 h-3.5 text-red-400" /> : <Volume2 className="w-3.5 h-3.5 text-emerald-400" />}
            <span>{isMuted ? 'Muted' : 'Audio On'}</span>
          </button>

          <button
            id="toggle-frame-mode-button"
            onClick={() => setIsFramed(!isFramed)}
            aria-label="Toggle Phone Shell Frame"
            className="flex items-center gap-1 px-2.5 py-1 rounded-full bg-white/5 hover:bg-white/10 text-neutral-300 transition-colors border border-white/10 text-[11px]"
            title="Toggle Phone Enclosure"
          >
            {isFramed ? <Smartphone className="w-3.5 h-3.5 text-[#FF6B00]" /> : <Monitor className="w-3.5 h-3.5" />}
            <span>{isFramed ? 'Phone Shell' : 'Full Screen'}</span>
          </button>
        </div>
      </header>

      {/* Main Container / Mobile Device Enclosure */}
      <div
        className={`w-full transition-all duration-300 relative flex flex-col ${
          isFramed
            ? `max-w-[420px] h-[100dvh] sm:h-[844px] sm:rounded-[48px] sm:border-[10px] sm:border-[#222226] sm:shadow-[0_25px_70px_rgba(0,0,0,0.8),0_0_0_1px_rgba(255,255,255,0.1)] sm:ring-1 sm:ring-white/10 overflow-hidden`
            : 'max-w-xl min-h-screen sm:rounded-3xl sm:border sm:border-white/10'
        } ${frameBg} ${isVibrating ? 'scale-[0.998] brightness-110' : ''}`}
      >
        {/* iOS Dynamic Island & Status Bar */}
        <div className="w-full pt-3 px-7 pb-2 flex items-center justify-between text-xs font-semibold tracking-tight text-white/90 z-20 shrink-0">
          <span className="font-mono text-[13px]">{currentTime}</span>
          
          {/* Dynamic Island Pill */}
          <div className="w-24 h-5 bg-black rounded-full flex items-center justify-center border border-white/10 shadow-inner">
            <div className="w-2.5 h-2.5 rounded-full bg-[#18181B] flex items-center justify-center mr-1">
              <div className="w-1.5 h-1.5 rounded-full bg-neutral-900 border border-neutral-700"></div>
            </div>
            <div className="w-2 h-2 rounded-full bg-[#052e16] border border-emerald-500/30"></div>
          </div>

          <div className="flex items-center gap-1.5">
            {/* Cellular Bars */}
            <div className="flex items-end gap-0.5 h-3">
              <span className="w-0.5 h-1 bg-white/90 rounded-xs"></span>
              <span className="w-0.5 h-1.5 bg-white/90 rounded-xs"></span>
              <span className="w-0.5 h-2 bg-white/90 rounded-xs"></span>
              <span className="w-0.5 h-2.5 bg-white/90 rounded-xs"></span>
            </div>
            {/* Battery */}
            <div className="w-5 h-2.5 border border-white/80 rounded-[3px] p-0.5 flex items-center">
              <div className="w-full h-full bg-white rounded-xs"></div>
            </div>
          </div>
        </div>

        {/* Content Area */}
        <main className="flex-1 flex flex-col relative overflow-hidden">
          {children}
        </main>

        {/* Home Indicator Bar */}
        <div className="w-full py-2 flex justify-center items-center shrink-0 z-20 pointer-events-none">
          <div className="w-32 h-1 bg-white/30 rounded-full"></div>
        </div>
      </div>
    </div>
  );
};
