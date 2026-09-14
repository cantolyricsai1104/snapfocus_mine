import React, { useState, useEffect, useRef } from 'react';
import { useTaskStore } from '../store/useTaskStore';
import { useGalleryStore } from '../store/useGalleryStore';
import { audioManager } from '../services/audioManager';
import { Haptics } from '../services/haptics';
import confetti from 'canvas-confetti';
import {
  Camera,
  RefreshCw,
  X,
  AlertCircle,
  CheckCircle2,
  Sparkles,
  Upload,
  Layers
} from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';

// Preset realistic workspace proof mock snapshots if camera is unavailable or in sandbox
const WORKSPACE_PRESETS = [
  {
    name: 'Desk & Notebook',
    url: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?auto=format&fit=crop&w=800&q=80',
  },
  {
    name: 'Dual Monitor Rig',
    url: 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80',
  },
  {
    name: 'Clean Workspace & Espresso',
    url: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=800&q=80',
  },
  {
    name: 'Open Textbook & Pen',
    url: 'https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=800&q=80',
  },
];

export const CameraModal: React.FC = () => {
  const {
    isCameraModalOpen,
    closeCameraModal,
    timerStatus,
    pendingFocusBlock,
    tasks,
    activeTaskIndex,
    unlockWithPhotoCapture,
  } = useTaskStore();

  const { addSnapshot } = useGalleryStore();

  const videoRef = useRef<HTMLVideoElement | null>(null);
  const canvasRef = useRef<HTMLCanvasElement | null>(null);
  const fileInputRef = useRef<HTMLInputElement | null>(null);

  const [hasCameraPermission, setHasCameraPermission] = useState<boolean | null>(null);
  const [stream, setStream] = useState<MediaStream | null>(null);
  const [selectedPresetIndex, setSelectedPresetIndex] = useState(0);
  const [capturedPhotoUri, setCapturedPhotoUri] = useState<string | null>(null);
  const [isAnimatingStamp, setIsAnimatingStamp] = useState(false);
  const [facingMode, setFacingMode] = useState<'user' | 'environment'>('environment');

  const currentFocusTask = pendingFocusBlock || tasks[activeTaskIndex] || {
    id: 'focus-task',
    title: 'Deep Focus Session',
    durationMinutes: 25,
    type: 'focus' as const,
  };

  // Start camera stream when modal opens
  useEffect(() => {
    if (!isCameraModalOpen) {
      stopCameraStream();
      setCapturedPhotoUri(null);
      setIsAnimatingStamp(false);
      return;
    }

    startCamera();

    return () => {
      stopCameraStream();
    };
  }, [isCameraModalOpen, facingMode]);

  const stopCameraStream = () => {
    if (stream) {
      stream.getTracks().forEach((track) => track.stop());
      setStream(null);
    }
  };

  const startCamera = async () => {
    try {
      if (typeof navigator === 'undefined' || !navigator.mediaDevices?.getUserMedia) {
        setHasCameraPermission(false);
        return;
      }

      const mediaStream = await navigator.mediaDevices.getUserMedia({
        video: {
          facingMode: { ideal: facingMode },
          width: { ideal: 1080 },
          height: { ideal: 1080 },
        },
        audio: false,
      });

      setStream(mediaStream);
      setHasCameraPermission(true);
      if (videoRef.current) {
        videoRef.current.srcObject = mediaStream;
      }
    } catch (err) {
      console.warn('Camera access unavailable or denied:', err);
      setHasCameraPermission(false);
    }
  };

  const toggleCameraFacing = () => {
    setFacingMode((prev) => (prev === 'user' ? 'environment' : 'user'));
    Haptics.impactAsync('light');
  };

  const handleCapture = () => {
    // 1. Play mechanical shutter sound and strong haptic impact
    audioManager.playShutterSound();
    Haptics.impactAsync('heavy');

    let photoData = '';

    if (hasCameraPermission && videoRef.current && canvasRef.current) {
      const video = videoRef.current;
      const canvas = canvasRef.current;
      canvas.width = video.videoWidth || 640;
      canvas.height = video.videoHeight || 640;
      const ctx = canvas.getContext('2d');
      if (ctx) {
        ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
        photoData = canvas.toDataURL('image/jpeg', 0.85);
      }
    }

    // If camera wasn't available, use selected workspace preset
    if (!photoData) {
      photoData = WORKSPACE_PRESETS[selectedPresetIndex].url;
    }

    setCapturedPhotoUri(photoData);
    setIsAnimatingStamp(true);

    // Play unlocking chime sound
    setTimeout(() => {
      audioManager.playUnlockSound();
      Haptics.notificationAsync('success');
      try {
        confetti({
          particleCount: 50,
          spread: 60,
          origin: { y: 0.6 },
          colors: ['#FF6B00', '#CCFF00', '#FFFFFF'],
        });
      } catch {
        // ignore
      }
    }, 400);

    // Save to Gallery store
    const nowIso = new Date().toISOString();
    addSnapshot({
      id: `snap-${Date.now()}`,
      taskId: currentFocusTask.id,
      taskTitle: currentFocusTask.title,
      photoUri: photoData,
      timestamp: nowIso,
      focusMinutesCompleted: currentFocusTask.durationMinutes,
    });

    // Complete 1.5-second Polaroid Stamp Animation -> Advance routine and start next focus timer!
    setTimeout(() => {
      unlockWithPhotoCapture();
    }, 1500);
  };

  const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = () => {
      if (typeof reader.result === 'string') {
        audioManager.playShutterSound();
        Haptics.impactAsync('heavy');
        setCapturedPhotoUri(reader.result);
        setIsAnimatingStamp(true);

        setTimeout(() => {
          audioManager.playUnlockSound();
          Haptics.notificationAsync('success');
          try {
            confetti({
              particleCount: 50,
              spread: 60,
              origin: { y: 0.6 },
              colors: ['#FF6B00', '#CCFF00', '#FFFFFF'],
            });
          } catch {
            // ignore
          }
        }, 400);

        const nowIso = new Date().toISOString();
        addSnapshot({
          id: `snap-${Date.now()}`,
          taskId: currentFocusTask.id,
          taskTitle: currentFocusTask.title,
          photoUri: reader.result,
          timestamp: nowIso,
          focusMinutesCompleted: currentFocusTask.durationMinutes,
        });

        setTimeout(() => {
          unlockWithPhotoCapture();
        }, 1500);
      }
    };
    reader.readAsDataURL(file);
  };

  if (!isCameraModalOpen) return null;

  const isLockedMode = timerStatus === 'transition-locked';

  return (
    <div
      id="camera-view-modal"
      className="absolute inset-0 z-50 bg-black text-white flex flex-col justify-between overflow-hidden select-none"
    >
      <canvas ref={canvasRef} className="hidden" />
      <input
        ref={fileInputRef}
        type="file"
        accept="image/*"
        capture="environment"
        onChange={handleFileUpload}
        className="hidden"
      />

      {/* Top Header Controls */}
      <div className="relative z-30 p-4 pt-2 flex items-center justify-between bg-gradient-to-b from-black/80 to-transparent">
        {/* Only show close button if NOT in mandatory transition lock */}
        {!isLockedMode ? (
          <button
            type="button"
            onClick={closeCameraModal}
            className="w-10 h-10 rounded-full bg-white/10 hover:bg-white/20 text-white flex items-center justify-center transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        ) : (
          <div className="flex items-center gap-1.5 px-3 py-1 rounded-full bg-red-500/20 border border-red-500/40 text-[11px] font-bold uppercase tracking-wider text-red-300">
            <span className="w-2 h-2 rounded-full bg-red-500 animate-ping" />
            Photo Required
          </div>
        )}

        <div className="flex items-center gap-2">
          {hasCameraPermission && (
            <button
              type="button"
              onClick={toggleCameraFacing}
              className="w-10 h-10 rounded-full bg-white/10 hover:bg-white/20 text-white flex items-center justify-center transition-colors"
              title="Switch Camera Front/Back"
            >
              <RefreshCw className="w-4 h-4" />
            </button>
          )}

          <button
            type="button"
            onClick={() => fileInputRef.current?.click()}
            className="px-3 py-1.5 rounded-full bg-white/10 hover:bg-white/20 text-white text-xs font-semibold flex items-center gap-1.5 transition-colors border border-white/10"
            title="Upload photo from device"
          >
            <Upload className="w-3.5 h-3.5" />
            <span>Upload</span>
          </button>
        </div>
      </div>

      {/* Viewfinder Main Stage */}
      <div className="relative flex-1 w-full bg-neutral-950 flex items-center justify-center overflow-hidden">
        {hasCameraPermission ? (
          <video
            ref={videoRef}
            autoPlay
            playsInline
            muted
            className="w-full h-full object-cover"
          />
        ) : (
          /* Fallback Workspace Viewfinder Simulation */
          <div className="w-full h-full relative flex flex-col items-center justify-center p-4">
            <img
              src={WORKSPACE_PRESETS[selectedPresetIndex].url}
              alt="Workspace preset"
              referrerPolicy="no-referrer"
              className="absolute inset-0 w-full h-full object-cover opacity-90"
            />
            
            {/* Overlay Banner */}
            <div className="absolute top-4 inset-x-4 bg-black/75 backdrop-blur-md p-2.5 rounded-2xl border border-white/15 text-center z-10">
              <div className="flex items-center justify-center gap-1.5 text-xs text-amber-400 font-semibold mb-0.5">
                <AlertCircle className="w-3.5 h-3.5" />
                <span>Camera Stream / Desk Proof Mode</span>
              </div>
              <p className="text-[11px] text-neutral-300">
                Tap shutter to capture current workspace desk proof, or switch desk preset below.
              </p>
            </div>
          </div>
        )}

        {/* Viewfinder Grid Reticle */}
        <div className="absolute inset-8 pointer-events-none border border-white/20 rounded-3xl flex flex-col justify-between p-4">
          <div className="flex justify-between text-[10px] font-mono text-white/50">
            <span>[ SNAPFOCUS 01 ]</span>
            <span>PRO-CAM 4K</span>
          </div>
          <div className="flex justify-center">
            <div className="w-12 h-12 border border-dashed border-white/40 rounded-full flex items-center justify-center">
              <div className="w-2 h-2 rounded-full bg-[#FF6B00]" />
            </div>
          </div>
          <div className="flex justify-between text-[10px] font-mono text-white/50">
            <span>DESK ALIGNMENT</span>
            <span>F/1.8 1/120s</span>
          </div>
        </div>

        {/* 1.5-Second Polaroid Stamp Animation Overlay */}
        <AnimatePresence>
          {isAnimatingStamp && capturedPhotoUri && (
            <motion.div
              initial={{ scale: 1.1, opacity: 0, rotate: 0 }}
              animate={{ scale: 0.85, opacity: 1, rotate: -3 }}
              exit={{ scale: 0.5, opacity: 0 }}
              transition={{ duration: 0.5, ease: 'easeOut' }}
              className="absolute z-40 bg-[#F9F9FB] p-4 pb-6 rounded-3xl shadow-[0_25px_60px_rgba(0,0,0,0.9)] border-4 border-white max-w-xs w-full flex flex-col items-center"
            >
              {/* Captured Photo */}
              <div className="w-full aspect-square rounded-2xl overflow-hidden bg-black shadow-inner relative">
                <img
                  src={capturedPhotoUri}
                  alt="Captured snapshot"
                  referrerPolicy="no-referrer"
                  className="w-full h-full object-cover"
                />

                {/* Stamp Badge */}
                <motion.div
                  initial={{ scale: 2, opacity: 0 }}
                  animate={{ scale: 1, opacity: 1 }}
                  transition={{ delay: 0.2, type: 'spring', stiffness: 300, damping: 20 }}
                  className="absolute inset-0 flex items-center justify-center bg-black/40 backdrop-blur-xs"
                >
                  <div className="px-4 py-2 rounded-2xl bg-[#CCFF00] text-black font-black text-sm uppercase tracking-wider shadow-2xl flex items-center gap-2 border-2 border-black rotate-[-6deg]">
                    <CheckCircle2 className="w-5 h-5 fill-current" />
                    <span>SESSION UNLOCKED</span>
                  </div>
                </motion.div>
              </div>

              {/* Polaroid Footer */}
              <div className="w-full mt-3 text-center">
                <p className="text-xs font-mono font-bold text-neutral-500">
                  {new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })} · PROOF VERIFIED
                </p>
                <h4 className="text-sm font-bold text-neutral-900 mt-0.5">
                  Next: {currentFocusTask.title}
                </h4>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      {/* Bottom Shutter Controls Stage */}
      <div className="relative z-30 p-6 pt-3 bg-gradient-to-t from-black via-black/90 to-transparent flex flex-col items-center gap-3">
        {/* Desk Preset Selector if camera is fallback */}
        {!hasCameraPermission && !isAnimatingStamp && (
          <div className="w-full flex items-center justify-center gap-1.5 overflow-x-auto py-1">
            <span className="text-[10px] text-neutral-400 font-mono flex items-center gap-1 mr-1">
              <Layers className="w-3 h-3" /> Desks:
            </span>
            {WORKSPACE_PRESETS.map((preset, idx) => (
              <button
                key={preset.name}
                type="button"
                onClick={() => {
                  setSelectedPresetIndex(idx);
                  Haptics.selectionAsync();
                }}
                className={`px-2.5 py-1 rounded-xl text-[11px] font-medium border transition-colors whitespace-nowrap ${
                  selectedPresetIndex === idx
                    ? 'bg-white text-black border-white font-bold'
                    : 'bg-white/10 text-neutral-300 border-white/10 hover:bg-white/20'
                }`}
              >
                {preset.name}
              </button>
            ))}
          </div>
        )}

        {/* Minimalist Shutter Button with Strong Haptic Impact */}
        <div className="flex items-center justify-center w-full my-1">
          <button
            type="button"
            id="camera-shutter-button"
            disabled={isAnimatingStamp}
            onClick={handleCapture}
            className="w-20 h-20 rounded-full border-4 border-white p-1 flex items-center justify-center active:scale-90 transition-transform cursor-pointer shadow-[0_0_25px_rgba(255,255,255,0.4)] group"
          >
            <div className="w-full h-full rounded-full bg-white group-hover:bg-[#FF6B00] transition-colors" />
          </button>
        </div>

        <p className="text-xs text-neutral-400 text-center font-medium">
          {isAnimatingStamp ? 'Unlocking session...' : 'Tap shutter to verify workspace proof'}
        </p>
      </div>
    </div>
  );
};
