/**
 * SnapFocus - Photo-Gated Transition Pomodoro Mobile App
 * Built with Tactile Minimalism, Zustand, Web Audio & Camera APIs
 */

import React, { useEffect } from 'react';
import { useTaskStore } from './store/useTaskStore';
import { MobileFrame } from './components/MobileFrame';
import { HomeScreen } from './screens/HomeScreen';
import { CalendarScreen } from './screens/CalendarScreen';
import { TimerScreen } from './screens/TimerScreen';
import { GalleryScreen } from './screens/GalleryScreen';
import { TransitionModal } from './screens/TransitionModal';
import { CameraModal } from './screens/CameraModal';
import { BottomNav } from './components/BottomNav';
import { audioManager } from './services/audioManager';

export default function App() {
  const { activeTab, tasks, activeTaskIndex } = useTaskStore();

  const currentTask = tasks[activeTaskIndex];
  const activeMode =
    activeTab === 'timer' && currentTask
      ? currentTask.type
      : 'neutral';

  // Unlock AudioContext on initial user interaction so alarm & shutter sounds work seamlessly
  useEffect(() => {
    const handleInitialUserGesture = () => {
      audioManager.playTapSound();
      window.removeEventListener('click', handleInitialUserGesture);
      window.removeEventListener('keydown', handleInitialUserGesture);
    };

    window.addEventListener('click', handleInitialUserGesture, { once: true });
    window.addEventListener('keydown', handleInitialUserGesture, { once: true });

    return () => {
      window.removeEventListener('click', handleInitialUserGesture);
      window.removeEventListener('keydown', handleInitialUserGesture);
    };
  }, []);

  const isTasksTab = activeTab === 'tasks' || activeTab === 'timeline';

  return (
    <MobileFrame activeMode={activeMode}>
      <div className="relative flex-1 flex flex-col h-full w-full overflow-hidden">
        {/* Active Screen Tab */}
        <div className="flex-1 flex flex-col h-full w-full overflow-hidden">
          {isTasksTab && <HomeScreen />}
          {activeTab === 'calendar' && <CalendarScreen />}
          {activeTab === 'timer' && <TimerScreen />}
          {activeTab === 'gallery' && <GalleryScreen />}
        </div>

        {/* Screen 3: The Transition Lock Screen (Break timer reaches 00:00) */}
        <TransitionModal />

        {/* Screen 4: In-App Camera Modal (Takes real-time desk photo to unlock) */}
        <CameraModal />

        {/* Floating Bottom Navigation Bar */}
        <BottomNav />
      </div>
    </MobileFrame>
  );
}
