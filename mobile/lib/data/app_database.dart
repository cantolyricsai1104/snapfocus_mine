import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class ActiveRoutines extends Table {
  TextColumn get id => text()();
  TextColumn get phase => text()();
  TextColumn get status => text()();
  IntColumn get focusDurationSeconds => integer()();
  IntColumn get breakDurationSeconds => integer()();
  IntColumn get startedAtMicros => integer().nullable()();
  IntColumn get endsAtMicros => integer().nullable()();
  IntColumn get pausedRemainingSeconds => integer().nullable()();
  RealColumn get progress => real()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Snapshots extends Table {
  TextColumn get id => text()();
  TextColumn get path => text()();
  IntColumn get capturedAtMicros => integer()();
  TextColumn get routineId => text().nullable()();
  TextColumn get taskTitle => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get durationMinutes => integer()();
  TextColumn get type => text()();
  TextColumn get color => text()();
  TextColumn get scheduledTime => text().nullable()();
  TextColumn get date => text()();
  TextColumn get repeat => text()();
  TextColumn get repeatUntil => text().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  TextColumn get completedDates => text()();
  IntColumn get position => integer()();
  TextColumn get goalId => text().nullable()();
  TextColumn get repeatDays => text().withDefault(const Constant('[]'))();
  IntColumn get repeatMonthDay => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Pillars extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get color => text()();
  TextColumn get emoji => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Goals extends Table {
  TextColumn get id => text()();
  TextColumn get pillarId => text()();
  TextColumn get name => text()();
  TextColumn get metricType => text()();
  RealColumn get targetValue => real()();
  RealColumn get currentValue => real().withDefault(const Constant(0))();
  TextColumn get unit => text()();
  TextColumn get period => text().withDefault(const Constant('once'))();
  TextColumn get periodKey => text().withDefault(const Constant('all'))();
  TextColumn get taskTitle => text().nullable()();
  TextColumn get taskWeekdays => text().withDefault(const Constant('[]'))();
  IntColumn get taskDurationMinutes =>
      integer().withDefault(const Constant(25))();
  TextColumn get taskTime => text().nullable()();
  IntColumn get durationMonths => integer().withDefault(const Constant(3))();
  IntColumn get durationWeeks => integer().withDefault(const Constant(0))();
  IntColumn get durationValue => integer().withDefault(const Constant(3))();
  TextColumn get durationUnit => text().withDefault(const Constant('month'))();
  TextColumn get startedOn => text().nullable()();
  TextColumn get taskRepeat => text().withDefault(const Constant('weekly'))();
  IntColumn get taskMonthDay => integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [ActiveRoutines, Snapshots, Tasks, Pillars, Goals])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(
        executor ??
            driftDatabase(
              name: 'snapfocus',
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.dart.js'),
              ),
            ),
      );

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(snapshots);
      }
      if (from < 3) {
        await m.createTable(tasks);
      }
      if (from < 4) {
        if (from >= 3) await m.addColumn(tasks, tasks.goalId);
        await m.createTable(pillars);
        await m.createTable(goals);
      }
      if (from < 5) {
        if (from >= 3) await m.addColumn(tasks, tasks.repeatDays);
        if (from >= 4) {
          await m.addColumn(goals, goals.period);
          await m.addColumn(goals, goals.periodKey);
          await m.addColumn(goals, goals.taskTitle);
          await m.addColumn(goals, goals.taskWeekdays);
          await m.addColumn(goals, goals.taskDurationMinutes);
          await m.addColumn(goals, goals.taskTime);
        }
      }
      if (from < 6) {
        if (from >= 3) await m.addColumn(tasks, tasks.repeatMonthDay);
        if (from >= 4) {
          await m.addColumn(goals, goals.durationMonths);
          await m.addColumn(goals, goals.durationWeeks);
          await m.addColumn(goals, goals.startedOn);
          await m.addColumn(goals, goals.taskRepeat);
          await m.addColumn(goals, goals.taskMonthDay);
        }
      }
      if (from < 9 && from >= 4) {
        final columns = await customSelect('PRAGMA table_info(goals)').get();
        final names = columns.map((column) => column.read<String>('name')).toSet();
        if (!names.contains('duration_value')) {
          await customStatement(
            'ALTER TABLE goals ADD COLUMN duration_value INTEGER NOT NULL DEFAULT 3',
          );
        }
        if (!names.contains('duration_unit')) {
          await customStatement(
            "ALTER TABLE goals ADD COLUMN duration_unit TEXT NOT NULL DEFAULT 'month'",
          );
        }
        await customStatement(
          'UPDATE goals SET duration_value = 3 WHERE duration_value IS NULL',
        );
        await customStatement(
          "UPDATE goals SET duration_unit = 'month' WHERE duration_unit IS NULL",
        );
      }
    },
  );
}
