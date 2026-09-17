import 'dart:convert';

import 'package:drift/drift.dart';

import '../domain/task.dart';
import '../domain/task_ports.dart';
import 'app_database.dart';

class DriftTaskRepository implements TaskRepository {
  DriftTaskRepository(this.database);

  final AppDatabase database;

  @override
  Future<List<TaskBlock>> list() async {
    final rows = await (database.select(
      database.tasks,
    )..orderBy([(table) => OrderingTerm.asc(table.position)])).get();
    return rows.map(_toTask).toList(growable: false);
  }

  @override
  Future<void> replaceAll(List<TaskBlock> tasks) async {
    await database.transaction(() async {
      await database.delete(database.tasks).go();
      for (var index = 0; index < tasks.length; index++) {
        final task = tasks[index];
        await database
            .into(database.tasks)
            .insert(
              TasksCompanion.insert(
                id: task.id,
                title: task.title,
                durationMinutes: task.durationMinutes,
                type: task.type.name,
                color: task.color,
                scheduledTime: Value(task.scheduledTime),
                date: task.date,
                repeat: task.repeat.name,
                repeatUntil: Value(task.repeatUntil),
                completed: Value(task.completed),
                completedDates: jsonEncode(task.completedDates),
                position: index,
              ),
            );
      }
    });
  }
}

TaskBlock _toTask(Task row) {
  final completedDates = jsonDecode(row.completedDates);
  return TaskBlock(
    id: row.id,
    title: row.title,
    durationMinutes: row.durationMinutes,
    type: TaskType.values.byName(row.type),
    color: row.color,
    scheduledTime: row.scheduledTime,
    date: row.date,
    repeat: TaskRepeat.values.byName(row.repeat),
    repeatUntil: row.repeatUntil,
    completed: row.completed,
    completedDates: completedDates is List
        ? completedDates.whereType<String>().toList(growable: false)
        : const [],
  );
}
