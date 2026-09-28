/**
 * SnapFocus - Photo-Gated Transition Pomodoro Mobile App
 * Built with Tactile Minimalism, Zustand, Web Audio & Camera APIs
 */

import React, { useEffect, useState } from 'react';
import type { Session, SupabaseClient } from '@supabase/supabase-js';
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
import { supabase } from './services/supabase';
import { AuthScreen } from './screens/AuthScreen';
import { connectCloudStores } from './services/cloudSync';
import { setTaskDataUser } from './store/useTaskStore';
import { setGalleryDataUser } from './store/useGalleryStore';

export default function App() {
  if (!supabase) {
    return <div className="min-h-screen bg-[#0E0E11] p-8 text-center text-white">Supabase setup is missing. Add the project URL and publishable key to <code>.env.local</code>, then restart the web preview.</div>;
  }
  return <WebAccountApp client={supabase} />;
}

function WebAccountApp({ client }: { client: SupabaseClient }) {
  const [session, setSession] = useState<Session | null>(null);
  const [checkingSession, setCheckingSession] = useState(true);
  const [syncState, setSyncState] = useState<'loading' | 'ready' | 'error'>('loading');
  const [syncError, setSyncError] = useState('');
  const [syncAttempt, setSyncAttempt] = useState(0);

  useEffect(() => {
    let live = true;
    void client.auth.getSession().then(({ data, error }) => {
      if (!live) return;
      if (error) setSyncError(error.message);
      setSession(data.session);
      setCheckingSession(false);
    });
    const { data: authListener } = client.auth.onAuthStateChange((_event, nextSession) => {
      if (!live) return;
      setSession(nextSession);
      if (!nextSession) {
        setTaskDataUser(null);
        setGalleryDataUser(null);
      }
    });
    return () => {
      live = false;
      authListener.subscription.unsubscribe();
    };
  }, [client]);

  useEffect(() => {
    if (!session) {
      setSyncState('loading');
      return;
    }
    let live = true;
    let disconnect: (() => void) | undefined;
    setSyncState('loading');
    setSyncError('');
    setTaskDataUser(session.user.id);
    setGalleryDataUser(session.user.id);
    void connectCloudStores(client, session.user.id)
      .then((cleanup) => {
        disconnect = cleanup;
        if (live) setSyncState('ready');
      })
      .catch((error: unknown) => {
        if (!live) return;
        setSyncError(error instanceof Error ? error.message : 'Cloud sync could not start.');
        setSyncState('error');
      });
    return () => {
      live = false;
      disconnect?.();
    };
  }, [client, session?.user.id, syncAttempt]);

  if (checkingSession) return <div className="min-h-screen bg-[#0E0E11] text-neutral-300 grid place-items-center">Checking your account…</div>;
  if (!session) return <AuthScreen client={client} />;
  if (syncState === 'loading') return <div className="min-h-screen bg-[#0E0E11] text-neutral-300 grid place-items-center">Syncing your SnapFocus data…</div>;
  if (syncState === 'error') return <main className="min-h-screen bg-[#0E0E11] text-white grid place-items-center p-6"><div className="max-w-md rounded-2xl border border-red-300/20 bg-red-950/30 p-5"><h1 className="font-bold">Couldn’t sync yet</h1><p className="mt-2 text-sm text-red-100/80">{syncError}</p><p className="mt-3 text-xs text-neutral-400">If the tables do not exist, run the SnapFocus SQL migration in the Supabase SQL Editor.</p><div className="mt-4 flex gap-2"><button className="rounded-lg bg-white/10 px-4 py-2" onClick={() => setSyncAttempt((value) => value + 1)}>Try again</button><button className="rounded-lg border border-white/20 px-4 py-2" onClick={() => void client.auth.signOut()}>Log out</button></div></div></main>;
  return <SnapFocusWorkspace client={client} />;
}

function SnapFocusWorkspace({ client }: { client: SupabaseClient }) {
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
          {isTasksTab && <HomeScreen onSignOut={() => void client.auth.signOut()} />}
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
