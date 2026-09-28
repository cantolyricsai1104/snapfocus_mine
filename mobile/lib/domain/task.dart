enum TaskType { focus, breakTime }

enum TaskRepeat { none, daily, weekly, monthly }

class TaskBlock {
  const TaskBlock({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.type,
    required this.color,
    required this.scheduledTime,
    required this.date,
    required this.repeat,
    this.repeatUntil,
    this.completed = false,
    this.completedDates = const [],
    this.goalId,
    this.repeatDays = const [],
    this.repeatMonthDay,
  });

  final String id;
  final String title;
  final int durationMinutes;
  final TaskType type;
  final String color;
  final String? scheduledTime;
  final String date;
  final TaskRepeat repeat;
  final String? repeatUntil;
  final bool completed;
  final List<String> completedDates;
  final String? goalId;
  final List<int> repeatDays;
  final int? repeatMonthDay;

  TaskBlock copyWith({
    String? title,
    int? durationMinutes,
    TaskType? type,
    String? color,
    Object? scheduledTime = _unset,
    String? date,
    TaskRepeat? repeat,
    Object? repeatUntil = _unset,
    bool? completed,
    List<String>? completedDates,
    Object? goalId = _unset,
    List<int>? repeatDays,
    Object? repeatMonthDay = _unset,
  }) {
    return TaskBlock(
      id: id,
      title: title ?? this.title,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      type: type ?? this.type,
      color: color ?? this.color,
      scheduledTime: identical(scheduledTime, _unset)
          ? this.scheduledTime
          : scheduledTime as String?,
      date: date ?? this.date,
      repeat: repeat ?? this.repeat,
      repeatUntil: identical(repeatUntil, _unset)
          ? this.repeatUntil
          : repeatUntil as String?,
      completed: completed ?? this.completed,
      completedDates: completedDates ?? this.completedDates,
      goalId: identical(goalId, _unset) ? this.goalId : goalId as String?,
      repeatDays: repeatDays ?? this.repeatDays,
      repeatMonthDay: identical(repeatMonthDay, _unset)
          ? this.repeatMonthDay
          : repeatMonthDay as int?,
    );
  }

  bool isScheduledOn(String dateString) {
    if (dateString.compareTo(date) < 0) return false;
    if (repeatUntil != null && dateString.compareTo(repeatUntil!) > 0) {
      return false;
    }
    switch (repeat) {
      case TaskRepeat.none:
        return dateString == date;
      case TaskRepeat.daily:
        return true;
      case TaskRepeat.weekly:
        return repeatDays.isEmpty
            ? _date(date).weekday == _date(dateString).weekday
            : repeatDays.contains(_date(dateString).weekday);
      case TaskRepeat.monthly:
        final scheduledDay = repeatMonthDay ?? _date(date).day;
        final monthEnd = DateTime(
          _date(dateString).year,
          _date(dateString).month + 1,
          0,
        ).day;
        return _date(dateString).day ==
            (scheduledDay > monthEnd ? monthEnd : scheduledDay);
    }
  }

  bool isCompletedOn(String dateString) {
    if (completedDates.contains(dateString)) return true;
    return repeat == TaskRepeat.none && completed;
  }

  @override
  bool operator ==(Object other) {
    return other is TaskBlock &&
        other.id == id &&
        other.title == title &&
        other.durationMinutes == durationMinutes &&
        other.type == type &&
        other.color == color &&
        other.scheduledTime == scheduledTime &&
        other.date == date &&
        other.repeat == repeat &&
        other.repeatUntil == repeatUntil &&
        other.completed == completed &&
        _listEquals(other.completedDates, completedDates) &&
        other.goalId == goalId &&
        _intListEquals(other.repeatDays, repeatDays) &&
        other.repeatMonthDay == repeatMonthDay;
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    durationMinutes,
    type,
    color,
    scheduledTime,
    date,
    repeat,
    repeatUntil,
    completed,
    Object.hashAll(completedDates),
    goalId,
    Object.hashAll(repeatDays),
    repeatMonthDay,
  );
}

class BreakSuggestion {
  const BreakSuggestion({
    required this.after,
    required this.next,
    required this.durationMinutes,
  });

  final TaskBlock after;
  final TaskBlock next;
  final int durationMinutes;

  String get key => '${after.id}:${next.id}';

  String get startTime {
    final start = _minutes(after.scheduledTime!);
    return _formatTime(start + after.durationMinutes);
  }
}

BreakSuggestion? suggestBreak(List<TaskBlock> tasks, String date) {
  final scheduled =
      tasks
          .where(
            (task) => task.isScheduledOn(date) && task.scheduledTime != null,
          )
          .toList()
        ..sort(
          (a, b) =>
              _minutes(a.scheduledTime!).compareTo(_minutes(b.scheduledTime!)),
        );

  for (var index = 0; index < scheduled.length - 1; index++) {
    final current = scheduled[index];
    final next = scheduled[index + 1];
    if (current.type != TaskType.focus || next.type != TaskType.focus) continue;

    final currentEnd =
        _minutes(current.scheduledTime!) + current.durationMinutes;
    final nextStart = _minutes(next.scheduledTime!);
    final gap = nextStart - currentEnd;
    if (gap < 0 || gap > 60) continue;

    final duration = current.durationMinutes >= 60
        ? 15
        : current.durationMinutes >= 25
        ? 10
        : 5;
    if (gap >= duration) continue;
    return BreakSuggestion(
      after: current,
      next: next,
      durationMinutes: duration,
    );
  }
  return null;
}

const Object _unset = Object();

int _minutes(String time) {
  final parts = time.split(':').map(int.parse).toList();
  return parts[0] * 60 + parts[1];
}

String _formatTime(int minutes) =>
    '${(minutes ~/ 60).toString().padLeft(2, '0')}:${(minutes % 60).toString().padLeft(2, '0')}';

DateTime _date(String value) => DateTime.parse('${value}T00:00:00');

bool _listEquals(List<String> first, List<String> second) {
  if (first.length != second.length) return false;
  for (var index = 0; index < first.length; index++) {
    if (first[index] != second[index]) return false;
  }
  return true;
}

bool _intListEquals(List<int> first, List<int> second) {
  if (first.length != second.length) return false;
  for (var index = 0; index < first.length; index++) {
    if (first[index] != second[index]) return false;
  }
  return true;
}
