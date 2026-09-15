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

@DriftDatabase(tables: [ActiveRoutines, Snapshots])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'snapfocus'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(snapshots);
      }
    },
  );
}
