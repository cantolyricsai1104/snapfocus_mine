import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/goal.dart';
import '../domain/goal_ports.dart';
import '../domain/routine_ports.dart';
import '../domain/snapshot.dart';
import '../domain/task.dart';
import '../domain/task_ports.dart';
import 'app_database.dart' hide Goal, Pillar;
import 'goal_repository.dart';
import 'snapshot_repository.dart';
import 'task_repository.dart';

class SupabaseSyncBridge {
  SupabaseSyncBridge({required this.client, required this.database});

  final SupabaseClient client;
  final AppDatabase database;
  String? _preparedUser;
  Future<void>? _preparing;

  String get userId {
    final id = client.auth.currentUser?.id;
    if (id == null) throw StateError('Sign in before syncing SnapFocus data.');
    return id;
  }

  Future<void> prepareAccount() {
    final id = userId;
    if (_preparedUser == id && _preparing != null) return _preparing!;
    _preparedUser = id;
    _preparing = _prepareAccount(id);
    return _preparing!;
  }

  Future<void> _prepareAccount(String id) async {
    await database.customStatement(
      'CREATE TABLE IF NOT EXISTS snapfocus_sync_state (key TEXT PRIMARY KEY, value TEXT NOT NULL)',
    );
    await database.customStatement(
      'CREATE TABLE IF NOT EXISTS snapfocus_sync_outbox (table_name TEXT NOT NULL, record_id TEXT NOT NULL, payload TEXT NOT NULL, deleted INTEGER NOT NULL DEFAULT 0, PRIMARY KEY(table_name, record_id))',
    );
    final row = await database
        .customSelect(
          'SELECT value FROM snapfocus_sync_state WHERE key = ?',
          variables: [Variable.withString('owner')],
        )
        .getSingleOrNull();
    final previousOwner = row?.read<String>('value');
    if (previousOwner != null && previousOwner != id) {
      await database.transaction(() async {
        await database.delete(database.tasks).go();
        await database.delete(database.goals).go();
        await database.delete(database.pillars).go();
        await database.delete(database.snapshots).go();
        await database.delete(database.goalProofNotes).go();
        await database.delete(database.activeRoutines).go();
        await database.customStatement('DELETE FROM snapfocus_sync_outbox');
      });
    }
    await database.customStatement(
      'INSERT INTO snapfocus_sync_state(key, value) VALUES (?, ?) ON CONFLICT(key) DO UPDATE SET value = excluded.value',
      [Variable.withString('owner'), Variable.withString(id)],
    );
  }

  Future<List<T>> loadTable<T>({
    required String table,
    required String conflict,
    required Future<List<T>> Function() readLocal,
    required Map<String, dynamic> Function(T) toCloud,
    Map<String, dynamic> Function(T, int)? toCloudIndexed,
    required T Function(Map<String, dynamic>) fromCloud,
    required String Function(T) idOf,
    required Future<void> Function(List<T>) writeLocal,
  }) async {
    await prepareAccount();
    final local = await readLocal();
    List<Map<String, dynamic>> remote;
    try {
      final result = table == 'tasks'
          ? await client
                .from(table)
                .select()
                .eq('user_id', userId)
                .order('position')
          : await client.from(table).select().eq('user_id', userId);
      remote = result.map((row) => Map<String, dynamic>.from(row)).toList();
    } catch (_) {
      return local;
    }

    final merged = <String, Map<String, dynamic>>{
      for (final row in remote) _rowKey(table, row): row,
    };
    final remoteWasEmpty = remote.isEmpty;
    for (var index = 0; index < local.length; index++) {
      final item = local[index];
      final row = (toCloudIndexed?.call(item, index) ?? toCloud(item))
        ..['user_id'] = userId;
      final key = _rowKey(table, row);
      if (remoteWasEmpty || !merged.containsKey(key)) {
        row['updated_at'] = DateTime.now().toUtc().toIso8601String();
        merged[key] = row;
        await _queue(table, key, row);
      }
    }

    final outbox = await _outbox(table);
    for (final mutation in outbox) {
      final row =
          jsonDecode(mutation.read<String>('payload')) as Map<String, dynamic>;
      final key = mutation.read<String>('record_id');
      if (mutation.read<int>('deleted') == 1) {
        merged.remove(key);
      } else {
        merged[key] = row;
      }
    }

    final values = merged.values
        .map((row) => fromCloud(Map<String, dynamic>.from(row)))
        .toList(growable: false);
    await writeLocal(values);
    await flush(table, conflict);
    return values;
  }

