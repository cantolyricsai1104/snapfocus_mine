import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/data/app_database.dart';
import 'package:mobile/data/task_repository.dart';
import 'package:mobile/domain/task.dart';

void main() {
  late AppDatabase database;
  late DriftTaskRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftTaskRepository(database);
  });

  tearDown(() async => database.close());

  test('round trips an ordered task list through SQLite', () async {
    final tasks = [
      TaskBlock(
        id: 'task-1',
        title: 'Learn Python Backend',
        durationMinutes: 45,
        type: TaskType.focus,
        color: '#FF6B00',
        scheduledTime: '09:30',
        date: '2026-09-17',
        repeat: TaskRepeat.none,
        completedDates: const ['2026-09-17'],
      ),
      TaskBlock(
        id: 'task-2',
        title: 'Coffee & Stretch Break',
        durationMinutes: 15,
        type: TaskType.breakTime,
        color: '#8B5CF6',
        scheduledTime: '10:30',
        date: '2026-09-17',
        repeat: TaskRepeat.daily,
      ),
    ];

    await repository.replaceAll(tasks);

    expect(await repository.list(), tasks);
  });
}
