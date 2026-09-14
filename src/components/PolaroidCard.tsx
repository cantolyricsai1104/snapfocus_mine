import React from 'react';
import { FocusSnapshot } from '../types';
import { CheckCircle2, Clock, Trash2, Maximize2 } from 'lucide-react';
import { Haptics } from '../services/haptics';

interface PolaroidCardProps {
  snapshot: FocusSnapshot;
  onSelect?: (snapshot: FocusSnapshot) => void;
  onDelete?: (id: string) => void;
}

export const PolaroidCard: React.FC<PolaroidCardProps> = ({
  snapshot,
  onSelect,
  onDelete,
}) => {
  const dateObj = new Date(snapshot.timestamp);
  const timeStr = dateObj.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  const dateStr = dateObj.toLocaleDateString([], { month: 'short', day: 'numeric' });

  return (
    <div
      id={`polaroid-${snapshot.id}`}
      onClick={() => onSelect?.(snapshot)}
      className="group relative bg-[#F9F9FB] text-neutral-900 rounded-2xl p-2.5 shadow-[0_10px_25px_rgba(0,0,0,0.4)] transition-all duration-200 hover:-translate-y-1 hover:shadow-[0_16px_35px_rgba(0,0,0,0.5)] cursor-pointer flex flex-col border border-white/20"
    >
      {/* Top Photo Frame */}
      <div className="relative aspect-square w-full rounded-xl overflow-hidden bg-neutral-900 shadow-inner">
        <img
          src={snapshot.photoUri}
          alt={`Workspace proof for ${snapshot.taskTitle}`}
          referrerPolicy="no-referrer"
          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
        />

        {/* Polaroid session badge */}
        <div className="absolute top-2 left-2 flex items-center gap-1 px-2 py-0.5 rounded-full bg-black/75 backdrop-blur-md text-[#CCFF00] text-[10px] font-bold tracking-wider uppercase border border-[#CCFF00]/40">
          <CheckCircle2 className="w-2.5 h-2.5" />
          <span>Unlocked</span>
        </div>

        {/* Hover zoom icon */}
        <div className="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity p-1 rounded-full bg-black/60 text-white">
          <Maximize2 className="w-3 h-3" />
        </div>
      </div>

      {/* Bottom Polaroid Chin with Handwritten/Authentic Typography */}
      <div className="pt-2.5 pb-1 px-1 flex flex-col justify-between">
        <div className="flex items-center justify-between gap-1 text-[11px] font-mono text-neutral-500">
          <span className="flex items-center gap-1 font-semibold">
            <Clock className="w-3 h-3 text-neutral-400" />
            {timeStr}
          </span>
          <span className="text-[10px]">{dateStr}</span>
        </div>

        <h5 className="font-bold text-xs text-neutral-900 truncate mt-1">
          {snapshot.taskTitle}
        </h5>

        {onDelete && (
          <div className="flex justify-end mt-1 pt-1 border-t border-neutral-200/70">
            <button
              type="button"
              onClick={(e) => {
                e.stopPropagation();
                onDelete(snapshot.id);
                Haptics.impactAsync('light');
              }}
              className="text-[11px] text-neutral-400 hover:text-red-600 flex items-center gap-1 transition-colors"
              title="Delete Snapshot"
            >
              <Trash2 className="w-3 h-3" />
              <span>Remove</span>
            </button>
          </div>
        )}
      </div>
    </div>
  );
};
