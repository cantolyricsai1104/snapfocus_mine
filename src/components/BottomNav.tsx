import React from 'react';
import { useTaskStore } from '../store/useTaskStore';
import { useGalleryStore } from '../store/useGalleryStore';
import { ListTodo, Calendar, Timer, Images, ShieldAlert } from 'lucide-react';
import { Haptics } from '../services/haptics';
import { ActiveTab } from '../types';

export const BottomNav: React.FC = () => {
  const { activeTab, setActiveTab, timerStatus } = useTaskStore();
  const { snapshots } = useGalleryStore();

  const isTimerActive = timerStatus === 'running';
  const isLocked = timerStatus === 'transition-locked';

  const handleTabChange = (tab: ActiveTab) => {
    // If screen is transition-locked, navigation away is restricted
    if (isLocked && tab !== 'timer') {
      Haptics.notificationAsync('warning');
      return;
    }
    setActiveTab(tab);
    Haptics.impactAsync('light');
  };

  const isTasksActive = activeTab === 'tasks' || activeTab === 'timeline';

  return (
    <nav
      aria-label="Bottom Navigation"
      className="absolute bottom-2 inset-x-3 z-30 bg-[#141418]/90 backdrop-blur-xl border border-white/10 rounded-3xl p-1 shadow-[0_10px_30px_rgba(0,0,0,0.6)] flex items-center justify-around select-none"
    >
      {/* Tab 1: Tasks */}
      <button
        type="button"
        id="nav-tab-tasks"
        onClick={() => handleTabChange('tasks')}
        className={`flex-1 py-2 rounded-2xl flex flex-col items-center gap-0.5 transition-all ${
          isTasksActive
            ? 'bg-white/10 text-white font-bold'
            : 'text-neutral-400 hover:text-neutral-200'
        }`}
      >
        <ListTodo className="w-4 h-4" />
        <span className="text-[10px] tracking-tight">Tasks</span>
      </button>

      {/* Tab 2: Calendar */}
      <button
        type="button"
        id="nav-tab-calendar"
        onClick={() => handleTabChange('calendar')}
        className={`flex-1 py-2 rounded-2xl flex flex-col items-center gap-0.5 transition-all ${
          activeTab === 'calendar'
            ? 'bg-white/10 text-white font-bold'
            : 'text-neutral-400 hover:text-neutral-200'
        }`}
      >
        <Calendar className="w-4 h-4" />
        <span className="text-[10px] tracking-tight">Calendar</span>
      </button>

      {/* Tab 3: Timer */}
      <button
        type="button"
        id="nav-tab-timer"
        onClick={() => handleTabChange('timer')}
        className={`flex-1 py-2 rounded-2xl flex flex-col items-center gap-0.5 relative transition-all ${
          activeTab === 'timer'
            ? 'bg-white/10 text-white font-bold'
            : 'text-neutral-400 hover:text-neutral-200'
        }`}
      >
        <div className="relative">
          {isLocked ? (
            <ShieldAlert className="w-4 h-4 text-red-500 animate-bounce" />
          ) : (
            <Timer className={`w-4 h-4 ${isTimerActive ? 'text-[#FF6B00]' : ''}`} />
          )}

          {isTimerActive && !isLocked && (
            <span className="absolute -top-1 -right-1 w-1.5 h-1.5 rounded-full bg-[#FF6B00] animate-ping" />
          )}
          {isLocked && (
            <span className="absolute -top-1 -right-1 w-1.5 h-1.5 rounded-full bg-red-500 animate-ping" />
          )}
        </div>
        <span className="text-[10px] tracking-tight">
          {isLocked ? 'LOCKED' : 'Timer'}
        </span>
      </button>

      {/* Tab 4: Proof Gallery */}
      <button
        type="button"
        id="nav-tab-gallery"
        onClick={() => handleTabChange('gallery')}
        className={`flex-1 py-2 rounded-2xl flex flex-col items-center gap-0.5 relative transition-all ${
          activeTab === 'gallery'
            ? 'bg-white/10 text-white font-bold'
            : 'text-neutral-400 hover:text-neutral-200'
        }`}
      >
        <div className="relative">
          <Images className="w-4 h-4" />
          {snapshots.length > 0 && (
            <span className="absolute -top-1 -right-2 px-1 rounded-full bg-[#CCFF00] text-black text-[8px] font-black">
              {snapshots.length}
            </span>
          )}
        </div>
        <span className="text-[10px] tracking-tight">Proof</span>
      </button>
    </nav>
  );
};
