import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/goal.dart';
import 'package:mobile/domain/task.dart';

void main() {
  test('goal progress is zero until focus time is recorded', () {
    final goal = _dailyGoal(currentMinutes: 0);

    expect(goal.progress, 0);
    expect(goal.achieved, isFalse);
  });

  test('goal progress compares focus minutes to scheduled minutes', () {
    expect(_dailyGoal(currentMinutes: 25).progress, 0.5);
    expect(_dailyGoal(currentMinutes: 50).progress, 1);
    expect(_dailyGoal(currentMinutes: 50).achieved, isTrue);
  });

  test('goal progress can count completed days instead of minutes', () {
    expect(
      _dailyGoal(currentMinutes: 2, metricType: GoalMetricType.days).progress,
      1,
    );
    expect(
      _dailyGoal(currentMinutes: 2, metricType: GoalMetricType.days).achieved,
      isTrue,
    );
  });
}

Goal _dailyGoal({
  required double currentMinutes,
  GoalMetricType metricType = GoalMetricType.time,
}) {
  final now = DateTime.now();
  final today =
      '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  return Goal(
    id: 'daily-goal',
    pillarId: 'health',
    name: 'Focus',
    metricType: metricType,
    targetValue: 0,
    currentValue: currentMinutes,
    unit: metricType == GoalMetricType.days ? 'days' : 'minutes',
    durationValue: 1,
    durationUnit: GoalDurationUnit.day,
    startedOn: today,
    taskTitle: 'Focus session',
    taskDurationMinutes: 25,
    taskRepeat: TaskRepeat.daily,
  );
}
