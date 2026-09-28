import type { SupabaseClient } from '@supabase/supabase-js';
import type { FocusSnapshot, TaskBlock } from '../types';
import { useTaskStore } from '../store/useTaskStore';
import { useGalleryStore } from '../store/useGalleryStore';

const bucket = 'snapfocus-proofs';
const exampleSnapshotIds = new Set(['snap-1', 'snap-2', 'snap-3']);

function taskFromRow(row: Record<string, any>): TaskBlock {
  return {
    id: row.id,
    title: row.title,
    durationMinutes: row.duration_minutes,
    type: row.type,
    color: row.color,
    scheduledTime: row.scheduled_time ?? undefined,
    date: row.task_date,
    repeat: row.repeat_rule,
    repeatUntil: row.repeat_until ?? undefined,
    completed: row.completed,
    completedDates: row.completed_dates ?? [],
    goalId: row.goal_id ?? undefined,
    repeatDays: row.repeat_days ?? [],
    repeatMonthDay: row.repeat_month_day ?? undefined,
  };
}

function taskToRow(task: TaskBlock, userId: string, position: number) {
  return {
    user_id: userId,
    id: task.id,
    title: task.title,
    duration_minutes: task.durationMinutes,
    type: task.type,
    color: task.color ?? (task.type === 'focus' ? '#FF6B00' : '#8B5CF6'),
    scheduled_time: task.scheduledTime ?? null,
    task_date: task.date,
    repeat_rule: task.repeat ?? 'none',
    repeat_until: task.repeatUntil ?? null,
    completed: task.completed ?? false,
    completed_dates: task.completedDates ?? [],
    goal_id: task.goalId ?? null,
    repeat_days: task.repeatDays ?? [],
    repeat_month_day: task.repeatMonthDay ?? null,
    position,
    updated_at: new Date().toISOString(),
  };
}

function snapshotFromRow(row: Record<string, any>, photoUri: string): FocusSnapshot {
  return {
    id: row.id,
    taskId: row.task_id ?? '',
    taskTitle: row.task_title ?? 'Focus session',
    photoUri,
    timestamp: row.captured_at,
    focusMinutesCompleted: row.focus_minutes ?? undefined,
  };
}

async function snapshotToRow(
  client: SupabaseClient,
  userId: string,
  snapshot: FocusSnapshot,
) {
  let objectPath: string | null = null;
  let remoteUrl: string | null = null;
  if (snapshot.photoUri.startsWith('data:')) {
    const blob = await fetch(snapshot.photoUri).then((response) => response.blob());
    const extension = blob.type.includes('png') ? 'png' : 'jpg';
    objectPath = `${userId}/${snapshot.id}.${extension}`;
    const { error } = await client.storage.from(bucket).upload(objectPath, blob, {
      upsert: true,
      contentType: blob.type || 'image/jpeg',
    });
    if (error && !/already exists/i.test(error.message)) throw error;
  } else {
    remoteUrl = snapshot.photoUri;
  }
  return {
    user_id: userId,
    id: snapshot.id,
    task_id: snapshot.taskId,
    task_title: snapshot.taskTitle,
    goal_id: null,
    object_path: objectPath,
    remote_url: remoteUrl,
    captured_at: snapshot.timestamp,
    focus_minutes: snapshot.focusMinutesCompleted ?? null,
    updated_at: new Date().toISOString(),
  };
}

async function loadSnapshots(client: SupabaseClient, userId: string) {
  const { data, error } = await client
    .from('proof_photos')
    .select('*')
    .eq('user_id', userId)
    .order('captured_at', { ascending: false });
  if (error) throw error;
  const snapshots: FocusSnapshot[] = [];
  for (const row of data ?? []) {
    let uri = row.remote_url as string | null;
    if (row.object_path) {
      const { data: signed, error: signedError } = await client.storage
        .from(bucket)
        .createSignedUrl(row.object_path, 60 * 60);
      if (signedError) throw signedError;
      uri = signed.signedUrl;
    }
    if (uri) snapshots.push(snapshotFromRow(row, uri));
  }
  return snapshots;
}

