import 'package:drift/drift.dart';

import '../domain/routine_ports.dart';
import '../domain/snapshot.dart';
import 'app_database.dart';

class DriftSnapshotRepository implements SnapshotRepository {
  DriftSnapshotRepository(this.database);

  final AppDatabase database;

  @override
  Future<void> add(CapturedPhoto photo) async {
    await database
        .into(database.snapshots)
        .insert(
          SnapshotsCompanion.insert(
            id: photo.id,
            path: photo.path,
            capturedAtMicros: photo.capturedAt.microsecondsSinceEpoch,
            routineId: Value(photo.routineId),
            taskTitle: Value(photo.taskTitle),
            goalId: Value(photo.goalId),
          ),
        );
  }

  @override
  Future<void> saveNote(ProofDayNote note) async {
    await _ensureNotesTable();
    await database
        .into(database.goalProofNotes)
        .insertOnConflictUpdate(
          GoalProofNotesCompanion.insert(
            goalId: note.goalId,
            date: note.date,
            note: Value(note.note),
          ),
        );
  }

  @override
  Future<List<ProofDayNote>> listNotes(String goalId) async {
    await _ensureNotesTable();
    final rows =
        await (database.select(database.goalProofNotes)
              ..where((row) => row.goalId.equals(goalId))
              ..orderBy([(row) => OrderingTerm.asc(row.date)]))
            .get();
    return rows
        .map(
          (row) =>
              ProofDayNote(goalId: row.goalId, date: row.date, note: row.note),
        )
        .toList(growable: false);
  }

  @override
  Future<void> deleteNotes(String goalId) async {
    await _ensureNotesTable();
    await (database.delete(
      database.goalProofNotes,
    )..where((note) => note.goalId.equals(goalId))).go();
  }

  Future<void> _ensureNotesTable() => database.customStatement(
    'CREATE TABLE IF NOT EXISTS goal_proof_notes ('
    'goal_id TEXT NOT NULL, date TEXT NOT NULL, note TEXT NULL, '
    'PRIMARY KEY (goal_id, date))',
  );

  @override
  Future<List<CapturedPhoto>> list() async {
    final rows = await (database.select(
      database.snapshots,
    )..orderBy([(table) => OrderingTerm.desc(table.capturedAtMicros)])).get();
    return rows.map(_toPhoto).toList(growable: false);
  }

  @override
  Future<void> delete(String id) async {
    await (database.delete(
      database.snapshots,
    )..where((row) => row.id.equals(id))).go();
  }

  @override
  Future<void> clearAll() async {
    await database.delete(database.snapshots).go();
  }
}

CapturedPhoto _toPhoto(Snapshot row) {
  return CapturedPhoto(
    id: row.id,
    path: row.path,
    capturedAt: DateTime.fromMicrosecondsSinceEpoch(row.capturedAtMicros),
    routineId: row.routineId,
    taskTitle: row.taskTitle,
    goalId: row.goalId,
  );
}
