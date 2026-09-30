import 'task.dart';

enum GoalMetricType { numeric, time, days }

enum GoalDurationUnit {
  day('day'),
  week('week'),
  month('month');

  const GoalDurationUnit(this.label);
  final String label;
}

class Pillar {
  const Pillar({
    required this.id,
    required this.name,
    required this.color,
    required this.emoji,
  });

  final String id;
  final String name;
  final String color;
  final String emoji;

  Pillar copyWith({String? name, String? color, String? emoji}) => Pillar(
    id: id,
    name: name ?? this.name,
    color: color ?? this.color,
    emoji: emoji ?? this.emoji,
  );
}

class Goal {
  const Goal({
    required this.id,
    required this.pillarId,
    required this.name,
    required this.metricType,
    required this.targetValue,
    required this.currentValue,
    required this.unit,
    this.durationMonths = 3,
    this.durationWeeks = 0,
    this.durationValue = 3,
    this.durationUnit = GoalDurationUnit.month,
    this.startedOn,
    this.taskTitle,
    this.taskWeekdays = const [],
    this.taskDurationMinutes = 25,
    this.taskTime,
    this.taskPriority = 1,
    this.taskCountTarget,
    this.taskCountUnit,
    this.taskRepeat = TaskRepeat.weekly,
    this.taskMonthDay = 1,
  });

  final String id;
  final String pillarId;
  final String name;
  final GoalMetricType metricType;
  final double targetValue;
  final double currentValue;
  final String unit;
  final int durationMonths;
  final int durationWeeks;
  final int durationValue;
  final GoalDurationUnit durationUnit;
  final String? startedOn;
  final String? taskTitle;
  final List<int> taskWeekdays;
  final int taskDurationMinutes;
  final String? taskTime;

  /// Priority inherited by the recurring task generated for this goal.
  final int taskPriority;
  final int? taskCountTarget;
  final String? taskCountUnit;
  final TaskRepeat taskRepeat;
  final int taskMonthDay;

  DateTime? get endDate {
    if (startedOn == null || durationValue <= 0) {
      return null;
    }
    final start = DateTime.parse(startedOn!);
    return switch (durationUnit) {
      GoalDurationUnit.day => start.add(Duration(days: durationValue)),
      GoalDurationUnit.week => start.add(Duration(days: durationValue * 7)),
      GoalDurationUnit.month => _addMonths(start, durationValue),
    };
  }

  double get progress {
    final end = endDate;
    if (end == null || startedOn == null || taskTitle == null) return 0;
    final start = DateTime.parse(startedOn!);
    final lastDate = DateTime(end.year, end.month, end.day);
    final schedule = TaskBlock(
      id: 'goal-progress-$id',
      title: taskTitle!,
      durationMinutes: taskDurationMinutes,
      type: TaskType.focus,
      color: '#000000',
      scheduledTime: taskTime ?? '09:00',
      date: startedOn!,
      repeat: taskRepeat,
      repeatUntil: _dateKey(lastDate),
      goalId: id,
      repeatDays: taskWeekdays,
      repeatMonthDay: taskMonthDay,
    );
    var plannedMinutes = 0;
    var plannedDays = 0;
    for (
      var day = DateTime(start.year, start.month, start.day);
      !day.isAfter(lastDate);
      day = day.add(const Duration(days: 1))
    ) {
      if (schedule.isScheduledOn(_dateKey(day))) {
        plannedMinutes += taskDurationMinutes;
        plannedDays++;
      }
    }
    final planned = metricType == GoalMetricType.days
        ? plannedDays
        : plannedMinutes;
    if (planned <= 0) return 0;
    return (currentValue / planned).clamp(0.0, 1.0).toDouble();
  }

  bool get achieved => progress >= 1;
  bool get expired {
    final end = endDate;
    if (end == null) return false;
    final today = DateTime.now();
    return DateTime(
      today.year,
      today.month,
      today.day,
    ).isAfter(DateTime(end.year, end.month, end.day));
  }

  Goal copyWith({
    String? id,
    String? pillarId,
    String? name,
    GoalMetricType? metricType,
    double? targetValue,
    double? currentValue,
    String? unit,
    int? durationMonths,
    int? durationWeeks,
    int? durationValue,
    GoalDurationUnit? durationUnit,
    Object? startedOn = _unset,
    Object? taskTitle = _unset,
    List<int>? taskWeekdays,
    int? taskDurationMinutes,
    Object? taskTime = _unset,
    int? taskPriority,
    Object? taskCountTarget = _unset,
    Object? taskCountUnit = _unset,
    TaskRepeat? taskRepeat,
    int? taskMonthDay,
  }) => Goal(
    id: id ?? this.id,
    pillarId: pillarId ?? this.pillarId,
    name: name ?? this.name,
    metricType: metricType ?? this.metricType,
    targetValue: targetValue ?? this.targetValue,
    currentValue: currentValue ?? this.currentValue,
    unit: unit ?? this.unit,
    durationMonths: durationMonths ?? this.durationMonths,
    durationWeeks: durationWeeks ?? this.durationWeeks,
    durationValue: durationValue ?? this.durationValue,
    durationUnit: durationUnit ?? this.durationUnit,
    startedOn: identical(startedOn, _unset)
        ? this.startedOn
        : startedOn as String?,
    taskTitle: identical(taskTitle, _unset)
        ? this.taskTitle
        : taskTitle as String?,
    taskWeekdays: taskWeekdays ?? this.taskWeekdays,
    taskDurationMinutes: taskDurationMinutes ?? this.taskDurationMinutes,
    taskTime: identical(taskTime, _unset) ? this.taskTime : taskTime as String?,
    taskPriority: taskPriority ?? this.taskPriority,
    taskCountTarget: identical(taskCountTarget, _unset)
        ? this.taskCountTarget
        : taskCountTarget as int?,
    taskCountUnit: identical(taskCountUnit, _unset)
        ? this.taskCountUnit
        : taskCountUnit as String?,
    taskRepeat: taskRepeat ?? this.taskRepeat,
    taskMonthDay: taskMonthDay ?? this.taskMonthDay,
  );
}

String _dateKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

DateTime _addMonths(DateTime date, int months) {
  final monthIndex = date.month - 1 + months;
  final year = date.year + monthIndex ~/ 12;
  final month = monthIndex % 12 + 1;
  final lastDay = DateTime(year, month + 1, 0).day;
  return DateTime(year, month, date.day.clamp(1, lastDay));
}

const Object _unset = Object();