  Future<void> replaceTable<T>({
    required String table,
    required String conflict,
    required Future<List<T>> Function() readLocal,
    required List<T> items,
    required Map<String, dynamic> Function(T) toCloud,
    Map<String, dynamic> Function(T, int)? toCloudIndexed,
    required String Function(T) idOf,
    required Future<void> Function(List<T>) writeLocal,
  }) async {
    await prepareAccount();
    final before = await readLocal();
    await writeLocal(items);
    final oldById = {
      for (var index = 0; index < before.length; index++)
        idOf(before[index]): (item: before[index], index: index),
    };
    final newById = {for (final item in items) idOf(item): item};
    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      final id = idOf(item);
      final old = oldById[id];
      final currentRow = (toCloudIndexed?.call(item, index) ?? toCloud(item))
        ..['user_id'] = userId;
      if (old == null ||
          _comparable(
                toCloudIndexed?.call(old.item, old.index) ?? toCloud(old.item),
              ) !=
              _comparable(toCloudIndexed?.call(item, index) ?? toCloud(item))) {
        currentRow['updated_at'] = DateTime.now().toUtc().toIso8601String();
        await _queue(table, _rowKey(table, currentRow), currentRow);
      }
    }
    for (final old in oldById.entries.where(
      (entry) => !newById.containsKey(entry.key),
    )) {
      final row =
          (toCloudIndexed?.call(old.value.item, old.value.index) ??
                toCloud(old.value.item))
            ..['user_id'] = userId;
      await _queueDelete(table, _rowKey(table, row), row);
    }
    await flush(table, conflict);
  }

  Future<void> enqueuePhoto(CapturedPhoto photo) async {
    await prepareAccount();
    final suffix = photo.path.toLowerCase().split('.').last;
    final extension = {'jpg', 'jpeg', 'png', 'webp'}.contains(suffix)
        ? suffix
        : 'jpg';
    final objectPath = '$userId/${photo.id}.$extension';
    await _queue('proof_photos', photo.id, {
      'user_id': userId,
      'id': photo.id,
      'task_id': null,
      'task_title': photo.taskTitle,
      'goal_id': photo.goalId,
      'object_path': objectPath,
      'remote_url': null,
      'captured_at': photo.capturedAt.toUtc().toIso8601String(),
      'focus_minutes': null,
      'local_path': photo.path,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
    await flush('proof_photos', 'user_id,id');
  }

  Future<List<CapturedPhoto>> syncPhotos(DriftSnapshotRepository local) async {
    await prepareAccount();
    final localPhotos = await local.list();
    try {
      final rows = await client
          .from('proof_photos')
          .select()
          .eq('user_id', userId)
          .order('captured_at', ascending: false);
      final remoteIds = rows.map((row) => row['id'] as String).toSet();
      for (final photo in localPhotos.where(
        (item) => !remoteIds.contains(item.id),
      )) {
        await enqueuePhoto(photo);
      }
      final directory = kIsWeb
          ? null
          : await getApplicationDocumentsDirectory();
      final downloaded = <CapturedPhoto>[];
      for (final row in rows) {
        final id = row['id'] as String;
        final objectPath = row['object_path'] as String?;
        String? path;
        if (objectPath != null) {
          if (kIsWeb) {
            final signed = await client.storage
                .from('snapfocus-proofs')
                .createSignedUrl(objectPath, 60 * 60);
            path = signed;
          } else {
            final file = File(
              '${directory!.path}/snapfocus-${id.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')}.${objectPath.split('.').last}',
            );
            if (!await file.exists()) {
              final bytes = await client.storage
                  .from('snapfocus-proofs')
                  .download(objectPath);
              await file.writeAsBytes(bytes, flush: true);
            }
            path = file.path;
          }
        } else if (row['remote_url'] != null) {
          path = kIsWeb
              ? row['remote_url'] as String
              : await _cacheRemoteImage(
                  row['remote_url'] as String,
                  directory!.path,
                  id,
                );
        }
        if (path == null) continue;
        final photo = CapturedPhoto(
          id: id,
          path: path,
          capturedAt: DateTime.parse(row['captured_at'] as String).toLocal(),
          routineId: null,
          taskTitle: row['task_title'] as String?,
          goalId: row['goal_id'] as String?,
        );
        if (!localPhotos.any((item) => item.id == id)) await local.add(photo);
        downloaded.add(photo);
      }
      return downloaded;
    } catch (_) {
      return localPhotos;
    }
  }

  Future<void> syncNotes(DriftSnapshotRepository local, String goalId) async {
    await prepareAccount();
    final localNotes = await local.listNotes(goalId);
    try {
      final rows = await client
          .from('proof_notes')
          .select()
          .eq('user_id', userId)
          .eq('goal_id', goalId);
      final merged = <String, Map<String, dynamic>>{
        for (final row in rows)
          row['note_date'] as String: Map<String, dynamic>.from(row),
      };
      for (final mutation in await _outbox('proof_notes')) {
        final row =
            jsonDecode(mutation.read<String>('payload'))
                as Map<String, dynamic>;
        if (row['goal_id'] != goalId) continue;
        final date = row['note_date'] as String;
        if (mutation.read<int>('deleted') == 1) {
          merged.remove(date);
        } else {
          merged[date] = row;
        }
      }
      for (final row in merged.values) {
        await local.saveNote(
          ProofDayNote(
            goalId: goalId,
            date: row['note_date'] as String,
            note: row['note'] as String?,
          ),
        );
      }
      final cloudDays = rows.map((row) => row['note_date'] as String).toSet();
      for (final note in localNotes.where(
        (item) => !cloudDays.contains(item.date),
      )) {
        await _queue('proof_notes', '${note.goalId}::${note.date}', {
          'user_id': userId,
          'goal_id': note.goalId,
          'note_date': note.date,
          'note': note.note,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        });
      }
      await flush('proof_notes', 'user_id,goal_id,note_date');
    } catch (_) {
      // Keep the local proof notes available when offline or before migration.
    }
  }

  Future<void> saveProofNote(ProofDayNote note) async {
    await prepareAccount();
    await _queue('proof_notes', '${note.goalId}::${note.date}', {
      'user_id': userId,
      'goal_id': note.goalId,
      'note_date': note.date,
      'note': note.note,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
    await flush('proof_notes', 'user_id,goal_id,note_date');
  }

  Future<void> deleteProofNotes(
    DriftSnapshotRepository local,
    String goalId,
  ) async {
    await prepareAccount();
    final existing = await local.listNotes(goalId);
    for (final note in existing) {
      await _queueDelete('proof_notes', '${note.goalId}::${note.date}', {
        'user_id': userId,
        'goal_id': note.goalId,
        'note_date': note.date,
      });
    }
    await local.deleteNotes(goalId);
    await flush('proof_notes', 'user_id,goal_id,note_date');
  }

  Future<void> deletePhoto(DriftSnapshotRepository local, String id) async {
    await prepareAccount();
    await local.delete(id);
    try {
      final response = await client
          .from('proof_photos')
          .select('object_path')
          .eq('user_id', userId)
          .eq('id', id)
          .maybeSingle();
      final objectPath = response?['object_path'] as String?;
      if (objectPath != null) {
        await client.storage.from('snapfocus-proofs').remove([objectPath]);
      }
      await client
          .from('proof_photos')
          .delete()
          .eq('user_id', userId)
          .eq('id', id);
    } catch (_) {
      await _queueDelete('proof_photos', id, {'user_id': userId, 'id': id});
    }
  }

  Future<void> clearPhotos(DriftSnapshotRepository local) async {
    await prepareAccount();
    final photos = await local.list();
    for (final photo in photos) {
      await deletePhoto(local, photo.id);
    }
    await local.clearAll();
  }

  Future<void> _queue(String table, String id, Map<String, dynamic> row) async {
    await database.customStatement(
      'INSERT INTO snapfocus_sync_outbox(table_name, record_id, payload, deleted) VALUES (?, ?, ?, 0) ON CONFLICT(table_name, record_id) DO UPDATE SET payload = excluded.payload, deleted = 0',
      [
        Variable.withString(table),
        Variable.withString(id),
        Variable.withString(jsonEncode(row)),
      ],
    );
  }

  Future<void> _queueDelete(
    String table,
    String id,
    Map<String, dynamic> identity,
  ) async {
    await database.customStatement(
      'INSERT INTO snapfocus_sync_outbox(table_name, record_id, payload, deleted) VALUES (?, ?, ?, 1) ON CONFLICT(table_name, record_id) DO UPDATE SET payload = excluded.payload, deleted = 1',
      [
        Variable.withString(table),
        Variable.withString(id),
        Variable.withString(jsonEncode(identity)),
      ],
    );
  }

  Future<List<QueryRow>> _outbox(String table) => database
      .customSelect(
        'SELECT record_id, payload, deleted FROM snapfocus_sync_outbox WHERE table_name = ?',
        variables: [Variable.withString(table)],
      )
      .get();

  Future<void> flush(String table, String conflict) async {
    final rows = await _outbox(table);
    for (final mutation in rows) {
      final key = mutation.read<String>('record_id');
      final payload =
          jsonDecode(mutation.read<String>('payload')) as Map<String, dynamic>;
      try {
        if (mutation.read<int>('deleted') == 1) {
          if (table == 'proof_notes') {
            await client
                .from(table)
                .delete()
                .eq('user_id', userId)
                .eq('goal_id', payload['goal_id'])
                .eq('note_date', payload['note_date']);
          } else {
            if (table == 'proof_photos') {
              final path = payload['object_path'] as String?;
              if (path != null) {
                await client.storage.from('snapfocus-proofs').remove([path]);
              }
            }
            await client
                .from(table)
                .delete()
                .eq('user_id', userId)
                .eq('id', payload['id'] ?? key);
          }
        } else {
          if (table == 'proof_photos') {
            final localPath = payload.remove('local_path') as String?;
            final objectPath = payload['object_path'] as String;
            if (localPath != null) {
              final file = File(localPath);
              if (await file.exists()) {
                final extension = objectPath.split('.').last.toLowerCase();
                final mime = extension == 'png'
                    ? 'image/png'
                    : extension == 'webp'
                    ? 'image/webp'
                    : 'image/jpeg';
                await client.storage
                    .from('snapfocus-proofs')
                    .upload(
                      objectPath,
                      file,
                      fileOptions: FileOptions(upsert: true, contentType: mime),
                    );
              } else {
                throw StateError(
                  'Photo file is no longer available on this device.',
                );
              }
            }
          }
          await client.from(table).upsert(payload, onConflict: conflict);
        }
        await database.customStatement(
          'DELETE FROM snapfocus_sync_outbox WHERE table_name = ? AND record_id = ?',
          [Variable.withString(table), Variable.withString(key)],
        );
      } catch (_) {
        // Leave the mutation queued; it will retry on next app resume or edit.
      }
    }
  }

  String _rowKey(String table, Map<String, dynamic> row) =>
      table == 'proof_notes'
      ? '${row['goal_id']}::${row['note_date']}'
      : row['id'] as String;

  String _comparable(Map<String, dynamic> row) {
    final comparable = Map<String, dynamic>.from(row)
      ..remove('updated_at')
      ..remove('user_id');
    return jsonEncode(comparable);
  }
}

class SupabaseTaskRepository implements TaskRepository {
  SupabaseTaskRepository({required this.local, required this.sync});
  final DriftTaskRepository local;
  final SupabaseSyncBridge sync;

  @override
  Future<List<TaskBlock>> list() => sync.loadTable(
    table: 'tasks',
    conflict: 'user_id,id',
    readLocal: local.list,
    idOf: (task) => task.id,
    toCloud: _taskToRow,
    toCloudIndexed: (task, index) => _taskToRow(task)..['position'] = index,
    fromCloud: _taskFromRow,
    writeLocal: local.replaceAll,
  );

  @override
  Future<void> replaceAll(List<TaskBlock> tasks) => sync.replaceTable(
    table: 'tasks',
    conflict: 'user_id,id',
    readLocal: local.list,
    items: tasks,
    idOf: (task) => task.id,
    toCloud: _taskToRow,
    toCloudIndexed: (task, index) => _taskToRow(task)..['position'] = index,
    writeLocal: local.replaceAll,
  );
}

class SupabaseGoalRepository implements GoalRepository {
  SupabaseGoalRepository({required this.local, required this.sync});
  final DriftGoalRepository local;
  final SupabaseSyncBridge sync;

  @override
  Future<List<Pillar>> listPillars() => sync.loadTable<Pillar>(
    table: 'pillars',
    conflict: 'user_id,id',
    readLocal: local.listPillars,
    idOf: (item) => item.id,
    toCloud: _pillarToRow,
    fromCloud: _pillarFromRow,
    writeLocal: local.replacePillars,
  );

  @override
  Future<List<Goal>> listGoals() => sync.loadTable<Goal>(
    table: 'goals',
    conflict: 'user_id,id',
    readLocal: local.listGoals,
    idOf: (item) => item.id,
    toCloud: _goalToRow,
    fromCloud: _goalFromRow,
    writeLocal: local.replaceGoals,
  );

  @override
  Future<void> replacePillars(List<Pillar> pillars) =>
      sync.replaceTable<Pillar>(
        table: 'pillars',
        conflict: 'user_id,id',
        readLocal: local.listPillars,
        items: pillars,
        idOf: (item) => item.id,
        toCloud: _pillarToRow,
        writeLocal: local.replacePillars,
      );

  @override
  Future<void> replaceGoals(List<Goal> goals) => sync.replaceTable<Goal>(
    table: 'goals',
    conflict: 'user_id,id',
    readLocal: local.listGoals,
    items: goals,
    idOf: (item) => item.id,
    toCloud: _goalToRow,
    writeLocal: local.replaceGoals,
  );
}

class SupabaseSnapshotRepository implements SnapshotRepository {
  SupabaseSnapshotRepository({required this.local, required this.sync});
  final DriftSnapshotRepository local;
  final SupabaseSyncBridge sync;

  @override
  Future<void> add(CapturedPhoto photo) async {
    await local.add(photo);
    await sync.enqueuePhoto(photo);
  }

  @override
  Future<void> saveNote(ProofDayNote note) async {
    await local.saveNote(note);
    await sync.saveProofNote(note);
  }

  @override
  Future<List<ProofDayNote>> listNotes(String goalId) async {
    await sync.syncNotes(local, goalId);
    return local.listNotes(goalId);
  }

  @override
  Future<void> deleteNotes(String goalId) =>
      sync.deleteProofNotes(local, goalId);

  @override
  Future<List<CapturedPhoto>> list() => sync.syncPhotos(local);

  @override
  Future<void> delete(String id) => sync.deletePhoto(local, id);

  @override
  Future<void> clearAll() => sync.clearPhotos(local);
}

Map<String, dynamic> _taskToRow(TaskBlock item) => {
  'id': item.id,
  'title': item.title,
  'duration_minutes': item.durationMinutes,
  'type': item.type == TaskType.breakTime ? 'break' : 'focus',
  'color': item.color,
  'scheduled_time': item.scheduledTime,
  'task_date': item.date,
  'repeat_rule': item.repeat.name,
  'repeat_until': item.repeatUntil,
  'completed': item.completed,
  'completed_dates': item.completedDates,
  'goal_id': item.goalId,
  'repeat_days': item.repeatDays,
  'repeat_month_day': item.repeatMonthDay,
};

TaskBlock _taskFromRow(Map<String, dynamic> row) => TaskBlock(
  id: row['id'] as String,
  title: row['title'] as String,
  durationMinutes: (row['duration_minutes'] as num).toInt(),
  type: row['type'] == 'break' ? TaskType.breakTime : TaskType.focus,
  color: row['color'] as String,
  scheduledTime: row['scheduled_time'] as String?,
  date: row['task_date'] as String,
  repeat: TaskRepeat.values.byName(row['repeat_rule'] as String),
  repeatUntil: row['repeat_until'] as String?,
  completed: row['completed'] as bool,
  completedDates: (row['completed_dates'] as List? ?? [])
      .map((item) => item.toString())
      .toList(),
  goalId: row['goal_id'] as String?,
  repeatDays: (row['repeat_days'] as List? ?? [])
      .map((item) => (item as num).toInt())
      .toList(),
  repeatMonthDay: (row['repeat_month_day'] as num?)?.toInt(),
);

Map<String, dynamic> _pillarToRow(Pillar item) => {
  'id': item.id,
  'name': item.name,
  'color': item.color,
  'emoji': item.emoji,
};

Pillar _pillarFromRow(Map<String, dynamic> row) => Pillar(
  id: row['id'] as String,
  name: row['name'] as String,
  color: row['color'] as String,
  emoji: row['emoji'] as String,
);

Map<String, dynamic> _goalToRow(Goal item) => {
  'id': item.id,
  'pillar_id': item.pillarId,
  'name': item.name,
  'metric_type': item.metricType.name,
  'target_value': item.targetValue,
  'current_value': item.currentValue,
  'unit': item.unit,
  'task_title': item.taskTitle,
  'task_weekdays': item.taskWeekdays,
  'task_duration_minutes': item.taskDurationMinutes,
  'task_time': item.taskTime,
  'duration_months': item.durationMonths,
  'duration_weeks': item.durationWeeks,
  'duration_value': item.durationValue,
  'duration_unit': item.durationUnit.name,
  'started_on': item.startedOn,
  'task_repeat': item.taskRepeat.name,
  'task_month_day': item.taskMonthDay,
};

Goal _goalFromRow(Map<String, dynamic> row) => Goal(
  id: row['id'] as String,
  pillarId: row['pillar_id'] as String,
  name: row['name'] as String,
  metricType: GoalMetricType.values.byName(row['metric_type'] as String),
  targetValue: (row['target_value'] as num).toDouble(),
  currentValue: (row['current_value'] as num).toDouble(),
  unit: row['unit'] as String,
  taskTitle: row['task_title'] as String?,
  taskWeekdays: (row['task_weekdays'] as List? ?? [])
      .map((item) => (item as num).toInt())
      .toList(),
  taskDurationMinutes: (row['task_duration_minutes'] as num).toInt(),
  taskTime: row['task_time'] as String?,
  durationMonths: (row['duration_months'] as num).toInt(),
  durationWeeks: (row['duration_weeks'] as num).toInt(),
  durationValue: (row['duration_value'] as num).toInt(),
  durationUnit: GoalDurationUnit.values.byName(row['duration_unit'] as String),
  startedOn: row['started_on'] as String?,
  taskRepeat: TaskRepeat.values.byName(row['task_repeat'] as String),
  taskMonthDay: (row['task_month_day'] as num).toInt(),
);

Future<String> _cacheRemoteImage(
  String url,
  String directory,
  String id,
) async {
  final safeId = id.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
  final file = File('$directory/snapfocus-$safeId.jpg');
  if (await file.exists()) return file.path;
  final request = await HttpClient().getUrl(Uri.parse(url));
  final response = await request.close();
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw HttpException(
      'Could not download synced proof image (${response.statusCode}).',
    );
  }
  await file.writeAsBytes(
    await response.fold<List<int>>([], (bytes, chunk) => bytes..addAll(chunk)),
    flush: true,
  );
  return file.path;
}
