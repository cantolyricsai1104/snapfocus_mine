enum RoutinePhase { focus, breakTime }

enum RoutineStatus { idle, running, paused, locked, completed, stopped }

const Object _unset = Object();

class RoutineState {
  const RoutineState({
    required this.id,
    required this.phase,
    required this.status,
    required this.focusDuration,
    required this.breakDuration,
    required this.startedAt,
    required this.endsAt,
    required this.pausedRemaining,
    required this.progress,
  });

  final String id;
  final RoutinePhase phase;
  final RoutineStatus status;
  final Duration focusDuration;
  final Duration breakDuration;
  final DateTime? startedAt;
  final DateTime? endsAt;
  final Duration? pausedRemaining;
  final double progress;

  RoutineState copyWith({
    RoutinePhase? phase,
    RoutineStatus? status,
    Duration? focusDuration,
    Duration? breakDuration,
    DateTime? startedAt,
    Object? endsAt = _unset,
    Object? pausedRemaining = _unset,
    double? progress,
  }) {
    return RoutineState(
      id: id,
      phase: phase ?? this.phase,
      status: status ?? this.status,
      focusDuration: focusDuration ?? this.focusDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      startedAt: startedAt ?? this.startedAt,
      endsAt: identical(endsAt, _unset) ? this.endsAt : endsAt as DateTime?,
      pausedRemaining: identical(pausedRemaining, _unset)
          ? this.pausedRemaining
          : pausedRemaining as Duration?,
      progress: progress ?? this.progress,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RoutineState &&
        other.id == id &&
        other.phase == phase &&
        other.status == status &&
        other.focusDuration == focusDuration &&
        other.breakDuration == breakDuration &&
        other.startedAt == startedAt &&
        other.endsAt == endsAt &&
        other.pausedRemaining == pausedRemaining &&
        other.progress == progress;
  }

  @override
  int get hashCode => Object.hash(
    id,
    phase,
    status,
    focusDuration,
    breakDuration,
    startedAt,
    endsAt,
    pausedRemaining,
    progress,
  );
}
