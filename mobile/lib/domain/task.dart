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
        return _date(date).weekday == _date(dateString).weekday;
      case TaskRepeat.monthly:
        return int.parse(date.substring(8, 10)) ==
            int.parse(dateString.substring(8, 10));
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
        _listEquals(other.completedDates, completedDates);
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
  );
}

const Object _unset = Object();

DateTime _date(String value) => DateTime.parse('${value}T00:00:00');

bool _listEquals(List<String> first, List<String> second) {
  if (first.length != second.length) return false;
  for (var index = 0; index < first.length; index++) {
    if (first[index] != second[index]) return false;
  }
  return true;
}
