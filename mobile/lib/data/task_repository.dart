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
                priority: Value(task.priority),
                reminderMinutesBefore: Value(task.reminderMinutesBefore),
                countTarget: Value(task.countTarget),
                countUnit: Value(task.countUnit),
                countByDate: Value(jsonEncode(task.countByDate)),
                repeatUntil: Value(task.repeatUntil),
                completed: Value(task.completed),
                completedDates: jsonEncode(task.completedDates),
                position: index,
                goalId: Value(task.goalId),
                repeatDays: Value(jsonEncode(task.repeatDays)),
                repeatMonthDay: Value(task.repeatMonthDay),
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
    priority: row.priority,
    reminderMinutesBefore: row.reminderMinutesBefore,
    countTarget: row.countTarget,
    countUnit: row.countUnit,
    countByDate: (jsonDecode(row.countByDate) as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, (value as num).toInt()),
    ),
    repeatUntil: row.repeatUntil,
    completed: row.completed,
    completedDates: completedDates is List
        ? completedDates.whereType<String>().toList(growable: false)
        : const [],
    goalId: row.goalId,
    repeatDays: (jsonDecode(row.repeatDays) as List<dynamic>)
        .whereType<num>()
        .map((day) => day.toInt())
        .toList(growable: false),
    repeatMonthDay: row.repeatMonthDay,
  );
}
