import { create } from 'zustand';
import { FocusSnapshot } from '../types';
import { Haptics } from '../services/haptics';

const GALLERY_STORAGE_KEY = 'snapfocus_gallery_snapshots_v1';
let activeGalleryUserId: string | null = null;

function scopedGalleryStorageKey() {
  return activeGalleryUserId
    ? `${GALLERY_STORAGE_KEY}:${activeGalleryUserId}`
    : GALLERY_STORAGE_KEY;
}

// Seed initial authentic workspace proof photos
const INITIAL_SNAPSHOTS: FocusSnapshot[] = [
  {
    id: 'snap-1',
    taskId: 'task-2',
    taskTitle: 'Learn Python Backend',
    photoUri: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?auto=format&fit=crop&w=800&q=80',
    timestamp: new Date(Date.now() - 3600 * 1000 * 4).toISOString(),
    focusMinutesCompleted: 45,
  },
  {
    id: 'snap-2',
    taskId: 'task-4',
    taskTitle: 'Code SnapFocus Architecture',
    photoUri: 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=800&q=80',
    timestamp: new Date(Date.now() - 3600 * 1000 * 2).toISOString(),
    focusMinutesCompleted: 50,
  },
  {
    id: 'snap-3',
    taskId: 'task-extra',
    taskTitle: 'Data Structures Sprint',
    photoUri: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=800&q=80',
    timestamp: new Date(Date.now() - 3600 * 1000 * 6).toISOString(),
    focusMinutesCompleted: 35,
  },
];

function loadStoredSnapshots(): FocusSnapshot[] {
  if (typeof window === 'undefined') return INITIAL_SNAPSHOTS;
  try {
    const raw = localStorage.getItem(scopedGalleryStorageKey());
    if (raw) {
      const parsed = JSON.parse(raw);
      if (Array.isArray(parsed)) return parsed;
    }
  } catch {
    // fallback
  }
  return INITIAL_SNAPSHOTS;
}

function saveSnapshots(snaps: FocusSnapshot[]) {
  if (typeof window === 'undefined') return;
  try {
    localStorage.setItem(scopedGalleryStorageKey(), JSON.stringify(snaps));
  } catch {
    // ignore
  }
}

interface GalleryStoreState {
  snapshots: FocusSnapshot[];
  streakDays: number;
  addSnapshot: (snapshot: FocusSnapshot) => void;
  setSnapshots: (snapshots: FocusSnapshot[]) => void;
  deleteSnapshot: (id: string) => void;
  clearAll: () => void;
  getTodaySnapshots: () => FocusSnapshot[];
}

export const useGalleryStore = create<GalleryStoreState>((set, get) => ({
  snapshots: loadStoredSnapshots(),
  streakDays: 4, // 4-day active streak

  setSnapshots: (snapshots) => {
    saveSnapshots(snapshots);
    set({ snapshots });
  },

  addSnapshot: (snapshot: FocusSnapshot) => {
    const current = get().snapshots;
    const updated = [snapshot, ...current];
    saveSnapshots(updated);
    set({ snapshots: updated });
    Haptics.notificationAsync('success');
  },

  deleteSnapshot: (id: string) => {
    const current = get().snapshots;
    const updated = current.filter((s) => s.id !== id);
    saveSnapshots(updated);
    set({ snapshots: updated });
    Haptics.impactAsync('light');
  },

  clearAll: () => {
    saveSnapshots([]);
    set({ snapshots: [] });
    Haptics.impactAsync('medium');
  },

  getTodaySnapshots: () => {
    const snaps = get().snapshots;
    const todayStr = new Date().toDateString();
    return snaps.filter((s) => new Date(s.timestamp).toDateString() === todayStr);
  },
}));

/** Uses per-account browser caches and only claims the old shared cache once. */
export function setGalleryDataUser(userId: string | null) {
  if (activeGalleryUserId === userId) return;
  activeGalleryUserId = userId;
  if (!userId || typeof window === 'undefined') return;

  try {
    const ownerKey = 'snapfocus_gallery_owner_v1';
    const scoped = localStorage.getItem(scopedGalleryStorageKey());
    let serialized = scoped;
    if (!serialized && !localStorage.getItem(ownerKey)) {
      serialized = localStorage.getItem(GALLERY_STORAGE_KEY);
      localStorage.setItem(ownerKey, userId);
    }
    const parsed = serialized ? JSON.parse(serialized) : null;
    const snapshots = Array.isArray(parsed) ? parsed : INITIAL_SNAPSHOTS;
    saveSnapshots(snapshots);
    useGalleryStore.setState({ snapshots });
  } catch {
    // Keep the in-memory gallery if browser storage is unavailable.
  }
}
