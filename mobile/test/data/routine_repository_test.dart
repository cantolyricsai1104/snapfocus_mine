import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/data/app_database.dart';
import 'package:mobile/data/routine_repository.dart';
import 'package:mobile/domain/routine.dart';

void main() {
  late AppDatabase database;
  late DriftRoutineRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftRoutineRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('round trips a running routine through SQLite', () async {
    final state = RoutineState(
      id: 'routine-1',
      phase: RoutinePhase.focus,
      status: RoutineStatus.running,
      focusDuration: const Duration(minutes: 25),
      breakDuration: const Duration(minutes: 5),
      startedAt: DateTime(2026, 9, 16, 9),
      endsAt: DateTime(2026, 9, 16, 9, 25),
      pausedRemaining: null,
      progress: 0.4,
    );

    await repository.saveActive(state);

    expect(await repository.loadActive(), state);
  });

  test('clears the active routine from SQLite', () async {
    await repository.saveActive(_state());

    await repository.saveActive(null);

    expect(await repository.loadActive(), isNull);
  });
}

RoutineState _state() {
  return RoutineState(
    id: 'routine-1',
    phase: RoutinePhase.focus,
    status: RoutineStatus.running,
    focusDuration: const Duration(minutes: 25),
    breakDuration: const Duration(minutes: 5),
    startedAt: DateTime(2026, 9, 16, 9),
    endsAt: DateTime(2026, 9, 16, 9, 25),
    pausedRemaining: null,
    progress: 0,
  );
}
