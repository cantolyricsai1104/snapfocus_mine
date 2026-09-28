import 'dart:convert';

import 'package:drift/drift.dart';

import '../domain/goal.dart';
import '../domain/goal_ports.dart';
import '../domain/task.dart';
import 'app_database.dart' hide Goal, Pillar;

class DriftGoalRepository implements GoalRepository {
  DriftGoalRepository(this.database);

  final AppDatabase database;

  @override
  Future<List<Pillar>> listPillars() async =>
      (await database.select(database.pillars).get())
          .map(
            (row) => Pillar(
              id: row.id,
              name: row.name,
              color: row.color,
              emoji: row.emoji,
            ),
          )
          .toList(growable: false);

  @override
  Future<List<Goal>> listGoals() async =>
      (await database.select(database.goals).get())
          .map(
            (row) => Goal(
              id: row.id,
              pillarId: row.pillarId,
              name: row.name,
              metricType: GoalMetricType.values.byName(row.metricType),
              targetValue: row.targetValue,
              currentValue: row.currentValue,
              unit: row.unit,
              taskTitle: row.taskTitle,
              taskWeekdays: (jsonDecode(row.taskWeekdays) as List<dynamic>)
                  .whereType<num>()
                  .map((day) => day.toInt())
                  .toList(growable: false),
              taskDurationMinutes: row.taskDurationMinutes,
              taskTime: row.taskTime,
              durationMonths: row.durationMonths,
              durationWeeks: row.durationWeeks,
              durationValue: row.durationValue,
              durationUnit: GoalDurationUnit.values.byName(row.durationUnit),
              startedOn: row.startedOn,
              taskRepeat: TaskRepeat.values.byName(row.taskRepeat),
              taskMonthDay: row.taskMonthDay,
            ),
          )
          .toList(growable: false);

  @override
  Future<void> replacePillars(List<Pillar> pillars) async {
    await database.transaction(() async {
      await database.delete(database.pillars).go();
      for (final pillar in pillars) {
        await database
            .into(database.pillars)
            .insert(
              PillarsCompanion.insert(
                id: pillar.id,
                name: pillar.name,
                color: pillar.color,
                emoji: pillar.emoji,
              ),
            );
      }
    });
  }

  @override
  Future<void> replaceGoals(List<Goal> goals) async {
    await database.transaction(() async {
      await database.delete(database.goals).go();
      for (final goal in goals) {
        await database
            .into(database.goals)
            .insert(
              GoalsCompanion.insert(
                id: goal.id,
                pillarId: goal.pillarId,
                name: goal.name,
                metricType: 'time',
                targetValue: 0,
                currentValue: Value(goal.currentValue),
                unit: 'minutes',
                taskTitle: Value(goal.taskTitle),
                taskWeekdays: Value(jsonEncode(goal.taskWeekdays)),
                taskDurationMinutes: Value(goal.taskDurationMinutes),
                taskTime: Value(goal.taskTime),
                durationMonths: Value(goal.durationMonths),
                durationWeeks: Value(goal.durationWeeks),
                durationValue: Value(goal.durationValue),
                durationUnit: Value(goal.durationUnit.name),
                startedOn: Value(goal.startedOn),
                taskRepeat: Value(goal.taskRepeat.name),
                taskMonthDay: Value(goal.taskMonthDay),
              ),
            );
      }
    });
  }
}