/** Initial pull/migration plus online persistence for the web client's stores. */
export async function connectCloudStores(client: SupabaseClient, userId: string) {
  const localTasks = useTaskStore.getState().tasks;
  const { data: remoteRows, error: taskError } = await client
    .from('tasks')
    .select('*')
    .eq('user_id', userId)
    .order('position');
  if (taskError) throw taskError;

  let tasks: TaskBlock[];
  if (!remoteRows?.length) {
    tasks = localTasks;
    if (tasks.length) {
      const { error } = await client
        .from('tasks')
        .upsert(tasks.map((task, index) => taskToRow(task, userId, index)), {
          onConflict: 'user_id,id',
        });
      if (error) throw error;
    }
  } else {
    const remoteTasks = remoteRows.map(taskFromRow);
    const remoteIds = new Set(remoteTasks.map((task) => task.id));
    const localOnly = localTasks.filter((task) => !remoteIds.has(task.id));
    tasks = [...remoteTasks, ...localOnly];
    if (localOnly.length) {
      const { error } = await client.from('tasks').upsert(
        localOnly.map((task) => taskToRow(task, userId, tasks.indexOf(task))),
        { onConflict: 'user_id,id' },
      );
      if (error) throw error;
    }
  }
  useTaskStore.getState().setTasks(tasks);

  const localSnapshots = useGalleryStore.getState().snapshots.filter(
    (snapshot) => !exampleSnapshotIds.has(snapshot.id),
  );
  let snapshots = await loadSnapshots(client, userId);
  if (!snapshots.length && localSnapshots.length) {
    for (const snapshot of localSnapshots) {
      const row = await snapshotToRow(client, userId, snapshot);
      const { error } = await client.from('proof_photos').upsert(row, {
        onConflict: 'user_id,id',
      });
      if (error) throw error;
    }
    snapshots = localSnapshots;
  } else if (snapshots.length) {
    const remoteIds = new Set(snapshots.map((snapshot) => snapshot.id));
    const localOnly = localSnapshots.filter((snapshot) => !remoteIds.has(snapshot.id));
    for (const snapshot of localOnly) {
      const row = await snapshotToRow(client, userId, snapshot);
      const { error } = await client.from('proof_photos').upsert(row, {
        onConflict: 'user_id,id',
      });
      if (error) throw error;
    }
    snapshots = [...snapshots, ...localOnly];
  }
  useGalleryStore.getState().setSnapshots(snapshots);

  let previousTasks = tasks;
  let previousSnapshots = snapshots;
  let taskTimer: number | undefined;
  let photoTimer: number | undefined;
  let disposed = false;

  const persistTasks = async (current: TaskBlock[]) => {
    const before = new Map(previousTasks.map((task, index) => [task.id, { task, index }]));
    const afterIds = new Set(current.map((task) => task.id));
    const changed = current.flatMap((task, index) => {
      const old = before.get(task.id);
      return !old || old.index !== index || JSON.stringify(old.task) !== JSON.stringify(task)
        ? [taskToRow(task, userId, index)]
        : [];
    });
    const removed = [...before.keys()].filter((id) => !afterIds.has(id));
    if (changed.length) {
      const { error } = await client.from('tasks').upsert(changed, { onConflict: 'user_id,id' });
      if (error) throw error;
    }
    if (removed.length) {
      const { error } = await client.from('tasks').delete().eq('user_id', userId).in('id', removed);
      if (error) throw error;
    }
    previousTasks = current;
  };

  const persistSnapshots = async (current: FocusSnapshot[]) => {
    const before = new Map(previousSnapshots.map((snapshot) => [snapshot.id, snapshot]));
    const afterIds = new Set(current.map((snapshot) => snapshot.id));
    const changed = current.filter((snapshot) => {
      const old = before.get(snapshot.id);
      return !old || JSON.stringify(old) !== JSON.stringify(snapshot);
    });
    const removed = [...before.keys()].filter((id) => !afterIds.has(id));
    for (const snapshot of changed) {
      const row = await snapshotToRow(client, userId, snapshot);
      const { error } = await client.from('proof_photos').upsert(row, { onConflict: 'user_id,id' });
      if (error) throw error;
    }
    previousSnapshots = current;
    if (removed.length) {
      const { error } = await client.from('proof_photos').delete().eq('user_id', userId).in('id', removed);
      if (error) throw error;
    }
  };

  const unsubTasks = useTaskStore.subscribe((state) => {
    const current = state.tasks;
    if (current === previousTasks) return;
    window.clearTimeout(taskTimer);
    taskTimer = window.setTimeout(() => {
      void persistTasks(current).catch((error) => console.error('Task sync failed', error));
    }, 250);
  });
  const unsubSnapshots = useGalleryStore.subscribe((state) => {
    const current = state.snapshots;
    if (current === previousSnapshots) return;
    window.clearTimeout(photoTimer);
    photoTimer = window.setTimeout(() => {
      void persistSnapshots(current).catch((error) => console.error('Proof sync failed', error));
    }, 250);
  });

  const refreshRemote = async (table: 'tasks' | 'proof_photos') => {
    if (disposed) return;
    if (table === 'tasks') {
      const { data, error } = await client.from('tasks').select('*').eq('user_id', userId).order('position');
      if (error) throw error;
      const refreshed = (data ?? []).map(taskFromRow);
      previousTasks = refreshed;
      useTaskStore.getState().setTasks(refreshed);
    } else {
      const refreshed = await loadSnapshots(client, userId);
      previousSnapshots = refreshed;
      useGalleryStore.getState().setSnapshots(refreshed);
    }
  };

  const channel = client.channel(`snapfocus-${userId}`)
    .on('postgres_changes', { event: '*', schema: 'public', table: 'tasks', filter: `user_id=eq.${userId}` }, () => {
      void refreshRemote('tasks').catch((error) => console.error('Task refresh failed', error));
    })
    .on('postgres_changes', { event: '*', schema: 'public', table: 'proof_photos', filter: `user_id=eq.${userId}` }, () => {
      void refreshRemote('proof_photos').catch((error) => console.error('Proof refresh failed', error));
    })
    .subscribe((status) => {
      if (status !== 'SUBSCRIBED' || disposed) return;
      void (async () => {
        await persistTasks(useTaskStore.getState().tasks);
        await persistSnapshots(useGalleryStore.getState().snapshots);
        await refreshRemote('tasks');
        await refreshRemote('proof_photos');
      })().catch((error) => console.error('Cloud reconnection sync failed', error));
    });

  return () => {
    disposed = true;
    window.clearTimeout(taskTimer);
    window.clearTimeout(photoTimer);
    unsubTasks();
    unsubSnapshots();
    void client.removeChannel(channel);
  };
}
