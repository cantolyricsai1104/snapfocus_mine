import 'package:drift/drift.dart';

import '../domain/routine.dart';
import '../domain/routine_ports.dart';
import 'app_database.dart';

class DriftRoutineRepository implements RoutineRepository {
  DriftRoutineRepository(this.database);

  final AppDatabase database;

  @override
  Future<RoutineState?> loadActive() async {
    final row = await database
        .select(database.activeRoutines)
        .getSingleOrNull();
    if (row == null) return null;

    return RoutineState(
      id: row.id,
      phase: RoutinePhase.values.byName(row.phase),
      status: RoutineStatus.values.byName(row.status),
      focusDuration: Duration(seconds: row.focusDurationSeconds),
      breakDuration: Duration(seconds: row.breakDurationSeconds),
      startedAt: _dateTimeFromMicros(row.startedAtMicros),
      endsAt: _dateTimeFromMicros(row.endsAtMicros),
      pausedRemaining: row.pausedRemainingSeconds == null
          ? null
          : Duration(seconds: row.pausedRemainingSeconds!),
      progress: row.progress,
    );
  }

  @override
  Future<void> saveActive(RoutineState? state) async {
    await database.transaction(() async {
      await database.delete(database.activeRoutines).go();
      if (state == null) return;

      await database
          .into(database.activeRoutines)
          .insert(
            ActiveRoutinesCompanion.insert(
              id: state.id,
              phase: state.phase.name,
              status: state.status.name,
              focusDurationSeconds: state.focusDuration.inSeconds,
              breakDurationSeconds: state.breakDuration.inSeconds,
              startedAtMicros: Value(_microsFromDateTime(state.startedAt)),
              endsAtMicros: Value(_microsFromDateTime(state.endsAt)),
              pausedRemainingSeconds: Value(state.pausedRemaining?.inSeconds),
              progress: state.progress,
            ),
          );
    });
  }
}

DateTime? _dateTimeFromMicros(int? micros) {
  if (micros == null) return null;
  return DateTime.fromMicrosecondsSinceEpoch(micros);
}

int? _microsFromDateTime(DateTime? value) => value?.microsecondsSinceEpoch;
