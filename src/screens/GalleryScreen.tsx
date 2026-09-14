import React, { useState } from 'react';
import { useGalleryStore } from '../store/useGalleryStore';
import { PolaroidCard } from '../components/PolaroidCard';
import { FocusSnapshot } from '../types';
import { Flame, Clock, Calendar, Sparkles, X, Share2, Award, Trash2 } from 'lucide-react';
import { Haptics } from '../services/haptics';

export const GalleryScreen: React.FC = () => {
  const { snapshots, streakDays, deleteSnapshot, clearAll } = useGalleryStore();
  const [selectedSnapshot, setSelectedSnapshot] = useState<FocusSnapshot | null>(null);
  const [filterMode, setFilterMode] = useState<'today' | 'all'>('today');

  const todayStr = new Date().toDateString();
  const filteredSnapshots = snapshots.filter((s) => {
    if (filterMode === 'all') return true;
    return new Date(s.timestamp).toDateString() === todayStr;
  });

  const totalMinutesToday = snapshots
    .filter((s) => new Date(s.timestamp).toDateString() === todayStr)
    .reduce((sum, s) => sum + (s.focusMinutesCompleted || 45), 0);

  const handleShare = (snapshot: FocusSnapshot) => {
    Haptics.impactAsync('medium');
    if (navigator.share) {
      navigator.share({
        title: `SnapFocus Proof: ${snapshot.taskTitle}`,
        text: `Unlocked my deep focus session on SnapFocus! Desk proof verified at ${new Date(
          snapshot.timestamp
        ).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}`,
        url: window.location.href,
      }).catch(() => {});
    } else {
      // Copy simulated proof link
      navigator.clipboard?.writeText(window.location.href);
      alert('Proof link copied to clipboard!');
    }
  };

  return (
    <div className="flex-1 flex flex-col h-full bg-[#0E0E11] text-white overflow-y-auto px-4 pt-2 pb-24">
      {/* Header & Streak Banner */}
      <div className="mb-4">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-black tracking-tight text-white flex items-center gap-2">
              Focus Gallery
            </h1>
            <p className="text-xs text-neutral-400 mt-0.5">
              Daily visual proof of every session unlocked.
            </p>
          </div>

          {/* Streak Counter Pill */}
          <div className="flex items-center gap-1.5 px-3 py-1.5 rounded-2xl bg-gradient-to-r from-[#FF6B00]/20 to-amber-500/20 border border-[#FF6B00]/30 text-[#FF6B00]">
            <Flame className="w-4 h-4 fill-current animate-pulse" />
            <span className="font-extrabold text-sm">{streakDays} Day Streak</span>
          </div>
        </div>

        {/* Highlight Stats Row */}
        <div className="grid grid-cols-2 gap-2.5 mt-3.5">
          <div className="bg-[#16161A] p-3 rounded-2xl border border-white/[0.08] flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-[#CCFF00]/15 border border-[#CCFF00]/30 text-[#CCFF00] flex items-center justify-center">
              <Award className="w-5 h-5" />
            </div>
            <div>
              <span className="text-[11px] text-neutral-400 font-medium">Unlocked Today</span>
              <p className="text-lg font-bold font-mono text-white">
                {filteredSnapshots.length} Sessions
              </p>
            </div>
          </div>

          <div className="bg-[#16161A] p-3 rounded-2xl border border-white/[0.08] flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-[#FF6B00]/15 border border-[#FF6B00]/30 text-[#FF6B00] flex items-center justify-center">
              <Clock className="w-5 h-5" />
            </div>
            <div>
              <span className="text-[11px] text-neutral-400 font-medium">Focus Time Proof</span>
              <p className="text-lg font-bold font-mono text-[#FF6B00]">
                {totalMinutesToday}m
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Filter Controls & List Header */}
      <div className="flex items-center justify-between mb-3 px-0.5">
        <div className="flex items-center gap-1 bg-black/40 p-1 rounded-xl border border-white/10 text-xs">
          <button
            type="button"
            onClick={() => {
              setFilterMode('today');
              Haptics.selectionAsync();
            }}
            className={`px-3 py-1 rounded-lg font-semibold transition-colors ${
              filterMode === 'today'
                ? 'bg-white text-black'
                : 'text-neutral-400 hover:text-white'
            }`}
          >
            Today ({snapshots.filter((s) => new Date(s.timestamp).toDateString() === todayStr).length})
          </button>
          <button
            type="button"
            onClick={() => {
              setFilterMode('all');
              Haptics.selectionAsync();
            }}
            className={`px-3 py-1 rounded-lg font-semibold transition-colors ${
              filterMode === 'all'
                ? 'bg-white text-black'
                : 'text-neutral-400 hover:text-white'
            }`}
          >
            All Time ({snapshots.length})
          </button>
        </div>

        {snapshots.length > 0 && (
          <button
            type="button"
            onClick={() => {
              if (confirm('Clear all photo proof history?')) {
                clearAll();
              }
            }}
            className="text-[11px] text-neutral-500 hover:text-red-400 flex items-center gap-1 transition-colors px-2 py-1"
          >
            <Trash2 className="w-3 h-3" />
            <span>Clear</span>
          </button>
        )}
      </div>

      {/* Polaroid Grid */}
      {filteredSnapshots.length === 0 ? (
        <div className="flex-1 flex flex-col items-center justify-center text-center p-8 border-2 border-dashed border-white/10 rounded-3xl my-6">
          <div className="w-14 h-14 rounded-2xl bg-white/5 border border-white/10 flex items-center justify-center text-neutral-400 mb-3">
            <Sparkles className="w-6 h-6 text-[#FF6B00]" />
          </div>
          <h3 className="font-bold text-white text-base">No Snapshots Yet Today</h3>
          <p className="text-xs text-neutral-400 max-w-xs mt-1">
            Complete a Break block, take a photo of your desk, and your polaroid will appear here!
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-2 gap-3 pb-6">
          {filteredSnapshots.map((snapshot) => (
            <PolaroidCard
              key={snapshot.id}
              snapshot={snapshot}
              onSelect={(snap) => {
                setSelectedSnapshot(snap);
                Haptics.impactAsync('light');
              }}
              onDelete={deleteSnapshot}
            />
          ))}
        </div>
      )}

      {/* Snapshot Modal Inspection View */}
      {selectedSnapshot && (
        <div
          className="fixed inset-0 z-50 bg-black/85 backdrop-blur-md flex items-center justify-center p-5 animate-in fade-in duration-200"
          onClick={() => setSelectedSnapshot(null)}
        >
          <div
            className="relative bg-[#F9F9FB] text-neutral-900 rounded-3xl p-4 pb-6 shadow-2xl border-4 border-white max-w-xs w-full animate-in zoom-in-95 duration-200"
            onClick={(e) => e.stopPropagation()}
          >
            {/* Close Button */}
            <button
              type="button"
              onClick={() => setSelectedSnapshot(null)}
              className="absolute top-2 right-2 w-8 h-8 rounded-full bg-black/60 text-white flex items-center justify-center z-10 hover:bg-black"
            >
              <X className="w-4 h-4" />
            </button>

            {/* Photo */}
            <div className="w-full aspect-square rounded-2xl overflow-hidden bg-black shadow-inner">
              <img
                src={selectedSnapshot.photoUri}
                alt={selectedSnapshot.taskTitle}
                referrerPolicy="no-referrer"
                className="w-full h-full object-cover"
              />
            </div>

            {/* Polaroid Chin Info */}
            <div className="mt-3">
              <div className="flex items-center justify-between text-xs font-mono text-neutral-500">
                <span className="flex items-center gap-1">
                  <Calendar className="w-3.5 h-3.5" />
                  {new Date(selectedSnapshot.timestamp).toLocaleDateString([], {
                    month: 'short',
                    day: 'numeric',
                    year: 'numeric',
                  })}
                </span>
                <span className="font-bold">
                  {new Date(selectedSnapshot.timestamp).toLocaleTimeString([], {
                    hour: '2-digit',
                    minute: '2-digit',
                  })}
                </span>
              </div>

              <h3 className="font-extrabold text-base text-neutral-900 mt-1">
                {selectedSnapshot.taskTitle}
              </h3>

              <div className="mt-3 pt-3 border-t border-neutral-200 flex items-center justify-between">
                <span className="text-[11px] font-bold text-emerald-700 bg-emerald-100 px-2 py-0.5 rounded-full">
                  VERIFIED PROOF
                </span>

                <button
                  type="button"
                  onClick={() => handleShare(selectedSnapshot)}
                  className="flex items-center gap-1 text-xs font-semibold text-neutral-700 hover:text-black bg-neutral-200/80 hover:bg-neutral-300 px-2.5 py-1 rounded-xl transition-colors"
                >
                  <Share2 className="w-3.5 h-3.5" />
                  <span>Share</span>
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
